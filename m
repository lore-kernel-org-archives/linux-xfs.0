Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A31DDC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiERSzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241723AbiERSzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A46115F
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB6CB821AA
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13DAC385A9;
        Wed, 18 May 2022 18:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900140;
        bh=QFEB0eBObUKmlG8HcQh1CFDE1sUbpf2EDDyTzD1AQD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LwzHrohbOHLW3HuHtFR+gEptN9o4G6xmvj4Ynm3vLQTKKJ7A2oyot1zRKwShAjiEH
         /tb8w6l6O5XVQisW4Y+z9fYzxjYS+eheDps/jan9lWRxE0k4V1ONY+RF1y2innJ/qv
         jeUENPfEtv4lJNJrYhYN59XOJUlurqLSc0Dar3hiff4FUqBB9qWRMxBSljhK2HbVlZ
         Oc2cBw/imIkTjilUjb7v9Z7HCD+nyrbX8lSVcS21lF8Gs+dwlzawPxz6WWkOAckNVA
         ObU8D+EeFCdYfTMpc8ayCY+v3j3yEJvPN0HPUxwSR9I7cY8HF+GbmI1Ta2LhtPh6rD
         vuvMurtDKqpQw==
Subject: [PATCH 3/3] xfs: convert buf_cancel_table allocation to kmalloc_array
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 18 May 2022 11:55:40 -0700
Message-ID: <165290014021.1646290.13716646283504726941.stgit@magnolia>
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

While we're messing around with how recovery allocates and frees the
buffer cancellation table, convert the allocation to use kmalloc_array
instead of the old kmem_alloc APIs, and make it handle a null return,
even though that's not likely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 +-
 fs/xfs/xfs_buf_item_recover.c   |   14 ++++++++++----
 fs/xfs/xfs_log_recover.c        |    4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index c96102484aa6..8227c74e75ec 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -128,7 +128,7 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-void xlog_alloc_buf_cancel_table(struct xlog *log);
+int xlog_alloc_buf_cancel_table(struct xlog *log);
 void xlog_free_buf_cancel_table(struct xlog *log);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d1e484649a33..4b54b808fb07 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -994,19 +994,25 @@ const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.commit_pass2		= xlog_recover_buf_commit_pass2,
 };
 
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
+			GFP_KERNEL | __GFP_NOWARN);
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
index bb10686ef88a..f77e072426cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3238,7 +3238,9 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	xlog_alloc_buf_cancel_table(log);
+	error = xlog_alloc_buf_cancel_table(log);
+	if (error)
+		return error;
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1, NULL);

