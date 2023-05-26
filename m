Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559CBC7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZBuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbjEZBtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:49:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71001189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B6064868
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69729C433EF;
        Fri, 26 May 2023 01:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065791;
        bh=d55PfCOLQB11NOPHYawjNN7Yx/g2pXe9NR2+2fqbQsY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WPa/s+QILo/oZl9V2auNrHnqfs/2Cu/duw8M7ogO3NdcZ1T9VCHftQcIjUgeeI0uM
         8+GoyAaGAJDS7vfnDDxW795kZrrz4aACGaGfLosG/YGJc50t37pNhTUwzyZl9vJLhv
         s+qgqY1ZbOUHI2vtA8UMI0EORjAPjDH7BXHwqtAiZwf3g4HqX3/ziU/Cmca5Cv3skf
         xWE7Syv5Q0/75Vy1tINhnuet1484iClnDmgmuSECmyC9yVslDamHbUPzHW3YC5ORBT
         soietc54McavDCKNj/7hIpXL3Vm6jnCdYlOS47wpo85h+fL9+FXzkpSihF4A5sBCPT
         t+sUQZh9UZ6Ng==
Date:   Thu, 25 May 2023 18:49:51 -0700
Subject: [PATCH 5/8] xfs_scrub: report FITRIM errors properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073147.3744829.12988251688048250604.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
References: <168506073077.3744829.468307851541842353.stgit@frogsfrogsfrogs>
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
 scrub/phase8.c |   12 +++++++++++-
 scrub/vfs.c    |   12 +++++++-----
 scrub/vfs.h    |    2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 6ad948ff6bf..3e174e400ba 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -47,10 +47,20 @@ int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	fstrim(ctx);
+	error = fstrim(ctx);
+	if (error == EOPNOTSUPP)
+		return 0;
+
+	if (error) {
+		str_liberror(ctx, error, _("fstrim"));
+		return error;
+	}
+
 	progress_add(1);
 	return 0;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index e4d56d1d380..5366e005746 100644
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
+		return EOPNOTSUPP;
+
+	return errno;
 }
diff --git a/scrub/vfs.h b/scrub/vfs.h
index f79b1997a5b..e512df647b4 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-void fstrim(struct scrub_ctx *ctx);
+int fstrim(struct scrub_ctx *ctx);
 
 #endif /* XFS_SCRUB_VFS_H_ */

