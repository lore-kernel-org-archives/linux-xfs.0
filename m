Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15369CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbjJQPrG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjJQPrF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:47:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AACCF0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:47:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00537C433C9;
        Tue, 17 Oct 2023 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557624;
        bh=eVVv9PeW7keGVKPJV/LhXh4JyrcRJOZGe301cfW9w4Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XkP1jI1l0lF/qy1LHvABtvxTdR245B359klCT1I9Dsd6rp/cWc1Vw0Qcl3zy9KtOm
         4zJRGHlll6pseaFkiGxgJHhoWGliZTsO88Yjf14hxQEkl/YdnAKgtYeP5SQ6/NdvqN
         uW2bIFZ7wtaJEHIgdVZCk8Rnhhb/RZew08J2jFta8ws8+PxlvylAiFwnXiKSoCIGV3
         tI1jqQA95E1+imWG/RjMagXSwlioNlYyPX82wOtO/D5lzi7VydRJE10f0tmR5XAVXp
         WhrD3olW61OBe+SrOFLsCvz6EGcFFgK5E7X3Jaqd4WirG0JatCFndplH4crkKfwUiu
         1HBQeQ6dGBoRA==
Date:   Tue, 17 Oct 2023 08:47:03 -0700
Subject: [PATCH 1/4] xfs: bump max fsgeom struct version
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755740913.3165385.13445742878905999011.stgit@frogsfrogsfrogs>
In-Reply-To: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
References: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..19134b23c10b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,

