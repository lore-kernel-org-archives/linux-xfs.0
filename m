Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34473C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZBCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D27D12E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E54D061B75
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C04C433EF;
        Fri, 26 May 2023 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062919;
        bh=yfnMDKnwYfFXCtxpTBoDvEu49hIsiyIGMEIIQFZrI1I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=isEavsrhB0kWRyFrfTmQchPIF20oXQyxGrTh0d8SotBZNpJA52UExlwypRk3UxS44
         v65q2AgMEQasLy7qo8E24PF1RtCJATPhRwRGpF6Ge/oCWvmFeWZ3by1g5oLUm2qHCP
         DLcan5VBL0VGLeOxTT/iS7PyXkOELje9JNakoUytMbRtA1aAwVeDN0sdyq2/KK8VHA
         1pUYVzTTLL15NOifLbA4U8Kt3tfOBktmHQUXutS2yLvh3ujrPHcPtCEKu/IEpcuXgj
         oKlT993fScqY0CtU9zRKDrDvWdw/CvPDRJhAG5DXzKKkQQ/xMyl5K2mBy5l9py0uNs
         Ge6+sA1fy5QXA==
Date:   Thu, 25 May 2023 18:01:58 -0700
Subject: [PATCH 07/11] xfs: report symlink block corruption errors to the
 health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060778.3732173.5055067200503338308.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
References: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_symlink.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index bfe81cb50c46..b1d39e7e64cf 100644
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
@@ -102,7 +106,7 @@ xfs_readlink(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsize_t		pathlen;
-	int			error = -EFSCORRUPTED;
+	int			error;
 
 	trace_xfs_readlink(ip);
 
@@ -113,14 +117,14 @@ xfs_readlink(
 
 	pathlen = ip->i_disk_size;
 	if (!pathlen)
-		goto out;
+		goto out_corrupt;
 
 	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		goto out;
+		goto out_corrupt;
 	}
 
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
@@ -129,7 +133,7 @@ xfs_readlink(
 		 * if if_data is junk.
 		 */
 		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
-			goto out;
+			goto out_corrupt;
 
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
 		error = 0;
@@ -137,9 +141,12 @@ xfs_readlink(
 		error = xfs_readlink_bmap_ilocked(ip, link);
 	}
 
- out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return error;
+ out_corrupt:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+	return -EFSCORRUPTED;
 }
 
 int
@@ -494,6 +501,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return -EFSCORRUPTED;
 	}
 

