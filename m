Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FD5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbiLaAGt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiLaAGt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:06:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0091F1CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:06:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8187B81DEE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F9BC433D2;
        Sat, 31 Dec 2022 00:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445205;
        bh=vOamtiEnmON4NcN0z0Dilr2Z+wQCu3i84dOmjmfD3kU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RZONyqm+/Mh63d12NrYDpQfmHCizqgswukHp9XdNo3RuCS4ZbiHCn7daBOpGxxspr
         Ac8Rn4UsUMF+JTHvh6PmkaLI38UF5TdE8PHDeTYWkVIew8uNubqNR4M8/rCFIQ60tJ
         b4rHjLjBDnLzT4og5CilIhCUcHng0u1cwxJeBd1gpnPKlOwGVS0mac/kmihl4E7XV6
         BjQs7+BqiBAZA2uQ3psraljIwuYhP9n8LetD3GGJ6nD1Qu8QREZGBDaDs93uRLgtvm
         OfLrJHJesD7FDO77ByZjmYt9udlUfIOfxuUxOfRottov+J795U47nPs0/i2LttVw2z
         OPn9kHVQCJCDw==
Subject: [PATCH 2/3] xfs_io: support passing the FORCE_REBUILD flag to online
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:22 -0800
Message-ID: <167243864278.707991.18074766242840502279.stgit@magnolia>
In-Reply-To: <167243864252.707991.14471233385651088983.stgit@magnolia>
References: <167243864252.707991.14471233385651088983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add CLI options to the scrubv and repair commands so that the user can
pass FORCE_REBUILD to force the kernel to rebuild metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |   22 +++++++++++++++-------
 man/man8/xfs_io.8 |    3 +++
 2 files changed, 18 insertions(+), 7 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index fc22ba49f8b..a74e65fbe8d 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -46,7 +46,8 @@ scrub_ioctl(
 	int				fd,
 	int				type,
 	uint64_t			control,
-	uint32_t			control2)
+	uint32_t			control2,
+	uint32_t			flags)
 {
 	struct xfs_scrub_metadata	meta;
 	const struct xfrog_scrub_descr	*sc;
@@ -69,7 +70,7 @@ scrub_ioctl(
 		/* no control parameters */
 		break;
 	}
-	meta.sm_flags = 0;
+	meta.sm_flags = flags;
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error)
@@ -91,17 +92,21 @@ parse_args(
 	int				argc,
 	char				**argv,
 	struct cmdinfo			*cmdinfo,
-	void				(*fn)(int, int, uint64_t, uint32_t))
+	void				(*fn)(int, int, uint64_t, uint32_t, uint32_t))
 {
 	char				*p;
 	int				type = -1;
 	int				i, c;
 	uint64_t			control = 0;
 	uint32_t			control2 = 0;
+	uint32_t			flags = 0;
 	const struct xfrog_scrub_descr	*d = NULL;
 
-	while ((c = getopt(argc, argv, "")) != EOF) {
+	while ((c = getopt(argc, argv, "R")) != EOF) {
 		switch (c) {
+		case 'R':
+			flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
+			break;
 		default:
 			return command_usage(cmdinfo);
 		}
@@ -173,7 +178,7 @@ parse_args(
 		ASSERT(0);
 		break;
 	}
-	fn(file->fd, type, control, control2);
+	fn(file->fd, type, control, control2, flags);
 
 	return 0;
 }
@@ -216,6 +221,8 @@ repair_help(void)
 " or (optionally) take an inode number and generation number to act upon as\n"
 " the second and third parameters.\n"
 "\n"
+" Flags are -R to rebuild metadata.\n"
+"\n"
 " Example:\n"
 " 'repair inobt 3' - repairs the inode btree in AG 3.\n"
 " 'repair bmapbtd 128 13525' - repairs the extent map of inode 128 gen 13525.\n"
@@ -231,7 +238,8 @@ repair_ioctl(
 	int				fd,
 	int				type,
 	uint64_t			control,
-	uint32_t			control2)
+	uint32_t			control2,
+	uint32_t			flags)
 {
 	struct xfs_scrub_metadata	meta;
 	const struct xfrog_scrub_descr	*sc;
@@ -254,7 +262,7 @@ repair_ioctl(
 		/* no control parameters */
 		break;
 	}
-	meta.sm_flags = XFS_SCRUB_IFLAG_REPAIR;
+	meta.sm_flags = flags | XFS_SCRUB_IFLAG_REPAIR;
 
 	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error)
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 223b5152314..ae8d0245d87 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1340,6 +1340,9 @@ parameter specifies which type of metadata to repair.
 For AG metadata, one AG number must be specified.
 For file metadata, the repair is applied to the open file unless the
 inode number and generation number are specified.
+The
+.B -R
+option can be specified to force rebuilding of a metadata structure.
 .TP
 .BI "label" " " "[ -c | -s " label " ] "
 On filesystems that support online label manipulation, get, set, or clear the

