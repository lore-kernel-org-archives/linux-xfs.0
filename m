Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7022071
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053363; cv=none; b=qiSdjMcE62u+zqRLobQOFDQTYfxzpk+uOZDDUK306jWvqcF43vpQoQXDUNnDE8DzGXBTLd2Jy4HO6CSjhI+HBOcdLcXjc0RlzD8F0OW/N+QnsGNPuEpV04JuHQNgvcO15g3cwf0Ocjdu/ZZkFGYibdw2r/bJmPUXOJu4I7cb8xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053363; c=relaxed/simple;
	bh=zuZpHkqboysASAemrWVpwKx/+YapZ8jcK6MSaSAzO2o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZereDeD2CgbhRokDP74hT1KV2SZP/5AHg+S45Vf+OlrDWtL1JOzukTS1Ucvtd/vbS2WU78wsi4/7rRXoJXOBD3DrZb9YRPB4+6oPrX+lI968TSoPPvHCAXQfVB0ONfZiNeDGn5dYg7/1TxYA3BIZXBBpIJP7CuHrlsMXC37tuE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIGE70Xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIGE70Xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FCC4CED3;
	Fri, 13 Dec 2024 01:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053363;
	bh=zuZpHkqboysASAemrWVpwKx/+YapZ8jcK6MSaSAzO2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NIGE70Xbsdz0qgFOxVcfK5tehqmM7F1ZAgOXrV6dIrtqJ0zQ72DXxPG/wz+IS5suu
	 sh6bFpiD6AWINZ5WnZWrSi+0FbLHSBY+W275x+NwoxVNhwXd0G8JewQtGUhx2wIkYF
	 /BliivzfnQruhUoJy30YO/87Z+RWC6PVRRlE0747BvWzsS84fGGWZimMVOdwVETsoX
	 V9aKC+WwAN9gPDO4K1Oya61bhI7GqfI8VZNT5SoDQQkRvHAtOU3x5d/O59qddaicGM
	 JhK9atJyiLXjgXfi2MQcGb8WI9u4jS062NKGJbyRrICQbZsH/uCD/6WOv0YhdLSXZQ
	 phowD5MAZEIOQ==
Date: Thu, 12 Dec 2024 17:29:22 -0800
Subject: [PATCH 35/50] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405323720.1228937.8741858826144010013.stgit@frogsfrogsfrogs>
In-Reply-To: <173405323136.1228937.15295934936342173452.stgit@frogsfrogsfrogs>
References: <173405323136.1228937.15295934936342173452.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support restoring realtime device metadata to the realtime device, if
the dumped filesystem had one.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_mdrestore.8  |   10 ++++++++++
 mdrestore/xfs_mdrestore.c |   47 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 9 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index f60e7b56ebf0d1..6f6e14e96c6a5c 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -8,6 +8,9 @@ .SH SYNOPSIS
 ] [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .I target
@@ -17,6 +20,9 @@ .SH SYNOPSIS
 [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .br
@@ -61,6 +67,10 @@ .SH OPTIONS
 In such a scenario, the user has to provide a device to which the log device
 contents from the metadump file are copied.
 .TP
+.BI \-r " rtdev"
+Restore realtime device metadata to this device.
+This is only required for a metadump in v2 format.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c5584fec68813e..d5014981b15a68 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -28,7 +28,8 @@ struct mdrestore_ops {
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
 			const struct mdrestore_dev *ddev,
-			const struct mdrestore_dev *logdev);
+			const struct mdrestore_dev *logdev,
+			const struct mdrestore_dev *rtdev);
 };
 
 static struct mdrestore {
@@ -37,6 +38,7 @@ static struct mdrestore {
 	bool			show_info;
 	bool			progress_since_warning;
 	bool			external_log;
+	bool			realtime_data;
 } mdrestore;
 
 static void
@@ -212,7 +214,8 @@ restore_v1(
 	union mdrestore_headers		*h,
 	FILE				*md_fp,
 	const struct mdrestore_dev	*ddev,
-	const struct mdrestore_dev	*logdev)
+	const struct mdrestore_dev	*logdev,
+	const struct mdrestore_dev	*rtdev)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -336,8 +339,9 @@ read_header_v2(
 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
 
-	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
-		fatal("Realtime device not yet supported\n");
+	if ((h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE)) &&
+	    !mdrestore.realtime_data)
+		fatal("Realtime device is required\n");
 }
 
 static void
@@ -346,14 +350,17 @@ show_info_v2(
 	const char		*md_file)
 {
 	uint32_t		compat_flags;
+	uint32_t		incompat_flags;
 
 	compat_flags = be32_to_cpu(h->v2.xmh_compat_flags);
+	incompat_flags = be32_to_cpu(h->v2.xmh_incompat_flags);
 
-	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, rt device contents are %sdumped, %s metadata blocks,\n",
 		md_file,
 		compat_flags & XFS_MD2_COMPAT_OBFUSCATED ? "":"not ",
 		compat_flags & XFS_MD2_COMPAT_DIRTYLOG ? "dirty":"clean",
 		compat_flags & XFS_MD2_COMPAT_EXTERNALLOG ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_RTDEVICE ? "":"not ",
 		compat_flags & XFS_MD2_COMPAT_FULLBLOCKS ? "full":"zeroed");
 }
 
@@ -390,7 +397,8 @@ restore_v2(
 	union mdrestore_headers		*h,
 	FILE				*md_fp,
 	const struct mdrestore_dev	*ddev,
-	const struct mdrestore_dev	*logdev)
+	const struct mdrestore_dev	*logdev,
+	const struct mdrestore_dev	*rtdev)
 {
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
@@ -431,6 +439,11 @@ restore_v2(
 		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
 	}
 
+	if (sb.sb_rblocks > 0) {
+		ASSERT(mdrestore.realtime_data == true);
+		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
+	}
+
 	if (pwrite(ddev->fd, block_buffer, len, 0) < 0)
 		fatal("error writing primary superblock: %s\n",
 			strerror(errno));
@@ -459,6 +472,10 @@ restore_v2(
 			device = "log";
 			fd = logdev->fd;
 			break;
+		case XME_ADDR_RT_DEVICE:
+			device = "rt";
+			fd = rtdev->fd;
+			break;
 		default:
 			fatal("Invalid device found in metadump\n");
 			break;
@@ -488,7 +505,7 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-r rtdev] source target\n",
 		progname);
 	exit(1);
 }
@@ -501,18 +518,21 @@ main(
 	union mdrestore_headers	headers;
 	DEFINE_MDRESTORE_DEV(ddev);
 	DEFINE_MDRESTORE_DEV(logdev);
+	DEFINE_MDRESTORE_DEV(rtdev);
 	FILE			*src_f;
 	char			*logdev_path = NULL;
+	char			*rtdev_path = NULL;
 	int			c;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
 	mdrestore.external_log = false;
+	mdrestore.realtime_data = false;
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:r:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -524,6 +544,10 @@ main(
 				logdev_path = optarg;
 				mdrestore.external_log = true;
 				break;
+			case 'r':
+				rtdev_path = optarg;
+				mdrestore.realtime_data = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -592,10 +616,15 @@ main(
 	if (mdrestore.external_log)
 		open_device(&logdev, logdev_path);
 
-	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev);
+	/* check and open realtime device */
+	if (mdrestore.realtime_data)
+		open_device(&rtdev, rtdev_path);
+
+	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev, &rtdev);
 
 	close_device(&ddev);
 	close_device(&logdev);
+	close_device(&rtdev);
 
 	if (src_f != stdin)
 		fclose(src_f);

