Return-Path: <SRS0=KB2e=YT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE436CA9EBF
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6530214DA
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Oct 2019 11:18:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+8/2ytU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZLSw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:18:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36843 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfJZLSv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Oct 2019 07:18:51 -0400
Received: by mail-pf1-f196.google.com with SMTP id v19so3466999pfm.3;
        Sat, 26 Oct 2019 04:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=hLyveOME/rptVjuJxX72WMT3z0xLnQ4b9DdXK8vjCCs=;
        b=g+8/2ytUsW5f7CwYhKr4bL2iMC1xP4x+Hk9SmBnzuLU8sDuENUnd32KLA/Oo1aH2iW
         hw/lBmMRRAG70yC4Cv6NJ91Ddy3eGCf1mupiyMhNLvWp3Mht9QjxFUBXaV9JsyGX+ghj
         hF51upaRHvikParHQFoN4ALyfsLyIMTghrsFZ4oF2q/NOUtvsI7zNuWjayMhJwYA//k3
         zj4kkZd2y1CvoKDBxtU9LEyawDKXbCUHv9hgXzx11zMoxJ8RFOB1yN9XZexGRJlkxv2g
         QVculJUcuYyaKDeBnYs6mbUVbwCo53rV0Yt3I6nxzMO4rbkTo429rwlf4kXv87OzFC9U
         ZC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=hLyveOME/rptVjuJxX72WMT3z0xLnQ4b9DdXK8vjCCs=;
        b=UJUlH3EQyQGRa2DZzP/P4zeDr1Eh5LbFZBr6eINOL3gtFMq5lBWlwA8DZs5nxeorjM
         bjd4dDGUaJlmTFGvwF4iiDOQmaNTvBLbwrVmkscSBvhGGw68lgLPeSEYa/9u0rlN0iN0
         /a4x43c0xm/DTB9hqVDAq2LAB5xFM8fJcEvj7/6eIwywNtiqXLn2+N/7O2QSEviptsCa
         TKCb8l8S08IAImQQV3fP1nr8r2SF+/iq99yuwspCVlXs4K+frTITxgeASw6l9bi4BtRA
         Jk7EPKRczVhcKZRpCUfRF0CV3OZibPjlo250ZIv3DZ89YdhBlfUYYkULazYB4L+URQFf
         iaqg==
X-Gm-Message-State: APjAAAXfUbZPwoRFvL5OOPmObCRrp4Ahqq4qP7l/S5jULcD+uiGgFsP9
        X4eXlPJ3TzHqRhOkms4JWw2Mz5Q=
X-Google-Smtp-Source: APXvYqyi07a9v4IgvQR1bTJqx9cOKxGdqt1RU1OqaeMxdGXES8DfAgjuauKRGU18qhFOAX9VHZU3TA==
X-Received: by 2002:a63:1242:: with SMTP id 2mr1380241pgs.288.1572088730610;
        Sat, 26 Oct 2019 04:18:50 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y2sm6104534pfe.126.2019.10.26.04.18.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 04:18:50 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v2 4/4] xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT
Date:   Sat, 26 Oct 2019 19:18:38 +0800
Message-Id: <a6dc5bd7c0f50840dfd034cd2d0e6931eeb9658a.1572057903.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572057903.git.kaixuxia@tencent.com>
References: <cover.1572057903.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, and add this testcase to make
sure the rename() call works well.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/579     | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/579.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 59 insertions(+)
 create mode 100755 tests/generic/579
 create mode 100644 tests/generic/579.out

diff --git a/tests/generic/579 b/tests/generic/579
new file mode 100755
index 0000000..95727f3
--- /dev/null
+++ b/tests/generic/579
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Tencent.  All Rights Reserved.
+#
+# FS QA Test No. 579
+#
+# Regression test for:
+#    bc56ad8c74b8: ("xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/renameat2
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+_require_renameat2 whiteout
+
+_scratch_mkfs > $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount >> $seqres.full 2>&1
+
+# start a create and rename(rename_whiteout) workload. These processes
+# occur simultaneously may cause the deadlock between AGI and AGF with
+# RENAME_WHITEOUT.
+$FSSTRESS_PROG -z -n 150 -p 100 \
+		-f mknod=5 \
+		-f rwhiteout=5 \
+		-d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
+
+echo Silence is golden
+
+# Failure comes in the form of a deadlock.
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/579.out b/tests/generic/579.out
new file mode 100644
index 0000000..06f4633
--- /dev/null
+++ b/tests/generic/579.out
@@ -0,0 +1,2 @@
+QA output created by 579
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6f9c4e1..21870d2 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -581,3 +581,4 @@
 576 auto quick verity encrypt
 577 auto quick verity
 578 auto quick rw clone
+579 auto rename
-- 
1.8.3.1

