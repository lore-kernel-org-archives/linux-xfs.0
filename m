Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B35C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiLaCHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:07:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9767013F97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 409C3B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82BCC433EF;
        Sat, 31 Dec 2022 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452449;
        bh=oGaddjt9rNXM/L+GJHQg7X4/80N7MNEwwi7go3OihOc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RukjPnY1QdQjBzj3JmftckBnSg2Vmp/33/L3PZlKURkxuji94RdBTNNamfg3Ngo4u
         K6i8YAQI4tst1oQIGn8HRsFvZzRSzu5NzYpUklp2opX83BTreJ7O759UxX4fDzASbJ
         6m764tUE69rJLXupv9ooxxG99GapfcQ8j1SxzMImS4W8q3xjVhFThm7qkSvZaeawwC
         3Jz7OTKqkbPNQKyc0hnKfmfAHM5DVQWgASs5w7PcTAf0QK/Xj1azfmOWENc8mqS/pF
         d7brruWubafGvdpltUub1BAN5YYF9sHIQysjnEVM74+9VJ3dMV+azgTHhzxk5fTJmA
         9Efgoj8henQxw==
Subject: [PATCH 17/26] xfs: hoist xfs_{bump,drop}link to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875524.723621.513390509314496204.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
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
 include/xfs_inode.h     |    4 ++++
 libxfs/xfs_inode_util.c |   35 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    2 ++
 3 files changed, 41 insertions(+)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 234f8d3affa..ccd19e5ee5b 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -257,6 +257,10 @@ static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
 }
+static inline void drop_nlink(struct inode *inode)
+{
+	inode->i_nlink--;
+}
 
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 4b19edd9ab1..e12c43954cf 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -608,3 +608,38 @@ xfs_iunlink_remove(
 
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
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index e15cf94e094..f92b14a6fbe 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -59,6 +59,8 @@ void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* The libxfs client must provide this group of helper functions. */
 

