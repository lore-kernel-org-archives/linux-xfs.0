Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11204C4167D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjKNBxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjKNBxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:51 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609EAD44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:48 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc938f9612so32893355ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926827; x=1700531627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDncr2wGrgIrYIjQGRYyMav7Qe7qKyxnFaGr6mJ2zak=;
        b=LpOw8dxjfT/evHdYLyA3LHax2BwFvkSYFgnIBGG4vzFLEhB7lUNLoh463cfcYH+rcR
         B0YLdD4b0P5MSybMRFSXaxSqnxB20XlRRzFsUl4V9Ep0KBQBm498eJ2cjDtxxg2OoGxf
         NkFocJRsIuIF+ycG7xiblgSxTARsQ+U+MO/upIXNJBV7B81N9OT+3qIqpXoSUGU0thmJ
         ejdhqNqN1p5jkBl8ZX4z/QQGFeQSX1UhQGjYYnyXQibXEbRdSaLU4Aykp2grjaa5EjsN
         4N5zMBc33AoogQxX9QT6cc5WlvRqebiwCsbYpAQEz7SRVxnGNF4RiUcQFYhLh9EFyDrw
         tC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926827; x=1700531627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDncr2wGrgIrYIjQGRYyMav7Qe7qKyxnFaGr6mJ2zak=;
        b=xAoOR8M3DDNhDxNrzQhE4wsuIA7fBhuRLbDopgQ159lFtliCWZRtpjQ8kZ7Rvv1XeR
         iL8RHZznWyNS9OUiVHYagPbuSLIVHpyJvfZy9h4DTQXgzY+AkQr5W5NMnUUCi0tq7HxZ
         WLkBIwbRVBL1/xfXnxTRxRarcqGiOKogr58rzHTl8hoOf9uTxjsE5Sw9Qm+Og9NWrFf1
         BGtnP4YTJoWpUBYQBMRy4lqNuSdcn+NIz2CqYqW9mwdCOIgVOrRip11RAlIzTcGRvXWw
         YOU53wvJEf1+eZ3NbrLhTZ4rSvboZrKPoTzTZZ5eC/Lx9QtdmYi+9CK2BqMOeujT4E5n
         V+lQ==
X-Gm-Message-State: AOJu0Yz4HOWArC1MZXEY78o9cxzg6OWrvtbW5NzIC3+uf3+uVIAgK6JT
        i1K22/eSukshMbjhh0l3+ChfLuGudY6bFg==
X-Google-Smtp-Source: AGHT+IFQUVqxjijzphjsceUpqIWlYXQ8ukMEZgR50GP7YHHdUqEZcdJjBKQQq0M+BTx08DT1GJHeYw==
X-Received: by 2002:a17:903:2a84:b0:1cc:6fa6:ab62 with SMTP id lv4-20020a1709032a8400b001cc6fa6ab62mr1125194plb.29.1699926827592;
        Mon, 13 Nov 2023 17:53:47 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:47 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 01/17] xfs: refactor buffer cancellation table allocation
Date:   Mon, 13 Nov 2023 17:53:22 -0800
Message-ID: <20231114015339.3922119-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
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

