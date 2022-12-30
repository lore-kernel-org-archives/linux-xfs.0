Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB1AC4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbiLaDRv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiLaDRu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:17:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31582733;
        Fri, 30 Dec 2022 19:17:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F2662CE1AC6;
        Sat, 31 Dec 2022 03:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB8CC433D2;
        Sat, 31 Dec 2022 03:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456666;
        bh=ryjV8Jrw4OGG3FzNh3otD97RHKFVzbHCCZkGrrqFVx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hs2/8GNb5XasTY/GGfgZ7PU9UrYKoeok17Q8vHeOMYO0FlOQe8Wn3sfjLhujF1V/j
         X3KSDTl0dEXfAJHaDT/9oIN75hFA760D+vTM1yNtE+0JkvEQXF2f0i0uSzidqXgDnx
         4E6qC9xSsaUpMURPHBMs0XDENaMoNhsWaqTiANT0iedSkntEXQpT+yz8swXkGQ15di
         R4ZlSzvoFC4b4nPM5rNhix3mu17OQiPJT9zIdqf/8dbmHTdjZZIhsXWlHV4m1hfDrt
         etpVU/Sspd4PzWaCoXbQX/GhigpZUKcZdsCNc5gZmJzbogprdFhfYps/q2tRnrbXek
         s9eie0EjkmIzQ==
Subject: [PATCH 07/10] xfs: remove xfs/131 now that we allow reflink on
 realtime volumes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884945.740253.13846905541104076494.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this test, since we now support reflink on the rt volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/131     |   48 ------------------------------------------------
 tests/xfs/131.out |    5 -----
 2 files changed, 53 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out


diff --git a/tests/xfs/131 b/tests/xfs/131
deleted file mode 100755
index 879e2dc6e8..0000000000
--- a/tests/xfs/131
+++ /dev/null
@@ -1,48 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# FS QA Test No. 131
-#
-# Ensure that we can't reflink realtime files.
-#
-. ./common/preamble
-_begin_fstest auto quick clone realtime
-
-# Override the default cleanup function.
-_cleanup()
-{
-    cd /
-    umount $SCRATCH_MNT > /dev/null 2>&1
-    rm -rf $tmp.* $testdir $metadump_file
-}
-
-# Import common functions.
-. ./common/filter
-. ./common/reflink
-
-# real QA test starts here
-_supported_fs xfs
-_require_realtime
-_require_scratch_reflink
-_require_cp_reflink
-
-echo "Format and mount scratch device"
-_scratch_mkfs >> $seqres.full
-_scratch_mount
-
-testdir=$SCRATCH_MNT/test-$seq
-mkdir $testdir
-
-echo "Create the original file blocks"
-blksz=65536
-$XFS_IO_PROG -R -f -c "truncate $blksz" $testdir/file1
-
-echo "Reflink every block"
-_cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
-
-test -s $testdir/file2 && _fail "Should not be able to reflink a realtime file."
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/131.out b/tests/xfs/131.out
deleted file mode 100644
index 3c0186f0c7..0000000000
--- a/tests/xfs/131.out
+++ /dev/null
@@ -1,5 +0,0 @@
-QA output created by 131
-Format and mount scratch device
-Create the original file blocks
-Reflink every block
-cp: failed to clone 'SCRATCH_MNT/test-131/file2' from 'SCRATCH_MNT/test-131/file1': Invalid argument

