Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAF5C4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiK2WGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbiK2WGo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:06:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232AE70DF4
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2ABBB8197D
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 22:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECCEC433C1;
        Tue, 29 Nov 2022 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669759600;
        bh=uezY4FOEbt1loNWBXjL+9apwaRDEwm4Bp9yK/zlIuCY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=TBvE/CdhqD0K6khbP0nnQpccHRZl6LCVVUcBeL4ZLAvuwqY9nXjNJ/HJ7Wx+XMdmc
         TtbPv9HXtkCK71ioo7LcmbzUvrMHrdTCfk769oerx8Rl+fItt2LtmNZ/UP4reL86r+
         kXk6pL9A/U4KETARaA4bt/D3aEYYfNhusbB82P243Bc1/+189oN7DnWhyhTO5Q1ppA
         fV3QoaQCnYMenIC4P2vkGn67yivoaT1sdfuRINOo8ai3ZV/hkPn5WOLJYvAFUCE1hL
         D1ck+4FDh84Q+bODix9C3YoolVZkzhXziuchDFq2SF+sHVchp6qPTzdyWqR7rl1bqz
         NXdphFjqCgOGQ==
Date:   Tue, 29 Nov 2022 14:06:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [RFC PATCH] xfs/179: modify test to trigger refcount update bugs
Message-ID: <Y4aCb+y2ej1TBE/R@magnolia>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166975928548.3768925.15141817742859398250.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upon enabling fsdax + reflink for XFS, this test began to report
refcount metadata corruptions after being run.  Specifically, xfs_repair
noticed single-block refcount records that could be combined but had not
been.

The root cause of this is improper MAXREFCOUNT edge case handling in
xfs_refcount_merge_extents.  When we're trying to find candidates for a
record merge, we compute the refcount of the merged record, but without
accounting for the fact that once a record hits rc_refcount ==
MAXREFCOUNT, it is pinned that way forever.

Adjust this test to use a sub-filesize write for one of the COW writes,
because this is how we force the extent merge code to run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/179 |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/179 b/tests/xfs/179
index ec0cb7e5b4..214558f694 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -21,17 +21,28 @@ _require_scratch_nocheck
 _require_cp_reflink
 _require_test_program "punch-alternating"
 
+_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: estimate post-merge refcounts correctly"
+
 echo "Format and mount"
 _scratch_mkfs -d agcount=1 > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
+# This test modifies the refcount btree on the data device, so we must force
+# rtinherit off so that the test files are created there.
+_xfs_force_bdev data $SCRATCH_MNT
+
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
+# Set the file size to 10x the block size to guarantee that the COW writes will
+# touch multiple blocks and exercise the refcount extent merging code.  This is
+# necessary to catch a bug in the refcount extent merging code that handles
+# MAXREFCOUNT edge cases.
 blksz=65536
+filesz=$((blksz * 10))
 
 echo "Create original files"
-_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $filesz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 
 echo "Change reference count"
@@ -56,9 +67,20 @@ _scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "CoW a couple files"
-_pwrite_byte 0x62 0 $blksz $testdir/file3 >> $seqres.full
-_pwrite_byte 0x62 0 $blksz $testdir/file5 >> $seqres.full
+_pwrite_byte 0x62 0 $filesz $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $filesz $testdir/file5 >> $seqres.full
+
+# For the last COW test, write single blocks at the start, middle, and end of
+# the shared file to exercise a refcount btree update that targets a single
+# block of the multiblock refcount record that we just modified.
+#
+# This trips a bug where XFS didn't correctly identify refcount record merge
+# candidates when any of the records are pinned at MAXREFCOUNT.  The bug was
+# originally discovered by enabling fsdax + reflink, but the bug can be
+# triggered by any COW that doesn't target the entire extent.
 _pwrite_byte 0x62 0 $blksz $testdir/file7 >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 4)) $blksz $testdir/file7 >> $seqres.full
+_pwrite_byte 0x62 $((filesz - blksz)) $blksz $testdir/file7 >> $seqres.full
 
 echo "Check scratch fs"
 _scratch_unmount
