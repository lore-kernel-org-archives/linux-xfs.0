Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58K19hE230198 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 15:01:09 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6673F1E0A4A8
	for <xfs@oss.sgi.com>; Tue,  8 Jun 2010 13:03:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 28n8EbUTE0SWE8zj for
	<xfs@oss.sgi.com>; Tue, 08 Jun 2010 13:03:40 -0700 (PDT)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o58K3dmY003059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 16:03:40 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o58K3dDn017907
	for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 16:03:39 -0400
Message-ID: <4C0EA21B.8020703@sandeen.net>
Date: Tue, 08 Jun 2010 15:03:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: resolve symlinked devices to real paths
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
To: xfs mailing list <xfs@oss.sgi.com>

If you try running xfstests on lvm volumes which are symlinks,
it'll fail to run several tests because our _require_scratch 
framework ultimately uses lstat not stat, and does not think 
the lvm device (which is usually a symlink to a dm-X device) 
is a block device.  Sigh.

Last try at this - just resolve any symlinked devicenames
into their realpath(3) in common.config.

This actually seems to work.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.config b/common.config
index 926846b..e5b2483 100644
--- a/common.config
+++ b/common.config
@@ -208,6 +208,15 @@ else
     known_hosts
 fi
 
+# Scripts just don't deal well with symlinked devices
+if [ -L $TEST_DEV ]; then
+        TEST_DEV=`src/realpath $TEST_DEV`
+fi
+
+if [ -L $SCRATCH_DEV ]; then
+        SCRATCH_DEV=`src/realpath $SCRATCH_DEV`
+fi
+
 echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
     echo "common.config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
diff --git a/src/Makefile b/src/Makefile
index 976133d..2399853 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,7 +10,8 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
-	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes
+	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
+	realpath
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/realpath.c b/src/realpath.c
new file mode 100644
index 0000000..997b1aa
--- /dev/null
+++ b/src/realpath.c
@@ -0,0 +1,32 @@
+#include <limits.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+
+/*
+ * Simple wrapper around realpath(3) to get absolute path
+ * to a device name; many xfstests scripts don't cope well
+ * with symlinked devices due to differences in /proc/mounts,
+ * /etc/mtab, mount output, etc.
+ */
+
+int main(int argc, char *argv[])
+{
+	char path[PATH_MAX];
+	char resolved_path[PATH_MAX];
+
+	if (argc != 2) {
+		printf("Usage: %s <filename>\n", argv[0]);
+		return 1;
+	}
+
+	strncpy(path, argv[1], PATH_MAX-1);
+
+	if (!realpath(path, resolved_path)) {
+		perror("Failed to resolve path for %s");
+		return 1;
+	}
+
+	printf("%s\n", resolved_path);
+	return 0;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
