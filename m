Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF49C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiLaAmF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:42:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B1C1D0C8;
        Fri, 30 Dec 2022 16:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D45A61D2E;
        Sat, 31 Dec 2022 00:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C74C433D2;
        Sat, 31 Dec 2022 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447323;
        bh=EmJFQ1pIFYqKMImC+T+GP+rzsEqbIs+a9RBIy0lpza4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kz3Qq0yBs2tEcRHKbTJOOd1K0tM0sPqQIk+kpRBXPx9sYWHecKbbCDIJup/jSA1EP
         DctNQnPRAcrGQ/3Bc/JzlKgHxZXq0TYjfCwaVtjk2SNzmm1/us4ifwclVZF8gBPhxR
         NhiZAXx6Q3LXGUZtgah6/gsw8/ydM6dxvE1ZkGp1aly9Nd0pnccyaaxFimLzVM11zE
         2KH/UZurNYp8BP4T7JKG8r2D1udVpc8kEX7UPMf6L3CAFHQ8z4oWuBe/vRFDG9Zs6r
         MbJ3ylLakryJVBraVB6IfJrC8MAOZwaZVl020Pld+G/ZI7yXRWogNQ2xZ5E/lL+SqD
         nxvp5m303hkjA==
Subject: [PATCH 4/4] xfs: race fsstress with online repair for special file
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:18 -0800
Message-ID: <167243875889.725760.16841240655943822802.stgit@magnolia>
In-Reply-To: <167243875835.725760.8458608166534095780.stgit@magnolia>
References: <167243875835.725760.8458608166534095780.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For each XFS_SCRUB_TYPE_* that looks at symbolic link and special file
metadata, create a test that runs that repairer in the foreground and
fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/828     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/828.out |    2 ++
 tests/xfs/829     |   39 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/829.out |    2 ++
 4 files changed, 81 insertions(+)
 create mode 100755 tests/xfs/828
 create mode 100644 tests/xfs/828.out
 create mode 100755 tests/xfs/829
 create mode 100644 tests/xfs/829.out


diff --git a/tests/xfs/828 b/tests/xfs/828
new file mode 100755
index 0000000000..99020e9b3c
--- /dev/null
+++ b/tests/xfs/828
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 828
+#
+# Race fsstress and symlink repair for a while to see if we crash or livelock.
+# We can't open special files directly for scrubbing, so we use xfs_scrub(8).
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+XFS_SCRUB_PHASE=3 _scratch_xfs_stress_online_repair -x 'symlink' -S '-k'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/828.out b/tests/xfs/828.out
new file mode 100644
index 0000000000..d0291290a9
--- /dev/null
+++ b/tests/xfs/828.out
@@ -0,0 +1,2 @@
+QA output created by 828
+Silence is golden
diff --git a/tests/xfs/829 b/tests/xfs/829
new file mode 100755
index 0000000000..7451f66069
--- /dev/null
+++ b/tests/xfs/829
@@ -0,0 +1,39 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 827
+#
+# Race fsstress and special file repair for a while to see if we crash or
+# livelock.  We can't open special files directly for scrubbing, so we use
+# xfs_scrub(8).
+#
+. ./common/preamble
+_begin_fstest online_repair dangerous_fsstress_repair
+
+_cleanup() {
+	_scratch_xfs_stress_scrub_cleanup &> /dev/null
+	cd /
+	rm -r -f $tmp.*
+}
+_register_cleanup "_cleanup" BUS
+
+# Import common functions.
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_stress_online_repair
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+XFS_SCRUB_PHASE=3 _scratch_xfs_stress_online_repair -x 'mknod' -S '-k'
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/829.out b/tests/xfs/829.out
new file mode 100644
index 0000000000..8a43a15204
--- /dev/null
+++ b/tests/xfs/829.out
@@ -0,0 +1,2 @@
+QA output created by 829
+Silence is golden

