Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfADXO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 18:14:56 -0500
Date: Fri, 4 Jan 2019 15:14:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] generic: test that xattrs can have slashes in their names
Message-ID: <20190104231448.GF12689@magnolia>
References: <20190104212336.GC12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104212336.GC12689@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Eric Sandeen recently found a bug in xfs_repair that flagged extended
attribute names containing "/" as corrupt and purged them.  There's
nothing in the IRIX or Linux manuals that say anything about slashes not
being allowed (and Linux certainly allows this) so let's make sure this
continues to work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/generic/708     |   50 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/708.out |    6 ++++++
 tests/generic/group   |    1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/708
 create mode 100644 tests/generic/708.out

diff --git a/tests/generic/708 b/tests/generic/708
new file mode 100755
index 00000000..c32f966c
--- /dev/null
+++ b/tests/generic/708
@@ -0,0 +1,50 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 708
+#
+# Check that xattrs can have slashes in their name.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/attr
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_attrs
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+echo "set attr"
+file=$SCRATCH_MNT/moofile
+touch $file
+setfattr -n "user.boo/hoo" -v "woof" $file
+
+echo "check attr"
+getfattr -d --absolute-names $file | _filter_scratch
+
+# Now we let the fsck tool check the filesystem, because xfs_repair had a
+# regression where it would flag and erase any xattr with a '/' in it.
+
+status=0
+exit
diff --git a/tests/generic/708.out b/tests/generic/708.out
new file mode 100644
index 00000000..6978532e
--- /dev/null
+++ b/tests/generic/708.out
@@ -0,0 +1,6 @@
+QA output created by 708
+set attr
+check attr
+# file: SCRATCH_MNT/moofile
+user.boo/hoo="woof"
+
diff --git a/tests/generic/group b/tests/generic/group
index ea5aa7aa..f88125b4 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -525,3 +525,4 @@
 520 auto quick log
 521 soak long_rw
 522 soak long_rw
+708 auto quick attr
