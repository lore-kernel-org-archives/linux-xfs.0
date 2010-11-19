Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAJJfIcm153362 for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 13:41:18 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD568193D4B
	for <xfs@oss.sgi.com>; Fri, 19 Nov 2010 11:42:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j7BFGRTZRC5DE7il for
	<xfs@oss.sgi.com>; Fri, 19 Nov 2010 11:42:53 -0800 (PST)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfsprogs: add fpunch command for hole punching via fallocate
	V2
Date: Fri, 19 Nov 2010 14:33:06 -0500
Message-Id: <1290195186-19249-1-git-send-email-josef@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, david@fromorbit.com

This adds a fpunch command that Dave Chinner recommended.  It simply uses
fallocate to punch a hole for the given offset and length.  It is necessary to
run the xfstest I have for hole punching.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2
-instead of a -p option for falloc, make fpunch

 io/prealloc.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index c8b7df6..9dcfc1c 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -32,6 +32,9 @@ static cmdinfo_t unresvsp_cmd;
 static cmdinfo_t zero_cmd;
 #if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
+#if defined (FALLOC_FL_PUNCH_HOLE)
+static cmdinfo_t fpunch_cmd;
+#endif
 #endif
 
 static int
@@ -153,8 +156,10 @@ fallocate_f(
 	xfs_flock64_t	segment;
 	int		mode = 0;
 	int		c;
+	const char	*opts;
 
-	while ((c = getopt(argc, argv, "k")) != EOF) {
+	opts = "k";
+	while ((c = getopt(argc, argv, opts)) != EOF) {
 		switch (c) {
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
@@ -176,7 +181,28 @@ fallocate_f(
 	}
 	return 0;
 }
-#endif
+
+#if defined (FALLOC_FL_PUNCH_HOLE)
+static int
+fpunch_f(
+	 int		argc,
+	 char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+#endif	/* FALLOC_FL_PUNCH_HOLE */
+#endif	/* HAVE_FALLOCATE */
 
 void
 prealloc_init(void)
@@ -239,7 +265,18 @@ prealloc_init(void)
 	falloc_cmd.args = _("[-k] off len");
 	falloc_cmd.oneline =
 		_("allocates space associated with part of a file via fallocate");
-
 	add_command(&falloc_cmd);
-#endif
+
+#if defined (FALLOC_FL_PUNCH_HOLE)
+	fpunch_cmd.name = _("fpunch");
+	fpunch_cmd.cfunc = fpunch_f;
+	fpunch_cmd.argmin = 2;
+	fpunch_cmd.argmax = -1;
+	fpunch_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fpunch_cmd.args = _("off len");
+	fpunch_cmd.oneline =
+		_("de-allocates space assocated with part of a file via fallocate");
+	add_command(&fpunch_cmd);
+#endif	/* FALLOC_FL_PUNCH_HOLE */
+#endif	/* HAVE_FALLOCATE */
 }
-- 
1.6.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
