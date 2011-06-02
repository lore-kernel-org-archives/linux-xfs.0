Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5271l5J180579 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 02:01:48 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3FFD1ED1909
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 00:01:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UaWFcLua5hmuLZsL for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 00:01:45 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/12] inode: move to per-sb LRU locks
Date: Thu,  2 Jun 2011 17:01:02 +1000
Message-Id: <1306998067-27659-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-1-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

With the inode LRUs moving to per-sb structures, there is no longer
a need for a global inode_lru_lock. The locking can be made more
fine-grained by moving to a per-sb LRU lock, isolating the LRU
operations of different filesytsems completely from each other.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c         |   27 +++++++++++++--------------
 fs/super.c         |    1 +
 include/linux/fs.h |    3 ++-
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e039115..667a29c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -33,7 +33,7 @@
  *
  * inode->i_lock protects:
  *   inode->i_state, inode->i_hash, __iget()
- * inode_lru_lock protects:
+ * inode->i_sb->s_inode_lru_lock protects:
  *   inode->i_sb->s_inode_lru, inode->i_lru
  * inode_sb_list_lock protects:
  *   sb->s_inodes, inode->i_sb_list
@@ -46,7 +46,7 @@
  *
  * inode_sb_list_lock
  *   inode->i_lock
- *     inode_lru_lock
+ *     inode->i_sb->s_inode_lru_lock
  *
  * inode_wb_list_lock
  *   inode->i_lock
@@ -64,8 +64,6 @@ static unsigned int i_hash_shift __read_mostly;
 static struct hlist_head *inode_hashtable __read_mostly;
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
-static DEFINE_SPINLOCK(inode_lru_lock);
-
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_sb_list_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_wb_list_lock);
 
@@ -342,24 +340,24 @@ EXPORT_SYMBOL(ihold);
 
 static void inode_lru_list_add(struct inode *inode)
 {
-	spin_lock(&inode_lru_lock);
+	spin_lock(&inode->i_sb->s_inode_lru_lock);
 	if (list_empty(&inode->i_lru)) {
 		list_add(&inode->i_lru, &inode->i_sb->s_inode_lru);
 		inode->i_sb->s_nr_inodes_unused++;
 		this_cpu_inc(nr_unused);
 	}
-	spin_unlock(&inode_lru_lock);
+	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
 static void inode_lru_list_del(struct inode *inode)
 {
-	spin_lock(&inode_lru_lock);
+	spin_lock(&inode->i_sb->s_inode_lru_lock);
 	if (!list_empty(&inode->i_lru)) {
 		list_del_init(&inode->i_lru);
 		inode->i_sb->s_nr_inodes_unused--;
 		this_cpu_dec(nr_unused);
 	}
-	spin_unlock(&inode_lru_lock);
+	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
 /**
@@ -608,7 +606,8 @@ static int can_unuse(struct inode *inode)
 
 /*
  * Scan `goal' inodes on the unused list for freeable ones. They are moved to a
- * temporary list and then are freed outside inode_lru_lock by dispose_list().
+ * temporary list and then are freed outside sb->s_inode_lru_lock by
+ * dispose_list().
  *
  * Any inodes which are pinned purely because of attached pagecache have their
  * pagecache removed.  If the inode has metadata buffers attached to
@@ -628,7 +627,7 @@ static void shrink_icache_sb(struct super_block *sb, int *nr_to_scan)
 	int nr_scanned;
 	unsigned long reap = 0;
 
-	spin_lock(&inode_lru_lock);
+	spin_lock(&sb->s_inode_lru_lock);
 	for (nr_scanned = *nr_to_scan; nr_scanned >= 0; nr_scanned--) {
 		struct inode *inode;
 
@@ -638,7 +637,7 @@ static void shrink_icache_sb(struct super_block *sb, int *nr_to_scan)
 		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
 
 		/*
-		 * we are inverting the inode_lru_lock/inode->i_lock here,
+		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
 		 * so use a trylock. If we fail to get the lock, just move the
 		 * inode to the back of the list so we don't spin on it.
 		 */
@@ -670,12 +669,12 @@ static void shrink_icache_sb(struct super_block *sb, int *nr_to_scan)
 		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
 			__iget(inode);
 			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_lru_lock);
+			spin_unlock(&sb->s_inode_lru_lock);
 			if (remove_inode_buffers(inode))
 				reap += invalidate_mapping_pages(&inode->i_data,
 								0, -1);
 			iput(inode);
-			spin_lock(&inode_lru_lock);
+			spin_lock(&sb->s_inode_lru_lock);
 
 			if (inode != list_entry(sb->s_inode_lru.next,
 						struct inode, i_lru))
@@ -700,7 +699,7 @@ static void shrink_icache_sb(struct super_block *sb, int *nr_to_scan)
 		__count_vm_events(KSWAPD_INODESTEAL, reap);
 	else
 		__count_vm_events(PGINODESTEAL, reap);
-	spin_unlock(&inode_lru_lock);
+	spin_unlock(&sb->s_inode_lru_lock);
 	*nr_to_scan = nr_scanned;
 
 	dispose_list(&freeable);
diff --git a/fs/super.c b/fs/super.c
index ef7caf7..9c3fa1f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -78,6 +78,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		INIT_LIST_HEAD(&s->s_inode_lru);
+		spin_lock_init(&s->s_inode_lru_lock);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a96071d..bbd478e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1393,7 +1393,8 @@ struct super_block {
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
-	/* inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
+	/* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
+	spinlock_t		s_inode_lru_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_inode_lru;		/* unused inode lru */
 	int			s_nr_inodes_unused;	/* # of inodes on lru */
 
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
