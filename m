Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D35C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiKWRJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbiKWRJX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6968732BB0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E752D61DEB
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525DBC433C1;
        Wed, 23 Nov 2022 17:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223346;
        bh=4ENKD6CYJIlcq3tpEQi7XM8tDGHhneeXslf5YQUx1gM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=krTvEBHOq2D2ThJD9eI7y3e57w4i1bBIqSY2zIoiu8JyafEhJZBjuV032mm9ln7U0
         gRNw3NprR3eyqS3HPy1kUpHZPUWcwOhofEf9VMduHv1wWht6HM6LwdGc73xrJ+cPLC
         xbM44vnkAh1ik7b2NMS1MEpCXsdqxlellWDjWLKO3yt3mfIqnZqeiHEYwF5pV1I6iJ
         4yZU3+qOYhBVjyT3LaUD2EIoWg/Us8KONqg//rT0V7MA6MLXcthrqAvvyjcJo87tvU
         ki3yKs/z0b/9YbQELlkmsGUKYVtyXy3HLACXw5z8B9lhCjr9QDdWpgLvyWK1S6qwNo
         h5zva0Ac1A1pw==
Subject: [PATCH 2/9] misc: add static to various sourcefile-local functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:05 -0800
Message-ID: <166922334592.1572664.17864426624261290357.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
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
index 4186d262940..00e8c8dc6d5 100644
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
index 458a78b83c3..0f1d8b97b05 100644
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
index 9dd0e79c6ba..e219ec166da 100644
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
index c94671d8d18..871b428d7de 100644
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
index ffe7eb33441..78f0914b8d9 100644
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

