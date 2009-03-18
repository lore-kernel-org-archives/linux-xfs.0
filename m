Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I6Ykjw213496 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 01:35:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FC3D1C4EFFB
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2009 23:34:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BLqQADhnHCG8Sbet for
	<xfs@oss.sgi.com>; Tue, 17 Mar 2009 23:34:26 -0700 (PDT)
Date: Wed, 18 Mar 2009 02:34:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs: properly truncate blocks outsize i_size on write_begin failure
Message-ID: <20090318063425.GA18386@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org

As pointed out by Dave in the thread starting at
http://oss.sgi.com/archives/xfs/2008-04/msg00542.html the current use
of vmtruncate in block_write_begin is incorrect for filesystem not
using ->truncate for doing the actual on-disk truncatation.  Doing
it in ->truncate for a filesystem like XFS means it would be split
over multiple transactions leading to violations of the atomicy guarantee.
Historically (and still documented in Documentation/filesystems/Locking)
->truncate is not a method but only a helper for setattr implementations
so this is correct.

The correct fix would be to use ->setattr but that needs a new ATTR_NOLOCK
flag and an audit of all filesystems.  I'm still hoping to do that later
but for now I really want XFS fixed.

So just duplicate block_write_begin in XFS to do the proper truncation,
note that I need to export __block_prepare_write to no duplicate even
more code than nessecary.

GFS2 and UFS and possibly others wants the same kind of fix, too.

And I need to get rid of ->truncate one day to prevent people from using
it in stupid ways.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/buffer.c
===================================================================
--- xfs.orig/fs/buffer.c	2009-03-01 04:22:47.091430206 +0100
+++ xfs/fs/buffer.c	2009-03-01 04:22:59.913336991 +0100
@@ -1910,7 +1910,7 @@ void page_zero_new_buffers(struct page *
 }
 EXPORT_SYMBOL(page_zero_new_buffers);
 
-static int __block_prepare_write(struct inode *inode, struct page *page,
+int __block_prepare_write(struct inode *inode, struct page *page,
 		unsigned from, unsigned to, get_block_t *get_block)
 {
 	unsigned block_start, block_end;
@@ -1989,6 +1989,7 @@ static int __block_prepare_write(struct 
 		page_zero_new_buffers(page, from, to);
 	return err;
 }
+EXPORT_SYMBOL(__block_prepare_write);
 
 static int __block_commit_write(struct inode *inode, struct page *page,
 		unsigned from, unsigned to)
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-03-01 04:16:12.003305119 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2009-03-01 04:21:55.618306704 +0100
@@ -1598,6 +1598,71 @@ xfs_vm_direct_IO(
 	return ret;
 }
 
+/*
+ * This is a copy of fs/buffer.c:block_write_begin except for doing
+ * the correct setattr call in the error case instead of the wrong
+ * vmtruncate.
+ */
+static int
+xfs_block_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata,
+			get_block_t *get_block)
+{
+	struct inode *inode = mapping->host;
+	int status = 0;
+	struct page *page;
+	pgoff_t index;
+	unsigned start, end;
+	int ownpage = 0;
+
+	index = pos >> PAGE_CACHE_SHIFT;
+	start = pos & (PAGE_CACHE_SIZE - 1);
+	end = start + len;
+
+	page = *pagep;
+	if (page == NULL) {
+		ownpage = 1;
+		page = grab_cache_page_write_begin(mapping, index, flags);
+		if (!page) {
+			status = -ENOMEM;
+			goto out;
+		}
+		*pagep = page;
+	} else
+		BUG_ON(!PageLocked(page));
+
+	status = __block_prepare_write(inode, page, start, end, get_block);
+	if (unlikely(status)) {
+		ClearPageUptodate(page);
+
+		if (ownpage) {
+			unlock_page(page);
+			page_cache_release(page);
+			*pagep = NULL;
+
+			/*
+			 * prepare_write() may have instantiated a few blocks
+			 * outside i_size.  Trim these off again. Don't need
+			 * i_size_read because we hold i_mutex.
+			 */
+			if (pos + len > inode->i_size) {
+				struct iattr newattrs;
+				int error;
+
+				newattrs.ia_size = inode->i_size;
+				newattrs.ia_valid = ATTR_SIZE | ATTR_FORCE;
+				error = xfs_setattr(XFS_I(inode), &newattrs,
+						    XFS_ATTR_NOLOCK);
+				WARN_ON(error); /* not much we can do.. */
+			}
+		}
+	}
+
+out:
+	return status;
+}
+
 STATIC int
 xfs_vm_write_begin(
 	struct file		*file,
Index: xfs/include/linux/buffer_head.h
===================================================================
--- xfs.orig/include/linux/buffer_head.h	2009-03-01 04:23:14.364305635 +0100
+++ xfs/include/linux/buffer_head.h	2009-03-01 04:23:19.081305583 +0100
@@ -218,6 +218,8 @@ int generic_write_end(struct file *, str
 				struct page *, void *);
 void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
 int block_prepare_write(struct page*, unsigned, unsigned, get_block_t*);
+int __block_prepare_write(struct inode *inode, struct page *page,
+		unsigned from, unsigned to, get_block_t *get_block);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, unsigned, struct page **, void **,
 			get_block_t *, loff_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
