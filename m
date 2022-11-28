Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAFBC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Nov 2022 13:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiK1NTQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Nov 2022 08:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiK1NS6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2022 08:18:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A281E3C3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 05:16:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C4C96117A
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE58C433D6
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 13:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669641373;
        bh=eRI8B1+vq602Z7vo+SMEsMoX5D/JdHTy046yDCDxXjo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LIE2ZOPFyAdr39ZvHCx3Ri5ivqzjFCzTULY4Cd7YHdNTqv6j/qN9vAVL4+BlREi96
         ahy8l0ElsW2dTbN4XW6BwYlubT+tbSI23mRwcA0AHaGvXrYcyjmTQqLMIjvvt3RIGX
         5H2txOaq1CF2UwB7jDLeNsuhNQoGPm+1B0GYCaGp5XDMItBrF29sLh2MjUJVR11Jb+
         CX0RU27PR4iloNw/FXMFCzaQlsTUzuofNS19nUzF9hrCj+j/0i/AvVmWiSd59vShYp
         plZYdbLsJA+oNhcqEgMMD+nuII1EJiv1Tp2SdNuujmBk05Qgf+wmb1db+bekZiokCN
         zIYkueF5Vw4Yg==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs_repair: Fix rmaps_verify_btree() error path
Date:   Mon, 28 Nov 2022 14:14:34 +0100
Message-Id: <20221128131434.21496-3-cem@kernel.org>
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

Fixes-coverity-id: 1512654

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
V2:
	- Rename error label from err_agf to err_pag

 repair/rmap.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/repair/rmap.c b/repair/rmap.c
index e76a8f611..4001df57a 100644
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
+		goto err_bt_cur;
 	}
 
 	rm_rec = pop_slab_cursor(rm_cur);
@@ -1023,7 +1023,7 @@ rmaps_verify_btree(
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 					agno, rm_rec->rm_startblock);
-			goto err;
+			goto err_loop;
 		}
 
 		/*
@@ -1039,7 +1039,7 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 				do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
 						agno, rm_rec->rm_startblock);
-				goto err;
+				goto err_loop;
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
+err_loop:
+	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+err_bt_cur:
+	libxfs_buf_relse(agbp);
+err_pag:
+	libxfs_perag_put(pag);
 	free_slab_cursor(&rm_cur);
 }
 
-- 
2.30.2

