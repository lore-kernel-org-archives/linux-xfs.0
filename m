Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A21C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiLaBId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiLaBIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:08:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC87D1573A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71AF661D38
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22A2C433D2;
        Sat, 31 Dec 2022 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448910;
        bh=JeRumTp+7rYI+pzaW+cwzkfzv1rijkpzNulh2GedVaQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DkpFKejXGA9h2d0AoDsfOB8I7MtW5ON7BL0/0YwrwfsY/Y+6c2egklwYzLctBjC+d
         EPt+nmLZdn0yaMilXeLdY2w215E6k2HOBhGaHIkOaUDAnB8NBGDzhkQQkU9JQDdJz3
         5HCa3He48t/HWBuGFWycDdvhB4lNVYPKyp+wYMlr6DJkmvHDJpq9D2nTmNWROQ4uCO
         YFaR9r33XSWRKEizMUSq8El5tuDD4rbewnaGfe+MRZVjCcg0XIjBqioRQbkB0KXZC0
         ty/hw2iLOyep1omNkYsUeyuYV/DtllsdfT8J48Qe/Hy70HutT043g0AlNKIWNUodQB
         tLPA/Qefd3l4Q==
Subject: [PATCH 13/20] xfs: hoist xfs_{bump,drop}link to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:20 -0800
Message-ID: <167243864015.707335.15427130046025701783.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move xfs_bumplink and xfs_droplink to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.c             |   35 -----------------------------------
 fs/xfs/xfs_inode.h             |    1 -
 4 files changed, 37 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 0c3ac4b07cc5..e32b3152c3df 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -610,3 +610,38 @@ xfs_iunlink_remove(
 
 	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
 }
+
+/*
+ * Decrement the link count on an inode & log the change.  If this causes the
+ * link count to go to zero, move the inode to AGI unlinked list so that it can
+ * be freed when the last active reference goes away via xfs_inactive().
+ */
+int
+xfs_droplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	drop_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	if (VFS_I(ip)->i_nlink)
+		return 0;
+
+	return xfs_iunlink(tp, ip);
+}
+
+/*
+ * Increment the link count on an inode & log the change.
+ */
+void
+xfs_bumplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	inc_nlink(VFS_I(ip));
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index e15cf94e0943..f92b14a6fbe8 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -59,6 +59,8 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* The libxfs client must provide this group of helper functions. */
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f69423504216..f9599aa49ab4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -657,41 +657,6 @@ xfs_icreate_args_rootfile(
 		      XFS_ICREATE_ARGS_FORCE_MODE;
 }
 
-/*
- * Decrement the link count on an inode & log the change.  If this causes the
- * link count to go to zero, move the inode to AGI unlinked list so that it can
- * be freed when the last active reference goes away via xfs_inactive().
- */
-static int			/* error */
-xfs_droplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	drop_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	if (VFS_I(ip)->i_nlink)
-		return 0;
-
-	return xfs_iunlink(tp, ip);
-}
-
-/*
- * Increment the link count on an inode & log the change.
- */
-void
-xfs_bumplink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
-
-	inc_nlink(VFS_I(ip));
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-}
-
 #ifdef CONFIG_XFS_LIVE_HOOKS
 /*
  * Use a static key here to reduce the overhead of link count live updates.  If
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d07763312a27..571f61930b7b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -580,7 +580,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
-void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);

