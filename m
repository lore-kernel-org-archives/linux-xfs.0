Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528A9C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbiLaAnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiLaAnI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:43:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4DC1EACB;
        Fri, 30 Dec 2022 16:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 487AE61D56;
        Sat, 31 Dec 2022 00:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C0DC433D2;
        Sat, 31 Dec 2022 00:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447385;
        bh=f+e4SZBnAc3H//6VWuMHLcELgswxyDtbbfHj5u7UoHI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b+F1amvJxBxfSri4FMpXPfMU9/rz8FwvBuhM5Upfjc3tsSNcYNJ3wVXBowxv2u6xC
         7bkjebV0AJkly57jWWvJHtKQyjop27YWJr+IE3h5j42K48jbWzcHzkDq1cq88ODn7w
         flgzvWtMiJpZ9YKr6MOFutIaHCAP46F2GojDvXAuaovIBciF54knUzLhaKPSaUFuBq
         qHBiJaJNqTpFH5mH5d0Mx0ODFZUYomePBAm6mj8vrfhPIF+JOZItsWBIqU2QB2UHOF
         MMPhsWMVA3wSqUf8A3n8DlMA92PYKaCM48jEEnDBoAIrvHO0jiRVK1ECr6JP/l8oqC
         oay93ztFSbEhg==
Subject: [PATCH 1/2] xfs: test fs summary counter online repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877052.727863.4657438078725247106.stgit@magnolia>
In-Reply-To: <167243877039.727863.13765266441029212988.stgit@magnolia>
References: <167243877039.727863.13765266441029212988.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fuzz the fs summary counters in the primary super and see if online
repair can fix them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/713     |   36 ++++++++++++++++++++++++++++++++++++
 tests/xfs/713.out |    4 ++++
 2 files changed, 40 insertions(+)
 create mode 100755 tests/xfs/713
 create mode 100644 tests/xfs/713.out


diff --git a/tests/xfs/713 b/tests/xfs/713
new file mode 100755
index 0000000000..7ac6d1458f
--- /dev/null
+++ b/tests/xfs/713
@@ -0,0 +1,36 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 713
+#
+# Populate a XFS filesystem and fuzz every fscounter field.
+# Use xfs_scrub to fix the corruption.
+#
+. ./common/preamble
+_begin_fstest dangerous_fuzzers dangerous_scrub dangerous_online_repair
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
+_require_scratch_xfs_fuzz_fields
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Fuzz fscounters"
+test -z "$SCRATCH_XFS_LIST_METADATA_FIELDS" &&
+	SCRATCH_XFS_LIST_METADATA_FIELDS='icount,ifree,fdblocks'
+export SCRATCH_XFS_LIST_METADATA_FIELDS
+_scratch_xfs_fuzz_metadata '' 'online' 'sb 0' >> $seqres.full
+echo "Done fuzzing fscounters"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/713.out b/tests/xfs/713.out
new file mode 100644
index 0000000000..6dd322f4ca
--- /dev/null
+++ b/tests/xfs/713.out
@@ -0,0 +1,4 @@
+QA output created by 713
+Format and populate
+Fuzz fscounters
+Done fuzzing fscounters

