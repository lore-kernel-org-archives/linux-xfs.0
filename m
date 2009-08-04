Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n74EHk2k171005 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 09:17:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 099753A47AF
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 07:18:36 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zxuv4JhAKHXzzosq for
	<xfs@oss.sgi.com>; Tue, 04 Aug 2009 07:18:36 -0700 (PDT)
Message-Id: <20090804141836.606829000@bombadil.infradead.org>
Date: Tue, 04 Aug 2009 10:15:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] add __destroy_inode
References: <20090804141554.992235000@bombadil.infradead.org>
Content-Disposition: inline; filename=add-__destroy_inode
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

When we want to tear down an inode that lost the add to the cache race
in XFS we must not call into ->destroy_inode because that would delete
the inode that won the race from the inode cache radix tree.

This patch provides the __destroy_inode helper needed to fix this,
the actual fix will be in th next patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2009-08-04 16:01:18.766801320 +0200
+++ linux-2.6/fs/inode.c	2009-08-04 16:01:37.281556243 +0200
@@ -228,7 +228,7 @@ static struct inode *alloc_inode(struct 
 	return inode;
 }
 
-void destroy_inode(struct inode *inode)
+void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	ima_inode_free(inode);
@@ -240,13 +240,17 @@ void destroy_inode(struct inode *inode)
 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
 		posix_acl_release(inode->i_default_acl);
 #endif
+}
+EXPORT_SYMBOL(__destroy_inode);
+
+void destroy_inode(struct inode *inode)
+{
+	__destroy_inode(inode);
 	if (inode->i_sb->s_op->destroy_inode)
 		inode->i_sb->s_op->destroy_inode(inode);
 	else
 		kmem_cache_free(inode_cachep, (inode));
 }
-EXPORT_SYMBOL(destroy_inode);
-
 
 /*
  * These are initializations that only need to be done
Index: linux-2.6/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-04 15:59:38.705782128 +0200
+++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-04 16:01:20.157556334 +0200
@@ -322,8 +322,11 @@ static inline struct inode *VFS_I(struct
  */
 static inline void xfs_destroy_inode(struct xfs_inode *ip)
 {
-	make_bad_inode(VFS_I(ip));
-	return destroy_inode(VFS_I(ip));
+	struct inode *inode = VFS_I(ip);
+
+	make_bad_inode(inode);
+	__destroy_inode(inode);
+	inode->i_sb->s_op->destroy_inode(inode);
 }
 
 /*
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-08-04 16:01:18.770804693 +0200
+++ linux-2.6/include/linux/fs.h	2009-08-04 16:01:20.159539128 +0200
@@ -2163,6 +2163,7 @@ extern void __iget(struct inode * inode)
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
+extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
