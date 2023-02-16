Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46070C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBPUip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBPUin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E6D1CF73
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D326B829AC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA494C433EF;
        Thu, 16 Feb 2023 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579919;
        bh=JbIaAh6MpblAeP2hYvdmjKkhvegG2735a4K+s77OEsA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sDb/+rNcxUAJULxw1rVujC7w74jkV3PAguuXMVr33CeAotpzkHG+wsapdnxjRWju1
         JnlOF23Wi1chk3fbVw+hGQ5CwxRh/NxkNgjbI3Pqz1hk1Yjx8Plkc/ksdmM6Vdxq0l
         FeP6FSpD03QJAMwqXCXCeD3qMXwcGIvmM3HUwUCbSpF5f6ZKU4bpZCLUZg/5bKlZT0
         PrNATgD0Eet6oiiPxnKZrxYfel3WLdZaWTWVqQd0gc2CY/KPQ0QsDkeVL96tt5M5k+
         eLSycHJ9mfEDZsEeK9yS91ZMrzNLTm2xFLXUKMnxaAByKiX3+UE6I1l5Ku7hqKIjow
         i3RQMlIlC+9DA==
Date:   Thu, 16 Feb 2023 12:38:39 -0800
Subject: [PATCH 23/28] xfs: Add helper function xfs_attr_list_context_init
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872715.3473407.1602330056133097351.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a helper function xfs_attr_list_context_init used by
xfs_attr_list. This function initializes the xfs_attr_list_context
structure passed to xfs_attr_list_int. We will need this later to call
xfs_attr_list_int_ilocked when the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |    1 +
 fs/xfs/xfs_ioctl.c |   54 +++++++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_ioctl.h |    2 ++
 3 files changed, 41 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 595a5bcf46b9..9c09d32a6c9e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -17,6 +17,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 736510bc241b..5cd5154d4d1e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -369,6 +369,40 @@ xfs_attr_flags(
 	return 0;
 }
 
+/*
+ * Initializes an xfs_attr_list_context suitable for
+ * use by xfs_attr_list
+ */
+int
+xfs_ioc_attr_list_context_init(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct xfs_attr_list_context	*context)
+{
+	struct xfs_attrlist		*alist;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	context->dp = dp;
+	context->resynch = 1;
+	context->attr_filter = xfs_attr_filter(flags);
+	context->buffer = buffer;
+	context->bufsize = round_down(bufsize, sizeof(uint32_t));
+	context->firstu = context->bufsize;
+	context->put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context->buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context->bufsize;
+
+	return 0;
+}
+
+
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
@@ -378,7 +412,6 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist_cursor __user *ucursor)
 {
 	struct xfs_attr_list_context	context = { };
-	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
 
@@ -410,21 +443,10 @@ xfs_ioc_attr_list(
 	if (!buffer)
 		return -ENOMEM;
 
-	/*
-	 * Initialize the output buffer.
-	 */
-	context.dp = dp;
-	context.resynch = 1;
-	context.attr_filter = xfs_attr_filter(flags);
-	context.buffer = buffer;
-	context.bufsize = round_down(bufsize, sizeof(uint32_t));
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_ioc_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
+	error = xfs_ioc_attr_list_context_init(dp, buffer, bufsize, flags,
+			&context);
+	if (error)
+		return error;
 
 	error = xfs_attr_list(&context);
 	if (error)
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d4abba2c13c1..ca60e1c427a3 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -35,6 +35,8 @@ int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
 		      size_t bufsize, int flags,
 		      struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list_context_init(struct xfs_inode *dp, char *buffer,
+		int bufsize, int flags, struct xfs_attr_list_context *context);
 
 extern struct dentry *
 xfs_handle_to_dentry(

