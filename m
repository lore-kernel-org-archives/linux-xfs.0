Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC350C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADB4D610A1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhESX6O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESX6N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5ED61007;
        Wed, 19 May 2021 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468613;
        bh=Jilndsq459/6kZq4Q3+F1Dh6m7zGawEGLy3rxXGfD9Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kHok4PUFeAKTy3nLH4EQWeMOC2RDnxVDdceZ+wF1FM0seT7AcfG+WzdCLXywGU3yo
         IAtwnbBDyprcYvIsJjXMxsYMxj8Mzr7nR6rtEK64sfZ0SIxPWRCc9JExgfmBf9QgFB
         5rvuADDD25XKmPkR33Ez82fMPaA3tcScArhLV0Y8HZTbIYKYqbfcLB1RvghUhnuoR2
         H1oV1pSTNyuad6U+KEXP3pR6FrRNuUdlf6d7QMulgaa6Rw7Lwy6fi0MEKNFvLORimB
         4o0XPsZGDUx1ynqwBX02USk9VxBchKuXsqSzx41c2scKbYWEXfJpYVVEU7Ovve4ugS
         3AoIOWgkaZmLA==
Subject: [PATCH 2/6] xfs: force file creation to the data device for certain
 layout tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:56:52 -0700
Message-ID: <162146861270.2500122.8499973348974838405.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I found a bunch more tests in the xfs/ directory that try to create
specific metadata layouts on the data device, either because they're
fuzz tests or because they're testing specific edge cases of the code
base.  Either way, these test need to override '-d rtinherit' in the
MKFS_OPTIONS, so do that with _xfs_force_bdev.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/088 |    1 +
 tests/xfs/089 |    1 +
 tests/xfs/091 |    1 +
 tests/xfs/120 |    1 +
 tests/xfs/130 |    1 +
 tests/xfs/139 |    2 ++
 tests/xfs/207 |    1 +
 tests/xfs/229 |    1 +
 tests/xfs/235 |    1 +
 9 files changed, 10 insertions(+)


diff --git a/tests/xfs/088 b/tests/xfs/088
index 6c5cbec8..b3e65dcf 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 mkdir -p "${TESTDIR}"
diff --git a/tests/xfs/089 b/tests/xfs/089
index 2892ad9e..21380798 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 mkdir -p "${TESTDIR}"
diff --git a/tests/xfs/091 b/tests/xfs/091
index 04322cec..ff8f0f1f 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 mkdir -p "${TESTDIR}"
diff --git a/tests/xfs/120 b/tests/xfs/120
index e66bc763..f5eb14cc 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -47,6 +47,7 @@ echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 nr="$((blksz * 2 / 16))"
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 $XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full
diff --git a/tests/xfs/130 b/tests/xfs/130
index 3071eace..6f6e8512 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -43,6 +43,7 @@ echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
diff --git a/tests/xfs/139 b/tests/xfs/139
index 1444444d..58b71711 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -38,12 +38,14 @@ rm -f $seqres.full
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
+_xfs_force_bdev data $SCRATCH_MNT
 blksz=$(_get_file_block_size $SCRATCH_MNT)
 _scratch_unmount
 
 echo "Format and mount"
 _scratch_mkfs -d agsize=$((16384 * $blksz)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_xfs_force_bdev data $SCRATCH_MNT
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
diff --git a/tests/xfs/207 b/tests/xfs/207
index f703c0dc..f0f30754 100755
--- a/tests/xfs/207
+++ b/tests/xfs/207
@@ -50,6 +50,7 @@ rm -f $seqres.full
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_xfs_force_bdev data $SCRATCH_MNT
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
diff --git a/tests/xfs/229 b/tests/xfs/229
index e723b10b..64851557 100755
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -38,6 +38,7 @@ _require_fs_space $TEST_DIR 3200000
 TDIR="${TEST_DIR}/t_holes"
 NFILES="10"
 EXTSIZE="256k"
+_xfs_force_bdev data $TEST_DIR
 
 # Create the test directory
 mkdir ${TDIR}
diff --git a/tests/xfs/235 b/tests/xfs/235
index a2ab9e55..55f5c5a6 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -41,6 +41,7 @@ echo "+ mount fs image"
 _scratch_mount
 blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
 agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+_xfs_force_bdev data $SCRATCH_MNT
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full

