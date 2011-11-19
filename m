Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJ8NVeu008592 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 02:23:32 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C92CC1627DFC
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 00:23:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5IEkWf33vmZJbQpo for
	<xfs@oss.sgi.com>; Sat, 19 Nov 2011 00:23:30 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAJ8NTUU010114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 03:23:29 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: 276 test time before epoch is correct when re-read
	in from disk
Date: Sat, 19 Nov 2011 16:24:15 +0800
Message-Id: <1321691055-1927-1-git-send-email-eguan@redhat.com>
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
Cc: Christoph Hellwig <chellwig@redhat.com>, Eryu Guan <eguan@redhat.com>

This is a regression test case for commit

4d7bf11d649c72621ca31b8ea12b9c94af380e63
ext2/3/4: fix file date underflow on ext2 3 filesystems on 64 bit systems

On 64bit systems, unpatched extX doesn't sign-extend time values read
in from disk. This results in times which should be before the epoch
jumping forward in time.  For example:

At creation, inode information still in memory.
[root@cluster1 ~]# touch -t 196001010101 test.txt
[root@cluster1 ~]# ls -l test.txt
-rw-r--r-- 1 root root 0 Jan  1  1960 test.txt

After remount/reboot to force the values to be read in from disk:
[root@cluster1 ~]# ls -l test.txt
-rw-r--r-- 1 root root 0 Feb  6  2096 test.txt

When the time value was read in from disk, it wasn't sign extended so
became a large, positive time value.  This doesn't occur on 32bit
systems since the time is stored as 32bits on disk and thus doesn't
need to be extended in size.

Cc: Christoph Hellwig <chellwig@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 276     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 276.out |    5 ++++
 group   |    1 +
 3 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100755 276
 create mode 100644 276.out

diff --git a/276 b/276
new file mode 100755
index 0000000..7570977
--- /dev/null
+++ b/276
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 276
+#
+# Test time before epoch is correct when re-read in from disk.
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
+owner=eguan@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $testfile
+	_scratch_unmount
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
+
+_require_scratch
+_scratch_mkfs &>/dev/null
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+
+# set timestamp 1 second before epoch
+touch -d @-1 $testfile
+atime_1=`stat --format=%X $testfile`
+mtime_1=`stat --format=%Y $testfile`
+echo "atime after touch $atime_1"
+echo "mtime after touch $mtime_1"
+
+# remount fs to force re-read in timestamp from disk
+_scratch_remount
+
+atime_2=`stat --format=%X $testfile`
+mtime_2=`stat --format=%Y $testfile`
+echo "atime after remount $atime_2"
+echo "mtime after remount $mtime_2"
+
+if [ "$atime_1" = "$atime_2" -a "$mtime_1" = "$mtime_2" ];then
+	status=0
+fi
+
+exit
diff --git a/276.out b/276.out
new file mode 100644
index 0000000..6e544ee
--- /dev/null
+++ b/276.out
@@ -0,0 +1,5 @@
+QA output created by 276
+atime after touch -1
+mtime after touch -1
+atime after remount -1
+mtime after remount -1
diff --git a/group b/group
index 08d999a..be4bd9b 100644
--- a/group
+++ b/group
@@ -389,3 +389,4 @@ deprecated
 273 auto rw
 274 auto rw
 275 auto rw
+276 auto quick
-- 
1.7.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
