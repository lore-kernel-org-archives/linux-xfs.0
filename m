Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 21:36:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m414ZV20028944
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 21:35:34 -0700
Date: Thu, 01 May 2008 14:37:11 +1000
Subject: REVIEW: ASCII CI support in xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------IXmiutYgjYq48aBi7Ucq48
MIME-Version: 1.0
Message-ID: <op.uagkf9jl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>

------------IXmiutYgjYq48aBi7Ucq48
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

I've reworked xfsprogs userspace tools from scratch with ASCII CI support
only. Much simpler than previous patches with Unicode CI.

One issue that sort of bugs me a bit is I've maintained the same output as
the original IRIX mkfs.xfs with CI mode:
naming   =3Dversion 2              bsize=3D4096   mixed-case=3DY|N

where "N" =3D CI enabled and "Y" =3D normal case-senstive filesystem.

Should this be changed to something clearer?

Barry.

--

---
  xfsprogs/db/check.c              |    2 -
  xfsprogs/db/sb.c                 |    2 +
  xfsprogs/growfs/xfs_growfs.c     |   15 +++++---
  xfsprogs/include/libxfs.h        |    1
  xfsprogs/include/xfs_da_btree.h  |   21 +++++++++++
  xfsprogs/include/xfs_fs.h        |    1
  xfsprogs/include/xfs_sb.h        |   10 +++++
  xfsprogs/libxfs/xfs_da_btree.c   |   12 ++++++
  xfsprogs/libxfs/xfs_dir2.c       |   63=20=20
+++++++++++++++++++++++++++++++++--
  xfsprogs/libxfs/xfs_dir2_block.c |    5 +-
  xfsprogs/libxfs/xfs_dir2_data.c  |    2 -
  xfsprogs/man/man8/mkfs.xfs.8     |   27 +++++++++------
  xfsprogs/mkfs/xfs_mkfs.c         |   69=20=20
+++++++++++++++++----------------------
  xfsprogs/mkfs/xfs_mkfs.h         |    9 ++---
  xfsprogs/repair/phase6.c         |   11 +++---
  15 files changed, 178 insertions(+), 72 deletions(-)

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c
+++ ci/xfsprogs/db/check.c
@@ -2317,7 +2317,7 @@ process_data_dir_v2(
  		tag_err +=3D INT_GET(*tagp, ARCH_CONVERT) !=3D (char *)dep - (char *)da=
ta;
  		addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db,
  			(char *)dep - (char *)data);
-		hash =3D libxfs_da_hashname((uchar_t *)dep->name, dep->namelen);
+		hash =3D mp->m_dirnameops->hashname((uchar_t *)dep->name, dep->namelen);
  		dir_hash_add(hash, addr);
  		ptr +=3D XFS_DIR2_DATA_ENTSIZE(dep->namelen);
  		count++;
Index: ci/xfsprogs/db/sb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/sb.c
+++ ci/xfsprogs/db/sb.c
@@ -605,6 +605,8 @@ version_string(
  		strcat(s, ",EXTFLG");
  	if (XFS_SB_VERSION_HASSECTOR(sbp))
  		strcat(s, ",SECTOR");
+	if (xfs_sb_version_hasasciici(sbp))
+		strcat(s, ",ASCII_CI");
  	if (XFS_SB_VERSION_HASMOREBITS(sbp))
  		strcat(s, ",MOREBITS");
  	if (XFS_SB_VERSION_HASATTR2(sbp))
Index: ci/xfsprogs/growfs/xfs_growfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/growfs/xfs_growfs.c
+++ ci/xfsprogs/growfs/xfs_growfs.c
@@ -61,14 +61,15 @@ report_info(
  	int		lazycount,
  	int		dirversion,
  	int		logversion,
-	int		attrversion)
+	int		attrversion,
+	int		cimode)
  {
  	printf(_(
  	    "meta-data=3D%-22s isize=3D%-6u agcount=3D%u, agsize=3D%u blks\n"
  	    "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
  	    "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
  	    "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-	    "naming   =3Dversion %-14u bsize=3D%-6u\n"
+	    "naming   =3Dversion %-14u bsize=3D%-6u mixed-case=3D%c\n"
  	    "log      =3D%-22s bsize=3D%-6u blocks=3D%u, version=3D%u\n"
  	    "         =3D%-22s sectsz=3D%-5u sunit=3D%u blks, lazy-count=3D%u\n"
  	    "realtime =3D%-22s extsz=3D%-6u blocks=3D%llu, rtextents=3D%llu\n"),
@@ -78,7 +79,7 @@ report_info(
  		"", geo.blocksize, (unsigned long long)geo.datablocks,
  			geo.imaxpct,
  		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize,
+  		dirversion, geo.dirblocksize, cimode ? 'N' : 'Y',
  		isint ? _("internal") : logname ? logname : _("external"),
  			geo.blocksize, geo.logblocks, logversion,
  		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -114,6 +115,7 @@ main(int argc, char **argv)
  	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
  	int			rflag;	/* -r flag */
  	long long		rsize;	/* new rt size in fs blocks */
+	int			ci;	/* ASCII case-insensitive fs */
  	int			lazycount; /* lazy superblock counters */
  	int			xflag;	/* -x flag */
  	char			*fname;	/* mount point name */
@@ -131,6 +133,7 @@ main(int argc, char **argv)
  	maxpct =3D esize =3D 0;
  	dsize =3D lsize =3D rsize =3D 0LL;
  	aflag =3D dflag =3D iflag =3D lflag =3D mflag =3D nflag =3D rflag =3D xf=
lag =3D 0;
+	ci =3D 0;

  	while ((c =3D getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) !=3D EOF) {
  		switch (c) {
@@ -239,11 +242,11 @@ main(int argc, char **argv)
  	logversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
  	attrversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
  			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
-
+	ci =3D geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
  	if (nflag) {
  		report_info(geo, datadev, isint, logdev, rtdev,
  				lazycount, dirversion, logversion,
-				attrversion);
+				attrversion, ci);
  		exit(0);
  	}

@@ -280,7 +283,7 @@ main(int argc, char **argv)

  	report_info(geo, datadev, isint, logdev, rtdev,
  			lazycount, dirversion, logversion,
-			attrversion);
+			attrversion, ci);

  	ddsize =3D xi.dsize;
  	dlsize =3D ( xi.logBBsize? xi.logBBsize :
Index: ci/xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/libxfs.h
+++ ci/xfsprogs/include/libxfs.h
@@ -175,6 +175,7 @@ typedef struct xfs_mount {
  	int			m_attr_magicpct;/* 37% of the blocksize */
  	int			m_dir_magicpct;	/* 37% of the dir blocksize */
  	__uint8_t		m_dirversion;	/* 1 or 2 */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
  	int			m_dirblksize;	/* directory block sz--bytes */
  	int			m_dirblkfsbs;	/* directory block sz--fsbs */
  	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
Index: ci/xfsprogs/include/xfs_da_btree.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_da_btree.h
+++ ci/xfsprogs/include/xfs_da_btree.h
@@ -103,6 +103,15 @@ typedef struct xfs_da_node_entry xfs_da_
   *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/

  /*
+ * Search comparison results
+ */
+enum xfs_dacmp {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+};
+
+/*
   * Structure to ease passing around component names.
   */
  typedef struct xfs_da_args {
@@ -131,6 +140,7 @@ typedef struct xfs_da_args {
  	unsigned char	rename;		/* T/F: this is an atomic rename op */
  	unsigned char	addname;	/* T/F: this is an add operation */
  	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
  } xfs_da_args_t;

  /*
@@ -205,6 +215,14 @@ typedef struct xfs_da_state {
  		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
  		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)

+/*
+ * Name ops for directory and/or attr name operations
+ */
+struct xfs_nameops {
+	xfs_dahash_t	(*hashname)(const uchar_t *, int);
+	enum xfs_dacmp	(*compname)(const uchar_t *, int, const uchar_t *, int);
+};
+

  #ifdef __KERNEL__
  /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -253,6 +271,9 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
  					  xfs_dabuf_t *dead_buf);

  uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+enum xfs_dacmp xfs_da_compname(const uchar_t *name1, int len1,
+				const uchar_t *name2, int len2);
+
  uint xfs_da_log2_roundup(uint i);
  xfs_da_state_t *xfs_da_state_alloc(void);
  void xfs_da_state_free(xfs_da_state_t *state);
Index: ci/xfsprogs/include/xfs_fs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_fs.h
+++ ci/xfsprogs/include/xfs_fs.h
@@ -241,6 +241,7 @@ typedef struct xfs_fsop_resblks {
  #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
  #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
  #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
  #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */


Index: ci/xfsprogs/include/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_sb.h
+++ ci/xfsprogs/include/xfs_sb.h
@@ -46,10 +46,12 @@ struct xfs_mount;
  #define XFS_SB_VERSION_SECTORBIT	0x0800
  #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
  #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define	XFS_SB_VERSION_BORGBIT		0x4000
  #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
  #define	XFS_SB_VERSION_OKSASHFBITS	\
  	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_BORGBIT)
  #define	XFS_SB_VERSION_OKREALFBITS	\
  	(XFS_SB_VERSION_ATTRBIT | \
  	 XFS_SB_VERSION_NLINKBIT | \
@@ -416,6 +418,12 @@ static inline int xfs_sb_version_hassect
  		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
  }

+static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) =3D=3D XFS_SB_VERSION_4) && \
+		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
+}
+
  #define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)
  static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
  {
Index: ci/xfsprogs/libxfs/xfs_da_btree.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_da_btree.c
+++ ci/xfsprogs/libxfs/xfs_da_btree.c
@@ -1540,6 +1540,18 @@ xfs_da_hashname(const uchar_t *name, int
  	}
  }

+enum xfs_dacmp
+xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2, int=
=20=20
len2)
+{
+	return (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0) ?
+					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+const struct xfs_nameops xfs_default_nameops =3D {
+	.hashname	=3D xfs_da_hashname,
+	.compname	=3D xfs_da_compname
+};
+
  /*
   * Add a block to the btree ahead of the file.
   * Return the new block number to the caller.
Index: ci/xfsprogs/libxfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2.c
+++ ci/xfsprogs/libxfs/xfs_dir2.c
@@ -23,6 +23,57 @@

  #include <xfs.h>

+extern const struct xfs_nameops xfs_default_nameops;
+
+/*
+ * V1/OLDCI case-insensitive support for directories that was used in=20=
=20
IRIX.
+ *
+ * This is ASCII only case support, ie. A-Z.
+ */
+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	const uchar_t	*name,
+	int		len)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i =3D 0, hash =3D 0; i < len; i++)
+		hash =3D tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static enum xfs_dacmp
+xfs_ascii_ci_compname(
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	enum xfs_dacmp	result;
+	int		i;
+
+	if (len1 !=3D len2)
+		return XFS_CMP_DIFFERENT;
+
+	result =3D XFS_CMP_EXACT;
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
+

  /*
   * Initialize directory-related fields in the mount structure.
@@ -46,6 +97,10 @@ xfs_dir2_mount(
  		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
  		(uint)sizeof(xfs_da_node_entry_t);
  	mp->m_dir_magicpct =3D (mp->m_dirblksize * 37) / 100;
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
+		mp->m_dirnameops =3D &xfs_ascii_ci_nameops;
+	else
+		mp->m_dirnameops =3D &xfs_default_nameops;
  }

  /*
@@ -98,7 +153,7 @@ xfs_dir2_createname(
  	 */
  	args.name =3D name;
  	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
  	args.inumber =3D inum;
  	args.dp =3D dp;
  	args.firstblock =3D first;
@@ -149,7 +204,7 @@ xfs_dir2_lookup(
  	 */
  	args.name =3D name;
  	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
  	args.inumber =3D 0;
  	args.dp =3D dp;
  	args.firstblock =3D NULL;
@@ -206,7 +261,7 @@ xfs_dir2_removename(
  	 */
  	args.name =3D name;
  	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
  	args.inumber =3D ino;
  	args.dp =3D dp;
  	args.firstblock =3D first;
@@ -261,7 +316,7 @@ xfs_dir2_replace(
  	 */
  	args.name =3D name;
  	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
  	args.inumber =3D inum;
  	args.dp =3D dp;
  	args.firstblock =3D first;
Index: ci/xfsprogs/libxfs/xfs_dir2_block.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_block.c
+++ ci/xfsprogs/libxfs/xfs_dir2_block.c
@@ -1046,8 +1046,9 @@ xfs_dir2_sf_to_block(
  		tagp =3D XFS_DIR2_DATA_ENTRY_TAG_P(dep);
  		INT_SET(*tagp, ARCH_CONVERT, (xfs_dir2_data_off_t)((char *)dep - (char=
=20=20
*)block));
  		xfs_dir2_data_log_entry(tp, bp, dep);
-		INT_SET(blp[2 + i].hashval, ARCH_CONVERT, xfs_da_hashname((const=20=20
uchar_t *)sfep->name, sfep->namelen));
-		INT_SET(blp[2 + i].address, ARCH_CONVERT, XFS_DIR2_BYTE_TO_DATAPTR(mp,
+		blp[2 + i].hashval =3D cpu_to_be32(mp->m_dirnameops->hashname(
+						sfep->name, sfep->namelen));
+		blp[2 + i].address =3D cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
  						 (char *)dep - (char *)block));
  		offset =3D (int)((char *)(tagp + 1) - (char *)block);
  		if (++i =3D=3D INT_GET(sfp->hdr.count, ARCH_CONVERT))
Index: ci/xfsprogs/libxfs/xfs_dir2_data.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_data.c
+++ ci/xfsprogs/libxfs/xfs_dir2_data.c
@@ -126,7 +126,7 @@ xfs_dir2_data_check(
  			addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
  				(xfs_dir2_data_aoff_t)
  				((char *)dep - (char *)d));
-			hash =3D xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash =3D mp->m_dirnameops->hashname(dep->name, dep->namelen);
  			for (i =3D 0; i < INT_GET(btp->count, ARCH_CONVERT); i++) {
  				if (INT_GET(lep[i].address, ARCH_CONVERT) =3D=3D addr &&
  				    INT_GET(lep[i].hashval, ARCH_CONVERT) =3D=3D hash)
Index: ci/xfsprogs/man/man8/mkfs.xfs.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/man/man8/mkfs.xfs.8
+++ ci/xfsprogs/man/man8/mkfs.xfs.8
@@ -302,8 +302,8 @@ bits.
  .TP
  .BI maxpct=3D value
  This specifies the maximum percentage of space in the filesystem that
-can be allocated to inodes. The default
-.I value
+can be allocated to inodes. The default
+.I value
  is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
  for filesystems over 50TB.
  .IP
@@ -314,14 +314,14 @@ allocator will avoid these low blocks to
  maxpct, so a high value may result in a filesystem with nothing but
  inodes in a significant portion of the lower blocks of the filesystem.
  (This restriction is not present when the filesystem is mounted with
-the
-.I "inode64"
+the
+.I "inode64"
  option on 64-bit platforms).
  .IP
  Setting the value to 0 means that essentially all of the filesystem
  can become inode blocks, subject to inode32 restrictions.
  .IP
-This value can be modified with
+This value can be modified with
  .Ixfs_growfs(8)
  .
  .TP
@@ -340,7 +340,7 @@ filesystem needs to be mountable by a ve
  that does not have the inode alignment feature
  (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
  .TP
-.BI attr=3D value
+.BI attr=3D value
  This is used to specify the version of extended attribute inline
  allocation policy to be used.  By default, this is 2, which uses an
  efficient algorithm for managing the available inline inode space
@@ -489,10 +489,17 @@ filesystem block size.
  .BI version=3D value
  The naming (directory) version
  .I value
-can be either 1 or 2, defaulting to 2 if unspecified.
-With version 2 directories,
-the directory block size can be any power of 2 size
-from the filesystem block size up to 65536.
+can be either 2 or 'ci', defaulting to 2 if unspecified.
+With version 2 directories, the directory block size can be
+any power of 2 size from the filesystem block size up to 65536.
+.IP
+The
+.B version=3Dci
+option enables ASCII only case-insensitive filename lookup and version
+2 directories. Filenames are case-preserving, that is, the names
+are stored in directories using the case they were created with.
+.IP
+Note: Version 1 directories are not supported.
  .RE
  .TP
  .BI \-p " protofile"
Index: ci/xfsprogs/mkfs/xfs_mkfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c
+++ ci/xfsprogs/mkfs/xfs_mkfs.c
@@ -678,6 +678,7 @@ main(
  	xfs_alloc_rec_t		*nrec;
  	int			nsflag;
  	int			nvflag;
+	int			nci;
  	int			Nflag;
  	char			*p;
  	char			*protofile;
@@ -720,8 +721,9 @@ main(
  	loginternal =3D 1;
  	logversion =3D 2;
  	logagno =3D logblocks =3D rtblocks =3D rtextblocks =3D 0;
-	Nflag =3D nlflag =3D nsflag =3D nvflag =3D 0;
-	dirblocklog =3D dirblocksize =3D dirversion =3D 0;
+	Nflag =3D nlflag =3D nsflag =3D nvflag =3D nci =3D 0;
+	dirblocklog =3D dirblocksize =3D 0;
+	dirversion =3D XFS_DFL_DIR_VERSION;
  	qflag =3D 0;
  	imaxpct =3D inodelog =3D inopblock =3D isize =3D 0;
  	iaflag =3D XFS_IFLAG_ALIGN;
@@ -1236,9 +1238,14 @@ main(
  						reqval('n', nopts, N_VERSION);
  					if (nvflag)
  						respec('n', nopts, N_VERSION);
-					dirversion =3D atoi(value);
-					if (dirversion < 1 || dirversion > 2)
-						illegal(value, "n version");
+					if (!strcmp(value, "ci")) {
+						nci =3D 1; /* ASCII CI mode */
+					} else {
+						dirversion =3D atoi(value);
+						if (dirversion !=3D 2)
+							illegal(value,
+								"n version");
+					}
  					nvflag =3D 1;
  					break;
  				default:
@@ -1412,33 +1419,19 @@ main(
  		logversion =3D 2;
  	}

-	if (!nvflag)
-		dirversion =3D (nsflag || nlflag) ? 2 : XFS_DFL_DIR_VERSION;
-	switch (dirversion) {
-	case 1:
-		if ((nsflag || nlflag) && dirblocklog !=3D blocklog) {
+	if (nsflag || nlflag) {
+		if (dirblocksize < blocksize ||
+					dirblocksize > XFS_MAX_BLOCKSIZE) {
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
  	}

  	if (daflag && dasize) {
@@ -2024,7 +2017,7 @@ an AG size that is one stripe unit small
  		   "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
  		   "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
  		   "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-		   "naming   =3Dversion %-14u bsize=3D%-6u\n"
+		   "naming   =3Dversion %-14u bsize=3D%-6u mixed-case=3D%c\n"
  		   "log      =3D%-22s bsize=3D%-6d blocks=3D%lld, version=3D%d\n"
  		   "         =3D%-22s sectsz=3D%-5u sunit=3D%d blks, lazy-count=3D%d\n"
  		   "realtime =3D%-22s extsz=3D%-6d blocks=3D%lld, rtextents=3D%lld\n"),
@@ -2033,7 +2026,7 @@ an AG size that is one stripe unit small
  			"", blocksize, (long long)dblocks,
  			       calc_default_imaxpct(blocklog, dblocks),
  			"", dsunit, dswidth,
-			dirversion, dirversion =3D=3D 1 ? blocksize : dirblocksize,
+			dirversion, dirblocksize, nci ? 'N' : 'Y',
  			logfile, 1 << blocklog, (long long)logblocks,
  			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
  			rtfile, rtextblocks << blocklog,
@@ -2078,8 +2071,7 @@ an AG size that is one stripe unit small
  	sbp->sb_qflags =3D 0;
  	sbp->sb_unit =3D dsunit;
  	sbp->sb_width =3D dswidth;
-	if (dirversion =3D=3D 2)
-		sbp->sb_dirblklog =3D dirblocklog - blocklog;
+	sbp->sb_dirblklog =3D dirblocklog - blocklog;
  	if (logversion =3D=3D 2) {	/* This is stored in bytes */
  		lsunit =3D (lsunit =3D=3D 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
  		sbp->sb_logsunit =3D lsunit;
@@ -2097,12 +2089,13 @@ an AG size that is one stripe unit small
  		sbp->sb_logsectlog =3D 0;
  		sbp->sb_logsectsize =3D 0;
  	}
-	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters, attrversion=
=20=20
=3D=3D 2, 0);
-	sbp->sb_versionnum =3D XFS_SB_VERSION_MKFS(
-			iaflag, dsunit !=3D 0,
-			dirversion =3D=3D 2, logversion =3D=3D 2, attrversion =3D=3D 1,
-			(sectorsize !=3D BBSIZE || lsectorsize !=3D BBSIZE),
-			sbp->sb_features2 !=3D 0);
+	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters,
+					attrversion =3D=3D 2, 0);
+	sbp->sb_versionnum =3D XFS_SB_VERSION_MKFS(iaflag, dsunit !=3D 0,
+					logversion =3D=3D 2, attrversion =3D=3D 1,
+					(sectorsize !=3D BBSIZE ||
+							lsectorsize !=3D BBSIZE),
+					nci, sbp->sb_features2 !=3D 0);
  	/*
  	 * Due to a structure alignment issue, sb_features2 ended up in one
  	 * of two locations, the second "incorrect" location represented by
Index: ci/xfsprogs/mkfs/xfs_mkfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.h
+++ ci/xfsprogs/mkfs/xfs_mkfs.h
@@ -20,17 +20,18 @@

  #define XFS_DFL_SB_VERSION_BITS \
                  (XFS_SB_VERSION_NLINKBIT | \
-                 XFS_SB_VERSION_EXTFLGBIT)
+                 XFS_SB_VERSION_EXTFLGBIT | \
+                 XFS_SB_VERSION_DIRV2BIT)

-#define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
-	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
+#define XFS_SB_VERSION_MKFS(ia,dia,log2,attr1,sflag,ci,more) (\
+	((ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
  	( XFS_SB_VERSION_4 |						\
  		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
  		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
  		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
  		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
  		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
+		((ci) ? XFS_SB_VERSION_BORGBIT : 0) |			\
  		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
  	        XFS_DFL_SB_VERSION_BITS |                               \
  	0 ) : XFS_SB_VERSION_1 )
Index: ci/xfsprogs/repair/phase6.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase6.c
+++ ci/xfsprogs/repair/phase6.c
@@ -93,6 +93,7 @@ typedef struct freetab {
   */
  static int
  dir_hash_add(
+	xfs_mount_t		*mp,
  	dir_hash_tab_t		*hashtab,
  	__uint32_t		addr,
  	xfs_ino_t		inum,
@@ -113,7 +114,7 @@ dir_hash_add(
  	dup =3D 0;

  	if (!junk) {
-		hash =3D libxfs_da_hashname(name, namelen);
+		hash =3D mp->m_dirnameops->hashname(name, namelen);
  		byhash =3D DIR_HASH_FUNC(hashtab, hash);

  		/*
@@ -1589,7 +1590,7 @@ lf_block_dir_entry_check(xfs_mount_t		*m
  		/*
  		 * check for duplicate names in directory.
  		 */
-		if (!dir_hash_add(hashtab, (da_bno << mp->m_sb.sb_blocklog) +
+		if (!dir_hash_add(mp, hashtab, (da_bno << mp->m_sb.sb_blocklog) +
  				entry->nameidx, lino, entry->namelen,
  				namest->name)) {
  			nbad++;
@@ -2260,7 +2261,7 @@ longform_dir2_entry_check_data(
  		/*
  		 * check for duplicate names in directory.
  		 */
-		if (!dir_hash_add(hashtab, addr, inum, dep->namelen,
+		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
  				dep->name)) {
  			nbad++;
  			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
@@ -2870,7 +2871,7 @@ shortform_dir_entry_check(xfs_mount_t	*m
  		/*
  		 * check for duplicate names in directory.
  		 */
-		if (!dir_hash_add(hashtab,
+		if (!dir_hash_add(mp, hashtab,
  				(xfs_dir2_dataptr_t)(sf_entry - &sf->list[0]),
  				lino, sf_entry->namelen, sf_entry->name)) {
  			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
@@ -3275,7 +3276,7 @@ shortform_dir2_entry_check(xfs_mount_t	*
  		/*
  		 * check for duplicate names in directory.
  		 */
-		if (!dir_hash_add(hashtab, (xfs_dir2_dataptr_t)
+		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
  					(sfep - XFS_DIR2_SF_FIRSTENTRY(sfp)),
  				lino, sfep->namelen, sfep->name)) {
  			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
------------IXmiutYgjYq48aBi7Ucq48
Content-Disposition: attachment; filename=ascii_ci.patch
Content-Type: text/x-patch; name=ascii_ci.patch
Content-Transfer-Encoding: Quoted-Printable

---
 xfsprogs/db/check.c              |    2 -
 xfsprogs/db/sb.c                 |    2 +
 xfsprogs/growfs/xfs_growfs.c     |   15 +++++---
 xfsprogs/include/libxfs.h        |    1=20
 xfsprogs/include/xfs_da_btree.h  |   21 +++++++++++
 xfsprogs/include/xfs_fs.h        |    1=20
 xfsprogs/include/xfs_sb.h        |   10 +++++
 xfsprogs/libxfs/xfs_da_btree.c   |   12 ++++++
 xfsprogs/libxfs/xfs_dir2.c       |   63 +++++++++++++++++++++++++++++++++--
 xfsprogs/libxfs/xfs_dir2_block.c |    5 +-
 xfsprogs/libxfs/xfs_dir2_data.c  |    2 -
 xfsprogs/man/man8/mkfs.xfs.8     |   27 +++++++++------
 xfsprogs/mkfs/xfs_mkfs.c         |   69 +++++++++++++++++-----------------=
-----
 xfsprogs/mkfs/xfs_mkfs.h         |    9 ++---
 xfsprogs/repair/phase6.c         |   11 +++---
 15 files changed, 178 insertions(+), 72 deletions(-)

Index: ci/xfsprogs/db/check.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/check.c
+++ ci/xfsprogs/db/check.c
@@ -2317,7 +2317,7 @@ process_data_dir_v2(
 		tag_err +=3D INT_GET(*tagp, ARCH_CONVERT) !=3D (char *)dep - (char *)dat=
a;
 		addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, db,
 			(char *)dep - (char *)data);
-		hash =3D libxfs_da_hashname((uchar_t *)dep->name, dep->namelen);
+		hash =3D mp->m_dirnameops->hashname((uchar_t *)dep->name, dep->namelen);
 		dir_hash_add(hash, addr);
 		ptr +=3D XFS_DIR2_DATA_ENTSIZE(dep->namelen);
 		count++;
Index: ci/xfsprogs/db/sb.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/db/sb.c
+++ ci/xfsprogs/db/sb.c
@@ -605,6 +605,8 @@ version_string(
 		strcat(s, ",EXTFLG");
 	if (XFS_SB_VERSION_HASSECTOR(sbp))
 		strcat(s, ",SECTOR");
+	if (xfs_sb_version_hasasciici(sbp))
+		strcat(s, ",ASCII_CI");
 	if (XFS_SB_VERSION_HASMOREBITS(sbp))
 		strcat(s, ",MOREBITS");
 	if (XFS_SB_VERSION_HASATTR2(sbp))
Index: ci/xfsprogs/growfs/xfs_growfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/growfs/xfs_growfs.c
+++ ci/xfsprogs/growfs/xfs_growfs.c
@@ -61,14 +61,15 @@ report_info(
 	int		lazycount,
 	int		dirversion,
 	int		logversion,
-	int		attrversion)
+	int		attrversion,
+	int		cimode)
 {
 	printf(_(
 	    "meta-data=3D%-22s isize=3D%-6u agcount=3D%u, agsize=3D%u blks\n"
 	    "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
 	    "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
 	    "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-	    "naming   =3Dversion %-14u bsize=3D%-6u\n"
+	    "naming   =3Dversion %-14u bsize=3D%-6u mixed-case=3D%c\n"
 	    "log      =3D%-22s bsize=3D%-6u blocks=3D%u, version=3D%u\n"
 	    "         =3D%-22s sectsz=3D%-5u sunit=3D%u blks, lazy-count=3D%u\n"
 	    "realtime =3D%-22s extsz=3D%-6u blocks=3D%llu, rtextents=3D%llu\n"),
@@ -78,7 +79,7 @@ report_info(
 		"", geo.blocksize, (unsigned long long)geo.datablocks,
 			geo.imaxpct,
 		"", geo.sunit, geo.swidth,
-  		dirversion, geo.dirblocksize,
+  		dirversion, geo.dirblocksize, cimode ? 'N' : 'Y',
 		isint ? _("internal") : logname ? logname : _("external"),
 			geo.blocksize, geo.logblocks, logversion,
 		"", geo.logsectsize, geo.logsunit / geo.blocksize, lazycount,
@@ -114,6 +115,7 @@ main(int argc, char **argv)
 	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
 	int			rflag;	/* -r flag */
 	long long		rsize;	/* new rt size in fs blocks */
+	int			ci;	/* ASCII case-insensitive fs */
 	int			lazycount; /* lazy superblock counters */
 	int			xflag;	/* -x flag */
 	char			*fname;	/* mount point name */
@@ -131,6 +133,7 @@ main(int argc, char **argv)
 	maxpct =3D esize =3D 0;
 	dsize =3D lsize =3D rsize =3D 0LL;
 	aflag =3D dflag =3D iflag =3D lflag =3D mflag =3D nflag =3D rflag =3D xfl=
ag =3D 0;
+	ci =3D 0;
=20
 	while ((c =3D getopt(argc, argv, "dD:e:ilL:m:np:rR:t:xV")) !=3D EOF) {
 		switch (c) {
@@ -239,11 +242,11 @@ main(int argc, char **argv)
 	logversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_LOGV2 ? 2 : 1;
 	attrversion =3D geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR2 ? 2 : \
 			(geo.flags & XFS_FSOP_GEOM_FLAGS_ATTR ? 1 : 0);
-
+	ci =3D geo.flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI ? 1 : 0;
 	if (nflag) {
 		report_info(geo, datadev, isint, logdev, rtdev,
 				lazycount, dirversion, logversion,
-				attrversion);
+				attrversion, ci);
 		exit(0);
 	}
=20
@@ -280,7 +283,7 @@ main(int argc, char **argv)
=20
 	report_info(geo, datadev, isint, logdev, rtdev,
 			lazycount, dirversion, logversion,
-			attrversion);
+			attrversion, ci);
=20
 	ddsize =3D xi.dsize;
 	dlsize =3D ( xi.logBBsize? xi.logBBsize :
Index: ci/xfsprogs/include/libxfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/libxfs.h
+++ ci/xfsprogs/include/libxfs.h
@@ -175,6 +175,7 @@ typedef struct xfs_mount {
 	int			m_attr_magicpct;/* 37% of the blocksize */
 	int			m_dir_magicpct;	/* 37% of the dir blocksize */
 	__uint8_t		m_dirversion;	/* 1 or 2 */
+	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	int			m_dirblksize;	/* directory block sz--bytes */
 	int			m_dirblkfsbs;	/* directory block sz--fsbs */
 	xfs_dablk_t		m_dirdatablk;	/* blockno of dir data v2 */
Index: ci/xfsprogs/include/xfs_da_btree.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_da_btree.h
+++ ci/xfsprogs/include/xfs_da_btree.h
@@ -103,6 +103,15 @@ typedef struct xfs_da_node_entry xfs_da_
  *=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
=20
 /*
+ * Search comparison results
+ */
+enum xfs_dacmp {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+};
+
+/*
  * Structure to ease passing around component names.
  */
 typedef struct xfs_da_args {
@@ -131,6 +140,7 @@ typedef struct xfs_da_args {
 	unsigned char	rename;		/* T/F: this is an atomic rename op */
 	unsigned char	addname;	/* T/F: this is an add operation */
 	unsigned char	oknoent;	/* T/F: ok to return ENOENT, else die */
+	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
 } xfs_da_args_t;
=20
 /*
@@ -205,6 +215,14 @@ typedef struct xfs_da_state {
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
=20
+/*
+ * Name ops for directory and/or attr name operations
+ */
+struct xfs_nameops {
+	xfs_dahash_t	(*hashname)(const uchar_t *, int);
+	enum xfs_dacmp	(*compname)(const uchar_t *, int, const uchar_t *, int);
+};
+
=20
 #ifdef __KERNEL__
 /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -253,6 +271,9 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
 					  xfs_dabuf_t *dead_buf);
=20
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
+enum xfs_dacmp xfs_da_compname(const uchar_t *name1, int len1,
+				const uchar_t *name2, int len2);
+
 uint xfs_da_log2_roundup(uint i);
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
Index: ci/xfsprogs/include/xfs_fs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_fs.h
+++ ci/xfsprogs/include/xfs_fs.h
@@ -241,6 +241,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_LOGV2	0x0100	/* log format version 2	*/
 #define XFS_FSOP_GEOM_FLAGS_SECTOR	0x0200	/* sector sizes >1BB	*/
 #define XFS_FSOP_GEOM_FLAGS_ATTR2	0x0400	/* inline attributes rework */
+#define XFS_FSOP_GEOM_FLAGS_DIRV2CI	0x1000	/* ASCII only CI names */
 #define XFS_FSOP_GEOM_FLAGS_LAZYSB	0x4000	/* lazy superblock counters */
=20
=20
Index: ci/xfsprogs/include/xfs_sb.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/include/xfs_sb.h
+++ ci/xfsprogs/include/xfs_sb.h
@@ -46,10 +46,12 @@ struct xfs_mount;
 #define XFS_SB_VERSION_SECTORBIT	0x0800
 #define	XFS_SB_VERSION_EXTFLGBIT	0x1000
 #define	XFS_SB_VERSION_DIRV2BIT		0x2000
+#define	XFS_SB_VERSION_BORGBIT		0x4000
 #define	XFS_SB_VERSION_MOREBITSBIT	0x8000
 #define	XFS_SB_VERSION_OKSASHFBITS	\
 	(XFS_SB_VERSION_EXTFLGBIT | \
-	 XFS_SB_VERSION_DIRV2BIT)
+	 XFS_SB_VERSION_DIRV2BIT | \
+	 XFS_SB_VERSION_BORGBIT)
 #define	XFS_SB_VERSION_OKREALFBITS	\
 	(XFS_SB_VERSION_ATTRBIT | \
 	 XFS_SB_VERSION_NLINKBIT | \
@@ -416,6 +418,12 @@ static inline int xfs_sb_version_hassect
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
=20
+static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) =3D=3D XFS_SB_VERSION_4) && \
+		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
+}
+
 #define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
Index: ci/xfsprogs/libxfs/xfs_da_btree.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_da_btree.c
+++ ci/xfsprogs/libxfs/xfs_da_btree.c
@@ -1540,6 +1540,18 @@ xfs_da_hashname(const uchar_t *name, int
 	}
 }
=20
+enum xfs_dacmp
+xfs_da_compname(const uchar_t *name1, int len1, const uchar_t *name2, int =
len2)
+{
+	return (len1 =3D=3D len2 && memcmp(name1, name2, len1) =3D=3D 0) ?
+					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
+}
+
+const struct xfs_nameops xfs_default_nameops =3D {
+	.hashname	=3D xfs_da_hashname,
+	.compname	=3D xfs_da_compname
+};
+
 /*
  * Add a block to the btree ahead of the file.
  * Return the new block number to the caller.
Index: ci/xfsprogs/libxfs/xfs_dir2.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2.c
+++ ci/xfsprogs/libxfs/xfs_dir2.c
@@ -23,6 +23,57 @@
=20
 #include <xfs.h>
=20
+extern const struct xfs_nameops xfs_default_nameops;
+
+/*
+ * V1/OLDCI case-insensitive support for directories that was used in IRIX.
+ *
+ * This is ASCII only case support, ie. A-Z.
+ */
+static xfs_dahash_t
+xfs_ascii_ci_hashname(
+	const uchar_t	*name,
+	int		len)
+{
+	xfs_dahash_t	hash;
+	int		i;
+
+	for (i =3D 0, hash =3D 0; i < len; i++)
+		hash =3D tolower(name[i]) ^ rol32(hash, 7);
+
+	return hash;
+}
+
+static enum xfs_dacmp
+xfs_ascii_ci_compname(
+	const uchar_t	*name1,
+	int		len1,
+	const uchar_t	*name2,
+	int 		len2)
+{
+	enum xfs_dacmp	result;
+	int		i;
+
+	if (len1 !=3D len2)
+		return XFS_CMP_DIFFERENT;
+
+	result =3D XFS_CMP_EXACT;
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
+
=20
 /*
  * Initialize directory-related fields in the mount structure.
@@ -46,6 +97,10 @@ xfs_dir2_mount(
 		(mp->m_dirblksize - (uint)sizeof(xfs_da_node_hdr_t)) /
 		(uint)sizeof(xfs_da_node_entry_t);
 	mp->m_dir_magicpct =3D (mp->m_dirblksize * 37) / 100;
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
+		mp->m_dirnameops =3D &xfs_ascii_ci_nameops;
+	else
+		mp->m_dirnameops =3D &xfs_default_nameops;
 }
=20
 /*
@@ -98,7 +153,7 @@ xfs_dir2_createname(
 	 */
 	args.name =3D name;
 	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -149,7 +204,7 @@ xfs_dir2_lookup(
 	 */
 	args.name =3D name;
 	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
 	args.inumber =3D 0;
 	args.dp =3D dp;
 	args.firstblock =3D NULL;
@@ -206,7 +261,7 @@ xfs_dir2_removename(
 	 */
 	args.name =3D name;
 	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
 	args.inumber =3D ino;
 	args.dp =3D dp;
 	args.firstblock =3D first;
@@ -261,7 +316,7 @@ xfs_dir2_replace(
 	 */
 	args.name =3D name;
 	args.namelen =3D namelen;
-	args.hashval =3D xfs_da_hashname(name, namelen);
+	args.hashval =3D dp->i_mount->m_dirnameops->hashname(name, namelen);
 	args.inumber =3D inum;
 	args.dp =3D dp;
 	args.firstblock =3D first;
Index: ci/xfsprogs/libxfs/xfs_dir2_block.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_block.c
+++ ci/xfsprogs/libxfs/xfs_dir2_block.c
@@ -1046,8 +1046,9 @@ xfs_dir2_sf_to_block(
 		tagp =3D XFS_DIR2_DATA_ENTRY_TAG_P(dep);
 		INT_SET(*tagp, ARCH_CONVERT, (xfs_dir2_data_off_t)((char *)dep - (char *=
)block));
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		INT_SET(blp[2 + i].hashval, ARCH_CONVERT, xfs_da_hashname((const uchar_t=
 *)sfep->name, sfep->namelen));
-		INT_SET(blp[2 + i].address, ARCH_CONVERT, XFS_DIR2_BYTE_TO_DATAPTR(mp,
+		blp[2 + i].hashval =3D cpu_to_be32(mp->m_dirnameops->hashname(
+						sfep->name, sfep->namelen));
+		blp[2 + i].address =3D cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)block));
 		offset =3D (int)((char *)(tagp + 1) - (char *)block);
 		if (++i =3D=3D INT_GET(sfp->hdr.count, ARCH_CONVERT))
Index: ci/xfsprogs/libxfs/xfs_dir2_data.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/libxfs/xfs_dir2_data.c
+++ ci/xfsprogs/libxfs/xfs_dir2_data.c
@@ -126,7 +126,7 @@ xfs_dir2_data_check(
 			addr =3D XFS_DIR2_DB_OFF_TO_DATAPTR(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)d));
-			hash =3D xfs_da_hashname((char *)dep->name, dep->namelen);
+			hash =3D mp->m_dirnameops->hashname(dep->name, dep->namelen);
 			for (i =3D 0; i < INT_GET(btp->count, ARCH_CONVERT); i++) {
 				if (INT_GET(lep[i].address, ARCH_CONVERT) =3D=3D addr &&
 				    INT_GET(lep[i].hashval, ARCH_CONVERT) =3D=3D hash)
Index: ci/xfsprogs/man/man8/mkfs.xfs.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/man/man8/mkfs.xfs.8
+++ ci/xfsprogs/man/man8/mkfs.xfs.8
@@ -302,8 +302,8 @@ bits.
 .TP
 .BI maxpct=3D value
 This specifies the maximum percentage of space in the filesystem that
-can be allocated to inodes. The default=20
-.I value=20
+can be allocated to inodes. The default
+.I value
 is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
 for filesystems over 50TB.
 .IP
@@ -314,14 +314,14 @@ allocator will avoid these low blocks to
 maxpct, so a high value may result in a filesystem with nothing but
 inodes in a significant portion of the lower blocks of the filesystem.
 (This restriction is not present when the filesystem is mounted with
-the=20
-.I "inode64"=20
+the
+.I "inode64"
 option on 64-bit platforms).
 .IP
 Setting the value to 0 means that essentially all of the filesystem
 can become inode blocks, subject to inode32 restrictions.
 .IP
-This value can be modified with=20
+This value can be modified with
 .Ixfs_growfs(8)
 .
 .TP
@@ -340,7 +340,7 @@ filesystem needs to be mountable by a ve
 that does not have the inode alignment feature
 (any release of IRIX before 6.2, and IRIX 6.2 without XFS patches).
 .TP
-.BI attr=3D value=20
+.BI attr=3D value
 This is used to specify the version of extended attribute inline
 allocation policy to be used.  By default, this is 2, which uses an
 efficient algorithm for managing the available inline inode space
@@ -489,10 +489,17 @@ filesystem block size.
 .BI version=3D value
 The naming (directory) version
 .I value
-can be either 1 or 2, defaulting to 2 if unspecified.
-With version 2 directories,
-the directory block size can be any power of 2 size
-from the filesystem block size up to 65536.
+can be either 2 or 'ci', defaulting to 2 if unspecified.
+With version 2 directories, the directory block size can be
+any power of 2 size from the filesystem block size up to 65536.
+.IP
+The
+.B version=3Dci
+option enables ASCII only case-insensitive filename lookup and version
+2 directories. Filenames are case-preserving, that is, the names
+are stored in directories using the case they were created with.
+.IP
+Note: Version 1 directories are not supported.
 .RE
 .TP
 .BI \-p " protofile"
Index: ci/xfsprogs/mkfs/xfs_mkfs.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.c
+++ ci/xfsprogs/mkfs/xfs_mkfs.c
@@ -678,6 +678,7 @@ main(
 	xfs_alloc_rec_t		*nrec;
 	int			nsflag;
 	int			nvflag;
+	int			nci;
 	int			Nflag;
 	char			*p;
 	char			*protofile;
@@ -720,8 +721,9 @@ main(
 	loginternal =3D 1;
 	logversion =3D 2;
 	logagno =3D logblocks =3D rtblocks =3D rtextblocks =3D 0;
-	Nflag =3D nlflag =3D nsflag =3D nvflag =3D 0;
-	dirblocklog =3D dirblocksize =3D dirversion =3D 0;
+	Nflag =3D nlflag =3D nsflag =3D nvflag =3D nci =3D 0;
+	dirblocklog =3D dirblocksize =3D 0;
+	dirversion =3D XFS_DFL_DIR_VERSION;
 	qflag =3D 0;
 	imaxpct =3D inodelog =3D inopblock =3D isize =3D 0;
 	iaflag =3D XFS_IFLAG_ALIGN;
@@ -1236,9 +1238,14 @@ main(
 						reqval('n', nopts, N_VERSION);
 					if (nvflag)
 						respec('n', nopts, N_VERSION);
-					dirversion =3D atoi(value);
-					if (dirversion < 1 || dirversion > 2)
-						illegal(value, "n version");
+					if (!strcmp(value, "ci")) {
+						nci =3D 1; /* ASCII CI mode */
+					} else {
+						dirversion =3D atoi(value);
+						if (dirversion !=3D 2)
+							illegal(value,
+								"n version");
+					}
 					nvflag =3D 1;
 					break;
 				default:
@@ -1412,33 +1419,19 @@ main(
 		logversion =3D 2;
 	}
=20
-	if (!nvflag)
-		dirversion =3D (nsflag || nlflag) ? 2 : XFS_DFL_DIR_VERSION;
-	switch (dirversion) {
-	case 1:
-		if ((nsflag || nlflag) && dirblocklog !=3D blocklog) {
+	if (nsflag || nlflag) {
+		if (dirblocksize < blocksize ||
+					dirblocksize > XFS_MAX_BLOCKSIZE) {
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
 	}
=20
 	if (daflag && dasize) {
@@ -2024,7 +2017,7 @@ an AG size that is one stripe unit small
 		   "         =3D%-22s sectsz=3D%-5u attr=3D%u\n"
 		   "data     =3D%-22s bsize=3D%-6u blocks=3D%llu, imaxpct=3D%u\n"
 		   "         =3D%-22s sunit=3D%-6u swidth=3D%u blks\n"
-		   "naming   =3Dversion %-14u bsize=3D%-6u\n"
+		   "naming   =3Dversion %-14u bsize=3D%-6u mixed-case=3D%c\n"
 		   "log      =3D%-22s bsize=3D%-6d blocks=3D%lld, version=3D%d\n"
 		   "         =3D%-22s sectsz=3D%-5u sunit=3D%d blks, lazy-count=3D%d\n"
 		   "realtime =3D%-22s extsz=3D%-6d blocks=3D%lld, rtextents=3D%lld\n"),
@@ -2033,7 +2026,7 @@ an AG size that is one stripe unit small
 			"", blocksize, (long long)dblocks,
 			       calc_default_imaxpct(blocklog, dblocks),
 			"", dsunit, dswidth,
-			dirversion, dirversion =3D=3D 1 ? blocksize : dirblocksize,
+			dirversion, dirblocksize, nci ? 'N' : 'Y',
 			logfile, 1 << blocklog, (long long)logblocks,
 			logversion, "", lsectorsize, lsunit, lazy_sb_counters,
 			rtfile, rtextblocks << blocklog,
@@ -2078,8 +2071,7 @@ an AG size that is one stripe unit small
 	sbp->sb_qflags =3D 0;
 	sbp->sb_unit =3D dsunit;
 	sbp->sb_width =3D dswidth;
-	if (dirversion =3D=3D 2)
-		sbp->sb_dirblklog =3D dirblocklog - blocklog;
+	sbp->sb_dirblklog =3D dirblocklog - blocklog;
 	if (logversion =3D=3D 2) {	/* This is stored in bytes */
 		lsunit =3D (lsunit =3D=3D 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
 		sbp->sb_logsunit =3D lsunit;
@@ -2097,12 +2089,13 @@ an AG size that is one stripe unit small
 		sbp->sb_logsectlog =3D 0;
 		sbp->sb_logsectsize =3D 0;
 	}
-	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters, attrversion =
=3D=3D 2, 0);
-	sbp->sb_versionnum =3D XFS_SB_VERSION_MKFS(
-			iaflag, dsunit !=3D 0,
-			dirversion =3D=3D 2, logversion =3D=3D 2, attrversion =3D=3D 1,
-			(sectorsize !=3D BBSIZE || lsectorsize !=3D BBSIZE),
-			sbp->sb_features2 !=3D 0);
+	sbp->sb_features2 =3D XFS_SB_VERSION2_MKFS(lazy_sb_counters,
+					attrversion =3D=3D 2, 0);
+	sbp->sb_versionnum =3D XFS_SB_VERSION_MKFS(iaflag, dsunit !=3D 0,
+					logversion =3D=3D 2, attrversion =3D=3D 1,
+					(sectorsize !=3D BBSIZE ||
+							lsectorsize !=3D BBSIZE),
+					nci, sbp->sb_features2 !=3D 0);
 	/*
 	 * Due to a structure alignment issue, sb_features2 ended up in one
 	 * of two locations, the second "incorrect" location represented by
Index: ci/xfsprogs/mkfs/xfs_mkfs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/mkfs/xfs_mkfs.h
+++ ci/xfsprogs/mkfs/xfs_mkfs.h
@@ -20,17 +20,18 @@
=20
 #define XFS_DFL_SB_VERSION_BITS \
                 (XFS_SB_VERSION_NLINKBIT | \
-                 XFS_SB_VERSION_EXTFLGBIT)
+                 XFS_SB_VERSION_EXTFLGBIT | \
+                 XFS_SB_VERSION_DIRV2BIT)
=20
-#define XFS_SB_VERSION_MKFS(ia,dia,dir2,log2,attr1,sflag,more) (\
-	((ia)||(dia)||(dir2)||(log2)||(attr1)||(sflag)||(more)) ? \
+#define XFS_SB_VERSION_MKFS(ia,dia,log2,attr1,sflag,ci,more) (\
+	((ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
 	( XFS_SB_VERSION_4 |						\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
-		((dir2) ? XFS_SB_VERSION_DIRV2BIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
 		((attr1) ? XFS_SB_VERSION_ATTRBIT : 0) |		\
 		((sflag) ? XFS_SB_VERSION_SECTORBIT : 0) |		\
+		((ci) ? XFS_SB_VERSION_BORGBIT : 0) |			\
 		((more) ? XFS_SB_VERSION_MOREBITSBIT : 0) |		\
 	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
Index: ci/xfsprogs/repair/phase6.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- ci.orig/xfsprogs/repair/phase6.c
+++ ci/xfsprogs/repair/phase6.c
@@ -93,6 +93,7 @@ typedef struct freetab {
  */
 static int
 dir_hash_add(
+	xfs_mount_t		*mp,
 	dir_hash_tab_t		*hashtab,
 	__uint32_t		addr,
 	xfs_ino_t		inum,
@@ -113,7 +114,7 @@ dir_hash_add(
 	dup =3D 0;
=20
 	if (!junk) {
-		hash =3D libxfs_da_hashname(name, namelen);
+		hash =3D mp->m_dirnameops->hashname(name, namelen);
 		byhash =3D DIR_HASH_FUNC(hashtab, hash);
=20
 		/*
@@ -1589,7 +1590,7 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, (da_bno << mp->m_sb.sb_blocklog) +
+		if (!dir_hash_add(mp, hashtab, (da_bno << mp->m_sb.sb_blocklog) +
 				entry->nameidx, lino, entry->namelen,
 				namest->name)) {
 			nbad++;
@@ -2260,7 +2261,7 @@ longform_dir2_entry_check_data(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, addr, inum, dep->namelen,
+		if (!dir_hash_add(mp, hashtab, addr, inum, dep->namelen,
 				dep->name)) {
 			nbad++;
 			if (entry_junked(_("entry \"%s\" (ino %llu) in dir "
@@ -2870,7 +2871,7 @@ shortform_dir_entry_check(xfs_mount_t	*m
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab,
+		if (!dir_hash_add(mp, hashtab,
 				(xfs_dir2_dataptr_t)(sf_entry - &sf->list[0]),
 				lino, sf_entry->namelen, sf_entry->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "
@@ -3275,7 +3276,7 @@ shortform_dir2_entry_check(xfs_mount_t	*
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(hashtab, (xfs_dir2_dataptr_t)
+		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
 					(sfep - XFS_DIR2_SF_FIRSTENTRY(sfp)),
 				lino, sfep->namelen, sfep->name)) {
 			do_warn(_("entry \"%s\" (ino %llu) in dir %llu is a "

------------IXmiutYgjYq48aBi7Ucq48--
