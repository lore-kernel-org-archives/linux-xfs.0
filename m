Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D29BE728CA
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 17:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjI2R2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 13:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbjI2R2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 13:28:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230CA171B;
        Fri, 29 Sep 2023 10:28:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B703C433C7;
        Fri, 29 Sep 2023 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696008482;
        bh=4+WoVUi61VK+DDhiND6JYjJPH6CQgIN2AdMUJCs+5WY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DlmbJK9eNw7Ry1GbBzL8r7PC/Jcj5QPNiqTLTWbN8YEHS7+JF4vOhWF/qymEq2z5v
         h/B5/12TyqQ24rNwma29nL0KGlV1wP4Q2H/1s7YXxgVhHeO1W1011ve5F5i0m2/KlR
         2l8FQcz7uPWw4pmPdH1JT2qyQrbDy82Dmc0XocyTC6RKY4c4XrCbHx6ZKbW15whwe3
         E2RADCzNi61SqZtd9Yc+GMkr1725QAosN5GQ/8JZqghBDzKbGQ0gzp4pKWcf0BkIk4
         3PrORRJjiczA3XrW6WiP64BE5WxVAKx3TfC+uZpetX7IvpiU13+ktobBEpgcGmITa3
         8JVCYJVmjjEHw==
Date:   Fri, 29 Sep 2023 10:28:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, sandeen@sandeen.net
Subject: [PATCH v2.1 1/1] xfs/{270,557,600}: update commit id for _fixed_by
 tag.
Message-ID: <20230929172801.GB21283@frogsfrogsfrogs>
References: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
 <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169567817607.2269889.5897696336492740125.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the commit id in the _fixed_by tag now that we've merged the
kernel fixes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/270 |    2 +-
 tests/xfs/557 |    2 +-
 tests/xfs/600 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 7d4e1f6a87..4e4f767dc1 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -17,7 +17,7 @@ _begin_fstest auto quick mount
 
 # real QA test starts here
 _supported_fs xfs
-_fixed_by_kernel_commit xxxxxxxxxxxx \
+_fixed_by_kernel_commit 74ad4693b647 \
 	"xfs: fix log recovery when unknown rocompat bits are set"
 # skip fs check because superblock contains unknown ro-compat features
 _require_scratch_nocheck
diff --git a/tests/xfs/557 b/tests/xfs/557
index 522c4f0643..01205377b7 100644
--- a/tests/xfs/557
+++ b/tests/xfs/557
@@ -18,7 +18,7 @@ _require_xfs_io_command "falloc"
 _require_xfs_io_command "bulkstat_single"
 _require_scratch
 
-_fixed_by_kernel_commit XXXXXXXXXXXX \
+_fixed_by_kernel_commit 817644fa4525 \
 	"xfs: get root inode correctly at bulkstat"
 
 # Create a filesystem which contains a fake root inode
diff --git a/tests/xfs/600 b/tests/xfs/600
index 56af634a7c..e6997c53d1 100755
--- a/tests/xfs/600
+++ b/tests/xfs/600
@@ -20,7 +20,7 @@ _begin_fstest auto quick fsmap
 
 . ./common/filter
 
-_fixed_by_git_commit kernel XXXXXXXXXXXXX \
+_fixed_by_git_commit kernel cfa2df68b7ce \
 	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
 
 # Modify as appropriate.
