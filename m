Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A3CC3063F
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjGCRDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjGCRDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:03:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9BDE5D;
        Mon,  3 Jul 2023 10:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E1760FED;
        Mon,  3 Jul 2023 17:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7194BC433C8;
        Mon,  3 Jul 2023 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403830;
        bh=58z7Srcl/+HK8KI8+j/I2YBIyXH/Q9jFH1Q/otFMx10=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GlapZtFAyNXNAyXVZEjcai7ZO6fWyUG4JgBWY0crKYhZpp1UiQ6FiRsA1H2/0LqcU
         sbJVtdxgIKIaS9hMBSJ4kv3HgOz4Wx5dtI0JW8wbIIo+xlsEYYhgh+tsFhoHKCxgLc
         2zF9v1hUI4MbwZCdXXjRd3+bfGZfOyp/vwYTsZQrCJqaZjDj4MmjAGjKrsPXerrR8a
         oGB/8OEyxgPsg2Ljn9Mb5dUU0EYghi984tfkTfIER/5eXZG5mqef+jE3JGpTDvvwhd
         48FnXwRlD+S4/Bxuv4WDV3c/E1wz6pKpW1y9T2T991RHjqhvQDSsUaxtQGLgYUvNvh
         qeGasG4AYcMpA==
Subject: [PATCH 3/5] xfs/439: amend test to work with new log geometry
 validation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:03:50 -0700
Message-ID: <168840383001.1317961.12926483978316384291.stgit@frogsfrogsfrogs>
In-Reply-To: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

An upcoming patch moves more log validation checks to the superblock
verifier, so update this test as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/439 |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/439 b/tests/xfs/439
index b7929493d1..8c69ece655 100755
--- a/tests/xfs/439
+++ b/tests/xfs/439
@@ -21,7 +21,9 @@ _begin_fstest auto quick fuzzers log
 _supported_fs xfs
 _require_scratch_nocheck
 # We corrupt XFS on purpose, and check if assert failures would crash system.
-_require_no_xfs_bug_on_assert
+# This used to be _require_no_xfs_bug_on_assert, but now we've fixed the sb
+# verifier to reject this before xfs_log_mount gets to it:
+_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: journal geometry is not properly bounds checked"
 
 rm -f "$seqres.full"
 
@@ -33,7 +35,7 @@ blksz=$(_scratch_xfs_get_sb_field blocksize)
 _scratch_xfs_set_sb_field logsunit $((blksz - 1)) >> $seqres.full 2>&1
 
 # Check if logsunit is set correctly
-lsunit=$(_scratch_xfs_get_sb_field logsunit)
+lsunit=$(_scratch_xfs_get_sb_field logsunit 2>/dev/null)
 [ $lsunit -ne $((blksz - 1)) ] && _notrun "failed to set sb_logsunit"
 
 # Mount and writing log may trigger a crash on buggy kernel

