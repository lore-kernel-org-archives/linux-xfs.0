Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28B0CA9EC0
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60FA21D7E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 14:21:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXicb9Fq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393913AbfJXOVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:21:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33708 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393910AbfJXOVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 10:21:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id c184so5739857pfb.0;
        Thu, 24 Oct 2019 07:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=e9HQKKJbsIVy6b/ristOMpsKHhr0/kDMpwhPfPMNbOA=;
        b=IXicb9FqvjQaRxTjb/gSj1/vV64zIo8ppsBol95iqhFJ7R7vxZGgyXCp/ApkCn7ToJ
         uElOV7h+D621LhsqUTwa9Hi668wJ5YAoe94Wb53GQh/huykQTDNlSrl6tpxFggkrf+YW
         iJyH/3iSSgfNFaXw1eiS5OYv3g/wSeWnOLPDGwqCUsnKRIUxQymlxpEhxN+58N/lD49u
         ZtZhXRjL5ot/e2YwLHpby4fCkGQh9FP0X9hsiCWmfhu/BDCw77KscYb/LzjaGs9u4WG1
         ux5wC18s1uSkI0Ec8r63f42z7pzUZMvhoA9QnS8ahYLS8tuYEukleSvycZNAxrutfMLl
         ptjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=e9HQKKJbsIVy6b/ristOMpsKHhr0/kDMpwhPfPMNbOA=;
        b=jGaU+WZttXZij03xYiO9zOxQ31Ld9iNI//VXNsphXiIQLreWoROyuNuvQotNIlhr2x
         lT9osjt6npiZsrdnCcBtscePgljvD7eNtFaBqi4wZ7s07Kq+84iHsVFLwtAPzFM/uR1b
         V7S3Hw2Xqj8o6GFmjPeuXCliYuI/5yCREKXeMyGeDbu3MWkHY8iEGdVjDl/wbjlp+Oz+
         3wjo+IMprvHYCR9q2CJUAMOcWF2zBTYystnyLE8Yve69WBrfxBlffIcR+QiVfZBpSlL1
         pm0mpRUH7g1a+4LowL7x7RAVisSPJVsm5wtQS3ZPe9Rd/00AEFfATNfgWUp63s9TDKbK
         1bdw==
X-Gm-Message-State: APjAAAWBhBBrzm0ZUklBP45+CniVXd+7odA352T9peWflbF5bw/rU7ET
        qwrbctjAoYWQ9RSbMqbKjLVmka0Fh9Pu
X-Google-Smtp-Source: APXvYqwAIOQT/LoYkAIscmzlAQCDuQ8CgjYFSegIKuToAX0QYtjEtg1nZBgIcUslBNiaCH6xNpkm6w==
X-Received: by 2002:a63:7e11:: with SMTP id z17mr3824115pgc.33.1571926860872;
        Thu, 24 Oct 2019 07:21:00 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id i11sm24368284pgd.7.2019.10.24.07.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 07:21:00 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH 4/4] xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT
Date:   Thu, 24 Oct 2019 22:20:51 +0800
Message-Id: <7d7257620da4bacbeda3d7c9bf84e2be3fbc597a.1571926791.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1571926790.git.kaixuxia@tencent.com>
References: <cover.1571926790.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, and add this testcase to make
sure the rename() call works well.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
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

