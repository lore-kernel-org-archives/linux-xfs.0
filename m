Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE29C35267
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EE9208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKZWVy8x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgIQE3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQE3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:29:04 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92B0C06174A;
        Wed, 16 Sep 2020 21:29:03 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k15so394709pfc.12;
        Wed, 16 Sep 2020 21:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jD8gSJmistFf9e3EQDv95ZefwiEeTYsknPGCQzRzg6g=;
        b=iKZWVy8xdp9RuT0SIbbUNgQ/wk6ilZrqRRUhVnNI5QyFBVSBDgqYecUKZjQQUvKUQl
         1RBpPF+7oKUWxKjzAbUUnoimA2biKIoz3WfUPO0HDgFyyMcqm2bS4s2z+G92z5GnwGMN
         SQMih/uEKZD4Fto950O99Wnjgnw48vwbYvthXIMcgvF3XEHqceLWomeTxZ57/rkqwnci
         +t0KMFcqUv1Ljpgc6v2Uu0/XbfT/wFWFzvkZw01fwJVeU0xbb+dWvzauXyasRlamFiph
         o6ikb3tytc5IaKC0SrIPAsJfJbCu+v3Ngaq9KJxjluK+5D+jXIqJ87q8rMmaYW7gT5YK
         MO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jD8gSJmistFf9e3EQDv95ZefwiEeTYsknPGCQzRzg6g=;
        b=mv2qzdMx6fVQz7akAnGQfuNu1SIYcbaPwdQ1+ewCuSKy5YSwGvqgC/ODJBGXuBMqhE
         CKXp8kRVy3kPRIA22U3oG280+G+5MP4ZOqJ+1o7tHCsPZjhiB/6uuv5vLK5zpKvbAQ1C
         GM2NyRPwEaj/8TKYWMMK91U4leVmdQS+D26jr1AG7M8R8JYcf6jr8403dlckUItzD6YI
         4nNvsZOaVdwQ2lmVe0JDy4yFR8NQuisZFWAExWLYW69j2Wj5IMIwEflmix2aLzehUsQB
         LwFWLYZ3bnekXQWyXmt85RQXdXgFMK4F+Egdo+F82pdBX+r00OJ+iy4GI46AFzVYAKFh
         DATw==
X-Gm-Message-State: AOAM532LSOLTmBPR/AYjZ257fnjJ7/wfCGP02tLphma/3948c+xPc5CT
        Jgpzvp5Dz4KMiSATQ86WLDhIRfwkVXE=
X-Google-Smtp-Source: ABdhPJwFKkMIyR4a7+OpA8i9TmP9CWVUeBQvWId6d3nL7qgH7eTfzL75qTuEMmVtFTFBJ74lu23IjA==
X-Received: by 2002:aa7:82ce:0:b029:142:2501:35cb with SMTP id f14-20020aa782ce0000b0290142250135cbmr9505824pfn.43.1600316942913;
        Wed, 16 Sep 2020 21:29:02 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id 31sm15955885pgs.59.2020.09.16.21.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 21:29:02 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, guaneryu@gmail.com,
        darrick.wong@oracle.com, zlang@redhat.com
Subject: [PATCH 2/2] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Thu, 17 Sep 2020 09:58:44 +0530
Message-Id: <20200917042844.6063-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917042844.6063-1-chandanrlinux@gmail.com>
References: <20200917042844.6063-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 tests/xfs/260     | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/260.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 54 insertions(+)
 create mode 100755 tests/xfs/260
 create mode 100644 tests/xfs/260.out

diff --git a/tests/xfs/260 b/tests/xfs/260
new file mode 100755
index 00000000..1cafa368
--- /dev/null
+++ b/tests/xfs/260
@@ -0,0 +1,51 @@
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
index b99ca082..d6d4425d 100644
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

