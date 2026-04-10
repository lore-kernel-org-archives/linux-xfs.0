Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF52F9C37
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775802062; cv=none; b=JyuXZ8pSXNIJJtqWClhggVi9QRIPVQgwEyqjdxvFnjK+y/YTFCJvikRVMVGWm2LyFCnGrDWe3ZEECprXBdT1x1XDBOQ98PSmvjGXXVCld1p3x5ejsXIJ2GSvD91+gZT1rGYUTX/ZXJaWMn5SqW4a9Jq6x7Bg1thw6hlYNSQ60xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775802062; c=relaxed/simple;
	bh=HC4i6vsp6JgsAD3105mVqEf0TtJ1HQmjoco4cxXOCZQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C81cFyvc+uCLZ1vMstQOzhUtcRUlKOZDGJtK3KDEhYzTba/AaStiAGBxXy9L6q37WeZxuAFyk1DQRolDaeqIJ6Mm5imbU19cGX24ik6VEj9EVRWI5KwkK7oCOFR3VO01RQUPe4XUB9ehytEhsbU0IvB2Wp8OKvoSnHUB3CqMdiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6CoNxbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6CoNxbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3F3C19421;
	Fri, 10 Apr 2026 06:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775802061;
	bh=HC4i6vsp6JgsAD3105mVqEf0TtJ1HQmjoco4cxXOCZQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G6CoNxbWrB1AZ4pDNRu9tUwabDtDNSuE0H5tiFE6Y2BrX9V1i4M+zUqGDGRIVN3vV
	 nvitZ1tYTyVm+D/1uup2arOHD9wdP4DzFzcytM2mNlUg1oUP+0COphn/bn5x6YOV0q
	 saBxtgWbKZY5ST8HGvA3EpZdR7VwxnbR/mfl7CMThBXWzI4AvXXIA1eap5UhnJWSK+
	 rinATs6GltdVQTKIMt5sBgXRaaH5Y07paKfZPtDPSXt+WkjuwUaUytKj0xCZgb/4PI
	 /ESPjuwVAYKQ8lBE10B7Y6DHUYPJbmV2JO+Jf6JwqVAcFU7IhxIQXY71wuMbc9JsjN
	 ALpr3pRQ7SPjA==
Date: Thu, 09 Apr 2026 23:21:01 -0700
Subject: [PATCH 14/21] xfs_scrub: use the verify media ioctl during phase 6 if
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577385290.2090237.12789123647047351078.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

If the kernel suppots the XFS_IOC_VERIFY_MEDIA ioctl, use that to
perform the phase 6 media scan instead of pwrite or the SCSI VERIFY
command.  This enables better integration with xfs_healer and fsnotify;
and reduces the amount of work that userspace has to do.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub.h   |    1 +
 scrub/phase1.c      |   18 ++++++++++++++++++
 scrub/read_verify.c |   44 ++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 59 insertions(+), 4 deletions(-)


diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 3009a7cd2d97d0..851b4f37db48e4 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -79,6 +79,7 @@ struct scrub_ctx {
 
 	/* Data block read verification buffer */
 	void			*readbuf;
+	bool			no_verify_ioctl;
 
 	/* Mutable scrub state; use lock. */
 	pthread_mutex_t		lock;
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 16607af4c5f025..abc594898bf2c5 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -213,6 +213,22 @@ mode_from_autofsck(
 	goto summarize;
 }
 
+/* Does the XFS driver support media scanning its own disks? */
+static void
+configure_xfs_verify(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_verify_media	me = {
+		/* just probe for support using an empty range */
+		.me_start_daddr	= 0,
+		.me_end_daddr	= 0,
+		.me_dev		= XFS_DEV_DATA,
+	};
+
+	if (ioctl(ctx->mnt.fd, XFS_IOC_VERIFY_MEDIA, &me))
+		ctx->no_verify_ioctl = true;
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -379,6 +395,8 @@ _("Unable to find realtime device path."));
 		}
 	}
 
+	configure_xfs_verify(ctx);
+
 	/*
 	 * Everything's set up, which means any failures recorded after
 	 * this point are most probably corruption errors (as opposed to
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 3b3baaf8980c4e..66086d6fe2d56d 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -225,12 +225,45 @@ verify_simulate_read_error(
 	return 0;
 }
 
+/* Use the XFS media verification ioctl to do the media scan */
+static ssize_t
+ioctl_verify(
+	int			verify_fd,
+	enum xfs_device		dev,
+	uint64_t		start,
+	uint64_t		length,
+	bool			single_step)
+{
+	const uint64_t	orig_start_daddr = BTOBBT(start);
+	struct xfs_verify_media	me = {
+		.me_start_daddr	= orig_start_daddr,
+		.me_end_daddr	= BTOBB(start + length),
+		.me_dev		= dev,
+		.me_rest_us	= bg_mode > 2 ? bg_mode - 1 : 0,
+	};
+	int			ret;
+
+	if (single_step)
+		me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
+
+	ret = ioctl(verify_fd, XFS_IOC_VERIFY_MEDIA, &me);
+	if (ret < 0)
+		return ret;
+	if (me.me_ioerror) {
+		errno = me.me_ioerror;
+		return -1;
+	}
+
+	return BBTOB(me.me_start_daddr - orig_start_daddr);
+}
+
 /* Read-verify an extent of a disk device. */
 static ssize_t
 read_verify_one(
 	struct read_verify_pool	*rvp,
 	struct read_verify	*rv,
-	ssize_t			len)
+	ssize_t			len,
+	bool			single_step)
 {
 	if (debug) {
 		int		ret;
@@ -246,8 +279,11 @@ read_verify_one(
 			return len;
 	}
 
-	return disk_read_verify(rvp->ctx->verify_disks[rvp->dev], rvp->readbuf,
-			rv->io_start, len);
+	if (rvp->ctx->no_verify_ioctl)
+		return disk_read_verify(rvp->ctx->verify_disks[rvp->dev],
+				rvp->readbuf, rv->io_start, len);
+	return ioctl_verify(rvp->ctx->mnt.fd, rvp->dev, rv->io_start, len,
+			single_step);
 }
 
 /*
@@ -279,7 +315,7 @@ read_verify(
 		len = min(rv->io_length, io_max_size);
 		dbg_printf("diskverify %u %"PRIu64" %zu\n", rvp->dev,
 				rv->io_start, len);
-		sz = read_verify_one(rvp, rv, len);
+		sz = read_verify_one(rvp, rv, len, io_max_size <= rvp->miniosz);
 		if (sz == len && io_max_size < rvp->miniosz) {
 			/*
 			 * If the verify request was 100% successful and less

