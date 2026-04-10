Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7251A682B
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802077; cv=none; b=IC3B/7zoIlQ3TWEBrcEYE7zRLHP0b5ukTgI7fG/VEEIQHhmly4KjAhfg0toc8eRj7CSglCg/6hIP9nlGlxOVqFJFPW/87ESjJUIetVpGD2EsuYmnMsAL6grKfdKlDd1A3diOSQWb1xyBUEHKVDtjf3ycTDurlKJTbpXgCd9uO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802077; c=relaxed/simple;
	bh=ZNOBeqer5B3JytuK5II2ljsgKFR5T7HZG0gPfqn/iUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvR0IuY+wkl8PDNmtN09p6MYUD1OWkHb9RCHumQoG3cgmcXqC26eyFeyB385zL+yKacIlH/KUWaqJNaOUzApKa+3cgodvxdmmYS2B6weO5PEPc1s11ugZILMSzpUU8oyh3MFuIVmt47BXuLu/7RpfUfYe8CncYUxAQlxC1st7EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ED7KBmUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ED7KBmUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6DC19421;
	Fri, 10 Apr 2026 06:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802077;
	bh=ZNOBeqer5B3JytuK5II2ljsgKFR5T7HZG0gPfqn/iUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ED7KBmUlXGhNAfkk1l5lYtRk6aohfX1Q4nUmTJ3gAGyP0bdNMiktm7QKbpSkWjhU9
	 urfKjDk1aLbVeT0vyugpbOJ3J6+0BRWAwF35ccynHLtLSPHmUdNdwqIqcuQSbn2itp
	 71l0BrJLVEahCj564IHErjkBe8EjTaAlePbdVVuzg/C+14rw+XK73iqFmqzsrWwry0
	 sPTQguxFJ86F1s8QC+0WcBfNFGMZBnIYpz1TOLsKwU0sqqlhW53CJngkfb+q7KDecW
	 6qVSifQi/ODLRAwW97ITr/7fklP7lNlxxrqOwWZYLbQ3Uc36eAHCzbIegnprluZP0D
	 U3Mh77FPhXtfg==
Date: Thu, 09 Apr 2026 23:21:17 -0700
Subject: [PATCH 15/21] scrub: don't allocate disk for ioctl-based media verify
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385308.2090237.7193451271594756148.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
References: <177577384929.2090237.10369276062302001541.stgit@frogsfrogsfrogs>
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

