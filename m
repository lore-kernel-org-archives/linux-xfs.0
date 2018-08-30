Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbeH3Xu4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 19:50:56 -0400
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster> <20180830182849.GA4359@magnolia>
 <10d35380-6f5f-22a5-7b6a-1cfb60c53cfd@sandeen.net>
 <20180830193919.GA35751@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3d6029ec-0afe-e90e-d608-e1c627c0818f@sandeen.net>
Date: Thu, 30 Aug 2018 14:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180830193919.GA35751@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 8/30/18 2:39 PM, Brian Foster wrote:
>>> Frankly I think FIBMAP comes verrry
>>> close to "this API is unfixably stupid and shouldn't be enabled for new
>>> use cases and should go away some day".

Backing up, the interface isn't /that/ dumb, other than being limited to
32 bits.  Q: "Where is this logical file block physically located?"  A: "It is here."

Inefficient, sure.

>> So instead if anyone asks we'll just give them a successful response which
>> is indistinguishable from a hole.  :(
>>
> ... but this seems to be the crux of the matter (IMO, at least). If we
> can return -ENOTSUPP or whatever, then it can be made obvious that the
> user either needs to use fiemap or avoid using reflinked files. ISTM
> that what we do now is essentially report an incorrect bmap, which leads
> to these subtle bug reports.
> 
> I haven't dug into the fibmap code.. does something prevent returning a
> legitimate error code?

so ->bmap() returns a sector_t, which is a u64 and doesn't really
leave room for a negative error return.  But the ioctl interface 
stuffs that return into an int, and returns it to the user.
(note to self, wonder why it doesn't return -EOVERFLOW as needed).

I suppose ->bmap() could be changed to take a u64 in/out pointer like the
user interface does, and return 0 or -errno.  *Shrug* this seems like
a lot of work to avoid simply giving the user what they asked
for.  ;)

-Eric
