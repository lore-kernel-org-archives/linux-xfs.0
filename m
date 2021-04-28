Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90A2C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3666141E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhD1Gw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 02:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbhD1Gwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 02:52:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF502C061574
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:52:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q2so11116152pfk.9
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMZtID3aTWPUOjJKVVsjU+ykKHChdsXjZ+3XW9ECY+c=;
        b=UVyBZAGSfHTIuhEjj84zgamJFkOHLrSSq9av2evaegrXJaMOckdO4ygAx8CDtoUZ8W
         EYODFK9p7wDp2W9J3f6kWbSJCL8XSM5NHP0VW5iritDUFAKAIHrJYfkpbONtA/q01Xgd
         ae6GLEzhuj7mj3RY2JbhNKemCQdH9acxp2l5roZA/GSlb+R6xh98Bh+D59eyEbtrD51c
         syxOcB8clfyiEKBSQCuzOBfq97JcJD3Jdl/AFp44C4p4GknJnYZBmqnxyTDIVWPGFkey
         nga2oYrnl984t2RgLYgK+ARhSEtMqPnMOOw0GFZUnPgb+24B0f1z6e9n/5MUq5yNfZac
         G+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMZtID3aTWPUOjJKVVsjU+ykKHChdsXjZ+3XW9ECY+c=;
        b=RUxUzGrs1vzV5kXvdyoYd/MDCaUgpyff6QIDfuWXjWoT6uj0Z6aZ5+Xrit2gdAikkt
         si6HScUZX9+4lXNpFdDReoyRlRPOi+S95Qj14nMfXw4kxfizlL8fgqP2pzcF4d+auQZs
         EQn2hteBhiuw0vsqGRHOc2TAi4rHvNyno4LQkdZ3mH3Kg8wZwPMpNLWfa5yDXVAr47mr
         fxo3DZ4861xXVOCFW3as9SO0IYNCGifyAbXh08F/aqzH7Tfu+LVnbNETHFVU7d4Hh+Ql
         In2zwsPr/uE5HjvW9MwPdMfhfOvX2Wlq/6pptmL80bQTBBhAH4d7pdBn8TD3Gdyv7db5
         rEtQ==
X-Gm-Message-State: AOAM531x/QRiV6NtIM4szkVBtgQXc0KsbZwfUOgGkwyJtaZUjYQi1its
        b16Vva1qRgzB33eh0W7YFWxR/gKB/g0=
X-Google-Smtp-Source: ABdhPJzrvnZ378588ADr4UH+HmQ4rYmWDLDSokz7/M9/2SptSBXVC6OdxcNWQXrQhIiiolPZk+Youw==
X-Received: by 2002:a63:e552:: with SMTP id z18mr25656008pgj.100.1619592730110;
        Tue, 27 Apr 2021 23:52:10 -0700 (PDT)
Received: from localhost.localdomain ([122.171.137.194])
        by smtp.gmail.com with ESMTPSA id u12sm4039551pfh.122.2021.04.27.23.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 23:52:09 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH 1/2] xfs: Introduce XFS_EXTENT_BUSY_IN_TRANS busy extent flag
Date:   Wed, 28 Apr 2021 12:21:51 +0530
Message-Id: <20210428065152.77280-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds the busy extent flag XFS_EXTENT_BUSY_IN_TRANS which can be
used to check if a busy extent is still on a transaction's t_busy list. The
flag will be set when an extent is freed by __xfs_free_extent() and it is
cleared when the busy extent is moved to CIL's busy extent list.

This flag will be used in a future commit to prevent a deadlock when
populating an AG's AGFL.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 fs/xfs/xfs_extent_busy.h  | 1 +
 fs/xfs/xfs_log_cil.c      | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..7dc50a435cf4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3332,7 +3332,7 @@ __xfs_free_extent(
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	struct xfs_agf			*agf;
 	int				error;
-	unsigned int			busy_flags = 0;
+	unsigned int			busy_flags = XFS_EXTENT_BUSY_IN_TRANS;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 8aea07100092..929f72d1c699 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -28,6 +28,7 @@ struct xfs_extent_busy {
 	unsigned int	flags;
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
 #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
+#define XFS_EXTENT_BUSY_IN_TRANS	0x04
 };
 
 void
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b0ef071b3cb5..f91b69e92b85 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -390,6 +390,7 @@ xlog_cil_insert_items(
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
 	struct xfs_log_item	*lip;
+	struct xfs_extent_busy	*busy;
 	int			len = 0;
 	int			diff_iovecs = 0;
 	int			iclog_space;
@@ -410,6 +411,9 @@ xlog_cil_insert_items(
 	len += iovhdr_res;
 	ctx->nvecs += diff_iovecs;
 
+	list_for_each_entry(busy, &tp->t_busy, list)
+		busy->flags &= ~XFS_EXTENT_BUSY_IN_TRANS;
+
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &ctx->busy_extents);
-- 
2.30.2

