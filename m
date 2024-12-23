Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06BD433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992564; cv=none; b=Ael5X5S7Tgq+ac/3mWndfmqudCj/fwMcqLGUmXoi/XzLldykJ05x5B1qJQZmE52WTAVHTeClz7K2cv3pQKEI3mKg+esjGv/ygg3QjDFLkc+BFHOckGcl12Lzmd7Zj7oARhvJ41ivlCs0UKXeAXgPX8AVvkH0hBfxbp1Zi1GDKIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992564; c=relaxed/simple;
	bh=/i2oevIs7Dsjjw+bHUqt9jcSUktc+MEVT+xqbiAtVms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDRJT4YNx39A68wf9eirinLmwk+0xe/JdHfqQ9PwSfNOv4duMdaYV13Wbjl8Tr6ZGeHMjQEW3g3WllNSwMpzMorAHFwSAaE0Z+nHRRrRu6HmPgBr7BaYQM8JW3BaNmavtCy8JXzJZYL0/09dgnLubulGY/0o3fUYk/6TLOA0Tn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCiZ4RZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCiZ4RZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C657EC4CED3;
	Mon, 23 Dec 2024 22:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992563;
	bh=/i2oevIs7Dsjjw+bHUqt9jcSUktc+MEVT+xqbiAtVms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uCiZ4RZzQ4LyL67DpqSEgr9mkBZpwdPhTdVn/N2RwGXcOQsaOc9d+WX56U0NwWm6N
	 fm4xabMpcXmrZ1exMm2gJo7i5fWsxWTdfcHSwVkhP3fOEO8YqFzcxdv4RDaegaCVL5
	 16voAMKhQgZ4zma/d7IC5UvN2TugW6re+AhoTmxXBTioz7hT4+1EPXItPvN0Qv5sns
	 ux99Bo0nq2QtuWGGXy7+LkGgTGI5DHiUKUbqLpZXJhCOCkqLZLXYZ8kzO/AsTUS6M8
	 PHuXJwrcrNYEevjF2YV6lX66WqwPu11KguBmO5TG8v6SX5maXlzG7saWS03EHe92aL
	 4nJL1D6kT9pSA==
Date: Mon, 23 Dec 2024 14:22:43 -0800
Subject: [PATCH 42/51] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944446.2297565.16252646930364155778.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

