Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n850KoMZ253853 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 19:21:00 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E33642BEC9
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 17:21:20 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id cpdJCYQ8cHIuQ8Gx for <xfs@oss.sgi.com>;
	Fri, 04 Sep 2009 17:21:20 -0700 (PDT)
Message-Id: <20090905001455.382972737@mini.kroah.org>
Date: Fri, 04 Sep 2009 17:14:27 -0700
From: Greg KH <gregkh@suse.de>
Subject: [patch 52/71] vfs: add __destroy_inode
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=vfs-add-__destroy_inode.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Christoph Hellwig <hch@infradead.org>

backport of upstream commit 2e00c97e2c1d2ffc9e26252ca26b237678b0b772

When we want to tear down an inode that lost the add to the cache race
in XFS we must not call into ->destroy_inode because that would delete
the inode that won the race from the inode cache radix tree.

This patch provides the __destroy_inode helper needed to fix this,
the actual fix will be in th next patch.  As XFS was the only reason
destroy_inode was exported we shift the export to the new __destroy_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/inode.c         |   10 +++++++---
 include/linux/fs.h |    1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
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
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
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
