Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DCDC4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561662075A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 14:51:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vO83gZoC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgJGOvX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 10:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 10:51:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E4FC061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 07:51:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id j8so1150973pjy.5
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 07:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ujh7JXPTlTrgYw6aP5Lx2tc6stJVA14BYQP8YmEXa38=;
        b=vO83gZoCpoYHL0b1HWDLBhnb5sTOYH8z1lyT4llkrfuaEaU1CiMAX7ocyx3OYTYlAg
         esCFP6lba0nySQVt9/hotNF3o40mgosN6ImC4CUFa8uJa88mn/J3ZiLHT4mnuaMxGsW9
         FulZOIiIEYsARWEJqKo3ZI54Y0K2H2JY7iolR8065Pw0k0SLBEvJlXI9hrvow6qEBtwL
         fz0UKIqBc+i5C+5u17w/UI4LNJOv8eocxvZkhHTkfA8U4zPYE3HzRI5L9Jxd1IoZPTcx
         QEqmGsPTg0d3ka03UP++c6yoo18bEEyfOSUSr7RTIDvkwkSbhEYFuLqXSApqMDteRptU
         EwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ujh7JXPTlTrgYw6aP5Lx2tc6stJVA14BYQP8YmEXa38=;
        b=iXJam85qtQeeLGzYq1wlnV5VPCE66VHzMITy8LKZchH6RpVnt1eP0/soCRdyNsyrLh
         1tImxRw9rdc3/Wx+o2fcTq0iDiE6BQDW0I7imiBkjCuYD2L1FhF4lCBavfIj5Xn/O94p
         bUCebIcCaLX9hp72iRoHrMSYrHRcFKcRAQehC5cFg4lfuhI5jfhfqN6KTslrQpOnUXS7
         JqYdGVSXrW/P5UDAp3EbBvYVGcl60nruVWuTJiydmMxPyiMsjpj9k6/+VR35Fk8OchZI
         oN2SC1SfyVqM6KnLq8eAnGviKBcMqxTIHaLZBZT054YU5DAtUaUWIsMC8SjEhgKwDEBi
         YVOQ==
X-Gm-Message-State: AOAM532sJRMgDiwjkv5iw3ZcR3WIT7KjLHtawMa+kyBBSCiClQvWxAfQ
        Akw9eHZOXKfInbKuqZqrtGrrlqwW2GZI
X-Google-Smtp-Source: ABdhPJybPPcfdfB/TJI1cx78wTYcPvMwLePwvnmnGkbpglsRhRayprJzBRp3dK2sz8pW3ZeKZaCKFQ==
X-Received: by 2002:a17:90a:eb07:: with SMTP id j7mr3144400pjz.224.1602082282909;
        Wed, 07 Oct 2020 07:51:22 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x22sm3443402pfp.181.2020.10.07.07.51.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 07:51:22 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 2/5] xfs: fix the indent in xfs_trans_mod_dquot
Date:   Wed,  7 Oct 2020 22:51:09 +0800
Message-Id: <1602082272-20242-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The formatting is strange in xfs_trans_mod_dquot, so do a reindent.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 43 ++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 133fc6fc3edd..fe45b0c3970c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -221,36 +221,27 @@ xfs_trans_mod_dquot(
 	}
 
 	switch (field) {
-
-		/*
-		 * regular disk blk reservation
-		 */
-	      case XFS_TRANS_DQ_RES_BLKS:
+	/* regular disk blk reservation */
+	case XFS_TRANS_DQ_RES_BLKS:
 		qtrx->qt_blk_res += delta;
 		break;
 
-		/*
-		 * inode reservation
-		 */
-	      case XFS_TRANS_DQ_RES_INOS:
+	/* inode reservation */
+	case XFS_TRANS_DQ_RES_INOS:
 		qtrx->qt_ino_res += delta;
 		break;
 
-		/*
-		 * disk blocks used.
-		 */
-	      case XFS_TRANS_DQ_BCOUNT:
+	/* disk blocks used. */
+	case XFS_TRANS_DQ_BCOUNT:
 		qtrx->qt_bcount_delta += delta;
 		break;
 
-	      case XFS_TRANS_DQ_DELBCOUNT:
+	case XFS_TRANS_DQ_DELBCOUNT:
 		qtrx->qt_delbcnt_delta += delta;
 		break;
 
-		/*
-		 * Inode Count
-		 */
-	      case XFS_TRANS_DQ_ICOUNT:
+	/* Inode Count */
+	case XFS_TRANS_DQ_ICOUNT:
 		if (qtrx->qt_ino_res && delta > 0) {
 			qtrx->qt_ino_res_used += delta;
 			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);
@@ -258,17 +249,13 @@ xfs_trans_mod_dquot(
 		qtrx->qt_icount_delta += delta;
 		break;
 
-		/*
-		 * rtblk reservation
-		 */
-	      case XFS_TRANS_DQ_RES_RTBLKS:
+	/* rtblk reservation */
+	case XFS_TRANS_DQ_RES_RTBLKS:
 		qtrx->qt_rtblk_res += delta;
 		break;
 
-		/*
-		 * rtblk count
-		 */
-	      case XFS_TRANS_DQ_RTBCOUNT:
+	/* rtblk count */
+	case XFS_TRANS_DQ_RTBCOUNT:
 		if (qtrx->qt_rtblk_res && delta > 0) {
 			qtrx->qt_rtblk_res_used += delta;
 			ASSERT(qtrx->qt_rtblk_res >= qtrx->qt_rtblk_res_used);
@@ -276,11 +263,11 @@ xfs_trans_mod_dquot(
 		qtrx->qt_rtbcount_delta += delta;
 		break;
 
-	      case XFS_TRANS_DQ_DELRTBCOUNT:
+	case XFS_TRANS_DQ_DELRTBCOUNT:
 		qtrx->qt_delrtb_delta += delta;
 		break;
 
-	      default:
+	default:
 		ASSERT(0);
 	}
 
-- 
2.20.0

