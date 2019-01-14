Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbfANR0F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Jan 2019 12:26:05 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BF6C1F58E
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jan 2019 17:26:04 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/13] xfsdump: (5/13) (style) remove spaces from parentheses
Date: Mon, 14 Jan 2019 18:25:20 +0100
Message-Id: <20190114172528.65250-6-jtulak@redhat.com>
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
 common/mlog.c     | 328 +++++++++++++++++++++++-----------------------
 common/mlog.h     |  58 ++++----
 common/openutil.c |  72 +++++-----
 common/openutil.h |  22 ++--
 common/path.c     | 190 +++++++++++++--------------
 common/path.h     |   8 +-
 common/qlock.c    | 116 ++++++++--------
 common/qlock.h    |  18 +--
 common/rec_hdr.h  |   4 +-
 common/ring.c     | 228 ++++++++++++++++----------------
 common/ring.h     |  20 +--
 common/stream.c   |  96 +++++++-------
 common/stream.h   |  26 ++--
 common/timeutil.c |   8 +-
 common/timeutil.h |   6 +-
 common/ts_mtio.h  |   2 +-
 common/types.h    |  58 ++++----
 common/util.c     | 260 ++++++++++++++++++------------------
 common/util.h     |  56 ++++----
 19 files changed, 788 insertions(+), 788 deletions(-)

diff --git a/common/mlog.c b/common/mlog.c
index 0924bf2..e3cf69d 100644
--- a/common/mlog.c
+++ b/common/mlog.c
@@ -42,7 +42,7 @@
 #include "drive.h"
 
 extern char *progname;
-extern void usage( void );
+extern void usage(void);
 extern pthread_t parenttid;
 
 #ifdef DUMP
@@ -52,7 +52,7 @@ static FILE *mlog_fp = NULL; /* stderr */;
 static FILE *mlog_fp = NULL; /* stdout */;
 #endif /* RESTORE */
 
-int mlog_level_ss[ MLOG_SS_CNT ];
+int mlog_level_ss[MLOG_SS_CNT];
 
 int mlog_showlevel = BOOL_FALSE;
 
@@ -60,11 +60,11 @@ int mlog_showss = BOOL_FALSE;
 
 int mlog_timestamp = BOOL_FALSE;
 
-static int mlog_sym_lookup( char * );
+static int mlog_sym_lookup(char *);
 
 static size_t mlog_streamcnt;
 
-static char mlog_levelstr[ 3 ];
+static char mlog_levelstr[3];
 
 #define MLOG_SS_NAME_MAX	15
 #ifdef DUMP
@@ -76,9 +76,9 @@ static char mlog_levelstr[ 3 ];
 #endif /* DUMP */
 #define N(a) (sizeof((a)) / sizeof((a)[0]))
 
-static char mlog_ssstr[ MLOG_SS_NAME_MAX + 2 ];
+static char mlog_ssstr[MLOG_SS_NAME_MAX + 2];
 
-static char mlog_tsstr[ 10 ];
+static char mlog_tsstr[10];
 
 struct mlog_sym {
 	char *sym;
@@ -87,7 +87,7 @@ struct mlog_sym {
 
 typedef struct mlog_sym mlog_sym_t;
 
-char *mlog_ss_names[ MLOG_SS_CNT ] = {
+char *mlog_ss_names[MLOG_SS_CNT] = {
 	"general",	/* MLOG_SS_GEN */
 	"proc",		/* MLOG_SS_PROC */
 	"drive",	/* MLOG_SS_DRIVE */
@@ -102,7 +102,7 @@ char *mlog_ss_names[ MLOG_SS_CNT ] = {
 	"excluded_files" /* MLOG_SS_EXCLFILES */
 };
 
-static mlog_sym_t mlog_sym[ ] = {
+static mlog_sym_t mlog_sym[] = {
 	{"0",		MLOG_SILENT},
 	{"1",		MLOG_VERBOSE},
 	{"2",		MLOG_TRACE},
@@ -122,7 +122,7 @@ static rv_t mlog_main_exit_return = RV_NONE;
 static rv_t mlog_main_exit_hint = RV_NONE;
 
 void
-mlog_init0( void )
+mlog_init0(void)
 {
 	int i;
 
@@ -134,17 +134,17 @@ mlog_init0( void )
 #endif /* RESTORE */
 
 	/* initialize stream count. will be updated later by call to
-	 * mlog_tell_streamcnt( ), after drive layer has counted drives
+	 * mlog_tell_streamcnt(), after drive layer has counted drives
 	 */
 	mlog_streamcnt = 1;
 
-	for( i = 0 ; i < MLOG_SS_CNT ; i++ ) {
-		mlog_level_ss[ i ] = MLOG_VERBOSE;
+	for(i = 0 ; i < MLOG_SS_CNT ; i++) {
+		mlog_level_ss[i] = MLOG_VERBOSE;
 	}
 }
 
 bool_t
-mlog_init1( int argc, char *argv[ ] )
+mlog_init1(int argc, char *argv[])
 {
 	char **suboptstrs;
 	ix_t ssix;
@@ -154,105 +154,105 @@ mlog_init1( int argc, char *argv[ ] )
 
 	/* prepare an array of suboption token strings. this will be the
 	 * concatenation of the subsystem names with the verbosity symbols.
-	 * this array of char pts must be null terminated for getsubopt( 3 ).
+	 * this array of char pts must be null terminated for getsubopt(3).
 	 */
-	vsymcnt = sizeof( mlog_sym ) / sizeof( mlog_sym[ 0 ] );
-	suboptstrs = ( char ** )calloc( MLOG_SS_CNT + vsymcnt + 1,
-					sizeof( char * ));
-	assert( suboptstrs );
-	for ( soix = 0 ; soix < MLOG_SS_CNT ; soix++ ) {
-		assert( strlen( mlog_ss_names[ soix ] ) <= MLOG_SS_NAME_MAX );
+	vsymcnt = sizeof(mlog_sym) / sizeof(mlog_sym[0]);
+	suboptstrs = (char **)calloc(MLOG_SS_CNT + vsymcnt + 1,
+					sizeof(char *));
+	assert(suboptstrs);
+	for (soix = 0 ; soix < MLOG_SS_CNT ; soix++) {
+		assert(strlen(mlog_ss_names[soix]) <= MLOG_SS_NAME_MAX);
 			/* unrelated, but opportunity to chk */
-		suboptstrs[ soix ] = mlog_ss_names[ soix ];
+		suboptstrs[soix] = mlog_ss_names[soix];
 	}
-	for ( ; soix < MLOG_SS_CNT + vsymcnt ; soix++ ) {
-		suboptstrs[ soix ] = mlog_sym[ soix - MLOG_SS_CNT ].sym;
+	for (; soix < MLOG_SS_CNT + vsymcnt ; soix++) {
+		suboptstrs[soix] = mlog_sym[soix - MLOG_SS_CNT].sym;
 	}
-	suboptstrs[ soix ] = 0;
+	suboptstrs[soix] = 0;
 
 	/* set all of the subsystem log levels to -1, so we can see which
 	 * subsystems where explicitly called out. those which weren't will
 	 * be given the "general" level.
 	 */
-	for ( ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++ ) {
-		mlog_level_ss[ ssix ] = -1;
+	for (ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++) {
+		mlog_level_ss[ssix] = -1;
 	}
-	mlog_level_ss[ MLOG_SS_GEN ] = MLOG_VERBOSE;
+	mlog_level_ss[MLOG_SS_GEN] = MLOG_VERBOSE;
 
 	/* get command line options
 	 */
 	optind = 1;
 	opterr = 0;
-	while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
+	while ((c = getopt(argc, argv, GETOPT_CMDSTRING)) != EOF) {
 		char *options;
 
-		switch ( c ) {
+		switch (c) {
 		case GETOPT_VERBOSITY:
-			if ( ! optarg || optarg[ 0 ] == '-' ) {
-				fprintf( stderr,
+			if (! optarg || optarg[0] == '-') {
+				fprintf(stderr,
 					 _("%s: -%c argument missing\n"),
 					 progname,
-					 c );
-				usage( );
+					 c);
+				usage();
 				return BOOL_FALSE;
 			}
 			options = optarg;
-			while ( *options ) {
+			while (*options) {
 				int suboptix;
 				char *valstr;
 
-				suboptix = getsubopt( &options,
+				suboptix = getsubopt(&options,
 						      (constpp)suboptstrs,
-						      &valstr );
-				if ( suboptix < 0 ) {
-					fprintf( stderr,
+						      &valstr);
+				if (suboptix < 0) {
+					fprintf(stderr,
 						 _("%s: -%c argument invalid\n"),
 						 progname,
-						 c );
-					usage( );
+						 c);
+					usage();
 					return BOOL_FALSE;
 				}
-				assert( ( ix_t )suboptix
+				assert((ix_t)suboptix
 					<
-					MLOG_SS_CNT + vsymcnt );
-				if ( suboptix < MLOG_SS_CNT ) {
-					if ( ! valstr ) {
-						fprintf( stderr,
+					MLOG_SS_CNT + vsymcnt);
+				if (suboptix < MLOG_SS_CNT) {
+					if (! valstr) {
+						fprintf(stderr,
 							 _("%s: -%c subsystem "
 							 "subargument "
 							 "%s requires a "
 							 "verbosity value\n"),
 							 progname,
 							 c,
-						mlog_ss_names[ suboptix ] );
-						usage( );
+						mlog_ss_names[suboptix]);
+						usage();
 						return BOOL_FALSE;
 					}
-					ssix = ( ix_t )suboptix;
-					mlog_level_ss[ ssix ] =
-						    mlog_sym_lookup( valstr );
+					ssix = (ix_t)suboptix;
+					mlog_level_ss[ssix] =
+						    mlog_sym_lookup(valstr);
 				} else {
-					if ( valstr ) {
-						fprintf( stderr,
+					if (valstr) {
+						fprintf(stderr,
 							 _("%s: -%c argument "
 							 "does not require "
 							 "a value\n"),
 							 progname,
-							 c );
-						usage( );
+							 c);
+						usage();
 						return BOOL_FALSE;
 					}
 					ssix = MLOG_SS_GEN;
-					mlog_level_ss[ ssix ] =
-				    mlog_sym_lookup( suboptstrs[ suboptix ] );
+					mlog_level_ss[ssix] =
+				    mlog_sym_lookup(suboptstrs[suboptix]);
 				}
-				if ( mlog_level_ss[ ssix ] < 0 ) {
-					fprintf( stderr,
+				if (mlog_level_ss[ssix] < 0) {
+					fprintf(stderr,
 						 _("%s: -%c argument "
 						 "invalid\n"),
 						 progname,
-						 c );
-					usage( );
+						 c);
+					usage();
 					return BOOL_FALSE;
 				}
 			}
@@ -269,25 +269,25 @@ mlog_init1( int argc, char *argv[ ] )
 		}
 	}
 
-	free( ( void * )suboptstrs );
+	free((void *)suboptstrs);
 
 	/* give subsystems not explicitly called out the "general" verbosity
 	 */
-	for ( ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++ ) {
-		if ( mlog_level_ss[ ssix ] < 0 ) {
-			assert( mlog_level_ss[ ssix ] == -1 );
-			assert( mlog_level_ss[ MLOG_SS_GEN ] >= 0 );
-			mlog_level_ss[ ssix ] = mlog_level_ss[ MLOG_SS_GEN ];
+	for (ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++) {
+		if (mlog_level_ss[ssix] < 0) {
+			assert(mlog_level_ss[ssix] == -1);
+			assert(mlog_level_ss[MLOG_SS_GEN] >= 0);
+			mlog_level_ss[ssix] = mlog_level_ss[MLOG_SS_GEN];
 		}
 	}
 
 	/* prepare a string for optionally displaying the log level
 	 */
-	mlog_levelstr[ 0 ] = 0;
-	mlog_levelstr[ 1 ] = 0;
-	mlog_levelstr[ 2 ] = 0;
-	if ( mlog_showlevel ) {
-		mlog_levelstr[ 0 ] = ':';
+	mlog_levelstr[0] = 0;
+	mlog_levelstr[1] = 0;
+	mlog_levelstr[2] = 0;
+	if (mlog_showlevel) {
+		mlog_levelstr[0] = ':';
 	}
 
 #ifdef DUMP
@@ -296,7 +296,7 @@ mlog_init1( int argc, char *argv[ ] )
 	 * mlog_fd set to stderr, see if we can switch
 	 * to stdout.
 	 */
-	if ( optind >= argc ||  strcmp( argv[ optind ], "-" )) {
+	if (optind >= argc ||  strcmp(argv[optind ], "-")) {
 		mlog_fp = stdout;
 	}
 #endif /* DUMP */
@@ -307,31 +307,31 @@ mlog_init1( int argc, char *argv[ ] )
 }
 
 bool_t
-mlog_init2( void )
+mlog_init2(void)
 {
 	/* allocate a qlock
 	 */
-	mlog_qlockh = qlock_alloc( QLOCK_ORD_MLOG );
+	mlog_qlockh = qlock_alloc(QLOCK_ORD_MLOG);
 
 	return BOOL_TRUE;
 }
 
 void
-mlog_tell_streamcnt( size_t streamcnt )
+mlog_tell_streamcnt(size_t streamcnt)
 {
 	mlog_streamcnt = streamcnt;
 }
 
 void
-mlog_lock( void )
+mlog_lock(void)
 {
-	qlock_lock( mlog_qlockh );
+	qlock_lock(mlog_qlockh);
 }
 
 void
-mlog_unlock( void )
+mlog_unlock(void)
 {
-	qlock_unlock( mlog_qlockh );
+	qlock_unlock(mlog_qlockh);
 }
 
 /*
@@ -341,122 +341,122 @@ mlog_unlock( void )
  * too much output.
  */
 void
-mlog_override_level( int levelarg )
+mlog_override_level(int levelarg)
 {
 	int level;
 	ix_t ss; /* SubSystem */
 
 	level = levelarg & MLOG_LEVELMASK;
-	ss = ( ix_t )( ( levelarg & MLOG_SS_MASK ) >> MLOG_SS_SHIFT );
+	ss = (ix_t)((levelarg & MLOG_SS_MASK) >> MLOG_SS_SHIFT);
 
 	if (ss == MLOG_SS_GEN) { /* do level for all subsys */
-	    for (ss = 0 ; ss < MLOG_SS_CNT ; ss++ ) {
-		mlog_level_ss[ ss ] = level;
+	    for (ss = 0 ; ss < MLOG_SS_CNT ; ss++) {
+		mlog_level_ss[ss] = level;
 	    }
 	}
 	else { /* do a particular subsys */
-	    mlog_level_ss[ ss ] = level;
+	    mlog_level_ss[ss] = level;
 	}
 }
 
 void
-mlog( int levelarg, char *fmt, ... )
+mlog(int levelarg, char *fmt, ...)
 {
 	va_list args;
-	va_start( args, fmt );
-	mlog_va( levelarg, fmt, args );
-	va_end( args );
+	va_start(args, fmt);
+	mlog_va(levelarg, fmt, args);
+	va_end(args);
 }
 
 void
-mlog_va( int levelarg, char *fmt, va_list args )
+mlog_va(int levelarg, char *fmt, va_list args)
 {
 	int level;
 	ix_t ss;
 
 	level = levelarg & MLOG_LEVELMASK;
-	ss = ( ix_t )( ( levelarg & MLOG_SS_MASK ) >> MLOG_SS_SHIFT );
+	ss = (ix_t)((levelarg & MLOG_SS_MASK) >> MLOG_SS_SHIFT);
 
-	assert( ss < MLOG_SS_CNT );
-	if ( level > mlog_level_ss[ ss ] ) {
+	assert(ss < MLOG_SS_CNT);
+	if (level > mlog_level_ss[ss]) {
 		return;
 	}
 
-	if ( ! ( levelarg & MLOG_NOLOCK )) {
-		mlog_lock( );
+	if (! (levelarg & MLOG_NOLOCK)) {
+		mlog_lock();
 	}
 
-	if ( ! ( levelarg & MLOG_BARE )) {
+	if (! (levelarg & MLOG_BARE)) {
 		int streamix;
-		streamix = stream_getix( pthread_self( ) );
+		streamix = stream_getix(pthread_self());
 
-		if ( mlog_showss ) {
-			sprintf( mlog_ssstr, ":%s", mlog_ss_names[ ss ] );
+		if (mlog_showss) {
+			sprintf(mlog_ssstr, ":%s", mlog_ss_names[ ss]);
 		} else {
-			mlog_ssstr[ 0 ] = 0;
+			mlog_ssstr[0] = 0;
 		}
 
-		if ( mlog_timestamp ) {
-			time_t now = time( 0 );
-			struct tm *tmp = localtime( &now );
-			sprintf( mlog_tsstr,
+		if (mlog_timestamp) {
+			time_t now = time(0);
+			struct tm *tmp = localtime(&now);
+			sprintf(mlog_tsstr,
 				 ":%02d.%02d.%02d",
 				 tmp->tm_hour,
 				 tmp->tm_min,
-				 tmp->tm_sec );
-			assert( strlen( mlog_tsstr ) < sizeof( mlog_tsstr ));
+				 tmp->tm_sec);
+			assert(strlen(mlog_tsstr) < sizeof(mlog_tsstr));
 		} else {
-			mlog_tsstr[ 0 ] = 0;
+			mlog_tsstr[0] = 0;
 		}
 
-		if ( mlog_showlevel ) {
-			mlog_levelstr[ 0 ] = ':';
-			if ( level > 9 ) {
-				mlog_levelstr[ 1 ] = '?';
+		if (mlog_showlevel) {
+			mlog_levelstr[0] = ':';
+			if (level > 9) {
+				mlog_levelstr[1] = '?';
 			} else {
-				mlog_levelstr[ 1 ] = ( char )
-						     ( level
+				mlog_levelstr[1] = (char)
+						     (level
 						       +
-						       ( int )'0' );
+						       (int)'0');
 			}
 		} else {
-			mlog_levelstr[ 0 ] = 0;
+			mlog_levelstr[0] = 0;
 		}
-		if ( streamix != -1 && mlog_streamcnt > 1 ) {
-			fprintf( mlog_fp,
+		if (streamix != -1 && mlog_streamcnt > 1) {
+			fprintf(mlog_fp,
 				 _("%s%s%s%s: drive %d: "),
 				 progname,
 				 mlog_tsstr,
 				 mlog_ssstr,
 				 mlog_levelstr,
-				 streamix );
+				 streamix);
 		} else {
-			fprintf( mlog_fp,
+			fprintf(mlog_fp,
 				 "%s%s%s%s: ",
 				 progname,
 				 mlog_tsstr,
 				 mlog_ssstr,
-				 mlog_levelstr );
+				 mlog_levelstr);
 		}
-		if ( levelarg & MLOG_NOTE ) {
-			fprintf( mlog_fp,
-				 "NOTE: " );
+		if (levelarg & MLOG_NOTE) {
+			fprintf(mlog_fp,
+				 "NOTE: ");
 		}
-		if ( levelarg & MLOG_WARNING ) {
-			fprintf( mlog_fp,
-				 "WARNING: " );
+		if (levelarg & MLOG_WARNING) {
+			fprintf(mlog_fp,
+				 "WARNING: ");
 		}
-		if ( levelarg & MLOG_ERROR ) {
-			fprintf( mlog_fp,
-				 "ERROR: " );
+		if (levelarg & MLOG_ERROR) {
+			fprintf(mlog_fp,
+				 "ERROR: ");
 		}
 	}
 
-	vfprintf( mlog_fp, fmt, args );
-	fflush( mlog_fp );
+	vfprintf(mlog_fp, fmt, args);
+	fflush(mlog_fp);
 
-	if ( ! ( levelarg & MLOG_NOLOCK )) {
-		mlog_unlock( );
+	if (! (levelarg & MLOG_NOLOCK)) {
+		mlog_unlock();
 	}
 }
 
@@ -569,7 +569,7 @@ rv_getdesc(rv_t rv)
  */
 
 int
-_mlog_exit( const char *file, int line, int exit_code, rv_t rv )
+_mlog_exit(const char *file, int line, int exit_code, rv_t rv)
 {
 	pthread_t tid;
 	const struct rv_map *rvp;
@@ -578,7 +578,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	rvp = rv_getdesc(rv);
 
 
-	mlog( MLOG_DEBUG | MLOG_NOLOCK,
+	mlog(MLOG_DEBUG | MLOG_NOLOCK,
 	      "%s: %d: mlog_exit called: "
 	      "exit_code: %s return: %s (%s)\n",
 	      file, line,
@@ -586,7 +586,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	      rvp->rv_string, rvp->rv_desc);
 
 	if (rv < 0 || rv >= _RV_NUM) {
-		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,
+		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,
 		      "mlog_exit(): bad return code");
 		return exit_code;
 	}
@@ -598,7 +598,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 	 * most accurate information about the termination condition.
 	 */
 
-	if ( pthread_equal( tid, parenttid ) ) {
+	if (pthread_equal(tid, parenttid)) {
 		if (mlog_main_exit_code == -1) {
 			mlog_main_exit_code = exit_code;
 			mlog_main_exit_return = rv;
@@ -631,7 +631,7 @@ _mlog_exit( const char *file, int line, int exit_code, rv_t rv )
 }
 
 void
-_mlog_exit_hint( const char *file, int line, rv_t rv )
+_mlog_exit_hint(const char *file, int line, rv_t rv)
 {
 	pthread_t tid;
 	const struct rv_map *rvp;
@@ -639,14 +639,14 @@ _mlog_exit_hint( const char *file, int line, rv_t rv )
 	tid = pthread_self();
 	rvp = rv_getdesc(rv);
 
-	mlog( MLOG_DEBUG | MLOG_NOLOCK,
+	mlog(MLOG_DEBUG | MLOG_NOLOCK,
 	      "%s: %d: mlog_exit_hint called: "
 	      "hint: %s (%s)\n",
 	      file, line,
 	      rvp->rv_string, rvp->rv_desc);
 
 	if (rv < 0 || rv >= _RV_NUM) {
-		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,
+		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,
 		      "mlog_exit_hint(): bad return code");
 		return;
 	}
@@ -658,22 +658,22 @@ _mlog_exit_hint( const char *file, int line, rv_t rv )
 	 * information about the termination condition.
 	 */
 
-	if ( pthread_equal( tid, parenttid ) )
+	if (pthread_equal(tid, parenttid))
 		mlog_main_exit_hint = rv;
 	else
-		stream_set_hint( tid, rv );
+		stream_set_hint(tid, rv);
 
 }
 
 rv_t
-mlog_get_hint( void )
+mlog_get_hint(void)
 {
 	stream_state_t states[] = { S_RUNNING };
 	/* REFERENCED */
 	bool_t ok;
 	rv_t hint;
 
-	if ( pthread_equal( pthread_self(), parenttid ) )
+	if (pthread_equal(pthread_self(), parenttid))
 		return mlog_main_exit_hint;
 
 	ok = stream_get_exit_status(pthread_self(), states, N(states),
@@ -720,7 +720,7 @@ mlog_exit_flush(void)
 	if (ntids > 0) {
 
 		/* print the state of all the streams */
-		fprintf(mlog_fp, _("%s: %s Summary:\n"), progname, PROGSTR_CAPS );
+		fprintf(mlog_fp, _("%s: %s Summary:\n"), progname, PROGSTR_CAPS);
 
 		for (i = 0; i < ntids; i++) {
 			stream_state_t state;
@@ -785,15 +785,15 @@ mlog_exit_flush(void)
 }
 
 static int
-mlog_sym_lookup( char *sym )
+mlog_sym_lookup(char *sym)
 {
 	mlog_sym_t *p = mlog_sym;
 	mlog_sym_t *ep = mlog_sym
 			 +
-			 sizeof( mlog_sym ) / sizeof( mlog_sym[ 0 ] );
+			 sizeof(mlog_sym) / sizeof(mlog_sym[0]);
 
-	for ( ; p < ep ; p++ ) {
-		if ( ! strcmp( sym, p->sym )) {
+	for (; p < ep ; p++) {
+		if (! strcmp(sym, p->sym)) {
 			return p->level;
 		}
 	}
@@ -802,7 +802,7 @@ mlog_sym_lookup( char *sym )
 }
 
 void
-fold_init( fold_t fold, char *infostr, char c )
+fold_init(fold_t fold, char *infostr, char c)
 {
 	size_t infolen;
 	size_t dashlen;
@@ -812,36 +812,36 @@ fold_init( fold_t fold, char *infostr, char c )
 	char *endp;
 	ix_t cnt;
 
-	assert( sizeof( fold_t ) == FOLD_LEN + 1 );
+	assert(sizeof(fold_t) == FOLD_LEN + 1);
 
-	infolen = strlen( infostr );
-	if ( infolen > FOLD_LEN - 4 ) {
+	infolen = strlen(infostr);
+	if (infolen > FOLD_LEN - 4) {
 		infolen = FOLD_LEN - 4;
 	}
 	dashlen = FOLD_LEN - infolen - 3;
 	predashlen = dashlen / 2;
 	postdashlen = dashlen - predashlen;
 
-	p = &fold[ 0 ];
-	endp = &fold[ sizeof( fold_t ) - 1 ];
+	p = &fold[0];
+	endp = &fold[sizeof(fold_t) - 1];
 
-	assert( p < endp );
+	assert(p < endp);
 	*p++ = ' ';
-	for ( cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++ ) {
+	for (cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++) {
 		*p = c;
 	}
-	assert( p < endp );
+	assert(p < endp);
 	*p++ = ' ';
-	assert( p < endp );
-	assert( p + infolen < endp );
-	strcpy( p, infostr );
+	assert(p < endp);
+	assert(p + infolen < endp);
+	strcpy(p, infostr);
 	p += infolen;
-	assert( p < endp );
+	assert(p < endp);
 	*p++ = ' ';
-	assert( p < endp );
-	for ( cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++ ) {
+	assert(p < endp);
+	for (cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++) {
 		*p = c;
 	}
-	assert( p <= endp );
+	assert(p <= endp);
 	*p = 0;
 }
diff --git a/common/mlog.h b/common/mlog.h
index 628dd28..f007761 100644
--- a/common/mlog.h
+++ b/common/mlog.h
@@ -60,27 +60,27 @@
 #define MLOG_SS_CNT	7		/* NOTE! bump this when adding ss */
 
 #define MLOG_SS_SHIFT	8
-#define MLOG_SS_MASK	( 0xff << MLOG_SS_SHIFT )
+#define MLOG_SS_MASK	(0xff << MLOG_SS_SHIFT)
 
-/* subsystem flags - NOTE! only one may be specified! use in mlog( first arg )
+/* subsystem flags - NOTE! only one may be specified! use in mlog(first arg)
  */
-#define MLOG_ALL	( MLOG_SS_GEN << MLOG_SS_SHIFT )
-#define MLOG_PROC	( MLOG_SS_PROC << MLOG_SS_SHIFT )
-#define MLOG_DRIVE	( MLOG_SS_DRIVE << MLOG_SS_SHIFT )
-#define MLOG_MEDIA	( MLOG_SS_MEDIA << MLOG_SS_SHIFT )
-#define MLOG_INV	( MLOG_SS_INV << MLOG_SS_SHIFT )
+#define MLOG_ALL	(MLOG_SS_GEN << MLOG_SS_SHIFT)
+#define MLOG_PROC	(MLOG_SS_PROC << MLOG_SS_SHIFT)
+#define MLOG_DRIVE	(MLOG_SS_DRIVE << MLOG_SS_SHIFT)
+#define MLOG_MEDIA	(MLOG_SS_MEDIA << MLOG_SS_SHIFT)
+#define MLOG_INV	(MLOG_SS_INV << MLOG_SS_SHIFT)
 #ifdef DUMP
-#define MLOG_INOMAP	( MLOG_SS_INOMAP << MLOG_SS_SHIFT )
+#define MLOG_INOMAP	(MLOG_SS_INOMAP << MLOG_SS_SHIFT)
 #endif /* DUMP */
 #ifdef RESTORE
-#define MLOG_TREE	( MLOG_SS_TREE << MLOG_SS_SHIFT )
+#define MLOG_TREE	(MLOG_SS_TREE << MLOG_SS_SHIFT)
 #endif /* RESTORE */
-#define MLOG_EXCLFILES	( MLOG_SS_EXCLFILES << MLOG_SS_SHIFT )
+#define MLOG_EXCLFILES	(MLOG_SS_EXCLFILES << MLOG_SS_SHIFT)
 
 /* mlog_level - set during initialization, exported to facilitate
  * message logging decisions. one per subsystem (see above)
  */
-extern int mlog_level_ss[ MLOG_SS_CNT ];
+extern int mlog_level_ss[MLOG_SS_CNT];
 
 /* made external so main.c sigint dialog can change
  */
@@ -90,43 +90,43 @@ extern int mlog_timestamp;
 
 /* mlog_ss_name - so main.c sigint dialog can allow changes
  */
-extern char *mlog_ss_names[ MLOG_SS_CNT ];
+extern char *mlog_ss_names[MLOG_SS_CNT];
 
 /* initializes the mlog abstraction. split into two phases to
  * unravel some initialization sequencing problems.
  */
-extern void mlog_init0( void );
-extern bool_t mlog_init1( int argc, char *argv[ ] );
-extern bool_t mlog_init2( void );
+extern void mlog_init0(void);
+extern bool_t mlog_init1(int argc, char *argv[]);
+extern bool_t mlog_init2(void);
 
 /* post-initialization, to tell mlog how many streams
  */
-extern void mlog_tell_streamcnt( size_t streamcnt );
+extern void mlog_tell_streamcnt(size_t streamcnt);
 
 /* override the -v option
  */
-void mlog_override_level( int levelarg );
+void mlog_override_level(int levelarg);
 
 /* vprintf-based message format
  */
-extern void mlog( int level, char *fmt, ... );
-extern void mlog_va( int levelarg, char *fmt, va_list args );
-#define mlog_exit( e, r ) _mlog_exit( __FILE__, __LINE__, (e), (r) )
-extern int  _mlog_exit( const char *file, int line, int exit_code, rv_t return_code );
-#define mlog_exit_hint( r ) _mlog_exit_hint( __FILE__, __LINE__, (r) )
-extern void _mlog_exit_hint( const char *file, int line, rv_t rv );
-extern rv_t mlog_get_hint( void );
-extern void mlog_exit_flush( void );
+extern void mlog(int level, char *fmt, ...);
+extern void mlog_va(int levelarg, char *fmt, va_list args);
+#define mlog_exit(e, r) _mlog_exit(__FILE__, __LINE__, (e), (r))
+extern int  _mlog_exit(const char *file, int line, int exit_code, rv_t return_code);
+#define mlog_exit_hint(r) _mlog_exit_hint(__FILE__, __LINE__, (r))
+extern void _mlog_exit_hint(const char *file, int line, rv_t rv);
+extern rv_t mlog_get_hint(void);
+extern void mlog_exit_flush(void);
 
 /* the following calls are exported ONLY to dlog.c!
  */
-extern void mlog_lock( void );
-extern void mlog_unlock( void );
+extern void mlog_lock(void);
+extern void mlog_unlock(void);
 
 /* fold_t - a character string made to look like a "fold here"
  */
 #define FOLD_LEN	79
-typedef char fold_t[ FOLD_LEN + 1 ];
-extern void fold_init( fold_t fold, char *infostr, char c );
+typedef char fold_t[FOLD_LEN + 1];
+extern void fold_init(fold_t fold, char *infostr, char c);
 
 #endif /* MLOG_H */
diff --git a/common/openutil.c b/common/openutil.c
index fcb52fc..6b7b1b6 100644
--- a/common/openutil.c
+++ b/common/openutil.c
@@ -32,15 +32,15 @@
 #include "mlog.h"
 
 char *
-open_pathalloc( char *dirname, char *basename, pid_t pid )
+open_pathalloc(char *dirname, char *basename, pid_t pid)
 {
 	size_t dirlen;
 	size_t pidlen;
 	size_t namelen;
 	char *namebuf;
 
-	if ( strcmp( dirname, "/" )) {
-		dirlen = strlen( dirname );
+	if (strcmp(dirname, "/")) {
+		dirlen = strlen(dirname);
 	} else {
 		dirlen = 0;
 		dirname = "";
@@ -54,111 +54,111 @@ open_pathalloc( char *dirname, char *basename, pid_t pid )
 	 * And if it ever became 64 bits,
 	 * 64 bits => trunc(log10(2^64))+1 = 20
          */
-  	if ( pid ) {
+  	if (pid) {
 		pidlen = 1 + 20;
   	} else {
   		pidlen = 0;
   	}
-	namelen = dirlen + 1 + strlen( basename ) + pidlen + 1;
-	namebuf = ( char * )calloc( 1, namelen );
-  	assert( namebuf );
+	namelen = dirlen + 1 + strlen(basename) + pidlen + 1;
+	namebuf = (char *)calloc(1, namelen);
+  	assert(namebuf);
 
-  	if ( pid ) {
-		( void )snprintf( namebuf, namelen, "%s/%s.%d", dirname, basename, pid );
+  	if (pid) {
+		(void )snprintf(namebuf, namelen, "%s/%s.%d", dirname, basename, pid);
   	} else {
-		( void )snprintf( namebuf, namelen, "%s/%s", dirname, basename );
+		(void )snprintf(namebuf, namelen, "%s/%s", dirname, basename);
   	}
 
   	return namebuf;
 }
 
 int
-open_trwp( char *pathname )
+open_trwp(char *pathname)
 {
 	int fd;
 
-	fd = open( pathname, O_CREAT | O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL,
+	fd = open(pathname, O_CREAT | O_TRUNC | O_RDWR, S_IRUSR | S_IWUSR);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL,
 		      _("could not create %s: %s\n"),
 		      pathname,
-		      strerror( errno ));
+		      strerror(errno));
 	}
 
 	return fd;
 }
 
 int
-open_erwp( char *pathname )
+open_erwp(char *pathname)
 {
 	int fd;
 
-	fd = open( pathname, O_EXCL | O_CREAT | O_RDWR, S_IRUSR | S_IWUSR );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL,
+	fd = open(pathname, O_EXCL | O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL,
 		      _("could not create %s: %s\n"),
 		      pathname,
-		      strerror( errno ));
+		      strerror(errno));
 	}
 
 	return fd;
 }
 
 int
-open_rwp( char *pathname )
+open_rwp(char *pathname)
 {
 	int fd;
 
-	fd = open( pathname, O_RDWR );
+	fd = open(pathname, O_RDWR);
 
 	return fd;
 }
 
 int
-mkdir_tp( char *pathname )
+mkdir_tp(char *pathname)
 {
 	int rval;
 
-	rval = mkdir( pathname, S_IRWXU );
+	rval = mkdir(pathname, S_IRWXU);
 
 	return rval;
 }
 
 int
-open_trwdb( char *dirname, char *basename, pid_t pid )
+open_trwdb(char *dirname, char *basename, pid_t pid)
 {
 	char *pathname;
 	int fd;
 
-	pathname = open_pathalloc( dirname, basename, pid );
-	fd = open_trwp( pathname );
-	free( ( void * )pathname );
+	pathname = open_pathalloc(dirname, basename, pid);
+	fd = open_trwp(pathname);
+	free((void *)pathname);
 
 	return fd;
 }
 
 int
-open_erwdb( char *dirname, char *basename, pid_t pid )
+open_erwdb(char *dirname, char *basename, pid_t pid)
 {
 	char *pathname;
 	int fd;
 
-	pathname = open_pathalloc( dirname, basename, pid );
-	fd = open_erwp( pathname );
-	free( ( void * )pathname );
+	pathname = open_pathalloc(dirname, basename, pid);
+	fd = open_erwp(pathname);
+	free((void *)pathname);
 
 	return fd;
 }
 
 int
-open_rwdb( char *dirname, char *basename, pid_t pid )
+open_rwdb(char *dirname, char *basename, pid_t pid)
 {
 	char *pathname;
 	int fd;
 
-	pathname = open_pathalloc( dirname, basename, pid );
-	fd = open_rwp( pathname );
-	free( ( void * )pathname );
+	pathname = open_pathalloc(dirname, basename, pid);
+	fd = open_rwp(pathname);
+	free((void *)pathname);
 
 	return fd;
 }
diff --git a/common/openutil.h b/common/openutil.h
index 587462c..0e418d4 100644
--- a/common/openutil.h
+++ b/common/openutil.h
@@ -28,35 +28,35 @@
  * representation of the pid will be appended to the pathname, beginning
  * with a '.'.
  */
-extern char *open_pathalloc( char *dirname, char *basename, pid_t pid );
+extern char *open_pathalloc(char *dirname, char *basename, pid_t pid);
 
 /* create the specified file, creating or truncating as necessary,
  * with read and write permissions, given a directory and base.
- * return the file descriptor, or -1 with errno set. uses mlog( MLOG_NORMAL...
+ * return the file descriptor, or -1 with errno set. uses mlog(MLOG_NORMAL...
  * if the creation fails.
  */
-extern int open_trwdb( char *dirname, char *basename, pid_t pid );
-extern int open_trwp( char *pathname );
+extern int open_trwdb(char *dirname, char *basename, pid_t pid);
+extern int open_trwp(char *pathname);
 
 
 /* open the specified file, with read and write permissions, given a
  * directory and base.* return the file descriptor, or -1 with errno set.
- * uses mlog( MLOG_NORMAL... if the open fails.
+ * uses mlog(MLOG_NORMAL... if the open fails.
  */
-extern int open_rwdb( char *dirname, char *basename, pid_t pid );
-extern int open_rwp( char *pathname );
+extern int open_rwdb(char *dirname, char *basename, pid_t pid);
+extern int open_rwp(char *pathname);
 
 
 /* create and open the specified file, failing if already exists
  */
-extern int open_erwp( char *pathname );
-extern int open_erwdb( char *dirname, char *basename, pid_t pid );
+extern int open_erwp(char *pathname);
+extern int open_erwdb(char *dirname, char *basename, pid_t pid);
 
 
 /* create the specified directory, guaranteed to be initially empty. returns
- * 0 on success, -1 if trouble. uses mlog( MLOG_NORMAL... if the creation fails.
+ * 0 on success, -1 if trouble. uses mlog(MLOG_NORMAL... if the creation fails.
  */
-extern int mkdir_tp( char *pathname );
+extern int mkdir_tp(char *pathname);
 
 
 #endif /* UTIL_H */
diff --git a/common/path.c b/common/path.c
index b234de1..fb1fcf0 100644
--- a/common/path.c
+++ b/common/path.c
@@ -33,143 +33,143 @@ struct pem {
 
 typedef struct pem pem_t;
 
-static pem_t * pem_alloc( char *path );
-static void pem_free( pem_t *pemp );
-static char * pem_next( pem_t *pemp );
+static pem_t * pem_alloc(char *path);
+static void pem_free(pem_t *pemp);
+static char * pem_next(pem_t *pemp);
 
 #define PAMAX	1024
 
 struct pa {
-	char *pa_array[ PAMAX ];
+	char *pa_array[PAMAX];
 	int pa_cnt;
 };
 
 typedef struct pa pa_t;
 
-static pa_t * pa_alloc( void );
-static void pa_free( pa_t *pap );
-static void pa_append( pa_t *pap, char *pep );
-static int pa_peel( pa_t *pap );
-static char * pa_gen( pa_t *pap );
+static pa_t * pa_alloc(void);
+static void pa_free(pa_t *pap);
+static void pa_append(pa_t *pap, char *pep);
+static int pa_peel(pa_t *pap);
+static char * pa_gen(pa_t *pap);
 
 char *
-path_diff( char *path, char *base )
+path_diff(char *path, char *base)
 {
 	char *diff;
 
-	assert( *base == '/' );
-	assert( *path == '/' );
+	assert(*base == '/');
+	assert(*path == '/');
 
-	if ( ! path_beginswith( path, base )) {
+	if (! path_beginswith(path, base)) {
 		return 0;
 	}
 
-	for ( ; *base && *path == *base ; path++, base++ )
+	for (; *base && *path == *base ; path++, base++)
 		;
 
-	if ( *path == 0 ) {
+	if (*path == 0) {
 		return 0;
 	}
 
-	if ( *path == '/' ) {
+	if (*path == '/') {
 		path++;
 	}
 
-	diff = ( char * )calloc( 1, strlen( path ) + 1 );
-	assert( diff );
-	strcpy( diff, path );
+	diff = (char *)calloc(1, strlen(path) + 1);
+	assert(diff);
+	strcpy(diff, path);
 
 	return diff;
 }
 
 int
-path_beginswith( char *path, char *base )
+path_beginswith(char *path, char *base)
 {
-	if ( ! base ) {
+	if (! base) {
 		return 0;
 	}
-	return ! strncmp( base, path, strlen( base ));
+	return ! strncmp(base, path, strlen(base));
 }
 
 char *
-path_reltoabs( char *dir, char *basedir )
+path_reltoabs(char *dir, char *basedir)
 {
 	char *absdir;
 
 	/* check if the path starts with a / or
-	 * is a remote path (i.e. contains  machine:/path/name ).
+	 * is a remote path (i.e. contains  machine:/path/name).
 	 */
-	if ( ( *dir != '/' ) && ( strchr(dir, ':') == 0 ) ) {
+	if ((*dir != '/') && (strchr(dir, ':') == 0)) {
 		char *absdir;
-		absdir = ( char * )malloc( strlen( basedir )
+		absdir = (char *)malloc(strlen(basedir)
 					   +
 					   1
 					   +
-					   strlen( dir )
+					   strlen(dir)
 					   +
-					   1 );
-		assert( absdir );
+					   1);
+		assert(absdir);
 
-		( void )sprintf( absdir, "%s/%s", basedir, dir );
+		(void )sprintf(absdir, "%s/%s", basedir, dir);
 
 		dir = absdir;
 	}
 
-	if ( strchr(dir, ':') == 0 ) {
-		absdir = path_normalize( dir );
+	if (strchr(dir, ':') == 0) {
+		absdir = path_normalize(dir);
 	} else {
-		absdir = ( char * )malloc( strlen( dir )  + 1);
-		( void )sprintf( absdir, "%s", dir);
+		absdir = (char *)malloc(strlen(dir)  + 1);
+		(void )sprintf(absdir, "%s", dir);
 	}
 
 	return absdir;
 }
 
 char *
-path_normalize( char *path )
+path_normalize(char *path)
 {
-	pem_t *pemp = pem_alloc( path );
-	pa_t *pap = pa_alloc( );
+	pem_t *pemp = pem_alloc(path);
+	pa_t *pap = pa_alloc();
 	char *pep;
 	char *npath;
 
-	assert( path[ 0 ] == '/' );
+	assert(path[0] == '/');
 
-	while ( ( pep = pem_next( pemp )) != 0 ) {
-		if ( ! strcmp( pep, "" )) {
-			free( ( void * )pep );
+	while ((pep = pem_next(pemp)) != 0) {
+		if (! strcmp(pep, "")) {
+			free((void *)pep);
 			continue;
 		}
-		if ( ! strcmp( pep, "." )) {
-			free( ( void * )pep );
+		if (! strcmp(pep, ".")) {
+			free((void *)pep);
 			continue;
 		}
-		if ( ! strcmp( pep, ".." )) {
+		if (! strcmp(pep, "..")) {
 			int ok;
-			free( ( void * )pep );
-			ok = pa_peel( pap );
-			if ( ! ok ) {
-				pa_free( pap );
-				pem_free( pemp );
+			free((void *)pep);
+			ok = pa_peel(pap);
+			if (! ok) {
+				pa_free(pap);
+				pem_free(pemp);
 				return 0;
 			}
 			continue;
 		}
-		pa_append( pap, pep );
+		pa_append(pap, pep);
 	}
 
-	npath = pa_gen( pap );
-	pa_free( pap );
-	pem_free( pemp );
+	npath = pa_gen(pap);
+	pa_free(pap);
+	pem_free(pemp);
 
 	return npath;
 }
 
 static pem_t *
-pem_alloc( char *path )
+pem_alloc(char *path)
 {
-	pem_t *pemp = ( pem_t * )calloc( 1, sizeof( pem_t ));
-	assert( pemp );
+	pem_t *pemp = (pem_t *)calloc(1, sizeof(pem_t));
+	assert(pemp);
 	pemp->pem_head = path;
 	pemp->pem_next = pemp->pem_head;
 
@@ -177,13 +177,13 @@ pem_alloc( char *path )
 }
 
 static void
-pem_free( pem_t *pemp )
+pem_free(pem_t *pemp)
 {
-	free( ( void * )pemp );
+	free((void *)pemp);
 }
 
 static char *
-pem_next( pem_t *pemp )
+pem_next(pem_t *pemp)
 {
 	char *nextnext;
 	size_t len;
@@ -191,37 +191,37 @@ pem_next( pem_t *pemp )
 
 	/* no more left
 	 */
-	if ( *pemp->pem_next == 0 ) {
+	if (*pemp->pem_next == 0) {
 		return 0;
 	}
 
 	/* find the following slash
 	 */
-	nextnext = strchr( pemp->pem_next + 1, '/' );
+	nextnext = strchr(pemp->pem_next + 1, '/');
 
 	/* if end of string encountered, place next next at end of string
 	 */
-	if ( ! nextnext ) {
-		for ( nextnext = pemp->pem_next ; *nextnext ; nextnext++ )
+	if (! nextnext) {
+		for (nextnext = pemp->pem_next ; *nextnext ; nextnext++)
 			;
 	}
 
 	/* determine the length of the path element, sans the leading slash
 	 */
-	len = ( size_t )( nextnext - pemp->pem_next - 1 );
+	len = (size_t)(nextnext - pemp->pem_next - 1);
 
 	/* allocate buffer to hold the path element, incl null termination
 	 */
-	p = ( char * )malloc( len + 1 );
-	assert( p );
+	p = (char *)malloc(len + 1);
+	assert(p);
 
 	/* copy the path element into the buffer
 	 */
-	strncpy( p, pemp->pem_next + 1, len );
+	strncpy(p, pemp->pem_next + 1, len);
 
 	/* null-terminate
 	 */
-	p[ len ] = 0;
+	p[len] = 0;
 
 	/* update next
 	 */
@@ -233,54 +233,54 @@ pem_next( pem_t *pemp )
 }
 
 static pa_t *
-pa_alloc( void )
+pa_alloc(void)
 {
-	pa_t *pap = ( pa_t * )calloc( 1, sizeof( pa_t ));
-	assert( pap );
+	pa_t *pap = (pa_t *)calloc(1, sizeof(pa_t));
+	assert(pap);
 
 	return pap;
 }
 
 static void
-pa_free( pa_t *pap )
+pa_free(pa_t *pap)
 {
 	int i;
 
-	for ( i = 0 ; i < pap->pa_cnt ; i++ ) {
-		free( ( void * )pap->pa_array[ i ] );
+	for (i = 0 ; i < pap->pa_cnt ; i++) {
+		free((void *)pap->pa_array[i]);
 	}
 
-	free( ( void * )pap );
+	free((void *)pap);
 }
 
 static void
-pa_append( pa_t *pap, char *pep )
+pa_append(pa_t *pap, char *pep)
 {
-	assert( pap->pa_cnt < PAMAX );
+	assert(pap->pa_cnt < PAMAX);
 
-	pap->pa_array[ pap->pa_cnt ] = pep;
+	pap->pa_array[pap->pa_cnt] = pep;
 
 	pap->pa_cnt++;
 }
 
 static int
-pa_peel( pa_t *pap )
+pa_peel(pa_t *pap)
 {
-	if ( pap->pa_cnt <= 0 ) {
-		assert( pap->pa_cnt == 0 );
+	if (pap->pa_cnt <= 0) {
+		assert(pap->pa_cnt == 0);
 		return 0;
 	}
 
 	pap->pa_cnt--;
-	assert( pap->pa_array[ pap->pa_cnt ] );
-	free( ( void * )pap->pa_array[ pap->pa_cnt ] );
-	pap->pa_array[ pap->pa_cnt ] = 0;
+	assert(pap->pa_array[pap->pa_cnt]);
+	free((void *)pap->pa_array[pap->pa_cnt]);
+	pap->pa_array[pap->pa_cnt] = 0;
 
 	return 1;
 }
 
 static char *
-pa_gen( pa_t *pap )
+pa_gen(pa_t *pap)
 {
 	size_t sz;
 	int i;
@@ -288,23 +288,23 @@ pa_gen( pa_t *pap )
 	char *p;
 
 	sz = 0;
-	for ( i = 0 ; i < pap->pa_cnt ; i++ ) {
-		sz += strlen( pap->pa_array[ i ] ) + 1;
+	for (i = 0 ; i < pap->pa_cnt ; i++) {
+		sz += strlen(pap->pa_array[i]) + 1;
 	}
-	if ( i == 0 )
+	if (i == 0)
 		sz++;
 	sz++;
 
-	retp = ( char * )malloc( sz );
+	retp = (char *)malloc(sz);
 
-	if (  pap->pa_cnt <= 0 ) {
-		assert(  pap->pa_cnt == 0 );
-		sprintf( retp, "/" );
+	if (pap->pa_cnt <= 0) {
+		assert(pap->pa_cnt == 0);
+		sprintf(retp, "/");
 	} else {
 		p = retp;
-		for ( i = 0 ; i < pap->pa_cnt ; i++ ) {
-			sprintf( p, "/%s", pap->pa_array[ i ] );
-			p += strlen( p );
+		for (i = 0 ; i < pap->pa_cnt ; i++) {
+			sprintf(p, "/%s", pap->pa_array[ i]);
+			p += strlen(p);
 		}
 	}
 
diff --git a/common/path.h b/common/path.h
index 9092233..f05f5c7 100644
--- a/common/path.h
+++ b/common/path.h
@@ -20,9 +20,9 @@
 
 /* various pathname helpers
  */
-extern char * path_reltoabs( char *dir, char *basedir );
-extern char *path_normalize( char *path );
-extern char * path_diff( char *path, char *base );
-extern int path_beginswith( char *path, char *base );
+extern char * path_reltoabs(char *dir, char *basedir);
+extern char *path_normalize(char *path);
+extern char * path_diff(char *path, char *base);
+extern int path_beginswith(char *path, char *base);
 
 #endif /* PATH_H */
diff --git a/common/qlock.c b/common/qlock.c
index 1db461d..ae36817 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -43,7 +43,7 @@ typedef size_t ordmap_t;
 	 * been allocated.
 	 */
 
-#define ORDMAX					( 8 * sizeof( ordmap_t ))
+#define ORDMAX					(8 * sizeof(ordmap_t))
 	/* ordinals must fit into a wordsize bitmap
 	 */
 
@@ -55,53 +55,53 @@ static __thread ordmap_t thread_ordmap;
 	/* holds the ordmap for each thread
 	 */
 
-#define QLOCK_ORDMAP_SET( ordmap, ord )	( ordmap |= 1U << ord )
+#define QLOCK_ORDMAP_SET(ordmap, ord)	(ordmap |= 1U << ord)
 	/* sets the ordinal bit in an ordmap
 	 */
 
-#define QLOCK_ORDMAP_CLR( ordmap, ord )	( ordmap &= ~( 1U << ord ))
+#define QLOCK_ORDMAP_CLR(ordmap, ord)	(ordmap &= ~(1U << ord))
 	/* clears the ordinal bit in an ordmap
 	 */
 
-#define QLOCK_ORDMAP_GET( ordmap, ord )	( ordmap & ( 1U << ord ))
+#define QLOCK_ORDMAP_GET(ordmap, ord)	(ordmap & (1U << ord))
 	/* checks if ordinal set in ordmap
 	 */
 
-#define QLOCK_ORDMAP_CHK( ordmap, ord )	( ordmap & (( 1U << ord ) - 1U ))
+#define QLOCK_ORDMAP_CHK(ordmap, ord)	(ordmap & ((1U << ord) - 1U))
 	/* checks if any bits less than ord are set in the ordmap
 	 */
 
 
 qlockh_t
-qlock_alloc( ix_t ord )
+qlock_alloc(ix_t ord)
 {
 	qlock_t *qlockp;
 
 	/* verify the ordinal is not already taken, and mark as taken
 	 */
-	assert( ! QLOCK_ORDMAP_GET( qlock_ordalloced, ord ));
-	QLOCK_ORDMAP_SET( qlock_ordalloced, ord );
+	assert(! QLOCK_ORDMAP_GET(qlock_ordalloced, ord));
+	QLOCK_ORDMAP_SET(qlock_ordalloced, ord);
 
 	/* allocate lock memory
 	 */
-	qlockp = ( qlock_t * )calloc( 1, sizeof( qlock_t ));
-	assert( qlockp );
+	qlockp = (qlock_t *)calloc(1, sizeof(qlock_t));
+	assert(qlockp);
 
 	/* initialize the mutex
 	 */
-	pthread_mutex_init( &qlockp->ql_mutex, NULL );
+	pthread_mutex_init(&qlockp->ql_mutex, NULL);
 
 	/* assign the ordinal position
 	 */
 	qlockp->ql_ord = ord;
 
-	return ( qlockh_t )qlockp;
+	return (qlockh_t)qlockp;
 }
 
 void
-qlock_lock( qlockh_t qlockh )
+qlock_lock(qlockh_t qlockh)
 {
-	qlock_t *qlockp = ( qlock_t * )qlockh;
+	qlock_t *qlockp = (qlock_t *)qlockh;
 	pthread_t tid;
 	/* REFERENCED */
 	int rval;
@@ -112,138 +112,138 @@ qlock_lock( qlockh_t qlockh )
 
 	/* assert that this lock not already held by this thread
 	 */
-	if ( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
+	if (QLOCK_ORDMAP_GET(thread_ordmap, qlockp->ql_ord)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
 		      _("lock already held: tid %lu ord %d map %x\n"),
 		      tid,
 		      qlockp->ql_ord,
-		      thread_ordmap );
+		      thread_ordmap);
 	}
-	assert( ! QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
+	assert(! QLOCK_ORDMAP_GET(thread_ordmap, qlockp->ql_ord));
 
 	/* assert that no locks with a lesser ordinal are held by this thread
 	 */
-	if ( QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord )) {
-		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
+	if (QLOCK_ORDMAP_CHK(thread_ordmap, qlockp->ql_ord)) {
+		mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
 		      _("lock ordinal violation: tid %lu ord %d map %x\n"),
 		      tid,
 		      qlockp->ql_ord,
-		      thread_ordmap );
+		      thread_ordmap);
 	}
-	assert( ! QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord ));
+	assert(! QLOCK_ORDMAP_CHK(thread_ordmap, qlockp->ql_ord));
 
 	/* acquire the lock
 	 */
-	rval = pthread_mutex_lock( &qlockp->ql_mutex );
-	assert( !rval );
+	rval = pthread_mutex_lock(&qlockp->ql_mutex);
+	assert(!rval);
 
 	/* add ordinal to this threads ordmap
 	 */
-	QLOCK_ORDMAP_SET( thread_ordmap, qlockp->ql_ord );
+	QLOCK_ORDMAP_SET(thread_ordmap, qlockp->ql_ord);
 }
 
 void
-qlock_unlock( qlockh_t qlockh )
+qlock_unlock(qlockh_t qlockh)
 {
-	qlock_t *qlockp = ( qlock_t * )qlockh;
+	qlock_t *qlockp = (qlock_t *)qlockh;
 	/* REFERENCED */
 	int rval;
 
 	/* verify lock is held by this thread
 	 */
-	assert( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
+	assert(QLOCK_ORDMAP_GET(thread_ordmap, qlockp->ql_ord));
 
 	/* clear lock's ord from thread's ord map
 	 */
-	QLOCK_ORDMAP_CLR( thread_ordmap, qlockp->ql_ord );
+	QLOCK_ORDMAP_CLR(thread_ordmap, qlockp->ql_ord);
 
 	/* release the lock
 	 */
-	rval = pthread_mutex_unlock( &qlockp->ql_mutex );
-	assert( ! rval );
+	rval = pthread_mutex_unlock(&qlockp->ql_mutex);
+	assert(! rval);
 }
 
 qsemh_t
-qsem_alloc( ix_t cnt )
+qsem_alloc(ix_t cnt)
 {
 	sem_t *semp;
 	int rval;
 
 	/* allocate a semaphore
 	 */
-	semp = ( sem_t * )calloc( 1, sizeof( sem_t ));
-	assert( semp );
+	semp = (sem_t *)calloc(1, sizeof(sem_t));
+	assert(semp);
 
 	/* initialize the semaphore
 	 */
-	rval = sem_init( semp, 0, cnt );
-	assert( !rval );
+	rval = sem_init(semp, 0, cnt);
+	assert(!rval);
 
-	return ( qsemh_t )semp;
+	return (qsemh_t)semp;
 }
 
 void
-qsem_free( qsemh_t qsemh )
+qsem_free(qsemh_t qsemh)
 {
-	sem_t *semp = ( sem_t * )qsemh;
+	sem_t *semp = (sem_t *)qsemh;
 	int rval;
 
 	/* destroy the mutex and condition
 	 */
-	rval = sem_destroy( semp );
-	assert( !rval );
+	rval = sem_destroy(semp);
+	assert(!rval);
 
 	/* free the semaphore
 	 */
-	free( semp );
+	free(semp);
 }
 
 void
-qsemP( qsemh_t qsemh )
+qsemP(qsemh_t qsemh)
 {
-	sem_t *semp = ( sem_t * )qsemh;
+	sem_t *semp = (sem_t *)qsemh;
 	int rval;
 
 	/* "P" the semaphore
 	 */
-	rval = sem_wait( semp );
-	assert( !rval );
+	rval = sem_wait(semp);
+	assert(!rval);
 }
 
 void
-qsemV( qsemh_t qsemh )
+qsemV(qsemh_t qsemh)
 {
-	sem_t *semp = ( sem_t * )qsemh;
+	sem_t *semp = (sem_t *)qsemh;
 	int rval;
 
 	/* "V" the semaphore
 	 */
-	rval = sem_post( semp );
-	assert( !rval );
+	rval = sem_post(semp);
+	assert(!rval);
 }
 
 bool_t
-qsemPwouldblock( qsemh_t qsemh )
+qsemPwouldblock(qsemh_t qsemh)
 {
-	sem_t *semp = ( sem_t * )qsemh;
+	sem_t *semp = (sem_t *)qsemh;
 	int count;
 	int rval;
 
-	rval = sem_getvalue( semp, &count );
-	assert( !rval );
+	rval = sem_getvalue(semp, &count);
+	assert(!rval);
 
 	return count <= 0 ? BOOL_TRUE : BOOL_FALSE;
 }
 
 size_t
-qsemPavail( qsemh_t qsemh )
+qsemPavail(qsemh_t qsemh)
 {
-	sem_t *semp = ( sem_t * )qsemh;
+	sem_t *semp = (sem_t *)qsemh;
 	int count;
 	int rval;
 
-	rval = sem_getvalue( semp, &count );
-	assert( !rval );
+	rval = sem_getvalue(semp, &count);
+	assert(!rval);
 
 	return count < 0 ? 0 : count;
 }
diff --git a/common/qlock.h b/common/qlock.h
index 6c2dd18..52a8467 100644
--- a/common/qlock.h
+++ b/common/qlock.h
@@ -48,14 +48,14 @@ typedef void *qlockh_t;
 	/* opaque handle
 	 */
 
-extern qlockh_t qlock_alloc( ix_t ord );
+extern qlockh_t qlock_alloc(ix_t ord);
 	/* allocates a qlock with the specified ordinal. returns
 	 * NULL if lock can't be allocated.
 	 */
-extern void qlock_lock( qlockh_t qlockh );
+extern void qlock_lock(qlockh_t qlockh);
 	/* acquires the specified lock.
 	 */
-extern void qlock_unlock( qlockh_t qlockh );
+extern void qlock_unlock(qlockh_t qlockh);
 	/* releases the specified lock.
 	 */
 
@@ -64,23 +64,23 @@ typedef void *qsemh_t;
 	/* opaque handle
 	 */
 
-extern qsemh_t qsem_alloc( size_t cnt );
+extern qsemh_t qsem_alloc(size_t cnt);
 	/* allocates a counting semaphore initialized to the specified
 	 * count. returns a qsem handle
 	 */
-extern void qsem_free( qsemh_t qsemh );
+extern void qsem_free(qsemh_t qsemh);
 	/* frees the counting semaphore
 	 */
-extern void qsemP( qsemh_t qsemh );
+extern void qsemP(qsemh_t qsemh);
 	/* "P" (decrement) op
 	 */
-extern void qsemV( qsemh_t qsemh );
+extern void qsemV(qsemh_t qsemh);
 	/* "V" (increment) op
 	 */
-extern bool_t qsemPwouldblock( qsemh_t qsemh );
+extern bool_t qsemPwouldblock(qsemh_t qsemh);
 	/* returns true if a qsemP op would block
 	 */
-extern size_t qsemPavail( qsemh_t qsemh );
+extern size_t qsemPavail(qsemh_t qsemh);
 	/* number of resources available
 	 */
 
diff --git a/common/rec_hdr.h b/common/rec_hdr.h
index 1ab783c..a33c54e 100644
--- a/common/rec_hdr.h
+++ b/common/rec_hdr.h
@@ -51,7 +51,7 @@ struct rec_hdr {
 	int32_t capability;			/*   4  18 */
 		/* tape drive capabilities (from drive.h)
 		 */
-	char pad1[ 8 ];				/*   8  20 */
+	char pad1[8];				/*   8  20 */
 		/* padding
 		 */
 	off64_t file_offset;			/*   8  28 */
@@ -73,7 +73,7 @@ struct rec_hdr {
 
 	uuid_t dump_uuid;			/*  10  4c */
 
-	char pad2[ 0x1b4 ];			/* 1b4 200 */
+	char pad2[0x1b4];			/* 1b4 200 */
 };		/* pad to sizeof drive_hdr_t dh_specific */
 
 typedef struct rec_hdr rec_hdr_t;
diff --git a/common/ring.c b/common/ring.c
index 70c0f45..d1fbcb7 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -33,17 +33,17 @@
 #include "cldmgr.h"
 #include "ring.h"
 
-static int ring_slave_entry( void *ringctxp );
+static int ring_slave_entry(void *ringctxp);
 
 ring_t *
-ring_create( size_t ringlen,
+ring_create(size_t ringlen,
 	     size_t bufsz,
 	     bool_t pinpr,
 	     ix_t drive_index,
-	     int ( *readfunc )( void *clientctxp, char *bufp ),
-	     int ( *writefunc )( void *clientctxp, char *bufp ),
+	     int (*readfunc)(void *clientctxp, char *bufp),
+	     int (*writefunc)(void *clientctxp, char *bufp),
 	     void *clientctxp,
-	     int *rvalp )
+	     int *rvalp)
 {
 	bool_t ok;
 	ring_t *ringp;
@@ -55,8 +55,8 @@ ring_create( size_t ringlen,
 
 	/* allocate a ring descriptor
 	 */
-	ringp = ( ring_t * )calloc( 1, sizeof( ring_t ));
-	assert( ringp );
+	ringp = (ring_t *)calloc(1, sizeof(ring_t));
+	assert(ringp);
 	ringp->r_len = ringlen;
 	ringp->r_clientctxp = clientctxp;
 	ringp->r_readfunc = readfunc;
@@ -65,8 +65,8 @@ ring_create( size_t ringlen,
 	/* allocate counting semaphores for the ready and active queues,
 	 * and initialize the queue input and output indices.
 	 */
-	ringp->r_ready_qsemh = qsem_alloc( ringlen );
-	ringp->r_active_qsemh = qsem_alloc( 0 );
+	ringp->r_ready_qsemh = qsem_alloc(ringlen);
+	ringp->r_active_qsemh = qsem_alloc(0);
 	ringp->r_ready_in_ix = 0;
 	ringp->r_ready_out_ix = 0;
 	ringp->r_active_in_ix = 0;
@@ -85,87 +85,87 @@ ring_create( size_t ringlen,
 
 	/* allocate the ring messages
 	 */
-	ringp->r_msgp = ( ring_msg_t * )calloc( ringlen, sizeof( ring_msg_t ));
-	assert( ringp->r_msgp );
+	ringp->r_msgp = (ring_msg_t *)calloc(ringlen, sizeof(ring_msg_t));
+	assert(ringp->r_msgp);
 
 	/* allocate the buffers and initialize the messages
 	 */
-	for ( mix = 0 ; mix < ringlen ; mix++ ) {
-		ring_msg_t *msgp = &ringp->r_msgp[ mix ];
+	for (mix = 0 ; mix < ringlen ; mix++) {
+		ring_msg_t *msgp = &ringp->r_msgp[mix];
 		msgp->rm_mix = mix;
 		msgp->rm_op = RING_OP_NONE;
 		msgp->rm_stat = RING_STAT_INIT;
 		msgp->rm_user = 0;
 		msgp->rm_loc = RING_LOC_READY;
 
-		msgp->rm_bufp = ( char * )memalign( PGSZ, bufsz );
-		if ( ! msgp->rm_bufp ) {
+		msgp->rm_bufp = (char *)memalign(PGSZ, bufsz);
+		if (! msgp->rm_bufp) {
 			*rvalp = ENOMEM;
 			return 0;
 		}
-		if ( pinpr ) {
+		if (pinpr) {
 			int rval;
-			rval = mlock( ( void * )msgp->rm_bufp, bufsz );
-			if ( rval ) {
-				if ( errno == ENOMEM ) {
+			rval = mlock((void *)msgp->rm_bufp, bufsz);
+			if (rval) {
+				if (errno == ENOMEM) {
 					*rvalp = E2BIG;
 					return 0;
 				}
-				if ( errno == EPERM ) {
+				if (errno == EPERM) {
 					*rvalp = EPERM;
 					return 0;
 				}
-				assert( 0 );
+				assert(0);
 			}
 		}
 	}
 
 	/* kick off the slave thread
 	 */
-	ok = cldmgr_create( ring_slave_entry,
+	ok = cldmgr_create(ring_slave_entry,
 			    drive_index,
 			    _("slave"),
-			    ringp );
-	assert( ok );
+			    ringp);
+	assert(ok);
 
 	return ringp;
 }
 
 ring_msg_t *
-ring_get( ring_t *ringp )
+ring_get(ring_t *ringp)
 {
 	ring_msg_t *msgp;
 
 	/* assert client currently holds no messages
 	 */
-	assert( ringp->r_client_cnt == 0 );
+	assert(ringp->r_client_cnt == 0);
 
 	/* bump client message count and note if client needs to block
 	 */
 	ringp->r_client_msgcnt++;
-	if ( qsemPwouldblock( ringp->r_ready_qsemh )) {
+	if (qsemPwouldblock(ringp->r_ready_qsemh)) {
 		ringp->r_client_blkcnt++;
 	}
 
 	/* block until msg available on ready queue ("P")
 	 */
-	qsemP( ringp->r_ready_qsemh );
+	qsemP(ringp->r_ready_qsemh);
 
 	/* get a pointer to the next msg on the queue
 	 */
-	msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
+	msgp = &ringp->r_msgp[ringp->r_ready_out_ix];
 
 	/* assert the message is where it belongs
 	 */
-	assert( msgp->rm_loc == RING_LOC_READY );
+	assert(msgp->rm_loc == RING_LOC_READY);
 
 	/* verify the message index has not become corrupted
 	 */
-	assert( msgp->rm_mix == ringp->r_ready_out_ix );
+	assert(msgp->rm_mix == ringp->r_ready_out_ix);
 
 	/* bump the output index
 	 */
-	ringp->r_ready_out_ix = ( ringp->r_ready_out_ix + 1 )
+	ringp->r_ready_out_ix = (ringp->r_ready_out_ix + 1)
 				%
 				ringp->r_len;
 
@@ -183,19 +183,19 @@ ring_get( ring_t *ringp )
 }
 
 void
-ring_put( ring_t *ringp, ring_msg_t *msgp )
+ring_put(ring_t *ringp, ring_msg_t *msgp)
 {
 	/* assert the client holds exactly one message
 	 */
-	assert( ringp->r_client_cnt == 1 );
+	assert(ringp->r_client_cnt == 1);
 
 	/* assert the client is returning the right message
 	 */
-	assert( msgp->rm_mix == ringp->r_active_in_ix );
+	assert(msgp->rm_mix == ringp->r_active_in_ix);
 
 	/* assert the message is where it belongs
 	 */
-	assert( msgp->rm_loc == RING_LOC_CLIENT );
+	assert(msgp->rm_loc == RING_LOC_CLIENT);
 
 	/* decrement the count of messages held by the client
 	 */
@@ -207,150 +207,150 @@ ring_put( ring_t *ringp, ring_msg_t *msgp )
 
 	/* bump the active queue input ix
 	 */
-	ringp->r_active_in_ix = ( ringp->r_active_in_ix + 1 )
+	ringp->r_active_in_ix = (ringp->r_active_in_ix + 1)
 				%
 				ringp->r_len;
 
 	/* bump the semaphore for the active queue ("V")
 	 */
-	qsemV( ringp->r_active_qsemh );
+	qsemV(ringp->r_active_qsemh);
 }
 
 void
-ring_reset( ring_t *ringp, ring_msg_t *msgp )
+ring_reset(ring_t *ringp, ring_msg_t *msgp)
 {
 	size_t mix;
 
 	/* if the client is not holding a message, get the next message
 	 */
-	if ( ringp->r_client_cnt == 0 ) {
-		assert( ! msgp );
-		msgp = ring_get( ringp );
-		assert( msgp );
-		assert( ringp->r_client_cnt == 1 );
+	if (ringp->r_client_cnt == 0) {
+		assert(! msgp);
+		msgp = ring_get(ringp);
+		assert(msgp);
+		assert(ringp->r_client_cnt == 1);
 	} else {
-		assert( msgp );
-		assert( ringp->r_client_cnt == 1 );
+		assert(msgp);
+		assert(ringp->r_client_cnt == 1);
 	}
 
 	/* tell the slave to abort
 	 */
 	msgp->rm_op = RING_OP_RESET;
-	ring_put( ringp, msgp );
+	ring_put(ringp, msgp);
 
 	/* wait for the reset to be acknowledged
 	 */
-	assert( ringp->r_client_cnt == 0 );
+	assert(ringp->r_client_cnt == 0);
 	do {
 		/* pull a message from the ready queue
 		 */
-		qsemP( ringp->r_ready_qsemh );
-		msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
-		assert( msgp->rm_loc == RING_LOC_READY );
-		ringp->r_ready_out_ix = ( ringp->r_ready_out_ix + 1 )
+		qsemP(ringp->r_ready_qsemh);
+		msgp = &ringp->r_msgp[ringp->r_ready_out_ix];
+		assert(msgp->rm_loc == RING_LOC_READY);
+		ringp->r_ready_out_ix = (ringp->r_ready_out_ix + 1)
 					%
 					ringp->r_len;
 		ringp->r_client_cnt++;
-	} while ( msgp->rm_stat != RING_STAT_RESETACK );
-	assert( ringp->r_client_cnt == ringp->r_len );
+	} while (msgp->rm_stat != RING_STAT_RESETACK);
+	assert(ringp->r_client_cnt == ringp->r_len);
 
 	/* re-initialize the ring
 	 */
-	assert( qsemPavail( ringp->r_ready_qsemh ) == 0 );
-	assert( qsemPavail( ringp->r_active_qsemh ) == 0 );
+	assert(qsemPavail(ringp->r_ready_qsemh) == 0);
+	assert(qsemPavail(ringp->r_active_qsemh) == 0);
 	ringp->r_ready_in_ix = 0;
 	ringp->r_ready_out_ix = 0;
 	ringp->r_active_in_ix = 0;
 	ringp->r_active_out_ix = 0;
 	ringp->r_client_cnt = 0;
 	ringp->r_slave_cnt = 0;
-	for ( mix = 0 ; mix < ringp->r_len ; mix++ ) {
-		ring_msg_t *msgp = &ringp->r_msgp[ mix ];
+	for (mix = 0 ; mix < ringp->r_len ; mix++) {
+		ring_msg_t *msgp = &ringp->r_msgp[mix];
 		msgp->rm_mix = mix;
 		msgp->rm_op = RING_OP_NONE;
 		msgp->rm_stat = RING_STAT_INIT;
 		msgp->rm_user = 0;
 		msgp->rm_loc = RING_LOC_READY;
-		qsemV( ringp->r_ready_qsemh );
+		qsemV(ringp->r_ready_qsemh);
 	}
-	assert( qsemPavail( ringp->r_ready_qsemh ) == ringp->r_len );
-	assert( qsemPavail( ringp->r_active_qsemh ) == 0 );
+	assert(qsemPavail(ringp->r_ready_qsemh) == ringp->r_len);
+	assert(qsemPavail(ringp->r_active_qsemh) == 0);
 }
 
 void
-ring_destroy( ring_t *ringp )
+ring_destroy(ring_t *ringp)
 {
 	ring_msg_t *msgp;
 
 	/* the client must not be holding a message
 	 */
-	assert( ringp->r_client_cnt == 0 );
+	assert(ringp->r_client_cnt == 0);
 
 	/* get a message
 	 */
-	msgp = ring_get( ringp );
+	msgp = ring_get(ringp);
 
 	/* tell the slave to exit
 	 */
 	msgp->rm_op = RING_OP_DIE;
-	ring_put( ringp, msgp );
+	ring_put(ringp, msgp);
 
 	/* wait for the die to be acknowledged
 	 */
 	do {
 		/* pull a message from the ready queue
 		 */
-		qsemP( ringp->r_ready_qsemh );
-		msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
-		assert( msgp->rm_loc == RING_LOC_READY );
-		ringp->r_ready_out_ix = ( ringp->r_ready_out_ix + 1 )
+		qsemP(ringp->r_ready_qsemh);
+		msgp = &ringp->r_msgp[ringp->r_ready_out_ix];
+		assert(msgp->rm_loc == RING_LOC_READY);
+		ringp->r_ready_out_ix = (ringp->r_ready_out_ix + 1)
 					%
 					ringp->r_len;
-	} while ( msgp->rm_stat != RING_STAT_DIEACK );
+	} while (msgp->rm_stat != RING_STAT_DIEACK);
 
 	/* the slave is dead.
 	 */
-	qsem_free( ringp->r_ready_qsemh );
-	qsem_free( ringp->r_active_qsemh );
-	free( ( void * )ringp );
+	qsem_free(ringp->r_ready_qsemh);
+	qsem_free(ringp->r_active_qsemh);
+	free((void *)ringp);
 }
 
 
 static ring_msg_t *
-ring_slave_get( ring_t *ringp )
+ring_slave_get(ring_t *ringp)
 {
 	ring_msg_t *msgp;
 
 	/* assert slave currently holds no messages
 	 */
-	assert( ringp->r_slave_cnt == 0 );
+	assert(ringp->r_slave_cnt == 0);
 
 	/* bump slave message count and note if slave needs to block
 	 */
 	ringp->r_slave_msgcnt++;
-	if ( qsemPwouldblock( ringp->r_active_qsemh )) {
+	if (qsemPwouldblock(ringp->r_active_qsemh)) {
 		ringp->r_slave_blkcnt++;
 	}
 
 	/* block until msg available on active queue ("P")
 	 */
-	qsemP( ringp->r_active_qsemh );
+	qsemP(ringp->r_active_qsemh);
 
 	/* get a pointer to the next msg on the queue
 	 */
-	msgp = &ringp->r_msgp[ ringp->r_active_out_ix ];
+	msgp = &ringp->r_msgp[ringp->r_active_out_ix];
 
 	/* assert the message is where it belongs
 	 */
-	assert( msgp->rm_loc == RING_LOC_ACTIVE );
+	assert(msgp->rm_loc == RING_LOC_ACTIVE);
 
 	/* verify the message index has not become corrupted
 	 */
-	assert( msgp->rm_mix == ringp->r_active_out_ix );
+	assert(msgp->rm_mix == ringp->r_active_out_ix);
 
 	/* bump the output index
 	 */
-	ringp->r_active_out_ix = ( ringp->r_active_out_ix + 1 )
+	ringp->r_active_out_ix = (ringp->r_active_out_ix + 1)
 				 %
 				 ringp->r_len;
 
@@ -368,19 +368,19 @@ ring_slave_get( ring_t *ringp )
 }
 
 static void
-ring_slave_put( ring_t *ringp, ring_msg_t *msgp )
+ring_slave_put(ring_t *ringp, ring_msg_t *msgp)
 {
 	/* assert the slave holds exactly one message
 	 */
-	assert( ringp->r_slave_cnt == 1 );
+	assert(ringp->r_slave_cnt == 1);
 
 	/* assert the slave is returning the right message
 	 */
-	assert( msgp->rm_mix == ringp->r_ready_in_ix );
+	assert(msgp->rm_mix == ringp->r_ready_in_ix);
 
 	/* assert the message is where it belongs
 	 */
-	assert( msgp->rm_loc == RING_LOC_SLAVE );
+	assert(msgp->rm_loc == RING_LOC_SLAVE);
 
 	/* decrement the count of messages held by the slave
 	 */
@@ -392,56 +392,56 @@ ring_slave_put( ring_t *ringp, ring_msg_t *msgp )
 
 	/* bump the ready queue input ix
 	 */
-	ringp->r_ready_in_ix = ( ringp->r_ready_in_ix + 1 )
+	ringp->r_ready_in_ix = (ringp->r_ready_in_ix + 1)
 			       %
 			       ringp->r_len;
 
 	/* bump the semaphore for the ready queue ("V")
 	 */
-	qsemV( ringp->r_ready_qsemh );
+	qsemV(ringp->r_ready_qsemh);
 }
 
 static int
-ring_slave_entry( void *ringctxp )
+ring_slave_entry(void *ringctxp)
 {
 	sigset_t blocked_set;
-	ring_t *ringp = ( ring_t * )ringctxp;
+	ring_t *ringp = (ring_t *)ringctxp;
 	enum { LOOPMODE_NORMAL, LOOPMODE_IGNORE, LOOPMODE_DIE } loopmode;
 
 	/* block signals, let the main thread handle them
 	 */
-	sigemptyset( &blocked_set );
-	sigaddset( &blocked_set, SIGINT );
-	sigaddset( &blocked_set, SIGHUP );
-	sigaddset( &blocked_set, SIGTERM );
-	sigaddset( &blocked_set, SIGQUIT );
-	sigaddset( &blocked_set, SIGALRM );
-	pthread_sigmask( SIG_SETMASK, &blocked_set, NULL );
+	sigemptyset(&blocked_set);
+	sigaddset(&blocked_set, SIGINT);
+	sigaddset(&blocked_set, SIGHUP);
+	sigaddset(&blocked_set, SIGTERM);
+	sigaddset(&blocked_set, SIGQUIT);
+	sigaddset(&blocked_set, SIGALRM);
+	pthread_sigmask(SIG_SETMASK, &blocked_set, NULL);
 
 	/* loop reading and precessing messages until told to die
 	 */
-	for ( loopmode = LOOPMODE_NORMAL ; loopmode != LOOPMODE_DIE ; ) {
+	for (loopmode = LOOPMODE_NORMAL ; loopmode != LOOPMODE_DIE ;) {
 		ring_msg_t *msgp;
 		int rval;
 
-		msgp = ring_slave_get( ringp );
+		msgp = ring_slave_get(ringp);
 		msgp->rm_rval = 0;
 
-		switch( msgp->rm_op ) {
+		switch(msgp->rm_op) {
 		case RING_OP_READ:
-			if ( loopmode == LOOPMODE_IGNORE ) {
+			if (loopmode == LOOPMODE_IGNORE) {
 				msgp->rm_stat = RING_STAT_IGNORE;
 				break;
 			}
-			if ( ! ringp->r_first_io_time ) {
-				ringp->r_first_io_time = time( 0 );
-				assert( ringp->r_first_io_time );
+			if (! ringp->r_first_io_time) {
+				ringp->r_first_io_time = time(0);
+				assert(ringp->r_first_io_time);
 			}
-			rval = ( ringp->r_readfunc )( ringp->r_clientctxp,
-						      msgp->rm_bufp );
+			rval = (ringp->r_readfunc)(ringp->r_clientctxp,
+						      msgp->rm_bufp);
 			msgp->rm_rval = rval;
 			ringp->r_all_io_cnt++;
-			if ( msgp->rm_rval == 0 ) {
+			if (msgp->rm_rval == 0) {
 				msgp->rm_stat = RING_STAT_OK;
 			} else {
 				msgp->rm_stat = RING_STAT_ERROR;
@@ -449,19 +449,19 @@ ring_slave_entry( void *ringctxp )
 			}
 			break;
 		case RING_OP_WRITE:
-			if ( loopmode == LOOPMODE_IGNORE ) {
+			if (loopmode == LOOPMODE_IGNORE) {
 				msgp->rm_stat = RING_STAT_IGNORE;
 				break;
 			}
-			if ( ! ringp->r_first_io_time ) {
-				ringp->r_first_io_time = time( 0 );
-				assert( ringp->r_first_io_time );
+			if (! ringp->r_first_io_time) {
+				ringp->r_first_io_time = time(0);
+				assert(ringp->r_first_io_time);
 			}
-			rval = ( ringp->r_writefunc )( ringp->r_clientctxp,
-						       msgp->rm_bufp );
+			rval = (ringp->r_writefunc)(ringp->r_clientctxp,
+						       msgp->rm_bufp);
 			msgp->rm_rval = rval;
 			ringp->r_all_io_cnt++;
-			if ( msgp->rm_rval == 0 ) {
+			if (msgp->rm_rval == 0) {
 				msgp->rm_stat = RING_STAT_OK;
 			} else {
 				msgp->rm_stat = RING_STAT_ERROR;
@@ -486,7 +486,7 @@ ring_slave_entry( void *ringctxp )
 			msgp->rm_stat = RING_STAT_IGNORE;
 			break;
 		}
-		ring_slave_put( ringp, msgp );
+		ring_slave_put(ringp, msgp);
 	}
 
 	return 0;
diff --git a/common/ring.h b/common/ring.h
index 6126b77..be4ae69 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -144,8 +144,8 @@ struct ring {
 	qsemh_t r_active_qsemh;
 	size_t r_client_cnt;
 	size_t r_slave_cnt;
-	int ( *r_readfunc )( void *contextp, char *bufp );
-	int ( *r_writefunc )( void *contextp, char *bufp );
+	int (*r_readfunc)(void *contextp, char *bufp);
+	int (*r_writefunc)(void *contextp, char *bufp);
 	void *r_clientctxp;
 };
 
@@ -164,34 +164,34 @@ typedef struct ring ring_t;
  * E2BIG - insufficient physical memory available for pinning;
  * EPERM - exceeds allowed amount of pinned down memory.
  */
-extern ring_t *ring_create( size_t ringlen,
+extern ring_t *ring_create(size_t ringlen,
 			    size_t bufsz,
 			    bool_t pinpr,
 			    ix_t drive_index,
-			    int ( * readfunc )( void *clientctxp, char *bufp ),
-			    int ( * writefunc )( void *clientctxp, char *bufp ),
+			    int (* readfunc)(void *clientctxp, char *bufp),
+			    int (* writefunc)(void *clientctxp, char *bufp),
 			    void *clientctxp,
-			    int *rvalp );
+			    int *rvalp);
 
 
 /* ring_get - get a message off the ready queue
  */
-extern ring_msg_t *ring_get( ring_t *ringp );
+extern ring_msg_t *ring_get(ring_t *ringp);
 
 
 /* ring_put - put a message on the active queue
  */
-extern void ring_put( ring_t *ringp, ring_msg_t *msgp );
+extern void ring_put(ring_t *ringp, ring_msg_t *msgp);
 
 
 /* ring_reset - re-initialize the ring, after the current I/O completes.
  * msgp must be NULL if the client is not currently holding a ring message.
  * otherwise it must point to that message.
  */
-extern void ring_reset( ring_t *ringp, ring_msg_t *msgp );
+extern void ring_reset(ring_t *ringp, ring_msg_t *msgp);
 
 /* ring_destroy - de-allocates ring
  */
-extern void ring_destroy( ring_t *ringp );
+extern void ring_destroy(ring_t *ringp);
 
 #endif /* RING_H */
diff --git a/common/stream.c b/common/stream.c
index eadaaea..64a112a 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -40,13 +40,13 @@ struct spm {
 };
 
 typedef struct spm spm_t;
-static spm_t spm[ STREAM_SIMMAX * 3 ];
+static spm_t spm[STREAM_SIMMAX * 3];
 static bool_t initialized = BOOL_FALSE;
 
 void
-stream_init( void )
+stream_init(void)
 {
-	( void )memset( ( void * )spm, 0, sizeof( spm ));
+	(void)memset((void *)spm, 0, sizeof(spm));
 	initialized = BOOL_TRUE;
 }
 
@@ -61,24 +61,24 @@ stream_init( void )
  */
 
 void
-stream_register( pthread_t tid, int streamix )
+stream_register(pthread_t tid, int streamix)
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
-	assert( streamix < STREAM_SIMMAX );
+	assert(streamix < STREAM_SIMMAX);
 
 	lock();
-	for ( ; p < ep ; p++ ) {
-		if ( p->s_state == S_FREE ) {
+	for (; p < ep ; p++) {
+		if (p->s_state == S_FREE) {
 			p->s_state = S_RUNNING;
 			break;
 		}
 	}
 	unlock();
-	assert( p < ep );
+	assert(p < ep);
 
-	if ( p >= ep ) return;
+	if (p >= ep) return;
 
 	p->s_tid = tid;
 	p->s_ix = streamix;
@@ -89,40 +89,40 @@ stream_register( pthread_t tid, int streamix )
 
 /* NOTE: lock() must be held when calling stream_dead() */
 void
-stream_dead( pthread_t tid )
+stream_dead(pthread_t tid)
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
-	for ( ; p < ep ; p++ )
-		if ( pthread_equal( p->s_tid, tid ) ) {
+	for (; p < ep ; p++)
+		if (pthread_equal(p->s_tid, tid)) {
 			p->s_state = S_ZOMBIE;
 			break;
 		}
-	assert( p < ep );
+	assert(p < ep);
 }
 
 void
-stream_free( pthread_t tid )
+stream_free(pthread_t tid)
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
 
 	lock();
-	for ( ; p < ep ; p++ ) {
-		if ( pthread_equal( p->s_tid, tid ) ) {
-			(void) memset( (void *) p, 0, sizeof(spm_t) );
+	for (; p < ep ; p++) {
+		if (pthread_equal(p->s_tid, tid)) {
+			(void) memset((void *) p, 0, sizeof(spm_t));
 			p->s_state = S_FREE;
 			break;
 		}
 	}
 	unlock();
-	assert( p < ep );
+	assert(p < ep);
 }
 
 int
-stream_find_all( stream_state_t states[], int nstates,
-		 pthread_t tids[], int ntids )
+stream_find_all(stream_state_t states[], int nstates,
+		 pthread_t tids[], int ntids)
 {
 	int i, count = 0;
 	spm_t *p = spm;
@@ -134,7 +134,7 @@ stream_find_all( stream_state_t states[], int nstates,
 
 	/* lock - make sure we get a consistent snapshot of the stream status */
 	lock();
-	for ( ; p < ep && count < ntids; p++ )
+	for (; p < ep && count < ntids; p++)
 		for (i = 0; i < nstates; i++)
 			if (p->s_state == states[i]) {
 				tids[count++] = p->s_tid;
@@ -145,7 +145,7 @@ stream_find_all( stream_state_t states[], int nstates,
 }
 
 static spm_t *
-stream_find( pthread_t tid, stream_state_t s[], int nstates )
+stream_find(pthread_t tid, stream_state_t s[], int nstates)
 {
 	int i;
 	spm_t *p = spm;
@@ -154,8 +154,8 @@ stream_find( pthread_t tid, stream_state_t s[], int nstates )
 	assert(nstates > 0);
 
 	/* note we don't lock the stream array in this function */
-	for ( ; p < ep ; p++ )
-		if ( pthread_equal( p->s_tid, tid ) ) {
+	for (; p < ep ; p++)
+		if (pthread_equal(p->s_tid, tid)) {
 			/* check state */
 			for (i = 0; i < nstates; i++)
 				if (p->s_state == s[i])
@@ -165,13 +165,13 @@ stream_find( pthread_t tid, stream_state_t s[], int nstates )
 #ifdef STREAM_DEBUG
 	{
 		static const char *state_strings[] = { "S_FREE", "S_RUNNING", "S_ZOMBIE" };
-		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
+		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
 		      "stream_find(): no stream with tid: %lu and state%s:",
-		      tid, nstates == 1 ? "" : "s" );
+		      tid, nstates == 1 ? "" : "s");
 		for (i = 0; i < nstates; i++)
-			mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
+			mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE,
 			      " %s", state_strings[s[i]]);
-		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE, "\n");
+		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK | MLOG_BARE, "\n");
 	}
 #endif /* STREAM_DEBUG */
 
@@ -185,12 +185,12 @@ stream_find( pthread_t tid, stream_state_t s[], int nstates )
  */
 
 int
-stream_getix( pthread_t tid )
+stream_getix(pthread_t tid)
 {
 	stream_state_t states[] = { S_RUNNING };
 	spm_t *p;
 	int ix;
-	p = stream_find( tid, states, N(states) );
+	p = stream_find(tid, states, N(states));
 	ix = p ? p->s_ix : -1;
 	return ix;
 }
@@ -208,8 +208,8 @@ stream_getix( pthread_t tid )
 	spm_t *p;							\
 	pthread_t mytid = pthread_self();				\
 									\
-	if ( !pthread_equal(mytid, (tid))) {				\
-		mlog( MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,		\
+	if (!pthread_equal(mytid, (tid))) {				\
+		mlog(MLOG_DEBUG | MLOG_ERROR | MLOG_NOLOCK,		\
 		      "stream_set_" #field_name "(): "			\
 		      "foreign stream (tid %lu) "			\
 		      "not permitted to update this stream (tid %lu)\n",\
@@ -218,28 +218,28 @@ stream_getix( pthread_t tid )
 	}								\
 									\
 	lock();								\
-	p = stream_find( (tid), states, N(states) );			\
+	p = stream_find((tid), states, N(states));			\
 	if (p) p->s_exit_ ## field_name = (value);			\
 	unlock();
 
-void stream_set_code( pthread_t tid, int exit_code )
+void stream_set_code(pthread_t tid, int exit_code)
 {
-	stream_set( code, tid, exit_code );
+	stream_set(code, tid, exit_code);
 }
 
-void stream_set_return( pthread_t tid, rv_t rv )
+void stream_set_return(pthread_t tid, rv_t rv)
 {
-	stream_set( return, tid, rv );
+	stream_set(return, tid, rv);
 }
 
-void stream_set_hint( pthread_t tid, rv_t rv )
+void stream_set_hint(pthread_t tid, rv_t rv)
 {
-	stream_set( hint, tid, rv );
+	stream_set(hint, tid, rv);
 }
 
 
 bool_t
-stream_get_exit_status( pthread_t tid,
+stream_get_exit_status(pthread_t tid,
 			stream_state_t states[],
 			int nstates,
 			stream_state_t *state,
@@ -252,7 +252,7 @@ stream_get_exit_status( pthread_t tid,
 	spm_t *p;
 
 	lock();
-	p = stream_find( tid, states, nstates );
+	p = stream_find(tid, states, nstates);
 	if (! p) goto unlock;
 
 	if (state) *state = p->s_state;
@@ -268,7 +268,7 @@ stream_get_exit_status( pthread_t tid,
 }
 
 size_t
-stream_cnt( void )
+stream_cnt(void)
 {
 	spm_t *p = spm;
 	spm_t *ep = spm + N(spm);
@@ -276,19 +276,19 @@ stream_cnt( void )
 	size_t ixcnt;
 	size_t bitix;
 
-	assert( sizeof( ixmap ) * NBBY >= STREAM_SIMMAX );
+	assert(sizeof(ixmap) * NBBY >= STREAM_SIMMAX);
 
 	lock();
-	for ( ; p < ep ; p++ ) {
-		if ( p->s_state == S_RUNNING ) {
-			ixmap |= ( size_t )1 << p->s_ix;
+	for (; p < ep ; p++) {
+		if (p->s_state == S_RUNNING) {
+			ixmap |= (size_t)1 << p->s_ix;
 		}
 	}
 	unlock();
 
 	ixcnt = 0;
-	for ( bitix = 0 ; bitix < STREAM_SIMMAX ; bitix++ ) {
-		if ( ixmap & ( ( size_t )1 << bitix )) {
+	for (bitix = 0 ; bitix < STREAM_SIMMAX ; bitix++) {
+		if (ixmap & ((size_t)1 << bitix)) {
 			ixcnt++;
 		}
 	}
diff --git a/common/stream.h b/common/stream.h
index a83a5a5..b3417fa 100644
--- a/common/stream.h
+++ b/common/stream.h
@@ -41,21 +41,21 @@
 
 typedef enum { S_FREE, S_RUNNING, S_ZOMBIE } stream_state_t;
 
-extern void stream_init( void );
-extern void stream_register( pthread_t tid, int streamix );
+extern void stream_init(void);
+extern void stream_register(pthread_t tid, int streamix);
 /* NOTE: lock() must be held when calling stream_dead */
-extern void stream_dead( pthread_t tid );
-extern void stream_free( pthread_t tid );
-extern int stream_find_all( stream_state_t states[],
+extern void stream_dead(pthread_t tid);
+extern void stream_free(pthread_t tid);
+extern int stream_find_all(stream_state_t states[],
 			    int nstates,
 			    pthread_t tids[],
-			    int ntids );
-extern int stream_getix( pthread_t tid );
-extern void stream_set_code( pthread_t tid, int code );
-extern void stream_set_return( pthread_t tid, rv_t rv );
-extern void stream_set_hint( pthread_t tid, rv_t rv );
-extern bool_t stream_exists( pthread_t tid );
-extern bool_t stream_get_exit_status( pthread_t tid,
+			    int ntids);
+extern int stream_getix(pthread_t tid);
+extern void stream_set_code(pthread_t tid, int code);
+extern void stream_set_return(pthread_t tid, rv_t rv);
+extern void stream_set_hint(pthread_t tid, rv_t rv);
+extern bool_t stream_exists(pthread_t tid);
+extern bool_t stream_get_exit_status(pthread_t tid,
 				      stream_state_t states[],
 				      int nstates,
 				      stream_state_t *state,
@@ -63,7 +63,7 @@ extern bool_t stream_get_exit_status( pthread_t tid,
 				      int *exit_code,
 				      rv_t *exit_return,
 				      rv_t *exit_hint);
-extern size_t stream_cnt( void );
+extern size_t stream_cnt(void);
 
 
 #endif /* STREAM_H */
diff --git a/common/timeutil.c b/common/timeutil.c
index 0e52968..a25b0c4 100644
--- a/common/timeutil.c
+++ b/common/timeutil.c
@@ -38,12 +38,12 @@ ctime32_r(const time32_t *timep, char *buf)
 }
 
 char *
-ctimennl( const time32_t *clockp )
+ctimennl(const time32_t *clockp)
 {
-	char *p = ctime32( clockp );
+	char *p = ctime32(clockp);
 
-	if ( p && strlen( p ) > 0 ) {
-		p[ strlen( p ) - 1 ] = 0;
+	if (p && strlen(p) > 0) {
+		p[strlen(p) - 1] = 0;
 	}
 
 	return p;
diff --git a/common/timeutil.h b/common/timeutil.h
index b200855..5b9567d 100644
--- a/common/timeutil.h
+++ b/common/timeutil.h
@@ -24,14 +24,14 @@
 
 /* ctime32 - takes a time32_t instead of a time_t
  */
-extern char *ctime32( const time32_t *timep );
+extern char *ctime32(const time32_t *timep);
 
 /* ctime32_r - takes a time32_t instead of a time_t
  */
-extern char *ctime32_r( const time32_t *timep, char *buf );
+extern char *ctime32_r(const time32_t *timep, char *buf);
 
 /* ctimennl - ctime(3C) with newline removed
  */
-extern char *ctimennl( const time32_t *clockp );
+extern char *ctimennl(const time32_t *clockp);
 
 #endif /* TIMEUTIL_H */
diff --git a/common/ts_mtio.h b/common/ts_mtio.h
index 92fd889..9e4ae4c 100644
--- a/common/ts_mtio.h
+++ b/common/ts_mtio.h
@@ -42,7 +42,7 @@ typedef unsigned int    minor_t;
  * #define MTSEEK	22	 Seek to the given block number.  Not all
  *				 drives support this option.  For drives
  *				 that support audio, the block number
- *				 actually becomes the program number ( 0
+ *				 actually becomes the program number (0
  *				 meaning leadin area, 0xfffffffe meaning
  *				 leadout, and other values (currently 1-
  *				 799 decimal) the program #).  For seeking
diff --git a/common/types.h b/common/types.h
index b619667..080cc1a 100644
--- a/common/types.h
+++ b/common/types.h
@@ -43,8 +43,8 @@
  * for now we will
  */
 #define PGSZLOG2	12
-#define PGSZ		( 1 << PGSZLOG2 )
-#define PGMASK		( PGSZ - 1 )
+#define PGSZ		(1 << PGSZLOG2)
+#define PGMASK		(PGSZ - 1)
 
 /* integers
  */
@@ -68,37 +68,37 @@ typedef uint64_t xfs_ino_t;
 #define NBBY		8
 #endif
 
-#define	MKMAX( t, s )	( ( t )						\
-			  ( ( ( 1ull					\
+#define	MKMAX(t, s)	((t)						\
+			  (((1ull					\
 			        <<					\
-			        ( ( unsigned long long )sizeof( t )	\
+			        ((unsigned long long)sizeof(t)	\
 				  *					\
-				  ( unsigned long long )NBBY		\
+				  (unsigned long long)NBBY		\
 			          -					\
-			          ( s + 1ull )))			\
+			          (s + 1ull)))			\
 			      -						\
-			      1ull )					\
+			      1ull)					\
 			    *						\
 			    2ull					\
 			    +						\
-			    1ull ))
-#define MKSMAX( t )	MKMAX( t, 1ull )
-#define MKUMAX( t )	MKMAX( t, 0ull )
-#define INT32MAX	MKSMAX( int32_t )
-#define UINT32MAX	MKUMAX( uint32_t )
-#define SIZE32MAX	MKUMAX( size32_t )
-#define INT64MAX	MKSMAX( int64_t )
-#define UINT64MAX	MKUMAX( uint64_t )
-#define SIZE64MAX	MKUMAX( size64_t )
-#define INO64MAX	MKUMAX( xfs_ino_t )
-#define OFF64MAX	MKSMAX( off64_t )
-#define INTGENMAX	MKSMAX( int )
-#define UINTGENMAX	MKUMAX( uint )
-#define OFFMAX		MKSMAX( off_t )
-#define SIZEMAX		MKUMAX( size_t )
-#define IXMAX		MKUMAX( size_t )
-#define INOMAX		MKUMAX( ino_t )
-#define TIMEMAX		MKSMAX( time32_t )
+			    1ull))
+#define MKSMAX(t)	MKMAX(t, 1ull)
+#define MKUMAX(t)	MKMAX(t, 0ull)
+#define INT32MAX	MKSMAX(int32_t)
+#define UINT32MAX	MKUMAX(uint32_t)
+#define SIZE32MAX	MKUMAX(size32_t)
+#define INT64MAX	MKSMAX(int64_t)
+#define UINT64MAX	MKUMAX(uint64_t)
+#define SIZE64MAX	MKUMAX(size64_t)
+#define INO64MAX	MKUMAX(xfs_ino_t)
+#define OFF64MAX	MKSMAX(off64_t)
+#define INTGENMAX	MKSMAX(int)
+#define UINTGENMAX	MKUMAX(uint)
+#define OFFMAX		MKSMAX(off_t)
+#define SIZEMAX		MKUMAX(size_t)
+#define IXMAX		MKUMAX(size_t)
+#define INOMAX		MKUMAX(ino_t)
+#define TIMEMAX		MKSMAX(time32_t)
 #define INT16MAX	0x7fff
 #define UINT16MAX	0xffff
 
@@ -107,8 +107,8 @@ typedef uint64_t xfs_ino_t;
 typedef int bool_t;
 #define BOOL_TRUE	1
 #define BOOL_FALSE	0
-#define BOOL_UNKNOWN	( -1 )
-#define BOOL_ERROR	( -2 )
+#define BOOL_UNKNOWN	(-1)
+#define BOOL_ERROR	(-2)
 
 /* useful return code scheme
  * NOTE: that there are macros and error messages in common/types.h that should
@@ -122,7 +122,7 @@ typedef enum { RV_OK,		/* mission accomplished */
 	       RV_EOM,		/* hit end of media object */
 	       RV_ERROR,	/* operator error or resource exhaustion */
 	       RV_DONE,		/* return early because someone else did work */
-	       RV_INTR,		/* cldmgr_stop_requested( ) */
+	       RV_INTR,		/* cldmgr_stop_requested() */
 	       RV_CORRUPT,	/* stopped because corrupt data encountered */
 	       RV_QUIT,		/* stop using resource */
 	       RV_DRIVE,	/* drive quit working */
diff --git a/common/util.c b/common/util.c
index 70b17eb..081a40f 100644
--- a/common/util.c
+++ b/common/util.c
@@ -38,31 +38,31 @@
 extern size_t pgsz;
 
 int
-write_buf( char *bufp,
+write_buf(char *bufp,
 	   size_t bufsz,
 	   void *contextp,
 	   gwbfp_t get_write_buf_funcp,
-	   wfp_t write_funcp )
+	   wfp_t write_funcp)
 {
 	char *mbufp;	/* buffer obtained from manager */
 	size_t mbufsz;/* size of buffer obtained from manager */
 
-	while ( bufsz ) {
+	while (bufsz) {
 		int rval;
 
-		assert( bufsz > 0 );
-		mbufp = ( *get_write_buf_funcp )( contextp, bufsz, &mbufsz );
-		assert( mbufsz <= bufsz );
-		if ( bufp ) {
-			(void)memcpy( ( void * )mbufp, ( void * )bufp, mbufsz );
+		assert(bufsz > 0);
+		mbufp = (*get_write_buf_funcp)(contextp, bufsz, &mbufsz);
+		assert(mbufsz <= bufsz);
+		if (bufp) {
+			(void)memcpy((void *)mbufp, (void *)bufp, mbufsz);
 		} else {
-			(void)memset( ( void * )mbufp, 0, mbufsz );
+			(void)memset((void *)mbufp, 0, mbufsz);
 		}
-		rval = ( * write_funcp )( contextp, mbufp, mbufsz );
-		if ( rval ) {
+		rval = (* write_funcp)(contextp, mbufp, mbufsz);
+		if (rval) {
 			return rval;
 		}
-		if ( bufp ) {
+		if (bufp) {
 			bufp += mbufsz;
 		}
 		bufsz -= mbufsz;
@@ -72,12 +72,12 @@ write_buf( char *bufp,
 }
 
 int
-read_buf( char *bufp,
+read_buf(char *bufp,
 	  size_t bufsz,
 	  void *contextp,
 	  rfp_t read_funcp,
 	  rrbfp_t return_read_buf_funcp,
-	  int *statp )
+	  int *statp)
 {
 	char *mbufp;		/* manager's buffer pointer */
 	size_t mbufsz;	/* size of manager's buffer */
@@ -85,37 +85,37 @@ read_buf( char *bufp,
 
 	nread = 0;
 	*statp = 0;
-	while ( bufsz ) {
-		mbufp = ( * read_funcp )( contextp, bufsz, &mbufsz, statp );
-		if ( *statp ) {
+	while (bufsz) {
+		mbufp = (* read_funcp)(contextp, bufsz, &mbufsz, statp);
+		if (*statp) {
 			break;
 		}
-		assert( mbufsz <= bufsz );
-		if ( bufp ) {
-			( void )memcpy( (void *)bufp, (void *)mbufp, mbufsz );
+		assert(mbufsz <= bufsz);
+		if (bufp) {
+			(void)memcpy((void *)bufp, (void *)mbufp, mbufsz);
 			bufp += mbufsz;
 		}
 		bufsz -= mbufsz;
-		nread += ( int )mbufsz;
-		( * return_read_buf_funcp )( contextp, mbufp, mbufsz );
+		nread += (int)mbufsz;
+		(* return_read_buf_funcp)(contextp, mbufp, mbufsz);
 	}
 
 	return nread;
 }
 
 char
-*strncpyterm( char *s1, char *s2, size_t n )
+*strncpyterm(char *s1, char *s2, size_t n)
 {
 	char *rval;
 
-	if ( n < 1 ) return 0;
-	rval = strncpy( s1, s2, n );
-	s1[ n - 1 ] = 0;
+	if (n < 1) return 0;
+	rval = strncpy(s1, s2, n);
+	s1[n - 1] = 0;
 	return rval;
 }
 
 int
-bigstat_iter( jdm_fshandle_t *fshandlep,
+bigstat_iter(jdm_fshandle_t *fshandlep,
 	      int fsfd,
 	      int selector,
 	      xfs_ino_t start_ino,
@@ -124,9 +124,9 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 	      bstat_seekfp_t seekfp,
 	      void * seek_arg1,
 	      int *statp,
-	      bool_t ( pfp )( int ),
+	      bool_t (pfp)(int),
 	      xfs_bstat_t *buf,
-	      size_t buflenin )
+	      size_t buflenin)
 {
 	__s32 buflenout;
 	xfs_ino_t lastino;
@@ -141,20 +141,20 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 	/* NOT COOL: open will affect root dir's access time
 	 */
 
-	mlog( MLOG_NITTY,
+	mlog(MLOG_NITTY,
 	      "bulkstat iteration initiated: start_ino == %llu\n",
-	      start_ino );
+	      start_ino);
 
 	/* quirk of the interface: I want to play in terms of the
 	 * ino to begin with, and ino 0 is not used. so, ...
 	 */
-	if ( start_ino > 0 ) {
+	if (start_ino > 0) {
 		lastino = start_ino - 1;
 	} else {
 		lastino = 0;
 	}
-	mlog( MLOG_NITTY + 1,
-	      "calling bulkstat\n" );
+	mlog(MLOG_NITTY + 1,
+	      "calling bulkstat\n");
 
 	bulkstatcnt = 0;
 	bulkreq.lastip = (__u64 *)&lastino;
@@ -165,101 +165,101 @@ bigstat_iter( jdm_fshandle_t *fshandlep,
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 
-		if ( buflenout == 0 ) {
-			mlog( MLOG_NITTY + 1,
+		if (buflenout == 0) {
+			mlog(MLOG_NITTY + 1,
 			      "bulkstat returns buflen %d\n",
-			      buflenout );
+			      buflenout);
 			return 0;
 		}
-		mlog( MLOG_NITTY + 1,
+		mlog(MLOG_NITTY + 1,
 		      "bulkstat returns buflen %d ino %llu\n",
 		      buflenout,
-		      buf->bs_ino );
-		for ( p = buf, endp = buf + buflenout ; p < endp ; p++ ) {
+		      buf->bs_ino);
+		for (p = buf, endp = buf + buflenout ; p < endp ; p++) {
 			int rval;
 
-			if ( p->bs_ino == 0 )
+			if (p->bs_ino == 0)
 				continue;
 
-			if ( !p->bs_nlink || !p->bs_mode ) {
+			if (!p->bs_nlink || !p->bs_mode) {
 				/* inode being modified, get synced data */
-				mlog( MLOG_NITTY + 1,
+				mlog(MLOG_NITTY + 1,
 				      "ino %llu needed second bulkstat\n",
-				      p->bs_ino );
+				      p->bs_ino);
 
-				if( bigstat_one( fsfd, p->bs_ino, p ) < 0 ) {
-				    mlog( MLOG_WARNING,
+				if(bigstat_one(fsfd, p->bs_ino, p) < 0) {
+				    mlog(MLOG_WARNING,
 					  _("failed to get bulkstat information for inode %llu\n"),
-					  p->bs_ino );
+					  p->bs_ino);
 				    continue;
 				}
-				if ( !p->bs_nlink || !p->bs_mode || !p->bs_ino ) {
-					mlog( MLOG_TRACE,
+				if (!p->bs_nlink || !p->bs_mode || !p->bs_ino) {
+					mlog(MLOG_TRACE,
 					      _("failed to get valid bulkstat information for inode %llu\n"),
-					      p->bs_ino );
+					      p->bs_ino);
 					continue;
 				}
 			}
 
-			if ( ( p->bs_mode & S_IFMT ) == S_IFDIR ) {
-				if ( ! ( selector & BIGSTAT_ITER_DIR )){
+			if ((p->bs_mode & S_IFMT) == S_IFDIR) {
+				if (! (selector & BIGSTAT_ITER_DIR)){
 					continue;
 				}
 			} else {
-				if ( ! ( selector & BIGSTAT_ITER_NONDIR )){
+				if (! (selector & BIGSTAT_ITER_NONDIR)){
 					continue;
 				}
 			}
-			rval = ( * fp )( cb_arg1, fshandlep, fsfd, p );
-			if ( rval ) {
+			rval = (* fp)(cb_arg1, fshandlep, fsfd, p);
+			if (rval) {
 				*statp = rval;
 				return 0;
 			}
-			if ( pfp ) ( pfp )( PREEMPT_PROGRESSONLY );
+			if (pfp) (pfp)(PREEMPT_PROGRESSONLY);
 		}
 
-		if ( pfp && (++bulkstatcnt % 10) == 0 &&
-		     ( pfp )( PREEMPT_FULL )) {
+		if (pfp && (++bulkstatcnt % 10) == 0 &&
+		     (pfp)(PREEMPT_FULL)) {
 			return EINTR;
 		}
 
 		if (seekfp) {
 			lastino = seekfp(seek_arg1, lastino);
 			if (lastino == INO64MAX) {
-				mlog( MLOG_DEBUG,
+				mlog(MLOG_DEBUG,
 				      "bulkstat seeked to EOS\n");
 				return 0;
 			}
 
-			mlog( MLOG_DEBUG,
+			mlog(MLOG_DEBUG,
 			      "bulkstat seeked to %llu\n", lastino);
 
 			lastino = (lastino > 0) ? lastino - 1 : 0;
 		}
 
-		mlog( MLOG_NITTY + 1,
-		      "calling bulkstat\n" );
+		mlog(MLOG_NITTY + 1,
+		      "calling bulkstat\n");
 	}
 
 	saved_errno = errno;
 
-	mlog( MLOG_NORMAL,
+	mlog(MLOG_NORMAL,
 	      _("syssgi( SGI_FS_BULKSTAT ) on fsroot failed: %s\n"),
-	      strerror( saved_errno ));
+	      strerror(saved_errno));
 
 	return saved_errno;
 }
 
 /* ARGSUSED */
 int
-bigstat_one( int fsfd,
+bigstat_one(int fsfd,
 	     xfs_ino_t ino,
-	     xfs_bstat_t *statp )
+	     xfs_bstat_t *statp)
 {
         xfs_fsop_bulkreq_t bulkreq;
 	int count = 0;
 
-	assert( ino > 0 );
+	assert(ino > 0);
         bulkreq.lastip = (__u64 *)&ino;
         bulkreq.icount = 1;
         bulkreq.ubuffer = statp;
@@ -271,12 +271,12 @@ bigstat_one( int fsfd,
  */
 #define INOGRPLEN	256
 int
-inogrp_iter( int fsfd,
-	     int ( * fp )( void *arg1,
+inogrp_iter(int fsfd,
+	     int (* fp)(void *arg1,
 				int fsfd,
-				xfs_inogrp_t *inogrp ),
+				xfs_inogrp_t *inogrp),
 	     void * arg1,
-	     int *statp )
+	     int *statp)
 {
 	xfs_ino_t lastino;
 	int inogrpcnt;
@@ -304,15 +304,15 @@ inogrp_iter( int fsfd,
 	while (!ioctl(fsfd, XFS_IOC_FSINUMBERS, &bulkreq)) {
 		xfs_inogrp_t *p, *endp;
 
-		if ( inogrpcnt == 0 ) {
+		if (inogrpcnt == 0) {
 			free(igrp);
 			return 0;
 		}
-		for ( p = igrp, endp = igrp + inogrpcnt ; p < endp ; p++ ) {
+		for (p = igrp, endp = igrp + inogrpcnt ; p < endp ; p++) {
 			int rval;
 
-			rval = ( * fp )( arg1, fsfd, p );
-			if ( rval ) {
+			rval = (* fp)(arg1, fsfd, p);
+			if (rval) {
 				*statp = rval;
 				free(igrp);
 				return 0;
@@ -337,18 +337,18 @@ inogrp_iter( int fsfd,
  * caller may supply a dirent buffer. if not, will malloc one
  */
 int
-diriter( jdm_fshandle_t *fshandlep,
+diriter(jdm_fshandle_t *fshandlep,
 	 int fsfd,
 	 xfs_bstat_t *statp,
-	 int ( *cbfp )( void *arg1,
+	 int (*cbfp)(void *arg1,
 			     jdm_fshandle_t *fshandlep,
 			     int fsfd,
 			     xfs_bstat_t *statp,
-			     char *namep ),
+			     char *namep),
 	 void *arg1,
 	 int *cbrvalp,
 	 char *usrgdp,
-	 size_t usrgdsz )
+	 size_t usrgdsz)
 {
 	size_t gdsz;
 	struct dirent *gdp;
@@ -357,105 +357,105 @@ diriter( jdm_fshandle_t *fshandlep,
 	int scrval;
 	int cbrval;
 
-	if ( usrgdp ) {
-		assert( usrgdsz >= sizeof( struct dirent ) );
+	if (usrgdp) {
+		assert(usrgdsz >= sizeof(struct dirent));
 		gdsz = usrgdsz;
-		gdp = ( struct dirent * )usrgdp;
+		gdp = (struct dirent *)usrgdp;
 	} else {
 		gdsz = pgsz;
-		gdp = ( struct dirent * )malloc( gdsz );
-		assert( gdp );
+		gdp = (struct dirent *)malloc(gdsz);
+		assert(gdp);
 	}
 
 	/* open the directory
 	 */
-	fd = jdm_open( fshandlep, statp, O_RDONLY );
-	if ( fd < 0 ) {
-		mlog( MLOG_NORMAL,
+	fd = jdm_open(fshandlep, statp, O_RDONLY);
+	if (fd < 0) {
+		mlog(MLOG_NORMAL,
 		      _("WARNING: unable to open directory ino %llu: %s\n"),
 		      statp->bs_ino,
-		      strerror( errno ));
+		      strerror(errno));
 		*cbrvalp = 0;
-		if ( ! usrgdp ) {
-			free( ( void * )gdp );
+		if (! usrgdp) {
+			free((void *)gdp);
 		}
 		return -1;
 	}
-	assert( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
+	assert((statp->bs_mode & S_IFMT) == S_IFDIR);
 
 	/* lots of buffering done here, to achieve OS-independence.
 	 * if proves to be to much overhead, can streamline.
 	 */
 	scrval = 0;
 	cbrval = 0;
-	for ( gdcnt = 1 ; ; gdcnt++ ) {
+	for (gdcnt = 1 ; ; gdcnt++) {
 		struct dirent *p;
 		int nread;
 		register size_t reclen;
 
-		assert( scrval == 0 );
-		assert( cbrval == 0 );
+		assert(scrval == 0);
+		assert(cbrval == 0);
 
-		nread = getdents_wrap( fd, (char *)gdp, gdsz );
+		nread = getdents_wrap(fd, (char *)gdp, gdsz);
 
 		/* negative count indicates something very bad happened;
 		 * try to gracefully end this dir.
 		 */
-		if ( nread < 0 ) {
-			mlog( MLOG_NORMAL,
+		if (nread < 0) {
+			mlog(MLOG_NORMAL,
 			      _("WARNING: unable to read dirents (%d) for "
 			      "directory ino %llu: %s\n"),
 			      gdcnt,
 			      statp->bs_ino,
-			      strerror( errno ));
+			      strerror(errno));
 			nread = 0; /* pretend we are done */
 		}
 
 		/* no more directory entries: break;
 		 */
-		if ( nread == 0 ) {
+		if (nread == 0) {
 			break;
 		}
 
 		/* translate and invoke cb each entry: skip "." and "..".
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
 			xfs_bstat_t statbuf;
-			assert( scrval == 0 );
-			assert( cbrval == 0 );
+			assert(scrval == 0);
+			assert(cbrval == 0);
 
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
 
 			/* use bigstat
 			 */
-			scrval = bigstat_one( fsfd,
+			scrval = bigstat_one(fsfd,
 					      p->d_ino,
-					      &statbuf );
-			if ( scrval ) {
-				mlog( MLOG_NORMAL,
+					      &statbuf);
+			if (scrval) {
+				mlog(MLOG_NORMAL,
 				      _("WARNING: could not stat "
 				      "dirent %s ino %llu: %s\n"),
 				      p->d_name,
-				      ( xfs_ino_t )p->d_ino,
-				      strerror( errno ));
+				      (xfs_ino_t)p->d_ino,
+				      strerror(errno));
 				scrval = 0;
 				continue;
 			}
@@ -464,45 +464,45 @@ diriter( jdm_fshandle_t *fshandlep,
 			 * occupied more than 32 bits, warn and skip.
 			 */
 #ifndef __USE_LARGEFILE64
-			if ( statbuf.bs_ino > ( xfs_ino_t )INOMAX ) {
-				mlog( MLOG_NORMAL,
+			if (statbuf.bs_ino > (xfs_ino_t)INOMAX) {
+				mlog(MLOG_NORMAL,
 				      _("WARNING: unable to process dirent %s: "
 				      "ino %llu too large\n"),
 				      p->d_name,
-				      ( xfs_ino_t )p->d_ino );
+				      (xfs_ino_t)p->d_ino);
 				continue;
 			}
 #endif
 
 			/* invoke the callback
 			 */
-			cbrval = ( * cbfp )( arg1,
+			cbrval = (* cbfp)(arg1,
 					     fshandlep,
 					     fsfd,
 					     &statbuf,
-					     p->d_name );
+					     p->d_name);
 
 			/* abort the iteration if the callback returns non-zero
 			 */
-			if ( cbrval ) {
+			if (cbrval) {
 				break;
 			}
 		}
 
-		if ( scrval || cbrval ) {
+		if (scrval || cbrval) {
 			break;
 		}
 	}
 
-	( void )close( fd );
-	if ( ! usrgdp ) {
-		free( ( void * )gdp );
+	(void)close(fd);
+	if (! usrgdp) {
+		free((void *)gdp);
 	}
 
-	if ( scrval ) {
+	if (scrval) {
 		*cbrvalp = 0;
 		return -1;
-	} else if ( cbrval ) {
+	} else if (cbrval) {
 		*cbrvalp = cbrval;
 		return 1;
 	} else {
@@ -512,7 +512,7 @@ diriter( jdm_fshandle_t *fshandlep,
 }
 
 int
-cvtnum( int blocksize, char *s )
+cvtnum(int blocksize, char *s)
 {
 	int i;
 	char *sp;
diff --git a/common/util.h b/common/util.h
index 07fdd36..ab43739 100644
--- a/common/util.h
+++ b/common/util.h
@@ -32,14 +32,14 @@
  *
  * if bufp is null, writes bufsz zeros.
  */
-typedef char * ( * gwbfp_t )( void *contextp, size_t wantedsz, size_t *szp);
-typedef int ( * wfp_t )( void *contextp, char *bufp, size_t bufsz );
+typedef char * (* gwbfp_t)(void *contextp, size_t wantedsz, size_t *szp);
+typedef int (* wfp_t)(void *contextp, char *bufp, size_t bufsz);
 
-extern int write_buf( char *bufp,
+extern int write_buf(char *bufp,
 			   size_t bufsz,
 			   void *contextp,
 			   gwbfp_t get_write_buf_funcp,
-			   wfp_t write_funcp );
+			   wfp_t write_funcp);
 
 
 /* read_buf - converts the normal manager read method into something simpler
@@ -56,21 +56,21 @@ extern int write_buf( char *bufp,
  * status of the first failure of the read funcp. if no read failures occur,
  * *statp will be zero.
  */
-typedef char * ( *rfp_t )( void *contextp, size_t wantedsz, size_t *szp, int *statp );
-typedef void ( * rrbfp_t )( void *contextp, char *bufp, size_t bufsz );
+typedef char * (*rfp_t)(void *contextp, size_t wantedsz, size_t *szp, int *statp);
+typedef void (* rrbfp_t)(void *contextp, char *bufp, size_t bufsz);
 
-extern int read_buf( char *bufp,
+extern int read_buf(char *bufp,
 			  size_t bufsz,
 			  void *contextp,
 			  rfp_t read_funcp,
 			  rrbfp_t return_read_buf_funcp,
-			  int *statp );
+			  int *statp);
 
 
 
 /* strncpyterm - like strncpy, but guarantees the destination is null-terminated
  */
-extern char *strncpyterm( char *s1, char *s2, size_t n );
+extern char *strncpyterm(char *s1, char *s2, size_t n);
 
 /* bigstat - efficient file status gatherer. presents an iterative
  * callback interface, invoking the caller's callback for each in-use
@@ -80,19 +80,19 @@ extern char *strncpyterm( char *s1, char *s2, size_t n );
  * stat is set to zero. return value set to errno if the system call fails,
  * or EINTR if optional pre-emption func returns TRUE.
  */
-#define BIGSTAT_ITER_DIR	( 1 << 0 )
-#define BIGSTAT_ITER_NONDIR	( 1 << 1 )
-#define BIGSTAT_ITER_ALL	( ~0 )
+#define BIGSTAT_ITER_DIR	(1 << 0)
+#define BIGSTAT_ITER_NONDIR	(1 << 1)
+#define BIGSTAT_ITER_ALL	(~0)
 
 typedef int (*bstat_cbfp_t)(void *arg1,
 				 jdm_fshandle_t *fshandlep,
 				 int fsfd,
-				 xfs_bstat_t *statp );
+				 xfs_bstat_t *statp);
 
 typedef xfs_ino_t (*bstat_seekfp_t)(void *arg1,
 				    xfs_ino_t lastino);
 
-extern int bigstat_iter( jdm_fshandle_t *fshandlep,
+extern int bigstat_iter(jdm_fshandle_t *fshandlep,
 			      int fsfd,
 			      int selector,
 			      xfs_ino_t start_ino,
@@ -101,20 +101,20 @@ extern int bigstat_iter( jdm_fshandle_t *fshandlep,
 			      bstat_seekfp_t seekfp,
 			      void * seek_arg1,
 			      int *statp,
-			      bool_t ( pfp )( int ), /* preemption chk func */
+			      bool_t (pfp)(int), /* preemption chk func */
 			      xfs_bstat_t *buf,
-			      size_t buflen );
+			      size_t buflen);
 
-extern int bigstat_one( int fsfd,
+extern int bigstat_one(int fsfd,
 			     xfs_ino_t ino,
-			     xfs_bstat_t *statp );
+			     xfs_bstat_t *statp);
 
-extern int inogrp_iter( int fsfd,
-			     int ( * fp )( void *arg1,
+extern int inogrp_iter(int fsfd,
+			     int (* fp)(void *arg1,
 				     		int fsfd,
-						xfs_inogrp_t *inogrp ),
+						xfs_inogrp_t *inogrp),
 			     void * arg1,
-			     int *statp );
+			     int *statp);
 
 /* calls the callback for every entry in the directory specified
  * by the stat buffer. supplies the callback with a file system
@@ -122,31 +122,31 @@ extern int inogrp_iter( int fsfd,
  *
  * NOTE: does NOT invoke callback for "." or ".."!
  *
- * caller may supply getdents buffer. size must be >= sizeof( dirent_t )
+ * caller may supply getdents buffer. size must be >= sizeof(dirent_t)
  * + MAXPATHLEN. if not supplied (usrgdp NULL), one will be malloc()ed.
  *
  * if the callback returns non-zero, returns 1 with cbrval set to the
  * callback's return value. if syscall fails, returns -1 with errno set.
  * otherwise returns 0.
  */
-extern int diriter( jdm_fshandle_t *fshandlep,
+extern int diriter(jdm_fshandle_t *fshandlep,
 			 int fsfd,
 			 xfs_bstat_t *statp,
-			 int ( *cbfp )( void *arg1,
+			 int (*cbfp)(void *arg1,
 					     jdm_fshandle_t *fshandlep,
 					     int fsfd,
 					     xfs_bstat_t *statp,
-					     char *namep ),
+					     char *namep),
 			 void *arg1,
 			 int *cbrvalp,
 			 char *usrgdp,
-			 size_t usrgdsz );
+			 size_t usrgdsz);
 
 
 
 /* macro to copy uuid structures
  */
-#define COPY_LABEL( lab1, lab2) ( bcopy( lab1, lab2, GLOBAL_HDR_STRING_SZ) )
+#define COPY_LABEL(lab1, lab2) (bcopy(lab1, lab2, GLOBAL_HDR_STRING_SZ))
 
 /*
  * Align pointer up to alignment
-- 
2.19.1
