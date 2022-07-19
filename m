Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61699C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbiGSVhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiGSVhg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0080E5FAE0;
        Tue, 19 Jul 2022 14:37:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9093161A7B;
        Tue, 19 Jul 2022 21:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0874C341C6;
        Tue, 19 Jul 2022 21:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266653;
        bh=Bx7mvV59FAe6539ZFAHkv8Ze0ZKExewoBOQG4JOncsQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bASiTiRBbtl/h28+0s2ZivXDhkhaqSc1s7TGGeuYyDtj6eIsGqqKUGdNJiUXSi6n7
         tfOkUW+9ak7Qe06h/W2CEOZwFvfinl2k6qTKpurcEqDLa/wYwGACyrNtgirQAHJBe9
         /UxlpJ8rUFyThIM3jVroS7l9yp+BBFLWDAcVPKJsNFhTRz/087G+IgPTEBOTxsPJOk
         qCDpbaGHT/0LUh8vhevQnpwxfubKAKsPg4FiNmA7ONNpz+YBcJTc+tvOWF7qUXBWvl
         VJflbU1XSJQb2f4CaG19t1InF4iIX8h1niMw0DMiKTx1hOk9SJe1mNvEuOr/bKNf20
         IpHuX74MfKq9A==
Subject: [PATCH 3/8] misc: skip extent size hint tests when hint not congruent
 with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:33 -0700
Message-ID: <165826665344.3249494.3716007377375479796.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS files have an extent size hint, which tells the block allocator that
it should try to allocate larger aligned blocks when possible.  These
hints must be some integer multiple of the allocation unit size, which
is one fs block for files on the data device, and one rt extent for
files on the realtime device.  For tests that are hardwired to a static
extent size hint, the fssetxattr call will fail if the hint isn't
congruent, so just skip those tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/069 |    1 +
 tests/xfs/180 |    1 +
 tests/xfs/182 |    1 +
 tests/xfs/184 |    1 +
 tests/xfs/192 |    1 +
 tests/xfs/193 |    1 +
 tests/xfs/198 |    1 +
 tests/xfs/200 |    1 +
 tests/xfs/204 |    1 +
 tests/xfs/209 |    1 +
 tests/xfs/211 |    1 +
 tests/xfs/231 |    1 +
 tests/xfs/232 |    1 +
 tests/xfs/237 |    1 +
 tests/xfs/239 |    1 +
 tests/xfs/240 |    1 +
 tests/xfs/241 |    1 +
 tests/xfs/326 |    1 +
 tests/xfs/346 |    1 +
 tests/xfs/347 |    1 +
 tests/xfs/507 |    3 +++
 21 files changed, 23 insertions(+)


diff --git a/tests/xfs/069 b/tests/xfs/069
index bf4aa202..b3074e25 100755
--- a/tests/xfs/069
+++ b/tests/xfs/069
@@ -22,6 +22,7 @@ _require_scratch
 
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 8388608
 
 small=$SCRATCH_MNT/small
 big=$SCRATCH_MNT/big
diff --git a/tests/xfs/180 b/tests/xfs/180
index 72a1b738..9b52f1ff 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -32,6 +32,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/182 b/tests/xfs/182
index ea565824..93852229 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -33,6 +33,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/184 b/tests/xfs/184
index 95250b29..2ca6528e 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -33,6 +33,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/192 b/tests/xfs/192
index 1eb9d52e..8329604d 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -34,6 +34,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/193 b/tests/xfs/193
index 1bc48610..18f2fc2f 100755
--- a/tests/xfs/193
+++ b/tests/xfs/193
@@ -31,6 +31,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/198 b/tests/xfs/198
index 0c650874..231e1c23 100755
--- a/tests/xfs/198
+++ b/tests/xfs/198
@@ -32,6 +32,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/200 b/tests/xfs/200
index 2324fbdb..435cd9b9 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -35,6 +35,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/204 b/tests/xfs/204
index 931be128..3f9b6dca 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -36,6 +36,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/209 b/tests/xfs/209
index 220ea31d..08ec87f5 100755
--- a/tests/xfs/209
+++ b/tests/xfs/209
@@ -23,6 +23,7 @@ _require_xfs_io_command "cowextsize"
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
diff --git a/tests/xfs/211 b/tests/xfs/211
index 05515041..b99871ba 100755
--- a/tests/xfs/211
+++ b/tests/xfs/211
@@ -33,6 +33,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=50000
 filesize=$((blksz * nr))
 bufnr=16
diff --git a/tests/xfs/231 b/tests/xfs/231
index 8155d0ab..fd7d7a85 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -45,6 +45,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 bufnr=2
diff --git a/tests/xfs/232 b/tests/xfs/232
index 06217466..0bf3bb75 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -46,6 +46,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=64
 filesize=$((blksz * nr))
 bufnr=2
diff --git a/tests/xfs/237 b/tests/xfs/237
index 34d54a6c..db235e05 100755
--- a/tests/xfs/237
+++ b/tests/xfs/237
@@ -46,6 +46,7 @@ bufsize=$((blksz * bufnr))
 alignment=`_min_dio_alignment $TEST_DEV`
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 echo "Create the original files"
 $XFS_IO_PROG -c "cowextsize $((bufsize * 2))" $testdir
diff --git a/tests/xfs/239 b/tests/xfs/239
index 5143cc2e..f04460bc 100755
--- a/tests/xfs/239
+++ b/tests/xfs/239
@@ -35,6 +35,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=640
 bufnr=128
 filesize=$((blksz * nr))
diff --git a/tests/xfs/240 b/tests/xfs/240
index e5d35a83..a65c270d 100755
--- a/tests/xfs/240
+++ b/tests/xfs/240
@@ -40,6 +40,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=640
 bufnr=128
 filesize=$((blksz * nr))
diff --git a/tests/xfs/241 b/tests/xfs/241
index 7988c2d8..d9879788 100755
--- a/tests/xfs/241
+++ b/tests/xfs/241
@@ -36,6 +36,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=640
 bufnr=128
 filesize=$((blksz * nr))
diff --git a/tests/xfs/326 b/tests/xfs/326
index 8b95a18a..d8a9ac25 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -40,6 +40,7 @@ echo "Format filesystem"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 $XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
 
 echo "Create files"
diff --git a/tests/xfs/346 b/tests/xfs/346
index bb542202..6d371342 100755
--- a/tests/xfs/346
+++ b/tests/xfs/346
@@ -34,6 +34,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=8
diff --git a/tests/xfs/347 b/tests/xfs/347
index 63ee1ec6..86f405b5 100755
--- a/tests/xfs/347
+++ b/tests/xfs/347
@@ -33,6 +33,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 blksz=65536
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
 nr=128
 filesize=$((blksz * nr))
 bufnr=8
diff --git a/tests/xfs/507 b/tests/xfs/507
index b9c9ab29..8757152e 100755
--- a/tests/xfs/507
+++ b/tests/xfs/507
@@ -44,6 +44,9 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
+fs_blksz=$(_get_block_size $SCRATCH_MNT)
+_require_congruent_file_oplen $SCRATCH_MNT $((MAXEXTLEN * fs_blksz))
+
 # Create a huge sparse filesystem on the scratch device because that's what
 # we're going to need to guarantee that we have enough blocks to overflow in
 # the first place.  We need to have at least enough free space on that huge fs

