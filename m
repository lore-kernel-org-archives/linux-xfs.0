Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2F0C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF5B60F9C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhG1AJo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846F960F23;
        Wed, 28 Jul 2021 00:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627430983;
        bh=l25hCtwPmaZVMKa26qzIVvFnfRrLE3HV4QrZjUsSPRs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gFqPaDBtCThepG5KEOdPmOTJA33q0e7zs6LmHErIxRlxhFkgbX4POhXVEt3dcgd3l
         q65bweWKGh8mx5mENe/xirCsUJliV7g+C9pemt0yIE7dciiPHhr5rVfKzQaucwrjjB
         zfz7tah9Todhk6iE2G+n6YDmHxdxFffxEY8KC/yt4pNu4kRDHsfna8T43NfSo7wOWR
         q09RIvQO4qEs2z56NocqzBMqw0pr/VfVbgHYBS9Tj9O6ia70/uoI+3nD0Hm0725zSL
         K1KQCblVIMdznIiAu1V3z7wbiqm1/OTMFQYk4HpvSR195i8M27vHffRr7X/22Tb1s9
         2rQKcsRVKq9IQ==
Subject: [PATCH 1/4] xfs/106: fix golden output regression in quota off test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:09:43 -0700
Message-ID: <162743098324.3427426.13889210606647869531.stgit@magnolia>
In-Reply-To: <162743097757.3427426.8734776553736535870.stgit@magnolia>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 4c5df338, we reshuffled this test a bit in preparation to
disable quotaoff by rearranging the test to testing disabling of quota
by remounting the filesystem.  Unfortunately, extra blank lines were
added to the golden output, leading to test regressions.

The "extra" blank lines are a result of the "echo ; test_off";
test_off() itself doesn't print anything.  Make it print /something/ so
that we know what the test was trying to do when a particular line of
golden output appears, then fix the blank lines.

Fixes: 4c5df338 ("xfs/106: don't test disabling quota accounting")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/106     |    1 +
 tests/xfs/106.out |    5 +++++
 2 files changed, 6 insertions(+)


diff --git a/tests/xfs/106 b/tests/xfs/106
index d8f55441..fc2281af 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -155,6 +155,7 @@ test_enable()
 
 test_off()
 {
+	echo "turning quota off by remounting"
 	_scratch_unmount
 	_qmount_option ""
 	_qmount
diff --git a/tests/xfs/106.out b/tests/xfs/106.out
index 3e6805a6..7c7be6b1 100644
--- a/tests/xfs/106.out
+++ b/tests/xfs/106.out
@@ -149,6 +149,7 @@ Blocks grace time: [3 days]
 Inodes grace time: [3 days]
 Realtime Blocks grace time: [7 days]
 
+turning quota off by remounting
 
 checking remove command (type=u)
 User quota are not enabled on SCRATCH_DEV
@@ -327,6 +328,8 @@ Blocks grace time: [3 days]
 Inodes grace time: [3 days]
 Realtime Blocks grace time: [7 days]
 
+turning quota off by remounting
+
 checking remove command (type=g)
 Group quota are not enabled on SCRATCH_DEV
 
@@ -504,6 +507,8 @@ Blocks grace time: [3 days]
 Inodes grace time: [3 days]
 Realtime Blocks grace time: [7 days]
 
+turning quota off by remounting
+
 checking remove command (type=p)
 Project quota are not enabled on SCRATCH_DEV
 

