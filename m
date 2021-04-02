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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4560C43460
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8523761056
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 02:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhDBCuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 22:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBCuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 22:50:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74CFC0613E6;
        Thu,  1 Apr 2021 19:50:11 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so5586332pjb.1;
        Thu, 01 Apr 2021 19:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Dz7TFO7VKRwo753YhMjXp+HkF5/PNhyeGUj25h3YhY=;
        b=Q9ZVjEDTxl30ZQlFSpIhHsOzZ0/JeoESmXhEwD+gjeVzjGZQuKWLpQPIgm2/h30u2I
         Y3IG0LjNExAFjGcjo1PXZYAAvz99UL2q03VnmnSpBM396oapPrsAcMbB07DKd92FsbTV
         OZXwb430zER/ZR3r7CPwNO3JVmFtzZbSC6FU0iCHWjSZQEd4lftZ7uExE/mn8/08H0fG
         JQlhhpbyG3qAfo06Z7zj8+KSegwupbRnGo/UNj6RItlDwPTQQ3ckQCgf+RrYX+l09CVT
         bdnEWxHkyOxDkGw3oNG+u1fOIaXcG3UBI+oa0OTHdHR3i5aqrhDutHKXOqdPysIgoALr
         3Pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Dz7TFO7VKRwo753YhMjXp+HkF5/PNhyeGUj25h3YhY=;
        b=q9OwSKbzxuEoLIrfpfuQTiG8eyQUnjT66MTEO3Ii8oHwgvSeih+XZRUFSn+sGN4Wo/
         6dH+6E9k9f2r+JVnqm9vBMiOJTzBZFLouAP+rdWVs1xrfSDZs1Ju9VM7PLdVKRfu1CYN
         HoxjGFhVAHYg6mai+nE9H/G6ZTvJKxZYiwnE4i5ieKjnegRkv4wyZqZ6NiUW6gtVCQJR
         eWgDwh5S/RULQiwYic+ZioSM+MRz9iOkWELJcp0YdcqWM7qFTFBiCOv2AxUvGH6OWBd8
         W8NuDk1gdyLVzmX9vwdp0nMPjg0oOthem6eqvMR6z08iEYsK+VFKNhRlZ7ZFGcdE+nna
         MfQw==
X-Gm-Message-State: AOAM5332txC9TiTAsdhZgI+w7aeOKCGZ2QHu/4fElntySjYzoCUmdCQd
        bLp84Xozp2UTt4m1zjv7z1RDjwLS5h8=
X-Google-Smtp-Source: ABdhPJzpRu/+kNIgCOTHKabZcKZKTdg8vRfABdn3zSDfjFCNznO/53iUVcidautJH3SFejUIwQchKg==
X-Received: by 2002:a17:902:c945:b029:e7:1ec4:4315 with SMTP id i5-20020a170902c945b02900e71ec44315mr10543993pla.51.1617331811169;
        Thu, 01 Apr 2021 19:50:11 -0700 (PDT)
Received: from localhost.localdomain ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id i14sm6720796pjh.17.2021.04.01.19.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 19:50:10 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V2 2/2] fstests: Fix tests to execute in multi-block directory config
Date:   Fri,  2 Apr 2021 08:19:40 +0530
Message-Id: <20210402024940.7689-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210402024940.7689-1-chandanrlinux@gmail.com>
References: <20210402024940.7689-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/{529,531,532,534,535} attempt to create test files after injecting
reduce_max_iextents error tag. Creation of test files fails when using a
multi-block directory test configuration because,

1. A directory can have a pseudo maximum extent count of 10.
2. In the worst case a directory entry creation operation can consume
   (XFS_DA_NODE_MAXDEPTH + 1 + 1) * (Nr fs blocks in a single directory block)
   extents.
   With 1k fs block size and 4k directory block size, this evaluates to,
   (5 + 1 + 1) * 4
   = 7 * 4
   = 28
   > 10 (Pseudo maximum inode extent count).

This commit fixes the issue by creating test files before injecting
reduce_max_iextents error tag.

Reported-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/529     | 24 +++++++++++++++++++++---
 tests/xfs/529.out |  6 +++++-
 tests/xfs/531     | 11 ++++++++---
 tests/xfs/531.out |  9 ++++++++-
 tests/xfs/532     | 17 ++++++++++-------
 tests/xfs/532.out |  6 +++---
 tests/xfs/534     |  9 ++++++---
 tests/xfs/534.out |  5 ++++-
 tests/xfs/535     | 11 +++++++++++
 tests/xfs/535.out |  2 ++
 10 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/tests/xfs/529 b/tests/xfs/529
index abe5b1e0..b4533eba 100755
--- a/tests/xfs/529
+++ b/tests/xfs/529
@@ -54,6 +54,8 @@ echo "* Delalloc to written extent conversion"
 
 testfile=$SCRATCH_MNT/testfile
 
+touch $testfile
+
 echo "Inject reduce_max_iextents error tag"
 _scratch_inject_error reduce_max_iextents 1
 
@@ -74,10 +76,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 echo "* Fallocate unwritten extents"
 
+touch $testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Fallocate fragmented file"
 for i in $(seq 0 2 $((nr_blks - 1))); do
 	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
@@ -93,10 +103,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 echo "* Directio write"
 
+touch $testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Create fragmented file via directio writes"
 for i in $(seq 0 2 $((nr_blks - 1))); do
 	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
@@ -112,15 +130,15 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $testfile
 
 # Check if XFS gracefully returns with an error code when we try to increase
 # extent count of user quota inode beyond the pseudo max extent count limit.
 echo "* Extend quota inodes"
 
-echo "Disable reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 0
-
 echo "Consume free space"
 fillerdir=$SCRATCH_MNT/fillerdir
 nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
diff --git a/tests/xfs/529.out b/tests/xfs/529.out
index b2ae3f42..13489d34 100644
--- a/tests/xfs/529.out
+++ b/tests/xfs/529.out
@@ -4,14 +4,18 @@ Format and mount fs
 Inject reduce_max_iextents error tag
 Create fragmented file
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Fallocate unwritten extents
+Inject reduce_max_iextents error tag
 Fallocate fragmented file
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Directio write
+Inject reduce_max_iextents error tag
 Create fragmented file via directio writes
 Verify $testfile's extent count
-* Extend quota inodes
 Disable reduce_max_iextents error tag
+* Extend quota inodes
 Consume free space
 Create fragmented filesystem
 Inject reduce_max_iextents error tag
diff --git a/tests/xfs/531 b/tests/xfs/531
index caec7848..935c52b0 100755
--- a/tests/xfs/531
+++ b/tests/xfs/531
@@ -49,13 +49,15 @@ nr_blks=30
 
 testfile=$SCRATCH_MNT/testfile
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 for op in fpunch finsert fcollapse fzero; do
 	echo "* $op regular file"
 
 	echo "Create \$testfile"
+	touch $testfile
+
+	echo "Inject reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 1
+
 	$XFS_IO_PROG -f -s \
 		     -c "pwrite -b $((nr_blks * bsize)) 0 $((nr_blks * bsize))" \
 		     $testfile  >> $seqres.full
@@ -75,6 +77,9 @@ for op in fpunch finsert fcollapse fzero; do
 		exit 1
 	fi
 
+	echo "Disable reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 0
+
 	rm $testfile
 done
 
diff --git a/tests/xfs/531.out b/tests/xfs/531.out
index f85776c9..6ac90787 100644
--- a/tests/xfs/531.out
+++ b/tests/xfs/531.out
@@ -1,19 +1,26 @@
 QA output created by 531
 Format and mount fs
-Inject reduce_max_iextents error tag
 * fpunch regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fpunch alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * finsert regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 finsert alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * fcollapse regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fcollapse alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * fzero regular file
 Create $testfile
+Inject reduce_max_iextents error tag
 fzero alternating blocks
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
diff --git a/tests/xfs/532 b/tests/xfs/532
index 1c789217..2bed574a 100755
--- a/tests/xfs/532
+++ b/tests/xfs/532
@@ -63,9 +63,6 @@ for dentry in $(ls -1 $fillerdir/); do
 	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
 done
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 echo "Inject bmap_alloc_minlen_extent error tag"
 _scratch_inject_error bmap_alloc_minlen_extent 1
 
@@ -74,6 +71,9 @@ echo "* Set xattrs"
 echo "Create \$testfile"
 touch $testfile
 
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Create xattrs"
 nr_attrs=$((bsize * 20 / attr_len))
 for i in $(seq 1 $nr_attrs); do
@@ -90,6 +90,9 @@ if (( $naextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 echo "Remove \$testfile"
 rm $testfile
 
@@ -98,9 +101,6 @@ echo "* Remove xattrs"
 echo "Create \$testfile"
 touch $testfile
 
-echo "Disable reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 0
-
 echo "Create initial xattr extents"
 
 naextents=0
@@ -132,7 +132,10 @@ if [[ $? == 0 ]]; then
 	exit 1
 fi
 
-rm $testfile && echo "Successfully removed \$testfile"
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+rm $testfile
 
 # success, all done
 status=0
diff --git a/tests/xfs/532.out b/tests/xfs/532.out
index 8e19d7bc..db52108f 100644
--- a/tests/xfs/532.out
+++ b/tests/xfs/532.out
@@ -2,17 +2,17 @@ QA output created by 532
 Format and mount fs
 Consume free space
 Create fragmented filesystem
-Inject reduce_max_iextents error tag
 Inject bmap_alloc_minlen_extent error tag
 * Set xattrs
 Create $testfile
+Inject reduce_max_iextents error tag
 Create xattrs
 Verify $testfile's naextent count
+Disable reduce_max_iextents error tag
 Remove $testfile
 * Remove xattrs
 Create $testfile
-Disable reduce_max_iextents error tag
 Create initial xattr extents
 Inject reduce_max_iextents error tag
 Remove xattr to trigger -EFBIG
-Successfully removed $testfile
+Disable reduce_max_iextents error tag
diff --git a/tests/xfs/534 b/tests/xfs/534
index a8348526..338282ef 100755
--- a/tests/xfs/534
+++ b/tests/xfs/534
@@ -45,9 +45,6 @@ bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 testfile=${SCRATCH_MNT}/testfile
 
-echo "Inject reduce_max_iextents error tag"
-_scratch_inject_error reduce_max_iextents 1
-
 nr_blks=15
 
 for io in Buffered Direct; do
@@ -62,6 +59,9 @@ for io in Buffered Direct; do
 		xfs_io_flag="-d"
 	fi
 
+	echo "Inject reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 1
+
 	echo "$io write to every other block of fallocated space"
 	for i in $(seq 1 2 $((nr_blks - 1))); do
 		$XFS_IO_PROG -f -s $xfs_io_flag -c "pwrite $((i * bsize)) $bsize" \
@@ -76,6 +76,9 @@ for io in Buffered Direct; do
 		exit 1
 	fi
 
+	echo "Disable reduce_max_iextents error tag"
+	_scratch_inject_error reduce_max_iextents 0
+
 	rm $testfile
 done
 
diff --git a/tests/xfs/534.out b/tests/xfs/534.out
index f7c0821b..0a0cd3a6 100644
--- a/tests/xfs/534.out
+++ b/tests/xfs/534.out
@@ -1,11 +1,14 @@
 QA output created by 534
 Format and mount fs
-Inject reduce_max_iextents error tag
 * Buffered write to unwritten extent
 Fallocate 15 blocks
+Inject reduce_max_iextents error tag
 Buffered write to every other block of fallocated space
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
 * Direct write to unwritten extent
 Fallocate 15 blocks
+Inject reduce_max_iextents error tag
 Direct write to every other block of fallocated space
 Verify $testfile's extent count
+Disable reduce_max_iextents error tag
diff --git a/tests/xfs/535 b/tests/xfs/535
index 2d82624c..f2a8a3a5 100755
--- a/tests/xfs/535
+++ b/tests/xfs/535
@@ -51,6 +51,9 @@ nr_blks=15
 srcfile=${SCRATCH_MNT}/srcfile
 dstfile=${SCRATCH_MNT}/dstfile
 
+touch $srcfile
+touch $dstfile
+
 echo "Inject reduce_max_iextents error tag"
 _scratch_inject_error reduce_max_iextents 1
 
@@ -77,10 +80,18 @@ if (( $nextents > 10 )); then
 	exit 1
 fi
 
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
 rm $dstfile
 
 echo "* Funshare shared extent"
 
+touch $dstfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
 echo "Share the extent with \$dstfile"
 _reflink $srcfile $dstfile >> $seqres.full
 
diff --git a/tests/xfs/535.out b/tests/xfs/535.out
index 4383e921..8f600272 100644
--- a/tests/xfs/535.out
+++ b/tests/xfs/535.out
@@ -6,7 +6,9 @@ Create a $srcfile having an extent of length 15 blocks
 Share the extent with $dstfile
 Buffered write to every other block of $dstfile's shared extent
 Verify $dstfile's extent count
+Disable reduce_max_iextents error tag
 * Funshare shared extent
+Inject reduce_max_iextents error tag
 Share the extent with $dstfile
 Funshare every other block of $dstfile's shared extent
 Verify $dstfile's extent count
-- 
2.29.2

