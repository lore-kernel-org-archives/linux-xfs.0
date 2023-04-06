Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2CEC76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbjDFTYM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbjDFTYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670C45FC8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:24:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFEA364ADB
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488B4C433D2;
        Thu,  6 Apr 2023 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809043;
        bh=y7WfQFKU6euGxcs7roL6+8xY5Sx2LfFrUGrxl3mNBOo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LpO3DkfopyugBNxr0yKhM9mGlt4R4C6ulKs3ysJLxnWlL8ESAsResHQ5fgxW19GmR
         9kKKVmmVMyga+SwuTRRGBjPZc3reGJevFQ3Dx5Ps3gHygyQQMNwo05HcRsHvuOBPs8
         zK/1dRJi1/h2i+rtREycECbqIEdO1We+6cvZJRlxKgFgB3nWFodSXQc1c8sGq8obQr
         Fm1TPfKub6yP3GHys4S7jR0P9lmcZ6khpvBJkknyON7QbBBv21RmJJu5eUBfWZqcU5
         qCscnDUZoruTrnC73UqDpnFlDK9YAHzjgfRklPUO5ql6tgOI2XNsz1bz9rFiF6iayc
         3zs/h/8hSW22Q==
Date:   Thu, 06 Apr 2023 12:24:02 -0700
Subject: [PATCH 14/23] xfs: Add parent pointers to xfs_cross_rename
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824857.615225.16689885720224277405.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Cross renames are handled separately from standard renames, and
need different handling to update the parent attributes correctly.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5ad934358791..6d364a48e3cc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2743,19 +2743,22 @@ xfs_finish_rename(
  */
 STATIC int
 xfs_cross_rename(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*dp1,
-	struct xfs_name		*name1,
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*dp2,
-	struct xfs_name		*name2,
-	struct xfs_inode	*ip2,
-	int			spaceres)
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp1,
+	struct xfs_name			*name1,
+	struct xfs_inode		*ip1,
+	struct xfs_parent_defer		*ip1_pptr,
+	struct xfs_inode		*dp2,
+	struct xfs_name			*name2,
+	struct xfs_inode		*ip2,
+	struct xfs_parent_defer		*ip2_pptr,
+	int				spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
+	struct xfs_mount		*mp = dp1->i_mount;
+	int				error = 0;
+	int				ip1_flags = 0;
+	int				ip2_flags = 0;
+	int				dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
 	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
@@ -2824,6 +2827,18 @@ xfs_cross_rename(
 		}
 	}
 
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_replace(tp, ip1_pptr, dp1, name1, dp2,
+				name2, ip1);
+		if (error)
+			goto out_trans_abort;
+
+		error = xfs_parent_replace(tp, ip2_pptr, dp2, name2, dp1,
+				name1, ip2);
+		if (error)
+			goto out_trans_abort;
+	}
+
 	if (ip1_flags) {
 		xfs_trans_ichgtime(tp, ip1, ip1_flags);
 		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
@@ -2838,6 +2853,7 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3052,8 +3068,8 @@ xfs_rename(
 	/* RENAME_EXCHANGE is unique from here on. */
 	if (flags & RENAME_EXCHANGE) {
 		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
-					target_dp, target_name, target_ip,
-					spaceres);
+				src_ip_pptr, target_dp, target_name, target_ip,
+				tgt_ip_pptr, spaceres);
 		goto out_unlock;
 	}
 

