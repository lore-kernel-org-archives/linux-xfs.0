Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DECEC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5596115B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 21:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhGNV2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235260AbhGNV2P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 17:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85BE461026;
        Wed, 14 Jul 2021 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626297923;
        bh=B7c2lZyY4V06thrmxP9NWG1L0lQo52yoqPNSfhc436c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tB1z4lJp14gn8agoOkcUOC1bVnl6HDAdHz9/SmH33lb/Hsiafmpj9nNy/4w2TaSVp
         43UVVb9vn1mgFThuv2a3Jjqa5VepjKpiwtacl3itPS0YcCFodEOeb2rprrZusQlVfO
         UK2SVH+oNSoDelhxfh3KLlUtFiLFBatdEUiYzzrZ72cAO2W3okYJEtOMD8kuK7Q7nS
         MrwztzimnPWkrLVUFL4wLIKeAoQjQl8KgiDuROh1BYO4z9E+qLokgXHD1clqV4JXkC
         2rcUex4cOKWiLY5lgIUK6jOqgwSLtnp3lcvLpOgVXUtthvfYuCByPg5J8LVKXJewDj
         cJE3O4ynmIzzw==
Subject: [PATCH 1/2] xfs: improve FSGROWFSRT precondition checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 14 Jul 2021 14:25:23 -0700
Message-ID: <162629792325.487242.1728593976863145148.stgit@magnolia>
In-Reply-To: <162629791767.487242.2747879614157558075.stgit@magnolia>
References: <162629791767.487242.2747879614157558075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Improve the checking at the start of a realtime grow operation so that
we avoid accidentally set a new extent size that is too large and avoid
adding an rt volume to a filesystem with rmap or reflink because we
don't support rt rmap or reflink yet.

While we're at it, separate the checks so that we're only testing one
aspect at a time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4e7be6b4ca8e..8f6a05db4468 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -923,16 +923,41 @@ xfs_growfs_rt(
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
-	/*
-	 * Initial error checking.
-	 */
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
-	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
-	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
+
+	/* Needs to have been mounted with an rt device. */
+	if (!XFS_IS_REALTIME_MOUNT(mp))
 		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
+	/*
+	 * Mount should fail if the rt bitmap/summary files don't load, but
+	 * we'll check anyway.
+	 */
+	if (!mp->m_rbmip || !mp->m_rsumip)
+		return -EINVAL;
+
+	/* Shrink not supported. */
+	if (in->newblocks <= sbp->sb_rblocks)
+		return -EINVAL;
+
+	/* Can only change rt extent size when adding rt volume. */
+	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
+		return -EINVAL;
+
+	/* Range check the extent size. */
+	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
+	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
+		return -EINVAL;
+
+	/* Unsupported realtime features. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
+	    xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	nrblocks = in->newblocks;
+	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
+	if (error)
 		return error;
 	/*
 	 * Read in the last block of the device, make sure it exists.

