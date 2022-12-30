Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AE4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiL3Xid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiL3Xic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:38:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D3D1DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AF42B81DA0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19313C433EF;
        Fri, 30 Dec 2022 23:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443509;
        bh=8fV5zYKpelZvfCPxqcROytQ9IBpopzgW5y8g0/Ms7s8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kr97r2onAQd7ro1tL98NSr6d3uwd3awEvyUStNmyjgZduI/J/eY9h3EbEFG3TCPzd
         e5ms5d33cOUa8dag5BGCXkVNi2iOX8mnX4NwOf6CKNPSzoDEbG4aCJRfrW7iLz9888
         sgDQKPU4m6tt2WPNy2EGKj2dnXiXKPCyrZNdgJIrF7qmUObKtzgAQc8HZbs3XTnZhe
         50F3PxgvLCb2b4gTwDHDcXean2qPUj//tPl1l+P//fhVy7f/8FxOKlXf6bVLDUwNo6
         buxJpP8RL8j2u1wsqHwYNIlcWXymoHEEeI6FQO+4QX8K+8aolSctGqKL6okaqFYB6E
         l/hsCTiGWekSg==
Subject: [PATCH 07/11] xfs: report symlink block corruption errors to the
 health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:15 -0800
Message-ID: <167243839561.695999.5420811376124648584.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt symbolic link blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_symlink.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8241c0fcd0ba..90de8991cd94 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -23,6 +23,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -57,6 +58,8 @@ xfs_readlink_bmap_ilocked(
 
 		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
 				&bp, &xfs_symlink_buf_ops);
+		if (xfs_metadata_is_sick(error))
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		if (error)
 			return error;
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
@@ -67,6 +70,7 @@ xfs_readlink_bmap_ilocked(
 		if (xfs_has_crc(mp)) {
 			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 				error = -EFSCORRUPTED;
 				xfs_alert(mp,
 "symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
@@ -120,6 +124,7 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		goto out;
 	}
 
@@ -128,8 +133,10 @@ xfs_readlink(
 		 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED
 		 * if if_data is junk.
 		 */
-		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
+		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data)) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 			goto out;
+		}
 
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
 		error = 0;
@@ -139,6 +146,8 @@ xfs_readlink(
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error == -EFSCORRUPTED)
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 	return error;
 }
 
@@ -494,6 +503,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return -EFSCORRUPTED;
 	}
 

