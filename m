Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12BFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbiERSzb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiERSzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93711230204
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1759A6189A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D96C385A9;
        Wed, 18 May 2022 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900129;
        bh=DiAm0aQKWTtPZpcp3YGY9mHthn0KUgaabg9l69W1JJY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ihbFC70Rk5iboIYgmNUAkWZ9QG3n8ijI/GFqnBA7vcKhKMF2kpWUa5tVWzRSGthVI
         E10MNEYJO47vu7hKmwtL/Gl27AFmYMt/CitRtu19yQCRPairuW4UBu2FbR8dvfHZz5
         DJZ5Pgds1GQ54HS3Ogl/xByWYhNoq5f5EgarbC9mP2P0yRO0dka3B0+2VWHmmkxmfl
         8bZOLFVKq9cI/iYbCxUZCZjU/JerO0nGXlGxXJhYKH5saoEEac5d+dV31vt9PKaEQA
         bwdPBoPzNNKN+9iQVSk/sstbp8eZPoFbjY+RDJ1I5C8mROFgi9q+B5S04Phifv6uaG
         3rW9neXUBJeWg==
Subject: [PATCH 1/3] xfs: refactor buffer cancellation table allocation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 18 May 2022 11:55:29 -0700
Message-ID: <165290012900.1646290.13406779783177992762.stgit@magnolia>
In-Reply-To: <165290012335.1646290.10769144718908005637.stgit@magnolia>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
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
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_buf_item_recover.c   |   26 ++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   21 +++++++--------------
 3 files changed, 35 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 32e216255cb0..c96102484aa6 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -128,5 +128,7 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
+void xlog_alloc_buf_cancel_table(struct xlog *log);
+void xlog_free_buf_cancel_table(struct xlog *log);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index e484251dc9c8..8624ac22ca4a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -993,3 +993,29 @@ const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
 	.commit_pass2		= xlog_recover_buf_commit_pass2,
 };
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
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97b941c07957..bb10686ef88a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3230,7 +3230,7 @@ xlog_do_log_recovery(
 	xfs_daddr_t	head_blk,
 	xfs_daddr_t	tail_blk)
 {
-	int		error, i;
+	int		error;
 
 	ASSERT(head_blk != tail_blk);
 
@@ -3238,19 +3238,13 @@ xlog_do_log_recovery(
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
@@ -3266,9 +3260,8 @@ xlog_do_log_recovery(
 	}
 #endif	/* DEBUG */
 
-	kmem_free(log->l_buf_cancel_table);
-	log->l_buf_cancel_table = NULL;
-
+out_cancel:
+	xlog_free_buf_cancel_table(log);
 	return error;
 }
 

