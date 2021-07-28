Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D51C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D72660F41
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhG1AKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AKn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CEAA601FC;
        Wed, 28 Jul 2021 00:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431043;
        bh=pzcrRVDACGXFIwCHlnfomQ4hZwsHcRrOKPYvZJUxA8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W/5RM6fSSdS435utZ+tHvLxqS/KMwaeFOyFJ+or/kxK9vjW5jq+SbvXTVmvyDelJ+
         FDryP71qh+vCsi+XWUB7v3zzxKjIfoA6UBnoZ+IsQn4m3dUpRr8IPHyMYVplVbxO4Y
         HUwo/dQFEiEjwfzrSP8lrUj3zSq2mzAEyYzci9YznPPxuWaBJgEbKuyi1NhDMgmBOm
         eSePD52e7MU/nSwO+4j2+uElWZIys73SvzTf5FSn5OucL9mnNf11syzCEXCM3uYY8x
         IaQoeQ741kjz90d71oWwiWjXUv3N87Z/verRr+AFJ8TLLkCmfrXMzsEevUtLaYTrzd
         G3Ezwn2qN9cng==
Subject: [PATCH 1/1] misc: tag all tests that examine crash recovery in a loop
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:42 -0700
Message-ID: <162743104288.3429001.18145781236429703996.stgit@magnolia>
In-Reply-To: <162743103739.3429001.16912087881683869606.stgit@magnolia>
References: <162743103739.3429001.16912087881683869606.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Given all the recent problems that we've been finding with log recovery,
I think it would be useful to create a 'recoveryloop' group so that
developers have a convenient way to run every single test that rolls
around in a fs shutdown loop looking for subtle errors in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/btrfs/190   |    2 +-
 tests/generic/019 |    2 +-
 tests/generic/388 |    2 +-
 tests/generic/455 |    2 +-
 tests/generic/457 |    2 +-
 tests/generic/475 |    2 +-
 tests/generic/482 |    2 +-
 tests/generic/725 |    2 +-
 tests/xfs/057     |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)


diff --git a/tests/btrfs/190 b/tests/btrfs/190
index 3aa718e2..974438c1 100755
--- a/tests/btrfs/190
+++ b/tests/btrfs/190
@@ -8,7 +8,7 @@
 # balance needs to be resumed on mount.
 #
 . ./common/preamble
-_begin_fstest auto quick replay balance qgroup
+_begin_fstest auto quick replay balance qgroup recoveryloop
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/generic/019 b/tests/generic/019
index b8d025d6..db56dac1 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -8,7 +8,7 @@
 # check filesystem consistency at the end.
 #
 . ./common/preamble
-_begin_fstest aio dangerous enospc rw stress
+_begin_fstest aio dangerous enospc rw stress recoveryloop
 
 fio_config=$tmp.fio
 
diff --git a/tests/generic/388 b/tests/generic/388
index e41712af..9cd737e8 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -15,7 +15,7 @@
 # spurious corruption reports and/or mount failures.
 #
 . ./common/preamble
-_begin_fstest shutdown auto log metadata
+_begin_fstest shutdown auto log metadata recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/455 b/tests/generic/455
index 62788798..13d326e7 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -7,7 +7,7 @@
 # Run fsx with log writes to verify power fail safeness.
 #
 . ./common/preamble
-_begin_fstest auto log replay
+_begin_fstest auto log replay recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/457 b/tests/generic/457
index d9e38268..f4fdd81d 100755
--- a/tests/generic/457
+++ b/tests/generic/457
@@ -7,7 +7,7 @@
 # Run fsx with log writes on cloned files to verify power fail safeness.
 #
 . ./common/preamble
-_begin_fstest auto log replay clone
+_begin_fstest auto log replay clone recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/475 b/tests/generic/475
index 62894491..c426402e 100755
--- a/tests/generic/475
+++ b/tests/generic/475
@@ -12,7 +12,7 @@
 # testing efforts.
 #
 . ./common/preamble
-_begin_fstest shutdown auto log metadata eio
+_begin_fstest shutdown auto log metadata eio recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/482 b/tests/generic/482
index f26e6fc4..0fadf795 100755
--- a/tests/generic/482
+++ b/tests/generic/482
@@ -9,7 +9,7 @@
 # Will do log replay and check the filesystem.
 #
 . ./common/preamble
-_begin_fstest auto metadata replay thin
+_begin_fstest auto metadata replay thin recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/generic/725 b/tests/generic/725
index f43bcb37..8bd724e3 100755
--- a/tests/generic/725
+++ b/tests/generic/725
@@ -12,7 +12,7 @@
 # in writeback on the host that cause VM guests to fail to recover.
 #
 . ./common/preamble
-_begin_fstest shutdown auto log metadata eio
+_begin_fstest shutdown auto log metadata eio recoveryloop
 
 _cleanup()
 {
diff --git a/tests/xfs/057 b/tests/xfs/057
index d4cfa8dc..9fb3f406 100755
--- a/tests/xfs/057
+++ b/tests/xfs/057
@@ -21,7 +21,7 @@
 # Note that this test requires a DEBUG mode kernel.
 #
 . ./common/preamble
-_begin_fstest auto log
+_begin_fstest auto log recoveryloop
 
 # Override the default cleanup function.
 _cleanup()

