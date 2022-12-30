Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB51C53210
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiLaDPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236326AbiLaDOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:14:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09947E59;
        Fri, 30 Dec 2022 19:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B37EDB81E5D;
        Sat, 31 Dec 2022 03:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC41C433EF;
        Sat, 31 Dec 2022 03:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456479;
        bh=rZQRoAcAh/3zfW2Sh1mMP3nA4r5gUeCjbevpArYJvM4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NilYoXh3PhOAHkgVjcs4JtdwzG+ON5BSm/+lWETds0gP0JdwWeB6yH21OgiR8+fL6
         PK/iOTs1pU6y771OFkx3kvMMltD3p03XZeToiCoZlno4JRNvM/HTggT5kOMgVmvDOt
         c9v9mZOmtafGjxfk7o927Uy/yl7PpaGB3rXgVVeg0XZnAPzU9pCRUlZc0oEBRLdmRm
         +VdMpPDDJyBzCDF1AiRUFmHYZ0DUCrN2xt8ipVjEYrOTJyAEmuqJFrylWC4PvfLftd
         zkzQI3DtguqibOqnhx/y3Q9auv2olBilbWSkpkZAEjoio+q5moJpi3mEMMDsvwqqih
         Zu6Ye/AyY36lw==
Subject: [PATCH 08/13] xfs/3{43,32}: adapt tests for rt extent size greater
 than 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884498.739669.5577631514595742923.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Both of these tests for the realtime volume can fail when the rt extent
size is larger than a single block.

332 is a read-write functionality test that encodes md5sum in the
output, so we need to skip it if $blksz isn't congruent with the extent
size, because the fcollapse call will fail.

343 is a test of the rmap btree, so the fix here is simpler -- make
$blksz the file allocation unit, and get rid of the md5sum in the
golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/332     |    6 +-----
 tests/xfs/332.out |    2 --
 tests/xfs/343     |    2 ++
 3 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/tests/xfs/332 b/tests/xfs/332
index a2d37ee905..c1ac87adcb 100755
--- a/tests/xfs/332
+++ b/tests/xfs/332
@@ -28,7 +28,7 @@ rm -f "$seqres.full"
 echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz=65536
+blksz=$(_get_file_block_size $SCRATCH_MNT) # 65536
 blocks=16
 len=$((blocks * blksz))
 
@@ -45,10 +45,6 @@ $XFS_IO_PROG -c "fpunch $blksz $blksz" \
 	-c "fcollapse $((9 * blksz)) $blksz" \
 	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
 
-echo "Check file"
-md5sum $SCRATCH_MNT/f1 | _filter_scratch
-od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
-
 echo "Unmount"
 _scratch_unmount
 
diff --git a/tests/xfs/332.out b/tests/xfs/332.out
index 9beff7cc37..3a7ca95b40 100644
--- a/tests/xfs/332.out
+++ b/tests/xfs/332.out
@@ -2,8 +2,6 @@ QA output created by 332
 Format and mount
 Create some files
 Manipulate file
-Check file
-e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
 Unmount
 Try a regular fsmap
 Try a bad fsmap
diff --git a/tests/xfs/343 b/tests/xfs/343
index bffcc7d9ac..fe461847ed 100755
--- a/tests/xfs/343
+++ b/tests/xfs/343
@@ -31,6 +31,8 @@ blksz=65536
 blocks=16
 len=$((blocks * blksz))
 
+_require_congruent_file_oplen $SCRATCH_MNT $blksz
+
 echo "Create some files"
 $XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
 

