Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JIiNZk221128 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:44:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02F3514E5920
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xHBWoZ9kFiWrQxdX for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Message-Id: <20090819184512.134691786@bombadil.infradead.org>
Date: Wed, 19 Aug 2009 14:43:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/4] vfs: add __destroy_inode
References: <20090819184258.542698202@bombadil.infradead.org>
Content-Disposition: inline; filename=iget2
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

When we want to tear down an inode that lost the add to the cache race
in XFS we must not call into ->destroy_inode because that would delete
the inode that won the race from the inode cache radix tree.
    
This patch provides the __destroy_inode helper needed to fix this,
the actual fix will be in th next patch.  As XFS was the only reason
destroy_inode was exported we shift the export to the new __destroy_inode.
    
backport of upstream commit 2e00c97e2c1d2ffc9e26252ca26b237678b0b772

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2009-08-15 22:27:13.274661514 -0300
+++ linux-2.6/fs/inode.c	2009-08-15 22:28:08.261344721 -0300
@@ -220,18 +220,22 @@ static struct inode *alloc_inode(struct 
 	return inode;
 }
 
-void destroy_inode(struct inode *inode)
+void __destroy_inode(struct inode *inode)
 {
 	BUG_ON(inode_has_buffers(inode));
 	ima_inode_free(inode);
 	security_inode_free(inode);
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-08-15 22:27:13.278697992 -0300
+++ linux-2.6/include/linux/fs.h	2009-08-15 22:27:19.278690522 -0300
@@ -2162,6 +2162,7 @@ extern void __iget(struct inode * inode)
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
