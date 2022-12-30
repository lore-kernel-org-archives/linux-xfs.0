Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BCCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiLaCIt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:08:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC443140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:08:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6819661CD3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C004BC433D2;
        Sat, 31 Dec 2022 02:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452526;
        bh=D5q96YaFc/DCP0jlaRAH3qdNUF77gERh0mnNLbhv0xU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V9Wi8/dh4c+VsjPuSoQneMmGRTV7V0M/bxAEgwBT2SZfaa6KsvvBTyt7O+QiA8X7Q
         CUOchI46Zh+bSVCO7MPKrB24nDpVuwN9PZ6tZZA2PVMT2utlkX5BobNH0HezIP3JMO
         PdCgUFUETsg4KjNP1PEOX9QULOazhi8DOEc2fqIPUVgz/NZ/iJyVIklCGNeca4tBV4
         Feiq3kcVd83zuXo7P3MvXrdqNWf318y5TGFUyzZ1Ud5g1MfyczT8foRxQQmR90KXOv
         9OMhlF19ByVpMFr8oM5sO7G1zujZLm5BYc5Yf9GmhUTzkHijHDwwMBSJaQULyZO5jz
         L2BlestaU28Rw==
Subject: [PATCH 22/26] xfs: create libxfs helper to exchange two directory
 entries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875581.723621.10793024373873352545.stgit@magnolia>
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

Create a new libxfs function to exchange two directory entries.
The upcoming metadata directory feature will need this to replace a
metadata inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    4 ++
 2 files changed, 112 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index a0853d766f2..b0bb22ac506 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -949,3 +949,111 @@ xfs_dir_remove_child(
 
 	return 0;
 }
+
+/*
+ * Exchange the entry (@name1, @ip1) in directory @dp1 with the entry (@name2,
+ * @ip2) in directory @dp2, and update '..' @ip1 and @ip2's entries as needed.
+ * @ip1 and @ip2 need not be of the same type.
+ *
+ * All inodes must have the ILOCK held, and both entries must already exist.
+ */
+int
+xfs_dir_exchange(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp1,
+	struct xfs_name		*name1,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*dp2,
+	struct xfs_name		*name2,
+	struct xfs_inode	*ip2,
+	unsigned int		spaceres)
+{
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
+	int			error;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp1);
+			}
+
+			/*
+			 * Although ip1 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		}
+
+		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp2);
+			}
+
+			/*
+			 * Although ip2 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_CHG;
+		}
+	}
+
+	if (ip1_flags) {
+		xfs_trans_ichgtime(tp, ip1, ip1_flags);
+		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
+	}
+	if (ip2_flags) {
+		xfs_trans_ichgtime(tp, ip2, ip2_flags);
+		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
+	}
+	if (dp2_flags) {
+		xfs_trans_ichgtime(tp, dp2, dp2_flags);
+		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index e35deb273d8..f63390236f0 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -262,5 +262,9 @@ int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_exchange(struct xfs_trans *tp, struct xfs_inode *dp1,
+		struct xfs_name *name1, struct xfs_inode *ip1,
+		struct xfs_inode *dp2, struct xfs_name *name2,
+		struct xfs_inode *ip2, unsigned int spaceres);
 
 #endif	/* __XFS_DIR2_H__ */

