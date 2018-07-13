Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16371 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729762AbeGNAAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 20:00:36 -0400
Date: Sat, 14 Jul 2018 09:43:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180713234341.GX19934@dastard>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180713164153.GM32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713164153.GM32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jul 13, 2018 at 09:41:53AM -0700, Darrick J. Wong wrote:
> On Fri, Jul 13, 2018 at 08:10:03AM -0500, Bill O'Donnell wrote:
> > Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> > Add sanity checks for these parameters.
> > 
> > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_sb.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 350119eeaecb..cdede769ab88 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -261,7 +261,9 @@ xfs_mount_validate_sb(
> >  	    sbp->sb_dblocks == 0					||
> >  	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
> >  	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp)			||
> > -	    sbp->sb_shared_vn != 0)) {
> > +	    sbp->sb_shared_vn != 0					||
> > +	    sbp->sb_fdblocks > sbp->sb_dblocks				||
> > +	    sbp->sb_ifree > sbp->sb_icount)) {
> 
> Hmm.  On its face this seems reasonable for the superblock verifier, but
> then I started wondering, since these are /summary/ counters.
> 
> If the free counts are off by this much, the admin won't be able to
> mount the fs, and xfs_repair is the only other tool that can fix the
> summary counts.  However, if the log is dirty, the mount won't succeed
> to recover the fs, which is too bad since we can reinitialize the
> summary counts after log recovery.  xfs_repair -L will be the only way
> out, which will wreak havoc on the filesystem from discarding the log
> contents.

Yup, that's why I said "catch this on /write/", not "always reject
bad counter values".

i.e. we should never be writing a bad value, but we most definitely
need to be able to mount the filesystem to reconstruct them.

> So, would it be preferable to split this into two parts?  For example,
> have this as a corruption check in _sb_write_verify to prevent us from
> writing out garbage counters

yes.

> and a clamp in _reinit_percpu_counters so
> that we never present ridiculous free counts to users?

percpu_counter_{read,sum}_positive() should be used for anything that is
userspace facing. xfs_fs_counts() gets this right, but
xfs_fs_statfs() doesn't - it should use
percpu_counter_sum_positive().

> (Does any of this make sense with !haslazysbcount filesystems?)

Same thing - we can't verify the counters on read until after log
recovery as all the changes are journalled.

> Bonus question: What about checking frextents/rextents?

Same as !lazycount - all changes are journalled.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
