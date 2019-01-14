Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfANR0I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:08 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E9BA880F6B
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:06 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 07/13] xfsdump: (7/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:22 +0100
Message-Id: <20190114172528.65250-8-jtulak@redhat.com>
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
 dump/content.c | 1612 ++++++++++++++++++++++++------------------------
 1 file changed, 806 insertions(+), 806 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 4e4566a..43f51db 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -3824,11 +3824,11 @@ dump_file(void *arg1,
 
 	if (hsm_fs_ctxtp) {
 		if (HsmInitFileContext(contextp->cc_hsm_f_ctxtp, statp)) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "inomap inconsistency ino %llu: "
 			      "hsm detected error: NOT dumping\n"),
 			      statp->bs_ino);
-			if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+			if (statp->bs_ino > contextp->cc_stat_lastino) {
 				contextp->cc_stat_lastino = statp->bs_ino;
 			}
 			return RV_OK;
@@ -3837,7 +3837,7 @@ dump_file(void *arg1,
 
 	/* pass on to specific dump function
 	 */
-	switch( statp->bs_mode & S_IFMT ) {
+	switch(statp->bs_mode & S_IFMT) {
 	case S_IFREG:
 		/* ordinary file
 		 */
@@ -3847,7 +3847,7 @@ dump_file(void *arg1,
 		 */
 		if (maxdumpfilesize) {
 			off64_t estimated_size = statp->bs_blocks *
-						 ( off64_t )statp->bs_blksize;
+						 (off64_t)statp->bs_blksize;
 
 			if (hsm_fs_ctxtp) {
 				HsmEstimateFileSpace(hsm_fs_ctxtp,
@@ -3860,23 +3860,23 @@ dump_file(void *arg1,
 			/* quota files are exempt from max size check */
 			if (estimated_size > maxdumpfilesize &&
 			    !is_quota_file(statp->bs_ino)) {
-				mlog( MLOG_DEBUG | MLOG_NOTE,
+				mlog(MLOG_DEBUG | MLOG_NOTE,
 				      "ino %llu increased beyond maximum size: "
 				      "NOT dumping\n",
 				      statp->bs_ino);
 				return RV_OK;
 			}
 		}
-		rv = dump_file_reg( drivep,
+		rv = dump_file_reg(drivep,
 				    contextp,
 				    scwhdrp,
 				    fshandlep,
 				    statp,
-				    &file_skipped );
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
-			lock( );
+				    &file_skipped);
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
+			lock();
 			sc_stat_nondirdone++;
-			unlock( );
+			unlock();
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		break; /* drop out of switch to extattr dump */
@@ -3890,11 +3890,11 @@ dump_file(void *arg1,
 	case S_IFSOCK:
 		/* only need a filehdr_t; no data
 		 */
-		rv = dump_file_spec( drivep, contextp, fshandlep, statp );
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
-			lock( );
+		rv = dump_file_spec(drivep, contextp, fshandlep, statp);
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
+			lock();
 			sc_stat_nondirdone++;
-			unlock( );
+			unlock();
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		break; /* drop out of switch to extattr dump */
@@ -3902,14 +3902,14 @@ dump_file(void *arg1,
 	default:
 		/* don't know how to dump these
 		 */
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "don't know how to dump ino %llu: mode %08x\n"),
 		      statp->bs_ino,
-		      statp->bs_mode );
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
-			lock( );
+		      statp->bs_mode);
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
+			lock();
 			sc_stat_nondirdone++;
-			unlock( );
+			unlock();
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		return RV_OK;
@@ -3918,14 +3918,14 @@ dump_file(void *arg1,
 	 */
 	}
 
-	if ( rv == RV_OK
+	if (rv == RV_OK
 	     &&
 	     file_skipped == BOOL_FALSE
 	     &&
 	     sc_dumpextattrpr
 	     &&
-	     ( statp->bs_xflags & XFS_XFLAG_HASATTR )) {
-		rv = dump_extattrs( drivep, contextp, fshandlep, statp);
+	     (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
+		rv = dump_extattrs(drivep, contextp, fshandlep, statp);
 	}
 
 	return rv;
@@ -3938,12 +3938,12 @@ dump_file(void *arg1,
  * operator requested stop.
  */
 static rv_t
-dump_file_reg( drive_t *drivep,
+dump_file_reg(drive_t *drivep,
 	       context_t *contextp,
 	       content_inode_hdr_t *scwhdrp,
 	       jdm_fshandle_t *fshandlep,
 	       xfs_bstat_t *statp,
-	       bool_t *file_skippedp )
+	       bool_t *file_skippedp)
 {
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
@@ -3959,9 +3959,9 @@ dump_file_reg( drive_t *drivep,
 	 * it must have been aligned to the basic fs block size by the
 	 * startpoint calculations done during strategy initialization.
 	 */
-	if ( statp->bs_ino == startptp->sp_ino ) {
+	if (statp->bs_ino == startptp->sp_ino) {
 		offset = startptp->sp_offset;
-		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
+		assert((offset & (off64_t)(BBSIZE - 1)) == 0);
 	} else {
 		offset = 0;
 	}
@@ -3971,35 +3971,35 @@ dump_file_reg( drive_t *drivep,
 	 * above, and that file hasn't changed since the resumed dump,
 	 * modify offset.
 	 */
-	if ( sc_resumepr ) {
+	if (sc_resumepr) {
 		drange_t *drangep = sc_resumerangep;
 		size_t drangecnt = sc_resumerangecnt;
 		size_t drangeix;
 
-		for ( drangeix = 0 ; drangeix < drangecnt ; drangeix++ ) {
-			drange_t *rp = &drangep[ drangeix ];
-			if ( statp->bs_ino == rp->dr_begin.sp_ino ) {
+		for (drangeix = 0 ; drangeix < drangecnt ; drangeix++) {
+			drange_t *rp = &drangep[drangeix];
+			if (statp->bs_ino == rp->dr_begin.sp_ino) {
 				register time32_t mtime = statp->bs_mtime.tv_sec;
 				register time32_t ctime = statp->bs_ctime.tv_sec;
-				register time32_t ltime = max( mtime, ctime );
-				if ( ltime < sc_resumebasetime ) {
-					if ( rp->dr_begin.sp_offset > offset ){
+				register time32_t ltime = max(mtime, ctime);
+				if (ltime < sc_resumebasetime) {
+					if (rp->dr_begin.sp_offset > offset){
 						offset =rp->dr_begin.sp_offset;
 					}
 				}
 				break;
 			}
 		}
-		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
+		assert((offset & (off64_t)(BBSIZE - 1)) == 0);
 	}
 
 	/* determine the offset within the file where the dump should end.
 	 * only significant if this is an inode spanning a startpoint.
 	 */
-	if ( endptp->sp_flags & STARTPT_FLAGS_END ) {
+	if (endptp->sp_flags & STARTPT_FLAGS_END) {
 		sosig = BOOL_FALSE;
 		stopoffset = 0;
-	} else if ( statp->bs_ino == endptp->sp_ino ) {
+	} else if (statp->bs_ino == endptp->sp_ino) {
 		sosig = BOOL_TRUE;
 		stopoffset = endptp->sp_offset;
 	} else {
@@ -4007,7 +4007,7 @@ dump_file_reg( drive_t *drivep,
 		stopoffset = 0;
 	}
 
-	mlog( MLOG_TRACE,
+	mlog(MLOG_TRACE,
 	      "dumping regular file ino %llu "
 	      "offset %lld "
 	      "to offset %lld "
@@ -4015,7 +4015,7 @@ dump_file_reg( drive_t *drivep,
 	      statp->bs_ino,
 	      offset,
 	      sosig ? stopoffset : statp->bs_size,
-	      statp->bs_size );
+	      statp->bs_size);
 
 	/* calculate the maximum extent group size. files larger than this
 	 * will be broken into multiple extent groups, each with its own
@@ -4026,16 +4026,16 @@ dump_file_reg( drive_t *drivep,
 	/* initialize the extent group context. if fails, just return,
 	 * pretending the dump succeeded.
 	 */
-	rv = init_extent_group_context( fshandlep,
+	rv = init_extent_group_context(fshandlep,
 					statp,
-					&extent_group_context );
-	if ( rv != RV_OK ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					&extent_group_context);
+	if (rv != RV_OK) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "could not open regular file ino %llu mode 0x%08x: "
 		      "%s: not dumped\n"),
 		      statp->bs_ino,
 		      statp->bs_mode,
-		      strerror( errno ));
+		      strerror(errno));
 		*file_skippedp = BOOL_TRUE;
 		return RV_OK;
 	}
@@ -4051,14 +4051,14 @@ dump_file_reg( drive_t *drivep,
 	cmpltflg = BOOL_FALSE;
 
 	rv = RV_OK;
-	for ( ; ; ) {
+	for (; ;) {
 		off64_t bytecnt = 0;
 		off64_t bc;
 
 		/* see if we are done.
 		 */
-		if ( cmpltflg ) {
-			assert( rv == RV_OK );
+		if (cmpltflg) {
+			assert(rv == RV_OK);
 			break;
 		}
 
@@ -4067,23 +4067,23 @@ dump_file_reg( drive_t *drivep,
 		 * interrupt the dump. this mark, if committed, indicates
 		 * the previous fs file / extent group was completely dumped.
 		 */
-		mark_set( drivep, statp->bs_ino, offset, 0 );
+		mark_set(drivep, statp->bs_ino, offset, 0);
 
 		/* spoof EOF if the media file size is getting too big.
 		 * note that the most we can go over is d_recmarksep.
 		 */
-		if ( contextp->cc_mfilesz >= drivep->d_recmfilesz ){
+		if (contextp->cc_mfilesz >= drivep->d_recmfilesz){
 			rv = RV_EOF;
 			break;
 		}
 
 		/* check if the operator has requested to interrupt the dump.
 		 */
-		if ( cldmgr_stop_requested( )) {
-			mlog( MLOG_NORMAL, _(
+		if (cldmgr_stop_requested()) {
+			mlog(MLOG_NORMAL, _(
 			      "dump interrupted prior to ino %llu offset %lld\n"),
 			      statp->bs_ino,
-			      offset );
+			      offset);
 			mlog_exit_hint(RV_INTR);
 			rv = RV_INTR;
 			break;
@@ -4091,15 +4091,15 @@ dump_file_reg( drive_t *drivep,
 
 		/* dump the file header
 		 */
-		mlog( MLOG_DEBUG,
+		mlog(MLOG_DEBUG,
 		      "dumping extent group ino %llu offset %lld\n",
 		      statp->bs_ino,
-		      offset );
-		rv = dump_filehdr( drivep, contextp, statp, offset, 0 );
-		if ( rv != RV_OK ) {
+		      offset);
+		rv = dump_filehdr(drivep, contextp, statp, offset, 0);
+		if (rv != RV_OK) {
 			break;
 		}
-		bytecnt += sizeof( filehdr_t );
+		bytecnt += sizeof(filehdr_t);
 
 		/* dump a group of extents. returns by reference
 		 * the offset of the next extent group (to be placed
@@ -4108,7 +4108,7 @@ dump_file_reg( drive_t *drivep,
 		 * all extents have been dumped.
 		 */
 		bc = 0; /* for lint */
-		rv = dump_extent_group( drivep,
+		rv = dump_extent_group(drivep,
 					contextp,
 					statp,
 					&extent_group_context,
@@ -4117,33 +4117,33 @@ dump_file_reg( drive_t *drivep,
 					sosig,
 					&offset,
 					&bc,
-					&cmpltflg );
-		assert( bc >= 0 );
+					&cmpltflg);
+		assert(bc >= 0);
 		bytecnt += bc;
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			break;
 		}
 
 		/* update global stat
 		 */
-		lock( );
-		sc_stat_datadone += ( size64_t )bc;
-		unlock( );
+		lock();
+		sc_stat_datadone += (size64_t)bc;
+		unlock();
 
 		/* dump LAST extent hdr. one of these is placed at the
 		 * end of each dumped file. necessary to detect the
 		 * end of the file.
 		 */
-		rv = dump_extenthdr( drivep,
+		rv = dump_extenthdr(drivep,
 				     contextp,
 				     EXTENTHDR_TYPE_LAST,
 				     0,
 				     0,
-				     0 );
-		if ( rv != RV_OK ) {
+				     0);
+		if (rv != RV_OK) {
 			break;
 		}
-		bytecnt += sizeof( extenthdr_t );
+		bytecnt += sizeof(extenthdr_t);
 
 		/* update the media file size
 		 */
@@ -4151,7 +4151,7 @@ dump_file_reg( drive_t *drivep,
 
 	}
 
-	cleanup_extent_group_context( &extent_group_context );
+	cleanup_extent_group_context(&extent_group_context);
 	return rv;
 }
 
@@ -4160,42 +4160,42 @@ dump_file_reg( drive_t *drivep,
  * appends a variable-length string after the filehdr_t.
  */
 static rv_t
-dump_file_spec( drive_t *drivep,
+dump_file_spec(drive_t *drivep,
 		context_t *contextp,
 		jdm_fshandle_t *fshandlep,
-		xfs_bstat_t *statp )
+		xfs_bstat_t *statp)
 {
 	int rval;
 	rv_t rv;
 
-	mlog( MLOG_TRACE,
+	mlog(MLOG_TRACE,
 	      "dumping special file ino %llu mode 0x%04x\n",
 	      statp->bs_ino,
-	      statp->bs_mode );
+	      statp->bs_mode);
 
 	/* set a mark - important to do this now, before deciding
 	 * the media file is to big. this mark, if committed,
 	 * indicates the previous fs file was completely dumped.
 	 */
-	mark_set( drivep, statp->bs_ino, 0, 0 );
+	mark_set(drivep, statp->bs_ino, 0, 0);
 
 	/* dump the file header
 	 */
-	rv = dump_filehdr( drivep, contextp, statp, 0, 0 );
-	if ( rv != RV_OK ) {
+	rv = dump_filehdr(drivep, contextp, statp, 0, 0);
+	if (rv != RV_OK) {
 		return rv;
 	}
 
 	/* update the media file size
 	 */
-	contextp->cc_mfilesz += sizeof( filehdr_t );
+	contextp->cc_mfilesz += sizeof(filehdr_t);
 
 	/* if a symbolic link, also dump the link pathname.
 	 * use an extent header to represent the pathname. the
 	 * extent sz will always be a multiple of SYMLINK_ALIGN.
 	 * the symlink pathname char string will always  be NULL-terminated.
 	 */
-	if ( ( statp->bs_mode & S_IFMT ) == S_IFLNK ) {
+	if ((statp->bs_mode & S_IFMT) == S_IFLNK) {
 		int nread;
 		size_t extentsz;
 
@@ -4204,50 +4204,50 @@ dump_file_spec( drive_t *drivep,
 		 * bytes to dump, and contextp->cc_direntbufp will contain
 		 * the bytes.
 		 */
-		nread = jdm_readlink( fshandlep,
+		nread = jdm_readlink(fshandlep,
 				      statp,
 				      contextp->cc_readlinkbufp,
-				      contextp->cc_readlinkbufsz );
-		if ( nread < 0 ) {
-			mlog( MLOG_DEBUG,
+				      contextp->cc_readlinkbufsz);
+		if (nread < 0) {
+			mlog(MLOG_DEBUG,
 			      "could not read symlink ino %llu\n",
-			      statp->bs_ino );
+			      statp->bs_ino);
 			nread = 0;
 		}
 
 		/* null-terminate the string
 		 */
-		assert( ( size_t )nread < contextp->cc_readlinkbufsz );
-		contextp->cc_readlinkbufp[ nread ] = 0;
+		assert((size_t)nread < contextp->cc_readlinkbufsz);
+		contextp->cc_readlinkbufp[nread] = 0;
 
 		/* calculate the extent size - be sure to include room
 		 * for the null-termination.
 		 */
-		extentsz = ( ( size_t )nread + 1 + ( SYMLINK_ALIGN - 1 ))
+		extentsz = ((size_t)nread + 1 + (SYMLINK_ALIGN - 1))
 			   &
-			   ~ ( SYMLINK_ALIGN - 1 );
-		assert( extentsz <= contextp->cc_readlinkbufsz );
+			   ~ (SYMLINK_ALIGN - 1);
+		assert(extentsz <= contextp->cc_readlinkbufsz);
 
 		/* dump an extent header
 		 */
-		rv = dump_extenthdr( drivep,
+		rv = dump_extenthdr(drivep,
 				     contextp,
 				     EXTENTHDR_TYPE_DATA,
 				     0,
 				     0,
-				     ( off64_t )extentsz );
-		if ( rv != RV_OK ) {
+				     (off64_t)extentsz);
+		if (rv != RV_OK) {
 			return rv;
 		}
 
 		/* dump the link path extent
 		 */
-		rval = write_buf( contextp->cc_readlinkbufp,
+		rval = write_buf(contextp->cc_readlinkbufp,
 				  extentsz,
-				  ( void * )drivep,
-				  ( gwbfp_t )drivep->d_opsp->do_get_write_buf,
-				  ( wfp_t )drivep->d_opsp->do_write );
-		switch ( rval ) {
+				  (void *)drivep,
+				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+				  (wfp_t)drivep->d_opsp->do_write);
+		switch (rval) {
 		case 0:
 			rv = RV_OK;
 			break;
@@ -4263,7 +4263,7 @@ dump_file_spec( drive_t *drivep,
 			rv = RV_CORE;
 			break;
 		}
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			return rv;
 		}
 	}
@@ -4276,30 +4276,30 @@ dump_file_spec( drive_t *drivep,
  * does anything else.
  */
 static rv_t
-init_extent_group_context( jdm_fshandle_t *fshandlep,
+init_extent_group_context(jdm_fshandle_t *fshandlep,
 			   xfs_bstat_t *statp,
-			   extent_group_context_t *gcp )
+			   extent_group_context_t *gcp)
 {
 	bool_t isrealtime;
 	int oflags;
 	struct flock fl;
 
-	isrealtime = ( bool_t )(statp->bs_xflags & XFS_XFLAG_REALTIME );
+	isrealtime = (bool_t)(statp->bs_xflags & XFS_XFLAG_REALTIME);
 	oflags = O_RDONLY;
-	if ( isrealtime ) {
+	if (isrealtime) {
 		oflags |= O_DIRECT;
 	}
-	( void )memset( ( void * )gcp, 0, sizeof( *gcp ));
-	gcp->eg_bmap[ 0 ].bmv_offset = 0;
-	gcp->eg_bmap[ 0 ].bmv_length = -1;
-	gcp->eg_bmap[ 0 ].bmv_count = BMAP_LEN;
-	gcp->eg_bmap[ 0 ].bmv_iflags = BMV_IF_NO_DMAPI_READ;
-	gcp->eg_nextbmapp = &gcp->eg_bmap[ 1 ];
-	gcp->eg_endbmapp = &gcp->eg_bmap[ 1 ];
+	(void)memset((void *)gcp, 0, sizeof(*gcp));
+	gcp->eg_bmap[0].bmv_offset = 0;
+	gcp->eg_bmap[0].bmv_length = -1;
+	gcp->eg_bmap[0].bmv_count = BMAP_LEN;
+	gcp->eg_bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
+	gcp->eg_nextbmapp = &gcp->eg_bmap[1];
+	gcp->eg_endbmapp = &gcp->eg_bmap[1];
 	gcp->eg_bmapix = 0;
 	gcp->eg_gbmcnt = 0;
-	gcp->eg_fd = jdm_open( fshandlep, statp, oflags );
-	if ( gcp->eg_fd < 0 ) {
+	gcp->eg_fd = jdm_open(fshandlep, statp, oflags);
+	if (gcp->eg_fd < 0) {
 		return RV_ERROR;
 	}
 
@@ -4309,15 +4309,15 @@ init_extent_group_context( jdm_fshandle_t *fshandlep,
 	 * after this check but before all reads have completed.
 	 * This change just closes the window a bit.
 	 */
-	if ( (statp->bs_mode & S_ISGID) && ( ! (statp->bs_mode&S_IXOTH) ) ) {
+	if ((statp->bs_mode & S_ISGID) && (! (statp->bs_mode&S_IXOTH))) {
 		fl.l_type = F_RDLCK;
 		fl.l_whence = SEEK_SET;
 		fl.l_start = (off_t)0;
 		fl.l_len = 0;
-		if ((fcntl(gcp->eg_fd, F_GETLK, &fl)) < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		if ((fcntl(gcp->eg_fd, F_GETLK, &fl)) < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "locking check failed ino %llu\n"),
-			      statp->bs_ino );
+			      statp->bs_ino);
 			close(gcp->eg_fd);
 			return RV_ERROR;
 		}
@@ -4332,13 +4332,13 @@ init_extent_group_context( jdm_fshandle_t *fshandlep,
 }
 
 static void
-cleanup_extent_group_context( extent_group_context_t *gcp )
+cleanup_extent_group_context(extent_group_context_t *gcp)
 {
-	( void )close( gcp->eg_fd );
+	(void)close(gcp->eg_fd);
 }
 
 static rv_t
-dump_extent_group( drive_t *drivep,
+dump_extent_group(drive_t *drivep,
 		   context_t *contextp,
 		   xfs_bstat_t *statp,
 		   extent_group_context_t *gcp,
@@ -4347,13 +4347,13 @@ dump_extent_group( drive_t *drivep,
 		   bool_t sosig,
 		   off64_t *nextoffsetp,
 		   off64_t *bytecntp,
-		   bool_t *cmpltflgp )
+		   bool_t *cmpltflgp)
 {
 	struct dioattr da;
 	drive_ops_t *dop = drivep->d_opsp;
-	bool_t isrealtime = ( bool_t )( statp->bs_xflags
+	bool_t isrealtime = (bool_t)(statp->bs_xflags
 					&
-					XFS_XFLAG_REALTIME );
+					XFS_XFLAG_REALTIME);
 	off64_t nextoffset;
 	off64_t bytecnt;	/* accumulates total bytes sent to media */
 	int rval;
@@ -4362,11 +4362,11 @@ dump_extent_group( drive_t *drivep,
 	/*
 	 * Setup realtime I/O size.
 	 */
-	if ( isrealtime ) {
-		if ( (ioctl(gcp->eg_fd, XFS_IOC_DIOINFO, &da) < 0) ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (isrealtime) {
+		if ((ioctl(gcp->eg_fd, XFS_IOC_DIOINFO, &da) < 0)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "dioinfo failed ino %llu\n"),
-			      statp->bs_ino );
+			      statp->bs_ino);
 			da.d_miniosz = PGSZ;
 		}
 	}
@@ -4375,17 +4375,17 @@ dump_extent_group( drive_t *drivep,
 	 */
 	nextoffset = *nextoffsetp;
 	bytecnt = 0;
-	assert( ( nextoffset & ( BBSIZE - 1 )) == 0 );
+	assert((nextoffset & (BBSIZE - 1)) == 0);
 
-	for ( ; ; ) {
+	for (; ;) {
 		off64_t offset;
 		off64_t extsz;
 
 		/* if we've dumped to the stop point return.
 		 */
-		if ( sosig && nextoffset >= stopoffset ) {
-			mlog( MLOG_NITTY,
-			      "dumped to stop offset\n" );
+		if (sosig && nextoffset >= stopoffset) {
+			mlog(MLOG_NITTY,
+			      "dumped to stop offset\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4394,9 +4394,9 @@ dump_extent_group( drive_t *drivep,
 
 		/* if we've dumped the entire file, return
 		 */
-		if ( nextoffset >= statp->bs_size ) {
-			mlog( MLOG_NITTY,
-			      "dumped to end of file\n" );
+		if (nextoffset >= statp->bs_size) {
+			mlog(MLOG_NITTY,
+			      "dumped to end of file\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4407,9 +4407,9 @@ dump_extent_group( drive_t *drivep,
 		 * call it quits. we'll be called back for more because the
 		 * completion flag is set FALSE.
 		 */
-		if ( bytecnt >= maxcnt ) {
-			mlog( MLOG_NITTY,
-			      "reached per-extent group byte count\n" );
+		if (bytecnt >= maxcnt) {
+			mlog(MLOG_NITTY,
+			      "reached per-extent group byte count\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_FALSE;
@@ -4419,21 +4419,21 @@ dump_extent_group( drive_t *drivep,
 		/* if we are not looking at a valid bmap entry,
 		 * get one.
 		 */
-		if ( gcp->eg_nextbmapp >= gcp->eg_endbmapp ) {
+		if (gcp->eg_nextbmapp >= gcp->eg_endbmapp) {
 			int entrycnt; /* entries in new bmap */
 
-			assert( gcp->eg_nextbmapp == gcp->eg_endbmapp );
+			assert(gcp->eg_nextbmapp == gcp->eg_endbmapp);
 
 			/* get a new extent block
 			 */
-			mlog( MLOG_NITTY,
+			mlog(MLOG_NITTY,
 			      "calling getbmapx for ino %llu\n",
-			      statp->bs_ino );
-			rval = ioctl( gcp->eg_fd, XFS_IOC_GETBMAPX, gcp->eg_bmap );
+			      statp->bs_ino);
+			rval = ioctl(gcp->eg_fd, XFS_IOC_GETBMAPX, gcp->eg_bmap);
 			gcp->eg_gbmcnt++;
-			entrycnt = gcp->eg_bmap[ 0 ].bmv_entries;
-			if ( entrycnt < 0 ) { /* workaround for getbmap bug */
-				mlog( MLOG_DEBUG | MLOG_WARNING, _(
+			entrycnt = gcp->eg_bmap[0].bmv_entries;
+			if (entrycnt < 0) { /* workaround for getbmap bug */
+				mlog(MLOG_DEBUG | MLOG_WARNING, _(
 				      "getbmapx %d ino %lld mode 0x%08x "
 				      "offset %lld ix %d "
 				      "returns negative entry count\n"),
@@ -4441,21 +4441,21 @@ dump_extent_group( drive_t *drivep,
 				      statp->bs_ino,
 				      statp->bs_mode,
 				      nextoffset,
-				      gcp->eg_bmapix );
+				      gcp->eg_bmapix);
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
 				return RV_OK;
 			}
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "getbmapx %d ino %lld mode 0x%08x "
 				      "offset %lld failed: %s\n"),
 				      gcp->eg_gbmcnt,
 				      statp->bs_ino,
 				      statp->bs_mode,
 				      nextoffset,
-				      strerror( errno ));
+				      strerror(errno));
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
@@ -4470,7 +4470,7 @@ dump_extent_group( drive_t *drivep,
 			if (hsm_fs_ctxtp) {
 				if (!HsmModifyExtentMap(contextp->cc_hsm_f_ctxtp,
 					&gcp->eg_bmap[0])) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 						"hsm detected an extent map "
 						"error in ino %lld, skipping\n"),
 						statp->bs_ino);
@@ -4479,74 +4479,74 @@ dump_extent_group( drive_t *drivep,
 					*cmpltflgp = BOOL_TRUE;
 					return RV_OK;
 				}
-				entrycnt = gcp->eg_bmap[ 0 ].bmv_entries;
+				entrycnt = gcp->eg_bmap[0].bmv_entries;
 			}
 
-			if ( entrycnt <= 0 ) {
-				mlog( MLOG_NITTY,
-				      "all extent groups dumped\n" );
+			if (entrycnt <= 0) {
+				mlog(MLOG_NITTY,
+				      "all extent groups dumped\n");
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
 				return RV_OK;
 			}
-			gcp->eg_nextbmapp = &gcp->eg_bmap[ 1 ];
-			gcp->eg_endbmapp = &gcp->eg_bmap[ entrycnt + 1 ];
-			mlog( MLOG_NITTY,
+			gcp->eg_nextbmapp = &gcp->eg_bmap[1];
+			gcp->eg_endbmapp = &gcp->eg_bmap[entrycnt + 1];
+			mlog(MLOG_NITTY,
 			      "getbmapx supplied %d extent entries\n",
-			      entrycnt );
+			      entrycnt);
 		}
 
-		mlog( MLOG_NITTY,
+		mlog(MLOG_NITTY,
 		      "bmap entry %d ix %d block %lld offset %lld length %lld\n",
-		      gcp->eg_nextbmapp - &gcp->eg_bmap[ 0 ],
+		      gcp->eg_nextbmapp - &gcp->eg_bmap[0],
 		      gcp->eg_bmapix,
 		      gcp->eg_nextbmapp->bmv_block,
 		      gcp->eg_nextbmapp->bmv_offset,
-		      gcp->eg_nextbmapp->bmv_length );
+		      gcp->eg_nextbmapp->bmv_length);
 
 		/* if the next bmap entry represents a hole, go to the next
 		 * one in the bmap, and rescan to check above assumptions.
 		 * bump nextoffset to after the hole, if beyond current value.
 		 */
-		if ( gcp->eg_nextbmapp->bmv_block == -1 ) {
+		if (gcp->eg_nextbmapp->bmv_block == -1) {
 			off64_t tmpoffset;
 
 			/* extract the offset and extent size from this
 			 * entry
 			 */
 			offset = gcp->eg_nextbmapp->bmv_offset
-					* ( off64_t )BBSIZE;
+					* (off64_t)BBSIZE;
 			extsz  = gcp->eg_nextbmapp->bmv_length
-					* ( off64_t )BBSIZE;
+					* (off64_t)BBSIZE;
 
-			mlog( MLOG_NITTY,
+			mlog(MLOG_NITTY,
 			      "hole extent offset = %lld size = %lld\n",
-			      offset, extsz );
+			      offset, extsz);
 
 			/* Encode the hole - dump the extent header
 			 * with the right extent type.
 			 */
-			rv = dump_extenthdr( drivep,
+			rv = dump_extenthdr(drivep,
 					     contextp,
 					     EXTENTHDR_TYPE_HOLE,
 					     0,
 					     offset,
-					     extsz );
-			if ( rv != RV_OK ) {
+					     extsz);
+			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE; /*moot since rv != OK */
 				return rv;
 			}
-			bytecnt += sizeof( extenthdr_t );
+			bytecnt += sizeof(extenthdr_t);
 
-			tmpoffset = ( gcp->eg_nextbmapp->bmv_offset
+			tmpoffset = (gcp->eg_nextbmapp->bmv_offset
 				      +
-				      gcp->eg_nextbmapp->bmv_length )
+				      gcp->eg_nextbmapp->bmv_length)
 				    *
-				    ( off64_t )BBSIZE;
-			if ( tmpoffset > nextoffset ) {
+				    (off64_t)BBSIZE;
+			if (tmpoffset > nextoffset) {
 				nextoffset = tmpoffset;
 			}
 			gcp->eg_nextbmapp++;
@@ -4557,15 +4557,15 @@ dump_extent_group( drive_t *drivep,
 		/* if the next bmap entry has a zero size, go to the next
 		 * one in the bmap, and rescan to check above assumptions.
 		 */
-		if ( gcp->eg_nextbmapp->bmv_length <= 0 ) {
+		if (gcp->eg_nextbmapp->bmv_length <= 0) {
 			off64_t tmpoffset;
 
-			mlog( MLOG_NITTY,
-			      "non-positive extent\n" );
+			mlog(MLOG_NITTY,
+			      "non-positive extent\n");
 			tmpoffset = gcp->eg_nextbmapp->bmv_offset
 				    *
-				    ( off64_t )BBSIZE;
-			if ( tmpoffset > nextoffset ) {
+				    (off64_t)BBSIZE;
+			if (tmpoffset > nextoffset) {
 				nextoffset = tmpoffset;
 			}
 			gcp->eg_nextbmapp++;
@@ -4576,22 +4576,22 @@ dump_extent_group( drive_t *drivep,
 		/* extract the offset and extent size from this
 		 * entry
 		 */
-		offset = gcp->eg_nextbmapp->bmv_offset * ( off64_t )BBSIZE;
-		extsz = gcp->eg_nextbmapp->bmv_length * ( off64_t )BBSIZE;
-		mlog( MLOG_NITTY,
+		offset = gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE;
+		extsz = gcp->eg_nextbmapp->bmv_length * (off64_t)BBSIZE;
+		mlog(MLOG_NITTY,
 		      "extent offset %lld sz %lld; nextoffset %lld\n",
 		      offset,
 		      extsz,
-		      nextoffset );
+		      nextoffset);
 
 		/* if the new bmap entry begins below the stop offset
 		 * but does not contain any data above the current
 		 * offset, go to the next one and rescan.
 		 */
-		if ( ! sosig || offset < stopoffset ) {
-			if ( offset + extsz <= nextoffset ) {
-				mlog( MLOG_NITTY,
-				      "extent ends before nextoffset\n" );
+		if (! sosig || offset < stopoffset) {
+			if (offset + extsz <= nextoffset) {
+				mlog(MLOG_NITTY,
+				      "extent ends before nextoffset\n");
 				gcp->eg_nextbmapp++;
 				gcp->eg_bmapix++;
 				continue;
@@ -4601,9 +4601,9 @@ dump_extent_group( drive_t *drivep,
 		/* if the new bmap entry begins beyond the end of the file,
 		 * we are done.
 		 */
-		if ( offset >= statp->bs_size ) {
-			mlog( MLOG_NITTY,
-			      "extent beyond end of file\n" );
+		if (offset >= statp->bs_size) {
+			mlog(MLOG_NITTY,
+			      "extent beyond end of file\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4613,9 +4613,9 @@ dump_extent_group( drive_t *drivep,
 		/* if the new bmap entry begins at or above the stop offset,
 		 * stop. we are done.
 		 */
-		if ( sosig && offset >= stopoffset ) {
-			mlog( MLOG_NITTY,
-			      "extent beyond stop offset\n" );
+		if (sosig && offset >= stopoffset) {
+			mlog(MLOG_NITTY,
+			      "extent beyond stop offset\n");
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE;
@@ -4627,41 +4627,41 @@ dump_extent_group( drive_t *drivep,
 		 * beginning of the range of interest, and shorten
 		 * extsz accordingly.
 		 */
-		if ( offset < nextoffset ) {
+		if (offset < nextoffset) {
 			extsz -= nextoffset - offset;
 			offset = nextoffset;
-			mlog( MLOG_NITTY,
+			mlog(MLOG_NITTY,
 			      "adjusted bottom of extent to nextoffset: "
 			      "offset %lld, sz %lld; nextoffset %lld\n",
 			      offset,
 			      extsz,
-			      nextoffset );
+			      nextoffset);
 		}
-		assert( extsz > 0 );
+		assert(extsz > 0);
 
 		/* if the resultant extent would put us over maxcnt,
 		 * shorten it, and round up to the next BBSIZE (round
 		 * upto d_miniosz for realtime).
 		 */
-		if ( extsz > maxcnt - ( bytecnt + sizeof( extenthdr_t ))) {
+		if (extsz > maxcnt - (bytecnt + sizeof(extenthdr_t))) {
 			int iosz;
 
 			if (isrealtime)
 				iosz = da.d_miniosz;
 			else
 				iosz = BBSIZE;
-			extsz = maxcnt - ( bytecnt + sizeof( extenthdr_t ));
-			extsz = ( extsz + ( off64_t )( iosz - 1 ))
+			extsz = maxcnt - (bytecnt + sizeof(extenthdr_t));
+			extsz = (extsz + (off64_t)(iosz - 1))
 				&
-				~( off64_t )( iosz - 1 );
-			mlog( MLOG_NITTY,
+				~(off64_t)(iosz - 1);
+			mlog(MLOG_NITTY,
 			      "adjusted top of extent to honor maxcnt "
 			      "(rounded up %d): "
 			      "offset %lld, sz %lld; maxcnt %lld\n",
 			      iosz,
 			      offset,
 			      extsz,
-			      maxcnt );
+			      maxcnt);
 		}
 
 		/* if the shortened extent is too small, return; we'll
@@ -4669,15 +4669,15 @@ dump_extent_group( drive_t *drivep,
 		 * size is zero, indicate we are done.
 		 * !!! I don't believe this rule can ever fire!
 		 */
-		if ( extsz <= 0 ) {
-			mlog( MLOG_NITTY,
+		if (extsz <= 0) {
+			mlog(MLOG_NITTY,
 			      "adjusted extent size is non-positive: "
 			      "%lld (bs_size %lld)\n",
 			      extsz,
-			      statp->bs_size );
+			      statp->bs_size);
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
-			if ( statp->bs_size == 0 ) {
+			if (statp->bs_size == 0) {
 			    *cmpltflgp = BOOL_TRUE;
 			} else {
 			    *cmpltflgp = BOOL_FALSE;
@@ -4690,7 +4690,7 @@ dump_extent_group( drive_t *drivep,
 		 * at or beyond EOF.  (Shorten to d_miniosz for realtime
 		 * files).
 		 */
-		if ( extsz > statp->bs_size - offset ) {
+		if (extsz > statp->bs_size - offset) {
 			int iosz;
 
 			if (isrealtime)
@@ -4698,33 +4698,33 @@ dump_extent_group( drive_t *drivep,
 			else
 				iosz = BBSIZE;
 			extsz = statp->bs_size - offset;
-			extsz = ( extsz + ( off64_t )( iosz - 1 ))
+			extsz = (extsz + (off64_t)(iosz - 1))
 				&
-				~( off64_t )( iosz - 1 );
-			mlog( MLOG_NITTY,
+				~(off64_t)(iosz - 1);
+			mlog(MLOG_NITTY,
 			      "adjusted top of extent to match file size "
 			      "(rounded up %d): "
 			      "offset %lld, sz %lld; bs_size %lld\n",
 			      iosz,
 			      offset,
 			      extsz,
-			      statp->bs_size );
+			      statp->bs_size);
 		}
 
 		/* if the extent extends beyond the stop offset,
 		 * shorten it to the stop offset.
 		 */
-		if ( sosig && ( extsz > stopoffset - offset )) {
+		if (sosig && (extsz > stopoffset - offset)) {
 			extsz = stopoffset - offset;
-			assert( extsz >= 0 );
-			assert( ! ( extsz & ( off64_t )( BBSIZE - 1 )));
-			mlog( MLOG_NITTY,
+			assert(extsz >= 0);
+			assert(! (extsz & (off64_t)(BBSIZE - 1)));
+			mlog(MLOG_NITTY,
 			      "adjusted top of extent "
 			      "to adhere to stop offset: "
 			      "offset %lld, sz %lld; bs_size %lld\n",
 			      offset,
 			      extsz,
-			      statp->bs_size );
+			      statp->bs_size);
 		}
 
 		/* I/O performance is better if we align the media write
@@ -4732,131 +4732,131 @@ dump_extent_group( drive_t *drivep,
 		 * at least a page in length. Also, necessary for real time
 		 * files
 		 */
-		if ( isrealtime || extsz >= PGALIGNTHRESH * PGSZ ) {
+		if (isrealtime || extsz >= PGALIGNTHRESH * PGSZ) {
 			size_t cnt_to_align;
-			cnt_to_align = ( * dop->do_get_align_cnt )( drivep );
-			if ( ( size_t )cnt_to_align < 2*sizeof( extenthdr_t )) {
+			cnt_to_align = (* dop->do_get_align_cnt)(drivep);
+			if ((size_t)cnt_to_align < 2*sizeof(extenthdr_t)) {
 				cnt_to_align += PGSZ;
 			}
 
 			/* account for the DATA header following the alignment
 			 */
-			cnt_to_align -= sizeof( extenthdr_t );
+			cnt_to_align -= sizeof(extenthdr_t);
 
-			rv = dump_extenthdr( drivep,
+			rv = dump_extenthdr(drivep,
 					     contextp,
 					     EXTENTHDR_TYPE_ALIGN,
 					     0,
 					     0,
-					     ( off64_t )
-					     ( ( size_t )cnt_to_align
+					     (off64_t)
+					     ((size_t)cnt_to_align
 					       -
 					       sizeof(extenthdr_t)));
-			if ( rv != RV_OK ) {
+			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE;
 				return rv;
 			}
-			bytecnt += sizeof( extenthdr_t );
-			cnt_to_align -= sizeof( extenthdr_t );
-			rv = write_pad( drivep, cnt_to_align );
-			if ( rv != RV_OK ) {
+			bytecnt += sizeof(extenthdr_t);
+			cnt_to_align -= sizeof(extenthdr_t);
+			rv = write_pad(drivep, cnt_to_align);
+			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE; /* moot: rv != OK */
 				return rv;
 			}
-			bytecnt += ( off64_t )cnt_to_align;
+			bytecnt += (off64_t)cnt_to_align;
 		}
 		/* adjust the next offset
 		 */
-		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
-		assert( ( extsz & ( off64_t )( BBSIZE - 1 )) == 0 );
+		assert((offset & (off64_t)(BBSIZE - 1)) == 0);
+		assert((extsz & (off64_t)(BBSIZE - 1)) == 0);
 		nextoffset = offset + extsz;
 
 		/* dump the extent header
 		 */
-		rv = dump_extenthdr( drivep,
+		rv = dump_extenthdr(drivep,
 				     contextp,
 				     EXTENTHDR_TYPE_DATA,
 				     0,
 				     offset,
-				     extsz );
-		if ( rv != RV_OK ) {
+				     extsz);
+		if (rv != RV_OK) {
 			*nextoffsetp = nextoffset;
 			*bytecntp = bytecnt;
 			*cmpltflgp = BOOL_TRUE; /* moot since rv != OK */
 			return rv;
 		}
-		bytecnt += sizeof( extenthdr_t );
+		bytecnt += sizeof(extenthdr_t);
 
 		/* dump the extent. if read fails to return all
 		 * asked for, pad out the extent with zeros. necessary
 		 * because the extent hdr is already out there!
 		 */
-		while ( extsz ) {
+		while (extsz) {
 			off64_t new_off;
 			int nread;
 			size_t reqsz;
 			size_t actualsz;
 			char *bufp;
 
-			reqsz = extsz > ( off64_t )INTGENMAX
+			reqsz = extsz > (off64_t)INTGENMAX
 				?
 				INTGENMAX
 				:
-				( size_t )extsz;
-			bufp = ( * dop->do_get_write_buf )( drivep,
+				(size_t)extsz;
+			bufp = (* dop->do_get_write_buf)(drivep,
 							    reqsz,
-							    &actualsz );
-			assert( actualsz <= reqsz );
-			new_off = lseek64( gcp->eg_fd, offset, SEEK_SET );
-			if ( new_off == ( off64_t )( -1 )) {
-				mlog( MLOG_NORMAL, _(
+							    &actualsz);
+			assert(actualsz <= reqsz);
+			new_off = lseek64(gcp->eg_fd, offset, SEEK_SET);
+			if (new_off == (off64_t)(-1)) {
+				mlog(MLOG_NORMAL, _(
 				      "can't lseek ino %llu\n"),
-				      statp->bs_ino );
+				      statp->bs_ino);
 				nread = 0;
 			} else {
-				nread = read( gcp->eg_fd, bufp, actualsz);
+				nread = read(gcp->eg_fd, bufp, actualsz);
 			}
-			if ( nread < 0 ) {
+			if (nread < 0) {
 #ifdef HIDDEN
 				struct statvfs64 s;
 
  				/* Be quiet if this is a swap file - #510197 */
-				if ( (fstatvfs64(gcp->eg_fd, &s) < 0 ) ||
-				     ((s.f_flag & ST_LOCAL) != 0) )
-				   mlog( MLOG_NORMAL, _(
+				if ((fstatvfs64(gcp->eg_fd, &s) < 0) ||
+				     ((s.f_flag & ST_LOCAL) != 0))
+				   mlog(MLOG_NORMAL, _(
 		"can't read ino %llu at offset %d (act=%d req=%d) rt=%d\n"),
-		statp->bs_ino, new_off, actualsz , reqsz, isrealtime );
+		statp->bs_ino, new_off, actualsz , reqsz, isrealtime);
 #endif /* HIDDEN */
 
 				nread = 0;
 			}
-			assert( ( size_t )nread <= actualsz );
-			mlog( MLOG_NITTY,
+			assert((size_t)nread <= actualsz);
+			mlog(MLOG_NITTY,
 			      "read ino %llu offset %lld sz %d actual %d\n",
 			      statp->bs_ino,
 			      offset,
 			      actualsz,
-			      nread );
+			      nread);
 
 			/* must return entire buffer supplied by call to
 			 * do_get_write_buf; so pad end with zeros. below
 			 * we assume the short read implies EOF, so will
 			 * then pad out remainder of extent as well.
 			 */
-			if ( ( size_t )nread < actualsz ) {
-				memset( ( void * )( bufp + nread ),
+			if ((size_t)nread < actualsz) {
+				memset((void *)(bufp + nread),
 					0,
-					actualsz - ( size_t )nread );
+					actualsz - (size_t)nread);
 			}
 
-			rval = ( * dop->do_write )( drivep,
+			rval = (* dop->do_write)(drivep,
 						    bufp,
-						    actualsz );
-			switch ( rval ) {
+						    actualsz);
+			switch (rval) {
 			case 0:
 				rv = RV_OK;
 				break;
@@ -4872,41 +4872,41 @@ dump_extent_group( drive_t *drivep,
 				rv = RV_CORE;
 				break;
 			}
-			if ( rv != RV_OK ) {
+			if (rv != RV_OK) {
 				*nextoffsetp = nextoffset;
 				*bytecntp = bytecnt;
 				*cmpltflgp = BOOL_TRUE; /* moot: rv != OK */
 				return rv;
 			}
-			bytecnt += ( off64_t )actualsz;
-			extsz -= ( off64_t )actualsz;
-			offset += ( off64_t )actualsz;
+			bytecnt += (off64_t)actualsz;
+			extsz -= (off64_t)actualsz;
+			offset += (off64_t)actualsz;
 
 			/* if we got a short read, assume we are at the
 			 * end of the file; pad out the remainder of the
 			 * extent to match the header.
 			 */
-			if ( ( size_t )nread < actualsz ) {
-				mlog( MLOG_NITTY,
+			if ((size_t)nread < actualsz) {
+				mlog(MLOG_NITTY,
 				      "padding remaind %lld bytes of extent\n",
-				      extsz );
-				while ( extsz ) {
-					reqsz = extsz > ( off64_t )INTGENMAX
+				      extsz);
+				while (extsz) {
+					reqsz = extsz > (off64_t)INTGENMAX
 						?
 						INTGENMAX
 						:
-						( size_t )extsz;
-					rv = write_pad( drivep,
-							( size_t )reqsz );
-					if ( rv != RV_OK ) {
+						(size_t)extsz;
+					rv = write_pad(drivep,
+							(size_t)reqsz);
+					if (rv != RV_OK) {
 						*nextoffsetp = nextoffset;
 						*bytecntp = bytecnt;
 						*cmpltflgp = BOOL_TRUE;
 						return rv;
 					}
-					bytecnt += ( off64_t )reqsz;
-					extsz -= ( off64_t )reqsz;
-					offset += ( off64_t )reqsz;
+					bytecnt += (off64_t)reqsz;
+					extsz -= (off64_t)reqsz;
+					offset += (off64_t)reqsz;
 				}
 			}
 		}
@@ -4916,13 +4916,13 @@ dump_extent_group( drive_t *drivep,
 		 * !!! not be necessary, taken care of near the
 		 * !!! top of the loop.
 		 */
-		if ( nextoffset
+		if (nextoffset
 		     >=
-		     gcp->eg_nextbmapp->bmv_offset * ( off64_t )BBSIZE
+		     gcp->eg_nextbmapp->bmv_offset * (off64_t)BBSIZE
 		     +
-		     gcp->eg_nextbmapp->bmv_length * ( off64_t )BBSIZE ) {
-			mlog( MLOG_NITTY,
-			      "advancing to next extent in bmap\n" );
+		     gcp->eg_nextbmapp->bmv_length * (off64_t)BBSIZE) {
+			mlog(MLOG_NITTY,
+			      "advancing to next extent in bmap\n");
 			gcp->eg_nextbmapp++;
 			gcp->eg_bmapix++;
 		}
@@ -4961,11 +4961,11 @@ copy_xfs_bstat(bstat_t *dst, xfs_bstat_t *src)
 }
 
 static rv_t
-dump_filehdr( drive_t *drivep,
+dump_filehdr(drive_t *drivep,
 	      context_t *contextp,
 	      xfs_bstat_t *statp,
 	      off64_t offset,
-	      int flags )
+	      int flags)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	register filehdr_t *fhdrp = contextp->cc_filehdrp;
@@ -4973,8 +4973,8 @@ dump_filehdr( drive_t *drivep,
 	int rval;
 	rv_t rv;
 
-	( void )memset( ( void * )fhdrp, 0, sizeof( *fhdrp ));
-	if ( statp ) {
+	(void)memset((void *)fhdrp, 0, sizeof(*fhdrp));
+	if (statp) {
 		if (hsm_fs_ctxtp) {
 			HsmModifyInode(contextp->cc_hsm_f_ctxtp, statp);
 		}
@@ -4982,16 +4982,16 @@ dump_filehdr( drive_t *drivep,
 	}
 	fhdrp->fh_offset = offset;
 	fhdrp->fh_flags = flags | FILEHDR_FLAGS_CHECKSUM;
-	fhdrp->fh_checksum = calc_checksum( fhdrp, FILEHDR_SZ );
+	fhdrp->fh_checksum = calc_checksum(fhdrp, FILEHDR_SZ);
 
 	xlate_filehdr(fhdrp, &tmpfhdrp, 1);
-	rval = write_buf( ( char * )&tmpfhdrp,
-			  sizeof( tmpfhdrp ),
-			  ( void * )drivep,
-			  ( gwbfp_t )dop->do_get_write_buf,
-			  ( wfp_t )dop->do_write );
+	rval = write_buf((char *)&tmpfhdrp,
+			  sizeof(tmpfhdrp),
+			  (void *)drivep,
+			  (gwbfp_t)dop->do_get_write_buf,
+			  (wfp_t)dop->do_write);
 
-	switch ( rval ) {
+	switch (rval) {
 	case 0:
 		rv = RV_OK;
 		break;
@@ -5012,12 +5012,12 @@ dump_filehdr( drive_t *drivep,
 }
 
 static rv_t
-dump_extenthdr( drive_t *drivep,
+dump_extenthdr(drive_t *drivep,
 		context_t *contextp,
 		int32_t type,
 		int32_t flags,
 		off64_t offset,
-		off64_t sz )
+		off64_t sz)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	register extenthdr_t *ehdrp = contextp->cc_extenthdrp;
@@ -5026,44 +5026,44 @@ dump_extenthdr( drive_t *drivep,
 	rv_t rv;
 	char typestr[20];
 
-	switch( type )  {
+	switch(type)  {
 		case EXTENTHDR_TYPE_LAST:
-			strcpy( typestr, "LAST" );
+			strcpy(typestr, "LAST");
 			break;
 		case EXTENTHDR_TYPE_ALIGN:
-			strcpy( typestr, "ALIGN" );
+			strcpy(typestr, "ALIGN");
 			break;
 		case EXTENTHDR_TYPE_DATA:
-			strcpy( typestr, "DATA" );
+			strcpy(typestr, "DATA");
 			break;
 		case EXTENTHDR_TYPE_HOLE:
-			strcpy( typestr, "HOLE" );
+			strcpy(typestr, "HOLE");
 			break;
 		default:
-			strcpy( typestr, "UNKNOWN" );
+			strcpy(typestr, "UNKNOWN");
 	}
 
-	mlog( MLOG_DEBUG,
+	mlog(MLOG_DEBUG,
 	      "dumping extent type = %s offset = %lld size = %lld\n",
 	      typestr,
 	      offset,
-	       sz );
+	       sz);
 
-	( void )memset( ( void * )ehdrp, 0, sizeof( *ehdrp ));
+	(void)memset((void *)ehdrp, 0, sizeof(*ehdrp));
 	ehdrp->eh_type = type;
 	ehdrp->eh_flags = flags | EXTENTHDR_FLAGS_CHECKSUM;
 	ehdrp->eh_offset = offset;
 	ehdrp->eh_sz = sz;
-	ehdrp->eh_checksum = calc_checksum( ehdrp, EXTENTHDR_SZ );
+	ehdrp->eh_checksum = calc_checksum(ehdrp, EXTENTHDR_SZ);
 
 	xlate_extenthdr(ehdrp, &tmpehdrp, 1);
-	rval = write_buf( ( char * )&tmpehdrp,
-			  sizeof( tmpehdrp ),
-			  ( void * )drivep,
-			  ( gwbfp_t )dop->do_get_write_buf,
-			  ( wfp_t )dop->do_write );
+	rval = write_buf((char *)&tmpehdrp,
+			  sizeof(tmpehdrp),
+			  (void *)drivep,
+			  (gwbfp_t)dop->do_get_write_buf,
+			  (wfp_t)dop->do_write);
 
-	switch ( rval ) {
+	switch (rval) {
 	case 0:
 		rv = RV_OK;
 		break;
@@ -5084,13 +5084,13 @@ dump_extenthdr( drive_t *drivep,
 }
 
 static rv_t
-dump_dirent( drive_t *drivep,
+dump_dirent(drive_t *drivep,
 	     context_t *contextp,
 	     xfs_bstat_t *statp,
 	     xfs_ino_t ino,
 	     gen_t gen,
 	     char *name,
-	     size_t namelen )
+	     size_t namelen)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	char *outbufp;
@@ -5100,10 +5100,10 @@ dump_dirent( drive_t *drivep,
 	int rval;
 	rv_t rv;
 
-	if ( sc_use_old_direntpr ) {
-		name_offset = offsetofmember( direnthdr_v1_t, dh_name );
+	if (sc_use_old_direntpr) {
+		name_offset = offsetofmember(direnthdr_v1_t, dh_name);
 	} else {
-		name_offset = offsetofmember( direnthdr_t, dh_name );
+		name_offset = offsetofmember(direnthdr_t, dh_name);
 	}
 
 	sz = name_offset
@@ -5111,72 +5111,72 @@ dump_dirent( drive_t *drivep,
 	     namelen
 	     +
 	     1;
-	sz = ( sz + DIRENTHDR_ALIGN - 1 )
+	sz = (sz + DIRENTHDR_ALIGN - 1)
 	     &
-	     ~( DIRENTHDR_ALIGN - 1 );
+	     ~(DIRENTHDR_ALIGN - 1);
 
-	if ( sz > direntbufsz ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (sz > direntbufsz) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "unable to dump "
 		      "directory %llu entry %s (%llu): "
 		      "name too long\n"),
 		      statp->bs_ino,
 		      name,
-		      ino );
+		      ino);
 		mlog_exit_hint(RV_INCOMPLETE);
 		return RV_OK;
 	}
 
-	assert( sz <= UINT16MAX );
-	assert( sz >= DIRENTHDR_SZ );
+	assert(sz <= UINT16MAX);
+	assert(sz >= DIRENTHDR_SZ);
 
 	outbufp = malloc(sz);
 
-	if ( sc_use_old_direntpr ) {
-		direnthdr_v1_t *dhdrp = ( direnthdr_v1_t * )contextp->cc_mdirentbufp;
-		direnthdr_v1_t *tmpdhdrp = ( direnthdr_v1_t * )outbufp;
+	if (sc_use_old_direntpr) {
+		direnthdr_v1_t *dhdrp = (direnthdr_v1_t *)contextp->cc_mdirentbufp;
+		direnthdr_v1_t *tmpdhdrp = (direnthdr_v1_t *)outbufp;
 
-		memset( ( void * )dhdrp, 0, sz );
+		memset((void *)dhdrp, 0, sz);
 		dhdrp->dh_ino = ino;
-		dhdrp->dh_sz = ( uint16_t )sz;
-		dhdrp->dh_gen = ( uint16_t )( gen & DENTGENMASK );
-		if ( name ) {
-			strcpy( dhdrp->dh_name, name );
+		dhdrp->dh_sz = (uint16_t)sz;
+		dhdrp->dh_gen = (uint16_t)(gen & DENTGENMASK);
+		if (name) {
+			strcpy(dhdrp->dh_name, name);
 		}
 
-		dhdrp->dh_checksum = calc_checksum( dhdrp, DIRENTHDR_SZ );
+		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
 
-		xlate_direnthdr_v1( dhdrp, tmpdhdrp, 1 );
-		if ( name ) {
-			strcpy( tmpdhdrp->dh_name, name );
+		xlate_direnthdr_v1(dhdrp, tmpdhdrp, 1);
+		if (name) {
+			strcpy(tmpdhdrp->dh_name, name);
 		}
 	} else {
-		direnthdr_t *dhdrp = ( direnthdr_t * )contextp->cc_mdirentbufp;
-		direnthdr_t *tmpdhdrp = ( direnthdr_t * )outbufp;
+		direnthdr_t *dhdrp = (direnthdr_t *)contextp->cc_mdirentbufp;
+		direnthdr_t *tmpdhdrp = (direnthdr_t *)outbufp;
 
-		memset( ( void * )dhdrp, 0, sz );
+		memset((void *)dhdrp, 0, sz);
 		dhdrp->dh_ino = ino;
 		dhdrp->dh_gen = gen;
-		dhdrp->dh_sz = ( uint16_t )sz;
-		if ( name ) {
-			strcpy( dhdrp->dh_name, name );
+		dhdrp->dh_sz = (uint16_t)sz;
+		if (name) {
+			strcpy(dhdrp->dh_name, name);
 		}
 
-		dhdrp->dh_checksum = calc_checksum( dhdrp, DIRENTHDR_SZ );
+		dhdrp->dh_checksum = calc_checksum(dhdrp, DIRENTHDR_SZ);
 
-		xlate_direnthdr( dhdrp, tmpdhdrp, 1 );
-		if ( name ) {
-			strcpy( tmpdhdrp->dh_name, name );
+		xlate_direnthdr(dhdrp, tmpdhdrp, 1);
+		if (name) {
+			strcpy(tmpdhdrp->dh_name, name);
 		}
 	}
 
-	rval = write_buf( outbufp,
+	rval = write_buf(outbufp,
 			  sz,
-			  ( void * )drivep,
-			  ( gwbfp_t )dop->do_get_write_buf,
-			  ( wfp_t )dop->do_write );
+			  (void *)drivep,
+			  (gwbfp_t)dop->do_get_write_buf,
+			  (wfp_t)dop->do_write);
 	free(outbufp);
-	switch ( rval ) {
+	switch (rval) {
 	case 0:
 		rv = RV_OK;
 		break;
@@ -5197,10 +5197,10 @@ dump_dirent( drive_t *drivep,
 }
 
 static bool_t
-dump_session_inv( drive_t *drivep,
+dump_session_inv(drive_t *drivep,
 		  context_t *contextp,
 		  media_hdr_t *mwhdrp,
-		  content_inode_hdr_t *scwhdrp )
+		  content_inode_hdr_t *scwhdrp)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	ix_t strmix = drivep->d_index;
@@ -5213,24 +5213,24 @@ dump_session_inv( drive_t *drivep,
 
 	/* if the inventory session token is null, skip
 	 */
-	if ( sc_inv_sestoken == INV_TOKEN_NULL ) {
+	if (sc_inv_sestoken == INV_TOKEN_NULL) {
 		return BOOL_TRUE;
 	}
 
-	mlog( MLOG_VERBOSE, _(
-	      "dumping session inventory\n") );
+	mlog(MLOG_VERBOSE, _(
+	      "dumping session inventory\n"));
 
 	/* get a buffer from the inventory manager
 	 */
 	inv_sbufp = 0;
 	inv_sbufsz = 0;
-	ok = inv_get_sessioninfo( sc_inv_sestoken, ( void * )&inv_sbufp, &inv_sbufsz );
-	if ( ! ok ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
-		      "unable to get session inventory to dump\n") );
+	ok = inv_get_sessioninfo(sc_inv_sestoken, (void *)&inv_sbufp, &inv_sbufsz);
+	if (! ok) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
+		      "unable to get session inventory to dump\n"));
 		return BOOL_TRUE;
 	}
-	assert( inv_sbufp );
+	assert(inv_sbufp);
 
 	/* modify the write header to indicate the media file type.
 	 */
@@ -5240,32 +5240,32 @@ dump_session_inv( drive_t *drivep,
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
-	for ( done = BOOL_FALSE ; ! done ; ) {
+	for (done = BOOL_FALSE ; ! done ;) {
 		uuid_t mediaid;
-		char medialabel[ GLOBAL_HDR_STRING_SZ ];
+		char medialabel[GLOBAL_HDR_STRING_SZ];
 		bool_t partial;
 		int mediafileix;
 		int rval;
 		rv_t rv;
 
-		mlog( MLOG_VERBOSE, _(
-		      "beginning inventory media file\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "beginning inventory media file\n"));
 
 		partial = BOOL_FALSE;
-		rv = Media_mfile_begin( drivep, contextp, BOOL_FALSE );
-		switch( rv ) {
+		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
+		switch(rv) {
 		case RV_OK:
 			break;
 		case RV_TIMEOUT:
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change timeout: "
-			      "session inventory not dumped\n") );
+			      "session inventory not dumped\n"));
 			mlog_exit_hint(RV_INV);
 			return BOOL_FALSE;
 		case RV_QUIT:
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change declined: "
-			      "session inventory not dumped\n") );
+			      "session inventory not dumped\n"));
 			mlog_exit_hint(RV_INV);
 			return BOOL_FALSE;
 		case RV_DRIVE:
@@ -5275,22 +5275,22 @@ dump_session_inv( drive_t *drivep,
 			return BOOL_FALSE;
 		}
 
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "media file %u (media %u, file %u)\n"),
 		      mwhdrp->mh_dumpfileix,
 		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix );
+		      mwhdrp->mh_mediafileix);
 
 		uuid_copy(mediaid, mwhdrp->mh_mediaid);
-		strcpy( medialabel, mwhdrp->mh_medialabel );
-		mediafileix = ( int )mwhdrp->mh_mediafileix;
+		strcpy(medialabel, mwhdrp->mh_medialabel);
+		mediafileix = (int)mwhdrp->mh_mediafileix;
 
-		rval = write_buf( inv_sbufp,
+		rval = write_buf(inv_sbufp,
 				  inv_sbufsz,
-				  ( void * )drivep,
-				  ( gwbfp_t )dop->do_get_write_buf,
-				  ( wfp_t )dop->do_write );
-		switch ( rval ) {
+				  (void *)drivep,
+				  (gwbfp_t)dop->do_get_write_buf,
+				  (wfp_t)dop->do_write);
+		switch (rval) {
 		case 0:
 			break;
 		case DRIVE_ERROR_MEDIA:
@@ -5303,15 +5303,15 @@ dump_session_inv( drive_t *drivep,
 			return BOOL_FALSE;
 		}
 
-		mlog( MLOG_VERBOSE, _(
-		      "ending inventory media file\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "ending inventory media file\n"));
 		ncommitted = 0;
-		rv = Media_mfile_end( drivep,
+		rv = Media_mfile_end(drivep,
 				      contextp,
 				      mwhdrp,
 				      &ncommitted,
-				      partial );
-		switch( rv ) {
+				      partial);
+		switch(rv) {
 		case RV_OK:
 			break;
 		case RV_EOM:
@@ -5321,42 +5321,42 @@ dump_session_inv( drive_t *drivep,
 			return BOOL_FALSE;
 		}
 
-		if ( partial ) {
-			mlog( MLOG_VERBOSE, _(
+		if (partial) {
+			mlog(MLOG_VERBOSE, _(
 			      "encountered EOM while writing "
 			      "inventory media file size %lld bytes\n"),
-			      ncommitted );
+			      ncommitted);
 			mlog_exit_hint(RV_INV);
 		} else {
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "inventory media file size %lld bytes\n"),
-			      ncommitted );
+			      ncommitted);
 		}
-		if ( sc_inv_stmtokenp ) {
-			inv_stmt = sc_inv_stmtokenp[ strmix ];
+		if (sc_inv_stmtokenp) {
+			inv_stmt = sc_inv_stmtokenp[strmix];
 		} else {
 			inv_stmt = INV_TOKEN_NULL;
 		}
 
-		if ( inv_stmt != INV_TOKEN_NULL ) {
-			mlog( MLOG_DEBUG,
+		if (inv_stmt != INV_TOKEN_NULL) {
+			mlog(MLOG_DEBUG,
 			      "giving inventory "
-			      "session dump media file\n" );
-			ok = inv_put_mediafile( inv_stmt,
+			      "session dump media file\n");
+			ok = inv_put_mediafile(inv_stmt,
 						&mediaid,
 						medialabel,
-						( uint )mediafileix,
-						(xfs_ino_t )0,
-						( off64_t )0,
-						(xfs_ino_t )0,
-						( off64_t )0,
+						(uint)mediafileix,
+						(xfs_ino_t)0,
+						(off64_t)0,
+						(xfs_ino_t)0,
+						(off64_t)0,
 						ncommitted,
 						! partial,
-						BOOL_TRUE );
-			if ( ! ok ) {
-				mlog( MLOG_NORMAL, _(
+						BOOL_TRUE);
+			if (! ok) {
+				mlog(MLOG_NORMAL, _(
 				      "inventory session media file "
-				      "put failed\n") );
+				      "put failed\n"));
 				return BOOL_FALSE;
 			}
 		}
@@ -5368,49 +5368,49 @@ dump_session_inv( drive_t *drivep,
 }
 
 static void
-dump_terminator( drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp )
+dump_terminator(drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp)
 {
 	off64_t ncommitted;
 	bool_t done;
 
 	/* if the drive doesn't support use of stream terminators, don't bother
 	 */
-	if ( ! contextp->cc_Media_useterminatorpr ) {
+	if (! contextp->cc_Media_useterminatorpr) {
 		return;
 	}
 
-	mlog( MLOG_VERBOSE, _(
-	      "writing stream terminator\n") );
+	mlog(MLOG_VERBOSE, _(
+	      "writing stream terminator\n"));
 
 	/* modify the write header to indicate a terminator
 	 */
-	MEDIA_TERMINATOR_SET( mwhdrp );
+	MEDIA_TERMINATOR_SET(mwhdrp);
 
 	/* loop attempting to write a complete media file header
 	 * until we are successful or until the media layer
 	 * tells us to give up.
 	 */
-	for ( done = BOOL_FALSE ; ! done ; ) {
+	for (done = BOOL_FALSE ; ! done ;) {
 		bool_t partial;
 		rv_t rv;
 
-		mlog( MLOG_VERBOSE, _(
-		      "beginning media stream terminator\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "beginning media stream terminator\n"));
 
 		partial = BOOL_FALSE;
-		rv = Media_mfile_begin( drivep, contextp, BOOL_FALSE );
-		switch( rv ) {
+		rv = Media_mfile_begin(drivep, contextp, BOOL_FALSE);
+		switch(rv) {
 		case RV_OK:
 			break;
 		case RV_TIMEOUT:
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change timeout: "
-			      "media stream terminator not written\n") );
+			      "media stream terminator not written\n"));
 			return;
 		case RV_QUIT:
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change declined: "
-			      "media stream terminator not written\n") );
+			      "media stream terminator not written\n"));
 			return;
 		case RV_DRIVE:
 		case RV_ERROR:
@@ -5419,21 +5419,21 @@ dump_terminator( drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp )
 			return;
 		}
 
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "media file %u (media %u, file %u)\n"),
 		      mwhdrp->mh_dumpfileix,
 		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix );
+		      mwhdrp->mh_mediafileix);
 
-		mlog( MLOG_VERBOSE, _(
-		      "ending media stream terminator\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "ending media stream terminator\n"));
 		ncommitted = 0;
-		rv = Media_mfile_end( drivep,
+		rv = Media_mfile_end(drivep,
 				      contextp,
 				      mwhdrp,
 				      &ncommitted,
-				      BOOL_FALSE );
-		switch( rv ) {
+				      BOOL_FALSE);
+		switch(rv) {
 		case RV_OK:
 			break;
 		case RV_EOM:
@@ -5443,15 +5443,15 @@ dump_terminator( drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp )
 			return;
 		}
 
-		if ( partial ) {
-			mlog( MLOG_VERBOSE, _(
+		if (partial) {
+			mlog(MLOG_VERBOSE, _(
 			      "encountered EOM while writing "
 			      "media stream terminator size %lld bytes\n"),
-			      ncommitted );
+			      ncommitted);
 		} else {
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "media stream terminator size %lld bytes\n"),
-			      ncommitted );
+			      ncommitted);
 		}
 
 		done = ! partial;
@@ -5459,19 +5459,19 @@ dump_terminator( drive_t *drivep, context_t *contextp, media_hdr_t *mwhdrp )
 }
 
 static rv_t
-write_pad( drive_t *drivep, size_t sz )
+write_pad(drive_t *drivep, size_t sz)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	int rval;
 	rv_t rv;
 
-	rval = write_buf( 0,
+	rval = write_buf(0,
 			  sz,
-			  ( void * )drivep,
-			  ( gwbfp_t )dop->do_get_write_buf,
-			  ( wfp_t )dop->do_write );
+			  (void *)drivep,
+			  (gwbfp_t)dop->do_get_write_buf,
+			  (wfp_t)dop->do_write);
 
-	switch ( rval ) {
+	switch (rval) {
 	case 0:
 		rv = RV_OK;
 		break;
@@ -5492,16 +5492,16 @@ write_pad( drive_t *drivep, size_t sz )
 }
 
 static void
-inv_cleanup( void )
+inv_cleanup(void)
 {
 	/* REFERENCED */
 	bool_t ok;
 
-	if ( sc_inv_stmtokenp && sc_contextp ) {
+	if (sc_inv_stmtokenp && sc_contextp) {
 		size_t strmix;
 		inv_stmtoken_t *inv_stmtp;
 		context_t *contextp;
-		for ( strmix = 0,
+		for (strmix = 0,
 		      inv_stmtp = sc_inv_stmtokenp,
 		      contextp = sc_contextp
 		      ;
@@ -5509,30 +5509,30 @@ inv_cleanup( void )
 		      ;
 		      strmix++,
 		      inv_stmtp++,
-		      contextp++ ) {
+		      contextp++) {
 			bool_t interrupted;
 			interrupted = ! contextp->cc_completepr;
-			if ( *inv_stmtp == INV_TOKEN_NULL ) {
+			if (*inv_stmtp == INV_TOKEN_NULL) {
 				continue;
 			}
-			mlog( MLOG_DEBUG,
+			mlog(MLOG_DEBUG,
 			      "closing inventory stream %d%s\n",
 			      strmix,
-			      interrupted ? ": interrupted" : "" );
+			      interrupted ? ": interrupted" : "");
 			if (interrupted) mlog_exit_hint(RV_INTR);
-			ok = inv_stream_close( *inv_stmtp, interrupted );
-			assert( ok );
+			ok = inv_stream_close(*inv_stmtp, interrupted);
+			assert(ok);
 		}
 	}
 
-	if ( sc_inv_sestoken != INV_TOKEN_NULL ) {
-		ok = inv_writesession_close( sc_inv_sestoken );
-		assert( ok );
+	if (sc_inv_sestoken != INV_TOKEN_NULL) {
+		ok = inv_writesession_close(sc_inv_sestoken);
+		assert(ok);
 	}
 
-	if ( sc_inv_idbtoken != INV_TOKEN_NULL ) {
-		ok = inv_close( sc_inv_idbtoken );
-		assert( ok );
+	if (sc_inv_idbtoken != INV_TOKEN_NULL) {
+		ok = inv_close(sc_inv_idbtoken);
+		assert(ok);
 	}
 }
 
@@ -5546,15 +5546,15 @@ inv_cleanup( void )
  * of automatic variables.
  */
 static rv_t
-Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
+Media_mfile_begin(drive_t *drivep, context_t *contextp, bool_t intr_allowed)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	int dcaps = drivep->d_capabilities;
 	global_hdr_t *gwhdrp = drivep->d_gwritehdrp;
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
+	media_hdr_t *mwhdrp = (media_hdr_t *)dwhdrp->dh_upper;
 	drive_hdr_t *drhdrp = drivep->d_readhdrp;
-	media_hdr_t *mrhdrp = ( media_hdr_t * )drhdrp->dh_upper;
+	media_hdr_t *mrhdrp = (media_hdr_t *)drhdrp->dh_upper;
 	char *cmdlinemedialabel;
 	bool_t virginmediapr;
 	bool_t mediapresentpr;
@@ -5566,10 +5566,10 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 
 	/* sanity checks
 	 */
-	assert( BES_INIT == 0 );
+	assert(BES_INIT == 0);
 
-	mlog( MLOG_DEBUG | MLOG_MEDIA,
-	      "Media op: begin media file\n" );
+	mlog(MLOG_DEBUG | MLOG_MEDIA,
+	      "Media op: begin media file\n");
 
 	/* the command line-specified media label is good only for the
 	 * first media object written to. after that, the operator will
@@ -5587,12 +5587,12 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 		bes_t entrystate;
 		entrystate = contextp->cc_Media_begin_entrystate;
 		contextp->cc_Media_begin_entrystate = BES_INVAL;
-		switch ( entrystate ) {
+		switch (entrystate) {
 		case BES_INIT:
 			mediawrittentopr = BOOL_FALSE;
-			mwhdrp->mh_mediaix = ( uint32_t )( -1 );
-			mwhdrp->mh_dumpfileix = ( uint32_t )( -1 );
-			if ( dcaps & DRIVE_CAP_READ ) {
+			mwhdrp->mh_mediaix = (uint32_t)(-1);
+			mwhdrp->mh_dumpfileix = (uint32_t)(-1);
+			if (dcaps & DRIVE_CAP_READ) {
 				mediapresentpr = BOOL_UNKNOWN;
 				virginmediapr = BOOL_UNKNOWN;
 				goto position;
@@ -5612,7 +5612,7 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
 			mediawrittentopr = BOOL_TRUE;
 			goto changemedia;
 		default:
-			assert( 0 );
+			assert(0);
 			return RV_CORE;
 		}
 	}
@@ -5626,40 +5626,40 @@ position:
 	 * be concatenated but not jumbled. a dump stream must be virtually
 	 * contiguous.
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		/* check if a stop has been requested
 		 */
-		if ( intr_allowed && cldmgr_stop_requested( )) {
+		if (intr_allowed && cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
 		/* do a begin_read to see the disposition of the drive/media.
 		 */
-		rval = ( * dop->do_begin_read )( drivep );
+		rval = (* dop->do_begin_read)(drivep);
 
 		/* update cc_Media_useterminatorpr after every begin_read,
 		 * since begin_read will cause some unknown drive params
 		 * to be resolved.
 		 */
-		update_cc_Media_useterminatorpr( drivep, contextp );
+		update_cc_Media_useterminatorpr(drivep, contextp);
 
-		switch( rval ) {
+		switch(rval) {
 		case 0:
-			mlog_lock( );
-			mlog( MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
+			mlog_lock();
+			mlog(MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
 			      "positioned at media file %u: "
 			      "dump %u, "
 			      "stream %u\n"),
 			      mrhdrp->mh_mediafileix,
 			      mrhdrp->mh_dumpmediaix,
-			      drhdrp->dh_driveix );
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			      drhdrp->dh_driveix);
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "stream media file %u (%u in object), "
 			      "stream media object %d\n",
 			      mrhdrp->mh_dumpfileix,
 			      mrhdrp->mh_dumpmediafileix,
-			      mrhdrp->mh_mediaix );
-			mlog_unlock( );
+			      mrhdrp->mh_mediaix);
+			mlog_unlock();
 
 			/* successfully read media file header.
 			 * we know media must be present in drive, and
@@ -5679,12 +5679,12 @@ position:
 			 * media object a virgin.
 			 * also, check for erase option.
 			 */
-			( * dop->do_end_read )( drivep );
+			(* dop->do_end_read)(drivep);
 
-			switch( Media_erasechk( drivep,
+			switch(Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
-						prevmediapresentpr )) {
+						prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5693,34 +5693,34 @@ position:
 				break;
 			}
 
-			if ( ( int32_t )mwhdrp->mh_mediaix >= 0 ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+			if ((int32_t)mwhdrp->mh_mediaix >= 0) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "cannot interleave dump streams: "
-				      "must supply a blank media object\n") );
+				      "must supply a blank media object\n"));
 				goto changemedia;
 			}
-			if ( ! ( dcaps & DRIVE_CAP_APPEND )) {
-				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
+			if (! (dcaps & DRIVE_CAP_APPEND)) {
+				mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
 				      "media contains valid xfsdump "
-				      "but does not support append\n") );
+				      "but does not support append\n"));
 				goto changemedia;
 			}
-			if ( MEDIA_TERMINATOR_CHK( mrhdrp )) {
+			if (MEDIA_TERMINATOR_CHK(mrhdrp)) {
 				int status;
-				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-				      "stream terminator found\n") );
-				assert( contextp->cc_Media_useterminatorpr );
-				assert( dcaps & DRIVE_CAP_BSF ); /* redundant */
+				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+				      "stream terminator found\n"));
+				assert(contextp->cc_Media_useterminatorpr);
+				assert(dcaps & DRIVE_CAP_BSF); /* redundant */
 				status = 0;
-				rval = ( * dop->do_bsf )( drivep, 0, &status );
-				assert( rval == 0 );
-				if ( status == DRIVE_ERROR_DEVICE ) {
-					mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
+				rval = (* dop->do_bsf)(drivep, 0, &status);
+				assert(rval == 0);
+				if (status == DRIVE_ERROR_DEVICE) {
+					mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
 					      "encountered media error "
-					      "attempting BSF\n") );
+					      "attempting BSF\n"));
 					goto changemedia;
 				}
-				if ( mrhdrp->mh_mediafileix == 0 ) {
+				if (mrhdrp->mh_mediafileix == 0) {
 					virginmediapr = BOOL_TRUE;
 				}
 				goto write;
@@ -5729,16 +5729,16 @@ position:
 		case DRIVE_ERROR_FOREIGN:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 			      "media contains non-xfsdump data "
 			      "or a corrupt xfsdump media file header "
-			      "at beginning of media\n") );
+			      "at beginning of media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
-			switch( Media_erasechk( drivep,
+			switch(Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
-						prevmediapresentpr )) {
+						prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5747,30 +5747,30 @@ position:
 				break;
 			}
 
-			if ( dlog_allowed( )) {
+			if (dlog_allowed()) {
 				bool_t ok;
-				ok = Media_prompt_overwrite( drivep );
-				if ( intr_allowed && cldmgr_stop_requested( )) {
+				ok = Media_prompt_overwrite(drivep);
+				if (intr_allowed && cldmgr_stop_requested()) {
 					return RV_INTR;
 				}
-				if ( ! ok ) {
+				if (! ok) {
 					goto changemedia;
 				}
 			}
 
-			if ( ! ( dcaps & DRIVE_CAP_OVERWRITE )) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "unable to overwrite\n") );
+			if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+				      "unable to overwrite\n"));
 				goto changemedia;
 			} else {
 				int status;
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-				      "repositioning to overwrite\n") );
-				assert( dcaps & DRIVE_CAP_BSF );
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+				      "repositioning to overwrite\n"));
+				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
-				rval = ( * dop->do_bsf )( drivep, 0, &status );
-				assert( rval == 0 );
-				if ( status == DRIVE_ERROR_DEVICE ) {
+				rval = (* dop->do_bsf)(drivep, 0, &status);
+				assert(rval == 0);
+				if (status == DRIVE_ERROR_DEVICE) {
 					return RV_DRIVE;
 				}
 
@@ -5782,17 +5782,17 @@ position:
 		case DRIVE_ERROR_OVERWRITE:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 				"media may contain data. "
-				"Overwrite option specified\n") );
+				"Overwrite option specified\n"));
 
-			if ( dlog_allowed( )) {
+			if (dlog_allowed()) {
 				bool_t ok;
-				ok = Media_prompt_overwrite( drivep );
-				if ( intr_allowed && cldmgr_stop_requested( )) {
+				ok = Media_prompt_overwrite(drivep);
+				if (intr_allowed && cldmgr_stop_requested()) {
 					return RV_INTR;
 				}
-				if ( ! ok ) {
+				if (! ok) {
 					goto changemedia;
 				}
 			}
@@ -5810,16 +5810,16 @@ position:
 		case DRIVE_ERROR_DEVICE:
 			return RV_DRIVE;
 		case DRIVE_ERROR_EOD:
-			mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-			      "at end of data\n") );
+			mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+			      "at end of data\n"));
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 
-			switch( Media_erasechk( drivep,
+			switch(Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
-						prevmediapresentpr )) {
+						prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5828,11 +5828,11 @@ position:
 				break;
 			}
 
-			if ( contextp->cc_Media_useterminatorpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+			if (contextp->cc_Media_useterminatorpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "encountered EOD but expecting a media "
 				      "stream terminator: "
-				      "assuming full media\n") );
+				      "assuming full media\n"));
 				goto changemedia;
 			} else {
 				goto write;
@@ -5841,13 +5841,13 @@ position:
 			prevmediapresentpr = mediapresentpr;
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-			      "encountered EOM: media is full\n") );
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+			      "encountered EOM: media is full\n"));
 
-			switch( Media_erasechk( drivep,
+			switch(Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
-						prevmediapresentpr )) {
+						prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5864,15 +5864,15 @@ position:
 			mediapresentpr = BOOL_TRUE;
 			virginmediapr = BOOL_FALSE;
 
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 			      "encountered corrupt or foreign data: "
-			      "assuming corrupted media\n") );
+			      "assuming corrupted media\n"));
 			mlog_exit_hint(RV_CORRUPT);
 
-			switch( Media_erasechk( drivep,
+			switch(Media_erasechk(drivep,
 						dcaps,
 						intr_allowed,
-						prevmediapresentpr )) {
+						prevmediapresentpr)) {
 			case RV_OK:
 				goto erasemedia;
 			case RV_INTR:
@@ -5881,32 +5881,32 @@ position:
 				break;
 			}
 
-			if ( contextp->cc_Media_useterminatorpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+			if (contextp->cc_Media_useterminatorpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "encountered corrupt or foreign data "
 				      "but expecting a media "
 				      "stream terminator: "
-				      "assuming corrupted media\n") );
+				      "assuming corrupted media\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
-			} else if ( ! ( dcaps & DRIVE_CAP_OVERWRITE )) {
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+			} else if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "encountered corrupt or foreign data: "
 				      "unable to overwrite: "
-				      "assuming corrupted media\n") );
+				      "assuming corrupted media\n"));
 				mlog_exit_hint(RV_CORRUPT);
 				goto changemedia;
 			} else {
 				int status;
-				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
+				mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA,_(
 				      "encountered corrupt or foreign data: "
-				      "repositioning to overwrite\n") );
+				      "repositioning to overwrite\n"));
 				mlog_exit_hint(RV_CORRUPT);
-				assert( dcaps & DRIVE_CAP_BSF );
+				assert(dcaps & DRIVE_CAP_BSF);
 				status = 0;
-				rval = ( * dop->do_bsf )( drivep, 0, &status );
-				assert( rval == 0 );
-				if ( status == DRIVE_ERROR_DEVICE ) {
+				rval = (* dop->do_bsf)(drivep, 0, &status);
+				assert(rval == 0);
+				if (status == DRIVE_ERROR_DEVICE) {
 					return RV_DRIVE;
 				}
 				goto write;
@@ -5917,19 +5917,19 @@ position:
 			return RV_ERROR;
 		case DRIVE_ERROR_EOF:
 		default:
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
 			      "unexpected error from do_begin_read: %d\n"),
-			      rval );
+			      rval);
 			return RV_CORE;
 		}
 	}
 	/* NOTREACHED */
 
 erasemedia:
-	mlog( MLOG_VERBOSE | MLOG_WARNING | MLOG_MEDIA, _(
-	      "erasing media\n") );
-	rval = ( * dop->do_erase )( drivep );
-	if ( rval ) {
+	mlog(MLOG_VERBOSE | MLOG_WARNING | MLOG_MEDIA, _(
+	      "erasing media\n"));
+	rval = (* dop->do_erase)(drivep);
+	if (rval) {
 		return RV_DRIVE;
 	}
 	prevmediapresentpr = mediapresentpr;
@@ -5941,17 +5941,17 @@ erasemedia:
 changemedia:
 	/* if the drive does not support media change, quit.
 	 */
-	if ( ! ( dcaps & DRIVE_CAP_REMOVABLE )) {
+	if (! (dcaps & DRIVE_CAP_REMOVABLE)) {
 		return RV_ERROR;
 	}
 
 	/* first eject the current media object if capability supported
 	 */
-	assert( mediapresentpr != BOOL_UNKNOWN );
-	if ( mediapresentpr == BOOL_TRUE ) {
-		if ( dcaps & DRIVE_CAP_EJECT ) {
-			rval = ( * dop->do_eject_media )( drivep );
-			if ( rval ) {
+	assert(mediapresentpr != BOOL_UNKNOWN);
+	if (mediapresentpr == BOOL_TRUE) {
+		if (dcaps & DRIVE_CAP_EJECT) {
+			rval = (* dop->do_eject_media)(drivep);
+			if (rval) {
 				return RV_DRIVE;
 			}
 		}
@@ -5959,7 +5959,7 @@ changemedia:
 
 	/* if dialogs not allowed, we are done.
 	 */
-	if ( ! dlog_allowed( )) {
+	if (! dlog_allowed()) {
 		return RV_QUIT; /* this return value will cause approp. msg */
 	}
 
@@ -5971,29 +5971,29 @@ changemedia:
 	/* if media change prompt declined or times out,
 	 * we are done
 	 */
-	if ( drivecnt > 1 && ! stdoutpiped ) {
+	if (drivecnt > 1 && ! stdoutpiped) {
 		ix_t thrdix = drivep->d_index;
-		assert( sistr );
-		mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
+		assert(sistr);
+		mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
 		      "please change media: "
 		      "type %s to confirm media change\n"),
-		      sistr );
-		set_mcflag( thrdix );
-		while ( sc_mcflag[ thrdix ] ) {
-			sleep( 2 );
-			if ( cldmgr_stop_requested( )) {
-				clr_mcflag( thrdix );
+		      sistr);
+		set_mcflag(thrdix);
+		while (sc_mcflag[thrdix]) {
+			sleep(2);
+			if (cldmgr_stop_requested()) {
+				clr_mcflag(thrdix);
 				return RV_INTR;
 			}
 		}
 		ok = BOOL_TRUE;
 	} else {
-		ok = Media_prompt_change( drivep );
+		ok = Media_prompt_change(drivep);
 	}
-	if ( intr_allowed && cldmgr_stop_requested( )) {
+	if (intr_allowed && cldmgr_stop_requested()) {
 		return RV_INTR;
 	}
-	if ( ! ok ) {
+	if (! ok) {
 		return RV_QUIT;
 	}
 
@@ -6007,10 +6007,10 @@ changemedia:
 	goto position;
 
 write:
-	assert( mediapresentpr == BOOL_TRUE );
-	assert( virginmediapr != BOOL_UNKNOWN );
+	assert(mediapresentpr == BOOL_TRUE);
+	assert(virginmediapr != BOOL_UNKNOWN);
 
-	if ( intr_allowed && cldmgr_stop_requested( )) {
+	if (intr_allowed && cldmgr_stop_requested()) {
 		return RV_INTR;
 	}
 
@@ -6021,104 +6021,104 @@ write:
 	 */
 	saved_gwhdr = *gwhdrp;
 
-	if ( mediawrittentopr ) {
+	if (mediawrittentopr) {
 		mwhdrp->mh_dumpmediafileix++;
 	} else {
 		mwhdrp->mh_dumpmediafileix = 0;
 	}
 	mwhdrp->mh_dumpfileix++; /* pre-initialized to -1 */
-	if ( virginmediapr ) {
+	if (virginmediapr) {
 		mwhdrp->mh_mediafileix = 0;
 		mwhdrp->mh_dumpmediaix = 0;
 	} else {
-		if ( mwhdrp->mh_dumpmediafileix == 0 ) {
+		if (mwhdrp->mh_dumpmediafileix == 0) {
 			mwhdrp->mh_dumpmediaix = mrhdrp->mh_dumpmediaix + 1;
 		}
-		if ( mediawrittentopr ) {
+		if (mediawrittentopr) {
 			mwhdrp->mh_mediafileix++;
 		} else {
 			mwhdrp->mh_mediafileix = mrhdrp->mh_mediafileix;
-			if ( ! MEDIA_TERMINATOR_CHK( mrhdrp )) {
+			if (! MEDIA_TERMINATOR_CHK(mrhdrp)) {
 				mwhdrp->mh_mediafileix++;
 			}
 		}
 	}
 
-	if ( ! mediawrittentopr ) {
+	if (! mediawrittentopr) {
 		mwhdrp->mh_mediaix++; /* pre-initialized to -1 */
 	}
 
-	assert( mwhdrp->mh_mediaix != ( uint32_t )( -1 ));
-	assert( mwhdrp->mh_dumpfileix != ( uint32_t )( -1 ));
+	assert(mwhdrp->mh_mediaix != (uint32_t)(-1));
+	assert(mwhdrp->mh_dumpfileix != (uint32_t)(-1));
 
 	/* do not allow interleaving of media files from different xfsdumps.
 	 */
-	if ( mwhdrp->mh_mediaix != 0
+	if (mwhdrp->mh_mediaix != 0
 	     &&
 	     mwhdrp->mh_dumpmediafileix == 0
 	     &&
-	     ! virginmediapr ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+	     ! virginmediapr) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 		      "cannot interleave dump streams: must supply a blank "
-		      "media object\n") );
+		      "media object\n"));
 		*gwhdrp = saved_gwhdr;
 		goto changemedia;
 	}
 
 	/* update the media object previous id and label
 	 */
-	if ( ! mediawrittentopr && mwhdrp->mh_dumpfileix != 0 ) {
+	if (! mediawrittentopr && mwhdrp->mh_dumpfileix != 0) {
 		uuid_copy(mwhdrp->mh_prevmediaid, mwhdrp->mh_mediaid);
-		( void )strncpyterm( mwhdrp->mh_prevmedialabel,
+		(void)strncpyterm(mwhdrp->mh_prevmedialabel,
 				     mwhdrp->mh_medialabel,
-				     sizeof( mwhdrp->mh_medialabel ));
+				     sizeof(mwhdrp->mh_medialabel));
 	}
 
 	/* update the media object current id and label
 	 */
-	if ( ! mediawrittentopr ) {
-		if ( mwhdrp->mh_mediafileix == 0 ) {
-			char labelbuf[ GLOBAL_HDR_STRING_SZ ];
+	if (! mediawrittentopr) {
+		if (mwhdrp->mh_mediafileix == 0) {
+			char labelbuf[GLOBAL_HDR_STRING_SZ];
 
-			uuid_generate( mwhdrp->mh_mediaid );
+			uuid_generate(mwhdrp->mh_mediaid);
 
-			if ( ! cmdlinemedialabel
+			if (! cmdlinemedialabel
 			     &&
 			     ! drivep->d_isnamedpipepr
 			     &&
 			     ! drivep->d_isunnamedpipepr
 			     &&
-			     dlog_allowed( )) {
-				cmdlinemedialabel = Media_prompt_label( drivep,
+			     dlog_allowed()) {
+				cmdlinemedialabel = Media_prompt_label(drivep,
 							labelbuf,
-							sizeof( labelbuf ));
-				if ( intr_allowed && cldmgr_stop_requested( )) {
+							sizeof(labelbuf));
+				if (intr_allowed && cldmgr_stop_requested()) {
 					return RV_INTR;
 				}
 			}
-			if ( cmdlinemedialabel && strlen( cmdlinemedialabel )) {
-				( void )strncpyterm( mwhdrp->mh_medialabel,
+			if (cmdlinemedialabel && strlen(cmdlinemedialabel)) {
+				(void)strncpyterm(mwhdrp->mh_medialabel,
 						     cmdlinemedialabel,
-					       sizeof( mwhdrp->mh_medialabel ));
+					       sizeof(mwhdrp->mh_medialabel));
 			} else {
-				( void )memset( ( void * )mwhdrp->mh_medialabel,
+				(void)memset((void *)mwhdrp->mh_medialabel,
 						     0,
-					       sizeof( mwhdrp->mh_medialabel ));
-				if ( ! pipeline ) {
-					mlog( MLOG_VERBOSE
+					       sizeof(mwhdrp->mh_medialabel));
+				if (! pipeline) {
+					mlog(MLOG_VERBOSE
 					      |
 					      MLOG_WARNING
 					      |
 					      MLOG_MEDIA, _(
-					      "no media label specified\n") );
+					      "no media label specified\n"));
 				}
 			}
 		} else {
-			assert( ! virginmediapr );
+			assert(! virginmediapr);
 			uuid_copy(mwhdrp->mh_mediaid, mrhdrp->mh_mediaid);
-			( void )strncpyterm( mwhdrp->mh_medialabel,
+			(void)strncpyterm(mwhdrp->mh_medialabel,
 					     mrhdrp->mh_medialabel,
-					     sizeof( mwhdrp->mh_medialabel ));
+					     sizeof(mwhdrp->mh_medialabel));
 		}
 	}
 
@@ -6126,17 +6126,17 @@ write:
 
 	/* write hdr is prepared. place it on media
 	 */
-	if ( intr_allowed && cldmgr_stop_requested( )) {
+	if (intr_allowed && cldmgr_stop_requested()) {
 		return RV_INTR;
 	}
-	rval = ( * dop->do_begin_write )( drivep );
-	switch( rval ) {
+	rval = (* dop->do_begin_write)(drivep);
+	switch(rval) {
 	case 0:
 		return RV_OK;
 	case DRIVE_ERROR_EOM:
-		mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+		mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 		      "encountered end of media "
-		      "while attempting to begin new media file\n") );
+		      "while attempting to begin new media file\n"));
 		*gwhdrp = saved_gwhdr;
 		goto changemedia;
 	case DRIVE_ERROR_MEDIA:
@@ -6151,38 +6151,38 @@ write:
 
 /* ARGSUSED */
 static rv_t
-Media_mfile_end( drive_t *drivep,
+Media_mfile_end(drive_t *drivep,
 		 context_t *contextp,
 		 media_hdr_t *mwhdrp,
 		 off64_t *ncommittedp,
-		 bool_t hit_eom )
+		 bool_t hit_eom)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	int rval;
 
-	mlog( MLOG_DEBUG | MLOG_MEDIA,
-	      "Media op: end media file\n" );
+	mlog(MLOG_DEBUG | MLOG_MEDIA,
+	      "Media op: end media file\n");
 
-	assert( contextp->cc_Media_begin_entrystate == BES_INVAL );
+	assert(contextp->cc_Media_begin_entrystate == BES_INVAL);
 
 	/* call drive's end_write op to flush the tail of the media file
 	 * if has previously hit EOM, this is moot.
 	 */
-	rval = ( dop->do_end_write )( drivep, ncommittedp );
-	if ( hit_eom ) {
-		assert( ! rval );
+	rval = (dop->do_end_write)(drivep, ncommittedp);
+	if (hit_eom) {
+		assert(! rval);
 		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
 		return RV_EOM;
 	}
-	switch( rval ) {
+	switch(rval) {
 	case 0:
 		contextp->cc_Media_begin_entrystate = BES_ENDOK;
 		return RV_OK;
 	case DRIVE_ERROR_MEDIA:
 	case DRIVE_ERROR_EOM:
-		mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+		mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 		      "encountered end of media "
-		      "while ending media file\n") );
+		      "while ending media file\n"));
 		mlog_exit_hint(RV_EOM);
 		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
 		return RV_EOM;
@@ -6197,19 +6197,19 @@ Media_mfile_end( drive_t *drivep,
 }
 
 static bool_t
-Media_prompt_overwrite( drive_t *drivep )
+Media_prompt_overwrite(drive_t *drivep)
 {
 	fold_t fold;
-	char question[ 100 ];
-	char *preamblestr[ PREAMBLEMAX ];
+	char question[100];
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
 	ix_t doix;
 	ix_t dontix;
@@ -6218,31 +6218,31 @@ Media_prompt_overwrite( drive_t *drivep )
 
 retry:
 	preamblecnt = 0;
-	fold_init( fold, "media overwrite dialog", '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	fold_init(fold, "media overwrite dialog", '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* query: ask if overwrite ok
 	 */
-	sprintf( question,
+	sprintf(question,
 		 "overwrite data on media in "
 		 "drive %u?\n",
-		 (unsigned int)drivep->d_index );
+		 (unsigned int)drivep->d_index);
 	querycnt = 0;
-	querystr[ querycnt++ ] = question;
-	assert( querycnt <= QUERYMAX );
+	querystr[querycnt++] = question;
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
 	dontix = choicecnt;
-	choicestr[ choicecnt++ ] = "don't overwrite";
+	choicestr[choicecnt++ ] = "don't overwrite";
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = "overwrite";
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++ ] = "overwrite";
+	assert(choicecnt <= CHOICEMAX);
 	sigintix = IXMAX - 1;
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -6254,41 +6254,41 @@ retry:
 				       dontix,		/* timeout ix */
 				       sigintix,	/* sigint ix */
 				       dontix,		/* sighup ix */
-				       dontix );	/* sigquit ix */
+				       dontix);	/* sigquit ix */
 	ackcnt = 0;
-	if ( responseix == doix ) {
-		ackstr[ ackcnt++ ] = "media will be overwritten\n";
-	} else if ( responseix == dontix ) {
-		ackstr[ ackcnt++ ] = "media will NOT be overwritten\n";
+	if (responseix == doix) {
+		ackstr[ackcnt++ ] = "media will be overwritten\n";
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++ ] = "media will NOT be overwritten\n";
 	} else {
-		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
+		ackstr[ackcnt++ ] = "keyboard interrupt\n";
 	}
-	assert( ackcnt <= ACKMAX );
-	dlog_multi_ack( ackstr,
-			ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_multi_ack(ackstr,
+			ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, "end dialog", '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
-
-	if ( responseix == sigintix ) {
-		if ( cldmgr_stop_requested( )) {
+	fold_init(fold, "end dialog", '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
+
+	if (responseix == sigintix) {
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		sleep( 1 ); /* to allow main thread to begin dialog */
-		mlog( MLOG_NORMAL | MLOG_BARE,
-		      "" ); /* to block until main thread dialog complete */
-		sleep( 1 ); /* to allow main thread to request children die */
-		if ( cldmgr_stop_requested( )) {
+		sleep(1); /* to allow main thread to begin dialog */
+		mlog(MLOG_NORMAL | MLOG_BARE,
+		      ""); /* to block until main thread dialog complete */
+		sleep(1); /* to allow main thread to request children die */
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		mlog( MLOG_DEBUG,
-		      "retrying media overwrite dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying media overwrite dialog\n");
 		goto retry;
 	}
 
@@ -6297,24 +6297,24 @@ retry:
 }
 
 static rv_t
-Media_erasechk( drive_t *drivep,
+Media_erasechk(drive_t *drivep,
 		int dcaps,
 		bool_t intr_allowed,
-		bool_t prevmediapresentpr )
+		bool_t prevmediapresentpr)
 {
-	if ( prevmediapresentpr == BOOL_TRUE ) {
+	if (prevmediapresentpr == BOOL_TRUE) {
 		return RV_NOTOK;
 	}
 
-	if ( sc_preerasepr ) {
-		if ( dcaps & DRIVE_CAP_ERASE ) {
-			if ( dlog_allowed( )) {
+	if (sc_preerasepr) {
+		if (dcaps & DRIVE_CAP_ERASE) {
+			if (dlog_allowed()) {
 				bool_t ok;
-				ok = Media_prompt_erase( drivep );
-				if ( intr_allowed && cldmgr_stop_requested( )) {
+				ok = Media_prompt_erase(drivep);
+				if (intr_allowed && cldmgr_stop_requested()) {
 					return RV_INTR;
 				}
-				if ( ok ) {
+				if (ok) {
 					return RV_OK;
 				} else {
 					return RV_NOTOK;
@@ -6323,10 +6323,10 @@ Media_erasechk( drive_t *drivep,
 				return RV_OK;
 			}
 		} else {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 			      "drive does not support media erase: "
 			      "ignoring -%c option\n"),
-			      GETOPT_ERASE );
+			      GETOPT_ERASE);
 			return RV_NOTOK;
 		}
 	} else {
@@ -6335,19 +6335,19 @@ Media_erasechk( drive_t *drivep,
 }
 
 static bool_t
-Media_prompt_erase( drive_t *drivep )
+Media_prompt_erase(drive_t *drivep)
 {
 	fold_t fold;
-	char question[ 100 ];
-	char *preamblestr[ PREAMBLEMAX ];
+	char question[100];
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
 	ix_t doix;
 	ix_t dontix;
@@ -6356,34 +6356,34 @@ Media_prompt_erase( drive_t *drivep )
 
 retry:
 	preamblecnt = 0;
-	fold_init( fold, "media erase dialog", '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	fold_init(fold, "media erase dialog", '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* query: ask if overwrite ok
 	 */
-	sprintf( question,
+	sprintf(question,
 		 "pre-erase (-%c) option specified "
 		 "and non-blank media encountered:\n"
 		 "please confirm media erase "
 		 "drive %u\n",
 		 GETOPT_ERASE,
-		 (unsigned int)drivep->d_index );
+		 (unsigned int)drivep->d_index);
 	querycnt = 0;
-	querystr[ querycnt++ ] = question;
-	assert( querycnt <= QUERYMAX );
+	querystr[querycnt++] = question;
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
 	dontix = choicecnt;
-	choicestr[ choicecnt++ ] = "don't erase";
+	choicestr[choicecnt++ ] = "don't erase";
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = "erase";
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++ ] = "erase";
+	assert(choicecnt <= CHOICEMAX);
 	sigintix = IXMAX - 1;
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -6395,41 +6395,41 @@ retry:
 				       dontix,		/* timeout ix */
 				       sigintix,	/* sigint ix */
 				       dontix,		/* sighup ix */
-				       dontix );	/* sigquit ix */
+				       dontix);	/* sigquit ix */
 	ackcnt = 0;
-	if ( responseix == doix ) {
-		ackstr[ ackcnt++ ] = "media will be erased\n";
-	} else if ( responseix == dontix ) {
-		ackstr[ ackcnt++ ] = "media will NOT be erased\n";
+	if (responseix == doix) {
+		ackstr[ackcnt++ ] = "media will be erased\n";
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++ ] = "media will NOT be erased\n";
 	} else {
-		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
+		ackstr[ackcnt++ ] = "keyboard interrupt\n";
 	}
-	assert( ackcnt <= ACKMAX );
-	dlog_multi_ack( ackstr,
-			ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_multi_ack(ackstr,
+			ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, "end dialog", '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
-
-	if ( responseix == sigintix ) {
-		if ( cldmgr_stop_requested( )) {
+	fold_init(fold, "end dialog", '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
+
+	if (responseix == sigintix) {
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		sleep( 1 ); /* to allow main thread to begin dialog */
-		mlog( MLOG_NORMAL | MLOG_BARE,
-		      "" ); /* to block until main thread dialog complete */
-		sleep( 1 ); /* to allow main thread to request children die */
-		if ( cldmgr_stop_requested( )) {
+		sleep(1); /* to allow main thread to begin dialog */
+		mlog(MLOG_NORMAL | MLOG_BARE,
+		      ""); /* to block until main thread dialog complete */
+		sleep(1); /* to allow main thread to request children die */
+		if (cldmgr_stop_requested()) {
 			return BOOL_FALSE;
 		}
-		mlog( MLOG_DEBUG,
-		      "retrying media erase dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying media erase dialog\n");
 		goto retry;
 	}
 
@@ -6438,27 +6438,27 @@ retry:
 }
 
 static void
-Media_prompt_label_cb( void *uctxp, dlog_pcbp_t pcb, void *pctxp )
+Media_prompt_label_cb(void *uctxp, dlog_pcbp_t pcb, void *pctxp)
 {
-	drive_t *drivep = ( drive_t * )uctxp;
+	drive_t *drivep = (drive_t *)uctxp;
 
 	/* query: ask for a label
 	 */
-	( * pcb )( pctxp,
+	(* pcb)(pctxp,
 		   "please enter label for media in "
 		   "drive %u",
-		   drivep->d_index );
+		   drivep->d_index);
 }
 
 static char *
-Media_prompt_label( drive_t *drivep, char *bufp, size_t bufsz )
+Media_prompt_label(drive_t *drivep, char *bufp, size_t bufsz)
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
 	const ix_t timeoutix = 1;
 	const ix_t abortix = 2;
@@ -6468,15 +6468,15 @@ Media_prompt_label( drive_t *drivep, char *bufp, size_t bufsz )
 
 retry:
 	preamblecnt = 0;
-	fold_init( fold, "media label dialog", '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
-
-	responseix = dlog_string_query( Media_prompt_label_cb,
-					( void * )drivep,
+	fold_init(fold, "media label dialog", '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
+
+	responseix = dlog_string_query(Media_prompt_label_cb,
+					(void *)drivep,
 					bufp,
 					bufsz,
 					DLOG_TIMEOUT,
@@ -6484,51 +6484,51 @@ retry:
 					sigintix, /* sigint ix */
 					abortix,  /* sighup ix */
 					abortix,  /* sigquit ix */
-					okix );   /* ok ix */
+					okix);   /* ok ix */
 	ackcnt = 0;
-	if ( responseix == okix ) {
-		ackstr[ ackcnt++ ] = "media label entered: \"";
-		ackstr[ ackcnt++ ] = bufp;
-		ackstr[ ackcnt++ ] = "\"\n";
-	} else if ( responseix == timeoutix ) {
-		ackstr[ ackcnt++ ] = "timeout: media label left blank\n";
-	} else if ( responseix == sigintix ) {
-		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
+	if (responseix == okix) {
+		ackstr[ackcnt++ ] = "media label entered: \"";
+		ackstr[ackcnt++] = bufp;
+		ackstr[ackcnt++ ] = "\"\n";
+	} else if (responseix == timeoutix) {
+		ackstr[ackcnt++ ] = "timeout: media label left blank\n";
+	} else if (responseix == sigintix) {
+		ackstr[ackcnt++ ] = "keyboard interrupt\n";
 	} else {
-		ackstr[ ackcnt++ ] = "abort\n";
+		ackstr[ackcnt++ ] = "abort\n";
 	}
 
-	assert( ackcnt <= ACKMAX );
-	dlog_string_ack( ackstr,
-			 ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_string_ack(ackstr,
+			 ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, "end dialog", '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
-
-	if ( responseix == sigintix ) {
-		if ( cldmgr_stop_requested( )) {
+	fold_init(fold, "end dialog", '-');
+	postamblestr[postamblecnt++ ] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++ ] = "\n\n";
+	assert(postamblecnt <= POSTAMBLEMAX);
+	dlog_end(postamblestr,
+		  postamblecnt);
+
+	if (responseix == sigintix) {
+		if (cldmgr_stop_requested()) {
 			return 0;
 		}
-		sleep( 1 ); /* to allow main thread to begin dialog */
-		mlog( MLOG_NORMAL | MLOG_BARE,
-		      "" ); /* to block until main thread dialog complete */
-		sleep( 1 ); /* to allow main thread to request children die */
-		if ( cldmgr_stop_requested( )) {
+		sleep(1); /* to allow main thread to begin dialog */
+		mlog(MLOG_NORMAL | MLOG_BARE,
+		      ""); /* to block until main thread dialog complete */
+		sleep(1); /* to allow main thread to request children die */
+		if (cldmgr_stop_requested()) {
 			return 0;
 		}
-		mlog( MLOG_DEBUG,
-		      "retrying media label dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying media label dialog\n");
 		goto retry;
 	}
 
 
-	if ( responseix == okix ) {
+	if (responseix == okix) {
 		return bufp;
 	} else {
 		return 0;
@@ -6536,38 +6536,38 @@ retry:
 }
 
 static void
-set_mcflag( ix_t thrdix )
+set_mcflag(ix_t thrdix)
 {
-	lock( );
-	sc_mcflag[ thrdix ] = BOOL_TRUE;
+	lock();
+	sc_mcflag[thrdix] = BOOL_TRUE;
 	content_media_change_needed = BOOL_TRUE;
-	unlock( );
+	unlock();
 }
 
 static void
-clr_mcflag( ix_t thrdix )
+clr_mcflag(ix_t thrdix)
 {
-	lock( );
-	sc_mcflag[ thrdix ] = BOOL_FALSE;
-	for ( thrdix = 0 ; thrdix < drivecnt ; thrdix++ ) {
-		if ( sc_mcflag[ thrdix ] ) {
-			unlock( );
+	lock();
+	sc_mcflag[thrdix] = BOOL_FALSE;
+	for (thrdix = 0 ; thrdix < drivecnt ; thrdix++) {
+		if (sc_mcflag[thrdix]) {
+			unlock();
 			return;
 		}
 	}
 	content_media_change_needed = BOOL_FALSE;
-	unlock( );
+	unlock();
 }
 
 static bool_t
-check_complete_flags( void )
+check_complete_flags(void)
 {
 	ix_t strmix;
 	bool_t completepr = BOOL_TRUE;
 
-	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-		context_t *contextp = &sc_contextp[ strmix ];
-		if ( ! contextp->cc_completepr ) {
+	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+		context_t *contextp = &sc_contextp[strmix];
+		if (! contextp->cc_completepr) {
 			completepr = BOOL_FALSE;
 			break;
 		}
@@ -6591,7 +6591,7 @@ is_quota_file(ino_t ino)
 #define REPQUOTA "xfs_quota"
 
 static bool_t
-save_quotas( char *mntpnt, quota_info_t *quotainfo )
+save_quotas(char *mntpnt, quota_info_t *quotainfo)
 {
         int             sts = 0;
         char            buf[1024] = "";
@@ -6599,50 +6599,50 @@ save_quotas( char *mntpnt, quota_info_t *quotainfo )
         char            tmp;
         struct stat     statb;
 
-        mlog( MLOG_VERBOSE, _(
-		"saving %s information for: %s\n"), quotainfo->desc, mntpnt );
+        mlog(MLOG_VERBOSE, _(
+		"saving %s information for: %s\n"), quotainfo->desc, mntpnt);
 
-        if( unlink( quotainfo->quotapath ) == 0 ) {
-            mlog( MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
+        if(unlink(quotainfo->quotapath) == 0) {
+            mlog(MLOG_WARNING, _("overwriting: %s\n"), quotainfo->quotapath);
         }
         else {
-            if( errno != ENOENT ) {
-                mlog( MLOG_ERROR, _(
+            if(errno != ENOENT) {
+                mlog(MLOG_ERROR, _(
                       "unable to remove %s: %s\n"),
                       quotainfo->quotapath,
-                      strerror( errno ));
+                      strerror(errno));
                 return BOOL_FALSE;
             }
         }
 
-        sprintf( buf,
+        sprintf(buf,
 		 "%s -x -c 'dump %s %s' %s 2> /dev/null",
 		 REPQUOTA,
                  quotainfo->repquotaargs,
                  quotainfo->quotapath,
-                 mntpnt );
+                 mntpnt);
 
-        mlog( MLOG_NITTY, "saving quotas: %s\n", buf );
+        mlog(MLOG_NITTY, "saving quotas: %s\n", buf);
 
-        sts = system( buf );
-        if( sts != 0 ) {
-            mlog( MLOG_ERROR, _(
+        sts = system(buf);
+        if(sts != 0) {
+            mlog(MLOG_ERROR, _(
                   "%s failed with exit status: %d\n"), REPQUOTA,
 		  sts == -1 ? -1 : WEXITSTATUS(sts));
             return BOOL_FALSE;
         }
-        if((fd = open( quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
-            mlog( MLOG_ERROR, _(
+        if((fd = open(quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
+            mlog(MLOG_ERROR, _(
                   "open failed %s: %s\n"),
                   quotainfo->quotapath,
-                  strerror( errno ));
+                  strerror(errno));
             return BOOL_FALSE;
         }
         if(fstat(fd, &statb) < 0) {
-            mlog( MLOG_ERROR, _(
+            mlog(MLOG_ERROR, _(
                   "stat failed %s: %s\n"),
                   quotainfo->quotapath,
-                  strerror( errno ));
+                  strerror(errno));
             close(fd);
             return BOOL_FALSE;
         }
-- 
2.19.1
