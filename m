Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0E0C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 05:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2918421D7D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 05:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t7V+c0tL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgIPFee (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 01:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPFec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 01:34:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EE3C06174A;
        Tue, 15 Sep 2020 22:34:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k14so3241394pgi.9;
        Tue, 15 Sep 2020 22:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6RsnjIO1DITRqua+x80n86fE2hzcHz/fptYOyPQKYpA=;
        b=t7V+c0tLnXs1Frm6fxwhzAXtQf8ZempT5ILAAOPyJWfnOlzUIn8vHX58Ao04ZB5zF0
         Xdm9fYW209BJ0Kxc7PQF8ku0UqaHZlq2E8LexaUaufAo595tqxYelzPPV8AVv9BWhr30
         b3SiSAdWyZd1MZHhCsTP8LnkR1hNlVfRjOAqpJ2IA41s7DKna4Hefx1d/8YAhbtObe1E
         DCTlxZgpUHworAMmFZllr+eIeJ0OnkdaoZG3is/lxrMxuRrGE+BqBOjOfNfXYv66VcGV
         xp0i4z01JOS+S3qT7pTulsFdwEXRAzFh22t/zMr9ja65RYgJE07VXEaynfj/VHt6k2PR
         d8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RsnjIO1DITRqua+x80n86fE2hzcHz/fptYOyPQKYpA=;
        b=epVY+kQ3zM/xiDFzLWMythObgcPN/vesVkcQ699UrXbj+GNzBCvd9Da7aGUwpgwNmX
         M2eAp5Jbo53v9ZAUl2LZT+NQM8cUiIQptY29wPYDfQiB9v76I8mdBPvjvna69RpW6RX1
         mGbGAat0px1J7cJn/Z4O3xsGGsaFb6D0/V5t7BLDBEygS7zyseCEZGgZ1xFcChFpjnEd
         Hwh66CYTVqWuaXj4o6NZ3lOOdaL8Rao53XmS2oOcYebEsczpscMXyB2cb0EuZBtFoaWP
         kuZf8su38o4kY7hS1TWmZYLqsVfbOxV1xSexmr7pvwLJa2zQdgOxBqaex0xG/wHuMRYc
         EzGQ==
X-Gm-Message-State: AOAM531quuwikS/iPws5jgaKvi4X8RQGLB46Y01//hh2mPK+5a14W8r3
        7GyDpl1Z9QvtAfSFt4bvnY1eeuNCNX0=
X-Google-Smtp-Source: ABdhPJxiHb6wsS8EPau45GZ+ZNbDXTNKylw3eFro75e/XbMB2vup3Ci8peY1qnpQaF+HDAQ1izI5GQ==
X-Received: by 2002:a63:1f0f:: with SMTP id f15mr498770pgf.312.1600234471469;
        Tue, 15 Sep 2020 22:34:31 -0700 (PDT)
Received: from localhost.localdomain ([171.48.17.146])
        by smtp.gmail.com with ESMTPSA id m25sm14901701pfa.32.2020.09.15.22.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 22:34:30 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH V2 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Wed, 16 Sep 2020 11:04:07 +0530
Message-Id: <20200916053407.2036-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916053407.2036-1-chandanrlinux@gmail.com>
References: <20200916053407.2036-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds a test to check if growing a real-time device can end
up logging an xfs_buf with the "type" subfield of
bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
occurs the following call trace is printed on the console,

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
Call Trace:
 xfs_buf_item_format+0x632/0x680
 ? kmem_alloc_large+0x29/0x90
 ? kmem_alloc+0x70/0x120
 ? xfs_log_commit_cil+0x132/0x940
 xfs_log_commit_cil+0x26f/0x940
 ? xfs_buf_item_init+0x1ad/0x240
 ? xfs_growfs_rt_alloc+0x1fc/0x280
 __xfs_trans_commit+0xac/0x370
 xfs_growfs_rt_alloc+0x1fc/0x280
 xfs_growfs_rt+0x1a0/0x5e0
 xfs_file_ioctl+0x3fd/0xc70
 ? selinux_file_ioctl+0x174/0x220
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x3e/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
files" is required to fix this issue.

Reviewed-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/260     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/260.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 56 insertions(+)
 create mode 100755 tests/xfs/260
 create mode 100644 tests/xfs/260.out

diff --git a/tests/xfs/260 b/tests/xfs/260
new file mode 100755
index 00000000..078d4a11
--- /dev/null
+++ b/tests/xfs/260
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 260
+#
+# Test to check if growing a real-time device can end up logging an xfs_buf with
+# the "type" subfield of bip->bli_formats->blf_flags set to
+# XFS_BLFT_UNKNOWN_BUF.
+#
+# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
+# when growing summary/bitmap files".
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_realtime
+
+_scratch_mkfs -r size=10M  >> $seqres.full
+
+_scratch_mount >> $seqres.full
+
+$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
+
+_scratch_unmount
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/260.out b/tests/xfs/260.out
new file mode 100644
index 00000000..18ca517c
--- /dev/null
+++ b/tests/xfs/260.out
@@ -0,0 +1,2 @@
+QA output created by 260
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 3bb0f674..a3f5c81a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -257,6 +257,7 @@
 257 auto quick clone
 258 auto quick clone
 259 auto quick
+260 auto quick growfs realtime
 261 auto quick quota
 262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 263 auto quick quota
-- 
2.28.0

