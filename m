Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53860 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbfAACS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:18:28 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E5h8168497
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:26 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2pnxedxarc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:18:25 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012IOeQ022904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:25 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012IOlh006612
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:18:24 GMT
Subject: [PATCH 1/4] xfs: introduce online scrub freeze
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:18:23 -0800
Message-ID: <154630910344.17342.15163257894247850713.stgit@magnolia>
In-Reply-To: <154630909728.17342.14170394718206854566.stgit@magnolia>
References: <154630909728.17342.14170394718206854566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new 'online scrub freeze' that we can use to lock out all
filesystem modifications and background activity so that we can perform
global scans in order to rebuild metadata.  This introduces a new IFLAG
to the scrub ioctl to indicate that userspace is willing to allow a
freeze.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++
 fs/xfs/scrub/common.c  |   89 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/scrub.c   |    8 ++++
 fs/xfs/scrub/scrub.h   |    6 +++
 fs/xfs/xfs_mount.h     |    6 +++
 fs/xfs/xfs_super.c     |   46 ++++++++++++++++++++++++-
 fs/xfs/xfs_trans.c     |    5 ++-
 8 files changed, 164 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f3aa59302fef..e93f9432d2a6 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -536,7 +536,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1 << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Allow scrub to freeze the filesystem to perform global scans. */
+#define XFS_SCRUB_IFLAG_FREEZE_OK	(1 << 8)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FREEZE_OK)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 76629c874e07..979aa748be30 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -591,9 +591,13 @@ xchk_trans_alloc(
 	struct xfs_scrub	*sc,
 	uint			resblks)
 {
+	uint			flags = 0;
+
+	if (sc->fs_frozen)
+		flags |= XFS_TRANS_NO_WRITECOUNT;
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
-				resblks, 0, 0, &sc->tp);
+				resblks, 0, flags, &sc->tp);
 
 	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
 }
@@ -892,3 +896,86 @@ xchk_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
+
+/*
+ * Exclusive Filesystem Access During Scrub and Repair
+ * ===================================================
+ *
+ * While most scrub activity can occur while the filesystem is live, there
+ * are certain scenarios where we cannot tolerate concurrent metadata updates.
+ * We therefore must freeze the filesystem against all other changes.
+ *
+ * The typical scenarios envisioned for scrub freezes are (a) to lock out all
+ * other filesystem changes in order to check the global summary counters,
+ * and anything else that requires unusual behavioral semantics.
+ *
+ * The typical scenarios envisioned for repair freezes are (a) to avoid ABBA
+ * deadlocks when need to take locks in an unusual order; or (b) to update
+ * global filesystem state.  For example, reconstruction of a damaged reverse
+ * mapping btree requires us to hold the AG header locks while scanning
+ * inodes, which goes against the usual inode -> AG header locking order.
+ *
+ * A note about inode reclaim: when we freeze the filesystem, users can't
+ * modify things and periodic background reclaim of speculative preallocations
+ * and copy-on-write staging extents is stopped.  However, the scrub/repair
+ * thread must be careful about evicting an inode from memory -- if the
+ * eviction would require a transaction, we must defer the iput until after
+ * the scrub freeze.  The reasons for this are twofold: first, scrub/repair
+ * already have a transaction and xfs can't nest transactions; and second, we
+ * froze the fs to prevent modifications that we can't control directly.
+ * This guarantee is made by freezing the inode inactivation worker while
+ * frozen.
+ *
+ * Userspace is prevented from freezing or thawing the filesystem during a
+ * repair freeze by the ->freeze_super and ->thaw_super superblock operations,
+ * which block any changes to the freeze state while a repair freeze is
+ * running through the use of the m_scrub_freeze mutex.  It only makes sense
+ * to run one scrub/repair freeze at a time, so the mutex is fine.
+ *
+ * Scrub/repair freezes cannot be initiated during a regular freeze because
+ * freeze_super does not allow nested freeze.  Repair activity that does not
+ * require a repair freeze is also prevented from running during a regular
+ * freeze because transaction allocation blocks on the regular freeze.  We
+ * assume that the only other users of XFS_TRANS_NO_WRITECOUNT transactions
+ * either aren't modifying space metadata in a way that would affect repair,
+ * or that we can inhibit any of the ones that do.
+ *
+ * Note that thaw_super and freeze_super can call deactivate_locked_super
+ * which can free the xfs_mount.  This can happen if someone freezes the block
+ * device, unmounts the filesystem, and thaws the block device.  Therefore, we
+ * must be careful about who gets to unlock the repair freeze mutex.  See the
+ * comments in xfs_fs_put_super.
+ */
+
+/* Start a scrub/repair freeze. */
+int
+xfs_scrub_fs_freeze(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_FREEZE_OK))
+		return -EUSERS;
+
+	mutex_lock(&sc->mp->m_scrub_freeze);
+	error = freeze_super(sc->mp->m_super);
+	if (error) {
+		mutex_unlock(&sc->mp->m_scrub_freeze);
+		return error;
+	}
+	sc->fs_frozen = true;
+	return 0;
+}
+
+/* Release a scrub/repair freeze. */
+int
+xfs_scrub_fs_thaw(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	sc->fs_frozen = false;
+	error = thaw_super(sc->mp->m_super);
+	mutex_unlock(&sc->mp->m_scrub_freeze);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8646ee27d667..b525f0be0924 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -137,6 +137,8 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+int xfs_scrub_fs_freeze(struct xfs_scrub *sc);
+int xfs_scrub_fs_thaw(struct xfs_scrub *sc);
 
 /* Do we need to invoke the repair tool? */
 static inline bool xfs_scrub_needs_repair(struct xfs_scrub_metadata *sm)
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e08f588d518f..3b945f0ffbf6 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -170,6 +170,8 @@ xchk_teardown(
 	struct xfs_inode	*ip_in,
 	int			error)
 {
+	int				err2;
+
 	xchk_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -186,6 +188,12 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	if (sc->fs_frozen) {
+		err2 = xfs_scrub_fs_thaw(sc);
+		if (!error && err2)
+			error = err2;
+		sc->fs_frozen = false;
+	}
 	if (sc->has_quotaofflock)
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	if (sc->buf) {
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 780cc8e9ef6a..fff806456f1c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -66,6 +66,12 @@ struct xfs_scrub {
 	bool				has_quotaofflock;
 	bool				reset_perag_resv;
 
+	/*
+	 * Do we own the current scrub freeze?  It is critical that we
+	 * release it before exiting to userspace!
+	 */
+	bool				fs_frozen;
+
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1096ea61a427..34f2cf96ec27 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -193,6 +193,12 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	/*
+	 * Only allow one thread to initiate a repair freeze at a time.  We
+	 * also use this to block userspace from changing the freeze state
+	 * while a repair freeze is in progress.
+	 */
+	struct mutex		m_scrub_freeze;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1141413c53c0..41d30a5ead2f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1520,13 +1520,41 @@ xfs_fs_unfreeze(
 /*
  * Before we get to stage 1 of a freeze, force all the inactivation work so
  * that there's less work to do if we crash during the freeze.
+ *
+ * Don't let userspace freeze while scrub has the filesystem frozen.  Note
+ * that freeze_super can free the xfs_mount, so we must be careful to recheck
+ * XFS_M before trying to access anything in the xfs_mount afterwards.
  */
 STATIC int
 xfs_fs_freeze_super(
 	struct super_block	*sb)
 {
+	int			error;
+
 	xfs_inactive_force(XFS_M(sb));
-	return freeze_super(sb);
+	mutex_lock(&XFS_M(sb)->m_scrub_freeze);
+	error = freeze_super(sb);
+	if (XFS_M(sb))
+		mutex_unlock(&XFS_M(sb)->m_scrub_freeze);
+	return error;
+}
+
+/*
+ * Don't let userspace thaw while scrub has the filesystem frozen.  Note that
+ * thaw_super can free the xfs_mount, so we must be careful to recheck XFS_M
+ * before trying to access anything in the xfs_mount afterwards.
+ */
+STATIC int
+xfs_fs_thaw_super(
+	struct super_block	*sb)
+{
+	int			error;
+
+	mutex_lock(&XFS_M(sb)->m_scrub_freeze);
+	error = thaw_super(sb);
+	if (XFS_M(sb))
+		mutex_unlock(&XFS_M(sb)->m_scrub_freeze);
+	return error;
 }
 
 STATIC int
@@ -1687,6 +1715,7 @@ xfs_mount_alloc(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
+	mutex_init(&mp->m_scrub_freeze);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
@@ -1873,6 +1902,7 @@ xfs_fs_fill_super(
  out_free_fsname:
 	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
+	mutex_destroy(&mp->m_scrub_freeze);
 	kfree(mp);
  out:
 	return error;
@@ -1905,6 +1935,19 @@ xfs_fs_put_super(
 
 	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
+	/*
+	 * fs freeze takes an active reference to the filesystem and fs thaw
+	 * drops it.  If a filesystem on a frozen (dm) block device is
+	 * unmounted before the block device is thawed, we can end up tearing
+	 * down the super from within thaw_super when the device is thawed.
+	 * xfs_fs_thaw_super grabbed the scrub repair mutex before calling
+	 * thaw_super, so we must avoid freeing a locked mutex.  At this point
+	 * we know we're the only user of the filesystem, so we can safely
+	 * unlock the scrub/repair mutex if it's locked.
+	 */
+	if (mutex_is_locked(&mp->m_scrub_freeze))
+		mutex_unlock(&mp->m_scrub_freeze);
+	mutex_destroy(&mp->m_scrub_freeze);
 	kfree(mp);
 }
 
@@ -1952,6 +1995,7 @@ static const struct super_operations xfs_super_operations = {
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.freeze_super		= xfs_fs_freeze_super,
+	.thaw_super		= xfs_fs_thaw_super,
 };
 
 static struct file_system_type xfs_fs_type = {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 0ff635fde5bc..0c1c9e987741 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -326,9 +326,12 @@ xfs_trans_alloc(
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
-	 * they're allowed to run while we're frozen.
+	 * they're allowed to run while we're frozen.  Scrub is allowed to
+	 * freeze the filesystem in order to obtain exclusive access to the
+	 * filesystem.
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
+	        !mutex_is_locked(&mp->m_scrub_freeze) &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	atomic_inc(&mp->m_active_trans);
 
