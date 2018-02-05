Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33118 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbeBELur (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Feb 2018 06:50:47 -0500
Received: by mail-qt0-f193.google.com with SMTP id d8so39159671qtm.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2018 03:50:47 -0800 (PST)
From: Marco A Benatto <marco.antonio.780@gmail.com>
Subject: [PATCH] xfs_mdrestore: Don't rewind source file stream
Date: Mon,  5 Feb 2018 09:50:34 -0200
Message-Id: <1517831434-125895-1-git-send-email-marco.antonio.780@gmail.com>
In-Reply-To: <20180203173219.GE4849@magnolia>
References: <20180203173219.GE4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Today, xfs_mdrestore from stdin will fail if the -i flag is
specified, because it attempts to rewind the stream after
the initial read of the metablock.  This fails, and
results in an abort with "specified file is not a metadata
dump."

Read the metablock exactly once in main(), validate the magic,
print informational flags if requested, and then pass it to
perform_restore() which will then continue the restore process.

Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
---
 mdrestore/xfs_mdrestore.c | 68 +++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0bb4ac8..cbabd56 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -51,57 +51,55 @@ print_progress(const char *fmt, ...)
 	progress_since_warning = 1;
 }
 
+/*
+ * perform_restore() -- do the actual work to restore the metadump 
+ *
+ * @src_f: A FILE pointer to the source metadump
+ * @dst_fd: the file descriptor for the target file
+ * @is_target_file: designates whether the target is a regular file
+ * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
+ *  
+ * src_f should be positioned just past a read the previously validated metablock
+ */
 static void
 perform_restore(
 	FILE			*src_f,
 	int			dst_fd,
-	int			is_target_file)
+	int			is_target_file,
+	const struct xfs_metablock	*mbp)
 {
-	xfs_metablock_t 	*metablock;	/* header + index + blocks */
+	struct xfs_metablock 	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
 	char			*block_buffer;
 	int			block_size;
 	int			max_indices;
 	int			cur_index;
 	int			mb_count;
-	xfs_metablock_t		tmb;
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 
-	/*
-	 * read in first blocks (superblock 0), set "inprogress" flag for it,
-	 * read in the rest of the file, and if complete, clear SB 0's
-	 * "inprogress flag"
-	 */
-
-	if (fread(&tmb, sizeof(tmb), 1, src_f) != 1)
-		fatal("error reading from file: %s\n", strerror(errno));
-
-	if (be32_to_cpu(tmb.mb_magic) != XFS_MD_MAGIC)
-		fatal("specified file is not a metadata dump\n");
-
-	block_size = 1 << tmb.mb_blocklog;
+	block_size = 1 << mbp->mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
 	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
 	if (metablock == NULL)
 		fatal("memory allocation failure\n");
 
-	mb_count = be16_to_cpu(tmb.mb_count);
+	mb_count = be16_to_cpu(mbp->mb_count);
 	if (mb_count == 0 || mb_count > max_indices)
 		fatal("bad block count: %u\n", mb_count);
 
 	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
 	block_buffer = (char *)metablock + block_size;
 
-	if (fread(block_index, block_size - sizeof(tmb), 1, src_f) != 1)
+	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
 		fatal("error reading from file: %s\n", strerror(errno));
 
 	if (block_index[0] != 0)
 		fatal("first block is not the primary superblock\n");
 
 
-	if (fread(block_buffer, mb_count << tmb.mb_blocklog,
+	if (fread(block_buffer, mb_count << mbp->mb_blocklog,
 			1, src_f) != 1)
 		fatal("error reading from file: %s\n", strerror(errno));
 
@@ -148,7 +146,7 @@ perform_restore(
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(dst_fd, &block_buffer[cur_index <<
-					tmb.mb_blocklog], block_size,
+					mbp->mb_blocklog], block_size,
 					be64_to_cpu(block_index[cur_index]) <<
 						BBSHIFT) < 0)
 				fatal("error writing block %llu: %s\n",
@@ -167,11 +165,11 @@ perform_restore(
 		if (mb_count > max_indices)
 			fatal("bad block count: %u\n", mb_count);
 
-		if (fread(block_buffer, mb_count << tmb.mb_blocklog,
+		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
 								1, src_f) != 1)
 			fatal("error reading from file: %s\n", strerror(errno));
 
-		bytes_read += block_size + (mb_count << tmb.mb_blocklog);
+		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
 	}
 
 	if (progress_since_warning)
@@ -211,6 +209,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	struct xfs_metablock	mb;
 
 	progname = basename(argv[0]);
 
@@ -237,7 +236,12 @@ main(
 	if (!show_info && argc - optind != 2)
 		usage();
 
-	/* open source */
+	/*
+	 * open source and test if this really is a dump. The first metadump block
+	 * will be passed to perform_restore() which will continue to read the
+	 * file from this point. This avoids rewind the stream, which causes
+	 * restore to fail when source was being read from stdin.
+ 	 */
 	if (strcmp(argv[optind], "-") == 0) {
 		src_f = stdin;
 		if (isatty(fileno(stdin)))
@@ -248,15 +252,12 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (show_info) {
-		xfs_metablock_t		mb;
-
-		if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-			fatal("error reading from file: %s\n", strerror(errno));
-
-		if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
-			fatal("specified file is not a metadata dump\n");
+	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
+		fatal("error reading from file: %s\n", strerror(errno));
+	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
+		fatal("specified file is not a metadata dump\n");
 
+	if (show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
 			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			argv[optind],
@@ -270,9 +271,6 @@ main(
 
 		if (argc - optind == 1)
 			exit(0);
-
-		/* Go back to the beginning for the restore function */
-		fseek(src_f, 0L, SEEK_SET);
 	}
 
 	optind++;
@@ -301,7 +299,7 @@ main(
 	if (dst_fd < 0)
 		fatal("couldn't open target \"%s\"\n", argv[optind]);
 
-	perform_restore(src_f, dst_fd, is_target_file);
+	perform_restore(src_f, dst_fd, is_target_file, &mb);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
1.8.3.1

