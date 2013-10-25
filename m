Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 49C2929E04
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 15:56:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 23B218F804C
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 13:56:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 05ppztd8JQlobtFN for <xfs@oss.sgi.com>;
	Fri, 25 Oct 2013 13:56:44 -0700 (PDT)
Message-Id: <20131025205559.519204526@suse.com>
Date: Fri, 25 Oct 2013 16:52:47 -0400
From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 1/3] [PATCH 1/3] xfstests: add test for global metadata
	reservation publishing
References: <20131025205246.269327744@suse.com>
Content-Disposition: inline;
	filename=0001-xfstests-add-test-for-global-metadata-reservation-pu.patch
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
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>

My publishing patchset added the ability for the kernel to report
the size of the global metadata reservation via ioctl and sysfs.

This test confirms that we get sane results on an empty file system.

ENOTTY and missing /sys/fs/btrfs/<fsid>/allocation are not considered
failures.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 src/Makefile             |  3 +-
 src/btrfs_ioctl_helper.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/100          | 92 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/100.out      |  2 ++
 4 files changed, 186 insertions(+), 1 deletion(-)
 create mode 100644 src/btrfs_ioctl_helper.c
 create mode 100755 tests/btrfs/100
 create mode 100644 tests/btrfs/100.out

diff --git a/src/Makefile b/src/Makefile
index 84c8297..299f675 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec \
+	btrfs_ioctl_helper
 
 SUBDIRS =
 
diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
new file mode 100644
index 0000000..a88b7b5
--- /dev/null
+++ b/src/btrfs_ioctl_helper.c
@@ -0,0 +1,90 @@
+#include <sys/ioctl.h>
+#include <stdio.h>
+#include <sys/fcntl.h>
+#include <errno.h>
+#include <string.h>
+#include <stdint.h>
+#include <unistd.h>
+
+#ifndef BTRFS_IOCTL_MAGIC
+#define BTRFS_IOCTL_MAGIC 0x94
+#endif
+
+#ifndef BTRFS_IOC_GLOBAL_RSV
+#define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, uint64_t)
+#endif
+
+static int global_rsv_ioctl(int fd, int argc, char *argv[])
+{
+	uint64_t reserved;
+	int ret = ioctl(fd, BTRFS_IOC_GLOBAL_RSV, &reserved);
+	if (ret)
+		return -errno;
+
+	printf("%llu\n", (unsigned long long)reserved);
+	return 0;
+}
+
+#define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
+	{ .name = #_ioctl_name, .ioctl_cmd = BTRFS_IOC_##_ioctl_name, \
+	  .handler = _handler, }
+
+struct ioctl_table_entry {
+	const char *name;
+	unsigned ioctl_cmd;
+	int (*handler)(int fd, int argc, char *argv[]);
+};
+
+static struct ioctl_table_entry ioctls[] = {
+	IOCTL_TABLE_ENTRY(GLOBAL_RSV, global_rsv_ioctl),
+};
+
+int
+main(int argc, char *argv[])
+{
+	int fd;
+	int ret;
+	struct ioctl_table_entry *entry = NULL;
+	int i;
+
+	if (argc < 3) {
+		fprintf(stderr,
+			"usage: %s <fs mount point> <ioctl name> [args..]\n",
+			argv[0]);
+		return 1;
+	}
+
+	fd = open(argv[1], O_RDONLY|O_DIRECTORY);
+	if (fd < 0) {
+		perror(argv[1]);
+		return 1;
+	}
+
+	for (i = 0; i < (sizeof(ioctls)/sizeof(ioctls[0])); i++) {
+		if (strcmp(argv[2], ioctls[i].name) == 0) {
+			entry = &ioctls[i];
+			break;
+		}
+	}
+
+	if (!entry) {
+		fprintf(stderr, "ERROR: unknown ioctl %s\n", argv[2]);
+		close(fd);
+		return 1;
+	}
+
+	ret = entry->handler(fd, argc - 3, argv + 3);
+	if (ret == -ENOTTY) {
+		printf("Not implemented.\n");
+		close(fd);
+		return 0;
+	} else if (ret) {
+		fprintf(stderr, "ERROR: %s failed: %s\n",
+			entry->name, strerror(-ret));
+		close(fd);
+		return 1;
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/tests/btrfs/100 b/tests/btrfs/100
new file mode 100755
index 0000000..d2a40b4
--- /dev/null
+++ b/tests/btrfs/100
@@ -0,0 +1,92 @@
+#!/bin/bash
+# FA QA Test No. 100
+#
+# Test global metadata reservation reporting
+#
+# 1) Create empty file system
+# 2) Call the BTRFS_IOC_GLOBAL_RSV ioctl and confirm it is 0 < x < 10MB
+# 3) Read the /sys/fs/btrfs/<fsid>/allocation/global_rsv_reserved file
+#    and confirm the value is 0 < x < 10 MB
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 SUSE, All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=$(basename $0)
+seqres=$RESULT_DIR/$seq
+echo "== QA output created by $seq"
+
+here=$(pwd)
+tmp=/tmp/$$
+status=1
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter.btrfs
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+fsid() {
+	$BTRFS_UTIL_PROG filesystem show $1|awk '/uuid:/ {print $NF}'
+}
+
+# Check to see if the reservation is 0 < x <= 10MB
+# At the time of this writing, it should always be exactly 4 MB
+# but that is an implementation detail subject to change.
+check_reserved() {
+	reserved="$2"
+	method="$3"
+	if [ "$1" != 0 ]; then
+		echo "$method: failed: $reserved"
+		exit 1
+	fi
+	if [ "$reserved" = "Not implemented." ]; then
+		echo "Skipping ioctl test. Not implemented." >> $seqres.full
+		return
+	fi
+	if [ -n "$(echo $reserved | tr -d 0-9)" ]; then
+		echo "ERROR: numerical value expected (got $reserved)"
+		exit 1
+	fi
+	if [ "$reserved" -le 0 -o \
+	       "$reserved" -gt "$(( 10 * 1024 * 1024 ))" ]; then
+		echo "$method: out of range: $reserved."
+		exit
+	fi
+}
+
+# ioctl
+reserved="$(src/btrfs_ioctl_helper $SCRATCH_MNT GLOBAL_RSV 2>&1)"
+check_reserved $? "$reserved" "ioctl"
+
+# sysfs
+# If this directory is here, the files must be here as well
+SYSFS_PREFIX="/sys/fs/btrfs/$(fsid $SCRATCH_DEV)/allocation"
+if [ -d "$SYSFS_PREFIX" ]; then
+	reserved="$(cat $SYSFS_PREFIX/global_rsv_reserved 2>&1)"
+	check_reserved $? "$reserved" "sysfs:reserved"
+	size="$(cat $SYSFS_PREFIX/global_rsv_size 2>&1)"
+	check_reserved $? "$size" "sysfs:size"
+fi
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/100.out b/tests/btrfs/100.out
new file mode 100644
index 0000000..798c013
--- /dev/null
+++ b/tests/btrfs/100.out
@@ -0,0 +1,2 @@
+QA output created by 100
+Silence is golden
-- 
1.8.1.4



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
