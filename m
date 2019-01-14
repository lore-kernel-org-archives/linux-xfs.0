Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726751AbfANR0H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:07 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6B57C05E75A
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:05 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 06/13] xfsdump: (6/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:21 +0100
Message-Id: <20190114172528.65250-7-jtulak@redhat.com>
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
 dump/content.c | 2032 ++++++++++++++++++++++++------------------------
 1 file changed, 1016 insertions(+), 1016 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index ecc867d..4e4566a 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -109,7 +109,7 @@ struct mark {
 
 typedef struct mark mark_t;
 
-/* Media_mfile_begin( ) entry state.
+/* Media_mfile_begin() entry state.
  */
 enum bes { BES_INIT,	/* in the beginning */
 	   BES_ENDOK,   /* last media file successfully flushed to media */
@@ -197,7 +197,7 @@ typedef struct context context_t;
 #define BMAP_LEN	512
 
 struct extent_group_context {
-	getbmapx_t eg_bmap[ BMAP_LEN ];
+	getbmapx_t eg_bmap[BMAP_LEN];
 	getbmapx_t *eg_nextbmapp;	/* ptr to the next extent to dump */
 	getbmapx_t *eg_endbmapp;		/* to detect extent exhaustion */
 	int eg_fd;			/* file desc. */
@@ -208,27 +208,27 @@ struct extent_group_context {
 typedef struct extent_group_context extent_group_context_t;
 
 
-/* minimum getdents( ) buffer size
+/* minimum getdents() buffer size
  */
-#define GETDENTSBUF_SZ_MIN	( 2 * pgsz )
+#define GETDENTSBUF_SZ_MIN	(2 * pgsz)
 
 
 /* minimum sizes for extended attributes buffers
  */
-#define EXTATTR_LISTBUF_SZ	( XATTR_LIST_MAX )
-#define EXTATTR_RTRVARRAY_LEN	( 1 * pgsz )
-#define EXTATTR_DUMPBUF_SZ	( 4 * pgsz )
+#define EXTATTR_LISTBUF_SZ	(XATTR_LIST_MAX)
+#define EXTATTR_RTRVARRAY_LEN	(1 * pgsz)
+#define EXTATTR_DUMPBUF_SZ	(4 * pgsz)
 
 /* for printing ext attr namespace
  */
-#define EXTATTR_NAMESPACE(flag)	( ((flag) & ATTR_ROOT) ? _("root") : \
-				( ((flag) & ATTR_SECURE) ? _("secure") : \
-				  _("non-root") ) )
+#define EXTATTR_NAMESPACE(flag)	(((flag) & ATTR_ROOT) ? _("root") : \
+				(((flag) & ATTR_SECURE) ? _("secure") : \
+				  _("non-root")))
 
 /* for printing file type
  */
-#define FILETYPE(statp)		( ( (statp)->bs_mode & S_IFMT ) == S_IFDIR \
-				  ? _("dir") : _("nondir") )
+#define FILETYPE(statp)		(((statp)->bs_mode & S_IFMT) == S_IFDIR \
+				  ? _("dir") : _("nondir"))
 
 /* per-drive status descriptor
  */
@@ -248,8 +248,8 @@ typedef struct pds pds_t;
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
-extern bool_t preemptchk( int );
+extern void usage(void);
+extern bool_t preemptchk(int);
 extern char *homedir;
 extern bool_t pipeline;
 extern bool_t stdoutpiped;
@@ -261,51 +261,51 @@ extern size_t pgsz;
 
 /* file dumpers
  */
-static rv_t dump_dirs( ix_t strmix,
+static rv_t dump_dirs(ix_t strmix,
 		       xfs_bstat_t *bstatbufp,
 		       size_t bstatbuflen,
-		       void *inomap_contextp );
-static rv_t dump_dir( ix_t strmix,
+		       void *inomap_contextp);
+static rv_t dump_dir(ix_t strmix,
 		      jdm_fshandle_t *,
 		      int,
-		      xfs_bstat_t * );
-static rv_t dump_file( void *,
+		      xfs_bstat_t *);
+static rv_t dump_file(void *,
 		       jdm_fshandle_t *,
 		       int,
-		       xfs_bstat_t * );
-static rv_t dump_file_reg( drive_t *drivep,
+		       xfs_bstat_t *);
+static rv_t dump_file_reg(drive_t *drivep,
 			   context_t *contextp,
 			   content_inode_hdr_t *scwhdrp,
 			   jdm_fshandle_t *,
 			   xfs_bstat_t *,
 			   bool_t *);
-static rv_t dump_file_spec( drive_t *drivep,
+static rv_t dump_file_spec(drive_t *drivep,
 			    context_t *contextp,
 			    jdm_fshandle_t *,
-			    xfs_bstat_t * );
-static rv_t dump_filehdr( drive_t *drivep,
+			    xfs_bstat_t *);
+static rv_t dump_filehdr(drive_t *drivep,
 			  context_t *contextp,
 			  xfs_bstat_t *,
 			  off64_t,
-			  int );
-static rv_t dump_extenthdr( drive_t *drivep,
+			  int);
+static rv_t dump_extenthdr(drive_t *drivep,
 			    context_t *contextp,
 			    int32_t,
 			    int32_t,
 			    off64_t,
-			    off64_t );
-static rv_t dump_dirent( drive_t *drivep,
+			    off64_t);
+static rv_t dump_dirent(drive_t *drivep,
 			 context_t *contextp,
 			 xfs_bstat_t *,
 			 xfs_ino_t,
 			 gen_t,
 			 char *,
-			 size_t );
-static rv_t init_extent_group_context( jdm_fshandle_t *,
+			 size_t);
+static rv_t init_extent_group_context(jdm_fshandle_t *,
 				       xfs_bstat_t *,
-				       extent_group_context_t * );
-static void cleanup_extent_group_context( extent_group_context_t * );
-static rv_t dump_extent_group( drive_t *drivep,
+				       extent_group_context_t *);
+static void cleanup_extent_group_context(extent_group_context_t *);
+static rv_t dump_extent_group(drive_t *drivep,
 			       context_t *contextp,
 			       xfs_bstat_t *,
 			       extent_group_context_t *,
@@ -314,70 +314,70 @@ static rv_t dump_extent_group( drive_t *drivep,
 			       bool_t,
 			       off64_t *,
 			       off64_t *,
-			       bool_t * );
-static bool_t dump_session_inv( drive_t *drivep,
+			       bool_t *);
+static bool_t dump_session_inv(drive_t *drivep,
 			        context_t *contextp,
 			        media_hdr_t *mwhdrp,
-			        content_inode_hdr_t *scwhdrp );
-static rv_t write_pad( drive_t *drivep, size_t );
+			        content_inode_hdr_t *scwhdrp);
+static rv_t write_pad(drive_t *drivep, size_t);
 
-static void mark_callback( void *, drive_markrec_t *, bool_t );
+static void mark_callback(void *, drive_markrec_t *, bool_t);
 
-static void inv_cleanup( void );
-static void dump_terminator( drive_t *drivep,
+static void inv_cleanup(void);
+static void dump_terminator(drive_t *drivep,
 			     context_t *contextp,
-			     media_hdr_t *mwhdrp );
-static rv_t Media_mfile_begin( drive_t *drivep,
+			     media_hdr_t *mwhdrp);
+static rv_t Media_mfile_begin(drive_t *drivep,
 			       context_t *contextp,
-			       bool_t intr_allowed );
-static rv_t Media_mfile_end( drive_t *drivep,
+			       bool_t intr_allowed);
+static rv_t Media_mfile_end(drive_t *drivep,
 			     context_t *contextp,
 			     media_hdr_t *mwhdrp,
 			     off64_t *ncommittedp,
-			     bool_t hit_eom );
-static bool_t Media_prompt_overwrite( drive_t *drivep );
-static rv_t Media_erasechk( drive_t *drivep,
+			     bool_t hit_eom);
+static bool_t Media_prompt_overwrite(drive_t *drivep);
+static rv_t Media_erasechk(drive_t *drivep,
 			    int dcaps,
 			    bool_t intr_allowed,
-			    bool_t prevmediapresentpr );
-static bool_t Media_prompt_erase( drive_t *drivep );
-static char *Media_prompt_label( drive_t *drivep, char *bufp, size_t bufsz );
-static void update_cc_Media_useterminatorpr( drive_t *drivep,
-					     context_t *contextp );
-static void set_mcflag( ix_t thrdix );
-static void clr_mcflag( ix_t thrdix );
+			    bool_t prevmediapresentpr);
+static bool_t Media_prompt_erase(drive_t *drivep);
+static char *Media_prompt_label(drive_t *drivep, char *bufp, size_t bufsz);
+static void update_cc_Media_useterminatorpr(drive_t *drivep,
+					     context_t *contextp);
+static void set_mcflag(ix_t thrdix);
+static void clr_mcflag(ix_t thrdix);
 
-static bool_t check_complete_flags( void );
+static bool_t check_complete_flags(void);
 
-static rv_t dump_extattrs( drive_t *drivep,
+static rv_t dump_extattrs(drive_t *drivep,
 			   context_t *contextp,
 	       		   jdm_fshandle_t *fshandlep,
 			   xfs_bstat_t *statp);
-static rv_t dump_extattr_list( drive_t *drivep,
+static rv_t dump_extattr_list(drive_t *drivep,
 			       context_t *contextp,
 	       		       jdm_fshandle_t *fshandlep,
 			       xfs_bstat_t *statp,
 			       attrlist_t *listp,
 			       int flag,
-			       bool_t *abortprp );
-static char *dump_extattr_buildrecord( xfs_bstat_t *statp,
+			       bool_t *abortprp);
+static char *dump_extattr_buildrecord(xfs_bstat_t *statp,
 				       char *dumpbufp,
 				       char *dumpbufendp,
 				       char *namesrcp,
 				       uint32_t valuesz,
 				       int flag,
-				       char **valuepp );
-static rv_t dump_extattrhdr( drive_t *drivep,
+				       char **valuepp);
+static rv_t dump_extattrhdr(drive_t *drivep,
 			     context_t *contextp,
 			     xfs_bstat_t *statp,
 			     size_t recsz,
 			     size_t valoff,
 			     ix_t flags,
-			     uint32_t valsz );
+			     uint32_t valsz);
 
-static bool_t save_quotas( char *mntpnt,
-			   quota_info_t *quotainfo );
-static int getxfsqstat( char *fsdev );
+static bool_t save_quotas(char *mntpnt,
+			   quota_info_t *quotainfo);
+static int getxfsqstat(char *fsdev);
 
 
 
@@ -448,7 +448,7 @@ static size64_t sc_stat_inomapdone;
 static size64_t sc_stat_dircnt = 0;
 	/* total number of directory inodes to be dumped (strm 0)
 	 */
-static pds_t sc_stat_pds[ STREAM_SIMMAX ];
+static pds_t sc_stat_pds[STREAM_SIMMAX];
 	/* per-drive stream status
 	 */
 static size64_t sc_stat_nondircnt = 0;
@@ -470,13 +470,13 @@ static size_t sc_thrdsarrivedcnt = 0;
 	 */
 static size_t sc_thrdsdonecnt = 0;
 	/* number of threads which are ready to dump the session inventory.
-	 * when equal to the number of streams remaining (stream_cnt( )),
+	 * when equal to the number of streams remaining (stream_cnt()),
 	 * can proceed with inventory dumps
 	 */
 static context_t *sc_contextp;
 	/* an array of per-stream context descriptors
 	 */
-static bool_t sc_mcflag[ STREAM_SIMMAX ];
+static bool_t sc_mcflag[STREAM_SIMMAX];
 	/* media change flag
 	 */
 static bool_t sc_dumpextattrpr = BOOL_TRUE;
@@ -512,9 +512,9 @@ static bool_t create_inv_session(
 		size_t strmix);
 
 bool_t
-content_init( int argc,
-	      char *argv[ ],
-	      global_hdr_t *gwhdrtemplatep )
+content_init(int argc,
+	      char *argv[],
+	      global_hdr_t *gwhdrtemplatep)
 {
 
 	inv_idbtoken_t inv_idbt;
@@ -528,13 +528,13 @@ content_init( int argc,
 	ix_t subtreeix;
 	bool_t resumereqpr = BOOL_FALSE;
 	char *srcname;
-	char mntpnt[ GLOBAL_HDR_STRING_SZ ];
-	char fsdevice[ GLOBAL_HDR_STRING_SZ ];
-	char fstype[ CONTENT_HDR_FSTYPE_SZ ];
+	char mntpnt[GLOBAL_HDR_STRING_SZ];
+	char fsdevice[GLOBAL_HDR_STRING_SZ];
+	char fstype[CONTENT_HDR_FSTYPE_SZ];
 	bool_t skip_unchanged_dirs = BOOL_FALSE;
 	uuid_t fsid;
 	bool_t underfoundpr;
-	ix_t underlevel = ( ix_t )( -1 );
+	ix_t underlevel = (ix_t)(-1);
 	time32_t undertime = 0;
 	uuid_t underid;
 	bool_t underpartialpr = BOOL_FALSE;
@@ -566,27 +566,27 @@ content_init( int argc,
 
 	/* basic sanity checks
 	 */
-	assert( sizeof( mode_t ) == MODE_SZ );
-	assert( sizeof( timestruct_t ) == TIMESTRUCT_SZ );
-	assert( sizeof( bstat_t ) == BSTAT_SZ );
-	assert( sizeof( filehdr_t ) == FILEHDR_SZ );
-	assert( sizeof( extenthdr_t ) == EXTENTHDR_SZ );
-	assert( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
-	assert( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
-	assert( DIRENTHDR_SZ % DIRENTHDR_ALIGN == 0 );
-	assert( sizeofmember( content_hdr_t, ch_specific )
+	assert(sizeof(mode_t) == MODE_SZ);
+	assert(sizeof(timestruct_t) == TIMESTRUCT_SZ);
+	assert(sizeof(bstat_t) == BSTAT_SZ);
+	assert(sizeof(filehdr_t) == FILEHDR_SZ);
+	assert(sizeof(extenthdr_t) == EXTENTHDR_SZ);
+	assert(sizeof(direnthdr_t) == DIRENTHDR_SZ);
+	assert(sizeof(direnthdr_v1_t) == DIRENTHDR_SZ);
+	assert(DIRENTHDR_SZ % DIRENTHDR_ALIGN == 0);
+	assert(sizeofmember(content_hdr_t, ch_specific)
 		>=
-		sizeof( content_inode_hdr_t ));
-	assert( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
+		sizeof(content_inode_hdr_t));
+	assert(sizeof(extattrhdr_t) == EXTATTRHDR_SZ);
 
 	/* calculate offsets of portions of the write hdr template
 	 */
-	dwhdrtemplatep = ( drive_hdr_t * )gwhdrtemplatep->gh_upper;
-	mwhdrtemplatep = ( media_hdr_t * )dwhdrtemplatep->dh_upper;
-	cwhdrtemplatep = ( content_hdr_t * )mwhdrtemplatep->mh_upper;
-	scwhdrtemplatep = ( content_inode_hdr_t * ) cwhdrtemplatep->ch_specific;
+	dwhdrtemplatep = (drive_hdr_t *)gwhdrtemplatep->gh_upper;
+	mwhdrtemplatep = (media_hdr_t *)dwhdrtemplatep->dh_upper;
+	cwhdrtemplatep = (content_hdr_t *)mwhdrtemplatep->mh_upper;
+	scwhdrtemplatep = (content_inode_hdr_t *) cwhdrtemplatep->ch_specific;
 
-	if ( gwhdrtemplatep->gh_version < GLOBAL_HDR_VERSION_3 ) {
+	if (gwhdrtemplatep->gh_version < GLOBAL_HDR_VERSION_3) {
 		sc_use_old_direntpr = BOOL_TRUE;
 	}
 
@@ -596,61 +596,61 @@ content_init( int argc,
 	opterr = 0;
 	subtreecnt = 0;
 	baseuuidvalpr = BOOL_FALSE;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_LEVEL:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
-			sc_level = ( ix_t )atoi( optarg );
-			if ( sc_level > LEVEL_MAX ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			sc_level = (ix_t)atoi(optarg);
+			if (sc_level > LEVEL_MAX) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument must be "
 				      "between 0 and %d\n"),
 				      c,
-				      LEVEL_MAX );
-				usage( );
+				      LEVEL_MAX);
+				usage();
 				return BOOL_FALSE;
 			}
 			break;
 		case GETOPT_SUBTREE:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
-			if ( optarg[ 0 ] == '/' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (optarg[0] == '/') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument (subtree) "
 				      "must be a relative pathname\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			subtreecnt++;
 			break;
 		case GETOPT_MAXDUMPFILESIZE:
-			if ( ! optarg || optarg [ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg [0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			maxdumpfilesize = strtoull(optarg, NULL, 0);
-			if ( maxdumpfilesize == 0 ||
+			if (maxdumpfilesize == 0 ||
 			     maxdumpfilesize > ULONGLONG_MAX / 1024 ||
-			     ( maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE ) ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			     (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE)) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument is not a valid file size\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			maxdumpfilesize *= 1024;
@@ -671,11 +671,11 @@ content_init( int argc,
 			sc_preerasepr = BOOL_TRUE;
 			break;
 		case GETOPT_ALERTPROG:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					"-%c argument missing\n"),
-				    c );
-				usage( );
+				    c);
+				usage();
 				return BOOL_FALSE;
 			}
 			media_change_alert_program = optarg;
@@ -687,32 +687,32 @@ content_init( int argc,
 			sc_dumpasoffline = BOOL_TRUE;
 			break;
 		case GETOPT_BASED:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			baseuuidstr = optarg;
 
-			if ( uuid_parse( baseuuidstr, baseuuid ) < 0 ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (uuid_parse(baseuuidstr, baseuuid) < 0) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument not a valid "
 				      "dump session id\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			baseuuidvalpr = BOOL_TRUE;
 		}
 	}
 
-	if ( resumereqpr && baseuuidvalpr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (resumereqpr && baseuuidvalpr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "may not specify both -%c and -%c\n"),
 		      GETOPT_BASED,
-		      GETOPT_RESUME );
+		      GETOPT_RESUME);
 		return BOOL_FALSE;
 	}
 
@@ -720,44 +720,44 @@ content_init( int argc,
 	 * dash ('-') with no option letter. This must appear between
 	 * all lettered arguments and the source file system pathname.
 	 */
-	if ( optind < argc && ! strcmp( argv[ optind ], "-" )) {
+	if (optind < argc && ! strcmp(argv[optind ], "-")) {
 		optind++;
 	}
 
 	/* the last argument must be either the mount point or a
 	 * device pathname of the file system to be dumped.
 	 */
-	if ( optind >= argc ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (optind >= argc) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "source file system "
-		      "not specified\n") );
-		usage( );
+		      "not specified\n"));
+		usage();
 		return BOOL_FALSE;
 	}
-	srcname = argv[ optind ];
+	srcname = argv[optind];
 
-	if ( preemptchk( PREEMPT_FULL )) {
+	if (preemptchk(PREEMPT_FULL)) {
 		return BOOL_FALSE;
 	}
 
 	/* allocate space for the subtree pointer array and load it
 	 */
-	if ( subtreecnt ) {
-		subtreep = ( char ** )calloc( subtreecnt, sizeof( char * ));
-		assert( subtreep );
+	if (subtreecnt) {
+		subtreep = (char **)calloc(subtreecnt, sizeof(char *));
+		assert(subtreep);
 		optind = 1;
 		opterr = 0;
 		subtreeix = 0;
-		while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-			switch ( c ) {
+		while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+			switch (c) {
 			case GETOPT_SUBTREE:
-				assert( subtreeix < subtreecnt );
-				assert( optarg && optarg[ 0 ] != '-' );
-				subtreep[ subtreeix++ ] = optarg;
+				assert(subtreeix < subtreecnt);
+				assert(optarg && optarg[0] != '-');
+				subtreep[subtreeix++] = optarg;
 				break;
 			}
 		}
-		assert( subtreeix == subtreecnt );
+		assert(subtreeix == subtreecnt);
 	} else {
 		subtreep = 0;
 	}
@@ -769,20 +769,20 @@ content_init( int argc,
 	 * system ID (uuid). returns BOOL_FALSE if the last
 	 * argument doesn't look like a file system.
 	 */
-	if ( ! fs_info( fstype,
-			sizeof( fstype ),
+	if (! fs_info(fstype,
+			sizeof(fstype),
 			FS_DEFAULT,
 			fsdevice,
-			sizeof( fsdevice ),
+			sizeof(fsdevice),
 			mntpnt,
-			sizeof( mntpnt ),
+			sizeof(mntpnt),
 			&fsid,
-			srcname )) {
+			srcname)) {
 
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "%s does not identify a file system\n"),
-		      srcname );
-		usage( );
+		      srcname);
+		usage();
 		return BOOL_FALSE;
 	}
 
@@ -790,49 +790,49 @@ content_init( int argc,
 	 * to mount an unmounted file system on a temporary mount point,
 	 * if it is not currently mounted.
 	 */
-	if ( ! fs_mounted( fstype, fsdevice, mntpnt, &fsid )) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (! fs_mounted(fstype, fsdevice, mntpnt, &fsid)) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "%s must be mounted to be dumped\n"),
-		      srcname );
+		      srcname);
 		return BOOL_FALSE;
 	}
 
 	/* place the fs info in the write hdr template
 	 */
-	( void )strncpyterm( cwhdrtemplatep->ch_mntpnt,
+	(void)strncpyterm(cwhdrtemplatep->ch_mntpnt,
 			     mntpnt,
-			     sizeof( cwhdrtemplatep->ch_mntpnt ));
-	( void )strncpyterm( cwhdrtemplatep->ch_fsdevice,
+			     sizeof(cwhdrtemplatep->ch_mntpnt));
+	(void)strncpyterm(cwhdrtemplatep->ch_fsdevice,
 			     fsdevice,
-			     sizeof( cwhdrtemplatep->ch_fsdevice ));
-	( void )strncpyterm( cwhdrtemplatep->ch_fstype,
+			     sizeof(cwhdrtemplatep->ch_fsdevice));
+	(void)strncpyterm(cwhdrtemplatep->ch_fstype,
 			     fstype,
-			     sizeof( cwhdrtemplatep->ch_fstype ));
-	uuid_copy( cwhdrtemplatep->ch_fsid, fsid );
+			     sizeof(cwhdrtemplatep->ch_fstype));
+	uuid_copy(cwhdrtemplatep->ch_fsid, fsid);
 
 	/* write quota information */
-	if( sc_savequotas ) {
+	if(sc_savequotas) {
 
 		sc_savequotas = BOOL_FALSE;
 		for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
 			quotas[i].savequotas = BOOL_FALSE;
-			qstat = getxfsqstat( fsdevice );
-			if (qstat > 0 && (qstat & quotas[i].statflag) ) {
-				sprintf( quotas[i].quotapath, "%s/%s", mntpnt, quotas[i].quotafile );
-				if( save_quotas( mntpnt, &quotas[i] )) {
-					if( subtreecnt ) {
+			qstat = getxfsqstat(fsdevice);
+			if (qstat > 0 && (qstat & quotas[i].statflag)) {
+				sprintf(quotas[i].quotapath, "%s/%s", mntpnt, quotas[i].quotafile);
+				if(save_quotas(mntpnt, &quotas[i])) {
+					if(subtreecnt) {
 						subtreecnt++;
-						subtreep = (char **) realloc( subtreep,
+						subtreep = (char **) realloc(subtreep,
 								subtreecnt * sizeof(char *));
-						assert( subtreep );
-						subtreep[ subtreecnt - 1 ] = quotas[i].quotafile;
+						assert(subtreep);
+						subtreep[subtreecnt - 1] = quotas[i].quotafile;
 					}
 					sc_savequotas = BOOL_TRUE;
 					quotas[i].savequotas = BOOL_TRUE;
 				} else {
-					mlog( MLOG_NORMAL | MLOG_ERROR, _(
+					mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					      "failed to save %s information, continuing\n"),
-					      quotas[i].desc );
+					      quotas[i].desc);
 				}
 			}
 		}
@@ -841,7 +841,7 @@ content_init( int argc,
 
 	/* create my /var directory if it doesn't already exist.
 	 */
-	var_create( );
+	var_create();
 
 	/* get two session descriptors from the inventory: one for the last
 	 * dump at this level, and one for the last dump at a lower level.
@@ -851,23 +851,23 @@ content_init( int argc,
 	 * will give us a change date for all other inos.
 	 */
 
-	if ( preemptchk( PREEMPT_FULL )) {
+	if (preemptchk(PREEMPT_FULL)) {
 		return BOOL_FALSE;
 	}
 
 	/* briefly open the online dump inventory, so it can be used
 	 * to calculate incremental and resumed dumps.
 	 */
-	inv_idbt = inv_open( ( inv_predicate_t )INV_BY_UUID,
+	inv_idbt = inv_open((inv_predicate_t)INV_BY_UUID,
 			     INV_SEARCH_ONLY,
-			     ( void * )&fsid );
+			     (void *)&fsid);
 
 	/* if a based request, look for the indicated session.
 	 * if found, and not interrupted, this will be used as an
 	 * incremental base. if interrupted, will be used as
 	 * resume base.
 	 */
-	if ( baseuuidvalpr ) {
+	if (baseuuidvalpr) {
 		ix_t strix;
 		ix_t strcnt;
 		inv_stream_t *bsp;
@@ -880,53 +880,53 @@ content_init( int argc,
 		interruptedpr = BOOL_FALSE;
 
 		ok = inv_get_session_byuuid(&fsid, &baseuuid, &sessp);
-		if ( ! ok ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (! ok) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not find specified base dump (%s) "
 			      "in inventory\n"),
-			      baseuuidstr );
+			      baseuuidstr);
 			return BOOL_FALSE;
 		}
-		strcnt =  ( ix_t )sessp->s_nstreams;
-		for ( strix = 0 ; strix < strcnt ; strix++ ) {
-			bsp = &sessp->s_streams[ strix ];
-			if ( bsp->st_interrupted ) {
+		strcnt =  (ix_t)sessp->s_nstreams;
+		for (strix = 0 ; strix < strcnt ; strix++) {
+			bsp = &sessp->s_streams[strix];
+			if (bsp->st_interrupted) {
 				interruptedpr = BOOL_TRUE;
 				break;
 			}
 		}
 
-		if ( interruptedpr ) {
-			sc_level = ( ix_t )sessp->s_level;
+		if (interruptedpr) {
+			sc_level = (ix_t)sessp->s_level;
 			resumereqpr = BOOL_TRUE;
 			samefoundpr = BOOL_TRUE;
 			sametime = sessp->s_time;
 			uuid_copy (sameid, sessp->s_sesid);
 			samepartialpr = sessp->s_ispartial;
 			sameinterruptedpr = BOOL_TRUE;
-			sc_resumerangecnt =  ( size_t )sessp->s_nstreams;
-			sc_resumerangep = ( drange_t * )calloc( sc_resumerangecnt,
-								sizeof( drange_t ));
-			assert( sc_resumerangep );
-			for ( strmix = 0 ; strmix < sc_resumerangecnt ; strmix++ ) {
+			sc_resumerangecnt =  (size_t)sessp->s_nstreams;
+			sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
+								sizeof(drange_t));
+			assert(sc_resumerangep);
+			for (strmix = 0 ; strmix < sc_resumerangecnt ; strmix++) {
 				inv_stream_t *bsp;
 				inv_stream_t *esp;
-				drange_t *p = &sc_resumerangep[ strmix ];
-				bsp = &sessp->s_streams[ strmix ];
-				esp = ( strmix < sc_resumerangecnt - 1 )
+				drange_t *p = &sc_resumerangep[strmix];
+				bsp = &sessp->s_streams[strmix];
+				esp = (strmix < sc_resumerangecnt - 1)
 				      ?
 				      bsp + 1
 				      :
 				      0;
-				if ( bsp->st_interrupted ) {
+				if (bsp->st_interrupted) {
 					sameinterruptedpr = BOOL_TRUE;
 					p->dr_begin.sp_ino = bsp->st_endino;
 					p->dr_begin.sp_offset = bsp->st_endino_off;
-					if ( esp ) {
+					if (esp) {
 						p->dr_end.sp_ino = esp->st_startino;
 						p->dr_end.sp_offset =
 								esp->st_startino_off;
-						mlog( MLOG_DEBUG,
+						mlog(MLOG_DEBUG,
 						      "resume range stream %u "
 						      "ino %llu:%lld to "
 						      "%llu:%lld\n",
@@ -934,16 +934,16 @@ content_init( int argc,
 						      p->dr_begin.sp_ino,
 						      p->dr_begin.sp_offset,
 						      p->dr_end.sp_ino,
-						      p->dr_end.sp_offset );
+						      p->dr_end.sp_offset);
 					} else {
 						p->dr_end.sp_flags = STARTPT_FLAGS_END;
-						mlog( MLOG_DEBUG,
+						mlog(MLOG_DEBUG,
 						      "resume range stream %u "
 						      "ino %llu:%lld to "
 						      "end\n",
 						      strmix,
 						      p->dr_begin.sp_ino,
-						      p->dr_begin.sp_offset );
+						      p->dr_begin.sp_offset);
 					}
 				} else {
 					/* set the range start pt's END flag to
@@ -953,27 +953,27 @@ content_init( int argc,
 				}
 			}
 		} else {
-			if ( sessp->s_level >= LEVEL_MAX ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (sessp->s_level >= LEVEL_MAX) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "cannot select dump session %d as base "
 				      "for incremental dump: "
 				      "level must be less than %d\n"),
 				      sessp->s_level,
-				      LEVEL_MAX );
+				      LEVEL_MAX);
 				return BOOL_FALSE;
 			}
-			sc_level = ( ix_t )sessp->s_level + 1;
+			sc_level = (ix_t)sessp->s_level + 1;
 			undertime = sessp->s_time;
-			underlevel = ( ix_t )sessp->s_level;
+			underlevel = (ix_t)sessp->s_level;
 			uuid_copy (underid, sessp->s_sesid);
 			underpartialpr = sessp->s_ispartial;
 			underinterruptedpr = BOOL_FALSE;
 			underfoundpr = BOOL_TRUE;
 		}
-		inv_free_session( &sessp );
+		inv_free_session(&sessp);
 		sessp = 0;
-		ok = inv_close( inv_idbt );
-		assert( ok );
+		ok = inv_close(inv_idbt);
+		assert(ok);
 		inv_idbt = INV_TOKEN_NULL;
 		goto baseuuidbypass;
 	}
@@ -983,41 +983,41 @@ content_init( int argc,
 	 * and interrupted.
 	 */
 	underfoundpr = BOOL_FALSE;
-	if ( sc_level > 0 ) {
-		if ( inv_idbt == INV_TOKEN_NULL ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (sc_level > 0) {
+		if (inv_idbt == INV_TOKEN_NULL) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "cannot calculate incremental dump: "
-			      "online inventory not available\n") );
+			      "online inventory not available\n"));
 			return BOOL_FALSE;
 		}
 		ok = inv_lastsession_level_lessthan(&fsid,
 						    inv_idbt,
 						    (u_char_t)sc_level,
 						    &sessp);
-		if ( ! ok ) {
+		if (! ok) {
 			sessp = 0;
 		}
 
-		if ( sessp ) {
+		if (sessp) {
 			ix_t strix;
 			ix_t strcnt;
 			inv_stream_t *bsp;
 
 			undertime = sessp->s_time;
-			underlevel = ( ix_t )sessp->s_level;
+			underlevel = (ix_t)sessp->s_level;
 			uuid_copy (underid, sessp->s_sesid);
 			underpartialpr = sessp->s_ispartial;
 			underinterruptedpr = BOOL_FALSE;
-			strcnt =  ( ix_t )sessp->s_nstreams;
-			for ( strix = 0 ; strix < strcnt ; strix++ ) {
-				bsp = &sessp->s_streams[ strix ];
-				if ( bsp->st_interrupted ) {
+			strcnt =  (ix_t)sessp->s_nstreams;
+			for (strix = 0 ; strix < strcnt ; strix++) {
+				bsp = &sessp->s_streams[strix];
+				if (bsp->st_interrupted) {
 					underinterruptedpr = BOOL_TRUE;
 					break;
 				}
 			}
 			underfoundpr = BOOL_TRUE;
-			inv_free_session( & sessp );
+			inv_free_session(& sessp);
 			sessp = 0;
 		}
 	}
@@ -1027,16 +1027,16 @@ content_init( int argc,
 	 * and interrupted, and for each stream the range of ino/offset
 	 * values not dumped.
 	 */
-	if ( inv_idbt != INV_TOKEN_NULL ) {
+	if (inv_idbt != INV_TOKEN_NULL) {
 		/* REFERENCED */
 		bool_t ok1;
 		ok = inv_lastsession_level_equalto(&fsid,
 						   inv_idbt,
 						   (u_char_t)sc_level,
 						   &sessp);
-		ok1 = inv_close( inv_idbt );
-		assert( ok1 );
-		if ( ! ok ) {
+		ok1 = inv_close(inv_idbt);
+		assert(ok1);
+		if (! ok) {
 			sessp = 0;
 		}
 		inv_idbt = INV_TOKEN_NULL;
@@ -1045,34 +1045,34 @@ content_init( int argc,
 	}
 
 	samefoundpr = BOOL_FALSE;
-	if ( sessp ) {
+	if (sessp) {
 		sametime = sessp->s_time;
 		uuid_copy(sameid, sessp->s_sesid);
 		samepartialpr = sessp->s_ispartial;
 		sameinterruptedpr = BOOL_FALSE;
-		sc_resumerangecnt =  ( size_t )sessp->s_nstreams;
-		sc_resumerangep = ( drange_t * )calloc( sc_resumerangecnt,
-						        sizeof( drange_t ));
-		assert( sc_resumerangep );
-		for ( strmix = 0 ; strmix < sc_resumerangecnt ; strmix++ ) {
+		sc_resumerangecnt =  (size_t)sessp->s_nstreams;
+		sc_resumerangep = (drange_t *)calloc(sc_resumerangecnt,
+						        sizeof(drange_t));
+		assert(sc_resumerangep);
+		for (strmix = 0 ; strmix < sc_resumerangecnt ; strmix++) {
 			inv_stream_t *bsp;
 			inv_stream_t *esp;
-			drange_t *p = &sc_resumerangep[ strmix ];
-			bsp = &sessp->s_streams[ strmix ];
-			esp = ( strmix < sc_resumerangecnt - 1 )
+			drange_t *p = &sc_resumerangep[strmix];
+			bsp = &sessp->s_streams[strmix];
+			esp = (strmix < sc_resumerangecnt - 1)
 			      ?
 			      bsp + 1
 			      :
 			      0;
-			if ( bsp->st_interrupted ) {
+			if (bsp->st_interrupted) {
 				sameinterruptedpr = BOOL_TRUE;
 				p->dr_begin.sp_ino = bsp->st_endino;
 				p->dr_begin.sp_offset = bsp->st_endino_off;
-				if ( esp ) {
+				if (esp) {
 					p->dr_end.sp_ino = esp->st_startino;
 					p->dr_end.sp_offset =
 							esp->st_startino_off;
-					mlog( MLOG_DEBUG,
+					mlog(MLOG_DEBUG,
 					      "resume range stream %u "
 					      "ino %llu:%lld to "
 					      "%llu:%lld\n",
@@ -1080,16 +1080,16 @@ content_init( int argc,
 					      p->dr_begin.sp_ino,
 					      p->dr_begin.sp_offset,
 					      p->dr_end.sp_ino,
-					      p->dr_end.sp_offset );
+					      p->dr_end.sp_offset);
 				} else {
 					p->dr_end.sp_flags = STARTPT_FLAGS_END;
-					mlog( MLOG_DEBUG,
+					mlog(MLOG_DEBUG,
 					      "resume range stream %u "
 					      "ino %llu:%lld to "
 					      "end\n",
 					      strmix,
 					      p->dr_begin.sp_ino,
-					      p->dr_begin.sp_offset );
+					      p->dr_begin.sp_offset);
 				}
 			} else {
 				/* set the range start pt's END flag to
@@ -1098,7 +1098,7 @@ content_init( int argc,
 				p->dr_begin.sp_flags = STARTPT_FLAGS_END;
 			}
 		}
-		inv_free_session( & sessp );
+		inv_free_session(& sessp);
 		sessp = 0;
 		samefoundpr = BOOL_TRUE;
 	}
@@ -1107,166 +1107,166 @@ baseuuidbypass:
 
 	/* now determine the incremental and resume bases, if any.
 	 */
-	if ( samefoundpr && ! sameinterruptedpr ) {
-		free( ( void * )sc_resumerangep );
+	if (samefoundpr && ! sameinterruptedpr) {
+		free((void *)sc_resumerangep);
 		sc_resumerangep = 0;
 		samefoundpr = BOOL_FALSE;
 	}
-	if ( samefoundpr && ! resumereqpr ) {
-		if ( ! underfoundpr || undertime <= sametime ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+	if (samefoundpr && ! resumereqpr) {
+		if (! underfoundpr || undertime <= sametime) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "most recent level %d dump "
 			      "was interrupted, "
 			      "but not resuming that dump since "
 			      "resume (-R) option not specified\n"),
-			      sc_level );
+			      sc_level);
 		}
-		free( ( void * )sc_resumerangep );
+		free((void *)sc_resumerangep);
 		sc_resumerangep = 0;
 		samefoundpr = BOOL_FALSE;
 	}
-	if ( underfoundpr ) {
-		assert( underlevel <= LEVEL_MAX );
-		assert( undertime );
-		if ( samefoundpr ) {
-			if ( undertime >= sametime ) {
-				if ( underinterruptedpr ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (underfoundpr) {
+		assert(underlevel <= LEVEL_MAX);
+		assert(undertime);
+		if (samefoundpr) {
+			if (undertime >= sametime) {
+				if (underinterruptedpr) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "most recent base for "
 					      "incremental dump was "
 					      "interrupted (level %u): "
 					      "must resume or redump "
 					      "at or below level %d\n"),
 					      underlevel,
-					      sc_level );
+					      sc_level);
 					return BOOL_FALSE;
 				}
-				if ( subtreecnt && ! underpartialpr ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				if (subtreecnt && ! underpartialpr) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "level %u incremental "
 					      "subtree dump "
 					      "will be based on non-subtree "
 					      "level %u dump\n"),
 					      sc_level,
-					      underlevel );
+					      underlevel);
 				}
-				if ( ! subtreecnt && underpartialpr ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				if (! subtreecnt && underpartialpr) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "level %u incremental "
 					      "non-subtree dump "
 					      "will be based on subtree "
 					      "level %u dump\n"),
 					      sc_level,
-					      underlevel );
+					      underlevel);
 				}
 				sc_incrpr = BOOL_TRUE;
 				sc_incrbasetime = undertime;
 				sc_incrbaselevel = underlevel;
 				uuid_copy(sc_incrbaseid, underid);
 				sc_resumepr = BOOL_FALSE;
-				assert( sc_resumerangep );
-				free( ( void * )sc_resumerangep );
+				assert(sc_resumerangep);
+				free((void *)sc_resumerangep);
 				sc_resumerangep = 0;
 			} else {
-				if ( subtreecnt && ! samepartialpr ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				if (subtreecnt && ! samepartialpr) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "level %u incremental "
 					      "subtree dump "
 					      "will be based on non-subtree "
 					      "level %u resumed dump\n"),
 					      sc_level,
-					      sc_level );
+					      sc_level);
 				}
-				if ( ! subtreecnt && samepartialpr ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				if (! subtreecnt && samepartialpr) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "level %u incremental "
 					      "non-subtree dump "
 					      "will be based on subtree "
 					      "level %u resumed dump\n"),
 					      sc_level,
-					      sc_level );
+					      sc_level);
 				}
-				assert( sametime );
+				assert(sametime);
 				sc_incrpr = BOOL_TRUE;
 				sc_incrbasetime = undertime;
 				sc_incrbaselevel = underlevel;
 				sc_resumepr = BOOL_TRUE;
 				sc_resumebasetime = sametime;
 				uuid_copy(sc_resumebaseid, sameid);
-				assert( sc_resumerangep );
+				assert(sc_resumerangep);
 			}
 		} else {
-			if ( underinterruptedpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (underinterruptedpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "most recent base for "
 				      "incremental dump was "
 				      "interrupted (level %u): "
 				      "must resume or redump "
 				      "at or below level %d\n"),
 				      underlevel,
-				      sc_level );
+				      sc_level);
 				return BOOL_FALSE;
 			}
-			if ( subtreecnt && ! underpartialpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (subtreecnt && ! underpartialpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "level %u incremental "
 				      "subtree dump "
 				      "will be based on non-subtree "
 				      "level %u dump\n"),
 				      sc_level,
-				      underlevel );
+				      underlevel);
 			}
-			if ( ! subtreecnt && underpartialpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (! subtreecnt && underpartialpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "level %u incremental "
 				      "non-subtree dump "
 				      "will be based on subtree "
 				      "level %u dump\n"),
 				      sc_level,
-				      underlevel );
+				      underlevel);
 			}
 			sc_incrpr = BOOL_TRUE;
 			sc_incrbasetime = undertime;
 			sc_incrbaselevel = underlevel;
 			uuid_copy(sc_incrbaseid, underid);
 			sc_resumepr = BOOL_FALSE;
-			assert( ! sc_resumerangep );
+			assert(! sc_resumerangep);
 		}
 	} else {
-		if ( samefoundpr ) {
-			assert( sametime );
-			if ( subtreecnt && ! samepartialpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		if (samefoundpr) {
+			assert(sametime);
+			if (subtreecnt && ! samepartialpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "level %u "
 				      "subtree dump "
 				      "will be based on non-subtree "
 				      "level %u resumed dump\n"),
 				      sc_level,
-				      sc_level );
+				      sc_level);
 			}
-			if ( ! subtreecnt && samepartialpr ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (! subtreecnt && samepartialpr) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "level %u "
 				      "non-subtree dump "
 				      "will be based on subtree "
 				      "level %u resumed dump\n"),
 				      sc_level,
-				      sc_level );
+				      sc_level);
 			}
 			sc_incrpr = BOOL_FALSE;
 			sc_resumepr = BOOL_TRUE;
 			sc_resumebasetime = sametime;
 			uuid_copy(sc_resumebaseid, sameid);
-			assert( sc_resumerangep );
+			assert(sc_resumerangep);
 		} else {
 			sc_incrpr = BOOL_FALSE;
 			sc_resumepr = BOOL_FALSE;
-			assert( ! sc_resumerangep );
-			if ( sc_level > 0 ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			assert(! sc_resumerangep);
+			if (sc_level > 0) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "cannot find earlier dump "
 				      "to base level %d increment upon\n"),
-				      sc_level );
+				      sc_level);
 				return BOOL_FALSE;
 			}
 		}
@@ -1274,38 +1274,38 @@ baseuuidbypass:
 
 	/* don't allow interrupted dumps of a lesser level to be bases
 	 */
-	if ( sc_incrpr && underinterruptedpr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (sc_incrpr && underinterruptedpr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "most recent base dump (level %d begun %s) "
 		      "was interrupted: aborting\n"),
 		      sc_incrbaselevel,
-		      ctimennl( &sc_incrbasetime ));
+		      ctimennl(&sc_incrbasetime));
 		return BOOL_FALSE;
 	}
 
 	/* reject if resume (-R) specified, but base was not interrupted
 	 */
-	if ( ! sc_resumepr && resumereqpr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (! sc_resumepr && resumereqpr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "resume (-R) option inappropriate: "
 		      "no interrupted level %d dump to resume\n"),
-		      sc_level );
+		      sc_level);
 		return BOOL_FALSE;
 	}
 
 	/* announce the dump characteristics
 	 */
-	if ( sc_incrpr ) {
-		if ( sc_resumepr ) {
-			char restimestr[ 30 ];
-			char incrtimestr[ 30 ];
+	if (sc_incrpr) {
+		if (sc_resumepr) {
+			char restimestr[30];
+			char incrtimestr[30];
 
-			strcpy( restimestr, ctimennl( &sc_resumebasetime ));
-			assert( strlen( restimestr ) < sizeof( restimestr ));
-			strcpy( incrtimestr, ctimennl( &sc_incrbasetime ));
-			assert( strlen( incrtimestr ) < sizeof( incrtimestr ));
+			strcpy(restimestr, ctimennl(&sc_resumebasetime));
+			assert(strlen(restimestr) < sizeof(restimestr));
+			strcpy(incrtimestr, ctimennl(&sc_incrbasetime));
+			assert(strlen(incrtimestr) < sizeof(incrtimestr));
 
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "resuming level %d incremental dump of %s:%s "
 			      "begun %s "
 			      "(incremental base level %d begun %s)\n"),
@@ -1314,70 +1314,70 @@ baseuuidbypass:
 			      mntpnt,
 			      restimestr,
 			      sc_incrbaselevel,
-			      incrtimestr );
+			      incrtimestr);
 		} else {
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "level %d incremental dump of %s:%s "
 			      "based on level %d dump begun %s\n"),
 			      sc_level,
 			      gwhdrtemplatep->gh_hostname,
 			      mntpnt,
 			      sc_incrbaselevel,
-			      ctimennl( &sc_incrbasetime ));
+			      ctimennl(&sc_incrbasetime));
 		}
 	} else {
-		if ( sc_resumepr ) {
-			mlog( MLOG_VERBOSE, _(
+		if (sc_resumepr) {
+			mlog(MLOG_VERBOSE, _(
 			      "resuming level %d dump of %s:%s begun %s\n"),
 			      sc_level,
 			      gwhdrtemplatep->gh_hostname,
 			      mntpnt,
-			      ctimennl( &sc_resumebasetime ));
+			      ctimennl(&sc_resumebasetime));
 		} else {
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "level %d dump of %s:%s\n"),
 			      sc_level,
 			      gwhdrtemplatep->gh_hostname,
-			      mntpnt );
+			      mntpnt);
 		}
 	}
 
-	if ( preemptchk( PREEMPT_FULL )) {
+	if (preemptchk(PREEMPT_FULL)) {
 		return BOOL_FALSE;
 	}
 
 	/* announce the dump time
 	 */
-	mlog( MLOG_VERBOSE, _(
+	mlog(MLOG_VERBOSE, _(
 	      "dump date: %s\n"),
-	      ctimennl( &gwhdrtemplatep->gh_timestamp ));
+	      ctimennl(&gwhdrtemplatep->gh_timestamp));
 
 	/* display the session UUID
 	 */
 	{
 		char string_uuid[UUID_STR_LEN + 1];
-		uuid_unparse( gwhdrtemplatep->gh_dumpid, string_uuid );
-		mlog( MLOG_VERBOSE, _(
+		uuid_unparse(gwhdrtemplatep->gh_dumpid, string_uuid);
+		mlog(MLOG_VERBOSE, _(
 		      "session id: %s\n"),
-		      string_uuid );
+		      string_uuid);
 	}
 
 	/* display the session label
 	 */
-	mlog( MLOG_VERBOSE, _(
+	mlog(MLOG_VERBOSE, _(
 	      "session label: \"%s\"\n"),
-	      gwhdrtemplatep->gh_dumplabel );
+	      gwhdrtemplatep->gh_dumplabel);
 
 	/* get a file descriptor for the file system. any file
 	 * contained in the file system will do; use the mntpnt.
 	 * needed by bigstat.
 	 */
-	sc_fsfd = open( mntpnt, O_RDONLY );
-	if ( sc_fsfd < 0 ) {
-		mlog( MLOG_NORMAL, _(
+	sc_fsfd = open(mntpnt, O_RDONLY);
+	if (sc_fsfd < 0) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to open %s: %s\n"),
 		      mntpnt,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -1393,16 +1393,16 @@ baseuuidbypass:
 		xfs_fsop_bulkreq_t bulkreq;
 
 		/* Get the inode of the mount point */
-		rval = fstat64( sc_fsfd, &rootstat );
-		if ( rval ) {
-			mlog( MLOG_NORMAL, _(
+		rval = fstat64(sc_fsfd, &rootstat);
+		if (rval) {
+			mlog(MLOG_NORMAL, _(
 			      "could not stat %s\n"),
-			      mntpnt );
+			      mntpnt);
 			return BOOL_FALSE;
 		}
 		sc_rootxfsstatp =
-			( xfs_bstat_t * )calloc( 1, sizeof( xfs_bstat_t ));
-		assert( sc_rootxfsstatp );
+			(xfs_bstat_t *)calloc(1, sizeof(xfs_bstat_t));
+		assert(sc_rootxfsstatp);
 
 		/* Get the first valid (i.e. root) inode in this fs */
 		bulkreq.lastip = (__u64 *)&lastino;
@@ -1410,13 +1410,13 @@ baseuuidbypass:
 		bulkreq.ubuffer = sc_rootxfsstatp;
 		bulkreq.ocount = &ocount;
 		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
-			mlog( MLOG_ERROR,
+			mlog(MLOG_ERROR,
 			      _("failed to get bulkstat information for root inode\n"));
 			return BOOL_FALSE;
 		}
 
 		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
-			mlog ( MLOG_NORMAL | MLOG_NOTE,
+			mlog (MLOG_NORMAL | MLOG_NOTE,
 			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
 			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
@@ -1424,16 +1424,16 @@ baseuuidbypass:
 	/* alloc a file system handle, to be used with the jdm_open()
 	 * functions.
 	 */
-	sc_fshandlep = jdm_getfshandle( mntpnt );
-	if ( ! sc_fshandlep ) {
-		mlog( MLOG_NORMAL, _(
+	sc_fshandlep = jdm_getfshandle(mntpnt);
+	if (! sc_fshandlep) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to construct a file system handle for %s: %s\n"),
 		      mntpnt,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
-	if ( preemptchk( PREEMPT_FULL )) {
+	if (preemptchk(PREEMPT_FULL)) {
 		return BOOL_FALSE;
 	}
 
@@ -1454,11 +1454,11 @@ baseuuidbypass:
 	 * until the startpoints are copied into each streams header. will
 	 * be freed at the end of this function.
 	 */
-	sc_stat_inomapcnt = ( size64_t )fs_getinocnt( mntpnt );
+	sc_stat_inomapcnt = (size64_t)fs_getinocnt(mntpnt);
 
-	sc_startptp = ( startpt_t * )calloc( drivecnt, sizeof( startpt_t ));
-	assert( sc_startptp );
-	ok = inomap_build( sc_fshandlep,
+	sc_startptp = (startpt_t *)calloc(drivecnt, sizeof(startpt_t));
+	assert(sc_startptp);
+	ok = inomap_build(sc_fshandlep,
 			   sc_fsfd,
 			   sc_rootxfsstatp,
 			   sc_incrpr,
@@ -1475,58 +1475,58 @@ baseuuidbypass:
 			   &sc_stat_inomapphase,
 			   &sc_stat_inomappass,
 			   sc_stat_inomapcnt,
-			   &sc_stat_inomapdone );
-	free( ( void * )subtreep );
+			   &sc_stat_inomapdone);
+	free((void *)subtreep);
 	subtreep = 0;
-	if ( ! ok ) {
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
 	/* ask var to ask inomap to skip files under var if var is in
 	 * the fs being dumped
 	 */
-	var_skip( &fsid, inomap_skip );
+	var_skip(&fsid, inomap_skip);
 
 	/* fill in write header template content info. always produce
 	 * an inomap for each media file. the dirdump flag will be set
 	 * in content_stream_dump() for streams which dump the directories.
 	 */
-	assert( sizeof( cwhdrtemplatep->ch_specific ) >= sizeof( *scwhdrtemplatep ));
+	assert(sizeof(cwhdrtemplatep->ch_specific) >= sizeof(*scwhdrtemplatep));
 	scwhdrtemplatep->cih_mediafiletype = CIH_MEDIAFILETYPE_DATA;
-	scwhdrtemplatep->cih_level = ( int32_t )sc_level;
+	scwhdrtemplatep->cih_level = (int32_t)sc_level;
 	scwhdrtemplatep->cih_dumpattr = CIH_DUMPATTR_INOMAP;
-	if ( subtreecnt ) {
+	if (subtreecnt) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_SUBTREE;
 	}
-	if ( sc_inv_updatepr ) {
+	if (sc_inv_updatepr) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_INVENTORY;
 	}
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_FILEHDR_CHECKSUM;
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_EXTENTHDR_CHECKSUM;
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_DIRENTHDR_CHECKSUM;
 	scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_DIRENTHDR_GEN;
-	if ( sc_incrpr ) {
+	if (sc_incrpr) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_INCREMENTAL;
 		scwhdrtemplatep->cih_last_time = sc_incrbasetime;
 		uuid_copy(scwhdrtemplatep->cih_last_id, sc_incrbaseid);
-		if ( skip_unchanged_dirs ) {
+		if (skip_unchanged_dirs) {
 			scwhdrtemplatep->cih_dumpattr |=
 				CIH_DUMPATTR_NOTSELFCONTAINED;
 		}
 	}
-	if ( sc_resumepr ) {
+	if (sc_resumepr) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_RESUME;
 		scwhdrtemplatep->cih_resume_time = sc_resumebasetime;
 		uuid_copy(scwhdrtemplatep->cih_resume_id, sc_resumebaseid);
 	}
-	if ( sc_dumpextattrpr ) {
+	if (sc_dumpextattrpr) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_EXTATTR;
 		scwhdrtemplatep->cih_dumpattr |=
 					CIH_DUMPATTR_EXTATTRHDR_CHECKSUM;
 	}
 
 	scwhdrtemplatep->cih_rootino = sc_rootxfsstatp->bs_ino;
-	inomap_writehdr( scwhdrtemplatep );
+	inomap_writehdr(scwhdrtemplatep);
 
 	/* log the dump size. just a rough approx.
 	 */
@@ -1534,9 +1534,9 @@ baseuuidbypass:
 	nondircnt = scwhdrtemplatep->cih_inomap_nondircnt;
 	datasz = scwhdrtemplatep->cih_inomap_datasz;
 	inocnt = dircnt + nondircnt;
-	inomapsz = inomap_getsz( );
-	direntsz = inocnt * ( uint64_t )( DIRENTHDR_SZ + 8 );
-	filesz = inocnt * ( uint64_t )( FILEHDR_SZ + EXTENTHDR_SZ );
+	inomapsz = inomap_getsz();
+	direntsz = inocnt * (uint64_t)(DIRENTHDR_SZ + 8);
+	filesz = inocnt * (uint64_t)(FILEHDR_SZ + EXTENTHDR_SZ);
 
 	hdr_mfilesz =	GLOBAL_HDR_SZ
 			+
@@ -1548,27 +1548,27 @@ baseuuidbypass:
 			filesz
 			+
 			datasz;
-	mlog( MLOG_VERBOSE, _(
+	mlog(MLOG_VERBOSE, _(
 	      "estimated dump size: %llu bytes\n"),
-	      size_estimate );
+	      size_estimate);
 
 	if (drivecnt > 1) {
-	    mlog( MLOG_VERBOSE, _(
+	    mlog(MLOG_VERBOSE, _(
 		  "estimated dump size per stream: %llu bytes\n"),
 		    hdr_mfilesz + (filesz + datasz) / drivecnt);
 	}
-	mlog( MLOG_DEBUG,
+	mlog(MLOG_DEBUG,
 	      "estimated dump header size: %llu bytes\n",
-	      hdr_mfilesz );
-	mlog( MLOG_DEBUG,
+	      hdr_mfilesz);
+	mlog(MLOG_DEBUG,
 	      "estimated component sizes: global hdr: %llu bytes, "
 	      "inomap: %llu bytes,  dir entries: %llu bytes, "
 	      "file hdrs: %llu bytes, datasz: %llu bytes\n",
 	      GLOBAL_HDR_SZ, inomapsz, direntsz,
-	      filesz, datasz );
+	      filesz, datasz);
 
 	/* extract the progress stat denominators from the write hdr
-	 * template. placed there by inomap_writehdr( )
+	 * template. placed there by inomap_writehdr()
 	 */
 	sc_stat_dircnt = scwhdrtemplatep->cih_inomap_dircnt;
 	sc_stat_nondircnt = scwhdrtemplatep->cih_inomap_nondircnt;
@@ -1576,55 +1576,55 @@ baseuuidbypass:
 
 	/* allocate and populate per-stream context descriptors
 	 */
-	sc_contextp = ( context_t * )calloc( drivecnt, sizeof( context_t ));
-	assert( sc_contextp );
-	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-		context_t *contextp = &sc_contextp[ strmix ];
+	sc_contextp = (context_t *)calloc(drivecnt, sizeof(context_t));
+	assert(sc_contextp);
+	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+		context_t *contextp = &sc_contextp[strmix];
 
 		contextp->cc_filehdrp =
-				( filehdr_t * )calloc( 1, sizeof( filehdr_t ));
-		assert( contextp->cc_filehdrp );
+				(filehdr_t *)calloc(1, sizeof(filehdr_t));
+		assert(contextp->cc_filehdrp);
 
 		contextp->cc_extenthdrp =
-			    ( extenthdr_t * )calloc( 1, sizeof( extenthdr_t ));
-		assert( contextp->cc_extenthdrp );
+			    (extenthdr_t *)calloc(1, sizeof(extenthdr_t));
+		assert(contextp->cc_extenthdrp);
 
-		contextp->cc_getdentsbufsz = sizeof( struct dirent )
+		contextp->cc_getdentsbufsz = sizeof(struct dirent)
 					       +
 					       NAME_MAX + 1;
-		if ( contextp->cc_getdentsbufsz < GETDENTSBUF_SZ_MIN ) {
+		if (contextp->cc_getdentsbufsz < GETDENTSBUF_SZ_MIN) {
 			contextp->cc_getdentsbufsz = GETDENTSBUF_SZ_MIN;
 		}
 		contextp->cc_getdentsbufp =
-			   ( char * ) calloc( 1, contextp->cc_getdentsbufsz );
-		assert( contextp->cc_getdentsbufp );
+			   (char *) calloc(1, contextp->cc_getdentsbufsz);
+		assert(contextp->cc_getdentsbufp);
 
-		contextp->cc_mdirentbufsz = sizeof( direnthdr_t  )
+		contextp->cc_mdirentbufsz = sizeof(direnthdr_t)
 					    +
 					    NAME_MAX + 1
 					    +
 					    DIRENTHDR_ALIGN;
 		contextp->cc_mdirentbufp =
-			   ( char * ) calloc( 1, contextp->cc_mdirentbufsz );
-		assert( contextp->cc_mdirentbufp );
+			   (char *) calloc(1, contextp->cc_mdirentbufsz);
+		assert(contextp->cc_mdirentbufp);
 
 		contextp->cc_extattrlistbufsz = EXTATTR_LISTBUF_SZ;
 		contextp->cc_extattrrtrvarraylen = EXTATTR_RTRVARRAY_LEN;
 		contextp->cc_extattrdumpbufsz = 2 * ATTR_MAX_VALUELEN;
-		if ( contextp->cc_extattrdumpbufsz < EXTATTR_DUMPBUF_SZ ) {
+		if (contextp->cc_extattrdumpbufsz < EXTATTR_DUMPBUF_SZ) {
 			contextp->cc_extattrdumpbufsz = EXTATTR_DUMPBUF_SZ;
 		}
 		contextp->cc_extattrlistbufp =
-			   ( char * )calloc( 1, contextp->cc_extattrlistbufsz );
-		assert( contextp->cc_extattrlistbufp );
+			   (char *)calloc(1, contextp->cc_extattrlistbufsz);
+		assert(contextp->cc_extattrlistbufp);
 		contextp->cc_extattrrtrvarrayp =
-		  ( attr_multiop_t * )calloc( contextp->cc_extattrrtrvarraylen,
-				    sizeof( attr_multiop_t ));
-		assert( contextp->cc_extattrrtrvarrayp );
+		  (attr_multiop_t *)calloc(contextp->cc_extattrrtrvarraylen,
+				    sizeof(attr_multiop_t));
+		assert(contextp->cc_extattrrtrvarrayp);
 		contextp->cc_extattrdumpbufp =
-			   ( char * )memalign( sizeof( extattrhdr_t ),
-					       contextp->cc_extattrdumpbufsz );
-		assert( contextp->cc_extattrdumpbufp );
+			   (char *)memalign(sizeof(extattrhdr_t),
+					       contextp->cc_extattrdumpbufsz);
+		assert(contextp->cc_extattrdumpbufp);
 		if (hsm_fs_ctxtp) {
 			contextp->cc_hsm_f_ctxtp = HsmAllocateFileContext(
 				hsm_fs_ctxtp);
@@ -1634,10 +1634,10 @@ baseuuidbypass:
 
 		contextp->cc_readlinkbufsz = MAXPATHLEN + SYMLINK_ALIGN;
 		contextp->cc_readlinkbufp =
-			   ( char * ) calloc( 1, contextp->cc_readlinkbufsz );
-		assert( contextp->cc_readlinkbufp );
+			   (char *) calloc(1, contextp->cc_readlinkbufsz);
+		assert(contextp->cc_readlinkbufp);
 
-		contextp->cc_inomap_contextp = inomap_alloc_context( );
+		contextp->cc_inomap_contextp = inomap_alloc_context();
 	}
 
 	/* look for command line media labels. these will be assigned
@@ -1652,22 +1652,22 @@ baseuuidbypass:
 
 		optind = 1;
 		opterr = 0;
-		while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-			switch ( c ) {
+		while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+			switch (c) {
 			case GETOPT_MEDIALABEL:
-				if ( cp >= ep ) {
-					mlog( MLOG_NORMAL, _(
+				if (cp >= ep) {
+					mlog(MLOG_NORMAL, _(
 					      "more -%c arguments "
 					      "than number of drives\n"),
-					      c );
-					usage( );
+					      c);
+					usage();
 					return BOOL_FALSE;
 				}
-				if ( ! optarg || optarg[ 0 ] == '-' ) {
-					mlog( MLOG_NORMAL, _(
+				if (! optarg || optarg[0] == '-') {
+					mlog(MLOG_NORMAL, _(
 					      "-%c argument missing\n"),
-					      c );
-					usage( );
+					      c);
+					usage();
 					return BOOL_FALSE;
 				}
 				cp->cc_Media_firstlabel = optarg;
@@ -1676,39 +1676,39 @@ baseuuidbypass:
 			}
 		}
 
-		if ( cp > sc_contextp && cp < ep ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		if (cp > sc_contextp && cp < ep) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "media labels given for only %d out of %d "
 			      "drives\n"),
 			      cp - sc_contextp,
-			      drivecnt );
+			      drivecnt);
 		}
 	}
 
-	if ( preemptchk( PREEMPT_FULL )) {
+	if (preemptchk(PREEMPT_FULL)) {
 		return BOOL_FALSE;
 	}
 
 	/* open the dump inventory and a dump inventory write session
 	 * if an inventory update is to be done.
 	 */
-	if ( sc_inv_updatepr ) {
+	if (sc_inv_updatepr) {
 		bool_t result;
 		sigset_t tty_set, orig_set;
 
 		/* hold tty signals while creating a new inventory session */
-		sigemptyset( &tty_set );
-		sigaddset( &tty_set, SIGINT );
-		sigaddset( &tty_set, SIGQUIT );
-		sigaddset( &tty_set, SIGHUP );
-		pthread_sigmask( SIG_BLOCK, &tty_set, &orig_set );
+		sigemptyset(&tty_set);
+		sigaddset(&tty_set, SIGINT);
+		sigaddset(&tty_set, SIGQUIT);
+		sigaddset(&tty_set, SIGHUP);
+		pthread_sigmask(SIG_BLOCK, &tty_set, &orig_set);
 
-		result = create_inv_session( gwhdrtemplatep, &fsid, mntpnt,
-					     fsdevice, subtreecnt, strmix );
+		result = create_inv_session(gwhdrtemplatep, &fsid, mntpnt,
+					     fsdevice, subtreecnt, strmix);
 
-		pthread_sigmask( SIG_SETMASK, &orig_set, NULL );
+		pthread_sigmask(SIG_SETMASK, &orig_set, NULL);
 
-		if ( !result ) {
+		if (!result) {
 			return BOOL_FALSE;
 		}
 	}
@@ -1717,11 +1717,11 @@ baseuuidbypass:
 	 */
 	{
 		ix_t ix;
-		ix_t endix = sizeof( sc_mcflag )
+		ix_t endix = sizeof(sc_mcflag)
 			     /
-			     sizeof( sc_mcflag[ 0 ] );
-		for ( ix = 0 ; ix < endix ; ix++ ) {
-			sc_mcflag[ ix ] = BOOL_FALSE;
+			     sizeof(sc_mcflag[0]);
+		for (ix = 0 ; ix < endix ; ix++) {
+			sc_mcflag[ix] = BOOL_FALSE;
 		}
 	}
 	content_media_change_needed = BOOL_FALSE;
@@ -1730,8 +1730,8 @@ baseuuidbypass:
 	 */
 	{
 		ix_t driveix;
-		for ( driveix = 0 ; driveix < STREAM_SIMMAX ; driveix++ ) {
-			sc_stat_pds[ driveix ].pds_phase = PDS_NULL;
+		for (driveix = 0 ; driveix < STREAM_SIMMAX ; driveix++) {
+			sc_stat_pds[driveix].pds_phase = PDS_NULL;
 		}
 	}
 
@@ -1741,10 +1741,10 @@ baseuuidbypass:
 #define STATLINESZ	160
 
 size_t
-content_statline( char **linespp[ ] )
+content_statline(char **linespp[])
 {
-	static char statlinebuf[ STREAM_SIMMAX + 1 ][ STATLINESZ ];
-	static char *statline[ STREAM_SIMMAX + 1 ];
+	static char statlinebuf[STREAM_SIMMAX + 1][STATLINESZ];
+	static char *statline[STREAM_SIMMAX + 1];
 	size_t statlinecnt;
 	size64_t nondirdone;
 	size64_t datadone;
@@ -1756,32 +1756,32 @@ content_statline( char **linespp[ ] )
 
 	/* build and supply the line array
 	 */
-	for ( i = 0 ; i < STREAM_SIMMAX + 1 ; i++ ) {
-		statline[ i ] = &statlinebuf[ i ][ 0 ];
+	for (i = 0 ; i < STREAM_SIMMAX + 1 ; i++) {
+		statline[i] = &statlinebuf[i][0];
 	}
 	*linespp = statline;
 	statlinecnt = 0;
 
 	/* if start time not initialized, return no strings
 	 */
-	if ( ! sc_stat_starttime ) {
+	if (! sc_stat_starttime) {
 		return 0;
 	}
 
 	/* calculate the elapsed time
 	 */
-	now = time( 0 );
+	now = time(0);
 	elapsed = now - sc_stat_starttime;
 
 	/* get local time
 	 */
-	tmp = localtime( &now );
+	tmp = localtime(&now);
 
 	/* if inomap phase indicated, report on that
 	 */
-	if ( sc_stat_inomapphase && sc_stat_inomapcnt ) {
-		if ( sc_stat_inomappass ) {
-			sprintf( statline[ 0 ],
+	if (sc_stat_inomapphase && sc_stat_inomapcnt) {
+		if (sc_stat_inomappass) {
+			sprintf(statline[0],
 				 "status at %02d:%02d:%02d: "
 				 "inomap phase %u pass %u "
 				 "%llu/%llu inos scanned, "
@@ -1793,10 +1793,10 @@ content_statline( char **linespp[ ] )
 				 (unsigned int)sc_stat_inomappass,
 				 (unsigned long long)sc_stat_inomapdone,
 				 (unsigned long long)sc_stat_inomapcnt,
-				 elapsed );
-			assert( strlen( statline[ 0 ] ) < STATLINESZ );
+				 elapsed);
+			assert(strlen(statline[0]) < STATLINESZ);
 		} else {
-			sprintf( statline[ 0 ],
+			sprintf(statline[0],
 				 "status at %02d:%02d:%02d: "
 				 "inomap phase %u "
 				 "%llu/%llu inos scanned, "
@@ -1807,38 +1807,38 @@ content_statline( char **linespp[ ] )
 				 (unsigned int)sc_stat_inomapphase,
 				 (unsigned long long)sc_stat_inomapdone,
 				 (unsigned long long)sc_stat_inomapcnt,
-				 elapsed );
-			assert( strlen( statline[ 0 ] ) < STATLINESZ );
+				 elapsed);
+			assert(strlen(statline[0]) < STATLINESZ);
 		}
 		return 1;
 	}
 
 	/* get the accumulated totals for non-dir inos and data bytes dumped
 	 */
-	lock( );
+	lock();
 	nondirdone = sc_stat_nondirdone;
 	datadone = sc_stat_datadone;
-	unlock( );
+	unlock();
 
 	/* non-dir dump phase */
-	if ( nondirdone || datadone ) {
+	if (nondirdone || datadone) {
 		/* calculate percentage of data dumped
 		*/
-		if ( sc_stat_datasz ) {
-			percent = ( double )datadone
+		if (sc_stat_datasz) {
+			percent = (double)datadone
 				/
-				( double )sc_stat_datasz;
+				(double)sc_stat_datasz;
 			percent *= 100.0;
 		} else {
 			percent = 100.0;
 		}
-		if ( percent > 100.0 ) {
+		if (percent > 100.0) {
 			percent = 100.0;
 		}
 
 		/* format the status line in a local static buffer (non-re-entrant!)
 		*/
-		sprintf( statline[ 0 ],
+		sprintf(statline[0],
 				"status at %02d:%02d:%02d: %llu/%llu files dumped, "
 				"%.1lf%%%% data dumped, "
 				"%ld seconds elapsed\n",
@@ -1848,66 +1848,66 @@ content_statline( char **linespp[ ] )
 				(unsigned long long) nondirdone,
 				(unsigned long long) sc_stat_nondircnt,
 				percent,
-				elapsed );
+				elapsed);
 	} else {
-		sprintf( statline[ 0 ],
+		sprintf(statline[0],
 				"status at %02d:%02d:%02d: "
 				"%ld seconds elapsed\n",
 				tmp->tm_hour,
 				tmp->tm_min,
 				tmp->tm_sec,
-				elapsed );
+				elapsed);
 	}
 
-	assert( strlen( statline[ 0 ] ) < STATLINESZ );
+	assert(strlen(statline[0]) < STATLINESZ);
 
 	/* optionally create stat lines for each drive
 	 */
 	statlinecnt = 1;
-	for ( i = 0 ; i < drivecnt ; i++ ) {
-		pds_t *pdsp = &sc_stat_pds[ i ];
-		if ( pdsp->pds_phase == PDS_NULL
+	for (i = 0 ; i < drivecnt ; i++) {
+		pds_t *pdsp = &sc_stat_pds[i];
+		if (pdsp->pds_phase == PDS_NULL
 		     ||
-		     pdsp->pds_phase == PDS_NONDIR ) {
+		     pdsp->pds_phase == PDS_NONDIR) {
 			continue;
 		}
-		statline[ statlinecnt ][ 0 ] = 0;
-		if ( drivecnt > 1 ) {
-			sprintf( statline[ statlinecnt ],
+		statline[statlinecnt][0] = 0;
+		if (drivecnt > 1) {
+			sprintf(statline[statlinecnt],
 				 "drive %u: ",
-				 (unsigned int)i );
+				 (unsigned int)i);
 		}
-		switch( pdsp->pds_phase ) {
+		switch(pdsp->pds_phase) {
 		case PDS_INOMAP:
-			strcat( statline[ statlinecnt ],
-				"dumping inomap" );
+			strcat(statline[statlinecnt],
+				"dumping inomap");
 			break;
 		case PDS_DIRDUMP:
-			sprintf( &statline[ statlinecnt ]
-					  [ strlen( statline[ statlinecnt ] ) ],
+			sprintf(&statline[statlinecnt]
+					  [strlen(statline[statlinecnt])],
 				 "%llu/%llu directories dumped",
 				 (unsigned long long)pdsp->pds_dirdone,
-				 (unsigned long long)sc_stat_dircnt );
+				 (unsigned long long)sc_stat_dircnt);
 			break;
 		case PDS_INVSYNC:
-			strcat( statline[ statlinecnt ],
-				"waiting to dump inventory" );
+			strcat(statline[statlinecnt],
+				"waiting to dump inventory");
 			break;
 		case PDS_INVDUMP:
-			strcat( statline[ statlinecnt ],
-				"dumping inventory" );
+			strcat(statline[statlinecnt],
+				"dumping inventory");
 			break;
 		case PDS_TERMDUMP:
-			strcat( statline[ statlinecnt ],
-				"dumping stream terminator" );
+			strcat(statline[statlinecnt],
+				"dumping stream terminator");
 			break;
 		default:
 			break;
 		}
-		sprintf( &statline[ statlinecnt ]
-				  [ strlen( statline[ statlinecnt ] ) ],
-			 "\n" );
-		assert( strlen( statline[ statlinecnt ] ) < STATLINESZ );
+		sprintf(&statline[statlinecnt]
+				  [strlen(statline[statlinecnt])],
+			 "\n");
+		assert(strlen(statline[statlinecnt]) < STATLINESZ);
 		statlinecnt++;
 	}
 
@@ -1928,61 +1928,61 @@ create_inv_session(
 	char *qfsdevice;
 
 	/* create a cleanup handler to close the inventory on exit. */
-	rval = atexit( inv_cleanup );
-	assert( ! rval );
+	rval = atexit(inv_cleanup);
+	assert(! rval);
 
-	sc_inv_idbtoken = inv_open( ( inv_predicate_t )INV_BY_UUID,
+	sc_inv_idbtoken = inv_open((inv_predicate_t)INV_BY_UUID,
 					INV_SEARCH_N_MOD,
-					( void * )fsidp );
-	if ( sc_inv_idbtoken == INV_TOKEN_NULL ) {
+					(void *)fsidp);
+	if (sc_inv_idbtoken == INV_TOKEN_NULL) {
 		return BOOL_FALSE;
 	}
-	qmntpnt = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
-					+ 1 + strlen( mntpnt ) + 1 );
-	assert( qmntpnt );
-	assert( strlen( gwhdrtemplatep->gh_hostname ));
-	sprintf( qmntpnt, "%s:%s", gwhdrtemplatep->gh_hostname, mntpnt );
-	qfsdevice = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
-					 + 1 + strlen( fsdevice ) + 1 );
-	assert( qfsdevice );
-	sprintf( qfsdevice, "%s:%s", gwhdrtemplatep->gh_hostname, fsdevice );
-
-	sc_inv_sestoken = inv_writesession_open( sc_inv_idbtoken,
+	qmntpnt = (char *)calloc(1, strlen(gwhdrtemplatep->gh_hostname)
+					+ 1 + strlen(mntpnt) + 1);
+	assert(qmntpnt);
+	assert(strlen(gwhdrtemplatep->gh_hostname));
+	sprintf(qmntpnt, "%s:%s", gwhdrtemplatep->gh_hostname, mntpnt);
+	qfsdevice = (char *)calloc(1, strlen(gwhdrtemplatep->gh_hostname)
+					 + 1 + strlen(fsdevice) + 1);
+	assert(qfsdevice);
+	sprintf(qfsdevice, "%s:%s", gwhdrtemplatep->gh_hostname, fsdevice);
+
+	sc_inv_sestoken = inv_writesession_open(sc_inv_idbtoken,
 						fsidp,
 						&gwhdrtemplatep->gh_dumpid,
 						gwhdrtemplatep->gh_dumplabel,
 						subtreecnt ? BOOL_TRUE
 							   : BOOL_FALSE,
 						sc_resumepr,
-						( u_char_t )sc_level,
+						(u_char_t)sc_level,
 						drivecnt,
 						gwhdrtemplatep->gh_timestamp,
 						qmntpnt,
-						qfsdevice );
-	if ( sc_inv_sestoken == INV_TOKEN_NULL ) {
+						qfsdevice);
+	if (sc_inv_sestoken == INV_TOKEN_NULL) {
 		return BOOL_FALSE;
 	}
 
 	/* open an inventory stream for each stream
 	*/
-	sc_inv_stmtokenp = ( inv_stmtoken_t * )
-				calloc( drivecnt, sizeof( inv_stmtoken_t ));
-	assert( sc_inv_stmtokenp );
-	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-		drive_t *drivep = drivepp[ strmix ];
+	sc_inv_stmtokenp = (inv_stmtoken_t *)
+				calloc(drivecnt, sizeof(inv_stmtoken_t));
+	assert(sc_inv_stmtokenp);
+	for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+		drive_t *drivep = drivepp[strmix];
 		char *drvpath;
 
-		if ( strcmp( drivep->d_pathname, "stdio" )) {
-			drvpath = path_reltoabs( drivep->d_pathname, homedir );
+		if (strcmp(drivep->d_pathname, "stdio")) {
+			drvpath = path_reltoabs(drivep->d_pathname, homedir);
 		} else {
 			drvpath = drivep->d_pathname;
 		}
-		sc_inv_stmtokenp[ strmix ] = inv_stream_open( sc_inv_sestoken,
-								drvpath );
-		if ( strcmp( drivep->d_pathname, "stdio" )) {
-			free( ( void * )drvpath );
+		sc_inv_stmtokenp[strmix] = inv_stream_open(sc_inv_sestoken,
+								drvpath);
+		if (strcmp(drivep->d_pathname, "stdio")) {
+			free((void *)drvpath);
 		}
-		if ( sc_inv_stmtokenp[ strmix ] == INV_TOKEN_NULL ) {
+		if (sc_inv_stmtokenp[strmix] == INV_TOKEN_NULL) {
 			return BOOL_FALSE;
 		}
 	}
@@ -1991,55 +1991,55 @@ create_inv_session(
 }
 
 static void
-mark_set( drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags )
+mark_set(drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags)
 {
 	drive_ops_t *dop = drivep->d_opsp;
-	mark_t *markp = ( mark_t * )calloc( 1, sizeof( mark_t ));
-	assert( markp );
-
-	if ( flags & STARTPT_FLAGS_NULL ) {
-		mlog( MLOG_DEBUG,
-		      "setting media NULL mark\n" );
-	} else if ( flags & STARTPT_FLAGS_END ) {
-		mlog( MLOG_DEBUG,
-		      "setting media END mark\n" );
+	mark_t *markp = (mark_t *)calloc(1, sizeof(mark_t));
+	assert(markp);
+
+	if (flags & STARTPT_FLAGS_NULL) {
+		mlog(MLOG_DEBUG,
+		      "setting media NULL mark\n");
+	} else if (flags & STARTPT_FLAGS_END) {
+		mlog(MLOG_DEBUG,
+		      "setting media END mark\n");
 	} else {
-		mlog( MLOG_DEBUG,
+		mlog(MLOG_DEBUG,
 		      "setting media mark"
 		      " for ino %llu offset %lld\n",
 		      ino,
-		      offset );
+		      offset);
 	}
 
 	markp->startpt.sp_ino = ino;
 	markp->startpt.sp_offset = offset;
 	markp->startpt.sp_flags = flags;
-	( * dop->do_set_mark )( drivep,
+	(* dop->do_set_mark)(drivep,
 				mark_callback,
-				( void * )drivep->d_index,
-				( drive_markrec_t * )markp );
+				(void *)drivep->d_index,
+				(drive_markrec_t *)markp);
 }
 
 static void
-mark_callback( void *p, drive_markrec_t *dmp, bool_t committed )
+mark_callback(void *p, drive_markrec_t *dmp, bool_t committed)
 {
 	/* get context
 	 */
-	ix_t strmix = ( ix_t )p;
-	context_t *contextp = &sc_contextp[ strmix ];
-	drive_t *drivep = drivepp[ strmix ];
+	ix_t strmix = (ix_t)p;
+	context_t *contextp = &sc_contextp[strmix];
+	drive_t *drivep = drivepp[strmix];
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
-	content_hdr_t *cwhdrp = ( content_hdr_t * )mwhdrp->mh_upper;
-	content_inode_hdr_t *scwhdrp = ( content_inode_hdr_t * )
-				       ( void * )
+	media_hdr_t *mwhdrp = (media_hdr_t *)dwhdrp->dh_upper;
+	content_hdr_t *cwhdrp = (content_hdr_t *)mwhdrp->mh_upper;
+	content_inode_hdr_t *scwhdrp = (content_inode_hdr_t *)
+				       (void *)
 				       cwhdrp->ch_specific;
 
 	/* this is really a mark_t, allocated by mark_set()
 	 */
-	mark_t *markp = ( mark_t * )dmp;
+	mark_t *markp = (mark_t *)dmp;
 
-	if ( committed ) {
+	if (committed) {
 		/* bump the per-mfile mark committed count
 		 */
 		contextp->cc_markscommitted++;
@@ -2051,18 +2051,18 @@ mark_callback( void *p, drive_markrec_t *dmp, bool_t committed )
 
 		/* log the mark commit
 		 */
-		if ( markp->startpt.sp_flags & STARTPT_FLAGS_NULL ) {
-			mlog( MLOG_DEBUG,
+		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
+			mlog(MLOG_DEBUG,
 			      "media NULL mark committed"
 			      " in media file %d\n",
-			      mwhdrp->mh_dumpfileix );
+			      mwhdrp->mh_dumpfileix);
 			scwhdrp->cih_startpt.sp_flags |= STARTPT_FLAGS_NULL;
-		} else if ( markp->startpt.sp_flags & STARTPT_FLAGS_END ) {
-			mlog( MLOG_DEBUG,
+		} else if (markp->startpt.sp_flags & STARTPT_FLAGS_END) {
+			mlog(MLOG_DEBUG,
 			      "media END mark committed"
 			      " in media file %d\n",
-			      mwhdrp->mh_dumpfileix );
-			if ( scwhdrp->cih_endpt.sp_flags & STARTPT_FLAGS_END ) {
+			      mwhdrp->mh_dumpfileix);
+			if (scwhdrp->cih_endpt.sp_flags & STARTPT_FLAGS_END) {
 				scwhdrp->cih_startpt.sp_ino++;
 				scwhdrp->cih_startpt.sp_offset = 0;
 			} else {
@@ -2070,49 +2070,49 @@ mark_callback( void *p, drive_markrec_t *dmp, bool_t committed )
 			}
 			scwhdrp->cih_startpt.sp_flags |= STARTPT_FLAGS_END;
 		} else {
-			mlog( MLOG_DEBUG,
+			mlog(MLOG_DEBUG,
 			      "media mark committed"
 			      " for ino %llu offset %lld"
 			      " in media file %d\n",
 			      markp->startpt.sp_ino,
 			      markp->startpt.sp_offset,
-			      mwhdrp->mh_dumpfileix );
+			      mwhdrp->mh_dumpfileix);
 			scwhdrp->cih_startpt = markp->startpt;
 		}
 	} else {
 		/* note the mark was not committed
 		 */
-		if ( markp->startpt.sp_flags & STARTPT_FLAGS_NULL ) {
-			mlog( MLOG_DEBUG,
-			      "media NULL mark -NOT- committed\n" );
-		} else if ( markp->startpt.sp_flags & STARTPT_FLAGS_END ) {
-			mlog( MLOG_DEBUG,
-			      "media END mark -NOT- committed\n" );
+		if (markp->startpt.sp_flags & STARTPT_FLAGS_NULL) {
+			mlog(MLOG_DEBUG,
+			      "media NULL mark -NOT- committed\n");
+		} else if (markp->startpt.sp_flags & STARTPT_FLAGS_END) {
+			mlog(MLOG_DEBUG,
+			      "media END mark -NOT- committed\n");
 		} else {
-			mlog( MLOG_DEBUG,
+			mlog(MLOG_DEBUG,
 			      "media mark -NOT- committed"
 			      " for ino %llu offset %lld\n",
 			      markp->startpt.sp_ino,
-			      markp->startpt.sp_offset );
+			      markp->startpt.sp_offset);
 		}
 	}
 
 	/* get rid of this mark (it was allocated by mark_set())
 	 */
-	free( ( void * )markp );
+	free((void *)markp);
 }
 
 /* begin - called by stream process to invoke the dump stream
  */
 int
-content_stream_dump( ix_t strmix )
+content_stream_dump(ix_t strmix)
 {
-	context_t *contextp = &sc_contextp[ strmix ];
-	drive_t *drivep = drivepp[ strmix ];
+	context_t *contextp = &sc_contextp[strmix];
+	drive_t *drivep = drivepp[strmix];
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
-	content_hdr_t *cwhdrp = ( content_hdr_t * )mwhdrp->mh_upper;
-	content_inode_hdr_t *scwhdrp = ( content_inode_hdr_t * )
+	media_hdr_t *mwhdrp = (media_hdr_t *)dwhdrp->dh_upper;
+	content_hdr_t *cwhdrp = (content_hdr_t *)mwhdrp->mh_upper;
+	content_inode_hdr_t *scwhdrp = (content_inode_hdr_t *)
 				       cwhdrp->ch_specific;
 	void *inomap_contextp;
 	bool_t all_nondirs_committed;
@@ -2126,46 +2126,46 @@ content_stream_dump( ix_t strmix )
 
 	/* sanity checks
 	 */
-	assert( RV_OK == 0 ); /* bigstat_iter depends on this */
+	assert(RV_OK == 0); /* bigstat_iter depends on this */
 
 	/* allocate a buffer for use by bstat_iter
 	 */
-	bstatbufp = ( xfs_bstat_t * )calloc( bstatbuflen,
-					     sizeof( xfs_bstat_t ));
-	assert( bstatbufp );
+	bstatbufp = (xfs_bstat_t *)calloc(bstatbuflen,
+					     sizeof(xfs_bstat_t));
+	assert(bstatbufp);
 
 	/* allocate an inomap context */
 	inomap_contextp = inomap_alloc_context();
-	assert( inomap_contextp );
+	assert(inomap_contextp);
 
 	/* determine if stream terminators will be used and are expected.
 	 * this will be revised each time a new media file is begun.
 	 */
-	update_cc_Media_useterminatorpr( drivep, contextp );
+	update_cc_Media_useterminatorpr(drivep, contextp);
 
 	/* check in
 	 */
-	lock( );
+	lock();
 	sc_thrdsarrivedcnt++;
-	unlock( );
+	unlock();
 
 	/* fill in write hdr stream start and end points
 	 */
-	scwhdrp->cih_startpt = sc_startptp[ strmix ];
-	if ( strmix < drivecnt - 1 ) {
-		scwhdrp->cih_endpt = sc_startptp[ strmix + 1 ];
+	scwhdrp->cih_startpt = sc_startptp[strmix];
+	if (strmix < drivecnt - 1) {
+		scwhdrp->cih_endpt = sc_startptp[strmix + 1];
 	} else {
 		scwhdrp->cih_endpt.sp_flags = STARTPT_FLAGS_END;
 	}
 
 	// the first stream dumps the directories
-	if ( strmix == 0 ) {
+	if (strmix == 0) {
 		scwhdrp->cih_dumpattr |= CIH_DUMPATTR_DIRDUMP;
 	}
 
 	/* fill in inomap fields of write hdr
 	 */
-	inomap_writehdr( scwhdrp );
+	inomap_writehdr(scwhdrp);
 
 	/* used to decide if any non-dirs not yet on media
 	 */
@@ -2183,8 +2183,8 @@ content_stream_dump( ix_t strmix )
 
 	/* get the inventory stream token
 	 */
-	if ( sc_inv_stmtokenp ) {
-		inv_stmt = sc_inv_stmtokenp[ strmix ];
+	if (sc_inv_stmtokenp) {
+		inv_stmt = sc_inv_stmtokenp[strmix];
 	} else {
 		inv_stmt = INV_TOKEN_NULL;
 	}
@@ -2195,7 +2195,7 @@ content_stream_dump( ix_t strmix )
 	 * The current startpoint will be updated each time a media mark
 	 * is committed.
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		xfs_ino_t startino;
 		bool_t stop_requested;
 		bool_t hit_eom;
@@ -2248,48 +2248,48 @@ content_stream_dump( ix_t strmix )
 		 * and begin a new media file. This will dump the media
 		 * file header if successful.
 		 */
-		rv = Media_mfile_begin( drivep, contextp, BOOL_TRUE );
-		if ( rv == RV_INTR ) {
+		rv = Media_mfile_begin(drivep, contextp, BOOL_TRUE);
+		if (rv == RV_INTR) {
 			return mlog_exit(EXIT_INTERRUPT, rv);
 		}
-		if ( rv == RV_TIMEOUT ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		if (rv == RV_TIMEOUT) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change timeout will be treated as "
 			      "a request to stop using drive: "
-			      "can resume later\n") );
+			      "can resume later\n"));
 			mlog_exit_hint(RV_QUIT);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
-		if ( rv == RV_QUIT ) {
-			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
+		if (rv == RV_QUIT) {
+			mlog(MLOG_VERBOSE | MLOG_WARNING, _(
 			      "media change decline will be treated as "
 			      "a request to stop using drive: "
-			      "can resume later\n") );
+			      "can resume later\n"));
 			mlog_exit_hint(RV_QUIT);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
-		if ( rv == RV_DRIVE ) {
+		if (rv == RV_DRIVE) {
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
-		if ( rv == RV_ERROR ) {
+		if (rv == RV_ERROR) {
 			return mlog_exit(EXIT_ERROR, rv);
 		}
-		if ( rv == RV_CORE ) {
+		if (rv == RV_CORE) {
 			return mlog_exit(EXIT_FAULT, rv);
 		}
-		assert( rv == RV_OK );
-		if ( rv != RV_OK ) {
+		assert(rv == RV_OK);
+		if (rv != RV_OK) {
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
 		/* sync up here with other streams if reasonable
 		 */
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "creating dump session media file %u "
 		      "(media %u, file %u)\n"),
 		      mwhdrp->mh_dumpfileix,
 		      mwhdrp->mh_mediaix,
-		      mwhdrp->mh_mediafileix );
+		      mwhdrp->mh_mediafileix);
 
 		/* initialize the count of marks committed in the media file.
 		 * will be bumped by mark_callback().
@@ -2298,33 +2298,33 @@ content_stream_dump( ix_t strmix )
 
 		/* first dump the inomap
 		 */
-		mlog( MLOG_VERBOSE, _(
-		      "dumping ino map\n") );
-		sc_stat_pds[ strmix ].pds_phase = PDS_INOMAP;
-		rv = inomap_dump( drivep );
-		if ( rv == RV_INTR ) {
+		mlog(MLOG_VERBOSE, _(
+		      "dumping ino map\n"));
+		sc_stat_pds[strmix].pds_phase = PDS_INOMAP;
+		rv = inomap_dump(drivep);
+		if (rv == RV_INTR) {
 			stop_requested = BOOL_TRUE;
 			goto decision_more;
 		}
-		if ( rv == RV_EOM ) {
+		if (rv == RV_EOM) {
 			hit_eom = BOOL_TRUE;
 			goto decision_more;
 		}
-		if ( rv == RV_DRIVE ) {
-			free( ( void * )bstatbufp );
+		if (rv == RV_DRIVE) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
-		if ( rv == RV_ERROR ) {
-			free( ( void * )bstatbufp );
+		if (rv == RV_ERROR) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_ERROR, rv);
 		}
-		if ( rv == RV_CORE ) {
-			free( ( void * )bstatbufp );
+		if (rv == RV_CORE) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
-		assert( rv == RV_OK );
-		if ( rv != RV_OK ) {
-			free( ( void * )bstatbufp );
+		assert(rv == RV_OK);
+		if (rv != RV_OK) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
@@ -2332,35 +2332,35 @@ content_stream_dump( ix_t strmix )
 		 * directories. use the bigstat iterator capability to call
 		 * my dump_dir function for each directory in the bitmap.
 		 */
-		if ( scwhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP ) {
-			sc_stat_pds[ strmix ].pds_dirdone = 0;
-			rv = dump_dirs( strmix,
+		if (scwhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP) {
+			sc_stat_pds[strmix].pds_dirdone = 0;
+			rv = dump_dirs(strmix,
 					bstatbufp,
 					bstatbuflen,
-					inomap_contextp );
-			if ( rv == RV_INTR ) {
+					inomap_contextp);
+			if (rv == RV_INTR) {
 				stop_requested = BOOL_TRUE;
 				goto decision_more;
 			}
-			if ( rv == RV_EOM ) {
+			if (rv == RV_EOM) {
 				hit_eom = BOOL_TRUE;
 				goto decision_more;
 			}
-			if ( rv == RV_DRIVE ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_DRIVE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_NORMAL, rv);
 			}
-			if ( rv == RV_ERROR ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_ERROR) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_ERROR, rv);
 			}
-			if ( rv == RV_CORE ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_CORE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, rv);
 			}
-			assert( rv == RV_OK );
-			if ( rv != RV_OK ) {
-				free( ( void * )bstatbufp );
+			assert(rv == RV_OK);
+			if (rv != RV_OK) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, rv);
 			}
 		}
@@ -2372,55 +2372,55 @@ content_stream_dump( ix_t strmix )
 		 * non-directory file is fully committed to media,
 		 * the starting point for the next media file will be advanced.
 		 */
-		if ( ! all_nondirs_committed ) {
-			mlog( MLOG_VERBOSE, _(
-			      "dumping non-directory files\n") );
-			sc_stat_pds[ strmix ].pds_phase = PDS_NONDIR;
+		if (! all_nondirs_committed) {
+			mlog(MLOG_VERBOSE, _(
+			      "dumping non-directory files\n"));
+			sc_stat_pds[strmix].pds_phase = PDS_NONDIR;
 			rv = RV_OK;
 			inomap_reset_context(inomap_contextp);
-			rval = bigstat_iter( sc_fshandlep,
+			rval = bigstat_iter(sc_fshandlep,
 					     sc_fsfd,
 					     BIGSTAT_ITER_NONDIR,
 					     scwhdrp->cih_startpt.sp_ino,
-					     ( bstat_cbfp_t )dump_file,
-					     ( void * )strmix,
+					     (bstat_cbfp_t)dump_file,
+					     (void *)strmix,
 					     inomap_next_nondir,
 					     inomap_contextp,
-					     ( int * )&rv,
+					     (int *)&rv,
 					     pipeline ?
 					       (bool_t (*)(int))preemptchk : 0,
 					     bstatbufp,
-					     bstatbuflen );
-			if ( rval ) {
-				free( ( void * )bstatbufp );
+					     bstatbuflen);
+			if (rval) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, RV_CORE);
 			}
-			if ( rv == RV_INTR ) {
+			if (rv == RV_INTR) {
 				stop_requested = BOOL_TRUE;
 				goto decision_more;
 			}
-			if ( rv == RV_EOM ) {
+			if (rv == RV_EOM) {
 				hit_eom = BOOL_TRUE;
 				goto decision_more;
 			}
-			if ( rv == RV_EOF ) {
+			if (rv == RV_EOF) {
 				goto decision_more;
 			}
-			if ( rv == RV_DRIVE ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_DRIVE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_NORMAL, rv);
 			}
-			if ( rv == RV_ERROR ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_ERROR) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_ERROR, rv);
 			}
-			if ( rv == RV_CORE ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_CORE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, rv);
 			}
-			assert( rv == RV_OK || rv == RV_NOMORE );
-			if ( rv != RV_OK && rv != RV_NOMORE ) {
-				free( ( void * )bstatbufp );
+			assert(rv == RV_OK || rv == RV_NOMORE);
+			if (rv != RV_OK && rv != RV_NOMORE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, rv);
 			}
 		}
@@ -2435,10 +2435,10 @@ content_stream_dump( ix_t strmix )
 		 * we attempt to end the write stream.
 		 */
 		all_nondirs_sent = BOOL_TRUE;
-		mark_set( drivep,
+		mark_set(drivep,
 			  INO64MAX,
 			  OFF64MAX,
-			  STARTPT_FLAGS_END );
+			  STARTPT_FLAGS_END);
 
 decision_more:
 		/* write a null file hdr, to let restore recognize
@@ -2447,28 +2447,28 @@ decision_more:
 		 * media file in the stream. don't bother if we hit
 		 * EOM.
 		 */
-		if ( ! hit_eom ) {
-			rv = dump_filehdr( drivep,
+		if (! hit_eom) {
+			rv = dump_filehdr(drivep,
 					   contextp,
 					   0,
 					   0,
 					   all_nondirs_sent
 					   ?
-					   ( FILEHDR_FLAGS_NULL
+					   (FILEHDR_FLAGS_NULL
 					     |
-					     FILEHDR_FLAGS_END )
+					     FILEHDR_FLAGS_END)
 					   :
-					   FILEHDR_FLAGS_NULL );
-			if ( rv == RV_DRIVE ) {
-				free( ( void * )bstatbufp );
+					   FILEHDR_FLAGS_NULL);
+			if (rv == RV_DRIVE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_NORMAL, rv);
 			}
-			if ( rv == RV_CORE ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_CORE) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_FAULT, rv);
 			}
-			if ( rv == RV_ERROR ) {
-				free( ( void * )bstatbufp );
+			if (rv == RV_ERROR) {
+				free((void *)bstatbufp);
 				return mlog_exit(EXIT_ERROR, rv);
 			}
 
@@ -2476,14 +2476,14 @@ decision_more:
 			 * it. mark callback will adjust start pt before this
 			 * call returns if the null file header made it.
 			 */
-			mark_set( drivep,
+			mark_set(drivep,
 				  INO64MAX,
 				  OFF64MAX,
 				  all_nondirs_sent
 				  ?
 				  STARTPT_FLAGS_NULL | STARTPT_FLAGS_END
 				  :
-				  STARTPT_FLAGS_NULL );
+				  STARTPT_FLAGS_NULL);
 		}
 
 		/* tell the Media abstraction to end the media file.
@@ -2492,38 +2492,38 @@ decision_more:
 		 * will invoke drive end_write, which will flush
 		 * all pending marks.
 		 */
-		mlog( MLOG_VERBOSE, _(
-		      "ending media file\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "ending media file\n"));
 		ncommitted = 0;
-		rv = Media_mfile_end( drivep,
+		rv = Media_mfile_end(drivep,
 				      contextp,
 				      mwhdrp,
 				      &ncommitted,
-				      hit_eom );
-		if ( rv == RV_DRIVE ) {
-			free( ( void * )bstatbufp );
+				      hit_eom);
+		if (rv == RV_DRIVE) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_NORMAL, rv);
 		}
-		if ( rv == RV_CORE ) {
-			free( ( void * )bstatbufp );
+		if (rv == RV_CORE) {
+			free((void *)bstatbufp);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "media file size %lld bytes\n"),
-		      ncommitted );
+		      ncommitted);
 
 		/* if at least one mark committed, we know all of
 		 * the inomap and dirdump was committed.
 		 */
-		all_dirs_committed = ( contextp->cc_markscommitted > 0 );
+		all_dirs_committed = (contextp->cc_markscommitted > 0);
 
 		/* at this point we can check the new start point
 		 * to determine if all nondirs have been committed.
 		 * if this flag was already set, then this is a
 		 * inomap and dirdump-only media file.
 		 */
-		if ( scwhdrp->cih_startpt.sp_flags & STARTPT_FLAGS_END ) {
-			if ( all_nondirs_committed ) {
+		if (scwhdrp->cih_startpt.sp_flags & STARTPT_FLAGS_END) {
+			if (all_nondirs_committed) {
 				empty_mediafile = BOOL_TRUE;
 			}
 			all_nondirs_committed = BOOL_TRUE;
@@ -2537,51 +2537,51 @@ decision_more:
 
 		/* tell the inventory about the media file
 		 */
-		if ( inv_stmt != INV_TOKEN_NULL ) {
+		if (inv_stmt != INV_TOKEN_NULL) {
 			bool_t ok;
 
-			if ( ! all_dirs_committed ) {
-				mlog( MLOG_DEBUG,
+			if (! all_dirs_committed) {
+				mlog(MLOG_DEBUG,
 				      "giving inventory "
-				      "partial dirdump media file\n" );
-			} else if ( done && empty_mediafile ) {
-				mlog( MLOG_DEBUG,
+				      "partial dirdump media file\n");
+			} else if (done && empty_mediafile) {
+				mlog(MLOG_DEBUG,
 				      "giving inventory "
 				      "empty last media file: "
 				      "%llu:%lld\n",
 				       startino,
-				       startoffset );
-			} else if ( empty_mediafile ) {
-				mlog( MLOG_DEBUG,
+				       startoffset);
+			} else if (empty_mediafile) {
+				mlog(MLOG_DEBUG,
 				      "giving inventory "
 				      "empty media file: "
 				      "%llu:%lld\n",
 				       startino,
-				       startoffset );
-			} else if ( done ) {
-				mlog( MLOG_DEBUG,
+				       startoffset);
+			} else if (done) {
+				mlog(MLOG_DEBUG,
 				      "giving inventory "
 				      "last media file: "
 				      "%llu:%lld\n",
 				       startino,
-				       startoffset );
+				       startoffset);
 			} else {
-				mlog( MLOG_DEBUG,
+				mlog(MLOG_DEBUG,
 				      "giving inventory "
 				      "media file: "
 				      "%llu:%lld - %llu:%lld\n",
 				       startino,
 				       startoffset,
 				       scwhdrp->cih_startpt.sp_ino,
-				       scwhdrp->cih_startpt.sp_offset );
+				       scwhdrp->cih_startpt.sp_offset);
 			}
 
 			/* already thread-safe, don't need to lock
 			 */
-			ok = inv_put_mediafile( inv_stmt,
+			ok = inv_put_mediafile(inv_stmt,
 						&mwhdrp->mh_mediaid,
 						mwhdrp->mh_medialabel,
-					( uint )mwhdrp->mh_mediafileix,
+					(uint)mwhdrp->mh_mediafileix,
 						startino,
 						startoffset,
 						scwhdrp->cih_startpt.sp_ino,
@@ -2590,13 +2590,13 @@ decision_more:
 					        all_dirs_committed
 						&&
 						! empty_mediafile,
-						BOOL_FALSE );
-			if ( ! ok ) {
-				mlog( MLOG_NORMAL, _(
-				      "inventory media file put failed\n") );
+						BOOL_FALSE);
+			if (! ok) {
+				mlog(MLOG_NORMAL, _(
+				      "inventory media file put failed\n"));
 			}
 		}
-		if ( done ) {
+		if (done) {
 			contextp->cc_completepr = BOOL_TRUE;
 			    /* so inv_end_stream and main will know
 			     */
@@ -2604,58 +2604,58 @@ decision_more:
 
 		/* don't go back for more if done or stop was requested
 		 */
-		if ( done || stop_requested ) {
+		if (done || stop_requested) {
 			break;
 		}
 	} /* end main dump loop */
 
 	/* check in
 	 */
-	lock( );
+	lock();
 	sc_thrdsdonecnt++;
-	unlock( );
+	unlock();
 
 	/* dump the session inventory and terminator here, if the drive
 	 * supports multiple media files. must wait until all
 	 * streams have completed or given up, so all media files
 	 * from all streams have been registered.
 	 */
-	if ( drivep->d_capabilities & DRIVE_CAP_FILES ) {
-		if ( stream_cnt( ) > 1 ) {
-			mlog( MLOG_VERBOSE, _(
+	if (drivep->d_capabilities & DRIVE_CAP_FILES) {
+		if (stream_cnt() > 1) {
+			mlog(MLOG_VERBOSE, _(
 			      "waiting for synchronized "
-			      "session inventory dump\n") );
-			sc_stat_pds[ strmix ].pds_phase = PDS_INVSYNC;
+			      "session inventory dump\n"));
+			sc_stat_pds[strmix].pds_phase = PDS_INVSYNC;
 		}
 
 		/* first be sure all threads have begun
 		*/
-		while ( sc_thrdsarrivedcnt < drivecnt ) {
-			sleep( 1 );
+		while (sc_thrdsarrivedcnt < drivecnt) {
+			sleep(1);
 		}
 		/* now wait for survivors to checkin
 		*/
-		while ( sc_thrdsdonecnt < stream_cnt( )) {
-			sleep( 1 );
+		while (sc_thrdsdonecnt < stream_cnt()) {
+			sleep(1);
 		}
 		/* proceeed
 		 */
-		sc_stat_pds[ strmix ].pds_phase = PDS_INVDUMP;
-		if ( dump_session_inv( drivep, contextp, mwhdrp, scwhdrp )) {
-			sc_stat_pds[ strmix ].pds_phase = PDS_TERMDUMP;
-			dump_terminator( drivep, contextp, mwhdrp );
+		sc_stat_pds[strmix].pds_phase = PDS_INVDUMP;
+		if (dump_session_inv(drivep, contextp, mwhdrp, scwhdrp)) {
+			sc_stat_pds[strmix].pds_phase = PDS_TERMDUMP;
+			dump_terminator(drivep, contextp, mwhdrp);
 		}
 	}
 
-	sc_stat_pds[ strmix ].pds_phase = PDS_NULL;
+	sc_stat_pds[strmix].pds_phase = PDS_NULL;
 
-	free( ( void * )bstatbufp );
+	free((void *)bstatbufp);
 
-	elapsed = time( 0 ) - sc_stat_starttime;
+	elapsed = time(0) - sc_stat_starttime;
 
-	mlog( MLOG_TRACE, _(
+	mlog(MLOG_TRACE, _(
 	      "ending stream: %ld seconds elapsed\n"),
-	      elapsed );
+	      elapsed);
 
 	return mlog_exit(EXIT_NORMAL, rv);
 }
@@ -2666,53 +2666,53 @@ decision_more:
  * dump is not complete.
  */
 bool_t
-content_complete( void )
+content_complete(void)
 {
 	time_t elapsed;
 	bool_t completepr;
 	int i;
 
-	completepr = check_complete_flags( );
+	completepr = check_complete_flags();
 
-	elapsed = time( 0 ) - sc_stat_starttime;
+	elapsed = time(0) - sc_stat_starttime;
 
-	mlog( MLOG_VERBOSE, _(
+	mlog(MLOG_VERBOSE, _(
 	      "dump size (non-dir files) : %llu bytes\n"),
-	      sc_stat_datadone );
+	      sc_stat_datadone);
 
-	if ( completepr ) {
-		if( sc_savequotas ) {
+	if (completepr) {
+		if(sc_savequotas) {
 			for(i = 0; i < (sizeof(quotas) / sizeof(quotas[0])); i++) {
-				if( quotas[i].savequotas && unlink( quotas[i].quotapath ) < 0 ) {
-					mlog( MLOG_ERROR, _(
+				if(quotas[i].savequotas && unlink(quotas[i].quotapath) < 0) {
+					mlog(MLOG_ERROR, _(
 					"unable to remove %s: %s\n"),
 					quotas[i].quotapath,
-					strerror ( errno ));
+					strerror (errno));
 				}
 			}
 		}
 
-		mlog( MLOG_VERBOSE, _(
+		mlog(MLOG_VERBOSE, _(
 		      "dump complete"
 		      ": %ld seconds elapsed"
 		      "\n"),
-		      elapsed );
+		      elapsed);
 	} else {
-		if ( sc_inv_updatepr ) {
-			mlog( MLOG_VERBOSE | MLOG_NOTE, _(
+		if (sc_inv_updatepr) {
+			mlog(MLOG_VERBOSE | MLOG_NOTE, _(
 			      "dump interrupted"
 			      ": %ld seconds elapsed"
 			      ": may resume later using -%c option"
 			      "\n"),
 			      elapsed,
-			      GETOPT_RESUME );
+			      GETOPT_RESUME);
 			mlog_exit_hint(RV_INTR);
 		} else {
-			mlog( MLOG_VERBOSE | MLOG_NOTE, _(
+			mlog(MLOG_VERBOSE | MLOG_NOTE, _(
 			      "dump interrupted"
 			      ": %ld seconds elapsed"
 			      "\n"),
-			      elapsed );
+			      elapsed);
 			mlog_exit_hint(RV_INTR);
 		}
 	}
@@ -2728,15 +2728,15 @@ content_complete( void )
 #define DLOG_TIMEOUT_MEDIA	3600
 
 #define CHOICESTRSZ	10
-typedef struct { ix_t thrdix; char choicestr[ CHOICESTRSZ ]; } cttm_t;
+typedef struct { ix_t thrdix; char choicestr[CHOICESTRSZ]; } cttm_t;
 
 char *
-content_mediachange_query( void )
+content_mediachange_query(void)
 {
-	cttm_t choicetothrdmap[ STREAM_SIMMAX ];
-	char *querystr[ QUERYMAX ];
+	cttm_t choicetothrdmap[STREAM_SIMMAX];
+	char *querystr[QUERYMAX];
 	size_t querycnt;
-	char *choicestr[ CHOICEMAX ];
+	char *choicestr[CHOICEMAX];
 	size_t choicecnt;
 	size_t maxdrvchoiceix;
 	size_t nochangeix;
@@ -2744,25 +2744,25 @@ content_mediachange_query( void )
 	ix_t thrdix;
 
 	querycnt = 0;
-	querystr[ querycnt++ ] = "select a drive to acknowledge media change\n";
+	querystr[querycnt++ ] = "select a drive to acknowledge media change\n";
 	choicecnt = 0;
 	maxdrvchoiceix = 0;
-	for ( thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++ ) {
-		if ( sc_mcflag[ thrdix ] ) {
-			choicetothrdmap[ choicecnt ].thrdix = thrdix;
-			sprintf( choicetothrdmap[ choicecnt ].choicestr,
+	for (thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++) {
+		if (sc_mcflag[thrdix]) {
+			choicetothrdmap[choicecnt].thrdix = thrdix;
+			sprintf(choicetothrdmap[choicecnt].choicestr,
 				 "drive %u",
-				 (unsigned int)thrdix );
-			choicestr[ choicecnt ] =
-					choicetothrdmap[ choicecnt ].choicestr;
+				 (unsigned int)thrdix);
+			choicestr[choicecnt] =
+					choicetothrdmap[choicecnt].choicestr;
 			maxdrvchoiceix = choicecnt;
 			choicecnt++;
 		}
 	}
 	nochangeix = choicecnt;
-	choicestr[ choicecnt++ ] = "continue";
-	assert( choicecnt <= CHOICEMAX );
-	responseix = dlog_multi_query( querystr,
+	choicestr[choicecnt++ ] = "continue";
+	assert(choicecnt <= CHOICEMAX);
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -2775,40 +2775,40 @@ content_mediachange_query( void )
 				       nochangeix, /* sigint ix */
 				       nochangeix, /* sighup ix */
 				       nochangeix);/* sigquit ix */
-	if ( responseix <= maxdrvchoiceix ) {
-		clr_mcflag( choicetothrdmap[ responseix ].thrdix );
+	if (responseix <= maxdrvchoiceix) {
+		clr_mcflag(choicetothrdmap[responseix].thrdix);
 		return "media change acknowledged\n";
 	}
-	assert( responseix == nochangeix );
+	assert(responseix == nochangeix);
 	return "continuing\n";
 }
 
 
 static void
-update_cc_Media_useterminatorpr( drive_t *drivep, context_t *contextp )
+update_cc_Media_useterminatorpr(drive_t *drivep, context_t *contextp)
 {
 	int dcaps = drivep->d_capabilities;
 
 	contextp->cc_Media_useterminatorpr = BOOL_TRUE;
-	if ( ! ( dcaps & DRIVE_CAP_FILES )) {
+	if (! (dcaps & DRIVE_CAP_FILES)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if ( ! ( dcaps & DRIVE_CAP_OVERWRITE )) {
+	if (! (dcaps & DRIVE_CAP_OVERWRITE)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if ( ! ( dcaps & DRIVE_CAP_BSF )) {
+	if (! (dcaps & DRIVE_CAP_BSF)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
-	if ( ! ( dcaps & DRIVE_CAP_APPEND )) {
+	if (! (dcaps & DRIVE_CAP_APPEND)) {
 		contextp->cc_Media_useterminatorpr = BOOL_FALSE;
 	}
 }
 
 static rv_t
-dump_dirs( ix_t strmix,
+dump_dirs(ix_t strmix,
 	   xfs_bstat_t *bstatbufp,
 	   size_t bstatbuflen,
-	   void *inomap_contextp )
+	   void *inomap_contextp)
 {
 	xfs_ino_t lastino;
 	size_t bulkstatcallcnt;
@@ -2819,30 +2819,30 @@ dump_dirs( ix_t strmix,
 	/* begin iteration at ino zero
 	 */
 	lastino = 0;
-	for ( bulkstatcallcnt = 0 ; ; bulkstatcallcnt++ ) {
+	for (bulkstatcallcnt = 0 ; ; bulkstatcallcnt++) {
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 		__s32 buflenout;
 		int rval;
 
-		if ( bulkstatcallcnt == 0 ) {
-			mlog( MLOG_VERBOSE, _(
-			      "dumping directories\n") );
+		if (bulkstatcallcnt == 0) {
+			mlog(MLOG_VERBOSE, _(
+			      "dumping directories\n"));
 		}
-		sc_stat_pds[ strmix ].pds_phase = PDS_DIRDUMP;
+		sc_stat_pds[strmix].pds_phase = PDS_DIRDUMP;
 
 		/* check for interruption
 		 */
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
 		/* get a bunch of bulkstats
 		 */
-		mlog( MLOG_NITTY,
+		mlog(MLOG_NITTY,
 		      "dump_dirs SGI_FS_BULKSTAT %u buf len %u\n",
 		      bulkstatcallcnt,
-		      bstatbuflen );
+		      bstatbuflen);
 
 		bulkreq.lastip = (__u64 *)&lastino;
 		bulkreq.icount = bstatbuflen;
@@ -2851,73 +2851,73 @@ dump_dirs( ix_t strmix,
 
 		rval = ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq);
 
-		if ( rval ) {
-			mlog( MLOG_NORMAL, _(
+		if (rval) {
+			mlog(MLOG_NORMAL, _(
 			      "SGI_FS_BULKSTAT failed: "
 			      "%s (%d)\n"),
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			return RV_ERROR;
 		}
-		mlog( MLOG_NITTY,
+		mlog(MLOG_NITTY,
 		      "dump_dirs SGI_FS_BULKSTAT returns %d entries\n",
-		      buflenout );
+		      buflenout);
 
 		/* check if done
 		 */
-		if ( buflenout == 0 ) {
+		if (buflenout == 0) {
 			return RV_OK;
 		}
 
 		/* step through each node, dumping if
 		 * appropriate
 		 */
-		for ( p = bstatbufp, endp = bstatbufp + buflenout
+		for (p = bstatbufp, endp = bstatbufp + buflenout
 		      ;
 		      p < endp
 		      ;
-		      p++ ) {
+		      p++) {
 			rv_t rv;
 
-			if ( p->bs_ino == 0 )
+			if (p->bs_ino == 0)
 				continue;
 
-			if ( !p->bs_nlink || !p->bs_mode ) {
+			if (!p->bs_nlink || !p->bs_mode) {
 				/* inode being modified, get synced data */
-				mlog( MLOG_NITTY,
+				mlog(MLOG_NITTY,
 				      "ino %llu needs second bulkstat\n",
-				      p->bs_ino );
+				      p->bs_ino);
 
-				if ( bigstat_one( sc_fsfd, p->bs_ino, p ) < 0 ) {
-					mlog( MLOG_WARNING,  _(
+				if (bigstat_one(sc_fsfd, p->bs_ino, p) < 0) {
+					mlog(MLOG_WARNING,  _(
 					      "failed to get bulkstat information for inode %llu\n"),
-					      p->bs_ino );
+					      p->bs_ino);
 					continue;
 				}
-				if ( !p->bs_nlink || !p->bs_mode || !p->bs_ino ) {
-					mlog( MLOG_TRACE,
+				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
+					mlog(MLOG_TRACE,
 					      "failed to get valid bulkstat information for inode %llu\n",
-					      p->bs_ino );
+					      p->bs_ino);
 					continue;
 				}
 			}
-			if ( ( p->bs_mode & S_IFMT ) != S_IFDIR ) {
+			if ((p->bs_mode & S_IFMT) != S_IFDIR) {
 				continue;
 			}
 
-			rv = dump_dir( strmix, sc_fshandlep, sc_fsfd, p );
-			if ( rv != RV_OK ) {
+			rv = dump_dir(strmix, sc_fshandlep, sc_fsfd, p);
+			if (rv != RV_OK) {
 				return rv;
 			}
 		}
 
 		lastino = inomap_next_dir(inomap_contextp, lastino);
 		if (lastino == INO64MAX) {
-			mlog( MLOG_DEBUG, "bulkstat seeked to EOS\n" );
+			mlog(MLOG_DEBUG, "bulkstat seeked to EOS\n");
 			return 0;
 		}
 
-		mlog( MLOG_DEBUG, "bulkstat seeked to %llu\n", lastino );
+		mlog(MLOG_DEBUG, "bulkstat seeked to %llu\n", lastino);
 
 		lastino = (lastino > 0) ? lastino - 1 : 0;
 	}
@@ -2925,17 +2925,17 @@ dump_dirs( ix_t strmix,
 }
 
 static rv_t
-dump_dir( ix_t strmix,
+dump_dir(ix_t strmix,
 	  jdm_fshandle_t *fshandlep,
 	  int fsfd,
-	  xfs_bstat_t *statp )
+	  xfs_bstat_t *statp)
 {
-	context_t *contextp = &sc_contextp[ strmix ];
-	drive_t *drivep = drivepp[ strmix ];
+	context_t *contextp = &sc_contextp[strmix];
+	drive_t *drivep = drivepp[strmix];
 	void *inomap_contextp = contextp->cc_inomap_contextp;
 	int state;
 	int fd;
-	struct dirent *gdp = ( struct dirent *)contextp->cc_getdentsbufp;
+	struct dirent *gdp = (struct dirent *)contextp->cc_getdentsbufp;
 	size_t gdsz = contextp->cc_getdentsbufsz;
 	int gdcnt;
 	gen_t gen;
@@ -2943,104 +2943,104 @@ dump_dir( ix_t strmix,
 
 	/* no way this can be non-dir, but check anyway
 	 */
-	assert( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
-	if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
+	assert((statp->bs_mode & S_IFMT) == S_IFDIR);
+	if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 		return RV_OK;
 	}
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink < 1 ) {
+	if (statp->bs_nlink < 1) {
 		return RV_OK;
 	}
 
 	/* see what the inomap says about this ino
 	 */
-	state = inomap_get_state( inomap_contextp, statp->bs_ino );
+	state = inomap_get_state(inomap_contextp, statp->bs_ino);
 
 	/* skip if not in inomap
 	 */
-	if ( state == MAP_INO_UNUSED
+	if (state == MAP_INO_UNUSED
 	     ||
 	     state == MAP_DIR_NOCHNG
 	     ||
-	     state == MAP_NDR_NOCHNG ) {
-		if ( state == MAP_NDR_NOCHNG ) {
-			mlog( MLOG_DEBUG,
+	     state == MAP_NDR_NOCHNG) {
+		if (state == MAP_NDR_NOCHNG) {
+			mlog(MLOG_DEBUG,
 			      "inomap inconsistency ino %llu: "
 			      "map says is non-dir but is dir: skipping\n",
-			      statp->bs_ino );
+			      statp->bs_ino);
 		}
 		return RV_OK;
 	}
 
 	/* note if map says a non-dir
 	 */
-	if ( state == MAP_NDR_CHANGE ) {
-		mlog( MLOG_DEBUG,
+	if (state == MAP_NDR_CHANGE) {
+		mlog(MLOG_DEBUG,
 		      "inomap inconsistency ino %llu: "
 		      "map says non-dir but is dir: skipping\n",
-		      statp->bs_ino );
+		      statp->bs_ino);
 		return RV_OK;
 	}
 
 	/* bump the stats now. a bit early, but fewer lines of code
 	 */
-	sc_stat_pds[ strmix ].pds_dirdone++;
+	sc_stat_pds[strmix].pds_dirdone++;
 
         /* if bulkstat ino# occupied more than 32 bits and
          * linux ino# for getdents is 32 bits then
          * warn and skip.
          */
-	if ( statp->bs_ino > ( xfs_ino_t )INOMAX ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (statp->bs_ino > (xfs_ino_t)INOMAX) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "unable to dump directory: ino %llu too large\n"),
-		      statp->bs_ino );
+		      statp->bs_ino);
 		return RV_OK; /* continue anyway */
 	}
 
-	mlog( MLOG_TRACE,
+	mlog(MLOG_TRACE,
 	      "dumping directory ino %llu\n",
-	      statp->bs_ino );
+	      statp->bs_ino);
 
 	/* open the directory named by statp
 	 */
-	fd = jdm_open( fshandlep, statp, O_RDONLY );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	fd = jdm_open(fshandlep, statp, O_RDONLY);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "unable to open directory: ino %llu: %s\n"),
-		      statp->bs_ino, strerror( errno ) );
+		      statp->bs_ino, strerror(errno));
 		return RV_OK; /* continue anyway */
 	}
 
 	/* dump the file header.
 	 */
-	rv = dump_filehdr( drivep, contextp, statp, 0, 0 );
-	if ( rv != RV_OK ) {
-		close( fd );
+	rv = dump_filehdr(drivep, contextp, statp, 0, 0);
+	if (rv != RV_OK) {
+		close(fd);
 		return rv;
 	}
 
 	/* dump dirents - lots of buffering done here, to achieve OS-
 	 * independence. if proves to be to much overhead, can streamline.
 	 */
-	for ( gdcnt = 1, rv = RV_OK ; rv == RV_OK ; gdcnt++ ) {
+	for (gdcnt = 1, rv = RV_OK ; rv == RV_OK ; gdcnt++) {
 		struct dirent *p;
 		int nread;
 		register size_t reclen;
 
-		nread = getdents_wrap( fd, (char *)gdp, gdsz );
+		nread = getdents_wrap(fd, (char *)gdp, gdsz);
 
 		/* negative count indicates something very bad happened;
 		 * try to gracefully end this dir.
 		 */
-		if ( nread < 0 ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING, _(
+		if (nread < 0) {
+			mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      "unable to read dirents (%d) for "
 			      "directory ino %llu: %s\n"),
 			      gdcnt,
 			      statp->bs_ino,
-			      strerror( errno ));
+			      strerror(errno));
 			/* !!! curtis looked at this, and pointed out that
 			 * we could take some recovery action here. if the
 			 * errno is appropriate, lseek64 to the value of
@@ -3052,93 +3052,93 @@ dump_dir( ix_t strmix,
 
 		/* no more directory entries: break;
 		 */
-		if ( nread == 0 ) {
+		if (nread == 0) {
 			break;
 		}
 
 		/* translate and dump each entry: skip "." and ".."
 		 * and null entries.
 		 */
-		for ( p = gdp,
-		      reclen = ( size_t )p->d_reclen
+		for (p = gdp,
+		      reclen = (size_t)p->d_reclen
 		      ;
 		      nread > 0
 		      ;
-		      nread -= ( int )reclen,
-		      assert( nread >= 0 ),
-		      p = ( struct dirent * )( ( char * )p + reclen ),
-		      reclen = ( size_t )p->d_reclen ) {
+		      nread -= (int)reclen,
+		      assert(nread >= 0),
+		      p = (struct dirent *)((char *)p + reclen),
+		      reclen = (size_t)p->d_reclen) {
 			xfs_ino_t ino;
-			register size_t namelen = strlen( p->d_name );
+			register size_t namelen = strlen(p->d_name);
 #ifdef DEBUG
-			register size_t nameszmax = ( size_t )reclen
+			register size_t nameszmax = (size_t)reclen
 						    -
-						    offsetofmember( struct dirent,
-								    d_name );
+						    offsetofmember(struct dirent,
+								    d_name);
 
 			/* getdents(2) guarantees that the string will
 			 * be null-terminated, but the record may have
 			 * padding after the null-termination.
 			 */
-			assert( namelen < nameszmax );
+			assert(namelen < nameszmax);
 #endif
 
 			/* skip "." and ".."
 			 */
-			if ( *( p->d_name + 0 ) == '.'
+			if (*(p->d_name + 0) == '.'
 			     &&
-			     ( *( p->d_name + 1 ) == 0
+			     (*(p->d_name + 1) == 0
 			       ||
-			       ( *( p->d_name + 1 ) == '.'
+			       (*(p->d_name + 1) == '.'
 				 &&
-				 *( p->d_name + 2 ) == 0 ))) {
+				 *(p->d_name + 2) == 0))) {
 				continue;
 			}
 
 			ino = (xfs_ino_t)p->d_ino;
 
-			if ( ino == 0 ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (ino == 0) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "encountered 0 ino (%s) in "
 				      "directory ino %llu: NOT dumping\n"),
 				      p->d_name,
-				      statp->bs_ino );
+				      statp->bs_ino);
 				continue;
 			}
 
 			/* lookup the gen number in the ino-to-gen map.
 			 * if it's not there, we have to get it the slow way.
 			 */
-			if ( inomap_get_gen( NULL, p->d_ino, &gen) ) {
+			if (inomap_get_gen(NULL, p->d_ino, &gen)) {
 				xfs_bstat_t statbuf;
 				int scrval;
 
-				scrval = bigstat_one( fsfd,
+				scrval = bigstat_one(fsfd,
 						      p->d_ino,
-						      &statbuf );
-				if ( scrval ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+						      &statbuf);
+				if (scrval) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "could not stat "
 					      "dirent %s ino %llu: %s: "
 					      "using null generation count "
 					      "in directory entry\n"),
 					      p->d_name,
-					      ( xfs_ino_t )p->d_ino,
-					      strerror( errno ));
+					      (xfs_ino_t)p->d_ino,
+					      strerror(errno));
 					gen = 0;
 				} else {
 					gen = statbuf.bs_gen;
 				}
 			}
 
-			rv = dump_dirent( drivep,
+			rv = dump_dirent(drivep,
 					  contextp,
 					  statp,
 					  ino,
 					  gen,
 					  p->d_name,
-					  namelen );
-			if ( rv != RV_OK ) {
+					  namelen);
+			if (rv != RV_OK) {
 				break;
 			}
 		}
@@ -3146,19 +3146,19 @@ dump_dir( ix_t strmix,
 
 	/* write a null dirent hdr, unless trouble encountered in the loop
 	 */
-	if ( rv == RV_OK ) {
-		rv = dump_dirent( drivep, contextp, statp, 0, 0, 0, 0 );
+	if (rv == RV_OK) {
+		rv = dump_dirent(drivep, contextp, statp, 0, 0, 0, 0);
 	}
 
-	if ( rv == RV_OK
+	if (rv == RV_OK
 	     &&
 	     sc_dumpextattrpr
 	     &&
-	     ( statp->bs_xflags & XFS_XFLAG_HASATTR )) {
-		rv = dump_extattrs( drivep, contextp, fshandlep, statp);
+	     (statp->bs_xflags & XFS_XFLAG_HASATTR)) {
+		rv = dump_extattrs(drivep, contextp, fshandlep, statp);
 	}
 
-	close( fd );
+	close(fd);
 
 	/* if an error occurred, just return the error
 	 */
@@ -3166,7 +3166,7 @@ dump_dir( ix_t strmix,
 }
 
 static rv_t
-dump_extattrs( drive_t *drivep,
+dump_extattrs(drive_t *drivep,
 	       context_t *contextp,
 	       jdm_fshandle_t *fshandlep,
 	       xfs_bstat_t *statp)
@@ -3179,39 +3179,39 @@ dump_extattrs( drive_t *drivep,
 
 	/* dump a file header specially marked as heading extended attributes
 	 */
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "dumping %s ino %llu extended attributes filehdr\n",
 	      FILETYPE(statp),
-	      statp->bs_ino );
+	      statp->bs_ino);
 
-	rv = dump_filehdr( drivep, contextp, statp, 0, FILEHDR_FLAGS_EXTATTR );
-	if ( rv != RV_OK ) {
+	rv = dump_filehdr(drivep, contextp, statp, 0, FILEHDR_FLAGS_EXTATTR);
+	if (rv != RV_OK) {
 		return rv;
 	}
 
 	/* loop three times: once for the non-root, once for root, and
 	 * again for the secure attributes.
 	 */
-	for ( pass = 0; pass < 3; pass++ ) {
+	for (pass = 0; pass < 3; pass++) {
 		bool_t more;
 
-		if ( pass == 0 )
+		if (pass == 0)
 			flag = 0;
-		else if ( pass == 1)
+		else if (pass == 1)
 			flag = ATTR_ROOT;
 		else
 			flag = ATTR_SECURE;
 
-		mlog( MLOG_NITTY,
+		mlog(MLOG_NITTY,
 		      "dumping %s extended attributes for %s ino %llu\n",
 		      EXTATTR_NAMESPACE(flag),
 		      FILETYPE(statp),
-		      statp->bs_ino );
+		      statp->bs_ino);
 
 		/* loop dumping the extended attributes from the namespace
 		 * selected by the outer loop
 		 */
-		memset( &cursor, 0, sizeof( cursor ));
+		memset(&cursor, 0, sizeof(cursor));
 		more = BOOL_FALSE;
 		do {
 			attrlist_t *listp;
@@ -3219,62 +3219,62 @@ dump_extattrs( drive_t *drivep,
 
 			rval = jdm_attr_list(fshandlep, statp,
 				contextp->cc_extattrlistbufp,
-				( int )contextp->cc_extattrlistbufsz,
-				flag, &cursor );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				(int)contextp->cc_extattrlistbufsz,
+				flag, &cursor);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "could not get list of %s attributes for "
 				      "%s ino %llu: %s (%d)\n"),
 				      EXTATTR_NAMESPACE(flag),
 				      FILETYPE(statp),
 				      statp->bs_ino,
-				      strerror( errno ),
-				      errno );
+				      strerror(errno),
+				      errno);
 				break;
 			}
 
-			listp = ( attrlist_t * )contextp->cc_extattrlistbufp;
+			listp = (attrlist_t *)contextp->cc_extattrlistbufp;
 			more = listp->al_more;
 
 			abort = BOOL_FALSE;
-			rv = dump_extattr_list( drivep,
+			rv = dump_extattr_list(drivep,
 						contextp,
 						fshandlep,
 						statp,
 						listp,
 						flag,
-						&abort );
-			if ( rv != RV_OK ) {
+						&abort);
+			if (rv != RV_OK) {
 				return rv;
 			}
-		} while ( more && !abort );
+		} while (more && !abort);
 	}
 
 	/* finally, dump a dummy extattr hdr so restore will know
 	 * we're done.
 	 */
-	/*DBG*/mlog( MLOG_NITTY,
-		     "dumping NULL extattrhdr\n" );
-	rv = dump_extattrhdr( drivep,
+	/*DBG*/mlog(MLOG_NITTY,
+		     "dumping NULL extattrhdr\n");
+	rv = dump_extattrhdr(drivep,
 			      contextp,
 			      statp,
 			      EXTATTRHDR_SZ,
 			      0,
 			      EXTATTRHDR_FLAGS_NULL,
-			      0 );
+			      0);
 	return rv;
 }
 
 static rv_t
-dump_extattr_list( drive_t *drivep,
+dump_extattr_list(drive_t *drivep,
 		   context_t *contextp,
 		   jdm_fshandle_t *fshandlep,
 		   xfs_bstat_t *statp,
 		   attrlist_t *listp,
 		   int flag,
-		   bool_t *abortprp )
+		   bool_t *abortprp)
 {
-	size_t listlen = ( size_t )listp->al_count;
+	size_t listlen = (size_t)listp->al_count;
 	ix_t nameix;
 	char *dumpbufp;
 	char *endp;
@@ -3287,7 +3287,7 @@ dump_extattr_list( drive_t *drivep,
 
 	/* sanity checks
 	 */
-	assert( listp->al_count >= 0 );
+	assert(listp->al_count >= 0);
 
 	/* fill up a retrieve array and build a dump buffer;
 	 * can run out of entries in the name list, space in the
@@ -3295,7 +3295,7 @@ dump_extattr_list( drive_t *drivep,
 	 */
 	dumpbufp = contextp->cc_extattrdumpbufp;
 	endp = dumpbufp;
-	for ( nameix = 0 ; nameix < listlen ; ) {
+	for (nameix = 0 ; nameix < listlen ;) {
 		ix_t rtrvix;
 		size_t rtrvcnt;
 
@@ -3305,8 +3305,8 @@ dump_extattr_list( drive_t *drivep,
 			char *valuep;
 			attr_multiop_t *opp;
 
-			entp = ATTR_ENTRY( listp, nameix );
-			opp = &contextp->cc_extattrrtrvarrayp[ rtrvix ];
+			entp = ATTR_ENTRY(listp, nameix);
+			opp = &contextp->cc_extattrrtrvarrayp[rtrvix];
 
 			/* Offer the HSM a chance to avoid dumping certain
 			 * attributes.
@@ -3319,7 +3319,7 @@ dump_extattr_list( drive_t *drivep,
 				    contextp->cc_hsm_f_ctxtp, entp->a_name,
 				    entp->a_valuelen, flag,
 				    &skip_entry)) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      		    "HSM could not filter %s "
 					    "attribute %s for %s ino %llu\n"),
 					    EXTATTR_NAMESPACE(flag),
@@ -3335,21 +3335,21 @@ dump_extattr_list( drive_t *drivep,
 				}
 			}
 
-			dumpbufp = dump_extattr_buildrecord( statp,
+			dumpbufp = dump_extattr_buildrecord(statp,
 							     dumpbufp,
 							     dumpbufendp,
 							     entp->a_name,
 							     entp->a_valuelen,
 							     flag,
-							     &valuep );
-			if ( dumpbufp > dumpbufendp ) {
+							     &valuep);
+			if (dumpbufp > dumpbufendp) {
 				break;		/* won't fit in buffer */
 			}
 			if (valuep != NULL) {	/* if added to dump buffer */
 				endp = dumpbufp;
 				opp->am_attrname = entp->a_name;
 				opp->am_attrvalue = valuep;
-				opp->am_length = ( int )entp->a_valuelen;
+				opp->am_length = (int)entp->a_valuelen;
 				opp->am_flags = flag;
 				opp->am_error = 0;
 				opp->am_opcode = ATTR_OP_GET;
@@ -3365,29 +3365,29 @@ dump_extattr_list( drive_t *drivep,
 
 		rtrvcnt = rtrvix;
 		if (rtrvcnt > 0) {
-			rval = jdm_attr_multi( fshandlep, statp,
+			rval = jdm_attr_multi(fshandlep, statp,
 					(void *)contextp->cc_extattrrtrvarrayp,
-					( int )rtrvcnt,
-					0 );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					(int)rtrvcnt,
+					0);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "could not retrieve %s attributes for "
 				      "%s ino %llu: %s (%d)\n"),
 				      EXTATTR_NAMESPACE(flag),
 				      FILETYPE(statp),
 				      statp->bs_ino,
-				      strerror( errno ),
-				      errno );
+				      strerror(errno),
+				      errno);
 				*abortprp = BOOL_TRUE;
 				return RV_OK;
 			}
 
-			for ( rtrvix = 0 ; rtrvix < rtrvcnt ; rtrvix++ ) {
+			for (rtrvix = 0 ; rtrvix < rtrvcnt ; rtrvix++) {
 				attr_multiop_t *opp;
-				opp = &contextp->cc_extattrrtrvarrayp[ rtrvix ];
-				if ( opp->am_error ) {
-					if ( opp->am_error == ENOATTR &&
-					     flag & ATTR_SECURE ) {
+				opp = &contextp->cc_extattrrtrvarrayp[rtrvix];
+				if (opp->am_error) {
+					if (opp->am_error == ENOATTR &&
+					     flag & ATTR_SECURE) {
 				/* Security attributes are supported by
 				 * the kernel but jdm_attr_multi() returns
 				 * ENOATTR for every 'user' space attribute
@@ -3399,7 +3399,7 @@ dump_extattr_list( drive_t *drivep,
 				 */
 						continue;
 					}
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					     "attr_multi indicates error while "
 					     "retrieving %s attribute [%s] for "
 					     "%s ino %llu: %s (%d)\n"),
@@ -3407,8 +3407,8 @@ dump_extattr_list( drive_t *drivep,
 					     opp->am_attrname,
 					     FILETYPE(statp),
 					     statp->bs_ino,
-					     strerror( opp->am_error ),
-					     opp->am_error );
+					     strerror(opp->am_error),
+					     opp->am_error);
 				}
 			}
 		}
@@ -3421,15 +3421,15 @@ dump_extattr_list( drive_t *drivep,
 		if (dumpbufp <= dumpbufendp)
 			continue;	/* no buffer overflow yet */
 
-		assert( endp > contextp->cc_extattrdumpbufp );
-		bufsz = ( size_t )( endp - contextp->cc_extattrdumpbufp );
+		assert(endp > contextp->cc_extattrdumpbufp);
+		bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
-		rval = write_buf( contextp->cc_extattrdumpbufp,
+		rval = write_buf(contextp->cc_extattrdumpbufp,
 				  bufsz,
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
@@ -3445,7 +3445,7 @@ dump_extattr_list( drive_t *drivep,
 			rv = RV_CORE;
 			break;
 		}
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			*abortprp = BOOL_FALSE;
 			return rv;
 		}
@@ -3471,7 +3471,7 @@ dump_extattr_list( drive_t *drivep,
 						&hsmnamep,
 						&hsmvaluep,
 						&hsmvaluesz)) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 			      		"HSM could not add new %s attribute "
 					"#%d for %s ino %llu\n"),
 					EXTATTR_NAMESPACE(flag),
@@ -3485,30 +3485,30 @@ dump_extattr_list( drive_t *drivep,
 				break;		/* No more attributes to add */
 			}
 
-			dumpbufp = dump_extattr_buildrecord( statp,
+			dumpbufp = dump_extattr_buildrecord(statp,
 							     dumpbufp,
 							     dumpbufendp,
 							     hsmnamep,
 							     hsmvaluesz,
 							     flag,
-							     &valuep );
+							     &valuep);
 
-			if ( dumpbufp < dumpbufendp ) {	/* if fits in buffer */
+			if (dumpbufp < dumpbufendp) {	/* if fits in buffer */
 				endp = dumpbufp;
 				(void)memcpy(valuep, hsmvaluep, hsmvaluesz);
 				hsmcursor++;
 				continue;
 			}
 
-			assert( endp > contextp->cc_extattrdumpbufp );
-			bufsz = ( size_t )( endp - contextp->cc_extattrdumpbufp );
+			assert(endp > contextp->cc_extattrdumpbufp);
+			bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
-			rval = write_buf( contextp->cc_extattrdumpbufp,
+			rval = write_buf(contextp->cc_extattrdumpbufp,
 				  bufsz,
-				  ( void * )drivep,
-				  ( gwbfp_t )drivep->d_opsp->do_get_write_buf,
-				  ( wfp_t )drivep->d_opsp->do_write );
-			switch ( rval ) {
+				  (void *)drivep,
+				  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+				  (wfp_t)drivep->d_opsp->do_write);
+			switch (rval) {
 			case 0:
 				rv = RV_OK;
 				break;
@@ -3524,7 +3524,7 @@ dump_extattr_list( drive_t *drivep,
 				rv = RV_CORE;
 				break;
 			}
-			if ( rv != RV_OK ) {
+			if (rv != RV_OK) {
 				*abortprp = BOOL_FALSE;
 				return rv;
 			}
@@ -3538,14 +3538,14 @@ dump_extattr_list( drive_t *drivep,
 	 */
 
 	if (endp > contextp->cc_extattrdumpbufp) {
-		bufsz = ( size_t )( endp - contextp->cc_extattrdumpbufp );
+		bufsz = (size_t)(endp - contextp->cc_extattrdumpbufp);
 
-		rval = write_buf( contextp->cc_extattrdumpbufp,
+		rval = write_buf(contextp->cc_extattrdumpbufp,
 				  bufsz,
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
@@ -3561,7 +3561,7 @@ dump_extattr_list( drive_t *drivep,
 			rv = RV_CORE;
 			break;
 		}
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			*abortprp = BOOL_FALSE;
 			return rv;
 		}
@@ -3572,58 +3572,58 @@ dump_extattr_list( drive_t *drivep,
 }
 
 static char *
-dump_extattr_buildrecord( xfs_bstat_t *statp,
+dump_extattr_buildrecord(xfs_bstat_t *statp,
 			  char *dumpbufp,
 			  char *dumpbufendp,
 			  char *namesrcp,
 			  uint32_t valuesz,
 			  int flag,
-			  char **valuepp )
+			  char **valuepp)
 {
-	extattrhdr_t *ahdrp = ( extattrhdr_t * )dumpbufp;
+	extattrhdr_t *ahdrp = (extattrhdr_t *)dumpbufp;
 	char *namep = dumpbufp + EXTATTRHDR_SZ;
-	uint32_t namelen = strlen( namesrcp );
+	uint32_t namelen = strlen(namesrcp);
 	uint32_t namesz = namelen + 1;
 	char *valuep = namep + namesz;
 	uint32_t recsz = EXTATTRHDR_SZ + namesz + valuesz;
 	extattrhdr_t tmpah;
 
-	recsz = ( recsz + ( EXTATTRHDR_ALIGN - 1 ))
+	recsz = (recsz + (EXTATTRHDR_ALIGN - 1))
 		&
-		~( EXTATTRHDR_ALIGN - 1 );
+		~(EXTATTRHDR_ALIGN - 1);
 
-	if ( dumpbufp + recsz > dumpbufendp ) {
+	if (dumpbufp + recsz > dumpbufendp) {
 		*valuepp = 0;
 		return dumpbufp + recsz;
 	}
 
-	if ( namelen > NAME_MAX ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (namelen > NAME_MAX) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "%s extended attribute name for %s ino %llu too long: "
 		      "%u, max is %u: skipping\n"),
 		      EXTATTR_NAMESPACE(flag),
 		      FILETYPE(statp),
 		      statp->bs_ino,
 		      namelen,
-		      NAME_MAX );
+		      NAME_MAX);
 		*valuepp = 0;
 		return dumpbufp;
 	}
 
-	if ( valuesz > ATTR_MAX_VALUELEN ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (valuesz > ATTR_MAX_VALUELEN) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "%s extended attribute value for %s ino %llu too long: "
 		      "%u, max is %u: skipping\n"),
 		      EXTATTR_NAMESPACE(flag),
 		      FILETYPE(statp),
 		      statp->bs_ino,
 		      valuesz,
-		      ATTR_MAX_VALUELEN );
+		      ATTR_MAX_VALUELEN);
 		*valuepp = 0;
 		return dumpbufp;
 	}
 
-	/*DBG*/mlog( MLOG_NITTY,
+	/*DBG*/mlog(MLOG_NITTY,
 		     "building extattr "
 		     "record sz %u "
 		     "hdrsz %u "
@@ -3632,19 +3632,19 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 		     recsz,
 		     EXTATTRHDR_SZ,
 		     namesz, namesrcp,
-		     valuesz );
-	( void )strcpy( namep, namesrcp );
+		     valuesz);
+	(void)strcpy(namep, namesrcp);
 
-	memset( ( void * )&tmpah, 0, sizeof( tmpah ));
+	memset((void *)&tmpah, 0, sizeof(tmpah));
 	tmpah.ah_sz = recsz;
-	assert( EXTATTRHDR_SZ + namesz < UINT16MAX );
-	tmpah.ah_valoff = ( uint16_t )( EXTATTRHDR_SZ + namesz );
-	tmpah.ah_flags = ( uint16_t )
-		(( flag & ATTR_ROOT ) ? EXTATTRHDR_FLAGS_ROOT :
-		(( flag & ATTR_SECURE ) ? EXTATTRHDR_FLAGS_SECURE : 0));
+	assert(EXTATTRHDR_SZ + namesz < UINT16MAX);
+	tmpah.ah_valoff = (uint16_t)(EXTATTRHDR_SZ + namesz);
+	tmpah.ah_flags = (uint16_t)
+		((flag & ATTR_ROOT) ? EXTATTRHDR_FLAGS_ROOT :
+		((flag & ATTR_SECURE) ? EXTATTRHDR_FLAGS_SECURE : 0));
 	tmpah.ah_valsz = valuesz;
 	tmpah.ah_flags |= EXTATTRHDR_FLAGS_CHECKSUM;
-	tmpah.ah_checksum = calc_checksum( &tmpah, EXTATTRHDR_SZ );
+	tmpah.ah_checksum = calc_checksum(&tmpah, EXTATTRHDR_SZ);
 
 	xlate_extattrhdr(ahdrp, &tmpah, -1);
 	*valuepp = valuep;
@@ -3653,34 +3653,34 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
 
 /* ARGSUSED */
 static rv_t
-dump_extattrhdr( drive_t *drivep,
+dump_extattrhdr(drive_t *drivep,
 		 context_t *contextp,
 		 xfs_bstat_t *statp,
 		 size_t recsz,
 		 size_t valoff,
 		 ix_t flags,
-		 uint32_t valsz )
+		 uint32_t valsz)
 {
 	extattrhdr_t ahdr;
 	extattrhdr_t tmpahdr;
 	int rval;
 	rv_t rv;
 
-	memset( ( void * )&ahdr, 0, sizeof( ahdr ));
+	memset((void *)&ahdr, 0, sizeof(ahdr));
 	ahdr.ah_sz = recsz;
-	assert( valoff < UINT16MAX );
-	ahdr.ah_valoff = ( uint16_t )valoff;
-	ahdr.ah_flags = ( uint16_t )flags | EXTATTRHDR_FLAGS_CHECKSUM;
+	assert(valoff < UINT16MAX);
+	ahdr.ah_valoff = (uint16_t)valoff;
+	ahdr.ah_flags = (uint16_t)flags | EXTATTRHDR_FLAGS_CHECKSUM;
 	ahdr.ah_valsz = valsz;
-	ahdr.ah_checksum = calc_checksum( &ahdr, EXTATTRHDR_SZ );
+	ahdr.ah_checksum = calc_checksum(&ahdr, EXTATTRHDR_SZ);
 
 	xlate_extattrhdr(&ahdr, &tmpahdr, 1);
-	rval = write_buf( ( char * )&tmpahdr,
+	rval = write_buf((char *)&tmpahdr,
 			  EXTATTRHDR_SZ,
-			  ( void * )drivep,
-			  ( gwbfp_t )drivep->d_opsp->do_get_write_buf,
-			  ( wfp_t )drivep->d_opsp->do_write );
-	switch ( rval ) {
+			  (void *)drivep,
+			  (gwbfp_t)drivep->d_opsp->do_get_write_buf,
+			  (wfp_t)drivep->d_opsp->do_write);
+	switch (rval) {
 	case 0:
 		rv = RV_OK;
 		break;
@@ -3709,19 +3709,19 @@ dump_extattrhdr( drive_t *drivep,
  */
 /* ARGSUSED */
 static rv_t
-dump_file( void *arg1,
+dump_file(void *arg1,
 	   jdm_fshandle_t *fshandlep,
 	   int fsfd,
-	   xfs_bstat_t *statp )
+	   xfs_bstat_t *statp)
 {
-	ix_t strmix = ( ix_t )arg1;
-	context_t *contextp = &sc_contextp[ strmix ];
-	drive_t *drivep = drivepp[ strmix ];
+	ix_t strmix = (ix_t)arg1;
+	context_t *contextp = &sc_contextp[strmix];
+	drive_t *drivep = drivepp[strmix];
 	drive_hdr_t *dwhdrp = drivep->d_writehdrp;
-	media_hdr_t *mwhdrp = ( media_hdr_t * )dwhdrp->dh_upper;
-	content_hdr_t *cwhdrp = ( content_hdr_t * )mwhdrp->mh_upper;
-	content_inode_hdr_t *scwhdrp = ( content_inode_hdr_t * )
-				       ( void * )
+	media_hdr_t *mwhdrp = (media_hdr_t *)dwhdrp->dh_upper;
+	content_hdr_t *cwhdrp = (content_hdr_t *)mwhdrp->mh_upper;
+	content_inode_hdr_t *scwhdrp = (content_inode_hdr_t *)
+				       (void *)
 				       cwhdrp->ch_specific;
 	startpt_t *startptp = &scwhdrp->cih_startpt;
 	startpt_t *endptp = &scwhdrp->cih_endpt;
@@ -3731,22 +3731,22 @@ dump_file( void *arg1,
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink < 1 ) {
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+	if (statp->bs_nlink < 1) {
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as no links for ino %llu\n",
+		mlog(MLOG_DEBUG, "skip as no links for ino %llu\n",
 			statp->bs_ino);
 		return RV_OK;
 	}
 
 	/* skip if prior to startpoint
 	 */
-	if ( statp->bs_ino < startptp->sp_ino ) {
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+	if (statp->bs_ino < startptp->sp_ino) {
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as ino %llu is prior to starpoint\n",
+		mlog(MLOG_DEBUG, "skip as ino %llu is prior to starpoint\n",
 			statp->bs_ino);
 		return RV_OK;
 	}
@@ -3754,22 +3754,22 @@ dump_file( void *arg1,
 	/* skip if at or beyond next startpoint. return non-zero to
 	 * abort iteration.
 	 */
-	if ( ! ( endptp->sp_flags & STARTPT_FLAGS_END )) {
-		if ( endptp->sp_offset == 0 ) {
-			if ( statp->bs_ino >= endptp->sp_ino ) {
-				if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+	if (! (endptp->sp_flags & STARTPT_FLAGS_END)) {
+		if (endptp->sp_offset == 0) {
+			if (statp->bs_ino >= endptp->sp_ino) {
+				if (statp->bs_ino > contextp->cc_stat_lastino) {
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
-				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
+				mlog(MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
 					statp->bs_ino);
 				return RV_NOMORE;
 			}
 		} else {
-			if ( statp->bs_ino > endptp->sp_ino ) {
-				if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+			if (statp->bs_ino > endptp->sp_ino) {
+				if (statp->bs_ino > contextp->cc_stat_lastino) {
 					contextp->cc_stat_lastino = statp->bs_ino;
 				}
-				mlog( MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
+				mlog(MLOG_DEBUG, "skip as ino %llu is at/beyond starpoint\n",
 					statp->bs_ino);
 				return RV_NOMORE;
 			}
@@ -3778,35 +3778,35 @@ dump_file( void *arg1,
 
 	/* see what the inomap says about this ino
 	 */
-	state = inomap_get_state( contextp->cc_inomap_contextp, statp->bs_ino );
+	state = inomap_get_state(contextp->cc_inomap_contextp, statp->bs_ino);
 
 	/* skip if not in inomap
 	 */
-	if ( state == MAP_INO_UNUSED
+	if (state == MAP_INO_UNUSED
 	     ||
 	     state == MAP_DIR_NOCHNG
 	     ||
-	     state == MAP_NDR_NOCHNG ) {
-		if ( state == MAP_DIR_NOCHNG ) {
-			mlog( MLOG_DEBUG,
+	     state == MAP_NDR_NOCHNG) {
+		if (state == MAP_DIR_NOCHNG) {
+			mlog(MLOG_DEBUG,
 			      "inomap inconsistency ino %llu: "
 			      "MAP_DIR_NOCHNG but is non-dir: skipping\n",
-			      statp->bs_ino );
+			      statp->bs_ino);
 		}
-		if ( statp->bs_ino > contextp->cc_stat_lastino ) {
+		if (statp->bs_ino > contextp->cc_stat_lastino) {
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
-		mlog( MLOG_DEBUG, "skip as ino %llu is not marked as changed in inomap\n",
+		mlog(MLOG_DEBUG, "skip as ino %llu is not marked as changed in inomap\n",
 			statp->bs_ino);
-		mlog( MLOG_DEBUG, "ino %llu is in state %d\n",
+		mlog(MLOG_DEBUG, "ino %llu is in state %d\n",
 			statp->bs_ino, state);
 		return RV_OK;
 	}
 
 	/* note if map says a dir
 	 */
-	if ( state == MAP_DIR_CHANGE || state == MAP_DIR_SUPPRT ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING, _(
+	if (state == MAP_DIR_CHANGE || state == MAP_DIR_SUPPRT) {
+		mlog(MLOG_NORMAL | MLOG_WARNING, _(
 		      "inomap inconsistency ino %llu: "
 		      "%s but is now non-dir: NOT dumping\n"),
 		      statp->bs_ino,
@@ -3814,7 +3814,7 @@ dump_file( void *arg1,
 		      ?
 		      "map says changed dir"
 		      :
-		      "map says unchanged dir" );
+		      "map says unchanged dir");
 	}
 
 	/* if GETOPT_DUMPASOFFLINE was specified, initialize the HSM's file
-- 
2.19.1
