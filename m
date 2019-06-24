Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33399
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726981AbfFXDId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:08:33 -0400
Subject: [PATCH 09/10] xfs: mount-api - remove legacy mount functions
From: Ian Kent <raven@themaw.net>
Date: Mon, 24 Jun 2019 10:59:15 +0800
Message-ID: <156134515477.2519.17589095049157758592.stgit@fedora-28>
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

Now that the new mount-api is being used the old mount functions
can be removed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  551 ----------------------------------------------------
 1 file changed, 551 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6e6eace31e07..643b40e8a328 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -196,304 +196,6 @@ suffix_kstrtoint(const char *s, unsigned int base, int *res)
 	return ret;
 }
 
-STATIC int
-match_kstrtoint(const substring_t *s, unsigned int base, int *res)
-{
-	const char	*value;
-	int ret;
-
-	value = match_strdup(s);
-	if (!value)
-		return -ENOMEM;
-	ret = suffix_kstrtoint(value, base, res);
-	kfree(value);
-	return ret;
-}
-
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- *
- * Note that this function leaks the various device name allocations on
- * failure.  The caller takes care of them.
- *
- * *sb is const because this is also used to test options on the remount
- * path, and we don't want this to have any side effects at remount time.
- * Today this function does not change *sb, but just to future-proof...
- */
-STATIC int
-xfs_parseargs(
-	struct xfs_mount	*mp,
-	char			*options)
-{
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	int			iosize = 0;
-	uint8_t			iosizelog = 0;
-
-	/*
-	 * set up the mount name first so all the errors will refer to the
-	 * correct device.
-	 */
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return -ENOMEM;
-	mp->m_fsname_len = strlen(mp->m_fsname) + 1;
-
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (sb_rdonly(sb))
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	if (sb->s_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (sb->s_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-
-	/*
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-
-	if (!options)
-		goto done;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_logbufs:
-			if (match_int(args, &mp->m_logbufs))
-				return -EINVAL;
-			break;
-		case Opt_logbsize:
-			if (match_kstrtoint(args, 10, &mp->m_logbsize))
-				return -EINVAL;
-			break;
-		case Opt_logdev:
-			kfree(mp->m_logname);
-			mp->m_logname = match_strdup(args);
-			if (!mp->m_logname)
-				return -ENOMEM;
-			break;
-		case Opt_rtdev:
-			kfree(mp->m_rtname);
-			mp->m_rtname = match_strdup(args);
-			if (!mp->m_rtname)
-				return -ENOMEM;
-			break;
-		case Opt_allocsize:
-		case Opt_biosize:
-			if (match_kstrtoint(args, 10, &iosize))
-				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
-			break;
-		case Opt_grpid:
-		case Opt_bsdgroups:
-			mp->m_flags |= XFS_MOUNT_GRPID;
-			break;
-		case Opt_nogrpid:
-		case Opt_sysvgroups:
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
-			break;
-		case Opt_wsync:
-			mp->m_flags |= XFS_MOUNT_WSYNC;
-			break;
-		case Opt_norecovery:
-			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-			break;
-		case Opt_noalign:
-			mp->m_flags |= XFS_MOUNT_NOALIGN;
-			break;
-		case Opt_swalloc:
-			mp->m_flags |= XFS_MOUNT_SWALLOC;
-			break;
-		case Opt_sunit:
-			if (match_int(args, &dsunit))
-				return -EINVAL;
-			break;
-		case Opt_swidth:
-			if (match_int(args, &dswidth))
-				return -EINVAL;
-			break;
-		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_nouuid:
-			mp->m_flags |= XFS_MOUNT_NOUUID;
-			break;
-		case Opt_ikeep:
-			mp->m_flags |= XFS_MOUNT_IKEEP;
-			break;
-		case Opt_noikeep:
-			mp->m_flags &= ~XFS_MOUNT_IKEEP;
-			break;
-		case Opt_largeio:
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_nolargeio:
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_attr2:
-			mp->m_flags |= XFS_MOUNT_ATTR2;
-			break;
-		case Opt_noattr2:
-			mp->m_flags &= ~XFS_MOUNT_ATTR2;
-			mp->m_flags |= XFS_MOUNT_NOATTR2;
-			break;
-		case Opt_filestreams:
-			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-			break;
-		case Opt_noquota:
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-			break;
-		case Opt_quota:
-		case Opt_uquota:
-		case Opt_usrquota:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					 XFS_UQUOTA_ENFD);
-			break;
-		case Opt_qnoenforce:
-		case Opt_uqnoenforce:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-			break;
-		case Opt_pquota:
-		case Opt_prjquota:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					 XFS_PQUOTA_ENFD);
-			break;
-		case Opt_pqnoenforce:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
-			break;
-		case Opt_gquota:
-		case Opt_grpquota:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					 XFS_GQUOTA_ENFD);
-			break;
-		case Opt_gqnoenforce:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
-			break;
-		case Opt_discard:
-			mp->m_flags |= XFS_MOUNT_DISCARD;
-			break;
-		case Opt_nodiscard:
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-			break;
-#ifdef CONFIG_FS_DAX
-		case Opt_dax:
-			mp->m_flags |= XFS_MOUNT_DAX;
-			break;
-#endif
-		default:
-			xfs_warn(mp, "unknown mount option [%s].", p);
-			return -EINVAL;
-		}
-	}
-
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_warn(mp, "no-recovery mounts must be read-only.");
-		return -EINVAL;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
-		xfs_warn(mp,
-	"sunit and swidth options incompatible with the noalign option");
-		return -EINVAL;
-	}
-
-#ifndef CONFIG_XFS_QUOTA
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
-		xfs_warn(mp, "quota support not available in this kernel.");
-		return -EINVAL;
-	}
-#endif
-
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
-		xfs_warn(mp, "sunit and swidth must be specified together");
-		return -EINVAL;
-	}
-
-	if (dsunit && (dswidth % dsunit != 0)) {
-		xfs_warn(mp,
-	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
-		return -EINVAL;
-	}
-
-done:
-	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
-		/*
-		 * At this point the superblock has not been read
-		 * in, therefore we do not know the block size.
-		 * Before the mount call ends we will convert
-		 * these to FSBs.
-		 */
-		mp->m_dalign = dsunit;
-		mp->m_swidth = dswidth;
-	}
-
-	if (mp->m_logbufs != -1 &&
-	    mp->m_logbufs != 0 &&
-	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
-	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
-		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
-			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return -EINVAL;
-	}
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return -EINVAL;
-	}
-
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
-			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
-				XFS_MAX_IO_LOG);
-			return -EINVAL;
-		}
-
-		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
-		mp->m_writeio_log = iosizelog;
-	}
-
-	return 0;
-}
-
 struct xfs_fs_context {
 	int	dsunit;
 	int	dswidth;
@@ -1453,181 +1155,6 @@ xfs_quiesce_attr(
 	xfs_log_quiesce(mp);
 }
 
-STATIC int
-xfs_test_remount_options(
-	struct super_block	*sb,
-	char			*options)
-{
-	int			error = 0;
-	struct xfs_mount	*tmp_mp;
-
-	tmp_mp = kmem_zalloc(sizeof(*tmp_mp), KM_MAYFAIL);
-	if (!tmp_mp)
-		return -ENOMEM;
-
-	tmp_mp->m_super = sb;
-	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_fsname(tmp_mp);
-	kmem_free(tmp_mp);
-
-	return error;
-}
-
-STATIC int
-xfs_fs_remount(
-	struct super_block	*sb,
-	int			*flags,
-	char			*options)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
-	substring_t		args[MAX_OPT_ARGS];
-	char			*p;
-	int			error;
-
-	/* First, check for complete junk; i.e. invalid options */
-	error = xfs_test_remount_options(sb, options);
-	if (error)
-		return error;
-
-	sync_filesystem(sb);
-	while ((p = strsep(&options, ",")) != NULL) {
-		int token;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-			break;
-		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-			mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
-			break;
-		default:
-			/*
-			 * Logically we would return an error here to prevent
-			 * users from believing they might have changed
-			 * mount options using remount which can't be changed.
-			 *
-			 * But unfortunately mount(8) adds all options from
-			 * mtab and fstab to the mount arguments in some cases
-			 * so we can't blindly reject options, but have to
-			 * check for each specified option if it actually
-			 * differs from the currently set option and only
-			 * reject it if that's the case.
-			 *
-			 * Until that is implemented we return success for
-			 * every remount request, and silently ignore all
-			 * options that we can't actually change.
-			 */
-#if 0
-			xfs_info(mp,
-		"mount option \"%s\" not supported for remount", p);
-			return -EINVAL;
-#else
-			break;
-#endif
-		}
-	}
-
-	/* ro -> rw */
-	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
-		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-			xfs_warn(mp,
-		"ro->rw transition prohibited on norecovery mount");
-			return -EINVAL;
-		}
-
-		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		    xfs_sb_has_ro_compat_feature(sbp,
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
-				(sbp->sb_features_ro_compat &
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-			return -EINVAL;
-		}
-
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
-		/*
-		 * If this is the first remount to writeable state we
-		 * might have some superblock changes to update.
-		 */
-		if (mp->m_update_sb) {
-			error = xfs_sync_sb(mp, false);
-			if (error) {
-				xfs_warn(mp, "failed to write sb changes");
-				return error;
-			}
-			mp->m_update_sb = false;
-		}
-
-		/*
-		 * Fill out the reserve pool if it is empty. Use the stashed
-		 * value if it is non-zero, otherwise go with the default.
-		 */
-		xfs_restore_resvblks(mp);
-		xfs_log_work_queue(mp);
-
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-		xfs_start_block_reaping(mp);
-
-		/* Create the per-AG metadata reservation pool .*/
-		error = xfs_fs_reserve_ag_blocks(mp);
-		if (error && error != -ENOSPC)
-			return error;
-	}
-
-	/* rw -> ro */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
-		/*
-		 * Cancel background eofb scanning so it cannot race with the
-		 * final log force+buftarg wait and deadlock the remount.
-		 */
-		xfs_stop_block_reaping(mp);
-
-		/* Get rid of any leftover CoW reservations... */
-		error = xfs_icache_free_cowblocks(mp, NULL);
-		if (error) {
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-
-		/* Free the per-AG metadata reservation pool. */
-		error = xfs_fs_unreserve_ag_blocks(mp);
-		if (error) {
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-
-		/*
-		 * Before we sync the metadata, we need to free up the reserve
-		 * block pool so that the used block count in the superblock on
-		 * disk is correct at the end of the remount. Stash the current
-		 * reserve pool size so that if we get remounted rw, we can
-		 * return it to the same size.
-		 */
-		xfs_save_resvblks(mp);
-
-		xfs_quiesce_attr(mp);
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	}
-
-	return 0;
-}
-
 STATIC int
 xfs_validate_params(
 	struct xfs_mount *mp,
@@ -2051,38 +1578,6 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
-{
-	struct xfs_mount	*mp;
-
-	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL);
-	if (!mp)
-		return NULL;
-
-	mp->m_super = sb;
-	spin_lock_init(&mp->m_sb_lock);
-	spin_lock_init(&mp->m_agirotor_lock);
-	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
-	spin_lock_init(&mp->m_perag_lock);
-	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
-	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
-	mp->m_kobj.kobject.kset = xfs_kset;
-	/*
-	 * We don't create the finobt per-ag space reservation until after log
-	 * recovery, so we must set this to true so that an ifree transaction
-	 * started during log recovery will not depend on space reservations
-	 * for finobt expansion.
-	 */
-	mp->m_finobt_nores = true;
-	return mp;
-}
-
-
 STATIC int
 __xfs_fs_fill_super(
 	struct xfs_mount	*mp,
@@ -2260,42 +1755,6 @@ __xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
-STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
-	int			silent)
-{
-	struct xfs_mount	*mp = NULL;
-	int			error = -ENOMEM;
-
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc(sb);
-	if (!mp)
-		goto out;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_fsname;
-
-	error = __xfs_fs_fill_super(mp, silent);
-	if (error)
-		goto out_free_fsname;
-
-	return 0;
-
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
-out:
-	return error;
-}
-
 STATIC int
 xfs_fill_super(
 	struct super_block	*sb,
@@ -2367,16 +1826,6 @@ xfs_fs_put_super(
 	kfree(mp);
 }
 
-STATIC struct dentry *
-xfs_fs_mount(
-	struct file_system_type	*fs_type,
-	int			flags,
-	const char		*dev_name,
-	void			*data)
-{
-	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
-}
-
 static long
 xfs_fs_nr_cached_objects(
 	struct super_block	*sb,
