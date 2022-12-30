Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51C1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbiLaBcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:32:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DFC18387
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:32:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5964D61CC4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2D2C433EF;
        Sat, 31 Dec 2022 01:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450328;
        bh=mCRhIQuJSqqFN4dEbzx2qxj0Xc5dxZ9n3mr4qasj790=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lsF0ObNXxTVztN10Iezwnh57tTIzdQzLIbjo+KazwfL+F7fOBDs+gRgeCQq8o3ntr
         69cA5mO92+gxEPMaKSajbL/nyGMz+RANyaEzyfKYzLjFnwPJqlDcMQp4IO9gFq3Zpr
         vG+I8rsvYQRCwf6KsyjuXjlyWwdbNKm75p5dC8Y+1j1uo1b87TK7aT4tTfNLYs42Db
         k61JJa6J9/gUum+waxgVnJy7VPj1ZZDkH3y9mA7zOW6vbAXM28TeizwO4rJA41QEDI
         phmfdTAhMaYuoE0UEauCBpWrdZf2dZyH2lcC+Dd1hV8yHWGiSV1vugklqbPNLM+90M
         YKCXmmMo6nS/A==
Subject: [PATCH 18/22] xfs: store rtgroup information with a bmap intent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867524.712847.2285503341227488941.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap.h |    5 ++++-
 fs/xfs/xfs_bmap_item.c   |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d870c6a62e40..05097b1d5c7d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index bf52d30d7d1c..04eeae9aef79 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -25,6 +25,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -362,8 +363,18 @@ xfs_bmap_update_get_group(
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
@@ -383,8 +394,11 @@ static inline void
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

