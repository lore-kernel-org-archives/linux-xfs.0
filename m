Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215E9C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 13:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiK1NTK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 08:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiK1NSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 08:18:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE5E1E71D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 05:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338ED61186
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE56C433C1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669641369;
        bh=dN6uXEl0srgEbKyno2Ff5xmq1HBn2Q0cjb34YSNPgeo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PtAR88XmMckCBuS9QnZvC23YfEVP/3aAonp2Iv70s3jIHAh/iZmCnH0+tTQaCyC6J
         JEEtu90tDc1++mpxf2NJqjiOHfB8gPUexY4bP8BbonxeT7VM5N378FPWhonkQT/N7p
         Y5RLMknpHza4wcxHmpdtgkn1zcnTs9+Ul9UEth9v4hBFGLw1HV0644mUcld1Lg9Gis
         CZzjAINrU5UX6WkBNaNi+DXcA8ITQMhX7ho8YG3KqRRr8DneeyFB2+oJZefT/BG2xF
         Yg+QvdphD4MFwtq0yBEPhxk08RTUEoDNzlZFc0brV9ZW3lNyGEPMUu96GgTIWTNxm9
         uMSsqwz7wsb4Q==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs_repair: Fix check_refcount() error path
Date:   Mon, 28 Nov 2022 14:14:33 +0100
Message-Id: <20221128131434.21496-2-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128131434.21496-1-cem@kernel.org>
References: <20221128131434.21496-1-cem@kernel.org>
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

 repair/rmap.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index 2c809fd4f..e76a8f611 100644
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
+		goto err_bt_cur;
 	}
 
 	rl_rec = pop_slab_cursor(rl_cur);
@@ -1401,7 +1401,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_loop;
 		}
 		if (!have) {
 			do_warn(
@@ -1416,7 +1416,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err;
+			goto err_loop;
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
+err_loop:
+	libxfs_btree_del_cursor(bt_cur, error);
+err_bt_cur:
+	libxfs_buf_relse(agbp);
+err_pag:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rl_cur);
 }
 
-- 
2.30.2

