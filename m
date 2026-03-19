Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680D94317D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895767; cv=none; b=jFDwLJs4R9xfrOFwqe063dqQlkJ0M4tv1SH/TujnGT72t0oMQHtUXWmPXsRcDQzRBSy6wK3y4gFRReMla4sGZaTVgt7twC0rFtLfQFpVSWCw8e7hzbJTXXmYisIef5kXmdvoriReiCIK3iIsTwvHfQIxY97IxL5zKTD+u+XDpJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895767; c=relaxed/simple;
	bh=ZNOBeqer5B3JytuK5II2ljsgKFR5T7HZG0gPfqn/iUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RI+GGoksky/riSiPWmkxQRvLeOIMTTGFUdn/m+r54BDRL7GqWQ+oOVACd3YQfgeVyopft2TS26d7WtGEQsMnCaGGLAddboKv2aZJcIbzJv/8GT5IDEt4eTnnYViMvhSTyAGKaG7eTYH5um37kF8gKOHMPgFVBkrxZJCQpZLrvFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAyENf/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAyENf/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C4FC19425;
	Thu, 19 Mar 2026 04:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895767;
	bh=ZNOBeqer5B3JytuK5II2ljsgKFR5T7HZG0gPfqn/iUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JAyENf/nNYEhi5ZpLW0IwdAQCNF0Zsww2eWf7FxyffKXncgbj2SV9ol+1cTBZ4yzO
	 KJEXHJ1r2KDYRyEJFCn8Sw3MoOQYmdiX2F33+2gu/urUO8iPbma/dLISoncO15yx5f
	 RZuqR+wwMPjPU7n78zUNmm0zl1OWBntJN1G94sHjUXAu8s15GJDB9xpq2jdXtL0Sts
	 DHLBCEfKOW6QfGHAEe4mGcFnTeVfKk/WHWk7fOfAqhehd6VM+p7Rp/PxVNfOcPMq7Z
	 8e73EXG/B3WhfGpej76/sBnQge7A2MSI+Em0Hmks6kNbi5Byu7bpcYE9OvMbJS2/Rc
	 y+UiF6Panlycw==
Date: Wed, 18 Mar 2026 21:49:26 -0700
Subject: [PATCH 15/22] scrub: don't allocate disk for ioctl-based media verify
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507215.3681140.128799484083601255.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

When the kernel provides the data verification ioctl there is no point
in allocating struct disk and thus opening the underlying devices.
Refactor the code so that we don't have to do that, with the added
benefit of keeping the read verification self-contained in
read_verify.c for the case where the kernel provides the ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: break up patch]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase1.c |   65 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 20 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index abc594898bf2c5..f4d50d016c2ebd 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -213,8 +213,39 @@ mode_from_autofsck(
 	goto summarize;
 }
 
+/*
+ * We can't do XFS_IOC_VERIFY_MEDIA media verification, so we need to fall back
+ * to reading the disk.  We already opened the data device, now we need to open
+ * the rt and log devices for media verification.
+ */
+static int
+configure_xfs_verify_fallback(
+	struct scrub_ctx	*ctx)
+{
+	if (ctx->fsinfo.fs_log) {
+		ctx->verify_disks[XFS_DEV_LOG] = disk_open(ctx->fsinfo.fs_log);
+		if (!ctx->verify_disks[XFS_DEV_LOG]) {
+			str_error(ctx, ctx->mntpoint,
+				_("Unable to open external log device."));
+			return ECANCELED;
+		}
+	}
+
+	if (ctx->fsinfo.fs_rt) {
+		ctx->verify_disks[XFS_DEV_RT] = disk_open(ctx->fsinfo.fs_rt);
+		if (!ctx->verify_disks[XFS_DEV_RT]) {
+			str_error(ctx, ctx->mntpoint,
+				_("Unable to open realtime device."));
+			return ECANCELED;
+		}
+	}
+
+	ctx->no_verify_ioctl = true;
+	return 0;
+}
+
 /* Does the XFS driver support media scanning its own disks? */
-static void
+static bool
 configure_xfs_verify(
 	struct scrub_ctx	*ctx)
 {
@@ -225,8 +256,7 @@ configure_xfs_verify(
 		.me_dev		= XFS_DEV_DATA,
 	};
 
-	if (ioctl(ctx->mnt.fd, XFS_IOC_VERIFY_MEDIA, &me))
-		ctx->no_verify_ioctl = true;
+	return ioctl(ctx->mnt.fd, XFS_IOC_VERIFY_MEDIA, &me) == 0;
 }
 
 /*
@@ -378,24 +408,19 @@ _("Unable to find realtime device path."));
 		fflush(stdout);
 	}
 
-	if (ctx->fsinfo.fs_log) {
-		ctx->verify_disks[XFS_DEV_LOG] = disk_open(ctx->fsinfo.fs_log);
-		if (!ctx->verify_disks[XFS_DEV_LOG]) {
-			str_error(ctx, ctx->mntpoint,
-				_("Unable to open external log device."));
-			return ECANCELED;
-		}
+	if (configure_xfs_verify(ctx)) {
+		/*
+		 * ioctl-based media verification is enabled and we already set
+		 * nr_io_threads from the data device, so we no longer need to
+		 * keep this open.
+		 */
+		disk_close(ctx->verify_disks[XFS_DEV_DATA]);
+		ctx->verify_disks[XFS_DEV_DATA] = NULL;
+	} else {
+		error = configure_xfs_verify_fallback(ctx);
+		if (error)
+			return error;
 	}
-	if (ctx->fsinfo.fs_rt) {
-		ctx->verify_disks[XFS_DEV_RT] = disk_open(ctx->fsinfo.fs_rt);
-		if (!ctx->verify_disks[XFS_DEV_RT]) {
-			str_error(ctx, ctx->mntpoint,
-				_("Unable to open realtime device."));
-			return ECANCELED;
-		}
-	}
-
-	configure_xfs_verify(ctx);
 
 	/*
 	 * Everything's set up, which means any failures recorded after

