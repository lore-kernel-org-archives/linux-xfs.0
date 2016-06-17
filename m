Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5065F8128
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:37:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E551304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:38 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fJNjmbGLxcxHAwBg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:37:35 -0700 (PDT)
Subject: [PATCH 063/145] xfs_repair: check existing rmapbt entries against
	observed rmaps
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:37:26 -0700
Message-ID: <146612744678.16048.13958545888765262883.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Once we've finished collecting reverse mapping observations from the
metadata scan, check those observations against the rmap btree
(particularly if we're in -n mode) to detect rmapbt problems.

v2: Restructure after moving rmap_irec flags to separate field.
v3: Refactor code to prepare to do range queries for reflink.
Move unwritten bit to rm_offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |    6 +
 repair/rmap.c   |  253 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |   10 ++
 repair/scan.c   |  104 ++++++++++++++++++++---
 4 files changed, 362 insertions(+), 11 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 8880c91..e234d92 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -174,6 +174,12 @@ _("unable to add AG %u metadata reverse-mapping data.\n"), agno);
 	if (error)
 		do_error(
 _("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
+
+	error = check_rmaps(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while checking reverse-mappings"),
+			 strerror(-error));
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index 8f532fb..4648425 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -42,6 +42,7 @@ struct xfs_ag_rmap {
 };
 
 static struct xfs_ag_rmap *ag_rmaps;
+static bool rmapbt_suspect;
 
 /*
  * Compare rmap observations for array sorting.
@@ -442,3 +443,255 @@ dump_rmap(
 #else
 # define dump_rmap(m, a, r)
 #endif
+
+/*
+ * Return the number of rmap objects for an AG.
+ */
+size_t
+rmap_record_count(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno)
+{
+	return slab_count(ag_rmaps[agno].ar_rmaps);
+}
+
+/*
+ * Return a slab cursor that will return rmap objects in order.
+ */
+int
+init_rmap_cursor(
+	xfs_agnumber_t		agno,
+	struct xfs_slab_cursor	**cur)
+{
+	return init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare, cur);
+}
+
+/*
+ * Disable the refcount btree check.
+ */
+void
+rmap_avoid_check(void)
+{
+	rmapbt_suspect = true;
+}
+
+/* Look for an rmap in the rmapbt that matches a given rmap. */
+static int
+lookup_rmap(
+	struct xfs_btree_cur	*bt_cur,
+	struct xfs_rmap_irec	*rm_rec,
+	struct xfs_rmap_irec	*tmp,
+	int			*have)
+{
+	int			error;
+
+	/* Use the regular btree retrieval routine. */
+	error = xfs_rmap_lookup_le(bt_cur, rm_rec->rm_startblock,
+				rm_rec->rm_blockcount,
+				rm_rec->rm_owner, rm_rec->rm_offset,
+				rm_rec->rm_flags, have);
+	if (error)
+		return error;
+	if (*have == 0)
+		return error;
+	return xfs_rmap_get_rec(bt_cur, tmp, have);
+}
+
+/* Does the btree rmap cover the observed rmap? */
+#define NEXTP(x)	((x)->rm_startblock + (x)->rm_blockcount)
+#define NEXTL(x)	((x)->rm_offset + (x)->rm_blockcount)
+static bool
+is_good_rmap(
+	struct xfs_rmap_irec	*observed,
+	struct xfs_rmap_irec	*btree)
+{
+	/* Can't have mismatches in the flags or the owner. */
+	if (btree->rm_flags != observed->rm_flags ||
+	    btree->rm_owner != observed->rm_owner)
+		return false;
+
+	/*
+	 * Btree record can't physically start after the observed
+	 * record, nor can it end before the observed record.
+	 */
+	if (btree->rm_startblock > observed->rm_startblock ||
+	    NEXTP(btree) < NEXTP(observed))
+		return false;
+
+	/* If this is metadata or bmbt, we're done. */
+	if (XFS_RMAP_NON_INODE_OWNER(observed->rm_owner) ||
+	    (observed->rm_flags & XFS_RMAP_BMBT_BLOCK))
+		return true;
+	/*
+	 * Btree record can't logically start after the observed
+	 * record, nor can it end before the observed record.
+	 */
+	if (btree->rm_offset > observed->rm_offset ||
+	    NEXTL(btree) < NEXTL(observed))
+		return false;
+
+	return true;
+}
+#undef NEXTP
+#undef NEXTL
+
+/*
+ * Compare the observed reverse mappings against what's in the ag btree.
+ */
+int
+check_rmaps(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_slab_cursor	*rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	int			error;
+	int			have;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_rmap_irec	*rm_rec;
+	struct xfs_rmap_irec	tmp;
+	struct xfs_perag	*pag;		/* per allocation group data */
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+	if (rmapbt_suspect) {
+		if (no_modify && agno == 0)
+			do_warn(_("would rebuild corrupt rmap btrees.\n"));
+		return 0;
+	}
+
+	/* Create cursors to refcount structures */
+	error = init_rmap_cursor(agno, &rm_cur);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto err;
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	pag = xfs_perag_get(mp, agno);
+	pag->pagf_init = 0;
+	xfs_perag_put(pag);
+
+	bt_cur = xfs_rmapbt_init_cursor(mp, NULL, agbp, agno);
+	if (!bt_cur) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	rm_rec = pop_slab_cursor(rm_cur);
+	while (rm_rec) {
+		error = lookup_rmap(bt_cur, rm_rec, &tmp, &have);
+		if (error)
+			goto err;
+		if (!have) {
+			do_warn(
+_("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
+%s%soff %"PRIu64"\n"),
+				agno, rm_rec->rm_startblock,
+				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
+					_("unwritten ") : "",
+				rm_rec->rm_blockcount,
+				rm_rec->rm_owner,
+				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
+					_("attr ") : "",
+				(rm_rec->rm_flags & XFS_RMAP_BMBT_BLOCK) ?
+					_("bmbt ") : "",
+				rm_rec->rm_offset);
+			goto next_loop;
+		}
+
+		/* Compare each refcount observation against the btree's */
+		if (!is_good_rmap(rm_rec, &tmp)) {
+			do_warn(
+_("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
+%"PRIu64"; should be (%u/%u) %slen %u owner %"PRId64" %s%soff %"PRIu64"\n"),
+				agno, tmp.rm_startblock,
+				(tmp.rm_flags & XFS_RMAP_UNWRITTEN) ?
+					_("unwritten ") : "",
+				tmp.rm_blockcount,
+				tmp.rm_owner,
+				(tmp.rm_flags & XFS_RMAP_ATTR_FORK) ?
+					_("attr ") : "",
+				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
+					_("bmbt ") : "",
+				tmp.rm_offset,
+				agno, rm_rec->rm_startblock,
+				(rm_rec->rm_flags & XFS_RMAP_UNWRITTEN) ?
+					_("unwritten ") : "",
+				rm_rec->rm_blockcount,
+				rm_rec->rm_owner,
+				(rm_rec->rm_flags & XFS_RMAP_ATTR_FORK) ?
+					_("attr ") : "",
+				(rm_rec->rm_flags & XFS_RMAP_BMBT_BLOCK) ?
+					_("bmbt ") : "",
+				rm_rec->rm_offset);
+			goto next_loop;
+		}
+next_loop:
+		rm_rec = pop_slab_cursor(rm_cur);
+	}
+
+err:
+	if (bt_cur)
+		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	if (agbp)
+		libxfs_putbuf(agbp);
+	free_slab_cursor(&rm_cur);
+	return 0;
+}
+
+/* Compare the key fields of two rmap records. */
+__int64_t
+rmap_diffkeys(
+	struct xfs_rmap_irec	*kp1,
+	struct xfs_rmap_irec	*kp2)
+{
+	__u64			oa;
+	__u64			ob;
+	__int64_t		d;
+	struct xfs_rmap_irec	tmp;
+
+	tmp = *kp1;
+	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
+	oa = xfs_rmap_irec_offset_pack(&tmp);
+	tmp = *kp2;
+	tmp.rm_flags &= ~XFS_RMAP_REC_FLAGS;
+	ob = xfs_rmap_irec_offset_pack(&tmp);
+
+	d = (__int64_t)kp2->rm_startblock - kp1->rm_startblock;
+	if (d)
+		return d;
+
+	if (kp2->rm_owner > kp1->rm_owner)
+		return 1;
+	else if (kp1->rm_owner > kp2->rm_owner)
+		return -1;
+
+	if (ob > oa)
+		return 1;
+	else if (oa > ob)
+		return -1;
+	return 0;
+}
+
+/* Compute the high key of an rmap record. */
+void
+rmap_high_key_from_rec(
+	struct xfs_rmap_irec	*rec,
+	struct xfs_rmap_irec	*key)
+{
+	int			adj;
+
+	adj = rec->rm_blockcount - 1;
+
+	key->rm_startblock = rec->rm_startblock + adj;
+	key->rm_owner = rec->rm_owner;
+	key->rm_offset = rec->rm_offset;
+	key->rm_flags = rec->rm_flags & XFS_RMAP_KEY_FLAGS;
+	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
+	    (rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+		return;
+	key->rm_offset += adj;
+}
diff --git a/repair/rmap.h b/repair/rmap.h
index f948f25..d9d08d4 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -36,4 +36,14 @@ extern bool mergeable_rmaps(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
 extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
 
+extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
+extern int init_rmap_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+extern void rmap_avoid_check(void);
+extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
+
+extern __int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
+		struct xfs_rmap_irec *kp2);
+extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
+		struct xfs_rmap_irec *key);
+
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index 6157d71..6106d93 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -29,6 +29,7 @@
 #include "bmap.h"
 #include "progress.h"
 #include "threads.h"
+#include "slab.h"
 #include "rmap.h"
 
 static xfs_mount_t	*mp = NULL;
@@ -783,6 +784,11 @@ ino_issparse(
 	return xfs_inobt_is_sparse_disk(rp, offset);
 }
 
+struct rmap_priv {
+	struct aghdr_cnts	*agcnts;
+	struct xfs_rmap_irec	high_key;
+};
+
 static void
 scan_rmapbt(
 	struct xfs_btree_block	*block,
@@ -794,21 +800,26 @@ scan_rmapbt(
 	__uint32_t		magic,
 	void			*priv)
 {
-	struct aghdr_cnts	*agcnts = priv;
 	const char		*name = "rmap";
 	int			i;
 	xfs_rmap_ptr_t		*pp;
 	struct xfs_rmap_rec	*rp;
+	struct rmap_priv	*rmap_priv = priv;
 	int			hdr_errors = 0;
 	int			numrecs;
 	int			state;
 	xfs_agblock_t		lastblock = 0;
 	int64_t			lastowner = 0;
 	int64_t			lastoffset = 0;
+	struct xfs_rmap_key	*kp;
+	struct xfs_rmap_irec	key;
+
 
 	if (magic != XFS_RMAP_CRC_MAGIC) {
 		name = "(unknown)";
-		assert(0);
+		hdr_errors++;
+		suspect++;
+		goto out;
 	}
 
 	if (be32_to_cpu(block->bb_magic) != magic) {
@@ -816,7 +827,7 @@ scan_rmapbt(
 			be32_to_cpu(block->bb_magic), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
-			return;
+			goto out;
 	}
 
 	/*
@@ -825,8 +836,8 @@ scan_rmapbt(
 	 * free data block counter.
 	 */
 	if (!isroot) {
-		agcnts->agfbtreeblks++;
-		agcnts->fdblocks++;
+		rmap_priv->agcnts->agfbtreeblks++;
+		rmap_priv->agcnts->fdblocks++;
 	}
 
 	if (be16_to_cpu(block->bb_level) != level) {
@@ -834,7 +845,7 @@ scan_rmapbt(
 			level, be16_to_cpu(block->bb_level), name, agno, bno);
 		hdr_errors++;
 		if (suspect)
-			return;
+			goto out;
 	}
 
 	/* check for btree blocks multiply claimed */
@@ -844,7 +855,7 @@ scan_rmapbt(
 		do_warn(
 _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 				name, state, agno, bno, suspect);
-		return;
+		goto out;
 	}
 	set_bmap(agno, bno, XR_E_FS_MAP);
 
@@ -878,7 +889,20 @@ _("%s rmap btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 			len = be32_to_cpu(rp[i].rm_blockcount);
 			owner = be64_to_cpu(rp[i].rm_owner);
 			offset = be64_to_cpu(rp[i].rm_offset);
-			end = b + len;
+
+			key.rm_flags = 0;
+			key.rm_startblock = b;
+			key.rm_blockcount = len;
+			key.rm_owner = owner;
+			if (xfs_rmap_irec_offset_unpack(offset, &key)) {
+				/* Look for impossible flags. */
+				do_warn(
+	_("invalid flags in record %u of %s btree block %u/%u\n"),
+					i, name, agno, bno);
+				continue;
+			}
+
+			end = key.rm_startblock + key.rm_blockcount;
 
 			/* Make sure agbno & len make sense. */
 			if (!verify_agbno(mp, agno, b)) {
@@ -919,6 +943,18 @@ advance:
 					goto advance;
 			}
 
+			/* Check that we don't go past the high key. */
+			key.rm_startblock += key.rm_blockcount - 1;
+			if (!XFS_RMAP_NON_INODE_OWNER(key.rm_owner) &&
+			    !(key.rm_flags & XFS_RMAP_BMBT_BLOCK))
+				key.rm_offset += key.rm_blockcount - 1;
+			key.rm_blockcount = 0;
+			if (rmap_diffkeys(&rmap_priv->high_key, &key) > 0) {
+				do_warn(
+	_("record %d greater than high key of block (%u/%u) in %s tree\n"),
+					i, agno, bno, name);
+			}
+
 			/* Check for block owner collisions. */
 			for ( ; b < end; b += blen)  {
 				state = get_bmap_ext(agno, b, end, &blen);
@@ -996,7 +1032,7 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 				}
 			}
 		}
-		return;
+		goto out;
 	}
 
 	/*
@@ -1024,12 +1060,33 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 			mp->m_rmap_mnr[1], mp->m_rmap_mxr[1],
 			name, agno, bno);
 		if (suspect)
-			return;
+			goto out;
 		suspect++;
 	} else if (suspect) {
 		suspect = 0;
 	}
 
+	/* check the node's high keys */
+	for (i = 0; !isroot && i < numrecs; i++) {
+		kp = XFS_RMAP_HIGH_KEY_ADDR(block, i + 1);
+
+		key.rm_flags = 0;
+		key.rm_startblock = be32_to_cpu(kp->rm_startblock);
+		key.rm_owner = be64_to_cpu(kp->rm_owner);
+		if (xfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&key)) {
+			/* Look for impossible flags. */
+			do_warn(
+	_("invalid flags in key %u of %s btree block %u/%u\n"),
+				i, name, agno, bno);
+			continue;
+		}
+		if (rmap_diffkeys(&rmap_priv->high_key, &key) > 0)
+			do_warn(
+	_("key %d greater than high key of block (%u/%u) in %s tree\n"),
+				i, agno, bno, name);
+	}
+
 	for (i = 0; i < numrecs; i++)  {
 		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
 
@@ -1042,11 +1099,30 @@ _("unknown block (%d,%d-%d) mismatch on %s tree, state - %d,%" PRIx64 "\n"),
 		 * pointer mismatch, try and extract as much data
 		 * as possible.
 		 */
+		kp = XFS_RMAP_HIGH_KEY_ADDR(block, i + 1);
+		rmap_priv->high_key.rm_flags = 0;
+		rmap_priv->high_key.rm_startblock =
+				be32_to_cpu(kp->rm_startblock);
+		rmap_priv->high_key.rm_owner =
+				be64_to_cpu(kp->rm_owner);
+		if (xfs_rmap_irec_offset_unpack(be64_to_cpu(kp->rm_offset),
+				&rmap_priv->high_key)) {
+			/* Look for impossible flags. */
+			do_warn(
+	_("invalid flags in high key %u of %s btree block %u/%u\n"),
+				i, name, agno, bno);
+			continue;
+		}
+
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
 			scan_sbtree(bno, level, agno, suspect, scan_rmapbt, 0,
 				    magic, priv, &xfs_rmapbt_buf_ops);
 		}
 	}
+
+out:
+	if (suspect)
+		rmap_avoid_check();
 }
 
 /*
@@ -1815,15 +1891,21 @@ validate_agf(
 	}
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		struct rmap_priv	priv;
+
+		memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
+		priv.high_key.rm_blockcount = 0;
+		priv.agcnts = agcnts;
 		bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
 		if (bno != 0 && verify_agbno(mp, agno, bno)) {
 			scan_sbtree(bno,
 				    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]),
 				    agno, 0, scan_rmapbt, 1, XFS_RMAP_CRC_MAGIC,
-				    agcnts, &xfs_rmapbt_buf_ops);
+				    &priv, &xfs_rmapbt_buf_ops);
 		} else  {
 			do_warn(_("bad agbno %u for rmapbt root, agno %d\n"),
 				bno, agno);
+			rmap_avoid_check();
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
