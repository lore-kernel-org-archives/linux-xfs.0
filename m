Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F968C54EE9
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 14:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbiIBOS5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238929AbiIBOSk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 10:18:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D05106DAF
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 06:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F36BB82AA1
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC51C433D6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662126232;
        bh=2PIHwO5HxRmn5jSKGY3/QB3+5c+w5G1wKIxiJKmbp2E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NUzQ8sm9xB2VBDEmdY0T1hYabz5Ggv8emdDR9X8OJvCWJVAZQWD+5q2jyrin9h5n+
         zwCXAwjmAvXM9gNlgy+QfhF8aipL+xdSeVv2dpgctAK55yq9TBKqXLJuJqjZStj0y4
         +XGYVvaER66Wq5lmgGmXDn+dYnHGaiDalYPrF0bHgGrsEbCCRyk8YHxkPwe1UmjVKg
         BejQ5Tv5u+nNf3SnwC4PvdQcnSsnuxshOgr83ne7c56pqkGE50N5kx1LBRifxy1Hs+
         4bbqfkeK76F+bXdi+6WmdVfg/xXCfmEiXIel5E2xMoqcXrUqxJaqg6UGwih+GHfygW
         oToz2BUr9Z7cw==
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs_repair: Fix rmaps_verify_btree() error path
Date:   Fri,  2 Sep 2022 15:43:48 +0200
Message-Id: <166212622823.31305.7621804364378399970.stgit@andromeda>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <166212614879.31305.11337231919093625864.stgit@andromeda>
References: <166212614879.31305.11337231919093625864.stgit@andromeda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

Add proper exit error paths to avoid checking all pointers at the current path

Fixes-coverity-id: 1512654

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 repair/rmap.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index 0253c0c36..8b76e290b 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1002,7 +1002,7 @@ rmaps_verify_btree(
 	if (error) {
 		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
 				agno);
-		goto err;
+		goto err_agf;
 	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
@@ -1011,7 +1011,7 @@ rmaps_verify_btree(
 	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		do_warn(_("Not enough memory to check reverse mappings.\n"));
-		goto err;
+		goto err_bt_cur;
 	}
 
 	rm_rec = pop_slab_cursor(rm_cur);
@@ -1021,7 +1021,7 @@ rmaps_verify_btree(
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 					agno, rm_rec->rm_startblock);
-			goto err;
+			goto err_loop;
 		}
 
 		/*
@@ -1037,7 +1037,7 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 				do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 						agno, rm_rec->rm_startblock);
-				goto err;
+				goto err_loop;
 			}
 		}
 		if (!have) {
@@ -1088,13 +1088,12 @@ next_loop:
 		rm_rec = pop_slab_cursor(rm_cur);
 	}
 
-err:
-	if (bt_cur)
-		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
-	if (pag)
-		libxfs_perag_put(pag);
-	if (agbp)
-		libxfs_buf_relse(agbp);
+err_loop:
+	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+err_bt_cur:
+	libxfs_buf_relse(agbp);
+err_agf:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rm_cur);
 }
 

