Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A203BC3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 10:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7572A23400
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 10:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZq91MzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbfIDKBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 06:01:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45596 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfIDKBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 06:01:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id y72so5337678pfb.12;
        Wed, 04 Sep 2019 03:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2HIpbUjllMo4sHdRJetlTYtYRIToaa309IUR4vGgRCU=;
        b=UZq91MzXJOcrmGRZlVq89IjJT++2Nym4Z3c8psLjQo3y7FwKd+EOwhLptuH8Xliovm
         EvOhOYnBqo/6TI121Z8bzGLLxFGYDYk7I6sFprRfE7n7g1wh1ybSNoQAOWtJ8YgG5U9O
         0o95ioj3wGKT5UYAoDsCGLmsjiGqzzwlqh5RJzw68onnThg2tv12sBd2d0rv0POwTz7Y
         2RZnbu6aT5VasiXamuK+KV7UK8tGdpweZE2VbvoivHKRdR4AIa4UnLFAbWUBzmH2JPOU
         cx3SQPKnjiph6Vea6DqqJsb5JF6EgvUm+kIB0weivKRViCNkKbHVSiUjmf7qh60ByprN
         y6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2HIpbUjllMo4sHdRJetlTYtYRIToaa309IUR4vGgRCU=;
        b=bm6aTwBs0plKwurs4AbL/mBthcvvGPft9GfD8UvasmHs0QUvHG+jdhVE64EwabYm5w
         caGEsI76MKC4+XjJdlcfVLgeI49ja6kZ89LsUKZcaip51CeyxNd6XLUcFOVHKF/E6Q0P
         FcGZvu89SOmlcH/Kr9lrISfsMKNF5YVg3cn6DwMPzbI4BAmynTpSTNeoZs6PWSD+h5A4
         Zv384wBY8CgrtZHwWArcnEwqpi3m9hn/TpUCHgZUyJzRL6Z4FwiVLGQtdBinw7atH1cL
         beXXLgJcrNVkI4tg9AE3LHbL6ovZcDc2GcJREz8TCezoZYhCLZJETg0upw4n1+4gb30Q
         wMQQ==
X-Gm-Message-State: APjAAAXhhIXioVNWk92SOrdMiSfNI1aMeWyHK/gRwXJKYB5A9eABoZIg
        mafp30UHPWGQFOzdh0GCYg==
X-Google-Smtp-Source: APXvYqxIGP88yJbDx49+/YIcmX0llrNJvirPdLmKpJmaGJRVHXx7LMbT7InCUfS915NW7t4+O6pfxA==
X-Received: by 2002:a17:90a:800a:: with SMTP id b10mr3986125pjn.23.1567591290884;
        Wed, 04 Sep 2019 03:01:30 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id a1sm17277747pgh.61.2019.09.04.03.01.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 03:01:30 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <59006cf8-f825-d33f-c860-111189689e2e@gmail.com>
Date:   Wed, 4 Sep 2019 18:01:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
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
 tests/xfs/512     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |   2 ++
 tests/xfs/group   |   1 +
 3 files changed, 103 insertions(+)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100755
index 0000000..0e95fb7
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,100 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Tencent.  All Rights Reserved.
+#
+# FS QA Test 512
+#
+# Test the ABBA deadlock case between the AGI and AGF When performing
+# rename operation with RENAME_WHITEOUT flag.
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
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch
+
+# Single AG will cause default xfs_repair to fail. This test need a
+# single AG fs, so ignore the check.
+_require_scratch_nocheck
+
+prepare_file()
+{
+	# create many small files for the rename with RENAME_WHITEOUT
+	i=0
+	while [ $i -le $files ]; do
+		file=$SCRATCH_MNT/f$i
+		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+rename_whiteout()
+{
+	# create the rename targetdir
+	renamedir=$SCRATCH_MNT/renamedir
+	mkdir $renamedir
+
+	# just get a random long name...
+	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
+
+	# now try to do rename with RENAME_WHITEOUT flag
+	i=0
+	while [ $i -le $files ]; do
+		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+create_file()
+{
+	# create the targetdir
+	createdir=$SCRATCH_MNT/createdir
+	mkdir $createdir
+
+	# try to create file at the same time to hit the deadlock
+	i=0
+	while [ $i -le $files ]; do
+		file=$createdir/f$i
+		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+_scratch_mkfs_xfs -bsize=512 -dagcount=1 >> $seqres.full 2>&1 ||
+	_fail "mkfs failed"
+_scratch_mount
+
+files=250000
+
+prepare_file
+rename_whiteout &
+create_file &
+
+wait
+echo Silence is golden
+
+# Failure comes in the form of a deadlock.
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/512.out b/tests/xfs/512.out
new file mode 100644
index 0000000..0aabdef
--- /dev/null
+++ b/tests/xfs/512.out
@@ -0,0 +1,2 @@
+QA output created by 512
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index a7ad300..ed250d6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+512 auto rename
-- 
1.8.3.1

-- 
kaixuxia
