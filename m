Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8255C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJBSf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJBSf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:35:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6B62B253
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25507B80D82
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB632C433D6;
        Sun,  2 Oct 2022 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735752;
        bh=1R/peNgFfbvh3HRi+Z9pxPrqHu/NLBLBwInbxPoWoRw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fxontAQUh5ENcbbSmqob1mHk2mZwvF/oDgQG8Uhs+4zt8jNxRr3mZ7s9itsFE53uH
         MWAk0mXgWI9iWh0gjzkg5yLEVd5p/0ojB2Eu12CSZUB+pR9SDm+6pbUrToRUKnCQtR
         +Af2JiqMP6HGh0Tj94cIaeZ49i7oiv6XYRJlwzg3xdmQCoOqugxVKCR+cSGIjll3u0
         6/w3C8JgrPt5xyYr5CyddjGc+7UEngVt2ighjgSZ7QV3bqb+hppwr428ZOIhxdvCTe
         ub3iL4NwR1SEpToKkE928ddNwRuANAi9VDxR+p8NNRunQlyflsQvrOmQmuhqXl5+Yi
         BKF0Z6BUiXFQg==
Subject: [PATCH 3/6] xfs: flag free space btree records that could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:36 -0700
Message-ID: <166473483646.1084923.10060980464175596930.stgit@magnolia>
In-Reply-To: <166473483595.1084923.1946295148534639238.stgit@magnolia>
References: <166473483595.1084923.1946295148534639238.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Complain if we encounter free space btree records that could be merged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 0cd20d998368..de4b7c34275a 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -31,6 +31,13 @@ xchk_setup_ag_allocbt(
 }
 
 /* Free space btree scrubber. */
+
+struct xchk_alloc {
+	/* Previous free space extent. */
+	xfs_agblock_t		prev_bno;
+	xfs_extlen_t		prev_len;
+};
+
 /*
  * Ensure there's a corresponding cntbt/bnobt record matching this
  * bnobt/cntbt record, respectively.
@@ -91,6 +98,25 @@ xchk_allocbt_xref(
 	xchk_xref_is_not_cow_staging(sc, agbno, len);
 }
 
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_allocbt_mergeable(
+	struct xchk_btree	*bs,
+	struct xchk_alloc	*ca,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (ca->prev_len > 0 && ca->prev_bno + ca->prev_len == bno &&
+	    ca->prev_len + len < (uint32_t)~0U)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	ca->prev_bno = bno;
+	ca->prev_len = len;
+}
+
 /* Scrub a bnobt/cntbt record. */
 STATIC int
 xchk_allocbt_rec(
@@ -98,6 +124,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec *rec)
 {
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
+	struct xchk_alloc	*ca = bs->private;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 
@@ -109,6 +136,7 @@ xchk_allocbt_rec(
 	    !xfs_verify_agbno(pag, bno + len - 1))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
+	xchk_allocbt_mergeable(bs, ca, bno, len);
 	xchk_allocbt_xref(bs->sc, bno, len);
 
 	return 0;
@@ -120,10 +148,11 @@ xchk_allocbt(
 	struct xfs_scrub	*sc,
 	xfs_btnum_t		which)
 {
+	struct xchk_alloc	ca = { .prev_len = 0 };
 	struct xfs_btree_cur	*cur;
 
 	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
-	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, NULL);
+	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, &ca);
 }
 
 int

