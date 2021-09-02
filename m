Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A311BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9776108E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345522AbhIBXxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345048AbhIBXxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Sep 2021 19:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C036103A;
        Thu,  2 Sep 2021 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630626765;
        bh=HnvHdXUFsYt+iyC811yisJQSfgq/QzkZiKdK/DhqPRw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GWPAR5IC1Ju9yzh7N1So8ruCKBHzto70a95FjpNrRG+9YXuQiJZBLBK44OzpPiP2j
         YUHNECYmPoh4Syj6MzSn9jUpD6rr5ZMUaZfRY6Dx/vfyFJBq4Zcm/otyKmkxo6tlP1
         aqRVLbQevt2nAz5t4TMrN7dECsLdAjx17HnEAaqnuNRvoYbW47Xry78YIFEuIMNhtd
         HTDda3j7GQjScAsq1Wpnwe3FjltMZXSnr0AJXW+OvZsbezFqO977BcrdZdT09nh+tv
         TzyWiCVzOnXjW65Rn0ElBYjSngPT9ccUyTsXMCvcSZmciQG7icpUjxO4/V++HQycf7
         mA2Tv52P2sEfw==
Subject: [PATCH 4/8] btrfs: fix incorrect subvolume test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 02 Sep 2021 16:52:45 -0700
Message-ID: <163062676513.1579659.12516104685003091290.stgit@magnolia>
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

The group for testing subvolume functionality is 'subvol', not
'subvolume'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/btrfs/233 |    2 +-
 tests/btrfs/245 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/btrfs/233 b/tests/btrfs/233
index f3e3762c..6a414443 100755
--- a/tests/btrfs/233
+++ b/tests/btrfs/233
@@ -9,7 +9,7 @@
 # performed.
 #
 . ./common/preamble
-_begin_fstest auto quick subvolume
+_begin_fstest auto quick subvol
 
 # Override the default cleanup function.
 _cleanup()
diff --git a/tests/btrfs/245 b/tests/btrfs/245
index 2b9c63c7..f3380ac2 100755
--- a/tests/btrfs/245
+++ b/tests/btrfs/245
@@ -8,7 +8,7 @@
 # as subvolume and snapshot creation and deletion.
 #
 . ./common/preamble
-_begin_fstest auto quick idmapped subvolume
+_begin_fstest auto quick idmapped subvol
 
 # get standard environment, filters and checks
 . ./common/rc

