Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 978847F57
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84D76304064
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 03:58:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uhicvmlzMASecogE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 03:58:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/12] quota: Use function to provide i_dquot pointers
Date: Tue,  4 Nov 2014 12:19:46 +0100
Message-Id: <1415099993-18034-6-git-send-email-jack@suse.cz>
In-Reply-To: <1415099993-18034-1-git-send-email-jack@suse.cz>
References: <1415099993-18034-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

i_dquot array is used by relatively few filesystems (ext?, ocfs2, jfs,
reiserfs) so it is beneficial to move this array to fs-private part of
the inode. We cannot just pass quota pointers from filesystems to quota
functions because during quotaon and quotaoff we have to traverse list
of all inodes and manipulate i_dquot pointers for each inode. So we
provide a function which generic quota code can use to get pointer to
the i_dquot array from the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c   | 54 +++++++++++++++++++++++++++++++-----------------------
 include/linux/fs.h |  1 +
 2 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8a6b95e9bf3d..8144ff2b561d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -893,6 +893,14 @@ out:
 }
 EXPORT_SYMBOL(dqget);
 
+static inline struct dquot **i_dquot(struct inode *inode)
+{
+	/* Temporary workaround until all filesystems are converted. */
+	if (!inode->i_sb->s_op->get_dquots)
+		return inode->i_dquot;
+	return inode->i_sb->s_op->get_dquots(inode);
+}
+
 static int dqinit_needed(struct inode *inode, int type)
 {
 	int cnt;
@@ -900,9 +908,9 @@ static int dqinit_needed(struct inode *inode, int type)
 	if (IS_NOQUOTA(inode))
 		return 0;
 	if (type != -1)
-		return !inode->i_dquot[type];
+		return !i_dquot(inode)[type];
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		if (!inode->i_dquot[cnt])
+		if (!i_dquot(inode)[cnt])
 			return 1;
 	return 0;
 }
@@ -965,9 +973,9 @@ static void add_dquot_ref(struct super_block *sb, int type)
 static void remove_inode_dquot_ref(struct inode *inode, int type,
 				   struct list_head *tofree_head)
 {
-	struct dquot *dquot = inode->i_dquot[type];
+	struct dquot *dquot = i_dquot(inode)[type];
 
-	inode->i_dquot[type] = NULL;
+	i_dquot(inode)[type] = NULL;
 	if (!dquot)
 		return;
 
@@ -1402,7 +1410,7 @@ static void __dquot_initialize(struct inode *inode, int type)
 		 * we check it without locking here to avoid unnecessary
 		 * dqget()/dqput() calls.
 		 */
-		if (inode->i_dquot[cnt])
+		if (i_dquot(inode)[cnt])
 			continue;
 		init_needed = 1;
 
@@ -1433,8 +1441,8 @@ static void __dquot_initialize(struct inode *inode, int type)
 		/* We could race with quotaon or dqget() could have failed */
 		if (!got[cnt])
 			continue;
-		if (!inode->i_dquot[cnt]) {
-			inode->i_dquot[cnt] = got[cnt];
+		if (!i_dquot(inode)[cnt]) {
+			i_dquot(inode)[cnt] = got[cnt];
 			got[cnt] = NULL;
 			/*
 			 * Make quota reservation system happy if someone
@@ -1442,7 +1450,7 @@ static void __dquot_initialize(struct inode *inode, int type)
 			 */
 			rsv = inode_get_rsv_space(inode);
 			if (unlikely(rsv))
-				dquot_resv_space(inode->i_dquot[cnt], rsv);
+				dquot_resv_space(i_dquot(inode)[cnt], rsv);
 		}
 	}
 out_err:
@@ -1472,8 +1480,8 @@ static void __dquot_drop(struct inode *inode)
 
 	spin_lock(&dq_data_lock);
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		put[cnt] = inode->i_dquot[cnt];
-		inode->i_dquot[cnt] = NULL;
+		put[cnt] = i_dquot(inode)[cnt];
+		i_dquot(inode)[cnt] = NULL;
 	}
 	spin_unlock(&dq_data_lock);
 	dqput_all(put);
@@ -1494,7 +1502,7 @@ void dquot_drop(struct inode *inode)
 	 * add quota pointers back anyway.
 	 */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
+		if (i_dquot(inode)[cnt])
 			break;
 	}
 
@@ -1595,7 +1603,7 @@ int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags)
 {
 	int cnt, ret = 0, index;
 	struct dquot_warn warn[MAXQUOTAS];
-	struct dquot **dquots = inode->i_dquot;
+	struct dquot **dquots = i_dquot(inode);
 	int reserve = flags & DQUOT_SPACE_RESERVE;
 
 	if (!dquot_active(inode)) {
@@ -1647,7 +1655,7 @@ int dquot_alloc_inode(struct inode *inode)
 {
 	int cnt, ret = 0, index;
 	struct dquot_warn warn[MAXQUOTAS];
-	struct dquot * const *dquots = inode->i_dquot;
+	struct dquot * const *dquots = i_dquot(inode);
 
 	if (!dquot_active(inode))
 		return 0;
@@ -1696,14 +1704,14 @@ int dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
-			dquot_claim_reserved_space(inode->i_dquot[cnt],
+		if (i_dquot(inode)[cnt])
+			dquot_claim_reserved_space(i_dquot(inode)[cnt],
 							number);
 	}
 	/* Update inode bytes */
 	inode_claim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
-	mark_all_dquot_dirty(inode->i_dquot);
+	mark_all_dquot_dirty(i_dquot(inode));
 	srcu_read_unlock(&dquot_srcu, index);
 	return 0;
 }
@@ -1725,14 +1733,14 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
 	spin_lock(&dq_data_lock);
 	/* Claim reserved quotas to allocated quotas */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
-		if (inode->i_dquot[cnt])
-			dquot_reclaim_reserved_space(inode->i_dquot[cnt],
+		if (i_dquot(inode)[cnt])
+			dquot_reclaim_reserved_space(i_dquot(inode)[cnt],
 						     number);
 	}
 	/* Update inode bytes */
 	inode_reclaim_rsv_space(inode, number);
 	spin_unlock(&dq_data_lock);
-	mark_all_dquot_dirty(inode->i_dquot);
+	mark_all_dquot_dirty(i_dquot(inode));
 	srcu_read_unlock(&dquot_srcu, index);
 	return;
 }
@@ -1745,7 +1753,7 @@ void __dquot_free_space(struct inode *inode, qsize_t number, int flags)
 {
 	unsigned int cnt;
 	struct dquot_warn warn[MAXQUOTAS];
-	struct dquot **dquots = inode->i_dquot;
+	struct dquot **dquots = i_dquot(inode);
 	int reserve = flags & DQUOT_SPACE_RESERVE, index;
 
 	if (!dquot_active(inode)) {
@@ -1788,7 +1796,7 @@ void dquot_free_inode(struct inode *inode)
 {
 	unsigned int cnt;
 	struct dquot_warn warn[MAXQUOTAS];
-	struct dquot * const *dquots = inode->i_dquot;
+	struct dquot * const *dquots = i_dquot(inode);
 	int index;
 
 	if (!dquot_active(inode))
@@ -1865,7 +1873,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 		if (!sb_has_quota_active(inode->i_sb, cnt))
 			continue;
 		is_valid[cnt] = 1;
-		transfer_from[cnt] = inode->i_dquot[cnt];
+		transfer_from[cnt] = i_dquot(inode)[cnt];
 		ret = check_idq(transfer_to[cnt], 1, &warn_to[cnt]);
 		if (ret)
 			goto over_quota;
@@ -1901,7 +1909,7 @@ int __dquot_transfer(struct inode *inode, struct dquot **transfer_to)
 		dquot_incr_space(transfer_to[cnt], cur_space);
 		dquot_resv_space(transfer_to[cnt], rsv_space);
 
-		inode->i_dquot[cnt] = transfer_to[cnt];
+		i_dquot(inode)[cnt] = transfer_to[cnt];
 	}
 	spin_unlock(&dq_data_lock);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 770b466f2b44..97b0fec13168 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1566,6 +1566,7 @@ struct super_operations {
 #ifdef CONFIG_QUOTA
 	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	struct dquot **(*get_dquots)(struct inode *);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	long (*nr_cached_objects)(struct super_block *, int);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
