Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AA4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiLaCHr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:07:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8017B1C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2524861CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C857C433EF;
        Sat, 31 Dec 2022 02:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452464;
        bh=XQifu2S0REiqLMQAKODpExBnNIuq2MHCVVL0PoRnUw0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n86MZD1y+MBz9WFtBeM4T1kZdyFoiO1zK01FkgRbdeRLM4L7whLeSmdpTKz0R5sG+
         +uKCwPJiHc21dyw8flahnyK3CAJ/gqZW2MzAy3SVsUdKcXu9ECPwsrCzZhO9AuB3Ix
         lmhfjy4K2hvvzsXd9SqufFOdz8/2lX5maFlxpG7zHquiRIu5HrOmBlwccLl1D1JTYK
         l9RyuI1YDwdVpHgr/jVnzKFlSVPAVRuim6xXWIbJJntkRkQagVlAjk/9ITvkHuF+Of
         zeBVFpE27KwfPWNay4N1KPh60Y41XTMJUmKVhT4PK+9S0jQpZ4jMIYWpoBPMpz2SWv
         jJR986fxHiYGA==
Subject: [PATCH 18/26] xfs: create libxfs helper to link a new inode into a
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875535.723621.9136738856135046159.stgit@magnolia>
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

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    4 ++++
 2 files changed, 49 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 460b64339d7..ed52969b45d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,6 +18,9 @@
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_shared.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -780,3 +783,45 @@ xfs_dir2_compname(
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
 }
+
+/*
+ * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
+ * into @dp under the given @name.  If @ip is a directory, it will be
+ * initialized.  Both inodes must have the ILOCK held and the transaction must
+ * have sufficient blocks reserved.
+ */
+int
+xfs_dir_create_new_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+	ASSERT(resblks == 0 || resblks > XFS_IALLOC_SPACE_RES(mp));
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
+					resblks - XFS_IALLOC_SPACE_RES(mp));
+	if (error) {
+		ASSERT(error != -ENOSPC);
+		return error;
+	}
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (!S_ISDIR(VFS_I(ip)->i_mode))
+		return 0;
+
+	error = xfs_dir_init(tp, ip, dp);
+	if (error)
+		return error;
+
+	xfs_bumplink(tp, dp);
+	return 0;
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 7322284f61a..d3e7607c0e9 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -253,4 +253,8 @@ unsigned int xfs_dir3_data_end_offset(struct xfs_da_geometry *geo,
 		struct xfs_dir2_data_hdr *hdr);
 bool xfs_dir2_namecheck(const void *name, size_t length);
 
+int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
+
 #endif	/* __XFS_DIR2_H__ */

