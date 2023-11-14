Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585E6C072A2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjKNBxx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjKNBxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:53 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EDDD44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:50 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc37fb1310so38289365ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926829; x=1700531629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1d4Xl/TZSUhhcv89hxSw9fQ4xqgWI2PHSQb3xcxvXPA=;
        b=Ks1Hen+qKssVKsE1iMKShGLD74s4kw6GgZ0F1H+s0nSJzTAKE48RO7ROWmfesRoe3D
         tgCJcRqHbfCzv0KDbx0t0kaR/dT85UJoZKxjDBjth7T3NVXiv0gmZC2TPPJXGHBPTobr
         xdSBAqhLnx7ecwpREV4NV0VLbeiJaLcwzmwc01BXxvBDpgMwd2jLXHRZDTEqrPeIRLUG
         zSV8TaR51IsUEojb0kSWAP7PZZHYB6R4SvGjdqYEi+j/M81eNrxyKgHOnkO4uidGsSWa
         MgN9nEwTy06OGpkFLLTyYnSgmjuXtMWhVNn2b7ggFXni529hk2gREaw3cOlx9n7Pybud
         iXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926829; x=1700531629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1d4Xl/TZSUhhcv89hxSw9fQ4xqgWI2PHSQb3xcxvXPA=;
        b=HSup6SKCcpK9X/gC7YULt05Ydr0flyM1w9axK1Ct9kqF1nF+e9KcsZYF+yIh3C8P53
         MN8j5qxR6+S/Kb7vBCsPjtYLMSv+zYW0mROLzN3JTUkgaFE8murisrH7ngG9cgRU0mMl
         YTR716D78oe8iSSZkiUq80f9H+dBbJB3GLv/JIkMD2/cVqWONMk4YDGa/5CthmMKg+e5
         9XrV8Bwrmhc88TyZFEW0WpSxWmeAZiiRs8LjmhBTN2xtHEyhD2udD0GEP3Vw7LC77PHE
         4FFsk7NbJHl1+KbmRIWEQDlFHF13FtWCeCR8jEgu33PKebWx1KMgkvMEI9crzYMcJEAs
         jJpg==
X-Gm-Message-State: AOJu0YyvtM/hRHBKtCj3Q3+iRa002zLJA+mrs3onM9OG/+8e2R3EFwry
        F9SEoO0j8LrBm69ObqR9b0DbF1OXwjRrdQ==
X-Google-Smtp-Source: AGHT+IELMrMh7F2eg7URcAu7Q5XqR4AaGT5CqQBcOmGkMClESF6JMbdi2K45aQDaY/k5pgMhQn85bQ==
X-Received: by 2002:a17:902:d2ce:b0:1c3:845d:a4 with SMTP id n14-20020a170902d2ce00b001c3845d00a4mr1102476plc.51.1699926829546;
        Mon, 13 Nov 2023 17:53:49 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:49 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 03/17] xfs: convert buf_cancel_table allocation to kmalloc_array
Date:   Mon, 13 Nov 2023 17:53:24 -0800
Message-ID: <20231114015339.3922119-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 910bbdf2f4d7df46781bc9b723048f5ebed3d0d7 ]

While we're messing around with how recovery allocates and frees the
buffer cancellation table, convert the allocation to use kmalloc_array
instead of the old kmem_alloc APIs, and make it handle a null return,
even though that's not likely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 +-
 fs/xfs/xfs_buf_item_recover.c   | 14 ++++++++++----
 fs/xfs/xfs_log_recover.c        |  4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index b8b65a6e9b1e..81a065b0b571 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -120,7 +120,7 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-void xlog_alloc_buf_cancel_table(struct xlog *log);
+int xlog_alloc_buf_cancel_table(struct xlog *log);
 void xlog_free_buf_cancel_table(struct xlog *log);
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 635f7f8ed9c2..31cbe7deebfa 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1025,19 +1025,25 @@ xlog_check_buf_cancel_table(
 }
 #endif
 
-void
+int
 xlog_alloc_buf_cancel_table(
 	struct xlog	*log)
 {
+	void		*p;
 	int		i;
 
 	ASSERT(log->l_buf_cancel_table == NULL);
 
-	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
-						 sizeof(struct list_head),
-						 0);
+	p = kmalloc_array(XLOG_BC_TABLE_SIZE, sizeof(struct list_head),
+			  GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	log->l_buf_cancel_table = p;
 	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
 		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+
+	return 0;
 }
 
 void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 18d8eebc2d44..aeb01d4c0423 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3256,7 +3256,9 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	xlog_alloc_buf_cancel_table(log);
+	error = xlog_alloc_buf_cancel_table(log);
+	if (error)
+		return error;
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1, NULL);
-- 
2.43.0.rc0.421.g78406f8d94-goog

