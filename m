Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 06:46:59 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBBEkoqw009740
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 06:46:52 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBBBr0mM006630
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:53:14 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBBBnNaL005457
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:49:23 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kBBBnMP24421 for xfs@oss.sgi.com; Mon, 11 Dec 2006 20:49:22 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kBBBnLA14958 for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:49:21 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061211.205500.54600892 for <xfs@oss.sgi.com>
	; Mon, 11 Dec 2006 20:55:00 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 6F6F7AE4B0
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:48:30 +0900 (JST)
Subject: [PATCH 1/2] Fix the output message of xfsdump/xfsrestore
Message-Id: <20061211204909k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Mime-Version: 1.0
From: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Date: Mon, 11 Dec 2006 20:49:08 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

The attached patch fixes the output message of xfsdump/xfsrestore.
When you set a wrong option argument, this issue happens.

e.g)
# xfsdump -L session -M label -l 10 -f dump /
                     :
                     :
xfsdump: ERROR: - argument must be between 0 and 9
                 ^   :


Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>


diff -uprN xfsdump-2.2.42-orig/common/drive.c xfsdump-2.2.42/common/drive.c
--- xfsdump-2.2.42-orig/common/drive.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/drive.c	2006-12-11 13:58:37.483966901 +0900
@@ -109,7 +109,7 @@ drive_init1( int argc, char *argv[ ], bo
 		mlog( MLOG_NORMAL, _(
 		      "too many -%c arguments: "
 		      "maximum is %d when running in miniroot\n"),
-		      optopt,
+		      GETOPT_DUMPDEST,
 		      1 );
 		usage( );
 		return BOOL_FALSE;
@@ -146,7 +146,7 @@ drive_init1( int argc, char *argv[ ], bo
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
diff -uprN xfsdump-2.2.42-orig/common/drive_minrmt.c xfsdump-2.2.42/common/drive_minrmt.c
--- xfsdump-2.2.42-orig/common/drive_minrmt.c	2006-06-21 13:53:11.000000000 +0900
+++ xfsdump-2.2.42/common/drive_minrmt.c	2006-12-11 13:58:37.490965845 +0900
@@ -450,7 +450,7 @@ ds_match( int argc, char *argv[], drive_
 			    if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 					_("-%c argument missing\n"),
-					optopt );
+					c );
 				return -10;
 		    	    }
 			    cmdlineblksize = ( u_int32_t )atoi( optarg );
@@ -527,7 +527,7 @@ ds_instantiate( int argc, char *argv[], 
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				return BOOL_FALSE;
 			}
 			contextp->dc_ringlen = ( size_t )atoi( optarg );
@@ -537,7 +537,7 @@ ds_instantiate( int argc, char *argv[], 
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("-%c argument must be "
 				      "between %u and %u: ignoring %u\n"),
-				      optopt,
+				      c,
 				      RINGLEN_MIN,
 				      RINGLEN_MAX,
 				      contextp->dc_ringlen );
@@ -566,7 +566,7 @@ ds_instantiate( int argc, char *argv[], 
 			if ( ! optarg || optarg [ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				return BOOL_FALSE;
 			}
 			contextp->dc_filesz = (off64_t)atoi( optarg ) * 1024 * 1024;
@@ -574,7 +574,7 @@ ds_instantiate( int argc, char *argv[], 
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument must be a "
 				      "positive number (MB): ignoring %u\n"),
-				      optopt,
+				      c,
 				      contextp->dc_filesz );
 				return BOOL_FALSE;
 			}
diff -uprN xfsdump-2.2.42-orig/common/drive_scsitape.c xfsdump-2.2.42/common/drive_scsitape.c
--- xfsdump-2.2.42-orig/common/drive_scsitape.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/drive_scsitape.c	2006-12-11 13:58:37.485966600 +0900
@@ -609,7 +609,7 @@ ds_instantiate( int argc, char *argv[], 
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				return BOOL_FALSE;
 			}
 			contextp->dc_ringlen = ( size_t )atoi( optarg );
@@ -619,7 +619,7 @@ ds_instantiate( int argc, char *argv[], 
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("-%c argument must be "
 				      "between %u and %u: ignoring %u\n"),
-				      optopt,
+				      c,
 				      RINGLEN_MIN,
 				      RINGLEN_MAX,
 				      contextp->dc_ringlen );
@@ -642,7 +642,7 @@ ds_instantiate( int argc, char *argv[], 
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 			    mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				    _("-%c argument missing\n"),
-				    optopt );
+				    c );
 			    return -10;
 			}
 			cmdlineblksize = ( u_int32_t )atoi( optarg );
@@ -655,7 +655,7 @@ ds_instantiate( int argc, char *argv[], 
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				return BOOL_FALSE;
 			}
                         /* given in Mb */
@@ -664,7 +664,7 @@ ds_instantiate( int argc, char *argv[], 
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_DRIVE,
 				      _("-%c argument must be a "
 				      "positive number (Mb): ignoring %u\n"),
-				      optopt,
+				      c,
 				      contextp->dc_filesz );
 				return BOOL_FALSE;
                         }
diff -uprN xfsdump-2.2.42-orig/common/global.c xfsdump-2.2.42/common/global.c
--- xfsdump-2.2.42-orig/common/global.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/global.c	2006-12-11 13:58:37.486966449 +0900
@@ -127,8 +127,8 @@ global_hdr_alloc( intgen_t argc, char *a
                                 mlog( MLOG_NORMAL,
                                       _("too many -%c arguments: "
                                       "\"-%c %s\" already given\n"),
-                                      optopt,
-                                      optopt,
+                                      c,
+                                      c,
                                       dumplabel );
                                 usage( );
                                 return 0;
@@ -136,7 +136,7 @@ global_hdr_alloc( intgen_t argc, char *a
                         if ( ! optarg || optarg[ 0 ] == '-' ) {
                                 mlog( MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      optopt );
+                                      c );
                                 usage( );
                                 return 0;
                         }
@@ -147,14 +147,14 @@ global_hdr_alloc( intgen_t argc, char *a
                         if ( ! uuid_is_null( ghdrp->gh_dumpid )) {
                                 mlog( MLOG_NORMAL | MLOG_ERROR,
                                       _("too many -%c arguments\n"),
-                                      optopt );
+                                      c );
                                 usage( );
                                 return 0;
                         }
                         if ( ! optarg || optarg[ 0 ] == '-' ) {
                                 mlog( MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      optopt );
+                                      c );
                                 usage( );
                                 return 0;
                         }
@@ -162,7 +162,7 @@ global_hdr_alloc( intgen_t argc, char *a
 			if ( ! uuid_parse( optarg, ghdrp->gh_dumpid ) ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR,
 				      _("-%c argument not a valid uuid\n"),
-				      optopt );
+				      c );
                                 usage( );
                                 return 0;
                         }
@@ -176,7 +176,7 @@ global_hdr_alloc( intgen_t argc, char *a
                         if ( ! optarg || optarg[ 0 ] == '-' ) {
                                 mlog( MLOG_NORMAL | MLOG_ERROR,
                                       _("-%c argument missing\n"),
-                                      optopt );
+                                      c );
                                 usage( );
                                 return 0;
                         }
diff -uprN xfsdump-2.2.42-orig/common/main.c xfsdump-2.2.42/common/main.c
--- xfsdump-2.2.42-orig/common/main.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/main.c	2006-12-11 13:58:37.487966298 +0900
@@ -233,7 +233,7 @@ main( int argc, char *argv[] )
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
@@ -244,7 +244,7 @@ main( int argc, char *argv[] )
 			     errno == ERANGE ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument (%s) invalid\n"),
-				      optopt,
+				      c,
 				      optarg );
 				usage( );
 				return mlog_exit(EXIT_ERROR, RV_OPT);
@@ -255,7 +255,7 @@ main( int argc, char *argv[] )
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
@@ -266,7 +266,7 @@ main( int argc, char *argv[] )
 			     errno == ERANGE ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument (%s) invalid\n"),
-				      optopt,
+				      c,
 				      optarg );
 				usage( );
 				return mlog_exit(EXIT_ERROR, RV_OPT);
@@ -284,7 +284,7 @@ main( int argc, char *argv[] )
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return mlog_exit(EXIT_ERROR, RV_OPT);
 			}
@@ -1222,14 +1222,14 @@ loadoptfile( intgen_t *argcp, char ***ar
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
 			if ( optfilename ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
 				      _("-%c allowed only once\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
diff -uprN xfsdump-2.2.42-orig/common/media.c xfsdump-2.2.42/common/media.c
--- xfsdump-2.2.42-orig/common/media.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/media.c	2006-12-11 13:58:37.484966750 +0900
@@ -107,8 +107,8 @@ media_create( int argc, char *argv[ ], d
 				mlog( MLOG_NORMAL,
 				      _("too many -%c arguments: "
 				      "\"-%c %s\" already given\n"),
-				      optopt,
-				      optopt,
+				      c,
+				      c,
 				      medialabel );
 				usage( );
 				return 0;
@@ -116,7 +116,7 @@ media_create( int argc, char *argv[ ], d
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL,
 				      _("-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return 0;
 			}
diff -uprN xfsdump-2.2.42-orig/common/mlog.c xfsdump-2.2.42/common/mlog.c
--- xfsdump-2.2.42-orig/common/mlog.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/common/mlog.c	2006-12-11 13:58:37.488966147 +0900
@@ -179,7 +179,7 @@ mlog_init1( intgen_t argc, char *argv[ ]
 				fprintf( stderr,
 					 _("%s: -%c argument missing\n"),
 					 progname,
-					 optopt );
+					 c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -195,7 +195,7 @@ mlog_init1( intgen_t argc, char *argv[ ]
 					fprintf( stderr,
 						 _("%s: -%c argument invalid\n"),
 						 progname,
-						 optopt );
+						 c );
 					usage( );
 					return BOOL_FALSE;
 				}
@@ -210,7 +210,7 @@ mlog_init1( intgen_t argc, char *argv[ ]
 							 "%s requires a "
 							 "verbosity value\n"),
 							 progname,
-							 optopt,
+							 c,
 						mlog_ss_names[ suboptix ] );
 						usage( );
 						return BOOL_FALSE;
@@ -225,7 +225,7 @@ mlog_init1( intgen_t argc, char *argv[ ]
 							 "does not require "
 							 "a value\n"),
 							 progname,
-							 optopt );
+							 c );
 						usage( );
 						return BOOL_FALSE;
 					}
@@ -238,7 +238,7 @@ mlog_init1( intgen_t argc, char *argv[ ]
 						 _("%s: -%c argument "
 						 "invalid\n"),
 						 progname,
-						 optopt );
+						 c );
 					usage( );
 					return BOOL_FALSE;
 				}
diff -uprN xfsdump-2.2.42-orig/dump/content.c xfsdump-2.2.42/dump/content.c
--- xfsdump-2.2.42-orig/dump/content.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/dump/content.c	2006-12-11 13:58:37.458970672 +0900
@@ -598,7 +598,7 @@ content_init( intgen_t argc,
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -607,7 +607,7 @@ content_init( intgen_t argc,
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument must be "
 				      "between 0 and %d\n"),
-				      optopt,
+				      c,
 				      LEVEL_MAX );
 				usage( );
 				return BOOL_FALSE;
@@ -617,7 +617,7 @@ content_init( intgen_t argc,
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -625,7 +625,7 @@ content_init( intgen_t argc,
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument (subtree) "
 				      "must be a relative pathname\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -635,7 +635,7 @@ content_init( intgen_t argc,
 			if ( ! optarg || optarg [ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -645,7 +645,7 @@ content_init( intgen_t argc,
 			     ( maxdumpfilesize == ULONGLONG_MAX && errno == ERANGE ) ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument is not a valid file size\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -667,7 +667,7 @@ content_init( intgen_t argc,
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 					"-%c argument missing\n"),
-				    optopt );
+				    c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -684,7 +684,7 @@ content_init( intgen_t argc,
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -694,7 +694,7 @@ content_init( intgen_t argc,
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument not a valid "
 				      "dump session id\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -1662,14 +1662,14 @@ baseuuidbypass:
 					mlog( MLOG_NORMAL, _(
 					      "more -%c arguments "
 					      "than number of drives\n"),
-					      optopt );
+					      c );
 					usage( );
 					return BOOL_FALSE;
 				}
 				if ( ! optarg || optarg[ 0 ] == '-' ) {
 					mlog( MLOG_NORMAL, _(
 					      "-%c argument missing\n"),
-					      optopt );
+					      c );
 					usage( );
 					return BOOL_FALSE;
 				}
diff -uprN xfsdump-2.2.42-orig/restore/content.c xfsdump-2.2.42/restore/content.c
--- xfsdump-2.2.42-orig/restore/content.c	2006-06-20 15:51:26.000000000 +0900
+++ xfsdump-2.2.42/restore/content.c	2006-12-11 13:58:37.474968259 +0900
@@ -927,7 +927,7 @@ content_init( intgen_t argc, char *argv[
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -935,7 +935,7 @@ content_init( intgen_t argc, char *argv[
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "unable to get status of -%c argument %s:"
 				      " %s\n"),
-				      optopt,
+				      c,
 				      optarg,
 				      strerror( errno ));
 				return BOOL_FALSE;
@@ -953,7 +953,7 @@ content_init( intgen_t argc, char *argv[
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -964,7 +964,7 @@ content_init( intgen_t argc, char *argv[
 					mlog( MLOG_NORMAL | MLOG_ERROR, _(
 					      "-%c argument %s is an "
 					      "invalid pathname\n"),
-					      optopt,
+					      c,
 					      optarg );
 					usage( );
 					return BOOL_FALSE;
@@ -981,7 +981,7 @@ content_init( intgen_t argc, char *argv[
 			if ( rval ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "cannot stat -%c argument %s (%s): %s\n"),
-				      optopt,
+				      c,
 				      optarg,
 				      tranp->t_hkdir,
 				      strerror( errno ));
@@ -992,7 +992,7 @@ content_init( intgen_t argc, char *argv[
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument %s (%s) "
 				      "is not a directory\n"),
-				      optopt,
+				      c,
 				      optarg,
 				      tranp->t_hkdir );
 				usage( );
@@ -1005,8 +1005,8 @@ content_init( intgen_t argc, char *argv[
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "too many -%c arguments: "
 				      "\"-%c %s\" already given\n"),
-				      optopt,
-				      optopt,
+				      c,
+				      c,
 				      tranp->t_reqdumplab );
 				usage( );
 				return BOOL_FALSE;
@@ -1014,7 +1014,7 @@ content_init( intgen_t argc, char *argv[
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -1023,7 +1023,7 @@ content_init( intgen_t argc, char *argv[
 			     sizeofmember( pers_t, s.dumplab )) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument %s too long: max is %d\n"),
-				      optopt,
+				      c,
 				      optarg,
 				      sizeofmember( pers_t, s.dumplab ));
 				usage( );
@@ -1036,21 +1036,21 @@ content_init( intgen_t argc, char *argv[
 			if ( tranp->t_reqdumpidvalpr ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "too many -%c arguments\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
 			if (uuid_parse( optarg, tranp->t_reqdumpid ) < 0 ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 				      "-%c argument not a valid uuid\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -1065,14 +1065,14 @@ content_init( intgen_t argc, char *argv[
 			     optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL, _(
 				      "-%c argument missing\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
 			if ( optarg[ 0 ] == '/' ) {
 				mlog( MLOG_NORMAL, _(
 				      "-%c argument must be relative\n"),
-				      optopt );
+				      c );
 				usage( );
 				return BOOL_FALSE;
 			}
@@ -1111,7 +1111,7 @@ content_init( intgen_t argc, char *argv[
 			if ( ! optarg || optarg[ 0 ] == '-' ) {
 				mlog( MLOG_NORMAL | MLOG_ERROR, _(
 					"-%c argument missing\n"),
-					optopt );
+					c );
 				usage( );
 				return BOOL_FALSE;
 			}
