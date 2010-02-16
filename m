Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jbWd132014 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 917871D3895
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 41yQygPHsLFmZoaZ for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Message-Id: <20100216084651.956101538@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/10] quota: move code from sync_quota_sb into vfs_quota_sync
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=quota-cleanup-sync
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
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

Currenly sync_quota_sb does a lot of sync and truncate action that only
applies to "VFS" style quotas and is actively harmful for the sync
performance in XFS.  Move it into vfs_quota_sync and add a wait paramter
to ->quota_sync to tell if we need it or not.

My audit of the GFS2 code says it's also not needed given the way GFS2
implements quotas, but I'd be happy if this can get a detailed review.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-02-16 00:13:43.000000000 +0100
+++ linux-2.6/fs/quota/dquot.c	2010-02-16 00:19:51.642255742 +0100
@@ -564,7 +564,7 @@ out:
 }
 EXPORT_SYMBOL(dquot_scan_active);
 
-int vfs_quota_sync(struct super_block *sb, int type)
+int vfs_quota_sync(struct super_block *sb, int type, int wait)
 {
 	struct list_head *dirty;
 	struct dquot *dquot;
@@ -609,6 +609,33 @@ int vfs_quota_sync(struct super_block *s
 	spin_unlock(&dq_list_lock);
 	mutex_unlock(&dqopt->dqonoff_mutex);
 
+	if (!wait || (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE))
+		return 0;
+
+	/* This is not very clever (and fast) but currently I don't know about
+	 * any other simple way of getting quota data to disk and we must get
+	 * them there for userspace to be visible... */
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 1);
+	sync_blockdev(sb->s_bdev);
+
+	/*
+	 * Now when everything is written we can discard the pagecache so
+	 * that userspace sees the changes.
+	 */
+	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
+	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
+		if (type != -1 && cnt != type)
+			continue;
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
+		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex,
+				  I_MUTEX_QUOTA);
+		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
+		mutex_unlock(&sb_dqopt(sb)->files[cnt]->i_mutex);
+	}
+	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL(vfs_quota_sync);
Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-16 00:16:29.030004171 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-16 00:23:57.795005847 +0100
@@ -48,44 +48,6 @@ static int check_quotactl_permission(str
 	return security_quotactl(cmd, type, id, sb);
 }
 
-#ifdef CONFIG_QUOTA
-void sync_quota_sb(struct super_block *sb, int type)
-{
-	int cnt;
-
-	if (!sb->s_qcop || !sb->s_qcop->quota_sync)
-		return;
-
-	sb->s_qcop->quota_sync(sb, type);
-
-	if (sb_dqopt(sb)->flags & DQUOT_QUOTA_SYS_FILE)
-		return;
-	/* This is not very clever (and fast) but currently I don't know about
-	 * any other simple way of getting quota data to disk and we must get
-	 * them there for userspace to be visible... */
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
-	sync_blockdev(sb->s_bdev);
-
-	/*
-	 * Now when everything is written we can discard the pagecache so
-	 * that userspace sees the changes.
-	 */
-	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
-	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (type != -1 && cnt != type)
-			continue;
-		if (!sb_has_quota_active(sb, cnt))
-			continue;
-		mutex_lock_nested(&sb_dqopt(sb)->files[cnt]->i_mutex,
-				  I_MUTEX_QUOTA);
-		truncate_inode_pages(&sb_dqopt(sb)->files[cnt]->i_data, 0);
-		mutex_unlock(&sb_dqopt(sb)->files[cnt]->i_mutex);
-	}
-	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
-}
-#endif
-
 static int quota_sync_all(int type)
 {
 	struct super_block *sb;
@@ -101,6 +63,9 @@ static int quota_sync_all(int type)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (!sb->s_qcop || !sb->s_qcop->quota_sync)
+			continue;
+
 		/* This test just improves performance so it needn't be
 		 * reliable... */
 		for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
@@ -119,7 +84,7 @@ restart:
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
 		if (sb->s_root)
-			sync_quota_sb(sb, type);
+			sb->s_qcop->quota_sync(sb, type, 1);
 		up_read(&sb->s_umount);
 		spin_lock(&sb_lock);
 		if (__put_super_and_need_restart(sb))
@@ -306,8 +271,7 @@ static int do_quotactl(struct super_bloc
 	case Q_SYNC:
 		if (!sb->s_qcop->quota_sync)
 			return -ENOSYS;
-		sync_quota_sb(sb, type);
-		return 0;
+		return sb->s_qcop->quota_sync(sb, type, 1);
 	case Q_XQUOTAON:
 	case Q_XQUOTAOFF:
 	case Q_XQUOTARM:
Index: linux-2.6/fs/sync.c
===================================================================
--- linux-2.6.orig/fs/sync.c	2010-02-16 00:13:43.000000000 +0100
+++ linux-2.6/fs/sync.c	2010-02-16 00:21:32.283004241 +0100
@@ -34,14 +34,14 @@ static int __sync_filesystem(struct supe
 	if (!sb->s_bdi)
 		return 0;
 
-	/* Avoid doing twice syncing and cache pruning for quota sync */
-	if (!wait) {
-		writeout_quota_sb(sb, -1);
-		writeback_inodes_sb(sb);
-	} else {
-		sync_quota_sb(sb, -1);
+	if (sb->s_qcop && sb->s_qcop->quota_sync)
+		sb->s_qcop->quota_sync(sb, -1, wait);
+
+	if (wait)
 		sync_inodes_sb(sb);
-	}
+	else
+		writeback_inodes_sb(sb);
+
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, wait);
 	return __sync_blockdev(sb->s_bdev, wait);
Index: linux-2.6/include/linux/quotaops.h
===================================================================
--- linux-2.6.orig/include/linux/quotaops.h	2010-02-16 00:16:15.361004730 +0100
+++ linux-2.6/include/linux/quotaops.h	2010-02-16 00:19:15.186253926 +0100
@@ -19,13 +19,6 @@ static inline struct quota_info *sb_dqop
 /*
  * declaration of quota_function calls in kernel.
  */
-void sync_quota_sb(struct super_block *sb, int type);
-static inline void writeout_quota_sb(struct super_block *sb, int type)
-{
-	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, type);
-}
-
 int dquot_initialize(struct inode *inode, int type);
 int dquot_drop(struct inode *inode);
 struct dquot *dqget(struct super_block *sb, unsigned int id, int type);
@@ -64,7 +57,7 @@ int vfs_quota_on_mount(struct super_bloc
  	int format_id, int type);
 int vfs_quota_off(struct super_block *sb, int type, int remount);
 int vfs_quota_disable(struct super_block *sb, int type, unsigned int flags);
-int vfs_quota_sync(struct super_block *sb, int type);
+int vfs_quota_sync(struct super_block *sb, int type, int wait);
 int vfs_get_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int vfs_set_dqinfo(struct super_block *sb, int type, struct if_dqinfo *ii);
 int vfs_get_dqblk(struct super_block *sb, int type, qid_t id, struct if_dqblk *di);
@@ -333,14 +326,6 @@ static inline void vfs_dq_free_inode(str
 {
 }
 
-static inline void sync_quota_sb(struct super_block *sb, int type)
-{
-}
-
-static inline void writeout_quota_sb(struct super_block *sb, int type)
-{
-}
-
 static inline int vfs_dq_off(struct super_block *sb, int remount)
 {
 	return 0;
Index: linux-2.6/include/linux/quota.h
===================================================================
--- linux-2.6.orig/include/linux/quota.h	2010-02-16 00:19:54.595004101 +0100
+++ linux-2.6/include/linux/quota.h	2010-02-16 00:20:00.855004381 +0100
@@ -324,7 +324,7 @@ struct dquot_operations {
 struct quotactl_ops {
 	int (*quota_on)(struct super_block *, int, int, char *, int);
 	int (*quota_off)(struct super_block *, int, int);
-	int (*quota_sync)(struct super_block *, int);
+	int (*quota_sync)(struct super_block *, int, int);
 	int (*get_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*set_info)(struct super_block *, int, struct if_dqinfo *);
 	int (*get_dqblk)(struct super_block *, int, qid_t, struct if_dqblk *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
