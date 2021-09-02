Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AD8C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C9D861053
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344978AbhIBXxd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhIBXxd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D538610CE;
        Thu,  2 Sep 2021 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626754;
        bh=tT/mGLd4kItwm7Ge6257Bqs1Xr0PhVhHfPEySTspvHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LjYkt0+/ptJlJ01zba6qew1VjmsLL6mPGXLxr+GqC71sAY/zzCRCK5JPcFqc+KxUf
         puN8gMkPWqzrrN3GB/8PEGDSalr7wgRW5GKawjCn2cR0yNnFImPloT4w/xjDIFawcB
         N7H2bmIR0aYEmweol5UNSeLSxxj6YMasit/9qrEp0iW7UbSemZCFUOmpj5skzZOd9Z
         dXw1AqDfcbDSATVVhBx1GcZbXfTYTbiH+Pf2qTYiHoMaFFO3rummZIZxGwV0UAKXpD
         L8VVCmvMSUQ6/Mo4PL3VAYZsKiSZulrAuNu5Du9fvrfTacHE0Om/wAa8ce8FjbruwS
         n5qIUOqa5NoOg==
Subject: [PATCH 2/8] xfs: move reflink tests into the clone group
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:34 -0700
Message-ID: <163062675417.1579659.17996672464630051124.stgit@magnolia>
In-Reply-To: <163062674313.1579659.11141504872576317846.stgit@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
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

