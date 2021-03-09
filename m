Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED9FC4332E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA85B6529E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 05:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIFC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhCIFB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 00:01:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC9DC06174A;
        Mon,  8 Mar 2021 21:01:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o38so7946315pgm.9;
        Mon, 08 Mar 2021 21:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UoIgnUhVWthCqsPnEF2k+5Wvvq+hQl8O9VoT2BqJBss=;
        b=RCDwapbH285aJvvPUS6c3Fv2Jehs9yjtOpcQVnk2lEartpQoOml6JwDgIWsWt6nMam
         Hl0MX4SESsMyL4ukkEhdHCFj1fixoVdB2CdsVwEb44fU2o3EtgVJ2fLdI17Cz9l/6cIE
         NDgy3ComOBEFdSjLJ52dgmqFfa8J/ppzbgpjlTSxZnURUrp2Sb6twlaupzuMB8m3+INa
         a7IAI2l9ylyuR3IRr+TNkdqFwYVp7xe3HwnHaraXyS52QXlzE/GL3v0UAhDD7w63dXf9
         iarbJ8ueIRafKKM40/Rw542IKniWAwaRbPFkRwl/oj9pnGm9KGdeYrpNAxuOnI7JrPvf
         v1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UoIgnUhVWthCqsPnEF2k+5Wvvq+hQl8O9VoT2BqJBss=;
        b=np4dzECx/NGpTcaKAEjbstx4yE5JyBFYlczLiGYb+TMCoBTt+fYwfJlnWkLFB+HCD/
         dC29hIOpBfRoqrhIqVfrrCMHIB2hxVto529/yoDmxce2e+ZtbbuslBwGOVxa5jvbp3FU
         c4bducbYJ7Q6G/+vCv3KNhuJ0dThE2zDZLId/A2LoTLa1/LZFsWoBzkptBDNAqK2WsBg
         e8jG/rfdDp2M1gSvc9zY1upH5utqU0oan24S9VYeubqxuDNhgEX9pgGF/+VMJO0sWMyh
         SxeR1Cjh5wAggz/MyXbrwcq5jv6Yyj3igx5Sj9bqWzbWXBHWSI12k+JZO0k44OFoyRU5
         bmXA==
X-Gm-Message-State: AOAM533xeCdY13wq1dmjV5D7s+J42pVThgDhqUtNpDWElEf5NK2y1rQm
        00l3zm90jE1KK71yNsbyzOs15qd75OQ=
X-Google-Smtp-Source: ABdhPJwwMnWk9sbLUr+y86827Cg/9yTss8pdZj8pUlwcTNRP1gv8Ky+aG3rdhGSrdT/kotu4HvGo4g==
X-Received: by 2002:a63:6f8a:: with SMTP id k132mr24406710pgc.59.1615266118622;
        Mon, 08 Mar 2021 21:01:58 -0800 (PST)
Received: from localhost.localdomain ([122.179.125.254])
        by smtp.gmail.com with ESMTPSA id a21sm5849577pfh.31.2021.03.08.21.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 21:01:58 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V6 09/13] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue,  9 Mar 2021 10:31:20 +0530
Message-Id: <20210309050124.23797-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309050124.23797-1-chandanrlinux@gmail.com>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to an unwritten extent.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/533     | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/533.out | 11 +++++++
 tests/xfs/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/xfs/533
 create mode 100644 tests/xfs/533.out

diff --git a/tests/xfs/533 b/tests/xfs/533
new file mode 100755
index 00000000..bb6f075e
--- /dev/null
+++ b/tests/xfs/533
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 533
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to an unwritten extent.
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
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_debug
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+testfile=${SCRATCH_MNT}/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+nr_blks=15
+
+for io in Buffered Direct; do
+	echo "* $io write to unwritten extent"
+
+	echo "Fallocate $nr_blks blocks"
+	$XFS_IO_PROG -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
+
+	if [[ $io == "Buffered" ]]; then
+		xfs_io_flag=""
+	else
+		xfs_io_flag="-d"
+	fi
+
+	echo "$io write to every other block of fallocated space"
+	for i in $(seq 1 2 $((nr_blks - 1))); do
+		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
+		       $testfile >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	echo "Verify \$testfile's extent count"
+	nextents=$(_xfs_get_fsxattr nextents $testfile)
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+
+	rm $testfile
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/533.out b/tests/xfs/533.out
new file mode 100644
index 00000000..5b93964a
--- /dev/null
+++ b/tests/xfs/533.out
@@ -0,0 +1,11 @@
+QA output created by 533
+Format and mount fs
+Inject reduce_max_iextents error tag
+* Buffered write to unwritten extent
+Fallocate 15 blocks
+Buffered write to every other block of fallocated space
+Verify $testfile's extent count
+* Direct write to unwritten extent
+Fallocate 15 blocks
+Direct write to every other block of fallocated space
+Verify $testfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 77abeefa..3ad47d07 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -530,3 +530,4 @@
 530 auto quick punch zero insert collapse
 531 auto quick attr
 532 auto quick dir hardlink symlink
+533 auto quick
-- 
2.29.2

