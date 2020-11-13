Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958B8C388F7
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3E322240
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:29:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tDTsWMN0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgKML24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgKML2H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:28:07 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B52C061A4A;
        Fri, 13 Nov 2020 03:27:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id s2so4407746plr.9;
        Fri, 13 Nov 2020 03:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+PciDivRWXUvLdWNX7xttPep6/rYh/hZOshTARBJVQ=;
        b=tDTsWMN0pwf2JFb4E5vnygFc1BAB/c4pvdgaz/lF+mjroWt/Rp8FMqAMcJDE6ubO6F
         p4dC1AF4o7knA0pElXC0CNhw7yf7mIP10pG2kPxxl5H7Q4XYqlK4XEqQyggAOh+HzNc2
         tJ1JV7Q//f6dtKEiSRIatdichyHFdXBpN9kj1M8R1g5BlkqNgJ57UzBx0t7K7Tz2kiXh
         dBgfRQ9lbwBuqqhhsKKyvRgaw6qv6V8CSTdNW6uLWn8OBIa7k7TObJgts6gM/ZOvSxhU
         FsAFA34Ox3wxnysjEzuJw3FGdIl3IHKXED7sOdFsTQ8seQRR9gx8zDE+7TdaV/hoQ7Uq
         c7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+PciDivRWXUvLdWNX7xttPep6/rYh/hZOshTARBJVQ=;
        b=eSg51VMHqcg0zOoutv1GOU81zV7DmxrGxlZBzlKUOT5WMa+GS6uXeokxoLFfhYhzcf
         VK4N4doQKkIgVXpU6ubtuY4FsK5WgX+ZWP7qjYj88rsgRi19piFbXtuVYED5ssZvYfdn
         XEf1ZcX70QZ0zlTo0s7IEnW6D3XTIPZIhvpk+3MAO7Spd56tMmqrFpFFwCgW1UZsR1Yc
         d/nB3yArv8imbU7ziZ31LnpZ0PjWverBLhxj5pymCF3s0PpJLTnVKOj4QTKSCJ4qZpsv
         8aMAwc3JNQqrdfiIx9GJdbvm9AhTDhqIXkY+H2g8dWtSwHXAx0gcz2LZG3H4/N9QFtUw
         TYww==
X-Gm-Message-State: AOAM533svphGX4xNpZuUoFVlJXpJIzIMQqVxwwSDQTf1vL8tap60OMEU
        4C2kDoHqcDn+wAU+BaYN3CofTK8vz+8=
X-Google-Smtp-Source: ABdhPJzCh6KcHeuJUJgubAdEXMNdz5pcjtSot7PJwxy2EqoSEaQrvCkRyI33u/+D2VArJbciIVzaxw==
X-Received: by 2002:a17:902:8685:b029:d7:bb:aa2 with SMTP id g5-20020a1709028685b02900d700bb0aa2mr1813554plo.13.1605266872870;
        Fri, 13 Nov 2020 03:27:52 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:52 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 09/11] xfs: Check for extent overflow when remapping an extent
Date:   Fri, 13 Nov 2020 16:57:01 +0530
Message-Id: <20201113112704.28798-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when remapping extents from one file's inode fork to another.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/529.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 95 insertions(+)
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out

diff --git a/tests/xfs/529 b/tests/xfs/529
new file mode 100755
index 00000000..a44ce199
--- /dev/null
+++ b/tests/xfs/529
@@ -0,0 +1,86 @@
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
+nr_blks=15
+
+echo "Create \$srcfile having an extent of length $nr_blks blocks"
+xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile >> $seqres.full
+
+echo "Create \$dstfile having an extent of length $nr_blks blocks"
+xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $dstfile >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+echo "Reflink every other block from \$srcfile into \$dstfile"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	xfs_io -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
+	       $dstfile >> $seqres.full 2>&1
+done
+
+ino=$(stat -c "%i" $dstfile)
+
+_scratch_unmount >> $seqres.full
+
+echo "Verify \$dstfile's extent count"
+
+nextents=$(_scratch_get_iext_count $ino data ||
+		_fail "Unable to obtain inode fork's extent count")
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
new file mode 100644
index 00000000..687a8bd2
--- /dev/null
+++ b/tests/xfs/529.out
@@ -0,0 +1,8 @@
+QA output created by 529
+* Reflink remap extents
+Format and mount fs
+Create $srcfile having an extent of length 15 blocks
+Create $dstfile having an extent of length 15 blocks
+Inject reduce_max_iextents error tag
+Reflink every other block from $srcfile into $dstfile
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index c85aac6b..bc3958b3 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -526,3 +526,4 @@
 526 auto quick dir hardlink symlink
 527 auto quick
 528 auto quick reflink
+529 auto quick reflink
-- 
2.28.0

