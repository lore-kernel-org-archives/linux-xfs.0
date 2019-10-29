Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C199CCA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8786021906
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 23:30:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f7w1s0ml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfJ2Xat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:30:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ2Xas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:30:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNSl1i038196
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=iT+Ux4xo7gCN6qrq1i+LgRK64M7EqLWtNIb0cmQyZGE=;
 b=f7w1s0mlk3TEfLfcfZA8pqbuHQC3h0nilV/BALiqHcydJQRJAd/qW1vIH/zzJhCSnFR8
 cJGHGMc6XTuGWZlLM5kt8QWmoCVvekmg2D5i+rF6R5XM+eqmDBpq+PjpJ2+US9upNg1T
 Rv6wMAWWdIguuulT7tTTeqZVCU5xOmEZgzPSRZOiQbCs81hFUfZS49Dq8d84UZQvI0hZ
 7hUGexJTyEzYGBTbYCRaTjqS1Of9C5T9t4c6rRjv3Un/lH5rSeYoQp1dedJFYw3U5F66
 8tZd/7y3nSDvAYLepsS136sLnULr2+fMRNPScwITRUq1tNMTUZy0v2mTw/TZHaMk4tYe Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNRkj7183342
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vxwj8498s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9TNUjr6024013
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:45 -0700
Subject: [PATCH 2/3] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:44 -0700
Message-ID: <157239184470.1266870.6468390413869211476.stgit@magnolia>
In-Reply-To: <157239183075.1266870.1797402857427212175.stgit@magnolia>
References: <157239183075.1266870.1797402857427212175.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're discarding old btree blocks after a repair, only invalidate
the buffers for the ones that we're freeing -- if the metadata was
crosslinked with another data structure, we don't want to touch it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   74 ++++++++++++++++++++++---------------------------
 fs/xfs/scrub/repair.h |    1 -
 2 files changed, 33 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3a58788e0bd8..62a9b77eba3d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -423,44 +423,6 @@ xrep_init_btblock(
  * buffers associated with @bitmap.
  */
 
-/*
- * Invalidate buffers for per-AG btree blocks we're dumping.  This function
- * is not intended for use with file data repairs; we have bunmapi for that.
- */
-int
-xrep_invalidate_blocks(
-	struct xfs_scrub	*sc,
-	struct xfs_bitmap	*bitmap)
-{
-	struct xfs_bitmap_range	*bmr;
-	struct xfs_bitmap_range	*n;
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsbno;
-
-	/*
-	 * For each block in each extent, see if there's an incore buffer for
-	 * exactly that block; if so, invalidate it.  The buffer cache only
-	 * lets us look for one buffer at a time, so we have to look one block
-	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
-	 * because we never own those; and if we can't TRYLOCK the buffer we
-	 * assume it's owned by someone else.
-	 */
-	for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
-		/* Skip AG headers and post-EOFS blocks */
-		if (!xfs_verify_fsbno(sc->mp, fsbno))
-			continue;
-		bp = xfs_buf_incore(sc->mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(sc->mp, fsbno),
-				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
-		if (bp) {
-			xfs_trans_bjoin(sc->tp, bp);
-			xfs_trans_binval(sc->tp, bp);
-		}
-	}
-
-	return 0;
-}
-
 /* Ensure the freelist is the correct size. */
 int
 xrep_fix_freelist(
@@ -515,6 +477,33 @@ xrep_put_freelist(
 	return 0;
 }
 
+/* Try to invalidate the incore buffer for a block that we're about to free. */
+STATIC void
+xrep_reap_invalidate_block(
+	struct xfs_scrub	*sc,
+	xfs_fsblock_t		fsbno)
+{
+	struct xfs_buf		*bp;
+
+	/*
+	 * If there's an incore buffer for exactly this block, invalidate it.
+	 * Avoid invalidating AG headers and post-EOFS blocks because we never
+	 * own those; and if we can't TRYLOCK the buffer we assume it's owned
+	 * by someone else.
+	 */
+	if (!xfs_verify_fsbno(sc->mp, fsbno))
+		return;
+
+	bp = xfs_buf_incore(sc->mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(sc->mp, fsbno),
+			XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
+	if (!bp)
+		return;
+
+	xfs_trans_bjoin(sc->tp, bp);
+	xfs_trans_binval(sc->tp, bp);
+}
+
 /* Dispose of a single block. */
 STATIC int
 xrep_reap_block(
@@ -568,12 +557,15 @@ xrep_reap_block(
 	 * blow on writeout, the filesystem will shut down, and the admin gets
 	 * to run xfs_repair.
 	 */
-	if (has_other_rmap)
+	if (has_other_rmap) {
 		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
-	else if (resv == XFS_AG_RESV_AGFL)
+	} else if (resv == XFS_AG_RESV_AGFL) {
+		xrep_reap_invalidate_block(sc, fsbno);
 		error = xrep_put_freelist(sc, agbno);
-	else
+	} else {
+		xrep_reap_invalidate_block(sc, fsbno);
 		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
+	}
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	if (error)
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 60c61d7052a8..eab41928990f 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -31,7 +31,6 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 struct xfs_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xfs_bitmap *btlist);
 int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
 		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 

