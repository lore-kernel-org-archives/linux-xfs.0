Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o54FOguW231190 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 10:24:43 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BD9E1E05EB3
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 08:27:10 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id njoMZgyJtLfS8wcG for
	<xfs@oss.sgi.com>; Fri, 04 Jun 2010 08:27:10 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 804FA46AD993
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 10:27:10 -0500 (CDT)
Message-ID: <4C091B4E.5030503@sandeen.net>
Date: Fri, 04 Jun 2010 10:27:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: use stat not lstat when examining devices
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

If you try running xfstests on lvm volumes which are symlinks,
it'll fail to run several tests because our _require_scratch 
framework ultimately uses lstat not stat, and does not think 
the lvm device (which is usually a symlink to a dm-X device) 
is a block device.  Sigh.

It seems a little crummy to cut and paste lstat64.c to stat64.c
but then adding an "-L" option to lstat64 to -not- stat the link
seems all bass-ackwards.

We need something like this, but I'm open to suggestions of a
better implementation.  Even /usr/bin/stat -l may suffice, I don't
know why we roll our own lstat64 binary.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 6bf1e12..57b28c6 100644
--- a/common.rc
+++ b/common.rc
@@ -584,7 +584,7 @@ _is_block_dev()
 	exit 1
     fi
 
-    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
+    [ -b $1 ] && src/stat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
 }
 
 # Do a command, log it to $seq.full, optionally test return status
diff --git a/src/Makefile b/src/Makefile
index 976133d..1144547 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -5,7 +5,7 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
+TARGETS = dirstress fill fill2 getpagesize holes stat64 lstat64 \
 	nametest permname randholes runas truncfile usemem \
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
diff --git a/src/stat64.c b/src/stat64.c
new file mode 100644
index 0000000..3b68c66
--- /dev/null
+++ b/src/stat64.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2000-2002 Silicon Graphics, Inc.
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
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+
+long	timebuf;
+
+void
+timesince(long timesec)
+{
+	long	d_since;	/* days */
+	long	h_since;	/* hours */
+	long	m_since;	/* minutes */
+	long	s_since;	/* seconds */
+
+	s_since = timebuf - timesec;
+	d_since = s_since / 86400l ;
+	s_since -= d_since * 86400l ;
+	h_since = s_since / 3600l ;
+	s_since -= h_since * 3600l ;
+	m_since = s_since / 60l ;
+	s_since -= m_since * 60l ;
+
+	printf("(%05ld.%02ld:%02ld:%02ld)\n",
+			d_since, h_since, m_since, s_since);
+}
+
+void
+usage(void)
+{
+	fprintf(stderr, "Usage: lstat64 [-t] filename ...\n");
+	exit(1);
+}
+
+int
+main(int argc, char **argv)
+{
+	struct stat64	sbuf;
+	int		i, c;
+	int		terse_flag = 0;
+
+	while ((c = getopt(argc, argv, "t")) != EOF) {
+		switch (c) {
+			case 't':
+				terse_flag = 1;
+				break;
+
+			case '?':
+				usage();
+		}
+	}
+	if (optind == argc) {
+		usage();
+	}
+
+	time(&timebuf);
+
+	for (i = optind; i < argc; i++) {
+		char mode[] = "----------";
+
+		if( lstat64(argv[i], &sbuf) < 0) {
+			perror(argv[i]);
+			continue;
+		}
+
+		if (terse_flag) {
+			printf("%s %llu ", argv[i], (unsigned long long)sbuf.st_size);
+		}
+		else {
+			printf("  File: \"%s\"\n", argv[i]);
+			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
+		}
+
+		if (sbuf.st_mode & (S_IEXEC>>6))
+			mode[9] = 'x';
+		if (sbuf.st_mode & (S_IWRITE>>6))
+			mode[8] = 'w';
+		if (sbuf.st_mode & (S_IREAD>>6))
+			mode[7] = 'r';
+		if (sbuf.st_mode & (S_IEXEC>>3))
+			mode[6] = 'x';
+		if (sbuf.st_mode & (S_IWRITE>>3))
+			mode[5] = 'w';
+		if (sbuf.st_mode & (S_IREAD>>3))
+			mode[4] = 'r';
+		if (sbuf.st_mode & S_IEXEC)
+			mode[3] = 'x';
+		if (sbuf.st_mode & S_IWRITE)
+			mode[2] = 'w';
+		if (sbuf.st_mode & S_IREAD)
+			mode[1] = 'r';
+		if (sbuf.st_mode & S_ISVTX)
+			mode[9] = 't';
+		if (sbuf.st_mode & S_ISGID)
+			mode[6] = 's';
+		if (sbuf.st_mode & S_ISUID)
+			mode[3] = 's';
+
+		if (!terse_flag)
+			printf("   Filetype: ");
+		switch (sbuf.st_mode & S_IFMT) {
+		case S_IFSOCK:	
+			if (!terse_flag)
+				puts("Socket");
+			mode[0] = 's';
+			break;
+		case S_IFDIR:	
+			if (!terse_flag)
+				puts("Directory");
+			mode[0] = 'd';
+			break;
+		case S_IFCHR:	
+			if (!terse_flag)
+				puts("Character Device");
+			mode[0] = 'c';
+			break;
+		case S_IFBLK:	
+			if (!terse_flag)
+				puts("Block Device");
+			mode[0] = 'b';
+			break;
+		case S_IFREG:	
+			if (!terse_flag)
+				puts("Regular File");
+			mode[0] = '-';
+			break;
+		case S_IFLNK:	
+			if (!terse_flag)
+				puts("Symbolic Link");
+			mode[0] = 'l';
+			break;
+		case S_IFIFO:	
+			if (!terse_flag)
+				puts("Fifo File");
+			mode[0] = 'f';
+			break;
+		default:	
+			if (!terse_flag)
+				puts("Unknown");
+			mode[0] = '?';
+		}
+
+		if (terse_flag) {
+			printf("%s %d,%d\n", mode, (int)sbuf.st_uid, (int)sbuf.st_gid);
+			continue;
+		}
+
+		printf("  Mode: (%04o/%s)", (unsigned int)(sbuf.st_mode & 07777), mode);
+		printf("         Uid: (%d)", (int)sbuf.st_uid);
+		printf("  Gid: (%d)\n", (int)sbuf.st_gid);
+		printf("Device: %2d,%-2d", major(sbuf.st_dev),
+				minor(sbuf.st_dev));
+		printf("  Inode: %-9llu", (unsigned long long)sbuf.st_ino);
+		printf(" Links: %-5ld", (long)sbuf.st_nlink);
+
+		if ( ((sbuf.st_mode & S_IFMT) == S_IFCHR)
+		    || ((sbuf.st_mode & S_IFMT) == S_IFBLK) )
+			printf("     Device type: %2d,%-2d\n",
+				major(sbuf.st_rdev), minor(sbuf.st_rdev));
+		else
+			printf("\n");
+
+		printf("Access: %.24s",ctime(&sbuf.st_atime));
+		timesince(sbuf.st_atime);
+		printf("Modify: %.24s",ctime(&sbuf.st_mtime));
+		timesince(sbuf.st_mtime);
+		printf("Change: %.24s",ctime(&sbuf.st_ctime));
+		timesince(sbuf.st_ctime);
+
+		if (i+1 < argc)
+			printf("\n");
+	}
+	exit(0);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
