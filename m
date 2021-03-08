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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141BBC15500
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8FFB65220
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 15:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhCHPwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhCHPvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA5C06174A;
        Mon,  8 Mar 2021 07:51:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t9so3244244pjl.5;
        Mon, 08 Mar 2021 07:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omVeCqfQM2+8IWZaAvHwZeqv9Px9m8jWqtPJpOspsnE=;
        b=c2oszHKsD92lSuPczC+r/b1tIr9guTpgH48ft8Hqmd9QHED0Ov6D0mFT7BV1Fcm4py
         FYpbdAz737Qpfcqz4VjwaygfJ2TomYx7sY4v1NTqSzckJkSCQD6lPFK+QC4eS/gnAgZ1
         mBALNW0RgkCOH4RHeZvnB71Poe0eu+pQZpuK3Iv+PRhYjh5NWbr+xJyGbUAcbBHKg4qS
         3AvZhAsKL+hhw/BnkMqCr6k3xzDTqFmVHsugE5CF4mulNyEC0V/atetiO78zw3RnWNKG
         j7JnIQfzheyQTJUxl8sNyCGPyrWqu2Vg6Sh9AgUonlQO2PI2IoW/XXd9SHkgSq5LSc9Q
         WoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omVeCqfQM2+8IWZaAvHwZeqv9Px9m8jWqtPJpOspsnE=;
        b=Ih7pmeOf0c+LAIMDX/Q8PkgDbqbFNDOYTO9801bIsYiRHyXmqtkJGfMlkAoEI3OxMk
         OVhapzh3X/CoUj9TK5teI+x+tchIw+JW6goNNlvNfWHjjLEof74hswQkU8CKQ/Iiy/vT
         DhEn2j8D5Jp9IZUb9AuDaSMFDMPSg3qY13fYhkqf1bWAIfIlOwSiApVqTktgwBREPCpf
         7fiWZvx6fYryM6lLrSkqvGvC/K8J/tunbUCilU398Wr69faWJDBepvqZ4M1thrsDWCZk
         LnD/WVHx7rftSPOxyMeqR+jkzBWO/RRWrel9izqfbPpzv11O8U1Vn1ujaPNTnk5CWoid
         HDww==
X-Gm-Message-State: AOAM531hcLMagO+9orwYiHoPMQ64/YPURrQkdac6W+8Dt88Xw8sAYf+3
        Ex4Qxa6W7C7THPJfBTzvs0HW9GyO0pg=
X-Google-Smtp-Source: ABdhPJwXyDKe8PF3H0UdbwXrt29EJd3TAbHyZO8NlM+ix8HoXywocs0vxaM7ALKZ5MSND8qNAs9btw==
X-Received: by 2002:a17:90b:357:: with SMTP id fh23mr25323804pjb.169.1615218705008;
        Mon, 08 Mar 2021 07:51:45 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:44 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 11/13] xfs: Check for extent overflow when remapping an extent
Date:   Mon,  8 Mar 2021 21:21:09 +0530
Message-Id: <20210308155111.53874-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/535     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/535.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 90 insertions(+)
 create mode 100755 tests/xfs/535
 create mode 100644 tests/xfs/535.out

diff --git a/tests/xfs/535 b/tests/xfs/535
new file mode 100755
index 00000000..6bb27c92
--- /dev/null
+++ b/tests/xfs/535
@@ -0,0 +1,81 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 535
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# remapping extents from one file's inode fork to another.
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
+. ./common/reflink
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_require_xfs_debug
+_require_xfs_io_command "reflink"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Reflink remap extents"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+nr_blks=15
+
+echo "Create \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile >> $seqres.full
+
+echo "Create \$dstfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $dstfile >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Reflink every other block from \$srcfile into \$dstfile"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	_reflink_range $srcfile $((i * bsize)) $dstfile $((i * bsize)) $bsize \
+		       >> $seqres.full 2>&1
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$(xfs_get_fsxattr nextents $dstfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/535.out b/tests/xfs/535.out
new file mode 100644
index 00000000..cfe50f45
--- /dev/null
+++ b/tests/xfs/535.out
@@ -0,0 +1,8 @@
+QA output created by 535
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 15 blocks
+Create $dstfile having an extent of length 15 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index b4f0c777..aed06494 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -532,3 +532,4 @@
 532 auto quick dir hardlink symlink
 533 auto quick
 534 auto quick reflink
+535 auto quick reflink
-- 
2.29.2

