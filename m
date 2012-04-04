Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q34EGrDk167167 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 09:16:53 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id NZJTV36SdtRASDeX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Apr 2012 07:16:51 -0700 (PDT)
Message-ID: <4F7C575A.7030507@oracle.com>
Date: Wed, 04 Apr 2012 22:14:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Introduce test case 285 for project quota negative
	test collections
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

Hello,

Call statfs(2) against a directory with project quota setup, the vanilla kernel-3.3 will crashed if the
underlaying XFS file system was mounted without pquota option.
For detail, please take a look at the following link for the bug report:
http://patchwork.xfs.org/patch/3477/

I'd like to introduce a new test to verify something like this, it is intended to run as a negative test
collections for project quota.  It only verify the above issue for now, maybe its better to wrap the steps in a individual function?


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 285     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 285.out |    9 +++++
 group   |    1 +
 3 files changed, 124 insertions(+), 0 deletions(-)
 create mode 100755 285
 create mode 100644 285.out

diff --git a/285 b/285
new file mode 100755
index 0000000..a7bace8
--- /dev/null
+++ b/285
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 285
+#
+# Negative test cases collection for project quota
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 Oracle Liu Jie.  All Rights Reserved.
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
+owner=jeff.liu@oracle.com
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
+    rm -f /etc/projects.bak
+    rm -f /etc/projid.bak
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+. ./common.quota
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_quota
+
+tmpfile=$TEST_DIR/fsfile.$$
+tmpdir=$TEST_DIR/tmpdir.$$
+project_name="pquota_test"
+testfile=$tmpdir/testme
+
+_backup_pquota_config_files()
+{
+	cp /etc/projects /etc/projects.bak
+	cp /etc/projid /etc/projid.bak
+}
+
+_restore_pquota_config_files()
+{
+	cp /etc/projects.bak /etc/projects
+	cp /etc/projid.bak /etc/projid
+}
+
+_create_pquota_config_files()
+{
+	echo "1:$tmpdir" > /etc/projects
+	echo "$project_name:1" > /etc/projid
+}
+
+mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"
+
+echo "*** create loopback image file ***"
+dd if=/dev/zero of=$tmpfile bs=4k count=4096 >/dev/null 2>&1
+
+echo "*** mkfs.xfs ***"
+mkfs.xfs -b size=4096 $tmpfile >/dev/null 2>&1
+
+# mount loopback image but without pquota option
+mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
+
+echo "*** backup old project quota config files ***"
+_backup_pquota_config_files
+
+echo "*** setup project quota for testing ***"
+_create_pquota_config_files
+
+# create a file to trigger du(1) call statfs(2) against a directory with
+# project quota configed but without 'pquota' mount option.
+# XFS crashed on vanilla kernel-3.3 in this case.
+echo "*** create a file under the project directory ***"
+echo "project quota test" > $testfile
+
+echo "*** setup project quota ***" 
+xfs_quota -x -c "project -s $project_name" $tmpdir >/dev/null 2>&1
+
+du -sh $tmpdir >/dev/null 2>&1
+
+echo "*** clearing project quota ***"
+xfs_quota -x -c "project -C $project_name" $tmpdir >/dev/null 2>&1
+
+echo "*** restore old project quota config files ***"
+_restore_pquota_config_files
+
+status=0
+exit
diff --git a/285.out b/285.out
new file mode 100644
index 0000000..088cc08
--- /dev/null
+++ b/285.out
@@ -0,0 +1,9 @@
+QA output created by 285
+*** create loopback image file ***
+*** mkfs.xfs ***
+*** backup old project quota config files ***
+*** setup project quota for testing ***
+*** create a file under the project directory ***
+*** setup project quota ***
+*** clearing project quota ***
+*** restore old project quota config files ***
diff --git a/group b/group
index 104ed35..0b33178 100644
--- a/group
+++ b/group
@@ -403,3 +403,4 @@ deprecated
 282 dump ioctl auto quick
 283 dump ioctl auto quick
 284 auto
+285 auto
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
