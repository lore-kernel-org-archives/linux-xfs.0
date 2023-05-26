Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D07C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZCTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjEZCTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADD1B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384D76157B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4DAC433D2;
        Fri, 26 May 2023 02:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067555;
        bh=vXfcwgfMvVOzYRoaoy/EBOVGOiCU7iLW01jPw9dxY1E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jdKRU4IY1+7nEj/kns5WkCH1Qzs+vWk3+Ut06rU9A8BKRix+Dceu1RKhPRs5XwxeS
         g5AIdTj6iFbiRm4jm6BGP0V095rWm+YqLFbekxosBjOmIld2gn2iq2tz/uEksrZVDp
         ctHu7E5SGBjwMRrFdBGw4vGffFrlr+5lYRjGobkL03nCo4nJEt40qG+gCEiZUWGh+M
         R790aGYM1HK0fpHr4ajFzAacgPI7lsS7qDK51lUv2R5V9cI5adawdSX/oiE988aUFn
         vg1M7zy5oHCFDmpGsdVWBti0o+4QqZ5B2FPNL4tuBJIMbjHeWmQkFvkxTlb8Oy8J+f
         neV+0y3BO3W+g==
Date:   Thu, 25 May 2023 19:19:15 -0700
Subject: [PATCH 1/1] xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077134.3749047.1825192150739462971.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077122.3749047.6539176730750408418.stgit@frogsfrogsfrogs>
References: <168506077122.3749047.6539176730750408418.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Renames that generate parent pointer updates can join up to 5
inodes locked in sorted order.  So we need to increase the
number of defer ops inodes and relock them in the same way.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
[djwong: have one sorting function]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_defer.c   |    6 +++++-
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a8170732ffe..1d5621fc2ee 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -498,6 +498,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
+#define xfs_lock_inodes(i_tab, nr, mode)		((void) 0)
+#define xfs_sort_inodes(i_tab, nr)			((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 47a7c5ed1f5..ea274ebd8f5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -825,7 +825,11 @@ xfs_defer_ops_continue(
 	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
 
 	/* Lock the captured resources to the new transaction. */
-	if (dfc->dfc_held.dr_inos == 2)
+	if (dfc->dfc_held.dr_inos > 2) {
+		xfs_sort_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos);
+		xfs_lock_inodes(dfc->dfc_held.dr_ip, dfc->dfc_held.dr_inos,
+				XFS_ILOCK_EXCL);
+	} else if (dfc->dfc_held.dr_inos == 2)
 		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
 				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
 	else if (dfc->dfc_held.dr_inos == 1)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bcc48b0c75c..91c9568575d 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -71,7 +71,13 @@ extern const struct xfs_defer_op_type xfs_swapext_defer_type;
 /*
  * Deferred operation item relogging limits.
  */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+
+/*
+ * Rename w/ parent pointers can require up to 5 inodes with deferred ops to
+ * be joined to the transaction: src_dp, target_dp, src_ip, target_ip, and wip.
+ * These inodes are locked in sorted order by their inode numbers
+ */
+#define XFS_DEFER_OPS_NR_INODES	5
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 /* Resources that must be held across a transaction roll. */

