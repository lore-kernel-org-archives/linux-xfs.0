Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKZ8WS125641 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:35:08 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id eSmorujzWxnWXi9B for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:35:06 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 6/8] xfs: Use generic writers counter instead of
	m_active_trans counter
Date: Fri, 20 Jan 2012 21:34:44 +0100
Message-Id: <1327091686-23177-7-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org

m_active_trans counter is racy wrt filesystem freezing. The patch replaces it
with generic counter of running transactions which is properly synchronized
with filesystem freezing. Things are a bit more complex because we need to log
a dummy transaction and free block counters after the filesystem is frozen so
we need to pass information to _xfs_trans_alloc() whether the transaction is
part of filesystem freezing or not.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_fsops.c |    5 +++--
 fs/xfs/xfs_fsops.h |    2 +-
 fs/xfs/xfs_iomap.c |    4 ++--
 fs/xfs/xfs_mount.c |    2 +-
 fs/xfs/xfs_mount.h |    2 --
 fs/xfs/xfs_super.c |    3 +--
 fs/xfs/xfs_sync.c  |   13 +++----------
 fs/xfs/xfs_trans.c |   19 ++++++++++++-------
 fs/xfs/xfs_trans.h |    3 ++-
 9 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 1c6fdeb..503fdfa 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -645,12 +645,13 @@ out:
  */
 int
 xfs_fs_log_dummy(
-	xfs_mount_t	*mp)
+	xfs_mount_t	*mp,
+	bool		for_freeze)
 {
 	xfs_trans_t	*tp;
 	int		error;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP, for_freeze);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 1b6a98b..4d6253e 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern int xfs_fs_log_dummy(struct xfs_mount *mp);
+extern int xfs_fs_log_dummy(struct xfs_mount *mp, bool for_freeze);
 
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9afa282..fd47f6e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -679,8 +679,8 @@ xfs_iomap_write_unwritten(
 		 * the same inode that we complete here and might deadlock
 		 * on the iolock.
 		 */
-		xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE, KM_NOFS);
+		tp = _xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE,
+				KM_NOFS, false);
 		tp->t_flags |= XFS_TRANS_RESERVE;
 		error = xfs_trans_reserve(tp, resblks,
 				XFS_WRITE_LOG_RES(mp), 0,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..74a93c9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1572,7 +1572,7 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
 		return 0;
 
-	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP);
+	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_COUNT, KM_SLEEP, true);
 	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
 					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bb24dac..1317018 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -195,7 +195,6 @@ typedef struct xfs_mount {
 	uint			m_chsize;	/* size of next field */
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
-	atomic_t		m_active_trans;	/* number trans frozen */
 #ifdef HAVE_PERCPU_SB
 	xfs_icsb_cnts_t __percpu *m_sb_cnts;	/* per-cpu superblock counters */
 	unsigned long		m_icsb_counters; /* disabled per-cpu counters */
@@ -312,7 +311,6 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
 #define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
-#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
 
 /*
  * Flags for xfs_mountfs
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3eca58f..2c333be 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1242,7 +1242,7 @@ xfs_fs_freeze(
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return -xfs_fs_log_dummy(mp);
+	return -xfs_fs_log_dummy(mp, true);
 }
 
 STATIC int
@@ -1329,7 +1329,6 @@ xfs_fs_fill_super(
 
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index aa3dc1a..24f4d7c 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -373,7 +373,7 @@ xfs_quiesce_data(
 
 	/* mark the log as covered if needed */
 	if (xfs_log_need_covered(mp))
-		error2 = xfs_fs_log_dummy(mp);
+		error2 = xfs_fs_log_dummy(mp, false);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
@@ -421,18 +421,11 @@ xfs_quiesce_attr(
 	int	error = 0;
 
 	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
+	sb_wait_write(mp->m_super, SB_FREEZE_TRANS);
 
 	/* flush inodes and push all remaining buffers out to disk */
 	xfs_quiesce_fs(mp);
 
-	/*
-	 * Just warn here till VFS can correctly support
-	 * read-only remount without racing.
-	 */
-	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
-
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp);
 	if (error)
@@ -467,7 +460,7 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
+			error = xfs_fs_log_dummy(mp, false);
 		else
 			xfs_log_force(mp, 0);
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1f35b2f..e97014b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -577,24 +577,28 @@ xfs_trans_alloc(
 	xfs_mount_t	*mp,
 	uint		type)
 {
-	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type, KM_SLEEP);
+	return _xfs_trans_alloc(mp, type, KM_SLEEP, false);
 }
 
 xfs_trans_t *
 _xfs_trans_alloc(
 	xfs_mount_t	*mp,
 	uint		type,
-	uint		memflags)
+	uint		memflags,
+	bool		freezing)
 {
 	xfs_trans_t	*tp;
 
-	atomic_inc(&mp->m_active_trans);
-
+	if (!freezing)
+		sb_start_write(mp->m_super, SB_FREEZE_TRANS);
+	else
+		WARN_ON(xfs_test_for_freeze(mp) != SB_FREEZE_TRANS);
 	tp = kmem_zone_zalloc(xfs_trans_zone, memflags);
 	tp->t_magic = XFS_TRANS_MAGIC;
 	tp->t_type = type;
 	tp->t_mountp = mp;
+	if (freezing)
+		tp->t_flags |= XFS_TRANS_FREEZING;
 	INIT_LIST_HEAD(&tp->t_items);
 	INIT_LIST_HEAD(&tp->t_busy);
 	return tp;
@@ -611,7 +615,8 @@ xfs_trans_free(
 	xfs_alloc_busy_sort(&tp->t_busy);
 	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
-	atomic_dec(&tp->t_mountp->m_active_trans);
+	if (!(tp->t_flags & XFS_TRANS_FREEZING))
+		sb_end_write(tp->t_mountp->m_super, SB_FREEZE_TRANS);
 	xfs_trans_free_dqinfo(tp);
 	kmem_zone_free(xfs_trans_zone, tp);
 }
@@ -654,7 +659,7 @@ xfs_trans_dup(
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
-	atomic_inc(&tp->t_mountp->m_active_trans);
+	sb_dup_write(tp->t_mountp->m_super, SB_FREEZE_TRANS);
 	return ntp;
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3ae713c..8a04d8e 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -180,6 +180,7 @@ struct xfs_log_item_desc {
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
+#define XFS_TRANS_FREEZING	0x40	/* can happen on frozen filesystem */
 
 /*
  * Values for call flags parameter.
@@ -448,7 +449,7 @@ typedef struct xfs_trans {
  * XFS transaction mechanism exported interfaces.
  */
 xfs_trans_t	*xfs_trans_alloc(struct xfs_mount *, uint);
-xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint);
+xfs_trans_t	*_xfs_trans_alloc(struct xfs_mount *, uint, uint, bool);
 xfs_trans_t	*xfs_trans_dup(xfs_trans_t *);
 int		xfs_trans_reserve(xfs_trans_t *, uint, uint, uint,
 				  uint, uint);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
