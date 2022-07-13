Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDEBC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiGMA4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiGMA4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:56:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05F7BEB7D;
        Tue, 12 Jul 2022 17:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6718DB81C96;
        Wed, 13 Jul 2022 00:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDC5C341CD;
        Wed, 13 Jul 2022 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673800;
        bh=4yLkTCZuUD8YnUDO/9KwtbG8mW2hC6J6lAjw/ypiQOI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GrT4lu5UGVUOZXh/MHvPdxBcDXjl8QAD1EnwsJRFsrJx9bBHH3xR3wFJUAv1dWMRt
         mWiWPLaqDGK4Y8Hf29FA7uy+Bq9KX5HC7BqpNcXInRfr0onY70B3zTyZgIxz4KtcS/
         lqq5iosvs8/GCHdyCF/FHHa+CsSBROuR2oPFezulSRkelZlZquEqdylJtDGxKAMPgi
         UtRBnTS734Th6h2HlfLQqNXMdnu24E2eeWPdOsObf36Dk3kFOz8/E/jLsiVczo5gO4
         agK/ilkKGO/KxWg4zf/W+NKbLUJ0va/5LvCvk4ZXPaGhCHWvrA1kGat0XK7GITCte+
         7g5/pcH2u+Y4w==
Subject: [PATCH 1/8] misc: use _get_file_block_size for block (re)mapping
 tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:56:39 -0700
Message-ID: <165767379972.869123.2310819795149500736.stgit@magnolia>
In-Reply-To: <165767379401.869123.10167117467658302048.stgit@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Tests that exercise block remapping functionality such as reflink,
hole punching, fcollapse, and finsert all require the input parameters
to be aligned to allocation unit size for regular files.  This could be
different from the fundamental filesystem block size (think ext4
bigalloc or xfs realtime), so use the appropriate function here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc         |    2 +-
 tests/generic/017 |    2 +-
 tests/generic/064 |    2 +-
 tests/generic/158 |    2 +-
 tests/xfs/537     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/common/rc b/common/rc
index d5e6764c..5bac0355 100644
--- a/common/rc
+++ b/common/rc
@@ -2626,7 +2626,7 @@ _require_xfs_io_command()
 		param_checked="$param"
 		;;
 	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
-		local blocksize=$(_get_block_size $TEST_DIR)
+		local blocksize=$(_get_file_block_size $TEST_DIR)
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 $((5 * $blocksize))" \
 			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
 			$testfile 2>&1`
diff --git a/tests/generic/017 b/tests/generic/017
index 4b6acace..12c486d1 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -29,7 +29,7 @@ _scratch_mount
 testfile=$SCRATCH_MNT/$seq.$$
 BLOCKS=10240
 
-BSIZE=`_get_block_size $SCRATCH_MNT`
+BSIZE=`_get_file_block_size $SCRATCH_MNT`
 
 length=$(($BLOCKS * $BSIZE))
 
diff --git a/tests/generic/064 b/tests/generic/064
index b7d7fa4b..3b32fa1b 100755
--- a/tests/generic/064
+++ b/tests/generic/064
@@ -29,7 +29,7 @@ _scratch_mount
 src=$SCRATCH_MNT/testfile
 dest=$SCRATCH_MNT/testfile.dest
 BLOCKS=100
-BSIZE=`_get_block_size $SCRATCH_MNT`
+BSIZE=`_get_file_block_size $SCRATCH_MNT`
 length=$(($BLOCKS * $BSIZE))
 
 # Write file
diff --git a/tests/generic/158 b/tests/generic/158
index 649c75db..b9955265 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -38,7 +38,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(_get_block_size $testdir1)"
+blksz="$(_get_file_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/xfs/537 b/tests/xfs/537
index 7d7776f7..a31652cd 100755
--- a/tests/xfs/537
+++ b/tests/xfs/537
@@ -29,7 +29,7 @@ echo "Format and mount fs"
 _scratch_mkfs >> $seqres.full
 _scratch_mount >> $seqres.full
 
-bsize=$(_get_block_size $SCRATCH_MNT)
+bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 srcfile=${SCRATCH_MNT}/srcfile
 donorfile=${SCRATCH_MNT}/donorfile

