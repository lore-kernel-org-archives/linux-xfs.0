Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Apr 2007 21:16:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3D4FufB031559
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2007 21:16:00 -0700
Message-Id: <200704130415.OAA16550@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] xfs_repair - move realtime extent processing to a separate function
Date: Fri, 13 Apr 2007 14:22:10 +1000
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_025A_01C77DD7.1FB6E8F0"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, 'xfs-dev' <xfs-dev@sgi.com>

This is a multi-part message in MIME format.

------=_NextPart_000_025A_01C77DD7.1FB6E8F0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

While changing the process_bmbt_reclist_int() function, I observed a 
realtime check inside the block map get/set state loop which is quite
CPU intensive. Upon further investigation, this loop is not used at
all for realtime extents and that the two types of extents are pretty
much processed exclusively.

So, I simplified the functionality by moving the realtime extent
processing into it's own function and fixing a bug at the same time
when it comes to realtime inodes with attributes (it was comparing
attr extents to the realtime volume bmap instead of the normal bmap).

------=_NextPart_000_025A_01C77DD7.1FB6E8F0
Content-Type: application/octet-stream;
	name="separate_rt_extent_processing.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="separate_rt_extent_processing.patch"

Index: repair/xfsprogs/repair/dinode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- repair.orig/xfsprogs/repair/dinode.c	2007-04-13 13:07:16.000000000 +1000
+++ repair/xfsprogs/repair/dinode.c	2007-04-13 14:15:33.920960345 +1000
@@ -537,6 +537,121 @@
 		return (val);							\
 	} while (0)
=20
+static int
+process_rt_rec(
+	xfs_mount_t		*mp,
+	xfs_bmbt_rec_32_t	*rp,
+	xfs_ino_t		ino,
+	xfs_drfsbno_t		*tot,
+	int			check_dups)
+{
+	xfs_dfsbno_t		b;
+	xfs_drtbno_t		ext;
+	xfs_dfilblks_t		c;		/* count */
+	xfs_dfsbno_t		s;		/* start */
+	xfs_dfiloff_t		o;		/* offset */
+	int			state;
+	int			flag;		/* extent flag */
+	int			pwe;		/* partially-written extent */
+
+	convert_extent(rp, &o, &s, &c, &flag);
+
+	/*
+	 * check numeric validity of the extent
+	 */
+	if (s >=3D mp->m_sb.sb_rblocks)  {
+		do_warn(_("inode %llu - bad rt extent start block number "
+				"%llu, offset %llu\n"), ino, s, o);
+		return 1;
+	}
+	if (s + c - 1 >=3D mp->m_sb.sb_rblocks)  {
+		do_warn(_("inode %llu - bad rt extent last block number %llu, "
+				"offset %llu\n"), ino, s + c - 1, o);
+		return 1;
+	}
+	if (s + c - 1 < s)  {
+		do_warn(_("inode %llu - bad rt extent overflows - start %llu, "
+				"end %llu, offset %llu\n"),
+				ino, s, s + c - 1, o);
+		return 1;
+	}
+
+	/*
+	 * verify that the blocks listed in the record
+	 * are multiples of an extent
+	 */
+	if (XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) =3D=3D 0 &&
+			(s % mp->m_sb.sb_rextsize !=3D 0 ||
+			 c % mp->m_sb.sb_rextsize !=3D 0)) {
+		do_warn(_("malformed rt inode extent [%llu %llu] (fs rtext "
+				"size =3D %u)\n"), s, c, mp->m_sb.sb_rextsize);
+		return 1;
+	}
+
+	/*
+	 * set the appropriate number of extents
+	 */
+	for (b =3D s; b < s + c; b +=3D mp->m_sb.sb_rextsize)  {
+		ext =3D (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
+		pwe =3D XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) && flag &&
+				(b % mp->m_sb.sb_rextsize !=3D 0);
+
+		if (check_dups =3D=3D 1)  {
+			if (search_rt_dup_extent(mp, ext) && !pwe)  {
+				do_warn(_("data fork in rt ino %llu claims "
+						"dup rt extent, off - %llu, "
+						"start - %llu, count %llu\n"),
+						ino, o, s, c);
+				return 1;
+			}
+			continue;
+		}
+
+		state =3D get_rtbno_state(mp, ext);
+
+		switch (state)  {
+			case XR_E_FREE:
+			case XR_E_UNKNOWN:
+				set_rtbno_state(mp, ext, XR_E_INUSE);
+				break;
+
+			case XR_E_BAD_STATE:
+				do_error(_("bad state in rt block map %llu\n"),
+						ext);
+
+			case XR_E_FS_MAP:
+			case XR_E_INO:
+			case XR_E_INUSE_FS:
+				do_error(_("data fork in rt inode %llu found "
+						"metadata block %llu in rt bmap\n"),
+						ino, ext);
+
+			case XR_E_INUSE:
+				if (pwe)
+					break;
+
+			case XR_E_MULT:
+				set_rtbno_state(mp, ext, XR_E_MULT);
+				do_warn(_("data fork in rt inode %llu claims "
+						"used rt block %llu\n"),
+						ino, ext);
+				return 1;
+
+			case XR_E_FREE1:
+			default:
+				do_error(_("illegal state %d in rt block map "
+						"%llu\n"), state, b);
+		}
+	}
+
+	/*
+	 * bump up the block counter
+	 */
+	*tot +=3D c;
+
+	return 0;
+}
+
 /*
  * return 1 if inode should be cleared, 0 otherwise
  * if check_dups should be set to 1, that implies that
@@ -560,7 +675,6 @@
 	int			whichfork)
 {
 	xfs_dfsbno_t		b;
-	xfs_drtbno_t		ext;
 	xfs_dfilblks_t		c;		/* count */
 	xfs_dfilblks_t		cp =3D 0;		/* prev count */
 	xfs_dfsbno_t		s;		/* start */
@@ -572,7 +686,6 @@
 	int			i;
 	int			state;
 	int			flag;		/* extent flag */
-	int			pwe;		/* partially-written extent */
 	xfs_dfsbno_t		e;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -615,28 +728,22 @@
 				o, s, ino);
 			PROCESS_BMBT_UNLOCK_RETURN(1);
 		}
-		if (type =3D=3D XR_INO_RTDATA) {
-			if (s >=3D mp->m_sb.sb_rblocks)  {
-				do_warn(
-	_("inode %llu - bad rt extent start block number %llu, offset %llu\n"),
-					ino, s, o);
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-			if (s + c - 1 >=3D mp->m_sb.sb_rblocks)  {
-				do_warn(
-	_("inode %llu - bad rt extent last block number %llu, offset %llu\n"),
-					ino, s + c - 1, o);
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-			if (s + c - 1 < s)  {
-				do_warn(
-	_("inode %llu - bad rt extent overflows - start %llu, end %llu, "
-	  "offset %llu\n"),
-					ino, s, s + c - 1, o);
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-		} else  {
-			switch (verify_dfsbno_range(mp, s, c)) {
+
+		if (type =3D=3D XR_INO_RTDATA && whichfork =3D=3D XFS_DATA_FORK) {
+			/*
+			 * realtime bitmaps don't use AG locks, so returning
+			 * immediately is fine for this code path.
+			 */
+			if (process_rt_rec(mp, rp, ino, tot, check_dups))
+				return 1;
+			/*
+			 * skip rest of loop processing since that's
+			 * all for regular file forks and attr forks
+			 */
+			continue;
+		}
+
+		switch (verify_dfsbno_range(mp, s, c)) {
 			case XR_DFSBNORANGE_VALID:
 				break;
 			case XR_DFSBNORANGE_BADSTART:
@@ -656,109 +763,13 @@
 	  "offset %llu\n"),
 					ino, s, s + c - 1, o);
 				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-			if (o >=3D fs_max_file_offset)  {
-				do_warn(
+		}
+		if (o >=3D fs_max_file_offset)  {
+			do_warn(
 	_("inode %llu - extent offset too large - start %llu, count %llu, "
 	  "offset %llu\n"),
-					ino, s, c, o);
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-		}
-
-		/*
-		 * realtime file data fork
-		 */
-		if (type =3D=3D XR_INO_RTDATA && whichfork =3D=3D XFS_DATA_FORK)  {
-			/*
-			 * XXX - verify that the blocks listed in the record
-			 * are multiples of an extent
-			 */
-			if (XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) =3D=3D 0
-			   && (s % mp->m_sb.sb_rextsize !=3D 0 ||
-					c % mp->m_sb.sb_rextsize !=3D 0))  {
-				do_warn(
-	_("malformed rt inode extent [%llu %llu] (fs rtext size =3D %u)\n"),
-					s, c, mp->m_sb.sb_rextsize);
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-
-			/*
-			 * XXX - set the appropriate number of extents
-			 */
-			for (b =3D s; b < s + c; b +=3D mp->m_sb.sb_rextsize)  {
-				ext =3D (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
-				if (XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
-				    flag && (b % mp->m_sb.sb_rextsize !=3D 0)) {
-					pwe =3D 1;
-				} else {
-					pwe =3D 0;
-				}
-
-				if (check_dups =3D=3D 1)  {
-					if (search_rt_dup_extent(mp, ext) &&
-					    !pwe)  {
-						do_warn(
-	_("data fork in rt ino %llu claims dup rt extent, off - %llu, "
-	  "start - %llu, count %llu\n"),
-							ino, o, s, c);
-						PROCESS_BMBT_UNLOCK_RETURN(1);
-					}
-					continue;
-				}
-
-				state =3D get_rtbno_state(mp, ext);
-
-				switch (state)  {
-				case XR_E_FREE:
-/* XXX - turn this back on after we
-	run process_rtbitmap() in phase2
-					do_warn(
-			_("%s fork in rt ino %llu claims free rt block %llu\n"),
-						forkname, ino, ext);
-*/
-					/* fall through ... */
-				case XR_E_UNKNOWN:
-					set_rtbno_state(mp, ext, XR_E_INUSE);
-					break;
-				case XR_E_BAD_STATE:
-					do_error(
-				_("bad state in rt block map %llu\n"), ext);
-					abort();
-					break;
-				case XR_E_FS_MAP:
-				case XR_E_INO:
-				case XR_E_INUSE_FS:
-					do_error(
-	_("%s fork in rt inode %llu found metadata block %llu in %s bmap\n"),
-						forkname, ino, ext, ftype);
-				case XR_E_INUSE:
-					if (pwe)
-						break;
-				case XR_E_MULT:
-					set_rtbno_state(mp, ext, XR_E_MULT);
-					do_warn(
-	_("%s fork in rt inode %llu claims used rt block %llu\n"),
-						forkname, ino, ext);
-					PROCESS_BMBT_UNLOCK_RETURN(1);
-				case XR_E_FREE1:
-				default:
-					do_error(
-				_("illegal state %d in %s block map %llu\n"),
-						state, ftype, b);
-				}
-			}
-
-			/*
-			 * bump up the block counter
-			 */
-			*tot +=3D c;
-
-			/*
-			 * skip rest of loop processing since that's
-			 * all for regular file forks and attr forks
-			 */
-			continue;
+				ino, s, c, o);
+			PROCESS_BMBT_UNLOCK_RETURN(1);
 		}
=20
=20
@@ -793,15 +804,6 @@
 				continue;
 			}
=20
-			/* FIX FOR BUG 653709 -- EKN
-			 * realtime attribute fork, should be valid block number
-			 * in regular data space, not realtime partion.
-			 */
-			if (type =3D=3D XR_INO_RTDATA && whichfork =3D=3D XFS_ATTR_FORK) {
-			  if (mp->m_sb.sb_agcount < agno)
-				PROCESS_BMBT_UNLOCK_RETURN(1);
-			}
-
 			/* Process in chunks of 16 (XR_BB_UNIT/XR_BB)
 			 * for common XR_E_UNKNOWN to XR_E_INUSE transition
 			 */

------=_NextPart_000_025A_01C77DD7.1FB6E8F0--
