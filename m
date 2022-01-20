Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97DDC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357920AbiATAtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:49:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47480 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357980AbiATAtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:49:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0040361529;
        Thu, 20 Jan 2022 00:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD6C004E1;
        Thu, 20 Jan 2022 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642639784;
        bh=nmWTlKQBQfT3gKCNY9A5s22AhfewmRLot2G8joSGE60=;
        h=Date:From:To:Cc:Subject:From;
        b=nZQCYbeX5WD6XVqSB7hrnGIEmOd25Vihjsw/zlpGGgk8cMp5ZayiZWNHyNwQKP5Hj
         DGeRV0Fi8q7RDm7O6s2DqWiF//2hlTMoi0SzL+tdlD5QK9c5sCMSJEdwf6pMVyUthm
         NAAFsdhEcNIlIOSZx7P8L1ToOaXDoWt4ABNh+s/Bf9NTxVmjRATZQxvJmx1RFuyWn4
         3xqPAvG4wj/gXAX8iv2ZJ//M9/pzPVFbGwbu96wTJxQnfHjeRWQhJ5JSSCHqcZfPFI
         2oSuQ1c5Sf347ohuXr+EpLMbxbMJm188ESgRpvAt1KcmD4Kb/CTGjrU7L46QDyKwbS
         /PIS3+1+KD/MQ==
Date:   Wed, 19 Jan 2022 16:49:44 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs/107: fix formatting failures
Message-ID: <20220120004944.GD13514@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zorro Lang reported that the _scratch_mkfs_sized call in the new xfs/107
fstest sometimes fails on more exotic storage due to insufficient log
size on account of raid stripes, etc.   These are side effects of the
filesystem being too small.

Change the filesystem size to 256M to avoid these problems, and change
the allocstale parameters to use the same file size (16M) as before.
Given that ALLOCSP produces stale disk contents pretty quickly this
shouldn't affect the test runtime too much.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/107 |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/107 b/tests/xfs/107
index 6034dbc2..577094b2 100755
--- a/tests/xfs/107
+++ b/tests/xfs/107
@@ -22,7 +22,10 @@ _require_test
 _require_scratch
 _require_test_program allocstale
 
-size_mb=32
+# Create a 256MB filesystem to avoid running into mkfs problems with too-small
+# filesystems.
+size_mb=256
+
 # Write a known pattern to the disk so that we can detect stale disk blocks
 # being mapped into the file.  In the test author's experience, the bug will
 # reproduce within the first 500KB's worth of ALLOCSP calls, so running up
@@ -39,9 +42,10 @@ _scratch_mount
 _xfs_force_bdev data $SCRATCH_MNT
 testfile=$SCRATCH_MNT/a
 
-# Allow the test program to expand the file to consume half the free space.
+# Allow the test program to expand the file to 32MB.  If we can't find any
+# stale blocks at that point, the kernel has probably been patched.
 blksz=$(_get_file_block_size $SCRATCH_MNT)
-iterations=$(( (size_mb / 2) * 1048576 / blksz))
+iterations=$(( (size_mb / 16) * 1048576 / blksz))
 echo "Setting up $iterations runs for block size $blksz" >> $seqres.full
 
 # Run reproducer program and dump file contents if we see stale data.  Full
