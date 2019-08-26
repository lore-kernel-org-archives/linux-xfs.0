Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E646C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B044217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lPdI3o5t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfHZVti (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42444 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfHZVth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLnaUA189641
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kBF+0BJ0jyRQ9fdX6MfvbRvNrQxhoV7hRKDp2/RZago=;
 b=lPdI3o5tBEKgdQ1hI4ZopJemnKH9VE4BvZCmNhKpqIkQrOl+hPzynYFaVekl+xlx9PkE
 NHPPwGkatCpo7wevt1weynZPapkY/mYCqW2/rBo38ac2R/DKHGyFg/lAu+O1JSV8EtzW
 jGNTBO0B3kKrst/RMcww71/9dY21Wq9/ZVUeAouCJS+lbcLuUG3jcud1Lo9Mwf1xo4/Y
 LO+iKis1IGl7i0Hn3xzFAR1DJwroZ+A1ZQZzVxzkWdJnfyk6sbN5EDXroj9kFXky6MN7
 gQkYsJA+R74kCaq7vY6cj63mwCVkZitECNmQxlgnP+iLxECF4syXOgBWtJ7fO9GPBmej VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2umq5t84s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmVEJ041820
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj278rk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:35 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLnZlP019308
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:35 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 21:49:34 +0000
Subject: [PATCH 3/5] xfs: remove unnecessary int returns from deferred
 refcount functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:49:33 -0700
Message-ID: <156685617388.2853674.17040064326231302107.stgit@magnolia>
In-Reply-To: <156685615360.2853674.5160169873645196259.stgit@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the return value from the functions that schedule deferred
refcount operations since they never fail and do not return status.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     |   21 ++++++---------------
 fs/xfs/libxfs/xfs_refcount.c |   39 ++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_refcount.h |   12 ++++++------
 fs/xfs/xfs_refcount_item.c   |   10 ++++------
 fs/xfs/xfs_reflink.c         |   15 ++++-----------
 5 files changed, 36 insertions(+), 61 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9842064de80c..e0cbe73ebf04 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4393,12 +4393,9 @@ xfs_bmapi_write(
 			 * If this is a CoW allocation, record the data in
 			 * the refcount btree for orphan recovery.
 			 */
-			if (whichfork == XFS_COW_FORK) {
-				error = xfs_refcount_alloc_cow_extent(tp,
-						bma.blkno, bma.length);
-				if (error)
-					goto error0;
-			}
+			if (whichfork == XFS_COW_FORK)
+				xfs_refcount_alloc_cow_extent(tp, bma.blkno,
+						bma.length);
 		}
 
 		/* Deal with the allocated space we found.  */
@@ -4532,12 +4529,8 @@ xfs_bmapi_convert_delalloc(
 	*imap = bma.got;
 	*seq = READ_ONCE(ifp->if_seq);
 
-	if (whichfork == XFS_COW_FORK) {
-		error = xfs_refcount_alloc_cow_extent(tp, bma.blkno,
-				bma.length);
-		if (error)
-			goto out_finish;
-	}
+	if (whichfork == XFS_COW_FORK)
+		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -5148,9 +5141,7 @@ xfs_bmap_del_extent_real(
 	 */
 	if (do_fx && !(bflags & XFS_BMAPI_REMAP)) {
 		if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK) {
-			error = xfs_refcount_decrease_extent(tp, del);
-			if (error)
-				goto done;
+			xfs_refcount_decrease_extent(tp, del);
 		} else {
 			__xfs_bmap_add_free(tp, del->br_startblock,
 					del->br_blockcount, NULL,
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index f4e17a1f4b27..8e0a50214d94 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1174,7 +1174,7 @@ xfs_refcount_finish_one(
 /*
  * Record a refcount intent for later processing.
  */
-static int
+static void
 __xfs_refcount_add(
 	struct xfs_trans		*tp,
 	enum xfs_refcount_intent_type	type,
@@ -1196,37 +1196,36 @@ __xfs_refcount_add(
 	ri->ri_blockcount = blockcount;
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
-	return 0;
 }
 
 /*
  * Increase the reference count of the blocks backing a file's extent.
  */
-int
+void
 xfs_refcount_increase_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
-		return 0;
+		return;
 
-	return __xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE,
-			PREV->br_startblock, PREV->br_blockcount);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_INCREASE, PREV->br_startblock,
+			PREV->br_blockcount);
 }
 
 /*
  * Decrease the reference count of the blocks backing a file's extent.
  */
-int
+void
 xfs_refcount_decrease_extent(
 	struct xfs_trans		*tp,
 	struct xfs_bmbt_irec		*PREV)
 {
 	if (!xfs_sb_version_hasreflink(&tp->t_mountp->m_sb))
-		return 0;
+		return;
 
-	return __xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE,
-			PREV->br_startblock, PREV->br_blockcount);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_DECREASE, PREV->br_startblock,
+			PREV->br_blockcount);
 }
 
 /*
@@ -1541,30 +1540,26 @@ __xfs_refcount_cow_free(
 }
 
 /* Record a CoW staging extent in the refcount btree. */
-int
+void
 xfs_refcount_alloc_cow_extent(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			fsb,
 	xfs_extlen_t			len)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	int				error;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return 0;
+		return;
 
-	error = __xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
-	if (error)
-		return error;
+	__xfs_refcount_add(tp, XFS_REFCOUNT_ALLOC_COW, fsb, len);
 
 	/* Add rmap entry */
 	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
-	return 0;
 }
 
 /* Forget a CoW staging event in the refcount btree. */
-int
+void
 xfs_refcount_free_cow_extent(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			fsb,
@@ -1573,12 +1568,12 @@ xfs_refcount_free_cow_extent(
 	struct xfs_mount		*mp = tp->t_mountp;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return 0;
+		return;
 
 	/* Remove rmap entry */
 	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
-	return __xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
+	__xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
 struct xfs_refcount_recovery {
@@ -1676,10 +1671,8 @@ xfs_refcount_recover_cow_leftovers(
 		/* Free the orphan record */
 		agbno = rr->rr_rrec.rc_startblock - XFS_REFC_COW_START;
 		fsb = XFS_AGB_TO_FSB(mp, agno, agbno);
-		error = xfs_refcount_free_cow_extent(tp, fsb,
+		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
-		if (error)
-			goto out_trans;
 
 		/* Free the block. */
 		xfs_bmap_add_free(tp, fsb, rr->rr_rrec.rc_blockcount, NULL);
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 1d9c518575e7..209795539c8d 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -29,9 +29,9 @@ struct xfs_refcount_intent {
 	xfs_extlen_t				ri_blockcount;
 };
 
-extern int xfs_refcount_increase_extent(struct xfs_trans *tp,
+void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
-extern int xfs_refcount_decrease_extent(struct xfs_trans *tp,
+void xfs_refcount_decrease_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 
 extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
@@ -45,10 +45,10 @@ extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
 		xfs_extlen_t *flen, bool find_end_of_shared);
 
-extern int xfs_refcount_alloc_cow_extent(struct xfs_trans *tp,
-		xfs_fsblock_t fsb, xfs_extlen_t len);
-extern int xfs_refcount_free_cow_extent(struct xfs_trans *tp,
-		xfs_fsblock_t fsb, xfs_extlen_t len);
+void xfs_refcount_alloc_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
+		xfs_extlen_t len);
+void xfs_refcount_free_cow_extent(struct xfs_trans *tp, xfs_fsblock_t fsb,
+		xfs_extlen_t len);
 extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
 		xfs_agnumber_t agno);
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d8288aa0670a..bc3db2be4194 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -555,26 +555,24 @@ xfs_cui_recover(
 			irec.br_blockcount = new_len;
 			switch (type) {
 			case XFS_REFCOUNT_INCREASE:
-				error = xfs_refcount_increase_extent(tp, &irec);
+				xfs_refcount_increase_extent(tp, &irec);
 				break;
 			case XFS_REFCOUNT_DECREASE:
-				error = xfs_refcount_decrease_extent(tp, &irec);
+				xfs_refcount_decrease_extent(tp, &irec);
 				break;
 			case XFS_REFCOUNT_ALLOC_COW:
-				error = xfs_refcount_alloc_cow_extent(tp,
+				xfs_refcount_alloc_cow_extent(tp,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
 			case XFS_REFCOUNT_FREE_COW:
-				error = xfs_refcount_free_cow_extent(tp,
+				xfs_refcount_free_cow_extent(tp,
 						irec.br_startblock,
 						irec.br_blockcount);
 				break;
 			default:
 				ASSERT(0);
 			}
-			if (error)
-				goto abort_error;
 			requeue_only = true;
 		}
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index edbe37b7f636..eae128ea0c12 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -495,10 +495,8 @@ xfs_reflink_cancel_cow_blocks(
 			ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
 
 			/* Free the CoW orphan record. */
-			error = xfs_refcount_free_cow_extent(*tpp,
-					del.br_startblock, del.br_blockcount);
-			if (error)
-				break;
+			xfs_refcount_free_cow_extent(*tpp, del.br_startblock,
+					del.br_blockcount);
 
 			xfs_bmap_add_free(*tpp, del.br_startblock,
 					  del.br_blockcount, NULL);
@@ -675,10 +673,7 @@ xfs_reflink_end_cow_extent(
 	trace_xfs_reflink_cow_remap(ip, &del);
 
 	/* Free the CoW orphan record. */
-	error = xfs_refcount_free_cow_extent(tp, del.br_startblock,
-			del.br_blockcount);
-	if (error)
-		goto out_cancel;
+	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
 
 	/* Map the new blocks into the data fork. */
 	error = xfs_bmap_map_extent(tp, ip, &del);
@@ -1070,9 +1065,7 @@ xfs_reflink_remap_extent(
 				uirec.br_blockcount, uirec.br_startblock);
 
 		/* Update the refcount tree */
-		error = xfs_refcount_increase_extent(tp, &uirec);
-		if (error)
-			goto out_cancel;
+		xfs_refcount_increase_extent(tp, &uirec);
 
 		/* Map the new blocks into the data fork. */
 		error = xfs_bmap_map_extent(tp, ip, &uirec);

