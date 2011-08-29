Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TLfuCn091422 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 16:41:56 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: enable dump header checksums
Date: Mon, 29 Aug 2011 16:41:46 -0500
Message-Id: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
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

Various structures in a dump file optionally contain a checksum, but
the code to compute and validate the checksum has not been enabled.
The checksum code has a negligible performance impact and so this
patch enables the checksum code unconditionally. Also:

- make sure all header sizes are multiples of 4 bytes
  (a requirement of the checksum routine)
- zero structures to ensure internal padding has a known value
- fix a bug in dump_extattr_buildrecord() which checksummed
  the wrong header structure
- add calc_checksum() and is_checksum_valid() routines to
  cut down on duplicate code

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/content_inode.h |   20 +++++++++++
 dump/content.c         |   85 +++++++++++-------------------------------------
 restore/Makefile       |    2 +-
 restore/content.c      |   40 ++--------------------
 4 files changed, 44 insertions(+), 103 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index 479fdfc..e119354 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -347,4 +347,24 @@ typedef struct extattrhdr extattrhdr_t;
 	/* a linux "secure" mode attribute
 	 */
 
+/* Routines for calculating and validating checksums on xfsdump headers
+ */
+static inline u_int32_t
+calc_checksum(void *startp, void *endp)
+{
+	u_int32_t sum;
+	u_int32_t *sump = (u_int32_t *)startp;
+	for (sum = 0; sump < (u_int32_t *)endp; sum += *sump++);
+	return ~sum + 1;
+}
+
+static inline bool_t
+is_checksum_valid(void *startp, void *endp)
+{
+	u_int32_t sum;
+	u_int32_t *sump = (u_int32_t *)startp;
+	for (sum = 0; sump < (u_int32_t *)endp; sum += *sump++);
+	return sum == 0 ? BOOL_TRUE : BOOL_FALSE;
+}
+
 #endif /* CONTENT_INODE_H */
diff --git a/dump/content.c b/dump/content.c
index 9905c88..2cf15ba 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -585,6 +585,13 @@ content_init( intgen_t argc,
 		sizeof( content_inode_hdr_t ));
 	ASSERT( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
 
+	/* must be a multiple of 32-bits for checksums
+	 */
+	ASSERT( FILEHDR_SZ % sizeof( u_int32_t ) == 0 );
+	ASSERT( EXTENTHDR_SZ  % sizeof( u_int32_t ) == 0 );
+	ASSERT( DIRENTHDR_SZ % sizeof( u_int32_t ) == 0 );
+	ASSERT( EXTATTRHDR_SZ % sizeof( u_int32_t ) == 0 );
+
 	/* calculate offsets of portions of the write hdr template
 	 */
 	dwhdrtemplatep = ( drive_hdr_t * )gwhdrtemplatep->gh_upper;
@@ -1491,8 +1498,7 @@ baseuuidbypass:
 	var_skip( &fsid, inomap_skip );
 
 	/* fill in write header template content info. always produce
-	 * an inomap and dir dump for each media file. flag the checksums
-	 * available if so compiled (see -D...CHECKSUM in Makefile).
+	 * an inomap and dir dump for each media file.
 	 */
 	ASSERT( sizeof( cwhdrtemplatep->ch_specific ) >= sizeof( *scwhdrtemplatep ));
 	scwhdrtemplatep->cih_mediafiletype = CIH_MEDIAFILETYPE_DATA;
@@ -1506,15 +1512,9 @@ baseuuidbypass:
 	if ( sc_inv_updatepr ) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_INVENTORY;
 	}
-#ifdef FILEHDR_CHECKSUM
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_FILEHDR_CHECKSUM;
-#endif /* FILEHDR_CHECKSUM */
-#ifdef EXTENTHDR_CHECKSUM
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_EXTENTHDR_CHECKSUM;
-#endif /* EXTENTHDR_CHECKSUM */
-#ifdef DIRENTHDR_CHECKSUM
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_DIRENTHDR_CHECKSUM;
-#endif /* DIRENTHDR_CHECKSUM */
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_DIRENTHDR_GEN;
 	if ( sc_incrpr ) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_INCREMENTAL;
@@ -1528,10 +1528,8 @@ baseuuidbypass:
 	}
 	if ( sc_dumpextattrpr ) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_EXTATTR;
-#ifdef EXTATTRHDR_CHECKSUM
 		scwhdrtemplatep->cih_dumpattr |=
 					CIH_DUMPATTR_EXTATTRHDR_CHECKSUM;
-#endif /* EXTATTRHDR_CHECKSUM */
 	}
 
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
@@ -3743,6 +3741,8 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 		     namesz, namesrcp,
 		     valuesz );
 	( void )strcpy( namep, namesrcp );
+
+	memset( ( void * )&tmpah, 0, sizeof( tmpah ));
 	tmpah.ah_sz = recsz;
 	ASSERT( EXTATTRHDR_SZ + namesz < UINT16MAX );
 	tmpah.ah_valoff = ( u_int16_t )( EXTATTRHDR_SZ + namesz );
@@ -3750,17 +3750,8 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 		(( flag & ATTR_ROOT ) ? EXTATTRHDR_FLAGS_ROOT :
 		(( flag & ATTR_SECURE ) ? EXTATTRHDR_FLAGS_SECURE : 0));
 	tmpah.ah_valsz = valuesz;
-	tmpah.ah_checksum = 0;
-#ifdef EXTATTRHDR_CHECKSUM
-	{
-	register u_int32_t *sump = ( u_int32_t * )ahdrp;
-	register u_int32_t *endp = ( u_int32_t * )( ahdrp + 1 );
-	register u_int32_t sum;
 	tmpah.ah_flags |= EXTATTRHDR_FLAGS_CHECKSUM;
-	for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-	tmpah.ah_checksum = ~sum + 1;
-	}
-#endif /* EXTATTRHDR_CHECKSUM */
+	tmpah.ah_checksum = calc_checksum( &tmpah, &tmpah + 1 );
 
 	xlate_extattrhdr(ahdrp, &tmpah, -1);
 	*valuepp = valuep;
@@ -3782,23 +3773,13 @@ dump_extattrhdr( drive_t *drivep,
 	intgen_t rval;
 	rv_t rv;
 
+	memset( ( void * )&ahdr, 0, sizeof( ahdr ));
 	ahdr.ah_sz = recsz;
 	ASSERT( valoff < UINT16MAX );
 	ahdr.ah_valoff = ( u_int16_t )valoff;
-	ahdr.ah_flags = ( u_int16_t )flags;
+	ahdr.ah_flags = ( u_int16_t )flags | EXTATTRHDR_FLAGS_CHECKSUM;
 	ahdr.ah_valsz = valsz;
-	ahdr.ah_checksum = 0;
-
-#ifdef EXTATTRHDR_CHECKSUM
-	{
-	register u_int32_t *sump = ( u_int32_t * )&ahdr;
-	register u_int32_t *endp = ( u_int32_t * )( &ahdr + 1 );
-	register u_int32_t sum;
-	ahdr.ah_flags |= EXTATTRHDR_FLAGS_CHECKSUM;
-	for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-	ahdr.ah_checksum = ~sum + 1;
-	}
-#endif /* EXTATTRHDR_CHECKSUM */
+	ahdr.ah_checksum = calc_checksum( &ahdr, &ahdr + 1 );
 
 	xlate_extattrhdr(&ahdr, &tmpahdr, 1);
 	rval = write_buf( ( char * )&tmpahdr,
@@ -5102,11 +5083,6 @@ dump_filehdr( drive_t *drivep,
 	drive_ops_t *dop = drivep->d_opsp;
 	register filehdr_t *fhdrp = contextp->cc_filehdrp;
 	filehdr_t tmpfhdrp;
-#ifdef FILEHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )fhdrp;
-	register u_int32_t *endp = ( u_int32_t * )( fhdrp + 1 );
-	register u_int32_t sum;
-#endif /* FILEHDR_CHECKSUM */
 	intgen_t rval;
 	rv_t rv;
 
@@ -5118,13 +5094,8 @@ dump_filehdr( drive_t *drivep,
 		copy_xfs_bstat(&fhdrp->fh_stat, statp);
 	}
 	fhdrp->fh_offset = offset;
-	fhdrp->fh_flags = flags;
-
-#ifdef FILEHDR_CHECKSUM
-	fhdrp->fh_flags |= FILEHDR_FLAGS_CHECKSUM;
-	for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-	fhdrp->fh_checksum = ~sum + 1;
-#endif /* FILEHDR_CHECKSUM */
+	fhdrp->fh_flags = flags | FILEHDR_FLAGS_CHECKSUM;
+	fhdrp->fh_checksum = calc_checksum( fhdrp, fhdrp + 1 );
 
 	xlate_filehdr(fhdrp, &tmpfhdrp, 1);
 	rval = write_buf( ( char * )&tmpfhdrp,
@@ -5164,11 +5135,6 @@ dump_extenthdr( drive_t *drivep,
 	drive_ops_t *dop = drivep->d_opsp;
 	register extenthdr_t *ehdrp = contextp->cc_extenthdrp;
 	extenthdr_t tmpehdrp;
-#ifdef EXTENTHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )ehdrp;
-	register u_int32_t *endp = ( u_int32_t * )( ehdrp + 1 );
-	register u_int32_t sum;
-#endif /* EXTENTHDR_CHECKSUM */
 	intgen_t rval;
 	rv_t rv;
 	char typestr[20];
@@ -5198,15 +5164,10 @@ dump_extenthdr( drive_t *drivep,
 
 	( void )memset( ( void * )ehdrp, 0, sizeof( *ehdrp ));
 	ehdrp->eh_type = type;
-	ehdrp->eh_flags = flags;
+	ehdrp->eh_flags = flags | EXTENTHDR_FLAGS_CHECKSUM;
 	ehdrp->eh_offset = offset;
 	ehdrp->eh_sz = sz;
-
-#ifdef EXTENTHDR_CHECKSUM
-	ehdrp->eh_flags |= EXTENTHDR_FLAGS_CHECKSUM;
-	for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-	ehdrp->eh_checksum = ~sum + 1;
-#endif /* EXTENTHDR_CHECKSUM */
+	ehdrp->eh_checksum = calc_checksum( ehdrp, ehdrp + 1 );
 
 	xlate_extenthdr(ehdrp, &tmpehdrp, 1);
 	rval = write_buf( ( char * )&tmpehdrp,
@@ -5249,11 +5210,6 @@ dump_dirent( drive_t *drivep,
 	direnthdr_t *tmpdhdrp;
 	size_t direntbufsz = contextp->cc_mdirentbufsz;
 	size_t sz;
-#ifdef DIRENTHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )dhdrp;
-	register u_int32_t *endp = ( u_int32_t * )( dhdrp + 1 );
-	register u_int32_t sum;
-#endif /* DIRENTHDR_CHECKSUM */
 	intgen_t rval;
 	rv_t rv;
 
@@ -5290,10 +5246,7 @@ dump_dirent( drive_t *drivep,
 		strcpy( dhdrp->dh_name, name );
 	}
 
-#ifdef DIRENTHDR_CHECKSUM
-	for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-	dhdrp->dh_checksum = ~sum + 1;
-#endif /* DIRENTHDR_CHECKSUM */
+	dhdrp->dh_checksum = calc_checksum( dhdrp, dhdrp + 1);
 
 	tmpdhdrp = malloc(sz);
 	xlate_direnthdr(dhdrp, tmpdhdrp, 1);
diff --git a/restore/Makefile b/restore/Makefile
index 78ecc2c..588a8f0 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -103,7 +103,7 @@ LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX -DPIPEINVFIX \
-	-DEOMFIX -DSESSCPLT -DWHITEPARSE -DDIRENTHDR_CHECKSUM \
+	-DEOMFIX -DSESSCPLT -DWHITEPARSE \
 	-DF_FSSETDM
 
 default: depend $(LTCOMMAND)
diff --git a/restore/content.c b/restore/content.c
index e3e4994..25849d7 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8000,11 +8000,6 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
-#ifdef FILEHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )fhdrp;
-	register u_int32_t *endp = ( u_int32_t * )( fhdrp + 1 );
-	register u_int32_t sum;
-#endif /* FILEHDR_CHECKSUM */
 	intgen_t rval;
 	filehdr_t tmpfh;
 
@@ -8041,21 +8036,18 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
 	      bstatp->bs_ino,
 	      bstatp->bs_mode );
 
-#ifdef FILEHDR_CHECKSUM
 	if ( fhcs ) {
 		if ( ! ( fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "corrupt file header\n") );
 			return RV_CORRUPT;
 		}
-		for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-		if ( sum ) {
+		if ( !is_checksum_valid( fhdrp, fhdrp + 1)) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "bad file header checksum\n") );
 			return RV_CORRUPT;
 		}
 	}
-#endif /* FILEHDR_CHECKSUM */
 
 	return RV_OK;
 }
@@ -8067,11 +8059,6 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
-#ifdef EXTENTHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )ehdrp;
-	register u_int32_t *endp = ( u_int32_t * )( ehdrp + 1 );
-	register u_int32_t sum;
-#endif /* EXTENTHDR_CHECKSUM */
 	intgen_t rval;
 	extenthdr_t tmpeh;
 
@@ -8108,21 +8095,18 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
 	      ehdrp->eh_type,
 	      ehdrp->eh_flags );
 
-#ifdef EXTENTHDR_CHECKSUM
 	if ( ehcs ) {
 		if ( ! ( ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "corrupt extent header\n") );
 			return RV_CORRUPT;
 		}
-		for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-		if ( sum ) {
+		if ( !is_checksum_valid( ehdrp, ehdrp + 1)) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "bad extent header checksum\n") );
 			return RV_CORRUPT;
 		}
 	}
-#endif /* EXTENTHDR_CHECKSUM */
 
 	return RV_OK;
 }
@@ -8137,11 +8121,6 @@ read_dirent( drive_t *drivep,
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
-#ifdef DIRENTHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )dhdrp;
-	register u_int32_t *endp = ( u_int32_t * )( dhdrp + 1 );
-	register u_int32_t sum;
-#endif /* DIRENTHDR_CHECKSUM */
 	intgen_t rval;
 	direnthdr_t tmpdh;
 
@@ -8180,21 +8159,18 @@ read_dirent( drive_t *drivep,
 	      ( size_t )dhdrp->dh_gen,
 	      ( size_t )dhdrp->dh_sz );
 
-#ifdef DIRENTHDR_CHECKSUM
 	if ( dhcs ) {
 		if ( dhdrp->dh_sz == 0 ) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "corrupt directory entry header\n") );
 			return RV_CORRUPT;
 		}
-		for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-		if ( sum ) {
+		if ( !is_checksum_valid( dhdrp, dhdrp + 1)) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "bad directory entry header checksum\n") );
 			return RV_CORRUPT;
 		}
 	}
-#endif /* DIRENTHDR_CHECKSUM */
 
 	/* if null, return
 	 */
@@ -8246,11 +8222,6 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	drive_ops_t *dop = drivep->d_opsp;
 	/* REFERENCED */
 	intgen_t nread;
-#ifdef EXTATTRHDR_CHECKSUM
-	register u_int32_t *sump = ( u_int32_t * )ahdrp;
-	register u_int32_t *endp = ( u_int32_t * )( ahdrp + 1 );
-	register u_int32_t sum;
-#endif /* EXTATTRHDR_CHECKSUM */
 	intgen_t rval;
 	extattrhdr_t tmpah;
 
@@ -8288,21 +8259,18 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
 	      ahdrp->ah_valsz,
 	      ahdrp->ah_checksum );
 
-#ifdef EXTATTRHDR_CHECKSUM
 	if ( ahcs ) {
 		if ( ! ( ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM )) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "corrupt extattr header\n") );
 			return RV_CORRUPT;
 		}
-		for ( sum = 0 ; sump < endp ; sum += *sump++ ) ;
-		if ( sum ) {
+		if ( !is_checksum_valid( ahdrp, ahdrp + 1)) {
 			mlog( MLOG_NORMAL | MLOG_WARNING, _(
 			      "bad extattr header checksum\n") );
 			return RV_CORRUPT;
 		}
 	}
-#endif /* EXTATTRHDR_CHECKSUM */
 
 	return RV_OK;
 }
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
