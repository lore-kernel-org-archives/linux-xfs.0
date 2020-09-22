Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B80C4727E
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EB82399A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 09:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="np7G+7HS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgIVJEK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 05:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIVJEK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 05:04:10 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBBDC061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so11831058pff.6
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 02:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FYKn1wb5Rdr878OjtibLJ6tDsyGCAsfjF8Yre3B8Cgk=;
        b=np7G+7HSDRQVLgDOjpG7/lsipwVOcUz9AMBNd7dje5HHbqJGLT+UvZxd+a5Isjcup5
         ZISathE4YPvSdR/zXl8SvsPgKIIcLFLUm7kEIV1vbVu7Bkpg7dTr2kFlZ/deUuZRp68Q
         hzoGAYUSfh1EgWcaKyJ4JGGnRk6g9Ic/oHO8N2hFLQNTdXcgjF7grGe7J58UssqMKWjY
         mGX6yTSmqFDs2oVwi99iN/b+TlyAMVwP6glteUusMG3CAb+qaTPKy9gnfBftNEMGuYZq
         2h7HlmQBKAJih336AbN+0QyGlnuIQOca2QFPTM08bQ/CgAO1usInKsfEgMTsbMJjDBiS
         Y43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FYKn1wb5Rdr878OjtibLJ6tDsyGCAsfjF8Yre3B8Cgk=;
        b=fJmMUL2d8Sc6Im8GX+zr64FBs4II2dLuz2w2fGR1XN8OEzPaMpZs/0F+oEYlhn1uco
         hf2RQQsqunNnURdEqikyhM8IRy+NLY4QSc2FVJnTeGtnOu8pSoHJL2j56hi0Ii/ddNRV
         CRsCBGUXBmwsB56isR6BGm60UGII6WiOLkO6tDNtKP+lbNiN1/o5DLsA6SpWfclesPbl
         LQjIcqbIWZhxpIX2rsS8WAwgM5p40nNCtwe/USbbai0XmKyeYFxQYjYi0Rfvms8U6ra/
         5sUJcvSWHk2zfjdc+68DbBTXpe1jwtdDC4B6XapTugMPsgWuK3jD8fCpFt45Z8yrz2fl
         bDcw==
X-Gm-Message-State: AOAM530REB9bqDUTnfgF7so3GZTSXCHh4YrovQAvTE0rUTJPdoM+RK4w
        RYXzl4wKsPXzg6VVG0suaOu6UpP9Bg==
X-Google-Smtp-Source: ABdhPJzpenrNr2DQjSWEGBMCgO5wuzYBu8KkO+VxSzCoyQkzUnYdoPb84fP1wqCISHAwVHUzHatmtQ==
X-Received: by 2002:a17:902:7281:b029:d2:2a0b:f050 with SMTP id d1-20020a1709027281b02900d22a0bf050mr3776802pll.42.1600765449219;
        Tue, 22 Sep 2020 02:04:09 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h8sm13815653pfk.19.2020.09.22.02.04.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:04:08 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH 1/3] xfs: directly return if the delta equal to zero
Date:   Tue, 22 Sep 2020 17:04:00 +0800
Message-Id: <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

It is useless to go on when the variable delta equal to zero in
xfs_trans_mod_dquot(), so just return if the value equal to zero.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_trans_dquot.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 133fc6fc3edd..23c34af71825 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -215,10 +215,11 @@ xfs_trans_mod_dquot(
 	if (qtrx->qt_dquot == NULL)
 		qtrx->qt_dquot = dqp;
 
-	if (delta) {
-		trace_xfs_trans_mod_dquot_before(qtrx);
-		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
-	}
+	if (!delta)
+		return;
+
+	trace_xfs_trans_mod_dquot_before(qtrx);
+	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	switch (field) {
 
@@ -284,8 +285,7 @@ xfs_trans_mod_dquot(
 		ASSERT(0);
 	}
 
-	if (delta)
-		trace_xfs_trans_mod_dquot_after(qtrx);
+	trace_xfs_trans_mod_dquot_after(qtrx);
 
 	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
-- 
2.20.0

