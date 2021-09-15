Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE1BC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E1460F8F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhIOXoT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232982AbhIOXoT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930C160F25;
        Wed, 15 Sep 2021 23:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749379;
        bh=HnvHdXUFsYt+iyC811yisJQSfgq/QzkZiKdK/DhqPRw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lWrIrE8VG9TJ2Uj0cBKhUHy9aRY77p49i41ZZrtuby6fwo0Qt6Sn9olBEZIkkWpn2
         cEzwbzXV53dYbq6C0mG3mOBfcb3nDJnPp+jjkMpKuTH4t/apvHnhMcTYcM/zP2G0HV
         vp2exG8yWNrvXzUUa6tAnyJ3xtHgSF88mjO5ZyOoExrJV4Gt/dZBrPGpgLArLDkyuq
         g+3q6a3NX76ZnwiBytdlJ1WYDFqIn++TzG+5f39kH9byMefX17vbGjkfnKyEor1Aiz
         SH/ejiKVFfAIwmulWzdwHTamivIvtOoZNlcd733Cq12H88kRD9xejCHQGLrH9Lz9Ga
         N9kMMgK5c+b8A==
Subject: [PATCH 4/9] btrfs: fix incorrect subvolume test group name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:59 -0700
Message-ID: <163174937934.380880.8949346653026672201.stgit@magnolia>
In-Reply-To: <163174935747.380880.7635671692624086987.stgit@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
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

