Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9LGZwpV082218 for <xfs@oss.sgi.com>; Fri, 21 Oct 2011 11:35:58 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: incremental dump directory selection
Date: Fri, 21 Oct 2011 11:35:33 -0500
Message-Id: <1319214933-16276-1-git-send-email-wkendall@sgi.com>
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

When doing incremental backups, xfsdump does a recursive scan through
the filesystems to determine the proper set of unchanged directories
to include in the dump in order to make the dump self-contained
(allowing files to be restored from this dump without applying the
base dumps first).

For high-inode count filesystems, the recursive scan may consume a
significant portion of the backup time. This patch adds a -D option
which causes xfsdump to skip the recursive scan. Unchanged directories
will not be dumped, so the base dump(s) will have to be loaded prior
to restoring files from the dump. When restoring files from such a
dump, a message is issued to alert the user that files may end up in
the orphanage if the base dump(s) has not been applied.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/content_inode.h |    1 +
 common/main.c          |    1 +
 dump/content.c         |    9 +++++++++
 dump/getopt.h          |    4 ++--
 dump/inomap.c          |   25 +++++++++++++++++++------
 dump/inomap.h          |    1 +
 man/man8/xfsdump.8     |   17 +++++++++++++++++
 restore/content.c      |    7 +++++++
 8 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/common/content_inode.h b/common/content_inode.h
index 85e60df..67c4f6d 100644
--- a/common/content_inode.h
+++ b/common/content_inode.h
@@ -130,6 +130,7 @@ typedef struct content_inode_hdr content_inode_hdr_t;
 #define CIH_DUMPATTR_DIRENTHDR_GEN		( 1 << 11 )
 #define CIH_DUMPATTR_EXTATTR			( 1 << 12 )
 #define CIH_DUMPATTR_EXTATTRHDR_CHECKSUM	( 1 << 13 )
+#define CIH_DUMPATTR_NOTSELFCONTAINED		( 1 << 14 )
 
 
 /* timestruct_t - time structure
diff --git a/common/main.c b/common/main.c
index 55cdd93..08be16e 100644
--- a/common/main.c
+++ b/common/main.c
@@ -974,6 +974,7 @@ usage( void )
 #ifdef REVEAL
 	ULO(_("(generate tape record checksums)"),	GETOPT_RECCHKSUM );
 #endif /* REVEAL */
+	ULO(_("(skip unchanged directories)"),		GETOPT_NOUNCHANGEDDIRS );
 	ULO(_("(pre-erase media)"),			GETOPT_ERASE );
 	ULO(_("(don't prompt)"),			GETOPT_FORCE );
 #ifdef REVEAL
diff --git a/dump/content.c b/dump/content.c
index 26be043..54c97d1 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -533,6 +533,7 @@ content_init( intgen_t argc,
 	char mntpnt[ GLOBAL_HDR_STRING_SZ ];
 	char fsdevice[ GLOBAL_HDR_STRING_SZ ];
 	char fstype[ CONTENT_HDR_FSTYPE_SZ ];
+	bool_t skip_unchanged_dirs = BOOL_FALSE;
 	uuid_t fsid;
 	bool_t underfoundpr;
 	ix_t underlevel = ( ix_t )( -1 );
@@ -651,6 +652,9 @@ content_init( intgen_t argc,
 			}
 			maxdumpfilesize *= 1024;
 			break;
+		case GETOPT_NOUNCHANGEDDIRS:
+			skip_unchanged_dirs = BOOL_TRUE;
+			break;
 		case GETOPT_EXCLUDEFILES:
 			allowexcludefiles_pr = BOOL_TRUE;
 			break;
@@ -1443,6 +1447,7 @@ baseuuidbypass:
 			   sc_resumerangep,
 			   subtreep,
 			   subtreecnt,
+			   skip_unchanged_dirs,
 			   sc_startptp,
 			   drivecnt,
 			   &sc_stat_inomapphase,
@@ -1483,6 +1488,10 @@ baseuuidbypass:
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_INCREMENTAL;
 		scwhdrtemplatep->cih_last_time = sc_incrbasetime;
 		uuid_copy(scwhdrtemplatep->cih_last_id, sc_incrbaseid);
+		if ( skip_unchanged_dirs ) {
+			scwhdrtemplatep->cih_dumpattr |=
+				CIH_DUMPATTR_NOTSELFCONTAINED;
+		}
 	}
 	if ( sc_resumepr ) {
 		scwhdrtemplatep->cih_dumpattr |= CIH_DUMPATTR_RESUME;
diff --git a/dump/getopt.h b/dump/getopt.h
index 177f12f..8a55631 100644
--- a/dump/getopt.h
+++ b/dump/getopt.h
@@ -27,7 +27,7 @@
  * facilitating easy changes.
  */
 
-#define GETOPT_CMDSTRING	"ab:c:d:ef:hl:mop:qs:t:v:z:AB:CEFG:H:I:JL:M:NO:PRSTUVWY:Z"
+#define GETOPT_CMDSTRING	"ab:c:d:ef:hl:mop:qs:t:v:z:AB:CDEFG:H:I:JL:M:NO:PRSTUVWY:Z"
 
 #define GETOPT_DUMPASOFFLINE	'a'	/* dump DMF dualstate files as offline */
 #define	GETOPT_BLOCKSIZE	'b'	/* blocksize for rmt */
@@ -58,7 +58,7 @@
 #define	GETOPT_NOEXTATTR	'A'	/* do not dump ext. file attributes */
 #define	GETOPT_BASED		'B'	/* specify session to base increment */
 #define GETOPT_RECCHKSUM	'C'	/* use record checksums */
-/*				'D'	*/
+#define GETOPT_NOUNCHANGEDDIRS	'D'	/* skip unchanged directories */
 #define	GETOPT_ERASE		'E'	/* pre-erase media */
 #define GETOPT_FORCE		'F'	/* don't prompt (getopt.c) */
 #define GETOPT_MINSTACKSZ	'G'	/* minimum stack size (bytes) */
diff --git a/dump/inomap.c b/dump/inomap.c
index 3055391..a3b1220 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -72,6 +72,7 @@ static intgen_t cb_context( bool_t last,
 			    startpt_t *,
 			    size_t,
 			    intgen_t,
+			    bool_t,
 			    bool_t *);
 static void cb_context_free( void );
 static intgen_t cb_count_inogrp( void *, intgen_t, xfs_inogrp_t *);
@@ -148,6 +149,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 	      drange_t *resumerangep,
 	      char *subtreebuf[],
 	      ix_t subtreecnt,
+	      bool_t skip_unchanged_dirs,
 	      startpt_t *startptp,
 	      size_t startptcnt,
 	      ix_t *statphasep,
@@ -205,6 +207,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
 			   startptp,
 			   startptcnt,
 			   igrpcnt,
+			   skip_unchanged_dirs,
 			   &pruneneeded );
  	if ( rval ) {
  		free( ( void * )bstatbufp );
@@ -432,6 +435,7 @@ static off64_t cb_target;	/* set by cb_spinit(), used by cb_startpt() */
 static off64_t cb_dircnt;	/* number of dirs CHANGED or PRUNE */
 static off64_t cb_nondircnt;	/* number of non-dirs CHANGED */
 static bool_t *cb_pruneneededp; /* set by cb_context() */
+static bool_t cb_skip_unchanged_dirs;	/* set by cb_context() */
 
 /* cb_context - initializes the call back context for the add and prune
  * phases of inomap_build().
@@ -446,6 +450,7 @@ cb_context( bool_t last,
 	    startpt_t *startptp,
 	    size_t startptcnt,
 	    intgen_t igrpcnt,
+	    bool_t skip_unchanged_dirs,
 	    bool_t *pruneneededp )
 {
 	cb_last = last;
@@ -460,6 +465,7 @@ cb_context( bool_t last,
 	cb_dircnt = 0;
 	cb_nondircnt = 0;
 	cb_pruneneededp = pruneneededp;
+	cb_skip_unchanged_dirs = skip_unchanged_dirs;
 
 	if (inomap_init( igrpcnt ))
 		return -1;
@@ -642,12 +648,19 @@ cb_add( void *arg1,
 		ASSERT( changed );
 	} else {
 		if ( mode == S_IFDIR ) {
-			*cb_pruneneededp = BOOL_TRUE;
-			inomap_add( cb_inomap_contextp,
-				    ino,
-				    (gen_t)statp->bs_gen,
-				    MAP_DIR_SUPPRT );
-			cb_dircnt++;
+			if ( cb_skip_unchanged_dirs ) {
+				inomap_add( cb_inomap_contextp,
+					    ino,
+					    (gen_t)statp->bs_gen,
+					    MAP_DIR_NOCHNG );
+			} else {
+				*cb_pruneneededp = BOOL_TRUE;
+				inomap_add( cb_inomap_contextp,
+					    ino,
+					    (gen_t)statp->bs_gen,
+					    MAP_DIR_SUPPRT );
+				cb_dircnt++;
+			}
 		} else {
 			inomap_add( cb_inomap_contextp,
 				    ino,
diff --git a/dump/inomap.h b/dump/inomap.h
index ce6bd9d..16f2efb 100644
--- a/dump/inomap.h
+++ b/dump/inomap.h
@@ -57,6 +57,7 @@ extern bool_t inomap_build( jdm_fshandle_t *fshandlep,
 			    drange_t *resumerangep,
 			    char *subtreebuf[],
 			    ix_t subtreecnt,
+			    bool_t skip_unchanged_dirs,
 			    startpt_t startptp[],
 	      		    size_t startptcnt,
 			    ix_t *statphasep,
diff --git a/man/man8/xfsdump.8 b/man/man8/xfsdump.8
index 428912c..46e6bd5 100644
--- a/man/man8/xfsdump.8
+++ b/man/man8/xfsdump.8
@@ -284,6 +284,23 @@ This option allows incremental
 and resumed dumps to be based on any previous dump,
 rather than just the most recent.
 .TP 5
+.B \-D
+Controls which directories are backed up during an incremental dump. By
+default unchanged directories are dumped if files or directories beneath
+them have changed. This results in a self-contained dump -- if a base dump
+is lost, or you know the file(s) you wish to restore is in an incremental
+dump, you can restore just that dump without loading the base dump(s)
+first. However, this method requires a potentially expensive traversal
+through the filesystem.
+
+When
+.B \-D
+is specified, unchanged directories are not dumped.
+This results in a faster dump, but files will end up in the
+.IR xfsrestore (8)
+.I orphanage
+directory unless the base dump(s) is loaded first.
+.TP 5
 .B \-E
 Pre-erase media.
 If this option is specified, media is erased prior to use.
diff --git a/restore/content.c b/restore/content.c
index 9ff5b93..e5957bf 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2912,6 +2912,13 @@ applydirdump( drive_t *drivep,
 		persp->s.marknorefdonepr = BOOL_TRUE;
 	}
 
+	if ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_NOTSELFCONTAINED ) {
+		mlog( MLOG_NORMAL | MLOG_NOTE, _(
+		      "dump is not self-contained, "
+		      "orphaned files expected if base dump(s) "
+		      "was not applied\n") );
+	}
+
 	if ( ! persp->s.dirdonepr ) {
 		rv_t rv;
 		dah_t dah;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
