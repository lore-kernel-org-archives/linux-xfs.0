Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101A8C61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjKVXHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbjKVXHP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6007D8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:11 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8541EC433C8;
        Wed, 22 Nov 2023 23:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694431;
        bh=dhK3q9PbxQv5ehBQjgceYAUCcBZAHPlw+ZJKXeAFQHY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a9jDqJAPh5GhcnX9Oin+LpWhRWiWQ4mtNJNBt1roj+WlcuntEEa/DoY9O3yN5UVWb
         ieo8jaG4MPUPTLR6PYkFcnOW55DWnvPUdwwibzmF8oE+Hzl3D7zxfzOlyVLP5nMmGV
         oNCIa4rJdtvmhSCSGIcI9n6dagRvBaP/Oq0V57DAPTs9hRSytCdxs1F7QwgO2eYTuu
         citiNpM5p8X2ODXzDJj6pFM7Pr1VnWIkvW7zAEXT6sWp42GQ6tV5oQNQ+72FHyyBAV
         Vlmxk5zeLha7e0vSEC+Ca7g0PpJu9RtHhm6GCAMgVoxbODgM9CM8j03HXH/OHLeOhy
         4460U+ekswGMg==
Subject: [PATCH 4/9] xfs_db: report the device associated with each io cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:10 -0800
Message-ID: <170069443096.1865809.13119575401747000666.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When db is reporting on an io cursor, have it print out the device
that the cursor is pointing to.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |   14 +++++++++++++-
 db/io.c    |   35 ++++++++++++++++++++++++++++++++---
 db/io.h    |    3 +++
 3 files changed, 48 insertions(+), 4 deletions(-)


diff --git a/db/block.c b/db/block.c
index 788337d3709..d730c779671 100644
--- a/db/block.c
+++ b/db/block.c
@@ -126,7 +126,15 @@ daddr_f(
 	char		*p;
 
 	if (argc == 1) {
-		dbprintf(_("current daddr is %lld\n"), iocur_top->off >> BBSHIFT);
+		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
+
+		if (iocur_is_ddev(iocur_top))
+			dbprintf(_("datadev daddr is %lld\n"), daddr);
+		else if (iocur_is_extlogdev(iocur_top))
+			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else
+			dbprintf(_("current daddr is %lld\n"), daddr);
+
 		return 0;
 	}
 	d = (int64_t)strtoull(argv[1], &p, 0);
@@ -220,6 +228,10 @@ fsblock_f(
 	char		*p;
 
 	if (argc == 1) {
+		if (!iocur_is_ddev(iocur_top)) {
+			dbprintf(_("cursor does not point to data device\n"));
+			return 0;
+		}
 		dbprintf(_("current fsblock is %lld\n"),
 			XFS_DADDR_TO_FSB(mp, iocur_top->off >> BBSHIFT));
 		return 0;
diff --git a/db/io.c b/db/io.c
index 5ccfe3b536a..590dd1f82f7 100644
--- a/db/io.c
+++ b/db/io.c
@@ -137,18 +137,47 @@ pop_help(void)
 		));
 }
 
+bool
+iocur_is_ddev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_ddev_targp;
+}
+
+bool
+iocur_is_extlogdev(const struct iocur *ioc)
+{
+	struct xfs_buf	*bp = ioc->bp;
+
+	if (!bp)
+		return false;
+	if (bp->b_mount->m_logdev_targp == bp->b_mount->m_ddev_targp)
+		return false;
+
+	return bp->b_target == bp->b_mount->m_logdev_targp;
+}
+
 void
 print_iocur(
 	char	*tag,
 	iocur_t	*ioc)
 {
+	const char	*block_unit = "fsbno?";
 	int	i;
 
+	if (iocur_is_ddev(ioc))
+		block_unit = "fsbno";
+	else if (iocur_is_extlogdev(ioc))
+		block_unit = "logbno";
+
 	dbprintf("%s\n", tag);
 	dbprintf(_("\tbyte offset %lld, length %d\n"), ioc->off, ioc->len);
-	dbprintf(_("\tbuffer block %lld (fsbno %lld), %d bb%s\n"), ioc->bb,
-		(xfs_fsblock_t)XFS_DADDR_TO_FSB(mp, ioc->bb), ioc->blen,
-		ioc->blen == 1 ? "" : "s");
+	dbprintf(_("\tbuffer block %lld (%s %lld), %d bb%s\n"), ioc->bb,
+			block_unit,
+			(xfs_fsblock_t)XFS_DADDR_TO_FSB(mp, ioc->bb),
+			ioc->blen, ioc->blen == 1 ? "" : "s");
 	if (ioc->bbmap) {
 		dbprintf(_("\tblock map"));
 		for (i = 0; i < ioc->bbmap->nmaps; i++)
diff --git a/db/io.h b/db/io.h
index bd86c31f67e..f48b67b47a2 100644
--- a/db/io.h
+++ b/db/io.h
@@ -56,6 +56,9 @@ extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
 extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
+bool iocur_is_ddev(const struct iocur *ioc);
+bool iocur_is_extlogdev(const struct iocur *ioc);
+
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
  */

