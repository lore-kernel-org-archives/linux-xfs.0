Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E7EC2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 854FD206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HemoZexT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgAABTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:19:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54144 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbgAABTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:19:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011JKs4097090
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=d9zxvx4sR54piEgM7ER8dcIwJ+5FugU5mjfszQmgv6I=;
 b=HemoZexTDnmk8F5cosRB0DE1pULRqXByfUv5nVFuY5+FaVkz5MFjglsu1Ln3Ema4Fz5b
 2N7yHquel94C75THLnL2TCkAkNiWR1x/dofb8YqCqrHLO1w8I8gZBvHd8b8JTI9KAQtN
 KyazxKU7TO/Un/ph/iQJWlaUGQO+ZMPQj+3UbAc1W8NbTtzRRAHYhx2bChLQKh/WLm3T
 uHN2AVtqiQwfHKksRbWhY3kOS/s/m7Xx/XOR38ai6BFlqOnTXpBkuEdA33YGCIYjMdiz
 EL4OjMxAYtACOf1JOzF9fy8z3nUecwKfm8/kAaF0XHqPatQEfg1lLp+gYZlBDzri4q4P Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:19:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vr4172055
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gj91b8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:17:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011HJCd014377
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:17:19 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:17:18 -0800
Subject: [PATCH 09/21] xfs: add a realtime flag to the rmap update log redo
 items
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:17:16 -0800
Message-ID: <157784143622.1368137.8626042257765831402.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Extend the rmap update (RUI) log items with a new realtime flag that
indicates that the updates apply against the realtime rmapbt.  We'll
wire up the actual rmap code later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/libxfs/xfs_refcount.c   |    4 ++--
 fs/xfs/libxfs/xfs_rmap.c       |   22 +++++++++++++---------
 fs/xfs/libxfs/xfs_rmap.h       |    5 +++--
 fs/xfs/scrub/alloc_repair.c    |    2 +-
 fs/xfs/xfs_rmap_item.c         |   13 ++++++++++---
 6 files changed, 32 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 17789cf130e3..0f2f500309f2 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -642,11 +642,13 @@ struct xfs_map_extent {
 #define XFS_RMAP_EXTENT_ATTR_FORK	(1U << 31)
 #define XFS_RMAP_EXTENT_BMBT_BLOCK	(1U << 30)
 #define XFS_RMAP_EXTENT_UNWRITTEN	(1U << 29)
+#define XFS_RMAP_EXTENT_REALTIME	(1U << 28)
 
 #define XFS_RMAP_EXTENT_FLAGS		(XFS_RMAP_EXTENT_TYPE_MASK | \
 					 XFS_RMAP_EXTENT_ATTR_FORK | \
 					 XFS_RMAP_EXTENT_BMBT_BLOCK | \
-					 XFS_RMAP_EXTENT_UNWRITTEN)
+					 XFS_RMAP_EXTENT_UNWRITTEN | \
+					 XFS_RMAP_EXTENT_REALTIME)
 
 /*
  * This is the structure used to lay out an rui log item in the
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index e761b796170e..a2433e6e092a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1663,7 +1663,7 @@ xfs_refcount_alloc_cow_extent(
 	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
-	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_alloc_extent(tp, fsb, len, XFS_RMAP_OWN_COW, false);
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1679,7 +1679,7 @@ xfs_refcount_free_cow_extent(
 		return;
 
 	/* Remove rmap entry */
-	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW);
+	xfs_rmap_free_extent(tp, fsb, len, XFS_RMAP_OWN_COW, false);
 	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 15518f624396..3e625ba057e6 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2600,11 +2600,12 @@ __xfs_rmap_add(
 	enum xfs_rmap_intent_type	type,
 	uint64_t			owner,
 	int				whichfork,
-	struct xfs_bmbt_irec		*bmap)
+	struct xfs_bmbt_irec		*bmap,
+	bool				realtime)
 {
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(tp->t_mountp,
+	trace_xfs_rmap_defer(tp->t_mountp, realtime ? NULLAGNUMBER :
 			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
 			type,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
@@ -2619,6 +2620,7 @@ __xfs_rmap_add(
 	ri->ri_owner = owner;
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
+	ri->ri_realtime = realtime;
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 }
@@ -2636,7 +2638,7 @@ xfs_rmap_map_extent(
 
 	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Unmap an extent out of a file. */
@@ -2652,7 +2654,7 @@ xfs_rmap_unmap_extent(
 
 	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /*
@@ -2674,7 +2676,7 @@ xfs_rmap_convert_extent(
 
 	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+			whichfork, PREV, XFS_IS_REALTIME_INODE(ip));
 }
 
 /* Schedule the creation of an rmap for non-file data. */
@@ -2683,7 +2685,8 @@ xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		fsbno,
 	xfs_filblks_t		len,
-	uint64_t		owner)
+	uint64_t		owner,
+	bool			isrt)
 {
 	struct xfs_bmbt_irec	bmap;
 
@@ -2695,7 +2698,7 @@ xfs_rmap_alloc_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap, isrt);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
@@ -2704,7 +2707,8 @@ xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		fsbno,
 	xfs_filblks_t		len,
-	uint64_t		owner)
+	uint64_t		owner,
+	bool			isrt)
 {
 	struct xfs_bmbt_irec	bmap;
 
@@ -2716,7 +2720,7 @@ xfs_rmap_free_extent(
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap, isrt);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index c187f1a678dd..2d4badc4a531 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -159,6 +159,7 @@ struct xfs_rmap_intent {
 	uint64_t				ri_owner;
 	int					ri_whichfork;
 	struct xfs_bmbt_irec			ri_bmap;
+	bool					ri_realtime;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
@@ -170,9 +171,9 @@ void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
 void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
-		xfs_filblks_t len, uint64_t owner);
+		xfs_filblks_t len, uint64_t owner, bool isrt);
 void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_fsblock_t fsbno,
-		xfs_filblks_t len, uint64_t owner);
+		xfs_filblks_t len, uint64_t owner, bool isrt);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index ec04bbe14120..b4692ef4573e 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -408,7 +408,7 @@ xrep_abt_dispose_reservations(
 		/* Add a deferred rmap for each extent we used. */
 		if (resv->used > 0)
 			xfs_rmap_alloc_extent(sc->tp, resv->fsbno, resv->used,
-					XFS_RMAP_OWN_AG);
+					XFS_RMAP_OWN_AG, false);
 
 		/*
 		 * Add a deferred free for each block we didn't use and now
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..c7a55011972f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -262,13 +262,16 @@ xfs_trans_set_rmap_flags(
 	struct xfs_map_extent		*rmap,
 	enum xfs_rmap_intent_type	type,
 	int				whichfork,
-	xfs_exntst_t			state)
+	xfs_exntst_t			state,
+	bool				rt)
 {
 	rmap->me_flags = 0;
 	if (state == XFS_EXT_UNWRITTEN)
 		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
 	if (whichfork == XFS_ATTR_FORK)
 		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+	if (rt)
+		rmap->me_flags |= XFS_RMAP_EXTENT_REALTIME;
 	switch (type) {
 	case XFS_RMAP_MAP:
 		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
@@ -315,6 +318,7 @@ xfs_trans_log_finish_rmap_update(
 	xfs_fsblock_t			startblock,
 	xfs_filblks_t			blockcount,
 	xfs_exntst_t			state,
+	bool				rt,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
@@ -403,7 +407,7 @@ xfs_rmap_update_log_item(
 	map->me_startoff = rmap->ri_bmap.br_startoff;
 	map->me_len = rmap->ri_bmap.br_blockcount;
 	xfs_trans_set_rmap_flags(map, rmap->ri_type, rmap->ri_whichfork,
-			rmap->ri_bmap.br_state);
+			rmap->ri_bmap.br_state, rmap->ri_realtime);
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
@@ -435,6 +439,7 @@ xfs_rmap_update_finish_item(
 			rmap->ri_bmap.br_startblock,
 			rmap->ri_bmap.br_blockcount,
 			rmap->ri_bmap.br_state,
+			rmap->ri_realtime,
 			(struct xfs_btree_cur **)state);
 	kmem_free(rmap);
 	return error;
@@ -503,6 +508,7 @@ xfs_rui_recover(
 	xfs_exntst_t			state;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
+	bool				rt;
 
 	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
 
@@ -557,6 +563,7 @@ xfs_rui_recover(
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 		whichfork = (rmap->me_flags & XFS_RMAP_EXTENT_ATTR_FORK) ?
 				XFS_ATTR_FORK : XFS_DATA_FORK;
+		rt = !!(rmap->me_flags & XFS_RMAP_EXTENT_REALTIME);
 		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 		case XFS_RMAP_EXTENT_MAP:
 			type = XFS_RMAP_MAP;
@@ -590,7 +597,7 @@ xfs_rui_recover(
 		error = xfs_trans_log_finish_rmap_update(tp, rudp, type,
 				rmap->me_owner, whichfork,
 				rmap->me_startoff, rmap->me_startblock,
-				rmap->me_len, state, &rcur);
+				rmap->me_len, state, rt, &rcur);
 		if (error)
 			goto abort_error;
 

