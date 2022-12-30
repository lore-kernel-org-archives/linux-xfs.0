Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A619EC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiLaAyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:54:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A378F13F29;
        Fri, 30 Dec 2022 16:54:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2E7FCE19E1;
        Sat, 31 Dec 2022 00:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B792C433D2;
        Sat, 31 Dec 2022 00:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448086;
        bh=lOEvJO+L4lcJOQr7DNWMOyIvATKtyraDCPdIvpidMoY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dryJ4lApUWqc9MDK9fpsFK67HiOvQo0hPqiZPiqKV3AnenBqFoI2S7gqZL5P1lGug
         IVYO8wmobOhaSDZtbX+BM1vJJkT8EjZXoDAKYXx6jmaZPHZMF9FwvxpRyoIKhbuzDd
         YIeC21/jPRILXoVDNRtyeiUCbsDDjenn90+m5c0K/CLAs5ikNsXLvNBk8MlTVIyc2E
         TDw2bslPLvYiy9C0W5lkcRLQ3mNnin5sfuNjxP5Qf57PAow8yhcl14qZNAVDjYPyZZ
         oSrFYA6rXJzLBCeJTsTvzGHAranTHaIAZKgHw19Eq0Cx9Qqodm48fGnk7PnHbZJoYA
         NLhSqlkLXhPLA==
Subject: [PATCH 1/1] xfs: test xfs_scrub dry run, preen, and repair mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880087.733786.8534253614638778774.stgit@magnolia>
In-Reply-To: <167243880076.733786.4193492627332162854.stgit@magnolia>
References: <167243880076.733786.4193492627332162854.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For each of the three operational modes of xfs_scrub, make sure that we
/only/ repair that which we're supposed to.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/850     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/850.out |   32 ++++++++++++++++
 2 files changed, 137 insertions(+)
 create mode 100755 tests/xfs/850
 create mode 100644 tests/xfs/850.out


diff --git a/tests/xfs/850 b/tests/xfs/850
new file mode 100755
index 0000000000..bb46915c89
--- /dev/null
+++ b/tests/xfs/850
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 850
+#
+# Make sure that xfs_scrub dry run, preen, and repair modes only modify the
+# things that they're allowed to touch.
+#
+. ./common/preamble
+_begin_fstest auto quick online_repair
+
+# Import common functions.
+. ./common/fuzzy
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_scratch_nocheck
+_require_scrub
+_require_xfs_db_command "fuzz"
+_require_xfs_io_command "repair"
+
+# Make sure we support repair?
+output="$($XFS_IO_PROG -x -c 'repair -R probe' $SCRATCH_MNT 2>&1)"
+test -z "$output" && _notrun 'kernel does not support repair'
+
+# Make sure xfs_scrub is new enough to support -p(reen)
+$XFS_SCRUB_PROG -p 2>&1 | grep -q 'invalid option' && \
+	_notrun 'scrub does not support -p'
+
+_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
+. $tmp.mkfs
+
+test $agcount -ge 3 || _notrun 'filesystem must have at least 3 AGs'
+
+AWK_PROG='
+{
+	if ($1 ~ /Optimized:/)
+		optimized++;
+	else if ($1 ~ /Repaired:/)
+		repaired++;
+	else if ($1 ~ /Corruption:/)
+		corruption++;
+}
+END {
+	printf("corruption: %u optimized: %u repaired: %u\n",
+			corruption, optimized, repaired);
+}
+'
+
+test_scrub() {
+	local mode="$1"
+	local scrub_arg="$2"
+	local db_args=(-x)
+
+	# Fuzz secondary superblocks because this won't cause mount failures
+	if [[ $mode =~ c ]]; then
+		db_args+=(-c 'sb 1' -c 'fuzz -d dblocks add')
+	fi
+	if [[ $mode =~ o ]]; then
+		db_args+=(-c 'sb 2' -c 'fuzz -d fname random')
+	fi
+
+	echo "testing mode? $mode scrub_arg $scrub_arg"
+	echo "db_args:${db_args[@]}:scrub_arg:$scrub_arg:$mode:" >> $seqres.full
+	echo "----------------" >> $seqres.full
+
+	_scratch_mkfs >> $seqres.full
+
+	# Make sure there's nothing left to optimize, at least according to
+	# xfs_scrub.  This clears the way for us to make targeted changes to
+	# the filesystem.
+	_scratch_mount
+	_scratch_scrub $scrub_arg >> /dev/null
+	_scratch_unmount
+
+	# Modify the filesystem as needed to trip up xfs_scrub
+	_scratch_xfs_db "${db_args[@]}" >> $seqres.full
+
+	# See how many optimizations, repairs, and corruptions it'll report
+	_scratch_mount
+	_scratch_scrub $scrub_arg 2>&1 | awk "$AWK_PROG"
+	test "${PIPESTATUS[0]}" -eq 0 || echo "xfs_scrub returned ${PIPESTATUS[0]}?"
+	echo
+	_scratch_unmount
+}
+
+test_scrub 'o' -n	# dry run with possible optimizations
+test_scrub 'o' -p	# preen
+test_scrub 'o' 		# repair
+
+test_scrub 'co' -n	# dry run with corruptions and optimizations
+test_scrub 'co' -p	# preen
+test_scrub 'co' 	# repair
+
+test_scrub 'c' -n	# dry run with corruptions
+test_scrub 'c' -p	# preen
+test_scrub 'c' 		# repair
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/850.out b/tests/xfs/850.out
new file mode 100644
index 0000000000..6e43fd919d
--- /dev/null
+++ b/tests/xfs/850.out
@@ -0,0 +1,32 @@
+QA output created by 850
+testing mode? o scrub_arg -n
+corruption: 0 optimized: 0 repaired: 0
+
+testing mode? o scrub_arg -p
+corruption: 0 optimized: 1 repaired: 0
+
+testing mode? o scrub_arg 
+corruption: 0 optimized: 1 repaired: 0
+
+testing mode? co scrub_arg -n
+corruption: 1 optimized: 0 repaired: 0
+xfs_scrub returned 1?
+
+testing mode? co scrub_arg -p
+corruption: 1 optimized: 0 repaired: 0
+xfs_scrub returned 1?
+
+testing mode? co scrub_arg 
+corruption: 0 optimized: 1 repaired: 1
+
+testing mode? c scrub_arg -n
+corruption: 1 optimized: 0 repaired: 0
+xfs_scrub returned 1?
+
+testing mode? c scrub_arg -p
+corruption: 1 optimized: 0 repaired: 0
+xfs_scrub returned 1?
+
+testing mode? c scrub_arg 
+corruption: 0 optimized: 0 repaired: 1
+

