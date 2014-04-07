Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18D307F91
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E98C6304039
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3HaZnuHMV5QIIXN5 for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/19] xfs: remove unused flags arg from _xfs_buf_get_pages()
Date: Mon,  7 Apr 2014 14:58:55 -0500
Message-Id: <1396900746-22201-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3b48a57..2423741 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -216,8 +216,7 @@ _xfs_buf_alloc(
 STATIC int
 _xfs_buf_get_pages(
 	xfs_buf_t		*bp,
-	int			page_count,
-	xfs_buf_flags_t		flags)
+	int			page_count)
 {
 	/* Make sure that we have a page list */
 	if (bp->b_pages == NULL) {
@@ -330,7 +329,7 @@ use_alloc_page:
 	end = (BBTOB(bp->b_maps[0].bm_bn + bp->b_length) + PAGE_SIZE - 1)
 								>> PAGE_SHIFT;
 	page_count = end - start;
-	error = _xfs_buf_get_pages(bp, page_count, flags);
+	error = _xfs_buf_get_pages(bp, page_count);
 	if (unlikely(error))
 		return error;
 
@@ -767,7 +766,7 @@ xfs_buf_associate_memory(
 	bp->b_pages = NULL;
 	bp->b_addr = mem;
 
-	rval = _xfs_buf_get_pages(bp, page_count, 0);
+	rval = _xfs_buf_get_pages(bp, page_count);
 	if (rval)
 		return rval;
 
@@ -800,7 +799,7 @@ xfs_buf_get_uncached(
 		goto fail;
 
 	page_count = PAGE_ALIGN(numblks << BBSHIFT) >> PAGE_SHIFT;
-	error = _xfs_buf_get_pages(bp, page_count, 0);
+	error = _xfs_buf_get_pages(bp, page_count);
 	if (error)
 		goto fail_free_buf;
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
