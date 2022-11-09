Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE94C43219
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKICFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9A554B36
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AB2EB81CD7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FB5C433D6;
        Wed,  9 Nov 2022 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959511;
        bh=2FBShXMo5gchaatL2v9Kr+Js08nWLhjeRt/JApTrSGk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R1YiDJKVMrBiIINoYTFdrGC9P62sxPOn7Grvgeu8d9XBUJMwt+7MDKOpTNZnTXBe7
         iKe5EWTwTTzEAjBtIrt9uDvL9+LEDjVGCu88ux/JiLLoaHZ4p9ZUNhUtsfjYb3yHve
         iLHmI2+HqmaOaJUDRlT7v7IoRAbTxVnN1QHmP1jkMJBuoFBGQs0i4czrxgaRge38hW
         MzKYLFxLOj1brv9R5gQiYMyeeDE4TaMWkYZZX/EV36SvL6BEpUQBNPi/qvW6SaDkWD
         q6KBPZmCPfdSsumgfLXFPS1Z2cyROIJkSC57yeMwVCSsqTeZrJ4lvewqpOtLz1MmEM
         wWrzPCrzS/V/w==
Subject: [PATCH 2/7] misc: add static to various sourcefile-local functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:11 -0800
Message-ID: <166795951128.3761353.15844474340680771886.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These helper functions are not referenced outside the source file
they're defined in.  Mark them static.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c          |    2 +-
 io/pread.c          |    2 +-
 mkfs/xfs_mkfs.c     |    2 +-
 repair/xfs_repair.c |    2 +-
 scrub/inodes.c      |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index f06ee3e959..6c57cc624e 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -441,7 +441,7 @@ list_leafdir(
 }
 
 /* Read the directory, display contents. */
-int
+static int
 listdir(
 	struct xfs_inode	*dp)
 {
diff --git a/io/pread.c b/io/pread.c
index 458a78b83c..0f1d8b97b0 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -113,7 +113,7 @@ alloc_buffer(
 	return 0;
 }
 
-void
+static void
 __dump_buffer(
 	void		*buf,
 	off64_t		offset,
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9dd0e79c6b..e219ec166d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3964,7 +3964,7 @@ cfgfile_parse_ini(
 	return 1;
 }
 
-void
+static void
 cfgfile_parse(
 	struct cli_params	*cli)
 {
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index c94671d8d1..871b428d7d 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -750,7 +750,7 @@ check_fs_vs_host_sectsize(
 }
 
 /* Clear needsrepair after a successful repair run. */
-void
+static void
 clear_needsrepair(
 	struct xfs_mount	*mp)
 {
diff --git a/scrub/inodes.c b/scrub/inodes.c
index ffe7eb3344..78f0914b8d 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -163,7 +163,7 @@ alloc_ichunk(
 	return 0;
 }
 
-int
+static int
 render_ino_from_bulkstat(
 	struct scrub_ctx	*ctx,
 	char			*buf,

