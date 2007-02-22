Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Feb 2007 17:26:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1M1Qam7004340
	for <xfs@oss.sgi.com>; Wed, 21 Feb 2007 17:26:38 -0800
Message-Id: <200702220126.MAA19208@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] xfs_repair doesn't detect corrupt btree roots in nodes
Date: Thu, 22 Feb 2007 12:32:43 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0190_01C7567D.8CBD37A0"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: xfs-dev@sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0190_01C7567D.8CBD37A0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

The attached patch detect invalid btree root field (numrecs = 0, levels >
permissable value).

The patch also does some cleanup with the level and numrecs usage for the
process_btinode function.


------=_NextPart_000_0190_01C7567D.8CBD37A0
Content-Type: application/octet-stream;
	name="detect_bad_btree_root.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="detect_bad_btree_root.diff"

--- a/xfsprogs/repair/dinode.c	2007-02-22 12:19:27.000000000 +1100
+++ b/xfsprogs/repair/dinode.c	2007-02-22 12:19:21.463097922 +1100
@@ -307,8 +307,8 @@ clear_dinode(xfs_mount_t *mp, xfs_dinode
  * misc. inode-related utility routines
  */
=20
-/*=20
- * verify_ag_bno is heavily used. In the common case, it=20
+/*
+ * verify_ag_bno is heavily used. In the common case, it
  * performs just two number of compares
  */
 static __inline int
@@ -802,7 +802,7 @@ process_bmbt_reclist_int(
 				PROCESS_BMBT_UNLOCK_RETURN(1);
 			}
=20
-			/* Process in chunks of 16 (XR_BB_UNIT/XR_BB)=20
+			/* Process in chunks of 16 (XR_BB_UNIT/XR_BB)
 			 * for common XR_E_UNKNOWN to XR_E_INUSE transition
 			 */
 			if (((agbno & XR_BB_MASK) =3D=3D 0) && ((s + c - b) >=3D (XR_BB_UNIT/XR=
_BB))) {
@@ -1223,6 +1223,8 @@ process_btinode(
 	xfs_bmbt_key_t		*pkey;
 	char			*forkname;
 	int			i;
+	int			level;
+	int			numrecs;
 	bmap_cursor_t		cursor;
=20
 	dib =3D (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
@@ -1235,13 +1237,11 @@ process_btinode(
 	else
 		forkname =3D _("attr");
=20
-	if (INT_GET(dib->bb_level, ARCH_CONVERT) =3D=3D 0) {
+	level =3D INT_GET(dib->bb_level, ARCH_CONVERT);
+	numrecs =3D INT_GET(dib->bb_numrecs, ARCH_CONVERT);
+
+	if ((level =3D=3D 0) || (level > XFS_BM_MAXLEVELS(mp, whichfork))) {
 		/*
-		 * This should never happen since a btree inode
-		 * has to have at least one other block in the
-		 * bmap in addition to the root block in the
-		 * inode's data fork.
-		 *
 		 * XXX - if we were going to fix up the inode,
 		 * we'd try to treat the fork as an interior
 		 * node and see if we could get an accurate
@@ -1249,28 +1249,30 @@ process_btinode(
 		 * to by the pointers in the fork.  For now
 		 * though, we just bail (and blow out the inode).
 		 */
-		do_warn(_("bad level 0 in inode %llu bmap btree root block\n"),
+		do_warn(_("bad level %d in inode %llu bmap btree root block\n"),
+			level, XFS_AGINO_TO_INO(mp, agno, ino));
+		return(1);
+	}
+	if (numrecs =3D=3D 0) {
+		do_warn(_("bad numrecs 0 in inode %llu bmap btree root block\n"),
 			XFS_AGINO_TO_INO(mp, agno, ino));
 		return(1);
 	}
 	/*
 	 * use bmdr/dfork_dsize since the root block is in the data fork
 	 */
-	init_bm_cursor(&cursor, INT_GET(dib->bb_level, ARCH_CONVERT) + 1);
-
-	if (XFS_BMDR_SPACE_CALC(INT_GET(dib->bb_numrecs, ARCH_CONVERT)) >
-			((whichfork =3D=3D XFS_DATA_FORK) ?
+	if (XFS_BMDR_SPACE_CALC(numrecs) > ((whichfork =3D=3D XFS_DATA_FORK) ?
 			XFS_DFORK_DSIZE(dip, mp) :
 			XFS_DFORK_ASIZE(dip, mp)))  {
 		do_warn(
 	_("indicated size of %s btree root (%d bytes) greater than space in "
 	  "inode %llu %s fork\n"),
-			forkname, XFS_BMDR_SPACE_CALC(INT_GET(dib->bb_numrecs,
-				ARCH_CONVERT)),
-			lino, forkname);
+			forkname, XFS_BMDR_SPACE_CALC(numrecs), lino, forkname);
 		return(1);
 	}
=20
+	init_bm_cursor(&cursor, level + 1);
+
 	pp =3D XFS_BTREE_PTR_ADDR(
 			XFS_DFORK_SIZE(dip, mp, whichfork),
 		xfs_bmdr, dib, 1,
@@ -1286,7 +1288,7 @@ process_btinode(
=20
 	last_key =3D NULLDFILOFF;
=20
-	for (i =3D 0; i < INT_GET(dib->bb_numrecs, ARCH_CONVERT); i++)  {
+	for (i =3D 0; i < numrecs; i++)  {
 		/*
 		 * XXX - if we were going to do more to fix up the inode
 		 * btree, we'd do it right here.  For now, if there's a
@@ -1298,8 +1300,8 @@ process_btinode(
 			return(1);
 		}
=20
-		if (scan_lbtree((xfs_dfsbno_t)INT_GET(pp[i], ARCH_CONVERT), INT_GET(dib-=
>bb_level, ARCH_CONVERT),
-				    scanfunc_bmap, type, whichfork,
+		if (scan_lbtree((xfs_dfsbno_t)INT_GET(pp[i], ARCH_CONVERT),
+				    level, scanfunc_bmap, type, whichfork,
 				    lino, tot, nex, blkmapp, &cursor,
 				    1, check_dups))
 			return(1);
@@ -1310,8 +1312,7 @@ process_btinode(
 		 * blocks but the parent hasn't been updated
 		 */
 		if (check_dups =3D=3D 0 &&
-		    cursor.level[INT_GET(dib->bb_level,
-				ARCH_CONVERT)-1].first_key !=3D
+		    cursor.level[level-1].first_key !=3D
 		    INT_GET(pkey[i].br_startoff, ARCH_CONVERT))  {
 			if (!no_modify)  {
 				do_warn(
@@ -1319,22 +1320,19 @@ process_btinode(
 	  "%llu %s fork\n"),
 					INT_GET(pkey[i].br_startoff,
 						ARCH_CONVERT),
-					cursor.level[INT_GET(dib->bb_level,
-						ARCH_CONVERT)-1].first_key,
+					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
 				*dirty =3D 1;
 				INT_SET(pkey[i].br_startoff, ARCH_CONVERT,
-					cursor.level[INT_GET(dib->bb_level,
-						ARCH_CONVERT)-1].first_key);
+					cursor.level[level-1].first_key);
 			} else  {
 				do_warn(
 	_("bad key in bmbt root (is %llu, would reset to %llu) in inode "
 	  "%llu %s fork\n"),
 					INT_GET(pkey[i].br_startoff,
 						ARCH_CONVERT),
-					cursor.level[INT_GET(dib->bb_level,
-						ARCH_CONVERT)-1].first_key,
+					cursor.level[level-1].first_key,
 					XFS_AGINO_TO_INO(mp, agno, ino),
 					forkname);
 			}
@@ -1345,8 +1343,7 @@ process_btinode(
 		 */
 		if (check_dups =3D=3D 0)  {
 			if (last_key !=3D NULLDFILOFF && last_key >=3D
-			    cursor.level[INT_GET(dib->bb_level,
-					ARCH_CONVERT)-1].first_key)  {
+			    cursor.level[level-1].first_key)  {
 				do_warn(
 		_("out of order bmbt root key %llu in inode %llu %s fork\n"),
 					first_key,
@@ -1354,8 +1351,7 @@ process_btinode(
 					forkname);
 				return(1);
 			}
-			last_key =3D cursor.level[INT_GET(dib->bb_level,
-						ARCH_CONVERT)-1].first_key;
+			last_key =3D cursor.level[level-1].first_key;
 		}
 	}
 	/*
@@ -2064,9 +2060,9 @@ process_dinode_int(xfs_mount_t *mp,
 		if (!verify_mode)  {
 			do_warn(_("bad inode type %#o inode %llu\n"),
 				(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
-			if (!no_modify)=20=20
+			if (!no_modify)
 				*dirty +=3D clear_dinode(mp, dino, lino);
-			else=20
+			else
 				*dirty =3D 1;
 			*cleared =3D 1;
 			*used =3D is_free;

------=_NextPart_000_0190_01C7567D.8CBD37A0--
