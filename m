Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF82C7CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 10:44:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27765AC002
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:44:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ofn2F3cMp0csBoIZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:44:24 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 79E808F2FD
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:44:23 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] io/mmap: new -s option for mmap command to reserve some
	free space
Date: Wed, 16 Mar 2016 23:44:19 +0800
Message-Id: <1458143059-26153-1-git-send-email-zlang@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: bfoster@redhat.com, Zorro Lang <zlang@redhat.com>

When I try to use xfs_io to rewrite LTP's mmap16 testcase for xfstests,
I always hit mremap ENOMEM error. But according to linux commit:

  90a8020 vfs: fix data corruption when blocksize < pagesize for mmaped data

The reproducer shouldn't use MREMAP_MAYMOVE flag for mremap(). So we
need a stable method to make mremap can extend space from the original
mapped starting address(That means no -m option for xfs_io mremap).

Generally if we try to mremap from the original mapped starting point
in a C program, at first we always do:

  addr = mmap(NULL, res_size, prot, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  munmap(addr, res_size);

Then do:

  addr = mmap(addr, real_len, ...);

The "res_size" is bigger than "real_len". This will help us get a
region between real_len and res_size, which maybe free space. The
truth is we can't guarantee that this free memory will stay free.
But this method is still very helpful for reserve some free space
in short time.

This patch bring in the "res_size" by use a new -s option. If don't use
this option, xfs_io -c "mmap 0 1024" -c "mremap 8192" will hit ENOMEM
error nearly 100%, but if use this option, it nearly always remap
successfully. So I think it's helpful, if someone try to run mremap
without "-m".

Signed-off-by: Zorro Lang <zlang@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 io/mmap.c         | 29 +++++++++++++++++++++++------
 man/man8/xfs_io.8 | 17 ++++++++++++++++-
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/io/mmap.c b/io/mmap.c
index 5970069..6cd37a9 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -146,6 +146,7 @@ mmap_help(void)
 " -r -- map with PROT_READ protection\n"
 " -w -- map with PROT_WRITE protection\n"
 " -x -- map with PROT_EXEC protection\n"
+" -s <size> -- first do mmap(size)/munmap(size), try to reserve some free space\n"
 " If no protection mode is specified, all are used by default.\n"
 "\n"));
 }
@@ -156,8 +157,8 @@ mmap_f(
 	char		**argv)
 {
 	off64_t		offset;
-	ssize_t		length;
-	void		*address;
+	ssize_t		length = 0, length2 = 0;
+	void		*address = NULL;
 	char		*filename;
 	size_t		blocksize, sectsize;
 	int		c, prot = 0;
@@ -181,7 +182,9 @@ mmap_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "rwx")) != EOF) {
+	init_cvtnum(&blocksize, &sectsize);
+
+	while ((c = getopt(argc, argv, "rwxs:")) != EOF) {
 		switch (c) {
 		case 'r':
 			prot |= PROT_READ;
@@ -192,6 +195,9 @@ mmap_f(
 		case 'x':
 			prot |= PROT_EXEC;
 			break;
+		case 's':
+			length2 = cvtnum(blocksize, sectsize, optarg);
+			break;
 		default:
 			return command_usage(&mmap_cmd);
 		}
@@ -202,7 +208,6 @@ mmap_f(
 	if (optind != argc - 2)
 		return command_usage(&mmap_cmd);
 
-	init_cvtnum(&blocksize, &sectsize);
 	offset = cvtnum(blocksize, sectsize, argv[optind]);
 	if (offset < 0) {
 		printf(_("non-numeric offset argument -- %s\n"), argv[optind]);
@@ -221,7 +226,19 @@ mmap_f(
 		return 0;
 	}
 
-	address = mmap(NULL, length, prot, MAP_SHARED, file->fd, offset);
+	/*
+	 * mmap and munmap memory area of length2 region is helpful to
+	 * make a region of extendible free memory. It's generally used
+	 * for later mremap operation(no MREMAP_MAYMOVE flag). But there
+	 * isn't guarantee that the memory after length (up to length2)
+	 * will stay free.
+	 */
+	if (length2 > length) {
+		address = mmap(NULL, length2, prot,
+		               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		munmap(address, length2);
+	}
+	address = mmap(address, length, prot, MAP_SHARED, file->fd, offset);
 	if (address == MAP_FAILED) {
 		perror("mmap");
 		free(filename);
@@ -647,7 +664,7 @@ mmap_init(void)
 	mmap_cmd.argmin = 0;
 	mmap_cmd.argmax = -1;
 	mmap_cmd.flags = CMD_NOMAP_OK | CMD_NOFILE_OK | CMD_FOREIGN_OK;
-	mmap_cmd.args = _("[N] | [-rwx] [off len]");
+	mmap_cmd.args = _("[N] | [-rwx] [-s size] [off len]");
 	mmap_cmd.oneline =
 		_("mmap a range in the current file, show mappings");
 	mmap_cmd.help = mmap_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 33fbe6a..93a8a00 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -559,7 +559,7 @@ Do not print timing statistics at all.
 
 .SH MEMORY MAPPED I/O COMMANDS
 .TP
-.BI "mmap [ " N " | [[ \-rwx ] " "offset length " ]]
+.BI "mmap [ " N " | [[ \-rwx ] [\-s " size " ] " "offset length " ]]
 With no arguments,
 .B mmap
 shows the current mappings. Specifying a single numeric argument
@@ -575,6 +575,21 @@ PROT_WRITE
 .RB ( \-w ),
 and PROT_EXEC
 .RB ( \-x ).
+.BI \-s " size"
+is used to do a mmap(size) && munmap(size) operation at first, try to reserve some
+extendible free memory space, if
+.I size
+is bigger than
+.I length
+parameter. But there's not guarantee that the memory after
+.I length
+( up to
+.I size
+) will stay free.
+.B e.g.
+"mmap -rw -s 8192 1024" will mmap 0 ~ 1024 bytes memory, but try to reserve 1024 ~ 8192
+free space(no guarantee). This free space will helpful for "mremap 8192" without
+MREMAP_MAYMOVE flag.
 .TP
 .B mm
 See the
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
