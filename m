Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A46B17F5A
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 11:03:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2609AAC00A
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:03:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PTljiVXH4nr3uyUO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 09:03:47 -0700 (PDT)
Date: Thu, 27 Jun 2013 12:03:40 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 3/3] xfstests 314: user namespace uid/gids in an ACL
Message-ID: <20130627120340.20e494ad@oracle.com>
In-Reply-To: <20130626010931.GA29376@dastard>
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 common/attr           |  14 +++++++
 tests/generic/314     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/314.out |  51 +++++++++++++++++++++++++
 tests/generic/group   |   1 +
 4 files changed, 168 insertions(+)
 create mode 100644 tests/generic/314
 create mode 100644 tests/generic/314.out

diff --git a/common/attr b/common/attr
index e5070bf..4a3ac9e 100644
--- a/common/attr
+++ b/common/attr
@@ -54,6 +54,20 @@ _acl_filter_id()
        -e "s/ $acl3 / id3 /"
 }
 
+_getfacl_filter_id()
+{
+    sed \
+       -e "s/user:$acl1/user:id1/" \
+       -e "s/user:$acl2/user:id2/" \
+       -e "s/user:$acl3/user:id3/" \
+       -e "s/group:$acl1/group:id1/" \
+       -e "s/group:$acl2/group:id2/" \
+       -e "s/group:$acl3/group:id3/" \
+       -e "s/: $acl1/: id1/" \
+       -e "s/: $acl2/: id2/" \
+       -e "s/: $acl3/: id3/"
+}
+
 # filtered ls
 #
 _acl_ls()
diff --git a/tests/generic/314 b/tests/generic/314
new file mode 100644
index 0000000..fc0b722
--- /dev/null
+++ b/tests/generic/314
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 314
+#
+# Check get/set ACLs to/from disk with a user namespace. A new file
+# will be created and ACLs set on it from both inside a userns and
+# from init_user_ns. We check that the ACL is is correct from both
+# inside the userns and also from init_user_ns. We will then unmount
+# and remount the file system and check the ACL from both inside the
+# userns and from init_user_ns to show that the correct uid/gid in
+# the ACL was flushed and brought back from disk.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 Oracle, Inc.  All Rights Reserved.
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
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_DEV >/dev/null 2>&1
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+nsexec=$here/src/nsexec
+file=$SCRATCH_MNT/file1
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports user namespace
+_supported_os Linux
+
+[ -x $nsexec ] || _notrun "$nsexec executable not found"
+
+rm -f $seqres.full
+
+_require_scratch
+_need_to_be_root
+_acl_setup_ids
+_require_acls
+
+_print_getfacls()
+{
+    echo "From init_user_ns"
+    getfacl -n $file 2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+
+    echo "From user_ns"
+    $nsexec -U -M "0 $acl1 1000" -G "0 $acl2 1000" getfacl -n $file  2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+}
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***" >>$seqres.full
+echo ""             >>$seqres.full
+_scratch_mkfs       >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+touch $file
+chown $acl1.$acl1 $file
+
+# set acls from init_user_ns, to be checked from inside the userns
+setfacl -n -m u:$acl2:rw,g:$acl2:r $file
+# set acls from inside userns, to be checked from init_user_ns
+$nsexec -s -U -M "0 $acl1 1000" -G "0 $acl2 1000" setfacl -n -m u:root:rx,g:root:x $file
+
+_print_getfacls
+
+echo "*** Remounting ***"
+echo ""
+sync
+umount $SCRATCH_MNT >>$seqres.full 2>&1
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+_print_getfacls
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+status=0
+exit
diff --git a/tests/generic/314.out b/tests/generic/314.out
new file mode 100644
index 0000000..b88354c
--- /dev/null
+++ b/tests/generic/314.out
@@ -0,0 +1,51 @@
+QA output created by 314
+From init_user_ns
+# file: mnt/xfs-scratch/file1
+# owner: id1
+# group: id1
+user::rw-
+user:id1:r-x	#effective:r--
+user:id2:rw-	#effective:r--
+group::r--
+group:id2:--x	#effective:---
+mask::r--
+other::r--
+
+From user_ns
+# file: mnt/xfs-scratch/file1
+# owner: 0
+# group: 65534
+user::rw-
+user:0:r-x	#effective:r--
+user:1:rw-	#effective:r--
+group::r--
+group:0:--x	#effective:---
+mask::r--
+other::r--
+
+*** Remounting ***
+
+From init_user_ns
+# file: mnt/xfs-scratch/file1
+# owner: id1
+# group: id1
+user::rw-
+user:id1:r-x	#effective:r--
+user:id2:rw-	#effective:r--
+group::r--
+group:id2:--x	#effective:---
+mask::r--
+other::r--
+
+From user_ns
+# file: mnt/xfs-scratch/file1
+# owner: 0
+# group: 65534
+user::rw-
+user:0:r-x	#effective:r--
+user:1:rw-	#effective:r--
+group::r--
+group:0:--x	#effective:---
+mask::r--
+other::r--
+
diff --git a/tests/generic/group b/tests/generic/group
index 5c2b4d7..ead1cb1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -116,3 +116,4 @@
 311 auto metadata log
 312 auto quick prealloc enospc
 313 auto metadata quick
+314 acl attr auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
