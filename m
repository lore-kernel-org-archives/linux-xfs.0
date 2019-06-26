Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44668 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZGRU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 02:17:20 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] xfs_io: allow passing an open file to copy_range
Date: Wed, 26 Jun 2019 09:17:11 +0300
Message-Id: <20190626061711.27690-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Commit 1a05efba ("io: open pipes in non-blocking mode")
addressed a specific copy_range issue with pipes by always opening
pipes in non-blocking mode.

This change takes a different approach and allows passing any
open file as the source file to copy_range.  Besides providing
more flexibility to the copy_range command, this allows xfstests
to check if xfs_io supports passing an open file to copy_range.

The intended usage is:
$ mkfifo fifo
$ xfs_io -f -n -r -c "open -f dst" -C "copy_range -f 0" fifo

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---

Eric,

Re-posting this patch with Darrick's RVB, since it was missed last
two for-next updates.
This change is needed to implement the copy_range bounds test [1].

The -f option is already available with sendfile command and
we can make it available for reflink and dedupe commands if
we want to. Too bad that these 4 commands have 3 different
usage patterns to begin with...

Thanks,
Amir.

[1] https://marc.info/?l=fstests&m=155910786017989&w=2

 io/copy_file_range.c | 30 ++++++++++++++++++++++++------
 man/man8/xfs_io.8    | 10 +++++++---
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index d069e5bb..1f0d2713 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -26,6 +26,8 @@ copy_range_help(void)
 					       file at offset 200\n\
  'copy_range some_file' - copies all bytes from some_file into the open file\n\
                           at position 0\n\
+ 'copy_range -f 2' - copies all bytes from open file 2 into the current open file\n\
+                          at position 0\n\
 "));
 }
 
@@ -82,11 +84,12 @@ copy_range_f(int argc, char **argv)
 	int opt;
 	int ret;
 	int fd;
+	int src_file_arg = 1;
 	size_t fsblocksize, fssectsize;
 
 	init_cvtnum(&fsblocksize, &fssectsize);
 
-	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
+	while ((opt = getopt(argc, argv, "s:d:l:f:")) != -1) {
 		switch (opt) {
 		case 's':
 			src = cvtnum(fsblocksize, fssectsize, optarg);
@@ -109,15 +112,30 @@ copy_range_f(int argc, char **argv)
 				return 0;
 			}
 			break;
+		case 'f':
+			fd = atoi(argv[1]);
+			if (fd < 0 || fd >= filecount) {
+				printf(_("value %d is out of range (0-%d)\n"),
+					fd, filecount-1);
+				return 0;
+			}
+			fd = filetable[fd].fd;
+			/* Expect no src_file arg */
+			src_file_arg = 0;
+			break;
 		}
 	}
 
-	if (optind != argc - 1)
+	if (optind != argc - src_file_arg) {
+		fprintf(stderr, "optind=%d, argc=%d, src_file_arg=%d\n", optind, argc, src_file_arg);
 		return command_usage(&copy_range_cmd);
+	}
 
-	fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
-	if (fd < 0)
-		return 0;
+	if (src_file_arg) {
+		fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
+		if (fd < 0)
+			return 0;
+	}
 
 	if (src == 0 && dst == 0 && len == 0) {
 		off64_t	sz;
@@ -150,7 +168,7 @@ copy_range_init(void)
 	copy_range_cmd.argmin = 1;
 	copy_range_cmd.argmax = 7;
 	copy_range_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file");
+	copy_range_cmd.args = _("[-s src_off] [-d dst_off] [-l len] src_file | -f N");
 	copy_range_cmd.oneline = _("Copy a range of data between two files");
 	copy_range_cmd.help = copy_range_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 980dcfd3..6e064bdd 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -660,12 +660,16 @@ Do not print timing statistics at all.
 .RE
 .PD
 .TP
-.BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file"
+.BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file | \-f " N
 On filesystems that support the
 .BR copy_file_range (2)
-system call, copies data from the
+system call, copies data from the source file into the current open file.
+The source must be specified either by path
+.RB ( src_file )
+or as another open file
+.RB ( \-f ).
+If
 .I src_file
-into the open file.  If
 .IR src_offset ,
 .IR dst_offset ,
 and
-- 
2.17.1
