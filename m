Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C413C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 19:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiEXTyf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 15:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241149AbiEXTya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 15:54:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC1C79818;
        Tue, 24 May 2022 12:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1A8615FE;
        Tue, 24 May 2022 19:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E76C34100;
        Tue, 24 May 2022 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653422057;
        bh=O/559p5DHUq+MJ5MdcCVOnxnWIuT1w4PX0G5kdDGKd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cNSURPKBkQIsGm452iZQQit7Cr/qmb3+Ddlla1NCydC3B0sOBvVoouPWUXbl+TS6b
         22QuLCfcYR17c6y6EPIUaIDG4d7eAy5n4Ub06ne88AdejJguZjvKU7J8DLOMdxVppA
         BaUbrcDrgLEpSG/MCak6t6hvEfxBKYfydbmajqHHCz2tgTPw5yGP5RUtxJpOIAJR3V
         SsnfBs9DPD6roiA4oyjyFnm6Hi+ivUTf7+CBLRmUtXvJxJe6Q67mKjwXWAW3XCusvO
         YVmhqS0T8yGx5Zn1Te2c+GrkwCp3g0sYo1taCuGOK22Bzly72Rq9VUJOYivHRWX7pI
         Wb+OF2jXRmgQw==
Date:   Tue, 24 May 2022 12:54:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>, Zorro Lang <zlang@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCH] xfs: test xfs_copy doesn't do cached read before libxfs_mount
Message-ID: <Yo036Y+er/WaT2IH@magnolia>
References: <Yo027/k+vAYsUt4U@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo027/k+vAYsUt4U@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for an xfs_copy fix that ensures that it
doesn't perform a cached read of an XFS filesystem prior to initializing
libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
yet.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/844     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/844.out |    3 +++
 3 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/844
 create mode 100644 tests/xfs/844.out

diff --git a/tests/xfs/844 b/tests/xfs/844
new file mode 100755
index 00000000..720f45bb
--- /dev/null
+++ b/tests/xfs/844
@@ -0,0 +1,37 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 844
+#
+# Regression test for xfsprogs commit:
+#
+# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")
+#
+. ./common/preamble
+_begin_fstest auto copy
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $TEST_DIR/$seq.*
+}
+
+# Import common functions.
+# . ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_copy
+_require_test
+
+truncate -s 100m $TEST_DIR/$seq.a
+truncate -s 100m $TEST_DIR/$seq.b
+
+$XFS_COPY_PROG $TEST_DIR/$seq.a $TEST_DIR/$seq.b
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/844.out b/tests/xfs/844.out
new file mode 100644
index 00000000..dbefde1c
--- /dev/null
+++ b/tests/xfs/844.out
@@ -0,0 +1,3 @@
+QA output created by 844
+bad magic number
+xfs_copy: couldn't read superblock, error=22
