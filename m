Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1820C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243337AbiDKAeM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiDKAeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:06 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09E5810FCD
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4EE4510CE87D
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMY-88
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pj3-7H
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/17] xfs: convert bmapi flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:35 +1000
Message-Id: <20220411003147.2104423-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=02s9S1tPB9G6Toi5blgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 +++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.h | 36 ++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d53dfe8db8f2..ad938e6e23aa 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -485,7 +485,7 @@ STATIC void
 xfs_bmap_validate_ret(
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
-	int			flags,
+	uint32_t		flags,
 	xfs_bmbt_irec_t		*mval,
 	int			nmap,
 	int			ret_nmap)
@@ -2616,7 +2616,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_btree_cur	**curp,
 	struct xfs_bmbt_irec	*new,
 	int			*logflagsp,
-	int			flags)
+	uint32_t		flags)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -3766,7 +3766,7 @@ xfs_bmapi_trim_map(
 	xfs_fileoff_t		obno,
 	xfs_fileoff_t		end,
 	int			n,
-	int			flags)
+	uint32_t		flags)
 {
 	if ((flags & XFS_BMAPI_ENTIRE) ||
 	    got->br_startoff + got->br_blockcount <= obno) {
@@ -3811,7 +3811,7 @@ xfs_bmapi_update_map(
 	xfs_fileoff_t		obno,
 	xfs_fileoff_t		end,
 	int			*n,
-	int			flags)
+	uint32_t		flags)
 {
 	xfs_bmbt_irec_t	*mval = *map;
 
@@ -3864,7 +3864,7 @@ xfs_bmapi_read(
 	xfs_filblks_t		len,
 	struct xfs_bmbt_irec	*mval,
 	int			*nmap,
-	int			flags)
+	uint32_t		flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(flags);
@@ -4184,7 +4184,7 @@ xfs_bmapi_convert_unwritten(
 	struct xfs_bmalloca	*bma,
 	struct xfs_bmbt_irec	*mval,
 	xfs_filblks_t		len,
-	int			flags)
+	uint32_t		flags)
 {
 	int			whichfork = xfs_bmapi_whichfork(flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
@@ -4312,7 +4312,7 @@ xfs_bmapi_write(
 	struct xfs_inode	*ip,		/* incore inode */
 	xfs_fileoff_t		bno,		/* starting file offs. mapped */
 	xfs_filblks_t		len,		/* length to map in file */
-	int			flags,		/* XFS_BMAPI_... */
+	uint32_t		flags,		/* XFS_BMAPI_... */
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
 	int			*nmap)		/* i/o: mval size/count */
@@ -4629,7 +4629,7 @@ xfs_bmapi_remap(
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
 	xfs_fsblock_t		startblock,
-	int			flags)
+	uint32_t		flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
@@ -4999,7 +4999,7 @@ xfs_bmap_del_extent_real(
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork, /* data or attr fork */
-	int			bflags)	/* bmapi flags */
+	uint32_t		bflags)	/* bmapi flags */
 {
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
@@ -5281,7 +5281,7 @@ __xfs_bunmapi(
 	struct xfs_inode	*ip,		/* incore inode */
 	xfs_fileoff_t		start,		/* first file offset deleted */
 	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
-	int			flags,		/* misc flags */
+	uint32_t		flags,		/* misc flags */
 	xfs_extnum_t		nexts)		/* number of extents max */
 {
 	struct xfs_btree_cur	*cur;		/* bmap btree cursor */
@@ -5609,7 +5609,7 @@ xfs_bunmapi(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		bno,
 	xfs_filblks_t		len,
-	int			flags,
+	uint32_t		flags,
 	xfs_extnum_t		nexts,
 	int			*done)
 {
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 29d38c3c2607..16db95b11589 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -39,7 +39,7 @@ struct xfs_bmalloca {
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
 	int			datatype;/* data type being allocated */
-	int			flags;
+	uint32_t		flags;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -47,17 +47,17 @@ struct xfs_bmalloca {
 /*
  * Flags for xfs_bmapi_*
  */
-#define XFS_BMAPI_ENTIRE	0x001	/* return entire extent, not trimmed */
-#define XFS_BMAPI_METADATA	0x002	/* mapping metadata not user data */
-#define XFS_BMAPI_ATTRFORK	0x004	/* use attribute fork not data */
-#define XFS_BMAPI_PREALLOC	0x008	/* preallocation op: unwritten space */
-#define XFS_BMAPI_CONTIG	0x020	/* must allocate only one extent */
+#define XFS_BMAPI_ENTIRE	(1u << 0) /* return entire extent untrimmed */
+#define XFS_BMAPI_METADATA	(1u << 1) /* mapping metadata not user data */
+#define XFS_BMAPI_ATTRFORK	(1u << 2) /* use attribute fork not data */
+#define XFS_BMAPI_PREALLOC	(1u << 3) /* preallocating unwritten space */
+#define XFS_BMAPI_CONTIG	(1u << 4) /* must allocate only one extent */
 /*
  * unwritten extent conversion - this needs write cache flushing and no additional
  * allocation alignments. When specified with XFS_BMAPI_PREALLOC it converts
  * from written to unwritten, otherwise convert from unwritten to written.
  */
-#define XFS_BMAPI_CONVERT	0x040
+#define XFS_BMAPI_CONVERT	(1u << 5)
 
 /*
  * allocate zeroed extents - this requires all newly allocated user data extents
@@ -65,7 +65,7 @@ struct xfs_bmalloca {
  * Use in conjunction with XFS_BMAPI_CONVERT to convert unwritten extents found
  * during the allocation range to zeroed written extents.
  */
-#define XFS_BMAPI_ZERO		0x080
+#define XFS_BMAPI_ZERO		(1u << 6)
 
 /*
  * Map the inode offset to the block given in ap->firstblock.  Primarily
@@ -75,16 +75,16 @@ struct xfs_bmalloca {
  * For bunmapi, this flag unmaps the range without adjusting quota, reducing
  * refcount, or freeing the blocks.
  */
-#define XFS_BMAPI_REMAP		0x100
+#define XFS_BMAPI_REMAP		(1u << 7)
 
 /* Map something in the CoW fork. */
-#define XFS_BMAPI_COWFORK	0x200
+#define XFS_BMAPI_COWFORK	(1u << 8)
 
 /* Skip online discard of freed extents */
-#define XFS_BMAPI_NODISCARD	0x1000
+#define XFS_BMAPI_NODISCARD	(1u << 9)
 
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
-#define XFS_BMAPI_NORMAP	0x2000
+#define XFS_BMAPI_NORMAP	(1u << 10)
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
@@ -106,7 +106,7 @@ static inline int xfs_bmapi_aflag(int w)
 	       (w == XFS_COW_FORK ? XFS_BMAPI_COWFORK : 0));
 }
 
-static inline int xfs_bmapi_whichfork(int bmapi_flags)
+static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
 {
 	if (bmapi_flags & XFS_BMAPI_COWFORK)
 		return XFS_COW_FORK;
@@ -183,15 +183,15 @@ int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
 		int whichfork);
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
-		int *nmap, int flags);
+		int *nmap, uint32_t flags);
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
+		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
 int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
+		xfs_fileoff_t bno, xfs_filblks_t *rlen, uint32_t flags,
 		xfs_extnum_t nexts);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
-		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
+		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
 int	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
@@ -260,7 +260,7 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
-		int flags);
+		uint32_t flags);
 
 extern struct kmem_cache	*xfs_bmap_intent_cache;
 
-- 
2.35.1

