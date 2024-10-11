Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D4417597
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610327; cv=none; b=tcrYkR4pRBad3L9Ss+7WluKCx9QuP/kii3VxxYROQqlZaJiz6CrR/qZ4xpzjIHB+MChtP6in9NZV/Db+kf7N3dcyibfqpGX9NG8ms4ZVEdgVRwlN1LJPTFc6hleHKTZjynanotVVYkot9vLBXxziLWzSUT5BjFtpLeGWk4pfINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610327; c=relaxed/simple;
	bh=EN6X+QW7EzUejufxo29p3grc3h+KbqkLFr9EzbnewNI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HN1jqH5NyVfJgyVjVIK6Zb5GBh2qtWEqSlgwMS35hZKWp98l2L4TYnp9DjuYoqRhW25lfAoDRYmIu33/PdVFkPkST2/nijxSSUlSO540titEgAW2GgqD2ggNv8M0H0QRShwGyMQ20Y3qnh06dqjnYVqnDa61zSkc6kuPPoKX6SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z/zvs+5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z/zvs+5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BC9C4CEC5;
	Fri, 11 Oct 2024 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610327;
	bh=EN6X+QW7EzUejufxo29p3grc3h+KbqkLFr9EzbnewNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z/zvs+5/oV5uo5L74mv88XnqKIbprISVNToBpIyvLW4Bkryla5tcdfCpWqMJoFMFC
	 /5IGLD2wZ5zbS7LD1KH1fkjjmq+2CBLQAW6lOz3g60J2wsDFz9m+boNN89Zx96Pauz
	 jVBdnQuV8N7zxsj2VaW9rD4onY1n8tCfcItyFikBf14wxFG3Hjoy0XSfqrRjKQ1QWN
	 EYIfbI930wU9S62mq9iIt3iNVwFNLYNSnaa0mLaiX8cl15eOylpP+OfJlLxZ+6EYAB
	 GdZ6L7QQtHjnScfq4+6quuea5ZcpPFE0kX68Qcs/QAE91i61qy0qjau0IrOr1f9+FP
	 VNe0UvsS7xyuw==
Date: Thu, 10 Oct 2024 18:32:07 -0700
Subject: [PATCH 29/43] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655810.4184637.16840738761431805099.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

