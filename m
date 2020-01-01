Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3E7C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A087E206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q5B4hjC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAABBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:01:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727187AbgAABBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:01:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x7SB085448
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=iT+Ux4xo7gCN6qrq1i+LgRK64M7EqLWtNIb0cmQyZGE=;
 b=q5B4hjC7oskA62bH9krFKs/7H/YXP7bE1FW9cRyeoZGmFHMpQtIOd5555OiZD6M3Uo5M
 qyI7dG3sGW8T4cK9u/6XitXBTawq3t8Ou5qu9OJDIt7RDkNx99KoLCtNSxBvFSAIHpwT
 /HkMzhTNNfsUGBZqZg6nkbMbnw/95RUGFvCOAKeShMljFyYxq+p/zgGzDdqgOGca3pAs
 ucDHHngonNpYf05IO/SVfSb8UFd8uZnH+zu7oB3ONTnPZcAfoNhdrZon6xpeM4GP04PU
 ocYtEVdsyM5lu4x3hcX2ykDqMg350MpiMOtT1oxOGaTDnYg1rC9ikcupWlp/HbZsyDn5 SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010ww7H190720
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8guedbnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:01:33 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00111X0q023306
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:01:33 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:01:32 -0800
Subject: [PATCH 2/3] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:01:30 -0800
Message-ID: <157784049081.1357430.998170313426535186.stgit@magnolia>
In-Reply-To: <157784047838.1357430.18292934559846279176.stgit@magnolia>
References: <157784047838.1357430.18292934559846279176.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
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
 

