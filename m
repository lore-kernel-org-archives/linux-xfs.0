Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DD7C432BE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C3E61008
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbhIAAMP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhIAAMM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E6E36102A;
        Wed,  1 Sep 2021 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455076;
        bh=70jg9XdlglMyUXz102uAuGy064kfYaXRxY8G1CLZGak=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QpXj9O2oPritGUp5fAGjw4HGvAbjbvpj1Lhg6iqZZmr8JUfGUCnj6Ppia5QZSj7Uc
         4LaOGG+ywdnz5hN1UYCEEs/RQjhMXEVjwiqgky8yV4VRE04o3njnDQMEfAud/YxKCz
         E1kqJiT5z7Mywz2beJBQHrOIeVXKgrOujYWXTIeteTCd5NS6eePub/sSzPKMBEIaUv
         11zFjWyUBl0FHEWaAJSQ6gnyEYCCpox1yHapF25AuNt5cx2rhXwCMmvnjQlCCRTPr4
         GDsP5Io9TI6ciqSnvNZh7hw/bq+0B4ntweu2T6Z6kXbuEdqQ4J+mFkSM6t3sZzovLq
         rHwEd8BvecWUw==
Subject: [PATCH 1/2] common/xfs: skip xfs_check unless the test runner forces
 us to
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:16 -0700
Message-ID: <163045507618.769821.3650550873572768945.stgit@magnolia>
In-Reply-To: <163045507051.769821.5924414818977330640.stgit@magnolia>
References: <163045507051.769821.5924414818977330640.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

At long last I've completed my quest to ensure that every corruption
found by xfs_check can also be found by xfs_repair.  Since xfs_check
uses more memory than repair and has long been obsolete, let's stop
running it automatically from _check_xfs_filesystem unless the test
runner makes us do it.

Tests that explicitly want xfs_check can call it via _scratch_xfs_check
or _xfs_check; that part doesn't go away.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 README     |    4 ++++
 common/xfs |   12 ++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)


diff --git a/README b/README
index 84c217ce..63f0641a 100644
--- a/README
+++ b/README
@@ -125,6 +125,10 @@ Preparing system for tests:
 	       time we should try a patient module remove. The default is 50
 	       seconds. Set this to "forever" and we'll wait forever until the
 	       module is gone.
+             - Set FORCE_XFS_CHECK_PROG=yes to have _check_xfs_filesystem run
+               xfs_check to check the filesystem.  As of August 2021,
+               xfs_repair finds all filesystem corruptions found by xfs_check,
+               and more, which means that xfs_check is no longer run by default.
 
         - or add a case to the switch in common/config assigning
           these variables based on the hostname of your test
diff --git a/common/xfs b/common/xfs
index c5e39427..bfb1bf1e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -595,10 +595,14 @@ _check_xfs_filesystem()
 		ok=0
 	fi
 
-	# xfs_check runs out of memory on large files, so even providing the test
-	# option (-t) to avoid indexing the free space trees doesn't make it pass on
-	# large filesystems. Avoid it.
-	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
+	# xfs_check runs out of memory on large files, so even providing the
+	# test option (-t) to avoid indexing the free space trees doesn't make
+	# it pass on large filesystems. Avoid it.
+	#
+	# As of August 2021, xfs_repair completely supersedes xfs_check's
+	# ability to find corruptions, so we no longer run xfs_check unless
+	# forced to run it.
+	if [ "$LARGE_SCRATCH_DEV" != yes ] && [ "$FORCE_XFS_CHECK_PROG" = "yes" ]; then
 		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
 	fi
 	if [ -s $tmp.fs_check ]; then

