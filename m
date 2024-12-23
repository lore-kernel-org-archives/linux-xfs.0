Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368D433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992548; cv=none; b=aIO9EoOW4ORaBtBcMx/0sZkuVapXQo5Iio4xjThrkm/wGxk+YtypWMF2KFNwLIRtSZAqvVqYk9wXDrtBITl8Uo0/7I6JVFvlrOiOf+IRyLlLpgEx84uXAhS5roRJiaYOI1b7G094xtSli9pbIvlvPRE18IMFQVcmIOiDM0u+voM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992548; c=relaxed/simple;
	bh=q/KaSDvUZ/o/920cGcyok1NwzFyqaVd2p/ciQPI6GB8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdqP02xtxnJiFTJQzJzeQxuuBYmnfF1RXQ8nEjv6WaVeDZ2Sjbdi3kweeFq9cKJyqE6/sOs7SaGcPXecyoBwbT3O5/FXPaL43tiSGHckrfYLf/I+KAn3tHSNVYq2H/+hTGNxTpRE++e8MJKilxioM0XVDPyUWABpJPHh8i9ds1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0pRNW0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0pRNW0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB6DC4CED3;
	Mon, 23 Dec 2024 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992548;
	bh=q/KaSDvUZ/o/920cGcyok1NwzFyqaVd2p/ciQPI6GB8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n0pRNW0zgaFidgJ6Uf/SwemDE/WIoaal5id0e+OzXVxceRm1qOpmAMzdVn3gK9/fX
	 RmsvQdMzHNd9ulmGifSipdECipR5aFC3EfMlTKqDHeP12Mr3b56MVLahvySr0g2hHY
	 NSXBHz+xOD/47YAQz/S2fG0c2AzgmfCYFVdDnvrvp7eBzdg+pdRfbC3Gquf5iENiDT
	 X+rzjBlQSl0XhEs4elmYZFymaGHe3jtGPstib+gBFc6Z8mRQEWl/+YHLn4eYuCdsrU
	 mLNALKsDIy56WmsfinsIa4G3UOg3fUZdLGCfvcs/lx+ezSy7G/QilzHv+UPhmGEQIB
	 bBn0pwl10DgMw==
Date: Mon, 23 Dec 2024 14:22:27 -0800
Subject: [PATCH 41/51] xfs_mdrestore: refactor open-coded fd/is_file into a
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944431.2297565.16848943333894292871.stgit@frogsfrogsfrogs>
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

Create an explicit object to track the fd and flags associated with a
device onto which we are restoring metadata, and use it to reduce the
amount of open-coded arguments to ->restore.  This avoids some grossness
in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mdrestore/xfs_mdrestore.c |  123 +++++++++++++++++++++++----------------------
 1 file changed, 63 insertions(+), 60 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c6c00270234442..c5584fec68813e 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -15,12 +15,20 @@ union mdrestore_headers {
 	struct xfs_metadump_header	v2;
 };
 
+struct mdrestore_dev {
+	int		fd;
+	bool		is_file;
+};
+
+#define DEFINE_MDRESTORE_DEV(name) \
+	struct mdrestore_dev name = { .fd = -1 }
+
 struct mdrestore_ops {
 	void (*read_header)(union mdrestore_headers *header, FILE *md_fp);
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
-			int ddev_fd, bool is_data_target_file, int logdev_fd,
-			bool is_log_target_file);
+			const struct mdrestore_dev *ddev,
+			const struct mdrestore_dev *logdev);
 };
 
 static struct mdrestore {
@@ -108,25 +116,24 @@ fixup_superblock(
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 }
 
-static int
+static void
 open_device(
-	char		*path,
-	bool		*is_file)
+	struct mdrestore_dev	*dev,
+	char			*path)
 {
-	struct stat	statbuf;
-	int		open_flags;
-	int		fd;
+	struct stat		statbuf;
+	int			open_flags;
 
 	open_flags = O_RDWR;
-	*is_file = false;
+	dev->is_file = false;
 
 	if (stat(path, &statbuf) < 0)  {
 		/* ok, assume it's a file and create it */
 		open_flags |= O_CREAT;
-		*is_file = true;
+		dev->is_file = true;
 	} else if (S_ISREG(statbuf.st_mode))  {
 		open_flags |= O_TRUNC;
-		*is_file = true;
+		dev->is_file = true;
 	} else if (platform_check_ismounted(path, NULL, &statbuf, 0)) {
 		/*
 		 * check to make sure a filesystem isn't mounted on the device
@@ -136,23 +143,30 @@ open_device(
 				path);
 	}
 
-	fd = open(path, open_flags, 0644);
-	if (fd < 0)
+	dev->fd = open(path, open_flags, 0644);
+	if (dev->fd < 0)
 		fatal("couldn't open \"%s\"\n", path);
+}
 
-	return fd;
+static void
+close_device(
+	struct mdrestore_dev	*dev)
+{
+	if (dev->fd >= 0)
+		close(dev->fd);
+	dev->fd = -1;
+	dev->is_file = false;
 }
 
 static void
 verify_device_size(
-	int		dev_fd,
-	bool		is_file,
-	xfs_rfsblock_t	nr_blocks,
-	uint32_t	blocksize)
+	const struct mdrestore_dev	*dev,
+	xfs_rfsblock_t			nr_blocks,
+	uint32_t			blocksize)
 {
-	if (is_file) {
+	if (dev->is_file) {
 		/* ensure regular files are correctly sized */
-		if (ftruncate(dev_fd, nr_blocks * blocksize))
+		if (ftruncate(dev->fd, nr_blocks * blocksize))
 			fatal("cannot set filesystem image size: %s\n",
 				strerror(errno));
 	} else {
@@ -161,7 +175,7 @@ verify_device_size(
 		off_t		off;
 
 		off = nr_blocks * blocksize - sizeof(lb);
-		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
+		if (pwrite(dev->fd, lb, sizeof(lb), off) < 0)
 			fatal("failed to write last block, is target too "
 				"small? (error: %s)\n", strerror(errno));
 	}
@@ -195,12 +209,10 @@ show_info_v1(
 
 static void
 restore_v1(
-	union mdrestore_headers *h,
-	FILE			*md_fp,
-	int			ddev_fd,
-	bool			is_data_target_file,
-	int			logdev_fd,
-	bool			is_log_target_file)
+	union mdrestore_headers		*h,
+	FILE				*md_fp,
+	const struct mdrestore_dev	*ddev,
+	const struct mdrestore_dev	*logdev)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -254,8 +266,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
-			sb.sb_blocksize);
+	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
 
 	bytes_read = 0;
 
@@ -263,7 +274,7 @@ restore_v1(
 		maybe_print_progress(&mb_read, bytes_read);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(ddev_fd, &block_buffer[cur_index <<
+			if (pwrite(ddev->fd, &block_buffer[cur_index <<
 					h->v1.mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -292,7 +303,7 @@ restore_v1(
 
 	final_print_progress(&mb_read, bytes_read);
 
-	fixup_superblock(ddev_fd, block_buffer, &sb);
+	fixup_superblock(ddev->fd, block_buffer, &sb);
 
 	free(metablock);
 }
@@ -376,12 +387,10 @@ restore_meta_extent(
 
 static void
 restore_v2(
-	union mdrestore_headers	*h,
-	FILE			*md_fp,
-	int			ddev_fd,
-	bool			is_data_target_file,
-	int			logdev_fd,
-	bool			is_log_target_file)
+	union mdrestore_headers		*h,
+	FILE				*md_fp,
+	const struct mdrestore_dev	*ddev,
+	const struct mdrestore_dev	*logdev)
 {
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
@@ -415,16 +424,14 @@ restore_v2(
 
 	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
-			sb.sb_blocksize);
+	verify_device_size(ddev, sb.sb_dblocks, sb.sb_blocksize);
 
 	if (sb.sb_logstart == 0) {
 		ASSERT(mdrestore.external_log == true);
-		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
-				sb.sb_blocksize);
+		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
 	}
 
-	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
+	if (pwrite(ddev->fd, block_buffer, len, 0) < 0)
 		fatal("error writing primary superblock: %s\n",
 			strerror(errno));
 
@@ -446,11 +453,11 @@ restore_v2(
 		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
 		case XME_ADDR_DATA_DEVICE:
 			device = "data";
-			fd = ddev_fd;
+			fd = ddev->fd;
 			break;
 		case XME_ADDR_LOG_DEVICE:
 			device = "log";
-			fd = logdev_fd;
+			fd = logdev->fd;
 			break;
 		default:
 			fatal("Invalid device found in metadump\n");
@@ -467,7 +474,7 @@ restore_v2(
 
 	final_print_progress(&mb_read, bytes_read);
 
-	fixup_superblock(ddev_fd, block_buffer, &sb);
+	fixup_superblock(ddev->fd, block_buffer, &sb);
 
 	free(block_buffer);
 }
@@ -492,13 +499,11 @@ main(
 	char			**argv)
 {
 	union mdrestore_headers	headers;
+	DEFINE_MDRESTORE_DEV(ddev);
+	DEFINE_MDRESTORE_DEV(logdev);
 	FILE			*src_f;
-	char			*logdev = NULL;
-	int			data_dev_fd = -1;
-	int			log_dev_fd = -1;
+	char			*logdev_path = NULL;
 	int			c;
-	bool			is_data_dev_file = false;
-	bool			is_log_dev_file = false;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
@@ -516,7 +521,7 @@ main(
 				mdrestore.show_info = true;
 				break;
 			case 'l':
-				logdev = optarg;
+				logdev_path = optarg;
 				mdrestore.external_log = true;
 				break;
 			case 'V':
@@ -555,7 +560,7 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
-		if (logdev != NULL)
+		if (logdev_path != NULL)
 			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
@@ -581,18 +586,16 @@ main(
 	optind++;
 
 	/* check and open data device */
-	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+	open_device(&ddev, argv[optind]);
 
+	/* check and open log device */
 	if (mdrestore.external_log)
-		/* check and open log device */
-		log_dev_fd = open_device(logdev, &is_log_dev_file);
+		open_device(&logdev, logdev_path);
 
-	mdrestore.mdrops->restore(&headers, src_f, data_dev_fd,
-			is_data_dev_file, log_dev_fd, is_log_dev_file);
+	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev);
 
-	close(data_dev_fd);
-	if (mdrestore.external_log)
-		close(log_dev_fd);
+	close_device(&ddev);
+	close_device(&logdev);
 
 	if (src_f != stdin)
 		fclose(src_f);

