Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:39249 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbeBBTL3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 14:11:29 -0500
Received: by mail-qk0-f196.google.com with SMTP id n129so14519370qke.6
        for <linux-xfs@vger.kernel.org>; Fri, 02 Feb 2018 11:11:29 -0800 (PST)
From: Marco A Benatto <marco.antonio.780@gmail.com>
Subject: [PATCH 2/2] xfs_mdrestore: Don't rewind source file stream
Date: Fri,  2 Feb 2018 17:11:14 -0200
Message-Id: <1517598674-52297-2-git-send-email-marco.antonio.780@gmail.com>
In-Reply-To: <1517598674-52297-1-git-send-email-marco.antonio.780@gmail.com>
References: <1517598674-52297-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: mbenatto@redhat.com

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
 mdrestore/xfs_mdrestore.c | 52 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 0bb4ac8..15231a1 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -51,11 +51,22 @@ print_progress(const char *fmt, ...)
 	progress_since_warning = 1;
 }
 
+/*
+ * perform_restore() -- do the actual work to restore the metadump 
+ *
+ * @src_f: A FILE pointer to the source metadump
+ * @dst_fd: the file descriptor for the target file
+ * @is_target_file: designates whether the target is a regular file
+ * @mb: the metadump's first xfs_metablock_t, read and verified by the caller
+ *  
+ * src_f should be positioned just past a read the previously validated metablock
+ */
 static void
 perform_restore(
 	FILE			*src_f,
 	int			dst_fd,
-	int			is_target_file)
+	int			is_target_file,
+	const xfs_metablock_t	tmb)
 {
 	xfs_metablock_t 	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -64,22 +75,9 @@ perform_restore(
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
 	block_size = 1 << tmb.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
@@ -211,6 +209,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	xfs_metablock_t		mb;
 
 	progname = basename(argv[0]);
 
@@ -237,7 +236,12 @@ main(
 	if (!show_info && argc - optind != 2)
 		usage();
 
-	/* open source */
+	/*
+	 * open source and test if this really is a dump. The first metadatablock
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
+	if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
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
+	perform_restore(src_f, dst_fd, is_target_file, mb);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
1.8.3.1

