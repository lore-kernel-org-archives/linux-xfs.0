Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBCCC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiL3XjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XjR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:39:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E31DF16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:39:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF4061C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9A4C433EF;
        Fri, 30 Dec 2022 23:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443555;
        bh=DcjZaEdhTugqDvL0tJwfH7krbjKq1rAswwKp7WZXjoU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AbTZaVYlc0SzN1DjtJjO/LPvlAXBtgll/1/5qq1QK0hwL0/U7qPYg0U9i5QDXACuP
         srbMpANvSVCt0v6eMB+DYFf0obwWapy3OzWsKZXPn5JZHSDeyAZYrsFLt+8YXN5UFS
         9uKdZ5F8fX7/sx+1VY/BfquajVtq8PnyEiKJjiFaLoHA5Xq5XOnclK+QS5b+GoLJaM
         wsbryxiIr2bG8fZ9bdB3R70N7QRKdl54cZD5QrQyWJ3rwq+GfJbs77439+LI1ZEx+s
         85iGX2f40tCFTYZiklTgTBp120LVKJ+m+7b5GL+ISF66ZUS3jHjwIjEhfl94Jpfdas
         +o+mRycWwiFHA==
Subject: [PATCH 10/11] xfs: report realtime metadata corruption errors to the
 health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:16 -0800
Message-ID: <167243839603.695999.7909067471065743542.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt realtime metadat blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    9 ++++++++-
 fs/xfs/xfs_rtalloc.c         |    6 ++++++
 2 files changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..99a0af8d9028 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -70,13 +71,19 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map))) {
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 		return -EFSCORRUPTED;
+	}
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
 				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, issum ? XFS_SICK_RT_SUMMARY :
+					     XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..790191316a32 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,8 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1373,6 +1375,8 @@ xfs_rtmount_inodes(
 
 	sbp = &mp->m_sb;
 	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
 		return error;
 	ASSERT(mp->m_rbmip != NULL);
@@ -1382,6 +1386,8 @@ xfs_rtmount_inodes(
 		goto out_rele_bitmap;
 
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	if (xfs_metadata_is_sick(error))
+		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);

