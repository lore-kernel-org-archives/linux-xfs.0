Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B82DC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCPTVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjCPTV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0306F8DCC7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB04620DC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDB0C433D2;
        Thu, 16 Mar 2023 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994474;
        bh=gVZA2QbWHQ15G9TjNdr6BKbJgZ7T98gx3nYsOsdjGgY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fS1eK9+JVeHx44ZPr+45P8g7F1an/rnflphfSvkAfiV3Eaxo5/8JCZX4At2f6rvGB
         XK60r08EyvyG9LTrwfWaOaUZkKbS/sToNqn+xJti/bztIqaVLUNFWr7LvavNFxJpYG
         5FhX9gP19Q+IP5BOEsSbycAuLAQhFUGzd4PlbxzA5DAZq8DTOy+FGTe90wL3ivFFya
         A3DhmkwaPW/kaBZh2u9aHOGyh3GdDa8ea6K0hxgc37rmVlXoNApFox31CEX3qtKNjD
         AYu5L/DTJSVQndlqLPx2l0QYQvNMqtg7DHqE66rvWh/H+2UOAxhX91P+saaAJRG4cC
         NJitqZtahiH1w==
Date:   Thu, 16 Mar 2023 12:21:14 -0700
Subject: [PATCH 6/7] xfs: shorten parent pointer function names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414012.15157.7283472383620875118.stgit@frogsfrogsfrogs>
In-Reply-To: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
References: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c |   18 ++++++++++++------
 fs/xfs/libxfs/xfs_parent.h |   24 ++++++++++++------------
 fs/xfs/xfs_inode.c         |   16 ++++++++--------
 fs/xfs/xfs_symlink.c       |    2 +-
 4 files changed, 33 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 179b9bebaf25..ec2bff195773 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -135,6 +135,10 @@ xfs_parent_irec_from_disk(
 	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
 }
 
+/*
+ * Allocate memory to control a logged parent pointer update as part of a
+ * dirent operation.
+ */
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
@@ -170,12 +174,13 @@ __xfs_parent_init(
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
@@ -194,8 +199,9 @@ xfs_parent_defer_add(
 	return xfs_attr_defer_add(args);
 }
 
+/* Remove a parent pointer to reflect a dirent removal. */
 int
-xfs_parent_defer_remove(
+xfs_parent_remove(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	struct xfs_parent_defer	*parent,
@@ -211,14 +217,14 @@ xfs_parent_defer_remove(
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index f4f5887d1133..35854e968f1d 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
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
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 20193ebd3a99..d73f9283f399 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1090,7 +1090,7 @@ xfs_create(
 	 * the parent information now.
 	 */
 	if (parent) {
-		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+		error = xfs_parent_add(tp, parent, dp, name, diroffset,
 					     ip);
 		if (error)
 			goto out_trans_cancel;
@@ -1355,7 +1355,7 @@ xfs_link(
 	 * the parent to the inode.
 	 */
 	if (parent) {
-		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+		error = xfs_parent_add(tp, parent, tdp, target_name,
 					     diroffset, sip);
 		if (error)
 			goto error_return;
@@ -2626,7 +2626,7 @@ xfs_remove(
 	}
 
 	if (parent) {
-		error = xfs_parent_defer_remove(tp, dp, parent, dir_offset, ip);
+		error = xfs_parent_remove(tp, dp, parent, dir_offset, ip);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -2835,12 +2835,12 @@ xfs_cross_rename(
 	}
 
 	if (xfs_has_parent(mp)) {
-		error = xfs_parent_defer_replace(tp, ip1_pptr, dp1,
+		error = xfs_parent_replace(tp, ip1_pptr, dp1,
 				old_diroffset, name2, dp2, new_diroffset, ip1);
 		if (error)
 			goto out_trans_abort;
 
-		error = xfs_parent_defer_replace(tp, ip2_pptr, dp2,
+		error = xfs_parent_replace(tp, ip2_pptr, dp2,
 				new_diroffset, name1, dp1, old_diroffset, ip2);
 		if (error)
 			goto out_trans_abort;
@@ -3310,7 +3310,7 @@ xfs_rename(
 		goto out_trans_cancel;
 
 	if (wip_pptr) {
-		error = xfs_parent_defer_add(tp, wip_pptr,
+		error = xfs_parent_add(tp, wip_pptr,
 					     src_dp, src_name,
 					     old_diroffset, wip);
 		if (error)
@@ -3318,7 +3318,7 @@ xfs_rename(
 	}
 
 	if (src_ip_pptr) {
-		error = xfs_parent_defer_replace(tp, src_ip_pptr, src_dp,
+		error = xfs_parent_replace(tp, src_ip_pptr, src_dp,
 				old_diroffset, target_name, target_dp,
 				new_diroffset, src_ip);
 		if (error)
@@ -3326,7 +3326,7 @@ xfs_rename(
 	}
 
 	if (tgt_ip_pptr) {
-		error = xfs_parent_defer_remove(tp, target_dp,
+		error = xfs_parent_remove(tp, target_dp,
 						tgt_ip_pptr,
 						new_diroffset, target_ip);
 		if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7872397b8b5c..3f4eebf0b260 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -348,7 +348,7 @@ xfs_symlink(
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	if (parent) {
-		error = xfs_parent_defer_add(tp, parent, dp, link_name,
+		error = xfs_parent_add(tp, parent, dp, link_name,
 					     diroffset, ip);
 		if (error)
 			goto out_trans_cancel;

