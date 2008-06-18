Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 02:04:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I944c1030939
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 02:04:06 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA15709 for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 19:05:01 +1000
Date: Wed, 18 Jun 2008 19:07:59 +1000
Subject: [PATCH] XFS: Fix returning case-preserved name with CI node form directories
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------EJpXaOfPIMJQnq9LtbCipS
MIME-Version: 1.0
Message-ID: <op.ucxszl2d3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------EJpXaOfPIMJQnq9LtbCipS
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

xfs_dir2_node_lookup() calls xfs_da_node_lookup_int() which iterates
through leaf blocks containing the matching hash value for the name
being looked up. Inside xfs_da_node_lookup_int(), it calls the
xfs_dir2_leafn_lookup_for_entry() for each leaf block.
xfs_dir2_leafn_lookup_for_entry() iterates through each matching
hash/offset pair doing a name comparison to find the matching
dirent.

For CI mode, the state->extrablk retains the details of the block
that has the CI match so xfs_dir2_node_lookup() can return the
case-preserved name.

The original implementation didn't retain the xfs_da_buf_t properly,
so the lookup was returning a bogus name to be stored in the dentry.

In the case of unlink, the bad name was passed and in debug mode,
ASSERTed when it can't find the entry.


---
  fs/xfs/xfs_dir2_node.c |   69=20=20
++++++++++++++++++++++++++++++-------------------
  1 file changed, 43 insertions(+), 26 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_dir2_node.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2_node.c
+++ 2.6.x-xfs/fs/xfs/xfs_dir2_node.c
@@ -549,7 +549,6 @@ xfs_dir2_leafn_lookup_for_entry(
  	xfs_dir2_data_entry_t	*dep;		/* data block entry */
  	xfs_inode_t		*dp;		/* incore directory inode */
  	int			error;		/* error return value */
-	int			di =3D -1;	/* data entry index */
  	int			index;		/* leaf entry index */
  	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
  	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
@@ -577,7 +576,6 @@ xfs_dir2_leafn_lookup_for_entry(
  	if (state->extravalid) {
  		curbp =3D state->extrablk.bp;
  		curdb =3D state->extrablk.blkno;
-		di =3D state->extrablk.index;
  	}
  	/*
  	 * Loop over leaf entries with the right hash value.
@@ -602,17 +600,27 @@ xfs_dir2_leafn_lookup_for_entry(
  		 */
  		if (newdb !=3D curdb) {
  			/*
-			 * If we had a block before, drop it.
+			 * If we had a block before that we aren't saving
+			 * for a CI name, drop it
  			 */
-			if (curbp)
+			if (curbp && (args->cmpresult =3D=3D XFS_CMP_DIFFERENT ||
+						curdb !=3D state->extrablk.blkno))
  				xfs_da_brelse(tp, curbp);
  			/*
-			 * Read the data block.
+			 * If needing the block that is saved with a CI match,
+			 * use it otherwise read in the new data block.
  			 */
-			error =3D xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp,
-					newdb), -1, &curbp, XFS_DATA_FORK);
-			if (error)
-				return error;
+			if (args->cmpresult !=3D XFS_CMP_DIFFERENT &&
+					newdb =3D=3D state->extrablk.blkno) {
+				ASSERT(state->extravalid);
+				curbp =3D state->extrablk.bp;
+			} else {
+				error =3D xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newdb),
+						-1, &curbp, XFS_DATA_FORK);
+				if (error)
+					return error;
+			}
  			xfs_dir2_data_check(dp, curbp);
  			curdb =3D newdb;
  		}
@@ -624,38 +632,47 @@ xfs_dir2_leafn_lookup_for_entry(
  		/*
  		 * Compare the entry and if it's an exact match, return
  		 * EEXIST immediately. If it's the first case-insensitive
-		 * match, store the inode number and continue looking.
+		 * match, store the block & inode number and continue looking.
  		 */
  		cmp =3D mp->m_dirnameops->compname(args, dep->name, dep->namelen);
  		if (cmp !=3D XFS_CMP_DIFFERENT && cmp !=3D args->cmpresult) {
+			/* If there is a CI match block, drop it */
+			if (args->cmpresult !=3D XFS_CMP_DIFFERENT &&
+						curdb !=3D state->extrablk.blkno)
+				xfs_da_brelse(tp, state->extrablk.bp);
  			args->cmpresult =3D cmp;
  			args->inumber =3D be64_to_cpu(dep->inumber);
-			di =3D (int)((char *)dep - (char *)curbp->data);
-			error =3D EEXIST;
+			*indexp =3D index;
+			state->extravalid =3D 1;
+			state->extrablk.bp =3D curbp;
+			state->extrablk.blkno =3D curdb;
+			state->extrablk.index =3D (int)((char *)dep -
+							(char *)curbp->data);
+			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
  			if (cmp =3D=3D XFS_CMP_EXACT)
-				goto out;
+				return XFS_ERROR(EEXIST);
  		}
  	}
-	/* Didn't find an exact match. */
-	error =3D ENOENT;
  	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) ||
  					(args->op_flags & XFS_DA_OP_OKNOENT));
-out:
  	if (curbp) {
-		/* Giving back a data block. */
-		state->extravalid =3D 1;
-		state->extrablk.bp =3D curbp;
-		state->extrablk.index =3D di;
-		state->extrablk.blkno =3D curdb;
-		state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		if (args->cmpresult =3D=3D XFS_CMP_DIFFERENT) {
+			/* Giving back last used data block. */
+			state->extravalid =3D 1;
+			state->extrablk.bp =3D curbp;
+			state->extrablk.index =3D -1;
+			state->extrablk.blkno =3D curdb;
+			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		} else {
+			/* If the curbp is not the CI match block, drop it */
+			if (state->extrablk.bp !=3D curbp)
+				xfs_da_brelse(tp, curbp);
+		}
  	} else {
  		state->extravalid =3D 0;
  	}
-	/*
-	 * Return the index, that will be the deletion point for remove/replace.
-	 */
  	*indexp =3D index;
-	return XFS_ERROR(error);
+	return XFS_ERROR(ENOENT);
  }

  /*
------------EJpXaOfPIMJQnq9LtbCipS
Content-Disposition: attachment; filename=fix_node_form_dir_ci_name_return.patch
Content-Type: text/x-patch; name=fix_node_form_dir_ci_name_return.patch
Content-Transfer-Encoding: Quoted-Printable

XFS: Fix returning case-preserved name with CI node form directories

xfs_dir2_node_lookup() calls xfs_da_node_lookup_int() which iterates
through leaf blocks containing the matching hash value for the name
being looked up. Inside xfs_da_node_lookup_int(), it calls the=20
xfs_dir2_leafn_lookup_for_entry() for each leaf block.=20
xfs_dir2_leafn_lookup_for_entry() iterates through each matching
hash/offset pair doing a name comparison to find the matching=20
dirent.=20

For CI mode, the state->extrablk retains the details of the block
that has the CI match so xfs_dir2_node_lookup() can return the
case-preserved name.

The original implementation didn't retain the xfs_da_buf_t properly,
so the lookup was returning a bogus name to be stored in the dentry.

In the case of unlink, the bad name was passed and in debug mode,
ASSERTed when it can't find the entry.


---
 fs/xfs/xfs_dir2_node.c |   69 ++++++++++++++++++++++++++++++--------------=
-----
 1 file changed, 43 insertions(+), 26 deletions(-)

Index: 2.6.x-xfs/fs/xfs/xfs_dir2_node.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- 2.6.x-xfs.orig/fs/xfs/xfs_dir2_node.c
+++ 2.6.x-xfs/fs/xfs/xfs_dir2_node.c
@@ -549,7 +549,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir2_data_entry_t	*dep;		/* data block entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
-	int			di =3D -1;	/* data entry index */
 	int			index;		/* leaf entry index */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry */
@@ -577,7 +576,6 @@ xfs_dir2_leafn_lookup_for_entry(
 	if (state->extravalid) {
 		curbp =3D state->extrablk.bp;
 		curdb =3D state->extrablk.blkno;
-		di =3D state->extrablk.index;
 	}
 	/*
 	 * Loop over leaf entries with the right hash value.
@@ -602,17 +600,27 @@ xfs_dir2_leafn_lookup_for_entry(
 		 */
 		if (newdb !=3D curdb) {
 			/*
-			 * If we had a block before, drop it.
+			 * If we had a block before that we aren't saving
+			 * for a CI name, drop it
 			 */
-			if (curbp)
+			if (curbp && (args->cmpresult =3D=3D XFS_CMP_DIFFERENT ||
+						curdb !=3D state->extrablk.blkno))
 				xfs_da_brelse(tp, curbp);
 			/*
-			 * Read the data block.
+			 * If needing the block that is saved with a CI match,
+			 * use it otherwise read in the new data block.
 			 */
-			error =3D xfs_da_read_buf(tp, dp, xfs_dir2_db_to_da(mp,
-					newdb), -1, &curbp, XFS_DATA_FORK);
-			if (error)
-				return error;
+			if (args->cmpresult !=3D XFS_CMP_DIFFERENT &&
+					newdb =3D=3D state->extrablk.blkno) {
+				ASSERT(state->extravalid);
+				curbp =3D state->extrablk.bp;
+			} else {
+				error =3D xfs_da_read_buf(tp, dp,
+						xfs_dir2_db_to_da(mp, newdb),
+						-1, &curbp, XFS_DATA_FORK);
+				if (error)
+					return error;
+			}
 			xfs_dir2_data_check(dp, curbp);
 			curdb =3D newdb;
 		}
@@ -624,38 +632,47 @@ xfs_dir2_leafn_lookup_for_entry(
 		/*
 		 * Compare the entry and if it's an exact match, return
 		 * EEXIST immediately. If it's the first case-insensitive
-		 * match, store the inode number and continue looking.
+		 * match, store the block & inode number and continue looking.
 		 */
 		cmp =3D mp->m_dirnameops->compname(args, dep->name, dep->namelen);
 		if (cmp !=3D XFS_CMP_DIFFERENT && cmp !=3D args->cmpresult) {
+			/* If there is a CI match block, drop it */
+			if (args->cmpresult !=3D XFS_CMP_DIFFERENT &&
+						curdb !=3D state->extrablk.blkno)
+				xfs_da_brelse(tp, state->extrablk.bp);
 			args->cmpresult =3D cmp;
 			args->inumber =3D be64_to_cpu(dep->inumber);
-			di =3D (int)((char *)dep - (char *)curbp->data);
-			error =3D EEXIST;
+			*indexp =3D index;
+			state->extravalid =3D 1;
+			state->extrablk.bp =3D curbp;
+			state->extrablk.blkno =3D curdb;
+			state->extrablk.index =3D (int)((char *)dep -
+							(char *)curbp->data);
+			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
 			if (cmp =3D=3D XFS_CMP_EXACT)
-				goto out;
+				return XFS_ERROR(EEXIST);
 		}
 	}
-	/* Didn't find an exact match. */
-	error =3D ENOENT;
 	ASSERT(index =3D=3D be16_to_cpu(leaf->hdr.count) ||
 					(args->op_flags & XFS_DA_OP_OKNOENT));
-out:
 	if (curbp) {
-		/* Giving back a data block. */
-		state->extravalid =3D 1;
-		state->extrablk.bp =3D curbp;
-		state->extrablk.index =3D di;
-		state->extrablk.blkno =3D curdb;
-		state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		if (args->cmpresult =3D=3D XFS_CMP_DIFFERENT) {
+			/* Giving back last used data block. */
+			state->extravalid =3D 1;
+			state->extrablk.bp =3D curbp;
+			state->extrablk.index =3D -1;
+			state->extrablk.blkno =3D curdb;
+			state->extrablk.magic =3D XFS_DIR2_DATA_MAGIC;
+		} else {
+			/* If the curbp is not the CI match block, drop it */
+			if (state->extrablk.bp !=3D curbp)
+				xfs_da_brelse(tp, curbp);
+		}
 	} else {
 		state->extravalid =3D 0;
 	}
-	/*
-	 * Return the index, that will be the deletion point for remove/replace.
-	 */
 	*indexp =3D index;
-	return XFS_ERROR(error);
+	return XFS_ERROR(ENOENT);
 }
=20
 /*

------------EJpXaOfPIMJQnq9LtbCipS--
