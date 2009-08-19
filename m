Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JIiOUL221130 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:44:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E38E14E5923
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8NZS86NV3utwsZh0 for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Message-Id: <20090819184511.968291288@bombadil.infradead.org>
Date: Wed, 19 Aug 2009 14:42:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] vfs: fix inode_init_always calling convention
References: <20090819184258.542698202@bombadil.infradead.org>
Content-Disposition: inline; filename=iget1
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

vfs: fix inode_init_always calling convention

Currently inode_init_always calls into ->destroy_inode if the additional
initialization fails.  That's not only counter-intuitive because
inode_init_always did not allocate the inode structure, but in case of
XFS it's actively harmful as ->destroy_inode might delete the inode from
a radix-tree that has never been added.  This in turn might end up
deleting the inode for the same inum that has been instanciated by
another process and cause lots of cause subtile problems.
    
Also in the case of re-initializing a reclaimable inode in XFS it would
free an inode we still want to keep alive.

backport of upstream commit 54e346215e4fe2ca8c94c54e546cc61902060510
    
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2009-08-15 22:27:03.922699982 -0300
+++ linux-2.6/fs/inode.c	2009-08-15 22:27:13.274661514 -0300
@@ -118,12 +118,11 @@ static void wake_up_inode(struct inode *
  * These are initializations that need to be done on every inode
  * allocation as the fields are not initialised by slab allocation.
  */
-struct inode *inode_init_always(struct super_block *sb, struct inode *inode)
+int inode_init_always(struct super_block *sb, struct inode *inode)
 {
 	static const struct address_space_operations empty_aops;
 	static struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
-
 	struct address_space *const mapping = &inode->i_data;
 
 	inode->i_sb = sb;
@@ -150,7 +149,7 @@ struct inode *inode_init_always(struct s
 	inode->dirtied_when = 0;
 
 	if (security_inode_alloc(inode))
-		goto out_free_inode;
+		goto out;
 
 	/* allocate and initialize an i_integrity */
 	if (ima_inode_alloc(inode))
@@ -189,16 +188,12 @@ struct inode *inode_init_always(struct s
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 
-	return inode;
+	return 0;
 
 out_free_security:
 	security_inode_free(inode);
-out_free_inode:
-	if (inode->i_sb->s_op->destroy_inode)
-		inode->i_sb->s_op->destroy_inode(inode);
-	else
-		kmem_cache_free(inode_cachep, (inode));
-	return NULL;
+out:
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(inode_init_always);
 
@@ -211,9 +206,18 @@ static struct inode *alloc_inode(struct 
 	else
 		inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);
 
-	if (inode)
-		return inode_init_always(sb, inode);
-	return NULL;
+	if (!inode)
+		return NULL;
+
+	if (unlikely(inode_init_always(sb, inode))) {
+		if (inode->i_sb->s_op->destroy_inode)
+			inode->i_sb->s_op->destroy_inode(inode);
+		else
+			kmem_cache_free(inode_cachep, inode);
+		return NULL;
+	}
+
+	return inode;
 }
 
 void destroy_inode(struct inode *inode)
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-15 22:27:04.378664366 -0300
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-15 22:27:13.274661514 -0300
@@ -63,6 +63,10 @@ xfs_inode_alloc(
 	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
 	if (!ip)
 		return NULL;
+	if (inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
 
 	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
@@ -104,17 +108,6 @@ xfs_inode_alloc(
 #ifdef XFS_DIR2_TRACE
 	ip->i_dir_trace = ktrace_alloc(XFS_DIR2_KTRACE_SIZE, KM_NOFS);
 #endif
-	/*
-	* Now initialise the VFS inode. We do this after the xfs_inode
-	* initialisation as internal failures will result in ->destroy_inode
-	* being called and that will pass down through the reclaim path and
-	* free the XFS inode. This path requires the XFS inode to already be
-	* initialised. Hence if this call fails, the xfs_inode has already
-	* been freed and we should not reference it at all in the error
-	* handling.
-	*/
-	if (!inode_init_always(mp->m_super, VFS_I(ip)))
-		return NULL;
 
 	/* prevent anyone from using this yet */
 	VFS_I(ip)->i_state = I_NEW|I_LOCK;
@@ -166,7 +159,7 @@ xfs_iget_cache_hit(
 		 * errors cleanly, then tag it so it can be set up correctly
 		 * later.
 		 */
-		if (!inode_init_always(mp->m_super, VFS_I(ip))) {
+		if (inode_init_always(mp->m_super, VFS_I(ip))) {
 			error = ENOMEM;
 			goto out_error;
 		}
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-08-15 22:27:04.486664052 -0300
+++ linux-2.6/include/linux/fs.h	2009-08-15 22:27:13.278697992 -0300
@@ -2135,7 +2135,7 @@ extern loff_t default_llseek(struct file
 
 extern loff_t vfs_llseek(struct file *file, loff_t offset, int origin);
 
-extern struct inode * inode_init_always(struct super_block *, struct inode *);
+extern int inode_init_always(struct super_block *, struct inode *);
 extern void inode_init_once(struct inode *);
 extern void inode_add_to_lists(struct super_block *, struct inode *);
 extern void iput(struct inode *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
