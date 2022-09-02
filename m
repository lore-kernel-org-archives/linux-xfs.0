Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BF5ECAAD5
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 14:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238670AbiIBOSF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238647AbiIBORp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 10:17:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B76115F8BC
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 06:43:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E4B262122
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A813C433D6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Sep 2022 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662126222;
        bh=FjUiWpbs+pTWDJZTcuUTrKMm7j00I11AwOsD7uyMeJs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ro3TmgjQNAghfTeRrljvQ4Xqef0mCReoRmkD1QXk3hAg/r5szEftaLmP2kUY1vFq0
         wFS+Ov8VT68uaROte8+rrgxcFUA4DaWQ/9x6Eks7tmyRi22vl5CbVZcY+Mlk9XMUu4
         ZlRFQ6Q/KkzVx7r51XW86BbF5QlDpkMrwmyYoCBsbFoNR92DY04o5Ly0qURLtz89sR
         LNgnyd97/0y2nx3XRL10wvUh/2vV6q3BKJf2+zGykHuu19LS7ep4Q5SpkUG0rMHg+u
         eG55xnEDpHwZaIEMwsmOqEFY4zv6A0NrTWZzyC9gJS1akYXNNtCeXlFBaP1e80kr4p
         53E6ZNCN65Y1g==
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Date:   Fri,  2 Sep 2022 15:43:39 +0200
Message-Id: <166212621918.31305.17388002689404843538.stgit@andromeda>
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

Fixes-coverity-id: 1512651

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 repair/rmap.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index a7c4b25b1..0253c0c36 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1377,7 +1377,7 @@ check_refcounts(
 	if (error) {
 		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
 				agno);
-		goto err;
+		goto err_agf;
 	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
@@ -1386,7 +1386,7 @@ check_refcounts(
 	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		do_warn(_("Not enough memory to check refcount data.\n"));
-		goto err;
+		goto err_bt_cur;
 	}
 
 	rl_rec = pop_slab_cursor(rl_cur);
@@ -1398,7 +1398,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_loop;
 		}
 		if (!have) {
 			do_warn(
@@ -1413,7 +1413,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_loop;
 		}
 		if (!i) {
 			do_warn(
@@ -1436,14 +1436,13 @@ next_loop:
 		rl_rec = pop_slab_cursor(rl_cur);
 	}
 
-err:
-	if (bt_cur)
-		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
-							XFS_BTREE_NOERROR);
-	if (pag)
-		libxfs_perag_put(pag);
-	if (agbp)
-		libxfs_buf_relse(agbp);
+err_loop:
+	libxfs_btree_del_cursor(bt_cur, error ?
+				XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+err_bt_cur:
+	libxfs_buf_relse(agbp);
+err_agf:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rl_cur);
 }
 

