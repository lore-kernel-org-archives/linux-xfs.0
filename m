Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E7D29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689176; cv=none; b=EhEOLzGtKQwYGsmNwNNJ4tl8DX5G9Q1yRVrBz7OV+zOGe0O6LGQ4AEOfoYoMyQUJb//1P4ej/Z8GWR5L33q77pbeuN9OyzHVCYFdKdg4gTSPCi3UFuQhVMIupJfan9YfEnt1FVmiaqEilU9+Xrsr0uT3CWDB53gukTowXvlBbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689176; c=relaxed/simple;
	bh=VV+8OewEmIhVwlRjhYNNyFs9CpVvYvYUUNbCIcwhtAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JqOFdfztifL+0IiVyHw0oBZ27LAVqW3NxQFwBtxxuem89JIT0Q2C8DLqvIH69XIF3WoEtWwhn0bob75B0VX2rpGtDvPfgiVY/APJf1oIJTqek6EK7wlP7myXk2yTYwJuzvaEsg5uDtkBQDRx6fZnmKkKzTHqZwuTLPKcK+s27bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKvAACUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKvAACUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEEF0C4CED2;
	Tue, 31 Dec 2024 23:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689175;
	bh=VV+8OewEmIhVwlRjhYNNyFs9CpVvYvYUUNbCIcwhtAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cKvAACUOPC3SCtV1tlN7F1F3QOWQdbiB3MiU5pQQTJYV0Yc+0pqkdqJploHK9h0F8
	 z5yL/YQf04GkcD2cZKFgiUOIZa1YzB9BjFr4MacbzZMWykMEma5dK7SuXK0FGl8B57
	 LtS8iqBfd6A2e1flZlUGhfmWrxQwElYdDHQYV605gGbYiv//U/ReBAOIeo5cZ8M1wi
	 OZYYFg1BdbuiOe/MmQbMjZcqwlFm5Tew52XKfpsgKBbZ80pZ+7lx9rpc3aNAbTHEqb
	 Ns0GP1g4w3yIJId0vQoDFGq1ES9Vdsm4qRjb/CRa7bdSxD4Y7ewidbsVV2wPB9s1NZ
	 N0ns619w8tTgg==
Date: Tue, 31 Dec 2024 15:52:55 -0800
Subject: [PATCH 20/21] xfs_scrub: report media scrub failures to the kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778769.2710211.7691395007928091819.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
kernel so that the healthmon code can pass that along to xfs_scrubbed.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 5a1f29738680e5..b5f6f3c1d4bc63 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -671,6 +671,29 @@ clean_pool(
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
@@ -695,6 +718,8 @@ remember_ioerr(
 		return;
 	}
 
+	report_ioerr_to_kernel(ctx, disk, start, length);
+
 	tree = bitmap_for_disk(ctx, disk, vs);
 	if (!tree) {
 		str_liberror(ctx, ENOENT, _("finding bad block bitmap"));

