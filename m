Return-Path: <SRS0=Ae7g=DD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBB6C2D0A8
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F7C221EA
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Sep 2020 13:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhGLGtaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgIZNOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Sep 2020 09:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIZNOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Sep 2020 09:14:42 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF2FC0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d19so858746pld.0
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 06:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lztcMcUrUT/A5IBGuQdOsap/0bbfc8yh28EwhZCb9xk=;
        b=fhGLGtaKpd4Ox+fMicXr2OKN9rR6fcEow9A+xD2tDuDzxzQcaHAl0zoo5ElgKL6Gtg
         aeKoSlE5qn8b5PbgeDPvpQcj6cQL9e0sW8VaGdet8CJUOKg+WhuQVtPH/fgJCdef86mV
         azs/TTbkPnNgTJa3kHGWbNNDAmtk4ultkK+xDz5meU5CBbg1WaE4CL3aEFczJgX9j4Ud
         Y4qqVyTW/yVliennYynkQnRHj1y8t75H84WuV9kBk6le7Asq5kVggBDo+3Vc6Y/tD5e8
         l9TKIGU1kKLDI3rCWoRve1wkfH+lNvNsbqYUkTtKli0ZXg09F82+ZPSJPiG2WYfDAxWD
         meOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lztcMcUrUT/A5IBGuQdOsap/0bbfc8yh28EwhZCb9xk=;
        b=RTzpUEjKMNbSeCVi/ytIAYr6jFA0D1dPuI4xWfATVGCVjzMfjJ4hdgPvXzMOSEjcaP
         +5RUUkAQsdwdrkARUY7P63Bar8iRBjgZk/Dmr65Nvw7AN7nAnOr777JD2h2xdS/E+zMC
         pbT0QlQNlkbmtH9CTspo6nLsK3Boy8aAvUaWLzrd5iN6cL3sYYEaCGWJxs8X/MSRGj+2
         dFBvdZXcfD5vKgOBVC7MvnOsZqZD8dvUzpve+CWBcn9eJDhwgI+DVRoy1cQvskVl9U7j
         7jkGCk8JVADPW2jUPug0f7I45xFTo4icSpfCJUaLt00TPaL6luU1CV9NSZbrr9Lg1FEp
         8U6Q==
X-Gm-Message-State: AOAM530zaqp4OjjbMZTPiDWvivY/yIQgLXzvOQSsWOd2nEmO9pXn5lU9
        Pl5/y4UunKjDIeefF27bUmAUt5G7oQ==
X-Google-Smtp-Source: ABdhPJwTNibMxDglALmLGT36hDevAy/8nhdypLFq891MfCphdyClbugtrh1nCbhi49+epsTF7F0X/g==
X-Received: by 2002:a17:90a:ea09:: with SMTP id w9mr1906871pjy.203.1601126081654;
        Sat, 26 Sep 2020 06:14:41 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h12sm5623846pfo.68.2020.09.26.06.14.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Sep 2020 06:14:40 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 2/4] xfs: fix the indent in xfs_trans_mod_dquot
Date:   Sat, 26 Sep 2020 21:14:31 +0800
Message-Id: <1601126073-32453-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The formatting is strange in xfs_trans_mod_dquot, so do a reindent.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
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

