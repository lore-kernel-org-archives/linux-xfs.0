Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43111 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbeKJAMe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:34 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15656308213C
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:43 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/24] xfsdump: (2/4)(style) remove spaces from parentheses
Date: Fri,  9 Nov 2018 15:29:44 +0100
Message-Id: <20181109143004.24963-5-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
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

#!/usr/bin/env bash
# transform 'foo( x, y )' -> 'foo(x, y)'

# regexps in order:
# - remove spaces after opening parentheses (
# - remove spaces before closing parentheses )
# - remove spaces after opening brackets [
# - remove spaces before closing brackets ]

find . -name '*.[ch]' ! -type d -exec bash -c '
sed -i \
    -e "s/(\s\+/(/g" \
    -e "s/\(\S\)\s\+)/\1)/g" \
    -e "s/\[\s\+/[/g" \
    -e "s/\(\S\)\s\+\]/\1]/g" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 dump/content.c | 3644 ++++++++++++++++++++++++------------------------
 dump/getopt.h  |    2 +-
 dump/inomap.c  |  768 +++++-----
 dump/inomap.h  |   32 +-
 dump/var.c     |   96 +-
 dump/var.h     |    4 +-
 6 files changed, 2273 insertions(+), 2273 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index ecc867d..81159ee 100644
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
+				  _("non-root")) )
 
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
+			     (maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE) ) {
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
+	if (optind < argc && ! strcmp(argv[optind], "-")) {
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
+	querystr[querycnt++] = "select a drive to acknowledge media change\n";
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
+	choicestr[choicecnt++] = "continue";
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
+		      statp->bs_ino, strerror(errno) );
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
@@ -3824,11 +3824,11 @@ dump_file( void *arg1,
 
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
@@ -3837,7 +3837,7 @@ dump_file( void *arg1,
 
 	/* pass on to specific dump function
 	 */
-	switch( statp->bs_mode & S_IFMT ) {
+	switch(statp->bs_mode & S_IFMT) {
 	case S_IFREG:
 		/* ordinary file
 		 */
@@ -3847,7 +3847,7 @@ dump_file( void *arg1,
 		 */
 		if (maxdumpfilesize) {
 			off64_t estimated_size = statp->bs_blocks *
-						 ( off64_t )statp->bs_blksize;
+						 (off64_t)statp->bs_blksize;
 
 			if (hsm_fs_ctxtp) {
 				HsmEstimateFileSpace(hsm_fs_ctxtp,
@@ -3860,23 +3860,23 @@ dump_file( void *arg1,
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
@@ -3890,11 +3890,11 @@ dump_file( void *arg1,
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
@@ -3902,14 +3902,14 @@ dump_file( void *arg1,
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
@@ -3918,14 +3918,14 @@ dump_file( void *arg1,
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
@@ -3938,12 +3938,12 @@ dump_file( void *arg1,
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
+	if ((statp->bs_mode & S_ISGID) && (! (statp->bs_mode&S_IXOTH)) ) {
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
+	preamblestr[preamblecnt++] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++] = "\n\n";
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
+	choicestr[choicecnt++] = "don't overwrite";
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = "overwrite";
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++] = "overwrite";
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
+		ackstr[ackcnt++] = "media will be overwritten\n";
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++] = "media will NOT be overwritten\n";
 	} else {
-		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
+		ackstr[ackcnt++] = "keyboard interrupt\n";
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
+	postamblestr[postamblecnt++] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++] = "\n\n";
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
+	preamblestr[preamblecnt++] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++] = "\n\n";
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
+	choicestr[choicecnt++] = "don't erase";
 	doix = choicecnt;
-	choicestr[ choicecnt++ ] = "erase";
-	assert( choicecnt <= CHOICEMAX );
+	choicestr[choicecnt++] = "erase";
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
+		ackstr[ackcnt++] = "media will be erased\n";
+	} else if (responseix == dontix) {
+		ackstr[ackcnt++] = "media will NOT be erased\n";
 	} else {
-		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
+		ackstr[ackcnt++] = "keyboard interrupt\n";
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
+	postamblestr[postamblecnt++] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++] = "\n\n";
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
+	preamblestr[preamblecnt++] = "\n";
+	preamblestr[preamblecnt++] = fold;
+	preamblestr[preamblecnt++] = "\n\n";
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
+		ackstr[ackcnt++] = "media label entered: \"";
+		ackstr[ackcnt++] = bufp;
+		ackstr[ackcnt++] = "\"\n";
+	} else if (responseix == timeoutix) {
+		ackstr[ackcnt++] = "timeout: media label left blank\n";
+	} else if (responseix == sigintix) {
+		ackstr[ackcnt++] = "keyboard interrupt\n";
 	} else {
-		ackstr[ ackcnt++ ] = "abort\n";
+		ackstr[ackcnt++] = "abort\n";
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
+	postamblestr[postamblecnt++] = "\n";
+	postamblestr[postamblecnt++] = fold;
+	postamblestr[postamblecnt++] = "\n\n";
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
diff --git a/dump/getopt.h b/dump/getopt.h
index 3bab87a..dd798d8 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -50,7 +50,7 @@
 #define	GETOPT_SUBTREE		's'	/* subtree dump (content_inode.c) */
 #define GETOPT_DUMPTIME		't'	/* use mtime of file as dump time */
 /*				'u' */
-#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4 ) */
+#define	GETOPT_VERBOSITY	'v'	/* verbosity level (0 to 4) */
 /*				'w' */
 /*				'x'	   used in irix for xvm snapshot */
 /*				'y' */
diff --git a/dump/inomap.c b/dump/inomap.c
index 238fcaf..75e26e2 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -57,7 +57,7 @@
 
 /* declarations of externally defined global symbols *************************/
 
-extern bool_t preemptchk( int );
+extern bool_t preemptchk(int);
 extern size_t pgsz;
 extern hsm_fs_ctxt_t *hsm_fs_ctxtp;
 extern uint64_t maxdumpfilesize;
@@ -67,7 +67,7 @@ extern bool_t allowexcludefiles_pr;
 
 /* inomap construction callbacks
  */
-static int cb_context( bool_t last,
+static int cb_context(bool_t last,
 			    time32_t,
 			    bool_t,
 			    time32_t,
@@ -78,50 +78,50 @@ static int cb_context( bool_t last,
 			    int,
 			    bool_t,
 			    bool_t *);
-static void cb_context_free( void );
-static int cb_count_inogrp( void *, int, xfs_inogrp_t *);
-static int cb_add_inogrp( void *, int, xfs_inogrp_t * );
-static int cb_add( void *, jdm_fshandle_t *, int, xfs_bstat_t * );
-static bool_t cb_inoinresumerange( xfs_ino_t );
-static bool_t cb_inoresumed( xfs_ino_t );
-static void cb_accuminit_sz( void );
-static void cb_spinit( void );
-static int cb_startpt( void *,
+static void cb_context_free(void);
+static int cb_count_inogrp(void *, int, xfs_inogrp_t *);
+static int cb_add_inogrp(void *, int, xfs_inogrp_t *);
+static int cb_add(void *, jdm_fshandle_t *, int, xfs_bstat_t *);
+static bool_t cb_inoinresumerange(xfs_ino_t);
+static bool_t cb_inoresumed(xfs_ino_t);
+static void cb_accuminit_sz(void);
+static void cb_spinit(void);
+static int cb_startpt(void *,
 			    jdm_fshandle_t *,
 			    int,
-			    xfs_bstat_t * );
-static int supprt_prune( void *,
+			    xfs_bstat_t *);
+static int supprt_prune(void *,
 			      jdm_fshandle_t *,
 			      int,
 			      xfs_bstat_t *,
-			      char * );
-static off64_t quantity2offset( jdm_fshandle_t *, xfs_bstat_t *, off64_t );
-static off64_t estimate_dump_space( xfs_bstat_t * );
+			      char *);
+static off64_t quantity2offset(jdm_fshandle_t *, xfs_bstat_t *, off64_t);
+static off64_t estimate_dump_space(xfs_bstat_t *);
 
 /* inomap primitives
  */
-static int inomap_init( int igrpcnt );
-static void inomap_add( void *, xfs_ino_t ino, gen_t gen, int );
-static int inomap_set_state( void *, xfs_ino_t ino, int );
-static void inomap_set_gen(void *, xfs_ino_t, gen_t );
+static int inomap_init(int igrpcnt);
+static void inomap_add(void *, xfs_ino_t ino, gen_t gen, int);
+static int inomap_set_state(void *, xfs_ino_t ino, int);
+static void inomap_set_gen(void *, xfs_ino_t, gen_t);
 
 /* subtree abstraction
  */
-static int subtree_descend_cb( void *,
+static int subtree_descend_cb(void *,
 				    jdm_fshandle_t *,
 				    int fsfd,
 				    xfs_bstat_t *,
-				    char * );
-static int subtreelist_parse_cb( void *,
+				    char *);
+static int subtreelist_parse_cb(void *,
 				      jdm_fshandle_t *,
 				      int fsfd,
 				      xfs_bstat_t *,
-				      char * );
-static int subtreelist_parse( jdm_fshandle_t *,
+				      char *);
+static int subtreelist_parse(jdm_fshandle_t *,
 				   int,
 				   xfs_bstat_t *,
 				   char *[],
-				   ix_t );
+				   ix_t);
 
 /* definition of locally defined global variables ****************************/
 
@@ -142,7 +142,7 @@ static uint64_t inomap_exclude_skipattr = 0;
  */
 /* ARGSUSED */
 bool_t
-inomap_build( jdm_fshandle_t *fshandlep,
+inomap_build(jdm_fshandle_t *fshandlep,
 	      int fsfd,
 	      xfs_bstat_t *rootstatp,
 	      bool_t last,
@@ -159,7 +159,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	      ix_t *statphasep,
 	      ix_t *statpassp,
 	      size64_t statcnt,
-	      size64_t *statdonep )
+	      size64_t *statdonep)
 {
 	xfs_bstat_t *bstatbufp;
 	size_t bstatbuflen;
@@ -185,24 +185,24 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	/* allocate a bulkstat buf
 	 */
 	bstatbuflen = BSTATBUFLEN;
-	bstatbufp = ( xfs_bstat_t * )memalign( pgsz,
+	bstatbufp = (xfs_bstat_t *)memalign(pgsz,
 					       bstatbuflen
 					       *
-					       sizeof( xfs_bstat_t ));
-	assert( bstatbufp );
+					       sizeof(xfs_bstat_t));
+	assert(bstatbufp);
 
 	/* count the number of inode groups, which will serve as a
 	 * starting point for the size of the inomap.
 	 */
-	rval = inogrp_iter( fsfd, cb_count_inogrp, (void *)&igrpcnt, &stat );
-	if ( rval || stat ) {
-		free( ( void * )bstatbufp );
+	rval = inogrp_iter(fsfd, cb_count_inogrp, (void *)&igrpcnt, &stat);
+	if (rval || stat) {
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
 	/* initialize the callback context
 	 */
-	rval = cb_context( last,
+	rval = cb_context(last,
 			   lasttime,
 			   resume,
 			   resumetime,
@@ -212,9 +212,9 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			   startptcnt,
 			   igrpcnt,
 			   skip_unchanged_dirs,
-			   &pruneneeded );
- 	if ( rval ) {
- 		free( ( void * )bstatbufp );
+			   &pruneneeded);
+ 	if (rval) {
+ 		free((void *)bstatbufp);
  		return BOOL_FALSE;
  	}
 
@@ -225,10 +225,10 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	 * in this filesystem. each inode will be marked unused until its
 	 * correct state is set in cb_add.
 	 */
-	rval = inogrp_iter( fsfd, cb_add_inogrp, NULL, &stat );
- 	if ( rval || stat ) {
+	rval = inogrp_iter(fsfd, cb_add_inogrp, NULL, &stat);
+ 	if (rval || stat) {
 		cb_context_free();
- 		free( ( void * )bstatbufp );
+ 		free((void *)bstatbufp);
  		return BOOL_FALSE;
  	}
 
@@ -244,26 +244,26 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	 * set a flag if any ino not put in a dump state. This will be used
 	 * to decide if any pruning can be done.
 	 */
-	mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 	      "ino map phase 1: "
-	      "constructing initial dump list\n") );
+	      "constructing initial dump list\n"));
 
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 1;
 	stat = 0;
-	cb_accuminit_sz( );
+	cb_accuminit_sz();
 
-	if ( subtreecnt ) {
-		rval = subtreelist_parse( fshandlep,
+	if (subtreecnt) {
+		rval = subtreelist_parse(fshandlep,
 					  fsfd,
 					  rootstatp,
 					  subtreebuf,
-					  subtreecnt );
+					  subtreecnt);
 	} else {
-		rval = bigstat_iter( fshandlep,
+		rval = bigstat_iter(fshandlep,
 				     fsfd,
 				     BIGSTAT_ITER_ALL,
-				     ( xfs_ino_t )0,
+				     (xfs_ino_t)0,
 				     cb_add,
 				     NULL,
 				     NULL,
@@ -271,80 +271,80 @@ inomap_build( jdm_fshandle_t *fshandlep,
 				     &stat,
 				     preemptchk,
 				     bstatbufp,
-				     bstatbuflen );
+				     bstatbuflen);
 	}
 	*inomap_statphasep = 0;
-	if ( rval || preemptchk( PREEMPT_FULL )) {
+	if (rval || preemptchk(PREEMPT_FULL)) {
 		cb_context_free();
-		free( ( void * )bstatbufp );
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
-	if ( inomap_exclude_filesize > 0 ) {
-		mlog( MLOG_NOTE | MLOG_VERBOSE, _(
+	if (inomap_exclude_filesize > 0) {
+		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
 		      "pruned %llu files: maximum size exceeded\n"),
-		      inomap_exclude_filesize );
+		      inomap_exclude_filesize);
 	}
-	if ( inomap_exclude_skipattr > 0 ) {
-		mlog( MLOG_NOTE | MLOG_VERBOSE, _(
+	if (inomap_exclude_skipattr > 0) {
+		mlog(MLOG_NOTE | MLOG_VERBOSE, _(
 		      "pruned %llu files: skip attribute set\n"),
-		      inomap_exclude_skipattr );
+		      inomap_exclude_skipattr);
 	}
 
 	/* prune directories unchanged since the last dump and containing
 	 * no children needing dumping.
 	 */
-	if ( pruneneeded ) {
+	if (pruneneeded) {
 		bool_t	rootdump = BOOL_FALSE;
 
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 2: "
-		      "pruning unneeded subtrees\n") );
+		      "pruning unneeded subtrees\n"));
 		*inomap_statdonep = 0;
 		*inomap_statpassp = 0;
 		*inomap_statphasep = 2;
 
-		(void) supprt_prune( &rootdump,
+		(void) supprt_prune(&rootdump,
 				     fshandlep,
 				     fsfd,
 				     rootstatp,
-				     NULL );
+				     NULL);
 		*inomap_statphasep = 0;
 
-		if ( preemptchk( PREEMPT_FULL )) {
+		if (preemptchk(PREEMPT_FULL)) {
 			cb_context_free();
-			free( ( void * )bstatbufp );
+			free((void *)bstatbufp);
 			return BOOL_FALSE;
 		}
 
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 2: "
-		      "skipping (no pruning necessary)\n") );
+		      "skipping (no pruning necessary)\n"));
 	}
 
 	/* initialize the callback context for startpoint calculation
 	 */
-	cb_spinit( );
+	cb_spinit();
 
 	/* identify dump stream startpoints
 	 */
-	if ( startptcnt > 1 ) {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+	if (startptcnt > 1) {
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 3: "
-		      "identifying stream starting points\n") );
+		      "identifying stream starting points\n"));
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
+		mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
 		      "ino map phase 3: "
-		      "skipping (only one dump stream)\n") );
+		      "skipping (only one dump stream)\n"));
 	}
 	stat = 0;
 	*inomap_statdonep = 0;
 	*inomap_statphasep = 3;
-	rval = bigstat_iter( fshandlep,
+	rval = bigstat_iter(fshandlep,
 			     fsfd,
 			     BIGSTAT_ITER_NONDIR,
-			     ( xfs_ino_t )0,
+			     (xfs_ino_t)0,
 			     cb_startpt,
 			     NULL,
 			     inomap_next_nondir,
@@ -352,66 +352,66 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			     &stat,
 			     preemptchk,
 			     bstatbufp,
-			     bstatbuflen );
+			     bstatbuflen);
 	*inomap_statphasep = 0;
 
-	if ( rval ) {
+	if (rval) {
 		cb_context_free();
-		free( ( void * )bstatbufp );
+		free((void *)bstatbufp);
 		return BOOL_FALSE;
 	}
 
-	if ( startptcnt > 1 ) {
+	if (startptcnt > 1) {
 		ix_t startptix;
-		for ( startptix = 0 ; startptix < startptcnt ; startptix++ ) {
+		for (startptix = 0 ; startptix < startptcnt ; startptix++) {
 			startpt_t *p;
 			startpt_t *ep;
 
-			p = &startptp[ startptix ];
-			if ( startptix == startptcnt - 1 ) {
+			p = &startptp[startptix];
+			if (startptix == startptcnt - 1) {
 				ep = 0;
 			} else {
-				ep = &startptp[ startptix + 1 ];
+				ep = &startptp[startptix + 1];
 			}
-			assert( ! p->sp_flags );
-			mlog( MLOG_VERBOSE | MLOG_INOMAP,
+			assert(! p->sp_flags);
+			mlog(MLOG_VERBOSE | MLOG_INOMAP,
 			      _("stream %u: ino %llu offset %lld to "),
 			      startptix,
 			      p->sp_ino,
-			      p->sp_offset );
-			if ( ! ep ) {
-				mlog( MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
-				      _("end\n") );
+			      p->sp_offset);
+			if (! ep) {
+				mlog(MLOG_VERBOSE | MLOG_BARE | MLOG_INOMAP,
+				      _("end\n"));
 			} else {
-				mlog( MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
+				mlog(MLOG_VERBOSE |  MLOG_BARE | MLOG_INOMAP,
 				      _("ino %llu offset %lld\n"),
 				      ep->sp_ino,
-				      ep->sp_offset );
+				      ep->sp_offset);
 			}
 		}
 	}
 
 	cb_context_free();
-	free( ( void * )bstatbufp );
-	mlog( MLOG_VERBOSE | MLOG_INOMAP, _(
-	      "ino map construction complete\n") );
+	free((void *)bstatbufp);
+	mlog(MLOG_VERBOSE | MLOG_INOMAP, _(
+	      "ino map construction complete\n"));
 	return BOOL_TRUE;
 }
 
 void
-inomap_skip( xfs_ino_t ino )
+inomap_skip(xfs_ino_t ino)
 {
 	int oldstate;
 
-	oldstate = inomap_get_state( NULL, ino );
-	if ( oldstate == MAP_NDR_CHANGE) {
-		inomap_set_state( NULL, ino, MAP_NDR_NOCHNG );
+	oldstate = inomap_get_state(NULL, ino);
+	if (oldstate == MAP_NDR_CHANGE) {
+		inomap_set_state(NULL, ino, MAP_NDR_NOCHNG);
 	}
 
-	if ( oldstate == MAP_DIR_CHANGE
+	if (oldstate == MAP_DIR_CHANGE
 	     ||
-	     oldstate == MAP_DIR_SUPPRT ) {
-		inomap_set_state( NULL, ino, MAP_DIR_NOCHNG );
+	     oldstate == MAP_DIR_SUPPRT) {
+		inomap_set_state(NULL, ino, MAP_DIR_NOCHNG);
 	}
 }
 
@@ -445,7 +445,7 @@ static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
  * phases of inomap_build().
  */
 static int
-cb_context( bool_t last,
+cb_context(bool_t last,
 	    time32_t lasttime,
 	    bool_t resume,
 	    time32_t resumetime,
@@ -455,7 +455,7 @@ cb_context( bool_t last,
 	    size_t startptcnt,
 	    int igrpcnt,
 	    bool_t skip_unchanged_dirs,
-	    bool_t *pruneneededp )
+	    bool_t *pruneneededp)
 {
 	cb_last = last;
 	cb_lasttime = lasttime;
@@ -471,7 +471,7 @@ cb_context( bool_t last,
 	cb_pruneneededp = pruneneededp;
 	cb_skip_unchanged_dirs = skip_unchanged_dirs;
 
-	if (inomap_init( igrpcnt ))
+	if (inomap_init(igrpcnt))
 		return -1;
 
 	cb_inomap_contextp = inomap_alloc_context();
@@ -482,13 +482,13 @@ cb_context( bool_t last,
 }
 
 static void
-cb_context_free( void )
+cb_context_free(void)
 {
-	inomap_free_context( cb_inomap_contextp );
+	inomap_free_context(cb_inomap_contextp);
 }
 
 static int
-cb_count_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
+cb_count_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 {
 	int *count = (int *)arg1;
 	(*count)++;
@@ -502,25 +502,25 @@ cb_count_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
  */
 /* ARGSUSED */
 static int
-cb_add( void *arg1,
+cb_add(void *arg1,
 	jdm_fshandle_t *fshandlep,
 	int fsfd,
-	xfs_bstat_t *statp )
+	xfs_bstat_t *statp)
 {
 	register time32_t mtime = statp->bs_mtime.tv_sec;
 	register time32_t ctime = statp->bs_ctime.tv_sec;
-	register time32_t ltime = max( mtime, ctime );
+	register time32_t ltime = max(mtime, ctime);
 	register mode_t mode = statp->bs_mode & S_IFMT;
 	xfs_off_t estimated_size = 0;
 	xfs_ino_t ino = statp->bs_ino;
 	bool_t changed;
 	bool_t resumed;
 
-	( *inomap_statdonep )++;
+	(*inomap_statdonep)++;
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink == 0 ) {
+	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
@@ -533,14 +533,14 @@ cb_add( void *arg1,
 	 * increment was based, dump it if it has changed since that
 	 * original base dump.
 	 */
-	if ( cb_resume && ! cb_inoinresumerange( ino )) {
-		if ( ltime >= cb_resumetime ) {
+	if (cb_resume && ! cb_inoinresumerange(ino)) {
+		if (ltime >= cb_resumetime) {
 			changed = BOOL_TRUE;
 		} else {
 			changed = BOOL_FALSE;
 		}
-	} else if ( cb_last ) {
-		if ( ltime >= cb_lasttime ) {
+	} else if (cb_last) {
+		if (ltime >= cb_lasttime) {
 			changed = BOOL_TRUE;
 		} else {
 			changed = BOOL_FALSE;
@@ -552,86 +552,86 @@ cb_add( void *arg1,
 	/* this is redundant: make sure any ino partially dumped
 	 * is completed.
 	 */
-	if ( cb_resume && cb_inoresumed( ino )) {
+	if (cb_resume && cb_inoresumed(ino)) {
 		resumed = BOOL_TRUE;
 	} else {
 		resumed = BOOL_FALSE;
 	}
 
-	if ( changed ) {
-		if ( mode == S_IFDIR ) {
-			inomap_add( cb_inomap_contextp,
+	if (changed) {
+		if (mode == S_IFDIR) {
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_DIR_CHANGE );
+				    MAP_DIR_CHANGE);
 			cb_dircnt++;
 		} else {
-			estimated_size = estimate_dump_space( statp );
+			estimated_size = estimate_dump_space(statp);
 
 			/* skip if size is greater than prune size. quota
 			 * files are exempt from the check.
 			 */
-			if ( maxdumpfilesize > 0 &&
+			if (maxdumpfilesize > 0 &&
 			     estimated_size > maxdumpfilesize &&
-			     !is_quota_file(statp->bs_ino) ) {
-				mlog( MLOG_DEBUG | MLOG_EXCLFILES,
+			     !is_quota_file(statp->bs_ino)) {
+				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
 				      "pruned ino %llu, owner %u, estimated size %llu: maximum size exceeded\n",
 				      statp->bs_ino,
 				      statp->bs_uid,
-				      estimated_size );
-				inomap_add( cb_inomap_contextp,
+				      estimated_size);
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG );
+					    MAP_NDR_NOCHNG);
 				inomap_exclude_filesize++;
 				return 0;
 			}
 
 			if (allowexcludefiles_pr && statp->bs_xflags & XFS_XFLAG_NODUMP) {
-				mlog( MLOG_DEBUG | MLOG_EXCLFILES,
+				mlog(MLOG_DEBUG | MLOG_EXCLFILES,
 				      "pruned ino %llu, owner %u, estimated size %llu: skip flag set\n",
 				      statp->bs_ino,
 				      statp->bs_uid,
-				      estimated_size );
-				inomap_add( cb_inomap_contextp,
+				      estimated_size);
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_NDR_NOCHNG );
+					    MAP_NDR_NOCHNG);
 				inomap_exclude_skipattr++;
 				return 0;
 			}
 
-			inomap_add( cb_inomap_contextp,
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_NDR_CHANGE );
+				    MAP_NDR_CHANGE);
 			cb_nondircnt++;
 			cb_datasz += estimated_size;
-			cb_hdrsz += ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
+			cb_hdrsz += (EXTENTHDR_SZ * (statp->bs_extents + 1));
 		}
-	} else if ( resumed ) {
-		assert( mode != S_IFDIR );
-		assert( changed );
+	} else if (resumed) {
+		assert(mode != S_IFDIR);
+		assert(changed);
 	} else {
-		if ( mode == S_IFDIR ) {
-			if ( cb_skip_unchanged_dirs ) {
-				inomap_add( cb_inomap_contextp,
+		if (mode == S_IFDIR) {
+			if (cb_skip_unchanged_dirs) {
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_DIR_NOCHNG );
+					    MAP_DIR_NOCHNG);
 			} else {
 				*cb_pruneneededp = BOOL_TRUE;
-				inomap_add( cb_inomap_contextp,
+				inomap_add(cb_inomap_contextp,
 					    ino,
 					    (gen_t)statp->bs_gen,
-					    MAP_DIR_SUPPRT );
+					    MAP_DIR_SUPPRT);
 				cb_dircnt++;
 			}
 		} else {
-			inomap_add( cb_inomap_contextp,
+			inomap_add(cb_inomap_contextp,
 				    ino,
 				    (gen_t)statp->bs_gen,
-				    MAP_NDR_NOCHNG );
+				    MAP_NDR_NOCHNG);
 		}
 	}
 
@@ -639,23 +639,23 @@ cb_add( void *arg1,
 }
 
 static bool_t
-cb_inoinresumerange( xfs_ino_t ino )
+cb_inoinresumerange(xfs_ino_t ino)
 {
 	register size_t streamix;
 
-	for ( streamix = 0 ; streamix < cb_resumerangecnt ; streamix++ ) {
-		register drange_t *rp = &cb_resumerangep[ streamix ];
-		if ( ! ( rp->dr_begin.sp_flags & STARTPT_FLAGS_END )
+	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+		register drange_t *rp = &cb_resumerangep[streamix];
+		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
 		     ino >= rp->dr_begin.sp_ino
 		     &&
-		     ( ( rp->dr_end.sp_flags & STARTPT_FLAGS_END )
+		     ((rp->dr_end.sp_flags & STARTPT_FLAGS_END)
 		       ||
 		       ino < rp->dr_end.sp_ino
 		       ||
-		       ( ino == rp->dr_end.sp_ino
+		       (ino == rp->dr_end.sp_ino
 			 &&
-			 rp->dr_end.sp_offset != 0 ))) {
+			 rp->dr_end.sp_offset != 0))) {
 			return BOOL_TRUE;
 		}
 	}
@@ -664,17 +664,17 @@ cb_inoinresumerange( xfs_ino_t ino )
 }
 
 static bool_t
-cb_inoresumed( xfs_ino_t ino )
+cb_inoresumed(xfs_ino_t ino)
 {
 	size_t streamix;
 
-	for ( streamix = 0 ; streamix < cb_resumerangecnt ; streamix++ ) {
-		drange_t *rp = &cb_resumerangep[ streamix ];
-		if ( ! ( rp->dr_begin.sp_flags & STARTPT_FLAGS_END )
+	for (streamix = 0 ; streamix < cb_resumerangecnt ; streamix++) {
+		drange_t *rp = &cb_resumerangep[streamix];
+		if (! (rp->dr_begin.sp_flags & STARTPT_FLAGS_END)
 		     &&
 		     ino == rp->dr_begin.sp_ino
 		     &&
-		     rp->dr_begin.sp_offset != 0 ) {
+		     rp->dr_begin.sp_offset != 0) {
 			return BOOL_TRUE;
 		}
 	}
@@ -688,20 +688,20 @@ cb_inoresumed( xfs_ino_t ino )
  */
 /* ARGSUSED */
 static bool_t			/* false, used as diriter callback */
-supprt_prune( void *arg1,	/* ancestors marked as changed? */
+supprt_prune(void *arg1,	/* ancestors marked as changed? */
 	      jdm_fshandle_t *fshandlep,
 	      int fsfd,
 	      xfs_bstat_t *statp,
-	      char *name )
+	      char *name)
 {
 	static bool_t cbrval = BOOL_FALSE;
 	int state;
 
-	if ( ( statp->bs_mode & S_IFMT ) == S_IFDIR ) {
+	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
 		bool_t changed_below = BOOL_FALSE;
 
-		state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-		if ( state != MAP_DIR_CHANGE &&
+		state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+		if (state != MAP_DIR_CHANGE &&
                      state != MAP_DIR_NOCHNG &&
 		     state != MAP_DIR_SUPPRT) {
 			/*
@@ -709,67 +709,67 @@ supprt_prune( void *arg1,	/* ancestors marked as changed? */
 			 * certainly changed.
 			 */
 			state = MAP_DIR_CHANGE;
-			inomap_set_state( cb_inomap_contextp,
+			inomap_set_state(cb_inomap_contextp,
 					  statp->bs_ino,
-					  state );
+					  state);
 		}
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 supprt_prune,
 				 (void *)&changed_below,
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 
-		if ( state == MAP_DIR_SUPPRT ) {
-			if ( changed_below == BOOL_FALSE ) {
-				inomap_set_state( cb_inomap_contextp,
+		if (state == MAP_DIR_SUPPRT) {
+			if (changed_below == BOOL_FALSE) {
+				inomap_set_state(cb_inomap_contextp,
 						  statp->bs_ino,
-						  MAP_DIR_NOCHNG );
+						  MAP_DIR_NOCHNG);
 				cb_dircnt--;	/* dump size just changed! */
 			}
 			else {
 				/* Directory entries back up the hierarchy */
 				/* to be dumped - as either MAP_DIR_SUPPRT */
 				/* or as MAP_DIR_CHANGE in inode state map */
-				*( bool_t * )arg1 = BOOL_TRUE;
+				*(bool_t *)arg1 = BOOL_TRUE;
 			}
 		}
-		else if ( state == MAP_DIR_CHANGE ) {
+		else if (state == MAP_DIR_CHANGE) {
 			/* Directory entries back up the hierarchy must get */
 			/* dumped - as either MAP_DIR_SUPPRT/MAP_DIR_CHANGE */
-			*( bool_t * )arg1 = BOOL_TRUE;
+			*(bool_t *)arg1 = BOOL_TRUE;
 		}
 		return cbrval;
 	}
 
-	if ( *(bool_t *)arg1 == BOOL_TRUE ) {	/* shortcut, sibling changed */
+	if (*(bool_t *)arg1 == BOOL_TRUE) {	/* shortcut, sibling changed */
 		return cbrval;
 	}
 
-	state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-	if ( state != MAP_NDR_CHANGE &&
-	     state != MAP_NDR_NOCHNG ) {
+	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+	if (state != MAP_NDR_CHANGE &&
+	     state != MAP_NDR_NOCHNG) {
 		/*
 		 * if dir is now a file then it has
 		 * certainly changed.
 		 */
 		state = MAP_NDR_CHANGE;
-		inomap_set_state( cb_inomap_contextp, statp->bs_ino, state );
+		inomap_set_state(cb_inomap_contextp, statp->bs_ino, state);
 	}
-	if ( state == MAP_NDR_CHANGE ) {
+	if (state == MAP_NDR_CHANGE) {
 		/* Directory entries back up the hierarchy must get */
 		/* dumped - as either MAP_DIR_SUPPRT/MAP_DIR_CHANGE */
-		*( bool_t * )arg1 = BOOL_TRUE;
+		*(bool_t *)arg1 = BOOL_TRUE;
 	}
 	return cbrval;
 }
 
 
 static void
-cb_accuminit_sz( void )
+cb_accuminit_sz(void)
 {
 	cb_datasz = 0;
 	cb_hdrsz = 0;
@@ -782,10 +782,10 @@ cb_accuminit_sz( void )
  * cb_accum accumulates the dump space.
  */
 static void
-cb_spinit( void )
+cb_spinit(void)
 {
 	cb_startptix = 0;
-	cb_incr = (cb_datasz + cb_hdrsz) / ( off64_t )cb_startptcnt;
+	cb_incr = (cb_datasz + cb_hdrsz) / (off64_t)cb_startptcnt;
 	cb_target = 0; /* so first ino will push us over the edge */
 	cb_accum = 0;
 }
@@ -809,10 +809,10 @@ typedef enum {
 
 /* ARGSUSED */
 static int
-cb_startpt( void *arg1,
+cb_startpt(void *arg1,
 	    jdm_fshandle_t *fshandlep,
 	    int fsfd,
-	    xfs_bstat_t *statp )
+	    xfs_bstat_t *statp)
 {
 	register int state;
 
@@ -821,31 +821,31 @@ cb_startpt( void *arg1,
 	off64_t qty;	/* amount of a SPLIT file to skip */
 	action_t action;
 
-	( *inomap_statdonep )++;
+	(*inomap_statdonep)++;
 
 	/* skip if no links
 	 */
-	if ( statp->bs_nlink == 0 ) {
+	if (statp->bs_nlink == 0) {
 		return 0;
 	}
 
 	/* skip if not in inomap or not a non-dir
 	 */
-	state = inomap_get_state( cb_inomap_contextp, statp->bs_ino );
-	if ( state != MAP_NDR_CHANGE ) {
+	state = inomap_get_state(cb_inomap_contextp, statp->bs_ino);
+	if (state != MAP_NDR_CHANGE) {
 		return 0;
 	}
 
-	assert( cb_startptix < cb_startptcnt );
+	assert(cb_startptix < cb_startptcnt);
 
-	estimate = estimate_dump_space( statp );
-	cb_accum += estimate + ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
+	estimate = estimate_dump_space(statp);
+	cb_accum += estimate + (EXTENTHDR_SZ * (statp->bs_extents + 1));
 
 	/* loop until no new start points found. loop is necessary
 	 * to handle the pathological case of a huge file so big it
 	 * spans several streams.
 	 */
-	action = ( action_t )HOLD; /* irrelevant, but demanded by lint */
+	action = (action_t)HOLD; /* irrelevant, but demanded by lint */
 	do {
 		/* decide what to do: hold, bump, or split. there are
 		 * 8 valid cases to consider:
@@ -874,69 +874,69 @@ cb_startpt( void *arg1,
 		 *    accum incl. this file is would be way beyond the
 		 *    target: HOLD.
 		 */
-		if ( cb_target - old_accum >= TOO_SHY ) {
-			if ( cb_target - cb_accum >= TOO_SHY ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum <= cb_target ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum - cb_target < TOO_BOLD ) {
-				action = ( action_t )HOLD;
+		if (cb_target - old_accum >= TOO_SHY) {
+			if (cb_target - cb_accum >= TOO_SHY) {
+				action = (action_t)HOLD;
+			} else if (cb_accum <= cb_target) {
+				action = (action_t)HOLD;
+			} else if (cb_accum - cb_target < TOO_BOLD) {
+				action = (action_t)HOLD;
 			} else {
-				action = ( action_t )SPLIT;
+				action = (action_t)SPLIT;
 			}
 		} else {
-			if ( cb_target - cb_accum >= TOO_SHY ) {
-				action = ( action_t )YELL;
-			} else if ( cb_accum < cb_target ) {
-				action = ( action_t )HOLD;
-			} else if ( cb_accum - cb_target < TOO_BOLD ) {
-				if ( cb_accum - cb_target >=
-						      cb_target - old_accum ) {
-					action = ( action_t )BUMP;
+			if (cb_target - cb_accum >= TOO_SHY) {
+				action = (action_t)YELL;
+			} else if (cb_accum < cb_target) {
+				action = (action_t)HOLD;
+			} else if (cb_accum - cb_target < TOO_BOLD) {
+				if (cb_accum - cb_target >=
+						      cb_target - old_accum) {
+					action = (action_t)BUMP;
 				} else {
-					action = ( action_t )HOLD;
+					action = (action_t)HOLD;
 				}
 			} else {
-				action = ( action_t )BUMP;
+				action = (action_t)BUMP;
 			}
 		}
 
 		/* perform the action selected above
 		 */
-		switch ( action ) {
-		case ( action_t )HOLD:
+		switch (action) {
+		case (action_t)HOLD:
 			break;
-		case ( action_t )BUMP:
+		case (action_t)BUMP:
 			cb_startptp->sp_ino = statp->bs_ino;
 			cb_startptp->sp_offset = 0;
 			cb_startptix++;
 			cb_startptp++;
 			cb_target += cb_incr;
-			if ( cb_startptix == cb_startptcnt ) {
+			if (cb_startptix == cb_startptcnt) {
 				return 1; /* done; abort the iteration */
 			}
 			break;
-		case ( action_t )SPLIT:
+		case (action_t)SPLIT:
 			cb_startptp->sp_ino = statp->bs_ino;
-			qty = ( cb_target - old_accum )
+			qty = (cb_target - old_accum)
 			      &
-			      ~( off64_t )( BBSIZE - 1 );
+			      ~(off64_t)(BBSIZE - 1);
 			cb_startptp->sp_offset =
-					quantity2offset( fshandlep,
+					quantity2offset(fshandlep,
 							 statp,
-							 qty );
+							 qty);
 			cb_startptix++;
 			cb_startptp++;
 			cb_target += cb_incr;
-			if ( cb_startptix == cb_startptcnt ) {
+			if (cb_startptix == cb_startptcnt) {
 				return 1; /* done; abort the iteration */
 			}
 			break;
 		default:
-			assert( 0 );
+			assert(0);
 			return 1;
 		}
-	} while ( action == ( action_t )BUMP || action == ( action_t )SPLIT );
+	} while (action == (action_t)BUMP || action == (action_t)SPLIT);
 
 	return 0;
 }
@@ -948,7 +948,7 @@ cb_startpt( void *arg1,
  */
 struct i2gseg {
 	uint64_t s_valid;
-	gen_t s_gen[ INOPERSEG ];
+	gen_t s_gen[INOPERSEG];
 };
 typedef struct i2gseg i2gseg_t;
 
@@ -966,15 +966,15 @@ static struct inomap {
 } inomap;
 
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
@@ -1019,22 +1019,22 @@ SEG_SET_BITS( seg_t *segp, xfs_ino_t ino, int state )
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
 
@@ -1044,9 +1044,9 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
 /* context for inomap construction - initialized by map_init
  */
 static int
-inomap_init( int igrpcnt )
+inomap_init(int igrpcnt)
 {
-	assert( sizeof( hnk_t ) == HNKSZ );
+	assert(sizeof(hnk_t) == HNKSZ);
 
 	/* lastseg must be initialized with -1 offsets since
 	 * no segments have been added yet */
@@ -1055,58 +1055,58 @@ inomap_init( int igrpcnt )
 	inomap.hnkmaplen = (igrpcnt + SEGPERHNK - 1) / SEGPERHNK;
 	inomap.hnkmap = (hnk_t *)malloc(inomap.hnkmaplen * HNKSZ);
 	inomap.i2gmap = (i2gseg_t *)
-		calloc( inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t) );
+		calloc(inomap.hnkmaplen * SEGPERHNK, sizeof(i2gseg_t));
 	if (!inomap.hnkmap || !inomap.i2gmap)
 		return -1;
 	return 0;
 }
 
 uint64_t
-inomap_getsz( void )
+inomap_getsz(void)
 {
 	return (inomap.lastseg.hnkoff + 1) * HNKSZ;
 }
 
 static inline bool_t
-inomap_validaddr( seg_addr_t *addrp )
+inomap_validaddr(seg_addr_t *addrp)
 {
 	int maxseg;
 
-	if ( addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff )
+	if (addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff)
 		return BOOL_FALSE;
 
-	maxseg = ( addrp->hnkoff == inomap.lastseg.hnkoff ) ?
+	maxseg = (addrp->hnkoff == inomap.lastseg.hnkoff) ?
 			inomap.lastseg.segoff : SEGPERHNK - 1;
 
-	if ( addrp->segoff < 0 || addrp->segoff > maxseg )
+	if (addrp->segoff < 0 || addrp->segoff > maxseg)
 		return BOOL_FALSE;
 
 	return BOOL_TRUE;
 }
 
 static inline hnk_t *
-inomap_addr2hnk( seg_addr_t *addrp )
+inomap_addr2hnk(seg_addr_t *addrp)
 {
 	return &inomap.hnkmap[addrp->hnkoff];
 }
 
 static inline seg_t *
-inomap_addr2seg( seg_addr_t *addrp )
+inomap_addr2seg(seg_addr_t *addrp)
 {
-	hnk_t *hunkp = inomap_addr2hnk( addrp );
+	hnk_t *hunkp = inomap_addr2hnk(addrp);
 	return &hunkp->seg[addrp->segoff];
 }
 
 static inline int
-inomap_addr2segix( seg_addr_t *addrp )
+inomap_addr2segix(seg_addr_t *addrp)
 {
-	return ( addrp->hnkoff * SEGPERHNK ) + addrp->segoff;
+	return (addrp->hnkoff * SEGPERHNK) + addrp->segoff;
 }
 
 static inline int
-inomap_lastseg( int hnkoff )
+inomap_lastseg(int hnkoff)
 {
-	if ( hnkoff == inomap.lastseg.hnkoff )
+	if (hnkoff == inomap.lastseg.hnkoff)
 		return inomap.lastseg.segoff;
 	else
 		return SEGPERHNK - 1;
@@ -1116,7 +1116,7 @@ inomap_lastseg( int hnkoff )
  * order. adds a new segment to the inomap and ino-to-gen map.
  */
 static int
-cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
+cb_add_inogrp(void *arg1, int fsfd, xfs_inogrp_t *inogrp)
 {
 	hnk_t *hunk;
 	seg_t *segp;
@@ -1149,13 +1149,13 @@ cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 			       SEGPERHNK * sizeof(i2gseg_t));
 		}
 
-		memset(inomap_addr2hnk( lastsegp ), 0, HNKSZ);
+		memset(inomap_addr2hnk(lastsegp), 0, HNKSZ);
 	}
 
-	hunk = inomap_addr2hnk( lastsegp );
+	hunk = inomap_addr2hnk(lastsegp);
 	hunk->maxino = inogrp->xi_startino + INOPERSEG - 1;
 
-	segp = inomap_addr2seg( lastsegp );
+	segp = inomap_addr2seg(lastsegp);
 	segp->base = inogrp->xi_startino;
 
 	return 0;
@@ -1164,41 +1164,41 @@ cb_add_inogrp( void *arg1, int fsfd, xfs_inogrp_t *inogrp )
 /* called for every ino to be added to the map.
  */
 static void
-inomap_add( void *contextp, xfs_ino_t ino, gen_t gen, int state )
+inomap_add(void *contextp, xfs_ino_t ino, gen_t gen, int state)
 {
-	inomap_set_state( contextp, ino, state );
-	inomap_set_gen( contextp, ino, gen );
+	inomap_set_state(contextp, ino, state);
+	inomap_set_gen(contextp, ino, gen);
 }
 
 void *
-inomap_alloc_context( void )
+inomap_alloc_context(void)
 {
-	void *addr = calloc( 1, sizeof(seg_addr_t) );
+	void *addr = calloc(1, sizeof(seg_addr_t));
 	if (!addr) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("failed to allocate inomap context: %s\n"),
-		      strerror(errno) );
+		      strerror(errno));
 	}
 	return addr;
 }
 
 void
-inomap_reset_context( void *p )
+inomap_reset_context(void *p)
 {
-	memset( p, 0, sizeof(seg_addr_t) );
+	memset(p, 0, sizeof(seg_addr_t));
 }
 
 void
-inomap_free_context( void *p )
+inomap_free_context(void *p)
 {
-	free( p );
+	free(p);
 }
 
 /* use binary search to find the hunk containing the given inode.
  * use the supplied addr as the starting point for the search.
  */
 static bool_t
-inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
+inomap_find_hnk(seg_addr_t *addrp, xfs_ino_t ino)
 {
 	hnk_t *hunkp;
 	int lower;
@@ -1206,12 +1206,12 @@ inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
 
 	lower = 0;
 	upper = inomap.lastseg.hnkoff;
-	while ( upper >= lower ) {
-		hunkp = inomap_addr2hnk( addrp );
+	while (upper >= lower) {
+		hunkp = inomap_addr2hnk(addrp);
 
-		if ( hunkp->seg[0].base > ino ) {
+		if (hunkp->seg[0].base > ino) {
 			upper = addrp->hnkoff - 1;
-		} else if ( hunkp->maxino < ino ) {
+		} else if (hunkp->maxino < ino) {
 			lower = addrp->hnkoff + 1;
 		} else {
 			return BOOL_TRUE;
@@ -1230,29 +1230,29 @@ inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
  * point for the search.
  */
 static bool_t
-inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
+inomap_find_seg(seg_addr_t *addrp, xfs_ino_t ino)
 {
 	seg_t *segp;
 	int lower;
 	int upper;
 
-	if ( !inomap_validaddr( addrp ) ) {
-		inomap_reset_context( addrp );
+	if (!inomap_validaddr(addrp) ) {
+		inomap_reset_context(addrp);
 	}
 
-	if ( !inomap_find_hnk( addrp, ino ) )
+	if (!inomap_find_hnk(addrp, ino) )
 		return BOOL_FALSE;
 
 	/* find the correct segment */
 	lower = 0;
 	upper = inomap_lastseg(addrp->hnkoff);
 
-	while ( upper >= lower ) {
-		segp = inomap_addr2seg( addrp );
+	while (upper >= lower) {
+		segp = inomap_addr2seg(addrp);
 
-		if ( segp->base > ino ) {
+		if (segp->base > ino) {
 			upper = addrp->segoff - 1;
-		} else if ( segp->base + INOPERSEG <= ino ) {
+		} else if (segp->base + INOPERSEG <= ino) {
 			lower = addrp->segoff + 1;
 		} else {
 			return BOOL_TRUE;
@@ -1265,28 +1265,28 @@ inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
 }
 
 static xfs_ino_t
-inomap_iter( void *contextp, int statemask )
+inomap_iter(void *contextp, int statemask)
 {
 	xfs_ino_t ino, endino;
 	seg_t *segp;
 	seg_addr_t *addrp = (seg_addr_t *)contextp;
 
-	for ( ;
+	for (;
 	      addrp->hnkoff <= inomap.lastseg.hnkoff;
-	      addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0 ) {
+	      addrp->hnkoff++, addrp->segoff = 0, addrp->inooff = 0) {
 
-		for ( ;
+		for (;
 		      addrp->segoff <= inomap_lastseg(addrp->hnkoff);
-		      addrp->segoff++, addrp->inooff = 0 ) {
+		      addrp->segoff++, addrp->inooff = 0) {
 
-			segp = inomap_addr2seg( addrp );
+			segp = inomap_addr2seg(addrp);
 
 			ino = segp->base + addrp->inooff;
 			endino = segp->base + INOPERSEG;
-			for ( ; ino < endino ; ino++, addrp->inooff++ ) {
+			for (; ino < endino ; ino++, addrp->inooff++) {
 				int st;
-				st = SEG_GET_BITS( segp, ino );
-				if ( statemask & ( 1 << st )) {
+				st = SEG_GET_BITS(segp, ino);
+				if (statemask & (1 << st)) {
 					addrp->inooff++; /* for next call */
 					return ino;
 				}
@@ -1324,7 +1324,7 @@ inomap_next_dir(void *contextp, xfs_ino_t lastino)
 }
 
 static int
-inomap_set_state( void *contextp, xfs_ino_t ino, int state )
+inomap_set_state(void *contextp, xfs_ino_t ino, int state)
 {
 	int oldstate;
 	seg_addr_t *addrp;
@@ -1332,31 +1332,31 @@ inomap_set_state( void *contextp, xfs_ino_t ino, int state )
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino) )
 		return MAP_INO_UNUSED;
 
-	segp = inomap_addr2seg( addrp );
+	segp = inomap_addr2seg(addrp);
 
-	oldstate = SEG_GET_BITS( segp, ino );
-	SEG_SET_BITS( segp, ino, state );
+	oldstate = SEG_GET_BITS(segp, ino);
+	SEG_SET_BITS(segp, ino, state);
 
 	return oldstate;
 }
 
 int
-inomap_get_state( void *contextp, xfs_ino_t ino )
+inomap_get_state(void *contextp, xfs_ino_t ino)
 {
 	seg_addr_t *addrp;
 	seg_addr_t addr;
 	seg_t *segp;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino) )
 		return MAP_INO_UNUSED;
 
-	segp = inomap_addr2seg( addrp );
+	segp = inomap_addr2seg(addrp);
 
-	return SEG_GET_BITS( segp, ino );
+	return SEG_GET_BITS(segp, ino);
 }
 
 static void
@@ -1369,11 +1369,11 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino) )
 		return;
 
-	segp = inomap_addr2seg( addrp );
-	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
+	segp = inomap_addr2seg(addrp);
+	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
 
 	relino = ino - segp->base;
 	i2gsegp->s_valid |= (uint64_t)1 << relino;
@@ -1381,7 +1381,7 @@ inomap_set_gen(void *contextp, xfs_ino_t ino, gen_t gen)
 }
 
 int
-inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
+inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen)
 {
 	seg_addr_t *addrp;
 	seg_addr_t addr;
@@ -1390,14 +1390,14 @@ inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 	xfs_ino_t relino;
 
 	addrp = contextp ? (seg_addr_t *)contextp : &addr;
-	if ( !inomap_find_seg( addrp, ino ) )
+	if (!inomap_find_seg(addrp, ino) )
 		return 1;
 
-	segp = inomap_addr2seg( addrp );
-	i2gsegp = &inomap.i2gmap[inomap_addr2segix( addrp )];
+	segp = inomap_addr2seg(addrp);
+	i2gsegp = &inomap.i2gmap[inomap_addr2segix(addrp)];
 
 	relino = ino - segp->base;
-	if ( ! (i2gsegp->s_valid & ((uint64_t)1 << relino)) )
+	if (! (i2gsegp->s_valid & ((uint64_t)1 << relino)))
 		return 1;
 
 	*gen = i2gsegp->s_gen[relino];
@@ -1405,21 +1405,21 @@ inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen )
 }
 
 void
-inomap_writehdr( content_inode_hdr_t *scwhdrp )
+inomap_writehdr(content_inode_hdr_t *scwhdrp)
 {
 	/* update the inomap info in the content header
 	 */
 	scwhdrp->cih_inomap_hnkcnt = inomap.lastseg.hnkoff + 1;
-	scwhdrp->cih_inomap_segcnt = inomap_addr2segix( &inomap.lastseg ) + 1;
-	scwhdrp->cih_inomap_dircnt = ( uint64_t )cb_dircnt;
-	scwhdrp->cih_inomap_nondircnt = ( uint64_t )cb_nondircnt;
-	scwhdrp->cih_inomap_firstino = inomap.hnkmap[0].seg[ 0 ].base;
+	scwhdrp->cih_inomap_segcnt = inomap_addr2segix(&inomap.lastseg) + 1;
+	scwhdrp->cih_inomap_dircnt = (uint64_t)cb_dircnt;
+	scwhdrp->cih_inomap_nondircnt = (uint64_t)cb_nondircnt;
+	scwhdrp->cih_inomap_firstino = inomap.hnkmap[0].seg[0].base;
 	scwhdrp->cih_inomap_lastino = inomap.hnkmap[inomap.lastseg.hnkoff].maxino;
-	scwhdrp->cih_inomap_datasz = ( uint64_t )cb_datasz;
+	scwhdrp->cih_inomap_datasz = (uint64_t)cb_datasz;
 }
 
 rv_t
-inomap_dump( drive_t *drivep )
+inomap_dump(drive_t *drivep)
 {
 	seg_addr_t addr;
 	hnk_t *hnkp;
@@ -1427,22 +1427,22 @@ inomap_dump( drive_t *drivep )
 
 	/* use write_buf to dump the hunks
 	 */
-	for ( addr.hnkoff = 0 ;
+	for (addr.hnkoff = 0 ;
 	      addr.hnkoff <= inomap.lastseg.hnkoff ;
-	      addr.hnkoff++ ) {
+	      addr.hnkoff++) {
 		int rval;
 		rv_t rv;
 		drive_ops_t *dop = drivep->d_opsp;
 
-		hnkp = inomap_addr2hnk( &addr );
+		hnkp = inomap_addr2hnk(&addr);
 
 		xlate_hnk(hnkp, &tmphnkp, 1);
-		rval = write_buf( ( char * )&tmphnkp,
-				  sizeof( tmphnkp ),
-				  ( void * )drivep,
-				  ( gwbfp_t )dop->do_get_write_buf,
-				  ( wfp_t )dop->do_write );
-		switch ( rval ) {
+		rval = write_buf((char *)&tmphnkp,
+				  sizeof(tmphnkp),
+				  (void *)drivep,
+				  (gwbfp_t)dop->do_get_write_buf,
+				  (wfp_t)dop->do_write);
+		switch (rval) {
 		case 0:
 			rv = RV_OK;
 			break;
@@ -1461,7 +1461,7 @@ inomap_dump( drive_t *drivep )
 			rv = RV_CORE;
 			break;
 		}
-		if ( rv != RV_OK ) {
+		if (rv != RV_OK) {
 			return rv;
 		}
 	}
@@ -1470,38 +1470,38 @@ inomap_dump( drive_t *drivep )
 }
 
 static int
-subtreelist_parse( jdm_fshandle_t *fshandlep,
+subtreelist_parse(jdm_fshandle_t *fshandlep,
 		   int fsfd,
 		   xfs_bstat_t *rootstatp,
 		   char *subtreebuf[],
-		   ix_t subtreecnt )
+		   ix_t subtreecnt)
 {
 	ix_t subtreeix;
 
 	/* add the root ino to the dump
 	 */
-	cb_add( NULL, fshandlep, fsfd, rootstatp );
+	cb_add(NULL, fshandlep, fsfd, rootstatp);
 
 	/* do a recursive descent for each subtree specified
 	 */
-	for ( subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++ ) {
+	for (subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++) {
 		int cbrval = 0;
-		char *currentpath = subtreebuf[ subtreeix ];
-		assert( *currentpath != '/' );
-		( void )diriter( fshandlep,
+		char *currentpath = subtreebuf[subtreeix];
+		assert(*currentpath != '/');
+		(void)diriter(fshandlep,
 				 fsfd,
 				 rootstatp,
 				 subtreelist_parse_cb,
-				 ( void * )currentpath,
+				 (void *)currentpath,
 				 &cbrval,
 				 NULL,
-				 0 );
-		if ( cbrval != 1 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_INOMAP,
+				 0);
+		if (cbrval != 1) {
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_INOMAP,
 			      "%s: %s\n",
 			      cbrval == 0 ? _("subtree not present")
 					  : _("invalid subtree specified"),
-			      currentpath );
+			      currentpath);
 			return -1;
 		}
 	}
@@ -1510,30 +1510,30 @@ subtreelist_parse( jdm_fshandle_t *fshandlep,
 }
 
 static int
-subtreelist_parse_cb( void *arg1,
+subtreelist_parse_cb(void *arg1,
 		      jdm_fshandle_t *fshandlep,
 		      int fsfd,
 		      xfs_bstat_t *statp,
-		      char *name  )
+		      char *name)
 {
 	int cbrval = 0;
 
 	/* arg1 is used to carry the tail of the subtree path
 	 */
-	char *subpath = ( char * )arg1;
+	char *subpath = (char *)arg1;
 
 	/* temporarily terminate the subpath at the next slash
 	 */
-	char *nextslash = strchr( subpath, '/' );
-	if ( nextslash ) {
+	char *nextslash = strchr(subpath, '/');
+	if (nextslash) {
 		*nextslash = 0;
 	}
 
 	/* if the first element of the subpath doesn't match this
 	 * directory entry, try the next entry.
 	 */
-	if ( strcmp( subpath, name )) {
-		if ( nextslash ) {
+	if (strcmp(subpath, name)) {
+		if (nextslash) {
 			*nextslash = '/';
 		}
 		return 0;
@@ -1541,15 +1541,15 @@ subtreelist_parse_cb( void *arg1,
 
 	/* it matches, so add ino to list and continue down the path
 	 */
-	cb_add( NULL, fshandlep, fsfd, statp );
+	cb_add(NULL, fshandlep, fsfd, statp);
 
-	if ( nextslash ) {
+	if (nextslash) {
 
 		/* if we're not at the end of the path, yet the current
 		 * path element is not a directory, complain and abort the
 		 * iteration in a way which terminates the application
 		 */
-		if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
+		if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 			*nextslash = '/';
 			return 2;
 		}
@@ -1560,14 +1560,14 @@ subtreelist_parse_cb( void *arg1,
 
 		/* peel the first element of the subpath and recurse
 		*/
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtreelist_parse_cb,
-				 ( void * )( nextslash + 1 ),
+				 (void *)(nextslash + 1),
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 		return cbrval;
 
 	} else {
@@ -1576,43 +1576,43 @@ subtreelist_parse_cb( void *arg1,
 		 * to the inomap.
 		 */
 
-		if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
+		if ((statp->bs_mode & S_IFMT) != S_IFDIR) {
 			return 1;
 		}
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtree_descend_cb,
 				 NULL,
 				 &cbrval,
 				 0,
-				 0 );
+				 0);
 		return 1;
 	}
 }
 
 static int
-subtree_descend_cb( void *arg1,
+subtree_descend_cb(void *arg1,
 		    jdm_fshandle_t *fshandlep,
 		    int fsfd,
 		    xfs_bstat_t *statp,
-		    char *name  )
+		    char *name)
 {
 	int cbrval = 0;
 
-	cb_add( NULL, fshandlep, fsfd, statp );
+	cb_add(NULL, fshandlep, fsfd, statp);
 
-	if ( ( statp->bs_mode & S_IFMT ) == S_IFDIR ) {
+	if ((statp->bs_mode & S_IFMT) == S_IFDIR) {
 
-		( void )diriter( fshandlep,
+		(void)diriter(fshandlep,
 				 fsfd,
 				 statp,
 				 subtree_descend_cb,
 				 NULL,
 				 &cbrval,
 				 NULL,
-				 0 );
+				 0);
 	}
 
 	return cbrval;
@@ -1624,10 +1624,10 @@ subtree_descend_cb( void *arg1,
 #define BMAP_LEN	512
 
 static off64_t
-quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
+quantity2offset(jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty)
 {
 	int fd;
-	getbmapx_t bmap[ BMAP_LEN ];
+	getbmapx_t bmap[BMAP_LEN];
 	off64_t offset;
 	off64_t offset_next;
 	off64_t qty_accum;
@@ -1644,51 +1644,51 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 	offset = 0;
 	offset_next = 0;
 	qty_accum = 0;
-	bmap[ 0 ].bmv_offset = 0;
-	bmap[ 0 ].bmv_length = -1;
-	bmap[ 0 ].bmv_count = BMAP_LEN;
-	bmap[ 0 ].bmv_iflags = BMV_IF_NO_DMAPI_READ;
-	bmap[ 0 ].bmv_entries = -1;
-	fd = jdm_open( fshandlep, statp, O_RDONLY );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+	bmap[0].bmv_offset = 0;
+	bmap[0].bmv_length = -1;
+	bmap[0].bmv_count = BMAP_LEN;
+	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
+	bmap[0].bmv_entries = -1;
+	fd = jdm_open(fshandlep, statp, O_RDONLY);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 		      "could not open ino %llu to read extent map: %s\n"),
 		      statp->bs_ino,
-		      strerror( errno ));
+		      strerror(errno));
 		return 0;
 	}
 
-	for ( ; ; ) {
+	for (; ;) {
 		int eix;
 		int rval;
 
-		rval = ioctl( fd, XFS_IOC_GETBMAPX, bmap );
-		if ( rval ) {
-			mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+		rval = ioctl(fd, XFS_IOC_GETBMAPX, bmap);
+		if (rval) {
+			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 			      "could not read extent map for ino %llu: %s\n"),
 			      statp->bs_ino,
-			      strerror( errno ));
-			( void )close( fd );
+			      strerror(errno));
+			(void)close(fd);
 			return 0;
 		}
 
-		if ( bmap[ 0 ].bmv_entries <= 0 ) {
-			assert( bmap[ 0 ].bmv_entries == 0 );
-			( void )close( fd );
+		if (bmap[0].bmv_entries <= 0) {
+			assert(bmap[0].bmv_entries == 0);
+			(void)close(fd);
 			return offset_next;
 		}
 
-		for ( eix = 1 ; eix <= bmap[ 0 ].bmv_entries ; eix++ ) {
-			getbmapx_t *bmapp = &bmap[ eix ];
+		for (eix = 1 ; eix <= bmap[0].bmv_entries ; eix++) {
+			getbmapx_t *bmapp = &bmap[eix];
 			off64_t qty_new;
-			if ( bmapp->bmv_block == -1 ) {
+			if (bmapp->bmv_block == -1) {
 				continue; /* hole */
 			}
 			offset = bmapp->bmv_offset * BBSIZE;
 			qty_new = qty_accum + bmapp->bmv_length * BBSIZE;
-			if ( qty_new >= qty ) {
-				( void )close( fd );
-				return offset + ( qty - qty_accum );
+			if (qty_new >= qty) {
+				(void)close(fd);
+				return offset + (qty - qty_accum);
 			}
 			offset_next = offset + bmapp->bmv_length * BBSIZE;
 			qty_accum = qty_new;
@@ -1699,9 +1699,9 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
 
 
 static off64_t
-estimate_dump_space( xfs_bstat_t *statp )
+estimate_dump_space(xfs_bstat_t *statp)
 {
-	switch ( statp->bs_mode & S_IFMT ) {
+	switch (statp->bs_mode & S_IFMT) {
 	case S_IFREG:
 		/* very rough: must improve this.  If GETOPT_DUMPASOFFLINE was
 		 * specified and the HSM provided an estimate, then use it.
@@ -1719,7 +1719,7 @@ estimate_dump_space( xfs_bstat_t *statp )
 			if (HsmEstimateFileSpace(hsm_fs_ctxtp, NULL, statp, &bytes, accurate))
 				return bytes;
 		}
-		return statp->bs_blocks * ( off64_t )statp->bs_blksize;
+		return statp->bs_blocks * (off64_t)statp->bs_blksize;
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFDIR:
@@ -1734,11 +1734,11 @@ estimate_dump_space( xfs_bstat_t *statp )
 	*/
 		return 0;
 	default:
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 		      "unknown inode type: ino=%llu, mode=0x%04x 0%06o\n"),
 		      statp->bs_ino,
 		      statp->bs_mode,
-		      statp->bs_mode );
+		      statp->bs_mode);
 		return 0;
 	}
 }
diff --git a/dump/inomap.h b/dump/inomap.h
index fb9bbf7..64b769a 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -47,7 +47,7 @@ struct xfs_bstat;
  * fall at file boundaries. returns BOOL_FALSE if error encountered (should
  * abort the dump; else returns BOOL_TRUE.
  */
-extern bool_t inomap_build( void *fshandlep,
+extern bool_t inomap_build(void *fshandlep,
 			    int fsfd,
 			    struct xfs_bstat *rootstatp,
 			    bool_t last,
@@ -64,26 +64,26 @@ extern bool_t inomap_build( void *fshandlep,
 			    ix_t *statphasep,
 			    ix_t *statpassp,
 			    size64_t statcnt,
-			    size64_t *statdonep );
+			    size64_t *statdonep);
 
-extern uint64_t inomap_getsz( void );
+extern uint64_t inomap_getsz(void);
 
 /* inomap_skip - tell inomap about inodes to skip in the dump
  */
-extern void inomap_skip( xfs_ino_t ino );
+extern void inomap_skip(xfs_ino_t ino);
 
 
 /* inomap_writehdr - updates the write header with inomap-private info
  * to be communicated to the restore side
  */
-extern void inomap_writehdr( content_inode_hdr_t *scwhdrp );
+extern void inomap_writehdr(content_inode_hdr_t *scwhdrp);
 
 
 /* inomap_dump - dumps the map to media - content-abstraction-knowledgable
  *
  * returns error from media write op
  */
-extern rv_t inomap_dump( drive_t *drivep );
+extern rv_t inomap_dump(drive_t *drivep);
 
 
 /* map state values
@@ -111,16 +111,16 @@ struct seg {
 
 typedef struct seg seg_t;
 
-#define INOPERSEG	( sizeof( (( seg_t * )0 )->lobits ) * NBBY )
+#define INOPERSEG	(sizeof(((seg_t *)0)->lobits) * NBBY)
 
-#define HNKSZ		( 4 * PGSZ )
-#define SEGPERHNK	( ( HNKSZ / sizeof( seg_t )) - 1 )
+#define HNKSZ		(4 * PGSZ)
+#define SEGPERHNK	((HNKSZ / sizeof(seg_t)) - 1)
 
 struct hnk {
-	seg_t seg[ SEGPERHNK ];
+	seg_t seg[SEGPERHNK];
 	xfs_ino_t maxino;
 	struct hnk *nextp;		/* no longer used, kept for binary compat */
-	char pad[sizeof( seg_t ) - sizeof( xfs_ino_t ) - sizeof( struct hnk * )];
+	char pad[sizeof(seg_t) - sizeof(xfs_ino_t) - sizeof(struct hnk *)];
 };
 
 typedef struct hnk hnk_t;
@@ -129,11 +129,11 @@ typedef struct hnk hnk_t;
  * requires a pointer to a context block, obtained from
  * inomap_alloc_context(), and released by inomap_free_context().
  */
-extern void *inomap_alloc_context( void );
-extern void inomap_reset_context( void *contextp );
-extern void inomap_free_context( void *contextp );
-extern int inomap_get_state( void *contextp, xfs_ino_t ino );
-extern int inomap_get_gen( void *contextp, xfs_ino_t ino, gen_t *gen );
+extern void *inomap_alloc_context(void);
+extern void inomap_reset_context(void *contextp);
+extern void inomap_free_context(void *contextp);
+extern int inomap_get_state(void *contextp, xfs_ino_t ino);
+extern int inomap_get_gen(void *contextp, xfs_ino_t ino, gen_t *gen);
 
 
 /* generators returning the next dir or non-dir ino selected in this dump.
diff --git a/dump/var.c b/dump/var.c
index 6e3ead0..c9f251a 100644
--- a/dump/var.c
+++ b/dump/var.c
@@ -34,137 +34,137 @@
 #include "global.h"
 #include "inventory.h"
 
-static void var_skip_recurse( char *, void ( * )( xfs_ino_t ));
-static int  var_create_component( char * );
+static void var_skip_recurse(char *, void (*)(xfs_ino_t));
+static int  var_create_component(char *);
 
 void
-var_create( void )
+var_create(void)
 {
 	char path[PATH_MAX];
 	char *p;
 
-	p = strcpy( path, XFSDUMP_DIRPATH );
-	mlog( MLOG_DEBUG, "creating directory %s\n", path );
+	p = strcpy(path, XFSDUMP_DIRPATH);
+	mlog(MLOG_DEBUG, "creating directory %s\n", path);
 
 	do {
 		p++;
-		if ( *p == '/' ) {
+		if (*p == '/') {
 			*p = '\0';
-			if ( ! var_create_component( path ) )
+			if (! var_create_component(path) )
 				return;
 			*p = '/';
 		}
-	} while ( *p );
+	} while (*p);
 
-	( void ) var_create_component( path );
+	(void) var_create_component(path);
 }
 
 static int
-var_create_component( char *path )
+var_create_component(char *path)
 {
-	int rval = mkdir( path, 0755 );
+	int rval = mkdir(path, 0755);
 
-	if ( rval && errno != EEXIST ) {
-		mlog( MLOG_NORMAL, _("unable to create %s: %s\n"),
-		      path, strerror( errno ));
+	if (rval && errno != EEXIST) {
+		mlog(MLOG_NORMAL, _("unable to create %s: %s\n"),
+		      path, strerror(errno));
 		return 0;
 	}
-	if ( rval == 0 ) {
-		rval = chown( path, 0, 0 );
-		if ( rval ) {
-			mlog( MLOG_NORMAL, _("unable to chown %s: %s\n"),
-			      path, strerror( errno ));
+	if (rval == 0) {
+		rval = chown(path, 0, 0);
+		if (rval) {
+			mlog(MLOG_NORMAL, _("unable to chown %s: %s\n"),
+			      path, strerror(errno));
 		}
 	}
 	return 1;
 }
 
 void
-var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ))
+var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino))
 {
 	uuid_t fsid;
 	int rval;
 
 	/* see if the fs uuid's match
 	 */
-	rval = fs_getid( XFSDUMP_DIRPATH, &fsid );
-	if ( rval ) {
+	rval = fs_getid(XFSDUMP_DIRPATH, &fsid);
+	if (rval) {
 #ifdef HIDDEN
                 /* NOTE: this will happen for non-XFS file systems */
                 /*       and is expected, so no msg */
-		mlog( MLOG_NORMAL, _(
+		mlog(MLOG_NORMAL, _(
 		      "unable to determine uuid of fs containing %s: "
 		      "%s\n"),
 		      XFSDUMP_DIRPATH,
-		      strerror( errno ));
+		      strerror(errno));
 #endif
 		return;
 	}
 
-	if ( uuid_compare( *dumped_fsidp, fsid ) != 0) {
+	if (uuid_compare(*dumped_fsidp, fsid) != 0) {
 		return;
 	}
 
 	/* traverse the xfsdump directory, getting inode numbers of it
 	 * and all of its children, and reporting those to the callback.
 	 */
-	var_skip_recurse( XFSDUMP_DIRPATH, cb );
+	var_skip_recurse(XFSDUMP_DIRPATH, cb);
 }
 
 static void
-var_skip_recurse( char *base, void ( *cb )( xfs_ino_t ino ))
+var_skip_recurse(char *base, void (*cb)(xfs_ino_t ino))
 {
 	struct stat64 statbuf;
 	DIR *dirp;
 	struct dirent *direntp;
 	int rval;
 
-	rval = lstat64( base, &statbuf );
-	if ( rval ) {
-		mlog( MLOG_NORMAL, _(
+	rval = lstat64(base, &statbuf);
+	if (rval) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to get status of %s: %s\n"),
 		      base,
-		      strerror( errno ));
+		      strerror(errno));
 		return;
 	}
 
-	mlog( MLOG_DEBUG,
+	mlog(MLOG_DEBUG,
 	      "excluding %s from dump\n",
-	      base );
+	      base);
 
-	( * cb )( statbuf.st_ino );
+	(* cb)(statbuf.st_ino);
 
-	if ( ( statbuf.st_mode & S_IFMT ) != S_IFDIR ) {
+	if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
 		return;
 	}
 
-	dirp = opendir( base );
-	if ( ! dirp ) {
-		mlog( MLOG_NORMAL, _(
+	dirp = opendir(base);
+	if (! dirp) {
+		mlog(MLOG_NORMAL, _(
 		      "unable to open directory %s\n"),
-		      base );
+		      base);
 		return;
 	}
 
-	while ( ( direntp = readdir( dirp )) != NULL ) {
+	while ((direntp = readdir(dirp)) != NULL) {
 		char *path;
 
 		/* skip "." and ".."
 		 */
-		if ( *( direntp->d_name + 0 ) == '.'
+		if (*(direntp->d_name + 0) == '.'
 		     &&
-		     ( *( direntp->d_name + 1 ) == 0
+		     (*(direntp->d_name + 1) == 0
 		       ||
-		       ( *( direntp->d_name + 1 ) == '.'
+		       (*(direntp->d_name + 1) == '.'
 			 &&
-			 *( direntp->d_name + 2 ) == 0 ))) {
+			 *(direntp->d_name + 2) == 0))) {
 			continue;
 		}
 
-		path = open_pathalloc( base, direntp->d_name, 0 );
-		var_skip_recurse( path, cb );
-		free( ( void * )path );
+		path = open_pathalloc(base, direntp->d_name, 0);
+		var_skip_recurse(path, cb);
+		free((void *)path);
 	}
 
-	closedir( dirp );
+	closedir(dirp);
 }
diff --git a/dump/var.h b/dump/var.h
index 889a389..0a8f13d 100644
--- a/dump/var.h
+++ b/dump/var.h
@@ -21,8 +21,8 @@
 /* var.[ch] - abstraction dealing with /var/[lib/]xfsdump/
  */
 
-extern void var_create( void );
+extern void var_create(void);
 
-extern void var_skip( uuid_t *dumped_fsidp, void ( *cb )( xfs_ino_t ino ));
+extern void var_skip(uuid_t *dumped_fsidp, void (*cb)(xfs_ino_t ino));
 
 #endif /* VAR_H */
-- 
2.19.1
