Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P3ww7C176100 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 21:58:59 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A62FA28D519
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:01:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	siP592DjpzcsHJFO for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:01:20 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pha5j-0003Tq-7t
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 15:01:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pha3Y-0005Ne-Qa
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 14:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfstests: add test to reproduce bmap btree corruption.
Date: Tue, 25 Jan 2011 14:58:55 +1100
Message-Id: <1295927937-20634-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1295927937-20634-1-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
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

The problem was reprted here:

https://bugzilla.redhat.com/show_bug.cgi?id=626244

With the simple test case:

# mkfs.xfs -f -d agsize=16m,size=50g <dev>
# mount <dev> /mnt
# xfs_io -f -c 'resvsp 0 40G' /mnt/foo

Triggering the problem. Turn this into a new xfsqa test so that we
exercise the problem code and prevent future regressions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 250   |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 group |    1 +
 2 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 250

diff --git a/250 b/250
new file mode 100644
index 0000000..cb0fa9c
--- /dev/null
+++ b/250
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 250
+#
+# Bmap btree corruption regression test
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
+tmp=tmp/$$
+status=1  # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	umount $LOOP_MNT 2>/dev/null
+	rm -f $LOOP_DEV
+	rmdir $LOOP_MNT
+	_cleanup_testdir
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_loop
+
+LOOP_DEV=$TEST_DIR/$seq.fs
+LOOP_MNT=$TEST_DIR/$seq.mnt
+
+_filter_io()
+{
+	sed -e '/.* ops; /d'
+}
+
+# real QA test starts here
+
+echo "*** create loop mount point"
+rmdir $LOOP_MNT 2>/dev/null
+mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
+
+_test_loop()
+{
+	size=$1
+	agsize=$2
+	fsize=$3
+
+	dparam="file,name=$LOOP_DEV,size=$size"
+	if [ -n "$agsize" ]; then
+		dparam="$dparam,agsize=$agsize"
+	fi
+
+	echo "*** mkfs loop file (size=$size)"
+	$MKFS_XFS_PROG -d $dparam \
+		| _filter_mkfs # 2>/dev/null
+
+	echo "*** mount loop filesystem"
+	mount -t xfs -o loop $LOOP_DEV $LOOP_MNT
+
+	echo "*** preallocate large file"
+	xfs_io -f -c "resvsp 0 $fsize" $LOOP_MNT/foo | _filter_io
+
+	echo "*** unmount loop filesystem"
+	umount $LOOP_MNT
+
+	echo "*** check loop filesystem"
+	 _check_xfs_filesystem $LOOP_DEV none none
+}
+
+_test_loop 50g 16m 40G
+echo "*** done"
+status=0
+exit
diff --git a/group b/group
index b94f543..b18f2e6 100644
--- a/group
+++ b/group
@@ -363,3 +363,4 @@ deprecated
 247 auto quick rw
 248 auto quick rw 
 249 auto quick rw 
+250 auto quick rw prealloc metadata
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
