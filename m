Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:09:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE96P6016909
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:09:12 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 693DA1ADE15B
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:36 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 9sSjXqDtQk78L2ZX for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:10:36 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] Inode: Allow external list initialisation
Date: Sun, 14 Sep 2008 00:10:26 +1000
Message-Id: <1221315027-29951-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1221315027-29951-1-git-send-email-david@fromorbit.com>
References: <1221315027-29951-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

To allow XFS to combine the XFS and linux inodes into a single
structure, we need to drive inode lookup from the XFS inode cache,
not the generic inode cache. This means that we need initialise a
struct inode from a context outside alloc_inode() as it is no longer
used by XFS.

After inode allocation and initialisation, we need to add the inode
to the superblock list, the in-use list, hash it and do some
accounting. This all needs to be done with the inode_lock held and
there are already several places in fs/inode.c that do this list
manipulation.  Factor out the common code, add a locking wrapper and
export the function so ti can be called from XFS.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/inode.c         |   67 +++++++++++++++++++++++++++++++++++----------------
 include/linux/fs.h |    1 +
 2 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e7ee999..fbcf6c5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -550,6 +550,49 @@ repeat:
 	return node ? inode : NULL;
 }
 
+static unsigned long hash(struct super_block *sb, unsigned long hashval)
+{
+	unsigned long tmp;
+
+	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
+			L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
+	return tmp & I_HASHMASK;
+}
+
+static inline void
+__inode_add_to_lists(struct super_block *sb, struct hlist_head *head,
+			struct inode *inode)
+{
+	inodes_stat.nr_inodes++;
+	list_add(&inode->i_list, &inode_in_use);
+	list_add(&inode->i_sb_list, &sb->s_inodes);
+	if (head)
+		hlist_add_head(&inode->i_hash, head);
+}
+
+/**
+ * inode_add_to_lists - add a new inode to relevant lists
+ * @sb		- superblock inode belongs to.
+ * @inode	- inode to mark in use
+ *
+ * When an inode is allocated it needs to be accounted for, added to the in use
+ * list, the owning superblock and the inode hash. This needs to be done under
+ * the inode_lock, so export a function to do this rather than the inode lock
+ * itself. We calculate the hash list to add to here so it is all internal
+ * which requires the caller to have already set up the inode number in the
+ * inode to add.
+ */
+void inode_add_to_lists(struct super_block *sb, struct inode *inode)
+{
+	struct hlist_head *head = inode_hashtable + hash(sb, inode->i_ino);
+
+	spin_lock(&inode_lock);
+	__inode_add_to_lists(sb, head, inode);
+	spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL_GPL(inode_add_to_lists);
+
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -577,9 +620,7 @@ struct inode *new_inode(struct super_block *sb)
 	inode = alloc_inode(sb);
 	if (inode) {
 		spin_lock(&inode_lock);
-		inodes_stat.nr_inodes++;
-		list_add(&inode->i_list, &inode_in_use);
-		list_add(&inode->i_sb_list, &sb->s_inodes);
+		__inode_add_to_lists(sb, NULL, inode);
 		inode->i_ino = ++last_ino;
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
@@ -638,10 +679,7 @@ static struct inode * get_new_inode(struct super_block *sb, struct hlist_head *h
 			if (set(inode, data))
 				goto set_failed;
 
-			inodes_stat.nr_inodes++;
-			list_add(&inode->i_list, &inode_in_use);
-			list_add(&inode->i_sb_list, &sb->s_inodes);
-			hlist_add_head(&inode->i_hash, head);
+			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_LOCK|I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -687,10 +725,7 @@ static struct inode * get_new_inode_fast(struct super_block *sb, struct hlist_he
 		old = find_inode_fast(sb, head, ino);
 		if (!old) {
 			inode->i_ino = ino;
-			inodes_stat.nr_inodes++;
-			list_add(&inode->i_list, &inode_in_use);
-			list_add(&inode->i_sb_list, &sb->s_inodes);
-			hlist_add_head(&inode->i_hash, head);
+			__inode_add_to_lists(sb, head, inode);
 			inode->i_state = I_LOCK|I_NEW;
 			spin_unlock(&inode_lock);
 
@@ -714,16 +749,6 @@ static struct inode * get_new_inode_fast(struct super_block *sb, struct hlist_he
 	return inode;
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
-{
-	unsigned long tmp;
-
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-			L1_CACHE_BYTES;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
-	return tmp & I_HASHMASK;
-}
-
 /**
  *	iunique - get a unique inode number
  *	@sb: superblock
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ce55983..cf65c71 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1813,6 +1813,7 @@ extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
 extern struct inode * inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
+extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);
 extern struct inode * igrab(struct inode *);
 extern ino_t iunique(struct super_block *, ino_t);
-- 
1.5.6
