Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE2FC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbiDKAeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbiDKAeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D583A101C8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D0E9253AD70
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMk-As
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjI-9v
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/17] xfs: convert btree buffer log flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:38 +1000
Message-Id: <20220411003147.2104423-9-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=i4csnjo8p2NRvacbKjYA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

We also pass the fields to log to xfs_btree_offsets() as a uint32_t
all cases now. I have no idea why we made that parameter a int64_t
in the first place, but while we are fixing this up change it to
a uint32_t field, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 10 +++++-----
 fs/xfs/libxfs/xfs_btree.h | 26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c1500b238520..a8c79e760d8a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -751,20 +751,20 @@ xfs_btree_lastrec(
  */
 void
 xfs_btree_offsets(
-	int64_t		fields,		/* bitmask of fields */
+	uint32_t	fields,		/* bitmask of fields */
 	const short	*offsets,	/* table of field offsets */
 	int		nbits,		/* number of bits to inspect */
 	int		*first,		/* output: first byte offset */
 	int		*last)		/* output: last byte offset */
 {
 	int		i;		/* current bit number */
-	int64_t		imask;		/* mask for current bit number */
+	uint32_t	imask;		/* mask for current bit number */
 
 	ASSERT(fields != 0);
 	/*
 	 * Find the lowest bit, so the first byte offset.
 	 */
-	for (i = 0, imask = 1LL; ; i++, imask <<= 1) {
+	for (i = 0, imask = 1u; ; i++, imask <<= 1) {
 		if (imask & fields) {
 			*first = offsets[i];
 			break;
@@ -773,7 +773,7 @@ xfs_btree_offsets(
 	/*
 	 * Find the highest bit, so the last byte offset.
 	 */
-	for (i = nbits - 1, imask = 1LL << i; ; i--, imask >>= 1) {
+	for (i = nbits - 1, imask = 1u << i; ; i--, imask >>= 1) {
 		if (imask & fields) {
 			*last = offsets[i + 1] - 1;
 			break;
@@ -1456,7 +1456,7 @@ void
 xfs_btree_log_block(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	struct xfs_buf		*bp,	/* buffer containing btree block */
-	int			fields)	/* mask of fields: XFS_BB_... */
+	uint32_t		fields)	/* mask of fields: XFS_BB_... */
 {
 	int			first;	/* first byte offset logged */
 	int			last;	/* last byte offset logged */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 22d9f411fde6..eef27858a013 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -68,19 +68,19 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 /*
  * For logging record fields.
  */
-#define	XFS_BB_MAGIC		(1 << 0)
-#define	XFS_BB_LEVEL		(1 << 1)
-#define	XFS_BB_NUMRECS		(1 << 2)
-#define	XFS_BB_LEFTSIB		(1 << 3)
-#define	XFS_BB_RIGHTSIB		(1 << 4)
-#define	XFS_BB_BLKNO		(1 << 5)
-#define	XFS_BB_LSN		(1 << 6)
-#define	XFS_BB_UUID		(1 << 7)
-#define	XFS_BB_OWNER		(1 << 8)
+#define	XFS_BB_MAGIC		(1u << 0)
+#define	XFS_BB_LEVEL		(1u << 1)
+#define	XFS_BB_NUMRECS		(1u << 2)
+#define	XFS_BB_LEFTSIB		(1u << 3)
+#define	XFS_BB_RIGHTSIB		(1u << 4)
+#define	XFS_BB_BLKNO		(1u << 5)
+#define	XFS_BB_LSN		(1u << 6)
+#define	XFS_BB_UUID		(1u << 7)
+#define	XFS_BB_OWNER		(1u << 8)
 #define	XFS_BB_NUM_BITS		5
-#define	XFS_BB_ALL_BITS		((1 << XFS_BB_NUM_BITS) - 1)
+#define	XFS_BB_ALL_BITS		((1u << XFS_BB_NUM_BITS) - 1)
 #define	XFS_BB_NUM_BITS_CRC	9
-#define	XFS_BB_ALL_BITS_CRC	((1 << XFS_BB_NUM_BITS_CRC) - 1)
+#define	XFS_BB_ALL_BITS_CRC	((1u << XFS_BB_NUM_BITS_CRC) - 1)
 
 /*
  * Generic stats interface
@@ -345,7 +345,7 @@ xfs_btree_dup_cursor(
  */
 void
 xfs_btree_offsets(
-	int64_t			fields,	/* bitmask of fields */
+	uint32_t		fields,	/* bitmask of fields */
 	const short		*offsets,/* table of field offsets */
 	int			nbits,	/* number of bits to inspect */
 	int			*first,	/* output: first byte offset */
@@ -435,7 +435,7 @@ bool xfs_btree_sblock_verify_crc(struct xfs_buf *);
 /*
  * Internal btree helpers also used by xfs_bmap.c.
  */
-void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, int);
+void xfs_btree_log_block(struct xfs_btree_cur *, struct xfs_buf *, uint32_t);
 void xfs_btree_log_recs(struct xfs_btree_cur *, struct xfs_buf *, int, int);
 
 /*
-- 
2.35.1

