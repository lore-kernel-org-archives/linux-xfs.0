Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbdJOFHy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Oct 2017 01:07:54 -0400
Date: Sat, 14 Oct 2017 22:07:51 -0700
From: Shaohua Li <shli@kernel.org>
Subject: [PATCH V2] xfs: implement cgroup writeback support
Message-ID: <20171015050751.dfznko2hxhi6jvra@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ybjc454kubnt76ke"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Cc: david@fromorbit.com, tj@kernel.org, Kernel-team@fb.com


--ybjc454kubnt76ke
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Shaohua Li <shli@fb.com>

Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
writeback support). Tested with a fio test, verified writeback is
throttled against cgroup io.max write bandwidth, also verified moving
the fio test to another cgroup and the writeback is throttled against
new cgroup setting.

I created a test for this as attached, please try! I'll send the test out for
inclusion later.

Cc: Tejun Heo <tj@kernel.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 fs/xfs/xfs_aops.c  | 12 ++++++++++--
 fs/xfs/xfs_super.c |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2917260..0c41f82 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -561,7 +561,8 @@ xfs_alloc_ioend(
 	struct inode		*inode,
 	unsigned int		type,
 	xfs_off_t		offset,
-	struct buffer_head	*bh)
+	struct buffer_head	*bh,
+	struct writeback_control *wbc)
 {
 	struct xfs_ioend	*ioend;
 	struct bio		*bio;
@@ -578,6 +579,8 @@ xfs_alloc_ioend(
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	ioend->io_append_trans = NULL;
 	ioend->io_bio = bio;
+	/* attach new bio to its cgroup */
+	wbc_init_bio(wbc, bio);
 	return ioend;
 }
 
@@ -605,6 +608,8 @@ xfs_chain_bio(
 	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	ioend->io_bio = new;
+	/* attach new bio to its cgroup */
+	wbc_init_bio(wbc, new);
 }
 
 /*
@@ -628,7 +633,7 @@ xfs_add_to_ioend(
 	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
 		if (wpc->ioend)
 			list_add(&wpc->ioend->io_list, iolist);
-		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
+		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh, wbc);
 	}
 
 	/*
@@ -638,6 +643,9 @@ xfs_add_to_ioend(
 	while (xfs_bio_add_buffer(wpc->ioend->io_bio, bh) != bh->b_size)
 		xfs_chain_bio(wpc->ioend, wbc, bh);
 
+	/* Charge write size to its cgroup for cgroup switching track */
+	wbc_account_io(wbc, bh->b_page, bh->b_size);
+
 	wpc->ioend->io_size += bh->b_size;
 	wpc->last_block = bh->b_blocknr;
 	xfs_start_buffer_writeback(bh);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c996f4a..41eb6e0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1634,6 +1634,7 @@ xfs_fs_fill_super(
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
+	sb->s_iflags |= SB_I_CGROUPWB;
 
 	/* version 5 superblocks support inode version counters. */
 	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
-- 
2.9.5


--ybjc454kubnt76ke
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-cgroup2-writeback-test.patch"

>From 0edbc6d9f7abae299d6b1bd4b8ad76728afab313 Mon Sep 17 00:00:00 2001
Message-Id: <0edbc6d9f7abae299d6b1bd4b8ad76728afab313.1508043579.git.shli@fb.com>
From: Shaohua Li <shli@fb.com>
Date: Sat, 14 Oct 2017 18:57:06 -0700
Subject: [PATCH] Add cgroup2 writeback test

---
 common/cgroup2        | 18 +++++++++++++++++
 tests/generic/463     | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/463.out |  2 ++
 tests/generic/group   |  1 +
 4 files changed, 77 insertions(+)
 create mode 100644 common/cgroup2
 create mode 100755 tests/generic/463
 create mode 100644 tests/generic/463.out

diff --git a/common/cgroup2 b/common/cgroup2
new file mode 100644
index 00000000..130c2f79
--- /dev/null
+++ b/common/cgroup2
@@ -0,0 +1,18 @@
+#!/bin/bash
+# cgroup2 specific common functions
+
+export CGROUP2_PATH="/sys/fs/cgroup"
+
+_require_cgroup2()
+{
+	if [ ! -f ${CGROUP2_PATH}/cgroup.subtree_control ]; then
+		_notrun "Test requires cgroup2 enabled"
+	fi
+}
+
+_get_scratch_dev_devt()
+{
+	ls -l $SCRATCH_DEV | awk '{printf("%s:%s", substr($5, 1, length($5)-1), 0)}'
+}
+
+/bin/true
diff --git a/tests/generic/463 b/tests/generic/463
new file mode 100755
index 00000000..8dafadb0
--- /dev/null
+++ b/tests/generic/463
@@ -0,0 +1,56 @@
+#! /bin/bash
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/cgroup2
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+cgname=`mktemp -du ${CGROUP2_PATH}/test.XXXXXX`
+_cleanup()
+{
+    _scratch_unmount
+    cd /
+    rmdir $cgname
+}
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_cgroup2
+
+# Setup Filesystem
+_scratch_mkfs >/dev/null 2>&1 \
+        || _fail "mkfs failed"
+
+_scratch_mount \
+        || _fail "mount failed"
+
+echo +io > /sys/fs/cgroup/cgroup.subtree_control
+mkdir $cgname
+
+wbytes=$(
+echo $BASHPID > $cgname/cgroup.procs;
+dd if=/dev/zero of=$SCRATCH_MNT/image bs=1M count=100 >/dev/null 2>&1;
+# Makre sure writeback starts
+sleep 120;
+cat $cgname/io.stat | sed -n "s/$(_get_scratch_dev_devt).*wbytes=\([0-9]*\).*/\1/p"
+)
+
+[ -z "$wbytes" -o "$wbytes" = "0" ] && _fail "Cgroup writeback doesn't work"
+echo "Cgroup writeback test success"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/463.out b/tests/generic/463.out
new file mode 100644
index 00000000..211da95e
--- /dev/null
+++ b/tests/generic/463.out
@@ -0,0 +1,2 @@
+QA output created by 463
+Cgroup writeback test success
diff --git a/tests/generic/group b/tests/generic/group
index f2a6cdad..ea7b6956 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -465,3 +465,4 @@
 460 auto quick rw
 461 auto shutdown stress
 462 auto quick dax
+463 cgroup writeback test
-- 
2.11.0


--ybjc454kubnt76ke--
