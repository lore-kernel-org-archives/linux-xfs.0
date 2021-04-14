Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AABC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE94613C3
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348957AbhDNBFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348955AbhDNBFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D16B613C0;
        Wed, 14 Apr 2021 01:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362289;
        bh=NlCVr1nnQvGnwftU1uPqeOEIoypN0RecoAkuzE9lFbw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m8WZS7EuctfwnIXPtDtV7FrLhSSXDsBuEbse3dDJ0KvsPm26mGUMBk3K4rbxDNVdv
         Rd36i618RCO2ojf6k7q0w+Gp21mQ1AdBs9v+qa+4G13GhccRroDcHCez6ZYYNaZwwt
         CbGJ+6SJ0HkCXlyxApBEV+4lkYGDjGBKgBjNhH1k+wUa3j1cCzyqyjjvjejMFuipGW
         G1/cy8dyJ4k3oG2yULQC5DBRKP+RaEF9kcVYgjqjo6qmNnqzL7Yr+AT95DFxiqJEGn
         IF3MpRvwSVew9SXETcgGn3czj+NWCilxzRJYE4mSG23TZ6PUQbrMrNNPl53+kqooFk
         oNA31Ea/Y+0oQ==
Subject: [PATCH 3/9] xfs/521,530: refactor scratch fs check
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:04:48 -0700
Message-ID: <161836228828.2754991.13327862649701948223.stgit@magnolia>
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the existing _check_scratch_fs helper to check the (modified)
scratch filesystem in these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/521 |    2 +-
 tests/xfs/530 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/521 b/tests/xfs/521
index e6c417b8..b8026d45 100755
--- a/tests/xfs/521
+++ b/tests/xfs/521
@@ -75,7 +75,7 @@ echo "Create more copies to make sure the bitmap really works"
 cp -p $testdir/original $testdir/copy3
 
 echo "Check filesystem"
-_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+_check_scratch_fs
 
 # success, all done
 status=0
diff --git a/tests/xfs/530 b/tests/xfs/530
index 65c17af2..0e4dd6b5 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -114,7 +114,7 @@ for rtino in rbmino rsumino; do
 done
 
 echo "Check filesystem"
-_check_xfs_filesystem $SCRATCH_DEV none $rtdev
+_check_scratch_fs
 
 losetup -d $rtdev
 rm -f $TEST_DIR/$seq.rtvol

