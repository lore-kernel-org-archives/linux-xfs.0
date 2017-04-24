Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934180AbdDXOgD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 10:36:03 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E481940F15
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 14:36:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-64.rdu2.redhat.com [10.10.121.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E8FF8387E
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2017 14:36:02 +0000 (UTC)
From: Bill O'Donnell <billodo@redhat.com>
Subject: [PATCH] xfstests: test xfs_growfs to ensure rejection if target isn't mounted
Date: Mon, 24 Apr 2017 09:36:01 -0500
Message-Id: <20170424143601.26522-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The manpage for xfs_growfs specifies that the file/dir to be
grown must be mounted. This is a test to ensure that if the
target isn't mounted, the command is rejected. The test covers
absolute paths and relative paths, including symbolic links
and bind mounts.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 tests/xfs/288     | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/288.out | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 243 insertions(+)
 create mode 100755 tests/xfs/288
 create mode 100644 tests/xfs/288.out

diff --git a/tests/xfs/288 b/tests/xfs/288
new file mode 100755
index 0000000..bd3dac0
--- /dev/null
+++ b/tests/xfs/288
@@ -0,0 +1,123 @@
+#! /bin/bash
+# FS QA Test 288
+#
+# Test to ensure xfs_growfs command rejects non-existent mount points
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
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
+    umount $tmpdir
+    umount $tmpbind
+    rmdir $tmpdir
+    rm -f $tmpsymlink
+    rmdir $tmpbind
+    rm -f $tmp
+    rm -f $tmpfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_loop
+
+tmpfile=$TEST_DIR/fsfile
+tmpdir=$TEST_DIR/tmpdir
+tmpsymlink=$TEST_DIR/tmpsymlink.$$
+tmpbind=$TEST_DIR/tmpbind.$$
+tmpdir2=$TEST_DIR/tmpdir2
+
+mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"
+mkdir -p $tmpdir2 || _fail "!!! failed to create temp mount dir"
+
+echo "=== mkfs.xfs ==="
+mkfs.xfs -d file,name=$tmpfile,size=64m -f
+
+echo "=== truncate ==="
+truncate --size=128m $tmpfile
+
+echo "=== xfs_growfs - unmounted, command should be rejected ==="
+xfs_growfs $tmpdir
+
+echo "=== xfs_growfs - check relative path, unmounted ==="
+cd $TEST_DIR
+xfs_growfs ./tmpdir
+
+echo "=== xfs_growfs - no path, unmounted ==="
+cd $TEST_DIR
+xfs_growfs tmpdir
+
+echo "=== mount ==="
+mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
+
+echo "=== xfs_growfs - mounted ==="
+xfs_growfs $tmpdir
+
+echo "=== xfs_growfs - check relative path ==="
+cd $TEST_DIR
+xfs_growfs ./tmpdir
+
+echo "=== xfs_growfs - no path ==="
+cd $TEST_DIR
+xfs_growfs tmpdir
+
+echo "=== test symbolic link ==="
+ln -s $tmpdir $tmpsymlink
+xfs_growfs $tmpsymlink
+
+echo "=== test symbolic link using relative path ==="
+xfs_growfs ./tmpsymlink.$$
+
+echo "=== test symbolic link using no path ==="
+xfs_growfs tmpsymlink.$$
+
+echo "=== test bind mount ==="
+mkdir $tmpbind
+mount -o bind $tmpdir $tmpbind
+xfs_growfs $tmpbind
+
+echo "=== test bind mount - relative path ==="
+
+xfs_growfs ./tmpbind.$$
+
+echo "=== test bind mount - no path ==="
+xfs_growfs tmpbind.$$
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/288.out b/tests/xfs/288.out
new file mode 100644
index 0000000..a526048
--- /dev/null
+++ b/tests/xfs/288.out
@@ -0,0 +1,119 @@
+QA output created by 288
+=== mkfs.xfs ===
+meta-data=/mnt/test/fsfile       isize=512    agcount=4, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
+data     =                       bsize=4096   blocks=16384, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal log           bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== truncate ===
+=== xfs_growfs - unmounted, command should be rejected ===
+xfs_growfs: /mnt/test/tmpdir is not a mounted XFS filesystem
+=== xfs_growfs - check relative path, unmounted ===
+xfs_growfs: ./tmpdir is not a mounted XFS filesystem
+=== xfs_growfs - no path, unmounted ===
+xfs_growfs: tmpdir is not a mounted XFS filesystem
+=== mount ===
+=== xfs_growfs - mounted ===
+meta-data=/dev/loop0             isize=512    agcount=4, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=16384, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+data blocks changed from 16384 to 32768
+=== xfs_growfs - check relative path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== xfs_growfs - no path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test symbolic link ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test symbolic link using relative path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test symbolic link using no path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test bind mount ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test bind mount - relative path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
+=== test bind mount - no path ===
+meta-data=/dev/loop0             isize=512    agcount=8, agsize=4096 blks
+         =                       sectsz=512   attr=2, projid32bit=1
+         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
+         =                       reflink=0
+data     =                       bsize=4096   blocks=32768, imaxpct=25
+         =                       sunit=0      swidth=0 blks
+naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
+log      =internal               bsize=4096   blocks=855, version=2
+         =                       sectsz=512   sunit=0 blks, lazy-count=1
+realtime =none                   extsz=4096   blocks=0, rtextents=0
diff --git a/tests/xfs/group b/tests/xfs/group
index 75769f9..0dcb8e0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -285,6 +285,7 @@
 285 dangerous_fuzzers dangerous_scrub
 286 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 287 auto dump quota quick
+288 growfs auto quick
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.9.3

