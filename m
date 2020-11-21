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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853C4C8300B
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 459E322252
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 08:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRp3Bfck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgKUIYH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 03:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgKUIYH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Nov 2020 03:24:07 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83815C0613CF;
        Sat, 21 Nov 2020 00:24:07 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id l11so6182955plt.1;
        Sat, 21 Nov 2020 00:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RCqROnImwvyXzl6bVYsymZFsI81FeC2UbTuw1mbNivE=;
        b=kRp3Bfck1o1dl0uqPkakO0a4DwIRcJdvXtbwd7Dxc+ZWDpl9fEGnSkBzArvz9TTRng
         9rEmjtXalZ+AyV46EKCSe5ssiSEh8xlP559c2uotwWOn47TY1D3ZKTJQmEHkQq3DoJ5r
         +B0o7vKn4RvSmTXwpOQ84tce2wmC2ZSSfJ1aVYDtuNkllySI0xhxNsq8snkuvjPdWNEr
         GtkqOHPk75V54qEmqqG9lMyE8ICB8/12KMne8B1XQVC8RN2QqvP0LvIRYF07Ni5Fq7wd
         uLd12OJT0/Xj/x1GjZ1eW0epr9yeSRaGexJzrFUVQJPuEXGYhqzFu0Nqp3OmULLXiBD5
         8bUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RCqROnImwvyXzl6bVYsymZFsI81FeC2UbTuw1mbNivE=;
        b=cKhmd6TLDMHBloTfVFm0QZ6QVV/bpXD85HF55H/wfRiYs7KppYHt14MlZCpDd920zR
         Or83Q7gN21yGQrYjN2t/y+kkIrqUgjLLwuk8P0PuuEE6Igj7eGqQBaWtKzP0yVyziyo1
         qYwinuxKrQS7CFcEyg9n+ICpzhsIpCYB4LZQxXAn4euUrBx9yOYyjuKPuk5OxQiPJowB
         rfZw5lppvmkkOYeH3AGJ/QoII2MgdGiNgPr6LkVIIL6JSBaa8+YFiLgTywpxfaEOuQNI
         fhmOfG4+IbXzTn2Vgbhv+tKGgasletpkSe8YPwzzBK0nSCjAfEmffXjwCERPQthOWG2I
         rtMg==
X-Gm-Message-State: AOAM531vbUWU4ggZYCE3pmbsp0FIBOuwMs9NXXiN8l9MMjfKcnA76feL
        fYvVmjXCyUkSzXg4IN/IVfO3ju53okA=
X-Google-Smtp-Source: ABdhPJw2y+G9xupa/E4XPBD83AqFRLAtRAQg2UqU8B6okhLnts4j1OGCGxfMlVBXvvBlTB71wO5FEg==
X-Received: by 2002:a17:902:7486:b029:d9:d4aa:e033 with SMTP id h6-20020a1709027486b02900d9d4aae033mr12594535pll.16.1605947046790;
        Sat, 21 Nov 2020 00:24:06 -0800 (PST)
Received: from localhost.localdomain ([122.167.41.102])
        by smtp.gmail.com with ESMTPSA id e22sm6167148pfd.153.2020.11.21.00.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 00:24:06 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH V2 09/11] xfs: Check for extent overflow when remapping an extent
Date:   Sat, 21 Nov 2020 13:53:30 +0530
Message-Id: <20201121082332.89739-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121082332.89739-1-chandanrlinux@gmail.com>
References: <20201121082332.89739-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 91 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..47e738af
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 529
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
+nr_blks=40
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
+	$XFS_IO_PROG -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
+	       $dstfile >> $seqres.full 2>&1
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
+nextents=${nextents##fsxattr.nextents = }
+if (( $nextents > 35 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..06b8a769
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,8 @@
+QA output created by 529
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 40 blocks
+Create $dstfile having an extent of length 40 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index ea892308..96e40901 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,6 +526,7 @@
 526 auto quick dir hardlink symlink
 527 auto quick
 528 auto quick reflink
+529 auto quick reflink
 758 auto quick rw attr realtime
 759 auto quick rw realtime
 760 auto quick rw collapse punch insert zero prealloc
-- 
2.29.2

