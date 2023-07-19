Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EEBEB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjGSBKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjGSBKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:10:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61DF1722;
        Tue, 18 Jul 2023 18:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62ED06160B;
        Wed, 19 Jul 2023 01:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B852EC433C7;
        Wed, 19 Jul 2023 01:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689729047;
        bh=NZjD1+dDcLPciniNX3NNtnZR2Sp8KMIp/ZAmyrB3SlI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CcJrXewwkI9xxxkPqlI5ZZZ9J0t0jSh/zYemlzJqO0ZeuHwygpQwBZNfwt+KXhPuW
         CXhUHOlzBP6U877DPldSWTjYwg/nV7W6T304tWM8wrnZ3IxeIFmybFDSBe4RWGyvQl
         RmK4GeruzrQAwMPEOAFreOFuiKpOYhoBC7R6Gh49CalaDMCKSv74q0l6cN7a7+gGY6
         MAAhmM7zQf5uXdy4HrGmoTYdye3Oa0aNEKVnoUOZe2+UCqMylPFOKzcnTn0YHZZH0U
         sUo0bI5zXUF0oA0j0AqDEyrSdmcVkvohP4fU7MctvwrOlpGTL1pYzMN2VhXEyhTAeB
         //eT0RXNfYq5w==
Subject: [PATCH 1/1] generic/558: avoid forkbombs on filesystems with many
 free inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Bill O'Donnell <bodonnel@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Jul 2023 18:10:47 -0700
Message-ID: <168972904731.1698538.2489183241457829688.stgit@frogsfrogsfrogs>
In-Reply-To: <168972904158.1698538.17755661226352965399.stgit@frogsfrogsfrogs>
References: <168972904158.1698538.17755661226352965399.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Mikulas reported that this test became a forkbomb on his system when he
tested it with bcachefs.  Unlike XFS and ext4, which have large inodes
consuming hundreds of bytes, bcachefs has very tiny ones.  Therefore, it
reports a large number of free inodes on a freshly mounted 1GB fs (~15
million), which causes this test to try to create 15000 processes.

There's really no reason to do that -- all this test wanted to do was to
exhaust the number of inodes as quickly as possible using all available
CPUs, and then it ran xfs_repair to try to reproduce a bug.  Set the
number of subshells to 4x the CPU count and spread the work among them
instead of forking thousands of processes.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 tests/generic/558 |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)


diff --git a/tests/generic/558 b/tests/generic/558
index 4e22ce656b..510b06f281 100755
--- a/tests/generic/558
+++ b/tests/generic/558
@@ -19,9 +19,8 @@ create_file()
 	local prefix=$3
 	local i=0
 
-	while [ $i -lt $nr_file ]; do
+	for ((i = 0; i < nr_file; i++)); do
 		echo -n > $dir/${prefix}_${i}
-		let i=$i+1
 	done
 }
 
@@ -39,15 +38,25 @@ _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 i=0
-free_inode=`_get_free_inode $SCRATCH_MNT`
-file_per_dir=1000
-loop=$((free_inode / file_per_dir + 1))
+free_inodes=$(_get_free_inode $SCRATCH_MNT)
+# Round the number of inodes to create up to the nearest 1000, like the old
+# code did to make sure that we *cannot* allocate any more inodes at all.
+free_inodes=$(( ( (free_inodes + 999) / 1000) * 1000 ))
+nr_cpus=$(( $($here/src/feature -o) * 4 * LOAD_FACTOR ))
+echo "free inodes: $free_inodes nr_cpus: $nr_cpus" >> $seqres.full
+
+if ((free_inodes <= nr_cpus)); then
+	nr_cpus=1
+	files_per_dir=$free_inodes
+else
+	files_per_dir=$(( (free_inodes + nr_cpus - 1) / nr_cpus ))
+fi
 mkdir -p $SCRATCH_MNT/testdir
+echo "nr_cpus: $nr_cpus files_per_dir: $files_per_dir" >> $seqres.full
 
-echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
-while [ $i -lt $loop ]; do
-	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
-	let i=$i+1
+echo "Create $((nr_cpus * files_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
+for ((i = 0; i < nr_cpus; i++)); do
+	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
 done
 wait
 

