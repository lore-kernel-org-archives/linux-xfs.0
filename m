Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC37C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjnsTRPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0CEC433C8;
	Sun, 31 Dec 2023 23:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067064;
	bh=vnnC34QRKyKqQZGbS3M+9+hfFXV61999NFwohwMQWI4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HjnsTRPOXv3qU1kPlw6nbJaVA5tJOLQ4pdeLpNqHMCvgMHh/Q/NXG0OHd6EiU0rKu
	 xSmyQlvCl4f6nvaYqOWOdhp0kT49wLvJJoBaz7vEuh/xLQBBsnB/TFdWcV9agB7vfz
	 J/+XAHphD37mX4Sgx5EWL2Ql+ES23hoc9o5JwdJmOe+v6pNqC+yvnFpkHjqV35IGSP
	 2ag19evRDk6HdfWPBlycht5BYw7wsDrTF2AL928G8nsUZ1BK3O7tlGuV6+13H5cZ35
	 tFvJoKkHgY5wD1nsne+lxskn9kZuksMS0W8Y6vSiTUmzo/va+d7rG1mJ6jqqO6GyPC
	 js+ClysmVsGMA==
Date: Sun, 31 Dec 2023 15:57:43 -0800
Subject: [PATCH 39/52] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012685.1811243.17632346671268979025.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 man/man8/xfs_mdrestore.8  |   10 +++++++++
 mdrestore/xfs_mdrestore.c |   52 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 51 insertions(+), 11 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index f60e7b56ebf..6f6e14e96c6 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -8,6 +8,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 ] [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .I target
@@ -17,6 +20,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .br
@@ -61,6 +67,10 @@ Metadump in v2 format can contain metadata dumped from an external log.
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
index e0572b31e2c..07dcc21cc45 100644
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
@@ -452,6 +462,10 @@ restore_v2(
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
@@ -481,7 +495,7 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-r rtdev] source target\n",
 		progname);
 	exit(1);
 }
@@ -494,20 +508,24 @@ main(
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
@@ -519,6 +537,10 @@ main(
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
@@ -587,12 +609,20 @@ main(
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

