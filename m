Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D28C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiEXFgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbiEXFfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8990C7CDF6
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A0E6B8169C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D068EC34115;
        Tue, 24 May 2022 05:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370550;
        bh=5pf9wKTsTFAg6xiyQnivm6urKLgRWB3YtobKK9rQKZY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aqe81u5eCFNB4cdyLpTqKm8+RfROHphwDDk472G/vvkkiAVtMzBfP2VRAOFBHv79f
         +TRIhra/4rEUYkK1QgIB7xe5b9bay8nIb3PkP2LoAK+coTXXroC5vWBLlMnteN7YEp
         5uSlS1qa6qYc11KOc6HGOOWXY53j3myhqmv3Aqcf1tpbNnPHGzEaGSZ50UVqXT+wsD
         FFRguN6Qrx9NJ7zghW4E7MVv0PP4i8HyKhlsQekaa66kcNw5b+uUmFheAQvF2ytSJ/
         KH6gu48yty0/CGnUtlgiBTMM3zzl4CLjIwZ9h3iQlJX7tElAOoifgxPu2u2orgWWQJ
         HWpp4lIZD80+g==
Subject: [PATCH 1/3] xfs: refactor buffer cancellation table allocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 23 May 2022 22:35:50 -0700
Message-ID: <165337055035.992964.2834251062455867743.stgit@magnolia>
In-Reply-To: <165337054460.992964.11039203493792530929.stgit@magnolia>
References: <165337054460.992964.11039203493792530929.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the code that allocates and frees the buffer cancellation tables
used by log recovery into the file that actually uses the tables.  This
is a precursor to some cleanups and a memory leak fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |   14 +++++++-----
 fs/xfs/xfs_buf_item_recover.c   |   47 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h           |    3 --
 fs/xfs/xfs_log_recover.c        |   32 +++++++--------------------
 4 files changed, 64 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 32e216255cb0..cc36ef9f5df5 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -110,12 +110,6 @@ struct xlog_recover {
 
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
@@ -128,5 +122,13 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
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
index e484251dc9c8..d2e2dff01b99 100644
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
@@ -993,3 +1002,41 @@ const struct xlog_recover_item_ops xlog_buf_item_ops = {
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
index 67fd9789e69a..686c01eb3661 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -428,9 +428,6 @@ struct xlog {
 	struct rw_semaphore	l_incompat_users;
 };
 
-#define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
-	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
-
 /*
  * Bits for operational state
  */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b1980d7cbbee..9cf59ae98b86 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3223,7 +3223,7 @@ xlog_do_log_recovery(
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
-	int		error, i;
+	int		error;
 
 	ASSERT(head_blk != tail_blk);
 
@@ -3231,37 +3231,23 @@ xlog_do_log_recovery(
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
 

