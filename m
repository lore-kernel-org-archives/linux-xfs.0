Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D3CC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbiEVP2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiEVP2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D238BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3936860FFF
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE60C385AA;
        Sun, 22 May 2022 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233278;
        bh=1IY3iq2yJ/CWYavcRq1PkvAiI2IrauStcASYqU3rCYo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DQkbSrTcVUzhzQDy2prEHmIYQiMCzfEXkhZQMHP2Pi6SxmJZWQI89FiDaUegsTpNL
         zsz0VSi95sTgxSvmzgS6lE7nWFjTBlvs64Hj1cAgTfJMga1VoL7MwSljBJz57Xf/LD
         CFbVuwDMjl/EqhyZ+WN2oAK3m7W13deBLbJ+3TAYUHTGGEefzg6EuSa+Ol8iEs9ogY
         Gifkea0mE8OkJQE9L9tsp29oep/Bw4NY/i5jLpTdKKcPhw0fjAdD5rYCHCXquc5zTb
         YcfqTGe2JnxmzLsADIO/mq/TwQczirTwwyOrp+34nClzyQSMgttaJ1OKvETZbb8/9U
         x0moz4N9fH7sQ==
Subject: [PATCH 2/4] xfs: do not use logged xattr updates on V4 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:27:58 -0700
Message-ID: <165323327816.78754.11662775390499512627.stgit@magnolia>
In-Reply-To: <165323326679.78754.13346434666230687214.stgit@magnolia>
References: <165323326679.78754.13346434666230687214.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

V4 superblocks do not contain the log_incompat feature bit, which means
that we cannot protect xattr log items against kernels that are too old
to know how to recover them.  Turn off the log items for such
filesystems and adjust the "delayed" name to reflect what it's really
controlling.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    6 +++---
 fs/xfs/libxfs/xfs_attr.h |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 79615727f8c2..9f14aca29ec4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -982,7 +982,7 @@ xfs_attr_set(
 	int			error, local;
 	int			rmt_blks = 0;
 	unsigned int		total;
-	int			delayed = xfs_has_larp(mp);
+	bool			use_logging = xfs_has_larp(mp);
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
@@ -1027,7 +1027,7 @@ xfs_attr_set(
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
-	if (delayed) {
+	if (use_logging) {
 		error = xfs_attr_use_log_assist(mp);
 		if (error)
 			return error;
@@ -1101,7 +1101,7 @@ xfs_attr_set(
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 drop_incompat:
-	if (delayed)
+	if (use_logging)
 		xlog_drop_incompat_feat(mp->m_log);
 	return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b88b6d74e4fc..3cd9cbb68b0f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -31,7 +31,8 @@ struct xfs_attr_list_context;
 static inline bool xfs_has_larp(struct xfs_mount *mp)
 {
 #ifdef DEBUG
-	return xfs_globals.larp;
+	/* Logged xattrs require a V5 super for log_incompat */
+	return xfs_has_crc(mp) && xfs_globals.larp;
 #else
 	return false;
 #endif

