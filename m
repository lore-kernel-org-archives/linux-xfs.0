Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5360DC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 16:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C9F60560
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 16:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhG2QxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 12:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG2QxJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 12:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ACA960E76;
        Thu, 29 Jul 2021 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627577586;
        bh=7YMejev/9hsh+iza15xMqmVc7BACn5GZsZT1CfDg+28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZ2bpkH49lZ8GLlwTPaPwlHptkIg/YPwS7lFUP3pIZqPoGryn4aW8iWlkwiJGqqwz
         zwKwrhfsCA24VTLSXCX6R3UtYoyR/QimqKEyrgixbqvqtWjnYoi4R8OVHS2VBzAt9e
         JVTs0G165ICN2MYtb6XnYvmev9Aht9lIa7kNvZX8DSmwdeqsqNHUwyn5c6a+0Z8iay
         yEIDaBik0RgagXuXwPK/pJwVcZiYbcLNOXGuKDtWx6AvC/0GE3GFf8AkmwT9JPpBsG
         fQlCJGueMJlchjNlEzhVbOw/GapbMjgITeR5mm9NPz2BWFD6t8lIIjDZ4w5O00+Eck
         4CyCDy9/j2fmg==
Date:   Thu, 29 Jul 2021 09:53:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        fdmanana@gmail.com, dchinner@redhat.com
Subject: [PATCH v2 1/1] misc: tag all tests that examine crash recovery in a
 loop
Message-ID: <20210729165305.GD3601466@magnolia>
References: <162743103739.3429001.16912087881683869606.stgit@magnolia>
 <162743104288.3429001.18145781236429703996.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743104288.3429001.18145781236429703996.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Given all the recent problems that we've been finding with log recovery,
I think it would be useful to create a 'recoveryloop' group so that
developers have a convenient way to run every single test that rolls
around in a fs shutdown loop looking for subtle errors in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
v2: add more tests per fdmanana suggestion
---
 tests/btrfs/172   |    2 +-
 tests/btrfs/190   |    2 +-
 tests/btrfs/192   |    2 +-
 tests/btrfs/206   |    2 +-
 tests/generic/019 |    2 +-
 tests/generic/388 |    2 +-
 tests/generic/455 |    2 +-
 tests/generic/457 |    2 +-
 tests/generic/475 |    2 +-
 tests/generic/482 |    2 +-
 tests/generic/725 |    2 +-
 tests/xfs/057     |    2 +-
 12 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/btrfs/172 b/tests/btrfs/172
index 4db54642..f5acc698 100755
--- a/tests/btrfs/172
+++ b/tests/btrfs/172
@@ -11,7 +11,7 @@
 #     btrfs: replace all uses of btrfs_ordered_update_i_size
 #
 . ./common/preamble
-_begin_fstest auto quick log replay
+_begin_fstest auto quick log replay recoveryloop
 
 # Import common functions.
 . ./common/filter
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
diff --git a/tests/btrfs/192 b/tests/btrfs/192
index dd197b6b..bcf14ebb 100755
--- a/tests/btrfs/192
+++ b/tests/btrfs/192
@@ -8,7 +8,7 @@
 # and removal
 #
 . ./common/preamble
-_begin_fstest auto replay snapshot stress
+_begin_fstest auto replay snapshot stress recoveryloop
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/btrfs/206 b/tests/btrfs/206
index c45b89e6..efb07b4b 100755
--- a/tests/btrfs/206
+++ b/tests/btrfs/206
@@ -12,7 +12,7 @@
 #	btrfs: replace all uses of btrfs_ordered_update_i_size
 #
 . ./common/preamble
-_begin_fstest auto quick log replay
+_begin_fstest auto quick log replay recoveryloop
 
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
