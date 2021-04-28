Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B424C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E031C6140C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhD1EKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhD1EKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3727613E5;
        Wed, 28 Apr 2021 04:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582975;
        bh=6hIuyo85Z4nQzhNB8HhnkzYlLYItwSiFRkjbw0/0LB0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nv/RbupAhxX4UFPnd5jeTgc2h2bPp7Ub6dCxN2+uvdDGVyIArWe7K49gUi34ykx1r
         2chBf0tiwTzLaRPvcOJpyOuL1lMxYGdl8ie9FKZWLGNVKDVEW8WfpdGAzwHYYo0DjU
         SIPmeFFl1mQK3IFLmO4I5vQgvutVRDB62oHvEZCo50rHfr+3WooiSFaWAR/eZGKDRD
         zZXGg1s+D6e7N9Y/77fYYoMkqApuInwYeDPuIKElyA1ejwH+mfJ0HMppbU3gn3So6P
         4Fh1nH72Y1OTJeS4UTS1O216xfTv7Az+0HYftkpxS8rfr1TGMFF87x12eK3aEpN9Z/
         u+VdLxKedJPIw==
Subject: [PATCH 1/3] xfs/419: remove irrelevant swapfile test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:35 -0700
Message-ID: <161958297507.3452499.6111068461177037465.stgit@magnolia>
In-Reply-To: <161958296906.3452499.12678290296714187590.stgit@magnolia>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since the advent of iomap_swapfile_activate in XFS, we actually /do/
support having swap files on the realtime device.  Remove this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/419     |   58 -----------------------------------------------------
 tests/xfs/419.out |    5 -----
 tests/xfs/group   |    1 -
 3 files changed, 64 deletions(-)
 delete mode 100755 tests/xfs/419
 delete mode 100644 tests/xfs/419.out


diff --git a/tests/xfs/419 b/tests/xfs/419
deleted file mode 100755
index fc7174bd..00000000
--- a/tests/xfs/419
+++ /dev/null
@@ -1,58 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
-#
-# FS QA Test No. 419
-#
-# Check that we can't swapon a realtime file.
-#
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 7 15
-
-_cleanup()
-{
-	cd /
-	rm -rf $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# real QA test starts here
-_supported_fs xfs
-_require_realtime
-_require_scratch_swapfile
-
-echo "Format and mount"
-_scratch_mkfs > $seqres.full 2>&1
-_scratch_mount >> $seqres.full 2>&1
-
-testdir=$SCRATCH_MNT/test-$seq
-mkdir $testdir
-
-blocks=160
-blksz=65536
-
-echo "Initialize file"
-echo >> $seqres.full
-$XFS_IO_PROG -c "open -f -R $testdir/dummy" $testdir >> $seqres.full
-echo moo >> $testdir/dummy
-$XFS_IO_PROG -c "open -f -R $testdir/file1" $testdir >> $seqres.full
-_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
-$MKSWAP_PROG -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
-
-echo "Try to swapon"
-swapon $testdir/file1 2>&1 | _filter_scratch
-
-swapoff $testdir/file1 >> $seqres.full 2>&1
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/419.out b/tests/xfs/419.out
deleted file mode 100644
index 83b7dd45..00000000
--- a/tests/xfs/419.out
+++ /dev/null
@@ -1,5 +0,0 @@
-QA output created by 419
-Format and mount
-Initialize file
-Try to swapon
-swapon: SCRATCH_MNT/test-419/file1: swapon failed: Invalid argument
diff --git a/tests/xfs/group b/tests/xfs/group
index 76e31167..549209a4 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -407,7 +407,6 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
-419 auto quick swap realtime
 420 auto quick clone punch seek
 421 auto quick clone punch seek
 422 dangerous_scrub dangerous_online_repair

