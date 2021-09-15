Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89B0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86BCF610FF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhIOXoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233280AbhIOXoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4EF60F25;
        Wed, 15 Sep 2021 23:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749368;
        bh=tT/mGLd4kItwm7Ge6257Bqs1Xr0PhVhHfPEySTspvHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N+ht+hpLeMe3oqlIcDSoJMdTgm5Y1MEn2VXoBHipDUVCAgjeccTpcX/Qo40dDUKxD
         hyXrlU8GEm1UXh1n1U/W5GLMZ8dc+8Tt5fTNY6Iwwl+jFalPtjg7pWGJLZe9waGhCF
         uZpEpH02iUhMZKlOdNObF0iZVKQqZPHL4w9hb0cL60uStxuvg+8Br+0ibzncVLpr/k
         4m4u/DNEofmR2Vs3gNnopIrkY8mDf5U1VQ+i6OFI51oRnAMUaV9PJZr14qXcAXDUp0
         q5jFjmg3BCpuzCKXqdMGpZ5/RbgCbb7Wylbu/MUaCGBGJXsueRglVcWHpxNiy68waK
         v5rUILxCD8XlQ==
Subject: [PATCH 2/9] xfs: move reflink tests into the clone group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:48 -0700
Message-ID: <163174936843.380880.4944637627844574386.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

"clone" is the group for tests that exercise FICLONERANGE, so move these
tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/519 |    2 +-
 tests/xfs/520 |    2 +-
 tests/xfs/535 |    2 +-
 tests/xfs/536 |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/519 b/tests/xfs/519
index 675ec07e..49c62b56 100755
--- a/tests/xfs/519
+++ b/tests/xfs/519
@@ -9,7 +9,7 @@
 # flushing the log and then remounting to check file contents.
 
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/520 b/tests/xfs/520
index 8410f2ba..2fceb07c 100755
--- a/tests/xfs/520
+++ b/tests/xfs/520
@@ -12,7 +12,7 @@
 # is included in the current kernel.
 #
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/xfs/535 b/tests/xfs/535
index 4c883675..1a5da61b 100755
--- a/tests/xfs/535
+++ b/tests/xfs/535
@@ -7,7 +7,7 @@
 # Verify that XFS does not cause inode fork's extent count to overflow when
 # writing to a shared extent.
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter
diff --git a/tests/xfs/536 b/tests/xfs/536
index e5f904f5..64fa4fbf 100755
--- a/tests/xfs/536
+++ b/tests/xfs/536
@@ -7,7 +7,7 @@
 # Verify that XFS does not cause inode fork's extent count to overflow when
 # remapping extents from one file's inode fork to another.
 . ./common/preamble
-_begin_fstest auto quick reflink
+_begin_fstest auto quick clone
 
 # Import common functions.
 . ./common/filter

