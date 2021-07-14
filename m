Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFB8C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DA4613B5
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhGNXNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXNM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC481613B5;
        Wed, 14 Jul 2021 23:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304219;
        bh=jM2y7X1jsHr5R191Z9oEUbgGKwllhFv2UEbajNp672c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kdkod+eZyb5uEXNESuNmd72F78okp0d3hTsQgfkYdzWHCKc7hfYBdKRxKccfY7qVk
         /ZYRo99FxGE2u//0suZXYDfFjp3kQillamYSD3IKnBLm60Akv/CIRjoyGtvsU2Z+Qr
         aVSa5GvbnHM4j13o1BOgnNj2Yk5EsweKyKOVbkYV/dr7iHd2vnBISEsdUTh7tzG/Gy
         KxXzREc32BiX++v+vrLzILkqBBsDnBQ3HH/3w5lQzi4gVkbnSxPk1qIfp6mZ5SPONi
         72bExxy/C7Via8pKE6+eBW/lqDG1wdUg78Uugc0E8STG5/E6IalHJ/hW08YzVjCIy+
         sQZ3Kckm2MI/w==
Date:   Wed, 14 Jul 2021 16:10:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/16] xfs: convert remaining mount flags to state flags
Message-ID: <20210714231019.GB22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-9-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The remaining mount flags kept in m_flags are actually runtime state
> flags. These change dynamically, so they really should be updated
> atomically so we don't potentially lose an update dur to racing

s/dur/due/ ?

> modifications.
> 
> Rename m_flags to m_state, and convert it to use atomic bitops to
> set and clear the flags. This also adds a couple of simple wrappers
> for common state checks - read only and shutdown.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With that corrected, this is a neat cleanup. :)
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c |  2 +-
>  fs/xfs/libxfs/xfs_sb.c    |  2 +-
>  fs/xfs/scrub/scrub.c      |  2 +-
>  fs/xfs/xfs_buf.c          |  2 +-
>  fs/xfs/xfs_export.c       |  4 ++--
>  fs/xfs/xfs_filestream.c   |  2 +-
>  fs/xfs/xfs_fsops.c        |  7 +------
>  fs/xfs/xfs_icache.c       |  2 +-
>  fs/xfs/xfs_inode.c        |  4 ++--
>  fs/xfs/xfs_ioctl.c        |  6 +++---
>  fs/xfs/xfs_iops.c         |  2 +-
>  fs/xfs/xfs_log.c          | 31 +++++++++++++++++--------------
>  fs/xfs/xfs_log_recover.c  |  2 +-
>  fs/xfs/xfs_mount.c        | 15 +++++++--------
>  fs/xfs/xfs_mount.h        | 36 +++++++++++++++++++++---------------
>  fs/xfs/xfs_super.c        | 28 +++++++++++++---------------
>  16 files changed, 74 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 5f943a804d9e..f408ea68dbd0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3166,7 +3166,7 @@ xfs_alloc_vextent(
>  		 * the first a.g. fails.
>  		 */
>  		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
> -		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
> +		    xfs_is_inode32(mp)) {
>  			args->fsbno = XFS_AGB_TO_FSB(mp,
>  					((mp->m_agfrotor / rotorstep) %
>  					mp->m_sb.sb_agcount), 0);
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index a1e286fb8ac3..baaec7e6a975 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -122,7 +122,7 @@ xfs_validate_sb_read(
>  "Superblock has unknown read-only compatible features (0x%x) enabled.",
>  			(sbp->sb_features_ro_compat &
>  					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		if (!xfs_is_readonly(mp)) {
>  			xfs_warn(mp,
>  "Attempted to mount read-only compatible filesystem read-write.");
>  			xfs_warn(mp,
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index d9534fe0c69b..96c623c464f0 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -419,7 +419,7 @@ xchk_validate_inputs(
>  			goto out;
>  
>  		error = -EROFS;
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		if (xfs_is_readonly(mp))
>  			goto out;
>  	}
>  
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f606d4839e6e..49ae68086945 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1145,7 +1145,7 @@ xfs_buf_ioerror_permanent(
>  		return true;
>  
>  	/* At unmount we may treat errors differently */
> -	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
> +	if (xfs_is_unmounting(mp) && mp->m_fail_unmount)
>  		return true;
>  
>  	return false;
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index cb359ec3389b..1064c2342876 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -44,6 +44,7 @@ xfs_fs_encode_fh(
>  	int		*max_len,
>  	struct inode	*parent)
>  {
> +	struct xfs_mount	*mp = XFS_M(inode->i_sb);
>  	struct fid		*fid = (struct fid *)fh;
>  	struct xfs_fid64	*fid64 = (struct xfs_fid64 *)fh;
>  	int			fileid_type;
> @@ -63,8 +64,7 @@ xfs_fs_encode_fh(
>  	 * large enough filesystem may contain them, thus the slightly
>  	 * confusing looking conditional below.
>  	 */
> -	if (!xfs_has_small_inums(XFS_M(inode->i_sb)) ||
> -	    (XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES))
> +	if (!xfs_has_small_inums(mp) || xfs_is_inode32(mp))
>  		fileid_type |= XFS_FILEID_TYPE_64FLAG;
>  
>  	/*
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index eed6ca5f8f91..6a3ce0f6dc9e 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -295,7 +295,7 @@ xfs_filestream_lookup_ag(
>  	 * Set the starting AG using the rotor for inode32, otherwise
>  	 * use the directory inode's AG.
>  	 */
> -	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +	if (xfs_is_inode32(mp)) {
>  		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
>  		startag = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
>  		mp->m_agfrotor = (mp->m_agfrotor + 1) %
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index cbdb9a86edfc..38f714990756 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -527,15 +527,10 @@ xfs_do_force_shutdown(
>  	int		tag;
>  	const char	*why;
>  
> -	spin_lock(&mp->m_sb_lock);
> -	if (XFS_FORCED_SHUTDOWN(mp)) {
> -		spin_unlock(&mp->m_sb_lock);
> +	if (test_and_set_bit(XFS_STATE_SHUTDOWN, &mp->m_opstate))
>  		return;
> -	}
> -	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
>  	if (mp->m_sb_bp)
>  		mp->m_sb_bp->b_flags |= XBF_DONE;
> -	spin_unlock(&mp->m_sb_lock);
>  
>  	if (flags & SHUTDOWN_FORCE_UMOUNT)
>  		xfs_alert(mp, "User initiated shutdown received.");
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 81da0a59a106..8e65cd47a061 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1052,7 +1052,7 @@ static inline bool
>  xfs_want_reclaim_sick(
>  	struct xfs_mount	*mp)
>  {
> -	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) || xfs_has_norecovery(mp) ||
> +	return xfs_is_unmounting(mp) || xfs_has_norecovery(mp) ||
>  	       XFS_FORCED_SHUTDOWN(mp);
>  }
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 59cea74df9a7..09b4aba8edc5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1434,7 +1434,7 @@ xfs_release(
>  		return 0;
>  
>  	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (xfs_is_readonly(mp))
>  		return 0;
>  
>  	if (!XFS_FORCED_SHUTDOWN(mp)) {
> @@ -1682,7 +1682,7 @@ xfs_inactive(
>  	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
>  
>  	/* If this is a read-only mount, don't do this (would generate I/O) */
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (xfs_is_readonly(mp))
>  		goto out;
>  
>  	/* Metadata inodes require explicit resource cleanup. */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 1c7f01cdba71..d9c2aaad2a4f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1245,7 +1245,7 @@ xfs_ioctl_setattr_get_trans(
>  	struct xfs_trans	*tp;
>  	int			error = -EROFS;
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (xfs_is_readonly(mp))
>  		goto out_error;
>  	error = -EIO;
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -2063,7 +2063,7 @@ xfs_file_ioctl(
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		if (xfs_is_readonly(mp))
>  			return -EROFS;
>  
>  		if (copy_from_user(&inout, arg, sizeof(inout)))
> @@ -2180,7 +2180,7 @@ xfs_file_ioctl(
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  
> -		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		if (xfs_is_readonly(mp))
>  			return -EROFS;
>  
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 2208345546c1..6e37d89cdf02 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -673,7 +673,7 @@ xfs_vn_change_ok(
>  {
>  	struct xfs_mount	*mp = XFS_I(d_inode(dentry))->i_mount;
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +	if (xfs_is_readonly(mp))
>  		return -EROFS;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ac18fe03a630..574cb5f84600 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -621,7 +621,7 @@ xfs_log_mount(
>  		xfs_notice(mp,
>  "Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
>  			   XFS_SB_VERSION_NUM(&mp->m_sb));
> -		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
> +		ASSERT(xfs_is_readonly(mp));
>  	}
>  
>  	log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
> @@ -701,15 +701,15 @@ xfs_log_mount(
>  	 * just worked.
>  	 */
>  	if (!xfs_has_norecovery(mp)) {
> -		bool	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> -
> -		if (readonly)
> -			mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -
> +		/*
> +		 * log recovery ignores readonly state and so we need to clear
> +		 * mount-based read only state so it can write to disk.
> +		 */
> +		bool	readonly = test_and_clear_bit(XFS_STATE_READONLY,
> +						&mp->m_opstate);
>  		error = xlog_recover(log);
> -
>  		if (readonly)
> -			mp->m_flags |= XFS_MOUNT_RDONLY;
> +			set_bit(XFS_STATE_READONLY, &mp->m_opstate);
>  		if (error) {
>  			xfs_warn(mp, "log mount/recovery failed: error %d",
>  				error);
> @@ -758,17 +758,20 @@ xfs_log_mount_finish(
>  	struct xfs_mount	*mp)
>  {
>  	struct xlog		*log = mp->m_log;
> -	bool			readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
> +	bool			readonly;
>  	int			error = 0;
>  
>  	if (xfs_has_norecovery(mp)) {
> -		ASSERT(readonly);
> +		ASSERT(xfs_is_readonly(mp));
>  		return 0;
> -	} else if (readonly) {
> -		/* Allow unlinked processing to proceed */
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
>  	}
>  
> +	/*
> +	 * log recovery ignores readonly state and so we need to clear
> +	 * mount-based read only state so it can write to disk.
> +	 */
> +	readonly = test_and_clear_bit(XFS_STATE_READONLY, &mp->m_opstate);
> +
>  	/*
>  	 * During the second phase of log recovery, we need iget and
>  	 * iput to behave like they do for an active filesystem.
> @@ -820,7 +823,7 @@ xfs_log_mount_finish(
>  
>  	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
>  	if (readonly)
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> +		set_bit(XFS_STATE_READONLY, &mp->m_opstate);
>  
>  	/* Make sure the log is dead if we're returning failure. */
>  	ASSERT(!error || xlog_is_shutdown(log));
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index accc175987a4..ffa445d24ba4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1347,7 +1347,7 @@ xlog_find_tail(
>  	 * headers if we have a filesystem using non-persistent counters.
>  	 */
>  	if (clean)
> -		log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
> +		set_bit(XFS_STATE_CLEAN, &log->l_mp->m_opstate);
>  
>  	/*
>  	 * Make sure that there are no blocks in front of the head
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0750b2a0a6c5..feb10fa7029a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -485,7 +485,7 @@ xfs_check_summary_counts(
>  	 * counters.  If any of them are obviously incorrect, we can recompute
>  	 * them from the AGF headers in the next step.
>  	 */
> -	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
> +	if (xfs_is_clean(mp) &&
>  	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
>  	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
>  	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
> @@ -502,8 +502,7 @@ xfs_check_summary_counts(
>  	 * superblock to be correct and we don't need to do anything here.
>  	 * Otherwise, recalculate the summary counters.
>  	 */
> -	if ((!xfs_has_lazysbcount(mp) ||
> -	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> +	if ((!xfs_has_lazysbcount(mp) || xfs_is_clean(mp)) &&
>  	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
>  		return 0;
>  
> @@ -543,7 +542,7 @@ xfs_unmount_flush_inodes(
>  	xfs_extent_busy_wait_all(mp);
>  	flush_workqueue(xfs_discard_wq);
>  
> -	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> +	set_bit(XFS_STATE_UNMOUNTING, &mp->m_opstate);
>  
>  	xfs_ail_push_all_sync(mp->m_ail);
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> @@ -822,7 +821,7 @@ xfs_mountfs(
>  	 * the next remount into writeable mode.  Otherwise we would never
>  	 * perform the update e.g. for the root filesystem.
>  	 */
> -	if (mp->m_update_sb && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +	if (mp->m_update_sb && !xfs_is_readonly(mp)) {
>  		error = xfs_sync_sb(mp, false);
>  		if (error) {
>  			xfs_warn(mp, "failed to write sb changes");
> @@ -881,7 +880,7 @@ xfs_mountfs(
>  	 * We use the same quiesce mechanism as the rw->ro remount, as they are
>  	 * semantically identical operations.
>  	 */
> -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !xfs_has_norecovery(mp))
> +	if (xfs_is_readonly(mp) && !xfs_has_norecovery(mp))
>  		xfs_log_clean(mp);
>  
>  	/*
> @@ -905,7 +904,7 @@ xfs_mountfs(
>  	 * This may drive us straight to ENOSPC on mount, but that implies
>  	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +	if (!xfs_is_readonly(mp)) {
>  		resblks = xfs_default_resblks(mp);
>  		error = xfs_reserve_blocks(mp, &resblks, NULL);
>  		if (error)
> @@ -1044,7 +1043,7 @@ xfs_fs_writable(
>  {
>  	ASSERT(level > SB_UNFROZEN);
>  	if ((mp->m_super->s_writers.frozen >= level) ||
> -	    XFS_FORCED_SHUTDOWN(mp) || (mp->m_flags & XFS_MOUNT_RDONLY))
> +	    XFS_FORCED_SHUTDOWN(mp) || xfs_is_readonly(mp))
>  		return false;
>  
>  	return true;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 387be1bfb431..0b9b84b31179 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -131,12 +131,12 @@ typedef struct xfs_mount {
>  	uint			m_rsumsize;	/* size of rt summary, bytes */
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint			m_qflags;	/* quota status flags */
> -	uint64_t		m_flags;	/* global mount flags */
>  	uint64_t		m_features;	/* active filesystem features */
>  	int64_t			m_low_space[XFS_LOWSP_MAX];
>  	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
>  	struct xfs_trans_resv	m_resv;		/* precomputed res values */
>  						/* low free space thresholds */
> +	unsigned long		m_opstate;	/* dynamic state flags */
>  	bool			m_always_cow;
>  	bool			m_fail_unmount;
>  	bool			m_finobt_nores; /* no per-AG finobt resv. */
> @@ -345,18 +345,26 @@ __XFS_HAS_FEAT(norecovery, NORECOVERY)
>  __XFS_HAS_FEAT(nouuid, NOUUID)
>  
>  /*
> - * Flags for m_flags.
> + * Operational state flags
> + * Use these with atomic bit ops only!
>   */
> -#define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
> -						   must be synchronous except
> -						   for space allocations */
> -#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
> -#define XFS_MOUNT_WAS_CLEAN	(1ULL << 2)
> -#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 3)	/* atomic stop of all filesystem
> -						   operations, typically for
> -						   disk errors in metadata */
> -#define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
> -#define XFS_MOUNT_RDONLY	(1ULL << 4)	/* read-only fs */
> +#define XFS_STATE_UNMOUNTING	0	/* filesystem is unmounting */
> +#define XFS_STATE_CLEAN		1	/* mount was clean */
> +#define XFS_STATE_SHUTDOWN	2	/* atomic stop of all fs operations */
> +#define XFS_STATE_INODE32	3	/* inode32 allocator active */
> +#define XFS_STATE_READONLY	4	/* read-only fs */
> +
> +#define __XFS_IS_STATE(name, NAME) \
> +static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
> +{ \
> +	return test_bit(XFS_STATE_ ## NAME, &mp->m_opstate); \
> +}
> +
> +__XFS_IS_STATE(unmounting, UNMOUNTING)
> +__XFS_IS_STATE(clean, CLEAN)
> +__XFS_IS_STATE(shutdown, SHUTDOWN)
> +__XFS_IS_STATE(inode32, INODE32)
> +__XFS_IS_STATE(readonly, READONLY)
>  
>  /*
>   * Max and min values for mount-option defined I/O
> @@ -365,9 +373,7 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_MAX_IO_LOG		30	/* 1G */
>  #define XFS_MIN_IO_LOG		PAGE_SHIFT
>  
> -#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
> -				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
> -#define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
> +#define XFS_FORCED_SHUTDOWN(mp)		xfs_is_shutdown(mp)
>  void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  		int lnnum);
>  #define xfs_force_shutdown(m,f)	\
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9c3fc7f5e5ab..cc7eb9a73e85 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -233,7 +233,7 @@ xfs_fs_show_options(
>   *
>   * Inode allocation patterns are altered only if inode32 is requested
>   * (XFS_FEAT_SMALL_INUMS), and the filesystem is sufficiently large.
> - * If altered, XFS_MOUNT_32BITINODES is set as well.
> + * If altered, XFS_STATE_INODE32 is set as well.
>   *
>   * An agcount independent of that in the mount structure is provided
>   * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
> @@ -275,13 +275,13 @@ xfs_set_inode_alloc(
>  
>  	/*
>  	 * If user asked for no more than 32-bit inodes, and the fs is
> -	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> +	 * sufficiently large, set XFS_STATE_INODE32 if we must alter
>  	 * the allocator to accommodate the request.
>  	 */
>  	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> +		set_bit(XFS_STATE_INODE32, &mp->m_opstate);
>  	else
> -		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> +		clear_bit(XFS_STATE_INODE32, &mp->m_opstate);
>  
>  	for (index = 0; index < agcount; index++) {
>  		struct xfs_perag	*pag;
> @@ -290,7 +290,7 @@ xfs_set_inode_alloc(
>  
>  		pag = xfs_perag_get(mp, index);
>  
> -		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +		if (xfs_is_inode32(mp)) {
>  			if (ino > XFS_MAXINUMBER_32) {
>  				pag->pagi_inodeok = 0;
>  				pag->pagf_metadata = 0;
> @@ -310,7 +310,7 @@ xfs_set_inode_alloc(
>  		xfs_perag_put(pag);
>  	}
>  
> -	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
> +	return xfs_is_inode32(mp) ? maxagi : agcount;
>  }
>  
>  STATIC int
> @@ -912,8 +912,6 @@ STATIC int
>  xfs_finish_flags(
>  	struct xfs_mount	*mp)
>  {
> -	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
> -
>  	/* Fail a mount where the logbuf is smaller than the log stripe */
>  	if (xfs_has_logv2(mp)) {
>  		if (mp->m_logbsize <= 0 &&
> @@ -946,7 +944,7 @@ xfs_finish_flags(
>  	/*
>  	 * prohibit r/w mounts of read-only filesystems
>  	 */
> -	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
> +	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !xfs_is_readonly(mp)) {
>  		xfs_warn(mp,
>  			"cannot mount a read-only filesystem as read-write");
>  		return -EROFS;
> @@ -1293,7 +1291,7 @@ xfs_fs_validate_params(
>  	struct xfs_mount	*mp)
>  {
>  	/* No recovery flag requires a read-only mount */
> -	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +	if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
>  		xfs_warn(mp, "no-recovery mounts must be read-only.");
>  		return -EINVAL;
>  	}
> @@ -1666,7 +1664,7 @@ xfs_remount_rw(
>  		return -EINVAL;
>  	}
>  
> -	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +	clear_bit(XFS_STATE_READONLY, &mp->m_opstate);
>  
>  	/*
>  	 * If this is the first remount to writeable state we might have some
> @@ -1742,7 +1740,7 @@ xfs_remount_ro(
>  	xfs_save_resvblks(mp);
>  
>  	xfs_log_clean(mp);
> -	mp->m_flags |= XFS_MOUNT_RDONLY;
> +	set_bit(XFS_STATE_READONLY, &mp->m_opstate);
>  
>  	return 0;
>  }
> @@ -1792,14 +1790,14 @@ xfs_fs_reconfigure(
>  	}
>  
>  	/* ro -> rw */
> -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> +	if (xfs_is_readonly(mp) && !(flags & SB_RDONLY)) {
>  		error = xfs_remount_rw(mp);
>  		if (error)
>  			return error;
>  	}
>  
>  	/* rw -> ro */
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> +	if (!xfs_is_readonly(mp) && (flags & SB_RDONLY)) {
>  		error = xfs_remount_ro(mp);
>  		if (error)
>  			return error;
> @@ -1866,7 +1864,7 @@ static int xfs_init_fs_context(
>  	 * Copy binary VFS mount flags we are interested in.
>  	 */
>  	if (fc->sb_flags & SB_RDONLY)
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> +		set_bit(XFS_STATE_READONLY, &mp->m_opstate);
>  	if (fc->sb_flags & SB_DIRSYNC)
>  		mp->m_features |= XFS_FEAT_DIRSYNC;
>  	if (fc->sb_flags & SB_SYNCHRONOUS)
> -- 
> 2.31.1
> 
