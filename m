Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B504CA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F9952084C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 07:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408749AbfJXHwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 03:52:04 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404960AbfJXHwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:52:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DpAADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgXsChDqEKI9JBoERgSSIfoUgAYRrhyMJAQEBAQEBAQE?=
 =?us-ascii?q?BNwEBhDsDAgKDWTgTAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhA?=
 =?us-ascii?q?YDQImAgJHEAYThXWxdHV/MxqKMIEOKAGBZIpCeIEHgRABM4Iqc4dVgl4EjQ6?=
 =?us-ascii?q?CLzeGQEOWbIIulUUMgi+LcAMQixQtqWmBek0uCoMnUIM2F44wZ4c9gxmFWAE?=
 =?us-ascii?q?B?=
X-IPAS-Result: =?us-ascii?q?A2DpAADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgXsChDqEKI9JBoERgSSIfoUgAYRrhyMJAQEBAQEBAQEBNwEBhDsDAgKDW?=
 =?us-ascii?q?TgTAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHEAYTh?=
 =?us-ascii?q?XWxdHV/MxqKMIEOKAGBZIpCeIEHgRABM4Iqc4dVgl4EjQ6CLzeGQEOWbIIul?=
 =?us-ascii?q?UUMgi+LcAMQixQtqWmBek0uCoMnUIM2F44wZ4c9gxmFWAEB?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044147"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:59 +0800
Subject: [PATCH v7 16/17] xfs: move xfs_fs_fill_super() to be with parsing
 code
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:59 +0800
Message-ID: <157190351928.27074.6282162998349269536.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The function xfs_fs_fill_super() is only used by the mount code, so move
it to the same area as the option handling code (as part the work to
locate the mount code together).

Unfortunately some forward declarations are needed as several functions
called by xfs_fs_fill_super() ahlready have a sensible ordering and are
grouped with other related functions.

Change STATIC -> static for referenced functions while we're at it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  417 +++++++++++++++++++++++++++-------------------------
 1 file changed, 213 insertions(+), 204 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 24eec22bcac1..dd019be3fa72 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -47,8 +47,17 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
 
+static int xfs_setup_devices(struct xfs_mount *);
+static int xfs_open_devices(struct xfs_mount *);
+static void xfs_close_devices(struct xfs_mount *);
+static int xfs_init_mount_workqueues(struct xfs_mount *);
+static void xfs_destroy_mount_workqueues(struct xfs_mount *);
+static int xfs_init_percpu_counters(struct xfs_mount *);
+static void xfs_destroy_percpu_counters(struct xfs_mount *);
 static void xfs_restore_resvblks(struct xfs_mount *mp);
 static void xfs_save_resvblks(struct xfs_mount *mp);
+static int xfs_finish_flags(struct xfs_mount *);
+static uint64_t xfs_max_file_offset(unsigned int);
 
 /*
  * Table driven mount option parser.
@@ -608,6 +617,204 @@ xfs_parseargs(
 	return xfs_fc_validate_params(mp, dsunit, dswidth, iosizelog);
 }
 
+static int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct inode		*root;
+	struct xfs_mount	*mp = NULL;
+	int			flags = 0, error = -ENOMEM;
+
+	/*
+	 * allocate mp and do all low-level struct initializations before we
+	 * attach it to the super
+	 */
+	mp = xfs_mount_alloc();
+	if (!mp)
+		goto out;
+	mp->m_super = sb;
+	sb->s_fs_info = mp;
+
+	error = xfs_parseargs(mp, (char *)data);
+	if (error)
+		goto out_free_names;
+
+	sb_min_blocksize(sb, BBSIZE);
+	sb->s_xattr = xfs_xattr_handlers;
+	sb->s_export_op = &xfs_export_operations;
+#ifdef CONFIG_XFS_QUOTA
+	sb->s_qcop = &xfs_quotactl_operations;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
+#endif
+	sb->s_op = &xfs_super_operations;
+
+	/*
+	 * Delay mount work if the debug hook is set. This is debug
+	 * instrumention to coordinate simulation of xfs mount failures with
+	 * VFS superblock operations
+	 */
+	if (xfs_globals.mount_delay) {
+		xfs_notice(mp, "Delaying mount for %d seconds.",
+			xfs_globals.mount_delay);
+		msleep(xfs_globals.mount_delay * 1000);
+	}
+
+	if (silent)
+		flags |= XFS_MFSI_QUIET;
+
+	error = xfs_open_devices(mp);
+	if (error)
+		goto out_free_names;
+
+	error = xfs_init_mount_workqueues(mp);
+	if (error)
+		goto out_close_devices;
+
+	error = xfs_init_percpu_counters(mp);
+	if (error)
+		goto out_destroy_workqueues;
+
+	/* Allocate stats memory before we do operations that might use it */
+	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+	if (!mp->m_stats.xs_stats) {
+		error = -ENOMEM;
+		goto out_destroy_counters;
+	}
+
+	error = xfs_readsb(mp, flags);
+	if (error)
+		goto out_free_stats;
+
+	error = xfs_finish_flags(mp);
+	if (error)
+		goto out_free_sb;
+
+	error = xfs_setup_devices(mp);
+	if (error)
+		goto out_free_sb;
+
+	error = xfs_filestream_mount(mp);
+	if (error)
+		goto out_free_sb;
+
+	/*
+	 * we must configure the block size in the superblock before we run the
+	 * full mount process as the mount process can lookup and cache inodes.
+	 */
+	sb->s_magic = XFS_SUPER_MAGIC;
+	sb->s_blocksize = mp->m_sb.sb_blocksize;
+	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
+	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_max_links = XFS_MAXLINK;
+	sb->s_time_gran = 1;
+	sb->s_time_min = S32_MIN;
+	sb->s_time_max = S32_MAX;
+	sb->s_iflags |= SB_I_CGROUPWB;
+
+	set_posix_acl_flag(sb);
+
+	/* version 5 superblocks support inode version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		sb->s_flags |= SB_I_VERSION;
+
+	if (mp->m_flags & XFS_MOUNT_DAX) {
+		bool rtdev_is_dax = false, datadev_is_dax;
+
+		xfs_warn(mp,
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+
+		datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
+			sb->s_blocksize);
+		if (mp->m_rtdev_targp)
+			rtdev_is_dax = bdev_dax_supported(
+				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
+		if (!rtdev_is_dax && !datadev_is_dax) {
+			xfs_alert(mp,
+			"DAX unsupported by block device. Turning off DAX.");
+			mp->m_flags &= ~XFS_MOUNT_DAX;
+		}
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			xfs_alert(mp,
+		"DAX and reflink cannot be used together!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+	}
+
+	if (mp->m_flags & XFS_MOUNT_DISCARD) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+
+		if (!blk_queue_discard(q)) {
+			xfs_warn(mp, "mounting with \"discard\" option, but "
+					"the device does not support discard");
+			mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		}
+	}
+
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (mp->m_sb.sb_rblocks) {
+			xfs_alert(mp,
+	"reflink not compatible with realtime device!");
+			error = -EINVAL;
+			goto out_filestream_unmount;
+		}
+
+		if (xfs_globals.always_cow) {
+			xfs_info(mp, "using DEBUG-only always_cow mode.");
+			mp->m_always_cow = true;
+		}
+	}
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
+		xfs_alert(mp,
+	"reverse mapping btree not compatible with realtime device!");
+		error = -EINVAL;
+		goto out_filestream_unmount;
+	}
+
+	error = xfs_mountfs(mp);
+	if (error)
+		goto out_filestream_unmount;
+
+	root = igrab(VFS_I(mp->m_rootip));
+	if (!root) {
+		error = -ENOENT;
+		goto out_unmount;
+	}
+	sb->s_root = d_make_root(root);
+	if (!sb->s_root) {
+		error = -ENOMEM;
+		goto out_unmount;
+	}
+
+	return 0;
+
+ out_filestream_unmount:
+	xfs_filestream_unmount(mp);
+ out_free_sb:
+	xfs_freesb(mp);
+ out_free_stats:
+	free_percpu(mp->m_stats.xs_stats);
+ out_destroy_counters:
+	xfs_destroy_percpu_counters(mp);
+ out_destroy_workqueues:
+	xfs_destroy_mount_workqueues(mp);
+ out_close_devices:
+	xfs_close_devices(mp);
+ out_free_names:
+	sb->s_fs_info = NULL;
+	xfs_mount_free(mp);
+ out:
+	return error;
+
+ out_unmount:
+	xfs_filestream_unmount(mp);
+	xfs_unmountfs(mp);
+	goto out_free_sb;
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -840,7 +1047,7 @@ xfs_blkdev_issue_flush(
 	blkdev_issue_flush(buftarg->bt_bdev, GFP_NOFS, NULL);
 }
 
-STATIC void
+static void
 xfs_close_devices(
 	struct xfs_mount	*mp)
 {
@@ -876,7 +1083,7 @@ xfs_close_devices(
  * they are present.  The data subvolume has already been opened by
  * get_sb_bdev() and is stored in sb->s_bdev.
  */
-STATIC int
+static int
 xfs_open_devices(
 	struct xfs_mount	*mp)
 {
@@ -955,7 +1162,7 @@ xfs_open_devices(
 /*
  * Setup xfs_mount buffer target pointers based on superblock
  */
-STATIC int
+static int
 xfs_setup_devices(
 	struct xfs_mount	*mp)
 {
@@ -985,7 +1192,7 @@ xfs_setup_devices(
 	return 0;
 }
 
-STATIC int
+static int
 xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
@@ -1036,7 +1243,7 @@ xfs_init_mount_workqueues(
 	return -ENOMEM;
 }
 
-STATIC void
+static void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
@@ -1518,7 +1725,7 @@ xfs_fs_show_options(
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
  */
-STATIC int
+static int
 xfs_finish_flags(
 	struct xfs_mount	*mp)
 {
@@ -1636,204 +1843,6 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
-STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
-	int			silent)
-{
-	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
-	int			flags = 0, error = -ENOMEM;
-
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc();
-	if (!mp)
-		goto out;
-	mp->m_super = sb;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_names;
-
-	sb_min_blocksize(sb, BBSIZE);
-	sb->s_xattr = xfs_xattr_handlers;
-	sb->s_export_op = &xfs_export_operations;
-#ifdef CONFIG_XFS_QUOTA
-	sb->s_qcop = &xfs_quotactl_operations;
-	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
-#endif
-	sb->s_op = &xfs_super_operations;
-
-	/*
-	 * Delay mount work if the debug hook is set. This is debug
-	 * instrumention to coordinate simulation of xfs mount failures with
-	 * VFS superblock operations
-	 */
-	if (xfs_globals.mount_delay) {
-		xfs_notice(mp, "Delaying mount for %d seconds.",
-			xfs_globals.mount_delay);
-		msleep(xfs_globals.mount_delay * 1000);
-	}
-
-	if (silent)
-		flags |= XFS_MFSI_QUIET;
-
-	error = xfs_open_devices(mp);
-	if (error)
-		goto out_free_names;
-
-	error = xfs_init_mount_workqueues(mp);
-	if (error)
-		goto out_close_devices;
-
-	error = xfs_init_percpu_counters(mp);
-	if (error)
-		goto out_destroy_workqueues;
-
-	/* Allocate stats memory before we do operations that might use it */
-	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
-	if (!mp->m_stats.xs_stats) {
-		error = -ENOMEM;
-		goto out_destroy_counters;
-	}
-
-	error = xfs_readsb(mp, flags);
-	if (error)
-		goto out_free_stats;
-
-	error = xfs_finish_flags(mp);
-	if (error)
-		goto out_free_sb;
-
-	error = xfs_setup_devices(mp);
-	if (error)
-		goto out_free_sb;
-
-	error = xfs_filestream_mount(mp);
-	if (error)
-		goto out_free_sb;
-
-	/*
-	 * we must configure the block size in the superblock before we run the
-	 * full mount process as the mount process can lookup and cache inodes.
-	 */
-	sb->s_magic = XFS_SUPER_MAGIC;
-	sb->s_blocksize = mp->m_sb.sb_blocksize;
-	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
-	sb->s_max_links = XFS_MAXLINK;
-	sb->s_time_gran = 1;
-	sb->s_time_min = S32_MIN;
-	sb->s_time_max = S32_MAX;
-	sb->s_iflags |= SB_I_CGROUPWB;
-
-	set_posix_acl_flag(sb);
-
-	/* version 5 superblocks support inode version counters. */
-	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
-		sb->s_flags |= SB_I_VERSION;
-
-	if (mp->m_flags & XFS_MOUNT_DAX) {
-		bool rtdev_is_dax = false, datadev_is_dax;
-
-		xfs_warn(mp,
-		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
-
-		datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
-			sb->s_blocksize);
-		if (mp->m_rtdev_targp)
-			rtdev_is_dax = bdev_dax_supported(
-				mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
-		if (!rtdev_is_dax && !datadev_is_dax) {
-			xfs_alert(mp,
-			"DAX unsupported by block device. Turning off DAX.");
-			mp->m_flags &= ~XFS_MOUNT_DAX;
-		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-			xfs_alert(mp,
-		"DAX and reflink cannot be used together!");
-			error = -EINVAL;
-			goto out_filestream_unmount;
-		}
-	}
-
-	if (mp->m_flags & XFS_MOUNT_DISCARD) {
-		struct request_queue *q = bdev_get_queue(sb->s_bdev);
-
-		if (!blk_queue_discard(q)) {
-			xfs_warn(mp, "mounting with \"discard\" option, but "
-					"the device does not support discard");
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		}
-	}
-
-	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		if (mp->m_sb.sb_rblocks) {
-			xfs_alert(mp,
-	"reflink not compatible with realtime device!");
-			error = -EINVAL;
-			goto out_filestream_unmount;
-		}
-
-		if (xfs_globals.always_cow) {
-			xfs_info(mp, "using DEBUG-only always_cow mode.");
-			mp->m_always_cow = true;
-		}
-	}
-
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
-	"reverse mapping btree not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
-	}
-
-	error = xfs_mountfs(mp);
-	if (error)
-		goto out_filestream_unmount;
-
-	root = igrab(VFS_I(mp->m_rootip));
-	if (!root) {
-		error = -ENOENT;
-		goto out_unmount;
-	}
-	sb->s_root = d_make_root(root);
-	if (!sb->s_root) {
-		error = -ENOMEM;
-		goto out_unmount;
-	}
-
-	return 0;
-
- out_filestream_unmount:
-	xfs_filestream_unmount(mp);
- out_free_sb:
-	xfs_freesb(mp);
- out_free_stats:
-	free_percpu(mp->m_stats.xs_stats);
- out_destroy_counters:
-	xfs_destroy_percpu_counters(mp);
- out_destroy_workqueues:
-	xfs_destroy_mount_workqueues(mp);
- out_close_devices:
-	xfs_close_devices(mp);
- out_free_names:
-	sb->s_fs_info = NULL;
-	xfs_mount_free(mp);
- out:
-	return error;
-
- out_unmount:
-	xfs_filestream_unmount(mp);
-	xfs_unmountfs(mp);
-	goto out_free_sb;
-}
-
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)

