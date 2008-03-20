Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Mar 2008 21:48:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2K4lwjL024300
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2008 21:48:00 -0700
Date: Thu, 20 Mar 2008 15:48:13 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH] Revalidate the btree cursor after an insert
Message-ID: <20080320044813.GY95344431@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Ensure a btree insert returns a valid cursor.

When writing into preallocated regions there is a case
where XFS can oops or hang doing the unwritten extent conversion
on I/O completion. It turns out thathte problem is related to
the btree cursor being invalid.

When we do an insert into the tree, we may need to split blocks
in the tree. When we only split at the leaf level (i.e. level 0),
everything works just fine. However, if we have a multi-level
split in the btreee, the cursor passed to the insert function is
no longer valid once the insert is complete.

The leaf level split is handled correctly because all the operations
at level 0 are done using the original cursor, hence it is updated
correctly. However, when we need to update the next level up the
tree, we don't use that cursor - we use a cloned cursor that points
to the index in the next level up where we need to do the insert.

Hence if we need to split a second level, the changes to the tree
are reflected in the cloned cursor and not the original cursor.
This clone-and-move-up-a-level-on-split behaviour recurses all
the way to the top of the tree.

The complexity here is that these cloned cursors do not point to
the original index that was inserted - they point to the newly
allocated block (the right block) and the original cursor pointer
to that level may still point to the left block. Hence, without deep
examination of the cloned cursor and buffers, we cannot update the
original cursor with the new path from the cloned cursor.

In these cases the original cursor could be pointing to the wrong
block(s) and hence a subsequent modification to the tree using that
cursor will lead to corruption of the tree.

The crash case occurs whenteh tree changes height - we insert a new
level in the tree, and the cursor does not have a buffer in it's path
for that level. Hence any attempt to walk back up the cursor to the
root block will result in a null pointer dereference.

To make matters even more complex, the BMAP BT is rooted in an inode,
so we can have a change of height in the btree *without a root split*.
That is, if the root block in the inode is full when we split a
leaf node, we cannot fit the pointer to the new block in the root,
so we allocate a new block, migrate all the ptrs out of the inode
into the new block and point the inode root block at the newly
allocated block. This changes the height of the tree without a
root split having occurred and hence invalidates the path in the
original cursor.

The patch below prevents xfs_bmbt_insert() from returning with an
invalid cursor by detecting the cases that invalidate the original
cursor and refresh it by do a lookup into the btree for the original
index we were inserting at.

Note that the INOBT, AGFBNO and AGFCNT btree implementations also have
this bug, but the cursor is currently always destroyed or revalidated
after an insert for those trees. Hence this patch only address the
problem in the BMBT code.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_bmap_btree.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bmap_btree.c	2008-03-14 11:33:48.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_bmap_btree.c	2008-03-20 15:45:19.351601515 +1100
@@ -2027,6 +2027,24 @@ xfs_bmbt_increment(
 
 /*
  * Insert the current record at the point referenced by cur.
+ *
+ * A multi-level split of the tree on insert will invalidate the original
+ * cursor. It appears, however, that some callers assume that the cursor is
+ * always valid. Hence if we do a multi-level split we need to revalidate the
+ * cursor.
+ *
+ * When a split occurs, we will see a new cursor returned. Use that as a
+ * trigger to determine if we need to revalidate the original cursor. If we get
+ * a split, then use the original irec to lookup up the path of the record we
+ * just inserted.
+ *
+ * Note that the fact that the btree root is in the inode means that we can
+ * have the level of the tree change without a "split" occurring at the root
+ * level. What happens is that the root is migrated to an allocated block and
+ * the inode root is pointed to it. This means a single split can change the
+ * level of the tree (level 2 -> level 3) and invalidate the old cursor. Hence
+ * the level change should be accounted as a split so as to correctly trigger a
+ * revalidation of the old cursor.
  */
 int					/* error */
 xfs_bmbt_insert(
@@ -2039,11 +2057,14 @@ xfs_bmbt_insert(
 	xfs_fsblock_t	nbno;
 	xfs_btree_cur_t	*ncur;
 	xfs_bmbt_rec_t	nrec;
+	xfs_bmbt_irec_t	oirec;		/* original irec */
 	xfs_btree_cur_t	*pcur;
+	int		splits = 0;
 
 	XFS_BMBT_TRACE_CURSOR(cur, ENTRY);
 	level = 0;
 	nbno = NULLFSBLOCK;
+	oirec = cur->bc_rec.b;
 	xfs_bmbt_disk_set_all(&nrec, &cur->bc_rec.b);
 	ncur = NULL;
 	pcur = cur;
@@ -2052,11 +2073,13 @@ xfs_bmbt_insert(
 				&i))) {
 			if (pcur != cur)
 				xfs_btree_del_cursor(pcur, XFS_BTREE_ERROR);
-			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
-			return error;
+			goto error0;
 		}
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 		if (pcur != cur && (ncur || nbno == NULLFSBLOCK)) {
+			/* allocating a new root is effectively a split */
+			if (cur->bc_nlevels != pcur->bc_nlevels)
+				splits++;
 			cur->bc_nlevels = pcur->bc_nlevels;
 			cur->bc_private.b.allocated +=
 				pcur->bc_private.b.allocated;
@@ -2070,10 +2093,21 @@ xfs_bmbt_insert(
 			xfs_btree_del_cursor(pcur, XFS_BTREE_NOERROR);
 		}
 		if (ncur) {
+			splits++;
 			pcur = ncur;
 			ncur = NULL;
 		}
 	} while (nbno != NULLFSBLOCK);
+
+	if (splits > 1) {
+		/* revalidate the old cursor as we had a multi-level split */
+		error = xfs_bmbt_lookup_eq(cur, oirec.br_startoff,
+				oirec.br_startblock, oirec.br_blockcount, &i);
+		if (error)
+			goto error0;
+		ASSERT(i == 1);
+	}
+
 	XFS_BMBT_TRACE_CURSOR(cur, EXIT);
 	*stat = i;
 	return 0;
