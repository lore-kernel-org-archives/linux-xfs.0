Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B16DC636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBPVPN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPVPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:15:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E52448E22;
        Thu, 16 Feb 2023 13:15:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B2D5CE2D0F;
        Thu, 16 Feb 2023 21:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8442C433EF;
        Thu, 16 Feb 2023 21:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582108;
        bh=5ojAQWLRuwMuldWRkPKiK/uQHSX78DhaKxe/Ap7vFKw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IL096qX44RFD45v/aczOSsfyHv4Rn04TzX3pwRB6s8FT8i7xr+Q6UNd7ctAPR3S2Y
         bMFbmxYu7fJKFygjZIKrad/O3mnwEYi9Iz1hid5XG4hCAttGfaEsYG5KCEY/mcvpL5
         s4SLYklGQT+yIHqUtQ9XxbltdCu1Te5S6ojQdXQPzYWkCq1zXngwAMbTIKjQL4odqa
         5XIuERmjV2+qjHcx6HTWDTnEJq0QWXH2wbodl7hUgW5J55SsUlvz1xYy3uxOSoS75P
         Q+Ix6e+BNLNXnlTtbuEKlv7mOVK5vAAlxdMPqxWqOSuLOrcd5pSveeR2kefiXmvRKU
         MtBczF1w0agrQ==
Date:   Thu, 16 Feb 2023 13:15:08 -0800
Subject: [PATCH 06/14] xfs/306: fix formatting failures with parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884566.3481377.2303088177888217916.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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

