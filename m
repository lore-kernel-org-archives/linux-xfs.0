Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD179C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiEXFgE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiEXFgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD4F1157
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C89F6147C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AA3C385AA;
        Tue, 24 May 2022 05:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370562;
        bh=baZX5gH5uQYlPvEidEhb9tmoUPNvKZDr+cA8eMAtS6k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nkByuhngct0FA6efKTSgeJR8u36ZiNghqPZrBKtewmbd5gZP+94qhheONcfi75i5N
         QK77ixmdoqP9vITdbw6btdjfOPgQhl27VvncRWSqQ6tC/T7459JjfjsNE2m1tJ2MWt
         Rh6P4yZu9kSnIwmkMmnVz647J68UDjOvzUS9LcdW9RwpLmHgNLlU2NuXiprApeTez7
         EIT9GCmg8Alhl2sFI9W6EkSVmgx1sqTsEP9UPEMJCTZy7lWX5828j28U3GRThDpQqu
         bP5wVQcFuVP1TKN0YaqyiLleq/A3ZPJTlUzVN6O3kSqOoMQqeaLfUgMbxGdwbq1Ip4
         mXXlUfVQk/Yvg==
Subject: [PATCH 3/3] xfs: convert buf_cancel_table allocation to kmalloc_array
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 23 May 2022 22:36:01 -0700
Message-ID: <165337056157.992964.12304312171548323321.stgit@magnolia>
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

While we're messing around with how recovery allocates and frees the
buffer cancellation table, convert the allocation to use kmalloc_array
instead of the old kmem_alloc APIs, and make it handle a null return,
even though that's not likely.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 +-
 fs/xfs/xfs_buf_item_recover.c   |   14 ++++++++++----
 fs/xfs/xfs_log_recover.c        |    4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index cc36ef9f5df5..2420865f3007 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -122,7 +122,7 @@ int xlog_recover_iget(struct xfs_mount *mp, xfs_ino_t ino,
 		struct xfs_inode **ipp);
 void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
 		uint64_t intent_id);
-void xlog_alloc_buf_cancel_table(struct xlog *log);
+int xlog_alloc_buf_cancel_table(struct xlog *log);
 void xlog_free_buf_cancel_table(struct xlog *log);
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index f983af4de0a5..ffa94102094d 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1015,19 +1015,25 @@ xlog_check_buf_cancel_table(
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
index 9cf59ae98b86..5f7e4e6e33ce 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3231,7 +3231,9 @@ xlog_do_log_recovery(
 	 * First do a pass to find all of the cancelled buf log items.
 	 * Store them in the buf_cancel_table for use in the second pass.
 	 */
-	xlog_alloc_buf_cancel_table(log);
+	error = xlog_alloc_buf_cancel_table(log);
+	if (error)
+		return error;
 
 	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
 				      XLOG_RECOVER_PASS1, NULL);

