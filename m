Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbeLEVFz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:05:55 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E40ED3002C80
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:05:54 +0000 (UTC)
Subject: [PATCH 05/10] xfs: define new macros to set verifier context on
 return
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <bd4b1c10-5ef8-c470-308a-7f7dabb87be7@redhat.com>
Date: Wed, 5 Dec 2018 15:05:51 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

New XFS_CORRUPTED_RETURN and XFS_VERIFIED_RETURN macros to set
either __this_address or NULL into the verifier failaddr, and
return the same value as well so that caller logic is unchanged
for now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          |  33 +++++----
 fs/xfs/libxfs/xfs_alloc_btree.c    |  10 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  48 ++++++-------
 fs/xfs/libxfs/xfs_attr_remote.c    |  16 ++---
 fs/xfs/libxfs/xfs_bmap.c           |  14 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |   4 +-
 fs/xfs/libxfs/xfs_btree.c          |  70 +++++++++----------
 fs/xfs/libxfs/xfs_da_btree.c       |  22 +++---
 fs/xfs/libxfs/xfs_dir2_block.c     |  10 +--
 fs/xfs/libxfs/xfs_dir2_data.c      |  96 +++++++++++++-------------
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  24 +++----
 fs/xfs/libxfs/xfs_dir2_node.c      |  30 ++++-----
 fs/xfs/libxfs/xfs_dir2_sf.c        |  24 +++----
 fs/xfs/libxfs/xfs_dquot_buf.c      |  24 +++----
 fs/xfs/libxfs/xfs_ialloc.c         |  18 ++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c      | 104 ++++++++++++++---------------
 fs/xfs/libxfs/xfs_inode_fork.c     |   8 +--
 fs/xfs/libxfs/xfs_refcount_btree.c |   8 +--
 fs/xfs/libxfs/xfs_rmap_btree.c     |   8 +--
 fs/xfs/libxfs/xfs_symlink_remote.c |  26 ++++----
 fs/xfs/libxfs/xfs_types.h          |   3 +
 22 files changed, 303 insertions(+), 301 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 15312fb37c02..36073ac260af 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -567,12 +567,12 @@ xfs_agfl_verify(
 	 * can't verify just those entries are valid.
 	 */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -580,17 +580,17 @@ xfs_agfl_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
 		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(XFS_BUF_TO_AGFL(bp)->agfl_lsn)))
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -2586,10 +2586,10 @@ xfs_agf_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp,
 				be64_to_cpu(XFS_BUF_TO_AGF(bp)->agf_lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
@@ -2598,18 +2598,18 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
 	      be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -2618,19 +2618,18 @@ xfs_agf_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
-		return __this_address;
-
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
 
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 2e9353a76a58..e8c4d142c419 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -321,9 +321,9 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTB_MAGIC):
 		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_BNOi])
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		} else if (level >= mp->m_ag_maxlevels)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
 		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
@@ -333,12 +333,12 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTC_MAGIC):
 		if (pag && pag->pagf_init) {
 			if (level >= pag->pagf_levels[XFS_BTNUM_CNTi])
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		} else if (level >= mp->m_ag_maxlevels)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	return xfs_btree_sblock_verify(vc, bp, mp->m_alloc_mxr[level != 0]);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d7909e45800c..cf09952a3939 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -253,17 +253,17 @@ xfs_attr3_leaf_verify(
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 	/*
 	 * In recovery there is a transient state where count == 0 is valid
@@ -271,22 +271,22 @@ xfs_attr3_leaf_verify(
 	 * if the attr didn't fit in shortform.
 	 */
 	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
 	 */
 	if (ichdr.firstused > mp->m_attr_geo->blksize)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (ichdr.firstused < xfs_attr3_leaf_hdr_size(leaf))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Make sure the entries array doesn't crash into the name info. */
 	entries = xfs_attr3_leaf_entryp(bp->b_addr);
 	if ((char *)&entries[ichdr.count] >
 	    (char *)bp->b_addr + ichdr.firstused)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* XXX: need to range check rest of attr header values */
 	/* XXX: hash order check? */
@@ -302,23 +302,23 @@ xfs_attr3_leaf_verify(
 	 */
 	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
 		if (ichdr.freemap[i].base > mp->m_attr_geo->blksize)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (ichdr.freemap[i].base & 0x3)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (ichdr.freemap[i].size > mp->m_attr_geo->blksize)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (ichdr.freemap[i].size & 0x3)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* be care of 16 bit overflows here */
 		end = (uint32_t)ichdr.freemap[i].base + ichdr.freemap[i].size;
 		if (end < ichdr.freemap[i].base)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (end > mp->m_attr_geo->blksize)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -928,7 +928,7 @@ xfs_attr_shortform_verify(
 	 * Give up if the attribute is way too short.
 	 */
 	if (size < sizeof(struct xfs_attr_sf_hdr))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	endp = (char *)sfp + size;
 
@@ -941,11 +941,11 @@ xfs_attr_shortform_verify(
 		 * within the data buffer.
 		 */
 		if (((char *)sfep + sizeof(*sfep)) >= endp)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* Don't allow names with known bad length. */
 		if (sfep->namelen == 0)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/*
 		 * Check that the variable-length part of the structure is
@@ -954,7 +954,7 @@ xfs_attr_shortform_verify(
 		 */
 		next_sfep = XFS_ATTR_SF_NEXTENTRY(sfep);
 		if ((char *)next_sfep > endp)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/*
 		 * Check for unknown flags.  Short form doesn't support
@@ -962,7 +962,7 @@ xfs_attr_shortform_verify(
 		 * mask here.
 		 */
 		if (sfep->flags & ~XFS_ATTR_NSP_ONDISK_MASK)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/*
 		 * Check for invalid namespace combinations.  We only allow
@@ -970,14 +970,14 @@ xfs_attr_shortform_verify(
 		 * bits (i.e. hweight) here.
 		 */
 		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		sfep = next_sfep;
 	}
 	if ((void *)sfep != (void *)endp)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 96a1b67f4fb9..2b038458f4ae 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -87,22 +87,22 @@ xfs_attr3_rmt_verify(
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (rmt->rm_magic != cpu_to_be32(XFS_ATTR3_RMT_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be32_to_cpu(rmt->rm_offset) +
 				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (rmt->rm_owner == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static int
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fe0e0a1df5b1..0340f9e2e0e7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6115,19 +6115,19 @@ xfs_bmap_validate_extent(
 	endfsb = irec->br_startblock + irec->br_blockcount - 1;
 	if (isrt) {
 		if (!xfs_verify_rtbno(mp, irec->br_startblock))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_verify_rtbno(mp, endfsb))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (!xfs_verify_fsbno(mp, irec->br_startblock))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_verify_fsbno(mp, endfsb))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (XFS_FSB_TO_AGNO(mp, irec->br_startblock) !=
 		    XFS_FSB_TO_AGNO(mp, endfsb))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 	if (irec->br_state != XFS_EXT_NORM && whichfork != XFS_DATA_FORK)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3cc9c6610c05..27b9056ba87a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -430,7 +430,7 @@ xfs_bmbt_verify(
 	case cpu_to_be32(XFS_BMAP_MAGIC):
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/*
@@ -442,7 +442,7 @@ xfs_bmbt_verify(
 	 */
 	level = be16_to_cpu(block->bb_level);
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_btree_lblock_verify(vc, bp, mp->m_bmap_dmxr[level != 0]);
 }
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a618e0251a55..d4728f70fcc3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -70,31 +70,31 @@ __xfs_btree_check_lblock(
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (block->bb_u.l.bb_blkno !=
 		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (block->bb_u.l.bb_pad != cpu_to_be32(0))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(block->bb_level) != level)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
 			level + 1))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
 			level + 1))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /* Check a long btree block header. */
@@ -138,29 +138,29 @@ __xfs_btree_check_sblock(
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (block->bb_u.s.bb_blkno !=
 		    cpu_to_be64(bp ? bp->b_bn : XFS_BUF_DADDR_NULL))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(block->bb_level) != level)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
 			level + 1))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
 			level + 1))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /* Check a short btree block header. */
@@ -4444,15 +4444,15 @@ xfs_btree_lblock_v5hdr_verify(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (owner != XFS_RMAP_OWN_UNKNOWN &&
 	    be64_to_cpu(block->bb_u.l.bb_owner) != owner)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /* Verify a long-format btree block. */
@@ -4467,17 +4467,17 @@ xfs_btree_lblock_verify(
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* sibling pointer verification */
 	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
 	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /**
@@ -4498,14 +4498,14 @@ xfs_btree_sblock_v5hdr_verify(
 	struct xfs_perag	*pag = bp->b_pag;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /**
@@ -4526,18 +4526,18 @@ xfs_btree_sblock_verify(
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
 	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
 	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index eb19d6aa85ca..f7510bf5f505 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -134,24 +134,24 @@ xfs_da3_node_verify(
 		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
 
 		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (ichdr.magic != XFS_DA_NODE_MAGIC)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 	if (ichdr.level == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (ichdr.count == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/*
 	 * we don't know if the node is for and attribute or directory tree,
@@ -159,11 +159,11 @@ xfs_da3_node_verify(
 	 */
 	if (ichdr.count > mp->m_dir_geo->node_ents &&
 	    ichdr.count > mp->m_attr_geo->node_ents)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* XXX: hash order check? */
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -255,7 +255,7 @@ xfs_da3_node_verify_struct(
 		bp->b_ops = &xfs_dir3_leafn_buf_ops;
 		return bp->b_ops->verify_struct(vc, bp);
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 53cc0e151a75..12ae8c4285b2 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -56,16 +56,16 @@ xfs_dir3_block_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 	return __xfs_dir3_data_check(vc, NULL, bp);
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 661615f253b2..574fe8ba7144 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -74,7 +74,7 @@ __xfs_dir3_data_check(
 	 */
 	if ((dp && !S_ISDIR(VFS_I(dp)->i_mode)) ||
 	    ops != xfs_dir_get_ops(mp, NULL))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	hdr = bp->b_addr;
 	p = (char *)ops->data_entry_p(hdr);
@@ -94,17 +94,17 @@ __xfs_dir3_data_check(
 		 */
 		if (be32_to_cpu(btp->count) >=
 		    ((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 	endp = xfs_dir3_data_endp(geo, hdr);
 	if (!endp)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/*
 	 * Account for zero bestfree entries.
@@ -113,24 +113,24 @@ __xfs_dir3_data_check(
 	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
 		if (bf[0].offset)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		freeseen |= 1 << 0;
 	}
 	if (!bf[1].length) {
 		if (bf[1].offset)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		freeseen |= 1 << 1;
 	}
 	if (!bf[2].length) {
 		if (bf[2].offset)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		freeseen |= 1 << 2;
 	}
 
 	if (be16_to_cpu(bf[0].length) < be16_to_cpu(bf[1].length))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(bf[1].length) < be16_to_cpu(bf[2].length))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	/*
 	 * Loop over the data/unused entries.
 	 */
@@ -145,24 +145,24 @@ __xfs_dir3_data_check(
 			xfs_failaddr_t	fa;
 
 			if (lastfree != 0)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 			if (endp < p + be16_to_cpu(dup->length))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
 			    (char *)dup - (char *)hdr)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 			fa = xfs_dir2_data_freefind_verify(vc, hdr, bf, dup, &dfp);
 			if (fa)
 				return fa;
 			if (dfp) {
 				i = (int)(dfp - bf);
 				if ((freeseen & (1 << i)) != 0)
-					return __this_address;
+					return XFS_CORRUPTED_RETURN(vc);
 				freeseen |= 1 << i;
 			} else {
 				if (be16_to_cpu(dup->length) >
 				    be16_to_cpu(bf[2].length))
-					return __this_address;
+					return XFS_CORRUPTED_RETURN(vc);
 			}
 			p += be16_to_cpu(dup->length);
 			lastfree = 1;
@@ -176,16 +176,16 @@ __xfs_dir3_data_check(
 		 */
 		dep = (xfs_dir2_data_entry_t *)p;
 		if (dep->namelen == 0)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (endp < p + ops->data_entsize(dep->namelen))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
 		    (char *)dep - (char *)hdr)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
@@ -202,7 +202,7 @@ __xfs_dir3_data_check(
 					break;
 			}
 			if (i >= be32_to_cpu(btp->count))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		}
 		p += ops->data_entsize(dep->namelen);
 	}
@@ -210,7 +210,7 @@ __xfs_dir3_data_check(
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
 	if (freeseen != 7)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
@@ -219,14 +219,14 @@ __xfs_dir3_data_check(
 				stale++;
 			if (i > 0 && be32_to_cpu(lep[i].hashval) <
 				     be32_to_cpu(lep[i - 1].hashval))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		}
 		if (count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (stale != be32_to_cpu(btp->stale))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 #ifdef DEBUG
@@ -258,16 +258,16 @@ xfs_dir3_data_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 	return __xfs_dir3_data_check(vc, NULL, bp);
 }
@@ -413,36 +413,36 @@ xfs_dir2_data_freefind_verify(
 	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
 		if (!dfp->offset) {
 			if (dfp->length)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 			seenzero = true;
 			continue;
 		}
 		if (seenzero)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be16_to_cpu(dfp->offset) == off) {
 			matched = true;
 			if (dfp->length != dup->length)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		} else if (be16_to_cpu(dfp->offset) > off) {
 			if (off + be16_to_cpu(dup->length) >
 					be16_to_cpu(dfp->offset))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		} else {
 			if (be16_to_cpu(dfp->offset) +
 					be16_to_cpu(dfp->length) > off)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		}
 		if (!matched &&
 		    be16_to_cpu(dfp->length) < be16_to_cpu(dup->length))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (dfp > &bf[0] &&
 		    be16_to_cpu(dfp[-1].length) < be16_to_cpu(dfp[0].length))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/* Looks ok so far; now try to match up with a bestfree entry. */
 	*bf_ent = xfs_dir2_data_freefind(hdr, bf, dup);
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
@@ -975,17 +975,17 @@ xfs_dir2_data_check_free(
 	    hdr->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC) &&
 	    hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) &&
 	    hdr->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(dup->freetag) != XFS_DIR2_DATA_FREE_TAG)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (offset < (char *)dup - (char *)hdr)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (offset + len > (char *)dup + be16_to_cpu(dup->length) - (char *)hdr)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if ((char *)dup - (char *)hdr !=
 			be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)))
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /* Sanity-check a new bestfree entry. */
@@ -997,12 +997,12 @@ xfs_dir2_data_check_new_free(
 	struct xfs_dir2_data_unused	*newdup)
 {
 	if (dfp == NULL)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (dfp->length != newdup->length)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be16_to_cpu(dfp->offset) != (char *)newdup - (char *)hdr)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a225dcdc11c8..4488b898ca97 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -52,9 +52,9 @@ xfs_dir3_leaf1_check(
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_dir3_leaf_check_int(vc, dp->i_mount, dp, &leafhdr, leaf);
 }
@@ -115,27 +115,27 @@ xfs_dir3_leaf_check_int(
 	 * We can deduce a value for that from di_size.
 	 */
 	if (hdr->count > ops->leaf_max_ents(geo))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Leaves and bests don't overlap in leaf format. */
 	if ((hdr->magic == XFS_DIR2_LEAF1_MAGIC ||
 	     hdr->magic == XFS_DIR3_LEAF1_MAGIC) &&
 	    (char *)&ents[hdr->count] > (char *)xfs_dir2_leaf_bests_p(ltp))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Check hash value order, count stale entries.  */
 	for (i = stale = 0; i < hdr->count; i++) {
 		if (i + 1 < hdr->count) {
 			if (be32_to_cpu(ents[i].hashval) >
 					be32_to_cpu(ents[i + 1].hashval))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		}
 		if (ents[i].address == cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 			stale++;
 	}
 	if (hdr->stale != stale)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
@@ -162,16 +162,16 @@ xfs_dir3_leaf_verify(
 							 : XFS_DIR3_LEAFN_MAGIC;
 
 		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (leaf->hdr.info.magic != cpu_to_be16(magic))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	return xfs_dir3_leaf_check_int(vc, mp, NULL, NULL, leaf);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 8174e469b14f..1920caa65895 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -55,9 +55,9 @@ xfs_dir3_leafn_check(
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
 		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_dir3_leaf_check_int(vc, dp->i_mount, dp, &leafhdr, leaf);
 }
@@ -94,21 +94,21 @@ xfs_dir3_free_verify(
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
 		if (hdr3->magic != cpu_to_be32(XFS_DIR3_FREE_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		if (hdr->magic != cpu_to_be32(XFS_DIR2_FREE_MAGIC))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/* XXX: should bounds check the xfs_dir3_icfree_hdr here */
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -181,22 +181,22 @@ xfs_dir3_free_header_check(
 		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
 
 		if (be32_to_cpu(hdr3->firstdb) != firstdb)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be32_to_cpu(hdr3->nvalid) > maxbests)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
 		if (be32_to_cpu(hdr->firstdb) != firstdb)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be32_to_cpu(hdr->nvalid) > maxbests)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be32_to_cpu(hdr->nvalid) < be32_to_cpu(hdr->nused))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static int
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ea47b403c1c1..659243991b61 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -652,7 +652,7 @@ xfs_dir2_sf_verify(
 	 */
 	if (size <= offsetof(struct xfs_dir2_sf_hdr, parent) ||
 	    size < xfs_dir2_sf_hdr_size(sfp->i8count))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	endp = (char *)sfp + size;
 
@@ -661,7 +661,7 @@ xfs_dir2_sf_verify(
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 	error = xfs_dir_ino_validate(mp, ino);
 	if (error)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	offset = dops->data_first_offset;
 
 	/* Check all reported entries */
@@ -673,11 +673,11 @@ xfs_dir2_sf_verify(
 		 * within the data buffer.
 		 */
 		if (((char *)sfep + sizeof(*sfep)) >= endp)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* Don't allow names with known bad length. */
 		if (sfep->namelen == 0)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/*
 		 * Check that the variable-length part of the structure is
@@ -686,23 +686,23 @@ xfs_dir2_sf_verify(
 		 */
 		next_sfep = dops->sf_nextentry(sfp, sfep);
 		if (endp < (char *)next_sfep)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* Check that the offsets always increase. */
 		if (xfs_dir2_sf_get_offset(sfep) < offset)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* Check the inode number. */
 		ino = dops->sf_get_ino(sfp, sfep);
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		error = xfs_dir_ino_validate(mp, ino);
 		if (error)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		/* Check the file type. */
 		filetype = dops->sf_get_ftype(sfep);
 		if (filetype >= XFS_DIR3_FT_MAX)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 
 		offset = xfs_dir2_sf_get_offset(sfep) +
 				dops->data_entsize(sfep->namelen);
@@ -710,16 +710,16 @@ xfs_dir2_sf_verify(
 		sfep = next_sfep;
 	}
 	if (i8count != sfp->i8count)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if ((void *)sfep != (void *)endp)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Make sure this whole thing ought to be in local format. */
 	if (offset + (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
 	    (uint)sizeof(xfs_dir2_block_tail_t) > mp->m_dir_geo->blksize)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index bbc63656a6d2..0b7c76c5f3e1 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -59,39 +59,39 @@ xfs_dquot_verify(
 	 * any quota information. Just don't complain about bad dquot blks.
 	 */
 	if (ddq->d_magic != cpu_to_be16(XFS_DQUOT_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (ddq->d_version != XFS_DQUOT_VERSION)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (type && ddq->d_flags != type)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (ddq->d_flags != XFS_DQ_USER &&
 	    ddq->d_flags != XFS_DQ_PROJ &&
 	    ddq->d_flags != XFS_DQ_GROUP)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (!ddq->d_id)
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	if (ddq->d_blk_softlimit &&
 	    be64_to_cpu(ddq->d_bcount) > be64_to_cpu(ddq->d_blk_softlimit) &&
 	    !ddq->d_btimer)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (ddq->d_ino_softlimit &&
 	    be64_to_cpu(ddq->d_icount) > be64_to_cpu(ddq->d_ino_softlimit) &&
 	    !ddq->d_itimer)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (ddq->d_rtb_softlimit &&
 	    be64_to_cpu(ddq->d_rtbcount) > be64_to_cpu(ddq->d_rtb_softlimit) &&
 	    !ddq->d_rtbtimer)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 xfs_failaddr_t
@@ -104,7 +104,7 @@ xfs_dqblk_verify(
 {
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_dquot_verify(vc, mp, &dqb->dd_diskdq, id, type);
 }
@@ -223,7 +223,7 @@ xfs_dquot_buf_verify(
 		}
 	}
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static xfs_failaddr_t
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a204112c8c90..f24abdc20d3b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2506,28 +2506,28 @@ xfs_agi_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_log_check_lsn(mp,
 				be64_to_cpu(XFS_BUF_TO_AGI(bp)->agi_lsn)))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/*
 	 * Validate the magic number of the agi block.
 	 */
 	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (be32_to_cpu(agi->agi_level) < 1 ||
 	    be32_to_cpu(agi->agi_level) > XFS_BTREE_MAXLEVELS)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (xfs_sb_version_hasfinobt(&mp->m_sb) &&
 	    (be32_to_cpu(agi->agi_free_level) < 1 ||
 	     be32_to_cpu(agi->agi_free_level) > XFS_BTREE_MAXLEVELS))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -2536,16 +2536,16 @@ xfs_agi_verify(
 	 * so we can detect and avoid this problem.
 	 */
 	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
 		if (agi->agi_unlinked[i] == cpu_to_be32(NULLAGINO))
 			continue;
 		if (!xfs_verify_ino(mp, be32_to_cpu(agi->agi_unlinked[i])))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 02d7dd5c265c..a3902165aac5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -285,13 +285,13 @@ xfs_inobt_verify(
 	case cpu_to_be32(XFS_FIBT_MAGIC):
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (level >= mp->m_in_maxlevels)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_btree_sblock_verify(vc, bp, mp->m_inobt_mxr[level != 0]);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index d7a8199d5f36..a04f75f2885f 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -394,30 +394,30 @@ xfs_dinode_verify_fork(
 		 */
 		if (whichfork == XFS_DATA_FORK) {
 			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 			if (be64_to_cpu(dip->di_size) >
 					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		}
 		if (di_nextents)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		if (di_nextents > XFS_DFORK_MAXEXT(dip, mp, whichfork))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (whichfork == XFS_ATTR_FORK) {
 			if (di_nextents > MAXAEXTNUM)
-				return __this_address;
+				return XFS_CORRUPTED_RETURN(vc);
 		} else if (di_nextents > MAXEXTNUM) {
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		}
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static xfs_failaddr_t
@@ -427,23 +427,23 @@ xfs_dinode_verify_forkoff(
 	struct xfs_mount	*mp)
 {
 	if (!XFS_DFORK_Q(dip))
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	switch (dip->di_format)  {
 	case XFS_DINODE_FMT_DEV:
 		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
 		if (dip->di_forkoff >= (XFS_LITINO(mp, dip->di_version) >> 3))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 xfs_failaddr_t
@@ -460,47 +460,47 @@ xfs_dinode_verify(
 	uint64_t		di_size;
 
 	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!xfs_verify_cksum(vc, (char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (be64_to_cpu(dip->di_ino) != ino)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/* don't allow invalid i_size */
 	di_size = be64_to_cpu(dip->di_size);
 	if (di_size & (1ULL << 63))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	mode = be16_to_cpu(dip->di_mode);
 	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* No zero-length symlinks/dirs. */
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* Fork checks carried over from xfs_iformat_fork */
 	if (mode &&
 	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
 			be64_to_cpu(dip->di_nblocks))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	flags = be16_to_cpu(dip->di_flags);
 
 	if (mode && (flags & XFS_DIFLAG_REALTIME) && !mp->m_rtdev_targp)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* check for illegal values of forkoff */
 	fa = xfs_dinode_verify_forkoff(vc, dip, mp);
@@ -514,7 +514,7 @@ xfs_dinode_verify(
 	case S_IFBLK:
 	case S_IFSOCK:
 		if (dip->di_format != XFS_DINODE_FMT_DEV)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		break;
 	case S_IFREG:
 	case S_IFLNK:
@@ -527,7 +527,7 @@ xfs_dinode_verify(
 		/* Uninitialized inode ok. */
 		break;
 	default:
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	if (XFS_DFORK_Q(dip)) {
@@ -546,10 +546,10 @@ xfs_dinode_verify(
 		case XFS_DINODE_FMT_EXTENTS:
 			break;
 		default:
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 		}
 		if (dip->di_anextents)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	}
 
 	/* extent size hint validation */
@@ -560,26 +560,26 @@ xfs_dinode_verify(
 
 	/* only version 3 or greater inodes are extensively verified here */
 	if (dip->di_version < 3)
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	flags2 = be64_to_cpu(dip->di_flags2);
 
 	/* don't allow reflink/cowextsize if we don't have reflink */
 	if ((flags2 & (XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)) &&
 	     !xfs_sb_version_hasreflink(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* only regular files get reflink */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (mode & S_IFMT) != S_IFREG)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* don't let reflink and realtime mix */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* don't let reflink and dax mix */
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags2 & XFS_DIFLAG2_DAX))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* COW extent size hint validation */
 	fa = xfs_inode_validate_cowextsize(vc, mp, be32_to_cpu(dip->di_cowextsize),
@@ -587,7 +587,7 @@ xfs_dinode_verify(
 	if (fa)
 		return fa;
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 void
@@ -759,31 +759,31 @@ xfs_inode_validate_extsize(
 		blocksize_bytes = mp->m_sb.sb_blocksize;
 
 	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (hint_flag && !S_ISREG(mode))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (inherit_flag && !S_ISDIR(mode))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if ((hint_flag || inherit_flag) && extsize == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* free inodes get flags set to zero but extsize remains */
 	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (extsize_bytes % blocksize_bytes)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (extsize > MAXEXTLEN)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (!rt_flag && extsize > mp->m_sb.sb_agblocks / 2)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
@@ -810,29 +810,29 @@ xfs_inode_validate_cowextsize(
 	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
 	if (hint_flag && !xfs_sb_version_hasreflink(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (hint_flag && !(S_ISDIR(mode) || S_ISREG(mode)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (hint_flag && cowextsize == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* free inodes get flags set to zero but cowextsize remains */
 	if (mode && !hint_flag && cowextsize != 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (hint_flag && rt_flag)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (cowextsize_bytes % mp->m_sb.sb_blocksize)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (cowextsize > MAXEXTLEN)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (cowextsize > mp->m_sb.sb_agblocks / 2)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 49dd81b0728f..78ee502d856e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -708,7 +708,7 @@ xfs_ifork_verify_data(
 {
 	/* Non-local data fork, we're done. */
 	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	/* Check the inline data fork if there is one. */
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
@@ -717,7 +717,7 @@ xfs_ifork_verify_data(
 	case S_IFLNK:
 		return ops->verify_symlink(vc, ip);
 	default:
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 	}
 }
 
@@ -730,8 +730,8 @@ xfs_ifork_verify_attr(
 {
 	/* There has to be an attr fork allocated if aformat is local. */
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	return ops->verify_attr(vc, ip);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 125b536538ec..409ae8c08380 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -213,10 +213,10 @@ xfs_refcountbt_verify(
 	unsigned int		level;
 
 	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (!xfs_sb_version_hasreflink(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
 	if (fa)
 		return fa;
@@ -224,9 +224,9 @@ xfs_refcountbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_refcount_level)
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else if (level >= mp->m_refc_maxlevels)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_btree_sblock_verify(vc, bp, mp->m_refc_mxr[level != 0]);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f8828854ca2f..e9265c8c1cea 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -312,10 +312,10 @@ xfs_rmapbt_verify(
 	 * in this case.
 	 */
 	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
 	if (fa)
 		return fa;
@@ -323,9 +323,9 @@ xfs_rmapbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
-			return __this_address;
+			return XFS_CORRUPTED_RETURN(vc);
 	} else if (level >= mp->m_rmap_maxlevels)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	return xfs_btree_sblock_verify(vc, bp, mp->m_rmap_mxr[level != 0]);
 }
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 0405f17aae6f..9141a1635dac 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -95,22 +95,22 @@ xfs_symlink_verify(
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (dsl->sl_magic != cpu_to_be32(XFS_SYMLINK_MAGIC))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (be32_to_cpu(dsl->sl_offset) +
 				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (dsl->sl_owner == 0)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 	if (!xfs_log_check_lsn(mp, be64_to_cpu(dsl->sl_lsn)))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
-	return NULL;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static void
@@ -221,18 +221,18 @@ xfs_symlink_shortform_verify(
 
 	/* Zero length symlinks can exist while we're deleting a remote one. */
 	if (size == 0)
-		return NULL;
+		return XFS_VERIFIED_RETURN(vc);
 
 	/* No negative sizes or overly long symlink targets. */
 	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* No NULLs in the target either. */
 	if (memchr(sfp, 0, size - 1))
-		return __this_address;
+		return XFS_CORRUPTED_RETURN(vc);
 
 	/* We /did/ null-terminate the buffer, right? */
 	if (*endp != 0)
-		return __this_address;
-	return NULL;
+		return XFS_CORRUPTED_RETURN(vc);
+	return XFS_VERIFIED_RETURN(vc);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 6c27103522a9..d39c7e28ad00 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -45,6 +45,9 @@ struct xfs_vc {
 	xfs_failaddr_t	fa;
 };
 
+#define XFS_CORRUPTED_RETURN(vc) ({(vc)->fa = __this_address; __this_address;})
+#define XFS_VERIFIED_RETURN(vc) ({(vc)->fa = NULL; NULL;})
+
 /*
  * Null values for the types.
  */
-- 
2.17.0
