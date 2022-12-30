Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA045C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiL3Wrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiL3Wr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:47:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2306317890
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00FD61C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D65BC433EF;
        Fri, 30 Dec 2022 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440447;
        bh=gLALxO6vu3f2MrlWn71+XGvrEL+6CGkqeF/7ddnjWso=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k90frXERr/Y3lt+iy9j9w+tNZrC2ye6cpfBG7asJJSQhdwa2NCBeu8spKIQuzH2Cv
         JBUDEOaAn/7bpoWIzDZEyHXktgxG2+94DOM/w+6mbk456M4+QBUsnWOfv4ROr/Iv+z
         kjr18hH6TuxIn7ub0RGWC1+2Cr34qRys3iA9txEs3HE+7Mfi/qJ1zpjfyADTXwlKqn
         51obylba3qJ6rJi3NFfkm/Fw1TTHeoyEqAH/d0W2oKvxYgo+3yOem6NlS+ePhHB41a
         uEQ0PvD/+m/0q6x/8UiQ9f1fOobDUlt+2rolaGCsHAE44GmQCHRmaJn5sLVwq0oPCx
         QmnWMJAvxSSag==
Subject: [PATCH 3/6] xfs: flag free space btree records that could be merged
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:42 -0800
Message-ID: <167243830266.686829.7580042084001634501.stgit@magnolia>
In-Reply-To: <167243830218.686829.12866790282629472160.stgit@magnolia>
References: <167243830218.686829.12866790282629472160.stgit@magnolia>
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
 fs/xfs/scrub/alloc.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index e9f8d29544aa..94f4b836c48d 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -31,6 +31,12 @@ xchk_setup_ag_allocbt(
 }
 
 /* Free space btree scrubber. */
+
+struct xchk_alloc {
+	/* Previous free space extent. */
+	struct xfs_alloc_rec_incore	prev;
+};
+
 /*
  * Ensure there's a corresponding cntbt/bnobt record matching this
  * bnobt/cntbt record, respectively.
@@ -93,6 +99,24 @@ xchk_allocbt_xref(
 	xchk_xref_is_not_cow_staging(sc, agbno, len);
 }
 
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_allocbt_mergeable(
+	struct xchk_btree	*bs,
+	struct xchk_alloc	*ca,
+	const struct xfs_alloc_rec_incore *irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (ca->prev.ar_blockcount > 0 &&
+	    ca->prev.ar_startblock + ca->prev.ar_blockcount == irec->ar_startblock &&
+	    ca->prev.ar_blockcount + irec->ar_blockcount < (uint32_t)~0U)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&ca->prev, irec, sizeof(*irec));
+}
+
 /* Scrub a bnobt/cntbt record. */
 STATIC int
 xchk_allocbt_rec(
@@ -100,6 +124,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
+	struct xchk_alloc	*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(bs->cur, &irec) != NULL) {
@@ -107,6 +132,7 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
+	xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;
@@ -118,10 +144,11 @@ xchk_allocbt(
 	struct xfs_scrub	*sc,
 	xfs_btnum_t		which)
 {
+	struct xchk_alloc	ca = { };
 	struct xfs_btree_cur	*cur;
 
 	cur = which == XFS_BTNUM_BNO ? sc->sa.bno_cur : sc->sa.cnt_cur;
-	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, NULL);
+	return xchk_btree(sc, cur, xchk_allocbt_rec, &XFS_RMAP_OINFO_AG, &ca);
 }
 
 int

