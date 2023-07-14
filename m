Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF09EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbjGNO7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 10:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235487AbjGNO7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4067B1BD4;
        Fri, 14 Jul 2023 07:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C943C61D30;
        Fri, 14 Jul 2023 14:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34028C433C7;
        Fri, 14 Jul 2023 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689346741;
        bh=sg7dpAD52hyQDuvt6ClLCF3EucG5i+H+XM/TjFOOmq8=;
        h=Date:From:To:Cc:Subject:From;
        b=JlPZcAjL2rMR3MvlfxlhuSA3zY8rc04u8dkXbAe74WdB9vW20cs9DQQazSXlJDQHa
         psLMGiFfn5AMjajBUYZJrtn7WPL0YmXa1Yf6094o6Tf0aOFe7TET4y+CpejKKaNplJ
         e0yeXKE25UyVzE8vILGLZd+pgCpjPV44SKO1jZ0nJrG32UgtVINVFbBtO5Pr+wOOpX
         aBixWYARRZRhQAI5w1+iwvuKZut7Pt5Gq5tgXPM/WRld2tL/tNQOFT3ttJs0CeA8xQ
         A0C1Tz7ylDYiDd0prENHnk3iybhcL9q4y+WMOcmfggJeeDO67qTBx1UYFQtYhnBuVc
         1MS1O42xNJTow==
Date:   Fri, 14 Jul 2023 07:59:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        mpatocka@redhat.com
Subject: [PATCH] generic/558: avoid forkbombs on filesystems with many free
 inodes
Message-ID: <20230714145900.GM11442@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
---
 tests/generic/558 |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tests/generic/558 b/tests/generic/558
index 4e22ce656b..de5c28d00d 100755
--- a/tests/generic/558
+++ b/tests/generic/558
@@ -39,15 +39,21 @@ _scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 i=0
-free_inode=`_get_free_inode $SCRATCH_MNT`
-file_per_dir=1000
-loop=$((free_inode / file_per_dir + 1))
+free_inodes=$(_get_free_inode $SCRATCH_MNT)
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
 
 echo "Create $((loop * file_per_dir)) files in $SCRATCH_MNT/testdir" >>$seqres.full
-while [ $i -lt $loop ]; do
-	create_file $SCRATCH_MNT/testdir $file_per_dir $i >>$seqres.full 2>&1 &
-	let i=$i+1
+for ((i = 0; i < nr_cpus; i++)); do
+	create_file $SCRATCH_MNT/testdir $files_per_dir $i >>$seqres.full 2>&1 &
 done
 wait
 
