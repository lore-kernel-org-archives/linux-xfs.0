Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 935DC7F55
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 05:17:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 622393040BA
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 03:17:06 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UykGQf7fQ20DmRCq (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 03:17:01 -0800 (PST)
From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/2] btrfs: add small program for clone testing
Date: Wed,  5 Feb 2014 12:16:48 +0100
Message-Id: <1391599009-2402-2-git-send-email-ddiss@suse.de>
In-Reply-To: <1391599009-2402-1-git-send-email-ddiss@suse.de>
References: <1391599009-2402-1-git-send-email-ddiss@suse.de>
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
Cc: David Disseldorp <ddiss@suse.de>, dsterba@suse.cz, linux-btrfs@vger.kernel.org

The cloner program is capable of cloning files using the BTRFS_IOC_CLONE
and BTRFS_IOC_CLONE_RANGE ioctls.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 src/Makefile |   2 +-
 src/cloner.c | 168 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 src/cloner.c

diff --git a/src/Makefile b/src/Makefile
index 84c8297..6509f2d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner
 
 SUBDIRS =
 
diff --git a/src/cloner.c b/src/cloner.c
new file mode 100644
index 0000000..59defbb
--- /dev/null
+++ b/src/cloner.c
@@ -0,0 +1,168 @@
+/*
+ *  Tiny program to perform file (range) clones using raw Btrfs ioctls.
+ *  It should only be needed until btrfs-progs has an xfs_io equivalent.
+ *
+ *  Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+
+struct btrfs_ioctl_clone_range_args {
+	int64_t src_fd;
+	uint64_t src_offset;
+	uint64_t src_length;
+	uint64_t dest_offset;
+};
+
+#define BTRFS_IOCTL_MAGIC 0x94
+#define BTRFS_IOC_CLONE       _IOW(BTRFS_IOCTL_MAGIC, 9, int)
+#define BTRFS_IOC_CLONE_RANGE _IOW(BTRFS_IOCTL_MAGIC, 13, \
+				   struct btrfs_ioctl_clone_range_args)
+
+static void
+usage(char *name, const char *msg)
+{
+	printf("Fatal: %s\n"
+	       "Usage:\n"
+	       "%s [options] <src_file> <dest_file>\n"
+	       "\tA full file clone (reflink) is performed by default, "
+	       "unless any of the following are specified:\n"
+	       "\t-s <offset>:	source file offset (default = 0)\n"
+	       "\t-d <offset>:	destination file offset (default = 0)\n"
+	       "\t-l <length>:	length of clone (default = 0)\n",
+	       msg, name);
+	_exit(1);
+}
+
+static int
+clone_file(int src_fd, int dst_fd)
+{
+	int ret = ioctl(dst_fd, BTRFS_IOC_CLONE, src_fd);
+	if (ret != 0)
+		ret = errno;
+	return ret;
+}
+
+static int
+clone_file_range(int src_fd, int dst_fd, uint64_t src_off, uint64_t dst_off,
+		 uint64_t len)
+{
+	struct btrfs_ioctl_clone_range_args cr_args;
+	int ret;
+
+	memset(&cr_args, 0, sizeof(cr_args));
+	cr_args.src_fd = src_fd;
+	cr_args.src_offset = src_off;
+	cr_args.src_length = len;
+	cr_args.dest_offset = dst_off;
+	ret = ioctl(dst_fd, BTRFS_IOC_CLONE_RANGE, &cr_args);
+	if (ret != 0)
+		ret = errno;
+	return ret;
+}
+
+int
+main(int argc, char **argv)
+{
+	bool full_file = true;
+	uint64_t src_off = 0;
+	uint64_t dst_off = 0;
+	uint64_t len = 0;
+	char *src_file;
+	int src_fd;
+	char *dst_file;
+	int dst_fd;
+	int ret;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
+		switch (opt) {
+		case 's':
+			src_off = atoi(optarg);
+			full_file = false;
+			break;
+		case 'd':
+			dst_off = atoi(optarg);
+			full_file = false;
+			break;
+		case 'l':
+			len = atoi(optarg);
+			full_file = false;
+			break;
+		default:
+			usage(argv[0], "invalid argument");
+		}
+	}
+
+	/* should be exactly two args left */
+	if (optind != argc - 2)
+		usage(argv[0], "src_file and dst_file arguments are madatory");
+
+	src_file = (char *)strdup(argv[optind++]);
+	if (src_file == NULL) {
+		ret = ENOMEM;
+		goto err_out;
+	}
+	dst_file = (char *)strdup(argv[optind++]);
+	if (dst_file == NULL) {
+		ret = ENOMEM;
+		goto err_src_free;
+	}
+
+	src_fd = open(src_file, O_RDONLY);
+	if (src_fd == -1) {
+		ret = errno;
+		goto err_dst_free;
+	}
+	dst_fd = open(dst_file, O_CREAT | O_WRONLY, 0644);
+	if (dst_fd == -1) {
+		ret = errno;
+		goto err_src_close;
+	}
+
+	if (full_file) {
+		ret = clone_file(src_fd, dst_fd);
+	} else {
+		ret = clone_file_range(src_fd, dst_fd, src_off, dst_off, len);
+	}
+	if (ret != 0) {
+		printf("clone failed with %d\n", ret);
+		goto err_dst_close;
+	}
+
+	ret = 0;
+err_dst_close:
+	ret |= close(dst_fd);
+err_src_close:
+	ret |= close(src_fd);
+err_dst_free:
+	free(dst_file);
+err_src_free:
+	free(src_file);
+err_out:
+	return ret;
+}
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
