Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43776 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932108AbeCIWKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Mar 2018 17:10:48 -0500
Date: Sat, 10 Mar 2018 09:10:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: convert between packed and unpacked agfls
 on-demand
Message-ID: <20180309221045.GU18129@dastard>
References: <20180307192451.24196-1-bfoster@redhat.com>
 <20180308140354.pk25gd54cqjzbecs@odin.usersys.redhat.com>
 <20180309131628.GA3445@bfoster.bfoster>
 <20180309173318.GD18989@magnolia>
 <20180309183727.GA17046@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180309183727.GA17046@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Mar 09, 2018 at 01:37:28PM -0500, Brian Foster wrote:
> On Fri, Mar 09, 2018 at 09:33:18AM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 09, 2018 at 08:16:28AM -0500, Brian Foster wrote:
> > > On Thu, Mar 08, 2018 at 03:03:54PM +0100, Carlos Maiolino wrote:
> > > > Hi,
> > > > 
> > > > On Wed, Mar 07, 2018 at 02:24:51PM -0500, Brian Foster wrote:
> > > > > Disliked-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > > 
> > > > > Sent as RFC for the time being. This tests Ok on a straight xfstests run
> > > > > and also seems to pass Darrick's agfl fixup tester (thanks) both on
> > > > > upstream and on a rhel7 kernel with some minor supporting hacks.
> > > > > 
> > > > > I tried to tighten up the logic a bit to reduce the odds of mistaking
> > > > > actual corruption for a padding mismatch as much as possible. E.g.,
> > > > > limit to cases where the agfl is wrapped, make sure we don't mistake a
> > > > > corruption that looks like an agfl with 120 entries on a packed kernel,
> > > > > etc.
> > > > > 
> > > > > While I do prefer an on-demand fixup approach to a mount time scan, ISTM
> > > > > that in either case it's impossible to completely eliminate the risk of
> > > > > confusing corruption with a padding mismatch so long as we're doing a
> > > > > manual agfl fixup. The more I think about that the more I really dislike
> > > > > doing this. :(
> > > > > 
> > > > > After some IRC discussion with djwong and sandeen, I'm wondering if the
> > > > > existence of 'xfs_repair -d' is a good enough last resort for those
> > > > > users who might be bit by unexpected padding issues on a typical
> > > > > upgrade. If so, we could fall back to a safer mount-time detection model
> > > > > that enforces a read-only mount and let the user run repair. The
> > > > > supposition is that those who aren't prepared to repair via a ramdisk or
> > > > > whatever should be able to 'xfs_repair -d' a rootfs that is mounted
> > > > > read-only provided agfl padding is the only inconsistency. 
> > > > > 
> > > > > Eric points out that we can still write an unmount record for a
> > > > > read-only mount, but I'm not sure that would be a problem if repair only
> > > > > needs to fix the agfl. xfs_repair shouldn't touch the log unless there's
> > > > > a recovery issue or it needs to be reformatted to update the LSN, both
> > > > > of which seem to qualify as "you have more problems than agfl padding
> > > > > and need to run repair anyways" to me. Thoughts?
> > > > > 
> > > > 
> > > > Sorry if this may sound stupid, but in the possibility this can help the issue,
> > > > or at least me learning something new.
> > > > 
> > > > ISTM this issue is all related to the way xfs_agfl packing. I read the commit
> > > > log where packed attribute was added to xfs_agfl, and I was wondering...
> > > > 
> > > > What are the implications of breaking up the lsn field in xfs_agfl, in 2 __be32?
> > > > Merge it together in a 64bit field when reading it from disk, or split it when
> > > > writing to?
> > > > It seems to me this would avoid the size difference we are seeing now in 32/64
> > > > bit systems, and avoid such risk of confusion when trying to discern between a
> > > > corrupted agfl and a padding mismatch.
> > > > 
> > > 
> > > I'm not following how you'd accomplish the latter..? We already have the
> > > packed attribute in place, so the padding is fixed with that. This
> > > effort has to do with trying to fix up an agfl written by an older
> > > kernel without the padding fix. My understanding is that the xfs_agfl
> > > header looks exactly the same on-disk in either case, the issue is a
> > > broken size calculation that causes the older kernel to not see/use one
> > > last slot in the agfl. If the agfl has wrapped and a newer kernel loads
> > > the same on-disk structure, it has no means to know whether the content
> > > of the final slot is a valid block or a "gap" left by an older kernel
> > > other than to check whether flcount matches the active count from
> > > flfirst -> fllast (and that's where potential confusion over a padding
> > > issue vs other corruption comes into play).
> > 
> > Your understanding is correct.
> > 
> > Sez me, who is watching the fsck.xfs -f discussion just in case that can
> > be turned into a viable option quickly.
> > 
> 
> Thanks.
> 
> > ..and wondering what if we /did/ just implement Dave's suggestion from
> > years ago where if the flcount doesn't match we just reset the agfl and
> > call fix_freelist to refill it with fresh blocks... it would suck to
> > leak blocks, though.  Obviously, if the fs has rmap enabled then we can
> > just rebuild it on the spot via xfs_repair_agfl() (see patch on mailing
> > list).
> > 
> 
> I wasn't initially too fond of this idea, but thinking about it a bit
> more, there is definitely some value in terms of determinism. We know
> we'll just leak some blocks vs. riskily swizzling around a corrupted
> agfl.

And, most importantly: it's trivial to backport to other kernels.
The we simply don't have to worry where the filesystem has been
mounted - if we detect a suspect situation for the running kernel,
we just let go of the free list and rebuild it.

> Given that, perhaps an on-demand reset with a "Corrupted AGFL, tossed
> $flcount blocks, unmount and run xfs_repair if you ever want to see them
> again" warning might not be so bad. It works the same whether the kernel
> is packed, unpacked or the agfl is just borked, and therefore the test
> matrix is much simpler as well. Hmmmm...

Yup, exactly my thoughts. The more I read about the hoops we're
considering jumping through to work around this problem, the more I
like this solution....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
