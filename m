Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACAFC48BE6
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328556134F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhFNVBg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 17:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234280AbhFNVBf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8932C601FC;
        Mon, 14 Jun 2021 20:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704372;
        bh=kNq3y90VOBNbcYwZ2v6HvNwjuuleL7J5lcPebkjFm+w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IRfwRarLCBk9e6EZFdFu1VO5sjmHsRS74ePi2FKOmB6uoDUMX/7vgQuH+5KAzqait
         XT3u1xRSrBrSkWl/AfX8u4XVXxW8ARsZnM+0FZPyXWDC+CgdM+tfUXdfwFi25gja2G
         nhPbbCv4sHchjovL4QcTtRZ1VC5vcNVBMO/jxkgr7iq9lm3Yzid9voULmGD21j6usz
         VhDcfROyb9+Fd+q4rPO47HRBTW8li5RT6Ala1jYQthzoqqK1cpEAEO/3g0NrSNhjUn
         WD9i5BS8y1/f7xa7sEyUVoMZGvGWczr8yZ1ZuQi49xS/LQgOfQ5NM6PdR7aKatcOXg
         fZOBvSbeXBQvw==
Subject: [PATCH 06/13] fstests: clean up open-coded golden output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 13:59:32 -0700
Message-ID: <162370437228.3800603.4686985475787987320.stgit@locust>
In-Reply-To: <162370433910.3800603.9623820748404628250.stgit@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the handful of tests that open-coded 'QA output created by XXX'.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tests/btrfs/006.out   |    2 +-
 tests/btrfs/012.out   |    2 +-
 tests/generic/184.out |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/btrfs/006.out b/tests/btrfs/006.out
index a9769721..b7f29f96 100644
--- a/tests/btrfs/006.out
+++ b/tests/btrfs/006.out
@@ -1,4 +1,4 @@
-== QA output created by 006
+QA output created by 006
 == Set filesystem label to TestLabel.006
 == Get filesystem label
 TestLabel.006
diff --git a/tests/btrfs/012.out b/tests/btrfs/012.out
index 2a41e7e4..7aa5ae94 100644
--- a/tests/btrfs/012.out
+++ b/tests/btrfs/012.out
@@ -1 +1 @@
-== QA output created by 012
+QA output created by 012
diff --git a/tests/generic/184.out b/tests/generic/184.out
index 2d19691d..4c300543 100644
--- a/tests/generic/184.out
+++ b/tests/generic/184.out
@@ -1 +1 @@
-QA output created by 184 - silence is golden
+QA output created by 184

