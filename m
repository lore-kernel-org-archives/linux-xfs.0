Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F70AC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiLaAmw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235615AbiLaAmv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:42:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212F31EAC0;
        Fri, 30 Dec 2022 16:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4DBF61D53;
        Sat, 31 Dec 2022 00:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E26AC433EF;
        Sat, 31 Dec 2022 00:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447370;
        bh=bUI4TaqofIbVCPr63nQL7L4euqFNXDQIfUppY5kN638=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m/ygupahqLLvtpguM/Niqfhzf2URk5asLr4zMm4beyJQ91t6bo70O61o1FJGR6Gvw
         lWVGVaEM9IwuutG6MIvnZkzhR6pExRn2xipO2mFwxSFLSYPdyPaoxnw4OIsxftQVao
         LE3Fq4BgWklGi7UbL4BbkQZcvNpnUY0v7EDPdXOIJpPLgNxTCdehFxsShqwyyh7jTX
         vO9eQSwkowcVWzrweaRccdQu1urZnxVjwzqeIV87qmDQUqIEQlpYAXdIyOQ9AVbiPo
         imR888h3R51MdAxSW3kLaGzRzjvXAi9YuAyCqy41Llclx3yN5hdsCWffahom6RVTen
         0E6hqVP+XEWLQ==
Subject: [PATCH 1/1] xfs: race fsstress with inode link count check and repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:27 -0800
Message-ID: <167243876766.727436.7268075677833351349.stgit@magnolia>
In-Reply-To: <167243876754.727436.356658000575058711.stgit@magnolia>
References: <167243876754.727436.356658000575058711.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Race fsstress with inode link count checking and repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/772     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/772.out |    2 ++
 tests/xfs/820     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/820.out |    2 ++
 4 files changed, 79 insertions(+)
 create mode 100755 tests/xfs/772
 create mode 100644 tests/xfs/772.out
 create mode 100755 tests/xfs/820
 create mode 100644 tests/xfs/820.out


diff --git a/tests/xfs/772 b/tests/xfs/772
new file mode 100755
index 0000000000..a00c2796c5
--- /dev/null
+++ b/tests/xfs/772
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 772
+#
+# Race fsstress and inode link count repair for a while to see if we crash or
+# livelock.
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
+_scratch_xfs_stress_online_repair -x "dir" -s "repair nlinks"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/772.out b/tests/xfs/772.out
new file mode 100644
index 0000000000..98c1396896
--- /dev/null
+++ b/tests/xfs/772.out
@@ -0,0 +1,2 @@
+QA output created by 772
+Silence is golden
diff --git a/tests/xfs/820 b/tests/xfs/820
new file mode 100755
index 0000000000..58a5d4cc91
--- /dev/null
+++ b/tests/xfs/820
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 820
+#
+# Race fsstress and nlinks scrub for a while to see if we crash or livelock.
+#
+. ./common/preamble
+_begin_fstest scrub dangerous_fsstress_scrub
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
+_require_xfs_stress_scrub
+
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_scratch_xfs_stress_scrub -x "dir" -s "scrub nlinks"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/820.out b/tests/xfs/820.out
new file mode 100644
index 0000000000..29ab2e2d8c
--- /dev/null
+++ b/tests/xfs/820.out
@@ -0,0 +1,2 @@
+QA output created by 820
+Silence is golden

