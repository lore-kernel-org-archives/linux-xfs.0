Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfANR0B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:01 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD0E37CDE4
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:00 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/13] xfsdump: (3/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:18 +0100
Message-Id: <20190114172528.65250-4-jtulak@redhat.com>
In-Reply-To: <20190114172528.65250-1-jtulak@redhat.com>
References: <20190114172528.65250-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Transform "( x, y )" to "(x, y)", and the same for [].

Created by this script:
*****
#!/usr/bin/env bash
# transform 'foo( x, y )' -> 'foo(x, y)'
set -euo pipefail

# regexps in order:
# - remove spaces after opening parentheses (
# - remove spaces after opening brackets [
# - remove spaces before closing parentheses )
# - remove spaces before closing brackets ]
#
# Run multiple iterations to get all overlapping matches.

for i in {1..8}; do
    echo "iteration $i"
    find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
        $0 = gensub(/^([^"]*)\(\s+/, "\\1(", "g")
        $0 = gensub(/^([^"]*)\[\s+/, "\\1[", "g")
        $0 = gensub(/(\S)\s+\)([^"]*)$/, "\\1)\\2", "g")
        $0 = gensub(/(\S)\s+\]([^"]*)$/, "\\1]\\2", "g")
    }; {print }' {} \;
done


# Revert changes in defines that would cause redefinition error
sed -i \
    -e 's/^#define sizeofmember.*$/#define sizeofmember( t, m )\tsizeof( ( ( t * )0 )->m )/' \
    -e 's/^#define offsetofmember.*$/#define offsetofmember( t, m )\t( ( size_t )( char * )\&( ( ( t * )0 )->m ) )/' \
    common/types.h

*****

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/drive_scsitape.c | 2948 +++++++++++++++++++--------------------
 1 file changed, 1474 insertions(+), 1474 deletions(-)

diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index c360f9c..5c9ee89 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -257,11 +257,11 @@ typedef struct drive_context drive_context_t;
 /* macros for shortcut references to context. assumes a local variable named
  * 'contextp'.
  */
-#define	tape_recsz	( contextp->dc_recsz )
-#define	tape_blksz	( contextp->dc_blksz )
+#define	tape_recsz	(contextp->dc_recsz)
+#define	tape_blksz	(contextp->dc_blksz)
 
 /* macros to interpret tape status information returned by reference from
- * mt_get_status( ).
+ * mt_get_status().
  */
 	/* tape is positioned at end-of-tape   			*/
 #define IS_EOT(mtstat)		GMT_EOT(mtstat)
@@ -284,116 +284,116 @@ typedef long mtstat_t;
 
 /* declarations of externally defined global variables ***********************/
 
-extern void usage( void );
+extern void usage(void);
 #ifdef DUMP
 extern uint64_t hdr_mfilesz;
 #endif /* DUMP */
 
 /* remote tape protocol declarations (should be a system header file)
  */
-extern int rmtopen( char *, int, ... );
-extern int rmtclose( int );
-extern int rmtfstat( int, struct stat * );
-extern int rmtioctl( int, int, ... );
-extern int rmtread( int, void*, uint);
-extern int rmtwrite( int, const void *, uint);
+extern int rmtopen(char *, int, ...);
+extern int rmtclose(int);
+extern int rmtfstat(int, struct stat *);
+extern int rmtioctl(int, int, ...);
+extern int rmtread(int, void*, uint);
+extern int rmtwrite(int, const void *, uint);
 
 
 /* forward declarations of locally defined static functions ******************/
 
 /* strategy functions
  */
-static int ds_match( int, char *[], drive_t * );
-static int ds_instantiate( int, char *[], drive_t * );
+static int ds_match(int, char *[], drive_t *);
+static int ds_instantiate(int, char *[], drive_t *);
 
 /* manager operations
  */
-static bool_t do_init( drive_t * );
-static bool_t do_sync( drive_t * );
-static int do_begin_read( drive_t * );
-static char *do_read( drive_t *, size_t , size_t *, int * );
-static void do_return_read_buf( drive_t *, char *, size_t );
-static void do_get_mark( drive_t *, drive_mark_t * );
-static int do_seek_mark( drive_t *, drive_mark_t * );
-static int do_next_mark( drive_t * );
-static void do_get_mark( drive_t *, drive_mark_t * );
-static void do_end_read( drive_t * );
-static int do_begin_write( drive_t * );
-static void do_set_mark( drive_t *, drive_mcbfp_t, void *, drive_markrec_t * );
-static char * do_get_write_buf( drive_t *, size_t , size_t * );
-static int do_write( drive_t *, char *, size_t );
-static size_t do_get_align_cnt( drive_t * );
-static int do_end_write( drive_t *, off64_t * );
-static int do_fsf( drive_t *, int , int *);
-static int do_bsf( drive_t *, int , int *);
-static int do_rewind( drive_t * );
-static int do_erase( drive_t * );
-static int do_eject_media( drive_t * );
-static int do_get_device_class( drive_t * );
-static void do_display_metrics( drive_t *drivep );
-static void do_quit( drive_t * );
+static bool_t do_init(drive_t *);
+static bool_t do_sync(drive_t *);
+static int do_begin_read(drive_t *);
+static char *do_read(drive_t *, size_t , size_t *, int *);
+static void do_return_read_buf(drive_t *, char *, size_t);
+static void do_get_mark(drive_t *, drive_mark_t *);
+static int do_seek_mark(drive_t *, drive_mark_t *);
+static int do_next_mark(drive_t *);
+static void do_get_mark(drive_t *, drive_mark_t *);
+static void do_end_read(drive_t *);
+static int do_begin_write(drive_t *);
+static void do_set_mark(drive_t *, drive_mcbfp_t, void *, drive_markrec_t *);
+static char * do_get_write_buf(drive_t *, size_t , size_t *);
+static int do_write(drive_t *, char *, size_t);
+static size_t do_get_align_cnt(drive_t *);
+static int do_end_write(drive_t *, off64_t *);
+static int do_fsf(drive_t *, int , int *);
+static int do_bsf(drive_t *, int , int *);
+static int do_rewind(drive_t *);
+static int do_erase(drive_t *);
+static int do_eject_media(drive_t *);
+static int do_get_device_class(drive_t *);
+static void do_display_metrics(drive_t *drivep);
+static void do_quit(drive_t *);
 
 /* misc. local utility funcs
  */
-static int	mt_op(int , int , int );
-static int mt_blkinfo(int , struct mtblkinfo * );
-static bool_t mt_get_fileno( drive_t *, long *);
-static bool_t mt_get_status( drive_t *, mtstat_t *);
-static int determine_write_error( drive_t *, int, int );
-static int read_label( drive_t *);
-static bool_t tape_rec_checksum_check( drive_context_t *, char * );
-static void set_recommended_sizes( drive_t * );
-static void display_access_failed_message( drive_t *);
-static void status_failed_message( drive_t *);
-static bool_t get_tpcaps( drive_t * );
-static bool_t set_fixed_blksz( drive_t *, size_t );
-static int prepare_drive( drive_t *drivep );
-static bool_t Open( drive_t *drivep );
-static void Close( drive_t *drivep );
-static int Read( drive_t *drivep,
+static int	mt_op(int , int , int);
+static int mt_blkinfo(int , struct mtblkinfo *);
+static bool_t mt_get_fileno(drive_t *, long *);
+static bool_t mt_get_status(drive_t *, mtstat_t *);
+static int determine_write_error(drive_t *, int, int);
+static int read_label(drive_t *);
+static bool_t tape_rec_checksum_check(drive_context_t *, char *);
+static void set_recommended_sizes(drive_t *);
+static void display_access_failed_message(drive_t *);
+static void status_failed_message(drive_t *);
+static bool_t get_tpcaps(drive_t *);
+static bool_t set_fixed_blksz(drive_t *, size_t);
+static int prepare_drive(drive_t *drivep);
+static bool_t Open(drive_t *drivep);
+static void Close(drive_t *drivep);
+static int Read(drive_t *drivep,
 		      char *bufp,
 		      size_t cnt,
-		      int *errnop );
-static int Write( drive_t *drivep,
+		      int *errnop);
+static int Write(drive_t *drivep,
 		       char *bufp,
 		       size_t cnt,
-		       int *saved_errnop );
-static int quick_backup( drive_t *drivep,
+		       int *saved_errnop);
+static int quick_backup(drive_t *drivep,
 			      drive_context_t *contextp,
-			      ix_t skipcnt );
-static int record_hdr_validate( drive_t *drivep,
+			      ix_t skipcnt);
+static int record_hdr_validate(drive_t *drivep,
 				     char *bufp,
-				     bool_t chkoffpr );
-static int ring_read( void *clientctxp, char *bufp );
-static int ring_write( void *clientctxp, char *bufp );
-static double percent64( off64_t num, off64_t denom );
-static int getrec( drive_t *drivep );
-static int write_record( drive_t *drivep, char *bufp, bool_t chksumpr,
-                              bool_t xlatepr );
-static ring_msg_t * Ring_get( ring_t *ringp );
-static void Ring_reset(  ring_t *ringp, ring_msg_t *msgp );
-static void Ring_put(  ring_t *ringp, ring_msg_t *msgp );
-static int validate_media_file_hdr( drive_t *drivep );
-static void calc_max_lost( drive_t *drivep );
-static void display_ring_metrics( drive_t *drivep, int mlog_flags );
-static mtstat_t rewind_and_verify( drive_t *drivep );
-static mtstat_t erase_and_verify( drive_t *drivep );
-static mtstat_t bsf_and_verify( drive_t *drivep );
-static mtstat_t fsf_and_verify( drive_t *drivep );
-static void calc_best_blk_and_rec_sz( drive_t *drivep );
-static bool_t set_best_blk_and_rec_sz( drive_t *drivep );
-static bool_t isefsdump( drive_t *drivep );
-static int get_driver_character_major( const char * );
-static void map_ts_status( struct mtget *, struct mtget_sgi );
+				     bool_t chkoffpr);
+static int ring_read(void *clientctxp, char *bufp);
+static int ring_write(void *clientctxp, char *bufp);
+static double percent64(off64_t num, off64_t denom);
+static int getrec(drive_t *drivep);
+static int write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
+                              bool_t xlatepr);
+static ring_msg_t * Ring_get(ring_t *ringp);
+static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
+static void Ring_put(ring_t *ringp, ring_msg_t *msgp);
+static int validate_media_file_hdr(drive_t *drivep);
+static void calc_max_lost(drive_t *drivep);
+static void display_ring_metrics(drive_t *drivep, int mlog_flags);
+static mtstat_t rewind_and_verify(drive_t *drivep);
+static mtstat_t erase_and_verify(drive_t *drivep);
+static mtstat_t bsf_and_verify(drive_t *drivep);
+static mtstat_t fsf_and_verify(drive_t *drivep);
+static void calc_best_blk_and_rec_sz(drive_t *drivep);
+static bool_t set_best_blk_and_rec_sz(drive_t *drivep);
+static bool_t isefsdump(drive_t *drivep);
+static int get_driver_character_major(const char *);
+static void map_ts_status(struct mtget *, struct mtget_sgi);
 
 /* RMT trace stubs
  */
 #ifdef RMTDBG
-static int dbgrmtopen( char *, int );
-static int dbgrmtclose( int );
-static int dbgrmtioctl( int, int, void *);
-static int dbgrmtread( int, void*, uint);
-static int dbgrmtwrite( int, void *, uint);
+static int dbgrmtopen(char *, int);
+static int dbgrmtclose(int);
+static int dbgrmtioctl(int, int, void *);
+static int dbgrmtread(int, void*, uint);
+static int dbgrmtwrite(int, void *, uint);
 #endif /* RMTDBG */
 
 /* definition of locally defined global variables ****************************/
@@ -462,11 +462,11 @@ is_scsi_driver(char *pathname)
 		return BOOL_FALSE;
 	}
 
-	if ( stat64( pathname, &statbuf ) == -1) {
+	if (stat64(pathname, &statbuf) == -1) {
 		return BOOL_FALSE;
 	}
 
-	if ( !S_ISCHR( statbuf.st_mode )) {
+	if (!S_ISCHR(statbuf.st_mode)) {
 		return BOOL_FALSE;
 	}
 
@@ -510,7 +510,7 @@ is_scsi_driver(char *pathname)
  */
 /* ARGSUSED */
 static int
-ds_match( int argc, char *argv[], drive_t *drivep )
+ds_match(int argc, char *argv[], drive_t *drivep)
 {
 	struct mtget mt_stat;
 	int fd;
@@ -518,21 +518,21 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 	/* heuristics to determine if this is a drive.
 	 */
 
-	if ( ! strcmp( drivep->d_pathname, "stdio" )) {
+	if (! strcmp(drivep->d_pathname, "stdio")) {
 		return -10;
 	}
 
-	if ( strchr( drivep->d_pathname, ':')) {
+	if (strchr(drivep->d_pathname, ':')) {
 		errno = 0;
-		fd = open( drivep->d_pathname, O_RDONLY );
-		if ( fd < 0 ) {
+		fd = open(drivep->d_pathname, O_RDONLY);
+		if (fd < 0) {
 			return -10;
 		}
-		if ( ioctl( fd, MTIOCGET, &mt_stat ) < 0 ) {
-			close( fd );
+		if (ioctl(fd, MTIOCGET, &mt_stat) < 0) {
+			close(fd);
 			return -10;
 		}
-		close( fd );
+		close(fd);
 		return 10;
 	} else {
                 if (is_scsi_driver(drivep->d_pathname)) {
@@ -548,18 +548,18 @@ ds_match( int argc, char *argv[], drive_t *drivep )
  */
 /*ARGSUSED*/
 static bool_t
-ds_instantiate( int argc, char *argv[], drive_t *drivep )
+ds_instantiate(int argc, char *argv[], drive_t *drivep)
 {
 	drive_context_t *contextp;
 	int c;
 
 	/* opportunity for sanity checking
 	 */
-	assert( sizeof( global_hdr_t ) <= STAPE_HDR_SZ );
-	assert( sizeof( rec_hdr_t )
+	assert(sizeof(global_hdr_t) <= STAPE_HDR_SZ);
+	assert(sizeof(rec_hdr_t)
 		==
-		sizeofmember( drive_hdr_t, dh_specific ));
-	assert( ! ( STAPE_MAX_RECSZ % PGSZ ));
+		sizeofmember(drive_hdr_t, dh_specific));
+	assert(! (STAPE_MAX_RECSZ % PGSZ));
 
 	/* hook up the drive ops
 	 */
@@ -567,9 +567,9 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 
 	/* allocate context for the drive manager
 	 */
-	contextp = ( drive_context_t * )calloc( 1, sizeof( drive_context_t ));
-	assert( contextp );
-	memset( ( void * )contextp, 0, sizeof( *contextp ));
+	contextp = (drive_context_t *)calloc(1, sizeof(drive_context_t));
+	assert(contextp);
+	memset((void *)contextp, 0, sizeof(*contextp));
 
 	/* do not enable a separate I/O thread,
 	 * more testing to be done first...
@@ -589,26 +589,26 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 #endif
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_RINGLEN:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      c );
+				      c);
 				return BOOL_FALSE;
 			}
-			contextp->dc_ringlen = ( size_t )atoi( optarg );
-			if ( contextp->dc_ringlen < RINGLEN_MIN
+			contextp->dc_ringlen = (size_t)atoi(optarg);
+			if (contextp->dc_ringlen < RINGLEN_MIN
 			     ||
-			     contextp->dc_ringlen > RINGLEN_MAX ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+			     contextp->dc_ringlen > RINGLEN_MAX) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("-%c argument must be "
 				      "between %u and %u: ignoring %u\n"),
 				      c,
 				      RINGLEN_MIN,
 				      RINGLEN_MAX,
-				      contextp->dc_ringlen );
+				      contextp->dc_ringlen);
 				return BOOL_FALSE;
 			}
 			break;
@@ -625,33 +625,33 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 			contextp->dc_isQICpr = BOOL_TRUE;
 			break;
 		case GETOPT_BLOCKSIZE:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-			    mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			if (! optarg || optarg[0] == '-') {
+			    mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				    _("-%c argument missing\n"),
-				    c );
+				    c);
 			    return -10;
 			}
-			cmdlineblksize = ( uint32_t )atoi( optarg );
+			cmdlineblksize = (uint32_t)atoi(optarg);
 			break;
 #ifdef DUMP
 		case GETOPT_OVERWRITE:
 			contextp->dc_overwritepr = BOOL_TRUE;
 			break;
 		case GETOPT_FILESZ:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      c );
+				      c);
 				return BOOL_FALSE;
 			}
                         /* given in Mb */
-			contextp->dc_filesz = (off64_t)atoi( optarg ) * 1024 * 1024;
+			contextp->dc_filesz = (off64_t)atoi(optarg) * 1024 * 1024;
                         if (contextp->dc_filesz <= 0) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("-%c argument must be a "
 				      "positive number (Mb): ignoring %u\n"),
 				      c,
-				      contextp->dc_filesz );
+				      contextp->dc_filesz);
 				return BOOL_FALSE;
                         }
 			break;
@@ -675,37 +675,37 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	/* if threads not allowed, allocate a record buffer. otherwise
 	 * create a ring, from which buffers will be taken.
 	 */
-	if ( contextp->dc_singlethreadedpr ) {
-		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
-		assert( contextp->dc_bufp );
+	if (contextp->dc_singlethreadedpr) {
+		contextp->dc_bufp = (char *)memalign(PGSZ, STAPE_MAX_RECSZ);
+		assert(contextp->dc_bufp);
 	} else {
 		int rval;
-		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
+		mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
 		      "ring op: create: ringlen == %u\n",
-		      contextp->dc_ringlen );
-		contextp->dc_ringp = ring_create( contextp->dc_ringlen,
+		      contextp->dc_ringlen);
+		contextp->dc_ringp = ring_create(contextp->dc_ringlen,
 						  STAPE_MAX_RECSZ,
 						  contextp->dc_ringpinnedpr,
 						  drivep->d_index,
 						  ring_read,
 						  ring_write,
-						  ( void * )drivep,
-						  &rval );
-		if ( ! contextp->dc_ringp ) {
-			if ( rval == ENOMEM ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+						  (void *)drivep,
+						  &rval);
+		if (! contextp->dc_ringp) {
+			if (rval == ENOMEM) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("unable to allocate memory "
-				      "for I/O buffer ring\n") );
-			} else if ( rval == E2BIG ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				      "for I/O buffer ring\n"));
+			} else if (rval == E2BIG) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("not enough physical memory "
-				      "to pin down I/O buffer ring\n") );
-			} else if ( rval == EPERM ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				      "to pin down I/O buffer ring\n"));
+			} else if (rval == EPERM) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("not allowed "
-				      "to pin down I/O buffer ring\n") );
+				      "to pin down I/O buffer ring\n"));
 			} else {
-				assert( 0 );
+				assert(0);
 			}
 			return BOOL_FALSE;
 		}
@@ -713,7 +713,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 
 	/* scan drive device pathname to see if remote tape
 	 */
-	if ( strchr( drivep->d_pathname, ':') ) {
+	if (strchr(drivep->d_pathname, ':')) {
 		contextp->dc_isrmtpr = BOOL_TRUE;
 	} else {
 		contextp->dc_isrmtpr = BOOL_FALSE;
@@ -723,7 +723,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	 * mark them as unknown for now. however, if this is an RMT
 	 * access, we know immediately some capabilities are missing.
 	 */
-	if ( contextp->dc_isrmtpr ) {
+	if (contextp->dc_isrmtpr) {
 		contextp->dc_cangetblkszpr = BOOL_FALSE;
 		contextp->dc_cansetblkszpr = BOOL_FALSE;
 		contextp->dc_isvarpr = BOOL_TRUE;
@@ -781,15 +781,15 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
  */
 /* ARGSUSED */
 static bool_t
-do_init( drive_t *drivep )
+do_init(drive_t *drivep)
 {
 #ifdef DUMP
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
+	media_hdr_t *mwhdrp = (media_hdr_t *)dwhdrp->dh_upper;
 #endif /* DUMP */
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: init\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: init\n");
 
 #ifdef DUMP
 	/* fill in media strategy id: artifact of first version of xfsdump
@@ -806,10 +806,10 @@ do_init( drive_t *drivep )
  */
 /* ARGSUSED */
 static bool_t
-do_sync( drive_t *drivep )
+do_sync(drive_t *drivep)
 {
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: sync\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: sync\n");
 
 	return BOOL_TRUE;
 }
@@ -824,32 +824,32 @@ do_sync( drive_t *drivep )
  *
  */
 static int
-do_begin_read( drive_t *drivep )
+do_begin_read(drive_t *drivep)
 {
         drive_context_t *contextp;
         int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: begin read\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: begin read\n");
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* verify protocol being followed
 	 */
-	assert( drivep->d_capabilities & DRIVE_CAP_READ );
-	assert( contextp->dc_mode == OM_NONE );
-	assert( ! contextp->dc_recp );
+	assert(drivep->d_capabilities & DRIVE_CAP_READ);
+	assert(contextp->dc_mode == OM_NONE);
+	assert(! contextp->dc_recp);
 
 	/* get a record buffer to use during initialization.
 	 */
-	if ( contextp->dc_singlethreadedpr ) {
+	if (contextp->dc_singlethreadedpr) {
 		contextp->dc_recp = contextp->dc_bufp;
 	} else {
-		assert( contextp->dc_ringp );
-		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
+		assert(contextp->dc_ringp);
+		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+		assert(contextp->dc_msgp->rm_stat == RING_STAT_INIT);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 	}
 
@@ -858,38 +858,38 @@ do_begin_read( drive_t *drivep )
 	 * size previously determined.
 	 */
 	contextp->dc_iocnt = 0;
-	if ( contextp->dc_fd < 0 ) {
-		assert( contextp->dc_fd == -1 );
-		rval = prepare_drive( drivep );
-		if ( rval ) {
-			if ( ! contextp->dc_singlethreadedpr ) {
-			    Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (contextp->dc_fd < 0) {
+		assert(contextp->dc_fd == -1);
+		rval = prepare_drive(drivep);
+		if (rval) {
+			if (! contextp->dc_singlethreadedpr) {
+			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 			}
 			contextp->dc_msgp = 0;
 			contextp->dc_recp = 0;
 			return rval;
 		}
 	} else {
-		rval = read_label( drivep );
-		if ( rval ) {
-			if ( ! contextp->dc_singlethreadedpr ) {
-			    Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+		rval = read_label(drivep);
+		if (rval) {
+			if (! contextp->dc_singlethreadedpr) {
+			    Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 			}
 			contextp->dc_msgp = 0;
 			contextp->dc_recp = 0;
 			return rval;
 		}
 	}
-	assert( contextp->dc_iocnt == 1 );
+	assert(contextp->dc_iocnt == 1);
 					/* set by prepare_drive or read_label */
 
 	/* all is well. adjust context. don't kick off read-aheads just yet;
 	 * the client may not want this media file.
 	 */
-	if ( ! contextp->dc_singlethreadedpr ) {
+	if (! contextp->dc_singlethreadedpr) {
 		contextp->dc_msgp->rm_op = RING_OP_NOP;
 		contextp->dc_msgp->rm_user = 0; /* do diff. use in do_seek */
-		Ring_put( contextp->dc_ringp, contextp->dc_msgp );
+		Ring_put(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 	contextp->dc_recp = 0;
@@ -920,31 +920,31 @@ do_begin_read( drive_t *drivep )
  *
  */
 static char *
-do_read( drive_t *drivep,
+do_read(drive_t *drivep,
 	 size_t wantedcnt,
 	 size_t *actualcntp,
-	 int *rvalp )
+	 int *rvalp)
 {
 	drive_context_t *contextp;
 	size_t availcnt;
 	size_t actualcnt;
 	int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: read: wanted %u (0x%x)\n",
 	      wantedcnt,
-	      wantedcnt );
+	      wantedcnt);
 
 	/* get context ptrs
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
-	assert( wantedcnt > 0 );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
+	assert(wantedcnt > 0);
 
 	/* clear the return status field
 	 */
@@ -952,30 +952,30 @@ do_read( drive_t *drivep,
 
 	/* read a new record if necessary
 	 */
-	rval = getrec( drivep );
-	if ( rval ) {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+	rval = getrec(drivep);
+	if (rval) {
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "drive op read returning error rval=%d\n",
-		      rval );
+		      rval);
 		*rvalp = rval;
 		return 0;
 	}
 
 	/* figure how much data is available, and how much should be supplied
 	 */
-	availcnt = ( size_t )( contextp->dc_dataendp - contextp->dc_nextp );
-	actualcnt = min( wantedcnt, availcnt );
+	availcnt = (size_t)(contextp->dc_dataendp - contextp->dc_nextp);
+	actualcnt = min(wantedcnt, availcnt);
 
 	/* adjust the context
 	 */
 	contextp->dc_ownedp = contextp->dc_nextp;
 	contextp->dc_nextp += actualcnt;
-	assert( contextp->dc_nextp <= contextp->dc_dataendp );
+	assert(contextp->dc_nextp <= contextp->dc_dataendp);
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive op read actual == %d (0x%x)\n",
 	      actualcnt,
-	      actualcnt );
+	      actualcnt);
 
 	*actualcntp = actualcnt;
 	return contextp->dc_ownedp;
@@ -990,29 +990,29 @@ do_read( drive_t *drivep,
  */
 /* ARGSUSED */
 static void
-do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
+do_return_read_buf(drive_t *drivep, char *bufp, size_t retcnt)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	/* REFERENCED */
 	size_t ownedcnt;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: return read buf: sz %d (0x%x)\n",
 	      retcnt,
-	      retcnt );
+	      retcnt);
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( contextp->dc_ownedp );
-	assert( bufp == contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(contextp->dc_ownedp);
+	assert(bufp == contextp->dc_ownedp);
 
 	/* calculate how much the caller owns
 	 */
-	assert( contextp->dc_nextp >= contextp->dc_ownedp );
-	ownedcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
-	assert( ownedcnt == retcnt );
+	assert(contextp->dc_nextp >= contextp->dc_ownedp);
+	ownedcnt = (size_t)(contextp->dc_nextp - contextp->dc_ownedp);
+	assert(ownedcnt == retcnt);
 
 	/* take possession of buffer portion
 	 */
@@ -1021,11 +1021,11 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
 	/* if caller is done with this record, take the buffer back
 	 * and (if ring in use) give buffer to ring for read-ahead.
 	 */
-	if ( contextp->dc_nextp >= contextp->dc_dataendp ) {
-		assert( contextp->dc_nextp == contextp->dc_dataendp );
-		if ( ! contextp->dc_singlethreadedpr ) {
+	if (contextp->dc_nextp >= contextp->dc_dataendp) {
+		assert(contextp->dc_nextp == contextp->dc_dataendp);
+		if (! contextp->dc_singlethreadedpr) {
 			contextp->dc_msgp->rm_op = RING_OP_READ;
-			Ring_put( contextp->dc_ringp, contextp->dc_msgp );
+			Ring_put(contextp->dc_ringp, contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 		}
 		contextp->dc_recp = 0;
@@ -1043,29 +1043,29 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
  *	void
  */
 static void
-do_get_mark( drive_t *drivep, drive_mark_t *markp )
+do_get_mark(drive_t *drivep, drive_mark_t *markp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t offset;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: get mark\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: get mark\n");
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
 
 	/* the mark is simply the offset into the media file of the
 	 * next byte to be read.
 	 */
-	offset = contextp->dc_reccnt * ( off64_t )tape_recsz;
-	if ( contextp->dc_recp ) {
-		offset += ( off64_t )( contextp->dc_nextp - contextp->dc_recp );
+	offset = contextp->dc_reccnt * (off64_t)tape_recsz;
+	if (contextp->dc_recp) {
+		offset += (off64_t)(contextp->dc_nextp - contextp->dc_recp);
 	}
 
-	*markp = ( drive_mark_t )offset;
+	*markp = (drive_mark_t)offset;
 
 	return;
 }
@@ -1082,7 +1082,7 @@ typedef enum { SEEKMODE_BUF, SEEKMODE_RAW } seekmode_t;
  *
  */
 static int
-do_seek_mark( drive_t *drivep, drive_mark_t *markp )
+do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 {
 	drive_context_t	*contextp;
 	off64_t wantedoffset;
@@ -1094,55 +1094,55 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
 
 
 	/* the desired mark is passed by reference, and is really just an
 	 * offset into the raw (incl rec hdrs) read stream
 	 */
-	wantedoffset = *( off64_t * )markp;
+	wantedoffset = *(off64_t *)markp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: seek mark: %lld (0x%llx)\n",
 	      wantedoffset,
-	      wantedoffset );
+	      wantedoffset);
 
 	/* determine the current offset. assert that the wanted offset is
 	 * not less than the current offset.
 	 */
-	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
-	if ( contextp->dc_recp ) {
+	currentoffset = contextp->dc_reccnt * (off64_t)tape_recsz;
+	if (contextp->dc_recp) {
 		uint32_t recoff;
 #ifdef DEBUG
-		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+		rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 #endif
 
-		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( uint32_t )( contextp->dc_nextp
+		assert(contextp->dc_nextp >= contextp->dc_recp);
+		recoff = (uint32_t)(contextp->dc_nextp
 					-
-					contextp->dc_recp );
-		assert( recoff <= tape_recsz );
-		assert( rechdrp->rec_used <= tape_recsz );
-		assert( recoff >= STAPE_HDR_SZ );
-		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
-		assert( recoff <= rechdrp->rec_used );
-		currentoffset += ( off64_t )recoff;
+					contextp->dc_recp);
+		assert(recoff <= tape_recsz);
+		assert(rechdrp->rec_used <= tape_recsz);
+		assert(recoff >= STAPE_HDR_SZ);
+		assert(rechdrp->rec_used >= STAPE_HDR_SZ);
+		assert(recoff <= rechdrp->rec_used);
+		currentoffset += (off64_t)recoff;
 	}
-	assert( wantedoffset >= currentoffset );
+	assert(wantedoffset >= currentoffset);
 
 	/* if we are currently holding a record and the desired offset
 	 * is not within the current record, eat the current record.
 	 */
-	if ( contextp->dc_recp ) {
+	if (contextp->dc_recp) {
 		off64_t nextrecoffset;
-		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+		rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 
-		nextrecoffset = contextp->dc_reccnt  * ( off64_t )tape_recsz
+		nextrecoffset = contextp->dc_reccnt  * (off64_t)tape_recsz
 				+
-				( off64_t )rechdrp->rec_used;
-		if ( wantedoffset >= nextrecoffset ) {
+				(off64_t)rechdrp->rec_used;
+		if (wantedoffset >= nextrecoffset) {
 			uint32_t recoff;
 			size_t wantedcnt;
 			char *dummybufp;
@@ -1152,39 +1152,39 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 			/* if this is the last record, the wanted offset
 			 * must be just after it.
 			 */
-			if ( rechdrp->rec_used < tape_recsz ) {
-				assert( wantedoffset == nextrecoffset );
+			if (rechdrp->rec_used < tape_recsz) {
+				assert(wantedoffset == nextrecoffset);
 			}
 
 			/* figure how much to ask for
 			 */
-			assert( contextp->dc_nextp >= contextp->dc_recp );
-			recoff = ( uint32_t )( contextp->dc_nextp
+			assert(contextp->dc_nextp >= contextp->dc_recp);
+			recoff = (uint32_t)(contextp->dc_nextp
 						-
-						contextp->dc_recp );
-			wantedcnt = ( size_t )( rechdrp->rec_used
+						contextp->dc_recp);
+			wantedcnt = (size_t)(rechdrp->rec_used
 						-
-						recoff );
+						recoff);
 
 			/* eat that much tape
 			 */
 			rval = 0;
-			dummybufp = do_read( drivep,
+			dummybufp = do_read(drivep,
 					     wantedcnt,
 					     &actualcnt,
-					     &rval );
-			if ( rval ) {
+					     &rval);
+			if (rval) {
 				return rval;
 			}
-			assert( actualcnt == wantedcnt );
-			do_return_read_buf( drivep, dummybufp, actualcnt );
-			currentoffset += ( off64_t )actualcnt;
-			assert( currentoffset == nextrecoffset );
-			assert( wantedoffset >= currentoffset );
-			assert( ! contextp->dc_recp );
-			assert( currentoffset
+			assert(actualcnt == wantedcnt);
+			do_return_read_buf(drivep, dummybufp, actualcnt);
+			currentoffset += (off64_t)actualcnt;
+			assert(currentoffset == nextrecoffset);
+			assert(wantedoffset >= currentoffset);
+			assert(! contextp->dc_recp);
+			assert(currentoffset
 				==
-				contextp->dc_reccnt * ( off64_t )tape_recsz );
+				contextp->dc_reccnt * (off64_t)tape_recsz);
 		}
 	}
 
@@ -1195,208 +1195,208 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	 * made it there, suspend read-ahead, eat those readahead records,
 	 * FSR the remaining, and resume readahead.
 	 */
-	if ( contextp->dc_canfsrpr
+	if (contextp->dc_canfsrpr
 	     &&
-	     wantedoffset - currentoffset >= ( off64_t )tape_recsz ) {
+	     wantedoffset - currentoffset >= (off64_t)tape_recsz) {
 		off64_t wantedreccnt;
 		seekmode_t seekmode;
 
-		assert( ! contextp->dc_recp );
-		wantedreccnt = wantedoffset / ( off64_t )tape_recsz;
-		if ( contextp->dc_singlethreadedpr ) {
+		assert(! contextp->dc_recp);
+		wantedreccnt = wantedoffset / (off64_t)tape_recsz;
+		if (contextp->dc_singlethreadedpr) {
 			seekmode = SEEKMODE_RAW;
 		} else {
 			seekmode = SEEKMODE_BUF;
 		}
-		assert( wantedreccnt != 0 ); /* so NOP below can be
+		assert(wantedreccnt != 0); /* so NOP below can be
 					      * distinguished from use
 					      * in do_begin_read
 					      */
-		while ( contextp->dc_reccnt < wantedreccnt ) {
+		while (contextp->dc_reccnt < wantedreccnt) {
 			off64_t recskipcnt64;
 			off64_t recskipcnt64remaining;
 
-			if ( seekmode == SEEKMODE_BUF ) {
+			if (seekmode == SEEKMODE_BUF) {
 				ring_stat_t rs;
-				assert( ! contextp->dc_msgp );
+				assert(! contextp->dc_msgp);
 				contextp->dc_msgp =
-						Ring_get( contextp->dc_ringp );
+						Ring_get(contextp->dc_ringp);
 				rs = contextp->dc_msgp->rm_stat;
-				if ( rs == RING_STAT_ERROR ) {
+				if (rs == RING_STAT_ERROR) {
 					contextp->dc_errorpr = BOOL_TRUE;
 					return contextp->dc_msgp->rm_rval;
 				}
-				if ( rs != RING_STAT_OK
+				if (rs != RING_STAT_OK
 				     &&
 				     rs != RING_STAT_INIT
 				     &&
-				     rs != RING_STAT_NOPACK ) {
-					assert( 0 );
+				     rs != RING_STAT_NOPACK) {
+					assert(0);
 					contextp->dc_errorpr = BOOL_TRUE;
 					return DRIVE_ERROR_CORE;
 				}
-				if ( rs == RING_STAT_OK ) {
+				if (rs == RING_STAT_OK) {
 					contextp->dc_reccnt++;
 				}
-				if ( rs == RING_STAT_NOPACK
+				if (rs == RING_STAT_NOPACK
 				     &&
 				     contextp->dc_msgp->rm_user
 				     ==
-				     wantedreccnt ) {
+				     wantedreccnt) {
 					seekmode = SEEKMODE_RAW;
 				}
 				contextp->dc_msgp->rm_op = RING_OP_NOP;
 				contextp->dc_msgp->rm_user = wantedreccnt;
-				Ring_put( contextp->dc_ringp,
-					  contextp->dc_msgp );
+				Ring_put(contextp->dc_ringp,
+					  contextp->dc_msgp);
 				contextp->dc_msgp = 0;
 				continue;
 			}
 
-			assert( contextp->dc_reccnt == contextp->dc_iocnt );
-			assert( wantedreccnt > contextp->dc_reccnt );
+			assert(contextp->dc_reccnt == contextp->dc_iocnt);
+			assert(wantedreccnt > contextp->dc_reccnt);
 			recskipcnt64 = wantedreccnt - contextp->dc_reccnt;
 			recskipcnt64remaining = recskipcnt64;
-			while ( recskipcnt64remaining ) {
+			while (recskipcnt64remaining) {
 				int recskipcnt;
 				int saved_errno;
 				int rval;
 
-				assert( recskipcnt64remaining > 0 );
-				if ( recskipcnt64remaining > INTGENMAX ) {
+				assert(recskipcnt64remaining > 0);
+				if (recskipcnt64remaining > INTGENMAX) {
 					recskipcnt = INTGENMAX;
 				} else {
-					recskipcnt = ( int )
+					recskipcnt = (int)
 						     recskipcnt64remaining;
 				}
-				assert( recskipcnt > 0 );
-				rval = mt_op( contextp->dc_fd,
+				assert(recskipcnt > 0);
+				rval = mt_op(contextp->dc_fd,
 					      MTFSR,
-					      recskipcnt );
+					      recskipcnt);
 				saved_errno = errno;
-				if ( rval ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+				if (rval) {
+					mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					      _("could not forward space %d "
 					      "tape blocks: "
 					      "rval == %d, errno == %d (%s)\n"),
 					      rval,
 					      saved_errno,
-					      strerror( saved_errno ));
+					      strerror(saved_errno));
 					return DRIVE_ERROR_MEDIA;
 				}
-				recskipcnt64remaining -= ( off64_t )recskipcnt;
+				recskipcnt64remaining -= (off64_t)recskipcnt;
 			}
 			contextp->dc_reccnt += recskipcnt64;
 			contextp->dc_iocnt += recskipcnt64;
 			currentoffset = contextp->dc_reccnt
 					*
-					( off64_t )tape_recsz;
-			assert( wantedoffset >= currentoffset );
-			assert( wantedoffset - currentoffset
+					(off64_t)tape_recsz;
+			assert(wantedoffset >= currentoffset);
+			assert(wantedoffset - currentoffset
 				<
-				( off64_t )tape_recsz );
+				(off64_t)tape_recsz);
 		}
 	}
 
 	/* remove excess records by eating them. won't be any if
 	 * FSR supported
 	 */
-	while ( wantedoffset - currentoffset >= ( off64_t )tape_recsz ) {
+	while (wantedoffset - currentoffset >= (off64_t)tape_recsz) {
 		size_t wantedcnt;
 		char *dummybufp;
 		size_t actualcnt;
 		int rval;
 
-		assert( ! contextp->dc_recp );
+		assert(! contextp->dc_recp);
 
 		/* figure how much to ask for. to eat an entire record,
 		 * ask for a record sans the header. do_read will eat
 		 * the header, we eat the rest.
 		 */
-		wantedcnt = ( size_t )( tape_recsz - STAPE_HDR_SZ );
+		wantedcnt = (size_t)(tape_recsz - STAPE_HDR_SZ);
 
 		/* eat that much tape
 		 */
 		rval = 0;
-		dummybufp = do_read( drivep, wantedcnt, &actualcnt, &rval );
-		if ( rval ) {
+		dummybufp = do_read(drivep, wantedcnt, &actualcnt, &rval);
+		if (rval) {
 			return rval;
 		}
-		assert( actualcnt == wantedcnt );
-		do_return_read_buf( drivep, dummybufp, actualcnt );
-		assert( ! contextp->dc_recp );
-		currentoffset += ( off64_t )tape_recsz;
-		assert( currentoffset
+		assert(actualcnt == wantedcnt);
+		do_return_read_buf(drivep, dummybufp, actualcnt);
+		assert(! contextp->dc_recp);
+		currentoffset += (off64_t)tape_recsz;
+		assert(currentoffset
 			==
-			contextp->dc_reccnt * ( off64_t )tape_recsz );
+			contextp->dc_reccnt * (off64_t)tape_recsz);
 	}
 
 	/* eat that portion of the next record leading up to the
 	 * desired offset.
 	 */
-	if ( wantedoffset != currentoffset ) {
+	if (wantedoffset != currentoffset) {
 		size_t wantedcnt;
 		char *dummybufp;
 		size_t actualcnt;
 
-		assert( wantedoffset > currentoffset );
-		assert( wantedoffset - currentoffset < ( off64_t )tape_recsz );
-		wantedcnt = ( size_t )( wantedoffset - currentoffset );
-		if ( contextp->dc_recp ) {
+		assert(wantedoffset > currentoffset);
+		assert(wantedoffset - currentoffset < (off64_t)tape_recsz);
+		wantedcnt = (size_t)(wantedoffset - currentoffset);
+		if (contextp->dc_recp) {
 			uint32_t recoff;
 #ifdef DEBUG
-			rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+			rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 #endif
-			recoff = ( uint32_t )( contextp->dc_nextp
+			recoff = (uint32_t)(contextp->dc_nextp
 						-
-						contextp->dc_recp );
-			assert( recoff <= tape_recsz );
-			assert( rechdrp->rec_used <= tape_recsz );
-			assert( recoff >= STAPE_HDR_SZ );
-			assert( rechdrp->rec_used >= STAPE_HDR_SZ );
-			assert( recoff <= rechdrp->rec_used );
-			assert( recoff + wantedcnt <= rechdrp->rec_used );
+						contextp->dc_recp);
+			assert(recoff <= tape_recsz);
+			assert(rechdrp->rec_used <= tape_recsz);
+			assert(recoff >= STAPE_HDR_SZ);
+			assert(rechdrp->rec_used >= STAPE_HDR_SZ);
+			assert(recoff <= rechdrp->rec_used);
+			assert(recoff + wantedcnt <= rechdrp->rec_used);
 		} else {
-			assert( wantedcnt >= STAPE_HDR_SZ );
+			assert(wantedcnt >= STAPE_HDR_SZ);
 			wantedcnt -= STAPE_HDR_SZ;
 		}
 
 		/* eat that much tape
 		 */
-		if ( wantedcnt > 0 ) {
+		if (wantedcnt > 0) {
 		    int rval;
 		    rval = 0;
-		    dummybufp = do_read( drivep, wantedcnt, &actualcnt, &rval );
-		    if ( rval ) {
+		    dummybufp = do_read(drivep, wantedcnt, &actualcnt, &rval);
+		    if (rval) {
 			    return rval;
 		    }
-		    assert( actualcnt == wantedcnt );
-		    do_return_read_buf( drivep, dummybufp, actualcnt );
+		    assert(actualcnt == wantedcnt);
+		    do_return_read_buf(drivep, dummybufp, actualcnt);
 		}
 	}
 
 	/* as a sanity check, refigure the current offset and make sure
 	 * it is equal to the wanted offset
 	 */
-	currentoffset = contextp->dc_reccnt * ( off64_t )tape_recsz;
-	if ( contextp->dc_recp ) {
+	currentoffset = contextp->dc_reccnt * (off64_t)tape_recsz;
+	if (contextp->dc_recp) {
 		uint32_t recoff;
 #ifdef DEBUG
-		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+		rec_hdr_t *rechdrp = (rec_hdr_t *)contextp->dc_recp;
 #endif
 
-		assert( contextp->dc_nextp >= contextp->dc_recp );
-		recoff = ( uint32_t )( contextp->dc_nextp
+		assert(contextp->dc_nextp >= contextp->dc_recp);
+		recoff = (uint32_t)(contextp->dc_nextp
 					-
-					contextp->dc_recp );
-		assert( recoff <= tape_recsz );
-		assert( rechdrp->rec_used <= tape_recsz );
-		assert( recoff >= STAPE_HDR_SZ );
-		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
-		assert( recoff <= rechdrp->rec_used );
-		currentoffset += ( off64_t )recoff;
+					contextp->dc_recp);
+		assert(recoff <= tape_recsz);
+		assert(rechdrp->rec_used <= tape_recsz);
+		assert(recoff >= STAPE_HDR_SZ);
+		assert(rechdrp->rec_used >= STAPE_HDR_SZ);
+		assert(recoff <= rechdrp->rec_used);
+		currentoffset += (off64_t)recoff;
 	}
-	assert( wantedoffset == currentoffset );
+	assert(wantedoffset == currentoffset);
 
 	return 0;
 }
@@ -1412,7 +1412,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_next_mark( drive_t *drivep )
+do_next_mark(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	rec_hdr_t *rechdrp;
@@ -1429,69 +1429,69 @@ do_next_mark( drive_t *drivep )
 
 	/* assert protocol being followed.
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: next mark\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: next mark\n");
 
 	trycnt = 0;
 
-	if ( contextp->dc_errorpr ) {
+	if (contextp->dc_errorpr) {
 		goto resetring;
 	} else {
 		goto noerrorsearch;
 	}
 
 noerrorsearch:
-	for ( ; ; ) {
-		rval = getrec( drivep );
-		if ( rval == DRIVE_ERROR_CORRUPTION ) {
+	for (; ;) {
+		rval = getrec(drivep);
+		if (rval == DRIVE_ERROR_CORRUPTION) {
 			goto resetring;
-		} else if ( rval ) {
+		} else if (rval) {
 			return rval;
 		}
-		rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+		rechdrp = (rec_hdr_t *)contextp->dc_recp;
 
-		assert( rechdrp->first_mark_offset != 0 );
-		if ( rechdrp->first_mark_offset > 0 ) {
+		assert(rechdrp->first_mark_offset != 0);
+		if (rechdrp->first_mark_offset > 0) {
 			 off64_t markoff = rechdrp->first_mark_offset
 					   -
 					   rechdrp->file_offset;
-			 off64_t curoff = ( off64_t )( contextp->dc_nextp
+			 off64_t curoff = (off64_t)(contextp->dc_nextp
 						       -
-						       contextp->dc_recp );
-			 assert( markoff > 0 );
-			 assert( curoff > 0 );
-			 if ( markoff >= curoff ) {
+						       contextp->dc_recp);
+			 assert(markoff > 0);
+			 assert(curoff > 0);
+			 if (markoff >= curoff) {
 				break;
 			}
 		}
 
-		if ( ! contextp->dc_singlethreadedpr ) {
-			Ring_put( contextp->dc_ringp,
-				  contextp->dc_msgp );
+		if (! contextp->dc_singlethreadedpr) {
+			Ring_put(contextp->dc_ringp,
+				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 		}
 		contextp->dc_recp = 0;
 		contextp->dc_reccnt++;
 	}
 
-	assert( rechdrp->first_mark_offset - rechdrp->file_offset
+	assert(rechdrp->first_mark_offset - rechdrp->file_offset
 		<=
-		( off64_t )tape_recsz );
+		(off64_t)tape_recsz);
 	contextp->dc_nextp = contextp->dc_recp
 			     +
-			     ( size_t )( rechdrp->first_mark_offset
+			     (size_t)(rechdrp->first_mark_offset
 					 -
-					 rechdrp->file_offset );
-	assert( contextp->dc_nextp <= contextp->dc_dataendp );
-	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
-	if ( contextp->dc_nextp == contextp->dc_dataendp ) {
-		if ( ! contextp->dc_singlethreadedpr ) {
-			Ring_put( contextp->dc_ringp,
-				  contextp->dc_msgp );
+					 rechdrp->file_offset);
+	assert(contextp->dc_nextp <= contextp->dc_dataendp);
+	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
+	if (contextp->dc_nextp == contextp->dc_dataendp) {
+		if (! contextp->dc_singlethreadedpr) {
+			Ring_put(contextp->dc_ringp,
+				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 		}
 		contextp->dc_recp = 0;
@@ -1501,152 +1501,152 @@ noerrorsearch:
 	return 0;
 
 resetring:
-	if ( ! contextp->dc_singlethreadedpr ) {
-		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 	contextp->dc_recp = 0;
 
 	/* get a record buffer and cast a record header pointer
 	 */
-	if ( contextp->dc_singlethreadedpr ) {
+	if (contextp->dc_singlethreadedpr) {
 		contextp->dc_recp = contextp->dc_bufp;
 	} else {
-		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
+		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+		assert(contextp->dc_msgp->rm_stat == RING_STAT_INIT);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 	}
-	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
 	goto readrecord;
 
 readrecord:
 	trycnt++;
-	if ( trycnt > maxtrycnt ) {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
-		      _("unable to locate next mark in media file\n") );
+	if (trycnt > maxtrycnt) {
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
+		      _("unable to locate next mark in media file\n"));
 		return DRIVE_ERROR_MEDIA;
 	}
 
-	nread = Read( drivep, contextp->dc_recp, tape_recsz, &saved_errno );
+	nread = Read(drivep, contextp->dc_recp, tape_recsz, &saved_errno);
 	goto validateread;
 
 validateread:
-	if ( nread == ( int )tape_recsz ) {
+	if (nread == (int)tape_recsz) {
 		goto validatehdr;
 	}
-	ok = mt_get_status( drivep, &mtstat );
-	if ( ! ok ) {
-		status_failed_message( drivep );
+	ok = mt_get_status(drivep, &mtstat);
+	if (! ok) {
+		status_failed_message(drivep);
 		return DRIVE_ERROR_DEVICE;
 	}
 
-	if ( IS_FMK( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "encountered EOF attempting to read record\n" );
+	if (IS_FMK(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "encountered EOF attempting to read record\n");
 		return DRIVE_ERROR_EOF;
 	}
 
-	if ( IS_EOD( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "encountered EOD attempting to read record\n" );
+	if (IS_EOD(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "encountered EOD attempting to read record\n");
 		return DRIVE_ERROR_EOD;
 	}
 
-	if ( IS_EOT( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "encountered EOM attempting to read record\n" );
+	if (IS_EOT(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "encountered EOM attempting to read record\n");
 		return DRIVE_ERROR_EOM;
 	}
 
-	if ( IS_EW( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "encountered EW attempting to read record\n" );
+	if (IS_EW(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "encountered EW attempting to read record\n");
 		return DRIVE_ERROR_EOM;
 	}
 
-	if ( nread >= 0 ) {
-		assert( ( size_t )nread <= tape_recsz );
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (nread >= 0) {
+		assert((size_t)nread <= tape_recsz);
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "short read (nread == %d, record size == %d)\n",
 		      nread,
-		      tape_recsz );
+		      tape_recsz);
 		goto getbeyonderror;
 	}
 
 	/* some other error
 	 */
-	mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
+	mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
 	      "unexpected error attempting to read record: "
 	      "read returns %d, errno %d (%s)\n"),
 	      nread,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 
 	goto getbeyonderror;
 
 validatehdr:
-	rval = record_hdr_validate( drivep, contextp->dc_recp, BOOL_FALSE );
+	rval = record_hdr_validate(drivep, contextp->dc_recp, BOOL_FALSE);
 
-	if ( rval
+	if (rval
 	     &&
-	     ( contextp->dc_isQICpr == BOOL_TRUE
+	     (contextp->dc_isQICpr == BOOL_TRUE
 	       ||
-	       contextp->dc_isQICpr == BOOL_UNKNOWN )) {
+	       contextp->dc_isQICpr == BOOL_UNKNOWN)) {
 		goto huntQIC;
 	}
 
-	if ( rval ) {
+	if (rval) {
 		goto readrecord;
 	}
 
-	contextp->dc_reccnt = rechdrp->file_offset / ( off64_t )tape_recsz;
+	contextp->dc_reccnt = rechdrp->file_offset / (off64_t)tape_recsz;
 	contextp->dc_iocnt = contextp->dc_reccnt + 1;
-	if ( rechdrp->first_mark_offset < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
+	if (rechdrp->first_mark_offset < 0) {
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
 		      _("valid record %lld but no mark\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		goto readrecord;
 	}
 
-	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
+	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
 	markoff = rechdrp->first_mark_offset - rechdrp->file_offset;
-	assert( markoff >= ( off64_t )STAPE_HDR_SZ );
-	assert( markoff < ( off64_t )tape_recsz );
-	assert( rechdrp->rec_used > STAPE_HDR_SZ );
-	assert( rechdrp->rec_used < tape_recsz );
+	assert(markoff >= (off64_t)STAPE_HDR_SZ);
+	assert(markoff < (off64_t)tape_recsz);
+	assert(rechdrp->rec_used > STAPE_HDR_SZ);
+	assert(rechdrp->rec_used < tape_recsz);
 
 	goto alliswell;
 
 alliswell:
-	contextp->dc_nextp = contextp->dc_recp + ( size_t )markoff;
-	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
-	contextp->dc_reccnt = rechdrp->file_offset / ( off64_t )tape_recsz;
+	contextp->dc_nextp = contextp->dc_recp + (size_t)markoff;
+	assert(! (rechdrp->file_offset % (off64_t)tape_recsz));
+	contextp->dc_reccnt = rechdrp->file_offset / (off64_t)tape_recsz;
 	contextp->dc_iocnt = contextp->dc_reccnt + 1;
 	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
 	contextp->dc_dataendp = contextp->dc_recp + rechdrp->rec_used;
-	assert( contextp->dc_dataendp <= contextp->dc_recendp );
-	assert( contextp->dc_nextp < contextp->dc_dataendp );
+	assert(contextp->dc_dataendp <= contextp->dc_recendp);
+	assert(contextp->dc_nextp < contextp->dc_dataendp);
 	contextp->dc_errorpr = BOOL_FALSE;
 
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("resynchronized at record %lld offset %u\n"),
 	      contextp->dc_iocnt - 1,
 	      contextp->dc_nextp
 	      -
-	      contextp->dc_recp );
+	      contextp->dc_recp);
 	return 0;
 
 getbeyonderror:
-	rval = mt_op( contextp->dc_fd, MTFSR, 1 );
+	rval = mt_op(contextp->dc_fd, MTFSR, 1);
 	saved_errno = errno;
 
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (rval) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("could not forward space one tape block beyond "
 		      "read error: rval == %d, errno == %d (%s)\n"),
 		      rval,
 		      saved_errno,
-		      strerror( saved_errno ));
+		      strerror(saved_errno));
 		return DRIVE_ERROR_MEDIA;
 	}
 
@@ -1658,12 +1658,12 @@ huntQIC:
 	 * the following blocks to the head of the record buffer, and try
 	 * to read the remaining blocks in the record.
 	 */
-	for ( p = contextp->dc_recp + QIC_BLKSZ
+	for (p = contextp->dc_recp + QIC_BLKSZ
 	      ;
 	      p < contextp->dc_recendp
 	      ;
-	      p += QIC_BLKSZ ) {
-		if ( *( uint64_t * )p == STAPE_MAGIC ) {
+	      p += QIC_BLKSZ) {
+		if (*(uint64_t *)p == STAPE_MAGIC) {
 			goto adjustQIC;
 		}
 	}
@@ -1671,14 +1671,14 @@ huntQIC:
 	goto readrecord;
 
 adjustQIC:
-	tailsz = ( size_t )( contextp->dc_recendp - p );
-	memcpy( ( void * )contextp->dc_recp,
-		( void * )p,
-		tailsz );
-	nread = Read( drivep,
+	tailsz = (size_t)(contextp->dc_recendp - p);
+	memcpy((void *)contextp->dc_recp,
+		(void *)p,
+		tailsz);
+	nread = Read(drivep,
 		      contextp->dc_recp + tailsz,
 		      tape_recsz - tailsz,
-		      &saved_errno );
+		      &saved_errno);
 
 	goto validateread;
 }
@@ -1691,20 +1691,20 @@ adjustQIC:
  *	void
  */
 static void
-do_end_read( drive_t *drivep )
+do_end_read(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: end read\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: end read\n");
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
 
-	if ( ! contextp->dc_singlethreadedpr ) {
-		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 
@@ -1720,7 +1720,7 @@ do_end_read( drive_t *drivep )
  * 	DRIVE_ERROR_... on failure
  */
 static int
-do_begin_write( drive_t *drivep )
+do_begin_write(drive_t *drivep)
 {
 	drive_context_t		*contextp;
 	drive_hdr_t		*dwhdrp;
@@ -1742,38 +1742,38 @@ do_begin_write( drive_t *drivep )
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: begin write\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: begin write\n");
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_NONE );
-	assert( ! drivep->d_markrecheadp );
-	assert( ! contextp->dc_recp );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(! drivep->d_markrecheadp);
+	assert(! contextp->dc_recp);
 
 	/* get pointers into global write header
 	 */
 	gwhdrp = drivep->d_gwritehdrp;
 	dwhdrp = drivep->d_writehdrp;
-	tpwhdrp = ( rec_hdr_t * )dwhdrp->dh_specific;
+	tpwhdrp = (rec_hdr_t *)dwhdrp->dh_specific;
 
 	/* must already be open. The only way to open is to do a begin_read.
 	 * so all interaction with scsi tape requires reading first.
 	 */
-	assert( contextp->dc_fd != -1 );
+	assert(contextp->dc_fd != -1);
 
 	/* get tape device status. verify tape is positioned
  	 */
-	if ( ! mt_get_status( drivep, &mtstat )) {
-		status_failed_message( drivep );
+	if (! mt_get_status(drivep, &mtstat)) {
+		status_failed_message(drivep);
         	return DRIVE_ERROR_DEVICE;
 	}
-	if ( IS_EOT( mtstat )) {
+	if (IS_EOT(mtstat)) {
 		return DRIVE_ERROR_EOM;
 	}
-	if ( IS_EW( mtstat ) && !(IS_BOT(mtstat)) ) {
+	if (IS_EW(mtstat) && !(IS_BOT(mtstat))) {
 		return DRIVE_ERROR_EOM;
 	}
 
@@ -1781,8 +1781,8 @@ do_begin_write( drive_t *drivep )
 	 */
 	tpwhdrp->magic = STAPE_MAGIC;
 	tpwhdrp->version = STAPE_VERSION;
-	tpwhdrp->blksize = ( int32_t )tape_blksz;
-	tpwhdrp->recsize = ( int32_t )tape_recsz;
+	tpwhdrp->blksize = (int32_t)tape_blksz;
+	tpwhdrp->recsize = (int32_t)tape_recsz;
 	tpwhdrp->rec_used = 0;
 	tpwhdrp->file_offset = 0;
 	tpwhdrp->first_mark_offset= 0;
@@ -1791,15 +1791,15 @@ do_begin_write( drive_t *drivep )
 	/* get a record buffer. will be used for the media file header,
 	 * and is needed to "prime the pump" for first call to do_write.
 	 */
-	assert( ! contextp->dc_recp );
-	if ( contextp->dc_singlethreadedpr ) {
-		assert( contextp->dc_bufp );
+	assert(! contextp->dc_recp);
+	if (contextp->dc_singlethreadedpr) {
+		assert(contextp->dc_bufp);
 		contextp->dc_recp = contextp->dc_bufp;
 	} else {
-		assert( contextp->dc_ringp );
-		assert( ! contextp->dc_msgp );
-		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
+		assert(contextp->dc_ringp);
+		assert(! contextp->dc_msgp);
+		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+		assert(contextp->dc_msgp->rm_stat == RING_STAT_INIT);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 	}
 
@@ -1807,7 +1807,7 @@ do_begin_write( drive_t *drivep )
 	 * being produced!
 	 */
 	contextp->dc_iocnt = 0;
-	memset( ( void * )contextp->dc_recp, 0, tape_recsz );
+	memset((void *)contextp->dc_recp, 0, tape_recsz);
 
 	tmpgh  = (global_hdr_t *)contextp->dc_recp;
 	tmpdh  = (drive_hdr_t *)tmpgh->gh_upper;
@@ -1829,12 +1829,12 @@ do_begin_write( drive_t *drivep )
 
 	/* checksum the global header
 	 */
-	global_hdr_checksum_set( tmpgh );
+	global_hdr_checksum_set(tmpgh);
 
-	rval = write_record( drivep, contextp->dc_recp, BOOL_TRUE, BOOL_FALSE );
-	if ( rval ) {
-		if ( ! contextp->dc_singlethreadedpr ) {
-			Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	rval = write_record(drivep, contextp->dc_recp, BOOL_TRUE, BOOL_FALSE);
+	if (rval) {
+		if (! contextp->dc_singlethreadedpr) {
+			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 		}
 		contextp->dc_recp = 0;
@@ -1844,7 +1844,7 @@ do_begin_write( drive_t *drivep )
 	/* prepare the drive context. must have a record buffer ready to
 	 * go, header initialized.
 	 */
-	assert( ! contextp->dc_ownedp );
+	assert(! contextp->dc_ownedp);
 	contextp->dc_reccnt = 1; /* count the header record */
 	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
 	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
@@ -1854,12 +1854,12 @@ do_begin_write( drive_t *drivep )
 	rechdrp = (rec_hdr_t*)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
-	rechdrp->file_offset = contextp->dc_reccnt * ( off64_t )tape_recsz;
-	rechdrp->blksize = ( int32_t )tape_blksz;
-	rechdrp->recsize = ( int32_t )tape_recsz;
+	rechdrp->file_offset = contextp->dc_reccnt * (off64_t)tape_recsz;
+	rechdrp->blksize = (int32_t)tape_blksz;
+	rechdrp->recsize = (int32_t)tape_recsz;
 	rechdrp->capability = drivep->d_capabilities;
 	rechdrp->first_mark_offset = -1LL;
-	uuid_copy( rechdrp->dump_uuid, gwhdrp->gh_dumpid );
+	uuid_copy(rechdrp->dump_uuid, gwhdrp->gh_dumpid);
 
 	/* set mode now so operators will work
 	 */
@@ -1874,10 +1874,10 @@ do_begin_write( drive_t *drivep )
  * in record.
  */
 static void
-do_set_mark( drive_t *drivep,
+do_set_mark(drive_t *drivep,
 	     drive_mcbfp_t cbfuncp,
 	     void *cbcontextp,
-	     drive_markrec_t *markrecp )
+	     drive_markrec_t *markrecp)
 {
 	drive_context_t *contextp;
 	off64_t nextoff;
@@ -1885,34 +1885,34 @@ do_set_mark( drive_t *drivep,
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_recp );
-	assert( contextp->dc_nextp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_recp);
+	assert(contextp->dc_nextp);
 
 	/* calculate and fill in the mark record offset
 	 */
-	assert( contextp->dc_recp );
-	nextoff = contextp->dc_reccnt * ( off64_t )tape_recsz
+	assert(contextp->dc_recp);
+	nextoff = contextp->dc_reccnt * (off64_t)tape_recsz
 		  +
-		  ( off64_t )( contextp->dc_nextp - contextp->dc_recp );
-	markrecp->dm_log = ( drive_mark_t )nextoff;
+		  (off64_t)(contextp->dc_nextp - contextp->dc_recp);
+	markrecp->dm_log = (drive_mark_t)nextoff;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: set mark: %lld (0x%llx)\n",
 	      nextoff,
-	      nextoff );
+	      nextoff);
 
 	/* note the location of the first mark in this tape record.
 	 */
-	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
-	if ( rechdrp->first_mark_offset == -1LL ) {
-		assert( nextoff != -1LL );
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
+	if (rechdrp->first_mark_offset == -1LL) {
+		assert(nextoff != -1LL);
 		rechdrp->first_mark_offset = nextoff;
 	}
 
@@ -1921,11 +1921,11 @@ do_set_mark( drive_t *drivep,
 	markrecp->dm_cbfuncp = cbfuncp;
 	markrecp->dm_cbcontextp = cbcontextp;
 	markrecp->dm_nextp = 0;
-	if ( drivep->d_markrecheadp == 0 ) {
+	if (drivep->d_markrecheadp == 0) {
 		drivep->d_markrecheadp = markrecp;
 		drivep->d_markrectailp = markrecp;
 	} else {
-		assert( drivep->d_markrectailp );
+		assert(drivep->d_markrectailp);
 		drivep->d_markrectailp->dm_nextp = markrecp;
 		drivep->d_markrectailp = markrecp;
 	}
@@ -1940,7 +1940,7 @@ do_set_mark( drive_t *drivep,
  *	"actual_bufszp" points to the size of the buffer
  */
 static char *
-do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
+do_get_write_buf(drive_t *drivep, size_t wantedcnt, size_t *actualcntp)
 {
 	drive_context_t *contextp;
 	size_t remainingcnt;
@@ -1948,32 +1948,32 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_recp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp < contextp->dc_recendp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_recp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp < contextp->dc_recendp);
 
 	/* figure how much is available; supply the min of what is
 	 * available and what is wanted.
 	 */
-	remainingcnt = ( size_t )( contextp->dc_recendp - contextp->dc_nextp );
-	actualcnt = min( remainingcnt, wantedcnt );
+	remainingcnt = (size_t)(contextp->dc_recendp - contextp->dc_nextp);
+	actualcnt = min(remainingcnt, wantedcnt);
 	*actualcntp = actualcnt;
 	contextp->dc_ownedp = contextp->dc_nextp;
 	contextp->dc_nextp += actualcnt;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: get write buf: wanted %u (0x%x) actual %u (0x%x)\n",
 	      wantedcnt,
 	      wantedcnt,
 	      actualcnt,
-	      actualcnt );
+	      actualcnt);
 
 	return contextp->dc_ownedp;
 }
@@ -1991,7 +1991,7 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
  */
 /* ARGSUSED */
 static int
-do_write( drive_t *drivep, char *bufp, size_t retcnt )
+do_write(drive_t *drivep, char *bufp, size_t retcnt)
 {
 	drive_context_t *contextp;
 	rec_hdr_t *rechdrp;
@@ -2002,33 +2002,33 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 
 	/* get drive context and pointer to global write hdr
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 	gwhdrp = drivep->d_gwritehdrp;
 
 	/* calculate how many bytes we believe caller is holding
 	 */
-	heldcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
+	heldcnt = (size_t)(contextp->dc_nextp - contextp->dc_ownedp);
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: write: retcnt %u (0x%x) heldcnt %u (0x%x)\n",
 	      retcnt,
 	      retcnt,
 	      heldcnt,
-	      heldcnt );
+	      heldcnt);
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_errorpr );
-	assert( contextp->dc_ownedp );
-	assert( contextp->dc_recp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp <= contextp->dc_recendp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_errorpr);
+	assert(contextp->dc_ownedp);
+	assert(contextp->dc_recp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp <= contextp->dc_recendp);
 
 	/* verify the caller is returning exactly what is held
 	 */
-	assert( bufp == contextp->dc_ownedp );
-	assert( retcnt == heldcnt );
+	assert(bufp == contextp->dc_ownedp);
+	assert(retcnt == heldcnt);
 
 	/* take it back
 	 */
@@ -2037,30 +2037,30 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	/* if some portion of the record buffer has not yet been
 	 * held by the client, just return.
 	 */
-	if ( contextp->dc_nextp < contextp->dc_recendp ) {
+	if (contextp->dc_nextp < contextp->dc_recendp) {
 		return 0;
 	}
 
 	/* record in record header that entire record is used
 	 */
-	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
 	rechdrp->rec_used = tape_recsz;
 
 	/* write out the record buffer and get a new one.
 	 */
-	if ( contextp->dc_singlethreadedpr ) {
-		rval = write_record( drivep, contextp->dc_recp, BOOL_TRUE, BOOL_TRUE );
+	if (contextp->dc_singlethreadedpr) {
+		rval = write_record(drivep, contextp->dc_recp, BOOL_TRUE, BOOL_TRUE);
 		last_rec_wrtn_wo_err = contextp->dc_reccnt; /* conv cnt to ix */
 	} else {
 		contextp->dc_msgp->rm_op = RING_OP_WRITE;
 		contextp->dc_msgp->rm_user = contextp->dc_reccnt;
-		Ring_put( contextp->dc_ringp,
-			  contextp->dc_msgp );
+		Ring_put(contextp->dc_ringp,
+			  contextp->dc_msgp);
 		contextp->dc_msgp = 0;
-		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
+		contextp->dc_msgp = Ring_get(contextp->dc_ringp);
 		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 		last_rec_wrtn_wo_err = contextp->dc_msgp->rm_user;
-		switch( contextp->dc_msgp->rm_stat ) {
+		switch(contextp->dc_msgp->rm_stat) {
 		case RING_STAT_OK:
 		case RING_STAT_INIT:
 			rval = 0;
@@ -2069,7 +2069,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 			rval = contextp->dc_msgp->rm_rval;
 			break;
 		default:
-			assert( 0 );
+			assert(0);
 			return DRIVE_ERROR_CORE;
 		}
 	}
@@ -2077,7 +2077,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	/* check for errors. if none, commit all marks before a safety margin
 	 * before the no error offset.
 	 */
-	if ( rval ) {
+	if (rval) {
 		contextp->dc_errorpr = BOOL_TRUE;
 	} else {
 		off64_t recs_wrtn_wo_err;
@@ -2085,8 +2085,8 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 		off64_t bytes_committed;
 		recs_wrtn_wo_err = last_rec_wrtn_wo_err + 1;
 		recs_committed = recs_wrtn_wo_err - contextp->dc_lostrecmax;
-		bytes_committed = recs_committed * ( off64_t )tape_recsz;
-		drive_mark_commit( drivep, bytes_committed );
+		bytes_committed = recs_committed * (off64_t)tape_recsz;
+		drive_mark_commit(drivep, bytes_committed);
 	}
 
 	/* adjust context
@@ -2099,15 +2099,15 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 
 	/* intialize header in new record
 	 */
-	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+	rechdrp = (rec_hdr_t *)contextp->dc_recp;
 	rechdrp->magic = STAPE_MAGIC;
 	rechdrp->version = STAPE_VERSION;
-	rechdrp->file_offset = contextp->dc_reccnt * ( off64_t )tape_recsz;
-	rechdrp->blksize = ( int32_t )tape_blksz;
-	rechdrp->recsize = ( int32_t )tape_recsz;
+	rechdrp->file_offset = contextp->dc_reccnt * (off64_t)tape_recsz;
+	rechdrp->blksize = (int32_t)tape_blksz;
+	rechdrp->recsize = (int32_t)tape_recsz;
 	rechdrp->capability = drivep->d_capabilities;
 	rechdrp->first_mark_offset = -1LL;
-	uuid_copy( rechdrp->dump_uuid, gwhdrp->gh_dumpid );
+	uuid_copy(rechdrp->dump_uuid, gwhdrp->gh_dumpid);
 
 	return rval;
 }
@@ -2120,40 +2120,40 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
  *	the number of bytes to next alignment
  */
 static size_t
-do_get_align_cnt( drive_t * drivep )
+do_get_align_cnt(drive_t * drivep)
 {
 	char *next_alignment_point;
 	intptr_t next_alignment_off;
 	drive_context_t *contextp;
 
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: get align cnt\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: get align cnt\n");
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_recp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp < contextp->dc_recendp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_recp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp < contextp->dc_recendp);
 
 	/* calculate the next alignment point at or beyond the current nextp.
 	 * the following algorithm works because all buffers are page-aligned
 	 * and a multiple of PGSZ.
 	 */
-	next_alignment_off = ( intptr_t )contextp->dc_nextp;
+	next_alignment_off = (intptr_t)contextp->dc_nextp;
 	next_alignment_off +=  PGMASK;
 	next_alignment_off &= ~PGMASK;
-	next_alignment_point = ( char * )next_alignment_off;
-	assert( next_alignment_point <= contextp->dc_recendp );
+	next_alignment_point = (char *)next_alignment_off;
+	assert(next_alignment_point <= contextp->dc_recendp);
 
 	/* return the number of bytes to the next alignment offset
 	 */
-	assert( next_alignment_point >= contextp->dc_nextp );
-	return ( size_t )( next_alignment_point - contextp->dc_nextp );
+	assert(next_alignment_point >= contextp->dc_nextp);
+	return (size_t)(next_alignment_point - contextp->dc_nextp);
 }
 
 /* do_end_write - pad and write pending record if any client data in it.
@@ -2164,9 +2164,9 @@ do_get_align_cnt( drive_t * drivep )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_end_write( drive_t *drivep, off64_t *ncommittedp )
+do_end_write(drive_t *drivep, off64_t *ncommittedp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t first_rec_w_err; /* zero-based index */
 	off64_t recs_wtn_wo_err;
 	off64_t recs_guaranteed;
@@ -2174,17 +2174,17 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 
 	int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: end write\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: end write\n");
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_recp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
-	assert( contextp->dc_nextp < contextp->dc_recendp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_recp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ);
+	assert(contextp->dc_nextp < contextp->dc_recendp);
 
 	/* pre-initialize return of count of bytes committed to media
 	 */
@@ -2194,46 +2194,46 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * to do anymore writes, just cleanup and return 0. don't need to
 	 * do commits, already done when error occured.
 	 */
-	if ( contextp->dc_errorpr ) {
-		if ( ! contextp->dc_singlethreadedpr ) {
-			Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (contextp->dc_errorpr) {
+		if (! contextp->dc_singlethreadedpr) {
+			Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 			contextp->dc_msgp = 0;
 		}
 		contextp->dc_mode = OM_NONE;
-		drive_mark_discard( drivep );
-		*ncommittedp = ( contextp->dc_iocnt - contextp->dc_lostrecmax )
+		drive_mark_discard(drivep);
+		*ncommittedp = (contextp->dc_iocnt - contextp->dc_lostrecmax)
 			       *
-			       ( off64_t )tape_recsz;
+			       (off64_t)tape_recsz;
 		contextp->dc_recp = 0;
 		return 0;
 	}
 
 	/* if any user data in current record buffer, send it out.
 	 */
-	if ( contextp->dc_nextp > contextp->dc_recp + STAPE_HDR_SZ ) {
+	if (contextp->dc_nextp > contextp->dc_recp + STAPE_HDR_SZ) {
 		rec_hdr_t *rechdrp;
 		size_t bufusedcnt;
 
-		rechdrp = ( rec_hdr_t * )contextp->dc_recp;
-		bufusedcnt = ( size_t )( contextp->dc_nextp
+		rechdrp = (rec_hdr_t *)contextp->dc_recp;
+		bufusedcnt = (size_t)(contextp->dc_nextp
 					 -
-					 contextp->dc_recp );
+					 contextp->dc_recp);
 		rechdrp->rec_used = bufusedcnt;
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "writing padded last record\n" );
-		if ( contextp->dc_singlethreadedpr ) {
-			rval = write_record( drivep,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "writing padded last record\n");
+		if (contextp->dc_singlethreadedpr) {
+			rval = write_record(drivep,
 					     contextp->dc_recp,
-					     BOOL_TRUE, BOOL_TRUE );
+					     BOOL_TRUE, BOOL_TRUE);
 		} else {
-			assert( contextp->dc_msgp );
+			assert(contextp->dc_msgp);
 			contextp->dc_msgp->rm_op = RING_OP_WRITE;
 			contextp->dc_msgp->rm_user = contextp->dc_reccnt;
-			Ring_put( contextp->dc_ringp,
-				  contextp->dc_msgp );
+			Ring_put(contextp->dc_ringp,
+				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
-			contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-			switch( contextp->dc_msgp->rm_stat ) {
+			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+			switch(contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
 				rval = 0;
@@ -2242,7 +2242,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 				rval = contextp->dc_msgp->rm_rval;
 				break;
 			default:
-				assert( 0 );
+				assert(0);
 				contextp->dc_recp = 0;
 				return DRIVE_ERROR_CORE;
 			}
@@ -2259,7 +2259,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * media, and that will be used to select which marks
 	 * to commit and which to discard.
 	 */
-	if ( rval ) {
+	if (rval) {
 		first_rec_w_err = contextp->dc_iocnt;
 			/* because dc_iocnt bumped by write_record
 			 * only if no error
@@ -2267,28 +2267,28 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	} else {
 		first_rec_w_err = -1L;
 	}
-	if ( ! contextp->dc_singlethreadedpr ) {
-		while ( ! rval ) {
-			assert( contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		while (! rval) {
+			assert(contextp->dc_msgp);
 			contextp->dc_msgp->rm_op = RING_OP_TRACE;
-			Ring_put( contextp->dc_ringp,
-				  contextp->dc_msgp );
+			Ring_put(contextp->dc_ringp,
+				  contextp->dc_msgp);
 			contextp->dc_msgp = 0;
-			contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-			if ( contextp->dc_msgp->rm_op == RING_OP_TRACE ) {
+			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+			if (contextp->dc_msgp->rm_op == RING_OP_TRACE) {
 				break;
 			}
-			switch( contextp->dc_msgp->rm_stat ) {
+			switch(contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 			case RING_STAT_INIT:
-				assert( rval == 0 );
+				assert(rval == 0);
 				break;
 			case RING_STAT_ERROR:
 				rval = contextp->dc_msgp->rm_rval;
 				first_rec_w_err = contextp->dc_msgp->rm_user;
 				break;
 			default:
-				assert( 0 );
+				assert(0);
 				contextp->dc_recp = 0;
 				return DRIVE_ERROR_CORE;
 			}
@@ -2297,8 +2297,8 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 
 	/* the ring is now flushed. reset
 	 */
-	if ( ! contextp->dc_singlethreadedpr ) {
-		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 	contextp->dc_recp = 0;
@@ -2307,30 +2307,30 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * side-effect of flushing the driver/drive of pending writes,
 	 * exposing any write errors.
 	 */
-	if ( ! rval ) {
+	if (! rval) {
 		int weofrval;
 		mtstat_t mtstat;
 		bool_t ok;
 
-		weofrval = mt_op( contextp->dc_fd, MTWEOF, 1 );
-		if ( ! weofrval ) {
-			ok = mt_get_status( drivep, &mtstat );
-			if ( ! ok ) {
-				status_failed_message( drivep );
+		weofrval = mt_op(contextp->dc_fd, MTWEOF, 1);
+		if (! weofrval) {
+			ok = mt_get_status(drivep, &mtstat);
+			if (! ok) {
+				status_failed_message(drivep);
 				mtstat = 0;
 				rval = DRIVE_ERROR_DEVICE;
 			}
 		} else {
 			mtstat = 0;
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "MTWEOF returned %d: errno == %d (%s)\n",
 			      weofrval,
 			      errno,
-			      strerror( errno ));
+			      strerror(errno));
 		}
-		if ( weofrval || IS_EW( mtstat ) || IS_EOT( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
-			     "hit EOM trying to write file mark\n" );
+		if (weofrval || IS_EW(mtstat) || IS_EOT(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
+			     "hit EOM trying to write file mark\n");
 			rval = DRIVE_ERROR_EOM;
 		}
 	}
@@ -2349,18 +2349,18 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * and return rval. return by reference the number of bytes committed
 	 * to tape.
 	 */
-	if ( rval ) {
-		assert( first_rec_w_err >= 0 );
+	if (rval) {
+		assert(first_rec_w_err >= 0);
 		recs_wtn_wo_err = first_rec_w_err;
 		recs_guaranteed = recs_wtn_wo_err - contextp->dc_lostrecmax;
 	} else {
-		assert( first_rec_w_err == -1 );
+		assert(first_rec_w_err == -1);
 		recs_wtn_wo_err = contextp->dc_iocnt;
 		recs_guaranteed = recs_wtn_wo_err;
 	}
-	bytes_committed = recs_guaranteed * ( off64_t )tape_recsz;
-	drive_mark_commit( drivep, bytes_committed );
-	drive_mark_discard( drivep );
+	bytes_committed = recs_guaranteed * (off64_t)tape_recsz;
+	drive_mark_commit(drivep, bytes_committed);
+	drive_mark_discard(drivep);
 	contextp->dc_mode = OM_NONE;
 	*ncommittedp = bytes_committed;
 	return rval;
@@ -2374,7 +2374,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
  *	*statp set to zero or DRIVE_ERROR_...
  */
 static int
-do_fsf( drive_t *drivep, int count, int *statp )
+do_fsf(drive_t *drivep, int count, int *statp)
 {
 	int 		i, done, op_failed, opcount;
 	mtstat_t mtstat;
@@ -2382,42 +2382,42 @@ do_fsf( drive_t *drivep, int count, int *statp )
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* verify protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_NONE );
+	assert(contextp->dc_mode == OM_NONE);
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: fsf: count %d\n",
-	      count );
+	      count);
 
-	assert( count );
-	assert( contextp->dc_mode == OM_NONE );
+	assert(count);
+	assert(contextp->dc_mode == OM_NONE);
 
 	/* get tape status
   	 */
-	if ( ! mt_get_status( drivep, &mtstat) ) {
-		status_failed_message( drivep );
+	if (! mt_get_status(drivep, &mtstat)) {
+		status_failed_message(drivep);
 		*statp = DRIVE_ERROR_DEVICE;
 		return 0;
 	}
 
-	for ( i = 0 ; i < count; i++ ) {
+	for (i = 0 ; i < count; i++) {
 		done = 0;
 		opcount = 2;
 
 		/* the tape may encounter errors will trying to
 		 * reach the next file.
 		 */
-		while ( !done ) {
+		while (!done) {
 			/* check for end-of-data and end-of-tape conditions
 			 */
-			if ( IS_EOT( mtstat ) ) {
+			if (IS_EOT(mtstat)) {
 				*statp = DRIVE_ERROR_EOM;
 				return i;
 
-			} else if ( IS_EOD( mtstat ) ) {
+			} else if (IS_EOD(mtstat)) {
 				*statp = DRIVE_ERROR_EOD;
 				return i;
 			}
@@ -2426,17 +2426,17 @@ do_fsf( drive_t *drivep, int count, int *statp )
 			 * NOTE:
 			 * 	ignore return code
 			 */
-			mlog( MLOG_VERBOSE | MLOG_DRIVE,
-			      _("advancing tape to next media file\n") );
+			mlog(MLOG_VERBOSE | MLOG_DRIVE,
+			      _("advancing tape to next media file\n"));
 
 			op_failed = 0;
-			assert( contextp->dc_fd >= 0 );
-			if ( mt_op( contextp->dc_fd, MTFSF, 1 ) ) {
+			assert(contextp->dc_fd >= 0);
+			if (mt_op(contextp->dc_fd, MTFSF, 1)) {
 				op_failed = 1;
 			}
 
-			if ( ! mt_get_status( drivep, &mtstat) ) {
-				status_failed_message( drivep );
+			if (! mt_get_status(drivep, &mtstat)) {
+				status_failed_message(drivep);
 				*statp = DRIVE_ERROR_DEVICE;
 				return i;
 			}
@@ -2444,7 +2444,7 @@ do_fsf( drive_t *drivep, int count, int *statp )
 			/* Check for a file mark to
 			 * determine if the fsf command worked.
 			 */
-			if ( (!op_failed) && (IS_FMK(mtstat)) ) {
+			if ((!op_failed) && (IS_FMK(mtstat))) {
 				done = 1;
 			}
 
@@ -2452,9 +2452,9 @@ do_fsf( drive_t *drivep, int count, int *statp )
 			 * times, and a file mark has not been reached,
 			 * return an error.
 			 */
-			if ( --opcount < 0 ) {
-				mlog( MLOG_VERBOSE | MLOG_DRIVE,
-					_("FSF tape command failed\n") );
+			if (--opcount < 0) {
+				mlog(MLOG_VERBOSE | MLOG_DRIVE,
+					_("FSF tape command failed\n"));
 
 				*statp = DRIVE_ERROR_DEVICE;
 				return i;
@@ -2474,19 +2474,19 @@ do_fsf( drive_t *drivep, int count, int *statp )
  *	*statp set to zero or DRIVE_ERROR_...
  */
 static int
-do_bsf( drive_t *drivep, int count, int *statp )
+do_bsf(drive_t *drivep, int count, int *statp)
 {
 #ifdef DEBUG
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 #endif
 	int skipped;
 	mtstat_t mtstat;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "drive op: bsf: count %d\n",
-	      count );
+	      count);
 
-	assert( contextp->dc_mode == OM_NONE );
+	assert(contextp->dc_mode == OM_NONE);
 
 	*statp = 0;
 
@@ -2497,29 +2497,29 @@ do_bsf( drive_t *drivep, int count, int *statp )
 
 	/* get tape status
 	 */
-	if ( ! mt_get_status( drivep, &mtstat )) {
-		status_failed_message( drivep );
+	if (! mt_get_status(drivep, &mtstat)) {
+		status_failed_message(drivep);
 		*statp = DRIVE_ERROR_DEVICE;
 		return 0;
 	}
 
 	/* check for beginning-of-tape condition. close/reopen hack here
 	 */
-	if ( IS_BOT( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "reopening drive while at BOT\n" );
-		Close( drivep );
-		if ( ! Open( drivep )) {
-			display_access_failed_message( drivep );
+	if (IS_BOT(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "reopening drive while at BOT\n");
+		Close(drivep);
+		if (! Open(drivep)) {
+			display_access_failed_message(drivep);
 			*statp = DRIVE_ERROR_DEVICE;
 			return 0;
 		}
-		if ( ! mt_get_status( drivep, &mtstat )) {
-			status_failed_message( drivep );
+		if (! mt_get_status(drivep, &mtstat)) {
+			status_failed_message(drivep);
 			*statp = DRIVE_ERROR_DEVICE;
 			return 0;
 		}
-		assert( IS_BOT(mtstat ));
+		assert(IS_BOT(mtstat));
 
 
 		*statp = DRIVE_ERROR_BOM;
@@ -2529,18 +2529,18 @@ do_bsf( drive_t *drivep, int count, int *statp )
 	/* check if already at (and to right of) file mark and
 	 * count is zero.
 	 */
-	if ( IS_FMK( mtstat ) && count == 0 ) {
+	if (IS_FMK(mtstat) && count == 0) {
 		return 0;
 	}
 
 	/* back space - places us to left of previous file mark
 	 */
-	assert( drivep->d_capabilities & DRIVE_CAP_BSF );
-	mtstat = bsf_and_verify( drivep );
+	assert(drivep->d_capabilities & DRIVE_CAP_BSF);
+	mtstat = bsf_and_verify(drivep);
 
 	/* check again for beginning-of-tape condition
 	 */
-	if ( IS_BOT( mtstat )) {
+	if (IS_BOT(mtstat)) {
 		*statp = DRIVE_ERROR_BOM;
 		return 0;
 	}
@@ -2550,8 +2550,8 @@ do_bsf( drive_t *drivep, int count, int *statp )
 	 * TS devices !!!  LINUX ST tape driver only reports
 	 * GMT_EOF to the right of the filemark !!
 	 */
-	if ( TS_ISDRIVER ) {
-		if ( ! IS_FMK( mtstat )) {
+	if (TS_ISDRIVER) {
+		if (! IS_FMK(mtstat)) {
 			*statp = DRIVE_ERROR_DEVICE;
 			return 0;
 		}
@@ -2559,18 +2559,18 @@ do_bsf( drive_t *drivep, int count, int *statp )
 
 	/* now loop, skipping media files
 	 */
-	for ( skipped = 0 ; skipped < count ; skipped++ ) {
+	for (skipped = 0 ; skipped < count ; skipped++) {
 
 		/* move to the left of the next file mark on the left.
 		 * check for BOT.
 		 */
-		mtstat = bsf_and_verify( drivep );
-		if ( IS_BOT( mtstat )) {
+		mtstat = bsf_and_verify(drivep);
+		if (IS_BOT(mtstat)) {
 			*statp = DRIVE_ERROR_BOM;
 			return skipped + 1;
 		}
-		if ( TS_ISDRIVER ) {
-			if ( ! IS_FMK( mtstat )) {
+		if (TS_ISDRIVER) {
+			if (! IS_FMK(mtstat)) {
 				*statp = DRIVE_ERROR_DEVICE;
 				return 0;
 			}
@@ -2579,11 +2579,11 @@ do_bsf( drive_t *drivep, int count, int *statp )
 
 	/* finally, move to the right side of the file mark
 	 */
-	mtstat = fsf_and_verify( drivep );
-	if( IS_EOT( mtstat )) {
+	mtstat = fsf_and_verify(drivep);
+	if(IS_EOT(mtstat)) {
 		*statp = DRIVE_ERROR_EOM;
 	}
-	if ( ! IS_FMK( mtstat )) {
+	if (! IS_FMK(mtstat)) {
 		*statp = DRIVE_ERROR_DEVICE;
 	}
 
@@ -2600,23 +2600,23 @@ do_bsf( drive_t *drivep, int count, int *statp )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_rewind( drive_t *drivep )
+do_rewind(drive_t *drivep)
 {
 #ifdef DEBUG
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 #endif
 	mtstat_t mtstat;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: rewind\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: rewind\n");
 
-	assert( contextp->dc_mode == OM_NONE );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(contextp->dc_fd >= 0);
 
 	/* use validating tape rewind util func
 	 */
-	mtstat = rewind_and_verify( drivep );
-	if ( ! IS_BOT( mtstat )) {
+	mtstat = rewind_and_verify(drivep);
+	if (! IS_BOT(mtstat)) {
 		return DRIVE_ERROR_DEVICE;
 	} else {
 		return 0;
@@ -2631,40 +2631,40 @@ do_rewind( drive_t *drivep )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_erase( drive_t *drivep )
+do_erase(drive_t *drivep)
 {
 #ifdef DEBUG
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 #endif
 	mtstat_t mtstat;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: erase\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: erase\n");
 
-	assert( contextp->dc_mode == OM_NONE );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(contextp->dc_fd >= 0);
 
 	/* use validating tape rewind util func
 	 */
-	mtstat = rewind_and_verify( drivep );
-	if ( ! IS_BOT( mtstat )) {
+	mtstat = rewind_and_verify(drivep);
+	if (! IS_BOT(mtstat)) {
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* use validating tape erase util func
 	 */
-	( void )erase_and_verify( drivep );
+	(void)erase_and_verify(drivep);
 
 	/* rewind again
 	 */
-	mtstat = rewind_and_verify( drivep );
-	if ( ! IS_BOT( mtstat )) {
+	mtstat = rewind_and_verify(drivep);
+	if (! IS_BOT(mtstat)) {
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* close the drive so we start from scratch
 	 */
-	Close( drivep );
+	Close(drivep);
 	return 0;
 }
 
@@ -2676,27 +2676,27 @@ do_erase( drive_t *drivep )
  *	DRIVE_ERROR_DEVICE on failure
  */
 static int
-do_eject_media( drive_t *drivep )
+do_eject_media(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: eject media\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: eject media\n");
 
 	/* drive must be open
 	 */
-	assert( contextp->dc_fd >= 0 );
-	assert( contextp->dc_mode == OM_NONE );
+	assert(contextp->dc_fd >= 0);
+	assert(contextp->dc_mode == OM_NONE);
 
 	/* issue tape unload
 	 */
-	if ( contextp->dc_unloadokpr ) {
-		( void )mt_op( contextp->dc_fd, MTUNLOAD, 0 );
+	if (contextp->dc_unloadokpr) {
+		(void)mt_op(contextp->dc_fd, MTUNLOAD, 0);
 	}
 
 	/* close the device driver
 	 */
-	Close( drivep );
+	Close(drivep);
 
 	return 0;
 }
@@ -2709,10 +2709,10 @@ do_eject_media( drive_t *drivep )
  */
 /* ARGSUSED */
 static int
-do_get_device_class( drive_t *drivep)
+do_get_device_class(drive_t *drivep)
 {
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: get device class\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: get device class\n");
 
 	return DEVICE_TAPE_REMOVABLE;
 }
@@ -2720,69 +2720,69 @@ do_get_device_class( drive_t *drivep)
 /* do_display_metrics - print ring stats if using I/O ring
  */
 static void
-do_display_metrics( drive_t *drivep )
+do_display_metrics(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	ring_t *ringp = contextp->dc_ringp;
 
-	if ( ringp ) {
-		if ( drivecnt > 1 ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_DRIVE,
+	if (ringp) {
+		if (drivecnt > 1) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_DRIVE,
 			      _("drive %u "),
-			      drivep->d_index );
+			      drivep->d_index);
 		}
-		display_ring_metrics( drivep,
-				      MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK );
+		display_ring_metrics(drivep,
+				      MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK);
 	}
 }
 
 /* do_quit
  */
 static void
-do_quit( drive_t *drivep )
+do_quit(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	ring_t *ringp = contextp->dc_ringp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op: quit\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op: quit\n");
 
 	/* print the ring metrics and kill the ring
 	 */
-	if ( ringp ) {
-		display_ring_metrics( drivep, MLOG_VERBOSE );
+	if (ringp) {
+		display_ring_metrics(drivep, MLOG_VERBOSE);
 
 		/* tell slave to die
 		 */
-		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
-		      "ring op: destroy\n" );
-		ring_destroy( ringp );
+		mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
+		      "ring op: destroy\n");
+		ring_destroy(ringp);
 	}
 
-	if ( ! contextp->dc_isvarpr
+	if (! contextp->dc_isvarpr
 	     &&
 	     ! contextp->dc_isQICpr
 	     &&
 	     contextp->dc_cansetblkszpr
 	     &&
-	     ( contextp->dc_origcurblksz != 0 ) ) {
-		( void )set_fixed_blksz( drivep, contextp->dc_origcurblksz );
+	     (contextp->dc_origcurblksz != 0)) {
+		(void)set_fixed_blksz(drivep, contextp->dc_origcurblksz);
 	}
 
 	/* issue tape unload
 	 */
-	if ( contextp->dc_unloadokpr ) {
-		( void )mt_op( contextp->dc_fd, MTUNLOAD, 0 );
+	if (contextp->dc_unloadokpr) {
+		(void)mt_op(contextp->dc_fd, MTUNLOAD, 0);
 	}
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "drive op quit complete\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "drive op quit complete\n");
 }
 
 static double
-percent64( off64_t num, off64_t denom )
+percent64(off64_t num, off64_t denom)
 {
-	return ( double )( num * 100 ) / ( double )denom;
+	return (double)(num * 100) / (double)denom;
 }
 
 
@@ -2831,7 +2831,7 @@ percent64( off64_t num, off64_t denom )
 
 
 static int
-read_label( drive_t *drivep )
+read_label(drive_t *drivep)
 {
 	drive_context_t *contextp;
 	int nread;
@@ -2843,46 +2843,46 @@ read_label( drive_t *drivep )
 
 	/* initialize context ptr
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* if not at BOT or a file mark, advance to right of next file mark
 	 */
-	ok = mt_get_status( drivep, &mtstat );
-	if ( ! ok ) {
-		status_failed_message( drivep );
+	ok = mt_get_status(drivep, &mtstat);
+	if (! ok) {
+		status_failed_message(drivep);
 		return DRIVE_ERROR_DEVICE;
 	}
-	if ( ! IS_BOT( mtstat ) && ! IS_FMK( mtstat )) {
-		mtstat = fsf_and_verify( drivep );
+	if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
+		mtstat = fsf_and_verify(drivep);
 	}
 
 	/* if we hit EOM or early warning, just return
 	 */
-	if ( IS_EOT( mtstat ) || IS_EW( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "begin read hit EOM/EW\n" );
+	if (IS_EOT(mtstat) || IS_EW(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "begin read hit EOM/EW\n");
 		return DRIVE_ERROR_EOM;
 	}
 
 	/* if we hit EOD, a file mark is missing
 	 */
-	if ( IS_EOD( mtstat )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
-		      _("file mark missing from tape (hit EOD)\n") );
+	if (IS_EOD(mtstat)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+		      _("file mark missing from tape (hit EOD)\n"));
 #ifdef DUMP
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
-		      _("writing file mark at EOD\n") );
-		rval = mt_op( contextp->dc_fd, MTWEOF, 1 );
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING,
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+		      _("writing file mark at EOD\n"));
+		rval = mt_op(contextp->dc_fd, MTWEOF, 1);
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
 			      _("unable to write file mark at eod: %s (%d)\n"),
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			return DRIVE_ERROR_MEDIA;
 		}
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
+			status_failed_message(drivep);
 			return DRIVE_ERROR_DEVICE;
 		}
 #endif /* DUMP */
@@ -2890,9 +2890,9 @@ read_label( drive_t *drivep )
 
 	/* verify we are either at BOT or a file mark
 	 */
-	if ( ! IS_BOT( mtstat ) && ! IS_FMK( mtstat )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
-		      _("file mark missing from tape\n") );
+	if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+		      _("file mark missing from tape\n"));
 #ifdef DUMP
 		return DRIVE_ERROR_MEDIA;
 #endif
@@ -2901,7 +2901,7 @@ read_label( drive_t *drivep )
 	/* remember if we were at BOT, so we know how to reposition if EOD
 	 * encountered
 	 */
-	if ( IS_BOT( mtstat )) {
+	if (IS_BOT(mtstat)) {
 		wasatbotpr = BOOL_TRUE;
 	} else {
 		wasatbotpr = BOOL_FALSE;
@@ -2909,18 +2909,18 @@ read_label( drive_t *drivep )
 
 	/* read the first record of the media file directly
 	 */
-	nread = Read( drivep,
+	nread = Read(drivep,
 		      contextp->dc_recp,
 		      tape_recsz,
-		      &saved_errno );
+		      &saved_errno);
 
 	/* if a read error, get status
 	 */
-	if ( nread != ( int )tape_recsz ) {
-		assert( nread < ( int )tape_recsz );
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+	if (nread != (int)tape_recsz) {
+		assert(nread < (int)tape_recsz);
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
+			status_failed_message(drivep);
 			return DRIVE_ERROR_DEVICE;
 		}
 	} else {
@@ -2929,29 +2929,29 @@ read_label( drive_t *drivep )
 
 	/* check for an unexpected errno
 	 */
-	if ( nread < 0 && saved_errno != ENOSPC ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (nread < 0 && saved_errno != ENOSPC) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("could not read from drive: %s (%d)\n"),
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* check for a blank tape. NOTE: shouldn't get here!
 	 */
-	if ( nread == 0 && wasatbotpr ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (nread == 0 && wasatbotpr) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("unexpectedly encountered EOD at BOT: "
-		      "assuming corrupted media\n") );
-		( void )rewind_and_verify( drivep );
+		      "assuming corrupted media\n"));
+		(void)rewind_and_verify(drivep);
 		return DRIVE_ERROR_MEDIA;
 	}
 
 	/* if we hit end of tape or early warning, indicate EOM
 	 */
-	if ( IS_EOT( mtstat ) || IS_EW( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "hit EOM\n" );
+	if (IS_EOT(mtstat) || IS_EW(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "hit EOM\n");
 		return DRIVE_ERROR_EOM;
 	}
 
@@ -2959,29 +2959,29 @@ read_label( drive_t *drivep )
 #ifdef DUMP
 	/* if we hit EOD, re-position in anticipation of appending.
 	 */
-	if ( IS_EOD( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "hit EOD: repositioning for append\n" );
-		if ( drivep->d_capabilities & DRIVE_CAP_BSF ) {
-			( void )bsf_and_verify( drivep );
+	if (IS_EOD(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "hit EOD: repositioning for append\n");
+		if (drivep->d_capabilities & DRIVE_CAP_BSF) {
+			(void)bsf_and_verify(drivep);
 		}
-		( void )fsf_and_verify( drivep );
+		(void)fsf_and_verify(drivep);
 		return DRIVE_ERROR_EOD;
 	}
 #endif /* DUMP */
 #ifdef RESTORE
 
         /* Linux case */
-	if ( IS_EOD( mtstat ) && IS_FMK( mtstat ) ) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "hit EOM\n" );
+	if (IS_EOD(mtstat) && IS_FMK(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "hit EOM\n");
 		return DRIVE_ERROR_EOM;
 	}
 
 
-	if ( IS_EOD( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-		      "hit EOD\n" );
+	if (IS_EOD(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+		      "hit EOD\n");
 		return DRIVE_ERROR_EOD;
 	}
 #endif /* RESTORE */
@@ -2989,11 +2989,11 @@ read_label( drive_t *drivep )
 	/* if we hit a file mark, this is very bad.
 	 * indicates the media has been corrupted
 	 */
-	if ( IS_FMK( mtstat )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (IS_FMK(mtstat)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("unexpectedly encountered a file mark: "
-		      "assuming corrupted media\n") );
-		( void )rewind_and_verify( drivep );
+		      "assuming corrupted media\n"));
+		(void)rewind_and_verify(drivep);
 		return DRIVE_ERROR_MEDIA;
 	}
 
@@ -3001,13 +3001,13 @@ read_label( drive_t *drivep )
 	 */
 	contextp->dc_iocnt = 1;
 
-	rval = validate_media_file_hdr( drivep );
+	rval = validate_media_file_hdr(drivep);
 
 	return rval;
 }
 
 static int
-validate_media_file_hdr( drive_t *drivep )
+validate_media_file_hdr(drive_t *drivep)
 {
 	global_hdr_t		*grhdrp = drivep->d_greadhdrp;
 	drive_hdr_t		*drhdrp = drivep->d_readhdrp;
@@ -3024,10 +3024,10 @@ validate_media_file_hdr( drive_t *drivep )
 	content_hdr_t		*tmpch = (content_hdr_t *)tmpmh->mh_upper;
 	content_inode_hdr_t	*tmpcih = (content_inode_hdr_t *)tmpch->ch_specific;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "validating media file header\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "validating media file header\n");
 
-	memcpy( tmpbuf, contextp->dc_recp, GLOBAL_HDR_SZ );
+	memcpy(tmpbuf, contextp->dc_recp, GLOBAL_HDR_SZ);
 
 	mlog(MLOG_NITTY, "validate_media_file_hdr\n"
 	     "\tgh_magic %.100s\n"
@@ -3047,14 +3047,14 @@ validate_media_file_hdr( drive_t *drivep )
 
 	/* check the checksum
 	 */
-	if ( ! global_hdr_checksum_check( tmpgh )) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (! global_hdr_checksum_check(tmpgh)) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "bad media file header checksum\n");
 	        return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( ! tape_rec_checksum_check( contextp, contextp->dc_recp )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (! tape_rec_checksum_check(contextp, contextp->dc_recp)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "tape record checksum error\n");
 		return DRIVE_ERROR_CORRUPTION;
 
@@ -3067,54 +3067,54 @@ validate_media_file_hdr( drive_t *drivep )
 	xlate_content_inode_hdr(tmpcih, cih, 1);
 	xlate_rec_hdr(tmprh, tprhdrp, 1);
 
-	memcpy( contextp->dc_recp, grhdrp, GLOBAL_HDR_SZ );
+	memcpy(contextp->dc_recp, grhdrp, GLOBAL_HDR_SZ);
 
 	/* check the magic number
 	 */
-	if ( strncmp( grhdrp->gh_magic, GLOBAL_HDR_MAGIC,GLOBAL_HDR_MAGIC_SZ)) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC,GLOBAL_HDR_MAGIC_SZ)) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "missing magic number in tape label\n");
 	        return DRIVE_ERROR_FORMAT;
 	}
 
 	/* check the version
 	 */
-	if ( global_version_check( grhdrp->gh_version ) != BOOL_TRUE ) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (global_version_check(grhdrp->gh_version) != BOOL_TRUE) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "invalid version number (%d) in tape label\n",
-		      grhdrp->gh_version );
+		      grhdrp->gh_version);
 	        return DRIVE_ERROR_VERSION;
 	}
 
 	/* check the strategy id
 	 */
-	if ( drhdrp->dh_strategyid != drivep->d_strategyp->ds_id ) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (drhdrp->dh_strategyid != drivep->d_strategyp->ds_id) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	               "unrecognized drive strategy ID (%d)\n",
-	               drivep->d_readhdrp->dh_strategyid );
+	               drivep->d_readhdrp->dh_strategyid);
 	        return DRIVE_ERROR_FORMAT;
 	}
 
 	/* check the record magic number
 	 */
-	if ( tprhdrp->magic != STAPE_MAGIC ) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (tprhdrp->magic != STAPE_MAGIC) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "invalid record magic number in tape label\n");
 	        return DRIVE_ERROR_FORMAT;
 	}
 
 	/* check the record version number
 	 */
-	if ( tprhdrp->version != STAPE_VERSION ) {
-	        mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (tprhdrp->version != STAPE_VERSION) {
+	        mlog(MLOG_DEBUG | MLOG_DRIVE,
 	              "invalid record version number in tape label\n");
 	        return DRIVE_ERROR_VERSION;
 	}
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "media file header valid: "
 	      "media file ix %d\n",
-	      mrhdrp->mh_mediafileix );
+	      mrhdrp->mh_mediafileix);
 
 	return 0;
 }
@@ -3132,59 +3132,59 @@ validate_media_file_hdr( drive_t *drivep )
  *	FALSE on failure
  */
 static bool_t
-set_fixed_blksz( drive_t *drivep, size_t blksz )
+set_fixed_blksz(drive_t *drivep, size_t blksz)
 {
-	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	ix_t try;
 
 	/* sanity checks
 	 */
-	assert( blksz );
-	assert( contextp->dc_isvarpr == BOOL_FALSE );
-	assert( contextp->dc_cansetblkszpr );
-	assert( contextp->dc_fd >= 0 );
+	assert(blksz);
+	assert(contextp->dc_isvarpr == BOOL_FALSE);
+	assert(contextp->dc_cansetblkszpr);
+	assert(contextp->dc_fd >= 0);
 
 	/* give it two tries: first without rewinding, second with rewinding
 	 */
-	for ( try = 1 ; try <= 2 ; try++ ) {
+	for (try = 1 ; try <= 2 ; try++) {
 		struct mtblkinfo mtinfo;
 
 		/* set the tape block size. requires re-open
 	 	 */
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "setting fixed block size to %d\n",
-		      blksz );
+		      blksz);
 
 		/* close and re-open
 		 */
-		Close( drivep );
-		if ( ! Open( drivep )) {
-			display_access_failed_message( drivep );
+		Close(drivep);
+		if (! Open(drivep)) {
+			display_access_failed_message(drivep);
 			return BOOL_FALSE;
 		}
 
                 /* issue call to set block size
                  */
-                if ( mt_op( contextp->dc_fd,
+                if (mt_op(contextp->dc_fd,
                             MTSETBLK,
-                            ( int )blksz ) ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+                            (int)blksz)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "MTSETBLK %u failed: %s (%d)\n",
 			      blksz,
-			      strerror( errno ),
+			      strerror(errno),
 			      errno);
 		}
 
 		/* see if we were successful (can't look if RMT, so assume
 		 * it worked)
 		 */
-		if ( ! contextp->dc_isrmtpr ) {
+		if (! contextp->dc_isrmtpr) {
                         bool_t ok;
-                        ok = mt_blkinfo( contextp->dc_fd, &mtinfo );
-                        if ( ! ok ) {
+                        ok = mt_blkinfo(contextp->dc_fd, &mtinfo);
+                        if (! ok) {
                                 return BOOL_FALSE;
                         }
-                        if ( mtinfo.curblksz == blksz ) {
+                        if (mtinfo.curblksz == blksz) {
                                 return BOOL_TRUE;
                         }
 		} else {
@@ -3193,12 +3193,12 @@ set_fixed_blksz( drive_t *drivep, size_t blksz )
 
 		/* so rewind and try again
 		 */
-		( void )rewind_and_verify( drivep );
+		(void)rewind_and_verify(drivep);
 	}
 
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("unable to set block size to %d\n"),
-	      blksz );
+	      blksz);
 
 	return BOOL_FALSE;
 }
@@ -3213,13 +3213,13 @@ set_fixed_blksz( drive_t *drivep, size_t blksz )
  *	FALSE on error
  */
 static bool_t
-get_tpcaps( drive_t *drivep )
+get_tpcaps(drive_t *drivep)
 {
-	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_fd >= 0);
 
-	if ( contextp->dc_isrmtpr ) {
+	if (contextp->dc_isrmtpr) {
 		/* can't ask about blksz, can't set blksz, can't ask about
 		 * drive types/caps. assume a drive which can overwrite.
 		 * assume NOT QIC, since fixed blksz devices not supported
@@ -3236,8 +3236,8 @@ get_tpcaps( drive_t *drivep )
 		 */
 		struct mtblkinfo mtinfo;
 		bool_t ok;
-		ok = mt_blkinfo( contextp->dc_fd, &mtinfo );
-		if ( ! ok ) {
+		ok = mt_blkinfo(contextp->dc_fd, &mtinfo);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 
@@ -3254,20 +3254,20 @@ get_tpcaps( drive_t *drivep )
 			contextp->dc_cangetblkszpr = BOOL_TRUE;
 			contextp->dc_cansetblkszpr = BOOL_TRUE;
 			contextp->dc_maxblksz = mtinfo.maxblksz;
-			if ( contextp->dc_origcurblksz == 0 )
+			if (contextp->dc_origcurblksz == 0)
 				contextp->dc_origcurblksz = mtinfo.curblksz;
 			drivep->d_capabilities |= DRIVE_CAP_OVERWRITE;
 			drivep->d_capabilities |= DRIVE_CAP_BSF;
 #ifdef HIDDEN
 Need to find equivalent in Linux.
-			if ( mtcapablity & MTCAN_SEEK ) {
+			if (mtcapablity & MTCAN_SEEK) {
 				contextp->dc_canfsrpr = BOOL_TRUE;
 			}
 #endif
 		}
 	}
 
-	set_recommended_sizes( drivep );
+	set_recommended_sizes(drivep);
 
 	return BOOL_TRUE;
 }
@@ -3280,32 +3280,32 @@ Need to find equivalent in Linux.
  *	void
  */
 static void
-set_recommended_sizes( drive_t *drivep )
+set_recommended_sizes(drive_t *drivep)
 {
-	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t	fsize = drive_strategy_scsitape.ds_recmfilesz;
 	off64_t	marksep = drive_strategy_scsitape.ds_recmarksep;
 
 	if (contextp->dc_filesz > 0) {
 		fsize = contextp->dc_filesz;
 #ifdef DUMP
-		if ( hdr_mfilesz > fsize ) {
-			mlog( MLOG_WARNING, _(
+		if (hdr_mfilesz > fsize) {
+			mlog(MLOG_WARNING, _(
 			      "recommended media file size of %llu Mb less than"
 			      " estimated file header size %llu Mb for %s\n"),
-			      fsize / ( 1024 * 1024 ),
-			      hdr_mfilesz / ( 1024 * 1024 ),
-			      drivep->d_pathname );
+			      fsize / (1024 * 1024),
+			      hdr_mfilesz / (1024 * 1024),
+			      drivep->d_pathname);
 		}
 #endif /* DUMP */
         }
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "recommended tape media file size set to 0x%llx bytes\n",
-	      fsize );
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	      fsize);
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "recommended tape media mark separation set to 0x%llx bytes\n",
-	      marksep );
+	      marksep);
 
 	drivep->d_recmfilesz = fsize;
 	drivep->d_recmarksep = marksep;
@@ -3326,36 +3326,36 @@ set_recommended_sizes( drive_t *drivep )
  *	FALSE on failure
  */
 static bool_t
-mt_blkinfo( int fd, struct mtblkinfo *minfo )
+mt_blkinfo(int fd, struct mtblkinfo *minfo)
 {
 	struct mtget 	mt_stat;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "tape op: get block size info\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "tape op: get block size info\n");
 
 	if (TS_ISDRIVER) { /* Use TS ioctl MTIOCGETBLKINFO so we don't
 			    * have to hard code the max block size  */
 		struct mtblkinfo ts_blkinfo;
-		if ( ioctl(fd, MTIOCGETBLKINFO, &ts_blkinfo) < 0 ) {
+		if (ioctl(fd, MTIOCGETBLKINFO, &ts_blkinfo) < 0) {
 			/* failure
 			 */
 			mlog(MLOG_DEBUG,
 				"tape command MTIOCGETBLKINFO failed : %d (%s)\n",
 				errno,
-				strerror( errno ));
+				strerror(errno));
 			return BOOL_FALSE;
 		}
 		minfo->curblksz = ts_blkinfo.curblksz;
 		minfo->maxblksz = ts_blkinfo.maxblksz;
 	}
 	else {
-		if ( ioctl(fd, MTIOCGET, &mt_stat) < 0 ) {
+		if (ioctl(fd, MTIOCGET, &mt_stat) < 0) {
 			/* failure
 			 */
 			mlog(MLOG_DEBUG,
 				"tape command MTIOCGET failed : %d (%s)\n",
 	 			errno,
- 	 			strerror( errno ));
+ 	 			strerror(errno));
 			return BOOL_FALSE;
 		}
 		minfo->curblksz = (mt_stat.mt_dsreg >> MT_ST_BLKSIZE_SHIFT) &
@@ -3363,7 +3363,7 @@ mt_blkinfo( int fd, struct mtblkinfo *minfo )
 		minfo->maxblksz = STAPE_MAX_LINUX_RECSZ;
 	}
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "max=%u cur=%u\n",
 	      minfo->maxblksz,
 	      minfo->curblksz);
@@ -3381,18 +3381,18 @@ mt_blkinfo( int fd, struct mtblkinfo *minfo )
  *	-1 on failure
  */
 static int
-mt_op(int fd, int sub_op, int param )
+mt_op(int fd, int sub_op, int param)
 {
 	struct mtop 	mop;
 	char *printstr;
 	int rval;
 
-	mop.mt_op   	= (short )sub_op;
+	mop.mt_op   	= (short)sub_op;
 	mop.mt_count	= param;
 
-	assert( fd >= 0 );
+	assert(fd >= 0);
 
-	switch ( sub_op ) {
+	switch (sub_op) {
 	case MTSEEK:
 		printstr = "seek";
 		break;
@@ -3427,22 +3427,22 @@ mt_op(int fd, int sub_op, int param )
 		printstr = "???";
 		break;
 	}
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: %s %d\n",
 	      printstr,
-	      param );
+	      param);
 
-	rval = ioctl( fd, MTIOCTOP, &mop );
-	if ( rval < 0 ) {
+	rval = ioctl(fd, MTIOCTOP, &mop);
+	if (rval < 0) {
 		/* failure
 	 	 */
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "tape op %s %d returns %d: errno == %d (%s)\n",
 		      printstr,
 		      param,
 		      rval,
 		      errno,
-		      strerror( errno ));
+		      strerror(errno));
 		return -1;
 	}
 
@@ -3452,25 +3452,25 @@ mt_op(int fd, int sub_op, int param )
 }
 
 static bool_t
-mt_get_fileno( drive_t *drivep, long *fileno)
+mt_get_fileno(drive_t *drivep, long *fileno)
 {
 	struct mtget 	mt_stat;
 	drive_context_t *contextp;
 
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "tape op: get fileno\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "tape op: get fileno\n");
 
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_fd >= 0);
 
-	if ( ioctl(contextp->dc_fd, MTIOCGET, &mt_stat) < 0 ) {
+	if (ioctl(contextp->dc_fd, MTIOCGET, &mt_stat) < 0) {
 		/* failure
 		 */
 		mlog(MLOG_DEBUG,
 			"tape command MTIOCGET failed : %d (%s)\n",
 	 		errno,
- 	 		strerror( errno ));
+ 	 		strerror(errno));
 		return BOOL_FALSE;
 	}
 	*fileno = mt_stat.mt_fileno;
@@ -3485,17 +3485,17 @@ mt_get_fileno( drive_t *drivep, long *fileno)
  *	FALSE if not
  */
 static bool_t
-mt_get_status( drive_t *drivep, long *status)
+mt_get_status(drive_t *drivep, long *status)
 {
 	struct mtget 	mt_stat;
 	drive_context_t *contextp;
 
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "tape op: get status\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "tape op: get status\n");
 
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_fd >= 0);
 
 	if (TS_ISDRIVER) {
 		/*
@@ -3505,24 +3505,24 @@ mt_get_status( drive_t *drivep, long *status)
 		 * See comments in map_ts_status() for more detail.
 		 */
 		struct mtget_sgi mt_stat_sgi;
-                if ( ioctl(contextp->dc_fd, MTIOCGET_SGI, &mt_stat_sgi) < 0 ) {
+                if (ioctl(contextp->dc_fd, MTIOCGET_SGI, &mt_stat_sgi) < 0) {
                         /* failure
                          */
                         mlog(MLOG_DEBUG,
                                 "tape command MTIOCGET_SGI failed : %d (%s)\n",
                                 errno,
-                                strerror( errno ));
+                                strerror(errno));
                         return BOOL_FALSE;
                 }
-		map_ts_status( &mt_stat, mt_stat_sgi );
+		map_ts_status(&mt_stat, mt_stat_sgi);
 	} else {
-		if ( ioctl(contextp->dc_fd, MTIOCGET, &mt_stat) < 0 ) {
+		if (ioctl(contextp->dc_fd, MTIOCGET, &mt_stat) < 0) {
 			/* failure
 			 */
 			mlog(MLOG_DEBUG,
 				"tape command MTIOCGET failed : %d (%s)\n",
 	 			errno,
- 	 			strerror( errno ));
+ 	 			strerror(errno));
 			return BOOL_FALSE;
 		}
 	}
@@ -3532,7 +3532,7 @@ mt_get_status( drive_t *drivep, long *status)
 	*status = mt_stat.mt_gstat;
 
 	/* print out symbolic form of tape status */
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 		"tape status = %s%s%s%s%s%s%s\n",
 		IS_BOT(*status)?   "bot ":"",
 		IS_FMK(*status)?   "fmk ":"",
@@ -3553,28 +3553,28 @@ mt_get_status( drive_t *drivep, long *status)
  *	DRIVE_ERROR_*
  */
 static int
-determine_write_error( drive_t *drivep, int nwritten, int saved_errno )
+determine_write_error(drive_t *drivep, int nwritten, int saved_errno)
 {
 	mtstat_t	mtstat;
 	int 	ret;
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* get tape device status
 	 */
-	if ( ! mt_get_status( drivep, &mtstat) ) {
-		status_failed_message( drivep );
+	if (! mt_get_status(drivep, &mtstat)) {
+		status_failed_message(drivep);
 		ret = DRIVE_ERROR_DEVICE;
-	} else if ( IS_WPROT(mtstat) && (saved_errno == EROFS)) {
+	} else if (IS_WPROT(mtstat) && (saved_errno == EROFS)) {
 
 		mlog(MLOG_NORMAL,
 		     _("tape is write protected\n"));
 
 		ret = DRIVE_ERROR_DEVICE;
-	} else if ( (!IS_BOT(mtstat)) &&
-		    (IS_EOT( mtstat ) || IS_EW( mtstat) ||
+	} else if ((!IS_BOT(mtstat)) &&
+		    (IS_EOT(mtstat) || IS_EW(mtstat) ||
 		    (saved_errno == ENOSPC))) {
  		ret = DRIVE_ERROR_EOM;
-	} else if (saved_errno == EIO ) {
+	} else if (saved_errno == EIO) {
 
 		mlog(MLOG_NORMAL,
 		     _("tape media error on write operation\n"));
@@ -3583,65 +3583,65 @@ determine_write_error( drive_t *drivep, int nwritten, int saved_errno )
 		     _("no more data can be written to this tape\n"));
 
 		ret = DRIVE_ERROR_EOM;
-	} else if ( (saved_errno == 0) &&
+	} else if ((saved_errno == 0) &&
 		    (nwritten > 0)     &&
-		    contextp->dc_isQICpr ) {
+		    contextp->dc_isQICpr) {
 		/* short write on one of this devices indicates
 		 * early warning for end-of-media.
 		 */
  		ret = DRIVE_ERROR_EOM;
 	} else {
 		ret = DRIVE_ERROR_CORE;
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 			"tape unknown error on write operation: "
 			"0x%x, %d, %d\n",
 			mtstat, nwritten, saved_errno);
 	}
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 		"tape write operation status 0x%x, nwritten %d, errno %d\n",
 		mtstat,
 		nwritten,
 		saved_errno);
 
-	return ( ret );
+	return (ret);
 
 }
 
 static void
-tape_rec_checksum_set( drive_context_t *contextp, char *bufp )
+tape_rec_checksum_set(drive_context_t *contextp, char *bufp)
 {
-	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	uint32_t *beginp = ( uint32_t * )bufp;
-	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	rec_hdr_t *rechdrp = (rec_hdr_t *)bufp;
+	uint32_t *beginp = (uint32_t *)bufp;
+	uint32_t *endp = (uint32_t *)(bufp + tape_recsz);
 	uint32_t *p;
 	uint32_t accum;
 
-	if ( ! contextp->dc_recchksumpr ) {
+	if (! contextp->dc_recchksumpr) {
 		return;
 	}
 
 	INT_SET(rechdrp->ischecksum, ARCH_CONVERT, 1);
 	rechdrp->checksum = 0;
 	accum = 0;
-	for ( p = beginp ; p < endp ; p++ ) {
+	for (p = beginp ; p < endp ; p++) {
 	        accum += INT_GET(*p, ARCH_CONVERT);
 	}
-	INT_SET(rechdrp->checksum, ARCH_CONVERT, ( int32_t )( ~accum + 1 ));
+	INT_SET(rechdrp->checksum, ARCH_CONVERT, (int32_t)(~accum + 1));
 }
 
 static bool_t
-tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
+tape_rec_checksum_check(drive_context_t *contextp, char *bufp)
 {
-	rec_hdr_t *rechdrp = ( rec_hdr_t * )bufp;
-	uint32_t *beginp = ( uint32_t * )bufp;
-	uint32_t *endp = ( uint32_t * )( bufp + tape_recsz );
+	rec_hdr_t *rechdrp = (rec_hdr_t *)bufp;
+	uint32_t *beginp = (uint32_t *)bufp;
+	uint32_t *endp = (uint32_t *)(bufp + tape_recsz);
 	uint32_t *p;
 	uint32_t accum;
 
-	if ( contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
+	if (contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
 		accum = 0;
-		for ( p = beginp ; p < endp ; p++ ) {
+		for (p = beginp ; p < endp ; p++) {
 	       		accum += INT_GET(*p, ARCH_CONVERT);
 		}
 		return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
@@ -3654,75 +3654,75 @@ tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
  */
 #ifdef RMTDBG
 static int
-dbgrmtopen( char *path, int flags )
+dbgrmtopen(char *path, int flags)
 {
 	int rval;
-	rval = rmtopen( path, flags );
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	rval = rmtopen(path, flags);
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("RMTOPEN( %s, %d ) returns %d: errno=%d (%s)\n"),
 	      path,
 	      flags,
 	      rval,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return rval;
 }
 static int
-dbgrmtclose( int fd )
+dbgrmtclose(int fd)
 {
 	int rval;
-	rval = rmtclose( fd );
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	rval = rmtclose(fd);
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("RMTCLOSE( %d ) returns %d: errno=%d (%s)\n"),
 	      fd,
 	      rval,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return rval;
 }
 static int
-dbgrmtioctl( int fd, int op, void *arg )
+dbgrmtioctl(int fd, int op, void *arg)
 {
 	int rval;
-	rval = rmtioctl( fd, op, arg );
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	rval = rmtioctl(fd, op, arg);
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("RMTIOCTL( %d, %d, 0x%x ) returns %d: errno=%d (%s)\n"),
 	      fd,
 	      op,
 	      arg,
 	      rval,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return rval;
 }
 static int
-dbgrmtread( int fd, void *p, uint sz )
+dbgrmtread(int fd, void *p, uint sz)
 {
 	int rval;
-	rval = rmtread( fd, p, sz );
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	rval = rmtread(fd, p, sz);
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("RMTREAD( %d, 0x%x, %u ) returns %d: errno=%d (%s)\n"),
 	      fd,
 	      p,
 	      sz,
 	      rval,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return rval;
 }
 static int
-dbgrmtwrite( int fd, void *p, uint sz )
+dbgrmtwrite(int fd, void *p, uint sz)
 {
 	int rval;
-	rval = rmtwrite( fd, p, sz );
-	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	rval = rmtwrite(fd, p, sz);
+	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	      _("RMTWRITE( %d, 0x%x, %u ) returns %d: errno=%d (%s)\n"),
 	      fd,
 	      p,
 	      sz,
 	      rval,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return rval;
 }
 #endif /* RMTDBG */
@@ -3734,27 +3734,27 @@ dbgrmtwrite( int fd, void *p, uint sz )
  *	void
  */
 static void
-display_access_failed_message( drive_t *drivep )
+display_access_failed_message(drive_t *drivep)
 {
 	drive_context_t		*contextp;
 
 	/* get pointer to drive context
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
-	if ( contextp->dc_isrmtpr ) {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
+	if (contextp->dc_isrmtpr) {
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
 			_("attempt to access/open remote "
 			"tape drive %s failed: %d (%s)\n"),
 			drivep->d_pathname,
 			errno,
-			strerror( errno ));
+			strerror(errno));
 	} else {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
 			_("attempt to access/open device %s failed: %d (%s)\n"),
 			drivep->d_pathname,
 			errno,
-			strerror( errno ));
+			strerror(errno));
 	}
 	return;
 }
@@ -3766,43 +3766,43 @@ display_access_failed_message( drive_t *drivep )
  *	one
  */
 static void
-status_failed_message( drive_t *drivep )
+status_failed_message(drive_t *drivep)
 {
 	drive_context_t		*contextp;
 
 	/* get pointer to drive context
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 	/* the get status call could have failed due to the
 	 * tape device being closed by a CTLR-\ from the operator.
 	 */
-	if ( contextp->dc_fd != -1 ) {
-		if ( contextp->dc_isrmtpr ) {
-		 	mlog( MLOG_NORMAL | MLOG_DRIVE,
+	if (contextp->dc_fd != -1) {
+		if (contextp->dc_isrmtpr) {
+		 	mlog(MLOG_NORMAL | MLOG_DRIVE,
 	 			_("attempt to get status of remote "
 	 			"tape drive %s failed: %d (%s)\n"),
 				drivep->d_pathname,
 				errno,
-				strerror( errno ));
+				strerror(errno));
 		} else {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
 				_("attempt to get status of "
 				"tape drive %s failed: %d (%s)\n"),
 				drivep->d_pathname,
 				errno,
-				strerror( errno ));
+				strerror(errno));
 		}
 	}
 	return;
 }
 
 static bool_t
-is_variable( drive_t *drivep, bool_t *varblk )
+is_variable(drive_t *drivep, bool_t *varblk)
 {
 	drive_context_t *contextp;
 
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 	if (TS_ISDRIVER) {
 		char value[MT_ATTR_MAX_VALLEN+1];
@@ -3826,7 +3826,7 @@ is_variable( drive_t *drivep, bool_t *varblk )
 		struct mtblkinfo minfo;
 
 		ok = mt_blkinfo(contextp->dc_fd, &minfo);
-		if (!ok )
+		if (!ok)
 			return BOOL_FALSE; /* failure */
 
 		/* for Linux scsi driver the blksize == 0 if variable */
@@ -3846,7 +3846,7 @@ is_variable( drive_t *drivep, bool_t *varblk )
  * xfsdumps on media.
  */
 static int
-prepare_drive( drive_t *drivep )
+prepare_drive(drive_t *drivep)
 {
 	drive_context_t	*contextp;
 	mtstat_t mtstat;
@@ -3859,44 +3859,44 @@ prepare_drive( drive_t *drivep )
 
 	/* get pointer to drive context
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 retry:
-	if ( cldmgr_stop_requested( )) {
+	if (cldmgr_stop_requested()) {
 		return DRIVE_ERROR_STOP;
 	}
 
 	/* shouldn't be here if drive is open
 	 */
-	assert( contextp->dc_fd == -1 );
+	assert(contextp->dc_fd == -1);
 
-	mlog( MLOG_VERBOSE | MLOG_DRIVE,
-	      _("preparing drive\n") );
+	mlog(MLOG_VERBOSE | MLOG_DRIVE,
+	      _("preparing drive\n"));
 
 
 	/* determine if tape is present or write protected. try several times.
 	 * if not present or write-protected during dump, return.
 	 */
 	maxtries = 15;
-	for ( try = 1 ; ; sleep( 10 ), try++ ) {
-		if ( cldmgr_stop_requested( )) {
+	for (try = 1 ; ; sleep(10), try++) {
+		if (cldmgr_stop_requested()) {
 			return DRIVE_ERROR_STOP;
 		}
 
 		/* open the drive
 	 	 */
-		ok = Open( drivep );
-		if ( ! ok ) {
-			if ( errno != EBUSY ) {
-				display_access_failed_message( drivep );
+		ok = Open(drivep);
+		if (! ok) {
+			if (errno != EBUSY) {
+				display_access_failed_message(drivep);
 				return DRIVE_ERROR_DEVICE;
 			} else {
-				mlog( MLOG_DEBUG | MLOG_DRIVE,
-				      "open drive returns EBUSY\n" );
-				if ( try >= maxtries ) {
-					mlog( MLOG_TRACE | MLOG_DRIVE,
+				mlog(MLOG_DEBUG | MLOG_DRIVE,
+				      "open drive returns EBUSY\n");
+				if (try >= maxtries) {
+					mlog(MLOG_TRACE | MLOG_DRIVE,
 					      "giving up waiting for drive "
-					      "to indicate online\n" );
+					      "to indicate online\n");
 					return DRIVE_ERROR_MEDIA;
 				}
 				continue;
@@ -3906,9 +3906,9 @@ retry:
 		/* read device status (uses an ioctl)
 		 */
 		mtstat = 0;
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
+			status_failed_message(drivep);
 			return DRIVE_ERROR_DEVICE;
 		}
 
@@ -3916,18 +3916,18 @@ retry:
 		 * also check if write-protected (DUMP only), and give up
 		 * after a few tries.
 		 */
-		if ( IS_ONL( mtstat )) {
+		if (IS_ONL(mtstat)) {
 #ifdef DUMP
-			if ( IS_WPROT( mtstat )) {
+			if (IS_WPROT(mtstat)) {
 				mlog(MLOG_NORMAL,
-				     _("tape is write protected\n") );
+				     _("tape is write protected\n"));
 				return DRIVE_ERROR_MEDIA;
 			}
 #endif /* DUMP */
 			/* populate a struct stat. NOTE: this may do a temporary open/close
 			 * NOTE: may do this only on local drives: rmt does not support!
 			 */
-			if ( contextp->dc_isrmtpr ) {
+			if (contextp->dc_isrmtpr) {
 				contextp->dc_isvarpr = BOOL_FALSE;
 			} else {
 				/* check for special device dev_t for fixed or variable type
@@ -3939,66 +3939,66 @@ retry:
 
 				if (varblk) {
 					contextp->dc_isvarpr = BOOL_TRUE;
-					mlog( MLOG_TRACE | MLOG_DRIVE,
+					mlog(MLOG_TRACE | MLOG_DRIVE,
 					      "variable block size "
 					      "tape drive at %s\n",
-					      drivep->d_pathname );
+					      drivep->d_pathname);
 				} else {
 					contextp->dc_isvarpr = BOOL_FALSE;
-					mlog( MLOG_TRACE | MLOG_DRIVE,
+					mlog(MLOG_TRACE | MLOG_DRIVE,
 					      "fixed block size tape "
 					      "drive at %s\n",
-					      drivep->d_pathname );
+					      drivep->d_pathname);
 				}
 			}
 
 			break;
-		} else if ( try >= maxtries ) {
-			mlog( MLOG_VERBOSE | MLOG_DRIVE,
+		} else if (try >= maxtries) {
+			mlog(MLOG_VERBOSE | MLOG_DRIVE,
 			      _("giving up waiting for drive "
-			      "to indicate online\n") );
+			      "to indicate online\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
 
 		/* drive is not ready. sleep for a while and try again
 		 */
-		mlog( MLOG_VERBOSE | MLOG_DRIVE,
+		mlog(MLOG_VERBOSE | MLOG_DRIVE,
 		      _("tape drive %s is not ready (0x%x): "
 		      "retrying ...\n"),
 		      drivep->d_pathname,
-		      mtstat );
+		      mtstat);
 
-		Close( drivep );
+		Close(drivep);
 	}
-	assert( IS_ONL( mtstat ));
+	assert(IS_ONL(mtstat));
 
 	/* determine tape capabilities. this will set the drivep->d_capabilities
 	 * and contextp->dc_{...}blksz and dc_isQICpr, as well as recommended
 	 * mark separation and media file size.
 	 */
-	ok = get_tpcaps( drivep );
-	if ( ! ok ) {
+	ok = get_tpcaps(drivep);
+	if (! ok) {
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* disallow access of QIC via variable
 	 */
-	if ( contextp->dc_isvarpr && contextp->dc_isQICpr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
+	if (contextp->dc_isvarpr && contextp->dc_isQICpr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
 		      "use of QIC drives via variable blocksize device nodes "
-		      "is not supported\n") );
+		      "is not supported\n"));
 		return DRIVE_ERROR_INVAL;
 	}
 
 	/* if the overwrite option was specified , set the best blocksize
 	 * we can and return.
 	 */
-	if ( contextp->dc_overwritepr ) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (contextp->dc_overwritepr) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 			"Overwrite option specified. "
-			"Trying best blocksize\n" );
-		ok = set_best_blk_and_rec_sz( drivep );
-		if ( ! ok ) {
+			"Trying best blocksize\n");
+		ok = set_best_blk_and_rec_sz(drivep);
+		if (! ok) {
 			return DRIVE_ERROR_DEVICE;
 		}
 		return DRIVE_ERROR_OVERWRITE;
@@ -4017,16 +4017,16 @@ retry:
 	 * we will use tape motion. back up two file marks, because
 	 * typically we will be positioned after last file mark at EOD.
 	 */
-	if ( ! IS_BOT( mtstat ) && IS_FMK( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (! IS_BOT(mtstat) && IS_FMK(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "tape positioned at file mark, "
 		      "but do not know if before or after: "
-		      "forcing tape motion to disambiguate\n" );
+		      "forcing tape motion to disambiguate\n");
 #ifdef RESTORE
-		( void )fsf_and_verify( drivep );
+		(void)fsf_and_verify(drivep);
 #endif /* RESTORE */
-		rval = quick_backup( drivep, contextp, 0 );
-		if ( rval ) {
+		rval = quick_backup(drivep, contextp, 0);
+		if (rval) {
 			return rval;
 		}
 	}
@@ -4051,39 +4051,39 @@ retry:
  	 */
 	maxtries = 5;
 	changedblkszpr = BOOL_FALSE;
-	for ( try = 1 ; ; try++ ) {
+	for (try = 1 ; ; try++) {
 		bool_t wasatbotpr;
 		int nread;
 		int saved_errno;
 
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return DRIVE_ERROR_STOP;
 		}
 
 		/* bail out if we've tried too many times
 		 */
-		if ( try > maxtries ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
+		if (try > maxtries) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
 			      "giving up attempt to determining "
-			      "tape record size\n") );
+			      "tape record size\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
 
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "determining tape record size: trying %d (0x%x) bytes\n",
 		      tape_recsz,
-		      tape_recsz );
+		      tape_recsz);
 
 		/* if a fixed device, but not QIC, and possible to set the block
 		 * size, do so.
 		 */
-		if ( ! contextp->dc_isvarpr
+		if (! contextp->dc_isvarpr
 		     &&
 		     ! contextp->dc_isQICpr
 		     &&
-		     contextp->dc_cansetblkszpr ) {
-			ok = set_fixed_blksz( drivep, tape_blksz );
-			if ( ! ok ) {
+		     contextp->dc_cansetblkszpr) {
+			ok = set_fixed_blksz(drivep, tape_blksz);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 		}
@@ -4091,9 +4091,9 @@ retry:
 		/* refresh the tape status
 		 */
 		mtstat = 0;
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
+			status_failed_message(drivep);
 			return DRIVE_ERROR_DEVICE;
 		}
 
@@ -4103,102 +4103,102 @@ retry:
 		 * so we must either bsf or rewind to eliminate the uncertainty.
 		 * if BSF is not supported, must rewind.
 		 */
-		if ( ! IS_BOT( mtstat ) && ! IS_FMK( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "tape position unknown: searching backward "
-			      "for file mark or BOT\n" );
-			rval = quick_backup( drivep, contextp, 0 );
-			if ( rval ) {
+			      "for file mark or BOT\n");
+			rval = quick_backup(drivep, contextp, 0);
+			if (rval) {
 				return rval;
 			}
 			mtstat = 0;
-			ok = mt_get_status( drivep, &mtstat );
-			if ( ! ok ) {
-				status_failed_message( drivep );
+			ok = mt_get_status(drivep, &mtstat);
+			if (! ok) {
+				status_failed_message(drivep);
 				return DRIVE_ERROR_DEVICE;
 			}
 		}
 
 		/* if we can't position the tape, call it a media error
 		 */
-		if ( ! IS_BOT( mtstat ) && ! IS_FMK( mtstat )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
-			      _("unable to backspace/rewind media\n") );
+		if (! IS_BOT(mtstat) && ! IS_FMK(mtstat)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			      _("unable to backspace/rewind media\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
-		if ( IS_BOT( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (IS_BOT(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "tape positioned at BOT: "
-			      "doing redundant rewind\n" );
-			mtstat = rewind_and_verify( drivep );
-			if ( ! IS_BOT( mtstat )) {
+			      "doing redundant rewind\n");
+			mtstat = rewind_and_verify(drivep);
+			if (! IS_BOT(mtstat)) {
 				return DRIVE_ERROR_DEVICE;
 			}
 		}
-		if ( IS_FMK( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
-			      "tape positioned at file mark\n" );
+		if (IS_FMK(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
+			      "tape positioned at file mark\n");
 		}
 
 		/* determine if we are at BOT. remember, so if read fails
 		 * we can make a better decision on what to do next.
 		 */
-		if ( IS_BOT( mtstat )) {
+		if (IS_BOT(mtstat)) {
 			wasatbotpr = BOOL_TRUE;
-		} else if ( IS_FMK( mtstat )) {
+		} else if (IS_FMK(mtstat)) {
 			wasatbotpr = BOOL_FALSE;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
-			      _("unable to backspace/rewind media\n") );
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			      _("unable to backspace/rewind media\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
 
 		/* read a record. use the first ring buffer
 		 */
 		saved_errno = 0;
-		nread = Read( drivep,
+		nread = Read(drivep,
 			      contextp->dc_recp,
 			      tape_recsz,
-			      &saved_errno );
-		assert( saved_errno == 0 || nread < 0 );
+			      &saved_errno);
+		assert(saved_errno == 0 || nread < 0);
 
 		/* RMT can require a retry
 		 */
-		if ( saved_errno == EAGAIN ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
-			      "read returned EAGAIN: retrying\n" );
+		if (saved_errno == EAGAIN) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
+			      "read returned EAGAIN: retrying\n");
 			continue;
 		}
 
 		/* block size is bigger than buffer; should never happen
 		 */
-		if ( saved_errno == EINVAL ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (saved_errno == EINVAL) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "read returned EINVAL: "
-			      "trying new record size\n" );
+			      "trying new record size\n");
 			goto largersize;
 		}
 
 		/* block size is bigger than buffer; should never happen
 		 */
-		if ( saved_errno == ENOMEM ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (saved_errno == ENOMEM) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "read returned ENOMEM: "
-			      "trying new record size\n" );
+			      "trying new record size\n");
 			goto largersize;
 		}
 
 		/* tried to read past EOD and was at BOT
 		 */
-		if ( saved_errno == ENOSPC
+		if (saved_errno == ENOSPC
 		     &&
-		     wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "errno ENOSPC while at BOT "
-			      "indicates blank tape: returning\n" );
-			( void )rewind_and_verify( drivep );
-			ok = set_best_blk_and_rec_sz( drivep );
-			if ( ! ok ) {
+			      "indicates blank tape: returning\n");
+			(void)rewind_and_verify(drivep);
+			ok = set_best_blk_and_rec_sz(drivep);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 			return DRIVE_ERROR_BLANK;
@@ -4208,15 +4208,15 @@ retry:
 		 * On Linux, using the scsi tape driver this
 		 * seems to happen with an erased/blank tape
 		 */
-		if ( saved_errno == EIO
+		if (saved_errno == EIO
 		     &&
-		     wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "errno EIO while at BOT "
-			      "indicates blank tape: returning\n" );
-			( void )rewind_and_verify( drivep );
-			ok = set_best_blk_and_rec_sz( drivep );
-			if ( ! ok ) {
+			      "indicates blank tape: returning\n");
+			(void)rewind_and_verify(drivep);
+			ok = set_best_blk_and_rec_sz(drivep);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 			return DRIVE_ERROR_BLANK;
@@ -4224,14 +4224,14 @@ retry:
 
 		/* tried to read past EOD and NOT at BOT
 		 */
-		if ( saved_errno == ENOSPC
+		if (saved_errno == ENOSPC
 		     &&
-		     ! wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "errno ENOSPC while not at BOT "
-			      "indicates EOD: retrying\n" );
-			rval = quick_backup( drivep, contextp, 1 );
-			if ( rval ) {
+			      "indicates EOD: retrying\n");
+			rval = quick_backup(drivep, contextp, 1);
+			if (rval) {
 				return rval;
 			}
 			continue;
@@ -4239,17 +4239,17 @@ retry:
 
 		/* I/O error
 		 */
-		if ( saved_errno == EIO ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (saved_errno == EIO) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "read returned EIO: will reopen, rewind, "
-			      "and try again\n" );
-			Close( drivep );
-			ok = Open( drivep );
-			if ( ! ok ) {
-				display_access_failed_message( drivep );
+			      "and try again\n");
+			Close(drivep);
+			ok = Open(drivep);
+			if (! ok) {
+				display_access_failed_message(drivep);
 				return DRIVE_ERROR_DEVICE;
 			}
-			( void )rewind_and_verify( drivep );
+			(void)rewind_and_verify(drivep);
 			continue;
 		}
 
@@ -4257,197 +4257,197 @@ retry:
 		 * done below.
 		 */
 		mtstat = 0;
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
+			status_failed_message(drivep);
 			return DRIVE_ERROR_DEVICE;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     ! contextp->dc_isvarpr
 		     &&
-		     IS_EOD( mtstat )
+		     IS_EOD(mtstat)
 		     &&
-		     wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and EOD while at BOT on "
 			  "fixed blocksize drive "
-			  "indicates blank tape: returning\n" );
-			( void )rewind_and_verify( drivep );
-			ok = set_best_blk_and_rec_sz( drivep );
-			if ( ! ok ) {
+			  "indicates blank tape: returning\n");
+			(void)rewind_and_verify(drivep);
+			ok = set_best_blk_and_rec_sz(drivep);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 			return DRIVE_ERROR_BLANK;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     ! contextp->dc_isvarpr
 		     &&
-		     IS_EOD( mtstat )
+		     IS_EOD(mtstat)
 		     &&
-		     ! wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and EOD while not at BOT on "
 			  "fixed blocksize drive "
-			  "indicates EOD: backing up and retrying\n" );
-			rval = quick_backup( drivep, contextp, 1 );
-			if ( rval ) {
+			  "indicates EOD: backing up and retrying\n");
+			rval = quick_backup(drivep, contextp, 1);
+			if (rval) {
 				return rval;
 			}
 			continue;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     ! contextp->dc_isvarpr
 		     &&
-		     IS_EOT( mtstat )
+		     IS_EOT(mtstat)
 		     &&
-		     ! wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and EOT while not at BOT on "
 			  "fixed blocksize drive "
-			  "indicates EOD: backing up and retrying\n" );
-			rval = quick_backup( drivep, contextp, 1 );
-			if ( rval ) {
+			  "indicates EOD: backing up and retrying\n");
+			rval = quick_backup(drivep, contextp, 1);
+			if (rval) {
 				return rval;
 			}
 			continue;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     ! contextp->dc_isvarpr
 		     &&
-		     ! IS_EOD( mtstat )
+		     ! IS_EOD(mtstat)
 		     &&
-		     ! IS_FMK( mtstat )
+		     ! IS_FMK(mtstat)
 		     &&
-		     ! IS_EOT( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! IS_EOT(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and not EOD, not EOT, "
 			  "and not at a file mark on fixed blocksize drive "
-			  "indicates wrong blocksize\n" );
+			  "indicates wrong blocksize\n");
 			goto newsize;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     contextp->dc_isvarpr
 		     &&
-		     IS_EOD( mtstat )
+		     IS_EOD(mtstat)
 		     &&
-		     wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "nread == 0 and EOD indication at BOT "
 			      "on variable tape "
-			      "indicates blank tape: returning\n" );
-			( void )rewind_and_verify( drivep );
-			ok = set_best_blk_and_rec_sz( drivep );
-			if ( ! ok ) {
+			      "indicates blank tape: returning\n");
+			(void)rewind_and_verify(drivep);
+			ok = set_best_blk_and_rec_sz(drivep);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 			return DRIVE_ERROR_BLANK;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     contextp->dc_isvarpr
 		     &&
-		     IS_EOD( mtstat )
+		     IS_EOD(mtstat)
 		     &&
-		     ! wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and EOD while not at BOT on "
 			  "variable blocksize drive "
-			  "indicates EOD: backing up and retrying\n" );
-			rval = quick_backup( drivep, contextp, 1 );
-			if ( rval ) {
+			  "indicates EOD: backing up and retrying\n");
+			rval = quick_backup(drivep, contextp, 1);
+			if (rval) {
 				return rval;
 			}
 			continue;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     contextp->dc_isvarpr
 		     &&
-		     IS_EOT( mtstat )
+		     IS_EOT(mtstat)
 		     &&
-		     ! wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == 0 and EOT while not at BOT on "
 			  "variable blocksize drive "
-			  "indicates EOT: backing up and retrying\n" );
-			rval = quick_backup( drivep, contextp, 1 );
-			if ( rval ) {
+			  "indicates EOT: backing up and retrying\n");
+			rval = quick_backup(drivep, contextp, 1);
+			if (rval) {
 				return rval;
 			}
 			continue;
 		}
 
-		if ( nread == 0
+		if (nread == 0
 		     &&
 		     contextp->dc_isvarpr
 		     &&
-		     IS_FMK( mtstat )
+		     IS_FMK(mtstat)
 		     &&
-		     wasatbotpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     wasatbotpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "nread == 0 at BOT and at a file mark "
 			      "on variable blocksize drive "
-			      "indicates foreign tape: returning\n" );
-			( void )rewind_and_verify( drivep );
-			ok = set_best_blk_and_rec_sz( drivep );
-			if ( ! ok ) {
+			      "indicates foreign tape: returning\n");
+			(void)rewind_and_verify(drivep);
+			ok = set_best_blk_and_rec_sz(drivep);
+			if (! ok) {
 				return DRIVE_ERROR_DEVICE;
 			}
 			return DRIVE_ERROR_FOREIGN;
 		}
 
-		if ( nread > 0
+		if (nread > 0
 		     &&
 		     contextp->dc_isvarpr
 		     &&
-		     ! IS_EOD( mtstat )
+		     ! IS_EOD(mtstat)
 		     &&
-		     ! IS_FMK( mtstat )
+		     ! IS_FMK(mtstat)
 		     &&
-		     ! IS_EOT( mtstat )) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! IS_EOT(mtstat)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread > 0 and not EOD, not EOT, "
 			  "and not at a file mark on variable blocksize drive "
-			  "indicates correct blocksize found\n" );
+			  "indicates correct blocksize found\n");
 			goto checkhdr;
 		}
 
-		if ( nread < ( int )tape_recsz
+		if (nread < (int)tape_recsz
 		     &&
-		     ! contextp->dc_isvarpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! contextp->dc_isvarpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread less than selected record size on "
 			  "fixed blocksize drive "
-			  "indicates wrong blocksize\n" );
+			  "indicates wrong blocksize\n");
 			goto newsize;
 		}
 
-		if ( nread == ( int )tape_recsz
+		if (nread == (int)tape_recsz
 		     &&
-		     ! contextp->dc_isvarpr ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		     ! contextp->dc_isvarpr) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == selected blocksize "
 			  "on fixed blocksize drive "
-			  "indicates correct blocksize found\n" );
+			  "indicates correct blocksize found\n");
 			goto checkhdr;
 		}
 
 		/* if we fell through the seive, code is wrong.
 		 * display useful info and abort
 		 */
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
 		      "unexpected tape error: "
 		      "errno %d "
 		      "nread %d "
@@ -4468,21 +4468,21 @@ retry:
 		      tape_recsz,
 		      !! contextp->dc_isvarpr,
 		      wasatbotpr,
-		      IS_EOD( mtstat ) > 0,
-		      IS_FMK( mtstat ) > 0,
-		      IS_EOT( mtstat ) > 0,
-		      IS_ONL( mtstat ) > 0,
-		      IS_WPROT( mtstat ) > 0,
-		      IS_EW( mtstat ) > 0,
-		      0 );
+		      IS_EOD(mtstat) > 0,
+		      IS_FMK(mtstat) > 0,
+		      IS_EOT(mtstat) > 0,
+		      IS_ONL(mtstat) > 0,
+		      IS_WPROT(mtstat) > 0,
+		      IS_EW(mtstat) > 0,
+		      0);
 
 		/* Common Linux Problem */
 		if (errno == EOVERFLOW) {
-		    mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_DRIVE,
+		    mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_DRIVE,
 			_("likely problem is that the block size, %d, "
 			"is too large for Linux\n"),
 			tape_blksz);
-		    mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_DRIVE,
+		    mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_DRIVE,
 			_("either try using a smaller block size with "
 			"the -b option, or increase max_sg_segs for "
 			"the scsi tape driver\n"));
@@ -4493,44 +4493,44 @@ retry:
 
 
 checkhdr:
-		rval = validate_media_file_hdr( drivep );
-		if ( rval ) {
-			if ( rval == DRIVE_ERROR_VERSION ) {
+		rval = validate_media_file_hdr(drivep);
+		if (rval) {
+			if (rval == DRIVE_ERROR_VERSION) {
 				global_hdr_t *grhdrp = drivep->d_greadhdrp;
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
 				      _("media file header version (%d) "
 				      "invalid: advancing\n"),
-				      grhdrp->gh_version );
+				      grhdrp->gh_version);
 				continue;
-			} else if ( wasatbotpr ) {
-				if ( isefsdump( drivep )) {
-					mlog( MLOG_NORMAL
+			} else if (wasatbotpr) {
+				if (isefsdump(drivep)) {
+					mlog(MLOG_NORMAL
 					      |
 					      MLOG_WARNING
 					      |
 					      MLOG_DRIVE,
 					      _("may be an EFS dump at BOT\n"));
 				} else {
-					mlog( MLOG_NORMAL | MLOG_DRIVE,
+					mlog(MLOG_NORMAL | MLOG_DRIVE,
 					      _("bad media file header at BOT "
 					      "indicates foreign or "
 					      "corrupted tape\n"));
 				}
-				( void )rewind_and_verify( drivep );
-				ok = set_best_blk_and_rec_sz( drivep );
-				if ( ! ok ) {
+				(void)rewind_and_verify(drivep);
+				ok = set_best_blk_and_rec_sz(drivep);
+				if (! ok) {
 					return DRIVE_ERROR_DEVICE;
 				}
 				return DRIVE_ERROR_FOREIGN;
 			} else {
 				/* back up and try again.
 				 */
-				mlog( MLOG_DEBUG | MLOG_DRIVE,
+				mlog(MLOG_DEBUG | MLOG_DRIVE,
 				      "media file header invalid: "
 				      "backing up "
-				      "to try a previous media file\n" );
-				rval = quick_backup( drivep, contextp, 1 );
-				if ( rval ) {
+				      "to try a previous media file\n");
+				rval = quick_backup(drivep, contextp, 1);
+				if (rval) {
 					return rval;
 				}
 				continue;
@@ -4539,10 +4539,10 @@ checkhdr:
 			drive_hdr_t *drhdrp;
 			rec_hdr_t *tprhdrp;
 			drhdrp = drivep->d_readhdrp;
-			tprhdrp = ( rec_hdr_t * )drhdrp->dh_specific;
-			assert( tprhdrp->recsize >= 0 );
-			tape_recsz = ( size_t )tprhdrp->recsize;
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+			tprhdrp = (rec_hdr_t *)drhdrp->dh_specific;
+			assert(tprhdrp->recsize >= 0);
+			tape_recsz = (size_t)tprhdrp->recsize;
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "tape record size set to header's "
 			      "record size = %d\n", tape_recsz);
 			break;
@@ -4552,37 +4552,37 @@ newsize:
 		/* we end up here if we want to try a new record size.
 		 * only do this once.
 		 */
-		if ( changedblkszpr ) {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
+		if (changedblkszpr) {
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
 			      _("cannot determine tape block size "
-			      "after two tries\n") );
-			if ( ! wasatbotpr ) {
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
-				      _("will rewind and try again\n") );
-				( void )rewind_and_verify( drivep );
-				Close( drivep );
+			      "after two tries\n"));
+			if (! wasatbotpr) {
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
+				      _("will rewind and try again\n"));
+				(void)rewind_and_verify(drivep);
+				Close(drivep);
 				goto retry;
 			} else {
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
 				      _("assuming media is corrupt "
-				      "or contains non-xfsdump data\n") );
-				( void )rewind_and_verify( drivep );
-				ok = set_best_blk_and_rec_sz( drivep );
-				if ( ! ok ) {
+				      "or contains non-xfsdump data\n"));
+				(void)rewind_and_verify(drivep);
+				ok = set_best_blk_and_rec_sz(drivep);
+				if (! ok) {
 					return DRIVE_ERROR_DEVICE;
 				}
 				return DRIVE_ERROR_FOREIGN;
 			}
 		}
-		if ( tape_recsz > STAPE_MIN_MAX_BLKSZ ) {
+		if (tape_recsz > STAPE_MIN_MAX_BLKSZ) {
 			tape_recsz = STAPE_MIN_MAX_BLKSZ;
-			if ( ! contextp->dc_isQICpr ) {
+			if (! contextp->dc_isQICpr) {
 				tape_blksz = tape_recsz;;
 			}
 			changedblkszpr = BOOL_TRUE;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
-			      _("cannot determine tape block size\n") );
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
+			      _("cannot determine tape block size\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
 		continue;
@@ -4591,23 +4591,23 @@ largersize:
 		/* we end up here if we want to try a new larger record size
 		 * because the last one was not big enough for the tape block
 		 */
-		if ( changedblkszpr ) {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
+		if (changedblkszpr) {
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
 			      _("cannot determine tape block size "
-			      "after two tries\n") );
-			if ( ! wasatbotpr ) {
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
-				      _("will rewind and try again\n") );
-				( void )rewind_and_verify( drivep );
-				Close( drivep );
+			      "after two tries\n"));
+			if (! wasatbotpr) {
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
+				      _("will rewind and try again\n"));
+				(void)rewind_and_verify(drivep);
+				Close(drivep);
 				goto retry;
 			} else {
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
 				      _("assuming media is corrupt "
-				      "or contains non-xfsdump data\n") );
-				( void )rewind_and_verify( drivep );
-				ok = set_best_blk_and_rec_sz( drivep );
-				if ( ! ok ) {
+				      "or contains non-xfsdump data\n"));
+				(void)rewind_and_verify(drivep);
+				ok = set_best_blk_and_rec_sz(drivep);
+				if (! ok) {
 					return DRIVE_ERROR_DEVICE;
 				}
 				return DRIVE_ERROR_FOREIGN;
@@ -4615,29 +4615,29 @@ largersize:
 		}
                 /* Make it as large as we can go
                  */
-		if ( tape_recsz != STAPE_MAX_RECSZ ) {
+		if (tape_recsz != STAPE_MAX_RECSZ) {
 			tape_recsz = STAPE_MAX_RECSZ;
-			if ( ! contextp->dc_isQICpr ) {
+			if (! contextp->dc_isQICpr) {
 				tape_blksz = tape_recsz;;
 			}
 			changedblkszpr = BOOL_TRUE;
 		} else {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
-			      _("cannot determine tape block size\n") );
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
+			      _("cannot determine tape block size\n"));
 			return DRIVE_ERROR_MEDIA;
 		}
 		continue;
 
 	} /* loop reading 1st record 'til get correct blksz */
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "read first record of first media file encountered on media: "
 	      "recsz == %u\n",
-	      tape_recsz );
+	      tape_recsz);
 
 	/* calculate maximum bytes lost without error at end of tape
 	 */
-	calc_max_lost( drivep );
+	calc_max_lost(drivep);
 
 	contextp->dc_iocnt = 1;
 	return 0;
@@ -4646,9 +4646,9 @@ largersize:
 /* if BOOL_FALSE returned, errno is valid
  */
 static bool_t
-Open( drive_t *drivep )
+Open(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int oflags;
 
 #ifdef DUMP
@@ -4658,15 +4658,15 @@ Open( drive_t *drivep )
 	oflags = O_RDONLY;
 #endif /* RESTORE */
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "tape op: opening drive\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "tape op: opening drive\n");
 
-	assert( contextp->dc_fd == -1 );
+	assert(contextp->dc_fd == -1);
 
 	errno = 0;
-	contextp->dc_fd = open( drivep->d_pathname, oflags );
+	contextp->dc_fd = open(drivep->d_pathname, oflags);
 
-	if ( contextp->dc_fd <= 0 ) {
+	if (contextp->dc_fd <= 0) {
 		return BOOL_FALSE;
 	}
 
@@ -4675,87 +4675,87 @@ Open( drive_t *drivep )
 }
 
 static void
-Close( drive_t *drivep )
+Close(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "tape op: closing drive\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "tape op: closing drive\n");
 
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_fd >= 0);
 
-	( void )close( contextp->dc_fd );
+	(void)close(contextp->dc_fd);
 
 	contextp->dc_fd = -1;
 }
 
 static int
-Read( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
+Read(drive_t *drivep, char *bufp, size_t cnt, int *errnop)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int nread;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: reading %u bytes\n",
-	      cnt );
+	      cnt);
 
-	assert( contextp->dc_fd >= 0 );
-	assert( bufp );
+	assert(contextp->dc_fd >= 0);
+	assert(bufp);
 	*errnop = 0;
 	errno = 0;
-	nread = read( contextp->dc_fd, ( void * )bufp, cnt );
-	if ( nread < 0 ) {
+	nread = read(contextp->dc_fd, (void *)bufp, cnt);
+	if (nread < 0) {
 		*errnop = errno;
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op read of %u bytes failed: errno == %d (%s)\n",
 		      cnt,
 		      errno,
-		      strerror( errno ));
-	} else if ( nread != ( int )cnt ) {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		      strerror(errno));
+	} else if (nread != (int)cnt) {
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op read of %u bytes short: nread == %d\n",
 		      cnt,
-		      nread );
+		      nread);
 	} else {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op read of %u bytes successful\n",
-		      cnt );
+		      cnt);
 	}
 
 	return nread;
 }
 
 static int
-Write( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
+Write(drive_t *drivep, char *bufp, size_t cnt, int *errnop)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int nwritten;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "tape op: writing %u bytes\n",
-	      cnt );
+	      cnt);
 
-	assert( contextp->dc_fd >= 0 );
-	assert( bufp );
+	assert(contextp->dc_fd >= 0);
+	assert(bufp);
 	*errnop = 0;
 	errno = 0;
-	nwritten = write( contextp->dc_fd, ( void * )bufp, cnt );
-	if ( nwritten < 0 ) {
+	nwritten = write(contextp->dc_fd, (void *)bufp, cnt);
+	if (nwritten < 0) {
 		*errnop = errno;
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op write of %u bytes failed: errno == %d (%s)\n",
 		      cnt,
 		      errno,
-		      strerror( errno ));
-	} else if ( nwritten != ( int )cnt ) {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		      strerror(errno));
+	} else if (nwritten != (int)cnt) {
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op write of %u bytes short: nwritten == %d\n",
 		      cnt,
-		      nwritten );
+		      nwritten);
 	} else {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "tape op write of %u bytes successful\n",
-		      cnt );
+		      cnt);
 	}
 
 	return nwritten;
@@ -4767,27 +4767,27 @@ Write( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
  */
 /* ARGSUSED */
 static int
-quick_backup( drive_t *drivep, drive_context_t *contextp, ix_t skipcnt )
+quick_backup(drive_t *drivep, drive_context_t *contextp, ix_t skipcnt)
 {
-	if ( drivep->d_capabilities & DRIVE_CAP_BSF ) {
+	if (drivep->d_capabilities & DRIVE_CAP_BSF) {
 		do {
 			mtstat_t mtstat;
-			mtstat = bsf_and_verify( drivep );
-			if ( IS_BOT( mtstat )) {
+			mtstat = bsf_and_verify(drivep);
+			if (IS_BOT(mtstat)) {
 				return 0;
 			}
-			if ( TS_ISDRIVER ) {
-				if ( ! IS_FMK( mtstat )) {
-					mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			if (TS_ISDRIVER) {
+				if (! IS_FMK(mtstat)) {
+					mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					      _("unable to backspace tape: "
-					      "assuming media error\n") );
+					      "assuming media error\n"));
 					return DRIVE_ERROR_MEDIA;
 				}
 			}
-		} while ( skipcnt-- );
-		( void )fsf_and_verify( drivep );
+		} while (skipcnt--);
+		(void)fsf_and_verify(drivep);
 	} else {
-		( void )rewind_and_verify( drivep );
+		(void)rewind_and_verify(drivep);
 	}
 
 	return 0;
@@ -4797,82 +4797,82 @@ quick_backup( drive_t *drivep, drive_context_t *contextp, ix_t skipcnt )
  * indication.
  */
 static int
-record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
+record_hdr_validate(drive_t *drivep, char *bufp, bool_t chkoffpr)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	rec_hdr_t rechdr;
 	rec_hdr_t *rechdrp = &rechdr;
-	rec_hdr_t *tmprh = ( rec_hdr_t * )bufp;
+	rec_hdr_t *tmprh = (rec_hdr_t *)bufp;
 
-	if ( ! tape_rec_checksum_check( contextp, bufp )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (! tape_rec_checksum_check(contextp, bufp)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: bad record checksum\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 
 	}
 
 	xlate_rec_hdr(tmprh, rechdrp, 1);
 
-	if ( rechdrp->magic != STAPE_MAGIC )  {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (rechdrp->magic != STAPE_MAGIC)  {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: bad magic number\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( uuid_is_null( rechdrp->dump_uuid )) {
+	if (uuid_is_null(rechdrp->dump_uuid)) {
 
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: null dump id\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( uuid_compare( grhdrp->gh_dumpid,
-			   rechdrp->dump_uuid ) != 0) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (uuid_compare(grhdrp->gh_dumpid,
+			   rechdrp->dump_uuid) != 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: dump id mismatch\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( ( size_t )rechdrp->recsize != tape_recsz ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
+	if ((size_t)rechdrp->recsize != tape_recsz) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
 		      "record %lld corrupt: incorrect record size in header\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( rechdrp->file_offset % ( off64_t )tape_recsz ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (rechdrp->file_offset % (off64_t)tape_recsz) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: record offset in header "
 		      "not a multiple of record size\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( chkoffpr
+	if (chkoffpr
 	     &&
 	     rechdrp->file_offset
 	     !=
-	     ( contextp->dc_iocnt - 1 ) * ( off64_t )tape_recsz ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	     (contextp->dc_iocnt - 1) * (off64_t)tape_recsz) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: "
 		      "incorrect record offset in header (0x%llx)\n"),
 		      contextp->dc_iocnt - 1,
-		      rechdrp->file_offset );
+		      rechdrp->file_offset);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
-	if ( rechdrp->rec_used > tape_recsz
+	if (rechdrp->rec_used > tape_recsz
 	     ||
-	     rechdrp->rec_used < STAPE_HDR_SZ ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	     rechdrp->rec_used < STAPE_HDR_SZ) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("record %lld corrupt: "
 		      "incorrect record padding offset in header\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
@@ -4885,116 +4885,116 @@ record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
  * return 0 on success.
  */
 static int
-read_record(  drive_t *drivep, char *bufp )
+read_record(drive_t *drivep, char *bufp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int nread;
 	int saved_errno;
 	mtstat_t mtstat;
 	int rval;
 	bool_t ok;
 
-	nread = Read( drivep, bufp, tape_recsz, &saved_errno );
-	if ( nread == ( int )tape_recsz ) {
+	nread = Read(drivep, bufp, tape_recsz, &saved_errno);
+	if (nread == (int)tape_recsz) {
 		contextp->dc_iocnt++;
-		rval = record_hdr_validate( drivep, bufp, BOOL_TRUE );
+		rval = record_hdr_validate(drivep, bufp, BOOL_TRUE);
 		return rval;
 	}
 
 	/* get drive status
 	 */
-	ok = mt_get_status( drivep, &mtstat );
-	if ( ! ok ) {
-		status_failed_message( drivep );
+	ok = mt_get_status(drivep, &mtstat);
+	if (! ok) {
+		status_failed_message(drivep);
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* encountered a file mark
 	 */
-	if ( IS_FMK( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (IS_FMK(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "encountered EOF attempting to read record %lld\n",
-		      contextp->dc_iocnt );
+		      contextp->dc_iocnt);
 		return DRIVE_ERROR_EOF;
 	}
 
 	/* encountered a end of recorded data
 	 */
-	if ( IS_EOD( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (IS_EOD(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "encountered EOD attempting to read record %lld\n",
-		      contextp->dc_iocnt );
+		      contextp->dc_iocnt);
 		return DRIVE_ERROR_EOD;
 	}
 
 	/* encountered a end of media
 	 */
-	if ( IS_EOT( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (IS_EOT(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "encountered EOM attempting to read record %lld\n",
-		      contextp->dc_iocnt );
+		      contextp->dc_iocnt);
 		return DRIVE_ERROR_EOM;
 	}
 
 	/* encountered a end of media (early warning indicated)
 	 */
-	if ( IS_EW( mtstat )) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (IS_EW(mtstat)) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "encountered EW attempting to read record %lld\n",
-		      contextp->dc_iocnt );
+		      contextp->dc_iocnt);
 		return DRIVE_ERROR_EOM;
 	}
 
 	/* short read
 	 */
-	if ( nread >= 0 ) {
-		assert( nread <= ( int )tape_recsz );
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+	if (nread >= 0) {
+		assert(nread <= (int)tape_recsz);
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "short read record %lld (nread == %d)\n",
 		      contextp->dc_iocnt,
-		      nread );
+		      nread);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
 	/* some other error
 	 */
-	mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
+	mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
 	      "unexpected error attempting to read record %lld: "
 	      "read returns %d, errno %d (%s)\n"),
 	      contextp->dc_iocnt,
 	      nread,
 	      errno,
-	      strerror( errno ));
+	      strerror(errno));
 	return DRIVE_ERROR_CORRUPTION;
 }
 
 static int
-ring_read( void *clientctxp, char *bufp )
+ring_read(void *clientctxp, char *bufp)
 {
-	return read_record( ( drive_t * )clientctxp, bufp );
+	return read_record((drive_t *)clientctxp, bufp);
 }
 
 /* gets another record IF dc_recp is NULL
  */
 static int
-getrec( drive_t *drivep )
+getrec(drive_t *drivep)
 {
 	drive_context_t *contextp;
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
-	while ( ! contextp->dc_recp ) {
+	while (! contextp->dc_recp) {
 		rec_hdr_t *rechdrp;
-		if ( contextp->dc_singlethreadedpr ) {
+		if (contextp->dc_singlethreadedpr) {
 			int rval;
 			contextp->dc_recp = contextp->dc_bufp;
-			rval = read_record( drivep, contextp->dc_recp );
-			if ( rval ) {
+			rval = read_record(drivep, contextp->dc_recp);
+			if (rval) {
 				contextp->dc_errorpr = BOOL_TRUE;
 				return rval;
 			}
 		} else {
-			contextp->dc_msgp = Ring_get( contextp->dc_ringp );
-			switch( contextp->dc_msgp->rm_stat ) {
+			contextp->dc_msgp = Ring_get(contextp->dc_ringp);
+			switch(contextp->dc_msgp->rm_stat) {
 			case RING_STAT_OK:
 				contextp->dc_recp = contextp->dc_msgp->rm_bufp;
 				break;
@@ -5002,20 +5002,20 @@ getrec( drive_t *drivep )
 			case RING_STAT_NOPACK:
 			case RING_STAT_IGNORE:
 				contextp->dc_msgp->rm_op = RING_OP_READ;
-				Ring_put( contextp->dc_ringp,
-					  contextp->dc_msgp );
+				Ring_put(contextp->dc_ringp,
+					  contextp->dc_msgp);
 				contextp->dc_msgp = 0;
 				continue;
 			case RING_STAT_ERROR:
 				contextp->dc_errorpr = BOOL_TRUE;
 				return contextp->dc_msgp->rm_rval;
 			default:
-				assert( 0 );
+				assert(0);
 				contextp->dc_errorpr = BOOL_TRUE;
 				return DRIVE_ERROR_CORE;
 			}
 		}
-		rechdrp = ( rec_hdr_t * )contextp->dc_recp;
+		rechdrp = (rec_hdr_t *)contextp->dc_recp;
 		contextp->dc_recendp = contextp->dc_recp + tape_recsz;
 		contextp->dc_dataendp = contextp->dc_recp
 				        +
@@ -5023,7 +5023,7 @@ getrec( drive_t *drivep )
 		contextp->dc_nextp = contextp->dc_recp
 				     +
 				     STAPE_HDR_SZ;
-		assert( contextp->dc_nextp <= contextp->dc_dataendp );
+		assert(contextp->dc_nextp <= contextp->dc_dataendp);
 	}
 
 	return 0;
@@ -5034,73 +5034,73 @@ getrec( drive_t *drivep )
  */
 /*ARGSUSED*/
 static int
-write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
+write_record(drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int nwritten;
 	int saved_errno;
 	int rval;
 
-        if ( xlatepr ) {
+        if (xlatepr) {
 		rec_hdr_t rechdr;
-		memcpy( &rechdr, bufp, sizeof(rechdr) );
-		xlate_rec_hdr( &rechdr, ( rec_hdr_t * )bufp, 1 );
+		memcpy(&rechdr, bufp, sizeof(rechdr));
+		xlate_rec_hdr(&rechdr, (rec_hdr_t *)bufp, 1);
 	}
 
-	if ( chksumpr ) {
-		tape_rec_checksum_set( contextp, bufp );
+	if (chksumpr) {
+		tape_rec_checksum_set(contextp, bufp);
 	}
 
-	nwritten = Write( drivep, bufp, tape_recsz, &saved_errno );
+	nwritten = Write(drivep, bufp, tape_recsz, &saved_errno);
 
-	if ( nwritten == ( int )tape_recsz ) {
+	if (nwritten == (int)tape_recsz) {
 		contextp->dc_iocnt++;
 		return 0;
 	}
 
-	rval = determine_write_error( drivep, nwritten, saved_errno );
-	assert( rval );
+	rval = determine_write_error(drivep, nwritten, saved_errno);
+	assert(rval);
 
 	return rval;
 }
 
 static int
-ring_write( void *clientctxp, char *bufp )
+ring_write(void *clientctxp, char *bufp)
 {
-	return write_record( ( drive_t * )clientctxp, bufp, BOOL_TRUE, BOOL_TRUE );
+	return write_record((drive_t *)clientctxp, bufp, BOOL_TRUE, BOOL_TRUE);
 }
 
 static ring_msg_t *
-Ring_get( ring_t *ringp )
+Ring_get(ring_t *ringp)
 {
 	ring_msg_t *msgp;
 
-	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
-	      "ring op: get\n" );
+	mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
+	      "ring op: get\n");
 
-	msgp = ring_get( ringp );
+	msgp = ring_get(ringp);
 	return msgp;
 }
 
 static void
-Ring_put(  ring_t *ringp, ring_msg_t *msgp )
+Ring_put(ring_t *ringp, ring_msg_t *msgp)
 {
-	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
+	mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
 	      "ring op: put %d\n",
-	      msgp->rm_op );
+	      msgp->rm_op);
 
-	ring_put( ringp, msgp );
+	ring_put(ringp, msgp);
 }
 
 static void
-Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
+Ring_reset(ring_t *ringp, ring_msg_t *msgp)
 {
-	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
-	      "ring op: reset\n" );
+	mlog((MLOG_NITTY + 1) | MLOG_DRIVE,
+	      "ring op: reset\n");
 
-	assert( ringp );
+	assert(ringp);
 
-	ring_reset( ringp, msgp );
+	ring_reset(ringp, msgp);
 }
 
 /* a simple heuristic to calculate the maximum uncertainty
@@ -5108,11 +5108,11 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
  * end of media.
  */
 static void
-calc_max_lost( drive_t *drivep )
+calc_max_lost(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	if ( contextp->dc_isQICpr ) {
+	if (contextp->dc_isQICpr) {
 		contextp->dc_lostrecmax = 1;
 	} else {
 		contextp->dc_lostrecmax = 2;
@@ -5121,33 +5121,33 @@ calc_max_lost( drive_t *drivep )
 }
 
 static void
-display_ring_metrics( drive_t *drivep, int mlog_flags )
+display_ring_metrics(drive_t *drivep, int mlog_flags)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	ring_t *ringp = contextp->dc_ringp;
-	char bufszbuf[ 16 ];
+	char bufszbuf[16];
 	char *bufszsfxp;
 
-	if ( tape_recsz == STAPE_MIN_MAX_BLKSZ ) {
-		assert( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
-		sprintf( bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400 );
-		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
+	if (tape_recsz == STAPE_MIN_MAX_BLKSZ) {
+		assert(! (STAPE_MIN_MAX_BLKSZ % 0x400));
+		sprintf(bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400);
+		assert(strlen(bufszbuf) < sizeof(bufszbuf));
 		bufszsfxp = "KB";
-	} else if ( tape_recsz == STAPE_MAX_RECSZ ) {
-		assert( ! ( STAPE_MAX_RECSZ % 0x100000 ));
-		sprintf( bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000 );
-		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
+	} else if (tape_recsz == STAPE_MAX_RECSZ) {
+		assert(! (STAPE_MAX_RECSZ % 0x100000));
+		sprintf(bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000);
+		assert(strlen(bufszbuf) < sizeof(bufszbuf));
 		bufszsfxp = "MB";
-	} else if ( tape_recsz == STAPE_MAX_LINUX_RECSZ ) {
-		assert( ! ( STAPE_MAX_LINUX_RECSZ % 0x100000 ));
-		sprintf( bufszbuf, "%u", STAPE_MAX_LINUX_RECSZ / 0x100000 );
-		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
+	} else if (tape_recsz == STAPE_MAX_LINUX_RECSZ) {
+		assert(! (STAPE_MAX_LINUX_RECSZ % 0x100000));
+		sprintf(bufszbuf, "%u", STAPE_MAX_LINUX_RECSZ / 0x100000);
+		assert(strlen(bufszbuf) < sizeof(bufszbuf));
 		bufszsfxp = "MB";
 	} else {
 		bufszsfxp = "";
 	}
 
-	mlog( mlog_flags, _(
+	mlog(mlog_flags, _(
 	      "I/O metrics: "
 	      "%u by %s%s %sring; "
 	      "%lld/%lld (%.0lf%%) records streamed; "
@@ -5158,100 +5158,100 @@ display_ring_metrics( drive_t *drivep, int mlog_flags )
 	      contextp->dc_ringpinnedpr ? _("pinned ") : "",
 	      ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
 	      ringp->r_slave_msgcnt,
-	      percent64( ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
-			 ringp->r_slave_msgcnt ),
-	      ( double )( ringp->r_all_io_cnt )
+	      percent64(ringp->r_slave_msgcnt - ringp->r_slave_blkcnt,
+			 ringp->r_slave_msgcnt),
+	      (double)(ringp->r_all_io_cnt)
 	      *
-	      ( double )tape_recsz
+	      (double)tape_recsz
 	      /
-	      ( double )( time( 0 ) - ringp->r_first_io_time ));
+	      (double)(time(0) - ringp->r_first_io_time));
 }
 
 static mtstat_t
-rewind_and_verify( drive_t *drivep )
+rewind_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	ix_t try;
 	int rval;
 
-	rval = mt_op( contextp->dc_fd, MTREW, 0 );
-	for ( try = 1 ; ; try++ ) {
+	rval = mt_op(contextp->dc_fd, MTREW, 0);
+	for (try = 1 ; ; try++) {
 		mtstat_t mtstat;
 		bool_t ok;
 
-		if ( rval ) {
-			sleep( 1 );
-			rval = mt_op( contextp->dc_fd, MTREW, 0 );
+		if (rval) {
+			sleep(1);
+			rval = mt_op(contextp->dc_fd, MTREW, 0);
 		}
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
 			mtstat = 0;
-			status_failed_message( drivep );
-			if ( try > 1 ) {
+			status_failed_message(drivep);
+			if (try > 1) {
 				return 0;
 			}
 		}
-		if ( IS_BOT( mtstat )) {
+		if (IS_BOT(mtstat)) {
 			return mtstat;
 		}
-		if ( try >= MTOP_TRIES_MAX ) {
+		if (try >= MTOP_TRIES_MAX) {
 			return mtstat;
 		}
-		if ( rval ) {
+		if (rval) {
 			return mtstat;
 		}
-		sleep( 1 );
+		sleep(1);
 	}
 	/* NOTREACHED */
 }
 
 static mtstat_t
-erase_and_verify( drive_t *drivep )
+erase_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	mtstat_t mtstat;
 	bool_t ok;
 
-	( void )mt_op( contextp->dc_fd, MTERASE, 0 );
-	ok = mt_get_status( drivep, &mtstat );
-	if ( ! ok ) {
+	(void)mt_op(contextp->dc_fd, MTERASE, 0);
+	ok = mt_get_status(drivep, &mtstat);
+	if (! ok) {
 		mtstat = 0;
-		status_failed_message( drivep );
+		status_failed_message(drivep);
 	}
 	return mtstat;
 }
 
 static mtstat_t
-bsf_and_verify( drive_t *drivep )
+bsf_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	ix_t try;
 	bool_t ok;
 
 	/* Can't do with LINUX ST driver, as GMT_EOF never set for left of fmk */
-	if ( TS_ISDRIVER ) {
-		( void )mt_op( contextp->dc_fd, MTBSF, 1 );
-		for ( try = 1 ; ; try++ ) {
+	if (TS_ISDRIVER) {
+		(void)mt_op(contextp->dc_fd, MTBSF, 1);
+		for (try = 1 ; ; try++) {
 			mtstat_t mtstat;
 
-			ok = mt_get_status( drivep, &mtstat );
-			if ( ! ok ) {
+			ok = mt_get_status(drivep, &mtstat);
+			if (! ok) {
 				mtstat = 0;
-				status_failed_message( drivep );
-				if ( try > 1 ) {
+				status_failed_message(drivep);
+				if (try > 1) {
 					return 0;
 				}
 			}
-			if ( IS_FMK( mtstat )) {
+			if (IS_FMK(mtstat)) {
 				return mtstat;
 			}
-			if ( IS_BOT( mtstat )) {
+			if (IS_BOT(mtstat)) {
 				return mtstat;
 			}
-			if ( try >= MTOP_TRIES_MAX ) {
+			if (try >= MTOP_TRIES_MAX) {
 				return mtstat;
 			}
-			sleep( 1 );
+			sleep(1);
 		}
 	} else {
 		long fileno;
@@ -5264,29 +5264,29 @@ bsf_and_verify( drive_t *drivep )
 		 * Do a rewind instead because the status won't be
 		 * set correctly otherwise. [TS:Oct/2000]
 		 */
-		ok = mt_get_fileno( drivep, &fileno );
-		if ( ! ok ) {
-			status_failed_message( drivep );
+		ok = mt_get_fileno(drivep, &fileno);
+		if (! ok) {
+			status_failed_message(drivep);
 			return 0;
 		}
 		if (fileno == 0) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "In first file, do a rewind to achieve bsf\n");
-			return rewind_and_verify( drivep );
+			return rewind_and_verify(drivep);
 		}
 
-		( void )mt_op( contextp->dc_fd, MTBSF, 1 );
+		(void)mt_op(contextp->dc_fd, MTBSF, 1);
 
 		try = 1;
-status:		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
+status:		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
 			mtstat = 0;
-			status_failed_message( drivep );
-			if ( try > 1 ) {
+			status_failed_message(drivep);
+			if (try > 1) {
 				return 0;
 			}
 			try++;
-			sleep( 1 );
+			sleep(1);
 			goto status;
 		}
 		return mtstat;
@@ -5295,56 +5295,56 @@ status:		ok = mt_get_status( drivep, &mtstat );
 }
 
 static mtstat_t
-fsf_and_verify( drive_t *drivep )
+fsf_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	ix_t try;
 
-	( void )mt_op( contextp->dc_fd, MTFSF, 1 );
-	for ( try = 1 ; ; try++ ) {
+	(void)mt_op(contextp->dc_fd, MTFSF, 1);
+	for (try = 1 ; ; try++) {
 		mtstat_t mtstat;
 		bool_t ok;
 
-		ok = mt_get_status( drivep, &mtstat );
-		if ( ! ok ) {
+		ok = mt_get_status(drivep, &mtstat);
+		if (! ok) {
 			mtstat = 0;
-			status_failed_message( drivep );
-			if ( try > 1 ) {
+			status_failed_message(drivep);
+			if (try > 1) {
 				return 0;
 			}
 		}
-		if ( IS_FMK( mtstat )) {
+		if (IS_FMK(mtstat)) {
 			return mtstat;
 		}
-		if ( IS_EOD( mtstat )) {
+		if (IS_EOD(mtstat)) {
 			return mtstat;
 		}
-		if ( IS_EOT( mtstat )) {
+		if (IS_EOT(mtstat)) {
 			return mtstat;
 		}
-		if ( try >= MTOP_TRIES_MAX ) {
+		if (try >= MTOP_TRIES_MAX) {
 			return mtstat;
 		}
-		sleep( 1 );
+		sleep(1);
 	}
 	/* NOTREACHED */
 }
 
 static void
-calc_best_blk_and_rec_sz( drive_t *drivep )
+calc_best_blk_and_rec_sz(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	if ( ! contextp->dc_isrmtpr ) {
-		if ( cmdlineblksize > 0 ) {
+	if (! contextp->dc_isrmtpr) {
+		if (cmdlineblksize > 0) {
 		    tape_blksz = cmdlineblksize;
                 } else {
 		    tape_blksz = contextp->dc_maxblksz;
                 }
-		if ( tape_blksz > STAPE_MAX_RECSZ ) {
+		if (tape_blksz > STAPE_MAX_RECSZ) {
 			tape_blksz = STAPE_MAX_RECSZ;
 		}
-		if ( contextp->dc_isQICpr ) {
+		if (contextp->dc_isQICpr) {
 			tape_recsz = STAPE_MAX_RECSZ;
 		} else {
 			tape_recsz = tape_blksz;
@@ -5355,20 +5355,20 @@ calc_best_blk_and_rec_sz( drive_t *drivep )
 }
 
 static bool_t
-set_best_blk_and_rec_sz( drive_t *drivep )
+set_best_blk_and_rec_sz(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
         calc_best_blk_and_rec_sz(drivep);
 
-	if ( ! contextp->dc_isvarpr
+	if (! contextp->dc_isvarpr
 	     &&
 	     ! contextp->dc_isQICpr
 	     &&
-	     contextp->dc_cansetblkszpr ) {
+	     contextp->dc_cansetblkszpr) {
 		bool_t ok;
-		ok = set_fixed_blksz( drivep, tape_blksz );
-		if ( ! ok ) {
+		ok = set_fixed_blksz(drivep, tape_blksz);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 	}
@@ -5377,13 +5377,13 @@ set_best_blk_and_rec_sz( drive_t *drivep )
 }
 
 static bool_t
-isefsdump( drive_t *drivep )
+isefsdump(drive_t *drivep)
 {
-	int32_t *efshdrp = ( int32_t * )drivep->d_greadhdrp;
-	int32_t efsmagic = efshdrp[ 6 ];
-	if ( efsmagic == 60011
+	int32_t *efshdrp = (int32_t *)drivep->d_greadhdrp;
+	int32_t efsmagic = efshdrp[6];
+	if (efsmagic == 60011
 	     ||
-	     efsmagic == 60012 ) {
+	     efsmagic == 60012) {
 		return BOOL_TRUE;
 	} else {
 		return BOOL_FALSE;
@@ -5397,7 +5397,7 @@ isefsdump( drive_t *drivep )
  * the get_driver_block_major() routine in the libdisk library.)
  */
 static int
-get_driver_character_major( const char *driver )
+get_driver_character_major(const char *driver)
 {
 	FILE	*f;
 	char	buf[64], puf[64];
@@ -5420,7 +5420,7 @@ found:
 }
 
 static void
-map_ts_status( struct mtget *mtstat, struct mtget_sgi mtstat_sgi)
+map_ts_status(struct mtget *mtstat, struct mtget_sgi mtstat_sgi)
 {
 	/*
 	 * This routine has been added as a workaround for a TS/APD
-- 
2.19.1
