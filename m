Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D14C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiGMA5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiGMA5Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:57:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD56CFB45;
        Tue, 12 Jul 2022 17:57:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E74AFCE1E6C;
        Wed, 13 Jul 2022 00:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AA1C3411C;
        Wed, 13 Jul 2022 00:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673839;
        bh=otszpbkt5MCfHJ2dlo5RCZS4p8Vr8QbdUokqGYpTQXM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DmUy7i2Q60/TJtwMSEEaTZCar+M0dvD52qMgUAGMDv1g3nQnRsJIjy39DDNTyduSM
         pYJvEgY69X6J/ngmRtxa4eGRnNZaN/S6D7FYFbJOwJ2KsczqJ3du91+9JZrwOjUgZo
         Wsd4AZ1iYbcw0w81xL4Ri7EnGrXZW5KN3/X0qTq6Yw6w9Xi26FFeuncAuJYids4ld6
         xSCilpAVx3etvX4ECJiO7PbhUXUgVBI+wV2w9y2t0wRKdfnUzMXTbyCwd8xyVq+/nS
         9OPwFBENtsf7hwfzkmbSVO4ZtEN0RpCFQTv8ikjeU0kEqFKLlNhIo49gRfA4yBCey/
         7/u6N69oEIXog==
Subject: [PATCH 8/8] punch: skip fpunch tests when page size not congruent
 with file allocation unit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:57:18 -0700
Message-ID: <165767383891.869123.11883992017076273427.stgit@magnolia>
In-Reply-To: <165767379401.869123.10167117467658302048.stgit@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Skip the generic fpunch tests on a file when the file's allocation unit
size is not congruent with the system page size.  This is needed for
testing swapfiles and mmap collisions wiht fallocate.

Assuming this edgecase configuration of an edgecase feature is
vanishingly rare, let's just _notrun the tests instead of rewriting a
ton of tests to do their integrity checking by hand.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/495 |    4 ++++
 tests/generic/503 |    4 ++++
 2 files changed, 8 insertions(+)


diff --git a/tests/generic/495 b/tests/generic/495
index 608f1715..5e03dfee 100755
--- a/tests/generic/495
+++ b/tests/generic/495
@@ -21,6 +21,10 @@ _require_sparse_files
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount
 
+blksize=$(_get_file_block_size $SCRATCH_MNT)
+test $blksize -eq $(getconf PAGE_SIZE) || \
+	_notrun "swap file allocation unit size must match page size"
+
 # We can't use _format_swapfile because we're using our custom mkswap and
 # swapon.
 touch "$SCRATCH_MNT/swap"
diff --git a/tests/generic/503 b/tests/generic/503
index a6971e63..ff3390bf 100755
--- a/tests/generic/503
+++ b/tests/generic/503
@@ -38,6 +38,10 @@ _scratch_mkfs >> $seqres.full 2>&1
 export MOUNT_OPTIONS=""
 _scratch_mount >> $seqres.full 2>&1
 
+blksize=$(_get_file_block_size $SCRATCH_MNT)
+test $blksize -eq $(getconf PAGE_SIZE) || \
+	_notrun "file block size must match page size"
+
 # real QA test starts here
 $here/src/t_mmap_collision $TEST_DIR/testfile $SCRATCH_MNT/testfile
 

