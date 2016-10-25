Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46943 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:06:34 -0400
Subject: [PATCH 27/39] xfs_repair: check the existing refcount btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:06:28 -0700
Message-ID: <147743678891.11035.6488664698227918852.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Spot-check the refcount btree for obvious errors, and mark the
refcount btree blocks as such.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/incore.h     |    3 +
 repair/scan.c       |  185 +++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c |    2 +
 3 files changed, 189 insertions(+), 1 deletion(-)


diff --git a/repair/incore.h b/repair/incore.h
index bc0810b..b6c4b4f 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -106,7 +106,8 @@ typedef struct rt_extent_tree_node  {
 #define XR_E_INUSE_FS1	9	/* used by fs ag header or log (rmap btree) */
 #define XR_E_INO1	10	/* used by inodes (marked by rmap btree) */
 #define XR_E_FS_MAP1	11	/* used by fs space/inode maps (rmap btree) */
-#define XR_E_BAD_STATE	12
+#define XR_E_REFC	12	/* used by fs ag reference count btree */
+#define XR_E_BAD_STATE	13
 
 /* separate state bit, OR'ed into high (4th) bit of ex_state field */
 
diff --git a/repair/scan.c b/repair/scan.c
index 35a974a..c27f969 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -810,6 +810,9 @@ process_rmap_rec(
 		case XFS_RMAP_OWN_INODES:
 			set_bmap_ext(agno, b, blen, XR_E_INO1);
 			break;
+		case XFS_RMAP_OWN_REFC:
+			set_bmap_ext(agno, b, blen, XR_E_REFC);
+			break;
 		case XFS_RMAP_OWN_NULL:
 			/* still unknown */
 			break;
@@ -845,6 +848,14 @@ _("inode block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
 			agno, b, b + blen - 1,
 			name, state, owner);
 		break;
+	case XR_E_REFC:
+		if (owner == XFS_RMAP_OWN_REFC)
+			break;
+		do_warn(
+_("AG refcount block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+			agno, b, b + blen - 1,
+			name, state, owner);
+		break;
 	case XR_E_INUSE:
 		if (owner >= 0 &&
 		    owner < mp->m_sb.sb_dblocks)
@@ -1161,6 +1172,167 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		rmap_avoid_check();
 }
 
+static void
+scan_refcbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	xfs_agblock_t		bno,
+	xfs_agnumber_t		agno,
+	int			suspect,
+	int			isroot,
+	__uint32_t		magic,
+	void			*priv)
+{
+	const char		*name = "refcount";
+	int			i;
+	xfs_refcount_ptr_t	*pp;
+	struct xfs_refcount_rec	*rp;
+	int			hdr_errors = 0;
+	int			numrecs;
+	int			state;
+	xfs_agblock_t		lastblock = 0;
+
+	if (magic != XFS_REFC_CRC_MAGIC) {
+		name = "(unknown)";
+		hdr_errors++;
+		suspect++;
+		goto out;
+	}
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in %s btree block %d/%d\n"),
+			be32_to_cpu(block->bb_magic), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(_("expected level %d got %d in %s btree block %d/%d\n"),
+			level, be16_to_cpu(block->bb_level), name, agno, bno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	/* check for btree blocks multiply claimed */
+	state = get_bmap(agno, bno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_REFC))  {
+		set_bmap(agno, bno, XR_E_MULT);
+		do_warn(
+_("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
+				name, state, agno, bno, suspect);
+		goto out;
+	}
+	set_bmap(agno, bno, XR_E_FS_MAP);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level == 0) {
+		if (numrecs > mp->m_refc_mxr[0])  {
+			numrecs = mp->m_refc_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_refc_mnr[0])  {
+			numrecs = mp->m_refc_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_refc_mnr[0], mp->m_refc_mxr[0],
+				name, agno, bno);
+			suspect++;
+		}
+
+		rp = XFS_REFCOUNT_REC_ADDR(block, 1);
+		for (i = 0; i < numrecs; i++) {
+			xfs_agblock_t		b, end;
+			xfs_extlen_t		len;
+			xfs_nlink_t		nr;
+
+			b = be32_to_cpu(rp[i].rc_startblock);
+			len = be32_to_cpu(rp[i].rc_blockcount);
+			nr = be32_to_cpu(rp[i].rc_refcount);
+			end = b + len;
+
+			if (!verify_agbno(mp, agno, b)) {
+				do_warn(
+	_("invalid start block %u in record %u of %s btree block %u/%u\n"),
+					b, i, name, agno, bno);
+				continue;
+			}
+			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+				do_warn(
+	_("invalid length %u in record %u of %s btree block %u/%u\n"),
+					len, i, name, agno, bno);
+				continue;
+			}
+
+			if (nr < 2 || nr > MAXREFCOUNT) {
+				do_warn(
+	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
+					nr, i, name, agno, bno);
+				continue;
+			}
+
+			if (b && b <= lastblock) {
+				do_warn(_(
+	"out-of-order %s btree record %d (%u %u) block %u/%u\n"),
+					name, i, b, len, agno, bno);
+			} else {
+				lastblock = b;
+			}
+
+			/* XXX: probably want to mark the reflinked areas? */
+		}
+		goto out;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
+
+	if (numrecs > mp->m_refc_mxr[1])  {
+		numrecs = mp->m_refc_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_refc_mnr[1])  {
+		numrecs = mp->m_refc_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs),
+			mp->m_refc_mnr[1], mp->m_refc_mxr[1],
+			name, agno, bno);
+		if (suspect)
+			goto out;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno, level, agno, suspect, scan_refcbt, 0,
+				    magic, priv, &xfs_refcountbt_buf_ops);
+		}
+	}
+out:
+	return;
+}
+
 /*
  * The following helpers are to help process and validate individual on-disk
  * inode btree records. We have two possible inode btrees with slightly
@@ -1951,6 +2123,19 @@ validate_agf(
 		}
 	}
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		bno = be32_to_cpu(agf->agf_refcount_root);
+		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+			scan_sbtree(bno,
+				    be32_to_cpu(agf->agf_refcount_level),
+				    agno, 0, scan_refcbt, 1, XFS_REFC_CRC_MAGIC,
+				    agcnts, &xfs_refcountbt_buf_ops);
+		} else  {
+			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
+				bno, agno);
+		}
+	}
+
 	if (be32_to_cpu(agf->agf_freeblks) != agcnts->agffreeblks) {
 		do_warn(_("agf_freeblks %u, counted %u in ag %u\n"),
 			be32_to_cpu(agf->agf_freeblks), agcnts->agffreeblks, agno);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index dc38ece..4d92b90 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -423,6 +423,8 @@ calc_mkfs(xfs_mount_t *mp)
 		fino_bno += min(2, mp->m_rmap_maxlevels); /* agfl blocks */
 		fino_bno++;
 	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		fino_bno++;
 
 	/*
 	 * If the log is allocated in the first allocation group we need to

