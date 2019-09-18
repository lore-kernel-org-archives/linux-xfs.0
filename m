Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BBCC4CEC4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BECF21924
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 11:49:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdT+3fEX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfIRLtZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 07:49:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35278 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfIRLtZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 07:49:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so3052980plp.2;
        Wed, 18 Sep 2019 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bQ/MA/LGtZ5GVvu+LMj6BceyBfJYfZgDOycctOdkkrE=;
        b=mdT+3fEXduwa+GGOP8QlYdJLLllSPk/S10OegxYqac4SvyauMBG+fhHHkC80xVYaP2
         c79UUJSoy6pjXJ+ocAQYLcE859i/rY0ZV73apIfPAogt8DHYBLVcxljegXYoHccDOeVi
         bYA4dPO5BuRcZXDmpL0dLpspzl49kDGLOOJWy4lnpaxybFhMLwokwwS7kcm7QChOsvFw
         qOadLfZCwmRGC+XCXOZdbwXPTndug7Zx2YxVWGmqC+JBIkGdXwCOjAQP0aH6BFgOxsTc
         JM/u7pbV53GjpP5JIhscftteJIagoL24ieMgLVGP3gfa22h1i98FcYvWTKhKAAaItLcm
         plBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bQ/MA/LGtZ5GVvu+LMj6BceyBfJYfZgDOycctOdkkrE=;
        b=lCSrR+ecTHk4aet3c/KgjBobZzz9HvwJ7PJtRoR9gaIa6LLfvefNiHqpoQ9+aWFFm4
         r2Qr/lkR+/hXP35t4c1RMBwzknfxBLBNWEXxalEwJUymNm15g7XGcEFl+9EXI4NOoNap
         FFD0YDBbFQ5+ZsMnPSgR5iPF4RZgZRH+lXt4ZKL0zX5AgCrlX1VJIcvIZvf4e77wlTHr
         NnujYAZIcq7G1fZEt9tr7nB+aW60WJ405SBGuAE/8ywKKAgoMnthHGa9EufSTQhhmqgB
         gMmQJAWcgu8S44sfVtKCy6s+ZFSNHT50+kBZl0cOVQTBqzsuIZGzQ5py/9H6w2sxWpHz
         q+JA==
X-Gm-Message-State: APjAAAUP5z2zZg1kkduZUOYg2S/esQHwRdt6pGt6WYWGp3UiuedTDP5k
        pSCeC0PCrcza3nqoWHrB1g==
X-Google-Smtp-Source: APXvYqygOO/WQ1/qjL90aVLesFQOszXD3DJJtiWyjTt0g0G6AuGpcxT+ck+q5KCqTO2RPvdUEWHw4A==
X-Received: by 2002:a17:902:b7c3:: with SMTP id v3mr3616678plz.139.1568807364833;
        Wed, 18 Sep 2019 04:49:24 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id b20sm10625220pff.158.2019.09.18.04.49.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 04:49:24 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v3 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <db6c5d87-5a47-75bd-4d24-a135e6bcd783@gmail.com>
Date:   Wed, 18 Sep 2019 19:49:22 +0800
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
 tests/xfs/512     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100755
index 0000000..a2089f0
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,96 @@
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
+. ./common/renameat2
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+# single AG will cause default xfs_repair to fail. This test need a
+# single AG fs, so ignore the check.
+_require_scratch_nocheck
+_requires_renameat2 whiteout
+
+filter_enospc() {
+	sed -e '/^.*No space left on device.*/d'
+}
+
+create_file()
+{
+	local target_dir=$1
+	local files_count=$2
+
+	for i in $(seq 1 $files_count); do
+		echo > $target_dir/f$i >/dev/null 2>&1 | filter_enospc
+	done
+}
+
+rename_whiteout()
+{
+	local target_dir=$1
+	local files_count=$2
+
+	# a long filename could increase the possibility that target_dp
+	# allocate new blocks(acquire the AGF lock) to store the filename
+	longnamepre=`$PERL_PROG -e 'print "a"x200;'`
+
+	# now try to do rename with RENAME_WHITEOUT flag
+	for i in $(seq 1 $files_count); do
+		src/renameat2 -w $SCRATCH_MNT/f$i $target_dir/$longnamepre$i >/dev/null 2>&1
+	done
+}
+
+_scratch_mkfs_xfs -d agcount=1 >> $seqres.full 2>&1 ||
+	_fail "mkfs failed"
+_scratch_mount
+
+# set the rename and create file counts
+file_count=50000
+
+# create the necessary directory for create and rename operations
+createdir=$SCRATCH_MNT/createdir
+mkdir $createdir
+renamedir=$SCRATCH_MNT/renamedir
+mkdir $renamedir
+
+# create many small files for the rename with RENAME_WHITEOUT
+create_file $SCRATCH_MNT $file_count
+
+# try to create files at the same time to hit the deadlock
+rename_whiteout $renamedir $file_count &
+create_file $createdir $file_count &
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
