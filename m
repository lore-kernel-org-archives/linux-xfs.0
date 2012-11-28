Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS3Gv9Y127003 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 21:16:58 -0600
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6NV445gO9LFRafqk for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 19:19:13 -0800 (PST)
Message-ID: <50B582B0.4050305@sandeen.net>
Date: Tue, 27 Nov 2012 21:19:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: test EROFS vs. EEXIST when creating on an RO
	filesystem
References: <50B52DB7.3030506@redhat.com>
In-Reply-To: <50B52DB7.3030506@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

TBH, I don't know if this is posix-specified, but I found out the
hard way that when trying to re-create existing files on a readonly 
filesystem, some apps expect/handle EEXIST, but fail on EROFS.

This will test mkdir, mknod, and symlinks for that behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2:  Change test dir var name, do scratch mkfs, drop _fail

diff --git a/292 b/292
new file mode 100755
index 0000000..4f0cc87
--- /dev/null
+++ b/292
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 292
+#
+# Tests for EEXIST (not EROFS) for inode creations, if
+# we ask to create an already-existing entity on an RO filesystem
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Red Hat, Inc.  All Rights Reserved.
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
+owner=sandeen@redhat.com
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+MYDIR=$SCRATCH_MNT/$seq.test
+
+_create_files()
+{
+	mknod $MYDIR/testnode c 1 3
+	mkdir $MYDIR/testdir
+	touch $MYDIR/testtarget
+	ln -s $MYDIR/testtarget $MYDIR/testlink
+}
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+rm -rf $MYDIR
+mkdir $MYDIR
+
+_create_files 2>&1 | _filter_scratch
+_scratch_mount -o remount,ro
+_create_files 2>&1 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/292.out b/292.out
new file mode 100644
index 0000000..485c567
--- /dev/null
+++ b/292.out
@@ -0,0 +1,5 @@
+QA output created by 292
+mknod: `SCRATCH_MNT/292.test/testnode': File exists
+mkdir: cannot create directory `SCRATCH_MNT/292.test/testdir': File exists
+touch: cannot touch `SCRATCH_MNT/292.test/testtarget': Read-only file system
+ln: creating symbolic link `SCRATCH_MNT/292.test/testlink': File exists
diff --git a/group b/group
index dc8db65..030082b 100644
--- a/group
+++ b/group
@@ -410,3 +410,4 @@ deprecated
 289 auto quick
 290 auto rw prealloc quick ioctl
 291 repair
+292 auto quick


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
