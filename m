Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9250C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiLaBjc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBja (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:39:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7755413DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D1CEB81DE3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FC0C433EF;
        Sat, 31 Dec 2022 01:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450766;
        bh=2RGy5Hxc+xlxTiUsteidMGaD89DNew6s9YlKxN88S6o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m2qkWkITNF7mY/yyspwSD42YDGONpapVy7CFuT8u96nTnRa5u7wUl15+6Pyt5vQ+y
         A2JOQ/vq8WT2SuUDVT6Eb05ZpU6+hkUA0I9GTZ4goTmcQqdWGpkjkKOk0sUJBq/NVV
         zt4jNq79ZsmoIxButycgn4nAX4C1Tgw/CrMurF/msQcZSs6BqELJ7asly2NLsOhOZy
         vPYoZZGWWTxuh4bp5KMQDBuOJA4g+fz/JQ0sszt9JK971HGpHbcPVllYZP3rpqlbrV
         2IvRIGk4sUwKf8YGXcuYL0odKIK7kuu/IRZgxoSJfhb5YosMLNwhJRdQNbeDlYNhe3
         VWdLpBpdvea+A==
Subject: [PATCH 10/38] xfs: add realtime rmap btree block detection to log
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869742.715303.9448242223459976161.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Identify rtrmapbt blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index b74d40f5beb1..496260c9d8cd 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -259,6 +259,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
@@ -768,6 +771,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

