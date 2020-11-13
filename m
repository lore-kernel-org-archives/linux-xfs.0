Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6319C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6F0622250
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U9NrPQ4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgKML24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgKML2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:28:07 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105F6C061A4B;
        Fri, 13 Nov 2020 03:27:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r186so6886693pgr.0;
        Fri, 13 Nov 2020 03:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rfh6r8h4r1l5e9rz2uPEKmppi0Azq2EOi1A6KcIRpTM=;
        b=U9NrPQ4cTUgytfjmgn56s0mIbMqZuup0oblQM2gSH03T+K4Sz8Exjgy7S/JC6lxiwy
         aF3jDSGdm7lAAhLOz0tXwEPqSSi3iiHop+Bj2KuCp5wYlnoJWcFSuCsAY3ChguOi7VnX
         GmXv5ZMBVjPzL4cGkkVZPsRpCMMGw4Klu2/0w643WDlqRnshUFslDURvTFVSwv0V+vp8
         eXEjsL4ZvFxZooynNHRBLU+/uA72ke4RPD1BCiFa8h604MWCjUohLWUyZMjjHTnC3Ys4
         +nfKEwQIvFAmGbUjegUszTnhQ20d4Z7vfYPwv6FExsaCGL1p1OyxBOB2YmUyaGGX4Gjt
         kZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rfh6r8h4r1l5e9rz2uPEKmppi0Azq2EOi1A6KcIRpTM=;
        b=oRb41vnSt1wg1Um9zcEZdRTb1i5WHnMWtwkhzg4NZLgqs1j0qDZawQn3Wg0P1i4LNG
         NmKgrAclWbBd3Cnlh8Q2aJUHFvGgbXs/JIKqMcMG486FrEUb/fvjLiLPm9H2Wwy4fbMn
         CulXVdEP8DDXSDCAGjaooMQpGGBBCsnnJbzdAigIBGdkH+4oIhniWpxgHIJ/Ce2GlaHI
         sbCENAWHZwRHt7dhu6OYhomKfst0e7z+NuNBsfCFZczr1GRX6URV3QN9xZlK8rVlHbud
         H3b/0ePlJNsyIJWQ1edfEujnv12hnfYMp3LWx4qnU71hcKxHEexETB/NFTgxTFX9SqJR
         ZPlg==
X-Gm-Message-State: AOAM5300dWHBg3sTXROqKFJuK/cQAdIELv2fANFbdNRapmxa0CCN3DY+
        I3ZFYduBnKI3fm8FP8X5RgLJLnkW4KE=
X-Google-Smtp-Source: ABdhPJxFvUTwceo2pjzxFAVWUSXhbPZqQ3i6fGfKZMNQ/vL/9kTzPCdE3jAXwly2chlwrw9ckMZYaQ==
X-Received: by 2002:a63:5754:: with SMTP id h20mr1683521pgm.378.1605266875344;
        Fri, 13 Nov 2020 03:27:55 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 10/11] xfs: Check for extent overflow when swapping extents
Date:   Fri, 13 Nov 2020 16:57:02 +0530
Message-Id: <20201113112704.28798-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when swapping forks across two files.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530     | 115 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/530.out |  13 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 129 insertions(+)
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out

diff --git a/tests/xfs/530 b/tests/xfs/530
new file mode 100755
index 00000000..fccc6de7
--- /dev/null
+++ b/tests/xfs/530
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 530
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# swapping forks between files
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
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "swapext"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "* Swap extent forks"
+
+echo "Format and mount fs"
+_scratch_mkfs >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+donorfile=${SCRATCH_MNT}/donorfile
+
+echo "Create \$donorfile having an extent of length 17 blocks"
+xfs_io -f -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" -c fsync $donorfile \
+       >> $seqres.full
+
+# After the for loop the donor file will have the following extent layout
+# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
+echo "Fragment \$donorfile"
+for i in $(seq 5 10); do
+	start_offset=$((i * bsize))
+	xfs_io -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
+done
+donorino=$(stat -c "%i" $donorfile)
+
+echo "Create \$srcfile having an extent of length 18 blocks"
+xfs_io -f -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" -c fsync $srcfile \
+       >> $seqres.full
+
+echo "Fragment \$srcfile"
+# After the for loop the src file will have the following extent layout
+# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
+for i in $(seq 1 7); do
+	start_offset=$((i * bsize))
+	xfs_io -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
+done
+srcino=$(stat -c "%i" $srcfile)
+
+_scratch_unmount >> $seqres.full
+
+echo "Collect \$donorfile's extent count"
+donor_nr_exts=$(_scratch_get_iext_count $donorino data || \
+		_fail "Unable to obtain inode fork's extent count")
+
+echo "Collect \$srcfile's extent count"
+src_nr_exts=$(_scratch_get_iext_count $srcino data || \
+		_fail "Unable to obtain inode fork's extent count")
+
+_scratch_mount >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+echo "Swap \$srcfile's and \$donorfile's extent forks"
+xfs_io -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
+
+_scratch_unmount >> $seqres.full
+
+echo "Check for \$donorfile's extent count overflow"
+nextents=$(_scratch_get_iext_count $donorino data || \
+		_fail "Unable to obtain inode fork's extent count")
+if (( $nextents == $src_nr_exts )); then
+	echo "\$donorfile: Extent count overflow check failed"
+fi
+
+echo "Check for \$srcfile's extent count overflow"
+nextents=$(_scratch_get_iext_count $srcino data || \
+		_fail "Unable to obtain inode fork's extent count")
+if (( $nextents == $donor_nr_exts )); then
+	echo "\$srcfile: Extent count overflow check failed"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/530.out b/tests/xfs/530.out
new file mode 100644
index 00000000..996af959
--- /dev/null
+++ b/tests/xfs/530.out
@@ -0,0 +1,13 @@
+QA output created by 530
+* Swap extent forks
+Format and mount fs
+Create $donorfile having an extent of length 17 blocks
+Fragment $donorfile
+Create $srcfile having an extent of length 18 blocks
+Fragment $srcfile
+Collect $donorfile's extent count
+Collect $srcfile's extent count
+Inject reduce_max_iextents error tag
+Swap $srcfile's and $donorfile's extent forks
+Check for $donorfile's extent count overflow
+Check for $srcfile's extent count overflow
diff --git a/tests/xfs/group b/tests/xfs/group
index bc3958b3..81a15582 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -527,3 +527,4 @@
 527 auto quick
 528 auto quick reflink
 529 auto quick reflink
+530 auto quick
-- 
2.28.0

