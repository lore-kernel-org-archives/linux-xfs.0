Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C428CDB470
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjJKSCJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjJKSCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:02:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D86994
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:02:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD51C433C8;
        Wed, 11 Oct 2023 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047324;
        bh=VsdlCD6Q+pBjdkqPxpa9hcz7LwpAn5tB5s4I410ZRBE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Lgtk7+ofI2bXdZdXxRUUKo3lJrK1uaMIHptXMmOpjj0SRWFtgLEYtXk4LoBnM+bbX
         PZuxthhlNBm9KGIxHoLGxIXow3Sh86uVP7HFYjE/4dogkO/q2na6aNlA6SETXk+s+P
         uiurIjYEsFwDB+hH/+QWcXLbJbTgVyLDZ2XI/l/DVLHtujw1A7ap0LKAcsdjXk0W3t
         MI1HvG+1flGxw0sxrkdAU6VMtWd4tyaWK0KpGmHGGOOSVvwHQNrBEokoySyrcYxcCV
         4U6IpAOiV0wBiCW9RWp7Wzm9d98IRLVFUHA4c8eXia3fwcuVXHXu533oeqibxZV/KJ
         e71sUJ4ajE5/g==
Date:   Wed, 11 Oct 2023 11:02:03 -0700
Subject: [PATCH 1/3] xfs: bump max fsgeom struct version
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720351.1773263.12324560217170051519.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The latest version of the fs geometry structure is v5.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9ac..19134b23c10be 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,

