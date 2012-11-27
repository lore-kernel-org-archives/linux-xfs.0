Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qARND3qs105001 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 17:13:03 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OFgAStZR6M8lBHyF for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 15:15:18 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/19] dentry: move to per-sb LRU locks
Date: Wed, 28 Nov 2012 10:14:29 +1100
Message-Id: <1354058086-27937-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1354058086-27937-1-git-send-email-david@fromorbit.com>
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
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
To: glommer@parallels.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

With the dentry LRUs being per-sb structures, there is no real need
for a global dentry_lru_lock. The locking can be made more
fine-grained by moving to a per-sb LRU lock, isolating the LRU
operations of different filesytsems completely from each other.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dcache.c        |   37 ++++++++++++++++++-------------------
 fs/super.c         |    1 +
 include/linux/fs.h |    4 +++-
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 2fc0daa..e0c97fe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -48,7 +48,7 @@
  *   - the dcache hash table
  * s_anon bl list spinlock protects:
  *   - the s_anon list (see __d_drop)
- * dcache_lru_lock protects:
+ * dentry->d_sb->s_dentry_lru_lock protects:
  *   - the dcache lru lists and counters
  * d_lock protects:
  *   - d_flags
@@ -63,7 +63,7 @@
  * Ordering:
  * dentry->d_inode->i_lock
  *   dentry->d_lock
- *     dcache_lru_lock
+ *     dentry->d_sb->s_dentry_lru_lock
  *     dcache_hash_bucket lock
  *     s_anon lock
  *
@@ -81,7 +81,6 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
-static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
@@ -320,11 +319,11 @@ static void dentry_unlink_inode(struct dentry * dentry)
 static void dentry_lru_add(struct dentry *dentry)
 {
 	if (list_empty(&dentry->d_lru)) {
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
 		this_cpu_inc(nr_dentry_unused);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 	}
 }
 
@@ -342,9 +341,9 @@ static void __dentry_lru_del(struct dentry *dentry)
 static void dentry_lru_del(struct dentry *dentry)
 {
 	if (!list_empty(&dentry->d_lru)) {
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		__dentry_lru_del(dentry);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 	}
 }
 
@@ -359,15 +358,15 @@ static void dentry_lru_prune(struct dentry *dentry)
 		if (dentry->d_flags & DCACHE_OP_PRUNE)
 			dentry->d_op->d_prune(dentry);
 
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 		__dentry_lru_del(dentry);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 	}
 }
 
 static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
 		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
@@ -375,7 +374,7 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 	} else {
 		list_move_tail(&dentry->d_lru, list);
 	}
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
 }
 
 /**
@@ -879,14 +878,14 @@ void prune_dcache_sb(struct super_block *sb, int count)
 	LIST_HEAD(tmp);
 
 relock:
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		dentry = list_entry(sb->s_dentry_lru.prev,
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
 		if (!spin_trylock(&dentry->d_lock)) {
-			spin_unlock(&dcache_lru_lock);
+			spin_unlock(&sb->s_dentry_lru_lock);
 			cpu_relax();
 			goto relock;
 		}
@@ -902,11 +901,11 @@ relock:
 			if (!--count)
 				break;
 		}
-		cond_resched_lock(&dcache_lru_lock);
+		cond_resched_lock(&sb->s_dentry_lru_lock);
 	}
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&sb->s_dentry_lru_lock);
 
 	shrink_dentry_list(&tmp);
 }
@@ -922,14 +921,14 @@ void shrink_dcache_sb(struct super_block *sb)
 {
 	LIST_HEAD(tmp);
 
-	spin_lock(&dcache_lru_lock);
+	spin_lock(&sb->s_dentry_lru_lock);
 	while (!list_empty(&sb->s_dentry_lru)) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
-		spin_unlock(&dcache_lru_lock);
+		spin_unlock(&sb->s_dentry_lru_lock);
 		shrink_dentry_list(&tmp);
-		spin_lock(&dcache_lru_lock);
+		spin_lock(&sb->s_dentry_lru_lock);
 	}
-	spin_unlock(&dcache_lru_lock);
+	spin_unlock(&sb->s_dentry_lru_lock);
 }
 EXPORT_SYMBOL(shrink_dcache_sb);
 
diff --git a/fs/super.c b/fs/super.c
index 12f1237..21abf02 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -182,6 +182,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 		INIT_HLIST_BL_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		INIT_LIST_HEAD(&s->s_dentry_lru);
+		spin_lock_init(&s->s_dentry_lru_lock);
 		INIT_LIST_HEAD(&s->s_inode_lru);
 		spin_lock_init(&s->s_inode_lru_lock);
 		INIT_LIST_HEAD(&s->s_mounts);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..0845283 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1262,7 +1262,9 @@ struct super_block {
 	struct list_head	s_files;
 #endif
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
-	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
+
+	/* s_dentry_lru_lock protects s_dentry_lru and s_nr_dentry_unused */
+	spinlock_t		s_dentry_lru_lock ____cacheline_aligned_in_smp;
 	struct list_head	s_dentry_lru;	/* unused dentry lru */
 	int			s_nr_dentry_unused;	/* # of dentry on lru */
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
