Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4B0C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB1F96140C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhD1EKK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234436AbhD1EKJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FE08613F9;
        Wed, 28 Apr 2021 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582965;
        bh=vCQs2qZKXCWNOopS++qbkc0wL7f4psbDajdHIaGIPjg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CjU6AE4+iDWz3zVDrNMFc1Zn/t4bxaqGQL8vHLmxhdeYOl3q2K0SzYcIpXoISLLhz
         BOKFas/hNHDgGu38AwX0CPCL+q371eANqqxU/bcER6FqJe+KWCAmeDrPRyCBvZSpG1
         6E2V6DBWAdY2MNXeXENwfKC8nsGHelvbCpIoNczzdhv9g+7FU25C2H4QgC+n1Qom78
         MZiHB93XY/CVXDeoKipSjbEHBjzy0RyHNRFMMfDKB279/0d4/7UFSQPIK199qK7p17
         IxLoNCU3xGpB5VbhgNQlITpiVYtYboYjgBgbupQKD+IrIEpuM1yspZ8se2XePV8d7/
         PqlwJncY537zA==
Subject: [PATCH 5/5] xfs/49[12]: skip pre-lazysbcount filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:24 -0700
Message-ID: <161958296475.3452351.7075798777673076839.stgit@magnolia>
In-Reply-To: <161958293466.3452351.14394620932744162301.stgit@magnolia>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to lazysbcount, the xfs mount code blindly trusted the value of
the fdblocks counter in the primary super, which means that the kernel
doesn't detect the fuzzed fdblocks value at all.  V4 is deprecated and
pre-lazysbcount V4 hasn't been the default for ~14 years, so we'll just
skip these two tests on those old filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/491 |    5 +++++
 tests/xfs/492 |    5 +++++
 2 files changed, 10 insertions(+)


diff --git a/tests/xfs/491 b/tests/xfs/491
index 6420202b..9fd0ab56 100755
--- a/tests/xfs/491
+++ b/tests/xfs/491
@@ -36,6 +36,11 @@ _require_scratch
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
+
+# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
+_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
+	_notrun "filesystem requires lazysbcount"
+
 _scratch_mount >> $seqres.full 2>&1
 echo "test file" > $SCRATCH_MNT/testfile
 
diff --git a/tests/xfs/492 b/tests/xfs/492
index 522def47..c4b087b5 100755
--- a/tests/xfs/492
+++ b/tests/xfs/492
@@ -36,6 +36,11 @@ _require_scratch
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
+
+# pre-lazysbcount filesystems blindly trust the primary sb fdblocks
+_check_scratch_xfs_features LAZYSBCOUNT &>/dev/null || \
+	_notrun "filesystem requires lazysbcount"
+
 _scratch_mount >> $seqres.full 2>&1
 echo "test file" > $SCRATCH_MNT/testfile
 

