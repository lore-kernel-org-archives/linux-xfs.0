Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5AAC3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 320E3217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PfxRiB1z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfHZVtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHZVtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLnMWi021200
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Nj65a8ti/isXg4GWCtt4pd91MM1eLdB0NxvYM3X0jbQ=;
 b=PfxRiB1zzIqwBypQIqwGz0gcefkwiKFpmtguck1zUZZimBiIrnNZIHCSheWS9SfrTsRt
 4wGpk26L7RMT6i3yufAA2GQF5WxiiwardSCFNwh9qZJq8ggV3xz2aPtTZ7objIE24etE
 QOrCCYAQIJer2bsz06KTlETTDrjtOuDvfvetLFQHOStxXqp+vPcAu4uUjg5eNfitHm3I
 INHzF+5ZrAxOlQXcMxBFiz6cP95QnrAGLslovNWsyNEMtEj9/9NPiW+nb2S5gbhXcku8
 4f3AF7dlwE+uKNP+QU7NqrnHgRpC9JoRFNH902NcUNRwHGmyo8xL6zeoHEBVtKyCkFzu NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2umqbe834m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmU2t041762
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2umj278rgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLnSIu019272
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:28 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:28 -0700
Subject: [PATCH 2/5] xfs: remove unnecessary int returns from deferred rmap
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:49:27 -0700
Message-ID: <156685616759.2853674.14113052736055839178.stgit@magnolia>
In-Reply-To: <156685615360.2853674.5160169873645196259.stgit@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the return value from the functions that schedule deferred rmap
operations since they never fail and do not return status.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c     |   36 ++++++++++++------------------------
 fs/xfs/libxfs/xfs_refcount.c |    9 +++------
 fs/xfs/libxfs/xfs_rmap.c     |   33 ++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_rmap.h     |   10 +++++-----
 4 files changed, 36 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 07aad70f3931..9842064de80c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1985,11 +1985,8 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* add reverse mapping unless caller opted out */
-	if (!(bma->flags & XFS_BMAPI_NORMAP)) {
-		error = xfs_rmap_map_extent(bma->tp, bma->ip, whichfork, new);
-		if (error)
-			goto done;
-	}
+	if (!(bma->flags & XFS_BMAPI_NORMAP))
+		xfs_rmap_map_extent(bma->tp, bma->ip, whichfork, new);
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -2471,9 +2468,7 @@ xfs_bmap_add_extent_unwritten_real(
 	}
 
 	/* update reverse mappings */
-	error = xfs_rmap_convert_extent(mp, tp, ip, whichfork, new);
-	if (error)
-		goto done;
+	xfs_rmap_convert_extent(mp, tp, ip, whichfork, new);
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
@@ -2832,11 +2827,8 @@ xfs_bmap_add_extent_hole_real(
 	}
 
 	/* add reverse mapping unless caller opted out */
-	if (!(flags & XFS_BMAPI_NORMAP)) {
-		error = xfs_rmap_map_extent(tp, ip, whichfork, new);
-		if (error)
-			goto done;
-	}
+	if (!(flags & XFS_BMAPI_NORMAP))
+		xfs_rmap_map_extent(tp, ip, whichfork, new);
 
 	/* convert to a btree if necessary */
 	if (xfs_bmap_needs_btree(ip, whichfork)) {
@@ -5149,9 +5141,7 @@ xfs_bmap_del_extent_real(
 	}
 
 	/* remove reverse mapping */
-	error = xfs_rmap_unmap_extent(tp, ip, whichfork, del);
-	if (error)
-		goto done;
+	xfs_rmap_unmap_extent(tp, ip, whichfork, del);
 
 	/*
 	 * If we need to, add to list of extents to delete.
@@ -5651,12 +5641,11 @@ xfs_bmse_merge(
 			&new);
 
 	/* update reverse mapping. rmap functions merge the rmaps for us */
-	error = xfs_rmap_unmap_extent(tp, ip, whichfork, got);
-	if (error)
-		return error;
+	xfs_rmap_unmap_extent(tp, ip, whichfork, got);
 	memcpy(&new, got, sizeof(new));
 	new.br_startoff = left->br_startoff + left->br_blockcount;
-	return xfs_rmap_map_extent(tp, ip, whichfork, &new);
+	xfs_rmap_map_extent(tp, ip, whichfork, &new);
+	return 0;
 }
 
 static int
@@ -5695,10 +5684,9 @@ xfs_bmap_shift_update_extent(
 			got);
 
 	/* update reverse mapping */
-	error = xfs_rmap_unmap_extent(tp, ip, whichfork, &prev);
-	if (error)
-		return error;
-	return xfs_rmap_map_extent(tp, ip, whichfork, got);
+	xfs_rmap_unmap_extent(tp, ip, whichfork, &prev);
+	xfs_rmap_map_extent(tp, ip, whichfork, got);
+	return 0;
 }
 
 int
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 51bb9bdb0e84..f4e17a1f4b27 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1558,8 +1558,9 @@ xfs_refcount_alloc_cow_extent(
 		return error;
 
 	/* Add rmap entry */
-	return xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
+	xfs_rmap_alloc_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
+	return 0;
 }
 
 /* Forget a CoW staging event in the refcount btree. */
@@ -1570,17 +1571,13 @@ xfs_refcount_free_cow_extent(
 	xfs_extlen_t			len)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	int				error;
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
 		return 0;
 
 	/* Remove rmap entry */
-	error = xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
+	xfs_rmap_free_extent(tp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), len, XFS_RMAP_OWN_COW);
-	if (error)
-		return error;
-
 	return __xfs_refcount_add(tp, XFS_REFCOUNT_FREE_COW, fsb, len);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 819693ef852c..56769826a5ca 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2268,7 +2268,7 @@ xfs_rmap_update_is_needed(
  * Record a rmap intent; the list is kept sorted first by AG and then by
  * increasing age.
  */
-static int
+static void
 __xfs_rmap_add(
 	struct xfs_trans		*tp,
 	enum xfs_rmap_intent_type	type,
@@ -2295,11 +2295,10 @@ __xfs_rmap_add(
 	ri->ri_bmap = *bmap;
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
-	return 0;
 }
 
 /* Map an extent into a file. */
-int
+void
 xfs_rmap_map_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -2307,15 +2306,15 @@ xfs_rmap_map_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
-		return 0;
+		return;
 
-	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
+	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
 			whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
-int
+void
 xfs_rmap_unmap_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -2323,9 +2322,9 @@ xfs_rmap_unmap_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
-		return 0;
+		return;
 
-	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
+	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
 			whichfork, PREV);
 }
@@ -2336,7 +2335,7 @@ xfs_rmap_unmap_extent(
  * Note that tp can be NULL here as no transaction is used for COW fork
  * unwritten conversion.
  */
-int
+void
 xfs_rmap_convert_extent(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -2345,15 +2344,15 @@ xfs_rmap_convert_extent(
 	struct xfs_bmbt_irec	*PREV)
 {
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
-		return 0;
+		return;
 
-	return __xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
+	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
 			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
 			whichfork, PREV);
 }
 
 /* Schedule the creation of an rmap for non-file data. */
-int
+void
 xfs_rmap_alloc_extent(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
@@ -2364,18 +2363,18 @@ xfs_rmap_alloc_extent(
 	struct xfs_bmbt_irec	bmap;
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
-		return 0;
+		return;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	return __xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_ALLOC, owner, XFS_DATA_FORK, &bmap);
 }
 
 /* Schedule the deletion of an rmap for non-file data. */
-int
+void
 xfs_rmap_free_extent(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
@@ -2386,14 +2385,14 @@ xfs_rmap_free_extent(
 	struct xfs_bmbt_irec	bmap;
 
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, XFS_DATA_FORK))
-		return 0;
+		return;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(tp->t_mountp, agno, bno);
 	bmap.br_blockcount = len;
 	bmap.br_startoff = 0;
 	bmap.br_state = XFS_EXT_NORM;
 
-	return __xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
+	__xfs_rmap_add(tp, XFS_RMAP_FREE, owner, XFS_DATA_FORK, &bmap);
 }
 
 /* Compare rmap records.  Returns -1 if a < b, 1 if a > b, and 0 if equal. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index e21ed0294e5c..0c2c3cb73429 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -161,16 +161,16 @@ struct xfs_rmap_intent {
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
-int xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+void xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);
-int xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+void xfs_rmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);
-int xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
+void xfs_rmap_convert_extent(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *imap);
-int xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
+void xfs_rmap_alloc_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
-int xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
+void xfs_rmap_free_extent(struct xfs_trans *tp, xfs_agnumber_t agno,
 		xfs_agblock_t bno, xfs_extlen_t len, uint64_t owner);
 
 void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,

