Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36E8C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbiGSVhs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbiGSVhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8907060508;
        Tue, 19 Jul 2022 14:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47CDEB81D77;
        Tue, 19 Jul 2022 21:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E590C341C6;
        Tue, 19 Jul 2022 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266665;
        bh=1Y1qpQbsvKLBcodXYYAlDUvKexMSvTqacgBkQr9XCfs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fw8V5gbrcU/mi8lkit1T2GQ0rCoLRt1Jh4nre3NIbHo0tE/WPhSqBDCDthEmM1XhQ
         FUgy7FLKpmXep2US15B1Bzl31glyK4RmNBaHMhiO+xm/squdE9L7pHnkuaBuuHwNYW
         SSbfITxAjg0bTV1u9wpOxsad9A0Ypit5ME258pM7IQQdZUNgR0IWj3tdVRbaxTIkEo
         iel4p/lDQdCJvvAk3kXl6K5+G83SgxFqi8iytqGYkO1N8+MgGr3iumez098rSo70oW
         IJO2Tkb8eMECT30SCJdEL7esQW72auRuroFzDEM3a3JD2NeA5ApOW3H32+iyMpb/tM
         FbNBP3ZTbie6A==
Subject: [PATCH 5/8] punch: use allocation unit to test punching holes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:44 -0700
Message-ID: <165826666462.3249494.17223784022585974750.stgit@magnolia>
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

