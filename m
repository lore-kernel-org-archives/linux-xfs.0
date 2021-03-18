Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0806C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C2564F40
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCRWd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhCRWdc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7604964EBD;
        Thu, 18 Mar 2021 22:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106812;
        bh=SJz9zPZV0Ijs5TtVSKiY1WEmEQ+3vG+se/MZKupDgog=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uGc2SwLYaHA1/ewBfGen5EvTXEKCQaxwnh5eTrzGWigdrpN6sOzQN5tbORdu/XOEO
         1EAv7w3mjtf+G2cnsXEMYP2s5eKX9AcXdbCb8NP43nkn4kVIC+tAoj4s5IdKiDRe5k
         NWfpKge2fWSDSJ9m1ypdV57HBVabKxJQAp3QSDUGU9LTuhMPTV0ACZMYsxTsEhyJgT
         mdImiPk8j4ac5jwmwd4ckaozMYEaiTxfFrh0uH3ogbaJ1k6jxQnlVM6gwxI0fXkT3V
         nlM33ytlejvKeCdMGz502MjV38DjkTLmpcrOtSTLM5o3HF9UU09Sm9gbPECdnmYx28
         X7SqCDyE0K2kw==
Subject: [PATCH 1/2] xfs: move the xfs_can_free_eofblocks call under the
 IOLOCK
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:32 -0700
Message-ID: <161610681213.1887542.5172499515393116902.stgit@magnolia>
In-Reply-To: <161610680641.1887542.10509468263256161712.stgit@magnolia>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_inode_free_eofblocks, move the xfs_can_free_eofblocks call
further down in the function to the point where we have taken the
IOLOCK.  This is preparation for the next patch, where we will need that
lock (or equivalent) so that we can check if there are any post-eof
blocks to clean out.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e6a62f765422..7353c9fe05db 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1294,13 +1294,6 @@ xfs_inode_free_eofblocks(
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
 
-	if (!xfs_can_free_eofblocks(ip, false)) {
-		/* inode could be preallocated or append-only */
-		trace_xfs_inode_free_eofblocks_invalid(ip);
-		xfs_inode_clear_eofblocks_tag(ip);
-		return 0;
-	}
-
 	/*
 	 * If the mapping is dirty the operation can block and wait for some
 	 * time. Unless we are waiting, skip it.
@@ -1322,7 +1315,10 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	return xfs_free_eofblocks(ip);
+	if (xfs_can_free_eofblocks(ip, false))
+		return xfs_free_eofblocks(ip);
+
+	return 0;
 }
 
 /*

