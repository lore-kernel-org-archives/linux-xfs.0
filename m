Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbeHUQnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Aug 2018 12:43:19 -0400
Date: Tue, 21 Aug 2018 09:23:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] xfs: convert remaining mount flags to state flags
Message-ID: <20180821132308.GD15030@bfoster>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180820044851.414-6-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 20, 2018 at 02:48:46PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The remaining mount flags kept in m_flags are actually runtime state
> flags. These change dynamically, so they really should be updated
> atomically so we don't potentially lose an update dur to racing

s/dur/due/

> modifications.
> 
> Rename m_flags to m_state, and convert it to use atomic bitops to
> set and clear the flags. This also adds a couple of simple wrappers
> for common state checks - read only and shutdown.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |  2 +-
>  fs/xfs/libxfs/xfs_sb.c    |  4 ++--
>  fs/xfs/scrub/scrub.c      |  2 +-
>  fs/xfs/xfs_buf_item.c     |  2 +-
>  fs/xfs/xfs_export.c       |  5 +++--
>  fs/xfs/xfs_filestream.c   |  2 +-
>  fs/xfs/xfs_fsops.c        |  2 +-
>  fs/xfs/xfs_inode.c        |  4 ++--
>  fs/xfs/xfs_ioctl.c        |  6 +++---
>  fs/xfs/xfs_iops.c         |  2 +-
>  fs/xfs/xfs_log.c          | 39 ++++++++++++++++++++++-----------------
>  fs/xfs/xfs_log_recover.c  |  2 +-
>  fs/xfs/xfs_mount.c        | 25 +++++++++++--------------
>  fs/xfs/xfs_mount.h        | 36 +++++++++++++++++++++++-------------
>  fs/xfs/xfs_super.c        | 28 +++++++++++++---------------
>  15 files changed, 86 insertions(+), 75 deletions(-)
> 
...
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5dcb9005173c..ee4d483e1209 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -183,7 +183,7 @@ xfs_validate_sb_read(
>  "Superblock has unknown read-only compatible features (0x%x) enabled.",
>  			(sbp->sb_features_ro_compat &
>  					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		if (!test_bit(XFS_STATE_RDONLY, &mp->m_state)) {

!xfs_is_readonly() ?

>  			xfs_warn(mp,
>  "Attempted to mount read-only compatible filesystem read-write.");
>  			xfs_warn(mp,
> @@ -981,7 +981,7 @@ xfs_initialize_perag_data(
>  
>  	xfs_reinit_percpu_counters(mp);
>  out:
> -	mp->m_flags &= ~XFS_MOUNT_BAD_SUMMARY;
> +	clear_bit(XFS_STATE_BAD_SUMMARY, &mp->m_state);
>  	return error;
>  }
>  
...
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fee11d015b5a..03f4681c1ba6 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
...
> @@ -316,17 +316,28 @@ __XFS_HAS_FEAT(noattr2, NOATTR2)
>  __XFS_HAS_FEAT(noalign, NOALIGN)
>  
>  /*
> - * Flags for m_flags.
> + * Mount state flags
> + *
> + * Use these with atomic bit ops only!
>   */
> -#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
> -#define XFS_MOUNT_BAD_SUMMARY	(1ULL << 2)	/* summary counters are bad */
> -#define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
> -#define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
> -						   operations, typically for
> -						   disk errors in metadata */
> -#define XFS_MOUNT_32BITINODES	(1ULL << 15)	/* inode32 allocator active */
> -#define XFS_MOUNT_RDONLY	(1ULL << 20)	/* read-only fs */
> +#define XFS_STATE_UNMOUNTING	0	/* filesystem is unmounting */
> +#define XFS_STATE_BAD_SUMMARY	1	/* summary counters are bad */
> +#define XFS_STATE_WAS_CLEAN	2	/* mount was clean */
> +#define XFS_STATE_SHUTDOWN	3	/* atomic stop of all filesystem
> +					   operations, typically for
> +					   disk errors in metadata */
> +#define XFS_STATE_32BITINODES	4	/* inode32 allocator active */
> +#define XFS_STATE_RDONLY	5	/* read-only fs */
> +
> +static inline bool xfs_is_readonly(struct xfs_mount *mp)
> +{
> +	return test_bit(XFS_STATE_RDONLY, &mp->m_state);
> +}
>  
> +static inline bool xfs_is_shut_down(struct xfs_mount *mp)
> +{
> +	return test_bit(XFS_STATE_SHUTDOWN, &mp->m_state);
> +}

This is unused, so what is the purpose of this in relation to
XFS_FORCED_SHUTDOWN(), which this duplicates?

Brian

>  
>  /*
>   * Default minimum read and write sizes.
> @@ -372,9 +383,8 @@ xfs_preferred_iosize(xfs_mount_t *mp)
>  	return PAGE_SIZE;
>  }
>  
> -#define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
> -				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
> -#define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
> +#define XFS_FORCED_SHUTDOWN(mp) \
> +		test_bit(XFS_STATE_SHUTDOWN, &(mp)->m_state)
>  void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>  		int lnnum);
>  #define xfs_force_shutdown(m,f)	\
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d3dff878be99..9938d9fb420b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -191,7 +191,7 @@ xfs_parseargs(
>  	 * Copy binary VFS mount flags we are interested in.
>  	 */
>  	if (sb_rdonly(sb))
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> +		set_bit(XFS_STATE_RDONLY, &mp->m_state);
>  	if (sb->s_flags & SB_DIRSYNC)
>  		mp->m_features |= XFS_FEAT_DIRSYNC;
>  	if (sb->s_flags & SB_SYNCHRONOUS)
> @@ -361,7 +361,7 @@ xfs_parseargs(
>  	/*
>  	 * no recovery flag requires a read-only mount
>  	 */
> -	if (xfs_has_norecovery(mp) && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +	if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
>  		xfs_warn(mp, "no-recovery mounts must be read-only.");
>  		return -EINVAL;
>  	}
> @@ -567,7 +567,7 @@ xfs_max_file_offset(
>   *
>   * Inode allocation patterns are altered only if inode32 is requested
>   * (XFS_FEAT_SMALL_INUMS), and the filesystem is sufficiently large.
> - * If altered, XFS_MOUNT_32BITINODES is set as well.
> + * If altered, XFS_STATE_32BITINODES is set as well.
>   *
>   * An agcount independent of that in the mount structure is provided
>   * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
> @@ -609,13 +609,13 @@ xfs_set_inode_alloc(
>  
>  	/*
>  	 * If user asked for no more than 32-bit inodes, and the fs is
> -	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
> +	 * sufficiently large, set XFS_STATE_32BITINODES if we must alter
>  	 * the allocator to accommodate the request.
>  	 */
>  	if (xfs_has_small_inums(mp) && ino > XFS_MAXINUMBER_32)
> -		mp->m_flags |= XFS_MOUNT_32BITINODES;
> +		set_bit(XFS_STATE_32BITINODES, &mp->m_state);
>  	else
> -		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
> +		clear_bit(XFS_STATE_32BITINODES, &mp->m_state);
>  
>  	for (index = 0; index < agcount; index++) {
>  		struct xfs_perag	*pag;
> @@ -624,7 +624,7 @@ xfs_set_inode_alloc(
>  
>  		pag = xfs_perag_get(mp, index);
>  
> -		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
> +		if (test_bit(XFS_STATE_32BITINODES, &mp->m_state)) {
>  			if (ino > XFS_MAXINUMBER_32) {
>  				pag->pagi_inodeok = 0;
>  				pag->pagf_metadata = 0;
> @@ -644,7 +644,7 @@ xfs_set_inode_alloc(
>  		xfs_perag_put(pag);
>  	}
>  
> -	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
> +	return test_bit(XFS_STATE_32BITINODES, &mp->m_state) ? maxagi : agcount;
>  }
>  
>  STATIC int
> @@ -1294,7 +1294,7 @@ xfs_fs_remount(
>  	}
>  
>  	/* ro -> rw */
> -	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
> +	if (xfs_is_readonly(mp) && !(*flags & SB_RDONLY)) {
>  		if (xfs_has_norecovery(mp)) {
>  			xfs_warn(mp,
>  		"ro->rw transition prohibited on norecovery mount");
> @@ -1311,7 +1311,7 @@ xfs_fs_remount(
>  			return -EINVAL;
>  		}
>  
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +		clear_bit(XFS_STATE_RDONLY, &mp->m_state);
>  
>  		/*
>  		 * If this is the first remount to writeable state we
> @@ -1350,7 +1350,7 @@ xfs_fs_remount(
>  	}
>  
>  	/* rw -> ro */
> -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
> +	if (!xfs_is_readonly(mp) && (*flags & SB_RDONLY)) {
>  		/*
>  		 * Cancel background eofb scanning so it cannot race with the
>  		 * final log force+buftarg wait and deadlock the remount.
> @@ -1381,7 +1381,7 @@ xfs_fs_remount(
>  		xfs_save_resvblks(mp);
>  
>  		xfs_quiesce_attr(mp);
> -		mp->m_flags |= XFS_MOUNT_RDONLY;
> +		set_bit(XFS_STATE_RDONLY, &mp->m_state);
>  	}
>  
>  	return 0;
> @@ -1433,8 +1433,6 @@ STATIC int
>  xfs_finish_flags(
>  	struct xfs_mount	*mp)
>  {
> -	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
> -
>  	/* Fail a mount where the logbuf is smaller than the log stripe */
>  	if (xfs_has_logv2(mp)) {
>  		if (mp->m_logbsize <= 0 &&
> @@ -1467,7 +1465,7 @@ xfs_finish_flags(
>  	/*
>  	 * prohibit r/w mounts of read-only filesystems
>  	 */
> -	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
> +	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !xfs_is_readonly(mp)) {
>  		xfs_warn(mp,
>  			"cannot mount a read-only filesystem as read-write");
>  		return -EROFS;
> -- 
> 2.17.0
> 
