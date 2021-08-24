Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4280C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 00:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C367A61284
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 00:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhHXAjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 20:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhHXAjS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 20:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7054A613A7
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629765515;
        bh=pe+emmB8fZNdbnnyGKTE/kZbGr9qZ6tjc48qGXxK93A=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=m5k8TidZkabr27S/OSVxPCVpVZdzgSuVFWQrxC+LoiD7rc//XeHlixZ1YnVDynXTY
         SnKTQVl1AepW+928sfn/oB+T5ZzCqMmNICaCUx7FeBXvt8+ERGqJGATYamF1H6j4Dd
         BbdXsXOYZXRNzpPcQ8/rJt7NOWRdVsChnBSpD2XkCYOqRbOgZ6ERBIf5Z+2ShECS0V
         4v162Xj3Pv0EpagVufzTV5/2WhhIgl+Mj2mbCQI9iuE2eG8C1f4N1eIEE9ruuPv4Wh
         RMCBUe7qesh+doxwrfr2ZwX8Wdb+sHWqaxFmcklCYpWkzJrnQAy/tj8Tutp8QekDGp
         x/SRkA2VfS89g==
Date:   Mon, 23 Aug 2021 17:38:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [RFC PATCH] generic: regression test for a FALLOC_FL_UNSHARE bug in
 XFS
Message-ID: <20210824003835.GD12640@magnolia>
References: <20210824003739.GC12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824003739.GC12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for "xfs: only set IOMAP_F_SHARED when
providing a srcmap to a write".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/729     |   73 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/729.out |    2 +
 2 files changed, 75 insertions(+)
 create mode 100755 tests/generic/729
 create mode 100644 tests/generic/729.out

diff --git a/tests/generic/729 b/tests/generic/729
new file mode 100755
index 00000000..269aed65
--- /dev/null
+++ b/tests/generic/729
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 729
+#
+# This is a regression test for "xfs: only set IOMAP_F_SHARED when providing a
+# srcmap to a write".  If a user creates a sparse shared region in a file,
+# convinces XFS to create a copy-on-write delayed allocation reservation
+# spanning both the shared blocks and the holes, and then calls the fallocate
+# unshare command to unshare the entire sparse region, XFS incorrectly tells
+# iomap that the delalloc blocks for the holes are shared, which causes it to
+# error out while trying to unshare a hole.
+#
+. ./common/preamble
+_begin_fstest auto clone unshare
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $TEST_DIR/$seq
+}
+
+# Import common functions.
+. ./common/reflink
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_cp_reflink
+_require_test_reflink
+_require_test_program "punch-alternating"
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "funshare"
+
+mkdir $TEST_DIR/$seq
+file1=$TEST_DIR/$seq/a
+file2=$TEST_DIR/$seq/b
+
+$XFS_IO_PROG -f -c "pwrite -S 0x58 -b 10m 0 10m" $file1 >> $seqres.full
+
+f1sum0="$(md5sum $file1 | _filter_test_dir)"
+
+_cp_reflink $file1 $file2
+$here/src/punch-alternating -o 1 $file2
+
+f2sum0="$(md5sum $file2 | _filter_test_dir)"
+
+# set cowextsize to the defaults (128k) to force delalloc cow preallocations
+test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'cowextsize 0' $file2
+$XFS_IO_PROG -c "funshare 0 10m" $file2
+
+f1sum1="$(md5sum $file1 | _filter_test_dir)"
+f2sum1="$(md5sum $file2 | _filter_test_dir)"
+
+test "${f1sum0}" = "${f1sum1}" || echo "file1 should not have changed"
+test "${f2sum0}" = "${f2sum1}" || echo "file2 should not have changed"
+
+_test_cycle_mount
+
+f1sum2="$(md5sum $file1 | _filter_test_dir)"
+f2sum2="$(md5sum $file2 | _filter_test_dir)"
+
+test "${f1sum2}" = "${f1sum1}" || echo "file1 should not have changed ondisk"
+test "${f2sum2}" = "${f2sum1}" || echo "file2 should not have changed ondisk"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/729.out b/tests/generic/729.out
new file mode 100644
index 00000000..0f175ae2
--- /dev/null
+++ b/tests/generic/729.out
@@ -0,0 +1,2 @@
+QA output created by 729
+Silence is golden
