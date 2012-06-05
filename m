Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55B8KAc075704 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 06:08:20 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 6ldWG8qj3yzmSiGt (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 04:08:16 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Fix overallocation in xfs_buf_allocate_memory()
Date: Tue,  5 Jun 2012 13:08:10 +0200
Message-Id: <1338894490-12662-1-git-send-email-jack@suse.cz>
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
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Jan Kara <jack@suse.cz>

Commit 0e6e847f which introduced xfs_buf_allocate_memory() function has a bug
causing the function to overestimate the number of necessary pages. The problem
is that xfs_buf_alloc() sets b_bn to -1 and thus effectively every buffer is
straddling a page boundary which causes xfs_buf_allocate_memory() to allocate
two pages and use vmalloc() for access which slows things down.

Fix the code to use correct block number.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_buf.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 172d3cc..b67cc83 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -296,6 +296,7 @@ xfs_buf_free(
 STATIC int
 xfs_buf_allocate_memory(
 	xfs_buf_t		*bp,
+	xfs_daddr_t		blkno,
 	uint			flags)
 {
 	size_t			size;
@@ -334,8 +335,8 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	start = BBTOB(bp->b_bn) >> PAGE_SHIFT;
-	end = (BBTOB(bp->b_bn + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = BBTOB(blkno) >> PAGE_SHIFT;
+	end = (BBTOB(blkno + bp->b_length) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	page_count = end - start;
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
@@ -552,7 +553,7 @@ xfs_buf_get(
 	if (unlikely(!new_bp))
 		return NULL;
 
-	error = xfs_buf_allocate_memory(new_bp, flags);
+	error = xfs_buf_allocate_memory(new_bp, blkno, flags);
 	if (error) {
 		kmem_zone_free(xfs_buf_zone, new_bp);
 		return NULL;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
