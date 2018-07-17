Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56868 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729717AbeGQRrX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 13:47:23 -0400
Date: Tue, 17 Jul 2018 10:13:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180717171328.GS32415@magnolia>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180713164153.GM32415@magnolia>
 <20180713234341.GX19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713234341.GX19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On Sat, Jul 14, 2018 at 09:43:41AM +1000, Dave Chinner wrote:
> On Fri, Jul 13, 2018 at 09:41:53AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 13, 2018 at 08:10:03AM -0500, Bill O'Donnell wrote:
> > > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > > Add sanity checks for these parameters.
> > > 
> > > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 350119eeaecb..cdede769ab88 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -261,7 +261,9 @@ xfs_mount_validate_sb(
> > >  	    sbp->sb_dblocks == 0					||
> > >  	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
> > >  	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp)			||
> > > -	    sbp->sb_shared_vn != 0)) {
> > > +	    sbp->sb_shared_vn != 0					||
> > > +	    sbp->sb_fdblocks > sbp->sb_dblocks				||
> > > +	    sbp->sb_ifree > sbp->sb_icount)) {
> > 
> > Hmm.  On its face this seems reasonable for the superblock verifier, but
> > then I started wondering, since these are /summary/ counters.
> > 
> > If the free counts are off by this much, the admin won't be able to
> > mount the fs, and xfs_repair is the only other tool that can fix the
> > summary counts.  However, if the log is dirty, the mount won't succeed
> > to recover the fs, which is too bad since we can reinitialize the
> > summary counts after log recovery.  xfs_repair -L will be the only way
> > out, which will wreak havoc on the filesystem from discarding the log
> > contents.
> 
> Yup, that's why I said "catch this on /write/", not "always reject
> bad counter values".
> 
> i.e. we should never be writing a bad value, but we most definitely
> need to be able to mount the filesystem to reconstruct them.
> 
> > So, would it be preferable to split this into two parts?  For example,
> > have this as a corruption check in _sb_write_verify to prevent us from
> > writing out garbage counters
> 
> yes.
> 
> > and a clamp in _reinit_percpu_counters so
> > that we never present ridiculous free counts to users?
> 
> percpu_counter_{read,sum}_positive() should be used for anything that is
> userspace facing. xfs_fs_counts() gets this right, but
> xfs_fs_statfs() doesn't - it should use
> percpu_counter_sum_positive().

I don't think that will solve this problem -- although sb_fdblocks is
larger than sb_dblocks, sd_fdblocks is not so insanely large that
percpu_counter_{read,sum} return negative values; returning to Eric's
analysis of the original complaint:

> sb_fdblocks 4461713825, counted 166746529
>         - found root inode chunk
> 
> that sb_fdblocks really is ~17T which indicates the problem
> really is on disk.
> 
> 4461713825
> 100001001111100000101100110100001

  ^-- bit 32 of a signed 64-bit quantity

> 166746529
>      1001111100000101100110100001

So we still need a separate sb_fdblocks <= sb_dblocks clamp and/or
forced recalculation somewhere.

I agree that _fs_statfs should only return positive free blocks to avoid
reporting total garbage to userspace, but that's not the problme here.
I'll toss that onto my pile for 4.19 stuff.

> > (Does any of this make sense with !haslazysbcount filesystems?)
> 
> Same thing - we can't verify the counters on read until after log
> recovery as all the changes are journalled.
> 
> > Bonus question: What about checking frextents/rextents?
> 
> Same as !lazycount - all changes are journalled.

Ok.

--D

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
