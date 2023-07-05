Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60876EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 15:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjGEPiW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjGEPiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 11:38:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDC710F5;
        Wed,  5 Jul 2023 08:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF51561403;
        Wed,  5 Jul 2023 15:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A9DC433C8;
        Wed,  5 Jul 2023 15:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688571500;
        bh=4rJSb474n/LoYcyz5g+9Lh3n8cxVkxhmylvev2DsJSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hxAQjChbo8UoCyUpZBsC5dQS0vdNoGQm07KC/ALsoSIS2/PzJOwZtLfcSrDGTrXXb
         LX2eYyO41WirNUu3i/4Ju4ZkaxAhmudgA4DQN+2LPQ6JPg/XaVX26LbybiD0vgL+Wm
         tKxjyBDta4P8805+9bQGPLWGnc4/Hdvm5KeazvetFL63DZvvym4MEDkxKm50k/dn7p
         SAf9UBEQu2OuUzD2fY4gnf+jNFITF0660KIQn8hwRDF8nWXGzJoK0IwK7SDWRNOmlL
         fcyXOut6D0Upbf+KNPqPlJsXOQQYUf7CHpAexqDEUcqlZFttme0w24T/4soQ0LBLhw
         N5omSGe5Scd6Q==
Date:   Wed, 5 Jul 2023 08:38:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 3/5] xfs/439: amend test to work with new log geometry
 validation
Message-ID: <20230705153819.GS11441@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

An upcoming patch moves more log validation checks to the superblock
verifier, so update this test as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: annotate which commits this tests is testing
---
 tests/xfs/439 |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/439 b/tests/xfs/439
index b7929493d1..cb6fb37918 100755
--- a/tests/xfs/439
+++ b/tests/xfs/439
@@ -20,8 +20,14 @@ _begin_fstest auto quick fuzzers log
 # real QA test starts here
 _supported_fs xfs
 _require_scratch_nocheck
-# We corrupt XFS on purpose, and check if assert failures would crash system.
-_require_no_xfs_bug_on_assert
+
+# We corrupt XFS on purpose, and check if assert failures would crash the
+# system when trying to xfs_log_mount.  Hence this is a regression test for:
+_fixed_by_git_commit kernel 9c92ee208b1f "xfs: validate sb_logsunit is a multiple of the fs blocksize"
+
+# This used to be _require_no_xfs_bug_on_assert, but now we've fixed the sb
+# verifier to reject this before xfs_log_mount gets to it:
+_fixed_by_git_commit kernel f1e1765aad7d "xfs: journal geometry is not properly bounds checked"
 
 rm -f "$seqres.full"
 
@@ -33,7 +39,7 @@ blksz=$(_scratch_xfs_get_sb_field blocksize)
 _scratch_xfs_set_sb_field logsunit $((blksz - 1)) >> $seqres.full 2>&1
 
 # Check if logsunit is set correctly
-lsunit=$(_scratch_xfs_get_sb_field logsunit)
+lsunit=$(_scratch_xfs_get_sb_field logsunit 2>/dev/null)
 [ $lsunit -ne $((blksz - 1)) ] && _notrun "failed to set sb_logsunit"
 
 # Mount and writing log may trigger a crash on buggy kernel
