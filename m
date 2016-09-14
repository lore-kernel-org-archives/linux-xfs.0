Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5EC67CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 16:51:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 788098F8050
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 14:51:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	iWHDdHjiAF2lGYHR for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 14:50:54 -0700 (PDT)
Date: Thu, 15 Sep 2016 07:50:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: automatically fix up AGFL size issues
Message-ID: <20160914215051.GO30497@dastard>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-5-git-send-email-david@fromorbit.com>
	<20160914182044.GG9314@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160914182044.GG9314@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 14, 2016 at 11:20:44AM -0700, Darrick J. Wong wrote:
> On Fri, Sep 02, 2016 at 12:27:35PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> I've been wondering whether we need to take the extra step of clearing
> that last slot in the AGFL.  Prior to 4.5, 32-bit kernels thought
> XFS_AGFL_SIZE was 119 (4k blocks, 512b sectors) and 64-bit kernels
> thought it was 118.  Since then, both 32b and 64b think it's 119; with
> this patchset we're making it 118 everywhere.  My initial fear was that
> the following could happen:
> 
> 1. Mount with an agfl-119 kernel, beat on the fs until the agfl wraps
> around the end.  The last agfl pointer is set to something.
> 
> 2. Remount with a patched agfl-118 kernel that makes this correction.
> The last agfl pointer remains set to whatever.  Exercise the fs until
> the agfl active list wraps around again.
> 
> 3. Remount with the old agfl-119 kernel.  It is now working with flcount
> values that don't add up in its worldview, but will it notice?  In any
> case, it will end up using that last agfl pointer.  Can we guarantee
> that block is not owned by something else?

Yes, because we left it on the free list and simply adjusted the
pointers to skip it. Hence if the corrected fs is then mounted again
on an older kernel while there is a AGFL wrap condition on disk, it
will pull the block from the AGFL and it's OK because it's still a
free block that isn't present in the ABTB/ABTC.

> I /think/ the answer to #2 is that a block only ends up on the AGFL
> after it's been removed from the freespace btrees, so the block pointed
> to in that last slot is still free and in fact can be used.

Correct.

> Therefore,
> the patch is correct and we don't need to write NULLAGBLOCK to the that
> last AGFL slot that we're never going to use again, and I'm worrying
> about nothing.

Well, there is still a worry here - mkfs will mark the entry as
NULLAGBLOCK, so if we take a filesystem like that with a wrapped
AGFL the older kernel will barf on a NULLAGBLOCK being allocated
from the AGFL. Nothing we can do about that, though, except to say
"run xfs_repair and all will be good again".

> xfs_repair writes 0xFF to the entire sector, rebuilds the freesp btrees,
> and moves the agfl to the start of the sector, so we're covered for that
> case.

Exactly.

> As for the question of whether or not an old kernel will notice flcount
> not fitting its world view w.r.t. fllast - flfirst + 1, I don't know if
> old kernels will notice; the current verifiers don't seem to check.

They don't.

> If we wanted to be really heavy handed I suppose we could set that last
> slot to sb_agblocks to stop all the agfl-119 kernels dead in their
> tracks, but I don't know that's necessary.

It still doesn't help us for the case that an existing mkfs is
usedi, an existing 4.8 kernel is used and then we wrap and then take
the fs back to an older kernel...

Still, after seeing the "make the fs on distro/kernel X; mount and
grow the fs to production size on different kernel Y; run production
on different kernel Z" container deployment infrastructure that
exposed the problem, I'd suggest that that are still some people we
cannot fix this problem for because their deployment system is
so convoluted that there's nothing we can do to avoid such problems
randomly occurring...

FWIW, this crazy deployment process is one of the reasons I didn't
make this a transactional correction. i.e. It won't make it to disk
unless there's a subsequent allocation/free done in the AG. THis
means mounting on a newer kernel will warn and correct in memory,
but won't modify on disk until it absolutely has to. Hence the
grwofs phase won't modify wrapped AGFLs on disk, and so shouldn't
cause problems for older kernels in this specific case.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
