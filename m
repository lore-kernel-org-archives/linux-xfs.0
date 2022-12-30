Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF14BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbiLaDOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiLaDO1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:14:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FAEE59;
        Fri, 30 Dec 2022 19:14:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A0FB81E5C;
        Sat, 31 Dec 2022 03:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EFBC433EF;
        Sat, 31 Dec 2022 03:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456463;
        bh=5tGYjlAVtTsCmR1z/8/XOITcG+nNZq/DfjTeq+f8+nc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pmSv/KwBUhYdRngWGImXGbMeTOlWzj1jLIornZCWEQF5iwHcZr2ZWZGCG+sb/Fzhg
         UYjiEW37zEJkVKJiz+lsC50ofcIR9e+NWSRU5wQHHWB45/yzBXiJnaZFvO16Vyu/bj
         YQyTPJgmWvcpWnQEcFR4HhcRc/7EfGjTN6KiaGOjTMEFKRy9pq0y5wR4SoOz59UGKb
         8tKQp9h7zR69iuoG3probEP0q9Zhq4t/5ROitx3zDRJ3Pp8dtMV4/4wpYpcjyFNMW7
         txRNK3OkGyvsTiIXqvh2zahrCv1lmaKcu1FzBIPoh2fYpqoovlz343hmGWse8SCmiI
         cxwwT7f5C/V9A==
Subject: [PATCH 07/13] xfs/341: update test for rtgroup-based rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884485.739669.4899909585795610128.stgit@magnolia>
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

Now that we're sharding the realtime volume into multiple allocation
groups, update this test to reflect the new reality.  The realtime rmap
btree record and key sizes have shrunk, and we can't guarantee that a
quick file write actually hits the same rt group as the one we fuzzed,
so eliminate the file write test since we're really only curious if
xfs_repair will fix the problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/341     |   10 +++-------
 tests/xfs/341.out |    1 -
 2 files changed, 3 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/341 b/tests/xfs/341
index 8861e751a9..561054f0bd 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -32,10 +32,10 @@ blksz="$(_get_block_size $SCRATCH_MNT)"
 rtextsz_blks=$((rtextsz / blksz))
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
-# rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
+# rtrmap record is 24 bytes; and rtrmap key/pointer are 48 bytes.
 i_core_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
-i_ptrs=$(( (isize - i_core_size) / 56 ))
-bt_recs=$(( (blksz - 56) / 32 ))
+i_ptrs=$(( (isize - i_core_size) / 48 ))
+bt_recs=$(( (blksz - 56) / 24 ))
 
 blocks=$((i_ptrs * bt_recs + 1))
 len=$((blocks * rtextsz))
@@ -57,10 +57,6 @@ _scratch_xfs_db -x -c 'path -m /realtime/0.rmap' \
 	-c "write u3.rtrmapbt.ptrs[1] $fsbno" -c 'p' >> $seqres.full
 _scratch_mount
 
-echo "Try to create more files"
-$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
-test -e $SCRATCH_MNT/f5 && echo "should not have been able to write f5"
-
 echo "Repair fs"
 _scratch_unmount 2>&1 | _filter_scratch
 _repair_scratch_fs >> $seqres.full 2>&1
diff --git a/tests/xfs/341.out b/tests/xfs/341.out
index 75a5bc6c61..580d788954 100644
--- a/tests/xfs/341.out
+++ b/tests/xfs/341.out
@@ -2,6 +2,5 @@ QA output created by 341
 Format and mount
 Create some files
 Corrupt fs
-Try to create more files
 Repair fs
 Try to create more files (again)

