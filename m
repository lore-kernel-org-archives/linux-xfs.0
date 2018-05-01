Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754727AbeEAPxW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:53:22 -0400
Date: Tue, 1 May 2018 08:52:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 10/13] xfs: replace XFS_QMOPT_DQALLOC with boolean
Message-ID: <20180501155259.GB4127@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
 <152506705736.21553.3142275765217711989.stgit@magnolia>
 <20180430054752.GB21688@magnolia>
 <20180501134503.GC4525@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501134503.GC4525@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Tue, May 01, 2018 at 09:45:04AM -0400, Brian Foster wrote:
> On Sun, Apr 29, 2018 at 10:47:52PM -0700, Darrick J. Wong wrote:
> > Ugh, wrong commit message.  Here's an updated one now that the flag is
> > gone entirely.
> > 
> 
> Just FYI.. git applies this with the above as the commit log message and
> the text below is tossed. ;P

D'oh.  Yeah, I screwed up the git-to-mail export. :(

This all will be done correctly in the git tree I swear.

> > --D
> > 
> > ---
> > Subject: [PATCH] xfs: replace XFS_QMOPT_DQALLOC with a simple boolean
> > 
> > DQALLOC is only ever used with xfs_qm_dqget*, and the only flag that the
> > _dqget family of functions cares about is DQALLOC.  Therefore, change
> > it to a boolean 'can alloc?' flag for the dqget interfaces where that
> > makes sense.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_quota_defs.h |    1 -
> >  fs/xfs/xfs_dquot.c             |    8 ++++----
> >  fs/xfs/xfs_dquot.h             |    2 +-
> >  fs/xfs/xfs_qm.c                |   12 +++++-------
> >  fs/xfs/xfs_qm_bhv.c            |    2 +-
> >  fs/xfs/xfs_qm_syscalls.c       |    9 ++++-----
> >  6 files changed, 15 insertions(+), 19 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> > index 531e8224dcb6..1fa3d6d6db40 100644
> > --- a/fs/xfs/xfs_qm_bhv.c
> > +++ b/fs/xfs/xfs_qm_bhv.c
> > @@ -72,7 +72,7 @@ xfs_qm_statvfs(
> >  	xfs_mount_t		*mp = ip->i_mount;
> >  	xfs_dquot_t		*dqp;
> >  
> > -	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
> > +	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, true, &dqp)) {
> 
> False? Otherwise looks fine:

Yep, that should be false.  Fixed.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  		xfs_fill_statvfs_from_dquot(statp, dqp);
> >  		xfs_qm_dqput(dqp);
> >  	}
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index b9243f554697..3e05d300b14e 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -425,7 +425,7 @@ xfs_qm_scall_setqlim(
> >  	 * a reference to the dquot, so it's safe to do this unlock/lock without
> >  	 * it being reclaimed in the mean time.
> >  	 */
> > -	error = xfs_qm_dqget(mp, id, type, XFS_QMOPT_DQALLOC, &dqp);
> > +	error = xfs_qm_dqget(mp, id, type, true, &dqp);
> >  	if (error) {
> >  		ASSERT(error != -ENOENT);
> >  		goto out_unlock;
> > @@ -696,11 +696,10 @@ xfs_qm_scall_getquota(
> >  	int			error;
> >  
> >  	/*
> > -	 * Try to get the dquot. We don't want it allocated on disk, so
> > -	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
> > -	 * exist, we'll get ENOENT back.
> > +	 * Try to get the dquot. We don't want it allocated on disk, so don't
> > +	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
> >  	 */
> > -	error = xfs_qm_dqget(mp, id, type, 0, &dqp);
> > +	error = xfs_qm_dqget(mp, id, type, false, &dqp);
> >  	if (error)
> >  		return error;
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
