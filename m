Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871B9C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiLaAyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:54:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37A113F29;
        Fri, 30 Dec 2022 16:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E7D261D56;
        Sat, 31 Dec 2022 00:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99825C433D2;
        Sat, 31 Dec 2022 00:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448070;
        bh=NytJ0nHrGVdseOG2iZiChh6vJOaEdaomuzyXtnhXkXk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f9Xqxyastq2eBzQyJwAXkjc73TnqKNip5QdChiHOq/wi6/vEowgiLTR16KJG+F/Md
         Jj8ofK368pxlMj9y2s8fqW+lND1hy12NVRyiuJDKeDT3g88PJORmUCBBCEaDNTR3Ny
         WYXbWYgaBMVfvbryHjdagl1P9QJYptWEYqVZpSaE/NJ43irAOcsXm7DN/577mc2snE
         E00epb1meNm7c6eQrOFS4M1fXGu30CFSlJVxofAsx/ekUAywZt75J/unNmE3ficqDF
         cWrR9CwBSfRlD3/3QffkXFB1UOI71f4JXBg+duPsa4yidp8CkXXjPNwn6AFaduJuph
         ue47voZj8PLag==
Subject: [PATCH 2/2] xfs: race fsstress with online repair of dirs and parent
 pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879806.733381.14328701846747487244.stgit@magnolia>
In-Reply-To: <167243879781.733381.1441585366549762189.stgit@magnolia>
References: <167243879781.733381.1441585366549762189.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create tests to race fsstress with directories and directory parent
pointer repair while running fsstress in the background.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/815     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/815.out |    2 ++
 tests/xfs/816     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/816.out |    2 ++
 4 files changed, 79 insertions(+)
 create mode 100755 tests/xfs/815
 create mode 100644 tests/xfs/815.out
 create mode 100755 tests/xfs/816
 create mode 100644 tests/xfs/816.out


diff --git a/tests/xfs/815 b/tests/xfs/815
new file mode 100755
index 0000000000..745afec792
--- /dev/null
+++ b/tests/xfs/815
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 815
+#
+# Race fsstress and directory repair for a while to see if we crash or livelock.
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
+_scratch_xfs_stress_online_repair -x 'dir' -s "repair directory" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/815.out b/tests/xfs/815.out
new file mode 100644
index 0000000000..6ea462f3f7
--- /dev/null
+++ b/tests/xfs/815.out
@@ -0,0 +1,2 @@
+QA output created by 815
+Silence is golden
diff --git a/tests/xfs/816 b/tests/xfs/816
new file mode 100755
index 0000000000..25a79005f8
--- /dev/null
+++ b/tests/xfs/816
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+#
+# FS QA Test No. 816
+#
+# Race fsstress and parent pointers repair for a while to see if we crash or
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
+_scratch_xfs_stress_online_repair -s "repair parent" -t "%dir%"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/816.out b/tests/xfs/816.out
new file mode 100644
index 0000000000..a9d8f943c8
--- /dev/null
+++ b/tests/xfs/816.out
@@ -0,0 +1,2 @@
+QA output created by 816
+Silence is golden

