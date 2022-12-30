Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B30C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbiLaC3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaC3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:29:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C6F1CB17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E367B81E72
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE80C433EF;
        Sat, 31 Dec 2022 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453787;
        bh=c+dlL9gCIxOVHKYd7GxKSXIdJB4iLg98Gp4SUnZq2Po=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kV1HJlysTJ9n0uLhYLanKx6ewkbzNSOCb0IbFBUIbFPdc2nySdGNfnnuXkO11XYCS
         gtSFGxIeQLisYBECrJZTYmKGxaDm+aXOlMVnhTuC0FRqEn/nlyXl1UqkyVgbYgSomj
         cFoEHvSxHLw/JfrEe9FJzpmR91qRAoQunC2ewXVtuNUxXll7DMc1OfqUF6O+zvejvk
         54JwrZF+zlGTDyOaCEXkQOvumy0xo5n8VLjN2d1c/NapfhXuM62ps/R06KVrFtRAzJ
         CwCSzrw0hZ1INAHEkQTJSRDRW8t5deSWUQ1HfPXcby/35feuRREUDJAArbVPtnkbrT
         /d3QXg5QNvo/Q==
Subject: [PATCH 4/5] xfs_mdrestore: restore log contents to external log
 devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878035.730695.15058686240875755491.stgit@magnolia>
In-Reply-To: <167243877981.730695.7761889719607533776.stgit@magnolia>
References: <167243877981.730695.7761889719607533776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Support restoring log data to an external log device, if the dumped
filesystem had one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_mdrestore.8  |    8 ++
 mdrestore/xfs_mdrestore.c |  176 +++++++++++++++++++++++++++++++--------------
 2 files changed, 131 insertions(+), 53 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 72f3b297787..4626b98e749 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -5,12 +5,17 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B xfs_mdrestore
 [
 .B \-gi
+] [
+.B \-l logdev
 ]
 .I source
 .I target
 .br
 .B xfs_mdrestore
 .B \-i
+[
+.B \-l logdev
+]
 .I source
 .br
 .B xfs_mdrestore \-V
@@ -43,6 +48,9 @@ can be destroyed.
 .B \-g
 Shows restore progress on stdout.
 .TP
+.B \-l
+Restore log contents to this external log device.
+.TP
 .B \-i
 Shows metadump information on stdout.  If no
 .I target
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 9f8cbe98cd6..4318fac9008 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -38,6 +38,67 @@ print_progress(const char *fmt, ...)
 	progress_since_warning = 1;
 }
 
+extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+
+static int
+open_device(
+	char		*path,
+	int		*is_target_file)
+{
+	struct stat	statbuf;
+	int		open_flags = O_RDWR;
+	int		dst_fd;
+
+	*is_target_file = 0;
+	if (stat(path, &statbuf) < 0)  {
+		/* ok, assume it's a file and create it */
+		open_flags |= O_CREAT;
+		*is_target_file = 1;
+	} else if (S_ISREG(statbuf.st_mode))  {
+		open_flags |= O_TRUNC;
+		*is_target_file = 1;
+	} else  {
+		/*
+		 * check to make sure a filesystem isn't mounted on the device
+		 */
+		if (platform_check_ismounted(path, NULL, &statbuf, 0))
+			fatal("a filesystem is mounted on target device \"%s\","
+				" cannot restore to a mounted filesystem.\n",
+				path);
+	}
+
+	dst_fd = open(path, open_flags, 0644);
+	if (dst_fd < 0)
+		fatal("couldn't open target \"%s\"\n", path);
+
+	return dst_fd;
+}
+
+static void
+check_dev(
+	int			dst_fd,
+	int			is_target_file,
+	unsigned long long	bytes)
+{
+	if (is_target_file)  {
+		/* ensure regular files are correctly sized */
+
+		if (ftruncate(dst_fd, bytes))
+			fatal("cannot set filesystem image size: %s\n",
+				strerror(errno));
+	} else  {
+		/* ensure device is sufficiently large enough */
+
+		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
+		off64_t		off;
+
+		off = bytes - sizeof(lb);
+		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
+			fatal("failed to write last block, is target too "
+				"small? (error: %s)\n", strerror(errno));
+	}
+}
+
 /*
  * perform_restore() -- do the actual work to restore the metadump
  *
@@ -53,7 +114,8 @@ perform_restore(
 	FILE			*src_f,
 	int			dst_fd,
 	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+	const struct xfs_metablock	*mbp,
+	char			*log_path)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -64,6 +126,10 @@ perform_restore(
 	int			mb_count;
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
+	int			log_fd = -1;
+	bool			is_mdx;
+
+	is_mdx = mbp->mb_magic == cpu_to_be32(XFS_MDX_MAGIC);
 
 	block_size = 1 << mbp->mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
@@ -76,6 +142,7 @@ perform_restore(
 	if (mb_count == 0 || mb_count > max_indices)
 		fatal("bad block count: %u\n", mb_count);
 
+	memcpy(metablock, mbp, sizeof(struct xfs_metablock));
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
@@ -106,32 +173,43 @@ perform_restore(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	if (is_target_file)  {
-		/* ensure regular files are correctly sized */
-
-		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
-			fatal("cannot set filesystem image size: %s\n",
-				strerror(errno));
-	} else  {
-		/* ensure device is sufficiently large enough */
-
-		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
-		off64_t		off;
-
-		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
-			fatal("failed to write last block, is target too "
-				"small? (error: %s)\n", strerror(errno));
-	}
+	check_dev(dst_fd, is_target_file, sb.sb_dblocks * sb.sb_blocksize);
 
 	bytes_read = 0;
 
 	for (;;) {
+		int		write_fd = dst_fd;
+
+		if (metablock->mb_magic != mbp->mb_magic)
+			fatal("magic value 0x%x wrong, expected 0x%x\n",
+					metablock->mb_magic, mbp->mb_magic);
+
+		if (metablock->mb_info & XFS_METADUMP_LOGDEV) {
+			int	log_is_file;
+
+			if (!is_mdx)
+				fatal("logdev set on an old style metadump?\n");
+			if (log_fd == -1) {
+				if (!log_path)
+					fatal(
+	"metadump has log contents but -l was not specified?\n");
+				log_fd = open_device(log_path, &log_is_file);
+				check_dev(log_fd, log_is_file,
+						sb.sb_logblocks * sb.sb_blocksize);
+			}
+			write_fd = log_fd;
+		}
+		if (metablock->mb_info & XFS_METADUMP_RTDEV) {
+			if (!is_mdx)
+				fatal("rtdev set on an old style metadump?\n");
+			fatal("rtdev not supported\n");
+		}
+
 		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
 			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
-			if (pwrite(dst_fd, &block_buffer[cur_index <<
+			if (pwrite(write_fd, &block_buffer[cur_index <<
 					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
@@ -139,11 +217,20 @@ perform_restore(
 					be64_to_cpu(block_index[cur_index]) << BBSHIFT,
 					strerror(errno));
 		}
-		if (mb_count < max_indices)
-			break;
+		if (is_mdx) {
+			size_t	nr = fread(metablock, block_size, 1, src_f);
 
-		if (fread(metablock, block_size, 1, src_f) != 1)
-			fatal("error reading from metadump file\n");
+			if (nr == 0)
+				break;
+			if (nr != 1)
+				fatal("error reading from extended metadump file\n");
+		} else {
+			if (mb_count < max_indices)
+				break;
+
+			if (fread(metablock, block_size, 1, src_f) != 1)
+				fatal("error reading from metadump file\n");
+		}
 
 		mb_count = be16_to_cpu(metablock->mb_count);
 		if (mb_count == 0)
@@ -170,38 +257,41 @@ perform_restore(
 	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
+	if (log_fd >= 0)
+		close(log_fd);
+
 	free(metablock);
 }
 
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n", progname);
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
 	char 		**argv)
 {
+	char		*log_path = NULL;
 	FILE		*src_f;
 	int		dst_fd;
 	int		c;
-	int		open_flags;
-	struct stat	statbuf;
 	int		is_target_file;
 	struct xfs_metablock	mb;
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gl:iV")) != EOF) {
 		switch (c) {
 			case 'g':
 				show_progress = 1;
 				break;
+			case 'l':
+				log_path = optarg;
+				break;
 			case 'i':
 				show_info = 1;
 				break;
@@ -238,7 +328,8 @@ main(
 
 	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
 		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC) &&
+	    mb.mb_magic != cpu_to_be32(XFS_MDX_MAGIC))
 		fatal("specified file is not a metadata dump\n");
 
 	if (show_info) {
@@ -260,30 +351,9 @@ main(
 	optind++;
 
 	/* check and open target */
-	open_flags = O_RDWR;
-	is_target_file = 0;
-	if (stat(argv[optind], &statbuf) < 0)  {
-		/* ok, assume it's a file and create it */
-		open_flags |= O_CREAT;
-		is_target_file = 1;
-	} else if (S_ISREG(statbuf.st_mode))  {
-		open_flags |= O_TRUNC;
-		is_target_file = 1;
-	} else  {
-		/*
-		 * check to make sure a filesystem isn't mounted on the device
-		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
-			fatal("a filesystem is mounted on target device \"%s\","
-				" cannot restore to a mounted filesystem.\n",
-				argv[optind]);
-	}
+	dst_fd = open_device(argv[optind], &is_target_file);
 
-	dst_fd = open(argv[optind], open_flags, 0644);
-	if (dst_fd < 0)
-		fatal("couldn't open target \"%s\"\n", argv[optind]);
-
-	perform_restore(src_f, dst_fd, is_target_file, &mb);
+	perform_restore(src_f, dst_fd, is_target_file, &mb, log_path);
 
 	close(dst_fd);
 	if (src_f != stdin)

