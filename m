Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02937C2BB3F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbjKPC2n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbjKPC2m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:42 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69512199;
        Wed, 15 Nov 2023 18:28:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cc1e1e74beso3119825ad.1;
        Wed, 15 Nov 2023 18:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101719; x=1700706519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C4yKQaxzckTaxnMxd75YNEVODiQh7sgtjOmTnctxwas=;
        b=aalIiWaIIl2ivH36Y4Z7IrfhGNU1PRvNFqhVs3Bqa2VnGN2qrGFxKbmCbnr1Z2jPbY
         YjevOcogbUysqnT+bF9exmDKM1wuCIzI7AxHXvKgb7oiH2s/r1HQVYhrhdYjoi7zEBjI
         tTErWC5KigW3F4NWD0aWm94uKSoeNxIRuwWv62nj6660Rs7yvGM9QhDqu9eLniuQ2k3I
         P7AmYGN1ur6gXxnNw+TUraXGl+AM8Wdpt0rHmfkxtJof7F0h+H8Vy7k8eYkvloAej4nt
         RFL0ZRqo9COGhs1lSLz29Yc/gCjpUUYnD1ubn8sSbkJ4kYe+uoVbDuVSihwXXDRLU5Yu
         4Kvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101719; x=1700706519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C4yKQaxzckTaxnMxd75YNEVODiQh7sgtjOmTnctxwas=;
        b=QQeeUumeVdUvBuPhPGYWXVQ6UseqvOMjWdvsBSxkkdBKRoqUDKCK7UDN9H8Ao96D92
         s3i9d2wl9lyhrquzgeSI9FBFIChqHMnF327zSI2OTwQ6588SlAaKVKLS2IBA+sVve4WF
         q4Fc3aY1zzxCFVvwGRc5nas4YqNmhOcCEgSb04152yIw7guxLwensVqQl9wxQgwSS0E8
         9NV2zMRnjPucPVAGcCcKm0rg7RDCtBrhS+LP8Ctz+E2VLdVfEEJc79VE77yX/BXnYe++
         0qh53WZIpp3w6gCuaP+XAHqXv10m24r8ybhrTmGKLHOJ/XAEzLRrratB2YZiNtbKz1+M
         OwWA==
X-Gm-Message-State: AOJu0Yx3GyMoSYJo7mGHdqnkxIGhYQKjv77d91whDLBlcoTrux0Rm+/k
        apVs2F+T4ntD8MHPbGzZhB/sT3lujlZ/Fg==
X-Google-Smtp-Source: AGHT+IGps7H5ClZuqeYYx/u6pPB12tco8SEl7+shzTf3veE07P8oB5t3RiFUE3t3KK9YhciaPsCO9A==
X-Received: by 2002:a17:902:ea07:b0:1cc:4ae8:dadc with SMTP id s7-20020a170902ea0700b001cc4ae8dadcmr7385423plg.64.1700101718608;
        Wed, 15 Nov 2023 18:28:38 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:38 -0800 (PST)
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
Subject: [PATCH 5.15 01/17] xfs: refactor buffer cancellation table allocation
Date:   Wed, 15 Nov 2023 18:28:17 -0800
Message-ID: <20231116022833.121551-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2723234923b3294dbcf6019c288c87465e927ed4 ]

Move the code that allocates and frees the buffer cancellation tables
used by log recovery into the file that actually uses the tables.  This
is a precursor to some cleanups and a memory leak fix.

( backport: dependency of 8db074bd84df5ccc88bff3f8f900f66f4b8349fa )

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h | 14 +++++-----
 fs/xfs/xfs_buf_item_recover.c   | 47 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h           |  3 ---
 fs/xfs/xfs_log_recover.c        | 32 +++++++---------------
 4 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ff69a0000817..b8b65a6e9b1e 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -108,12 +108,6 @@ struct xlog_recover {
 
 #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].i_addr)
 
-/*
- * This is the number of entries in the l_buf_cancel_table used during
- * recovery.
- */
-#define	XLOG_BC_TABLE_SIZE	64
-
 #define	XLOG_RECOVER_CRCPASS	0
 #define	XLOG_RECOVER_PASS1	1
 #define	XLOG_RECOVER_PASS2	2
@@ -126,5 +120,13 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+void xlog_alloc_buf_cancel_table(struct xlog *log);
+void xlog_free_buf_cancel_table(struct xlog *log);
+
+#ifdef DEBUG
+void xlog_check_buf_cancel_table(struct xlog *log);
+#else
+#define xlog_check_buf_cancel_table(log) do { } while (0)
+#endif
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e04e44ef14c6..dc099b2f4984 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -23,6 +23,15 @@
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
 
+/*
+ * This is the number of entries in the l_buf_cancel_table used during
+ * recovery.
+ */
+#define	XLOG_BC_TABLE_SIZE	64
+
+#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
+	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
+
 /*
  * This structure is used during recovery to record the buf log items which
  * have been canceled and should not be replayed.
@@ -1003,3 +1012,41 @@ const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
 	.commit_pass2		= xlog_recover_buf_commit_pass2,
 };
+
+#ifdef DEBUG
+void
+xlog_check_buf_cancel_table(
+	struct xlog	*log)
+{
+	int		i;
+
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
+		ASSERT(list_empty(&log->l_buf_cancel_table[i]));
+}
+#endif
+
+void
+xlog_alloc_buf_cancel_table(
+	struct xlog	*log)
+{
+	int		i;
+
+	ASSERT(log->l_buf_cancel_table == NULL);
+
+	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
+						 sizeof(struct list_head),
+						 0);
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
+		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+}
+
+void
+xlog_free_buf_cancel_table(
+	struct xlog	*log)
+{
+	if (!log->l_buf_cancel_table)
+		return;
+
+	kmem_free(log->l_buf_cancel_table);
+	log->l_buf_cancel_table = NULL;
+}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f3d68ca39f45..03393595676f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -454,9 +454,6 @@ struct xlog {
 	struct rw_semaphore	l_incompat_users;
 };
 
-#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
-	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
-
 /*
  * Bits for operational state
  */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 581aeb288b32..18d8eebc2d44 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3248,7 +3248,7 @@ xlog_do_log_recovery(
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
-	int		error, i;
+	int		error;
 
 	ASSERT(head_blk != tail_blk);
 
@@ -3256,37 +3256,23 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	log->l_buf_cancel_table = kmem_zalloc(XLOG_BC_TABLE_SIZE *
-						 sizeof(struct list_head),
-						 0);
-	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
-		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
+	xlog_alloc_buf_cancel_table(log);
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1, NULL);
-	if (error != 0) {
-		kmem_free(log->l_buf_cancel_table);
-		log->l_buf_cancel_table = NULL;
-		return error;
-	}
+	if (error != 0)
+		goto out_cancel;
+
 	/*
 	 * Then do a second pass to actually recover the items in the log.
 	 * When it is complete free the table of buf cancel items.
 	 */
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS2, NULL);
-#ifdef DEBUG
-	if (!error) {
-		int	i;
-
-		for (i = 0; i < XLOG_BC_TABLE_SIZE; i++)
-			ASSERT(list_empty(&log->l_buf_cancel_table[i]));
-	}
-#endif	/* DEBUG */
-
-	kmem_free(log->l_buf_cancel_table);
-	log->l_buf_cancel_table = NULL;
-
+	if (!error)
+		xlog_check_buf_cancel_table(log);
+out_cancel:
+	xlog_free_buf_cancel_table(log);
 	return error;
 }
 
-- 
2.43.0.rc0.421.g78406f8d94-goog

