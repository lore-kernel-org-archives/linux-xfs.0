Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbfHMJDJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 05:03:09 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] xfs: Opencode and remove DEFINE_SINGLE_BUF_MAP
Date: Tue, 13 Aug 2019 12:03:06 +0300
Message-Id: <20190813090306.31278-4-nborisov@suse.com>
In-Reply-To: <20190813090306.31278-1-nborisov@suse.com>
References: <20190813090306.31278-1-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, Nikolay Borisov <nborisov@suse.com>

This macro encodes a trivial struct initializations, just open code it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/xfs/xfs_buf.c   | 4 ++--
 fs/xfs/xfs_buf.h   | 9 +++------
 fs/xfs/xfs_trans.h | 6 ++++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 99c66f80d7cc..389c5b590f11 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -658,7 +658,7 @@ xfs_buf_incore(
 {
 	struct xfs_buf		*bp;
 	int			error;
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
 
 	error = xfs_buf_find(target, &map, 1, flags, NULL, &bp);
 	if (error)
@@ -905,7 +905,7 @@ xfs_buf_get_uncached(
 	unsigned long		page_count;
 	int			error, i;
 	struct xfs_buf		*bp;
-	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
+	struct xfs_buf_map map = { .bm_bn = XFS_BUF_DADDR_NULL, .bm_len = numblks };
 
 	/* flags might contain irrelevant bits, pass only what we care about */
 	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ec7037284d62..548dfb0c6e27 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -104,9 +104,6 @@ struct xfs_buf_map {
 	int			bm_len;	/* size of I/O */
 };
 
-#define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
-	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
-
 struct xfs_buf_ops {
 	char *name;
 	union {
@@ -209,7 +206,7 @@ xfs_buf_get(
 	xfs_daddr_t		blkno,
 	size_t			numblks)
 {
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
 	return xfs_buf_get_map(target, &map, 1, 0);
 }
 
@@ -221,7 +218,7 @@ xfs_buf_read(
 	xfs_buf_flags_t		flags,
 	const struct xfs_buf_ops *ops)
 {
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
 	return xfs_buf_read_map(target, &map, 1, flags, ops);
 }
 
@@ -232,7 +229,7 @@ xfs_buf_readahead(
 	size_t			numblks,
 	const struct xfs_buf_ops *ops)
 {
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..8d6fce5c0320 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -182,7 +182,8 @@ xfs_trans_get_buf(
 	int			numblks,
 	uint			flags)
 {
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
+
 	return xfs_trans_get_buf_map(tp, target, &map, 1, flags);
 }
 
@@ -205,7 +206,8 @@ xfs_trans_read_buf(
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
+
 	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
 				      flags, bpp, ops);
 }
-- 
2.17.1
