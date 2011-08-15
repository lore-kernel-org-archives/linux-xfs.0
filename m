Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FDtfR1085699 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 08:55:41 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v3 7/7] xfsdump: refactor inventory session creation
Date: Mon, 15 Aug 2011 08:55:06 -0500
Message-Id: <1313416506-3666-8-git-send-email-wkendall@sgi.com>
In-Reply-To: <1313416506-3666-1-git-send-email-wkendall@sgi.com>
References: <1313416506-3666-1-git-send-email-wkendall@sgi.com>
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

Move the inventory session creation out of content_init and into a
new function, create_inv_session, in order to simplify restoration
of the signal mask. TTY-related signals are blocked prior to calling
create_inv_session and restored afterwards.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 dump/content.c |  175 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 92 insertions(+), 83 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index fcc952e..9905c88 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -507,7 +507,13 @@ static quota_info_t quotas[] = {
 
 
 /* definition of locally defined static functions ****************************/
-
+static bool_t create_inv_session(
+		global_hdr_t *gwhdrtemplatep,
+		uuid_t *fsidp,
+		const char *mntpnt,
+		const char *fsdevice,
+		ix_t subtreecnt,
+		size_t strmix);
 
 bool_t
 content_init( intgen_t argc,
@@ -1695,100 +1701,27 @@ baseuuidbypass:
 	}
 
 	/* open the dump inventory and a dump inventory write session
-	 * if an inventory update is to be done. first create a cleanup
-	 * handler, to close the inventory on exit.
+	 * if an inventory update is to be done.
 	 */
 	if ( sc_inv_updatepr ) {
-		char *qmntpnt;
-		char *qfsdevice;
+		bool_t result;
 		sigset_t tty_set, orig_set;
 
-		rval = atexit( inv_cleanup );
-		ASSERT( ! rval );
-		sc_inv_idbtoken = inv_open( ( inv_predicate_t )INV_BY_UUID,
-					    INV_SEARCH_N_MOD,
-					    ( void * )&fsid );
-		if ( sc_inv_idbtoken == INV_TOKEN_NULL ) {
-			return BOOL_FALSE;
-		}
-		qmntpnt = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
-					       +
-					       1
-					       +
-					       strlen( mntpnt )
-					       +
-					       1 );
-		ASSERT( qmntpnt );
-		ASSERT( strlen( gwhdrtemplatep->gh_hostname ));
-		( void )sprintf( qmntpnt,
-				 "%s:%s",
-				 gwhdrtemplatep->gh_hostname,
-				 mntpnt );
-		qfsdevice = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
-					       +
-					       1
-					       +
-					       strlen( fsdevice )
-					       +
-					       1 );
-		ASSERT( qfsdevice );
-		( void )sprintf( qfsdevice,
-				 "%s:%s",
-				 gwhdrtemplatep->gh_hostname,
-				 fsdevice );
-
-		/* hold tty signals while creating a new inventory session
-		 */
+		/* hold tty signals while creating a new inventory session */
 		sigemptyset( &tty_set );
 		sigaddset( &tty_set, SIGINT );
 		sigaddset( &tty_set, SIGQUIT );
 		sigaddset( &tty_set, SIGHUP );
 		sigprocmask( SIG_BLOCK, &tty_set, &orig_set );
 
-		sc_inv_sestoken = inv_writesession_open( sc_inv_idbtoken,
-						&fsid,
-						&gwhdrtemplatep->gh_dumpid,
-						gwhdrtemplatep->gh_dumplabel,
-						subtreecnt ? BOOL_TRUE
-							   : BOOL_FALSE,
-						sc_resumepr,
-						( u_char_t )sc_level,
-						drivecnt,
-						gwhdrtemplatep->gh_timestamp,
-						qmntpnt,
-						qfsdevice );
-		if( sc_inv_sestoken == INV_TOKEN_NULL ) {
-			sigprocmask( SIG_SETMASK, &orig_set, NULL );
-			return BOOL_FALSE;
-		}
-
-		/* open an inventory stream for each stream
-		 */
-		sc_inv_stmtokenp = ( inv_stmtoken_t * )calloc( drivecnt,
-							       sizeof( inv_stmtoken_t ));
-		ASSERT( sc_inv_stmtokenp );
-		for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
-			drive_t *drivep = drivepp[ strmix ];
-			char *drvpath;
-
-			if ( strcmp( drivep->d_pathname, "stdio" )) {
-				drvpath = path_reltoabs( drivep->d_pathname,
-							 homedir );
-			} else {
-				drvpath = drivep->d_pathname;
-			}
-			sc_inv_stmtokenp[ strmix ] = inv_stream_open( sc_inv_sestoken,
-								      drvpath );
-			if ( strcmp( drivep->d_pathname, "stdio" )) {
-				free( ( void * )drvpath );
-			}
-			if ( sc_inv_stmtokenp[ strmix ] == INV_TOKEN_NULL ) {
-				sigprocmask( SIG_SETMASK, &orig_set, NULL );
-				return BOOL_FALSE;
-			}
-		}
+		result = create_inv_session( gwhdrtemplatep, &fsid, mntpnt,
+					     fsdevice, subtreecnt, strmix );
 
 		sigprocmask( SIG_SETMASK, &orig_set, NULL );
+
+		if ( !result ) {
+			return BOOL_FALSE;
+		}
 	}
 
 	/* set media change flags to FALSE;
@@ -2012,6 +1945,82 @@ content_statline( char **linespp[ ] )
 	return statlinecnt;
 }
 
+static bool_t
+create_inv_session(
+		global_hdr_t *gwhdrtemplatep,
+		uuid_t *fsidp,
+		const char *mntpnt,
+		const char *fsdevice,
+		ix_t subtreecnt,
+		size_t strmix)
+{
+	intgen_t rval;
+	char *qmntpnt;
+	char *qfsdevice;
+
+	/* create a cleanup handler to close the inventory on exit. */
+	rval = atexit( inv_cleanup );
+	ASSERT( ! rval );
+
+	sc_inv_idbtoken = inv_open( ( inv_predicate_t )INV_BY_UUID,
+					INV_SEARCH_N_MOD,
+					( void * )fsidp );
+	if ( sc_inv_idbtoken == INV_TOKEN_NULL ) {
+		return BOOL_FALSE;
+	}
+	qmntpnt = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
+					+ 1 + strlen( mntpnt ) + 1 );
+	ASSERT( qmntpnt );
+	ASSERT( strlen( gwhdrtemplatep->gh_hostname ));
+	sprintf( qmntpnt, "%s:%s", gwhdrtemplatep->gh_hostname, mntpnt );
+	qfsdevice = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
+					 + 1 + strlen( fsdevice ) + 1 );
+	ASSERT( qfsdevice );
+	sprintf( qfsdevice, "%s:%s", gwhdrtemplatep->gh_hostname, fsdevice );
+
+	sc_inv_sestoken = inv_writesession_open( sc_inv_idbtoken,
+						fsidp,
+						&gwhdrtemplatep->gh_dumpid,
+						gwhdrtemplatep->gh_dumplabel,
+						subtreecnt ? BOOL_TRUE
+							   : BOOL_FALSE,
+						sc_resumepr,
+						( u_char_t )sc_level,
+						drivecnt,
+						gwhdrtemplatep->gh_timestamp,
+						qmntpnt,
+						qfsdevice );
+	if ( sc_inv_sestoken == INV_TOKEN_NULL ) {
+		return BOOL_FALSE;
+	}
+
+	/* open an inventory stream for each stream
+	*/
+	sc_inv_stmtokenp = ( inv_stmtoken_t * )
+				calloc( drivecnt, sizeof( inv_stmtoken_t ));
+	ASSERT( sc_inv_stmtokenp );
+	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
+		drive_t *drivep = drivepp[ strmix ];
+		char *drvpath;
+
+		if ( strcmp( drivep->d_pathname, "stdio" )) {
+			drvpath = path_reltoabs( drivep->d_pathname, homedir );
+		} else {
+			drvpath = drivep->d_pathname;
+		}
+		sc_inv_stmtokenp[ strmix ] = inv_stream_open( sc_inv_sestoken,
+								drvpath );
+		if ( strcmp( drivep->d_pathname, "stdio" )) {
+			free( ( void * )drvpath );
+		}
+		if ( sc_inv_stmtokenp[ strmix ] == INV_TOKEN_NULL ) {
+			return BOOL_FALSE;
+		}
+	}
+
+	return BOOL_TRUE;
+}
+
 static void
 mark_set( drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags )
 {
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
