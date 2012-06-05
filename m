Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55EmcPr093251 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:48:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	brpOBHKHE6hVU8CJ (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:48:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sbv3j-0004ye-HY
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 14:48:35 +0000
Message-Id: <20120605144835.503963603@bombadil.infradead.org>
Date: Tue, 05 Jun 2012 10:46:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: remove xfs_ialloc_find_free
References: <20120605144647.051012936@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_ialloc_find_free
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

This function is entirely trivial and only has one caller, so remove it to
simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-06-04 12:39:42.512235078 -0400
+++ xfs/fs/xfs/xfs_ialloc.c	2012-06-04 12:39:44.012235117 -0400
@@ -609,13 +609,6 @@ xfs_ialloc_get_rec(
 /*
  * Visible inode allocation functions.
  */
-/*
- * Find a free (set) bit in the inode bitmask.
- */
-static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
-{
-	return xfs_lowbit64(*fp);
-}
 
 /*
  * Allocate an inode on disk.
@@ -995,7 +988,7 @@ newino:
 	}
 
 alloc_inode:
-	offset = xfs_ialloc_find_free(&rec.ir_free);
+	offset = xfs_lowbit64(rec.ir_free);
 	ASSERT(offset >= 0);
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
