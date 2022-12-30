Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D761FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiLaBLK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiLaBLJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:11:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D29C13CC6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:11:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF08561D5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356D1C433D2;
        Sat, 31 Dec 2022 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449067;
        bh=ak8RobrBD5Jqlr9Rk8pnp9gVF1zl9DcUDVwFzFHyHiU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hY+I5SOTMk9o2Kv0JYkq7l+6UwvIT8jDulG4aFtyUUVXDLy2r2UkYx4G3re4ezx5Z
         EOugY71hPnBoQe67Bk84rDtEdQpGX9cz3aehR0wWTr6C6j4+FsLfvx4/0Yq+Y8IkLY
         MtAUKS0YuxXoQWitgpMTsl9SwvH7oj6SpcPpZsEKsr7J0cCcbtiS4EMYT/M9SYHEwR
         vh+eRhMWIA7rV4s5CHsaA5ex9feLx9laU1Q2ENQRlHL5o8aWYAOopTdQDc8spzP7jv
         +PAsAuMt0373589UGQumI8BdUrusVqD2NFgMudb63Toe6XuMHRRh2mxR9X1xZCdr1F
         K5XJ8a1i/ckbQ==
Subject: [PATCH 03/23] xfs: create transaction reservations for metadata inode
 operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864499.708110.13666815843828802033.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.  Right now the reservations
are the same as always; we're just separating the symbols for a future
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c      |   20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h      |    3 +++
 fs/xfs/libxfs/xfs_trans_resv.c |    4 ++++
 fs/xfs/libxfs/xfs_trans_resv.h |    2 ++
 4 files changed, 29 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 0a1cd0c5c15b..f14b7892f50d 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -19,6 +19,10 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata Inode Number Management
@@ -436,3 +440,19 @@ xfs_imeta_mount(
 {
 	return 0;
 }
+
+/* Calculate the log block reservation to create a metadata inode. */
+unsigned int
+xfs_imeta_create_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_IALLOC_SPACE_RES(mp);
+}
+
+/* Calculate the log block reservation to unlink a metadata inode. */
+unsigned int
+xfs_imeta_unlink_space_res(
+	struct xfs_mount	*mp)
+{
+	return XFS_REMOVE_SPACE_RES(mp);
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index b535e19ff1a0..9d54cb0d7962 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -45,4 +45,7 @@ int xfs_imeta_start_update(struct xfs_mount *mp,
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..d2716184bd8f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1025,4 +1025,8 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount += logcount_adj;
 	resp->tr_write.tr_logcount += logcount_adj;
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create = resp->tr_create;
+	resp->tr_imeta_unlink = resp->tr_remove;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0554b9d775d2..3836c5131b91 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -48,6 +48,8 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */

