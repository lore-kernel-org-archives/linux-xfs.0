Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CE2C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiLaDQS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiLaDP7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:15:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232381021;
        Fri, 30 Dec 2022 19:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B230A61D12;
        Sat, 31 Dec 2022 03:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFEFC433EF;
        Sat, 31 Dec 2022 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456557;
        bh=nM2u7XBrmsx1R39s/7nWtTPRmyzfjZ0rVAVb5NfQgFs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SjV5gUES0xgykpUmTjnOuvyZL3H+CoZPQQfnrkLIcyCI496F6IQHeT5B18eVURRpV
         MsizpqQrUk07E/NXqz4DVG7GbT6tSV8YRF93kZddZl6dCZPKQntBq1SdJUpkGHrdrQ
         7PNJ7/KIjuwd7SnLW5LIhvDAmrNw+XokZqx3QAUu+irRi5gc8L7JzzMP53hEPrcKmz
         Rv621VbVnjTzNDZdZ2CREOot18gRMW5X22TCJ3g2CaB5BZaOnXYOIROCa/yDeqcETG
         jS0PkQO7+/+/UHcyVhv1ODW/5v1/9G3WisOhHQLruviGbhDBiuP3g6/Axd3IX869F8
         flj2cwcupJRHA==
Subject: [PATCH 13/13] fuzzy: create missing fuzz tests for rt rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884564.739669.10126609995882362405.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Back when I first created the fuzz tests for the realtime rmap btree, I
forgot a couple of things.  Add tests to fuzz rtrmap btree leaf records,
and node keys.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1528     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 ++++
 tests/xfs/1529     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 ++++
 tests/xfs/407      |    2 +-
 5 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out


diff --git a/tests/xfs/1528 b/tests/xfs/1528
new file mode 100755
index 0000000000..b2e1193ebd
--- /dev/null
+++ b/tests/xfs/1528
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1528
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt record field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
+
+echo "Fuzz rtrmapbt recs"
+_scratch_xfs_fuzz_metadata '' 'both' "path -m $path" "addr u${inode_ver}.rtrmapbt.ptrs[1]" >> $seqres.full
+echo "Done fuzzing rtrmapbt recs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1528.out b/tests/xfs/1528.out
new file mode 100644
index 0000000000..b51b640c40
--- /dev/null
+++ b/tests/xfs/1528.out
@@ -0,0 +1,4 @@
+QA output created by 1528
+Format and populate
+Fuzz rtrmapbt recs
+Done fuzzing rtrmapbt recs
diff --git a/tests/xfs/1529 b/tests/xfs/1529
new file mode 100755
index 0000000000..91a673c049
--- /dev/null
+++ b/tests/xfs/1529
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1529
+#
+# Populate a XFS filesystem and fuzz every rtrmapbt keyptr field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
+	_fail "could not find two-level rtrmapbt"
+
+echo "Fuzz rtrmapbt keyptrs"
+_scratch_xfs_fuzz_metadata '(rtrmapbt)' 'offline' "path -m $path" >> $seqres.full
+echo "Done fuzzing rtrmapbt keyptrs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1529.out b/tests/xfs/1529.out
new file mode 100644
index 0000000000..808fcc957f
--- /dev/null
+++ b/tests/xfs/1529.out
@@ -0,0 +1,4 @@
+QA output created by 1529
+Format and populate
+Fuzz rtrmapbt keyptrs
+Done fuzzing rtrmapbt keyptrs
diff --git a/tests/xfs/407 b/tests/xfs/407
index 2460ea336c..bd439105e2 100755
--- a/tests/xfs/407
+++ b/tests/xfs/407
@@ -26,7 +26,7 @@ _require_scratch_xfs_fuzz_fields
 echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 
-path="$(_scratch_xfs_find_rgbtree_height 'rmap' 1)" || \
+path="$(_scratch_xfs_find_rgbtree_height 'rmap' 2)" || \
 	_fail "could not find two-level rtrmapbt"
 inode_ver=$(_scratch_xfs_get_metadata_field "core.version" "path -m $path")
 

