Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 20:42:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I4gM8E021086
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 20:42:24 -0800
Date: Fri, 18 Jan 2008 15:43:52 +1100
Subject: [REVIEW 2/2] Case insensitive support for XFS - user-space
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------blQY9A8HShDiztkzvReN2F
MIME-Version: 1.0
Message-ID: <op.t43zfeiz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>

------------blQY9A8HShDiztkzvReN2F
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

This patch relies on the dinode.c refactoring patch posted recently.
I have attached the latest version (with fixes pointed out by Chandan).


  db/Makefile             |    2
  db/cft.c                |  135 ++++++++
  db/cft.h                |   23 +
  db/check.c              |  236 ++++++++++++++
  db/command.c            |    2
  db/field.c              |    3
  db/field.h              |    1
  db/inode.c              |    2
  db/metadump.c           |    3
  db/sb.c                 |    5
  db/type.c               |    2
  db/type.h               |    2
  include/casefoldtable.h |   29 +
  include/libxfs.h        |   12
  include/xfs_attr_leaf.h |    8
  include/xfs_da_btree.h  |   34 ++
  include/xfs_dir2.h      |    7
  include/xfs_sb.h        |   33 +-
  include/xfs_unicode.h   |   69 ++++
  libxfs/Makefile         |    6
  libxfs/casefoldtable.c  |  760  
++++++++++++++++++++++++++++++++++++++++++++++++
  libxfs/init.c           |   10
  libxfs/utf8.c           |   85 +++++
  libxfs/xfs.h            |   20 +
  libxfs/xfs_attr.c       |   35 +-
  libxfs/xfs_attr_leaf.c  |   11
  libxfs/xfs_da_btree.c   |   86 +++++
  libxfs/xfs_dir2.c       |  220 ++++++++-----
  libxfs/xfs_dir2_block.c |    5
  libxfs/xfs_dir2_data.c  |    3
  libxfs/xfs_mount.c      |    2
  libxfs/xfs_unicode.c    |  405 +++++++++++++++++++++++++
  mdrestore/Makefile      |    2
  mkfs/proto.c            |   24 +
  mkfs/xfs_mkfs.c         |  101 +++---
  mkfs/xfs_mkfs.h         |   13
  repair/agheader.c       |   12
  repair/dino_chunks.c    |   15
  repair/dinode.c         |  112 +++++++
  repair/dir2.c           |    3
  repair/incore.h         |    1
  repair/phase2.c         |   19 +
  repair/phase6.c         |  257 ++++++++++------
  repair/xfs_repair.c     |   20 +
------------blQY9A8HShDiztkzvReN2F
Content-Disposition: attachment; filename=dinode.patch
Content-Type: text/x-patch; name=dinode.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
xfsprogs/repair/dino_chunks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

Index: ci/xfsprogs/repair/dino_chunks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dino_chunks.c	2007-11-16 14:45:56.000000000 =
+1100
+++ ci/xfsprogs/repair/dino_chunks.c	2008-01-18 14:50:42.000000000 +1100=

@@ -593,7 +593,6 @@
 	xfs_agino_t		agino;
 	xfs_agblock_t		agbno;
 	int			dirty =3D 0;
-	int			cleared =3D 0;
 	int			isa_dir =3D 0;
 	int			blks_per_cluster;
 	int			cluster_count;
@@ -777,8 +776,7 @@
 =

 		status =3D process_dinode(mp, dino, agno, agino,
 				is_inode_free(ino_rec, irec_offset),
-				&ino_dirty, &cleared, &is_used,
-				ino_discovery, check_dups,
+				&ino_dirty, &is_used,ino_discovery, check_dups,
 				extra_attr_check, &isa_dir, &parent);
 =

 		ASSERT(is_used !=3D 3);
Index: ci/xfsprogs/repair/dinode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dinode.c	2007-11-16 14:45:56.000000000 +1100=

+++ ci/xfsprogs/repair/dinode.c	2008-01-18 14:57:36.000000000 +1100
@@ -58,9 +58,6 @@
 	case XFS_DINODE_FMT_LOCAL:
 		offset +=3D INT_GET(dinoc->di_size, ARCH_CONVERT);
 		break;
-	case XFS_DINODE_FMT_UUID:
-		offset +=3D sizeof(uuid_t);
-		break;
 	case XFS_DINODE_FMT_EXTENTS:
 		offset +=3D INT_GET(dinoc->di_nextents, ARCH_CONVERT) * sizeof(xfs_bm=
bt_rec_32_t);
 		break;
@@ -1563,8 +1560,11 @@
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
@@ -1673,8 +1673,7 @@
  * called to process the set of misc inode special inode types
  * that have no associated data storage (fifos, pipes, devices, etc.).
  */
-/* ARGSUSED */
-int
+static int
 process_misc_ino_types(xfs_mount_t	*mp,
 			xfs_dinode_t	*dino,
 			xfs_ino_t	lino,
@@ -1693,27 +1692,27 @@
 	/*
 	 * must also have a zero size
 	 */
-	if (INT_GET(dino->di_core.di_size, ARCH_CONVERT) !=3D 0)  {
+	if (dino->di_core.di_size)  {
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
@@ -1769,712 +1768,395 @@
 	return (0);
 }
 =

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
-		int extra_attr_check, /* 1 =3D=3D do attribute format and value check=
s */
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
 =

-	dinoc =3D &dino->di_core;
-	lino =3D XFS_AGINO_TO_INO(mp, agno, ino);
+static inline void
+change_dinode_fmt(
+	xfs_dinode_core_t *dinoc,
+	int		new_fmt)
+{
+	int		mode =3D be16_to_cpu(dinoc->di_mode);
 =

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
+	ASSERT((new_fmt & ~S_IFMT) =3D=3D 0);
 =

-	if (INT_GET(dinoc->di_magic, ARCH_CONVERT) !=3D XFS_DINODE_MAGIC)  {
-		retval++;
-		if (!verify_mode)  {
-			do_warn(_("bad magic number 0x%x on inode %llu, "),
-				INT_GET(dinoc->di_magic, ARCH_CONVERT), lino);
+	mode &=3D ~S_IFMT;
+	mode |=3D new_fmt;
+	dinoc->di_mode =3D cpu_to_be16(mode);
+}
+
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
+ * If inode is a superblock inode, does type check to make sure is it v=
alid.
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
+			do_warn(_("bad # of extents (%u) for realtime summary inode %llu\n")=
,
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
-	}
-
-	/*
-	 * was_free value is not meaningful if we're in verify mode
-	 */
-	if (!verify_mode && INT_GET(dinoc->di_mode, ARCH_CONVERT) =3D=3D 0 && =
was_free =3D=3D 1)  {
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
+		if (mp->m_sb.sb_rblocks =3D=3D 0 && dinoc->di_nextents !=3D 0)  {
+			do_warn(_("bad # of extents (%u) for realtime bitmap inode %llu\n"),=

+				be32_to_cpu(dinoc->di_nextents), lino);
+			return 1;
 		}
-		*used =3D is_free;
-		return(0);
-	} else if (!verify_mode && INT_GET(dinoc->di_mode, ARCH_CONVERT) =3D=3D=
 0 && was_free =3D=3D 0)  {
-		/*
-		 * the inode looks free but the map says it's in use.
-		 * clear the inode just to be safe and mark the inode
-		 * free.
-		 */
-		do_warn(_("imap claims a free inode %llu is in use, "), lino);
+		return 0;
+	}
+	return 0;
+}
 =

-		if (!no_modify)  {
-			do_warn(_("correcting imap and clearing inode\n"));
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
 =

-			err =3D  clear_dinode(mp, dino, lino);
-			if (err)  {
-				retval++;
-				*dirty =3D 1;
-				*cleared =3D 1;
-			}
-		} else  {
-			do_warn(_("would correct imap and clear inode\n"));
+	switch (type)  {
 =

-			*dirty =3D 1;
-			*cleared =3D 1;
+	case XR_INO_DIR:
+		if (size <=3D XFS_DFORK_DSIZE(dino, mp) &&
+				dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL) {
+			do_warn(_("mismatch between format (%d) and size "
+				"(%lld) in directory ino %llu\n"),
+				dinoc->di_format, size, lino);
+			return 1;
 		}
+		break;
 =

-		*used =3D is_free;
-
-		return(retval > 0 ? 1 : 0);
-	}
-
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
+	case XR_INO_SYMLINK:
+		if (process_symlink_extlist(mp, lino, dino))  {
+			do_warn(_("bad data fork in symlink %llu\n"), lino);
+			return 1;
 		}
-		*cleared =3D 1;
-		*used =3D is_free;
-
-		return(retval > 0 ? 1 : 0);
-	}
-
-	if (verify_mode)
-		return(retval > 0 ? 1 : 0);
-
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
-
-	/* set type and map type info */
+		break;
 =

-	switch (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT) {
-	case S_IFDIR:
-		type =3D XR_INO_DIR;
-		*isa_dir =3D 1;
+	case XR_INO_CHRDEV:	/* fall through to FIFO case ... */
+	case XR_INO_BLKDEV:	/* fall through to FIFO case ... */
+	case XR_INO_SOCK:	/* fall through to FIFO case ... */
+	case XR_INO_MOUNTPOINT:	/* fall through to FIFO case ... */
+	case XR_INO_FIFO:
+		if (process_misc_ino_types(mp, dino, lino, type))
+			return 1;
 		break;
-	case S_IFREG:
-		if (INT_GET(dinoc->di_flags, ARCH_CONVERT) & XFS_DIFLAG_REALTIME)
-			type =3D XR_INO_RTDATA;
-		else if (lino =3D=3D mp->m_sb.sb_rbmino)
-			type =3D XR_INO_RTBITMAP;
-		else if (lino =3D=3D mp->m_sb.sb_rsumino)
-			type =3D XR_INO_RTSUM;
-		else
-			type =3D XR_INO_DATA;
+
+	case XR_INO_RTDATA:
+		/*
+		 * if we have no realtime blocks, any inode claiming
+		 * to be a real-time file is bogus
+		 */
+		if (mp->m_sb.sb_rblocks =3D=3D 0)  {
+			do_warn(_("found inode %llu claiming to be a "
+				"real-time file\n"), lino);
+			return 1;
+		}
 		break;
-	case S_IFLNK:
-		type =3D XR_INO_SYMLINK;
+
+	case XR_INO_RTBITMAP:
+		if (size !=3D (__int64_t)mp->m_sb.sb_rbmblocks *
+					mp->m_sb.sb_blocksize) {
+			do_warn(_("realtime bitmap inode %llu has bad size "
+				"%lld (should be %lld)\n"),
+				lino, size, (__int64_t) mp->m_sb.sb_rbmblocks *
+					mp->m_sb.sb_blocksize);
+			return 1;
+		}
 		break;
-	case S_IFCHR:
-		type =3D XR_INO_CHRDEV;
+
+	case XR_INO_RTSUM:
+		if (size !=3D mp->m_rsumsize)  {
+			do_warn(_("realtime summary inode %llu has bad size "
+				"%lld (should be %d)\n"),
+				lino, size, mp->m_rsumsize);
+			return 1;
+		}
 		break;
-	case S_IFBLK:
-		type =3D XR_INO_BLKDEV;
+
+	default:
 		break;
-	case S_IFSOCK:
-		type =3D XR_INO_SOCK;
+	}
+	return 0;
+}
+
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
 		break;
-	case S_IFIFO:
-		type =3D XR_INO_FIFO;
+	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
+	case XFS_DINODE_FMT_EXTENTS:	/* fall through ... */
+	case XFS_DINODE_FMT_BTREE:
+		if (dinoc->di_forkoff >=3D (XFS_LITINO(mp) >> 3)) {
+			do_warn(_("bad attr fork offset %d in inode %llu, "
+				"max=3D%d\n"), dinoc->di_forkoff, lino,
+				XFS_LITINO(mp) >> 3);
+			return 1;
+		}
 		break;
 	default:
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
+		do_error(_("unexpected inode format %d\n"), dinoc->di_format);
+		break;
 	}
+	return 0;
+}
 =

-	/*
-	 * type checks for root, realtime inodes, and quota inodes
-	 */
-	if (lino =3D=3D mp->m_sb.sb_rootino && type !=3D XR_INO_DIR)  {
-		do_warn(_("bad inode type for root inode %llu, "), lino);
-		type =3D XR_INO_DIR;
-
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
 		if (!no_modify)  {
-			do_warn(_("resetting to directory\n"));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  &=3D ~(INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  |=3D INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFDIR);
+			do_warn(_("correcting nblocks for inode %llu, "
+				"was %llu - counted %llu\n"), lino,
+				be64_to_cpu(dinoc->di_nblocks), nblocks);
+			dinoc->di_nblocks =3D cpu_to_be64(nblocks);
+			*dirty =3D 1;
 		} else  {
-			do_warn(_("would reset to directory\n"));
+			do_warn(_("bad nblocks %llu for inode %llu, "
+				"would reset to %llu\n"),
+				be64_to_cpu(dinoc->di_nblocks), lino, nblocks);
 		}
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
+	}
 =

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
+	if (nextents > MAXEXTNUM)  {
+		do_warn(_("too many data fork extents (%llu) in inode %llu\n"),
+			nextents, lino);
+		return 1;
 	}
-
-	if (do_rt && type !=3D rtype)  {
-		type =3D XR_INO_DATA;
-
-		do_warn(_("bad inode type for realtime %s inode %llu, "),
-			rstring, lino);
-
+	if (nextents !=3D be32_to_cpu(dinoc->di_nextents))  {
 		if (!no_modify)  {
-			do_warn(_("resetting to regular file\n"));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  &=3D ~(INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT));
-			INT_MOD_EXPR(dinoc->di_mode, ARCH_CONVERT,
-			  |=3D INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFREG);
+			do_warn(_("correcting nextents for inode %llu, "
+				"was %d - counted %llu\n"), lino,
+				be32_to_cpu(dinoc->di_nextents), nextents);
+			dinoc->di_nextents =3D cpu_to_be32(nextents);
+			*dirty =3D 1;
 		} else  {
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
-	_("bad non-zero extent size %u for non-realtime/extsize inode %llu, ")=
,
-				INT_GET(dinoc->di_extsize, ARCH_CONVERT), lino);
-
-			if (!no_modify)  {
-				do_warn(_("resetting to zero\n"));
-				dinoc->di_extsize =3D 0;
-				*dirty =3D 1;
-			} else  {
-				do_warn(_("would reset to zero\n"));
-			}
+			do_warn(_("bad nextents %d for inode %llu, would reset "
+				"to %llu\n"), be32_to_cpu(dinoc->di_nextents),
+				lino, nextents);
 		}
 	}
 =

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
+	if (anextents > MAXAEXTNUM)  {
+		do_warn(_("too many attr fork extents (%llu) in inode %llu\n"),
+			anextents, lino);
+		return 1;
 	}
-
-	if (do_rt && mp->m_sb.sb_rblocks =3D=3D 0 && INT_GET(dinoc->di_nextent=
s, ARCH_CONVERT) !=3D 0)  {
-		do_warn(_("bad # of extents (%u) for realtime %s inode %llu\n"),
-			INT_GET(dinoc->di_nextents, ARCH_CONVERT), rstring, lino);
-
+	if (anextents !=3D be16_to_cpu(dinoc->di_anextents))  {
 		if (!no_modify)  {
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
-	if (nextents > INT_GET(dinoc->di_nblocks, ARCH_CONVERT) || nextents > =
XFS_MAX_INCORE_EXTENTS)
-		nextents =3D 1;
-	anextents =3D INT_GET(dinoc->di_anextents, ARCH_CONVERT);
-	if (anextents > INT_GET(dinoc->di_nblocks, ARCH_CONVERT) || anextents =
> XFS_MAX_INCORE_EXTENTS)
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
-_("mismatch between format (%d) and size (%lld) in directory ino %llu\n=
"),
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
+			do_warn(_("correcting anextents for inode %llu, "
+				"was %d - counted %llu\n"), lino,
+				be16_to_cpu(dinoc->di_anextents), anextents);
+			dinoc->di_anextents =3D cpu_to_be16(anextents);
+			*dirty =3D 1;
+		} else  {
+			do_warn(_("bad anextents %d for inode %llu, would reset"
+				" to %llu\n"), be16_to_cpu(dinoc->di_anextents),
+				lino, anextents);
 		}
 	}
+	return 0;
+}
 =

-	if (err)  {
-		if (!no_modify)  {
-			*dirty +=3D clear_dinode(mp, dino, lino);
-			ASSERT(*dirty > 0);
-		}
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
 =

-		*cleared =3D 1;
-		*used =3D is_free;
-		*isa_dir =3D 0;
-		blkmap_free(dblkmap);
-		return(1);
-	}
+	*nextents =3D be32_to_cpu(dinoc->di_nextents);
+	if (*nextents > be64_to_cpu(dinoc->di_nblocks) ||
+			*nextents > XFS_MAX_INCORE_EXTENTS)
+		*nextents =3D 1;
+
+	if (dinoc->di_format !=3D XFS_DINODE_FMT_LOCAL && type !=3D XR_INO_RTD=
ATA)
+		*dblkmap =3D blkmap_alloc(*nextents);
+	*nextents =3D 0;
 =

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
 =

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
 =

 	if (check_dups)  {
@@ -2486,465 +2168,635 @@
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
 =

-		if (no_modify && err !=3D 0)  {
-			*cleared =3D 1;
-			*used =3D is_free;
-			*isa_dir =3D 0;
-			blkmap_free(dblkmap);
-			return(1);
-		}
+		if (no_modify && err !=3D 0)
+			return 1;
 =

 		ASSERT(err =3D=3D 0);
 	}
+	return 0;
+}
 =

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
 =

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
+	*anextents =3D be16_to_cpu(dinoc->di_anextents);
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
 =

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
 =

+		ASSERT(err =3D=3D 0);
+	}
+
+	/*
+	 * do attribute semantic-based consistency checks now
+	 */
+
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
 =

-			atotblocks =3D 0;
-			anextents =3D 0;
+/*
+ * check nlinks feature, if it's a version 1 inode,
+ * just leave nlinks alone.  even if it's set wrong,
+ * it'll be reset when read in.
+ */
 =

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
-
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
 			}
+		}
+	}
+
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
+		int extra_attr_check, /* 1 =3D=3D do attribute format and value check=
s */
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
+			do_warn(_("bad magic number 0x%x on inode %llu%c"),
+				be16_to_cpu(dinoc->di_magic), lino,
+				verify_mode ? '\n' : ',');
+		if (!verify_mode) {
+			if (!no_modify)  {
+				do_warn(_(" resetting magic number\n"));
+				dinoc->di_magic =3D cpu_to_be16(XFS_DINODE_MAGIC);
+				*dirty =3D 1;
+			} else
+				do_warn(_(" would reset magic number\n"));
+		}
+	}
+
+	if (!XFS_DINODE_GOOD_VERSION(dinoc->di_version) ||
+	    (!fs_inode_nlink && dinoc->di_version > XFS_DINODE_VERSION_1))  {
+		retval =3D 1;
+		if (!uncertain)
+			do_warn(_("bad version number 0x%x on inode %llu%c"),
+				dinoc->di_version, lino,
+				verify_mode ? '\n' : ',');
+		if (!verify_mode) {
+			if (!no_modify) {
+				do_warn(_(" resetting version number\n"));
+				dinoc->di_version =3D (fs_inode_nlink) ?
+					XFS_DINODE_VERSION_2 :
+					XFS_DINODE_VERSION_1;
+				*dirty =3D 1;
+			} else
+				do_warn(_(" would reset version number\n"));
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
+			*dirty +=3D clear_dinode(mp, dino, lino);
+			retval =3D 1;
+		} else
+			do_warn(_("would correct imap and clear inode\n"));
+		*used =3D is_free;
+		return retval;
+	}
 =

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
 =

-			ASSERT(err =3D=3D 0);
-		}
+	if (verify_mode)
+		return retval;
 =

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
 =

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
 =

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
 =

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
 =

 	/*
-	 * correct space counters if required
+	 * only regular files with REALTIME or EXTSIZE flags set can have
+	 * extsize set, or directories with EXTSZINHERIT.
 	 */
-	if (totblocks + atotblocks !=3D INT_GET(dinoc->di_nblocks, ARCH_CONVER=
T))  {
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
+	if (dinoc->di_extsize) {
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
 =

-	if (nextents > MAXEXTNUM)  {
-		do_warn(_("too many data fork extents (%llu) in inode %llu\n"),
-			nextents, lino);
+	/*
+	 * general size/consistency checks:
+	 */
+	if (process_check_inode_sizes(mp, dino, lino, type) !=3D 0)
+		goto clear_bad_out;
 =

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
 =

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
 =

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
 =

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
 =

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
 =

 	if (dblkmap)
 		blkmap_free(dblkmap);
 =

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
-
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
-	_("would convert back to version 1,\n\tthis might destroy %d links\n")=
,
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
 =

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
-_("clearing obsolete nlink field in version 2 inode %llu, was %d, now 0=
\n"),
-				lino, INT_GET(dinoc->di_onlink, ARCH_CONVERT));
-			dinoc->di_onlink =3D 0;
-			*dirty =3D 1;
-		} else  {
-			do_warn(
-_("would clear obsolete nlink field in version 2 inode %llu, currently =
%d\n"),
-				lino, INT_GET(dinoc->di_onlink, ARCH_CONVERT));
-			*dirty =3D 1;
-		}
-	}
+	return retval;
 =

-	return(retval > 0 ? 1 : 0);
+clear_bad_out:
+	if (!no_modify)  {
+		*dirty +=3D clear_dinode(mp, dino, lino);
+		ASSERT(*dirty > 0);
+	}
+bad_out:
+	*used =3D is_free;
+	*isa_dir =3D 0;
+	if (dblkmap)
+		blkmap_free(dblkmap);
+	return 1;
 }
 =

 /*
@@ -2983,8 +2835,6 @@
  *				claimed blocks using the bitmap.
  *	Outs:
  *		dirty -- whether we changed the inode (1 =3D=3D yes)
- *		cleared -- whether we cleared the inode (1 =3D=3D yes).  In
- *				no modify mode, if we would have cleared it
  *		used -- 1 if the inode is used, 0 if free.  In no modify
  *			mode, whether the inode should be used or free
  *		isa_dir -- 1 if the inode is a directory, 0 if not.  In
@@ -2994,30 +2844,29 @@
  */
 =

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
 =

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
 =

 /*
@@ -3027,25 +2876,24 @@
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
 =

 /*
@@ -3054,23 +2902,22 @@
  * returns 0 if the inode passes the cursory sanity check, 1 otherwise.=

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
Index: ci/xfsprogs/repair/dinode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dinode.h	2007-11-16 14:45:56.000000000 +1100=

+++ ci/xfsprogs/repair/dinode.h	2007-11-16 14:46:32.000000000 +1100
@@ -84,7 +84,6 @@
 		xfs_agino_t ino,
 		int was_free,
 		int *dirty,
-		int *tossit,
 		int *used,
 		int check_dirs,
 		int check_dups,

------------blQY9A8HShDiztkzvReN2F
Content-Disposition: attachment; filename=ci_user.patch
Content-Type: text/x-patch; name=ci_user.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
xfsprogs/include/casefoldtable.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

Index: ci/xfsprogs/include/casefoldtable.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/include/casefoldtable.h	2008-01-18 15:00:08.788602304 +1=
100
@@ -0,0 +1,29 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef CASEFOLDTABLE_H
+#define CASEFOLDTABLE_H
+
+#include "xfs_unicode.h"
+
+#define XFS_CFT_MIN_NUM_TABLES	3		/* minumum number of tables */
+#define XFS_CFT_MAX_NUM_TABLES	3		/* maximum number of tables */
+
+int libxfs_create_casefoldtable(xfs_mount_t *mp, int isturkic);
+
+#endif /* CASEFOLDTABLE_H */
Index: ci/xfsprogs/include/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_sb.h	2008-01-18 14:50:42.000000000 +110=
0
+++ ci/xfsprogs/include/xfs_sb.h	2008-01-18 15:00:08.788602304 +1100
@@ -46,10 +46,12 @@
 #define XFS_SB_VERSION_SECTORBIT	0x0800
 #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
 #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define XFS_SB_VERSION_OLDCIBIT		0x4000
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 #define	XFS_SB_VERSION_OKSASHFBITS	\
 	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_OLDCIBIT)
 #define	XFS_SB_VERSION_OKREALFBITS	\
 	(XFS_SB_VERSION_ATTRBIT | \
 	 XFS_SB_VERSION_NLINKBIT | \
@@ -82,13 +84,12 @@
 #define XFS_SB_VERSION2_DONOTUSEBIT2	0x00000004
 #define XFS_SB_VERSION2_ATTR2BIT	0x00000008	/* Inline attr rework */
 #define XFS_SB_VERSION2_PARENTBIT	0x00000010	/* Parent pointers */
-#define XFS_SB_VERSION2_SASHFBITS	0xff000000	/* Mask: features that
-							   require changing
-							   PROM and SASH */
+#define XFS_SB_VERSION2_UNICODEBIT	0x00000020	/* Unicode names */
 =

 #define	XFS_SB_VERSION2_OKREALFBITS	\
-	(XFS_SB_VERSION2_ATTR2BIT |	\
-	 XFS_SB_VERSION2_LAZYSBCOUNTBIT)
+	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+	 XFS_SB_VERSION2_ATTR2BIT | \
+	 XFS_SB_VERSION2_UNICODEBIT)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
 #define XFS_SB_VERSION2_OKREALBITS	\
@@ -151,6 +152,8 @@
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
+	__uint32_t	sb_bad_features2; /* unusable space */
+	xfs_ino_t	sb_cftino;	/* unicode case folding table inode */
 } xfs_sb_t;
 =

 /*
@@ -169,7 +172,7 @@
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_CFTINO,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 =

@@ -194,13 +197,15 @@
 #define XFS_SB_IFREE		XFS_SB_MVAL(IFREE)
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
+#define XFS_SB_CFTINO		XFS_SB_MVAL(CFTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
 	(XFS_SB_UUID | XFS_SB_ROOTINO | XFS_SB_RBMINO | XFS_SB_RSUMINO | \
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
-	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2)
+	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \=

+	 XFS_SB_CFTINO)
 =

 =

 /*
@@ -415,6 +420,12 @@
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 =

+static inline int xfs_sb_version_hasoldci(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) =3D=3D XFS_SB_VERSION_4) && \
+		((sbp)->sb_versionnum & XFS_SB_VERSION_OLDCIBIT);
+}
+
 #define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)=

 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
@@ -455,6 +466,12 @@
 		((sbp)->sb_features2 | XFS_SB_VERSION2_ATTR2BIT)));
 }
 =

+static inline int xfs_sb_version_hasunicode(xfs_sb_t *sbp)
+{
+	return (xfs_sb_version_hasmorebits(sbp) &&	\
+		((sbp)->sb_features2 & XFS_SB_VERSION2_UNICODEBIT));
+}
+
 /*
  * end of superblock version macros
  */
Index: ci/xfsprogs/libxfs/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/Makefile	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/libxfs/Makefile	2008-01-18 15:00:08.816598712 +1100
@@ -11,13 +11,13 @@
 LT_AGE =3D 0
 =

 HFILES =3D xfs.h init.h
-CFILES =3D bit.c cache.c init.c logitem.c rdwr.c trans.c util.c \
-	xfs_alloc.c xfs_ialloc.c xfs_rtalloc.c \
+CFILES =3D bit.c cache.c casefoldtable.c init.c logitem.c rdwr.c trans.=
c util.c \
+	utf8.c xfs_alloc.c xfs_ialloc.c xfs_rtalloc.c \
 	xfs_inode.c xfs_btree.c xfs_alloc_btree.c xfs_ialloc_btree.c \
 	xfs_bmap_btree.c xfs_da_btree.c xfs_dir.c xfs_dir_leaf.c \
 	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
 	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
-	xfs_mount.c xfs_trans.c xfs_attr.c
+	xfs_mount.c xfs_trans.c xfs_attr.c xfs_unicode.c
 =

 CFILES +=3D $(PKG_PLATFORM).c
 PCFILES =3D darwin.c freebsd.c irix.c linux.c
Index: ci/xfsprogs/libxfs/casefoldtable.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/libxfs/casefoldtable.c	2008-01-18 15:00:08.832596659 +11=
00
@@ -0,0 +1,760 @@
+/*
+ * Unicode case folding table automatically generated from
+ * http://www.unicode.org/Public/UNIDATA/CaseFolding.txt
+ *
+ * Characters that map to 0xe000 to 0xe3fff are indexes to the double
+ * character sequence in xfs_case_fold_double_table. 0xe400 to 0xe7ff
+ * map to the triple sequences in xfs_case_fold_triple_table.
+ */
+
+#include <xfs/libxfs.h>
+#include <casefoldtable.h>
+
+__uint16_t xfs_case_fold_table[15 * 256] =3D {
+
+	/* Most-significant-byte index table */
+
+	0x0100, 0x0200, 0x0300, 0x0400, 0x0500, 0x0600, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0700, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0800, 0x0900,
+	0x0000, 0x0a00, 0x0000, 0x0000, 0x0b00, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0c00, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+	0x0000, 0x0000, 0x0000, 0x0d00, 0x0000, 0x0000, 0x0000, 0x0e00,
+
+	/* Characters U+0000 to U+00FF */
+
+	0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007,
+	0x0008, 0x0009, 0x000a, 0x000b, 0x000c, 0x000d, 0x000e, 0x000f,
+	0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015, 0x0016, 0x0017,
+	0x0018, 0x0019, 0x001a, 0x001b, 0x001c, 0x001d, 0x001e, 0x001f,
+	0x0020, 0x0021, 0x0022, 0x0023, 0x0024, 0x0025, 0x0026, 0x0027,
+	0x0028, 0x0029, 0x002a, 0x002b, 0x002c, 0x002d, 0x002e, 0x002f,
+	0x0030, 0x0031, 0x0032, 0x0033, 0x0034, 0x0035, 0x0036, 0x0037,
+	0x0038, 0x0039, 0x003a, 0x003b, 0x003c, 0x003d, 0x003e, 0x003f,
+	0x0040, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067,
+	0x0068, 0x0069, 0x006a, 0x006b, 0x006c, 0x006d, 0x006e, 0x006f,
+	0x0070, 0x0071, 0x0072, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077,
+	0x0078, 0x0079, 0x007a, 0x005b, 0x005c, 0x005d, 0x005e, 0x005f,
+	0x0060, 0x0061, 0x0062, 0x0063, 0x0064, 0x0065, 0x0066, 0x0067,
+	0x0068, 0x0069, 0x006a, 0x006b, 0x006c, 0x006d, 0x006e, 0x006f,
+	0x0070, 0x0071, 0x0072, 0x0073, 0x0074, 0x0075, 0x0076, 0x0077,
+	0x0078, 0x0079, 0x007a, 0x007b, 0x007c, 0x007d, 0x007e, 0x007f,
+	0x0080, 0x0081, 0x0082, 0x0083, 0x0084, 0x0085, 0x0086, 0x0087,
+	0x0088, 0x0089, 0x008a, 0x008b, 0x008c, 0x008d, 0x008e, 0x008f,
+	0x0090, 0x0091, 0x0092, 0x0093, 0x0094, 0x0095, 0x0096, 0x0097,
+	0x0098, 0x0099, 0x009a, 0x009b, 0x009c, 0x009d, 0x009e, 0x009f,
+	0x00a0, 0x00a1, 0x00a2, 0x00a3, 0x00a4, 0x00a5, 0x00a6, 0x00a7,
+	0x00a8, 0x00a9, 0x00aa, 0x00ab, 0x00ac, 0x00ad, 0x00ae, 0x00af,
+	0x00b0, 0x00b1, 0x00b2, 0x00b3, 0x00b4, 0x03bc, 0x00b6, 0x00b7,
+	0x00b8, 0x00b9, 0x00ba, 0x00bb, 0x00bc, 0x00bd, 0x00be, 0x00bf,
+	0x00e0, 0x00e1, 0x00e2, 0x00e3, 0x00e4, 0x00e5, 0x00e6, 0x00e7,
+	0x00e8, 0x00e9, 0x00ea, 0x00eb, 0x00ec, 0x00ed, 0x00ee, 0x00ef,
+	0x00f0, 0x00f1, 0x00f2, 0x00f3, 0x00f4, 0x00f5, 0x00f6, 0x00d7,
+	0x00f8, 0x00f9, 0x00fa, 0x00fb, 0x00fc, 0x00fd, 0x00fe, 0xe000,
+	0x00e0, 0x00e1, 0x00e2, 0x00e3, 0x00e4, 0x00e5, 0x00e6, 0x00e7,
+	0x00e8, 0x00e9, 0x00ea, 0x00eb, 0x00ec, 0x00ed, 0x00ee, 0x00ef,
+	0x00f0, 0x00f1, 0x00f2, 0x00f3, 0x00f4, 0x00f5, 0x00f6, 0x00f7,
+	0x00f8, 0x00f9, 0x00fa, 0x00fb, 0x00fc, 0x00fd, 0x00fe, 0x00ff,
+
+	/* Characters U+0100 to U+01FF */
+
+	0x0101, 0x0101, 0x0103, 0x0103, 0x0105, 0x0105, 0x0107, 0x0107,
+	0x0109, 0x0109, 0x010b, 0x010b, 0x010d, 0x010d, 0x010f, 0x010f,
+	0x0111, 0x0111, 0x0113, 0x0113, 0x0115, 0x0115, 0x0117, 0x0117,
+	0x0119, 0x0119, 0x011b, 0x011b, 0x011d, 0x011d, 0x011f, 0x011f,
+	0x0121, 0x0121, 0x0123, 0x0123, 0x0125, 0x0125, 0x0127, 0x0127,
+	0x0129, 0x0129, 0x012b, 0x012b, 0x012d, 0x012d, 0x012f, 0x012f,
+	0xe001, 0x0131, 0x0133, 0x0133, 0x0135, 0x0135, 0x0137, 0x0137,
+	0x0138, 0x013a, 0x013a, 0x013c, 0x013c, 0x013e, 0x013e, 0x0140,
+	0x0140, 0x0142, 0x0142, 0x0144, 0x0144, 0x0146, 0x0146, 0x0148,
+	0x0148, 0xe002, 0x014b, 0x014b, 0x014d, 0x014d, 0x014f, 0x014f,
+	0x0151, 0x0151, 0x0153, 0x0153, 0x0155, 0x0155, 0x0157, 0x0157,
+	0x0159, 0x0159, 0x015b, 0x015b, 0x015d, 0x015d, 0x015f, 0x015f,
+	0x0161, 0x0161, 0x0163, 0x0163, 0x0165, 0x0165, 0x0167, 0x0167,
+	0x0169, 0x0169, 0x016b, 0x016b, 0x016d, 0x016d, 0x016f, 0x016f,
+	0x0171, 0x0171, 0x0173, 0x0173, 0x0175, 0x0175, 0x0177, 0x0177,
+	0x00ff, 0x017a, 0x017a, 0x017c, 0x017c, 0x017e, 0x017e, 0x0073,
+	0x0180, 0x0253, 0x0183, 0x0183, 0x0185, 0x0185, 0x0254, 0x0188,
+	0x0188, 0x0256, 0x0257, 0x018c, 0x018c, 0x018d, 0x01dd, 0x0259,
+	0x025b, 0x0192, 0x0192, 0x0260, 0x0263, 0x0195, 0x0269, 0x0268,
+	0x0199, 0x0199, 0x019a, 0x019b, 0x026f, 0x0272, 0x019e, 0x0275,
+	0x01a1, 0x01a1, 0x01a3, 0x01a3, 0x01a5, 0x01a5, 0x0280, 0x01a8,
+	0x01a8, 0x0283, 0x01aa, 0x01ab, 0x01ad, 0x01ad, 0x0288, 0x01b0,
+	0x01b0, 0x028a, 0x028b, 0x01b4, 0x01b4, 0x01b6, 0x01b6, 0x0292,
+	0x01b9, 0x01b9, 0x01ba, 0x01bb, 0x01bd, 0x01bd, 0x01be, 0x01bf,
+	0x01c0, 0x01c1, 0x01c2, 0x01c3, 0x01c6, 0x01c6, 0x01c6, 0x01c9,
+	0x01c9, 0x01c9, 0x01cc, 0x01cc, 0x01cc, 0x01ce, 0x01ce, 0x01d0,
+	0x01d0, 0x01d2, 0x01d2, 0x01d4, 0x01d4, 0x01d6, 0x01d6, 0x01d8,
+	0x01d8, 0x01da, 0x01da, 0x01dc, 0x01dc, 0x01dd, 0x01df, 0x01df,
+	0x01e1, 0x01e1, 0x01e3, 0x01e3, 0x01e5, 0x01e5, 0x01e7, 0x01e7,
+	0x01e9, 0x01e9, 0x01eb, 0x01eb, 0x01ed, 0x01ed, 0x01ef, 0x01ef,
+	0xe003, 0x01f3, 0x01f3, 0x01f3, 0x01f5, 0x01f5, 0x0195, 0x01bf,
+	0x01f9, 0x01f9, 0x01fb, 0x01fb, 0x01fd, 0x01fd, 0x01ff, 0x01ff,
+
+	/* Characters U+0200 to U+02FF */
+
+	0x0201, 0x0201, 0x0203, 0x0203, 0x0205, 0x0205, 0x0207, 0x0207,
+	0x0209, 0x0209, 0x020b, 0x020b, 0x020d, 0x020d, 0x020f, 0x020f,
+	0x0211, 0x0211, 0x0213, 0x0213, 0x0215, 0x0215, 0x0217, 0x0217,
+	0x0219, 0x0219, 0x021b, 0x021b, 0x021d, 0x021d, 0x021f, 0x021f,
+	0x019e, 0x0221, 0x0223, 0x0223, 0x0225, 0x0225, 0x0227, 0x0227,
+	0x0229, 0x0229, 0x022b, 0x022b, 0x022d, 0x022d, 0x022f, 0x022f,
+	0x0231, 0x0231, 0x0233, 0x0233, 0x0234, 0x0235, 0x0236, 0x0237,
+	0x0238, 0x0239, 0x2c65, 0x023c, 0x023c, 0x019a, 0x2c66, 0x023f,
+	0x0240, 0x0242, 0x0242, 0x0180, 0x0289, 0x028c, 0x0247, 0x0247,
+	0x0249, 0x0249, 0x024b, 0x024b, 0x024d, 0x024d, 0x024f, 0x024f,
+	0x0250, 0x0251, 0x0252, 0x0253, 0x0254, 0x0255, 0x0256, 0x0257,
+	0x0258, 0x0259, 0x025a, 0x025b, 0x025c, 0x025d, 0x025e, 0x025f,
+	0x0260, 0x0261, 0x0262, 0x0263, 0x0264, 0x0265, 0x0266, 0x0267,
+	0x0268, 0x0269, 0x026a, 0x026b, 0x026c, 0x026d, 0x026e, 0x026f,
+	0x0270, 0x0271, 0x0272, 0x0273, 0x0274, 0x0275, 0x0276, 0x0277,
+	0x0278, 0x0279, 0x027a, 0x027b, 0x027c, 0x027d, 0x027e, 0x027f,
+	0x0280, 0x0281, 0x0282, 0x0283, 0x0284, 0x0285, 0x0286, 0x0287,
+	0x0288, 0x0289, 0x028a, 0x028b, 0x028c, 0x028d, 0x028e, 0x028f,
+	0x0290, 0x0291, 0x0292, 0x0293, 0x0294, 0x0295, 0x0296, 0x0297,
+	0x0298, 0x0299, 0x029a, 0x029b, 0x029c, 0x029d, 0x029e, 0x029f,
+	0x02a0, 0x02a1, 0x02a2, 0x02a3, 0x02a4, 0x02a5, 0x02a6, 0x02a7,
+	0x02a8, 0x02a9, 0x02aa, 0x02ab, 0x02ac, 0x02ad, 0x02ae, 0x02af,
+	0x02b0, 0x02b1, 0x02b2, 0x02b3, 0x02b4, 0x02b5, 0x02b6, 0x02b7,
+	0x02b8, 0x02b9, 0x02ba, 0x02bb, 0x02bc, 0x02bd, 0x02be, 0x02bf,
+	0x02c0, 0x02c1, 0x02c2, 0x02c3, 0x02c4, 0x02c5, 0x02c6, 0x02c7,
+	0x02c8, 0x02c9, 0x02ca, 0x02cb, 0x02cc, 0x02cd, 0x02ce, 0x02cf,
+	0x02d0, 0x02d1, 0x02d2, 0x02d3, 0x02d4, 0x02d5, 0x02d6, 0x02d7,
+	0x02d8, 0x02d9, 0x02da, 0x02db, 0x02dc, 0x02dd, 0x02de, 0x02df,
+	0x02e0, 0x02e1, 0x02e2, 0x02e3, 0x02e4, 0x02e5, 0x02e6, 0x02e7,
+	0x02e8, 0x02e9, 0x02ea, 0x02eb, 0x02ec, 0x02ed, 0x02ee, 0x02ef,
+	0x02f0, 0x02f1, 0x02f2, 0x02f3, 0x02f4, 0x02f5, 0x02f6, 0x02f7,
+	0x02f8, 0x02f9, 0x02fa, 0x02fb, 0x02fc, 0x02fd, 0x02fe, 0x02ff,
+
+	/* Characters U+0300 to U+03FF */
+
+	0x0300, 0x0301, 0x0302, 0x0303, 0x0304, 0x0305, 0x0306, 0x0307,
+	0x0308, 0x0309, 0x030a, 0x030b, 0x030c, 0x030d, 0x030e, 0x030f,
+	0x0310, 0x0311, 0x0312, 0x0313, 0x0314, 0x0315, 0x0316, 0x0317,
+	0x0318, 0x0319, 0x031a, 0x031b, 0x031c, 0x031d, 0x031e, 0x031f,
+	0x0320, 0x0321, 0x0322, 0x0323, 0x0324, 0x0325, 0x0326, 0x0327,
+	0x0328, 0x0329, 0x032a, 0x032b, 0x032c, 0x032d, 0x032e, 0x032f,
+	0x0330, 0x0331, 0x0332, 0x0333, 0x0334, 0x0335, 0x0336, 0x0337,
+	0x0338, 0x0339, 0x033a, 0x033b, 0x033c, 0x033d, 0x033e, 0x033f,
+	0x0340, 0x0341, 0x0342, 0x0343, 0x0344, 0x03b9, 0x0346, 0x0347,
+	0x0348, 0x0349, 0x034a, 0x034b, 0x034c, 0x034d, 0x034e, 0x034f,
+	0x0350, 0x0351, 0x0352, 0x0353, 0x0354, 0x0355, 0x0356, 0x0357,
+	0x0358, 0x0359, 0x035a, 0x035b, 0x035c, 0x035d, 0x035e, 0x035f,
+	0x0360, 0x0361, 0x0362, 0x0363, 0x0364, 0x0365, 0x0366, 0x0367,
+	0x0368, 0x0369, 0x036a, 0x036b, 0x036c, 0x036d, 0x036e, 0x036f,
+	0x0370, 0x0371, 0x0372, 0x0373, 0x0374, 0x0375, 0x0376, 0x0377,
+	0x0378, 0x0379, 0x037a, 0x037b, 0x037c, 0x037d, 0x037e, 0x037f,
+	0x0380, 0x0381, 0x0382, 0x0383, 0x0384, 0x0385, 0x03ac, 0x0387,
+	0x03ad, 0x03ae, 0x03af, 0x038b, 0x03cc, 0x038d, 0x03cd, 0x03ce,
+	0xe400, 0x03b1, 0x03b2, 0x03b3, 0x03b4, 0x03b5, 0x03b6, 0x03b7,
+	0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bc, 0x03bd, 0x03be, 0x03bf,
+	0x03c0, 0x03c1, 0x03a2, 0x03c3, 0x03c4, 0x03c5, 0x03c6, 0x03c7,
+	0x03c8, 0x03c9, 0x03ca, 0x03cb, 0x03ac, 0x03ad, 0x03ae, 0x03af,
+	0xe401, 0x03b1, 0x03b2, 0x03b3, 0x03b4, 0x03b5, 0x03b6, 0x03b7,
+	0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bc, 0x03bd, 0x03be, 0x03bf,
+	0x03c0, 0x03c1, 0x03c3, 0x03c3, 0x03c4, 0x03c5, 0x03c6, 0x03c7,
+	0x03c8, 0x03c9, 0x03ca, 0x03cb, 0x03cc, 0x03cd, 0x03ce, 0x03cf,
+	0x03b2, 0x03b8, 0x03d2, 0x03d3, 0x03d4, 0x03c6, 0x03c0, 0x03d7,
+	0x03d9, 0x03d9, 0x03db, 0x03db, 0x03dd, 0x03dd, 0x03df, 0x03df,
+	0x03e1, 0x03e1, 0x03e3, 0x03e3, 0x03e5, 0x03e5, 0x03e7, 0x03e7,
+	0x03e9, 0x03e9, 0x03eb, 0x03eb, 0x03ed, 0x03ed, 0x03ef, 0x03ef,
+	0x03ba, 0x03c1, 0x03f2, 0x03f3, 0x03b8, 0x03b5, 0x03f6, 0x03f8,
+	0x03f8, 0x03f2, 0x03fb, 0x03fb, 0x03fc, 0x037b, 0x037c, 0x037d,
+
+	/* Characters U+0400 to U+04FF */
+
+	0x0450, 0x0451, 0x0452, 0x0453, 0x0454, 0x0455, 0x0456, 0x0457,
+	0x0458, 0x0459, 0x045a, 0x045b, 0x045c, 0x045d, 0x045e, 0x045f,
+	0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, 0x0436, 0x0437,
+	0x0438, 0x0439, 0x043a, 0x043b, 0x043c, 0x043d, 0x043e, 0x043f,
+	0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447,
+	0x0448, 0x0449, 0x044a, 0x044b, 0x044c, 0x044d, 0x044e, 0x044f,
+	0x0430, 0x0431, 0x0432, 0x0433, 0x0434, 0x0435, 0x0436, 0x0437,
+	0x0438, 0x0439, 0x043a, 0x043b, 0x043c, 0x043d, 0x043e, 0x043f,
+	0x0440, 0x0441, 0x0442, 0x0443, 0x0444, 0x0445, 0x0446, 0x0447,
+	0x0448, 0x0449, 0x044a, 0x044b, 0x044c, 0x044d, 0x044e, 0x044f,
+	0x0450, 0x0451, 0x0452, 0x0453, 0x0454, 0x0455, 0x0456, 0x0457,
+	0x0458, 0x0459, 0x045a, 0x045b, 0x045c, 0x045d, 0x045e, 0x045f,
+	0x0461, 0x0461, 0x0463, 0x0463, 0x0465, 0x0465, 0x0467, 0x0467,
+	0x0469, 0x0469, 0x046b, 0x046b, 0x046d, 0x046d, 0x046f, 0x046f,
+	0x0471, 0x0471, 0x0473, 0x0473, 0x0475, 0x0475, 0x0477, 0x0477,
+	0x0479, 0x0479, 0x047b, 0x047b, 0x047d, 0x047d, 0x047f, 0x047f,
+	0x0481, 0x0481, 0x0482, 0x0483, 0x0484, 0x0485, 0x0486, 0x0487,
+	0x0488, 0x0489, 0x048b, 0x048b, 0x048d, 0x048d, 0x048f, 0x048f,
+	0x0491, 0x0491, 0x0493, 0x0493, 0x0495, 0x0495, 0x0497, 0x0497,
+	0x0499, 0x0499, 0x049b, 0x049b, 0x049d, 0x049d, 0x049f, 0x049f,
+	0x04a1, 0x04a1, 0x04a3, 0x04a3, 0x04a5, 0x04a5, 0x04a7, 0x04a7,
+	0x04a9, 0x04a9, 0x04ab, 0x04ab, 0x04ad, 0x04ad, 0x04af, 0x04af,
+	0x04b1, 0x04b1, 0x04b3, 0x04b3, 0x04b5, 0x04b5, 0x04b7, 0x04b7,
+	0x04b9, 0x04b9, 0x04bb, 0x04bb, 0x04bd, 0x04bd, 0x04bf, 0x04bf,
+	0x04cf, 0x04c2, 0x04c2, 0x04c4, 0x04c4, 0x04c6, 0x04c6, 0x04c8,
+	0x04c8, 0x04ca, 0x04ca, 0x04cc, 0x04cc, 0x04ce, 0x04ce, 0x04cf,
+	0x04d1, 0x04d1, 0x04d3, 0x04d3, 0x04d5, 0x04d5, 0x04d7, 0x04d7,
+	0x04d9, 0x04d9, 0x04db, 0x04db, 0x04dd, 0x04dd, 0x04df, 0x04df,
+	0x04e1, 0x04e1, 0x04e3, 0x04e3, 0x04e5, 0x04e5, 0x04e7, 0x04e7,
+	0x04e9, 0x04e9, 0x04eb, 0x04eb, 0x04ed, 0x04ed, 0x04ef, 0x04ef,
+	0x04f1, 0x04f1, 0x04f3, 0x04f3, 0x04f5, 0x04f5, 0x04f7, 0x04f7,
+	0x04f9, 0x04f9, 0x04fb, 0x04fb, 0x04fd, 0x04fd, 0x04ff, 0x04ff,
+
+	/* Characters U+0500 to U+05FF */
+
+	0x0501, 0x0501, 0x0503, 0x0503, 0x0505, 0x0505, 0x0507, 0x0507,
+	0x0509, 0x0509, 0x050b, 0x050b, 0x050d, 0x050d, 0x050f, 0x050f,
+	0x0511, 0x0511, 0x0513, 0x0513, 0x0514, 0x0515, 0x0516, 0x0517,
+	0x0518, 0x0519, 0x051a, 0x051b, 0x051c, 0x051d, 0x051e, 0x051f,
+	0x0520, 0x0521, 0x0522, 0x0523, 0x0524, 0x0525, 0x0526, 0x0527,
+	0x0528, 0x0529, 0x052a, 0x052b, 0x052c, 0x052d, 0x052e, 0x052f,
+	0x0530, 0x0561, 0x0562, 0x0563, 0x0564, 0x0565, 0x0566, 0x0567,
+	0x0568, 0x0569, 0x056a, 0x056b, 0x056c, 0x056d, 0x056e, 0x056f,
+	0x0570, 0x0571, 0x0572, 0x0573, 0x0574, 0x0575, 0x0576, 0x0577,
+	0x0578, 0x0579, 0x057a, 0x057b, 0x057c, 0x057d, 0x057e, 0x057f,
+	0x0580, 0x0581, 0x0582, 0x0583, 0x0584, 0x0585, 0x0586, 0x0557,
+	0x0558, 0x0559, 0x055a, 0x055b, 0x055c, 0x055d, 0x055e, 0x055f,
+	0x0560, 0x0561, 0x0562, 0x0563, 0x0564, 0x0565, 0x0566, 0x0567,
+	0x0568, 0x0569, 0x056a, 0x056b, 0x056c, 0x056d, 0x056e, 0x056f,
+	0x0570, 0x0571, 0x0572, 0x0573, 0x0574, 0x0575, 0x0576, 0x0577,
+	0x0578, 0x0579, 0x057a, 0x057b, 0x057c, 0x057d, 0x057e, 0x057f,
+	0x0580, 0x0581, 0x0582, 0x0583, 0x0584, 0x0585, 0x0586, 0xe004,
+	0x0588, 0x0589, 0x058a, 0x058b, 0x058c, 0x058d, 0x058e, 0x058f,
+	0x0590, 0x0591, 0x0592, 0x0593, 0x0594, 0x0595, 0x0596, 0x0597,
+	0x0598, 0x0599, 0x059a, 0x059b, 0x059c, 0x059d, 0x059e, 0x059f,
+	0x05a0, 0x05a1, 0x05a2, 0x05a3, 0x05a4, 0x05a5, 0x05a6, 0x05a7,
+	0x05a8, 0x05a9, 0x05aa, 0x05ab, 0x05ac, 0x05ad, 0x05ae, 0x05af,
+	0x05b0, 0x05b1, 0x05b2, 0x05b3, 0x05b4, 0x05b5, 0x05b6, 0x05b7,
+	0x05b8, 0x05b9, 0x05ba, 0x05bb, 0x05bc, 0x05bd, 0x05be, 0x05bf,
+	0x05c0, 0x05c1, 0x05c2, 0x05c3, 0x05c4, 0x05c5, 0x05c6, 0x05c7,
+	0x05c8, 0x05c9, 0x05ca, 0x05cb, 0x05cc, 0x05cd, 0x05ce, 0x05cf,
+	0x05d0, 0x05d1, 0x05d2, 0x05d3, 0x05d4, 0x05d5, 0x05d6, 0x05d7,
+	0x05d8, 0x05d9, 0x05da, 0x05db, 0x05dc, 0x05dd, 0x05de, 0x05df,
+	0x05e0, 0x05e1, 0x05e2, 0x05e3, 0x05e4, 0x05e5, 0x05e6, 0x05e7,
+	0x05e8, 0x05e9, 0x05ea, 0x05eb, 0x05ec, 0x05ed, 0x05ee, 0x05ef,
+	0x05f0, 0x05f1, 0x05f2, 0x05f3, 0x05f4, 0x05f5, 0x05f6, 0x05f7,
+	0x05f8, 0x05f9, 0x05fa, 0x05fb, 0x05fc, 0x05fd, 0x05fe, 0x05ff,
+
+	/* Characters U+1000 to U+10FF */
+
+	0x1000, 0x1001, 0x1002, 0x1003, 0x1004, 0x1005, 0x1006, 0x1007,
+	0x1008, 0x1009, 0x100a, 0x100b, 0x100c, 0x100d, 0x100e, 0x100f,
+	0x1010, 0x1011, 0x1012, 0x1013, 0x1014, 0x1015, 0x1016, 0x1017,
+	0x1018, 0x1019, 0x101a, 0x101b, 0x101c, 0x101d, 0x101e, 0x101f,
+	0x1020, 0x1021, 0x1022, 0x1023, 0x1024, 0x1025, 0x1026, 0x1027,
+	0x1028, 0x1029, 0x102a, 0x102b, 0x102c, 0x102d, 0x102e, 0x102f,
+	0x1030, 0x1031, 0x1032, 0x1033, 0x1034, 0x1035, 0x1036, 0x1037,
+	0x1038, 0x1039, 0x103a, 0x103b, 0x103c, 0x103d, 0x103e, 0x103f,
+	0x1040, 0x1041, 0x1042, 0x1043, 0x1044, 0x1045, 0x1046, 0x1047,
+	0x1048, 0x1049, 0x104a, 0x104b, 0x104c, 0x104d, 0x104e, 0x104f,
+	0x1050, 0x1051, 0x1052, 0x1053, 0x1054, 0x1055, 0x1056, 0x1057,
+	0x1058, 0x1059, 0x105a, 0x105b, 0x105c, 0x105d, 0x105e, 0x105f,
+	0x1060, 0x1061, 0x1062, 0x1063, 0x1064, 0x1065, 0x1066, 0x1067,
+	0x1068, 0x1069, 0x106a, 0x106b, 0x106c, 0x106d, 0x106e, 0x106f,
+	0x1070, 0x1071, 0x1072, 0x1073, 0x1074, 0x1075, 0x1076, 0x1077,
+	0x1078, 0x1079, 0x107a, 0x107b, 0x107c, 0x107d, 0x107e, 0x107f,
+	0x1080, 0x1081, 0x1082, 0x1083, 0x1084, 0x1085, 0x1086, 0x1087,
+	0x1088, 0x1089, 0x108a, 0x108b, 0x108c, 0x108d, 0x108e, 0x108f,
+	0x1090, 0x1091, 0x1092, 0x1093, 0x1094, 0x1095, 0x1096, 0x1097,
+	0x1098, 0x1099, 0x109a, 0x109b, 0x109c, 0x109d, 0x109e, 0x109f,
+	0x2d00, 0x2d01, 0x2d02, 0x2d03, 0x2d04, 0x2d05, 0x2d06, 0x2d07,
+	0x2d08, 0x2d09, 0x2d0a, 0x2d0b, 0x2d0c, 0x2d0d, 0x2d0e, 0x2d0f,
+	0x2d10, 0x2d11, 0x2d12, 0x2d13, 0x2d14, 0x2d15, 0x2d16, 0x2d17,
+	0x2d18, 0x2d19, 0x2d1a, 0x2d1b, 0x2d1c, 0x2d1d, 0x2d1e, 0x2d1f,
+	0x2d20, 0x2d21, 0x2d22, 0x2d23, 0x2d24, 0x2d25, 0x10c6, 0x10c7,
+	0x10c8, 0x10c9, 0x10ca, 0x10cb, 0x10cc, 0x10cd, 0x10ce, 0x10cf,
+	0x10d0, 0x10d1, 0x10d2, 0x10d3, 0x10d4, 0x10d5, 0x10d6, 0x10d7,
+	0x10d8, 0x10d9, 0x10da, 0x10db, 0x10dc, 0x10dd, 0x10de, 0x10df,
+	0x10e0, 0x10e1, 0x10e2, 0x10e3, 0x10e4, 0x10e5, 0x10e6, 0x10e7,
+	0x10e8, 0x10e9, 0x10ea, 0x10eb, 0x10ec, 0x10ed, 0x10ee, 0x10ef,
+	0x10f0, 0x10f1, 0x10f2, 0x10f3, 0x10f4, 0x10f5, 0x10f6, 0x10f7,
+	0x10f8, 0x10f9, 0x10fa, 0x10fb, 0x10fc, 0x10fd, 0x10fe, 0x10ff,
+
+	/* Characters U+1E00 to U+1EFF */
+
+	0x1e01, 0x1e01, 0x1e03, 0x1e03, 0x1e05, 0x1e05, 0x1e07, 0x1e07,
+	0x1e09, 0x1e09, 0x1e0b, 0x1e0b, 0x1e0d, 0x1e0d, 0x1e0f, 0x1e0f,
+	0x1e11, 0x1e11, 0x1e13, 0x1e13, 0x1e15, 0x1e15, 0x1e17, 0x1e17,
+	0x1e19, 0x1e19, 0x1e1b, 0x1e1b, 0x1e1d, 0x1e1d, 0x1e1f, 0x1e1f,
+	0x1e21, 0x1e21, 0x1e23, 0x1e23, 0x1e25, 0x1e25, 0x1e27, 0x1e27,
+	0x1e29, 0x1e29, 0x1e2b, 0x1e2b, 0x1e2d, 0x1e2d, 0x1e2f, 0x1e2f,
+	0x1e31, 0x1e31, 0x1e33, 0x1e33, 0x1e35, 0x1e35, 0x1e37, 0x1e37,
+	0x1e39, 0x1e39, 0x1e3b, 0x1e3b, 0x1e3d, 0x1e3d, 0x1e3f, 0x1e3f,
+	0x1e41, 0x1e41, 0x1e43, 0x1e43, 0x1e45, 0x1e45, 0x1e47, 0x1e47,
+	0x1e49, 0x1e49, 0x1e4b, 0x1e4b, 0x1e4d, 0x1e4d, 0x1e4f, 0x1e4f,
+	0x1e51, 0x1e51, 0x1e53, 0x1e53, 0x1e55, 0x1e55, 0x1e57, 0x1e57,
+	0x1e59, 0x1e59, 0x1e5b, 0x1e5b, 0x1e5d, 0x1e5d, 0x1e5f, 0x1e5f,
+	0x1e61, 0x1e61, 0x1e63, 0x1e63, 0x1e65, 0x1e65, 0x1e67, 0x1e67,
+	0x1e69, 0x1e69, 0x1e6b, 0x1e6b, 0x1e6d, 0x1e6d, 0x1e6f, 0x1e6f,
+	0x1e71, 0x1e71, 0x1e73, 0x1e73, 0x1e75, 0x1e75, 0x1e77, 0x1e77,
+	0x1e79, 0x1e79, 0x1e7b, 0x1e7b, 0x1e7d, 0x1e7d, 0x1e7f, 0x1e7f,
+	0x1e81, 0x1e81, 0x1e83, 0x1e83, 0x1e85, 0x1e85, 0x1e87, 0x1e87,
+	0x1e89, 0x1e89, 0x1e8b, 0x1e8b, 0x1e8d, 0x1e8d, 0x1e8f, 0x1e8f,
+	0x1e91, 0x1e91, 0x1e93, 0x1e93, 0x1e95, 0x1e95, 0xe005, 0xe006,
+	0xe007, 0xe008, 0xe009, 0x1e61, 0x1e9c, 0x1e9d, 0x1e9e, 0x1e9f,
+	0x1ea1, 0x1ea1, 0x1ea3, 0x1ea3, 0x1ea5, 0x1ea5, 0x1ea7, 0x1ea7,
+	0x1ea9, 0x1ea9, 0x1eab, 0x1eab, 0x1ead, 0x1ead, 0x1eaf, 0x1eaf,
+	0x1eb1, 0x1eb1, 0x1eb3, 0x1eb3, 0x1eb5, 0x1eb5, 0x1eb7, 0x1eb7,
+	0x1eb9, 0x1eb9, 0x1ebb, 0x1ebb, 0x1ebd, 0x1ebd, 0x1ebf, 0x1ebf,
+	0x1ec1, 0x1ec1, 0x1ec3, 0x1ec3, 0x1ec5, 0x1ec5, 0x1ec7, 0x1ec7,
+	0x1ec9, 0x1ec9, 0x1ecb, 0x1ecb, 0x1ecd, 0x1ecd, 0x1ecf, 0x1ecf,
+	0x1ed1, 0x1ed1, 0x1ed3, 0x1ed3, 0x1ed5, 0x1ed5, 0x1ed7, 0x1ed7,
+	0x1ed9, 0x1ed9, 0x1edb, 0x1edb, 0x1edd, 0x1edd, 0x1edf, 0x1edf,
+	0x1ee1, 0x1ee1, 0x1ee3, 0x1ee3, 0x1ee5, 0x1ee5, 0x1ee7, 0x1ee7,
+	0x1ee9, 0x1ee9, 0x1eeb, 0x1eeb, 0x1eed, 0x1eed, 0x1eef, 0x1eef,
+	0x1ef1, 0x1ef1, 0x1ef3, 0x1ef3, 0x1ef5, 0x1ef5, 0x1ef7, 0x1ef7,
+	0x1ef9, 0x1ef9, 0x1efa, 0x1efb, 0x1efc, 0x1efd, 0x1efe, 0x1eff,
+
+	/* Characters U+1F00 to U+1FFF */
+
+	0x1f00, 0x1f01, 0x1f02, 0x1f03, 0x1f04, 0x1f05, 0x1f06, 0x1f07,
+	0x1f00, 0x1f01, 0x1f02, 0x1f03, 0x1f04, 0x1f05, 0x1f06, 0x1f07,
+	0x1f10, 0x1f11, 0x1f12, 0x1f13, 0x1f14, 0x1f15, 0x1f16, 0x1f17,
+	0x1f10, 0x1f11, 0x1f12, 0x1f13, 0x1f14, 0x1f15, 0x1f1e, 0x1f1f,
+	0x1f20, 0x1f21, 0x1f22, 0x1f23, 0x1f24, 0x1f25, 0x1f26, 0x1f27,
+	0x1f20, 0x1f21, 0x1f22, 0x1f23, 0x1f24, 0x1f25, 0x1f26, 0x1f27,
+	0x1f30, 0x1f31, 0x1f32, 0x1f33, 0x1f34, 0x1f35, 0x1f36, 0x1f37,
+	0x1f30, 0x1f31, 0x1f32, 0x1f33, 0x1f34, 0x1f35, 0x1f36, 0x1f37,
+	0x1f40, 0x1f41, 0x1f42, 0x1f43, 0x1f44, 0x1f45, 0x1f46, 0x1f47,
+	0x1f40, 0x1f41, 0x1f42, 0x1f43, 0x1f44, 0x1f45, 0x1f4e, 0x1f4f,
+	0xe00a, 0x1f51, 0xe402, 0x1f53, 0xe403, 0x1f55, 0xe404, 0x1f57,
+	0x1f58, 0x1f51, 0x1f5a, 0x1f53, 0x1f5c, 0x1f55, 0x1f5e, 0x1f57,
+	0x1f60, 0x1f61, 0x1f62, 0x1f63, 0x1f64, 0x1f65, 0x1f66, 0x1f67,
+	0x1f60, 0x1f61, 0x1f62, 0x1f63, 0x1f64, 0x1f65, 0x1f66, 0x1f67,
+	0x1f70, 0x1f71, 0x1f72, 0x1f73, 0x1f74, 0x1f75, 0x1f76, 0x1f77,
+	0x1f78, 0x1f79, 0x1f7a, 0x1f7b, 0x1f7c, 0x1f7d, 0x1f7e, 0x1f7f,
+	0xe00b, 0xe00c, 0xe00d, 0xe00e, 0xe00f, 0xe010, 0xe011, 0xe012,
+	0xe013, 0xe014, 0xe015, 0xe016, 0xe017, 0xe018, 0xe019, 0xe01a,
+	0xe01b, 0xe01c, 0xe01d, 0xe01e, 0xe01f, 0xe020, 0xe021, 0xe022,
+	0xe023, 0xe024, 0xe025, 0xe026, 0xe027, 0xe028, 0xe029, 0xe02a,
+	0xe02b, 0xe02c, 0xe02d, 0xe02e, 0xe02f, 0xe030, 0xe031, 0xe032,
+	0xe033, 0xe034, 0xe035, 0xe036, 0xe037, 0xe038, 0xe039, 0xe03a,
+	0x1fb0, 0x1fb1, 0xe03b, 0xe03c, 0xe03d, 0x1fb5, 0xe03e, 0xe405,
+	0x1fb0, 0x1fb1, 0x1f70, 0x1f71, 0xe03f, 0x1fbd, 0x03b9, 0x1fbf,
+	0x1fc0, 0x1fc1, 0xe040, 0xe041, 0xe042, 0x1fc5, 0xe043, 0xe406,
+	0x1f72, 0x1f73, 0x1f74, 0x1f75, 0xe044, 0x1fcd, 0x1fce, 0x1fcf,
+	0x1fd0, 0x1fd1, 0xe407, 0xe408, 0x1fd4, 0x1fd5, 0xe045, 0xe409,
+	0x1fd0, 0x1fd1, 0x1f76, 0x1f77, 0x1fdc, 0x1fdd, 0x1fde, 0x1fdf,
+	0x1fe0, 0x1fe1, 0xe40a, 0xe40b, 0xe046, 0x1fe5, 0xe047, 0xe40c,
+	0x1fe0, 0x1fe1, 0x1f7a, 0x1f7b, 0x1fe5, 0x1fed, 0x1fee, 0x1fef,
+	0x1ff0, 0x1ff1, 0xe048, 0xe049, 0xe04a, 0x1ff5, 0xe04b, 0xe40d,
+	0x1f78, 0x1f79, 0x1f7c, 0x1f7d, 0xe04c, 0x1ffd, 0x1ffe, 0x1fff,
+
+	/* Characters U+2100 to U+21FF */
+
+	0x2100, 0x2101, 0x2102, 0x2103, 0x2104, 0x2105, 0x2106, 0x2107,
+	0x2108, 0x2109, 0x210a, 0x210b, 0x210c, 0x210d, 0x210e, 0x210f,
+	0x2110, 0x2111, 0x2112, 0x2113, 0x2114, 0x2115, 0x2116, 0x2117,
+	0x2118, 0x2119, 0x211a, 0x211b, 0x211c, 0x211d, 0x211e, 0x211f,
+	0x2120, 0x2121, 0x2122, 0x2123, 0x2124, 0x2125, 0x03c9, 0x2127,
+	0x2128, 0x2129, 0x006b, 0x00e5, 0x212c, 0x212d, 0x212e, 0x212f,
+	0x2130, 0x2131, 0x214e, 0x2133, 0x2134, 0x2135, 0x2136, 0x2137,
+	0x2138, 0x2139, 0x213a, 0x213b, 0x213c, 0x213d, 0x213e, 0x213f,
+	0x2140, 0x2141, 0x2142, 0x2143, 0x2144, 0x2145, 0x2146, 0x2147,
+	0x2148, 0x2149, 0x214a, 0x214b, 0x214c, 0x214d, 0x214e, 0x214f,
+	0x2150, 0x2151, 0x2152, 0x2153, 0x2154, 0x2155, 0x2156, 0x2157,
+	0x2158, 0x2159, 0x215a, 0x215b, 0x215c, 0x215d, 0x215e, 0x215f,
+	0x2170, 0x2171, 0x2172, 0x2173, 0x2174, 0x2175, 0x2176, 0x2177,
+	0x2178, 0x2179, 0x217a, 0x217b, 0x217c, 0x217d, 0x217e, 0x217f,
+	0x2170, 0x2171, 0x2172, 0x2173, 0x2174, 0x2175, 0x2176, 0x2177,
+	0x2178, 0x2179, 0x217a, 0x217b, 0x217c, 0x217d, 0x217e, 0x217f,
+	0x2180, 0x2181, 0x2182, 0x2184, 0x2184, 0x2185, 0x2186, 0x2187,
+	0x2188, 0x2189, 0x218a, 0x218b, 0x218c, 0x218d, 0x218e, 0x218f,
+	0x2190, 0x2191, 0x2192, 0x2193, 0x2194, 0x2195, 0x2196, 0x2197,
+	0x2198, 0x2199, 0x219a, 0x219b, 0x219c, 0x219d, 0x219e, 0x219f,
+	0x21a0, 0x21a1, 0x21a2, 0x21a3, 0x21a4, 0x21a5, 0x21a6, 0x21a7,
+	0x21a8, 0x21a9, 0x21aa, 0x21ab, 0x21ac, 0x21ad, 0x21ae, 0x21af,
+	0x21b0, 0x21b1, 0x21b2, 0x21b3, 0x21b4, 0x21b5, 0x21b6, 0x21b7,
+	0x21b8, 0x21b9, 0x21ba, 0x21bb, 0x21bc, 0x21bd, 0x21be, 0x21bf,
+	0x21c0, 0x21c1, 0x21c2, 0x21c3, 0x21c4, 0x21c5, 0x21c6, 0x21c7,
+	0x21c8, 0x21c9, 0x21ca, 0x21cb, 0x21cc, 0x21cd, 0x21ce, 0x21cf,
+	0x21d0, 0x21d1, 0x21d2, 0x21d3, 0x21d4, 0x21d5, 0x21d6, 0x21d7,
+	0x21d8, 0x21d9, 0x21da, 0x21db, 0x21dc, 0x21dd, 0x21de, 0x21df,
+	0x21e0, 0x21e1, 0x21e2, 0x21e3, 0x21e4, 0x21e5, 0x21e6, 0x21e7,
+	0x21e8, 0x21e9, 0x21ea, 0x21eb, 0x21ec, 0x21ed, 0x21ee, 0x21ef,
+	0x21f0, 0x21f1, 0x21f2, 0x21f3, 0x21f4, 0x21f5, 0x21f6, 0x21f7,
+	0x21f8, 0x21f9, 0x21fa, 0x21fb, 0x21fc, 0x21fd, 0x21fe, 0x21ff,
+
+	/* Characters U+2400 to U+24FF */
+
+	0x2400, 0x2401, 0x2402, 0x2403, 0x2404, 0x2405, 0x2406, 0x2407,
+	0x2408, 0x2409, 0x240a, 0x240b, 0x240c, 0x240d, 0x240e, 0x240f,
+	0x2410, 0x2411, 0x2412, 0x2413, 0x2414, 0x2415, 0x2416, 0x2417,
+	0x2418, 0x2419, 0x241a, 0x241b, 0x241c, 0x241d, 0x241e, 0x241f,
+	0x2420, 0x2421, 0x2422, 0x2423, 0x2424, 0x2425, 0x2426, 0x2427,
+	0x2428, 0x2429, 0x242a, 0x242b, 0x242c, 0x242d, 0x242e, 0x242f,
+	0x2430, 0x2431, 0x2432, 0x2433, 0x2434, 0x2435, 0x2436, 0x2437,
+	0x2438, 0x2439, 0x243a, 0x243b, 0x243c, 0x243d, 0x243e, 0x243f,
+	0x2440, 0x2441, 0x2442, 0x2443, 0x2444, 0x2445, 0x2446, 0x2447,
+	0x2448, 0x2449, 0x244a, 0x244b, 0x244c, 0x244d, 0x244e, 0x244f,
+	0x2450, 0x2451, 0x2452, 0x2453, 0x2454, 0x2455, 0x2456, 0x2457,
+	0x2458, 0x2459, 0x245a, 0x245b, 0x245c, 0x245d, 0x245e, 0x245f,
+	0x2460, 0x2461, 0x2462, 0x2463, 0x2464, 0x2465, 0x2466, 0x2467,
+	0x2468, 0x2469, 0x246a, 0x246b, 0x246c, 0x246d, 0x246e, 0x246f,
+	0x2470, 0x2471, 0x2472, 0x2473, 0x2474, 0x2475, 0x2476, 0x2477,
+	0x2478, 0x2479, 0x247a, 0x247b, 0x247c, 0x247d, 0x247e, 0x247f,
+	0x2480, 0x2481, 0x2482, 0x2483, 0x2484, 0x2485, 0x2486, 0x2487,
+	0x2488, 0x2489, 0x248a, 0x248b, 0x248c, 0x248d, 0x248e, 0x248f,
+	0x2490, 0x2491, 0x2492, 0x2493, 0x2494, 0x2495, 0x2496, 0x2497,
+	0x2498, 0x2499, 0x249a, 0x249b, 0x249c, 0x249d, 0x249e, 0x249f,
+	0x24a0, 0x24a1, 0x24a2, 0x24a3, 0x24a4, 0x24a5, 0x24a6, 0x24a7,
+	0x24a8, 0x24a9, 0x24aa, 0x24ab, 0x24ac, 0x24ad, 0x24ae, 0x24af,
+	0x24b0, 0x24b1, 0x24b2, 0x24b3, 0x24b4, 0x24b5, 0x24d0, 0x24d1,
+	0x24d2, 0x24d3, 0x24d4, 0x24d5, 0x24d6, 0x24d7, 0x24d8, 0x24d9,
+	0x24da, 0x24db, 0x24dc, 0x24dd, 0x24de, 0x24df, 0x24e0, 0x24e1,
+	0x24e2, 0x24e3, 0x24e4, 0x24e5, 0x24e6, 0x24e7, 0x24e8, 0x24e9,
+	0x24d0, 0x24d1, 0x24d2, 0x24d3, 0x24d4, 0x24d5, 0x24d6, 0x24d7,
+	0x24d8, 0x24d9, 0x24da, 0x24db, 0x24dc, 0x24dd, 0x24de, 0x24df,
+	0x24e0, 0x24e1, 0x24e2, 0x24e3, 0x24e4, 0x24e5, 0x24e6, 0x24e7,
+	0x24e8, 0x24e9, 0x24ea, 0x24eb, 0x24ec, 0x24ed, 0x24ee, 0x24ef,
+	0x24f0, 0x24f1, 0x24f2, 0x24f3, 0x24f4, 0x24f5, 0x24f6, 0x24f7,
+	0x24f8, 0x24f9, 0x24fa, 0x24fb, 0x24fc, 0x24fd, 0x24fe, 0x24ff,
+
+	/* Characters U+2C00 to U+2CFF */
+
+	0x2c30, 0x2c31, 0x2c32, 0x2c33, 0x2c34, 0x2c35, 0x2c36, 0x2c37,
+	0x2c38, 0x2c39, 0x2c3a, 0x2c3b, 0x2c3c, 0x2c3d, 0x2c3e, 0x2c3f,
+	0x2c40, 0x2c41, 0x2c42, 0x2c43, 0x2c44, 0x2c45, 0x2c46, 0x2c47,
+	0x2c48, 0x2c49, 0x2c4a, 0x2c4b, 0x2c4c, 0x2c4d, 0x2c4e, 0x2c4f,
+	0x2c50, 0x2c51, 0x2c52, 0x2c53, 0x2c54, 0x2c55, 0x2c56, 0x2c57,
+	0x2c58, 0x2c59, 0x2c5a, 0x2c5b, 0x2c5c, 0x2c5d, 0x2c5e, 0x2c2f,
+	0x2c30, 0x2c31, 0x2c32, 0x2c33, 0x2c34, 0x2c35, 0x2c36, 0x2c37,
+	0x2c38, 0x2c39, 0x2c3a, 0x2c3b, 0x2c3c, 0x2c3d, 0x2c3e, 0x2c3f,
+	0x2c40, 0x2c41, 0x2c42, 0x2c43, 0x2c44, 0x2c45, 0x2c46, 0x2c47,
+	0x2c48, 0x2c49, 0x2c4a, 0x2c4b, 0x2c4c, 0x2c4d, 0x2c4e, 0x2c4f,
+	0x2c50, 0x2c51, 0x2c52, 0x2c53, 0x2c54, 0x2c55, 0x2c56, 0x2c57,
+	0x2c58, 0x2c59, 0x2c5a, 0x2c5b, 0x2c5c, 0x2c5d, 0x2c5e, 0x2c5f,
+	0x2c61, 0x2c61, 0x026b, 0x1d7d, 0x027d, 0x2c65, 0x2c66, 0x2c68,
+	0x2c68, 0x2c6a, 0x2c6a, 0x2c6c, 0x2c6c, 0x2c6d, 0x2c6e, 0x2c6f,
+	0x2c70, 0x2c71, 0x2c72, 0x2c73, 0x2c74, 0x2c76, 0x2c76, 0x2c77,
+	0x2c78, 0x2c79, 0x2c7a, 0x2c7b, 0x2c7c, 0x2c7d, 0x2c7e, 0x2c7f,
+	0x2c81, 0x2c81, 0x2c83, 0x2c83, 0x2c85, 0x2c85, 0x2c87, 0x2c87,
+	0x2c89, 0x2c89, 0x2c8b, 0x2c8b, 0x2c8d, 0x2c8d, 0x2c8f, 0x2c8f,
+	0x2c91, 0x2c91, 0x2c93, 0x2c93, 0x2c95, 0x2c95, 0x2c97, 0x2c97,
+	0x2c99, 0x2c99, 0x2c9b, 0x2c9b, 0x2c9d, 0x2c9d, 0x2c9f, 0x2c9f,
+	0x2ca1, 0x2ca1, 0x2ca3, 0x2ca3, 0x2ca5, 0x2ca5, 0x2ca7, 0x2ca7,
+	0x2ca9, 0x2ca9, 0x2cab, 0x2cab, 0x2cad, 0x2cad, 0x2caf, 0x2caf,
+	0x2cb1, 0x2cb1, 0x2cb3, 0x2cb3, 0x2cb5, 0x2cb5, 0x2cb7, 0x2cb7,
+	0x2cb9, 0x2cb9, 0x2cbb, 0x2cbb, 0x2cbd, 0x2cbd, 0x2cbf, 0x2cbf,
+	0x2cc1, 0x2cc1, 0x2cc3, 0x2cc3, 0x2cc5, 0x2cc5, 0x2cc7, 0x2cc7,
+	0x2cc9, 0x2cc9, 0x2ccb, 0x2ccb, 0x2ccd, 0x2ccd, 0x2ccf, 0x2ccf,
+	0x2cd1, 0x2cd1, 0x2cd3, 0x2cd3, 0x2cd5, 0x2cd5, 0x2cd7, 0x2cd7,
+	0x2cd9, 0x2cd9, 0x2cdb, 0x2cdb, 0x2cdd, 0x2cdd, 0x2cdf, 0x2cdf,
+	0x2ce1, 0x2ce1, 0x2ce3, 0x2ce3, 0x2ce4, 0x2ce5, 0x2ce6, 0x2ce7,
+	0x2ce8, 0x2ce9, 0x2cea, 0x2ceb, 0x2cec, 0x2ced, 0x2cee, 0x2cef,
+	0x2cf0, 0x2cf1, 0x2cf2, 0x2cf3, 0x2cf4, 0x2cf5, 0x2cf6, 0x2cf7,
+	0x2cf8, 0x2cf9, 0x2cfa, 0x2cfb, 0x2cfc, 0x2cfd, 0x2cfe, 0x2cff,
+
+	/* Characters U+FB00 to U+FBFF */
+
+	0xe04d, 0xe04e, 0xe04f, 0xe40e, 0xe40f, 0xe050, 0xe051, 0xfb07,
+	0xfb08, 0xfb09, 0xfb0a, 0xfb0b, 0xfb0c, 0xfb0d, 0xfb0e, 0xfb0f,
+	0xfb10, 0xfb11, 0xfb12, 0xe052, 0xe053, 0xe054, 0xe055, 0xe056,
+	0xfb18, 0xfb19, 0xfb1a, 0xfb1b, 0xfb1c, 0xfb1d, 0xfb1e, 0xfb1f,
+	0xfb20, 0xfb21, 0xfb22, 0xfb23, 0xfb24, 0xfb25, 0xfb26, 0xfb27,
+	0xfb28, 0xfb29, 0xfb2a, 0xfb2b, 0xfb2c, 0xfb2d, 0xfb2e, 0xfb2f,
+	0xfb30, 0xfb31, 0xfb32, 0xfb33, 0xfb34, 0xfb35, 0xfb36, 0xfb37,
+	0xfb38, 0xfb39, 0xfb3a, 0xfb3b, 0xfb3c, 0xfb3d, 0xfb3e, 0xfb3f,
+	0xfb40, 0xfb41, 0xfb42, 0xfb43, 0xfb44, 0xfb45, 0xfb46, 0xfb47,
+	0xfb48, 0xfb49, 0xfb4a, 0xfb4b, 0xfb4c, 0xfb4d, 0xfb4e, 0xfb4f,
+	0xfb50, 0xfb51, 0xfb52, 0xfb53, 0xfb54, 0xfb55, 0xfb56, 0xfb57,
+	0xfb58, 0xfb59, 0xfb5a, 0xfb5b, 0xfb5c, 0xfb5d, 0xfb5e, 0xfb5f,
+	0xfb60, 0xfb61, 0xfb62, 0xfb63, 0xfb64, 0xfb65, 0xfb66, 0xfb67,
+	0xfb68, 0xfb69, 0xfb6a, 0xfb6b, 0xfb6c, 0xfb6d, 0xfb6e, 0xfb6f,
+	0xfb70, 0xfb71, 0xfb72, 0xfb73, 0xfb74, 0xfb75, 0xfb76, 0xfb77,
+	0xfb78, 0xfb79, 0xfb7a, 0xfb7b, 0xfb7c, 0xfb7d, 0xfb7e, 0xfb7f,
+	0xfb80, 0xfb81, 0xfb82, 0xfb83, 0xfb84, 0xfb85, 0xfb86, 0xfb87,
+	0xfb88, 0xfb89, 0xfb8a, 0xfb8b, 0xfb8c, 0xfb8d, 0xfb8e, 0xfb8f,
+	0xfb90, 0xfb91, 0xfb92, 0xfb93, 0xfb94, 0xfb95, 0xfb96, 0xfb97,
+	0xfb98, 0xfb99, 0xfb9a, 0xfb9b, 0xfb9c, 0xfb9d, 0xfb9e, 0xfb9f,
+	0xfba0, 0xfba1, 0xfba2, 0xfba3, 0xfba4, 0xfba5, 0xfba6, 0xfba7,
+	0xfba8, 0xfba9, 0xfbaa, 0xfbab, 0xfbac, 0xfbad, 0xfbae, 0xfbaf,
+	0xfbb0, 0xfbb1, 0xfbb2, 0xfbb3, 0xfbb4, 0xfbb5, 0xfbb6, 0xfbb7,
+	0xfbb8, 0xfbb9, 0xfbba, 0xfbbb, 0xfbbc, 0xfbbd, 0xfbbe, 0xfbbf,
+	0xfbc0, 0xfbc1, 0xfbc2, 0xfbc3, 0xfbc4, 0xfbc5, 0xfbc6, 0xfbc7,
+	0xfbc8, 0xfbc9, 0xfbca, 0xfbcb, 0xfbcc, 0xfbcd, 0xfbce, 0xfbcf,
+	0xfbd0, 0xfbd1, 0xfbd2, 0xfbd3, 0xfbd4, 0xfbd5, 0xfbd6, 0xfbd7,
+	0xfbd8, 0xfbd9, 0xfbda, 0xfbdb, 0xfbdc, 0xfbdd, 0xfbde, 0xfbdf,
+	0xfbe0, 0xfbe1, 0xfbe2, 0xfbe3, 0xfbe4, 0xfbe5, 0xfbe6, 0xfbe7,
+	0xfbe8, 0xfbe9, 0xfbea, 0xfbeb, 0xfbec, 0xfbed, 0xfbee, 0xfbef,
+	0xfbf0, 0xfbf1, 0xfbf2, 0xfbf3, 0xfbf4, 0xfbf5, 0xfbf6, 0xfbf7,
+	0xfbf8, 0xfbf9, 0xfbfa, 0xfbfb, 0xfbfc, 0xfbfd, 0xfbfe, 0xfbff,
+
+	/* Characters U+FF00 to U+FFFF */
+
+	0xff00, 0xff01, 0xff02, 0xff03, 0xff04, 0xff05, 0xff06, 0xff07,
+	0xff08, 0xff09, 0xff0a, 0xff0b, 0xff0c, 0xff0d, 0xff0e, 0xff0f,
+	0xff10, 0xff11, 0xff12, 0xff13, 0xff14, 0xff15, 0xff16, 0xff17,
+	0xff18, 0xff19, 0xff1a, 0xff1b, 0xff1c, 0xff1d, 0xff1e, 0xff1f,
+	0xff20, 0xff41, 0xff42, 0xff43, 0xff44, 0xff45, 0xff46, 0xff47,
+	0xff48, 0xff49, 0xff4a, 0xff4b, 0xff4c, 0xff4d, 0xff4e, 0xff4f,
+	0xff50, 0xff51, 0xff52, 0xff53, 0xff54, 0xff55, 0xff56, 0xff57,
+	0xff58, 0xff59, 0xff5a, 0xff3b, 0xff3c, 0xff3d, 0xff3e, 0xff3f,
+	0xff40, 0xff41, 0xff42, 0xff43, 0xff44, 0xff45, 0xff46, 0xff47,
+	0xff48, 0xff49, 0xff4a, 0xff4b, 0xff4c, 0xff4d, 0xff4e, 0xff4f,
+	0xff50, 0xff51, 0xff52, 0xff53, 0xff54, 0xff55, 0xff56, 0xff57,
+	0xff58, 0xff59, 0xff5a, 0xff5b, 0xff5c, 0xff5d, 0xff5e, 0xff5f,
+	0xff60, 0xff61, 0xff62, 0xff63, 0xff64, 0xff65, 0xff66, 0xff67,
+	0xff68, 0xff69, 0xff6a, 0xff6b, 0xff6c, 0xff6d, 0xff6e, 0xff6f,
+	0xff70, 0xff71, 0xff72, 0xff73, 0xff74, 0xff75, 0xff76, 0xff77,
+	0xff78, 0xff79, 0xff7a, 0xff7b, 0xff7c, 0xff7d, 0xff7e, 0xff7f,
+	0xff80, 0xff81, 0xff82, 0xff83, 0xff84, 0xff85, 0xff86, 0xff87,
+	0xff88, 0xff89, 0xff8a, 0xff8b, 0xff8c, 0xff8d, 0xff8e, 0xff8f,
+	0xff90, 0xff91, 0xff92, 0xff93, 0xff94, 0xff95, 0xff96, 0xff97,
+	0xff98, 0xff99, 0xff9a, 0xff9b, 0xff9c, 0xff9d, 0xff9e, 0xff9f,
+	0xffa0, 0xffa1, 0xffa2, 0xffa3, 0xffa4, 0xffa5, 0xffa6, 0xffa7,
+	0xffa8, 0xffa9, 0xffaa, 0xffab, 0xffac, 0xffad, 0xffae, 0xffaf,
+	0xffb0, 0xffb1, 0xffb2, 0xffb3, 0xffb4, 0xffb5, 0xffb6, 0xffb7,
+	0xffb8, 0xffb9, 0xffba, 0xffbb, 0xffbc, 0xffbd, 0xffbe, 0xffbf,
+	0xffc0, 0xffc1, 0xffc2, 0xffc3, 0xffc4, 0xffc5, 0xffc6, 0xffc7,
+	0xffc8, 0xffc9, 0xffca, 0xffcb, 0xffcc, 0xffcd, 0xffce, 0xffcf,
+	0xffd0, 0xffd1, 0xffd2, 0xffd3, 0xffd4, 0xffd5, 0xffd6, 0xffd7,
+	0xffd8, 0xffd9, 0xffda, 0xffdb, 0xffdc, 0xffdd, 0xffde, 0xffdf,
+	0xffe0, 0xffe1, 0xffe2, 0xffe3, 0xffe4, 0xffe5, 0xffe6, 0xffe7,
+	0xffe8, 0xffe9, 0xffea, 0xffeb, 0xffec, 0xffed, 0xffee, 0xffef,
+	0xfff0, 0xfff1, 0xfff2, 0xfff3, 0xfff4, 0xfff5, 0xfff6, 0xfff7,
+	0xfff8, 0xfff9, 0xfffa, 0xfffb, 0xfffc, 0xfffd, 0xfffe, 0xffff,
+};
+
+__uint16_t xfs_case_fold_double_table[87][2] =3D {
+	/* U+00DF */ {0x0073, 0x0073}, /* U+0130 */ {0x0069, 0x0307},
+	/* U+0149 */ {0x02bc, 0x006e}, /* U+01F0 */ {0x006a, 0x030c},
+	/* U+0587 */ {0x0565, 0x0582}, /* U+1E96 */ {0x0068, 0x0331},
+	/* U+1E97 */ {0x0074, 0x0308}, /* U+1E98 */ {0x0077, 0x030a},
+	/* U+1E99 */ {0x0079, 0x030a}, /* U+1E9A */ {0x0061, 0x02be},
+	/* U+1F50 */ {0x03c5, 0x0313}, /* U+1F80 */ {0x1f00, 0x03b9},
+	/* U+1F81 */ {0x1f01, 0x03b9}, /* U+1F82 */ {0x1f02, 0x03b9},
+	/* U+1F83 */ {0x1f03, 0x03b9}, /* U+1F84 */ {0x1f04, 0x03b9},
+	/* U+1F85 */ {0x1f05, 0x03b9}, /* U+1F86 */ {0x1f06, 0x03b9},
+	/* U+1F87 */ {0x1f07, 0x03b9}, /* U+1F88 */ {0x1f00, 0x03b9},
+	/* U+1F89 */ {0x1f01, 0x03b9}, /* U+1F8A */ {0x1f02, 0x03b9},
+	/* U+1F8B */ {0x1f03, 0x03b9}, /* U+1F8C */ {0x1f04, 0x03b9},
+	/* U+1F8D */ {0x1f05, 0x03b9}, /* U+1F8E */ {0x1f06, 0x03b9},
+	/* U+1F8F */ {0x1f07, 0x03b9}, /* U+1F90 */ {0x1f20, 0x03b9},
+	/* U+1F91 */ {0x1f21, 0x03b9}, /* U+1F92 */ {0x1f22, 0x03b9},
+	/* U+1F93 */ {0x1f23, 0x03b9}, /* U+1F94 */ {0x1f24, 0x03b9},
+	/* U+1F95 */ {0x1f25, 0x03b9}, /* U+1F96 */ {0x1f26, 0x03b9},
+	/* U+1F97 */ {0x1f27, 0x03b9}, /* U+1F98 */ {0x1f20, 0x03b9},
+	/* U+1F99 */ {0x1f21, 0x03b9}, /* U+1F9A */ {0x1f22, 0x03b9},
+	/* U+1F9B */ {0x1f23, 0x03b9}, /* U+1F9C */ {0x1f24, 0x03b9},
+	/* U+1F9D */ {0x1f25, 0x03b9}, /* U+1F9E */ {0x1f26, 0x03b9},
+	/* U+1F9F */ {0x1f27, 0x03b9}, /* U+1FA0 */ {0x1f60, 0x03b9},
+	/* U+1FA1 */ {0x1f61, 0x03b9}, /* U+1FA2 */ {0x1f62, 0x03b9},
+	/* U+1FA3 */ {0x1f63, 0x03b9}, /* U+1FA4 */ {0x1f64, 0x03b9},
+	/* U+1FA5 */ {0x1f65, 0x03b9}, /* U+1FA6 */ {0x1f66, 0x03b9},
+	/* U+1FA7 */ {0x1f67, 0x03b9}, /* U+1FA8 */ {0x1f60, 0x03b9},
+	/* U+1FA9 */ {0x1f61, 0x03b9}, /* U+1FAA */ {0x1f62, 0x03b9},
+	/* U+1FAB */ {0x1f63, 0x03b9}, /* U+1FAC */ {0x1f64, 0x03b9},
+	/* U+1FAD */ {0x1f65, 0x03b9}, /* U+1FAE */ {0x1f66, 0x03b9},
+	/* U+1FAF */ {0x1f67, 0x03b9}, /* U+1FB2 */ {0x1f70, 0x03b9},
+	/* U+1FB3 */ {0x03b1, 0x03b9}, /* U+1FB4 */ {0x03ac, 0x03b9},
+	/* U+1FB6 */ {0x03b1, 0x0342}, /* U+1FBC */ {0x03b1, 0x03b9},
+	/* U+1FC2 */ {0x1f74, 0x03b9}, /* U+1FC3 */ {0x03b7, 0x03b9},
+	/* U+1FC4 */ {0x03ae, 0x03b9}, /* U+1FC6 */ {0x03b7, 0x0342},
+	/* U+1FCC */ {0x03b7, 0x03b9}, /* U+1FD6 */ {0x03b9, 0x0342},
+	/* U+1FE4 */ {0x03c1, 0x0313}, /* U+1FE6 */ {0x03c5, 0x0342},
+	/* U+1FF2 */ {0x1f7c, 0x03b9}, /* U+1FF3 */ {0x03c9, 0x03b9},
+	/* U+1FF4 */ {0x03ce, 0x03b9}, /* U+1FF6 */ {0x03c9, 0x0342},
+	/* U+1FFC */ {0x03c9, 0x03b9}, /* U+FB00 */ {0x0066, 0x0066},
+	/* U+FB01 */ {0x0066, 0x0069}, /* U+FB02 */ {0x0066, 0x006c},
+	/* U+FB05 */ {0x0073, 0x0074}, /* U+FB06 */ {0x0073, 0x0074},
+	/* U+FB13 */ {0x0574, 0x0576}, /* U+FB14 */ {0x0574, 0x0565},
+	/* U+FB15 */ {0x0574, 0x056b}, /* U+FB16 */ {0x057e, 0x0576},
+	/* U+FB17 */ {0x0574, 0x056d},
+};
+
+__uint16_t xfs_case_fold_triple_table[16][3] =3D {
+	/* U+0390 */ {0x03b9, 0x0308, 0x0301},
+	/* U+03B0 */ {0x03c5, 0x0308, 0x0301},
+	/* U+1F52 */ {0x03c5, 0x0313, 0x0300},
+	/* U+1F54 */ {0x03c5, 0x0313, 0x0301},
+	/* U+1F56 */ {0x03c5, 0x0313, 0x0342},
+	/* U+1FB7 */ {0x03b1, 0x0342, 0x03b9},
+	/* U+1FC7 */ {0x03b7, 0x0342, 0x03b9},
+	/* U+1FD2 */ {0x03b9, 0x0308, 0x0300},
+	/* U+1FD3 */ {0x03b9, 0x0308, 0x0301},
+	/* U+1FD7 */ {0x03b9, 0x0308, 0x0342},
+	/* U+1FE2 */ {0x03c5, 0x0308, 0x0300},
+	/* U+1FE3 */ {0x03c5, 0x0308, 0x0301},
+	/* U+1FE7 */ {0x03c5, 0x0308, 0x0342},
+	/* U+1FF7 */ {0x03c9, 0x0342, 0x03b9},
+	/* U+FB03 */ {0x0066, 0x0066, 0x0069},
+	/* U+FB04 */ {0x0066, 0x0066, 0x006c},
+};
+
+static __uint16_t xfs_case_fold_turkic_adjust[2][2] =3D {
+	{0x0049, 0x0131}, {0x0130, 0x0069},
+};
+
+#define NUM_CFT		3
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
+int
+libxfs_create_casefoldtable(
+	xfs_mount_t		*mp,
+	int			isturkic)
+{
+	int			i;
+	xfs_dcft_t 		*table;
+	int			table_size;
+	__be16			*cfc;
+	xfs_trans_t		*tp;
+	xfs_inode_t		*cftip;
+	struct cred		creds;
+	struct fsxattr		fsxattrs;
+	xfs_dfiloff_t		bno;
+	int			committed;
+	xfs_bmbt_irec_t		*ep;
+	int			error;
+	xfs_fsblock_t		first;
+	xfs_bmap_free_t		flist;
+	xfs_bmbt_irec_t		map[XFS_BMAP_MAX_NMAP];
+	xfs_extlen_t		nblocks;
+	int			nmap;
+	char			*p;
+	xfs_buf_t		*bp;
+
+	if (!xfs_sb_version_hasunicode(&mp->m_sb))
+		return 0;
+
+	/*
+	 * setup on-disk table in a memory buffer
+	 */
+	table_size =3D sizeof(xfs_dcft_t) + sizeof(__be32) * (NUM_CFT - 1) +
+			sizeof(xfs_case_fold_table) +
+			sizeof(xfs_case_fold_double_table) +
+			sizeof(xfs_case_fold_triple_table);
+	nblocks =3D XFS_B_TO_FSB(mp, table_size);
+	table =3D calloc(1, XFS_FSB_TO_B(mp, nblocks));
+	table->cft_magic =3D cpu_to_be32(XFS_CFT_MAGIC);
+	platform_uuid_copy(&table->cft_uuid, &mp->m_sb.sb_uuid);
+	table->cft_num_tables =3D cpu_to_be32(NUM_CFT);
+	table->cft_table_offset[0] =3D cpu_to_be32(sizeof(xfs_dcft_t) +
+					sizeof(__be32) * (NUM_CFT - 1));
+	table->cft_table_offset[1] =3D cpu_to_be32(sizeof(xfs_dcft_t) +
+					sizeof(__be32) * (NUM_CFT - 1) +
+					sizeof(xfs_case_fold_table));
+	table->cft_table_offset[2] =3D cpu_to_be32(sizeof(xfs_dcft_t) +
+					sizeof(__be32) * (NUM_CFT - 1) +
+					sizeof(xfs_case_fold_table) +
+					sizeof(xfs_case_fold_double_table));
+	/* if user wants turkic case folding, adjust table first */
+	if (isturkic) {
+		table->cft_flags |=3D cpu_to_be32(XFS_CFT_FLAG_TURKIC);
+		for (i =3D 0; i < ARRAY_SIZE(xfs_case_fold_turkic_adjust); i++) {
+			__uint16_t tmp =3D xfs_case_fold_table[
+					xfs_case_fold_turkic_adjust[i][0] >> 8];
+			xfs_case_fold_table[tmp +
+				(xfs_case_fold_turkic_adjust[i][0] & 0xff)] =3D
+					xfs_case_fold_turkic_adjust[i][1];
+		}
+	}
+	cfc =3D XFS_DCFT_PTR(table, 0);
+	for (i =3D 0; i < ARRAY_SIZE(xfs_case_fold_table); i++)
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_table[i]);
+	ASSERT(cfc =3D=3D XFS_DCFT_PTR(table, 1));
+	for (i =3D 0; i < ARRAY_SIZE(xfs_case_fold_double_table); i++) {
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_double_table[i][0]);
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_double_table[i][1]);
+	}
+	ASSERT(cfc =3D=3D XFS_DCFT_PTR(table, 2));
+	for (i =3D 0; i < ARRAY_SIZE(xfs_case_fold_triple_table); i++) {
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_triple_table[i][0]);
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_triple_table[i][1]);
+		*cfc++ =3D cpu_to_be16(xfs_case_fold_triple_table[i][2]);
+	}
+
+	/*
+	 * allocate the inode
+	 */
+	tp =3D libxfs_trans_alloc(mp, 0);
+	error =3D  libxfs_trans_reserve(tp, XFS_CREATE_LOG_RES(mp), 0, 0, 0, 0=
);
+	if (error) {
+		fprintf(stderr, _("%s: cannot reserve space: %s\n"),
+			progname, strerror(error));
+		exit(1);
+	}
+	bzero(&creds, sizeof(creds));
+	bzero(&fsxattrs, sizeof(fsxattrs));
+	error =3D libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+					&creds, &fsxattrs, &cftip);
+	if (error)
+		goto err_out;
+	mp->m_sb.sb_cftino =3D cftip->i_ino;
+	cftip->i_d.di_size =3D table_size;
+	libxfs_trans_log_inode(tp, cftip, XFS_ILOG_CORE);
+	libxfs_mod_sb(tp, XFS_SB_CFTINO);
+	libxfs_trans_ihold(tp, cftip);
+	libxfs_trans_commit(tp, 0, NULL);
+
+	/*
+	 * write case table to inode
+	 */
+	tp =3D libxfs_trans_alloc(mp, 0);
+	error =3D libxfs_trans_reserve(tp,
+			nblocks + (XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1),
+			0, 0, 0, 0);
+	if (error) {
+		fprintf(stderr, _("%s: cannot reserve space: %s\n"),
+			progname, strerror(error));
+		exit(1);
+	}
+	libxfs_trans_ijoin(tp, cftip, 0);
+	bno =3D 0;
+	p =3D (char *)table;
+	XFS_BMAP_INIT(&flist, &first);
+	while (bno < nblocks) {
+		nmap =3D XFS_BMAP_MAX_NMAP;
+		error =3D libxfs_bmapi(tp, cftip, bno,
+				(xfs_extlen_t)(nblocks - bno),
+				XFS_BMAPI_WRITE, &first, nblocks,
+				map, &nmap, &flist);
+		if (error)
+			goto err_out;
+		for (i =3D 0, ep =3D map; i < nmap; i++, ep++) {
+			bp =3D libxfs_getbuf(mp->m_dev,
+					XFS_FSB_TO_DADDR(mp, ep->br_startblock),
+					XFS_FSB_TO_BB(mp, ep->br_blockcount));
+			memcpy(XFS_BUF_PTR(bp), p, XFS_BUF_SIZE(bp));
+			libxfs_writebuf(bp, 0);
+			bno +=3D ep->br_blockcount;
+			p +=3D XFS_BUF_SIZE(bp);
+		}
+	}
+	error =3D libxfs_bmap_finish(&tp, &flist, first, &committed);
+	if (error)
+		goto err_out;
+	libxfs_trans_commit(tp, 0, NULL);
+	free(table);
+	return 0;
+
+err_out:
+	libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+	free(table);
+	return error;
+}
Index: ci/xfsprogs/libxfs/xfs_mount.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_mount.c	2008-01-18 14:50:42.000000000 +1=
100
+++ ci/xfsprogs/libxfs/xfs_mount.c	2008-01-18 15:00:08.836596146 +1100
@@ -140,6 +140,8 @@
     { offsetof(xfs_sb_t, sb_logsectsize),0 },
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
+    { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_cftino),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 =

Index: ci/xfsprogs/mkfs/proto.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/proto.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/mkfs/proto.c	2008-01-18 15:00:08.912586396 +1100
@@ -18,6 +18,7 @@
 =

 #include <xfs/libxfs.h>
 #include <sys/stat.h>
+#include <casefoldtable.h>
 #include "xfs_mkfs.h"
 =

 /*
@@ -32,6 +33,7 @@
 	xfs_fsblock_t *first, int dolocal, int logit, char *buf, int len);
 static char *newregfile(char **pp, int *len);
 static void rtinit(xfs_mount_t *mp);
+static void cftinit(xfs_mount_t *mp);
 static long filesize(int fd);
 =

 /*
@@ -570,11 +572,13 @@
 		libxfs_trans_ihold(tp, ip);
 		libxfs_trans_commit(tp, 0, NULL);
 		/*
-		 * RT initialization.  Do this here to ensure that
-		 * the RT inodes get placed after the root inode.
+		 * RT & CFT initialization.  Do this here to ensure that
+		 * the RT & CFT inodes get placed after the root inode.
 		 */
-		if (isroot)
+		if (isroot) {
 			rtinit(mp);
+			cftinit(mp);
+		}
 		tp =3D NULL;
 		for (;;) {
 			name =3D getstr(pp);
@@ -762,6 +766,20 @@
 	}
 }
 =

+/*
+ * Allocate unicode case folding table
+ */
+
+static void
+cftinit(
+	xfs_mount_t		*mp)
+{
+	int	error =3D libxfs_create_casefoldtable(mp,
+				mp->m_flags & LIBXFS_MOUNT_FLAG_TURKIC_CASE);
+	if (error)
+		fail(_("Creating the case folding table failed"), error);
+}
+
 static long
 filesize(
 	int		fd)
Index: ci/xfsprogs/mkfs/xfs_mkfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/mkfs/xfs_mkfs.c	2008-01-18 15:00:08.916585883 +1100
@@ -128,6 +128,8 @@
 	"size",
 #define	N_VERSION	2
 	"version",
+#define N_UTF8		3
+	"utf8",
 	NULL,
 };
 =

@@ -635,7 +637,6 @@
 	char			*dfile;
 	int			dirblocklog;
 	int			dirblocksize;
-	int			dirversion;
 	char			*dsize;
 	int			dsu;
 	int			dsw;
@@ -683,6 +684,8 @@
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
 	int			nvflag;
+	int			nci;
+	int			nutf8;
 	int			Nflag;
 	char			*p;
 	char			*protofile;
@@ -707,12 +710,20 @@
 	int 			xlv_dsunit;
 	int			xlv_dswidth;
 	int			lazy_sb_counters;
+	char			*locale;
+	int			isturkiclocale;
+
 =

 	progname =3D basename(argv[0]);
-	setlocale(LC_ALL, "");
+	locale =3D setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 =

+	isturkiclocale =3D strncasecmp(locale, "az_", 3) =3D=3D 0 ||
+			strncasecmp(locale, "aze_", 4) =3D=3D 0 ||
+			strncasecmp(locale, "tr_", 3) =3D=3D 0 ||
+			strncasecmp(locale, "tur_", 4) =3D=3D 0;
+
 	attrversion =3D 2;
 	blflag =3D bsflag =3D slflag =3D ssflag =3D lslflag =3D lssflag =3D 0;=

 	blocklog =3D blocksize =3D 0;
@@ -724,8 +735,8 @@
 	loginternal =3D 1;
 	logversion =3D 2;
 	logagno =3D logblocks =3D rtblocks =3D rtextblocks =3D 0;
-	Nflag =3D nlflag =3D nsflag =3D nvflag =3D 0;
-	dirblocklog =3D dirblocksize =3D dirversion =3D 0;
+	Nflag =3D nlflag =3D nsflag =3D nvflag =3D nci =3D nutf8 =3D 0;
+	dirblocklog =3D dirblocksize =3D 0;
 	qflag =3D 0;
 	imaxpct =3D inodelog =3D inopblock =3D isize =3D 0;
 	iaflag =3D XFS_IFLAG_ALIGN;
@@ -1240,11 +1251,27 @@
 						reqval('n', nopts, N_VERSION);
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
-					dirversion =3D atoi(value);
-					if (dirversion < 1 || dirversion > 2)
-						illegal(value, "n version");
+					if (!strcmp(value, "ci")) {
+						nci =3D 1; /* old-style CI mode */
+					} else {
+						if (atoi(value) !=3D XFS_DFL_DIR_VERSION)
+							illegal(value,
+								"n version");
+					}
 					nvflag =3D 1;
 					break;
+				case N_UTF8:
+					if (value) {
+						if (!strcmp(value, "turkic"))
+							nutf8 =3D 2;
+						else
+						if (!strcmp(value, "default"))
+							nutf8 =3D 1;
+						else
+							illegal(value, "n utf8");
+					} else
+						nutf8 =3D isturkiclocale ? 2 : 1;
+					break;
 				default:
 					unknown('n', value);
 				}
@@ -1416,33 +1443,24 @@
 		logversion =3D 2;
 	}
 =

-	if (!nvflag)
-		dirversion =3D (nsflag || nlflag) ? 2 : XFS_DFL_DIR_VERSION;
-	switch (dirversion) {
-	case 1:
-		if ((nsflag || nlflag) && dirblocklog !=3D blocklog) {
+	if (nsflag || nlflag) {
+		if (dirblocksize < blocksize ||
+		    dirblocksize > XFS_MAX_BLOCKSIZE) {
 			fprintf(stderr, _("illegal directory block size %d\n"),
 				dirblocksize);
 			usage();
 		}
-		break;
-	case 2:
-		if (nsflag || nlflag) {
-			if (dirblocksize < blocksize ||
-			    dirblocksize > XFS_MAX_BLOCKSIZE) {
-				fprintf(stderr,
-					_("illegal directory block size %d\n"),
-					dirblocksize);
-				usage();
-			}
-		} else {
-			if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
-				dirblocklog =3D XFS_MIN_REC_DIRSIZE;
-			else
-				dirblocklog =3D blocklog;
-			dirblocksize =3D 1 << dirblocklog;
-		}
-		break;
+	} else {
+		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
+			dirblocklog =3D XFS_MIN_REC_DIRSIZE;
+		else
+			dirblocklog =3D blocklog;
+		dirblocksize =3D 1 << dirblocklog;
+	}
+	if (nci && nutf8) {
+		fprintf(stderr,
+	_("both -n version=3Dci and utf8=3D specified, use one or the other\n"=
));
+		usage();
 	}
 =

 	if (daflag && dasize) {
@@ -1717,7 +1735,7 @@
 			sectorsize, xi.rtbsize);
 	}
 =

-	max_tr_res =3D max_trans_res(dirversion,
+	max_tr_res =3D max_trans_res(XFS_DFL_DIR_VERSION,
 				   sectorlog, blocklog, inodelog, dirblocklog);
 	ASSERT(max_tr_res);
 	min_logblocks =3D max_tr_res * XFS_MIN_LOG_FACTOR;
@@ -2022,7 +2040,7 @@
 		   "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
 		   "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
 		   "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-		   "naming   =3Dversion %-14u bsize=3D%-6u\n"
+		   "naming   =3Dversion %-14s bsize=3D%-6u utf8=3D%s\n"
 		   "log      =3D%-22s bsize=3D%-6d blocks=3D%lld, version=3D%d\n"
 		   "         =3D%-22s sectsz=3D%-5u sunit=3D%d blks, lazy-count=3D%d\=
n"
 		   "realtime =3D%-22s extsz=3D%-6d blocks=3D%lld, rtextents=3D%lld\n"=
),
@@ -2031,7 +2049,8 @@
 			"", blocksize, (long long)dblocks,
 			       calc_default_imaxpct(blocklog, dblocks),
 			"", dsunit, dswidth,
-			dirversion, dirversion =3D=3D 1 ? blocksize : dirblocksize,
+			nci ? "ci" : "2" /*dirversion*/, dirblocksize,
+			nutf8 =3D=3D 0 ? "none" : nutf8 =3D=3D 2 ? "turkic" : "default",
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -2076,8 +2095,7 @@
 	sbp->sb_qflags =3D 0;
 	sbp->sb_unit =3D dsunit;
 	sbp->sb_width =3D dswidth;
-	if (dirversion =3D=3D 2)
-		sbp->sb_dirblklog =3D dirblocklog - blocklog;
+	sbp->sb_dirblklog =3D dirblocklog - blocklog;
 	if (logversion =3D=3D 2) {	/* This is stored in bytes */
 		lsunit =3D (lsunit =3D=3D 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit =3D lsunit;
@@ -2095,12 +2113,13 @@
 		sbp->sb_logsectlog =3D 0;
 		sbp->sb_logsectsize =3D 0;
 	}
-	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters, attrversi=
on =3D=3D 2, 0);
+	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters,
+				attrversion =3D=3D 2, 0, nutf8 !=3D 0);
 	sbp->sb_versionnum =3D XFS_SB_VERSION_MKFS(
-			iaflag, dsunit !=3D 0,
-			dirversion =3D=3D 2, logversion =3D=3D 2, attrversion =3D=3D 1,
+			iaflag, dsunit !=3D 0, logversion =3D=3D 2, attrversion =3D=3D 1,
 			(sectorsize !=3D BBSIZE || lsectorsize !=3D BBSIZE),
-			sbp->sb_features2 !=3D 0);
+			nci !=3D 0, sbp->sb_features2 !=3D 0);
+	sbp->sb_cftino =3D 0;
 =

 	if (force_overwrite)
 		zero_old_xfs_structures(&xi, sbp);
@@ -2162,6 +2181,8 @@
 			progname);
 		exit(1);
 	}
+	if (nutf8 =3D=3D 2)
+		mp->m_flags |=3D LIBXFS_MOUNT_FLAG_TURKIC_CASE;
 =

 	for (agno =3D 0; agno < agcount; agno++) {
 		/*
@@ -2574,7 +2595,7 @@
 			    sunit=3Dvalue|su=3Dnum,sectlog=3Dn|sectsize=3Dnum,\n\
 			    lazy-count=3D0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n log=3Dn|size=3Dnum,version=3Dn]\n\
+/* naming */		[-n log=3Dn|size=3Dnum,version=3Dn,utf8=3Dnone|default|tu=
rkic]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
 /* realtime subvol */	[-r extsize=3Dnum,size=3Dnum,rtdev=3Dxxx]\n\
Index: ci/xfsprogs/mkfs/xfs_mkfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.h	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/mkfs/xfs_mkfs.h	2008-01-18 15:00:08.924584857 +1100
@@ -20,25 +20,27 @@
 =

 #define XFS_DFL_SB_VERSION_BITS \
                 (XFS_SB_VERSION_NLINKBIT | \
-                 XFS_SB_VERSION_EXTFLGBIT)
+                 XFS_SB_VERSION_EXTFLGBIT | \
+                 XFS_SB_VERSION_DIRV2BIT)
 =

-#define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
-	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
+#define XFS_SB_VERSION_MKFS(ia,dia,log2,attr1,sflag,ci,more) (\
+	((ia)||(dia)||(log2)||(attr1)||(sflag)||(more)) ? \
 	( XFS_SB_VERSION_4 |						\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
 		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
 		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
+		((ci) ? XFS_SB_VERSION_OLDCIBIT : 0) |			\
 		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
 	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 =

-#define XFS_SB_VERSION2_MKFS(lazycount, attr2, parent) (\
+#define XFS_SB_VERSION2_MKFS(lazycount, attr2, parent, unicode) (\
 	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
 	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
 	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
+	((unicode) ? XFS_SB_VERSION2_UNICODEBIT : 0) |			\
 	0 )
 =

 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
@@ -65,6 +67,7 @@
 =

 #define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
 =

+#define LIBXFS_MOUNT_FLAG_TURKIC_CASE	0x1000 /* use turkic casefold tab=
le */
 =

 /* xfs_mkfs.c */
 extern void usage (void);
Index: ci/xfsprogs/repair/agheader.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/agheader.c	2008-01-18 14:50:42.000000000 +11=
00
+++ ci/xfsprogs/repair/agheader.c	2008-01-18 15:00:08.984577159 +1100
@@ -245,10 +245,14 @@
 		 * work against older filesystems when the superblock
 		 * gets rev'ed again with new fields appended.
 		 */
-		if (XFS_SB_VERSION_HASMOREBITS(sb))
-			size =3D (__psint_t)&sb->sb_features2
-				+ sizeof(sb->sb_features2) - (__psint_t)sb;
-		else if (XFS_SB_VERSION_HASLOGV2(sb))
+		if (XFS_SB_VERSION_HASMOREBITS(sb)) {
+			if (xfs_sb_version_hasunicode(sb))
+				size =3D (__psint_t)&sb->sb_cftino
+					+ sizeof(sb->sb_cftino) - (__psint_t)sb;
+			else
+				size =3D (__psint_t)&sb->sb_features2
+					+ sizeof(sb->sb_features2) - (__psint_t)sb;
+		} else if (XFS_SB_VERSION_HASLOGV2(sb))
 			size =3D (__psint_t)&sb->sb_logsunit
 				+ sizeof(sb->sb_logsunit) - (__psint_t)sb;
 		else if (XFS_SB_VERSION_HASSECTOR(sb))
Index: ci/xfsprogs/repair/dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dir2.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/repair/dir2.c	2008-01-18 15:00:09.004574594 +1100
@@ -932,6 +932,9 @@
 		} else if (lino =3D=3D mp->m_sb.sb_gquotino)  {
 			junkit =3D 1;
 			junkreason =3D _("group quota");
+		} else if (lino =3D=3D mp->m_sb.sb_cftino)  {
+			junkit =3D 1;
+			junkreason =3D _("casefold table");
 		} else if ((irec_p =3D find_inode_rec(XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) !=3D NULL) {
 			/*
Index: ci/xfsprogs/repair/incore.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/incore.h	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/repair/incore.h	2008-01-18 15:00:09.012573567 +1100
@@ -307,6 +307,7 @@
 #define XR_INO_SOCK	9		/* socket */
 #define XR_INO_FIFO	10		/* fifo */
 #define XR_INO_MOUNTPOINT 11		/* mountpoint */
+#define XR_INO_CFT	12		/* casefold table */
 =

 /* inode allocation tree */
 =

Index: ci/xfsprogs/repair/phase6.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase6.c	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/repair/phase6.c	2008-01-18 15:00:09.016573054 +1100
@@ -17,6 +17,7 @@
  */
 =

 #include <libxfs.h>
+#include <casefoldtable.h>
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -94,6 +95,7 @@
 static int
 dir_hash_add(
 	dir_hash_tab_t		*hashtab,
+	xfs_inode_t		*ip,
 	__uint32_t		addr,
 	xfs_ino_t		inum,
 	int			namelen,
@@ -113,7 +115,7 @@
 	dup =3D 0;
 =

 	if (!junk) {
-		hash =3D libxfs_da_hashname(name, namelen);
+		hash =3D xfs_dir_hashname(ip, name, namelen);
 		byhash =3D DIR_HASH_FUNC(hashtab, hash);
 =

 		/*
@@ -797,6 +799,18 @@
 }
 =

 /*
+ * Makes new case fold table. Default it to a normal table and do check=
s
+ * during the hashing for possible turkic case, and adjust then if requ=
ired.
+ */
+void
+mk_cftino(xfs_mount_t *mp)
+{
+	int	error =3D libxfs_create_casefoldtable(mp, 0);
+	if (error)
+		do_error(_("Creating the casefold table failed"), error);
+}
+
+/*
  * orphanage name =3D=3D lost+found
  */
 xfs_ino_t
@@ -1092,7 +1106,6 @@
  */
 static xfs_dfsbno_t
 map_first_dblock_fsbno(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
 			xfs_inode_t	*ip,
 			xfs_dablk_t	*bno)
 {
@@ -1127,11 +1140,11 @@
 		if (!no_modify)
 			do_error(
 _("can't map block %d in %s inode %llu, xfs_bmapi returns %d, nmap =3D =
%d\n"),
-				da_bno, ftype, ino, error, nmap);
+				da_bno, ftype, ip->i_ino, error, nmap);
 		else  {
 			do_warn(
 _("can't map block %d in %s inode %llu, xfs_bmapi returns %d, nmap =3D =
%d\n"),
-				da_bno, ftype, ino, error, nmap);
+				da_bno, ftype, ip->i_ino, error, nmap);
 			return(NULLDFSBNO);
 		}
 	}
@@ -1139,10 +1152,10 @@
 	if ((fsbno =3D map.br_startblock) =3D=3D HOLESTARTBLOCK)  {
 		if (!no_modify)
 			do_error(_("block %d in %s ino %llu doesn't exist\n"),
-				da_bno, ftype, ino);
+				da_bno, ftype, ip->i_ino);
 		else  {
 			do_warn(_("block %d in %s ino %llu doesn't exist\n"),
-				da_bno, ftype, ino);
+				da_bno, ftype, ip->i_ino);
 			return(NULLDFSBNO);
 		}
 	}
@@ -1167,7 +1180,7 @@
 		if (!bp) {
 			do_warn(
 	_("can't read block %u (fsbno %llu) for directory inode %llu\n"),
-					da_bno, fsbno, ino);
+					da_bno, fsbno, ip->i_ino);
 			return(NULLDFSBNO);
 		}
 =

@@ -1177,7 +1190,7 @@
 			libxfs_putbuf(bp);
 			do_warn(
 _("bad dir/attr magic number in inode %llu, file bno =3D %u, fsbno =3D =
%llu\n"),
-				ino, da_bno, fsbno);
+				ip->i_ino, da_bno, fsbno);
 			return(NULLDFSBNO);
 		}
 =

@@ -1197,11 +1210,11 @@
 			if (!no_modify)
 				do_error(
 _("can't map block %d in %s ino %llu, xfs_bmapi returns %d, nmap =3D %d=
\n"),
-					da_bno, ftype, ino, error, nmap);
+					da_bno, ftype, ip->i_ino, error, nmap);
 			else  {
 				do_warn(
 _("can't map block %d in %s ino %llu, xfs_bmapi returns %d, nmap =3D %d=
\n"),
-					da_bno, ftype, ino, error, nmap);
+					da_bno, ftype, ip->i_ino, error, nmap);
 				return(NULLDFSBNO);
 			}
 		}
@@ -1209,11 +1222,11 @@
 			if (!no_modify)
 				do_error(
 				_("block %d in %s inode %llu doesn't exist\n"),
-					da_bno, ftype, ino);
+					da_bno, ftype, ip->i_ino);
 			else  {
 				do_warn(
 				_("block %d in %s inode %llu doesn't exist\n"),
-					da_bno, ftype, ino);
+					da_bno, ftype, ip->i_ino);
 				return(NULLDFSBNO);
 			}
 		}
@@ -1236,8 +1249,7 @@
  * this routine can NOT be called if running in no modify mode
  */
 static int
-prune_lf_dir_entry(xfs_mount_t *mp, xfs_ino_t ino, xfs_inode_t *ip,
-			xfs_dahash_t *hashval)
+prune_lf_dir_entry(xfs_mount_t *mp, xfs_inode_t *ip, xfs_dahash_t *hash=
val)
 {
 	xfs_dfsbno_t		fsbno;
 	int			i;
@@ -1280,7 +1292,7 @@
 	namest =3D NULL;
 	fblock =3D NULLFSBLOCK;
 =

-	fsbno =3D map_first_dblock_fsbno(mp, ino, ip, &da_bno);
+	fsbno =3D map_first_dblock_fsbno(mp, ip, &da_bno);
 =

 	/*
 	 * now go foward along the leaves of the btree looking
@@ -1293,7 +1305,7 @@
 		if (!bp)  {
 			do_error(
 	_("can't read directory inode %llu (leaf) block %u (fsbno %llu)\n"),
-				ino, da_bno, fsbno);
+				ip->i_ino, da_bno, fsbno);
 			/* NOTREACHED */
 		}
 =

@@ -1335,12 +1347,12 @@
 				if (error || nmap !=3D 1)
 					do_error(
 _("can't map block %d in directory %llu, xfs_bmapi returns %d, nmap =3D=
 %d\n"),
-						da_bno, ino, error, nmap);
+						da_bno, ip->i_ino, error, nmap);
 				if ((fsbno =3D map.br_startblock)
 						=3D=3D HOLESTARTBLOCK)  {
 					do_error(
 				_("%s ino %llu block %d doesn't exist\n"),
-						ftype, ino, da_bno);
+						ftype, ip->i_ino, da_bno);
 				}
 			}
 		}
@@ -1395,7 +1407,7 @@
 	if (error)  {
 		do_error(
 _("couldn't remove bogus entry \"%s\" in\n\tdirectory inode %llu, errno=
 =3D %d\n"),
-			fname, ino, error);
+			fname, ip->i_ino, error);
 		/* NOTREACHED */
 	}
 =

@@ -1432,7 +1444,7 @@
  */
 static void
 lf_block_dir_entry_check(xfs_mount_t		*mp,
-			xfs_ino_t		ino,
+			xfs_inode_t		*ip,
 			xfs_dir_leafblock_t	*leaf,
 			int			*dirty,
 			int			*num_illegal,
@@ -1516,7 +1528,7 @@
 		 * '..' is already accounted for or will be taken care
 		 * of when directory is moved to orphanage.
 		 */
-		if (ino =3D=3D lino)  {
+		if (ip->i_ino =3D=3D lino)  {
 			ASSERT(namest->name[0] =3D=3D '.' && entry->namelen =3D=3D 1);
 			add_inode_ref(current_irec, current_ino_offset);
 			*need_dot =3D 0;
@@ -1539,7 +1551,7 @@
 			nbad++;
 			if (entry_junked(_("entry \"%s\" in dir inode %llu "
 					"points to non-existent inode %llu"),
-					fname, ino, lino)) {
+					fname, ip->i_ino, lino)) {
 				namest->name[0] =3D '/';
 				*dirty =3D 1;
 			}
@@ -1557,7 +1569,7 @@
 			nbad++;
 			if (entry_junked(_("entry \"%s\" in dir inode %llu "
 					"points to free inode %llu"),
-					fname, ino, lino)) {
+					fname, ip->i_ino, lino)) {
 				namest->name[0] =3D '/';
 				*dirty =3D 1;
 			}
@@ -1566,14 +1578,15 @@
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
-		if (ino =3D=3D mp->m_sb.sb_rootino && strcmp(fname, ORPHANAGE) =3D=3D=
 0) {
+		if (ip->i_ino =3D=3D mp->m_sb.sb_rootino &&
+				strcmp(fname, ORPHANAGE) =3D=3D 0) {
 			/* root inode, "lost+found", if it's not a directory,
 			 * trash it, otherwise, assign it */
 			if (!inode_isadir(irec, ino_offset)) {
 				nbad++;
 				if (entry_junked(_("%s (ino %llu) in root "
 						"(%llu) is not a directory"),
-						ORPHANAGE, lino, ino)) {
+						ORPHANAGE, lino, ip->i_ino)) {
 					namest->name[0] =3D '/';
 					*dirty =3D 1;
 				}
@@ -1589,13 +1602,13 @@
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, (da_bno << mp->m_sb.sb_blocklog) +
-				entry->nameidx, lino, entry->namelen,
-				namest->name)) {
+		if (!dir_hash_add(hashtab, ip, (da_bno <<
+					mp->m_sb.sb_blocklog) + entry->nameidx,
+				lino, entry->namelen, namest->name)) {
 			nbad++;
 			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
 					"%llu is a duplicate name"),
-					fname, lino, ino)) {
+					fname, lino, ip->i_ino)) {
 				namest->name[0] =3D '/';
 				*dirty =3D 1;
 			}
@@ -1626,15 +1639,15 @@
 			junkit =3D 1;
 			do_warn(
 _("entry \"%s\" in dir %llu points to an already connected dir inode %l=
lu,\n"),
-				fname, ino, lino);
-		} else if (parent =3D=3D ino)  {
+				fname, ip->i_ino, lino);
+		} else if (parent =3D=3D ip->i_ino)  {
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
 		} else  {
 			junkit =3D 1;
 			do_warn(
 _("entry \"%s\" in dir ino %llu not consistent with .. value (%llu) in =
ino %llu,\n"),
-				fname, ino, parent, lino);
+				fname, ip->i_ino, parent, lino);
 		}
 =

 		if (junkit)  {
@@ -1666,7 +1679,6 @@
  */
 static void
 longform_dir_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
 			xfs_inode_t	*ip,
 			int		*num_illegal,
 			int		*need_dot,
@@ -1691,10 +1703,11 @@
 	*need_dot =3D 1;
 	ftype =3D _("dir");
 =

-	fsbno =3D map_first_dblock_fsbno(mp, ino, ip, &da_bno);
+	fsbno =3D map_first_dblock_fsbno(mp, ip, &da_bno);
 =

 	if (fsbno =3D=3D NULLDFSBNO && no_modify)  {
-		do_warn(_("cannot map block 0 of directory inode %llu\n"), ino);
+		do_warn(_("cannot map block 0 of directory inode %llu\n"),
+				ip->i_ino);
 		return;
 	}
 =

@@ -1708,7 +1721,7 @@
 		if (!bp) {
 			do_error(
 	_("can't read block %u (fsbno %llu) for directory inode %llu\n"),
-					da_bno, fsbno, ino);
+					da_bno, fsbno, ip->i_ino);
 			/* NOTREACHED */
 		}
 =

@@ -1721,7 +1734,7 @@
 _("bad magic # (0x%x) for dir ino %llu leaf block (bno %u fsbno %llu)\n=
"),
 					INT_GET(leaf->hdr.info.magic,
 						ARCH_CONVERT),
-					ino, da_bno, fsbno);
+					ip->i_ino, da_bno, fsbno);
 				/* NOTREACHED */
 			} else  {
 				/*
@@ -1734,7 +1747,7 @@
 		}
 =

 		if (!skipit)
-			lf_block_dir_entry_check(mp, ino, leaf, &dirty,
+			lf_block_dir_entry_check(mp, ip, leaf, &dirty,
 					num_illegal, need_dot, irec,
 					ino_offset, hashtab, da_bno);
 =

@@ -1757,11 +1770,11 @@
 				if (!no_modify)
 					do_error(
 _("can't map leaf block %d in dir %llu, xfs_bmapi returns %d, nmap =3D =
%d\n"),
-						da_bno, ino, error, nmap);
+						da_bno, ip->i_ino, error, nmap);
 				else  {
 					do_warn(
 _("can't map leaf block %d in dir %llu, xfs_bmapi returns %d, nmap =3D =
%d\n"),
-						da_bno, ino, error, nmap);
+						da_bno, ip->i_ino, error, nmap);
 					return;
 				}
 			}
@@ -1769,11 +1782,11 @@
 				if (!no_modify)
 					do_error(
 				_("block %d in %s ino %llu doesn't exist\n"),
-						da_bno, ftype, ino);
+						da_bno, ftype, ip->i_ino);
 				else  {
 					do_warn(
 				_("block %d in %s ino %llu doesn't exist\n"),
-						da_bno, ftype, ino);
+						da_bno, ftype, ip->i_ino);
 					return;
 				}
 			}
@@ -1788,10 +1801,9 @@
 =

 static void
 longform_dir2_rebuild(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	xfs_inode_t	*ip,
-	dir_hash_tab_t	*hashtab)
+	xfs_mount_t		*mp,
+	xfs_inode_t		*ip,
+	dir_hash_tab_t		*hashtab)
 {
 	int			error;
 	int			nres;
@@ -1810,7 +1822,7 @@
 	 * name/inode pairs in the hash table
 	 */
 =

-	do_warn(_("rebuilding directory inode %llu\n"), ino);
+	do_warn(_("rebuilding directory inode %llu\n"), ip->i_ino);
 =

 	/*
 	 * first attempt to locate the parent inode, if it can't be found,
@@ -1891,7 +1903,7 @@
 				nres))) {
 			do_warn(
 _("name create failed in ino %llu (%d), filesystem may be out of space\=
n"),
-				ino, error);
+				ip->i_ino, error);
 			libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 						XFS_TRANS_ABORT);
 			break;
@@ -2253,9 +2265,24 @@
 				orphanage_ino =3D inum;
 		}
 		/*
+		 * check for invalid UTF-8 name if Unicode filesystem
+		 */
+		if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+				xfs_unicode_validate((uchar_t *)dep->name,
+					dep->namelen) !=3D 0) {
+			nbad++;
+			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
+					"%llu is not a valid UTF-8 name"),
+					fname, inum, ip->i_ino)) {
+				dep->name[0] =3D '/';
+				libxfs_dir2_data_log_entry(tp, bp, dep);
+			}
+			continue;
+		}
+		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, addr, inum, dep->namelen,
+		if (!dir_hash_add(hashtab, ip, addr, inum, dep->namelen,
 				dep->name)) {
 			nbad++;
 			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
@@ -2565,7 +2592,6 @@
  */
 static void
 longform_dir2_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
 			xfs_inode_t	*ip,
 			int		*num_illegal,
 			int		*need_dot,
@@ -2629,7 +2655,7 @@
 				XFS_DATA_FORK)) {
 			do_warn(_(
 			"can't read data block %u for directory inode %llu\n"),
-				da_bno, ino);
+				da_bno, ip->i_ino);
 			*num_illegal +=3D 1;
 			continue;	/* try and read all "data" blocks */
 		}
@@ -2637,7 +2663,7 @@
 				irec, ino_offset, &bplist[db], hashtab,
 				&freetab, da_bno, isblock);
 	}
-	fixit =3D (*num_illegal !=3D 0) || dir2_is_badino(ino);
+	fixit =3D (*num_illegal !=3D 0) || dir2_is_badino(ip->i_ino);
 =

 	/* check btree and freespace */
 	if (isblock) {
@@ -2659,7 +2685,7 @@
 		for (i =3D 0; i < freetab->naents; i++)
 			if (bplist[i])
 				libxfs_da_brelse(NULL, bplist[i]);
-		longform_dir2_rebuild(mp, ino, ip, hashtab);
+		longform_dir2_rebuild(mp, ip, hashtab);
 		*num_illegal =3D 0;
 	} else {
 		for (i =3D 0; i < freetab->naents; i++)
@@ -2677,7 +2703,6 @@
  */
 static void
 shortform_dir_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
 			xfs_inode_t	*ip,
 			int		*ino_dirty,
 			ino_tree_node_t	*current_irec,
@@ -2726,7 +2751,7 @@
 	if (sf =3D=3D NULL) {
 		junkit =3D 1;
 		do_warn(_("shortform dir inode %llu has null data entries \n"),
-			ino);
+			ip->i_ino);
 =

 		}
 	else {
@@ -2794,7 +2819,7 @@
 		if (irec =3D=3D NULL) {
 			do_warn(_("entry \"%s\" in shortform dir %llu "
 				"references non-existent ino %llu"),
-				fname, ino, lino);
+				fname, ip->i_ino, lino);
 			goto do_junkit;
 		}
 		ino_offset =3D XFS_INO_TO_AGINO(mp, lino) - irec->ino_startnum;
@@ -2806,19 +2831,22 @@
 		 */
 		if (!is_inode_free(irec, ino_offset))  {
 			do_warn(_("entry \"%s\" in shortform dir inode %llu "
-				"points to free inode %llu"), fname, ino, lino);
+				"points to free inode %llu"),
+				fname, ip->i_ino, lino);
 			goto do_junkit;
 		}
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
-		if (ino =3D=3D mp->m_sb.sb_rootino && strcmp(fname, ORPHANAGE) =3D=3D=
 0) {
+		if (ip->i_ino =3D=3D mp->m_sb.sb_rootino &&
+				strcmp(fname, ORPHANAGE) =3D=3D 0) {
 			/*
 			 * if it's not a directory, trash it
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
 				do_warn(_("%s (ino %llu) in root (%llu) is not "
-					"a directory"), ORPHANAGE, lino, ino);
+					"a directory"),
+					ORPHANAGE, lino, ip->i_ino);
 				goto do_junkit;
 			}
 			/*
@@ -2831,11 +2859,11 @@
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab,
+		if (!dir_hash_add(hashtab, ip,
 				(xfs_dir2_dataptr_t)(sf_entry - &sf->list[0]),
 				lino, sf_entry->namelen, sf_entry->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
-				"duplicate name"), fname, lino, ino);
+				"duplicate name"), fname, lino, ip->i_ino);
 			goto do_junkit;
 		}
 		if (!inode_isadir(irec, ino_offset))  {
@@ -2861,8 +2889,8 @@
 				junkit =3D 1;
 				do_warn(_("entry \"%s\" in dir %llu references "
 					"already connected dir ino %llu,\n"),
-					fname, ino, lino);
-			} else if (parent =3D=3D ino)  {
+					fname, ip->i_ino, lino);
+			} else if (parent =3D=3D ip->i_ino)  {
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
 			} else  {
@@ -2870,7 +2898,7 @@
 				do_warn(_("entry \"%s\" in dir %llu not "
 					"consistent with .. value (%llu) in "
 					"dir ino %llu"),
-					fname, ino, parent, lino);
+					fname, ip->i_ino, parent, lino);
 			}
 		}
 		if (junkit)  {
@@ -2960,7 +2988,7 @@
 =

 /* ARGSUSED */
 static void
-prune_sf_dir_entry(xfs_mount_t *mp, xfs_ino_t ino, xfs_inode_t *ip)
+prune_sf_dir_entry(xfs_mount_t *mp, xfs_inode_t *ip)
 {
 				/* REFERENCED */
 	xfs_ino_t		lino;
@@ -3058,7 +3086,6 @@
  */
 static void
 shortform_dir2_entry_check(xfs_mount_t	*mp,
-			xfs_ino_t	ino,
 			xfs_inode_t	*ip,
 			int		*ino_dirty,
 			ino_tree_node_t	*current_irec,
@@ -3188,7 +3215,7 @@
 		if (irec =3D=3D NULL)  {
 			do_warn(_("entry \"%s\" in shortform directory %llu "
 				  "references non-existent inode %llu"),
-				fname, ino, lino);
+				fname, ip->i_ino, lino);
 			goto do_junkit;
 		}
 =

@@ -3202,19 +3229,21 @@
 		if (is_inode_free(irec, ino_offset))  {
 			do_warn(_("entry \"%s\" in shortform directory "
 				  "inode %llu points to free inode %llu"),
-				fname, ino, lino);
+				fname, ip->i_ino, lino);
 			goto do_junkit;
 		}
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
-		if (ino =3D=3D mp->m_sb.sb_rootino && strcmp(fname, ORPHANAGE) =3D=3D=
 0) {
+		if (ip->i_ino =3D=3D mp->m_sb.sb_rootino &&
+				strcmp(fname, ORPHANAGE) =3D=3D 0) {
 			/*
 			 * if it's not a directory, trash it
 			 */
 			if (!inode_isadir(irec, ino_offset)) {
 				do_warn(_("%s (ino %llu) in root (%llu) is not "
-					"a directory"), ORPHANAGE, lino, ino);
+					"a directory"),
+					ORPHANAGE, lino, ip->i_ino);
 				goto do_junkit;
 			}
 			/*
@@ -3225,13 +3254,24 @@
 				orphanage_ino =3D lino;
 		}
 		/*
+		 * check for invalid UTF-8 name if Unicode filesystem
+		 */
+		if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+				xfs_unicode_validate((uchar_t *)sfep->name,
+					sfep->namelen) !=3D 0) {
+			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is "
+				"not a valid UTF-8 name"),
+				fname, lino, ip->i_ino);
+			goto do_junkit;
+		}
+		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, (xfs_dir2_dataptr_t)
+		if (!dir_hash_add(hashtab, ip, (xfs_dir2_dataptr_t)
 					(sfep - XFS_DIR2_SF_FIRSTENTRY(sfp)),
 				lino, sfep->namelen, sfep->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
-				"duplicate name"), fname, lino, ino);
+				"duplicate name"), fname, lino, ip->i_ino);
 			goto do_junkit;
 		}
 		if (!inode_isadir(irec, ino_offset))  {
@@ -3252,17 +3292,17 @@
 				junkit =3D 1;
 				do_warn(_("entry \"%s\" in directory inode %llu"
 					  " references already connected inode "
-					  "%llu,\n"),
-					fname, ino, lino);
-			} else if (parent =3D=3D ino)  {
+					  "%llu"),
+					fname, ip->i_ino, lino);
+			} else if (parent =3D=3D ip->i_ino)  {
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
 			} else  {
 				junkit =3D 1;
 				do_warn(_("entry \"%s\" in directory inode %llu"
 					  " not consistent with .. value (%llu)"
-					  " in inode %llu,\n"),
-					fname, ino, parent, lino);
+					  " in inode %llu"),
+					fname, ip->i_ino, parent, lino);
 			}
 		}
 =

@@ -3302,11 +3342,11 @@
 				*ino_dirty =3D 1;
 =

 				if (verbose)
-					do_warn(_("junking entry\n"));
+					do_warn(_(", junking entry\n"));
 				else
 					do_warn("\n");
 			} else  {
-				do_warn(_("would junk entry\n"));
+				do_warn(_(", would junk entry\n"));
 			}
 		} else if (lino > XFS_DIR2_MAX_SHORT_INUM)
 			i8++;
@@ -3330,7 +3370,8 @@
 =

 	if (sfp->hdr.i8count !=3D i8) {
 		if (no_modify) {
-			do_warn(_("would fix i8count in inode %llu\n"), ino);
+			do_warn(_("would fix i8count in inode %llu\n"),
+				ip->i_ino);
 		} else {
 			if (i8 =3D=3D 0) {
 				tmp_sfep =3D next_sfep;
@@ -3342,7 +3383,7 @@
 			} else
 				sfp->hdr.i8count =3D i8;
 			*ino_dirty =3D 1;
-			do_warn(_("fixing i8count in inode %llu\n"), ino);
+			do_warn(_("fixing i8count in inode %llu\n"), ip->i_ino);
 		}
 	}
 =

@@ -3418,6 +3459,7 @@
 		add_inode_refchecked(ino, irec, 0);
 		return;
 	}
+	ASSERT(ip->i_ino =3D=3D ino);
 =

 	need_dot =3D dirty =3D num_illegal =3D 0;
 =

@@ -3450,15 +3492,13 @@
 			 * we need to create '.' entries here.
 			 */
 			if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-				longform_dir2_entry_check(mp, ino, ip,
-							&num_illegal, &need_dot,
-							irec, ino_offset,
-							hashtab);
+				longform_dir2_entry_check(mp, ip, &num_illegal,
+						&need_dot, irec, ino_offset,
+						hashtab);
 			else
-				longform_dir_entry_check(mp, ino, ip,
-							&num_illegal, &need_dot,
-							irec, ino_offset,
-							hashtab);
+				longform_dir_entry_check(mp, ip, &num_illegal,
+						&need_dot, irec, ino_offset,
+						hashtab);
 			break;
 =

 		case XFS_DINODE_FMT_LOCAL:
@@ -3481,13 +3521,11 @@
 			libxfs_trans_ihold(tp, ip);
 =

 			if (XFS_SB_VERSION_HASDIRV2(&mp->m_sb))
-				shortform_dir2_entry_check(mp, ino, ip, &dirty,
-							irec, ino_offset,
-							hashtab);
+				shortform_dir2_entry_check(mp, ip, &dirty,
+						irec, ino_offset, hashtab);
 			else
-				shortform_dir_entry_check(mp, ino, ip, &dirty,
-							irec, ino_offset,
-							hashtab);
+				shortform_dir_entry_check(mp, ip, &dirty,
+						irec, ino_offset, hashtab);
 =

 			ASSERT(dirty =3D=3D 0 || (dirty && !no_modify));
 			if (dirty)  {
@@ -3567,7 +3605,7 @@
 =

 		while (num_illegal > 0 && ip->i_d.di_format !=3D
 				XFS_DINODE_FMT_LOCAL)  {
-			prune_lf_dir_entry(mp, ino, ip, &hashval);
+			prune_lf_dir_entry(mp, ip, &hashval);
 			num_illegal--;
 		}
 =

@@ -3600,7 +3638,7 @@
 			libxfs_trans_ijoin(tp, ip, 0);
 			libxfs_trans_ihold(tp, ip);
 =

-			prune_sf_dir_entry(mp, ino, ip);
+			prune_sf_dir_entry(mp, ip);
 =

 			libxfs_trans_log_inode(tp, ip,
 					XFS_ILOG_CORE | XFS_ILOG_DDATA);
@@ -3679,7 +3717,7 @@
 =

 /*
  * mark realtime bitmap and summary inodes as reached.
- * quota inode will be marked here as well
+ * quota and casefold table inodes will be marked here as well
  */
 void
 mark_standalone_inodes(xfs_mount_t *mp)
@@ -3707,6 +3745,15 @@
 =

 	add_inode_reached(irec, offset);
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		irec =3D find_inode_rec(XFS_INO_TO_AGNO(mp, mp->m_sb.sb_cftino),
+				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_cftino));
+		offset =3D XFS_INO_TO_AGINO(mp, mp->m_sb.sb_cftino) -
+				irec->ino_startnum;
+		ASSERT(irec !=3D NULL);
+		add_inode_reached(irec, offset);
+	}
+
 	if (fs_quotas)  {
 		if (mp->m_sb.sb_uquotino
 				&& mp->m_sb.sb_uquotino !=3D NULLFSINO)  {
@@ -3882,6 +3929,15 @@
 		}
 	}
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb) && (mp->m_sb.sb_cftino =3D=3D=
 0 ||
+			mp->m_sb.sb_cftino =3D=3D NULLFSINO)) {
+		if (!no_modify) {
+			do_warn(_("reinitializing casefold table inode\n"));
+			mk_cftino(mp);
+		} else
+			do_warn(_("would reinitializing casefold table inode\n"));
+	}
+
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n=
"));
@@ -3896,6 +3952,11 @@
 		}
 	}
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (xfs_unicode_read_cft(mp) !=3D 0)
+			do_error(_("cannot read case folding table\n"));
+	}
+
 	mark_standalone_inodes(mp);
 =

 	do_log(_("        - traversing filesystem ...\n"));
Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/check.c	2008-01-18 15:00:09.076565357 +1100
@@ -31,6 +31,7 @@
 #include "output.h"
 #include "init.h"
 #include "malloc.h"
+#include "casefoldtable.h"
 =

 typedef enum {
 	IS_USER_QUOTA, IS_PROJECT_QUOTA, IS_GROUP_QUOTA,
@@ -39,11 +40,11 @@
 typedef enum {
 	DBM_UNKNOWN,	DBM_AGF,	DBM_AGFL,	DBM_AGI,
 	DBM_ATTR,	DBM_BTBMAPA,	DBM_BTBMAPD,	DBM_BTBNO,
-	DBM_BTCNT,	DBM_BTINO,	DBM_DATA,	DBM_DIR,
-	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,	DBM_INODE,
-	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,	DBM_RTBITMAP,
-	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,	DBM_SB,
-	DBM_SYMLINK,
+	DBM_BTCNT,	DBM_BTINO,	DBM_CFT,	DBM_DATA,
+	DBM_DIR,	DBM_FREE1,	DBM_FREE2,	DBM_FREELIST,
+	DBM_INODE,	DBM_LOG,	DBM_MISSING,	DBM_QUOTA,
+	DBM_RTBITMAP,	DBM_RTDATA,	DBM_RTFREE,	DBM_RTSUM,
+	DBM_SB,		DBM_SYMLINK,
 	DBM_NDBM
 } dbm_t;
 =

@@ -153,6 +154,7 @@
 	"btbno",
 	"btcnt",
 	"btino",
+	"cft",
 	"data",
 	"dir",
 	"free1",
@@ -224,6 +226,7 @@
 static int		blocktrash_f(int argc, char **argv);
 static int		blockuse_f(int argc, char **argv);
 static int		check_blist(xfs_fsblock_t bno);
+static void		check_cft(void);
 static void		check_dbmap(xfs_agnumber_t agno, xfs_agblock_t agbno,
 				    xfs_extlen_t len, dbm_t type);
 static int		check_inomap(xfs_agnumber_t agno, xfs_agblock_t agbno,
@@ -249,7 +252,7 @@
 				       xfs_extlen_t len, int typemask);
 static void		checknot_rdbmap(xfs_drfsbno_t bno, xfs_extlen_t len,
 					int typemask);
-static void		dir_hash_add(xfs_dahash_t hash,
+static void		dir_hash_add(const uchar_t *name, int namelen,
 				     xfs_dir2_dataptr_t addr);
 static void		dir_hash_check(inodata_t *id, int v);
 static void		dir_hash_done(void);
@@ -1227,6 +1230,170 @@
 }
 =

 static void
+check_cft(void)
+{
+	xfs_agblock_t		agbno;
+	xfs_agino_t		agino;
+	xfs_dinode_t		*dip;
+	xfs_dinode_core_t	tdic;
+	xfs_extnum_t		nextents =3D 0;
+	xfs_drfsbno_t		totdblocks =3D 0;
+	xfs_drfsbno_t		totiblocks =3D 0;
+	blkmap_t		*blkmap;
+	xfs_dcft_t		*cfthdr;
+	int			off;
+	int			i;
+	xfs_dfsbno_t		fsbno;
+	int			ntables;
+	int			lower_off;
+
+	/*
+	 * Without CRCs, cannot verify the actual table, just the header
+	 * consistency.
+	 */
+	cfthdr =3D NULL;
+	agino =3D XFS_INO_TO_AGINO(mp, mp->m_sb.sb_cftino);
+	agbno =3D XFS_AGINO_TO_AGBNO(mp, agino);
+	off =3D XFS_AGINO_TO_OFFSET(mp, agino);
+	if (XFS_INO_TO_AGNO(mp, mp->m_sb.sb_cftino) !=3D 0 ||
+			agbno >=3D mp->m_sb.sb_agblocks ||
+			off >=3D mp->m_sb.sb_inopblock) {
+		if (!sflag)
+			dbprintf("bad casefold table inode number %lld\n",
+				mp->m_sb.sb_cftino);
+		goto bad_out;
+	}
+	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, 0, agbno),
+			blkbb, DB_RING_IGN, NULL);
+	off_cur(off << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
+	dip =3D iocur_top->data;
+
+	libxfs_xlate_dinode_core((xfs_caddr_t)&dip->di_core, &tdic, 1);
+	memcpy(&dip->di_core, &tdic, sizeof(xfs_dinode_core_t));
+
+	/* do some basic inode checks */
+	if ((dip->di_core.di_mode & S_IFMT) !=3D S_IFREG) {
+		if (!sflag)
+			dbprintf("casefold table inode mode invalid\n");
+		goto bad_out;
+	}
+	if (dip->di_core.di_format !=3D XFS_DINODE_FMT_EXTENTS) {
+		dbprintf("casefold table inode format invalid\n");
+		goto bad_out;
+	}
+	if (dip->di_core.di_size <=3D sizeof(xfs_dcft_t) + sizeof(__be32) *
+			XFS_CFT_MAX_NUM_TABLES) {
+		if (!sflag)
+			dbprintf("casefold table inode size too small\n");
+		return;
+	}
+	blkmap =3D blkmap_alloc(dip->di_core.di_nextents);
+
+	process_exinode(find_inode(mp->m_sb.sb_cftino, 1), dip, DBM_CFT,
+			&totdblocks, &totiblocks, &nextents, &blkmap,
+			XFS_DATA_FORK);
+	ASSERT(totiblocks =3D=3D 0);
+	if (totdblocks !=3D dip->di_core.di_nblocks) {
+		if (!sflag)
+			dbprintf("bad nblocks %lld for casefold table inode "
+				"%lld, counted %lld\n", dip->di_core.di_nblocks,
+				mp->m_sb.sb_cftino, totdblocks);
+		goto bad_out;
+	}
+	if (nextents !=3D dip->di_core.di_nextents) {
+		if (!sflag)
+			dbprintf("bad nextents %d for casefold table inode "
+				"%lld, counted %d\n", dip->di_core.di_nextents,
+				mp->m_sb.sb_cftino, nextents);
+		goto bad_out;
+	}
+
+	cfthdr =3D xmalloc(sizeof(xfs_dcft_t) + sizeof(__be32) *
+			XFS_CFT_MAX_NUM_TABLES);
+
+	/* make sure we can read the entire table, should not be sparse */
+	for (i =3D 0; i < totdblocks; i++) {
+		fsbno =3D blkmap_get(blkmap, i);
+		if (fsbno =3D=3D NULLFSBLOCK) {
+			if (!sflag)
+				dbprintf("block %lld for casefold table inode "
+					"is missing\n", (xfs_dfiloff_t)i);
+			goto bad_out;
+		}
+		push_cur();
+		set_cur(&typtab[TYP_CFT], XFS_FSB_TO_DADDR(mp, fsbno), blkbb,
+				DB_RING_IGN, NULL);
+		if (iocur_top->data =3D=3D NULL) {
+			pop_cur();
+			if (!sflag)
+				dbprintf("can't read block %lld for casfold "
+					 "table inode\n", (xfs_dfiloff_t)i);
+			goto bad_out;
+		}
+		if (i =3D=3D 0)
+			memcpy(cfthdr, iocur_top->data, sizeof(xfs_dcft_t) +
+				sizeof(__be32) * XFS_CFT_MAX_NUM_TABLES);
+		pop_cur();
+	}
+
+	/* verify contents of the header */
+	if (be32_to_cpu(cfthdr->cft_magic) !=3D XFS_CFT_MAGIC) {
+		if (!sflag)
+			dbprintf("bad magic number 0x%x in casefold table (ino %llu)\n",
+				be32_to_cpu(cfthdr->cft_magic), mp->m_sb.sb_cftino);
+		goto bad_out;
+	}
+	if (be32_to_cpu(cfthdr->cft_flags) > XFS_CFT_FLAG_MAX) {
+		if (!sflag)
+			dbprintf("invalid flags (0x%x) in casefold table (ino %llu)\n",
+				be32_to_cpu(cfthdr->cft_flags), mp->m_sb.sb_cftino);
+		goto bad_out;
+	}
+	if (platform_uuid_compare(&cfthdr->cft_uuid, &mp->m_sb.sb_uuid) !=3D 0=
) {
+		if (!sflag)
+			dbprintf("mismatched UUID in casefold table (ino %llu)\n",
+				mp->m_sb.sb_cftino);
+		goto bad_out;
+	}
+	ntables =3D be32_to_cpu(cfthdr->cft_num_tables);
+	if (ntables < XFS_CFT_MIN_NUM_TABLES ||
+			ntables > XFS_CFT_MAX_NUM_TABLES) {
+		if (!sflag)
+			dbprintf("invalid number of tables (%d) in casefold "
+				"table (ino %llu)\n", ntables, mp->m_sb.sb_cftino);
+		goto bad_out;
+	}
+	lower_off =3D sizeof(xfs_dcft_t) + sizeof(__be32) * (ntables - 1);
+	for (i =3D 0; i < ntables; i++) {
+		off =3D be32_to_cpu(cfthdr->cft_table_offset[i]);
+		if (off < lower_off || off > dip->di_core.di_size) {
+			if (!sflag)
+				dbprintf("invalid table offset (%d) in "
+					"casefold table (ino %llu)\n",
+					off, mp->m_sb.sb_cftino);
+			goto bad_out;
+		}
+		lower_off =3D off + sizeof(__be16);
+	}
+	if (xfs_unicode_read_cft(mp) =3D=3D 0) {
+		xfree(cfthdr);
+		if (blkmap)
+			blkmap_free(blkmap);
+		return;
+	}
+
+bad_out:
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_dirnameops =3D &xfs_default_nameops;
+		mp->m_attrnameops =3D &xfs_default_nameops;
+	}
+	error++;
+	xfree(cfthdr);
+	if (blkmap)
+		blkmap_free(blkmap);
+}
+
+static void
 check_dbmap(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
@@ -1605,12 +1772,19 @@
 =

 static void
 dir_hash_add(
-	xfs_dahash_t		hash,
+	const uchar_t		*name,
+	int			namelen,
 	xfs_dir2_dataptr_t	addr)
 {
+	xfs_inode_t		inode;
+	xfs_dahash_t		hash;
 	int			i;
 	dirhash_t		*p;
 =

+	/* xfs_dir_hashname only uses i_mount in xfs_inode_t for now */
+	inode.i_mount =3D mp;
+	hash =3D xfs_dir_hashname(&inode, name, namelen);
+
 	i =3D DIR_HASH_FUNC(hash, addr);
 	p =3D malloc(sizeof(*p));
 	p->next =3D dirhash[i];
@@ -1778,6 +1952,18 @@
 		sumfile =3D xcalloc(mp->m_rsumsize, 1);
 		sumcompute =3D xcalloc(mp->m_rsumsize, 1);
 	}
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		if (mp->m_sb.sb_cftino =3D=3D 0 || mp->m_sb.sb_cftino =3D=3D NULLFSIN=
O)
+			dbprintf("missing casefold table inode number for "
+				"unicode filesystem\n");
+		else
+			check_cft(); /* need CFT before processing root dir */
+	} else {
+		if (mp->m_sb.sb_cftino !=3D 0 && mp->m_sb.sb_cftino !=3D NULLFSINO)
+			dbprintf("bad casefold table inode number %llu for "
+				"non-unicode filesystem\n", mp->m_sb.sb_cftino);
+	}
+
 	nflag =3D sflag =3D tflag =3D verbose =3D optind =3D 0;
 	while ((c =3D getopt(argc, argv, "b:i:npstv")) !=3D EOF) {
 		switch (c) {
@@ -2188,7 +2374,6 @@
 	char			*endptr;
 	int			freeseen;
 	freetab_t		*freetab;
-	xfs_dahash_t		hash;
 	int			i;
 	int			lastfree;
 	int			lastfree_err;
@@ -2308,8 +2493,18 @@
 		tag_err +=3D INT_GET(*tagp, ARCH_CONVERT) !=3D (char *)dep - (char *)=
data;
 		addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db,
 			(char *)dep - (char *)data);
-		hash =3D libxfs_da_hashname((uchar_t *)dep->name, dep->namelen);
-		dir_hash_add(hash, addr);
+		if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+				xfs_unicode_validate((uchar_t *)dep->name,
+					dep->namelen) !=3D 0) {
+			if (!sflag)
+				dbprintf("dir %lld block %d invalid UTF-8 "
+					"name in entry at %d\n",
+					id->ino, dabno,
+					(int)((char *)dep - (char *)data));
+			error++;
+			break;
+		}
+		dir_hash_add((uchar_t *)dep->name, dep->namelen, addr);
 		ptr +=3D XFS_DIR2_DATA_ENTSIZE(dep->namelen);
 		count++;
 		lastfree =3D 0;
@@ -2744,6 +2939,10 @@
 			type =3D DBM_RTSUM;
 			blkmap =3D blkmap_alloc(dic->di_nextents);
 			addlink_inode(id);
+		} else if (id->ino =3D=3D mp->m_sb.sb_cftino) {
+			type =3D DBM_CFT;
+			blkmap =3D blkmap_alloc(dic->di_nextents);
+			addlink_inode(id);
 		}
 		else if (id->ino =3D=3D mp->m_sb.sb_uquotino ||
 			 id->ino =3D=3D mp->m_sb.sb_gquotino) {
@@ -2776,8 +2975,9 @@
 			&nextents, &blkmap, XFS_DATA_FORK);
 		break;
 	case XFS_DINODE_FMT_EXTENTS:
-		process_exinode(id, dip, type, &totdblocks, &totiblocks,
-			&nextents, &blkmap, XFS_DATA_FORK);
+		if (type !=3D DBM_CFT)
+			process_exinode(id, dip, type, &totdblocks, &totiblocks,
+				&nextents, &blkmap, XFS_DATA_FORK);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		process_btinode(id, dip, type, &totdblocks, &totiblocks,
@@ -2801,6 +3001,8 @@
 			break;
 		}
 	}
+	if (type =3D=3D DBM_CFT)
+		return;  /* already checked enough in check_cft from init */
 	if (qgdo || qpdo || qudo) {
 		switch (type) {
 		case DBM_DATA:
@@ -2854,6 +3056,7 @@
 		process_rtbitmap(blkmap);
 	else if (type =3D=3D DBM_RTSUM)
 		process_rtsummary(blkmap);
+
 	/*
 	 * If the CHKD flag is not set, this can legitimately contain garbage;=

 	 * xfs_repair may have cleared that bit.
@@ -3634,6 +3837,15 @@
 		lino =3D XFS_DIR2_SF_GET_INUMBER(sf, XFS_DIR2_SF_INUMBERP(sfe));
 		if (lino > XFS_DIR2_MAX_SHORT_INUM)
 			i8++;
+		if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+				xfs_unicode_validate((uchar_t *)sfe->name,
+					sfe->namelen) !=3D 0) {
+			if (!sflag)
+				dbprintf("dir %lld invalid UTF-8 name in "
+					"entry at offset %d\n",
+					id->ino, XFS_DIR2_SF_GET_OFFSET(sfe));
+			error++;
+		}
 		cid =3D find_inode(lino, 1);
 		if (cid =3D=3D NULL) {
 			if (!sflag)
Index: ci/xfsprogs/repair/dino_chunks.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dino_chunks.c	2008-01-18 14:50:42.000000000 =
+1100
+++ ci/xfsprogs/repair/dino_chunks.c	2008-01-18 15:00:09.080564844 +1100=

@@ -885,6 +885,21 @@
 						XFS_AGINO_TO_INO(mp, agno,
 						agino));
 				}
+			} else if (mp->m_sb.sb_cftino =3D=3D
+					XFS_AGINO_TO_INO(mp, agno, agino)) {
+				mp->m_sb.sb_cftino =3D 0;
+
+				if (!no_modify)  {
+					do_warn(_("cleared case fold table "
+						  "inode %llu\n"),
+						XFS_AGINO_TO_INO(mp, agno,
+						agino));
+				} else  {
+					do_warn(_("would clear case fold table"
+						  " inode %llu\n"),
+						XFS_AGINO_TO_INO(mp, agno,
+						agino));
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %llu\n"),
 					XFS_AGINO_TO_INO(mp, agno, agino));
Index: ci/xfsprogs/repair/phase2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase2.c	2008-01-18 14:50:42.000000000 +1100=

+++ ci/xfsprogs/repair/phase2.c	2008-01-18 15:00:09.080564844 +1100
@@ -168,8 +168,15 @@
 				(xfs_agino_t) mp->m_sb.sb_rootino);
 		set_inode_used(ino_rec, 1);
 		set_inode_used(ino_rec, 2);
+		j =3D 3;
+		/* if using unicode filenames, mark the next inode too */
+		if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+			ASSERT(mp->m_sb.sb_cftino =3D=3D mp->m_sb.sb_rootino + 3);
+			set_inode_used(ino_rec, 3);
+			j++;
+		}
 =

-		for (j =3D 3; j < XFS_INODES_PER_CHUNK; j++)
+		for (; j < XFS_INODES_PER_CHUNK; j++)
 			set_inode_free(ino_rec, j);
 =

 		/*
@@ -212,5 +219,15 @@
 			else
 				do_warn(_("would correct\n"));
 		}
+
+		if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+				is_inode_free(ino_rec, 3)) {
+			do_warn(_("casefold table inode marked free, "));
+			set_inode_used(ino_rec, 3);
+			if (!no_modify)
+				do_warn(_("correcting\n"));
+			else
+				do_warn(_("would correct\n"));
+		}
 	}
 }
Index: ci/xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/xfs_repair.c	2008-01-18 14:50:42.000000000 +=
1100
+++ ci/xfsprogs/repair/xfs_repair.c	2008-01-18 15:00:09.084564331 +1100
@@ -451,6 +451,26 @@
 		mp->m_sb.sb_rsumino =3D first_prealloc_ino + 2;
 	}
 =

+	if (xfs_sb_version_hasunicode(&mp->m_sb) &&
+			mp->m_sb.sb_cftino !=3D first_prealloc_ino + 3) {
+		do_warn(_("sb casefold table inode %llu %sinconsistent with "
+			"calculated value %lu\n"), mp->m_sb.sb_cftino,
+			(mp->m_sb.sb_cftino =3D=3D NULLFSINO ? "(NULLFSINO) ":""),
+			first_prealloc_ino + 3);
+
+		if (!no_modify)
+			do_warn(_("resetting superblock casefold table ino "
+				"pointer to %lu\n"), first_prealloc_ino + 3);
+		else
+			do_warn(_("would reset superblock realtime summary ino "
+				"pointer to %lu\n"), first_prealloc_ino + 3);
+
+		/*
+		 * just set the value -- safe since the superblock
+		 * doesn't get flushed out if no_modify is set
+		 */
+		mp->m_sb.sb_cftino =3D first_prealloc_ino + 3;
+	}
 }
 =

 int
Index: ci/xfsprogs/repair/dinode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/dinode.c	2008-01-18 14:57:36.000000000 +1100=

+++ ci/xfsprogs/repair/dinode.c	2008-01-18 15:00:09.088563817 +1100
@@ -17,6 +17,7 @@
  */
 =

 #include <libxfs.h>
+#include <casefoldtable.h>
 #include "avl.h"
 #include "globals.h"
 #include "agheader.h"
@@ -1670,6 +1671,100 @@
 }
 =

 /*
+ * make sure the header of the case folding table is valid
+ */
+static int
+process_cft(
+	xfs_mount_t	*mp,
+	xfs_ino_t	lino,
+	xfs_dinode_t	*dino,
+	blkmap_t	*blkmap)
+{
+	int		rval =3D 1;
+	xfs_dcft_t	*cft;
+	int		size;
+	int		off;
+	int		i;
+	xfs_dfsbno_t	fsbno;
+	xfs_buf_t	*bp;
+	int		ntables;
+	int		lower_off;
+
+	/*
+	 * Already confirmed it's in extents, read all the blocks and
+	 * verify the header. Without CRCs, cannot verify the actual
+	 * table. If we find anything invalid, just junk it now and
+	 * it will be rebuilt later in Phase 6.
+	 */
+
+	cft =3D malloc(sizeof(xfs_dcft_t) + sizeof(__be32) *
+			XFS_CFT_MAX_NUM_TABLES);
+	if (!cft)
+		do_error(_("cannot allocate memory for CFT header\n"));
+
+	/* make sure we can read the entire table */
+	size =3D (int)be64_to_cpu(dino->di_core.di_size);
+	off =3D i =3D 0;
+	while (off < size) {
+		fsbno =3D blkmap_get(blkmap, i);
+		if (fsbno !=3D NULLDFSBNO)
+			bp =3D libxfs_readbuf(mp->m_dev,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, 1), 0);
+		if (!bp || fsbno =3D=3D NULLDFSBNO) {
+			do_warn(_("cannot read casefold table inode %llu, "
+					"disk block %llu\n"), lino, fsbno);
+			goto bad_out;
+		}
+		if (i =3D=3D 0)
+			memcpy(cft, XFS_BUF_PTR(bp), sizeof(xfs_dcft_t) +
+				sizeof(__be32) * XFS_CFT_MAX_NUM_TABLES);
+		off +=3D XFS_BUF_SIZE(bp);
+		libxfs_putbuf(bp);
+		libxfs_purgebuf(bp);
+		i++;
+	}
+
+	/* verify contents of the header */
+	if (be32_to_cpu(cft->cft_magic) !=3D XFS_CFT_MAGIC) {
+		do_warn(_("bad magic number 0x%x in casefold table (ino %llu)\n"),
+				be32_to_cpu(cft->cft_magic), lino);
+		goto bad_out;
+	}
+	if (be32_to_cpu(cft->cft_flags) > XFS_CFT_FLAG_MAX) {
+		do_warn(_("invalid flags (0x%x) in casefold table (ino %llu)\n"),
+				be32_to_cpu(cft->cft_flags), lino);
+		goto bad_out;
+	}
+	if (platform_uuid_compare(&cft->cft_uuid, &mp->m_sb.sb_uuid) !=3D 0) {=

+		do_warn(_("mismatched UUID in casefold table (ino %llu)\n"),
+				lino);
+		goto bad_out;
+	}
+	ntables =3D be32_to_cpu(cft->cft_num_tables);
+	if (ntables < XFS_CFT_MIN_NUM_TABLES ||
+			ntables > XFS_CFT_MAX_NUM_TABLES) {
+		do_warn(_("invalid number of tables (%d) in casefold table "
+				"(ino %llu)\n"), ntables, lino);
+		goto bad_out;
+	}
+	lower_off =3D sizeof(xfs_dcft_t) + sizeof(__be32) * (ntables - 1);
+	for (i =3D 0; i < ntables; i++) {
+		off =3D be32_to_cpu(cft->cft_table_offset[i]);
+		if (off < lower_off || off > size) {
+			do_warn(_("invalid table offset (%d) in casefold table "
+					"(ino %llu)\n"), off, lino);
+			goto bad_out;
+		}
+		lower_off =3D off + sizeof(__be16);
+	}
+	rval =3D 0;
+bad_out:
+	free(cft);
+	return rval;
+}
+
+/*
  * called to process the set of misc inode special inode types
  * that have no associated data storage (fifos, pipes, devices, etc.).
  */
@@ -1903,6 +1998,16 @@
 		}
 		return 0;
 	}
+	if (lino =3D=3D mp->m_sb.sb_cftino) {
+		if (*type !=3D XR_INO_DATA) {
+			do_warn(_("casefold table inode %llu has bad type 0x%x\n"),
+				lino, dinode_fmt(dinoc));
+			mp->m_sb.sb_cftino =3D NULLFSINO;
+			return 1;
+		}
+		*type =3D XR_INO_CFT;
+		return 0;
+	}
 	return 0;
 }
 =

@@ -2770,6 +2875,13 @@
 			goto clear_bad_out;
 		}
 		break;
+	case XR_INO_CFT:
+		if (process_cft(mp, lino, dino, dblkmap) !=3D 0) {
+			do_warn(_("problem with casefold table in inode %llu\n"),
+				lino);
+			goto clear_bad_out;
+		}
+		break;
 	default:
 		break;
 	}
Index: ci/xfsprogs/db/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/Makefile	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/Makefile	2008-01-18 15:00:09.088563817 +1100
@@ -8,7 +8,7 @@
 LTCOMMAND =3D xfs_db
 =

 HFILES =3D addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h b=
map.h \
-	bmapbt.h bmroot.h bnobt.h check.h cntbt.h command.h convert.h \
+	bmapbt.h bmroot.h bnobt.h cft.h check.h cntbt.h command.h convert.h \
 	dbread.h debug.h dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h \
 	faddr.h field.h flist.h fprint.h frag.h freesp.h hash.h help.h \
 	init.h inobt.h inode.h input.h io.h malloc.h metadump.h output.h \
Index: ci/xfsprogs/db/command.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/command.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/command.c	2008-01-18 15:00:09.088563817 +1100
@@ -33,6 +33,7 @@
 #include "agf.h"
 #include "agfl.h"
 #include "agi.h"
+#include "cft.h"
 #include "frag.h"
 #include "freesp.h"
 #include "help.h"
@@ -121,6 +122,7 @@
 	attrset_init();
 	block_init();
 	bmap_init();
+	cft_init();
 	check_init();
 	convert_init();
 	debug_init();
Index: ci/xfsprogs/db/field.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/field.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/field.c	2008-01-18 15:00:09.092563304 +1100
@@ -39,6 +39,7 @@
 #include "dquot.h"
 #include "dir2.h"
 #include "dir2sf.h"
+#include "cft.h"
 =

 const ftattr_t	ftattrtab[] =3D {
 	{ FLDT_AEXTNUM, "aextnum", fp_num, "%d", SI(bitsz(xfs_aextnum_t)),
@@ -133,6 +134,8 @@
 	  0, fa_cfileoffd, NULL },
 	{ FLDT_CFSBLOCK, "cfsblock", fp_num, "%llu", SI(BMBT_STARTBLOCK_BITLEN=
),
 	  0, fa_cfsblock, NULL },
+	{ FLDT_CFT, "cft", NULL, (char *)cft_flds, cft_size, FTARG_SIZE, NULL,=

+	  cft_flds },
 	{ FLDT_CHARNS, "charns", fp_charns, NULL, SI(bitsz(char)), 0, NULL,
 	  NULL },
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },=

Index: ci/xfsprogs/db/field.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/field.h	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/field.h	2008-01-18 15:00:09.092563304 +1100
@@ -61,6 +61,7 @@
 	FLDT_CFILEOFFA,
 	FLDT_CFILEOFFD,
 	FLDT_CFSBLOCK,
+	FLDT_CFT,
 	FLDT_CHARNS,
 	FLDT_CHARS,
 	FLDT_CNTBT,
Index: ci/xfsprogs/db/inode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/inode.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/inode.c	2008-01-18 15:00:09.092563304 +1100
@@ -410,6 +410,8 @@
 		else if (iocur_top->ino =3D=3D mp->m_sb.sb_uquotino ||
 			 iocur_top->ino =3D=3D mp->m_sb.sb_gquotino)
 			return TYP_DQBLK;
+		else if (iocur_top->ino =3D=3D mp->m_sb.sb_cftino)
+			return TYP_CFT;
 		else
 			return TYP_DATA;
 	default:
Index: ci/xfsprogs/db/metadump.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/metadump.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/metadump.c	2008-01-18 15:00:09.096562791 +1100
@@ -1537,6 +1537,9 @@
 	if (!copy_ino(mp->m_sb.sb_rsumino, TYP_RTSUMMARY))
 		return 0;
 =

+	if (!copy_ino(mp->m_sb.sb_cftino, TYP_CFT))
+		return 0;
+
 	if (!copy_ino(mp->m_sb.sb_uquotino, TYP_DQBLK))
 		return 0;
 =

Index: ci/xfsprogs/db/sb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/sb.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/sb.c	2008-01-18 15:00:09.096562791 +1100
@@ -108,6 +108,7 @@
 	{ "logsectsize", FLDT_UINT16D, OI(OFF(logsectsize)), C1, 0, TYP_NONE }=
,
 	{ "logsunit", FLDT_UINT32D, OI(OFF(logsunit)), C1, 0, TYP_NONE },
 	{ "features2", FLDT_UINT32X, OI(OFF(features2)), C1, 0, TYP_NONE },
+	{ "cftino", FLDT_INO, OI(OFF(cftino)), C1, 0, TYP_INODE },
 	{ NULL }
 };
 =

@@ -604,12 +605,16 @@
 		strcat(s, ",EXTFLG");
 	if (XFS_SB_VERSION_HASSECTOR(sbp))
 		strcat(s, ",SECTOR");
+	if (xfs_sb_version_hasoldci(sbp))
+		strcat(s, ",OLDCI");
 	if (XFS_SB_VERSION_HASMOREBITS(sbp))
 		strcat(s, ",MOREBITS");
 	if (XFS_SB_VERSION_HASATTR2(sbp))
 		strcat(s, ",ATTR2");
 	if (XFS_SB_VERSION_LAZYSBCOUNT(sbp))
 		strcat(s, ",LAZYSBCOUNT");
+	if (xfs_sb_version_hasunicode(sbp))
+		strcat(s, ",UNICODE");
 	return s;
 }
 =

Index: ci/xfsprogs/db/type.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/type.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/type.c	2008-01-18 15:00:09.096562791 +1100
@@ -43,6 +43,7 @@
 #include "dquot.h"
 #include "dir2.h"
 #include "text.h"
+#include "cft.h"
 =

 static const typ_t	*findtyp(char *name);
 static int		type_f(int argc, char **argv);
@@ -61,6 +62,7 @@
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld },
+	{ TYP_CFT, "cft", handle_struct, cft_hfld },
 	{ TYP_CNTBT, "cntbt", handle_struct, cntbt_hfld },
 	{ TYP_DATA, "data", handle_block, NULL },
 	{ TYP_DIR, "dir", handle_struct, dir_hfld },
Index: ci/xfsprogs/db/type.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/type.h	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/db/type.h	2008-01-18 15:00:09.096562791 +1100
@@ -24,7 +24,7 @@
 typedef enum typnm
 {
 	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
-	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_DATA, TYP_DIR,
+	TYP_BMAPBTD, TYP_BNOBT, TYP_CFT, TYP_CNTBT, TYP_DATA, TYP_DIR,
 	TYP_DIR2, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
 	TYP_TEXT, TYP_NONE
Index: ci/xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/libxfs.h	2008-01-18 14:50:42.000000000 +110=
0
+++ ci/xfsprogs/include/libxfs.h	2008-01-18 15:00:09.112560739 +1100
@@ -22,7 +22,7 @@
 #define XFS_BIG_BLKNOS	1
 =

 #include <xfs/platform_defs.h>
-
+#include <ctype.h>
 #include <pthread.h>
 #include <xfs/list.h>
 #include <xfs/cache.h>
@@ -50,6 +50,7 @@
 #include <xfs/xfs_alloc.h>
 #include <xfs/xfs_btree.h>
 #include <xfs/xfs_bmap.h>
+#include <xfs/xfs_unicode.h>
 =

 =

 #ifndef XFS_SUPER_MAGIC
@@ -175,6 +176,9 @@
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_dirversion;	/* 1 or 2 */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
+	const struct xfs_nameops *m_attrnameops;/* vector of attr name ops */
+	const struct xfs_cft	*m_cft;		/* unicode case fold table */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
@@ -401,7 +405,6 @@
 extern void	libxfs_free (void *);
 extern void	*libxfs_realloc (void *, size_t);
 =

-
 /*
  * Inode interface
  */
@@ -525,6 +528,10 @@
  * All other routines we want to keep common...
  */
 =

+extern const struct xfs_nameops xfs_default_nameops;
+extern const struct xfs_nameops xfs_unicode_nameops;
+extern const struct xfs_nameops xfs_unicode_ci_nameops;
+
 extern int	libxfs_highbit32 (__uint32_t);
 extern int	libxfs_highbit64 (__uint64_t);
 extern uint	libxfs_da_log2_roundup (uint);
@@ -556,6 +563,7 @@
 				xfs_extlen_t);
 =

 /* Directory/Attribute routines used by xfs_repair */
+extern void	libxfs_attr_mount(xfs_mount_t *);
 extern void	libxfs_da_bjoin (xfs_trans_t *, xfs_dabuf_t *);
 extern int	libxfs_da_shrink_inode (xfs_da_args_t *, xfs_dablk_t,
 				xfs_dabuf_t *);
Index: ci/xfsprogs/include/xfs_attr_leaf.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_attr_leaf.h	2008-01-18 14:50:42.0000000=
00 +1100
+++ ci/xfsprogs/include/xfs_attr_leaf.h	2008-01-18 15:00:09.116560225 +1=
100
@@ -36,6 +36,7 @@
 struct xfs_da_state;
 struct xfs_da_state_blk;
 struct xfs_inode;
+struct xfs_mount;
 struct xfs_trans;
 =

 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
@@ -192,6 +193,12 @@
 	return (((bsize) >> 1) + ((bsize) >> 2));
 }
 =

+/*
+ * Do hash based on nameops
+ */
+#define xfs_attr_hashname(dp, n, l) \
+		((dp)->i_mount->m_attrnameops->hashname((dp), (n), (l)))
+
 =

 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Structure used to pass context around among the routines.
@@ -274,6 +281,7 @@
 /*
  * Utility routines.
  */
+void	xfs_attr_mount(struct xfs_mount *mp);
 xfs_dahash_t	xfs_attr_leaf_lasthash(struct xfs_dabuf *bp, int *count);
 int	xfs_attr_leaf_order(struct xfs_dabuf *leaf1_bp,
 				   struct xfs_dabuf *leaf2_bp);
Index: ci/xfsprogs/include/xfs_da_btree.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_da_btree.h	2008-01-18 14:50:42.00000000=
0 +1100
+++ ci/xfsprogs/include/xfs_da_btree.h	2008-01-18 15:00:09.124559199 +11=
00
@@ -103,6 +103,15 @@
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

 /*
+ * Search comparison results
+ */
+typedef enum {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+} xfs_dacmp_t;
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
@@ -205,12 +214,37 @@
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
 =

+/*
+ * Name ops for directory and/or attr name operations
+ */
+
+typedef xfs_dahash_t	(*xfs_hashname_t)(struct xfs_inode *, const uchar_=
t *,
+					int);
+typedef xfs_dacmp_t	(*xfs_compname_t)(struct xfs_inode *, const uchar_t=
 *,
+					int, const uchar_t *, int);
+
+typedef struct xfs_nameops {
+	xfs_hashname_t		hashname;
+	xfs_compname_t		compname;
+} xfs_nameops_t;
+
 =

 #ifdef __KERNEL__
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  * Function prototypes for the kernel.
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

+extern const struct xfs_nameops xfs_default_nameops;
+extern const struct xfs_nameops xfs_unicode_nameops;
+extern const struct xfs_nameops xfs_unicode_ci_nameops;
+
+xfs_dacmp_t xfs_default_compname(struct xfs_inode *inode, const uchar_t=
 *name1,
+				int len1, const uchar_t *name2, int len2);
+
+int	xfs_da_setup_name_and_hash(xfs_da_args_t *args, const uchar_t *name=
,
+				int namelen);
+void	xfs_da_cleanup_name(xfs_da_args_t *args, const uchar_t *name);
+
 /*
  * Routines used for growing the Btree.
  */
Index: ci/xfsprogs/include/xfs_dir2.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_dir2.h	2008-01-18 14:50:42.000000000 +1=
100
+++ ci/xfsprogs/include/xfs_dir2.h	2008-01-18 15:00:09.124559199 +1100
@@ -72,6 +72,13 @@
 	struct uio	*uio;		/* uio control structure */
 } xfs_dir2_put_args_t;
 =

+#define xfs_dir_hashname(dp, n, l) \
+		((dp)->i_mount->m_dirnameops->hashname((dp), (n), (l)))
+
+#define xfs_dir_compname(dp, n1, l1, n2, l2) \
+		((dp)->i_mount->m_dirnameops->compname((dp), (n1), (l1), \
+							(n2), (l2)))
+
 /*
  * Other interfaces used by the rest of the dir v2 code.
  */
Index: ci/xfsprogs/include/xfs_unicode.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/include/xfs_unicode.h	2008-01-18 15:00:09.128558686 +110=
0
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_UNICODE_H__
+#define __XFS_UNICODE_H__
+
+#define XFS_CFT_MAGIC		0x58434654	/* 'XCFT' */
+#define XFS_CFT_FLAG_TURKIC	0x00000001
+#define XFS_CFT_FLAG_MAX	0x00000001
+
+/*
+ * Case Fold Table - on disk version. Must match the incore version bel=
ow.
+ */
+typedef struct xfs_dcft {
+	__be32			cft_magic;	/* validity check */
+	__be32			cft_flags;
+	uuid_t			cft_uuid;	/* UUID of the filesystem */
+	__be32			cft_crc;	/* for future support */
+	__be32			cft_num_tables;	/* single, double, etc */
+	__be32			cft_table_offset[1];
+} xfs_dcft_t;
+
+/*
+ * Case Fold Table - in core version. Must match the ondisk version abo=
ve.
+ */
+typedef struct xfs_cft {
+	__uint32_t		cft_magic;
+	__uint32_t		cft_flags;
+	uuid_t			cft_uuid;	/* UUID of the filesystem */
+	__uint32_t		cft_crc;
+	__uint32_t		cft_num_tables;	/* single, double, etc */
+	__uint32_t		cft_table_offset[1];/* num_tables sized */
+	/* 16-bit array tables immediately follow */
+} xfs_cft_t;
+
+#define XFS_CFT_PTR(t,n)	(__uint16_t *)(((char *)(t)) + \
+					(t)->cft_table_offset[n])
+#define XFS_DCFT_PTR(t,n)	(__be16 *)(((char *)(t)) + \
+					be32_to_cpu((t)->cft_table_offset[n]))
+
+__uint32_t xfs_unicode_hash(const xfs_cft_t *cft,
+				const uchar_t *name, int namelen);
+
+int xfs_unicode_casecmp(const xfs_cft_t *cft, const uchar_t *name1,
+				int len1, const uchar_t *name2, int len2);
+
+char *xfs_alloc_unicode_nls_name(void);
+void xfs_free_unicode_nls_name(char *name);
+
+int xfs_unicode_validate(const uchar_t *name, int namelen);
+
+int xfs_unicode_read_cft(struct xfs_mount *mp);
+void xfs_unicode_free_cft(const xfs_cft_t *cft);
+
+#endif /* __XFS_UNICODE_H__ */
Index: ci/xfsprogs/libxfs/init.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/init.c	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/libxfs/init.c	2008-01-18 15:00:09.136557660 +1100
@@ -579,10 +579,14 @@
 	else
 		libxfs_dir_mount(mp);
 =

-	/* Initialize cached values for the attribute manager */
-	mp->m_attr_magicpct =3D (mp->m_sb.sb_blocksize * 37) / 100;
+	/*
+	 * Initialize the attribute manager's entries.
+	 */
+	libxfs_attr_mount(mp);
 =

-	/* Initialize the precomputed transaction reservations values */
+	/*
+	 * Initialize the precomputed transaction reservations values.
+	 */
 	libxfs_trans_init(mp);
 =

 	if (dev =3D=3D 0)	/* maxtrres, we have no device so leave now */
Index: ci/xfsprogs/libxfs/xfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs.h	2008-01-18 14:50:42.000000000 +1100
+++ ci/xfsprogs/libxfs/xfs.h	2008-01-18 15:00:09.136557660 +1100
@@ -95,6 +95,8 @@
 #define xfs_itobp			libxfs_itobp
 #define xfs_iformat			libxfs_iformat
 #define xfs_ichgtime			libxfs_ichgtime
+#define xfs_iget(m,t,i,f,lf,ip,b)	libxfs_iget(m,t,i,lf,ip,b)
+#define xfs_iput			libxfs_iput
 #define xfs_bmapi			libxfs_bmapi
 #define xfs_bmapi_single		libxfs_bmapi_single
 #define xfs_bmap_finish			libxfs_bmap_finish
@@ -146,6 +148,7 @@
 #define xfs_dir2_data_freescan		libxfs_dir2_data_freescan
 #define xfs_dir2_free_log_bests		libxfs_dir2_free_log_bests
 =

+#define xfs_attr_mount			libxfs_attr_mount
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_set_int		libxfs_attr_set_int
 #define xfs_attr_remove_int		libxfs_attr_remove_int
@@ -175,7 +178,7 @@
 #define xfs_validate_extents(e,n,d,f)	((void) 0)	/* debug only */
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_read_buf(mp,devp,blkno,len,f,bpp)	\
-	( *(bpp) =3D libxfs_readbuf( *(dev_t*)devp, (blkno), (len), 1), 0 )
+	( *(bpp) =3D libxfs_readbuf((devp), (blkno), (len), 1), 0 )
 #define xfs_buf_get_flags(devp,blkno,len,f)	\
 	( libxfs_getbuf( devp, (blkno), (len) ) )
 #define xfs_bwrite(mp,bp)		libxfs_writebuf((bp), 0)
@@ -205,10 +208,13 @@
 #define kmem_zone_alloc(z, f)	libxfs_zone_zalloc(z)
 #define kmem_zone_zalloc(z, f)	libxfs_zone_zalloc(z)
 #define kmem_zone_free(z, p)	libxfs_zone_free(z, p)
+#define kmem_zone_destroy(z)	((void) 0)
 #define kmem_realloc(p,sz,u,f)	libxfs_realloc(p,sz)
 #define kmem_zalloc(size, f)	libxfs_malloc(size)
 #define kmem_alloc(size, f)	libxfs_malloc(size)
 #define kmem_free(p, size)	libxfs_free(p)
+#define vmalloc(size)		libxfs_malloc(size)
+#define vfree(p)		libxfs_free(p)
 =

 /* directory management */
 #define xfs_dir2_trace_args(where, args)		((void) 0)
@@ -288,6 +294,8 @@
 #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
 #define XFS_MOUNT_32BITINOOPT		LIBXFS_MOUNT_32BITINOOPT
 #define XFS_MOUNT_COMPAT_ATTR		LIBXFS_MOUNT_COMPAT_ATTR
+#define XFS_MOUNT_CI_LOOKUP		0	/* ignored in userspace */
+#define XFS_MOUNT_CI_ATTR		0	/* ignored in userspace */
 #define XFS_ILOCK_EXCL			0
 #define xfs_sort			qsort
 #define down_read(a)			((void) 0)
@@ -300,6 +308,10 @@
 #define spinlock_init(a,b)		((void) 0)
 #define spin_lock(a)			((void) 0)
 #define spin_unlock(a)			((void) 0)
+#define mutex_t				int
+#define mutex_init(a)			((void) 0)
+#define mutex_lock(a)			((void) 0)
+#define mutex_unlock(a)			((void) 0)
 #define xfs_btree_reada_bufl(m,fsb,c)	((void) 0)
 #define xfs_btree_reada_bufs(m,fsb,c,x)	((void) 0)
 #define XFS_SB_LOCK(mp)			0
@@ -559,6 +571,10 @@
 			xfs_alloc_key_t *, xfs_btree_cur_t **, int *);
 =

 /* xfs_da_btree.c */
+xfs_dacmp_t xfs_default_compname(struct xfs_inode *, const uchar_t *, i=
nt,
+			const uchar_t *, int);
+int  xfs_da_setup_name_and_hash(xfs_da_args_t *, const uchar_t *, int);=

+void xfs_da_cleanup_name(xfs_da_args_t *, const uchar_t *);
 xfs_dabuf_t *xfs_da_buf_make (int, xfs_buf_t **, inst_t *);
 void xfs_da_binval (struct xfs_trans *, xfs_dabuf_t *);
 void xfs_da_buf_done (xfs_dabuf_t *);
@@ -678,6 +694,8 @@
 void xfs_trans_mod_sb (xfs_trans_t *, uint, long);
 int  xfs_trans_unlock_chunk (xfs_log_item_chunk_t *, int, int, xfs_lsn_=
t);
 =

+int  utf8_mbtowc(wchar_t *p, const __u8 *s, int n);
+int  utf8_wctomb(__u8 *s, wchar_t wc, int maxlen);
 =

 #ifndef DEBUG
 #define xfs_inobp_check(mp,bp)				((void) 0)
Index: ci/xfsprogs/libxfs/xfs_attr.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_attr.c	2008-01-18 14:50:42.000000000 +11=
00
+++ ci/xfsprogs/libxfs/xfs_attr.c	2008-01-18 15:00:09.144556633 +1100
@@ -64,6 +64,17 @@
  * Overall external interface routines.
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/
 =

+void
+xfs_attr_mount(struct xfs_mount *mp)
+{
+	mp->m_attr_magicpct =3D (mp->m_sb.sb_blocksize * 37) / 100;
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_attrnameops =3D (mp->m_flags & XFS_MOUNT_CI_ATTR) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_attrnameops =3D &xfs_default_nameops;
+}
+
 int
 xfs_attr_set_int(xfs_inode_t *dp, const char *name, int namelen,
 		 char *value, int valuelen, int flags)
@@ -103,18 +114,18 @@
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D (const uchar_t *)name;
-	args.namelen =3D namelen;
 	args.value =3D (uchar_t *)value;
 	args.valuelen =3D valuelen;
 	args.flags =3D flags;
-	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D dp;
 	args.firstblock =3D &firstblock;
 	args.flist =3D &flist;
 	args.whichfork =3D XFS_ATTR_FORK;
 	args.addname =3D 1;
 	args.oknoent =3D 1;
+	error =3D xfs_da_setup_name_and_hash(&args, (uchar_t *)name, namelen);=

+	if (error)
+		return error;
 =

 	nblks =3D XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	if (local) {
@@ -159,6 +170,7 @@
 				      0, XFS_TRANS_PERM_LOG_RES,
 				      XFS_ATTRSET_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
+		xfs_da_cleanup_name(&args, (uchar_t *)name);
 		return(error);
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -169,6 +181,7 @@
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_da_cleanup_name(&args, (uchar_t *)name);
 		return (error);
 	}
 =

@@ -220,6 +233,7 @@
 			if (!error && (flags & ATTR_KERNOTIME) =3D=3D 0) {
 				xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 			}
+			xfs_da_cleanup_name(&args, (uchar_t *)name);
 			return(error =3D=3D 0 ? err2 : error);
 		}
 =

@@ -290,6 +304,7 @@
 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 =

+	xfs_da_cleanup_name(&args, (uchar_t *)name);
 	return(error);
 =

 out:
@@ -297,6 +312,7 @@
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_da_cleanup_name(&args, (uchar_t *)name);
 	return(error);
 }
 =

@@ -313,21 +329,23 @@
 	 * Fill in the arg structure for this request.
 	 */
 	memset((char *)&args, 0, sizeof(args));
-	args.name =3D (const uchar_t *)name;
-	args.namelen =3D namelen;
 	args.flags =3D flags;
-	args.hashval =3D xfs_da_hashname(args.name, args.namelen);
 	args.dp =3D dp;
 	args.firstblock =3D &firstblock;
 	args.flist =3D &flist;
 	args.total =3D 0;
 	args.whichfork =3D XFS_ATTR_FORK;
+	error =3D xfs_da_setup_name_and_hash(&args, (uchar_t *)name, namelen);=

+	if (error)
+		return error;
 =

 	/*
 	 * Attach the dquots to the inode.
 	 */
-	if ((error =3D XFS_QM_DQATTACH(mp, dp, 0)))
+	if ((error =3D XFS_QM_DQATTACH(mp, dp, 0))) {
+		xfs_da_cleanup_name(&args, (uchar_t *)name);
 		return (error);
+	}
 =

 	/*
 	 * Start our first transaction of the day.
@@ -355,6 +373,7 @@
 				      0, XFS_TRANS_PERM_LOG_RES,
 				      XFS_ATTRRM_LOG_COUNT))) {
 		xfs_trans_cancel(args.trans, 0);
+		xfs_da_cleanup_name(&args, (uchar_t *)name);
 		return(error);
 	}
 =

@@ -413,6 +432,7 @@
 		xfs_ichgtime(dp, XFS_ICHGTIME_CHG);
 	}
 =

+	xfs_da_cleanup_name(&args, (uchar_t *)name);
 	return(error);
 =

 out:
@@ -420,6 +440,7 @@
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_da_cleanup_name(&args, (uchar_t *)name);
 	return(error);
 }
 =

Index: ci/xfsprogs/libxfs/xfs_attr_leaf.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_attr_leaf.c	2008-01-18 14:50:42.00000000=
0 +1100
+++ ci/xfsprogs/libxfs/xfs_attr_leaf.c	2008-01-18 15:00:09.152555607 +11=
00
@@ -372,18 +372,19 @@
 =

 	sfe =3D &sf->list[0];
 	for (i =3D 0; i < INT_GET(sf->hdr.count, ARCH_CONVERT); i++) {
-		nargs.name =3D (const uchar_t *)sfe->nameval;
-		nargs.namelen =3D sfe->namelen;
 		nargs.value =3D (uchar_t *)&sfe->nameval[nargs.namelen];
 		nargs.valuelen =3D INT_GET(sfe->valuelen, ARCH_CONVERT);
-		nargs.hashval =3D xfs_da_hashname((const uchar_t *)sfe->nameval,
-						sfe->namelen);
+		error =3D xfs_da_setup_name_and_hash(&nargs, sfe->nameval,
+				sfe->namelen);
+		if (error)
+			goto out;
 		nargs.flags =3D (sfe->flags & XFS_ATTR_SECURE) ? ATTR_SECURE :
 				((sfe->flags & XFS_ATTR_ROOT) ? ATTR_ROOT : 0);
 		error =3D xfs_attr_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error =3D=3D ENOATTR);
 		error =3D xfs_attr_leaf_add(bp, &nargs);
 		ASSERT(error !=3D ENOSPC);
+		xfs_da_cleanup_name(&nargs, sfe->nameval);
 		if (error)
 			goto out;
 		sfe =3D XFS_ATTR_SF_NEXTENTRY(sfe);
@@ -1684,7 +1685,7 @@
 		else
 			break;
 	}
-	ASSERT((probe >=3D 0) && =

+	ASSERT((probe >=3D 0) &&
 	       (!leaf->hdr.count
 	       || (probe < INT_GET(leaf->hdr.count, ARCH_CONVERT))));
 	ASSERT((span <=3D 4) || (INT_GET(entry->hashval, ARCH_CONVERT)
Index: ci/xfsprogs/libxfs/xfs_da_btree.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_da_btree.c	2008-01-18 14:50:42.000000000=
 +1100
+++ ci/xfsprogs/libxfs/xfs_da_btree.c	2008-01-18 15:00:09.156555094 +110=
0
@@ -1540,6 +1540,92 @@
 	}
 }
 =

+
+static xfs_dahash_t
+xfs_default_hashname(xfs_inode_t *inode, const uchar_t *name, int namel=
en)
+{
+	return xfs_da_hashname(name, namelen);
+}
+
+xfs_dacmp_t
+xfs_default_compname(xfs_inode_t *inode, const uchar_t *name1, int len1=
,
+	const uchar_t *name2, int len2)
+{
+	return (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0) ?
+			XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+static xfs_dahash_t
+xfs_unicode_ci_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	return xfs_unicode_hash(inode->i_mount->m_cft, name, namelen);
+}
+
+static xfs_dacmp_t
+xfs_unicode_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	if (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0)
+		return XFS_CMP_EXACT;
+
+	return xfs_unicode_casecmp(inode->i_mount->m_cft, name1, len1,
+			name2, len2) =3D=3D 0 ? XFS_CMP_CASE : XFS_CMP_DIFFERENT;
+}
+
+const struct xfs_nameops xfs_default_nameops =3D {
+	.hashname	=3D xfs_default_hashname,
+	.compname	=3D xfs_default_compname
+};
+
+const struct xfs_nameops xfs_unicode_nameops =3D {
+	.hashname	=3D xfs_unicode_ci_hashname,
+	.compname	=3D xfs_default_compname,
+};
+
+const struct xfs_nameops xfs_unicode_ci_nameops =3D {
+	.hashname	=3D xfs_unicode_ci_hashname,
+	.compname	=3D xfs_unicode_ci_compname,
+};
+
+int
+xfs_da_setup_name_and_hash(
+	xfs_da_args_t		*args,
+	const uchar_t 		*name,
+	int			namelen)
+{
+	xfs_mount_t		*mp =3D args->dp->i_mount;
+
+	/* for libxfs usage, no extended characters should be used */
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		int	rval;
+		rval =3D xfs_unicode_validate(name, namelen);
+		if (rval < 0)
+			return -rval;
+	}
+	args->name =3D name;
+	args->namelen =3D namelen;
+	args->hashval =3D (args->whichfork =3D=3D XFS_ATTR_FORK) ?
+		xfs_attr_hashname(args->dp, args->name, args->namelen) :
+		xfs_dir_hashname(args->dp, args->name, args->namelen);
+	return 0;
+}
+
+void
+xfs_da_cleanup_name(
+	xfs_da_args_t		*args,
+	const uchar_t		*name)
+{
+	if (args->name !=3D name)
+		xfs_free_unicode_nls_name((char *)args->name);
+}
+
 /*
  * Add a block to the btree ahead of the file.
  * Return the new block number to the caller.
Index: ci/xfsprogs/libxfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2.c	2008-01-18 14:50:42.000000000 +11=
00
+++ ci/xfsprogs/libxfs/xfs_dir2.c	2008-01-18 15:00:09.168553554 +1100
@@ -23,6 +23,53 @@
 =

 #include <xfs.h>
 =

+/*
+ * V1 case-insensitive support for directories
+ */
+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name,
+	int		namelen)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i =3D 0, hash =3D 0; i < namelen; i++)
+		hash =3D tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static xfs_dacmp_t
+xfs_ascii_ci_compname(
+	xfs_inode_t	*inode,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	xfs_dacmp_t	result =3D XFS_CMP_EXACT;
+	int		i;
+
+	if (len1 !=3D len2)
+		return XFS_CMP_DIFFERENT;
+
+	for (i =3D 0; i < len1; i++) {
+		if (name1[i] =3D=3D name2[i])
+			continue;
+		if (tolower(name1[i]) !=3D tolower(name2[i]))
+			return XFS_CMP_DIFFERENT;
+		result =3D XFS_CMP_CASE;
+	}
+
+	return result;
+}
+
+static const struct xfs_nameops xfs_ascii_ci_nameops =3D {
+	.hashname	=3D xfs_ascii_ci_hashname,
+	.compname	=3D xfs_ascii_ci_compname,
+};
 =

 /*
  * Initialize directory-related fields in the mount structure.
@@ -46,6 +93,13 @@
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct =3D (mp->m_dirblksize * 37) / 100;
+
+	if (xfs_sb_version_hasunicode(&mp->m_sb)) {
+		mp->m_dirnameops =3D (mp->m_flags & XFS_MOUNT_CI_LOOKUP) ?
+			&xfs_unicode_ci_nameops : &xfs_unicode_nameops;
+	} else
+		mp->m_dirnameops =3D (xfs_sb_version_hasoldci(&mp->m_sb)) ?
+			&xfs_ascii_ci_nameops : &xfs_default_nameops;
 }
 =

 /*
@@ -71,21 +125,21 @@
 }
 =

 /*
-  Enter a name in a directory.
+ * Enter a name in a directory.
  */
-STATIC int					/* error */
+int
 xfs_dir2_createname(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*dp,		/* incore directory inode */
-	uchar_t			*name,		/* new entry name */
-	int			namelen,	/* new entry name length */
+	xfs_trans_t		*tp,
+	xfs_inode_t		*dp,
+	uchar_t			*name,
+	int			namelen,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	xfs_bmap_free_t		*flist,		/* bmap's freeblock list */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
-	xfs_da_args_t		args;		/* operation arguments */
-	int			rval;		/* return value */
+	xfs_da_args_t		args;
+	int			rval;
 	int			v;		/* type-checking value */
 =

 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
@@ -93,12 +147,7 @@
 		return rval;
 	}
 	XFS_STATS_INC(xs_dir_create);
-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -108,48 +157,45 @@
 	args.trans =3D tp;
 	args.justcheck =3D 0;
 	args.addname =3D args.oknoent =3D 1;
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
+
 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_addname(&args);
-	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_block_addname(&args);
-	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_leaf_addname(&args);
 	else
 		rval =3D xfs_dir2_node_addname(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

 /*
  * Lookup a name in a directory, give back the inode number.
  */
-STATIC int				/* error */
+int
 xfs_dir2_lookup(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_inode_t	*dp,		/* incore directory inode */
-	uchar_t		*name,		/* lookup name */
-	int		namelen,	/* lookup name length */
+	xfs_trans_t	*tp,
+	xfs_inode_t	*dp,
+	uchar_t		*name,
+	int		namelen,
 	xfs_ino_t	*inum)		/* out: inode number */
 {
-	xfs_da_args_t	args;		/* operation arguments */
-	int		rval;		/* return value */
+	xfs_da_args_t	args;
+	int		rval;
 	int		v;		/* type-checking value */
 =

 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_lookup);
 =

-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
 	args.inumber =3D 0;
 	args.dp =3D dp;
 	args.firstblock =3D NULL;
@@ -159,17 +205,20 @@
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D 0;
 	args.oknoent =3D 1;
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
+	args.value =3D NULL;	/* value may contain actual name on return */
+	args.valuelen =3D 0;
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
+
 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_lookup(&args);
 	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v))) {
-		return rval;
+		goto out;
 	} else if (v)
 		rval =3D xfs_dir2_block_lookup(&args);
 	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v))) {
-		return rval;
+		goto out;
 	} else if (v)
 		rval =3D xfs_dir2_leaf_lookup(&args);
 	else
@@ -178,35 +227,32 @@
 		rval =3D 0;
 	if (rval =3D=3D 0)
 		*inum =3D args.inumber;
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

 /*
  * Remove an entry from a directory.
  */
-STATIC int				/* error */
+int
 xfs_dir2_removename(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_inode_t	*dp,		/* incore directory inode */
-	uchar_t		*name,		/* name of entry to remove */
-	int		namelen,	/* name length of entry to remove */
-	xfs_ino_t	ino,		/* inode number of entry to remove */
+	xfs_trans_t	*tp,
+	xfs_inode_t	*dp,
+	uchar_t		*name,
+	int		namelen,
+	xfs_ino_t	ino,
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
-	xfs_da_args_t	args;		/* operation arguments */
-	int		rval;		/* return value */
+	xfs_da_args_t	args;
+	int		rval;
 	int		v;		/* type-checking value */
 =

 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 	XFS_STATS_INC(xs_dir_remove);
-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+
 	args.inumber =3D ino;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -215,53 +261,50 @@
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 0;
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
+
 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_removename(&args);
-	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_block_removename(&args);
-	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_leaf_removename(&args);
 	else
 		rval =3D xfs_dir2_node_removename(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

 /*
  * Replace the inode number of a directory entry.
  */
-STATIC int				/* error */
+int
 xfs_dir2_replace(
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_inode_t	*dp,		/* incore directory inode */
+	xfs_trans_t	*tp,
+	xfs_inode_t	*dp,
 	uchar_t		*name,		/* name of entry to replace */
-	int		namelen,	/* name length of entry to replace */
+	int		namelen,
 	xfs_ino_t	inum,		/* new inode number */
 	xfs_fsblock_t	*first,		/* bmap's firstblock */
 	xfs_bmap_free_t	*flist,		/* bmap's freeblock list */
 	xfs_extlen_t	total)		/* bmap's total block count */
 {
-	xfs_da_args_t	args;		/* operation arguments */
-	int		rval;		/* return value */
+	xfs_da_args_t	args;
+	int		rval;
 	int		v;		/* type-checking value */
 =

 	ASSERT((dp->i_d.di_mode & S_IFMT) =3D=3D S_IFDIR);
 =

-	if ((rval =3D xfs_dir_ino_validate(tp->t_mountp, inum))) {
+	if ((rval =3D xfs_dir_ino_validate(tp->t_mountp, inum)))
 		return rval;
-	}
-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	args.name =3D name;
-	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -270,21 +313,24 @@
 	args.whichfork =3D XFS_DATA_FORK;
 	args.trans =3D tp;
 	args.justcheck =3D args.addname =3D args.oknoent =3D 0;
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
+	rval =3D xfs_da_setup_name_and_hash(&args, name, namelen);
+	if (rval)
+		return rval;
+
 	if (dp->i_d.di_format =3D=3D XFS_DINODE_FMT_LOCAL)
 		rval =3D xfs_dir2_sf_replace(&args);
-	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isblock(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_block_replace(&args);
-	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v))) {
-		return rval;
-	} else if (v)
+	else if ((rval =3D xfs_dir2_isleaf(tp, dp, &v)))
+		goto out;
+	else if (v)
 		rval =3D xfs_dir2_leaf_replace(&args);
 	else
 		rval =3D xfs_dir2_node_replace(&args);
+out:
+	xfs_da_cleanup_name(&args, name);
 	return rval;
 }
 =

Index: ci/xfsprogs/libxfs/xfs_unicode.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/libxfs/xfs_unicode.c	2008-01-18 15:00:09.176552528 +1100=

@@ -0,0 +1,405 @@
+/*
+ * Copyright (c) 2007 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_alloc.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bmap.h"
+#include "xfs_unicode.h"
+
+#define MAX_FOLD_CHARS	4
+
+static kmem_zone_t	*xfs_nls_uni_zone;
+
+static inline int
+xfs_casefold(
+	const xfs_cft_t *cft,
+	__uint16_t	c,
+	__uint16_t	*fc)
+{
+	__uint16_t	*table =3D XFS_CFT_PTR(cft, 0);
+	__uint16_t	tmp =3D table[c >> 8];
+	int		i;
+
+	if (!tmp) {
+		*fc =3D c;
+		return 1;
+	}
+	tmp =3D table[tmp + (c & 0xff)];
+	if ((tmp & 0xf000) !=3D 0xe000) {
+		*fc =3D tmp;
+		return 1;
+	}
+	i =3D ((tmp >> 10) & 0x3) + 2;
+	ASSERT(i < cft->cft_num_tables);
+	table =3D XFS_CFT_PTR(cft, i - 1) + ((tmp & 0x3ff) * i);
+
+	memcpy(fc, table, sizeof(__uint16_t) * i);
+
+	return i;
+}
+
+static inline int
+xfs_utf8_casefold(
+	const xfs_cft_t	*cft,
+	const uchar_t	**name,
+	int		*namelen,
+	__uint16_t	*fc)
+{
+	wchar_t		uc;
+
+	if (*namelen =3D=3D 0)
+		return 0;
+
+	if (**name & 0x80) {
+		int	n =3D utf8_mbtowc(&uc, *name, *namelen);
+		if (n < 0) {
+			(*namelen)--;
+			*fc =3D *(*name)++;
+			return 1;
+		}
+		*name +=3D n;
+		*namelen -=3D n;
+	} else {
+		uc =3D *(*name)++;
+		(*namelen)--;
+	}
+	return xfs_casefold(cft, uc, fc);
+}
+
+__uint32_t
+xfs_unicode_hash(
+	const xfs_cft_t	*cft,
+	const uchar_t	*name,
+	int		namelen)
+{
+	__uint32_t	hash =3D 0;
+	__uint16_t	fc[MAX_FOLD_CHARS];
+	int		nfc;
+	int		i;
+
+	while (namelen > 0) {
+		nfc =3D xfs_utf8_casefold(cft, &name, &namelen, fc);
+		for (i =3D 0; i < nfc; i++)
+			hash =3D fc[i] ^ rol32(hash, 7);
+	}
+	return hash;
+}
+
+int
+xfs_unicode_casecmp(
+	const xfs_cft_t	*cft,
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int		len2)
+{
+	__uint16_t	fc1[MAX_FOLD_CHARS], fc2[MAX_FOLD_CHARS];
+	__uint16_t	*pfc1, *pfc2;
+	int		nfc1, nfc2;
+
+	nfc1 =3D xfs_utf8_casefold(cft, &name1, &len1, fc1);
+	pfc1 =3D fc1;
+	nfc2 =3D xfs_utf8_casefold(cft, &name2, &len2, fc2);
+	pfc2 =3D fc2;
+
+	while (nfc1 > 0 && nfc2 > 0) {
+		if (*pfc1 !=3D *pfc2)
+			return (*pfc1 < *pfc2) ? -1 : 1;
+		if (!--nfc1) {
+			nfc1 =3D xfs_utf8_casefold(cft, &name1, &len1, fc1);
+			pfc1 =3D fc1;
+		} else
+			pfc1++;
+		if (!--nfc2) {
+			nfc2 =3D xfs_utf8_casefold(cft, &name2, &len2, fc2);
+			pfc2 =3D fc2;
+		} else
+			pfc2++;
+	}
+	if (nfc1 !=3D nfc2)
+		return (nfc1 < nfc2) ? -1 : 1;
+	return 0;
+}
+
+
+char *
+xfs_alloc_unicode_nls_name(void)
+{
+	return kmem_zone_alloc(xfs_nls_uni_zone, KM_SLEEP);
+}
+
+
+void
+xfs_free_unicode_nls_name(
+	char		*name)
+{
+	kmem_zone_free(xfs_nls_uni_zone, name);
+}
+
+
+int
+xfs_unicode_validate(
+	const uchar_t	*name,
+	int		namelen)
+{
+	wchar_t		uc;
+	int		i, nlen;
+
+	for (i =3D 0; i < namelen; i +=3D nlen) {
+		if (*name >=3D 0xf0)
+			return -EINVAL;
+		/* utf8_mbtowc must fail on overlong sequences too */
+		nlen =3D utf8_mbtowc(&uc, name + i, namelen - i);
+		if (nlen < 0)
+			return -EILSEQ;
+		/* check for invalid/surrogate/private unicode chars */
+		if (uc >=3D 0xfffe || (uc >=3D 0xd800 && uc <=3D 0xf8ff))
+			return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * Unicode Case Fold Table management
+ */
+
+struct cft_item {
+	xfs_cft_t	*table;
+	int		size;
+	int		refcount;
+};
+
+static mutex_t		cft_lock;
+static int		cft_size;
+static struct cft_item	*cft_list;
+
+static xfs_cft_t *
+add_cft(
+	xfs_dcft_t	*dcft,
+	int		size)
+{
+	int		found =3D 0;
+	int		i, j;
+	xfs_cft_t	*cft;
+	__be16		*duc;
+	__uint16_t	*uc;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		if (cft_list[i].size !=3D size)
+			continue;
+		cft =3D cft_list[i].table;
+		if (cft->cft_num_tables !=3D be32_to_cpu(dcft->cft_num_tables) ||
+				cft->cft_flags !=3D be32_to_cpu(dcft->cft_flags))
+			continue;
+		found =3D 1;
+		for (j =3D 0; j < cft->cft_num_tables; j++) {
+			if (cft->cft_table_offset[j] !=3D
+					be32_to_cpu(dcft->cft_table_offset[j])) {
+				found =3D 0;
+				break;
+			}
+		}
+		if (found) {
+			cft_list[i].refcount++;
+			mutex_unlock(&cft_lock);
+			return cft;
+		}
+	}
+
+	cft =3D vmalloc(size);
+	if (!cft) {
+		mutex_unlock(&cft_lock);
+		return NULL;
+	}
+	cft->cft_magic =3D be32_to_cpu(dcft->cft_magic);
+	cft->cft_flags =3D be32_to_cpu(dcft->cft_flags);
+	cft->cft_num_tables =3D be32_to_cpu(dcft->cft_num_tables);
+	ASSERT(cft->cft_num_tables <=3D MAX_FOLD_CHARS);
+	for (i =3D 0; i < cft->cft_num_tables; i++)
+		cft->cft_table_offset[i] =3D be32_to_cpu(dcft->cft_table_offset[i]);
+	j =3D (size - cft->cft_table_offset[0]) / sizeof(__uint16_t);
+	uc =3D XFS_CFT_PTR(cft, 0);
+	duc =3D XFS_DCFT_PTR(dcft, 0);
+	for (i =3D 0; i < j; i++)
+		uc[i] =3D be16_to_cpu(duc[i]);
+
+	cft_list =3D kmem_realloc(cft_list,
+			(cft_size + 1) * sizeof(struct cft_item),
+			cft_size  * sizeof(struct cft_item), KM_SLEEP);
+	cft_list[cft_size].table =3D cft;
+	cft_list[cft_size].size =3D size;
+	cft_list[cft_size].refcount =3D 1;
+	cft_size++;
+
+	mutex_unlock(&cft_lock);
+
+	return cft;
+}
+
+static void
+remove_cft(
+	const xfs_cft_t	*cft)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		if (cft_list[i].table =3D=3D cft) {
+			ASSERT(cft_list[i].refcount > 0);
+			cft_list[i].refcount--;
+			break;
+		}
+	}
+
+	mutex_unlock(&cft_lock);
+}
+
+
+int
+xfs_unicode_read_cft(
+	xfs_mount_t	*mp)
+{
+	int		error;
+	xfs_inode_t	*cftip;
+	int		size;
+	int		nfsb;
+	int             nmap;
+	xfs_bmbt_irec_t *mapp;
+	int		n;
+	int		byte_cnt;
+	xfs_buf_t	*bp;
+	char		*table;
+	xfs_dcft_t	*dcft;
+
+	if (mp->m_sb.sb_cftino =3D=3D NULLFSINO || mp->m_sb.sb_cftino =3D=3D 0=
)
+		return EINVAL;
+	error =3D xfs_iget(mp, NULL, mp->m_sb.sb_cftino, 0, 0, &cftip, 0);
+	if (error)
+		return error;
+	ASSERT(cftip !=3D NULL);
+
+	size =3D cftip->i_d.di_size;
+	nfsb =3D cftip->i_d.di_nblocks;
+
+	table =3D vmalloc(size);
+	if (!table) {
+		xfs_iput(cftip, 0);
+		return ENOMEM;
+	}
+	dcft =3D (xfs_dcft_t *)table;
+
+	nmap =3D nfsb;
+	mapp =3D kmem_alloc(nfsb * sizeof(xfs_bmbt_irec_t), KM_SLEEP);
+
+	error =3D xfs_bmapi(NULL, cftip, 0, nfsb, 0, NULL, 0, mapp, &nmap, NUL=
L);
+	if (error)
+		goto out;
+
+	for (n =3D 0; n < nmap; n++) {
+		byte_cnt =3D XFS_FSB_TO_B(mp, mapp[n].br_blockcount);
+
+		error =3D xfs_read_buf(mp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mapp[n].br_startblock),
+				BTOBB(byte_cnt), 0, &bp);
+		if (error)
+			goto out;
+
+		if (size < byte_cnt)
+			byte_cnt =3D size;
+		size -=3D byte_cnt;
+		memcpy(table, XFS_BUF_PTR(bp), byte_cnt);
+		table +=3D byte_cnt;
+		xfs_buf_relse(bp);
+	}
+
+	/* verify case table read off disk */
+	if (platform_uuid_compare(&dcft->cft_uuid, &mp->m_sb.sb_uuid) !=3D 0) =
{
+		error =3D EINVAL;
+		goto out;
+	}
+
+	/* clear UUID for in-memory copy/compare */
+	memset(&dcft->cft_uuid, 0, sizeof(dcft->cft_uuid));
+
+	mp->m_cft =3D add_cft(dcft, cftip->i_d.di_size);
+	if (mp->m_cft =3D=3D NULL)
+		error =3D ENOMEM;
+
+out:
+	xfs_iput(cftip, 0);
+	kmem_free(mapp, nfsb * sizeof(xfs_bmbt_irec_t));
+	vfree(dcft);
+
+	return error;
+}
+
+void
+xfs_unicode_free_cft(
+	const xfs_cft_t	*cft)
+{
+	remove_cft(cft);
+}
+
+void
+xfs_unicode_init(void)
+{
+	mutex_init(&cft_lock);
+	xfs_nls_uni_zone =3D kmem_zone_init(MAXNAMELEN, "xfs_nls_uni");
+}
+
+void
+xfs_unicode_uninit(void)
+{
+	int		i;
+
+	mutex_lock(&cft_lock);
+
+	for (i =3D 0; i < cft_size; i++) {
+		ASSERT(cft_list[i].refcount =3D=3D 0);
+		vfree(cft_list[i].table);
+	}
+	kmem_free(cft_list, cft_size * sizeof(struct cft_item));
+	cft_size =3D 0;
+	cft_list =3D NULL;
+
+	mutex_unlock(&cft_lock);
+
+	kmem_zone_destroy(xfs_nls_uni_zone);
+}
Index: ci/xfsprogs/mdrestore/Makefile
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mdrestore/Makefile	2008-01-18 14:50:43.000000000 +1=
100
+++ ci/xfsprogs/mdrestore/Makefile	2008-01-18 15:00:09.272540212 +1100
@@ -8,7 +8,7 @@
 LTCOMMAND =3D xfs_mdrestore
 CFILES =3D xfs_mdrestore.c
 =

-LLDLIBS =3D $(LIBXFS) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS =3D $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES =3D $(LIBXFS)
 LLDFLAGS =3D -static
 =

Index: ci/xfsprogs/db/cft.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/db/cft.c	2008-01-18 15:00:09.336532002 +1100
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/libxfs.h>
+#include "command.h"
+#include "type.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "io.h"
+#include "bit.h"
+#include "output.h"
+#include "init.h"
+#include "inode.h"
+#include "bmap.h"
+
+static int	cft_f(int argc, char **argv);
+static void	cft_help(void);
+
+static int	cft_table_count(void *obj, int startoff);
+
+static const cmdinfo_t cft_cmd =3D
+	{ "cft", NULL, cft_f, 0, 0, 0, NULL,
+	  "set address to casefold table", cft_help };
+
+const field_t	cft_hfld[] =3D {
+	{ "", FLDT_CFT, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	OFF(f)	bitize(offsetof(xfs_cft_t, cft_ ## f))
+#define	SZ(f)	bitszof(xfs_cft_t, cft_ ## f)
+const field_t	cft_flds[] =3D {
+	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "flags", FLDT_UINT32X, OI(OFF(flags)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_UINT32X, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "num_tables", FLDT_UINT32D, OI(OFF(num_tables)), C1, 0, TYP_NONE },
+	{ "table_offset", FLDT_UINT32D, OI(OFF(table_offset)), cft_table_count=
,
+			FLD_ARRAY | FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
+static void
+cft_help(void)
+{
+	dbprintf(
+"\n"
+" set address to casefold table\n"
+"\n"
+" Example:\n"
+"\n"
+" cft - move location to filesystem casefold table\n"
+"\n"
+" The casefold table is stored in a file for Unicode aware filesystems.=
\n"
+" All directory and attribute names are hashed using the casefold table=
.\n"
+);
+}
+
+static int
+cft_f(
+	int		argc,
+	char		**argv)
+{
+	bmap_ext_t	bmp;
+	xfs_dfiloff_t	bno;
+	int		nex;
+	typnm_t		type;
+
+	if (!xfs_sb_version_hasunicode(&mp->m_sb)) {
+		dbprintf("filesystem does not have a casefold table\n");
+		return 0;
+	}
+
+	set_cur_inode(mp->m_sb.sb_cftino);
+	type =3D inode_next_type();
+	if (!type !=3D TYP_CFT) {
+		dbprintf("cannot read casefold table\n");
+		return 0;
+	}
+
+	nex =3D 1;
+	bmap(bno, 1, XFS_DATA_FORK, &nex, &bmp);
+	if (nex =3D=3D 0) {
+		dbprintf("casefold table block is unmapped\n");
+		return 0;
+	}
+	ASSERT(typtab[type].typnm =3D=3D type);
+	ASSERT(nex =3D=3D 1);
+	set_cur(&typtab[type], (__int64_t)XFS_FSB_TO_DADDR(mp, bmp.startblock)=
,
+		blkbb, DB_RING_ADD, NULL);
+	return 0;
+}
+
+void
+cft_init(void)
+{
+	add_command(&cft_cmd);
+}
+
+int
+cft_size(
+	void	*obj,
+	int	startoff,
+	int	idx)
+{
+	return bitize(mp->m_sb.sb_blocksize);
+}
+
+static int
+cft_table_count(
+	void		*obj,
+	int		startoff)
+{
+	xfs_dcft_t	*cft;
+
+	ASSERT(startoff =3D=3D 0);
+	cft =3D obj;
+	return be32_to_cpu(cft->cft_num_tables);
+}
Index: ci/xfsprogs/db/cft.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/db/cft.h	2008-01-18 15:00:09.348530462 +1100
@@ -0,0 +1,23 @@
+/*
+ * Copyright (c) 2008 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,=

+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+extern const struct field	cft_flds[];
+extern const struct field	cft_hfld[];
+
+extern void	cft_init(void);
+extern int	cft_size(void *obj, int startoff, int idx);
Index: ci/xfsprogs/libxfs/utf8.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ci/xfsprogs/libxfs/utf8.c	2008-01-18 15:00:09.348530462 +1100
@@ -0,0 +1,85 @@
+/*
+ * The following was provided by Ken Thompson of AT&T Bell Laboratories=
,
+ * <ken@research.att.com>, on Tue, 8 Sep 92 03:22:07 EDT, to the X/Open=

+ * Joint Internationalization Group.
+ */
+
+#include <stdlib.h>
+
+struct utf8_table {
+	int     cmask;
+	int     cval;
+	int     shift;
+	long    lmask;
+	long    lval;
+};
+
+static const struct utf8_table utf8_table[] =3D
+{
+    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequen=
ce */},
+    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequen=
ce */},
+    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequen=
ce */},
+    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequen=
ce */},
+    {0xFC,  0xF8,   4*6,    0x3FFFFFF,      0x200000,  /* 5 byte sequen=
ce */},
+    {0xFE,  0xFC,   5*6,    0x7FFFFFFF,     0x4000000, /* 6 byte sequen=
ce */},
+    {0,						       /* end of table    */}
+};
+
+int
+utf8_mbtowc(wchar_t *p, const unsigned char *s, int n)
+{
+	long l;
+	int c0, c, nc;
+	const struct utf8_table *t;
+
+	nc =3D 0;
+	c0 =3D *s;
+	l =3D c0;
+	for (t =3D utf8_table; t->cmask; t++) {
+		nc++;
+		if ((c0 & t->cmask) =3D=3D t->cval) {
+			l &=3D t->lmask;
+			if (l < t->lval)
+				return -1;
+			*p =3D l;
+			return nc;
+		}
+		if (n <=3D nc)
+			return -1;
+		s++;
+		c =3D (*s ^ 0x80) & 0xFF;
+		if (c & 0xC0)
+			return -1;
+		l =3D (l << 6) | c;
+	}
+	return -1;
+}
+
+int
+utf8_wctomb(unsigned char *s, wchar_t wc, int maxlen)
+{
+	long l;
+	int c, nc;
+	const struct utf8_table *t;
+
+	if (!s)
+		return 0;
+
+	l =3D wc;
+	nc =3D 0;
+	for (t =3D utf8_table; t->cmask && maxlen; t++, maxlen--) {
+		nc++;
+		if (l <=3D t->lmask) {
+			c =3D t->shift;
+			*s =3D t->cval | (l >> c);
+			while (c > 0) {
+				c -=3D 6;
+				s++;
+				*s =3D 0x80 | ((l >> c) & 0x3F);
+			}
+			return nc;
+		}
+	}
+	return -1;
+}
+
Index: ci/xfsprogs/libxfs/xfs_dir2_block.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_block.c	2008-01-18 14:50:42.0000000=
00 +1100
+++ ci/xfsprogs/libxfs/xfs_dir2_block.c	2008-01-18 15:00:09.352529949 +1=
100
@@ -1046,8 +1046,9 @@
 		tagp =3D XFS_DIR2_DATA_ENTRY_TAG_P(dep);
 		INT_SET(*tagp, ARCH_CONVERT, (xfs_dir2_data_off_t)((char *)dep - (cha=
r *)block));
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		INT_SET(blp[2 + i].hashval, ARCH_CONVERT, xfs_da_hashname((const ucha=
r_t *)sfep->name, sfep->namelen));
-		INT_SET(blp[2 + i].address, ARCH_CONVERT, XFS_DIR2_BYTE_TO_DATAPTR(mp=
,
+		blp[2 + i].hashval =3D cpu_to_be32(xfs_dir_hashname(dp,
+						sfep->name, sfep->namelen));
+		blp[2 + i].address =3D cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset =3D (int)((char *)(tagp + 1) - (char *)block);
 		if (++i =3D=3D INT_GET(sfp->hdr.count, ARCH_CONVERT))
Index: ci/xfsprogs/libxfs/xfs_dir2_data.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_data.c	2008-01-18 14:50:42.00000000=
0 +1100
+++ ci/xfsprogs/libxfs/xfs_dir2_data.c	2008-01-18 15:00:09.352529949 +11=
00
@@ -126,7 +126,8 @@
 			addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
-			hash =3D xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash =3D xfs_dir_hashname(dp, (char *)dep->name,
+					dep->namelen);
 			for (i =3D 0; i < INT_GET(btp->count, ARCH_CONVERT); i++) {
 				if (INT_GET(lep[i].address, ARCH_CONVERT) =3D=3D addr &&
 				    INT_GET(lep[i].hashval, ARCH_CONVERT) =3D=3D hash)

------------blQY9A8HShDiztkzvReN2F--
