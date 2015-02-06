Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 142377F63
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 16:23:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8276304051
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 14:23:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FNTKuyRgKaMWVSlz for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 14:23:45 -0800 (PST)
Message-ID: <54D53EF0.5060705@sandeen.net>
Date: Fri, 06 Feb 2015 16:23:44 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: pass mp to XFS_WANT_CORRUPTED_RETURN
References: <54D53E8C.8070207@redhat.com>
In-Reply-To: <54D53E8C.8070207@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Today, if we hit an XFS_WANT_CORRUPTED_RETURN we don't print
any information about which filesystem hit it.  Passing
in the mp allows us to print the filesystem (device) name,
which is a pretty critical piece of information.

Tested by running fsfuzzer 'til I hit some.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d38d69a..14a222f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -315,6 +315,9 @@ xfs_alloc_fixup_trees(
 	xfs_agblock_t	nfbno2;		/* second new free startblock */
 	xfs_extlen_t	nflen1=0;	/* first new free length */
 	xfs_extlen_t	nflen2=0;	/* second new free length */
+	struct xfs_mount *mp;
+
+	mp = cnt_cur->bc_mp;
 
 	/*
 	 * Look up the record in the by-size tree if necessary.
@@ -323,13 +326,13 @@ xfs_alloc_fixup_trees(
 #ifdef DEBUG
 		if ((error = xfs_alloc_get_rec(cnt_cur, &nfbno1, &nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp,
 			i == 1 && nfbno1 == fbno && nflen1 == flen);
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	}
 	/*
 	 * Look up the record in the by-block tree if necessary.
@@ -338,13 +341,13 @@ xfs_alloc_fixup_trees(
 #ifdef DEBUG
 		if ((error = xfs_alloc_get_rec(bno_cur, &nfbno1, &nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp,
 			i == 1 && nfbno1 == fbno && nflen1 == flen);
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(bno_cur, fbno, flen, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	}
 
 #ifdef DEBUG
@@ -355,7 +358,7 @@ xfs_alloc_fixup_trees(
 		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
 		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
 
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp,
 			bnoblock->bb_numrecs == cntblock->bb_numrecs);
 	}
 #endif
@@ -386,25 +389,25 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	/*
 	 * Add new by-size btree entry(s).
 	 */
 	if (nfbno1 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 0);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 0);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -415,7 +418,7 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -429,10 +432,10 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 0);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 	}
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c655a41..3d1a675 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5458,6 +5458,7 @@ xfs_bmse_merge(
 	struct xfs_bmbt_irec		left;
 	xfs_filblks_t			blockcount;
 	int				error, i;
+	struct xfs_mount		*mp = ip->i_mount;
 
 	xfs_bmbt_get_all(gotp, &got);
 	xfs_bmbt_get_all(leftp, &left);
@@ -5492,19 +5493,19 @@ xfs_bmse_merge(
 				   got.br_blockcount, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left.br_startoff, left.br_startblock,
 				   left.br_blockcount, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	left.br_blockcount = blockcount;
 
@@ -5526,6 +5527,7 @@ xfs_bmse_shift_one(
 	int				*logflags)
 {
 	struct xfs_ifork		*ifp;
+	struct xfs_mount		*mp;
 	xfs_fileoff_t			startoff;
 	struct xfs_bmbt_rec_host	*leftp;
 	struct xfs_bmbt_irec		got;
@@ -5533,13 +5535,14 @@ xfs_bmse_shift_one(
 	int				error;
 	int				i;
 
+	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	xfs_bmbt_get_all(gotp, &got);
 	startoff = got.br_startoff - offset_shift_fsb;
 
 	/* delalloc extents should be prevented by caller */
-	XFS_WANT_CORRUPTED_RETURN(!isnullstartblock(got.br_startblock));
+	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
 
 	/*
 	 * Check for merge if we've got an extent to the left, otherwise make
@@ -5578,7 +5581,7 @@ xfs_bmse_shift_one(
 				   got.br_blockcount, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
 
 	got.br_startoff = startoff;
 	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8c5ce10..c72283d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -168,7 +168,7 @@ xfs_btree_check_lptr(
 	xfs_fsblock_t		bno,	/* btree block disk address */
 	int			level)	/* btree block level */
 {
-	XFS_WANT_CORRUPTED_RETURN(
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
 		level > 0 &&
 		bno != NULLFSBLOCK &&
 		XFS_FSB_SANITY_CHECK(cur->bc_mp, bno));
@@ -187,7 +187,7 @@ xfs_btree_check_sptr(
 {
 	xfs_agblock_t		agblocks = cur->bc_mp->m_sb.sb_agblocks;
 
-	XFS_WANT_CORRUPTED_RETURN(
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
 		level > 0 &&
 		bno != NULLAGBLOCK &&
 		bno != 0 &&
@@ -1825,7 +1825,7 @@ xfs_btree_lookup(
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_RETURN(i == 1);
+			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 			XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
 			*stat = 1;
 			return 0;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 5ff31be..de1ea16 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -89,7 +89,7 @@ __xfs_dir3_data_check(
 		 * so just ensure that the count falls somewhere inside the
 		 * block right now.
 		 */
-		XFS_WANT_CORRUPTED_RETURN(be32_to_cpu(btp->count) <
+		XFS_WANT_CORRUPTED_RETURN(mp, be32_to_cpu(btp->count) <
 			((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry));
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
@@ -107,21 +107,21 @@ __xfs_dir3_data_check(
 	bf = ops->data_bestfree_p(hdr);
 	count = lastfree = freeseen = 0;
 	if (!bf[0].length) {
-		XFS_WANT_CORRUPTED_RETURN(!bf[0].offset);
+		XFS_WANT_CORRUPTED_RETURN(mp, !bf[0].offset);
 		freeseen |= 1 << 0;
 	}
 	if (!bf[1].length) {
-		XFS_WANT_CORRUPTED_RETURN(!bf[1].offset);
+		XFS_WANT_CORRUPTED_RETURN(mp, !bf[1].offset);
 		freeseen |= 1 << 1;
 	}
 	if (!bf[2].length) {
-		XFS_WANT_CORRUPTED_RETURN(!bf[2].offset);
+		XFS_WANT_CORRUPTED_RETURN(mp, !bf[2].offset);
 		freeseen |= 1 << 2;
 	}
 
-	XFS_WANT_CORRUPTED_RETURN(be16_to_cpu(bf[0].length) >=
+	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[0].length) >=
 						be16_to_cpu(bf[1].length));
-	XFS_WANT_CORRUPTED_RETURN(be16_to_cpu(bf[1].length) >=
+	XFS_WANT_CORRUPTED_RETURN(mp, be16_to_cpu(bf[1].length) >=
 						be16_to_cpu(bf[2].length));
 	/*
 	 * Loop over the data/unused entries.
@@ -134,18 +134,18 @@ __xfs_dir3_data_check(
 		 * doesn't need to be there.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			XFS_WANT_CORRUPTED_RETURN(lastfree == 0);
-			XFS_WANT_CORRUPTED_RETURN(
+			XFS_WANT_CORRUPTED_RETURN(mp, lastfree == 0);
+			XFS_WANT_CORRUPTED_RETURN(mp,
 				be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) ==
 					       (char *)dup - (char *)hdr);
 			dfp = xfs_dir2_data_freefind(hdr, bf, dup);
 			if (dfp) {
 				i = (int)(dfp - bf);
-				XFS_WANT_CORRUPTED_RETURN(
+				XFS_WANT_CORRUPTED_RETURN(mp,
 					(freeseen & (1 << i)) == 0);
 				freeseen |= 1 << i;
 			} else {
-				XFS_WANT_CORRUPTED_RETURN(
+				XFS_WANT_CORRUPTED_RETURN(mp,
 					be16_to_cpu(dup->length) <=
 						be16_to_cpu(bf[2].length));
 			}
@@ -160,13 +160,13 @@ __xfs_dir3_data_check(
 		 * The linear search is crude but this is DEBUG code.
 		 */
 		dep = (xfs_dir2_data_entry_t *)p;
-		XFS_WANT_CORRUPTED_RETURN(dep->namelen != 0);
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp, dep->namelen != 0);
+		XFS_WANT_CORRUPTED_RETURN(mp,
 			!xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)));
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp,
 			be16_to_cpu(*ops->data_entry_tag_p(dep)) ==
 					       (char *)dep - (char *)hdr);
-		XFS_WANT_CORRUPTED_RETURN(
+		XFS_WANT_CORRUPTED_RETURN(mp,
 				ops->data_get_ftype(dep) < XFS_DIR3_FT_MAX);
 		count++;
 		lastfree = 0;
@@ -183,14 +183,15 @@ __xfs_dir3_data_check(
 				    be32_to_cpu(lep[i].hashval) == hash)
 					break;
 			}
-			XFS_WANT_CORRUPTED_RETURN(i < be32_to_cpu(btp->count));
+			XFS_WANT_CORRUPTED_RETURN(mp,
+						  i < be32_to_cpu(btp->count));
 		}
 		p += ops->data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
 	 */
-	XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
+	XFS_WANT_CORRUPTED_RETURN(mp, freeseen == 7);
 	if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
 	    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC)) {
 		for (i = stale = 0; i < be32_to_cpu(btp->count); i++) {
@@ -198,13 +199,13 @@ __xfs_dir3_data_check(
 			    cpu_to_be32(XFS_DIR2_NULL_DATAPTR))
 				stale++;
 			if (i > 0)
-				XFS_WANT_CORRUPTED_RETURN(
+				XFS_WANT_CORRUPTED_RETURN(mp,
 					be32_to_cpu(lep[i].hashval) >=
 						be32_to_cpu(lep[i - 1].hashval));
 		}
-		XFS_WANT_CORRUPTED_RETURN(count ==
+		XFS_WANT_CORRUPTED_RETURN(mp, count ==
 			be32_to_cpu(btp->count) - be32_to_cpu(btp->stale));
-		XFS_WANT_CORRUPTED_RETURN(stale == be32_to_cpu(btp->stale));
+		XFS_WANT_CORRUPTED_RETURN(mp, stale == be32_to_cpu(btp->stale));
 	}
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f95c4ae..db04448 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -700,7 +700,7 @@ xfs_ialloc_next_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 	}
 
 	return 0;
@@ -724,7 +724,7 @@ xfs_ialloc_get_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 	}
 
 	return 0;
@@ -1016,7 +1016,7 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(lcur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(i == 1);
+		XFS_WANT_CORRUPTED_RETURN(lcur->bc_mp, i == 1);
 
 		/*
 		 * See if we've landed in the parent inode record. The finobt
@@ -1095,7 +1095,7 @@ xfs_dialloc_ag_finobt_newino(
 			error = xfs_inobt_get_rec(cur, rec, &i);
 			if (error)
 				return error;
-			XFS_WANT_CORRUPTED_RETURN(i == 1);
+			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 			return 0;
 		}
 	}
@@ -1106,12 +1106,12 @@ xfs_dialloc_ag_finobt_newino(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 
 	error = xfs_inobt_get_rec(cur, rec, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 
 	return 0;
 }
@@ -1133,19 +1133,19 @@ xfs_dialloc_ag_update_inobt(
 	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(i == 1);
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
 	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 
-	XFS_WANT_CORRUPTED_RETURN((rec.ir_free == frec->ir_free) &&
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, (rec.ir_free == frec->ir_free) &&
 				  (rec.ir_freecount == frec->ir_freecount));
 
 	return xfs_inobt_update(cur, &rec);
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 13eeca3..c0394ed 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -52,13 +52,13 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 		} \
 	}
 
-#define	XFS_WANT_CORRUPTED_RETURN(x)	\
+#define	XFS_WANT_CORRUPTED_RETURN(mp, x)	\
 	{ \
 		int fs_is_ok = (x); \
 		ASSERT(fs_is_ok); \
 		if (unlikely(!fs_is_ok)) { \
 			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_RETURN", \
-					 XFS_ERRLEVEL_LOW, NULL); \
+					 XFS_ERRLEVEL_LOW, mp); \
 			return -EFSCORRUPTED; \
 		} \
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 82e3142..8042989 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -229,7 +229,7 @@ xfs_bulkstat_grab_ichunk(
 	error = xfs_inobt_get_rec(cur, irec, &stat);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(stat == 1);
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
 
 	/* Check if the record contains the inode in request */
 	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
