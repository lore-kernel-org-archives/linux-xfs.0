Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC6EC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiGMA5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGMA5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A1BC0526;
        Tue, 12 Jul 2022 17:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 321E76188A;
        Wed, 13 Jul 2022 00:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E209C3411E;
        Wed, 13 Jul 2022 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673822;
        bh=1Y1qpQbsvKLBcodXYYAlDUvKexMSvTqacgBkQr9XCfs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y69/O4nS1dbD7+RCkq6EmbH2exjm79zf2k6yUc4NDvGUpt4hMIvhXZquZzlTS4pbh
         PD4kY42Cvf3VIh/nO6Cnatkj8iQjS237eLx7GhQ3qcvuIuMSJyotRgSghX1ivCDO8U
         4l6MjuPjqjkt3m0oD60CPWGpBB8mif/smIKW3JYGGbRMvqdw8bh4LFXBFIorgmN6Tp
         jv8idYLvJ0Zumf5+jdPA2kjFr4K5flMIV+s3mQ5C5UrCTAuVdE4VEtc2uNZ4d9/6l2
         9erEXloM6vrK0p5OIRtON5F6WVOVifmkRUpH7snwKLfhMudmULNdqeWsaJn6o8iYGL
         hgLKYXJjItl5g==
Subject: [PATCH 5/8] punch: use allocation unit to test punching holes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:57:02 -0700
Message-ID: <165767382219.869123.10917801988659698881.stgit@magnolia>
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

In step 17 of _test_generic_punch, we want to test that we can write
a file with a single block, use one of unresvsp, fpunch, or fzero to
modify the file, and then check that the file has one written block
followed by a hole.

Unfortunately, the test helper uses _get_block_size to determine how
much data to write to the test file.  For filesystems with an allocation
unit size that is not the fs block size (e.g. XFS realtime with a rt
extent size), this produces unwritten extents in the fiemap output,
which causes test failures.

Fix step 17 to obtain the file allocation unit size with
_get_file_block_size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/punch      |    2 +-
 tests/generic/153 |    2 +-
 tests/generic/404 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/punch b/common/punch
index b6b8a0b9..4d16b898 100644
--- a/common/punch
+++ b/common/punch
@@ -480,7 +480,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	block_size=`_get_block_size $TEST_DIR`
+	block_size=`_get_file_block_size $TEST_DIR`
 	$XFS_IO_PROG -f -c "truncate $block_size" \
 		-c "pwrite 0 $block_size" $sync_cmd \
 		-c "$zero_cmd 128 128" \
diff --git a/tests/generic/153 b/tests/generic/153
index 40877266..342959fd 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -37,7 +37,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(_get_block_size $testdir)"
+blksz="$(_get_file_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/404 b/tests/generic/404
index 939692eb..30fce85d 100755
--- a/tests/generic/404
+++ b/tests/generic/404
@@ -69,7 +69,7 @@ _require_test
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "finsert"
 
-blksize=`_get_block_size $TEST_DIR`
+blksize=`_get_file_block_size $TEST_DIR`
 
 # Generate a block with a repeating number represented as 4 bytes decimal.
 # The test generates unique pattern for each block in order to observe a

