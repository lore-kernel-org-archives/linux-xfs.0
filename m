Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 47D097F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 04:35:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C49ABAC005
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:35:51 -0800 (PST)
Received: from mail-ee0-f41.google.com (mail-ee0-f41.google.com
	[74.125.83.41]) by cuda.sgi.com with ESMTP id 1VLITwawSxvsWMDR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:35:49 -0800 (PST)
Received: by mail-ee0-f41.google.com with SMTP id b15so1289259eek.14
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 02:35:48 -0800 (PST)
From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2] util-linux/fallocate: introduce an option -c to support
	COLLAPSE_RANGE
Date: Thu, 27 Feb 2014 11:35:07 +0100
Message-Id: <1393497307-9205-1-git-send-email-dongsu.park@profitbricks.com>
In-Reply-To: <CAKYAXd-ngheH2njza1Tq0umONrF+VBrmB+9SiVG1Q=DsM0PBBA@mail.gmail.com>
References: <CAKYAXd-ngheH2njza1Tq0umONrF+VBrmB+9SiVG1Q=DsM0PBBA@mail.gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>

From: Dongsu Park <dongsu.park@profitbricks.com>

Introduce a new option -c (or --collapse-range) to support a new flag
FALLOC_FL_COLLAPSE_RANGE for fallocate(2). It will nullify a particular
range [offset, offset+len] by shifting extents beyond the range to the
beginning of the hole.

To test that, it's necessary to apply kernel patches in the patchset
"fs: Introduce new flag (FALLOC_FL_COLLAPSE_RANGE) for fallocate" [1],
as well as "[PATCH v6] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
fallocate". [2]

As discussed in the thread "[PATCH RESEND 3/10] ext4: Add support
FALLOC_FL_COLLAPSE_RANGE for fallocate", [3] this patch to util-linux
will be useful for testing collapse-range with fsstress.

[1] https://lkml.org/lkml/2014/2/18/374
[2] https://lkml.org/lkml/2014/2/20/318
[3] https://lkml.org/lkml/2014/2/18/83

Cc: Karel Zak <kzak@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---

Changelog:

v2:
 - update patch description by replacing xfstests with fsstress
 - update help message by replacing hole with space

 sys-utils/fallocate.1 |  7 +++++++
 sys-utils/fallocate.c | 45 ++++++++++++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/sys-utils/fallocate.1 b/sys-utils/fallocate.1
index 8a3aa4f..634c595 100644
--- a/sys-utils/fallocate.1
+++ b/sys-utils/fallocate.1
@@ -6,6 +6,7 @@ fallocate \- preallocate or deallocate space to a file
 .B fallocate
 .RB [ \-n ]
 .RB [ \-p ]
+.RB [ \-c ]
 .RB [ \-o
 .IR offset ]
 .B \-l
@@ -54,6 +55,12 @@ implied.
 .IP
 You can think of this as doing a "\fBcp --sparse\fP" and
 renaming the dest file as the original, without the need for extra disk space.
+.IP "\fB\-c, \-\-collapse-range\fP"
+Collapse a particular file range to nullify the hole. Extents beyond the range
+[offset, offset+length] will be shifted to the beginning of hole. Hence this
+command does not leave a hole, while \fI\-\-punch-hole\fP leaves a hole
+instead of shifting extents. Both offset and length should be aligned to
+the block size of filesystem.
 .IP "\fB\-o, \-\-offset\fP \fIoffset\fP
 Specifies the beginning offset of the allocation, in bytes.
 .IP "\fB\-l, \-\-length\fP \fIlength\fP
diff --git a/sys-utils/fallocate.c b/sys-utils/fallocate.c
index d8a74bf..3c8a8d2 100644
--- a/sys-utils/fallocate.c
+++ b/sys-utils/fallocate.c
@@ -39,7 +39,8 @@
 #endif
 
 #if defined(HAVE_LINUX_FALLOC_H) && \
-    (!defined(FALLOC_FL_KEEP_SIZE) || !defined(FALLOC_FL_PUNCH_HOLE))
+    (!defined(FALLOC_FL_KEEP_SIZE) || !defined(FALLOC_FL_PUNCH_HOLE) || \
+     !defined(FALLOC_FL_COLLAPSE_RANGE))
 # include <linux/falloc.h>	/* non-libc fallback for FALLOC_FL_* flags */
 #endif
 
@@ -51,6 +52,10 @@
 # define FALLOC_FL_PUNCH_HOLE 2
 #endif
 
+#ifndef FALLOC_FL_COLLAPSE_RANGE
+# define FALLOC_FL_COLLAPSE_RANGE 8
+#endif
+
 #include "nls.h"
 #include "strutils.h"
 #include "c.h"
@@ -66,12 +71,13 @@ static void __attribute__((__noreturn__)) usage(FILE *out)
 	fprintf(out,
 	      _(" %s [options] <filename>\n"), program_invocation_short_name);
 	fputs(USAGE_OPTIONS, out);
-	fputs(_(" -d, --dig-holes     detect and dig holes\n"), out);
-	fputs(_(" -l, --length <num>  length of the (de)allocation, in bytes\n"), out);
-	fputs(_(" -n, --keep-size     don't modify the length of the file\n"), out);
-	fputs(_(" -o, --offset <num>  offset of the (de)allocation, in bytes\n"), out);
-	fputs(_(" -p, --punch-hole    punch holes in the file\n"), out);
-	fputs(_(" -v, --verbose       verbose mode\n"), out);
+	fputs(_(" -c, --collapse-range collapse space in the file\n"), out);
+	fputs(_(" -d, --dig-holes      detect and dig holes\n"), out);
+	fputs(_(" -l, --length <num>   length of the (de)allocation, in bytes\n"), out);
+	fputs(_(" -n, --keep-size      don't modify the length of the file\n"), out);
+	fputs(_(" -o, --offset <num>   offset of the (de)allocation, in bytes\n"), out);
+	fputs(_(" -p, --punch-hole     punch holes in the file\n"), out);
+	fputs(_(" -v, --verbose        verbose mode\n"), out);
 
 	fputs(USAGE_SEPARATOR, out);
 	fputs(USAGE_HELP, out);
@@ -258,15 +264,16 @@ int main(int argc, char **argv)
 	loff_t	offset = 0;
 
 	static const struct option longopts[] = {
-	    { "help",       0, 0, 'h' },
-	    { "version",    0, 0, 'V' },
-	    { "keep-size",  0, 0, 'n' },
-	    { "punch-hole", 0, 0, 'p' },
-	    { "dig-holes",  0, 0, 'd' },
-	    { "offset",     1, 0, 'o' },
-	    { "length",     1, 0, 'l' },
-	    { "verbose",    0, 0, 'v' },
-	    { NULL,         0, 0, 0 }
+	    { "help",           0, 0, 'h' },
+	    { "version",        0, 0, 'V' },
+	    { "keep-size",      0, 0, 'n' },
+	    { "punch-hole",     0, 0, 'p' },
+	    { "collapse-range", 0, 0, 'c' },
+	    { "dig-holes",      0, 0, 'd' },
+	    { "offset",         1, 0, 'o' },
+	    { "length",         1, 0, 'l' },
+	    { "verbose",        0, 0, 'v' },
+	    { NULL,             0, 0, 0 }
 	};
 
 	setlocale(LC_ALL, "");
@@ -274,7 +281,8 @@ int main(int argc, char **argv)
 	textdomain(PACKAGE);
 	atexit(close_stdout);
 
-	while ((c = getopt_long(argc, argv, "hvVnpdl:o:", longopts, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "hvVncpdl:o:", longopts, NULL))
+			!= -1) {
 		switch(c) {
 		case 'h':
 			usage(stdout);
@@ -282,6 +290,9 @@ int main(int argc, char **argv)
 		case 'V':
 			printf(UTIL_LINUX_VERSION);
 			return EXIT_SUCCESS;
+		case 'c':
+			mode |= FALLOC_FL_COLLAPSE_RANGE;
+			break;
 		case 'p':
 			mode |= FALLOC_FL_PUNCH_HOLE;
 			/* fall through */
-- 
1.8.5.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
