Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9311CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8AC619D5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhCXOWj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhCXOWL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:22:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BEDC0613DF
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=PHbwRLUpmbZcnRHeM5D0jG/GLCM55TG5PVWgFlU+/Nk=; b=L1VOfjSWQAl86DbjZKg9nm0ylj
        rM+QW2KlmDdDJ4t3dUKkfhW4Cd5TBti1+miFnUXlH6HC0JQFK+uj9pR1jpyzsdGYggcseSd9nLjgc
        a581g0PDUqYiMYeEkDlBtrctTNEoRXwzO2Bil4Vk6IEeOxHX6chTH90C/saSyou8Ar/FoMGlB29y8
        yrWUcVa81NgTThkLwS34x711f7atgqEACqSODWA0VADvdoxUQ+8tfYZGyWPn/PRAM1EaB6h8+oUQO
        LHglXkRgGZ6+snbddpJVPMiueCwu2geNxo3p/q7oWcmlEwLfn1GBf4LJLL/ortoVfNKse+2p8symL
        9tvgvXCQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4Og-0045Y1-Lo
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:22:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/18] xfs: move the di_forkoff field to struct xfs_inode
Date:   Wed, 24 Mar 2021 15:21:26 +0100
Message-Id: <20210324142129.1011766-16-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
forkoff field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 22 +++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.c       | 32 ++++++++++++++++----------------
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
 fs/xfs/libxfs/xfs_inode_fork.h |  4 ++--
 fs/xfs/xfs_icache.c            |  2 +-
 fs/xfs/xfs_inode.c             |  8 ++++----
 fs/xfs/xfs_inode.h             |  1 +
 fs/xfs/xfs_inode_item.c        |  2 +-
 9 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d6ef69ab1c67a5..23e2bf3341a015 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -518,10 +518,10 @@ xfs_attr_copy_value(
  * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
- * Returns zero if not, else the di_forkoff fork offset to be used in the
+ * Returns zero if not, else the i_forkoff fork offset to be used in the
  * literal area for attribute data once the new bytes have been added.
  *
- * di_forkoff must be 8 byte aligned, hence is stored as a >>3 value;
+ * i_forkoff must be 8 byte aligned, hence is stored as a >>3 value;
  * special case for dev/uuid inodes, they have fixed size data forks.
  */
 int
@@ -560,7 +560,7 @@ xfs_attr_shortform_bytesfit(
 	 * literal area rebalancing.
 	 */
 	if (bytes <= XFS_IFORK_ASIZE(dp))
-		return dp->i_d.di_forkoff;
+		return dp->i_forkoff;
 
 	/*
 	 * For attr2 we can try to move the forkoff if there is space in the
@@ -581,7 +581,7 @@ xfs_attr_shortform_bytesfit(
 		 * minimum offset only needs to be the space required for
 		 * the btree root.
 		 */
-		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
+		if (!dp->i_forkoff && dp->i_df.if_bytes >
 		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
@@ -592,10 +592,10 @@ xfs_attr_shortform_bytesfit(
 		 * minforkoff to where the btree root can finish so we have
 		 * plenty of room for attrs
 		 */
-		if (dp->i_d.di_forkoff) {
-			if (offset < dp->i_d.di_forkoff)
+		if (dp->i_forkoff) {
+			if (offset < dp->i_forkoff)
 				return 0;
-			return dp->i_d.di_forkoff;
+			return dp->i_forkoff;
 		}
 		dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
 		break;
@@ -730,7 +730,7 @@ xfs_attr_shortform_add(
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	dp->i_d.di_forkoff = forkoff;
+	dp->i_forkoff = forkoff;
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -770,7 +770,7 @@ xfs_attr_fork_remove(
 	xfs_idestroy_fork(ip->i_afp);
 	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 	ip->i_afp = NULL;
-	ip->i_d.di_forkoff = 0;
+	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
@@ -821,8 +821,8 @@ xfs_attr_shortform_remove(
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
-		ASSERT(dp->i_d.di_forkoff);
+		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
+		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8d4947ffcd4981..de44507f6caa54 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -66,13 +66,13 @@ xfs_bmap_compute_maxlevels(
 	 * either a signed 32-bit number for the data fork, or a signed 16-bit
 	 * number for the attr fork.
 	 *
-	 * Note that we can no longer assume that if we are in ATTR1 that
-	 * the fork offset of all the inodes will be
-	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted
-	 * with ATTR2 and then mounted back with ATTR1, keeping the
-	 * di_forkoff's fixed but probably at various positions. Therefore,
-	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
-	 * of a minimum size available.
+	 * Note that we can no longer assume that if we are in ATTR1 that the
+	 * fork offset of all the inodes will be
+	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted with
+	 * ATTR2 and then mounted back with ATTR1, keeping the i_forkoff's fixed
+	 * but probably at various positions. Therefore, for both ATTR1 and
+	 * ATTR2 we have to assume the worst case scenario of a minimum size
+	 * available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
 		maxleafents = MAXEXTNUM;
@@ -205,9 +205,9 @@ xfs_default_attroffset(
 }
 
 /*
- * Helper routine to reset inode di_forkoff field when switching
- * attribute fork from local to extent format - we reset it where
- * possible to make space available for inline data fork extents.
+ * Helper routine to reset inode i_forkoff field when switching attribute fork
+ * from local to extent format - we reset it where possible to make space
+ * available for inline data fork extents.
  */
 STATIC void
 xfs_bmap_forkoff_reset(
@@ -219,8 +219,8 @@ xfs_bmap_forkoff_reset(
 	    ip->i_df.if_format != XFS_DINODE_FMT_BTREE) {
 		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
 
-		if (dfl_forkoff > ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = dfl_forkoff;
+		if (dfl_forkoff > ip->i_forkoff)
+			ip->i_forkoff = dfl_forkoff;
 	}
 }
 
@@ -1036,14 +1036,14 @@ xfs_bmap_set_attrforkoff(
 {
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		ip->i_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_forkoff)
+			ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
 			*version = 2;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 96db2649f6b2fe..0ce936368e9a4f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -230,7 +230,7 @@ xfs_inode_from_disk(
 	ip->i_disk_size = be64_to_cpu(from->di_size);
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
-	to->di_forkoff = from->di_forkoff;
+	ip->i_forkoff = from->di_forkoff;
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
 	if (from->di_dmevmask || from->di_dmstate)
@@ -311,7 +311,7 @@ xfs_inode_to_disk(
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
-	to->di_forkoff = from->di_forkoff;
+	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = cpu_to_be16(from->di_flags);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index e41a11bef04436..39f4ad4419fe41 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	uint64_t	di_flags2;	/* more random flags */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 9e2137cd73724b..115841c0f532af 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -99,8 +99,8 @@ struct xfs_ifork {
  * Fork handling.
  */
 
-#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
+#define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
+#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
 
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5c68e3069a8783..3f856a4af428c6 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -65,7 +65,7 @@ xfs_inode_alloc(
 	ip->i_delayed_blks = 0;
 	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_nblocks = 0;
-	ip->i_d.di_forkoff = 0;
+	ip->i_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b4b6fddccd1ca0..455be367b18bfc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1740,7 +1740,7 @@ xfs_inactive(
 	}
 
 	ASSERT(!ip->i_afp);
-	ASSERT(ip->i_d.di_forkoff == 0);
+	ASSERT(ip->i_forkoff == 0);
 
 	/*
 	 * Free the inode.
@@ -2589,7 +2589,7 @@ xfs_ifree(
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_flags2 = ip->i_mount->m_ino_geo.new_diflags2;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IDMAPI))
 		xfs_iflags_clear(ip, XFS_IDMAPI);
@@ -3421,11 +3421,11 @@ xfs_iflush(
 			ip->i_nblocks, ip);
 		goto flush_out;
 	}
-	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
+	if (XFS_TEST_ERROR(ip->i_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
-			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
+			__func__, ip->i_ino, ip->i_forkoff, ip);
 		goto flush_out;
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7ba0ffa50ede20..195eb45d333441 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -63,6 +63,7 @@ typedef struct xfs_inode {
 		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
+	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 091436857ee74b..77295948cd2997 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -374,7 +374,7 @@ xfs_inode_to_log_dinode(
 	to->di_extsize = ip->i_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
-	to->di_forkoff = from->di_forkoff;
+	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_flags = from->di_flags;
 
-- 
2.30.1

