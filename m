Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C40C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbiLaBGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:06:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D276064F9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72C3D61D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1038C433EF;
        Sat, 31 Dec 2022 01:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448770;
        bh=jmAyw5GmyH2zqW2aAmCcqVxubT1Dk2vXyMCuAnh2CrM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TK92Xyf0v8vi6XmZT6uIKezWBnL6aZuy+TDRjjVR678CE2ublRllIjOoyjMfrKKLW
         dqu0y4rRkkGQtmCnCcgdeknfqePbSvJm9AhynMEIZIP6g2lfryhyF8M7smjHNggkRb
         IMtUAN7YsEGdj0TtBdgVHgIb7F5vUmQofF3p8G7uIIzl8OrJZFtBd//d1LCobyULds
         41CoGiqr4ZZ1vmvpnSqStS+fN7Tlh+z+I/wWaZd+O+QrXi4tfSTNEdyo9FNvK9lGoA
         4NAkO9JSaGVGjckCQZjg9YB0i3UKxdPjRxHh68ZcLGELXOprSHOxMpn32RQc+iSSs2
         ts62TridvVMUA==
Subject: [PATCH 04/20] xfs: hoist project id get/set functions to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:18 -0800
Message-ID: <167243863889.707335.1570079499343467331.stgit@magnolia>
In-Reply-To: <167243863809.707335.15895322495460356300.stgit@magnolia>
References: <167243863809.707335.15895322495460356300.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   11 +++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.h             |    9 ---------
 fs/xfs/xfs_linux.h             |    2 --
 4 files changed, 13 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index ed5e1a9b4b8c..2624d18922c0 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -122,3 +122,14 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+#define XFS_PROJID_DEFAULT	0
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	return XFS_PROJID_DEFAULT;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 6ad1898a0f73..f7e4d5a8235d 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
 uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2f6072d78444..4803904686f5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -255,15 +255,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 	return ret;
 }
 
-static inline prid_t
-xfs_get_initial_prid(struct xfs_inode *dp)
-{
-	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
-		return dp->i_projid;
-
-	return XFS_PROJID_DEFAULT;
-}
-
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 7e9bf03c80a3..2cdb3411aabb 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -134,8 +134,6 @@ typedef __u32			xfs_nlink_t;
  */
 #define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
 
-#define XFS_PROJID_DEFAULT	0
-
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 static inline void delay(long ticks)

