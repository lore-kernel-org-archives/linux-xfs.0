Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9EA87F52
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3CBB304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:46 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	THRy8OiSxsOLvVcY for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PK-Cx
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000o7-C1
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: introduce new large ACL test
Date: Wed, 23 Apr 2014 08:04:31 +1000
Message-Id: <1398204274-2113-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Having just removed the largeacl test from the shared ACL test,
reintroduce the same test as an XFS specific test so that we can
handle the different limits in supported ACL count appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/010     | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/010.out |   9 ++++
 tests/xfs/group   |   1 +
 3 files changed, 157 insertions(+)
 create mode 100644 tests/xfs/010
 create mode 100644 tests/xfs/010.out

diff --git a/tests/xfs/010 b/tests/xfs/010
new file mode 100644
index 0000000..4f75d26
--- /dev/null
+++ b/tests/xfs/010
@@ -0,0 +1,147 @@
+#! /bin/bash
+# FS QA Test No. xfs/010
+#
+# Test out ACL count limits
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2014 Red hat, Inc.  All Rights Reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+
+here=`pwd`
+tmp=/tmp/$$
+runas=$here/src/runas
+status=1	# FAILure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    [ -n "$TEST_DIR" ] && rm -rf $TEST_DIR/$seq.dir1
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+[ -x $runas ] || _notrun "$runas executable not found"
+
+rm -f $seqres.full
+
+_need_to_be_root
+_acl_setup_ids
+_require_acls
+
+# get dir
+cd $TEST_DIR
+rm -rf $seq.dir1
+mkdir $seq.dir1
+cd $seq.dir1
+
+echo "QA output created by $seq"
+
+# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
+# on old kernel. So we need to filter out the error message in order
+# to make the updated golden output works for both old and new kernels.
+_filter_largeacl()
+{
+	sed -e "s/Invalid argument/Argument list too long/"
+}
+
+# filter all the non-ace stuff from the acl output so the count is
+# correct. Note that this assumes that _create_n_aces always creates rwx acls.
+_filter_acls()
+{
+	_filter_aces | grep ':rwx'
+}
+
+# CRC format filesystems have much larger ACL counts. The actual number is into
+# the thousands, but testing that meany takes too long, so just test well past
+# the old limit of 25.
+get_max_acls()
+{
+	xfs_info $TEST_DIR | _filter_mkfs > /dev/null 2> $tmp.info
+	. $tmp.info
+	if [ $_fs_has_crcs -eq 0 ]; then
+		echo 25
+	else
+		echo 5461
+	fi
+}
+
+# store the output in seqres.full, then run again an count and filter the
+# output.
+check_acls()
+{
+	_acl=$1
+	_count=$2
+
+	chacl $_acl largeaclfile 2>&1 | _filter_largeacl
+	getfacl --numeric largeaclfile | _filter_aces \
+		>> $seqres.full 2> /dev/null
+	nacls=`getfacl --numeric largeaclfile | _filter_acls | wc -l`
+	if [ $nacls -ne $_count ]; then
+		echo Wrong ACL count - $nacls != $_count
+	fi
+}
+
+
+echo ""
+echo "=== Test out large ACLs  ==="
+touch largeaclfile
+
+XFS_ACL_MAX_ENTRIES=$(get_max_acls)
+num_aces_pre=$((XFS_ACL_MAX_ENTRIES - 1))
+num_aces_post=$((XFS_ACL_MAX_ENTRIES + 1))
+
+acl1=`_create_n_aces $num_aces_pre`
+acl2=`_create_n_aces $XFS_ACL_MAX_ENTRIES`
+acl3=`_create_n_aces $num_aces_post`
+acl4=`_create_n_aces 16` # Andreas G. libacl size for initial get
+acl5=`_create_n_aces 17` # 1 over A.G. libacl initial size
+
+echo "1 below xfs acl max"
+check_acls $acl1 $num_aces_pre
+
+echo "xfs acl max"
+check_acls $acl2 $XFS_ACL_MAX_ENTRIES
+
+# we expect the ACL change to fail, so the old ACLs should remain on the
+# file. Hence the expected ACL count is XFS_ACL_MAX_ENTRIES, not num_aces_post.
+echo "1 above xfs acl max"
+check_acls $acl3 $XFS_ACL_MAX_ENTRIES
+
+echo "use 16 aces"
+check_acls $acl4 16
+
+echo "use 17 aces"
+check_acls $acl5 17
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/010.out b/tests/xfs/010.out
new file mode 100644
index 0000000..5f7f428
--- /dev/null
+++ b/tests/xfs/010.out
@@ -0,0 +1,9 @@
+QA output created by 010
+
+=== Test out large ACLs  ===
+1 below xfs acl max
+xfs acl max
+1 above xfs acl max
+chacl: cannot set access acl on "largeaclfile": Argument list too long
+use 16 aces
+use 17 aces
diff --git a/tests/xfs/group b/tests/xfs/group
index 445783e..f907d9b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -7,6 +7,7 @@
 007 auto quota quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
+010 acl quick auto
 012 rw auto quick
 016 rw auto quick
 017 mount auto quick stress
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
