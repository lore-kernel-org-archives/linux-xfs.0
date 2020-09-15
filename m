Return-Path: <SRS0=4rV+=CY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4FBC43461
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 05:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1EB220829
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Sep 2020 05:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uTmk/uu2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgIOFsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Sep 2020 01:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgIOFsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 01:48:07 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C73C06174A;
        Mon, 14 Sep 2020 22:48:06 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id e4so754803pln.10;
        Mon, 14 Sep 2020 22:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=meDAlnYmnC8sGAWwJbXUjKBczOiTomzV5geEDze9mh0=;
        b=uTmk/uu2Vg7Zj+pMBDt0+ga6Udb0COyKG1Z6FpwmqlUUo4vBIgJ1m1f4xIi6UHoDU5
         G2M1O2NhL/mmLGCXidZKrbmx8LrdkrQPmtiIDfg3K6nfHmNM+oKQLMbhn2khnbhx1D5a
         SKTqhY/JVkdJYqs3Ar4gbWc+mz+AIIXrxhnVjjsRwQWsb9bzp4YXnDWPgEVK0npdSiXm
         zX82I8sSxiHnKQafIKOKWlJSrhhLjDuon47WPMgd3KtHhDRzSmew1AW8o9d1gA2KAscA
         kVUSo2Lt/D1B55PJZa2gAZL5iZmG5kd0wLg81DnoPFGwy8ePbyjIuSCdaM/CJmVxWRwC
         s0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=meDAlnYmnC8sGAWwJbXUjKBczOiTomzV5geEDze9mh0=;
        b=brJmyjwKEnA+2gi0TRS8K5KBG8fbCyGalA12ck2qK0Vda6yrzEPNuy7/ekricZUUgL
         u55DBmlTEBHfUzpp3tX16CYzt6kdYTZAUeRDXYD0JgQp4VfZzVMVhi+L2l2SiqtVd/Yc
         D3L/AuEGXL7rfYY/BTlAB4DzUhIjY6mXdMziGLzO6RSN/GQeYosQWV+5SxFggV9oTyUx
         bssaavsDAllYyP86GxXNAAZHJIs767dT2aQL8CTphdDTXMntxTJ0H04iHlOfM9WFzBqQ
         FCDwqrxNFkZlr3K6w9jxgyLMwPqqGEIFs/DIpENSyzoBU4Q3vSEPIgqPFvtq3nEKr3/9
         /85Q==
X-Gm-Message-State: AOAM532+pUydVTYZc40RsfRQbGC7pHTULw4JeiX+/bxl7oNPJbs9NeW8
        QdSf6GQdi3jL3oHGPB+kSx3yrsPel6s=
X-Google-Smtp-Source: ABdhPJynXWr2H/3bjaEFwZYTfDKzl2CnK2iNMxriZ4unlDaLctEDMV0evwZ6oujyOTD4SAtXil8+Ww==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr2609557pjb.7.1600148885750;
        Mon, 14 Sep 2020 22:48:05 -0700 (PDT)
Received: from localhost.localdomain ([122.179.36.63])
        by smtp.gmail.com with ESMTPSA id y13sm12119356pfr.141.2020.09.14.22.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 22:48:05 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Tue, 15 Sep 2020 11:17:48 +0530
Message-Id: <20200915054748.1765-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
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
index ed0d389e..68676064 100644
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

