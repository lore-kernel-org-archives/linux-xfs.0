Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDF8EE49AF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 01:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjHWBCn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjHWBCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 21:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B547CE3;
        Tue, 22 Aug 2023 18:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 224D2637EE;
        Wed, 23 Aug 2023 01:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407CDC433C7;
        Wed, 23 Aug 2023 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692752560;
        bh=X1BqXgk/85nh41rk1F7NSPk/gvQcErrWY5hpjw/OrIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4OhOoDnGGBOYNa8m01ejg1+Iob5+Pzp132WnIABqtcCpfGO5xRla3u5WndFVLlbr
         KiwUaCj+YfM0yAVtoRBFhRl91XO0NMikhc0iyOUExb0zRb+cJu9orPpoZ7ugUDE/u4
         D/mqXWpGAcD8lQZ+2A2FBej49fCU8EfeU5HRudCKZNCXBgvzLE0m//LQuccfDdBUMT
         v7cbxrPq9Rn2quc9S3ZI2RbIeoC4gwHrMI03BdQ0L7d2g6rku7LiYbchBk4XnoEbVK
         J6uvSPvkM9DUZis0kMdkV3jJm/hvArddVNX9R8/nUVlhkRj2M3bT8YFWD3Cpvbqxf/
         H35PGmbDuUJNQ==
Date:   Tue, 22 Aug 2023 18:02:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <20230823010239.GE11263@frogsfrogsfrogs>
References: <20230823010046.GD11286@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823010046.GD11286@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner reported that xfs/273 fails if the AG size happens to be an
exact power of two.  I traced this to an agbno integer overflow when the
current GETFSMAP call is a continuation of a previous GETFSMAP call, and
the last record returned was non-shareable space at the end of an AG.

This is the regression test for that bug.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/935.out |    2 ++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/xfs/935
 create mode 100644 tests/xfs/935.out

diff --git a/tests/xfs/935 b/tests/xfs/935
new file mode 100755
index 0000000000..a06f2fc8dc
--- /dev/null
+++ b/tests/xfs/935
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 935
+#
+# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
+# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
+# a continuation of a previous call by setting the "low" key to the last record
+# returned by the previous call.
+#
+# If the last record returned by GETFSMAP is a non-shareable extent at the end
+# of an AG and the AG size is exactly a power of two, the startblock in the low
+# key of the rmapbt query can be set to a value larger than EOAG.  When this
+# happens, GETFSMAP will return EINVAL instead of returning records for the
+# next AG.
+#
+. ./common/preamble
+_begin_fstest auto quick fsmap
+
+. ./common/filter
+
+_fixed_by_git_commit kernel XXXXXXXXXXXXX \
+	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command fsmap
+_require_xfs_scratch_rmapbt
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+source $tmp.mkfs
+
+# Find the next power of two agsize smaller than whatever the default is.
+for ((p = 31; p > 0; p--)); do
+	desired_agsize=$((2 ** p))
+	test "$desired_agsize" -lt "$agsize" && break
+done
+
+echo "desired asize=$desired_agsize" >> $seqres.full
+_scratch_mkfs -d "agsize=${desired_agsize}b" | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+source $tmp.mkfs
+
+test "$desired_agsize" -eq "$agsize" || _notrun "wanted agsize=$desired_agsize, got $agsize"
+
+_scratch_mount
+$XFS_IO_PROG -c 'fsmap -n 1024 -v' $SCRATCH_MNT >> $tmp.big
+$XFS_IO_PROG -c 'fsmap -n 1 -v' $SCRATCH_MNT >> $tmp.small
+
+diff -Naurpw $tmp.big $tmp.small
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/935.out b/tests/xfs/935.out
new file mode 100644
index 0000000000..1b5422d1e3
--- /dev/null
+++ b/tests/xfs/935.out
@@ -0,0 +1,2 @@
+QA output created by 935
+Silence is golden
