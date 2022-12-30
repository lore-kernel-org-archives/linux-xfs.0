Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EFBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiLaCKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCKZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:10:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFECA140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25432CE1926
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612F2C433D2;
        Sat, 31 Dec 2022 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452620;
        bh=E2MOaathI95qDx3Jtrv9M8MI1l2ubyuCYPg5etJgn0Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ek1eXABmaSMGZVDFK1HskMWERJOGw/RULxLwXzc/qx3XDG+T735HryPiD3ygSpaym
         agxNdtmCCQPEWo8ni+pj8tRkGtBNw2ObN8ryciBQeXKHt3UM5uGvNF7nQc2Y95yJe6
         erAEqIK4sWTndycPgPtSgkZBSxfqWJ2t9KaK+njHLHjJddODhUjm7xSRoCq+IU6PKr
         86kFiAu6/wKHsOfz/SLG5KdCFfN8Ae3UVXcppfG0Q/F0oscfiMJVzQY5NEdMr1vthi
         Zgj6OISgINZl/KMF4wuuWzpyJwC9kRxfgtGJhPBlu06ZrdmajlqnUIeak/CVguHIuP
         h8l96SaqVncnA==
Subject: [PATCH 02/46] xfs: create transaction reservations for metadata inode
 operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:19 -0800
Message-ID: <167243875969.725900.3452525934158218936.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.  Right now we're just
separating the symbols for a future patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_imeta.c       |   20 ++++++++++++++++++++
 libxfs/xfs_imeta.h       |    3 +++
 libxfs/xfs_trans_resv.c  |    4 ++++
 libxfs/xfs_trans_resv.h  |    2 ++
 5 files changed, 31 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5657fee51b8..69f1cf2c752 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -157,12 +157,14 @@
 #define xfs_imap_to_bp			libxfs_imap_to_bp
 
 #define xfs_imeta_create		libxfs_imeta_create
+#define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
 #define xfs_imeta_end_update		libxfs_imeta_end_update
 #define xfs_imeta_link			libxfs_imeta_link
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
 #define xfs_imeta_start_update		libxfs_imeta_start_update
 #define xfs_imeta_unlink		libxfs_imeta_unlink
+#define xfs_imeta_unlink_space_res	libxfs_imeta_unlink_space_res
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index b5c6672e7d5..bc3c94634ce 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -18,6 +18,10 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata Inode Number Management
@@ -435,3 +439,19 @@ xfs_imeta_mount(
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
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index b535e19ff1a..9d54cb0d796 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -45,4 +45,7 @@ int xfs_imeta_start_update(struct xfs_mount *mp,
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_mount *mp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c444806fe..00bdcb1d550 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1024,4 +1024,8 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount += logcount_adj;
 	resp->tr_write.tr_logcount += logcount_adj;
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create = resp->tr_create;
+	resp->tr_imeta_unlink = resp->tr_remove;
 }
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 0554b9d775d..3836c5131b9 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -48,6 +48,8 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */

