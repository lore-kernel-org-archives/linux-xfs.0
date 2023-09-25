Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEF4CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjIYV67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV66 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0FE11C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D51CC433C7;
        Mon, 25 Sep 2023 21:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679130;
        bh=Y814CETZezRclqWmENT4srWR6cFI11kV6NhWgf4TUDA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MrdnEbrVvvc9/zSBN7cJHzuTVL7jAO3Uk7AgKpIuGSZfhnKv0UlhUh51axIYcCPeK
         Sve6SBKYSVLv8tB3N6UKv6Y4urkE0PT9Nu2+lo6QezM9enBYrYQCeDvh/TjrplcJeo
         1A8jP7XRJeEf4+U5zioB0iWcan07lwWNm7y9NMBCnZ2Trt7CpBwjUUsjQqE8atKSIx
         4yGfHE/rhmTCpB4ZCaKY0PV/K+yKWgcivf0nNkR4g7NjG6nnVuMWabP5nD5aZuDTR4
         R1BzKYGDFgolhHDYBVCS1O7r3FXstXmhJF2O95OjSN++fvVI6qkvDqjPMks1WnpnDv
         /A7Y9uK5d7gGg==
Subject: [PATCH 1/3] xfs_io: support passing the FORCE_REBUILD flag to online
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:49 -0700
Message-ID: <169567912995.2320149.4634874093845147114.stgit@frogsfrogsfrogs>
In-Reply-To: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
References: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
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
 io/scrub.c        |   24 ++++++++++++++++--------
 man/man8/xfs_io.8 |    3 +++
 2 files changed, 19 insertions(+), 8 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index fc22ba49f8b..dbdedf10099 100644
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
@@ -216,11 +221,13 @@ repair_help(void)
 " or (optionally) take an inode number and generation number to act upon as\n"
 " the second and third parameters.\n"
 "\n"
+" Flags are -R to force rebuilding metadata.\n"
+"\n"
 " Example:\n"
 " 'repair inobt 3' - repairs the inode btree in AG 3.\n"
 " 'repair bmapbtd 128 13525' - repairs the extent map of inode 128 gen 13525.\n"
 "\n"
-" Known metadata repairs types are:"));
+" Known metadata repair types are:"));
 	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
 	printf("\n");
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
index ef7087b3d09..d46dc369a06 100644
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

