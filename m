Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182BBC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348020AbiEVP2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVP2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820C38BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71A6861003
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9376C385AA;
        Sun, 22 May 2022 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233316;
        bh=XwTnGubnt0R5zVUL6PRh2F5vZsqf5+ytVIsHUXwTxZU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eO4Q0Ir3dSvIqUw6K3wKzH/EDWL8RWLCKTT2NZJlfFXnfYcAFjigShDed9zXZvSsy
         3bu067ACNt86znL5X1aYETiKkqBpOmsPQZYNGE4kk9N8Dy0ep45xaPV8Vg8T9qntKJ
         retjK5oWC3iY1N83yKzlLlVoS5VvSk1n/zKGNrfPnndP85bXFcEVLtCUD85uMSbYs7
         7Za5w/NtADFv54n4X2lP/MxtrOxJeUEDuOcY08TjjFTydayMstDMRhVlYdMvRoOLeV
         UXSj3kRsx5Li2d1id/9uaQ1Qsv3IoHFDhvVsqAEj7dI4MsvZb6WwIDM+LLZXc7XNI/
         NnsMZuFnar2NA==
Subject: [PATCH 4/5] xfs: tell xfs_attr_set if the log is actually letting us
 use LARP mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:36 -0700
Message-ID: <165323331637.78886.17152680198202410050.stgit@magnolia>
In-Reply-To: <165323329374.78886.11371349029777433302.stgit@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a means for xfs_attr_use_log_assist to tell its caller if we have a
lock on using LARP mode.  This will be used in the next patch it will be
useful to turn it on for a batch update.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 ++++----
 fs/xfs/xfs_log.c         |   10 +++++++---
 fs/xfs/xfs_log.h         |    2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9f14aca29ec4..1de3db88e006 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -982,7 +982,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
-	bool			use_logging = xfs_has_larp(mp);
+	bool			need_rele = false;
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -1027,8 +1027,8 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
-	if (use_logging) {
-		error = xfs_attr_use_log_assist(mp);
+	if (xfs_has_larp(mp)) {
+		error = xfs_attr_use_log_assist(mp, &need_rele);
 		if (error)
 			return error;
 	}
@@ -1101,7 +1101,7 @@ xfs_attr_set(
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 drop_incompat:
-	if (use_logging)
+	if (need_rele)
 		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index edd077e055d5..bd41e0dc95ff 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3879,15 +3879,17 @@ xlog_drop_incompat_feat(
 }
 
 /*
- * Get permission to use log-assisted atomic exchange of file extents.
+ * Get permission to use log-assisted extended attribute updates.
  *
  * Callers must not be running any transactions or hold any inode locks, and
  * they must release the permission by calling xlog_drop_incompat_feat
- * when they're done.
+ * when they're done.  The @need_rele parameter will be set to true if the
+ * caller should drop permission after the call.
  */
 int
 xfs_attr_use_log_assist(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			*need_rele)
 {
 	int			error = 0;
 
@@ -3896,6 +3898,7 @@ xfs_attr_use_log_assist(
 	 * incompat feature bit.
 	 */
 	xlog_use_incompat_feat(mp->m_log);
+	*need_rele = true;
 
 	/*
 	 * If log-assisted xattrs are already enabled, the caller can use the
@@ -3916,5 +3919,6 @@ xfs_attr_use_log_assist(
 	return 0;
 drop_incompat:
 	xlog_drop_incompat_feat(mp->m_log);
+	*need_rele = false;
 	return error;
 }
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index f3ce046a7d45..166d2310af0b 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -160,6 +160,6 @@ bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
-int xfs_attr_use_log_assist(struct xfs_mount *mp);
+int xfs_attr_use_log_assist(struct xfs_mount *mp, bool *need_rele);
 
 #endif	/* __XFS_LOG_H__ */

