Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40288 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbfANR0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:13 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D288E8666D
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:12 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/13] xfsdump: (10/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:25 +0100
Message-Id: <20190114172528.65250-11-jtulak@redhat.com>
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
 restore/content.c | 2810 ++++++++++++++++++++++-----------------------
 1 file changed, 1405 insertions(+), 1405 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index 078c6b8..24f7e78 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -94,7 +94,7 @@ typedef enum { SYNC_INIT, SYNC_BUSY, SYNC_DONE } sync_t;
 typedef struct { xfs_ino_t eg_ino; off64_t eg_off; } egrp_t;
 	/* extent group descriptor
 	 */
-typedef char label_t[ GLOBAL_HDR_STRING_SZ ];
+typedef char label_t[GLOBAL_HDR_STRING_SZ];
 	/* dump or mobj label
 	 */
 typedef enum { PURP_SEARCH, PURP_DIR, PURP_NONDIR } purp_t;
@@ -106,14 +106,14 @@ typedef off_t dh_t;
 	 * encoded as byte offset plus one of descriptor into descriptor
 	 * portion of persistent state. plus one so DH_NULL can be zero.
 	 */
-#define DH_NULL		( ( dh_t )0 )
+#define DH_NULL		((dh_t)0)
 	/* NULL inv. descriptor handles, to terminate linked descriptor lists.
 	 * must be zero-valued, so memset of pers.s sets freeh to DH_NULL.
 	 */
-#define DH2F( h )	( ( pers_file_t * )( ( char * )descp + ( h - 1 )))
-#define DH2O( h )	( ( pers_obj_t * )( ( char * )descp + ( h - 1 )))
-#define DH2S( h )	( ( pers_strm_t * )( ( char * )descp + ( h - 1 )))
-#define DH2D( h )	( ( pers_desc_t * )( ( char * )descp + ( h - 1 )))
+#define DH2F(h)	((pers_file_t *)((char *)descp + (h - 1)))
+#define DH2O(h)	((pers_obj_t *)((char *)descp + (h - 1)))
+#define DH2S(h)	((pers_strm_t *)((char *)descp + (h - 1)))
+#define DH2D(h)	((pers_desc_t *)((char *)descp + (h - 1)))
 	/* convert file, object, and stream inv. descriptor handle into
 	 * descriptor pointers
 	 */
@@ -226,8 +226,8 @@ struct pers_file {
 
 /* f_flags
  */
-#define PF_INV	( 1 << 0 )
-#define PF_TERM	( 1 << 1 )
+#define PF_INV	(1 << 0)
+#define PF_TERM	(1 << 1)
 
 typedef struct pers_file pers_file_t;
 
@@ -331,7 +331,7 @@ struct stdesc {
 	off_t std_nextoff;
 		/* offset to next descriptor, in bytes relative to this
 		 */
-	char std_path[ 1 ];
+	char std_path[1];
 		/* first character of a NULL-terminated string containing the
 		 * the relative subtree pathname
 		 */
@@ -430,7 +430,7 @@ struct pers {
 			 * have been initialized, and the session history
 			 * has been initialized and validated.
 			 */
-		char dstdir[ MAXPATHLEN ];
+		char dstdir[MAXPATHLEN];
 			/* absolute pathname of the destination directory
 			 */
 		bool_t dstdirisxfspr;
@@ -489,7 +489,7 @@ struct pers {
 			 * up searches in parrest.
 			 */
 
-		partial_rest_t parrest[ STREAM_SIMMAX * 2 - 2 ];
+		partial_rest_t parrest[STREAM_SIMMAX * 2 - 2];
 			/* record of bytes restored to partially restored files.
 			 * Max possible is two per stream except the first
 			 * drive will never finish another drives file and the
@@ -677,8 +677,8 @@ typedef struct tran tran_t;
 
 /* declarations of externally defined global symbols *************************/
 
-extern void usage( void );
-extern bool_t preemptchk( void );
+extern void usage(void);
+extern bool_t preemptchk(void);
 extern char *homedir;
 extern bool_t pipeline;
 extern bool_t stdoutpiped;
@@ -689,13 +689,13 @@ extern size_t pgmask;
 
 /* forward declarations of locally defined static functions ******************/
 
-static void toconly_cleanup( void );
+static void toconly_cleanup(void);
 
-static Media_t *Media_create( ix_t thrdix );
-static void Media_indir( Media_t *Mediap );
-static void Media_indir( Media_t *Mediap );
-static void Media_atnondir( Media_t *Mediap );
-static rv_t Media_mfile_next( Media_t *Mediap,
+static Media_t *Media_create(ix_t thrdix);
+static void Media_indir(Media_t *Mediap);
+static void Media_indir(Media_t *Mediap);
+static void Media_atnondir(Media_t *Mediap);
+static rv_t Media_mfile_next(Media_t *Mediap,
 			      purp_t purp,
 			      sync_t *donesyncp,
 			      dh_t  *filehp,
@@ -705,160 +705,160 @@ static rv_t Media_mfile_next( Media_t *Mediap,
 			      content_hdr_t **crhdrpp,
 			      content_inode_hdr_t **scrhdrpp,
 			      drive_t **drivepp,
-			      filehdr_t *fhdr );
-static void Media_end( Media_t *Mediap );
-static bool_t Media_prompt_change( drive_t *drivep,
+			      filehdr_t *fhdr);
+static void Media_end(Media_t *Mediap);
+static bool_t Media_prompt_change(drive_t *drivep,
 				   purp_t purp,
 				   bag_t *bagp,
 				   bool_t knownholespr,
-				   bool_t maybeholespr );
+				   bool_t maybeholespr);
 
-static bool_t Inv_validate_cmdline( void );
-static bool_t dumpcompat( bool_t resumepr,
+static bool_t Inv_validate_cmdline(void);
+static bool_t dumpcompat(bool_t resumepr,
 			  ix_t level,
 			  uuid_t baseid,
-			  bool_t logpr );
-static bool_t promptdumpmatch( ix_t thrdix,
+			  bool_t logpr);
+static bool_t promptdumpmatch(ix_t thrdix,
 			       global_hdr_t *grhdrp,
 			       media_hdr_t *mrhdrp,
 			       content_hdr_t *crhdrp,
-			       content_inode_hdr_t *scrhdrp );
+			       content_inode_hdr_t *scrhdrp);
 
-static void pi_checkpoint( dh_t fileh,
+static void pi_checkpoint(dh_t fileh,
 			   drive_mark_t *drivemarkp,
 			   xfs_ino_t ino,
-			   off64_t off );
-static bool_t pi_transcribe( inv_session_t *sessp );
-static dh_t pi_addfile( Media_t *Mediap,
+			   off64_t off);
+static bool_t pi_transcribe(inv_session_t *sessp);
+static dh_t pi_addfile(Media_t *Mediap,
 			global_hdr_t *grhdrp,
 			drive_hdr_t *drhdrp,
 			media_hdr_t *mrhdrp,
 			content_inode_hdr_t *scrhdrp,
-			drive_t * drivep );
-static void pi_seestrmend( ix_t strmix );
-static void pi_seeobjstrmend( ix_t strmix, ix_t mediaix );
-static xfs_ino_t pi_scanfileendino( dh_t fileh );
-static bool_t pi_alldone( void );
-static bag_t * pi_neededobjs_dir_alloc( bool_t *knownholesprp,
-				        bool_t *maybeholesprp );
-static bag_t * pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
+			drive_t * drivep);
+static void pi_seestrmend(ix_t strmix);
+static void pi_seeobjstrmend(ix_t strmix, ix_t mediaix);
+static xfs_ino_t pi_scanfileendino(dh_t fileh);
+static bool_t pi_alldone(void);
+static bag_t * pi_neededobjs_dir_alloc(bool_t *knownholesprp,
+				        bool_t *maybeholesprp);
+static bag_t * pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 					   bool_t *maybeholesprp,
 					   bool_t showobjindrivepr,
-					   bool_t markskippr );
-static void pi_neededobjs_free( bag_t *bagp );
-static void pi_bracketneededegrps( dh_t thisfileh,
+					   bool_t markskippr);
+static void pi_neededobjs_free(bag_t *bagp);
+static void pi_bracketneededegrps(dh_t thisfileh,
 				   egrp_t *first_egrp,
-				   egrp_t *next_egrp );
-static void pi_update_stats( off64_t sz );
-static void pi_hiteod( ix_t strmix, ix_t objix );
-static void pi_hiteom( ix_t strmix, ix_t objix );
-static void pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix );
-static bool_t pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix );
-static bool_t pi_know_no_more_beyond_on_object( purp_t purp,
+				   egrp_t *next_egrp);
+static void pi_update_stats(off64_t sz);
+static void pi_hiteod(ix_t strmix, ix_t objix);
+static void pi_hiteom(ix_t strmix, ix_t objix);
+static void pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix);
+static bool_t pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix);
+static bool_t pi_know_no_more_beyond_on_object(purp_t purp,
 					        ix_t strmix,
 					        ix_t objix,
-					        ix_t fileix );
-static void pi_preclean( void );
-static void pi_driveempty( ix_t driveix );
-static void pi_note_indrive( ix_t driveix, uuid_t mediaid );
-static void pi_note_underhead( dh_t thisobjh, dh_t thisfileh );
-static void pi_lock( void );
-static void pi_unlock( void );
-
-static rv_t applydirdump( drive_t *drivep,
+					        ix_t fileix);
+static void pi_preclean(void);
+static void pi_driveempty(ix_t driveix);
+static void pi_note_indrive(ix_t driveix, uuid_t mediaid);
+static void pi_note_underhead(dh_t thisobjh, dh_t thisfileh);
+static void pi_lock(void);
+static void pi_unlock(void);
+
+static rv_t applydirdump(drive_t *drivep,
 			  dh_t fileh,
 			  content_inode_hdr_t *scrhdrp,
-			  filehdr_t *fhdrp );
-static rv_t treepost( char *path1, char *path2 );
-static rv_t applynondirdump( drive_t *drivep,
+			  filehdr_t *fhdrp);
+static rv_t treepost(char *path1, char *path2);
+static rv_t applynondirdump(drive_t *drivep,
 			     dh_t fileh,
 			     content_inode_hdr_t *scrhdrp,
 			     char *path1,
 			     char *path2,
-			     filehdr_t *fhdrp );
-static rv_t finalize( char *path1, char *path2 );
-static void wipepersstate( void );
+			     filehdr_t *fhdrp);
+static rv_t finalize(char *path1, char *path2);
+static void wipepersstate(void);
 
-static rv_t read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs );
-static rv_t restore_file( drive_t *drivep,
+static rv_t read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs);
+static rv_t restore_file(drive_t *drivep,
 			  filehdr_t *fhdrp,
 			  bool_t ehcs,
 			  bool_t ahcs,
 			  char *path1,
-			  char *path2 );
-static bool_t restore_reg( drive_t *drivep,
+			  char *path2);
+static bool_t restore_reg(drive_t *drivep,
 			   filehdr_t *fhdrp,
 			   rv_t *rvp,
-			   char *path );
-static bool_t restore_extent_group( drive_t *drivep,
+			   char *path);
+static bool_t restore_extent_group(drive_t *drivep,
 				    filehdr_t *fhdrp,
 				    char *path,
 				    int fd,
 				    bool_t ehcs,
 				    rv_t *rvp);
-static bool_t restore_complete_reg( stream_context_t* );
-static bool_t restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path );
-static bool_t restore_symlink( drive_t *drivep,
+static bool_t restore_complete_reg(stream_context_t*);
+static bool_t restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path);
+static bool_t restore_symlink(drive_t *drivep,
 			       filehdr_t *fhdrp,
 			       rv_t *rvp,
 			       char *path,
 			       char *scratchpath,
-			       bool_t ehcs );
-static rv_t read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs );
-static rv_t read_dirent( drive_t *drivep,
+			       bool_t ehcs);
+static rv_t read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs);
+static rv_t read_dirent(drive_t *drivep,
 			 direnthdr_t *dhdrp,
 			 size_t direntbufsz,
-			 bool_t dhcs );
-static rv_t discard_padding( size_t sz, drive_t *drivep );
-static rv_t restore_extent( filehdr_t *fhdrp,
+			 bool_t dhcs);
+static rv_t discard_padding(size_t sz, drive_t *drivep);
+static rv_t restore_extent(filehdr_t *fhdrp,
 			    extenthdr_t *ehdrp,
 			    int fd,
 			    char *path,
 			    drive_t *drivep,
-			    off64_t *bytesreadp );
-static bool_t askinvforbaseof( uuid_t baseid, inv_session_t *sessp );
-static void addobj( bag_t *bagp,
+			    off64_t *bytesreadp);
+static bool_t askinvforbaseof(uuid_t baseid, inv_session_t *sessp);
+static void addobj(bag_t *bagp,
 		    uuid_t *objidp,
 		    label_t objlabel,
 		    bool_t indrivepr,
-		    ix_t indriveix );
-static size_t cntobj( bag_t *bagp );
-static bool_t gapneeded( egrp_t *firstegrpp, egrp_t *lastegrpp );
-static char * ehdr_typestr( int32_t type );
-static int egrpcmp( egrp_t *egrpap, egrp_t *egrpbp );
-static void display_dump_label( bool_t lockpr,
+		    ix_t indriveix);
+static size_t cntobj(bag_t *bagp);
+static bool_t gapneeded(egrp_t *firstegrpp, egrp_t *lastegrpp);
+static char * ehdr_typestr(int32_t type);
+static int egrpcmp(egrp_t *egrpap, egrp_t *egrpbp);
+static void display_dump_label(bool_t lockpr,
 				int mllevel,
 				char *introstr,
 				global_hdr_t *grhdrp,
 				media_hdr_t *mrhdrp,
 				content_hdr_t *crhdrp,
-				content_inode_hdr_t *scrhdrp );
-static void display_needed_objects( purp_t purp,
+				content_inode_hdr_t *scrhdrp);
+static void display_needed_objects(purp_t purp,
 				    bag_t *bagp,
 				    bool_t knownholespr,
-				    bool_t maybeholespr );
-static void set_mcflag( ix_t thrdix );
-static void clr_mcflag( ix_t thrdix );
-static void pi_show( char *introstring );
-static void pi_show_nomloglock( void );
-
-static bool_t extattr_init( size_t drivecnt );
-static char * get_extattrbuf( ix_t which );
-static rv_t restore_extattr( drive_t *drivep,
+				    bool_t maybeholespr);
+static void set_mcflag(ix_t thrdix);
+static void clr_mcflag(ix_t thrdix);
+static void pi_show(char *introstring);
+static void pi_show_nomloglock(void);
+
+static bool_t extattr_init(size_t drivecnt);
+static char * get_extattrbuf(ix_t which);
+static rv_t restore_extattr(drive_t *drivep,
 			     filehdr_t *fhdrp,
 			     char *path,
 			     bool_t ahcs,
 			     bool_t isdirpr,
 			     bool_t onlydoreadpr,
-			     dah_t dah );
-static bool_t restore_dir_extattr_cb( char *path, dah_t dah );
-static bool_t restore_dir_extattr_cb_cb( extattrhdr_t *ahdrp, void *ctxp );
-static void setextattr( char *path, extattrhdr_t *ahdrp );
+			     dah_t dah);
+static bool_t restore_dir_extattr_cb(char *path, dah_t dah);
+static bool_t restore_dir_extattr_cb_cb(extattrhdr_t *ahdrp, void *ctxp);
+static void setextattr(char *path, extattrhdr_t *ahdrp);
 static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
                         off64_t offset, off64_t sz);
 static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
 static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
-static int do_fssetdm_by_handle( char *path, fsdmidata_t *fdmp);
+static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);
 static int quotafilecheck(char *type, char *dstdir, char *quotafile);
 
 /* definition of locally defined global variables ****************************/
@@ -877,13 +877,13 @@ static pers_desc_t *descp = 0;	/* mapped on the fly; don't use! (see macros) */
 static char *hkdirname = "xfsrestorehousekeepingdir";
 static char *persname = "state";
 static char *perspath = 0;
-static bool_t mcflag[ STREAM_SIMMAX ]; /* media change flag */
+static bool_t mcflag[STREAM_SIMMAX]; /* media change flag */
 
 
 /* definition of locally defined global functions ****************************/
 
 bool_t
-content_init( int argc, char *argv[ ], size64_t vmsz )
+content_init(int argc, char *argv[], size64_t vmsz)
 {
 	char *dstdir;	/* abs. path to destination dir */
 	bool_t cumpr;	/* cmd line cumulative restore specification */
@@ -913,32 +913,32 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 
 	/* Calculate the size needed for the persistent inventory
 	 */
-	for ( perssz = pgsz; perssz < sizeof(pers_t); perssz += pgsz )
+	for (perssz = pgsz; perssz < sizeof(pers_t); perssz += pgsz)
 		;
 
 	/* sanity checks
 	 */
-	assert( sizeof( pers_desc_t ) <= PERS_DESCSZ );
-	assert( PERS_DESCSZ <= pgsz );
-	assert( ! ( pgsz % PERS_DESCSZ ));
-	assert( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
+	assert(sizeof(pers_desc_t) <= PERS_DESCSZ);
+	assert(PERS_DESCSZ <= pgsz);
+	assert(! (pgsz % PERS_DESCSZ));
+	assert(sizeof(extattrhdr_t) == EXTATTRHDR_SZ);
 
-	assert( ! ( perssz % pgsz ));
+	assert(! (perssz % pgsz));
 
-	assert( SYNC_INIT == 0 );
+	assert(SYNC_INIT == 0);
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "sizeof( pers_desc_t ) == %d, pgsz == %d, perssz == %d \n",
-	      sizeof( pers_desc_t ), pgsz, perssz );
+	      sizeof(pers_desc_t), pgsz, perssz);
 
 	/* allocate transient state
 	 */
-	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
-	assert( tranp );
+	tranp = (tran_t *)calloc(1, sizeof(tran_t));
+	assert(tranp);
 
 	/* allocate a qlock for establishing pi critical regions
 	 */
-	tranp->t_pilockh = qlock_alloc( QLOCK_ORD_PI );
+	tranp->t_pilockh = qlock_alloc(QLOCK_ORD_PI);
 
 	/* record vmsz; will be used later to init tree abstraction
 	 */
@@ -946,7 +946,7 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 
 	/* record the start time for stats display
 	 */
-	tranp->t_starttime = time( 0 );
+	tranp->t_starttime = time(0);
 
 	/* get command line options
 	 */
@@ -966,8 +966,8 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	restore_rootdir_permissions = BOOL_FALSE;
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
-		switch ( c ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
+		switch (c) {
 		case GETOPT_TOC:
 			tranp->t_toconlypr = BOOL_TRUE;
 			break;
@@ -981,20 +981,20 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			existpr = BOOL_TRUE;
 			break;
 		case GETOPT_NEWER:
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
-			if ( stat( optarg, &statbuf )) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (stat(optarg, &statbuf)) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "unable to get status of -%c argument %s:"
 				      " %s\n"),
 				      c,
 				      optarg,
-				      strerror( errno ));
+				      strerror(errno));
 				return BOOL_FALSE;
 			}
 			newerpr = BOOL_TRUE;
@@ -1007,153 +1007,153 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			ownerpr = BOOL_TRUE;
 			break;
 		case GETOPT_WORKSPACE:
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
-			if ( optarg[ 0 ] != '/' ) {
-				tranp->t_hkdir = path_reltoabs( optarg,
-								homedir );
-				if ( ! tranp->t_hkdir ) {
-					mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (optarg[0] != '/') {
+				tranp->t_hkdir = path_reltoabs(optarg,
+								homedir);
+				if (! tranp->t_hkdir) {
+					mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					      "-%c argument %s is an "
 					      "invalid pathname\n"),
 					      c,
-					      optarg );
-					usage( );
+					      optarg);
+					usage();
 					return BOOL_FALSE;
 				}
-				mlog( MLOG_DEBUG,
+				mlog(MLOG_DEBUG,
 				      "alternate workspace path converted "
 				      "from %s to %s\n",
 				      optarg,
-				      tranp->t_hkdir );
+				      tranp->t_hkdir);
 			} else {
 				tranp->t_hkdir = optarg;
 			}
-			rval = stat( tranp->t_hkdir, &statbuf );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			rval = stat(tranp->t_hkdir, &statbuf);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "cannot stat -%c argument %s (%s): %s\n"),
 				      c,
 				      optarg,
 				      tranp->t_hkdir,
-				      strerror( errno ));
-				usage( );
+				      strerror(errno));
+				usage();
 				return BOOL_FALSE;
 			}
-			if ( ( statbuf.st_mode & S_IFMT ) != S_IFDIR ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument %s (%s) "
 				      "is not a directory\n"),
 				      c,
 				      optarg,
-				      tranp->t_hkdir );
-				usage( );
+				      tranp->t_hkdir);
+				usage();
 				return BOOL_FALSE;
 			}
 
 			break;
 		case GETOPT_DUMPLABEL:
-			if ( tranp->t_reqdumplabvalpr ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (tranp->t_reqdumplabvalpr) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "too many -%c arguments: "
 				      "\"-%c %s\" already given\n"),
 				      c,
 				      c,
-				      tranp->t_reqdumplab );
-				usage( );
+				      tranp->t_reqdumplab);
+				usage();
 				return BOOL_FALSE;
 			}
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
-			if ( strlen( optarg )
+			if (strlen(optarg)
 			     >
-			     sizeofmember( pers_t, s.dumplab )) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			     sizeofmember(pers_t, s.dumplab)) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument %s too long: max is %d\n"),
 				      c,
 				      optarg,
-				      sizeofmember( pers_t, s.dumplab ));
-				usage( );
+				      sizeofmember(pers_t, s.dumplab));
+				usage();
 				return BOOL_FALSE;
 			}
 			tranp->t_reqdumplab = optarg;
 			tranp->t_reqdumplabvalpr = BOOL_TRUE;
 			break;
 		case GETOPT_SESSIONID:
-			if ( tranp->t_reqdumpidvalpr ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (tranp->t_reqdumpidvalpr) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "too many -%c arguments\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
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
-			if (uuid_parse( optarg, tranp->t_reqdumpid ) < 0 ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (uuid_parse(optarg, tranp->t_reqdumpid) < 0) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument not a valid uuid\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			tranp->t_reqdumpidvalpr = BOOL_TRUE;
 			break;
 		case GETOPT_SUBTREE:
 		case GETOPT_NOSUBTREE:
-			if ( ! optarg
+			if (! optarg
 			     ||
-			     optarg[ 0 ] == 0
+			     optarg[0] == 0
 			     ||
-			     optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL, _(
+			     optarg[0] == '-') {
+				mlog(MLOG_NORMAL, _(
 				      "-%c argument missing\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
-			if ( optarg[ 0 ] == '/' ) {
-				mlog( MLOG_NORMAL, _(
+			if (optarg[0] == '/') {
+				mlog(MLOG_NORMAL, _(
 				      "-%c argument must be relative\n"),
-				      c );
-				usage( );
+				      c);
+				usage();
 				return BOOL_FALSE;
 			}
 			stcnt++;
-			if ( ! firststsenseprvalpr ) {
-				if ( c == GETOPT_SUBTREE ) {
+			if (! firststsenseprvalpr) {
+				if (c == GETOPT_SUBTREE) {
 					firststsensepr = BOOL_TRUE;
 				} else {
 					firststsensepr = BOOL_FALSE;
 				}
 				firststsenseprvalpr = BOOL_TRUE;
 			}
-			stsz += sizeof( stdesc_t )
+			stsz += sizeof(stdesc_t)
 				+
-				strlen( optarg )
+				strlen(optarg)
 				+
-				( STDESCALIGN - 1 );
-			stsz &= ~( STDESCALIGN - 1 );
+				(STDESCALIGN - 1);
+			stsz &= ~(STDESCALIGN - 1);
 			break;
 		case GETOPT_INTERACTIVE:
-			if ( ! dlog_allowed( )) {
-				mlog( MLOG_NORMAL, _(
+			if (! dlog_allowed()) {
+				mlog(MLOG_NORMAL, _(
 				      "-%c unavailable: no /dev/tty\n"),
-				      GETOPT_INTERACTIVE );
+				      GETOPT_INTERACTIVE);
 				return BOOL_FALSE;
 			}
 			interpr = BOOL_TRUE;
@@ -1165,11 +1165,11 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			restoredmpr = BOOL_TRUE;
 			break;
 		case GETOPT_ALERTPROG:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! optarg || optarg[0] == '-') {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					"-%c argument missing\n"),
-					c );
-				usage( );
+					c);
+				usage();
 				return BOOL_FALSE;
 			}
 			media_change_alert_program = optarg;
@@ -1194,35 +1194,35 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 
 	/* command line option error checking
 	 */
-	if ( cumpr && tranp->t_toconlypr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (cumpr && tranp->t_toconlypr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "-%c and -%c option cannot be used together\n"),
 		      GETOPT_TOC,
-		      GETOPT_CUMULATIVE );
-		usage( );
+		      GETOPT_CUMULATIVE);
+		usage();
 		return BOOL_FALSE;
 	}
-	if ( resumepr && tranp->t_toconlypr ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (resumepr && tranp->t_toconlypr) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "-%c and -%c option cannot be used together\n"),
 		      GETOPT_TOC,
-		      GETOPT_RESUME );
-		usage( );
+		      GETOPT_RESUME);
+		usage();
 		return BOOL_FALSE;
 	}
 
 	/* assume all streams contain a directory dump. streams will remove
 	 * themselves from this bitset if they do not contain a directory dump.
 	 */
-	assert( drivecnt <= sizeof(tranp->t_dirdumps) * NBBY );
-	tranp->t_dirdumps = ( 1ULL << drivecnt ) - 1;
+	assert(drivecnt <= sizeof(tranp->t_dirdumps) * NBBY);
+	tranp->t_dirdumps = (1ULL << drivecnt) - 1;
 
 	/* the user may specify stdin as the restore source stream,
 	 * by a single dash ('-') with no option letter. This must
 	 * appear between the last lettered argument and the destination
 	 * directory pathname.
 	 */
-	if ( optind < argc && ! strcmp( argv[ optind ], "-" )) {
+	if (optind < argc && ! strcmp(argv[optind ], "-")) {
 		optind++;
 	}
 
@@ -1230,55 +1230,55 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * required if table-of-contents display, or if a resumed restore
 	 * or a delta restore.
 	 */
-	if ( ! tranp->t_toconlypr ) {
-		if ( optind >= argc ) {
+	if (! tranp->t_toconlypr) {
+		if (optind >= argc) {
 			dstdir = 0;
 		} else {
-			if ( argv[ optind ][ 0 ] != '/' ) {
-				dstdir = path_reltoabs( argv[ optind ],
-							homedir );
-				if ( ! dstdir ) {
-					mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (argv[optind][0] != '/') {
+				dstdir = path_reltoabs(argv[optind],
+							homedir);
+				if (! dstdir) {
+					mlog(MLOG_NORMAL | MLOG_ERROR, _(
 					      "destination directory %s "
 					      "invalid pathname\n"),
-					      argv[ optind ] );
-					usage( );
+					      argv[optind]);
+					usage();
 					return BOOL_FALSE;
 				}
-				mlog( MLOG_DEBUG,
+				mlog(MLOG_DEBUG,
 				      "restore destination path converted "
 				      "from %s to %s\n",
-				      argv[ optind ],
-				      dstdir );
+				      argv[optind],
+				      dstdir);
 			} else {
-				dstdir = argv[ optind ];
+				dstdir = argv[optind];
 			}
-			rval = stat( dstdir, &statbuf );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			rval = stat(dstdir, &statbuf);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "cannot stat destination directory %s: "
 				      "%s\n"),
 				      dstdir,
-				      strerror( errno ));
-				usage( );
+				      strerror(errno));
+				usage();
 				return BOOL_FALSE;
 			}
-			if ( ( statbuf.st_mode & S_IFMT ) != S_IFDIR ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if ((statbuf.st_mode & S_IFMT) != S_IFDIR) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "specified destination %s "
 				      "is not a directory\n"),
-				      dstdir );
-				usage( );
+				      dstdir);
+				usage();
 				return BOOL_FALSE;
 			}
 		}
 	} else {
-		if ( optind < argc ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (optind < argc) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "do not specify destination directory if "
 			      "contents only restore invoked (-%c option)\n"),
-			      GETOPT_TOC );
-			usage( );
+			      GETOPT_TOC);
+			usage();
 			return BOOL_FALSE;
 		}
 		dstdir = ".";
@@ -1292,62 +1292,62 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * if this is toconly, modify the housekeeping dir's name with
 	 * the pid.
 	 */
-	if ( ! tranp->t_hkdir ) {
-		if ( tranp->t_toconlypr ) {
+	if (! tranp->t_hkdir) {
+		if (tranp->t_toconlypr) {
 			tranp->t_hkdir = homedir;
 		} else {
-			if ( ! dstdir ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			if (! dstdir) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "destination directory "
-				      "not specified\n") );
-				usage( );
+				      "not specified\n"));
+				usage();
 				return BOOL_FALSE;
 			} else {
 				tranp->t_hkdir = dstdir;
 			}
 		}
 	}
-	if ( tranp->t_toconlypr ) {
-		pid = getpid( );
+	if (tranp->t_toconlypr) {
+		pid = getpid();
 	} else {
 		pid = 0;
 	}
-	tranp->t_hkdir = open_pathalloc( tranp->t_hkdir, hkdirname, pid );
+	tranp->t_hkdir = open_pathalloc(tranp->t_hkdir, hkdirname, pid);
 
 	/* if this is a table-of-contents only restore, register an
 	 * exit handler to get rid of the housekeeping directory and
 	 * its contents. NOTE: needs several tran fields initialized!
 	 */
-	if ( tranp->t_toconlypr ) {
-		atexit( toconly_cleanup );
+	if (tranp->t_toconlypr) {
+		atexit(toconly_cleanup);
 	}
 
 	/* create housekeeping dir if not present
 	 */
-	rval = mkdir( tranp->t_hkdir, S_IRWXU );
-	if ( rval && errno != EEXIST ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	rval = mkdir(tranp->t_hkdir, S_IRWXU);
+	if (rval && errno != EEXIST) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "unable to create %s: %s\n"),
 		      tranp->t_hkdir,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* build a full pathname to pers. state file
 	 */
-	assert( ! perspath );
-	perspath = open_pathalloc( tranp->t_hkdir, persname, 0 );
+	assert(! perspath);
+	perspath = open_pathalloc(tranp->t_hkdir, persname, 0);
 
 	/* open, creating if non-existent
 	 */
-	tranp->t_persfd = open( perspath,
+	tranp->t_persfd = open(perspath,
 				O_CREAT | O_RDWR,
-				S_IRUSR | S_IWUSR );
-	if ( tranp->t_persfd < 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+				S_IRUSR | S_IWUSR);
+	if (tranp->t_persfd < 0) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "could not open/create persistent state file %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
@@ -1355,19 +1355,19 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * arguments. three cases: no dumps applied so far, or one or more
 	 * dumps applied completely, or restore session was interrupted
 	 */
-	persp = ( pers_t * ) mmap_autogrow(perssz, tranp->t_persfd, 0);
+	persp = (pers_t *) mmap_autogrow(perssz, tranp->t_persfd, 0);
 
-	if ( persp == ( pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (persp == (pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "could not map persistent state file hdr %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* but first setup or verify the on-disk format information
 	 */
-	if ( ! persp->a.valpr ) {
+	if (! persp->a.valpr) {
 		/* this is the first restore session
 		 */
 		persp->v.housekeeping_magic = HOUSEKEEPING_MAGIC;
@@ -1377,254 +1377,254 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	} else {
 		/* cumulative or resuming a restore, verify the header
 		 */
-		if ( persp->v.housekeeping_magic != HOUSEKEEPING_MAGIC ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (persp->v.housekeeping_magic != HOUSEKEEPING_MAGIC) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "%s format corrupt or wrong endianness "
 			      "(0x%x, expected 0x%x)\n"),
 			      hkdirname,
 			      persp->v.housekeeping_magic,
-			      HOUSEKEEPING_MAGIC );
+			      HOUSEKEEPING_MAGIC);
 			return BOOL_FALSE;
 		}
-		if ( persp->v.housekeeping_version != HOUSEKEEPING_VERSION ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (persp->v.housekeeping_version != HOUSEKEEPING_VERSION) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "%s format version differs from previous "
 			      "restore (%u, expected %u)\n"),
 			      hkdirname,
 			      persp->v.housekeeping_version,
-			      HOUSEKEEPING_VERSION );
+			      HOUSEKEEPING_VERSION);
 			return BOOL_FALSE;
 		}
-		if ( persp->v.pagesize != pgsz ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (persp->v.pagesize != pgsz) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "%s format differs from previous "
 			      "restore due to page size change "
 			      "(was %lu, now %lu)\n"),
 			      hkdirname,
 			      persp->v.pagesize,
-			      pgsz );
+			      pgsz);
 			return BOOL_FALSE;
 		}
 	}
 
-	if ( ! persp->a.valpr ) {
-		if ( ! dstdir ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
-			      "destination directory not specified\n") );
-			usage( );
+	if (! persp->a.valpr) {
+		if (! dstdir) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
+			      "destination directory not specified\n"));
+			usage();
 			return BOOL_FALSE;
 		}
-		if ( strlen( dstdir ) >= sizeofmember( pers_t, a.dstdir )) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (strlen(dstdir) >= sizeofmember(pers_t, a.dstdir)) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "destination directory pathname too long: "
 			      "max is %d characters\n"),
-			      sizeofmember( pers_t, a.dstdir ) - 1 );
-			usage( );
+			      sizeofmember(pers_t, a.dstdir) - 1);
+			usage();
 			return BOOL_FALSE;
 		}
-		if ( resumepr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (resumepr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
 			      "interrupted restore to resume\n"),
-			      GETOPT_RESUME );
-			usage( );
+			      GETOPT_RESUME);
+			usage();
 			return BOOL_FALSE;
 		}
-		if ( sesscpltpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (sesscpltpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
 			      "interrupted restore to force completion of\n"),
-			      GETOPT_SESSCPLT );
-			usage( );
+			      GETOPT_SESSCPLT);
+			usage();
 			return BOOL_FALSE;
 		}
-	} else if ( ! persp->s.valpr ) {
-		if ( ! cumpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	} else if (! persp->s.valpr) {
+		if (! cumpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "must rm -rf %s prior to noncumulative restore\n"),
-			      tranp->t_hkdir );
+			      tranp->t_hkdir);
 			return BOOL_FALSE;
 		}
-		if ( resumepr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (resumepr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
 			      "interrupted restore to resume\n"),
-			      GETOPT_RESUME );
-			usage( );
+			      GETOPT_RESUME);
+			usage();
 			return BOOL_FALSE;
 		}
-		if ( sesscpltpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (sesscpltpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option invalid: there is no "
 			      "interrupted restore to force completion of\n"),
-			      GETOPT_SESSCPLT );
-			usage( );
+			      GETOPT_SESSCPLT);
+			usage();
 			return BOOL_FALSE;
 		}
-		if ( existpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (existpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
 			      "cumulative restore\n"),
-			      GETOPT_EXISTING );
+			      GETOPT_EXISTING);
 			return BOOL_FALSE;
 		}
-		if ( newerpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (newerpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
 			      "cumulative restore\n"),
-			      GETOPT_NEWER );
+			      GETOPT_NEWER);
 			return BOOL_FALSE;
 		}
-		if ( changepr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (changepr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
 			      "cumulative restore\n"),
-			      GETOPT_CHANGED );
+			      GETOPT_CHANGED);
 			return BOOL_FALSE;
 		}
-		if ( ownerpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (ownerpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
 			      "cumulative restore\n"),
-			      GETOPT_OWNER );
+			      GETOPT_OWNER);
 			return BOOL_FALSE;
 		}
-		if ( stcnt ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (stcnt) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c and -%c valid only when initiating "
 			      "cumulative restore\n"),
 			      GETOPT_SUBTREE,
-			      GETOPT_NOSUBTREE );
+			      GETOPT_NOSUBTREE);
 			return BOOL_FALSE;
 		}
-		if ( tranp->t_truncategenpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (tranp->t_truncategenpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating "
 			      "cumulative restore\n"),
-			      GETOPT_FMT2COMPAT );
+			      GETOPT_FMT2COMPAT);
 			return BOOL_FALSE;
 		}
 	} else {
-		if ( ! resumepr && ! sesscpltpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (! resumepr && ! sesscpltpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c option required to resume "
 			      "or "
 			      "-%c option required to force completion of "
 			      "previously "
 			      "interrupted restore session\n"),
 			      GETOPT_RESUME,
-			      GETOPT_SESSCPLT );
+			      GETOPT_SESSCPLT);
 			return BOOL_FALSE;
 		}
-		if ( tranp->t_reqdumplabvalpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (tranp->t_reqdumplabvalpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_DUMPLABEL );
+			      GETOPT_DUMPLABEL);
 			return BOOL_FALSE;
 		}
-		if ( tranp->t_reqdumpidvalpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (tranp->t_reqdumpidvalpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_SESSIONID );
+			      GETOPT_SESSIONID);
 			return BOOL_FALSE;
 		}
-		if ( existpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (existpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_EXISTING );
+			      GETOPT_EXISTING);
 			return BOOL_FALSE;
 		}
-		if ( newerpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (newerpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_NEWER );
+			      GETOPT_NEWER);
 			return BOOL_FALSE;
 		}
-		if ( changepr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (changepr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_CHANGED );
+			      GETOPT_CHANGED);
 			return BOOL_FALSE;
 		}
-		if ( ownerpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (ownerpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_OWNER );
+			      GETOPT_OWNER);
 			return BOOL_FALSE;
 		}
-		if ( interpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (interpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_INTERACTIVE );
+			      GETOPT_INTERACTIVE);
 			return BOOL_FALSE;
 		}
-		if ( stcnt ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (stcnt) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			     "-%c and -%c valid only when initiating restore\n"),
 			      GETOPT_SUBTREE,
-			      GETOPT_NOSUBTREE );
+			      GETOPT_NOSUBTREE);
 			return BOOL_FALSE;
 		}
-		if ( tranp->t_truncategenpr ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+		if (tranp->t_truncategenpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "-%c valid only when initiating restore\n"),
-			      GETOPT_FMT2COMPAT );
+			      GETOPT_FMT2COMPAT);
 			return BOOL_FALSE;
 		}
 	}
 
-	if ( persp->a.valpr ) {
-		if ( restoredmpr && persp->a.restoredmpr != restoredmpr) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (persp->a.valpr) {
+		if (restoredmpr && persp->a.restoredmpr != restoredmpr) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			     "-%c cannot reset flag from previous restore\n"),
-			      GETOPT_SETDM );
+			      GETOPT_SETDM);
 			return BOOL_FALSE;
 		}
-		if ( ! restoreextattrpr &&
+		if (! restoreextattrpr &&
 		       persp->a.restoreextattrpr != restoreextattrpr) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			     "-%c cannot reset flag from previous restore\n"),
-			      GETOPT_NOEXTATTR );
+			      GETOPT_NOEXTATTR);
 			return BOOL_FALSE;
 		}
 	}
 
 	/* force owner option if root
 	 */
-	ownerpr = ( geteuid( ) == 0 ) ? BOOL_TRUE : ownerpr;
+	ownerpr = (geteuid() == 0) ? BOOL_TRUE : ownerpr;
 
 	/* force completion of interrupted restore if asked to do so
 	 */
-	if ( sesscpltpr ) {
+	if (sesscpltpr) {
 		char *path1;
 		char *path2;
 		rv_t rv;
 		int rval;
 
-		path1 = ( char * )calloc( 1, 2 * MAXPATHLEN );
-		assert( path1 );
-		path2 = ( char * )calloc( 1, 2 * MAXPATHLEN );
-		assert( path2 );
-		assert( persp->a.valpr );
-		assert( persp->s.valpr );
-		rval = chdir( persp->a.dstdir );
-		if ( rval ) {
-			mlog( MLOG_NORMAL, _(
+		path1 = (char *)calloc(1, 2 * MAXPATHLEN);
+		assert(path1);
+		path2 = (char *)calloc(1, 2 * MAXPATHLEN);
+		assert(path2);
+		assert(persp->a.valpr);
+		assert(persp->s.valpr);
+		rval = chdir(persp->a.dstdir);
+		if (rval) {
+			mlog(MLOG_NORMAL, _(
 			      "chdir %s failed: %s\n"),
 			      persp->a.dstdir,
-			      strerror( errno ));
+			      strerror(errno));
 			return BOOL_FALSE;
 		}
-		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
-		if ( ! ok ) {
+		ok = dirattr_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
-		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
-		if ( ! ok ) {
+		ok = namreg_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
-		ok = inomap_sync_pers( tranp->t_hkdir );
-		if ( ! ok ) {
+		ok = inomap_sync_pers(tranp->t_hkdir);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 
@@ -1637,18 +1637,18 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			fullpr = BOOL_FALSE;
 		}
 
-		ok = tree_sync( tranp->t_hkdir,
+		ok = tree_sync(tranp->t_hkdir,
 				persp->a.dstdir,
 				tranp->t_toconlypr,
 				fullpr,
-				persp->a.dstdirisxfspr );
-		if ( ! ok ) {
+				persp->a.dstdirisxfspr);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
-		rv = finalize( path1, path2 );
-		free( ( void * )path1 );
-		free( ( void * )path2 );
-		switch ( rv ) {
+		rv = finalize(path1, path2);
+		free((void *)path1);
+		free((void *)path2);
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_ERROR:
@@ -1664,78 +1664,78 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	/* for the three cases, calculate old and new mapping params
 	 * and wipe partial state
 	 */
-	if ( ! persp->a.valpr ) {
+	if (! persp->a.valpr) {
 		stpgcnt = 0;
-		newstpgcnt = ( stsz + pgmask ) / pgsz;
+		newstpgcnt = (stsz + pgmask) / pgsz;
 		descpgcnt = 0;
-		memset( ( void * )&persp->a, 0,
-			sizeof( pers_t ) - offsetofmember( pers_t, a ));
-	} else if ( ! persp->s.valpr ) {
+		memset((void *)&persp->a, 0,
+			sizeof(pers_t) - offsetofmember(pers_t, a));
+	} else if (! persp->s.valpr) {
 		stpgcnt = persp->a.stpgcnt;
 		newstpgcnt = stpgcnt;
 		descpgcnt = 0;
-		memset( ( void * )&persp->s, 0, sizeofmember( pers_t, s ));
+		memset((void *)&persp->s, 0, sizeofmember(pers_t, s));
 	} else {
 		stpgcnt = persp->a.stpgcnt;
 		newstpgcnt = stpgcnt;
 		descpgcnt = persp->s.descpgcnt;
-		assert( resumepr );
-		mlog( MLOG_VERBOSE, _(
+		assert(resumepr);
+		mlog(MLOG_VERBOSE, _(
 		      "resuming restore previously begun %s\n"),
-		      ctimennl( &persp->s.begintime ));
-		persp->s.begintime = time( 0 );
+		      ctimennl(&persp->s.begintime));
+		persp->s.begintime = time(0);
 	}
 
 	/* unmap temp mapping of hdr, truncate, and remap hdr/subtrees
 	 */
-	rval = munmap( ( void * )persp, perssz );
-	assert( ! rval );
-	rval = ftruncate( tranp->t_persfd, ( off_t )perssz
+	rval = munmap((void *)persp, perssz);
+	assert(! rval);
+	rval = ftruncate(tranp->t_persfd, (off_t)perssz
 					   +
-					   ( off_t )( stpgcnt + descpgcnt )
+					   (off_t)(stpgcnt + descpgcnt)
 					   *
-					   ( off_t )pgsz );
-	assert( ! rval );
+					   (off_t)pgsz);
+	assert(! rval);
 	stpgcnt = newstpgcnt;
-	persp = ( pers_t * ) mmap_autogrow( perssz + stpgcnt * pgsz,
+	persp = (pers_t *) mmap_autogrow(perssz + stpgcnt * pgsz,
 				   tranp->t_persfd, 0);
-	if ( persp == ( pers_t * )-1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR, _(
+	if (persp == (pers_t *)-1) {
+		mlog(MLOG_NORMAL | MLOG_ERROR, _(
 		      "could not map persistent state file %s: %s\n"),
 		      perspath,
-		      strerror( errno ));
+		      strerror(errno));
 		return BOOL_FALSE;
 	}
 
 	/* if first restore session, record cmd line args and subtrees
 	 * and start time.
 	 */
-	if ( ! persp->a.valpr ) {
+	if (! persp->a.valpr) {
 		stdesc_t *stdescp;
 
-		strcpy( persp->a.dstdir, dstdir );
-		persp->a.dstdirisxfspr = platform_test_xfs_path( dstdir );
-		if ( cumpr ) {
+		strcpy(persp->a.dstdir, dstdir);
+		persp->a.dstdirisxfspr = platform_test_xfs_path(dstdir);
+		if (cumpr) {
 			persp->a.cumpr = cumpr;
 		}
-		if ( interpr ) {
+		if (interpr) {
 			persp->a.interpr = interpr;
 		}
-		if ( existpr ) {
+		if (existpr) {
 			persp->a.existpr = existpr;
 		}
-		if ( changepr ) {
+		if (changepr) {
 			persp->a.changepr = changepr;
 		}
-		if ( ownerpr ) {
+		if (ownerpr) {
 			persp->a.ownerpr = ownerpr;
 		}
-		if ( newerpr ) {
+		if (newerpr) {
 			persp->a.newerpr = newerpr;
 			persp->a.newertime = newertime;
 		}
 		persp->a.restoredmpr = restoredmpr;
-		if ( ! persp->a.dstdirisxfspr ) {
+		if (! persp->a.dstdirisxfspr) {
 			restoreextattrpr = BOOL_FALSE;
 		}
 		persp->a.restoreextattrpr = restoreextattrpr;
@@ -1745,40 +1745,40 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 		persp->a.stpgcnt = stpgcnt;
 		optind = 1;
 		opterr = 0;
-		stdescp = ( stdesc_t * )( ( char * )persp + perssz );
-		while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
+		stdescp = (stdesc_t *)((char *)persp + perssz);
+		while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 			size_t stdsz;
-			switch ( c ) {
+			switch (c) {
 			case GETOPT_SUBTREE:
 			case GETOPT_NOSUBTREE:
-				stdescp->std_sensepr = ( c == GETOPT_SUBTREE )
+				stdescp->std_sensepr = (c == GETOPT_SUBTREE)
 						       ?
 						       BOOL_TRUE
 						       :
 						       BOOL_FALSE;
-				stdsz = sizeof( stdesc_t )
+				stdsz = sizeof(stdesc_t)
 					+
-					strlen( optarg )
+					strlen(optarg)
 					+
-					( STDESCALIGN - 1 );
-				stdsz &= ~( STDESCALIGN - 1 );
-				assert( stdsz <= ( size_t )OFFMAX );
-				stdescp->std_nextoff = ( off_t )stdsz;
-				strcpy( stdescp->std_path, optarg );
-				stdescp = ( stdesc_t * )
-					  ( ( char * )stdescp + stdsz );
+					(STDESCALIGN - 1);
+				stdsz &= ~(STDESCALIGN - 1);
+				assert(stdsz <= (size_t)OFFMAX);
+				stdescp->std_nextoff = (off_t)stdsz;
+				strcpy(stdescp->std_path, optarg);
+				stdescp = (stdesc_t *)
+					  ((char *)stdescp + stdsz);
 				stcnt--;
 				break;
 			}
 		}
-		assert( stcnt == 0 );
+		assert(stcnt == 0);
 	}
 
 	/* initialize the local extattr abstraction. must be done even if
 	 * we don't intend to restore extended attributes
 	 */
-	ok = extattr_init( drivecnt );
-	if ( ! ok ) {
+	ok = extattr_init(drivecnt);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
@@ -1787,16 +1787,16 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * before any open_by_handle() calls (and possibly other
 	 * libhandle calls).
 	 */
-	if ( persp->a.dstdirisxfspr ) {
+	if (persp->a.dstdirisxfspr) {
 		void	*fshanp;
 		size_t	fshlen=0;
 
 		if(path_to_fshandle(persp->a.dstdir, &fshanp, &fshlen)) {
-			mlog( MLOG_NORMAL,
+			mlog(MLOG_NORMAL,
 				_("unable to construct a file "
 				  "system handle for %s: %s\n"),
 				persp->a.dstdir,
-				strerror( errno ));
+				strerror(errno));
 			return BOOL_FALSE;
 		}
 		/* libhandle has it cached, release this copy */
@@ -1807,32 +1807,32 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * referenced ONLY via the macros provided; the descriptors will be
 	 * occasionally remapped, causing the ptr to change.
 	 */
-	assert( ! descp );
-	if ( descpgcnt ) {
-		descp = ( pers_desc_t * ) mmap_autogrow( descpgcnt * pgsz,
+	assert(! descp);
+	if (descpgcnt) {
+		descp = (pers_desc_t *) mmap_autogrow(descpgcnt * pgsz,
 						tranp->t_persfd,
-						( off_t )perssz
+						(off_t)perssz
 						+
-						( off_t )( stpgcnt * pgsz ));
-		if ( descp == ( pers_desc_t * )-1 ) {
-			mlog( MLOG_NORMAL | MLOG_ERROR, _(
+						(off_t)(stpgcnt * pgsz));
+		if (descp == (pers_desc_t *)-1) {
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not map persistent state file inv %s: "
 			      "%s (%d)\n"),
 			      perspath,
-			      strerror( errno ),
-			      errno );
+			      strerror(errno),
+			      errno);
 			descp = 0;
 			return BOOL_FALSE;
 		}
-		pi_preclean( );
+		pi_preclean();
 	}
 
 	/* if resuming an interrupted restore, indicate we know the id
 	 * of the dump session being restored. otherwise, it will be determined
 	 * during coordination of per-drive threads.
 	 */
-	if ( persp->a.valpr && persp->s.valpr ) {
-		persp->s.begintime = time( 0 );
+	if (persp->a.valpr && persp->s.valpr) {
+		persp->s.begintime = time(0);
 		tranp->t_dumpidknwnpr = BOOL_TRUE;
 	}
 
@@ -1840,9 +1840,9 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * starts fresh with each dump session restored.
 	 * determine if full init needed instead.
 	 */
-	if ( persp->a.valpr && persp->s.valpr ) {
-		ok = dirattr_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
-		if ( ! ok ) {
+	if (persp->a.valpr && persp->s.valpr) {
+		ok = dirattr_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 		tranp->t_dirattrinitdonepr = BOOL_TRUE;
@@ -1852,9 +1852,9 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * first session, retained by subsequent sessions.
 	 * determine if full init needed instead.
 	 */
-	if ( persp->a.valpr ) {
-		ok = namreg_init( tranp->t_hkdir, BOOL_TRUE, ( uint64_t )0 );
-		if ( ! ok ) {
+	if (persp->a.valpr) {
+		ok = namreg_init(tranp->t_hkdir, BOOL_TRUE, (uint64_t)0);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 		tranp->t_namreginitdonepr = BOOL_TRUE;
@@ -1864,17 +1864,17 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 * restore session, but persistent after tree updated with dirdump.
 	 * determine if full init needed instead.
 	 */
-	ok = inomap_sync_pers( tranp->t_hkdir );
-	if ( ! ok ) {
+	ok = inomap_sync_pers(tranp->t_hkdir);
+	if (! ok) {
 		return BOOL_FALSE;
 	}
 
 	/* sync up with the tree abstraction. created by the
 	 * first session, retained by subsequent sessions.
-	 * don't call tree_init( ) from here; can only be called
+	 * don't call tree_init() from here; can only be called
 	 * when a valid media file header is at hand.
 	 */
-	if ( persp->a.valpr ) {
+	if (persp->a.valpr) {
 		/* This is only a full restore if we're doing a level
 		 * 0 restore.
 		 */
@@ -1884,12 +1884,12 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 			fullpr = BOOL_FALSE;
 		}
 
-		ok = tree_sync( tranp->t_hkdir,
+		ok = tree_sync(tranp->t_hkdir,
 				persp->a.dstdir,
 				tranp->t_toconlypr,
 				fullpr,
-				persp->a.dstdirisxfspr );
-		if ( ! ok ) {
+				persp->a.dstdirisxfspr);
+		if (! ok) {
 			return BOOL_FALSE;
 		}
 		tranp->t_treeinitdonepr = BOOL_TRUE;
@@ -1899,23 +1899,23 @@ content_init( int argc, char *argv[ ], size64_t vmsz )
 	 */
 	{
 		ix_t ix;
-		ix_t endix = sizeof( mcflag )
+		ix_t endix = sizeof(mcflag)
 			     /
-			     sizeof( mcflag[ 0 ] );
-		for ( ix = 0 ; ix < endix ; ix++ ) {
-			mcflag[ ix ] = BOOL_FALSE;
+			     sizeof(mcflag[0]);
+		for (ix = 0 ; ix < endix ; ix++) {
+			mcflag[ix] = BOOL_FALSE;
 		}
 	}
 	content_media_change_needed = BOOL_FALSE;
 
-	pi_show( " at initialization" );
+	pi_show(" at initialization");
 	return BOOL_TRUE;
 }
 
 /* stream thread entry point - returns exit code
  */
 int
-content_stream_restore( ix_t thrdix )
+content_stream_restore(ix_t thrdix)
 {
 	dh_t fileh;
 	Media_t *Mediap; /* local media abstraction */
@@ -1937,42 +1937,42 @@ content_stream_restore( ix_t thrdix )
 
 	/* allocate two path buffers
 	 */
-	path1 = ( char * )calloc( 1, 2 * MAXPATHLEN );
-	assert( path1 );
-	path2 = ( char * )calloc( 1, 2 * MAXPATHLEN );
-	assert( path2 );
+	path1 = (char *)calloc(1, 2 * MAXPATHLEN);
+	assert(path1);
+	path2 = (char *)calloc(1, 2 * MAXPATHLEN);
+	assert(path2);
 
 	/* set the current directory to dstdir. the tree abstraction
 	 * depends on the current directory being the root of the
 	 * destination file system.
 	 */
-	rval = chdir( persp->a.dstdir );
-	if ( rval ) {
-		mlog( MLOG_NORMAL, _(
+	rval = chdir(persp->a.dstdir);
+	if (rval) {
+		mlog(MLOG_NORMAL, _(
 		      "chdir %s failed: %s\n"),
 		      persp->a.dstdir,
-		      strerror( errno ));
+		      strerror(errno));
 		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 
 	/* set my file creation mask to zero, to avoid modifying the
 	 * dumped mode bits
 	 */
-	( void )umask( 0 );
+	(void)umask(0);
 
 	/* initialize the Media abstraction
 	 */
-	Mediap = Media_create( thrdix );
+	Mediap = Media_create(thrdix);
 
 	/*
 	 * initialize the stream context
 	 */
 	strctxp = (stream_context_t *)calloc(1, sizeof(stream_context_t));
 	if (!strctxp) {
-		mlog( MLOG_NORMAL | MLOG_ERROR,
+		mlog(MLOG_NORMAL | MLOG_ERROR,
 		      _("malloc of stream context failed (%d bytes): %s\n"),
 		      sizeof(stream_context_t),
-		      strerror( errno ));
+		      strerror(errno));
 		return mlog_exit(EXIT_ERROR, RV_ERROR);
 	}
 	strctxp->sc_fd = -1;
@@ -1985,32 +1985,32 @@ content_stream_restore( ix_t thrdix )
 	 * side-effect of validation is to incorporate the online
 	 * inventory into the persistent state.
 	 */
-	if ( tranp->t_dumpidknwnpr ) {
+	if (tranp->t_dumpidknwnpr) {
 		tranp->t_sync1 = SYNC_DONE;
 	}
-	while ( tranp->t_sync1 != SYNC_DONE ) {
-		lock( );
-		if ( tranp->t_sync1 == SYNC_BUSY ) {
-			unlock( );
-			sleep( 1 );
-			if ( cldmgr_stop_requested( )) {
+	while (tranp->t_sync1 != SYNC_DONE) {
+		lock();
+		if (tranp->t_sync1 == SYNC_BUSY) {
+			unlock();
+			sleep(1);
+			if (cldmgr_stop_requested()) {
 				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			continue;
 		}
-		if ( tranp->t_sync1 == SYNC_DONE ) {
-			unlock( );
+		if (tranp->t_sync1 == SYNC_DONE) {
+			unlock();
 			continue;
 		}
 		tranp->t_sync1 = SYNC_BUSY;
-		unlock( );
-		mlog( MLOG_DEBUG,
-		      "checking and validating command line dump id/label\n" );
-		ok = Inv_validate_cmdline( );
+		unlock();
+		mlog(MLOG_DEBUG,
+		      "checking and validating command line dump id/label\n");
+		ok = Inv_validate_cmdline();
 		    /* side-effect - searches for and incorporates online inv
 		     * into pi, and makes persp->s.dumpid valid.
 		     */
-		if ( ok == BOOL_ERROR ) {
+		if (ok == BOOL_ERROR) {
 			return mlog_exit(EXIT_ERROR, RV_OPT);
 		}
 		tranp->t_dumpidknwnpr = ok;
@@ -2022,22 +2022,22 @@ content_stream_restore( ix_t thrdix )
 	 * until the operator selects a media file from the desired
 	 * dump.
 	 */
-	if ( tranp->t_dumpidknwnpr ) {
+	if (tranp->t_dumpidknwnpr) {
 		tranp->t_sync2 = SYNC_DONE;
 	}
 	uuid_clear(lastdumprejectedid);
-	if ( tranp->t_sync2 != SYNC_DONE ) {
-		mlog( MLOG_VERBOSE, _(
-		      "searching media for dump\n") );
+	if (tranp->t_sync2 != SYNC_DONE) {
+		mlog(MLOG_VERBOSE, _(
+		      "searching media for dump\n"));
 	}
-	while ( tranp->t_sync2 != SYNC_DONE ) {
+	while (tranp->t_sync2 != SYNC_DONE) {
 		bool_t matchpr;
 		inv_session_t *sessp;
 		bool_t resumepr;
 		ix_t level;
 		uuid_t *baseidp;
 
-		rv = Media_mfile_next( Mediap,
+		rv = Media_mfile_next(Mediap,
 				       PURP_SEARCH,
 				       &tranp->t_sync2,
 				       0,
@@ -2047,8 +2047,8 @@ content_stream_restore( ix_t thrdix )
 				       &crhdrp,
 				       &scrhdrp,
 				       &drivep,
-				       &fhdr );
-		switch ( rv ) {
+				       &fhdr);
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_DONE:
@@ -2057,158 +2057,158 @@ content_stream_restore( ix_t thrdix )
 		case RV_INTR:
 		case RV_QUIT:
 		case RV_DRIVE:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
 
-		lock( );
-		while ( tranp->t_sync2 == SYNC_BUSY ) {
-			unlock( );
-			sleep( 1 );
-			if ( cldmgr_stop_requested( )) {
-				Media_end( Mediap );
+		lock();
+		while (tranp->t_sync2 == SYNC_BUSY) {
+			unlock();
+			sleep(1);
+			if (cldmgr_stop_requested()) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
-			lock( );
+			lock();
 		}
-		if ( tranp->t_sync2 == SYNC_DONE ) {
-			unlock( );
+		if (tranp->t_sync2 == SYNC_DONE) {
+			unlock();
 			continue;
 		}
 		tranp->t_sync2 = SYNC_BUSY;
 
-		unlock( );
-		mlog( MLOG_DEBUG,
-		      "dump found: checking\n" );
+		unlock();
+		mlog(MLOG_DEBUG,
+		      "dump found: checking\n");
 		matchpr = BOOL_FALSE;
-		resumepr = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME );
-		assert( scrhdrp->cih_level >= 0 );
-		level = ( ix_t )scrhdrp->cih_level;
+		resumepr = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME);
+		assert(scrhdrp->cih_level >= 0);
+		level = (ix_t)scrhdrp->cih_level;
 		baseidp = resumepr
 			  ?
 			  &scrhdrp->cih_resume_id
 			  :
 			  &scrhdrp->cih_last_id;
-		if ( tranp->t_reqdumpidvalpr ) {
-			if ( uuid_compare( tranp->t_reqdumpid,
+		if (tranp->t_reqdumpidvalpr) {
+			if (uuid_compare(tranp->t_reqdumpid,
 					 grhdrp->gh_dumpid) == 0) {
 				matchpr = BOOL_TRUE;
-				display_dump_label( BOOL_TRUE, /* lock */
+				display_dump_label(BOOL_TRUE, /* lock */
 						    MLOG_VERBOSE, _(
 						    "found dump matching "
 						    "specified id:\n"),
 						    grhdrp,
 						    mrhdrp,
 						    crhdrp,
-						    scrhdrp );
+						    scrhdrp);
 			}
-		} else if ( tranp->t_reqdumplabvalpr ) {
-			if ( ! strncmp( tranp->t_reqdumplab,
+		} else if (tranp->t_reqdumplabvalpr) {
+			if (! strncmp(tranp->t_reqdumplab,
 					grhdrp->gh_dumplabel,
-					sizeof( grhdrp->gh_dumplabel ))) {
+					sizeof(grhdrp->gh_dumplabel))) {
 				matchpr = BOOL_TRUE;
-				display_dump_label( BOOL_TRUE, /* lock */
+				display_dump_label(BOOL_TRUE, /* lock */
 						    MLOG_VERBOSE,  _(
 						    "found dump matching "
 						    "specified label:\n"),
 						    grhdrp,
 						    mrhdrp,
 						    crhdrp,
-						    scrhdrp );
+						    scrhdrp);
 			}
-		} else if ( dumpcompat( resumepr,
+		} else if (dumpcompat(resumepr,
 					level,
 					*baseidp,
-					BOOL_FALSE )) {
-			if ( uuid_compare( lastdumprejectedid,
+					BOOL_FALSE)) {
+			if (uuid_compare(lastdumprejectedid,
 					 grhdrp->gh_dumpid) == 0) {
 				matchpr = BOOL_FALSE;
 			} else {
-				if ( dlog_allowed( )
+				if (dlog_allowed()
 				     &&
-				     ( ( dcaps & DRIVE_CAP_FILES )
+				     ((dcaps & DRIVE_CAP_FILES)
 				       ||
-				       ( dcaps & DRIVE_CAP_REMOVABLE )
+				       (dcaps & DRIVE_CAP_REMOVABLE)
 				       ||
-				       drivecnt > 1 )) {
-					matchpr = promptdumpmatch( thrdix,
+				       drivecnt > 1)) {
+					matchpr = promptdumpmatch(thrdix,
 								   grhdrp,
 								   mrhdrp,
 								   crhdrp,
-								   scrhdrp );
+								   scrhdrp);
 				} else {
 					matchpr = BOOL_TRUE;
-					display_dump_label( BOOL_TRUE,/* lock */
+					display_dump_label(BOOL_TRUE,/* lock */
 							    MLOG_VERBOSE, _(
 							    "dump "
 							    "description: \n"),
 							    grhdrp,
 							    mrhdrp,
 							    crhdrp,
-							    scrhdrp );
+							    scrhdrp);
 				}
 			}
 		}
-		if ( cldmgr_stop_requested( )) {
-			Media_end( Mediap );
+		if (cldmgr_stop_requested()) {
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, RV_INTR);
 		}
-		if ( ! matchpr ) {
-			Media_end( Mediap );
+		if (! matchpr) {
+			Media_end(Mediap);
 			uuid_copy(lastdumprejectedid, grhdrp->gh_dumpid);
 			tranp->t_sync2 = SYNC_INIT;
-			if ( ! dlog_allowed( )
+			if (! dlog_allowed()
 			     ||
-			     ( ! ( dcaps & DRIVE_CAP_FILES )
+			     (! (dcaps & DRIVE_CAP_FILES)
 			       &&
-			       ! ( dcaps & DRIVE_CAP_REMOVABLE ))) {
+			       ! (dcaps & DRIVE_CAP_REMOVABLE))) {
 				return mlog_exit(EXIT_NORMAL, RV_QUIT);
 			}
 			continue;
 		}
-		if ( ! dumpcompat( resumepr, level, *baseidp, BOOL_TRUE )) {
-			Media_end( Mediap );
+		if (! dumpcompat(resumepr, level, *baseidp, BOOL_TRUE)) {
+			Media_end(Mediap);
 			return mlog_exit(EXIT_ERROR, RV_COMPAT);
 		}
-		strncpyterm( persp->s.dumplab,
+		strncpyterm(persp->s.dumplab,
 			     grhdrp->gh_dumplabel,
-			     sizeof( persp->s.dumplab ));
+			     sizeof(persp->s.dumplab));
 		sessp = 0;
 
 		/* don't look at the online inventory if the input is piped
 		 */
-		if ( ! drivep->d_isnamedpipepr
+		if (! drivep->d_isnamedpipepr
 		     &&
-		     ! drivep->d_isunnamedpipepr ) {
+		     ! drivep->d_isunnamedpipepr) {
 			ok = inv_get_session_byuuid(NULL,
 						    &grhdrp->gh_dumpid,
 						    &sessp);
-			if ( ok && sessp ) {
-				mlog( MLOG_VERBOSE, _(
-				      "using online session inventory\n") );
-				persp->s.fullinvpr = pi_transcribe( sessp );
-				inv_free_session( &sessp );
+			if (ok && sessp) {
+				mlog(MLOG_VERBOSE, _(
+				      "using online session inventory\n"));
+				persp->s.fullinvpr = pi_transcribe(sessp);
+				inv_free_session(&sessp);
 			}
 		}
-		fileh = pi_addfile( Mediap,
+		fileh = pi_addfile(Mediap,
 				    grhdrp,
 				    drhdrp,
 				    mrhdrp,
 				    scrhdrp,
-				    drivep );
+				    drivep);
 			/* done here because Media_mfile_next doesn't know
 			 * if this is a match
 			 */
-		if ( fileh == DH_NULL ) {
+		if (fileh == DH_NULL) {
 			return mlog_exit(EXIT_FAULT, RV_ERROR);
 		}
 		uuid_copy(persp->s.dumpid,grhdrp->gh_dumpid);
-		persp->s.begintime = time( 0 );
+		persp->s.begintime = time(0);
 		tranp->t_dumpidknwnpr = BOOL_TRUE;
 		tranp->t_sync2 = SYNC_DONE;
 	}
@@ -2216,15 +2216,15 @@ content_stream_restore( ix_t thrdix )
 	/* all drives coordinate in attempt to apply session dir dump.
 	 * only one actually completes.
 	 */
-	if ( persp->s.dirdonepr ) {
+	if (persp->s.dirdonepr) {
 		tranp->t_sync3 = SYNC_DONE;
 	}
-	if ( tranp->t_sync3 != SYNC_DONE ) {
-		mlog( MLOG_VERBOSE, _(
-		      "searching media for directory dump\n") );
+	if (tranp->t_sync3 != SYNC_DONE) {
+		mlog(MLOG_VERBOSE, _(
+		      "searching media for directory dump\n"));
 	}
-	while ( tranp->t_sync3 != SYNC_DONE ) {
-		rv = Media_mfile_next( Mediap,
+	while (tranp->t_sync3 != SYNC_DONE) {
+		rv = Media_mfile_next(Mediap,
 				       PURP_DIR,
 				       &tranp->t_sync3,
 				       &fileh,
@@ -2234,8 +2234,8 @@ content_stream_restore( ix_t thrdix )
 				       &crhdrp,
 				       &scrhdrp,
 				       &drivep,
-				       &fhdr );
-		switch ( rv ) {
+				       &fhdr);
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_DONE:
@@ -2244,117 +2244,117 @@ content_stream_restore( ix_t thrdix )
 		case RV_INTR:
 		case RV_QUIT:
 		case RV_DRIVE:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
-		assert( fileh != DH_NULL );
-		lock( );
-		if ( tranp->t_sync3 == SYNC_BUSY ) {
-			unlock( );
-			mlog( MLOG_TRACE,
-			      "waiting for directories to be restored\n" );
-			lock( );
-		}
-		while ( tranp->t_sync3 == SYNC_BUSY ) {
-			unlock( );
+		assert(fileh != DH_NULL);
+		lock();
+		if (tranp->t_sync3 == SYNC_BUSY) {
+			unlock();
+			mlog(MLOG_TRACE,
+			      "waiting for directories to be restored\n");
+			lock();
+		}
+		while (tranp->t_sync3 == SYNC_BUSY) {
+			unlock();
 #if DEBUG_DUMPSTREAMS
 			{
 			    static int count[STREAM_MAX] = {0};
-			    int streamix = stream_getix( pthread_self() );
+			    int streamix = stream_getix(pthread_self());
 			    if (++(count[streamix]) == 30) {
-				mlog( MLOG_TRACE,
+				mlog(MLOG_TRACE,
 					"still waiting for dirs to be restored\n");
 				count[streamix] = 0;
 			    }
 			}
 #endif
-			sleep( 1 );
-			if ( cldmgr_stop_requested( )) {
-				Media_end( Mediap );
+			sleep(1);
+			if (cldmgr_stop_requested()) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
-			lock( );
+			lock();
 		}
-		if ( tranp->t_sync3 == SYNC_DONE ) {
-			unlock( );
+		if (tranp->t_sync3 == SYNC_DONE) {
+			unlock();
 			continue;
 		}
-		if ( !(scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP) ) {
+		if (!(scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRDUMP)) {
 			/* if no streams have a directory dump, issue a
 			 * message and exit. first set SYNC_BUSY to prevent
 			 * other threads from coming through here and issuing
 			 * the same message.
 			 */
 			tranp->t_dirdumps &= ~(1ULL << thrdix);
-			if ( !tranp->t_dirdumps ) {
+			if (!tranp->t_dirdumps) {
 				tranp->t_sync3 = SYNC_BUSY;
 			}
-			unlock( );
-			if ( !tranp->t_dirdumps ) {
-				mlog( MLOG_VERBOSE | MLOG_ERROR, _(
-					"no directory dump found\n") );
-				Media_end( Mediap );
+			unlock();
+			if (!tranp->t_dirdumps) {
+				mlog(MLOG_VERBOSE | MLOG_ERROR, _(
+					"no directory dump found\n"));
+				Media_end(Mediap);
 				return mlog_exit(EXIT_NORMAL, RV_ERROR);
 			}
-			sleep( 1 );
-			if ( cldmgr_stop_requested( )) {
-				Media_end( Mediap );
+			sleep(1);
+			if (cldmgr_stop_requested()) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
 			continue;
 		}
 		tranp->t_sync3 = SYNC_BUSY;
-		unlock( );
-		if ( ! tranp->t_dirattrinitdonepr ) {
-			mlog( MLOG_TRACE,
-			      "initializing directory attributes registry\n" );
-			mlog( MLOG_NITTY,
+		unlock();
+		if (! tranp->t_dirattrinitdonepr) {
+			mlog(MLOG_TRACE,
+			      "initializing directory attributes registry\n");
+			mlog(MLOG_NITTY,
 			      "content_stream_restore: dircnt %llu\n",
-			      scrhdrp->cih_inomap_dircnt );
-			ok = dirattr_init( tranp->t_hkdir,
+			      scrhdrp->cih_inomap_dircnt);
+			ok = dirattr_init(tranp->t_hkdir,
 					   BOOL_FALSE,
-					   scrhdrp->cih_inomap_dircnt );
-			if ( ! ok ) {
-				Media_end( Mediap );
+					   scrhdrp->cih_inomap_dircnt);
+			if (! ok) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_dirattrinitdonepr = BOOL_TRUE;
 		}
 
-		if ( ! tranp->t_namreginitdonepr ) {
-			mlog( MLOG_TRACE,
-			      "initializing directory entry name registry\n" );
-			ok = namreg_init( tranp->t_hkdir,
+		if (! tranp->t_namreginitdonepr) {
+			mlog(MLOG_TRACE,
+			      "initializing directory entry name registry\n");
+			ok = namreg_init(tranp->t_hkdir,
 					  BOOL_FALSE,
 					  scrhdrp->cih_inomap_dircnt
 					  +
-					  scrhdrp->cih_inomap_nondircnt );
-			if ( ! ok ) {
-				Media_end( Mediap );
+					  scrhdrp->cih_inomap_nondircnt);
+			if (! ok) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_namreginitdonepr = BOOL_TRUE;
 		}
 
-		if ( ! tranp->t_treeinitdonepr ) {
+		if (! tranp->t_treeinitdonepr) {
 			bool_t fullpr;
 
-			fullpr = ( scrhdrp->cih_level
+			fullpr = (scrhdrp->cih_level
 				   ==
-				   0 )
+				   0)
 				 &&
-				 ! ( scrhdrp->cih_dumpattr
+				 ! (scrhdrp->cih_dumpattr
 				    &
-				    CIH_DUMPATTR_RESUME );
+				    CIH_DUMPATTR_RESUME);
 
-			mlog( MLOG_TRACE,
-			      "initializing directory hierarchy image\n" );
-			ok = tree_init( tranp->t_hkdir,
+			mlog(MLOG_TRACE,
+			      "initializing directory hierarchy image\n");
+			ok = tree_init(tranp->t_hkdir,
 					persp->a.dstdir,
 					tranp->t_toconlypr,
 					persp->a.ownerpr,
@@ -2368,17 +2368,17 @@ content_stream_restore( ix_t thrdix )
 					persp->a.restoredmpr,
 					persp->a.dstdirisxfspr,
 					grhdrp->gh_version,
-					tranp->t_truncategenpr );
-			if ( ! ok ) {
-				Media_end( Mediap );
+					tranp->t_truncategenpr);
+			if (! ok) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 			tranp->t_treeinitdonepr = BOOL_TRUE;
 
 		} else {
-			ok = tree_check_dump_format( grhdrp->gh_version );
-			if ( ! ok ) {
-				Media_end( Mediap );
+			ok = tree_check_dump_format(grhdrp->gh_version);
+			if (! ok) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_ERROR, RV_ERROR);
 			}
 		}
@@ -2388,31 +2388,31 @@ content_stream_restore( ix_t thrdix )
 		persp->s.valpr = BOOL_TRUE;
 		persp->a.valpr = BOOL_TRUE;
 
-		mlog( MLOG_VERBOSE, _(
-		      "reading directories\n") );
+		mlog(MLOG_VERBOSE, _(
+		      "reading directories\n"));
 		win_locks_off(); /* we are single threaded here */
-		rv = applydirdump( drivep, fileh, scrhdrp, &fhdr );
+		rv = applydirdump(drivep, fileh, scrhdrp, &fhdr);
 		win_locks_on();
-		mlog( MLOG_TRACE,
+		mlog(MLOG_TRACE,
 		      "number of mmap calls for windows = %lu\n", win_getnum_mmaps());
-		switch ( rv ) {
+		switch (rv) {
 		case RV_OK:
-			DH2F( fileh )->f_dirtriedpr = BOOL_TRUE;
-			Media_atnondir( Mediap );
+			DH2F(fileh)->f_dirtriedpr = BOOL_TRUE;
+			Media_atnondir(Mediap);
 			tranp->t_sync3 = SYNC_DONE;
 			break;
 		case RV_CORRUPT:
-			Media_indir( Mediap );
-			DH2F( fileh )->f_dirtriedpr = BOOL_TRUE;
+			Media_indir(Mediap);
+			DH2F(fileh)->f_dirtriedpr = BOOL_TRUE;
 			tranp->t_sync3 = SYNC_INIT;
 			break;
 		case RV_INTR:
 		case RV_DRIVE:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 	}
@@ -2420,61 +2420,61 @@ content_stream_restore( ix_t thrdix )
 	/* now let one thread do all tree post-processing prior to
 	 * non-dir restore
 	 */
-	if ( persp->s.treepostdonepr ) {
+	if (persp->s.treepostdonepr) {
 		tranp->t_sync4 = SYNC_DONE;
 	}
-	while ( tranp->t_sync4 != SYNC_DONE ) {
-		lock( );
-		if ( tranp->t_sync4 == SYNC_BUSY ) {
-			unlock( );
-			mlog( MLOG_TRACE,
+	while (tranp->t_sync4 != SYNC_DONE) {
+		lock();
+		if (tranp->t_sync4 == SYNC_BUSY) {
+			unlock();
+			mlog(MLOG_TRACE,
 			      "waiting for directory post-processing "
-			      "to complete\n" );
-			lock( );
+			      "to complete\n");
+			lock();
 		}
-		while ( tranp->t_sync4 == SYNC_BUSY ) {
-			unlock( );
+		while (tranp->t_sync4 == SYNC_BUSY) {
+			unlock();
 #if DEBUG_DUMPSTREAMS
 			{
 			static int count[STREAM_MAX] = {0};
-			int streamix = stream_getix( pthread_self() );
+			int streamix = stream_getix(pthread_self());
 			    if (++(count[streamix]) == 30) {
-				mlog( MLOG_NORMAL,
+				mlog(MLOG_NORMAL,
 				      "still waiting for dirs post-processing\n");
 				count[streamix] = 0;
 			    }
 			}
 #endif
-			sleep( 1 );
-			if ( cldmgr_stop_requested( )) {
-				Media_end( Mediap );
+			sleep(1);
+			if (cldmgr_stop_requested()) {
+				Media_end(Mediap);
 				return mlog_exit(EXIT_NORMAL, RV_INTR);
 			}
-			lock( );
+			lock();
 		}
-		if ( tranp->t_sync4 == SYNC_DONE ) {
-			unlock( );
+		if (tranp->t_sync4 == SYNC_DONE) {
+			unlock();
 			continue;
 		}
 		tranp->t_sync4 = SYNC_BUSY;
-		unlock( );
-		mlog( MLOG_VERBOSE, _(
-		      "directory post-processing\n") );
+		unlock();
+		mlog(MLOG_VERBOSE, _(
+		      "directory post-processing\n"));
 		win_locks_off(); /* we are single threaded here */
-		rv = treepost( path1, path2 );
+		rv = treepost(path1, path2);
 		win_locks_on();
-		switch ( rv ) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_ERROR:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_ERROR, RV_ERROR);
 		case RV_INTR:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_INTERRUPT, RV_INTR);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 
@@ -2486,12 +2486,12 @@ content_stream_restore( ix_t thrdix )
 		{
 		bool_t dummyknownholespr;
 		bool_t dummymaybeholespr;
-		bag_t *bagp = pi_neededobjs_nondir_alloc( &dummyknownholespr,
+		bag_t *bagp = pi_neededobjs_nondir_alloc(&dummyknownholespr,
 							  &dummymaybeholespr,
 							  BOOL_FALSE,
-							  BOOL_TRUE );
-		if ( bagp ) {
-			pi_neededobjs_free( bagp );
+							  BOOL_TRUE);
+		if (bagp) {
+			pi_neededobjs_free(bagp);
 			bagp = 0;
 		}
 		}
@@ -2505,9 +2505,9 @@ content_stream_restore( ix_t thrdix )
 	 * apply media files until there are no more, or we are interrupted
 	 */
 	for (;;) {
-		mlog( MLOG_DEBUG,
-		      "getting next media file for non-dir restore\n" );
-		rv = Media_mfile_next( Mediap,
+		mlog(MLOG_DEBUG,
+		      "getting next media file for non-dir restore\n");
+		rv = Media_mfile_next(Mediap,
 				       PURP_NONDIR,
 				       0,
 				       &fileh,
@@ -2517,64 +2517,64 @@ content_stream_restore( ix_t thrdix )
 				       &crhdrp,
 				       &scrhdrp,
 				       &drivep,
-				       &fhdr );
-		if ( rv == RV_NOMORE ) {
+				       &fhdr);
+		if (rv == RV_NOMORE) {
 			break;
 		}
-		switch ( rv ) {
+		switch (rv) {
 		case RV_OK:
 			break;
 		case RV_INTR:
 		case RV_QUIT:
 		case RV_DRIVE:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 		dcaps = drivep->d_capabilities;
-		assert( fileh > DH_NULL );
-		if ( tranp->t_toconlypr ) {
-			mlog( MLOG_VERBOSE, _(
-			      "reading non-directory files\n") );
+		assert(fileh > DH_NULL);
+		if (tranp->t_toconlypr) {
+			mlog(MLOG_VERBOSE, _(
+			      "reading non-directory files\n"));
 		} else {
-			mlog( MLOG_VERBOSE, _(
-			      "restoring non-directory files\n") );
+			mlog(MLOG_VERBOSE, _(
+			      "restoring non-directory files\n"));
 		}
-		mlog( MLOG_TRACE,
+		mlog(MLOG_TRACE,
 		      "media file %u in "
 		      "object %u "
 		      "of stream %u\n",
 		      mrhdrp->mh_mediafileix,
 		      mrhdrp->mh_mediaix,
-		      drhdrp->dh_driveix );
-		mlog( MLOG_DEBUG,
+		      drhdrp->dh_driveix);
+		mlog(MLOG_DEBUG,
 		      "file %u in stream, "
 		      "file %u in dump %u on object\n",
 		      mrhdrp->mh_dumpfileix,
 		      mrhdrp->mh_dumpmediafileix,
-		      mrhdrp->mh_dumpmediaix );
-		rv = applynondirdump( drivep,
+		      mrhdrp->mh_dumpmediaix);
+		rv = applynondirdump(drivep,
 				      fileh,
 				      scrhdrp,
 				      path1,
 				      path2,
-				      &fhdr );
-		switch ( rv ) {
+				      &fhdr);
+		switch (rv) {
 		case RV_OK:
-			DH2F( fileh )->f_nondirdonepr = BOOL_TRUE;
-			Media_end( Mediap );
+			DH2F(fileh)->f_nondirdonepr = BOOL_TRUE;
+			Media_end(Mediap);
 			break;
 		case RV_INTR:
 		case RV_DRIVE:
 		case RV_INCOMPLETE:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_NORMAL, rv);
 		case RV_CORE:
 		default:
-			Media_end( Mediap );
+			Media_end(Mediap);
 			return mlog_exit(EXIT_FAULT, rv);
 		}
 	}
@@ -2583,24 +2583,24 @@ content_stream_restore( ix_t thrdix )
 	 * and cleanup. the winner waits, the losers all exit.
 	 * once the losers exit, the winner can perform cleanup.
 	 */
-	lock( );
-	if ( tranp->t_sync5 == SYNC_BUSY ) {
-		unlock( );
+	lock();
+	if (tranp->t_sync5 == SYNC_BUSY) {
+		unlock();
 		return mlog_exit(EXIT_NORMAL, RV_DONE);
 	}
 	tranp->t_sync5 = SYNC_BUSY;
-	unlock( );
-	if ( drivecnt > 1 ) {
-		mlog( MLOG_TRACE,
-		      "waiting for other streams to exit\n" );
+	unlock();
+	if (drivecnt > 1) {
+		mlog(MLOG_TRACE,
+		      "waiting for other streams to exit\n");
 	}
-	while ( cldmgr_otherstreamsremain( thrdix )) {
-		sleep( 1 );
+	while (cldmgr_otherstreamsremain(thrdix)) {
+		sleep(1);
 	}
 
-	mlog( MLOG_DEBUG,
-	      "tree finalize\n" );
-	rv = finalize( path1, path2 );
+	mlog(MLOG_DEBUG,
+	      "tree finalize\n");
+	rv = finalize(path1, path2);
 	if (rv == RV_OK || rv == RV_INTR) {
 		rval = EXIT_NORMAL;
 	} else if (rv == RV_ERROR) {
@@ -2616,33 +2616,33 @@ content_stream_restore( ix_t thrdix )
  * if interrupted or not.
  */
 bool_t
-content_complete( void )
+content_complete(void)
 {
 	bool_t completepr;
 	time_t elapsed;
 
-	if ( ! persp ) {
+	if (! persp) {
 		completepr = BOOL_TRUE;
-	} else if ( ! persp->a.valpr ) {
+	} else if (! persp->a.valpr) {
 		completepr =  BOOL_TRUE;
-	} else if ( ! persp->s.valpr ) {
+	} else if (! persp->s.valpr) {
 		completepr =  BOOL_TRUE;
 	} else {
 		completepr = BOOL_FALSE;
 	}
 
-	elapsed = time( 0 ) - tranp->t_starttime;
-	if ( persp ) {
+	elapsed = time(0) - tranp->t_starttime;
+	if (persp) {
 		elapsed += persp->s.accumtime;
 	}
 
-	if ( completepr ) {
-		if ( tranp->t_toconlypr ) {
-			mlog( MLOG_VERBOSE, _(
+	if (completepr) {
+		if (tranp->t_toconlypr) {
+			mlog(MLOG_VERBOSE, _(
 			      "table of contents display complete"
 			      ": %ld seconds elapsed"
 			      "\n"),
-			      elapsed );
+			      elapsed);
 		} else {
 			int found;
 
@@ -2657,39 +2657,39 @@ content_complete( void )
 						CONTENT_GQUOTAFILE);
 
 			if (found)
-				mlog( MLOG_NORMAL,
-				      _("use \'xfs_quota\' to restore quotas\n") );
+				mlog(MLOG_NORMAL,
+				      _("use \'xfs_quota\' to restore quotas\n"));
 
-			mlog( MLOG_VERBOSE, _(
+			mlog(MLOG_VERBOSE, _(
 			      "restore complete"
 			      ": %ld seconds elapsed"
 			      "\n"),
-			      elapsed );
+			      elapsed);
 		}
-	} else if ( tranp->t_toconlypr ) {
-		mlog( MLOG_VERBOSE | MLOG_NOTE, _(
+	} else if (tranp->t_toconlypr) {
+		mlog(MLOG_VERBOSE | MLOG_NOTE, _(
 		      "table of contents display interrupted"
 		      ": %ld seconds elapsed"
 		      "\n"),
-		      elapsed );
+		      elapsed);
 	} else {
-		mlog( MLOG_VERBOSE | MLOG_NOTE, _(
+		mlog(MLOG_VERBOSE | MLOG_NOTE, _(
 		      "restore interrupted"
 		      ": %ld seconds elapsed"
 		      ": may resume later using -%c option"
 		      "\n"),
 		      elapsed,
-		      GETOPT_RESUME );
+		      GETOPT_RESUME);
 	}
 
 	/* accumulate total elapsed time
 	 */
-	if ( persp ) {
+	if (persp) {
 		persp->s.accumtime = elapsed;
 	}
 
-	if ( ! persp->a.valpr ) {
-		wipepersstate( );
+	if (! persp->a.valpr) {
+		wipepersstate();
 		persp = 0;
 	}
 
@@ -2699,10 +2699,10 @@ content_complete( void )
 #define STATLINESZ	160
 
 size_t
-content_statline( char **linespp[ ] )
+content_statline(char **linespp[])
 {
-	static char statlinebuf[ 1 ][ STATLINESZ ];
-	static char *statline[ 1 ];
+	static char statlinebuf[1][STATLINESZ];
+	static char *statline[1];
 	size64_t inodone;
 	off64_t datadone;
 	size64_t inocnt;
@@ -2715,12 +2715,12 @@ content_statline( char **linespp[ ] )
 
 	/* build and supply the line array
 	 */
-	for ( i = 0 ; i < 1 ; i++ ) {
-		statline[ i ] = &statlinebuf[ i ][ 0 ];
+	for (i = 0 ; i < 1 ; i++) {
+		statline[i] = &statlinebuf[i][0];
 	}
 	*linespp = statline;
 
-	if ( ! persp->s.stat_valpr ) {
+	if (! persp->s.stat_valpr) {
 		return 0;
 	}
 
@@ -2728,23 +2728,23 @@ content_statline( char **linespp[ ] )
 	 */
 	elapsed = persp->s.accumtime
 		  +
-		  ( time( 0 ) - tranp->t_starttime );
+		  (time(0) - tranp->t_starttime);
 
 	/* get local time
 	 */
-	now = time( 0 );
-	tmp = localtime( &now );
+	now = time(0);
+	tmp = localtime(&now);
 
-	if ( ! persp->s.dirdonepr ) {
-		if ( ! tranp->t_dircnt ) {
+	if (! persp->s.dirdonepr) {
+		if (! tranp->t_dircnt) {
 			return 0;
 		}
 
-		percent = ( double )tranp->t_dirdonecnt
+		percent = (double)tranp->t_dirdonecnt
 			  /
-			  ( double )tranp->t_dircnt;
+			  (double)tranp->t_dircnt;
 		percent *= 100.0;
-		sprintf( statline[ 0 ], _(
+		sprintf(statline[0], _(
 			 "status at %02d:%02d:%02d: "
 			 "%llu/%llu directories reconstructed, "
 			 "%.1f%%%% complete, "
@@ -2757,8 +2757,8 @@ content_statline( char **linespp[ ] )
 			 (unsigned long long)tranp->t_dircnt,
 			 percent,
 			 (unsigned long long)tranp->t_direntcnt,
-			 elapsed );
-		assert( strlen( statline[ 0 ] ) < STATLINESZ );
+			 elapsed);
+		assert(strlen(statline[0]) < STATLINESZ);
 
 		return 1;
 	}
@@ -2773,21 +2773,21 @@ content_statline( char **linespp[ ] )
 
 	/* calculate percentage of data dumped
 	 */
-	if ( datacnt ) {
-		percent = ( double )datadone
+	if (datacnt) {
+		percent = (double)datadone
 			  /
-			  ( double )datacnt;
+			  (double)datacnt;
 		percent *= 100.0;
 	} else {
 		percent = 100.0;
 	}
-	if ( percent > 100.0 ) {
+	if (percent > 100.0) {
 		percent = 100.0;
 	}
 
 	/* format the status line in a local static buffer (non-re-entrant!)
 	 */
-	sprintf( statline[ 0 ], _(
+	sprintf(statline[0], _(
 		 "status at %02d:%02d:%02d: %llu/%llu files restored, "
 		 "%.1f%%%% complete, "
 		 "%ld seconds elapsed\n"),
@@ -2797,8 +2797,8 @@ content_statline( char **linespp[ ] )
 		 (unsigned long long)inodone,
 		 (unsigned long long)inocnt,
 		 percent,
-		 elapsed );
-	assert( strlen( statline[ 0 ] ) < STATLINESZ );
+		 elapsed);
+	assert(strlen(statline[0]) < STATLINESZ);
 
 	/* return buffer to caller
 	 */
@@ -2806,28 +2806,28 @@ content_statline( char **linespp[ ] )
 }
 
 void
-content_showinv( void )
+content_showinv(void)
 {
-	pi_show_nomloglock( );
+	pi_show_nomloglock();
 }
 
 void
-content_showremainingobjects( void )
+content_showremainingobjects(void)
 {
 	bool_t knownholespr = BOOL_FALSE;
 	bool_t maybeholespr = BOOL_FALSE;
 	bag_t *bagp;
 
-	bagp = pi_neededobjs_nondir_alloc( &knownholespr,
+	bagp = pi_neededobjs_nondir_alloc(&knownholespr,
 					   &maybeholespr,
 					   BOOL_TRUE,
-					   BOOL_FALSE );
-	display_needed_objects( PURP_NONDIR,
+					   BOOL_FALSE);
+	display_needed_objects(PURP_NONDIR,
 				bagp,
 				knownholespr,
-				maybeholespr );
-	if ( bagp ) {
-		pi_neededobjs_free( bagp );
+				maybeholespr);
+	if (bagp) {
+		pi_neededobjs_free(bagp);
 		bagp = 0;
 	}
 }
@@ -2845,17 +2845,17 @@ content_showremainingobjects( void )
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
-	char *ackstr[ ACKMAX ];
+	char *ackstr[ACKMAX];
 	size_t ackcnt;
 	size_t maxdrvchoiceix;
 	size_t infoix;
@@ -2864,30 +2864,30 @@ content_mediachange_query( void )
 	ix_t thrdix;
 
 	infoix = querycnt = 0;
-	querystr[ querycnt++ ] =
+	querystr[querycnt++] =
 		_("select a drive to acknowledge media change\n");
 	choicecnt = 0;
 	maxdrvchoiceix = 0;
-	for ( thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++ ) {
-		if ( mcflag[ thrdix ] ) {
-			choicetothrdmap[ choicecnt ].thrdix = thrdix;
-			sprintf( choicetothrdmap[ choicecnt ].choicestr,
+	for (thrdix = 0 ; thrdix < STREAM_SIMMAX ; thrdix++) {
+		if (mcflag[thrdix]) {
+			choicetothrdmap[choicecnt].thrdix = thrdix;
+			sprintf(choicetothrdmap[choicecnt].choicestr,
 				 _("drive %u"),
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
-	if ( persp->s.valpr ) {
+	if (persp->s.valpr) {
 		infoix = choicecnt;
-		choicestr[ choicecnt++ ] = _("display needed media objects");
+		choicestr[choicecnt++ ] = _("display needed media objects");
 	}
 	nochangeix = choicecnt;
-	choicestr[ choicecnt++ ] = _("continue");
-	assert( choicecnt <= CHOICEMAX );
-	responseix = dlog_multi_query( querystr,
+	choicestr[choicecnt++ ] = _("continue");
+	assert(choicecnt <= CHOICEMAX);
+	responseix = dlog_multi_query(querystr,
 				       querycnt,
 				       choicestr,
 				       choicecnt,
@@ -2900,34 +2900,34 @@ content_mediachange_query( void )
 				       nochangeix, /* sigint ix */
 				       nochangeix, /* sighup ix */
 				       nochangeix);/* sigquit ix */
-	if ( responseix <= maxdrvchoiceix ) {
-		clr_mcflag( choicetothrdmap[ responseix ].thrdix );
+	if (responseix <= maxdrvchoiceix) {
+		clr_mcflag(choicetothrdmap[responseix].thrdix);
 		return _("media change acknowledged\n");
 	}
-	if ( responseix == infoix ) {
+	if (responseix == infoix) {
 		bool_t knownholespr = BOOL_FALSE;
 		bool_t maybeholespr = BOOL_FALSE;
-		bag_t *bagp = pi_neededobjs_nondir_alloc( &knownholespr,
+		bag_t *bagp = pi_neededobjs_nondir_alloc(&knownholespr,
 							  &maybeholespr,
 							  BOOL_FALSE,
-							  BOOL_FALSE );
-		display_needed_objects( PURP_NONDIR,
+							  BOOL_FALSE);
+		display_needed_objects(PURP_NONDIR,
 					bagp,
 					knownholespr,
-					maybeholespr );
-		if ( bagp ) {
-			pi_neededobjs_free( bagp );
+					maybeholespr);
+		if (bagp) {
+			pi_neededobjs_free(bagp);
 			bagp = 0;
 		}
 		ackcnt = 0;
-		dlog_multi_ack( ackstr,
-				ackcnt );
+		dlog_multi_ack(ackstr,
+				ackcnt);
 		querycnt = 0;
 		choicecnt = 0;
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
@@ -2942,7 +2942,7 @@ content_mediachange_query( void )
 					       nochangeix);/* sigquit ix */
 		return _("continuing\n");
 	}
-	assert( responseix == nochangeix );
+	assert(responseix == nochangeix);
 	return _("continuing\n");
 }
 
@@ -2954,60 +2954,60 @@ content_mediachange_query( void )
  */
 /* ARGSUSED */
 static rv_t
-applydirdump( drive_t *drivep,
+applydirdump(drive_t *drivep,
 	      dh_t fileh,
 	      content_inode_hdr_t *scrhdrp,
-	      filehdr_t *fhdrp )
+	      filehdr_t *fhdrp)
 {
 	bool_t fhcs;
 	bool_t dhcs;
 	bool_t ahcs;
 
-	fhcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM )
+	fhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	dhcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRENTHDR_CHECKSUM )
+	dhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRENTHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	ahcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM )
+	ahcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
 
-	if ( ! persp->s.marknorefdonepr ) {
-		tree_marknoref( );
+	if (! persp->s.marknorefdonepr) {
+		tree_marknoref();
 		persp->s.marknorefdonepr = BOOL_TRUE;
 	}
 
-	if ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_NOTSELFCONTAINED ) {
-		mlog( MLOG_NORMAL | MLOG_NOTE, _(
+	if (scrhdrp->cih_dumpattr & CIH_DUMPATTR_NOTSELFCONTAINED) {
+		mlog(MLOG_NORMAL | MLOG_NOTE, _(
 		      "dump is not self-contained, "
 		      "orphaned files expected if base dump(s) "
-		      "was not applied\n") );
+		      "was not applied\n"));
 	}
 
-	if ( ! persp->s.dirdonepr ) {
+	if (! persp->s.dirdonepr) {
 		rv_t rv;
 		dah_t dah;
 
-		char _direntbuf[ sizeof( direnthdr_t )
+		char _direntbuf[sizeof(direnthdr_t)
 				+
 				NAME_MAX + 1
 				+
-				DIRENTHDR_ALIGN ];
+				DIRENTHDR_ALIGN];
 		char *direntbuf = ALIGN_PTR(_direntbuf, DIRENTHDR_ALIGN);
 		size_t direntbufsz =
 			sizeof(_direntbuf) - (direntbuf - _direntbuf);
 
-		mlog( MLOG_TRACE,
-		      "reading the ino map\n" );
-		rv = inomap_restore_pers( drivep, scrhdrp, tranp->t_hkdir );
-		if ( rv != RV_OK ) {
+		mlog(MLOG_TRACE,
+		      "reading the ino map\n");
+		rv = inomap_restore_pers(drivep, scrhdrp, tranp->t_hkdir);
+		if (rv != RV_OK) {
 			return rv;
 		}
 
@@ -3015,8 +3015,8 @@ applydirdump( drive_t *drivep,
 		tranp->t_dirdonecnt = 0;
 		tranp->t_direntcnt = 0;
 
-		mlog( MLOG_TRACE,
-		      "reading the directories \n" );
+		mlog(MLOG_TRACE,
+		      "reading the directories \n");
 
 		dah = DAH_NULL;
 		for (;;) {
@@ -3024,8 +3024,8 @@ applydirdump( drive_t *drivep,
 
 			/* read the file header
 			 */
-			rv = read_filehdr( drivep, fhdrp, fhcs );
-			if ( rv ) {
+			rv = read_filehdr(drivep, fhdrp, fhcs);
+			if (rv) {
 				return rv;
 			}
 
@@ -3033,44 +3033,44 @@ applydirdump( drive_t *drivep,
 			 * reading dirs, and there are no nondirs.
 			 * done.
 			 */
-			if ( fhdrp->fh_flags & FILEHDR_FLAGS_NULL ) {
+			if (fhdrp->fh_flags & FILEHDR_FLAGS_NULL) {
 				break;
 			}
 
 			/* if its not a directory, must be the
 			 * first non-dir file. done.
 			 */
-			if ( ( fhdrp->fh_stat.bs_mode & S_IFMT ) != S_IFDIR ) {
+			if ((fhdrp->fh_stat.bs_mode & S_IFMT) != S_IFDIR) {
 				break;
 			}
 
 			/* if stop requested bail out gracefully
 			 */
-			if ( cldmgr_stop_requested( )) {
+			if (cldmgr_stop_requested()) {
 				return RV_INTR;
 			}
 
-			/* if in a pipeline , call preemptchk( ) to
+			/* if in a pipeline , call preemptchk() to
 			 * print status reports
 			 */
-			if ( pipeline )
+			if (pipeline)
 			{
-				mlog( MLOG_DEBUG ,
+				mlog(MLOG_DEBUG ,
 					"preemptchk( )\n");
-				preemptchk( );
+				preemptchk();
 			}
 
 			/* may be an extended attributes file hdr
 			 */
-			if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
-				rv = restore_extattr( drivep,
+			if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
+				rv = restore_extattr(drivep,
 						      fhdrp,
 						      0,
 						      ahcs,
 						      BOOL_TRUE, /* isdirpr */
 						      BOOL_FALSE, /* onlydoreadpr */
-						      dah );
-				if ( rv != RV_OK ) {
+						      dah);
+				if (rv != RV_OK) {
 					return rv;
 				}
 				continue;
@@ -3083,7 +3083,7 @@ applydirdump( drive_t *drivep,
 			 * with that dir.
 			 */
 			dah = DAH_NULL;
-			dirh = tree_begindir( fhdrp, &dah );
+			dirh = tree_begindir(fhdrp, &dah);
 			if (dirh == NH_NULL)
 			    return RV_ERROR;
 
@@ -3091,16 +3091,16 @@ applydirdump( drive_t *drivep,
 			 * tree with them. we can tell when we are done
 			 * by looking for a null dirent.
 			 */
-			for ( ; ; ) {
+			for (; ;) {
 				register direnthdr_t *dhdrp =
-						    ( direnthdr_t * )direntbuf;
+						    (direnthdr_t *)direntbuf;
 				register size_t namelen;
 
-				rv = read_dirent( drivep,
+				rv = read_dirent(drivep,
 						  dhdrp,
 						  direntbufsz,
-						  dhcs );
-				if ( rv != RV_OK ) {
+						  dhcs);
+				if (rv != RV_OK) {
 					return rv;
 				}
 
@@ -3108,26 +3108,26 @@ applydirdump( drive_t *drivep,
 				 * break out of this inner loop and
 				 * move on th the next dir.
 				 */
-				if ( dhdrp->dh_ino == 0 ) {
+				if (dhdrp->dh_ino == 0) {
 					break;
 				}
-				namelen = strlen( dhdrp->dh_name );
-				assert( namelen <= NAME_MAX );
+				namelen = strlen(dhdrp->dh_name);
+				assert(namelen <= NAME_MAX);
 
 				/* add this dirent to the tree.
 				 */
-				rv = tree_addent( dirh,
+				rv = tree_addent(dirh,
 					     dhdrp->dh_ino,
 					     dhdrp->dh_gen,
 					     dhdrp->dh_name,
-					     namelen );
-				if ( rv != RV_OK ) {
+					     namelen);
+				if (rv != RV_OK) {
 					return rv;
 				}
 				tranp->t_direntcnt++;
 			}
 
-			tree_enddir( dirh );
+			tree_enddir(dirh);
 
 			tranp->t_dirdonecnt++;
 		}
@@ -3143,7 +3143,7 @@ applydirdump( drive_t *drivep,
 		persp->s.dirdonepr = BOOL_TRUE;
 	}
 
-	mlog( MLOG_VERBOSE, _("%llu directories and %llu entries processed\n"),
+	mlog(MLOG_VERBOSE, _("%llu directories and %llu entries processed\n"),
 		tranp->t_dirdonecnt, tranp->t_direntcnt);
 
 	return RV_OK;
@@ -3155,54 +3155,54 @@ applydirdump( drive_t *drivep,
  */
 /* ARGSUSED */
 rv_t
-eatdirdump( drive_t *drivep,
+eatdirdump(drive_t *drivep,
 	    dh_t fileh,
 	    content_inode_hdr_t *scrhdrp,
-	    filehdr_t *fhdrp )
+	    filehdr_t *fhdrp)
 {
 	bool_t fhcs;
 	bool_t dhcs;
 	bool_t ahcs;
 
-	char _direntbuf[ sizeof( direnthdr_t )
+	char _direntbuf[sizeof(direnthdr_t)
 			+
 			NAME_MAX + 1
 			+
-			DIRENTHDR_ALIGN ];
+			DIRENTHDR_ALIGN];
 	char *direntbuf = ALIGN_PTR(_direntbuf, DIRENTHDR_ALIGN);
 	size_t direntbufsz = sizeof(_direntbuf) - (direntbuf - _direntbuf);
 	rv_t rv;
 
-	fhcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM )
+	fhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	dhcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRENTHDR_CHECKSUM )
+	dhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_DIRENTHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	ahcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM )
+	ahcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
 
-	mlog( MLOG_DEBUG,
-	      "discarding ino map\n" );
-	rv = inomap_discard( drivep, scrhdrp );
-	if ( rv != RV_OK ) {
+	mlog(MLOG_DEBUG,
+	      "discarding ino map\n");
+	rv = inomap_discard(drivep, scrhdrp);
+	if (rv != RV_OK) {
 		return rv;
 	}
 
-	mlog( MLOG_DEBUG,
-	      "discarding directories \n" );
+	mlog(MLOG_DEBUG,
+	      "discarding directories \n");
 	for (;;) {
 		/* read the file header
 		 */
-		rv = read_filehdr( drivep, fhdrp, fhcs );
-		if ( rv ) {
+		rv = read_filehdr(drivep, fhdrp, fhcs);
+		if (rv) {
 			return rv;
 		}
 
@@ -3210,34 +3210,34 @@ eatdirdump( drive_t *drivep,
 		 * reading dirs, and there are no nondirs.
 		 * done.
 		 */
-		if ( fhdrp->fh_flags & FILEHDR_FLAGS_NULL ) {
+		if (fhdrp->fh_flags & FILEHDR_FLAGS_NULL) {
 			break;
 		}
 
 		/* if its not a directory, must be the
 		 * first non-dir file. done.
 		 */
-		if ( ( fhdrp->fh_stat.bs_mode & S_IFMT ) != S_IFDIR ) {
+		if ((fhdrp->fh_stat.bs_mode & S_IFMT) != S_IFDIR) {
 			break;
 		}
 
 		/* if stop requested bail out gracefully
 		 */
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
 		/* may be an extended attributes file hdr
 		 */
-		if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
-			rv = restore_extattr( drivep,
+		if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
+			rv = restore_extattr(drivep,
 					      fhdrp,
 					      0,
 					      ahcs,
 					      BOOL_TRUE, /* isdirpr */
 					      BOOL_TRUE, /* onlydoreadpr */
-					      DAH_NULL );
-			if ( rv != RV_OK ) {
+					      DAH_NULL);
+			if (rv != RV_OK) {
 				return rv;
 			}
 			continue;
@@ -3247,17 +3247,17 @@ eatdirdump( drive_t *drivep,
 		 * we can tell when we are done
 		 * by looking for a null dirent.
 		 */
-		for ( ; ; ) {
+		for (; ;) {
 			register direnthdr_t *dhdrp =
-					    ( direnthdr_t * )direntbuf;
+					    (direnthdr_t *)direntbuf;
 			/* REFERENCED */
 			register size_t namelen;
 
-			rv = read_dirent( drivep,
+			rv = read_dirent(drivep,
 					  dhdrp,
 					  direntbufsz,
-					  dhcs );
-			if ( rv ) {
+					  dhcs);
+			if (rv) {
 				return rv;
 			}
 
@@ -3265,11 +3265,11 @@ eatdirdump( drive_t *drivep,
 			 * break out of this inner loop and
 			 * move on th the next dir.
 			 */
-			if ( dhdrp->dh_ino == 0 ) {
+			if (dhdrp->dh_ino == 0) {
 				break;
 			}
-			namelen = strlen( dhdrp->dh_name );
-			assert( namelen <= NAME_MAX );
+			namelen = strlen(dhdrp->dh_name);
+			assert(namelen <= NAME_MAX);
 		}
 	}
 
@@ -3282,27 +3282,27 @@ eatdirdump( drive_t *drivep,
  * until no point in doing so.
  */
 static rv_t
-treepost( char *path1, char *path2 )
+treepost(char *path1, char *path2)
 {
 	bool_t ok;
 
 #ifdef TREE_CHK
 	/* first scan the tree for corruption
 	 */
-	mlog( MLOG_DEBUG | MLOG_TREE,
-	      "checking tree for consistency\n" );
-	if ( ! tree_chk( )) {
+	mlog(MLOG_DEBUG | MLOG_TREE,
+	      "checking tree for consistency\n");
+	if (! tree_chk()) {
 		return RV_CORE;
 	}
 #endif /* TREE_CHK */
 
 	/* adjust ref flags based on what dirs were dumped
 	 */
-	if ( ! persp->s.adjrefdonepr ) {
-		mlog( MLOG_DEBUG | MLOG_TREE,
-		      "adjusting dirent ref flags\n" );
-		ok = tree_adjref( );
-		if ( ! ok ) {
+	if (! persp->s.adjrefdonepr) {
+		mlog(MLOG_DEBUG | MLOG_TREE,
+		      "adjusting dirent ref flags\n");
+		ok = tree_adjref();
+		if (! ok) {
 			return RV_INTR;
 		}
 		persp->s.adjrefdonepr = BOOL_TRUE;
@@ -3312,61 +3312,61 @@ treepost( char *path1, char *path2 )
 	 * so only inos selected by subtree or interactive cmds will
 	 * be present in inomap.
 	 */
-	if ( ! persp->s.inomapsanitizedonepr ) {
-		if ( persp->a.interpr
+	if (! persp->s.inomapsanitizedonepr) {
+		if (persp->a.interpr
 		     ||
-		     ( persp->a.firststsenseprvalpr
+		     (persp->a.firststsenseprvalpr
 		       &&
-		       persp->a.firststsensepr )) {
-			inomap_sanitize( );
+		       persp->a.firststsensepr)) {
+			inomap_sanitize();
 		}
 		persp->s.inomapsanitizedonepr = BOOL_TRUE;
 	}
 
 	/* apply subtree selections
 	 */
-	if ( ! persp->s.stdonepr ) {
+	if (! persp->s.stdonepr) {
 		ix_t stix;
 		stdesc_t *stdescp;
 
-		mlog( MLOG_DEBUG | MLOG_TREE,
-		      "applying subtree selections\n" );
+		mlog(MLOG_DEBUG | MLOG_TREE,
+		      "applying subtree selections\n");
 
 		/* if first subtree selection is inclusive in sense,
 		 * first mark the entire tree as unselected. otherwise,
 		 * select all (no subtree selections or first was excluding).
 		 */
-		if ( ( persp->a.interpr
+		if ((persp->a.interpr
 		       &&
-		       ( ! persp->a.firststsenseprvalpr
+		       (! persp->a.firststsenseprvalpr
 		         ||
-		         persp->a.firststsensepr ))
+		         persp->a.firststsensepr))
 		     ||
-		     ( persp->a.firststsenseprvalpr
+		     (persp->a.firststsenseprvalpr
 		       &&
-		       persp->a.firststsensepr )) {
-			tree_markallsubtree( BOOL_FALSE );
+		       persp->a.firststsensepr)) {
+			tree_markallsubtree(BOOL_FALSE);
 		} else {
-			tree_markallsubtree( BOOL_TRUE );
+			tree_markallsubtree(BOOL_TRUE);
 		}
 
 		/* now apply all subtree commands from command line
 		 */
-		for ( stix = 0,
-		      stdescp = ( stdesc_t * )( ( char * )persp + perssz )
+		for (stix = 0,
+		      stdescp = (stdesc_t *)((char *)persp + perssz)
 		      ;
 		      stix < persp->a.stcnt
 		      ;
 		      stix++,
-		      stdescp = ( stdesc_t * )( ( char * )stdescp
+		      stdescp = (stdesc_t *)((char *)stdescp
 						+
-						stdescp->std_nextoff )) {
-			ok = tree_subtree_parse( stdescp->std_sensepr,
-						 stdescp->std_path );
-			if ( ! ok ) {
-				mlog( MLOG_NORMAL | MLOG_ERROR, _(
+						stdescp->std_nextoff)) {
+			ok = tree_subtree_parse(stdescp->std_sensepr,
+						 stdescp->std_path);
+			if (! ok) {
+				mlog(MLOG_NORMAL | MLOG_ERROR, _(
 				      "subtree argument %s invalid\n"),
-				      stdescp->std_path );
+				      stdescp->std_path);
 				return RV_ERROR;
 			}
 		}
@@ -3375,24 +3375,24 @@ treepost( char *path1, char *path2 )
 
 	/* next engage interactive subtree selection
 	 */
-	if ( ! persp->s.interdonepr ) {
-		if ( persp->a.interpr ) {
-			ok = tree_subtree_inter( );
-			if ( ! ok ) {
+	if (! persp->s.interdonepr) {
+		if (persp->a.interpr) {
+			ok = tree_subtree_inter();
+			if (! ok) {
 				return RV_INTR;
 			}
 		}
 		persp->s.interdonepr = BOOL_TRUE;
 	}
 
-	ok = tree_post( path1, path2 );
+	ok = tree_post(path1, path2);
 
-	if ( ! ok ) {
+	if (! ok) {
 		return RV_INTR;
 	}
 
-	ok = tree_extattr( restore_dir_extattr_cb, path1 );
-	if ( ! ok ) {
+	ok = tree_extattr(restore_dir_extattr_cb, path1);
+	if (! ok) {
 		return RV_INTR;
 	}
 
@@ -3402,12 +3402,12 @@ treepost( char *path1, char *path2 )
 }
 
 static rv_t
-applynondirdump( drive_t *drivep,
+applynondirdump(drive_t *drivep,
 		 dh_t fileh,
 		 content_inode_hdr_t *scrhdrp,
 		 char *path1,
 		 char *path2,
-		 filehdr_t *fhdrp )
+		 filehdr_t *fhdrp)
 {
 	rv_t rv = RV_UNKNOWN;
 	bool_t fhcs;
@@ -3419,17 +3419,17 @@ applynondirdump( drive_t *drivep,
 
 	/* determine if file header and/or extent heade checksums present
 	 */
-	fhcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM )
+	fhcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_FILEHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	ehcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTENTHDR_CHECKSUM )
+	ehcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTENTHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
 	       BOOL_FALSE;
-	ahcs = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM )
+	ahcs = (scrhdrp->cih_dumpattr & CIH_DUMPATTR_EXTATTRHDR_CHECKSUM)
 	       ?
 	       BOOL_TRUE
 	       :
@@ -3438,7 +3438,7 @@ applynondirdump( drive_t *drivep,
 	/* determine the first and next egrps needed from this media file.
 	 * used to decide if stats should be updated
 	 */
-	pi_bracketneededegrps( fileh, &first_egrp, &next_egrp );
+	pi_bracketneededegrps(fileh, &first_egrp, &next_egrp);
 
 	/* initialize the stream context
 	 */
@@ -3448,7 +3448,7 @@ applynondirdump( drive_t *drivep,
 	strctxp->sc_ownerset = BOOL_FALSE;
 
 
-	for ( ; ; ) {
+	for (; ;) {
 		drive_ops_t *dop = drivep->d_opsp;
 		drive_mark_t drivemark;
 		bstat_t *bstatp = &fhdrp->fh_stat;
@@ -3457,7 +3457,7 @@ applynondirdump( drive_t *drivep,
 
 		/* if a null file header, break
 		 */
-		if ( fhdrp->fh_flags & FILEHDR_FLAGS_NULL ) {
+		if (fhdrp->fh_flags & FILEHDR_FLAGS_NULL) {
 			rv = RV_OK;
 			goto applynondirdump_out;
 		}
@@ -3465,7 +3465,7 @@ applynondirdump( drive_t *drivep,
 		/* if working on a different file than we were previously,
 		 * complete the old one and begin the new one.
 		 */
-		if ( bstatp->bs_ino != strctxp->sc_bstat.bs_ino ) {
+		if (bstatp->bs_ino != strctxp->sc_bstat.bs_ino) {
 
 			restore_complete_reg(strctxp);
 
@@ -3475,39 +3475,39 @@ applynondirdump( drive_t *drivep,
 			strctxp->sc_fd = -1;
 			strctxp->sc_ownerset = BOOL_FALSE;
 
-			rv = restore_file( drivep, fhdrp, ehcs, ahcs, path1, path2 );
+			rv = restore_file(drivep, fhdrp, ehcs, ahcs, path1, path2);
 
-		} else if ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR ) {
-			rv = restore_extattr( drivep,
+		} else if (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR) {
+			rv = restore_extattr(drivep,
 					      fhdrp,
 					      strctxp->sc_path,
 					      ahcs,
 					      BOOL_FALSE, /* isdirpr */
 					      BOOL_FALSE, /* onlydoreadpr */
-					      DAH_NULL );
+					      DAH_NULL);
 		} else {
 			/* Must be another extent group for the current file */
-			restore_extent_group( drivep,
+			restore_extent_group(drivep,
 					      fhdrp,
 					      strctxp->sc_path,
 					      strctxp->sc_fd,
 					      ehcs,
-					      &rv );
+					      &rv);
 		}
 
-		switch( rv ) {
+		switch(rv) {
 		case RV_OK:
 			break;
 		case RV_EOD:
 			rv = RV_OK;
 			goto applynondirdump_out;
 		case RV_CORRUPT:
-			rval = ( * dop->do_next_mark )( drivep );
-			if ( rval ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			rval = (* dop->do_next_mark)(drivep);
+			if (rval) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "unable to resync media file: "
 				      "some portion of dump will NOT "
-				      "be restored\n") );
+				      "be restored\n"));
 				rv = RV_OK;  /* treat as EOD */
 				goto applynondirdump_out;
 			}
@@ -3519,25 +3519,25 @@ applynondirdump( drive_t *drivep,
 
 		/* update stats if appropriate
 		 */
-		if ( ( ( bstatp->bs_mode & S_IFMT ) == S_IFREG )
+		if (((bstatp->bs_mode & S_IFMT) == S_IFREG)
 		     &&
-		     ! ( fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR )
+		     ! (fhdrp->fh_flags & FILEHDR_FLAGS_EXTATTR)
 		     &&
-		     fhdrp->fh_offset == 0 ) {
+		     fhdrp->fh_offset == 0) {
 			egrp_t cur_egrp;
 			cur_egrp.eg_ino = fhdrp->fh_stat.bs_ino;
 			cur_egrp.eg_off = fhdrp->fh_offset;
-			if (cur_egrp.eg_ino > first_egrp.eg_ino ) {
-				if ( cur_egrp.eg_ino < next_egrp.eg_ino
+			if (cur_egrp.eg_ino > first_egrp.eg_ino) {
+				if (cur_egrp.eg_ino < next_egrp.eg_ino
 				     ||
-				     next_egrp.eg_off > 0 ) {
-					assert( cur_egrp.eg_ino
+				     next_egrp.eg_off > 0) {
+					assert(cur_egrp.eg_ino
 						<=
-						next_egrp.eg_ino );
-					pi_update_stats( bstatp->bs_blocks
+						next_egrp.eg_ino);
+					pi_update_stats(bstatp->bs_blocks
 							 *
-							 ( off64_t )
-							 bstatp->bs_blksize );
+							 (off64_t)
+							 bstatp->bs_blksize);
 				}
 			}
 		}
@@ -3545,24 +3545,24 @@ applynondirdump( drive_t *drivep,
 		do {
 			/* get a mark for the next read, in case we restart here
 			 */
-			( * dop->do_get_mark )( drivep, &drivemark );
+			(* dop->do_get_mark)(drivep, &drivemark);
 
 			/* read the file header.
 			 */
-			rv = read_filehdr( drivep, fhdrp, fhcs );
-			switch( rv ) {
+			rv = read_filehdr(drivep, fhdrp, fhcs);
+			switch(rv) {
 			case RV_OK:
 				break;
 			case RV_EOD:
 				rv = RV_OK;
 				goto applynondirdump_out;
 			case RV_CORRUPT:
-				rval = ( * dop->do_next_mark )( drivep );
-				if ( rval ) {
-					mlog( MLOG_NORMAL | MLOG_WARNING, _(
+				rval = (* dop->do_next_mark)(drivep);
+				if (rval) {
+					mlog(MLOG_NORMAL | MLOG_WARNING, _(
 					      "unable to resync media file: "
 					      "some portion of dump will NOT "
-					      "be restored\n") );
+					      "be restored\n"));
 					rv = RV_OK;  /* treat as EOD */
 					goto applynondirdump_out;
 				}
@@ -3571,33 +3571,33 @@ applynondirdump( drive_t *drivep,
 				goto applynondirdump_out;
 			}
 
-			if ( resyncpr && rv == RV_OK ) {
-				mlog( MLOG_NORMAL | MLOG_WARNING, _(
+			if (resyncpr && rv == RV_OK) {
+				mlog(MLOG_NORMAL | MLOG_WARNING, _(
 				      "resynchronization achieved at "
 				      "ino %llu offset %lld\n"),
 				      fhdrp->fh_stat.bs_ino,
-				      fhdrp->fh_offset );
+				      fhdrp->fh_offset);
 				resyncpr = BOOL_FALSE;
 			}
-		} while ( resyncpr );
+		} while (resyncpr);
 
 		/* checkpoint into persistent state if not a null file hdr
 		 */
-		if ( ! ( fhdrp->fh_flags & FILEHDR_FLAGS_NULL )) {
-			pi_checkpoint( fileh,
+		if (! (fhdrp->fh_flags & FILEHDR_FLAGS_NULL)) {
+			pi_checkpoint(fileh,
 				       &drivemark,
 				       fhdrp->fh_stat.bs_ino,
-				       fhdrp->fh_offset );
+				       fhdrp->fh_offset);
 		}
 
-		/* if in a pipeline , call preemptchk( ) to
+		/* if in a pipeline , call preemptchk() to
 		 * print status reports
 		 */
-		if ( pipeline )
+		if (pipeline)
 		{
-			mlog( MLOG_DEBUG ,
+			mlog(MLOG_DEBUG ,
 				"preemptchk( )\n");
-			preemptchk( );
+			preemptchk();
 		}
 	}
 
@@ -3614,17 +3614,17 @@ applynondirdump_out:
 
 /* ARGSUSED */
 static rv_t
-finalize( char *path1, char *path2 )
+finalize(char *path1, char *path2)
 {
 	bool_t ok;
 
-	if ( ! tranp->t_toconlypr ) {
+	if (! tranp->t_toconlypr) {
 
 		/* restore directory attributes
 		 */
-		if ( ! persp->s.dirattrdonepr ) {;
-			ok = tree_setattr( path1 );
-			if ( ! ok ) {
+		if (! persp->s.dirattrdonepr) {;
+			ok = tree_setattr(path1);
+			if (! ok) {
 				return RV_INTR;
 			}
 			persp->s.dirattrdonepr = BOOL_TRUE;
@@ -3632,9 +3632,9 @@ finalize( char *path1, char *path2 )
 
 		/* remove orphanage if empty
 		 */
-		if ( ! persp->s.orphdeltriedpr ) {;
-			ok = tree_delorph( );
-			if ( ! ok ) {
+		if (! persp->s.orphdeltriedpr) {;
+			ok = tree_delorph();
+			if (! ok) {
 				return RV_INTR;
 			}
 			persp->s.orphdeltriedpr = BOOL_TRUE;
@@ -3642,8 +3642,8 @@ finalize( char *path1, char *path2 )
 
 		/* delete the persistent ino map
 		 */
-		if ( ! persp->s.inomapdelpr ) {
-			inomap_del_pers( tranp->t_hkdir );
+		if (! persp->s.inomapdelpr) {
+			inomap_del_pers(tranp->t_hkdir);
 			persp->s.inomapdelpr = BOOL_TRUE;
 		}
 	}
@@ -3653,12 +3653,12 @@ finalize( char *path1, char *path2 )
 	 * invalidate the pers session state. otherwise, invalidate the
 	 * persistent state. content_complete will remove housekeeping dir.
 	 */
-	if ( persp->a.cumpr ) {
+	if (persp->a.cumpr) {
 		/* following must be atomic!
 		 */
 		persp->a.dumpcnt++;
 		uuid_copy(persp->a.lastdumpid, persp->s.dumpid);
-		strcpy( persp->a.lastdumplab, persp->s.dumplab );
+		strcpy(persp->a.lastdumplab, persp->s.dumplab);
 		persp->s.valpr = BOOL_FALSE;
 	} else {
 		persp->a.valpr = BOOL_FALSE;
@@ -3667,63 +3667,63 @@ finalize( char *path1, char *path2 )
 }
 
 static void
-toconly_cleanup( void )
+toconly_cleanup(void)
 {
-	if ( ! tranp ) {
+	if (! tranp) {
 		return;
 	}
 
-	if ( ! tranp->t_toconlypr ) {
+	if (! tranp->t_toconlypr) {
 		return;
 	}
 
-	if ( ! tranp->t_hkdir ) {
+	if (! tranp->t_hkdir) {
 		return;
 	}
 
-	if ( ! strlen( tranp->t_hkdir )) {
+	if (! strlen(tranp->t_hkdir)) {
 		return;
 	}
 
-	wipepersstate( );
+	wipepersstate();
 }
 
 static void
-wipepersstate( void )
+wipepersstate(void)
 {
 	DIR *dirp;
 	struct dirent64 *direntp;
-	char pathname[ MAXPATHLEN ];
-	dirp = opendir( tranp->t_hkdir );
-	if ( ! dirp ) {
+	char pathname[MAXPATHLEN];
+	dirp = opendir(tranp->t_hkdir);
+	if (! dirp) {
 		return;
 	}
 
-	while ( ( direntp = readdir64( dirp )) != 0 ) {
+	while ((direntp = readdir64(dirp)) != 0) {
 		/* REFERENCED */
 		int len;
-		if ( ! strcmp( direntp->d_name, "." )) {
+		if (! strcmp(direntp->d_name, ".")) {
 			continue;
 		}
-		if ( ! strcmp( direntp->d_name, ".." )) {
+		if (! strcmp(direntp->d_name, "..")) {
 			continue;
 		}
-		len = sprintf( pathname,
+		len = sprintf(pathname,
 			       "%s/%s",
 			       tranp->t_hkdir,
-			       direntp->d_name );
-		assert( len > 0 );
-		assert( len < MAXPATHLEN );
-		( void )unlink( pathname );
-		closedir( dirp );
-		dirp = opendir( tranp->t_hkdir );
-		if ( ! dirp ) {
+			       direntp->d_name);
+		assert(len > 0);
+		assert(len < MAXPATHLEN);
+		(void)unlink(pathname);
+		closedir(dirp);
+		dirp = opendir(tranp->t_hkdir);
+		if (! dirp) {
 			return;
 		}
 	}
-	closedir( dirp );
+	closedir(dirp);
 
-	rmdir( tranp->t_hkdir );
+	rmdir(tranp->t_hkdir);
 }
 
 /* Inv abstraction ***********************************************************/
@@ -3732,46 +3732,46 @@ wipepersstate( void )
  * sets pers id/label and pers idvalpr etc as side-effect (does NOT set valpr!)
  */
 static bool_t
-Inv_validate_cmdline( void )
+Inv_validate_cmdline(void)
 {
 	inv_session_t *sessp;
 	bool_t ok;
 	bool_t rok;
 
-	assert( ! persp->s.valpr );
+	assert(! persp->s.valpr);
 
 	ok = BOOL_FALSE;
 	sessp = 0;
-	if ( tranp->t_reqdumpidvalpr ) {
+	if (tranp->t_reqdumpidvalpr) {
 		ok = inv_get_session_byuuid(NULL, &tranp->t_reqdumpid, &sessp);
-	} else if ( tranp->t_reqdumplabvalpr ) {
+	} else if (tranp->t_reqdumplabvalpr) {
 		ok = inv_get_session_bylabel(NULL, tranp->t_reqdumplab, &sessp);
 	}
 	rok = BOOL_FALSE;
-	if ( ok && sessp ) {
+	if (ok && sessp) {
 		uuid_t baseid;
 
 		uuid_clear(baseid);
-                askinvforbaseof( baseid, sessp );
-		if ( ! dumpcompat( sessp->s_isresumed,
-				   ( ix_t )( sessp->s_level ),
+                askinvforbaseof(baseid, sessp);
+		if (! dumpcompat(sessp->s_isresumed,
+				   (ix_t)(sessp->s_level),
 				   baseid,
-				   BOOL_TRUE )) {
-			inv_free_session( &sessp );
+				   BOOL_TRUE)) {
+			inv_free_session(&sessp);
 			return BOOL_ERROR;
 		}
 
-		mlog( MLOG_VERBOSE, _(
-		      "using online session inventory\n") );
-		persp->s.fullinvpr = pi_transcribe( sessp );
-		if ( persp->s.fullinvpr ) {
-			strncpyterm( persp->s.dumplab,
+		mlog(MLOG_VERBOSE, _(
+		      "using online session inventory\n"));
+		persp->s.fullinvpr = pi_transcribe(sessp);
+		if (persp->s.fullinvpr) {
+			strncpyterm(persp->s.dumplab,
 				     sessp->s_label,
-				     sizeof( persp->s.dumplab ));
+				     sizeof(persp->s.dumplab));
 			uuid_copy(persp->s.dumpid, sessp->s_sesid);
 			rok = BOOL_TRUE;
 		}
-		inv_free_session( &sessp );
+		inv_free_session(&sessp);
 	}
 	return rok;
 }
@@ -3781,29 +3781,29 @@ Inv_validate_cmdline( void )
 
 
 static Media_t *
-Media_create( ix_t thrdix )
+Media_create(ix_t thrdix)
 {
-	drive_t *drivep = drivepp[ thrdix ];
+	drive_t *drivep = drivepp[thrdix];
 	global_hdr_t *grhdrp = drivep->d_greadhdrp;
 	drive_hdr_t *drhdrp = drivep->d_readhdrp;
-	media_hdr_t *mrhdrp = ( media_hdr_t * )drhdrp->dh_upper;
-	content_hdr_t *crhdrp = ( content_hdr_t * )mrhdrp->mh_upper;
+	media_hdr_t *mrhdrp = (media_hdr_t *)drhdrp->dh_upper;
+	content_hdr_t *crhdrp = (content_hdr_t *)mrhdrp->mh_upper;
 	content_inode_hdr_t *scrhdrp =
-				( content_inode_hdr_t * )crhdrp->ch_specific;
+				(content_inode_hdr_t *)crhdrp->ch_specific;
 	Media_t *Mediap;
 
 
-	mlog( MLOG_DEBUG,
-	      "Media_create\n" );
+	mlog(MLOG_DEBUG,
+	      "Media_create\n");
 
-	Mediap = ( Media_t * )calloc( 1, sizeof( Media_t ));
+	Mediap = (Media_t *)calloc(1, sizeof(Media_t));
 	Mediap->M_drivep = drivep;
 	Mediap->M_grhdrp = grhdrp;
 	Mediap->M_drhdrp = drhdrp;
 	Mediap->M_mrhdrp = mrhdrp;
 	Mediap->M_crhdrp = crhdrp;
 	Mediap->M_scrhdrp = scrhdrp;
-	assert( POS_UNKN == 0 );
+	assert(POS_UNKN == 0);
 
 	return Mediap;
 }
@@ -3812,19 +3812,19 @@ Media_create( ix_t thrdix )
  * within the current media file
  */
 static void
-Media_indir( Media_t *Mediap )
+Media_indir(Media_t *Mediap)
 {
-	mlog( MLOG_DEBUG,
-	      "Media_indir\n" );
+	mlog(MLOG_DEBUG,
+	      "Media_indir\n");
 
 	Mediap->M_pos = POS_INDIR;
 }
 
 static void
-Media_atnondir( Media_t *Mediap )
+Media_atnondir(Media_t *Mediap)
 {
-	mlog( MLOG_DEBUG,
-	      "Media_atnondir\n" );
+	mlog(MLOG_DEBUG,
+	      "Media_atnondir\n");
 
 	Mediap->M_pos = POS_ATNONDIR;
 }
@@ -3850,7 +3850,7 @@ Media_atnondir( Media_t *Mediap )
  * It takes on values like RV_OK, RV_EOF.
  */
 static rv_t
-Media_mfile_next( Media_t *Mediap,
+Media_mfile_next(Media_t *Mediap,
 		  purp_t purp,
 		  sync_t *donesyncp,
 		  dh_t  *filehp,
@@ -3860,7 +3860,7 @@ Media_mfile_next( Media_t *Mediap,
 		  content_hdr_t **crhdrpp,
 		  content_inode_hdr_t **scrhdrpp,
 		  drive_t **drivepp,
-		  filehdr_t *fhdrp ) /*caller-supplied buf if NONDIR purp*/
+		  filehdr_t *fhdrp) /*caller-supplied buf if NONDIR purp*/
 {
 	drive_t *drivep = Mediap->M_drivep;
 	drive_ops_t *dop = drivep->d_opsp;
@@ -3875,10 +3875,10 @@ Media_mfile_next( Media_t *Mediap,
 	bool_t ok;
 	uuid_t prevmfiledumpid;
 
-	mlog( MLOG_DEBUG | MLOG_MEDIA,
+	mlog(MLOG_DEBUG | MLOG_MEDIA,
 	      "Media_mfile_next: purp==%d pos==%d\n",
 	      purp,
-	      Mediap->M_pos );
+	      Mediap->M_pos);
 
 	/* pass back hdr and drive ptrs
 	 */
@@ -3891,7 +3891,7 @@ Media_mfile_next( Media_t *Mediap,
 
 	/* if ref return for pers mfile desc supplied, pre-zero
 	 */
-	if ( filehp ) {
+	if (filehp) {
 		*filehp = DH_NULL;
 	}
 
@@ -3901,8 +3901,8 @@ Media_mfile_next( Media_t *Mediap,
 
 	/* if purpose has changed, invalidate first, last, and previous indices
 	 */
-	if ( Mediap->M_flmfixvalpr ) {
-		if ( purp != Mediap->M_mfixpurp ) {
+	if (Mediap->M_flmfixvalpr) {
+		if (purp != Mediap->M_mfixpurp) {
 			Mediap->M_flmfixvalpr = BOOL_FALSE;
 			Mediap->M_pmfixvalpr = BOOL_FALSE;
 		}
@@ -3918,15 +3918,15 @@ Media_mfile_next( Media_t *Mediap,
 	/* if restore is complete, return indication. be sure to end read
 	 * if active.
 	 */
-	if ( purp == PURP_NONDIR
+	if (purp == PURP_NONDIR
 	     &&
-	     pi_alldone( )) {
-		if ( Mediap->M_pos == POS_ATHDR
+	     pi_alldone()) {
+		if (Mediap->M_pos == POS_ATHDR
 		     ||
 		     Mediap->M_pos == POS_INDIR
 		     ||
-		     Mediap->M_pos == POS_ATNONDIR ) {
-			( * dop->do_end_read )( drivep );
+		     Mediap->M_pos == POS_ATNONDIR) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 		}
@@ -3936,7 +3936,7 @@ Media_mfile_next( Media_t *Mediap,
 	/* loop searching for an acceptable media file.
 	 * change media as necessary.
 	 */
-	for ( ; ; ) {
+	for (; ;) {
 		bool_t emptypr; /* begin_read says drive empty */
 		bool_t partofdumppr;
 		bool_t hassomepr;
@@ -3956,23 +3956,23 @@ Media_mfile_next( Media_t *Mediap,
 
 		/* check if no point in going on
 		 */
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
-		if ( donesyncp && *donesyncp == SYNC_DONE ) {
+		if (donesyncp && *donesyncp == SYNC_DONE) {
 			return RV_DONE;
 		}
-		if ( purp == PURP_NONDIR
+		if (purp == PURP_NONDIR
 		     &&
-		     pi_alldone( )) {
+		     pi_alldone()) {
 			return RV_NOMORE;
 		}
 
 		/* if we have a useless media object, get another one
 		 */
-		if ( Mediap->M_pos == POS_USELESS
+		if (Mediap->M_pos == POS_USELESS
 		     ||
-		     Mediap->M_pos == POS_BLANK ) {
+		     Mediap->M_pos == POS_BLANK) {
 			goto newmedia;
 		}
 
@@ -3980,41 +3980,41 @@ Media_mfile_next( Media_t *Mediap,
 		 * a media file, that media file has already been
 		 * searched, so set pos to cause another begin read
 		 */
-		if ( purp == PURP_SEARCH ) {
-			if ( Mediap->M_pos == POS_ATHDR
+		if (purp == PURP_SEARCH) {
+			if (Mediap->M_pos == POS_ATHDR
 			     ||
 			     Mediap->M_pos == POS_INDIR
 			     ||
-			     Mediap->M_pos == POS_ATNONDIR ) {
+			     Mediap->M_pos == POS_ATNONDIR) {
 				Mediap->M_pos = POS_UNKN;
 			}
 		}
 
 		/* if already have a media file, skip the begin_read
 		 */
-		if ( Mediap->M_pos == POS_ATHDR
+		if (Mediap->M_pos == POS_ATHDR
 		     ||
 		     Mediap->M_pos == POS_INDIR
 		     ||
-		     Mediap->M_pos == POS_ATNONDIR ) {
+		     Mediap->M_pos == POS_ATNONDIR) {
 			goto validate;
 		}
 
 		/* see if the indices say we've seen all there is to see
 		 */
-		if ( Mediap->M_flmfixvalpr ) {
-			if ( Mediap->M_pos == POS_UNKN ) {
-				if ( Mediap->M_lmfix + 1 == Mediap->M_fmfix ) {
+		if (Mediap->M_flmfixvalpr) {
+			if (Mediap->M_pos == POS_UNKN) {
+				if (Mediap->M_lmfix + 1 == Mediap->M_fmfix) {
 					goto newmedia;
 				}
 			}
-			if ( Mediap->M_pos == POS_END ) {
-				if ( Mediap->M_fmfix == 0 ) {
+			if (Mediap->M_pos == POS_END) {
+				if (Mediap->M_fmfix == 0) {
 					goto newmedia;
 				}
-				if ( Mediap->M_fsfixvalpr
+				if (Mediap->M_fsfixvalpr
 				     &&
-				     Mediap->M_fmfix <= Mediap->M_fsfix ) {
+				     Mediap->M_fmfix <= Mediap->M_fsfix) {
 					goto newmedia;
 				}
 			}
@@ -4025,23 +4025,23 @@ Media_mfile_next( Media_t *Mediap,
 		 * afterwards check for interrupt or if someone else
 		 * has finished the job.
 		 */
-		if ( Mediap->M_pos == POS_END ) {
-			if ( ! ( dcaps & DRIVE_CAP_REWIND )) {
+		if (Mediap->M_pos == POS_END) {
+			if (! (dcaps & DRIVE_CAP_REWIND)) {
 				goto newmedia;
 			}
-			mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-			      "rewinding\n") );
-			( * drivep->d_opsp->do_rewind )( drivep );
+			mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+			      "rewinding\n"));
+			(* drivep->d_opsp->do_rewind)(drivep);
 			Mediap->M_pos = POS_UNKN;
-			if ( cldmgr_stop_requested( )) {
+			if (cldmgr_stop_requested()) {
 				return RV_INTR;
 			}
-			if ( donesyncp && *donesyncp == SYNC_DONE ) {
+			if (donesyncp && *donesyncp == SYNC_DONE) {
 				return RV_DONE;
 			}
-			if ( purp == PURP_NONDIR
+			if (purp == PURP_NONDIR
 			     &&
-			     pi_alldone( )) {
+			     pi_alldone()) {
 				return RV_NOMORE;
 			}
 		}
@@ -4050,52 +4050,52 @@ Media_mfile_next( Media_t *Mediap,
 		 * bail if catastrophic. also, tell pi about EOD/EOM
 		 * if appropriate.
 		 */
-		rval = ( * drivep->d_opsp->do_begin_read )( drivep );
-		switch ( rval ) {
+		rval = (* drivep->d_opsp->do_begin_read)(drivep);
+		switch (rval) {
 		case 0:
-			mlog_lock( );
-			mlog( MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
+			mlog_lock();
+			mlog(MLOG_VERBOSE | MLOG_NOLOCK | MLOG_MEDIA, _(
 			      "examining media file %u\n"),
-			      mrhdrp->mh_mediafileix );
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			      mrhdrp->mh_mediafileix);
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "file %u in "
 			      "object %u "
 			      "of stream %u\n",
 			      mrhdrp->mh_mediafileix,
 			      mrhdrp->mh_mediaix,
-			      drhdrp->dh_driveix );
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			      drhdrp->dh_driveix);
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "file %u in stream, "
 			      "file %u of dump %u on object\n",
 			      mrhdrp->mh_dumpfileix,
 			      mrhdrp->mh_dumpmediafileix,
-			      mrhdrp->mh_dumpmediaix );
-			mlog_unlock( );
+			      mrhdrp->mh_dumpmediaix);
+			mlog_unlock();
 
 			Mediap->M_pos = POS_ATHDR;
-			if ( Mediap->M_flmfixvalpr ) {
+			if (Mediap->M_flmfixvalpr) {
 				Mediap->M_pmfix = Mediap->M_lmfix;
 				Mediap->M_pmfixvalpr = BOOL_TRUE;
 			}
 
-			pi_note_indrive( drhdrp->dh_driveix,
-					 mrhdrp->mh_mediaid );
+			pi_note_indrive(drhdrp->dh_driveix,
+					 mrhdrp->mh_mediaid);
 
 			break;
 		case DRIVE_ERROR_EOD:
 			Mediap->M_pos = POS_END;
-			if ( Mediap->M_fsfixvalpr ) {
-				assert( purp != PURP_SEARCH );
-				pi_hiteod( Mediap->M_fssix,
-					   Mediap->M_fsoix );
+			if (Mediap->M_fsfixvalpr) {
+				assert(purp != PURP_SEARCH);
+				pi_hiteod(Mediap->M_fssix,
+					   Mediap->M_fsoix);
 			}
 			break;
 		case DRIVE_ERROR_EOM:
 			Mediap->M_pos = POS_END;
-			if ( Mediap->M_fsfixvalpr ) {
-				assert( purp != PURP_SEARCH );
-				pi_hiteom( Mediap->M_fssix,
-					   Mediap->M_fsoix );
+			if (Mediap->M_fsfixvalpr) {
+				assert(purp != PURP_SEARCH);
+				pi_hiteom(Mediap->M_fssix,
+					   Mediap->M_fsoix);
 			}
 			break;
 		case DRIVE_ERROR_MEDIA:
@@ -4133,12 +4133,12 @@ Media_mfile_next( Media_t *Mediap,
 validate:
 		/* update the positional indices
 		 */
-		if ( Mediap->M_pos == POS_ATHDR
+		if (Mediap->M_pos == POS_ATHDR
 		     ||
 		     Mediap->M_pos == POS_INDIR
 		     ||
-		     Mediap->M_pos == POS_ATNONDIR ) {
-			if ( ! Mediap->M_flmfixvalpr ) {
+		     Mediap->M_pos == POS_ATNONDIR) {
+			if (! Mediap->M_flmfixvalpr) {
 				Mediap->M_fmfix = mrhdrp->mh_mediafileix;
 				Mediap->M_mfixpurp = purp;
 				Mediap->M_flmfixvalpr = BOOL_TRUE;
@@ -4148,13 +4148,13 @@ validate:
 
 		/* check for interrupt. be sure to end_read if necessary
 		 */
-		if ( cldmgr_stop_requested( )) {
-			if ( Mediap->M_pos == POS_ATHDR
+		if (cldmgr_stop_requested()) {
+			if (Mediap->M_pos == POS_ATHDR
 			     ||
 			     Mediap->M_pos == POS_INDIR
 			     ||
-			     Mediap->M_pos == POS_ATNONDIR ) {
-				( * dop->do_end_read )( drivep );
+			     Mediap->M_pos == POS_ATNONDIR) {
+				(* dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 			}
@@ -4164,24 +4164,24 @@ validate:
 		/* check if another thread has finished job (for this purpose).
 		 * don't end_read, we will be back.
 		 */
-		if ( donesyncp && *donesyncp == SYNC_DONE ) {
+		if (donesyncp && *donesyncp == SYNC_DONE) {
 			return RV_DONE;
 		}
 
 		/* we may be done due to the actions of other threads.
 		 * if so, return indicating so
 		 */
-		if ( purp == PURP_NONDIR
+		if (purp == PURP_NONDIR
 		     &&
-		     pi_alldone( )) {
+		     pi_alldone()) {
 			return RV_NOMORE;
 		}
 
 		/* if the media object is useless, go get more
 		 */
-		if ( Mediap->M_pos == POS_USELESS
+		if (Mediap->M_pos == POS_USELESS
 		     ||
-		     Mediap->M_pos == POS_BLANK ) {
+		     Mediap->M_pos == POS_BLANK) {
 			goto newmedia;
 		}
 
@@ -4190,71 +4190,71 @@ validate:
 		 * ask the inventory if there is any point in examining
 		 * the beginning of the object.
 		 */
-		if ( Mediap->M_pos == POS_END
+		if (Mediap->M_pos == POS_END
 		     &&
 		     purp != PURP_SEARCH
 		     &&
 		     Mediap->M_fsfixvalpr
 		     &&
-		     pi_know_no_more_on_object( purp,
+		     pi_know_no_more_on_object(purp,
 						Mediap->M_fssix,
-						Mediap->M_fsoix )) {
+						Mediap->M_fsoix)) {
 			goto newmedia;
 		}
 
 		/* if we hit the end, go back to the top, where
 		 * we will decide if we should rewind or get new media.
 		 */
-		if ( Mediap->M_pos == POS_END ) {
+		if (Mediap->M_pos == POS_END) {
 			continue;
 		}
 
 		/* if the purpose is to search, return this media file
 		 */
-		if ( purp == PURP_SEARCH ) {
-			assert( Mediap->M_pos == POS_ATHDR );
+		if (purp == PURP_SEARCH) {
+			assert(Mediap->M_pos == POS_ATHDR);
 			return RV_OK;
 		}
 
 		/* see if this media file is part of the desired dump session
 		 */
-		partofdumppr = ( bool_t )(uuid_compare( persp->s.dumpid,
+		partofdumppr = (bool_t)(uuid_compare(persp->s.dumpid,
 						     grhdrp->gh_dumpid) == 0);
 		if (!partofdumppr) {
 		    char gh_string_uuid[UUID_STR_LEN + 1];
 		    char inv_string_uuid[UUID_STR_LEN + 1];
 
-		    uuid_unparse( grhdrp->gh_dumpid, gh_string_uuid);
-		    uuid_unparse( persp->s.dumpid, inv_string_uuid);
-		    mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+		    uuid_unparse(grhdrp->gh_dumpid, gh_string_uuid);
+		    uuid_unparse(persp->s.dumpid, inv_string_uuid);
+		    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 		          "inventory session uuid (%s) does not match "
 		          "the media header's session uuid (%s)\n"),
-			  inv_string_uuid, gh_string_uuid );
+			  inv_string_uuid, gh_string_uuid);
 		}
 
 		/* if media file dump id is different from the preceeding
 		 * media file, print something useful at TRACE verbosity.
 		 */
-		if ( uuid_compare( prevmfiledumpid,
+		if (uuid_compare(prevmfiledumpid,
 				   grhdrp->gh_dumpid) != 0) {
 
 			char string_uuid[UUID_STR_LEN + 1];
 
-			mlog_lock( );
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			mlog_lock();
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "dump session label: \"%s\"\n",
-			      grhdrp->gh_dumplabel );
+			      grhdrp->gh_dumplabel);
 
-			uuid_unparse( grhdrp->gh_dumpid, string_uuid);
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			uuid_unparse(grhdrp->gh_dumpid, string_uuid);
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "dump session id: %s\n",
-			      string_uuid );
-			mlog( MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
+			      string_uuid);
+			mlog(MLOG_TRACE | MLOG_NOLOCK | MLOG_MEDIA,
 			      "stream %u, object %u, file %u\n",
 			      drhdrp->dh_driveix,
 			      mrhdrp->mh_mediaix,
-			      mrhdrp->mh_dumpmediafileix );
-			mlog_unlock( );
+			      mrhdrp->mh_dumpmediafileix);
+			mlog_unlock();
 			uuid_copy(prevmfiledumpid, grhdrp->gh_dumpid);
 		}
 
@@ -4263,14 +4263,14 @@ validate:
 		 * dump, we know we have hit the end of the stream. tell the
 		 * persistent inventory.
 		 */
-		 if ( ! partofdumppr
+		 if (! partofdumppr
 		      &&
 		      Mediap->M_fsfixvalpr
 		      &&
-		      Mediap->M_lmfix > Mediap->M_fsfix ) {
-			pi_hitnextdump( Mediap->M_fssix,
+		      Mediap->M_lmfix > Mediap->M_fsfix) {
+			pi_hitnextdump(Mediap->M_fssix,
 					Mediap->M_fsoix,
-					Mediap->M_lmfix );
+					Mediap->M_lmfix);
 		}
 
 		/* if this media file is not part of the desired dump session,
@@ -4278,15 +4278,15 @@ validate:
 		 * object was part of the dump, we know we have hit the end of
 		 * the stream. check if we are done.
 		 */
-		 if ( ! partofdumppr
+		 if (! partofdumppr
 		      &&
 		      purp == PURP_NONDIR
 		      &&
 		      Mediap->M_fsfixvalpr
 		      &&
-		      Mediap->M_lmfix > Mediap->M_fsfix ) {
-			if ( pi_alldone( )) {
-				( * dop->do_end_read )( drivep );
+		      Mediap->M_lmfix > Mediap->M_fsfix) {
+			if (pi_alldone()) {
+				(* dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				return RV_NOMORE;
@@ -4297,18 +4297,18 @@ validate:
 		 * and preceeding media files on this object were, decide if
 		 * we need to rewind and look at the beginning of the object.
 		 */
-		if ( ! partofdumppr
+		if (! partofdumppr
 		     &&
 		     Mediap->M_fsfixvalpr
 		     &&
-		     Mediap->M_fmfix <= Mediap->M_fsfix ) {
-			( * dop->do_end_read )( drivep );
+		     Mediap->M_fmfix <= Mediap->M_fsfix) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
-			if ( dcaps & DRIVE_CAP_REWIND ) {
-				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-				  "rewinding\n") );
-				( * drivep->d_opsp->do_rewind )( drivep );
+			if (dcaps & DRIVE_CAP_REWIND) {
+				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+				  "rewinding\n"));
+				(* drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			} else {
 				goto newmedia;
@@ -4318,8 +4318,8 @@ validate:
 		/* if this media file is not part of the desired dump session,
 		 * and the above conditions were not met, then keep looking
 		 */
-		if ( ! partofdumppr ) {
-			( * dop->do_end_read )( drivep );
+		if (! partofdumppr) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
 			continue;
@@ -4328,7 +4328,7 @@ validate:
 		/* record the index within this media object of the first
 		 * media file in the dump stream
 		 */
-		if ( ! Mediap->M_fsfixvalpr ) {
+		if (! Mediap->M_fsfixvalpr) {
 			Mediap->M_fsfix =
 				     mrhdrp->mh_mediafileix
 				     -
@@ -4341,52 +4341,52 @@ validate:
 		/* this media file is part of the dump. add it to the
 		 * persistent inventory and get a file handle.
 		 */
-		fileh = pi_addfile( Mediap,
+		fileh = pi_addfile(Mediap,
 				    grhdrp,
 				    drhdrp,
 				    mrhdrp,
 				    scrhdrp,
-				    drivep );
+				    drivep);
 
-		if ( fileh == DH_NULL ) {
+		if (fileh == DH_NULL) {
 			return RV_CORE;
 		}
 
-		pi_lock( );
-		objh = DH2F( fileh )->f_parh;
-		DH2O( objh )->o_indriveix = drivep->d_index;
-		DH2O( objh )->o_indrivepr = BOOL_TRUE;
-		pi_unlock( );
+		pi_lock();
+		objh = DH2F(fileh)->f_parh;
+		DH2O(objh)->o_indriveix = drivep->d_index;
+		DH2O(objh)->o_indrivepr = BOOL_TRUE;
+		pi_unlock();
 
-		pi_note_underhead( objh, fileh );
+		pi_note_underhead(objh, fileh);
 
 		/* if purp is nondir, we may be done.
 		 */
-		if ( purp == PURP_NONDIR && pi_alldone( )) {
-			( * dop->do_end_read )( drivep );
+		if (purp == PURP_NONDIR && pi_alldone()) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			return RV_NOMORE;
 		}
 
 		/* check for a wraparound
 		 */
-		if ( Mediap->M_flmfixvalpr ) {
-			if ( Mediap->M_fsfixvalpr
+		if (Mediap->M_flmfixvalpr) {
+			if (Mediap->M_fsfixvalpr
 			     &&
 			     Mediap->M_fmfix <= Mediap->M_fsfix
 			     &&
-			     Mediap->M_lmfix < Mediap->M_fmfix ) {
-				( * dop->do_end_read )( drivep );
+			     Mediap->M_lmfix < Mediap->M_fmfix) {
+				(* dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				goto newmedia;
 			}
-			if ( Mediap->M_pmfixvalpr
+			if (Mediap->M_pmfixvalpr
 			     &&
 			     Mediap->M_pmfix < Mediap->M_fmfix
 			     &&
-			     Mediap->M_lmfix > Mediap->M_fmfix ) {
-				( * dop->do_end_read )( drivep );
+			     Mediap->M_lmfix > Mediap->M_fmfix) {
+				(* dop->do_end_read)(drivep);
 				Mediap->M_pos = POS_UNKN;
 				fileh = DH_NULL;
 				goto newmedia;
@@ -4399,26 +4399,26 @@ validate:
 		 * decide if any preceeding media files are useful and if so
 		 * go get them. otherwise get another media object.
 		 */
-		if ( MEDIA_TERMINATOR_CHK( mrhdrp )
+		if (MEDIA_TERMINATOR_CHK(mrhdrp)
 		     ||
 		     scrhdrp->cih_mediafiletype
 		     ==
-		     CIH_MEDIAFILETYPE_INVENTORY ) {
-			( * dop->do_end_read )( drivep );
+		     CIH_MEDIAFILETYPE_INVENTORY) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
-			if ( pi_know_no_more_on_object( purp,
+			if (pi_know_no_more_on_object(purp,
 							Mediap->M_fssix,
-							Mediap->M_fsoix )) {
+							Mediap->M_fsoix)) {
 				goto newmedia;
 			}
-			if ( Mediap->M_fmfix > Mediap->M_fsfix
+			if (Mediap->M_fmfix > Mediap->M_fsfix
 			     &&
-			     ( dcaps & DRIVE_CAP_REWIND )) {
-				pi_note_underhead( objh, DH_NULL );
-				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-					"rewinding\n") );
-				( * drivep->d_opsp->do_rewind )( drivep );
+			     (dcaps & DRIVE_CAP_REWIND)) {
+				pi_note_underhead(objh, DH_NULL);
+				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+					"rewinding\n"));
+				(* drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			}
 			goto newmedia;
@@ -4428,30 +4428,30 @@ validate:
 		 * at the hdr or has already been tried, get another one.
 		 * use the persistent inventory to do this intelligently.
 		 */
-		if ( purp == PURP_DIR
+		if (purp == PURP_DIR
 		     &&
-		     ( Mediap->M_pos != POS_ATHDR
+		     (Mediap->M_pos != POS_ATHDR
 		       ||
-		       DH2F( fileh )->f_dirtriedpr )) {
-			( * dop->do_end_read )( drivep );
+		       DH2F(fileh)->f_dirtriedpr)) {
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
-			if ( pi_know_no_more_beyond_on_object( purp,
+			if (pi_know_no_more_beyond_on_object(purp,
 							       Mediap->M_fssix,
 							       Mediap->M_fsoix,
-						mrhdrp->mh_dumpmediafileix )) {
-				if ( pi_know_no_more_on_object( purp,
+						mrhdrp->mh_dumpmediafileix)) {
+				if (pi_know_no_more_on_object(purp,
 								Mediap->M_fssix,
-							    Mediap->M_fsoix )) {
+							    Mediap->M_fsoix)) {
 					goto newmedia;
 				}
-				if ( Mediap->M_fmfix > Mediap->M_fsfix
+				if (Mediap->M_fmfix > Mediap->M_fsfix
 				     &&
-				     ( dcaps & DRIVE_CAP_REWIND )) {
-					pi_note_underhead( objh, DH_NULL );
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-						"rewinding\n") );
-					( * drivep->d_opsp->do_rewind )(drivep);
+				     (dcaps & DRIVE_CAP_REWIND)) {
+					pi_note_underhead(objh, DH_NULL);
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+						"rewinding\n"));
+					(* drivep->d_opsp->do_rewind)(drivep);
 					continue;
 				}
 				goto newmedia;
@@ -4462,10 +4462,10 @@ validate:
 
 		/* if the purpose is dir, give it to the caller
 		 */
-		if ( purp == PURP_DIR ) {
-			assert( Mediap->M_pos == POS_ATHDR );
-			if ( filehp ) {
-				assert( fileh != DH_NULL );
+		if (purp == PURP_DIR) {
+			assert(Mediap->M_pos == POS_ATHDR);
+			if (filehp) {
+				assert(fileh != DH_NULL);
 				*filehp = fileh;
 			}
 			return RV_OK;
@@ -4477,46 +4477,46 @@ validate:
 
 		/* see if this media file contains any inodes not yet restored
 		 */
-		assert( fileh != DH_NULL );
-		pi_lock( );
-		assert( DH2F( fileh )->f_valpr );
-		begino = DH2F( fileh )->f_curegrp.eg_ino;
-		endino = pi_scanfileendino( fileh );
-		hassomepr = inomap_rst_needed( begino, endino );
+		assert(fileh != DH_NULL);
+		pi_lock();
+		assert(DH2F(fileh)->f_valpr);
+		begino = DH2F(fileh)->f_curegrp.eg_ino;
+		endino = pi_scanfileendino(fileh);
+		hassomepr = inomap_rst_needed(begino, endino);
 
 		/* if we have already given up on this media file or
 		 * it doesn't contains anything not yet restored,
 		 * or it can be skipped, move on. force the done flag on,
 		 * so we don't check it again.
 		 */
-		if ( DH2F( fileh )->f_nondirdonepr
+		if (DH2F(fileh)->f_nondirdonepr
 		     ||
-		     DH2F( fileh )->f_nondirskippr
+		     DH2F(fileh)->f_nondirskippr
 		     ||
-		     ! hassomepr ) {
-			if ( ! DH2F( fileh )->f_nondirskippr ) {
-				DH2F( fileh )->f_nondirdonepr = BOOL_TRUE;
+		     ! hassomepr) {
+			if (! DH2F(fileh)->f_nondirskippr) {
+				DH2F(fileh)->f_nondirdonepr = BOOL_TRUE;
 			}
-			pi_unlock( );
-			( * dop->do_end_read )( drivep );
+			pi_unlock();
+			(* dop->do_end_read)(drivep);
 			Mediap->M_pos = POS_UNKN;
 			fileh = DH_NULL;
-			if ( pi_know_no_more_beyond_on_object( purp,
+			if (pi_know_no_more_beyond_on_object(purp,
 							       Mediap->M_fssix,
 							       Mediap->M_fsoix,
-						mrhdrp->mh_dumpmediafileix )) {
-				if ( pi_know_no_more_on_object( purp,
+						mrhdrp->mh_dumpmediafileix)) {
+				if (pi_know_no_more_on_object(purp,
 								Mediap->M_fssix,
-							    Mediap->M_fsoix )) {
+							    Mediap->M_fsoix)) {
 					goto newmedia;
 				}
-				if ( Mediap->M_fmfix > Mediap->M_fsfix
+				if (Mediap->M_fmfix > Mediap->M_fsfix
 				     &&
-				     ( dcaps & DRIVE_CAP_REWIND )) {
-					pi_note_underhead( objh, DH_NULL );
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-						"rewinding\n") );
-					( * drivep->d_opsp->do_rewind )(drivep);
+				     (dcaps & DRIVE_CAP_REWIND)) {
+					pi_note_underhead(objh, DH_NULL);
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+						"rewinding\n"));
+					(* drivep->d_opsp->do_rewind)(drivep);
 					continue;
 				}
 				goto newmedia;
@@ -4538,81 +4538,81 @@ validate:
 		 * and no check point, can still get there
 		 * by doing dummy read of dirdump.
 		 */
-		assert( fileh != DH_NULL );
-		assert( DH2F( fileh )->f_valpr );
-		resumepr = ( ( DH2F( fileh )->f_firstegrp.eg_ino
+		assert(fileh != DH_NULL);
+		assert(DH2F(fileh)->f_valpr);
+		resumepr = ((DH2F(fileh)->f_firstegrp.eg_ino
 			       !=
-			       DH2F( fileh )->f_curegrp.eg_ino )
+			       DH2F(fileh)->f_curegrp.eg_ino)
 			     ||
-			     ( DH2F( fileh )->f_firstegrp.eg_off
+			     (DH2F(fileh)->f_firstegrp.eg_off
 			       !=
-			       DH2F( fileh )->f_curegrp.eg_off ));
-		chkpnt = DH2F( fileh )->f_curmark;
-		pi_unlock( );
-		fhcs = ( scrhdrp->cih_dumpattr
+			       DH2F(fileh)->f_curegrp.eg_off));
+		chkpnt = DH2F(fileh)->f_curmark;
+		pi_unlock();
+		fhcs = (scrhdrp->cih_dumpattr
 			 &
-			 CIH_DUMPATTR_FILEHDR_CHECKSUM )
+			 CIH_DUMPATTR_FILEHDR_CHECKSUM)
 		       ?
 		       BOOL_TRUE
 		       :
 		       BOOL_FALSE;
 		canseeknextpr = dcaps & DRIVE_CAP_NEXTMARK;
-		switch( Mediap->M_pos ) {
+		switch(Mediap->M_pos) {
 		case POS_ATHDR:
 		case POS_INDIR:
-			if ( resumepr ) {
-			    mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+			if (resumepr) {
+			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "seeking past portion of media file "
-				  "already restored\n") );
-			    rval = ( * dop->do_seek_mark )( drivep,
-							    &chkpnt );
-			    if ( ! rval ) {
+				  "already restored\n"));
+			    rval = (* dop->do_seek_mark)(drivep,
+							    &chkpnt);
+			    if (! rval) {
 				    rv_t rv;
-				    rv = read_filehdr( drivep,
+				    rv = read_filehdr(drivep,
 						       fhdrp,
-						       fhcs );
-				    if ( rv != RV_OK ) {
+						       fhcs);
+				    if (rv != RV_OK) {
 					    rval = 1;
 				    } else {
-					    mlog( MLOG_TRACE | MLOG_MEDIA,
+					    mlog(MLOG_TRACE | MLOG_MEDIA,
 						  "positioned at unrestored "
-						  "portion of media file\n" );
+						  "portion of media file\n");
 				    }
 			    }
-			} else if ( canseeknextpr ) {
-			    mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+			} else if (canseeknextpr) {
+			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "seeking past media file "
-				  "directory dump\n") );
-			    rval = ( * dop->do_next_mark )( drivep);
-			    if ( ! rval ) {
+				  "directory dump\n"));
+			    rval = (* dop->do_next_mark)(drivep);
+			    if (! rval) {
 				    rv_t rv;
-				    rv = read_filehdr( drivep,
+				    rv = read_filehdr(drivep,
 						       fhdrp,
-						       fhcs );
-				    if ( rv != RV_OK ) {
+						       fhcs);
+				    if (rv != RV_OK) {
 					    rval = 1;
 				    } else {
-					    mlog( MLOG_TRACE | MLOG_MEDIA,
+					    mlog(MLOG_TRACE | MLOG_MEDIA,
 						  "positioned at "
 						  "media file "
-						  "non-directory dump\n" );
+						  "non-directory dump\n");
 				    }
 			    }
-			} else if ( Mediap->M_pos == POS_ATHDR ) {
-			    mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+			} else if (Mediap->M_pos == POS_ATHDR) {
+			    mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 				  "seeking past media file "
-				  "directory dump\n") );
-			    rv = eatdirdump( drivep,
+				  "directory dump\n"));
+			    rv = eatdirdump(drivep,
 					     fileh,
 					     scrhdrp,
-					     fhdrp );
-			    if ( rv != RV_OK ) {
+					     fhdrp);
+			    if (rv != RV_OK) {
 				    rval = 1;
 			    } else {
-				    mlog( MLOG_TRACE | MLOG_MEDIA,
+				    mlog(MLOG_TRACE | MLOG_MEDIA,
 					  "positioned at "
 					  "media file "
-					  "non-directory dump\n" );
+					  "non-directory dump\n");
 			    }
 			} else {
 			    rval = 1;
@@ -4622,7 +4622,7 @@ validate:
 			rval = 0;
 			break;
 		default:
-		    assert( 0 );
+		    assert(0);
 		    rval = 1;
 		    break;
 		}
@@ -4630,17 +4630,17 @@ validate:
 		/* if error encountered during fine positioning,
 		 * mark file so we won't try it again
 		 */
-		if ( rval ) {
-			DH2F( fileh )->f_nondirdonepr = BOOL_TRUE;
+		if (rval) {
+			DH2F(fileh)->f_nondirdonepr = BOOL_TRUE;
 		} else {
 			Mediap->M_pos = POS_ATNONDIR;
 		}
 
 		/* if no error during fine positioning, return.
 		 */
-		if ( ! rval ) {
-			if ( filehp ) {
-				assert( fileh != DH_NULL );
+		if (! rval) {
+			if (filehp) {
+				assert(fileh != DH_NULL);
 				*filehp = fileh;
 			}
 			return RV_OK;
@@ -4650,26 +4650,26 @@ validate:
 		 * media files on this object? if so, continue; if not, get
 		 * more media.
 		 */
-		( * dop->do_end_read )( drivep );
+		(* dop->do_end_read)(drivep);
 		Mediap->M_pos = POS_UNKN;
 		fileh = DH_NULL;
-		assert( purp == PURP_NONDIR );
-		if ( pi_know_no_more_beyond_on_object( purp,
+		assert(purp == PURP_NONDIR);
+		if (pi_know_no_more_beyond_on_object(purp,
 						       Mediap->M_fssix,
 						       Mediap->M_fsoix,
-					mrhdrp->mh_dumpmediafileix )) {
-			if ( pi_know_no_more_on_object( purp,
+					mrhdrp->mh_dumpmediafileix)) {
+			if (pi_know_no_more_on_object(purp,
 							Mediap->M_fssix,
-							Mediap->M_fsoix )) {
+							Mediap->M_fsoix)) {
 				goto newmedia;
 			}
-			if ( Mediap->M_fmfix > Mediap->M_fsfix
+			if (Mediap->M_fmfix > Mediap->M_fsfix
 			     &&
-			     ( dcaps & DRIVE_CAP_REWIND )) {
-				pi_note_underhead( objh, DH_NULL );
-				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-					"rewinding\n") );
-				( * drivep->d_opsp->do_rewind )(drivep);
+			     (dcaps & DRIVE_CAP_REWIND)) {
+				pi_note_underhead(objh, DH_NULL);
+				mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+					"rewinding\n"));
+				(* drivep->d_opsp->do_rewind)(drivep);
 				continue;
 			}
 			goto newmedia;
@@ -4687,7 +4687,7 @@ newmedia:
 		/* if we are searching and some other thread completed
 		 * the search, don't pop the media unless it is useless
 		 */
-		if ( purp == PURP_SEARCH
+		if (purp == PURP_SEARCH
 		     &&
 		     Mediap->M_pos != POS_USELESS
 		     &&
@@ -4695,15 +4695,15 @@ newmedia:
 		     &&
 		     donesyncp
 		     &&
-		     *donesyncp == SYNC_DONE ) {
+		     *donesyncp == SYNC_DONE) {
 			return RV_DONE;
 		}
 
 		/* if media not removable, just return
 		 */
-		if ( ( * dop->do_get_device_class )( drivep )
+		if ((* dop->do_get_device_class)(drivep)
 		     ==
-		     DEVICE_NONREMOVABLE )
+		     DEVICE_NONREMOVABLE)
 		{
 		    /* if no error has already been detected then don't log
 		       a failure */
@@ -4714,13 +4714,13 @@ newmedia:
 
 		/* check for an interrupt
 		 */
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
 
 		/* check if we are done.
 		 */
-		switch( purp ) {
+		switch(purp) {
 		case PURP_SEARCH:
 			knownholespr = BOOL_TRUE;
 			maybeholespr = BOOL_FALSE;
@@ -4729,54 +4729,54 @@ newmedia:
 		case PURP_DIR:
 			knownholespr = BOOL_FALSE;
 			maybeholespr = BOOL_FALSE;
-			bagp = pi_neededobjs_dir_alloc( &knownholespr,
-							&maybeholespr );
+			bagp = pi_neededobjs_dir_alloc(&knownholespr,
+							&maybeholespr);
 			break;
 		case PURP_NONDIR:
 			knownholespr = BOOL_FALSE;
 			maybeholespr = BOOL_FALSE;
-			bagp = pi_neededobjs_nondir_alloc( &knownholespr,
+			bagp = pi_neededobjs_nondir_alloc(&knownholespr,
 							   &maybeholespr,
 							   BOOL_FALSE,
-							   BOOL_FALSE );
+							   BOOL_FALSE);
 			break;
 		default:
-			assert( 0 );
+			assert(0);
 		}
 
-		if ( ! bagp && ! knownholespr && ! maybeholespr ) {
+		if (! bagp && ! knownholespr && ! maybeholespr) {
 			/* if PURP_DIR, this may be a problem
 			 */
-			if ( purp == PURP_NONDIR ) {
+			if (purp == PURP_NONDIR) {
 				return RV_NOMORE;
 			}
 		}
 
 		/* eject media if drive not already empty
 		 */
-		if ( ! emptypr ) {
+		if (! emptypr) {
 			int dcaps = drivep->d_capabilities;
-			if ( purp == PURP_SEARCH ) {
-				if ( Mediap->M_pos == POS_USELESS ) {
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-					      "media object not useful\n") );
-				} else if ( Mediap->M_pos == POS_BLANK ) {
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
-					      "media object empty\n") );
+			if (purp == PURP_SEARCH) {
+				if (Mediap->M_pos == POS_USELESS) {
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+					      "media object not useful\n"));
+				} else if (Mediap->M_pos == POS_BLANK) {
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
+					      "media object empty\n"));
 				} else {
-					mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
+					mlog(MLOG_VERBOSE | MLOG_MEDIA, _(
 					      "all media files examined, "
-					      "none selected for restoral\n") );
+					      "none selected for restoral\n"));
 				}
 			}
-			if ( dcaps & DRIVE_CAP_EJECT ) {
-				( * dop->do_eject_media )( drivep );
+			if (dcaps & DRIVE_CAP_EJECT) {
+				(* dop->do_eject_media)(drivep);
 			}
 		}
 
 		/* tell the persistent inventory this drive is now empty
 		 */
-		pi_driveempty( drivep->d_index );
+		pi_driveempty(drivep->d_index);
 
 		/* invalidate all positional descriptors
 		 */
@@ -4790,80 +4790,80 @@ newmedia:
 		/* ask for a media change: supply a list of media objects
 		 * which may contain useful media files
 		 */
-		if ( dlog_allowed( )) {
+		if (dlog_allowed()) {
 			/* If an alert program has been specified , run it.
 			 */
 			if (media_change_alert_program != NULL)
 				system(media_change_alert_program);
 
-			if ( drivecnt > 1 && ! stdoutpiped ) {
+			if (drivecnt > 1 && ! stdoutpiped) {
 				ix_t thrdix = drivep->d_index;
-				if ( bagp ) {
-					pi_neededobjs_free( bagp );
+				if (bagp) {
+					pi_neededobjs_free(bagp);
 					bagp = 0;
 				}
-				assert( sistr );
-				mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
+				assert(sistr);
+				mlog(MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
 				      "please change media: "
 				      "type %s to confirm media change\n"),
-				      sistr );
-				set_mcflag( thrdix );
-				while ( mcflag[ thrdix ] ) {
-					sleep( 2 );
-					if ( cldmgr_stop_requested( )) {
-						clr_mcflag( thrdix );
+				      sistr);
+				set_mcflag(thrdix);
+				while (mcflag[thrdix]) {
+					sleep(2);
+					if (cldmgr_stop_requested()) {
+						clr_mcflag(thrdix);
 						return RV_INTR;
 					}
-					if ( purp == PURP_NONDIR
+					if (purp == PURP_NONDIR
 					     &&
-					     pi_alldone( )) {
-						clr_mcflag( thrdix );
+					     pi_alldone()) {
+						clr_mcflag(thrdix);
 						return RV_NOMORE;
 					}
 				}
 				ok = BOOL_TRUE;
 			} else {
-				ok = Media_prompt_change( drivep,
+				ok = Media_prompt_change(drivep,
 							  purp,
 							  bagp,
 							  knownholespr,
-							  maybeholespr );
+							  maybeholespr);
 			}
 		} else {
 			ok = BOOL_FALSE;
 		}
-		if ( bagp ) {
-			pi_neededobjs_free( bagp );
+		if (bagp) {
+			pi_neededobjs_free(bagp);
 			bagp = 0;
 		}
-		if ( cldmgr_stop_requested( )) {
+		if (cldmgr_stop_requested()) {
 			return RV_INTR;
 		}
-		if ( ! ok ) {
+		if (! ok) {
 			return RV_QUIT;
 		}
 	}
 	/* NOTREACHED */
 }
 
-/* figures out and calls if needed do_end_read( ).
+/* figures out and calls if needed do_end_read().
  */
 static void
-Media_end( Media_t *Mediap )
+Media_end(Media_t *Mediap)
 {
 	drive_t *drivep = Mediap->M_drivep;
 	drive_ops_t *dop = drivep->d_opsp;
 
-	mlog( MLOG_DEBUG | MLOG_MEDIA,
+	mlog(MLOG_DEBUG | MLOG_MEDIA,
 	      "Media_end: pos==%d\n",
-	      Mediap->M_pos );
+	      Mediap->M_pos);
 
-	if ( Mediap->M_pos == POS_ATHDR
+	if (Mediap->M_pos == POS_ATHDR
 	     ||
 	     Mediap->M_pos == POS_INDIR
 	     ||
-	     Mediap->M_pos == POS_ATNONDIR ) {
-		( * dop->do_end_read )( drivep );
+	     Mediap->M_pos == POS_ATNONDIR) {
+		(* dop->do_end_read)(drivep);
 		Mediap->M_pos = POS_UNKN;
 	}
 }
@@ -4892,37 +4892,37 @@ Media_end( Media_t *Mediap )
  * terminators and inventories.
  */
 static void
-pi_lock( void )
+pi_lock(void)
 {
-	qlock_lock( tranp->t_pilockh );
+	qlock_lock(tranp->t_pilockh);
 }
 
 static void
-pi_unlock( void )
+pi_unlock(void)
 {
-	qlock_unlock( tranp->t_pilockh );
+	qlock_unlock(tranp->t_pilockh);
 }
 
 /* sets check point in media file descriptor
  */
 static void
-pi_checkpoint( dh_t fileh, drive_mark_t *drivemarkp, xfs_ino_t ino, off64_t off )
+pi_checkpoint(dh_t fileh, drive_mark_t *drivemarkp, xfs_ino_t ino, off64_t off)
 {
-	pi_lock( );
-	DH2F( fileh )->f_curmark = *drivemarkp;
-	DH2F( fileh )->f_curegrp.eg_ino = ino;
-	DH2F( fileh )->f_curegrp.eg_off = off;
-	pi_unlock( );
+	pi_lock();
+	DH2F(fileh)->f_curmark = *drivemarkp;
+	DH2F(fileh)->f_curegrp.eg_ino = ino;
+	DH2F(fileh)->f_curegrp.eg_off = off;
+	pi_unlock();
 }
 
 /* lock must be held by caller
  */
 static bool_t
-pi_allocdesc( dh_t *deschp )
+pi_allocdesc(dh_t *deschp)
 {
 	dh_t desch;
 
-	if ( persp->s.descfreeh == DH_NULL ) {
+	if (persp->s.descfreeh == DH_NULL) {
 		ix_t stpgcnt = persp->a.stpgcnt;
 		ix_t olddescpgcnt = persp->s.descpgcnt;
 		ix_t newdescpgcnt = olddescpgcnt + DAU;
@@ -4933,53 +4933,53 @@ pi_allocdesc( dh_t *deschp )
 
 		/* first unmap if any existing descriptors
 		 */
-		if ( descp ) {
-			assert( olddescpgcnt > 0 );
-			rval = munmap( ( void * )descp,
-				       olddescpgcnt * pgsz );
-			assert( ! rval );
+		if (descp) {
+			assert(olddescpgcnt > 0);
+			rval = munmap((void *)descp,
+				       olddescpgcnt * pgsz);
+			assert(! rval);
 			descp = 0;
 		} else {
-			assert( olddescpgcnt == 0 );
+			assert(olddescpgcnt == 0);
 		}
 
 		/* remap with DAU more pages of descriptors
 		 */
-		assert( stpgcnt <= ( ix_t )INTGENMAX );
-		assert( newdescpgcnt > 0 );
-		descp = ( pers_desc_t * ) mmap_autogrow( newdescpgcnt * pgsz,
+		assert(stpgcnt <= (ix_t)INTGENMAX);
+		assert(newdescpgcnt > 0);
+		descp = (pers_desc_t *) mmap_autogrow(newdescpgcnt * pgsz,
 						tranp->t_persfd,
-						( off_t )perssz
+						(off_t)perssz
 						+
-						( off_t )( stpgcnt * pgsz ));
-		if ( descp == ( pers_desc_t * )( -1 )) {
-			pi_unlock( );
-			mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
+						(off_t)(stpgcnt * pgsz));
+		if (descp == (pers_desc_t *)(-1)) {
+			pi_unlock();
+			mlog(MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
 			      "could not remap persistent state file "
 			      "inv %s: %d (%s)\n"),
 			      perspath,
 			      errno,
-			      strerror( errno ));
-			pi_lock( );
+			      strerror(errno));
+			pi_lock();
 			descp = 0;
 			return BOOL_FALSE;
 		}
-		persp->s.descfreeh = ( dh_t )( olddescpgcnt * pgsz + 1 );
-		for ( descix = 0, desch = persp->s.descfreeh
+		persp->s.descfreeh = (dh_t)(olddescpgcnt * pgsz + 1);
+		for (descix = 0, desch = persp->s.descfreeh
 		      ;
-		      descix < ( DAU * descppg ) - 1
+		      descix < (DAU * descppg) - 1
 		      ;
-		      descix++, desch += PERS_DESCSZ ) {
-			DH2D( desch )->d_nexth = desch + PERS_DESCSZ;
+		      descix++, desch += PERS_DESCSZ) {
+			DH2D(desch)->d_nexth = desch + PERS_DESCSZ;
 		}
-		DH2D( desch )->d_nexth = DH_NULL;
+		DH2D(desch)->d_nexth = DH_NULL;
 		persp->s.descpgcnt = newdescpgcnt;
 	}
 
 	desch = persp->s.descfreeh;
-	persp->s.descfreeh = DH2D( desch )->d_nexth;
-	memset( ( void * )DH2D( desch ), 0, sizeof( pers_desc_t ));
-	assert( desch != DH_NULL );
+	persp->s.descfreeh = DH2D(desch)->d_nexth;
+	memset((void *)DH2D(desch), 0, sizeof(pers_desc_t));
+	assert(desch != DH_NULL);
 	*deschp = desch;
 	return BOOL_TRUE;
 }
@@ -4989,7 +4989,7 @@ pi_allocdesc( dh_t *deschp )
  * adds objects.
  */
 static dh_t
-pi_insertfile( ix_t drivecnt,
+pi_insertfile(ix_t drivecnt,
 	       ix_t driveix,
 	       ix_t mediaix,
 	       bool_t idlabvalpr,
@@ -5009,7 +5009,7 @@ pi_insertfile( ix_t drivecnt,
 	       off64_t startoffset,
 	       int flags,
 	       bool_t fileszvalpr,
-	       off64_t filesz )
+	       off64_t filesz)
 {
 	ix_t strmix;
 	dh_t strmh;
@@ -5021,100 +5021,100 @@ pi_insertfile( ix_t drivecnt,
 	dh_t prevfileh;
 	bool_t ok;
 
-	pi_lock( );
+	pi_lock();
 
 	/* first alloc stream descriptors if needed
 	 */
-	if ( persp->s.strmheadh == DH_NULL ) {
-		for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-			ok = pi_allocdesc( &strmh );
-			if ( ! ok ) {
-				pi_unlock( );
+	if (persp->s.strmheadh == DH_NULL) {
+		for (strmix = 0 ; strmix < drivecnt ; strmix++) {
+			ok = pi_allocdesc(&strmh);
+			if (! ok) {
+				pi_unlock();
 				return DH_NULL;
 			}
-			DH2S( strmh )->s_nexth = persp->s.strmheadh;
+			DH2S(strmh)->s_nexth = persp->s.strmheadh;
 			persp->s.strmheadh = strmh;
 		}
 	}
 
 	/* get handle to this stream
 	 */
-	for ( strmix = 0,
+	for (strmix = 0,
 	      strmh = persp->s.strmheadh
 	      ;
 	      strmix < driveix
 	      ;
 	      strmix++,
-	      strmh = DH2S( strmh )->s_nexth )
+	      strmh = DH2S(strmh)->s_nexth)
 		;
-	assert( strmh != DH_NULL );
+	assert(strmh != DH_NULL);
 
 	/* get handle to this object by walking/constructing this stream's
 	 * object list, up to the desired object
 	 */
 	objh = prevobjh = DH_NULL;
-	for ( objix = 0 ; objix <= mediaix ; objix++ ) {
+	for (objix = 0 ; objix <= mediaix ; objix++) {
 		prevobjh = objh;
-		if ( objix == 0 ) {
-			objh = DH2S( strmh )->s_cldh;
+		if (objix == 0) {
+			objh = DH2S(strmh)->s_cldh;
 		} else {
-			objh = DH2O( prevobjh )->o_nexth;
+			objh = DH2O(prevobjh)->o_nexth;
 		}
-		if ( objh == DH_NULL ) {
-			ok = pi_allocdesc( &objh );
-			if ( ! ok ) {
-				pi_unlock( );
+		if (objh == DH_NULL) {
+			ok = pi_allocdesc(&objh);
+			if (! ok) {
+				pi_unlock();
 				return DH_NULL;
 			}
-			DH2O( objh )->o_parh = strmh;
-			if ( objix == 0 ) {
-				DH2S( strmh )->s_cldh = objh;
+			DH2O(objh)->o_parh = strmh;
+			if (objix == 0) {
+				DH2S(strmh)->s_cldh = objh;
 			} else {
-				DH2O( prevobjh )->o_nexth = objh;
+				DH2O(prevobjh)->o_nexth = objh;
 			}
 		}
 	}
 
 	/* update the object fields if not yet valid
 	 */
-	if ( idlabvalpr
+	if (idlabvalpr
 	     &&
-	     ! DH2O( objh )->o_idlabvalpr ) {
-		uuid_copy(DH2O( objh )->o_id, *mediaidp);
-		strncpy( DH2O( objh )->o_lab,
+	     ! DH2O(objh)->o_idlabvalpr) {
+		uuid_copy(DH2O(objh)->o_id, *mediaidp);
+		strncpy(DH2O(objh)->o_lab,
 			 medialabel,
-			 sizeof( DH2O( objh )->o_lab ));
-		DH2O( objh )->o_idlabvalpr = BOOL_TRUE;
+			 sizeof(DH2O(objh)->o_lab));
+		DH2O(objh)->o_idlabvalpr = BOOL_TRUE;
 	}
-	if ( mfixvalpr
+	if (mfixvalpr
 	     &&
 	     dmfixvalpr
 	     &&
-	     ! DH2O( objh )->o_fmfmixvalpr ) {
-		DH2O( objh )->o_fmfmix = mediafileix - dumpmediafileix;
-		DH2O( objh )->o_fmfmixvalpr = BOOL_TRUE;
+	     ! DH2O(objh)->o_fmfmixvalpr) {
+		DH2O(objh)->o_fmfmix = mediafileix - dumpmediafileix;
+		DH2O(objh)->o_fmfmixvalpr = BOOL_TRUE;
 	}
-	if ( dfixvalpr
+	if (dfixvalpr
 	     &&
 	     dmfixvalpr
 	     &&
-	     ! DH2O( objh )->o_fmfsixvalpr ) {
-		DH2O( objh )->o_fmfsix = dumpfileix - dumpmediafileix;
-		DH2O( objh )->o_fmfsixvalpr = BOOL_TRUE;
+	     ! DH2O(objh)->o_fmfsixvalpr) {
+		DH2O(objh)->o_fmfsix = dumpfileix - dumpmediafileix;
+		DH2O(objh)->o_fmfsixvalpr = BOOL_TRUE;
 	}
 
 	/* record the previous object's id and label if not yet valid
 	 */
-	if ( prevobjh != DH_NULL
+	if (prevobjh != DH_NULL
 	     &&
 	     previdlabvalpr
 	     &&
-	     ! DH2O( prevobjh )->o_idlabvalpr ) {
-		uuid_copy(DH2O( prevobjh )->o_id, *prevmediaidp);
-		strncpy( DH2O( prevobjh )->o_lab,
+	     ! DH2O(prevobjh)->o_idlabvalpr) {
+		uuid_copy(DH2O(prevobjh)->o_id, *prevmediaidp);
+		strncpy(DH2O(prevobjh)->o_lab,
 			       prevmedialabel,
-			       sizeof( DH2O( prevobjh )->o_lab ));
-		DH2O( prevobjh )->o_idlabvalpr = BOOL_TRUE;
+			       sizeof(DH2O(prevobjh)->o_lab));
+		DH2O(prevobjh)->o_idlabvalpr = BOOL_TRUE;
 	}
 
 	/* if the dump file and dump media file indices are valid,
@@ -5122,19 +5122,19 @@ pi_insertfile( ix_t drivecnt,
 	 * dump file index valid, can infer the index of the last media
 	 * file on the previous dump object.
 	 */
-	if ( DH2O( objh )->o_fmfsixvalpr
+	if (DH2O(objh)->o_fmfsixvalpr
 	     &&
 	     prevobjh != DH_NULL
 	     &&
-	     DH2O( prevobjh )->o_fmfsixvalpr
+	     DH2O(prevobjh)->o_fmfsixvalpr
 	     &&
-	     ! DH2O( prevobjh )->o_lmfknwnpr ) {
+	     ! DH2O(prevobjh)->o_lmfknwnpr) {
 		size_t prevmfcnt;
-		assert( DH2O( objh )->o_fmfsix > DH2O( prevobjh )->o_fmfsix );
-		prevmfcnt = DH2O( objh )->o_fmfsix - DH2O( prevobjh )->o_fmfsix;
-		pi_unlock( );
-		assert( mediaix > 0 );
-		( void )pi_insertfile( drivecnt,
+		assert(DH2O(objh)->o_fmfsix > DH2O(prevobjh)->o_fmfsix);
+		prevmfcnt = DH2O(objh)->o_fmfsix - DH2O(prevobjh)->o_fmfsix;
+		pi_unlock();
+		assert(mediaix > 0);
+		(void)pi_insertfile(drivecnt,
 				       driveix,
 				       mediaix - 1,
 				       BOOL_FALSE,
-- 
2.19.1
