Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfANR0H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:07 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F1AAB83F3C
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:02 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/13] xfsdump: (4/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:19 +0100
Message-Id: <20190114172528.65250-5-jtulak@redhat.com>
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
 common/drive_simple.c  |  732 +++++++++----------
 common/exit.h          |    4 +-
 common/fs.c            |  188 ++---
 common/fs.h            |   12 +-
 common/global.c        |  206 +++---
 common/global.h        |   28 +-
 common/hsmapi.c        |   22 +-
 common/inventory.c     |  302 ++++----
 common/inventory.h     |   36 +-
 common/lock.c          |   14 +-
 common/lock.h          |    6 +-
 common/main.c          | 1578 ++++++++++++++++++++--------------------
 common/media.c         |  126 ++--
 common/media.h         |   20 +-
 common/media_rmvtape.h |    6 +-
 15 files changed, 1640 insertions(+), 1640 deletions(-)

diff --git a/common/drive_simple.c b/common/drive_simple.c
index 54a3058..2d802d3 100644
--- a/common/drive_simple.c
+++ b/common/drive_simple.c
@@ -55,12 +55,12 @@
 #define read    rmtread
 #define write   rmtwrite
 
-extern int rmtclose( int );
+extern int rmtclose(int);
 extern int rmtcreat (char *path, int mode);
-extern int rmtioctl( int, int, ... );
-extern int rmtopen( char *, int, ... );
-extern int rmtread( int, void*, uint);
-extern int rmtwrite( int, const void *, uint);
+extern int rmtioctl(int, int, ...);
+extern int rmtopen(char *, int, ...);
+extern int rmtread(int, void*, uint);
+extern int rmtwrite(int, const void *, uint);
 
 
 /* drive_simple.c - drive strategy for standard in or a file
@@ -73,14 +73,14 @@ extern int rmtwrite( int, const void *, uint);
  * buf must be page-aligned and at least 1 page in size
  */
 #define PGPERBUF	64	/* private read buffer */
-#define BUFSZ		( PGPERBUF * PGSZ )
+#define BUFSZ		(PGPERBUF * PGSZ)
 
 /* operational mode
  */
 typedef enum { OM_NONE, OM_READ, OM_WRITE } om_t;
 
 struct drive_context {
-	char dc_buf[ BUFSZ ];	/* input/output buffer */
+	char dc_buf[BUFSZ];	/* input/output buffer */
 	om_t dc_mode;		/* current mode of operation */
 	ix_t dc_fmarkcnt;	/* how many file marks to the left */
 	char *dc_ownedp;	/* first byte owned by caller */
@@ -108,31 +108,31 @@ extern size_t pgsz;
 
 /* strategy functions
  */
-static int ds_match( int, char *[], drive_t * );
-static int ds_instantiate( int, char *[], drive_t * );
+static int ds_match(int, char *[], drive_t *);
+static int ds_instantiate(int, char *[], drive_t *);
 
 /* declare manager operators
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
-static int do_rewind( drive_t * );
-static int do_erase( drive_t * );
-static int do_get_device_class( drive_t * );
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
+static int do_rewind(drive_t *);
+static int do_erase(drive_t *);
+static int do_get_device_class(drive_t *);
+static void do_quit(drive_t *);
 
 
 /* definition of locally defined global variables ****************************/
@@ -188,39 +188,39 @@ static drive_ops_t drive_ops = {
  */
 /* ARGSUSED */
 static int
-ds_match( int argc, char *argv[], drive_t *drivep )
+ds_match(int argc, char *argv[], drive_t *drivep)
 {
 	bool_t isrmtpr;
 	struct stat64 statbuf;
 
 	/* sanity checks
 	 */
-	assert( ! ( sizeofmember( drive_context_t, dc_buf ) % PGSZ ));
+	assert(! (sizeofmember(drive_context_t, dc_buf) % PGSZ));
 
 	/* determine if this is an rmt file. if so, give a weak match:
 	 * might be an ordinary file accessed via the rmt protocol.
 	 */
-	if ( strchr( drivep->d_pathname, ':') ) {
+	if (strchr(drivep->d_pathname, ':')) {
 		isrmtpr = BOOL_TRUE;
 	} else {
 		isrmtpr = BOOL_FALSE;
 	}
-	if ( isrmtpr ) {
+	if (isrmtpr) {
 		return 1;
 	}
 
 	/* willing to pick up anything not picked up by other strategies,
 	 * as long as it exists and is not a directory
 	 */
-	if ( ! strcmp( drivep->d_pathname, "stdio" )) {
+	if (! strcmp(drivep->d_pathname, "stdio")) {
 		return 1;
 	}
 
-	if ( stat64( drivep->d_pathname, &statbuf )) {
+	if (stat64(drivep->d_pathname, &statbuf)) {
 		return -1;
 	}
 
-	if ( S_ISDIR( statbuf.st_mode )) {
+	if (S_ISDIR(statbuf.st_mode)) {
 		return -1;
 	}
 
@@ -231,7 +231,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
  */
 /*ARGSUSED*/
 static bool_t
-ds_instantiate( int argc, char *argv[], drive_t *drivep )
+ds_instantiate(int argc, char *argv[], drive_t *drivep)
 {
 	drive_context_t *contextp;
 
@@ -242,15 +242,15 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	/* initialize the drive context - allocate a page-aligned
 	 * structure, so the buffer is page-aligned.
 	 */
-	contextp = ( drive_context_t * )memalign( PGSZ,
-						  sizeof( drive_context_t ));
-	assert( contextp );
-	assert( ( void * )contextp->dc_buf == ( void * )contextp );
-	memset( ( void * )contextp, 0, sizeof( *contextp ));
+	contextp = (drive_context_t *)memalign(PGSZ,
+						  sizeof(drive_context_t));
+	assert(contextp);
+	assert((void *)contextp->dc_buf == (void *)contextp);
+	memset((void *)contextp, 0, sizeof(*contextp));
 
 	/* scan drive device pathname to see if remote tape
 	 */
-	if ( strchr( drivep->d_pathname, ':') ) {
+	if (strchr(drivep->d_pathname, ':')) {
 		contextp->dc_isrmtpr = BOOL_TRUE;
 	} else {
 		contextp->dc_isrmtpr = BOOL_FALSE;
@@ -260,7 +260,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	 */
 	drivep->d_capabilities = 0;
 	drivep->d_capabilities |= DRIVE_CAP_AUTOREWIND;
-	if ( ! strcmp( drivep->d_pathname, "stdio" )) {
+	if (! strcmp(drivep->d_pathname, "stdio")) {
 #ifdef DUMP
 		contextp->dc_fd = 1;
 #endif /* DUMP */
@@ -268,7 +268,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 		drivep->d_capabilities |= DRIVE_CAP_READ;
 		contextp->dc_fd = 0;
 #endif /* RESTORE */
-	} else if ( contextp->dc_isrmtpr ) {
+	} else if (contextp->dc_isrmtpr) {
 		int oflags;
 #ifdef DUMP
 		oflags = O_WRONLY | O_CREAT | O_TRUNC;
@@ -278,28 +278,28 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 		drivep->d_capabilities |= DRIVE_CAP_READ;
 #endif /* RESTORE */
 		contextp->dc_rampr = BOOL_FALSE;
-		contextp->dc_fd = open( drivep->d_pathname,
+		contextp->dc_fd = open(drivep->d_pathname,
 					oflags,
-				        S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH );
-		if ( contextp->dc_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				        S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+		if (contextp->dc_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 			      _("unable to open %s: %s\n"),
 			      drivep->d_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 	} else {
 		int oflags = 0;
 		struct stat statbuf;
 		int rval;
-		rval = stat( drivep->d_pathname, &statbuf );
+		rval = stat(drivep->d_pathname, &statbuf);
 #ifdef DUMP
-		if ( rval ) {
-			if ( errno != ENOENT ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+		if (rval) {
+			if (errno != ENOENT) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("stat of %s failed: %s\n"),
 				      drivep->d_pathname,
-				      strerror( errno ));
+				      strerror(errno));
 				return BOOL_FALSE;
 			}
 			drivep->d_capabilities |= DRIVE_CAP_REWIND;
@@ -309,7 +309,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 			oflags = O_RDWR | O_CREAT;
 
 		} else {
-			switch( statbuf.st_mode & S_IFMT ) {
+			switch(statbuf.st_mode & S_IFMT) {
 			case S_IFREG:
 				drivep->d_capabilities |= DRIVE_CAP_ERASE;
 				drivep->d_capabilities |= DRIVE_CAP_REWIND;
@@ -326,26 +326,26 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 				oflags = O_WRONLY;
 				break;
 			default:
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("cannot dump to %s "
 				      "file type %x\n"),
 				      drivep->d_pathname,
-				      statbuf.st_mode & S_IFMT );
+				      statbuf.st_mode & S_IFMT);
 				return BOOL_FALSE;
 			}
 		}
 #endif /* DUMP */
 #ifdef RESTORE
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 			      _("stat of %s failed: %s\n"),
 			      drivep->d_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 
 		}
 		oflags = O_RDONLY;
-		switch( statbuf.st_mode & S_IFMT ) {
+		switch(statbuf.st_mode & S_IFMT) {
 		case S_IFREG:
 		case S_IFCHR:
 		case S_IFBLK:
@@ -356,21 +356,21 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 			drivep->d_capabilities |= DRIVE_CAP_READ;
 			break;
 		default:
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 			      _("cannot restore from %s file type %x\n"),
 			      drivep->d_pathname,
-			      statbuf.st_mode & S_IFMT );
+			      statbuf.st_mode & S_IFMT);
 			return BOOL_FALSE;
 		}
 #endif /* RESTORE */
-		contextp->dc_fd = open( drivep->d_pathname,
+		contextp->dc_fd = open(drivep->d_pathname,
 					oflags,
-				        S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH );
-		if ( contextp->dc_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+				        S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
+		if (contextp->dc_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 			      _("unable to open %s: %s\n"),
 			      drivep->d_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 	}
@@ -381,7 +381,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
 	contextp->dc_mode = OM_NONE;
 	contextp->dc_fmarkcnt = 0;
 
-	drivep->d_contextp = ( void * )contextp;
+	drivep->d_contextp = (void *)contextp;
 
 	drivep->d_cap_est = -1;
 	drivep->d_rate_est = -1;
@@ -394,11 +394,11 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
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
 
 #ifdef DUMP
@@ -415,7 +415,7 @@ do_init( drive_t *drivep )
  */
 /* ARGSUSED */
 static bool_t
-do_sync( drive_t *drivep )
+do_sync(drive_t *drivep)
 {
 	return BOOL_TRUE;
 }
@@ -424,14 +424,14 @@ do_sync( drive_t *drivep )
  * read the media hdr
  */
 static int
-do_begin_read( drive_t *drivep )
+do_begin_read(drive_t *drivep)
 {
 #ifdef DEBUG
 	int dcaps = drivep->d_capabilities;
 #endif
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_hdr_t *drhdrp = drivep->d_readhdrp;
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int nread;
 	int rval;
 	global_hdr_t		*tmphdr = (global_hdr_t	*)malloc(GLOBAL_HDR_SZ);
@@ -444,25 +444,25 @@ do_begin_read( drive_t *drivep )
 	content_hdr_t		*ch = (content_hdr_t *)mh->mh_upper;
 	content_inode_hdr_t	*cih = (content_inode_hdr_t *)ch->ch_specific;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple begin_read( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple begin_read( )\n");
 
 	/* verify protocol being followed
 	 */
-	assert( dcaps & DRIVE_CAP_READ );
-	assert( contextp->dc_fd >= 0 );
-	assert( contextp->dc_mode == OM_NONE );
+	assert(dcaps & DRIVE_CAP_READ);
+	assert(contextp->dc_fd >= 0);
+	assert(contextp->dc_mode == OM_NONE);
 
 	/* can only read one media file
 	 */
-	if ( contextp->dc_fmarkcnt > 0 ) {
+	if (contextp->dc_fmarkcnt > 0) {
 		return DRIVE_ERROR_EOM;
 	}
 
 	/* prepare the drive context
 	 */
 	contextp->dc_ownedp = 0;
-	contextp->dc_emptyp = &contextp->dc_buf[ 0 ];
+	contextp->dc_emptyp = &contextp->dc_buf[0];
 	contextp->dc_nextp = contextp->dc_emptyp;
 	contextp->dc_bufstroff = 0;
 
@@ -471,18 +471,18 @@ do_begin_read( drive_t *drivep )
 	 */
 	contextp->dc_mode = OM_READ;
 
-	nread = read_buf( ( char * )tmphdr,
+	nread = read_buf((char *)tmphdr,
 			  GLOBAL_HDR_SZ,
-			  ( void * )drivep,
-			  ( rfp_t )drivep->d_opsp->do_read,
-			  ( rrbfp_t )drivep->d_opsp->do_return_read_buf,
-			  &rval );
+			  (void *)drivep,
+			  (rfp_t)drivep->d_opsp->do_read,
+			  (rrbfp_t)drivep->d_opsp->do_return_read_buf,
+			  &rval);
 	contextp->dc_mode = OM_NONE;
 
 	/* if EOD and nread is zero, there is no data after the file mark
 	 */
-	if ( rval == DRIVE_ERROR_EOD ) {
-		if ( nread == 0 ) {
+	if (rval == DRIVE_ERROR_EOD) {
+		if (nread == 0) {
 			free(tmphdr);
 			return DRIVE_ERROR_BLANK;
 		} else {
@@ -490,11 +490,11 @@ do_begin_read( drive_t *drivep )
 			return DRIVE_ERROR_FORMAT;
 		}
 	}
-	if  ( rval ) {
+	if  (rval) {
 		free(tmphdr);
 		return rval;
 	}
-	assert( ( size_t )nread == GLOBAL_HDR_SZ );
+	assert((size_t)nread == GLOBAL_HDR_SZ);
 
 	mlog(MLOG_NITTY, "do_begin_read: global_hdr\n"
 	     "\tgh_magic %.100s\n"
@@ -514,17 +514,17 @@ do_begin_read( drive_t *drivep )
 
 	/* check the checksum
 	 */
-	if ( ! global_hdr_checksum_check( tmphdr )) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
-		      _("media file header checksum error\n") );
+	if (! global_hdr_checksum_check(tmphdr)) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+		      _("media file header checksum error\n"));
 		free(tmphdr);
 		return DRIVE_ERROR_CORRUPTION;
 	}
 
 	xlate_global_hdr(tmphdr, grhdrp, 1);
 	xlate_drive_hdr(tmpdh, dh, 1);
-	*(( drive_mark_t * )dh->dh_specific) =
-		INT_GET(*(( drive_mark_t * )tmpdh->dh_specific), ARCH_CONVERT);
+	*((drive_mark_t *)dh->dh_specific) =
+		INT_GET(*((drive_mark_t *)tmpdh->dh_specific), ARCH_CONVERT);
 	xlate_media_hdr(tmpmh, mh, 1);
 	xlate_content_hdr(tmpch, ch, 1);
 	xlate_content_inode_hdr(tmpcih, cih, 1);
@@ -532,8 +532,8 @@ do_begin_read( drive_t *drivep )
 
 	/* check the magic number
 	 */
-	if ( strncmp( grhdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ)) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+	if (strncmp(grhdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ)) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 		      _("media file header magic number mismatch: %s, %s\n"),
 		      grhdrp->gh_magic,
 		      GLOBAL_HDR_MAGIC);
@@ -542,32 +542,32 @@ do_begin_read( drive_t *drivep )
 
 	/* check the version
 	 */
-	if ( global_version_check( grhdrp->gh_version ) != BOOL_TRUE ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+	if (global_version_check(grhdrp->gh_version) != BOOL_TRUE) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 		      _("unrecognized media file header version (%d)\n"),
-		      grhdrp->gh_version );
+		      grhdrp->gh_version);
 		return DRIVE_ERROR_VERSION;
 	}
 
 	/* check the strategy id
 	 */
-	if ( drhdrp->dh_strategyid != drive_strategy_simple.ds_id ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+	if (drhdrp->dh_strategyid != drive_strategy_simple.ds_id) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 		      _("unrecognized drive strategy ID "
 		      "(media says %d, expected %d)\n"),
-		      drhdrp->dh_strategyid, drive_strategy_simple.ds_id );
+		      drhdrp->dh_strategyid, drive_strategy_simple.ds_id);
 		return DRIVE_ERROR_FORMAT;
 	}
 
 	/* record the offset of the first mark
 	 */
-	contextp->dc_firstmark = *( drive_mark_t * )drhdrp->dh_specific;
+	contextp->dc_firstmark = *(drive_mark_t *)drhdrp->dh_specific;
 
 	/* adjust the drive capabilities based on presence of first mark.
 	 * this is a hack workaround for a bug in xfsdump which causes the
 	 * first mark offset to not always be placed in the hdr.
 	 */
-	if ( contextp->dc_firstmark ) {
+	if (contextp->dc_firstmark) {
 		drivep->d_capabilities |= DRIVE_CAP_NEXTMARK;
 	}
 
@@ -580,24 +580,24 @@ do_begin_read( drive_t *drivep )
 /* read - supply the caller with some filled buffer
  */
 static char *
-do_read( drive_t *drivep,
+do_read(drive_t *drivep,
          size_t wantedcnt,
          size_t *actualcntp,
-         int *rvalp )
+         int *rvalp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	size_t remainingcnt;
 	size_t actualcnt;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple read( want %u )\n",
-	      wantedcnt );
+	      wantedcnt);
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
-	assert( wantedcnt > 0 );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
+	assert(wantedcnt > 0);
 
 	/* pre-initialize reference return
 	 */
@@ -605,12 +605,12 @@ do_read( drive_t *drivep,
 
 	/* count number of unread bytes in buffer
 	 */
-	assert( contextp->dc_emptyp >= contextp->dc_nextp );
-	remainingcnt = ( size_t )( contextp->dc_emptyp - contextp->dc_nextp );
+	assert(contextp->dc_emptyp >= contextp->dc_nextp);
+	remainingcnt = (size_t)(contextp->dc_emptyp - contextp->dc_nextp);
 
 	/* if no unread bytes in buffer, refill
 	 */
-	if ( remainingcnt == 0 ) {
+	if (remainingcnt == 0) {
 		size_t bufhowfullcnt;
 		int nread;
 
@@ -619,13 +619,13 @@ do_read( drive_t *drivep,
 		 * beginning of the media file) of the top of the buffer
 		 * after we refill the buffer.
 		 */
-		bufhowfullcnt = ( size_t )
-				( contextp->dc_emptyp - contextp->dc_buf );
+		bufhowfullcnt = (size_t)
+				(contextp->dc_emptyp - contextp->dc_buf);
 
 		/* attempt to fill the buffer. nread may be less if at EOF
 		 */
-		nread = read( contextp->dc_fd, contextp->dc_buf, BUFSZ );
-		if ( nread < 0 ) {
+		nread = read(contextp->dc_fd, contextp->dc_buf, BUFSZ);
+		if (nread < 0) {
 			*rvalp = DRIVE_ERROR_DEVICE;
 			return 0;
 		}
@@ -633,31 +633,31 @@ do_read( drive_t *drivep,
 		/* adjust the recorded offset of the top of the buffer
 		 * relative to the beginning of the media file
 		 */
-		contextp->dc_bufstroff += ( off64_t )bufhowfullcnt;
+		contextp->dc_bufstroff += (off64_t)bufhowfullcnt;
 
 		/* record the ptrs to the first empty byte and the next
 		 * byte to be read
 		 */
-		assert( nread <= BUFSZ );
+		assert(nread <= BUFSZ);
 		contextp->dc_emptyp = contextp->dc_buf + nread;
 		contextp->dc_nextp = contextp->dc_buf;
 
 		/* if no bytes were read, the caller has seen all bytes.
 		 */
-		if ( nread == 0 ) {
+		if (nread == 0) {
 			*rvalp = DRIVE_ERROR_EOD;
 			return 0;
 		}
 
 		/* adjust the remaining count
 		 */
-		remainingcnt = ( size_t )nread;
+		remainingcnt = (size_t)nread;
 	}
 
 	/* the caller specified at most how many bytes he wants. if less
 	 * than that remain unread in buffer, just return that many.
 	 */
-	actualcnt = min( wantedcnt, remainingcnt );
+	actualcnt = min(wantedcnt, remainingcnt);
 
 	/* set the owned ptr to the first byte to be supplied
 	 */
@@ -666,7 +666,7 @@ do_read( drive_t *drivep,
 	/* advance the next ptr to the next byte to be supplied
 	 */
 	contextp->dc_nextp += actualcnt;
-	assert( contextp->dc_nextp <= contextp->dc_emptyp );
+	assert(contextp->dc_nextp <= contextp->dc_emptyp);
 
 	/* return the actual number of bytes supplied, and a ptr to the first
 	 */
@@ -679,29 +679,29 @@ do_read( drive_t *drivep,
  */
 /* ARGSUSED */
 static void
-do_return_read_buf( drive_t *drivep, char *retp, size_t retcnt )
+do_return_read_buf(drive_t *drivep, char *retp, size_t retcnt)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	/* REFERENCED */
 	size_t ownedcnt;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple return_read_buf( returning %u )\n",
-	      retcnt );
+	      retcnt);
 
 	/* verify protocol
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(contextp->dc_ownedp);
 
 	/* verify returning right buffer
 	 */
-	assert( retp == contextp->dc_ownedp );
+	assert(retp == contextp->dc_ownedp);
 
 	/* verify all of buffer provided is being returned
 	 */
-	ownedcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
-	assert( retcnt == ownedcnt );
+	ownedcnt = (size_t)(contextp->dc_nextp - contextp->dc_ownedp);
+	assert(retcnt == ownedcnt);
 
 	/* indicate nothing now owned by caller
 	 */
@@ -712,37 +712,37 @@ do_return_read_buf( drive_t *drivep, char *retp, size_t retcnt )
  * next byte to be read
  */
 static void
-do_get_mark( drive_t *drivep, drive_mark_t *markp )
+do_get_mark(drive_t *drivep, drive_mark_t *markp)
 {
-        drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+        drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t nextoff;
 	off64_t strmoff;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple get_mark( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple get_mark( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
 
 	/* calculate the offset of the next byte to be supplied relative to
 	 * the beginning of the buffer and relative to the beginning of
 	 * ther media file.
 	 */
-	nextoff = ( off64_t )( contextp->dc_nextp - contextp->dc_buf );
+	nextoff = (off64_t)(contextp->dc_nextp - contextp->dc_buf);
 	strmoff = contextp->dc_bufstroff + nextoff;
-	*markp = ( drive_mark_t )strmoff;
+	*markp = (drive_mark_t)strmoff;
 }
 
 /* seek forward to the specified mark. the caller must not have already read
  * past that point.
  */
 static int
-do_seek_mark( drive_t *drivep, drive_mark_t *markp )
+do_seek_mark(drive_t *drivep, drive_mark_t *markp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
-	off64_t mark = *( off64_t * )markp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
+	off64_t mark = *(off64_t *)markp;
 	off64_t nextoff;
 	off64_t strmoff;
 	/* REFERENCED */
@@ -751,40 +751,40 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 	int nreadneeded;
 	int rval;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple seek_mark( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple seek_mark( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
 
 	/* calculate the current offset within the media file
 	 * of the next byte to be read
 	 */
-	nextoff = ( off64_t )( contextp->dc_nextp - contextp->dc_buf );
+	nextoff = (off64_t)(contextp->dc_nextp - contextp->dc_buf);
 	strmoff = contextp->dc_bufstroff + nextoff;
 
 	/* if the caller attempts to seek past the current offset,
 	 * this is really bad
 	 */
-	if ( strmoff > mark ) {
+	if (strmoff > mark) {
 		return DRIVE_ERROR_CORE;
 	}
 
 	/* use read_buf util func to eat up difference
 	 */
 	nreadneeded64 = mark - strmoff;
-	while ( nreadneeded64 > 0 ) {
-		if ( nreadneeded64 > INTGENMAX )
+	while (nreadneeded64 > 0) {
+		if (nreadneeded64 > INTGENMAX)
 			nreadneeded = INTGENMAX;
 		else
-			nreadneeded = ( int )nreadneeded64;
-		nread = read_buf( 0, nreadneeded, drivep,
-				  ( rfp_t )drivep->d_opsp->do_read,
-				( rrbfp_t )drivep->d_opsp->do_return_read_buf,
-				  &rval );
-		if  ( rval ) {
+			nreadneeded = (int)nreadneeded64;
+		nread = read_buf(0, nreadneeded, drivep,
+				  (rfp_t)drivep->d_opsp->do_read,
+				(rrbfp_t)drivep->d_opsp->do_return_read_buf,
+				  &rval);
+		if  (rval) {
 			return rval;
 		}
 		nreadneeded64 -= nread;
@@ -792,9 +792,9 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
 
 	/* verify we are on the mark
 	 */
-	nextoff = ( off64_t )( contextp->dc_nextp - contextp->dc_buf );
+	nextoff = (off64_t)(contextp->dc_nextp - contextp->dc_buf);
 	strmoff = contextp->dc_bufstroff + nextoff;
-	assert( strmoff == mark );
+	assert(strmoff == mark);
 
 	return 0;
 }
@@ -804,30 +804,30 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
  * has already read past that mark, blow up.
  */
 static int
-do_next_mark( drive_t *drivep )
+do_next_mark(drive_t *drivep)
 {
 #ifdef DEBUG
 	int dcaps = drivep->d_capabilities;
 #endif
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	drive_mark_t mark = contextp->dc_firstmark;
 	int rval;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple next_mark( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple next_mark( )\n");
 
 	/* assert protocol
 	 */
-	assert( dcaps & DRIVE_CAP_NEXTMARK );
-	assert( contextp->dc_mode == OM_READ );
-	assert( ! contextp->dc_ownedp );
+	assert(dcaps & DRIVE_CAP_NEXTMARK);
+	assert(contextp->dc_mode == OM_READ);
+	assert(! contextp->dc_ownedp);
 
-	if ( ! mark ) {
+	if (! mark) {
 		return DRIVE_ERROR_EOF;
 	}
 
-	rval = do_seek_mark( drivep, ( drive_mark_t * )&mark );
-	if ( rval ) {
+	rval = do_seek_mark(drivep, (drive_mark_t *)&mark);
+	if (rval) {
 		return rval;
 	}
 
@@ -838,33 +838,33 @@ do_next_mark( drive_t *drivep )
  * just discards any buffered data
  */
 void
-do_end_read( drive_t *drivep )
+do_end_read(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple end_read( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple end_read( )\n");
 
 	/* be sure we are following protocol
 	 */
-	assert( contextp->dc_mode == OM_READ );
+	assert(contextp->dc_mode == OM_READ);
 	contextp->dc_mode = OM_NONE;
 
 	/* bump the file mark cnt
 	 */
 	contextp->dc_fmarkcnt++;
-	assert( contextp->dc_fmarkcnt == 1 );
+	assert(contextp->dc_fmarkcnt == 1);
 }
 
 /* begin_write - prepare file for writing
  */
 static int
-do_begin_write( drive_t *drivep )
+do_begin_write(drive_t *drivep)
 {
 	int dcaps = drivep->d_capabilities;
 	global_hdr_t *gwhdrp = drivep->d_gwritehdrp;
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	int rval;
 	global_hdr_t		*tmphdr;
 	drive_hdr_t		*tmpdh;
@@ -876,27 +876,27 @@ do_begin_write( drive_t *drivep )
 	content_hdr_t		*ch = (content_hdr_t *)mh->mh_upper;
 	content_inode_hdr_t	*cih = (content_inode_hdr_t *)ch->ch_specific;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple begin_write( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple begin_write( )\n");
 
 	/* sanity checks
 	 */
-	assert( dwhdrp->dh_strategyid == DRIVE_STRATEGY_SIMPLE );
+	assert(dwhdrp->dh_strategyid == DRIVE_STRATEGY_SIMPLE);
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_fd >= 0 );
-	assert( contextp->dc_mode == OM_NONE );
+	assert(contextp->dc_fd >= 0);
+	assert(contextp->dc_mode == OM_NONE);
 
 	/* only one media file may be written
 	 */
-	if ( contextp->dc_fmarkcnt > 0 ) {
+	if (contextp->dc_fmarkcnt > 0) {
 		return DRIVE_ERROR_EOM;
 	}
 
 	/* indicate in the header that there is no recorded mark.
 	 */
-	*( ( off64_t * )dwhdrp->dh_specific ) = 0;
+	*((off64_t *)dwhdrp->dh_specific) = 0;
 
 	/* prepare the drive context. initially the caller does not own
 	 * any of the write buffer, so the next portion of the buffer to
@@ -906,20 +906,20 @@ do_begin_write( drive_t *drivep )
 	 */
 	contextp->dc_ownedp = 0;
 	contextp->dc_nextp = contextp->dc_buf;
-	contextp->dc_emptyp = contextp->dc_buf + sizeof( contextp->dc_buf );
+	contextp->dc_emptyp = contextp->dc_buf + sizeof(contextp->dc_buf);
 	contextp->dc_bufstroff = 0;
 	contextp->dc_markcnt = 0;
 
 	/* truncate the destination if it supports read.
 	 */
-	if ( dcaps & DRIVE_CAP_READ ) {
-		rval = ftruncate( contextp->dc_fd, 0 );
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	if (dcaps & DRIVE_CAP_READ) {
+		rval = ftruncate(contextp->dc_fd, 0);
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 			      _("attempt to truncate %s failed: %d (%s)\n"),
 			      drivep->d_pathname,
 			      errno,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 	}
 
@@ -937,16 +937,16 @@ do_begin_write( drive_t *drivep )
 
 	xlate_global_hdr(gwhdrp, tmphdr, 1);
 	xlate_drive_hdr(dh, tmpdh, 1);
-	INT_SET(*(( drive_mark_t * )tmpdh->dh_specific),
+	INT_SET(*((drive_mark_t *)tmpdh->dh_specific),
 		ARCH_CONVERT,
-		*(( drive_mark_t * )dh->dh_specific));
+		*((drive_mark_t *)dh->dh_specific));
 	xlate_media_hdr(mh, tmpmh, 1);
 	xlate_content_hdr(ch, tmpch, 1);
 	xlate_content_inode_hdr(cih, tmpcih, 1);
 
 	/* checksum the header
 	 */
-	global_hdr_checksum_set( tmphdr );
+	global_hdr_checksum_set(tmphdr);
 
 	mlog(MLOG_NITTY, "do_begin_write: global_hdr\n"
 	     "\tgh_magic %.100s\n"
@@ -964,28 +964,28 @@ do_begin_write( drive_t *drivep )
 	     tmphdr->gh_hostname,
 	     tmphdr->gh_dumplabel);
 
-	if ( ! global_hdr_checksum_check( tmphdr )) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
-		      _("media file header checksum error\n") );
+	if (! global_hdr_checksum_check(tmphdr)) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
+		      _("media file header checksum error\n"));
 	}
 	else {
-		mlog( MLOG_NITTY, "media file header checksum OK!\n" );
+		mlog(MLOG_NITTY, "media file header checksum OK!\n");
 	}
 
 	/* write the header using the write_buf() utility function and
 	 * my own get_write_buf and write operators.
 	 */
-	rval = write_buf( ( char * )tmphdr,
+	rval = write_buf((char *)tmphdr,
 			  GLOBAL_HDR_SZ,
-			  ( void * )drivep,
-			  ( gwbfp_t )drivep->d_opsp->do_get_write_buf,
-			  ( wfp_t )drivep->d_opsp->do_write );
+			  (void *)drivep,
+			  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+			  (wfp_t)drivep->d_opsp->do_write);
 
 	free(tmphdr);
 
 	/* if error while writing hdr, undo mode
 	 */
-	if ( rval ) {
+	if (rval) {
 		contextp->dc_mode = OM_NONE;
 	}
 
@@ -995,28 +995,28 @@ do_begin_write( drive_t *drivep )
 /* do_set_mark - record a markrecord and callback
  */
 static void
-do_set_mark( drive_t *drivep,
+do_set_mark(drive_t *drivep,
 	     drive_mcbfp_t cbfuncp,
 	     void *cbcontextp,
-	     drive_markrec_t *markrecp )
+	     drive_markrec_t *markrecp)
 {
-	drive_context_t		*contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t		*contextp = (drive_context_t *)drivep->d_contextp;
 	drive_mark_t		mark;
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple set_mark( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple set_mark( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_nextp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_nextp);
 
 	/* calculate the mark offset
 	 */
-	mark = ( drive_mark_t )( contextp->dc_bufstroff
+	mark = (drive_mark_t)(contextp->dc_bufstroff
 				 +
-				 ( off64_t )
-				 ( contextp->dc_nextp - contextp->dc_buf ));
+				 (off64_t)
+				 (contextp->dc_nextp - contextp->dc_buf));
 
 	/* fill in the mark field of the mark record
 	 */
@@ -1034,27 +1034,27 @@ do_set_mark( drive_t *drivep,
 	 * buffer has not yet been flushed, we can just edit the buffer.
 	 */
 	contextp->dc_markcnt++;
-	if ( contextp->dc_markcnt == 1 ) {
-		if ( contextp->dc_bufstroff == 0 ) {
+	if (contextp->dc_markcnt == 1) {
+		if (contextp->dc_bufstroff == 0) {
 			/* cast the write buffer into a media file hdr
 			 */
 			global_hdr_t		*gwhdrp  =
-				( global_hdr_t * )contextp->dc_buf;
-			drive_hdr_t		*dwhdrp = ( drive_hdr_t * )gwhdrp->gh_upper;
+				(global_hdr_t *)contextp->dc_buf;
+			drive_hdr_t		*dwhdrp = (drive_hdr_t *)gwhdrp->gh_upper;
 
-			mlog( MLOG_NITTY | MLOG_DRIVE,
+			mlog(MLOG_NITTY | MLOG_DRIVE,
 			     "re-writing media file header with first mark "
-			     "(in buffer)\n" );
+			     "(in buffer)\n");
 
 			/* record mark in hdr
 			 */
-			INT_SET(*( ( drive_mark_t * )dwhdrp->dh_specific ), ARCH_CONVERT, mark);
+			INT_SET(*((drive_mark_t *)dwhdrp->dh_specific), ARCH_CONVERT, mark);
 
 			/* adjust header checksum
 			 */
-			global_hdr_checksum_set( gwhdrp );
+			global_hdr_checksum_set(gwhdrp);
 
-		} else if ( contextp->dc_rampr ) {
+		} else if (contextp->dc_rampr) {
 			global_hdr_t		*gwhdrp = drivep->d_gwritehdrp;
 			drive_hdr_t		*dwhdrp = drivep->d_writehdrp;
 			off64_t			newoff;
@@ -1063,24 +1063,24 @@ do_set_mark( drive_t *drivep,
 
 			/* assert the header has been flushed
 			 */
-			assert( contextp->dc_bufstroff >= sizeof( *gwhdrp ));
+			assert(contextp->dc_bufstroff >= sizeof(*gwhdrp));
 
 			/* record mark in hdr
 			 */
-			INT_SET(*( ( drive_mark_t * )dwhdrp->dh_specific ), ARCH_CONVERT, mark);
+			INT_SET(*((drive_mark_t *)dwhdrp->dh_specific), ARCH_CONVERT, mark);
 
 			/* adjust header checksum
 			 */
-			global_hdr_checksum_set( gwhdrp );
+			global_hdr_checksum_set(gwhdrp);
 
 			/* seek to beginning
 			 */
-			newoff = lseek64( contextp->dc_fd, ( off64_t )0, SEEK_SET );
-			if ( newoff < 0 ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+			newoff = lseek64(contextp->dc_fd, (off64_t)0, SEEK_SET);
+			if (newoff < 0) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("could not save first mark: %d (%s)\n"),
 				      errno,
-				      strerror( errno ));
+				      strerror(errno));
 			} else {
 				global_hdr_t		*tmphdr;
 				drive_hdr_t		*tmpdh;
@@ -1092,14 +1092,14 @@ do_set_mark( drive_t *drivep,
 				content_hdr_t		*ch = (content_hdr_t *)mh->mh_upper;
 				content_inode_hdr_t	*cih = (content_inode_hdr_t *)ch->ch_specific;
 
-				assert( newoff == 0 );
+				assert(newoff == 0);
 
 				/* write and seek back to current offset
 				 */
-				mlog( MLOG_NITTY | MLOG_DRIVE,
+				mlog(MLOG_NITTY | MLOG_DRIVE,
 				     "re-writing media file header "
 				     "with first mark "
-				     "(on media)\n" );
+				     "(on media)\n");
 
 				tmphdr = (global_hdr_t *)malloc(GLOBAL_HDR_SZ);
 				assert(tmphdr);
@@ -1109,16 +1109,16 @@ do_set_mark( drive_t *drivep,
 				tmpcih = (content_inode_hdr_t *)tmpch->ch_specific;
 				xlate_global_hdr(gwhdrp, tmphdr, 1);
 				xlate_drive_hdr(dh, tmpdh, 1);
-				INT_SET(*(( drive_mark_t * )tmpdh->dh_specific),
+				INT_SET(*((drive_mark_t *)tmpdh->dh_specific),
 					ARCH_CONVERT,
-					*(( drive_mark_t * )dh->dh_specific));
+					*((drive_mark_t *)dh->dh_specific));
 				xlate_media_hdr(mh, tmpmh, 1);
 				xlate_content_hdr(ch, tmpch, 1);
 				xlate_content_inode_hdr(cih, tmpcih, 1);
 
 				/* adjust header checksum
 				 */
-				global_hdr_checksum_set( tmphdr );
+				global_hdr_checksum_set(tmphdr);
 
 				mlog(MLOG_NITTY, "do_set_mark: global_hdr\n"
 				     "\tgh_magic %.100s\n"
@@ -1136,16 +1136,16 @@ do_set_mark( drive_t *drivep,
 				     tmphdr->gh_hostname,
 				     tmphdr->gh_dumplabel);
 
-				nwritten = write( contextp->dc_fd,
+				nwritten = write(contextp->dc_fd,
 						  tmphdr,
-						  sizeof( *tmphdr ));
-				assert( ( size_t )nwritten == sizeof( *tmphdr ));
+						  sizeof(*tmphdr));
+				assert((size_t)nwritten == sizeof(*tmphdr));
 				free(tmphdr);
 
-				newoff = lseek64( contextp->dc_fd,
+				newoff = lseek64(contextp->dc_fd,
 						  contextp->dc_bufstroff,
-						  SEEK_SET );
-				assert( newoff == contextp->dc_bufstroff );
+						  SEEK_SET);
+				assert(newoff == contextp->dc_bufstroff);
 			}
 		}
 	}
@@ -1153,19 +1153,19 @@ do_set_mark( drive_t *drivep,
 	/* if all written are committed, send the mark back immediately.
 	 * otherwise put the mark record on the tail of the queue.
 	 */
-	if ( contextp->dc_nextp == contextp->dc_buf ) {
-		assert( drivep->d_markrecheadp == 0 );
-		( * cbfuncp )( cbcontextp, markrecp, BOOL_TRUE );
+	if (contextp->dc_nextp == contextp->dc_buf) {
+		assert(drivep->d_markrecheadp == 0);
+		(* cbfuncp)(cbcontextp, markrecp, BOOL_TRUE);
 		return;
 	} else {
 		markrecp->dm_cbfuncp = cbfuncp;
 		markrecp->dm_cbcontextp = cbcontextp;
 		markrecp->dm_nextp = 0;
-		if ( drivep->d_markrecheadp == 0 ) {
+		if (drivep->d_markrecheadp == 0) {
 			drivep->d_markrecheadp = markrecp;
 			drivep->d_markrectailp = markrecp;
 		} else {
-			assert( drivep->d_markrectailp );
+			assert(drivep->d_markrectailp);
 			drivep->d_markrectailp->dm_nextp = markrecp;
 			drivep->d_markrectailp = markrecp;
 		}
@@ -1178,31 +1178,31 @@ do_set_mark( drive_t *drivep,
  */
 /*ARGSUSED*/
 static char *
-do_get_write_buf( drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp )
+do_get_write_buf(drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	size_t remaining_bufsz;
 	size_t actual_bufsz;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple get_write_buf( want %u )\n",
-	      wanted_bufsz );
+	      wanted_bufsz);
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp < contextp->dc_emptyp );
-	assert( contextp->dc_ownedsz == 0 );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp < contextp->dc_emptyp);
+	assert(contextp->dc_ownedsz == 0);
 
 	/* calculate how much buffer remains
 	 */
-	remaining_bufsz =( size_t )( contextp->dc_emptyp - contextp->dc_nextp );
+	remaining_bufsz =(size_t)(contextp->dc_emptyp - contextp->dc_nextp);
 
 	/*  give the caller the lesser of what he wants and what is available
 	 */
-	actual_bufsz = min( wanted_bufsz, remaining_bufsz );
+	actual_bufsz = min(wanted_bufsz, remaining_bufsz);
 
 	/* caller will own that portion of buffer
 	 */
@@ -1224,15 +1224,15 @@ do_get_write_buf( drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp )
  */
 /*ARGSUSED*/
 static int
-do_write( drive_t *drivep, char *bufp, size_t writesz )
+do_write(drive_t *drivep, char *bufp, size_t writesz)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t ownedstroff = contextp->dc_bufstroff
 			      +
-			      ( off64_t )
-			      ( contextp->dc_ownedp - contextp->dc_buf );
+			      (off64_t)
+			      (contextp->dc_ownedp - contextp->dc_buf);
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
+	mlog(MLOG_NITTY | MLOG_DRIVE,
 	      "drive_simple write( "
 	      "offset %lld (0x%llx 0%llo) "
 	      "size %u (0x%x 0%o) "
@@ -1243,55 +1243,55 @@ do_write( drive_t *drivep, char *bufp, size_t writesz )
 	      writesz,
 	      writesz,
 	      writesz,
-	      0 );
+	      0);
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( contextp->dc_ownedp );
-	assert( bufp == contextp->dc_ownedp );
-	assert( ! contextp->dc_nextp );
-	assert( contextp->dc_ownedp < contextp->dc_emptyp );
-	assert( writesz == contextp->dc_ownedsz );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(contextp->dc_ownedp);
+	assert(bufp == contextp->dc_ownedp);
+	assert(! contextp->dc_nextp);
+	assert(contextp->dc_ownedp < contextp->dc_emptyp);
+	assert(writesz == contextp->dc_ownedsz);
 
 	/* calculate next portion of buffer available for get_write_buf,
 	 * and indicate no portion is owned.
 	 */
 	contextp->dc_nextp = contextp->dc_ownedp + writesz;
-	assert( contextp->dc_nextp <= contextp->dc_emptyp );
+	assert(contextp->dc_nextp <= contextp->dc_emptyp);
 	contextp->dc_ownedp = 0;
 	contextp->dc_ownedsz = 0;
 
-	if ( writesz == 0 ) {
+	if (writesz == 0) {
 		return 0; /* returning unused buffer */
 	}
 
 	/* if buffer is full, flush it
 	 */
-	if ( contextp->dc_nextp == contextp->dc_emptyp ) {
+	if (contextp->dc_nextp == contextp->dc_emptyp) {
 		int nwritten;
 
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "flushing write buf addr 0x%x size 0x%x\n",
 		      contextp->dc_buf,
-		      sizeof( contextp->dc_buf ));
+		      sizeof(contextp->dc_buf));
 
 		contextp->dc_nextp = 0;
-		nwritten = write( contextp->dc_fd,
+		nwritten = write(contextp->dc_fd,
 				  contextp->dc_buf,
-				  sizeof( contextp->dc_buf ));
-		if ( nwritten < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+				  sizeof(contextp->dc_buf));
+		if (nwritten < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 			      _("write to %s failed: %d (%s)\n"),
 			      drivep->d_pathname,
 			      errno,
-			      strerror( errno ));
+			      strerror(errno));
 			nwritten = 0;
 		}
-		contextp->dc_bufstroff += ( off64_t )nwritten;
-		drive_mark_commit( drivep, contextp->dc_bufstroff );
+		contextp->dc_bufstroff += (off64_t)nwritten;
+		drive_mark_commit(drivep, contextp->dc_bufstroff);
 		contextp->dc_nextp = contextp->dc_buf;
-		if ( ( size_t )nwritten < sizeof( contextp->dc_buf )) {
+		if ((size_t)nwritten < sizeof(contextp->dc_buf)) {
 			return DRIVE_ERROR_EOM;
 		}
 	}
@@ -1303,91 +1303,91 @@ do_write( drive_t *drivep, char *bufp, size_t writesz )
  * cause the next call to get_write_buf() to be page-aligned.
  */
 static size_t
-do_get_align_cnt( drive_t *drivep )
+do_get_align_cnt(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	intptr_t next_alignment_off;
 	char *next_alignment_point;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple get_align_cnt( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple get_align_cnt( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp < contextp->dc_emptyp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp < contextp->dc_emptyp);
 
 	/* calculate the next alignment point at or beyond the current nextp.
 	 * the following algorithm works because dc_buf is page-aligned and
 	 * a multiple of PGSZ.
 	 */
-	next_alignment_off = ( intptr_t )contextp->dc_nextp;
+	next_alignment_off = (intptr_t)contextp->dc_nextp;
 	next_alignment_off +=  PGMASK;
 	next_alignment_off &= ~PGMASK;
-	next_alignment_point = ( char * )next_alignment_off;
-	assert( next_alignment_point <= contextp->dc_emptyp );
+	next_alignment_point = (char *)next_alignment_off;
+	assert(next_alignment_point <= contextp->dc_emptyp);
 
 	/* return the number of bytes to the next alignment point
 	 */
-	return ( size_t )( next_alignment_point - contextp->dc_nextp );
+	return (size_t)(next_alignment_point - contextp->dc_nextp);
 }
 
 /* end_write - flush any buffered data, and return by reference how many
  * bytes were committed.
  */
 static int
-do_end_write( drive_t *drivep, off64_t *ncommittedp )
+do_end_write(drive_t *drivep, off64_t *ncommittedp)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	size_t remaining_bufsz;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple end_write( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple end_write( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_WRITE );
-	assert( ! contextp->dc_ownedp );
-	assert( contextp->dc_nextp );
-	assert( contextp->dc_nextp < contextp->dc_emptyp );
+	assert(contextp->dc_mode == OM_WRITE);
+	assert(! contextp->dc_ownedp);
+	assert(contextp->dc_nextp);
+	assert(contextp->dc_nextp < contextp->dc_emptyp);
 
 	/* calculate length of un-written portion of buffer
 	 */
-	assert( contextp->dc_nextp >= contextp->dc_buf );
-	remaining_bufsz = ( size_t )( contextp->dc_nextp - contextp->dc_buf );
+	assert(contextp->dc_nextp >= contextp->dc_buf);
+	remaining_bufsz = (size_t)(contextp->dc_nextp - contextp->dc_buf);
 
-	if ( remaining_bufsz ) {
+	if (remaining_bufsz) {
 		int nwritten;
-		if ( contextp->dc_israwdevpr ) {
-			remaining_bufsz = ( remaining_bufsz + ( BBSIZE - 1 ))
+		if (contextp->dc_israwdevpr) {
+			remaining_bufsz = (remaining_bufsz + (BBSIZE - 1))
 					  &
-					  ~( BBSIZE - 1 );
+					  ~(BBSIZE - 1);
 		}
 
-		mlog( MLOG_DEBUG | MLOG_DRIVE,
+		mlog(MLOG_DEBUG | MLOG_DRIVE,
 		      "flushing write buf addr 0x%x size 0x%x\n",
 		      contextp->dc_buf,
-		      remaining_bufsz );
+		      remaining_bufsz);
 
-		nwritten = write( contextp->dc_fd,
+		nwritten = write(contextp->dc_fd,
 				  contextp->dc_buf,
-				  remaining_bufsz );
-		if ( nwritten < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+				  remaining_bufsz);
+		if (nwritten < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 			      _("write to %s failed: %d (%s)\n"),
 			      drivep->d_pathname,
 			      errno,
-			      strerror( errno ));
-			drive_mark_discard( drivep );
+			      strerror(errno));
+			drive_mark_discard(drivep);
 			*ncommittedp = contextp->dc_bufstroff;
 			contextp->dc_mode = OM_NONE;
 			return DRIVE_ERROR_DEVICE;
 		}
-		contextp->dc_bufstroff += ( off64_t )nwritten;
-		drive_mark_commit( drivep, contextp->dc_bufstroff );
-		if ( ( size_t )nwritten < remaining_bufsz ) {
+		contextp->dc_bufstroff += (off64_t)nwritten;
+		drive_mark_commit(drivep, contextp->dc_bufstroff);
+		if ((size_t)nwritten < remaining_bufsz) {
 			*ncommittedp = contextp->dc_bufstroff;
 			contextp->dc_mode = OM_NONE;
 			return DRIVE_ERROR_EOM;
@@ -1397,7 +1397,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 	/* bump the file mark cnt
 	 */
 	contextp->dc_fmarkcnt++;
-	assert( contextp->dc_fmarkcnt == 1 );
+	assert(contextp->dc_fmarkcnt == 1);
 
 	*ncommittedp = contextp->dc_bufstroff;
 	contextp->dc_mode = OM_NONE;
@@ -1407,32 +1407,32 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
 /* rewind - return the current file offset to the beginning
  */
 int
-do_rewind( drive_t *drivep )
+do_rewind(drive_t *drivep)
 {
 #ifdef DEBUG
 	int dcaps = drivep->d_capabilities;
 #endif
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t newoff;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple rewind( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple rewind( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_NONE );
-	assert( dcaps & DRIVE_CAP_REWIND );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(dcaps & DRIVE_CAP_REWIND);
+	assert(contextp->dc_fd >= 0);
 
 	/* seek to beginning of file
 	 */
-	newoff = lseek64( contextp->dc_fd, ( off64_t )0, SEEK_SET );
-	if ( newoff ) {
-		assert( newoff < 0 );
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	newoff = lseek64(contextp->dc_fd, (off64_t)0, SEEK_SET);
+	if (newoff) {
+		assert(newoff < 0);
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("could not rewind %s: %s\n"),
 		      drivep->d_pathname,
-		      strerror( errno ));
+		      strerror(errno));
 		return DRIVE_ERROR_DEVICE;
 	}
 
@@ -1442,45 +1442,45 @@ do_rewind( drive_t *drivep )
 /* erase - truncate to zero length
  */
 int
-do_erase( drive_t *drivep )
+do_erase(drive_t *drivep)
 {
 #ifdef DEBUG
 	int dcaps = drivep->d_capabilities;
 #endif
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 	off64_t newoff;
 	int rval;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple erase( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple erase( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_NONE );
-	assert( dcaps & DRIVE_CAP_ERASE );
-	assert( contextp->dc_fd >= 0 );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(dcaps & DRIVE_CAP_ERASE);
+	assert(contextp->dc_fd >= 0);
 
 	/* seek to beginning of file
 	 */
-	newoff = lseek64( contextp->dc_fd, ( off64_t )0, SEEK_SET );
-	if ( newoff ) {
-		assert( newoff < 0 );
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	newoff = lseek64(contextp->dc_fd, (off64_t)0, SEEK_SET);
+	if (newoff) {
+		assert(newoff < 0);
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("could not rewind %s in prep for erase: %s\n"),
 		      drivep->d_pathname,
-		      strerror( errno ));
+		      strerror(errno));
 		return DRIVE_ERROR_DEVICE;
 	}
 
 	/* erase to beginning of file
 	 */
-	rval = ftruncate64( contextp->dc_fd, ( off64_t )0 );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
+	rval = ftruncate64(contextp->dc_fd, (off64_t)0);
+	if (rval) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 		      _("could not erase %s: %s (%d)\n"),
 		      drivep->d_pathname,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		return DRIVE_ERROR_DEVICE;
 	}
 	contextp->dc_fmarkcnt = 0;
@@ -1492,36 +1492,36 @@ do_erase( drive_t *drivep )
  */
 /* ARGSUSED */
 static int
-do_get_device_class( drive_t *drivep )
+do_get_device_class(drive_t *drivep)
 {
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple get_device_class( )\n" );
-	assert( drivep );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple get_device_class( )\n");
+	assert(drivep);
 	return DEVICE_NONREMOVABLE;
 }
 
 static void
-do_quit( drive_t *drivep )
+do_quit(drive_t *drivep)
 {
-	drive_context_t *contextp = ( drive_context_t * )drivep->d_contextp;
+	drive_context_t *contextp = (drive_context_t *)drivep->d_contextp;
 
-	mlog( MLOG_NITTY | MLOG_DRIVE,
-	      "drive_simple quit( )\n" );
+	mlog(MLOG_NITTY | MLOG_DRIVE,
+	      "drive_simple quit( )\n");
 
 	/* assert protocol
 	 */
-	assert( contextp->dc_mode == OM_NONE );
-	assert( contextp );
+	assert(contextp->dc_mode == OM_NONE);
+	assert(contextp);
 
 	/* close file
 	 */
-	if ( contextp->dc_fd > 1 ) {
-		close( contextp->dc_fd );
+	if (contextp->dc_fd > 1) {
+		close(contextp->dc_fd);
 	}
 	contextp->dc_fd = -1;
 
 	/* free context
 	 */
-	free( ( void * )contextp );
+	free((void *)contextp);
 	drivep->d_contextp = 0;
 }
diff --git a/common/exit.h b/common/exit.h
index 403946d..de76cd8 100644
--- a/common/exit.h
+++ b/common/exit.h
@@ -26,9 +26,9 @@
 #define EXIT_FAULT	4	/* code fault */
 
 static inline const char *
-exit_codestring( int code )
+exit_codestring(int code)
 {
-	switch ( code ) {
+	switch (code) {
 	case EXIT_NORMAL:    return "SUCCESS";
 	case EXIT_ERROR:     return "ERROR";
 	case EXIT_INTERRUPT: return "INTERRUPT";
diff --git a/common/fs.c b/common/fs.c
index 60cf0fd..4880db9 100644
--- a/common/fs.c
+++ b/common/fs.c
@@ -99,16 +99,16 @@ static	fs_tab_ent_t *fs_tabp;
 
 /* forward declarations
  */
-static void fs_tab_build( void );
-static void fs_tab_free( void );
-static fs_tab_ent_t *fs_tab_ent_build( struct mntent * );
-static void fs_tab_ent_free( fs_tab_ent_t * );
-static fs_tab_ent_t *fs_tab_lookup_blk( char * );
-static fs_tab_ent_t *fs_tab_lookup_mnt( char * );
+static void fs_tab_build(void);
+static void fs_tab_free(void);
+static fs_tab_ent_t *fs_tab_ent_build(struct mntent *);
+static void fs_tab_ent_free(fs_tab_ent_t *);
+static fs_tab_ent_t *fs_tab_lookup_blk(char *);
+static fs_tab_ent_t *fs_tab_lookup_mnt(char *);
 
 /* ARGSUSED */
 bool_t
-fs_info( char *typb,		/* out */
+fs_info(char *typb,		/* out */
 	 int typbz,
 	 char *typd,
 	 char *blkb,		/* out */
@@ -116,7 +116,7 @@ fs_info( char *typb,		/* out */
 	 char *mntb,		/* out */
 	 int mntbz,
 	 uuid_t *idb,		/* out */
-	 char *usrs )		/* in */
+	 char *usrs)		/* in */
 {
 	struct stat64 statb;
 	fs_tab_ent_t *tep;
@@ -126,64 +126,64 @@ fs_info( char *typb,		/* out */
 	bool_t canstat;
 	bool_t ok = BOOL_UNKNOWN;
 
-	fs_tab_build( );
+	fs_tab_build();
 
-	canstat = ( stat64( usrs, &statb ) == 0 );
-	if ( canstat && ( statb.st_mode & S_IFMT ) == S_IFBLK ) {
-		if ( ( tep = fs_tab_lookup_blk( usrs )) != 0 ) {
+	canstat = (stat64(usrs, &statb) == 0);
+	if (canstat && (statb.st_mode & S_IFMT) == S_IFBLK) {
+		if ((tep = fs_tab_lookup_blk(usrs)) != 0) {
 			blks = tep->fte_blks;
-			assert( strlen( blks ) < ( size_t )blkbz );
-			strcpy( blkb, blks );
+			assert(strlen(blks) < (size_t)blkbz);
+			strcpy(blkb, blks);
 			mnts = tep->fte_mnts;
-			if ( mnts ) {
-				assert( strlen( mnts ) < ( size_t )mntbz );
-				strcpy( mntb, mnts );
+			if (mnts) {
+				assert(strlen(mnts) < (size_t)mntbz);
+				strcpy(mntb, mnts);
 			} else {
-				mntb[ 0 ] = 0;
+				mntb[0] = 0;
 			}
-			if ( ( typs = tep->fte_typs ) == 0 ) {
+			if ((typs = tep->fte_typs) == 0) {
 				typs = typd;
 			}
-			assert( strlen( typs ) < ( size_t )typbz );
-			strcpy( typb, typs );
+			assert(strlen(typs) < (size_t)typbz);
+			strcpy(typb, typs);
 			ok = BOOL_TRUE;
 		} else {
 			ok = BOOL_FALSE;
 		}
-	} else if ( ( tep = fs_tab_lookup_mnt( usrs )) != 0 ) {
+	} else if ((tep = fs_tab_lookup_mnt(usrs)) != 0) {
 		blks = tep->fte_blks;
-		assert( strlen( blks ) < ( size_t )blkbz );
-		strcpy( blkb, blks );
+		assert(strlen(blks) < (size_t)blkbz);
+		strcpy(blkb, blks);
 		mnts = tep->fte_mnts;
-		assert( strlen( mnts ) < ( size_t )mntbz );
-		strcpy( mntb, mnts );
+		assert(strlen(mnts) < (size_t)mntbz);
+		strcpy(mntb, mnts);
 		typs = tep->fte_typs;
-		assert( strlen( typs ) < ( size_t )typbz );
-		strcpy( typb, typs );
+		assert(strlen(typs) < (size_t)typbz);
+		strcpy(typb, typs);
 		ok = BOOL_TRUE;
 	} else {
 		ok = BOOL_FALSE;
 	}
 
-	fs_tab_free( );
-	assert( ok != BOOL_UNKNOWN );
+	fs_tab_free();
+	assert(ok != BOOL_UNKNOWN);
 
-	if ( ok == BOOL_TRUE ) {
-		int rval = fs_getid( mntb, idb );
-		if ( rval ) {
-			mlog( MLOG_NORMAL,
+	if (ok == BOOL_TRUE) {
+		int rval = fs_getid(mntb, idb);
+		if (rval) {
+			mlog(MLOG_NORMAL,
 			      _("unable to determine uuid of fs mounted at %s: "
 			      "%s\n"),
 			      mntb,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 		{
 			char string_uuid[37];
-			uuid_unparse( *idb, string_uuid );
-			mlog( MLOG_DEBUG,
+			uuid_unparse(*idb, string_uuid);
+			mlog(MLOG_DEBUG,
 			      "fs %s uuid [%s]\n",
 			      mntb,
-			      string_uuid );
+			      string_uuid);
 		}
 	}
 
@@ -196,120 +196,120 @@ fs_info( char *typb,		/* out */
  */
 /* ARGSUSED */
 bool_t
-fs_mounted( char *typs, char *chrs, char *mnts, uuid_t *idp )
+fs_mounted(char *typs, char *chrs, char *mnts, uuid_t *idp)
 {
-	return strlen( mnts ) > 0 ? BOOL_TRUE : BOOL_FALSE;
+	return strlen(mnts) > 0 ? BOOL_TRUE : BOOL_FALSE;
 }
 
 int
-fs_getid( char *mnts, uuid_t *idb )
+fs_getid(char *mnts, uuid_t *idb)
 {
 	xfs_fsop_geom_v1_t geo;
 	int fd;
 
-	fd = open( mnts, O_RDONLY );
-	if ( fd < 0 ) {
-		uuid_clear( *idb );
+	fd = open(mnts, O_RDONLY);
+	if (fd < 0) {
+		uuid_clear(*idb);
 		return -1;
 	}
-	if ( ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo ) ) {
-		uuid_clear( *idb );
+	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geo)) {
+		uuid_clear(*idb);
 		close(fd);
 		return -1;
 	}
 	close(fd);
-	uuid_copy( *idb, geo.uuid );
+	uuid_copy(*idb, geo.uuid);
 
 	return 0;
 }
 
 size_t
-fs_getinocnt( char *mnts )
+fs_getinocnt(char *mnts)
 {
 	struct statvfs vfsstat;
 	int rval;
 
-	rval = statvfs( mnts, &vfsstat );
-	if ( rval ) {
+	rval = statvfs(mnts, &vfsstat);
+	if (rval) {
 		return 0;
 	}
 
-	if ( vfsstat.f_files < vfsstat.f_ffree ) {
+	if (vfsstat.f_files < vfsstat.f_ffree) {
 		return 0;
 	}
 
-	return ( size_t )( vfsstat.f_files - vfsstat.f_ffree );
+	return (size_t)(vfsstat.f_files - vfsstat.f_ffree);
 }
 
 static void
-fs_tab_build( void )
+fs_tab_build(void)
 {
 	register struct mntent *mntentp;
 	fs_tab_ent_t *tep;
 	FILE *fp;
 
 	fs_tabp = 0;
-	fp = setmntent( MOUNTED, "r" );
-        if ( fp == NULL ) {
-		mlog( MLOG_NORMAL,
+	fp = setmntent(MOUNTED, "r");
+        if (fp == NULL) {
+		mlog(MLOG_NORMAL,
 		      _("Can't open %s for mount information\n"),
-		      MOUNTED );
+		      MOUNTED);
 		return;
 	}
-	while ( ( mntentp = getmntent( fp )) != 0 ) {
-		tep = fs_tab_ent_build( mntentp );
+	while ((mntentp = getmntent(fp)) != 0) {
+		tep = fs_tab_ent_build(mntentp);
 		tep->fte_nextp = fs_tabp;
 		fs_tabp = tep;
 	}
-	endmntent( fp );
+	endmntent(fp);
 }
 
 static void
-fs_tab_free( void )
+fs_tab_free(void)
 {
 	fs_tab_ent_t *tep;
 	fs_tab_ent_t *otep;
 
-	for ( tep = fs_tabp
+	for (tep = fs_tabp
 	      ;
 	      tep
 	      ;
-	      otep = tep, tep = tep->fte_nextp, fs_tab_ent_free( otep ) )
+	      otep = tep, tep = tep->fte_nextp, fs_tab_ent_free(otep))
 
 		;
 }
 
 static fs_tab_ent_t *
-fs_tab_ent_build( struct mntent *mntentp )
+fs_tab_ent_build(struct mntent *mntentp)
 {
 	fs_tab_ent_t *tep;
 	char *cp;
 
-	tep = ( fs_tab_ent_t * )calloc( 1, sizeof( fs_tab_ent_t ));
-	assert( tep );
+	tep = (fs_tab_ent_t *)calloc(1, sizeof(fs_tab_ent_t));
+	assert(tep);
 
-	if ( mntentp->mnt_dir ) {
-		cp = calloc( 1, strlen( mntentp->mnt_dir ) + 1 );
-		assert( cp );
-		( void )strcpy( cp, mntentp->mnt_dir );
+	if (mntentp->mnt_dir) {
+		cp = calloc(1, strlen(mntentp->mnt_dir) + 1);
+		assert(cp);
+		(void)strcpy(cp, mntentp->mnt_dir);
 		tep->fte_mnts = cp;
 	} else {
 		tep->fte_mnts = 0;
 	}
 
-	if ( mntentp->mnt_type ) {
-		cp = calloc( 1, strlen( mntentp->mnt_type ) + 1 );
-		assert( cp );
-		( void )strcpy( cp, mntentp->mnt_type );
+	if (mntentp->mnt_type) {
+		cp = calloc(1, strlen(mntentp->mnt_type) + 1);
+		assert(cp);
+		(void)strcpy(cp, mntentp->mnt_type);
 		tep->fte_typs = cp;
 	} else {
 		tep->fte_typs = 0;
 	}
 
-	if ( mntentp->mnt_fsname ) {
-		cp = calloc( 1, strlen( mntentp->mnt_fsname ) + 1 );
-		assert( cp );
-		( void )strcpy( cp, mntentp->mnt_fsname );
+	if (mntentp->mnt_fsname) {
+		cp = calloc(1, strlen(mntentp->mnt_fsname) + 1);
+		assert(cp);
+		(void)strcpy(cp, mntentp->mnt_fsname);
 		tep->fte_blks = cp;
 	} else {
 		tep->fte_blks = 0;
@@ -319,37 +319,37 @@ fs_tab_ent_build( struct mntent *mntentp )
 }
 
 static void
-fs_tab_ent_free( fs_tab_ent_t *tep )
+fs_tab_ent_free(fs_tab_ent_t *tep)
 {
-	if ( tep->fte_blks ) free( tep->fte_blks );
-	if ( tep->fte_mnts ) free( tep->fte_mnts );
-	if ( tep->fte_typs ) free( tep->fte_typs );
-	memset( ( void * )tep, 0, sizeof( *tep )); /* bug catcher */
-	free( tep );
+	if (tep->fte_blks) free(tep->fte_blks);
+	if (tep->fte_mnts) free(tep->fte_mnts);
+	if (tep->fte_typs) free(tep->fte_typs);
+	memset((void *)tep, 0, sizeof(*tep)); /* bug catcher */
+	free(tep);
 }
 
 static fs_tab_ent_t *
-fs_tab_lookup_blk( char *blks )
+fs_tab_lookup_blk(char *blks)
 {
 	fs_tab_ent_t *tep;
 
-	for ( tep = fs_tabp ; tep ; tep = tep->fte_nextp ) {
+	for (tep = fs_tabp ; tep ; tep = tep->fte_nextp) {
 		struct stat64 stata;
 		bool_t aok;
 		struct stat64 statb;
 		bool_t bok;
 
-		if ( ! tep->fte_blks ) {
+		if (! tep->fte_blks) {
 			continue;
 		}
 
-		if ( ! strcmp( tep->fte_blks, blks )) {
+		if (! strcmp(tep->fte_blks, blks)) {
 			return tep;
 		}
 
-		aok = ! stat64( blks, &stata );
-		bok = ! stat64( tep->fte_blks, &statb );
-		if ( aok && bok && stata.st_rdev == statb.st_rdev ) {
+		aok = ! stat64(blks, &stata);
+		bok = ! stat64(tep->fte_blks, &statb);
+		if (aok && bok && stata.st_rdev == statb.st_rdev) {
 			return tep;
 		}
 	}
@@ -357,12 +357,12 @@ fs_tab_lookup_blk( char *blks )
 }
 
 static fs_tab_ent_t *
-fs_tab_lookup_mnt( char *mnts )
+fs_tab_lookup_mnt(char *mnts)
 {
 	fs_tab_ent_t *tep;
 
-	for ( tep = fs_tabp ; tep ; tep = tep->fte_nextp ) {
-		if ( tep->fte_mnts && ! strcmp( tep->fte_mnts, mnts )) {
+	for (tep = fs_tabp ; tep ; tep = tep->fte_nextp) {
+		if (tep->fte_mnts && ! strcmp(tep->fte_mnts, mnts)) {
 			return tep;
 		}
 	}
diff --git a/common/fs.h b/common/fs.h
index 4a9d9d1..7b02d72 100644
--- a/common/fs.h
+++ b/common/fs.h
@@ -31,7 +31,7 @@
  *
  * returns BOOL_FALSE if srcname does not describe a file system.
  */
-extern bool_t fs_info( char *fstype,		/* out: fs type (fsid.h) */
+extern bool_t fs_info(char *fstype,		/* out: fs type (fsid.h) */
 		       int fstypesz,	/* in: buffer size */
 		       char *fstypedef,		/* in: default fs type */
 		       char *fsdevice,		/* out: blk spec. dev. file */
@@ -39,22 +39,22 @@ extern bool_t fs_info( char *fstype,		/* out: fs type (fsid.h) */
 		       char *mntpt,		/* out: where fs mounted */
 		       int mntptsz,	/* in: buffer size */
 		       uuid_t *fsid,		/* out: fs uuid */
-		       char *srcname );		/* in: how user named the fs */
+		       char *srcname);		/* in: how user named the fs */
 
 /* fs_mounted - checks if a file system is mounted at its mount point
  */
-extern bool_t fs_mounted( char *fstype,
+extern bool_t fs_mounted(char *fstype,
 		          char *fsdevice,
 		          char *mntpt,
-		          uuid_t *fsid );
+		          uuid_t *fsid);
 
 /* fs_getid - retrieves the uuid of the file system containing the named
  * file. returns -1 with errno set on error.
  */
-extern int fs_getid( char *fullpathname, uuid_t *fsidp );
+extern int fs_getid(char *fullpathname, uuid_t *fsidp);
 
 /* tells how many inos in use
  */
-extern size_t fs_getinocnt( char *mnts );
+extern size_t fs_getinocnt(char *mnts);
 
 #endif /* FS_H */
diff --git a/common/global.c b/common/global.c
index 73efd55..62a00c3 100644
--- a/common/global.c
+++ b/common/global.c
@@ -39,14 +39,14 @@
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
+extern void usage(void);
 extern bool_t pipeline;
 
 
 /* forward declarations of locally defined static functions ******************/
 
 #ifdef DUMP
-static char * prompt_label( char *bufp, size_t bufsz );
+static char * prompt_label(char *bufp, size_t bufsz);
 #endif /* DUMP */
 
 /* definition of locally defined global variables ****************************/
@@ -58,13 +58,13 @@ static char * prompt_label( char *bufp, size_t bufsz );
 /* definition of locally defined global functions ****************************/
 
 global_hdr_t *
-global_hdr_alloc( int argc, char *argv[ ] )
+global_hdr_alloc(int argc, char *argv[])
 {
 	global_hdr_t *ghdrp;
 	int c;
 	char *dumplabel;
 #ifdef DUMP
-	char labelbuf[ GLOBAL_HDR_STRING_SZ ];
+	char labelbuf[GLOBAL_HDR_STRING_SZ];
 	struct stat64 statb;
 #endif /* DUMP */
 
@@ -72,17 +72,17 @@ global_hdr_alloc( int argc, char *argv[ ] )
 
 	/* sanity checks
 	 */
-	assert( sizeof( time32_t ) == GLOBAL_HDR_TIME_SZ );
-	assert( sizeof( uuid_t ) == GLOBAL_HDR_UUID_SZ );
+	assert(sizeof(time32_t) == GLOBAL_HDR_TIME_SZ);
+	assert(sizeof(uuid_t) == GLOBAL_HDR_UUID_SZ);
 
 	/* allocate a global hdr
 	 */
-	ghdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
-	assert( ghdrp );
+	ghdrp = (global_hdr_t *)calloc(1, sizeof(global_hdr_t));
+	assert(ghdrp);
 
 	/* fill in the magic number
 	 */
-	strncpy( ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ );
+	strncpy(ghdrp->gh_magic, GLOBAL_HDR_MAGIC, GLOBAL_HDR_MAGIC_SZ);
 
 	/* fill in the hdr version
 	 */
@@ -92,31 +92,31 @@ global_hdr_alloc( int argc, char *argv[ ] )
 	 * will be included in increments on this base. This may be
 	 * overridden with the GETOPT_DUMPTIME option.
 	 */
-	ghdrp->gh_timestamp = (time32_t) time( 0 );
+	ghdrp->gh_timestamp = (time32_t) time(0);
 
 	/* fill in the host id: typecast to fit into a 64 bit field
 	 */
-	ghdrp->gh_ipaddr = ( uint64_t )( unsigned long )gethostid( );
+	ghdrp->gh_ipaddr = (uint64_t)(unsigned long)gethostid();
 
 #ifdef DUMP
-	uuid_generate( ghdrp->gh_dumpid );
+	uuid_generate(ghdrp->gh_dumpid);
 #endif /* DUMP */
 #ifdef RESTORE
-	uuid_clear( ghdrp->gh_dumpid );
+	uuid_clear(ghdrp->gh_dumpid);
 #endif /* RESTORE */
 
 	/* fill in the hostname
 	 */
-	rval = gethostname( ghdrp->gh_hostname, GLOBAL_HDR_STRING_SZ );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+	rval = gethostname(ghdrp->gh_hostname, GLOBAL_HDR_STRING_SZ);
+	if (rval) {
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("unable to determine hostname: %s\n"),
-		      strerror( errno ));
+		      strerror(errno));
 		return 0;
 	}
-	if ( ! strlen( ghdrp->gh_hostname )) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
-		      _("hostname length is zero\n") );
+	if (! strlen(ghdrp->gh_hostname)) {
+		mlog(MLOG_NORMAL | MLOG_ERROR,
+		      _("hostname length is zero\n"));
 		return 0;
 	}
 
@@ -125,50 +125,50 @@ global_hdr_alloc( int argc, char *argv[ ] )
 	dumplabel = 0;
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
                 case GETOPT_DUMPLABEL:
-                        if ( dumplabel ) {
-                                mlog( MLOG_NORMAL,
+                        if (dumplabel) {
+                                mlog(MLOG_NORMAL,
                                       _("too many -%c arguments: "
                                       "\"-%c %s\" already given\n"),
                                       c,
                                       c,
-                                      dumplabel );
-                                usage( );
+                                      dumplabel);
+                                usage();
                                 return 0;
                         }
-                        if ( ! optarg || optarg[ 0 ] == '-' ) {
-                                mlog( MLOG_NORMAL | MLOG_ERROR,
+                        if (! optarg || optarg[0] == '-') {
+                                mlog(MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      c );
-                                usage( );
+                                      c);
+                                usage();
                                 return 0;
                         }
                         dumplabel = optarg;
                         break;
 #ifdef RESTORE
 		case GETOPT_SESSIONID:
-                        if ( ! uuid_is_null( ghdrp->gh_dumpid )) {
-                                mlog( MLOG_NORMAL | MLOG_ERROR,
+                        if (! uuid_is_null(ghdrp->gh_dumpid)) {
+                                mlog(MLOG_NORMAL | MLOG_ERROR,
                                       _("too many -%c arguments\n"),
-                                      c );
-                                usage( );
+                                      c);
+                                usage();
                                 return 0;
                         }
-                        if ( ! optarg || optarg[ 0 ] == '-' ) {
-                                mlog( MLOG_NORMAL | MLOG_ERROR,
+                        if (! optarg || optarg[0] == '-') {
+                                mlog(MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      c );
-                                usage( );
+                                      c);
+                                usage();
                                 return 0;
                         }
 
-			if ( ! uuid_parse( optarg, ghdrp->gh_dumpid ) ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+			if (! uuid_parse(optarg, ghdrp->gh_dumpid)) {
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 				      _("-%c argument not a valid uuid\n"),
-				      c );
-                                usage( );
+				      c);
+                                usage();
                                 return 0;
                         }
                         break;
@@ -178,20 +178,20 @@ global_hdr_alloc( int argc, char *argv[ ] )
 			/* Use the timestamp of the specified file for the
 			 * dump time, rather than using the current time.
 			 */
-                        if ( ! optarg || optarg[ 0 ] == '-' ) {
-                                mlog( MLOG_NORMAL | MLOG_ERROR,
+                        if (! optarg || optarg[0] == '-') {
+                                mlog(MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      c );
-                                usage( );
+                                      c);
+                                usage();
                                 return 0;
                         }
-			rval = stat64( optarg, &statb );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+			rval = stat64(optarg, &statb);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 				      _("unable to stat %s: %s\n"),
 				      optarg,
-				      strerror( errno ));
-				usage( );
+				      strerror(errno));
+				usage();
 				return 0;
 			}
 			ghdrp->gh_timestamp = statb.st_mtime;
@@ -208,49 +208,49 @@ global_hdr_alloc( int argc, char *argv[ ] )
 	/* if no dump label specified, no pipes in use, and dialogs
 	 * are allowed, prompt for one
 	 */
-	if ( ! dumplabel && dlog_allowed( )) {
-		dumplabel = prompt_label( labelbuf, sizeof( labelbuf ));
+	if (! dumplabel && dlog_allowed()) {
+		dumplabel = prompt_label(labelbuf, sizeof(labelbuf));
 	}
 #endif /* DUMP */
 
-	if ( ! dumplabel || ! strlen( dumplabel )) {
+	if (! dumplabel || ! strlen(dumplabel)) {
 #ifdef DUMP
-		if ( ! pipeline ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING,
-			      _("no session label specified\n") );
+		if (! pipeline) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING,
+			      _("no session label specified\n"));
 		}
 #endif /* DUMP */
 		dumplabel = "";
 	}
 
-	strncpyterm( ghdrp->gh_dumplabel,
+	strncpyterm(ghdrp->gh_dumplabel,
 		     dumplabel,
-		     sizeof( ghdrp->gh_dumplabel ));
+		     sizeof(ghdrp->gh_dumplabel));
 
 	return ghdrp;
 }
 
 
 void
-global_hdr_free( global_hdr_t *ghdrp )
+global_hdr_free(global_hdr_t *ghdrp)
 {
-    free( ( void * )ghdrp );
+    free((void *)ghdrp);
 }
 
 /* global_hdr_checksum_set - fill in the global media file header checksum.
  * utility function for use by drive-specific strategies.
  */
 void
-global_hdr_checksum_set( global_hdr_t *hdrp )
+global_hdr_checksum_set(global_hdr_t *hdrp)
 {
-	uint32_t *beginp = ( uint32_t * )&hdrp[ 0 ];
-	uint32_t *endp = ( uint32_t * )&hdrp[ 1 ];
+	uint32_t *beginp = (uint32_t *)&hdrp[0];
+	uint32_t *endp = (uint32_t *)&hdrp[1];
 	uint32_t *p;
 	uint32_t accum;
 
 	hdrp->gh_checksum = 0;
 	accum = 0;
-	for ( p = beginp ; p < endp ; p++ ) {
+	for (p = beginp ; p < endp ; p++) {
 		accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	INT_SET(hdrp->gh_checksum, ARCH_CONVERT, (int32_t)(~accum + 1));
@@ -261,15 +261,15 @@ global_hdr_checksum_set( global_hdr_t *hdrp )
  * returns BOOL_TRUE if ok, BOOL_FALSE if bad
  */
 bool_t
-global_hdr_checksum_check( global_hdr_t *hdrp )
+global_hdr_checksum_check(global_hdr_t *hdrp)
 {
-	uint32_t *beginp = ( uint32_t * )&hdrp[ 0 ];
-	uint32_t *endp = ( uint32_t * )&hdrp[ 1 ];
+	uint32_t *beginp = (uint32_t *)&hdrp[0];
+	uint32_t *endp = (uint32_t *)&hdrp[1];
 	uint32_t *p;
 	uint32_t accum;
 
 	accum = 0;
-	for ( p = beginp ; p < endp ; p++ ) {
+	for (p = beginp ; p < endp ; p++) {
 		accum += INT_GET(*p, ARCH_CONVERT);
 	}
 	return accum == 0 ? BOOL_TRUE : BOOL_FALSE;
@@ -279,7 +279,7 @@ global_hdr_checksum_check( global_hdr_t *hdrp )
  * else return BOOL_FALSE
  */
 bool_t
-global_version_check( uint32_t version )
+global_version_check(uint32_t version)
 {
 	switch (version) {
 		case GLOBAL_HDR_VERSION_0:
@@ -304,37 +304,37 @@ global_version_check( uint32_t version )
 
 /* ARGSUSED */
 static void
-prompt_label_cb( void *uctxp, dlog_pcbp_t pcb, void *pctxp )
+prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
 	/* query: ask for a dump label
 	 */
-	( * pcb )( pctxp,
-		   _("please enter label for this dump session") );
+	(* pcb)(pctxp,
+		   _("please enter label for this dump session"));
 }
 
 static char *
-prompt_label( char *bufp, size_t bufsz )
+prompt_label(char *bufp, size_t bufsz)
 {
 	fold_t fold;
-	char *preamblestr[ PREAMBLEMAX ];
+	char *preamblestr[PREAMBLEMAX];
 	size_t preamblecnt;
-	char *ackstr[ ACKMAX ];
+	char *ackstr[ACKMAX];
 	size_t ackcnt;
-	char *postamblestr[ POSTAMBLEMAX ];
+	char *postamblestr[POSTAMBLEMAX];
 	size_t postamblecnt;
 	const ix_t abortix = 1;
 	const ix_t okix = 2;
 	ix_t responseix;
 
 	preamblecnt = 0;
-	fold_init( fold, _("dump label dialog"), '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
-
-	responseix = dlog_string_query( prompt_label_cb,
+	fold_init(fold, _("dump label dialog"), '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
+
+	responseix = dlog_string_query(prompt_label_cb,
 					0,
 					bufp,
 					bufsz,
@@ -343,30 +343,30 @@ prompt_label( char *bufp, size_t bufsz )
 					IXMAX, /* sigint ix */
 					IXMAX,  /* sighup ix */
 					IXMAX,  /* sigquit ix */
-					okix );   /* ok ix */
+					okix);   /* ok ix */
 	ackcnt = 0;
-	if ( responseix == okix ) {
-		ackstr[ ackcnt++ ] = _("session label entered: \"");
-		ackstr[ ackcnt++ ] = bufp;
-		ackstr[ ackcnt++ ] = "\"\n";
+	if (responseix == okix) {
+		ackstr[ackcnt++ ] = _("session label entered: \"");
+		ackstr[ackcnt++] = bufp;
+		ackstr[ackcnt++ ] = "\"\n";
 	} else {
-		ackstr[ ackcnt++ ] = _("session label left blank\n");
+		ackstr[ackcnt++ ] = _("session label left blank\n");
 	}
 
-	assert( ackcnt <= ACKMAX );
-	dlog_string_ack( ackstr,
-			 ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_string_ack(ackstr,
+			 ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, _("end dialog"), '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
-
-	if ( responseix == okix ) {
+	fold_init(fold, _("end dialog"), '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
+
+	if (responseix == okix) {
 		return bufp;
 	} else {
 		return 0;
diff --git a/common/global.h b/common/global.h
index 53351a1..141c6db 100644
--- a/common/global.h
+++ b/common/global.h
@@ -41,7 +41,7 @@
 #define GLOBAL_HDR_UUID_SZ	0x10
 
 struct global_hdr {
-	char gh_magic[ GLOBAL_HDR_MAGIC_SZ ];		/*   8    8 */
+	char gh_magic[GLOBAL_HDR_MAGIC_SZ];		/*   8    8 */
 		/* unique signature of xfsdump */
 	uint32_t gh_version;				/*   4    c */
 		/* header version */
@@ -49,55 +49,55 @@ struct global_hdr {
 		/* 32-bit unsigned additive inverse of entire header */
 	time32_t gh_timestamp;				/*   4   14 */
 		/* time32_t of dump */
-	char gh_pad1[ 4 ];				/*   4   18 */
+	char gh_pad1[4];				/*   4   18 */
 		/* alignment */
 	uint64_t gh_ipaddr;				/*   8   20 */
 		/* from gethostid(2), room for expansion */
 	uuid_t gh_dumpid;				/*  10   30 */
 		/* ID of dump session	 */
-	char gh_pad2[ 0xd0 ];				/*  d0  100 */
+	char gh_pad2[0xd0];				/*  d0  100 */
 		/* alignment */
-	char gh_hostname[ GLOBAL_HDR_STRING_SZ ];	/* 100  200 */
+	char gh_hostname[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
 		/* from gethostname(2) */
-	char gh_dumplabel[ GLOBAL_HDR_STRING_SZ ];	/* 100  300 */
+	char gh_dumplabel[GLOBAL_HDR_STRING_SZ];	/* 100  300 */
 		/* label of dump session */
-	char gh_pad3[ 0x100 ];				/* 100  400 */
+	char gh_pad3[0x100];				/* 100  400 */
 		/* padding */
-	char gh_upper[ GLOBAL_HDR_SZ - 0x400 ];		/* c00 1000 */
+	char gh_upper[GLOBAL_HDR_SZ - 0x400];		/* c00 1000 */
 		/* header info private to upper software layers */
 };
 
 typedef struct global_hdr global_hdr_t;
 
 
-/* used by main( ) to allocate and populate a global header template.
+/* used by main() to allocate and populate a global header template.
  * drive managers will copy this into the write header.
  */
-extern global_hdr_t * global_hdr_alloc( int argc, char *argv[ ] );
+extern global_hdr_t * global_hdr_alloc(int argc, char *argv[]);
 
 
-/* used by main( ) to free the global header template after drive ini.
+/* used by main() to free the global header template after drive ini.
  */
-extern void global_hdr_free( global_hdr_t *ghdrp );
+extern void global_hdr_free(global_hdr_t *ghdrp);
 
 
 /* global_hdr_checksum_set - fill in the global media file header checksum.
  * utility function for use by drive-specific strategies.
  */
-extern void global_hdr_checksum_set( global_hdr_t *hdrp );
+extern void global_hdr_checksum_set(global_hdr_t *hdrp);
 
 
 /* global_hdr_checksum_check - check the global media file header checksum.
  * utility function for use by drive-specific strategies.
  * returns BOOL_TRUE if ok, BOOL_FALSE if bad
  */
-extern bool_t global_hdr_checksum_check( global_hdr_t *hdrp );
+extern bool_t global_hdr_checksum_check(global_hdr_t *hdrp);
 
 /* global_version_check - if we know this version number, return BOOL_TRUE
  * else return BOOL_FALSE
  */
 
-extern bool_t global_version_check( uint32_t version );
+extern bool_t global_version_check(uint32_t version);
 
 
 #endif /* GLOBAL_H */
diff --git a/common/hsmapi.c b/common/hsmapi.c
index 7a3584d..24bb924 100644
--- a/common/hsmapi.c
+++ b/common/hsmapi.c
@@ -74,12 +74,12 @@ typedef	struct {
 	u_char	regcnt[2];	/* number of regions in MSB form */
 } XFSattrvalue1_t;
 
-#define	MIN_FORMAT1_ATTR_LEN	( sizeof(XFSattrvalue1_t) + \
-				  sizeof(XFSattrregion_t) )
+#define	MIN_FORMAT1_ATTR_LEN	(sizeof(XFSattrvalue1_t) + \
+				  sizeof(XFSattrregion_t))
 
 /* supported fsys values */
 
-/* XFS DMAPI (w/o MMR ) */
+/* XFS DMAPI (w/o MMR) */
 #define	FSYS_TYPE_XFS		1
 
 /* supported version values */
@@ -111,13 +111,13 @@ typedef	struct {
  /* Interesting bit combinations within the bs_dmevmask field of xfs_bstat_t:
  * OFL, UNM, and PAR files have exactly these bits set.
  * DUL and MIG files have all but the DM_EVENT_READ bit set */
-#define DMF_EV_BITS	( (1<<DM_EVENT_DESTROY) | \
+#define DMF_EV_BITS	((1<<DM_EVENT_DESTROY) | \
 			  (1<<DM_EVENT_READ)    | \
 			  (1<<DM_EVENT_WRITE)   | \
-			  (1<<DM_EVENT_TRUNCATE) )
+			  (1<<DM_EVENT_TRUNCATE))
 
 /* OFL file's managed region event flags */
-#define DMF_MR_FLAGS	( 0x1 | 0x2 | 0x4 )
+#define DMF_MR_FLAGS	(0x1 | 0x2 | 0x4)
 
 /* The following definitions provide the internal format of the hsm_fs_ctxt_t
    and hsm_f_ctxt_t structures, respectively.
@@ -476,7 +476,7 @@ const	xfs_bstat_t	*statp)
 	if ((statp->bs_xflags & XFS_XFLAG_HASATTR) == 0) {
 		return 0;	/* no DMF attribute exists */
 	}
-	if ((statp->bs_dmevmask & DMF_EV_BITS) == 0 ) {
+	if ((statp->bs_dmevmask & DMF_EV_BITS) == 0) {
 		return 0;	/* no interesting DMAPI bits set */
 	}
 
@@ -735,8 +735,8 @@ HsmAddNewAttribute(
 	if (dmfattr1p->version == DMF_ATTR_FORMAT_1 &&
 	    msb_load(dmfattr1p->sitetag, sizeof(dmfattr1p->sitetag)) != 0) {
 		XFSattrregion_t *reg;
-		reg = (XFSattrregion_t *)( dmf_f_ctxtp->attrval +
-				           sizeof(XFSattrvalue1_t) );
+		reg = (XFSattrregion_t *)(dmf_f_ctxtp->attrval +
+				           sizeof(XFSattrvalue1_t));
 		dmf_f_ctxtp->attrlen = MIN_FORMAT1_ATTR_LEN;
 
 		/* make one offline region the size of the whole file */
@@ -794,7 +794,7 @@ HsmBeginRestoreFile(
 	 * remove the attribute when the file is completed.
 	 */
 	*hsm_flagp = 0;
-	if ( bstatp->bs_dmevmask && bstatp->bs_xflags & XFS_XFLAG_HASATTR ) {
+	if (bstatp->bs_dmevmask && bstatp->bs_xflags & XFS_XFLAG_HASATTR) {
 		memset(&dmattr, 0, sizeof(XFSattrvalue0_t));
 		dmattr.fsys = FSYS_TYPE_XFS;
 		msb_store(dmattr.state, DMF_ST_NOMIGR, sizeof(dmattr.state));
@@ -871,7 +871,7 @@ HsmEndRestoreFile(
 	 */
 	if (*hsm_flagp) {
 		int rv;
-		rv = attr_removef( fd, DMF_ATTR_NAME , ATTR_ROOT );
+		rv = attr_removef(fd, DMF_ATTR_NAME , ATTR_ROOT);
 		if (rv) {
 			mlog(MLOG_NORMAL | MLOG_WARNING,
 			     _("error removing temp DMF attr on %s: %s\n"),
diff --git a/common/inventory.c b/common/inventory.c
index 552f594..9ebe461 100644
--- a/common/inventory.c
+++ b/common/inventory.c
@@ -43,64 +43,64 @@ int sesslock_fd = -1;
 /*----------------------------------------------------------------------*/
 
 inv_idbtoken_t
-inv_open( inv_predicate_t bywhat, void *pred )
+inv_open(inv_predicate_t bywhat, void *pred)
 {
 
 	int fd, stobjfd, num;
-	char uuname[ INV_STRLEN ];
+	char uuname[INV_STRLEN];
 	inv_idbtoken_t tok = INV_TOKEN_NULL;
 	invt_sescounter_t *sescnt = 0;
 
 	int index = 0;
 
-	assert ( pred );
-	if ((fd = init_idb ( pred, bywhat, uuname, &tok )) < 0 )
+	assert (pred);
+	if ((fd = init_idb (pred, bywhat, uuname, &tok)) < 0)
 		return tok;
 
 	/* XXX also, see if it is too full. if so, make another and leave a
 	   reference to the new file in the old one */
 
-	stobjfd = get_storageobj( fd, &index );
-	if ( stobjfd < 0 ) {
-		close( fd );
-		close( sesslock_fd );
+	stobjfd = get_storageobj(fd, &index);
+	if (stobjfd < 0) {
+		close(fd);
+		close(sesslock_fd);
 		sesslock_fd = -1;
 		return INV_TOKEN_NULL;
 	}
 
-	assert ( index > 0 );
+	assert (index > 0);
 
 	/* Now we need to make sure that this has enough space */
-	num = GET_SESCOUNTERS( stobjfd, &sescnt );
-	if ( num < 0 ) {
-		close( fd );
-		close( stobjfd );
-		close( sesslock_fd );
+	num = GET_SESCOUNTERS(stobjfd, &sescnt);
+	if (num < 0) {
+		close(fd);
+		close(stobjfd);
+		close(sesslock_fd);
 		sesslock_fd = -1;
 		return INV_TOKEN_NULL;
 	}
-	/* create another storage object ( and, an inv_index entry for it too )
+	/* create another storage object (and, an inv_index entry for it too)
 	   if we've filled this one up */
-	if ( (uint) num >= sescnt->ic_maxnum ) {
+	if ((uint) num >= sescnt->ic_maxnum) {
 #ifdef INVT_DEBUG
-		printf("$ creating a new storage obj & index entry. \n" );
+		printf("$ creating a new storage obj & index entry. \n");
 #endif
 		close (stobjfd);
 
-		stobjfd = create_invindex_entry( &tok, fd, uuname, BOOL_FALSE );
-		free ( sescnt );
-		if ( stobjfd < 0 ) {
-			close( fd );
-			close( sesslock_fd );
+		stobjfd = create_invindex_entry(&tok, fd, uuname, BOOL_FALSE);
+		free (sescnt);
+		if (stobjfd < 0) {
+			close(fd);
+			close(sesslock_fd);
 			sesslock_fd = -1;
 			return INV_TOKEN_NULL;
 		}
 		return tok;
 	}
 
-	free ( sescnt );
-	tok = get_token( fd, stobjfd );
-	tok->d_invindex_off = INVINDEX_HDR_OFFSET( index - 1 );
+	free (sescnt);
+	tok = get_token(fd, stobjfd);
+	tok->d_invindex_off = INVINDEX_HDR_OFFSET(index - 1);
 
 	return tok;
 
@@ -117,12 +117,12 @@ inv_open( inv_predicate_t bywhat, void *pred )
 
 
 bool_t
-inv_close( inv_idbtoken_t tok )
+inv_close(inv_idbtoken_t tok)
 {
-	close ( tok->d_invindex_fd );
-	close ( tok->d_stobj_fd );
-	destroy_token( tok );
-	close( sesslock_fd );
+	close (tok->d_invindex_fd);
+	close (tok->d_stobj_fd);
+	destroy_token(tok);
+	close(sesslock_fd);
 	sesslock_fd = -1;
 
 	return BOOL_TRUE;
@@ -144,15 +144,15 @@ bool_t
 inv_lasttime_level_lessthan(
 	inv_idbtoken_t  tok,
 	u_char level,
-	time32_t **tm )
+	time32_t **tm)
 {
 	int 	rval;
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
-	rval =  search_invt( tok, level, (void **) tm,
-			 (search_callback_t) tm_level_lessthan );
+	rval =  search_invt(tok, level, (void **) tm,
+			 (search_callback_t) tm_level_lessthan);
 
-	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 }
 
 
@@ -169,15 +169,15 @@ bool_t
 inv_lastsession_level_lessthan(
 	inv_idbtoken_t 	tok,
 	u_char		level,
-	inv_session_t 	**ses )
+	inv_session_t 	**ses)
 {
 	int 	rval;
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
-	rval = search_invt( tok, level, (void **) ses,
-			  (search_callback_t) lastsess_level_lessthan );
+	rval = search_invt(tok, level, (void **) ses,
+			  (search_callback_t) lastsess_level_lessthan);
 
-	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -196,14 +196,14 @@ bool_t
 inv_lastsession_level_equalto(
 	inv_idbtoken_t 	tok,
 	u_char		level,
-	inv_session_t	**ses )
+	inv_session_t	**ses)
 {
 	int 	rval;
-	assert ( tok != INV_TOKEN_NULL );
-	rval = search_invt( tok, level, (void **) ses,
-			  (search_callback_t) lastsess_level_equalto );
+	assert (tok != INV_TOKEN_NULL);
+	rval = search_invt(tok, level, (void **) ses,
+			  (search_callback_t) lastsess_level_equalto);
 
-	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -229,7 +229,7 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath )
+	char		*devpath)
 {
 	invt_session_t *ses;
 	int		fd;
@@ -238,11 +238,11 @@ inv_writesession_open(
 	invt_seshdr_t  	hdr;
 	inv_sestoken_t	sestok;
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( sesid && fsid && mntpt && devpath );
+	assert (tok != INV_TOKEN_NULL);
+	assert (sesid && fsid && mntpt && devpath);
 
-	if ( ! ( tok->d_update_flag & FSTAB_UPDATED ) ) {
-		if ( put_fstab_entry( fsid, mntpt, devpath ) < 0 ) {
+	if (! (tok->d_update_flag & FSTAB_UPDATED)) {
+		if (put_fstab_entry(fsid, mntpt, devpath) < 0) {
 			printf ("put_fstab_entry :(\n");
 			return INV_TOKEN_NULL;
 		}
@@ -251,14 +251,14 @@ inv_writesession_open(
 
 
 
-	ses = (invt_session_t *) calloc( 1, sizeof( invt_session_t ) );
+	ses = (invt_session_t *) calloc(1, sizeof(invt_session_t));
 
 	/* copy the session information to store */
-	memcpy( &ses->s_sesid, sesid, sizeof( uuid_t ) );
-	memcpy( &ses->s_fsid, fsid, sizeof( uuid_t ) );
-	strcpy( ses->s_label, label );
-	strcpy( ses->s_mountpt, mntpt );
-	strcpy( ses->s_devpath, devpath );
+	memcpy(&ses->s_sesid, sesid, sizeof(uuid_t));
+	memcpy(&ses->s_fsid, fsid, sizeof(uuid_t));
+	strcpy(ses->s_label, label);
+	strcpy(ses->s_mountpt, mntpt);
+	strcpy(ses->s_devpath, devpath);
 	ses->s_max_nstreams = nstreams;
 
 
@@ -266,48 +266,48 @@ inv_writesession_open(
 
 	fd = tok->d_stobj_fd;
 
-	assert ( fd > 0 );
+	assert (fd > 0);
 
 	hdr.sh_time = time;
 	hdr.sh_level = level;
 	/* sh_streams_off and sh_sess_off will be set in create_session() */
 
-	sestok = get_sesstoken( tok );
+	sestok = get_sesstoken(tok);
 
 	/* we need to put the new session in the appropriate place in
 	   storage object. So first find out howmany sessions are there */
 
-	INVLOCK( fd, LOCK_EX );
-	if ( GET_SESCOUNTERS( fd, &sescnt) < 0 ) {
-		free ( ses );
-		free ( sestok );
-		INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_EX);
+	if (GET_SESCOUNTERS(fd, &sescnt) < 0) {
+		free (ses);
+		free (sestok);
+		INVLOCK(fd, LOCK_UN);
 		return INV_TOKEN_NULL;
 	}
 
 	/* create the writesession, and get ready for the streams to come
 	   afterwards */
-	rval = create_session( sestok, fd, sescnt, ses, &hdr );
+	rval = create_session(sestok, fd, sescnt, ses, &hdr);
 	assert (rval > 0);
 
 
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
 	sestok->sd_sesstime = time;
 
-	if ( tok->d_update_flag & NEW_INVINDEX ) {
-		if ( put_sesstime( sestok, INVT_STARTTIME ) < 0 ) {
+	if (tok->d_update_flag & NEW_INVINDEX) {
+		if (put_sesstime(sestok, INVT_STARTTIME) < 0) {
 			printf ("put_starttime :(\n");
 			return INV_TOKEN_NULL;
 		}
 		tok->d_update_flag &= ~(NEW_INVINDEX);
 	}
 
-	free ( ses );
-	free ( sescnt );
+	free (ses);
+	free (sescnt);
 
 
-	return ( rval < 0 )? INV_TOKEN_NULL: sestok;
+	return (rval < 0)? INV_TOKEN_NULL: sestok;
 }
 
 
@@ -322,20 +322,20 @@ inv_writesession_open(
 
 
 bool_t
-inv_writesession_close( inv_sestoken_t tok )
+inv_writesession_close(inv_sestoken_t tok)
 {
 	int		rval;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	/* now update end_time in the inv index header */
-	rval = put_sesstime( tok, INVT_ENDTIME );
+	rval = put_sesstime(tok, INVT_ENDTIME);
 
-	memset( tok, 0, sizeof( invt_sesdesc_entry_t ) );
+	memset(tok, 0, sizeof(invt_sesdesc_entry_t));
 
-	free ( tok );
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -348,7 +348,7 @@ inv_writesession_close( inv_sestoken_t tok )
 /*----------------------------------------------------------------------*/
 inv_stmtoken_t
 inv_stream_open(
-	inv_sestoken_t tok )
+	inv_sestoken_t tok)
 {
 	inv_stmtoken_t stok;
 	invt_stream_t  stream;
@@ -356,14 +356,14 @@ inv_stream_open(
 	invt_seshdr_t  seshdr;
 	int fd;
 
-	assert ( tok != INV_TOKEN_NULL );
+	assert (tok != INV_TOKEN_NULL);
 
 	stream.st_nmediafiles = 0;
 	stream.st_interrupted = BOOL_FALSE;
 
 
 	/* XXX yukk... make the token descriptors not pointers */
-	stok = ( inv_stmtoken_t ) malloc( sizeof( invt_strdesc_entry_t ) );
+	stok = (inv_stmtoken_t) malloc(sizeof(invt_strdesc_entry_t));
 
 	stok->md_sesstok = tok;
 	stok->md_lastmfile = 0;
@@ -373,12 +373,12 @@ inv_stream_open(
 
 	sess_lock();
 
-	INVLOCK( fd, LOCK_SH );
+	INVLOCK(fd, LOCK_SH);
 	/* get the session header first */
-	if ( GET_REC_NOLOCK( fd, &seshdr, sizeof( invt_seshdr_t ),
-			     tok->sd_sesshdr_off ) <= 0 ) {
-		free ( stok );
-		INVLOCK( fd, LOCK_UN );
+	if (GET_REC_NOLOCK(fd, &seshdr, sizeof(invt_seshdr_t),
+			     tok->sd_sesshdr_off) <= 0) {
+		free (stok);
+		INVLOCK(fd, LOCK_UN);
 		sess_unlock();
 		return INV_TOKEN_NULL;
 	}
@@ -386,33 +386,33 @@ inv_stream_open(
 
 
 	/* XXX Have one func that gives both seshdr and session */
-	if ( GET_REC_NOLOCK( fd, &ses, sizeof( invt_session_t ),
-			     tok->sd_session_off ) <= 0 ) {
-		free ( stok );
-		INVLOCK( fd, LOCK_UN );
+	if (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
+			     tok->sd_session_off) <= 0) {
+		free (stok);
+		INVLOCK(fd, LOCK_UN);
 		sess_unlock();
 		return INV_TOKEN_NULL;
 	}
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	if ( ses.s_cur_nstreams < ses.s_max_nstreams ) {
+	if (ses.s_cur_nstreams < ses.s_max_nstreams) {
 		/* this is where this stream header will be written to */
-		stok->md_stream_off = (off64_t) (sizeof( invt_stream_t ) *
-					         ses.s_cur_nstreams )
+		stok->md_stream_off = (off64_t) (sizeof(invt_stream_t) *
+					         ses.s_cur_nstreams)
 			                         + seshdr.sh_streams_off;
 		ses.s_cur_nstreams++;
 
 		/* write it back. this locks and unlocks fd EXclusively */
-		if ( PUT_REC( fd, &ses, sizeof( ses ),
-			      tok->sd_session_off ) < 0 ) {
-			free ( stok );
+		if (PUT_REC(fd, &ses, sizeof(ses),
+			      tok->sd_session_off) < 0) {
+			free (stok);
 			sess_unlock();
 			return INV_TOKEN_NULL;
 		}
 	} else {
 		fprintf(stderr, "Cant create more than %d streams. Max'd out..\n",
-			ses.s_cur_nstreams );
-		free ( stok );
+			ses.s_cur_nstreams);
+		free (stok);
 		sess_unlock();
 		return INV_TOKEN_NULL;
 	}
@@ -421,9 +421,9 @@ inv_stream_open(
 	stream.st_firstmfile = stream.st_lastmfile = stok->md_stream_off;
 
 	/* now put the stream header on to the disk */
-	if ( PUT_REC( fd, &stream, sizeof( invt_stream_t ),
-		      stok->md_stream_off ) < 0 ) {
-		free ( stok );
+	if (PUT_REC(fd, &stream, sizeof(invt_stream_t),
+		      stok->md_stream_off) < 0) {
+		free (stok);
 		return INV_TOKEN_NULL;
 	}
 
@@ -442,27 +442,27 @@ inv_stream_open(
 bool_t
 inv_stream_close(
 		inv_stmtoken_t	tok,
-		bool_t wasinterrupted )
+		bool_t wasinterrupted)
 {
 	invt_stream_t strm;
 	int fd = tok->md_sesstok->sd_invtok->d_stobj_fd;
 	int rval;
 	bool_t dowrite = BOOL_FALSE;
 
-	INVLOCK( fd, LOCK_EX );
-	if ((rval = GET_REC_NOLOCK( fd, &strm, sizeof( invt_stream_t ),
-			       tok->md_stream_off )) < 0 )
+	INVLOCK(fd, LOCK_EX);
+	if ((rval = GET_REC_NOLOCK(fd, &strm, sizeof(invt_stream_t),
+			       tok->md_stream_off)) < 0)
 		goto end;   /* eek :-)   */
 
-	if ( strm.st_interrupted != wasinterrupted ) {
+	if (strm.st_interrupted != wasinterrupted) {
 		strm.st_interrupted = wasinterrupted;
 		dowrite = BOOL_TRUE;
 	}
 
 	/* get the last media file to figure out what our last ino was.
 	   we have a pointer to that in the stream token */
-	if ( tok->md_lastmfile ){
-		if ( strm.st_endino.ino != tok->md_lastmfile->mf_endino.ino ||
+	if (tok->md_lastmfile){
+		if (strm.st_endino.ino != tok->md_lastmfile->mf_endino.ino ||
 		     strm.st_endino.offset != tok->md_lastmfile->mf_endino.offset){
 			printf("Warning: endinos dont match ! \n");
 			dowrite = BOOL_TRUE;
@@ -475,13 +475,13 @@ inv_stream_close(
 				      tok->md_stream_off);
 	}
  end:
-	INVLOCK( fd, LOCK_UN );
+	INVLOCK(fd, LOCK_UN);
 
-	free ( tok->md_lastmfile );
-	memset( tok, 0, sizeof( invt_strdesc_entry_t ) );
-	free ( tok );
+	free (tok->md_lastmfile);
+	memset(tok, 0, sizeof(invt_strdesc_entry_t));
+	free (tok);
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 }
 
 
@@ -501,36 +501,36 @@ inv_put_mediafile(
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
 	xfs_ino_t	endino,
-	off64_t		endino_offset )
+	off64_t		endino_offset)
 {
 	invt_mediafile_t *mf;
 	int 		 rval;
 
 
-	assert ( tok != INV_TOKEN_NULL );
-	assert ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
-	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
+	assert (tok != INV_TOKEN_NULL);
+	assert (tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED);
+	assert (tok->md_sesstok->sd_invtok->d_stobj_fd >= 0);
 
-	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
+	mf = (invt_mediafile_t *) calloc(1, sizeof(invt_mediafile_t));
 
 	/* copy the media file information */
-	memcpy( &mf->mf_moid, moid, sizeof( uuid_t ) );
-	strcpy( mf->mf_label, label );
+	memcpy(&mf->mf_moid, moid, sizeof(uuid_t));
+	strcpy(mf->mf_label, label);
 	mf->mf_startino.ino = startino;
 	mf->mf_startino.offset = startino_offset;
 	mf->mf_endino.ino = endino;
 	mf->mf_endino.offset = endino_offset;
 
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX );
-	rval = put_mediafile( tok, mf );
-	INVLOCK( tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN );
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_EX);
+	rval = put_mediafile(tok, mf);
+	INVLOCK(tok->md_sesstok->sd_invtok->d_stobj_fd, LOCK_UN);
 
 	/* we dont free the mfile here. we always keep the last mfile
 	   around, inside the inv_stmtoken, and when we add a new mfile,
 	   we free the previous one. The last one is freed in stream_close()
 	   */
 
-	return ( rval < 0 ) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
@@ -543,14 +543,14 @@ inv_put_mediafile(
 /* that the client (dump) knows that these shouldn't be dumped alongwith*/
 /* regular files.                                                       */
 /*                                                                      */
-/* foreach ( fs in fstab )                                              */
-/* 	foreach ( index in InvIndex )                                 */
+/* foreach (fs in fstab)                                              */
+/* 	foreach (index in InvIndex)                                 */
 /*          get                                                         */
 /*----------------------------------------------------------------------*/
 
 int
 inv_get_inolist(
-	inv_inolist_t 	**inolist )
+	inv_inolist_t 	**inolist)
 {
 	invt_entry_t	*iarr = NULL;
 	invt_counter_t	*icnt = NULL;
@@ -560,47 +560,47 @@ inv_get_inolist(
 
 #ifdef NOTDEF
 	*inolist = NULL;
-	curitem = malloc( sizeof( inv_inolist_t ) );
+	curitem = malloc(sizeof(inv_inolist_t));
 
 	/* get the array of all indices in the invindex */
-	if ( ( nindices = GET_ALLHDRS_N_CNTS( invfd, (void **)&iarr,
+	if ((nindices = GET_ALLHDRS_N_CNTS(invfd, (void **)&iarr,
 					      (void **)&icnt,
-					      sizeof( invt_entry_t ),
-					      sizeof( invt_counter_t ))
-	      ) <= 0 ) {
+					      sizeof(invt_entry_t),
+					      sizeof(invt_counter_t))
+	      ) <= 0) {
 		return -1;
 	}
-	free( icnt );
+	free(icnt);
 
 	/* attach all the StObjs */
 	for (i = nindices - 1; i >= 0; i--) {
-		if ( stat64( iarr[i].ie_filename, &statbuf ) < 0 ) {
-			perror( iarr[i].ie_filename );
+		if (stat64(iarr[i].ie_filename, &statbuf) < 0) {
+			perror(iarr[i].ie_filename);
 			return -1;
 		}
 
-		create_inolist_item( curitem, statbuf.st_ino );
+		create_inolist_item(curitem, statbuf.st_ino);
 	}
 	/* The inventory index */
-	if ( fstat64( invfd, &statbuf ) ){
-		perror( "InvIndex file" );
+	if (fstat64(invfd, &statbuf)){
+		perror("InvIndex file");
 		return -1;
 	}
-	create_inolist_item( curitem, statbuf.st_ino );
+	create_inolist_item(curitem, statbuf.st_ino);
 
 	/* fstab */
-	if ( stat64( INV_FSTAB, &statbuf ) < 0 ) {
-			perror( INV_FSTAB );
+	if (stat64(INV_FSTAB, &statbuf) < 0) {
+			perror(INV_FSTAB);
 			return -1;
 		}
-	create_inolist_item( curitem, statbuf.st_ino );
+	create_inolist_item(curitem, statbuf.st_ino);
 
 	/* sesslock file */
-	if ( stat64( SESSLOCK_FILE, &statbuf ) < 0 ) {
-			perror( SESSLOCK_FILE );
+	if (stat64(SESSLOCK_FILE, &statbuf) < 0) {
+			perror(SESSLOCK_FILE);
 			return -1;
 		}
-	create_inolist_item( curitem, statbuf.st_ino );
+	create_inolist_item(curitem, statbuf.st_ino);
 #endif
 
 	return 1;
@@ -627,10 +627,10 @@ bool_t
 inv_get_session(
 	inv_sestoken_t		tok,
 	void		      **bufpp,	/* buf to fill */
-	size_t		       *bufszp )/* size of that buffer */
+	size_t		       *bufszp)/* size of that buffer */
 {
-	assert( tok != INV_TOKEN_NULL );
-	assert( tok->sd_invtok );
+	assert(tok != INV_TOKEN_NULL);
+	assert(tok->sd_invtok);
 
 	/* First get the session header, and the session information. Then
 	   we can figure out how much space to allocate */
@@ -646,13 +646,13 @@ inv_get_session(
 bool_t
 inv_DEBUG_printallsessions(
 	inv_idbtoken_t 	tok,
-	inv_session_t	**ses )
+	inv_session_t	**ses)
 {
 	int 	rval;
-	rval = search_invt( tok, 0, (void **) ses,
-			  (search_callback_t) DEBUG_displayallsessions );
+	rval = search_invt(tok, 0, (void **) ses,
+			  (search_callback_t) DEBUG_displayallsessions);
 
-	return ( rval < 0) ? BOOL_FALSE: BOOL_TRUE;
+	return (rval < 0) ? BOOL_FALSE: BOOL_TRUE;
 
 }
 
diff --git a/common/inventory.h b/common/inventory.h
index d5c182a..599fc25 100644
--- a/common/inventory.h
+++ b/common/inventory.h
@@ -144,12 +144,12 @@ typedef struct invt_strdesc_entry	*inv_stmtoken_t;
 extern inv_idbtoken_t
 inv_open(
 	 inv_predicate_t bywhat, /* BY_UUID, BY_MOUNTPT, BY_DEVPATH */
-	 void 		 *pred );/* uuid_t *,char * mntpt, or char *dev */
+	 void 		 *pred);/* uuid_t *,char * mntpt, or char *dev */
 
 
 extern bool_t
 inv_close(
-	inv_idbtoken_t tok );
+	inv_idbtoken_t tok);
 
 
 extern inv_sestoken_t
@@ -162,20 +162,20 @@ inv_writesession_open(
 	uint		nstreams,
 	time32_t	time,
 	char		*mntpt,
-	char		*devpath );
+	char		*devpath);
 
 extern bool_t
 inv_writesession_close(
-	inv_sestoken_t  tok );
+	inv_sestoken_t  tok);
 
 extern inv_stmtoken_t
 inv_stream_open(
-	inv_sestoken_t 	tok );
+	inv_sestoken_t 	tok);
 
 extern bool_t
 inv_stream_close(
 	inv_stmtoken_t	tok,
-	bool_t 		wasinterrupted );
+	bool_t 		wasinterrupted);
 
 extern bool_t
 inv_put_mediafile(
@@ -185,7 +185,7 @@ inv_put_mediafile(
 	xfs_ino_t	startino,
 	off64_t		startino_offset,
 	xfs_ino_t	endino,
-	off64_t		endino_offset );
+	off64_t		endino_offset);
 
 /* lasttime_level_lessthan - finds the time of the last dump of the
  * specified file system at a level less than the specified level.
@@ -196,58 +196,58 @@ extern bool_t
 inv_lasttime_level_lessthan(
 	inv_idbtoken_t 		tok,
 	u_char  		level,
-	time32_t		**time );/* out */
+	time32_t		**time);/* out */
 
 extern bool_t
 inv_lastsession_level_lessthan(
 	inv_idbtoken_t 		tok,
 	u_char  		level,
-	inv_session_t		**ses );/* out */
+	inv_session_t		**ses);/* out */
 
 extern bool_t
 inv_lastsession_level_equalto(
 	inv_idbtoken_t 		tok,
 	u_char  		level,
-	inv_session_t		**ses );/* out */
+	inv_session_t		**ses);/* out */
 
 extern bool_t
 inv_get_inolist(
-	inv_inolist_t 		**inolist );
+	inv_inolist_t 		**inolist);
 
 /* For dumping the inventory once a dump is done. */
 extern bool_t
 inv_get_session(
 	inv_sestoken_t		tok,
 	void		      **bufpp,		/* out */
-	size_t		       *bufszp );	/* out */
+	size_t		       *bufszp);	/* out */
 
 /* To reconstruct a compelete inventory from dumped inventories */
 extern bool_t
 inv_put_session(
 	inv_idbtoken_t		tok,
 	void		       *bufp,
-	size_t		        bufsz );
+	size_t		        bufsz);
 
 #ifdef DEBUG
 
 bool_t
 inv_DEBUG_printallsessions(
 	inv_idbtoken_t 	tok,
-	inv_session_t	**ses );
+	inv_session_t	**ses);
 
 #endif /* ifdef DEBUG */
 
 extern int
-inv_setup_base( void );
+inv_setup_base(void);
 
 extern char *
-inv_dirpath( void );
+inv_dirpath(void);
 
 extern char *
-inv_fstab( void );
+inv_fstab(void);
 
 extern char *
-inv_lockfile( void );
+inv_lockfile(void);
 
 
 #endif /* INVENTORY_H */
diff --git a/common/lock.c b/common/lock.c
index 9826581..216d202 100644
--- a/common/lock.c
+++ b/common/lock.c
@@ -27,27 +27,27 @@
 static qlockh_t lock_qlockh = QLOCKH_NULL;
 
 bool_t
-lock_init( void )
+lock_init(void)
 {
 	/* initialization sanity checks
 	 */
-	assert( lock_qlockh == QLOCKH_NULL );
+	assert(lock_qlockh == QLOCKH_NULL);
 
 	/* allocate a qlock
 	 */
-	lock_qlockh = qlock_alloc( QLOCK_ORD_CRIT );
+	lock_qlockh = qlock_alloc(QLOCK_ORD_CRIT);
 
 	return BOOL_TRUE;
 }
 
 void
-lock( void )
+lock(void)
 {
-	qlock_lock( lock_qlockh );
+	qlock_lock(lock_qlockh);
 }
 
 void
-unlock( void )
+unlock(void)
 {
-	qlock_unlock( lock_qlockh );
+	qlock_unlock(lock_qlockh);
 }
diff --git a/common/lock.h b/common/lock.h
index 1dab2ae..97460bb 100644
--- a/common/lock.h
+++ b/common/lock.h
@@ -18,10 +18,10 @@
 #ifndef LOCK_H
 #define LOCK_H
 
-extern bool_t lock_init( void );
+extern bool_t lock_init(void);
 
-extern void lock( void );
+extern void lock(void);
 
-extern void unlock( void );
+extern void unlock(void);
 
 #endif /* LOCK_H */
diff --git a/common/main.c b/common/main.c
index 0c23eb4..1edfae4 100644
--- a/common/main.c
+++ b/common/main.c
@@ -84,27 +84,27 @@ extern void rmt_turnonmsgs(int);
 
 /* forward declarations of locally defined global functions ******************/
 
-void usage( void );
-bool_t preemptchk( int );
+void usage(void);
+bool_t preemptchk(int);
 
 
 /* forward declarations of locally defined static functions ******************/
 
-static bool_t loadoptfile( int *argcp, char ***argvp );
-static char * stripquotes( char *p );
-static void shiftleftby1( char *p, char *endp );
-static void sighandler( int );
-static int childmain( void * );
-static bool_t sigint_dialog( void );
-static char *sigintstr( void );
+static bool_t loadoptfile(int *argcp, char ***argvp);
+static char * stripquotes(char *p);
+static void shiftleftby1(char *p, char *endp);
+static void sighandler(int);
+static int childmain(void *);
+static bool_t sigint_dialog(void);
+static char *sigintstr(void);
 #ifdef DUMP
-static bool_t set_rlimits( void );
+static bool_t set_rlimits(void);
 #endif /* DUMP */
 #ifdef RESTORE
-static bool_t set_rlimits( size64_t * );
+static bool_t set_rlimits(size64_t *);
 #endif /* RESTORE */
-static char *sig_numstring( int num );
-static char *strpbrkquotes( char *p, const char *sep );
+static char *sig_numstring(int num);
+static char *strpbrkquotes(char *p, const char *sep);
 
 
 /* definition of locally defined global variables ****************************/
@@ -143,7 +143,7 @@ static time32_t progrpt_deadline;
 
 
 int
-main( int argc, char *argv[] )
+main(int argc, char *argv[])
 {
 	int c;
 #ifdef DUMP
@@ -168,18 +168,18 @@ main( int argc, char *argv[] )
 
 	/* sanity checks
 	 */
-	assert( sizeof( char_t ) == 1 );
-	assert( sizeof( u_char_t ) == 1 );
-	assert( sizeof( int32_t ) == 4 );
-	assert( sizeof( uint32_t ) == 4 );
-	assert( sizeof( size32_t ) == 4 );
-	assert( sizeof( int64_t ) == 8 );
-	assert( sizeof( uint64_t ) == 8 );
-	assert( sizeof( size64_t ) == 8 );
+	assert(sizeof(char_t) == 1);
+	assert(sizeof(u_char_t) == 1);
+	assert(sizeof(int32_t) == 4);
+	assert(sizeof(uint32_t) == 4);
+	assert(sizeof(size32_t) == 4);
+	assert(sizeof(int64_t) == 8);
+	assert(sizeof(uint64_t) == 8);
+	assert(sizeof(size64_t) == 8);
 
 	/* record the command name used to invoke
 	 */
-	progname = argv[ 0 ];
+	progname = argv[0];
 
 	/* setup I18N support */
 	setlocale(LC_ALL, "");
@@ -193,22 +193,22 @@ main( int argc, char *argv[] )
 	/* Get the parent's pthread id. will be used
 	 * to differentiate parent from children.
 	 */
-	parenttid = pthread_self( );
+	parenttid = pthread_self();
 	rval = atexit(mlog_exit_flush);
 	assert(rval == 0);
 
 	/* pre-scan the command line for the option file option.
 	 * if found, create a new argv.
 	 */
-	ok = loadoptfile( &argc, &argv );
-	if ( ! ok ) {
+	ok = loadoptfile(&argc, &argv);
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_OPT);
 	}
 
 	/* initialize message logging (stage 1)
 	 */
-	ok = mlog_init1( argc, argv );
-	if ( ! ok ) {
+	ok = mlog_init1(argc, argv);
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 	/* scan the command line for the info, progress
@@ -220,48 +220,48 @@ main( int argc, char *argv[] )
 	progrpt_enabledpr = BOOL_FALSE;
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
                 case GETOPT_MINSTACKSZ:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
 			errno = 0;
-			tmpstacksz = strtoull( optarg, 0, 0 );
-			if ( tmpstacksz == UINT64_MAX
+			tmpstacksz = strtoull(optarg, 0, 0);
+			if (tmpstacksz == UINT64_MAX
 			     ||
-			     errno == ERANGE ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			     errno == ERANGE) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument (%s) invalid\n"),
 				      c,
-				      optarg );
-				usage( );
+				      optarg);
+				usage();
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
 			minstacksz = tmpstacksz;
 			break;
                 case GETOPT_MAXSTACKSZ:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
 			errno = 0;
-			tmpstacksz = strtoull( optarg, 0, 0 );
-			if ( tmpstacksz == UINT64_MAX
+			tmpstacksz = strtoull(optarg, 0, 0);
+			if (tmpstacksz == UINT64_MAX
 			     ||
-			     errno == ERANGE ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			     errno == ERANGE) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument (%s) invalid\n"),
 				      c,
-				      optarg );
-				usage( );
+				      optarg);
+				usage();
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
 			maxstacksz = tmpstacksz;
@@ -271,15 +271,15 @@ main( int argc, char *argv[] )
 			mlog_exit_hint(RV_USAGE);
 			break;
 		case GETOPT_PROGRESS:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
-			progrpt_interval = ( time32_t )atoi( optarg );
-			if ( progrpt_interval > 0 ) {
+			progrpt_interval = (time32_t)atoi(optarg);
+			if (progrpt_interval > 0) {
 				progrpt_enabledpr = BOOL_TRUE;
 			} else {
 				progrpt_enabledpr = BOOL_FALSE;
@@ -290,8 +290,8 @@ main( int argc, char *argv[] )
 
 	/* sanity check resultant stack size limits
 	 */
-	if ( minstacksz > maxstacksz ) {
-		mlog( MLOG_NORMAL
+	if (minstacksz > maxstacksz) {
+		mlog(MLOG_NORMAL
 		      |
 		      MLOG_ERROR
 		      |
@@ -301,29 +301,29 @@ main( int argc, char *argv[] )
 		      _("specified minimum stack size is larger than maximum: "
 		      "min is 0x%llx,  max is 0x%llx\n"),
 		      minstacksz,
-		      maxstacksz );
+		      maxstacksz);
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
-	if ( argc == 1 ) {
+	if (argc == 1) {
 		infoonly = BOOL_TRUE;
 	}
 
 	/* set a progress report deadline to allow preemptchk() to
 	 * report
 	 */
-	if ( progrpt_enabledpr ) {
-		progrpt_deadline = time( 0 ) + progrpt_interval;
+	if (progrpt_enabledpr) {
+		progrpt_deadline = time(0) + progrpt_interval;
 	}
 
 	/* intitialize the stream manager
 	 */
-	stream_init( );
+	stream_init();
 
 #ifdef DUMP
 	/* set the memory limits to their appropriate values.
 	 */
-	ok = set_rlimits( );
+	ok = set_rlimits();
 #endif /* DUMP */
 #ifdef RESTORE
 	/* set the memory limits to their appropriate values. this is necessary
@@ -331,89 +331,89 @@ main( int argc, char *argv[] )
 	 * also determines maximum vm, which will be budgeted among the
 	 * various abstractions.
 	 */
-	ok = set_rlimits( &vmsz );
+	ok = set_rlimits(&vmsz);
 #endif /* RESTORE */
-	if ( ! ok ) {
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
 	/* initialize message logging (stage 2) - allocate the message lock
 	 */
-	ok = mlog_init2( );
-	if ( ! ok ) {
+	ok = mlog_init2();
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
 	/* initialize the critical region lock
 	 */
-	lock_init( );
+	lock_init();
 	rmt_turnonmsgs(1); /* turn on WARNING msgs for librmt */
 
-	mlog( MLOG_NITTY + 1, "INTGENMAX == %ld (0x%lx)\n", INTGENMAX, INTGENMAX );
-	mlog( MLOG_NITTY + 1, "UINTGENMAX == %lu (0x%lx)\n", UINTGENMAX, UINTGENMAX );
-	mlog( MLOG_NITTY + 1, "OFF64MAX == %lld (0x%llx)\n", OFF64MAX, OFF64MAX );
-	mlog( MLOG_NITTY + 1, "OFFMAX == %ld (0x%lx)\n", OFFMAX, OFFMAX );
-	mlog( MLOG_NITTY + 1, "SIZEMAX == %lu (0x%lx)\n", SIZEMAX, SIZEMAX );
-	mlog( MLOG_NITTY + 1, "INOMAX == %lu (0x%lx)\n", INOMAX, INOMAX );
-	mlog( MLOG_NITTY + 1, "TIMEMAX == %ld (0x%lx)\n", TIMEMAX, TIMEMAX );
-	mlog( MLOG_NITTY + 1, "SIZE64MAX == %llu (0x%llx)\n", SIZE64MAX, SIZE64MAX );
-	mlog( MLOG_NITTY + 1, "INO64MAX == %llu (0x%llx)\n", INO64MAX, INO64MAX );
-	mlog( MLOG_NITTY + 1, "UINT64MAX == %llu (0x%llx)\n", UINT64MAX, UINT64MAX );
-	mlog( MLOG_NITTY + 1, "INT64MAX == %lld (0x%llx)\n", INT64MAX, INT64MAX );
-	mlog( MLOG_NITTY + 1, "UINT32MAX == %u (0x%x)\n", UINT32MAX, UINT32MAX );
-	mlog( MLOG_NITTY + 1, "INT32MAX == %d (0x%x)\n", INT32MAX, INT32MAX );
-	mlog( MLOG_NITTY + 1, "INT16MAX == %d (0x%x)\n", INT16MAX, INT16MAX );
-	mlog( MLOG_NITTY + 1, "UINT16MAX == %u (0x%x)\n", UINT16MAX, UINT16MAX );
+	mlog(MLOG_NITTY + 1, "INTGENMAX == %ld (0x%lx)\n", INTGENMAX, INTGENMAX);
+	mlog(MLOG_NITTY + 1, "UINTGENMAX == %lu (0x%lx)\n", UINTGENMAX, UINTGENMAX);
+	mlog(MLOG_NITTY + 1, "OFF64MAX == %lld (0x%llx)\n", OFF64MAX, OFF64MAX);
+	mlog(MLOG_NITTY + 1, "OFFMAX == %ld (0x%lx)\n", OFFMAX, OFFMAX);
+	mlog(MLOG_NITTY + 1, "SIZEMAX == %lu (0x%lx)\n", SIZEMAX, SIZEMAX);
+	mlog(MLOG_NITTY + 1, "INOMAX == %lu (0x%lx)\n", INOMAX, INOMAX);
+	mlog(MLOG_NITTY + 1, "TIMEMAX == %ld (0x%lx)\n", TIMEMAX, TIMEMAX);
+	mlog(MLOG_NITTY + 1, "SIZE64MAX == %llu (0x%llx)\n", SIZE64MAX, SIZE64MAX);
+	mlog(MLOG_NITTY + 1, "INO64MAX == %llu (0x%llx)\n", INO64MAX, INO64MAX);
+	mlog(MLOG_NITTY + 1, "UINT64MAX == %llu (0x%llx)\n", UINT64MAX, UINT64MAX);
+	mlog(MLOG_NITTY + 1, "INT64MAX == %lld (0x%llx)\n", INT64MAX, INT64MAX);
+	mlog(MLOG_NITTY + 1, "UINT32MAX == %u (0x%x)\n", UINT32MAX, UINT32MAX);
+	mlog(MLOG_NITTY + 1, "INT32MAX == %d (0x%x)\n", INT32MAX, INT32MAX);
+	mlog(MLOG_NITTY + 1, "INT16MAX == %d (0x%x)\n", INT16MAX, INT16MAX);
+	mlog(MLOG_NITTY + 1, "UINT16MAX == %u (0x%x)\n", UINT16MAX, UINT16MAX);
 
 	/* ask the system for the true vm page size, which must be used
 	 * in all mmap calls
 	 */
-	pgsz = ( size_t )getpagesize( );
-	mlog( MLOG_DEBUG | MLOG_PROC,
+	pgsz = (size_t)getpagesize();
+	mlog(MLOG_DEBUG | MLOG_PROC,
 	      "getpagesize( ) returns %u\n",
-	      pgsz );
-	assert( ( int )pgsz > 0 );
+	      pgsz);
+	assert((int)pgsz > 0);
 	pgmask = pgsz - 1;
 
 	/* report parent tid
          */
-	mlog( MLOG_DEBUG | MLOG_PROC,
+	mlog(MLOG_DEBUG | MLOG_PROC,
 	      "parent tid is %lu\n",
-	      parenttid );
+	      parenttid);
 
 	/* get the current working directory: this is where we will dump
 	 * core, if necessary. some tmp files may be placed here as well.
 	 */
-	homedir = getcwd( 0, MAXPATHLEN );
-	if ( ! homedir ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+	homedir = getcwd(0, MAXPATHLEN);
+	if (! homedir) {
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("unable to determine current directory: %s\n"),
-		      strerror( errno ));
+		      strerror(errno));
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
 	/* sanity check the inventory database directory, setup global paths
 	 */
-	ok = inv_setup_base( );
-	if ( ! ok ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+	ok = inv_setup_base();
+	if (! ok) {
+		mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 		      _("both /var/lib/xfsdump and /var/xfsdump exist - fatal\n"));
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
 	/* if just looking for info, oblige
 	 */
-	if ( infoonly ) {
-		mlog( MLOG_NORMAL,
+	if (infoonly) {
+		mlog(MLOG_NORMAL,
 		      _("version %s (dump format %d.0)\n"),
-		      VERSION, GLOBAL_HDR_VERSION );
-		usage( );
+		      VERSION, GLOBAL_HDR_VERSION);
+		usage();
 		return mlog_exit(EXIT_NORMAL, RV_OK); /* normal termination */
 	}
 
 	/* if an inventory display is requested, do it and exit
 	 */
-	if ( ! inv_DEBUG_print( argc, argv )) {
+	if (! inv_DEBUG_print(argc, argv)) {
 		return mlog_exit(EXIT_NORMAL, RV_OK); /* normal termination */
 	}
 
@@ -422,28 +422,28 @@ main( int argc, char *argv[] )
 	 * this must appear after inv_DEBUG_print(),
 	 * so it may be done without root privilege.
 	 */
-	euid = geteuid( );
-	mlog( MLOG_DEBUG | MLOG_PROC,
+	euid = geteuid();
+	mlog(MLOG_DEBUG | MLOG_PROC,
 	      "effective user id is %d\n",
-	      euid );
-	if ( euid != 0 ) {
-		mlog( MLOG_NORMAL,
-		      _("effective user ID must be root\n") );
+	      euid);
+	if (euid != 0) {
+		mlog(MLOG_NORMAL,
+		      _("effective user ID must be root\n"));
 		return mlog_exit(EXIT_ERROR, RV_PERM);
 	}
 #endif /* DUMP */
 
 	/* initialize operator dialog capability
 	 */
-	ok = dlog_init( argc, argv );
-	if ( ! ok ) {
+	ok = dlog_init(argc, argv);
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
 	/* initialize the child process manager
 	 */
-	ok = cldmgr_init( );
-	if ( ! ok ) {
+	ok = cldmgr_init();
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
@@ -452,8 +452,8 @@ main( int argc, char *argv[] )
 	 * terribly time-consuming here. A second initialization pass
 	 * will be done shortly.
 	 */
-	ok = drive_init1( argc, argv );
-	if ( ! ok ) {
+	ok = drive_init1(argc, argv);
+	if (! ok) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 
@@ -461,40 +461,40 @@ main( int argc, char *argv[] )
 	 * if not, check stdout anyway, in case someone is trying to pipe
 	 * the log messages into more, tee, ...
 	 */
-	if ( drivepp[ 0 ]->d_isunnamedpipepr ) {
-		mlog( MLOG_DEBUG | MLOG_NOTE,
-		      "pipeline detected\n" );
+	if (drivepp[0]->d_isunnamedpipepr) {
+		mlog(MLOG_DEBUG | MLOG_NOTE,
+		      "pipeline detected\n");
 		pipeline = BOOL_TRUE;
 	} else {
 		struct stat64 statbuf;
-		if ( fstat64( 1, &statbuf ) == 0
+		if (fstat64(1, &statbuf) == 0
 		     &&
-		     ( statbuf.st_mode & S_IFMT ) == S_IFIFO ) {
+		     (statbuf.st_mode & S_IFMT) == S_IFIFO) {
 			stdoutpiped = BOOL_TRUE;
 		}
 	}
 
 	/* announce version and instructions
 	 */
-	sistr = sigintstr( );
-	mlog( MLOG_VERBOSE,
+	sistr = sigintstr();
+	mlog(MLOG_VERBOSE,
 	      _("version %s (dump format %d.0)"),
-	      VERSION, GLOBAL_HDR_VERSION );
-	if ( ! pipeline && ! stdoutpiped && sistr && dlog_allowed( )) {
-		mlog( MLOG_VERBOSE | MLOG_BARE, _(
+	      VERSION, GLOBAL_HDR_VERSION);
+	if (! pipeline && ! stdoutpiped && sistr && dlog_allowed()) {
+		mlog(MLOG_VERBOSE | MLOG_BARE, _(
 		      " - "
 		      "type %s for status and control\n"),
-		      sistr );
+		      sistr);
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_BARE,
-		      "\n" );
+		mlog(MLOG_VERBOSE | MLOG_BARE,
+		      "\n");
 	}
 
 #ifdef DUMP
 	/* build a global write header template
 	 */
-	gwhdrtemplatep = global_hdr_alloc( argc, argv );
-	if ( ! gwhdrtemplatep ) {
+	gwhdrtemplatep = global_hdr_alloc(argc, argv);
+	if (! gwhdrtemplatep) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
 #endif /* DUMP */
@@ -502,7 +502,7 @@ main( int argc, char *argv[] )
 	/* tell mlog how many streams there are. the format of log messages
 	 * depends on whether there are one or many.
 	 */
-	mlog_tell_streamcnt( drivecnt );
+	mlog_tell_streamcnt(drivecnt);
 
 	/* initialize the state of signal processing. if in a pipeline, just
 	 * want to exit when a signal is received. otherwise, hold signals so
@@ -524,9 +524,9 @@ main( int argc, char *argv[] )
 	 * of normal sys call error handling.
 	 */
 	sa.sa_handler = SIG_IGN;
-	sigaction( SIGPIPE, &sa, NULL );
+	sigaction(SIGPIPE, &sa, NULL);
 
-	if ( ! pipeline ) {
+	if (! pipeline) {
 		sigset_t blocked_set;
 
 		stop_in_progress = BOOL_FALSE;
@@ -537,80 +537,80 @@ main( int argc, char *argv[] )
 		sigquit_received = BOOL_FALSE;
 		sigstray_received = BOOL_FALSE;
 
-		alarm( 0 );
+		alarm(0);
 
-		sigemptyset( &blocked_set );
-		sigaddset( &blocked_set, SIGINT );
-		sigaddset( &blocked_set, SIGHUP );
-		sigaddset( &blocked_set, SIGTERM );
-		sigaddset( &blocked_set, SIGQUIT );
-		sigaddset( &blocked_set, SIGALRM );
-		sigaddset( &blocked_set, SIGUSR1 );
-		pthread_sigmask( SIG_SETMASK, &blocked_set, NULL );
+		sigemptyset(&blocked_set);
+		sigaddset(&blocked_set, SIGINT);
+		sigaddset(&blocked_set, SIGHUP);
+		sigaddset(&blocked_set, SIGTERM);
+		sigaddset(&blocked_set, SIGQUIT);
+		sigaddset(&blocked_set, SIGALRM);
+		sigaddset(&blocked_set, SIGUSR1);
+		pthread_sigmask(SIG_SETMASK, &blocked_set, NULL);
 
 		sa.sa_handler = sighandler;
-		sigaction( SIGINT, &sa, NULL );
-		sigaction( SIGHUP, &sa, NULL );
-		sigaction( SIGTERM, &sa, NULL );
-		sigaction( SIGQUIT, &sa, NULL );
-		sigaction( SIGALRM, &sa, NULL );
-		sigaction( SIGUSR1, &sa, NULL );
+		sigaction(SIGINT, &sa, NULL);
+		sigaction(SIGHUP, &sa, NULL);
+		sigaction(SIGTERM, &sa, NULL);
+		sigaction(SIGQUIT, &sa, NULL);
+		sigaction(SIGALRM, &sa, NULL);
+		sigaction(SIGUSR1, &sa, NULL);
 	}
 
 	/* do content initialization.
 	 */
 #ifdef DUMP
-	ok = content_init( argc, argv, gwhdrtemplatep );
+	ok = content_init(argc, argv, gwhdrtemplatep);
 #endif /* DUMP */
 #ifdef RESTORE
-	ok = content_init( argc, argv, vmsz / VMSZ_PER );
+	ok = content_init(argc, argv, vmsz / VMSZ_PER);
 #endif /* RESTORE */
-	if ( ! ok ) {
+	if (! ok) {
 		err = mlog_exit(EXIT_ERROR, RV_INIT);
 		goto err_free;
 	}
 
 	/* if in a pipeline, go single-threaded with just one stream.
 	 */
-	if ( pipeline ) {
+	if (pipeline) {
 		int exitcode;
 
 		sa.sa_handler = sighandler;
-		sigaction( SIGINT, &sa, NULL );
-		sigaction( SIGHUP, &sa, NULL );
-		sigaction( SIGTERM, &sa, NULL );
-		sigaction( SIGQUIT, &sa, NULL );
+		sigaction(SIGINT, &sa, NULL);
+		sigaction(SIGHUP, &sa, NULL);
+		sigaction(SIGTERM, &sa, NULL);
+		sigaction(SIGQUIT, &sa, NULL);
 
 #ifdef DUMP
-		ok = drive_init2( argc,
+		ok = drive_init2(argc,
 				  argv,
-				  gwhdrtemplatep );
+				  gwhdrtemplatep);
 #endif /* DUMP */
 #ifdef RESTORE
-		ok = drive_init2( argc,
+		ok = drive_init2(argc,
 				  argv,
-				  ( global_hdr_t * )0 );
+				  (global_hdr_t *)0);
 #endif /* RESTORE */
-		if ( ! ok ) {
+		if (! ok) {
 			err = mlog_exit(EXIT_ERROR, RV_INIT);
 			goto err_free;
 		}
-		ok = drive_init3( );
-		if ( ! ok ) {
+		ok = drive_init3();
+		if (! ok) {
 			err = mlog_exit(EXIT_ERROR, RV_INIT);
 			goto err_free;
 		}
 #ifdef DUMP
-		exitcode = content_stream_dump( 0 );
+		exitcode = content_stream_dump(0);
 #endif /* DUMP */
 #ifdef RESTORE
-		exitcode = content_stream_restore( 0 );
+		exitcode = content_stream_restore(0);
 #endif /* RESTORE */
-		if ( exitcode != EXIT_NORMAL ) {
-			( void )content_complete( );
+		if (exitcode != EXIT_NORMAL) {
+			(void)content_complete();
 						/* for cleanup side-effect */
 			err = mlog_exit(exitcode, RV_UNKNOWN);
-		} else if ( content_complete( )) {
+		} else if (content_complete()) {
 			err = mlog_exit(EXIT_NORMAL, RV_OK);
 		} else {
 			err = mlog_exit(EXIT_INTERRUPT, RV_UNKNOWN);
@@ -626,28 +626,28 @@ main( int argc, char *argv[] )
 	/* now do the second and third passes of drive initialization.
 	 * allocate per-stream write and read headers. if a drive
 	 * manager uses a slave process, it should be created now,
-	 * using cldmgr_create( ). each drive manager may use the slave to
+	 * using cldmgr_create(). each drive manager may use the slave to
 	 * asynchronously read the media file header, typically a very
 	 * time-consuming chore. drive_init3 will synchronize with each slave.
 	 */
-	if ( ! init_error ) {
+	if (! init_error) {
 #ifdef DUMP
-		ok = drive_init2( argc,
+		ok = drive_init2(argc,
 				  argv,
-				  gwhdrtemplatep );
+				  gwhdrtemplatep);
 #endif /* DUMP */
 #ifdef RESTORE
-		ok = drive_init2( argc,
+		ok = drive_init2(argc,
 				  argv,
-				  ( global_hdr_t * )0 );
+				  (global_hdr_t *)0);
 #endif /* RESTORE */
-		if ( ! ok ) {
+		if (! ok) {
 			init_error = BOOL_TRUE;
 		}
 	}
-	if ( ! init_error ) {
-		ok = drive_init3( );
-		if ( ! ok ) {
+	if (! init_error) {
+		ok = drive_init3();
+		if (! ok) {
 			init_error = BOOL_TRUE;
 		}
 	}
@@ -655,13 +655,13 @@ main( int argc, char *argv[] )
 	/* create a child thread for each stream. drivecnt global from
 	 * drive.h, initialized by drive_init[12]
 	 */
-	if ( ! init_error ) {
-		for ( stix = 0 ; stix < drivecnt ; stix++ ) {
-			ok = cldmgr_create( childmain,
+	if (! init_error) {
+		for (stix = 0 ; stix < drivecnt ; stix++) {
+			ok = cldmgr_create(childmain,
 					    stix,
 					    "child",
-					    ( void * )stix );
-			if ( ! ok ) {
+					    (void *)stix);
+			if (! ok) {
 				init_error = BOOL_TRUE;
 			}
 		}
@@ -670,10 +670,10 @@ main( int argc, char *argv[] )
 	/* loop here, waiting for children to die, processing operator
 	 * signals.
 	 */
-	if ( progrpt_enabledpr ) {
-		( void )alarm( ( uint )progrpt_interval );
+	if (progrpt_enabledpr) {
+		(void)alarm((uint)progrpt_interval);
 	}
-	for ( ; ; ) {
+	for (; ;) {
 		time32_t now;
 		bool_t stop_requested = BOOL_FALSE;
 		int stop_timeout = -1;
@@ -682,7 +682,7 @@ main( int argc, char *argv[] )
 		/* if there was an initialization error,
 		 * immediately stop all children.
 		 */
-		if ( init_error ) {
+		if (init_error) {
 			stop_timeout = STOP_TIMEOUT;
 			stop_requested = BOOL_TRUE;
 		}
@@ -691,9 +691,9 @@ main( int argc, char *argv[] )
 		 * stop. furthermore, note that core should be dumped if
 		 * the child explicitly exited with EXIT_FAULT.
 		 */
-		xc = cldmgr_join( );
-		if ( xc ) {
-			if ( xc == EXIT_FAULT ) {
+		xc = cldmgr_join();
+		if (xc) {
+			if (xc == EXIT_FAULT) {
 				coredump_requested = BOOL_TRUE;
 				stop_timeout = ABORT_TIMEOUT;
 			} else {
@@ -705,21 +705,21 @@ main( int argc, char *argv[] )
 
 		/* all children died normally. break out.
 		 */
-		if ( cldmgr_remainingcnt( ) == 0 ) {
-			mlog( MLOG_DEBUG,
-			      "all children have exited\n" );
+		if (cldmgr_remainingcnt() == 0) {
+			mlog(MLOG_DEBUG,
+			      "all children have exited\n");
 			break;
 		}
 
 		/* get the current time
 		 */
-		now = time( 0 );
+		now = time(0);
 
 		/* check for stop timeout. request a core dump and bail
 		 */
-		if ( stop_in_progress && now >= stop_deadline ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR,
-			      _("session interrupt timeout\n") );
+		if (stop_in_progress && now >= stop_deadline) {
+			mlog(MLOG_NORMAL | MLOG_ERROR,
+			      _("session interrupt timeout\n"));
 			coredump_requested = BOOL_TRUE;
 			break;
 		}
@@ -727,21 +727,21 @@ main( int argc, char *argv[] )
 		/* operator sent SIGINT. if dialog allowed, enter dialog.
 		 * otherwise treat as a hangup and request a stop.
 		 */
-		if ( sigint_received ) {
-			mlog( MLOG_DEBUG | MLOG_PROC,
-			      "SIGINT received\n" );
-			if ( stop_in_progress ) {
-				if ( dlog_allowed( )) {
-					( void )sigint_dialog( );
+		if (sigint_received) {
+			mlog(MLOG_DEBUG | MLOG_PROC,
+			      "SIGINT received\n");
+			if (stop_in_progress) {
+				if (dlog_allowed()) {
+					(void)sigint_dialog();
 				}
 				/*
-				mlog( MLOG_NORMAL,
+				mlog(MLOG_NORMAL,
 				      _("session interrupt in progress: "
-				      "please wait\n") );
+				      "please wait\n"));
 				 */
 			} else {
-				if ( dlog_allowed( )) {
-					stop_requested = sigint_dialog( );
+				if (dlog_allowed()) {
+					stop_requested = sigint_dialog();
 				} else {
 					stop_requested = BOOL_TRUE;
 				}
@@ -757,13 +757,13 @@ main( int argc, char *argv[] )
 
 		/* refresh the current time in case in dialog for a while
 		 */
-		now = time( 0 );
+		now = time(0);
 
 		/* request a stop on hangup
 		 */
-		if ( sighup_received ) {
-			mlog( MLOG_DEBUG | MLOG_PROC,
-			      "SIGHUP received\n" );
+		if (sighup_received) {
+			mlog(MLOG_DEBUG | MLOG_PROC,
+			      "SIGHUP received\n");
 			stop_requested = BOOL_TRUE;
 			stop_timeout = STOP_TIMEOUT;
 			sighup_received = BOOL_FALSE;
@@ -771,9 +771,9 @@ main( int argc, char *argv[] )
 
 		/* request a stop on termination request
 		 */
-		if ( sigterm_received ) {
-			mlog( MLOG_DEBUG | MLOG_PROC,
-			      "SIGTERM received\n" );
+		if (sigterm_received) {
+			mlog(MLOG_DEBUG | MLOG_PROC,
+			      "SIGTERM received\n");
 			stop_requested = BOOL_TRUE;
 			stop_timeout = STOP_TIMEOUT;
 			sigterm_received = BOOL_FALSE;
@@ -782,13 +782,13 @@ main( int argc, char *argv[] )
 		/* operator send SIGQUIT. treat like an interrupt,
 		 * but force a core dump
 		 */
-		if ( sigquit_received ) {
-			mlog( MLOG_NORMAL | MLOG_PROC,
-			      "SIGQUIT received\n" );
-			if ( stop_in_progress ) {
-				mlog( MLOG_NORMAL,
+		if (sigquit_received) {
+			mlog(MLOG_NORMAL | MLOG_PROC,
+			      "SIGQUIT received\n");
+			if (stop_in_progress) {
+				mlog(MLOG_NORMAL,
 				      _("session interrupt in progress: "
-				      "please wait\n") );
+				      "please wait\n"));
 				stop_deadline = now;
 			} else {
 				stop_requested = BOOL_TRUE;
@@ -800,86 +800,86 @@ main( int argc, char *argv[] )
 
 		/* see if need to initiate a stop
 		 */
-		if ( stop_requested && ! stop_in_progress ) {
-			mlog( MLOG_NORMAL,
+		if (stop_requested && ! stop_in_progress) {
+			mlog(MLOG_NORMAL,
 			      _("initiating session interrupt (timeout in %d sec)\n"),
 			      stop_timeout);
 			mlog_exit_hint(RV_INTR);
 			stop_in_progress = BOOL_TRUE;
-			cldmgr_stop( );
-			assert( stop_timeout >= 0 );
-			stop_deadline = now + ( time32_t )stop_timeout;
+			cldmgr_stop();
+			assert(stop_timeout >= 0);
+			stop_deadline = now + (time32_t)stop_timeout;
 		}
 
 		/* set alarm if needed (note time stands still during dialog)
 		 */
-		if ( stop_in_progress ) {
-			int timeout = ( int )( stop_deadline - now );
-			if ( timeout < 0 ) {
+		if (stop_in_progress) {
+			int timeout = (int)(stop_deadline - now);
+			if (timeout < 0) {
 				timeout = 0;
 			}
-			mlog( MLOG_DEBUG | MLOG_PROC,
+			mlog(MLOG_DEBUG | MLOG_PROC,
 			      "setting alarm for %d second%s\n",
 			      timeout,
-			      timeout == 1 ? "" : "s" );
-			( void )alarm( ( uint )timeout );
-			if ( timeout == 0 ) {
+			      timeout == 1 ? "" : "s");
+			(void)alarm((uint)timeout);
+			if (timeout == 0) {
 				continue;
 			}
 		}
 
-		if ( progrpt_enabledpr && ! stop_in_progress ) {
+		if (progrpt_enabledpr && ! stop_in_progress) {
 			bool_t need_progrptpr = BOOL_FALSE;
-			while ( now >= progrpt_deadline ) {
+			while (now >= progrpt_deadline) {
 				need_progrptpr = BOOL_TRUE;
 				progrpt_deadline += progrpt_interval;
 			}
-			if ( need_progrptpr ) {
+			if (need_progrptpr) {
 				size_t statlinecnt;
 				char **statline;
 				ix_t i;
-				statlinecnt = content_statline( &statline );
-				for ( i = 0 ; i < statlinecnt ; i++ ) {
-					mlog( MLOG_NORMAL,
-					      statline[ i ] );
+				statlinecnt = content_statline(&statline);
+				for (i = 0 ; i < statlinecnt ; i++) {
+					mlog(MLOG_NORMAL,
+					      statline[i]);
 				}
 			}
-			( void )alarm( ( uint )( progrpt_deadline
+			(void)alarm((uint)(progrpt_deadline
 						       -
-						       now ));
+						       now));
 		}
 
 		/* sleep until next signal
 		 */
-		sigemptyset( &empty_set );
-		sigsuspend( &empty_set );
-		( void )alarm( 0 );
+		sigemptyset(&empty_set);
+		sigsuspend(&empty_set);
+		(void)alarm(0);
 	}
 
 	/* check if core dump requested
 	 */
-	if ( coredump_requested ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
+	if (coredump_requested) {
+		mlog(MLOG_DEBUG | MLOG_PROC,
 		      "core dump requested, aborting (pid %d)\n",
-		      getpid() );
+		      getpid());
 		abort();
 	}
 
 	/* determine if dump or restore was interrupted
 	 * or an initialization error occurred.
 	 */
-	if ( init_error ) {
-		( void )content_complete( );
+	if (init_error) {
+		(void)content_complete();
 		exitcode = EXIT_ERROR;
 	} else {
-		if ( content_complete( ) ) {
+		if (content_complete()) {
 			if (prbcld_xc != EXIT_NORMAL)
 				exitcode = EXIT_ERROR;
 			else
 				exitcode = EXIT_NORMAL;
 		} else {
 			exitcode = EXIT_INTERRUPT;
-			if ( mlog_get_hint() == RV_NONE )
+			if (mlog_get_hint() == RV_NONE)
 				mlog_exit_hint(RV_INCOMPLETE);
 		}
 	}
@@ -888,28 +888,28 @@ main( int argc, char *argv[] )
 
 err_free:
 #ifdef DUMP
-	global_hdr_free( gwhdrtemplatep );
+	global_hdr_free(gwhdrtemplatep);
 #endif /* DUMP */
 	return err;
 }
 
-#define ULO( f, o )	fprintf( stderr,		\
+#define ULO(f, o)	fprintf(stderr,		\
 				 "%*s[ -%c %s ]\n",	\
 				 ps,			\
 				 ns,			\
 				 o,			\
-				 f ),			\
+				 f),			\
 			ps = pfxsz
 
-#define ULN( f )	fprintf( stderr,		\
+#define ULN(f)	fprintf(stderr,		\
 				 "%*s[ %s ]\n",		\
 				 ps,			\
 				 ns,			\
-				 f ),			\
+				 f),			\
 			ps = pfxsz
 
 void
-usage( void )
+usage(void)
 {
 	int pfxsz;
 	int ps = 0;
@@ -919,107 +919,107 @@ usage( void )
 				progname, basename(progname));
 
 #ifdef DUMP
-	ULO(_("(dump DMF dualstate files as offline)"),	GETOPT_DUMPASOFFLINE );
-	ULO(_("<blocksize>"),				GETOPT_BLOCKSIZE );
-	ULO(_("<media change alert program> "),		GETOPT_ALERTPROG );
-	ULO(_("<dump media file size> "),		GETOPT_FILESZ );
-	ULO(_("(allow files to be excluded)"),		GETOPT_EXCLUDEFILES );
-	ULO(_("<destination> ..."),			GETOPT_DUMPDEST );
-	ULO(_("(help)"),				GETOPT_HELP );
-	ULO(_("<level>"),				GETOPT_LEVEL );
-	ULO(_("(force usage of minimal rmt)"),		GETOPT_MINRMT );
-	ULO(_("(overwrite tape)"),			GETOPT_OVERWRITE );
-	ULO(_("<seconds between progress reports>"),	GETOPT_PROGRESS );
-	ULO(_("<use QIC tape settings>"),		GETOPT_QIC );
-	ULO(_("<subtree> ..."),				GETOPT_SUBTREE );
-	ULO(_("<file> (use file mtime for dump time"),	GETOPT_DUMPTIME );
-	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY );
-	ULO(_("<maximum file size>"),			GETOPT_MAXDUMPFILESIZE );
-	ULO(_("(don't dump extended file attributes)"),	GETOPT_NOEXTATTR );
-	ULO(_("<base dump session id>"),		GETOPT_BASED );
+	ULO(_("(dump DMF dualstate files as offline)"),	GETOPT_DUMPASOFFLINE);
+	ULO(_("<blocksize>"),				GETOPT_BLOCKSIZE);
+	ULO(_("<media change alert program> "),		GETOPT_ALERTPROG);
+	ULO(_("<dump media file size> "),		GETOPT_FILESZ);
+	ULO(_("(allow files to be excluded)"),		GETOPT_EXCLUDEFILES);
+	ULO(_("<destination> ..."),			GETOPT_DUMPDEST);
+	ULO(_("(help)"),				GETOPT_HELP);
+	ULO(_("<level>"),				GETOPT_LEVEL);
+	ULO(_("(force usage of minimal rmt)"),		GETOPT_MINRMT);
+	ULO(_("(overwrite tape)"),			GETOPT_OVERWRITE);
+	ULO(_("<seconds between progress reports>"),	GETOPT_PROGRESS);
+	ULO(_("<use QIC tape settings>"),		GETOPT_QIC);
+	ULO(_("<subtree> ..."),				GETOPT_SUBTREE);
+	ULO(_("<file> (use file mtime for dump time"),	GETOPT_DUMPTIME);
+	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
+	ULO(_("<maximum file size>"),			GETOPT_MAXDUMPFILESIZE);
+	ULO(_("(don't dump extended file attributes)"),	GETOPT_NOEXTATTR);
+	ULO(_("<base dump session id>"),		GETOPT_BASED);
 #ifdef REVEAL
-	ULO(_("(generate tape record checksums)"),	GETOPT_RECCHKSUM );
+	ULO(_("(generate tape record checksums)"),	GETOPT_RECCHKSUM);
 #endif /* REVEAL */
-	ULO(_("(skip unchanged directories)"),		GETOPT_NOUNCHANGEDDIRS );
-	ULO(_("(pre-erase media)"),			GETOPT_ERASE );
-	ULO(_("(don't prompt)"),			GETOPT_FORCE );
+	ULO(_("(skip unchanged directories)"),		GETOPT_NOUNCHANGEDDIRS);
+	ULO(_("(pre-erase media)"),			GETOPT_ERASE);
+	ULO(_("(don't prompt)"),			GETOPT_FORCE);
 #ifdef REVEAL
-	ULO(_("<minimum thread stack size>"),		GETOPT_MINSTACKSZ );
-	ULO(_("<maximum thread stack size>"),		GETOPT_MAXSTACKSZ );
+	ULO(_("<minimum thread stack size>"),		GETOPT_MINSTACKSZ);
+	ULO(_("<maximum thread stack size>"),		GETOPT_MAXSTACKSZ);
 #endif /* REVEAL */
-	ULO(_("(display dump inventory)"),		GETOPT_INVPRINT );
-	ULO(_("(inhibit inventory update)"),		GETOPT_NOINVUPDATE );
-	ULO(_("(generate format 2 dump)"),		GETOPT_FMT2COMPAT );
-	ULO(_("<session label>"),			GETOPT_DUMPLABEL );
-	ULO(_("<media label> ..."),			GETOPT_MEDIALABEL );
+	ULO(_("(display dump inventory)"),		GETOPT_INVPRINT);
+	ULO(_("(inhibit inventory update)"),		GETOPT_NOINVUPDATE);
+	ULO(_("(generate format 2 dump)"),		GETOPT_FMT2COMPAT);
+	ULO(_("<session label>"),			GETOPT_DUMPLABEL);
+	ULO(_("<media label> ..."),			GETOPT_MEDIALABEL);
 #ifdef REVEAL
-	ULO(_("(timestamp messages)"),			GETOPT_TIMESTAMP );
+	ULO(_("(timestamp messages)"),			GETOPT_TIMESTAMP);
 #endif /* REVEAL */
-	ULO(_("<options file>"),			GETOPT_OPTFILE );
+	ULO(_("<options file>"),			GETOPT_OPTFILE);
 #ifdef REVEAL
-	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN );
+	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN);
 #endif /* REVEAL */
-	ULO(_("(resume)"),				GETOPT_RESUME );
-	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS );
+	ULO(_("(resume)"),				GETOPT_RESUME);
+	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS);
 #ifdef REVEAL
-	ULO(_("(unload media when change needed)"),	GETOPT_UNLOAD );
-	ULO(_("(show subsystem in messages)"),		GETOPT_SHOWLOGSS );
-	ULO(_("(show verbosity in messages)"),		GETOPT_SHOWLOGLEVEL );
+	ULO(_("(unload media when change needed)"),	GETOPT_UNLOAD);
+	ULO(_("(show subsystem in messages)"),		GETOPT_SHOWLOGSS);
+	ULO(_("(show verbosity in messages)"),		GETOPT_SHOWLOGLEVEL);
 #endif /* REVEAL */
-	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN );
-	ULN(_("- (stdout)") );
-	ULN(_("<source (mntpnt|device)>") );
+	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN);
+	ULN(_("- (stdout)"));
+	ULN(_("<source (mntpnt|device)>"));
 #endif /* DUMP */
 #ifdef RESTORE
-	ULO(_("<alt. workspace dir> ..."),		GETOPT_WORKSPACE );
-	ULO(_("<blocksize>"),				GETOPT_BLOCKSIZE );
-	ULO(_("<media change alert program> "),		GETOPT_ALERTPROG );
-	ULO(_("(don't overwrite existing files)"),	GETOPT_EXISTING );
-	ULO(_("<source> ..."),				GETOPT_DUMPDEST );
-	ULO(_("(help)"),				GETOPT_HELP );
-	ULO(_("(interactive)"),				GETOPT_INTERACTIVE );
-	ULO(_("(force usage of minimal rmt)"),		GETOPT_MINRMT );
-	ULO(_("<file> (restore only if newer than)"),	GETOPT_NEWER );
-	ULO(_("(restore owner/group even if not root)"),GETOPT_OWNER );
-	ULO(_("<seconds between progress reports>"),	GETOPT_PROGRESS );
-	ULO(_("<use QIC tape settings>"),		GETOPT_QIC );
-	ULO(_("(cumulative restore)"),			GETOPT_CUMULATIVE );
-	ULO(_("<subtree> ..."),				GETOPT_SUBTREE );
-	ULO(_("(contents only)"),			GETOPT_TOC );
-	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY );
-	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW );
-	ULO(_("(don't restore extended file attributes)"),GETOPT_NOEXTATTR );
-	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM );
-	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM );
+	ULO(_("<alt. workspace dir> ..."),		GETOPT_WORKSPACE);
+	ULO(_("<blocksize>"),				GETOPT_BLOCKSIZE);
+	ULO(_("<media change alert program> "),		GETOPT_ALERTPROG);
+	ULO(_("(don't overwrite existing files)"),	GETOPT_EXISTING);
+	ULO(_("<source> ..."),				GETOPT_DUMPDEST);
+	ULO(_("(help)"),				GETOPT_HELP);
+	ULO(_("(interactive)"),				GETOPT_INTERACTIVE);
+	ULO(_("(force usage of minimal rmt)"),		GETOPT_MINRMT);
+	ULO(_("<file> (restore only if newer than)"),	GETOPT_NEWER);
+	ULO(_("(restore owner/group even if not root)"),GETOPT_OWNER);
+	ULO(_("<seconds between progress reports>"),	GETOPT_PROGRESS);
+	ULO(_("<use QIC tape settings>"),		GETOPT_QIC);
+	ULO(_("(cumulative restore)"),			GETOPT_CUMULATIVE);
+	ULO(_("<subtree> ..."),				GETOPT_SUBTREE);
+	ULO(_("(contents only)"),			GETOPT_TOC);
+	ULO(_("<verbosity {silent, verbose, trace}>"),	GETOPT_VERBOSITY);
+	ULO(_("(use small tree window)"),		GETOPT_SMALLWINDOW);
+	ULO(_("(don't restore extended file attributes)"),GETOPT_NOEXTATTR);
+	ULO(_("(restore root dir owner/permissions)"),	GETOPT_ROOTPERM);
+	ULO(_("(restore DMAPI event settings)"),	GETOPT_SETDM);
 #ifdef REVEAL
-	ULO(_("(check tape record checksums)"),		GETOPT_RECCHKSUM );
+	ULO(_("(check tape record checksums)"),		GETOPT_RECCHKSUM);
 #endif /* REVEAL */
-	ULO(_("(don't overwrite if changed)"),		GETOPT_CHANGED );
-	ULO(_("(don't prompt)"),			GETOPT_FORCE );
-	ULO(_("(display dump inventory)"),		GETOPT_INVPRINT );
-	ULO(_("(inhibit inventory update)"),		GETOPT_NOINVUPDATE );
-	ULO(_("(force use of format 2 generation numbers)"),GETOPT_FMT2COMPAT );
-	ULO(_("<session label>"),			GETOPT_DUMPLABEL );
+	ULO(_("(don't overwrite if changed)"),		GETOPT_CHANGED);
+	ULO(_("(don't prompt)"),			GETOPT_FORCE);
+	ULO(_("(display dump inventory)"),		GETOPT_INVPRINT);
+	ULO(_("(inhibit inventory update)"),		GETOPT_NOINVUPDATE);
+	ULO(_("(force use of format 2 generation numbers)"),GETOPT_FMT2COMPAT);
+	ULO(_("<session label>"),			GETOPT_DUMPLABEL);
 #ifdef REVEAL
-	ULO(_("(timestamp messages)"),			GETOPT_TIMESTAMP );
+	ULO(_("(timestamp messages)"),			GETOPT_TIMESTAMP);
 #endif /* REVEAL */
-	ULO(_("<options file>"),			GETOPT_OPTFILE );
+	ULO(_("<options file>"),			GETOPT_OPTFILE);
 #ifdef REVEAL
-	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN );
+	ULO(_("(pin down I/O buffers)"),		GETOPT_RINGPIN);
 #endif /* REVEAL */
-	ULO(_("(force interrupted session completion)"),GETOPT_SESSCPLT );
-	ULO(_("(resume)"),				GETOPT_RESUME );
-	ULO(_("<session id>"),				GETOPT_SESSIONID );
-	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS );
+	ULO(_("(force interrupted session completion)"),GETOPT_SESSCPLT);
+	ULO(_("(resume)"),				GETOPT_RESUME);
+	ULO(_("<session id>"),				GETOPT_SESSIONID);
+	ULO(_("(don't timeout dialogs)"),		GETOPT_NOTIMEOUTS);
 #ifdef REVEAL
-	ULO(_("(unload media when change needed)"),	GETOPT_UNLOAD );
-	ULO(_("(show subsystem in messages)"),		GETOPT_SHOWLOGSS );
-	ULO(_("(show verbosity in messages)"),		GETOPT_SHOWLOGLEVEL );
+	ULO(_("(unload media when change needed)"),	GETOPT_UNLOAD);
+	ULO(_("(show subsystem in messages)"),		GETOPT_SHOWLOGSS);
+	ULO(_("(show verbosity in messages)"),		GETOPT_SHOWLOGLEVEL);
 #endif /* REVEAL */
-	ULO(_("<excluded subtree> ..."),		GETOPT_NOSUBTREE );
-	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN );
-	ULN(_("- (stdin)") );
-	ULN(_("<destination>") );
+	ULO(_("<excluded subtree> ..."),		GETOPT_NOSUBTREE);
+	ULO(_("<I/O buffer ring length>"),		GETOPT_RINGLEN);
+	ULN(_("- (stdin)"));
+	ULN(_("<destination>"));
 #endif /* RESTORE */
 
 	/* anywhere usage is called we will exit shortly after...
@@ -1032,7 +1032,7 @@ usage( void )
 /* returns TRUE if preemption
  */
 bool_t
-preemptchk( int flg )
+preemptchk(int flg)
 {
 	bool_t preempt_requested;
 	int i;
@@ -1042,21 +1042,21 @@ preemptchk( int flg )
 
 	/* see if a progress report needed
 	 */
-	if ( progrpt_enabledpr ) {
-		time32_t now = time( 0 );
+	if (progrpt_enabledpr) {
+		time32_t now = time(0);
 		bool_t need_progrptpr = BOOL_FALSE;
-		while ( now >= progrpt_deadline ) {
+		while (now >= progrpt_deadline) {
 			need_progrptpr = BOOL_TRUE;
 			progrpt_deadline += progrpt_interval;
 		}
-		if ( need_progrptpr ) {
+		if (need_progrptpr) {
 			size_t statlinecnt;
 			char **statline;
 			ix_t i;
-			statlinecnt = content_statline( &statline );
-			for ( i = 0 ; i < statlinecnt ; i++ ) {
-				mlog( MLOG_NORMAL,
-				      statline[ i ] );
+			statlinecnt = content_statline(&statline);
+			for (i = 0 ; i < statlinecnt ; i++) {
+				mlog(MLOG_NORMAL,
+				      statline[i]);
 			}
 		}
 	}
@@ -1068,29 +1068,29 @@ preemptchk( int flg )
 
 	/* signals not caught if in a pipeline
 	 */
-	if ( pipeline ) {
+	if (pipeline) {
 		return BOOL_FALSE;
 	}
 
 	/* release signals momentarily to let any pending ones
 	 * invoke signal handler and set flags
 	 */
-	sigpending( &pending_set );
-	for ( i = 0; i < num_sigs; i++ ) {
-		if ( sigismember( &pending_set, sigs[i] ) == 1 ) {
-			sigfillset( &handle_set );
-			sigdelset( &handle_set, sigs[i] );
-			sigsuspend( &handle_set );
+	sigpending(&pending_set);
+	for (i = 0; i < num_sigs; i++) {
+		if (sigismember(&pending_set, sigs[i]) == 1) {
+			sigfillset(&handle_set);
+			sigdelset(&handle_set, sigs[i]);
+			sigsuspend(&handle_set);
 		}
 	}
 
 	preempt_requested = BOOL_FALSE;
 
-	if ( sigint_received ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "SIGINT received (preempt)\n" );
-		if ( dlog_allowed( )) {
-			preempt_requested = sigint_dialog( );
+	if (sigint_received) {
+		mlog(MLOG_DEBUG | MLOG_PROC,
+		      "SIGINT received (preempt)\n");
+		if (dlog_allowed()) {
+			preempt_requested = sigint_dialog();
 		} else {
 			preempt_requested = BOOL_TRUE;
 		}
@@ -1101,23 +1101,23 @@ preemptchk( int flg )
 		sigint_received = BOOL_FALSE;
 	}
 
-	if ( sighup_received ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "SIGHUP received (prempt)\n" );
+	if (sighup_received) {
+		mlog(MLOG_DEBUG | MLOG_PROC,
+		      "SIGHUP received (prempt)\n");
 		preempt_requested = BOOL_TRUE;
 		sighup_received = BOOL_FALSE;
 	}
 
-	if ( sigterm_received ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "SIGTERM received (prempt)\n" );
+	if (sigterm_received) {
+		mlog(MLOG_DEBUG | MLOG_PROC,
+		      "SIGTERM received (prempt)\n");
 		preempt_requested = BOOL_TRUE;
 		sigterm_received = BOOL_FALSE;
 	}
 
-	if ( sigquit_received ) {
-		mlog( MLOG_DEBUG | MLOG_PROC,
-		      "SIGQUIT received (preempt)\n" );
+	if (sigquit_received) {
+		mlog(MLOG_DEBUG | MLOG_PROC,
+		      "SIGQUIT received (preempt)\n");
 		preempt_requested = BOOL_TRUE;
 		sigquit_received = BOOL_FALSE;
 	}
@@ -1128,7 +1128,7 @@ preemptchk( int flg )
 /* definition of locally defined static functions ****************************/
 
 static bool_t
-loadoptfile( int *argcp, char ***argvp )
+loadoptfile(int *argcp, char ***argvp)
 {
 	char *optfilename;
 	ix_t optfileix = 0;
@@ -1150,66 +1150,66 @@ loadoptfile( int *argcp, char ***argvp )
 	optind = 1;
 	opterr = 0;
 	optfilename =  0;
-	while ( ( c = getopt( *argcp, *argvp, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(*argcp, *argvp, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_OPTFILE:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
-			if ( optfilename ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
+			if (optfilename) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c allowed only once\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			optfilename = optarg;
-			assert( optind > 2 );
-			optfileix = ( ix_t )optind - 2;
+			assert(optind > 2);
+			optfileix = (ix_t)optind - 2;
 			break;
 		}
 	}
-	if ( ! optfilename )  {
+	if (! optfilename)  {
 		return BOOL_TRUE;
 	}
 
 	/* attempt to open the option  file
 	 */
 	errno = 0;
-	fd = open( optfilename, O_RDONLY );
-	if ( fd  < 0 ) {
-		mlog( MLOG_ERROR | MLOG_NOLOCK,
+	fd = open(optfilename, O_RDONLY);
+	if (fd  < 0) {
+		mlog(MLOG_ERROR | MLOG_NOLOCK,
 		      _("cannot open option file %s: %s (%d)\n"),
 		      optfilename,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		return BOOL_FALSE;
 	}
 
 	/* get file status
 	 */
-	rval = fstat64( fd, &stat );
-	if ( rval ) {
-		mlog( MLOG_ERROR | MLOG_NOLOCK,
+	rval = fstat64(fd, &stat);
+	if (rval) {
+		mlog(MLOG_ERROR | MLOG_NOLOCK,
 		      _("cannot stat option file %s: %s (%d)\n"),
 		      optfilename,
-		      strerror( errno ),
-		      errno );
-		close( fd );
+		      strerror(errno),
+		      errno);
+		close(fd);
 		return BOOL_FALSE;
 	}
 
 	/* ensure the file is ordinary
 	 */
-	if ( ( stat.st_mode & S_IFMT ) != S_IFREG ) {
-		mlog( MLOG_ERROR | MLOG_NOLOCK,
+	if ((stat.st_mode & S_IFMT) != S_IFREG) {
+		mlog(MLOG_ERROR | MLOG_NOLOCK,
 		      _("given option file %s is not ordinary file\n"),
-		      optfilename );
-		close( fd );
+		      optfilename);
+		close(fd);
 		return BOOL_FALSE;
 	}
 
@@ -1217,68 +1217,68 @@ loadoptfile( int *argcp, char ***argvp )
 	 * skip the GETOPT_OPTFILE option which put us here!
 	 */
 	sz = 0;
-	for ( i =  0 ; i < *argcp ; i++ ) {
-		if ( i == ( int )optfileix ) {
+	for (i =  0 ; i < *argcp ; i++) {
+		if (i == (int)optfileix) {
 			i++; /* to skip option argument */
 			continue;
 		}
-		sz += strlen( ( * argvp )[ i ] ) + 1;
+		sz += strlen((* argvp)[i]) + 1;
 	}
 
 	/* add in the size of the option file (plus one byte in case
 	 * option file ends without newline, and one NULL for safety)
 	 */
-	sz += ( size_t )stat.st_size + 2;
+	sz += (size_t)stat.st_size + 2;
 
 	/* allocate an argument buffer
 	 */
-	argbuf = ( char * )malloc( sz );
-	assert( argbuf );
+	argbuf = (char *)malloc(sz);
+	assert(argbuf);
 
-	/* copy arg0 (the executable's name ) in first
+	/* copy arg0 (the executable's name) in first
 	 */
 	p = argbuf;
 	i = 0;
-	sprintf( p, "%s ", ( * argvp )[ i ] );
-	p += strlen( ( * argvp )[ i ] ) + 1;
+	sprintf(p, "%s ", ( * argvp)[ i]);
+	p += strlen((* argvp)[i]) + 1;
 	i++;
 
 	/* copy the options file into the buffer after the given args
 	 */
-	nread = read( fd, ( void * )p, ( size_t )stat.st_size );
-	if ( nread < 0 ) {
-		mlog( MLOG_ERROR | MLOG_NOLOCK,
+	nread = read(fd, (void *)p, (size_t)stat.st_size);
+	if (nread < 0) {
+		mlog(MLOG_ERROR | MLOG_NOLOCK,
 		      _("read of option file %s failed: %s (%d)\n"),
 		      optfilename,
-		      strerror( errno ),
-		      errno );
-		close( fd );
+		      strerror(errno),
+		      errno);
+		close(fd);
 		return BOOL_FALSE;
 	}
-	assert( ( off64_t )nread == stat.st_size );
-	p += ( size_t )stat.st_size;
+	assert((off64_t)nread == stat.st_size);
+	p += (size_t)stat.st_size;
 	*p++ = ' ';
 
 	/* copy the remaining command line args into the buffer
 	 */
-	for ( ; i < *argcp ; i++ ) {
-		if ( i == ( int )optfileix ) {
+	for (; i < *argcp ; i++) {
+		if (i == (int)optfileix) {
 			i++; /* to skip option argument */
 			continue;
 		}
-		sprintf( p, "%s ", ( * argvp )[ i ] );
-		p += strlen( ( * argvp )[ i ] ) + 1;
+		sprintf(p, "%s ", ( * argvp)[ i]);
+		p += strlen((* argvp)[i]) + 1;
 	}
 
 	/* null-terminate the entire buffer
 	 */
 	*p++ = 0;
-	assert( ( size_t )( p - argbuf ) <= sz );
+	assert((size_t)(p - argbuf) <= sz);
 
 	/* change newlines and carriage returns into spaces
 	 */
-	for ( p = argbuf ; *p ; p++ ) {
-		if ( strchr( "\n\r", ( int )( *p ))) {
+	for (p = argbuf ; *p ; p++) {
+		if (strchr("\n\r", ( int)( *p))) {
 			*p = ' ';
 		}
 	}
@@ -1287,16 +1287,16 @@ loadoptfile( int *argcp, char ***argvp )
 	 */
 	tokencnt = 0;
 	p = argbuf;
-	for ( ; ; ) {
+	for (; ;) {
 		/* start at the first non-separator character
 		 */
-		while ( *p && strchr( sep, ( int )( *p ))) {
+		while (*p && strchr(sep, (int)(*p))) {
 			p++;
 		}
 
 		/* done when NULL encountered
 		 */
-		if ( ! *p ) {
+		if (! *p) {
 			break;
 		}
 
@@ -1306,71 +1306,71 @@ loadoptfile( int *argcp, char ***argvp )
 
 		/* find the end of the first token
 		 */
-		p = strpbrkquotes( p, sep );
+		p = strpbrkquotes(p, sep);
 
 		/* if no more separators, all tokens seen
 		 */
-		if ( ! p ) {
+		if (! p) {
 			break;
 		}
 	}
 
 	/* if no arguments, can return now
 	 */
-	if ( ! tokencnt ) {
-		close( fd );
+	if (! tokencnt) {
+		close(fd);
 		return BOOL_TRUE;
 	}
 
 	/* allocate a new argv array to hold the tokens
 	 */
-	newargv = ( char ** )calloc( tokencnt, sizeof( char * ));
-	assert( newargv );
+	newargv = (char **)calloc(tokencnt, sizeof(char *));
+	assert(newargv);
 
 	/* null-terminate tokens and place in new argv, after
 	 * extracting quotes and escapes
 	 */
 	p = argbuf;
-	for ( i = 0 ; ; i++ ) {
+	for (i = 0 ; ; i++) {
 		char *endp = 0;
 
 		/* start at the first non-separator character
 		 */
-		while ( *p && strchr( sep, ( int )*p )) {
+		while (*p && strchr(sep, (int)*p)) {
 			p++;
 		}
 
 		/* done when NULL encountered
 		 */
-		if ( ! *p ) {
+		if (! *p) {
 			break;
 		}
 
 		/* better not disagree with counting scan!
 		 */
-		assert( i < ( int )tokencnt );
+		assert(i < (int)tokencnt);
 
 		/* find the end of the first token
 		 */
-		endp = strpbrkquotes( p, sep );
+		endp = strpbrkquotes(p, sep);
 
 		/* null-terminate if needed
 		 */
-		if ( endp ) {
+		if (endp) {
 			*endp = 0;
 		}
 
 		/* strip quotes and escapes
 		 */
-		p = stripquotes( p );
+		p = stripquotes(p);
 
 		/* stick result in new argv array
 		 */
-		newargv[ i ] = p;
+		newargv[i] = p;
 
 		/* if no more separators, all tokens seen
 		 */
-		if ( ! endp ) {
+		if (! endp) {
 			break;
 		}
 
@@ -1379,8 +1379,8 @@ loadoptfile( int *argcp, char ***argvp )
 
 	/* return new argc anr argv
 	 */
-	close( fd );
-	*argcp = ( int )tokencnt;
+	close(fd);
+	*argcp = (int)tokencnt;
 	*argvp = newargv;
 	return BOOL_TRUE;
 }
@@ -1388,43 +1388,43 @@ loadoptfile( int *argcp, char ***argvp )
 /* parent and children share this handler.
  */
 static void
-sighandler( int signo )
+sighandler(int signo)
 {
 	/* dialog gets first crack at the signal
 	 */
-	if ( dlog_sighandler( signo ) )
+	if (dlog_sighandler(signo))
 		return;
 
 	/* if in pipeline, don't do anything risky. just quit.
 	 */
-	if ( pipeline ) {
+	if (pipeline) {
 		int rval;
 
-		mlog( MLOG_TRACE | MLOG_NOTE | MLOG_NOLOCK | MLOG_PROC,
+		mlog(MLOG_TRACE | MLOG_NOTE | MLOG_NOLOCK | MLOG_PROC,
 		      _("received signal %d (%s): cleanup and exit\n"),
 		      signo,
-		      sig_numstring( signo ));
+		      sig_numstring(signo));
 
-		if ( content_complete( )) {
+		if (content_complete()) {
 			rval = EXIT_NORMAL;
 		} else {
 			rval = EXIT_INTERRUPT;
 		}
 		mlog_exit(rval, RV_NONE);
-		exit( rval );
+		exit(rval);
 	}
 
-	switch ( signo ) {
+	switch (signo) {
 	case SIGHUP:
 		/* immediately disable further dialogs
 		*/
-		dlog_desist( );
+		dlog_desist();
 		sighup_received = BOOL_TRUE;
 		break;
 	case SIGTERM:
 		/* immediately disable further dialogs
 		*/
-		dlog_desist( );
+		dlog_desist();
 		sigterm_received = BOOL_TRUE;
 		break;
 	case SIGINT:
@@ -1433,7 +1433,7 @@ sighandler( int signo )
 	case SIGQUIT:
 		/* immediately disable further dialogs
 		 */
-		dlog_desist( );
+		dlog_desist();
 		sigquit_received = BOOL_TRUE;
 		break;
 	case SIGALRM:
@@ -1446,7 +1446,7 @@ sighandler( int signo )
 }
 
 static int
-childmain( void *arg1 )
+childmain(void *arg1)
 {
 	ix_t stix;
 	int exitcode;
@@ -1454,21 +1454,21 @@ childmain( void *arg1 )
 
 	/* Determine which stream I am.
 	 */
-	stix = ( ix_t )arg1;
+	stix = (ix_t)arg1;
 
 	/* tell the content manager to begin.
 	 */
 #ifdef DUMP
-	exitcode = content_stream_dump( stix );
+	exitcode = content_stream_dump(stix);
 #endif /* DUMP */
 #ifdef RESTORE
-	exitcode = content_stream_restore( stix );
+	exitcode = content_stream_restore(stix);
 #endif /* RESTORE */
 
 	/* let the drive manager shut down its slave thread
 	 */
-	drivep = drivepp[ stix ];
-	( * drivep->d_opsp->do_quit )( drivep );
+	drivep = drivepp[stix];
+	(* drivep->d_opsp->do_quit)(drivep);
 
 	return exitcode;
 }
@@ -1476,17 +1476,17 @@ childmain( void *arg1 )
 
 /* ARGSUSED */
 static void
-prompt_prog_cb( void *uctxp, dlog_pcbp_t pcb, void *pctxp )
+prompt_prog_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
 	/* query: ask for a dump label
 	 */
-	( * pcb )( pctxp,
+	(* pcb)(pctxp,
 		   progrpt_enabledpr
 		   ?
 		   _("please enter seconds between progress reports, "
 		   "or 0 to disable")
 		   :
-		   _("please enter seconds between progress reports") );
+		   _("please enter seconds between progress reports"));
 }
 
 /* SIGINTR dialog
@@ -1494,28 +1494,28 @@ prompt_prog_cb( void *uctxp, dlog_pcbp_t pcb, void *pctxp )
  * side affect is to change verbosity level.
  * return code of BOOL_TRUE indicates a stop was requested.
  */
-#define PREAMBLEMAX	( 7 + 2 * STREAM_SIMMAX )
+#define PREAMBLEMAX	(7 + 2 * STREAM_SIMMAX)
 #define QUERYMAX	3
 #define CHOICEMAX	9
 #define ACKMAX		7
 #define POSTAMBLEMAX	3
 
 static bool_t
-sigint_dialog( void )
+sigint_dialog(void)
 {
 	fold_t fold;
 	char **statline;
 	ix_t i;
 	size_t statlinecnt;
-	char *preamblestr[ PREAMBLEMAX ];
+	char *preamblestr[PREAMBLEMAX];
 	size_t preamblecnt;
-	char *querystr[ QUERYMAX ];
+	char *querystr[QUERYMAX];
 	size_t querycnt;
-	char *choicestr[ CHOICEMAX ];
+	char *choicestr[CHOICEMAX];
 	size_t choicecnt;
-	char *ackstr[ ACKMAX ];
+	char *ackstr[ACKMAX];
 	size_t ackcnt;
-	char *postamblestr[ POSTAMBLEMAX ];
+	char *postamblestr[POSTAMBLEMAX];
 	size_t postamblecnt;
 	size_t interruptix;
 	size_t verbosityix;
@@ -1540,55 +1540,55 @@ sigint_dialog( void )
 
 	/* preamble: the content status line, indicate if interrupt happening
 	 */
-	fold_init( fold, _("status and control dialog"), '=' );
-	statlinecnt = content_statline( &statline );
+	fold_init(fold, _("status and control dialog"), '=');
+	statlinecnt = content_statline(&statline);
 	preamblecnt = 0;
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = "\n";
-	for ( i = 0 ; i < statlinecnt ; i++ ) {
-		preamblestr[ preamblecnt++ ] = statline[ i ];
-	}
-	if ( stop_in_progress ) {
-		preamblestr[ preamblecnt++ ] =
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++ ] = "\n";
+	for (i = 0 ; i < statlinecnt ; i++) {
+		preamblestr[preamblecnt++] = statline[i];
+	}
+	if (stop_in_progress) {
+		preamblestr[preamblecnt++] =
 			_("\nsession interrupt in progress\n");
 	}
-	preamblestr[ preamblecnt++ ] = "\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	preamblestr[preamblecnt++ ] = "\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* top-level query: a function of session interrupt status
 	 */
 	querycnt = 0;
-	querystr[ querycnt++ ] = _("please select one of "
+	querystr[querycnt++ ] = _("please select one of "
 				 "the following operations\n");
-	assert( querycnt <= QUERYMAX );
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
-	if ( ! stop_in_progress ) {
+	if (! stop_in_progress) {
 		interruptix = choicecnt;
-		choicestr[ choicecnt++ ] = _("interrupt this session");
+		choicestr[choicecnt++ ] = _("interrupt this session");
 	} else {
 		interruptix = SIZEMAX; /* never happen */
 	}
 
 	verbosityix = choicecnt;
-	choicestr[ choicecnt++ ] = _("change verbosity");
+	choicestr[choicecnt++ ] = _("change verbosity");
 	metricsix = choicecnt;
-	choicestr[ choicecnt++ ] = _("display metrics");
-	if ( content_media_change_needed ) {
+	choicestr[choicecnt++ ] = _("display metrics");
+	if (content_media_change_needed) {
 		mediachangeix = choicecnt;
-		choicestr[ choicecnt++ ] = _("confirm media change");
+		choicestr[choicecnt++ ] = _("confirm media change");
 	} else {
 		mediachangeix = SIZEMAX; /* never happen */
 	}
 	controlix = choicecnt;
-	choicestr[ choicecnt++ ] = _("other controls");
+	choicestr[choicecnt++ ] = _("other controls");
 	continueix = choicecnt;
-	choicestr[ choicecnt++ ] = _("continue");
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++ ] = _("continue");
+	assert(choicecnt <= CHOICEMAX);
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -1600,22 +1600,22 @@ sigint_dialog( void )
 				       continueix,	/* timeout ix */
 				       continueix,	/* sigint ix */
 				       continueix,	/* sighup ix */
-				       continueix );	/* sigquit ix */
-	if ( responseix == interruptix ) {
+				       continueix);	/* sigquit ix */
+	if (responseix == interruptix) {
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = "\n";
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		ackstr[ackcnt++ ] = "\n";
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		querycnt = 0;
-		querystr[ querycnt++ ] = _("please confirm\n");
-		assert( querycnt <= QUERYMAX );
+		querystr[querycnt++ ] = _("please confirm\n");
+		assert(querycnt <= QUERYMAX);
 		choicecnt = 0;
 		interruptix = choicecnt;
-		choicestr[ choicecnt++ ] = _("interrupt this session");
+		choicestr[choicecnt++ ] = _("interrupt this session");
 		nochangeix = choicecnt;
-		choicestr[ choicecnt++ ] = _("continue");
-		assert( choicecnt <= CHOICEMAX );
-		responseix = dlog_multi_query( querystr,
+		choicestr[choicecnt++ ] = _("continue");
+		assert(choicecnt <= CHOICEMAX);
+		responseix = dlog_multi_query(querystr,
 					       querycnt,
 					       choicestr,
 					       choicecnt,
@@ -1629,35 +1629,35 @@ sigint_dialog( void )
 					       nochangeix, /* sighup ix */
 					       nochangeix);/* sigquit ix */
 		ackcnt = 0;
-		if ( responseix == nochangeix ) {
-			ackstr[ ackcnt++ ] = _("continuing\n");
+		if (responseix == nochangeix) {
+			ackstr[ackcnt++ ] = _("continuing\n");
 		} else {
-			ackstr[ ackcnt++ ] = _("interrupt request accepted\n");
+			ackstr[ackcnt++ ] = _("interrupt request accepted\n");
 			stop_requested = BOOL_TRUE;
 		}
-		dlog_multi_ack( ackstr,
-				ackcnt );
-	} else if ( responseix == verbosityix ) {
+		dlog_multi_ack(ackstr,
+				ackcnt);
+	} else if (responseix == verbosityix) {
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = "\n";
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		ackstr[ackcnt++ ] = "\n";
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		querycnt = 0;
-		querystr[ querycnt++ ] = _("please select one of "
+		querystr[querycnt++ ] = _("please select one of "
 					 "the following subsystems\n");
-		assert( querycnt <= QUERYMAX );
+		assert(querycnt <= QUERYMAX);
 		choicecnt = 0;
 		/* number of lines must match number of subsystems
 		 */
-		for ( choicecnt = 0 ; choicecnt < MLOG_SS_CNT ; choicecnt++ ) {
-			choicestr[ choicecnt ] = mlog_ss_names[ choicecnt ];
+		for (choicecnt = 0 ; choicecnt < MLOG_SS_CNT ; choicecnt++) {
+			choicestr[choicecnt] = mlog_ss_names[choicecnt];
 		}
 		allix = choicecnt;
-		choicestr[ choicecnt++ ] = _("all of the above");
+		choicestr[choicecnt++ ] = _("all of the above");
 		nochangeix = choicecnt;
-		choicestr[ choicecnt++ ] = _("no change");
-		assert( choicecnt <= CHOICEMAX );
-		responseix = dlog_multi_query( querystr,
+		choicestr[choicecnt++ ] = _("no change");
+		assert(choicecnt <= CHOICEMAX);
+		responseix = dlog_multi_query(querystr,
 					       querycnt,
 					       choicestr,
 					       choicecnt,
@@ -1671,33 +1671,33 @@ sigint_dialog( void )
 					       nochangeix, /* sighup ix */
 					       nochangeix);/* sigquit ix */
 		ackcnt = 0;
-		if ( responseix == nochangeix ) {
-			ackstr[ ackcnt++ ] = _("no change\n");
-		} else if ( responseix == allix ) {
+		if (responseix == nochangeix) {
+			ackstr[ackcnt++ ] = _("no change\n");
+		} else if (responseix == allix) {
 			ssselected = -1;
-			ackstr[ ackcnt++ ] = _("all subsystems selected\n\n");
+			ackstr[ackcnt++ ] = _("all subsystems selected\n\n");
 		} else {
-			ssselected = ( int )responseix;
-			ackstr[ ackcnt++ ] = "\n";
+			ssselected = (int)responseix;
+			ackstr[ackcnt++ ] = "\n";
 		}
-		dlog_multi_ack( ackstr,
-				ackcnt );
-		if ( responseix != nochangeix ) {
+		dlog_multi_ack(ackstr,
+				ackcnt);
+		if (responseix != nochangeix) {
 			querycnt = 0;
-			querystr[ querycnt++ ] = ("please select one of the "
+			querystr[querycnt++ ] = ("please select one of the "
 						  "following verbosity levels\n");
-			assert( querycnt <= QUERYMAX );
+			assert(querycnt <= QUERYMAX);
 			choicecnt = 0;
-			choicestr[ choicecnt++ ] = _("silent");
-			choicestr[ choicecnt++ ] = _("verbose");
-			choicestr[ choicecnt++ ] = _("trace");
-			choicestr[ choicecnt++ ] = _("debug");
-			choicestr[ choicecnt++ ] = _("nitty");
-			choicestr[ choicecnt++ ] = _("nitty + 1");
+			choicestr[choicecnt++ ] = _("silent");
+			choicestr[choicecnt++ ] = _("verbose");
+			choicestr[choicecnt++ ] = _("trace");
+			choicestr[choicecnt++ ] = _("debug");
+			choicestr[choicecnt++ ] = _("nitty");
+			choicestr[choicecnt++ ] = _("nitty + 1");
 			nochangeix = choicecnt;
-			choicestr[ choicecnt++ ] = _("no change");
-			assert( choicecnt <= CHOICEMAX );
-			responseix = dlog_multi_query( querystr,
+			choicestr[choicecnt++ ] = _("no change");
+			assert(choicecnt <= CHOICEMAX);
+			responseix = dlog_multi_query(querystr,
 						       querycnt,
 						       choicestr,
 						       choicecnt,
@@ -1710,7 +1710,7 @@ sigint_dialog( void )
 						       ?
 						       IXMAX
 						       :
-			     ( ix_t )mlog_level_ss[ ssselected ], /* hiliteix */
+			     (ix_t)mlog_level_ss[ssselected], /* hiliteix */
 						       0,       /* defaultstr */
 						      nochangeix,/* defaultix */
 						    DLOG_TIMEOUT,/* timeout */
@@ -1719,57 +1719,57 @@ sigint_dialog( void )
 						     nochangeix, /* sighup ix */
 						    nochangeix);/* sigquit ix */
 			ackcnt = 0;
-			if ( responseix == nochangeix
+			if (responseix == nochangeix
 			     ||
-			     ( ssselected >= 0
+			     (ssselected >= 0
 			       &&
 			       responseix
 			       ==
-			       ( ix_t )mlog_level_ss[ ssselected ] )) {
-				ackstr[ ackcnt++ ] = _("no change\n");
+			       (ix_t)mlog_level_ss[ssselected])) {
+				ackstr[ackcnt++ ] = _("no change\n");
 			} else {
-				if ( ssselected < 0 ) {
+				if (ssselected < 0) {
 					ix_t ssix;
-					assert( ssselected == -1 );
-					for ( ssix = 0
+					assert(ssselected == -1);
+					for (ssix = 0
 					      ;
 					      ssix < MLOG_SS_CNT
 					      ;
-					      ssix++ ) {
-						mlog_level_ss[ ssix ] =
-							( int )responseix;
+					      ssix++) {
+						mlog_level_ss[ssix] =
+							(int)responseix;
 					}
 				} else {
-					mlog_level_ss[ ssselected ] =
-							( int )responseix;
+					mlog_level_ss[ssselected] =
+							(int)responseix;
 				}
-				ackstr[ ackcnt++ ] = _("level changed\n");
+				ackstr[ackcnt++ ] = _("level changed\n");
 			}
-			dlog_multi_ack( ackstr,
-					ackcnt );
+			dlog_multi_ack(ackstr,
+					ackcnt);
 		}
-	} else if ( responseix == metricsix ) {
+	} else if (responseix == metricsix) {
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = "\n";
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		ackstr[ackcnt++ ] = "\n";
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		querycnt = 0;
-		querystr[ querycnt++ ] = _("please select one of "
+		querystr[querycnt++ ] = _("please select one of "
 					  "the following metrics\n");
-		assert( querycnt <= QUERYMAX );
+		assert(querycnt <= QUERYMAX);
 		choicecnt = 0;
 		ioix = choicecnt;
-		choicestr[ choicecnt++ ] = _("I/O");
+		choicestr[choicecnt++ ] = _("I/O");
 #ifdef RESTORE
 		piix = choicecnt;
-		choicestr[ choicecnt++ ] = _("media inventory status");
+		choicestr[choicecnt++ ] = _("media inventory status");
 		roix = choicecnt;
-		choicestr[ choicecnt++ ] = _("needed media objects");
+		choicestr[choicecnt++ ] = _("needed media objects");
 #endif /* RESTORE */
 		nochangeix = choicecnt;
-		choicestr[ choicecnt++ ] = _("continue");
-		assert( choicecnt <= CHOICEMAX );
-		responseix = dlog_multi_query( querystr,
+		choicestr[choicecnt++ ] = _("continue");
+		assert(choicecnt <= CHOICEMAX);
+		responseix = dlog_multi_query(querystr,
 					       querycnt,
 					       choicestr,
 					       choicecnt,
@@ -1782,31 +1782,31 @@ sigint_dialog( void )
 					       nochangeix, /* sigint ix */
 					       nochangeix, /* sighup ix */
 					       nochangeix);/* sigquit ix */
-		if ( responseix != nochangeix ) {
+		if (responseix != nochangeix) {
 			ackcnt = 0;
-			ackstr[ ackcnt++ ] = "\n";
-			dlog_multi_ack( ackstr,
-					ackcnt );
+			ackstr[ackcnt++ ] = "\n";
+			dlog_multi_ack(ackstr,
+					ackcnt);
 		}
-		if ( responseix == ioix ) {
-			drive_display_metrics( );
+		if (responseix == ioix) {
+			drive_display_metrics();
 #ifdef RESTORE
-		} else if ( responseix == piix ) {
-			content_showinv( );
-		} else if ( responseix == roix ) {
-			content_showremainingobjects( );
+		} else if (responseix == piix) {
+			content_showinv();
+		} else if (responseix == roix) {
+			content_showremainingobjects();
 #endif /* RESTORE */
 		}
 
-		if ( responseix != nochangeix ) {
+		if (responseix != nochangeix) {
 			querycnt = 0;
-			querystr[ querycnt++ ] = "\n";
-			assert( querycnt <= QUERYMAX );
+			querystr[querycnt++ ] = "\n";
+			assert(querycnt <= QUERYMAX);
 			choicecnt = 0;
 			nochangeix = choicecnt;
-			choicestr[ choicecnt++ ] = _("continue");
-			assert( choicecnt <= CHOICEMAX );
-			responseix = dlog_multi_query( querystr,
+			choicestr[choicecnt++ ] = _("continue");
+			assert(choicecnt <= CHOICEMAX);
+			responseix = dlog_multi_query(querystr,
 						       querycnt,
 						       choicestr,
 						       choicecnt,
@@ -1821,56 +1821,56 @@ sigint_dialog( void )
 						       nochangeix);/*sigquitix*/
 		}
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = _("continuing\n");
-		dlog_multi_ack( ackstr,
-				ackcnt );
-	} else if ( responseix == mediachangeix ) {
+		ackstr[ackcnt++ ] = _("continuing\n");
+		dlog_multi_ack(ackstr,
+				ackcnt);
+	} else if (responseix == mediachangeix) {
 		ackcnt = 0;
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = content_mediachange_query( );
-		dlog_multi_ack( ackstr,
-				ackcnt );
-	} else if ( responseix == controlix ) {
+		ackstr[ackcnt++] = content_mediachange_query();
+		dlog_multi_ack(ackstr,
+				ackcnt);
+	} else if (responseix == controlix) {
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = "\n";
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		ackstr[ackcnt++ ] = "\n";
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		querycnt = 0;
-		querystr[ querycnt++ ] = _("please select one of "
+		querystr[querycnt++ ] = _("please select one of "
 					   "the following controls\n");
-		assert( querycnt <= QUERYMAX );
+		assert(querycnt <= QUERYMAX);
 		choicecnt = 0;
 		progix = choicecnt;
-		if ( progrpt_enabledpr ) {
-		    choicestr[ choicecnt++ ] = _("change interval of "
+		if (progrpt_enabledpr) {
+		    choicestr[choicecnt++ ] = _("change interval of "
 					         "or disable progress reports");
 		} else {
-		    choicestr[ choicecnt++ ] = _("enable progress reports");
+		    choicestr[choicecnt++ ] = _("enable progress reports");
 		}
 		mllevix = choicecnt;
-		if ( mlog_showlevel ) {
-			choicestr[ choicecnt++ ] = _("hide log message levels");
+		if (mlog_showlevel) {
+			choicestr[choicecnt++ ] = _("hide log message levels");
 		} else {
-			choicestr[ choicecnt++ ] = _("show log message levels");
+			choicestr[choicecnt++ ] = _("show log message levels");
 		}
 		mlssix = choicecnt;
-		if ( mlog_showss ) {
-			choicestr[ choicecnt++ ] = _("hide log message subsystems");
+		if (mlog_showss) {
+			choicestr[choicecnt++ ] = _("hide log message subsystems");
 		} else {
-			choicestr[ choicecnt++ ] = _("show log message subsystems");
+			choicestr[choicecnt++ ] = _("show log message subsystems");
 		}
 		mltsix = choicecnt;
-		if ( mlog_timestamp ) {
-			choicestr[ choicecnt++ ] = _("hide log message timestamps");
+		if (mlog_timestamp) {
+			choicestr[choicecnt++ ] = _("hide log message timestamps");
 		} else {
-			choicestr[ choicecnt++ ] = _("show log message timestamps");
+			choicestr[choicecnt++ ] = _("show log message timestamps");
 		}
 		nochangeix = choicecnt;
-		choicestr[ choicecnt++ ] = _("continue");
-		assert( choicecnt <= CHOICEMAX );
-		responseix = dlog_multi_query( querystr,
+		choicestr[choicecnt++ ] = _("continue");
+		assert(choicecnt <= CHOICEMAX);
+		responseix = dlog_multi_query(querystr,
 					       querycnt,
 					       choicestr,
 					       choicecnt,
@@ -1884,165 +1884,165 @@ sigint_dialog( void )
 					       nochangeix, /* sighup ix */
 					       nochangeix);/* sigquit ix */
 		ackcnt = 0;
-		if ( responseix == progix ) {
-			char buf[ 10 ];
+		if (responseix == progix) {
+			char buf[10];
 			const size_t ncix = 1;
 			const size_t okix = 2;
 
-			ackstr[ ackcnt++ ] = "\n";
-			dlog_multi_ack( ackstr,
-					ackcnt );
+			ackstr[ackcnt++ ] = "\n";
+			dlog_multi_ack(ackstr,
+					ackcnt);
 			ackcnt = 0;
-			responseix = dlog_string_query( prompt_prog_cb,
+			responseix = dlog_string_query(prompt_prog_cb,
 							0,
 							buf,
-							sizeof( buf ),
+							sizeof(buf),
 							DLOG_TIMEOUT,
 							ncix,/* timeout ix */
 							ncix, /* sigint ix */
 							ncix,  /* sighup ix */
 							ncix,  /* sigquit ix */
-							okix );
-			if ( responseix == okix ) {
+							okix);
+			if (responseix == okix) {
 				int newinterval;
-				newinterval = atoi( buf );
-				if ( ! strlen( buf )) {
-					ackstr[ ackcnt++ ] = _("no change\n");
-				} else if ( newinterval > 0 ) {
+				newinterval = atoi(buf);
+				if (! strlen(buf)) {
+					ackstr[ackcnt++ ] = _("no change\n");
+				} else if (newinterval > 0) {
 					time32_t newdeadline;
-					char intervalbuf[ 64 ];
-					newdeadline = time( 0 ) + ( time32_t )newinterval;
-					if ( progrpt_enabledpr ) {
-						if ( ( time32_t )newinterval == progrpt_interval ) {
-							ackstr[ ackcnt++ ] = _("no change\n");
+					char intervalbuf[64];
+					newdeadline = time(0) + (time32_t)newinterval;
+					if (progrpt_enabledpr) {
+						if ((time32_t)newinterval == progrpt_interval) {
+							ackstr[ackcnt++ ] = _("no change\n");
 						} else {
-							ackstr[ ackcnt++ ] = _("changing progress report interval to ");
-							sprintf( intervalbuf,
+							ackstr[ackcnt++ ] = _("changing progress report interval to ");
+							sprintf(intervalbuf,
 								 _("%d seconds\n"),
-								 newinterval );
-							assert( strlen( intervalbuf )
+								 newinterval);
+							assert(strlen(intervalbuf)
 								<
-								sizeof( intervalbuf ));
-							ackstr[ ackcnt++ ] = intervalbuf;
-							if ( progrpt_deadline > newdeadline ) {
+								sizeof(intervalbuf));
+							ackstr[ackcnt++] = intervalbuf;
+							if (progrpt_deadline > newdeadline) {
 								progrpt_deadline = newdeadline;
 							}
 						}
 					} else {
-						ackstr[ ackcnt++ ] = _("enabling progress reports at ");
-						sprintf( intervalbuf,
+						ackstr[ackcnt++ ] = _("enabling progress reports at ");
+						sprintf(intervalbuf,
 							 _("%d second intervals\n"),
-							 newinterval );
-						assert( strlen( intervalbuf )
+							 newinterval);
+						assert(strlen(intervalbuf)
 							<
-							sizeof( intervalbuf ));
-						ackstr[ ackcnt++ ] = intervalbuf;
+							sizeof(intervalbuf));
+						ackstr[ackcnt++] = intervalbuf;
 						progrpt_enabledpr = BOOL_TRUE;
 						progrpt_deadline = newdeadline;
 					}
-					progrpt_interval = ( time32_t )newinterval;
+					progrpt_interval = (time32_t)newinterval;
 				} else {
-					if ( progrpt_enabledpr ) {
-						ackstr[ ackcnt++ ] = _("disabling progress reports\n");
+					if (progrpt_enabledpr) {
+						ackstr[ackcnt++ ] = _("disabling progress reports\n");
 					} else {
-						ackstr[ ackcnt++ ] = _("no change\n");
+						ackstr[ackcnt++ ] = _("no change\n");
 					}
 					progrpt_enabledpr = BOOL_FALSE;
 				}
 			} else {
-				ackstr[ ackcnt++ ] = _("no change\n");
+				ackstr[ackcnt++ ] = _("no change\n");
 			}
-		} else if ( responseix == mllevix ) {
+		} else if (responseix == mllevix) {
 			mlog_showlevel = ! mlog_showlevel;
-			if ( mlog_showlevel ) {
-				ackstr[ ackcnt++ ] = _("showing log message levels\n");
+			if (mlog_showlevel) {
+				ackstr[ackcnt++ ] = _("showing log message levels\n");
 			} else {
-				ackstr[ ackcnt++ ] = _("hiding log message levels\n");
+				ackstr[ackcnt++ ] = _("hiding log message levels\n");
 			}
-		} else if ( responseix == mlssix ) {
+		} else if (responseix == mlssix) {
 			mlog_showss = ! mlog_showss;
-			if ( mlog_showss ) {
-				ackstr[ ackcnt++ ] = _("showing log message subsystems\n");
+			if (mlog_showss) {
+				ackstr[ackcnt++ ] = _("showing log message subsystems\n");
 			} else {
-				ackstr[ ackcnt++ ] = _("hiding log message subsystems\n");
+				ackstr[ackcnt++ ] = _("hiding log message subsystems\n");
 			}
-		} else if ( responseix == mltsix ) {
+		} else if (responseix == mltsix) {
 			mlog_timestamp = ! mlog_timestamp;
-			if ( mlog_timestamp ) {
-				ackstr[ ackcnt++ ] = _("showing log message timestamps\n");
+			if (mlog_timestamp) {
+				ackstr[ackcnt++ ] = _("showing log message timestamps\n");
 			} else {
-				ackstr[ ackcnt++ ] = _("hiding log message timestamps\n");
+				ackstr[ackcnt++ ] = _("hiding log message timestamps\n");
 			}
 		}
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		dlog_multi_ack(ackstr,
+				ackcnt);
 	} else {
 		ackcnt = 0;
-		ackstr[ ackcnt++ ] = _("continuing\n");
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		ackstr[ackcnt++ ] = _("continuing\n");
+		dlog_multi_ack(ackstr,
+				ackcnt);
 	}
 
-	fold_init( fold, _("end dialog"), '-' );
+	fold_init(fold, _("end dialog"), '-');
 	postamblecnt = 0;
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
 
 	return stop_requested;
 }
 
 static char *
-sigintstr( void )
+sigintstr(void)
 {
 	int ttyfd;
-	static char buf[ 20 ];
+	static char buf[20];
 	struct termios termios;
 	cc_t intchr;
 	int rval;
 
-	ttyfd = dlog_fd( );
-	if ( ttyfd == -1 ) {
+	ttyfd = dlog_fd();
+	if (ttyfd == -1) {
 		return 0;
 	}
 
-	rval = tcgetattr( ttyfd, &termios );
-	if ( rval ) {
-		mlog( MLOG_NITTY | MLOG_PROC,
+	rval = tcgetattr(ttyfd, &termios);
+	if (rval) {
+		mlog(MLOG_NITTY | MLOG_PROC,
 		      "could not get controlling terminal information: %s\n",
-		      strerror( errno ));
+		      strerror(errno));
 		return 0;
 	}
 
-	intchr = termios.c_cc[ VINTR ];
-	mlog( MLOG_NITTY | MLOG_PROC,
+	intchr = termios.c_cc[VINTR];
+	mlog(MLOG_NITTY | MLOG_PROC,
 	      "tty fd: %d; terminal interrupt character: %c (0%o)\n",
 	      ttyfd,
 	      intchr,
-	      intchr );
+	      intchr);
 
-	if ( intchr < ' ' ) {
-		sprintf( buf, "^%c", intchr + '@' );
-	} else if ( intchr == 0177 ) {
-		sprintf( buf, "DEL" );
+	if (intchr < ' ') {
+		sprintf(buf, "^%c", intchr + '@');
+	} else if (intchr == 0177) {
+		sprintf(buf, "DEL");
 	} else {
-		sprintf( buf, "%c", intchr );
+		sprintf(buf, "%c", intchr);
 	}
-	assert( strlen( buf ) < sizeof( buf ));
+	assert(strlen(buf) < sizeof(buf));
 
 	return buf;
 }
 
 #ifdef DUMP
 static bool_t
-set_rlimits( void )
+set_rlimits(void)
 #endif /* DUMP */
 #ifdef RESTORE
 static bool_t
-set_rlimits( size64_t *vmszp )
+set_rlimits(size64_t *vmszp)
 #endif /* RESTORE */
 {
 	struct rlimit64 rlimit64;
@@ -2052,40 +2052,40 @@ set_rlimits( size64_t *vmszp )
 	/* REFERENCED */
 	int rval;
 
-	assert( minstacksz <= maxstacksz );
+	assert(minstacksz <= maxstacksz);
 
-	rval = getrlimit64( RLIMIT_AS, &rlimit64 );
+	rval = getrlimit64(RLIMIT_AS, &rlimit64);
 
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_AS org cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 #ifdef RESTORE
 	if (rlimit64.rlim_cur != RLIM64_INFINITY) {
 		rlimit64.rlim_cur = rlimit64.rlim_max;
-		( void )setrlimit64( RLIMIT_AS, &rlimit64 );
-		rval = getrlimit64( RLIMIT_AS, &rlimit64 );
-		assert( ! rval );
-		mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+		(void)setrlimit64(RLIMIT_AS, &rlimit64);
+		rval = getrlimit64(RLIMIT_AS, &rlimit64);
+		assert(! rval);
+		mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 			"RLIMIT_VMEM now cur 0x%llx max 0x%llx\n",
 			rlimit64.rlim_cur,
-			rlimit64.rlim_max );
+			rlimit64.rlim_max);
 	}
 
-	vmsz = ( size64_t )rlimit64.rlim_cur;
+	vmsz = (size64_t)rlimit64.rlim_cur;
 #endif /* RESTORE */
 
-	assert( minstacksz <= maxstacksz );
-	rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	assert(minstacksz <= maxstacksz);
+	rval = getrlimit64(RLIMIT_STACK, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_STACK org cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
-	if ( rlimit64.rlim_cur < minstacksz ) {
-		if ( rlimit64.rlim_max < minstacksz ) {
-			mlog( MLOG_DEBUG
+	      rlimit64.rlim_max);
+	if (rlimit64.rlim_cur < minstacksz) {
+		if (rlimit64.rlim_max < minstacksz) {
+			mlog(MLOG_DEBUG
 			      |
 			      MLOG_NOLOCK
 			      |
@@ -2093,14 +2093,14 @@ set_rlimits( size64_t *vmszp )
 			      "raising stack size hard limit "
 			      "from 0x%llx to 0x%llx\n",
 			      rlimit64.rlim_max,
-			      minstacksz );
+			      minstacksz);
 			rlimit64.rlim_cur = minstacksz;
 			rlimit64.rlim_max = minstacksz;
-			( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
-			rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
-			assert( ! rval );
-			if ( rlimit64.rlim_cur < minstacksz ) {
-				mlog( MLOG_NORMAL
+			(void)setrlimit64(RLIMIT_STACK, &rlimit64);
+			rval = getrlimit64(RLIMIT_STACK, &rlimit64);
+			assert(! rval);
+			if (rlimit64.rlim_cur < minstacksz) {
+				mlog(MLOG_NORMAL
 				      |
 				      MLOG_WARNING
 				      |
@@ -2110,10 +2110,10 @@ set_rlimits( size64_t *vmszp )
 				      _("unable to raise stack size hard limit "
 				      "from 0x%llx to 0x%llx\n"),
 				      rlimit64.rlim_max,
-				      minstacksz );
+				      minstacksz);
 			}
 		} else {
-			mlog( MLOG_DEBUG
+			mlog(MLOG_DEBUG
 			      |
 			      MLOG_NOLOCK
 			      |
@@ -2121,13 +2121,13 @@ set_rlimits( size64_t *vmszp )
 			      "raising stack size soft limit "
 			      "from 0x%llx to 0x%llx\n",
 			      rlimit64.rlim_cur,
-			      minstacksz );
+			      minstacksz);
 			rlimit64.rlim_cur = minstacksz;
-			( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
-			rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
-			assert( ! rval );
-			if ( rlimit64.rlim_cur < minstacksz ) {
-				mlog( MLOG_NORMAL
+			(void)setrlimit64(RLIMIT_STACK, &rlimit64);
+			rval = getrlimit64(RLIMIT_STACK, &rlimit64);
+			assert(! rval);
+			if (rlimit64.rlim_cur < minstacksz) {
+				mlog(MLOG_NORMAL
 				      |
 				      MLOG_WARNING
 				      |
@@ -2137,11 +2137,11 @@ set_rlimits( size64_t *vmszp )
 				      _("unable to raise stack size soft limit "
 				      "from 0x%llx to 0x%llx\n"),
 				      rlimit64.rlim_cur,
-				      minstacksz );
+				      minstacksz);
 			}
 		}
-	} else if ( rlimit64.rlim_cur > maxstacksz ) {
-		mlog( MLOG_DEBUG
+	} else if (rlimit64.rlim_cur > maxstacksz) {
+		mlog(MLOG_DEBUG
 		      |
 		      MLOG_NOLOCK
 		      |
@@ -2149,13 +2149,13 @@ set_rlimits( size64_t *vmszp )
 		      "lowering stack size soft limit "
 		      "from 0x%llx to 0x%llx\n",
 		      rlimit64.rlim_cur,
-		      maxstacksz );
+		      maxstacksz);
 		rlimit64.rlim_cur = maxstacksz;
-		( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
-		rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
-		assert( ! rval );
-		if ( rlimit64.rlim_cur > maxstacksz ) {
-			mlog( MLOG_NORMAL
+		(void)setrlimit64(RLIMIT_STACK, &rlimit64);
+		rval = getrlimit64(RLIMIT_STACK, &rlimit64);
+		assert(! rval);
+		if (rlimit64.rlim_cur > maxstacksz) {
+			mlog(MLOG_NORMAL
 			      |
 			      MLOG_WARNING
 			      |
@@ -2165,52 +2165,52 @@ set_rlimits( size64_t *vmszp )
 			      _("unable to lower stack size soft limit "
 			      "from 0x%llx to 0x%llx\n"),
 			      rlimit64.rlim_cur,
-			      maxstacksz );
+			      maxstacksz);
 		}
 	}
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_STACK new cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 
-	rval = getrlimit64( RLIMIT_DATA, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	rval = getrlimit64(RLIMIT_DATA, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_DATA org cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 
-	rval = getrlimit64( RLIMIT_FSIZE, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	rval = getrlimit64(RLIMIT_FSIZE, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_FSIZE org cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 	rlimit64.rlim_cur = rlimit64.rlim_max;
-	( void )setrlimit64( RLIMIT_FSIZE, &rlimit64 );
+	(void)setrlimit64(RLIMIT_FSIZE, &rlimit64);
 	rlimit64.rlim_cur = RLIM64_INFINITY;
-	( void )setrlimit64( RLIMIT_FSIZE, &rlimit64 );
-	rval = getrlimit64( RLIMIT_FSIZE, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	(void)setrlimit64(RLIMIT_FSIZE, &rlimit64);
+	rval = getrlimit64(RLIMIT_FSIZE, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_FSIZE now cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 
-	rval = getrlimit64( RLIMIT_CPU, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	rval = getrlimit64(RLIMIT_CPU, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_CPU cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 	rlimit64.rlim_cur = rlimit64.rlim_max;
-	( void )setrlimit64( RLIMIT_CPU, &rlimit64 );
-	rval = getrlimit64( RLIMIT_CPU, &rlimit64 );
-	assert( ! rval );
-	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
+	(void)setrlimit64(RLIMIT_CPU, &rlimit64);
+	rval = getrlimit64(RLIMIT_CPU, &rlimit64);
+	assert(! rval);
+	mlog(MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
 	      "RLIMIT_CPU now cur 0x%llx max 0x%llx\n",
 	      rlimit64.rlim_cur,
-	      rlimit64.rlim_max );
+	      rlimit64.rlim_max);
 
 #ifdef RESTORE
 	*vmszp = vmsz;
@@ -2225,7 +2225,7 @@ struct sig_printmap {
 
 typedef struct sig_printmap sig_printmap_t;
 
-static sig_printmap_t sig_printmap[ ] = {
+static sig_printmap_t sig_printmap[] = {
 	{SIGHUP,	"SIGHUP"},
 	{SIGINT,	"SIGINT"},
 	{SIGQUIT,	"SIGQUIT"},
@@ -2256,16 +2256,16 @@ static sig_printmap_t sig_printmap[ ] = {
 };
 
 static char *
-sig_numstring( int num )
+sig_numstring(int num)
 {
 	sig_printmap_t *p = sig_printmap;
 	sig_printmap_t *endp = sig_printmap
 			       +
-			       ( sizeof( sig_printmap )
+			       (sizeof(sig_printmap)
 			         /
-			         sizeof( sig_printmap[ 0 ] ));
-	for ( ; p < endp ; p++ ) {
-		if ( p->num == num ) {
+			         sizeof(sig_printmap[0]));
+	for (; p < endp ; p++) {
+		if (p->num == num) {
 			return p->string;
 		}
 	}
@@ -2274,18 +2274,18 @@ sig_numstring( int num )
 }
 
 static char *
-strpbrkquotes( char *p, const char *sep )
+strpbrkquotes(char *p, const char *sep)
 {
 	bool_t prevcharwasbackslash = BOOL_FALSE;
 	bool_t inquotes = BOOL_FALSE;
 
-	for ( ; ; p++ ) {
-		if ( *p == 0 ) {
+	for (; ; p++) {
+		if (*p == 0) {
 			return 0;
 		}
 
-		if ( *p == '\\' ) {
-			if ( ! prevcharwasbackslash ) {
+		if (*p == '\\') {
+			if (! prevcharwasbackslash) {
 				prevcharwasbackslash = BOOL_TRUE;
 			} else {
 				prevcharwasbackslash = BOOL_FALSE;
@@ -2293,12 +2293,12 @@ strpbrkquotes( char *p, const char *sep )
 			continue;
 		}
 
-		if ( *p == '"' ) {
-			if ( prevcharwasbackslash ) {
+		if (*p == '"') {
+			if (prevcharwasbackslash) {
 				prevcharwasbackslash = BOOL_FALSE;
 				continue;
 			}
-			if ( inquotes ) {
+			if (inquotes) {
 				inquotes = BOOL_FALSE;
 			} else {
 				inquotes = BOOL_TRUE;
@@ -2306,8 +2306,8 @@ strpbrkquotes( char *p, const char *sep )
 			continue;
 		}
 
-		if ( ! inquotes ) {
-			if ( strchr( sep, ( int )( *p ))) {
+		if (! inquotes) {
+			if (strchr(sep, (int)(*p))) {
 				return p;
 			}
 		}
@@ -2318,18 +2318,18 @@ strpbrkquotes( char *p, const char *sep )
 }
 
 static char *
-stripquotes( char *p )
+stripquotes(char *p)
 {
-	size_t len = strlen( p );
+	size_t len = strlen(p);
 	char *endp;
 	char *nextp;
 	bool_t justremovedbackslash;
 
-	if ( len > 2 && p[ 0 ] == '"' ) {
+	if (len > 2 && p[0 ] == '"') {
 		p++;
 		len--;
-		if ( len && p[ len - 1 ] == '"' ) {
-			p[ len - 1 ] = 0;
+		if (len && p[len - 1 ] == '"') {
+			p[len - 1] = 0;
 			len--;
 		}
 	}
@@ -2337,9 +2337,9 @@ stripquotes( char *p )
 	endp = p + len;
 	justremovedbackslash = BOOL_FALSE;
 
-	for ( nextp = p ; nextp < endp ; ) {
-		if ( *nextp == '\\' && ! justremovedbackslash ) {
-			shiftleftby1( nextp, endp );
+	for (nextp = p ; nextp < endp ;) {
+		if (*nextp == '\\' && ! justremovedbackslash) {
+			shiftleftby1(nextp, endp);
 			endp--;
 			justremovedbackslash = BOOL_TRUE;
 		} else {
@@ -2352,9 +2352,9 @@ stripquotes( char *p )
 }
 
 static void
-shiftleftby1( char *p, char *endp )
+shiftleftby1(char *p, char *endp)
 {
-	for ( ; p < endp ; p++ ) {
-		*p = p[ 1 ];
+	for (; p < endp ; p++) {
+		*p = p[1];
 	}
 }
diff --git a/common/media.c b/common/media.c
index 817e99e..15c0478 100644
--- a/common/media.c
+++ b/common/media.c
@@ -42,7 +42,7 @@
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
+extern void usage(void);
 
 /* declare all media strategies here
  */
@@ -52,7 +52,7 @@ extern media_strategy_t media_strategy_rmvtape;
 
 /* forward declarations of locally defined static functions ******************/
 
-static media_t *media_alloc( drive_t *, char * );
+static media_t *media_alloc(drive_t *, char *);
 
 
 /* definition of locally defined global variables ****************************/
@@ -74,7 +74,7 @@ static media_strategy_t *strategyp[] = {
  * and create and initialize media managers for each stream.
  */
 media_strategy_t *
-media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
+media_create(int argc, char *argv[], drive_strategy_t *dsp)
 {
 	int c;
 	size_t mediaix;
@@ -82,42 +82,42 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 	media_t **mediapp;
 	char *medialabel;
 	media_strategy_t **spp = strategyp;
-	media_strategy_t **epp = strategyp + sizeof( strategyp )
+	media_strategy_t **epp = strategyp + sizeof(strategyp)
 					     /
-					     sizeof( strategyp[ 0 ] );
+					     sizeof(strategyp[0]);
 	media_strategy_t *chosen_sp;
 	int id;
 	bool_t ok;
 
 	/* sanity check asserts
 	 */
-	assert( sizeof( media_hdr_t ) == MEDIA_HDR_SZ );
-	assert( MEDIA_MARKLOG_SZ == sizeof( media_marklog_t ));
+	assert(sizeof(media_hdr_t) == MEDIA_HDR_SZ);
+	assert(MEDIA_MARKLOG_SZ == sizeof(media_marklog_t));
 
 	/* scan the command line for a media label
 	 */
 	medialabel = 0;
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 #ifdef DUMP
 		case GETOPT_MEDIALABEL:
-			if ( medialabel ) {
-				mlog( MLOG_NORMAL,
+			if (medialabel) {
+				mlog(MLOG_NORMAL,
 				      _("too many -%c arguments: "
 				      "\"-%c %s\" already given\n"),
 				      c,
 				      c,
-				      medialabel );
-				usage( );
+				      medialabel);
+				usage();
 				return 0;
 			}
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL,
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL,
 				      _("-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return 0;
 			}
 			medialabel = optarg;
@@ -128,10 +128,10 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 
 	/* if no media label specified, synthesize one
 	 */
-	if ( ! medialabel ) {
+	if (! medialabel) {
 		/* not useful
-		mlog( MLOG_VERBOSE,
-		      _("WARNING: no media label specified\n") );
+		mlog(MLOG_VERBOSE,
+		      _("WARNING: no media label specified\n"));
 		*/
 		medialabel = "";
 	}
@@ -142,11 +142,11 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 	 * match phase, and given to the winning strategy.
 	 */
 	mediacnt = dsp->ds_drivecnt;
-	mediapp = ( media_t ** )calloc( mediacnt, sizeof( media_t * ));
-	assert( mediapp );
-	for ( mediaix = 0 ; mediaix < mediacnt ; mediaix++ ) {
-		mediapp[ mediaix ] = media_alloc( dsp->ds_drivep[ mediaix ],
-					 	  medialabel );
+	mediapp = (media_t **)calloc(mediacnt, sizeof(media_t *));
+	assert(mediapp);
+	for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+		mediapp[mediaix] = media_alloc(dsp->ds_drivep[mediaix],
+					 	  medialabel);
 	}
 
 	/* choose the first strategy which claims appropriateness.
@@ -156,26 +156,26 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 	 * media_strategy_t as well as the write headers.
 	 */
 	chosen_sp = 0;
-	for ( id = 0 ; spp < epp ; spp++, id++ ) {
+	for (id = 0 ; spp < epp ; spp++, id++) {
 		(*spp)->ms_id = id;
-		if ( ! chosen_sp ) {
+		if (! chosen_sp) {
 			/* lend the media_t array to the strategy
 			 */
 			(*spp)->ms_mediap = mediapp;
 			(*spp)->ms_dsp = dsp;
 			(*spp)->ms_mediacnt = mediacnt;
-			for ( mediaix = 0 ; mediaix < mediacnt ; mediaix++ ) {
-				media_t *mediap = mediapp[ mediaix ];
+			for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+				media_t *mediap = mediapp[mediaix];
 				mediap->m_strategyp = *spp;
 				mediap->m_writehdrp->mh_strategyid = id;
 			}
-			if ( ( * (*spp)->ms_match )( argc, argv, dsp )) {
+			if ((* (*spp)->ms_match)(argc, argv, dsp)) {
 				chosen_sp = *spp;
 			}
 		}
 	}
-	if ( ! chosen_sp ) {
-		mlog( MLOG_NORMAL,
+	if (! chosen_sp) {
+		mlog(MLOG_NORMAL,
 #ifdef DUMP
 		      _("no media strategy available for selected "
 		      "dump destination(s)\n")
@@ -185,14 +185,14 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 		      "restore source(s)\n")
 #endif /* RESTORE */
 			);
-		usage( );
+		usage();
 		return 0;
 	}
 
 	/* give the media_t array to the chosen strategy
 	 */
-	for ( mediaix = 0 ; mediaix < mediacnt ; mediaix++ ) {
-		media_t *mediap = mediapp[ mediaix ];
+	for (mediaix = 0 ; mediaix < mediacnt ; mediaix++) {
+		media_t *mediap = mediapp[mediaix];
 		mediap->m_strategyp = chosen_sp;
 		mediap->m_writehdrp->mh_strategyid = chosen_sp->ms_id;
 	}
@@ -200,8 +200,8 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 	/* initialize the strategy. this will cause each of the managers
 	 * to be initialized as well. if error, return 0.
 	 */
-	ok = ( * chosen_sp->ms_create )( chosen_sp, argc, argv );
-	if ( ! ok ) {
+	ok = (* chosen_sp->ms_create)(chosen_sp, argc, argv);
+	if (! ok) {
 		return 0;
 	}
 
@@ -211,40 +211,40 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
 }
 
 bool_t
-media_init( media_strategy_t *msp, int argc, char *argv[] )
+media_init(media_strategy_t *msp, int argc, char *argv[])
 {
 	bool_t ok;
 
-	ok = ( * msp->ms_init )( msp, argc, argv );
+	ok = (* msp->ms_init)(msp, argc, argv);
 
 	return ok;
 }
 
 void
-media_complete( media_strategy_t *msp )
+media_complete(media_strategy_t *msp)
 {
-	( * msp->ms_complete )( msp );
+	(* msp->ms_complete)(msp);
 }
 
 /* media_get_upper_hdrs - supply pointers to portion of media file headers
  * set aside for upper software layers, as well as to the global hdrs
  */
 void
-media_get_upper_hdrs( media_t *mediap,
+media_get_upper_hdrs(media_t *mediap,
 		      global_hdr_t **grhdrpp,
 		      char **rhdrpp,
 		      size_t *rhdrszp,
 		      global_hdr_t **gwhdrpp,
 		      char **whdrpp,
-		      size_t *whdrszp )
+		      size_t *whdrszp)
 {
 	*grhdrpp = mediap->m_greadhdrp;
 	*rhdrpp = mediap->m_readhdrp->mh_upper;
-	*rhdrszp = sizeof( mediap->m_readhdrp->mh_upper );
+	*rhdrszp = sizeof(mediap->m_readhdrp->mh_upper);
 
 	*gwhdrpp = mediap->m_gwritehdrp;
 	*whdrpp = mediap->m_writehdrp->mh_upper;
-	*whdrszp = sizeof( mediap->m_writehdrp->mh_upper );
+	*whdrszp = sizeof(mediap->m_writehdrp->mh_upper);
 }
 
 
@@ -254,8 +254,8 @@ media_get_upper_hdrs( media_t *mediap,
  * descriptor and read and write media headers
  */
 static media_t *
-media_alloc( drive_t *drivep,
-	     char *medialabel )
+media_alloc(drive_t *drivep,
+	     char *medialabel)
 {
 	media_t *mediap;
 	global_hdr_t *grhdrp;
@@ -265,26 +265,26 @@ media_alloc( drive_t *drivep,
 	size_t mrhdrsz;
 	size_t mwhdrsz;
 
-	mediap = ( media_t * )calloc( 1, sizeof( media_t ));
-	assert( mediap );
+	mediap = (media_t *)calloc(1, sizeof(media_t));
+	assert(mediap);
 
 	grhdrp = 0;
 	gwhdrp = 0;
 	mrhdrp = 0;
 	mwhdrp = 0;
-	drive_get_upper_hdrs( drivep,
+	drive_get_upper_hdrs(drivep,
 			      &grhdrp,
-			      ( char ** )&mrhdrp,
+			      (char **)&mrhdrp,
 			      &mrhdrsz,
 			      &gwhdrp,
-			      ( char ** )&mwhdrp,
-			      &mwhdrsz );
-	assert( grhdrp );
-	assert( gwhdrp );
-	assert( mrhdrp );
-	assert( mwhdrp );
-	assert( mrhdrsz == MEDIA_HDR_SZ );
-	assert( mwhdrsz == MEDIA_HDR_SZ );
+			      (char **)&mwhdrp,
+			      &mwhdrsz);
+	assert(grhdrp);
+	assert(gwhdrp);
+	assert(mrhdrp);
+	assert(mwhdrp);
+	assert(mrhdrsz == MEDIA_HDR_SZ);
+	assert(mwhdrsz == MEDIA_HDR_SZ);
 
 	mediap->m_greadhdrp = grhdrp;
 	mediap->m_gwritehdrp = gwhdrp;
@@ -292,14 +292,14 @@ media_alloc( drive_t *drivep,
 	mediap->m_writehdrp = mwhdrp;
 	mediap->m_drivep = drivep;
 
-	strncpyterm( mwhdrp->mh_medialabel,
+	strncpyterm(mwhdrp->mh_medialabel,
 		     medialabel,
-		     sizeof( mwhdrp->mh_medialabel ));
+		     sizeof(mwhdrp->mh_medialabel));
 
 #ifdef DUMP
-	uuid_create( mwhdrp->mh_mediaid );
+	uuid_create(mwhdrp->mh_mediaid);
 #else /* DUMP */
-	uuid_clear( mwhdrp->mh_mediaid );
+	uuid_clear(mwhdrp->mh_mediaid);
 #endif /* DUMP */
 
 	return mediap;
diff --git a/common/media.h b/common/media.h
index 0b727e5..64e39ca 100644
--- a/common/media.h
+++ b/common/media.h
@@ -31,20 +31,20 @@
  * argument of the mo_begin_write() operator will be stuffed into the
  * upper layer info, and extracted for the upper layer by mo_begin_read().
  */
-#define MEDIA_HDR_SZ		sizeofmember( drive_hdr_t, dh_upper )
+#define MEDIA_HDR_SZ		sizeofmember(drive_hdr_t, dh_upper)
 
 struct media_hdr {
-	char mh_medialabel[ GLOBAL_HDR_STRING_SZ ];	/* 100  100 */
+	char mh_medialabel[GLOBAL_HDR_STRING_SZ];	/* 100  100 */
 		/* label of media object containing file */
-	char mh_prevmedialabel[ GLOBAL_HDR_STRING_SZ ];	/* 100  200 */
+	char mh_prevmedialabel[GLOBAL_HDR_STRING_SZ];	/* 100  200 */
 		/* label of upstream media object */
-	char mh_pad1[ GLOBAL_HDR_STRING_SZ ];		/* 100  300 */
+	char mh_pad1[GLOBAL_HDR_STRING_SZ];		/* 100  300 */
 		/* in case more labels needed */
 	uuid_t mh_mediaid;				/*  10  310 */
 		/* ID of media object 	*/
 	uuid_t mh_prevmediaid;				/*  10  320 */
 		/* ID of upstream media object */
-	char mh_pad2[ GLOBAL_HDR_UUID_SZ ];		/*  10  330 */
+	char mh_pad2[GLOBAL_HDR_UUID_SZ];		/*  10  330 */
 		/* in case more IDs needed */
 	uint32_t mh_mediaix;				/*   4  334 */
 		/* 0-based index of this media object within the dump stream */
@@ -58,11 +58,11 @@ struct media_hdr {
 		/* 0-based index of this dump within the media object */
 	int32_t mh_strategyid;				/*   4  348 */
 		/* ID of the media strategy used to produce this dump */
-	char mh_pad3[ 0x38 ];				/*  38  380 */
+	char mh_pad3[0x38];				/*  38  380 */
 		/* padding */
-	char mh_specific[ 0x80 ];			/*  80  400 */
+	char mh_specific[0x80];			/*  80  400 */
 		/* media strategy-specific info */
-	char mh_upper[ MEDIA_HDR_SZ - 0x400 ];		/* 400  800 */
+	char mh_upper[MEDIA_HDR_SZ - 0x400];		/* 400  800 */
 		/* header info private to upper software layers */
 };
 
@@ -71,8 +71,8 @@ typedef struct media_hdr media_hdr_t;
 /* macros to mark a media file as a terminator. artifact of original
  * media_rmvtape media strategy
  */
-#define MEDIA_TERMINATOR_CHK( mrhp )	( mrhp->mh_specific[ 0 ] & 1 )
-#define MEDIA_TERMINATOR_SET( mwhp )	( mwhp->mh_specific[ 0 ] |= 1 )
+#define MEDIA_TERMINATOR_CHK(mrhp)	(mrhp->mh_specific[0] & 1)
+#define MEDIA_TERMINATOR_SET(mwhp)	(mwhp->mh_specific[0] |= 1)
 
 /* media strategy IDs. artifactis of first version of xfsdump
  */
diff --git a/common/media_rmvtape.h b/common/media_rmvtape.h
index 61e80e1..4116a14 100644
--- a/common/media_rmvtape.h
+++ b/common/media_rmvtape.h
@@ -53,8 +53,8 @@ typedef struct media_context media_context_t;
 #define TERM_IS_SET(rmv_hdrp)	(rmv_hdrp->mrmv_flags & RMVMEDIA_TERMINATOR_BLOCK)
 
 
-#define CAN_OVERWRITE( drivep )	(drivep->d_capabilities & DRIVE_CAP_OVERWRITE)
-#define CAN_APPEND( drivep )	(drivep->d_capabilities & DRIVE_CAP_APPEND)
-#define CAN_BSF( drivep )	(drivep->d_capabilities & DRIVE_CAP_BSF)
+#define CAN_OVERWRITE(drivep)	(drivep->d_capabilities & DRIVE_CAP_OVERWRITE)
+#define CAN_APPEND(drivep)	(drivep->d_capabilities & DRIVE_CAP_APPEND)
+#define CAN_BSF(drivep)	(drivep->d_capabilities & DRIVE_CAP_BSF)
 
 #endif
-- 
2.19.1
