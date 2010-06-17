Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5H6ZJlY164796 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 01:35:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51D56B0ACA1
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 23:41:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	VABwg2OOYxvTZCwe for <xfs@oss.sgi.com>;
	Wed, 16 Jun 2010 23:41:37 -0700 (PDT)
Received: from dastard (unverified [121.44.96.63])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	28200299-1927428
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 16:07:53 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OP8jN-0006ZD-SU
	for xfs@oss.sgi.com; Thu, 17 Jun 2010 16:37:41 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OP8jM-0003DT-0u
	for xfs@oss.sgi.com; Thu, 17 Jun 2010 16:37:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: test open_by_handle() on unlinked and freed inode
	clusters V2
Date: Thu, 17 Jun 2010 16:37:39 +1000
Message-Id: <1276756659-12338-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When Christoph and I were discussing bulkstat coherency on IRC, we
realised that inode lookup from bulkstat was not actually looking up
the inode allocation btree in xfs_imap() before reading the inode
buffer from disk in xfs_iread(). Bulkstat uses the same lookup
mechanism as handle validation to avoid shutting down the filesystem
if inode numbers that point to non-inode buffers (i.e. invalid) are
passed in the handle.

The problem with this is that when we delete inodes from disk and we
remove the inode chunk (i.e. deallocate inodes) we mark both the
inodes in memory and the cluster buffer as stale, thereby preventing
it from being written back to disk. The result of this is that some
number of inodes remain on disk looking like allocated, in use
inodes (i.e.  di_mode is not zero).

Hence if we get a cold cache lookup from a stale handle that
references such an inode, we can read the inode off disk even though
it has been deleted because we don't check if the inode is allocated
or not.  If the inode chunk has not been overwritten, then the inode
read will succeed and the handle-to-dentry conversion will not error
out like it is supposed to. The result is that stale NFS filehandles
and open_by_handle() will succeed incorrectly on unlinked files for
cold cache lookups.

This is a bug that has been present ever since the inode chunk
deletion code was implemented. This test exercises the problem and
documents the hoops you have to jump through to reproduce it.

Version 2:

o suppress mkfs output that was unnoticed due to failure noise
o fix exit value so test reports success correctly (e.g. when run
  with MOUNT_OPTIONS="-o ikeep")

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 238                |   57 +++++++++++++++++++++
 238.out            |    2 +
 group              |    1 +
 src/Makefile       |    3 +-
 src/stale_handle.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 202 insertions(+), 1 deletions(-)
 create mode 100755 238
 create mode 100644 238.out
 create mode 100644 src/stale_handle.c

diff --git a/238 b/238
new file mode 100755
index 0000000..4daca89
--- /dev/null
+++ b/238
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 238
+#
+# Check stale handles pointing to unlinked files are detected correctly
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
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
+#
+# creator
+owner=dchinner@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+echo "Silence is golden"
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount > /dev/null 2>&1
+src/stale_handle $SCRATCH_MNT
+status=$?
+exit
diff --git a/238.out b/238.out
new file mode 100644
index 0000000..9d5b672
--- /dev/null
+++ b/238.out
@@ -0,0 +1,2 @@
+QA output created by 238
+Silence is golden
diff --git a/group b/group
index 5c2d252..ee835d6 100644
--- a/group
+++ b/group
@@ -351,3 +351,4 @@ deprecated
 235 auto quota quick
 236 auto quick metadata
 237 auto quick acl
+238 auto quick metadata ioctl
diff --git a/src/Makefile b/src/Makefile
index 976133d..e878cff 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -15,7 +15,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
-	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable
+	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
+	stale_handle
 
 SUBDIRS =
 
diff --git a/src/stale_handle.c b/src/stale_handle.c
new file mode 100644
index 0000000..9b692f3
--- /dev/null
+++ b/src/stale_handle.c
@@ -0,0 +1,140 @@
+/*
+ *  stale_handle.c - attempt to create a stale handle and open it
+ *
+ *  Copyright (C) 2010 Red Hat, Inc. All Rights reserved.
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
+#define TEST_UTIME
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <errno.h>
+#include <xfs/xfs.h>
+#include <xfs/handle.h>
+
+#define NUMFILES 1024
+int main(int argc, char **argv)
+{
+	int	i;
+	int	fd;
+	int	ret;
+	int	failed = 0;
+	char	fname[MAXPATHLEN];
+	char	*test_dir;
+	void	*handle[NUMFILES];
+	size_t	hlen[NUMFILES];
+	char	fshandle[256];
+	size_t	fshlen;
+	struct stat st;
+
+
+	if (argc != 2) {
+		fprintf(stderr, "usage: stale_handle test_dir\n");
+		return EXIT_FAILURE;
+	}
+
+	test_dir = argv[1];
+	if (stat(test_dir, &st) != 0) {
+		perror("stat");
+		return EXIT_FAILURE;
+	}
+
+	ret = path_to_fshandle(test_dir, (void **)fshandle, &fshlen);
+	if (ret < 0) {
+		perror("path_to_fshandle");
+		return EXIT_FAILURE;
+	}
+
+	/*
+	 * create a large number of files to force allocation of new inode
+	 * chunks on disk.
+	 */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0644);
+		if (fd < 0) {
+			printf("Warning (%s,%d), open(%s) failed.\n", __FILE__, __LINE__, fname);
+			perror(fname);
+			return EXIT_FAILURE;
+		}
+		close(fd);
+	}
+
+	/* sync to get the new inodes to hit the disk */
+	sync();
+
+	/* create the handles */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		ret = path_to_handle(fname, &handle[i], &hlen[i]);
+		if (ret < 0) {
+			perror("path_to_handle");
+			return EXIT_FAILURE;
+		}
+	}
+
+	/* unlink the files */
+	for (i=0; i < NUMFILES; i++) {
+		sprintf(fname, "%s/file%06d", test_dir, i);
+		ret = unlink(fname);
+		if (ret < 0) {
+			perror("unlink");
+			return EXIT_FAILURE;
+		}
+	}
+
+	/* sync to get log forced for unlink transactions to hit the disk */
+	sync();
+
+	/* sync once more FTW */
+	sync();
+
+	/*
+	 * now drop the caches so that unlinked inodes are reclaimed and
+	 * buftarg page cache is emptied so that the inode cluster has to be
+	 * fetched from disk again for the open_by_handle() call.
+	 */
+	system("echo 3 > /proc/sys/vm/drop_caches");
+
+	/*
+	 * now try to open the files by the stored handles. Expecting ENOENT
+	 * for all of them.
+	 */
+	for (i=0; i < NUMFILES; i++) {
+		errno = 0;
+		fd = open_by_handle(handle[i], hlen[i], O_RDWR);
+		if (fd < 0 && errno == ENOENT) {
+			free_handle(handle[i], hlen[i]);
+			continue;
+		}
+		if (ret >= 0) {
+			printf("open_by_handle(%d) opened an unlinked file!\n", i);
+			close(fd);
+		} else
+			printf("open_by_handle(%d) returned %d incorrectly on an unlinked file!\n", i, errno);
+		free_handle(handle[i], hlen[i]);
+		failed++;
+	}
+	if (failed)
+		return EXIT_FAILURE;
+	return EXIT_SUCCESS;
+}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
