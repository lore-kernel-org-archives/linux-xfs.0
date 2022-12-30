Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD46C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiLaBPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:15:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9144816588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C99FB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81BEC433F0;
        Sat, 31 Dec 2022 01:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449301;
        bh=8+6n4U8i5t3Kc9+RCNSrrR9jvEKJj0LWYMads/A/BvE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZsGvbxlat08DnNLNJ2Gx5/AlWCNoARGOYYDQGURZN/kT7re1+XOUpJrSrGi1dYsf7
         4xMBuSMnL71MnCFnqWgv7g7w5YhHMcG6Yqx+yXxVycrsOnhloJ4WcxHDO/leE/2uZR
         LTIjlS792YLd9el4i3ab+o2Roo+DCcTAhjTQHFcRSoxHnRHsiaZN1NVwt41sVtZEDA
         dlBVmjxVcZX4Jt84/Buhsi9N7jPYS6x3+vRXlHIQ41eK07QYv8Z79DpDfABeQqnXwJ
         7vo0VtXtrW8rvjy9ZIIXsZPpmO7ODPsp7WrhdgEbLA4edoa8Gz7FVXSXT6T/fEfET8
         OVJQDsZBd9IDg==
Subject: [PATCH 18/23] xfs: enable creation of dynamically allocated metadir
 path structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864712.708110.18030104243814000684.stgit@magnolia>
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

Add a few helper functions so that it's possible to allocate
xfs_imeta_path objects dynamically, along with dynamically allocated
path components.  Eventually we're going to want to support paths of the
form "/realtime/$rtgroup.rmap", and this is necessary for that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_imeta.h |    8 ++++++++
 2 files changed, 51 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 07f88df7a7e5..8960c13117fc 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -1149,3 +1149,46 @@ xfs_imeta_lookup_update(
 
 	return error;
 }
+
+/* Create a path to a file within the metadata directory tree. */
+int
+xfs_imeta_create_file_path(
+	struct xfs_mount	*mp,
+	unsigned int		nr_components,
+	struct xfs_imeta_path	**pathp)
+{
+	struct xfs_imeta_path	*p;
+	char			**components;
+
+	p = kmalloc(sizeof(struct xfs_imeta_path), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	components = kvcalloc(nr_components, sizeof(char *), GFP_KERNEL);
+	if (!components) {
+		kfree(p);
+		return -ENOMEM;
+	}
+
+	p->im_depth = nr_components;
+	p->im_path = (const char **)components;
+	p->im_ftype = XFS_DIR3_FT_REG_FILE;
+	p->im_dynamicmask = 0;
+	*pathp = p;
+	return 0;
+}
+
+/* Free a metadata directory tree path. */
+void
+xfs_imeta_free_path(
+	struct xfs_imeta_path	*path)
+{
+	unsigned int		i;
+
+	for (i = 0; i < path->im_depth; i++) {
+		if ((path->im_dynamicmask & (1ULL << i)) && path->im_path[i])
+			kfree(path->im_path[i]);
+	}
+	kfree(path->im_path);
+	kfree(path);
+}
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 741f426c6a4a..7840087b71da 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -15,6 +15,7 @@ const struct xfs_imeta_path name = { \
 	.im_path = (path), \
 	.im_ftype = XFS_DIR3_FT_REG_FILE, \
 	.im_depth = ARRAY_SIZE(path), \
+	.im_dynamicmask = 0, \
 }
 
 /* Key for looking up metadata inodes. */
@@ -27,6 +28,9 @@ struct xfs_imeta_path {
 
 	/* Expected file type. */
 	unsigned int	im_ftype;
+
+	/* Each bit corresponds to an element of im_path needing to be freed */
+	unsigned long long im_dynamicmask;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */
@@ -52,6 +56,10 @@ int xfs_imeta_lookup_update(struct xfs_mount *mp,
 			    const struct xfs_imeta_path *path,
 			    struct xfs_imeta_update *upd, xfs_ino_t *inop);
 
+int xfs_imeta_create_file_path(struct xfs_mount *mp,
+		unsigned int nr_components, struct xfs_imeta_path **pathp);
+void xfs_imeta_free_path(struct xfs_imeta_path *path);
+
 void xfs_imeta_set_metaflag(struct xfs_trans *tp, struct xfs_inode *ip);
 
 /* Don't allocate quota for this file. */

