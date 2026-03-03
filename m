Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5A91A6810
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498343; cv=none; b=CFdUffzLvkMbB2HGa6fezbAkTZNDXTVarszdvYfsyqaoYaSrcYx9RSIbXrugUnbRhMZKCqQZm6saPk9fbuJaQ4kM7h7rTMk83DNumlTK9fqINde7R4BgdDbTTZww3yYKwL93G/FlZ+qOL5gscumHgN9SUUvli/Qb4Tf89FYWHmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498343; c=relaxed/simple;
	bh=RVpCCRMJCRMeC858ijUiUGpaD2XabKKIioa4+pFMCw0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usUTFHfj7ozXJ8FxCV1AARoBxPt4Yks+vFUqBdbAhX72LGYH1qTl62KXVwN46hsw2kEmSRzlV9sdzQ9xo6UYw/GOOoXH3a9lEvqmbZRyN6RWV4HSYpFmntPDFxZ8XZfkMJv9YEfAMbfti6PEdRJmhpgJ/fOJA1/NG9NCaoZ/oFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAH2fMUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAH2fMUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B62EC19423;
	Tue,  3 Mar 2026 00:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498343;
	bh=RVpCCRMJCRMeC858ijUiUGpaD2XabKKIioa4+pFMCw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aAH2fMUVF4K6Ic5Pz8pKpm9dQFpiG4TKBfvPstXbLSHszG26067P+VPGOM4vCPZIf
	 AfSdwwAw9tR2NuPhni1QoKjLv8xkuAkLcE2CnFvvIh0Wks0kGrxuZBtwZJwL9ipahU
	 qacrnKQK3YhmuXb1k3K7MEoW2LteNk1u7NFmHRl6h1M9voEiU/QNUHa7p9yTUPhgcH
	 l+lE+2bEVDOvl0l4g2YJg586ltZCq0UCJddhTh2qmA+WwsnzkhxQ6XDXGc9nw98MbK
	 SOaZQy9/QVzWemkQuUHv1S31MsiWsTrmW6G+RnquF2ubOUQRxm4QClZBW6r33AsSQA
	 WeeKvVxdujojw==
Date: Mon, 02 Mar 2026 16:39:02 -0800
Subject: [PATCH 20/26] xfs_scrub: use the verify media ioctl during phase 6 if
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783656.482027.946865669068210433.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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
---
 scrub/disk.h        |   11 ++++++++++-
 scrub/disk.c        |   40 +++++++++++++++++++++++++++++++++++++++-
 scrub/phase1.c      |   25 +++++++++++++++++++++++++
 scrub/read_verify.c |    2 +-
 4 files changed, 75 insertions(+), 3 deletions(-)


diff --git a/scrub/disk.h b/scrub/disk.h
index 73c73ab57fb5c7..2ae27b73839ad3 100644
--- a/scrub/disk.h
+++ b/scrub/disk.h
@@ -10,18 +10,27 @@
 struct disk {
 	struct stat	d_sb;
 	int		d_fd;
+	int		d_verify_fd;
 	unsigned int	d_lbalog;
 	unsigned int	d_lbasize;	/* bytes */
 	unsigned int	d_flags;
 	unsigned int	d_blksize;	/* bytes */
 	uint64_t	d_size;		/* bytes */
 	uint64_t	d_start;	/* bytes */
+	unsigned int	d_verify_disk;
 };
 
 unsigned int disk_heads(struct disk *disk);
 struct disk *disk_open(const char *pathname);
 int disk_close(struct disk *disk);
 ssize_t disk_read_verify(struct disk *disk, void *buf, uint64_t startblock,
-		uint64_t blockcount);
+		uint64_t blockcount, bool single_step);
+
+static inline void
+disk_config_xfs_verify(struct disk *disk, int mnt_fd, unsigned int verify_disk)
+{
+	disk->d_verify_fd = mnt_fd;
+	disk->d_verify_disk = verify_disk;
+}
 
 #endif /* XFS_SCRUB_DISK_H_ */
diff --git a/scrub/disk.c b/scrub/disk.c
index 2cf84d91887587..4e78bd1cebbdc8 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -190,6 +190,7 @@ disk_open(
 	disk = calloc(1, sizeof(struct disk));
 	if (!disk)
 		return NULL;
+	disk->d_verify_fd = -1;
 
 	disk->d_fd = open(pathname, O_RDONLY | O_DIRECT | O_NOATIME);
 	if (disk->d_fd < 0)
@@ -266,6 +267,18 @@ disk_close(
 #define LBASIZE(d)		(1ULL << (d)->d_lbalog)
 #define BTOLBA(d, bytes)	(((uint64_t)(bytes) + LBASIZE(d) - 1) >> (d)->d_lbalog)
 
+#ifndef BTOBB
+# define BTOBB(bytes)		((uint64_t)((bytes) + 511) >> 9)
+#endif
+
+#ifndef BTOBBT
+# define BTOBBT(bytes)		((uint64_t)(bytes) >> 9)
+#endif
+
+#ifndef BBTOB
+# define BBTOB(bytes)		((uint64_t)(bytes) << 9)
+#endif
+
 /* Simulate disk errors. */
 static int
 disk_simulate_read_error(
@@ -329,7 +342,8 @@ disk_read_verify(
 	struct disk		*disk,
 	void			*buf,
 	uint64_t		start,
-	uint64_t		length)
+	uint64_t		length,
+	bool			single_step)
 {
 	if (debug) {
 		int		ret;
@@ -345,6 +359,30 @@ disk_read_verify(
 			return length;
 	}
 
+	if (disk->d_verify_fd >= 0) {
+		const uint64_t	orig_start_daddr = BTOBBT(start);
+		struct xfs_verify_media me = {
+			.me_start_daddr	= orig_start_daddr,
+			.me_end_daddr	= BTOBB(start + length),
+			.me_dev		= disk->d_verify_disk,
+			.me_rest_us	= bg_mode > 2 ? bg_mode - 1 : 0,
+		};
+		int		ret;
+
+		if (single_step)
+			me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
+
+		ret = ioctl(disk->d_verify_fd, XFS_IOC_VERIFY_MEDIA, &me);
+		if (ret < 0)
+			return ret;
+		if (me.me_ioerror) {
+			errno = me.me_ioerror;
+			return -1;
+		}
+
+		return BBTOB(me.me_start_daddr - orig_start_daddr);
+	}
+
 	/* Convert to logical block size. */
 	if (disk->d_flags & DISK_FLAG_SCSI_VERIFY)
 		return disk_scsi_verify(disk, BTOLBAT(disk, start),
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 10e9aa1892b701..093e7a01b9542f 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -213,6 +213,29 @@ mode_from_autofsck(
 	goto summarize;
 }
 
+/* Does the XFS driver support media scanning its own disks? */
+static void
+configure_xfs_verify(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_verify_media	me = {
+		.me_start_daddr	= 1,
+		.me_end_daddr	= 0,
+		.me_dev		= XFS_DEV_DATA,
+	};
+	int			ret;
+
+	ret = ioctl(ctx->mnt.fd, XFS_IOC_VERIFY_MEDIA, &me);
+	if (ret < 0)
+		return;
+
+	disk_config_xfs_verify(ctx->datadev, ctx->mnt.fd, XFS_DEV_DATA);
+	if (ctx->logdev)
+		disk_config_xfs_verify(ctx->logdev, ctx->mnt.fd, XFS_DEV_LOG);
+	if (ctx->rtdev)
+		disk_config_xfs_verify(ctx->rtdev, ctx->mnt.fd, XFS_DEV_RT);
+}
+
 /*
  * Bind to the mountpoint, read the XFS geometry, bind to the block devices.
  * Anything we've already built will be cleaned up by scrub_cleanup.
@@ -379,6 +402,8 @@ _("Unable to find realtime device path."));
 		}
 	}
 
+	configure_xfs_verify(ctx);
+
 	/*
 	 * Everything's set up, which means any failures recorded after
 	 * this point are most probably corruption errors (as opposed to
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 1219efe2590182..9e1f3ec0ed1186 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -201,7 +201,7 @@ read_verify(
 		dbg_printf("diskverify %d %"PRIu64" %zu\n", rvp->disk->d_fd,
 				rv->io_start, len);
 		sz = disk_read_verify(rvp->disk, rvp->readbuf, rv->io_start,
-				len);
+				len, io_max_size <= rvp->miniosz);
 		if (sz == len && io_max_size < rvp->miniosz) {
 			/*
 			 * If the verify request was 100% successful and less

