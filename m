Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09161C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiLaAdR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:33:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6303714006
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16387B80883
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA754C433D2;
        Sat, 31 Dec 2022 00:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446793;
        bh=Acp5gWtVhxXN18UDxPY/9vVP+O9VbSEaANIjxl0n5CE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KK9nD0XwCSBmEpcnHGNAtMaeQNVIssYv+qnHA3ZaKMmi1EUl3/fqGpslESRdk0S4C
         T2pxpi0BUe+hinFUCU8AAnSVwQyeVoa203hz7lag331k2khZv+SEQcJdHAp7CnWMuK
         I4IZqsFev9CKgKBwDhK4TxqhFEISEXH3sZ/LwE8YYmhDMSYGtF6ljaExnY+f9qjNzQ
         95jmwcJbKcdDi25eiTijSHL+mgbOTwNlAzu5YyxmB+rdJb2t+1FGnZMdPctshnj5sL
         oBg38/Bl/gMMe978lSXNRIbmfNUQmha9Jk1XkIVJ4sO2pgNnxg3syiwFG2QbzU5zPq
         v7y6GRa4mOwWw==
Subject: [PATCH 5/7] xfs_scrub: report FITRIM errors properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:28 -0800
Message-ID: <167243870813.716924.4414068608990346746.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the error reporting for the FITRIM ioctl out of vfs.c and into
phase8.c.  This makes it so that IO errors encountered during trim are
counted as runtime errors instead of being dropped silently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |    9 ++++++++-
 scrub/vfs.c    |   12 +++++++-----
 scrub/vfs.h    |    2 +-
 3 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 789ef2b2b4e..c54f2cc738b 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -47,10 +47,17 @@ int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	fstrim(ctx);
+	error = fstrim(ctx);
+	if (error) {
+		str_liberror(ctx, error, _("fstrim"));
+		return error;
+	}
+
 	progress_add(1);
 	return 0;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 577eb6dc3e8..ca34972d401 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -296,15 +296,17 @@ struct fstrim_range {
 #endif
 
 /* Call FITRIM to trim all the unused space in a filesystem. */
-void
+int
 fstrim(
 	struct scrub_ctx	*ctx)
 {
 	struct fstrim_range	range = {0};
-	int			error;
 
 	range.len = ULLONG_MAX;
-	error = ioctl(ctx->mnt.fd, FITRIM, &range);
-	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
-		perror(_("fstrim"));
+	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
+		return 0;
+	if (errno == EOPNOTSUPP || errno == ENOTTY)
+		return 0;
+
+	return errno;
 }
diff --git a/scrub/vfs.h b/scrub/vfs.h
index dc1099cf18d..14f2a583eb1 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-void fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_VFS_H_ */

