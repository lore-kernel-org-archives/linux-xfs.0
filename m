Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:15016 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731231AbeG0AhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 20:37:00 -0400
Date: Fri, 27 Jul 2018 09:17:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfs: completely disable toggling DAX flag via ioctl
 on reg files
Message-ID: <20180726231754.GB2234@dastard>
References: <405e182f-0c24-81fe-9d04-1031a8bbac17@redhat.com>
 <20180726120854.GA16980@bfoster>
 <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892f27ac-f985-bf8f-1cc9-bc0a996136f7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>

On Thu, Jul 26, 2018 at 06:23:58AM -0700, Eric Sandeen wrote:
> On 7/26/18 5:08 AM, Brian Foster wrote:
> > On Wed, Jul 25, 2018 at 02:20:54PM -0700, Eric Sandeen wrote:
> >> 742d842 xfs: disable per-inode DAX flag was, I think, intended
> >> as a short-term workaround to avoid races when toggling DAX on
> >> and off of active inodes until mm/ sorted that out.
> >>
> >> (It's also a confusing title, as it didn't really disable
> >> per-inode DAX at all.)
> >>
> >> However, it has the surprising (to me, at least) result that while
> >> the ioctl succeeds, no behavior changes until the inode is cycled
> >> out of cache and re-read from disk at some unknown later time.
> >> This seems to badly violate the principle of least surprise.
> >>
> >> Until said races are properly resolved, it seems most prudent to
> >> disallow modification of the flag on regular files altogether.
> >> We can still allow per-inode DAX flagging via directory inheritance.
> >>
> >> Since DAX is still flagged as experimental (in part due to these
> >> concerns) I don't think it's a problem to (temporarily?) break
> >> this interface further.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> > 
> > I'm not in tune with the latest state of dax, but if the situation is
> > that we don't currently have a means to correctly switch the per-inode
> > state for an active inode (and thus have simply skipped changing the
> > online flag while carrying on with the on-disk flag, leading to this
> > inode cache cycling requirement), then I think this makes sense. The
> > current interface is essentially incomplete, I don't see any reason to
> > allow unless/until it actually works sanely.
> > 
> > BTW, what bits are actually missing to make that happen? Why is the
> > flush/inval currently in this function not sufficient?
> 
> TBH I don't actually know the low-level details. :/

page faults aren't synchronised with filesystem locks, so we can
change the aops callout behaviour half way through a page fault.
i.e. the first half of the page fault sees the S_DAX flag and does
prep work based on that, the second half of the page fault doesn't
see the S_DAX flag and assumes it's working on a page cache page
that doesn't exist and things go bang...

As it is, I don't think we can remove this now - people are using
the on-disk flags already, and the inherit flag from the directory
has none of the problems of changing S_DAX dynamically. Hence just
disabling it is the wrong thing to do because it removes the ability
for people to manage the flags that are already on disk....

I'd much prefer we fix the page fault synchronisation problem than
break stuff that /isn't actually broken/. Yes, it's current
behaviour is suboptimal, but that is only supposed to be /temporary/
until the aops callout problem is fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
