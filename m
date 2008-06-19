Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 23:12:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J6CjRO013306
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 23:12:46 -0700
Message-ID: <4859F9EB.5050505@sgi.com>
Date: Thu, 19 Jun 2008 16:17:15 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH V2] Always reset btree cursor after an insert
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

After a btree insert operation a cursor can be invalid due to block
splits and a maybe a new root block.  We reset the cursor in
xfs_bmbt_insert() in the cases where we think we need to but it
isn't enough as we still see assertions.  Just do what we do elsewhere
and reset the cursor unconditionally.  Version 2 adds
XFS_WANT_CORRUPTED_GOTO checks throughout xfs_bmap.c and removes the
fix to revalidate the original cursor in xfs_bmbt_insert().

Lachlan

--- fs/xfs/xfs_bmap.c_1.392	2008-06-16 17:25:09.000000000 +1000
+++ fs/xfs/xfs_bmap.c	2008-06-19 16:07:47.000000000 +1000
@@ -428,7 +428,8 @@ xfs_bmap_add_attrfork_btree(
 		cur->bc_private.b.firstblock = *firstblock;
 		if ((error = xfs_bmbt_lookup_ge(cur, 0, 0, 0, &stat)))
 			goto error0;
-		ASSERT(stat == 1);	/* must be at least one entry */
+		/* must be at least one entry */
+		XFS_WANT_CORRUPTED_GOTO(stat == 1, error0);
 		if ((error = xfs_bmbt_newroot(cur, flags, &stat)))
 			goto error0;
 		if (stat == 0) {
@@ -816,13 +817,13 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -860,7 +861,7 @@ xfs_bmap_add_extent_delay_real(
 					LEFT.br_startblock, LEFT.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -895,7 +896,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
 					new->br_startblock,
 					PREV.br_blockcount +
@@ -928,11 +929,11 @@ xfs_bmap_add_extent_delay_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		*dnew = 0;
 		/* DELTA: The in-core extent described by new changed type. */
@@ -963,7 +964,7 @@ xfs_bmap_add_extent_delay_real(
 					LEFT.br_startblock, LEFT.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 					LEFT.br_startblock,
 					LEFT.br_blockcount +
@@ -1004,11 +1005,11 @@ xfs_bmap_add_extent_delay_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
@@ -1054,7 +1055,7 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
@@ -1094,11 +1095,11 @@ xfs_bmap_add_extent_delay_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
@@ -1149,11 +1150,11 @@ xfs_bmap_add_extent_delay_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_nextents > ip->i_df.if_ext_max) {
@@ -1377,19 +1378,19 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + PREV.br_blockcount +
@@ -1426,13 +1427,13 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, LEFT.br_startoff,
 				LEFT.br_startblock,
 				LEFT.br_blockcount + PREV.br_blockcount,
@@ -1469,13 +1470,13 @@ xfs_bmap_add_extent_unwritten_real(
 					RIGHT.br_startblock,
 					RIGHT.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock,
 				new->br_blockcount + RIGHT.br_blockcount,
@@ -1508,7 +1509,7 @@ xfs_bmap_add_extent_unwritten_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 				new->br_startblock, new->br_blockcount,
 				newext)))
@@ -1549,7 +1550,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur,
 				PREV.br_startoff + new->br_blockcount,
 				PREV.br_startblock + new->br_blockcount,
@@ -1596,7 +1597,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur,
 				PREV.br_startoff + new->br_blockcount,
 				PREV.br_startblock + new->br_blockcount,
@@ -1606,7 +1607,7 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = *new;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1640,7 +1641,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock,
 					PREV.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
 				PREV.br_startblock,
 				PREV.br_blockcount - new->br_blockcount,
@@ -1682,7 +1683,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, PREV.br_startoff,
 				PREV.br_startblock,
 				PREV.br_blockcount - new->br_blockcount,
@@ -1692,11 +1693,11 @@ xfs_bmap_add_extent_unwritten_real(
 					new->br_startblock, new->br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = XFS_EXT_NORM;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		/* DELTA: One in-core extent is split in two. */
 		temp = PREV.br_startoff;
@@ -1732,7 +1733,7 @@ xfs_bmap_add_extent_unwritten_real(
 					PREV.br_startblock, PREV.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			/* new right extent - oldext */
 			if ((error = xfs_bmbt_update(cur, r[1].br_startoff,
 				r[1].br_startblock, r[1].br_blockcount,
@@ -1744,15 +1745,22 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = PREV;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
-			if ((error = xfs_bmbt_increment(cur, 0, &i)))
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
+			/*
+			 * Reset the cursor to the position of the new extent
+			 * we are about to insert as we can't trust it after
+			 * the previous insert.
+			 */
+			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
+					new->br_startblock, new->br_blockcount,
+					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			/* new middle extent - newext */
-			cur->bc_rec.b = *new;
+			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		/* DELTA: One in-core extent is split in three. */
 		temp = PREV.br_startoff;
@@ -2097,13 +2105,13 @@ xfs_bmap_add_extent_hole_real(
 					right.br_startblock,
 					right.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_delete(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_decrement(cur, 0, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
@@ -2139,7 +2147,7 @@ xfs_bmap_add_extent_hole_real(
 					left.br_startblock,
 					left.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, left.br_startoff,
 					left.br_startblock,
 					left.br_blockcount +
@@ -2174,7 +2182,7 @@ xfs_bmap_add_extent_hole_real(
 					right.br_startblock,
 					right.br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			if ((error = xfs_bmbt_update(cur, new->br_startoff,
 					new->br_startblock,
 					new->br_blockcount +
@@ -2208,11 +2216,11 @@ xfs_bmap_add_extent_hole_real(
 					new->br_startblock,
 					new->br_blockcount, &i)))
 				goto done;
-			ASSERT(i == 0);
+			XFS_WANT_CORRUPTED_GOTO(i == 0, done);
 			cur->bc_rec.b.br_state = new->br_state;
 			if ((error = xfs_bmbt_insert(cur, &i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		/* DELTA: A new extent was added in a hole. */
 		temp = new->br_startoff;
@@ -3131,7 +3139,7 @@ xfs_bmap_del_extent(
 					got.br_startblock, got.br_blockcount,
 					&i)))
 				goto done;
-			ASSERT(i == 1);
+			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
 		da_old = da_new = 0;
 	} else {
@@ -3164,7 +3172,7 @@ xfs_bmap_del_extent(
 		}
 		if ((error = xfs_bmbt_delete(cur, &i)))
 			goto done;
-		ASSERT(i == 1);
+		XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		break;
 
 	case 2:
@@ -3268,7 +3276,7 @@ xfs_bmap_del_extent(
 							got.br_startblock,
 							temp, &i)))
 						goto done;
-					ASSERT(i == 1);
+					XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 					/*
 					 * Update the btree record back
 					 * to the original value.
@@ -3289,7 +3297,7 @@ xfs_bmap_del_extent(
 					error = XFS_ERROR(ENOSPC);
 					goto done;
 				}
-				ASSERT(i == 1);
+				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 			} else
 				flags |= XFS_ILOG_FEXT(whichfork);
 			XFS_IFORK_NEXT_SET(ip, whichfork,
--- fs/xfs/xfs_bmap_btree.c_1.169	2008-06-16 17:25:10.000000000 +1000
+++ fs/xfs/xfs_bmap_btree.c	2008-06-19 16:12:43.000000000 +1000
@@ -2029,22 +2029,8 @@ xfs_bmbt_increment(
  * Insert the current record at the point referenced by cur.
  *
  * A multi-level split of the tree on insert will invalidate the original
- * cursor. It appears, however, that some callers assume that the cursor is
- * always valid. Hence if we do a multi-level split we need to revalidate the
- * cursor.
- *
- * When a split occurs, we will see a new cursor returned. Use that as a
- * trigger to determine if we need to revalidate the original cursor. If we get
- * a split, then use the original irec to lookup up the path of the record we
- * just inserted.
- *
- * Note that the fact that the btree root is in the inode means that we can
- * have the level of the tree change without a "split" occurring at the root
- * level. What happens is that the root is migrated to an allocated block and
- * the inode root is pointed to it. This means a single split can change the
- * level of the tree (level 2 -> level 3) and invalidate the old cursor. Hence
- * the level change should be accounted as a split so as to correctly trigger a
- * revalidation of the old cursor.
+ * cursor.  All callers of this function should assume that the cursor is
+ * no longer valid and revalidate it.
  */
 int					/* error */
 xfs_bmbt_insert(
@@ -2057,14 +2043,11 @@ xfs_bmbt_insert(
 	xfs_fsblock_t	nbno;
 	xfs_btree_cur_t	*ncur;
 	xfs_bmbt_rec_t	nrec;
-	xfs_bmbt_irec_t	oirec;		/* original irec */
 	xfs_btree_cur_t	*pcur;
-	int		splits = 0;
 
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	level = 0;
 	nbno = NULLFSBLOCK;
-	oirec = cur->bc_rec.b;
 	xfs_bmbt_disk_set_all(&nrec, &cur->bc_rec.b);
 	ncur = NULL;
 	pcur = cur;
@@ -2073,13 +2056,11 @@ xfs_bmbt_insert(
 				&i))) {
 			if (pcur != cur)
 				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			goto error0;
+			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
+			return error;
 		}
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		if (pcur != cur && (ncur || nbno == NULLFSBLOCK)) {
-			/* allocating a new root is effectively a split */
-			if (cur->bc_nlevels != pcur->bc_nlevels)
-				splits++;
 			cur->bc_nlevels = pcur->bc_nlevels;
 			cur->bc_private.b.allocated +=
 				pcur->bc_private.b.allocated;
@@ -2093,21 +2074,10 @@ xfs_bmbt_insert(
 			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
 		}
 		if (ncur) {
-			splits++;
 			pcur = ncur;
 			ncur = NULL;
 		}
 	} while (nbno != NULLFSBLOCK);
-
-	if (splits > 1) {
-		/* revalidate the old cursor as we had a multi-level split */
-		error = xfs_bmbt_lookup_eq(cur, oirec.br_startoff,
-				oirec.br_startblock, oirec.br_blockcount, &i);
-		if (error)
-			goto error0;
-		ASSERT(i == 1);
-	}
-
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 	*stat = i;
 	return 0;
