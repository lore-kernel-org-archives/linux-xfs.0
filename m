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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3386C63697
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D96D207DE
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 11:30:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MbXPjWTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgKMLa3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 06:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgKML2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 06:28:21 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB30C061A48;
        Fri, 13 Nov 2020 03:27:51 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g7so7403789pfc.2;
        Fri, 13 Nov 2020 03:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=It9eDeqASlzE9iUH+GF+Ahf6+010vIJ6aAmZ1pUVA6o=;
        b=MbXPjWTWDFzL2HlAU2cikiB0Cnby+n1+6Tn6prekIwGO/DpNBciUTA3t58TuhzJsqJ
         d025eb5zzW4WExbMxq3LqgdFpWRVVAWidq5jcKc36I17BnZha3Ex64x8jPtOAljy+jHh
         67+kw6ouqioVQQ8qKW/qduYnAU+iR33LrP5ULly6ZARK7VIkerU5OPor3xyE8FFHmZxw
         UTMa7ot7lizR12rNGrcB/2LMx//gOo7ttfjBYopRGChS/y2QvSZ2kwRBTkXC56W39Yem
         w6cc0MaMDVt4G5p/lEv4Fij2gQYiJ7bhqq8wE7YMLpwx3/Aoyu+hRp/V5HcvQPTVbRFv
         ej6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=It9eDeqASlzE9iUH+GF+Ahf6+010vIJ6aAmZ1pUVA6o=;
        b=ma0I4tOpac/XnmHRcAwtAyEA/xyVlmSZMcSNNeojQaQgvtmLAyufM8NtqR+chYsrjl
         kekiNVbVnfZSy3nBtygfm1qZ+C7uPefH5hC/kLF9hA3vSDE2IyBf24VP3o5BAs0gNbyn
         YHnw2qVre3EkC1EkWlPx09yOpWmbg5pJa7C3HpxAUSU7vRrUol/8v868lrinL4m7rPeo
         6IqhoTN9HA0IiAbSn21bj3yXpjmyJa8i7NkF3dY9wSEsievdPRJo9jJNF06zndNrIknq
         5jDwYsH2GHIVkuohPTm6Nb6i9hjOGHxqXxxATYkf+gHpXrOdoAFF3d6JfSI+stD+AnfU
         jUqQ==
X-Gm-Message-State: AOAM5304bYkxfsrX2fskElvHsKoAj6vc4RKS+pUMhbX1TjTBZd9cfMxB
        tBKjCotSRULzwSphacTLFz6isDnbAd0=
X-Google-Smtp-Source: ABdhPJykxrzjQJsuoZntCYc5exbIBytAP1Irz6H0p8b909saHqqs4Zk153UnqJ8Ol+tiY4SgU9D8Jw==
X-Received: by 2002:a17:90a:4215:: with SMTP id o21mr2426060pjg.166.1605266870492;
        Fri, 13 Nov 2020 03:27:50 -0800 (PST)
Received: from localhost.localdomain ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id w131sm9410857pfd.14.2020.11.13.03.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 03:27:49 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: [PATCH 08/11] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Fri, 13 Nov 2020 16:57:00 +0530
Message-Id: <20201113112704.28798-9-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113112704.28798-1-chandanrlinux@gmail.com>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to a shared extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/528     | 87 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  8 +++++
 tests/xfs/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..0d39f05e
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,87 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 528
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to a shared extent.
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
+echo "* Write to shared extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+nr_blks=15
+
+echo "Create a \$srcfile having an extent of length $nr_blks blocks"
+xfs_io -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile  >> $seqres.full
+
+echo "Share the extent with \$dstfile"
+xfs_io -f -c "reflink $srcfile" $dstfile >> $seqres.full
+
+echo "Inject reduce_max_iextents error tag"
+xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
+
+echo "Buffered write to every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+ino=$(stat -c "%i" $dstfile)
+
+_scratch_unmount >> $seqres.full
+
+echo "Verify \$dstfile's extent count"
+
+nextents=$(_scratch_get_iext_count $ino data || \
+		_fail "Unable to obtain inode fork's extent count")
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+fi
+
+# success, all done
+status=0
+exit
+ 
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..8666488b
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,8 @@
+QA output created by 528
+* Write to shared extent
+Format and mount fs
+Create a $srcfile having an extent of length 15 blocks
+Share the extent with $dstfile
+Inject reduce_max_iextents error tag
+Buffered write to every other block of $dstfile's shared extent
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 627813fe..c85aac6b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick attr
 526 auto quick dir hardlink symlink
 527 auto quick
+528 auto quick reflink
-- 
2.28.0

