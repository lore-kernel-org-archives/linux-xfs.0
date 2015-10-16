Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3CFBA7F5A
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C8C630405F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IJ69ofcK1ZuoMArI for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:22 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019t-Ta
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-000065-Sl
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] cleanup: kill u_int*_t types
Date: Fri, 16 Oct 2015 12:44:57 +1100
Message-Id: <1444959901-31319-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1444959901-31319-1-git-send-email-david@fromorbit.com>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

They are the same as uint*_t type defined in <stdint.h>, so seek and
destroy these to reduce the type proliferation issues that this code
has.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/content_inode.h  | 78 ++++++++++++++++++++++++-------------------------
 common/drive.h          |  4 +--
 common/drive_minrmt.c   | 56 +++++++++++++++++------------------
 common/drive_scsitape.c | 40 ++++++++++++-------------
 common/global.c         | 20 ++++++-------
 common/global.h         |  8 ++---
 common/hsmapi.c         | 10 +++----
 common/hsmapi.h         |  4 +--
 common/inventory.c      |  4 +--
 common/inventory.h      |  4 +--
 common/main.c           | 10 +++----
 common/media.h          | 10 +++----
 common/rec_hdr.h        |  4 +--
 common/types.h          | 17 +++++++----
 dump/content.c          | 66 ++++++++++++++++++++---------------------
 dump/inomap.c           | 30 +++++++++----------
 dump/inomap.h           |  8 ++---
 inventory/inv_api.c     |  6 ++--
 inventory/inv_core.c    |  4 +--
 inventory/inv_idx.c     | 18 ++++++------
 inventory/inv_mgr.c     |  4 +--
 inventory/inv_priv.h    | 32 ++++++++++----------
 inventory/inv_stobj.c   | 46 ++++++++++++++---------------
 inventory/inventory.h   | 12 ++++----
 inventory/testmain.c    |  2 +-
 invutil/invidx.c        |  6 ++--
 restore/content.c       | 20 ++++++-------
 restore/dirattr.c       | 54 +++++++++++++++++-----------------
 restore/dirattr.h       | 12 ++++----
 restore/inomap.c        | 24 +++++++--------
 restore/inomap.h        |  6 ++--
 restore/namreg.c        |  2 +-
 restore/namreg.h        |  2 +-
 restore/tree.c          |  6 ++--
 restore/tree.h          |  4 +--
 35 files changed, 319 insertions(+), 314 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index 9013ca4..a69a9a0 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -88,19 +88,19 @@ struct content_inode_hdr {
 		/* starting point of media file contents */
 	startpt_t cih_endpt;				/*  18  70 */
 		/* starting point of next stream */
-	u_int64_t cih_inomap_hnkcnt;			/*   8  78 */
+	uint64_t cih_inomap_hnkcnt;			/*   8  78 */
 
-	u_int64_t cih_inomap_segcnt;			/*   8  80 */
+	uint64_t cih_inomap_segcnt;			/*   8  80 */
 
-	u_int64_t cih_inomap_dircnt;			/*   8  88 */
+	uint64_t cih_inomap_dircnt;			/*   8  88 */
 
-	u_int64_t cih_inomap_nondircnt;			/*   8  90 */
+	uint64_t cih_inomap_nondircnt;			/*   8  90 */
 
 	xfs_ino_t cih_inomap_firstino;			/*   8  98 */
 
 	xfs_ino_t cih_inomap_lastino;			/*   8  a0 */
 
-	u_int64_t cih_inomap_datasz;			/*   8  a8 */
+	uint64_t cih_inomap_datasz;			/*   8  a8 */
 		/* bytes of non-metadata dumped */
 	char cih_pad2[ CONTENT_INODE_HDR_SZ - 0xa8 ];	/*  18  c0 */
 		/* padding */
@@ -158,27 +158,27 @@ typedef struct timestruct timestruct_t;
 
 struct bstat {				/*		     bytes accum */
 	xfs_ino_t	bs_ino;		/* inode number		 8     8 */
-	u_int32_t	bs_mode;	/* type and mode	 4     c */
-	u_int32_t	bs_nlink;	/* number of links	 4    10 */
+	uint32_t	bs_mode;	/* type and mode	 4     c */
+	uint32_t	bs_nlink;	/* number of links	 4    10 */
 	int32_t		bs_uid;		/* user id		 4    14 */
 	int32_t		bs_gid;		/* group id		 4    18 */
-	u_int32_t	bs_rdev;	/* device value		 4    1c */
+	uint32_t	bs_rdev;	/* device value		 4    1c */
 	int32_t		bs_blksize;	/* block size		 4    20 */
 	off64_t		bs_size;	/* file size		 8    28 */
 	timestruct_t	bs_atime;	/* access time		 8    30 */
 	timestruct_t	bs_mtime;	/* modify time		 8    38 */
 	timestruct_t	bs_ctime;	/* inode change time	 8    40 */
 	int64_t		bs_blocks;	/* number of blocks	 8    48 */
-	u_int32_t	bs_xflags;	/* extended flags	 4    4c */
+	uint32_t	bs_xflags;	/* extended flags	 4    4c */
 	int32_t		bs_extsize;	/* extent size		 4    50 */
 	int32_t		bs_extents;	/* number of extents	 4    54 */
-	u_int32_t	bs_gen;		/* generation count	 4    58 */
-	u_int16_t	bs_projid_lo;	/* low 16 of project id	 2    5a */
-	u_int16_t	bs_forkoff;	/* inode fork offset	 2    5c */
-	u_int16_t	bs_projid_hi;	/* hi 16 of project id	 2    5e */
+	uint32_t	bs_gen;		/* generation count	 4    58 */
+	uint16_t	bs_projid_lo;	/* low 16 of project id	 2    5a */
+	uint16_t	bs_forkoff;	/* inode fork offset	 2    5c */
+	uint16_t	bs_projid_hi;	/* hi 16 of project id	 2    5e */
 	char		bs_pad[ 10 ];	/* for expansion	 e    68 */
-	u_int32_t	bs_dmevmask;	/* DMI event mask        4    6c */
-	u_int16_t	bs_dmstate;	/* DMI state info        2    6e */
+	uint32_t	bs_dmevmask;	/* DMI event mask        4    6c */
+	uint16_t	bs_dmstate;	/* DMI state info        2    6e */
 	char		bs_pad1[ 18 ];	/* for expansion        12    80 */
 					/* NOTE: old dumps didn't always
 					 * zero first 2 bytes of bs_pad1 */
@@ -216,12 +216,12 @@ bstat_projid(struct bstat *bs)
 struct filehdr {
 	int64_t fh_offset;
 	int32_t fh_flags;
-	u_int32_t fh_checksum;
+	uint32_t fh_checksum;
 	bstat_t fh_stat;
 	char fh_pad2[ FILEHDR_SZ
 		      - sizeof( int64_t )
 		      - sizeof( int32_t )
-		      - sizeof( u_int32_t )
+		      - sizeof( uint32_t )
 		      - sizeof( bstat_t ) ];
 };
 
@@ -260,7 +260,7 @@ struct extenthdr {
 	off64_t eh_offset;
 	int32_t eh_type;
 	int32_t eh_flags;
-	u_int32_t eh_checksum;
+	uint32_t eh_checksum;
 	char eh_pad[ 4 ];
 };
 
@@ -298,7 +298,7 @@ typedef struct extenthdr extenthdr_t;
  * a sequence of directory entries is always terminated with a null direnthdr_t.
  * this is detected by looking for a zero ino.
  */
-typedef u_int32_t gen_t;
+typedef uint32_t gen_t;
 
 #define DIRENTHDR_ALIGN	8
 
@@ -307,8 +307,8 @@ typedef u_int32_t gen_t;
 struct direnthdr {
 	xfs_ino_t dh_ino;
 	gen_t dh_gen;
-	u_int32_t dh_checksum;
-	u_int16_t dh_sz; /* overall size of record */
+	uint32_t dh_checksum;
+	uint16_t dh_sz; /* overall size of record */
 	char dh_name[ 6 ];
 };
 
@@ -320,9 +320,9 @@ typedef struct direnthdr direnthdr_t;
 
 struct direnthdr_v1 {
 	xfs_ino_t dh_ino;
-	u_int16_t dh_gen; /* generation count & DENTGENMASK of ref'ed inode */
-	u_int16_t dh_sz; /* overall size of record */
-	u_int32_t dh_checksum;
+	uint16_t dh_gen; /* generation count & DENTGENMASK of ref'ed inode */
+	uint16_t dh_sz; /* overall size of record */
+	uint32_t dh_checksum;
 	char dh_name[ 8 ];
 };
 
@@ -353,11 +353,11 @@ typedef struct direnthdr_v1 direnthdr_v1_t;
 #define EXTATTRHDR_ALIGN	8
 
 struct extattrhdr {
-	u_int32_t ah_sz; /* overall size of extended attribute record */
-	u_int16_t ah_valoff; /* byte offset within record of value */
-	u_int16_t ah_flags; /* see EXTATTRHDR_FLAGS_... below */
-	u_int32_t ah_valsz; /* size of value */
-	u_int32_t ah_checksum; /* hdr checksum */
+	uint32_t ah_sz; /* overall size of extended attribute record */
+	uint16_t ah_valoff; /* byte offset within record of value */
+	uint16_t ah_flags; /* see EXTATTRHDR_FLAGS_... below */
+	uint32_t ah_valsz; /* size of value */
+	uint32_t ah_checksum; /* hdr checksum */
 };
 
 typedef struct extattrhdr extattrhdr_t;
@@ -381,15 +381,15 @@ typedef struct extattrhdr extattrhdr_t;
 	 */
 
 /* Routines for calculating and validating checksums on xfsdump headers.
- * The header length must be an integral number of u_int32_t's.
+ * The header length must be an integral number of uint32_t's.
  */
-static inline u_int32_t
+static inline uint32_t
 calc_checksum(void *bufp, size_t len)
 {
-	u_int32_t sum = 0;
-	u_int32_t *sump = bufp;
-	u_int32_t *endp = sump + len / sizeof(u_int32_t);
-	assert(len % sizeof(u_int32_t) == 0);
+	uint32_t sum = 0;
+	uint32_t *sump = bufp;
+	uint32_t *endp = sump + len / sizeof(uint32_t);
+	assert(len % sizeof(uint32_t) == 0);
 	while (sump < endp)
 		sum += *sump++;
 	return ~sum + 1;
@@ -398,10 +398,10 @@ calc_checksum(void *bufp, size_t len)
 static inline bool_t
 is_checksum_valid(void *bufp, size_t len)
 {
-	u_int32_t sum = 0;
-	u_int32_t *sump = bufp;
-	u_int32_t *endp = sump + len / sizeof(u_int32_t);
-	assert(len % sizeof(u_int32_t) == 0);
+	uint32_t sum = 0;
+	uint32_t *sump = bufp;
+	uint32_t *endp = sump + len / sizeof(uint32_t);
+	assert(len % sizeof(uint32_t) == 0);
 	while (sump < endp)
 		sum += *sump++;
 	return sum == 0 ? BOOL_TRUE : BOOL_FALSE;
diff --git a/common/drive.h b/common/drive.h
index b0efa4c..89b143e 100644
--- a/common/drive.h
+++ b/common/drive.h
@@ -102,9 +102,9 @@
 #define DRIVE_HDR_SZ		sizeofmember( global_hdr_t, gh_upper )
 
 struct drive_hdr {
-	u_int32_t dh_drivecnt;				/*   4    4 */
+	uint32_t dh_drivecnt;				/*   4    4 */
 		/* number of drives used to dump the fs */
-	u_int32_t dh_driveix;				/*   4    8 */
+	uint32_t dh_driveix;				/*   4    8 */
 		/* 0-based index of the drive used to dump this stream */
 	int32_t dh_strategyid;				/*   4    c */
 		/* ID of the drive strategy used to produce this dump */
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 21eb09e..848d794 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -246,7 +246,7 @@ typedef struct drive_context drive_context_t;
 
 extern void usage( void );
 #ifdef DUMP
-extern u_int64_t hdr_mfilesz;
+extern uint64_t hdr_mfilesz;
 #endif /* DUMP */
 
 /* remote tape protocol declarations (should be a system header file)
@@ -329,10 +329,10 @@ static int validate_media_file_hdr( drive_t *drivep );
 static void calc_max_lost( drive_t *drivep );
 static void display_ring_metrics( drive_t *drivep, int mlog_flags );
 #ifdef CLRMTAUD
-static u_int32_t rewind_and_verify( drive_t *drivep );
-static u_int32_t erase_and_verify( drive_t *drivep ); 
-static u_int32_t bsf_and_verify( drive_t *drivep );
-static u_int32_t fsf_and_verify( drive_t *drivep );
+static uint32_t rewind_and_verify( drive_t *drivep );
+static uint32_t erase_and_verify( drive_t *drivep ); 
+static uint32_t bsf_and_verify( drive_t *drivep );
+static uint32_t fsf_and_verify( drive_t *drivep );
 #else /* CLRMTAUD */
 static short rewind_and_verify( drive_t *drivep );
 static short erase_and_verify( drive_t *drivep ); 
@@ -399,7 +399,7 @@ static drive_ops_t drive_ops = {
 	do_quit,		/* do_quit */
 };
 
-static u_int32_t cmdlineblksize = 0;
+static uint32_t cmdlineblksize = 0;
 
 /* definition of locally defined global functions ****************************/
 
@@ -440,7 +440,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 					c );
 				return -10;
 		    	    }
-			    cmdlineblksize = ( u_int32_t )atoi( optarg );
+			    cmdlineblksize = ( uint32_t )atoi( optarg );
 		            errno = 0;
 		            fd = open( drivep->d_pathname, O_RDONLY );
 		            if ( fd < 0 ) 
@@ -1003,13 +1003,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	 */
 	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
 	if ( contextp->dc_recp ) {
-		u_int32_t recoff;
+		uint32_t recoff;
 #ifdef DEBUG
 		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
 
 		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( u_int32_t )( contextp->dc_nextp
+		recoff = ( uint32_t )( contextp->dc_nextp
 					-
 					contextp->dc_recp );
 		assert( recoff <= tape_recsz );
@@ -1032,7 +1032,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 				+
 				( off64_t )rechdrp->rec_used;
 		if ( wantedoffset >= nextrecoffset ) {
-			u_int32_t recoff;
+			uint32_t recoff;
 			size_t wantedcnt;
 			char *dummybufp;
 			size_t actualcnt;
@@ -1048,7 +1048,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			/* figure how much to ask for
 			 */
 			assert( contextp->dc_nextp >= contextp->dc_recp );
-			recoff = ( u_int32_t )( contextp->dc_nextp
+			recoff = ( uint32_t )( contextp->dc_nextp
 						-
 						contextp->dc_recp );
 			wantedcnt = ( size_t )( rechdrp->rec_used
@@ -1232,11 +1232,11 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		assert( wantedoffset - currentoffset < ( off64_t )tape_recsz );
 		wantedcnt = ( size_t )( wantedoffset - currentoffset );
 		if ( contextp->dc_recp ) {
-			u_int32_t recoff;
+			uint32_t recoff;
 #ifdef DEBUG
 			rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
-			recoff = ( u_int32_t )( contextp->dc_nextp
+			recoff = ( uint32_t )( contextp->dc_nextp
 						-
 						contextp->dc_recp );
 			assert( recoff <= tape_recsz );
@@ -1269,13 +1269,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	 */
 	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
 	if ( contextp->dc_recp ) {
-		u_int32_t recoff;
+		uint32_t recoff;
 #ifdef DEBUG
 		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
 
 		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( u_int32_t )( contextp->dc_nextp
+		recoff = ( uint32_t )( contextp->dc_nextp
 					-
 					contextp->dc_recp );
 		assert( recoff <= tape_recsz );
@@ -1522,7 +1522,7 @@ huntQIC:
 	      p < contextp->dc_recendp
 	      ;
 	      p += QIC_BLKSZ ) {
-		if ( *( u_int64_t * )p == STAPE_MAGIC ) {
+		if ( *( uint64_t * )p == STAPE_MAGIC ) {
 			goto adjustQIC;
 		}
 	}
@@ -2921,10 +2921,10 @@ static void
 tape_rec_checksum_set( drive_context_t *contextp, char *bufp )
 {
 	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	u_int32_t *beginp = ( u_int32_t * )bufp;
-	u_int32_t *endp = ( u_int32_t * )( bufp + tape_recsz );
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )bufp;
+	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	uint32_t *p;
+	uint32_t accum;
 
 	if ( ! contextp->dc_recchksumpr ) {
 		return;
@@ -2943,10 +2943,10 @@ static bool_t
 tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
 {
 	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	u_int32_t *beginp = ( u_int32_t * )bufp;
-	u_int32_t *endp = ( u_int32_t * )( bufp + tape_recsz );
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )bufp;
+	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	uint32_t *p;
+	uint32_t accum;
 
 	if ( contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT) ) {
 		accum = 0;
@@ -3886,7 +3886,7 @@ display_ring_metrics( drive_t *drivep, int mlog_flags )
 }
 
 #ifdef CLRMTAUD
-static u_int32_t
+static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
@@ -3913,7 +3913,7 @@ rewind_and_verify( drive_t *drivep )
 }
 
 #ifdef CLRMTAUD
-static u_int32_t
+static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
@@ -3945,7 +3945,7 @@ erase_and_verify( drive_t *drivep )
 }
 
 #ifdef CLRMTAUD
-static u_int32_t
+static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
@@ -3957,7 +3957,7 @@ bsf_and_verify( drive_t *drivep )
 }
 
 #ifdef CLRMTAUD
-static u_int32_t
+static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 605675f..06ba2f4 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -288,7 +288,7 @@ typedef long mtstat_t;
 
 extern void usage( void );
 #ifdef DUMP
-extern u_int64_t hdr_mfilesz;
+extern uint64_t hdr_mfilesz;
 #endif /* DUMP */
 
 /* remote tape protocol declarations (should be a system header file)
@@ -446,7 +446,7 @@ static drive_ops_t drive_ops = {
 	do_quit,		/* do_quit */
 };
 
-static u_int32_t cmdlineblksize = 0;
+static uint32_t cmdlineblksize = 0;
 
 /* definition of locally defined global functions ****************************/
 
@@ -633,7 +633,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 				    c );
 			    return -10;
 			}
-			cmdlineblksize = ( u_int32_t )atoi( optarg );
+			cmdlineblksize = ( uint32_t )atoi( optarg );
 			break;
 #ifdef DUMP
 		case GETOPT_OVERWRITE:
@@ -1116,13 +1116,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	 */
 	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
 	if ( contextp->dc_recp ) {
-		u_int32_t recoff;
+		uint32_t recoff;
 #ifdef DEBUG
 		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
 
 		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( u_int32_t )( contextp->dc_nextp
+		recoff = ( uint32_t )( contextp->dc_nextp
 					-
 					contextp->dc_recp );
 		assert( recoff <= tape_recsz );
@@ -1145,7 +1145,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 				+
 				( off64_t )rechdrp->rec_used;
 		if ( wantedoffset >= nextrecoffset ) {
-			u_int32_t recoff;
+			uint32_t recoff;
 			size_t wantedcnt;
 			char *dummybufp;
 			size_t actualcnt;
@@ -1161,7 +1161,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			/* figure how much to ask for
 			 */
 			assert( contextp->dc_nextp >= contextp->dc_recp );
-			recoff = ( u_int32_t )( contextp->dc_nextp
+			recoff = ( uint32_t )( contextp->dc_nextp
 						-
 						contextp->dc_recp );
 			wantedcnt = ( size_t )( rechdrp->rec_used
@@ -1345,11 +1345,11 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 		assert( wantedoffset - currentoffset < ( off64_t )tape_recsz );
 		wantedcnt = ( size_t )( wantedoffset - currentoffset );
 		if ( contextp->dc_recp ) {
-			u_int32_t recoff;
+			uint32_t recoff;
 #ifdef DEBUG
 			rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
-			recoff = ( u_int32_t )( contextp->dc_nextp
+			recoff = ( uint32_t )( contextp->dc_nextp
 						-
 						contextp->dc_recp );
 			assert( recoff <= tape_recsz );
@@ -1382,13 +1382,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	 */
 	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
 	if ( contextp->dc_recp ) {
-		u_int32_t recoff;
+		uint32_t recoff;
 #ifdef DEBUG
 		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
 #endif
 
 		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( u_int32_t )( contextp->dc_nextp
+		recoff = ( uint32_t )( contextp->dc_nextp
 					-
 					contextp->dc_recp );
 		assert( recoff <= tape_recsz );
@@ -1665,7 +1665,7 @@ huntQIC:
 	      p < contextp->dc_recendp
 	      ;
 	      p += QIC_BLKSZ ) {
-		if ( *( u_int64_t * )p == STAPE_MAGIC ) {
+		if ( *( uint64_t * )p == STAPE_MAGIC ) {
 			goto adjustQIC;
 		}
 	}
@@ -3614,10 +3614,10 @@ static void
 tape_rec_checksum_set( drive_context_t *contextp, char *bufp )
 {
 	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	u_int32_t *beginp = ( u_int32_t * )bufp;
-	u_int32_t *endp = ( u_int32_t * )( bufp + tape_recsz );
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )bufp;
+	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	uint32_t *p;
+	uint32_t accum;
 
 	if ( ! contextp->dc_recchksumpr ) {
 		return;
@@ -3636,10 +3636,10 @@ static bool_t
 tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
 {
 	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	u_int32_t *beginp = ( u_int32_t * )bufp;
-	u_int32_t *endp = ( u_int32_t * )( bufp + tape_recsz );
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )bufp;
+	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	uint32_t *p;
+	uint32_t accum;
 
 	if ( contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
 		accum = 0;
diff --git a/common/global.c b/common/global.c
index 2129941..ea7ad6d 100644
--- a/common/global.c
+++ b/common/global.c
@@ -96,7 +96,7 @@ global_hdr_alloc( int argc, char *argv[ ] )
 
 	/* fill in the host id: typecast to fit into a 64 bit field
 	 */
-	ghdrp->gh_ipaddr = ( u_int64_t )( unsigned long )gethostid( );
+	ghdrp->gh_ipaddr = ( uint64_t )( unsigned long )gethostid( );
 
 #ifdef DUMP
 	uuid_generate( ghdrp->gh_dumpid );
@@ -243,10 +243,10 @@ global_hdr_free( global_hdr_t *ghdrp )
 void
 global_hdr_checksum_set( global_hdr_t *hdrp )
 {
-	u_int32_t *beginp = ( u_int32_t * )&hdrp[ 0 ];
-	u_int32_t *endp = ( u_int32_t * )&hdrp[ 1 ];
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )&hdrp[ 0 ];
+	uint32_t *endp = ( uint32_t * )&hdrp[ 1 ];
+	uint32_t *p;
+	uint32_t accum;
 
 	hdrp->gh_checksum = 0;
 	accum = 0;
@@ -263,10 +263,10 @@ global_hdr_checksum_set( global_hdr_t *hdrp )
 bool_t
 global_hdr_checksum_check( global_hdr_t *hdrp )
 {
-	u_int32_t *beginp = ( u_int32_t * )&hdrp[ 0 ];
-	u_int32_t *endp = ( u_int32_t * )&hdrp[ 1 ];
-	u_int32_t *p;
-	u_int32_t accum;
+	uint32_t *beginp = ( uint32_t * )&hdrp[ 0 ];
+	uint32_t *endp = ( uint32_t * )&hdrp[ 1 ];
+	uint32_t *p;
+	uint32_t accum;
 
 	accum = 0;
 	for ( p = beginp ; p < endp ; p++ ) {
@@ -279,7 +279,7 @@ global_hdr_checksum_check( global_hdr_t *hdrp )
  * else return BOOL_FALSE
  */
 bool_t 
-global_version_check( u_int32_t version )
+global_version_check( uint32_t version )
 {
 	switch (version) {
 		case GLOBAL_HDR_VERSION_0:
diff --git a/common/global.h b/common/global.h
index 537be0c..0b738de 100644
--- a/common/global.h
+++ b/common/global.h
@@ -43,15 +43,15 @@
 struct global_hdr {
 	char gh_magic[ GLOBAL_HDR_MAGIC_SZ ];		/*   8    8 */
 		/* unique signature of xfsdump */
-	u_int32_t gh_version;				/*   4    c */
+	uint32_t gh_version;				/*   4    c */
 		/* header version */
-	u_int32_t gh_checksum;				/*   4   10 */
+	uint32_t gh_checksum;				/*   4   10 */
 		/* 32-bit unsigned additive inverse of entire header */
 	time32_t gh_timestamp;				/*   4   14 */
 		/* time32_t of dump */
 	char gh_pad1[ 4 ];				/*   4   18 */
 		/* alignment */
-	u_int64_t gh_ipaddr;				/*   8   20 */
+	uint64_t gh_ipaddr;				/*   8   20 */
 		/* from gethostid(2), room for expansion */
 	uuid_t gh_dumpid;				/*  10   30 */
 		/* ID of dump session	 */
@@ -97,7 +97,7 @@ extern bool_t global_hdr_checksum_check( global_hdr_t *hdrp );
  * else return BOOL_FALSE
  */
 
-extern bool_t global_version_check( u_int32_t version );
+extern bool_t global_version_check( uint32_t version );
 
 
 #endif /* GLOBAL_H */
diff --git a/common/hsmapi.c b/common/hsmapi.c
index ed29370..489223d 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -137,7 +137,7 @@ typedef	struct	{
 static inline void
 msb_store(
 	u_char		*dest,
-	u_int64_t	src,
+	uint64_t	src,
 	int		length)
 {
         int             i;
@@ -155,12 +155,12 @@ msb_store(
 * Returns
 *	value
 ******************************************************************************/
-static inline u_int64_t
+static inline uint64_t
 msb_load(
 	u_char		*src,
 	int		length)
 {
-        u_int64_t        tmp = 0;
+        uint64_t        tmp = 0;
         int             i;
 
         for (i = 0; i < length; i++) {
@@ -634,7 +634,7 @@ extern int
 HsmFilterExistingAttribute(
 	hsm_f_ctxt_t	*hsm_f_ctxtp,
 const	char		*namep,		/* attribute name */
-	u_int32_t	valuesz,	/* value size */
+	uint32_t	valuesz,	/* value size */
 	int		flag,
 	int		*skip_entry)
 {
@@ -698,7 +698,7 @@ HsmAddNewAttribute(
 	int		flag,
 	char		**namepp,	/* pointer to new attribute name */
 	char		**valuepp,	/* pointer to its value */
-	u_int32_t	*valueszp)	/* pointer to the value size */
+	uint32_t	*valueszp)	/* pointer to the value size */
 {
 	dmf_f_ctxt_t	*dmf_f_ctxtp = (dmf_f_ctxt_t *)hsm_f_ctxtp;
 	XFSattrvalue1_t	*dmfattr1p = (XFSattrvalue1_t *)dmf_f_ctxtp->attrval;
diff --git a/common/hsmapi.h b/common/hsmapi.h
index 665499c..b6d035d 100644
--- a/common/hsmapi.h
+++ b/common/hsmapi.h
@@ -252,7 +252,7 @@ extern int
 HsmFilterExistingAttribute(
 	hsm_f_ctxt_t	*hsm_f_ctxtp,
 const	char		*namep,		/* name of attribute to filter */
-	u_int32_t	valuesz,	/* attribute's current value size */
+	uint32_t	valuesz,	/* attribute's current value size */
 	int		flag,		/* ext attr flags */
 	int		*skip_entry);
 
@@ -290,7 +290,7 @@ HsmAddNewAttribute(
 	int		flag,		/* ext attr flags */
 	char		**namepp,	/* pointer to new attribute name */
 	char		**valuepp,	/* pointer to its value */
-	u_int32_t	*valueszp);	/* pointer to the value size */
+	uint32_t	*valueszp);	/* pointer to the value size */
 
 
 /******************************************************************************
diff --git a/common/inventory.c b/common/inventory.c
index d1c067b..83e1ebb 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -80,7 +80,7 @@ inv_open( inv_predicate_t bywhat, void *pred )
 	}
 	/* create another storage object ( and, an inv_index entry for it too )
 	   if we've filled this one up */
-	if ( (u_int) num >= sescnt->ic_maxnum ) {
+	if ( (uint) num >= sescnt->ic_maxnum ) {
 #ifdef INVT_DEBUG
 		printf("$ creating a new storage obj & index entry. \n" );
 #endif
@@ -225,7 +225,7 @@ inv_writesession_open(
 	uuid_t		*sesid,
 	char		*label,
 	u_char		level,
-	u_int		nstreams,
+	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
 	char		*devpath )
diff --git a/common/inventory.h b/common/inventory.h
index 351f6e0..f9fcb19 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -98,7 +98,7 @@ typedef struct inv_stream {
 typedef struct inv_session {
 	uuid_t		 s_fsid;	/* file system */
 	uuid_t 		 s_sesid;	/* this dump session's id: 16 bytes*/
-	u_int		 s_nstreams;	/* number of media streams recorded */
+	uint		 s_nstreams;	/* number of media streams recorded */
 	inv_stream_t	*s_streams;	/* array of streams */
 	time32_t	 s_time;   	/* time of the dump */
 	u_char		 s_level;  	/* dump level */
@@ -159,7 +159,7 @@ inv_writesession_open(
 	uuid_t		*sesid,
 	char		*label,
 	u_char		level,
-	u_int		nstreams,
+	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
 	char		*devpath );
diff --git a/common/main.c b/common/main.c
index 08bf574..e381e85 100644
--- a/common/main.c
+++ b/common/main.c
@@ -170,10 +170,10 @@ main( int argc, char *argv[] )
 	assert( sizeof( char_t ) == 1 );
 	assert( sizeof( u_char_t ) == 1 );
 	assert( sizeof( int32_t ) == 4 );
-	assert( sizeof( u_int32_t ) == 4 );
+	assert( sizeof( uint32_t ) == 4 );
 	assert( sizeof( size32_t ) == 4 );
 	assert( sizeof( int64_t ) == 8 );
-	assert( sizeof( u_int64_t ) == 8 );
+	assert( sizeof( uint64_t ) == 8 );
 	assert( sizeof( size64_t ) == 8 );
 
 	/* record the command name used to invoke
@@ -662,7 +662,7 @@ main( int argc, char *argv[] )
 	 * signals.
 	 */
 	if ( progrpt_enabledpr ) {
-		( void )alarm( ( u_int )progrpt_interval );
+		( void )alarm( ( uint )progrpt_interval );
 	}
 	for ( ; ; ) {
 		time32_t now;
@@ -813,7 +813,7 @@ main( int argc, char *argv[] )
 			      "setting alarm for %d second%s\n",
 			      timeout,
 			      timeout == 1 ? "" : "s" );
-			( void )alarm( ( u_int )timeout );
+			( void )alarm( ( uint )timeout );
 			if ( timeout == 0 ) {
 				continue;
 			}
@@ -835,7 +835,7 @@ main( int argc, char *argv[] )
 					      statline[ i ] );
 				}
 			}
-			( void )alarm( ( u_int )( progrpt_deadline
+			( void )alarm( ( uint )( progrpt_deadline
 						       -
 						       now ));
 		}
diff --git a/common/media.h b/common/media.h
index ee1975f..0b727e5 100644
--- a/common/media.h
+++ b/common/media.h
@@ -46,15 +46,15 @@ struct media_hdr {
 		/* ID of upstream media object */
 	char mh_pad2[ GLOBAL_HDR_UUID_SZ ];		/*  10  330 */
 		/* in case more IDs needed */
-	u_int32_t mh_mediaix;				/*   4  334 */
+	uint32_t mh_mediaix;				/*   4  334 */
 		/* 0-based index of this media object within the dump stream */
-	u_int32_t mh_mediafileix;			/*   4  338 */
+	uint32_t mh_mediafileix;			/*   4  338 */
 		/* 0-based index of this file within this media object */
-	u_int32_t mh_dumpfileix;			/*   4  33c */
+	uint32_t mh_dumpfileix;			/*   4  33c */
 		/* 0-based index of this file within this dump stream */
-	u_int32_t mh_dumpmediafileix;			/*   4  340 */
+	uint32_t mh_dumpmediafileix;			/*   4  340 */
 		/* 0-based index of file within dump stream and media object */
-	u_int32_t mh_dumpmediaix;			/*   4  344 */
+	uint32_t mh_dumpmediaix;			/*   4  344 */
 		/* 0-based index of this dump within the media object */
 	int32_t mh_strategyid;				/*   4  348 */
 		/* ID of the media strategy used to produce this dump */
diff --git a/common/rec_hdr.h b/common/rec_hdr.h
index b8f4571..552447c 100644
--- a/common/rec_hdr.h
+++ b/common/rec_hdr.h
@@ -36,7 +36,7 @@
  * structure, and add a endian conversion function to arch_xlate.c 
  */
 struct rec_hdr {
-	u_int64_t magic;			/*   8   8 */
+	uint64_t magic;			/*   8   8 */
 		/* magic number STAPE_MAGIC (see above)
 		 */
 	int32_t version;			/*   4   c */
@@ -62,7 +62,7 @@ struct rec_hdr {
 		/* raw media file byte offset of first mark set
 		 * in this record. set to -1 if no marks in record
 		 */
-	u_int32_t rec_used;			/*   4  34 */
+	uint32_t rec_used;			/*   4  34 */
 		/* portion of record containing user data plus rec hdr (bytes).
 		 * normally set to record size. last record written may
 		 * indicate smaller value. includes record header.
diff --git a/common/types.h b/common/types.h
index 9afb3a7..235f52a 100644
--- a/common/types.h
+++ b/common/types.h
@@ -18,6 +18,11 @@
 #ifndef TYPES_H
 #define TYPES_H
 
+/*
+ * Pull in all the standard C types first.
+ */
+#include <stdint.h>
+
 #define XFSDUMP_DIRPATH	inv_basepath()
 
 /*
@@ -34,11 +39,11 @@
 
 /* integers
  */
-typedef u_int32_t size32_t;
-typedef u_int64_t size64_t;
+typedef uint32_t size32_t;
+typedef uint64_t size64_t;
 typedef char char_t;
 typedef unsigned char u_char_t;
-typedef unsigned int u_int;
+typedef unsigned int uint;
 typedef long long_t;
 typedef unsigned long u_long_t;
 typedef size_t ix_t;
@@ -63,15 +68,15 @@ typedef int32_t time32_t;
 #define MKSMAX( t )	MKMAX( t, 1ull )
 #define MKUMAX( t )	MKMAX( t, 0ull )
 #define INT32MAX	MKSMAX( int32_t )
-#define UINT32MAX	MKUMAX( u_int32_t )
+#define UINT32MAX	MKUMAX( uint32_t )
 #define SIZE32MAX	MKUMAX( size32_t )
 #define INT64MAX	MKSMAX( int64_t )
-#define UINT64MAX	MKUMAX( u_int64_t )
+#define UINT64MAX	MKUMAX( uint64_t )
 #define SIZE64MAX	MKUMAX( size64_t )
 #define INO64MAX	MKUMAX( xfs_ino_t )
 #define OFF64MAX	MKSMAX( off64_t )
 #define INTGENMAX	MKSMAX( int )
-#define UINTGENMAX	MKUMAX( u_int )
+#define UINTGENMAX	MKUMAX( uint )
 #define OFFMAX		MKSMAX( off_t )
 #define SIZEMAX		MKUMAX( size_t )
 #define IXMAX		MKUMAX( size_t )
diff --git a/dump/content.c b/dump/content.c
index 00a7bad..fcd7dd7 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -363,7 +363,7 @@ static char *dump_extattr_buildrecord( xfs_bstat_t *statp,
 				       char *dumpbufp,
 				       char *dumpbufendp,
 				       char *namesrcp,
-				       u_int32_t valuesz,
+				       uint32_t valuesz,
 				       int flag,
 				       char **valuepp );
 static rv_t dump_extattrhdr( drive_t *drivep,
@@ -372,7 +372,7 @@ static rv_t dump_extattrhdr( drive_t *drivep,
 			     size_t recsz,
 			     size_t valoff,
 			     ix_t flags,
-			     u_int32_t valsz );
+			     uint32_t valsz );
 
 static bool_t save_quotas( char *mntpnt,
 			   quota_info_t *quotainfo );
@@ -385,8 +385,8 @@ static int getxfsqstat( char *fsdev );
 bool_t content_media_change_needed;
 char *media_change_alert_program = NULL;
 hsm_fs_ctxt_t *hsm_fs_ctxtp = NULL;
-u_int64_t hdr_mfilesz = 0;
-u_int64_t maxdumpfilesize = 0;
+uint64_t hdr_mfilesz = 0;
+uint64_t maxdumpfilesize = 0;
 bool_t allowexcludefiles_pr = BOOL_FALSE;
 
 /* definition of locally defined static variables *****************************/
@@ -554,14 +554,14 @@ content_init( int argc,
 	char *baseuuidstr = NULL;
 	uuid_t baseuuid;
 	bool_t baseuuidvalpr;
-	u_int64_t dircnt;
-	u_int64_t nondircnt;
-	u_int64_t datasz;
-	u_int64_t inocnt;
-	u_int64_t inomapsz;
-	u_int64_t direntsz;
-	u_int64_t filesz;
-	u_int64_t size_estimate;
+	uint64_t dircnt;
+	uint64_t nondircnt;
+	uint64_t datasz;
+	uint64_t inocnt;
+	uint64_t inomapsz;
+	uint64_t direntsz;
+	uint64_t filesz;
+	uint64_t size_estimate;
 
 	/* basic sanity checks
 	 */
@@ -1517,8 +1517,8 @@ baseuuidbypass:
 	datasz = scwhdrtemplatep->cih_inomap_datasz;
 	inocnt = dircnt + nondircnt;
 	inomapsz = inomap_getsz( );
-	direntsz = inocnt * ( u_int64_t )( DIRENTHDR_SZ + 8 );
-	filesz = inocnt * ( u_int64_t )( FILEHDR_SZ + EXTENTHDR_SZ );
+	direntsz = inocnt * ( uint64_t )( DIRENTHDR_SZ + 8 );
+	filesz = inocnt * ( uint64_t )( FILEHDR_SZ + EXTENTHDR_SZ );
 
 	hdr_mfilesz =	GLOBAL_HDR_SZ
 			+
@@ -2563,7 +2563,7 @@ decision_more:
 			ok = inv_put_mediafile( inv_stmt,
 						&mwhdrp->mh_mediaid,
 						mwhdrp->mh_medialabel,
-					( u_int )mwhdrp->mh_mediafileix,
+					( uint )mwhdrp->mh_mediafileix,
 						startino,
 						startoffset,
 						scwhdrp->cih_startpt.sp_ino,
@@ -3445,7 +3445,7 @@ dump_extattr_list( drive_t *drivep,
 			char	*hsmnamep;
 			char	*hsmvaluep;
 			char	*valuep;
-			u_int32_t	hsmvaluesz;
+			uint32_t	hsmvaluesz;
 
 			if (!HsmAddNewAttribute(contextp->cc_hsm_f_ctxtp,
 						hsmcursor,
@@ -3558,16 +3558,16 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 			  char *dumpbufp,
 			  char *dumpbufendp,
 			  char *namesrcp,
-			  u_int32_t valuesz,
+			  uint32_t valuesz,
 			  int flag,
 			  char **valuepp )
 {
 	extattrhdr_t *ahdrp = ( extattrhdr_t * )dumpbufp;
 	char *namep = dumpbufp + EXTATTRHDR_SZ;
-	u_int32_t namelen = strlen( namesrcp );
-	u_int32_t namesz = namelen + 1;
+	uint32_t namelen = strlen( namesrcp );
+	uint32_t namesz = namelen + 1;
 	char *valuep = namep + namesz;
-	u_int32_t recsz = EXTATTRHDR_SZ + namesz + valuesz;
+	uint32_t recsz = EXTATTRHDR_SZ + namesz + valuesz;
 	extattrhdr_t tmpah;
 
 	recsz = ( recsz + ( EXTATTRHDR_ALIGN - 1 ))
@@ -3620,8 +3620,8 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 	memset( ( void * )&tmpah, 0, sizeof( tmpah ));
 	tmpah.ah_sz = recsz;
 	assert( EXTATTRHDR_SZ + namesz < UINT16MAX );
-	tmpah.ah_valoff = ( u_int16_t )( EXTATTRHDR_SZ + namesz );
-	tmpah.ah_flags = ( u_int16_t )
+	tmpah.ah_valoff = ( uint16_t )( EXTATTRHDR_SZ + namesz );
+	tmpah.ah_flags = ( uint16_t )
 		(( flag & ATTR_ROOT ) ? EXTATTRHDR_FLAGS_ROOT :
 		(( flag & ATTR_SECURE ) ? EXTATTRHDR_FLAGS_SECURE : 0));
 	tmpah.ah_valsz = valuesz;
@@ -3641,7 +3641,7 @@ dump_extattrhdr( drive_t *drivep,
 		 size_t recsz,
 		 size_t valoff,
 		 ix_t flags,
-		 u_int32_t valsz )
+		 uint32_t valsz )
 {
 	extattrhdr_t ahdr;
 	extattrhdr_t tmpahdr;
@@ -3651,8 +3651,8 @@ dump_extattrhdr( drive_t *drivep,
 	memset( ( void * )&ahdr, 0, sizeof( ahdr ));
 	ahdr.ah_sz = recsz;
 	assert( valoff < UINT16MAX );
-	ahdr.ah_valoff = ( u_int16_t )valoff;
-	ahdr.ah_flags = ( u_int16_t )flags | EXTATTRHDR_FLAGS_CHECKSUM;
+	ahdr.ah_valoff = ( uint16_t )valoff;
+	ahdr.ah_flags = ( uint16_t )flags | EXTATTRHDR_FLAGS_CHECKSUM;
 	ahdr.ah_valsz = valsz;
 	ahdr.ah_checksum = calc_checksum( &ahdr, EXTATTRHDR_SZ );
 
@@ -5120,8 +5120,8 @@ dump_dirent( drive_t *drivep,
 
 		memset( ( void * )dhdrp, 0, sz );
 		dhdrp->dh_ino = ino;
-		dhdrp->dh_sz = ( u_int16_t )sz;
-		dhdrp->dh_gen = ( u_int16_t )( gen & DENTGENMASK );
+		dhdrp->dh_sz = ( uint16_t )sz;
+		dhdrp->dh_gen = ( uint16_t )( gen & DENTGENMASK );
 		if ( name ) {
 			strcpy( dhdrp->dh_name, name );
 		}
@@ -5139,7 +5139,7 @@ dump_dirent( drive_t *drivep,
 		memset( ( void * )dhdrp, 0, sz );
 		dhdrp->dh_ino = ino;
 		dhdrp->dh_gen = gen;
-		dhdrp->dh_sz = ( u_int16_t )sz;
+		dhdrp->dh_sz = ( uint16_t )sz;
 		if ( name ) {
 			strcpy( dhdrp->dh_name, name );
 		}
@@ -5327,7 +5327,7 @@ dump_session_inv( drive_t *drivep,
 			ok = inv_put_mediafile( inv_stmt,
 						&mediaid,
 						medialabel,
-						( u_int )mediafileix,
+						( uint )mediafileix,
 						(xfs_ino_t )0,
 						( off64_t )0,
 						(xfs_ino_t )0,
@@ -5572,8 +5572,8 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 		switch ( entrystate ) {
 		case BES_INIT:
 			mediawrittentopr = BOOL_FALSE;
-			mwhdrp->mh_mediaix = ( u_int32_t )( -1 );
-			mwhdrp->mh_dumpfileix = ( u_int32_t )( -1 );
+			mwhdrp->mh_mediaix = ( uint32_t )( -1 );
+			mwhdrp->mh_dumpfileix = ( uint32_t )( -1 );
 			if ( dcaps & DRIVE_CAP_READ ) {
 				mediapresentpr = BOOL_UNKNOWN;
 				virginmediapr = BOOL_UNKNOWN;
@@ -6030,8 +6030,8 @@ write:
 		mwhdrp->mh_mediaix++; /* pre-initialized to -1 */
 	}
 
-	assert( mwhdrp->mh_mediaix != ( u_int32_t )( -1 ));
-	assert( mwhdrp->mh_dumpfileix != ( u_int32_t )( -1 ));
+	assert( mwhdrp->mh_mediaix != ( uint32_t )( -1 ));
+	assert( mwhdrp->mh_dumpfileix != ( uint32_t )( -1 ));
 
 	/* do not allow interleaving of media files from different xfsdumps.
 	 */
diff --git a/dump/inomap.c b/dump/inomap.c
index 06f3869..4e57a78 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -62,7 +62,7 @@
 extern bool_t preemptchk( int );
 extern size_t pgsz;
 extern hsm_fs_ctxt_t *hsm_fs_ctxtp;
-extern u_int64_t maxdumpfilesize;
+extern uint64_t maxdumpfilesize;
 extern bool_t allowexcludefiles_pr;
 
 /* forward declarations of locally defined static functions ******************/
@@ -133,8 +133,8 @@ static int subtreelist_parse( jdm_fshandle_t *,
 static ix_t *inomap_statphasep;
 static ix_t *inomap_statpassp;
 static size64_t *inomap_statdonep;
-static u_int64_t inomap_exclude_filesize = 0;
-static u_int64_t inomap_exclude_skipattr = 0;
+static uint64_t inomap_exclude_filesize = 0;
+static uint64_t inomap_exclude_skipattr = 0;
 
 /* definition of locally defined global functions ****************************/
 
@@ -949,7 +949,7 @@ cb_startpt( void *arg1,
 /* define structure for ino to gen mapping.
  */
 struct i2gseg {
-	u_int64_t s_valid;
+	uint64_t s_valid;
 	gen_t s_gen[ INOPERSEG ];
 };
 typedef struct i2gseg i2gseg_t;
@@ -971,10 +971,10 @@ static inline void
 SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 {
 	register xfs_ino_t relino;
-	register u_int64_t mask;
-	register u_int64_t clrmask;
+	register uint64_t mask;
+	register uint64_t clrmask;
 	relino = ino - segp->base;
-	mask = ( u_int64_t )1 << relino;
+	mask = ( uint64_t )1 << relino;
 	clrmask = ~mask;
 	switch( state ) {
 	case 0:
@@ -1025,9 +1025,9 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 {
 	int state;
 	register xfs_ino_t relino;
-	register u_int64_t mask;
+	register uint64_t mask;
 	relino = ino - segp->base;
-	mask = ( u_int64_t )1 << relino;
+	mask = ( uint64_t )1 << relino;
 	if ( segp->lobits & mask ) {
 		state = 1;
 	} else {
@@ -1063,7 +1063,7 @@ inomap_init( int igrpcnt )
 	return 0;
 }
 
-u_int64_t
+uint64_t
 inomap_getsz( void )
 {
 	return (inomap.lastseg.hnkoff + 1) * HNKSZ;
@@ -1378,7 +1378,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
 
 	relino = ino - segp->base;
-	i2gsegp->s_valid |= (u_int64_t)1 << relino;
+	i2gsegp->s_valid |= (uint64_t)1 << relino;
 	i2gsegp->s_gen[relino] = gen;
 }
 
@@ -1399,7 +1399,7 @@ inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
 
 	relino = ino - segp->base;
-	if ( ! (i2gsegp->s_valid & ((u_int64_t)1 << relino)) )
+	if ( ! (i2gsegp->s_valid & ((uint64_t)1 << relino)) )
 		return 1;
 
 	*gen = i2gsegp->s_gen[relino];
@@ -1413,11 +1413,11 @@ inomap_writehdr( content_inode_hdr_t *scwhdrp )
 	 */
 	scwhdrp->cih_inomap_hnkcnt = inomap.lastseg.hnkoff + 1;
 	scwhdrp->cih_inomap_segcnt = inomap_addr2segix( &inomap.lastseg ) + 1;
-	scwhdrp->cih_inomap_dircnt = ( u_int64_t )cb_dircnt;
-	scwhdrp->cih_inomap_nondircnt = ( u_int64_t )cb_nondircnt;
+	scwhdrp->cih_inomap_dircnt = ( uint64_t )cb_dircnt;
+	scwhdrp->cih_inomap_nondircnt = ( uint64_t )cb_nondircnt;
 	scwhdrp->cih_inomap_firstino = inomap.hnkmap[0].seg[ 0 ].base;
 	scwhdrp->cih_inomap_lastino = inomap.hnkmap[inomap.lastseg.hnkoff].maxino;
-	scwhdrp->cih_inomap_datasz = ( u_int64_t )cb_datasz;
+	scwhdrp->cih_inomap_datasz = ( uint64_t )cb_datasz;
 }
 
 rv_t
diff --git a/dump/inomap.h b/dump/inomap.h
index 663b434..f222642 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -65,7 +65,7 @@ extern bool_t inomap_build( jdm_fshandle_t *fshandlep,
 			    size64_t statcnt,
 			    size64_t *statdonep );
 
-extern u_int64_t inomap_getsz( void );
+extern uint64_t inomap_getsz( void );
 
 /* inomap_skip - tell inomap about inodes to skip in the dump
  */
@@ -103,9 +103,9 @@ extern rv_t inomap_dump( drive_t *drivep );
  */
 struct seg {
 	xfs_ino_t base;
-	u_int64_t lobits;
-	u_int64_t mebits;
-	u_int64_t hibits;
+	uint64_t lobits;
+	uint64_t mebits;
+	uint64_t hibits;
 };
 
 typedef struct seg seg_t;
diff --git a/inventory/inv_api.c b/inventory/inv_api.c
index 4c1855b..888c425 100644
--- a/inventory/inv_api.c
+++ b/inventory/inv_api.c
@@ -94,7 +94,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
 	/* create another storage object ( and, an inv_index entry for it 
 	   too ) if we've filled this one up */
 
-	if ( (u_int) num >= sescnt->ic_maxnum ) {
+	if ( (uint) num >= sescnt->ic_maxnum ) {
 		mlog( MLOG_DEBUG | MLOG_INV, "$ INV: creating a new storage obj & "
 		      "index entry. \n" );
 		INVLOCK( stobjfd, LOCK_UN );
@@ -163,7 +163,7 @@ inv_writesession_open(
 	bool_t		ispartial,
 	bool_t		isresumed,
 	u_char		level,
-	u_int		nstreams,
+	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
 	char		*devpath )
@@ -439,7 +439,7 @@ inv_put_mediafile(
 	inv_stmtoken_t 	tok, 
 	uuid_t 		*moid, 
 	char 		*label,
-	u_int		mfileindex,
+	uint		mfileindex,
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
 	xfs_ino_t	endino,
diff --git a/inventory/inv_core.c b/inventory/inv_core.c
index 419f575..a17c2c9 100644
--- a/inventory/inv_core.c
+++ b/inventory/inv_core.c
@@ -49,7 +49,7 @@ int
 get_counters( int fd, void **cntpp, size_t cntsz )
 {
 	/* object must be locked at least SHARED by caller */
-	u_int num;
+	uint num;
 	assert( cntsz >= sizeof( invt_counter_t ) );
 
 	*cntpp =  calloc( 1, cntsz);
@@ -238,7 +238,7 @@ get_lastheader( int fd, void **ent, size_t hdrsz, size_t cntsz )
 	/* if there's space anywhere at all, then it must be in the last
 	   entry */
 	*ent = malloc( hdrsz );
-	pos = (char *) arr + ( (u_int)nindices - 1 ) * hdrsz;
+	pos = (char *) arr + ( (uint)nindices - 1 ) * hdrsz;
 	memcpy( *ent, pos, hdrsz );
 	free ( arr );
 	free ( cnt );
diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
index 13b64db..95529e8 100644
--- a/inventory/inv_idx.c
+++ b/inventory/inv_idx.c
@@ -43,13 +43,13 @@
 /* given a time, find the invindex that has the time-period it can fit  */
 /* into.                                                                */
 /*----------------------------------------------------------------------*/
-u_int
+uint
 idx_insert_newentry( int fd, /* kept locked EX by caller */
 		     int *stobjfd, /* OUT */
 		     invt_entry_t *iarr, invt_counter_t *icnt,
 		     time32_t tm )
 {
-	u_int i;
+	uint i;
 	inv_oflag_t forwhat = INV_SEARCH_N_MOD;
 /*	invt_entry_t ient;
 	ient.ie_timeperiod.tp_start = ient.ie_timeperiod.tp_end = tm; */
@@ -162,7 +162,7 @@ idx_put_newentry(
 	int stobjfd;
 	
 	int fd = idx->invfd; 	/* kept locked EX by caller */
-	u_int index = idx->index + 1;
+	uint index = idx->index + 1;
 	invt_entry_t *iarr = idx->iarr;
 	invt_counter_t *icnt = idx->icnt;
 
@@ -356,7 +356,7 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
 				sizeof( invt_counter_t ))) < 0 ) {
 			return -1;		 
 		}
-		idx_DEBUG_printinvindices( iarr, (u_int) nindices );
+		idx_DEBUG_printinvindices( iarr, (uint) nindices );
 		free( iarr );
 		free( icnt );
 	}
@@ -496,10 +496,10 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
 
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, u_int num )
+idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num )
 {
-	u_int i;
-	u_int k;
+	uint i;
+	uint k;
 
 	char s[9];
 	printf( "\n ==================================\n"
@@ -533,7 +533,7 @@ idx_DEBUG_print ( int fd )
 				         sizeof( invt_counter_t ))) < 0 ) {
 		return -1;		 
 	}
-	idx_DEBUG_printinvindices( iarr, (u_int) nindices );
+	idx_DEBUG_printinvindices( iarr, (uint) nindices );
 	free( iarr );
 	free( icnt );
 
@@ -543,7 +543,7 @@ idx_DEBUG_print ( int fd )
 
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, u_int ref,
+DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref,
 			  invt_pr_ctx_t *prctx)
 {
 	inv_session_t *ses;
diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
index 1b99d5c..e521f24 100644
--- a/inventory/inv_mgr.c
+++ b/inventory/inv_mgr.c
@@ -346,7 +346,7 @@ invmgr_inv_print(
 	invt_entry_t	*iarr = NULL;
 	invt_counter_t	*icnt = NULL;
 	int	     	nindices;
-	u_int           ref = 0;
+	uint           ref = 0;
 
 	if (invfd == I_EMPTYINV)
 		return 0;
@@ -363,7 +363,7 @@ invmgr_inv_print(
 	free( icnt );
 
 	if (prctx->invidx) {
-		idx_DEBUG_printinvindices( iarr, (u_int) nindices );
+		idx_DEBUG_printinvindices( iarr, (uint) nindices );
 		free(iarr);
 		return (0);
 	}
diff --git a/inventory/inv_priv.h b/inventory/inv_priv.h
index 598c366..1690271 100644
--- a/inventory/inv_priv.h
+++ b/inventory/inv_priv.h
@@ -48,8 +48,8 @@
 #define NEW_INVINDEX		2
 
 /* session flags ( seshdr.sh_flag ) */
-#define INVT_PARTIAL		(u_int)0x0001
-#define INVT_RESUMED            (u_int)0x0002
+#define INVT_PARTIAL		(uint)0x0001
+#define INVT_RESUMED            (uint)0x0002
 
 /* media file flags ( mfile.mf_flag ) */
 #define INVT_MFILE_GOOD         (u_char)0x01
@@ -108,9 +108,9 @@ typedef struct invt_session {
 	char		 s_label[INV_STRLEN];  /* session label */
 	char		 s_mountpt[INV_STRLEN];/* path to the mount point */
 	char		 s_devpath[INV_STRLEN];/* path to the device */
-	u_int		 s_cur_nstreams;/* number of streams created under
+	uint		 s_cur_nstreams;/* number of streams created under
 					   this session so far */
-	u_int		 s_max_nstreams;/* number of media streams in 
+	uint		 s_max_nstreams;/* number of media streams in 
 					   the session */
 	char		 s_padding[16];
 } invt_session_t;			   
@@ -148,7 +148,7 @@ typedef struct invt_stream {
 	off64_t		st_firstmfile;	/*offsets to the start and end of*/
 	off64_t		st_lastmfile;	/* .. linked list of mediafiles */
 	char            st_cmdarg[INV_STRLEN]; /* drive path */
-	u_int		st_nmediafiles; /* number of mediafiles */
+	uint		st_nmediafiles; /* number of mediafiles */
 	bool_t		st_interrupted;	/* was this stream interrupted ? */
 	char		st_padding[16];
 } invt_stream_t;
@@ -163,7 +163,7 @@ typedef struct invt_mediafile {
 					   media file with */
 	off64_t		 mf_nextmf;	/* links to other mfiles */
 	off64_t		 mf_prevmf;
-	u_int		 mf_mfileidx; 	/* index within the media object */
+	uint		 mf_mfileidx; 	/* index within the media object */
 	u_char           mf_flag;       /* Currently MFILE_GOOD, INVDUMP */
 	off64_t		 mf_size;       /* size of the media file */
 	char		 mf_padding[15];
@@ -185,9 +185,9 @@ typedef struct invt_entry {
 /* Cheap Inheritance, and an attempt to avoid a nested type */
 #define INVT_COUNTER_FIELDS  \
         __uint32_t    ic_vernum;/* on disk version number for posterity */\
-	u_int	      ic_curnum;/* number of sessions/invindices recorded \
+	uint	      ic_curnum;/* number of sessions/invindices recorded \
 				   so far */				  \
-	u_int	      ic_maxnum;/* maximum number of sessions/inv_indices \
+	uint	      ic_maxnum;/* maximum number of sessions/inv_indices \
 				   that we can record on this stobj */
 #define INVT_COUNTER_FIELDS_SIZE 0xc
 
@@ -272,7 +272,7 @@ typedef struct invt_idxinfo {
 	int 		invfd;
 	invt_counter_t	*icnt;
 	invt_entry_t	*iarr;
-	u_int		index;
+	uint		index;
 }invt_idxinfo_t;
 
 #define INVT_MOID	1
@@ -366,7 +366,7 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime);
 int
 idx_find_stobj( invt_idxinfo_t *idx, time32_t tm );
 
-u_int
+uint
 idx_insert_newentry( int fd, int *stobjfd, invt_entry_t *iarr, 
 		     invt_counter_t *icnt,
 		     time32_t tm );
@@ -380,7 +380,7 @@ int
 idx_recons_time( time32_t tm, invt_idxinfo_t *idx );
 
 int
-idx_DEBUG_printinvindices( invt_entry_t *iarr, u_int num );
+idx_DEBUG_printinvindices( invt_entry_t *iarr, uint num );
 
 int
 idx_DEBUG_print ( int fd );
@@ -415,10 +415,10 @@ int
 stobj_hdrcmp( const void *h1, const void *h2 );
 
 int
-stobj_sortheaders( int fd, u_int num );
+stobj_sortheaders( int fd, uint num );
 
-u_int
-stobj_find_splitpoint( int fd, invt_seshdr_t *harr, u_int ns, time32_t tm );
+uint
+stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm );
 
 int
 stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt, 
@@ -467,7 +467,7 @@ stobj_copy_invsess( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		    inv_session_t **buf);
 
 void
-DEBUG_sessionprint( inv_session_t *ses, u_int ref, invt_pr_ctx_t *prctx);
+DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx);
 
 void
 DEBUG_sessprint( invt_session_t *ses );
@@ -572,7 +572,7 @@ bool_t
 lastsess_level_equalto( int fd, invt_seshdr_t *hdr,  void *arg, void **buf );
 
 int
-DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, u_int ref, 
+DEBUG_displayallsessions( int fd, invt_seshdr_t *hdr, uint ref, 
 			  invt_pr_ctx_t *prctx);
 
 int
diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
index 0b6aa45..0763d0b 100644
--- a/inventory/inv_stobj.c
+++ b/inventory/inv_stobj.c
@@ -62,7 +62,7 @@ stobj_insert_session( invt_idxinfo_t *idx,
 	/* Check the existing sessions to make sure that we're not
 	   duplicating this session */
 	if ( sescnt->ic_curnum > 0 ) {
-		u_int i;
+		uint i;
 		invt_session_t	*sessions = calloc( sescnt->ic_curnum, 
 				   sizeof( invt_session_t ) );
 		if ( GET_REC_NOLOCK( fd, sessions, sescnt->ic_curnum *
@@ -123,10 +123,10 @@ stobj_insert_session( invt_idxinfo_t *idx,
 
 
 /* ARGSUSED */
-u_int
-stobj_find_splitpoint( int fd, invt_seshdr_t *harr, u_int ns, time32_t tm )
+uint
+stobj_find_splitpoint( int fd, invt_seshdr_t *harr, uint ns, time32_t tm )
 {
-	u_int i;
+	uint i;
 
 	if ( harr[ns-1].sh_time < tm )
 		return ns;
@@ -165,7 +165,7 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
 	     invt_sessinfo_t *newsess )
 {
 	invt_seshdr_t 	*harr = NULL;
-	u_int          	i, ix, ns = sescnt->ic_curnum;
+	uint          	i, ix, ns = sescnt->ic_curnum;
 	void        	*bufpp;
 	size_t        	bufszp;
 	invt_sessinfo_t sesinfo;
@@ -341,7 +341,7 @@ stobj_put_session(
 		sescnt->ic_eof += (off64_t)( ses->s_max_nstreams * 
 					     sizeof( invt_stream_t ) );
 	} else {
-		u_int i;
+		uint i;
 		size_t nmf = 0;
 		sescnt->ic_eof += (off64_t)( ses->s_cur_nstreams * 
 					     sizeof( invt_stream_t ) );
@@ -386,7 +386,7 @@ stobj_put_session(
 /*----------------------------------------------------------------------*/
 
 int
-stobj_sortheaders( int fd, u_int num )
+stobj_sortheaders( int fd, uint num )
 {
 	size_t sz = sizeof( invt_seshdr_t ) * num;
 	invt_seshdr_t *hdrs;
@@ -440,11 +440,11 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
 {
-	u_int	nstm = ses->s_cur_nstreams;
+	uint	nstm = ses->s_cur_nstreams;
 	off64_t off  = hdr->sh_streams_off;
 	off64_t mfileoff = off + (off64_t)( nstm * sizeof( invt_stream_t ) );
-	u_int nmfiles = 0;
-	u_int i,j;
+	uint nmfiles = 0;
+	uint i,j;
 
 	/* fix the offsets in streams */
 	for ( i = 0; i < nstm; i++ ) {
@@ -737,7 +737,7 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
 		     void  **bufpp, size_t *bufszp )
 {
 	size_t	      	stmsz;
-	u_int		i, j;
+	uint		i, j;
 	size_t		sessz;
 	invt_stream_t  *strms;
 	char	       *sesbuf, *sesbufcp;
@@ -917,8 +917,8 @@ stobj_delete_mobj(int fd,
 	invt_stream_t  *strms;
 	off64_t		off;
 	invt_mediafile_t *mf, *mfiles;
-	u_int 		nmfiles;
-	u_int		i, j;
+	uint 		nmfiles;
+	uint		i, j;
 	bool_t 		dirty;
 
 	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
@@ -1007,7 +1007,7 @@ stobj_unpack_sessinfo(
         size_t             bufsz,
 	invt_sessinfo_t   *s )
 {
-	u_int 		 i;
+	uint 		 i;
 	char	         *tmpbuf;
 	char 		 *p = (char *)bufp;
 	
@@ -1090,7 +1090,7 @@ stobj_unpack_sessinfo(
 #ifdef INVT_DELETION
 	{
 		int tmpfd = open( "moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR );
-		u_int j;
+		uint j;
 		invt_mediafile_t *mmf = s->mfiles;
 		for (i=0; i< s->ses->s_cur_nstreams; i++ ) {
 			for (j=0; j< s->strms[ i ].st_nmediafiles; 
@@ -1235,7 +1235,7 @@ stobj_copy_invsess(int fd,
 	i = (int) ses->s_cur_nstreams;
 	while ( i-- ) {
 		off64_t		 off;
-		u_int            j, nmf;
+		uint            j, nmf;
 		
 		stobj_convert_strm(&ises->s_streams[i], &strms[i]);
 		nmf = strms[i].st_nmediafiles;
@@ -1305,7 +1305,7 @@ stobj_convert_sessinfo(inv_session_t **buf, invt_sessinfo_t *sinfo)
 	for ( i = 0 ; i < nstreams ; i++ ) {
 		stobj_convert_strm(&ises->s_streams[i], &sinfo->strms[i]);
 		nmf = (int) ises->s_streams[i].st_nmediafiles;
-		ises->s_streams[i].st_mediafiles = calloc( (u_int) nmf,
+		ises->s_streams[i].st_mediafiles = calloc( (uint) nmf,
 						    sizeof( inv_mediafile_t ) );
 
 		for ( j = 0; j < nmf; j++ ) {
@@ -1372,7 +1372,7 @@ bool_t
 check_for_mobj ( inv_session_t *ses, invt_mobjinfo_t *mobj )
 {
 	int i;
-	u_int j;
+	uint j;
 	inv_mediafile_t *mfp;
 
 	for (i = 0; i < (int) ses->s_nstreams; i++ ) {
@@ -1390,12 +1390,12 @@ check_for_mobj ( inv_session_t *ses, invt_mobjinfo_t *mobj )
 
 
 void
-DEBUG_sessionprint( inv_session_t *ses, u_int ref, invt_pr_ctx_t *prctx)
+DEBUG_sessionprint( inv_session_t *ses, uint ref, invt_pr_ctx_t *prctx)
 {
 	char str[UUID_STR_LEN + 1];
 	int i;
 	inv_mediafile_t *mfp;
-	static u_int fsidxprinted = -1;
+	static uint fsidxprinted = -1;
 
        invt_mobjinfo_t *mobj = &prctx->mobj;
 
@@ -1405,8 +1405,8 @@ DEBUG_sessionprint( inv_session_t *ses, u_int ref, invt_pr_ctx_t *prctx)
 			return;
 	}
 		
-	if ( ref == 0 || fsidxprinted != (u_int) prctx->index ) {
-		fsidxprinted = (u_int) prctx->index;
+	if ( ref == 0 || fsidxprinted != (uint) prctx->index ) {
+		fsidxprinted = (uint) prctx->index;
 
 		printf("file system %d:\n", prctx->index);
 		uuid_unparse( ses->s_fsid, str );
@@ -1435,7 +1435,7 @@ DEBUG_sessionprint( inv_session_t *ses, u_int ref, invt_pr_ctx_t *prctx)
 		return;
 
 	for (i = 0; i < (int) ses->s_nstreams; i++ ) {
-		u_int j;
+		uint j;
 		printf("\t\tstream %d:\n", i );
 		printf( "\t\t\tpathname:\t%s\n", ses->s_streams[i].st_cmdarg );
 		printf( "\t\t\tstart:\t\tino %llu offset %lld\n",
diff --git a/inventory/inventory.h b/inventory/inventory.h
index 43ac969..134b9ba 100644
--- a/inventory/inventory.h
+++ b/inventory/inventory.h
@@ -115,7 +115,7 @@ typedef enum {
 		     
 typedef struct inv_mediafile {
 	uuid_t		 m_moid;	/* media object id */
-	u_int		 m_mfile_index; /* index within the media object */
+	uint		 m_mfile_index; /* index within the media object */
 	xfs_ino_t	 m_startino;	/* file that we started out with */
 	off64_t		 m_startino_off;
 	xfs_ino_t	 m_endino;	/* the dump file we ended this .. */
@@ -139,7 +139,7 @@ typedef struct inv_stream {
 					   including this breakpoint. */
 	off64_t		st_endino_off;
 	char            st_cmdarg[INV_STRLEN]; /* the driver path user entered */
-	u_int		st_nmediafiles; /* number of mediafiles */
+	uint		st_nmediafiles; /* number of mediafiles */
 	inv_mediafile_t *st_mediafiles; /* array of all media files */
 } inv_stream_t;
 
@@ -161,9 +161,9 @@ typedef struct inv_session {
 	char		 s_label[INV_STRLEN];  /* session label */
 	char		 s_mountpt[INV_STRLEN];/* path to the mount point */
 	char		 s_devpath[INV_STRLEN];/* path to the device */
-	u_int		 s_nstreams;	/* num of media streams recorded */
+	uint		 s_nstreams;	/* num of media streams recorded */
 	inv_stream_t	*s_streams;	/* array of streams */
-        u_int            s_refnum;      /* storage location dependent ref.
+        uint            s_refnum;      /* storage location dependent ref.
 					   used in displaying the session and 
 					   nowhere else */
 					   
@@ -206,7 +206,7 @@ inv_writesession_open(
 	bool_t		ispartial,
         bool_t          isresumed,
 	u_char		level,
-	u_int		nstreams,
+	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
 	char		*devpath );	      
@@ -230,7 +230,7 @@ inv_put_mediafile(
 	inv_stmtoken_t 	tok, 
 	uuid_t 		*moid, 
 	char 		*label,
-	u_int		mfileindex,
+	uint		mfileindex,
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
 	xfs_ino_t	endino,
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 7a268ea..3f742e4 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -145,7 +145,7 @@ delete_test( int n )
 int
 sess_queries_byuuid(char *uu)
 {
-	u_int stat;
+	uint stat;
 	uuid_t uuid;
 	inv_session_t *ses;
 	invt_pr_ctx_t prctx;
diff --git a/invutil/invidx.c b/invutil/invidx.c
index 56995f0..44c5e7f 100644
--- a/invutil/invidx.c
+++ b/invutil/invidx.c
@@ -626,11 +626,11 @@ stobj_put_streams( int fd, invt_seshdr_t *hdr, invt_session_t *ses,
 		   invt_stream_t *strms,
 		   invt_mediafile_t *mfiles )
 {
-    u_int	nstm	= ses->s_cur_nstreams;
+    uint	nstm	= ses->s_cur_nstreams;
     off64_t	off	= hdr->sh_streams_off;
     off64_t	mfileoff= off + (off64_t)( nstm * sizeof( invt_stream_t ) );
-    u_int	nmfiles = 0;
-    u_int	i,j;
+    uint	nmfiles = 0;
+    uint	i,j;
 
     /* fix the offsets in streams */
      for ( i = 0; i < nstm; i++ ) {
diff --git a/restore/content.c b/restore/content.c
index ac7d72a..5e6e88e 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -526,10 +526,10 @@ struct pers {
 			/* the following stats are not valid until the
 			 * first media file header has been read.
 			 */
-		u_int64_t stat_inocnt;
+		uint64_t stat_inocnt;
 			/* number of non-dir inos to restore during session
 			 */
-		u_int64_t stat_inodone;
+		uint64_t stat_inodone;
 			/* number of non-dir inos restored so far
 			 */
 		off64_t stat_datacnt;
@@ -1615,11 +1615,11 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			      strerror( errno ));
 			return BOOL_FALSE;
 		}
-		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( u_int64_t )0 );
+		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
 		if ( ! ok ) {
 			return BOOL_FALSE;
 		}
-		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( u_int64_t )0 );
+		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
 		if ( ! ok ) {
 			return BOOL_FALSE;
 		}
@@ -1841,7 +1841,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * determine if full init needed instead.
 	 */
 	if ( persp->a.valpr && persp->s.valpr ) {
-		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( u_int64_t )0 );
+		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
 		if ( ! ok ) {
 			return BOOL_FALSE;
 		}
@@ -1853,7 +1853,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * determine if full init needed instead.
 	 */
 	if ( persp->a.valpr ) {
-		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( u_int64_t )0 );
+		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
 		if ( ! ok ) {
 			return BOOL_FALSE;
 		}
@@ -7532,7 +7532,7 @@ restore_reg( drive_t *drivep,
 		assert( bstatp->bs_extsize >= 0 );
 		memset((void *)&fsxattr, 0, sizeof( fsxattr ));
 		fsxattr.fsx_xflags = bstatp->bs_xflags & ~POST_DATA_XFLAGS;
-		fsxattr.fsx_extsize = (u_int32_t) bstatp->bs_extsize;
+		fsxattr.fsx_extsize = (uint32_t) bstatp->bs_extsize;
 		fsxattr.fsx_projid = bstat_projid(bstatp);
 
 		rval = ioctl( *fdp, XFS_IOC_FSSETXATTR, (void *)&fsxattr);
@@ -7753,7 +7753,7 @@ restore_complete_reg(stream_context_t *strcxtp)
 		struct fsxattr fsxattr;
 		memset((void *)&fsxattr, 0, sizeof( fsxattr ));
 		fsxattr.fsx_xflags = bstatp->bs_xflags;
-		fsxattr.fsx_extsize = (u_int32_t)bstatp->bs_extsize;
+		fsxattr.fsx_extsize = (uint32_t)bstatp->bs_extsize;
 		fsxattr.fsx_projid = bstat_projid(bstatp);
 
 		rval = ioctl( fd, XFS_IOC_FSSETXATTR, (void *)&fsxattr );
@@ -8364,8 +8364,8 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	mlog( MLOG_NITTY,
 	      "read extattr hdr sz %u valoff %u flags 0x%x valsz %u cs 0x%x\n",
 	      ahdrp->ah_sz,
-	      ( u_int )ahdrp->ah_valoff,
-	      ( u_int )ahdrp->ah_flags,
+	      ( uint )ahdrp->ah_valoff,
+	      ( uint )ahdrp->ah_flags,
 	      ahdrp->ah_valsz,
 	      ahdrp->ah_checksum );
 
diff --git a/restore/dirattr.c b/restore/dirattr.c
index d8d5140..7a423ab 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -71,7 +71,7 @@
 #define	HDLSUMMASK		( HDLSUMLOMASK << HDLSUMSHIFT )
 #define HDLDIXCNT		HDLSUMSHIFT
 #define HDLDIXMASK		( ( 1 << HDLDIXCNT ) - 1 )
-#define HDLGETSUM( h )		( ( u_int16_t )				\
+#define HDLGETSUM( h )		( ( uint16_t )				\
 				  ( ( ( int )h >> HDLSUMSHIFT )		\
 				    &					\
 				    HDLSUMLOMASK ))
@@ -104,8 +104,8 @@
  */
 struct dirattr {
 #ifdef DIRATTRCHK
-	u_int16_t d_unq;
-	u_int16_t d_sum; 
+	uint16_t d_unq;
+	uint16_t d_sum; 
 #endif /* DIRATTRCHK */
 	mode_t d_mode;
 	uid_t d_uid;
@@ -113,11 +113,11 @@ struct dirattr {
 	time32_t d_atime;
 	time32_t d_mtime;
 	time32_t d_ctime;
-	u_int32_t d_xflags;
-	u_int32_t d_extsize;
-	u_int32_t d_projid;
-	u_int32_t d_dmevmask;
-	u_int32_t d_dmstate;
+	uint32_t d_xflags;
+	uint32_t d_extsize;
+	uint32_t d_projid;
+	uint32_t d_dmevmask;
+	uint32_t d_dmstate;
 	off64_t d_extattroff;
 };
 
@@ -181,7 +181,7 @@ extern size_t pgsz;
 static void dirattr_get( dah_t );
 static void dirattr_cacheflush( void );
 #ifdef DIRATTRCHK
-static u_int16_t calcdixcum( dix_t dix );
+static uint16_t calcdixcum( dix_t dix );
 #endif /* DIRATTRCHK */
 
 
@@ -199,7 +199,7 @@ static dirattr_pers_t *dpp = 0;
 /* definition of locally defined global functions ****************************/
 
 bool_t
-dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
+dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 {
 	if ( dtp ) {
 		return BOOL_TRUE;
@@ -392,7 +392,7 @@ dirattr_add( filehdr_t *fhdrp )
 	off64_t oldoff;
 	dix_t dix;
 #ifdef DIRATTRCHK
-	u_int16_t sum;
+	uint16_t sum;
 #endif /* DIRATTRCHK */
 	dah_t dah;
 	
@@ -437,10 +437,10 @@ dirattr_add( filehdr_t *fhdrp )
 	dirattr.d_mtime = ( time32_t )fhdrp->fh_stat.bs_mtime.tv_sec;
 	dirattr.d_ctime = ( time32_t )fhdrp->fh_stat.bs_ctime.tv_sec;
 	dirattr.d_xflags = fhdrp->fh_stat.bs_xflags;
-	dirattr.d_extsize = ( u_int32_t )fhdrp->fh_stat.bs_extsize;
+	dirattr.d_extsize = ( uint32_t )fhdrp->fh_stat.bs_extsize;
 	dirattr.d_projid = bstat_projid(&(fhdrp->fh_stat));
 	dirattr.d_dmevmask = fhdrp->fh_stat.bs_dmevmask;
-	dirattr.d_dmstate = ( u_int32_t )fhdrp->fh_stat.bs_dmstate;
+	dirattr.d_dmstate = ( uint32_t )fhdrp->fh_stat.bs_dmstate;
 #ifdef DIRATTRCHK
 	dirattr.d_unq = DIRATTRUNQ;
 	sum = calcdixcum( dix );
@@ -753,7 +753,7 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
 {
 	dix_t dix;
 #ifdef DIRATTRCHK
-	u_int16_t sum;
+	uint16_t sum;
 #endif /* DIRATTRCHK */
 	off64_t argoff;
 	off64_t newoff;
@@ -815,10 +815,10 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
 	dirattr.d_mtime = ( time32_t )fhdrp->fh_stat.bs_mtime.tv_sec;
 	dirattr.d_ctime = ( time32_t )fhdrp->fh_stat.bs_ctime.tv_sec;
 	dirattr.d_xflags = fhdrp->fh_stat.bs_xflags;
-	dirattr.d_extsize = ( u_int32_t )fhdrp->fh_stat.bs_extsize;
+	dirattr.d_extsize = ( uint32_t )fhdrp->fh_stat.bs_extsize;
 	dirattr.d_projid = bstat_projid(&(fhdrp->fh_stat));
 	dirattr.d_dmevmask = fhdrp->fh_stat.bs_dmevmask;
-	dirattr.d_dmstate = ( u_int32_t )fhdrp->fh_stat.bs_dmstate;
+	dirattr.d_dmstate = ( uint32_t )fhdrp->fh_stat.bs_dmstate;
 	dirattr.d_extattroff = DIRATTR_EXTATTROFFNULL;
 
 	/* write the dirattr
@@ -883,35 +883,35 @@ dirattr_get_ctime( dah_t dah )
 	return dtp->dt_cached_dirattr.d_ctime;
 }
 
-u_int32_t
+uint32_t
 dirattr_get_xflags( dah_t dah )
 {
 	dirattr_get( dah );
 	return dtp->dt_cached_dirattr.d_xflags;
 }
 
-u_int32_t
+uint32_t
 dirattr_get_extsize( dah_t dah )
 {
 	dirattr_get( dah );
 	return dtp->dt_cached_dirattr.d_extsize;
 }
 
-u_int32_t
+uint32_t
 dirattr_get_projid( dah_t dah )
 {
 	dirattr_get( dah );
 	return dtp->dt_cached_dirattr.d_projid;
 }
 
-u_int32_t
+uint32_t
 dirattr_get_dmevmask( dah_t dah )
 {
 	dirattr_get( dah );
 	return dtp->dt_cached_dirattr.d_dmevmask;
 }
 
-u_int32_t
+uint32_t
 dirattr_get_dmstate( dah_t dah )
 {
 	dirattr_get( dah );
@@ -960,7 +960,7 @@ dirattr_get( dah_t dah )
 	off64_t newoff;
 	int nread;
 #ifdef DIRATTRCHK
-	u_int16_t sum;
+	uint16_t sum;
 #endif /* DIRATTRCHK */
 
 	/* sanity checks
@@ -1036,7 +1036,7 @@ dirattr_cacheflush( void )
 	dah_t dah;
 	dix_t dix;
 #ifdef DIRATTRCHK
-	u_int16_t sum;
+	uint16_t sum;
 #endif /* DIRATTRCHK */
 	off64_t argoff;
 	off64_t newoff;
@@ -1103,10 +1103,10 @@ dirattr_cacheflush( void )
 
 #ifdef DIRATTRCHK
 
-static u_int16_t
+static uint16_t
 calcdixcum( dix_t dix )
 {
-	u_int16_t sum;
+	uint16_t sum;
 	ix_t nibcnt;
 	ix_t nibix;
 
@@ -1115,10 +1115,10 @@ calcdixcum( dix_t dix )
 	nibcnt = ( sizeof( dah_t ) / HDLSUMCNT ) - 1;
 	sum = 0;
 	for ( nibix = 0 ; nibix < nibcnt ; nibix++ ) {
-		sum += ( u_int16_t )( dix & HDLSUMLOMASK );
+		sum += ( uint16_t )( dix & HDLSUMLOMASK );
 		dix >>= HDLSUMCNT;
 	}
-	sum = ( u_int16_t )( ( ~sum + 1 ) & HDLSUMLOMASK );
+	sum = ( uint16_t )( ( ~sum + 1 ) & HDLSUMLOMASK );
 
 	return sum;
 }
diff --git a/restore/dirattr.h b/restore/dirattr.h
index d671883..aaf276d 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -33,7 +33,7 @@ typedef size32_t dah_t;
  */
 extern bool_t dirattr_init( char *housekeepingdir,
 			    bool_t resync,
-			    u_int64_t dircnt );
+			    uint64_t dircnt );
 
 
 /* dirattr_cleanup - removes all traces
@@ -62,11 +62,11 @@ gid_t dirattr_get_gid( dah_t dah );
 time32_t dirattr_get_atime( dah_t dah );
 time32_t dirattr_get_mtime( dah_t dah );
 time32_t dirattr_get_ctime( dah_t dah );
-u_int32_t dirattr_get_xflags( dah_t dah );
-u_int32_t dirattr_get_extsize( dah_t dah );
-u_int32_t dirattr_get_projid( dah_t dah );
-u_int32_t dirattr_get_dmevmask( dah_t dah );
-u_int32_t dirattr_get_dmstate( dah_t dah );
+uint32_t dirattr_get_xflags( dah_t dah );
+uint32_t dirattr_get_extsize( dah_t dah );
+uint32_t dirattr_get_projid( dah_t dah );
+uint32_t dirattr_get_dmevmask( dah_t dah );
+uint32_t dirattr_get_dmstate( dah_t dah );
 
 /* dirattr_flush - flush dirattr I/O buffer.  Returns 0 if successful.
  */
diff --git a/restore/inomap.c b/restore/inomap.c
index f1604c4..fd55907 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -92,8 +92,8 @@ static int pers_fd = -1;
 
 /* context for inomap construction - initialized by inomap_restore_pers
  */
-static u_int64_t hnkcnt;
-static u_int64_t segcnt;
+static uint64_t hnkcnt;
+static uint64_t segcnt;
 static hnk_t *roothnkp = 0;
 static hnk_t *tailhnkp;
 static seg_t *lastsegp;
@@ -106,10 +106,10 @@ static inline void
 SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 {
 	register xfs_ino_t relino;
-	register u_int64_t mask;
-	register u_int64_t clrmask;
+	register uint64_t mask;
+	register uint64_t clrmask;
 	relino = ino - segp->base;
-	mask = ( u_int64_t )1 << relino;
+	mask = ( uint64_t )1 << relino;
 	clrmask = ~mask;
 	switch( state ) {
 	case 0:
@@ -160,9 +160,9 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 {
 	int state;
 	register xfs_ino_t relino;
-	register u_int64_t mask;
+	register uint64_t mask;
 	relino = ino - segp->base;
-	mask = ( u_int64_t )1 << relino;
+	mask = ( uint64_t )1 << relino;
 	if ( segp->lobits & mask ) {
 		state = 1;
 	} else {
@@ -310,7 +310,7 @@ rv_t
 inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	u_int64_t tmphnkcnt;
+	uint64_t tmphnkcnt;
 	/* REFERENCED */
 	int nread;
 	int rval;
@@ -654,10 +654,10 @@ map_getset( xfs_ino_t ino, int newstate, bool_t setflag )
 static seg_t *
 map_getsegment( xfs_ino_t ino )
 {
-	u_int64_t min;
-	u_int64_t max;
-	u_int64_t hnk;
-	u_int64_t seg;
+	uint64_t min;
+	uint64_t max;
+	uint64_t hnk;
+	uint64_t seg;
 
 	/* Use binary search to find the hunk that contains the inode number,
 	 * if any.  This counts on the fact that all the hunks are contiguous
diff --git a/restore/inomap.h b/restore/inomap.h
index bc40f3e..03facdb 100644
--- a/restore/inomap.h
+++ b/restore/inomap.h
@@ -48,9 +48,9 @@
  */
 struct seg {
 	xfs_ino_t base;
-	u_int64_t lobits;
-	u_int64_t mebits;
-	u_int64_t hibits;
+	uint64_t lobits;
+	uint64_t mebits;
+	uint64_t hibits;
 };
 
 typedef struct seg seg_t;
diff --git a/restore/namreg.c b/restore/namreg.c
index 8c3b74f..97e6524 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -116,7 +116,7 @@ static namreg_pers_t *npp = 0;
 /* definition of locally defined global functions ****************************/
 
 bool_t
-namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
+namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 {
 	if ( ntp ) {
 		return BOOL_TRUE;
diff --git a/restore/namreg.h b/restore/namreg.h
index 8bc7b53..859ccd7 100644
--- a/restore/namreg.h
+++ b/restore/namreg.h
@@ -36,7 +36,7 @@ typedef size64_t nrh_t;
  */
 extern bool_t namreg_init( char *housekeepingdir,
 			   bool_t resync,
-			   u_int64_t inocnt );
+			   uint64_t inocnt );
 
 
 /* namreg_add - registers a name. name does not need to be null-terminated.
diff --git a/restore/tree.c b/restore/tree.c
index 46ba715..363f0f1 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -349,7 +349,7 @@ tree_init( char *hkdir,
 	   bool_t fullpr,
 	   bool_t restoredmpr,
 	   bool_t dstdirisxfspr,
-	   u_int32_t dumpformat,
+	   uint32_t dumpformat,
 	   bool_t truncategenpr )
 {
 	off64_t nodeoff;
@@ -661,7 +661,7 @@ tree_sync( char *hkdir,
 }
 
 bool_t
-tree_check_dump_format( u_int32_t dumpformat )
+tree_check_dump_format( uint32_t dumpformat )
 {
 	if ( dumpformat < GLOBAL_HDR_VERSION_3 && !persp->p_truncategenpr ) {
 		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_TREE, _(
@@ -2554,7 +2554,7 @@ setdirattr( dah_t dah, char *path )
 
 		fssetdm.fsd_dmevmask = dirattr_get_dmevmask( dah );
 		fssetdm.fsd_padding = 0;	/* not used */
-		fssetdm.fsd_dmstate = ( u_int16_t )dirattr_get_dmstate( dah );
+		fssetdm.fsd_dmstate = ( uint16_t )dirattr_get_dmstate( dah );
 
 		/* restore DMAPI event settings etc.
 		 */
diff --git a/restore/tree.h b/restore/tree.h
index 7b1a76a..47911c4 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -33,7 +33,7 @@ extern bool_t tree_init( char *hkdir,
 			 bool_t fullpr,
 			 bool_t restoredmpr,
 			 bool_t dstdirisxfspr,
-			 u_int32_t dumpformat,
+			 uint32_t dumpformat,
 			 bool_t truncategenpr );
 
 /* tree_sync - synchronizes with an existing tree abstraction
@@ -50,7 +50,7 @@ extern bool_t tree_sync( char *hkdir,
  * a format 2 dump. the restore will fail unless the
  * original restore was told to use format 2 gen numbers.
  */
-extern bool_t tree_check_dump_format( u_int32_t dumpformat );
+extern bool_t tree_check_dump_format( uint32_t dumpformat );
 
 
 /* tree_begindir - begins application of dumped directory to tree.
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
