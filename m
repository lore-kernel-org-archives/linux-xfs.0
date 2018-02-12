Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933813AbeBLNAJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 08:00:09 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F4E940A0971
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2018 13:00:09 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8BAC2166BD6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2018 13:00:08 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] Cleanup old XFS_BTREE_* traces
Date: Mon, 12 Feb 2018 14:00:05 +0100
Message-Id: <20180212130005.7199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Remove unused legacy btree traces from IRIX era.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Talking to Dave about it, he mentioned XFS_BTREE_TRACE_CURSOR might be worth to
turn into a proper ftrace trace point, so I didn't touch _CURSOR traces in this
patchset, and a proper conversion will be sent later, unless it's not worth at
all, and I should send a V2 also removing TRACE_CURSOR.

Cheers

 fs/xfs/libxfs/xfs_btree.c | 15 ---------------
 fs/xfs/libxfs/xfs_btree.h |  7 -------
 2 files changed, 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 79ee4a1951d1..eb324eb9e5cd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1439,7 +1439,6 @@ xfs_btree_log_keys(
 	int			last)
 {
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
 	if (bp) {
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
@@ -1465,7 +1464,6 @@ xfs_btree_log_recs(
 	int			last)
 {
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
 	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 	xfs_trans_log_buf(cur->bc_tp, bp,
@@ -1486,7 +1484,6 @@ xfs_btree_log_ptrs(
 	int			last)	/* index of last pointer to log */
 {
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBII(cur, bp, first, last);
 
 	if (bp) {
 		struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
@@ -1544,7 +1541,6 @@ xfs_btree_log_block(
 	};
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGBI(cur, bp, fields);
 
 	if (bp) {
 		int nbits;
@@ -1594,7 +1590,6 @@ xfs_btree_increment(
 	int			lev;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, level);
 
 	ASSERT(level < cur->bc_nlevels);
 
@@ -1702,7 +1697,6 @@ xfs_btree_decrement(
 	union xfs_btree_ptr	ptr;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, level);
 
 	ASSERT(level < cur->bc_nlevels);
 
@@ -1882,7 +1876,6 @@ xfs_btree_lookup(
 	union xfs_btree_ptr	ptr;	/* ptr to btree block */
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, dir);
 
 	XFS_BTREE_STATS_INC(cur, lookup);
 
@@ -2225,7 +2218,6 @@ xfs_btree_update_keys(
 		return __xfs_btree_updkeys(cur, level, block, bp, false);
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGIK(cur, level, keyp);
 
 	/*
 	 * Go up the tree from this level toward the root.
@@ -2273,7 +2265,6 @@ xfs_btree_update(
 	union xfs_btree_rec	*rp;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGR(cur, rec);
 
 	/* Pick up the current block. */
 	block = xfs_btree_get_block(cur, 0, &bp);
@@ -2340,7 +2331,6 @@ xfs_btree_lshift(
 	int			i;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, level);
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1)
@@ -2542,7 +2532,6 @@ xfs_btree_rshift(
 	int			i;		/* loop counter */
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, level);
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    (level == cur->bc_nlevels - 1))
@@ -2727,8 +2716,6 @@ __xfs_btree_split(
 #endif
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGIPK(cur, level, *ptrp, key);
-
 	XFS_BTREE_STATS_INC(cur, split);
 
 	/* Set up left block (current one). */
@@ -3310,7 +3297,6 @@ xfs_btree_insrec(
 	xfs_daddr_t		old_bn;
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGIPR(cur, level, *ptrp, &rec);
 
 	ncur = NULL;
 	lkey = &nkey;
@@ -3781,7 +3767,6 @@ xfs_btree_delrec(
 	int			numrecs;	/* temporary numrec count */
 
 	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
-	XFS_BTREE_TRACE_ARGI(cur, level);
 
 	tcur = NULL;
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 50440b5618e8..7d4e6b16981d 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -483,13 +483,6 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
  * r = btree record
  * k = btree key
  */
-#define	XFS_BTREE_TRACE_ARGBI(c, b, i)
-#define	XFS_BTREE_TRACE_ARGBII(c, b, i, j)
-#define	XFS_BTREE_TRACE_ARGI(c, i)
-#define	XFS_BTREE_TRACE_ARGIPK(c, i, p, s)
-#define	XFS_BTREE_TRACE_ARGIPR(c, i, p, r)
-#define	XFS_BTREE_TRACE_ARGIK(c, i, k)
-#define XFS_BTREE_TRACE_ARGR(c, r)
 #define	XFS_BTREE_TRACE_CURSOR(c, t)
 
 xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
-- 
2.14.3

