Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F262BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiLaBFm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiLaBFl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:05:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2491DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4783D61D33
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DEEC433D2;
        Sat, 31 Dec 2022 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448739;
        bh=XdpvGRV9WB9ZqwfELpTJM9zIM+ySxXLtK1IuKZrHDW4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QDZjUOUEsky/OoIC1M24Qg2BWDbJh+nfpGOTjTb3qbl9FbznxMxd8rmR/d3nKrmZC
         /eDoBYLvR/IXN+hnXyLUXx4s3Ea0n73sHbzytpC30ierVhX8AHnQtwIGswE0OwK9U2
         GddKR5CfIhveH4hgDBBN+3McM0O0IYwvnJ2+5aeXkUaQYtzsGFK+BxK54PKsA1QIeL
         TLG+1+/0oevmcL/XPZZf/mef4hhG5alEeeam1RniMm1Y2WttY5Vjft2CJ7xk8T6d3d
         Q42ortzQkBLt2s0c7WGqq3ivldjC5lOxXeRYPCHLaA8WdtKhbU6HcLOztZc/2IcbPw
         rE35fxiG4S0uA==
Subject: [PATCH 02/20] xfs: hoist extent size helpers to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:18 -0800
Message-ID: <167243863859.707335.7535230585116837700.stgit@magnolia>
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

Move the extent size helpers to xfs_bmap.c in libxfs since they're used
there already.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   43 -------------------------------------------
 fs/xfs/xfs_inode.h       |    3 ---
 fs/xfs/xfs_iops.c        |    1 +
 5 files changed, 45 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0dfa84993a9e..5224e3fcce83 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6413,3 +6413,44 @@ xfs_bmap_query_all(
 
 	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
 }
+
+/* Helper function to extract extent size hint from inode */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
+	if (XFS_IS_REALTIME_INODE(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 9559f7174bba..d870c6a62e40 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -292,4 +292,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index abf8844df017..a4a3ca9a3ea6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -45,49 +45,6 @@ struct kmem_cache *xfs_inode_cache;
 STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 	struct xfs_inode *);
 
-/*
- * helper function to extract extent size hint from inode
- */
-xfs_extlen_t
-xfs_get_extsz_hint(
-	struct xfs_inode	*ip)
-{
-	/*
-	 * No point in aligning allocations if we need to COW to actually
-	 * write to them.
-	 */
-	if (xfs_is_always_cow_inode(ip))
-		return 0;
-	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
-		return ip->i_extsize;
-	if (XFS_IS_REALTIME_INODE(ip))
-		return ip->i_mount->m_sb.sb_rextsize;
-	return 0;
-}
-
-/*
- * Helper function to extract CoW extent size hint from inode.
- * Between the extent size hint and the CoW extent size hint, we
- * return the greater of the two.  If the value is zero (automatic),
- * use the default size.
- */
-xfs_extlen_t
-xfs_get_cowextsz_hint(
-	struct xfs_inode	*ip)
-{
-	xfs_extlen_t		a, b;
-
-	a = 0;
-	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_cowextsize;
-	b = xfs_get_extsz_hint(ip);
-
-	a = max(a, b);
-	if (a == 0)
-		return XFS_DEFAULT_COWEXTSZ_HINT;
-	return a;
-}
-
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
  * centralize some grungy code.  They are used in places that wish to lock the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 926f2d74413c..adcdc369396a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -532,9 +532,6 @@ int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
-xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
-
 int xfs_init_new_inode(struct user_namespace *mnt_userns, struct xfs_trans *tp,
 		struct xfs_inode *pip, xfs_ino_t ino, umode_t mode,
 		xfs_nlink_t nlink, dev_t rdev, prid_t prid, bool init_xattrs,
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a24bf6bb5094..80f881c69336 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -25,6 +25,7 @@
 #include "xfs_error.h"
 #include "xfs_ioctl.h"
 #include "xfs_xattr.h"
+#include "xfs_bmap.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>

