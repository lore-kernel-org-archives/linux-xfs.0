Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5IKobjX028260 for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 15:50:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FD8B1295770
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2009 13:51:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0PU3yVXaTQHAzjlL for
	<xfs@oss.sgi.com>; Thu, 18 Jun 2009 13:51:03 -0700 (PDT)
Date: Thu, 18 Jun 2009 16:51:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks ==
	0, file: fs/xfs/xfs_bmap.c, line: 5991
Message-ID: <20090618205102.GA5805@infradead.org>
References: <a4423d670906181231r7388df5am394bc55508272b3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670906181231r7388df5am394bc55508272b3@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: xfs@oss.sgi.com

Did this happens once or multiple times?  It seems that for some
reason xfs_flush_pages didn't flush all delalloc space and then
we rightfully hit this assertation.

I really hate the code in xfs_flush_pages with the optimizations it
tries to apply.  Can you give the patch below which removes the
optimizations and uses some more core VM code instead of doing our
own thing?


Index: xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-06-18 22:48:01.469815342 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2009-06-18 22:49:08.296815058 +0200
@@ -68,20 +68,12 @@ xfs_flush_pages(
 	uint64_t	flags,
 	int		fiopt)
 {
-	struct address_space *mapping = VFS_I(ip)->i_mapping;
-	int		ret = 0;
-	int		ret2;
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
-	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		xfs_iflags_clear(ip, XFS_ITRUNCATED);
-		ret = -filemap_fdatawrite(mapping);
-	}
 	if (flags & XFS_B_ASYNC)
-		return ret;
-	ret2 = xfs_wait_on_pages(ip, first, last);
-	if (!ret)
-		ret = ret2;
-	return ret;
+		return -filemap_fdatawrite(VFS_I(ip)->i_mapping);
+	else
+		return -filemap_write_and_wait(VFS_I(ip)->i_mapping);
 }
 
 int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
