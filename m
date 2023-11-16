Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C973FC5ACB3
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344470AbjKPC2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344474AbjKPC2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7995A199;
        Wed, 15 Nov 2023 18:28:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1cc4f777ab9so3374795ad.0;
        Wed, 15 Nov 2023 18:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101721; x=1700706521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJcMNFYl8mDa5rJZBSlFzRqGzQp2hmbD2/RaSE+W3S0=;
        b=hAM43yiuBZbfrUhVvPlJrUEbLFxlfqv6ZrGQMjddDlahw+j89vRzs7xwIfYIqvByWy
         ecsuT9ug+EB4tQbtqXeWPM3Q7RW+bRSIESaNO2rAA1eoz43zIRQcWMPVubseVaxAqvIl
         liI6+iuOCxfYAwCwdlqs5N8sIEuX54axhGdOUBNB5GA/MuKkJrxAOlYR/NUkrk5w6ce+
         EDVPyN4Befc1m4YAJOSfNbJIMmFbrBdTHttRPtWgzoVbEQGqJAC97yPXdbobD51o0V9z
         m9s+We+B3K6HN95ZvShcWzbkaeIt6roRTC8c2VAl1Che/slfcft9vnbMdLOa+/MMvP4z
         AMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101721; x=1700706521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJcMNFYl8mDa5rJZBSlFzRqGzQp2hmbD2/RaSE+W3S0=;
        b=wgbh0VGNFe0zLJEvc2xzsTjIYUwFJeO07SkZGnRymDVf6Zao3h5objnLZ/xPI2+KiA
         XHzLAFc75rfMKQe5tokzmxlUMMuqKFqENG5gcEYsA9z/JY2cRUa7oy2vcG/O2qdD7pWw
         QjGP/dXIzGjO1/zEmVlS+AJxFCD2Qy68VVrcY+NWTnZc7je33avHioJVAlSyJw1JoQFs
         IxkSqsvdIiCh5oNnfvHpRLCzsQAnbmtLs380XBQ4Dw9TZ1dko+jaKW7jHmjt9kDSFC7N
         qU0T2pGGLiiDcPySQM71K5/fXFefSVTngCQP1eU0fb9MBqaErl/ZttqRnNwI0Iqfqija
         l6rg==
X-Gm-Message-State: AOJu0YxG+OShvrbcCE3VzYczajJtYQgkeuxpfqVhxWwY1l2BYdX0z35H
        TM2GG9AXLXqcjM0jXhTvOWOVcgStTMi/zg==
X-Google-Smtp-Source: AGHT+IG1RuMRU4+EdVB+nOArBA7fbsQbmVYj/IIUFwy3o24g+9Y9DotbNCQZ8ysvIEfkmoIPJVtwfQ==
X-Received: by 2002:a17:902:d4c9:b0:1cc:4598:6f46 with SMTP id o9-20020a170902d4c900b001cc45986f46mr8151882plg.57.1700101720696;
        Wed, 15 Nov 2023 18:28:40 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:40 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 03/17] xfs: convert buf_cancel_table allocation to kmalloc_array
Date:   Wed, 15 Nov 2023 18:28:19 -0800
Message-ID: <20231116022833.121551-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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

