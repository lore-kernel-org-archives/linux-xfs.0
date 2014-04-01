Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 413767F58
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 13:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C687AAC005
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 11:49:10 -0700 (PDT)
Received: from order.stressinduktion.org (order.stressinduktion.org
	[87.106.68.36]) by cuda.sgi.com with ESMTP id 2ZyfBKAIdyCIr9ym
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Apr 2014 11:49:05 -0700 (PDT)
Date: Tue, 1 Apr 2014 20:49:03 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH xfstests] tests for file hash collisions on xfs filesystems
Message-ID: <20140401184903.GA13434@order.stressinduktion.org>
References: <20140327074156.GJ29498@order.stressinduktion.org>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140327074156.GJ29498@order.stressinduktion.org>
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

This patch adds a new check for xfstests, which generates directories with 64
distinct hash values and afterwards tries to delete the directory. This caused
a hash ordering issue.

The file-hash-tool can also generate files (this should result in the same
original problem as with directories) and generate only filenames with one
hash (this can be very well optimized in future).

This is just a preview. Dave Chiner seems to want this as soon as possible,
thus please review and suggest changes so I can adapt this patch ASAP.

Thanks!

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 .gitignore           |   1 +
 ltp/Makefile         |   2 +-
 ltp/file-hash-test.c | 189 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/307        |  61 +++++++++++++++++
 tests/xfs/307.out    |   2 +
 tests/xfs/group      |   1 +
 6 files changed, 255 insertions(+), 1 deletion(-)
 create mode 100644 ltp/file-hash-test.c
 create mode 100755 tests/xfs/307
 create mode 100644 tests/xfs/307.out

diff --git a/.gitignore b/.gitignore
index b6f2463..c023afc 100644
--- a/.gitignore
+++ b/.gitignore
@@ -26,6 +26,7 @@
 /ltp/fsstress
 /ltp/fsx
 /ltp/growfiles
+/ltp/file-hash-test
 /ltp/iogen
 
 # src/ binaries
diff --git a/ltp/Makefile b/ltp/Makefile
index 5bea492..c1ec489 100644
--- a/ltp/Makefile
+++ b/ltp/Makefile
@@ -5,7 +5,7 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-TARGETS = doio fsstress fsx growfiles iogen
+TARGETS = doio fsstress fsx growfiles iogen file-hash-test
 SCRIPTS = rwtest.sh
 CFILES = $(TARGETS:=.c)
 HFILES = doio.h
diff --git a/ltp/file-hash-test.c b/ltp/file-hash-test.c
new file mode 100644
index 0000000..c297034
--- /dev/null
+++ b/ltp/file-hash-test.c
@@ -0,0 +1,189 @@
+/*
+ * creates files or directories with similar hashes
+ *
+ * If used without option 64 different hash values are possible If
+ * '-s' is specified as command line option, it does reduce the number
+ * of hashes to just one.
+ *
+ * '-f' creates files - this is the default
+ * '-d' creates directories
+ * '-n 200000' specified the number of file names to generate
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
+	DIRECTORY,
+	FILENAME,
+} touch_mode = FILENAME;
+
+static bool one_hash = false;
+
+static uint32_t rol32(uint32_t word, unsigned int shift)
+{
+	return (word << shift) | (word >> (32 - shift));
+}
+
+static uint32_t xfs_hash(const uint8_t *name, int namelen)
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
+			"misbalanced input buffer to xfs_hash - "
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
+	hash = rol32(xfs_hash(buffer, 248), 7 * 4);
+	last = hash ^ ~0U;
+
+	if (last == 0)
+		goto again;
+
+	buffer[idx + 0] = (last >> 21) & 0xff;
+	buffer[idx + 1] = (last >> 14) & 0xff;
+	buffer[idx + 2] = (last >> 7)  & 0xff;
+	buffer[idx + 3] = last & 0xff;
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
+			filter = xfs_hash(buffer, 252);
+			done = true;
+			return;
+		}
+
+		if (filter != xfs_hash(buffer, 252))
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
+int main(int argc, char **argv)
+{
+	const char allopts[] = "vsdfn:";
+	int c, orig_cycles, errors = 0, cycles = 200000;
+
+	while ((c = getopt(argc, argv, allopts)) != -1) {
+		switch (c) {
+		case 'd':
+			touch_mode = DIRECTORY;
+			break;
+		case 'f':
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
+		}
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
index 0000000..12a322a
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,61 @@
+#! /bin/bash
+# FS QA Test No. 001
+#
+# what am I here for?
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 YOUR NAME HERE.  All Rights Reserved.
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
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os IRIX Linux
+
+mkdir $TEST_DIR/x
+cd $TEST_DIR/x
+
+$here/ltp/file-hash-test -d -n 200000
+cd $here
+# kernel should oops here
+rm -rf $TEST_DIR/x
+
+echo "If we got here, everything seems fine at first."
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/307.out b/tests/xfs/307.out
new file mode 100644
index 0000000..6cd3cd6
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,2 @@
+QA output created by 307
+If we got here, everything seems fine at first.
diff --git a/tests/xfs/group b/tests/xfs/group
index ba34650..b5695d3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -189,3 +189,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto stress
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
