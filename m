Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877F2C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjEZCD6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEZCD5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:03:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D7FE7;
        Thu, 25 May 2023 19:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E97C619B3;
        Fri, 26 May 2023 02:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CE9C433EF;
        Fri, 26 May 2023 02:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066635;
        bh=5ojAQWLRuwMuldWRkPKiK/uQHSX78DhaKxe/Ap7vFKw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d0Ult23ESK/Y9gVoqqHF2egoMjlmiVcxTJlPzFu6hsEQRlBL4OWhJE8I5Q44pEGHa
         pXXvvwb4+8t1f7O8jloHrc6gXVwo08jx4dKBieOVUABs14ov6C54hZqB7GojJGikt0
         A7WGY28uhFZG+z20VRdz/5sgkhkqs4nlB2CRAi1RvmLKlAQRm8sXVI4LkN3dR+dyRx
         YNEly8ke0vBNMHNSAaFZGDp3x6um66MSecCtmly/NrgXVVpPyeWWIGz6wUvyWagVe2
         Z0XNsB2jN7wVSje/UBMQ8IMCn45Pzf0yHLrYtVeqjofewvUQEFV8P77I179sWcdqbJ
         6y75n1xlLkEMA==
Date:   Thu, 25 May 2023 19:03:55 -0700
Subject: [PATCH 07/11] xfs/306: fix formatting failures with parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060942.3732476.692396921947580410.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The parent pointers feature isn't supported on tiny 20MB filesystems
because the larger directory transactions result in larger minimum log
sizes, particularly with nrext64 enabled:

** mkfs failed with extra mkfs options added to " -m rmapbt=0, -i nrext64=1, -n parent=1," by test 306 **
** attempting to mkfs using only test 306 options: -d size=20m -n size=64k **
max log size 5108 smaller than min log size 5310, filesystem is too small

We don't support 20M filesystems anymore, so bump the filesystem size up
to 100M and skip this test if we can't actually format the filesystem.
Convert the open-coded punch-alternating logic into a call to that
program to reduce execve overhead, which more than makes up having to
write 5x as much data to fragment the free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/306 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/306 b/tests/xfs/306
index b57bf4c0a9..152971cfc3 100755
--- a/tests/xfs/306
+++ b/tests/xfs/306
@@ -23,6 +23,7 @@ _supported_fs xfs
 _require_scratch_nocheck	# check complains about single AG fs
 _require_xfs_io_command "fpunch"
 _require_command $UUIDGEN_PROG uuidgen
+_require_test_program "punch-alternating"
 
 # Disable the scratch rt device to avoid test failures relating to the rt
 # bitmap consuming all the free space in our small data device.
@@ -30,7 +31,8 @@ unset SCRATCH_RTDEV
 
 # Create a small fs with a large directory block size. We want to fill up the fs
 # quickly and then create multi-fsb dirblocks over fragmented free space.
-_scratch_mkfs_xfs -d size=20m -n size=64k >> $seqres.full 2>&1
+_scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1 || \
+	_notrun 'could not format tiny scratch fs'
 _scratch_mount
 
 # Fill a source directory with many largish-named files. 1k uuid-named entries
@@ -49,10 +51,7 @@ done
 $XFS_IO_PROG -xc "resblks 16" $SCRATCH_MNT >> $seqres.full 2>&1
 dd if=/dev/zero of=$SCRATCH_MNT/file bs=4k >> $seqres.full 2>&1
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/file >> $seqres.full 2>&1
-size=`_get_filesize $SCRATCH_MNT/file`
-for i in $(seq 0 8192 $size); do
-	$XFS_IO_PROG -c "fpunch $i 4k" $SCRATCH_MNT/file >> $seqres.full 2>&1
-done
+$here/src/punch-alternating $SCRATCH_MNT/file
 
 # Replicate the src dir several times into fragmented free space. After one or
 # two dirs, we should have nothing but non-contiguous directory blocks.

