Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbeHaACp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 20:02:45 -0400
Date: Thu, 30 Aug 2018 15:58:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830195851.GB35751@bfoster>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
 <20180830182849.GA4359@magnolia>
 <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
 <20180830193919.GA35751@bfoster>
 <3d6029ec-0afe-e90e-d608-e1c627c0818f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d6029ec-0afe-e90e-d608-e1c627c0818f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 02:47:09PM -0500, Eric Sandeen wrote:
> On 8/30/18 2:39 PM, Brian Foster wrote:
> >>> Frankly I think FIBMAP comes verrry
> >>> close to "this API is unfixably stupid and shouldn't be enabled for new
> >>> use cases and should go away some day".
> 
> Backing up, the interface isn't /that/ dumb, other than being limited to
> 32 bits.  Q: "Where is this logical file block physically located?"  A: "It is here."
> 
> Inefficient, sure.
> 
> >> So instead if anyone asks we'll just give them a successful response which
> >> is indistinguishable from a hole.  :(
> >>
> > ... but this seems to be the crux of the matter (IMO, at least). If we
> > can return -ENOTSUPP or whatever, then it can be made obvious that the
> > user either needs to use fiemap or avoid using reflinked files. ISTM
> > that what we do now is essentially report an incorrect bmap, which leads
> > to these subtle bug reports.
> > 
> > I haven't dug into the fibmap code.. does something prevent returning a
> > legitimate error code?
> 
> so ->bmap() returns a sector_t, which is a u64 and doesn't really
> leave room for a negative error return.  But the ioctl interface 
> stuffs that return into an int, and returns it to the user.
> (note to self, wonder why it doesn't return -EOVERFLOW as needed).
> 

Ah, so the syscall can return an error, but the internal interface
basically doesn't support error propagation from the fs callback.

> I suppose ->bmap() could be changed to take a u64 in/out pointer like the
> user interface does, and return 0 or -errno.  *Shrug* this seems like
> a lot of work to avoid simply giving the user what they asked
> for.  ;)
> 

FWIW, another option might be to drop the ->bmap() callback on reflinked
inodes, which looks like it would trigger an -EINVAL to userspace. I
also don't know if that is worth whatever trouble might be required to
change function pointers like that, if it can even be done safely. I
guess my take boils down to that I think either returning an error (one
way or another) or accurate block map info is more sane than the current
behavior.

Brian

> -Eric
