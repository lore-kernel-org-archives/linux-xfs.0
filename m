Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759091A0AFE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637486; cv=none; b=fPNyHlkHB4RFHnTCy0bA3q7beAH0uq0lPVVME8VqR++nTmeC85ckrP9a7HJ7JTBuFPdHB/LKWf8eLotfQu8KsnPy1mmsD/ySF2yX6bhayf7drxU7zuppd7klgMGWX3ii4D87E81DhJP3om8iCjJlyftlRCsx+TWuIXEZsfi9tBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637486; c=relaxed/simple;
	bh=GhyHGxki1LC3Tyaep0+lGJl/1UAiLpHxKVVGY8Wpnvk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPb4fu6ld0uFUn92a3Onr2UDRz7JCu7Tm8+WcE6NcmwAmL1AGCtsLx6lyR2xEHIXt+8052ERtdfkYxZoCSug9lNYGuZ4BZUhv8EgMycEqmyibzVwCWn5K+PUf1qbnukLk8d5fR6WyhzlMCOa598IJC5tiJ0XIYBDdrpGVqBVARE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVEt5U3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVEt5U3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD5EC4CECE;
	Thu, 19 Dec 2024 19:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637486;
	bh=GhyHGxki1LC3Tyaep0+lGJl/1UAiLpHxKVVGY8Wpnvk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LVEt5U3bLHl8hE2Eu1PA5DUFKFe0gLrI/gUarvjJblw+4pfdWIN57w+gz5N5RmC2u
	 4cLV4ZG+co8uqTBocDSDeP8Acs90qgCa1+fD8LEvQfcNWtS2m0zrPhJrFDtm55bl+s
	 fdR0arizYCY+d4PdurSO/6+BvFU/kjWgVd0hlSVCYPv/jlowlEukrkryGczWbwUXf+
	 ktMHGcAFZTSe4Ftkzj3CTTuzCug9tOdpCKUKRysbF5eSwTsVPxUL/E0HfDU13wdl+j
	 uRNxw6svx4dkPmI0DCz6/Uj3q0qj3CKNweHOXBif3K1ttoYi9CsUJJnPzflnCOg6Qy
	 jN4PCsP3ZSYlQ==
Date: Thu, 19 Dec 2024 11:44:45 -0800
Subject: [PATCH 2/3] xfs_mdrestore: refactor open-coded fd/is_file into a
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463582928.1574879.5106855575792576842.stgit@frogsfrogsfrogs>
In-Reply-To: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
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

