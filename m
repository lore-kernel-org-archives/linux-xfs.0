Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B847CC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbiGSVhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiGSVhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2F25F101;
        Tue, 19 Jul 2022 14:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34E4F61A81;
        Tue, 19 Jul 2022 21:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8D4C341C6;
        Tue, 19 Jul 2022 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266642;
        bh=gdbXzr0PoafnBvICyLgLWZ9+TQJjUuEVewzYjiAT6H4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tr98OiE4U93uAQ4ArHzVm1awFLmYsdqahqgtXyk3cHHe6ZdufUqwZpy6IoWga/1uR
         sJwLATXm3tOazR1mW+Z3f8UElLiCSis0dvXQLoZLWWoXQJ4VZo9RVxT+hyrcLNEgjr
         NjkTS/Mulatz/hNtIZ73JjHTgZT9feWU9U0h/3l8AXqZ98TGDyT1WrHC2NDgGTyRLc
         8ubpesN+cOcpisBpTi6S43gQf6ofIZXXarLHXX0suPrpOD5Y/KAtFFI1w6j/M/eN6F
         bQ47fD8k5RZmHcmsUbRaD7SgyNIM/7lAw0xQN5V/U8oPaaezo4lXfXt3E+VyODqhb9
         7ysY5rlvRnLAg==
Subject: [PATCH 1/8] misc: use _get_file_block_size for block (re)mapping
 tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:22 -0700
Message-ID: <165826664214.3249494.7493387996300273398.stgit@magnolia>
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

Tests that exercise block remapping functionality such as reflink,
hole punching, fcollapse, and finsert all require the input parameters
to be aligned to allocation unit size for regular files.  This could be
different from the fundamental filesystem block size (think ext4
bigalloc or xfs realtime), so use the appropriate function here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
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

