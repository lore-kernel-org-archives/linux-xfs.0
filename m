Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DD9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiLaCID (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCIB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:08:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13724140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5FF61CCE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120EEC433D2;
        Sat, 31 Dec 2022 02:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452480;
        bh=NDT3Q8Uwyhg7qsE1y5Iv2NjbEs2ENum1dNZ2nyCaojA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i9NsEMcEXXOnXLpZFBAQbIXFOG8iEHeFpsUAV5ApFmas9b/gjfoXtI2NA6mWua+DG
         M/7kxUSHYp4Z+FE26JBLjL18ToguYjgQltud14k8hZAIQTE2AHtEZnCCflDukh11Al
         5vBhXDfhk3mcSUuY+8IwIJIz9187C7xScqsJVV0lajouSNgC6EWiPQH/RefyVR3BIV
         L5lZXEpT8hRH/d0u3y19cme3vnxxBmKiJi84/wK5MmUfk8IPp+yRvuJkMX1bYplFxG
         VVMkQn/i09JnZ69PpFZNBdThsHnpDGs/E9ck30B6JzAflDoNAX3zzrZWsLtmt5M9sL
         M4fC1pM/rCIxA==
Subject: [PATCH 19/26] xfs: create libxfs helper to link an existing inode
 into a directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875547.723621.11413859898250059295.stgit@magnolia>
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

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    3 +++
 2 files changed, 54 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index ed52969b45d..8755ef615f8 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -21,6 +21,7 @@
 #include "xfs_shared.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
+#include "xfs_ag.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -825,3 +826,53 @@ xfs_dir_create_new_child(
 	xfs_bumplink(tp, dp);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, an existing non-directory inode @ip, and a @name,
+ * link @ip into @dp under the given @name.  Both inodes must have the ILOCK
+ * held.
+ */
+int
+xfs_dir_link_existing_child(
+	struct xfs_trans	*tp,
+	uint			resblks,
+	struct xfs_inode	*dp,
+	struct xfs_name		*name,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(!S_ISDIR(VFS_I(ip)->i_mode));
+
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+		error = xfs_iunlink_remove(tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	xfs_bumplink(tp, ip);
+	return 0;
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index d3e7607c0e9..4afade8b087 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -256,5 +256,8 @@ bool xfs_dir2_namecheck(const void *name, size_t length);
 int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */

