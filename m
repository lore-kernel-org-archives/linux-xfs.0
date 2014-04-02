Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFE6E7F6C
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 07:34:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 505BAAC008
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 05:34:46 -0700 (PDT)
Received: from order.stressinduktion.org (order.stressinduktion.org
	[87.106.68.36]) by cuda.sgi.com with ESMTP id NwKIz96LyHGXEyEL
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Apr 2014 05:34:44 -0700 (PDT)
Date: Wed, 2 Apr 2014 14:34:42 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH v3 xfstests] add tests for unlinking directories with hash
	collisions
Message-ID: <20140402123442.GF16157@order.stressinduktion.org>
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<20140401184903.GA13434@order.stressinduktion.org>
	<20140401230309.GC16157@order.stressinduktion.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140401230309.GC16157@order.stressinduktion.org>
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
Cc: tinguely@sgi.com

This tests creates several directories that have the same small (8)
group of hashes to ensure the hash ordering of file and directories
are preserved.

Sample backtrace this test tries to prevent in future:

[ 3856.245843] XFS (vda1): Internal error xfs_trans_cancel at line 966 of file fs/xfs/xfs_trans.c.  Caller 0xffffffffa01186bc
[ 3856.249049] CPU: 1 PID: 866 Comm: rm Not tainted 3.13.6-200.fc20.x86_64 #1
[ 3856.250966] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 3856.252615]  000000000000000c ffff8800d23a7d68 ffffffff8168730c ffff8800cf5462b8
[ 3856.254823]  ffff8800d23a7d80 ffffffffa00d00cb ffffffffa01186bc ffff8800d23a7da8
[ 3856.257241]  ffffffffa00e5459 ffff8800d9ac3400 ffff8800d23a7e30 ffff8800371b6800
[ 3856.259420] Call Trace:
[ 3856.260172]  [<ffffffff8168730c>] dump_stack+0x45/0x56
[ 3856.261717]  [<ffffffffa00d00cb>] xfs_error_report+0x3b/0x40 [xfs]
[ 3856.263472]  [<ffffffffa01186bc>] ? xfs_remove+0x1ac/0x370 [xfs]
[ 3856.270838]  [<ffffffffa00e5459>] xfs_trans_cancel+0xd9/0x100 [xfs]
[ 3856.272783]  [<ffffffffa01186bc>] xfs_remove+0x1ac/0x370 [xfs]
[ 3856.274531]  [<ffffffffa00db40b>] xfs_vn_unlink+0x4b/0x90 [xfs]
[ 3856.276286]  [<ffffffff811c61b8>] vfs_rmdir+0xa8/0x100
[ 3856.277821]  [<ffffffff811c638d>] do_rmdir+0x17d/0x1d0
[ 3856.281021]  [<ffffffff811ba7fe>] ? ____fput+0xe/0x10
[ 3856.285261]  [<ffffffff8108c11c>] ? task_work_run+0xac/0xe0
[ 3856.286952]  [<ffffffff81013a31>] ? do_notify_resume+0x61/0xa0
[ 3856.288693]  [<ffffffff811c9a65>] SyS_unlinkat+0x25/0x40
[ 3856.290407]  [<ffffffff816962e9>] system_call_fastpath+0x16/0x1b
[ 3856.292685] XFS (vda1): xfs_do_force_shutdown(0x8) called from line 967 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffffa00e5472
[ 3856.627330] XFS (vda1): Corruption of in-memory data detected.  Shutting down filesystem
[ 3856.627332] XFS (vda1): Please umount the filesystem and rectify the problem(s)

With help from Mark Tinguely, thanks very much!

Cc: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
Changelog:

v2)
* first serious proposal

v3)
* reduced number of possible generated hashes to 8 and thus lowered the number of
  generated files to 10_000 which still generate the corruption in all of my
  10 tests. This speeds up the test considerable. Maybe we can add
  quick to the group description now?
* updated changelog

Also:
When testing this program with reduced number of generated hashes and
huge amount of test files, xfs_repair needs a considerable amount of
time to check the directory (I aborted it). I guess this is because the
hash tables get flattened to linked lists.

I don't know if there are other runtime explosions in other parts of
the code (maybe in the kernel).  I suggest to add a random perturbation
to the hash function, which unluckily seems to be included into the
superblock then, too.

Please have a look!

Thanks,

  Hannes

 .gitignore                    |   1 +
 src/Makefile                  |   2 +-
 src/generate-hash-collision.c | 223 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/307                 |  63 ++++++++++++
 tests/xfs/307.out             |  28 ++++++
 tests/xfs/group               |   1 +
 6 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 src/generate-hash-collision.c
 create mode 100755 tests/xfs/307
 create mode 100644 tests/xfs/307.out

diff --git a/.gitignore b/.gitignore
index b6f2463..049f2e0 100644
--- a/.gitignore
+++ b/.gitignore
@@ -50,6 +50,7 @@
 /src/fsync-tester
 /src/ftrunc
 /src/genhashnames
+/src/generate-hash-collision
 /src/getdevicesize
 /src/getpagesize
 /src/godown
diff --git a/src/Makefile b/src/Makefile
index 6509f2d..1e9ec61 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,7 +11,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
-	t_mmap_writev t_truncate_cmtime
+	t_mmap_writev t_truncate_cmtime generate-hash-collision
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/generate-hash-collision.c b/src/generate-hash-collision.c
new file mode 100644
index 0000000..55cec87
--- /dev/null
+++ b/src/generate-hash-collision.c
@@ -0,0 +1,223 @@
+/*
+ * Generates files or directories with hash collisions on a XFS filesystem
+ * Copyright (C) 2014 Hannes Frederic Sowa
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+
+static enum {
+	ILLEGAL,
+	DIRECTORY,
+	FILENAME,
+} touch_mode = ILLEGAL;
+
+static bool one_hash = false;
+
+static uint32_t rol32(uint32_t word, unsigned int shift)
+{
+	return (word << shift) | (word >> (32 - shift));
+}
+
+static uint32_t xfs_da_hashname(const uint8_t *name, int namelen)
+{
+	uint32_t hash;
+
+	for (hash = 0; namelen >= 4; namelen -= 4, name += 4)
+		hash = (name[0] << 21) ^ (name[1] << 14) ^ (name[2] << 7) ^
+		       (name[3] << 0) ^ rol32(hash, 7 * 4);
+
+	if (namelen) {
+		fprintf(stderr,
+			"internal error: "
+			"misbalanced input buffer to xfs_da_hashname - "
+			"overlapping %d bytes\n", namelen);
+		exit(1);
+	}
+
+	return hash;
+}
+
+static uint8_t gen_rand(void)
+{
+	uint8_t r;
+	while (!(r = rand()));
+	return r;
+}
+
+static uint8_t buffer[252+1] = {0};
+
+static void gen_name(void)
+{
+	int idx;
+	uint32_t hash, last;
+
+again:
+	for (idx = 0; idx < 252-4; idx+=4) {
+		buffer[idx + 0] = gen_rand();
+		buffer[idx + 1] = gen_rand();
+		buffer[idx + 2] = gen_rand();
+		buffer[idx + 3] = gen_rand();
+	}
+
+	hash = rol32(xfs_da_hashname(buffer, 248), 7 * 4);
+	last = hash ^ ~0U;
+
+	if (last == 0)
+		goto again;
+
+	buffer[idx + 3] = last & 0x7fU;
+	buffer[idx + 2] = (last >> 7)  & 0x7fU;
+	buffer[idx + 1] = (last >> 14) & 0x7fU;
+	buffer[idx + 0] = ((last >> 21) & 0xffU);
+
+	if (memchr(buffer, '.', sizeof(buffer)) ||
+	    memchr(buffer, '/', sizeof(buffer)))
+		goto again;
+
+	if (one_hash) {
+		/* very poor - can be improved later */
+		static bool done = false;
+		static uint32_t filter;
+
+		if (!done) {
+			filter = xfs_da_hashname(buffer, 252);
+			done = true;
+			return;
+		}
+
+		if (filter != xfs_da_hashname(buffer, 252))
+			goto again;
+	}
+}
+
+static int touch(const char *buffer)
+{
+	if (touch_mode == DIRECTORY) {
+		if (mkdir(buffer, S_IRWXU)) {
+			/* ignore if directory is already present */
+			if (errno == EEXIST)
+				return 0;
+			perror("mkdir with random directory name");
+			return 1;
+		}
+	} else if (touch_mode == FILENAME) {
+		int fd = creat(buffer, S_IRWXU);
+		if (fd == -1) {
+			/* ignore duplicate files */
+			if (errno == EEXIST)
+				return 0;
+			perror("creat with random directory name");
+			return 1;
+		}
+		if (close(fd)) {
+			perror("close is leaking a file descriptor");
+			return 1;
+		}
+		return 0;
+	}
+	return 0;
+}
+
+static void do_seed(void)
+{
+	struct timeval tv;
+	if (gettimeofday(&tv, NULL)) {
+		perror("gettimeofday");
+		exit(1);
+	}
+	srand(tv.tv_sec ^ tv.tv_usec ^ getpid());
+}
+
+static void usage_and_exit(const char *pname)
+{
+	fprintf(stderr, "usage: %s [-d] [-f] [-n num] [-s] directory\n"
+		        "\t-f\tcreate files (the default)\n"
+			"\t-d\tcreate directories\n"
+			"\t-n num\tcreate num directories or files (default 200000)\n"
+			"\t-s\tonly generate one hash\n"
+			"\tdirectory\tthe directory to chdir() to\n",
+		pname);
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	const char allopts[] = "hsdfn:";
+	int c, orig_cycles, errors = 0, cycles = 200000;
+
+	while ((c = getopt(argc, argv, allopts)) != -1) {
+		switch (c) {
+		case 'd':
+			if (touch_mode != ILLEGAL)
+				usage_and_exit(argv[0]);
+			touch_mode = DIRECTORY;
+			break;
+		case 'f':
+			if (touch_mode != ILLEGAL)
+				usage_and_exit(argv[0]);
+			touch_mode = FILENAME;
+			break;
+		case 'n':
+			errno = 0;
+			if (sscanf(optarg, "%d", &cycles) != 1 ||
+			    errno == ERANGE) {
+				fputs("could not parse number of iterations", stderr);
+				exit(1);
+			}
+			break;
+		case 's':
+			one_hash = true;
+			break;
+		default:
+			usage_and_exit(argv[0]);
+			break;
+		}
+	}
+
+	if (argc <= optind || touch_mode == ILLEGAL)
+		usage_and_exit(argv[0]);
+
+	if (chdir(argv[optind])) {
+		perror("chdir");
+		exit(1);
+	}
+
+	orig_cycles = cycles;
+
+	do_seed();
+
+	while (cycles--) {
+		gen_name();
+		errors += touch((char *)buffer);
+	}
+
+	if (errors)
+		fprintf(stderr, "creating %d %s caused %d errors\n",
+			orig_cycles, touch_mode == FILENAME ? "files" : "directories",
+			errors);
+
+	return 0;
+}
diff --git a/tests/xfs/307 b/tests/xfs/307
new file mode 100755
index 0000000..9ff1bf7
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 307
+#
+# Test that directory hash entries are place in the correct order.
+# commit f5ea110 ("xfs: add CRCs to dir2/da node blocks") left the
+# directory with incorrect hash ordering.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Hannes Frederic Sowa.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+. ./common/rc
+. ./common/filter
+. ./common/repair
+
+# real QA test starts here
+
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mount | _filter_scratch
+
+mkdir $SCRATCH_MNT/x
+$here/src/generate-hash-collision -d -n 10000 $SCRATCH_MNT/x
+umount $SCRATCH_MNT 2>&1 | _filter_scratch
+
+_scratch_xfs_repair 2>&1 | _filter_repair
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/307.out b/tests/xfs/307.out
new file mode 100644
index 0000000..eaf5716
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,28 @@
+QA output created by 307
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
diff --git a/tests/xfs/group b/tests/xfs/group
index ba34650..a1ef7f9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -189,3 +189,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto dir
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
