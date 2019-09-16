Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC8AC4CED3
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA6E1214AF
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732370AbfIPMQi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731514AbfIPMQi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:38 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFFEC3084031
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DBB35C1D6
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 04/11] xfs: track best extent from cntbt lastblock scan in alloc cursor
Date:   Mon, 16 Sep 2019 08:16:28 -0400
Message-Id: <20190916121635.43148-5-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the size lookup lands in the last block of the by-size btree, the
near mode algorithm scans the entire block for the extent with best
available locality. In preparation for similar best available
extent tracking across both btrees, extend the allocation cursor
with best extent data and lift the associated state from the cntbt
last block scan code. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 63 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5c34d4c41761..ee46989ab723 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -716,6 +716,11 @@ struct xfs_alloc_cur {
 	struct xfs_btree_cur		*cnt;	/* btree cursors */
 	struct xfs_btree_cur		*bnolt;
 	struct xfs_btree_cur		*bnogt;
+	xfs_agblock_t			rec_bno;/* extent startblock */
+	xfs_extlen_t			rec_len;/* extent length */
+	xfs_agblock_t			bno;	/* alloc bno */
+	xfs_extlen_t			len;	/* alloc len */
+	xfs_extlen_t			diff;	/* diff from search bno */
 	unsigned			busy_gen;/* busy state */
 	bool				busy;
 };
@@ -735,6 +740,11 @@ xfs_alloc_cur_setup(
 
 	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
 
+	acur->rec_bno = 0;
+	acur->rec_len = 0;
+	acur->bno = 0;
+	acur->len = 0;
+	acur->diff = -1;
 	acur->busy = false;
 	acur->busy_gen = 0;
 
@@ -1247,10 +1257,7 @@ xfs_alloc_ag_vextent_near(
 	 * but we never loop back to the top.
 	 */
 	while (xfs_btree_islastblock(acur.cnt, 0)) {
-		xfs_extlen_t	bdiff;
-		int		besti=0;
-		xfs_extlen_t	blen=0;
-		xfs_agblock_t	bnew=0;
+		xfs_extlen_t	diff;
 
 #ifdef DEBUG
 		if (dofirst)
@@ -1281,8 +1288,8 @@ xfs_alloc_ag_vextent_near(
 				break;
 		}
 		i = acur.cnt->bc_ptrs[0];
-		for (j = 1, blen = 0, bdiff = 0;
-		     !error && j && (blen < args->maxlen || bdiff > 0);
+		for (j = 1;
+		     !error && j && (acur.len < args->maxlen || acur.diff > 0);
 		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
 			/*
 			 * For each entry, decide if it's better than
@@ -1301,44 +1308,40 @@ xfs_alloc_ag_vextent_near(
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ASSERT(args->len >= args->minlen);
-			if (args->len < blen)
+			if (args->len < acur.len)
 				continue;
-			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
+			diff = xfs_alloc_compute_diff(args->agbno, args->len,
 				args->alignment, args->datatype, ltbnoa,
 				ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
-			    (args->len > blen || ltdiff < bdiff)) {
-				bdiff = ltdiff;
-				bnew = ltnew;
-				blen = args->len;
-				besti = acur.cnt->bc_ptrs[0];
+			    (args->len > acur.len || diff < acur.diff)) {
+				acur.rec_bno = ltbno;
+				acur.rec_len = ltlen;
+				acur.diff = diff;
+				acur.bno = ltnew;
+				acur.len = args->len;
 			}
 		}
 		/*
 		 * It didn't work.  We COULD be in a case where
 		 * there's a good record somewhere, so try again.
 		 */
-		if (blen == 0)
+		if (acur.len == 0)
 			break;
-		/*
-		 * Point at the best entry, and retrieve it again.
-		 */
-		acur.cnt->bc_ptrs[0] = besti;
-		error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
-		if (error)
-			goto out;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
-		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-		args->len = blen;
 
 		/*
-		 * We are allocating starting at bnew for blen blocks.
+		 * Allocate at the bno/len tracked in the cursor.
 		 */
-		args->agbno = bnew;
-		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltbno + ltlen);
-		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, ltbno,
-					ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
+		args->agbno = acur.bno;
+		args->len = acur.len;
+		ASSERT(acur.bno >= acur.rec_bno);
+		ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
+		ASSERT(acur.rec_bno + acur.rec_len <=
+		       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+
+		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt,
+				acur.rec_bno, acur.rec_len, acur.bno, acur.len,
+				0);
 		if (error)
 			goto out;
 		trace_xfs_alloc_near_first(args);
-- 
2.20.1

