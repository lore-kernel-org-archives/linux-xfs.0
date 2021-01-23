Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F4BC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA0422D57
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbhAWSxm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbhAWSxd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E19224DE;
        Sat, 23 Jan 2021 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427998;
        bh=NO+acRY+wd7em++6fsSTHt27mum69gxSZpLrxsxP1/w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qGyVkkVN83yOs5XsZ/I2bOIXPT3C3e48KCPA3qbCitIV061pTlYN/+zWRMIgBWpLS
         oSw47+h4kbVSXwHV0Par7LRSYitppqOISzkYyJQSPiGkzxQqo5WMIH9niCvDpWmoP7
         Sd4ZbRPI3+dZXX6uTFjHE3hHdrwlNyPnF/szCXnJoTCCb8Lydp7wCMtbDClvS4fJt+
         OSnGztlDIF9D2QFkGPTVJAix7DdwmoEzEkOhxW9Gq2QJUAp4cg4MM1BZUZMbqJuhwd
         UZ5TjfnmMvsgJFCzXE+1T9AGI3w1cGxe2R/vfPFX5e3lvV1q90ymOOUj1bk4yHOcMp
         UAEnwaC3fUzPg==
Subject: [PATCH 3/3] xfs: set WQ_SYSFS on all workqueues
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:19 -0800
Message-ID: <161142799960.2173328.12558377173737512680.stgit@magnolia>
In-Reply-To: <161142798284.2173328.11591192629841647898.stgit@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Set WQ_SYSFS on all workqueues that we create so that we have a means to
monitor cpu affinity and whatnot for background workers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c       |    4 ++--
 fs/xfs/xfs_mru_cache.c |    2 +-
 fs/xfs/xfs_super.c     |   23 ++++++++++++++---------
 3 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 58699881c100..edb16843dff7 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1493,8 +1493,8 @@ xlog_alloc_log(
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
-			mp->m_super->s_id);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI,
+			0, mp->m_super->s_id);
 	if (!log->l_ioend_workqueue)
 		goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index a06661dac5be..b6dab34e361d 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -294,7 +294,7 @@ int
 xfs_mru_cache_init(void)
 {
 	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
-				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
+				WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 1);
 	if (!xfs_mru_reap_wq)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aed74a3fc787..ebe3eba2cbbc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -495,33 +495,37 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 1,
+			mp->m_super->s_id);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
-			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
 			0, mp->m_super->s_id);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
+			mp->m_super->s_id);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_reclaim;
 
-	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
-					       mp->m_super->s_id);
+	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
+			WQ_SYSFS | WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
@@ -2085,11 +2089,12 @@ xfs_init_workqueues(void)
 	 * max_active value for this workqueue.
 	 */
 	xfs_alloc_wq = alloc_workqueue("xfsalloc",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0);
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
 
-	xfs_discard_wq = alloc_workqueue("xfsdiscard", WQ_UNBOUND, 0);
+	xfs_discard_wq = alloc_workqueue("xfsdiscard",
+			WQ_SYSFS | WQ_UNBOUND, 0);
 	if (!xfs_discard_wq)
 		goto out_free_alloc_wq;
 

