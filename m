Return-Path: <SRS0=4OPL=YK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19EFFA3732
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 09:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38E721848
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Oct 2019 09:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QiT17T8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439521AbfJQJlB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 05:41:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44716 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439516AbfJQJk7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Oct 2019 05:40:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id q15so846418pll.11;
        Thu, 17 Oct 2019 02:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IFU/J9klOPXpeK+FUQd7ZcRQH26PWNssyQpLrq+S1gY=;
        b=QiT17T8EblTRQ1ZF9Yppbw/JKsPQwI6fyqiKIbUpXQwKGqFfdtJkaJyZDoxuCW8xPg
         chn8bYmzHRx65TW/2Gswu/10UoAvXzrnP/uyOlWPu+5HB5PnZErfdfAKa/3VJGZey14p
         6gz4Gr9gr817GhbgrhRJB7dJNFv7QWyhdvRSVr7+0QSHiK/FYtF2al0/HhEEjuGjGldK
         KPJM9RCubBBCS2Re9yYwGec24yVxd3kyqj6bfuPxdjFsXnf70x/8wk1bcxQm4c+b4V7N
         QAdAlkN39Wwr1Y0shWDH0CaeyeKPQYioP0p43lLapM6mEMfPL8b27CcCy9GtjkeDeBrX
         qTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=IFU/J9klOPXpeK+FUQd7ZcRQH26PWNssyQpLrq+S1gY=;
        b=b/4yzqMoGW9wbpoO59heAb/B/DKD9Z6f6igRIJ49aRCkw3s0p17WvVsosmuoksUCba
         pJHbvBRng+q7USNcnXQKoH8suGVVCEq65XKS3V6RZ/EFTy8gZrhrDlTl4PHIi9nWT4f+
         k5b5zexaNMTXPIh32i3zdQkM0tIz1WyjcvbIvpogxeN5Mzbu8N1GweoyXKlEZHzLD2dE
         rSDfqriQ5UBvZ9gaLwXAJwXqCPaC4o20xcWSOYRqTOor3iaw12McAeh2b1OQNLExyklv
         9oEvnPYoQ3Us7j7cYyGaPuKDESU9IzoxpkawYGkEGQQXIeAzXb9RIKDaCfIlUcsNuCUB
         +K0g==
X-Gm-Message-State: APjAAAVgRSnLBa0gOxMZt6zdi3ffeiRF7zn8N0eogofidrTmFdrv2+cA
        gQWFfrwrYzIZjTHi9OYj7A==
X-Google-Smtp-Source: APXvYqzcUxD9mpqCSqkvLuTalAyLgguCff3yuJWptdLSN68g0N1RyFUxHlTDhAihx1lmQn9U4zQONg==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr3115502pla.55.1571305256705;
        Thu, 17 Oct 2019 02:40:56 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id q76sm3748063pfc.86.2019.10.17.02.40.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 02:40:56 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH RFC] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <a1a28793-6fc3-fb53-2ec3-646f1a758443@gmail.com>
Date:   Thu, 17 Oct 2019 17:40:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
index 0000000..d6b0042
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
+$FSSTRESS_PROG -z -n 100 -p 100 \
+		-f creat=5 \
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

-- 
kaixuxia
