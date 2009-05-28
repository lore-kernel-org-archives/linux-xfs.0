Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4SKXAwO009575 for <xfs@oss.sgi.com>; Thu, 28 May 2009 15:33:10 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EFC51A3CCDB
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 13:33:23 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 3dVPLXUzntCH8UlY for <xfs@oss.sgi.com>;
	Thu, 28 May 2009 13:33:23 -0700 (PDT)
Message-ID: <4A1EF50D.8090900@redhat.com>
Date: Thu, 28 May 2009 15:33:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 206: test for overflow in growfs size calculation
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
Cc: Richard.Ems@cape-horn-eng.com

Test trim of last small AG for large filesystem resizes

As reported at
http://article.gmane.org/gmane.comp.file-systems.xfs.general/29187
this trimming may cause an overflow in the new size calculation.

Patch to fix it, and testcase at
http://article.gmane.org/gmane.comp.file-systems.xfs.general/29193

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/206 b/206
new file mode 100755
index 0000000..cb584f2
--- /dev/null
+++ b/206
@@ -0,0 +1,82 @@
+#! /bin/sh
+# FS QA Test No. 206
+#
+# Test trim of last small AG for large filesystem resizes
+#
+# As reported at
+# http://article.gmane.org/gmane.comp.file-systems.xfs.general/29187
+# this trimming may cause an overflow in the new size calculation.
+# Patch and testcase at
+# http://article.gmane.org/gmane.comp.file-systems.xfs.general/29193
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.
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
+owner=sandeen@sandeen.net
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
+    umount $tmpdir
+    rmdir $tmpdir
+    rm -f $tmp
+    rm -f $tmpfile
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
+_supported_os IRIX Linux
+
+tmpfile=$TEST_DIR/fsfile.$$
+tmpdir=$TEST_DIR/tmpdir.$$
+
+mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"
+
+echo "=== xfs_io ==="
+xfs_io -f -c "truncate 19998630180864" $tmpfile \
+	|| _fail "!!! failed to truncate loopback file to correct size"
+
+echo "=== mkfs.xfs ==="
+mkfs.xfs -f -bsize=4096 -dagsize=76288719b,size=3905982455b -llazy-count=0 $tmpfile \
+	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g"
+
+mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
+
+echo "=== xfs_growfs ==="
+xfs_growfs $tmpdir \
+	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
+	| grep -v "data blocks changed"
+
+# _cleanup cleans up
+
+# success, all done
+status=0
+exit
diff --git a/206.out b/206.out
new file mode 100644
index 0000000..14b2c34
--- /dev/null
+++ b/206.out
@@ -0,0 +1,20 @@
+QA output created by 206
+=== xfs_io ===
+=== mkfs.xfs ===
+meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
+         =                       sectsz=512   attr=2
+data     =                       bsize=4096   blocks=3905982455, imaxpct=5
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0
+log      =internal log           bsize=4096   blocks=32768, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=0
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== xfs_growfs ===
+meta-data=FILE                   isize=256    agcount=52, agsize=76288719 blks
+         =                       sectsz=512   attr=2
+data     =                       bsize=4096   blocks=3905982455, imaxpct=5
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0
+log      =internal               bsize=4096   blocks=32768, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=0
+realtime =none                   extsz=4096   blocks=0, rtextents=0
diff --git a/group b/group
index 0ac33c2..343aace 100644
--- a/group
+++ b/group
@@ -310,3 +310,4 @@ atime
 203 ioctl auto
 204 metadata rw auto
 205 metadata rw auto
+206 growfs auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
