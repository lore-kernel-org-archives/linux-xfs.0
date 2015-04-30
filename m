Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 716267F37
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 23:55:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5ED8E30404E
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 21:55:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aPlZdxr7st9cpdm4 for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 21:55:04 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 00B19658ADAC
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 23:55:03 -0500 (CDT)
Message-ID: <5541B5A7.8000307@sandeen.net>
Date: Wed, 29 Apr 2015 23:55:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH RFC 2/2] xfsprogs: add support for sb_meta_uuid
References: <553EB3D1.10602@sandeen.net>
In-Reply-To: <553EB3D1.10602@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This adds userspace support for the new sb_meta_uuid field,
allowing us to change the user-visible UUID if needed.

If xfs_db changes the uuid, and we have CRCs (and hence metadata
UUID checking), and we don't have the incompatible meta_uuid
feature set, it will copy the primary uuid to the meta uuid and
set the incompat flag, then change the primary uuid as requested.

The bulk of the patch is simply changing comparisons from sb_uuid
to sb_meta_uuid.  If the feature isn't set, we populate the latter
with the former when reading the superblock from disk.

xfs_copy support is still missing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(for RFC purposes only, has only had smoke testing so far)

 db/sb.c                     |   27 ++++++++++++++-------------
 include/xfs_sb.h            |   17 ++++++++++++++---
 libxfs/util.c               |    2 +-
 libxfs/xfs_alloc.c          |    4 ++--
 libxfs/xfs_alloc_btree.c    |    4 ++--
 libxfs/xfs_attr_leaf.c      |    4 ++--
 libxfs/xfs_attr_remote.c    |    4 ++--
 libxfs/xfs_bmap_btree.c     |    4 ++--
 libxfs/xfs_btree.c          |    8 ++++----
 libxfs/xfs_da_btree.c       |    4 ++--
 libxfs/xfs_dir2_block.c     |    4 ++--
 libxfs/xfs_dir2_data.c      |    4 ++--
 libxfs/xfs_dir2_leaf.c      |    4 ++--
 libxfs/xfs_dir2_node.c      |    4 ++--
 libxfs/xfs_dquot_buf.c      |    4 ++--
 libxfs/xfs_ialloc.c         |    4 ++--
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_inode_buf.c      |    2 +-
 libxfs/xfs_sb.c             |    9 +++++++++
 libxfs/xfs_symlink_remote.c |    4 ++--
 repair/agheader.c           |   13 ++++++++-----
 repair/dinode.c             |    6 +++---
 repair/phase5.c             |    6 +++---
 repair/phase6.c             |    6 +++---
 24 files changed, 87 insertions(+), 63 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index 23ec87c..42e34f9 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -121,6 +121,7 @@ const field_t	sb_flds[] = {
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -324,6 +325,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 {
 	xfs_sb_t	tsb;
 	static uuid_t	uu;
+	__int64_t	fields = XFS_SB_UUID;
 
 	if (!get_sb(agno, &tsb))
 		return NULL;
@@ -333,9 +335,16 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 		pop_cur();
 		return &uu;
 	}
+	if (xfs_sb_version_hascrc(&tsb) &&
+	    !xfs_sb_version_hasmetauuid(&tsb)) {
+		memcpy(&tsb.sb_meta_uuid, &tsb.sb_uuid, sizeof(uuid_t));
+		tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		fields |= XFS_SB_META_UUID | XFS_SB_FEATURES_INCOMPAT;
+	}
 	/* set uuid */
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
-	libxfs_sb_to_disk(iocur_top->data, &tsb, XFS_SB_UUID);
+	libxfs_sb_to_disk(iocur_top->data, &tsb, fields);
 	write_cur();
 	return uuid;
 }
@@ -363,18 +372,6 @@ uuid_f(
 			return 0;
 		}
 
-		/*
-		 * For now, changing the UUID of V5 superblock filesystems is
-		 * not supported; we do not have the infrastructure to fix all
-		 * other metadata when a new superblock UUID is generated.
-		 */
-		if (xfs_sb_version_hascrc(&mp->m_sb) &&
-		    strcasecmp(argv[1], "rewrite")) {
-			dbprintf(_("%s: only 'rewrite' supported on V5 fs\n"),
-				progname);
-			return 0;
-		}
-
 		if (!strcasecmp(argv[1], "generate")) {
 			platform_uuid_generate(&uu);
 		} else if (!strcasecmp(argv[1], "nil")) {
@@ -658,6 +655,10 @@ version_string(
 		strcat(s, ",CRC");
 	if (xfs_sb_version_hasftype(sbp))
 		strcat(s, ",FTYPE");
+	if (xfs_sb_version_hasfinobt(sbp))
+		strcat(s, ",FINOBT");
+	if (xfs_sb_version_hasmetauuid(sbp))
+		strcat(s, ",META_UUID");
 	return s;
 }
 
diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index 950d1ea..41b54ce 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -178,6 +178,7 @@ typedef struct xfs_sb {
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
+	uuid_t		sb_meta_uuid;	/* metadata unique id */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -264,6 +265,7 @@ typedef struct xfs_dsb {
 
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
+	uuid_t		sb_meta_uuid;	/* metadata unique id */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -287,7 +289,7 @@ typedef enum {
 	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
 	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
 	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
-	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
+	XFS_SBS_PQUOTINO, XFS_SBS_LSN, XFS_SBS_META_UUID,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -319,6 +321,7 @@ typedef enum {
 #define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
 #define XFS_SB_CRC		XFS_SB_MVAL(CRC)
 #define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
+#define	XFS_SB_META_UUID	XFS_SB_MVAL(META_UUID)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -328,7 +331,7 @@ typedef enum {
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
 	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
 	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
-	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
+	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO | XFS_SB_META_UUID)
 
 
 /*
@@ -600,8 +603,10 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_META_UUID (1 << 1)		/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_META_UUID)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -649,6 +654,12 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
+static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_META_UUID);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/libxfs/util.c b/libxfs/util.c
index 49eb76d..ea698c4 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -250,7 +250,7 @@ libxfs_ialloc(
 
 	if (ip->i_d.di_version == 3) {
 		ASSERT(ip->i_d.di_ino == ino);
-		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid));
+		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		ip->i_d.di_crc = 0;
 		ip->i_d.di_changecount = 1;
 		ip->i_d.di_lsn = 0;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 6c82be0..06757c3 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -426,7 +426,7 @@ xfs_agfl_verify(
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
 	int		i;
 
-	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
 		return false;
@@ -2181,7 +2181,7 @@ xfs_agf_verify(
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 215be7e..cefa18b 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -279,7 +279,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
@@ -297,7 +297,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index f7f02ae..e9f96ec 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -161,7 +161,7 @@ xfs_attr3_leaf_verify(
 		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
 			return false;
 
-		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
@@ -952,7 +952,7 @@ xfs_attr3_leaf_create(
 
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
 	} else {
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 08b983b..62abaec 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -78,7 +78,7 @@ xfs_attr3_rmt_verify(
 		return false;
 	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
 		return false;
-	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
 		return false;
@@ -194,7 +194,7 @@ xfs_attr3_rmt_hdr_set(
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
 	rmt->rm_offset = cpu_to_be32(offset);
 	rmt->rm_bytes = cpu_to_be32(size);
-	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_uuid);
+	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid);
 	rmt->rm_owner = cpu_to_be64(ino);
 	rmt->rm_blkno = cpu_to_be64(bno);
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a4bd69d..96d20c1 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -412,7 +412,7 @@ xfs_bmbt_to_bmdr(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
-		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid));
+		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
 		ASSERT(rblock->bb_u.l.bb_blkno ==
 		       cpu_to_be64(XFS_BUF_DADDR_NULL));
 	} else
@@ -712,7 +712,7 @@ xfs_bmbt_verify(
 	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(block->bb_u.l.bb_blkno) != bp->b_bn)
 			return false;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index cc823f5..d3df341 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -50,7 +50,7 @@ xfs_btree_check_lblock(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		lblock_ok = lblock_ok &&
-			uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid) &&
+			uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid) &&
 			block->bb_u.l.bb_blkno == cpu_to_be64(
 				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
 	}
@@ -100,7 +100,7 @@ xfs_btree_check_sblock(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		sblock_ok = sblock_ok &&
-			uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid) &&
+			uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid) &&
 			block->bb_u.s.bb_blkno == cpu_to_be64(
 				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
 	}
@@ -992,7 +992,7 @@ xfs_btree_init_block_int(
 		if (flags & XFS_BTREE_CRC_BLOCKS) {
 			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
-			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid);
 			buf->bb_u.l.bb_pad = 0;
 			buf->bb_u.l.bb_lsn = 0;
 		}
@@ -1005,7 +1005,7 @@ xfs_btree_init_block_int(
 		if (flags & XFS_BTREE_CRC_BLOCKS) {
 			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
-			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
 			buf->bb_u.s.bb_lsn = 0;
 		}
 	}
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index b731b54..0323dc7 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -172,7 +172,7 @@ xfs_da3_node_verify(
 		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
 			return false;
 
-		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
@@ -349,7 +349,7 @@ xfs_da3_node_create(
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
-		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
 	}
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index cede01f..2a25059 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -51,7 +51,7 @@ xfs_dir3_block_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -141,7 +141,7 @@ xfs_dir3_block_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 		return;
 
 	}
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index dc9df4d..4c79d7c 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -186,7 +186,7 @@ xfs_dir3_data_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -573,7 +573,7 @@ xfs_dir3_data_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 8e0cbc9..a918e15 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -186,7 +186,7 @@ xfs_dir3_leaf_verify(
 
 		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
 			return false;
-		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
@@ -337,7 +337,7 @@ xfs_dir3_leaf_init(
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
 		leaf3->info.owner = cpu_to_be64(owner);
-		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		memset(leaf, 0, sizeof(*leaf));
 		leaf->hdr.info.magic = cpu_to_be16(type);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 3737e4e..309e7ce 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -78,7 +78,7 @@ xfs_dir3_free_verify(
 
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -257,7 +257,7 @@ xfs_dir3_free_get_buf(
 
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	xfs_dir3_free_hdr_to_disk(bp->b_addr, &hdr);
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index e089ec8..f75bfe3 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -146,7 +146,7 @@ xfs_dqcheck(
 	d->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -181,7 +181,7 @@ xfs_dquot_buf_verify_crc(
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF))
 			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 	}
 	return true;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b20a9ec..da09ae7 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -295,7 +295,7 @@ xfs_ialloc_inode_init(
 			if (version == 3) {
 				free->di_ino = cpu_to_be64(ino);
 				ino++;
-				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
+				uuid_copy(&free->di_uuid, &mp->m_sb.sb_meta_uuid);
 				xfs_dinode_calc_crc(mp, free);
 			} else if (tp) {
 				/* just log the inode core */
@@ -1947,7 +1947,7 @@ xfs_agi_verify(
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid))
+	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 	/*
 	 * Validate the magic number of the agi block.
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index c337389..320984f 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -214,7 +214,7 @@ xfs_inobt_verify(
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index de16ed9..1c0047d 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -295,7 +295,7 @@ xfs_dinode_verify(
 		return false;
 	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
-	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	return true;
 }
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ea89367..22404e6 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -81,6 +81,7 @@ static const struct {
 	{ offsetof(xfs_sb_t, sb_pad),		0 },
 	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
 	{ offsetof(xfs_sb_t, sb_lsn),		0 },
+	{ offsetof(xfs_sb_t, sb_meta_uuid),	1 },
 	{ sizeof(xfs_sb_t),			0 }
 };
 
@@ -413,6 +414,14 @@ xfs_sb_from_disk(
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+	if (xfs_sb_version_hasmetauuid(to)) {
+		memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
+					sizeof(to->sb_meta_uuid));
+	} else {
+		memcpy(&to->sb_meta_uuid, &from->sb_uuid,
+					sizeof(to->sb_meta_uuid));
+	}
+
 }
 
 static inline void
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index ebf60ac..3f8374e 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -48,7 +48,7 @@ xfs_symlink_hdr_set(
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
-	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
+	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
 	dsl->sl_owner = cpu_to_be64(ino);
 	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
 	bp->b_ops = &xfs_symlink_buf_ops;
@@ -93,7 +93,7 @@ xfs_symlink_verify(
 		return false;
 	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
 		return false;
-	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
 		return false;
diff --git a/repair/agheader.c b/repair/agheader.c
index 5dbf992..2f307e7 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -112,7 +112,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGF;
@@ -120,7 +120,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
 
 		if (!no_modify)
-			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 	return retval;
 }
@@ -190,7 +190,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGI;
@@ -198,7 +198,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 		do_warn(_("bad uuid %s for agi %d\n"), uu, agno);
 
 		if (!no_modify)
-			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 
 	return retval;
@@ -267,7 +267,10 @@ secondary_sb_wack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hascrc(sb))
+	if (xfs_sb_version_hasmetauuid(sb))
+		size = offsetof(xfs_sb_t, sb_meta_uuid)
+			+ sizeof(sb->sb_meta_uuid);
+	else if (xfs_sb_version_hascrc(sb))
 		size = offsetof(xfs_sb_t, sb_lsn)
 			+ sizeof(sb->sb_lsn);
 	else if (xfs_sb_version_hasmorebits(sb))
diff --git a/repair/dinode.c b/repair/dinode.c
index 035212c..83804ce 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -208,9 +208,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_ino = cpu_to_be64(ino_num);
 	}
 
-	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid)) {
 		__dirty_no_modify_ret(dirty);
-		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 
 	for (i = 0; i < sizeof(dinoc->di_pad2)/sizeof(dinoc->di_pad2[0]); i++) {
@@ -2366,7 +2366,7 @@ _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
 				return 1;
 			goto clear_bad_out;
 		}
-		if (platform_uuid_compare(&dino->di_uuid, &mp->m_sb.sb_uuid)) {
+		if (platform_uuid_compare(&dino->di_uuid, &mp->m_sb.sb_meta_uuid)) {
 			if (!uncertain)
 				do_warn(
 			_("UUID mismatch on inode %" PRIu64 "\n"), lino);
diff --git a/repair/phase5.c b/repair/phase5.c
index 3a2cdbb..d6f2ead 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1119,7 +1119,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
 		agi->agi_unlinked[i] = cpu_to_be32(NULLAGINO);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
 		agi->agi_free_root = cpu_to_be32(finobt_curs->root);
@@ -1360,7 +1360,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 #endif
 
 	if (xfs_sb_version_hascrc(&mp->m_sb))
-		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* initialise the AGFL, then fill it if there are blocks left over. */
 	agfl_buf = libxfs_getbuf(mp->m_dev,
@@ -1374,7 +1374,7 @@ build_agf_agfl(xfs_mount_t	*mp,
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
-		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 		for (i = 0; i < XFS_AGFL_SIZE(mp); i++)
 			agfl->agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index c09b394..96204b9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -526,7 +526,7 @@ mk_rbmino(xfs_mount_t *mp)
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_ino = mp->m_sb.sb_rbmino;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -782,7 +782,7 @@ mk_rsumino(xfs_mount_t *mp)
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_ino = mp->m_sb.sb_rsumino;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -898,7 +898,7 @@ mk_root_dir(xfs_mount_t *mp)
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_ino = mp->m_sb.sb_rootino;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
