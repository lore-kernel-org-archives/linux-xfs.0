Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE8CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbiLaBUb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiLaBUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:20:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8D91CB3B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A822B81DFB
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9E4C433EF;
        Sat, 31 Dec 2022 01:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449627;
        bh=efSdDODCf/QkCrq3NY3/V/0NH+3/0LG3RGeRI/wHmaE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EidzIcJGzS7iWFgxwoiyCYdtEy2hY831GhboZKudNhjo6ZWKP4a0ezyyrv1rt+xBS
         B4Ysa4UVDPQwySBrHs+SXnpFFFdKuz01OFHXSkI7L4ZnSkkOns8SiDUxv5ad4LkVKE
         kglADYLBRhvamUsOq+4rxqROfp3XMH0RsE1uoiQFZ9HTUCMPO8VKn8tqgcbcPLGzrA
         eeeK1xBs222J1EyY1i5yE80djbS/mEHYVEIUwRcPFcNoV686eTi9P6tXgc1zBGR/07
         JZhYhN9Ru/dPNFMzf1AOd+N+3ZNa6P2anDVgV5jYnmMIQ4Zjf78V+2MyOBOkWQcMUs
         ljT1xkEn/P0Tw==
Subject: [PATCH 02/11] xfs: bump max fsgeom struct version
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:36 -0800
Message-ID: <167243865645.709511.13593751767841627621.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
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

