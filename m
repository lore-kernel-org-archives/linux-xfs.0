Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42021 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754002AbdKIT1H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 14:27:07 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v4 3/4] xfs_io: Add RWF_NOWAIT to pwritev2()
Date: Thu,  9 Nov 2017 13:26:47 -0600
Message-Id: <20171109192648.6356-3-rgoldwyn@suse.de>
In-Reply-To: <20171109192648.6356-1-rgoldwyn@suse.de>
References: <20171109192648.6356-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This allows to make pwritev2() calls with RWF_NOWAIT,
which would fail in case the call blocks.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 io/pwrite.c       | 12 ++++++++++--
 man/man8/xfs_io.8 | 10 ++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/io/pwrite.c b/io/pwrite.c
index 2cdf0954..c218f686 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -53,6 +53,9 @@ pwrite_help(void)
 #ifdef HAVE_PWRITEV
 " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
 #endif
+#ifdef HAVE_PWRITEV2
+" -N   -- Perform the pwritev2() with RWF_NOWAIT\n"
+#endif
 "\n"));
 }
 
@@ -279,7 +282,7 @@ pwrite_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:BCdf:Fi:qRs:S:uV:wWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:BCdf:Fi:NqRs:S:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -308,6 +311,11 @@ pwrite_f(
 		case 'i':
 			infile = optarg;
 			break;
+#ifdef HAVE_PWRITEV2
+		case 'N':
+			pwritev2_flags |= RWF_NOWAIT;
+			break;
+#endif
 		case 's':
 			skip = cvtnum(fsblocksize, fssectsize, optarg);
 			if (skip < 0) {
@@ -426,7 +434,7 @@ pwrite_init(void)
 	pwrite_cmd.argmax = -1;
 	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	pwrite_cmd.args =
-_("[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] [-FBR [-Z N]] [-V N] off len");
+_("[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] [-FBR [-Z N]] [-N] [-V N] off len");
 	pwrite_cmd.oneline =
 		_("writes a number of bytes at a specified offset");
 	pwrite_cmd.help = pwrite_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 0fd9b951..5c0565ec 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -282,6 +282,16 @@ Use the vectored IO write syscall
 with a number of blocksize length iovecs. The number of iovecs is set by the
 .I vectors
 parameter.
+.TP
+.B \-N
+Perform the
+.BR pwritev2 (2)
+call with
+.I RWF_NOWAIT.
+This option is available if
+.BR xfs_io
+was built on a kernel which supports
+.I pwritev2 (2)
 .RE
 .PD
 .TP
-- 
2.14.2

