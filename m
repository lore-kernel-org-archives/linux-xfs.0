Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413A4C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236326AbiLaDPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbiLaDPM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:15:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874811104;
        Fri, 30 Dec 2022 19:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FE461D12;
        Sat, 31 Dec 2022 03:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C15DC433EF;
        Sat, 31 Dec 2022 03:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456510;
        bh=IfjQZHXjRIiqHQ3FFzV1RNJqYfT5tIMuzLDYlQRjQf0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eRu/8RE9NcCcWjswP/9f7JWEFfo0ZSQ4powzCrMapzFcOIcGOnVVL9mifXO/jfWUp
         5kZHLbGCMOO+tuIbrMLxhIkOfRZEi3hmVNp8uz3XcLzx5rCaAloYCSgIQCIIFwd7Kc
         h1ns5T+zPavYYdd7z1H6EPP3iCUmGIAAbJ6C2oJplK8R3JXfY8hY/5HneWspYlYLRr
         J1o/3tnG/rA6rpjXYAMKx7vFIRUjUaEGStxNU89JY37HbMbVpM1PM/A83oaSBgLMpv
         jCHnwz7OoTosQaQ1GiQut7o6Ii6054pRu7CoQQ2Ik6MgU9XVO7NlAN4rdi2fa+E+jQ
         Eou/NzbrZNH/Q==
Subject: [PATCH 10/13] xfs/443: use file allocation unit, not dbsize
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884525.739669.1970186950244287006.stgit@magnolia>
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

We can only punch in units of file allocation boundaries, so update this
test to use that instead of the fs blocksize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/443 |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/443 b/tests/xfs/443
index 56828decae..ab3cda59f3 100755
--- a/tests/xfs/443
+++ b/tests/xfs/443
@@ -40,14 +40,15 @@ _scratch_mount
 
 file1=$SCRATCH_MNT/file1
 file2=$SCRATCH_MNT/file2
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
 
 # The goal is run an extent swap where one of the associated files has the
 # minimum number of extents to remain in btree format. First, create a couple
 # files with large enough extent counts (200 or so should be plenty) to ensure
 # btree format on the largest possible inode size filesystems.
-$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file1
+$XFS_IO_PROG -fc "falloc 0 $((400 * file_blksz))" $file1
 $here/src/punch-alternating $file1
-$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file2
+$XFS_IO_PROG -fc "falloc 0 $((400 * file_blksz))" $file2
 $here/src/punch-alternating $file2
 
 # Now run an extent swap at every possible extent count down to 0. Depending on
@@ -55,12 +56,12 @@ $here/src/punch-alternating $file2
 # btree format.
 for i in $(seq 1 2 399); do
 	# punch one extent from the tmpfile and swap
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 	$XFS_IO_PROG -c "swapext $file2" $file1
 
 	# punch the same extent from the old fork (now in file2) to resync the
 	# extent counts and repeat
-	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "fpunch $((i * file_blksz)) $file_blksz" $file2
 done
 
 # sanity check that no extents are left over

