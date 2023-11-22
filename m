Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45CEC27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjKVXHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbjKVXHx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C340DD8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B7C433C8;
        Wed, 22 Nov 2023 23:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694469;
        bh=duKkXNy50jqrbLCf8pKCyhaTBbK4YxoSEIWtnyFZAxY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dPdqIaCeBQJDyk+k+0PUcH+Ml9RhZ47Rf+AcmGUAbidHudZlhIWuspp9FSvdrCP1D
         Ye/b5OreuHV9ZSAqoClaDGsFQ4bl33cPaNq1MQY6O/N2/upakVZLN8IDPjj91t6/ux
         cyysqijZw33rHgpQfC6NGQBdpAJqIFW9UOdDz/RPhWDiq0uk1xK2Ij5tGemGq/kl4M
         XmCkHc0hfP2qDaN4J1iS2bwPr8JE33Jjh4OHR2Ahq6mZOoaTsx1hfgg8VjiRrqH8El
         VZ09IoIWJaguMosr/7zlKt9m64li7gN0mOh5Lf8t99RiJ9EqFsMbxAhWr99WodLl4B
         ttnC+VKNm/BAQ==
Subject: [PATCH 1/4] xfs_io: support passing the FORCE_REBUILD flag to online
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:48 -0800
Message-ID: <170069446896.1867812.14957304624227632832.stgit@frogsfrogsfrogs>
In-Reply-To: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

