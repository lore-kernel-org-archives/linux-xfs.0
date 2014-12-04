Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FF677F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 22:20:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2EC878F8035
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 20:20:30 -0800 (PST)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	WLDKooAYc3PdPem9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 20:20:26 -0800 (PST)
Received: by mail-wi0-f182.google.com with SMTP id h11so26519644wiw.9
	for <xfs@oss.sgi.com>; Wed, 03 Dec 2014 20:20:24 -0800 (PST)
From: Iustin Pop <iustin@k1024.org>
Subject: [PATCH] xfs: add test for XFS_IOC_FSSETXATTR behaviour
Date: Thu,  4 Dec 2014 05:20:01 +0100
Message-Id: <1417666801-601-1-git-send-email-iustin@k1024.org>
In-Reply-To: <20140829025218.GG26465@dastard>
References: <20140829025218.GG26465@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: Iustin Pop <iustin@k1024.org>, fstests@vger.kernel.org, xfs@oss.sgi.com

Adds a new test (xfs/032) that checks for correct behaviour of
XFS_IOC_FSSETXATTR for directories: extent sizes should always be
settable on a directory, even if the directory already has allocated
extents.

Signed-off-by: Iustin Pop <iustin@k1024.org>
---
 Note that I've dropped the other test, since - thanks to your explanations - I
 understood that it was meaningless (and why).

 tests/xfs/032     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/032.out |  4 +++
 tests/xfs/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/xfs/032
 create mode 100644 tests/xfs/032.out

diff --git a/tests/xfs/032 b/tests/xfs/032
new file mode 100755
index 0000000..3afce26
--- /dev/null
+++ b/tests/xfs/032
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 032
+#
+# Determine whether the extent size hint can be set on directories
+# with allocated extents correctly.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Google Inc.  All Rights Reserved.
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
+. ./common/punch
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+small=$SCRATCH_MNT/small
+big=$SCRATCH_MNT/big
+
+# sanity check on a small directory
+mkdir $small
+# expect that an empty directory has no extents
+$XFS_IO_PROG -c "bmap" $small | _filter_scratch
+# and that we can set an extent size on it
+$XFS_IO_PROG -c 'extsize 8m' $small
+# and finally check that the extent size update has taken place
+$XFS_IO_PROG -c "extsize" $small | _filter_scratch
+
+# now create a 'big' (with extents) directory
+mkdir $big
+for idx in {0..1000}; do
+    touch $big/$idx
+done
+$XFS_IO_PROG -c 'bmap -vp' $big | _filter_bmap | \
+    grep -q '^0: .*data'
+[ $? -eq 0 ] || echo "Can't force allocating extents!" 1>&2
+
+# expect that we can set the extent size on $big as well
+$XFS_IO_PROG -c 'extsize 8m' $big | _filter_scratch
+# and that it took effect
+$XFS_IO_PROG -c 'extsize' $big | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/032.out b/tests/xfs/032.out
new file mode 100644
index 0000000..4b7bd92
--- /dev/null
+++ b/tests/xfs/032.out
@@ -0,0 +1,4 @@
+QA output created by 032
+SCRATCH_MNT/small: no extents
+[8388608] SCRATCH_MNT/small
+[8388608] SCRATCH_MNT/big
diff --git a/tests/xfs/group b/tests/xfs/group
index 4b8e51a..dc132b5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -29,6 +29,7 @@
 029 mkfs logprint log auto quick
 030 repair auto quick
 031 repair mkfs auto quick
+032 ioctl quick
 033 repair auto quick
 034 other auto quick
 035 dump ioctl tape auto
-- 
2.1.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
