Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfANR0O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:14 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E804E7518D
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:13 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 12/13] xfsdump: (12/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:27 +0100
Message-Id: <20190114172528.65250-13-jtulak@redhat.com>
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
 restore/dirattr.c | 682 +++++++++++++++++++++++-----------------------
 restore/dirattr.h |  46 ++--
 restore/getopt.h  |   2 +-
 restore/inomap.c  | 288 ++++++++++----------
 restore/inomap.h  |  34 +--
 restore/mmap.c    |   2 +-
 restore/namreg.c  | 234 ++++++++--------
 restore/namreg.h  |  12 +-
 restore/node.c    | 328 +++++++++++-----------
 restore/node.h    |  12 +-
 10 files changed, 820 insertions(+), 820 deletions(-)

diff --git a/restore/dirattr.c b/restore/dirattr.c
index f057b78..5368664 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -66,22 +66,22 @@
  * with a handle checksum.
  */
 #define HDLSUMCNT		4
-#define	HDLSUMSHIFT		( NBBY * sizeof ( dah_t ) - HDLSUMCNT )
-#define	HDLSUMLOMASK		( ( 1 << HDLSUMCNT ) - 1 )
-#define	HDLSUMMASK		( HDLSUMLOMASK << HDLSUMSHIFT )
+#define	HDLSUMSHIFT		(NBBY * sizeof (dah_t) - HDLSUMCNT)
+#define	HDLSUMLOMASK		((1 << HDLSUMCNT) - 1)
+#define	HDLSUMMASK		(HDLSUMLOMASK << HDLSUMSHIFT)
 #define HDLDIXCNT		HDLSUMSHIFT
-#define HDLDIXMASK		( ( 1 << HDLDIXCNT ) - 1 )
-#define HDLGETSUM( h )		( ( uint16_t )				\
-				  ( ( ( int )h >> HDLSUMSHIFT )		\
+#define HDLDIXMASK		((1 << HDLDIXCNT) - 1)
+#define HDLGETSUM(h)		((uint16_t)				\
+				  (((int)h >> HDLSUMSHIFT)		\
 				    &					\
-				    HDLSUMLOMASK ))
-#define HDLGETDIX( h )		( ( dix_t )( ( int )h & HDLDIXMASK ))
-#define HDLMKHDL( s, d )	( ( dah_t )( ( ( ( int )s << HDLSUMSHIFT )\
+				    HDLSUMLOMASK))
+#define HDLGETDIX(h)		((dix_t)((int)h & HDLDIXMASK))
+#define HDLMKHDL(s, d)	((dah_t)((((int)s << HDLSUMSHIFT)\
 					       &			\
-					       HDLSUMMASK )		\
+					       HDLSUMMASK)		\
 					  |				\
-					  ( ( int )d & HDLDIXMASK )))
-#define DIX_MAX			( ( off64_t )HDLDIXMASK )
+					  ((int)d & HDLDIXMASK)))
+#define DIX_MAX			((off64_t)HDLDIXMASK)
 
 /* each dirattr will hold two check fields: a handle checksum, and unique
  * pattern, to differentiate a valid dirattr from random file contents.
@@ -90,13 +90,13 @@
 
 #else /* DIRATTRCHK */
 
-#define DIX_MAX			( ( ( off64_t )1			\
+#define DIX_MAX			(((off64_t)1			\
 				    <<					\
-				    ( ( off64_t )NBBY			\
+				    ((off64_t)NBBY			\
 				      *					\
-				      ( off64_t )sizeof( dah_t )))	\
+				      (off64_t)sizeof(dah_t)))	\
 				  -					\
-				  ( off64_t )2 ) /* 2 to avoid DAH_NULL */
+				  (off64_t)2) /* 2 to avoid DAH_NULL */
 
 #endif /* DIRATTRCHK */
 
@@ -123,7 +123,7 @@ struct dirattr {
 
 typedef struct dirattr dirattr_t;
 
-#define DIRATTR_EXTATTROFFNULL	( ( off64_t )OFF64MAX )
+#define DIRATTR_EXTATTROFFNULL	((off64_t)OFF64MAX)
 
 /* dirattr persistent context definition
  */
@@ -164,12 +164,12 @@ typedef struct dirattr_tran dirattr_tran_t;
  * in the lseek64 system call.
  */
 typedef off64_t dix_t;
-#define DIX2OFF( dix )	( ( off64_t )( dix * ( off64_t )sizeof( dirattr_t )   \
+#define DIX2OFF(dix)	((off64_t)(dix * (off64_t)sizeof(dirattr_t)   \
 				       +				      \
-				       ( off64_t )DIRATTR_PERS_SZ ))
-#define OFF2DIX( doff )	( ( dix_t )( ( doff - ( off64_t )DIRATTR_PERS_SZ )    \
+				       (off64_t)DIRATTR_PERS_SZ))
+#define OFF2DIX(doff)	((dix_t)((doff - (off64_t)DIRATTR_PERS_SZ)    \
 				     /					      \
-				     ( off64_t )sizeof( dirattr_t )))
+				     (off64_t)sizeof(dirattr_t)))
 
 
 /* declarations of externally defined global symbols *************************/
@@ -178,10 +178,10 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
-static void dirattr_get( dah_t );
-static void dirattr_cacheflush( void );
+static void dirattr_get(dah_t);
+static void dirattr_cacheflush(void);
 #ifdef DIRATTRCHK
-static uint16_t calcdixcum( dix_t dix );
+static uint16_t calcdixcum(dix_t dix);
 #endif /* DIRATTRCHK */
 
 
@@ -199,58 +199,58 @@ static dirattr_pers_t *dpp = 0;
 /* definition of locally defined global functions ****************************/
 
 bool_t
-dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
+dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 {
-	if ( dtp ) {
+	if (dtp) {
 		return BOOL_TRUE;
 	}
 
 	/* sanity checks
 	 */
-	assert( sizeof( dirattr_pers_t ) <= DIRATTR_PERS_SZ );
-	assert( ! dtp );
-	assert( ! dpp );
+	assert(sizeof(dirattr_pers_t) <= DIRATTR_PERS_SZ);
+	assert(! dtp);
+	assert(! dpp);
 
 	/* allocate and initialize context
 	 */
-	dtp = ( dirattr_tran_t * )calloc( 1, sizeof( dirattr_tran_t ));
-	assert( dtp );
+	dtp = (dirattr_tran_t *)calloc(1, sizeof(dirattr_tran_t));
+	assert(dtp);
 	dtp->dt_cachedh = DAH_NULL;
 	dtp->dt_fd = -1;
 	dtp->dt_extattrfd = -1;
 
 	/* generate a string containing the pathname of the dirattr file
 	 */
-	dtp->dt_pathname = open_pathalloc( hkdir, dirattrfile, 0 );
+	dtp->dt_pathname = open_pathalloc(hkdir, dirattrfile, 0);
 
 	/* open the dirattr file
 	 */
-	if ( resume ) {
+	if (resume) {
 		/* open existing file
 		 */
-		dtp->dt_fd = open( dtp->dt_pathname, O_RDWR );
-		if ( dtp->dt_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		dtp->dt_fd = open(dtp->dt_pathname, O_RDWR);
+		if (dtp->dt_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not find directory attributes file %s: "
 			      "%s\n"),
 			      dtp->dt_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 	} else {
 		/* create the dirattr file, first unlinking any older version
 		 * laying around
 		 */
-		( void )unlink( dtp->dt_pathname );
-		dtp->dt_fd = open( dtp->dt_pathname,
+		(void)unlink(dtp->dt_pathname);
+		dtp->dt_fd = open(dtp->dt_pathname,
 				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR );
-		if ( dtp->dt_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				   S_IRUSR | S_IWUSR);
+		if (dtp->dt_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create directory attributes file %s: "
 			      "%s\n"),
 			      dtp->dt_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 
@@ -264,7 +264,7 @@ dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 		int loglevel;
 		size_t trycnt;
 
-		for ( trycnt = 0,
+		for (trycnt = 0,
 		      successpr = BOOL_FALSE,
 		      ioctlcmd = XFS_IOC_RESVSP64,
 		      loglevel = MLOG_VERBOSE
@@ -273,25 +273,25 @@ dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 		      ;
 		      trycnt++,
 		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max( MLOG_NORMAL, loglevel - 1 )) {
+		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
 			off64_t initsz;
 			struct flock64 flock64;
 			int rval;
 
-			if ( ! ioctlcmd ) {
+			if (! ioctlcmd) {
 				continue;
 			}
 
-			initsz = ( off64_t )DIRATTR_PERS_SZ
+			initsz = (off64_t)DIRATTR_PERS_SZ
 				 +
-				 ( ( off64_t )dircnt * sizeof( dirattr_t ));
+				 ((off64_t)dircnt * sizeof(dirattr_t));
 			flock64.l_whence = 0;
 			flock64.l_start = 0;
 			flock64.l_len = initsz;
-			rval = ioctl( dtp->dt_fd, ioctlcmd, &flock64 );
-			if ( rval ) {
-				if ( errno != ENOTTY ) {
-					mlog( loglevel | MLOG_NOTE, _(
+			rval = ioctl(dtp->dt_fd, ioctlcmd, &flock64);
+			if (rval) {
+				if (errno != ENOTTY) {
+					mlog(loglevel | MLOG_NOTE, _(
 					      "attempt to reserve %lld bytes for %s "
 					      "using %s "
 					      "failed: %s (%d)\n"),
@@ -302,8 +302,8 @@ dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 					      "XFS_IOC_RESVSP64"
 					      :
 					      "XFS_IOC_ALLOCSP64",
-					      strerror( errno ),
-					      errno );
+					      strerror(errno),
+					      errno);
 				}
 			} else {
 				successpr = BOOL_TRUE;
@@ -314,23 +314,23 @@ dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 
 	/* mmap the persistent descriptor
 	 */
-	assert( ! ( DIRATTR_PERS_SZ % pgsz ));
-	dpp = ( dirattr_pers_t * )mmap_autogrow( DIRATTR_PERS_SZ,
+	assert(! (DIRATTR_PERS_SZ % pgsz));
+	dpp = (dirattr_pers_t *)mmap_autogrow(DIRATTR_PERS_SZ,
 				        dtp->dt_fd,
-				        ( off_t )0 );
-	assert( dpp );
-	if ( dpp == ( dirattr_pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				        (off_t)0);
+	assert(dpp);
+	if (dpp == (dirattr_pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map %s: %s\n"),
 		      dtp->dt_pathname,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* initialize persistent state
 	 */
-	if ( ! resume ) {
-		dpp->dp_appendoff = ( off64_t )DIRATTR_PERS_SZ;
+	if (! resume) {
+		dpp->dp_appendoff = (off64_t)DIRATTR_PERS_SZ;
 	}
 
 	/* initialize transient state
@@ -340,53 +340,53 @@ dirattr_init( char *hkdir, bool_t resume, uint64_t dircnt )
 	/* calculate the dir extattr pathname, and set the fd to -1.
 	 * file will be created on demand.
 	 */
-	dtp->dt_extattrpathname = open_pathalloc( hkdir, dirextattrfile, 0 );
+	dtp->dt_extattrpathname = open_pathalloc(hkdir, dirextattrfile, 0);
 	dtp->dt_extattrfd = -1;
 	dtp->dt_extattrfdbadpr = BOOL_FALSE;
-	if ( resume ) {
-		( void )unlink( dtp->dt_extattrpathname );
+	if (resume) {
+		(void)unlink(dtp->dt_extattrpathname);
 	}
 
 	return BOOL_TRUE;
 }
 
 void
-dirattr_cleanup( void )
+dirattr_cleanup(void)
 {
 	/* REFERENCED */
 	int rval;
 
-	if ( ! dtp ) {
+	if (! dtp) {
 		return;
 	}
-	if ( dpp ) {
-		rval = munmap( ( void * )dpp, DIRATTR_PERS_SZ );
-		assert( ! rval );
+	if (dpp) {
+		rval = munmap((void *)dpp, DIRATTR_PERS_SZ);
+		assert(! rval);
 		dpp = 0;
 	}
-	if ( dtp->dt_fd >= 0 ) {
-		( void )close( dtp->dt_fd );
+	if (dtp->dt_fd >= 0) {
+		(void)close(dtp->dt_fd);
 		dtp->dt_fd = -1;
 	}
-	if ( dtp->dt_pathname ) {
-		( void )unlink( dtp->dt_pathname );
-		free( ( void * )dtp->dt_pathname );
+	if (dtp->dt_pathname) {
+		(void)unlink(dtp->dt_pathname);
+		free((void *)dtp->dt_pathname);
 	}
-	if ( dtp->dt_extattrfd >= 0 ) {
-		( void )close( dtp->dt_extattrfd );
+	if (dtp->dt_extattrfd >= 0) {
+		(void)close(dtp->dt_extattrfd);
 		dtp->dt_extattrfd = -1;
 	}
-	if ( dtp->dt_extattrpathname ) {
-		( void )unlink( dtp->dt_extattrpathname );
-		free( ( void * )dtp->dt_extattrpathname );
+	if (dtp->dt_extattrpathname) {
+		(void)unlink(dtp->dt_extattrpathname);
+		free((void *)dtp->dt_extattrpathname);
 	}
 
-	free( ( void * )dtp );
+	free((void *)dtp);
 	dtp = 0;
 }
 
 dah_t
-dirattr_add( filehdr_t *fhdrp )
+dirattr_add(filehdr_t *fhdrp)
 {
 	dirattr_t dirattr;
 	off64_t oldoff;
@@ -398,21 +398,21 @@ dirattr_add( filehdr_t *fhdrp )
 
 	/* sanity checks
 	 */
-	assert( dtp );
-	assert( dpp );
+	assert(dtp);
+	assert(dpp);
 
 	/* make sure file pointer is positioned to write at end of file
 	 */
-	if ( ! dtp->dt_at_endpr ) {
+	if (! dtp->dt_at_endpr) {
 		off64_t newoff;
-		newoff = lseek64( dtp->dt_fd, dpp->dp_appendoff, SEEK_SET );
-		if ( newoff == ( off64_t )-1 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		newoff = lseek64(dtp->dt_fd, dpp->dp_appendoff, SEEK_SET);
+		if (newoff == (off64_t)-1) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "lseek of dirattr failed: %s\n"),
-			      strerror( errno ));
+			      strerror(errno));
 			return DAH_NULL;
 		}
-		assert( dpp->dp_appendoff == newoff );
+		assert(dpp->dp_appendoff == newoff);
 		dtp->dt_at_endpr = BOOL_TRUE;
 	}
 
@@ -425,25 +425,25 @@ dirattr_add( filehdr_t *fhdrp )
 	/* calculate the index of this dirattr
 	 */
 	oldoff = dpp->dp_appendoff;
-	dix = OFF2DIX( oldoff );
-	assert( dix <= DIX_MAX );
+	dix = OFF2DIX(oldoff);
+	assert(dix <= DIX_MAX);
 
 	/* populate a dirattr
 	 */
-	dirattr.d_mode = ( mode_t )fhdrp->fh_stat.bs_mode;
-	dirattr.d_uid = ( uid_t )fhdrp->fh_stat.bs_uid;
-	dirattr.d_gid = ( gid_t )fhdrp->fh_stat.bs_gid;
-	dirattr.d_atime = ( time32_t )fhdrp->fh_stat.bs_atime.tv_sec;
-	dirattr.d_mtime = ( time32_t )fhdrp->fh_stat.bs_mtime.tv_sec;
-	dirattr.d_ctime = ( time32_t )fhdrp->fh_stat.bs_ctime.tv_sec;
+	dirattr.d_mode = (mode_t)fhdrp->fh_stat.bs_mode;
+	dirattr.d_uid = (uid_t)fhdrp->fh_stat.bs_uid;
+	dirattr.d_gid = (gid_t)fhdrp->fh_stat.bs_gid;
+	dirattr.d_atime = (time32_t)fhdrp->fh_stat.bs_atime.tv_sec;
+	dirattr.d_mtime = (time32_t)fhdrp->fh_stat.bs_mtime.tv_sec;
+	dirattr.d_ctime = (time32_t)fhdrp->fh_stat.bs_ctime.tv_sec;
 	dirattr.d_xflags = fhdrp->fh_stat.bs_xflags;
-	dirattr.d_extsize = ( uint32_t )fhdrp->fh_stat.bs_extsize;
+	dirattr.d_extsize = (uint32_t)fhdrp->fh_stat.bs_extsize;
 	dirattr.d_projid = bstat_projid(&(fhdrp->fh_stat));
 	dirattr.d_dmevmask = fhdrp->fh_stat.bs_dmevmask;
-	dirattr.d_dmstate = ( uint32_t )fhdrp->fh_stat.bs_dmstate;
+	dirattr.d_dmstate = (uint32_t)fhdrp->fh_stat.bs_dmstate;
 #ifdef DIRATTRCHK
 	dirattr.d_unq = DIRATTRUNQ;
-	sum = calcdixcum( dix );
+	sum = calcdixcum(dix);
 	dirattr.d_sum = sum;
 #endif /* DIRATTRCHK */
 	dirattr.d_extattroff = DIRATTR_EXTATTROFFNULL;
@@ -455,20 +455,20 @@ dirattr_add( filehdr_t *fhdrp )
 
 	/* update the next write offset
 	 */
-	assert( dpp->dp_appendoff <= OFF64MAX - ( off64_t )sizeof(dirattr_t) );
-	dpp->dp_appendoff += ( off64_t )sizeof(dirattr_t);
+	assert(dpp->dp_appendoff <= OFF64MAX - (off64_t)sizeof(dirattr_t));
+	dpp->dp_appendoff += (off64_t)sizeof(dirattr_t);
 
 #ifdef DIRATTRCHK
-	dah = HDLMKHDL( sum, dix );
+	dah = HDLMKHDL(sum, dix);
 #else /* DIRATTRCHK */
-	dah = ( dah_t )dix;
+	dah = (dah_t)dix;
 #endif /* DIRATTRCHK */
 
 	return dah;
 }
 
 void
-dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
+dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp)
 {
 	off64_t oldoff;
 	off64_t off;
@@ -479,25 +479,25 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 
 	/* pull the selected dir attributes into the cache
 	 */
-	dirattr_get( dah );
+	dirattr_get(dah);
 
 	/* open/create extended attributes file if not yet done
 	 */
-	if ( dtp->dt_extattrfd < 0 ) {
-		if ( dtp->dt_extattrfdbadpr ) {
+	if (dtp->dt_extattrfd < 0) {
+		if (dtp->dt_extattrfdbadpr) {
 			return;
 		}
-		dtp->dt_extattrfd = open( dtp->dt_extattrpathname,
+		dtp->dt_extattrfd = open(dtp->dt_extattrpathname,
 					  O_RDWR | O_CREAT,
-					  S_IRUSR | S_IWUSR );
-		if ( dtp->dt_extattrfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					  S_IRUSR | S_IWUSR);
+		if (dtp->dt_extattrfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not open/create directory "
 			      "extended attributes file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return;
 		}
@@ -507,34 +507,34 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 	 */
 	off = dtp->dt_cached_dirattr.d_extattroff;
 	oldoff = DIRATTR_EXTATTROFFNULL;
-	while ( off != DIRATTR_EXTATTROFFNULL ) {
-		seekoff = lseek64( dtp->dt_extattrfd, off, SEEK_SET );
-		if ( seekoff < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	while (off != DIRATTR_EXTATTROFFNULL) {
+		seekoff = lseek64(dtp->dt_extattrfd, off, SEEK_SET);
+		if (seekoff < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not seek to into extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return;
 		}
-		assert( seekoff == off );
+		assert(seekoff == off);
 
 		oldoff = off;
 
-		nread = read( dtp->dt_extattrfd,
-			      ( void * )&off,
-			      sizeof( off ));
-		if ( nread != ( int )sizeof( off )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		nread = read(dtp->dt_extattrfd,
+			      (void *)&off,
+			      sizeof(off));
+		if (nread != (int)sizeof(off)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return;
 		}
@@ -542,42 +542,42 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 
 	/* append the extended attributes
 	 */
-	off = lseek64( dtp->dt_extattrfd, 0, SEEK_END );
-	if ( off < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	off = lseek64(dtp->dt_extattrfd, 0, SEEK_END);
+	if (off < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not seek to end of extended attributes "
 		      "file %s: "
 		      "%s (%d)\n"),
 		      dtp->dt_extattrpathname,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		dtp->dt_extattrfdbadpr = BOOL_TRUE;
 		return;
 	}
 	nulloff = DIRATTR_EXTATTROFFNULL;
-	nwritten = write( dtp->dt_extattrfd,
-			  ( void * )&nulloff,
-			  sizeof( nulloff ));
-	if ( nwritten != ( int )sizeof( nulloff )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	nwritten = write(dtp->dt_extattrfd,
+			  (void *)&nulloff,
+			  sizeof(nulloff));
+	if (nwritten != (int)sizeof(nulloff)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not write extended attributes "
 		      "file %s: "
 		      "%s (%d)\n"),
 		      dtp->dt_extattrpathname,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		dtp->dt_extattrfdbadpr = BOOL_TRUE;
 		return;
 	}
-	nwritten = write( dtp->dt_extattrfd, ( void * )ahdrp, ahdrp->ah_sz );
-	if ( nwritten != ( int )( ahdrp->ah_sz )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	nwritten = write(dtp->dt_extattrfd, (void *)ahdrp, ahdrp->ah_sz);
+	if (nwritten != (int)(ahdrp->ah_sz)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not write at end of extended attributes "
 		      "file %s: "
 		      "%s (%d)\n"),
 		      dtp->dt_extattrpathname,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 		dtp->dt_extattrfdbadpr = BOOL_TRUE;
 		return;
 	}
@@ -585,34 +585,34 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 	/* fill in the offset of the extended attributes into the
 	 * linked list
 	 */
-	if ( oldoff == DIRATTR_EXTATTROFFNULL ) {
+	if (oldoff == DIRATTR_EXTATTROFFNULL) {
 		dtp->dt_cached_dirattr.d_extattroff = off;
-		dirattr_cacheflush( );
+		dirattr_cacheflush();
 	} else {
-		seekoff = lseek64( dtp->dt_extattrfd, oldoff, SEEK_SET );
-		if ( seekoff < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		seekoff = lseek64(dtp->dt_extattrfd, oldoff, SEEK_SET);
+		if (seekoff < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not seek to into extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return;
 		}
-		assert( seekoff == oldoff );
-		nwritten = write( dtp->dt_extattrfd,
-				  ( void * )&off,
-				  sizeof( off ));
-		if ( nwritten != ( int )sizeof( off )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		assert(seekoff == oldoff);
+		nwritten = write(dtp->dt_extattrfd,
+				  (void *)&off,
+				  sizeof(off));
+		if (nwritten != (int)sizeof(off)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not write extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return;
 		}
@@ -620,35 +620,35 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
 }
 
 bool_t
-dirattr_cb_extattr( dah_t dah,
-		    bool_t ( * cbfunc )( extattrhdr_t *ahdrp,
-				         void *ctxp ),
+dirattr_cb_extattr(dah_t dah,
+		    bool_t (* cbfunc)(extattrhdr_t *ahdrp,
+				         void *ctxp),
 		    extattrhdr_t *ahdrp,
-		    void *ctxp )
+		    void *ctxp)
 {
 	off64_t off;
 
 	/* pull the selected dir attributes into the cache
 	 */
-	dirattr_get( dah );
+	dirattr_get(dah);
 
 	/* open/create extended attributes file if not yet done
 	 */
-	if ( dtp->dt_extattrfd < 0 ) {
-		if ( dtp->dt_extattrfdbadpr ) {
+	if (dtp->dt_extattrfd < 0) {
+		if (dtp->dt_extattrfdbadpr) {
 			return BOOL_TRUE;
 		}
-		dtp->dt_extattrfd = open( dtp->dt_extattrpathname,
+		dtp->dt_extattrfd = open(dtp->dt_extattrpathname,
 					  O_RDWR | O_CREAT,
-					  S_IRUSR | S_IWUSR );
-		if ( dtp->dt_extattrfd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					  S_IRUSR | S_IWUSR);
+		if (dtp->dt_extattrfd < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not open/create directory "
 			      "extended attributes file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return BOOL_TRUE;
 		}
@@ -657,7 +657,7 @@ dirattr_cb_extattr( dah_t dah,
 	/* walk through the dirattr list for this dah
 	 */
 	off = dtp->dt_cached_dirattr.d_extattroff;
-	while ( off != DIRATTR_EXTATTROFFNULL ) {
+	while (off != DIRATTR_EXTATTROFFNULL) {
 		off64_t seekoff;
 		int nread;
 		off64_t nextoff;
@@ -666,77 +666,77 @@ dirattr_cb_extattr( dah_t dah,
 
 		/* seek to the extattr
 		 */
-		seekoff = lseek64( dtp->dt_extattrfd, off, SEEK_SET );
-		if ( seekoff < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		seekoff = lseek64(dtp->dt_extattrfd, off, SEEK_SET);
+		if (seekoff < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not seek to into extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return BOOL_TRUE;
 		}
-		assert( seekoff == off );
+		assert(seekoff == off);
 
 		/* peel off the next offset
 		 */
-		nread = read( dtp->dt_extattrfd,
-			      ( void * )&nextoff,
-			      sizeof( nextoff ));
-		if ( nread != ( int )sizeof( nextoff )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		nread = read(dtp->dt_extattrfd,
+			      (void *)&nextoff,
+			      sizeof(nextoff));
+		if (nread != (int)sizeof(nextoff)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return BOOL_TRUE;
 		}
 
 		/* read the extattr hdr
 		 */
-		nread = read( dtp->dt_extattrfd,
-			      ( void * )ahdrp,
-			      EXTATTRHDR_SZ );
-		if ( nread != EXTATTRHDR_SZ ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		nread = read(dtp->dt_extattrfd,
+			      (void *)ahdrp,
+			      EXTATTRHDR_SZ);
+		if (nread != EXTATTRHDR_SZ) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return BOOL_TRUE;
 		}
 
 		/* read the remainder of the extattr
 		 */
-		recsz = ( size_t )ahdrp->ah_sz;
-		assert( recsz >= EXTATTRHDR_SZ );
-		nread = read( dtp->dt_extattrfd,
-			      ( void * )&ahdrp[ 1 ],
-			      recsz - EXTATTRHDR_SZ );
-		if ( nread != ( int )( recsz - EXTATTRHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		recsz = (size_t)ahdrp->ah_sz;
+		assert(recsz >= EXTATTRHDR_SZ);
+		nread = read(dtp->dt_extattrfd,
+			      (void *)&ahdrp[1],
+			      recsz - EXTATTRHDR_SZ);
+		if (nread != (int)(recsz - EXTATTRHDR_SZ)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "could not read extended attributes "
 			      "file %s: "
 			      "%s (%d)\n"),
 			      dtp->dt_extattrpathname,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			dtp->dt_extattrfdbadpr = BOOL_TRUE;
 			return BOOL_TRUE;
 		}
 
 		/* call the callback func
 		 */
-		ok = ( * cbfunc )( ahdrp, ctxp );
-		if ( ! ok ) {
+		ok = (* cbfunc)(ahdrp, ctxp);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 
@@ -749,7 +749,7 @@ dirattr_cb_extattr( dah_t dah,
 }
 
 void
-dirattr_update( dah_t dah, filehdr_t *fhdrp )
+dirattr_update(dah_t dah, filehdr_t *fhdrp)
 {
 	dix_t dix;
 #ifdef DIRATTRCHK
@@ -762,73 +762,73 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
 
 	/* sanity checks
 	 */
-	assert( dtp );
-	assert( dpp );
+	assert(dtp);
+	assert(dpp);
 
-	assert( dah != DAH_NULL );
+	assert(dah != DAH_NULL);
 
 #ifdef DIRATTRCHK
-	sum = HDLGETSUM( dah );
-	dix = HDLGETDIX( dah );
+	sum = HDLGETSUM(dah);
+	dix = HDLGETDIX(dah);
 #else /* DIRATTRCHK */
-	dix = ( dix_t )dah;
+	dix = (dix_t)dah;
 #endif /* DIRATTRCHK */
 
-	assert( dix >= 0 );
-	assert( dix <= DIX_MAX );
+	assert(dix >= 0);
+	assert(dix <= DIX_MAX);
 
-	argoff = DIX2OFF( dix );
-	assert( argoff >= 0 );
-	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
-	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
+	argoff = DIX2OFF(dix);
+	assert(argoff >= 0);
+	assert(argoff >= (off64_t)DIRATTR_PERS_SZ);
+	assert(argoff <= dpp->dp_appendoff - (off64_t)sizeof(dirattr_t));
 
 #ifdef DIRATTRCHK
-	dirattr_get( dah );
-	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
-	assert( dtp->dt_cached_dirattr.d_sum == sum );
+	dirattr_get(dah);
+	assert(dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ);
+	assert(dtp->dt_cached_dirattr.d_sum == sum);
 #endif /* DIRATTRCHK */
 
-	if ( dtp->dt_at_endpr && dtp->dt_off ) {
+	if (dtp->dt_at_endpr && dtp->dt_off) {
 		if (dirattr_flush() != RV_OK) {
-			assert( 0 );
+			assert(0);
 			return;
 		}
 	}
 
 	/* seek to the dirattr
 	 */
-	newoff = lseek64( dtp->dt_fd, argoff, SEEK_SET );
-	if ( newoff == ( off64_t )-1 ) {
-		mlog( MLOG_NORMAL, _(
+	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
+	if (newoff == (off64_t)-1) {
+		mlog(MLOG_NORMAL, _(
 		      "lseek of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
-	assert( newoff == argoff );
+	assert(newoff == argoff);
 
 	/* populate a dirattr
 	 */
-	dirattr.d_mode = ( mode_t )fhdrp->fh_stat.bs_mode;
-	dirattr.d_uid = ( uid_t )fhdrp->fh_stat.bs_uid;
-	dirattr.d_gid = ( gid_t )fhdrp->fh_stat.bs_gid;
-	dirattr.d_atime = ( time32_t )fhdrp->fh_stat.bs_atime.tv_sec;
-	dirattr.d_mtime = ( time32_t )fhdrp->fh_stat.bs_mtime.tv_sec;
-	dirattr.d_ctime = ( time32_t )fhdrp->fh_stat.bs_ctime.tv_sec;
+	dirattr.d_mode = (mode_t)fhdrp->fh_stat.bs_mode;
+	dirattr.d_uid = (uid_t)fhdrp->fh_stat.bs_uid;
+	dirattr.d_gid = (gid_t)fhdrp->fh_stat.bs_gid;
+	dirattr.d_atime = (time32_t)fhdrp->fh_stat.bs_atime.tv_sec;
+	dirattr.d_mtime = (time32_t)fhdrp->fh_stat.bs_mtime.tv_sec;
+	dirattr.d_ctime = (time32_t)fhdrp->fh_stat.bs_ctime.tv_sec;
 	dirattr.d_xflags = fhdrp->fh_stat.bs_xflags;
-	dirattr.d_extsize = ( uint32_t )fhdrp->fh_stat.bs_extsize;
+	dirattr.d_extsize = (uint32_t)fhdrp->fh_stat.bs_extsize;
 	dirattr.d_projid = bstat_projid(&(fhdrp->fh_stat));
 	dirattr.d_dmevmask = fhdrp->fh_stat.bs_dmevmask;
-	dirattr.d_dmstate = ( uint32_t )fhdrp->fh_stat.bs_dmstate;
+	dirattr.d_dmstate = (uint32_t)fhdrp->fh_stat.bs_dmstate;
 	dirattr.d_extattroff = DIRATTR_EXTATTROFFNULL;
 
 	/* write the dirattr
 	 */
-	nwritten = write( dtp->dt_fd, ( void * )&dirattr, sizeof( dirattr ));
-	if ( ( size_t )nwritten != sizeof( dirattr )) {
-		mlog( MLOG_NORMAL, _(
+	nwritten = write(dtp->dt_fd, (void *)&dirattr, sizeof(dirattr));
+	if ((size_t)nwritten != sizeof(dirattr)) {
+		mlog(MLOG_NORMAL, _(
 		      "update of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
 
 	dtp->dt_at_endpr = BOOL_FALSE;
@@ -837,84 +837,84 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
 
 /* ARGSUSED */
 void
-dirattr_del( dah_t dah )
+dirattr_del(dah_t dah)
 {
 }
 
 mode_t
-dirattr_get_mode( dah_t dah )
+dirattr_get_mode(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_mode;
 }
 
 uid_t
-dirattr_get_uid( dah_t dah )
+dirattr_get_uid(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_uid;
 }
 
 uid_t
-dirattr_get_gid( dah_t dah )
+dirattr_get_gid(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_gid;
 }
 
 time32_t
-dirattr_get_atime( dah_t dah )
+dirattr_get_atime(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_atime;
 }
 
 time32_t
-dirattr_get_mtime( dah_t dah )
+dirattr_get_mtime(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_mtime;
 }
 
 time32_t
-dirattr_get_ctime( dah_t dah )
+dirattr_get_ctime(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_ctime;
 }
 
 uint32_t
-dirattr_get_xflags( dah_t dah )
+dirattr_get_xflags(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_xflags;
 }
 
 uint32_t
-dirattr_get_extsize( dah_t dah )
+dirattr_get_extsize(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_extsize;
 }
 
 uint32_t
-dirattr_get_projid( dah_t dah )
+dirattr_get_projid(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_projid;
 }
 
 uint32_t
-dirattr_get_dmevmask( dah_t dah )
+dirattr_get_dmevmask(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_dmevmask;
 }
 
 uint32_t
-dirattr_get_dmstate( dah_t dah )
+dirattr_get_dmstate(dah_t dah)
 {
-	dirattr_get( dah );
+	dirattr_get(dah);
 	return dtp->dt_cached_dirattr.d_dmstate;
 }
 
@@ -925,24 +925,24 @@ dirattr_flush()
 
 	/* sanity checks
 	*/
-	assert ( dtp );
+	assert (dtp);
 
 	if (dtp->dt_off) {
 		/* write the accumulated dirattr entries
 		*/
-		nwritten = write( dtp->dt_fd, ( void * )dtp->dt_buf, dtp->dt_off);
-		if ( nwritten != dtp->dt_off ) {
-			if ( nwritten < 0 ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+		nwritten = write(dtp->dt_fd, (void *)dtp->dt_buf, dtp->dt_off);
+		if (nwritten != dtp->dt_off) {
+			if (nwritten < 0) {
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 					_("write of dirattr buffer failed: %s\n"),
-					strerror( errno ));
+					strerror(errno));
 			} else {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 					_("write of dirattr buffer failed: "
 					"expected to write %ld, actually "
 					"wrote %ld\n"), dtp->dt_off, nwritten);
 			}
-			assert( 0 );
+			assert(0);
 			return RV_UNKNOWN;
 		}
 		dtp->dt_off = 0;
@@ -953,7 +953,7 @@ dirattr_flush()
 /* definition of locally defined static functions ****************************/
 
 static void
-dirattr_get( dah_t dah )
+dirattr_get(dah_t dah)
 {
 	dix_t dix;
 	off64_t argoff;
@@ -965,65 +965,65 @@ dirattr_get( dah_t dah )
 
 	/* sanity checks
 	 */
-	assert( dtp );
-	assert( dpp );
+	assert(dtp);
+	assert(dpp);
 
-	assert( dah != DAH_NULL );
+	assert(dah != DAH_NULL);
 
 	/* if we are already holding this dirattr in cache,
 	 * just return
 	 */
-	if ( dtp->dt_cachedh == dah ) {
+	if (dtp->dt_cachedh == dah) {
 		return;
 	}
 
 #ifdef DIRATTRCHK
-	sum = HDLGETSUM( dah );
-	dix = HDLGETDIX( dah );
+	sum = HDLGETSUM(dah);
+	dix = HDLGETDIX(dah);
 #else /* DIRATTRCHK */
-	dix = ( dix_t )dah;
+	dix = (dix_t)dah;
 #endif /* DIRATTRCHK */
-	assert( dix >= 0 );
-	assert( dix <= DIX_MAX );
+	assert(dix >= 0);
+	assert(dix <= DIX_MAX);
 
-	argoff = DIX2OFF( dix );
-	assert( argoff >= 0 );
-	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
-	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
+	argoff = DIX2OFF(dix);
+	assert(argoff >= 0);
+	assert(argoff >= (off64_t)DIRATTR_PERS_SZ);
+	assert(argoff <= dpp->dp_appendoff - (off64_t)sizeof(dirattr_t));
 
-	if ( dtp->dt_at_endpr && dtp->dt_off ) {
+	if (dtp->dt_at_endpr && dtp->dt_off) {
 		if (dirattr_flush() != RV_OK) {
-			assert( 0 );
+			assert(0);
 			return;
 		}
 	}
 
 	/* seek to the dirattr
 	 */
-	newoff = lseek64( dtp->dt_fd, argoff, SEEK_SET );
-	if ( newoff == ( off64_t )-1 ) {
-		mlog( MLOG_NORMAL, _(
+	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
+	if (newoff == (off64_t)-1) {
+		mlog(MLOG_NORMAL, _(
 		      "lseek of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
-	assert( newoff == argoff );
+	assert(newoff == argoff);
 
 	/* read the dirattr
 	 */
-	nread = read( dtp->dt_fd,
-		      ( void * )&dtp->dt_cached_dirattr,
-		      sizeof( dtp->dt_cached_dirattr ));
-	if ( ( size_t )nread != sizeof( dtp->dt_cached_dirattr )) {
-		mlog( MLOG_NORMAL, _(
+	nread = read(dtp->dt_fd,
+		      (void *)&dtp->dt_cached_dirattr,
+		      sizeof(dtp->dt_cached_dirattr));
+	if ((size_t)nread != sizeof(dtp->dt_cached_dirattr)) {
+		mlog(MLOG_NORMAL, _(
 		      "read of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
 
 #ifdef DIRATTRCHK
-	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
-	assert( dtp->dt_cached_dirattr.d_sum == sum );
+	assert(dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ);
+	assert(dtp->dt_cached_dirattr.d_sum == sum);
 #endif /* DIRATTRCHK */
 
 	dtp->dt_at_endpr = BOOL_FALSE;
@@ -1031,7 +1031,7 @@ dirattr_get( dah_t dah )
 }
 
 static void
-dirattr_cacheflush( void )
+dirattr_cacheflush(void)
 {
 	dah_t dah;
 	dix_t dix;
@@ -1044,58 +1044,58 @@ dirattr_cacheflush( void )
 
 	/* sanity checks
 	 */
-	assert( dtp );
-	assert( dpp );
+	assert(dtp);
+	assert(dpp);
 
 	/* if nothing in the cache, ignore
 	 */
 	dah = dtp->dt_cachedh;
-	assert( dah != DAH_NULL );
-	if ( dah == DAH_NULL ) {
+	assert(dah != DAH_NULL);
+	if (dah == DAH_NULL) {
 		return;
 	}
 
 #ifdef DIRATTRCHK
-	sum = HDLGETSUM( dah );
-	dix = HDLGETDIX( dah );
+	sum = HDLGETSUM(dah);
+	dix = HDLGETDIX(dah);
 #else /* DIRATTRCHK */
-	dix = ( dix_t )dah;
+	dix = (dix_t)dah;
 #endif /* DIRATTRCHK */
 
 #ifdef DIRATTRCHK
-	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
-	assert( dtp->dt_cached_dirattr.d_sum == sum );
+	assert(dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ);
+	assert(dtp->dt_cached_dirattr.d_sum == sum);
 #endif /* DIRATTRCHK */
 
-	assert( dix >= 0 );
-	assert( dix <= DIX_MAX );
+	assert(dix >= 0);
+	assert(dix <= DIX_MAX);
 
-	argoff = DIX2OFF( dix );
-	assert( argoff >= 0 );
-	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
-	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
+	argoff = DIX2OFF(dix);
+	assert(argoff >= 0);
+	assert(argoff >= (off64_t)DIRATTR_PERS_SZ);
+	assert(argoff <= dpp->dp_appendoff - (off64_t)sizeof(dirattr_t));
 
 	/* seek to the dirattr
 	 */
-	newoff = lseek64( dtp->dt_fd, argoff, SEEK_SET );
-	if ( newoff == ( off64_t )-1 ) {
-		mlog( MLOG_NORMAL, _(
+	newoff = lseek64(dtp->dt_fd, argoff, SEEK_SET);
+	if (newoff == (off64_t)-1) {
+		mlog(MLOG_NORMAL, _(
 		      "lseek of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
-	assert( newoff == argoff );
+	assert(newoff == argoff);
 
 	/* write the dirattr
 	 */
-	nwritten = write( dtp->dt_fd,
-			  ( void * )&dtp->dt_cached_dirattr,
-			  sizeof( dtp->dt_cached_dirattr ));
-	if ( ( size_t )nwritten != sizeof( dtp->dt_cached_dirattr )) {
-		mlog( MLOG_NORMAL, _(
+	nwritten = write(dtp->dt_fd,
+			  (void *)&dtp->dt_cached_dirattr,
+			  sizeof(dtp->dt_cached_dirattr));
+	if ((size_t)nwritten != sizeof(dtp->dt_cached_dirattr)) {
+		mlog(MLOG_NORMAL, _(
 		      "flush of dirattr failed: %s\n"),
-		      strerror( errno ));
-		assert( 0 );
+		      strerror(errno));
+		assert(0);
 	}
 
 	dtp->dt_at_endpr = BOOL_FALSE;
@@ -1104,21 +1104,21 @@ dirattr_cacheflush( void )
 #ifdef DIRATTRCHK
 
 static uint16_t
-calcdixcum( dix_t dix )
+calcdixcum(dix_t dix)
 {
 	uint16_t sum;
 	ix_t nibcnt;
 	ix_t nibix;
 
-	assert( ( sizeof( dah_t ) / HDLSUMCNT ) * HDLSUMCNT == sizeof( dah_t ));
+	assert((sizeof(dah_t) / HDLSUMCNT) * HDLSUMCNT == sizeof(dah_t));
 
-	nibcnt = ( sizeof( dah_t ) / HDLSUMCNT ) - 1;
+	nibcnt = (sizeof(dah_t) / HDLSUMCNT) - 1;
 	sum = 0;
-	for ( nibix = 0 ; nibix < nibcnt ; nibix++ ) {
-		sum += ( uint16_t )( dix & HDLSUMLOMASK );
+	for (nibix = 0 ; nibix < nibcnt ; nibix++) {
+		sum += (uint16_t)(dix & HDLSUMLOMASK);
 		dix >>= HDLSUMCNT;
 	}
-	sum = ( uint16_t )( ( ~sum + 1 ) & HDLSUMLOMASK );
+	sum = (uint16_t)((~sum + 1) & HDLSUMLOMASK);
 
 	return sum;
 }
diff --git a/restore/dirattr.h b/restore/dirattr.h
index aaf276d..dd37a98 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -31,61 +31,61 @@ typedef size32_t dah_t;
  * returns FALSE if an error encountered. if NOT resync,
  * dircnt hints at number of directories to expect.
  */
-extern bool_t dirattr_init( char *housekeepingdir,
+extern bool_t dirattr_init(char *housekeepingdir,
 			    bool_t resync,
-			    uint64_t dircnt );
+			    uint64_t dircnt);
 
 
 /* dirattr_cleanup - removes all traces
  */
-extern void dirattr_cleanup( void );
+extern void dirattr_cleanup(void);
 
 
 /* dirattr_add - registers a directory's attributes. knows how to interpret
  * the filehdr. returns handle for use with dirattr_get_...().
  */
-extern dah_t dirattr_add( filehdr_t *fhdrp );
+extern dah_t dirattr_add(filehdr_t *fhdrp);
 
 /* dirattr_update - modifies existing registered attributes
  */
-extern void dirattr_update( dah_t dah, filehdr_t *fhdrp );
+extern void dirattr_update(dah_t dah, filehdr_t *fhdrp);
 
 /* dirattr_del - frees dirattr no longer needed
  */
-extern void dirattr_del( dah_t dah );
+extern void dirattr_del(dah_t dah);
 
 /* dirattr_get_... - retrieve various attributes
  */
-mode_t dirattr_get_mode( dah_t dah );
-uid_t dirattr_get_uid( dah_t dah );
-gid_t dirattr_get_gid( dah_t dah );
-time32_t dirattr_get_atime( dah_t dah );
-time32_t dirattr_get_mtime( dah_t dah );
-time32_t dirattr_get_ctime( dah_t dah );
-uint32_t dirattr_get_xflags( dah_t dah );
-uint32_t dirattr_get_extsize( dah_t dah );
-uint32_t dirattr_get_projid( dah_t dah );
-uint32_t dirattr_get_dmevmask( dah_t dah );
-uint32_t dirattr_get_dmstate( dah_t dah );
+mode_t dirattr_get_mode(dah_t dah);
+uid_t dirattr_get_uid(dah_t dah);
+gid_t dirattr_get_gid(dah_t dah);
+time32_t dirattr_get_atime(dah_t dah);
+time32_t dirattr_get_mtime(dah_t dah);
+time32_t dirattr_get_ctime(dah_t dah);
+uint32_t dirattr_get_xflags(dah_t dah);
+uint32_t dirattr_get_extsize(dah_t dah);
+uint32_t dirattr_get_projid(dah_t dah);
+uint32_t dirattr_get_dmevmask(dah_t dah);
+uint32_t dirattr_get_dmstate(dah_t dah);
 
 /* dirattr_flush - flush dirattr I/O buffer.  Returns 0 if successful.
  */
-extern rv_t dirattr_flush( void );
+extern rv_t dirattr_flush(void);
 
 /* dirattr_addextattr - record an extended attribute. second argument is
  * ptr to extattrhdr_t, with extattr name and value appended as
  * described by hdr.
  */
-extern void dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp );
+extern void dirattr_addextattr(dah_t dah, extattrhdr_t *ahdrp);
 
 /* dirattr_cb_extattr - calls back for every extended attribute associated with
  * the given dah. stops iteration and returnd FALSE if cbfunc returns FALSE,
  * else returns TRUE.
  */
-extern bool_t dirattr_cb_extattr( dah_t dah,
-				  bool_t ( * cbfunc )( extattrhdr_t *ahdrp,
-						       void *ctxp ),
+extern bool_t dirattr_cb_extattr(dah_t dah,
+				  bool_t (* cbfunc)(extattrhdr_t *ahdrp,
+						       void *ctxp),
 				  extattrhdr_t *ahdrp,
-				  void *ctxp );
+				  void *ctxp);
 
 #endif /* DIRATTR_H */
diff --git a/restore/getopt.h b/restore/getopt.h
index 361bc61..b5bc004 100644
--- a/restore/getopt.h
+++ b/restore/getopt.h
@@ -49,7 +49,7 @@
 #define	GETOPT_SUBTREE		's'	/* subtree restore (content.c) */
 #define	GETOPT_TOC		't'	/* display contents only (content.c) */
 /*				'u' */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4 ) */
+#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 #define	GETOPT_SMALLWINDOW	'w'	/* use a small window for dir entries */
 /*				'x' */
 /*				'y' */
diff --git a/restore/inomap.c b/restore/inomap.c
index 5f81897..1b03779 100644
--- a/restore/inomap.c
+++ b/restore/inomap.c
@@ -77,9 +77,9 @@ extern size_t pgsz;
 
 /* inomap primitives
  */
-static int map_getset( xfs_ino_t, int, bool_t );
-static int map_set( xfs_ino_t ino, int );
-static seg_t * map_getsegment( xfs_ino_t ino );
+static int map_getset(xfs_ino_t, int, bool_t);
+static int map_set(xfs_ino_t ino, int);
+static seg_t * map_getsegment(xfs_ino_t ino);
 
 /* definition of locally defined global variables ****************************/
 
@@ -103,15 +103,15 @@ static xfs_ino_t last_ino_added;
  */
 
 static inline void
-SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
+SEG_SET_BITS(seg_t *segp, xfs_ino_t ino, int state)
 {
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	register uint64_t clrmask;
 	relino = ino - segp->base;
-	mask = ( uint64_t )1 << relino;
+	mask = (uint64_t)1 << relino;
 	clrmask = ~mask;
-	switch( state ) {
+	switch(state) {
 	case 0:
 		segp->lobits &= clrmask;
 		segp->mebits &= clrmask;
@@ -156,22 +156,22 @@ SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
 }
 
 static inline int
-SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
+SEG_GET_BITS(seg_t *segp, xfs_ino_t ino)
 {
 	int state;
 	register xfs_ino_t relino;
 	register uint64_t mask;
 	relino = ino - segp->base;
-	mask = ( uint64_t )1 << relino;
-	if ( segp->lobits & mask ) {
+	mask = (uint64_t)1 << relino;
+	if (segp->lobits & mask) {
 		state = 1;
 	} else {
 		state = 0;
 	}
-	if ( segp->mebits & mask ) {
+	if (segp->mebits & mask) {
 		state |= 2;
 	}
-	if ( segp->hibits & mask ) {
+	if (segp->hibits & mask) {
 		state |= 4;
 	}
 
@@ -181,9 +181,9 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 /* definition of locally defined global functions ****************************/
 
 rv_t
-inomap_restore_pers( drive_t *drivep,
+inomap_restore_pers(drive_t *drivep,
 		     content_inode_hdr_t *scrhdrp,
-		     char *hkdir )
+		     char *hkdir)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	char *perspath;
@@ -201,9 +201,9 @@ inomap_restore_pers( drive_t *drivep,
 
 	/* sanity checks
 	 */
-	assert( INOPERSEG == ( sizeof( (( seg_t * )0 )->lobits ) * NBBY ));
-	assert( sizeof( hnk_t ) == HNKSZ );
-	assert( sizeof( pers_t ) <= PERSSZ );
+	assert(INOPERSEG == (sizeof(((seg_t *)0)->lobits) * NBBY));
+	assert(sizeof(hnk_t) == HNKSZ);
+	assert(sizeof(pers_t) <= PERSSZ);
 
 	/* get inomap info from media hdr
 	 */
@@ -213,32 +213,32 @@ inomap_restore_pers( drive_t *drivep,
 
 	/* truncate and open the backing store
 	 */
-	perspath = open_pathalloc( hkdir, PERS_NAME, 0 );
-	( void )unlink( perspath );
-	fd = open( perspath,
+	perspath = open_pathalloc(hkdir, PERS_NAME, 0);
+	(void)unlink(perspath);
+	fd = open(perspath,
 		   O_RDWR | O_CREAT,
-		   S_IRUSR | S_IWUSR );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		   S_IRUSR | S_IWUSR);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "could not open %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return RV_ERROR;
 	}
 
 	/* mmap the persistent hdr and space for the map
 	 */
-	persp = ( pers_t * ) mmap_autogrow(
+	persp = (pers_t *) mmap_autogrow(
 				     PERSSZ
 				     +
-				     sizeof( hnk_t ) * ( size_t )hnkcnt,
+				     sizeof(hnk_t) * (size_t)hnkcnt,
 				     fd,
-				     ( off64_t )0 );
-	if ( persp == ( pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				     (off64_t)0);
+	if (persp == (pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return RV_ERROR;
 	}
 
@@ -248,17 +248,17 @@ inomap_restore_pers( drive_t *drivep,
 	persp->segcnt = segcnt;
 	persp->last_ino_added = last_ino_added;
 
-	tmphnkp = ( hnk_t * )calloc( ( size_t )hnkcnt, sizeof( hnk_t ));
-	assert( tmphnkp );
+	tmphnkp = (hnk_t *)calloc((size_t)hnkcnt, sizeof(hnk_t));
+	assert(tmphnkp);
 
 	/* read the map in from media
 	 */
-	nread = read_buf( ( char * )tmphnkp,
-			  sizeof( hnk_t ) * ( size_t )hnkcnt,
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
+	nread = read_buf((char *)tmphnkp,
+			  sizeof(hnk_t) * (size_t)hnkcnt,
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
 
 	pershnkp = (hnk_t *)((char *)persp + PERSSZ);
 	for(i = 0; i < hnkcnt; i++) {
@@ -270,23 +270,23 @@ inomap_restore_pers( drive_t *drivep,
 
 	/* close up
 	 */
-	rval1 = munmap( ( void * )persp,
+	rval1 = munmap((void *)persp,
 		        PERSSZ
 		        +
-		        sizeof( hnk_t ) * ( size_t )hnkcnt );
-	assert( ! rval1 );
-	( void )close( fd );
-	free( ( void * )perspath );
+		        sizeof(hnk_t) * (size_t)hnkcnt);
+	assert(! rval1);
+	(void)close(fd);
+	free((void *)perspath);
 
 	mlog(MLOG_NITTY, "inomap_restore_pers: post-munmap\n");
 
 	/* check the return code from read
 	 */
-	switch( rval ) {
+	switch(rval) {
 	case 0:
-		assert( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
-		ok = inomap_sync_pers( hkdir );
-		if ( ! ok ) {
+		assert((size_t)nread == sizeof(hnk_t) * (size_t)hnkcnt);
+		ok = inomap_sync_pers(hkdir);
+		if (! ok) {
 			return RV_ERROR;
 		}
 		return RV_OK;
@@ -307,7 +307,7 @@ inomap_restore_pers( drive_t *drivep,
 /* peels inomap from media
  */
 rv_t
-inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
+inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	uint64_t tmphnkcnt;
@@ -321,17 +321,17 @@ inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
 
 	/* read the map in from media
 	 */
-	nread = read_buf( 0,
-			  sizeof( hnk_t ) * ( size_t )tmphnkcnt,
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
+	nread = read_buf(0,
+			  sizeof(hnk_t) * (size_t)tmphnkcnt,
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
 	/* check the return code from read
 	 */
-	switch( rval ) {
+	switch(rval) {
 	case 0:
-		assert( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
+		assert((size_t)nread == sizeof(hnk_t) * (size_t)hnkcnt);
 		return RV_OK;
 	case DRIVE_ERROR_EOD:
 	case DRIVE_ERROR_EOF:
@@ -348,7 +348,7 @@ inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
 }
 
 bool_t
-inomap_sync_pers( char *hkdir )
+inomap_sync_pers(char *hkdir)
 {
 	char *perspath;
 	pers_t *persp;
@@ -356,33 +356,33 @@ inomap_sync_pers( char *hkdir )
 
 	/* sanity checks
 	 */
-	assert( sizeof( hnk_t ) == HNKSZ );
+	assert(sizeof(hnk_t) == HNKSZ);
 
 	/* only needed once per session
 	 */
-	if ( pers_fd >= 0 ) {
+	if (pers_fd >= 0) {
 		return BOOL_TRUE;
 	}
 
 	/* open the backing store. if not present, ok, hasn't been created yet
 	 */
-	perspath = open_pathalloc( hkdir, PERS_NAME, 0 );
-	pers_fd = open( perspath, O_RDWR );
-	if ( pers_fd < 0 ) {
+	perspath = open_pathalloc(hkdir, PERS_NAME, 0);
+	pers_fd = open(perspath, O_RDWR);
+	if (pers_fd < 0) {
 		return BOOL_TRUE;
 	}
 
 	/* mmap the persistent hdr
 	 */
-	persp = ( pers_t * ) mmap_autogrow(
+	persp = (pers_t *) mmap_autogrow(
 				     PERSSZ,
 				     pers_fd,
-				     ( off64_t )0 );
-	if ( persp == ( pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				     (off64_t)0);
+	if (persp == (pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map %s hdr: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -394,26 +394,26 @@ inomap_sync_pers( char *hkdir )
 
 	/* mmap the pers inomap
 	 */
-	assert( hnkcnt * sizeof( hnk_t ) <= ( size64_t )INT32MAX );
-	roothnkp = ( hnk_t * ) mmap_autogrow(
-				       sizeof( hnk_t ) * ( size_t )hnkcnt,
+	assert(hnkcnt * sizeof(hnk_t) <= (size64_t)INT32MAX);
+	roothnkp = (hnk_t *) mmap_autogrow(
+				       sizeof(hnk_t) * (size_t)hnkcnt,
 				       pers_fd,
-				       ( off64_t )PERSSZ );
-	if ( roothnkp == ( hnk_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				       (off64_t)PERSSZ);
+	if (roothnkp == (hnk_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* correct the next pointers
 	 */
-	for ( hnkp = roothnkp
+	for (hnkp = roothnkp
 	      ;
-	      hnkp < roothnkp + ( int )hnkcnt - 1
+	      hnkp < roothnkp + (int)hnkcnt - 1
 	      ;
-	      hnkp++ ) {
+	      hnkp++) {
 		hnkp->nextp = hnkp + 1;
 	}
 	hnkp->nextp = 0;
@@ -421,12 +421,12 @@ inomap_sync_pers( char *hkdir )
 	/* calculate the tail pointers
 	 */
 	tailhnkp = hnkp;
-	assert( hnkcnt > 0 );
-	lastsegp = &tailhnkp->seg[ ( int )( segcnt
+	assert(hnkcnt > 0);
+	lastsegp = &tailhnkp->seg[(int)(segcnt
 						 -
-						 SEGPERHNK * ( hnkcnt - 1 )
+						 SEGPERHNK * (hnkcnt - 1)
 						 -
-						 1 ) ];
+						 1)];
 
 	/* now all inomap operators will work
 	 */
@@ -436,50 +436,50 @@ inomap_sync_pers( char *hkdir )
 /* de-allocate the persistent inomap
  */
 void
-inomap_del_pers( char *hkdir )
+inomap_del_pers(char *hkdir)
 {
-	char *perspath = open_pathalloc( hkdir, PERS_NAME, 0 );
-	( void )unlink( perspath );
-	free( ( void * )perspath );
+	char *perspath = open_pathalloc(hkdir, PERS_NAME, 0);
+	(void)unlink(perspath);
+	free((void *)perspath);
 }
 
 /* mark all included non-dirs as MAP_NDR_NOREST
  */
 void
-inomap_sanitize( void )
+inomap_sanitize(void)
 {
 	hnk_t *hnkp;
 	seg_t *segp;
 
 	/* step through all hunks, segs, and inos
 	 */
-	for ( hnkp = roothnkp
+	for (hnkp = roothnkp
 	      ;
 	      hnkp != 0
 	      ;
-	      hnkp = hnkp->nextp ) {
-		for ( segp = hnkp->seg
+	      hnkp = hnkp->nextp) {
+		for (segp = hnkp->seg
 		      ;
 		      segp < hnkp->seg + SEGPERHNK
 		      ;
-		      segp++ ) {
+		      segp++) {
 			xfs_ino_t ino;
-			if ( hnkp == tailhnkp && segp > lastsegp ) {
+			if (hnkp == tailhnkp && segp > lastsegp) {
 				return;
 			}
-			for ( ino = segp->base
+			for (ino = segp->base
 			      ;
 			      ino < segp->base + INOPERSEG
 			      ;
-			      ino++ ) {
+			      ino++) {
 				int state;
-				if ( ino > last_ino_added ) {
+				if (ino > last_ino_added) {
 					return;
 				}
-				state = SEG_GET_BITS( segp, ino );
-				if ( state == MAP_NDR_CHANGE ) {
+				state = SEG_GET_BITS(segp, ino);
+				if (state == MAP_NDR_CHANGE) {
 					state = MAP_NDR_NOREST;
-					SEG_SET_BITS( segp, ino, state );
+					SEG_SET_BITS(segp, ino, state);
 				}
 			}
 		}
@@ -489,53 +489,53 @@ inomap_sanitize( void )
 /* called to mark a non-dir ino as TO be restored
  */
 void
-inomap_rst_add( xfs_ino_t ino )
+inomap_rst_add(xfs_ino_t ino)
 {
-		assert( pers_fd >= 0 );
-		( void )map_set( ino, MAP_NDR_CHANGE );
+		assert(pers_fd >= 0);
+		(void)map_set(ino, MAP_NDR_CHANGE);
 }
 
 /* called to mark a non-dir ino as NOT to be restored
  */
 void
-inomap_rst_del( xfs_ino_t ino )
+inomap_rst_del(xfs_ino_t ino)
 {
-		assert( pers_fd >= 0 );
-		( void )map_set( ino, MAP_NDR_NOREST );
+		assert(pers_fd >= 0);
+		(void)map_set(ino, MAP_NDR_NOREST);
 }
 
 /* called to ask if any inos in the given range need to be restored.
  * range is inclusive
  */
 bool_t
-inomap_rst_needed( xfs_ino_t firstino, xfs_ino_t lastino )
+inomap_rst_needed(xfs_ino_t firstino, xfs_ino_t lastino)
 {
 	hnk_t *hnkp;
 	seg_t *segp;
 
 	/* if inomap not restored/resynced, just say yes
 	 */
-	if ( ! roothnkp ) {
+	if (! roothnkp) {
 		return BOOL_TRUE;
 	}
 
 	/* may be completely out of range
 	 */
-	if ( firstino > last_ino_added ) {
+	if (firstino > last_ino_added) {
 		return BOOL_FALSE;
 	}
 
 	/* find the hunk/seg containing first ino or any ino beyond
 	 */
-	for ( hnkp = roothnkp ; hnkp != 0 ; hnkp = hnkp->nextp ) {
-		if ( firstino > hnkp->maxino ) {
+	for (hnkp = roothnkp ; hnkp != 0 ; hnkp = hnkp->nextp) {
+		if (firstino > hnkp->maxino) {
 			continue;
 		}
-		for ( segp = hnkp->seg; segp < hnkp->seg + SEGPERHNK ; segp++ ){
-			if ( hnkp == tailhnkp && segp > lastsegp ) {
+		for (segp = hnkp->seg; segp < hnkp->seg + SEGPERHNK ; segp++){
+			if (hnkp == tailhnkp && segp > lastsegp) {
 				return BOOL_FALSE;
 			}
-			if ( firstino < segp->base + INOPERSEG ) {
+			if (firstino < segp->base + INOPERSEG) {
 				goto begin;
 			}
 		}
@@ -545,32 +545,32 @@ inomap_rst_needed( xfs_ino_t firstino, xfs_ino_t lastino )
 begin:
 	/* search until at least one ino is needed or until beyond last ino
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		xfs_ino_t ino;
 
-		if ( segp->base > lastino ) {
+		if (segp->base > lastino) {
 			return BOOL_FALSE;
 		}
-		for ( ino = segp->base ; ino < segp->base + INOPERSEG ; ino++ ){
+		for (ino = segp->base ; ino < segp->base + INOPERSEG ; ino++){
 			int state;
-			if ( ino < firstino ) {
+			if (ino < firstino) {
 				continue;
 			}
-			if ( ino > lastino ) {
+			if (ino > lastino) {
 				return BOOL_FALSE;
 			}
-			state = SEG_GET_BITS( segp, ino );
-			if ( state == MAP_NDR_CHANGE ) {
+			state = SEG_GET_BITS(segp, ino);
+			if (state == MAP_NDR_CHANGE) {
 				return BOOL_TRUE;
 			}
 		}
 		segp++;
-		if ( hnkp == tailhnkp && segp > lastsegp ) {
+		if (hnkp == tailhnkp && segp > lastsegp) {
 			return BOOL_FALSE;
 		}
-		if ( segp >= hnkp->seg + SEGPERHNK ) {
+		if (segp >= hnkp->seg + SEGPERHNK) {
 			hnkp = hnkp->nextp;
-			if ( ! hnkp ) {
+			if (! hnkp) {
 				return BOOL_FALSE;
 			}
 			segp = hnkp->seg;
@@ -584,43 +584,43 @@ begin:
  * returns FALSE.
  */
 void
-inomap_cbiter( int statemask,
-	       bool_t ( * cbfunc )( void *ctxp, xfs_ino_t ino ),
-	       void *ctxp )
+inomap_cbiter(int statemask,
+	       bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
+	       void *ctxp)
 {
 	hnk_t *hnkp;
 	seg_t *segp;
 
 	/* step through all hunks, segs, and inos
 	 */
-	for ( hnkp = roothnkp
+	for (hnkp = roothnkp
 	      ;
 	      hnkp != 0
 	      ;
-	      hnkp = hnkp->nextp ) {
-		for ( segp = hnkp->seg
+	      hnkp = hnkp->nextp) {
+		for (segp = hnkp->seg
 		      ;
 		      segp < hnkp->seg + SEGPERHNK
 		      ;
-		      segp++ ) {
+		      segp++) {
 			xfs_ino_t ino;
-			if ( hnkp == tailhnkp && segp > lastsegp ) {
+			if (hnkp == tailhnkp && segp > lastsegp) {
 				return;
 			}
-			for ( ino = segp->base
+			for (ino = segp->base
 			      ;
 			      ino < segp->base + INOPERSEG
 			      ;
-			      ino++ ) {
+			      ino++) {
 				int state;
-				if ( ino > last_ino_added ) {
+				if (ino > last_ino_added) {
 					return;
 				}
-				state = SEG_GET_BITS( segp, ino );
-				if ( statemask & ( 1 << state )) {
+				state = SEG_GET_BITS(segp, ino);
+				if (statemask & (1 << state)) {
 					bool_t ok;
-					ok = ( cbfunc )( ctxp, ino );
-					if ( ! ok ) {
+					ok = (cbfunc)(ctxp, ino);
+					if (! ok) {
 						return;
 					}
 				}
@@ -635,24 +635,24 @@ inomap_cbiter( int statemask,
  * and optionally sets the state to a new value.
  */
 static int
-map_getset( xfs_ino_t ino, int newstate, bool_t setflag )
+map_getset(xfs_ino_t ino, int newstate, bool_t setflag)
 {
 	int state;
 	seg_t *segp;
 
-	if ((segp = map_getsegment( ino )) == NULL) {
+	if ((segp = map_getsegment(ino)) == NULL) {
 		return MAP_INO_UNUSED;
 	}
 
-	state = SEG_GET_BITS( segp, ino );
-	if ( setflag ) {
-		SEG_SET_BITS( segp, ino, newstate );
+	state = SEG_GET_BITS(segp, ino);
+	if (setflag) {
+		SEG_SET_BITS(segp, ino, newstate);
 	}
 	return state;
 }
 
 static seg_t *
-map_getsegment( xfs_ino_t ino )
+map_getsegment(xfs_ino_t ino)
 {
 	uint64_t min;
 	uint64_t max;
@@ -690,7 +690,7 @@ map_getsegment( xfs_ino_t ino )
 
 	min = 0;
 	if (hnk == hnkcnt - 1) {
-		max = segcnt - SEGPERHNK * ( hnkcnt - 1 ) - 1;
+		max = segcnt - SEGPERHNK * (hnkcnt - 1) - 1;
 	} else {
 		max = SEGPERHNK - 1;
 	}
@@ -710,10 +710,10 @@ map_getsegment( xfs_ino_t ino )
 }
 
 static int
-map_set( xfs_ino_t ino, int state )
+map_set(xfs_ino_t ino, int state)
 {
 	int oldstate;
 
- 	oldstate = map_getset( ino, state, BOOL_TRUE );
+ 	oldstate = map_getset(ino, state, BOOL_TRUE);
 	return oldstate;
 }
diff --git a/restore/inomap.h b/restore/inomap.h
index 03facdb..93f982c 100644
--- a/restore/inomap.h
+++ b/restore/inomap.h
@@ -55,32 +55,32 @@ struct seg {
 
 typedef struct seg seg_t;
 
-#define INOPERSEG	( sizeofmember( seg_t, lobits ) * NBBY )
+#define INOPERSEG	(sizeofmember(seg_t, lobits) * NBBY)
 
-#define HNKSZ		( 4 * PGSZ )
-#define SEGPERHNK	( ( HNKSZ / sizeof( seg_t )) - 1 )
+#define HNKSZ		(4 * PGSZ)
+#define SEGPERHNK	((HNKSZ / sizeof(seg_t)) - 1)
 
 struct hnk {
-	seg_t seg[ SEGPERHNK ];
+	seg_t seg[SEGPERHNK];
 	xfs_ino_t maxino;
 	struct hnk *nextp;
-	char pad[sizeof( seg_t ) - sizeof( xfs_ino_t ) - sizeof( struct hnk * )];
+	char pad[sizeof(seg_t) - sizeof(xfs_ino_t) - sizeof(struct hnk *)];
 };
 
 typedef struct hnk hnk_t;
 
-extern bool_t inomap_sync_pers( char *hkdir );
-extern rv_t inomap_restore_pers( drive_t *drivep,
+extern bool_t inomap_sync_pers(char *hkdir);
+extern rv_t inomap_restore_pers(drive_t *drivep,
 				 content_inode_hdr_t *scrhdrp,
-				 char *hkdir );
-extern void inomap_del_pers( char *hkdir );
-extern void inomap_sanitize( void );
-extern bool_t inomap_rst_needed( xfs_ino_t begino, xfs_ino_t endino );
-extern void inomap_rst_add( xfs_ino_t ino );
-extern void inomap_rst_del( xfs_ino_t ino );
-extern rv_t inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp );
-extern void inomap_cbiter( int mapstatemask,
-			   bool_t ( * cbfunc )( void *ctxp, xfs_ino_t ino ),
-			   void *ctxp );
+				 char *hkdir);
+extern void inomap_del_pers(char *hkdir);
+extern void inomap_sanitize(void);
+extern bool_t inomap_rst_needed(xfs_ino_t begino, xfs_ino_t endino);
+extern void inomap_rst_add(xfs_ino_t ino);
+extern void inomap_rst_del(xfs_ino_t ino);
+extern rv_t inomap_discard(drive_t *drivep, content_inode_hdr_t *scrhdrp);
+extern void inomap_cbiter(int mapstatemask,
+			   bool_t (* cbfunc)(void *ctxp, xfs_ino_t ino),
+			   void *ctxp);
 
 #endif /* INOMAP_H */
diff --git a/restore/mmap.c b/restore/mmap.c
index 29dd3d7..0407740 100644
--- a/restore/mmap.c
+++ b/restore/mmap.c
@@ -41,5 +41,5 @@ mmap_autogrow(size_t len, int fd, off_t offset)
 	(void)write(fd, nul_buffer, 1);
     }
 
-    return mmap( 0, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset );
+    return mmap(0, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset);
 }
diff --git a/restore/namreg.c b/restore/namreg.c
index 8e7ff76..89fa5ef 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -76,21 +76,21 @@ typedef struct namreg_tran namreg_tran_t;
  * checking is enabled.
  */
 #define CHKBITCNT		2
-#define	CHKBITSHIFT		( NBBY * sizeof( nrh_t ) - CHKBITCNT )
-#define	CHKBITLOMASK		( ( 1ULL << CHKBITCNT ) - 1 )
-#define	CHKBITMASK		( CHKBITLOMASK << CHKBITSHIFT )
+#define	CHKBITSHIFT		(NBBY * sizeof(nrh_t) - CHKBITCNT)
+#define	CHKBITLOMASK		((1ULL << CHKBITCNT) - 1)
+#define	CHKBITMASK		(CHKBITLOMASK << CHKBITSHIFT)
 #define CHKHDLCNT		CHKBITSHIFT
-#define CHKHDLMASK		( ( 1ULL << CHKHDLCNT ) - 1 )
-#define CHKGETBIT( h )		( ( (h) >> CHKBITSHIFT ) & CHKBITLOMASK )
-#define CHKGETHDL( h )		( (h) & CHKHDLMASK )
-#define CHKMKHDL( c, h )	( ( ( (c) << CHKBITSHIFT ) & CHKBITMASK )	\
+#define CHKHDLMASK		((1ULL << CHKHDLCNT) - 1)
+#define CHKGETBIT(h)		(((h) >> CHKBITSHIFT) & CHKBITLOMASK)
+#define CHKGETHDL(h)		((h) & CHKHDLMASK)
+#define CHKMKHDL(c, h)	((((c) << CHKBITSHIFT) & CHKBITMASK)	\
 				  |					\
-				  ( (h) & CHKHDLMASK ))
-#define HDLMAX			( ( off64_t )CHKHDLMASK )
+				  ((h) & CHKHDLMASK))
+#define HDLMAX			((off64_t)CHKHDLMASK)
 
 #else /* NAMREGCHK */
 
-#define HDLMAX			( NRH_NULL - 1 )
+#define HDLMAX			(NRH_NULL - 1)
 
 #endif /* NAMREGCHK */
 
@@ -101,7 +101,7 @@ extern size_t pgsz;
 
 /* forward declarations of locally defined static functions ******************/
 
-static rv_t namreg_flush( void );
+static rv_t namreg_flush(void);
 
 /* definition of locally defined global variables ****************************/
 
@@ -116,56 +116,56 @@ static namreg_pers_t *npp = 0;
 /* definition of locally defined global functions ****************************/
 
 bool_t
-namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
+namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 {
-	if ( ntp ) {
+	if (ntp) {
 		return BOOL_TRUE;
 	}
 
 	/* sanity checks
 	 */
-	assert( ! ntp );
-	assert( ! npp );
+	assert(! ntp);
+	assert(! npp);
 
-	assert( sizeof( namreg_pers_t ) <= NAMREG_PERS_SZ );
+	assert(sizeof(namreg_pers_t) <= NAMREG_PERS_SZ);
 
 	/* allocate and initialize context
 	 */
-	ntp = ( namreg_tran_t * )calloc( 1, sizeof( namreg_tran_t ));
-	assert( ntp );
+	ntp = (namreg_tran_t *)calloc(1, sizeof(namreg_tran_t));
+	assert(ntp);
 
 	/* generate a string containing the pathname of the namreg file
 	 */
-	ntp->nt_pathname = open_pathalloc( hkdir, namregfile, 0 );
+	ntp->nt_pathname = open_pathalloc(hkdir, namregfile, 0);
 
 	/* open the namreg file
 	 */
-	if ( resume ) {
+	if (resume) {
 		/* open existing file
 		 */
-		ntp->nt_fd = open( ntp->nt_pathname, O_RDWR );
-		if ( ntp->nt_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		ntp->nt_fd = open(ntp->nt_pathname, O_RDWR);
+		if (ntp->nt_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not find name registry file %s: "
 			      "%s\n"),
 			      ntp->nt_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 	} else {
 		/* create the namreg file, first unlinking any older version
 		 * laying around
 		 */
-		( void )unlink( ntp->nt_pathname );
-		ntp->nt_fd = open( ntp->nt_pathname,
+		(void)unlink(ntp->nt_pathname);
+		ntp->nt_fd = open(ntp->nt_pathname,
 				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR );
-		if ( ntp->nt_fd < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				   S_IRUSR | S_IWUSR);
+		if (ntp->nt_fd < 0) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create name registry file %s: "
 			      "%s\n"),
 			      ntp->nt_pathname,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
 
@@ -179,7 +179,7 @@ namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 		int loglevel;
 		size_t trycnt;
 
-		for ( trycnt = 0,
+		for (trycnt = 0,
 		      successpr = BOOL_FALSE,
 		      ioctlcmd = XFS_IOC_RESVSP64,
 		      loglevel = MLOG_VERBOSE
@@ -188,25 +188,25 @@ namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 		      ;
 		      trycnt++,
 		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max( MLOG_NORMAL, loglevel - 1 )) {
+		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
 			off64_t initsz;
 			struct flock64 flock64;
 			int rval;
 
-			if ( ! ioctlcmd ) {
+			if (! ioctlcmd) {
 				continue;
 			}
 
-			initsz = ( off64_t )NAMREG_PERS_SZ
+			initsz = (off64_t)NAMREG_PERS_SZ
 				 +
-				 ( ( off64_t )inocnt * NAMREG_AVGLEN );
+				 ((off64_t)inocnt * NAMREG_AVGLEN);
 			flock64.l_whence = 0;
 			flock64.l_start = 0;
 			flock64.l_len = initsz;
-			rval = ioctl( ntp->nt_fd, ioctlcmd, &flock64 );
-			if ( rval ) {
-				if ( errno != ENOTTY ) {
-					mlog( loglevel | MLOG_NOTE, _(
+			rval = ioctl(ntp->nt_fd, ioctlcmd, &flock64);
+			if (rval) {
+				if (errno != ENOTTY) {
+					mlog(loglevel | MLOG_NOTE, _(
 					      "attempt to reserve %lld bytes for %s "
 					      "using %s "
 					      "failed: %s (%d)\n"),
@@ -217,8 +217,8 @@ namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 					      "XFS_IOC_RESVSP64"
 					      :
 					      "XFS_IOC_ALLOCSP64",
-					      strerror( errno ),
-					      errno );
+					      strerror(errno),
+					      errno);
 				}
 			} else {
 				successpr = BOOL_TRUE;
@@ -229,23 +229,23 @@ namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 
 	/* mmap the persistent descriptor
 	 */
-	assert( ! ( NAMREG_PERS_SZ % pgsz ));
-	npp = ( namreg_pers_t * ) mmap_autogrow(
+	assert(! (NAMREG_PERS_SZ % pgsz));
+	npp = (namreg_pers_t *) mmap_autogrow(
 				        NAMREG_PERS_SZ,
 				        ntp->nt_fd,
-				        ( off_t )0 );
-	if ( npp == ( namreg_pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				        (off_t)0);
+	if (npp == (namreg_pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map %s: %s\n"),
 		      ntp->nt_pathname,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* initialize persistent state
 	 */
-	if ( ! resume ) {
-		npp->np_appendoff = ( off64_t )NAMREG_PERS_SZ;
+	if (! resume) {
+		npp->np_appendoff = (off64_t)NAMREG_PERS_SZ;
 	}
 
 	/* initialize transient state
@@ -256,7 +256,7 @@ namreg_init( char *hkdir, bool_t resume, uint64_t inocnt )
 }
 
 nrh_t
-namreg_add( char *name, size_t namelen )
+namreg_add(char *name, size_t namelen)
 {
 	off64_t oldoff;
 	unsigned char c;
@@ -264,23 +264,23 @@ namreg_add( char *name, size_t namelen )
 
 	/* sanity checks
 	 */
-	assert( ntp );
-	assert( npp );
-	assert( !ntp->nt_map );
+	assert(ntp);
+	assert(npp);
+	assert(!ntp->nt_map);
 
 	/* make sure file pointer is positioned to append
 	 */
-	if ( ! ntp->nt_at_endpr ) {
+	if (! ntp->nt_at_endpr) {
 		off64_t newoff;
-		newoff = lseek64( ntp->nt_fd, npp->np_appendoff, SEEK_SET );
-		if ( newoff == ( off64_t )-1 ) {
-			mlog( MLOG_NORMAL, _(
+		newoff = lseek64(ntp->nt_fd, npp->np_appendoff, SEEK_SET);
+		if (newoff == (off64_t)-1) {
+			mlog(MLOG_NORMAL, _(
 			      "lseek of namreg failed: %s\n"),
-			      strerror( errno ));
-			assert( 0 );
+			      strerror(errno));
+			assert(0);
 			return NRH_NULL;
 		}
-		assert( npp->np_appendoff == newoff );
+		assert(npp->np_appendoff == newoff);
 		ntp->nt_at_endpr = BOOL_TRUE;
 	}
 
@@ -296,8 +296,8 @@ namreg_add( char *name, size_t namelen )
 
 	/* write a one byte unsigned string length into the buffer.
 	 */
-	assert( namelen < 256 );
-	c = ( unsigned char )( namelen & 0xff );
+	assert(namelen < 256);
+	c = (unsigned char)(namelen & 0xff);
 	ntp->nt_buf[ntp->nt_off++] = c;
 
 	/* write the name string into the buffer.
@@ -305,18 +305,18 @@ namreg_add( char *name, size_t namelen )
 	memcpy(ntp->nt_buf + ntp->nt_off, name, namelen);
 	ntp->nt_off += namelen;
 
-	npp->np_appendoff += ( off64_t )( 1 + namelen );
-	assert( oldoff <= HDLMAX );
+	npp->np_appendoff += (off64_t)(1 + namelen);
+	assert(oldoff <= HDLMAX);
 
 #ifdef NAMREGCHK
 
 	/* encode the lsb of the len plus the first character into the handle.
 	 */
-	nrh = CHKMKHDL( ( nrh_t )namelen + ( nrh_t )*name, ( nrh_t )oldoff );
+	nrh = CHKMKHDL((nrh_t)namelen + (nrh_t)*name, (nrh_t)oldoff);
 
 #else /* NAMREGCHK */
 
-	nrh = ( nrh_t )oldoff;
+	nrh = (nrh_t)oldoff;
 
 #endif /* NAMREGCHK */
 
@@ -325,38 +325,38 @@ namreg_add( char *name, size_t namelen )
 
 /* ARGSUSED */
 void
-namreg_del( nrh_t nrh )
+namreg_del(nrh_t nrh)
 {
 	/* currently not implemented - grows, never shrinks
 	 */
 }
 
 static rv_t
-namreg_flush( void )
+namreg_flush(void)
 {
 	ssize_t nwritten;
 
 	/* sanity checks
 	*/
-	assert( ntp );
+	assert(ntp);
 
 	if (ntp->nt_off) {
 
 		/* write the accumulated name strings.
 		*/
-		nwritten = write( ntp->nt_fd, ( void * )ntp->nt_buf, ntp->nt_off );
-		if ( nwritten != ntp->nt_off ) {
-			if ( nwritten < 0 ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+		nwritten = write(ntp->nt_fd, (void *)ntp->nt_buf, ntp->nt_off);
+		if (nwritten != ntp->nt_off) {
+			if (nwritten < 0) {
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 					_("write of namreg buffer failed: %s\n"),
-					strerror( errno ));
+					strerror(errno));
 			} else {
-				mlog( MLOG_NORMAL | MLOG_ERROR,
+				mlog(MLOG_NORMAL | MLOG_ERROR,
 					_("write of namreg buffer failed: "
 					"expected to write %ld, actually "
 					"wrote %ld\n"), ntp->nt_off, nwritten);
 			}
-			assert( 0 );
+			assert(0);
 			return RV_UNKNOWN;
 		}
 		ntp->nt_off = 0;
@@ -365,9 +365,9 @@ namreg_flush( void )
 }
 
 int
-namreg_get( nrh_t nrh,
+namreg_get(nrh_t nrh,
 	    char *bufp,
-	    size_t bufsz )
+	    size_t bufsz)
 {
 	off64_t newoff;
 	int nread;
@@ -381,55 +381,55 @@ namreg_get( nrh_t nrh,
 
 	/* sanity checks
 	 */
-	assert( ntp );
-	assert( npp );
+	assert(ntp);
+	assert(npp);
 
 	/* make sure we aren't being given a NULL handle
 	 */
-	assert( nrh != NRH_NULL );
+	assert(nrh != NRH_NULL);
 
 	/* convert the handle into the offset
 	 */
 #ifdef NAMREGCHK
 
-	newoff = ( off64_t )( size64_t )CHKGETHDL( nrh );
-	chkbit = CHKGETBIT( nrh );
+	newoff = (off64_t)(size64_t)CHKGETHDL(nrh);
+	chkbit = CHKGETBIT(nrh);
 
 #else /* NAMREGCHK */
 
-	newoff = ( off64_t )( size64_t )nrh;
+	newoff = (off64_t)(size64_t)nrh;
 
 #endif /* NAMREGCHK */
 
 	/* do sanity check on offset
 	 */
-	assert( newoff <= HDLMAX );
-	assert( newoff < npp->np_appendoff );
-	assert( newoff >= ( off64_t )NAMREG_PERS_SZ );
+	assert(newoff <= HDLMAX);
+	assert(newoff < npp->np_appendoff);
+	assert(newoff >= (off64_t)NAMREG_PERS_SZ);
 
-	lock( );
+	lock();
 
-	if ( ntp->nt_map ) {
+	if (ntp->nt_map) {
 
 		in_bufp = ntp->nt_map + newoff - NAMREG_PERS_SZ;
 
 	} else {
 
-		if ( ntp->nt_at_endpr && ntp->nt_off ) {
+		if (ntp->nt_at_endpr && ntp->nt_off) {
 			if (namreg_flush() != RV_OK) {
-				unlock( );
+				unlock();
 				return -3;
 			}
 		}
 
 		/* seek to the name
 		*/
-		newoff = lseek64( ntp->nt_fd, newoff, SEEK_SET );
-		if ( newoff == ( off64_t )-1 ) {
-			unlock( );
-			mlog( MLOG_NORMAL, _(
+		newoff = lseek64(ntp->nt_fd, newoff, SEEK_SET);
+		if (newoff == (off64_t)-1) {
+			unlock();
+			mlog(MLOG_NORMAL, _(
 				"lseek of namreg failed: %s\n"),
-				strerror( errno ));
+				strerror(errno));
 			return -3;
 		}
 		ntp->nt_at_endpr = BOOL_FALSE;
@@ -438,13 +438,13 @@ namreg_get( nrh_t nrh,
 		 * NOTE: assumes read_buf is big enough for the longest
 		 * allowed name (255 chars) plus one byte for length.
 		 */
-		nread = read( ntp->nt_fd, ( void * )read_buf, sizeof(read_buf) );
-		if ( nread <= 0 ) {
-			unlock( );
-			mlog( MLOG_NORMAL, _(
+		nread = read(ntp->nt_fd, (void *)read_buf, sizeof(read_buf));
+		if (nread <= 0) {
+			unlock();
+			mlog(MLOG_NORMAL, _(
 				"read of namreg failed: %s (nread = %d)\n"),
-				strerror( errno ),
-				nread );
+				strerror(errno),
+				nread);
 			return -3;
 		}
 
@@ -453,9 +453,9 @@ namreg_get( nrh_t nrh,
 
 	/* deal with a short caller-supplied buffer
 	 */
-	len = ( size_t )in_bufp[0];
-	if ( bufsz < len + 1 ) {
-		unlock( );
+	len = (size_t)in_bufp[0];
+	if (bufsz < len + 1) {
+		unlock();
 		return -1;
 	}
 
@@ -467,42 +467,42 @@ namreg_get( nrh_t nrh,
 
 	/* validate the checkbit
 	 */
-	assert( chkbit
+	assert(chkbit
 		==
-		( ( ( nrh_t )len + ( nrh_t )bufp[ 0 ] ) & CHKBITLOMASK ));
+		(((nrh_t)len + (nrh_t)bufp[0]) & CHKBITLOMASK));
 
 #endif /* NAMREGCHK */
 
 	/* null-terminate the string if room
 	 */
-	bufp[ len ] = 0;
+	bufp[len] = 0;
 
-	unlock( );
+	unlock();
 
-	return ( int )len;
+	return (int)len;
 }
 
 rv_t
-namreg_map( void )
+namreg_map(void)
 {
 	rv_t rv;
 
 	/* ensure all entries have been written */
-	if ( (rv = namreg_flush()) != RV_OK ) {
+	if ((rv = namreg_flush()) != RV_OK) {
 		return rv;
 	}
 
-	ntp->nt_map = ( char * ) mmap_autogrow(
+	ntp->nt_map = (char *) mmap_autogrow(
 					npp->np_appendoff - NAMREG_PERS_SZ,
 					ntp->nt_fd,
-					NAMREG_PERS_SZ );
+					NAMREG_PERS_SZ);
 
 	/* it's okay if this fails, just fall back to (the much slower)
 	 * seek-and-read lookups.
 	 */
-	if ( ntp->nt_map == ( char * )-1 ) {
-		mlog( MLOG_DEBUG, "failed to map namreg: %s\n",
-			strerror( errno ) );
+	if (ntp->nt_map == (char *)-1) {
+		mlog(MLOG_DEBUG, "failed to map namreg: %s\n",
+			strerror(errno));
 		ntp->nt_map = NULL;
 	}
 
diff --git a/restore/namreg.h b/restore/namreg.h
index 859ccd7..bd014e2 100644
--- a/restore/namreg.h
+++ b/restore/namreg.h
@@ -34,26 +34,26 @@ typedef size64_t nrh_t;
  * registry should already exist, and we are resynchronizing.
  * if NOT resync, inocnt hints at how many names will be held
  */
-extern bool_t namreg_init( char *housekeepingdir,
+extern bool_t namreg_init(char *housekeepingdir,
 			   bool_t resync,
-			   uint64_t inocnt );
+			   uint64_t inocnt);
 
 
 /* namreg_add - registers a name. name does not need to be null-terminated.
  * returns handle for use with namreg_get().
  */
-extern nrh_t namreg_add( char *name, size_t namelen );
+extern nrh_t namreg_add(char *name, size_t namelen);
 
 
 /* namreg_del - remove a name from the registry
  */
-extern void namreg_del( nrh_t nrh );
+extern void namreg_del(nrh_t nrh);
 
 /* namreg_map - mmap the name registry, allowing for much
  * faster namreg_get() lookups. once called, additional
  * entries cannot be added.
  */
-extern rv_t namreg_map( void );
+extern rv_t namreg_map(void);
 
 /* namreg_get - retrieves the name identified by the index.
  * fills the buffer with the null-terminated name from the registry.
@@ -61,6 +61,6 @@ extern rv_t namreg_map( void );
  * small to fit the null-terminated name. return -2 if the name
  * not in the registry. return -3 if a system call fails.
  */
-extern int namreg_get( nrh_t nrh, char *bufp, size_t bufsz );
+extern int namreg_get(nrh_t nrh, char *bufp, size_t bufsz);
 
 #endif /* NAMREG_H */
diff --git a/restore/node.c b/restore/node.c
index b6b6906..f720730 100644
--- a/restore/node.c
+++ b/restore/node.c
@@ -49,21 +49,21 @@ extern size_t pgmask;
  * that xfsrestore can handle.
  */
 #define HDLGENCNT		4
-#define	HDLGENSHIFT		( NBBY * sizeof ( nh_t ) - HDLGENCNT )
-#define	HDLGENLOMASK		( ( 1 << HDLGENCNT ) - 1 )
-#define	HDLGENMASK		( HDLGENLOMASK << HDLGENSHIFT )
-#define HDLMASK			( ( 1 << HDLGENSHIFT ) - 1 )
-#define HDLGETGEN( h )		( ( u_char_t )				\
-				  ( ( ( int )h >> HDLGENSHIFT )		\
+#define	HDLGENSHIFT		(NBBY * sizeof (nh_t) - HDLGENCNT)
+#define	HDLGENLOMASK		((1 << HDLGENCNT) - 1)
+#define	HDLGENMASK		(HDLGENLOMASK << HDLGENSHIFT)
+#define HDLMASK			((1 << HDLGENSHIFT) - 1)
+#define HDLGETGEN(h)		((u_char_t)				\
+				  (((int)h >> HDLGENSHIFT)		\
 				    &					\
-				    HDLGENLOMASK ))
-#define HDLGETNHDL( h )		( ( nh_t )( ( int )h & HDLMASK ))
-#define HDLMKHDL( g, n )	( ( nh_t )( ( ( ( int )g << HDLGENSHIFT )\
+				    HDLGENLOMASK))
+#define HDLGETNHDL(h)		((nh_t)((int)h & HDLMASK))
+#define HDLMKHDL(g, n)	((nh_t)((((int)g << HDLGENSHIFT)\
 					      &				\
-					      HDLGENMASK )		\
+					      HDLGENMASK)		\
 					  |				\
-					  ( ( int )n & HDLMASK )))
-#define NH_MAX			( HDLMASK )
+					  ((int)n & HDLMASK)))
+#define NH_MAX			(HDLMASK)
 
 /* the housekeeping byte of each node will hold two check fields:
  * a gen count, initialized to 0 and incremented each time a node
@@ -74,22 +74,22 @@ extern size_t pgmask;
  * be freed.
  */
 #define HKPGENCNT		HDLGENCNT
-#define HKPGENSHIFT		( NBBY - HKPGENCNT )
-#define HKPGENLOMASK		( ( 1 << HKPGENCNT ) - 1 )
-#define HKPGENMASK		( HKPGENLOMASK << HKPGENSHIFT )
-#define HKPUNQCNT		( NBBY - HKPGENCNT )
-#define HKPUNQMASK		( ( 1 << HKPUNQCNT ) - 1 )
-#define HKPGETGEN( b )		( ( u_char_t )				\
-				  ( ( ( int )b >> HKPGENSHIFT )		\
+#define HKPGENSHIFT		(NBBY - HKPGENCNT)
+#define HKPGENLOMASK		((1 << HKPGENCNT) - 1)
+#define HKPGENMASK		(HKPGENLOMASK << HKPGENSHIFT)
+#define HKPUNQCNT		(NBBY - HKPGENCNT)
+#define HKPUNQMASK		((1 << HKPUNQCNT) - 1)
+#define HKPGETGEN(b)		((u_char_t)				\
+				  (((int)b >> HKPGENSHIFT)		\
 				    &					\
-				    HKPGENLOMASK ))
-#define HKPGETUNQ( b )		( ( u_char_t )( ( int )b & HKPUNQMASK ))
-#define HKPMKHKP( g, u )	( ( u_char_t )				\
-				  ( ( ( ( int )g << HKPGENSHIFT )	\
+				    HKPGENLOMASK))
+#define HKPGETUNQ(b)		((u_char_t)((int)b & HKPUNQMASK))
+#define HKPMKHKP(g, u)	((u_char_t)				\
+				  ((((int)g << HKPGENSHIFT)	\
 				      &					\
-				      HKPGENMASK )			\
+				      HKPGENMASK)			\
 				    |					\
-				    ( ( int )u & HKPUNQMASK )))
+				    ((int)u & HKPUNQMASK)))
 
 /* simple patterns for detecting a node
  */
@@ -98,7 +98,7 @@ extern size_t pgmask;
 
 #else /* NODECHK */
 
-#define NH_MAX			( NH_NULL - 1 )
+#define NH_MAX			(NH_NULL - 1)
 
 #endif /* NODECHK */
 
@@ -159,32 +159,32 @@ static node_hdr_t *node_hdrp;
 static int node_fd;
 
 static inline segix_t
-nh2segix( nh_t nh )
+nh2segix(nh_t nh)
 {
 	return nh >> node_hdrp->nh_segixshift;
 }
 
 static inline relnix_t
-nh2relnix( nh_t nh )
+nh2relnix(nh_t nh)
 {
 	return nh & node_hdrp->nh_relnixmask;
 }
 
 static inline void
-node_map_internal( nh_t nh, void **pp )
+node_map_internal(nh_t nh, void **pp)
 {
-	win_map( nh2segix( nh ), pp );
-	if ( *pp != NULL ) {
-		relnix_t relnix = nh2relnix( nh );
-		*pp = ( void * )( ( char * )( *pp ) +
-				( ( off64_t )relnix *
-				  node_hdrp->nh_nodesz ) );
+	win_map(nh2segix(nh), pp);
+	if (*pp != NULL) {
+		relnix_t relnix = nh2relnix(nh);
+		*pp = (void *)((char *)(*pp) +
+				((off64_t)relnix *
+				  node_hdrp->nh_nodesz));
 	}
 }
 
 /* ARGSUSED */
 static inline void
-node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
+node_unmap_internal(nh_t nh, void **pp, bool_t freepr)
 {
 #ifdef NODECHK
 	register u_char_t hkp;
@@ -193,47 +193,47 @@ node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
 	register u_char_t nodeunq;
 #endif /* NODECHK */
 
-	assert( pp );
-	assert( *pp );
-	assert( nh != NH_NULL );
+	assert(pp);
+	assert(*pp);
+	assert(nh != NH_NULL);
 
 	/* convert the handle into an index
 	 */
 #ifdef NODECHK
-	hdlgen = HDLGETGEN( nh );
-	nh = HDLGETNHDL( nh );
+	hdlgen = HDLGETGEN(nh);
+	nh = HDLGETNHDL(nh);
 #endif /* NODECHK */
 
-	assert( nh <= NH_MAX );
+	assert(nh <= NH_MAX);
 
 #ifdef NODECHK
-	hkp = *( *( u_char_t ** )pp + node_hdrp->nh_nodehkix );
-	nodegen = HKPGETGEN( hkp );
-	assert( nodegen == hdlgen );
-	nodeunq = HKPGETUNQ( hkp );
-	if ( ! freepr ) {
-		assert( nodeunq != NODEUNQFREE );
-		assert( nodeunq == NODEUNQALCD );
+	hkp = *(*(u_char_t **)pp + node_hdrp->nh_nodehkix);
+	nodegen = HKPGETGEN(hkp);
+	assert(nodegen == hdlgen);
+	nodeunq = HKPGETUNQ(hkp);
+	if (! freepr) {
+		assert(nodeunq != NODEUNQFREE);
+		assert(nodeunq == NODEUNQALCD);
 	} else {
-		assert( nodeunq != NODEUNQALCD );
-		assert( nodeunq == NODEUNQFREE );
+		assert(nodeunq != NODEUNQALCD);
+		assert(nodeunq == NODEUNQFREE);
 	}
 #endif /* NODECHK */
 
 	/* unmap the window containing the node
 	 */
-	win_unmap( nh2segix( nh ), pp ); /* zeros *pp */
+	win_unmap(nh2segix(nh), pp); /* zeros *pp */
 }
 
 /* ARGSUSED */
 bool_t
-node_init( int fd,
+node_init(int fd,
 	   off64_t off,
 	   size_t usrnodesz,
 	   ix_t nodehkix,
 	   size_t nodealignsz,
 	   size64_t vmsz,
-	   size64_t dirs_nondirs_cnt )
+	   size64_t dirs_nondirs_cnt)
 {
 	size_t nodesz;
 	size64_t segsz;
@@ -245,23 +245,23 @@ node_init( int fd,
 
 	/* sanity checks
 	 */
-	assert( sizeof( node_hdr_t ) <= NODE_HDRSZ );
-	assert( sizeof( nh_t ) < sizeof( off64_t ));
-	assert( sizeof( nh_t ) <= sizeof( segix_t ));
-	assert( sizeof( nh_t ) <= sizeof( relnix_t ));
-	assert( nodehkix < usrnodesz );
-	assert( usrnodesz >= sizeof( char * ) + 1 );
+	assert(sizeof(node_hdr_t) <= NODE_HDRSZ);
+	assert(sizeof(nh_t) < sizeof(off64_t));
+	assert(sizeof(nh_t) <= sizeof(segix_t));
+	assert(sizeof(nh_t) <= sizeof(relnix_t));
+	assert(nodehkix < usrnodesz);
+	assert(usrnodesz >= sizeof(char *) + 1);
 		/* so node is at least big enough to hold
 		 * the free list linkage and the housekeeping byte
 		 */
-	assert( nodehkix > sizeof( char * ));
+	assert(nodehkix > sizeof(char *));
 		/* since beginning of each node is used to
 		 * link it in the free list.
 		 */
 
 	/* adjust the user's node size to meet user's alignment constraint
 	*/
-	nodesz = ( usrnodesz + nodealignsz - 1 ) & ~( nodealignsz - 1 );
+	nodesz = (usrnodesz + nodealignsz - 1) & ~(nodealignsz - 1);
 
 	/* Calculate the node table params based on the number of inodes in the
 	 * dump, since that's all we know. Ideally we'd base this on the number
@@ -288,13 +288,13 @@ node_init( int fd,
 	 * reasonable cap on the max number of segments.
 	 */
 
-	assert( NODESPERSEG_MIN >= pgsz );
+	assert(NODESPERSEG_MIN >= pgsz);
 
-	if ( vmsz < WINMAP_MIN * NODESPERSEG_MIN * nodesz ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (vmsz < WINMAP_MIN * NODESPERSEG_MIN * nodesz) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		  "not enough virtual memory for node abstraction: "
 		  "remaining-vsmz=%llu need=%llu\n"),
-		  vmsz, WINMAP_MIN * NODESPERSEG_MIN * nodesz );
+		  vmsz, WINMAP_MIN * NODESPERSEG_MIN * nodesz);
 		return BOOL_FALSE;
 	}
 
@@ -302,53 +302,53 @@ node_init( int fd,
 	 * dirs_nondirs_cnt may be less than the number of nodes/dirents).
 	 * Checking this here prevents potential overflow in the logic below.
 	 */
-	if ( dirs_nondirs_cnt > NH_MAX ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (dirs_nondirs_cnt > NH_MAX) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		  "dump contains %llu inodes, restore can only handle %u\n"),
-		  dirs_nondirs_cnt, NH_MAX );
+		  dirs_nondirs_cnt, NH_MAX);
 		return BOOL_FALSE;
 	}
 
-	for ( winmapmax = 0, segcount = 1; winmapmax < WINMAP_MIN; segcount <<= 1 ) {
+	for (winmapmax = 0, segcount = 1; winmapmax < WINMAP_MIN; segcount <<= 1) {
 
-		nodesperseg = max( dirs_nondirs_cnt / segcount, NODESPERSEG_MIN );
+		nodesperseg = max(dirs_nondirs_cnt / segcount, NODESPERSEG_MIN);
 
 		/* nodesperseg must be a power of 2 */
-		for ( segixshift = 0;
-		      ( 1ULL << segixshift ) < nodesperseg;
-		      segixshift++ );
+		for (segixshift = 0;
+		      (1ULL << segixshift) < nodesperseg;
+		      segixshift++);
 
 		/* rounding up to a power of 2 may have caused overflow */
-		if ( ( 1ULL << segixshift ) > NH_MAX )
+		if ((1ULL << segixshift) > NH_MAX)
 			segixshift--;
 
 		nodesperseg = 1UL << segixshift;
 
-		max_segments = 1UL << ( NBBY * sizeof(nh_t) - segixshift );
+		max_segments = 1UL << (NBBY * sizeof(nh_t) - segixshift);
 
 		segsz = nodesperseg * nodesz;
 
 		/* max number of segments that will fit in virtual memory,
 		 * capped at the max possible number of segments
 		 */
-		winmapmax = min( vmsz / segsz, max_segments );
+		winmapmax = min(vmsz / segsz, max_segments);
 	}
 
 	/* map the abstraction header
 	 */
-	assert( ( NODE_HDRSZ & pgmask ) == 0 );
-	assert( ! ( NODE_HDRSZ % pgsz ));
-	assert( off <= OFF64MAX );
-	assert( ! ( off % ( off64_t )pgsz ));
-	node_hdrp = ( node_hdr_t * )mmap_autogrow(
+	assert((NODE_HDRSZ & pgmask) == 0);
+	assert(! (NODE_HDRSZ % pgsz));
+	assert(off <= OFF64MAX);
+	assert(! (off % (off64_t)pgsz));
+	node_hdrp = (node_hdr_t *)mmap_autogrow(
 					    NODE_HDRSZ,
 					    fd,
-					    off );
-	if ( node_hdrp == (node_hdr_t *)-1 ) {
-	    mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					    off);
+	if (node_hdrp == (node_hdr_t *)-1) {
+	    mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		  "unable to map node hdr of size %d: %s\n"),
 		  NODE_HDRSZ,
-		  strerror( errno ));
+		  strerror(errno));
 	    return BOOL_FALSE;
 	}
 
@@ -361,7 +361,7 @@ node_init( int fd,
 	node_hdrp->nh_nodesperseg = nodesperseg;
 	node_hdrp->nh_nodealignsz = nodealignsz;
 	node_hdrp->nh_freenh = NH_NULL;
-	node_hdrp->nh_firstsegoff = off + ( off64_t )NODE_HDRSZ;
+	node_hdrp->nh_firstsegoff = off + (off64_t)NODE_HDRSZ;
 	node_hdrp->nh_virgnh = 0;
 	node_hdrp->nh_segixshift = segixshift;
 	node_hdrp->nh_relnixmask = nodesperseg - 1;
@@ -372,14 +372,14 @@ node_init( int fd,
 
 	/* initialize the window abstraction
 	 */
-	win_init( fd,
+	win_init(fd,
 		  node_hdrp->nh_firstsegoff,
 		  segsz,
-		  winmapmax );
+		  winmapmax);
 
 	/* announce the results
 	 */
-	mlog( MLOG_DEBUG | MLOG_TREE,
+	mlog(MLOG_DEBUG | MLOG_TREE,
 	      "node_init:"
 	      " vmsz = %llu (0x%llx)"
 	      " segsz = %llu (0x%llx)"
@@ -389,32 +389,32 @@ node_init( int fd,
 	      vmsz, vmsz,
 	      segsz, segsz,
 	      nodesperseg, nodesperseg,
-	      winmapmax, winmapmax );
+	      winmapmax, winmapmax);
 
 	return BOOL_TRUE;
 }
 
 bool_t
-node_sync( int fd, off64_t off )
+node_sync(int fd, off64_t off)
 {
 	/* sanity checks
 	 */
-	assert( sizeof( node_hdr_t ) <= NODE_HDRSZ );
+	assert(sizeof(node_hdr_t) <= NODE_HDRSZ);
 
 	/* map the abstraction header
 	 */
-	assert( ( NODE_HDRSZ & pgmask ) == 0 );
-	assert( off <= ( off64_t )OFF64MAX );
-	assert( ! ( off % ( off64_t )pgsz ));
-	node_hdrp = ( node_hdr_t * )mmap_autogrow(
+	assert((NODE_HDRSZ & pgmask) == 0);
+	assert(off <= (off64_t)OFF64MAX);
+	assert(! (off % (off64_t)pgsz));
+	node_hdrp = (node_hdr_t *)mmap_autogrow(
 					    NODE_HDRSZ,
 					    fd,
-					    off );
-	if ( node_hdrp == (node_hdr_t *)-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					    off);
+	if (node_hdrp == (node_hdr_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to map node hdr of size %d: %s\n"),
 		      NODE_HDRSZ,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -424,16 +424,16 @@ node_sync( int fd, off64_t off )
 
 	/* initialize the window abstraction
 	 */
-	win_init( fd,
+	win_init(fd,
 		  node_hdrp->nh_firstsegoff,
 		  node_hdrp->nh_segsz,
-		  node_hdrp->nh_winmapmax );
+		  node_hdrp->nh_winmapmax);
 
 	return BOOL_TRUE;
 }
 
 nh_t
-node_alloc( void )
+node_alloc(void)
 {
 	u_char_t *p;
 	nh_t nh;
@@ -447,56 +447,56 @@ node_alloc( void )
 	 * otherwise get the next one from the current virgin segment,
 	 * or allocate a new virgin segment if the current one is depleted.
 	 */
-	if ( node_hdrp->nh_freenh != NH_NULL ) {
+	if (node_hdrp->nh_freenh != NH_NULL) {
 		nh_t *linkagep;
 
 		nh = node_hdrp->nh_freenh;
 
-		node_map_internal( nh, ( void ** )&p );
+		node_map_internal(nh, (void **)&p);
 		if (p == NULL)
 			return NH_NULL;
 #ifdef NODECHK
 		hkpp = p + node_hdrp->nh_nodehkix;
-		gen = ( u_char_t )( HKPGETGEN( *p ) + ( u_char_t )1 );
-		unq = HKPGETUNQ( *hkpp );
-		assert( unq != NODEUNQALCD );
-		assert( unq == NODEUNQFREE );
+		gen = (u_char_t)(HKPGETGEN(*p) + (u_char_t)1);
+		unq = HKPGETUNQ(*hkpp);
+		assert(unq != NODEUNQALCD);
+		assert(unq == NODEUNQFREE);
 #endif /* NODECHK */
 
 		/* adjust the free list */
-		linkagep = ( nh_t * )p;
+		linkagep = (nh_t *)p;
 		node_hdrp->nh_freenh = *linkagep;
 
-		node_unmap_internal( nh, ( void ** )&p, BOOL_TRUE );
+		node_unmap_internal(nh, (void **)&p, BOOL_TRUE);
 
 	} else {
-		if ( nh2relnix( node_hdrp->nh_virgnh ) == 0 ) {
+		if (nh2relnix(node_hdrp->nh_virgnh) == 0) {
 			/* need to start a new virgin segment */
 			int rval;
 			off64_t new_seg_off =
 				node_hdrp->nh_firstsegoff +
-				( off64_t )nh2segix( node_hdrp->nh_virgnh ) *
-				( off64_t )node_hdrp->nh_segsz;
+				(off64_t)nh2segix(node_hdrp->nh_virgnh) *
+				(off64_t)node_hdrp->nh_segsz;
 
-			assert( new_seg_off
+			assert(new_seg_off
 				<=
-				OFF64MAX - ( off64_t )node_hdrp->nh_segsz );
-			mlog( MLOG_DEBUG,
+				OFF64MAX - (off64_t)node_hdrp->nh_segsz);
+			mlog(MLOG_DEBUG,
 			      "pre-growing new node array segment at %lld "
 			      "size %lld\n",
 			      new_seg_off,
-			      ( off64_t )node_hdrp->nh_segsz );
-			rval = ftruncate64( node_fd,
+			      (off64_t)node_hdrp->nh_segsz);
+			rval = ftruncate64(node_fd,
 					    new_seg_off
 					    +
-					    ( off64_t )node_hdrp->nh_segsz );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
+					    (off64_t)node_hdrp->nh_segsz);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
 				      "unable to autogrow node segment %u: "
 				      "%s (%d)\n"),
-				      nh2segix( node_hdrp->nh_virgnh ),
-				      strerror( errno ),
-				      errno );
+				      nh2segix(node_hdrp->nh_virgnh),
+				      strerror(errno),
+				      errno);
 			}
 		}
 
@@ -505,28 +505,28 @@ node_alloc( void )
 
 	/* build a handle for node
 	 */
-	if ( nh > NH_MAX ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (nh > NH_MAX) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		  "dump contains too many dirents, "
 		  "restore can only handle %llu\n"),
-		  NH_MAX );
+		  NH_MAX);
 		return NH_NULL;
 	}
 #ifdef NODECHK
-	node_map_internal( nh , ( void ** )&p );
+	node_map_internal(nh , (void **)&p);
 	if (p == NULL)
 		abort();
-	hkpp = p + ( int )node_hdrp->nh_nodehkix;
-	nh = HDLMKHDL( gen, nh );
-	*hkpp = HKPMKHKP( gen, NODEUNQALCD );
-	node_unmap_internal( nh, ( void ** )&p, BOOL_FALSE );
+	hkpp = p + (int)node_hdrp->nh_nodehkix;
+	nh = HDLMKHDL(gen, nh);
+	*hkpp = HKPMKHKP(gen, NODEUNQALCD);
+	node_unmap_internal(nh, (void **)&p, BOOL_FALSE);
 #endif /* NODECHK */
 
 	return nh;
 }
 
 void *
-node_map( nh_t nh )
+node_map(nh_t nh)
 {
 	u_char_t *p;
 #ifdef NODECHK
@@ -536,44 +536,44 @@ node_map( nh_t nh )
 	register u_char_t nodeunq;
 #endif /* NODECHK */
 
-	assert( nh != NH_NULL );
+	assert(nh != NH_NULL);
 
 	/* convert the handle into an index
 	 */
 #ifdef NODECHK
-	hdlgen = HDLGETGEN( nh );
-	nh = HDLGETNHDL( nh );
+	hdlgen = HDLGETGEN(nh);
+	nh = HDLGETNHDL(nh);
 #endif /* NODECHK */
 
-	assert( nh <= NH_MAX );
+	assert(nh <= NH_MAX);
 
 	/* map in
 	 */
 	p = 0; /* keep lint happy */
-	node_map_internal( nh, ( void ** )&p );
+	node_map_internal(nh, (void **)&p);
 	if (p == NULL)
 	    return NULL;
 
 #ifdef NODECHK
-	hkp = *( p + node_hdrp->nh_nodehkix );
-	nodegen = HKPGETGEN( hkp );
-	nodeunq = HKPGETUNQ( hkp );
-	assert( nodegen == hdlgen );
-	assert( nodeunq != NODEUNQFREE );
-	assert( nodeunq == NODEUNQALCD );
+	hkp = *(p + node_hdrp->nh_nodehkix);
+	nodegen = HKPGETGEN(hkp);
+	nodeunq = HKPGETUNQ(hkp);
+	assert(nodegen == hdlgen);
+	assert(nodeunq != NODEUNQFREE);
+	assert(nodeunq == NODEUNQALCD);
 #endif /* NODECHK */
 
-	return ( void * )p;
+	return (void *)p;
 }
 
 void
-node_unmap( nh_t nh, void **pp )
+node_unmap(nh_t nh, void **pp)
 {
-	node_unmap_internal( nh, pp, BOOL_FALSE );
+	node_unmap_internal(nh, pp, BOOL_FALSE);
 }
 
 void
-node_free( nh_t *nhp )
+node_free(nh_t *nhp)
 {
 	nh_t nh;
 	u_char_t *p;
@@ -585,22 +585,22 @@ node_free( nh_t *nhp )
 	register u_char_t nodeunq;
 #endif /* NODECHK */
 
-	assert( nhp );
+	assert(nhp);
 	nh = *nhp;
-	assert( nh != NH_NULL );
+	assert(nh != NH_NULL);
 
 	/* convert the handle into an index
 	 */
 #ifdef NODECHK
-	hdlgen = HDLGETGEN( nh );
-	nh = HDLGETNHDL( nh );
+	hdlgen = HDLGETGEN(nh);
+	nh = HDLGETNHDL(nh);
 #endif /* NODECHK */
 
-	assert( nh <= NH_MAX );
+	assert(nh <= NH_MAX);
 
 	/* map in
 	 */
-	p = ( u_char_t * )node_map( nh );
+	p = (u_char_t *)node_map(nh);
 	if (p == NULL){
 	    *nhp = NH_NULL;
 	    return;
@@ -610,23 +610,23 @@ node_free( nh_t *nhp )
 	/* fix up unique field
 	 */
 	hkpp = p + node_hdrp->nh_nodehkix;
-	nodegen = HKPGETGEN( *hkpp );
-	nodeunq = HKPGETUNQ( *hkpp );
-	assert( nodegen == hdlgen );
-	assert( nodeunq != NODEUNQFREE );
-	assert( nodeunq == NODEUNQALCD );
-	*hkpp = HKPMKHKP( nodegen, NODEUNQFREE );
+	nodegen = HKPGETGEN(*hkpp);
+	nodeunq = HKPGETUNQ(*hkpp);
+	assert(nodegen == hdlgen);
+	assert(nodeunq != NODEUNQFREE);
+	assert(nodeunq == NODEUNQALCD);
+	*hkpp = HKPMKHKP(nodegen, NODEUNQFREE);
 #endif /* NODECHK */
 
 	/* put node on free list
 	 */
-	linkagep = ( nh_t * )p;
+	linkagep = (nh_t *)p;
 	*linkagep = node_hdrp->nh_freenh;
 	node_hdrp->nh_freenh = nh;
 
 	/* map out
 	 */
-	node_unmap_internal( nh, ( void ** )&p, BOOL_TRUE );
+	node_unmap_internal(nh, (void **)&p, BOOL_TRUE);
 
 	/* invalidate caller's handle
 	 */
diff --git a/restore/node.h b/restore/node.h
index 25fdaad..5b5efda 100644
--- a/restore/node.h
+++ b/restore/node.h
@@ -29,7 +29,7 @@ typedef size32_t nh_t;
 /* node_init - creates a new node abstraction.
  * user reserves one byte per node for use by the node abstraction
  */
-extern bool_t node_init( int fd,		/* backing store */
+extern bool_t node_init(int fd,		/* backing store */
 		         off64_t off,		/* offset into backing store */
 		         size_t nodesz,		/* node size */
 		         ix_t nodehkix,		/* my housekeeping byte */
@@ -39,26 +39,26 @@ extern bool_t node_init( int fd,		/* backing store */
 
 /* node_sync - syncs up with existing node abstraction persistent state
  */
-extern bool_t node_sync( int fd, off64_t off );
+extern bool_t node_sync(int fd, off64_t off);
 
 /* node_alloc - allocates a node, returning a handle.
  * returns NULL handle if no space left.
  */
-extern nh_t node_alloc( void );
+extern nh_t node_alloc(void);
 
 /* node_map - returns a pointer to the node identified by the node handle.
  * pointer remains valid until node_unmap called.
  */
-extern void *node_map( nh_t node_handle );
+extern void *node_map(nh_t node_handle);
 
 /* node_unmap - unmaps the node.
  * SIDE-EFFECT: sets *nodepp to 0.
  */
-extern void node_unmap( nh_t node_handle, void **nodepp );
+extern void node_unmap(nh_t node_handle, void **nodepp);
 
 /* node_free - frees a previously allocated node.
  * SIDE-EFFECT: sets *node_handlep to NODE_HANDLE_NULL.
  */
-extern void node_free( nh_t *node_handlep );
+extern void node_free(nh_t *node_handlep);
 
 #endif /* NODE_H */
-- 
2.19.1
