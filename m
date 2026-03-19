Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E671F10E3
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895752; cv=none; b=Z5Ljoa7INmB2v5CKUHkIesepzHKF2V5TWHCIzl6FolKOe7OBnWcwvUVKLp6LSjYJIp7/BwcYjP3WLHhkhsBOSqI4o7q5JpgrPyyvuAOXOm6QbhQR5b7O9P9JwmTnEtrVzwLq/Fi4jFVZOHunZSNBob70hFksBLdQgVvjQ78eT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895752; c=relaxed/simple;
	bh=VRrFoO0Z91ABWAhVmFExJqiYDyvLSSbA1167QamRsIU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daisxrMlZOUYubIT+Uq5MohvV3E2WvtG6Az25vc25jfxcpePBej24RjWUyLG1LySlE65eAm5JT96NBo6NKai4PQ2pVsi/dwW0UtESNGFpkMys7pIqwn5wk52oV/u0nIYuVVz2GVh9v0s+yn+A7UnzuQg2AOni+5Ys+40l1umCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqBDjTro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqBDjTro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987B2C19425;
	Thu, 19 Mar 2026 04:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895751;
	bh=VRrFoO0Z91ABWAhVmFExJqiYDyvLSSbA1167QamRsIU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bqBDjTroWrRHdo6cfsowOY0IF8ZU+mkPIrtP0gJxHWWIkAGwzsm5+JfUJGgdvkU0E
	 xUGCMVJRXVu6HQiGEGRkRUZm7kGt5ZO94+yODhpHcodK6Ub2hmSfJJ0th5fhREsp3N
	 UYX8ooG4NRHsIwwqXX7UrLP9elux6mMvTqnxHGnARMYJMEpX+CBTvougTBqNCVUbnz
	 OoDMrBPQI5xZhylAcz5BNARz+U+Y9uz8DLthwsMyejltdWAFmjv/4jN9aGIuuKhUan
	 /LR24nexzOvV1ZhREMmBam88HtYseL03+j8WLSMRHnHv0tpmPmNZJhErDOTgfAViv+
	 2BPrj/PiIZuLw==
Date: Wed, 18 Mar 2026 21:49:11 -0700
Subject: [PATCH 14/22] xfs_scrub: use the verify media ioctl during phase 6 if
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389507197.3681140.12909228499805644066.stgit@frogsfrogsfrogs>
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
index adee67d922fc76..f724dfd693d7ab 100644
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

