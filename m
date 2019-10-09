Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A9EECE58C
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C947D218DE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TbeU9+vV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbfJIQsv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:48:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55732 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfJIQsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:48:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjbFr003517
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8DIJKsGUmskKjaNWKviAj9HIQJY+2JGhYNi0+5/jkLk=;
 b=TbeU9+vVoMBjUKQYnnlKr7frIfuikjPjAAoROOqT5fIM/WlSIMyFviEn8HfzsOcsGhEb
 MBUh038Ed0zvnK3xHxXVkjXcAlL4HmOC2Fxu2CT153ZCD/kDRDHqNQontrJGrJ4Ajkl7
 5DvHFOf3ejpLmoou41l36ZtdVdHO86cSAHZpma0aw2sF2zFExEakLUtgJOs7tldghi1l
 pYAbVML+KoI1hyJRhMsr/lCj8UsLbEx0/rtllO1DypK5bZ2+ILuBo4fgHcXqYoNem1ZN
 xRCVQbjJCDq0qa9ey7LbR+J1nXN8NlptCMjTYtxQFJtOCeFu9BgDT3DA6scz5EzqFUW2 Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vek4qnyrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GiZQi174294
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vhhsmwyn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x99Gmm6N021345
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:48:48 -0700
Subject: [PATCH 2/3] xfs: only invalidate blocks if we're going to free them
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:48:47 -0700
Message-ID: <157063972723.2913192.12835516373692425243.stgit@magnolia>
In-Reply-To: <157063971218.2913192.8762913814390092382.stgit@magnolia>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
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
 fs/xfs/scrub/repair.c |   76 +++++++++++++++++++++++--------------------------
 fs/xfs/scrub/repair.h |    1 -
 2 files changed, 35 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3a58788e0bd8..e21faef6db5a 100644
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
@@ -515,6 +477,35 @@ xrep_put_freelist(
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
+	 * For each block in each extent, see if there's an incore buffer for
+	 * exactly that block; if so, invalidate it.  The buffer cache only
+	 * lets us look for one buffer at a time, so we have to look one block
+	 * at a time.  Avoid invalidating AG headers and post-EOFS blocks
+	 * because we never own those; and if we can't TRYLOCK the buffer we
+	 * assume it's owned by someone else.
+	 */
+	/* Skip AG headers and post-EOFS blocks */
+	if (!xfs_verify_fsbno(sc->mp, fsbno))
+		return;
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
@@ -568,12 +559,15 @@ xrep_reap_block(
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
 

