Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4914C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 04:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiKGE4Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Nov 2022 23:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiKGE4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2022 23:56:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EBD60D8;
        Sun,  6 Nov 2022 20:56:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD37560E86;
        Mon,  7 Nov 2022 04:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBC9C433C1;
        Mon,  7 Nov 2022 04:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667796982;
        bh=Ql15oxiALhcE913iut5NrC98u0ZWQRn2KS1/NnPu/yU=;
        h=From:To:Cc:Subject:Date:From;
        b=BmrBcUngNaJY8MVJZh2Fn0JeVuqt+rSwHuC1zfgelb+gzn2LaN+/SMwpdEvgtNjlf
         5huXL0XWEn31Vy0u7JYdvxM3n+5oUhOqKhxzG9wdxb178c9XplS2vm0ua4dLcTXBw6
         bcYen5qz7d1/t3pZtfGz+41yUeysj1tNZBM2NNlA9nmbyU3SK2EJRvvjRE+EGER85X
         7Z3Kpf2wG8dfHGKK9rxQ6UJ90LiqM6+6Z8v62racGJszOL0cFh30zA+izd1+NYOI1F
         guA/vuhbYu1fsyPL2EcnOWTVlYJLt5KY65b1U163lg58GHWvw6j3xEzQUjdG8eBK5f
         O5iQ2QFxg/B+w==
From:   Zorro Lang <zlang@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] generic: check logical-sector sized O_DIRECT
Date:   Mon,  7 Nov 2022 12:56:18 +0800
Message-Id: <20221107045618.2772009-1-zlang@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the physical sector size is 4096, but the logical sector size
is 512, the 512b dio write/read should be allowed.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---

Hi,

This reproducer was written for xfs, I try to make it to be a generic
test case for localfs. Current it test passed on xfs, extN and btrfs,
the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
someone fs, please feel free to tell me.

Thanks,
Zorro

[1]
# ./check generic/888
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch

generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
    --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
    +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
    @@ -4,3 +4,4 @@
     512
     mkfs and mount
     DIO read/write 512 bytes
    +pwrite64: Invalid argument
    ...
    (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
Ran: generic/888
Failures: generic/888
Failed 1 of 1 tests

 tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/888.out |  6 +++++
 2 files changed, 58 insertions(+)
 create mode 100755 tests/generic/888
 create mode 100644 tests/generic/888.out

diff --git a/tests/generic/888 b/tests/generic/888
new file mode 100755
index 00000000..b5075d1e
--- /dev/null
+++ b/tests/generic/888
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 888
+#
+# Make sure logical-sector sized O_DIRECT write is allowed
+#
+. ./common/preamble
+_begin_fstest auto quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
+	_put_scsi_debug_dev
+}
+
+# Import common functions.
+. ./common/scsi_debug
+
+# real QA test starts here
+_supported_fs generic
+_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
+_require_scsi_debug
+# If TEST_DEV is block device, make sure current fs is a localfs which can be
+# written on scsi_debug device
+_require_test
+_require_block_device $TEST_DEV
+
+echo "Get a device with 4096 physical sector size and 512 logical sector size"
+SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
+blockdev --getpbsz --getss $SCSI_DEBUG_DEV
+
+echo "mkfs and mount"
+_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
+SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
+rm -rf $SCSI_DEBUG_MNT
+mkdir $SCSI_DEBUG_MNT
+run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
+
+echo "DIO read/write 512 bytes"
+# This dio write should succeed, even the physical sector size is 4096, but
+# the logical sector size is 512
+$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
+$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/888.out b/tests/generic/888.out
new file mode 100644
index 00000000..0f142ce9
--- /dev/null
+++ b/tests/generic/888.out
@@ -0,0 +1,6 @@
+QA output created by 888
+Get a device with 4096 physical sector size and 512 logical sector size
+4096
+512
+mkfs and mount
+DIO read/write 512 bytes
-- 
2.31.1

