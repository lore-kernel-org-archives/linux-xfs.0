Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2AFC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC2BB61420
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 00:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhDUAXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbhDUAXx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 20:23:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6BF6141F;
        Wed, 21 Apr 2021 00:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964601;
        bh=RyKoLmbrbH6XqUy1EbZr5UJ84//p0tSP+g9dKjlcG6c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qwJLyo9NrTjYXr0xOIY0WmDCEstDGNXrdyhWZGuSROV8rDkB2WcNXYiEPPAaX11Ua
         Qh0FT6ntrYmSevmfyQE51uYm/ipPvo6tDOtEM59CYZt2g36n0HxK7YAjlHhQHxOaKh
         jo3nMWmv1WjEgPH8GgZ6C1MtVWjY6dkCfv/vFFE9SyfmPRPHE90T1GO8nwRAO6sOet
         BOBx+0tdpXnC3U2/8jI7WXYFD3PN+ukMupZ+TDgWCAKbK2QTwz5iOcXPm33M9neGYe
         3RmfbMvDQHBQLEPoQoEELkiDvmG6x8sMNsfepY3jtJd36v58J3ZMEYszri4ry5O4pk
         I4OUa4W8DsajQ==
Subject: [PATCH 3/4] xfs: detect time limits from filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Apr 2021 17:23:20 -0700
Message-ID: <161896460011.776452.12958363566736119178.stgit@magnolia>
In-Reply-To: <161896458140.776452.9583732658582318883.stgit@magnolia>
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
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
index 11ff7635..116d7b20 100644
--- a/common/rc
+++ b/common/rc
@@ -2124,7 +2124,7 @@ _filesystem_timestamp_range()
 		echo "0 $u32max"
 		;;
 	xfs)
-		echo "$s32min $s32max"
+		_xfs_timestamp_range "$device"
 		;;
 	btrfs)
 		echo "$s64min $s64max"
diff --git a/common/xfs b/common/xfs
index 3d660858..cb6a1978 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1165,3 +1165,22 @@ _require_scratch_xfs_inobtcount()
 		_notrun "kernel doesn't support xfs inobtcount feature"
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
index bd47333c..b4e29bab 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -527,3 +527,4 @@
 770 auto repair
 773 auto quick repair
 910 auto quick inobtcount
+911 auto quick bigtime

