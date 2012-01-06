Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06K9WqO038335 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 14:09:32 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: use the full 32-bit generation number
Date: Fri,  6 Jan 2012 14:09:25 -0600
Message-Id: <1325880565-20934-1-git-send-email-wkendall@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfsdump historically has truncated the inode generation number to the low
12 bits when writing out directory entries. This makes it possible for
xfsrestore to mistakingly think 2 directory entries refer to the same
inode when dealing with incremental or resumed dumps. A message such as
this is an indication of this problem:

    xfsrestore: WARNING: unable to unlink current file prior to restore

This patch changes xfsdump to use the full 32-bit inode generation number.
A change to part of the dump format (direnthdr_t) was required, so the
dump format version has been bumped to 3. xfsdump also required changes to
its inode-to-generation cache. This map is not persistent though, so no
compatibility or version changes were required there.

xfsrestore has been changed to support the old and new dump formats. This
required a change to its persistent data structures (for cumulative
restores), so that version number was bumped as well.

When restoring a series of incremental/resumed dumps, if the oldest
restore used 12-bit generation numbers then they will be used throughout
the restore series to avoid mass confusion. It's recommended that users do
a level 0 backup of their filesystems with the new xfsdump so that future
incremental restores can take advantage of the full 32-bit generation
number.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/arch_xlate.c    |   54 +++++++++++++++++++++++++++++++++++---
 common/arch_xlate.h    |    5 +++
 common/content_inode.h |   20 ++++++++++++--
 common/global.c        |    1 +
 common/global.h        |    7 +++--
 dump/content.c         |   11 +++----
 dump/inomap.c          |   45 ++++++-------------------------
 dump/inomap.h          |    2 +-
 restore/content.c      |   27 +++++++++++++++---
 restore/tree.c         |   68 ++++++++++++++++++++++++++++++++++++-----------
 restore/tree.h         |    7 +++--
 11 files changed, 170 insertions(+), 77 deletions(-)

diff --git a/common/arch_xlate.c b/common/arch_xlate.c
index 1c7e880..c156313 100644
--- a/common/arch_xlate.c
+++ b/common/arch_xlate.c
@@ -438,8 +438,8 @@ xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir)
 
 	IXLATE(dh1, dh2, dh_ino);
 	IXLATE(dh1, dh2, dh_gen);
-	IXLATE(dh1, dh2, dh_sz);
 	IXLATE(dh1, dh2, dh_checksum);
+	IXLATE(dh1, dh2, dh_sz);
 
 	if (dir < 0) {
 		ptr1 = dh2;
@@ -450,7 +450,53 @@ xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir)
 
 	mlog(MLOG_NITTY, "xlate_direnthdr: pre-xlate\n"
 	     "\tdh_ino %llu\n"
-	     "\tdh_gen %d\n"
+	     "\tdh_gen %u\n"
+	     "\tdh_checksum %d\n"
+	     "\tdh_sz %d\n"
+	     "\tdh_name %.8s\n",
+	     ptr1->dh_ino,
+	     ptr1->dh_gen,
+	     ptr1->dh_checksum,
+	     ptr1->dh_sz,
+	     ptr1->dh_name );
+
+	mlog(MLOG_NITTY, "xlate_direnthdr: post-xlate\n"
+	     "\tdh_ino %llu\n"
+	     "\tdh_gen %u\n"
+	     "\tdh_checksum %d\n"
+	     "\tdh_sz %d\n"
+	     "\tdh_name %.8s\n",
+	     ptr2->dh_ino,
+	     ptr2->dh_gen,
+	     ptr2->dh_checksum,
+	     ptr2->dh_sz,
+	     ptr2->dh_name );
+}
+
+/*
+ * xlate_direnthdr_v1 - endian convert struct direnthdr_v1
+ */
+void
+xlate_direnthdr_v1(direnthdr_v1_t *dh1, direnthdr_v1_t *dh2, int dir)
+{
+	direnthdr_v1_t *ptr1 = dh1;
+	direnthdr_v1_t *ptr2 = dh2;
+
+	IXLATE(dh1, dh2, dh_ino);
+	IXLATE(dh1, dh2, dh_gen);
+	IXLATE(dh1, dh2, dh_sz);
+	IXLATE(dh1, dh2, dh_checksum);
+
+	if (dir < 0) {
+		ptr1 = dh2;
+		ptr2 = dh1;
+	}
+
+	BXLATE(dh_name);
+
+	mlog(MLOG_NITTY, "xlate_direnthdr_v1: pre-xlate\n"
+	     "\tdh_ino %llu\n"
+	     "\tdh_gen %u\n"
 	     "\tdh_sz %d\n"
 	     "\tdh_checksum %d\n"
 	     "\tdh_name %.8s\n",
@@ -460,9 +506,9 @@ xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir)
 	     ptr1->dh_checksum,
 	     ptr1->dh_name );
 
-	mlog(MLOG_NITTY, "xlate_direnthdr: post-xlate\n"
+	mlog(MLOG_NITTY, "xlate_direnthdr_v1: post-xlate\n"
 	     "\tdh_ino %llu\n"
-	     "\tdh_gen %d\n"
+	     "\tdh_gen %u\n"
 	     "\tdh_sz %d\n"
 	     "\tdh_checksum %d\n"
 	     "\tdh_name %.8s\n",
diff --git a/common/arch_xlate.h b/common/arch_xlate.h
index 3ad3c97..35333c6 100644
--- a/common/arch_xlate.h
+++ b/common/arch_xlate.h
@@ -98,6 +98,11 @@ void xlate_extenthdr(extenthdr_t *eh1, extenthdr_t *eh2, int dir);
 void xlate_direnthdr(direnthdr_t *dh1, direnthdr_t *dh2, int dir);
 
 /*
+ * xlate_direnthdr_v1 - endian convert struct direnthdr_v1
+ */
+void xlate_direnthdr_v1(direnthdr_v1_t *dh1, direnthdr_v1_t *dh2, int dir);
+
+/*
  * xlate_extattrhdr - endian convert struct extattrhdr
  */
 void xlate_extattrhdr(extattrhdr_t *eh1, extattrhdr_t *eh2, int dir);
diff --git a/common/content_inode.h b/common/content_inode.h
index 67c4f6d..a25b66e 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -284,26 +284,40 @@ typedef struct extenthdr extenthdr_t;
  * a sequence of directory entries is always terminated with a null direnthdr_t.
  * this is detected by looking for a zero ino.
  */
+typedef u_int32_t gen_t;
+
 #define DIRENTHDR_ALIGN	8
 
 #define DIRENTHDR_SZ	24
 
 struct direnthdr {
 	xfs_ino_t dh_ino;
+	gen_t dh_gen;
+	u_int32_t dh_checksum;
+	u_int16_t dh_sz; /* overall size of record */
+	char dh_name[ 6 ];
+};
+
+typedef struct direnthdr direnthdr_t;
+
+/* the old direnthdr truncated the inode generation number
+ * to the low 12 bits.
+ */
+
+struct direnthdr_v1 {
+	xfs_ino_t dh_ino;
 	u_int16_t dh_gen; /* generation count & DENTGENMASK of ref'ed inode */
 	u_int16_t dh_sz; /* overall size of record */
 	u_int32_t dh_checksum;
 	char dh_name[ 8 ];
 };
 
-typedef struct direnthdr direnthdr_t;
+typedef struct direnthdr_v1 direnthdr_v1_t;
 
 /* truncated generation count
  */
 #define DENTGENSZ		12	/* leave 4 bits for future flags */
 #define DENTGENMASK		(( 1 << DENTGENSZ ) - 1 )
-typedef u_int16_t gen_t;
-#define GEN_NULL		( ( gen_t )UINT16MAX )
 #define BIGGEN2GEN( bg )	( ( gen_t )( bg & DENTGENMASK ))
 
 
diff --git a/common/global.c b/common/global.c
index 737b731..baa13fe 100644
--- a/common/global.c
+++ b/common/global.c
@@ -276,6 +276,7 @@ global_version_check( u_int32_t version )
 		case GLOBAL_HDR_VERSION_0:
 		case GLOBAL_HDR_VERSION_1:
 		case GLOBAL_HDR_VERSION_2:
+		case GLOBAL_HDR_VERSION_3:
 			return BOOL_TRUE;
 		default:
 			return BOOL_FALSE;
diff --git a/common/global.h b/common/global.h
index ea2b732..6556a68 100644
--- a/common/global.h
+++ b/common/global.h
@@ -27,13 +27,14 @@
 #define GLOBAL_HDR_VERSION_0	0
 #define GLOBAL_HDR_VERSION_1	1
 #define GLOBAL_HDR_VERSION_2	2
-	/* version 2 adds encoding of holes and a change to on-tape inventory format.
+#define GLOBAL_HDR_VERSION_3	3
+	/* version 3 uses the full 32-bit inode generation number in direnthdr_t.
+	 * version 2 adds encoding of holes and a change to on-tape inventory format.
 	 * version 1 adds extended file attribute dumping.
 	 * version 0 xfsrestore can't handle media produced
 	 * by version 1 xfsdump. 
 	 */
-#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_2
-#define GLOBAL_HDR_VERSION_PREV	1
+#define GLOBAL_HDR_VERSION	GLOBAL_HDR_VERSION_3
 
 #define GLOBAL_HDR_STRING_SZ	0x100
 #define GLOBAL_HDR_TIME_SZ	4
diff --git a/dump/content.c b/dump/content.c
index 3a7f508..20d6497 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -290,7 +290,7 @@ static rv_t dump_dirent( drive_t *drivep,
 			 context_t *contextp,
 			 xfs_bstat_t *,
 			 xfs_ino_t,
-			 u_int32_t,
+			 gen_t,
 			 char *,
 			 size_t );
 static rv_t init_extent_group_context( jdm_fshandle_t *,
@@ -2902,7 +2902,7 @@ dump_dir( ix_t strmix,
 	struct dirent *gdp = ( struct dirent *)contextp->cc_getdentsbufp;
 	size_t gdsz = contextp->cc_getdentsbufsz;
 	intgen_t gdcnt;
-	u_int32_t gen;
+	gen_t gen;
 	rv_t rv;
 
 	/* no way this can be non-dir, but check anyway
@@ -3073,8 +3073,7 @@ dump_dir( ix_t strmix,
 			/* lookup the gen number in the ino-to-gen map.
 			 * if it's not there, we have to get it the slow way.
 			 */
-			gen = inomap_get_gen( NULL, p->d_ino );
-			if (gen == GEN_NULL) {
+			if ( inomap_get_gen( NULL, p->d_ino, &gen) ) {
 				xfs_bstat_t statbuf;
 				intgen_t scrval;
 				
@@ -5045,7 +5044,7 @@ dump_dirent( drive_t *drivep,
 	     context_t *contextp,
 	     xfs_bstat_t *statp,
 	     xfs_ino_t ino,
-	     u_int32_t gen,
+	     gen_t gen,
 	     char *name,
 	     size_t namelen )
 {
@@ -5083,8 +5082,8 @@ dump_dirent( drive_t *drivep,
 
 	memset( ( void * )dhdrp, 0, sz );
 	dhdrp->dh_ino = ino;
+	dhdrp->dh_gen = gen;
 	dhdrp->dh_sz = ( u_int16_t )sz;
-	dhdrp->dh_gen = ( u_int16_t )( gen & DENTGENMASK );
 
 	if ( name ) {
 		strcpy( dhdrp->dh_name, name );
diff --git a/dump/inomap.c b/dump/inomap.c
index aa4f59d..9b385ec 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -940,18 +940,11 @@ cb_startpt( void *arg1,
 /* map context and operators
  */
 
-/* define structure for ino to gen mapping. Allocate 12 bits for the gen
- * instead of the 32-bit gen that XFS uses, as xfsdump currently truncates
- * the gen to 12 bits.
+/* define structure for ino to gen mapping.
  */
-#if DENTGENSZ != 12
-#error DENTGENSZ has changed. i2gseg_t and its users must be updated.
-#endif
-
 struct i2gseg {
 	u_int64_t s_valid;
-	u_char_t s_lower[ INOPERSEG ];
-	u_char_t s_upper[ INOPERSEG / 2 ];
+	gen_t s_gen[ INOPERSEG ];
 };
 typedef struct i2gseg i2gseg_t;
 
@@ -1382,51 +1375,31 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 
 	relino = ino - segp->base;
 	i2gsegp->s_valid |= (u_int64_t)1 << relino;
-	i2gsegp->s_lower[ relino ] = ( u_char_t )( gen & 0xff );
-	if ( relino & 1 ) {
-		/* odd, goes in high nibble */
-		i2gsegp->s_upper[relino / 2] &= ( u_char_t )( 0x0f );
-		i2gsegp->s_upper[relino / 2] |=
-			( u_char_t )( ( gen >> 4 ) & 0xf0 );
-	} else {
-		/* even, goes in low nibble */
-		i2gsegp->s_upper[ relino / 2 ] &= ( u_char_t )( 0xf0 );
-		i2gsegp->s_upper[ relino / 2 ] |=
-			( u_char_t )( ( gen >> 8 ) & 0x0f );
-	}
+	i2gsegp->s_gen[relino] = gen;
 }
 
-gen_t
-inomap_get_gen( void *contextp, xfs_ino_t ino )
+intgen_t
+inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 {
 	seg_addr_t *addrp;
 	seg_addr_t addr;
 	seg_t *segp;
 	i2gseg_t *i2gsegp;
 	xfs_ino_t relino;
-	gen_t gen;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
 	if ( !inomap_find_seg( addrp, ino ) )
-		return GEN_NULL;
+		return 1;
 
 	segp = inomap_addr2seg( addrp );
 	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
 
 	relino = ino - segp->base;
 	if ( ! (i2gsegp->s_valid & ((u_int64_t)1 << relino)) )
-		return GEN_NULL;
-
-	gen = i2gsegp->s_lower[relino];
-	if (relino & 1) {
-		/* odd, rest of gen in high nibble */
-		gen |= ( (gen_t)i2gsegp->s_upper[relino / 2] & 0xf0 ) << 4;
-	} else {
-		/* even, rest of gen in low nibble */
-		gen |= ( (gen_t)i2gsegp->s_upper[relino / 2] & 0x0f ) << 8;
-	}
+		return 1;
 
-	return gen;
+	*gen = i2gsegp->s_gen[relino];
+	return 0;
 }
 
 void
diff --git a/dump/inomap.h b/dump/inomap.h
index 16f2efb..7d1db1f 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -132,7 +132,7 @@ extern void *inomap_alloc_context( void );
 extern void inomap_reset_context( void *contextp );
 extern void inomap_free_context( void *contextp );
 extern intgen_t inomap_get_state( void *contextp, xfs_ino_t ino );
-extern gen_t inomap_get_gen( void *contextp, xfs_ino_t ino );
+extern intgen_t inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen );
 
 
 /* generators returning the next dir or non-dir ino selected in this dump.
diff --git a/restore/content.c b/restore/content.c
index a9e0b20..b2a3071 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -73,8 +73,10 @@
 #define HOUSEKEEPING_MAGIC	0x686b6d61
 	/* "hkma" - see the housekeeping_magic field of pers_t below.
 	 */
-#define HOUSEKEEPING_VERSION	1
+#define HOUSEKEEPING_VERSION	2
 	/* see the housekeeping_version field of pers_t below.
+	 * version 2 changed the size of a gen_t, which caused node_t
+	 * to change in size. also p_truncategenpr was added to treepers_t.
 	 */
 
 #define WRITE_TRIES_MAX	3
@@ -2328,7 +2330,8 @@ content_stream_restore( ix_t thrdix )
 					tranp->t_vmsz,
 					fullpr,
 					persp->a.restoredmpr,
-					persp->a.dstdirisxfspr );
+					persp->a.dstdirisxfspr,
+					grhdrp->gh_version );
 			if ( ! ok ) {
 				Media_end( Mediap );
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
@@ -3071,7 +3074,7 @@ applydirdump( drive_t *drivep,
 				 */
 				rv = tree_addent( dirh,
 					     dhdrp->dh_ino,
-					     ( size_t )dhdrp->dh_gen,
+					     dhdrp->dh_gen,
 					     dhdrp->dh_name,
 					     namelen );
 				if ( rv != RV_OK ) {
@@ -8109,11 +8112,13 @@ read_dirent( drive_t *drivep,
 	     size_t direntbufsz,
 	     bool_t dhcs )
 {
+	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
 	intgen_t rval;
 	direnthdr_t tmpdh;
+	char *namep;    // beginning of name following the direnthdr_t
 
 	/* read the head of the dirent
 	 */
@@ -8124,7 +8129,19 @@ read_dirent( drive_t *drivep,
 			  ( rrbfp_t )
 			  dop->do_return_read_buf,
 			  &rval );
-	xlate_direnthdr(&tmpdh, dhdrp, 1);
+	if ( grhdrp->gh_version >= GLOBAL_HDR_VERSION_3 ) {
+		xlate_direnthdr(&tmpdh, dhdrp, 1);
+		namep = dhdrp->dh_name + sizeof(dhdrp->dh_name);
+	} else {
+		direnthdr_v1_t dhdr_v1;
+		xlate_direnthdr_v1((direnthdr_v1_t *)&tmpdh, &dhdr_v1, 1);
+		dhdrp->dh_ino = dhdr_v1.dh_ino;
+		dhdrp->dh_gen = BIGGEN2GEN(dhdr_v1.dh_gen);
+		dhdrp->dh_checksum = dhdr_v1.dh_checksum;
+		dhdrp->dh_sz = dhdr_v1.dh_sz;
+		memcpy(dhdrp->dh_name, dhdr_v1.dh_name, sizeof(dhdr_v1.dh_name));
+		namep = dhdrp->dh_name + sizeof(dhdr_v1.dh_name);
+	}
 
 	switch( rval ) {
 	case 0:
@@ -8177,7 +8194,7 @@ read_dirent( drive_t *drivep,
 	ASSERT( ! ( ( size_t )dhdrp->dh_sz & ( DIRENTHDR_ALIGN - 1 )));
 	if ( ( size_t )dhdrp->dh_sz > sizeof( direnthdr_t )) {
 		size_t remsz = ( size_t )dhdrp->dh_sz - sizeof( direnthdr_t );
-		nread = read_buf( ( char * )( dhdrp + 1 ),
+		nread = read_buf( namep,
 				  remsz,
 				  ( void * )drivep,
 				  ( rfp_t )dop->do_read,
diff --git a/restore/tree.c b/restore/tree.c
index 9e4e83c..afe7042 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -102,6 +102,10 @@ struct treePersStorage {
 	bool_t p_restoredmpr;
 		/* restore DMI event settings
 		 */
+	bool_t p_truncategenpr;
+		/* truncate inode generation number (for compatibility
+		 * with xfsdump format 2 and earlier)
+		 */
 };
 
 typedef struct treePersStorage treepers_t;
@@ -163,7 +167,7 @@ typedef struct tran tran_t;
 
 /* node structure. each node represents a directory entry
  */
-#define NODESZ	48
+#define NODESZ	56
 
 struct node {
 	xfs_ino_t n_ino;	/* 8  8 ino */
@@ -175,9 +179,10 @@ struct node {
 	nh_t n_sibprevh;	/* 4 36 prev sibling list - dbl link list */
 	nh_t n_cldh;		/* 4 40 children list */
 	nh_t n_lnkh;		/* 4 44 hard link list */
-	gen_t n_gen;		/* 2 46 generation count mod 0x10000 */
-	u_char_t n_flags;	/* 1 47 action and state flags */
-	u_char_t n_nodehkbyte;	/* 1 48 given to node abstraction */
+	gen_t n_gen;		/* 4 48 generation count mod 0x10000 */
+	u_char_t n_flags;	/* 1 49 action and state flags */
+	u_char_t n_nodehkbyte;	/* 1 50 given to node abstraction */
+	char n_pad[6];		/* 6 56 */
 };
 
 typedef struct node node_t;
@@ -335,7 +340,8 @@ tree_init( char *hkdir,
 	   size64_t vmsz,
 	   bool_t fullpr,
 	   bool_t restoredmpr,
-	   bool_t dstdirisxfspr )
+	   bool_t dstdirisxfspr,
+	   u_int32_t dumpformat )
 {
 	off64_t nodeoff;
 	char *perspath;
@@ -496,6 +502,17 @@ tree_init( char *hkdir,
 	 */
 	persp->p_restoredmpr = restoredmpr;
 
+	/* record if truncated generation numbers are required
+	 */
+	if ( dumpformat < GLOBAL_HDR_VERSION_3 ) {
+		persp->p_truncategenpr = BOOL_TRUE;
+		mlog( MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
+		      "dump format version %u used truncated inode generation numbers\n"),
+			dumpformat );
+	} else {
+		persp->p_truncategenpr = BOOL_FALSE;
+	}
+
 	return BOOL_TRUE;
 }
 
@@ -596,6 +613,15 @@ tree_sync( char *hkdir,
 	 */
 	persp->p_fullpr = fullpr;
 
+	/* regardless of the format of this dump, if the previously applied
+	 * dump used truncated generation numbers, then we need to as well.
+	 */
+	if ( persp->p_truncategenpr ) {
+		mlog( MLOG_NORMAL | MLOG_DEBUG | MLOG_TREE, _(
+		      "using truncated inode generation numbers for "
+		      "compatibility with previously applied restore\n") );
+	}
+
 	/* rsynchronize with the hash abstraction. it will map more of the
 	 * persistent state file.
 	 */
@@ -682,10 +708,13 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 {
 	nh_t hardh;
 	xfs_ino_t ino = fhdrp->fh_stat.bs_ino;
-	u_int32_t biggen = fhdrp->fh_stat.bs_gen;
-	gen_t gen = BIGGEN2GEN( biggen );
+	gen_t gen = fhdrp->fh_stat.bs_gen;
 	dah_t dah;
 
+	if ( persp->p_truncategenpr ) {
+		gen = BIGGEN2GEN( gen );
+	}
+
 	/* sanity check - orphino is supposed to be an unused ino!
 	 */
 	ASSERT( ino != orphino );
@@ -708,7 +737,7 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 			      "upgrading to dir\n",
 			      ino,
 			      gen,
-			      biggen );
+			      fhdrp->fh_stat.bs_gen );
 			if ( ! tranp->t_toconlypr ) {
 				ASSERT( hardp->n_dah == DAH_NULL );
 				hardp->n_dah = dirattr_add( fhdrp );
@@ -721,7 +750,7 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 			      "updating\n",
 			      ino,
 			      gen,
-			      biggen );
+			      fhdrp->fh_stat.bs_gen );
 			hardp->n_dah = dirattr_add( fhdrp );
 		} else {
 			/* case 3: already has dirattr; must be restart
@@ -731,7 +760,7 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 			      "retaining\n",
 			      ino,
 			      gen,
-			      biggen );
+			      fhdrp->fh_stat.bs_gen );
 		}
 		hardp->n_flags |= NF_ISDIR;
 		hardp->n_flags |= NF_DUMPEDDIR;
@@ -745,7 +774,7 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 		      "new\n",
 		      ino,
 		      gen,
-		      biggen );
+		      fhdrp->fh_stat.bs_gen );
 		if ( ! tranp->t_toconlypr ) {
 			dah = dirattr_add( fhdrp );
 		} else {
@@ -767,11 +796,14 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
 }
 
 rv_t
-tree_addent( nh_t parh, xfs_ino_t ino, size_t g, char *name, size_t namelen )
+tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
 {
-	gen_t gen = BIGGEN2GEN( g );
 	nh_t hardh;
 
+	if ( persp->p_truncategenpr ) {
+		gen = BIGGEN2GEN( gen );
+	}
+
 	/* sanity check - orphino is supposed to be an unused ino!
 	 */
 	ASSERT( ino != orphino );
@@ -1677,7 +1709,7 @@ rename_dirs( nh_t cldh,
  */
 rv_t
 tree_cb_links( xfs_ino_t ino,
-	       u_int32_t biggen,
+	       gen_t gen,
 	       int32_t ctime,
 	       int32_t mtime,
 	       bool_t ( * funcp )( void *contextp,
@@ -1688,13 +1720,16 @@ tree_cb_links( xfs_ino_t ino,
 	       char *path1,
 	       char *path2 )
 {
-	gen_t gen = BIGGEN2GEN( biggen );
 	nh_t hardh;
 	nh_t nh;
 	char *path;
 	bool_t ok;
 	int  rval;
 
+	if ( persp->p_truncategenpr ) {
+		gen = BIGGEN2GEN( gen );
+	}
+
 	/* find the hardhead
 	 */
 	hardh = link_hardh( ino, gen );
@@ -1887,7 +1922,7 @@ tree_cb_links( xfs_ino_t ino,
 			      "ino %llu gen %u not referenced: "
 			      "placing in orphanage\n"),
 			      ino,
-			      biggen );
+			      gen );
 			nh = Node_alloc( ino,
 					 gen,
 					 NRH_NULL,
@@ -3357,6 +3392,7 @@ Node_alloc( xfs_ino_t ino, gen_t gen, nrh_t nrh, dah_t dah, size_t flags )
 	np->n_lnkh = NH_NULL;
 	np->n_gen = gen;
 	np->n_flags = ( u_char_t )flags;
+	memset(np->n_pad, 0, sizeof(np->n_pad));
 	Node_unmap( nh, &np  );
 	return nh;
 }
diff --git a/restore/tree.h b/restore/tree.h
index 93621c7..29d1033 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -32,7 +32,8 @@ extern bool_t tree_init( char *hkdir,
 			 size64_t vmsz,
 			 bool_t fullpr,
 			 bool_t restoredmpr,
-			 bool_t dstdirisxfspr );
+			 bool_t dstdirisxfspr,
+			 u_int32_t dumpformat );
 
 /* tree_sync - synchronizes with an existing tree abstraction
  */
@@ -53,7 +54,7 @@ extern nh_t tree_begindir( filehdr_t *fhdrp, dah_t *dahp );
  */
 extern rv_t tree_addent( nh_t dirh,
 			 xfs_ino_t ino,
-			 size_t gen,
+			 gen_t gen,
 			 char *name,
 			 size_t namelen );
 
@@ -84,7 +85,7 @@ extern bool_t tree_subtree_parse( bool_t sensepr, char *path );
 extern bool_t tree_post( char *path1, char *path2 );
 
 extern rv_t tree_cb_links( xfs_ino_t ino,
-			   u_int32_t biggen,
+			   gen_t gen,
 			   int32_t ctime,
 			   int32_t mtime,
 			   bool_t ( * funcp )( void *contextp,
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
