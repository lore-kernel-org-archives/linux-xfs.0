Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13378C48BE8
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E302E61378
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 20:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbhFNVBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 17:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbhFNVBN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jun 2021 17:01:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A13DF601FC;
        Mon, 14 Jun 2021 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623704350;
        bh=NQz2B/6gA1jDHUUnGs57KukZqdUdsO693x8BFij8ueY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tNVXc8xi/5rZ+kXC0gaR7ok/aYx7uOjFOw/H5J1AkJfh2JSCrP4mzfw2WX2riwpon
         yY28wWuvP+2f5y7XT0tXcXPLBJqloGfmUMmoCptuDMEmQtg2kkmHBhnJa0dw5ZyZn6
         MFXHiQpL3ejT7o7qmSgZaksDniMQ5yPlqZCCSyIdfgj93VLZHP/KQvls15gxjOtfaU
         GqgMqDATR4rHUF8VfLXflPKlv4Z04ZQULgRvM2ON1aujZ99PT5gP1iRxgkM4rR39mM
         Dk/q8GGLxuTJnHI7badf/o0f+IwI278JCxZbWLS4AVk+RaF2Z/54H/SI3M5ma7q7vB
         qA27ZpKkDrdfg==
Subject: [PATCH 02/13] misc: move exit status into trap handler
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Mon, 14 Jun 2021 13:59:10 -0700
Message-ID: <162370435035.3800603.9525365377170213035.stgit@locust>
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

Move the "exit $status" clause of the _cleanup function into the
argument to the "trap" command so that we can standardize the
registration of the atexit cleanup code in the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 tests/generic/068 |    3 +--
 tests/xfs/004     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/tests/generic/068 b/tests/generic/068
index 932a8560..573fbd45 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -22,10 +22,9 @@ _cleanup()
     cd /
 
     trap 0 1 2 3 15
-    exit $status
 }
 
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/004 b/tests/xfs/004
index d3fb9c95..4d92a08e 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -18,9 +18,8 @@ _cleanup()
 {
 	_scratch_unmount
 	rm -f $tmp.*
-	exit $status
 }
-trap "_cleanup" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _populate_scratch()
 {

