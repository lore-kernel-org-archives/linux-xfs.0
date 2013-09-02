Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32FE57F61
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 09:33:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E75628F8052
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 07:33:54 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	dvS7zkwiGNFDURvw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 07:33:53 -0700 (PDT)
Received: by mail-pd0-f177.google.com with SMTP id y10so4815616pdj.22
	for <xfs@oss.sgi.com>; Mon, 02 Sep 2013 07:33:53 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE
	for fallocate
Date: Mon,  2 Sep 2013 23:33:39 +0900
Message-Id: <1378132420-2953-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add support FALLOC_FL_COLLAPSE_RANGE for fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 io/prealloc.c     |   39 ++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_io.8 |    6 ++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/io/prealloc.c b/io/prealloc.c
index 8380646..e7ff940 100644
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
+	if(!offset_length(argv[1], argv[2], &segment))
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
+		_("de-allocates space and nullify the hole by shifting extents into it");
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
