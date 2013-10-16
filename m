Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 632157F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 10:52:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1E3FAC001
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:52:53 -0700 (PDT)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id XdlZobNc8JemVz3k
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:52:51 -0700 (PDT)
Received: by mail-wg0-f53.google.com with SMTP id y10so926143wgg.8
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:52:50 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] xfstests: add specific test for default ACL inheritance
Date: Wed, 16 Oct 2013 16:52:41 +0100
Message-Id: <1381938761-31625-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: sandeen@sandeen.net, dsterba@suse.cz, jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>

This test is motivated by an issue found by a btrfs user, addressed
and described by the following GNU/Linux kernel patch:

https://patchwork.kernel.org/patch/3046931/

The steps to reproduce the issue on btrfs are the following:

$ mkfs.btrfs -f /dev/loop0
$ mount /dev/loop0 /mnt
$ mkdir /mnt/acl
$ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
$ getfacl /mnt/acl
user::rwx
group::rwx
other::r-x
default:user::rwx
default:group::rwx
default:other::---

$ mkdir /mnt/acl/dir1
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---

After unmounting and mounting again the filesystem, getfacl returned the
expected default ACL for the subdirectory:

$ umount /mnt/acl
$ mount /dev/loop0 /mnt
$ getfacl /mnt/acl/dir1
user::rwx
group::rwx
other::---
default:user::rwx
default:group::rwx
default:other::---

This means that the underlying ACL xattr was persisted correctly but
the in memory representation of the inode had (incorrectly) a NULL ACL.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Moved the regression test into a dedicated and new file, as suggested
    by Eric Sandeen.

 tests/shared/052     |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/052.out |   21 +++++++++++++++
 tests/shared/group   |    1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/shared/052
 create mode 100644 tests/shared/052.out

diff --git a/tests/shared/052 b/tests/shared/052
new file mode 100755
index 0000000..ee08eda
--- /dev/null
+++ b/tests/shared/052
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test No. shared/052
+#
+# Regression test to make sure a directory inherits the default ACL from
+# its parent directory. This test was motivated by an issue reported by
+# a btrfs user. That issue is fixed and described by the following btrfs
+# kernel patch:
+#
+#     https://patchwork.kernel.org/patch/3046931/
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Filipe Manana.  All Rights Reserved.
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
+status=1	# FAILure is the default!
+
+_cleanup()
+{
+       rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_os Linux
+_require_acls
+_require_scratch
+_need_to_be_root
+
+rm -f $seqres.full
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+mkdir $SCRATCH_MNT/testdir
+setfacl -d --set u::rwx,g::rwx,o::- $SCRATCH_MNT/testdir
+getfacl --absolute-names $SCRATCH_MNT/testdir | _filter_scratch
+
+mkdir $SCRATCH_MNT/testdir/testsubdir
+getfacl --absolute-names $SCRATCH_MNT/testdir/testsubdir | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/shared/052.out b/tests/shared/052.out
new file mode 100644
index 0000000..d453175
--- /dev/null
+++ b/tests/shared/052.out
@@ -0,0 +1,21 @@
+QA output created by 052
+# file: SCRATCH_MNT/testdir
+# owner: root
+# group: root
+user::rwx
+group::r-x
+other::r-x
+default:user::rwx
+default:group::rwx
+default:other::---
+
+# file: SCRATCH_MNT/testdir/testsubdir
+# owner: root
+# group: root
+user::rwx
+group::rwx
+other::---
+default:user::rwx
+default:group::rwx
+default:other::---
+
diff --git a/tests/shared/group b/tests/shared/group
index 0ad640b..91cb049 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -5,6 +5,7 @@
 #
 032 mkfs auto quick
 051 acl udf auto quick
+052 acl auto quick
 218 auto fsr quick
 243 auto quick prealloc
 272 auto enospc rw
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
