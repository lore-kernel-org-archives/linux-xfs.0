Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F86C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiLaC1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiLaC1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:27:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FBF1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C564B81E67
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D80C433F0;
        Sat, 31 Dec 2022 02:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453631;
        bh=ZjDnWwPn+h/VHJn3uoqvAmXCAD6ovoR5HLQb45r5RcM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LGiOh3SV/JVXvKOHdUa3Ur1VJKD12uqHaQvBvD6pi+T/OLQjYEtbK2bTv6L7+AF99
         YENK268as2FJF0P1xTWY2A0CgFDw3bQDG1nbwUBgK5V7s9g+X3rmx9iVsyOJH3wdRj
         mWDuREXUrmueXIIohKRtIM3yEP+/3XGokkcfoHLxH609jpYtDsl3rcXgyUOcyGRxeg
         CKVbyDbXmCfECZ5SCyLBdP7ZOJuKqUj6Y4p0vHFKD84pA1+vjsrm5NeuKhRtRGEeS4
         RBTWPHoy8k5RxjJM6w1KZIbHe8+Anwk3ZyyKW3pLoM0qZH2QxVgLbJqK+pQC9vzDHB
         /Fy0R4Nlh8Vrw==
Subject: [PATCH 2/8] xfs_db: report the device associated with each io cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877638.728317.344770129451526584.stgit@magnolia>
In-Reply-To: <167243877610.728317.12510123562097453242.stgit@magnolia>
References: <167243877610.728317.12510123562097453242.stgit@magnolia>
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
 db/block.c |   16 +++++++++++++++-
 db/io.c    |   46 +++++++++++++++++++++++++++++++++++++++++++---
 db/io.h    |    4 ++++
 3 files changed, 62 insertions(+), 4 deletions(-)


diff --git a/db/block.c b/db/block.c
index 788337d3709..b2b5edf9385 100644
--- a/db/block.c
+++ b/db/block.c
@@ -126,7 +126,17 @@ daddr_f(
 	char		*p;
 
 	if (argc == 1) {
-		dbprintf(_("current daddr is %lld\n"), iocur_top->off >> BBSHIFT);
+		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
+
+		if (iocur_is_ddev(iocur_top))
+			dbprintf(_("datadev daddr is %lld\n"), daddr);
+		else if (iocur_is_extlogdev(iocur_top))
+			dbprintf(_("logdev daddr is %lld\n"), daddr);
+		else if (iocur_is_rtdev(iocur_top))
+			dbprintf(_("rtdev daddr is %lld\n"), daddr);
+		else
+			dbprintf(_("current daddr is %lld\n"), daddr);
+
 		return 0;
 	}
 	d = (int64_t)strtoull(argv[1], &p, 0);
@@ -220,6 +230,10 @@ fsblock_f(
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
index 8688ee8e9c0..00eb5e98dc2 100644
--- a/db/io.c
+++ b/db/io.c
@@ -137,18 +137,58 @@ pop_help(void)
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
+bool
+iocur_is_rtdev(const struct iocur *ioc)
+{
+	if (!ioc->bp)
+		return false;
+
+	return ioc->bp->b_target == ioc->bp->b_mount->m_rtdev_targp;
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
+	else if (iocur_is_rtdev(ioc))
+		block_unit = "rtbno";
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
index 29b22037bd6..1a37ee78c72 100644
--- a/db/io.h
+++ b/db/io.h
@@ -56,6 +56,10 @@ extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
 extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
 
+bool iocur_is_ddev(const struct iocur *ioc);
+bool iocur_is_extlogdev(const struct iocur *ioc);
+bool iocur_is_rtdev(const struct iocur *ioc);
+
 /*
  * returns -1 for unchecked, 0 for bad and 1 for good
  */

