Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404B7C2D0BF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D9052176D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfLQWeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:34:09 -0500
Received: from sandeen.net ([63.231.237.45]:36632 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfLQWeI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Dec 2019 17:34:08 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D3D80F8AF6;
        Tue, 17 Dec 2019 16:33:54 -0600 (CST)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH V2] fstests: verify that xfs_growfs can operate on mounted
 device node
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4cdefab7-02f0-7703-a3d2-8c2b3ce655b7@sandeen.net>
Date:   Tue, 17 Dec 2019 16:34:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The ability to use a mounted device node as the primary argument
to xfs_growfs was added back in with:
  7e8275f8 xfs_growfs: allow mounted device node as argument
because it was an undocumented behavior that some userspace depended on.
This test exercises that functionality.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Address Eryu's review concerns

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 00000000..186a29eb
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 999
+#
+# Test to ensure xfs_growfs command accepts device nodes if & only
+# if they are mounted.
+# This functionality, though undocumented, worked until xfsprogs v4.12
+# It was added back and documented after xfsprogs v5.2 via
+#   7e8275f8 xfs_growfs: allow mounted device node as argument
+#
+# Based on xfs/289
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+loopfile=$TEST_DIR/fsfile
+mntdir=$TEST_DIR/mntdir
+loop_symlink=$TEST_DIR/loop_symlink.$$
+
+_cleanup()
+{
+    $UMOUNT_PROG $mntdir
+    [ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
+    rmdir $mntdir
+    rm -f $loop_symlink
+    rm -f $loopfile
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
+mkdir -p $mntdir || _fail "!!! failed to create temp mount dir"
+
+echo "=== mkfs.xfs ==="
+$MKFS_XFS_PROG -d file,name=$loopfile,size=16m -f >/dev/null 2>&1
+
+echo "=== truncate ==="
+$XFS_IO_PROG -fc "truncate 256m" $loopfile
+
+echo "=== create loop device ==="
+loop_dev=$(_create_loop_device $loopfile)
+
+echo "=== create loop device symlink ==="
+ln -s $loop_dev $loop_symlink
+
+echo "loop device is $loop_dev" >> $seqres.full
+
+# These unmounted operations should fail
+
+echo "=== xfs_growfs - unmounted device, command should be rejected ==="
+$XFS_GROWFS_PROG $loop_dev 2>&1 | sed -e s:$loop_dev:LOOPDEV:
+
+echo "=== xfs_growfs - check symlinked dev, unmounted ==="
+$XFS_GROWFS_PROG $loop_symlink 2>&1 | sed -e s:$loop_symlink:LOOPSYMLINK:
+
+# These mounted operations should pass
+
+echo "=== mount ==="
+$MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
+
+echo "=== xfs_growfs - check device node ==="
+$XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
+
+echo "=== xfs_growfs - check device symlink ==="
+$XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
+
+echo "=== unmount ==="
+$UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
+
+echo "=== mount device symlink ==="
+$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
+
+echo "=== xfs_growfs - check device symlink ==="
+$XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
+
+echo "=== xfs_growfs - check device node ==="
+$XFS_GROWFS_PROG -D 20480 $loop_dev > /dev/null
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 00000000..ababb892
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,16 @@
+QA output created by 999
+=== mkfs.xfs ===
+=== truncate ===
+=== create loop device ===
+=== create loop device symlink ===
+=== xfs_growfs - unmounted device, command should be rejected ===
+xfs_growfs: LOOPDEV is not a mounted XFS filesystem
+=== xfs_growfs - check symlinked dev, unmounted ===
+xfs_growfs: LOOPSYMLINK is not a mounted XFS filesystem
+=== mount ===
+=== xfs_growfs - check device node ===
+=== xfs_growfs - check device symlink ===
+=== unmount ===
+=== mount device symlink ===
+=== xfs_growfs - check device symlink ===
+=== xfs_growfs - check device node ===
diff --git a/tests/xfs/group b/tests/xfs/group
index 4373d082..ff251002 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -508,3 +508,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+999 quick auto growfs

