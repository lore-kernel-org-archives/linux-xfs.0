Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 22:38:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAF6bvk7000500
	for <xfs@oss.sgi.com>; Wed, 14 Nov 2007 22:38:01 -0800
Date: Thu, 15 Nov 2007 17:40:41 +1100
Subject: [REVIEW] Refactor xfs_repair's process_dinode_int
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------LgAlWvtlkAZ8Uw20CyzBdz
MIME-Version: 1.0
Message-ID: <op.t1tl53ac3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------LgAlWvtlkAZ8Uw20CyzBdz
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

Implementing casefold-table checking in xfs_repair, I have to
touch process_dinode_int. It's a horrendous function. The attached
patch hopefully makes it much clearer what it does and removes a
lot of duplicate code when bad inodes are found. There are some
obscure bug fixes too (eg. two places where the inode's di_mode is
updated, but not marked dirty - libxfs would have tossed it).

The refactoring involved removing unused variables, working out
what various variables actually did and use them appropriately
and break blocks of functionality into separate functions.

Barry.

------------LgAlWvtlkAZ8Uw20CyzBdz
Content-Disposition: attachment; filename=dinode.patch
Content-Type: text/x-patch; name=dinode.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/dino_chunks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/dino_chunks.c	2007-11-15 17:24:33.000000000 +1100
+++ b/xfsprogs/repair/dino_chunks.c	2007-11-14 15:41:03.188152397 +1100
@@ -593,7 +593,6 @@ process_inode_chunk(
 	xfs_agino_t		agino;
 	xfs_agblock_t		agbno;
 	int			dirty =3D 0;
-	int			cleared =3D 0;
 	int			isa_dir =3D 0;
 	int			blks_per_cluster;
 	int			cluster_count;
@@ -777,8 +776,7 @@ process_inode_chunk(
=20
 		status =3D process_dinode(mp, dino, agno, agino,
 				is_inode_free(ino_rec, irec_offset),
-				&ino_dirty, &cleared, &is_used,
-				ino_discovery, check_dups,
+				&ino_dirty, &is_used,ino_discovery, check_dups,
 				extra_attr_check, &isa_dir, &parent);
=20
 		ASSERT(is_used !=3D 3);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/dinode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/dinode.c	2007-11-15 17:24:33.000000000 +1100
+++ b/xfsprogs/repair/dinode.c	2007-11-15 17:23:49.322691248 +1100
@@ -58,9 +58,6 @@ calc_attr_offset(xfs_mount_t *mp, xfs_di
 	case XFS_DINODE_FMT_LOCAL:
 		offset +=3D INT_GET(dinoc->di_size, ARCH_CONVERT);
 		break;
-	case XFS_DINODE_FMT_UUID:
-		offset +=3D sizeof(uuid_t);
-		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		offset +=3D INT_GET(dinoc->di_nextents, ARCH_CONVERT) * sizeof(xfs_bmbt_=
rec_32_t);
 		break;
@@ -1563,8 +1560,11 @@ null_check(char *name, int length)
  * bogus
  */
 int
-process_symlink(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino,
-		blkmap_t *blkmap)
+process_symlink(
+	xfs_mount_t	*mp,
+	xfs_ino_t	lino,
+	xfs_dinode_t	*dino,
+	blkmap_t 	*blkmap)
 {
 	xfs_dfsbno_t		fsbno;
 	xfs_dinode_core_t	*dinoc =3D &dino->di_core;
@@ -1673,8 +1673,7 @@ process_symlink(xfs_mount_t *mp, xfs_ino
  * called to process the set of misc inode special inode types
  * that have no associated data storage (fifos, pipes, devices, etc.).
  */
-/* ARGSUSED */
-int
+static int
 process_misc_ino_types(xfs_mount_t	*mp,
 			xfs_dinode_t	*dino,
 			xfs_ino_t	lino,
@@ -1693,27 +1692,27 @@ process_misc_ino_types(xfs_mount_t	*mp,
 	/*
 	 * must also have a zero size
 	 */
-	if (INT_GET(dino->di_core.di_size, ARCH_CONVERT) !=3D 0)  {
+	if (dino->di_core.di_size !=3D 0)  {
 		switch (type)  {
 		case XR_INO_CHRDEV:
 			do_warn(_("size of character device inode %llu !=3D 0 "
 				  "(%lld bytes)\n"), lino,
-				INT_GET(dino->di_core.di_size, ARCH_CONVERT));
+				be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(_("size of block device inode %llu !=3D 0 "
 				  "(%lld bytes)\n"), lino,
-				INT_GET(dino->di_core.di_size, ARCH_CONVERT));
+				be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_SOCK:
 			do_warn(_("size of socket inode %llu !=3D 0 "
 				  "(%lld bytes)\n"), lino,
-				INT_GET(dino->di_core.di_size, ARCH_CONVERT));
+				be64_to_cpu(dino->di_core.di_size));
 			break;
 		case XR_INO_FIFO:
 			do_warn(_("size of fifo inode %llu !=3D 0 "
 				  "(%lld bytes)\n"), lino,
-				INT_GET(dino->di_core.di_size, ARCH_CONVERT));
+				be64_to_cpu(dino->di_core.di_size));
 			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
@@ -1769,712 +1768,393 @@ process_misc_ino_types_blocks(xfs_drfsbn
 	return (0);
 }
=20
-/*
- * returns 0 if the inode is ok, 1 if the inode is corrupt
- * check_dups can be set to 1 *only* when called by the
- * first pass of the duplicate block checking of phase 4.
- * *dirty is set > 0 if the dinode has been altered and
- * needs to be written out.
- *
- * for detailed, info, look at process_dinode() comments.
- */
-/* ARGSUSED */
-int
-process_dinode_int(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
-		xfs_agnumber_t agno,
-		xfs_agino_t ino,
-		int was_free,		/* 1 if inode is currently free */
-		int *dirty,		/* out =3D=3D > 0 if inode is now dirty */
-		int *cleared,		/* out =3D=3D 1 if inode was cleared */
-		int *used,		/* out =3D=3D 1 if inode is in use */
-		int verify_mode,	/* 1 =3D=3D verify but don't modify inode */
-		int uncertain,		/* 1 =3D=3D inode is uncertain */
-		int ino_discovery,	/* 1 =3D=3D check dirs for unknown inodes */
-		int check_dups,		/* 1 =3D=3D check if inode claims
-					 * duplicate blocks		*/
-		int extra_attr_check, /* 1 =3D=3D do attribute format and value checks */
-		int *isa_dir,		/* out =3D=3D 1 if inode is a directory */
-		xfs_ino_t *parent)	/* out -- parent if ino is a dir */
+static inline int
+dinode_fmt(
+	xfs_dinode_core_t *dinoc)
 {
-	xfs_drfsbno_t		totblocks =3D 0;
-	xfs_drfsbno_t		atotblocks =3D 0;
-	xfs_dinode_core_t	*dinoc;
-	char			*rstring;
-	int			type;
-	int			rtype;
-	int			do_rt;
-	int			err;
-	int			retval =3D 0;
-	__uint64_t		nextents;
-	__uint64_t		anextents;
-	xfs_ino_t		lino;
-	const int		is_free =3D 0;
-	const int		is_used =3D 1;
-	int			repair =3D 0;
-	blkmap_t		*ablkmap =3D NULL;
-	blkmap_t		*dblkmap =3D NULL;
-	static char		okfmts[] =3D {
-		0,				/* free inode */
-		1 << XFS_DINODE_FMT_DEV,	/* FIFO */
-		1 << XFS_DINODE_FMT_DEV,	/* CHR */
-		0,				/* type 3 unused */
-		(1 << XFS_DINODE_FMT_LOCAL) |
-		(1 << XFS_DINODE_FMT_EXTENTS) |
-		(1 << XFS_DINODE_FMT_BTREE),	/* DIR */
-		0,				/* type 5 unused */
-		1 << XFS_DINODE_FMT_DEV,	/* BLK */
-		0,				/* type 7 unused */
-		(1 << XFS_DINODE_FMT_EXTENTS) |
-		(1 << XFS_DINODE_FMT_BTREE),	/* REG */
-		0,				/* type 9 unused */
-		(1 << XFS_DINODE_FMT_LOCAL) |
-		(1 << XFS_DINODE_FMT_EXTENTS),	/* LNK */
-		0,				/* type 11 unused */
-		1 << XFS_DINODE_FMT_DEV,	/* SOCK */
-		0,				/* type 13 unused */
-		1 << XFS_DINODE_FMT_UUID,	/* MNT */
-		0				/* type 15 unused */
-	};
-
-	retval =3D 0;
-	totblocks =3D atotblocks =3D 0;
-	*dirty =3D *isa_dir =3D *cleared =3D 0;
-	*used =3D is_used;
-	type =3D rtype =3D XR_INO_UNKNOWN;
-	rstring =3D NULL;
-	do_rt =3D 0;
+	return be16_to_cpu(dinoc->di_mode) & S_IFMT;
+}
=20
-	dinoc =3D &dino->di_core;
-	lino =3D XFS_AGINO_TO_INO(mp, agno, ino);
+static inline void
+change_dinode_fmt(
+	xfs_dinode_core_t *dinoc,
+	int		new_fmt)
+{
+	int		mode =3D be16_to_cpu(dinoc->di_mode);
=20
-	/*
-	 * if in verify mode, don't modify the inode.
-	 *
-	 * if correcting, reset stuff that has known values
-	 *
-	 * if in uncertain mode, be silent on errors since we're
-	 * trying to find out if these are inodes as opposed
-	 * to assuming that they are.  Just return the appropriate
-	 * return code in that case.
-	 */
+	mode &=3D ~S_IFMT;
+	mode |=3D new_fmt;
+	dinoc->di_mode =3D cpu_to_be16(mode);
+}
=20
-	if (INT_GET(dinoc->di_magic, ARCH_CONVERT) !=3D XFS_DINODE_MAGIC)  {
-		retval++;
-		if (!verify_mode)  {
-			do_warn(_("bad magic number 0x%x on inode %llu, "),
-				INT_GET(dinoc->di_magic, ARCH_CONVERT), lino);
+static int
+check_dinode_mode_format(
+	xfs_dinode_core_t *dinoc)
+{
+	if ((uchar_t)dinoc->di_format >=3D XFS_DINODE_FMT_UUID)
+		return -1;	/* FMT_UUID is not used */
+
+	switch (dinode_fmt(dinoc)) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		return (dinoc->di_format !=3D XFS_DINODE_FMT_DEV) ? -1 : 0;
+
+	case S_IFDIR:
+		return (dinoc->di_format < XFS_DINODE_FMT_LOCAL ||
+			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
+
+	case S_IFREG:
+		return (dinoc->di_format < XFS_DINODE_FMT_EXTENTS ||
+			dinoc->di_format > XFS_DINODE_FMT_BTREE) ? -1 : 0;
+
+	case S_IFLNK:
+		return (dinoc->di_format < XFS_DINODE_FMT_LOCAL ||
+			dinoc->di_format > XFS_DINODE_FMT_EXTENTS) ? -1 : 0;
+
+	default: ;
+	}
+	return 0;	/* invalid modes are checked elsewhere */
+}
+
+/*
+ * If inode is a superblock inode, does type check to make sure is it vali=
d.
+ * Returns 0 if it's valid, non-zero if it needs to be cleared.
+ */
+
+static int
+process_check_sb_inodes(
+	xfs_mount_t	*mp,
+	xfs_dinode_core_t *dinoc,
+	xfs_ino_t	lino,
+	int		*type,
+	int		*dirty)
+{
+	if (lino =3D=3D mp->m_sb.sb_rootino) {
+	 	if (*type !=3D XR_INO_DIR)  {
+			do_warn(_("root inode %llu has bad type 0x%x\n"),
+				lino, dinode_fmt(dinoc));
+			*type =3D XR_INO_DIR;
 			if (!no_modify)  {
-				do_warn(_("resetting magic number\n"));
+				do_warn(_("resetting to directory\n"));
+				change_dinode_fmt(dinoc, S_IFDIR);
 				*dirty =3D 1;
-				INT_SET(dinoc->di_magic, ARCH_CONVERT,
-					XFS_DINODE_MAGIC);
-			} else  {
-				do_warn(_("would reset magic number\n"));
-			}
-		} else if (!uncertain) {
-			do_warn(_("bad magic number 0x%x on inode %llu\n"),
-				INT_GET(dinoc->di_magic, ARCH_CONVERT), lino);
+			} else
+				do_warn(_("would reset to directory\n"));
 		}
+		return 0;
 	}
-
-	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
-	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
-		retval++;
-		if (!verify_mode)  {
-			do_warn(_("bad version number 0x%x on inode %llu, "),
-				dinoc->di_version, lino);
+	if (lino =3D=3D mp->m_sb.sb_uquotino)  {
+		if (*type !=3D XR_INO_DATA)  {
+			do_warn(_("user quota inode %llu has bad type 0x%x\n"),
+				lino, dinode_fmt(dinoc));
+			mp->m_sb.sb_uquotino =3D NULLFSINO;
+			return 1;
+		}
+		return 0;
+	}
+	if (lino =3D=3D mp->m_sb.sb_gquotino)  {
+		if (*type !=3D XR_INO_DATA)  {
+			do_warn(_("group quota inode %llu has bad type 0x%x\n"),
+				lino, dinode_fmt(dinoc));
+			mp->m_sb.sb_gquotino =3D NULLFSINO;
+			return 1;
+		}
+		return 0;
+	}
+	if (lino =3D=3D mp->m_sb.sb_rsumino) {
+		if (*type !=3D XR_INO_RTSUM) {
+			do_warn(_("realtime summary inode %llu has bad type 0x%x, "),
+				lino, dinode_fmt(dinoc));
 			if (!no_modify)  {
-				do_warn(_("resetting version number\n"));
+				do_warn(_("resetting to regular file\n"));
+				change_dinode_fmt(dinoc, S_IFREG);
 				*dirty =3D 1;
-				dinoc->di_version =3D (fs_inode_nlink) ?
-					XFS_DINODE_VERSION_2 :
-					XFS_DINODE_VERSION_1;
 			} else  {
-				do_warn(_("would reset version number\n"));
+				do_warn(_("would reset to regular file\n"));
 			}
-		} else  if (!uncertain) {
-			do_warn(_("bad version number 0x%x on inode %llu\n"),
-				dinoc->di_version, lino);
 		}
+		if (mp->m_sb.sb_rblocks =3D=3D 0 && dinoc->di_nextents !=3D 0)  {
+			do_warn(_("bad # of extents (%u) for realtime summary inode %llu\n"),
+				be32_to_cpu(dinoc->di_nextents), lino);
+			return 1;
+		}
+		return 0;
 	}
-
-	/*
-	 * blow out of here if the inode size is < 0
-	 */
-	if (INT_GET(dinoc->di_size, ARCH_CONVERT) < 0)  {
-		retval++;
-		if (!verify_mode)  {
-			do_warn(_("bad (negative) size %lld on inode %llu\n"),
-				INT_GET(dinoc->di_size, ARCH_CONVERT), lino);
+	if (lino =3D=3D mp->m_sb.sb_rbmino) {
+		if (*type !=3D XR_INO_RTBITMAP) {
+			do_warn(_("realtime bitmap inode %llu has bad type 0x%x, "),
+				lino, dinode_fmt(dinoc));
 			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				*cleared =3D 1;
-			} else  {
+				do_warn(_("resetting to regular file\n"));
+				change_dinode_fmt(dinoc, S_IFREG);
 				*dirty =3D 1;
-				*cleared =3D 1;
+			} else  {
+				do_warn(_("would reset to regular file\n"));
 			}
-			*used =3D is_free;
-		} else if (!uncertain)  {
-			do_warn(_("bad (negative) size %lld on inode %llu\n"),
-				INT_GET(dinoc->di_size, ARCH_CONVERT), lino);
 		}
-
-		return(1);
+		if (mp->m_sb.sb_rblocks =3D=3D 0 && dinoc->di_nextents !=3D 0)  {
+			do_warn(_("bad # of extents (%u) for realtime bitmap inode %llu\n"),
+				be32_to_cpu(dinoc->di_nextents), lino);
+			return 1;
+		}
+		return 0;
 	}
+	return 0;
+}
=20
-	/*
-	 * was_free value is not meaningful if we're in verify mode
-	 */
-	if (!verify_mode && INT_GET(dinoc->di_mode, ARCH_CONVERT) =3D=3D 0 && was=
_free =3D=3D 1)  {
-		/*
-		 * easy case, inode free -- inode and map agree, clear
-		 * it just in case to ensure that format, etc. are
-		 * set correctly
-		 */
-		if (!no_modify)  {
-			err =3D  clear_dinode(mp, dino, lino);
-			if (err)  {
-				*dirty =3D 1;
-				*cleared =3D 1;
-			}
+/*
+ * general size/consistency checks:
+ *
+ * if the size <=3D size of the data fork, directories  must be
+ * local inodes unlike regular files which would be extent inodes.
+ * all the other mentioned types have to have a zero size value.
+ *
+ * if the size and format don't match, get out now rather than
+ * risk trying to process a non-existent extents or btree
+ * type data fork.
+ */
+static int
+process_check_inode_sizes(
+	xfs_mount_t	*mp,
+	xfs_dinode_t	*dino,
+	xfs_ino_t	lino,
+	int		type)
+{
+	xfs_dinode_core_t *dinoc =3D &dino->di_core;
+	xfs_fsize_t	size =3D be64_to_cpu(dinoc->di_size);
+
+	switch (type)  {
+
+	case XR_INO_DIR:
+		if (size <=3D XFS_DFORK_DSIZE(dino, mp) &&
+				dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL) {
+			do_warn(_("mismatch between format (%d) and size "
+				"(%lld) in directory ino %llu\n"),
+				dinoc->di_format, size, lino);
+			return 1;
 		}
-		*used =3D is_free;
-		return(0);
-	} else if (!verify_mode && INT_GET(dinoc->di_mode, ARCH_CONVERT) =3D=3D 0=
 && was_free =3D=3D 0)  {
+		break;
+
+	case XR_INO_SYMLINK:
+		if (process_symlink_extlist(mp, lino, dino))  {
+			do_warn(_("bad data fork in symlink %llu\n"), lino);
+			return 1;
+		}
+		break;
+
+	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
+	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
+	case XR_INO_SOCK:	/* fall through to FIFO case ... */
+	case XR_INO_MOUNTPOINT:	/* fall through to FIFO case ... */
+	case XR_INO_FIFO:
+		if (process_misc_ino_types(mp, dino, lino, type))
+			return 1;
+		break;
+
+	case XR_INO_RTDATA:
 		/*
-		 * the inode looks free but the map says it's in use.
-		 * clear the inode just to be safe and mark the inode
-		 * free.
+		 * if we have no realtime blocks, any inode claiming
+		 * to be a real-time file is bogus
 		 */
-		do_warn(_("imap claims a free inode %llu is in use, "), lino);
-
-		if (!no_modify)  {
-			do_warn(_("correcting imap and clearing inode\n"));
+		if (mp->m_sb.sb_rblocks =3D=3D 0)  {
+			do_warn(_("found inode %llu claiming to be a "
+				"real-time file\n"), lino);
+			return 1;
+		}
+		break;
=20
-			err =3D  clear_dinode(mp, dino, lino);
-			if (err)  {
-				retval++;
-				*dirty =3D 1;
-				*cleared =3D 1;
-			}
-		} else  {
-			do_warn(_("would correct imap and clear inode\n"));
+	case XR_INO_RTBITMAP:
+		if (size !=3D (__int64_t)mp->m_sb.sb_rbmblocks *
+					mp->m_sb.sb_blocksize) {
+			do_warn(_("realtime bitmap inode %llu has bad size "
+				"%lld (should be %lld)\n"),
+				lino, size, (__int64_t) mp->m_sb.sb_rbmblocks *
+					mp->m_sb.sb_blocksize);
+			return 1;
+		}
+		break;
=20
-			*dirty =3D 1;
-			*cleared =3D 1;
+	case XR_INO_RTSUM:
+		if (size !=3D mp->m_rsumsize)  {
+			do_warn(_("realtime summary inode %llu has bad size "
+				"%lld (should be %d)\n"),
+				lino, size, mp->m_rsumsize);
+			return 1;
 		}
+		break;
=20
-		*used =3D is_free;
+	default:
+		break;
+	}
+	return 0;
+}
=20
-		return(retval > 0 ? 1 : 0);
+/*
+ * check for illegal values of forkoff
+ */
+static int
+process_check_inode_forkoff(
+	xfs_mount_t	*mp,
+	xfs_dinode_core_t *dinoc,
+	xfs_ino_t	lino)
+{
+	if (dinoc->di_forkoff =3D=3D 0)
+		return 0;
+
+	switch (dinoc->di_format)  {
+	case XFS_DINODE_FMT_DEV:
+		if (dinoc->di_forkoff !=3D (roundup(sizeof(xfs_dev_t), 8) >> 3)) {
+			do_warn(_("bad attr fork offset %d in dev inode %llu, "
+				"should be %d\n"), dinoc->di_forkoff, lino,
+				(int)(roundup(sizeof(xfs_dev_t), 8) >> 3));
+			return 1;
+		}
+		break;
+	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
+	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
+	case XFS_DINODE_FMT_BTREE:
+		if (dinoc->di_forkoff >=3D (XFS_LITINO(mp) >> 3)) {
+			do_warn(_("bad attr fork offset %d in inode %llu, "
+				"max=3D%d\n"), dinoc->di_forkoff, lino,
+				XFS_LITINO(mp) >> 3);
+			return 1;
+		}
+		break;
+	default:
+		do_error(_("unexpected inode format %d\n"), dinoc->di_format);
+		break;
 	}
+	return 0;
+}
=20
-	/*
-	 * because of the lack of any write ordering guarantee, it's
-	 * possible that the core got updated but the forks didn't.
-	 * so rather than be ambitious (and probably incorrect),
-	 * if there's an inconsistency, we get conservative and
-	 * just pitch the file.  blow off checking formats of
-	 * free inodes since technically any format is legal
-	 * as we reset the inode when we re-use it.
-	 */
-	if (INT_GET(dinoc->di_mode, ARCH_CONVERT) !=3D 0 &&
-		((((INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT) >> 12) > 15) ||
-		(uchar_t) dinoc->di_format > XFS_DINODE_FMT_UUID ||
-			(!(okfmts[(INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT) >> 12] &
-			  (1 << dinoc->di_format))))) {
-		/* bad inode format */
-		retval++;
-		if (!uncertain)
-			do_warn(_("bad inode format in inode %llu\n"), lino);
-		if (!verify_mode)  {
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
+/*
+ * Updates the inodes block and extent counts if they are wrong
+ */
+static int
+process_inode_blocks_and_extents(
+	xfs_dinode_core_t *dinoc,
+	xfs_drfsbno_t	nblocks,
+	__uint64_t	nextents,
+	__uint64_t	anextents,
+	xfs_ino_t	lino,
+	int		*dirty)
+{
+	if (nblocks !=3D be64_to_cpu(dinoc->di_nblocks))  {
+		if (!no_modify)  {
+			do_warn(_("correcting nblocks for inode %llu, "
+				"was %llu - counted %llu\n"), lino,
+				be64_to_cpu(dinoc->di_nblocks), nblocks);
+			dinoc->di_nblocks =3D cpu_to_be64(nblocks);
+			*dirty =3D 1;
+		} else  {
+			do_warn(_("bad nblocks %llu for inode %llu, "
+				"would reset to %llu\n"),
+				be64_to_cpu(dinoc->di_nblocks), lino, nblocks);
 		}
-		*cleared =3D 1;
-		*used =3D is_free;
+	}
=20
-		return(retval > 0 ? 1 : 0);
+	if (nextents > MAXEXTNUM)  {
+		do_warn(_("too many data fork extents (%llu) in inode %llu\n"),
+			nextents, lino);
+		return 1;
+	}
+	if (nextents !=3D be32_to_cpu(dinoc->di_nextents))  {
+		if (!no_modify)  {
+			do_warn(_("correcting nextents for inode %llu, "
+				"was %d - counted %llu\n"), lino,
+				be32_to_cpu(dinoc->di_nextents), nextents);
+			dinoc->di_nextents =3D cpu_to_be32(nextents);
+			*dirty =3D 1;
+		} else  {
+			do_warn(_("bad nextents %d for inode %llu, would reset "
+				"to %llu\n"), be32_to_cpu(dinoc->di_nextents),
+				lino, nextents);
+		}
 	}
=20
-	if (verify_mode)
-		return(retval > 0 ? 1 : 0);
+	if (anextents > MAXAEXTNUM)  {
+		do_warn(_("too many attr fork extents (%llu) in inode %llu\n"),
+			anextents, lino);
+		return 1;
+	}
+	if (anextents !=3D be16_to_cpu(dinoc->di_anextents))  {
+		if (!no_modify)  {
+			do_warn(_("correcting anextents for inode %llu, "
+				"was %d - counted %llu\n"), lino,
+				be16_to_cpu(dinoc->di_anextents), anextents);
+			dinoc->di_anextents =3D cpu_to_be16(anextents);
+			*dirty =3D 1;
+		} else  {
+			do_warn(_("bad anextents %d for inode %llu, would reset"
+				" to %llu\n"), be16_to_cpu(dinoc->di_anextents),
+				lino, anextents);
+		}
+	}
+	return 0;
+}
=20
-	/*
-	 * clear the next unlinked field if necessary on a good
-	 * inode only during phase 4 -- when checking for inodes
-	 * referencing duplicate blocks.  then it's safe because
-	 * we've done the inode discovery and have found all the inodes
-	 * we're going to find.  check_dups is set to 1 only during
-	 * phase 4.  Ugly.
-	 */
-	if (check_dups && !no_modify)
-		*dirty +=3D clear_dinode_unlinked(mp, dino);
+/*
+ * check data fork -- if it's bad, clear the inode
+ */
+static int
+process_inode_data_fork(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino,
+	xfs_dinode_t	*dino,
+	int		type,
+	int		*dirty,
+	xfs_drfsbno_t	*totblocks,
+	__uint64_t	*nextents,
+	blkmap_t	**dblkmap,
+	int		check_dups)
+{
+	xfs_dinode_core_t *dinoc =3D &dino->di_core;
+	xfs_ino_t	lino =3D XFS_AGINO_TO_INO(mp, agno, ino);
+	int		err =3D 0;
=20
-	/* set type and map type info */
+	*nextents =3D be32_to_cpu(dinoc->di_nextents);
+	if (*nextents > be64_to_cpu(dinoc->di_nblocks) ||
+			*nextents > XFS_MAX_INCORE_EXTENTS)
+		*nextents =3D 1;
+
+	if (dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL && type !=3D XR_INO_RTDATA)
+		*dblkmap =3D blkmap_alloc(*nextents);
+	*nextents =3D 0;
=20
-	switch (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT) {
-	case S_IFDIR:
-		type =3D XR_INO_DIR;
-		*isa_dir =3D 1;
-		break;
-	case S_IFREG:
-		if (INT_GET(dinoc->di_flags, ARCH_CONVERT) & XFS_DIFLAG_REALTIME)
-			type =3D XR_INO_RTDATA;
-		else if (lino =3D=3D mp->m_sb.sb_rbmino)
-			type =3D XR_INO_RTBITMAP;
-		else if (lino =3D=3D mp->m_sb.sb_rsumino)
-			type =3D XR_INO_RTSUM;
-		else
-			type =3D XR_INO_DATA;
-		break;
-	case S_IFLNK:
-		type =3D XR_INO_SYMLINK;
-		break;
-	case S_IFCHR:
-		type =3D XR_INO_CHRDEV;
-		break;
-	case S_IFBLK:
-		type =3D XR_INO_BLKDEV;
-		break;
-	case S_IFSOCK:
-		type =3D XR_INO_SOCK;
-		break;
-	case S_IFIFO:
-		type =3D XR_INO_FIFO;
-		break;
-	default:
-		retval++;
-		if (!verify_mode)  {
-			do_warn(_("bad inode type %#o inode %llu\n"),
-				(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
-			if (!no_modify)
-				*dirty +=3D clear_dinode(mp, dino, lino);
-			else
-				*dirty =3D 1;
-			*cleared =3D 1;
-			*used =3D is_free;
-		} else if (!uncertain)  {
-			do_warn(_("bad inode type %#o inode %llu\n"),
-				(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
-		}
-		return 1;
-	}
-
-	/*
-	 * type checks for root, realtime inodes, and quota inodes
-	 */
-	if (lino =3D=3D mp->m_sb.sb_rootino && type !=3D XR_INO_DIR)  {
-		do_warn(_("bad inode type for root inode %llu, "), lino);
-		type =3D XR_INO_DIR;
-
-		if (!no_modify)  {
-			do_warn(_("resetting to directory\n"));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  &=3D ~(INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  |=3D INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFDIR);
-		} else  {
-			do_warn(_("would reset to directory\n"));
-		}
-	} else if (lino =3D=3D mp->m_sb.sb_rsumino)  {
-		do_rt =3D 1;
-		rstring =3D _("summary");
-		rtype =3D XR_INO_RTSUM;
-	} else if (lino =3D=3D mp->m_sb.sb_rbmino)  {
-		do_rt =3D 1;
-		rstring =3D _("bitmap");
-		rtype =3D XR_INO_RTBITMAP;
-	} else if (lino =3D=3D mp->m_sb.sb_uquotino)  {
-		if (type !=3D XR_INO_DATA)  {
-			do_warn(_("user quota inode has bad type 0x%x\n"),
-				INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			mp->m_sb.sb_uquotino =3D NULLFSINO;
-
-			return(1);
-		}
-	} else if (lino =3D=3D mp->m_sb.sb_gquotino)  {
-		if (type !=3D XR_INO_DATA)  {
-			do_warn(_("group quota inode has bad type 0x%x\n"),
-				INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			mp->m_sb.sb_gquotino =3D NULLFSINO;
-
-			return(1);
-		}
-	}
-
-	if (do_rt && type !=3D rtype)  {
-		type =3D XR_INO_DATA;
-
-		do_warn(_("bad inode type for realtime %s inode %llu, "),
-			rstring, lino);
-
-		if (!no_modify)  {
-			do_warn(_("resetting to regular file\n"));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  &=3D ~(INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  |=3D INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFREG);
-		} else  {
-			do_warn(_("would reset to regular file\n"));
-		}
-	}
-
-	/*
-	 * only regular files with REALTIME or EXTSIZE flags set can have
-	 * extsize set, or directories with EXTSZINHERIT.
-	 */
-	if (INT_GET(dinoc->di_extsize, ARCH_CONVERT) !=3D 0)  {
-		if ((type =3D=3D XR_INO_RTDATA) ||
-		    (type =3D=3D XR_INO_DIR &&
-				(INT_GET(dinoc->di_flags, ARCH_CONVERT) &
-				 XFS_DIFLAG_EXTSZINHERIT)) ||
-		    (type =3D=3D XR_INO_DATA &&
-				(INT_GET(dinoc->di_flags, ARCH_CONVERT) &
-				 XFS_DIFLAG_EXTSIZE)))  {
-			/* s'okay */ ;
-		} else {
-			do_warn(
-	_("bad non-zero extent size %u for non-realtime/extsize inode %llu, "),
-				INT_GET(dinoc->di_extsize, ARCH_CONVERT), lino);
-
-			if (!no_modify)  {
-				do_warn(_("resetting to zero\n"));
-				dinoc->di_extsize =3D 0;
-				*dirty =3D 1;
-			} else  {
-				do_warn(_("would reset to zero\n"));
-			}
-		}
-	}
-
-	/*
-	 * for realtime inodes, check sizes to see that
-	 * they are consistent with the # of realtime blocks.
-	 * also, verify that they contain only one extent and
-	 * are extent format files.  If anything's wrong, clear
-	 * the inode -- we'll recreate it in phase 6.
-	 */
-	if (do_rt &&
-	    ((lino =3D=3D mp->m_sb.sb_rbmino &&
-	      INT_GET(dinoc->di_size, ARCH_CONVERT)
-			  !=3D mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize) ||
-	     (lino =3D=3D mp->m_sb.sb_rsumino &&
-	      INT_GET(dinoc->di_size, ARCH_CONVERT) !=3D mp->m_rsumsize))) {
-
-		do_warn(_("bad size %llu for realtime %s inode %llu\n"),
-			INT_GET(dinoc->di_size, ARCH_CONVERT), rstring, lino);
-
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-
-		return(1);
-	}
-
-	if (do_rt && mp->m_sb.sb_rblocks =3D=3D 0 && INT_GET(dinoc->di_nextents, =
ARCH_CONVERT) !=3D 0)  {
-		do_warn(_("bad # of extents (%u) for realtime %s inode %llu\n"),
-			INT_GET(dinoc->di_nextents, ARCH_CONVERT), rstring, lino);
-
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-
-		return(1);
-	}
-
-	/*
-	 * Setup nextents and anextents for blkmap_alloc calls.
-	 */
-	nextents =3D INT_GET(dinoc->di_nextents, ARCH_CONVERT);
-	if (nextents > INT_GET(dinoc->di_nblocks, ARCH_CONVERT) || nextents > XFS=
_MAX_INCORE_EXTENTS)
-		nextents =3D 1;
-	anextents =3D INT_GET(dinoc->di_anextents, ARCH_CONVERT);
-	if (anextents > INT_GET(dinoc->di_nblocks, ARCH_CONVERT) || anextents > X=
FS_MAX_INCORE_EXTENTS)
-		anextents =3D 1;
-
-	/*
-	 * general size/consistency checks:
-	 *
-	 * if the size <=3D size of the data fork, directories  must be
-	 * local inodes unlike regular files which would be extent inodes.
-	 * all the other mentioned types have to have a zero size value.
-	 *
-	 * if the size and format don't match, get out now rather than
-	 * risk trying to process a non-existent extents or btree
-	 * type data fork.
-	 */
-	switch (type)  {
-	case XR_INO_DIR:
-		if (INT_GET(dinoc->di_size, ARCH_CONVERT) <=3D
-			XFS_DFORK_DSIZE(dino, mp) &&
-		    (dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL))  {
-			do_warn(
-_("mismatch between format (%d) and size (%lld) in directory ino %llu\n"),
-				dinoc->di_format,
-				INT_GET(dinoc->di_size, ARCH_CONVERT),
-				lino);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp,
-						dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		if (dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL)
-			dblkmap =3D blkmap_alloc(nextents);
-		break;
-	case XR_INO_SYMLINK:
-		if (process_symlink_extlist(mp, lino, dino))  {
-			do_warn(_("bad data fork in symlink %llu\n"), lino);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp,
-						dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		if (dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL)
-			dblkmap =3D blkmap_alloc(nextents);
-		break;
-	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
-	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
-	case XR_INO_SOCK:	/* fall through to FIFO case ... */
-	case XR_INO_MOUNTPOINT:	/* fall through to FIFO case ... */
-	case XR_INO_FIFO:
-		if (process_misc_ino_types(mp, dino, lino, type))  {
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		break;
-	case XR_INO_RTDATA:
-		/*
-		 * if we have no realtime blocks, any inode claiming
-		 * to be a real-time file is bogus
-		 */
-		if (mp->m_sb.sb_rblocks =3D=3D 0)  {
-			do_warn(
-			_("found inode %llu claiming to be a real-time file\n"),
-				lino);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		break;
-	case XR_INO_RTBITMAP:
-		if (INT_GET(dinoc->di_size, ARCH_CONVERT) !=3D
-		    (__int64_t)mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize)  {
-			do_warn(
-	_("realtime bitmap inode %llu has bad size %lld (should be %lld)\n"),
-				lino, INT_GET(dinoc->di_size, ARCH_CONVERT),
-				(__int64_t) mp->m_sb.sb_rbmblocks *
-				mp->m_sb.sb_blocksize);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		dblkmap =3D blkmap_alloc(nextents);
-		break;
-	case XR_INO_RTSUM:
-		if (INT_GET(dinoc->di_size, ARCH_CONVERT) !=3D mp->m_rsumsize)  {
-			do_warn(
-	_("realtime summary inode %llu has bad size %lld (should be %d)\n"),
-				lino, INT_GET(dinoc->di_size, ARCH_CONVERT),
-				mp->m_rsumsize);
-
-			if (!no_modify)  {
-				*dirty +=3D clear_dinode(mp, dino, lino);
-				ASSERT(*dirty > 0);
-			}
-
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-
-			return(1);
-		}
-		dblkmap =3D blkmap_alloc(nextents);
-		break;
-	default:
-		break;
-	}
-
-	/*
-	 * check for illegal values of forkoff
-	 */
-	err =3D 0;
-	if (dinoc->di_forkoff !=3D 0)  {
-		switch (dinoc->di_format)  {
-		case XFS_DINODE_FMT_DEV:
-			if (dinoc->di_forkoff !=3D
-					(roundup(sizeof(xfs_dev_t), 8) >> 3))  {
-				do_warn(
-		_("bad attr fork offset %d in dev inode %llu, should be %d\n"),
-					(int) dinoc->di_forkoff,
-					lino,
-					(int) (roundup(sizeof(xfs_dev_t), 8) >> 3));
-				err =3D 1;
-			}
-			break;
-		case XFS_DINODE_FMT_UUID:
-			if (dinoc->di_forkoff !=3D
-					(roundup(sizeof(uuid_t), 8) >> 3))  {
-				do_warn(
-		_("bad attr fork offset %d in uuid inode %llu, should be %d\n"),
-					(int) dinoc->di_forkoff,
-					lino,
-					(int)(roundup(sizeof(uuid_t), 8) >> 3));
-				err =3D 1;
-			}
-			break;
-		case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
-		case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
-		case XFS_DINODE_FMT_BTREE: {
-			if (dinoc->di_forkoff >=3D (XFS_LITINO(mp) >> 3))  {
-				do_warn(
-		_("bad attr fork offset %d in inode %llu, max=3D%d\n"),
-					(int) dinoc->di_forkoff,
-					lino, XFS_LITINO(mp) >> 3);
-				err =3D 1;
-			}
-			break;
-		    }
-		default:
-			do_error(_("unexpected inode format %d\n"),
-				(int) dinoc->di_format);
-			break;
-		}
-	}
-
-	if (err)  {
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
-		return(1);
-	}
-
-	/*
-	 * check data fork -- if it's bad, clear the inode
-	 */
-	nextents =3D 0;
 	switch (dinoc->di_format) {
 	case XFS_DINODE_FMT_LOCAL:
-		err =3D process_lclinode(mp, agno, ino, dino, type,
-			dirty, &totblocks, &nextents, &dblkmap,
-			XFS_DATA_FORK, check_dups);
+		err =3D process_lclinode(mp, agno, ino, dino, type, dirty,
+			totblocks, nextents, dblkmap, XFS_DATA_FORK,
+			check_dups);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		err =3D process_exinode(mp, agno, ino, dino, type,
-			dirty, &totblocks, &nextents, &dblkmap,
-			XFS_DATA_FORK, check_dups);
+		err =3D process_exinode(mp, agno, ino, dino, type, dirty,
+			totblocks, nextents, dblkmap, XFS_DATA_FORK,
+			check_dups);
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		err =3D process_btinode(mp, agno, ino, dino, type,
-			dirty, &totblocks, &nextents, &dblkmap,
-			XFS_DATA_FORK, check_dups);
+		err =3D process_btinode(mp, agno, ino, dino, type, dirty,
+			totblocks, nextents, dblkmap, XFS_DATA_FORK,
+			check_dups);
 		break;
 	case XFS_DINODE_FMT_DEV:	/* fall through */
-	case XFS_DINODE_FMT_UUID:
 		err =3D 0;
 		break;
 	default:
 		do_error(_("unknown format %d, ino %llu (mode =3D %d)\n"),
-			dinoc->di_format, lino,
-			INT_GET(dinoc->di_mode, ARCH_CONVERT));
+			dinoc->di_format, lino, be16_to_cpu(dinoc->di_mode));
 	}
=20
 	if (err)  {
-		/*
-		 * problem in the data fork, clear out the inode
-		 * and get out
-		 */
 		do_warn(_("bad data fork in inode %llu\n"), lino);
-
 		if (!no_modify)  {
 			*dirty +=3D clear_dinode(mp, dino, lino);
 			ASSERT(*dirty > 0);
 		}
-
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
-		return(1);
+		return 1;
 	}
=20
 	if (check_dups)  {
@@ -2486,465 +2166,633 @@ _("mismatch between format (%d) and size
 		switch (dinoc->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			err =3D process_lclinode(mp, agno, ino, dino, type,
-				dirty, &totblocks, &nextents, &dblkmap,
+				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
 			err =3D process_exinode(mp, agno, ino, dino, type,
-				dirty, &totblocks, &nextents, &dblkmap,
+				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_BTREE:
 			err =3D process_btinode(mp, agno, ino, dino, type,
-				dirty, &totblocks, &nextents, &dblkmap,
+				dirty, totblocks, nextents, dblkmap,
 				XFS_DATA_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_DEV:	/* fall through */
-		case XFS_DINODE_FMT_UUID:
 			err =3D 0;
 			break;
 		default:
 			do_error(_("unknown format %d, ino %llu (mode =3D %d)\n"),
 				dinoc->di_format, lino,
-				INT_GET(dinoc->di_mode, ARCH_CONVERT));
+				be16_to_cpu(dinoc->di_mode));
 		}
=20
-		if (no_modify && err !=3D 0)  {
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-			blkmap_free(dblkmap);
-			return(1);
-		}
+		if (no_modify && err !=3D 0)
+			return 1;
=20
 		ASSERT(err =3D=3D 0);
 	}
+	return 0;
+}
=20
-	/*
-	 * check attribute fork if necessary.  attributes are
-	 * always stored in the regular filesystem.
-	 */
+/*
+ * Process extended attribute fork in inode
+ */
+static int
+process_inode_attr_fork(
+	xfs_mount_t	*mp,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino,
+	xfs_dinode_t	*dino,
+	int		type,
+	int		*dirty,
+	xfs_drfsbno_t	*atotblocks,
+	__uint64_t	*anextents,
+	int		check_dups,
+	int		extra_attr_check,
+	int		*retval)
+{
+	xfs_dinode_core_t *dinoc =3D &dino->di_core;
+	xfs_ino_t	lino =3D XFS_AGINO_TO_INO(mp, agno, ino);
+	blkmap_t	*ablkmap =3D NULL;
+	int		repair =3D 0;
+	int		err;
+
+	if (!XFS_DFORK_Q(dino)) {
+		*anextents =3D 0;
+		if (dinoc->di_aformat !=3D XFS_DINODE_FMT_EXTENTS) {
+			do_warn(_("bad attribute format %d in inode %llu, "),
+				dinoc->di_aformat, lino);
+			if (!no_modify) {
+				do_warn(_("resetting value\n"));
+				dinoc->di_aformat =3D XFS_DINODE_FMT_EXTENTS;
+				*dirty =3D 1;
+			} else
+				do_warn(_("would reset value\n"));
+		}
+		return 0;
+	}
=20
-	if (!XFS_DFORK_Q(dino) &&
-	    dinoc->di_aformat !=3D XFS_DINODE_FMT_EXTENTS) {
-		do_warn(_("bad attribute format %d in inode %llu, "),
-			dinoc->di_aformat, lino);
-		if (!no_modify) {
-			do_warn(_("resetting value\n"));
-			dinoc->di_aformat =3D XFS_DINODE_FMT_EXTENTS;
-			*dirty =3D 1;
-		} else
-			do_warn(_("would reset value\n"));
-		anextents =3D 0;
-	} else if (XFS_DFORK_Q(dino)) {
+	*anextents =3D be32_to_cpu(dinoc->di_anextents);
+	if (*anextents > be64_to_cpu(dinoc->di_nblocks) ||
+			*anextents > XFS_MAX_INCORE_EXTENTS)
+		*anextents =3D 1;
+
+	switch (dinoc->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		*anextents =3D 0;
+		err =3D process_lclinode(mp, agno, ino, dino, type, dirty,
+				atotblocks, anextents, &ablkmap,
+				XFS_ATTR_FORK, check_dups);
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		ablkmap =3D blkmap_alloc(*anextents);
+		*anextents =3D 0;
+		err =3D process_exinode(mp, agno, ino, dino, type, dirty,
+				atotblocks, anextents, &ablkmap,
+				XFS_ATTR_FORK, check_dups);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		ablkmap =3D blkmap_alloc(*anextents);
+		*anextents =3D 0;
+		err =3D process_btinode(mp, agno, ino, dino, type, dirty,
+				atotblocks, anextents, &ablkmap,
+				XFS_ATTR_FORK, check_dups);
+		break;
+	default:
+		do_warn(_("illegal attribute format %d, ino %llu\n"),
+				dinoc->di_aformat, lino);
+		err =3D 1;
+		break;
+	}
+
+	if (err) {
+		/*
+		 * clear the attribute fork if necessary.  we can't
+		 * clear the inode because we've already put the
+		 * inode space info into the blockmap.
+		 *
+		 * XXX - put the inode onto the "move it" list and
+		 *	log the the attribute scrubbing
+		 */
+		do_warn(_("bad attribute fork in inode %llu"), lino);
+
+		if (!no_modify)  {
+			if (delete_attr_ok)  {
+				do_warn(_(", clearing attr fork\n"));
+				*dirty +=3D clear_dinode_attr(mp, dino, lino);
+				dinoc->di_aformat =3D XFS_DINODE_FMT_LOCAL;
+			} else  {
+				do_warn("\n");
+				*dirty +=3D clear_dinode(mp, dino, lino);
+			}
+			ASSERT(*dirty > 0);
+		} else  {
+			do_warn(_(", would clear attr fork\n"));
+		}
+
+		*atotblocks =3D 0;
+		*anextents =3D 0;
+		blkmap_free(ablkmap);
+		*retval =3D 1;
+
+		return delete_attr_ok ? 0 : 1;
+	}
+
+	if (check_dups)  {
 		switch (dinoc->di_aformat) {
 		case XFS_DINODE_FMT_LOCAL:
-			anextents =3D 0;
 			err =3D process_lclinode(mp, agno, ino, dino,
-				type, dirty, &atotblocks, &anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				type, dirty, atotblocks, anextents,
+				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_EXTENTS:
-			ablkmap =3D blkmap_alloc(anextents);
-			anextents =3D 0;
 			err =3D process_exinode(mp, agno, ino, dino,
-				type, dirty, &atotblocks, &anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				type, dirty, atotblocks, anextents,
+				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		case XFS_DINODE_FMT_BTREE:
-			ablkmap =3D blkmap_alloc(anextents);
-			anextents =3D 0;
 			err =3D process_btinode(mp, agno, ino, dino,
-				type, dirty, &atotblocks, &anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				type, dirty, atotblocks, anextents,
+				&ablkmap, XFS_ATTR_FORK, 0);
 			break;
 		default:
-			anextents =3D 0;
-			do_warn(_("illegal attribute format %d, ino %llu\n"),
-					dinoc->di_aformat, lino);
-			err =3D 1;
-			break;
+			do_error(_("illegal attribute fmt %d, ino %llu\n"),
+				dinoc->di_aformat, lino);
 		}
=20
-		if (err)  {
-			/*
-			 * clear the attribute fork if necessary.  we can't
-			 * clear the inode because we've already put the
-			 * inode space info into the blockmap.
-			 *
-			 * XXX - put the inode onto the "move it" list and
-			 *	log the the attribute scrubbing
-			 */
-			do_warn(_("bad attribute fork in inode %llu"), lino);
+		if (no_modify && err !=3D 0) {
+			blkmap_free(ablkmap);
+			return 1;
+		}
+
+		ASSERT(err =3D=3D 0);
+	}
+
+	/*
+	 * do attribute semantic-based consistency checks now
+	 */
=20
+	/* get this only in phase 3, not in both phase 3 and 4 */
+	if (extra_attr_check &&
+			process_attributes(mp, lino, dino, ablkmap, &repair)) {
+		do_warn(_("problem with attribute contents in inode %llu\n"),
+			lino);
+		if (!repair) {
+			/* clear attributes if not done already */
 			if (!no_modify)  {
-				if (delete_attr_ok)  {
-					do_warn(_(", clearing attr fork\n"));
-					*dirty +=3D clear_dinode_attr(mp,
-							dino, lino);
-				} else  {
-					do_warn("\n");
-					*dirty +=3D clear_dinode(mp,
-							dino, lino);
-				}
-				ASSERT(*dirty > 0);
+				*dirty +=3D clear_dinode_attr(mp, dino, lino);
+				dinoc->di_aformat =3D XFS_DINODE_FMT_LOCAL;
 			} else  {
-				do_warn(_(", would clear attr fork\n"));
+				do_warn(_("would clear attr fork\n"));
 			}
+			*atotblocks =3D 0;
+			*anextents =3D 0;
+		}
+		else {
+			*dirty =3D 1; /* it's been repaired */
+		}
+	}
+	blkmap_free(ablkmap);
+	return 0;
+}
=20
-			atotblocks =3D 0;
-			anextents =3D 0;
+/*
+ * check nlinks feature, if it's a version 1 inode,
+ * just leave nlinks alone.  even if it's set wrong,
+ * it'll be reset when read in.
+ */
=20
-			if (delete_attr_ok)  {
-				if (!no_modify)
-					dinoc->di_aformat =3D XFS_DINODE_FMT_LOCAL;
+static int
+process_check_inode_nlink_version(
+	xfs_dinode_core_t *dinoc,
+	xfs_ino_t	lino)
+{
+	int		dirty =3D 0;
+
+	if (dinoc->di_version > XFS_DINODE_VERSION_1 && !fs_inode_nlink)  {
+		/*
+		 * do we have a fs/inode version mismatch with a valid
+		 * version 2 inode here that has to stay version 2 or
+		 * lose links?
+		 */
+		if (be32_to_cpu(dinoc->di_nlink) > XFS_MAXLINK_1)  {
+			/*
+			 * yes.  are nlink inodes allowed?
+			 */
+			if (fs_inode_nlink_allowed)  {
+				/*
+				 * yes, update status variable which will
+				 * cause sb to be updated later.
+				 */
+				fs_inode_nlink =3D 1;
+				do_warn(_("version 2 inode %llu claims > %u links, "),
+					lino, XFS_MAXLINK_1);
+				if (!no_modify)  {
+					do_warn(_("updating superblock "
+						"version number\n"));
+				} else  {
+					do_warn(_("would update superblock "
+						"version number\n"));
+				}
 			} else  {
-				*cleared =3D 1;
-				*used =3D is_free;
-				*isa_dir =3D 0;
-				blkmap_free(dblkmap);
-				blkmap_free(ablkmap);
+				/*
+				 * no, have to convert back to onlinks
+				 * even if we lose some links
+				 */
+				do_warn(_("WARNING:  version 2 inode %llu "
+					"claims > %u links, "),
+					lino, XFS_MAXLINK_1);
+				if (!no_modify)  {
+					do_warn(_("converting back to version 1,\n"
+						"this may destroy %d links\n"),
+						be32_to_cpu(dinoc->di_nlink) -
+							XFS_MAXLINK_1);
+
+					dinoc->di_version =3D XFS_DINODE_VERSION_1;
+					dinoc->di_nlink =3D cpu_to_be32(XFS_MAXLINK_1);
+					dinoc->di_onlink =3D cpu_to_be16(XFS_MAXLINK_1);
+					dirty =3D 1;
+				} else  {
+					do_warn(_("would convert back to version 1,\n"
+						"\tthis might destroy %d links\n"),
+						be32_to_cpu(dinoc->di_nlink) -
+							XFS_MAXLINK_1);
+				}
 			}
-			return(1);
+		} else  {
+			/*
+			 * do we have a v2 inode that we could convert back
+			 * to v1 without losing any links?  if we do and
+			 * we have a mismatch between superblock bits and the
+			 * version bit, alter the version bit in this case.
+			 *
+			 * the case where we lost links was handled above.
+			 */
+			do_warn(_("found version 2 inode %llu, "), lino);
+			if (!no_modify)  {
+				do_warn(_("converting back to version 1\n"));
+				dinoc->di_version =3D XFS_DINODE_VERSION_1;
+				dinoc->di_onlink =3D cpu_to_be16(
+					be32_to_cpu(dinoc->di_nlink));
+				dirty =3D 1;
+			} else  {
+				do_warn(_("would convert back to version 1\n"));
+			}
+		}
+	}
=20
-		} else if (check_dups)  {
-			switch (dinoc->di_aformat) {
-			case XFS_DINODE_FMT_LOCAL:
-				err =3D process_lclinode(mp, agno, ino, dino,
-					type, dirty, &atotblocks, &anextents,
-					&ablkmap, XFS_ATTR_FORK, 0);
-				break;
-			case XFS_DINODE_FMT_EXTENTS:
-				err =3D process_exinode(mp, agno, ino, dino,
-					type, dirty, &atotblocks, &anextents,
-					&ablkmap, XFS_ATTR_FORK, 0);
-				break;
-			case XFS_DINODE_FMT_BTREE:
-				err =3D process_btinode(mp, agno, ino, dino,
-					type, dirty, &atotblocks, &anextents,
-					&ablkmap, XFS_ATTR_FORK, 0);
-				break;
-			default:
-				do_error(
-				_("illegal attribute fmt %d, ino %llu\n"),
-					dinoc->di_aformat, lino);
+	/*
+	 * ok, if it's still a version 2 inode, it's going
+	 * to stay a version 2 inode.  it should have a zero
+	 * onlink field, so clear it.
+	 */
+	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
+			dinoc->di_onlink !=3D 0 && fs_inode_nlink > 0) {
+		if (!no_modify) {
+			do_warn(_("clearing obsolete nlink field in "
+				"version 2 inode %llu, was %d, now 0\n"),
+				lino, be16_to_cpu(dinoc->di_onlink));
+			dinoc->di_onlink =3D 0;
+			dirty =3D 1;
+		} else  {
+			do_warn(_("would clear obsolete nlink field in "
+				"version 2 inode %llu, currently %d\n"),
+				lino, be16_to_cpu(dinoc->di_onlink));
+		}
+	}
+	return dirty;
+}
+
+/*
+ * returns 0 if the inode is ok, 1 if the inode is corrupt
+ * check_dups can be set to 1 *only* when called by the
+ * first pass of the duplicate block checking of phase 4.
+ * *dirty is set > 0 if the dinode has been altered and
+ * needs to be written out.
+ *
+ * for detailed, info, look at process_dinode() comments.
+ */
+/* ARGSUSED */
+int
+process_dinode_int(xfs_mount_t *mp,
+		xfs_dinode_t *dino,
+		xfs_agnumber_t agno,
+		xfs_agino_t ino,
+		int was_free,		/* 1 if inode is currently free */
+		int *dirty,		/* out =3D=3D > 0 if inode is now dirty */
+		int *used,		/* out =3D=3D 1 if inode is in use */
+		int verify_mode,	/* 1 =3D=3D verify but don't modify inode */
+		int uncertain,		/* 1 =3D=3D inode is uncertain */
+		int ino_discovery,	/* 1 =3D=3D check dirs for unknown inodes */
+		int check_dups,		/* 1 =3D=3D check if inode claims
+					 * duplicate blocks		*/
+		int extra_attr_check, /* 1 =3D=3D do attribute format and value checks */
+		int *isa_dir,		/* out =3D=3D 1 if inode is a directory */
+		xfs_ino_t *parent)	/* out -- parent if ino is a dir */
+{
+	xfs_drfsbno_t		totblocks =3D 0;
+	xfs_drfsbno_t		atotblocks =3D 0;
+	xfs_dinode_core_t	*dinoc;
+	int			di_mode;
+	int			type;
+	int			retval =3D 0;
+	__uint64_t		nextents;
+	__uint64_t		anextents;
+	xfs_ino_t		lino;
+	const int		is_free =3D 0;
+	const int		is_used =3D 1;
+	blkmap_t		*dblkmap =3D NULL;
+
+	*dirty =3D *isa_dir =3D 0;
+	*used =3D is_used;
+	type =3D XR_INO_UNKNOWN;
+
+	dinoc =3D &dino->di_core;
+	lino =3D XFS_AGINO_TO_INO(mp, agno, ino);
+	di_mode =3D be16_to_cpu(dinoc->di_mode);
+
+	/*
+	 * if in verify mode, don't modify the inode.
+	 *
+	 * if correcting, reset stuff that has known values
+	 *
+	 * if in uncertain mode, be silent on errors since we're
+	 * trying to find out if these are inodes as opposed
+	 * to assuming that they are.  Just return the appropriate
+	 * return code in that case.
+	 *
+	 * If uncertain is set, verify_mode MUST be set.
+	 */
+	ASSERT(uncertain =3D=3D 0 || verify_mode !=3D 0);
+
+	if (be16_to_cpu(dinoc->di_magic) !=3D XFS_DINODE_MAGIC)  {
+		retval =3D 1;
+		if (!uncertain)
+			do_warn(_("bad magic number 0x%x on inode %llu\n"),
+				be16_to_cpu(dinoc->di_magic), lino);
+		if (!verify_mode) {
+			if (!no_modify)  {
+				do_warn(_("resetting magic number\n"));
+				dinoc->di_magic =3D cpu_to_be16(XFS_DINODE_MAGIC);
+				*dirty =3D 1;
+			} else
+				do_warn(_("would reset magic number\n"));
+		}
+	}
+
+	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
+	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+		retval =3D 1;
+		if (!uncertain)
+			do_warn(_("bad version number 0x%x on inode %llu, "),
+				dinoc->di_version, lino);
+		if (!verify_mode) {
+			if (!no_modify) {
+				do_warn(_("resetting version number\n"));
+				dinoc->di_version =3D (fs_inode_nlink) ?
+					XFS_DINODE_VERSION_2 :
+					XFS_DINODE_VERSION_1;
+				*dirty =3D 1;
+			} else
+				do_warn(_("would reset version number\n"));
+		}
+	}
+
+	/*
+	 * blow out of here if the inode size is < 0
+	 */
+	if ((xfs_fsize_t)be64_to_cpu(dinoc->di_size) < 0)  {
+		if (!uncertain)
+			do_warn(_("bad (negative) size %lld on inode %llu\n"),
+				be64_to_cpu(dinoc->di_size), lino);
+		if (verify_mode)
+			return 1;
+		goto clear_bad_out;
+	}
+
+	/*
+	 * if not in verify mode, check to sii if the inode and imap
+	 * agree that the inode is free
+	 */
+	if (!verify_mode && di_mode =3D=3D 0) {
+		/*
+		 * was_free value is not meaningful if we're in verify mode
+		 */
+		if (was_free) {
+			/*
+			 * easy case, inode free -- inode and map agree, clear
+			 * it just in case to ensure that format, etc. are
+			 * set correctly
+			 */
+			if (!no_modify)
+				*dirty +=3D clear_dinode(mp, dino, lino);
+			*used =3D is_free;
+			return 0;
+		}
+		/*
+		 * the inode looks free but the map says it's in use.
+		 * clear the inode just to be safe and mark the inode
+		 * free.
+		 */
+		do_warn(_("imap claims a free inode %llu is in use, "), lino);
+		if (!no_modify)  {
+			do_warn(_("correcting imap and clearing inode\n"));
+			if (clear_dinode(mp, dino, lino))  {
+				retval =3D 1;
+				*dirty =3D 1;
 			}
+		} else
+			do_warn(_("would correct imap and clear inode\n"));
+		*used =3D is_free;
+		return retval;
+	}
=20
-			if (no_modify && err !=3D 0)  {
-				*cleared =3D 1;
-				*used =3D is_free;
-				*isa_dir =3D 0;
-				blkmap_free(dblkmap);
-				blkmap_free(ablkmap);
-				return(1);
-			}
+	/*
+	 * because of the lack of any write ordering guarantee, it's
+	 * possible that the core got updated but the forks didn't.
+	 * so rather than be ambitious (and probably incorrect),
+	 * if there's an inconsistency, we get conservative and
+	 * just pitch the file.  blow off checking formats of
+	 * free inodes since technically any format is legal
+	 * as we reset the inode when we re-use it.
+	 */
+	if (di_mode !=3D 0 && check_dinode_mode_format(dinoc) !=3D 0) {
+		if (!uncertain)
+			do_warn(_("bad inode format in inode %llu\n"), lino);
+		if (verify_mode)
+			return 1;
+		goto clear_bad_out;
+	}
=20
-			ASSERT(err =3D=3D 0);
-		}
+	if (verify_mode)
+		return retval;
=20
-		/*
-		 * do attribute semantic-based consistency checks now
-		 */
+	/*
+	 * clear the next unlinked field if necessary on a good
+	 * inode only during phase 4 -- when checking for inodes
+	 * referencing duplicate blocks.  then it's safe because
+	 * we've done the inode discovery and have found all the inodes
+	 * we're going to find.  check_dups is set to 1 only during
+	 * phase 4.  Ugly.
+	 */
+	if (check_dups && !no_modify)
+		*dirty +=3D clear_dinode_unlinked(mp, dino);
=20
-		/* get this only in phase 3, not in both phase 3 and 4 */
-		if (extra_attr_check) {
-		    if ((err =3D process_attributes(mp, lino, dino, ablkmap,
-				    &repair))) {
-			    do_warn(
-		_("problem with attribute contents in inode %llu\n"), lino);
-			    if(!repair) {
-				    /* clear attributes if not done already */
-				    if (!no_modify)  {
-					    *dirty +=3D clear_dinode_attr(
-							mp, dino, lino);
-					    dinoc->di_aformat =3D
-						XFS_DINODE_FMT_LOCAL;
-				    } else  {
-					    do_warn(
-					_("would clear attr fork\n"));
-				    }
-				    atotblocks =3D 0;
-				    anextents =3D 0;
-			    }
-			    else {
-				    *dirty =3D 1; /* it's been repaired */
-			     }
-		    }
-		}
-		blkmap_free(ablkmap);
+	/* set type and map type info */
=20
-	} else
-		anextents =3D 0;
+	switch (di_mode & S_IFMT) {
+	case S_IFDIR:
+		type =3D XR_INO_DIR;
+		*isa_dir =3D 1;
+		break;
+	case S_IFREG:
+		if (be16_to_cpu(dinoc->di_flags) & XFS_DIFLAG_REALTIME)
+			type =3D XR_INO_RTDATA;
+		else if (lino =3D=3D mp->m_sb.sb_rbmino)
+			type =3D XR_INO_RTBITMAP;
+		else if (lino =3D=3D mp->m_sb.sb_rsumino)
+			type =3D XR_INO_RTSUM;
+		else
+			type =3D XR_INO_DATA;
+		break;
+	case S_IFLNK:
+		type =3D XR_INO_SYMLINK;
+		break;
+	case S_IFCHR:
+		type =3D XR_INO_CHRDEV;
+		break;
+	case S_IFBLK:
+		type =3D XR_INO_BLKDEV;
+		break;
+	case S_IFSOCK:
+		type =3D XR_INO_SOCK;
+		break;
+	case S_IFIFO:
+		type =3D XR_INO_FIFO;
+		break;
+	default:
+		do_warn(_("bad inode type %#o inode %llu\n"),
+				di_mode & S_IFMT, lino);
+		goto clear_bad_out;
+	}
=20
 	/*
-	* enforce totblocks is 0 for misc types
-	*/
-	if (process_misc_ino_types_blocks(totblocks, lino, type)) {
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
-		return(1);
-	}
+	 * type checks for superblock inodes
+	 */
+	if (process_check_sb_inodes(mp, dinoc, lino, &type, dirty) !=3D 0)
+		goto clear_bad_out;
=20
 	/*
-	 * correct space counters if required
+	 * only regular files with REALTIME or EXTSIZE flags set can have
+	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (totblocks + atotblocks !=3D INT_GET(dinoc->di_nblocks, ARCH_CONVERT))=
  {
-		if (!no_modify)  {
-			do_warn(
-	_("correcting nblocks for inode %llu, was %llu - counted %llu\n"),
-				lino, INT_GET(dinoc->di_nblocks, ARCH_CONVERT),
-				totblocks + atotblocks);
-			*dirty =3D 1;
-			INT_SET(dinoc->di_nblocks, ARCH_CONVERT, totblocks + atotblocks);
-		} else  {
-			do_warn(
-	_("bad nblocks %llu for inode %llu, would reset to %llu\n"),
-				INT_GET(dinoc->di_nblocks, ARCH_CONVERT), lino,
-				totblocks + atotblocks);
+	if (dinoc->di_extsize !=3D 0) {
+		if ((type =3D=3D XR_INO_RTDATA) ||
+		    (type =3D=3D XR_INO_DIR && (be16_to_cpu(dinoc->di_flags) &
+					XFS_DIFLAG_EXTSZINHERIT)) ||
+		    (type =3D=3D XR_INO_DATA && (be16_to_cpu(dinoc->di_flags) &
+				 XFS_DIFLAG_EXTSIZE)))  {
+			/* s'okay */ ;
+		} else {
+			do_warn(_("bad non-zero extent size %u for "
+					"non-realtime/extsize inode %llu, "),
+					be32_to_cpu(dinoc->di_extsize), lino);
+			if (!no_modify)  {
+				do_warn(_("resetting to zero\n"));
+				dinoc->di_extsize =3D 0;
+				*dirty =3D 1;
+			} else
+				do_warn(_("would reset to zero\n"));
 		}
 	}
=20
-	if (nextents > MAXEXTNUM)  {
-		do_warn(_("too many data fork extents (%llu) in inode %llu\n"),
-			nextents, lino);
+	/*
+	 * general size/consistency checks:
+	 */
+	if (process_check_inode_sizes(mp, dino, lino, type) !=3D 0)
+		goto clear_bad_out;
=20
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
+	/*
+	 * check for illegal values of forkoff
+	 */
+	if (process_check_inode_forkoff(mp, dinoc, lino) !=3D 0)
+		goto clear_bad_out;
=20
-		return(1);
-	}
-	if (nextents !=3D INT_GET(dinoc->di_nextents, ARCH_CONVERT))  {
-		if (!no_modify)  {
-			do_warn(
-	_("correcting nextents for inode %llu, was %d - counted %llu\n"),
-				lino, INT_GET(dinoc->di_nextents, ARCH_CONVERT),
-				nextents);
-			*dirty =3D 1;
-			INT_SET(dinoc->di_nextents, ARCH_CONVERT,
-				(xfs_extnum_t) nextents);
-		} else  {
-			do_warn(
-		_("bad nextents %d for inode %llu, would reset to %llu\n"),
-				INT_GET(dinoc->di_nextents, ARCH_CONVERT),
-				lino, nextents);
-		}
-	}
+	/*
+	 * check data fork -- if it's bad, clear the inode
+	 */
+	if (process_inode_data_fork(mp, agno, ino, dino, type, dirty,
+			&totblocks, &nextents, &dblkmap, check_dups) !=3D 0)
+		goto bad_out;
=20
-	if (anextents > MAXAEXTNUM)  {
-		do_warn(_("too many attr fork extents (%llu) in inode %llu\n"),
-			anextents, lino);
+	/*
+	 * check attribute fork if necessary.  attributes are
+	 * always stored in the regular filesystem.
+	 */
+	if (process_inode_attr_fork(mp, agno, ino, dino, type, dirty,
+			&atotblocks, &anextents, check_dups, extra_attr_check,
+			&retval))
+		goto bad_out;
=20
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
-		return(1);
-	}
-	if (anextents !=3D INT_GET(dinoc->di_anextents, ARCH_CONVERT))  {
-		if (!no_modify)  {
-			do_warn(
-	_("correcting anextents for inode %llu, was %d - counted %llu\n"),
-				lino,
-				INT_GET(dinoc->di_anextents, ARCH_CONVERT),
-				anextents);
-			*dirty =3D 1;
-			INT_SET(dinoc->di_anextents, ARCH_CONVERT,
-				(xfs_aextnum_t) anextents);
-		} else  {
-			do_warn(
-		_("bad anextents %d for inode %llu, would reset to %llu\n"),
-				INT_GET(dinoc->di_anextents, ARCH_CONVERT),
-				lino, anextents);
-		}
-	}
+	/*
+	 * enforce totblocks is 0 for misc types
+	 */
+	if (process_misc_ino_types_blocks(totblocks, lino, type))
+		goto clear_bad_out;
+
+	/*
+	 * correct space counters if required
+	 */
+	if (process_inode_blocks_and_extents(dinoc, totblocks + atotblocks,
+			nextents, anextents, lino, dirty) !=3D 0)
+		goto clear_bad_out;
=20
 	/*
 	 * do any semantic type-based checking here
 	 */
 	switch (type)  {
 	case XR_INO_DIR:
-		if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-			err =3D process_dir2(mp, lino, dino, ino_discovery,
-					dirty, "", parent, dblkmap);
-		else
-			err =3D process_dir(mp, lino, dino, ino_discovery,
-					dirty, "", parent, dblkmap);
-		if (err)
-			do_warn(
-			_("problem with directory contents in inode %llu\n"),
-				lino);
-		break;
-	case XR_INO_RTBITMAP:
-		/* process_rtbitmap XXX */
-		err =3D 0;
-		break;
-	case XR_INO_RTSUM:
-		/* process_rtsummary XXX */
-		err =3D 0;
+		if (process_dir2(mp, lino, dino, ino_discovery, dirty, "",
+				parent, dblkmap) !=3D 0) {
+			do_warn(_("problem with directory contents in "
+				"inode %llu\n"), lino);
+			goto clear_bad_out;
+		}
 		break;
 	case XR_INO_SYMLINK:
-		if ((err =3D process_symlink(mp, lino, dino, dblkmap)))
+		if (process_symlink(mp, lino, dino, dblkmap) !=3D 0) {
 			do_warn(_("problem with symbolic link in inode %llu\n"),
 				lino);
-		break;
-	case XR_INO_DATA:	/* fall through to FIFO case ... */
-	case XR_INO_RTDATA:	/* fall through to FIFO case ... */
-	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
-	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
-	case XR_INO_SOCK:	/* fall through to FIFO case ... */
-	case XR_INO_FIFO:
-		err =3D 0;
+			goto clear_bad_out;
+		}
 		break;
 	default:
-		printf(_("Unexpected inode type\n"));
-		abort();
+		break;
 	}
=20
-	if (dblkmap)
-		blkmap_free(dblkmap);
-
-	if (err)  {
-		/*
-		 * problem in the inode type-specific semantic
-		 * checking, clear out the inode and get out
-		 */
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-
-		return(1);
-	}
+	blkmap_free(dblkmap);
=20
 	/*
 	 * check nlinks feature, if it's a version 1 inode,
 	 * just leave nlinks alone.  even if it's set wrong,
 	 * it'll be reset when read in.
 	 */
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 && !fs_inode_nlink)  {
-		/*
-		 * do we have a fs/inode version mismatch with a valid
-		 * version 2 inode here that has to stay version 2 or
-		 * lose links?
-		 */
-		if (INT_GET(dinoc->di_nlink, ARCH_CONVERT) > XFS_MAXLINK_1)  {
-			/*
-			 * yes.  are nlink inodes allowed?
-			 */
-			if (fs_inode_nlink_allowed)  {
-				/*
-				 * yes, update status variable which will
-				 * cause sb to be updated later.
-				 */
-				fs_inode_nlink =3D 1;
-				do_warn(
-				_("version 2 inode %llu claims > %u links, "),
-					lino, XFS_MAXLINK_1);
-				if (!no_modify)  {
-					do_warn(
-			_("updating superblock version number\n"));
-				} else  {
-					do_warn(
-			_("would update superblock version number\n"));
-				}
-			} else  {
-				/*
-				 * no, have to convert back to onlinks
-				 * even if we lose some links
-				 */
-				do_warn(
-			_("WARNING:  version 2 inode %llu claims > %u links, "),
-					lino, XFS_MAXLINK_1);
-				if (!no_modify)  {
-					do_warn(
-	_("converting back to version 1,\n\tthis may destroy %d links\n"),
-						INT_GET(dinoc->di_nlink,
-							ARCH_CONVERT)
-						- XFS_MAXLINK_1);
-
-					dinoc->di_version =3D
-						XFS_DINODE_VERSION_1;
-					INT_SET(dinoc->di_nlink, ARCH_CONVERT,
-						XFS_MAXLINK_1);
-					INT_SET(dinoc->di_onlink, ARCH_CONVERT,
-						XFS_MAXLINK_1);
-
-					*dirty =3D 1;
-				} else  {
-					do_warn(
-	_("would convert back to version 1,\n\tthis might destroy %d links\n"),
-						INT_GET(dinoc->di_nlink,
-							ARCH_CONVERT)
-						- XFS_MAXLINK_1);
-				}
-			}
-		} else  {
-			/*
-			 * do we have a v2 inode that we could convert back
-			 * to v1 without losing any links?  if we do and
-			 * we have a mismatch between superblock bits and the
-			 * version bit, alter the version bit in this case.
-			 *
-			 * the case where we lost links was handled above.
-			 */
-			do_warn(_("found version 2 inode %llu, "), lino);
-			if (!no_modify)  {
-				do_warn(_("converting back to version 1\n"));
-
-				dinoc->di_version =3D
-					XFS_DINODE_VERSION_1;
-				INT_SET(dinoc->di_onlink, ARCH_CONVERT,
-					INT_GET(dinoc->di_nlink, ARCH_CONVERT));
-
-				*dirty =3D 1;
-			} else  {
-				do_warn(_("would convert back to version 1\n"));
-			}
-		}
-	}
+	*dirty =3D process_check_inode_nlink_version(dinoc, lino);
=20
-	/*
-	 * ok, if it's still a version 2 inode, it's going
-	 * to stay a version 2 inode.  it should have a zero
-	 * onlink field, so clear it.
-	 */
-	if (dinoc->di_version > XFS_DINODE_VERSION_1 &&
-	    INT_GET(dinoc->di_onlink, ARCH_CONVERT) > 0 &&
-	    fs_inode_nlink > 0)  {
-		if (!no_modify)  {
-			do_warn(
-_("clearing obsolete nlink field in version 2 inode %llu, was %d, now 0\n"=
),
-				lino, INT_GET(dinoc->di_onlink, ARCH_CONVERT));
-			dinoc->di_onlink =3D 0;
-			*dirty =3D 1;
-		} else  {
-			do_warn(
-_("would clear obsolete nlink field in version 2 inode %llu, currently %d\=
n"),
-				lino, INT_GET(dinoc->di_onlink, ARCH_CONVERT));
-			*dirty =3D 1;
-		}
-	}
+	return retval;
=20
-	return(retval > 0 ? 1 : 0);
+clear_bad_out:
+	if (!no_modify)  {
+		*dirty +=3D clear_dinode(mp, dino, lino);
+		ASSERT(*dirty > 0);
+	}
+bad_out:
+	*used =3D is_free;
+	*isa_dir =3D 0;
+	blkmap_free(dblkmap);
+	return 1;
 }
=20
 /*
@@ -2983,8 +2831,6 @@ _("would clear obsolete nlink field in v
  *				claimed blocks using the bitmap.
  *	Outs:
  *		dirty -- whether we changed the inode (1 =3D=3D yes)
- *		cleared -- whether we cleared the inode (1 =3D=3D yes).  In
- *				no modify mode, if we would have cleared it
  *		used -- 1 if the inode is used, 0 if free.  In no modify
  *			mode, whether the inode should be used or free
  *		isa_dir -- 1 if the inode is a directory, 0 if not.  In
@@ -2994,30 +2840,29 @@ _("would clear obsolete nlink field in v
  */
=20
 int
-process_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
-		xfs_agnumber_t agno,
-		xfs_agino_t ino,
-		int was_free,
-		int *dirty,
-		int *cleared,
-		int *used,
-		int ino_discovery,
-		int check_dups,
-		int extra_attr_check,
-		int *isa_dir,
-		xfs_ino_t *parent)
+process_dinode(
+	xfs_mount_t	*mp,
+	xfs_dinode_t	*dino,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino,
+	int		was_free,
+	int		*dirty,
+	int		*used,
+	int		ino_discovery,
+	int		check_dups,
+	int		extra_attr_check,
+	int		*isa_dir,
+	xfs_ino_t	*parent)
 {
-	const int verify_mode =3D 0;
-	const int uncertain =3D 0;
+	const int	verify_mode =3D 0;
+	const int	uncertain =3D 0;
=20
 #ifdef XR_INODE_TRACE
 	fprintf(stderr, "processing inode %d/%d\n", agno, ino);
 #endif
-	return(process_dinode_int(mp, dino, agno, ino, was_free, dirty,
-				cleared, used, verify_mode, uncertain,
-				ino_discovery, check_dups, extra_attr_check,
-				isa_dir, parent));
+	return process_dinode_int(mp, dino, agno, ino, was_free, dirty, used,
+				verify_mode, uncertain, ino_discovery,
+				check_dups, extra_attr_check, isa_dir, parent);
 }
=20
 /*
@@ -3027,25 +2872,24 @@ process_dinode(xfs_mount_t *mp,
  * if the inode passes the cursory sanity check, 1 otherwise.
  */
 int
-verify_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
-		xfs_agnumber_t agno,
-		xfs_agino_t ino)
-{
-	xfs_ino_t parent;
-	int cleared =3D 0;
-	int used =3D 0;
-	int dirty =3D 0;
-	int isa_dir =3D 0;
-	const int verify_mode =3D 1;
-	const int check_dups =3D 0;
-	const int ino_discovery =3D 0;
-	const int uncertain =3D 0;
-
-	return(process_dinode_int(mp, dino, agno, ino, 0, &dirty,
-				&cleared, &used, verify_mode,
-				uncertain, ino_discovery, check_dups,
-				0, &isa_dir, &parent));
+verify_dinode(
+	xfs_mount_t	*mp,
+	xfs_dinode_t	*dino,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino)
+{
+	xfs_ino_t	parent;
+	int		used =3D 0;
+	int		dirty =3D 0;
+	int		isa_dir =3D 0;
+	const int	verify_mode =3D 1;
+	const int	check_dups =3D 0;
+	const int	ino_discovery =3D 0;
+	const int	uncertain =3D 0;
+
+	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
+				verify_mode, uncertain, ino_discovery,
+				check_dups, 0, &isa_dir, &parent);
 }
=20
 /*
@@ -3054,23 +2898,22 @@ verify_dinode(xfs_mount_t *mp,
  * returns 0 if the inode passes the cursory sanity check, 1 otherwise.
  */
 int
-verify_uncertain_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
-		xfs_agnumber_t agno,
-		xfs_agino_t ino)
-{
-	xfs_ino_t parent;
-	int cleared =3D 0;
-	int used =3D 0;
-	int dirty =3D 0;
-	int isa_dir =3D 0;
-	const int verify_mode =3D 1;
-	const int check_dups =3D 0;
-	const int ino_discovery =3D 0;
-	const int uncertain =3D 1;
-
-	return(process_dinode_int(mp, dino, agno, ino, 0, &dirty,
-				&cleared, &used, verify_mode,
-				uncertain, ino_discovery, check_dups,
-				0, &isa_dir, &parent));
+verify_uncertain_dinode(
+	xfs_mount_t	*mp,
+	xfs_dinode_t	*dino,
+	xfs_agnumber_t	agno,
+	xfs_agino_t	ino)
+{
+	xfs_ino_t	parent;
+	int		used =3D 0;
+	int		dirty =3D 0;
+	int		isa_dir =3D 0;
+	const int	verify_mode =3D 1;
+	const int	check_dups =3D 0;
+	const int	ino_discovery =3D 0;
+	const int	uncertain =3D 1;
+
+	return process_dinode_int(mp, dino, agno, ino, 0, &dirty, &used,
+				verify_mode, uncertain, ino_discovery,
+				check_dups, 0, &isa_dir, &parent);
 }

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/dinode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/dinode.h	2007-11-15 17:24:33.000000000 +1100
+++ b/xfsprogs/repair/dinode.h	2007-11-15 17:22:18.290409320 +1100
@@ -84,7 +84,6 @@ process_dinode(xfs_mount_t *mp,
 		xfs_agino_t ino,
 		int was_free,
 		int *dirty,
-		int *tossit,
 		int *used,
 		int check_dirs,
 		int check_dups,

------------LgAlWvtlkAZ8Uw20CyzBdz--
