Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D50C47088
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 09:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiLAJeT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLAJeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 04:34:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1B8B8D
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 01:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6A9461EFA
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8BDC433C1
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669887257;
        bh=ZnOwIxwee67jDlyhfJcBSrKEBX8tmJnCR7GIC+Xrs9A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rheilE2bFuJxh0gF8GbawDmGawaWOhAL0qwB80JZvFyBZSz8ZjrIzysbtUznwr/Ul
         Q9CVuZDkyyKZj1hsjxhZblTM462NjGgXya017nWOTsPS9yObuTU+sRkY7ZQPChrhl0
         jZ3ZSVk6GX8pYdsk3WbDz/4txtN7c9IA7kVjUoYKrZtXEifaM/AVEoS18Yw1MYrP1i
         8lJV/5vmvTdTHVuXLXjOc5JIWzohVJV4yBE5wKCAcaa47LTvpmkCUPwKDgcW46c2Rk
         OHQJK39NN0GaJrApaszjalcx7EcBEvJEZXWj5ERzInYGOkohfoSdyworqvbhCabWwF
         g03Y7Bimq3AfQ==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs_repair: Fix rmaps_verify_btree() error path
Date:   Thu,  1 Dec 2022 10:34:08 +0100
Message-Id: <20221201093408.87820-3-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221201093408.87820-1-cem@kernel.org>
References: <20221201093408.87820-1-cem@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Add proper exit error paths to avoid checking all pointers at the current path

Fixes-coverity-id: 1512654

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Rename error label from err_agf to err_pag
V3:
	- Rename the remaining 2 err labels to match what they are freeing

 repair/rmap.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index 9ec5e9e13..52106fd42 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1004,7 +1004,7 @@ rmaps_verify_btree(
 	if (error) {
 		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
 				agno);
-		goto err;
+		goto err_pag;
 	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
@@ -1013,7 +1013,7 @@ rmaps_verify_btree(
 	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
-		goto err;
+		goto err_agf;
 	}
 
 	rm_rec = pop_slab_cursor(rm_cur);
@@ -1023,7 +1023,7 @@ rmaps_verify_btree(
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 					agno, rm_rec->rm_startblock);
-			goto err;
+			goto err_cur;
 		}
 
 		/*
@@ -1039,7 +1039,7 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 				do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 						agno, rm_rec->rm_startblock);
-				goto err;
+				goto err_cur;
 			}
 		}
 		if (!have) {
@@ -1090,13 +1090,12 @@ next_loop:
 		rm_rec = pop_slab_cursor(rm_cur);
 	}
 
-err:
-	if (bt_cur)
-		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
-	if (pag)
-		libxfs_perag_put(pag);
-	if (agbp)
-		libxfs_buf_relse(agbp);
+err_cur:
+	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+err_agf:
+	libxfs_buf_relse(agbp);
+err_pag:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rm_cur);
 }
 
-- 
2.30.2

