Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D84C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjBPVHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjBPVHH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:07:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3142D2B632
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C37B960BFE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E52C433EF;
        Thu, 16 Feb 2023 21:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581625;
        bh=AiM0WqRVjRuNiWrv9EzqUofUanAeU1/gOoxJJEzkT8Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Rc8fwVW/NvTxjiV+V0Wf2ws32F4YYwuFsAgWq6orxepwbEBaPXdxuIToy3pxaLvXv
         lt3kLxBSBOjglv9Nf/CsuNiJOPW36uI58q826gYUj1fHEv29MgzRbNXlwLyVjP8J58
         wi5OuuS71utAczBF2T+w9wB6NraJ7BKoRm2v9LAOTffrEZ3ikrH75432A+P2h32APM
         BO7e8VhDe2giopkdGy8SyrU/UQFO3ORn7MHJxvUH0v8noiEMDdZAmJZzOvD2sAvfAd
         boo38A1vvj7BXKgRqMW1pZ2+XMSrfRsOoIfuNYw0T+qugUdmQDxMz7Po9mUr1GnjfV
         zcarSdAOM/k0w==
Date:   Thu, 16 Feb 2023 13:07:04 -0800
Subject: [PATCH 1/3] xfs: shorten parent pointer function names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881038.3477513.11767684665536808344.stgit@magnolia>
In-Reply-To: <167657881025.3477513.15490690754847111370.stgit@magnolia>
References: <167657881025.3477513.15490690754847111370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Shorten the function names and add brief comments to each, outlining
what they're supposed to be doing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +-
 libxfs/xfs_parent.c      |   18 ++++++++++++------
 libxfs/xfs_parent.h      |   24 ++++++++++++------------
 mkfs/proto.c             |   12 ++++++------
 4 files changed, 31 insertions(+), 25 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 6d045867..a5045d2e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -141,7 +141,7 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
-#define xfs_parent_defer_add		libxfs_parent_defer_add
+#define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 74c7f1f7..89eb531f 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -136,6 +136,10 @@ xfs_parent_irec_from_disk(
 	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
 }
 
+/*
+ * Allocate memory to control a logged parent pointer update as part of a
+ * dirent operation.
+ */
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
@@ -171,12 +175,13 @@ __xfs_parent_init(
 	return 0;
 }
 
+/* Add a parent pointer to reflect a dirent addition. */
 int
-xfs_parent_defer_add(
+xfs_parent_add(
 	struct xfs_trans	*tp,
 	struct xfs_parent_defer	*parent,
 	struct xfs_inode	*dp,
-	struct xfs_name		*parent_name,
+	const struct xfs_name	*parent_name,
 	xfs_dir2_dataptr_t	diroffset,
 	struct xfs_inode	*child)
 {
@@ -195,8 +200,9 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+/* Remove a parent pointer to reflect a dirent removal. */
 int
-xfs_parent_defer_remove(
+xfs_parent_remove(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	struct xfs_parent_defer	*parent,
@@ -212,14 +218,14 @@ xfs_parent_defer_remove(
 	return xfs_attr_defer_remove(args);
 }
 
-
+/* Replace one parent pointer with another to reflect a rename. */
 int
-xfs_parent_defer_replace(
+xfs_parent_replace(
 	struct xfs_trans	*tp,
 	struct xfs_parent_defer	*new_parent,
 	struct xfs_inode	*old_dp,
 	xfs_dir2_dataptr_t	old_diroffset,
-	struct xfs_name		*parent_name,
+	const struct xfs_name	*parent_name,
 	struct xfs_inode	*new_dp,
 	xfs_dir2_dataptr_t	new_diroffset,
 	struct xfs_inode	*child)
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index f4f5887d..35854e96 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -49,8 +49,9 @@ struct xfs_parent_defer {
  * Parent pointer attribute prototypes
  */
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
-			      struct xfs_inode *ip,
-			      uint32_t p_diroffset);
+		struct xfs_inode *ip, uint32_t p_diroffset);
+void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
+			       struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 
@@ -78,18 +79,17 @@ xfs_parent_start_locked(
 	return 0;
 }
 
-int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
-			 struct xfs_inode *dp, struct xfs_name *parent_name,
-			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
-int xfs_parent_defer_replace(struct xfs_trans *tp,
+int xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+		struct xfs_inode *dp, const struct xfs_name *parent_name,
+		xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+int xfs_parent_replace(struct xfs_trans *tp,
 		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
-		xfs_dir2_dataptr_t old_diroffset, struct xfs_name *parent_name,
-		struct xfs_inode *new_ip, xfs_dir2_dataptr_t new_diroffset,
+		xfs_dir2_dataptr_t old_diroffset,
+		const struct xfs_name *parent_name, struct xfs_inode *new_ip,
+		xfs_dir2_dataptr_t new_diroffset, struct xfs_inode *child);
+int xfs_parent_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_parent_defer *parent, xfs_dir2_dataptr_t diroffset,
 		struct xfs_inode *child);
-int xfs_parent_defer_remove(struct xfs_trans *tp, struct xfs_inode *dp,
-			    struct xfs_parent_defer *parent,
-			    xfs_dir2_dataptr_t diroffset,
-			    struct xfs_inode *child);
 
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index e0131df5..b8d7ac96 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -508,8 +508,8 @@ parseproto(
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
 		if (parent) {
-			error = -libxfs_parent_defer_add(tp, parent, pip,
-					&xname, offset, ip);
+			error = -libxfs_parent_add(tp, parent, pip, &xname,
+					offset, ip);
 			if (error)
 				fail(_("committing parent pointers failed."),
 						error);
@@ -601,8 +601,8 @@ parseproto(
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
 		if (parent) {
-			error = -libxfs_parent_defer_add(tp, parent, pip,
-					&xname, offset, ip);
+			error = -libxfs_parent_add(tp, parent, pip, &xname,
+					offset, ip);
 			if (error)
 				fail(_("committing parent pointers failed."),
 						error);
@@ -636,8 +636,8 @@ parseproto(
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
 	if (parent) {
-		error = -libxfs_parent_defer_add(tp, parent, pip, &xname,
-				offset, ip);
+		error = -libxfs_parent_add(tp, parent, pip, &xname, offset,
+				ip);
 		if (error)
 			fail(_("committing parent pointers failed."), error);
 	}

