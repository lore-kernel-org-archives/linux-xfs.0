Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85962CA6
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530461; cv=none; b=J/R5FeKGRvD2KjlvGqzcGfP8McZUfyVY5vtPc9I4KhoHXo+DaacyAu1AlXgyU5ysa0oB5J4tiAKIdYivYBxONkVsjfziSN9K6CRqGY2q3LQf7EEMz66J5Pn73j5PcuL3QkbPvaUWRq7eeR6Ak7PBvNvrOmcxPc7O5aa0M+nJe20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530461; c=relaxed/simple;
	bh=+sl1kmIZv+bgkP6TtSU+wnOmA94Yzgk/n4Ipu5Tz9zw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChHwEsO6ClsXXleG0Bw4hyNq51lPlYOLUgO0a2ck9Hd5lcguE6+vULr1N/9x7Rb+4AN9UA1wM2n2uIRxpXaPbMxipHfbl0wACZcj0ySKKq+fGmG0UskC220h49r+guhsJdmYGIlErQpEWUZ0XLkBs0bE1CZh2bYWj4psHX+H6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZqDlXW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZqDlXW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E370C4CED1;
	Sat,  7 Dec 2024 00:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530461;
	bh=+sl1kmIZv+bgkP6TtSU+wnOmA94Yzgk/n4Ipu5Tz9zw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XZqDlXW6dOSDUXb3qsEVBP/6BZnCDXgLZ7+0J07J3TSo/BymDd0X0+pY7FcWrwkJF
	 ycThbF2poFkEjUaM9wEgmgC4JrKUwDUyXZ8HpKxSDBJ5eAB2WSKn3gNtiuRAkjxh28
	 3f0qRUvr/GavovkV1SnMTZe2L/GcAIbBMgtOSZz0KyXrJiMcwvBUJT6WUhs6Y5adO7
	 P8/2t4oOhv2aF0R1pRlLlEtO+LQw8WRGP0ysY5EdPSOIqCvJi1RHrQ917+cb0Slae2
	 dx/NUTOsus1fPM/6xm0LNva6B6ph2mXy7DCKoUSd1u6Yxi8fAOOkd+rWhM6/atKQEr
	 MMx2sh1QQEA8A==
Date: Fri, 06 Dec 2024 16:14:20 -0800
Subject: [PATCH 36/50] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752495.126362.8968721228760590908.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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
 man/man8/xfs_mdrestore.8  |   10 ++++++++
 mdrestore/xfs_mdrestore.c |   58 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 11 deletions(-)


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
index c6c00270234442..9bc99f5cb82611 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -19,8 +19,9 @@ struct mdrestore_ops {
 	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
-			int ddev_fd, bool is_data_target_file, int logdev_fd,
-			bool is_log_target_file);
+			int ddev_fd, bool is_data_target_file,
+			int logdev_fd, bool is_log_target_file,
+			int rtdev_fd, bool is_rt_target_file);
 };
 
 static struct mdrestore {
@@ -29,6 +30,7 @@ static struct mdrestore {
 	bool			show_info;
 	bool			progress_since_warning;
 	bool			external_log;
+	bool			realtime_data;
 } mdrestore;
 
 static void
@@ -200,7 +202,9 @@ restore_v1(
 	int			ddev_fd,
 	bool			is_data_target_file,
 	int			logdev_fd,
-	bool			is_log_target_file)
+	bool			is_log_target_file,
+	int			rtdev_fd,
+	bool			is_rt_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -325,8 +329,9 @@ read_header_v2(
 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
 
-	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
-		fatal("Realtime device not yet supported\n");
+	if ((h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE)) &&
+	    !mdrestore.realtime_data)
+		fatal("Realtime device is required\n");
 }
 
 static void
@@ -335,14 +340,17 @@ show_info_v2(
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
 
@@ -381,7 +389,9 @@ restore_v2(
 	int			ddev_fd,
 	bool			is_data_target_file,
 	int			logdev_fd,
-	bool			is_log_target_file)
+	bool			is_log_target_file,
+	int			rtdev_fd,
+	bool			is_rt_target_file)
 {
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
@@ -424,6 +434,12 @@ restore_v2(
 				sb.sb_blocksize);
 	}
 
+	if (sb.sb_rblocks > 0) {
+		ASSERT(mdrestore.realtime_data == true);
+		verify_device_size(rtdev_fd, is_rt_target_file, sb.sb_rblocks,
+				sb.sb_blocksize);
+	}
+
 	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
 		fatal("error writing primary superblock: %s\n",
 			strerror(errno));
@@ -452,6 +468,10 @@ restore_v2(
 			device = "log";
 			fd = logdev_fd;
 			break;
+		case XME_ADDR_RT_DEVICE:
+			device = "rt";
+			fd = rtdev_fd;
+			break;
 		default:
 			fatal("Invalid device found in metadump\n");
 			break;
@@ -481,7 +501,7 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-r rtdev] source target\n",
 		progname);
 	exit(1);
 }
@@ -494,20 +514,24 @@ main(
 	union mdrestore_headers	headers;
 	FILE			*src_f;
 	char			*logdev = NULL;
+	char			*rtdev = NULL;
 	int			data_dev_fd = -1;
 	int			log_dev_fd = -1;
+	int			rt_dev_fd = -1;
 	int			c;
 	bool			is_data_dev_file = false;
 	bool			is_log_dev_file = false;
+	bool			is_rt_dev_file = false;
 
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
@@ -519,6 +543,10 @@ main(
 				logdev = optarg;
 				mdrestore.external_log = true;
 				break;
+			case 'r':
+				rtdev = optarg;
+				mdrestore.realtime_data = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -587,12 +615,20 @@ main(
 		/* check and open log device */
 		log_dev_fd = open_device(logdev, &is_log_dev_file);
 
-	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
-			is_data_dev_file, log_dev_fd, is_log_dev_file);
+	if (mdrestore.realtime_data)
+		/* check and open realtime device */
+		rt_dev_fd = open_device(rtdev, &is_rt_dev_file);
+
+	mdrestore.mdrops->restore(&headers, src_f,
+			data_dev_fd, is_data_dev_file,
+			log_dev_fd, is_log_dev_file,
+			rt_dev_fd, is_rt_dev_file);
 
 	close(data_dev_fd);
 	if (mdrestore.external_log)
 		close(log_dev_fd);
+	if (mdrestore.realtime_data)
+		close(rt_dev_fd);
 
 	if (src_f != stdin)
 		fclose(src_f);

