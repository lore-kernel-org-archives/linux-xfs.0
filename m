Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Mar 2008 22:25:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2R5PD39015203
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 22:25:16 -0700
Date: Thu, 27 Mar 2008 16:28:19 +1100
Subject: Re: REVIEW: improve/fix/update zeroing garbage in superblock sectors in xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------EQ54Je2klZrw6sqzQDB6C1
MIME-Version: 1.0
References: <op.t8ntcvc23jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <op.t8nthhog3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t8ntcvc23jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------EQ54Je2klZrw6sqzQDB6C1
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

Hmm... a "cd" line appeared in the patch, delete it if trying to apply
the patch.

I've attached it to be sure :)

On Thu, 27 Mar 2008 16:25:33 +1100, Barry Naujok <bnaujok@sgi.com> wrote:

> Running XFS QA with a standard HDD with the bad_features2 problem
> happening and doing "mkfs.xfs -l version=3D1", a problem was encounter
> where it went to zero the "bad" features2 bit.
>
> Why didn't this happen all the time?
>
> Upon investigation, I updated the behaviour of the "secondary_sb_wack"
> function. Now it always zeroes any garbage found beyond the expected
> end of the xfs_sb_t structure in the first sector.
>
> Further down in discrete field checking, there were a lot of
> "  if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  { "
> checks which seems superfluous for the tests and operations
> being performed.
>
> The following patch relies on the bad_features2 patch from the
> other week.
>
> --
------------EQ54Je2klZrw6sqzQDB6C1
Content-Disposition: attachment; filename=update_sb_whack.patch
Content-Type: text/x-patch; name=update_sb_whack.patch
Content-Transfer-Encoding: Quoted-Printable

--- ci.orig/xfsprogs/repair/agheader.c
+++ ci/xfsprogs/repair/agheader.c
@@ -213,82 +213,66 @@ compare_sb(xfs_mount_t *mp, xfs_sb_t *sb
  *
  * And everything else in the buffer beyond either sb_width,
  * sb_dirblklog (v2 dirs), or sb_logsectsize can be zeroed.
- *
- * Note: contrary to the name, this routine is called for all
- * superblocks, not just the secondary superblocks.
  */
-int
-secondary_sb_wack(xfs_mount_t *mp, xfs_buf_t *sbuf, xfs_sb_t *sb,
-	xfs_agnumber_t i)
+static int
+sb_whack(
+	xfs_mount_t	*mp,
+	xfs_sb_t	*sb,		/* translated superblock */
+	xfs_buf_t	*sbuf,		/* disk buffer with superblock */
+	xfs_agnumber_t	agno)
 {
-	int do_bzero;
-	int size;
-	char *ip;
-	int rval;
-
-	rval =3D do_bzero =3D 0;
+	int		rval =3D 0;
+	int		do_zero =3D 0;
+	int		size;
+	char		*ip;
=20
 	/*
-	 * mkfs's that stamped a feature bit besides the ones in the mask
-	 * (e.g. were pre-6.5 beta) could leave garbage in the secondary
-	 * superblock sectors.  Anything stamping the shared fs bit or better
-	 * into the secondaries is ok and should generate clean secondary
-	 * superblock sectors.  so only run the bzero check on the
-	 * potentially garbaged secondaries.
+	 * Check for garbage beyond the last field.
+	 * Use field addresses instead so this code will still
+	 * work against older filesystems when the superblock
+	 * gets rev'ed again with new fields appended.
 	 */
-	if (pre_65_beta ||
-	    (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK) =3D=3D 0 ||
-	    sb->sb_versionnum < XFS_SB_VERSION_4)  {
-		/*
-		 * Check for garbage beyond the last field.
-		 * Use field addresses instead so this code will still
-		 * work against older filesystems when the superblock
-		 * gets rev'ed again with new fields appended.
-		 */
-		if (XFS_SB_VERSION_HASMOREBITS(sb))
-			size =3D (__psint_t)&sb->sb_features2
-				+ sizeof(sb->sb_features2) - (__psint_t)sb;
-		else if (XFS_SB_VERSION_HASLOGV2(sb))
-			size =3D (__psint_t)&sb->sb_logsunit
+	if (xfs_sb_version_hasmorebits(sb))
+		size =3D (__psint_t)&sb->sb_bad_features2
+				+ sizeof(sb->sb_bad_features2) - (__psint_t)sb;
+	else if (xfs_sb_version_haslogv2(sb))
+		size =3D (__psint_t)&sb->sb_logsunit
 				+ sizeof(sb->sb_logsunit) - (__psint_t)sb;
-		else if (XFS_SB_VERSION_HASSECTOR(sb))
-			size =3D (__psint_t)&sb->sb_logsectsize
+	else if (xfs_sb_version_hassector(sb))
+		size =3D (__psint_t)&sb->sb_logsectsize
 				+ sizeof(sb->sb_logsectsize) - (__psint_t)sb;
-		else if (XFS_SB_VERSION_HASDIRV2(sb))
-			size =3D (__psint_t)&sb->sb_dirblklog
+	else if (xfs_sb_version_hasdirv2(sb))
+		size =3D (__psint_t)&sb->sb_dirblklog
 				+ sizeof(sb->sb_dirblklog) - (__psint_t)sb;
-		else
-			size =3D (__psint_t)&sb->sb_width
+	else
+		size =3D (__psint_t)&sb->sb_width
 				+ sizeof(sb->sb_width) - (__psint_t)sb;
-		for (ip =3D (char *)((__psint_t)sb + size);
-		     ip < (char *)((__psint_t)sb + mp->m_sb.sb_sectsize);
-		     ip++)  {
-			if (*ip)  {
-				do_bzero =3D 1;
-				break;
-			}
-		}
=20
-		if (do_bzero)  {
-			rval |=3D XR_AG_SB_SEC;
-			if (!no_modify)  {
-				do_warn(
-		_("zeroing unused portion of %s superblock (AG #%u)\n"),
-					!i ? _("primary") : _("secondary"), i);
-				bzero((void *)((__psint_t)sb + size),
-					mp->m_sb.sb_sectsize - size);
-			} else
-				do_warn(
-		_("would zero unused portion of %s superblock (AG #%u)\n"),
-					!i ? _("primary") : _("secondary"), i);
+	for (ip =3D XFS_BUF_PTR(sbuf) + size;
+	     ip < XFS_BUF_PTR(sbuf) + mp->m_sb.sb_sectsize; ip++) {
+		if (*ip)  {
+			do_zero =3D 1;
+			break;
 		}
 	}
=20
+	if (do_zero)  {
+		rval |=3D XR_AG_SB_SEC;
+		if (!no_modify) {
+			do_warn(_("zeroing unused portion of %s superblock "
+				"(AG #%u)\n"), !agno ? _("primary") :
+				_("secondary"), agno);
+			memset(XFS_BUF_PTR(sbuf) + size, 0,
+				mp->m_sb.sb_sectsize - size);
+		} else
+			do_warn(_("would zero unused portion of %s superblock "
+				"(AG #%u)\n"), !agno ? _("primary") :
+				_("secondary"), agno);
+	}
+
 	/*
-	 * now look for the fields we can manipulate directly.
-	 * if we did a bzero and that bzero could have included
-	 * the field in question, just silently reset it.  otherwise,
-	 * complain.
+	 * now look for the fields we can manipulate directly that
+	 * may not have been zeroed above.
 	 *
 	 * for now, just zero the flags field since only
 	 * the readonly flag is used
@@ -296,11 +280,8 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
 	if (sb->sb_flags)  {
 		if (!no_modify)
 			sb->sb_flags =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(_("bad flags field in superblock %d\n"), i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("bad flags field in superblock %d\n"), agno);
 	}
=20
 	/*
@@ -312,38 +293,24 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
 	if (sb->sb_inprogress =3D=3D 1 && sb->sb_uquotino)  {
 		if (!no_modify)
 			sb->sb_uquotino =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(
-		_("non-null user quota inode field in superblock %d\n"),
-				i);
-
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("non-null user quota inode field in superblock %d\n"),
+			agno);
 	}
=20
 	if (sb->sb_inprogress =3D=3D 1 && sb->sb_gquotino)  {
 		if (!no_modify)
 			sb->sb_gquotino =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(
-		_("non-null group quota inode field in superblock %d\n"),
-				i);
-
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("non-null group quota inode field in superblock %d\n"),
+			agno);
 	}
=20
 	if (sb->sb_inprogress =3D=3D 1 && sb->sb_qflags)  {
 		if (!no_modify)
 			sb->sb_qflags =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(_("non-null quota flags in superblock %d\n"),
-				i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("non-null quota flags in superblock %d\n"), agno);
 	}
=20
 	/*
@@ -352,44 +319,31 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
 	 * written at mkfs time (and the corresponding sb version bits
 	 * are set).
 	 */
-	if (!XFS_SB_VERSION_HASSHARED(sb) && sb->sb_shared_vn !=3D 0)  {
+	if (!xfs_sb_version_hasshared(sb) && sb->sb_shared_vn)  {
 		if (!no_modify)
 			sb->sb_shared_vn =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(
-		_("bad shared version number in superblock %d\n"),
-				i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("bad shared version number in superblock %d\n"),
+			agno);
 	}
=20
-	if (!XFS_SB_VERSION_HASALIGN(sb) && sb->sb_inoalignmt !=3D 0)  {
+	if (!xfs_sb_version_hasalign(sb) && sb->sb_inoalignmt)  {
 		if (!no_modify)
 			sb->sb_inoalignmt =3D 0;
-		if (sb->sb_versionnum & XR_PART_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(
-		_("bad inode alignment field in superblock %d\n"),
-				i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("bad inode alignment field in superblock %d\n"),
+			agno);
 	}
=20
-	if (!XFS_SB_VERSION_HASDALIGN(sb) &&
-	    (sb->sb_unit !=3D 0 || sb->sb_width !=3D 0))  {
+	if (!xfs_sb_version_hasdalign(sb) && (sb->sb_unit || sb->sb_width)) {
 		if (!no_modify)
 			sb->sb_unit =3D sb->sb_width =3D 0;
-		if (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK || !do_bzero)  {
-			rval |=3D XR_AG_SB;
-			do_warn(
-		_("bad stripe unit/width fields in superblock %d\n"),
-				i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+		rval |=3D XR_AG_SB;
+		do_warn(_("bad stripe unit/width fields in superblock %d\n"),
+			agno);
 	}
=20
-	if (!XFS_SB_VERSION_HASSECTOR(sb) &&
+	if (!xfs_sb_version_hassector(sb) &&
 	    (sb->sb_sectsize !=3D BBSIZE || sb->sb_sectlog !=3D BBSHIFT ||
 	     sb->sb_logsectsize !=3D 0 || sb->sb_logsectlog !=3D 0))  {
 		if (!no_modify)  {
@@ -398,13 +352,11 @@ secondary_sb_wack(xfs_mount_t *mp, xfs_b
 			sb->sb_logsectsize =3D 0;
 			sb->sb_logsectlog =3D 0;
 		}
-		if (sb->sb_versionnum & XR_GOOD_SECSB_VNMASK || !do_bzero)  {
+		if (!do_zero)  {
 			rval |=3D XR_AG_SB;
-			do_warn(
-		_("bad log/data device sector size fields in superblock %d\n"),
-				i);
-		} else
-			rval |=3D XR_AG_SB_SEC;
+			do_warn(_("bad log/data device sector size fields in "
+				"superblock %d\n"), agno);
+		}
 	}
=20
 	return(rval);
@@ -463,7 +415,7 @@ verify_set_agheader(xfs_mount_t *mp, xfs
 		rval |=3D XR_AG_SB;
 	}
=20
-	rval |=3D secondary_sb_wack(mp, sbuf, sb, i);
+	rval |=3D sb_whack(mp, sb, sbuf, i);
=20
 	rval |=3D verify_set_agf(mp, agf, i);
 	rval |=3D verify_set_agi(mp, agi, i);

------------EQ54Je2klZrw6sqzQDB6C1--
