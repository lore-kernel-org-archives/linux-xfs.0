Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D32E97F52
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 18:44:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 852578F8049
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:44:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1Z5eU2jXxNC7NY0Q for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 16:44:56 -0700 (PDT)
Date: Thu, 24 Apr 2014 09:44:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6 v2] generic: introduce new large ACL test
Message-ID: <20140423234452.GW15995@dastard>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
	<1398204274-2113-4-git-send-email-david@fromorbit.com>
	<20140423152313.GC26128@infradead.org>
	<20140423230915.GV15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423230915.GV15995@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Having just removed the largeacl test from the shared ACL test,
reintroduce the same test as an generic test so that we can
handle the different limits in supported ACL count appropriately
across different filesystems and different configurations within
filesystem types.

Filesystems have to add support to _acl_get_max to run
this test - the default behaviour right now is to throw a
notrun error like this:

generic/026 14s ... [not run] ext4 does not define maximum ACL count

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/attr           |  31 ++++++++++++
 tests/generic/026     | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/026.out |   9 ++++
 tests/generic/group   |   1 +
 4 files changed, 173 insertions(+)

diff --git a/common/attr b/common/attr
index 83bf9d1..6fdcbf2 100644
--- a/common/attr
+++ b/common/attr
@@ -21,6 +21,37 @@
 #-----------------------------------------------------------------------
 # common extended attribute and ACL support
 
+# filesystems that want to test maximum supported acl counts need to
+# add support in here
+_acl_get_max()
+{
+	case $FSTYP in
+	xfs)
+		# CRC format filesystems have much larger ACL counts. The actual
+		# number is into the thousands, but testing that meany takes too
+		# long, so just test well past the old limit of 25.
+		xfs_info $TEST_DIR | _filter_mkfs > /dev/null 2> $tmp.info
+		. $tmp.info
+		rm $tmp.info
+		if [ $_fs_has_crcs -eq 0 ]; then
+			echo 25
+		else
+			echo 5461
+		fi
+		;;
+	*)
+		echo 0
+		;;
+	esac
+}
+
+_require_acl_get_max()
+{
+	if [ $(_acl_get_max) -eq 0 ]; then
+		_notrun "$FSTYP does not define maximum ACL count"
+	fi
+}
+
 # pick three unused user/group ids, store them as $acl[1-3]
 #
 _acl_setup_ids()
diff --git a/tests/generic/026 b/tests/generic/026
new file mode 100644
index 0000000..6dae966
--- /dev/null
+++ b/tests/generic/026
@@ -0,0 +1,132 @@
+#! /bin/bash
+# FS QA Test No. generic/026
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
+echo "QA output created by $seq"
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_need_to_be_root
+_acl_setup_ids
+_require_acls
+_require_acl_get_max
+
+[ -x $runas ] || _notrun "$runas executable not found"
+
+rm -f $seqres.full
+
+# get dir
+cd $TEST_DIR
+rm -rf $seq.dir1
+mkdir $seq.dir1
+cd $seq.dir1
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
+ACL_MAX_ENTRIES=$(_acl_get_max)
+num_aces_pre=$((ACL_MAX_ENTRIES - 1))
+num_aces_post=$((ACL_MAX_ENTRIES + 1))
+
+acl1=`_create_n_aces $num_aces_pre`
+acl2=`_create_n_aces $ACL_MAX_ENTRIES`
+acl3=`_create_n_aces $num_aces_post`
+acl4=`_create_n_aces 16` # Andreas G. libacl size for initial get
+acl5=`_create_n_aces 17` # 1 over A.G. libacl initial size
+
+echo "1 below acl max"
+check_acls $acl1 $num_aces_pre
+
+echo "acl max"
+check_acls $acl2 $ACL_MAX_ENTRIES
+
+# we expect the ACL change to fail, so the old ACLs should remain on the
+# file. Hence the expected ACL count is XFS_ACL_MAX_ENTRIES, not num_aces_post.
+echo "1 above acl max"
+check_acls $acl3 $ACL_MAX_ENTRIES
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
diff --git a/tests/generic/026.out b/tests/generic/026.out
new file mode 100644
index 0000000..c36b7f0
--- /dev/null
+++ b/tests/generic/026.out
@@ -0,0 +1,9 @@
+QA output created by 026
+
+=== Test out large ACLs  ===
+1 below acl max
+acl max
+1 above acl max
+chacl: cannot set access acl on "largeaclfile": Argument list too long
+use 16 aces
+use 17 aces
diff --git a/tests/generic/group b/tests/generic/group
index 60d6066..961f4e5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -28,6 +28,7 @@
 023 auto quick
 024 auto quick
 025 auto quick
+026 acl quick auto
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
