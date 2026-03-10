Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533981547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114499; cv=none; b=gAYV7G2oBdpfQBrc7njhWwoW18Mb0qYQTer6Xr5PmkOoxN8end1IlTsJT2+VAN/OJruTwZSda7kBo+e9X1deAc4WUl8PxrXAfiv3KvZFQz+DWJ6FMP4tuNtnn6oUec3XdbAf/vzPgujDjM9EATkqzkR8fqYr7B17wWR/suXupX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114499; c=relaxed/simple;
	bh=+uj/HlqNtotowCW/Hdh8OELMGJL8rYp9d8Tsq5npesU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cy2dpVonXAaNlkQKkXXpi92KLdOBTzi1Dcl1vzaCrGl0u9HF8dZidpWrNJkwQo3oqBaWzZqJC6AsYX1jJpEBy24rNNMIyiFY9rGqcDsaP++7WdnA6+grT/eYD6PGRZTEFK+MwOzHj7wHmVLFI6sWIxEaZUPCPKMVtO6Tef2oMiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=esa+RxJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="esa+RxJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B2C19423;
	Tue, 10 Mar 2026 03:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114499;
	bh=+uj/HlqNtotowCW/Hdh8OELMGJL8rYp9d8Tsq5npesU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=esa+RxJDnc0IlHcZn5J1iJtS1+5GIeZl4sCFgHXAEwFvkOYr5DditmC/uzwNSj9aD
	 JUOmT2yKrbf44QIZ0UhxymAnxhp1u3AOH+q3EmmgfA19ugrH+bRjRWHB1d/oaHHaMG
	 HxanrLYzVHiF5kJVyrYFabU1r4UC+eCeCcbfDlbijr3A3ZEotzN88VkI5glg1HNy5p
	 tgJ6BEqtw09VAayVk2wK58Gs8P//CEWSNVnN9tqE4Ccwffqdx760d4c0hr4jMHc+Ky
	 gkKRouZjrYiPy5bF2nb+1LsEXbUNLeCPNhHRQO3yilMOslDJ09hjbsVSDPEsgS+6gz
	 bTwMj//J2Rv1w==
Date: Mon, 09 Mar 2026 20:48:18 -0700
Subject: [PATCH 22/28] xfs_scrub: use the verify media ioctl during phase 6 if
 possible
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401861.1183235.9677228337197848690.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
 scrub/disk.c        |   38 +++++++++++++++++++++++++++++++++++++-
 scrub/phase1.c      |   25 +++++++++++++++++++++++++
 scrub/read_verify.c |    2 +-
 4 files changed, 73 insertions(+), 3 deletions(-)


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
index 2cf84d91887587..5c20fbb0f2181b 100644
--- a/scrub/disk.c
+++ b/scrub/disk.c
@@ -190,6 +190,7 @@ disk_open(
 	disk = calloc(1, sizeof(struct disk));
 	if (!disk)
 		return NULL;
+	disk->d_verify_fd = -1;
 
 	disk->d_fd = open(pathname, O_RDONLY | O_DIRECT | O_NOATIME);
 	if (disk->d_fd < 0)
@@ -323,13 +324,45 @@ disk_simulate_read_error(
 	return 0;
 }
 
+/* Use the XFS media verification ioctl to do the media scan */
+static ssize_t
+disk_ioctl_verify(
+	struct disk		*disk,
+	uint64_t		start,
+	uint64_t		length,
+	bool			single_step)
+{
+	const uint64_t	orig_start_daddr = BTOBBT(start);
+	struct xfs_verify_media	me = {
+		.me_start_daddr	= orig_start_daddr,
+		.me_end_daddr	= BTOBB(start + length),
+		.me_dev		= disk->d_verify_disk,
+		.me_rest_us	= bg_mode > 2 ? bg_mode - 1 : 0,
+	};
+	int			ret;
+
+	if (single_step)
+		me.me_flags |= XFS_VERIFY_MEDIA_REPORT;
+
+	ret = ioctl(disk->d_verify_fd, XFS_IOC_VERIFY_MEDIA, &me);
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
 ssize_t
 disk_read_verify(
 	struct disk		*disk,
 	void			*buf,
 	uint64_t		start,
-	uint64_t		length)
+	uint64_t		length,
+	bool			single_step)
 {
 	if (debug) {
 		int		ret;
@@ -345,6 +378,9 @@ disk_read_verify(
 			return length;
 	}
 
+	if (disk->d_verify_fd >= 0)
+		return disk_ioctl_verify(disk, start, length, single_step);
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

