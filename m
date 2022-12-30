Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E05C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiLaAVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiLaAVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:21:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F7D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9180CB81E7C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C74C433D2;
        Sat, 31 Dec 2022 00:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446078;
        bh=sO5eVoWfMoXrsKN5eCPm83SoXD5q+xtTebDdFQTOGq8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cAGi/1ymQqYJ+Er0Jz33dq0yNjJPYiGjHNRlopCc595sVld49xGjGHjVpNdn/415d
         o9uVNmc6i1lcNJEbNlBZ43URcAsh4CnnC2UycTrylzGB0xl4O2GIHTnMVFfhv2/+kc
         jkr7Wss4owjWCQYOxJ779rq+/U1/NzS53e4btQt5n8WBeIKeW+ElcjnPmSPgfcfg32
         2lvUJJPnQ4syNf6rUWQ7IU2xAchy7/3MO+k2LTUZtJnfP5OWm7riMUEKKbjZ8gftzi
         QKqPcbls82wjecmuZLOtSofEfW6AOKw8h/9ROok5p4RyBA/XzP3h4EUMCk2rgyuIij
         i5bZiynKxO9zg==
Subject: [PATCH 10/19] xfs: make atomic extent swapping support realtime files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:00 -0800
Message-ID: <167243868069.713817.1091572867089358356.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that bmap items support the realtime device, we can add the
necessary pieces to the atomic extent swapping code to support such
things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |    5 ++
 libxfs/xfs_swapext.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_swapext.h |    5 +-
 3 files changed, 110 insertions(+), 9 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index b0bba1094e7..489fd7d107d 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -232,6 +232,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_bigrtextents(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index e439b938f10..9be29f610f2 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -140,6 +140,108 @@ sxi_advance(
 	sxi->sxi_blockcount -= irec->br_blockcount;
 }
 
+#ifdef DEBUG
+static inline bool
+xfs_swapext_need_rt_conversion(
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_inode		*ip = req->ip2;
+	struct xfs_mount		*mp = ip->i_mount;
+
+	/* xattrs don't live on the rt device */
+	if (req->whichfork == XFS_ATTR_FORK)
+		return false;
+
+	/*
+	 * Caller got permission to use logged swapext, so log recovery will
+	 * finish the swap and not leave us with partially swapped rt extents
+	 * exposed to userspace.
+	 */
+	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
+		return false;
+
+	/*
+	 * If we can't use log intent items at all, the only supported
+	 * operation is full fork swaps.
+	 */
+	if (!xfs_swapext_supported(mp))
+		return false;
+
+	/* Conversion is only needed for realtime files with big rt extents */
+	return xfs_inode_has_bigrtextents(ip);
+}
+
+static inline int
+xfs_swapext_check_rt_extents(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_bmbt_irec		irec1, irec2;
+	xfs_fileoff_t			startoff1 = req->startoff1;
+	xfs_fileoff_t			startoff2 = req->startoff2;
+	xfs_filblks_t			blockcount = req->blockcount;
+	uint32_t			mod;
+	int				nimaps;
+	int				error;
+
+	if (!xfs_swapext_need_rt_conversion(req))
+		return 0;
+
+	while (blockcount > 0) {
+		/* Read extent from the first file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip1, startoff1, blockcount,
+				&irec1, &nimaps, 0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/* Read extent from the second file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip2, startoff2,
+				irec1.br_blockcount, &irec2, &nimaps,
+				0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/*
+		 * We can only swap as many blocks as the smaller of the two
+		 * extent maps.
+		 */
+		irec1.br_blockcount = min(irec1.br_blockcount,
+					  irec2.br_blockcount);
+
+		/* Both mappings must be aligned to the realtime extent size. */
+		div_u64_rem(irec1.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		div_u64_rem(irec2.br_startoff, mp->m_sb.sb_rextsize, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		div_u64_rem(irec1.br_blockcount, mp->m_sb.sb_rextsize, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		startoff1 += irec1.br_blockcount;
+		startoff2 += irec1.br_blockcount;
+		blockcount -= irec1.br_blockcount;
+	}
+
+	return 0;
+}
+#else
+# define xfs_swapext_check_rt_extents(mp, req)		(0)
+#endif
+
 /* Check all extents to make sure we can actually swap them. */
 int
 xfs_swapext_check_extents(
@@ -159,12 +261,7 @@ xfs_swapext_check_extents(
 	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
-	/* We don't support realtime data forks yet. */
-	if (!XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
-	if (req->whichfork == XFS_ATTR_FORK)
-		return 0;
-	return -EINVAL;
+	return xfs_swapext_check_rt_extents(mp, req);
 }
 
 #ifdef CONFIG_XFS_QUOTA
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index 6b610fea150..155add23d8e 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -13,12 +13,11 @@
  * This can be done to individual file extents by using the block mapping log
  * intent items introduced with reflink and rmap; or to entire file ranges
  * using swapext log intent items to track the overall progress across multiple
- * extent mappings.  Realtime is not supported yet.
+ * extent mappings.
  */
 static inline bool xfs_swapext_supported(struct xfs_mount *mp)
 {
-	return (xfs_has_reflink(mp) || xfs_has_rmapbt(mp)) &&
-	       !xfs_has_realtime(mp);
+	return xfs_has_reflink(mp) || xfs_has_rmapbt(mp);
 }
 
 /*

