Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C88A7CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 21:06:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B84A0AC004
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 19:06:28 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9LFbUwGGyeiIFriB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 19:06:26 -0700 (PDT)
Date: Thu, 4 Aug 2016 19:03:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v3] xfs: test attr_list_by_handle cursor iteration
Message-ID: <20160805020351.GF25565@birch.djwong.org>
References: <20160802235251.GB8586@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160802235251.GB8586@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Apparently the XFS attr_list_by_handle ioctl has never actually copied
the cursor contents back to user space, which means that iteration has
never worked.  Add a test case for this and see
"xfs: in _attrlist_by_handle, copy the cursor back to userspace".

v2: Use BULKSTAT_SINGLE for less confusion, fix build errors on RHEL6.
v3: Use path_to_handle instead of bulkstat.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .gitignore                            |    1 
 src/Makefile                          |    3 +
 src/attr-list-by-handle-cursor-test.c |  118 +++++++++++++++++++++++++++++++++
 tests/xfs/700                         |   64 ++++++++++++++++++
 tests/xfs/700.out                     |    5 +
 tests/xfs/group                       |    1 
 6 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100644 src/attr-list-by-handle-cursor-test.c
 create mode 100755 tests/xfs/700
 create mode 100644 tests/xfs/700.out

diff --git a/.gitignore b/.gitignore
index 28bd180..e184a6f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -38,6 +38,7 @@
 /src/alloc
 /src/append_reader
 /src/append_writer
+/src/attr-list-by-handle-cursor-test
 /src/bstat
 /src/bulkstat_unlink_test
 /src/bulkstat_unlink_test_modified
diff --git a/src/Makefile b/src/Makefile
index 1bf318b..ae06d50 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -20,7 +20,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
-	renameat2 t_getcwd e4compact test-nextquota punch-alternating
+	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
+	attr-list-by-handle-cursor-test
 
 SUBDIRS =
 
diff --git a/src/attr-list-by-handle-cursor-test.c b/src/attr-list-by-handle-cursor-test.c
new file mode 100644
index 0000000..4269d1e
--- /dev/null
+++ b/src/attr-list-by-handle-cursor-test.c
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <attr/attributes.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdio.h>
+#include <asm/types.h>
+#include <xfs/xfs.h>
+#include <xfs/handle.h>
+
+#define ATTRBUFSZ		1024
+#define BSTATBUF_NR		32
+
+/* Read all the extended attributes of a file handle. */
+void
+read_handle_xattrs(
+	struct xfs_handle	*handle)
+{
+	struct attrlist_cursor	cur;
+	char			attrbuf[ATTRBUFSZ];
+	char			*firstname = NULL;
+	struct attrlist		*attrlist = (struct attrlist *)attrbuf;
+	struct attrlist_ent	*ent;
+	int			i;
+	int			flags = 0;
+	int			error;
+
+	memset(&cur, 0, sizeof(cur));
+	while ((error = attr_list_by_handle(handle, sizeof(*handle),
+					    attrbuf, ATTRBUFSZ, flags,
+					    &cur)) == 0) {
+		for (i = 0; i < attrlist->al_count; i++) {
+			ent = ATTR_ENTRY(attrlist, i);
+
+			if (i != 0)
+				continue;
+
+			if (firstname == NULL) {
+				firstname = malloc(ent->a_valuelen);
+				memcpy(firstname, ent->a_name, ent->a_valuelen);
+			} else {
+				if (memcmp(firstname, ent->a_name,
+					   ent->a_valuelen) == 0)
+					fprintf(stderr,
+						"Saw duplicate xattr \"%s\", buggy XFS?\n",
+						ent->a_name);
+				else
+					fprintf(stderr,
+						"Test passes.\n");
+				goto out;
+			}
+		}
+
+		if (!attrlist->al_more)
+			break;
+	}
+
+out:
+	if (firstname)
+		free(firstname);
+	if (error)
+		perror("attr_list_by_handle");
+	return;
+}
+
+int main(
+	int			argc,
+	char			*argv[])
+{
+	struct xfs_handle	*fshandle;
+	size_t			fshandle_len;
+	struct xfs_handle	*handle;
+	size_t			handle_len;
+	int			error;
+
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s filename\n", argv[0]);
+		return 1;
+	}
+
+	error = path_to_fshandle(argv[1], (void **)&fshandle, &fshandle_len);
+	if (error) {
+		perror("getting fshandle");
+		return 2;
+	}
+
+	error = path_to_handle(argv[1], (void **)&handle, &handle_len);
+	if (error) {
+		perror("getting handle");
+		return 3;
+	}
+
+	read_handle_xattrs(handle);
+
+	free_handle(handle, handle_len);
+	free_handle(fshandle, fshandle_len);
+	return 0;
+}
diff --git a/tests/xfs/700 b/tests/xfs/700
new file mode 100755
index 0000000..4a5680d
--- /dev/null
+++ b/tests/xfs/700
@@ -0,0 +1,64 @@
+#! /bin/bash
+# FS QA Test No. 700
+#
+# Check that attr_list_by_handle copies the cursor back to userspace.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/populate
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+_require_test_program "attr-list-by-handle-cursor-test"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Stuff file with xattrs"
+mkdir $SCRATCH_MNT/foo
+__populate_create_attr $SCRATCH_MNT/foo 100
+
+echo "Run test program"
+./src/attr-list-by-handle-cursor-test $SCRATCH_MNT/foo
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/700.out b/tests/xfs/700.out
new file mode 100644
index 0000000..493a68a
--- /dev/null
+++ b/tests/xfs/700.out
@@ -0,0 +1,5 @@
+QA output created by 700
+Format and mount
+Stuff file with xattrs
+Run test program
+Test passes.
diff --git a/tests/xfs/group b/tests/xfs/group
index ff0efa5..b42153d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -307,3 +307,4 @@
 325 auto quick clone
 326 auto quick clone
 327 auto quick clone
+700 auto quick ioctl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
