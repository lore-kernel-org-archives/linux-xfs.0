Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369D0C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbiF1UZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiF1UYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC2C3981F;
        Tue, 28 Jun 2022 13:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7297B8203F;
        Tue, 28 Jun 2022 20:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D08C3411D;
        Tue, 28 Jun 2022 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447728;
        bh=F+r3GkLBuLofHc4DvTbyjiDKmp/Zv65CClZbMwTM4KQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=faEmLy7DoE67qnFrjc3mtJ1FTLuCfkeTEuIyKV88EhS6LVuS4ZqX0kyae4sAu6xpS
         UYHoNHGIIdacuVXj4D0o4Ne0NIAE6hgEUiQocUIiwKFEtHJ7R18hwHkOeuHPjs++k7
         d8fFibBhu43s+Pd0pdBrLOI3d/XUDyIYoMksMQXkve8kyoTyMbhGZdocx+k2+aePhn
         14CB8162dK4rvBqUswntaqaSXkx5RjeWyU3FTeM3or/OE3gavTkpYDZVm3L00P5PJF
         yW7QHmdve2+tSF8RyNelCAcy57VAbESWmdyVFXpMRiVGmNzzzQunkC1/eruPwEYf5z
         FsJzARO+dfidg==
Subject: [PATCH 9/9] xfs/547: fix problems with realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:22:08 -0700
Message-ID: <165644772810.1045534.14629047434325021582.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test needs to fragment the free space on the data device so that
each block added to the attr fork gets its own mapping.  If the test
configuration sets up a rt device and rtinherit=1 on the root dir, the
test will erroneously fragment space on the *realtime* volume.  When
this happens, attr fork allocations are contiguous and get merged into
fewer than 10 extents and the test fails.

Fix this test to force all allocations to be on the data device, and fix
incorrect variable usage in the error messages.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/547 |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/547 b/tests/xfs/547
index 9d4216ca..60121eb9 100755
--- a/tests/xfs/547
+++ b/tests/xfs/547
@@ -33,6 +33,10 @@ for nrext64 in 0 1; do
 		      >> $seqres.full
 	_scratch_mount >> $seqres.full
 
+	# Force data device extents so that we can fragment the free space
+	# and force attr fork allocations to be non-contiguous
+	_xfs_force_bdev data $SCRATCH_MNT
+
 	bsize=$(_get_file_block_size $SCRATCH_MNT)
 
 	testfile=$SCRATCH_MNT/testfile
@@ -76,13 +80,15 @@ for nrext64 in 0 1; do
 	acnt=$(_scratch_xfs_get_metadata_field core.naextents \
 					       "path /$(basename $testfile)")
 
-	if (( $dcnt != 10 )); then
-		echo "Invalid data fork extent count: $dextcnt"
+	echo "nrext64: $nrext64 dcnt: $dcnt acnt: $acnt" >> $seqres.full
+
+	if [ -z "$dcnt" ] || (( $dcnt != 10 )); then
+		echo "Invalid data fork extent count: $dcnt"
 		exit 1
 	fi
 
-	if (( $acnt < 10 )); then
-		echo "Invalid attr fork extent count: $aextcnt"
+	if [ -z "$acnt" ] || (( $acnt < 10 )); then
+		echo "Invalid attr fork extent count: $acnt"
 		exit 1
 	fi
 done

