Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D340DEB64DD
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jul 2023 22:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjGIWhx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Jul 2023 18:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjGIWhx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2023 18:37:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3924C11C
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 15:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA8B860BEB
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 22:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1744EC433C8;
        Sun,  9 Jul 2023 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688942271;
        bh=NlyKmcJkFt3w9Y5cuUmp1nO3pfWfzYGP7AcceHI/D7Y=;
        h=Date:From:To:Cc:Subject:From;
        b=cueTusBBRZ24D5wt0CL1ZbbfWJdMszp+K/2EczIY75pPvv+pZcWvMTS8KM8WnGa6P
         ULJh3kKHksdzF6WK1UYNsMUsI6jbfDMCQ1x4KVCs1q2LGRY5ewX8g0kzSzuB9cZol4
         5cJcaBbFhZXKsphtn7VLkL/AsAlwJL05IQTY0d/juHdKKQbqLvQVJP6Ykc/12wDvtl
         oOFBsylpzYcdY29F+uytJ+9+IGF3sdvWER2D0PllFsr4p+eGo/LNYzrb49t0/cCUQM
         Y5PF85WIkO28g3Kv6FT0UzYgMyIWEFlQipvv+wnk14wbQg4KoqKR2x/9/P1y6EpMeb
         li6ShrTjAM5Hg==
Date:   Sun, 9 Jul 2023 15:37:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] misc: remove bogus fstest
Message-ID: <20230709223750.GC11456@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove this test, not sure why it was committed...

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/999     |   66 -----------------------------------------------------
 tests/xfs/999.out |   15 ------------
 2 files changed, 81 deletions(-)
 delete mode 100755 tests/xfs/999
 delete mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
deleted file mode 100755
index 9e799f66e72..00000000000
--- a/tests/xfs/999
+++ /dev/null
@@ -1,66 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
-#
-# FS QA Test 521
-#
-# Test xfs_repair's progress reporting
-#
-. ./common/preamble
-_begin_fstest auto repair
-
-# Override the default cleanup function.
-_cleanup()
-{
-	cd /
-	rm -f $tmp.*
-	_cleanup_delay > /dev/null 2>&1
-}
-
-# Import common functions.
-. ./common/filter
-. ./common/dmdelay
-. ./common/populate
-
-# real QA test starts here
-
-# Modify as appropriate.
-_supported_fs xfs
-_require_scratch
-_require_dm_target delay
-
-# Filter output specific to the formatters in xfs_repair/progress.c
-# Ideally we'd like to see hits on anything that matches
-# awk '/{FMT/' xfsprogs-dev/repair/progress.c
-filter_repair()
-{
-	sed -nre '
-	s/[0-9]+/#/g;
-	s/^\s+/ /g;
-	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
-	/#:#:#:/p
-	'
-}
-
-echo "Format and populate"
-_scratch_populate_cached nofill > $seqres.full 2>&1
-
-echo "Introduce a dmdelay"
-_init_delay
-DELAY_MS=38
-
-# Introduce a read I/O delay
-# The default in common/dmdelay is a bit too agressive
-BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
-DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
-_load_delay_table $DELAY_READ
-
-echo "Run repair"
-SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
-        tee -a $seqres.full > $tmp.repair
-
-cat $tmp.repair | filter_repair | sort -u
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
deleted file mode 100644
index e27534d8de6..00000000000
--- a/tests/xfs/999.out
+++ /dev/null
@@ -1,15 +0,0 @@
-QA output created by 999
-Format and populate
-Introduce a dmdelay
-Run repair
- - #:#:#: Phase #: #% done - estimated remaining time {progres}
- - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
- - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
- - #:#:#: process known inodes and inode discovery - # of # inodes done
- - #:#:#: process newly discovered inodes - # of # allocation groups done
- - #:#:#: rebuild AG headers and trees - # of # allocation groups done
- - #:#:#: scanning agi unlinked lists - # of # allocation groups done
- - #:#:#: scanning filesystem freespace - # of # allocation groups done
- - #:#:#: setting up duplicate extent list - # of # allocation groups done
- - #:#:#: verify and correct link counts - # of # allocation groups done
- - #:#:#: zeroing log - # of # blocks done
