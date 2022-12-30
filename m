Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24CEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiLaB4K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiLaB4I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:56:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279CB5F76
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7571FCE19E6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A0FC433D2;
        Sat, 31 Dec 2022 01:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451764;
        bh=uew8H4Sc10IVJ3VmA+bYQwJQrBvdRbPe2/87iLkab+Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZS4btJfFacvyBsZfOtZCP/OLVZBJId6Rrso6Qd9i28jQJePwVvb/kWlvA9I9TyQ/Z
         FYD7VhVNFReA+z5ePwZmJiY0ZrmWvA+m+Mn6s5oweQcpG8pb43g9E6IxknCU38CW3V
         0XA/kpydouxrVvxVPbtg8a8gH8uAc7+lEti0E/OLEn3fd8lYMV8sVf+ScwOmvymc9H
         CVkMy2ToKOsuPYYbPBLEeEDl9b+o0tWgToJSIBnC0GxtPNN5dmPFfJbzFW/8Xs/R4v
         eArdf09m4SHiAxNu5udE/cEJjkRj+JiRXFLIu5edZLVakKt4BM1XRMhtprxTTmI1jI
         X6n09nP4BhpEQ==
Subject: [PATCH 31/42] xfs: allow overlapping rtrmapbt records for shared data
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871338.717073.13427743306191179302.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow overlapping realtime reverse mapping records if they both describe
shared data extents and the fs supports reflink on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index e89d5310117a..3ff4151b2c0a 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -86,6 +86,18 @@ struct xchk_rtrmap {
 	struct xfs_rmap_irec	prev_rec;
 };
 
+static inline bool
+xchk_rtrmapbt_is_shareable(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (!xfs_has_rtreflink(sc->mp))
+		return false;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		return false;
+	return true;
+}
+
 /* Flag failures for records that overlap but cannot. */
 STATIC void
 xchk_rtrmapbt_check_overlapping(
@@ -107,7 +119,10 @@ xchk_rtrmapbt_check_overlapping(
 	if (pnext <= irec->rm_startblock)
 		goto set_prev;
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	/* Overlap is only allowed if both records are data fork mappings. */
+	if (!xchk_rtrmapbt_is_shareable(bs->sc, &cr->overlap_rec) ||
+	    !xchk_rtrmapbt_is_shareable(bs->sc, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
 	/* Save whichever rmap record extends furthest. */
 	inext = irec->rm_startblock + irec->rm_blockcount;

