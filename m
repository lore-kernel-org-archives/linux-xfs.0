Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A1B97FC0
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:11:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A9CBAC001
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:11:45 -0800 (PST)
Received: from mail-pb0-f44.google.com (mail-pb0-f44.google.com
	[209.85.160.44]) by cuda.sgi.com with ESMTP id kmSHjeXYJjqEseV9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:11:39 -0800 (PST)
Received: by mail-pb0-f44.google.com with SMTP id rq2so3817464pbb.3
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:11:38 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 4/10] xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE
	for fallocate
Date: Sun,  8 Dec 2013 23:11:30 +0900
Message-Id: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 io/prealloc.c     |   41 +++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |    6 ++++++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index 8380646..d697f82 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -29,6 +29,10 @@
 #define FALLOC_FL_PUNCH_HOLE	0x02
 #endif
 
+#ifndef FALLOC_FL_COLLAPSE_RANGE
+#define FALLOC_FL_COLLAPSE_RANGE 0x08
+#endif
+
 static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
@@ -37,6 +41,7 @@ static cmdinfo_t zero_cmd;
 #if defined(HAVE_FALLOCATE)
 static cmdinfo_t falloc_cmd;
 static cmdinfo_t fpunch_cmd;
+static cmdinfo_t fcollapse_cmd;
 #endif
 
 static int
@@ -159,8 +164,11 @@ fallocate_f(
 	int		mode = 0;
 	int		c;
 
-	while ((c = getopt(argc, argv, "kp")) != EOF) {
+	while ((c = getopt(argc, argv, "ckp")) != EOF) {
 		switch (c) {
+		case 'c':
+			mode = FALLOC_FL_COLLAPSE_RANGE;
+			break;
 		case 'k':
 			mode = FALLOC_FL_KEEP_SIZE;
 			break;
@@ -203,6 +211,25 @@ fpunch_f(
 	}
 	return 0;
 }
+
+static int
+fcollapse_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = FALLOC_FL_COLLAPSE_RANGE;
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
 #endif	/* HAVE_FALLOCATE */
 
 void
@@ -263,7 +290,7 @@ prealloc_init(void)
 	falloc_cmd.argmin = 2;
 	falloc_cmd.argmax = -1;
 	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	falloc_cmd.args = _("[-k] [-p] off len");
+	falloc_cmd.args = _("[-c] [-k] [-p] off len");
 	falloc_cmd.oneline =
 		_("allocates space associated with part of a file via fallocate");
 	add_command(&falloc_cmd);
@@ -277,5 +304,15 @@ prealloc_init(void)
 	fpunch_cmd.oneline =
 		_("de-allocates space assocated with part of a file via fallocate");
 	add_command(&fpunch_cmd);
+
+	fcollapse_cmd.name = "fcollapse";
+	fcollapse_cmd.cfunc = fcollapse_f;
+	fcollapse_cmd.argmin = 2;
+	fcollapse_cmd.argmax = 2;
+	fcollapse_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	fcollapse_cmd.args = _("off len");
+	fcollapse_cmd.oneline =
+	_("de-allocates space and eliminates the hole by shifting extents");
+	add_command(&fcollapse_cmd);
 #endif	/* HAVE_FALLOCATE */
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 767b50e..9543b20 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -380,6 +380,12 @@ will set the FALLOC_FL_KEEP_SIZE flag as described in
 .PD
 .RE
 .TP
+.BI fcollapse " offset length"
+Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
+.BR fallocate (2)
+manual page to de-allocates blocks and eliminates the hole created in this process
+by shifting data blocks into the hole.
+.TP
 .BI fpunch " offset length"
 Punches (de-allocates) blocks in the file by calling fallocate with 
 the FALLOC_FL_PUNCH_HOLE flag as described in the
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
