Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88DD24DCF6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311851; cv=none; b=lOnnZsiUqEKszMQbz9lrYuPhwVETTHWVo1Ez8+oD/XOMkRDg4cNgbzsMxJ4n8FOJv93PTZ5wrSVgdTckPZ4hV/NTqJRCEM1EkQHzTAd6SddTolATi04lsuaZU+6Uhwl0bGHp6K6u/jhPikSEhy4uo/lfwfmoMqLYqZsHMaziyoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311851; c=relaxed/simple;
	bh=4MlB4miwX2TWGnYWFrYxhMhjb81PJDSxjONQuSsWZsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVRCyaloIWoEGn25VUKfVdAaGiKm2rNT0DyCW42xTw3pGFcaz+FVLRJ5sxZfX1ZvVje3Bkgj6/eKRiQ2hmCgdTQvJC+lJoPoWLx4wNHk57D+Wwk14MFqSwBNu/PcCIZcU7zkvNPmLcr7cCYKID4tV0vv65g43J2GWI5FD50qceM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o809A8g4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o809A8g4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VhI/Sdo2vv7SxWr2bEFhJhtTQfURAfu8QP9eWpAzc9E=; b=o809A8g4TyC5f48h+TbU2nCIsp
	qVB7sdUXaNPwLVhMqAPTyG2XLXh9lL0sNdqT2w5yxu5l8INsmc346aOPGkjgQV41JQy6cqSEA3IPR
	JplJqU0wtxTnT2pWQNYsCt/pyHEwtzxBEEpbK+C0mj4jimtPwJueHf2sPQ3JwCeWRpEq1AwmGFnzm
	Ze1xzb8jKB/ZHf0ymMJvnWWtBv80aTkfarIwJsKCS0ywLApvKeH8i5W9aOy8VfROZeohhi4DW+UO7
	pL3oSEvBTNRIt02sGlDK4XBfctK9t9KE/HCksRxCkNvCnU+kC5zZ2ss+OwBoxHAyCmG5gKraC5R3w
	GE1XIQKw==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs6i-000000003EF-3ser;
	Fri, 28 Nov 2025 06:37:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] repair: add a enum for the XR_INO_* values
Date: Fri, 28 Nov 2025 07:36:59 +0100
Message-ID: <20251128063719.1495736-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063719.1495736-1-hch@lst.de>
References: <20251128063719.1495736-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the XR_INO_ definitions into dinode.c as they aren't used anywhere
else, and turn them into an enum to improve type safety.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c | 52 +++++++++++++++++++++++++++++++++++--------------
 repair/incore.h | 19 ------------------
 2 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 8ca0aa0238c7..b824dfc0a59f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -23,6 +23,26 @@
 #include "bmap_repair.h"
 #include "rt.h"
 
+/* inode types */
+enum xr_ino_type {
+	XR_INO_UNKNOWN,		/* unknown */
+	XR_INO_DIR,		/* directory */
+	XR_INO_RTDATA,		/* realtime file */
+	XR_INO_RTBITMAP,	/* realtime bitmap inode */
+	XR_INO_RTSUM,		/* realtime summary inode */
+	XR_INO_DATA,		/* regular file */
+	XR_INO_SYMLINK,		/* symlink */
+	XR_INO_CHRDEV,		/* character device */
+	XR_INO_BLKDEV,		/* block device */
+	XR_INO_SOCK,		/* socket */
+	XR_INO_FIFO,		/* fifo */
+	XR_INO_UQUOTA,		/* user quota inode */
+	XR_INO_GQUOTA,		/* group quota inode */
+	XR_INO_PQUOTA,		/* project quota inode */
+	XR_INO_RTRMAP,		/* realtime rmap */
+	XR_INO_RTREFC,		/* realtime refcount */
+};
+
 /*
  * gettext lookups for translations of strings use mutexes internally to
  * the library. Hence when we come through here doing parallel scans in
@@ -482,7 +502,7 @@ out_unlock:
 static inline bool
 is_reflink_type(
 	struct xfs_mount	*mp,
-	int			type)
+	enum xr_ino_type	type)
 {
 	if (type == XR_INO_DATA && xfs_has_reflink(mp))
 		return true;
@@ -503,7 +523,7 @@ process_bmbt_reclist_int(
 	xfs_mount_t		*mp,
 	xfs_bmbt_rec_t		*rp,
 	xfs_extnum_t		*numrecs,
-	int			type,
+	enum xr_ino_type	type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
 	blkmap_t		**blkmapp,
@@ -952,7 +972,7 @@ process_rtrmap(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	struct xfs_dinode	*dip,
-	int			type,
+	enum xr_ino_type	type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
 	uint64_t		*nex,
@@ -1123,7 +1143,7 @@ process_rtrefc(
 	xfs_agnumber_t			agno,
 	xfs_agino_t			ino,
 	struct xfs_dinode		*dip,
-	int				type,
+	enum xr_ino_type		type,
 	int				*dirty,
 	xfs_rfsblock_t			*tot,
 	uint64_t			*nex,
@@ -1279,7 +1299,7 @@ process_btinode(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	struct xfs_dinode	*dip,
-	int			type,
+	enum xr_ino_type	type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
 	xfs_extnum_t		*nex,
@@ -1455,7 +1475,7 @@ process_exinode(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	struct xfs_dinode	*dip,
-	int			type,
+	enum xr_ino_type	type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
 	xfs_extnum_t		*nex,
@@ -1648,7 +1668,7 @@ process_quota_inode(
 	struct xfs_mount	*mp,
 	xfs_ino_t		lino,
 	struct xfs_dinode	*dino,
-	uint			ino_type,
+	enum xr_ino_type	ino_type,
 	struct blkmap		*blkmap)
 {
 	xfs_fsblock_t		fsbno;
@@ -1935,7 +1955,7 @@ process_misc_ino_types(
 	xfs_mount_t		*mp,
 	struct xfs_dinode	*dino,
 	xfs_ino_t		lino,
-	int			type)
+	enum xr_ino_type	type)
 {
 	/*
 	 * must also have a zero size
@@ -1982,7 +2002,10 @@ _("size of quota inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
 }
 
 static int
-process_misc_ino_types_blocks(xfs_rfsblock_t totblocks, xfs_ino_t lino, int type)
+process_misc_ino_types_blocks(
+	xfs_rfsblock_t		totblocks,
+	xfs_ino_t		lino,
+	enum xr_ino_type	type)
 {
 	/*
 	 * you can not enforce all misc types have zero data fork blocks
@@ -2092,7 +2115,7 @@ process_check_rt_inode(
 	struct xfs_mount	*mp,
 	struct xfs_dinode	*dinoc,
 	xfs_ino_t		lino,
-	int			*type,
+	enum xr_ino_type	*type,
 	int			*dirty,
 	int			expected_type,
 	const char		*tag)
@@ -2130,7 +2153,7 @@ process_check_metadata_inodes(
 	xfs_mount_t		*mp,
 	struct xfs_dinode	*dinoc,
 	xfs_ino_t		lino,
-	int			*type,
+	enum xr_ino_type	*type,
 	int			*dirty)
 {
 	if (lino == mp->m_sb.sb_rootino) {
@@ -2205,7 +2228,7 @@ process_check_inode_sizes(
 	xfs_mount_t		*mp,
 	struct xfs_dinode	*dino,
 	xfs_ino_t		lino,
-	int			type)
+	enum xr_ino_type	type)
 {
 	xfs_fsize_t		size = be64_to_cpu(dino->di_size);
 
@@ -2466,7 +2489,7 @@ process_inode_data_fork(
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
 	struct xfs_dinode	**dinop,
-	int			type,
+	enum xr_ino_type	type,
 	int			*dirty,
 	xfs_rfsblock_t		*totblocks,
 	xfs_extnum_t		*nextents,
@@ -3029,10 +3052,10 @@ process_dinode_int(
 	xfs_ino_t		*parent,	/* out -- parent if ino is a dir */
 	struct xfs_buf		**ino_bpp)
 {
+	enum xr_ino_type	type = XR_INO_UNKNOWN;
 	xfs_rfsblock_t		totblocks = 0;
 	xfs_rfsblock_t		atotblocks = 0;
 	int			di_mode;
-	int			type;
 	int			retval = 0;
 	xfs_extnum_t		nextents;
 	xfs_extnum_t		anextents;
@@ -3048,7 +3071,6 @@ process_dinode_int(
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
-	type = XR_INO_UNKNOWN;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	di_mode = be16_to_cpu(dino->di_mode);
diff --git a/repair/incore.h b/repair/incore.h
index 57019148f588..293988c9769d 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -225,25 +225,6 @@ int		count_bcnt_extents(xfs_agnumber_t);
  * inode definitions
  */
 
-/* inode types */
-
-#define XR_INO_UNKNOWN	0		/* unknown */
-#define XR_INO_DIR	1		/* directory */
-#define XR_INO_RTDATA	2		/* realtime file */
-#define XR_INO_RTBITMAP	3		/* realtime bitmap inode */
-#define XR_INO_RTSUM	4		/* realtime summary inode */
-#define XR_INO_DATA	5		/* regular file */
-#define XR_INO_SYMLINK	6		/* symlink */
-#define XR_INO_CHRDEV	7		/* character device */
-#define XR_INO_BLKDEV	8		/* block device */
-#define XR_INO_SOCK	9		/* socket */
-#define XR_INO_FIFO	10		/* fifo */
-#define XR_INO_UQUOTA	12		/* user quota inode */
-#define XR_INO_GQUOTA	13		/* group quota inode */
-#define XR_INO_PQUOTA	14		/* project quota inode */
-#define XR_INO_RTRMAP	15		/* realtime rmap */
-#define XR_INO_RTREFC	16		/* realtime refcount */
-
 /* inode allocation tree */
 
 /*
-- 
2.47.3

