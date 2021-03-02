Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BD7C28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C406601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350385AbhCCDQU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361110AbhCBXX0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 18:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90CDB64F39;
        Tue,  2 Mar 2021 23:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614727365;
        bh=2oyFzPf7zo59T6UmCeDEbgc4XUptJkxuMlmAGUT1Vow=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WVSimCf0ZriWxsnfww0hdphD94mgkJPmqAzRKe75xKQBz+idQArhZ3Ul7LstTyzMa
         BedsTZmh84tgE9LQRfvM2j+0Wvc7d6RjxuT183MzE1uEMro7NhTwW/T9dUJjVE8xEi
         e/ZfbzCRfnuNtu1UuErP9/9DuCUjf3jEJE7I449Ox4fCIH/OgkL1a4vnVibBwAsUdr
         7vl6RSUcrljJYwtou5hyyngrKFUM+K+csNmLB7klb2gXlzQaj+jFZhnLWOU/MsvZMO
         yj/u+dfVcO4SalEe2bve+ucbcKhGbQHS9tGA1Z8AIMn5DqvHJEvf1W+VWquayJ4SLR
         awXRMLKjGRPGA==
Subject: [PATCH 2/4] xfs/271: fix test failure on non-reflink filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Mar 2021 15:22:45 -0800
Message-ID: <161472736521.3478298.1405183245326186350.stgit@magnolia>
In-Reply-To: <161472735404.3478298.8179031068431918520.stgit@magnolia>
References: <161472735404.3478298.8179031068431918520.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test creates an empty filesystem with rmap btrees enabled, and then
checks that GETFSMAP corresponds (roughly) with what we expect mkfs to
have written to the filesystem.

Unfortunately, the test's calculation for the number of "per-AG
metadata" extents is not quite correct.  For a filesystem with a
refcount btree, the rmapbt and agfl blocks will be reported separately,
but for non-reflink filesystems, GETFSMAP merges the records.

Since this test counts the number of records, fix the calculation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/271 |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/271 b/tests/xfs/271
index 48a3eb8f..35c23b84 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -38,6 +38,16 @@ _scratch_mount
 
 agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 
+# mkfs lays out btree root blocks in the order bnobt, cntbt, inobt, finobt,
+# rmapbt, refcountbt, and then allocates AGFL blocks.  Since GETFSMAP has the
+# same owner (per-AG metadata) for rmap btree blocks and blocks on the AGFL and
+# the reverse mapping index merges records, the number of per-AG extents
+# reported will vary depending on whether the refcount btree is enabled.
+$XFS_INFO_PROG $SCRATCH_MNT | grep -q reflink=1
+has_reflink=$(( 1 - $? ))
+perag_metadata_exts=2
+test $has_reflink -gt 0 && perag_metadata_exts=$((perag_metadata_exts + 1))
+
 echo "Get fsmap" | tee -a $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
 cat $TEST_DIR/fsmap >> $seqres.full
@@ -48,7 +58,7 @@ _within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
 
 echo "Check freesp/rmap btrees" | tee -a $seqres.full
 grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
-_within_tolerance "freesp extent count" $(wc -l < $TEST_DIR/testout) $((agcount * 3)) 0 999999 -v
+_within_tolerance "freesp extent count" $(wc -l < $TEST_DIR/testout) $((agcount * perag_metadata_exts)) 0 999999 -v
 
 echo "Check inode btrees" | tee -a $seqres.full
 grep 'inode btree[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout

