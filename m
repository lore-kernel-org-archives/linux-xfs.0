Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C398C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbiLaCeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbiLaCeP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:34:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4771CB21
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCA40B81C22
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C500C433EF;
        Sat, 31 Dec 2022 02:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454051;
        bh=hslgFdebPew+0RjSKZG69pr4YqNQXM5R/Dsrbuw7Q0w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hAT9RjMqBjx/jbZP+UQQ8htDYhtpyRgtywl44SR6VcUUrkVc39+wCaOkjMGRuK/Am
         w1zOLrlViE6xVDva3xrOaTTYBV86pB0V2Yo7g6wzALuGtYA/VcfkywHJmLsnE67SJg
         fsfX+gf61DTVPmHZJ7LEWQV16nP0QCInMVT7iTbRRmWtMg9jZStc6cUo13GdTAcddh
         viygKwKC/HWZqhCA5cN/inDjsmU75VroukT6EXIqTlIEqeOtxAYATXG0dZiCOikEE9
         P+ePmsAf+zmtkzy1nDdccKfES3CBJSW/aHBKSWJZUIjTYdNhiPvBWvSk4iW2PAsVgu
         gj2tV+tuuNqHA==
Subject: [PATCH 16/45] xfs: store rtgroup information with a bmap intent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878576.731133.2170551438718575869.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the bmap intent items take an active reference to the rtgroup
containing the space that is being mapped or unmapped.  We will need
this functionality once we start enabling rmap and reflink on the rt
volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   17 +++++++++++++++--
 libxfs/xfs_bmap.h   |    5 ++++-
 2 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 316cc87a802..be6ecbc348f 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -479,8 +479,18 @@ xfs_bmap_update_get_group(
 {
 	xfs_agnumber_t		agno;
 
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(mp)) {
+			xfs_rgnumber_t	rgno;
+
+			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
+			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+		} else {
+			bi->bi_rtg = NULL;
+		}
+
 		return;
+	}
 
 	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
 	bi->bi_pag = xfs_perag_get(mp, agno);
@@ -500,8 +510,11 @@ static inline void
 xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
+	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
+			xfs_rtgroup_put(bi->bi_rtg);
 		return;
+	}
 
 	xfs_perag_drop_intents(bi->bi_pag);
 	xfs_perag_put(bi->bi_pag);
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index d870c6a62e4..05097b1d5c7 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -241,7 +241,10 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
-	struct xfs_perag			*bi_pag;
+	union {
+		struct xfs_perag		*bi_pag;
+		struct xfs_rtgroup		*bi_rtg;
+	};
 	struct xfs_bmbt_irec			bi_bmap;
 };
 

