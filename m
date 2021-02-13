Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30BAC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDA53601FC
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhBMFe6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhBMFe5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528F864E68;
        Sat, 13 Feb 2021 05:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194447;
        bh=75Tytqmf8MEBUHfeLNpB8j3oC9+n9ebyyaCdxVi8uJg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XVifbqdoDOAMsqeW7JkAOCmeXCd1/IVumFmaSfU9yu8Z630ljAfD54NSGrE3CBemP
         zOHTXxTbiccxodK8CEsfeeAmao3ps0OStOk/FUR/2IHOCpeWvDncsiQdZhyoaD66ku
         xAH5HHwXitR3eVMqJ/Bivou6GS4zp2V7f/73Kqj9I7hFfkHMar8pbGxu2SlJ+jV6ZG
         5AmdktLmET2dLJWinyzuFD7fQx18OxDVWcuFahZfrMgxFvA4Nhc1GXWsU5eKr4ykfd
         ZL2qkkx1e43/9EWclq+jgiXKU9UPP4g6+Se444Kct2lExk5n2whCtPYQGvTg0EzQhh
         BM1ubkGMJ8Twg==
Subject: [PATCH 3/4] xfs: detect time limits from filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:34:07 -0800
Message-ID: <161319444701.403615.1697502862999284423.stgit@magnolia>
In-Reply-To: <161319443045.403615.18346950431837086632.stgit@magnolia>
References: <161319443045.403615.18346950431837086632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach fstests to extract timestamp limits of a filesystem using the new
xfs_db timelimit command.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         |    2 +-
 common/xfs        |   19 +++++++++++++++++++
 tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/911.out |   15 +++++++++++++++
 tests/xfs/group   |    1 +
 5 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out


diff --git a/common/rc b/common/rc
index 082699bb..e1f96393 100644
--- a/common/rc
+++ b/common/rc
@@ -2066,7 +2066,7 @@ _filesystem_timestamp_range()
 		echo "0 $u32max"
 		;;
 	xfs)
-		echo "$s32min $s32max"
+		_xfs_timestamp_range "$device"
 		;;
 	btrfs)
 		echo "$s64min $s64max"
diff --git a/common/xfs b/common/xfs
index 30544f88..294b8c4d 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1065,3 +1065,22 @@ _require_xfs_scratch_inobtcount()
 		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+_xfs_timestamp_range()
+{
+	local device="$1"
+	local use_db=0
+	local dbprog="$XFS_DB_PROG $device"
+	test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
+
+	$dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
+	if [ $use_db -eq 0 ]; then
+		# The "timelimit" command was added to xfs_db at the same time
+		# that bigtime was added to xfsprogs.  Therefore, we can assume
+		# the old timestamp range if the command isn't present.
+		echo "-$((1<<31)) $(((1<<31)-1))"
+	else
+		$dbprog -f -c 'timelimit --compact' | \
+			awk '{printf("%s %s", $1, $2);}'
+	fi
+}
diff --git a/tests/xfs/911 b/tests/xfs/911
new file mode 100755
index 00000000..01ddb856
--- /dev/null
+++ b/tests/xfs/911
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 911
+#
+# Check that the xfs_db timelimit command prints the ranges that we expect.
+# This in combination with an xfs_ondisk.h build time check in the kernel
+# ensures that the kernel agrees with userspace.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_db_command timelimit
+
+rm -f $seqres.full
+
+# Format filesystem without bigtime support and populate it
+_scratch_mkfs > $seqres.full
+echo classic xfs timelimits
+_scratch_xfs_db -c 'timelimit --classic'
+echo bigtime xfs timelimits
+_scratch_xfs_db -c 'timelimit --bigtime'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/911.out b/tests/xfs/911.out
new file mode 100644
index 00000000..84dc475b
--- /dev/null
+++ b/tests/xfs/911.out
@@ -0,0 +1,15 @@
+QA output created by 911
+classic xfs timelimits
+time.min = -2147483648
+time.max = 2147483647
+dqtimer.min = 1
+dqtimer.max = 4294967295
+dqgrace.min = 0
+dqgrace.min = 4294967295
+bigtime xfs timelimits
+time.min = -2147483648
+time.max = 16299260424
+dqtimer.min = 4
+dqtimer.max = 16299260424
+dqgrace.min = 0
+dqgrace.min = 4294967295
diff --git a/tests/xfs/group b/tests/xfs/group
index 90d2098f..a585c3b4 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -510,6 +510,7 @@
 768 auto quick repair
 770 auto repair
 910 auto quick inobtcount
+911 auto quick bigtime
 915 auto quick quota
 917 auto quick db
 918 auto quick db

