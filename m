Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBCDC727A9
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244057AbjHXXWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244080AbjHXXV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07401FC1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4727464B19
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B52C433C7;
        Thu, 24 Aug 2023 23:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919312;
        bh=QNP2RUiEFYKkkNqAxOBo5/xT5UQyi5LPXchJafajL3Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QrXxKPU140h7R3WRpNlwF/m/1nlmn3rmhns1Ofq3EVJ/3Viw9LvoOYCQuBT4Kwds6
         MkJyfkWW/buDMYYCQOrZ8jVpBvsCOKKSLF0xz7OlfLxG+yM3cVglzo++i9eWEsF6KO
         c2Ik1sgzB28RLSSXvgvQ/oxAibXOyDPRaWUINQtiRm7saVoxtbC2LxCn4O7xgIq6eG
         xxo4i6tYpJagIa3KaXN5NMNCdnlOW4lrj2ac/A8ZvDmtjK29kY6I49W2djbZ9ppwRU
         Dyq9elnBPMfFjMIZO2K2ceIBssdBZRY6x3zsAn3fIES0aPJvoSTTQs5ELpc2+yX8Le
         xovLpQ+6VpqbQ==
Subject: [PATCH 3/3] xfs: log is not writable if we have unknown rocompat
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:52 -0700
Message-ID: <169291931221.220104.3437825303883889120.stgit@frogsfrogsfrogs>
In-Reply-To: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ever since commit 9e037cb7972f, the superblock write verifier will trip
if someone tries to write a superblock with unknown rocompat features.
However, we allow ro mounts of a filesystem with unknown rocompat
features if the log is clean, except that has been broken for years
because the end of an ro mount cleans the log, which logs and writes the
superblock.

Therefore, don't allow log writes to happen if there are unknown
rocompat features set.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         |    6 ++++++
 fs/xfs/xfs_log_priv.h    |    7 +++++++
 fs/xfs/xfs_log_recover.c |    7 +++++++
 3 files changed, 20 insertions(+)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..c1bbc8040bcb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -391,6 +391,8 @@ xfs_log_writable(
 		return false;
 	if (xlog_is_shutdown(mp->m_log))
 		return false;
+	if (xlog_is_readonly(mp->m_log))
+		return false;
 	return true;
 }
 
@@ -408,6 +410,8 @@ xfs_log_regrant(
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
+	if (xlog_is_readonly(log))
+		return -EROFS;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
 
@@ -471,6 +475,8 @@ xfs_log_reserve(
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
+	if (xlog_is_readonly(log))
+		return -EROFS;
 
 	XFS_STATS_INC(mp, xs_try_logspace);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index af87648331d5..14892e01de38 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -461,6 +461,7 @@ struct xlog {
 #define XLOG_IO_ERROR		2	/* log hit an I/O error, and being
 				   shutdown */
 #define XLOG_TAIL_WARN		3	/* log tail verify warning issued */
+#define XLOG_READONLY		4	/* cannot write to the log */
 
 static inline bool
 xlog_recovery_needed(struct xlog *log)
@@ -480,6 +481,12 @@ xlog_is_shutdown(struct xlog *log)
 	return test_bit(XLOG_IO_ERROR, &log->l_opstate);
 }
 
+static inline bool
+xlog_is_readonly(struct xlog *log)
+{
+	return test_bit(XLOG_READONLY, &log->l_opstate);
+}
+
 /*
  * Wait until the xlog_force_shutdown() has marked the log as shut down
  * so xlog_is_shutdown() will always return true.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b4458b7fd6f7..f8f13d5f79cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3450,6 +3450,13 @@ xlog_recover(
 
 		error = xlog_do_recover(log, head_blk, tail_blk);
 		set_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
+	} else if (unknown_rocompat) {
+		/*
+		 * Log recovery wasn't needed, but if the superblock has
+		 * unknown rocompat features, don't allow log writes at all
+		 * because the sb write verifier will trip.
+		 */
+		set_bit(XLOG_READONLY, &log->l_opstate);
 	}
 	return error;
 }

