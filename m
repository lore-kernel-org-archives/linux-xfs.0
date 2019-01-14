Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfANRZ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:25:59 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DBE73C2CCC
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:25:58 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 02/13] xfsdump: (2/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:17 +0100
Message-Id: <20190114172528.65250-3-jtulak@redhat.com>
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
 common/drive_minrmt.c | 2128 ++++++++++++++++++++---------------------
 1 file changed, 1064 insertions(+), 1064 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 04fed3e..e9be114 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -237,118 +237,118 @@ typedef struct drive_context drive_context_t;
 /* macros for shortcut references to context. assumes a local variable named
  * 'contextp'.
  */
-#define	tape_recsz	( contextp->dc_recsz )
-#define	tape_blksz	( contextp->dc_blksz )
+#define	tape_recsz	(contextp->dc_recsz)
+#define	tape_blksz	(contextp->dc_blksz)
 
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
-static int determine_write_error( int, int );
-static int read_label( drive_t *);
-static bool_t tape_rec_checksum_check( drive_context_t *, char * );
-static void set_recommended_sizes( drive_t * );
-static void display_access_failed_message( drive_t *);
-static bool_t get_tpcaps( drive_t * );
-static int prepare_drive( drive_t *drivep );
-static bool_t Open( drive_t *drivep );
-static void Close( drive_t *drivep );
-static int Read( drive_t *drivep,
+static int	mt_op(int , int , int);
+static int determine_write_error(int, int);
+static int read_label(drive_t *);
+static bool_t tape_rec_checksum_check(drive_context_t *, char *);
+static void set_recommended_sizes(drive_t *);
+static void display_access_failed_message(drive_t *);
+static bool_t get_tpcaps(drive_t *);
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
-static int record_hdr_validate( drive_t *drivep,
+		       int *saved_errnop);
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
 #ifdef CLRMTAUD
-static uint32_t rewind_and_verify( drive_t *drivep );
-static uint32_t erase_and_verify( drive_t *drivep );
-static uint32_t bsf_and_verify( drive_t *drivep );
-static uint32_t fsf_and_verify( drive_t *drivep );
+static uint32_t rewind_and_verify(drive_t *drivep);
+static uint32_t erase_and_verify(drive_t *drivep);
+static uint32_t bsf_and_verify(drive_t *drivep);
+static uint32_t fsf_and_verify(drive_t *drivep);
 #else /* CLRMTAUD */
-static short rewind_and_verify( drive_t *drivep );
-static short erase_and_verify( drive_t *drivep );
-static short bsf_and_verify( drive_t *drivep );
-static short fsf_and_verify( drive_t *drivep );
+static short rewind_and_verify(drive_t *drivep);
+static short erase_and_verify(drive_t *drivep);
+static short bsf_and_verify(drive_t *drivep);
+static short fsf_and_verify(drive_t *drivep);
 #endif /* CLRMTAUD */
-static bool_t set_best_blk_and_rec_sz( drive_t *drivep );
-static bool_t isefsdump( drive_t *drivep );
-static bool_t isxfsdumperasetape( drive_t *drivep );
+static bool_t set_best_blk_and_rec_sz(drive_t *drivep);
+static bool_t isefsdump(drive_t *drivep);
+static bool_t isxfsdumperasetape(drive_t *drivep);
 
 /* RMT trace stubs
  */
 #ifdef RMTDBG
-static int dbgrmtopen( char *, int );
-static int dbgrmtclose( int );
-static int dbgrmtioctl( int, int, void * );
-static int dbgrmtread( int, void *, uint);
-static int dbgrmtwrite( int, void *, uint);
+static int dbgrmtopen(char *, int);
+static int dbgrmtclose(int);
+static int dbgrmtioctl(int, int, void *);
+static int dbgrmtread(int, void *, uint);
+static int dbgrmtwrite(int, void *, uint);
 #endif /* RMTDBG */
 
 #define ERASE_MAGIC "$^*@++! This tape was quick erased by SGI xfsdump $^*@++!"
@@ -408,7 +408,7 @@ static uint32_t cmdlineblksize = 0;
  */
 /* ARGSUSED */
 static int
-ds_match( int argc, char *argv[], drive_t *drivep )
+ds_match(int argc, char *argv[], drive_t *drivep)
 {
 	int fd;
 	int c;
@@ -417,7 +417,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 	/* heuristics to determine if this is a drive.
 	 */
 
-	if ( ! strcmp( drivep->d_pathname, "stdio" )) {
+	if (! strcmp(drivep->d_pathname, "stdio")) {
 		return -10;
 	}
 
@@ -429,21 +429,21 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 	{
 		optind = 1;
 		opterr = 0;
-		while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
+		while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 		   switch (c) {
 		      case GETOPT_BLOCKSIZE:
-			    if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			    if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					_("-%c argument missing\n"),
-					c );
+					c);
 				return -10;
 		    	    }
-			    cmdlineblksize = ( uint32_t )atoi( optarg );
+			    cmdlineblksize = (uint32_t)atoi(optarg);
 		            errno = 0;
-		            fd = open( drivep->d_pathname, O_RDONLY );
-		            if ( fd < 0 )
+		            fd = open(drivep->d_pathname, O_RDONLY);
+		            if (fd < 0)
 			            return -10;
-		            close( fd );
+		            close(fd);
 			    break;
 			case GETOPT_MINRMT:
 			    minrmt = BOOL_TRUE;
@@ -455,9 +455,9 @@ ds_match( int argc, char *argv[], drive_t *drivep )
 			if (cmdlineblksize != 0)
 				return 20;
 		 	else
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					_("Minimal rmt cannot be used without specifying blocksize. Use -%c\n"),
-					GETOPT_BLOCKSIZE );
+					GETOPT_BLOCKSIZE);
 		}
 	}
 	/* catch all */
@@ -468,18 +468,18 @@ ds_match( int argc, char *argv[], drive_t *drivep )
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
@@ -487,9 +487,9 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 
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
@@ -507,26 +507,26 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	contextp->dc_isQICpr = BOOL_FALSE;
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
@@ -545,23 +545,23 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 #ifdef DUMP
 		case GETOPT_OVERWRITE:
 			contextp->dc_overwritepr = BOOL_TRUE;
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      			_("Overwrite command line option\n") );
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      			_("Overwrite command line option\n"));
 			break;
 		case GETOPT_FILESZ:
-			if ( ! optarg || optarg [ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			if (! optarg || optarg [0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      c );
+				      c);
 				return BOOL_FALSE;
 			}
-			contextp->dc_filesz = (off64_t)atoi( optarg ) * 1024 * 1024;
+			contextp->dc_filesz = (off64_t)atoi(optarg) * 1024 * 1024;
 			if (contextp->dc_filesz <= 0) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument must be a "
 				      "positive number (MB): ignoring %u\n"),
 				      c,
-				      contextp->dc_filesz );
+				      contextp->dc_filesz);
 				return BOOL_FALSE;
 			}
 			break;
@@ -585,37 +585,37 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
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
@@ -668,15 +668,15 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
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
-	      "rmt drive op: init\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: init\n");
 
 #ifdef DUMP
 	/* fill in media strategy id: artifact of first version of xfsdump
@@ -693,10 +693,10 @@ do_init( drive_t *drivep )
  */
 /* ARGSUSED */
 static bool_t
-do_sync( drive_t *drivep )
+do_sync(drive_t *drivep)
 {
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: sync\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: sync\n");
 
 	return BOOL_TRUE;
 }
@@ -711,32 +711,32 @@ do_sync( drive_t *drivep )
  *
  */
 static int
-do_begin_read( drive_t *drivep )
+do_begin_read(drive_t *drivep)
 {
         drive_context_t *contextp;
         int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: begin read\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: begin read\n");
 
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
 
@@ -745,38 +745,38 @@ do_begin_read( drive_t *drivep )
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
-		rval = read_label( drivep ) ;
-		if ( rval ) {
-			if ( ! contextp->dc_singlethreadedpr ) {
-			    Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+		rval = read_label(drivep) ;
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
@@ -807,31 +807,31 @@ do_begin_read( drive_t *drivep )
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
 	      "rmt drive op: read: wanted %u (0x%x)\n",
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
@@ -839,30 +839,30 @@ do_read( drive_t *drivep,
 
 	/* read a new record if necessary
 	 */
-	rval = getrec( drivep );
-	if ( rval ) {
-		mlog( MLOG_NITTY | MLOG_DRIVE,
+	rval = getrec(drivep);
+	if (rval) {
+		mlog(MLOG_NITTY | MLOG_DRIVE,
 		      "rmt drive op read returning error rval=%d\n",
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
 	      "rmt drive op read actual == %d (0x%x)\n",
 	      actualcnt,
-	      actualcnt );
+	      actualcnt);
 
 	*actualcntp = actualcnt;
 	return contextp->dc_ownedp;
@@ -877,29 +877,29 @@ do_read( drive_t *drivep,
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
 	      "rmt drive op: return read buf: sz %d (0x%x)\n",
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
@@ -908,11 +908,11 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
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
@@ -930,29 +930,29 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
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
-	      "rmt drive op: get mark\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: get mark\n");
 
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
@@ -969,7 +969,7 @@ typedef enum { SEEKMODE_BUF, SEEKMODE_RAW } seekmode_t;
  *
  */
 static int
-do_seek_mark( drive_t *drivep, drive_mark_t *markp )
+do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 {
 	drive_context_t	*contextp;
 	off64_t wantedoffset;
@@ -981,55 +981,55 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 
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
@@ -1039,39 +1039,39 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
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
 
@@ -1082,208 +1082,208 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
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
@@ -1299,7 +1299,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_next_mark( drive_t *drivep )
+do_next_mark(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 	rec_hdr_t *rechdrp;
@@ -1314,69 +1314,69 @@ do_next_mark( drive_t *drivep )
 
 	/* assert protocol being followed.
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_errorpr );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_errorpr);
+	assert(! contextp->dc_ownedp);
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: next mark\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: next mark\n");
 
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
@@ -1386,124 +1386,124 @@ noerrorsearch:
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
-	mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+	mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 	      _("unexpected error attempting to read record: "
 	      "read returns %d, errno %s (%s)\n"),
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
 	      _("resynchronized at record %lld "
 	      "offset %u\n"),
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
 
@@ -1515,12 +1515,12 @@ huntQIC:
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
@@ -1528,14 +1528,14 @@ huntQIC:
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
@@ -1548,27 +1548,27 @@ adjustQIC:
  *	void
  */
 static void
-do_end_read( drive_t *drivep )
+do_end_read(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: end read\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: end read\n");
 
 	/* assert protocol being followed
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
 
 	/* In the scsi version, read_label() does a status command to the
 	 * drive to then decide if doing a 'fsf' is appropriate.  For minrmt,
 	 * we don't have the status command so we need to space forward at
 	 * the moment we know we need to go forward... which is here.
 	 */
-	( void )fsf_and_verify( drivep );
+	(void)fsf_and_verify(drivep);
 
-	if ( ! contextp->dc_singlethreadedpr ) {
-		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 
@@ -1584,7 +1584,7 @@ do_end_read( drive_t *drivep )
  * 	DRIVE_ERROR_... on failure
  */
 static int
-do_begin_write( drive_t *drivep )
+do_begin_write(drive_t *drivep)
 {
 	drive_context_t		*contextp;
 	drive_hdr_t		*dwhdrp;
@@ -1605,34 +1605,34 @@ do_begin_write( drive_t *drivep )
 
 	/* get drive context
 	 */
-        contextp = ( drive_context_t * )drivep->d_contextp;
+        contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: begin write\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: begin write\n");
 
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
 	 * so all interaction with tape requires reading first.
 	 */
-	assert( contextp->dc_fd != -1 );
+	assert(contextp->dc_fd != -1);
 
 	/* fill in write header's drive specific info
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
@@ -1641,15 +1641,15 @@ do_begin_write( drive_t *drivep )
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
 
@@ -1657,7 +1657,7 @@ do_begin_write( drive_t *drivep )
 	 * being produced!
 	 */
 	contextp->dc_iocnt = 0;
-	memset( ( void * )contextp->dc_recp, 0, tape_recsz );
+	memset((void *)contextp->dc_recp, 0, tape_recsz);
 
 	tmpgh  = (global_hdr_t *)contextp->dc_recp;
 	tmpdh  = (drive_hdr_t *)tmpgh->gh_upper;
@@ -1679,12 +1679,12 @@ do_begin_write( drive_t *drivep )
 
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
@@ -1694,7 +1694,7 @@ do_begin_write( drive_t *drivep )
 	/* prepare the drive context. must have a record buffer ready to
 	 * go, header initialized.
 	 */
-	assert( ! contextp->dc_ownedp );
+	assert(! contextp->dc_ownedp);
 	contextp->dc_reccnt = 1; /* count the header record */
 	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
 	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
@@ -1704,12 +1704,12 @@ do_begin_write( drive_t *drivep )
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
@@ -1724,10 +1724,10 @@ do_begin_write( drive_t *drivep )
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
@@ -1735,34 +1735,34 @@ do_set_mark( drive_t *drivep,
 
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
 	      "rmt drive op: set mark: %lld (0x%llx)\n",
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
 
@@ -1771,11 +1771,11 @@ do_set_mark( drive_t *drivep,
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
@@ -1790,7 +1790,7 @@ do_set_mark( drive_t *drivep,
  *	"actual_bufszp" points to the size of the buffer
  */
 static char *
-do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
+do_get_write_buf(drive_t *drivep, size_t wantedcnt, size_t *actualcntp)
 {
 	drive_context_t *contextp;
 	size_t remainingcnt;
@@ -1798,32 +1798,32 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
 
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
 	      "rmt drive op: get write buf: wanted %u (0x%x) actual %u (0x%x)\n",
 	      wantedcnt,
 	      wantedcnt,
 	      actualcnt,
-	      actualcnt );
+	      actualcnt);
 
 	return contextp->dc_ownedp;
 }
@@ -1841,7 +1841,7 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
  */
 /* ARGSUSED */
 static int
-do_write( drive_t *drivep, char *bufp, size_t retcnt )
+do_write(drive_t *drivep, char *bufp, size_t retcnt)
 {
 	drive_context_t *contextp;
 	rec_hdr_t *rechdrp;
@@ -1852,33 +1852,33 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 
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
 	      "rmt drive op: write: retcnt %u (0x%x) heldcnt %u (0x%x)\n",
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
@@ -1887,30 +1887,30 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
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
@@ -1919,7 +1919,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 			rval = contextp->dc_msgp->rm_rval;
 			break;
 		default:
-			assert( 0 );
+			assert(0);
 			return DRIVE_ERROR_CORE;
 		}
 	}
@@ -1927,7 +1927,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 	/* check for errors. if none, commit all marks before a safety margin
 	 * before the no error offset.
 	 */
-	if ( rval ) {
+	if (rval) {
 		contextp->dc_errorpr = BOOL_TRUE;
 	} else {
 		off64_t recs_wrtn_wo_err;
@@ -1935,8 +1935,8 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 		off64_t bytes_committed;
 		recs_wrtn_wo_err = last_rec_wrtn_wo_err + 1;
 		recs_committed = recs_wrtn_wo_err - contextp->dc_lostrecmax;
-		bytes_committed = recs_committed * ( off64_t )tape_recsz;
-		drive_mark_commit( drivep, bytes_committed );
+		bytes_committed = recs_committed * (off64_t)tape_recsz;
+		drive_mark_commit(drivep, bytes_committed);
 	}
 
 	/* adjust context
@@ -1949,15 +1949,15 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
 
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
@@ -1970,40 +1970,40 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
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
-	      "rmt drive op: get align cnt\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: get align cnt\n");
 
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
@@ -2014,9 +2014,9 @@ do_get_align_cnt( drive_t * drivep )
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
@@ -2024,17 +2024,17 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 
 	int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: end write\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: end write\n");
 
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
@@ -2044,46 +2044,46 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
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
@@ -2092,7 +2092,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 				rval = contextp->dc_msgp->rm_rval;
 				break;
 			default:
-				assert( 0 );
+				assert(0);
 				contextp->dc_recp = 0;
 				return DRIVE_ERROR_CORE;
 			}
@@ -2109,7 +2109,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * media, and that will be used to select which marks
 	 * to commit and which to discard.
 	 */
-	if ( rval ) {
+	if (rval) {
 		first_rec_w_err = contextp->dc_iocnt;
 			/* because dc_iocnt bumped by write_record
 			 * only if no error
@@ -2117,28 +2117,28 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
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
@@ -2147,8 +2147,8 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 
 	/* the ring is now flushed. reset
 	 */
-	if ( ! contextp->dc_singlethreadedpr ) {
-		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
+	if (! contextp->dc_singlethreadedpr) {
+		Ring_reset(contextp->dc_ringp, contextp->dc_msgp);
 		contextp->dc_msgp = 0;
 	}
 	contextp->dc_recp = 0;
@@ -2157,16 +2157,16 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	 * side-effect of flushing the driver/drive of pending writes,
 	 * exposing any write errors.
 	 */
-	if ( ! rval ) {
+	if (! rval) {
 		int weofrval;
 
-		weofrval = mt_op( contextp->dc_fd, MTWEOF, 1 );
-		if ( weofrval ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		weofrval = mt_op(contextp->dc_fd, MTWEOF, 1);
+		if (weofrval) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "MTWEOF returned %d: errno == %d (%s)\n",
 			      weofrval,
 			      errno,
-			      strerror( errno ));
+			      strerror(errno));
 			rval = DRIVE_ERROR_EOM;
 		}
 	}
@@ -2185,18 +2185,18 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
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
@@ -2210,45 +2210,45 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
  *	*statp set to zero or DRIVE_ERROR_...
  */
 static int
-do_fsf( drive_t *drivep, int count, int *statp )
+do_fsf(drive_t *drivep, int count, int *statp)
 {
 	int 		i, done, op_failed, opcount;
 	drive_context_t *contextp;
 
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
 	      "rmt drive op: fsf: count %d\n",
-	      count );
+	      count);
 
-	assert( count );
-	assert( contextp->dc_mode == OM_NONE );
+	assert(count);
+	assert(contextp->dc_mode == OM_NONE);
 
-	for ( i = 0 ; i < count; i++ ) {
+	for (i = 0 ; i < count; i++) {
 		done = 0;
 		opcount = 2;
 
 		/* the tape may encounter errors will trying to
 		 * reach the next file.
 		 */
-		while ( !done ) {
+		while (!done) {
 
 			/* advance the tape to the next file mark
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
 
@@ -2264,9 +2264,9 @@ do_fsf( drive_t *drivep, int count, int *statp )
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
@@ -2286,37 +2286,37 @@ do_fsf( drive_t *drivep, int count, int *statp )
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
 	int rval;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
 	      "rmt drive op: bsf: count %d\n",
-	      count );
+	      count);
 
-	assert( contextp->dc_mode == OM_NONE );
+	assert(contextp->dc_mode == OM_NONE);
 
 	*statp = 0;
 
 	/* back space - places us to left of previous file mark
 	 * if we hit BOT, return
 	 */
-	assert( drivep->d_capabilities & DRIVE_CAP_BSF );
-	rval = bsf_and_verify( drivep );
+	assert(drivep->d_capabilities & DRIVE_CAP_BSF);
+	rval = bsf_and_verify(drivep);
 	if (rval) {
 		if (errno == ENOSPC/*IRIX*/ || errno == EIO/*Linux*/) {
-			if ( count ) {
-				mlog( MLOG_DEBUG | MLOG_DRIVE,
+			if (count) {
+				mlog(MLOG_DEBUG | MLOG_DRIVE,
 				      "rmt drive op: bsf reached BOT "
 					    "unexpectedly (%d files to go)\n",
 				       count);
 				/* set statp - BOT is unexpected */
 			} else {
-				mlog( MLOG_DEBUG | MLOG_DRIVE,
+				mlog(MLOG_DEBUG | MLOG_DRIVE,
 				      "rmt drive op: bsf reached BOT\n");
 				/* don't set statp, BOT is fine */
 				return 0;
@@ -2328,16 +2328,16 @@ do_bsf( drive_t *drivep, int count, int *statp )
 
 	/* now loop, skipping media files
 	 */
-	for ( skipped = 0 ; skipped < count ; skipped++ ) {
+	for (skipped = 0 ; skipped < count ; skipped++) {
 
 		/* move to the left of the next file mark on the left.
 		 * check for BOT.
 		 */
-		rval = bsf_and_verify( drivep );
+		rval = bsf_and_verify(drivep);
 		if (rval) {
 			if (errno == ENOSPC/*IRIX*/ || errno == EIO/*Linux*/) {
-				if ( count - skipped - 1 ) {
-					mlog( MLOG_DEBUG | MLOG_DRIVE,
+				if (count - skipped - 1) {
+					mlog(MLOG_DEBUG | MLOG_DRIVE,
 					      "rmt drive op: bsf reached BOT "
 					      "unexpectedly (%d files to go)\n",
 					      count - skipped - 1);
@@ -2345,7 +2345,7 @@ do_bsf( drive_t *drivep, int count, int *statp )
 					*statp = DRIVE_ERROR_DEVICE;
 					return skipped + 1;
 				} else {
-					mlog( MLOG_DEBUG | MLOG_DRIVE,
+					mlog(MLOG_DEBUG | MLOG_DRIVE,
 					      "rmt drive op: bsf reached BOT\n");
 					/* don't set statp - BOT is fine */
 					return skipped + 1;
@@ -2359,7 +2359,7 @@ do_bsf( drive_t *drivep, int count, int *statp )
 	/* we're not at BOT, so we need to move to the right side of
 	 * the file mark
 	 */
-	( void )fsf_and_verify( drivep );
+	(void)fsf_and_verify(drivep);
 
 	/* indicate the number of media files skipped
 	 */
@@ -2374,21 +2374,21 @@ do_bsf( drive_t *drivep, int count, int *statp )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_rewind( drive_t *drivep )
+do_rewind(drive_t *drivep)
 {
 #ifdef DEBUG
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 #endif
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: rewind\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: rewind\n");
 
-	assert( contextp->dc_mode == OM_NONE );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(contextp->dc_fd >= 0);
 
 	/* use validating tape rewind util func
 	 */
-	( void )rewind_and_verify( drivep );
+	(void)rewind_and_verify(drivep);
 	return 0;
 }
 
@@ -2400,33 +2400,33 @@ do_rewind( drive_t *drivep )
  *	DRIVE_ERROR_* on failure
  */
 static int
-do_erase( drive_t *drivep )
+do_erase(drive_t *drivep)
 {
 #ifdef DEBUG
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 #endif
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: erase\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: erase\n");
 
-	assert( contextp->dc_mode == OM_NONE );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(contextp->dc_fd >= 0);
 
 	/* use validating tape rewind util func
 	 */
-	(void )rewind_and_verify( drivep );
+	(void)rewind_and_verify(drivep);
 
 	/* use validating tape erase util func
 	 */
-	( void )erase_and_verify( drivep );
+	(void)erase_and_verify(drivep);
 
 	/* rewind again
 	 */
-	( void )rewind_and_verify( drivep );
+	(void)rewind_and_verify(drivep);
 
 	/* close the drive so we start from scratch
 	 */
-	Close( drivep );
+	Close(drivep);
 	return 0;
 }
 
@@ -2438,27 +2438,27 @@ do_erase( drive_t *drivep )
  *	DRIVE_ERROR_DEVICE on failure
  */
 static int
-do_eject_media( drive_t *drivep )
+do_eject_media(drive_t *drivep)
 {
 	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: eject media\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: eject media\n");
 
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
@@ -2471,10 +2471,10 @@ do_eject_media( drive_t *drivep )
  */
 /* ARGSUSED */
 static int
-do_get_device_class( drive_t *drivep)
+do_get_device_class(drive_t *drivep)
 {
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op: get device class\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: get device class\n");
 
 	return DEVICE_TAPE_REMOVABLE;
 }
@@ -2482,55 +2482,55 @@ do_get_device_class( drive_t *drivep)
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
-	      "rmt drive op: quit\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op: quit\n");
 
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
 
 	Close(drivep);
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt drive op quit complete\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt drive op quit complete\n");
 }
 
 static double
-percent64( off64_t num, off64_t denom )
+percent64(off64_t num, off64_t denom)
 {
-	return ( double )( num * 100 ) / ( double )denom;
+	return (double)(num * 100) / (double)denom;
 }
 
 
@@ -2546,7 +2546,7 @@ percent64( off64_t num, off64_t denom )
  *	DRIVE_ERROR_* on failure
  */
 static int
-read_label( drive_t *drivep )
+read_label(drive_t *drivep)
 {
 	drive_context_t *contextp;
 	int nread;
@@ -2555,45 +2555,45 @@ read_label( drive_t *drivep )
 
 	/* initialize context ptr
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
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
+	if (nread != (int)tape_recsz) {
+		assert(nread < (int)tape_recsz);
 	}
 
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
 
 	/* check for a blank tape/EOD.
 	 */
-	if (( nread == 0 )  /* takes care of sun */
+	if ((nread == 0)  /* takes care of sun */
 	      ||            /* now handle SGI */
-	      (nread < 0 && saved_errno == ENOSPC )) {
+	      (nread < 0 && saved_errno == ENOSPC)) {
 #ifdef DUMP
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
-		      _("encountered EOD : assuming blank media\n") );
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
+		      _("encountered EOD : assuming blank media\n"));
 #endif
 #ifdef RESTORE
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
-		      _("encountered EOD : end of data\n") );
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
+		      _("encountered EOD : end of data\n"));
 #endif
-		( void )rewind_and_verify( drivep );
+		(void)rewind_and_verify(drivep);
 #ifdef DUMP
 		return DRIVE_ERROR_BLANK;
 #endif
@@ -2607,13 +2607,13 @@ read_label( drive_t *drivep )
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
@@ -2621,7 +2621,7 @@ validate_media_file_hdr( drive_t *drivep )
 	media_hdr_t		*mrhdrp = (media_hdr_t *)drhdrp->dh_upper;
 	content_hdr_t		*ch = (content_hdr_t *)mrhdrp->mh_upper;
 	content_inode_hdr_t	*cih = (content_inode_hdr_t *)ch->ch_specific;
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	char tmpbuf[GLOBAL_HDR_SZ];
 	global_hdr_t		*tmpgh = (global_hdr_t *)&tmpbuf[0];
 	drive_hdr_t		*tmpdh = (drive_hdr_t *)tmpgh->gh_upper;
@@ -2630,22 +2630,22 @@ validate_media_file_hdr( drive_t *drivep )
 	content_hdr_t		*tmpch = (content_hdr_t *)tmpmh->mh_upper;
 	content_inode_hdr_t	*tmpcih = (content_inode_hdr_t *)tmpch->ch_specific;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "validating media file header\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "validating media file header\n");
 
-	memcpy( tmpbuf, contextp->dc_recp, GLOBAL_HDR_SZ );
+	memcpy(tmpbuf, contextp->dc_recp, GLOBAL_HDR_SZ);
 
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
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
-		      _("tape record checksum error\n") );
+	if (! tape_rec_checksum_check(contextp, contextp->dc_recp)) {
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
+		      _("tape record checksum error\n"));
 		return DRIVE_ERROR_CORRUPTION;
 
 	}
@@ -2657,54 +2657,54 @@ validate_media_file_hdr( drive_t *drivep )
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
@@ -2720,12 +2720,12 @@ validate_media_file_hdr( drive_t *drivep )
  *	FALSE on error
  */
 static bool_t
-get_tpcaps( drive_t *drivep )
+get_tpcaps(drive_t *drivep)
 {
 #ifdef DEBUG
-	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t	*contextp = (drive_context_t *)drivep->d_contextp;
 
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_fd >= 0);
 #endif
 
 	/* can't ask about blksz, can't set blksz, can't ask about
@@ -2736,7 +2736,7 @@ get_tpcaps( drive_t *drivep )
 	drivep->d_capabilities |= DRIVE_CAP_OVERWRITE;
 	drivep->d_capabilities |= DRIVE_CAP_BSF;
 
-	set_recommended_sizes( drivep );
+	set_recommended_sizes(drivep);
 
 	return BOOL_TRUE;
 }
@@ -2749,32 +2749,32 @@ get_tpcaps( drive_t *drivep )
  *	void
  */
 static void
-set_recommended_sizes( drive_t *drivep )
+set_recommended_sizes(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t	fsize = drive_strategy_rmt.ds_recmfilesz;
 	off64_t	marksep = drive_strategy_rmt.ds_recmarksep;
 
 	if (contextp->dc_filesz > 0) {
 		fsize = contextp->dc_filesz;
 #ifdef DUMP
-		if ( hdr_mfilesz > fsize ) {
-			mlog( MLOG_WARNING, _(
+		if (hdr_mfilesz > fsize) {
+			mlog(MLOG_WARNING, _(
 			      "recommended media file size of %llu Mb less than "
 			      "estimated file header size %llu Mb for %s\n"),
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
@@ -2792,18 +2792,18 @@ set_recommended_sizes( drive_t *drivep )
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
@@ -2842,22 +2842,22 @@ mt_op(int fd, int sub_op, int param )
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
 
@@ -2874,82 +2874,82 @@ mt_op(int fd, int sub_op, int param )
  *      DRIVE_ERROR_*
  */
 static int
-determine_write_error( int nwritten, int saved_errno )
+determine_write_error(int nwritten, int saved_errno)
 {
 	int        ret = 0;
 
-	if ( saved_errno == EACCES ) {
+	if (saved_errno == EACCES) {
 		mlog(MLOG_NORMAL,
-			_("tape is write protected\n") );
+			_("tape is write protected\n"));
 
 		ret = DRIVE_ERROR_DEVICE;
 	} else if (
-			( saved_errno == ENOSPC )
+			(saved_errno == ENOSPC)
 				||
-			( saved_errno == EIO )
+			(saved_errno == EIO)
 				||
-			(( saved_errno == 0 ) && ( nwritten >= 0 ))  /* short
+			((saved_errno == 0) && (nwritten >= 0))  /* short
 							write indicates EOM */
 		) {
 		mlog(MLOG_NORMAL,
-			_("tape media error on write operation\n") );
+			_("tape media error on write operation\n"));
 
 		mlog(MLOG_NORMAL,
-			_("no more data can be written to this tape\n") );
+			_("no more data can be written to this tape\n"));
 
 		ret = DRIVE_ERROR_EOM;
-	} else if ( saved_errno != 0 ) {
+	} else if (saved_errno != 0) {
 		ret = DRIVE_ERROR_CORE;
 
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 			"tape unknown error on write operation: "
 			"%d, %d\n",
 			nwritten, saved_errno);
 	}
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 		"tape write operation nwritten %d, errno %d\n",
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
 
-	if ( contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT) ) {
+	if (contextp->dc_recchksumpr && INT_GET(rechdrp->ischecksum, ARCH_CONVERT)) {
 		accum = 0;
-		for ( p = beginp ; p < endp ; p++ ) {
+		for (p = beginp ; p < endp ; p++) {
 	       		accum += INT_GET(*p, ARCH_CONVERT);
 		}
 		return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
@@ -2962,75 +2962,75 @@ tape_rec_checksum_check( drive_context_t *contextp, char *bufp )
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
@@ -3042,14 +3042,14 @@ dbgrmtwrite( int fd, void *p, uint sz )
  *	void
  */
 static void
-display_access_failed_message( drive_t *drivep )
+display_access_failed_message(drive_t *drivep)
 {
-	mlog( MLOG_NORMAL | MLOG_DRIVE, _(
+	mlog(MLOG_NORMAL | MLOG_DRIVE, _(
 		"attempt to access/open remote "
 		"tape drive %s failed: %d (%s)\n"),
 		drivep->d_pathname,
 		errno,
-		strerror( errno ));
+		strerror(errno));
 	return;
 }
 
@@ -3059,7 +3059,7 @@ display_access_failed_message( drive_t *drivep )
  * xfsdumps on media.
  */
 static int
-prepare_drive( drive_t *drivep )
+prepare_drive(drive_t *drivep)
 {
 	drive_context_t	*contextp;
 	bool_t ok;
@@ -3070,46 +3070,46 @@ prepare_drive( drive_t *drivep )
 
 	/* get pointer to drive context
 	 */
-	contextp = ( drive_context_t * )drivep->d_contextp;
+	contextp = (drive_context_t *)drivep->d_contextp;
 
 /* retry: */
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
-				Close( drivep );
+				Close(drivep);
 				continue;
 			}
 		} else
@@ -3120,8 +3120,8 @@ prepare_drive( drive_t *drivep )
 	 * and contextp->dc_{...}blksz and dc_isQICpr, as well as recommended
 	 * mark separation and media file size.
 	 */
-	ok = get_tpcaps( drivep );
-	if ( ! ok ) {
+	ok = get_tpcaps(drivep);
+	if (! ok) {
 		return DRIVE_ERROR_DEVICE;
 	}
 
@@ -3131,19 +3131,19 @@ prepare_drive( drive_t *drivep )
 	 * guess.
 	 */
 	tape_blksz = cmdlineblksize;
-	if ( tape_blksz > STAPE_MAX_RECSZ ) {
+	if (tape_blksz > STAPE_MAX_RECSZ) {
 		tape_blksz = STAPE_MAX_RECSZ;
 	}
-	if ( contextp->dc_isQICpr == BOOL_TRUE )
+	if (contextp->dc_isQICpr == BOOL_TRUE)
 		tape_recsz = STAPE_MIN_MAX_BLKSZ;
 	else
 		tape_recsz = tape_blksz;
 
 	/* if the overwrite option was specified , return.
 	 */
-	if ( contextp->dc_overwritepr ) {
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
-			"Overwrite option specified.\n" );
+	if (contextp->dc_overwritepr) {
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
+			"Overwrite option specified.\n");
 		return DRIVE_ERROR_OVERWRITE;
 	}
 
@@ -3157,74 +3157,74 @@ prepare_drive( drive_t *drivep )
 	maxtries = 5;
 	changedblkszpr = BOOL_FALSE;
 
-	for ( try = 1 ; ; try++ ) {
+	for (try = 1 ; ; try++) {
 		int nread;
 		int saved_errno;
 
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return DRIVE_ERROR_STOP;
 		}
 
 		/* bail out if we've tried too many times
 		 */
-		if ( try > maxtries ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+		if (try > maxtries) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 			      _("giving up attempt to determining "
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
 
 
 		/* I/O error
 		 */
-		if ( saved_errno == EIO ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (saved_errno == EIO) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "read returned EIO: will reopen, "
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
 #ifdef RESTORE
@@ -3240,14 +3240,14 @@ prepare_drive( drive_t *drivep )
 
 		/* ENOSPC
 		 */
-		if ( saved_errno == ENOSPC ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (saved_errno == ENOSPC) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			      "read returned ENOSPC: will reopen, "
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
 #ifdef RESTORE
@@ -3263,19 +3263,19 @@ prepare_drive( drive_t *drivep )
 #endif
 		}
 
-		if ( nread == ( int )tape_recsz ) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if (nread == (int)tape_recsz) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread == selected blocksize "
-			  "indicates correct blocksize found\n" );
+			  "indicates correct blocksize found\n");
 			goto checkhdr;
 		}
 
 		/* short read */
-		if (( saved_errno == 0 ) && ( nread < (int)tape_recsz)) {
-			mlog( MLOG_DEBUG | MLOG_DRIVE,
+		if ((saved_errno == 0) && (nread < (int)tape_recsz)) {
+			mlog(MLOG_DEBUG | MLOG_DRIVE,
 			  "nread < selected blocksize "
 			  "indicates incorrect blocksize found "
-			  "or foreign media\n" );
+			  "or foreign media\n");
 			return DRIVE_ERROR_FOREIGN;
 		}
 
@@ -3283,7 +3283,7 @@ prepare_drive( drive_t *drivep )
 		/* if we fell through the seive, code is wrong.
 		 * display useful info and abort
 		 */
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE, _(
 		      "unexpected tape error: "
 		      "errno %d "
 		      "nread %d "
@@ -3294,7 +3294,7 @@ prepare_drive( drive_t *drivep )
 		      nread,
 		      tape_blksz,
 		      tape_recsz,
-		      0 );
+		      0);
 
 
 
@@ -3302,18 +3302,18 @@ prepare_drive( drive_t *drivep )
 		return DRIVE_ERROR_MEDIA;
 
 checkhdr:
-		rval = validate_media_file_hdr( drivep );
-		if ( rval ) {
-			if ( rval == DRIVE_ERROR_VERSION ) {
+		rval = validate_media_file_hdr(drivep);
+		if (rval) {
+			if (rval == DRIVE_ERROR_VERSION) {
 				global_hdr_t *grhdrp = drivep->d_greadhdrp;
-				mlog( MLOG_NORMAL | MLOG_DRIVE, _(
+				mlog(MLOG_NORMAL | MLOG_DRIVE, _(
 				      "media file header version (%d) "
 				      "invalid: advancing\n"),
-				      grhdrp->gh_version );
+				      grhdrp->gh_version);
 				continue;
 			} else {
-				if ( isefsdump( drivep )) {
-					mlog( MLOG_NORMAL
+				if (isefsdump(drivep)) {
+					mlog(MLOG_NORMAL
 					      |
 					      MLOG_WARNING
 					      |
@@ -3321,21 +3321,21 @@ checkhdr:
 					      _("may be an EFS dump at BOT\n"));
 				} else
 				/* Check if the tape was erased by us */
-				if  ( isxfsdumperasetape( drivep )) {
-					mlog( MLOG_NORMAL | MLOG_DRIVE,
+				if  (isxfsdumperasetape(drivep)) {
+					mlog(MLOG_NORMAL | MLOG_DRIVE,
 					      _("This tape was erased earlier "
-					      "by xfsdump.\n") );
-					( void )rewind_and_verify( drivep );
+					      "by xfsdump.\n"));
+					(void)rewind_and_verify(drivep);
 					return DRIVE_ERROR_BLANK;
 				} else {
-					mlog( MLOG_NORMAL | MLOG_DRIVE,
+					mlog(MLOG_NORMAL | MLOG_DRIVE,
 					      _("bad media file header at BOT "
 					      "indicates foreign or "
-					      "corrupted tape\n") );
+					      "corrupted tape\n"));
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
@@ -3344,9 +3344,9 @@ checkhdr:
 			drive_hdr_t *drhdrp;
 			rec_hdr_t *tprhdrp;
 			drhdrp = drivep->d_readhdrp;
-			tprhdrp = ( rec_hdr_t * )drhdrp->dh_specific;
-			assert( tprhdrp->recsize >= 0 );
-			tape_recsz = ( size_t )tprhdrp->recsize;
+			tprhdrp = (rec_hdr_t *)drhdrp->dh_specific;
+			assert(tprhdrp->recsize >= 0);
+			tape_recsz = (size_t)tprhdrp->recsize;
 			break;
 		}
 
@@ -3354,44 +3354,44 @@ largersize:
 		/* we end up here if we want to try a new larger record size
 		 * because the last one was not big enough for the tape block
 		 */
-		if ( changedblkszpr ) {
-			mlog( MLOG_NORMAL | MLOG_DRIVE,
+		if (changedblkszpr) {
+			mlog(MLOG_NORMAL | MLOG_DRIVE,
 			      _("cannot determine tape block size "
-			      "after two tries\n") );
-				mlog( MLOG_NORMAL | MLOG_DRIVE,
+			      "after two tries\n"));
+				mlog(MLOG_NORMAL | MLOG_DRIVE,
 				      _("assuming media is corrupt "
-				      "or contains non-xfsdump data\n") );
-				ok = set_best_blk_and_rec_sz( drivep );
-				if ( ! ok ) {
+				      "or contains non-xfsdump data\n"));
+				ok = set_best_blk_and_rec_sz(drivep);
+				if (! ok) {
 					return DRIVE_ERROR_DEVICE;
 				}
 				return DRIVE_ERROR_FOREIGN;
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
 
 	}
 
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
@@ -3400,9 +3400,9 @@ largersize:
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
@@ -3412,15 +3412,15 @@ Open( drive_t *drivep )
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
 
@@ -3428,87 +3428,87 @@ Open( drive_t *drivep )
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
@@ -3518,44 +3518,44 @@ Write( drive_t *drivep, char *bufp, size_t cnt, int *errnop )
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
 
-	if (  uuid_compare( grhdrp->gh_dumpid,
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
 
@@ -3563,48 +3563,48 @@ record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
 	 * 5.3 version of xfsdump did not set it properly.
 	 */
 #ifdef RECSZCHK
-	if ( ( size_t )rechdrp->recsize != tape_recsz ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
+	if ((size_t)rechdrp->recsize != tape_recsz) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE, _(
 		      "record %lld corrupt: incorrect record size in header\n"),
-		      contextp->dc_iocnt - 1 );
+		      contextp->dc_iocnt - 1);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 #else /* RECSZCHK */
-	mlog( (MLOG_NITTY + 1) | MLOG_NOTE | MLOG_DRIVE,
+	mlog((MLOG_NITTY + 1) | MLOG_NOTE | MLOG_DRIVE,
 	      "record %lld header record size %d (0x%x)\n",
 	      contextp->dc_iocnt - 1,
 	      rechdrp->recsize,
-	      rechdrp->recsize );
+	      rechdrp->recsize);
 #endif /* RECSZCHK */
 
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
 
@@ -3617,27 +3617,27 @@ record_hdr_validate( drive_t *drivep, char *bufp, bool_t chkoffpr )
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
 	int rval;
 
-	nread = Read( drivep, bufp, tape_recsz, &saved_errno );
+	nread = Read(drivep, bufp, tape_recsz, &saved_errno);
 
-	if ( nread == ( int )tape_recsz ) {
+	if (nread == (int)tape_recsz) {
 		contextp->dc_iocnt++;
-		rval = record_hdr_validate( drivep, bufp, BOOL_TRUE );
+		rval = record_hdr_validate(drivep, bufp, BOOL_TRUE);
 		return rval;
 	}
 
 	/* check for a blank tape/EOD.
 	 */
-	if (( nread == 0 )  /* takes care of sun */
+	if ((nread == 0)  /* takes care of sun */
 		||            /* now handle SGI */
-	    (nread < 0 && saved_errno == ENOSPC )) {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
+	    (nread < 0 && saved_errno == ENOSPC)) {
+		mlog(MLOG_NORMAL | MLOG_DRIVE,
 #ifdef DUMP
 		_("read_record encountered EOD : assuming blank media\n")
 #endif
@@ -3655,9 +3655,9 @@ read_record(  drive_t *drivep, char *bufp )
 
 	/* some other error
 	 */
-	if ( saved_errno == EIO ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
-		      _("unexpected EIO error attempting to read record\n") );
+	if (saved_errno == EIO) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+		      _("unexpected EIO error attempting to read record\n"));
 #ifdef RESTORE
 		return DRIVE_ERROR_EOM;
 #endif
@@ -3668,54 +3668,54 @@ read_record(  drive_t *drivep, char *bufp )
 
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
-	mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+	mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 	      _("unexpected error attempting to read record %lld: "
 	      "read returns %d, errno %d (%s)\n"),
 	      contextp->dc_iocnt,
 	      nread,
 	      saved_errno,
-	      strerror( saved_errno ));
+	      strerror(saved_errno));
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
@@ -3723,20 +3723,20 @@ getrec( drive_t *drivep )
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
@@ -3744,7 +3744,7 @@ getrec( drive_t *drivep )
 		contextp->dc_nextp = contextp->dc_recp
 				     +
 				     STAPE_HDR_SZ;
-		assert( contextp->dc_nextp <= contextp->dc_dataendp );
+		assert(contextp->dc_nextp <= contextp->dc_dataendp);
 	}
 
 	return 0;
@@ -3755,73 +3755,73 @@ getrec( drive_t *drivep )
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
 
-	rval = determine_write_error( nwritten, saved_errno );
+	rval = determine_write_error(nwritten, saved_errno);
 	assert(rval);
 
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
@@ -3829,11 +3829,11 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
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
@@ -3842,29 +3842,29 @@ calc_max_lost( drive_t *drivep )
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
 		bufszsfxp = _("KB");
-	} else if ( tape_recsz == STAPE_MAX_RECSZ ) {
-		assert( ! ( STAPE_MAX_RECSZ % 0x100000 ));
-		sprintf( bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000 );
-		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
+	} else if (tape_recsz == STAPE_MAX_RECSZ) {
+		assert(! (STAPE_MAX_RECSZ % 0x100000));
+		sprintf(bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000);
+		assert(strlen(bufszbuf) < sizeof(bufszbuf));
 		bufszsfxp = _("MB");
 	} else {
-		sprintf( bufszbuf, "%u", (unsigned int)(tape_recsz / 0x400) );
+		sprintf(bufszbuf, "%u", (unsigned int)(tape_recsz / 0x400));
 		bufszsfxp = _("KB");
 	}
 
-	mlog( mlog_flags, _(
+	mlog(mlog_flags, _(
 	      "I/O metrics: "
 	      "%u by %s%s %sring; "
 	      "%lld/%lld (%.0lf%%) records streamed; "
@@ -3875,13 +3875,13 @@ display_ring_metrics( drive_t *drivep, int mlog_flags )
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
 
 #ifdef CLRMTAUD
@@ -3889,24 +3889,24 @@ static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
-rewind_and_verify( drive_t *drivep )
+rewind_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	ix_t try;
 	int rval;
 
-	rval = mt_op( contextp->dc_fd, MTREW, 0 );
-	for ( try = 1 ; ; try++ ) {
-		if ( rval ) {
-			sleep( 1 );
-			rval = mt_op( contextp->dc_fd, MTREW, 0 );
+	rval = mt_op(contextp->dc_fd, MTREW, 0);
+	for (try = 1 ; ; try++) {
+		if (rval) {
+			sleep(1);
+			rval = mt_op(contextp->dc_fd, MTREW, 0);
 		} else
 			return 0;
 
-		if ( try >= MTOP_TRIES_MAX ) {
+		if (try >= MTOP_TRIES_MAX) {
 			return 0;
 		}
-		sleep( 1 );
+		sleep(1);
 	}
 	/* NOTREACHED */
 }
@@ -3916,28 +3916,28 @@ static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
-erase_and_verify( drive_t *drivep )
+erase_and_verify(drive_t *drivep)
 {
 	char *tempbufp;
 	int saved_errno;
 
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_DEBUG | MLOG_DRIVE,
-	      "rmt : erase_and_verify\n" );
+	mlog(MLOG_DEBUG | MLOG_DRIVE,
+	      "rmt : erase_and_verify\n");
 
 	/* Erase is not standard rmt. So we cannot use the line below.
 
-	( void )mt_op( contextp->dc_fd, MTERASE, 0 );
+	(void)mt_op(contextp->dc_fd, MTERASE, 0);
 
 	 * So write a record of zeros to fake erase . Poor man's erase!
 	 * We put the ERASE_MAGIC string at the beginning so we can
 	 * detect if we have erased the tape.
 	 */
 
-	tempbufp = (char *) calloc( 1 , ( size_t )tape_recsz );
-	strcpy( tempbufp, ERASE_MAGIC );
-	Write( drivep, tempbufp, tape_recsz, &saved_errno );
+	tempbufp = (char *) calloc(1 , (size_t)tape_recsz);
+	strcpy(tempbufp, ERASE_MAGIC);
+	Write(drivep, tempbufp, tape_recsz, &saved_errno);
 	free(tempbufp);
 
 	return 0;
@@ -3948,11 +3948,11 @@ static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
-bsf_and_verify( drive_t *drivep )
+bsf_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	return mt_op( contextp->dc_fd, MTBSF, 1 );
+	return mt_op(contextp->dc_fd, MTBSF, 1);
 }
 
 #ifdef CLRMTAUD
@@ -3960,21 +3960,21 @@ static uint32_t
 #else /* CLRMTAUD */
 static short
 #endif /* CLRMTAUD */
-fsf_and_verify( drive_t *drivep )
+fsf_and_verify(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	( void )mt_op( contextp->dc_fd, MTFSF, 1 );
+	(void)mt_op(contextp->dc_fd, MTFSF, 1);
 
 	return 0;
 }
 
 static bool_t
-set_best_blk_and_rec_sz( drive_t *drivep )
+set_best_blk_and_rec_sz(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	if ( contextp->dc_isQICpr == BOOL_TRUE )
+	if (contextp->dc_isQICpr == BOOL_TRUE)
 		tape_recsz = STAPE_MIN_MAX_BLKSZ;
 	else
 		tape_recsz = cmdlineblksize;
@@ -3983,13 +3983,13 @@ set_best_blk_and_rec_sz( drive_t *drivep )
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
@@ -3997,9 +3997,9 @@ isefsdump( drive_t *drivep )
 }
 
 static bool_t
-isxfsdumperasetape( drive_t *drivep )
+isxfsdumperasetape(drive_t *drivep)
 {
-	if ( !strcmp( ( char * )drivep->d_greadhdrp, ERASE_MAGIC ) )
+	if (!strcmp((char *)drivep->d_greadhdrp, ERASE_MAGIC))
 		return BOOL_TRUE;
 	else
 		return BOOL_FALSE;
-- 
2.19.1
