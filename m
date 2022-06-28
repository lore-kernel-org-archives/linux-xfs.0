Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D93CCA47F
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiF1UZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiF1UYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307D81C4;
        Tue, 28 Jun 2022 13:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C579BB81BED;
        Tue, 28 Jun 2022 20:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB87C3411D;
        Tue, 28 Jun 2022 20:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447700;
        bh=tiPDfwHrOYk4kde7l9WtFOYFYC8Zo9Mdy1epE/sOEUc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e1/8FCUUD7371eYpDKovKZmSUIe0jfriyt9AaUqgul0xefictsYVyTu2PLgJbwUXw
         ZwkPf8FMksSq3SjBHiag70Jj570yOuNO81qesmZTbLX+ZzgREj6y3YKWh+w7afPbx4
         UkQgTDo7No+mRxDjYaiDIxkEhAmoxbFrtpWCD3DzFrrBD7TWcvtQ6blbFMAY/RfS5N
         43tHm3Iaq1XuvGtrTfiGcpUkMaPEKcEH/bhvfDRbstYrBjmp9AZj0W+vI8qhh/AFve
         e9QJoymp4c2BD+Biu90QOyTY7sZb/XSVKXe6P/tEuE9bQGWS7Kfu+tIvgjQ2oyKpOi
         FuI9jpY2EeSIQ==
Subject: [PATCH 4/9] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:40 -0700
Message-ID: <165644770013.1045534.5572366430392518217.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
 tests/xfs/844     |   33 +++++++++++++++++++++++++++++++++
 tests/xfs/844.out |    3 +++
 2 files changed, 36 insertions(+)
 create mode 100755 tests/xfs/844
 create mode 100644 tests/xfs/844.out


diff --git a/tests/xfs/844 b/tests/xfs/844
new file mode 100755
index 00000000..688abe33
--- /dev/null
+++ b/tests/xfs/844
@@ -0,0 +1,33 @@
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_copy
+_require_test
+
+rm -f $TEST_DIR/$seq.*
+$XFS_IO_PROG -f -c 'truncate 100m' $TEST_DIR/$seq.a
+$XFS_IO_PROG -f -c 'truncate 100m' $TEST_DIR/$seq.b
+
+filter_copy() {
+	sed -e 's/Superblock has bad magic number.*/bad magic number/'
+}
+
+$XFS_COPY_PROG $TEST_DIR/$seq.a $TEST_DIR/$seq.b 2>&1 | filter_copy
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

