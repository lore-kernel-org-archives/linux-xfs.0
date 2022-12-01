Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FC1C43217
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 09:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiLAJeV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 04:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiLAJeU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 04:34:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F8C5EFA8
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 01:34:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE60161F0D
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB16C433D6
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669887255;
        bh=KXLzKsW5hXICIjuI+F9aUwUtTWAd9arC8ZoJZfNpxyk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bg62m5t6JAWudI3IcIcSEkWvij6axaehXEfFWXg/SiQBcpt6DrODHUm4W4cUFz5VZ
         dEFKa9iCn1X3FptEnb0HBCHEmEJSyh1/UdV19Ko4y2uZXY6h9PTYZZdA65HILYtlJs
         n7XCE4SAFuHmBnBFNFniELJx1o9MH4gd/AzldOsAvp5JOqjSdkaLqgQOB6kHCHTiNl
         5ROM6v2BwGNMw+BOwtBzSWfocDxkY7DU/w7ZLYD78ewPlYsODwynT29UWcORjoL2IO
         jyesaTuoDqlnJM2MPS6Tuve2awZ8NUfRHdeHaHK5kS1RZE7WWx2guptOYrW98zVwXb
         fNRlWW7EFgJdw==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Date:   Thu,  1 Dec 2022 10:34:07 +0100
Message-Id: <20221201093408.87820-2-cem@kernel.org>
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

Fixes-coverity-id: 1512651

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Rename error label from err_agf to err_pag
	- pass error directly to libxfs_btree_del_cursor() without
	  using ternary operator
V3:
	- Rename the remaining 2 err labels to match what they are freeing

 repair/rmap.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index 2c809fd4f..9ec5e9e13 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1379,7 +1379,7 @@ check_refcounts(
 	if (error) {
 		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
 				agno);
-		goto err;
+		goto err_pag;
 	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
@@ -1388,7 +1388,7 @@ check_refcounts(
 	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
 		do_warn(_("Not enough memory to check refcount data.\n"));
-		goto err;
+		goto err_agf;
 	}
 
 	rl_rec = pop_slab_cursor(rl_cur);
@@ -1401,7 +1401,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_cur;
 		}
 		if (!have) {
 			do_warn(
@@ -1416,7 +1416,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_cur;
 		}
 		if (!i) {
 			do_warn(
@@ -1446,14 +1446,12 @@ next_loop:
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
+err_cur:
+	libxfs_btree_del_cursor(bt_cur, error);
+err_agf:
+	libxfs_buf_relse(agbp);
+err_pag:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rl_cur);
 }
 
-- 
2.30.2

