Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfANR0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:13 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A47E3BDC1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:12 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/13] xfsdump: (11/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:26 +0100
Message-Id: <20190114172528.65250-12-jtulak@redhat.com>
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
 restore/content.c | 2604 ++++++++++++++++++++++-----------------------
 1 file changed, 1302 insertions(+), 1302 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 24f7e78..930a76c 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -5148,22 +5148,22 @@ pi_insertfile(ix_t drivecnt,
 				       BOOL_TRUE,
 				       prevmfcnt - 1,
 				       BOOL_TRUE,
-				       DH2O( objh )->o_fmfsix - 1,
+				       DH2O(objh)->o_fmfsix - 1,
 				       0,
 				       0,
 				       0,
 				       0,
 				       BOOL_FALSE,
-				       ( off64_t )0 );
-		pi_seeobjstrmend( strmix, mediaix - 1 );
-		pi_lock( );
+				       (off64_t)0);
+		pi_seeobjstrmend(strmix, mediaix - 1);
+		pi_lock();
 	}
 
 	/* if don't know dump stream media file index, can't add any media files
 	 */
-	if ( ! dmfixvalpr ) {
-		pi_unlock( );
-		pi_show( " after pi_insertfile no media file ix" );
+	if (! dmfixvalpr) {
+		pi_unlock();
+		pi_show(" after pi_insertfile no media file ix");
 		return DH_NULL;
 	}
 
@@ -5171,53 +5171,53 @@ pi_insertfile(ix_t drivecnt,
 	 * file list, up to the desired file
 	 */
 	fileh = DH_NULL;
-	for ( fileix = 0 ; fileix <= dumpmediafileix ; fileix++ ) {
+	for (fileix = 0 ; fileix <= dumpmediafileix ; fileix++) {
 		prevfileh = fileh;
-		if ( fileix == 0 ) {
-			fileh = DH2O( objh )->o_cldh;
+		if (fileix == 0) {
+			fileh = DH2O(objh)->o_cldh;
 		} else {
-			fileh = DH2F( prevfileh )->f_nexth;
+			fileh = DH2F(prevfileh)->f_nexth;
 		}
-		if ( fileh == DH_NULL ) {
-			ok = pi_allocdesc( &fileh );
-			if ( ! ok ) {
-				pi_unlock( );
+		if (fileh == DH_NULL) {
+			ok = pi_allocdesc(&fileh);
+			if (! ok) {
+				pi_unlock();
 				return DH_NULL;
 			}
-			DH2F( fileh )->f_parh = objh;
-			if ( fileix == 0 ) {
-				DH2O( objh )->o_cldh = fileh;
+			DH2F(fileh)->f_parh = objh;
+			if (fileix == 0) {
+				DH2O(objh)->o_cldh = fileh;
 			} else {
-				DH2F( prevfileh )->f_nexth = fileh;
+				DH2F(prevfileh)->f_nexth = fileh;
 			}
 		}
 	}
 
 	/* update the media file fields not yet valid
 	 */
-	if ( egrpvalpr && ! DH2F( fileh )->f_valpr ) {
-		assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
-		assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
-		DH2F( fileh )->f_firstegrp.eg_ino = startino;
-		DH2F( fileh )->f_firstegrp.eg_off = startoffset;
-		DH2F( fileh )->f_curegrp = DH2F( fileh )->f_firstegrp;
-		DH2F( fileh )->f_valpr = BOOL_TRUE;
+	if (egrpvalpr && ! DH2F(fileh)->f_valpr) {
+		assert(! (DH2F(fileh)->f_flags & PF_INV));
+		assert(! (DH2F(fileh)->f_flags & PF_TERM));
+		DH2F(fileh)->f_firstegrp.eg_ino = startino;
+		DH2F(fileh)->f_firstegrp.eg_off = startoffset;
+		DH2F(fileh)->f_curegrp = DH2F(fileh)->f_firstegrp;
+		DH2F(fileh)->f_valpr = BOOL_TRUE;
 	}
 
 	/* set flags
 	 */
-	DH2F( fileh )->f_flags = flags;
+	DH2F(fileh)->f_flags = flags;
 
 	/* if we know the file size,
 	 * update it
 	 */
-	if ( fileszvalpr ) {
-		DH2F( fileh )->f_sz = filesz;
-		DH2F( fileh )->f_szvalpr = BOOL_TRUE;
+	if (fileszvalpr) {
+		DH2F(fileh)->f_sz = filesz;
+		DH2F(fileh)->f_szvalpr = BOOL_TRUE;
 	}
 
-	pi_unlock( );
-	pi_show( " after pi_insertfile" );
+	pi_unlock();
+	pi_show(" after pi_insertfile");
 	return fileh;
 }
 
@@ -5227,20 +5227,20 @@ pi_insertfile(ix_t drivecnt,
  */
 /* ARGSUSED */
 static dh_t
-pi_addfile( Media_t *Mediap,
+pi_addfile(Media_t *Mediap,
 	    global_hdr_t *grhdrp,
 	    drive_hdr_t *drhdrp,
 	    media_hdr_t *mrhdrp,
 	    content_inode_hdr_t *scrhdrp,
-	    drive_t * drivep )
+	    drive_t * drivep)
 {
 	dh_t fileh;
 
-	if ( ! persp->s.stat_valpr ) {
+	if (! persp->s.stat_valpr) {
 		persp->s.stat_inocnt = scrhdrp->cih_inomap_nondircnt;
 		persp->s.stat_inodone = 0;
-		assert( scrhdrp->cih_inomap_datasz <= OFF64MAX );
-		persp->s.stat_datacnt = ( off64_t )scrhdrp->cih_inomap_datasz;
+		assert(scrhdrp->cih_inomap_datasz <= OFF64MAX);
+		persp->s.stat_datacnt = (off64_t)scrhdrp->cih_inomap_datasz;
 		persp->s.stat_datadone = 0;
 		persp->s.stat_valpr = BOOL_TRUE;
 	}
@@ -5248,8 +5248,8 @@ pi_addfile( Media_t *Mediap,
 	/* if we see a terminator, we know we have seen the end of
 	 * a stream.
 	 */
-	if ( MEDIA_TERMINATOR_CHK( mrhdrp )) {
-		fileh = pi_insertfile( drhdrp->dh_drivecnt,
+	if (MEDIA_TERMINATOR_CHK(mrhdrp)) {
+		fileh = pi_insertfile(drhdrp->dh_drivecnt,
 				       drhdrp->dh_driveix,
 				       mrhdrp->mh_mediaix,
 				       BOOL_TRUE,
@@ -5265,25 +5265,25 @@ pi_addfile( Media_t *Mediap,
 				       BOOL_TRUE,
 				       mrhdrp->mh_dumpfileix,
 				       BOOL_FALSE,
-				       ( xfs_ino_t )0,
-				       ( off64_t )0,
+				       (xfs_ino_t)0,
+				       (off64_t)0,
 				       PF_TERM,
 				       BOOL_FALSE,
-				       ( off64_t )0 );
-		if ( fileh == DH_NULL ) {
+				       (off64_t)0);
+		if (fileh == DH_NULL) {
 			return DH_NULL;
 		}
-		pi_seestrmend( drhdrp->dh_driveix );
-		pi_seeobjstrmend( drhdrp->dh_driveix, mrhdrp->mh_mediaix );
+		pi_seestrmend(drhdrp->dh_driveix);
+		pi_seeobjstrmend(drhdrp->dh_driveix, mrhdrp->mh_mediaix);
 		return fileh;
 	}
 
 	/* data file
 	 */
-	if ( scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_DATA ) {
+	if (scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_DATA) {
 		/* tell the inventory about this media file
 		 */
-		fileh = pi_insertfile( drhdrp->dh_drivecnt,
+		fileh = pi_insertfile(drhdrp->dh_drivecnt,
 				       drhdrp->dh_driveix,
 				       mrhdrp->mh_mediaix,
 				       BOOL_TRUE,
@@ -5303,17 +5303,17 @@ pi_addfile( Media_t *Mediap,
 				       scrhdrp->cih_startpt.sp_offset,
 				       0,
 				       BOOL_FALSE,
-				       ( off64_t )0 );
-		if ( fileh == DH_NULL ) {
+				       (off64_t)0);
+		if (fileh == DH_NULL) {
 			return DH_NULL;
 		}
-		assert( drhdrp->dh_drivecnt > 0 );
-		if ( drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1 ) {
+		assert(drhdrp->dh_drivecnt > 0);
+		if (drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1) {
 			/* if this is not in the last stream, we know
 			 * there is at least one other media file in
 			 * the following stream, and we know its start pt
 			 */
-			( void )pi_insertfile( drhdrp->dh_drivecnt,
+			(void)pi_insertfile(drhdrp->dh_drivecnt,
 					       drhdrp->dh_driveix + 1,
 					       0,
 					       BOOL_FALSE,
@@ -5333,14 +5333,14 @@ pi_addfile( Media_t *Mediap,
 					       scrhdrp->cih_endpt.sp_offset,
 					       0,
 					       BOOL_FALSE,
-					       ( off64_t )0 );
+					       (off64_t)0);
 		}
-		if ( ! ( drivep->d_capabilities & DRIVE_CAP_FILES )) {
+		if (! (drivep->d_capabilities & DRIVE_CAP_FILES)) {
 			/* if drive does not support multiple files,
 			 * we know this is end of object and stream
 			 */
-			pi_seestrmend( drhdrp->dh_driveix );
-			pi_seeobjstrmend( drhdrp->dh_driveix, mrhdrp->mh_mediaix );
+			pi_seestrmend(drhdrp->dh_driveix);
+			pi_seeobjstrmend(drhdrp->dh_driveix, mrhdrp->mh_mediaix);
 		}
 
 		return fileh;
@@ -5348,8 +5348,8 @@ pi_addfile( Media_t *Mediap,
 
 	/* inventory file
 	 */
-	if ( scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_INVENTORY ) {
-		fileh = pi_insertfile( drhdrp->dh_drivecnt,
+	if (scrhdrp->cih_mediafiletype == CIH_MEDIAFILETYPE_INVENTORY) {
+		fileh = pi_insertfile(drhdrp->dh_drivecnt,
 				       drhdrp->dh_driveix,
 				       mrhdrp->mh_mediaix,
 				       BOOL_TRUE,
@@ -5365,19 +5365,19 @@ pi_addfile( Media_t *Mediap,
 				       BOOL_TRUE,
 				       mrhdrp->mh_dumpfileix,
 				       BOOL_FALSE,
-				       ( xfs_ino_t )0,
-				       ( off64_t )0,
+				       (xfs_ino_t)0,
+				       (off64_t)0,
 					PF_INV,
 					BOOL_FALSE,
-					( off64_t )0 );
-		if ( fileh == DH_NULL ) {
+					(off64_t)0);
+		if (fileh == DH_NULL) {
 			return DH_NULL;
 		}
-		pi_seestrmend( drhdrp->dh_driveix );
-		pi_seeobjstrmend( drhdrp->dh_driveix,
-				  mrhdrp->mh_mediaix );
-		if ( drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1 ) {
-			( void )pi_insertfile( drhdrp->dh_drivecnt,
+		pi_seestrmend(drhdrp->dh_driveix);
+		pi_seeobjstrmend(drhdrp->dh_driveix,
+				  mrhdrp->mh_mediaix);
+		if (drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1) {
+			(void)pi_insertfile(drhdrp->dh_drivecnt,
 					       drhdrp->dh_driveix + 1,
 					       0,
 					       BOOL_FALSE,
@@ -5397,11 +5397,11 @@ pi_addfile( Media_t *Mediap,
 					       scrhdrp->cih_endpt.sp_offset,
 					       0,
 					       BOOL_FALSE,
-					       ( off64_t )0 );
+					       (off64_t)0);
 		}
-		if ( ! persp->s.fullinvpr
+		if (! persp->s.fullinvpr
 		     &&
-		     Mediap->M_pos == POS_ATHDR ) {
+		     Mediap->M_pos == POS_ATHDR) {
 			size_t bufszincr;
 			size_t bufsz;
 			size_t buflen;
@@ -5419,7 +5419,7 @@ pi_addfile( Media_t *Mediap,
 				 */
 			bufsz = bufszincr;
 			buflen = 0;
-			bufp = ( char * )malloc( bufsz );
+			bufp = (char *)malloc(bufsz);
 
 			/* need to read until we hit EOF/EOD. that's the only
 			 * way to know how big the inventory is. mark the Media
@@ -5427,32 +5427,32 @@ pi_addfile( Media_t *Mediap,
 			 */
 			Mediap->M_pos = POS_ATNONDIR;
 			donepr = BOOL_FALSE;
-			while ( ! donepr ) {
+			while (! donepr) {
 				int nread;
 				drive_ops_t *dop = drivep->d_opsp;
 				int rval = 0;
-				nread = read_buf( bufp + buflen,
+				nread = read_buf(bufp + buflen,
 						  bufszincr,
-						  ( void * )drivep,
-						  ( rfp_t )dop->do_read,
-					    ( rrbfp_t )dop->do_return_read_buf,
-						  &rval );
-				switch( rval ) {
+						  (void *)drivep,
+						  (rfp_t)dop->do_read,
+					    (rrbfp_t)dop->do_return_read_buf,
+						  &rval);
+				switch(rval) {
 				case 0:
-					assert( nread == ( int )bufszincr );
-					buflen += ( size_t )nread;
+					assert(nread == (int)bufszincr);
+					buflen += (size_t)nread;
 					bufsz += bufszincr;
-					bufp = ( char * )realloc(( void * )bufp,
-								 bufsz );
-					assert( bufp );
+					bufp = (char *)realloc((void *)bufp,
+								 bufsz);
+					assert(bufp);
 					continue;
 				case DRIVE_ERROR_EOD:
 				case DRIVE_ERROR_EOF:
-					buflen += ( size_t )nread;
+					buflen += (size_t)nread;
 					donepr = BOOL_TRUE;
 					break;
 				default:
-					free( ( void * )bufp );
+					free((void *)bufp);
 					return fileh;
 				}
 			}
@@ -5461,62 +5461,62 @@ pi_addfile( Media_t *Mediap,
 			 * desc.
 			 */
 			sessp = 0;
-			if ( ! buflen ) {
+			if (! buflen) {
 				ok = BOOL_FALSE;
 			} else {
 			    /* extract the session information from the buffer */
-			    if ( stobj_unpack_sessinfo( bufp, buflen, &sessinfo )<0 ) {
+			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
 				ok = BOOL_FALSE;
 			    } else {
 				stobj_convert_sessinfo(&sessp, &sessinfo);
 				ok = BOOL_TRUE;
 			    }
 			}
-			if ( ! ok || ! sessp ) {
-				mlog( MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
+			if (! ok || ! sessp) {
+				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
 				      "on-media session "
-				      "inventory corrupt\n") );
+				      "inventory corrupt\n"));
 			} else {
 				/* if root, update online inventory.
 				 */
-				if ( ! geteuid( )
+				if (! geteuid()
 				     &&
-				     ! tranp->t_noinvupdatepr ) {
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+				     ! tranp->t_noinvupdatepr) {
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 					      "incorporating on-media session "
 					      "inventory into online "
-					      "inventory\n") );
-					inv_put_sessioninfo( &sessinfo );
+					      "inventory\n"));
+					inv_put_sessioninfo(&sessinfo);
 				}
 
 				/* convert into pi format
 				 */
-				mlog( MLOG_VERBOSE | MLOG_MEDIA,
-				      "using on-media session inventory\n" );
-				persp->s.fullinvpr = pi_transcribe( sessp );
-				inv_free_session( &sessp );
+				mlog(MLOG_VERBOSE | MLOG_MEDIA,
+				      "using on-media session inventory\n");
+				persp->s.fullinvpr = pi_transcribe(sessp);
+				inv_free_session(&sessp);
 			}
-			free( ( void * )bufp );
+			free((void *)bufp);
 		}
 		return fileh;
 	}
 
-	assert( 0 );
+	assert(0);
 	return DH_NULL;
 }
 
 /* translate a session inventory into a pi
  */
 static bool_t
-pi_transcribe( inv_session_t *sessp )
+pi_transcribe(inv_session_t *sessp)
 {
 	ix_t strmcnt;
 	ix_t strmix;
 
 	/* traverse inventory, transcribing into pers inv.
 	 */
-	strmcnt =  ( size_t )sessp->s_nstreams;
-	for ( strmix = 0 ; strmix < strmcnt ; strmix++ ) {
+	strmcnt =  (size_t)sessp->s_nstreams;
+	for (strmix = 0 ; strmix < strmcnt ; strmix++) {
 		inv_stream_t *strmp;
 		size_t fileix;
 		size_t filecnt;
@@ -5525,33 +5525,33 @@ pi_transcribe( inv_session_t *sessp )
 		ix_t mediaix;
 		size_t dumpmediafileix;
 
-		strmp = &sessp->s_streams[ strmix ];
+		strmp = &sessp->s_streams[strmix];
 		filecnt = strmp->st_nmediafiles;
                 uuid_clear(lastobjid);
-		lastobjlabel[ 0 ] = 0;
+		lastobjlabel[0] = 0;
 		mediaix = 0;
 		dumpmediafileix = 0;
 
 		/* insert all media files from this stream. note that
 		 * the media object representation is inverted
 		 */
-		for ( fileix = 0 ; fileix < filecnt ; fileix++ ) {
+		for (fileix = 0 ; fileix < filecnt ; fileix++) {
 			inv_mediafile_t *filep;
 			bool_t fileszvalpr;
 
-			filep = &strmp->st_mediafiles[ fileix ];
-			if ( uuid_compare( filep->m_moid,
-					   lastobjid ) != 0) {
+			filep = &strmp->st_mediafiles[fileix];
+			if (uuid_compare(filep->m_moid,
+					   lastobjid) != 0) {
 				dumpmediafileix = 0;
-				if ( fileix != 0 ) {
-					pi_seeobjstrmend( strmix, mediaix );
+				if (fileix != 0) {
+					pi_seeobjstrmend(strmix, mediaix);
 					mediaix++;
 				}
 			}
 
 			fileszvalpr = BOOL_TRUE;
 
-			( void )pi_insertfile( strmcnt,
+			(void)pi_insertfile(strmcnt,
 					       strmix,
 					       mediaix,
 					       BOOL_TRUE,
@@ -5579,15 +5579,15 @@ pi_transcribe( inv_session_t *sessp )
 					       :
 					       0,
 					       fileszvalpr,
-					       filep->m_size );
+					       filep->m_size);
 			uuid_copy(lastobjid, filep->m_moid);
-			strncpy( lastobjlabel,
+			strncpy(lastobjlabel,
 				 filep->m_label,
-				 sizeof( lastobjlabel ));
+				 sizeof(lastobjlabel));
 			dumpmediafileix++;
 		}
-		pi_seestrmend( strmix );
-		pi_seeobjstrmend( strmix, mediaix );
+		pi_seestrmend(strmix);
+		pi_seeobjstrmend(strmix, mediaix);
 	}
 
 	return BOOL_TRUE;
@@ -5597,29 +5597,29 @@ pi_transcribe( inv_session_t *sessp )
  * be set from previously interrupted invocation.
  */
 static void
-pi_preclean( void )
+pi_preclean(void)
 {
 	dh_t strmh;
 	dh_t objh;
 	dh_t fileh;
 
-	for ( strmh = persp->s.strmheadh
+	for (strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth ) {
-		for ( objh = DH2S( strmh )->s_cldh
+	      strmh = DH2S(strmh)->s_nexth) {
+		for (objh = DH2S(strmh)->s_cldh
 		      ;
 		      objh != DH_NULL
 		      ;
-		      objh = DH2O( objh )->o_nexth ) {
-			DH2O( objh )->o_indrivepr = BOOL_FALSE;
-			for ( fileh = DH2O( objh )->o_cldh
+		      objh = DH2O(objh)->o_nexth) {
+			DH2O(objh)->o_indrivepr = BOOL_FALSE;
+			for (fileh = DH2O(objh)->o_cldh
 			      ;
 			      fileh != DH_NULL
 			      ;
-			      fileh = DH2F( fileh )->f_nexth ) {
-				DH2F( fileh )->f_underheadpr = BOOL_FALSE;
+			      fileh = DH2F(fileh)->f_nexth) {
+				DH2F(fileh)->f_underheadpr = BOOL_FALSE;
 			}
 		}
 	}
@@ -5628,201 +5628,201 @@ pi_preclean( void )
 /* tell pi no media objects are in this drive
  */
 static void
-pi_driveempty( ix_t driveix )
+pi_driveempty(ix_t driveix)
 {
 	dh_t strmh;
 	dh_t objh;
 	dh_t fileh;
 
-	pi_lock( );
+	pi_lock();
 
-	for ( strmh = persp->s.strmheadh
+	for (strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth ) {
-		for ( objh = DH2S( strmh )->s_cldh
+	      strmh = DH2S(strmh)->s_nexth) {
+		for (objh = DH2S(strmh)->s_cldh
 		      ;
 		      objh != DH_NULL
 		      ;
-		      objh = DH2O( objh )->o_nexth ) {
-			if ( DH2O( objh )->o_indrivepr
+		      objh = DH2O(objh)->o_nexth) {
+			if (DH2O(objh)->o_indrivepr
 			     &&
-			     DH2O( objh )->o_indriveix == driveix ) {
-				DH2O( objh )->o_indrivepr = BOOL_FALSE;
-				for ( fileh = DH2O( objh )->o_cldh
+			     DH2O(objh)->o_indriveix == driveix) {
+				DH2O(objh)->o_indrivepr = BOOL_FALSE;
+				for (fileh = DH2O(objh)->o_cldh
 				      ;
 				      fileh != DH_NULL
 				      ;
-				      fileh = DH2F( fileh )->f_nexth ) {
-					DH2F( fileh )->f_underheadpr =
+				      fileh = DH2F(fileh)->f_nexth) {
+					DH2F(fileh)->f_underheadpr =
 								    BOOL_FALSE;
 				}
 			}
 		}
 	}
 
-	pi_unlock( );
+	pi_unlock();
 }
 
 /* tell pi this media object is in the drive
  */
 static void
-pi_note_indrive( ix_t driveix, uuid_t media_id )
+pi_note_indrive(ix_t driveix, uuid_t media_id)
 {
 	dh_t strmh;
 	dh_t objh;
 
-	pi_lock( );
+	pi_lock();
 
-	for ( strmh = persp->s.strmheadh
+	for (strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth ) {
-		for ( objh = DH2S( strmh )->s_cldh
+	      strmh = DH2S(strmh)->s_nexth) {
+		for (objh = DH2S(strmh)->s_cldh
 		      ;
 		      objh != DH_NULL
 		      ;
-		      objh = DH2O( objh )->o_nexth ) {
-			if ( DH2O( objh )->o_idlabvalpr
+		      objh = DH2O(objh)->o_nexth) {
+			if (DH2O(objh)->o_idlabvalpr
 			     &&
-			     uuid_compare( DH2O( objh )->o_id, media_id) == 0) {
-				DH2O( objh )->o_indrivepr = BOOL_TRUE;
-				DH2O( objh )->o_indriveix = driveix;
+			     uuid_compare(DH2O(objh)->o_id, media_id) == 0) {
+				DH2O(objh)->o_indrivepr = BOOL_TRUE;
+				DH2O(objh)->o_indriveix = driveix;
 				goto done;
 			}
 		}
 	}
 
 done:
-	pi_unlock( );
+	pi_unlock();
 }
 
 /* tell pi this media file is under the head of the drive containing the object
  */
 static void
-pi_note_underhead( dh_t thisobjh, dh_t thisfileh )
+pi_note_underhead(dh_t thisobjh, dh_t thisfileh)
 {
 	dh_t fileh;
 
-	if ( thisobjh == DH_NULL ) {
+	if (thisobjh == DH_NULL) {
 		return;
 	}
 
-	pi_lock( );
+	pi_lock();
 
-	if ( thisfileh != DH_NULL ) {
-		DH2F( thisfileh )->f_underheadpr = BOOL_TRUE;
+	if (thisfileh != DH_NULL) {
+		DH2F(thisfileh)->f_underheadpr = BOOL_TRUE;
 	}
 
-	for ( fileh = DH2O( thisobjh )->o_cldh
+	for (fileh = DH2O(thisobjh)->o_cldh
 	      ;
 	      fileh != DH_NULL
 	      ;
-	      fileh = DH2F( fileh )->f_nexth ) {
-		if ( fileh != thisfileh ) {
-			DH2F( fileh )->f_underheadpr = BOOL_FALSE;
+	      fileh = DH2F(fileh)->f_nexth) {
+		if (fileh != thisfileh) {
+			DH2F(fileh)->f_underheadpr = BOOL_FALSE;
 		}
 	}
 
-	pi_unlock( );
+	pi_unlock();
 }
 
 /* mark the pi stream indicating all objects in that stream are known.
  */
 static void
-pi_seestrmend( ix_t strmix )
+pi_seestrmend(ix_t strmix)
 {
 	ix_t ix;
 	dh_t strmh;
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
 
 	/* if an empty stream (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
-	if ( strmh == DH_NULL ) {
-		pi_unlock( );
+	if (strmh == DH_NULL) {
+		pi_unlock();
 		return;
 	}
 
 	/* set stream flag and object and file counts
 	 */
-	DH2S( strmh )->s_lastobjknwnpr = BOOL_TRUE;
+	DH2S(strmh)->s_lastobjknwnpr = BOOL_TRUE;
 
-	pi_unlock( );
-	pi_show( " after pi_seestrmend" );
+	pi_unlock();
+	pi_show(" after pi_seestrmend");
 }
 
 /* mark pi indicating all media files in object are known
  */
 static void
-pi_seeobjstrmend( ix_t strmix, ix_t mediaix )
+pi_seeobjstrmend(ix_t strmix, ix_t mediaix)
 {
 	ix_t ix;
 	dh_t strmh;
 	dh_t objh;
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
 
 	/* if an empty stream (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
-	if ( strmh == DH_NULL ) {
-		pi_unlock( );
+	if (strmh == DH_NULL) {
+		pi_unlock();
 		return;
 	}
 
 
 	/* get handle to indexed object in stream
 	 */
-	for ( ix = 0,
-	      objh = DH2S( strmh )->s_cldh
+	for (ix = 0,
+	      objh = DH2S(strmh)->s_cldh
 	      ;
 	      objh != DH_NULL && ix < mediaix
 	      ;
 	      ix++,
-	      objh = DH2O( objh )->o_nexth )
+	      objh = DH2O(objh)->o_nexth)
 		;
 
 	/* if an empty object (can happen when dump interrupted),
 	 * nothing need be done, so return
 	 */
-	if ( objh == DH_NULL ) {
-		pi_unlock( );
+	if (objh == DH_NULL) {
+		pi_unlock();
 		return;
 	}
 
 
 	/* set object flag
 	 */
-	DH2O( objh )->o_lmfknwnpr = BOOL_TRUE;
+	DH2O(objh)->o_lmfknwnpr = BOOL_TRUE;
 
-	pi_unlock( );
-	pi_show( " after pi_seeobjstrmend" );
+	pi_unlock();
+	pi_show(" after pi_seeobjstrmend");
 }
 
 /* scans pi to determine ino of last file wholly or partially contained on
@@ -5830,53 +5830,53 @@ pi_seeobjstrmend( ix_t strmix, ix_t mediaix )
  * NOTE: assumes caller locks pi!
  */
 static xfs_ino_t
-pi_scanfileendino( dh_t fileh )
+pi_scanfileendino(dh_t fileh)
 {
 	dh_t strmh;
 	ix_t mode = 0;
 
-	assert( fileh != DH_NULL );
+	assert(fileh != DH_NULL);
 
 	/* traverse the pi tree, looking for the next media file after
 	 */
-	for ( strmh = persp->s.strmheadh
+	for (strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth ) {
+	      strmh = DH2S(strmh)->s_nexth) {
 	    dh_t objh;
 
-	    for ( objh = DH2S( strmh )->s_cldh
+	    for (objh = DH2S(strmh)->s_cldh
 		  ;
 		  objh != DH_NULL
 		  ;
-		  objh = DH2O( objh )->o_nexth ) {
+		  objh = DH2O(objh)->o_nexth) {
 		dh_t nexth;
 
-		for ( nexth = DH2O( objh )->o_cldh
+		for (nexth = DH2O(objh)->o_cldh
 		      ;
 		      nexth != DH_NULL
 		      ;
-		      nexth = DH2F( nexth )->f_nexth ) {
+		      nexth = DH2F(nexth)->f_nexth) {
 
-		    switch( mode ) {
+		    switch(mode) {
 		    case 0:
-			if ( nexth == fileh ) {
+			if (nexth == fileh) {
 				mode = 1;
 			}
 			break;
 		    default:
-			if ( DH2F( nexth )->f_valpr ) {
+			if (DH2F(nexth)->f_valpr) {
 			    xfs_ino_t ino;
 
-			    assert( ! ( DH2F( nexth )->f_flags & PF_INV ));
-			    assert( ! ( DH2F( nexth )->f_flags & PF_TERM ));
-			    if ( DH2F( nexth )->f_firstegrp.eg_off ) {
-				ino =  DH2F( nexth )->f_firstegrp.eg_ino;
+			    assert(! (DH2F(nexth)->f_flags & PF_INV));
+			    assert(! (DH2F(nexth)->f_flags & PF_TERM));
+			    if (DH2F(nexth)->f_firstegrp.eg_off) {
+				ino =  DH2F(nexth)->f_firstegrp.eg_ino;
 				return ino;
 			    } else {
-				assert( DH2F( nexth )->f_firstegrp.eg_ino > 0 );
-				ino =  DH2F( nexth )->f_firstegrp.eg_ino - 1;
+				assert(DH2F(nexth)->f_firstegrp.eg_ino > 0);
+				ino =  DH2F(nexth)->f_firstegrp.eg_ino - 1;
 				return ino;
 			    }
 			}
@@ -5892,7 +5892,7 @@ pi_scanfileendino( dh_t fileh )
  * from media file. *--o
  */
 static void
-pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
+pi_bracketneededegrps(dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp)
 {
 	dh_t strmh;
 	bool_t thisfoundpr = BOOL_FALSE;
@@ -5900,44 +5900,44 @@ pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
 	dh_t follh = DH_NULL;
 
 
-	assert( thisfileh != DH_NULL );
+	assert(thisfileh != DH_NULL);
 
 	/* traverse the pi tree, looking for fileh
 	 */
-	pi_lock( );
-	assert( DH2F( thisfileh )->f_valpr );
+	pi_lock();
+	assert(DH2F(thisfileh)->f_valpr);
 
-	for ( strmh = persp->s.strmheadh
+	for (strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth ) {
+	      strmh = DH2S(strmh)->s_nexth) {
 	    dh_t objh;
 
-	    for ( objh = DH2S( strmh )->s_cldh
+	    for (objh = DH2S(strmh)->s_cldh
 		  ;
 		  objh != DH_NULL
 		  ;
-		  objh = DH2O( objh )->o_nexth ) {
+		  objh = DH2O(objh)->o_nexth) {
 		dh_t fileh;
 
-		for ( fileh = DH2O( objh )->o_cldh
+		for (fileh = DH2O(objh)->o_cldh
 		      ;
 		      fileh != DH_NULL
 		      ;
-		      fileh = DH2F( fileh )->f_nexth ) {
-		    if ( ! thisfoundpr ) {
-			if ( fileh == thisfileh ) {
+		      fileh = DH2F(fileh)->f_nexth) {
+		    if (! thisfoundpr) {
+			if (fileh == thisfileh) {
 			    thisfoundpr = BOOL_TRUE;
-			} else if ( DH2F( fileh )->f_valpr ) {
-			    assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
-			    assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
+			} else if (DH2F(fileh)->f_valpr) {
+			    assert(! (DH2F(fileh)->f_flags & PF_INV));
+			    assert(! (DH2F(fileh)->f_flags & PF_TERM));
 			    prech = fileh;
 			}
-		    } else if ( DH2F( fileh )->f_valpr ) {
-			assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
-			assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
-			assert( follh == DH_NULL );
+		    } else if (DH2F(fileh)->f_valpr) {
+			assert(! (DH2F(fileh)->f_flags & PF_INV));
+			assert(! (DH2F(fileh)->f_flags & PF_TERM));
+			assert(follh == DH_NULL);
 			follh = fileh;
 			goto done;
 		    }
@@ -5946,21 +5946,21 @@ pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
 	}
 done:
 
-	assert( thisfoundpr );
+	assert(thisfoundpr);
 
 	/* initially the lower bracket is this file descriptor's
 	 * current egrp. this catches the case where a previous restore
 	 * session was interrupted while restoring this media file.
 	 */
-	*first_egrp = DH2F( thisfileh )->f_curegrp;
+	*first_egrp = DH2F(thisfileh)->f_curegrp;
 
 	/* if the closest valid preceeding media file's current egrp is
 	 * greater, use it as the lower bracket
 	 */
-	if ( prech != DH_NULL
+	if (prech != DH_NULL
 	     &&
-	     egrpcmp( &DH2F( prech )->f_curegrp, first_egrp ) > 0 ) {
-		*first_egrp = DH2F( prech )->f_curegrp;
+	     egrpcmp(&DH2F(prech)->f_curegrp, first_egrp) > 0) {
+		*first_egrp = DH2F(prech)->f_curegrp;
 	}
 
 	/* the upper bracket is initially the end of the world.
@@ -5970,25 +5970,25 @@ done:
 	 */
 	next_egrp->eg_ino = INO64MAX;
 	next_egrp->eg_off = OFF64MAX;
-	if ( follh != DH_NULL
+	if (follh != DH_NULL
 	     &&
-	     egrpcmp( &DH2F( follh )->f_curegrp, &DH2F( follh )->f_firstegrp )
+	     egrpcmp(&DH2F(follh)->f_curegrp, &DH2F(follh)->f_firstegrp)
 	     >
-	     0 ) {
-		*next_egrp = DH2F( follh )->f_firstegrp;
+	     0) {
+		*next_egrp = DH2F(follh)->f_firstegrp;
 	}
 
-	pi_unlock( );
+	pi_unlock();
 }
 
 static void
-pi_update_stats( off64_t sz )
+pi_update_stats(off64_t sz)
 {
-	pi_lock( );
-	assert( persp->s.stat_valpr );
+	pi_lock();
+	assert(persp->s.stat_valpr);
 	persp->s.stat_inodone++;
 	persp->s.stat_datadone += sz;
-	pi_unlock( );
+	pi_unlock();
 }
 
 /* pi_iterator - each invocation of the iterator advances to the next media file
@@ -6012,92 +6012,92 @@ struct pi_iter {
 typedef struct pi_iter pi_iter_t;
 
 static pi_iter_t *
-pi_iter_alloc( void )
+pi_iter_alloc(void)
 {
 	pi_iter_t *iterp;
 
-	iterp = ( pi_iter_t * )calloc( 1, sizeof( pi_iter_t ));
-	assert( iterp );
+	iterp = (pi_iter_t *)calloc(1, sizeof(pi_iter_t));
+	assert(iterp);
 	return iterp;
 }
 
 static void
-pi_iter_free( pi_iter_t *iterp )
+pi_iter_free(pi_iter_t *iterp)
 {
-	free( ( void * )iterp );
+	free((void *)iterp);
 }
 
 static dh_t
-pi_iter_nextfileh( pi_iter_t *iterp,
+pi_iter_nextfileh(pi_iter_t *iterp,
 		   bool_t *objmissingprp,
-		   bool_t *filemissingprp )
+		   bool_t *filemissingprp)
 {
-	assert( ! iterp->donepr );
+	assert(! iterp->donepr);
 
-	if ( persp->s.strmheadh == DH_NULL ) {
+	if (persp->s.strmheadh == DH_NULL) {
 		iterp->donepr = BOOL_TRUE;
 		return DH_NULL;
 	}
 
-	if ( ! iterp->initializedpr ) {
-		assert( persp->s.strmheadh != DH_NULL );
+	if (! iterp->initializedpr) {
+		assert(persp->s.strmheadh != DH_NULL);
 		iterp->strmh = persp->s.strmheadh;
-		iterp->objh = DH2S( iterp->strmh )->s_cldh;
-		if ( iterp->objh == DH_NULL ) {
-			if ( ! DH2S( iterp->strmh )->s_lastobjknwnpr ) {
+		iterp->objh = DH2S(iterp->strmh)->s_cldh;
+		if (iterp->objh == DH_NULL) {
+			if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
 				*objmissingprp = BOOL_TRUE;
 			}
 		} else {
-			iterp->fileh = DH2O( iterp->objh )->o_cldh;
-			if ( iterp->fileh == DH_NULL ) {
-				if ( ! DH2O( iterp->objh )->o_lmfknwnpr ) {
+			iterp->fileh = DH2O(iterp->objh)->o_cldh;
+			if (iterp->fileh == DH_NULL) {
+				if (! DH2O(iterp->objh)->o_lmfknwnpr) {
 					*filemissingprp = BOOL_TRUE;
 				}
 			}
 		}
 
-		while ( iterp->fileh == DH_NULL ) {
-			while ( iterp->objh == DH_NULL ) {
-				if ( ! DH2S( iterp->strmh )->s_lastobjknwnpr ) {
+		while (iterp->fileh == DH_NULL) {
+			while (iterp->objh == DH_NULL) {
+				if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
 					*objmissingprp = BOOL_TRUE;
 				}
-				iterp->strmh = DH2S( iterp->strmh )->s_nexth;
-				if ( iterp->strmh == DH_NULL ) {
+				iterp->strmh = DH2S(iterp->strmh)->s_nexth;
+				if (iterp->strmh == DH_NULL) {
 					iterp->donepr = BOOL_TRUE;
 					return DH_NULL;
 				}
-				iterp->objh = DH2S( iterp->strmh )->s_cldh;
+				iterp->objh = DH2S(iterp->strmh)->s_cldh;
 			}
-			iterp->fileh = DH2O( iterp->objh )->o_cldh;
-			if ( iterp->fileh == DH_NULL ) {
-				if ( ! DH2O( iterp->objh )->o_lmfknwnpr ) {
+			iterp->fileh = DH2O(iterp->objh)->o_cldh;
+			if (iterp->fileh == DH_NULL) {
+				if (! DH2O(iterp->objh)->o_lmfknwnpr) {
 					*filemissingprp = BOOL_TRUE;
 				}
-				iterp->objh = DH2O( iterp->objh )->o_nexth;
+				iterp->objh = DH2O(iterp->objh)->o_nexth;
 			}
 		}
 		iterp->initializedpr = BOOL_TRUE;
 		return iterp->fileh;
 	}
 
-	iterp->fileh = DH2F( iterp->fileh )->f_nexth;
-	while ( iterp->fileh == DH_NULL ) {
-		if ( ! DH2O( iterp->objh )->o_lmfknwnpr ) {
+	iterp->fileh = DH2F(iterp->fileh)->f_nexth;
+	while (iterp->fileh == DH_NULL) {
+		if (! DH2O(iterp->objh)->o_lmfknwnpr) {
 			*filemissingprp = BOOL_TRUE;
 		}
-		iterp->objh = DH2O( iterp->objh )->o_nexth;
-		while ( iterp->objh == DH_NULL ) {
-			if ( ! DH2S( iterp->strmh )->s_lastobjknwnpr ) {
+		iterp->objh = DH2O(iterp->objh)->o_nexth;
+		while (iterp->objh == DH_NULL) {
+			if (! DH2S(iterp->strmh)->s_lastobjknwnpr) {
 				*objmissingprp = BOOL_TRUE;
 			}
-			iterp->strmh = DH2S( iterp->strmh )->s_nexth;
-			if ( iterp->strmh == DH_NULL ) {
+			iterp->strmh = DH2S(iterp->strmh)->s_nexth;
+			if (iterp->strmh == DH_NULL) {
 				iterp->donepr = BOOL_TRUE;
 				return DH_NULL;
 			}
-			iterp->objh = DH2S( iterp->strmh )->s_cldh;
+			iterp->objh = DH2S(iterp->strmh)->s_cldh;
 		}
-		iterp->fileh = DH2O( iterp->objh )->o_cldh;
+		iterp->fileh = DH2O(iterp->objh)->o_cldh;
 	}
 
 	return iterp->fileh;
@@ -6121,10 +6121,10 @@ struct bagobj {
 typedef struct bagobj bagobj_t;
 
 static bag_t *
-pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
+pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 			    bool_t *maybeholesprp,
 			    bool_t showobjindrivepr,
-			    bool_t markskippr )
+			    bool_t markskippr)
 {
 	bag_t *bagp;
 	pi_iter_t *headiterp;
@@ -6140,21 +6140,21 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 
 	/* no point in proceeding if pi not begun
 	 */
-	if ( persp->s.strmheadh == DH_NULL ) {
+	if (persp->s.strmheadh == DH_NULL) {
 		*knownholesprp = BOOL_TRUE;
 		*maybeholesprp = BOOL_FALSE;
 		return 0;
 	}
 
 	/* to hold a list of media object handles: caller must free
-	 * using pi_neededobjs_free( ).
+	 * using pi_neededobjs_free().
 	 */
-	bagp = bag_alloc( );
+	bagp = bag_alloc();
 
 	/* allocate two iterators to scan pi
 	 */
-	tailiterp = pi_iter_alloc( );
-	headiterp = pi_iter_alloc( );
+	tailiterp = pi_iter_alloc();
+	headiterp = pi_iter_alloc();
 
 	/* set the handle to the last file added to the list to NULL.
 	 * this will be updated each time we add an object to the list,
@@ -6185,7 +6185,7 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 
 	/* lock up the inventory during the scan
 	 */
-	pi_lock( );
+	pi_lock();
 
 	do {
 		egrp_t headegrp;
@@ -6197,23 +6197,23 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 		do {
 			bool_t dummyobjmissingpr;
 			bool_t dummyfilemissingpr;
-			headh = pi_iter_nextfileh( headiterp,
+			headh = pi_iter_nextfileh(headiterp,
 						   &dummyobjmissingpr,
-						   &dummyfilemissingpr );
-		} while ( headh != DH_NULL && ! DH2F( headh )->f_valpr );
-		if ( headh == DH_NULL ) {
+						   &dummyfilemissingpr);
+		} while (headh != DH_NULL && ! DH2F(headh)->f_valpr);
+		if (headh == DH_NULL) {
 			headegrp.eg_ino = INO64MAX;
 			headegrp.eg_off = OFF64MAX;
 		} else {
-			assert( ! ( DH2F( headh )->f_flags & PF_INV ));
-			assert( ! ( DH2F( headh )->f_flags & PF_TERM ));
-			headegrp = DH2F( headh )->f_firstegrp;
+			assert(! (DH2F(headh)->f_flags & PF_INV));
+			assert(! (DH2F(headh)->f_flags & PF_TERM));
+			headegrp = DH2F(headh)->f_firstegrp;
 		}
 
 		/* see if the range of egrps from head up to but not including
 		 * tail needed according to ino map
 		 */
-		if ( gapneeded( &tailegrp, &headegrp )) {
+		if (gapneeded(&tailegrp, &headegrp)) {
 			foundgappr = BOOL_TRUE;
 		} else {
 			foundgappr = BOOL_FALSE;
@@ -6226,46 +6226,46 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 		do {
 		    /* if requested, mark media files not needed
 		     */
-		    if ( markskippr
+		    if (markskippr
 			 &&
 			 ! foundgappr
 			 &&
 			 tailh != DH_NULL
 			 &&
-			 ! ( DH2F( tailh )->f_flags & PF_INV )
+			 ! (DH2F(tailh)->f_flags & PF_INV)
 			 &&
-			 ! ( DH2F( tailh )->f_flags & PF_TERM )
+			 ! (DH2F(tailh)->f_flags & PF_TERM)
 			 &&
-			 ! DH2F( tailh )->f_nondirskippr ) {
-			    DH2F( tailh )->f_nondirskippr = BOOL_TRUE;
+			 ! DH2F(tailh)->f_nondirskippr) {
+			    DH2F(tailh)->f_nondirskippr = BOOL_TRUE;
 		    }
 
 		    /* build up list of needed objects
 		     */
-		    if ( foundgappr
+		    if (foundgappr
 			 &&
 			 tailh != DH_NULL
 			 &&
-			 ! ( DH2F( tailh )->f_flags & PF_INV )
+			 ! (DH2F(tailh)->f_flags & PF_INV)
 			 &&
-			 ! ( DH2F( tailh )->f_flags & PF_TERM )
+			 ! (DH2F(tailh)->f_flags & PF_TERM)
 			 &&
-			 ! DH2F( tailh )->f_nondirdonepr
+			 ! DH2F(tailh)->f_nondirdonepr
 			 &&
-			 ! DH2F( tailh )->f_nondirskippr ) {
+			 ! DH2F(tailh)->f_nondirskippr) {
 
-			    dh_t objh = DH2F( tailh )->f_parh;
+			    dh_t objh = DH2F(tailh)->f_parh;
 
-			    if ( ! DH2O( objh )->o_indrivepr
+			    if (! DH2O(objh)->o_indrivepr
 				 ||
-				 showobjindrivepr ) {
-				if ( DH2O( objh )->o_idlabvalpr ) {
-					if ( objh != lastobjaddedh ) {
-					    addobj( bagp,
-						    &DH2O( objh )->o_id,
-						    DH2O( objh )->o_lab,
-						    DH2O( objh )->o_indrivepr,
-						    DH2O( objh )->o_indriveix );
+				 showobjindrivepr) {
+				if (DH2O(objh)->o_idlabvalpr) {
+					if (objh != lastobjaddedh) {
+					    addobj(bagp,
+						    &DH2O(objh)->o_id,
+						    DH2O(objh)->o_lab,
+						    DH2O(objh)->o_indrivepr,
+						    DH2O(objh)->o_indriveix);
 					    lastobjaddedh = objh;
 					    objlistlen++;
 					}
@@ -6277,36 +6277,36 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
 
 		    /* pull the tail up to the next media file
 		     */
-		    tailh = pi_iter_nextfileh( tailiterp,
+		    tailh = pi_iter_nextfileh(tailiterp,
 					       &maybeobjmissingpr,
-					       &maybefilemissingpr );
-		} while ( tailh != headh );
+					       &maybefilemissingpr);
+		} while (tailh != headh);
 
 		tailegrp = headegrp;
 
-	} while ( headh != DH_NULL );
+	} while (headh != DH_NULL);
 
-	pi_unlock( );
+	pi_unlock();
 
 	/* free the iterators
 	 */
-	pi_iter_free( tailiterp );
-	pi_iter_free( headiterp );
+	pi_iter_free(tailiterp);
+	pi_iter_free(headiterp);
 
 	/* free the bag and return NULL if object list empty
 	 */
-	if ( objlistlen == 0 ) {
-		bag_free( bagp );
+	if (objlistlen == 0) {
+		bag_free(bagp);
 		bagp = 0;
 	}
 
-	*maybeholesprp = ( maybeobjmissingpr || maybefilemissingpr );
+	*maybeholesprp = (maybeobjmissingpr || maybefilemissingpr);
 	*knownholesprp = knownobjmissingpr;
 	return bagp;
 }
 
 static bag_t *
-pi_neededobjs_dir_alloc( bool_t *knownholesprp, bool_t *maybeholesprp )
+pi_neededobjs_dir_alloc(bool_t *knownholesprp, bool_t *maybeholesprp)
 {
 	bag_t *bagp;
 	dh_t fileh;
@@ -6317,8 +6317,8 @@ pi_neededobjs_dir_alloc( bool_t *knownholesprp, bool_t *maybeholesprp )
 	dh_t lastobjaddedh;
 	int objlistlen;
 
-	bagp = bag_alloc( );
-	iterp = pi_iter_alloc( );
+	bagp = bag_alloc();
+	iterp = pi_iter_alloc();
 
 	knownobjmissingpr = BOOL_FALSE;
 	maybeobjmissingpr = BOOL_FALSE;
@@ -6326,22 +6326,22 @@ pi_neededobjs_dir_alloc( bool_t *knownholesprp, bool_t *maybeholesprp )
 	lastobjaddedh = DH_NULL;
 	objlistlen = 0;
 
-	pi_lock( );
+	pi_lock();
 
-	while ( ( fileh = pi_iter_nextfileh( iterp,
+	while ((fileh = pi_iter_nextfileh(iterp,
 					     &maybeobjmissingpr,
-					     &maybefilemissingpr ))
-		!= DH_NULL ) {
-		if ( ! DH2F( fileh )->f_dirtriedpr ) {
-			dh_t objh = DH2F( fileh )->f_parh;
-			if ( ! DH2O( objh )->o_indrivepr ) {
-				if ( DH2O( objh )->o_idlabvalpr ) {
-					if ( objh != lastobjaddedh ) {
-						addobj( bagp,
-							&DH2O( objh )->o_id,
-							DH2O( objh )->o_lab,
-						    DH2O( objh )->o_indrivepr,
-						    DH2O( objh )->o_indriveix );
+					     &maybefilemissingpr))
+		!= DH_NULL) {
+		if (! DH2F(fileh)->f_dirtriedpr) {
+			dh_t objh = DH2F(fileh)->f_parh;
+			if (! DH2O(objh)->o_indrivepr) {
+				if (DH2O(objh)->o_idlabvalpr) {
+					if (objh != lastobjaddedh) {
+						addobj(bagp,
+							&DH2O(objh)->o_id,
+							DH2O(objh)->o_lab,
+						    DH2O(objh)->o_indrivepr,
+						    DH2O(objh)->o_indriveix);
 						lastobjaddedh = objh;
 						objlistlen++;
 					}
@@ -6352,22 +6352,22 @@ pi_neededobjs_dir_alloc( bool_t *knownholesprp, bool_t *maybeholesprp )
 		}
 	}
 
-	pi_unlock( );
+	pi_unlock();
 
-	pi_iter_free( iterp );
+	pi_iter_free(iterp);
 
-	if ( objlistlen == 0 ) {
-		bag_free( bagp );
+	if (objlistlen == 0) {
+		bag_free(bagp);
 		bagp = 0;
 	}
 
-	*maybeholesprp = ( maybeobjmissingpr || maybefilemissingpr );
+	*maybeholesprp = (maybeobjmissingpr || maybefilemissingpr);
 	*knownholesprp = knownobjmissingpr;
 	return bagp;
 }
 
 static void
-pi_neededobjs_free( bag_t *bagp )
+pi_neededobjs_free(bag_t *bagp)
 {
 	bagiter_t bagiter;
 	bagobj_t *bagobjp;
@@ -6375,27 +6375,27 @@ pi_neededobjs_free( bag_t *bagp )
 	size64_t dummykey;
 	void *dummypayloadp;
 
-	assert( bagp );
+	assert(bagp);
 
-	bagiter_init( bagp, &bagiter );
+	bagiter_init(bagp, &bagiter);
 
 	bagobjp = 0;
-	while (( bagelemp = bagiter_next( &bagiter, ( void ** )&bagobjp ) )) {
-		bag_remove( bagp, bagelemp, &dummykey, &dummypayloadp );
-		assert( bagobjp );
-		assert( bagobjp == ( bagobj_t * )dummypayloadp );
-		free( ( void * )bagobjp );
+	while ((bagelemp = bagiter_next(&bagiter, (void **)&bagobjp))) {
+		bag_remove(bagp, bagelemp, &dummykey, &dummypayloadp);
+		assert(bagobjp);
+		assert(bagobjp == (bagobj_t *)dummypayloadp);
+		free((void *)bagobjp);
 		bagobjp = 0;
 	}
 
-	bag_free( bagp );
+	bag_free(bagp);
 }
 
 /* a macro predicate to indicate if we know we are done. if we are not
  * done or don't know, returns FALSE.
  */
 static bool_t
-pi_alldone( void )
+pi_alldone(void)
 {
 	bag_t *bagp;
 	bool_t knownholespr;
@@ -6404,18 +6404,18 @@ pi_alldone( void )
 
 	knownholespr = BOOL_FALSE;
 	maybeholespr = BOOL_FALSE;
-	bagp = pi_neededobjs_nondir_alloc( &knownholespr,
+	bagp = pi_neededobjs_nondir_alloc(&knownholespr,
 					   &maybeholespr,
 					   BOOL_TRUE,
-					   BOOL_FALSE );
-	if ( bagp ) {
-		cnt = cntobj( bagp );
-		pi_neededobjs_free( bagp );
+					   BOOL_FALSE);
+	if (bagp) {
+		cnt = cntobj(bagp);
+		pi_neededobjs_free(bagp);
 	} else {
 		cnt = 0;
 	}
 
-	if ( cnt || knownholespr || maybeholespr ) {
+	if (cnt || knownholespr || maybeholespr) {
 		return BOOL_FALSE;
 	} else {
 		return BOOL_TRUE;
@@ -6427,7 +6427,7 @@ pi_alldone( void )
  * of the stream as well as the end of the object.
  */
 static void
-pi_hiteod( ix_t strmix, ix_t objix )
+pi_hiteod(ix_t strmix, ix_t objix)
 {
 	ix_t ix;
 	dh_t strmh;
@@ -6435,48 +6435,48 @@ pi_hiteod( ix_t strmix, ix_t objix )
 	size_t objcnt;
 	ix_t lastobjix;
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
-	assert( strmh != DH_NULL );
+	assert(strmh != DH_NULL);
 
 	/* get index to last object in stream
 	 */
-	for ( objcnt = 0, objh = DH2S( strmh )->s_cldh
+	for (objcnt = 0, objh = DH2S(strmh)->s_cldh
 	      ;
 	      objh != DH_NULL
 	      ;
-	      objh = DH2O( objh )->o_nexth, objcnt++ )
+	      objh = DH2O(objh)->o_nexth, objcnt++)
 		;
-	assert( objcnt != 0 );
+	assert(objcnt != 0);
 	lastobjix = objcnt - 1;
 
-	pi_unlock( );
+	pi_unlock();
 
 	/* can't possibly happen, but check for case where pi indicates
 	 * other media objects beyond this one.
 	 */
-	if ( objix != lastobjix ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+	if (objix != lastobjix) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 		      "hit EOD at stream %u object %u, "
 		      "yet inventory indicates last object index is %u\n"),
 		      strmix,
 		      objix,
-		      lastobjix );
+		      lastobjix);
 	} else {
-		pi_seestrmend( strmix );
+		pi_seestrmend(strmix);
 	}
 
-	pi_seeobjstrmend( strmix, lastobjix );
+	pi_seeobjstrmend(strmix, lastobjix);
 }
 
 /* tells the persistent inventory we hit end-of-media while examining the
@@ -6484,13 +6484,13 @@ pi_hiteod( ix_t strmix, ix_t objix )
  * of the object.
  */
 static void
-pi_hiteom( ix_t strmix, ix_t objix )
+pi_hiteom(ix_t strmix, ix_t objix)
 {
-	pi_seeobjstrmend( strmix, objix );
+	pi_seeobjstrmend(strmix, objix);
 }
 
 static void
-pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
+pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix)
 {
 	ix_t ix;
 	dh_t strmh;
@@ -6498,49 +6498,49 @@ pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
 	size_t objcnt;
 	ix_t lastobjix;
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
-	assert( strmh != DH_NULL );
+	assert(strmh != DH_NULL);
 
 	/* get index to last object in stream
 	 */
-	for ( objcnt = 0, objh = DH2S( strmh )->s_cldh
+	for (objcnt = 0, objh = DH2S(strmh)->s_cldh
 	      ;
 	      objh != DH_NULL
 	      ;
-	      objh = DH2O( objh )->o_nexth, objcnt++ )
+	      objh = DH2O(objh)->o_nexth, objcnt++)
 		;
-	assert( objcnt != 0 );
+	assert(objcnt != 0);
 	lastobjix = objcnt - 1;
 
-	pi_unlock( );
+	pi_unlock();
 
 	/* can't possibly happen, but check for case where pi indicates
 	 * other media objects beyond this one.
 	 */
-	if ( objix != lastobjix ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+	if (objix != lastobjix) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 		      "hit next dump at stream %u object %u file %u, "
 		      "yet inventory indicates last object index is %u\n"),
 		      strmix,
 		      objix,
 		      lastfileix,
-		      lastobjix );
+		      lastobjix);
 	} else {
-		pi_seestrmend( strmix );
+		pi_seestrmend(strmix);
 	}
 
-	pi_seeobjstrmend( strmix, lastobjix );
+	pi_seeobjstrmend(strmix, lastobjix);
 }
 
 /* returns TRUE if pi is certain no more useful media files remaining
@@ -6548,161 +6548,161 @@ pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
  * the object, returns FALSE.
  */
 static bool_t
-pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
+pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix)
 {
 	ix_t ix;
 	dh_t strmh;
 	dh_t objh;
 	dh_t fileh;
 
-	assert( purp == PURP_DIR || purp == PURP_NONDIR );
+	assert(purp == PURP_DIR || purp == PURP_NONDIR);
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
-	assert( strmh != DH_NULL );
+	assert(strmh != DH_NULL);
 
 	/* get handle to indexed object
 	 */
-	for ( ix = 0, objh = DH2S( strmh )->s_cldh
+	for (ix = 0, objh = DH2S(strmh)->s_cldh
 	      ;
 	      objh != DH_NULL && ix < objix
 	      ;
 	      ix++,
-	      objh = DH2O( objh )->o_nexth )
+	      objh = DH2O(objh)->o_nexth)
 		;
-	assert( objh != DH_NULL );
+	assert(objh != DH_NULL);
 
 	/* if don't know last media file on object, return FALSE
 	 */
-	if ( ! DH2O( objh )->o_lmfknwnpr ) {
-		pi_unlock( );
+	if (! DH2O(objh)->o_lmfknwnpr) {
+		pi_unlock();
 		return BOOL_FALSE;
 	}
 
 	/* check all media files on object. if any are not marked done,
 	 * return FALSE.
 	 */
-	for ( fileh = DH2O( objh )->o_cldh
+	for (fileh = DH2O(objh)->o_cldh
 	      ;
 	      fileh != DH_NULL
 	      ;
-	      fileh = DH2F( fileh )->f_nexth ) {
-		if ( DH2F( fileh )->f_flags & PF_INV ) {
+	      fileh = DH2F(fileh)->f_nexth) {
+		if (DH2F(fileh)->f_flags & PF_INV) {
 			continue;
 		}
-		if ( DH2F( fileh )->f_flags & PF_TERM ) {
+		if (DH2F(fileh)->f_flags & PF_TERM) {
 			continue;
 		}
-		if ( purp == PURP_DIR ) {
-			if ( ! DH2F( fileh )->f_dirtriedpr ) {
-				pi_unlock( );
+		if (purp == PURP_DIR) {
+			if (! DH2F(fileh)->f_dirtriedpr) {
+				pi_unlock();
 				return BOOL_FALSE;
 			}
 		} else {
-			if ( ! DH2F( fileh )->f_nondirskippr
+			if (! DH2F(fileh)->f_nondirskippr
 			     &&
-			     ! DH2F( fileh )->f_nondirdonepr ) {
-				pi_unlock( );
+			     ! DH2F(fileh)->f_nondirdonepr) {
+				pi_unlock();
 				return BOOL_FALSE;
 			}
 		}
 	}
 
-	pi_unlock( );
+	pi_unlock();
 	return BOOL_TRUE;
 }
 
 static bool_t
-pi_know_no_more_beyond_on_object( purp_t purp,
+pi_know_no_more_beyond_on_object(purp_t purp,
 				  ix_t strmix,
 				  ix_t objix,
-				  ix_t fileix )
+				  ix_t fileix)
 {
 	ix_t ix;
 	dh_t strmh;
 	dh_t objh;
 	dh_t fileh;
 
-	assert( purp == PURP_DIR || purp == PURP_NONDIR );
+	assert(purp == PURP_DIR || purp == PURP_NONDIR);
 
-	pi_lock( );
+	pi_lock();
 
 	/* get handle to the indexed stream
 	 */
-	for ( ix = 0,
+	for (ix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmh != DH_NULL && ix < strmix
 	      ;
 	      ix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
-	assert( strmh != DH_NULL );
+	assert(strmh != DH_NULL);
 
 	/* get handle to indexed object
 	 */
-	for ( ix = 0,
-	      objh = DH2S( strmh )->s_cldh
+	for (ix = 0,
+	      objh = DH2S(strmh)->s_cldh
 	      ;
 	      objh != DH_NULL && ix < objix
 	      ;
 	      ix++,
-	      objh = DH2O( objh )->o_nexth )
+	      objh = DH2O(objh)->o_nexth)
 		;
-	assert( objh != DH_NULL );
+	assert(objh != DH_NULL);
 
 	/* if don't know last media file on object, return FALSE
 	 */
-	if ( ! DH2O( objh )->o_lmfknwnpr ) {
-		pi_unlock( );
+	if (! DH2O(objh)->o_lmfknwnpr) {
+		pi_unlock();
 		return BOOL_FALSE;
 	}
 
 	/* check all files on object after indexed file. if any are not marked
 	 * done, return FALSE. skip inventory and terminator files.
 	 */
-	for ( ix = 0,
-	      fileh = DH2O( objh )->o_cldh
+	for (ix = 0,
+	      fileh = DH2O(objh)->o_cldh
 	      ;
 	      fileh != DH_NULL
 	      ;
 	      ix++,
-	      fileh = DH2F( fileh )->f_nexth ) {
-		if ( ix <= fileix ) {
+	      fileh = DH2F(fileh)->f_nexth) {
+		if (ix <= fileix) {
 			continue;
 		}
-		if ( DH2F( fileh )->f_flags & PF_INV ) {
+		if (DH2F(fileh)->f_flags & PF_INV) {
 			continue;
 		}
-		if ( DH2F( fileh )->f_flags & PF_TERM ) {
+		if (DH2F(fileh)->f_flags & PF_TERM) {
 			continue;
 		}
-		if ( purp == PURP_DIR ) {
-			if ( ! DH2F( fileh )->f_dirtriedpr ) {
-				pi_unlock( );
+		if (purp == PURP_DIR) {
+			if (! DH2F(fileh)->f_dirtriedpr) {
+				pi_unlock();
 				return BOOL_FALSE;
 			}
 		} else {
-			if ( ! DH2F( fileh )->f_nondirdonepr
+			if (! DH2F(fileh)->f_nondirdonepr
 			     &&
-			     ! DH2F( fileh )->f_nondirskippr ) {
-				pi_unlock( );
+			     ! DH2F(fileh)->f_nondirskippr) {
+				pi_unlock();
 				return BOOL_FALSE;
 			}
 		}
 	}
 
-	pi_unlock( );
+	pi_unlock();
 	return BOOL_TRUE;
 }
 
@@ -6710,27 +6710,27 @@ pi_know_no_more_beyond_on_object( purp_t purp,
  * ino map. *---o (endpoint not inclusive)
  */
 static bool_t
-gapneeded( egrp_t *firstegrpp, egrp_t *lastegrpp )
+gapneeded(egrp_t *firstegrpp, egrp_t *lastegrpp)
 {
 	xfs_ino_t endino;
 
-	if ( firstegrpp->eg_ino > lastegrpp->eg_ino ) {
+	if (firstegrpp->eg_ino > lastegrpp->eg_ino) {
 		return BOOL_FALSE;
 	}
 
-	if ( firstegrpp->eg_ino == lastegrpp->eg_ino
+	if (firstegrpp->eg_ino == lastegrpp->eg_ino
 	     &&
-	     firstegrpp->eg_off > lastegrpp->eg_off ) {
+	     firstegrpp->eg_off > lastegrpp->eg_off) {
 		return BOOL_FALSE;
 	}
 
-	if ( lastegrpp->eg_off > 0 || lastegrpp->eg_ino == 0 ) {
+	if (lastegrpp->eg_off > 0 || lastegrpp->eg_ino == 0) {
 		endino = lastegrpp->eg_ino;
 	} else {
 		endino = lastegrpp->eg_ino - 1;
 	}
 
-	if ( ! inomap_rst_needed( firstegrpp->eg_ino, endino )) {
+	if (! inomap_rst_needed(firstegrpp->eg_ino, endino)) {
 		return BOOL_FALSE;
 	}
 
@@ -6738,41 +6738,41 @@ gapneeded( egrp_t *firstegrpp, egrp_t *lastegrpp )
 }
 
 static void
-addobj( bag_t *bagp,
+addobj(bag_t *bagp,
 	uuid_t *idp,
 	label_t label,
 	bool_t indrivepr,
-	ix_t indriveix )
+	ix_t indriveix)
 {
 	bagobj_t *bagobjp;
 
-	bagobjp = ( bagobj_t * )calloc( 1, sizeof( bagobj_t ));
-	assert( bagobjp );
+	bagobjp = (bagobj_t *)calloc(1, sizeof(bagobj_t));
+	assert(bagobjp);
 	uuid_copy(bagobjp->id, *idp);
-	strncpy( bagobjp->label,
+	strncpy(bagobjp->label,
 		 label,
-		 sizeof( bagobjp->label ));
+		 sizeof(bagobjp->label));
 	bagobjp->indrivepr = indrivepr;
 	bagobjp->indriveix = indriveix;
-	bag_insert( bagp,
+	bag_insert(bagp,
 		    &bagobjp->bagelem,
-		    ( size64_t )0,
-		    ( void * )bagobjp );
+		    (size64_t)0,
+		    (void *)bagobjp);
 }
 
 static size_t
-cntobj( bag_t *bagp )
+cntobj(bag_t *bagp)
 {
 	bagiter_t bagiter;
 	bagobj_t *bagobjp;
 	size_t cnt;
 
-	assert( bagp );
+	assert(bagp);
 
-	bagiter_init( bagp, &bagiter );
+	bagiter_init(bagp, &bagiter);
 	cnt = 0;
 	bagobjp = 0; /* keep lint happy */
-	while ( bagiter_next( &bagiter, ( void ** )&bagobjp )) {
+	while (bagiter_next(&bagiter, (void **)&bagobjp)) {
 		cnt++;
 		bagobjp = 0; /* keep lint happy */
 	}
@@ -6788,7 +6788,7 @@ cntobj( bag_t *bagp )
  * must be last dump of a lesser level
  */
 static bool_t
-askinvforbaseof( uuid_t baseid, inv_session_t *sessp )
+askinvforbaseof(uuid_t baseid, inv_session_t *sessp)
 {
 	ix_t level;
 	bool_t resumedpr;
@@ -6796,29 +6796,29 @@ askinvforbaseof( uuid_t baseid, inv_session_t *sessp )
 	inv_session_t *basesessp;
 	bool_t ok;
 
-	level = ( ix_t )sessp->s_level;
+	level = (ix_t)sessp->s_level;
 	resumedpr = sessp->s_isresumed;
 
 	/* don't look for base if level 0 and not resumed
 	 */
-	if ( level == 0 && ! resumedpr ) {
+	if (level == 0 && ! resumedpr) {
 		return BOOL_TRUE;
 	}
 
 	/* open the inventory for this file system
 	 */
-	invtok = inv_open( INV_BY_UUID,
+	invtok = inv_open(INV_BY_UUID,
 			   INV_SEARCH_ONLY,
-			   ( void * )&sessp->s_fsid );
-	if ( invtok == INV_TOKEN_NULL ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
-		      "unable to open inventory to validate dump\n") );
+			   (void *)&sessp->s_fsid);
+	if (invtok == INV_TOKEN_NULL) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+		      "unable to open inventory to validate dump\n"));
 		return BOOL_FALSE;
 	}
 
 	/* get the base session
 	 */
-	if ( resumedpr ) {
+	if (resumedpr) {
 		ok = inv_lastsession_level_equalto(&sessp->s_fsid,
 						    invtok,
 						    (u_char_t)level,
@@ -6829,17 +6829,17 @@ askinvforbaseof( uuid_t baseid, inv_session_t *sessp )
 						     (u_char_t)level,
 						     &basesessp);
 	}
-	if ( ! ok ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
+	if (! ok) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
 		      "unable to find base dump in inventory "
-		      "to validate dump\n") );
+		      "to validate dump\n"));
 		return BOOL_FALSE;
 	}
 
 	/* close the inventory
 	 */
-	ok = inv_close( invtok );
-	assert( ok );
+	ok = inv_close(invtok);
+	assert(ok);
 
 	/* return id of base session
 	 */
@@ -6847,39 +6847,39 @@ askinvforbaseof( uuid_t baseid, inv_session_t *sessp )
 
 	/* free the base session descriptor
 	 */
-	inv_free_session( &basesessp );
+	inv_free_session(&basesessp);
 
 	return BOOL_TRUE;
 }
 
 static bool_t
-dumpcompat( bool_t resumepr, ix_t level, uuid_t baseid, bool_t logpr )
+dumpcompat(bool_t resumepr, ix_t level, uuid_t baseid, bool_t logpr)
 {
-	if ( persp->a.cumpr ) {
-		if ( persp->a.dumpcnt == 0 ) {
-			if ( resumepr ) {
-				if ( logpr ) {
-				    mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (persp->a.cumpr) {
+		if (persp->a.dumpcnt == 0) {
+			if (resumepr) {
+				if (logpr) {
+				    mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					  "cumulative restores must begin with "
 					  "an initial (not resumed) "
-					  "level 0 dump\n") );
+					  "level 0 dump\n"));
 				}
 				return BOOL_FALSE;
 			}
-			if ( level > 0 ) {
-				if ( logpr ) {
-				    mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (level > 0) {
+				if (logpr) {
+				    mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					  "cumulative restores must begin with "
-					  "a level 0 dump\n") );
+					  "a level 0 dump\n"));
 				}
 				return BOOL_FALSE;
 			}
 		} else {
-			if ( resumepr ) {
-				if ( uuid_compare( persp->a.lastdumpid,
+			if (resumepr) {
+				if (uuid_compare(persp->a.lastdumpid,
 						   baseid) != 0) {
-					if ( logpr ) {
-					    mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					if (logpr) {
+					    mlog(MLOG_NORMAL | MLOG_ERROR, _(
 						  "selected resumed dump "
 						  "not a resumption of "
 						  "previously applied dump\n"));
@@ -6887,10 +6887,10 @@ dumpcompat( bool_t resumepr, ix_t level, uuid_t baseid, bool_t logpr )
 					return BOOL_FALSE;
 				}
 			} else {
-				if ( uuid_compare( persp->a.lastdumpid,
+				if (uuid_compare(persp->a.lastdumpid,
 						   baseid) != 0) {
-					if ( logpr ) {
-					    mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					if (logpr) {
+					    mlog(MLOG_NORMAL | MLOG_ERROR, _(
 						  "selected dump not based on "
 						  "previously applied dump\n"));
 					}
@@ -6908,23 +6908,23 @@ dumpcompat( bool_t resumepr, ix_t level, uuid_t baseid, bool_t logpr )
  * still needed/available
  */
 static bool_t
-Media_prompt_change( drive_t *drivep,
+Media_prompt_change(drive_t *drivep,
 		     purp_t purp,
 		     bag_t *bagp,
 		     bool_t knownholespr,
-		     bool_t maybeholespr )
+		     bool_t maybeholespr)
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
@@ -6934,47 +6934,47 @@ Media_prompt_change( drive_t *drivep,
 	ix_t sigintix;
 
 retry:
-	fold_init( fold, _("change media dialog"), '=' );
+	fold_init(fold, _("change media dialog"), '=');
 	preamblecnt = 0;
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* query: ask if media changed or declined
 	 */
-	if ( drivecnt > 1 ) {
-		sprintf( question, _(
+	if (drivecnt > 1) {
+		sprintf(question, _(
 			 "please change media in "
 			 "drive %u\n"),
-			 (unsigned int)drivep->d_index );
+			 (unsigned int)drivep->d_index);
 	} else {
-		sprintf( question, _(
+		sprintf(question, _(
 			 "please change media in "
-			 "drive\n") );
+			 "drive\n"));
 	}
 	querycnt = 0;
-	querystr[ querycnt++ ] = question;
-	assert( querycnt <= QUERYMAX );
+	querystr[querycnt++] = question;
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
 	dontix = choicecnt;
-	choicestr[ choicecnt++ ] = _("media change declined");
-	if ( purp != PURP_SEARCH ) {
+	choicestr[choicecnt++ ] = _("media change declined");
+	if (purp != PURP_SEARCH) {
 		invstatix = choicecnt;
-		choicestr[ choicecnt++ ] = _("display media inventory status");
+		choicestr[choicecnt++ ] = _("display media inventory status");
 		neededix = choicecnt;
-		choicestr[ choicecnt++ ] = _("list needed media objects");
+		choicestr[choicecnt++ ] = _("list needed media objects");
 	} else {
 		invstatix = IXMAX;
 		neededix = IXMAX;
 	}
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = _("media changed");
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++ ] = _("media changed");
+	assert(choicecnt <= CHOICEMAX);
 	sigintix = IXMAX - 1;
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -6986,76 +6986,76 @@ retry:
 				       dontix,		/* timeout ix */
 				       sigintix,	/* sigint ix */
 				       dontix,		/* sighup ix */
-				       dontix );	/* sigquit ix */
+				       dontix);	/* sigquit ix */
 	ackcnt = 0;
-	if ( responseix == doix ) {
-		ackstr[ ackcnt++ ] = _("examining new media\n");
-	} else if ( responseix == dontix ) {
-		ackstr[ ackcnt++ ] = _("media change aborted\n");
-	} else if ( responseix == invstatix ) {
-		ackstr[ ackcnt++ ] = "\n";
-		assert( ackcnt <= ACKMAX );
-		dlog_multi_ack( ackstr,
-				ackcnt );
-		pi_show_nomloglock( );
+	if (responseix == doix) {
+		ackstr[ackcnt++ ] = _("examining new media\n");
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++ ] = _("media change aborted\n");
+	} else if (responseix == invstatix) {
+		ackstr[ackcnt++ ] = "\n";
+		assert(ackcnt <= ACKMAX);
+		dlog_multi_ack(ackstr,
+				ackcnt);
+		pi_show_nomloglock();
 		postamblecnt = 0;
-		fold_init( fold, _("end dialog"), '-' );
-		postamblestr[ postamblecnt++ ] = "\n";
-		postamblestr[ postamblecnt++ ] = fold;
-		postamblestr[ postamblecnt++ ] = "\n\n";
-		assert( postamblecnt <= POSTAMBLEMAX );
-		dlog_end( postamblestr,
-			  postamblecnt );
+		fold_init(fold, _("end dialog"), '-');
+		postamblestr[postamblecnt++ ] = "\n";
+		postamblestr[postamblecnt++] = fold;
+		postamblestr[postamblecnt++ ] = "\n\n";
+		assert(postamblecnt <= POSTAMBLEMAX);
+		dlog_end(postamblestr,
+			  postamblecnt);
 		goto retry;
-	} else if ( responseix == neededix ) {
-		ackstr[ ackcnt++ ] = "\n";
-		assert( ackcnt <= ACKMAX );
-		dlog_multi_ack( ackstr,
-				ackcnt );
-		display_needed_objects( purp,
+	} else if (responseix == neededix) {
+		ackstr[ackcnt++ ] = "\n";
+		assert(ackcnt <= ACKMAX);
+		dlog_multi_ack(ackstr,
+				ackcnt);
+		display_needed_objects(purp,
 					bagp,
 					knownholespr,
-					maybeholespr );
+					maybeholespr);
 		postamblecnt = 0;
-		fold_init( fold, "end dialog", '-' );
-		postamblestr[ postamblecnt++ ] = "\n";
-		postamblestr[ postamblecnt++ ] = fold;
-		postamblestr[ postamblecnt++ ] = "\n\n";
-		assert( postamblecnt <= POSTAMBLEMAX );
-		dlog_end( postamblestr,
-			  postamblecnt );
+		fold_init(fold, "end dialog", '-');
+		postamblestr[postamblecnt++ ] = "\n";
+		postamblestr[postamblecnt++] = fold;
+		postamblestr[postamblecnt++ ] = "\n\n";
+		assert(postamblecnt <= POSTAMBLEMAX);
+		dlog_end(postamblestr,
+			  postamblecnt);
 		goto retry;
 	} else {
-		assert( responseix == sigintix );
-		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
+		assert(responseix == sigintix);
+		ackstr[ackcnt++ ] = _("keyboard interrupt\n");
 	}
 
-	assert( ackcnt <= ACKMAX );
-	dlog_multi_ack( ackstr,
-			ackcnt );
+	assert(ackcnt <= ACKMAX);
+	dlog_multi_ack(ackstr,
+			ackcnt);
 
 	postamblecnt = 0;
-	fold_init( fold, _("end dialog"), '-' );
-	postamblestr[ postamblecnt++ ] = "\n";
-	postamblestr[ postamblecnt++ ] = fold;
-	postamblestr[ postamblecnt++ ] = "\n\n";
-	assert( postamblecnt <= POSTAMBLEMAX );
-	dlog_end( postamblestr,
-		  postamblecnt );
-
-	if ( responseix == sigintix ) {
-		if ( cldmgr_stop_requested( )) {
+	fold_init(fold, _("end dialog"), '-');
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
-		      "retrying media change dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying media change dialog\n");
 		goto retry;
 	}
 
@@ -7066,23 +7066,23 @@ retry:
  * the dump to be restored
  */
 static bool_t
-promptdumpmatch( ix_t thrdix,
+promptdumpmatch(ix_t thrdix,
 		 global_hdr_t *grhdrp,
 		 media_hdr_t *mrhdrp,
 		 content_hdr_t *crhdrp,
-		 content_inode_hdr_t *scrhdrp )
+		 content_inode_hdr_t *scrhdrp)
 {
 	fold_t fold;
-	char introstring[ 80 ];
-	char *preamblestr[ PREAMBLEMAX ];
+	char introstring[80];
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
@@ -7091,54 +7091,54 @@ promptdumpmatch( ix_t thrdix,
 
 retry:
 	preamblecnt = 0;
-	fold_init( fold, _("dump selection dialog"), '=' );
-	preamblestr[ preamblecnt++ ] = "\n";
-	preamblestr[ preamblecnt++ ] = fold;
-	preamblestr[ preamblecnt++ ] = "\n\n";
-	assert( preamblecnt <= PREAMBLEMAX );
-	dlog_begin( preamblestr, preamblecnt );
+	fold_init(fold, _("dump selection dialog"), '=');
+	preamblestr[preamblecnt++ ] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++ ] = "\n\n";
+	assert(preamblecnt <= PREAMBLEMAX);
+	dlog_begin(preamblestr, preamblecnt);
 
 	/* display vital stats and ask if this one should be restored
 	 */
-	if ( drivecnt > 0 ) {
-		sprintf( introstring, _(
+	if (drivecnt > 0) {
+		sprintf(introstring, _(
 			 "the following dump has been found"
 			 " on drive %u"
 			 "\n\n"),
-			 (unsigned int)thrdix );
+			 (unsigned int)thrdix);
 	} else {
-		sprintf( introstring, _(
+		sprintf(introstring, _(
 			 "the following dump has been found"
-			 "\n\n") );
+			 "\n\n"));
 	}
-	assert( strlen( introstring ) < sizeof( introstring ));
-	display_dump_label( BOOL_FALSE,
+	assert(strlen(introstring) < sizeof(introstring));
+	display_dump_label(BOOL_FALSE,
 			    MLOG_NORMAL | MLOG_BARE,
 			    introstring,
 			    grhdrp,
 			    mrhdrp,
 			    crhdrp,
-			    scrhdrp );
+			    scrhdrp);
 
 	querycnt = 0;
-	if ( tranp->t_toconlypr ) {
-		querystr[ querycnt++ ] = _("\nexamine this dump?\n");
+	if (tranp->t_toconlypr) {
+		querystr[querycnt++ ] = _("\nexamine this dump?\n");
 	} else {
-		querystr[ querycnt++ ] = (persp->a.interpr) ?
+		querystr[querycnt++] = (persp->a.interpr) ?
 			_("\ninteractively restore from this dump?\n")
 				: _("\nrestore this dump?\n");
 	}
-	assert( querycnt <= QUERYMAX );
+	assert(querycnt <= QUERYMAX);
 	choicecnt = 0;
 	dontix = choicecnt;
-	choicestr[ choicecnt++ ] = _("skip");
+	choicestr[choicecnt++ ] = _("skip");
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = (persp->a.interpr) ?
+	choicestr[choicecnt++] = (persp->a.interpr) ?
 				_("interactively restore\n") : _("restore\n");
-	assert( choicecnt <= CHOICEMAX );
+	assert(choicecnt <= CHOICEMAX);
 	sigintix = IXMAX - 1;
 
-	responseix = dlog_multi_query( querystr,
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -7150,45 +7150,45 @@ retry:
 				       IXMAX,		/* timeout ix */
 				       sigintix,	/* sigint ix */
 				       dontix,		/* sighup ix */
-				       dontix );	/* sigquit ix */
+				       dontix);	/* sigquit ix */
 	ackcnt = 0;
-	if ( responseix == doix ) {
-		ackstr[ ackcnt++ ] = (persp->a.interpr) ?
+	if (responseix == doix) {
+		ackstr[ackcnt++] = (persp->a.interpr) ?
 			_("this dump selected for interactive restoral\n")
 			      : _("this dump selected for restoral\n");
-	} else if ( responseix == dontix ) {
-		ackstr[ ackcnt++ ] = _("dump skipped\n");
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++ ] = _("dump skipped\n");
 	} else {
-		assert( responseix == sigintix );
-		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
+		assert(responseix == sigintix);
+		ackstr[ackcnt++ ] = _("keyboard interrupt\n");
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
-		      "retrying dump selection dialog\n" );
+		mlog(MLOG_DEBUG,
+		      "retrying dump selection dialog\n");
 		goto retry;
 	}
 
@@ -7212,15 +7212,15 @@ struct cb_context {
 
 typedef struct cb_context cb_context_t;
 
-static bool_t restore_file_cb( void *, bool_t, char *, char * );
+static bool_t restore_file_cb(void *, bool_t, char *, char *);
 
 static rv_t
-restore_file( drive_t *drivep,
+restore_file(drive_t *drivep,
 	      filehdr_t *fhdrp,
 	      bool_t ehcs,
 	      bool_t ahcs,
 	      char *path1,
-	      char *path2 )
+	      char *path2)
 {
 	rv_t rv;
 	bstat_t *bstatp = &fhdrp->fh_stat;
@@ -7237,14 +7237,14 @@ restore_file( drive_t *drivep,
 	context.cb_ahcs = ahcs;
 	context.cb_path1 = path1;
 	context.cb_path2 = path2;
-	rv = tree_cb_links( bstatp->bs_ino,
+	rv = tree_cb_links(bstatp->bs_ino,
 		       bstatp->bs_gen,
 		       bstatp->bs_ctime.tv_sec,
 		       bstatp->bs_mtime.tv_sec,
 		       restore_file_cb,
 		       &context,
 		       path1,
-		       path2 );
+		       path2);
 	if (context.cb_rv) /* context error result has precedence */
 	    return context.cb_rv; /* this would be set by callback */
 	else
@@ -7259,9 +7259,9 @@ restore_file( drive_t *drivep,
  * if this func returns FALSE, will cause tree_cb_links to abort
  */
 static bool_t
-restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
+restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
 {
-	cb_context_t *contextp = ( cb_context_t * )cp;
+	cb_context_t *contextp = (cb_context_t *)cp;
 	drive_t *drivep = contextp->cb_drivep;
 	filehdr_t *fhdrp = contextp->cb_fhdrp;
 	bstat_t *bstatp = &fhdrp->fh_stat;
@@ -7273,12 +7273,12 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 	int rval;
 	bool_t ok;
 
-	if ( cldmgr_stop_requested( )) {
+	if (cldmgr_stop_requested()) {
 		*rvp = RV_INTR;
 		return BOOL_FALSE;
 	}
 
-	if ( ! linkpr ) {
+	if (! linkpr) {
 		if (path1) {
 			/* cache the path for use in restoring attributes
 			 * and extended attributes
@@ -7288,26 +7288,26 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 
 		/* call type-specific function to create the file
 		 */
-		switch( bstatp->bs_mode & S_IFMT ) {
+		switch(bstatp->bs_mode & S_IFMT) {
 		case S_IFREG:
-			ok = restore_reg( drivep, fhdrp, rvp, path1 );
+			ok = restore_reg(drivep, fhdrp, rvp, path1);
 			if (!ok)
 				return ok;
-			if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
-				*rvp = restore_extattr( drivep,
+			if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
+				*rvp = restore_extattr(drivep,
 							fhdrp,
 							path1,
 							ahcs,
 							BOOL_FALSE, /* isdirpr */
 							BOOL_FALSE, /* onlydoreadpr */
-							DAH_NULL );
+							DAH_NULL);
 			} else {
-				ok = restore_extent_group( drivep,
+				ok = restore_extent_group(drivep,
 							   fhdrp,
 							   path1,
 							   strctxp->sc_fd,
 							   ehcs,
-							   rvp );
+							   rvp);
 			}
 			return ok;
 		case S_IFBLK:
@@ -7317,57 +7317,57 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
 		case S_IFNAM:
 #endif
 		case S_IFSOCK:
-			ok = restore_spec( fhdrp, rvp, path1 );
+			ok = restore_spec(fhdrp, rvp, path1);
 			return ok;
 		case S_IFLNK:
-			ok = restore_symlink( drivep,
+			ok = restore_symlink(drivep,
 					      fhdrp,
 					      rvp,
 					      path1,
 					      path2,
-					      ehcs );
+					      ehcs);
 			return ok;
 		default:
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "ino %llu: unknown file type: %08x\n"),
 			      bstatp->bs_ino,
-			      bstatp->bs_mode );
+			      bstatp->bs_mode);
 			return BOOL_FALSE;
 		}
-	} else if ( ! tranp->t_toconlypr ) {
-		assert( path1 );
-		assert( path2 );
-		mlog( MLOG_TRACE,
+	} else if (! tranp->t_toconlypr) {
+		assert(path1);
+		assert(path2);
+		mlog(MLOG_TRACE,
 		      "linking %s to %s\n",
 		      path1,
-		      path2 );
-		rval = unlink( path2 );
-		if ( rval && errno != ENOENT ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		      path2);
+		rval = unlink(path2);
+		if (rval && errno != ENOENT) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to unlink "
 			      "current file prior to linking "
 			      "%s to %s:"
 			      " %s\n"),
 			      path1,
 			      path2,
-			      strerror( errno ));
+			      strerror(errno));
 		} else {
-			rval = link( path1, path2 );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			rval = link(path1, path2);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "attempt to "
 				      "link %s to %s failed:"
 				      " %s\n"),
 				      path1,
 				      path2,
-				      strerror( errno ));
+				      strerror(errno));
 			}
 		}
 		return BOOL_TRUE;
 	} else {
-		mlog( MLOG_NORMAL | MLOG_BARE,
+		mlog(MLOG_NORMAL | MLOG_BARE,
 		      "%s\n",
-		      path2 );
+		      path2);
 		return BOOL_TRUE;
 	}
 }
@@ -7387,7 +7387,7 @@ set_file_owner(
 	mode_t		mode = (mode_t)bstatp->bs_mode;
 	int		rval;
 
-	rval = fchown(*fdp, (uid_t)bstatp->bs_uid, (gid_t)bstatp->bs_gid );
+	rval = fchown(*fdp, (uid_t)bstatp->bs_uid, (gid_t)bstatp->bs_gid);
 	if (!rval)
 		goto done;
 
@@ -7434,10 +7434,10 @@ done:
  * this iteration.
  */
 static bool_t
-restore_reg( drive_t *drivep,
+restore_reg(drive_t *drivep,
 	     filehdr_t *fhdrp,
 	     rv_t *rvp,
-	     char *path )
+	     char *path)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
@@ -7447,73 +7447,73 @@ restore_reg( drive_t *drivep,
 	struct stat64 stat;
 	int oflags;
 
-	if ( !path )
+	if (!path)
 		return BOOL_TRUE;
 
-	if ( fhdrp->fh_offset ) {
-		if ( ! tranp->t_toconlypr ) {
-			mlog( MLOG_TRACE,
+	if (fhdrp->fh_offset) {
+		if (! tranp->t_toconlypr) {
+			mlog(MLOG_TRACE,
 			      "restoring regular file ino %llu %s"
 			      " (offset %lld)\n",
 			      bstatp->bs_ino,
 			      path,
-			      fhdrp->fh_offset );
+			      fhdrp->fh_offset);
 		} else {
-			mlog( MLOG_NORMAL | MLOG_BARE,
+			mlog(MLOG_NORMAL | MLOG_BARE,
 			      _("%s (offset %lld)\n"),
 			      path,
-			      fhdrp->fh_offset );
+			      fhdrp->fh_offset);
 		}
 	} else {
-		if ( ! tranp->t_toconlypr ) {
-			mlog( MLOG_TRACE,
+		if (! tranp->t_toconlypr) {
+			mlog(MLOG_TRACE,
 			      "restoring regular file ino %llu %s\n",
 			      bstatp->bs_ino,
-			      path );
+			      path);
 		} else {
-			mlog( MLOG_NORMAL | MLOG_BARE,
+			mlog(MLOG_NORMAL | MLOG_BARE,
 			      "%s\n",
-			      path );
+			      path);
 		}
 	}
 
-	if ( tranp->t_toconlypr )
+	if (tranp->t_toconlypr)
 		return BOOL_TRUE;
 
 	oflags = O_CREAT | O_RDWR;
 	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & XFS_XFLAG_REALTIME)
 		oflags |= O_DIRECT;
 
-	*fdp = open( path, oflags, S_IRUSR | S_IWUSR );
-	if ( *fdp < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING,
+	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
+	if (*fdp < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING,
 		      _("open of %s failed: %s: discarding ino %llu\n"),
 		      path,
-		      strerror( errno ),
-		      bstatp->bs_ino );
+		      strerror(errno),
+		      bstatp->bs_ino);
 		return BOOL_TRUE;
 	}
 
-	rval = fstat64( *fdp, &stat );
-	if ( rval != 0 ) {
-		mlog( MLOG_VERBOSE | MLOG_WARNING,
+	rval = fstat64(*fdp, &stat);
+	if (rval != 0) {
+		mlog(MLOG_VERBOSE | MLOG_WARNING,
 		      _("attempt to stat %s failed: %s\n"),
 		      path,
-		      strerror( errno ));
+		      strerror(errno));
 	} else {
-		if ( stat.st_size != bstatp->bs_size ) {
-			mlog( MLOG_TRACE,
+		if (stat.st_size != bstatp->bs_size) {
+			mlog(MLOG_TRACE,
 			      "truncating %s from %lld to %lld\n",
 			      path,
 			      stat.st_size,
-			      bstatp->bs_size );
+			      bstatp->bs_size);
 
-			rval = ftruncate64( *fdp, bstatp->bs_size );
-			if ( rval != 0 ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING,
+			rval = ftruncate64(*fdp, bstatp->bs_size);
+			if (rval != 0) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING,
 				      _("attempt to truncate %s failed: %s\n"),
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 			}
 		}
 	}
@@ -7524,20 +7524,20 @@ restore_reg( drive_t *drivep,
 			return BOOL_TRUE;
 	}
 
-	if ( persp->a.dstdirisxfspr ) {
+	if (persp->a.dstdirisxfspr) {
 
 		/* set the extended inode flags, except those which must
 		 * be set only after all data has been restored.
 		 */
-		assert( bstatp->bs_extsize >= 0 );
-		memset((void *)&fsxattr, 0, sizeof( fsxattr ));
+		assert(bstatp->bs_extsize >= 0);
+		memset((void *)&fsxattr, 0, sizeof(fsxattr));
 		fsxattr.fsx_xflags = bstatp->bs_xflags & ~POST_DATA_XFLAGS;
 		fsxattr.fsx_extsize = (uint32_t) bstatp->bs_extsize;
 		fsxattr.fsx_projid = bstat_projid(bstatp);
 
-		rval = ioctl( *fdp, XFS_IOC_FSSETXATTR, (void *)&fsxattr);
-		if ( rval < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING,
+		rval = ioctl(*fdp, XFS_IOC_FSSETXATTR, (void *)&fsxattr);
+		if (rval < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
 			      _("attempt to set extended attributes "
 				"(xflags 0x%x, extsize = 0x%x, projid = 0x%x) "
 				"of %s failed: %s\n"),
@@ -7549,10 +7549,10 @@ restore_reg( drive_t *drivep,
 		}
 	}
 
-	if ( persp->a.dstdirisxfspr && persp->a.restoredmpr ) {
-		HsmBeginRestoreFile( bstatp,
+	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
+		HsmBeginRestoreFile(bstatp,
 				     *fdp,
-				     &strctxp->sc_hsmflags );
+				     &strctxp->sc_hsmflags);
 	}
 
 	return BOOL_TRUE;
@@ -7564,12 +7564,12 @@ restore_reg( drive_t *drivep,
  * drive errors. returns FALSE if should abort this iteration.
  */
 static bool_t
-restore_extent_group( drive_t *drivep,
+restore_extent_group(drive_t *drivep,
 		      filehdr_t *fhdrp,
 		      char *path,
 		      int fd,
 		      bool_t ehcs,
-		      rv_t *rvp )
+		      rv_t *rvp)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	off64_t restoredsz = 0;
@@ -7579,25 +7579,25 @@ restore_extent_group( drive_t *drivep,
 
 	/* copy data extents from media to the file
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		/* read the extent header
 		 */
-		rv = read_extenthdr( drivep, &ehdr, ehcs );
-		if ( rv != RV_OK ) {
+		rv = read_extenthdr(drivep, &ehdr, ehcs);
+		if (rv != RV_OK) {
 			*rvp = rv;
 			return BOOL_FALSE;
 		}
-		mlog( MLOG_NITTY,
+		mlog(MLOG_NITTY,
 		      "read extent hdr type %s offset %lld sz %lld flags %x\n",
-		      ehdr_typestr( ehdr.eh_type ),
+		      ehdr_typestr(ehdr.eh_type),
 		      ehdr.eh_offset,
 		      ehdr.eh_sz,
-		      ehdr.eh_flags );
+		      ehdr.eh_flags);
 
 		/* if we see the specially marked last extent hdr,
 		 * we are done.
 		 */
-		if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
+		if (ehdr.eh_type == EXTENTHDR_TYPE_LAST) {
 			/* For a wholly sparse file, there is no HOLE
 			 * record; advance restoredsz to EOF.
 			 */
@@ -7608,12 +7608,12 @@ restore_extent_group( drive_t *drivep,
 
 		/* if its an ALIGNment extent, discard the extent.
 		 */
-		if ( ehdr.eh_type == EXTENTHDR_TYPE_ALIGN ) {
+		if (ehdr.eh_type == EXTENTHDR_TYPE_ALIGN) {
 			size_t sz;
-			assert( ehdr.eh_sz <= INTGENMAX );
-			sz = ( size_t )ehdr.eh_sz;
-			rv = discard_padding( sz, drivep );
-			if ( rv != RV_OK ) {
+			assert(ehdr.eh_sz <= INTGENMAX);
+			sz = (size_t)ehdr.eh_sz;
+			rv = discard_padding(sz, drivep);
+			if (rv != RV_OK) {
 				*rvp = rv;
 				return BOOL_FALSE;
 			}
@@ -7628,26 +7628,26 @@ restore_extent_group( drive_t *drivep,
 		/* Holes do not need to be restored since we now
 		 * unlink the file at the start of the restore.
 		 */
-		if ( ehdr.eh_type == EXTENTHDR_TYPE_HOLE ) {
+		if (ehdr.eh_type == EXTENTHDR_TYPE_HOLE) {
 			continue;
 		}
 
 		/* real data
 		 */
-		assert( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
+		assert(ehdr.eh_type == EXTENTHDR_TYPE_DATA);
 		bytesread = 0;
-		rv = restore_extent( fhdrp,
+		rv = restore_extent(fhdrp,
 				     &ehdr,
 				     fd,
 				     path,
 				     drivep,
-				     &bytesread );
-		if ( rv != RV_OK ) {
+				     &bytesread);
+		if (rv != RV_OK) {
 			*rvp = rv;
 			return BOOL_FALSE;
 		}
 
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			*rvp = RV_INTR;
 			return BOOL_FALSE;
 		}
@@ -7697,15 +7697,15 @@ restore_complete_reg(stream_context_t *strcxtp)
 
 	/* set the access and modification times
 	 */
-	utimbuf.actime = ( time32_t )bstatp->bs_atime.tv_sec;
-	utimbuf.modtime = ( time32_t )bstatp->bs_mtime.tv_sec;
-	rval = utime( path, &utimbuf );
-	if ( rval ) {
-		mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+	utimbuf.actime = (time32_t)bstatp->bs_atime.tv_sec;
+	utimbuf.modtime = (time32_t)bstatp->bs_mtime.tv_sec;
+	rval = utime(path, &utimbuf);
+	if (rval) {
+		mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 		      "unable to set access and modification "
 		      "times of %s: %s\n"),
 		      path,
-		      strerror( errno ));
+		      strerror(errno));
 	}
 
 	/* set the owner and group (if enabled)
@@ -7718,15 +7718,15 @@ restore_complete_reg(stream_context_t *strcxtp)
 
 	/* set the permissions/mode
 	 */
-	rval = fchmod( fd, ( mode_t )bstatp->bs_mode );
-	if ( rval ) {
-		mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+	rval = fchmod(fd, (mode_t)bstatp->bs_mode);
+	if (rval) {
+		mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 		      "unable to set mode of %s: %s\n"),
 		      path,
-		      strerror( errno ));
+		      strerror(errno));
 	}
 
-	if ( persp->a.dstdirisxfspr && persp->a.restoredmpr ) {
+	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
 		fsdmidata_t fssetdm;
 
 		/* Set the DMAPI Fields. */
@@ -7734,30 +7734,30 @@ restore_complete_reg(stream_context_t *strcxtp)
 		fssetdm.fsd_padding = 0;
 		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
 
-		rval = ioctl( fd, XFS_IOC_FSSETDM, ( void * )&fssetdm );
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING,
+		rval = ioctl(fd, XFS_IOC_FSSETDM, (void *)&fssetdm);
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING,
 			      _("attempt to set DMI attributes of %s "
 			      "failed: %s\n"),
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 
-		HsmEndRestoreFile( path, fd, &strcxtp->sc_hsmflags );
+		HsmEndRestoreFile(path, fd, &strcxtp->sc_hsmflags);
 	}
 
 	/* set any extended inode flags that couldn't be set
 	 * prior to restoring the data.
 	 */
-	if ( persp->a.dstdirisxfspr && bstatp->bs_xflags & POST_DATA_XFLAGS ) {
+	if (persp->a.dstdirisxfspr && bstatp->bs_xflags & POST_DATA_XFLAGS) {
 		struct fsxattr fsxattr;
-		memset((void *)&fsxattr, 0, sizeof( fsxattr ));
+		memset((void *)&fsxattr, 0, sizeof(fsxattr));
 		fsxattr.fsx_xflags = bstatp->bs_xflags;
 		fsxattr.fsx_extsize = (uint32_t)bstatp->bs_extsize;
 		fsxattr.fsx_projid = bstat_projid(bstatp);
 
-		rval = ioctl( fd, XFS_IOC_FSSETXATTR, (void *)&fsxattr );
-		if ( rval < 0 ) {
+		rval = ioctl(fd, XFS_IOC_FSSETXATTR, (void *)&fsxattr);
+		if (rval < 0) {
 			mlog(MLOG_NORMAL | MLOG_WARNING,
 			     _("attempt to set extended attributes "
 			     "(xflags 0x%x, extsize = 0x%x, projid = 0x%x) "
@@ -7776,18 +7776,18 @@ restore_complete_reg(stream_context_t *strcxtp)
 
 /* ARGSUSED */
 static bool_t
-restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
+restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	struct utimbuf utimbuf;
 	char *printstr;
 	int rval;
 
-	if ( ! path ) {
+	if (! path) {
 		return BOOL_TRUE;
 	}
 
-	switch ( bstatp->bs_mode & S_IFMT ) {
+	switch (bstatp->bs_mode & S_IFMT) {
 	case S_IFBLK:
 		printstr = _("block special file");
 		break;
@@ -7806,131 +7806,131 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 		printstr = _("UNIX domain socket");
 		break;
 	default:
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "%s: unknown file type: mode 0x%x ino %llu\n"),
 		      path,
 		      bstatp->bs_mode,
-		      fhdrp->fh_stat.bs_ino );
+		      fhdrp->fh_stat.bs_ino);
 		return BOOL_TRUE;
 	}
 
-	if ( ! tranp->t_toconlypr ) {
-		mlog( MLOG_TRACE,
+	if (! tranp->t_toconlypr) {
+		mlog(MLOG_TRACE,
 		      "restoring %s ino %llu %s\n",
 		      printstr,
 		      fhdrp->fh_stat.bs_ino,
-		      path );
+		      path);
 	} else {
-		mlog( MLOG_NORMAL | MLOG_BARE,
+		mlog(MLOG_NORMAL | MLOG_BARE,
 		      "%s\n",
-		      path );
+		      path);
 	}
 
-	if ( ! tranp->t_toconlypr ) {
-		if ( ( bstatp->bs_mode & S_IFMT ) == S_IFSOCK ) {
+	if (! tranp->t_toconlypr) {
+		if ((bstatp->bs_mode & S_IFMT) == S_IFSOCK) {
 			int sockfd;
 			struct sockaddr_un addr;
 			size_t addrlen;
 
-			sockfd = socket( AF_UNIX, SOCK_STREAM, 0 );
-			if ( sockfd < 0 ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
+			if (sockfd < 0) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 				      "unable to create "
 				      "%s ino %llu %s: %s: discarding\n"),
 				      printstr,
 				      fhdrp->fh_stat.bs_ino,
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 				return BOOL_TRUE;
 			}
-			memset( ( void * )&addr, 0, sizeof( addr ));
+			memset((void *)&addr, 0, sizeof(addr));
 			addr.sun_family = AF_UNIX;
-			if ( strlen( path ) >= sizeof( addr.sun_path )) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			if (strlen(path) >= sizeof(addr.sun_path)) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 				      "pathname too long for bind of "
 				      "%s ino %llu %s: discarding\n"),
 				      printstr,
 				      fhdrp->fh_stat.bs_ino,
-				      path );
-				( void )close( sockfd );
+				      path);
+				(void)close(sockfd);
 				return BOOL_TRUE;
 			}
-			strcpy( addr.sun_path, path );
-			addrlen = strlen( addr.sun_path )
+			strcpy(addr.sun_path, path);
+			addrlen = strlen(addr.sun_path)
 				  +
-				  sizeof( addr.sun_family );
-			rval = bind( sockfd,
-				     ( struct sockaddr * )&addr,
-				     ( int )addrlen );
-			if ( rval < 0 ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+				  sizeof(addr.sun_family);
+			rval = bind(sockfd,
+				     (struct sockaddr *)&addr,
+				     (int)addrlen);
+			if (rval < 0) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 				      "unable to bind "
 				      "%s ino %llu %s: %s: discarding\n"),
 				      printstr,
 				      fhdrp->fh_stat.bs_ino,
 				      path,
-				      strerror( errno ));
-				( void )close( sockfd );
+				      strerror(errno));
+				(void)close(sockfd);
 				return BOOL_TRUE;
 			}
-			( void )close( sockfd );
+			(void)close(sockfd);
 
 		} else {
 			/* create the node
 			*/
-			rval = mknod( path,
-				      ( mode_t )bstatp->bs_mode,
-				      ( dev_t )IRIX_DEV_TO_KDEVT(bstatp->bs_rdev));
-			if ( rval && rval != EEXIST ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+			rval = mknod(path,
+				      (mode_t)bstatp->bs_mode,
+				      (dev_t)IRIX_DEV_TO_KDEVT(bstatp->bs_rdev));
+			if (rval && rval != EEXIST) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 				      "unable to create %s "
 				      "ino %llu %s: %s: discarding\n"),
 				      printstr,
 				      fhdrp->fh_stat.bs_ino,
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 				return BOOL_TRUE;
 			}
 		}
 
 		/* set the owner and group (if enabled)
 		 */
-		if ( persp->a.ownerpr ) {
-			rval = chown( path,
-				      ( uid_t )bstatp->bs_uid,
-				      ( gid_t )bstatp->bs_gid );
-			if ( rval ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING,
+		if (persp->a.ownerpr) {
+			rval = chown(path,
+				      (uid_t)bstatp->bs_uid,
+				      (gid_t)bstatp->bs_gid);
+			if (rval) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING,
 				      _("chown (uid=%u, gid=%u) %s "
 				      "failed: %s\n"),
 				      bstatp->bs_uid,
 				      bstatp->bs_gid,
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 			}
 		}
 
 		/* set the permissions/mode
 		 */
-		rval = chmod( path, ( mode_t )fhdrp->fh_stat.bs_mode );
-		if ( rval ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		rval = chmod(path, (mode_t)fhdrp->fh_stat.bs_mode);
+		if (rval) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to set mode of %s: %s\n"),
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 
 		/* set the access and modification times
 		 */
-		utimbuf.actime = ( time32_t )bstatp->bs_atime.tv_sec;
-		utimbuf.modtime = ( time32_t )bstatp->bs_mtime.tv_sec;
-		rval = utime( path, &utimbuf );
-		if ( rval ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		utimbuf.actime = (time32_t)bstatp->bs_atime.tv_sec;
+		utimbuf.modtime = (time32_t)bstatp->bs_mtime.tv_sec;
+		rval = utime(path, &utimbuf);
+		if (rval) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to set access and modification "
 			      "times of %s: %s\n"),
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 		}
 	}
 
@@ -7938,12 +7938,12 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 }
 
 static bool_t
-restore_symlink( drive_t *drivep,
+restore_symlink(drive_t *drivep,
 		 filehdr_t *fhdrp,
 		 rv_t *rvp,
 		 char *path,
 		 char *scratchpath,
-		 bool_t ehcs )
+		 bool_t ehcs)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	drive_ops_t *dop = drivep->d_opsp;
@@ -7954,46 +7954,46 @@ restore_symlink( drive_t *drivep,
 	rv_t rv;
 	mode_t oldumask;
 
-	if ( path ) {
-		if ( ! tranp->t_toconlypr ) {
-			mlog( MLOG_TRACE,
+	if (path) {
+		if (! tranp->t_toconlypr) {
+			mlog(MLOG_TRACE,
 			      "restoring symbolic link ino %llu %s\n",
 			      bstatp->bs_ino,
-			      path );
+			      path);
 		} else {
-			mlog( MLOG_NORMAL | MLOG_BARE,
+			mlog(MLOG_NORMAL | MLOG_BARE,
 			      "%s\n",
-			      path );
+			      path);
 		}
 	}
 
 	/* read the extent header
 	 */
-	rv = read_extenthdr( drivep, &ehdr, ehcs );
-	if ( rv != RV_OK ) {
+	rv = read_extenthdr(drivep, &ehdr, ehcs);
+	if (rv != RV_OK) {
 		*rvp = rv;
 		return BOOL_FALSE;
 	}
 
 	/* symlinks always have one extent
 	 */
-	assert( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
+	assert(ehdr.eh_type == EXTENTHDR_TYPE_DATA);
 
 	/* read the link path extent
 	 */
-	if ( ehdr.eh_sz < ( off64_t )( 2 * MAXPATHLEN )) {
+	if (ehdr.eh_sz < (off64_t)(2 * MAXPATHLEN)) {
 		scratch = scratchpath;
 	} else {
 		scratch = 0;
 	}
-	nread = read_buf( scratch,
-			  ( size_t )ehdr.eh_sz,
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
-	if ( rval ) {
-		switch( rval ) {
+	nread = read_buf(scratch,
+			  (size_t)ehdr.eh_sz,
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
+	if (rval) {
+		switch(rval) {
 		case DRIVE_ERROR_EOF:
 		case DRIVE_ERROR_EOD:
 		case DRIVE_ERROR_EOM:
@@ -8012,19 +8012,19 @@ restore_symlink( drive_t *drivep,
 		}
 		return BOOL_FALSE;
 	}
-	assert( ( off64_t )nread == ehdr.eh_sz );
-	if ( ! scratch ) {
-		if ( path ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+	assert((off64_t)nread == ehdr.eh_sz);
+	if (! scratch) {
+		if (path) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to create symlink ino %llu "
 			      "%s: src too long: discarding\n"),
 			      bstatp->bs_ino,
-			      path );
+			      path);
 		}
 		return BOOL_TRUE;
 	}
-	scratchpath[ nread ] = 0;
-	if ( ! tranp->t_toconlypr && path ) {
+	scratchpath[nread] = 0;
+	if (! tranp->t_toconlypr && path) {
 		/* create the symbolic link
 		 */
 		/* NOTE: There is no direct way to set mode for
@@ -8032,40 +8032,40 @@ restore_symlink( drive_t *drivep,
 		 * No way of setting times for sym links.
 		 */
 
-		oldumask = umask( (( mode_t )(~bstatp->bs_mode)) & 0777 );
+		oldumask = umask(((mode_t)(~bstatp->bs_mode)) & 0777);
 
-		rval = symlink( scratchpath, path );
+		rval = symlink(scratchpath, path);
 
-		umask( oldumask );
+		umask(oldumask);
 
-		if ( rval ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		if (rval) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to create "
 			      "symlink ino %llu %s: %s: discarding\n"),
 			      bstatp->bs_ino,
 			      path,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_TRUE;
 		}
 
 		/* set the owner and group (if enabled)
 		 */
-		if ( persp->a.ownerpr ) {
-			rval = lchown( path,
-				       ( uid_t )bstatp->bs_uid,
-				       ( gid_t )bstatp->bs_gid );
-			if ( rval ) {
-				mlog( MLOG_VERBOSE | MLOG_WARNING,
+		if (persp->a.ownerpr) {
+			rval = lchown(path,
+				       (uid_t)bstatp->bs_uid,
+				       (gid_t)bstatp->bs_gid);
+			if (rval) {
+				mlog(MLOG_VERBOSE | MLOG_WARNING,
 				      _("chown (uid=%u, gid=%u) %s "
 				      "failed: %s\n"),
 				      bstatp->bs_uid,
 				      bstatp->bs_gid,
 				      path,
-				      strerror( errno ));
+				      strerror(errno));
 			}
 		}
 
-		if ( persp->a.restoredmpr) {
+		if (persp->a.restoredmpr) {
 		fsdmidata_t fssetdm;
 
 		/*	Restore DMAPI fields. */
@@ -8082,7 +8082,7 @@ restore_symlink( drive_t *drivep,
 
 /* ARGSUSED */
 static rv_t
-read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
+read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	drive_ops_t *dop = drivep->d_opsp;
@@ -8091,15 +8091,15 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 	int rval;
 	filehdr_t tmpfh;
 
-	nread = read_buf( ( char * )&tmpfh,
-			  sizeof( *fhdrp ),
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
+	nread = read_buf((char *)&tmpfh,
+			  sizeof(*fhdrp),
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
 	xlate_filehdr(&tmpfh, fhdrp, 1);
 
-	switch( rval ) {
+	switch(rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8115,24 +8115,24 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 	default:
 		return RV_CORE;
 	}
-	assert( ( size_t )nread == sizeof( *fhdrp ));
+	assert((size_t)nread == sizeof(*fhdrp));
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "read file hdr off %lld flags 0x%x ino %llu mode 0x%08x\n",
 	      fhdrp->fh_offset,
 	      fhdrp->fh_flags,
 	      bstatp->bs_ino,
-	      bstatp->bs_mode );
+	      bstatp->bs_mode);
 
-	if ( fhcs ) {
-		if ( ! ( fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "corrupt file header\n") );
+	if (fhcs) {
+		if (! (fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			      "corrupt file header\n"));
 			return RV_CORRUPT;
 		}
-		if ( !is_checksum_valid( fhdrp, FILEHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "bad file header checksum\n") );
+		if (!is_checksum_valid(fhdrp, FILEHDR_SZ)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			      "bad file header checksum\n"));
 			return RV_CORRUPT;
 		}
 	}
@@ -8142,7 +8142,7 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 
 /* ARGSUSED */
 static rv_t
-read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
+read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
@@ -8150,15 +8150,15 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 	int rval;
 	extenthdr_t tmpeh;
 
-	nread = read_buf( ( char * )&tmpeh,
-			  sizeof( *ehdrp ),
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
+	nread = read_buf((char *)&tmpeh,
+			  sizeof(*ehdrp),
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
 	xlate_extenthdr(&tmpeh, ehdrp, 1);
 
-	switch( rval ) {
+	switch(rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8174,24 +8174,24 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 	default:
 		return RV_CORE;
 	}
-	assert( ( size_t )nread == sizeof( *ehdrp ));
+	assert((size_t)nread == sizeof(*ehdrp));
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "read extent hdr size %lld offset %lld type %d flags %08x\n",
 	      ehdrp->eh_sz,
 	      ehdrp->eh_offset,
 	      ehdrp->eh_type,
-	      ehdrp->eh_flags );
+	      ehdrp->eh_flags);
 
-	if ( ehcs ) {
-		if ( ! ( ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "corrupt extent header\n") );
+	if (ehcs) {
+		if (! (ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			      "corrupt extent header\n"));
 			return RV_CORRUPT;
 		}
-		if ( !is_checksum_valid( ehdrp, EXTENTHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "bad extent header checksum\n") );
+		if (!is_checksum_valid(ehdrp, EXTENTHDR_SZ)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			      "bad extent header checksum\n"));
 			return RV_CORRUPT;
 		}
 	}
@@ -8201,10 +8201,10 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 
 /* ARGSUSED */
 static rv_t
-read_dirent( drive_t *drivep,
+read_dirent(drive_t *drivep,
 	     direnthdr_t *dhdrp,
 	     size_t direntbufsz,
-	     bool_t dhcs )
+	     bool_t dhcs)
 {
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_ops_t *dop = drivep->d_opsp;
@@ -8214,19 +8214,19 @@ read_dirent( drive_t *drivep,
 	direnthdr_t tmpdh;
 	char *namep;    // beginning of name following the direnthdr_t
 
-	assert( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
-	assert( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
+	assert(sizeof(direnthdr_t) == DIRENTHDR_SZ);
+	assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ);
 
 	/* read the head of the dirent
 	 */
-	nread = read_buf( ( char * )&tmpdh,
+	nread = read_buf((char *)&tmpdh,
 			  DIRENTHDR_SZ,
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)
 			  dop->do_return_read_buf,
-			  &rval );
-	switch( rval ) {
+			  &rval);
+	switch(rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8242,15 +8242,15 @@ read_dirent( drive_t *drivep,
 	default:
 		return RV_CORE;
 	}
-	assert( ( size_t )nread == DIRENTHDR_SZ );
+	assert((size_t)nread == DIRENTHDR_SZ);
 
-	if ( grhdrp->gh_version >= GLOBAL_HDR_VERSION_3 ) {
+	if (grhdrp->gh_version >= GLOBAL_HDR_VERSION_3) {
 		xlate_direnthdr(&tmpdh, dhdrp, 1);
 		namep = dhdrp->dh_name + sizeof(dhdrp->dh_name);
 
-		if ( dhcs && !is_checksum_valid( dhdrp, DIRENTHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-				"bad directory entry header checksum\n") );
+		if (dhcs && !is_checksum_valid(dhdrp, DIRENTHDR_SZ)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+				"bad directory entry header checksum\n"));
 			return RV_CORRUPT;
 		}
 	} else {
@@ -8263,47 +8263,47 @@ read_dirent( drive_t *drivep,
 		memcpy(dhdrp->dh_name, dhdr_v1.dh_name, sizeof(dhdr_v1.dh_name));
 		namep = dhdrp->dh_name + sizeof(dhdr_v1.dh_name);
 
-		if ( dhcs && !is_checksum_valid( &dhdr_v1, DIRENTHDR_SZ )) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-				"bad directory entry header checksum\n") );
+		if (dhcs && !is_checksum_valid(&dhdr_v1, DIRENTHDR_SZ)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+				"bad directory entry header checksum\n"));
 			return RV_CORRUPT;
 		}
 	}
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "read dirent hdr ino %llu gen %u size %u\n",
 	      dhdrp->dh_ino,
-	      ( size_t )dhdrp->dh_gen,
-	      ( size_t )dhdrp->dh_sz );
+	      (size_t)dhdrp->dh_gen,
+	      (size_t)dhdrp->dh_sz);
 
-	if ( dhdrp->dh_sz == 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			"corrupt directory entry header\n") );
+	if (dhdrp->dh_sz == 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			"corrupt directory entry header\n"));
 		return RV_CORRUPT;
 	}
 
 	/* if null, return
 	 */
-	if ( dhdrp->dh_ino == 0 ) {
-		assert( ( size_t )dhdrp->dh_sz == sizeof( direnthdr_t ));
+	if (dhdrp->dh_ino == 0) {
+		assert((size_t)dhdrp->dh_sz == sizeof(direnthdr_t));
 		return RV_OK;
 	}
 
 	/* read the remainder of the dirent.
 	 */
-	assert( ( size_t )dhdrp->dh_sz <= direntbufsz );
-	assert( ( size_t )dhdrp->dh_sz >= sizeof( direnthdr_t ));
-	assert( ! ( ( size_t )dhdrp->dh_sz & ( DIRENTHDR_ALIGN - 1 )));
-	if ( ( size_t )dhdrp->dh_sz > sizeof( direnthdr_t )) {
-		size_t remsz = ( size_t )dhdrp->dh_sz - sizeof( direnthdr_t );
-		nread = read_buf( namep,
+	assert((size_t)dhdrp->dh_sz <= direntbufsz);
+	assert((size_t)dhdrp->dh_sz >= sizeof(direnthdr_t));
+	assert(! ((size_t)dhdrp->dh_sz & (DIRENTHDR_ALIGN - 1)));
+	if ((size_t)dhdrp->dh_sz > sizeof(direnthdr_t)) {
+		size_t remsz = (size_t)dhdrp->dh_sz - sizeof(direnthdr_t);
+		nread = read_buf(namep,
 				  remsz,
-				  ( void * )drivep,
-				  ( rfp_t )dop->do_read,
-				  ( rrbfp_t )
+				  (void *)drivep,
+				  (rfp_t)dop->do_read,
+				  (rrbfp_t)
 				  dop->do_return_read_buf,
-				  &rval );
-		switch( rval ) {
+				  &rval);
+		switch(rval) {
 		case 0:
 			break;
 		case DRIVE_ERROR_EOD:
@@ -8319,7 +8319,7 @@ read_dirent( drive_t *drivep,
 		default:
 			return RV_CORE;
 		}
-		assert( ( size_t ) nread == remsz );
+		assert((size_t) nread == remsz);
 	}
 
 	return RV_OK;
@@ -8327,7 +8327,7 @@ read_dirent( drive_t *drivep,
 
 /* ARGSUSED */
 static rv_t
-read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
+read_extattrhdr(drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
@@ -8335,15 +8335,15 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	int rval;
 	extattrhdr_t tmpah;
 
-	nread = read_buf( ( char * )&tmpah,
-			  sizeof( *ahdrp ),
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
+	nread = read_buf((char *)&tmpah,
+			  sizeof(*ahdrp),
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
 	xlate_extattrhdr(&tmpah, ahdrp, 1);
 
-	switch( rval ) {
+	switch(rval) {
 	case 0:
 		break;
 	case DRIVE_ERROR_EOD:
@@ -8359,38 +8359,38 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	default:
 		return RV_CORE;
 	}
-	assert( ( size_t )nread == sizeof( *ahdrp ));
+	assert((size_t)nread == sizeof(*ahdrp));
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "read extattr hdr sz %u valoff %u flags 0x%x valsz %u cs 0x%x\n",
 	      ahdrp->ah_sz,
-	      ( uint )ahdrp->ah_valoff,
-	      ( uint )ahdrp->ah_flags,
+	      (uint)ahdrp->ah_valoff,
+	      (uint)ahdrp->ah_flags,
 	      ahdrp->ah_valsz,
-	      ahdrp->ah_checksum );
+	      ahdrp->ah_checksum);
 
-	if ( ahcs ) {
-		if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM ) {
-			if ( !is_checksum_valid( ahdrp, EXTATTRHDR_SZ )) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
-					"bad extattr header checksum\n") );
+	if (ahcs) {
+		if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM) {
+			if (!is_checksum_valid(ahdrp, EXTATTRHDR_SZ)) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
+					"bad extattr header checksum\n"));
 				return RV_CORRUPT;
 			}
-		} else if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_OLD_CHECKSUM ) {
+		} else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_OLD_CHECKSUM) {
 			/* possibly a corrupt header, but most likely an old
 			 * header, which cannot be verified due to a bug in how
 			 * its checksum was calculated.
 			 */
 			static bool_t warned = BOOL_FALSE;
-			if ( !warned ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (!warned) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					"ignoring old-style extattr "
-					"header checksums\n") );
+					"header checksums\n"));
 				warned = BOOL_TRUE;
 			}
 		} else {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
-			      "corrupt extattr header\n") );
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
+			      "corrupt extattr header\n"));
 			return RV_CORRUPT;
 		}
 	}
@@ -8399,22 +8399,22 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 }
 
 static rv_t
-discard_padding( size_t sz, drive_t *drivep )
+discard_padding(size_t sz, drive_t *drivep)
 {
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	int nread;
 	int rval;
 
-	nread = read_buf( 0,
+	nread = read_buf(0,
 			  sz,
-			  ( void * )drivep,
-			  ( rfp_t )dop->do_read,
-			  ( rrbfp_t )dop->do_return_read_buf,
-			  &rval );
-	switch( rval ) {
+			  (void *)drivep,
+			  (rfp_t)dop->do_read,
+			  (rrbfp_t)dop->do_return_read_buf,
+			  &rval);
+	switch(rval) {
 	case 0:
-		assert( ( size_t )nread == sz );
+		assert((size_t)nread == sz);
 		return RV_OK;
 	case DRIVE_ERROR_EOF:
 	case DRIVE_ERROR_EOD:
@@ -8432,12 +8432,12 @@ discard_padding( size_t sz, drive_t *drivep )
 }
 
 static rv_t
-restore_extent( filehdr_t *fhdrp,
+restore_extent(filehdr_t *fhdrp,
 		extenthdr_t *ehdrp,
 		int fd,
 		char *path,
 		drive_t *drivep,
-		off64_t *bytesreadp )
+		off64_t *bytesreadp)
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	drive_ops_t *dop = drivep->d_opsp;
@@ -8449,35 +8449,35 @@ restore_extent( filehdr_t *fhdrp,
 
 	*bytesreadp = 0;
 
-	if ( fd != -1 ) {
-		assert( path );
+	if (fd != -1) {
+		assert(path);
 		/* seek to the beginning of the extent.
 		 * must be on a basic fs blksz boundary.
 		 */
-		assert( ( off & ( off64_t )( BBSIZE - 1 )) == 0 );
-		new_off = lseek64(  fd, off, SEEK_SET );
-		if ( new_off < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		assert((off & (off64_t)(BBSIZE - 1)) == 0);
+		new_off = lseek64(fd, off, SEEK_SET);
+		if (new_off < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "attempt to seek %s to %lld failed: %s: "
 			      "not restoring extent off %lld sz %lld\n"),
 			      path,
 			      off,
-			      strerror( errno ),
+			      strerror(errno),
 			      off,
-			      sz );
+			      sz);
 			fd = -1;
 			new_off = off;
 		}
-		assert( new_off == off );
+		assert(new_off == off);
 	}
-	if ( (fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME) ) {
-		if ( (ioctl(fd, XFS_IOC_DIOINFO, &da) < 0) ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if ((fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME)) {
+		if ((ioctl(fd, XFS_IOC_DIOINFO, &da) < 0)) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "dioinfo %s failed: "
 			      "%s: discarding ino %llu\n"),
 			      path,
-			      strerror( errno ),
-			      fhdrp->fh_stat.bs_ino );
+			      strerror(errno),
+			      fhdrp->fh_stat.bs_ino);
 			fd = -1;
 		} else
 			isrealtime = BOOL_TRUE;
@@ -8485,7 +8485,7 @@ restore_extent( filehdr_t *fhdrp,
 
 	/* move from media to fs.
 	 */
-	while ( sz ) {
+	while (sz) {
 		char *bufp;
 		size_t req_bufsz;	/* requested bufsz */
 		size_t sup_bufsz;	/* supplied bufsz */
@@ -8493,12 +8493,12 @@ restore_extent( filehdr_t *fhdrp,
 		int rval;
 		size_t ntowrite;
 
-		req_bufsz = ( size_t )min( ( off64_t )INTGENMAX, sz );
-		bufp = ( * dop->do_read )(drivep, req_bufsz, &sup_bufsz, &rval);
-		if ( rval ) {
+		req_bufsz = (size_t)min((off64_t)INTGENMAX, sz);
+		bufp = (* dop->do_read)(drivep, req_bufsz, &sup_bufsz, &rval);
+		if (rval) {
 			rv_t rv;
 			char *reasonstr;
-			switch( rval ) {
+			switch(rval) {
 			case DRIVE_ERROR_EOF:
 				rv = RV_EOD;
 				reasonstr = _("end of media file");
@@ -8529,56 +8529,56 @@ restore_extent( filehdr_t *fhdrp,
 				reasonstr = _("dumping core");
 				break;
 			}
-			mlog( MLOG_NORMAL, _(
+			mlog(MLOG_NORMAL, _(
 			      "attempt to read %u bytes failed: %s\n"),
 			      req_bufsz,
-			      reasonstr );
+			      reasonstr);
 			return rv;
 		}
-		if ( off >= bstatp->bs_size ) {
-			assert( off == bstatp->bs_size );
+		if (off >= bstatp->bs_size) {
+			assert(off == bstatp->bs_size);
 			ntowrite = 0;
-		} else if ((off64_t)sup_bufsz > bstatp->bs_size - off ) {
-			ntowrite = ( size_t )( bstatp->bs_size - off );
+		} else if ((off64_t)sup_bufsz > bstatp->bs_size - off) {
+			ntowrite = (size_t)(bstatp->bs_size - off);
 		} else {
 			ntowrite = sup_bufsz;
 		}
-		assert( ntowrite <= ( size_t )INTGENMAX );
-		if ( ntowrite > 0 ) {
-			*bytesreadp += ( off64_t )ntowrite;
-			if ( fd != -1 ) {
+		assert(ntowrite <= (size_t)INTGENMAX);
+		if (ntowrite > 0) {
+			*bytesreadp += (off64_t)ntowrite;
+			if (fd != -1) {
 				size_t tries;
 				size_t remaining;
 				int rval;
 				off64_t tmp_off;
 
 				rval = 0; /* for lint */
-				for ( nwritten = 0,
+				for (nwritten = 0,
 				      tries = 0,
 				      remaining = ntowrite,
 				      tmp_off = off
 				      ;
-				      nwritten < ( int )ntowrite
+				      nwritten < (int)ntowrite
 				      &&
 				      tries < WRITE_TRIES_MAX
 				      ;
 				      nwritten += rval,
 				      tries++,
-				      remaining -= ( size_t )rval,
-				      tmp_off += ( off64_t )rval ) {
+				      remaining -= (size_t)rval,
+				      tmp_off += (off64_t)rval) {
 					int rttrunc = 0;
 					int trycnt = 0;
-					assert( remaining
+					assert(remaining
 						<=
-						( size_t )INTGENMAX );
+						(size_t)INTGENMAX);
 					/*
 					 * Realtime files must be written
 					 * to the end of the block even if
 					 * it has been truncated back.
 					 */
-					if ( isrealtime &&
+					if (isrealtime &&
 					    (remaining % da.d_miniosz != 0 ||
-					     remaining < da.d_miniosz) ) {
+					     remaining < da.d_miniosz)) {
 						/*
 						 * Since the ring and static
 						 * buffers from the different
@@ -8603,20 +8603,20 @@ restore_extent( filehdr_t *fhdrp,
 					 * if ENOSPC still occurs.
 					 */
 					for (trycnt = 0; trycnt < 3; trycnt++) {
-						rval = write( fd, bufp, remaining );
+						rval = write(fd, bufp, remaining);
 						if (rval >= 0 || errno != ENOSPC)
 							break;
 
-						( trycnt == 0 ) ?
+						(trycnt == 0) ?
 							fdatasync(fd) : sync();
 					}
-					if ( rval < 0 ) {
+					if (rval < 0) {
 						nwritten = rval;
 						break;
 					}
-					assert( ( size_t )rval <= remaining );
-					if ( rval < remaining ) {
-						mlog( MLOG_NORMAL | MLOG_WARNING,
+					assert((size_t)rval <= remaining);
+					if (rval < remaining) {
+						mlog(MLOG_NORMAL | MLOG_WARNING,
 						      _("attempt to "
 						      "write %u bytes to %s at "
 						      "offset %lld failed: "
@@ -8624,7 +8624,7 @@ restore_extent( filehdr_t *fhdrp,
 						      remaining,
 						      path,
 						      tmp_off,
-						      rval );
+						      rval);
 					}
 					if (rttrunc) {
 						/* truncate and re-set rval */
@@ -8634,40 +8634,40 @@ restore_extent( filehdr_t *fhdrp,
 					}
 				}
 			} else {
-				nwritten = ( int )ntowrite;
+				nwritten = (int)ntowrite;
 			}
 		} else {
 			nwritten = 0;
 		}
-		( * dop->do_return_read_buf )( drivep, bufp, sup_bufsz );
-		if ( ( size_t )nwritten != ntowrite ) {
-			if ( nwritten < 0 ) {
-				mlog( MLOG_NORMAL, _(
+		(* dop->do_return_read_buf)(drivep, bufp, sup_bufsz);
+		if ((size_t)nwritten != ntowrite) {
+			if (nwritten < 0) {
+				mlog(MLOG_NORMAL, _(
 				      "attempt to write %u bytes to %s "
 				      "at offset %lld failed: %s\n"),
 				      ntowrite,
 				      path,
 				      off,
-				      strerror( errno ));
+				      strerror(errno));
 			} else {
-				assert( ( size_t )nwritten < ntowrite );
-				mlog( MLOG_NORMAL, _(
+				assert((size_t)nwritten < ntowrite);
+				mlog(MLOG_NORMAL, _(
 				      "attempt to write %u bytes to %s at "
 				      "offset %lld failed: only %d bytes "
 				      "written\n"),
 				      ntowrite,
 				      path,
 				      off,
-				      nwritten );
+				      nwritten);
 			}
 			/* stop attempting to write, but complete reads
 			 */
 			fd = -1;
-			assert( ntowrite <= ( size_t )INTGENMAX );
-			nwritten = ( int )ntowrite;
+			assert(ntowrite <= (size_t)INTGENMAX);
+			nwritten = (int)ntowrite;
 		}
-		sz -= ( off64_t )sup_bufsz;
-		off += ( off64_t )nwritten;
+		sz -= (off64_t)sup_bufsz;
+		off += (off64_t)nwritten;
 	}
 
 	return RV_OK;
@@ -8677,9 +8677,9 @@ static char *extattrbufp = 0; /* ptr to start of all the extattr buffers */
 static size_t extattrbufsz = 0; /* size of each extattr buffer */
 
 static bool_t
-extattr_init( size_t drivecnt )
+extattr_init(size_t drivecnt)
 {
-	assert( ! extattrbufp );
+	assert(! extattrbufp);
 	extattrbufsz = EXTATTRHDR_SZ		/* dump hdr */
 		       +
 		       NAME_MAX			/* attribute name */
@@ -8689,10 +8689,10 @@ extattr_init( size_t drivecnt )
 		       ATTR_MAX_VALUELEN;	/* attribute value */
 	extattrbufsz = roundup(extattrbufsz, EXTATTRHDR_ALIGN);
 
-	extattrbufp = memalign( EXTATTRHDR_ALIGN, extattrbufsz * drivecnt );
+	extattrbufp = memalign(EXTATTRHDR_ALIGN, extattrbufsz * drivecnt);
 	if (extattrbufp == NULL) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
-		      "Failed to allocate extended attribute buffer\n") );
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
+		      "Failed to allocate extended attribute buffer\n"));
 		return BOOL_FALSE;
 	}
 
@@ -8700,7 +8700,7 @@ extattr_init( size_t drivecnt )
 }
 
 static char *
-get_extattrbuf( ix_t which )
+get_extattrbuf(ix_t which)
 {
         return extattrbufp + (extattrbufsz * which);
 }
@@ -8713,53 +8713,53 @@ struct extattr_cb_ctx {
 typedef struct extattr_cb_ctx extattr_cb_ctx_t;
 
 static rv_t
-restore_extattr( drive_t *drivep,
+restore_extattr(drive_t *drivep,
 		 filehdr_t *fhdrp,
 		 char *path,
 		 bool_t ahcs,
 		 bool_t isdirpr,
 		 bool_t onlydoreadpr,
-		 dah_t dah )
+		 dah_t dah)
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	extattrhdr_t *ahdrp = ( extattrhdr_t * )get_extattrbuf( drivep->d_index );
+	extattrhdr_t *ahdrp = (extattrhdr_t *)get_extattrbuf(drivep->d_index);
 	stream_context_t *strctxp = (stream_context_t *)drivep->d_strmcontextp;
 	bstat_t *bstatp = &fhdrp->fh_stat;
 	bool_t isfilerestored = BOOL_FALSE;
 
-	assert( extattrbufp );
+	assert(extattrbufp);
 
-	if ( ! isdirpr )
+	if (! isdirpr)
 		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
 
 	/* peel off extattrs until null hdr hit
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		size_t recsz;
 		/* REFERENCED */
 		int nread;
 		int rval;
 		rv_t rv;
 
-		rv = read_extattrhdr( drivep, ahdrp, ahcs );
-		if ( rv != RV_OK ) {
+		rv = read_extattrhdr(drivep, ahdrp, ahcs);
+		if (rv != RV_OK) {
 			return rv;
 		}
 
-		if ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_NULL ) {
+		if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_NULL) {
 			return RV_OK;
 		}
 
-		recsz = ( size_t )ahdrp->ah_sz;
-		assert( recsz <= extattrbufsz );
-		assert( recsz >= EXTATTRHDR_SZ );
-		nread = read_buf( ( char * )&ahdrp[ 1 ],
+		recsz = (size_t)ahdrp->ah_sz;
+		assert(recsz <= extattrbufsz);
+		assert(recsz >= EXTATTRHDR_SZ);
+		nread = read_buf((char *)&ahdrp[1],
 				  recsz - EXTATTRHDR_SZ,
-				  ( void * )drivep,
-				  ( rfp_t )dop->do_read,
-				  ( rrbfp_t )dop->do_return_read_buf,
-				  &rval );
-		switch( rval ) {
+				  (void *)drivep,
+				  (rfp_t)dop->do_read,
+				  (rrbfp_t)dop->do_return_read_buf,
+				  &rval);
+		switch(rval) {
 		case 0:
 			break;
 		case DRIVE_ERROR_EOD:
@@ -8775,13 +8775,13 @@ restore_extattr( drive_t *drivep,
 		default:
 			return RV_CORE;
 		}
-		assert( nread == ( int )( recsz - EXTATTRHDR_SZ ));
+		assert(nread == (int)(recsz - EXTATTRHDR_SZ));
 
-		if ( ! persp->a.restoreextattrpr && ! persp->a.restoredmpr ) {
+		if (! persp->a.restoreextattrpr && ! persp->a.restoredmpr) {
 			continue;
 		}
 
-		if ( onlydoreadpr || tranp->t_toconlypr )
+		if (onlydoreadpr || tranp->t_toconlypr)
 			continue;
 
 		/* NOTE: In the cases below, if we get errors then we issue warnings
@@ -8789,15 +8789,15 @@ restore_extattr( drive_t *drivep,
 		 * We can still restore the file possibly without the
 		 * extended attributes.
 		 */
-		if ( isdirpr ) {
-			assert( ! path );
-			if ( dah != DAH_NULL ) {
-				dirattr_addextattr( dah, ahdrp );
+		if (isdirpr) {
+			assert(! path);
+			if (dah != DAH_NULL) {
+				dirattr_addextattr(dah, ahdrp);
 			}
-		} else if ( isfilerestored && path[0] != '\0' ) {
-			setextattr( path, ahdrp );
+		} else if (isfilerestored && path[0] != '\0') {
+			setextattr(path, ahdrp);
 
-			if ( persp->a.dstdirisxfspr && persp->a.restoredmpr ) {
+			if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
 				int flag = 0;
 				char *attrname = (char *)&ahdrp[1];
 				if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT)
@@ -8805,9 +8805,9 @@ restore_extattr( drive_t *drivep,
 				else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE)
 					flag = ATTR_SECURE;
 
-				HsmRestoreAttribute( flag,
+				HsmRestoreAttribute(flag,
 						     attrname,
-						     &strctxp->sc_hsmflags );
+						     &strctxp->sc_hsmflags);
 			}
 		}
 	}
@@ -8815,38 +8815,38 @@ restore_extattr( drive_t *drivep,
 }
 
 static bool_t
-restore_dir_extattr_cb( char *path, dah_t dah )
+restore_dir_extattr_cb(char *path, dah_t dah)
 {
         /*
          * directory extattr's are built during the directory phase
          * by 1 thread so we only need one extattr buffer
          * -> we pick the 0th one
          */
-	extattrhdr_t *ahdrp = ( extattrhdr_t * )get_extattrbuf( 0 );
+	extattrhdr_t *ahdrp = (extattrhdr_t *)get_extattrbuf(0);
 	bool_t ok;
 
 	/* ask the dirattr abstraction to call me back for each
 	 * extended dirattr associated with this dah.
 	 */
-	ok = dirattr_cb_extattr( dah,
+	ok = dirattr_cb_extattr(dah,
 				 restore_dir_extattr_cb_cb,
 				 ahdrp,
-				 ( void * )path );
+				 (void *)path);
 	return ok;
 }
 
 static bool_t
-restore_dir_extattr_cb_cb( extattrhdr_t *ahdrp, void *ctxp )
+restore_dir_extattr_cb_cb(extattrhdr_t *ahdrp, void *ctxp)
 {
-	char *path = ( char * )ctxp;
+	char *path = (char *)ctxp;
 
-	setextattr( path, ahdrp );
+	setextattr(path, ahdrp);
 
 	return BOOL_TRUE;
 }
 
 static void
-setextattr( char *path, extattrhdr_t *ahdrp )
+setextattr(char *path, extattrhdr_t *ahdrp)
 {
 	static	char dmiattr[] = "SGI_DMI_";
 	bool_t isrootpr = ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT;
@@ -8855,45 +8855,45 @@ setextattr( char *path, extattrhdr_t *ahdrp )
 	int attr_namespace;
 	int rval;
 
-	isdmpr = ( isrootpr &&
-		   !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1) );
+	isdmpr = (isrootpr &&
+		   !strncmp((char *)(&ahdrp[1]), dmiattr, sizeof(dmiattr)-1));
 
 	/* If restoreextattrpr not set, then we are here because -D was
 	 * specified. So return unless it looks like a root DMAPI attribute.
 	 */
-	if ( !persp->a.restoreextattrpr && !isdmpr )
+	if (!persp->a.restoreextattrpr && !isdmpr)
 		return;
 
-	if ( isrootpr ) {
+	if (isrootpr) {
 		attr_namespace = ATTR_ROOT;
-	} else if ( issecurepr ) {
+	} else if (issecurepr) {
 		attr_namespace = ATTR_SECURE;
 	} else {
 		attr_namespace = 0;
 	}
 
-	rval = attr_set( path,
-			 ( char * )( &ahdrp[ 1 ] ),
-			 ( ( char * )ahdrp ) + ( u_long_t )ahdrp->ah_valoff,
-			 ( int )ahdrp->ah_valsz,
-			 attr_namespace | ATTR_DONTFOLLOW );
-	if ( rval ) {
+	rval = attr_set(path,
+			 (char *)(&ahdrp[1]),
+			 ((char *)ahdrp) + (u_long_t)ahdrp->ah_valoff,
+			 (int)ahdrp->ah_valsz,
+			 attr_namespace | ATTR_DONTFOLLOW);
+	if (rval) {
 		char *namespace;
-		if ( isrootpr ) {
+		if (isrootpr) {
 			namespace = _("root");
-		} else if ( issecurepr ) {
+		} else if (issecurepr) {
 			namespace = _("secure");
 		} else {
 			namespace = _("non-root");
 		}
 
-		mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 		      "unable to set %s extended attribute for %s: "
 		      "%s (%d)\n"),
 		      namespace,
 		      path,
-		      strerror( errno ),
-		      errno );
+		      strerror(errno),
+		      errno);
 	}
 }
 
@@ -8911,7 +8911,7 @@ dump_partials(void)
 	pi_lock();
 	printf("\npartial_reg: count=%d\n", (int)persp->a.parrestcnt);
 	if (persp->a.parrestcnt > 0) {
-		for (i=0; i < partialmax; i++ ) {
+		for (i=0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino > 0) {
 				int j;
 
@@ -8928,7 +8928,7 @@ dump_partials(void)
 						   (long long)bsptr->endoffset);
 					}
 				}
-				printf( "\n");
+				printf("\n");
 			}
 		}
 	}
@@ -8959,7 +8959,7 @@ check_valid_partials(void)
 
 	pi_lock();
 	if (persp->a.parrestcnt > 0) {
-		for (i=0; i < partialmax; i++ ) {
+		for (i=0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino > 0) {
 				int j;
 
@@ -8972,7 +8972,7 @@ check_valid_partials(void)
 					    num_partials[j]++;
 					    if (num_partials[j] > 2) {
 						pi_unlock();
-						mlog( MLOG_NORMAL | MLOG_WARNING,
+						mlog(MLOG_NORMAL | MLOG_WARNING,
 		  "partial_reg: Too many partials (>2) for drive: %d\n", j);
 						dump_partials();
 						exit(EXIT_ERROR);
@@ -9000,7 +9000,7 @@ check_valid_partials(void)
  * should only be set after all data for a file has been restored.
  */
 static void
-partial_reg( ix_t d_index,
+partial_reg(ix_t d_index,
 	     xfs_ino_t ino,
 	     off64_t fsize,
 	     off64_t offset,
@@ -9017,7 +9017,7 @@ partial_reg( ix_t d_index,
 
 	endoffset = offset + sz;
 
-	if ( partialmax == 0 )
+	if (partialmax == 0)
 		return;
 
 	pi_lock();
@@ -9025,7 +9025,7 @@ partial_reg( ix_t d_index,
 	/* Search for a matching inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
-	for (i=0; i < partialmax; i++ ) {
+	for (i=0; i < partialmax; i++) {
 		if (persp->a.parrest[i].is_ino == ino) {
 			isptr = &persp->a.parrest[i];
 			break;
@@ -9033,11 +9033,11 @@ partial_reg( ix_t d_index,
 	}
 
 	/* If not found, find a free one, fill it in and return */
-	if ( ! isptr ) {
+	if (! isptr) {
 		mlog(MLOG_NITTY | MLOG_NOLOCK,
 			"partial_reg: no entry found for %llu\n", ino);
 		/* find a free one */
-		for (i=0; i < partialmax; i++ ) {
+		for (i=0; i < partialmax; i++) {
 			if (persp->a.parrest[i].is_ino == 0) {
 				int j;
 
@@ -9060,7 +9060,7 @@ partial_reg( ix_t d_index,
 
 		/* Should never get here. */
 		pi_unlock();
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		  "partial_reg: Out of records. Extend attrs applied early.\n"));
 #ifdef DEBUGPARTIALS
 		dump_partials();
@@ -9114,7 +9114,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 	bool_t ret;
 	int i;
 
-	if ( partialmax == 0 )
+	if (partialmax == 0)
 		return BOOL_TRUE;
 
 	pi_lock();
@@ -9128,7 +9128,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 	/* Search for the inode.  Gaps can exist so we must search
 	 * all entries.
 	 */
-	for (i=0; i < partialmax; i++ ) {
+	for (i=0; i < partialmax; i++) {
 		if (persp->a.parrest[i].is_ino == ino) {
 			isptr = &persp->a.parrest[i];
 			break;
@@ -9136,7 +9136,7 @@ partial_check (xfs_ino_t ino, off64_t fsize)
 	}
 
 	/* If not found, return okay */
-	if ( ! isptr ) {
+	if (! isptr) {
 		pi_unlock();
 		return BOOL_TRUE;
 	}
@@ -9191,9 +9191,9 @@ gapsearch:
 }
 
 static char *
-ehdr_typestr( int32_t type )
+ehdr_typestr(int32_t type)
 {
-	switch ( type ) {
+	switch (type) {
 	case EXTENTHDR_TYPE_LAST:
 		return "LAST";
 	case EXTENTHDR_TYPE_ALIGN:
@@ -9209,11 +9209,11 @@ ehdr_typestr( int32_t type )
 
 /* ARGSUSED */
 bool_t
-content_overwrite_ok( char *path,
+content_overwrite_ok(char *path,
 		      int32_t ctime,
 		      int32_t mtime,
 		      char **reasonstrp,
-		      bool_t *exists )
+		      bool_t *exists)
 {
 	struct stat statbuf;
 
@@ -9222,9 +9222,9 @@ content_overwrite_ok( char *path,
 	/* if file doesn't exist, allow
 	 */
 
-	if ( lstat( path, &statbuf )) {
+	if (lstat(path, &statbuf)) {
 		*reasonstrp = 0;
-		if ( errno == ENOENT ) {
+		if (errno == ENOENT) {
 			*exists = BOOL_FALSE;
 		}
 		return BOOL_TRUE;
@@ -9232,15 +9232,15 @@ content_overwrite_ok( char *path,
 
 	/* if overwrites absolutely inhibited, disallow
 	 */
-	if ( persp->a.existpr ) {
+	if (persp->a.existpr) {
 		*reasonstrp = _("overwrites inhibited");
 		return BOOL_FALSE;
 	}
 
 	/* if newer time specified, compare
 	 */
-	if ( persp->a.newerpr ) {
-		if ( ( time32_t )ctime < persp->a.newertime ) {
+	if (persp->a.newerpr) {
+		if ((time32_t)ctime < persp->a.newertime) {
 			*reasonstrp = _("too old");
 			return BOOL_FALSE;
 		}
@@ -9248,8 +9248,8 @@ content_overwrite_ok( char *path,
 
 	/* don't overwrite changed files
 	 */
-	if ( persp->a.changepr ) {
-		if ( statbuf.st_ctime >= ( time32_t )ctime ) {
+	if (persp->a.changepr) {
+		if (statbuf.st_ctime >= (time32_t)ctime) {
 			*reasonstrp = _("existing version is newer");
 			return BOOL_FALSE;
 		}
@@ -9261,66 +9261,66 @@ content_overwrite_ok( char *path,
 
 
 static void
-set_mcflag( ix_t thrdix )
+set_mcflag(ix_t thrdix)
 {
-	lock( );
-	mcflag[ thrdix ] = BOOL_TRUE;
+	lock();
+	mcflag[thrdix] = BOOL_TRUE;
 	content_media_change_needed = BOOL_TRUE;
-	unlock( );
+	unlock();
 }
 
 static void
-clr_mcflag( ix_t thrdix )
+clr_mcflag(ix_t thrdix)
 {
-	lock( );
-	mcflag[ thrdix ] = BOOL_FALSE;
-	for ( thrdix = 0 ; thrdix < drivecnt ; thrdix++ ) {
-		if ( mcflag[ thrdix ] ) {
-			unlock( );
+	lock();
+	mcflag[thrdix] = BOOL_FALSE;
+	for (thrdix = 0 ; thrdix < drivecnt ; thrdix++) {
+		if (mcflag[thrdix]) {
+			unlock();
 			return;
 		}
 	}
 	content_media_change_needed = BOOL_FALSE;
-	unlock( );
+	unlock();
 }
 
 /* debug functions ***********************************************************/
 
 static void
-pi_show( char *introstring )
+pi_show(char *introstring)
 {
-	char strbuf[ 100 ];
+	char strbuf[100];
 	/* REFERENCED */
 	int strbuflen;
 	fold_t fold;
 
-	if ( mlog_level_ss[ MLOG_SS_MEDIA ] < MLOG_NITTY + 1 ) {
+	if (mlog_level_ss[MLOG_SS_MEDIA] < MLOG_NITTY + 1) {
 		return;
 	}
 
-	mlog_lock( );
+	mlog_lock();
 
-	strbuflen = sprintf( strbuf,
+	strbuflen = sprintf(strbuf,
 			     "persistent inventory media file tree%s",
-			     introstring );
-	assert( ( size_t )strbuflen < sizeof( strbuf ));
-	fold_init( fold, strbuf, ':' );
-	mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			     introstring);
+	assert((size_t)strbuflen < sizeof(strbuf));
+	fold_init(fold, strbuf, ':');
+	mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 	      "\n%s\n\n",
-	      fold );
+	      fold);
 
-	pi_show_nomloglock( );
+	pi_show_nomloglock();
 
-	fold_init( fold, "end persistent inventory display", '.'  );
-	mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+	fold_init(fold, "end persistent inventory display", '.');
+	mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 	      "\n%s\n\n",
-	      fold );
+	      fold);
 
-	mlog_unlock( );
+	mlog_unlock();
 }
 
 static void
-pi_show_nomloglock( void )
+pi_show_nomloglock(void)
 {
 	dh_t strmh;
 	int strmix;
@@ -9328,191 +9328,191 @@ pi_show_nomloglock( void )
 
 	/* no point in proceeding if pi not begun
 	 */
-	if ( persp->s.strmheadh == DH_NULL ) {
-		mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
-		      "session inventory unknown\n") );
+	if (persp->s.strmheadh == DH_NULL) {
+		mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
+		      "session inventory unknown\n"));
 		return;
 	}
 
-	mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
-	      "session inventory display\n") );
+	mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA, _(
+	      "session inventory display\n"));
 
 	/* iterate over all streams
 	 */
-	for ( strmh = persp->s.strmheadh, strmix = 0
+	for (strmh = persp->s.strmheadh, strmix = 0
 	      ;
 	      strmh != DH_NULL
 	      ;
-	      strmh = DH2S( strmh )->s_nexth, strmix++ ) {
+	      strmh = DH2S(strmh)->s_nexth, strmix++) {
 		dh_t objh;
 		int objix;
 
-		mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+		mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 		      _("\nmedia stream %u:\n"),
-		      strmix );
-		if ( DH2S( strmh )->s_cldh == DH_NULL ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-			      _("\n    media objects not yet identified\n") );
+		      strmix);
+		if (DH2S(strmh)->s_cldh == DH_NULL) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			      _("\n    media objects not yet identified\n"));
 			continue;
 		}
 		/* iterate over all objects
 		 */
-		for ( objh = DH2S( strmh )->s_cldh, objix = 0
+		for (objh = DH2S(strmh)->s_cldh, objix = 0
 		      ;
 		      objh != DH_NULL
 		      ;
-		      objh = DH2O( objh )->o_nexth, objix++ ) {
+		      objh = DH2O(objh)->o_nexth, objix++) {
 			dh_t fileh;
 			ix_t fileix;
 
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 			      _("\n    media object %u:\n\n"),
-			      objix );
-			if ( DH2O( objh )->o_idlabvalpr ) {
-				if ( strlen( DH2O( objh )->o_lab )) {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-				      _("    label: ") );
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			      objix);
+			if (DH2O(objh)->o_idlabvalpr) {
+				if (strlen(DH2O(objh)->o_lab)) {
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+				      _("    label: "));
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					"\"%s\"\n",
-				      DH2O( objh )->o_lab );
+				      DH2O(objh)->o_lab);
 				} else {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-				      _("    label is blank\n") );
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+				      _("    label is blank\n"));
 				}
-				if ( ! uuid_is_null( DH2O( objh )->o_id)) {
+				if (! uuid_is_null(DH2O(objh)->o_id)) {
 				    char media_string_uuid[UUID_STR_LEN + 1];
-				    uuid_unparse( DH2O( objh )->o_id,
+				    uuid_unparse(DH2O(objh)->o_id,
 						    media_string_uuid);
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					  _("    id: %s\n"),
-					  media_string_uuid );
+					  media_string_uuid);
 				}
 			} else {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-				      _("    label not identified\n") );
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+				      _("    label not identified\n"));
 			}
-			if ( DH2O( objh )->o_fmfmixvalpr ) {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			if (DH2O(objh)->o_fmfmixvalpr) {
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 				      _("    index within object "
 				      "of first media file: %u\n"),
-				      DH2O( objh )->o_fmfmix );
+				      DH2O(objh)->o_fmfmix);
 			}
-			if ( DH2O( objh )->o_fmfsixvalpr ) {
-				mlog( MLOG_DEBUG | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			if (DH2O(objh)->o_fmfsixvalpr) {
+				mlog(MLOG_DEBUG | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 				      _("    index within stream "
 				      "of first media file: %u\n"),
-				      DH2O( objh )->o_fmfsix );
+				      DH2O(objh)->o_fmfsix);
 			}
 
-			if ( DH2O( objh )->o_indrivepr ) {
-				if ( drivecnt > 1 ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			if (DH2O(objh)->o_indrivepr) {
+				if (drivecnt > 1) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					  _("    now in drive %u\n"),
-					  DH2O( objh )->o_indriveix );
+					  DH2O(objh)->o_indriveix);
 				} else {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-					  _("    now in drive\n") );
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					  _("    now in drive\n"));
 				}
 			}
 
-			if ( DH2O( objh )->o_cldh == DH_NULL ) {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			if (DH2O(objh)->o_cldh == DH_NULL) {
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 				      _("        media files not yet "
-				      "identified\n") );
+				      "identified\n"));
 				continue;
 			}
 
 			/* iterate over all files
 			 */
-			for ( fileh = DH2O( objh )->o_cldh, fileix = 0
+			for (fileh = DH2O(objh)->o_cldh, fileix = 0
 			      ;
 			      fileh != DH_NULL
 			      ;
-			      fileh = DH2F( fileh )->f_nexth, fileix++ ) {
-			    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			      fileh = DH2F(fileh)->f_nexth, fileix++) {
+			    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 				  _("\n        media file %u"),
-				  fileix );
-			    if ( DH2O( objh )->o_fmfmixvalpr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+				  fileix);
+			    if (DH2O(objh)->o_fmfmixvalpr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					  " (%u):\n",
-					  DH2O( objh )->o_fmfmix + fileix );
+					  DH2O(objh)->o_fmfmix + fileix);
 			    } else {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-					  ":\n" );
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					  ":\n");
 			    }
-			    if ( DH2F( fileh )->f_szvalpr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			    if (DH2F(fileh)->f_szvalpr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					 _("        size: "
 					 "%lld bytes\n"),
-					 DH2F( fileh )->f_sz );
+					 DH2F(fileh)->f_sz);
 			    }
-			    if ( DH2F( fileh )->f_dirtriedpr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			    if (DH2F(fileh)->f_dirtriedpr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					 _("        used for directory "
-					 "restoral\n") );
+					 "restoral\n"));
 			    }
-			    if ( DH2F( fileh )->f_valpr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			    if (DH2F(fileh)->f_valpr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					 _("        first extent contained: "
 					 "ino %llu off %lld\n"),
-					 DH2F( fileh )->f_firstegrp.eg_ino,
-					 DH2F( fileh )->f_firstegrp.eg_off );
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					 DH2F(fileh)->f_firstegrp.eg_ino,
+					 DH2F(fileh)->f_firstegrp.eg_off);
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					 _("        next extent to restore: "
 					 "ino %llu off %lld\n"),
-					 DH2F( fileh )->f_curegrp.eg_ino,
-					 DH2F( fileh )->f_curegrp.eg_off );
-				    mlog( MLOG_DEBUG | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					 DH2F(fileh)->f_curegrp.eg_ino,
+					 DH2F(fileh)->f_curegrp.eg_off);
+				    mlog(MLOG_DEBUG | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					 _("        rollback mark %lld\n"),
-					 DH2F( fileh )->f_curmark );
+					 DH2F(fileh)->f_curmark);
 			    }
-			    if ( DH2F( fileh )->f_nondirskippr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			    if (DH2F(fileh)->f_nondirskippr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					  _("        contains no selected "
-					  "non-directories\n") );
+					  "non-directories\n"));
 			    }
-			    if ( DH2F( fileh )->f_nondirdonepr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-					  _("        non-directories done\n") );
+			    if (DH2F(fileh)->f_nondirdonepr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					  _("        non-directories done\n"));
 			    }
-			    if ( DH2F( fileh )->f_flags & PF_INV ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			    if (DH2F(fileh)->f_flags & PF_INV) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 					  _("        contains session "
-					  "inventory\n") );
+					  "inventory\n"));
 			    }
-			    if ( DH2F( fileh )->f_flags & PF_TERM ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-					  _("        is stream terminator\n") );
+			    if (DH2F(fileh)->f_flags & PF_TERM) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					  _("        is stream terminator\n"));
 			    }
-			    if ( DH2F( fileh )->f_underheadpr ) {
-				    mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
-					  _("        now reading\n") );
+			    if (DH2F(fileh)->f_underheadpr) {
+				    mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+					  _("        now reading\n"));
 			    }
 			}
-			if ( ! DH2O( objh )->o_lmfknwnpr ) {
-				mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+			if (! DH2O(objh)->o_lmfknwnpr) {
+				mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 				      _("\n        may be additional "
-				      "unidentified media files\n") );
+				      "unidentified media files\n"));
 			}
 		}
-		if ( ! DH2S( strmh )->s_lastobjknwnpr ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
+		if (! DH2S(strmh)->s_lastobjknwnpr) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK | MLOG_MEDIA,
 			      _("\n    may be "
-			      "additional unidentified media objects\n\n") );
+			      "additional unidentified media objects\n\n"));
 		}
 	}
 }
 
 static int
-egrpcmp( egrp_t *egrpap, egrp_t *egrpbp )
+egrpcmp(egrp_t *egrpap, egrp_t *egrpbp)
 {
-	if ( egrpap->eg_ino < egrpbp->eg_ino ) {
+	if (egrpap->eg_ino < egrpbp->eg_ino) {
 		return -1;
-	} else if ( egrpap->eg_ino > egrpbp->eg_ino ) {
+	} else if (egrpap->eg_ino > egrpbp->eg_ino) {
 		return 1;
-	} else if ( egrpap->eg_off < egrpbp->eg_off ) {
+	} else if (egrpap->eg_off < egrpbp->eg_off) {
 		return -1;
-	} else if ( egrpap->eg_off > egrpbp->eg_off ) {
+	} else if (egrpap->eg_off > egrpbp->eg_off) {
 		return 1;
 	} else {
 		return 0;
@@ -9520,147 +9520,147 @@ egrpcmp( egrp_t *egrpap, egrp_t *egrpbp )
 }
 
 static void
-display_dump_label( bool_t lockpr,
+display_dump_label(bool_t lockpr,
 		    int mllevel,
 		    char *introstr,
 		    global_hdr_t *grhdrp,
 		    media_hdr_t *mrhdrp,
 		    content_hdr_t *crhdrp,
-		    content_inode_hdr_t *scrhdrp )
+		    content_inode_hdr_t *scrhdrp)
 {
-	char dateline[ 28 ];
-	char level_string[ 2 ];
+	char dateline[28];
+	char level_string[2];
 	char dump_string_uuid[UUID_STR_LEN + 1];
 	char media_string_uuid[UUID_STR_LEN + 1];
 	char fs_string_uuid[UUID_STR_LEN + 1];
 
-	assert( scrhdrp->cih_level >= 0 );
-	assert( scrhdrp->cih_level < 10 );
-	level_string[ 0 ] = ( char )( '0' + ( u_char_t )scrhdrp->cih_level );
-	level_string[ 1 ] = 0;
+	assert(scrhdrp->cih_level >= 0);
+	assert(scrhdrp->cih_level < 10);
+	level_string[0] = (char)('0' + (u_char_t)scrhdrp->cih_level);
+	level_string[1] = 0;
 
 	uuid_unparse(grhdrp->gh_dumpid, dump_string_uuid);
 	uuid_unparse(mrhdrp->mh_mediaid, media_string_uuid);
 	uuid_unparse(crhdrp->ch_fsid, fs_string_uuid);
 
-	if ( lockpr ) {
-		mlog_lock( );
+	if (lockpr) {
+		mlog_lock();
 	}
 
-	mlog( mllevel | MLOG_NOLOCK,
+	mlog(mllevel | MLOG_NOLOCK,
 	      "%s",
-	      introstr );
-	mlog( mllevel | MLOG_NOLOCK,
+	      introstr);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("hostname: %s\n"),
-	      grhdrp->gh_hostname );
-	mlog( mllevel | MLOG_NOLOCK,
+	      grhdrp->gh_hostname);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("mount point: %s\n"),
-	      crhdrp->ch_mntpnt );
-	mlog( mllevel | MLOG_NOLOCK,
+	      crhdrp->ch_mntpnt);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("volume: %s\n"),
-	      crhdrp->ch_fsdevice );
-	mlog( mllevel | MLOG_NOLOCK,
+	      crhdrp->ch_fsdevice);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("session time: %s"),
-	      ctime32_r( &grhdrp->gh_timestamp, dateline ));
-	mlog( mllevel | MLOG_NOLOCK,
+	      ctime32_r(&grhdrp->gh_timestamp, dateline));
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("level: %s%s\n"),
 	      level_string,
-	      ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME )
+	      (scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME)
 	      ?
 	      _(" resumed")
 	      :
-	      "" );
-	mlog( mllevel | MLOG_NOLOCK,
-	      _("session label: ") );
-	mlog( mllevel | MLOG_NOLOCK | MLOG_BARE,
+	      "");
+	mlog(mllevel | MLOG_NOLOCK,
+	      _("session label: "));
+	mlog(mllevel | MLOG_NOLOCK | MLOG_BARE,
 	      "\"%s\"\n",
-	      grhdrp->gh_dumplabel );
-	mlog( mllevel | MLOG_NOLOCK,
-	      _("media label: ") );
-	mlog( mllevel | MLOG_NOLOCK | MLOG_BARE,
+	      grhdrp->gh_dumplabel);
+	mlog(mllevel | MLOG_NOLOCK,
+	      _("media label: "));
+	mlog(mllevel | MLOG_NOLOCK | MLOG_BARE,
 	      "\"%s\"\n",
-	      mrhdrp->mh_medialabel );
-	mlog( mllevel | MLOG_NOLOCK,
+	      mrhdrp->mh_medialabel);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("file system id: %s\n"),
-	      fs_string_uuid );
-	mlog( mllevel | MLOG_NOLOCK,
+	      fs_string_uuid);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("session id: %s\n"),
-	      dump_string_uuid );
-	mlog( mllevel | MLOG_NOLOCK,
+	      dump_string_uuid);
+	mlog(mllevel | MLOG_NOLOCK,
 	      _("media id: %s\n"),
-	      media_string_uuid );
+	      media_string_uuid);
 
-	if ( lockpr ) {
-		mlog_unlock( );
+	if (lockpr) {
+		mlog_unlock();
 	}
 }
 
 static void
-display_needed_objects( purp_t purp,
+display_needed_objects(purp_t purp,
 			bag_t *bagp,
 			bool_t knownholespr,
-			bool_t maybeholespr )
+			bool_t maybeholespr)
 {
-	if ( bagp ) {
+	if (bagp) {
 		ix_t ix;
 		bagiter_t iter;
 		bagobj_t *bagobjp;
-		if ( purp == PURP_DIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK, _(
+		if (purp == PURP_DIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK, _(
 			      "the following media objects "
 			      "contain media files not yet tried "
-			      "for directory hierarchy restoral:\n") );
+			      "for directory hierarchy restoral:\n"));
 		}
-		if ( purp == PURP_NONDIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK, _(
+		if (purp == PURP_NONDIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK, _(
 			      "the following media objects "
-			      "are needed:\n") );
+			      "are needed:\n"));
 		}
-		bagiter_init( bagp, &iter );
+		bagiter_init(bagp, &iter);
 		bagobjp = 0; /* keep lint happy */
 		ix = 0;
-		while ( bagiter_next( &iter,
-				      ( void ** )&bagobjp )) {
+		while (bagiter_next(&iter,
+				      (void **)&bagobjp)) {
 			char uuidstr[UUID_STR_LEN + 1];
-			uuid_unparse( bagobjp->id, uuidstr);
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
-			      "\n" );
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			uuid_unparse(bagobjp->id, uuidstr);
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			      "\n");
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      _("%2u. label: "),
-			      ix );
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			      ix);
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      "\"%s\"\n",
-			      bagobjp->label );
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
-			      _("    id: ") );
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			      bagobjp->label);
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+			      _("    id: "));
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      "\"%s\"\n",
-			      uuidstr );
-			if ( bagobjp->indrivepr ) {
-				if ( drivecnt > 1 ) {
-					mlog( MLOG_NORMAL
+			      uuidstr);
+			if (bagobjp->indrivepr) {
+				if (drivecnt > 1) {
+					mlog(MLOG_NORMAL
 					      |
 					      MLOG_BARE
 					      |
 					      MLOG_NOLOCK,
 					      _("    now in drive %u\n"),
-					      bagobjp->indriveix );
+					      bagobjp->indriveix);
 				} else {
-					mlog( MLOG_NORMAL
+					mlog(MLOG_NORMAL
 					      |
 					      MLOG_BARE
 					      |
 					      MLOG_NOLOCK,
-					      _("    now in drive\n") );
+					      _("    now in drive\n"));
 				}
 			}
 			ix++;
 			bagobjp = 0; /* keep lint happy */
 		}
 	}
-	if ( knownholespr ) {
-		if ( purp == PURP_DIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+	if (knownholespr) {
+		if (purp == PURP_DIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      bagp ?
 			      _("\nthere are additional unidentified media "
 			      "objects containing media files not yet tried "
@@ -9668,20 +9668,20 @@ display_needed_objects( purp_t purp,
 				:
 			      _("\nthere are unidentified media "
 			      "objects containing media files not yet tried "
-			      "for directory hierarchy restoral:\n") );
+			      "for directory hierarchy restoral:\n"));
 		}
-		if ( purp == PURP_NONDIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+		if (purp == PURP_NONDIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      bagp ?
 			      _("\nthere are additional unidentified media "
 			      "objects not yet fully restored\n")
 				:
 			      _("\nthere are unidentified media objects "
-			      "not yet fully restored\n") );
+			      "not yet fully restored\n"));
 		}
-	} else if ( maybeholespr ) {
-		if ( purp == PURP_DIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+	} else if (maybeholespr) {
+		if (purp == PURP_DIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      bagp ?
 			      _("\nthere may be additional unidentified media "
 			      "objects containing media files not yet tried "
@@ -9689,23 +9689,23 @@ display_needed_objects( purp_t purp,
 				:
 			      _("\nthere may be unidentified media "
 			      "objects containing media files not yet tried "
-			      "for directory hierarchy restoral:\n") );
+			      "for directory hierarchy restoral:\n"));
 
 		}
-		if ( purp == PURP_NONDIR ) {
-			mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+		if (purp == PURP_NONDIR) {
+			mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
 			      bagp ?
 			      _("\nthere may be additional unidentified media "
 			      "objects not yet fully restored\n")
 				:
 			      _("\there may be unidentified media "
-			      "objects not yet fully restored\n") );
+			      "objects not yet fully restored\n"));
 		}
 	}
 
-	if ( ! bagp && ! knownholespr && ! maybeholespr ) {
-		mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
-		      _("no additional media objects needed\n") );
+	if (! bagp && ! knownholespr && ! maybeholespr) {
+		mlog(MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
+		      _("no additional media objects needed\n"));
 	}
 }
 
@@ -9719,18 +9719,18 @@ do_fssetdm_by_handle(
 	int		rc;
 
 	if (path_to_handle(path, &hanp, &hlen)) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			"path_to_handle of %s failed:%s\n"),
-			path, strerror( errno ));
+			path, strerror(errno));
 		return -1;
 	}
 
 	rc = fssetdm_by_handle(hanp, hlen, fdmp);
 	free_handle(hanp, hlen);
 	if (rc) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			"fssetdm_by_handle of %s failed %s\n"),
-			path, strerror( errno ));
+			path, strerror(errno));
 	}
 	return rc;
 }
@@ -9741,16 +9741,16 @@ quotafilecheck(char *type, char *dstdir, char *quotafile)
 	struct stat s;
 	char buf[MAXPATHLEN];
 
-	sprintf( buf,
+	sprintf(buf,
 		 "%s/%s",
 		 dstdir,
-		 quotafile );
+		 quotafile);
 
-	if ( stat (buf, &s ) >= 0 && S_ISREG(s.st_mode)) {
-		mlog( MLOG_NORMAL, _(
+	if (stat (buf, &s) >= 0 && S_ISREG(s.st_mode)) {
+		mlog(MLOG_NORMAL, _(
 		      "%s quota information written to '%s'\n"),
 		      type,
-		      buf );
+		      buf);
 		return 1;
 	}
 
-- 
2.19.1
