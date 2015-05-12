Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 994977F54
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 14:30:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EA905AC004
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 12:30:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id mSCTsknFgpBrPGGk for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 12:30:16 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0E09D63CBFD7
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 14:30:16 -0500 (CDT)
Message-ID: <555254C7.8000705@sandeen.net>
Date: Tue, 12 May 2015 14:30:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsprogs: Add new sb_meta_uuid field, update userspace
	tools to manipulate it
References: <55525356.1020807@sandeen.net>
In-Reply-To: <55525356.1020807@sandeen.net>
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

This adds a new superblock field, sb_meta_uuid.  This allows us to
change the use-visible UUID on crc-enabled filesytems from userspace
if desired, by copying the existing UUID to the new location for
metadata comparisons.  If this is done, an incompat flag must be
set to prevent older filesystems from mounting the filesystem, but
the original UUID can be restored, and the incompat flag removed,
with a new xfs_db / xfs_admin UUID command, "restore."

Much of this patch mirrors the kernel patch in simply renaming
the field used for metadata uuid comparison; other bits:

* Teach xfs_db to print the new meta_uuid field
* Allow xfs_db to generate a new UUID for CRC-enabled filesystems
* Allow xfs_db to revert to the original UUID and clear the flag
* Fix up xfs_copy to work with CRC-enabled filesystems
* Update the xfs_admin manpage to show the UUID "restore" command

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This version makes the UUID "restore" command silent if there
is nothing to do.

Still open to bike-shedding on the "restore" name.  Maybe "revert?"

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 279527c..a58eee5 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -466,6 +466,34 @@ write_wbuf(void)
 	sighold(SIGCHLD);
 }
 
+void
+sb_update_uuid(
+	xfs_sb_t	*sb,
+	ag_header_t	*ag_hdr,
+	thread_args	*tcarg)
+{
+	/*
+	 * If this filesystem has CRCs, the original UUID is stamped into
+	 * all metadata.  We need to copy the original UUID into the meta_uuid
+	 * slot and set the incompat flag if that hasn't already been done.
+	 */
+	if (xfs_sb_version_hascrc(sb) && !xfs_sb_version_hasmetauuid(sb)) {
+		__be32 feat;
+
+		feat = be32_to_cpu(ag_hdr->xfs_sb->sb_features_incompat);
+		feat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		ag_hdr->xfs_sb->sb_features_incompat = cpu_to_be32(feat);
+		platform_uuid_copy(&ag_hdr->xfs_sb->sb_meta_uuid,
+				   &ag_hdr->xfs_sb->sb_uuid);
+	}
+
+	platform_uuid_copy(&ag_hdr->xfs_sb->sb_uuid, &tcarg->uuid);
+
+	/* We changed the UUID, so update the superblock CRC if needed */
+	if (xfs_sb_version_hascrc(sb))
+		xfs_update_cksum((char *)&ag_hdr->xfs_sb, sb->sb_sectsize,
+							 XFS_SB_CRC_OFF);
+}
 
 int
 main(int argc, char **argv)
@@ -659,16 +687,6 @@ main(int argc, char **argv)
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
 
-	/*
-	 * For now, V5 superblock filesystems are not supported without -d;
-	 * we do not have the infrastructure yet to fix CRCs when a new UUID
-	 * is generated.
-	 */
-	if (xfs_sb_version_hascrc(sb) && !duplicate) {
-		do_log(_("%s: Cannot yet copy V5 fs without '-d'\n"), progname);
-		exit(1);
-	}
-
 	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	if (mp == NULL) {
 		do_log(_("%s: %s filesystem failed to initialize\n"
@@ -1127,8 +1145,7 @@ main(int argc, char **argv)
 			/* do each thread in turn, each has its own UUID */
 
 			for (j = 0, tcarg = targ; j < num_targets; j++)  {
-				platform_uuid_copy(&ag_hdr.xfs_sb->sb_uuid,
-							&tcarg->uuid);
+				sb_update_uuid(sb, &ag_hdr, tcarg);
 				do_write(tcarg);
 				tcarg++;
 			}
diff --git a/db/sb.c b/db/sb.c
index cd12f83..a1dd039 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -29,6 +29,8 @@
 #include "output.h"
 #include "init.h"
 
+#define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
+
 static int	sb_f(int argc, char **argv);
 static void     sb_help(void);
 static int	uuid_f(int argc, char **argv);
@@ -121,6 +123,7 @@ const field_t	sb_flds[] = {
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }
 };
 
@@ -334,6 +337,32 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 		return &uu;
 	}
 	/* set uuid */
+	if (!xfs_sb_version_hascrc(&tsb))
+		goto write;
+	/*
+	 * If we have CRCs, and this UUID differs from that stamped in the
+	 * metadata, set the incompat flag and copy the old one to the
+	 * metadata-specific location.
+	 *
+	 * If we are setting the user-visible UUID back to match the metadata
+	 * UUID, clear the metadata-specific location and the incompat flag.
+	 */
+	if (!xfs_sb_version_hasmetauuid(&tsb) &&
+	    !uuid_equal(uuid, &mp->m_sb.sb_meta_uuid)) {
+		mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		tsb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_META_UUID;
+		memcpy(&tsb.sb_meta_uuid, &tsb.sb_uuid, sizeof(uuid_t));
+	} else if (xfs_sb_version_hasmetauuid(&tsb) &&
+		   uuid_equal(uuid, &mp->m_sb.sb_meta_uuid)) {
+		memset(&tsb.sb_meta_uuid, 0, sizeof(uuid_t));
+		/* Write those zeros now; it's ignored once we clear the flag */
+		libxfs_sb_to_disk(iocur_top->data, &tsb);
+		mp->m_sb.sb_features_incompat &=
+						~XFS_SB_FEAT_INCOMPAT_META_UUID;
+		tsb.sb_features_incompat &= ~XFS_SB_FEAT_INCOMPAT_META_UUID;
+	}
+
+write:
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
@@ -363,18 +392,6 @@ uuid_f(
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
@@ -388,6 +405,17 @@ uuid_f(
 			memcpy(&uu, uup, sizeof(uuid_t));
 			platform_uuid_unparse(&uu, bp);
 			dbprintf(_("old UUID = %s\n"), bp);
+		} else if (!strcasecmp(argv[1], "restore")) {
+			xfs_sb_t	tsb;
+
+			if (!get_sb(0, &tsb))
+				return 0;
+
+			/* Not set; nothing to do.  Success! */
+			if (!xfs_sb_version_hasmetauuid(&tsb))
+				return 0;
+		
+			memcpy(&uu, mp->m_sb.sb_meta_uuid, sizeof(uuid_t));
 		} else {
 			if (platform_uuid_parse(argv[1], &uu)) {
 				dbprintf(_("invalid UUID\n"));
@@ -660,6 +688,8 @@ version_string(
 		strcat(s, ",CRC");
 	if (xfs_sb_version_hasftype(sbp))
 		strcat(s, ",FTYPE");
+	if (xfs_sb_version_hasmetauuid(sbp))
+		strcat(s, ",META_UUID");
 	return s;
 }
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 23e3c53..62dce1e 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -446,7 +446,7 @@ xfs_agfl_verify(
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
 	int		i;
 
-	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
 		return false;
@@ -2199,7 +2199,7 @@ xfs_agf_verify(
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 7fd72af..e60538a 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -293,7 +293,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
@@ -311,7 +311,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 200bd30..69b6af3 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -258,7 +258,7 @@ xfs_attr3_leaf_verify(
 		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
 			return false;
 
-		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
@@ -1052,7 +1052,7 @@ xfs_attr3_leaf_create(
 
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 		ichdr.freemap[0].base = sizeof(struct xfs_attr3_leaf_hdr);
 	} else {
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 4f492c1..5feaf55 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -95,7 +95,7 @@ xfs_attr3_rmt_verify(
 		return false;
 	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
 		return false;
-	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
 		return false;
@@ -212,7 +212,7 @@ xfs_attr3_rmt_hdr_set(
 	rmt->rm_magic = cpu_to_be32(XFS_ATTR3_RMT_MAGIC);
 	rmt->rm_offset = cpu_to_be32(offset);
 	rmt->rm_bytes = cpu_to_be32(size);
-	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_uuid);
+	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid);
 	rmt->rm_owner = cpu_to_be64(ino);
 	rmt->rm_blkno = cpu_to_be64(bno);
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2fd04e0..f42bc2d 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -346,7 +346,8 @@ xfs_bmbt_to_bmdr(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		ASSERT(rblock->bb_magic == cpu_to_be32(XFS_BMAP_CRC_MAGIC));
-		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid));
+		ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid,
+		       &mp->m_sb.sb_meta_uuid));
 		ASSERT(rblock->bb_u.l.bb_blkno ==
 		       cpu_to_be64(XFS_BUF_DADDR_NULL));
 	} else
@@ -644,7 +645,7 @@ xfs_bmbt_verify(
 	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(block->bb_u.l.bb_blkno) != bp->b_bn)
 			return false;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 203e7d2..a16ae7d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -62,7 +62,8 @@ xfs_btree_check_lblock(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		lblock_ok = lblock_ok &&
-			uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid) &&
+			uuid_equal(&block->bb_u.l.bb_uuid,
+				   &mp->m_sb.sb_meta_uuid) &&
 			block->bb_u.l.bb_blkno == cpu_to_be64(
 				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
 	}
@@ -112,7 +113,8 @@ xfs_btree_check_sblock(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		sblock_ok = sblock_ok &&
-			uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid) &&
+			uuid_equal(&block->bb_u.s.bb_uuid,
+				   &mp->m_sb.sb_meta_uuid) &&
 			block->bb_u.s.bb_blkno == cpu_to_be64(
 				bp ? bp->b_bn : XFS_BUF_DADDR_NULL);
 	}
@@ -997,7 +999,7 @@ xfs_btree_init_block_int(
 		if (flags & XFS_BTREE_CRC_BLOCKS) {
 			buf->bb_u.l.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.l.bb_owner = cpu_to_be64(owner);
-			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&buf->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid);
 			buf->bb_u.l.bb_pad = 0;
 			buf->bb_u.l.bb_lsn = 0;
 		}
@@ -1010,7 +1012,7 @@ xfs_btree_init_block_int(
 		if (flags & XFS_BTREE_CRC_BLOCKS) {
 			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
 			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
-			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
 			buf->bb_u.s.bb_lsn = 0;
 		}
 	}
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 441bef4..3de4cd3 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -142,7 +142,7 @@ xfs_da3_node_verify(
 		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
 			return false;
 
-		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
 			return false;
@@ -320,7 +320,7 @@ xfs_da3_node_create(
 		ichdr.magic = XFS_DA3_NODE_MAGIC;
 		hdr3->info.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->info.owner = cpu_to_be64(args->dp->i_ino);
-		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		ichdr.magic = XFS_DA_NODE_MAGIC;
 	}
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index f061a99..489f301 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -64,7 +64,7 @@ xfs_dir3_block_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -154,7 +154,7 @@ xfs_dir3_block_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 		return;
 
 	}
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 609c097..c475ba8 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -218,7 +218,7 @@ xfs_dir3_data_verify(
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -602,7 +602,7 @@ xfs_dir3_data_init(
 		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
 		hdr3->blkno = cpu_to_be64(bp->b_bn);
 		hdr3->owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
 
 	} else
 		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index c2dba8a..80d03b3 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -158,7 +158,7 @@ xfs_dir3_leaf_verify(
 
 		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
 			return false;
-		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
 			return false;
@@ -308,7 +308,7 @@ xfs_dir3_leaf_init(
 					 : cpu_to_be16(XFS_DIR3_LEAFN_MAGIC);
 		leaf3->info.blkno = cpu_to_be64(bp->b_bn);
 		leaf3->info.owner = cpu_to_be64(owner);
-		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid);
 	} else {
 		memset(leaf, 0, sizeof(*leaf));
 		leaf->hdr.info.magic = cpu_to_be16(type);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 3b71e9e..581d648 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -91,7 +91,7 @@ xfs_dir3_free_verify(
 
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
 			return false;
-		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
 			return false;
@@ -224,7 +224,7 @@ xfs_dir3_free_get_buf(
 
 		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
 		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
-		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
 	} else
 		hdr.magic = XFS_DIR2_FREE_MAGIC;
 	dp->d_ops->free_hdr_to_disk(bp->b_addr, &hdr);
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 2e0484a..1a2546b 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -171,7 +171,7 @@ xfs_dqcheck(
 	d->dd_diskdq.d_id = cpu_to_be32(id);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_uuid);
+		uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
@@ -206,7 +206,7 @@ xfs_dquot_buf_verify_crc(
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF))
 			return false;
-		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&d->dd_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 	}
 	return true;
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 4d313d3..c360585 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -100,7 +100,7 @@ typedef struct xfs_sb {
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
 	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
-	uuid_t		sb_uuid;	/* file system unique id */
+	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	xfs_fsblock_t	sb_logstart;	/* starting block of log if internal */
 	xfs_ino_t	sb_rootino;	/* root inode number */
 	xfs_ino_t	sb_rbmino;	/* bitmap inode for realtime extents */
@@ -174,6 +174,7 @@ typedef struct xfs_sb {
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
+	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -190,7 +191,7 @@ typedef struct xfs_dsb {
 	__be64		sb_dblocks;	/* number of data blocks */
 	__be64		sb_rblocks;	/* number of realtime blocks */
 	__be64		sb_rextents;	/* number of realtime extents */
-	uuid_t		sb_uuid;	/* file system unique id */
+	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	__be64		sb_logstart;	/* starting block of log if internal */
 	__be64		sb_rootino;	/* root inode number */
 	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
@@ -260,6 +261,7 @@ typedef struct xfs_dsb {
 
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
+	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -457,8 +459,10 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 1)	/* metadata UUID */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_META_UUID)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -507,6 +511,18 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 }
 
 /*
+ * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
+ * is stored separately from the user-visible UUID; this allows the
+ * user-visible UUID to be changed on V5 filesystems which have a
+ * filesystem UUID stamped into every piece of metadata.
+ */
+static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
+}
+
+/*
  * end of superblock version macros
  */
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 2b4e4e0..71af28e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -302,7 +302,8 @@ xfs_ialloc_inode_init(
 			if (version == 3) {
 				free->di_ino = cpu_to_be64(ino);
 				ino++;
-				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
+				uuid_copy(&free->di_uuid,
+					  &mp->m_sb.sb_meta_uuid);
 				xfs_dinode_calc_crc(mp, free);
 			} else if (tp) {
 				/* just log the inode core */
@@ -2044,7 +2045,7 @@ xfs_agi_verify(
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid))
+	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 	/*
 	 * Validate the magic number of the agi block.
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 9ac143a..e8ec5e7 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -229,7 +229,7 @@ xfs_inobt_verify(
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return false;
 		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
 			return false;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index fd48f04..3f20303 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -304,7 +304,7 @@ xfs_dinode_verify(
 		return false;
 	if (be64_to_cpu(dip->di_ino) != ino)
 		return false;
-	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	return true;
 }
@@ -366,7 +366,7 @@ xfs_iread(
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			ip->i_d.di_version = 3;
 			ip->i_d.di_ino = ip->i_ino;
-			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+			uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		} else
 			ip->i_d.di_version = 2;
 		return 0;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 6844cd8..b3c5de9 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -360,6 +360,17 @@ __xfs_sb_from_disk(
 	to->sb_pad = 0;
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+	/*
+	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
+	 * feature flag is set; if not set we keep it only in memory.
+	 */
+	if (xfs_sb_version_hasmetauuid(to)) {
+		memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
+					sizeof(to->sb_meta_uuid));
+	} else {
+		memcpy(&to->sb_meta_uuid, &from->sb_uuid,
+					sizeof(to->sb_meta_uuid));
+	}
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
@@ -501,6 +512,10 @@ xfs_sb_to_disk(
 				cpu_to_be32(from->sb_features_log_incompat);
 		to->sb_pad = 0;
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
+		if (xfs_sb_version_hasmetauuid(from)) {
+			memcpy(&to->sb_meta_uuid, &from->sb_meta_uuid,
+						sizeof(to->sb_meta_uuid));
+		}
 	}
 }
 
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index 6bc5af5..7d46d9e 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -60,7 +60,7 @@ xfs_symlink_hdr_set(
 	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
 	dsl->sl_offset = cpu_to_be32(offset);
 	dsl->sl_bytes = cpu_to_be32(size);
-	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
+	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid);
 	dsl->sl_owner = cpu_to_be64(ino);
 	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
 	bp->b_ops = &xfs_symlink_buf_ops;
@@ -104,7 +104,7 @@ xfs_symlink_verify(
 		return false;
 	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
 		return false;
-	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_uuid))
+	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
 		return false;
 	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
 		return false;
diff --git a/libxlog/util.c b/libxlog/util.c
index 053cf04..fd1011f 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -29,8 +29,10 @@ header_check_uuid(xfs_mount_t *mp, xlog_rec_header_t *head)
 {
     char uu_log[64], uu_sb[64];
 
-    if (print_skip_uuid) return 0;
-    if (!platform_uuid_compare(&mp->m_sb.sb_uuid, &head->h_fs_uuid)) return 0;
+    if (print_skip_uuid)
+		return 0;
+    if (!platform_uuid_compare(&mp->m_sb.sb_uuid, &head->h_fs_uuid))
+		return 0;
 
     platform_uuid_unparse(&mp->m_sb.sb_uuid, uu_sb);
     platform_uuid_unparse(&head->h_fs_uuid, uu_log);
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index b393d74..c17b35e 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -98,7 +98,12 @@ The
 .I uuid
 may also be
 .BR generate ,
-which will generate a new UUID for the filesystem.
+which will generate a new UUID for the filesystem.  Note that on CRC-enabled
+filesystems, this will set an incompatible flag such that older kernels will
+not be able to mount the filesystem.  To remove this incompatible flag, use
+.BR restore ,
+which will restore the original UUID and remove the incompatible
+feature flag as needed.
 .TP
 .B \-V
 Prints the version number and exits.
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index d527230..df54bb7 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -664,7 +664,7 @@ The possible data types are:
 .BR sb ", " symlink " and " text .
 See the TYPES section below for more information on these data types.
 .TP
-.BI "uuid [" uuid " | " generate " | " rewrite ]
+.BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
 Set the filesystem universally unique identifier (UUID).
 The filesystem UUID can be used by
 .BR mount (8)
@@ -675,7 +675,12 @@ can be set directly to the desired UUID, or it can
 be automatically generated using the
 .B generate
 option. These options will both write the UUID into every copy of the
-superblock in the filesystem.
+superblock in the filesystem.  On a CRC-enabled filesystem, this will
+set an incompatible superblock flag, and the filesystem will not be
+mountable with older kernels.  This can be reverted with the
+.B restore
+option, which will copy the original UUID back into place and clear
+the incompatible flag as needed.
 .B rewrite
 copies the current UUID from the primary superblock
 to all secondary copies of the superblock.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1770666..cb9f7f5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2598,6 +2598,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_rextents = rtextents;
 	platform_uuid_generate(&uuid);
 	platform_uuid_copy(&sbp->sb_uuid, &uuid);
+	/* Only in memory; libxfs expects this as if read from disk */
+	platform_uuid_copy(&sbp->sb_meta_uuid, &uuid);
 	sbp->sb_logstart = logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_rextsize = rtextblocks;
diff --git a/repair/agheader.c b/repair/agheader.c
index 9ae2deb..cfca529 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -112,7 +112,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGF;
@@ -120,7 +120,8 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 		do_warn(_("bad uuid %s for agf %d\n"), uu, i);
 
 		if (!no_modify)
-			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+			platform_uuid_copy(&agf->agf_uuid,
+					   &mp->m_sb.sb_meta_uuid);
 	}
 	return retval;
 }
@@ -190,7 +191,7 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return retval;
 
-	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid)) {
 		char uu[64];
 
 		retval = XR_AG_AGI;
@@ -198,7 +199,8 @@ verify_set_agi(xfs_mount_t *mp, xfs_agi_t *agi, xfs_agnumber_t agno)
 		do_warn(_("bad uuid %s for agi %d\n"), uu, agno);
 
 		if (!no_modify)
-			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
+			platform_uuid_copy(&agi->agi_uuid,
+					   &mp->m_sb.sb_meta_uuid);
 	}
 
 	return retval;
@@ -245,7 +247,7 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb)
  * superblocks, not just the secondary superblocks.
  */
 static int
-secondary_sb_wack(
+secondary_sb_whack(
 	struct xfs_mount *mp,
 	struct xfs_buf	*sbuf,
 	struct xfs_sb	*sb,
@@ -267,7 +269,10 @@ secondary_sb_wack(
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
@@ -511,7 +516,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
 		rval |= XR_AG_SB;
 	}
 
-	rval |= secondary_sb_wack(mp, sbuf, sb, i);
+	rval |= secondary_sb_whack(mp, sbuf, sb, i);
 
 	rval |= verify_set_agf(mp, agf, i);
 	rval |= verify_set_agi(mp, agi, i);
diff --git a/repair/agheader.h b/repair/agheader.h
index 5541fb9..6b2974c 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -24,7 +24,6 @@ typedef struct fs_geometry  {
 	xfs_rfsblock_t	sb_dblocks;	/* # data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* # realtime blocks */
 	xfs_rtblock_t	sb_rextents;	/* # realtime extents */
-	uuid_t		sb_uuid;	/* fs uuid */
 	xfs_fsblock_t	sb_logstart;	/* starting log block # */
 	xfs_agblock_t	sb_rextsize;	/* realtime extent size (blocks )*/
 	xfs_agblock_t	sb_agblocks;	/* # of blocks per ag */
diff --git a/repair/dinode.c b/repair/dinode.c
index 179203e..0ea5a9e 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -207,9 +207,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 		dinoc->di_ino = cpu_to_be64(ino_num);
 	}
 
-	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_uuid)) {
+	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid)) {
 		__dirty_no_modify_ret(dirty);
-		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_meta_uuid);
 	}
 
 	for (i = 0; i < sizeof(dinoc->di_pad2)/sizeof(dinoc->di_pad2[0]); i++) {
@@ -2287,7 +2287,8 @@ _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
 				return 1;
 			goto clear_bad_out;
 		}
-		if (platform_uuid_compare(&dino->di_uuid, &mp->m_sb.sb_uuid)) {
+		if (platform_uuid_compare(&dino->di_uuid,
+					  &mp->m_sb.sb_meta_uuid)) {
 			if (!uncertain)
 				do_warn(
 			_("UUID mismatch on inode %" PRIu64 "\n"), lino);
diff --git a/repair/phase5.c b/repair/phase5.c
index 1ce57a1..d40b71d 100644
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
index 7902be9..5148693 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -527,7 +527,7 @@ mk_rbmino(xfs_mount_t *mp)
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_ino = mp->m_sb.sb_rbmino;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -783,7 +783,7 @@ mk_rsumino(xfs_mount_t *mp)
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_ino = mp->m_sb.sb_rsumino;
 		memset(&(ip->i_d.di_pad2[0]), 0, sizeof(ip->i_d.di_pad2));
-		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_uuid);
+		platform_uuid_copy(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid);
 		times |= XFS_ICHGTIME_CREATE;
 	}
 	libxfs_trans_ichgtime(tp, ip, times);
@@ -897,7 +897,7 @@ mk_root_dir(xfs_mount_t *mp)
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
