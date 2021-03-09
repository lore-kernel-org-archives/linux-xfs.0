Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F70C4332D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B291652A4
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCIEkm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhCIEk0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C24AD65275;
        Tue,  9 Mar 2021 04:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264825;
        bh=z8gtE7eBiVPyS4gAqaZDmLXXstaBQIF2xzfaaY1mtp4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=glibU5M9vKw/TrWhPutRohiLu5GZUaiSkUtL3j9QxLEPWWcI8gxRO2InI+31aHwdk
         T74gm4yvbg6ipw3iF+UyGT0XmgiNr3jj+ra21BytluNxFIkLKJ9C+QYBRDdZgL7N41
         +pvXnJ3G8why0ZJaqAsCkvrpUObPmhQM5OpZTkWh6siTBWDd1XYvZw1IxFCwHixSUG
         WaZBKdqBE5TgEXOXrnWURPIPNM0kICcVc0ZXrnRSYO2WyQSSaTCHjGE6OFM7ONNVCG
         1NPYhktiphH9HhNHSX0PudGFhXlPEG+NqSw/g2dsZtGGcTA+F3S8+LO07WXyJCYFRC
         9EvbK9yoQ20EQ==
Subject: [PATCH 04/10] xfs: test mkfs min log size calculation w/ rt volumes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:25 -0800
Message-ID: <161526482563.1214319.7317631500409765514.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In "mkfs: set required parts of the realtime geometry before computing
log geometry" we made sure that mkfs set up enough of the fs geometry to
compute the minimum xfs log size correctly when formatting the
filesystem.  This is the regression test for that issue.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/761     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/761.out |    1 +
 tests/xfs/group   |    1 +
 3 files changed, 47 insertions(+)
 create mode 100755 tests/xfs/761
 create mode 100644 tests/xfs/761.out


diff --git a/tests/xfs/761 b/tests/xfs/761
new file mode 100755
index 00000000..b9770d90
--- /dev/null
+++ b/tests/xfs/761
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 761
+#
+# Make sure mkfs sets up enough of the rt geometry that we can compute the
+# correct min log size for formatting the fs.
+#
+# This is a regression test for the xfsprogs commit 31409f48 ("mkfs: set
+# required parts of the realtime geometry before computing log geometry").
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+
+rm -f $seqres.full
+
+# Format a tiny filesystem to force minimum log size, then see if it mounts
+_scratch_mkfs -r size=1m -d size=100m > $seqres.full
+_scratch_mount >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/761.out b/tests/xfs/761.out
new file mode 100644
index 00000000..8c9d9e90
--- /dev/null
+++ b/tests/xfs/761.out
@@ -0,0 +1 @@
+QA output created by 761
diff --git a/tests/xfs/group b/tests/xfs/group
index 318468b5..87badd56 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -503,4 +503,5 @@
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
+761 auto quick realtime
 763 auto quick rw realtime

