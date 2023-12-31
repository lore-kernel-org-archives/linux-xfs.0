Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C746AC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYr9Hhwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D163C433C8;
	Sun, 31 Dec 2023 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063109;
	bh=8xyCQtxsTPrqMannou3hRvpU/yPFDOoIMTpqUjZ3x+E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kYr9HhwmeOtqyqMFCGEVENOV02r1denEHb7hADcJzSAugIf9MFfRkukco7dWLWYxe
	 UXg7DhCJ0ZaxpkUOIHhsORcb+G367yPivSwzjD4ExDJpMnhN82DjQ+PSTRSm/kcMUB
	 0Y0HFhEa6KA5V2v99dyNPHWceLYAzh7sKcLsUVdpIORmU7CLD4jqZO6sCvIs7dGQjF
	 PwlfHHWdSr+Z0QDKTa8OUxDg0Ht6KOvUsMIMH++5Ud+iCMnEfoAUw9mC9H94C6tjzm
	 0KXmzfB4RWWioWxVfyhlgODm7zEHKdQxd6NaYkmJvvrfKLTNguiaKS1MrLVZGl6IZg
	 tfUS+1Xfb5Jrw==
Date: Sun, 31 Dec 2023 14:51:49 -0800
Subject: [PATCH 5/7] xfs_scrub: remove pointless spacemap.c arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001523.1798998.2486622165570624583.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
References: <170405001452.1798998.1713163893791596567.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove unused parameters from the full-device spacemap scan functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/spacemap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index b6fd411816b..f20ecfeac5d 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -132,7 +132,6 @@ scan_ag_rmaps(
 static void
 scan_dev_rmaps(
 	struct scrub_ctx	*ctx,
-	int			idx,
 	dev_t			dev,
 	struct scan_blocks	*sbx)
 {
@@ -170,7 +169,7 @@ scan_rt_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_rtdev, arg);
 }
 
 /* Iterate all the reverse mappings of the log device. */
@@ -182,7 +181,7 @@ scan_log_rmaps(
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, ctx->fsinfo.fs_logdev, arg);
 }
 
 /*
@@ -210,8 +209,7 @@ scrub_scan_all_spacemaps(
 		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = -workqueue_add(&wq, scan_rt_rmaps,
-				ctx->mnt.fsgeom.agcount + 1, &sbx);
+		ret = -workqueue_add(&wq, scan_rt_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
@@ -219,8 +217,7 @@ scrub_scan_all_spacemaps(
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = -workqueue_add(&wq, scan_log_rmaps,
-				ctx->mnt.fsgeom.agcount + 2, &sbx);
+		ret = -workqueue_add(&wq, scan_log_rmaps, 0, &sbx);
 		if (ret) {
 			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing logdev fsmap work"));

