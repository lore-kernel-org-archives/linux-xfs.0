Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751593AbeFXTYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jun 2018 15:24:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5OJOY3V077412
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:34 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2jt8a7gerj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOYuV026520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:34 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5OJOXiq031766
        for <linux-xfs@vger.kernel.org>; Sun, 24 Jun 2018 19:24:33 GMT
Subject: [PATCH 10/21] xfs: introduce online scrub freeze
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 24 Jun 2018 12:24:32 -0700
Message-ID: <152986827256.3155.4406402105952959221.stgit@magnolia>
In-Reply-To: <152986820984.3155.16417868536016544528.stgit@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
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
 fs/xfs/scrub/common.c  |   87 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/repair.c  |   21 ++++++++++++
 fs/xfs/scrub/repair.h  |    1 +
 fs/xfs/scrub/scrub.c   |    8 ++++
 fs/xfs/scrub/scrub.h   |    6 +++
 fs/xfs/xfs_mount.h     |    6 +++
 fs/xfs/xfs_super.c     |   53 +++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.c     |    5 ++-
 10 files changed, 192 insertions(+), 3 deletions(-)


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
index 6dcd83944ab6..257cb13d36e3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -590,9 +590,13 @@ xfs_scrub_trans_alloc(
 	struct xfs_scrub_context	*sc,
 	uint				resblks)
 {
+	uint				flags = 0;
+
+	if (sc->fs_frozen)
+		flags |= XFS_TRANS_NO_WRITECOUNT;
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
-				resblks, 0, 0, &sc->tp);
+				resblks, 0, flags, &sc->tp);
 
 	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
 }
@@ -944,3 +948,84 @@ xfs_scrub_iput(
 	trace_xfs_scrub_iput_now(ip, __return_address);
 	iput(VFS_I(ip));
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
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
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
+/* Release a scrub/repair freeze and iput all the deferred inodes. */
+int
+xfs_scrub_fs_thaw(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	sc->fs_frozen = false;
+	error = thaw_super(sc->mp->m_super);
+	mutex_unlock(&sc->mp->m_scrub_freeze);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ca9e15af2a4f..e8c4e41139ca 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -141,5 +141,7 @@ static inline bool xfs_scrub_skip_xref(struct xfs_scrub_metadata *sm)
 int xfs_scrub_metadata_inode_forks(struct xfs_scrub_context *sc);
 int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 void xfs_scrub_iput(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xfs_scrub_fs_freeze(struct xfs_scrub_context *sc);
+int xfs_scrub_fs_thaw(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index bcdaa8df18f6..85ec872093e6 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1161,3 +1161,24 @@ xfs_repair_ino_dqattach(
 
 	return error;
 }
+
+/* Read all AG headers and attach to this transaction. */
+int
+xfs_repair_grab_all_ag_headers(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_buf			*agi;
+	struct xfs_buf			*agf;
+	struct xfs_buf			*agfl;
+	xfs_agnumber_t			agno;
+	int				error = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_scrub_ag_read_headers(sc, agno, &agi, &agf, &agfl);
+		if (error)
+			break;
+	}
+
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dcfa5eb18940..1cdf457e41da 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -95,6 +95,7 @@ int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
 		struct xfs_buf *agfl_bp);
 void xfs_repair_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
 int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
+int xfs_repair_grab_all_ag_headers(struct xfs_scrub_context *sc);
 
 /* Metadata repairers */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b24b37b34d85..424f01130f14 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -182,6 +182,8 @@ xfs_scrub_teardown(
 	struct xfs_inode		*ip_in,
 	int				error)
 {
+	int				err2;
+
 	xfs_scrub_ag_free(sc, &sc->sa);
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
@@ -199,6 +201,12 @@ xfs_scrub_teardown(
 			iput(VFS_I(sc->ip));
 		sc->ip = NULL;
 	}
+	if (sc->fs_frozen) {
+		err2 = xfs_scrub_fs_thaw(sc);
+		if (!error && err2)
+			error = err2;
+		sc->fs_frozen = false;
+	}
 	xfs_scrub_iput_deferred(sc);
 	if (sc->has_quotaofflock)
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 69eee2ffed29..93a4a0b22273 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -65,6 +65,12 @@ struct xfs_scrub_context {
 	bool				try_harder;
 	bool				has_quotaofflock;
 
+	/*
+	 * Do we own the current scrub freeze?  It is critical that we
+	 * release it before exiting to userspace!
+	 */
+	bool				fs_frozen;
+
 	/*
 	 * List of inodes which cannot be released (by scrub) until after the
 	 * scrub operation concludes because we'd have to do some work to the
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 245349d1e23f..b2b947a0e44a 100644
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
index 9d791f158dfe..c446d800bb79 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1445,6 +1445,42 @@ xfs_fs_unfreeze(
 	return 0;
 }
 
+/*
+ * Don't let userspace freeze while scrub has the filesystem frozen.  Note
+ * that freeze_super can free the xfs_mount, so we must be careful to recheck
+ * XFS_M before trying to access anything in the xfs_mount afterwards.
+ */
+STATIC int
+xfs_fs_freeze_super(
+	struct super_block	*sb)
+{
+	int			error;
+
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
+}
+
 STATIC int
 xfs_fs_show_options(
 	struct seq_file		*m,
@@ -1582,6 +1618,7 @@ xfs_mount_alloc(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
+	mutex_init(&mp->m_scrub_freeze);
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
@@ -1768,6 +1805,7 @@ xfs_fs_fill_super(
  out_free_fsname:
 	sb->s_fs_info = NULL;
 	xfs_free_fsname(mp);
+	mutex_destroy(&mp->m_scrub_freeze);
 	kfree(mp);
  out:
 	return error;
@@ -1800,6 +1838,19 @@ xfs_fs_put_super(
 
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
 
@@ -1846,6 +1897,8 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.freeze_super		= xfs_fs_freeze_super,
+	.thaw_super		= xfs_fs_thaw_super,
 };
 
 static struct file_system_type xfs_fs_type = {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index c08785cf83a9..1f0ae57d1e8c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -314,9 +314,12 @@ xfs_trans_alloc(
 
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
 

