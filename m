Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77576CDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjJSQVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbjJSQVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:21:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE073114
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:21:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A04C433C7;
        Thu, 19 Oct 2023 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732492;
        bh=eVVv9PeW7keGVKPJV/LhXh4JyrcRJOZGe301cfW9w4Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CBGC5ZW19+K73P5x5ypuVIq8mz0huda0T7cNsid+/3b+IvoUIuYMowSz9MF9BXJmN
         F5qjIj25dLufAT1vqFVDP/C13VNgm1jQotX3Wgj3qXd3EQj0/wrp1HgpsWQ472X9kA
         J1WyS4XyeDFlNyYiUErJWfFkRhWdzL6/pDW7DkmasJwEnErIC0+Tn5dbWVFvN4WzUa
         X1xD5BcFiDQIgZS0nAEtteIcL7QZGkvYp9kskRCDY98lkyxfnFO213VP7GsmtNRd9l
         l2LUOtxV8MszqZK4MD0Zuw7/br9ecNsl2Ab066gG8povzT/3XhS6Gyxcj9p/cgCt3d
         9AzPGdSHa+IFg==
Date:   Thu, 19 Oct 2023 09:21:32 -0700
Subject: [PATCH 1/4] xfs: bump max fsgeom struct version
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773209761.223190.385881137548412782.stgit@frogsfrogsfrogs>
In-Reply-To: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
References: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
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

