Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECACC07E9C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7A061CAC
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 00:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGGAYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 20:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhGGAYa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 20:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3076261C91;
        Wed,  7 Jul 2021 00:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625617311;
        bh=wsR7O4YF+XUkT361BzP6TGQSgYg5RrVBcsDkHEmSIkw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uL2LRtkPHGJVV2Mwb4oqjtOS8UpWvQ7Ukp/RdQAsAY0aRmgyQ3+oOfK3lVXOPaFFU
         Q+etkScTvgpW2bxY9+tfhu91bfi5sCSU4WBQGcYea8SNnZwSMpz+n58WP/pDAHhdqP
         RVbhfXt9sybooIpK7gR47P4apVfP7MjbxbhUMCloYpEml7WwCV5oJUCpbs0o1SCNDX
         3LdenGECazuQhOEbC4AdM9o9W7tV3kar6g4WJ9rutRMW7VfB5EAITHLKlrv/IBtwva
         JZnzx8GQZ87gr4O2nUHn4Tg/U4nLVL/t9pyD4GmKiC3s6PygbkhvNEWBtws4XalZ1t
         0RLxOn7ODHVvQ==
Subject: [PATCH 8/8] generic/019: don't dump cores when fio/fsstress hit io
 errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 06 Jul 2021 17:21:50 -0700
Message-ID: <162561731092.543423.12382027169225482171.stgit@locust>
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
References: <162561726690.543423.15033740972304281407.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Disable coredumps so that fstests won't mark the test failed when the
EIO injector causes an mmap write to abort with SIGBUS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/019 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/generic/019 b/tests/generic/019
index bd234815..b8d025d6 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -62,6 +62,9 @@ NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
 
+# Don't fail the test just because fio or fsstress dump cores
+ulimit -c 0
+
 cat >$fio_config <<EOF
 ###########
 # $seq test's fio activity

