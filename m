Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74EHklW171003 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 09:17:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D28641D5215B
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 07:18:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2usWilneZ2HMYnlG for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 07:18:36 -0700 (PDT)
Message-Id: <20090804141834.850853000@bombadil.infradead.org>
Date: Tue, 04 Aug 2009 10:15:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] fix inode_init_always calling convention
References: <20090804141554.992235000@bombadil.infradead.org>
Content-Disposition: inline; filename=change-inode_init_always
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Currently inode_init_always calls into ->destroy_inode if the additional
initialization fails.  That's not only counter-intuitive because
inode_init_always did not allocate the inode structure, but in case of
XFS it's actively harmful as ->destroy_inode might delete the inode from
a radix-tree that has never been added.  This in turn might end up
deleting the inode for the same inum that has been instanciated by
another process and cause lots of cause subtile problems.

Also in the case of re-initializing a reclaimable inode in XFS it would
free an inode we still want to keep alive.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2009-08-03 01:16:04.254556370 +0200
+++ linux-2.6/fs/inode.c	2009-08-03 01:23:11.135532251 +0200
@@ -120,12 +120,11 @@ static void wake_up_inode(struct inode *
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
@@ -152,7 +151,7 @@ struct inode *inode_init_always(struct s
 	inode->dirtied_when = 0;
 
 	if (security_inode_alloc(inode))
-		goto out_free_inode;
+		goto out;
 
 	/* allocate and initialize an i_integrity */
 	if (ima_inode_alloc(inode))
@@ -198,16 +197,12 @@ struct inode *inode_init_always(struct s
 	inode->i_fsnotify_mask = 0;
 #endif
 
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
 
@@ -220,9 +215,17 @@ static struct inode *alloc_inode(struct 
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
+	}
+
+	return inode;
 }
 
 void destroy_inode(struct inode *inode)
Index: linux-2.6/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_iget.c	2009-08-03 01:16:22.510806794 +0200
+++ linux-2.6/fs/xfs/xfs_iget.c	2009-08-03 01:23:29.878784477 +0200
@@ -64,6 +64,10 @@ xfs_inode_alloc(
 	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
 	if (!ip)
 		return NULL;
+	if (inode_init_always(mp->m_super, VFS_I(ip))) {
+		kmem_zone_free(xfs_inode_zone, ip);
+		return NULL;
+	}
 
 	ASSERT(atomic_read(&ip->i_iocount) == 0);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
@@ -105,17 +109,6 @@ xfs_inode_alloc(
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
@@ -190,7 +183,7 @@ xfs_iget_cache_hit(
 		spin_unlock(&ip->i_flags_lock);
 		read_unlock(&pag->pag_ici_lock);
 
-		if (unlikely(!inode_init_always(mp->m_super, inode))) {
+		if (unlikely(inode_init_always(mp->m_super, inode))) {
 			/*
 			 * Re-initializing the inode failed, and we are in deep
 			 * trouble.  Try to re-add it to the reclaim list.
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-08-03 01:16:21.186539128 +0200
+++ linux-2.6/include/linux/fs.h	2009-08-03 01:23:11.131532230 +0200
@@ -2136,7 +2136,7 @@ extern loff_t default_llseek(struct file
 
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
