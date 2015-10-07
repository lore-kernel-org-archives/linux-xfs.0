Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFCA229E59
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:05:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C15088F8035
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:05:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PAXFGPOm9mNBWHdb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:05:42 -0700 (PDT)
Subject: [PATCH 04/51] xfs_io: unshare blocks via fallocate
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:05:39 -0700
Message-ID: <20151007050539.1504.84390.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Try to unshare copy-on-write blocks via fallocate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/prealloc.c     |   41 +++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |    5 +++++
 2 files changed, 44 insertions(+), 2 deletions(-)


diff --git a/io/prealloc.c b/io/prealloc.c
index 713ea7b..5b77768 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -40,6 +40,10 @@
 #define FALLOC_FL_INSERT_RANGE 0x20
 #endif
 
+#ifndef FALLOC_FL_UNSHARE_RANGE
+#define FALLOC_FL_UNSHARE_RANGE 0x40
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -173,7 +177,7 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "cikp")) != EOF) {
+	while ((c = getopt(argc, argv, "cikpu")) != EOF) {
 		switch (c) {
 		case 'c':
 			mode = FALLOC_FL_COLLAPSE_RANGE;
@@ -187,6 +191,9 @@ fallocate_f(
 		case 'p':
 			mode = FALLOC_FL_PUNCH_HOLE;
 			break;
+		case 'u':
+			mode = FALLOC_FL_UNSHARE_RANGE;
+			break;
 		default:
 			command_usage(&falloc_cmd);
 		}
@@ -286,6 +293,26 @@ fzero_f(
 	}
 	return 0;
 }
+
+static int
+funshare_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_UNSHARE_RANGE;
+	int		index = 1;
+
+	if (!offset_length(argv[index], argv[index + 1], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
 #endif	/* HAVE_FALLOCATE */
 
 void
@@ -346,7 +373,7 @@ prealloc_init(void)
 	falloc_cmd.argmin = 2;
 	falloc_cmd.argmax = -1;
 	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	falloc_cmd.args = _("[-c] [-k] [-p] off len");
+	falloc_cmd.args = _("[-c] [-k] [-p] [-u] off len");
 	falloc_cmd.oneline =
 	_("allocates space associated with part of a file via fallocate");
 	add_command(&falloc_cmd);
@@ -390,5 +417,15 @@ prealloc_init(void)
 	fzero_cmd.oneline =
 	_("zeroes space and eliminates holes by preallocating");
 	add_command(&fzero_cmd);
+
+	fzero_cmd.name = "funshare";
+	fzero_cmd.cfunc = funshare_f;
+	fzero_cmd.argmin = 2;
+	fzero_cmd.argmax = 2;
+	fzero_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fzero_cmd.args = _("off len");
+	fzero_cmd.oneline =
+	_("unshares shared blocks within the range");
+	add_command(&fzero_cmd);
 #endif	/* HAVE_FALLOCATE */
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e0a901f..d66dfbf 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -415,6 +415,11 @@ the FALLOC_FL_PUNCH_HOLE flag as described in the
 .BR fallocate (2)
 manual page.
 .TP
+.BI funshare " offset length"
+Call fallocate with FALLOC_FL_UNSHARE_RANGE flag as described in the
+.BR fallocate (2)
+manual page to unshare all shared blocks within the range.
+.TP
 .BI fzero " offset length"
 Call fallocate with FALLOC_FL_ZERO_RANGE flag as described in the
 .BR fallocate (2)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
