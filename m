Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC430A927
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178326; cv=none; b=HeQbFGBrizP+kETPyS/nSq3GUolD8HGz3EHJGqdIklFWAmDL34K9WmznW//ia8K/qm7L2sqjcnL3XBanJMDDlQw/TwCiY25EJDYVx7zxN95CtxJrRMz4Xv4SYeUwau1Djd5Tla8vpiy7ycqeRm7Y5hBM9hPScQzARdxtPvUk/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178326; c=relaxed/simple;
	bh=JiZu6VTbsrjyCdiktyIoZJBf9cb5vP+oyX5cVX64lyU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlzsbdthxB+ekplXyx+OUsDkv2vBEMzKudyz2rfjy1bFbssbEDynqNRcWQVCooHRayiNJFsVHe/pcLMjDxNIyfjQfG12fGGYWoCuJPWcxxz5yv4/R/rq8ka5MgzERylUcdwz46lUiIVCxiDZZoPnnIMfKh2uSFMfJKxhhwpuyyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYMMYMVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYMMYMVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23920C4CEE7;
	Thu, 23 Oct 2025 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178325;
	bh=JiZu6VTbsrjyCdiktyIoZJBf9cb5vP+oyX5cVX64lyU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QYMMYMVqPHG90Vt3RW37VFxMxbBXW4aV74AJMkxdL6x03Ck2Ig1Lt4eY2c/MAriaa
	 8Xh1jS2Kb5a6vk29fAl0t/373sfMdTzUsJ84fUa7IzkHzP9/Ve/XcAppuC05q/Qx6T
	 +0rOGNLF4s7WaaESrx7f1P7IvZgj4yoyh1xb2B/HutoSOWPdyZOSF3W8AvmUcjYLuN
	 e464nDTm7oUbL7BLrp0rsVaKB+1jVA6LGyn9kg3Pn/qFmCiw4UKEELR085GrkCgMEI
	 6Zd5Y/wsdML+INbbsaYkFu0RjMuHwAvtegA7kTWnaj6YlGI3Wb/55kZkKEMt9zdpRL
	 EFn6rCzcTwqaA==
Date: Wed, 22 Oct 2025 17:12:04 -0700
Subject: [PATCH 25/26] xfs_scrub: report media scrub failures to the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747936.1028044.6279161516965244247.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the media scan finds that media have been lost, report this to the
kernel so that the healthmon code can pass that along to xfs_healer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index abf6f9713f1a4d..345a461af0d9e2 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -673,6 +673,29 @@ clean_pool(
 	return ret;
 }
 
+static void
+report_ioerr_to_kernel(
+	struct scrub_ctx		*ctx,
+	struct disk			*disk,
+	uint64_t			start,
+	uint64_t			length)
+{
+	struct xfs_media_error		me = {
+		.daddr			= start,
+		.bbcount		= length,
+	};
+	dev_t				dev = disk_to_dev(ctx, disk);
+
+	if (dev == ctx->fsinfo.fs_datadev)
+		me.flags |= XFS_MEDIA_ERROR_DATADEV;
+	else if (dev == ctx->fsinfo.fs_rtdev)
+		me.flags |= XFS_MEDIA_ERROR_RTDEV;
+	else if (dev == ctx->fsinfo.fs_logdev)
+		me.flags |= XFS_MEDIA_ERROR_LOGDEV;
+
+	ioctl(ctx->mnt.fd, XFS_IOC_MEDIA_ERROR, &me);
+}
+
 /* Remember a media error for later. */
 static void
 remember_ioerr(
@@ -697,6 +720,8 @@ remember_ioerr(
 		return;
 	}
 
+	report_ioerr_to_kernel(ctx, disk, start, length);
+
 	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree) {
 		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));

