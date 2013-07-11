Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 215187F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 13:19:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 000B28F8037
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 11:19:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FvQYVpbkmrXefHsl for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 11:19:14 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BIJDFi012628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 14:19:13 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r6BIJDPV023198
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 14:19:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfsprogs/io: add getdents command
Date: Thu, 11 Jul 2013 14:23:54 -0400
Message-Id: <1373567034-7534-1-git-send-email-bfoster@redhat.com>
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

getdents reads the directory entries from an open directory from
the provided offset (or 0 if not specified). On completion,
getdents prints summary information regarding the number of
operations and bytes transferred. Options are available to specify
the starting offset, buffer size and verbose mode to dump directory
entry information from the buffer.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This is something I hacked together for testing something for gluster. Thoughts
appreciated!

Brian

 io/Makefile   |   4 ++
 io/getdents.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c     |   1 +
 io/io.h       |   1 +
 4 files changed, 181 insertions(+)
 create mode 100644 io/getdents.c

diff --git a/io/Makefile b/io/Makefile
index 50edf91..cfd1b11 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -80,6 +80,10 @@ ifeq ($(HAVE_PREADV),yes)
 LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
 endif
 
+ifeq ($(PKG_PLATFORM),linux)
+CFILES += getdents.c
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/getdents.c b/io/getdents.c
new file mode 100644
index 0000000..2b167f2
--- /dev/null
+++ b/io/getdents.c
@@ -0,0 +1,175 @@
+/*
+ * Copyright (c) 2013 Red Hat, Inc.
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
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+#include <sys/syscall.h>
+
+static struct cmdinfo getdents_cmd;
+
+static char *gd_buf;
+static size_t gd_bufsz;
+
+struct linux_dirent {
+	unsigned long	d_ino;     /* Inode number */
+	unsigned long	d_off;     /* Offset to next linux_dirent */
+	unsigned short	d_reclen;  /* Length of this linux_dirent */
+	char		d_name[];  /* Filename (null-terminated) */
+};
+
+static void
+dump_dir_buffer(
+	struct linux_dirent *dirp,
+	long long offset,
+	long long length)
+{
+	while (length > 0) {
+		printf("%08llx: 0x%lx (%s)\n",
+			offset, dirp->d_ino, dirp->d_name);
+
+		offset = dirp->d_off;
+		length -= dirp->d_reclen;
+
+		dirp = (struct linux_dirent *) ((char *) dirp + dirp->d_reclen);
+	}
+}
+
+static int
+do_getdents(char *buf, unsigned int len)
+{
+	return syscall(SYS_getdents, file->fd, buf, len);
+}
+
+static int
+read_directory(
+	long long offset,
+	long long length,
+	int dump,
+	long long *total)
+{
+	int bytes;
+	int count = 0;
+
+	offset = lseek(file->fd, offset, SEEK_SET);
+	if (offset < 0)
+		perror("lseek");
+
+	*total = 0;
+	while (1) {
+		bytes = do_getdents(gd_buf, gd_bufsz);
+		if (!bytes)
+			break;
+		if (bytes < 0)
+			perror("getdents");
+
+		if (dump)
+			dump_dir_buffer((struct linux_dirent *) gd_buf, offset, bytes);
+
+		*total += bytes;
+		count++;
+
+		/*
+		 * Keep filling the buffer until we've read at least as much
+		 * data as requested.
+		 */
+		if (length > 0 && *total >= length)
+			break;
+	}
+
+	return count;
+}
+
+static int
+getdents_f(
+	int argc,
+	char **argv)
+{
+	int cnt;
+	long long total;
+	int c;
+	size_t fsblocksize, fssectsize;
+	struct timeval t1, t2;
+	char s1[64], s2[64], ts[64];
+	long long offset = -1;
+	long long length = -1;
+	int verbose = 0;
+
+	init_cvtnum(&fsblocksize, &fssectsize);
+	gd_bufsz = fsblocksize;
+
+	while ((c = getopt(argc, argv, "b:l:o:v")) != EOF) {
+		switch (c) {
+		case 'b':
+			gd_bufsz = cvtnum(fsblocksize, fssectsize, optarg);
+			break;
+		case 'l':
+			length = cvtnum(fsblocksize, fssectsize, optarg);
+			break;
+		case 'o':
+			offset = cvtnum(fsblocksize, fssectsize, optarg);
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			return command_usage(&getdents_cmd);
+		}
+	}
+
+	gd_buf = malloc(gd_bufsz);
+	if (!gd_buf)
+		return -1;
+
+	if (offset == -1)
+		offset = lseek(file->fd, 0, SEEK_CUR);
+
+	gettimeofday(&t1, NULL);
+	cnt = read_directory(offset, length, verbose, &total);
+	gettimeofday(&t2, NULL);
+
+	t2 = tsub(t2, t1);
+	timestr(&t2, ts, sizeof(ts), 0);
+
+	cvtstr(total, s1, sizeof(s1));
+	cvtstr(tdiv(total, t2), s2, sizeof(s2));
+
+	printf(_("read %lld bytes from offset %lld\n"), total, offset);
+	printf(_("%s, %d ops, %s (%s/sec and %.4f ops/sec)\n"),
+		s1, cnt, ts, s2, tdiv(cnt, t2));
+
+	free(gd_buf);
+
+	return 0;
+}
+
+void
+getdents_init(void)
+{
+	getdents_cmd.name = "getdents";
+	getdents_cmd.cfunc = getdents_f;
+	getdents_cmd.argmax = 6;
+	getdents_cmd.flags = CMD_NOMAP_OK|CMD_FOREIGN_OK;
+	getdents_cmd.args = _("[-v][-b buffer size][-o offset][-l length]");
+	getdents_cmd.oneline = _("read directory entries");
+
+	add_command(&getdents_cmd);
+}
diff --git a/io/init.c b/io/init.c
index ca3055a..44cce44 100644
--- a/io/init.c
+++ b/io/init.c
@@ -60,6 +60,7 @@ init_commands(void)
 	file_init();
 	freeze_init();
 	fsync_init();
+	getdents_init();
 	getrusage_init();
 	help_init();
 	imap_init();
diff --git a/io/io.h b/io/io.h
index 91f0e3e..5658b13 100644
--- a/io/io.h
+++ b/io/io.h
@@ -94,6 +94,7 @@ extern void		bmap_init(void);
 extern void		file_init(void);
 extern void		freeze_init(void);
 extern void		fsync_init(void);
+extern void		getdents_init(void);
 extern void		getrusage_init(void);
 extern void		help_init(void);
 extern void		imap_init(void);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
