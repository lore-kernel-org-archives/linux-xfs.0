Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1002AC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiL3W7o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiL3W7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:59:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C291CFC6;
        Fri, 30 Dec 2022 14:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEF4EB81DA0;
        Fri, 30 Dec 2022 22:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C63C433EF;
        Fri, 30 Dec 2022 22:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441179;
        bh=eBH5HRlaZyaoRlLkY0tnOwSqGXaeSmElU7DiKf7+cdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=un5xJwAUSmmErv8W7QLjknMMcQZxG2eg2rVvfGUlgMWvKGwALIEYwuK3ithXkHZg2
         iT5xmPZgHg2vsQBQx6jPpknIHP0JfiGhlLCea+8FJGqxQJoWaeL9RkfR50MLoaPasb
         Gyb0Is+Z1q0jqavCN3RozCU09dEaPdAyVj2UTN7YwiG44Cb+S+Taaoi9nmEKnULRZZ
         BkwLV4XpRnVK1hH4nrU/KSik18H5Q9RACqkrFUvwPX9fMUoAGJ06Ungd6rLw8tsLN4
         O31nBu6xcn8zjGevLVKMfXoRSMbxe9z4ry/o9ZCtQ+yCOnUeFpz1bfeqFfwXRbopnJ
         aNfsRbRMmcjoA==
Subject: [PATCH 2/2] xfs: stress test xfs_scrub(8) with freeze and ro-remount
 loops
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:13:00 -0800
Message-ID: <167243838092.695417.14196982687015485390.stgit@magnolia>
In-Reply-To: <167243838066.695417.12457890635253015617.stgit@magnolia>
References: <167243838066.695417.12457890635253015617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we don't trip over any asserts or livelock when scrub races
with filesystem freezing and readonly remounts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/733     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/733.out |    2 ++
 tests/xfs/771     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/771.out |    2 ++
 tests/xfs/824     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/824.out |    2 ++
 tests/xfs/825     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/825.out |    2 ++
 8 files changed, 166 insertions(+)
 create mode 100755 tests/xfs/733
 create mode 100644 tests/xfs/733.out
 create mode 100755 tests/xfs/771
 create mode 100644 tests/xfs/771.out
 create mode 100755 tests/xfs/824
 create mode 100644 tests/xfs/824.out
 create mode 100755 tests/xfs/825
 create mode 100644 tests/xfs/825.out


diff --git a/tests/xfs/733 b/tests/xfs/733
new file mode 100755
index 0000000000..ee9a0a26ee
--- /dev/null
+++ b/tests/xfs/733
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 733
+#
+# Race xfs_scrub in check-only mode and ro remount for a while to see if we
+# crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	_scratch_remount rw
+	rm -rf $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -r 5 -S '-n'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/733.out b/tests/xfs/733.out
new file mode 100644
index 0000000000..7118d5ddf0
--- /dev/null
+++ b/tests/xfs/733.out
@@ -0,0 +1,2 @@
+QA output created by 733
+Silence is golden
diff --git a/tests/xfs/771 b/tests/xfs/771
new file mode 100755
index 0000000000..8c8d124f12
--- /dev/null
+++ b/tests/xfs/771
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 771
+#
+# Race xfs_scrub in check-only mode and freeze for a while to see if we crash
+# or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	_scratch_remount rw
+	rm -rf $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -f -S '-n'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/771.out b/tests/xfs/771.out
new file mode 100644
index 0000000000..c2345c7be3
--- /dev/null
+++ b/tests/xfs/771.out
@@ -0,0 +1,2 @@
+QA output created by 771
+Silence is golden
diff --git a/tests/xfs/824 b/tests/xfs/824
new file mode 100755
index 0000000000..65eeb3a6c9
--- /dev/null
+++ b/tests/xfs/824
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 824
+#
+# Race xfs_scrub in force-repair mdoe and freeze for a while to see if we crash
+# or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	_scratch_remount rw
+	rm -rf $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/xfs
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -f -S '-k'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/824.out b/tests/xfs/824.out
new file mode 100644
index 0000000000..6cf432abbd
--- /dev/null
+++ b/tests/xfs/824.out
@@ -0,0 +1,2 @@
+QA output created by 824
+Silence is golden
diff --git a/tests/xfs/825 b/tests/xfs/825
new file mode 100755
index 0000000000..80ce06932d
--- /dev/null
+++ b/tests/xfs/825
@@ -0,0 +1,40 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 825
+#
+# Race xfs_scrub in force-repair mode and ro remount for a while to see if we
+# crash or livelock.
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	_scratch_remount rw
+	rm -rf $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/xfs
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_online_repair -r 5 -S '-k'
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/xfs/825.out b/tests/xfs/825.out
new file mode 100644
index 0000000000..d0e970dfd6
--- /dev/null
+++ b/tests/xfs/825.out
@@ -0,0 +1,2 @@
+QA output created by 825
+Silence is golden

