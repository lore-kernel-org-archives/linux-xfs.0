Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D25CE29DFE
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10844AC005
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:36 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id QbrHeWT1eKZwXOmY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:12 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 7327C208A1
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:11 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2qk5nF5z5vN3
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:10 +0100 (CET)
Date: Tue, 12 Jan 2016 20:59:35 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 1/6] Move from __uint*_t types to uint*_t and likewise for
	__int*_t
Message-ID: <20160112195935.GB568@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452627740.git.felix.janda@posteo.de>
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
To: xfs@oss.sgi.com

The uint*_t and int*_t are defined by C99 and should be prefered
over the less portable __uint*_t and __int*_t variants. The
necessary <stdint.h> include is in platformdefs.h, which gets
included in most places via libxfs.h. In the public headers
<stdint.h> is included in <xfs/xfs_types.h>.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 copy/xfs_copy.c           |  14 ++--
 copy/xfs_copy.h           |   2 +-
 db/attr.c                 |   8 +-
 db/attrshort.c            |   4 +-
 db/bit.c                  |   4 +-
 db/bit.h                  |   2 +-
 db/block.c                |   8 +-
 db/check.c                |  18 ++---
 db/convert.c              |  28 +++----
 db/faddr.c                |  14 ++--
 db/field.c                |  44 +++++------
 db/fprint.c               |   8 +-
 db/frag.c                 |   8 +-
 db/inode.c                |  30 ++++----
 db/io.c                   |   4 +-
 db/io.h                   |   8 +-
 db/metadump.c             |  12 +--
 db/sb.c                   |   6 +-
 fsr/xfs_fsr.c             |   2 +-
 include/darwin.h          |   9 ---
 include/freebsd.h         |   6 +-
 include/gnukfreebsd.h     |   6 +-
 include/irix.h            |  28 +++----
 include/linux.h           |   8 +-
 include/xfs_arch.h        |  22 +++---
 include/xfs_inode.h       |   4 +-
 include/xfs_log_recover.h |   2 +-
 include/xfs_metadump.h    |   4 +-
 include/xfs_mount.h       |  20 ++---
 libhandle/handle.c        |   2 +-
 libhandle/jdm.c           |   2 +-
 libxfs/darwin.c           |   2 +-
 libxfs/freebsd.c          |   2 +-
 libxfs/init.c             |   2 +-
 libxfs/irix.c             |   2 +-
 libxfs/libxfs_priv.h      |   4 +-
 libxfs/linux.c            |   2 +-
 libxfs/logitem.c          |   2 +-
 libxfs/radix-tree.c       |   8 +-
 libxfs/rdwr.c             |   6 +-
 libxfs/util.c             |  14 ++--
 libxfs/xfs_alloc_btree.c  |  10 +--
 libxfs/xfs_attr_remote.c  |   8 +-
 libxfs/xfs_attr_sf.h      |  18 ++---
 libxfs/xfs_bit.h          |  24 +++---
 libxfs/xfs_bmap_btree.c   |   8 +-
 libxfs/xfs_btree.c        |  12 +--
 libxfs/xfs_btree.h        |  14 ++--
 libxfs/xfs_cksum.h        |  14 ++--
 libxfs/xfs_da_btree.c     |   2 +-
 libxfs/xfs_da_btree.h     |   8 +-
 libxfs/xfs_da_format.c    |  24 +++---
 libxfs/xfs_da_format.h    |  60 +++++++--------
 libxfs/xfs_dir2.h         |   8 +-
 libxfs/xfs_dir2_leaf.c    |  12 +--
 libxfs/xfs_dir2_priv.h    |   2 +-
 libxfs/xfs_format.h       |  98 ++++++++++++------------
 libxfs/xfs_fs.h           |  12 +--
 libxfs/xfs_ialloc.c       |   6 +-
 libxfs/xfs_ialloc_btree.c |   4 +-
 libxfs/xfs_inode_buf.c    |   2 +-
 libxfs/xfs_log_format.h   | 190 +++++++++++++++++++++++-----------------------
 libxfs/xfs_quota_defs.h   |   4 +-
 libxfs/xfs_rtbitmap.c     |   2 +-
 libxfs/xfs_sb.c           |   4 +-
 libxfs/xfs_types.h        |  46 +++++------
 logprint/log_misc.c       |   6 +-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/proto.c              |   2 +-
 mkfs/xfs_mkfs.c           |  88 ++++++++++-----------
 quota/edit.c              |  64 ++++++++--------
 quota/free.c              |  44 +++++------
 quota/quot.c              |  24 +++---
 quota/quota.c             |   4 +-
 quota/quota.h             |  12 +--
 quota/report.c            |   2 +-
 quota/state.c             |   2 +-
 quota/util.c              |  66 ++++++++--------
 repair/README             |   2 +-
 repair/agheader.h         |  14 ++--
 repair/attr_repair.h      |  26 +++----
 repair/avl64.c            |  38 +++++-----
 repair/avl64.h            |  18 ++---
 repair/dino_chunks.c      |   2 +-
 repair/dinode.c           |  38 +++++-----
 repair/dinode.h           |   4 +-
 repair/dir2.c             |   2 +-
 repair/globals.h          |  16 ++--
 repair/incore.c           |  10 +--
 repair/incore.h           |  42 +++++-----
 repair/incore_ext.c       |   6 +-
 repair/incore_ino.c       |  72 +++++++++---------
 repair/phase2.c           |   2 +-
 repair/phase3.c           |   6 +-
 repair/phase4.c           |   4 +-
 repair/phase5.c           |  40 +++++-----
 repair/phase6.c           |  18 ++---
 repair/phase7.c           |   6 +-
 repair/progress.c         |  30 ++++----
 repair/progress.h         |   4 +-
 repair/sb.c               |  10 +--
 repair/scan.c             |  42 +++++-----
 repair/scan.h             |  12 +--
 103 files changed, 870 insertions(+), 883 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 15a3f33..425cd7a 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -43,7 +43,7 @@ unsigned int	source_sectorsize;	/* source disk sectorsize */
 
 xfs_agblock_t	first_agbno;
 
-__uint64_t	barcount[11];
+uint64_t	barcount[11];
 
 unsigned int	num_targets;
 target_control	*target;
@@ -303,7 +303,7 @@ usage(void)
 }
 
 void
-init_bar(__uint64_t source_blocks)
+init_bar(uint64_t source_blocks)
 {
 	int	i;
 
@@ -312,7 +312,7 @@ init_bar(__uint64_t source_blocks)
 }
 
 int
-bump_bar(int tenths, __uint64_t numblocks)
+bump_bar(int tenths, uint64_t numblocks)
 {
 	static char *bar[11] = {
 		" 0% ",
@@ -522,8 +522,8 @@ main(int argc, char **argv)
 	xfs_off_t	pos;
 	size_t		length;
 	int		c;
-	__uint64_t	size, sizeb;
-	__uint64_t	numblocks = 0;
+	uint64_t	size, sizeb;
+	uint64_t	numblocks = 0;
 	int		wblocks = 0;
 	int		num_threads = 0;
 	struct dioattr	d;
@@ -939,8 +939,8 @@ main(int argc, char **argv)
 	num_ags = mp->m_sb.sb_agcount;
 
 	init_bar(mp->m_sb.sb_blocksize / BBSIZE
-			* ((__uint64_t)mp->m_sb.sb_dblocks
-			    - (__uint64_t)mp->m_sb.sb_fdblocks + 10 * num_ags));
+			* ((uint64_t)mp->m_sb.sb_dblocks
+			    - (uint64_t)mp->m_sb.sb_fdblocks + 10 * num_ags));
 
 	kids = num_targets;
 
diff --git a/copy/xfs_copy.h b/copy/xfs_copy.h
index 2737068..53c6e42 100644
--- a/copy/xfs_copy.h
+++ b/copy/xfs_copy.h
@@ -76,7 +76,7 @@ typedef struct {
 
 typedef int thread_id;
 typedef int tm_index;			/* index into thread mask array */
-typedef __uint32_t thread_mask;		/* a thread mask */
+typedef uint32_t thread_mask;		/* a thread mask */
 
 typedef struct {
 	char		*name;
diff --git a/db/attr.c b/db/attr.c
index e26ac67..6f56953 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -77,16 +77,16 @@ const field_t	attr_leaf_entry_flds[] = {
 	{ "nameidx", FLDT_UINT16D, OI(LEOFF(nameidx)), C1, 0, TYP_NONE },
 	{ "flags", FLDT_UINT8X, OI(LEOFF(flags)), C1, FLD_SKIPALL, TYP_NONE },
 	{ "incomplete", FLDT_UINT1,
-	  OI(LEOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_INCOMPLETE_BIT - 1), C1,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_INCOMPLETE_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "root", FLDT_UINT1,
-	  OI(LEOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_ROOT_BIT - 1), C1, 0,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_ROOT_BIT - 1), C1, 0,
 	  TYP_NONE },
 	{ "secure", FLDT_UINT1,
-	  OI(LEOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
 	{ "local", FLDT_UINT1,
-	  OI(LEOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
+	  OI(LEOFF(flags) + bitsz(uint8_t) - XFS_ATTR_LOCAL_BIT - 1), C1, 0,
 	  TYP_NONE },
 	{ "pad2", FLDT_UINT8X, OI(LEOFF(pad2)), C1, FLD_SKIPALL, TYP_NONE },
 	{ NULL }
diff --git a/db/attrshort.c b/db/attrshort.c
index d82559c..2ef358f 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -51,10 +51,10 @@ const field_t	attr_sf_entry_flds[] = {
 	{ "valuelen", FLDT_UINT8D, OI(EOFF(valuelen)), C1, 0, TYP_NONE },
 	{ "flags", FLDT_UINT8X, OI(EOFF(flags)), C1, FLD_SKIPALL, TYP_NONE },
 	{ "root", FLDT_UINT1,
-	  OI(EOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_ROOT_BIT - 1), C1, 0,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_ROOT_BIT - 1), C1, 0,
 	  TYP_NONE },
 	{ "secure", FLDT_UINT1,
-	  OI(EOFF(flags) + bitsz(__uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
+	  OI(EOFF(flags) + bitsz(uint8_t) - XFS_ATTR_SECURE_BIT - 1), C1, 0,
 	  TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(EOFF(nameval)), attr_sf_entry_name_count,
 	  FLD_COUNT, TYP_NONE },
diff --git a/db/bit.c b/db/bit.c
index 24872bf..53cbcb3 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -60,7 +60,7 @@ setbit(
 	}
 }
 
-__int64_t
+int64_t
 getbitval(
 	void		*obj,
 	int		bitoff,
@@ -70,7 +70,7 @@ getbitval(
 	int		bit;
 	int		i;
 	char		*p;
-	__int64_t	rval;
+	int64_t		rval;
 	int		signext;
 	int		z1, z2, z3, z4;
 
diff --git a/db/bit.h b/db/bit.h
index 80ba24c..7601066 100644
--- a/db/bit.h
+++ b/db/bit.h
@@ -25,5 +25,5 @@
 #define	BVUNSIGNED	0
 #define	BVSIGNED	1
 
-extern __int64_t	getbitval(void *obj, int bitoff, int nbits, int flags);
+extern int64_t	getbitval(void *obj, int bitoff, int nbits, int flags);
 extern void             setbitval(void *obuf, int bitoff, int nbits, void *ibuf);
diff --git a/db/block.c b/db/block.c
index 4a357ce..77b9054 100644
--- a/db/block.c
+++ b/db/block.c
@@ -98,7 +98,7 @@ ablock_f(
 	}
 	dfsbno = bm.startblock + (bno - bm.startoff);
 	ASSERT(typtab[TYP_ATTR].typnm == TYP_ATTR);
-	set_cur(&typtab[TYP_ATTR], (__int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+	set_cur(&typtab[TYP_ATTR], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
 		blkbb, DB_RING_ADD, NULL);
 	return 0;
 }
@@ -128,14 +128,14 @@ daddr_f(
 	int		argc,
 	char		**argv)
 {
-	__int64_t	d;
+	int64_t		d;
 	char		*p;
 
 	if (argc == 1) {
 		dbprintf(_("current daddr is %lld\n"), iocur_top->off >> BBSHIFT);
 		return 0;
 	}
-	d = (__int64_t)strtoull(argv[1], &p, 0);
+	d = (int64_t)strtoull(argv[1], &p, 0);
 	if (*p != '\0' ||
 	    d >= mp->m_sb.sb_dblocks << (mp->m_sb.sb_blocklog - BBSHIFT)) {
 		dbprintf(_("bad daddr %s\n"), argv[1]);
@@ -197,7 +197,7 @@ dblock_f(
 	ASSERT(typtab[type].typnm == type);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[type], (__int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+	set_cur(&typtab[type], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
 		nb * blkbb, DB_RING_ADD, nex > 1 ? &bbmap : NULL);
 	free(bmp);
 	return 0;
diff --git a/db/check.c b/db/check.c
index 838db53..8ffa156 100644
--- a/db/check.c
+++ b/db/check.c
@@ -112,8 +112,8 @@ typedef struct dirhash {
 
 static xfs_extlen_t	agffreeblks;
 static xfs_extlen_t	agflongest;
-static __uint64_t	agf_aggr_freeblks;	/* aggregate count over all */
-static __uint32_t	agfbtreeblks;
+static uint64_t	agf_aggr_freeblks;	/* aggregate count over all */
+static uint32_t	agfbtreeblks;
 static int		lazycount;
 static xfs_agino_t	agicount;
 static xfs_agino_t	agifreecount;
@@ -122,10 +122,10 @@ static int		blist_size;
 static char		**dbmap;	/* really dbm_t:8 */
 static dirhash_t	**dirhash;
 static int		error;
-static __uint64_t	fdblocks;
-static __uint64_t	frextents;
-static __uint64_t	icount;
-static __uint64_t	ifree;
+static uint64_t	fdblocks;
+static uint64_t	frextents;
+static uint64_t	icount;
+static uint64_t	ifree;
 static inodata_t	***inodata;
 static int		inodata_hash_size;
 static inodata_t	***inomap;
@@ -1173,7 +1173,7 @@ blocktrash_f(
 		goto out;
 	}
 	for (i = 0; i < count; i++) {
-		randb = (xfs_rfsblock_t)((((__int64_t)random() << 32) |
+		randb = (xfs_rfsblock_t)((((int64_t)random() << 32) |
 					 random()) % blocks);
 		for (bi = 0, agno = 0, done = 0;
 		     !done && agno < mp->m_sb.sb_agcount;
@@ -2991,7 +2991,7 @@ process_leaf_node_dir_v2(
 		}
 		if (v)
 			dbprintf(_("dir inode %lld block %u=%llu\n"), id->ino,
-				(__uint32_t)dbno,
+				(uint32_t)dbno,
 				(xfs_fsblock_t)bmp->startblock);
 		push_cur();
 		if (nex > 1)
@@ -3004,7 +3004,7 @@ process_leaf_node_dir_v2(
 			if (!sflag || v)
 				dbprintf(_("can't read block %u for directory "
 					 "inode %lld\n"),
-					(__uint32_t)dbno, id->ino);
+					(uint32_t)dbno, id->ino);
 			error++;
 			pop_cur();
 			dbno += mp->m_dir_geo->fsbcount - 1;
diff --git a/db/convert.c b/db/convert.c
index a337abe..fa4f962 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -24,13 +24,13 @@
 
 #define	M(A)	(1 << CT_ ## A)
 #define	agblock_to_bytes(x)	\
-	((__uint64_t)(x) << mp->m_sb.sb_blocklog)
+	((uint64_t)(x) << mp->m_sb.sb_blocklog)
 #define	agino_to_bytes(x)	\
-	((__uint64_t)(x) << mp->m_sb.sb_inodelog)
+	((uint64_t)(x) << mp->m_sb.sb_inodelog)
 #define	agnumber_to_bytes(x)	\
-	agblock_to_bytes((__uint64_t)(x) * mp->m_sb.sb_agblocks)
+	agblock_to_bytes((uint64_t)(x) * mp->m_sb.sb_agblocks)
 #define	daddr_to_bytes(x)	\
-	((__uint64_t)(x) << BBSHIFT)
+	((uint64_t)(x) << BBSHIFT)
 #define	fsblock_to_bytes(x)	\
 	(agnumber_to_bytes(XFS_FSB_TO_AGNO(mp, (x))) + \
 	 agblock_to_bytes(XFS_FSB_TO_AGBNO(mp, (x))))
@@ -38,7 +38,7 @@
 	(agnumber_to_bytes(XFS_INO_TO_AGNO(mp, (x))) + \
 	 agino_to_bytes(XFS_INO_TO_AGINO(mp, (x))))
 #define	inoidx_to_bytes(x)	\
-	((__uint64_t)(x) << mp->m_sb.sb_inodelog)
+	((uint64_t)(x) << mp->m_sb.sb_inodelog)
 
 typedef enum {
 	CT_NONE = -1,
@@ -68,7 +68,7 @@ typedef union {
 	xfs_agnumber_t	agnumber;
 	int		bboff;
 	int		blkoff;
-	__uint64_t	byte;
+	uint64_t	byte;
 	xfs_daddr_t	daddr;
 	xfs_fsblock_t	fsblock;
 	xfs_ino_t	ino;
@@ -76,7 +76,7 @@ typedef union {
 	int		inooff;
 } cval_t;
 
-static __uint64_t		bytevalue(ctype_t ctype, cval_t *val);
+static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
 static int		convert_f(int argc, char **argv);
 static int		getvalue(char *s, ctype_t ctype, cval_t *val);
 static ctype_t		lookupcty(char *ctyname);
@@ -118,7 +118,7 @@ static const cmdinfo_t	convert_cmd =
 	{ "convert", NULL, convert_f, 3, 9, 0, "type num [type num]... type",
 	  "convert from one address form to another", NULL };
 
-static __uint64_t
+static uint64_t
 bytevalue(ctype_t ctype, cval_t *val)
 {
 	switch (ctype) {
@@ -129,9 +129,9 @@ bytevalue(ctype_t ctype, cval_t *val)
 	case CT_AGNUMBER:
 		return agnumber_to_bytes(val->agnumber);
 	case CT_BBOFF:
-		return (__uint64_t)val->bboff;
+		return (uint64_t)val->bboff;
 	case CT_BLKOFF:
-		return (__uint64_t)val->blkoff;
+		return (uint64_t)val->blkoff;
 	case CT_BYTE:
 		return val->byte;
 	case CT_DADDR:
@@ -143,7 +143,7 @@ bytevalue(ctype_t ctype, cval_t *val)
 	case CT_INOIDX:
 		return inoidx_to_bytes(val->inoidx);
 	case CT_INOOFF:
-		return (__uint64_t)val->inooff;
+		return (uint64_t)val->inooff;
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -160,7 +160,7 @@ convert_f(int argc, char **argv)
 	cval_t		cvals[NCTS] = {};
 	int		i;
 	int		mask;
-	__uint64_t	v;
+	uint64_t	v;
 	ctype_t		wtype;
 
 	/* move past the "convert" command */
@@ -262,7 +262,7 @@ static int
 getvalue(char *s, ctype_t ctype, cval_t *val)
 {
 	char		*p;
-	__uint64_t	v;
+	uint64_t	v;
 
 	v = strtoull(s, &p, 0);
 	if (*p != '\0') {
@@ -286,7 +286,7 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 		val->blkoff = (int)v;
 		break;
 	case CT_BYTE:
-		val->byte = (__uint64_t)v;
+		val->byte = (uint64_t)v;
 		break;
 	case CT_DADDR:
 		val->daddr = (xfs_daddr_t)v;
diff --git a/db/faddr.c b/db/faddr.c
index e368d0d..6ded295 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -79,11 +79,11 @@ fa_attrblock(
 	typnm_t		next)
 {
 	bmap_ext_t	bm;
-	__uint32_t	bno;
+	uint32_t	bno;
 	xfs_fsblock_t	dfsbno;
 	int		nex;
 
-	bno = (__uint32_t)getbitval(obj, bit, bitsz(bno), BVUNSIGNED);
+	bno = (uint32_t)getbitval(obj, bit, bitsz(bno), BVUNSIGNED);
 	if (bno == 0) {
 		dbprintf(_("null attribute block number, cannot set new addr\n"));
 		return;
@@ -96,7 +96,7 @@ fa_attrblock(
 	}
 	dfsbno = bm.startblock + (bno - bm.startoff);
 	ASSERT(typtab[next].typnm == next);
-	set_cur(&typtab[next], (__int64_t)XFS_FSB_TO_DADDR(mp, dfsbno), blkbb,
+	set_cur(&typtab[next], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno), blkbb,
 		DB_RING_ADD, NULL);
 }
 
@@ -276,11 +276,11 @@ fa_dirblock(
 {
 	bbmap_t		bbmap;
 	bmap_ext_t	*bmp;
-	__uint32_t	bno;
+	uint32_t	bno;
 	xfs_fsblock_t	dfsbno;
 	int		nex;
 
-	bno = (__uint32_t)getbitval(obj, bit, bitsz(bno), BVUNSIGNED);
+	bno = (uint32_t)getbitval(obj, bit, bitsz(bno), BVUNSIGNED);
 	if (bno == 0) {
 		dbprintf(_("null directory block number, cannot set new addr\n"));
 		return;
@@ -297,7 +297,7 @@ fa_dirblock(
 	ASSERT(typtab[next].typnm == next);
 	if (nex > 1)
 		make_bbmap(&bbmap, nex, bmp);
-	set_cur(&typtab[next], (__int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
+	set_cur(&typtab[next], (int64_t)XFS_FSB_TO_DADDR(mp, dfsbno),
 		XFS_FSB_TO_BB(mp, mp->m_dir_geo->fsbcount), DB_RING_ADD,
 		nex > 1 ? &bbmap : NULL);
 	free(bmp);
@@ -317,7 +317,7 @@ fa_drfsbno(
 		return;
 	}
 	ASSERT(typtab[next].typnm == next);
-	set_cur(&typtab[next], (__int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
+	set_cur(&typtab[next], (int64_t)XFS_FSB_TO_BB(mp, bno), blkbb,
 		DB_RING_ADD, NULL);
 }
 
diff --git a/db/field.c b/db/field.c
index 843c385..2c8d414 100644
--- a/db/field.c
+++ b/db/field.c
@@ -83,7 +83,7 @@ const ftattr_t	ftattrtab[] = {
 	  attr_sf_entry_size, FTARG_SIZE, NULL, attr_sf_entry_flds },
 	{ FLDT_ATTR_SF_HDR, "attr_sf_hdr", NULL, (char *)attr_sf_hdr_flds,
 	  SI(bitsz(struct xfs_attr_sf_hdr)), 0, NULL, attr_sf_hdr_flds },
-	{ FLDT_ATTRBLOCK, "attrblock", fp_num, "%u", SI(bitsz(__uint32_t)), 0,
+	{ FLDT_ATTRBLOCK, "attrblock", fp_num, "%u", SI(bitsz(uint32_t)), 0,
 	  fa_attrblock, NULL },
 	{ FLDT_ATTRSHORT, "attrshort", NULL, (char *)attr_shortform_flds,
 	  attrshort_size, FTARG_SIZE, NULL, attr_shortform_flds },
@@ -165,7 +165,7 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(xfs_alloc_rec_t)), 0, NULL, cntbt_rec_flds },
 
 /* CRC field */
-	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(__uint32_t)),
+	{ FLDT_CRC, "crc", fp_crc, "%#x (%s)", SI(bitsz(uint32_t)),
 	  0, NULL, NULL },
 
 	{ FLDT_DEV, "dev", fp_num, "%#x", SI(bitsz(xfs_dev_t)), 0, NULL, NULL },
@@ -180,7 +180,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_DINODE_CORE, "dinode_core", NULL, (char *)inode_core_flds,
 	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_core_flds },
 	{ FLDT_DINODE_FMT, "dinode_fmt", fp_dinode_fmt, NULL,
-	  SI(bitsz(__int8_t)), 0, NULL, NULL },
+	  SI(bitsz(int8_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_u_flds },
 	{ FLDT_DINODE_V3, "dinode_v3", NULL, (char *)inode_v3_flds,
@@ -261,7 +261,7 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_DA3_NODE_HDR, "dir_node_hdr", NULL, (char *)da3_node_hdr_flds,
 	  SI(bitsz(struct xfs_da3_node_hdr)), 0, NULL, da3_node_hdr_flds },
 
-	{ FLDT_DIRBLOCK, "dirblock", fp_num, "%u", SI(bitsz(__uint32_t)), 0,
+	{ FLDT_DIRBLOCK, "dirblock", fp_num, "%u", SI(bitsz(uint32_t)), 0,
 	  fa_dirblock, NULL },
 	{ FLDT_DISK_DQUOT, "disk_dquot", NULL, (char *)disk_dquot_flds,
 	  SI(bitsz(xfs_disk_dquot_t)), 0, NULL, disk_dquot_flds },
@@ -301,15 +301,15 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SIZE, NULL, inode_crc_flds },
 	{ FLDT_INOFREE, "inofree", fp_num, "%#llx", SI(bitsz(xfs_inofree_t)), 0,
 	  NULL, NULL },
-	{ FLDT_INT16D, "int16d", fp_num, "%d", SI(bitsz(__int16_t)),
+	{ FLDT_INT16D, "int16d", fp_num, "%d", SI(bitsz(int16_t)),
 	  FTARG_SIGNED, NULL, NULL },
-	{ FLDT_INT32D, "int32d", fp_num, "%d", SI(bitsz(__int32_t)),
+	{ FLDT_INT32D, "int32d", fp_num, "%d", SI(bitsz(int32_t)),
 	  FTARG_SIGNED, NULL, NULL },
-	{ FLDT_INT64D, "int64d", fp_num, "%lld", SI(bitsz(__int64_t)),
+	{ FLDT_INT64D, "int64d", fp_num, "%lld", SI(bitsz(int64_t)),
 	  FTARG_SIGNED, NULL, NULL },
-	{ FLDT_INT8D, "int8d", fp_num, "%d", SI(bitsz(__int8_t)), FTARG_SIGNED,
+	{ FLDT_INT8D, "int8d", fp_num, "%d", SI(bitsz(int8_t)), FTARG_SIGNED,
 	  NULL, NULL },
-	{ FLDT_NSEC, "nsec", fp_num, "%09d", SI(bitsz(__int32_t)), FTARG_SIGNED,
+	{ FLDT_NSEC, "nsec", fp_num, "%09d", SI(bitsz(int32_t)), FTARG_SIGNED,
 	  NULL, NULL },
 	{ FLDT_QCNT, "qcnt", fp_num, "%llu", SI(bitsz(xfs_qcnt_t)), 0, NULL,
 	  NULL },
@@ -322,34 +322,34 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_SYMLINK_CRC, "symlink", NULL, (char *)symlink_crc_flds,
 	  symlink_size, FTARG_SIZE, NULL, symlink_crc_flds },
 
-	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(__int32_t)), FTARG_SIGNED,
+	{ FLDT_TIME, "time", fp_time, NULL, SI(bitsz(int32_t)), FTARG_SIGNED,
 	  NULL, NULL },
 	{ FLDT_TIMESTAMP, "timestamp", NULL, (char *)timestamp_flds,
 	  SI(bitsz(xfs_timestamp_t)), 0, NULL, timestamp_flds },
 	{ FLDT_UINT1, "uint1", fp_num, "%u", SI(1), 0, NULL, NULL },
-	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(__uint16_t)), 0, NULL,
+	{ FLDT_UINT16D, "uint16d", fp_num, "%u", SI(bitsz(uint16_t)), 0, NULL,
 	  NULL },
-	{ FLDT_UINT16O, "uint16o", fp_num, "%#o", SI(bitsz(__uint16_t)), 0,
+	{ FLDT_UINT16O, "uint16o", fp_num, "%#o", SI(bitsz(uint16_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT16X, "uint16x", fp_num, "%#x", SI(bitsz(__uint16_t)), 0,
+	{ FLDT_UINT16X, "uint16x", fp_num, "%#x", SI(bitsz(uint16_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT32D, "uint32d", fp_num, "%u", SI(bitsz(__uint32_t)), 0, NULL,
+	{ FLDT_UINT32D, "uint32d", fp_num, "%u", SI(bitsz(uint32_t)), 0, NULL,
 	  NULL },
-	{ FLDT_UINT32O, "uint32o", fp_num, "%#o", SI(bitsz(__uint32_t)), 0,
+	{ FLDT_UINT32O, "uint32o", fp_num, "%#o", SI(bitsz(uint32_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT32X, "uint32x", fp_num, "%#x", SI(bitsz(__uint32_t)), 0,
+	{ FLDT_UINT32X, "uint32x", fp_num, "%#x", SI(bitsz(uint32_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT64D, "uint64d", fp_num, "%llu", SI(bitsz(__uint64_t)), 0,
+	{ FLDT_UINT64D, "uint64d", fp_num, "%llu", SI(bitsz(uint64_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT64O, "uint64o", fp_num, "%#llo", SI(bitsz(__uint64_t)), 0,
+	{ FLDT_UINT64O, "uint64o", fp_num, "%#llo", SI(bitsz(uint64_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT64X, "uint64x", fp_num, "%#llx", SI(bitsz(__uint64_t)), 0,
+	{ FLDT_UINT64X, "uint64x", fp_num, "%#llx", SI(bitsz(uint64_t)), 0,
 	  NULL, NULL },
-	{ FLDT_UINT8D, "uint8d", fp_num, "%u", SI(bitsz(__uint8_t)), 0, NULL,
+	{ FLDT_UINT8D, "uint8d", fp_num, "%u", SI(bitsz(uint8_t)), 0, NULL,
 	  NULL },
-	{ FLDT_UINT8O, "uint8o", fp_num, "%#o", SI(bitsz(__uint8_t)), 0, NULL,
+	{ FLDT_UINT8O, "uint8o", fp_num, "%#o", SI(bitsz(uint8_t)), 0, NULL,
 	  NULL },
-	{ FLDT_UINT8X, "uint8x", fp_num, "%#x", SI(bitsz(__uint8_t)), 0, NULL,
+	{ FLDT_UINT8X, "uint8x", fp_num, "%#x", SI(bitsz(uint8_t)), 0, NULL,
 	  NULL },
 	{ FLDT_UUID, "uuid", fp_uuid, NULL, SI(bitsz(uuid_t)), 0, NULL, NULL },
 	{ FLDT_ZZZ, NULL }
diff --git a/db/fprint.c b/db/fprint.c
index f2b3794..12b1574 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -80,7 +80,7 @@ fp_num(
 	int		bitpos;
 	int		i;
 	int		isnull;
-	__int64_t	val;
+	int64_t		val;
 
 	for (i = 0, bitpos = bit;
 	     i < count && !seenint();
@@ -100,7 +100,7 @@ fp_num(
 		else if (size > 32)
 			dbprintf(fmtstr, val);
 		else
-			dbprintf(fmtstr, (__int32_t)val);
+			dbprintf(fmtstr, (int32_t)val);
 		if (i < count - 1)
 			dbprintf(" ");
 	}
@@ -203,7 +203,7 @@ fp_crc(
 {
 	int		bitpos;
 	int		i;
-	__int64_t	val;
+	int64_t		val;
 	char		*ok;
 
 	switch (iocur_crc_valid()) {
@@ -230,7 +230,7 @@ fp_crc(
 		if (size > 32)
 			dbprintf(fmtstr, val, ok);
 		else
-			dbprintf(fmtstr, (__int32_t)val, ok);
+			dbprintf(fmtstr, (int32_t)val, ok);
 		if (i < count - 1)
 			dbprintf(" ");
 	}
diff --git a/db/frag.c b/db/frag.c
index 3beb416..c3d1581 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -42,8 +42,8 @@ typedef	struct extmap {
 
 static int		aflag;
 static int		dflag;
-static __uint64_t	extcount_actual;
-static __uint64_t	extcount_ideal;
+static uint64_t	extcount_actual;
+static uint64_t	extcount_ideal;
 static int		fflag;
 static int		lflag;
 static int		qflag;
@@ -306,8 +306,8 @@ process_inode(
 	xfs_agino_t		agino,
 	xfs_dinode_t		*dip)
 {
-	__uint64_t		actual;
-	__uint64_t		ideal;
+	uint64_t		actual;
+	uint64_t		ideal;
 	xfs_ino_t		ino;
 	int			skipa;
 	int			skipd;
diff --git a/db/inode.c b/db/inode.c
index 442e6ea..3b2ee1a 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -119,49 +119,49 @@ const field_t	inode_core_flds[] = {
 	{ "dmstate", FLDT_UINT16D, OI(COFF(dmstate)), C1, 0, TYP_NONE },
 	{ "flags", FLDT_UINT16X, OI(COFF(flags)), C1, FLD_SKIPALL, TYP_NONE },
 	{ "newrtbm", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NEWRTBM_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NEWRTBM_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "prealloc", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PREALLOC_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_PREALLOC_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "realtime", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_REALTIME_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_REALTIME_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "immutable", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_IMMUTABLE_BIT-1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_IMMUTABLE_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "append", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_APPEND_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_APPEND_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "sync", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_SYNC_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_SYNC_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "noatime", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOATIME_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NOATIME_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "nodump", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODUMP_BIT - 1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NODUMP_BIT - 1), C1,
 	  0, TYP_NONE },
 	{ "rtinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_RTINHERIT_BIT-1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_RTINHERIT_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "projinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1),C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_PROJINHERIT_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "nosymlinks", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NOSYMLINKS_BIT-1), C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NOSYMLINKS_BIT-1), C1,
 	  0, TYP_NONE },
 	{ "extsz", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1),C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSIZE_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "extszinherit", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1),C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_EXTSZINHERIT_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "nodefrag", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1),C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_NODEFRAG_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "filestream", FLDT_UINT1,
-	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
+	  OI(COFF(flags) + bitsz(uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
 	  0, TYP_NONE },
 	{ "gen", FLDT_UINT32D, OI(COFF(gen)), C1, 0, TYP_NONE },
 	{ NULL }
diff --git a/db/io.c b/db/io.c
index 9452e07..8fa2504 100644
--- a/db/io.c
+++ b/db/io.c
@@ -487,7 +487,7 @@ write_cur(void)
 void
 set_cur(
 	const typ_t	*t,
-	__int64_t	d,
+	int64_t		d,
 	int		c,
 	int             ring_flag,
 	bbmap_t		*bbmap)
@@ -495,7 +495,7 @@ set_cur(
 	struct xfs_buf	*bp;
 	xfs_ino_t	dirino;
 	xfs_ino_t	ino;
-	__uint16_t	mode;
+	uint16_t	mode;
 	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
 
 	if (iocur_sp < 0) {
diff --git a/db/io.h b/db/io.h
index 6201d7b..4700db3 100644
--- a/db/io.h
+++ b/db/io.h
@@ -25,7 +25,7 @@ typedef struct bbmap {
 } bbmap_t;
 
 typedef struct iocur {
-	__int64_t		bb;	/* BB number in filesystem of buf */
+	int64_t		bb;	/* BB number in filesystem of buf */
 	int			blen;	/* length of "buf", bb's */
 	int			boff;	/* data - buf */
 	void			*buf;	/* base address of buffer */
@@ -33,7 +33,7 @@ typedef struct iocur {
 	xfs_ino_t		dirino;	/* current directory inode number */
 	xfs_ino_t		ino;	/* current inode number */
 	int			len;	/* length of "data", bytes */
-	__uint16_t		mode;	/* current inode's mode */
+	uint16_t		mode;	/* current inode's mode */
 	xfs_off_t		off;	/* fs offset of "data" in bytes */
 	const struct typ	*typ;	/* type of "data" */
 	bbmap_t			*bbmap;	/* map daddr if fragmented */
@@ -57,9 +57,9 @@ extern void	off_cur(int off, int len);
 extern void	pop_cur(void);
 extern void	print_iocur(char *tag, iocur_t *ioc);
 extern void	push_cur(void);
-extern int	read_buf(__int64_t daddr, int count, void *bufp);
+extern int	read_buf(int64_t daddr, int count, void *bufp);
 extern void     write_cur(void);
-extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
+extern void	set_cur(const struct typ *t, int64_t d, int c, int ring_add,
 			bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *t);
diff --git a/db/metadump.c b/db/metadump.c
index 8455fdd..0bb6e3d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -175,7 +175,7 @@ write_index(void)
 static int
 write_buf_segment(
 	char		*data,
-	__int64_t	off,
+	int64_t		off,
 	int		len)
 {
 	int		i;
@@ -1093,7 +1093,7 @@ process_sf_dir(
 {
 	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
-	__uint64_t		ino_dir_size;
+	uint64_t		ino_dir_size;
 	int			i;
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
@@ -1159,7 +1159,7 @@ process_sf_dir(
 static void
 obfuscate_path_components(
 	char			*buf,
-	__uint64_t		len)
+	uint64_t		len)
 {
 	unsigned char		*comp = (unsigned char *)buf;
 	unsigned char		*end = comp + len;
@@ -1196,7 +1196,7 @@ static void
 process_sf_symlink(
 	xfs_dinode_t		*dip)
 {
-	__uint64_t		len;
+	uint64_t		len;
 	char			*buf;
 
 	len = be64_to_cpu(dip->di_size);
@@ -1468,7 +1468,7 @@ process_attr_block(
 	xfs_attr_leaf_entry_t 		*entry;
 	xfs_attr_leaf_name_local_t 	*local;
 	xfs_attr_leaf_name_remote_t 	*remote;
-	__uint32_t			bs = mp->m_sb.sb_blocksize;
+	uint32_t			bs = mp->m_sb.sb_blocksize;
 	char				*first_name;
 
 
@@ -2106,7 +2106,7 @@ done:
 	return success;
 }
 
-static __uint32_t	inodes_copied = 0;
+static uint32_t	inodes_copied = 0;
 
 static int
 copy_inode_chunk(
diff --git a/db/sb.c b/db/sb.c
index 79a3c1d..e870aa6 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -606,7 +606,7 @@ version_help(void)
 }
 
 static int
-do_version(xfs_agnumber_t agno, __uint16_t version, __uint32_t features)
+do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
 {
 	xfs_sb_t	tsb;
 
@@ -708,8 +708,8 @@ version_f(
 	int		argc,
 	char		**argv)
 {
-	__uint16_t	version = 0;
-	__uint32_t	features = 0;
+	uint16_t	version = 0;
+	uint32_t	features = 0;
 	xfs_agnumber_t	ag;
 
 	if (argc == 2) {	/* WRITE VERSION */
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 424fbce..f32aced 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -57,7 +57,7 @@ struct getbmap  *outmap = NULL;
 int             outmap_size = 0;
 int		RealUid;
 int		tmp_agi;
-static __int64_t	minimumfree = 2048;
+static int64_t	minimumfree = 2048;
 
 #define MNTTYPE_XFS             "xfs"
 
diff --git a/include/darwin.h b/include/darwin.h
index dd6132f..8a85878 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -125,15 +125,6 @@ typedef signed int		__s32;
 typedef unsigned long long int	__u64;
 typedef signed long long int	__s64;
 
-#define __int8_t	int8_t
-#define __int16_t	int16_t
-#define __int32_t	int32_t
-#define __int32_t	int32_t
-#define __int64_t	int64_t
-#define __uint8_t	u_int8_t
-#define __uint16_t	u_int16_t
-#define __uint32_t	u_int32_t
-#define __uint64_t	u_int64_t
 #define off64_t		off_t
 
 typedef off_t		xfs_off_t;
diff --git a/include/freebsd.h b/include/freebsd.h
index 65bd60a..e3e995f 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -50,9 +50,9 @@
 
 typedef off_t		xfs_off_t;
 typedef off_t		off64_t;
-typedef __uint64_t	xfs_ino_t;
-typedef __uint32_t	xfs_dev_t;
-typedef __int64_t	xfs_daddr_t;
+typedef uint64_t	xfs_ino_t;
+typedef uint32_t	xfs_dev_t;
+typedef int64_t	xfs_daddr_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 64167b2..b2d2cf3 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -39,9 +39,9 @@
 #define EFSBADCRC	991	/* Bad CRC detected */
 
 typedef off_t		xfs_off_t;
-typedef __uint64_t	xfs_ino_t;
-typedef __uint32_t	xfs_dev_t;
-typedef __int64_t	xfs_daddr_t;
+typedef uint64_t	xfs_ino_t;
+typedef uint32_t	xfs_dev_t;
+typedef int64_t	xfs_daddr_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
diff --git a/include/irix.h b/include/irix.h
index 293f869..d6aa5e1 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -39,14 +39,10 @@
 #include <sys/fs/xfs_itable.h>
 #include <mntent.h>
 
-#define __int8_t	char
-#define __int16_t	short
-#define __uint8_t	unsigned char
-#define __uint16_t	unsigned short
 typedef off64_t		xfs_off_t;
-typedef __int64_t	xfs_ino_t;
-typedef __int32_t	xfs_dev_t;
-typedef __int64_t	xfs_daddr_t;
+typedef int64_t		xfs_ino_t;
+typedef int32_t		xfs_dev_t;
+typedef int64_t		xfs_daddr_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
@@ -63,17 +59,17 @@ typedef signed long long int	__s64;
 #define EFSBADCRC	991	/* Bad CRC detected */
 
 typedef struct xfs_error_injection {
-	__int32_t	fd;
-	__int32_t	errtag;
+	int32_t	fd;
+	int32_t	errtag;
 } xfs_error_injection_t;
 
 /* --- xfs_fsop_*req - request data structures --- */
 
 typedef struct xfs_fsop_bulkreq {
 	ino64_t	*lastip;
-	__int32_t	icount;
+	int32_t		icount;
 	xfs_bstat_t	*ubuffer;
-	__int32_t	*ocount;
+	int32_t		*ocount;
 } xfs_fsop_bulkreq_t;
 
 typedef struct xfs_fsop_handlereq {
@@ -302,13 +298,13 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	__uint32_t status;
+	uint32_t status;
 	return uuid_compare(uu1, uu2, &status);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	__uint32_t status;
+	uint32_t status;
 	char *s;
 	uuid_to_string(uu, &s, &status);
 	if (status == uuid_s_ok)
@@ -319,7 +315,7 @@ static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	__uint32_t status;
+	uint32_t status;
 	uuid_from_string(buffer, uu, &status);
 	return (status == uuid_s_ok);
 }
@@ -332,13 +328,13 @@ static __inline__ int platform_uuid_is_null(uuid_t *uu)
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	__uint32_t status;
+	uint32_t status;
 	uuid_create(uu, &status);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	__uint32_t status;
+	uint32_t status;
 	uuid_create_nil(uu, &status);
 }
 
diff --git a/include/linux.h b/include/linux.h
index 674717c..827dbe1 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -124,7 +124,7 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 static __inline__ int
 platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
-	__uint64_t range[2] = { start, len };
+	uint64_t range[2] = { start, len };
 
 	if (ioctl(fd, BLKDISCARD, &range) < 0)
 		return errno;
@@ -142,9 +142,9 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
 
 typedef loff_t		xfs_off_t;
-typedef __uint64_t	xfs_ino_t;
-typedef __uint32_t	xfs_dev_t;
-typedef __int64_t	xfs_daddr_t;
+typedef uint64_t	xfs_ino_t;
+typedef uint32_t	xfs_dev_t;
+typedef int64_t	xfs_daddr_t;
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 87650f1..c44d993 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -240,39 +240,39 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	*a = cpu_to_be64(be64_to_cpu(*a) + b);
 }
 
-static inline __uint16_t get_unaligned_be16(void *p)
+static inline uint16_t get_unaligned_be16(void *p)
 {
-	__uint8_t *__p = p;
+	uint8_t *__p = p;
 	return __p[0] << 8 | __p[1];
 }
 
-static inline __uint32_t get_unaligned_be32(void *p)
+static inline uint32_t get_unaligned_be32(void *p)
 {
-	__uint8_t *__p = p;
+	uint8_t *__p = p;
         return __p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
 }
 
-static inline __uint64_t get_unaligned_be64(void *p)
+static inline uint64_t get_unaligned_be64(void *p)
 {
-	return (__uint64_t)get_unaligned_be32(p) << 32 |
+	return (uint64_t)get_unaligned_be32(p) << 32 |
 			   get_unaligned_be32(p + 4);
 }
 
-static inline void put_unaligned_be16(__uint16_t val, void *p)
+static inline void put_unaligned_be16(uint16_t val, void *p)
 {
-	__uint8_t *__p = p;
+	uint8_t *__p = p;
 	*__p++ = val >> 8;
 	*__p++ = val;
 }
 
-static inline void put_unaligned_be32(__uint32_t val, void *p)
+static inline void put_unaligned_be32(uint32_t val, void *p)
 {
-	__uint8_t *__p = p;
+	uint8_t *__p = p;
 	put_unaligned_be16(val >> 16, __p);
 	put_unaligned_be16(val, __p + 2);
 }
 
-static inline void put_unaligned_be64(__uint64_t val, void *p)
+static inline void put_unaligned_be64(uint64_t val, void *p)
 {
 	put_unaligned_be32(val >> 32, p);
 	put_unaligned_be32(val, p + 4);
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 71c0fb4..708f8c6 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -77,8 +77,8 @@ xfs_get_projid(struct xfs_icdinode *id)
 static inline void
 xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
 {
-	id->di_projid_hi = (__uint16_t) (projid >> 16);
-	id->di_projid_lo = (__uint16_t) (projid & 0xffff);
+	id->di_projid_hi = (uint16_t) (projid >> 16);
+	id->di_projid_lo = (uint16_t) (projid & 0xffff);
 }
 
 typedef struct cred {
diff --git a/include/xfs_log_recover.h b/include/xfs_log_recover.h
index 2fea63d..69f276c 100644
--- a/include/xfs_log_recover.h
+++ b/include/xfs_log_recover.h
@@ -26,7 +26,7 @@
 #define XLOG_RHASH_SIZE	16
 #define XLOG_RHASH_SHIFT 2
 #define XLOG_RHASH(tid)	\
-	((((__uint32_t)tid)>>XLOG_RHASH_SHIFT) & (XLOG_RHASH_SIZE-1))
+	((((uint32_t)tid)>>XLOG_RHASH_SHIFT) & (XLOG_RHASH_SIZE-1))
 
 #define XLOG_MAX_REGIONS_IN_ITEM   (XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK / 2 + 1)
 
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index f4be51b..3ce5138 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -24,8 +24,8 @@
 typedef struct xfs_metablock {
 	__be32		mb_magic;
 	__be16		mb_count;
-	__uint8_t	mb_blocklog;
-	__uint8_t	mb_reserved;
+	uint8_t		mb_blocklog;
+	uint8_t		mb_reserved;
 	/* followed by an array of xfs_daddr_t */
 } xfs_metablock_t;
 
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 14b05a6..e0d5f48 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -48,12 +48,12 @@ typedef struct xfs_mount {
 #define m_dev		m_ddev_targp
 #define m_logdev	m_logdev_targp
 #define m_rtdev		m_rtdev_targp
-	__uint8_t		m_dircook_elog;	/* log d-cookie entry bits */
-	__uint8_t		m_blkbit_log;	/* blocklog + NBBY */
-	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
-	__uint8_t		m_sectbb_log;	/* sectorlog - BBSHIFT */
-	__uint8_t		m_agno_log;	/* log #ag's */
-	__uint8_t		m_agino_log;	/* #bits for agino in inum */
+	uint8_t			m_dircook_elog;	/* log d-cookie entry bits */
+	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
+	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
+	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
+	uint8_t			m_agno_log;	/* log #ag's */
+	uint8_t			m_agino_log;	/* #bits for agino in inum */
 	uint			m_inode_cluster_size;/* min inode buf size */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
@@ -78,7 +78,7 @@ typedef struct xfs_mount {
 	int			m_litino;	/* size of inode union area */
 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
-	__uint64_t		m_maxicount;	/* maximum inode count */
+	uint64_t		m_maxicount;	/* maximum inode count */
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignmnt */
@@ -118,12 +118,12 @@ typedef struct xfs_perag {
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
 	char		pagi_inodeok;	/* The agi is ok for inodes */
-	__uint8_t	pagf_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_levels[XFS_BTNUM_AGF];
 					/* # of levels in bno & cnt btree */
-	__uint32_t	pagf_flcount;	/* count of blocks in freelist */
+	uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
-	__uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
+	uint32_t	pagf_btreeblks;	/* # of blocks held in AGF btrees */
 	xfs_agino_t	pagi_freecount;	/* number of free inodes */
 	xfs_agino_t	pagi_count;	/* number of allocated inodes */
 
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 236ed22..00127b3 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -232,7 +232,7 @@ obj_to_handle(
 {
 	char		hbuf [MAXHANSIZ];
 	int		ret;
-	__uint32_t	handlen;
+	uint32_t	handlen;
 	xfs_fsop_handlereq_t hreq;
 
 	if (opcode == XFS_IOC_FD_TO_HANDLE) {
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index e52f5d8..821061b 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -36,7 +36,7 @@ typedef struct filehandle {
 	fshandle_t fh_fshandle;		/* handle of fs containing this inode */
 	int16_t fh_sz_following;	/* bytes in handle after this member */
 	char fh_pad[FILEHANDLE_SZ_PAD];	/* padding, must be zeroed */
-	__uint32_t fh_gen;		/* generation count */
+	uint32_t fh_gen;		/* generation count */
 	xfs_ino_t fh_ino;		/* 64 bit ino */
 } filehandle_t;
 
diff --git a/libxfs/darwin.c b/libxfs/darwin.c
index 017e190..1bd6c8a 100644
--- a/libxfs/darwin.c
+++ b/libxfs/darwin.c
@@ -68,7 +68,7 @@ platform_flush_device(int fd, dev_t device)
 void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
-	__uint64_t	size;
+	uint64_t	size;
 	struct stat64	st;
 
 	if (fstat64(fd, &st) < 0) {
diff --git a/libxfs/freebsd.c b/libxfs/freebsd.c
index 6c9f089..96f2c67 100644
--- a/libxfs/freebsd.c
+++ b/libxfs/freebsd.c
@@ -109,7 +109,7 @@ void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	struct stat	st;
-	__int64_t	size;
+	int64_t		size;
 	u_int		ssize;
 
 	if (fstat(fd, &st) < 0) {
diff --git a/libxfs/init.c b/libxfs/init.c
index 8d747e8..4e73e13 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -529,7 +529,7 @@ libxfs_initialize_perag(
 		 * the max inode percentage.
 		 */
 		if (mp->m_maxicount) {
-			__uint64_t	icount;
+			uint64_t	icount;
 
 			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
 			do_div(icount, 100);
diff --git a/libxfs/irix.c b/libxfs/irix.c
index 65aaa7e..f4e7f47 100644
--- a/libxfs/irix.c
+++ b/libxfs/irix.c
@@ -22,7 +22,7 @@
 
 int platform_has_uuid = 0;
 extern char *progname;
-extern __int64_t findsize(char *);
+extern int64_t findsize(char *);
 
 int
 platform_check_ismounted(char *name, char *block, struct stat64 *s, int verbose)
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0f4d3e5..ffd6bf7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -307,8 +307,8 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
-static inline __uint64_t
-roundup_64(__uint64_t x, __uint32_t y)
+static inline uint64_t
+roundup_64(uint64_t x, uint32_t y)
 {
 	x += y - 1;
 	do_div(x, y);
diff --git a/libxfs/linux.c b/libxfs/linux.c
index f6ea1b2..c532d65 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -133,7 +133,7 @@ void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	struct stat64	st;
-	__uint64_t	size;
+	uint64_t	size;
 	int		error;
 
 	if (fstat64(fd, &st) < 0) {
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 7e93f60..466b442 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -121,7 +121,7 @@ xfs_buf_item_init(
 	bip->bli_item.li_mountp = mp;
 	bip->bli_buf = bp;
 	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (__int64_t)XFS_BUF_ADDR(bp);
+	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
 	bip->bli_format.blf_len = (unsigned short)BTOBB(XFS_BUF_COUNT(bp));
 	XFS_BUF_SET_FSPRIVATE(bp, bip);
 }
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index eef9c36..3f0257f 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -66,21 +66,21 @@ static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH];
 static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
 		int offset)
 {
-	*((__uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
+	*((uint32_t *)node->tags[tag] + (offset >> 5)) |= (1 << (offset & 31));
 }
 
 static inline void tag_clear(struct radix_tree_node *node, unsigned int tag,
 		int offset)
 {
-	__uint32_t 	*p = (__uint32_t*)node->tags[tag] + (offset >> 5);
-	__uint32_t 	m = 1 << (offset & 31);
+	uint32_t 	*p = (uint32_t*)node->tags[tag] + (offset >> 5);
+	uint32_t 	m = 1 << (offset & 31);
 	*p &= ~m;
 }
 
 static inline int tag_get(struct radix_tree_node *node, unsigned int tag,
 		int offset)
 {
-	return 1 & (((const __uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
+	return 1 & (((const uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
 }
 
 /*
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7a04985..5f0ac24 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -116,9 +116,9 @@ static void unmount_record(void *p)
 	xlog_op_header_t	*op = (xlog_op_header_t *)p;
 	/* the data section must be 32 bit size aligned */
 	struct {
-	    __uint16_t magic;
-	    __uint16_t pad1;
-	    __uint32_t pad2; /* may as well make it 64 bits */
+	    uint16_t magic;
+	    uint16_t pad1;
+	    uint32_t pad2; /* may as well make it 64 bits */
 	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
 
 	memset(p, 0, BBSIZE);
diff --git a/libxfs/util.c b/libxfs/util.c
index 90031fd..8d7baa0 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -160,16 +160,16 @@ libxfs_trans_ichgtime(
 	tv.tv_sec = stv.tv_sec;
 	tv.tv_nsec = stv.tv_usec * 1000;
 	if (flags & XFS_ICHGTIME_MOD) {
-		ip->i_d.di_mtime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_mtime.t_nsec = (__int32_t)tv.tv_nsec;
+		ip->i_d.di_mtime.t_sec = (int32_t)tv.tv_sec;
+		ip->i_d.di_mtime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 	if (flags & XFS_ICHGTIME_CHG) {
-		ip->i_d.di_ctime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_ctime.t_nsec = (__int32_t)tv.tv_nsec;
+		ip->i_d.di_ctime.t_sec = (int32_t)tv.tv_sec;
+		ip->i_d.di_ctime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 	if (flags & XFS_ICHGTIME_CREATE) {
-		ip->i_d.di_crtime.t_sec = (__int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (__int32_t)tv.tv_nsec;
+		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 }
 
@@ -219,7 +219,7 @@ libxfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 
-	ip->i_d.di_mode = (__uint16_t)mode;
+	ip->i_d.di_mode = (uint16_t)mode;
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6f13572..e3f3338 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -246,25 +246,25 @@ xfs_allocbt_init_ptr_from_cur(
 	ptr->s = agf->agf_roots[cur->bc_btnum];
 }
 
-STATIC __int64_t
+STATIC int64_t
 xfs_allocbt_key_diff(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*key)
 {
 	xfs_alloc_rec_incore_t	*rec = &cur->bc_rec.a;
 	xfs_alloc_key_t		*kp = &key->alloc;
-	__int64_t		diff;
+	int64_t			diff;
 
 	if (cur->bc_btnum == XFS_BTNUM_BNO) {
-		return (__int64_t)be32_to_cpu(kp->ar_startblock) -
+		return (int64_t)be32_to_cpu(kp->ar_startblock) -
 				rec->ar_startblock;
 	}
 
-	diff = (__int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
+	diff = (int64_t)be32_to_cpu(kp->ar_blockcount) - rec->ar_blockcount;
 	if (diff)
 		return diff;
 
-	return (__int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
+	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
 }
 
 static bool
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 95383e3..ce55a79 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -247,7 +247,7 @@ xfs_attr_rmtval_copyout(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	__uint8_t	**dst)
+	uint8_t		**dst)
 {
 	char		*src = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -295,7 +295,7 @@ xfs_attr_rmtval_copyin(
 	xfs_ino_t	ino,
 	int		*offset,
 	int		*valuelen,
-	__uint8_t	**src)
+	uint8_t		**src)
 {
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = bp->b_bn;
@@ -349,7 +349,7 @@ xfs_attr_rmtval_get(
 	struct xfs_mount	*mp = args->dp->i_mount;
 	struct xfs_buf		*bp;
 	xfs_dablk_t		lblkno = args->rmtblkno;
-	__uint8_t		*dst = args->value;
+	uint8_ta		*dst = args->value;
 	int			valuelen;
 	int			nmap;
 	int			error;
@@ -415,7 +415,7 @@ xfs_attr_rmtval_set(
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	__uint8_t		*src = args->value;
+	uint8_t			*src = args->value;
 	int			blkcnt;
 	int			valuelen;
 	int			nmap;
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 919756e..085ff84 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -34,10 +34,10 @@ typedef struct xfs_attr_shortform {
 		__u8	count;	/* count of active entries */
 	} hdr;
 	struct xfs_attr_sf_entry {
-		__uint8_t namelen;	/* actual length of name (no NULL) */
-		__uint8_t valuelen;	/* actual length of value (no NULL) */
-		__uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		__uint8_t nameval[1];	/* name & value bytes concatenated */
+		uint8_t namelen;	/* actual length of name (no NULL) */
+		uint8_t valuelen;	/* actual length of value (no NULL) */
+		uint8_t flags;		/* flags bits (see xfs_attr_leaf.h) */
+		uint8_t nameval[1];	/* name & value bytes concatenated */
 	} list[1];			/* variable sized array */
 } xfs_attr_shortform_t;
 typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
@@ -47,10 +47,10 @@ typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
  * We generate this then sort it, attr_list() must return things in hash-order.
  */
 typedef struct xfs_attr_sf_sort {
-	__uint8_t	entno;		/* entry number in original list */
-	__uint8_t	namelen;	/* length of name value (no null) */
-	__uint8_t	valuelen;	/* length of value */
-	__uint8_t	flags;		/* flags bits (see xfs_attr_leaf.h) */
+	uint8_t	entno;			/* entry number in original list */
+	uint8_t	namelen;		/* length of name value (no null) */
+	uint8_t	valuelen;		/* length of value */
+	uint8_t	flags;			/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
 } xfs_attr_sf_sort_t;
@@ -58,7 +58,7 @@ typedef struct xfs_attr_sf_sort {
 #define XFS_ATTR_SF_ENTSIZE_BYNAME(nlen,vlen)	/* space name/value uses */ \
 	(((int)sizeof(xfs_attr_sf_entry_t)-1 + (nlen)+(vlen)))
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \
-	((1 << (NBBY*(int)sizeof(__uint8_t))) - 1)
+	((1 << (NBBY*(int)sizeof(uint8_t))) - 1)
 #define XFS_ATTR_SF_ENTSIZE(sfep)		/* space an entry uses */ \
 	((int)sizeof(xfs_attr_sf_entry_t)-1 + (sfep)->namelen+(sfep)->valuelen)
 #define XFS_ATTR_SF_NEXTENTRY(sfep)		/* next entry in struct */ \
diff --git a/libxfs/xfs_bit.h b/libxfs/xfs_bit.h
index e1649c0..61c6b20 100644
--- a/libxfs/xfs_bit.h
+++ b/libxfs/xfs_bit.h
@@ -25,47 +25,47 @@
 /*
  * masks with n high/low bits set, 64-bit values
  */
-static inline __uint64_t xfs_mask64hi(int n)
+static inline uint64_t xfs_mask64hi(int n)
 {
-	return (__uint64_t)-1 << (64 - (n));
+	return (uint64_t)-1 << (64 - (n));
 }
-static inline __uint32_t xfs_mask32lo(int n)
+static inline uint32_t xfs_mask32lo(int n)
 {
-	return ((__uint32_t)1 << (n)) - 1;
+	return ((uint32_t)1 << (n)) - 1;
 }
-static inline __uint64_t xfs_mask64lo(int n)
+static inline uint64_t xfs_mask64lo(int n)
 {
-	return ((__uint64_t)1 << (n)) - 1;
+	return ((uint64_t)1 << (n)) - 1;
 }
 
 /* Get high bit set out of 32-bit argument, -1 if none set */
-static inline int xfs_highbit32(__uint32_t v)
+static inline int xfs_highbit32(uint32_t v)
 {
 	return fls(v) - 1;
 }
 
 /* Get high bit set out of 64-bit argument, -1 if none set */
-static inline int xfs_highbit64(__uint64_t v)
+static inline int xfs_highbit64(uint64_t v)
 {
 	return fls64(v) - 1;
 }
 
 /* Get low bit set out of 32-bit argument, -1 if none set */
-static inline int xfs_lowbit32(__uint32_t v)
+static inline int xfs_lowbit32(uint32_t v)
 {
 	return ffs(v) - 1;
 }
 
 /* Get low bit set out of 64-bit argument, -1 if none set */
-static inline int xfs_lowbit64(__uint64_t v)
+static inline int xfs_lowbit64(uint64_t v)
 {
-	__uint32_t	w = (__uint32_t)v;
+	uint32_t	w = (uint32_t)v;
 	int		n = 0;
 
 	if (w) {	/* lower bits */
 		n = ffs(w);
 	} else {	/* upper bits */
-		w = (__uint32_t)(v >> 32);
+		w = (uint32_t)(v >> 32);
 		if (w) {
 			n = ffs(w);
 			if (n)
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2ef1836..fb5edca 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -95,8 +95,8 @@ xfs_bmdr_to_bmbt(
  */
 STATIC void
 __xfs_bmbt_get_all(
-		__uint64_t l0,
-		__uint64_t l1,
+		uint64_t l0,
+		uint64_t l1,
 		xfs_bmbt_irec_t *s)
 {
 	int	ext_flag;
@@ -624,12 +624,12 @@ xfs_bmbt_init_ptr_from_cur(
 	ptr->l = 0;
 }
 
-STATIC __int64_t
+STATIC int64_t
 xfs_bmbt_key_diff(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*key)
 {
-	return (__int64_t)be64_to_cpu(key->bmbt.br_startoff) -
+	return (int64_t)be64_to_cpu(key->bmbt.br_startoff) -
 				      cur->bc_rec.b.br_startoff;
 }
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 658f27e..1c700c0 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -38,7 +38,7 @@ kmem_zone_t	*xfs_btree_cur_zone;
 /*
  * Btree magic numbers.
  */
-static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
+static const uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
 	  XFS_FIBT_MAGIC },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC,
@@ -673,14 +673,14 @@ xfs_btree_lastrec(
  */
 void
 xfs_btree_offsets(
-	__int64_t	fields,		/* bitmask of fields */
+	int64_t	fields,		/* bitmask of fields */
 	const short	*offsets,	/* table of field offsets */
 	int		nbits,		/* number of bits to inspect */
 	int		*first,		/* output: first byte offset */
 	int		*last)		/* output: last byte offset */
 {
 	int		i;		/* current bit number */
-	__int64_t	imask;		/* mask for current bit number */
+	int64_t	imask;		/* mask for current bit number */
 
 	ASSERT(fields != 0);
 	/*
@@ -1711,7 +1711,7 @@ xfs_btree_lookup(
 	int			*stat)	/* success/failure */
 {
 	struct xfs_btree_block	*block;	/* current btree block */
-	__int64_t		diff;	/* difference for the current key */
+	int64_t			diff;	/* difference for the current key */
 	int			error;	/* error return value */
 	int			keyno;	/* current key number */
 	int			level;	/* level in the btree */
@@ -3992,7 +3992,7 @@ static int
 xfs_btree_block_change_owner(
 	struct xfs_btree_cur	*cur,
 	int			level,
-	__uint64_t		new_owner,
+	uint64_t		new_owner,
 	struct list_head	*buffer_list)
 {
 	struct xfs_btree_block	*block;
@@ -4039,7 +4039,7 @@ xfs_btree_block_change_owner(
 int
 xfs_btree_change_owner(
 	struct xfs_btree_cur	*cur,
-	__uint64_t		new_owner,
+	uint64_t		new_owner,
 	struct list_head	*buffer_list)
 {
 	union xfs_btree_ptr     lptr;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 48cb251..41376bb 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -159,7 +159,7 @@ struct xfs_btree_ops {
 				     union xfs_btree_ptr *ptr);
 
 	/* difference between key value and cursor value */
-	__int64_t (*key_diff)(struct xfs_btree_cur *cur,
+	int64_t (*key_diff)(struct xfs_btree_cur *cur,
 			      union xfs_btree_key *key);
 
 	const struct xfs_buf_ops	*buf_ops;
@@ -202,11 +202,11 @@ typedef struct xfs_btree_cur
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
-	__uint8_t	bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
+	uint8_t		bc_ra[XFS_BTREE_MAXLEVELS];	/* readahead bits */
 #define	XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
 #define	XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
-	__uint8_t	bc_nlevels;	/* number of levels in the tree */
-	__uint8_t	bc_blocklog;	/* log2(blocksize) of btree blocks */
+	uint8_t		bc_nlevels;	/* number of levels in the tree */
+	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	union {
 		struct {			/* needed for BNO, CNT, INO */
@@ -315,7 +315,7 @@ xfs_btree_islastblock(
  */
 void
 xfs_btree_offsets(
-	__int64_t		fields,	/* bitmask of fields */
+	int64_t			fields,	/* bitmask of fields */
 	const short		*offsets,/* table of field offsets */
 	int			nbits,	/* number of bits to inspect */
 	int			*first,	/* output: first byte offset */
@@ -393,7 +393,7 @@ int xfs_btree_new_iroot(struct xfs_btree_cur *, int *, int *);
 int xfs_btree_insert(struct xfs_btree_cur *, int *);
 int xfs_btree_delete(struct xfs_btree_cur *, int *);
 int xfs_btree_get_rec(struct xfs_btree_cur *, union xfs_btree_rec **, int *);
-int xfs_btree_change_owner(struct xfs_btree_cur *cur, __uint64_t new_owner,
+int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
 			   struct list_head *buffer_list);
 
 /*
@@ -419,7 +419,7 @@ static inline int xfs_btree_get_numrecs(struct xfs_btree_block *block)
 }
 
 static inline void xfs_btree_set_numrecs(struct xfs_btree_block *block,
-		__uint16_t numrecs)
+		uint16_t numrecs)
 {
 	block->bb_numrecs = cpu_to_be16(numrecs);
 }
diff --git a/libxfs/xfs_cksum.h b/libxfs/xfs_cksum.h
index fad1676..3c2bc92 100644
--- a/libxfs/xfs_cksum.h
+++ b/libxfs/xfs_cksum.h
@@ -1,18 +1,18 @@
 #ifndef _XFS_CKSUM_H
 #define _XFS_CKSUM_H 1
 
-#define XFS_CRC_SEED	(~(__uint32_t)0)
+#define XFS_CRC_SEED	(~(uint32_t)0)
 
 /*
  * Calculate the intermediate checksum for a buffer that has the CRC field
  * inside it.  The offset of the 32bit crc fields is passed as the
  * cksum_offset parameter.
  */
-static inline __uint32_t
+static inline uint32_t
 xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 {
-	__uint32_t zero = 0;
-	__uint32_t crc;
+	uint32_t zero = 0;
+	uint32_t crc;
 
 	/* Calculate CRC up to the checksum. */
 	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
@@ -33,7 +33,7 @@ xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
  * so that it is consistent on disk.
  */
 static inline __le32
-xfs_end_cksum(__uint32_t crc)
+xfs_end_cksum(uint32_t crc)
 {
 	return ~cpu_to_le32(crc);
 }
@@ -44,7 +44,7 @@ xfs_end_cksum(__uint32_t crc)
 static inline void
 xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 {
-	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+	uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
 
 	*(__le32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
 }
@@ -55,7 +55,7 @@ xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 static inline int
 xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
 {
-	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
+	uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
 
 	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
 }
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index bf5fe21..cdddca1 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1943,7 +1943,7 @@ xfs_da3_path_shift(
  * This is implemented with some source-level loop unrolling.
  */
 xfs_dahash_t
-xfs_da_hashname(const __uint8_t *name, int namelen)
+xfs_da_hashname(const uint8_t *name, int namelen)
 {
 	xfs_dahash_t hash;
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 6e153e3..cefbdf6 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -60,10 +60,10 @@ enum xfs_dacmp {
  */
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
-	const __uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
-	__uint8_t	filetype;	/* filetype of inode for directories */
-	__uint8_t	*value;		/* set of bytes (maybe contain NULLs) */
+	uint8_t		filetype;	/* filetype of inode for directories */
+	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
@@ -207,7 +207,7 @@ xfs_daddr_t	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
-uint xfs_da_hashname(const __uint8_t *name_string, int name_length);
+uint xfs_da_hashname(const uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
 				const unsigned char *name, int len);
 
diff --git a/libxfs/xfs_da_format.c b/libxfs/xfs_da_format.c
index e4c37f9..770d1f6 100644
--- a/libxfs/xfs_da_format.c
+++ b/libxfs/xfs_da_format.c
@@ -50,7 +50,7 @@ xfs_dir3_sf_entsize(
 	struct xfs_dir2_sf_hdr	*hdr,
 	int			len)
 {
-	return xfs_dir2_sf_entsize(hdr, len) + sizeof(__uint8_t);
+	return xfs_dir2_sf_entsize(hdr, len) + sizeof(uint8_t);
 }
 
 static struct xfs_dir2_sf_entry *
@@ -78,7 +78,7 @@ xfs_dir3_sf_nextentry(
  * not necessary. For non-filetype enable directories, the type is always
  * unknown and we never store the value.
  */
-static __uint8_t
+static uint8_t
 xfs_dir2_sfe_get_ftype(
 	struct xfs_dir2_sf_entry *sfep)
 {
@@ -88,16 +88,16 @@ xfs_dir2_sfe_get_ftype(
 static void
 xfs_dir2_sfe_put_ftype(
 	struct xfs_dir2_sf_entry *sfep,
-	__uint8_t		ftype)
+	uint8_t			ftype)
 {
 	ASSERT(ftype < XFS_DIR3_FT_MAX);
 }
 
-static __uint8_t
+static uint8_t
 xfs_dir3_sfe_get_ftype(
 	struct xfs_dir2_sf_entry *sfep)
 {
-	__uint8_t	ftype;
+	uint8_t		ftype;
 
 	ftype = sfep->name[sfep->namelen];
 	if (ftype >= XFS_DIR3_FT_MAX)
@@ -108,7 +108,7 @@ xfs_dir3_sfe_get_ftype(
 static void
 xfs_dir3_sfe_put_ftype(
 	struct xfs_dir2_sf_entry *sfep,
-	__uint8_t		ftype)
+	uint8_t			ftype)
 {
 	ASSERT(ftype < XFS_DIR3_FT_MAX);
 
@@ -230,7 +230,7 @@ xfs_dir3_sfe_put_ino(
 
 #define XFS_DIR3_DATA_ENTSIZE(n)					\
 	round_up((offsetof(struct xfs_dir2_data_entry, name[0]) + (n) +	\
-		 sizeof(xfs_dir2_data_off_t) + sizeof(__uint8_t)),	\
+		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
 		XFS_DIR2_DATA_ALIGN)
 
 static int
@@ -247,7 +247,7 @@ xfs_dir3_data_entsize(
 	return XFS_DIR3_DATA_ENTSIZE(n);
 }
 
-static __uint8_t
+static uint8_t
 xfs_dir2_data_get_ftype(
 	struct xfs_dir2_data_entry *dep)
 {
@@ -257,16 +257,16 @@ xfs_dir2_data_get_ftype(
 static void
 xfs_dir2_data_put_ftype(
 	struct xfs_dir2_data_entry *dep,
-	__uint8_t		ftype)
+	uint8_t			ftype)
 {
 	ASSERT(ftype < XFS_DIR3_FT_MAX);
 }
 
-static __uint8_t
+static uint8_t
 xfs_dir3_data_get_ftype(
 	struct xfs_dir2_data_entry *dep)
 {
-	__uint8_t	ftype = dep->name[dep->namelen];
+	uint8_t	ftype = dep->name[dep->namelen];
 
 	if (ftype >= XFS_DIR3_FT_MAX)
 		return XFS_DIR3_FT_UNKNOWN;
@@ -276,7 +276,7 @@ xfs_dir3_data_get_ftype(
 static void
 xfs_dir3_data_put_ftype(
 	struct xfs_dir2_data_entry *dep,
-	__uint8_t		type)
+	uint8_t			type)
 {
 	ASSERT(type < XFS_DIR3_FT_MAX);
 	ASSERT(dep->namelen != 0);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index b14bbd6..6b0f629 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -111,11 +111,11 @@ struct xfs_da3_intnode {
  * appropriate.
  */
 struct xfs_da3_icnode_hdr {
-	__uint32_t	forw;
-	__uint32_t	back;
-	__uint16_t	magic;
-	__uint16_t	count;
-	__uint16_t	level;
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	level;
 };
 
 /*
@@ -187,7 +187,7 @@ struct xfs_da3_icnode_hdr {
 /*
  * Byte offset in data block and shortform entry.
  */
-typedef	__uint16_t	xfs_dir2_data_off_t;
+typedef	uint16_t	xfs_dir2_data_off_t;
 #define	NULLDATAOFF	0xffffU
 typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
 
@@ -195,12 +195,12 @@ typedef uint		xfs_dir2_data_aoff_t;	/* argument form */
  * Normalized offset (in a data block) of the entry, really xfs_dir2_data_off_t.
  * Only need 16 bits, this is the byte offset into the single block form.
  */
-typedef struct { __uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
+typedef struct { uint8_t i[2]; } __arch_pack xfs_dir2_sf_off_t;
 
 /*
  * Offset in data space of a data entry.
  */
-typedef	__uint32_t	xfs_dir2_dataptr_t;
+typedef	uint32_t	xfs_dir2_dataptr_t;
 #define	XFS_DIR2_MAX_DATAPTR	((xfs_dir2_dataptr_t)0xffffffff)
 #define	XFS_DIR2_NULL_DATAPTR	((xfs_dir2_dataptr_t)0)
 
@@ -212,19 +212,19 @@ typedef	xfs_off_t	xfs_dir2_off_t;
 /*
  * Directory block number (logical dirblk in file)
  */
-typedef	__uint32_t	xfs_dir2_db_t;
+typedef	uint32_t	xfs_dir2_db_t;
 
 /*
  * Inode number stored as 8 8-bit values.
  */
-typedef	struct { __uint8_t i[8]; } xfs_dir2_ino8_t;
+typedef	struct { uint8_t i[8]; } xfs_dir2_ino8_t;
 
 /*
  * Inode number stored as 4 8-bit values.
  * Works a lot of the time, when all the inode numbers in a directory
  * fit in 32 bits.
  */
-typedef struct { __uint8_t i[4]; } xfs_dir2_ino4_t;
+typedef struct { uint8_t i[4]; } xfs_dir2_ino4_t;
 
 typedef union {
 	xfs_dir2_ino8_t	i8;
@@ -244,8 +244,8 @@ typedef union {
  * over them.
  */
 typedef struct xfs_dir2_sf_hdr {
-	__uint8_t		count;		/* count of entries */
-	__uint8_t		i8count;	/* count of 8-byte inode #s */
+	uint8_t			count;		/* count of entries */
+	uint8_t			i8count;	/* count of 8-byte inode #s */
 	xfs_dir2_inou_t		parent;		/* parent dir inode number */
 } __arch_pack xfs_dir2_sf_hdr_t;
 
@@ -466,11 +466,11 @@ struct xfs_dir3_leaf_hdr {
 };
 
 struct xfs_dir3_icleaf_hdr {
-	__uint32_t		forw;
-	__uint32_t		back;
-	__uint16_t		magic;
-	__uint16_t		count;
-	__uint16_t		stale;
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		stale;
 };
 
 /*
@@ -557,10 +557,10 @@ struct xfs_dir3_free {
  * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
  */
 struct xfs_dir3_icfree_hdr {
-	__uint32_t	magic;
-	__uint32_t	firstdb;
-	__uint32_t	nvalid;
-	__uint32_t	nused;
+	uint32_t	magic;
+	uint32_t	firstdb;
+	uint32_t	nvalid;
+	uint32_t	nused;
 
 };
 
@@ -727,22 +727,22 @@ struct xfs_attr3_leafblock {
  * incore, neutral version of the attribute leaf header
  */
 struct xfs_attr3_icleaf_hdr {
-	__uint32_t	forw;
-	__uint32_t	back;
-	__uint16_t	magic;
-	__uint16_t	count;
-	__uint16_t	usedbytes;
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	usedbytes;
 	/*
 	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
 	 * to support maximum fsb size of 64k without overflow issues throughout
 	 * the attr code. Instead, the overflow condition is handled on
 	 * conversion to/from disk.
 	 */
-	__uint32_t	firstused;
+	uint32_t	firstused;
 	__u8		holes;
 	struct {
-		__uint16_t	base;
-		__uint16_t	size;
+		uint16_t	base;
+		uint16_t	size;
 	} freemap[XFS_ATTR_LEAF_MAPSIZE];
 };
 
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 0129e37..69af9f7 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -45,9 +45,9 @@ struct xfs_dir_ops {
 	struct xfs_dir2_sf_entry *
 		(*sf_nextentry)(struct xfs_dir2_sf_hdr *hdr,
 				struct xfs_dir2_sf_entry *sfep);
-	__uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
+	uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
 	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
-				__uint8_t ftype);
+				uint8_t ftype);
 	xfs_ino_t (*sf_get_ino)(struct xfs_dir2_sf_hdr *hdr,
 				struct xfs_dir2_sf_entry *sfep);
 	void	(*sf_put_ino)(struct xfs_dir2_sf_hdr *hdr,
@@ -58,9 +58,9 @@ struct xfs_dir_ops {
 				     xfs_ino_t ino);
 
 	int	(*data_entsize)(int len);
-	__uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
+	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
-				__uint8_t ftype);
+				uint8_t ftype);
 	__be16 * (*data_entry_tag_p)(struct xfs_dir2_data_entry *dep);
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index f80d91f..40a35b8 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -142,7 +142,7 @@ xfs_dir3_leaf_check_int(
 static bool
 xfs_dir3_leaf_verify(
 	struct xfs_buf		*bp,
-	__uint16_t		magic)
+	uint16_t		magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
@@ -151,7 +151,7 @@ xfs_dir3_leaf_verify(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
-		__uint16_t		magic3;
+		uint16_t		magic3;
 
 		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
 							 : XFS_DIR3_LEAFN_MAGIC;
@@ -175,7 +175,7 @@ xfs_dir3_leaf_verify(
 static void
 __read_verify(
 	struct xfs_buf  *bp,
-	__uint16_t	magic)
+	uint16_t	magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
@@ -192,7 +192,7 @@ __read_verify(
 static void
 __write_verify(
 	struct xfs_buf  *bp,
-	__uint16_t	magic)
+	uint16_t	magic)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
@@ -296,7 +296,7 @@ xfs_dir3_leaf_init(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp,
 	xfs_ino_t		owner,
-	__uint16_t		type)
+	uint16_t		type)
 {
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 
@@ -340,7 +340,7 @@ xfs_dir3_leaf_get_buf(
 	xfs_da_args_t		*args,
 	xfs_dir2_db_t		bno,
 	struct xfs_buf		**bpp,
-	__uint16_t		magic)
+	uint16_t		magic)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index d04547f..6cdb465 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -69,7 +69,7 @@ extern void xfs_dir3_leaf_compact_x1(struct xfs_dir3_icleaf_hdr *leafhdr,
 		struct xfs_dir2_leaf_entry *ents, int *indexp,
 		int *lowstalep, int *highstalep, int *lowlogp, int *highlogp);
 extern int xfs_dir3_leaf_get_buf(struct xfs_da_args *args, xfs_dir2_db_t bno,
-		struct xfs_buf **bpp, __uint16_t magic);
+		struct xfs_buf **bpp, uint16_t magic);
 extern void xfs_dir3_leaf_log_ents(struct xfs_da_args *args,
 		struct xfs_buf *bp, int first, int last);
 extern void xfs_dir3_leaf_log_header(struct xfs_da_args *args,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index a35009a..4ebd0da 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -103,8 +103,8 @@ struct xfs_ifork;
  * Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
-	__uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
-	__uint32_t	sb_blocksize;	/* logical block size, bytes */
+	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
+	uint32_t	sb_blocksize;	/* logical block size, bytes */
 	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
 	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
@@ -118,45 +118,45 @@ typedef struct xfs_sb {
 	xfs_agnumber_t	sb_agcount;	/* number of allocation groups */
 	xfs_extlen_t	sb_rbmblocks;	/* number of rt bitmap blocks */
 	xfs_extlen_t	sb_logblocks;	/* number of log blocks */
-	__uint16_t	sb_versionnum;	/* header version == XFS_SB_VERSION */
-	__uint16_t	sb_sectsize;	/* volume sector size, bytes */
-	__uint16_t	sb_inodesize;	/* inode size, bytes */
-	__uint16_t	sb_inopblock;	/* inodes per block */
+	uint16_t	sb_versionnum;	/* header version == XFS_SB_VERSION */
+	uint16_t	sb_sectsize;	/* volume sector size, bytes */
+	uint16_t	sb_inodesize;	/* inode size, bytes */
+	uint16_t	sb_inopblock;	/* inodes per block */
 	char		sb_fname[12];	/* file system name */
-	__uint8_t	sb_blocklog;	/* log2 of sb_blocksize */
-	__uint8_t	sb_sectlog;	/* log2 of sb_sectsize */
-	__uint8_t	sb_inodelog;	/* log2 of sb_inodesize */
-	__uint8_t	sb_inopblog;	/* log2 of sb_inopblock */
-	__uint8_t	sb_agblklog;	/* log2 of sb_agblocks (rounded up) */
-	__uint8_t	sb_rextslog;	/* log2 of sb_rextents */
-	__uint8_t	sb_inprogress;	/* mkfs is in progress, don't mount */
-	__uint8_t	sb_imax_pct;	/* max % of fs for inode space */
+	uint8_t		sb_blocklog;	/* log2 of sb_blocksize */
+	uint8_t		sb_sectlog;	/* log2 of sb_sectsize */
+	uint8_t		sb_inodelog;	/* log2 of sb_inodesize */
+	uint8_t		sb_inopblog;	/* log2 of sb_inopblock */
+	uint8_t		sb_agblklog;	/* log2 of sb_agblocks (rounded up) */
+	uint8_t		sb_rextslog;	/* log2 of sb_rextents */
+	uint8_t		sb_inprogress;	/* mkfs is in progress, don't mount */
+	uint8_t		sb_imax_pct;	/* max % of fs for inode space */
 					/* statistics */
 	/*
 	 * These fields must remain contiguous.  If you really
 	 * want to change their layout, make sure you fix the
 	 * code in xfs_trans_apply_sb_deltas().
 	 */
-	__uint64_t	sb_icount;	/* allocated inodes */
-	__uint64_t	sb_ifree;	/* free inodes */
-	__uint64_t	sb_fdblocks;	/* free data blocks */
-	__uint64_t	sb_frextents;	/* free realtime extents */
+	uint64_t	sb_icount;	/* allocated inodes */
+	uint64_t	sb_ifree;	/* free inodes */
+	uint64_t	sb_fdblocks;	/* free data blocks */
+	uint64_t	sb_frextents;	/* free realtime extents */
 	/*
 	 * End contiguous fields.
 	 */
 	xfs_ino_t	sb_uquotino;	/* user quota inode */
 	xfs_ino_t	sb_gquotino;	/* group quota inode */
-	__uint16_t	sb_qflags;	/* quota flags */
-	__uint8_t	sb_flags;	/* misc. flags */
-	__uint8_t	sb_shared_vn;	/* shared version number */
+	uint16_t	sb_qflags;	/* quota flags */
+	uint8_t		sb_flags;	/* misc. flags */
+	uint8_t		sb_shared_vn;	/* shared version number */
 	xfs_extlen_t	sb_inoalignmt;	/* inode chunk alignment, fsblocks */
-	__uint32_t	sb_unit;	/* stripe or raid unit */
-	__uint32_t	sb_width;	/* stripe or raid width */
-	__uint8_t	sb_dirblklog;	/* log2 of dir block size (fsbs) */
-	__uint8_t	sb_logsectlog;	/* log2 of the log sector size */
-	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
-	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
-	__uint32_t	sb_features2;	/* additional feature bits */
+	uint32_t	sb_unit;	/* stripe or raid unit */
+	uint32_t	sb_width;	/* stripe or raid width */
+	uint8_t		sb_dirblklog;	/* log2 of dir block size (fsbs) */
+	uint8_t		sb_logsectlog;	/* log2 of the log sector size */
+	uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
+	uint32_t	sb_logsunit;	/* stripe unit size for the log */
+	uint32_t	sb_features2;	/* additional feature bits */
 
 	/*
 	 * bad features2 field as a result of failing to pad the sb structure to
@@ -167,17 +167,17 @@ typedef struct xfs_sb {
 	 * the value in sb_features2 when formatting the incore superblock to
 	 * the disk buffer.
 	 */
-	__uint32_t	sb_bad_features2;
+	uint32_t	sb_bad_features2;
 
 	/* version 5 superblock fields start here */
 
 	/* feature masks */
-	__uint32_t	sb_features_compat;
-	__uint32_t	sb_features_ro_compat;
-	__uint32_t	sb_features_incompat;
-	__uint32_t	sb_features_log_incompat;
+	uint32_t	sb_features_compat;
+	uint32_t	sb_features_ro_compat;
+	uint32_t	sb_features_incompat;
+	uint32_t	sb_features_log_incompat;
 
-	__uint32_t	sb_crc;		/* superblock crc */
+	uint32_t	sb_crc;		/* superblock crc */
 	xfs_extlen_t	sb_spino_align;	/* sparse inode chunk alignment */
 
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
@@ -449,7 +449,7 @@ static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
 static inline bool
 xfs_sb_has_compat_feature(
 	struct xfs_sb	*sbp,
-	__uint32_t	feature)
+	uint32_t	feature)
 {
 	return (sbp->sb_features_compat & feature) != 0;
 }
@@ -461,7 +461,7 @@ xfs_sb_has_compat_feature(
 static inline bool
 xfs_sb_has_ro_compat_feature(
 	struct xfs_sb	*sbp,
-	__uint32_t	feature)
+	uint32_t	feature)
 {
 	return (sbp->sb_features_ro_compat & feature) != 0;
 }
@@ -479,7 +479,7 @@ xfs_sb_has_ro_compat_feature(
 static inline bool
 xfs_sb_has_incompat_feature(
 	struct xfs_sb	*sbp,
-	__uint32_t	feature)
+	uint32_t	feature)
 {
 	return (sbp->sb_features_incompat & feature) != 0;
 }
@@ -489,7 +489,7 @@ xfs_sb_has_incompat_feature(
 static inline bool
 xfs_sb_has_incompat_log_feature(
 	struct xfs_sb	*sbp,
-	__uint32_t	feature)
+	uint32_t	feature)
 {
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
@@ -579,8 +579,8 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
  */
 #define XFS_FSB_TO_B(mp,fsbno)	((xfs_fsize_t)(fsbno) << (mp)->m_sb.sb_blocklog)
 #define XFS_B_TO_FSB(mp,b)	\
-	((((__uint64_t)(b)) + (mp)->m_blockmask) >> (mp)->m_sb.sb_blocklog)
-#define XFS_B_TO_FSBT(mp,b)	(((__uint64_t)(b)) >> (mp)->m_sb.sb_blocklog)
+	((((uint64_t)(b)) + (mp)->m_blockmask) >> (mp)->m_sb.sb_blocklog)
+#define XFS_B_TO_FSBT(mp,b)	(((uint64_t)(b)) >> (mp)->m_sb.sb_blocklog)
 #define XFS_B_FSB_OFFSET(mp,b)	((b) & (mp)->m_blockmask)
 
 /*
@@ -1032,7 +1032,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * next agno_log bits - ag number
  * high agno_log-agblklog-inopblog bits - 0
  */
-#define	XFS_INO_MASK(k)			(__uint32_t)((1ULL << (k)) - 1)
+#define	XFS_INO_MASK(k)			(uint32_t)((1ULL << (k)) - 1)
 #define	XFS_INO_OFFSET_BITS(mp)		(mp)->m_sb.sb_inopblog
 #define	XFS_INO_AGBNO_BITS(mp)		(mp)->m_sb.sb_agblklog
 #define	XFS_INO_AGINO_BITS(mp)		(mp)->m_agino_log
@@ -1229,16 +1229,16 @@ typedef __be32 xfs_alloc_ptr_t;
 #define	XFS_FIBT_MAGIC		0x46494254	/* 'FIBT' */
 #define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
 
-typedef	__uint64_t	xfs_inofree_t;
+typedef	uint64_t	xfs_inofree_t;
 #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
 #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
 #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
 #define	XFS_INOBT_MASK(i)		((xfs_inofree_t)1 << (i))
 
 #define XFS_INOBT_HOLEMASK_FULL		0	/* holemask for full chunk */
-#define XFS_INOBT_HOLEMASK_BITS		(NBBY * sizeof(__uint16_t))
+#define XFS_INOBT_HOLEMASK_BITS		(NBBY * sizeof(uint16_t))
 #define XFS_INODES_PER_HOLEMASK_BIT	\
-	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(__uint16_t)))
+	(XFS_INODES_PER_CHUNK / (NBBY * sizeof(uint16_t)))
 
 static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
 {
@@ -1272,9 +1272,9 @@ typedef struct xfs_inobt_rec {
 
 typedef struct xfs_inobt_rec_incore {
 	xfs_agino_t	ir_startino;	/* starting inode number */
-	__uint16_t	ir_holemask;	/* hole mask for sparse chunks */
-	__uint8_t	ir_count;	/* total inode count */
-	__uint8_t	ir_freecount;	/* count of free inodes (set bits) */
+	uint16_t	ir_holemask;	/* hole mask for sparse chunks */
+	uint8_t		ir_count;	/* total inode count */
+	uint8_t		ir_freecount;	/* count of free inodes (set bits) */
 	xfs_inofree_t	ir_free;	/* free inode mask */
 } xfs_inobt_rec_incore_t;
 
@@ -1345,11 +1345,11 @@ typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
 } xfs_bmbt_rec_t;
 
-typedef __uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
+typedef uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
 typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
 
 typedef struct xfs_bmbt_rec_host {
-	__uint64_t		l0, l1;
+	uint64_t		l0, l1;
 } xfs_bmbt_rec_host_t;
 
 /*
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d8b733a..8fbbdff 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -319,10 +319,10 @@ typedef struct xfs_bstat {
  * and using two 16bit values to hold new 32bit projid was choosen
  * to retain compatibility with "old" filesystems).
  */
-static inline __uint32_t
+static inline uint32_t
 bstat_get_projid(struct xfs_bstat *bs)
 {
-	return (__uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
+	return (uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
 }
 
 /*
@@ -472,10 +472,10 @@ typedef struct xfs_handle {
  */
 typedef struct xfs_swapext
 {
-	__int64_t	sx_version;	/* version */
+	int64_t	sx_version;	/* version */
 #define XFS_SX_VERSION		0
-	__int64_t	sx_fdtarget;	/* fd of target file */
-	__int64_t	sx_fdtmp;	/* fd of tmp file */
+	int64_t	sx_fdtarget;		/* fd of target file */
+	int64_t	sx_fdtmp;		/* fd of tmp file */
 	xfs_off_t	sx_offset;	/* offset into file */
 	xfs_off_t	sx_length;	/* leng from offset */
 	char		sx_pad[16];	/* pad space, unused */
@@ -565,7 +565,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
-#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 /* reflink ioctls; these MUST match the btrfs ioctl definitions */
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 64c3acf..ed228fb 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -133,9 +133,9 @@ xfs_inobt_get_rec(
 STATIC int
 xfs_inobt_insert_rec(
 	struct xfs_btree_cur	*cur,
-	__uint16_t		holemask,
-	__uint8_t		count,
-	__int32_t		freecount,
+	uint16_t		holemask,
+	uint8_t			count,
+	int32_t			freecount,
 	xfs_inofree_t		free,
 	int			*stat)
 {
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 52939c3..31b5923 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -205,12 +205,12 @@ xfs_finobt_init_ptr_from_cur(
 	ptr->s = agi->agi_free_root;
 }
 
-STATIC __int64_t
+STATIC int64_t
 xfs_inobt_key_diff(
 	struct xfs_btree_cur	*cur,
 	union xfs_btree_key	*key)
 {
-	return (__int64_t)be32_to_cpu(key->inobt.ir_startino) -
+	return (int64_t)be32_to_cpu(key->inobt.ir_startino) -
 			  cur->bc_rec.i.ir_startino;
 }
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 324715e..8bcb52a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -325,7 +325,7 @@ xfs_dinode_calc_crc(
 	struct xfs_mount	*mp,
 	struct xfs_dinode	*dip)
 {
-	__uint32_t		crc;
+	uint32_t		crc;
 
 	if (dip->di_version < 3)
 		return;
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index db8ceeb..ccc0fdb 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -31,7 +31,7 @@ struct xfs_trans_res;
  * through all the log items definitions and everything they encode into the
  * log.
  */
-typedef __uint32_t xlog_tid_t;
+typedef uint32_t xlog_tid_t;
 
 #define XLOG_MIN_ICLOGS		2
 #define XLOG_MAX_ICLOGS		8
@@ -205,7 +205,7 @@ typedef struct xfs_log_iovec {
 typedef struct xfs_trans_header {
 	uint		th_magic;		/* magic number */
 	uint		th_type;		/* transaction type */
-	__int32_t	th_tid;			/* transaction id (unused) */
+	int32_t		th_tid;			/* transaction id (unused) */
 	uint		th_num_items;		/* num items logged by trans */
 } xfs_trans_header_t;
 
@@ -242,52 +242,52 @@ typedef struct xfs_trans_header {
  * must be added on to the end.
  */
 typedef struct xfs_inode_log_format {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint64_t		ilf_ino;	/* inode number */
+	uint16_t		ilf_type;	/* inode log item type */
+	uint16_t		ilf_size;	/* size of this item */
+	uint32_t		ilf_fields;	/* flags for fields logged */
+	uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	uint16_t		ilf_dsize;	/* size of data/ext/root */
+	uint64_t		ilf_ino;	/* inode number */
 	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
 		uuid_t		ilfu_uuid;	/* mount point value */
 	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
+	int64_t			ilf_blkno;	/* blkno of inode buffer */
+	int32_t			ilf_len;	/* len of inode buffer */
+	int32_t			ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_t;
 
 typedef struct xfs_inode_log_format_32 {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint64_t		ilf_ino;	/* inode number */
+	uint16_t		ilf_type;	/* inode log item type */
+	uint16_t		ilf_size;	/* size of this item */
+	uint32_t		ilf_fields;	/* flags for fields logged */
+	uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	uint16_t		ilf_dsize;	/* size of data/ext/root */
+	uint64_t		ilf_ino;	/* inode number */
 	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
 		uuid_t		ilfu_uuid;	/* mount point value */
 	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
+	int64_t			ilf_blkno;	/* blkno of inode buffer */
+	int32_t			ilf_len;	/* len of inode buffer */
+	int32_t			ilf_boffset;	/* off of inode in buffer */
 } __attribute__((packed)) xfs_inode_log_format_32_t;
 
 typedef struct xfs_inode_log_format_64 {
-	__uint16_t		ilf_type;	/* inode log item type */
-	__uint16_t		ilf_size;	/* size of this item */
-	__uint32_t		ilf_fields;	/* flags for fields logged */
-	__uint16_t		ilf_asize;	/* size of attr d/ext/root */
-	__uint16_t		ilf_dsize;	/* size of data/ext/root */
-	__uint32_t		ilf_pad;	/* pad for 64 bit boundary */
-	__uint64_t		ilf_ino;	/* inode number */
+	uint16_t		ilf_type;	/* inode log item type */
+	uint16_t		ilf_size;	/* size of this item */
+	uint32_t		ilf_fields;	/* flags for fields logged */
+	uint16_t		ilf_asize;	/* size of attr d/ext/root */
+	uint16_t		ilf_dsize;	/* size of data/ext/root */
+	uint32_t		ilf_pad;	/* pad for 64 bit boundary */
+	uint64_t		ilf_ino;	/* inode number */
 	union {
-		__uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
+		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
 		uuid_t		ilfu_uuid;	/* mount point value */
 	} ilf_u;
-	__int64_t		ilf_blkno;	/* blkno of inode buffer */
-	__int32_t		ilf_len;	/* len of inode buffer */
-	__int32_t		ilf_boffset;	/* off of inode in buffer */
+	int64_t			ilf_blkno;	/* blkno of inode buffer */
+	int32_t			ilf_len;	/* len of inode buffer */
+	int32_t			ilf_boffset;	/* off of inode in buffer */
 } xfs_inode_log_format_64_t;
 
 /*
@@ -355,8 +355,8 @@ static inline int xfs_ilog_fdata(int w)
  * information.
  */
 typedef struct xfs_ictimestamp {
-	__int32_t	t_sec;		/* timestamp seconds */
-	__int32_t	t_nsec;		/* timestamp nanoseconds */
+	int32_t		t_sec;		/* timestamp seconds */
+	int32_t		t_nsec;		/* timestamp nanoseconds */
 } xfs_ictimestamp_t;
 
 /*
@@ -364,18 +364,18 @@ typedef struct xfs_ictimestamp {
  *	  except for the endianness annotations.
  */
 typedef struct xfs_icdinode {
-	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
-	__uint16_t	di_mode;	/* mode and type of file */
-	__int8_t	di_version;	/* inode version */
-	__int8_t	di_format;	/* format of di_c data */
-	__uint16_t	di_onlink;	/* old number of links to file */
-	__uint32_t	di_uid;		/* owner's user id */
-	__uint32_t	di_gid;		/* owner's group id */
-	__uint32_t	di_nlink;	/* number of links to file */
-	__uint16_t	di_projid_lo;	/* lower part of owner's project id */
-	__uint16_t	di_projid_hi;	/* higher part of owner's project id */
-	__uint8_t	di_pad[6];	/* unused, zeroed space */
-	__uint16_t	di_flushiter;	/* incremented on flush */
+	uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+	uint16_t	di_mode;	/* mode and type of file */
+	int8_t		di_version;	/* inode version */
+	int8_t		di_format;	/* format of di_c data */
+	uint16_t	di_onlink;	/* old number of links to file */
+	uint32_t	di_uid;		/* owner's user id */
+	uint32_t	di_gid;		/* owner's group id */
+	uint32_t	di_nlink;	/* number of links to file */
+	uint16_t	di_projid_lo;	/* lower part of owner's project id */
+	uint16_t	di_projid_hi;	/* higher part of owner's project id */
+	uint8_t		di_pad[6];	/* unused, zeroed space */
+	uint16_t	di_flushiter;	/* incremented on flush */
 	xfs_ictimestamp_t di_atime;	/* time last accessed */
 	xfs_ictimestamp_t di_mtime;	/* time last modified */
 	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
@@ -384,22 +384,22 @@ typedef struct xfs_icdinode {
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
 	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
-	__uint8_t	di_forkoff;	/* attr fork offs, <<3 for 64b align */
-	__int8_t	di_aformat;	/* format of attr fork's data */
-	__uint32_t	di_dmevmask;	/* DMIG event mask */
-	__uint16_t	di_dmstate;	/* DMIG state info */
-	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-	__uint32_t	di_gen;		/* generation number */
+	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
+	int8_t		di_aformat;	/* format of attr fork's data */
+	uint32_t	di_dmevmask;	/* DMIG event mask */
+	uint16_t	di_dmstate;	/* DMIG state info */
+	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
+	uint32_t	di_gen;		/* generation number */
 
 	/* di_next_unlinked is the only non-core field in the old dinode */
 	xfs_agino_t	di_next_unlinked;/* agi unlinked list ptr */
 
 	/* start of the extended dinode, writable fields */
-	__uint32_t	di_crc;		/* CRC of the inode */
-	__uint64_t	di_changecount;	/* number of attribute changes */
+	uint32_t	di_crc;		/* CRC of the inode */
+	uint64_t	di_changecount;	/* number of attribute changes */
 	xfs_lsn_t	di_lsn;		/* flush sequence */
-	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+	uint64_t	di_flags2;	/* more random flags */
+	uint8_t		di_pad2[16];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
@@ -458,7 +458,7 @@ typedef struct xfs_buf_log_format {
 	unsigned short	blf_size;	/* size of this item */
 	unsigned short	blf_flags;	/* misc state */
 	unsigned short	blf_len;	/* number of blocks in this buf */
-	__int64_t	blf_blkno;	/* starting blkno of this buf */
+	int64_t		blf_blkno;	/* starting blkno of this buf */
 	unsigned int	blf_map_size;	/* used size of data bitmap in words */
 	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */
 } xfs_buf_log_format_t;
@@ -506,7 +506,7 @@ xfs_blft_to_flags(struct xfs_buf_log_format *blf, enum xfs_blft type)
 	blf->blf_flags |= ((type << XFS_BLFT_SHIFT) & XFS_BLFT_MASK);
 }
 
-static inline __uint16_t
+static inline uint16_t
 xfs_blft_from_flags(struct xfs_buf_log_format *blf)
 {
 	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
@@ -527,14 +527,14 @@ typedef struct xfs_extent {
  * conversion routine.
  */
 typedef struct xfs_extent_32 {
-	__uint64_t	ext_start;
-	__uint32_t	ext_len;
+	uint64_t	ext_start;
+	uint32_t	ext_len;
 } __attribute__((packed)) xfs_extent_32_t;
 
 typedef struct xfs_extent_64 {
-	__uint64_t	ext_start;
-	__uint32_t	ext_len;
-	__uint32_t	ext_pad;
+	uint64_t	ext_start;
+	uint32_t	ext_len;
+	uint32_t	ext_pad;
 } xfs_extent_64_t;
 
 /*
@@ -543,26 +543,26 @@ typedef struct xfs_extent_64 {
  * size is given by efi_nextents.
  */
 typedef struct xfs_efi_log_format {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
+	uint16_t		efi_type;	/* efi log item type */
+	uint16_t		efi_size;	/* size of this item */
+	uint32_t		efi_nextents;	/* # extents to free */
+	uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_t		efi_extents[1];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 typedef struct xfs_efi_log_format_32 {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
+	uint16_t		efi_type;	/* efi log item type */
+	uint16_t		efi_size;	/* size of this item */
+	uint32_t		efi_nextents;	/* # extents to free */
+	uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
 typedef struct xfs_efi_log_format_64 {
-	__uint16_t		efi_type;	/* efi log item type */
-	__uint16_t		efi_size;	/* size of this item */
-	__uint32_t		efi_nextents;	/* # extents to free */
-	__uint64_t		efi_id;		/* efi identifier */
+	uint16_t		efi_type;	/* efi log item type */
+	uint16_t		efi_size;	/* size of this item */
+	uint32_t		efi_nextents;	/* # extents to free */
+	uint64_t		efi_id;		/* efi identifier */
 	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
@@ -572,26 +572,26 @@ typedef struct xfs_efi_log_format_64 {
  * size is given by efd_nextents;
  */
 typedef struct xfs_efd_log_format {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	uint16_t		efd_type;	/* efd log item type */
+	uint16_t		efd_size;	/* size of this item */
+	uint32_t		efd_nextents;	/* # of extents freed */
+	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 typedef struct xfs_efd_log_format_32 {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	uint16_t		efd_type;	/* efd log item type */
+	uint16_t		efd_size;	/* size of this item */
+	uint32_t		efd_nextents;	/* # of extents freed */
+	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
 typedef struct xfs_efd_log_format_64 {
-	__uint16_t		efd_type;	/* efd log item type */
-	__uint16_t		efd_size;	/* size of this item */
-	__uint32_t		efd_nextents;	/* # of extents freed */
-	__uint64_t		efd_efi_id;	/* id of corresponding efi */
+	uint16_t		efd_type;	/* efd log item type */
+	uint16_t		efd_size;	/* size of this item */
+	uint32_t		efd_nextents;	/* # of extents freed */
+	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
@@ -602,12 +602,12 @@ typedef struct xfs_efd_log_format_64 {
  * 32 bits : log_recovery code assumes that.
  */
 typedef struct xfs_dq_logformat {
-	__uint16_t		qlf_type;      /* dquot log item type */
-	__uint16_t		qlf_size;      /* size of this item */
+	uint16_t		qlf_type;      /* dquot log item type */
+	uint16_t		qlf_size;      /* size of this item */
 	xfs_dqid_t		qlf_id;	       /* usr/grp/proj id : 32 bits */
-	__int64_t		qlf_blkno;     /* blkno of dquot buffer */
-	__int32_t		qlf_len;       /* len of dquot buffer */
-	__uint32_t		qlf_boffset;   /* off of dquot in buffer */
+	int64_t			qlf_blkno;     /* blkno of dquot buffer */
+	int32_t			qlf_len;       /* len of dquot buffer */
+	uint32_t		qlf_boffset;   /* off of dquot in buffer */
 } xfs_dq_logformat_t;
 
 /*
@@ -666,8 +666,8 @@ typedef struct xfs_qoff_logformat {
  * decoding can be done correctly.
  */
 struct xfs_icreate_log {
-	__uint16_t	icl_type;	/* type of log format structure */
-	__uint16_t	icl_size;	/* size of log format structure */
+	uint16_t	icl_type;	/* type of log format structure */
+	uint16_t	icl_size;	/* size of log format structure */
 	__be32		icl_ag;		/* ag being allocated in */
 	__be32		icl_agbno;	/* start block of inode range */
 	__be32		icl_count;	/* number of inodes to initialise */
diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index 1b0a083..b6f63e2 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -27,8 +27,8 @@
  * they may need 64-bit accounting. Hence, 64-bit quota-counters,
  * and quota-limits. This is a waste in the common case, but hey ...
  */
-typedef __uint64_t	xfs_qcnt_t;
-typedef __uint16_t	xfs_qwarncnt_t;
+typedef uint64_t	xfs_qcnt_t;
+typedef uint16_t	xfs_qwarncnt_t;
 
 /*
  * flags for q_flags field in the dquot.
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 5648ea5..09237cb 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -978,7 +978,7 @@ xfs_rtfree_extent(
 	    mp->m_sb.sb_rextents) {
 		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
-		*(__uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
+		*(uint64_t *)&mp->m_rbmip->i_d.di_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
 	return 0;
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 78ad889..28cef20 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -417,7 +417,7 @@ xfs_sb_quota_to_disk(
 	struct xfs_dsb	*to,
 	struct xfs_sb	*from)
 {
-	__uint16_t	qflags = from->sb_qflags;
+	uint16_t	qflags = from->sb_qflags;
 
 	to->sb_uquotino = cpu_to_be64(from->sb_uquotino);
 	if (xfs_sb_version_has_pquotino(from)) {
@@ -712,7 +712,7 @@ xfs_sb_mount_common(
 	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
 
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
-	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
+	mp->m_ialloc_inos = (int)MAX((uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
 	mp->m_ialloc_blks = mp->m_ialloc_inos >> sbp->sb_inopblog;
 
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index f0d145a..27b0ed6 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -18,34 +18,34 @@
 #ifndef __XFS_TYPES_H__
 #define	__XFS_TYPES_H__
 
-typedef __uint32_t	prid_t;		/* project ID */
+typedef uint32_t	prid_t;		/* project ID */
 
-typedef __uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
-typedef	__uint32_t	xfs_agino_t;	/* inode # within allocation grp */
-typedef	__uint32_t	xfs_extlen_t;	/* extent length in blocks */
-typedef	__uint32_t	xfs_agnumber_t;	/* allocation group number */
-typedef __int32_t	xfs_extnum_t;	/* # of extents in a file */
-typedef __int16_t	xfs_aextnum_t;	/* # extents in an attribute fork */
-typedef	__int64_t	xfs_fsize_t;	/* bytes in a file */
-typedef __uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
+typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
+typedef	uint32_t	xfs_agino_t;	/* inode # within allocation grp */
+typedef	uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef	uint32_t	xfs_agnumber_t;	/* allocation group number */
+typedef int32_t	xfs_extnum_t;	/* # of extents in a file */
+typedef int16_t	xfs_aextnum_t;	/* # extents in an attribute fork */
+typedef	int64_t	xfs_fsize_t;	/* bytes in a file */
+typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
-typedef	__int32_t	xfs_suminfo_t;	/* type of bitmap summary info */
-typedef	__int32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
+typedef	int32_t	xfs_suminfo_t;	/* type of bitmap summary info */
+typedef	int32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
-typedef	__int64_t	xfs_lsn_t;	/* log sequence number */
-typedef	__int32_t	xfs_tid_t;	/* transaction identifier */
+typedef	int64_t	xfs_lsn_t;	/* log sequence number */
+typedef	int32_t	xfs_tid_t;	/* transaction identifier */
 
-typedef	__uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
-typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
+typedef	uint32_t	xfs_dablk_t;	/* dir/attr block number (in file) */
+typedef	uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
-typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
-typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
-typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
-typedef __uint64_t	xfs_fileoff_t;	/* block number in a file */
-typedef __uint64_t	xfs_filblks_t;	/* number of blocks in a file */
+typedef	uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
+typedef uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
+typedef uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
+typedef uint64_t	xfs_fileoff_t;	/* block number in a file */
+typedef uint64_t	xfs_filblks_t;	/* number of blocks in a file */
 
-typedef	__int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
-typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
+typedef	int64_t	xfs_srtblock_t;	/* signed version of xfs_rtblock_t */
+typedef int64_t	xfs_sfiloff_t;	/* signed block number in a file */
 
 /*
  * Null values for the types.
@@ -125,7 +125,7 @@ struct xfs_name {
  * uid_t and gid_t are hard-coded to 32 bits in the inode.
  * Hence, an 'id' in a dquot is 32 bits..
  */
-typedef __uint32_t	xfs_dqid_t;
+typedef uint32_t	xfs_dqid_t;
 
 /*
  * Constants for bit manipulations.
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 7378fe1..52fc504 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -212,12 +212,12 @@ xlog_print_trans_header(char **ptr, int len)
 {
     xfs_trans_header_t  *h;
     char		*cptr = *ptr;
-    __uint32_t          magic;
+    uint32_t          magic;
     char                *magic_c = (char *)&magic;
 
     *ptr += len;
 
-    magic=*(__uint32_t*)cptr; /* XXX be32_to_cpu soon */
+    magic=*(uint32_t*)cptr; /* XXX be32_to_cpu soon */
 
     if (len >= 4) {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -247,7 +247,7 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
     int			 num, skip;
     int			 super_block = 0;
     int			 bucket, col, buckets;
-    __int64_t		 blkno;
+    int64_t		 blkno;
     xfs_buf_log_format_t lbuf;
     int			 size, blen, map_size, struct_size;
     __be64		 x, y;
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index ebc5e54..07614e0 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -65,7 +65,7 @@ perform_restore(
 	int			mb_count;
 	xfs_metablock_t		tmb;
 	xfs_sb_t		sb;
-	__int64_t		bytes_read;
+	int64_t			bytes_read;
 
 	/*
 	 * read in first blocks (superblock 0), set "inprogress" flag for it,
diff --git a/mkfs/proto.c b/mkfs/proto.c
index cb34b28..f68d691 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -655,7 +655,7 @@ rtinit(
 	mp->m_sb.sb_rbmino = rbmip->i_ino;
 	rbmip->i_d.di_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_d.di_flags = XFS_DIFLAG_NEWRTBM;
-	*(__uint64_t *)&rbmip->i_d.di_atime = 0;
+	*(uint64_t *)&rbmip->i_d.di_atime = 0;
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 700d12c..42dd69b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -188,9 +188,9 @@ char	*mopts[] = {
 	NULL
 };
 
-#define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
-#define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
-#define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
+#define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
+#define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
+#define MEGABYTES(count, blog)	((uint64_t)(count) << (20 - (blog)))
 
 /*
  * Use this macro before we have superblock and mount structure
@@ -540,7 +540,7 @@ fixup_log_stripe_unit(
 	xfs_rfsblock_t	*logblocks,
 	int		blocklog)
 {
-	__uint64_t	tmp_logblocks;
+	uint64_t	tmp_logblocks;
 
 	/*
 	 * Make sure that the log size is a multiple of the stripe unit
@@ -572,7 +572,7 @@ fixup_internal_log_stripe(
 	xfs_mount_t	*mp,
 	int		lsflag,
 	xfs_fsblock_t	logstart,
-	__uint64_t	agsize,
+	uint64_t	agsize,
 	int		sunit,
 	xfs_rfsblock_t	*logblocks,
 	int		blocklog,
@@ -596,7 +596,7 @@ fixup_internal_log_stripe(
 }
 
 void
-validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
+validate_log_size(uint64_t logblocks, int blocklog, int min_logblocks)
 {
 	if (logblocks < min_logblocks) {
 		fprintf(stderr,
@@ -621,7 +621,7 @@ validate_log_size(__uint64_t logblocks, int blocklog, int min_logblocks)
 static int
 calc_default_imaxpct(
 	int		blocklog,
-	__uint64_t	dblocks)
+	uint64_t	dblocks)
 {
 	/*
 	 * This returns the % of the disk space that is used for
@@ -644,12 +644,12 @@ calc_default_imaxpct(
 void
 calc_default_ag_geometry(
 	int		blocklog,
-	__uint64_t	dblocks,
+	uint64_t	dblocks,
 	int		multidisk,
-	__uint64_t	*agsize,
-	__uint64_t	*agcount)
+	uint64_t	*agsize,
+	uint64_t	*agcount)
 {
-	__uint64_t	blocks = 0;
+	uint64_t	blocks = 0;
 	int		shift = 0;
 
 	/*
@@ -714,9 +714,9 @@ done:
 static void
 validate_ag_geometry(
 	int		blocklog,
-	__uint64_t	dblocks,
-	__uint64_t	agsize,
-	__uint64_t	agcount)
+	uint64_t	dblocks,
+	uint64_t	agsize,
+	uint64_t	agcount)
 {
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
@@ -792,7 +792,7 @@ zero_old_xfs_structures(
 {
 	void 			*buf;
 	xfs_sb_t 		sb;
-	__uint32_t		bsize;
+	uint32_t		bsize;
 	int			i;
 	xfs_off_t		off;
 	int			tmp;
@@ -843,8 +843,8 @@ zero_old_xfs_structures(
 			i != sb.sb_blocklog)
 		goto done;
 
-	if (sb.sb_dblocks > ((__uint64_t)sb.sb_agcount * sb.sb_agblocks) ||
-			sb.sb_dblocks < ((__uint64_t)(sb.sb_agcount - 1) *
+	if (sb.sb_dblocks > ((uint64_t)sb.sb_agcount * sb.sb_agblocks) ||
+			sb.sb_dblocks < ((uint64_t)(sb.sb_agcount - 1) *
 					 sb.sb_agblocks + XFS_MIN_AG_BLOCKS))
 		goto done;
 
@@ -864,7 +864,7 @@ done:
 }
 
 static void
-discard_blocks(dev_t dev, __uint64_t nsectors)
+discard_blocks(dev_t dev, uint64_t nsectors)
 {
 	int fd;
 
@@ -882,11 +882,11 @@ main(
 	int			argc,
 	char			**argv)
 {
-	__uint64_t		agcount;
+	uint64_t		agcount;
 	xfs_agf_t		*agf;
 	xfs_agi_t		*agi;
 	xfs_agnumber_t		agno;
-	__uint64_t		agsize;
+	uint64_t		agsize;
 	xfs_alloc_rec_t		*arec;
 	int			attrversion;
 	int			projid16bit;
@@ -971,10 +971,10 @@ main(
 	xfs_sb_t		*sbp;
 	int			sectorlog;
 	unsigned int		sectorsize;
-	__uint64_t		sector_mask;
+	uint64_t		sector_mask;
 	int			slflag;
 	int			ssflag;
-	__uint64_t		tmp_agsize;
+	uint64_t		tmp_agsize;
 	uuid_t			uuid;
 	int			worst_freelist;
 	libxfs_init_t		xi;
@@ -1086,9 +1086,9 @@ main(
 						reqval('d', dopts, D_AGCOUNT);
 					if (daflag)
 						respec('d', dopts, D_AGCOUNT);
-					agcount = (__uint64_t)
+					agcount = (uint64_t)
 						strtoul(value, NULL, 10);
-					if ((__int64_t)agcount <= 0)
+					if ((int64_t)agcount <= 0)
 						illegal(value, "d agcount");
 					daflag = 1;
 					break;
@@ -1915,7 +1915,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		usage();
 	}
 	if (dsize) {
-		__uint64_t dbytes;
+		uint64_t dbytes;
 
 		dbytes = cvtnum(blocksize, sectorsize, dsize);
 		if (dbytes % XFS_MIN_BLOCKSIZE) {
@@ -1952,7 +1952,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		usage();
 	}
 	if (logsize) {
-		__uint64_t logbytes;
+		uint64_t logbytes;
 
 		logbytes = cvtnum(blocksize, sectorsize, logsize);
 		if (logbytes % XFS_MIN_BLOCKSIZE) {
@@ -1974,7 +1974,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		usage();
 	}
 	if (rtsize) {
-		__uint64_t rtbytes;
+		uint64_t rtbytes;
 
 		rtbytes = cvtnum(blocksize, sectorsize, rtsize);
 		if (rtbytes % XFS_MIN_BLOCKSIZE) {
@@ -1994,7 +1994,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	 * If specified, check rt extent size against its constraints.
 	 */
 	if (rtextsize) {
-		__uint64_t rtextbytes;
+		uint64_t rtextbytes;
 
 		rtextbytes = cvtnum(blocksize, sectorsize, rtextsize);
 		if (rtextbytes % blocksize) {
@@ -2022,8 +2022,8 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 		 * and the underlying volume is striped, then set rtextblocks
 		 * to the stripe width.
 		 */
-		__uint64_t	rswidth;
-		__uint64_t	rtextbytes;
+		uint64_t	rswidth;
+		uint64_t	rtextbytes;
 
 		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
 			rswidth = ft.rtswidth;
@@ -2101,10 +2101,10 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
 	 * multiple of the sector size, or 1024, whichever is larger.
 	 */
 
-	sector_mask = (__uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
+	sector_mask = (uint64_t)-1 << (MAX(sectorlog, 10) - BBSHIFT);
 	xi.dsize &= sector_mask;
 	xi.rtsize &= sector_mask;
-	xi.logBBsize &= (__uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
+	xi.logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
 
 	if (!force_overwrite) {
 		if (check_overwrite(dfile) ||
@@ -2473,9 +2473,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	mp = &mbuf;
 	sbp = &mp->m_sb;
 	memset(mp, 0, sizeof(xfs_mount_t));
-	sbp->sb_blocklog = (__uint8_t)blocklog;
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
-	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
+	sbp->sb_blocklog = (uint8_t)blocklog;
+	sbp->sb_sectlog = (uint8_t)sectorlog;
+	sbp->sb_agblklog = (uint8_t)libxfs_log2_roundup((unsigned int)agsize);
 	sbp->sb_agblocks = (xfs_agblock_t)agsize;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
@@ -2603,14 +2603,14 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_agcount = (xfs_agnumber_t)agcount;
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
-	sbp->sb_sectsize = (__uint16_t)sectorsize;
-	sbp->sb_inodesize = (__uint16_t)isize;
-	sbp->sb_inopblock = (__uint16_t)(blocksize / isize);
-	sbp->sb_sectlog = (__uint8_t)sectorlog;
-	sbp->sb_inodelog = (__uint8_t)inodelog;
-	sbp->sb_inopblog = (__uint8_t)(blocklog - inodelog);
+	sbp->sb_sectsize = (uint16_t)sectorsize;
+	sbp->sb_inodesize = (uint16_t)isize;
+	sbp->sb_inopblock = (uint16_t)(blocksize / isize);
+	sbp->sb_sectlog = (uint8_t)sectorlog;
+	sbp->sb_inodelog = (uint8_t)inodelog;
+	sbp->sb_inopblog = (uint8_t)(blocklog - inodelog);
 	sbp->sb_rextslog =
-		(__uint8_t)(rtextents ?
+		(uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_imax_pct = imaxpct;
@@ -2638,8 +2638,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	} else
 		sbp->sb_inoalignmt = 0;
 	if (lsectorsize != BBSIZE || sectorsize != BBSIZE) {
-		sbp->sb_logsectlog = (__uint8_t)lsectorlog;
-		sbp->sb_logsectsize = (__uint16_t)lsectorsize;
+		sbp->sb_logsectlog = (uint8_t)lsectorlog;
+		sbp->sb_logsectsize = (uint16_t)lsectorsize;
 	} else {
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
diff --git a/quota/edit.c b/quota/edit.c
index c55fa1a..f970e66 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -115,16 +115,16 @@ warn_help(void)
 
 static void
 set_limits(
-	__uint32_t	id,
+	uint32_t	id,
 	uint		type,
 	uint		mask,
 	char		*dev,
-	__uint64_t	*bsoft,
-	__uint64_t	*bhard,
-	__uint64_t	*isoft,
-	__uint64_t	*ihard,
-	__uint64_t	*rtbsoft,
-	__uint64_t	*rtbhard)
+	uint64_t	*bsoft,
+	uint64_t	*bhard,
+	uint64_t	*isoft,
+	uint64_t	*ihard,
+	uint64_t	*rtbsoft,
+	uint64_t	*rtbhard)
 {
 	fs_disk_quota_t	d;
 
@@ -152,12 +152,12 @@ set_user_limits(
 	char		*name,
 	uint		type,
 	uint		mask,
-	__uint64_t	*bsoft,
-	__uint64_t	*bhard,
-	__uint64_t	*isoft,
-	__uint64_t	*ihard,
-	__uint64_t	*rtbsoft,
-	__uint64_t	*rtbhard)
+	uint64_t	*bsoft,
+	uint64_t	*bhard,
+	uint64_t	*isoft,
+	uint64_t	*ihard,
+	uint64_t	*rtbsoft,
+	uint64_t	*rtbhard)
 {
 	uid_t		uid = uid_from_string(name);
 
@@ -175,12 +175,12 @@ set_group_limits(
 	char		*name,
 	uint		type,
 	uint		mask,
-	__uint64_t	*bsoft,
-	__uint64_t	*bhard,
-	__uint64_t	*isoft,
-	__uint64_t	*ihard,
-	__uint64_t	*rtbsoft,
-	__uint64_t	*rtbhard)
+	uint64_t	*bsoft,
+	uint64_t	*bhard,
+	uint64_t	*isoft,
+	uint64_t	*ihard,
+	uint64_t	*rtbsoft,
+	uint64_t	*rtbhard)
 {
 	gid_t		gid = gid_from_string(name);
 
@@ -198,12 +198,12 @@ set_project_limits(
 	char		*name,
 	uint		type,
 	uint		mask,
-	__uint64_t	*bsoft,
-	__uint64_t	*bhard,
-	__uint64_t	*isoft,
-	__uint64_t	*ihard,
-	__uint64_t	*rtbsoft,
-	__uint64_t	*rtbhard)
+	uint64_t	*bsoft,
+	uint64_t	*bhard,
+	uint64_t	*isoft,
+	uint64_t	*ihard,
+	uint64_t	*rtbsoft,
+	uint64_t	*rtbhard)
 {
 	prid_t		prid = prid_from_string(name);
 
@@ -224,7 +224,7 @@ extractb(
 	int		length,
 	uint		blocksize,
 	uint		sectorsize,
-	__uint64_t	*value)
+	uint64_t	*value)
 {
 	long long	v;
 	char		*s = string;
@@ -238,7 +238,7 @@ extractb(
 				progname, s);
 			return 0;
 		}
-		*value = (__uint64_t)v >> 9;	/* syscalls use basic blocks */
+		*value = (uint64_t)v >> 9;	/* syscalls use basic blocks */
 		if (v > 0 && *value == 0)
 			fprintf(stderr, _("%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"), progname, s);
 		return 1;
@@ -252,7 +252,7 @@ extracti(
 	char		*string,
 	const char	*prefix,
 	int		length,
-	__uint64_t	*value)
+	uint64_t	*value)
 {
 	char		*sp, *s = string;
 
@@ -270,7 +270,7 @@ limit_f(
 	char		**argv)
 {
 	char		*name;
-	__uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
+	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
 	int		c, type = 0, mask = 0, flags = 0;
 	uint		bsize, ssize, endoptions;
 
@@ -379,8 +379,8 @@ restore_file(
 	char		*dev = NULL;
 	uint		mask;
 	int		cnt;
-	__uint32_t	id;
-	__uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
+	uint32_t	id;
+	uint64_t	bsoft, bhard, isoft, ihard, rtbsoft, rtbhard;
 
 	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
 		if (strncmp("fs = ", buffer, 5) == 0) {
@@ -531,7 +531,7 @@ timer_f(
 
 static void
 set_warnings(
-	__uint32_t	id,
+	uint32_t	id,
 	uint		type,
 	uint		mask,
 	char		*dev,
diff --git a/quota/free.c b/quota/free.c
index dcbe8ce..30ce38b 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -48,20 +48,20 @@ free_help(void)
 static int
 mount_free_space_data(
 	struct fs_path		*mount,
-	__uint64_t		*bcount,
-	__uint64_t		*bused,
-	__uint64_t		*bfree,
-	__uint64_t		*icount,
-	__uint64_t		*iused,
-	__uint64_t		*ifree,
-	__uint64_t		*rcount,
-	__uint64_t		*rused,
-	__uint64_t		*rfree)
+	uint64_t		*bcount,
+	uint64_t		*bused,
+	uint64_t		*bfree,
+	uint64_t		*icount,
+	uint64_t		*iused,
+	uint64_t		*ifree,
+	uint64_t		*rcount,
+	uint64_t		*rused,
+	uint64_t		*rfree)
 {
 	struct xfs_fsop_counts	fscounts;
 	struct xfs_fsop_geom	fsgeo;
 	struct statfs		st;
-	__uint64_t		logsize, count, free;
+	uint64_t		logsize, count, free;
 	int			fd;
 
 	if ((fd = open(mount->fs_dir, O_RDONLY)) < 0) {
@@ -115,15 +115,15 @@ mount_free_space_data(
 static int
 projects_free_space_data(
 	struct fs_path		*path,
-	__uint64_t		*bcount,
-	__uint64_t		*bused,
-	__uint64_t		*bfree,
-	__uint64_t		*icount,
-	__uint64_t		*iused,
-	__uint64_t		*ifree,
-	__uint64_t		*rcount,
-	__uint64_t		*rused,
-	__uint64_t		*rfree)
+	uint64_t		*bcount,
+	uint64_t		*bused,
+	uint64_t		*bfree,
+	uint64_t		*icount,
+	uint64_t		*iused,
+	uint64_t		*ifree,
+	uint64_t		*rcount,
+	uint64_t		*rused,
+	uint64_t		*rfree)
 {
 	fs_quota_stat_t		qfs;
 	fs_disk_quota_t		d;
@@ -209,9 +209,9 @@ free_space(
 	fs_path_t	*path,
 	uint		flags)
 {
-	__uint64_t	bcount, bused, bfree;
-	__uint64_t	icount, iused, ifree;
-	__uint64_t	rcount, rused, rfree;
+	uint64_t	bcount, bused, bfree;
+	uint64_t	icount, iused, ifree;
+	uint64_t	rcount, rused, rfree;
 	char		a[8], s[8], u[8], p[8];
 	int		count;
 
diff --git a/quota/quot.c b/quota/quot.c
index 9116e48..19d2253 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -25,17 +25,17 @@
 
 typedef struct du {
 	struct du	*next;
-	__uint64_t	blocks;
-	__uint64_t	blocks30;
-	__uint64_t	blocks60;
-	__uint64_t	blocks90;
-	__uint64_t	nfiles;
-	__uint32_t	id;
+	uint64_t	blocks;
+	uint64_t	blocks30;
+	uint64_t	blocks60;
+	uint64_t	blocks90;
+	uint64_t	nfiles;
+	uint32_t	id;
 } du_t;
 
 #define	TSIZE		500
-static __uint64_t	sizes[TSIZE];
-static __uint64_t	overflow;
+static uint64_t	sizes[TSIZE];
+static uint64_t	overflow;
 
 #define	NDU		60000
 #define	DUHASH		8209
@@ -83,8 +83,8 @@ quot_bulkstat_add(
 {
 	du_t		*dp;
 	du_t		**hp;
-	__uint64_t	size;
-	__uint32_t	i, id;
+	uint64_t	size;
+	uint32_t	i, id;
 
 	if ((p->bs_mode & S_IFMT) == 0)
 		return;
@@ -202,7 +202,7 @@ qcompare(
 	return 0;
 }
 
-typedef char *(*idtoname_t)(__uint32_t);
+typedef char *(*idtoname_t)(uint32_t);
 
 static void
 quot_report_mount_any_type(
@@ -290,7 +290,7 @@ quot_histogram_mount(
 	fs_path_t	*mount,
 	uint		flags)
 {
-	__uint64_t	t = 0;
+	uint64_t	t = 0;
 	int		i;
 
 	fprintf(fp, _("%s (%s):\n"), mount->fs_name, mount->fs_dir);
diff --git a/quota/quota.c b/quota/quota.c
index f6b24c3..d02e54e 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -51,7 +51,7 @@ quota_help(void)
 static int
 quota_mount(
 	FILE		*fp,
-	__uint32_t	id,
+	uint32_t	id,
 	char		*name,
 	uint		form,
 	uint		type,
@@ -180,7 +180,7 @@ quota_mount(
 static void
 quota(
 	FILE		*fp,
-	__uint32_t	id,
+	uint32_t	id,
 	char		*name,
 	uint		form,
 	uint		type,
diff --git a/quota/quota.h b/quota/quota.h
index 416f335..eb7a4fc 100644
--- a/quota/quota.h
+++ b/quota/quota.h
@@ -51,9 +51,9 @@ enum {
 extern char *type_to_string(uint __type);
 extern char *form_to_string(uint __form);
 extern char *time_to_string(time_t __time, uint __flags);
-extern char *bbs_to_string(__uint64_t __v, char *__c, uint __size);
-extern char *num_to_string(__uint64_t __v, char *__c, uint __size);
-extern char *pct_to_string(__uint64_t __v, __uint64_t __t, char *__c, uint __s);
+extern char *bbs_to_string(uint64_t __v, char *__c, uint __size);
+extern char *num_to_string(uint64_t __v, char *__c, uint __size);
+extern char *pct_to_string(uint64_t __v, uint64_t __t, char *__c, uint __s);
 
 extern FILE *fopen_write_secure(char *__filename);
 
@@ -78,7 +78,7 @@ enum {
  * Identifier (uid/gid/prid) cache routines
  */
 #define NMAX 32
-extern char *uid_to_name(__uint32_t __uid);
-extern char *gid_to_name(__uint32_t __gid);
-extern char *prid_to_name(__uint32_t __prid);
+extern char *uid_to_name(uint32_t __uid);
+extern char *gid_to_name(uint32_t __gid);
+extern char *prid_to_name(uint32_t __prid);
 extern bool isdigits_only(const char *);
diff --git a/quota/report.c b/quota/report.c
index c77b24f..d03f88d 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -289,7 +289,7 @@ report_header(
 static int
 report_mount(
 	FILE		*fp,
-	__uint32_t	id,
+	uint32_t	id,
 	char		*name,
 	uint		form,
 	uint		type,
diff --git a/quota/state.c b/quota/state.c
index 8186762..82dd26d 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -135,7 +135,7 @@ static void
 state_timelimit(
 	FILE		*fp,
 	uint		form,
-	__uint32_t	timelimit)
+	uint32_t	timelimit)
 {
 	fprintf(fp, _("%s grace time: %s\n"),
 		form_to_string(form),
diff --git a/quota/util.c b/quota/util.c
index 179aafd..f51f375 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -83,8 +83,8 @@ round_snprintf(
 	size_t		size,
 	const char	*fmt_round,
 	const char	*fmt_not_round,
-	__uint64_t	value,
-	__uint64_t	divisor)
+	uint64_t	value,
+	uint64_t	divisor)
 {
 	double		v = (double)value / divisor;
 
@@ -96,23 +96,23 @@ round_snprintf(
 }
 
 /* Basic blocks (512) bytes are returned from quotactl */
-#define BBS_TO_EXABYTES(bbs)	((__uint64_t)(bbs)>>51)
-#define BBS_TO_PETABYTES(bbs)	((__uint64_t)(bbs)>>41)
-#define BBS_TO_TERABYTES(bbs)	((__uint64_t)(bbs)>>31)
-#define BBS_TO_GIGABYTES(bbs)	((__uint64_t)(bbs)>>21)
-#define BBS_TO_MEGABYTES(bbs)	((__uint64_t)(bbs)>>11)
-#define BBS_TO_KILOBYTES(bbs)	((__uint64_t)(bbs)>>1)
-
-#define BBEXABYTE		((__uint64_t)1<<51)
-#define BBPETABYTE		((__uint64_t)1<<41)
-#define BBTERABYTE		((__uint64_t)1<<31)
-#define BBGIGABYTE		((__uint64_t)1<<21)
-#define BBMEGABYTE		((__uint64_t)1<<11)
-#define BBKILOBYTE		((__uint64_t)1<< 1)
+#define BBS_TO_EXABYTES(bbs)	((uint64_t)(bbs)>>51)
+#define BBS_TO_PETABYTES(bbs)	((uint64_t)(bbs)>>41)
+#define BBS_TO_TERABYTES(bbs)	((uint64_t)(bbs)>>31)
+#define BBS_TO_GIGABYTES(bbs)	((uint64_t)(bbs)>>21)
+#define BBS_TO_MEGABYTES(bbs)	((uint64_t)(bbs)>>11)
+#define BBS_TO_KILOBYTES(bbs)	((uint64_t)(bbs)>>1)
+
+#define BBEXABYTE		((uint64_t)1<<51)
+#define BBPETABYTE		((uint64_t)1<<41)
+#define BBTERABYTE		((uint64_t)1<<31)
+#define BBGIGABYTE		((uint64_t)1<<21)
+#define BBMEGABYTE		((uint64_t)1<<11)
+#define BBKILOBYTE		((uint64_t)1<< 1)
 
 char *
 bbs_to_string(
-	__uint64_t	v,
+	uint64_t	v,
 	char		*sp,
 	uint		size)
 {
@@ -135,17 +135,17 @@ bbs_to_string(
 	return sp;
 }
 
-#define THOUSAND		((__uint64_t)1000)
-#define MILLION			((__uint64_t)1000*1000)
-#define BILLION			((__uint64_t)1000*1000*1000)
-#define TRILLION		((__uint64_t)1000*1000*1000*1000)
-#define GAZILLION		((__uint64_t)1000*1000*1000*1000*1000)
-#define RIDICULOUS		((__uint64_t)1000*1000*1000*1000*1000*1000)
-#define STOPALREADY		((__uint64_t)1000*1000*1000*1000*1000*1000*1000)
+#define THOUSAND		((uint64_t)1000)
+#define MILLION			((uint64_t)1000*1000)
+#define BILLION			((uint64_t)1000*1000*1000)
+#define TRILLION		((uint64_t)1000*1000*1000*1000)
+#define GAZILLION		((uint64_t)1000*1000*1000*1000*1000)
+#define RIDICULOUS		((uint64_t)1000*1000*1000*1000*1000*1000)
+#define STOPALREADY		((uint64_t)1000*1000*1000*1000*1000*1000*1000)
 
 char *
 num_to_string(
-	__uint64_t	v,
+	uint64_t	v,
 	char		*sp,
 	uint		size)
 {
@@ -172,8 +172,8 @@ num_to_string(
 
 char *
 pct_to_string(
-	__uint64_t	portion,
-	__uint64_t	whole,
+	uint64_t	portion,
+	uint64_t	whole,
 	char		*buf,
 	uint		size)
 {
@@ -226,7 +226,7 @@ type_to_string(
 #define IDMASK		(NID-1)
 
 typedef struct {
-	__uint32_t	id;
+	uint32_t	id;
 	char		name[NMAX+1];
 } idcache_t;
 
@@ -239,7 +239,7 @@ static int		pentriesleft = NID;
 
 static idcache_t *
 getnextpwent(
-	__uint32_t	id,
+	uint32_t	id,
 	int		byid)
 {
 	struct passwd	*pw;
@@ -255,7 +255,7 @@ getnextpwent(
 
 static idcache_t *
 getnextgrent(
-	__uint32_t	id,
+	uint32_t	id,
 	int		byid)
 {
 	struct group	*gr;
@@ -270,7 +270,7 @@ getnextgrent(
 
 static idcache_t *
 getnextprent(
-	__uint32_t	id,
+	uint32_t	id,
 	int		byid)
 {
 	fs_project_t	*pr;
@@ -285,7 +285,7 @@ getnextprent(
 
 char *
 uid_to_name(
-	__uint32_t	id)
+	uint32_t	id)
 {
 	idcache_t	*ncp, *idp;
 
@@ -322,7 +322,7 @@ uid_to_name(
 
 char *
 gid_to_name(
-	__uint32_t	id)
+	uint32_t	id)
 {
 	idcache_t	*ncp, *idp;
 
@@ -359,7 +359,7 @@ gid_to_name(
 
 char *
 prid_to_name(
-	__uint32_t	id)
+	uint32_t	id)
 {
 	idcache_t	*ncp, *idp;
 
diff --git a/repair/README b/repair/README
index 7f168e6..4692463 100644
--- a/repair/README
+++ b/repair/README
@@ -189,7 +189,7 @@ D - 0) look at usage of XFS_MAKE_IPTR().  It does the right
 
 
 D - 0) look at references to XFS_INODES_PER_CHUNK.  change the
-	ones that really mean sizeof(__uint64_t)*NBBY to
+	ones that really mean sizeof(uint64_t)*NBBY to
 	something else (like that only defined as a constant
 	INOS_PER_IREC. this isn't as important since
 	XFS_INODES_PER_CHUNK will never chang
diff --git a/repair/agheader.h b/repair/agheader.h
index 6b2974c..e9075d1 100644
--- a/repair/agheader.h
+++ b/repair/agheader.h
@@ -20,7 +20,7 @@ typedef struct fs_geometry  {
 	/*
 	 * these types should match the superblock types
 	 */
-	__uint32_t	sb_blocksize;	/* blocksize (bytes) */
+	uint32_t	sb_blocksize;	/* blocksize (bytes) */
 	xfs_rfsblock_t	sb_dblocks;	/* # data blocks */
 	xfs_rfsblock_t	sb_rblocks;	/* # realtime blocks */
 	xfs_rtblock_t	sb_rextents;	/* # realtime extents */
@@ -30,9 +30,9 @@ typedef struct fs_geometry  {
 	xfs_agnumber_t	sb_agcount;	/* # of ags */
 	xfs_extlen_t	sb_rbmblocks;	/* # of rt bitmap blocks */
 	xfs_extlen_t	sb_logblocks;	/* # of log blocks */
-	__uint16_t	sb_sectsize;	/* volume sector size (bytes) */
-	__uint16_t	sb_inodesize;	/* inode size (bytes) */
-	__uint8_t	sb_imax_pct;	/* max % of fs for inode space */
+	uint16_t	sb_sectsize;	/* volume sector size (bytes) */
+	uint16_t	sb_inodesize;	/* inode size (bytes) */
+	uint8_t		sb_imax_pct;	/* max % of fs for inode space */
 
 	/*
 	 * these don't have to match the superblock types but are placed
@@ -49,10 +49,10 @@ typedef struct fs_geometry  {
 	/*
 	 * fields after this point have to be checked manually in compare_sb()
 	 */
-	__uint8_t	sb_shared_vn;	/* shared version number */
+	uint8_t		sb_shared_vn;	/* shared version number */
 	xfs_extlen_t	sb_inoalignmt;	/* inode chunk alignment, fsblocks */
-	__uint32_t	sb_unit;	/* stripe or raid unit */
-	__uint32_t	sb_width;	/* stripe or width unit */
+	uint32_t	sb_unit;	/* stripe or raid unit */
+	uint32_t	sb_width;	/* stripe or width unit */
 
 	/*
 	 * these don't have to match, they track superblock properties
diff --git a/repair/attr_repair.h b/repair/attr_repair.h
index 7010e4f..02e056f 100644
--- a/repair/attr_repair.h
+++ b/repair/attr_repair.h
@@ -32,10 +32,10 @@
 #define ACL_WRITE	02
 #define ACL_EXECUTE	01
 
-typedef __uint16_t	xfs_acl_perm_t;
-typedef __int32_t	xfs_acl_type_t;
-typedef __int32_t	xfs_acl_tag_t;
-typedef __int32_t	xfs_acl_id_t;
+typedef uint16_t	xfs_acl_perm_t;
+typedef int32_t	xfs_acl_type_t;
+typedef int32_t	xfs_acl_tag_t;
+typedef int32_t	xfs_acl_id_t;
 
 /*
  * "icacl" = in-core ACL. There is no equivalent in the XFS kernel code,
@@ -50,7 +50,7 @@ struct xfs_icacl_entry {
 };
 
 struct xfs_icacl {
-	__int32_t		acl_cnt;
+	int32_t		acl_cnt;
 	struct xfs_icacl_entry	acl_entry[0];
 };
 
@@ -59,14 +59,14 @@ struct xfs_icacl {
  */
 #define XFS_MAC_MAX_SETS	250
 typedef struct xfs_mac_label {
-	__uint8_t       ml_msen_type;	/* MSEN label type */
-	__uint8_t       ml_mint_type;	/* MINT label type */
-	__uint8_t       ml_level;	/* Hierarchical level */
-	__uint8_t       ml_grade;	/* Hierarchical grade */
-	__uint16_t      ml_catcount;	/* Category count */
-	__uint16_t      ml_divcount;	/* Division count */
+	uint8_t       ml_msen_type;	/* MSEN label type */
+	uint8_t       ml_mint_type;	/* MINT label type */
+	uint8_t       ml_level;	/* Hierarchical level */
+	uint8_t       ml_grade;	/* Hierarchical grade */
+	uint16_t      ml_catcount;	/* Category count */
+	uint16_t      ml_divcount;	/* Division count */
 					/* Category set, then Division set */
-	__uint16_t      ml_list[XFS_MAC_MAX_SETS];
+	uint16_t      ml_list[XFS_MAC_MAX_SETS];
 } xfs_mac_label_t;
 
 /* MSEN label type names. Choose an upper case ASCII character.  */
@@ -93,7 +93,7 @@ typedef struct xfs_mac_label {
 /*
  * Capabilities (IRIX)
  */
-typedef __uint64_t xfs_cap_value_t;
+typedef uint64_t xfs_cap_value_t;
 
 typedef struct xfs_cap_set {
 	xfs_cap_value_t	cap_effective;  /* use in capability checks */
diff --git a/repair/avl64.c b/repair/avl64.c
index 51cd624..8f4a121 100644
--- a/repair/avl64.c
+++ b/repair/avl64.c
@@ -70,8 +70,8 @@ avl64_checktree(
 	avl64node_t *root)
 {
 	avl64node_t *nlast, *nnext, *np;
-	__uint64_t offset = 0;
-	__uint64_t end;
+	uint64_t offset = 0;
+	uint64_t end;
 
 	nlast = nnext = root;
 
@@ -583,8 +583,8 @@ attach:
 avl64node_t *
 avl64_findanyrange(
 	avl64tree_desc_t *tree,
-	__uint64_t start,
-	__uint64_t end,
+	uint64_t start,
+	uint64_t end,
 	int	checklen)
 {
 	avl64node_t *np = tree->avl_root;
@@ -655,7 +655,7 @@ avl64_findanyrange(
 avl64node_t *
 avl64_findrange(
 	avl64tree_desc_t *tree,
-	__uint64_t value)
+	uint64_t value)
 {
 	avl64node_t *np = tree->avl_root;
 
@@ -682,10 +682,10 @@ avl64_findrange(
 avl64node_t *
 avl64_find(
 	avl64tree_desc_t *tree,
-	__uint64_t value)
+	uint64_t value)
 {
 	avl64node_t *np = tree->avl_root;
-	__uint64_t nvalue;
+	uint64_t nvalue;
 
 	while (np) {
 		nvalue = AVL_START(tree, np);
@@ -909,8 +909,8 @@ static
 avl64node_t *
 avl64_insert_find_growth(
 		avl64tree_desc_t *tree,
-		__uint64_t start,	/* range start at start, */
-		__uint64_t end,	/* exclusive */
+		uint64_t start,	/* range start at start, */
+		uint64_t end,	/* exclusive */
 		int   *growthp)	/* OUT */
 {
 	avl64node_t *root = tree->avl_root;
@@ -963,7 +963,7 @@ avl64_insert_grow(
 	int growth)
 {
 	avl64node_t *nnext;
-	__uint64_t start = AVL_START(tree, newnode);
+	uint64_t start = AVL_START(tree, newnode);
 
 	if (growth == AVL_BACK) {
 
@@ -1005,8 +1005,8 @@ avl64_insert(
 	avl64node_t *newnode)
 {
 	avl64node_t *np;
-	__uint64_t start = AVL_START(tree, newnode);
-	__uint64_t end = AVL_END(tree, newnode);
+	uint64_t start = AVL_START(tree, newnode);
+	uint64_t end = AVL_END(tree, newnode);
 	int growth;
 
 	ASSERT(newnode);
@@ -1159,16 +1159,16 @@ avl64ops_t avl_debug_ops = {
 	avl_debug_end,
 }
 
-static __uint64_t
+static uint64_t
 avl64_debug_start(avl64node_t *node)
 {
-	return (__uint64_t)(struct avl_debug_node *)node->avl_start;
+	return (uint64_t)(struct avl_debug_node *)node->avl_start;
 }
 
-static __uint64_t
+static uint64_t
 avl64_debug_end(avl64node_t *node)
 {
-	return (__uint64_t)
+	return (uint64_t)
 		((struct avl_debug_node *)node->avl_start +
 		 (struct avl_debug_node *)node->avl_size);
 }
@@ -1304,7 +1304,7 @@ main()
 avl64node_t *
 avl64_findadjacent(
 	avl64tree_desc_t *tree,
-	__uint64_t value,
+	uint64_t value,
 	int		dir)
 {
 	avl64node_t *np = tree->avl_root;
@@ -1378,8 +1378,8 @@ avl64_findadjacent(
 void
 avl64_findranges(
 	avl64tree_desc_t *tree,
-	__uint64_t start,
-	__uint64_t end,
+	uint64_t start,
+	uint64_t end,
 	avl64node_t	        **startp,
 	avl64node_t		**endp)
 {
diff --git a/repair/avl64.h b/repair/avl64.h
index fd19321..cd079a0 100644
--- a/repair/avl64.h
+++ b/repair/avl64.h
@@ -32,8 +32,8 @@ typedef struct	avl64node {
  * avl-tree operations
  */
 typedef struct avl64ops {
-	__uint64_t	(*avl_start)(avl64node_t *);
-	__uint64_t	(*avl_end)(avl64node_t *);
+	uint64_t	(*avl_start)(avl64node_t *);
+	uint64_t	(*avl_end)(avl64node_t *);
 } avl64ops_t;
 
 /*
@@ -89,32 +89,32 @@ avl64_init_tree(
 avl64node_t *
 avl64_findrange(
 	avl64tree_desc_t *tree,
-	__uint64_t value);
+	uint64_t value);
 
 avl64node_t *
 avl64_find(
 	avl64tree_desc_t *tree,
-	__uint64_t value);
+	uint64_t value);
 
 avl64node_t *
 avl64_findanyrange(
 	avl64tree_desc_t *tree,
-	__uint64_t	start,
-	__uint64_t	end,
+	uint64_t	start,
+	uint64_t	end,
 	int     checklen);
 
 
 avl64node_t *
 avl64_findadjacent(
 	avl64tree_desc_t *tree,
-	__uint64_t	value,
+	uint64_t	value,
 	int		dir);
 
 void
 avl64_findranges(
 	avl64tree_desc_t *tree,
-	__uint64_t	start,
-	__uint64_t	end,
+	uint64_t	start,
+	uint64_t	end,
 	avl64node_t	        **startp,
 	avl64node_t		**endp);
 
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 7dbaca6..ecfd0f1 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -826,7 +826,7 @@ next_readbuf:
 		 * we do now, this is where to start.
 		 */
 		if (is_used)  {
-			__uint16_t	di_mode;
+			uint16_t	di_mode;
 
 			if (is_inode_free(ino_rec, irec_offset))  {
 				if (verbose || no_modify)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index df28e9e..3f3bf08 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -742,7 +742,7 @@ _("%s fork in ino %" PRIu64 " claims dup extent, "
 			case XR_E_FREE1:
 				do_warn(
 _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
-					forkname, ino, (__uint64_t) b);
+					forkname, ino, (uint64_t) b);
 				/* fall through ... */
 			case XR_E_UNKNOWN:
 				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
@@ -888,7 +888,7 @@ process_btinode(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
-	__uint64_t		*nex,
+	uint64_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
 	int			check_dups)
@@ -904,7 +904,7 @@ process_btinode(
 	int			level;
 	int			numrecs;
 	bmap_cursor_t		cursor;
-	__uint64_t		magic;
+	uint64_t		magic;
 
 	dib = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1063,7 +1063,7 @@ process_exinode(
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
-	__uint64_t		*nex,
+	uint64_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
 	int			check_dups)
@@ -1165,14 +1165,14 @@ process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
 		do_warn(
 _("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
 			dino->di_format,
-			(__int64_t)be64_to_cpu(dino->di_size), lino);
+			(int64_t)be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
 	if (dino->di_format == XFS_DINODE_FMT_LOCAL) {
 		do_warn(
 _("mismatch between format (%d) and size (%" PRId64 ") in symlink inode %" PRIu64 "\n"),
 			dino->di_format,
-			(__int64_t)be64_to_cpu(dino->di_size), lino);
+			(int64_t)be64_to_cpu(dino->di_size), lino);
 		return 1;
 	}
 
@@ -1414,22 +1414,22 @@ _("inode %" PRIu64 " has bad inode type (IFMNT)\n"), lino);
 		case XR_INO_CHRDEV:
 			do_warn(
 _("size of character device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(__int64_t)be64_to_cpu(dino->di_size));
+				(int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_BLKDEV:
 			do_warn(
 _("size of block device inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(__int64_t)be64_to_cpu(dino->di_size));
+				(int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_SOCK:
 			do_warn(
 _("size of socket inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(__int64_t)be64_to_cpu(dino->di_size));
+				(int64_t)be64_to_cpu(dino->di_size));
 			break;
 		case XR_INO_FIFO:
 			do_warn(
 _("size of fifo inode %" PRIu64 " != 0 (%" PRId64 " bytes)\n"), lino,
-				(__int64_t)be64_to_cpu(dino->di_size));
+				(int64_t)be64_to_cpu(dino->di_size));
 			break;
 		default:
 			do_warn(_("Internal error - process_misc_ino_types, "
@@ -1703,12 +1703,12 @@ _("found inode %" PRIu64 " claiming to be a real-time file\n"), lino);
 		break;
 
 	case XR_INO_RTBITMAP:
-		if (size != (__int64_t)mp->m_sb.sb_rbmblocks *
+		if (size != (int64_t)mp->m_sb.sb_rbmblocks *
 					mp->m_sb.sb_blocksize) {
 			do_warn(
 _("realtime bitmap inode %" PRIu64 " has bad size %" PRId64 " (should be %" PRIu64 ")\n"),
 				lino, size,
-				(__int64_t) mp->m_sb.sb_rbmblocks *
+				(int64_t) mp->m_sb.sb_rbmblocks *
 					mp->m_sb.sb_blocksize);
 			return 1;
 		}
@@ -1777,8 +1777,8 @@ static int
 process_inode_blocks_and_extents(
 	xfs_dinode_t	*dino,
 	xfs_rfsblock_t	nblocks,
-	__uint64_t	nextents,
-	__uint64_t	anextents,
+	uint64_t	nextents,
+	uint64_t	anextents,
 	xfs_ino_t	lino,
 	int		*dirty)
 {
@@ -1868,7 +1868,7 @@ process_inode_data_fork(
 	int		type,
 	int		*dirty,
 	xfs_rfsblock_t	*totblocks,
-	__uint64_t	*nextents,
+	uint64_t	*nextents,
 	blkmap_t	**dblkmap,
 	int		check_dups)
 {
@@ -1977,7 +1977,7 @@ process_inode_attr_fork(
 	int		type,
 	int		*dirty,
 	xfs_rfsblock_t	*atotblocks,
-	__uint64_t	*anextents,
+	uint64_t	*anextents,
 	int		check_dups,
 	int		extra_attr_check,
 	int		*retval)
@@ -2188,8 +2188,8 @@ process_dinode_int(xfs_mount_t *mp,
 	int			di_mode;
 	int			type;
 	int			retval = 0;
-	__uint64_t		nextents;
-	__uint64_t		anextents;
+	uint64_t		nextents;
+	uint64_t		anextents;
 	xfs_ino_t		lino;
 	const int		is_free = 0;
 	const int		is_used = 1;
@@ -2306,7 +2306,7 @@ _("inode identifier %llu mismatch on inode %" PRIu64 "\n"),
 		if (!uncertain)
 			do_warn(
 _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
-				(__int64_t)be64_to_cpu(dino->di_size),
+				(int64_t)be64_to_cpu(dino->di_size),
 				lino);
 		if (verify_mode)
 			return 1;
diff --git a/repair/dinode.h b/repair/dinode.h
index 5aebf5b..42a526b 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -46,8 +46,8 @@ process_bmbt_reclist(xfs_mount_t	*mp,
 		xfs_ino_t		ino,
 		xfs_rfsblock_t		*tot,
 		struct blkmap		**blkmapp,
-		__uint64_t		*first_key,
-		__uint64_t		*last_key,
+		uint64_t		*first_key,
+		uint64_t		*last_key,
 		int			whichfork);
 
 int
diff --git a/repair/dir2.c b/repair/dir2.c
index 61912d1..3bff438 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -160,7 +160,7 @@ process_sf_dir2(
 	int			bad_sfnamelen;
 	int			i;
 	int			i8;
-	__int64_t		ino_dir_size;
+	int64_t			ino_dir_size;
 	int			ino_off;
 	ino_tree_node_t		*irec_p;
 	int			junkit;
diff --git a/repair/globals.h b/repair/globals.h
index efd1d03..1a55d78 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -140,7 +140,7 @@ EXTERN int		inodes_per_cluster;
 EXTERN unsigned int	glob_agcount;
 EXTERN int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 EXTERN int		max_symlink_blocks;
-EXTERN __int64_t	fs_max_file_offset;
+EXTERN int64_t	fs_max_file_offset;
 
 /* realtime info */
 
@@ -160,16 +160,16 @@ EXTERN int		full_ino_ex_data;/*
 
 /* superblock counters */
 
-EXTERN __uint64_t	sb_icount;	/* allocated (made) inodes */
-EXTERN __uint64_t	sb_ifree;	/* free inodes */
-EXTERN __uint64_t	sb_fdblocks;	/* free data blocks */
-EXTERN __uint64_t	sb_frextents;	/* free realtime extents */
+EXTERN uint64_t	sb_icount;	/* allocated (made) inodes */
+EXTERN uint64_t	sb_ifree;	/* free inodes */
+EXTERN uint64_t	sb_fdblocks;	/* free data blocks */
+EXTERN uint64_t	sb_frextents;	/* free realtime extents */
 
 /* superblock geometry info */
 
 EXTERN xfs_extlen_t	sb_inoalignmt;
-EXTERN __uint32_t	sb_unit;
-EXTERN __uint32_t	sb_width;
+EXTERN uint32_t	sb_unit;
+EXTERN uint32_t	sb_width;
 
 struct aglock {
 	pthread_mutex_t	lock __attribute__((__aligned__(64)));
@@ -177,7 +177,7 @@ struct aglock {
 EXTERN struct aglock	*ag_locks;
 
 EXTERN int 		report_interval;
-EXTERN __uint64_t 	*prog_rpt_done;
+EXTERN uint64_t 	*prog_rpt_done;
 
 EXTERN int		ag_stride;
 EXTERN int		thread_count;
diff --git a/repair/incore.c b/repair/incore.c
index cb57316..a9191ae 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -179,7 +179,7 @@ get_bmap_ext(
 static uint64_t		*rt_bmap;
 static size_t		rt_bmap_size;
 
-/* block records fit into __uint64_t's units */
+/* block records fit into uint64_t's units */
 #define XR_BB_UNIT	64			/* number of bits/unit */
 #define XR_BB		4			/* bits per block record */
 #define XR_BB_NUM	(XR_BB_UNIT/XR_BB)	/* number of records per unit */
@@ -203,8 +203,8 @@ set_rtbmap(
 {
 	*(rt_bmap + bno / XR_BB_NUM) =
 	 ((*(rt_bmap + bno / XR_BB_NUM) &
-	  (~((__uint64_t) XR_BB_MASK << ((bno % XR_BB_NUM) * XR_BB)))) |
-	 (((__uint64_t) state) << ((bno % XR_BB_NUM) * XR_BB)));
+	  (~((uint64_t) XR_BB_MASK << ((bno % XR_BB_NUM) * XR_BB)))) |
+	 (((uint64_t) state) << ((bno % XR_BB_NUM) * XR_BB)));
 }
 
 static void
@@ -222,9 +222,9 @@ init_rt_bmap(
 		return;
 
 	rt_bmap_size = roundup(mp->m_sb.sb_rextents / (NBBY / XR_BB),
-			       sizeof(__uint64_t));
+			       sizeof(uint64_t));
 
-	rt_bmap = memalign(sizeof(__uint64_t), rt_bmap_size);
+	rt_bmap = memalign(sizeof(uint64_t), rt_bmap_size);
 	if (!rt_bmap) {
 		do_error(
 	_("couldn't allocate realtime block map, size = %" PRIu64 "\n"),
diff --git a/repair/incore.h b/repair/incore.h
index c92475e..c0b593d 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -261,7 +261,7 @@ typedef xfs_ino_t parent_entry_t;
 struct nlink_ops;
 
 typedef struct parent_list  {
-	__uint64_t		pmask;
+	uint64_t		pmask;
 	parent_entry_t		*pentries;
 #ifdef DEBUG
 	short			cnt;
@@ -269,14 +269,14 @@ typedef struct parent_list  {
 } parent_list_t;
 
 union ino_nlink {
-	__uint8_t	*un8;
-	__uint16_t	*un16;
-	__uint32_t	*un32;
+	uint8_t		*un8;
+	uint16_t	*un16;
+	uint32_t	*un32;
 };
 
 typedef struct ino_ex_data  {
-	__uint64_t		ino_reached;	/* bit == 1 if reached */
-	__uint64_t		ino_processed;	/* reference checked bit mask */
+	uint64_t		ino_reached;	/* bit == 1 if reached */
+	uint64_t		ino_processed;	/* reference checked bit mask */
 	parent_list_t		*parents;
 	union ino_nlink		counted_nlinks;/* counted nlinks in P6 */
 } ino_ex_data_t;
@@ -285,20 +285,20 @@ typedef struct ino_tree_node  {
 	avlnode_t		avl_node;
 	xfs_agino_t		ino_startnum;	/* starting inode # */
 	xfs_inofree_t		ir_free;	/* inode free bit mask */
-	__uint64_t		ir_sparse;	/* sparse inode bitmask */
-	__uint64_t		ino_confirmed;	/* confirmed bitmask */
-	__uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
-	__uint8_t		nlink_size;
+	uint64_t		ir_sparse;	/* sparse inode bitmask */
+	uint64_t		ino_confirmed;	/* confirmed bitmask */
+	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
+	uint8_t			nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
 		ino_ex_data_t	*ex_data;	/* phases 6,7 */
 		parent_list_t	*plist;		/* phases 2-5 */
 	} ino_un;
-	__uint8_t		*ftypes;	/* phases 3,6 */
+	uint8_t			*ftypes;	/* phases 3,6 */
 } ino_tree_node_t;
 
-#define INOS_PER_IREC	(sizeof(__uint64_t) * NBBY)
-#define	IREC_MASK(i)	((__uint64_t)1 << (i))
+#define INOS_PER_IREC	(sizeof(uint64_t) * NBBY)
+#define	IREC_MASK(i)	((uint64_t)1 << (i))
 
 void		add_ino_ex_data(xfs_mount_t *mp);
 
@@ -509,10 +509,10 @@ static inline bool is_inode_sparse(struct ino_tree_node *irec, int offset)
  */
 void add_inode_ref(struct ino_tree_node *irec, int offset);
 void drop_inode_ref(struct ino_tree_node *irec, int offset);
-__uint32_t num_inode_references(struct ino_tree_node *irec, int offset);
+uint32_t num_inode_references(struct ino_tree_node *irec, int offset);
 
-void set_inode_disk_nlinks(struct ino_tree_node *irec, int offset, __uint32_t nlinks);
-__uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int offset);
+void set_inode_disk_nlinks(struct ino_tree_node *irec, int offset, uint32_t nlinks);
+uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int offset);
 
 static inline int is_inode_reached(struct ino_tree_node *irec, int offset)
 {
@@ -533,13 +533,13 @@ static inline void add_inode_reached(struct ino_tree_node *irec, int offset)
 static inline void
 set_inode_ftype(struct ino_tree_node *irec,
 	int		ino_offset,
-	__uint8_t	ftype)
+	uint8_t		ftype)
 {
 	if (irec->ftypes)
 		irec->ftypes[ino_offset] = ftype;
 }
 
-static inline __uint8_t
+static inline uint8_t
 get_inode_ftype(
 	struct ino_tree_node *irec,
 	int		ino_offset)
@@ -572,11 +572,11 @@ typedef struct bm_level_state  {
 	xfs_fsblock_t		fsbno;
 	xfs_fsblock_t		left_fsbno;
 	xfs_fsblock_t		right_fsbno;
-	__uint64_t		first_key;
-	__uint64_t		last_key;
+	uint64_t		first_key;
+	uint64_t		last_key;
 /*
 	int			level;
-	__uint64_t		prev_last_key;
+	uint64_t		prev_last_key;
 	xfs_buf_t		*bp;
 	xfs_bmbt_block_t	*block;
 */
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 7e6786c..0a8138a 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -721,13 +721,13 @@ search_rt_dup_extent(xfs_mount_t *mp, xfs_rtblock_t bno)
 	return(ret);
 }
 
-static __uint64_t
+static uint64_t
 avl64_rt_ext_start(avl64node_t *node)
 {
 	return(((rt_extent_tree_node_t *) node)->rt_startblock);
 }
 
-static __uint64_t
+static uint64_t
 avl64_ext_end(avl64node_t *node)
 {
 	return(((rt_extent_tree_node_t *) node)->rt_startblock +
@@ -834,7 +834,7 @@ count_extents(xfs_agnumber_t agno, avltree_desc_t *tree, int whichtree)
 int
 count_bno_extents_blocks(xfs_agnumber_t agno, uint *numblocks)
 {
-	__uint64_t nblocks;
+	uint64_t nblocks;
 	extent_tree_node_t *node;
 	int i = 0;
 
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 1898257..6ffe08e 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -38,7 +38,7 @@ static avltree_desc_t	**inode_uncertain_tree_ptrs;
 /* memory optimised nlink counting for all inodes */
 
 static void *
-alloc_nlink_array(__uint8_t nlink_size)
+alloc_nlink_array(uint8_t nlink_size)
 {
 	void *ptr;
 
@@ -51,10 +51,10 @@ alloc_nlink_array(__uint8_t nlink_size)
 static void
 nlink_grow_8_to_16(ino_tree_node_t *irec)
 {
-	__uint16_t	*new_nlinks;
+	uint16_t	*new_nlinks;
 	int		i;
 
-	irec->nlink_size = sizeof(__uint16_t);
+	irec->nlink_size = sizeof(uint16_t);
 
 	new_nlinks = alloc_nlink_array(irec->nlink_size);
 	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
@@ -76,10 +76,10 @@ nlink_grow_8_to_16(ino_tree_node_t *irec)
 static void
 nlink_grow_16_to_32(ino_tree_node_t *irec)
 {
-	__uint32_t	*new_nlinks;
+	uint32_t	*new_nlinks;
 	int		i;
 
-	irec->nlink_size = sizeof(__uint32_t);
+	irec->nlink_size = sizeof(uint32_t);
 
 	new_nlinks = alloc_nlink_array(irec->nlink_size);
 	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)
@@ -104,21 +104,21 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 	ASSERT(irec->ino_un.ex_data != NULL);
 
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		if (irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] < 0xff) {
 			irec->ino_un.ex_data->counted_nlinks.un8[ino_offset]++;
 			break;
 		}
 		nlink_grow_8_to_16(irec);
 		/*FALLTHRU*/
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		if (irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] < 0xffff) {
 			irec->ino_un.ex_data->counted_nlinks.un16[ino_offset]++;
 			break;
 		}
 		nlink_grow_16_to_32(irec);
 		/*FALLTHRU*/
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
 		break;
 	default:
@@ -128,20 +128,20 @@ void add_inode_ref(struct ino_tree_node *irec, int ino_offset)
 
 void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
 {
-	__uint32_t	refs = 0;
+	uint32_t	refs = 0;
 
 	ASSERT(irec->ino_un.ex_data != NULL);
 
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		ASSERT(irec->ino_un.ex_data->counted_nlinks.un8[ino_offset] > 0);
 		refs = --irec->ino_un.ex_data->counted_nlinks.un8[ino_offset];
 		break;
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		ASSERT(irec->ino_un.ex_data->counted_nlinks.un16[ino_offset] > 0);
 		refs = --irec->ino_un.ex_data->counted_nlinks.un16[ino_offset];
 		break;
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		ASSERT(irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] > 0);
 		refs = --irec->ino_un.ex_data->counted_nlinks.un32[ino_offset];
 		break;
@@ -153,16 +153,16 @@ void drop_inode_ref(struct ino_tree_node *irec, int ino_offset)
 		irec->ino_un.ex_data->ino_reached &= ~IREC_MASK(ino_offset);
 }
 
-__uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
+uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
 {
 	ASSERT(irec->ino_un.ex_data != NULL);
 
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		return irec->ino_un.ex_data->counted_nlinks.un8[ino_offset];
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		return irec->ino_un.ex_data->counted_nlinks.un16[ino_offset];
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		return irec->ino_un.ex_data->counted_nlinks.un32[ino_offset];
 	default:
 		ASSERT(0);
@@ -171,24 +171,24 @@ __uint32_t num_inode_references(struct ino_tree_node *irec, int ino_offset)
 }
 
 void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
-		__uint32_t nlinks)
+		uint32_t nlinks)
 {
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		if (nlinks < 0xff) {
 			irec->disk_nlinks.un8[ino_offset] = nlinks;
 			break;
 		}
 		nlink_grow_8_to_16(irec);
 		/*FALLTHRU*/
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		if (nlinks < 0xffff) {
 			irec->disk_nlinks.un16[ino_offset] = nlinks;
 			break;
 		}
 		nlink_grow_16_to_32(irec);
 		/*FALLTHRU*/
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		irec->disk_nlinks.un32[ino_offset] = nlinks;
 		break;
 	default:
@@ -196,14 +196,14 @@ void set_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset,
 	}
 }
 
-__uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
+uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
 {
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		return irec->disk_nlinks.un8[ino_offset];
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		return irec->disk_nlinks.un16[ino_offset];
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		return irec->disk_nlinks.un32[ino_offset];
 	default:
 		ASSERT(0);
@@ -211,11 +211,11 @@ __uint32_t get_inode_disk_nlinks(struct ino_tree_node *irec, int ino_offset)
 	return 0;
 }
 
-static __uint8_t *
+static uint8_t *
 alloc_ftypes_array(
 	struct xfs_mount *mp)
 {
-	__uint8_t	*ptr;
+	uint8_t		*ptr;
 
 	if (!xfs_sb_version_hasftype(&mp->m_sb))
 		return NULL;
@@ -260,23 +260,23 @@ alloc_ino_node(
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
-	irec->nlink_size = sizeof(__uint8_t);
+	irec->nlink_size = sizeof(uint8_t);
 	irec->disk_nlinks.un8 = alloc_nlink_array(irec->nlink_size);
 	irec->ftypes = alloc_ftypes_array(mp);
 	return irec;
 }
 
 static void
-free_nlink_array(union ino_nlink nlinks, __uint8_t nlink_size)
+free_nlink_array(union ino_nlink nlinks, uint8_t nlink_size)
 {
 	switch (nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		free(nlinks.un8);
 		break;
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		free(nlinks.un16);
 		break;
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		free(nlinks.un32);
 		break;
 	default:
@@ -607,7 +607,7 @@ set_inode_parent(
 	int			i;
 	int			cnt;
 	int			target;
-	__uint64_t		bitmask;
+	uint64_t		bitmask;
 	parent_entry_t		*tmp;
 
 	if (full_ino_ex_data)
@@ -697,7 +697,7 @@ set_inode_parent(
 xfs_ino_t
 get_inode_parent(ino_tree_node_t *irec, int offset)
 {
-	__uint64_t	bitmask;
+	uint64_t	bitmask;
 	parent_list_t	*ptbl;
 	int		i;
 	int		target;
@@ -738,15 +738,15 @@ alloc_ex_data(ino_tree_node_t *irec)
 	irec->ino_un.ex_data->parents = ptbl;
 
 	switch (irec->nlink_size) {
-	case sizeof(__uint8_t):
+	case sizeof(uint8_t):
 		irec->ino_un.ex_data->counted_nlinks.un8 =
 			alloc_nlink_array(irec->nlink_size);
 		break;
-	case sizeof(__uint16_t):
+	case sizeof(uint16_t):
 		irec->ino_un.ex_data->counted_nlinks.un16 =
 			alloc_nlink_array(irec->nlink_size);
 		break;
-	case sizeof(__uint32_t):
+	case sizeof(uint32_t):
 		irec->ino_un.ex_data->counted_nlinks.un32 =
 			alloc_nlink_array(irec->nlink_size);
 		break;
diff --git a/repair/phase2.c b/repair/phase2.c
index e21ffa6..a2dfa0b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -173,7 +173,7 @@ phase2(
 
 	bad_ino_btree = 0;
 
-	set_progress_msg(PROG_FMT_SCAN_AG, (__uint64_t) glob_agcount);
+	set_progress_msg(PROG_FMT_SCAN_AG, (uint64_t) glob_agcount);
 
 	scan_ags(mp, scan_threads);
 
diff --git a/repair/phase3.c b/repair/phase3.c
index 76c9440..398c60c 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -98,7 +98,7 @@ phase3(xfs_mount_t *mp)
 	else
 		do_log(_("        - scan (but don't clear) agi unlinked lists...\n"));
 
-	set_progress_msg(PROG_FMT_AGI_UNLINKED, (__uint64_t) glob_agcount);
+	set_progress_msg(PROG_FMT_AGI_UNLINKED, (uint64_t) glob_agcount);
 
 	/* first clear the agi unlinked AGI list */
 	if (!no_modify) {
@@ -118,7 +118,7 @@ phase3(xfs_mount_t *mp)
 	do_log(_(
 	    "        - process known inodes and perform inode discovery...\n"));
 
-	set_progress_msg(PROG_FMT_PROCESS_INO, (__uint64_t) mp->m_sb.sb_icount);
+	set_progress_msg(PROG_FMT_PROCESS_INO, (uint64_t) mp->m_sb.sb_icount);
 
 	process_ags(mp);
 
@@ -128,7 +128,7 @@ phase3(xfs_mount_t *mp)
 	 * process newly discovered inode chunks
 	 */
 	do_log(_("        - process newly discovered inodes...\n"));
-	set_progress_msg(PROG_FMT_NEW_INODES, (__uint64_t) glob_agcount);
+	set_progress_msg(PROG_FMT_NEW_INODES, (uint64_t) glob_agcount);
 	do  {
 		/*
 		 * have to loop until no ag has any uncertain
diff --git a/repair/phase4.c b/repair/phase4.c
index 1a7d7b5..90386c2 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -175,7 +175,7 @@ phase4(xfs_mount_t *mp)
 	do_log(_("Phase 4 - check for duplicate blocks...\n"));
 	do_log(_("        - setting up duplicate extent list...\n"));
 
-	set_progress_msg(PROG_FMT_DUP_EXTENT, (__uint64_t) glob_agcount);
+	set_progress_msg(PROG_FMT_DUP_EXTENT, (uint64_t) glob_agcount);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
@@ -289,7 +289,7 @@ phase4(xfs_mount_t *mp)
 	reset_bmaps(mp);
 
 	do_log(_("        - check for inodes claiming duplicate blocks...\n"));
-	set_progress_msg(PROG_FMT_DUP_BLOCKS, (__uint64_t) mp->m_sb.sb_icount);
+	set_progress_msg(PROG_FMT_DUP_BLOCKS, (uint64_t) mp->m_sb.sb_icount);
 
 	/*
 	 * ok, now process the inodes -- signal 2-pass check per inode.
diff --git a/repair/phase5.c b/repair/phase5.c
index 5d48848..c280292 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -83,9 +83,9 @@ struct agi_stat {
 	xfs_agino_t		freecount;
 };
 
-static __uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
-static __uint64_t	*sb_ifree_ag;		/* free inodes per ag */
-static __uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
+static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
+static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
+static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
 
 static int
 mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
@@ -618,14 +618,14 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 static void
 prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
 		bt_status_t *btree_curs, xfs_agblock_t startblock,
-		xfs_extlen_t blockcount, int level, __uint32_t magic)
+		xfs_extlen_t blockcount, int level, uint32_t magic)
 {
 	struct xfs_btree_block	*bt_hdr;
 	xfs_alloc_key_t		*bt_key;
 	xfs_alloc_ptr_t		*bt_ptr;
 	xfs_agblock_t		agbno;
 	bt_stat_level_t		*lptr;
-	__uint32_t		crc_magic;
+	uint32_t		crc_magic;
 
 	if (magic == XFS_ABTB_MAGIC)
 		crc_magic = XFS_ABTB_CRC_MAGIC;
@@ -720,7 +720,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static xfs_extlen_t
 build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic)
+		bt_status_t *btree_curs, uint32_t magic)
 {
 	xfs_agnumber_t		i;
 	xfs_agblock_t		j;
@@ -731,7 +731,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
 	extent_tree_node_t	*ext_ptr;
 	bt_stat_level_t		*lptr;
 	xfs_extlen_t		freeblks;
-	__uint32_t		crc_magic;
+	uint32_t		crc_magic;
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
@@ -895,10 +895,10 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
  */
 static void
 init_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
-		__uint64_t *num_inos, __uint64_t *num_free_inos, int finobt)
+		uint64_t *num_inos, uint64_t *num_free_inos, int finobt)
 {
-	__uint64_t		ninos;
-	__uint64_t		nfinos;
+	uint64_t		ninos;
+	uint64_t		nfinos;
 	int			rec_nfinos;
 	int			rec_ninos;
 	ino_tree_node_t		*ino_rec;
@@ -1144,7 +1144,7 @@ build_agi(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
  */
 static void
 build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, __uint32_t magic,
+		bt_status_t *btree_curs, uint32_t magic,
 		struct agi_stat *agi_stat, int finobt)
 {
 	xfs_agnumber_t		i;
@@ -1573,10 +1573,10 @@ phase5_func(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno)
 {
-	__uint64_t	num_inos;
-	__uint64_t	num_free_inos;
-	__uint64_t	finobt_num_inos;
-	__uint64_t	finobt_num_free_inos;
+	uint64_t	num_inos;
+	uint64_t	num_free_inos;
+	uint64_t	finobt_num_inos;
+	uint64_t	finobt_num_free_inos;
 	bt_status_t	bno_btree_curs;
 	bt_status_t	bcnt_btree_curs;
 	bt_status_t	ino_btree_curs;
@@ -1588,7 +1588,7 @@ phase5_func(
 	xfs_extlen_t	freeblks2;
 #endif
 	xfs_agblock_t	num_extents;
-	__uint32_t	magic;
+	uint32_t	magic;
 	struct agi_stat	agi_stat = {0,};
 
 	if (verbose)
@@ -1772,7 +1772,7 @@ phase5(xfs_mount_t *mp)
 	xfs_agnumber_t		agno;
 
 	do_log(_("Phase 5 - rebuild AG headers and trees...\n"));
-	set_progress_msg(PROG_FMT_REBUILD_AG, (__uint64_t )glob_agcount);
+	set_progress_msg(PROG_FMT_REBUILD_AG, (uint64_t )glob_agcount);
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
@@ -1798,15 +1798,15 @@ phase5(xfs_mount_t *mp)
 	keep_fsinos(mp);
 
 	/* allocate per ag counters */
-	sb_icount_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	sb_icount_ag = calloc(mp->m_sb.sb_agcount, sizeof(uint64_t));
 	if (sb_icount_ag == NULL)
 		do_error(_("cannot alloc sb_icount_ag buffers\n"));
 
-	sb_ifree_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	sb_ifree_ag = calloc(mp->m_sb.sb_agcount, sizeof(uint64_t));
 	if (sb_ifree_ag == NULL)
 		do_error(_("cannot alloc sb_ifree_ag buffers\n"));
 
-	sb_fdblocks_ag = calloc(mp->m_sb.sb_agcount, sizeof(__uint64_t));
+	sb_fdblocks_ag = calloc(mp->m_sb.sb_agcount, sizeof(uint64_t));
 	if (sb_fdblocks_ag == NULL)
 		do_error(_("cannot alloc sb_fdblocks_ag buffers\n"));
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 7680deb..437142a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -82,7 +82,7 @@ typedef struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyhash;	/* next in name bucket */
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
-	__uint32_t		address;	/* offset of data entry */
+	uint32_t		address;	/* offset of data entry */
 	xfs_ino_t 		inum;		/* inode num of entry */
 	short			junkit;		/* name starts with / */
 	short			seen;		/* have seen leaf entry */
@@ -170,11 +170,11 @@ static int
 dir_hash_add(
 	xfs_mount_t		*mp,
 	dir_hash_tab_t		*hashtab,
-	__uint32_t		addr,
+	uint32_t		addr,
 	xfs_ino_t		inum,
 	int			namelen,
 	unsigned char		*name,
-	__uint8_t		ftype)
+	uint8_t			ftype)
 {
 	xfs_dahash_t		hash = 0;
 	int			byaddr;
@@ -357,7 +357,7 @@ static void
 dir_hash_update_ftype(
 	dir_hash_tab_t		*hashtab,
 	xfs_dir2_dataptr_t	addr,
-	__uint8_t		ftype)
+	uint8_t			ftype)
 {
 	int			i;
 	dir_hash_ent_t		*p;
@@ -887,7 +887,7 @@ mk_root_dir(xfs_mount_t *mp)
 	memset(&ip->i_d, 0, xfs_icdinode_size(vers));
 
 	ip->i_d.di_magic = XFS_DINODE_MAGIC;
-	ip->i_d.di_mode = (__uint16_t) mode|S_IFDIR;
+	ip->i_d.di_mode = (uint16_t) mode|S_IFDIR;
 	ip->i_d.di_version = vers;
 	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
@@ -1839,8 +1839,8 @@ longform_dir2_entry_check_data(
 
 		/* validate ftype field if supported */
 		if (xfs_sb_version_hasftype(&mp->m_sb)) {
-			__uint8_t dir_ftype;
-			__uint8_t ino_ftype;
+			uint8_t dir_ftype;
+			uint8_t ino_ftype;
 
 			dir_ftype = M_DIROPS(mp)->data_get_ftype(dep);
 			ino_ftype = get_inode_ftype(irec, ino_offset);
@@ -2750,8 +2750,8 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 
 		/* validate ftype field if supported */
 		if (xfs_sb_version_hasftype(&mp->m_sb)) {
-			__uint8_t dir_ftype;
-			__uint8_t ino_ftype;
+			uint8_t dir_ftype;
+			uint8_t ino_ftype;
 
 			dir_ftype = M_DIROPS(mp)->sf_get_ftype(sfep);
 			ino_ftype = get_inode_ftype(irec, ino_offset);
diff --git a/repair/phase7.c b/repair/phase7.c
index b1e3a55..d8e788e 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -32,7 +32,7 @@ static void
 set_nlinks(
 	xfs_icdinode_t		*dinoc,
 	xfs_ino_t		ino,
-	__uint32_t		nrefs,
+	uint32_t		nrefs,
 	int			*dirty)
 {
 	if (dinoc->di_nlink == nrefs)
@@ -56,7 +56,7 @@ static void
 update_inode_nlinks(
 	xfs_mount_t 		*mp,
 	xfs_ino_t		ino,
-	__uint32_t		nlinks)
+	uint32_t		nlinks)
 {
 	xfs_trans_t		*tp;
 	xfs_inode_t		*ip;
@@ -114,7 +114,7 @@ phase7(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 	int			j;
-	__uint32_t		nrefs;
+	uint32_t		nrefs;
 
 	if (!no_modify)
 		do_log(_("Phase 7 - verify and correct link counts...\n"));
diff --git a/repair/progress.c b/repair/progress.c
index 418b803..eae14e7 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -85,8 +85,8 @@ pthread_t	report_thread;
 typedef struct msg_block_s {
 	pthread_mutex_t	mutex;
 	progress_rpt_t	*format;
-	__uint64_t	*done;
-	__uint64_t	*total;
+	uint64_t	*done;
+	uint64_t	*total;
 	int		count;
 	int		interval;
 } msg_block_t;
@@ -96,14 +96,14 @@ typedef struct phase_times_s {
 	time_t		start;
 	time_t		end;
 	time_t		duration;
-	__uint64_t	item_counts[4];
+	uint64_t	item_counts[4];
 } phase_times_t;
 static phase_times_t phase_times[8];
 
 static void *progress_rpt_thread(void *);
 static int current_phase;
 static int running;
-static __uint64_t prog_rpt_total;
+static uint64_t prog_rpt_total;
 
 void
 init_progress_rpt (void)
@@ -113,11 +113,11 @@ init_progress_rpt (void)
 	 *  allocate the done vector
 	 */
 
-	if ((prog_rpt_done = (__uint64_t *)
-		malloc(sizeof(__uint64_t)*glob_agcount)) == NULL ) {
+	if ((prog_rpt_done = (uint64_t *)
+		malloc(sizeof(uint64_t)*glob_agcount)) == NULL ) {
 		do_error(_("cannot malloc pointer to done vector\n"));
 	}
-	bzero(prog_rpt_done, sizeof(__uint64_t)*glob_agcount);
+	bzero(prog_rpt_done, sizeof(uint64_t)*glob_agcount);
 
 	/*
 	 *  Setup comm block, start the thread
@@ -165,10 +165,10 @@ progress_rpt_thread (void *p)
 	timer_t timerid;
 	struct itimerspec timespec;
 	char *msgbuf;
-	__uint64_t *donep;
-	__uint64_t sum;
+	uint64_t *donep;
+	uint64_t sum;
 	msg_block_t *msgp = (msg_block_t *)p;
-	__uint64_t percent;
+	uint64_t percent;
 
 	/* It's possible to get here very early w/ no progress msg set */
 	if (!msgp->format)
@@ -286,7 +286,7 @@ progress_rpt_thread (void *p)
 }
 
 int
-set_progress_msg (int report, __uint64_t total)
+set_progress_msg (int report, uint64_t total)
 {
 
 	if (!ag_stride)
@@ -300,7 +300,7 @@ set_progress_msg (int report, __uint64_t total)
 
 	/* reset all the accumulative totals */
 	if (prog_rpt_done)
-		bzero(prog_rpt_done, sizeof(__uint64_t)*glob_agcount);
+		bzero(prog_rpt_done, sizeof(uint64_t)*glob_agcount);
 
 	if (pthread_mutex_unlock(&global_msgs.mutex))
 		do_error(_("set_progress_msg: cannot unlock progress mutex\n"));
@@ -308,14 +308,14 @@ set_progress_msg (int report, __uint64_t total)
 	return (0);
 }
 
-__uint64_t
+uint64_t
 print_final_rpt(void)
 {
 	int i;
 	struct tm *tmp;
 	time_t now;
-	__uint64_t *donep;
-	__uint64_t sum;
+	uint64_t *donep;
+	uint64_t sum;
 	msg_block_t 	*msgp = &global_msgs;
 	char		msgbuf[DURATION_BUF_SIZE];
 
diff --git a/repair/progress.h b/repair/progress.h
index 33db834..5152648 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -32,8 +32,8 @@
 extern void init_progress_rpt(void);
 extern void stop_progress_rpt(void);
 extern void summary_report(void);
-extern int  set_progress_msg(int report, __uint64_t total);
-extern __uint64_t print_final_rpt(void);
+extern int  set_progress_msg(int report, uint64_t total);
+extern uint64_t print_final_rpt(void);
 extern char *timestamp(int end, int phase, char *buf);
 extern char *duration(int val, char *buf);
 extern int do_parallel;
diff --git a/repair/sb.c b/repair/sb.c
index 4eef14a..ea89ca9 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -41,7 +41,7 @@ copy_sb(xfs_sb_t *source, xfs_sb_t *dest)
 	xfs_ino_t	uquotino;
 	xfs_ino_t	gquotino;
 	xfs_ino_t	pquotino;
-	__uint16_t	versionnum;
+	uint16_t	versionnum;
 
 	rootino = dest->sb_rootino;
 	rbmino = dest->sb_rbmino;
@@ -264,7 +264,7 @@ sb_validate_ino_align(struct xfs_sb *sb)
 int
 verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 {
-	__uint32_t	bsize;
+	uint32_t	bsize;
 	int		i;
 
 	/* check magic number and version number */
@@ -329,13 +329,13 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 
 	if (sb->sb_dblocks == 0 ||
 		sb->sb_dblocks >
-			((__uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
+			((uint64_t)sb->sb_agcount * sb->sb_agblocks) ||
 		sb->sb_dblocks <
-			((__uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
+			((uint64_t)(sb->sb_agcount - 1) * sb->sb_agblocks
 			+ XFS_MIN_AG_BLOCKS))
 		return(XR_BAD_FS_SIZE_DATA);
 
-	if (sb->sb_agblklog != (__uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
+	if (sb->sb_agblklog != (uint8_t)libxfs_log2_roundup(sb->sb_agblocks))
 		return(XR_BAD_FS_SIZE_DATA);
 
 	if (sb->sb_inodesize < XFS_DINODE_MIN_SIZE ||
diff --git a/repair/scan.c b/repair/scan.c
index 964ff06..5a79325 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -40,12 +40,12 @@ struct aghdr_cnts {
 	xfs_agnumber_t	agno;
 	xfs_extlen_t	agffreeblks;
 	xfs_extlen_t	agflongest;
-	__uint64_t	agfbtreeblks;
-	__uint32_t	agicount;
-	__uint32_t	agifreecount;
-	__uint64_t	fdblocks;
-	__uint64_t	ifreecount;
-	__uint32_t	fibtfreecount;
+	uint64_t	agfbtreeblks;
+	uint32_t	agicount;
+	uint32_t	agifreecount;
+	uint64_t	fdblocks;
+	uint64_t	ifreecount;
+	uint32_t	fibtfreecount;
 };
 
 void
@@ -67,10 +67,10 @@ scan_sbtree(
 				xfs_agnumber_t		agno,
 				int			suspect,
 				int			isroot,
-				__uint32_t		magic,
+				uint32_t		magic,
 				void			*priv),
 	int		isroot,
-	__uint32_t	magic,
+	uint32_t	magic,
 	void		*priv,
 	const struct xfs_buf_ops *ops)
 {
@@ -107,23 +107,23 @@ scan_lbtree(
 				xfs_fsblock_t		bno,
 				xfs_ino_t		ino,
 				xfs_rfsblock_t		*tot,
-				__uint64_t		*nex,
+				uint64_t		*nex,
 				blkmap_t		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				__uint64_t		magic),
+				uint64_t		magic),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
 	xfs_rfsblock_t	*tot,
-	__uint64_t	*nex,
+	uint64_t	*nex,
 	blkmap_t	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
 	int		isroot,
 	int		check_dups,
-	__uint64_t	magic,
+	uint64_t	magic,
 	const struct xfs_buf_ops *ops)
 {
 	xfs_buf_t	*bp;
@@ -176,13 +176,13 @@ scan_bmapbt(
 	xfs_fsblock_t		bno,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	__uint64_t		*nex,
+	uint64_t		*nex,
 	blkmap_t		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	__uint64_t		magic)
+	uint64_t		magic)
 {
 	int			i;
 	int			err;
@@ -528,7 +528,7 @@ scan_allocbt(
 	xfs_agnumber_t		agno,
 	int			suspect,
 	int			isroot,
-	__uint32_t		magic,
+	uint32_t		magic,
 	void			*priv)
 {
 	struct aghdr_cnts	*agcnts = priv;
@@ -1243,7 +1243,7 @@ scan_inobt(
 	xfs_agnumber_t		agno,
 	int			suspect,
 	int			isroot,
-	__uint32_t		magic,
+	uint32_t		magic,
 	void			*priv)
 {
 	struct aghdr_cnts	*agcnts = priv;
@@ -1479,7 +1479,7 @@ validate_agf(
 	struct aghdr_cnts	*agcnts)
 {
 	xfs_agblock_t		bno;
-	__uint32_t		magic;
+	uint32_t		magic;
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
@@ -1530,7 +1530,7 @@ validate_agi(
 {
 	xfs_agblock_t		bno;
 	int			i;
-	__uint32_t		magic;
+	uint32_t		magic;
 
 	bno = be32_to_cpu(agi->agi_root);
 	if (bno != 0 && verify_agbno(mp, agno, bno)) {
@@ -1756,9 +1756,9 @@ scan_ags(
 	int			scan_threads)
 {
 	struct aghdr_cnts *agcnts;
-	__uint64_t	fdblocks = 0;
-	__uint64_t	icount = 0;
-	__uint64_t	ifreecount = 0;
+	uint64_t	fdblocks = 0;
+	uint64_t	icount = 0;
+	uint64_t	ifreecount = 0;
 	xfs_agnumber_t	i;
 	work_queue_t	wq;
 
diff --git a/repair/scan.h b/repair/scan.h
index ea8c0bf..9bbe1e6 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -30,23 +30,23 @@ int scan_lbtree(
 				xfs_fsblock_t		bno,
 				xfs_ino_t		ino,
 				xfs_rfsblock_t		*tot,
-				__uint64_t		*nex,
+				uint64_t		*nex,
 				struct blkmap		**blkmapp,
 				bmap_cursor_t		*bm_cursor,
 				int			isroot,
 				int			check_dups,
 				int			*dirty,
-				__uint64_t		magic),
+				uint64_t		magic),
 	int		type,
 	int		whichfork,
 	xfs_ino_t	ino,
 	xfs_rfsblock_t	*tot,
-	__uint64_t	*nex,
+	uint64_t	*nex,
 	struct blkmap	**blkmapp,
 	bmap_cursor_t	*bm_cursor,
 	int		isroot,
 	int		check_dups,
-	__uint64_t	magic,
+	uint64_t	magic,
 	const struct xfs_buf_ops *ops);
 
 int scan_bmapbt(
@@ -57,13 +57,13 @@ int scan_bmapbt(
 	xfs_fsblock_t		bno,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	__uint64_t		*nex,
+	uint64_t		*nex,
 	struct blkmap		**blkmapp,
 	bmap_cursor_t		*bm_cursor,
 	int			isroot,
 	int			check_dups,
 	int			*dirty,
-	__uint64_t		magic);
+	uint64_t		magic);
 
 void
 scan_ags(
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
