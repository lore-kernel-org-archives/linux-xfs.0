Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E43C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA4021741
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tc4u0XLi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgINJBq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgINJBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 05:01:44 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A7DC06174A;
        Mon, 14 Sep 2020 02:01:44 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d9so12073304pfd.3;
        Mon, 14 Sep 2020 02:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+24N/EyLiqfwOkczTQJ75qiO/VbQgLG0qcqPZDYvsU=;
        b=tc4u0XLi6dDJxLgK/riPzCILi1zcAG4GupY/n9cq46rd2oq12mA5ZKF/50xDHf1Bbo
         3racpJKzZSiTCeJRxZV3uipSaDvDBVbEmM4f5emVwzR2yzUCT2ctiZWZlpoSwomW5iLp
         +2msU/iwyUL76uWzDyzI91QZYiSa9l8FvibSCMtnyURXCKi/Il7xZ0KdQGvFk2sPukgQ
         VrsiaPidrVUZtus+3IydmnFIXULzizfwY+AxRIsLQSmm3O2rHqXYIUD3azsoLQmnLbqU
         BJnonUWZoW23yA7oNLRyRbT3jhYOs6za2+YUGuk3S9LP56cp2XGJBK9y5fBFIhCjXUoX
         NKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+24N/EyLiqfwOkczTQJ75qiO/VbQgLG0qcqPZDYvsU=;
        b=C21wwmmvRSHbomdB+5EfKM1dN82WKIj2OQAg1+LnY10vMsMgn/wjxkeSkGFmjm8Ul4
         jU+0xAS055+rZSj0kdWSkoVRhZozuGnphCy8ALC3mtvsZtaG371sy6oyLcazT6nE5Xl+
         eb8az49WP3+ayBnYDiVcRYIpB7bksBTnBys21gOj4qDFtWs+P7yxYq3gozQU5tZZui5k
         i6qdIlwdy/822CAgxeBqkcGIXnoXQhmHEizPNvNSAu35QqTWZ5UBD49pt1ArhmIPREV8
         lZ3WcCBrQcBvvZJHX029uqw6cZ3Y5LZvayh71w/P6wwcX4g+BDGmuZfwbuoAUzoBVdb8
         cJxA==
X-Gm-Message-State: AOAM531FhHLV1NJaBfsIb/vy8KypHhvHbO2vHDUblD42ItwOF7bLxkq7
        GPGQH05cDvtFqeaEB+GHrNkxIeGq/RY=
X-Google-Smtp-Source: ABdhPJyIq5WyxybyylT0VdqRX2fIrmd/mc5WKHXb+ariYLC4BZMcWerFKf35ptzMAersXBHAkBaIRA==
X-Received: by 2002:a63:471b:: with SMTP id u27mr10164130pga.139.1600074103271;
        Mon, 14 Sep 2020 02:01:43 -0700 (PDT)
Received: from localhost.localdomain ([122.182.251.12])
        by smtp.gmail.com with ESMTPSA id z129sm7918182pgb.84.2020.09.14.02.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 02:01:42 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, guaneryu@gmail.com,
        darrick.wong@oracle.com
Subject: [PATCH] xfs: Check if rt summary/bitmap buffers are logged with correct xfs_buf type
Date:   Mon, 14 Sep 2020 14:30:53 +0530
Message-Id: <20200914090053.7220-1-chandanrlinux@gmail.com>
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
 tests/xfs/260     | 52 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/260.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 55 insertions(+)
 create mode 100755 tests/xfs/260
 create mode 100644 tests/xfs/260.out

diff --git a/tests/xfs/260 b/tests/xfs/260
new file mode 100755
index 00000000..5fc1a5fc
--- /dev/null
+++ b/tests/xfs/260
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 260
+#
+# Test to check if growing a real-time device can end up logging an
+# xfs_buf with the "type" subfield of bip->bli_formats->blf_flags set
+# to XFS_BLFT_UNKNOWN_BUF.
+#
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
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_realtime
+
+MKFS_OPTIONS="-f -m reflink=0,rmapbt=0 -r rtdev=${SCRATCH_RTDEV},size=10M" \
+ 	    _mkfs_dev $SCRATCH_DEV >> $seqres.full
+_scratch_mount -o rtdev=$SCRATCH_RTDEV
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
index ed0d389e..6f30a2e7 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -257,6 +257,7 @@
 257 auto quick clone
 258 auto quick clone
 259 auto quick
+260 auto
 261 auto quick quota
 262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 263 auto quick quota
-- 
2.28.0

