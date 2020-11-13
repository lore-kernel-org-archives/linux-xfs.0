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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EE9C4742C
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7F1322240
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzpboTfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgKMMFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgKML1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:27:44 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8841C061A49;
        Fri, 13 Nov 2020 03:27:43 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id a18so7390466pfl.3;
        Fri, 13 Nov 2020 03:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7HROPP4p0WyFli+42wxjrz7OGx+y1FoxAU7QHFJXTg=;
        b=NzpboTfJEMzgZyXR3Cja3DvZ0/2FZmyxj+A7CLGoKlE9ICYKAU7jiBZiX9NNT5LzZL
         UQaXbXiOxZth4VpNwYWP4jqjKOCJNXc8CtpmYYI8wVmFaFXVcOA66AY41hMu/Jcx4j/j
         J2GrahHtkEGCrpFxsj6kqZureJKh5OlmOqF04nu7XpvSqOblxNlBqmlw5xt0b8rsGWaU
         JnqH0/J/LSJ0PxpFMh7meWxBAgD27kqsbOKrhBIpfk/uymC+fBv1pNRkpw+z3+1TGB5Z
         nwv6wvHcJUjMN4eUhhKG0kgE+vmi+uGCso7TYKNbRopkpClC1Q0vcwPCFqZv58epk2By
         +ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7HROPP4p0WyFli+42wxjrz7OGx+y1FoxAU7QHFJXTg=;
        b=bS23mKUjdxPa5ZGHmVa0ehwWrMj8luCCSe58wpBhnyt4k40Kj3BGfrq8sE/yXbwTv9
         zjEjvHkNe53Fa2HSey8lfbpJDAllJ0stfotP78wkWlt59/m67fgMejV01LwD47D8C6Al
         wNKLgCnwdq81vT4LG0hyY2FcW+UPrt/lEAnv21GNHAyf0y1i7Zt+JNqaK5IzvQy3CIug
         OdeNtc/VTZD5G6YBtXWAZxZtzMdHYEQRGtU2CovHggzSrZ1prnPX98uAUKu1ul0M7uK6
         Hx0rnTAnPxGJXIkftOv6F0OYRU1pDJHx1kHv/HjO5gSBRv5Sy+af51cQ5AIIyrVR9b6f
         OAUg==
X-Gm-Message-State: AOAM5320rJ3sYMsKupywrG3wdqV3YeVGkvjmC2lNrnECkc8sNVA4HbCj
        0bauUxuUnxQXf/ItEi+TpJJybZlWleU=
X-Google-Smtp-Source: ABdhPJzOxTKSVyJY2TXe21Qo9TbXfT6uQbmmEyrcISXRJdsMR+sBuHmpe9tFGejs45dChb1mzsRXiA==
X-Received: by 2002:a17:90b:180f:: with SMTP id lw15mr2452378pjb.119.1605266862983;
        Fri, 13 Nov 2020 03:27:42 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:42 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 05/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Fri, 13 Nov 2020 16:56:57 +0530
Message-Id: <20201113112704.28798-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding/removing xattrs.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/525     | 154 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/525.out |  16 +++++
 tests/xfs/group   |   1 +
 3 files changed, 171 insertions(+)
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out

diff --git a/tests/xfs/525 b/tests/xfs/525
new file mode 100755
index 00000000..1d5d6e7c
--- /dev/null
+++ b/tests/xfs/525
@@ -0,0 +1,154 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 525
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# Adding/removing xattrs.
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
+. ./common/attr
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_attrs
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+attr_set()
+{
+	echo "* Set xattrs"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Inject bmap_alloc_minlen_extent error tag"
+	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+	echo "Create xattrs"
+
+	attr_len=$(uuidgen | wc -c)
+	nr_attrs=$((bsize * 20 / attr_len))
+	for i in $(seq 1 $nr_attrs); do
+		$SETFATTR_PROG -n "trusted.""$(uuidgen)" $testfile \
+			 >> $seqres.full 2>&1
+		[[ $? != 0 ]] && break
+	done
+
+	testino=$(stat -c "%i" $testfile)
+
+	_scratch_unmount >> $seqres.full
+
+	echo "Verify uquota inode's extent count"
+
+	nextents=$(_scratch_get_iext_count $testino attr || \
+			_fail "Unable to obtain inode fork's extent count")
+	if (( $nextents > 10 )); then
+		echo "Extent count overflow check failed: nextents = $nextents"
+		exit 1
+	fi
+}
+
+attr_remove()
+{
+	echo "* Remove xattrs"
+
+	echo "Format and mount fs"
+	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
+	_scratch_mount >> $seqres.full
+
+	bsize=$(_get_block_size $SCRATCH_MNT)
+
+	testfile=$SCRATCH_MNT/testfile
+
+	echo "Consume free space"
+	dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
+	sync
+
+	echo "Create fragmented filesystem"
+	$here/src/punch-alternating $testfile >> $seqres.full
+	sync
+
+	testino=$(stat -c "%i" $testfile)
+
+	naextents=0
+	last=""
+
+	attr_len=$(uuidgen | wc -c)
+	nr_attrs=$((bsize / attr_len))
+
+	echo "Create initial xattr extents"
+	while (( $naextents < 4 )); do
+		xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
+
+		for i in $(seq 1 $nr_attrs); do
+			last="trusted.""$(uuidgen)"
+			$SETFATTR_PROG -n $last $testfile
+		done
+
+		_scratch_unmount >> $seqres.full
+
+		naextents=$(_scratch_get_iext_count $testino attr || \
+				_fail "Unable to obtain inode fork's extent count")
+
+		_scratch_mount >> $seqres.full
+	done
+
+	echo "Inject reduce_max_iextents error tag"
+	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+	echo "Remove xattr to trigger -EFBIG"
+	$SETFATTR_PROG -x "$last" $testfile >> $seqres.full 2>&1
+	if [[ $? == 0 ]]; then
+		echo "Xattr removal succeeded; Should have failed "
+		exit 1
+	fi
+}
+
+attr_set
+attr_remove
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/525.out b/tests/xfs/525.out
new file mode 100644
index 00000000..cc40e6e2
--- /dev/null
+++ b/tests/xfs/525.out
@@ -0,0 +1,16 @@
+QA output created by 525
+* Set xattrs
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Create xattrs
+Verify uquota inode's extent count
+* Remove xattrs
+Format and mount fs
+Consume free space
+Create fragmented filesystem
+Create initial xattr extents
+Inject reduce_max_iextents error tag
+Remove xattr to trigger -EFBIG
diff --git a/tests/xfs/group b/tests/xfs/group
index 3fa38c36..bd38aff0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -522,3 +522,4 @@
 522 auto quick quota
 523 auto quick realtime growfs
 524 auto quick punch zero insert collapse
+525 auto quick attr
-- 
2.28.0

