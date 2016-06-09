Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A04F7CA2
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:44:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8BF5AC001
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 09:44:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rIGcBhl5ScUZ9k65 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 09:44:36 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E6C074A6
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 11:44:35 -0500 (CDT)
Subject: [PATCH 4/4] xfsprogs: add online relabel commands
References: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0d905426-649e-278a-1e85-6dca646cb812@sandeen.net>
Date: Thu, 9 Jun 2016 11:44:35 -0500
MIME-Version: 1.0
In-Reply-To: <c1922d3d-208c-3699-0a36-26108a4f44de@sandeen.net>
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
To: xfs@oss.sgi.com

This adds a get/set label command to xfs_io, and updates
the xfs_admin script to use it rather than xfs_db if
the filesystem is mounted.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Still needs a man page update.
The new xfs_io command is:

# xfs_io> label [newlabel]

The hack to flush the bdev is maybe not right, I'm
not sure xfs has actually gotten the change out to sector 0
yet at this point...

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index d42446b..02485b0 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -16,7 +16,7 @@ do
 	f)	DB_OPTS=$DB_OPTS" -f";;
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	L)	LABEL_OPT=$OPTARG;;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
@@ -32,10 +32,18 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	1)	if [ -n "$DB_OPTS" ]
+	1)	DIR=`grep -w $1 /proc/mounts | awk '{print $2}'`
+		if [ -n "$LABEL_OPT" -a -n "$DIR" ]
 		then
-			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			eval io/xfs_io -c "'label $LABEL_OPT'" $DIR
 			status=$?
+		else
+			DB_OPTS=$DB_OPTS" -c 'label "$LABEL_OPT"'"
+		fi
+		if [ -n "$DB_OPTS" ]
+		then
+			eval db/xfs_db -x -p xfs_admin $DB_OPTS $1
+			status=`expr $? + $status`
 		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
diff --git a/io/Makefile b/io/Makefile
index 0b53f41..8f46340 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -9,9 +9,9 @@ LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
-	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
-	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	sync.c truncate.c reflink.c
+	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c label.c \
+	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c \
+	shutdown.c sync.c truncate.c reflink.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index 51f1f5c..0c08a57 100644
--- a/io/init.c
+++ b/io/init.c
@@ -65,6 +65,7 @@ init_commands(void)
 	help_init();
 	imap_init();
 	inject_init();
+	label_init();
 	seek_init();
 	madvise_init();
 	mincore_init();
diff --git a/io/io.h b/io/io.h
index 172b1f8..560ad52 100644
--- a/io/io.h
+++ b/io/io.h
@@ -102,6 +102,7 @@ extern void		getrusage_init(void);
 extern void		help_init(void);
 extern void		imap_init(void);
 extern void		inject_init(void);
+extern void		label_init(void);
 extern void		mmap_init(void);
 extern void		open_init(void);
 extern void		parent_init(void);
diff --git a/io/label.c b/io/label.c
new file mode 100644
index 0000000..721f27b
--- /dev/null
+++ b/io/label.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2016 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include "platform_defs.h"
+#include "libxfs.h"
+#include "path.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+
+#ifndef FS_IOC_GET_FSLABEL
+#define FSLABEL_MAX 256	/* Max chars for the interface; each fs may differ */
+#define FS_IOC_GET_FSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
+#define FS_IOC_SET_FSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
+#endif
+
+static cmdinfo_t label_cmd;
+
+static int
+label_f(
+	int		argc,
+	char		**argv)
+{
+	int		error;
+	char		label[FSLABEL_MAX];
+
+	if (argc == 1) {
+		memset(&label, 0, sizeof(label));
+		error = ioctl(file->fd, FS_IOC_GET_FSLABEL, &label);
+	} else {
+		fs_path_t	*fs;	/* mount point information */
+		int 		fd;
+
+		strncpy(label, argv[1], sizeof(label));
+		error = ioctl(file->fd, FS_IOC_SET_FSLABEL, &label);
+		/* best effort to flush bdev cache */
+		fs_table_initialise(0, NULL, 0, NULL);
+		fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
+		if (fs) {
+			fd = open(fs->fs_name, O_RDONLY);
+			if (fd >= 0) {
+				ioctl(fd, BLKFLSBUF, 0);
+				close(fd);
+			}
+		}
+	}
+
+	if (error)
+		perror("label:");
+	else
+		printf("label = \"%s\"\n", label);
+
+	return error;
+
+}
+
+void
+label_init(void)
+{
+	label_cmd.name = "label";
+	label_cmd.cfunc = label_f;
+	label_cmd.argmin = 0;
+	label_cmd.argmax = 1;
+	label_cmd.args = _("[label]");
+	label_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	label_cmd.oneline =
+		_("queries or sets the filesystem label while mounted");
+
+	add_command(&label_cmd);
+}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
