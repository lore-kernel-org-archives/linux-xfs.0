Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 05:52:54 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBBDpsqw002577
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 05:51:57 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBBBw08c008212
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:58:05 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kBBBnfUU012974
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:49:41 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kBBBnfH14308 for xfs@oss.sgi.com; Mon, 11 Dec 2006 20:49:41 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kBBBneA15158 for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:49:40 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061211.205519.59300892 for <xfs@oss.sgi.com>
	; Mon, 11 Dec 2006 20:55:19 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 83F99AE4B0
	for <xfs@oss.sgi.com>; Mon, 11 Dec 2006 20:48:52 +0900 (JST)
Subject: [PATCH 2/2] Segmentation fault in xfsdump/xfsrestore
Message-Id: <20061211204931k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Mime-Version: 1.0
From: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Date: Mon, 11 Dec 2006 20:49:31 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

xfsdump/xfsrestore causes segmentation fault when "-O options_file" 
is specified twice. Because mlog_fp is used before initialization.

# xfsdump -L session -M label -O optfile -O optfile -f dump / 

This patch adds a new function, mlog_init0(). And it initializes 
three variables(mlog_fp, mlog_level_ss and mlog_qlockh). 
mlog_level_ss is initialized with MLOG_VERBOSE for the log output.


Please patch "[PATCH 1/2] Fix the output message of xfsdump/xfsrestore"
first.


Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>


diff -up xfsdump-2.2.42-orig/common/main.c xfsdump-2.2.42/common/main.c
--- xfsdump-2.2.42-orig/common/main.c	2006-11-17 14:17:38.000000000 +0900
+++ xfsdump-2.2.42/common/main.c	2006-11-30 15:26:22.000000000 +0900
@@ -199,6 +199,10 @@ main( int argc, char *argv[] )
 	rval = atexit(mlog_exit_flush);
 	assert(rval == 0);
 
+	/* initialize message logging (stage 0)
+	 */
+	mlog_init0();
+
 	/* pre-scan the command line for the option file option.
 	 * if found, create a new argv.
 	 */
diff -up xfsdump-2.2.42-orig/common/mlog.c xfsdump-2.2.42/common/mlog.c
--- xfsdump-2.2.42-orig/common/mlog.c	2006-11-17 14:17:38.000000000 +0900
+++ xfsdump-2.2.42/common/mlog.c	2006-12-01 17:35:04.589000364 +0900
@@ -118,6 +118,25 @@ static int mlog_main_exit_code = -1;
 static rv_t mlog_main_exit_return = RV_NONE;
 static rv_t mlog_main_exit_hint = RV_NONE;
 
+void
+mlog_init0( void )
+{
+	int i;
+
+#ifdef DUMP
+	mlog_fp = stderr;
+#endif /* DUMP */
+#ifdef RESTORE
+	mlog_fp = stdout;
+#endif /* RESTORE */
+
+	for( i = 0 ; i < MLOG_SS_CNT ; i++ ) {
+		mlog_level_ss[ i ] = MLOG_VERBOSE;
+	}
+
+	mlog_qlockh = QLOCKH_NULL;
+}
+
 bool_t
 mlog_init1( intgen_t argc, char *argv[ ] )
 {
@@ -127,13 +146,6 @@ mlog_init1( intgen_t argc, char *argv[ ]
 	size_t vsymcnt;
 	intgen_t c;
 
-#ifdef DUMP
-        mlog_fp = stderr;
-#endif /* DUMP */
-#ifdef RESTORE
-        mlog_fp = stdout;
-#endif /* RESTORE */
-
 	/* initialize stream count. will be updated later by call to
 	 * mlog_tell_streamcnt( ), after drive layer has counted drives
 	 */
@@ -288,8 +300,6 @@ mlog_init1( intgen_t argc, char *argv[ ]
 	}
 #endif /* DUMP */
 
-	mlog_qlockh = QLOCKH_NULL;
-
 	return BOOL_TRUE;
 }
 
diff -up xfsdump-2.2.42-orig/common/mlog.h xfsdump-2.2.42/common/mlog.h
--- xfsdump-2.2.42-orig/common/mlog.h	2006-11-17 14:17:38.000000000 +0900
+++ xfsdump-2.2.42/common/mlog.h	2006-11-30 16:16:20.000000000 +0900
@@ -95,6 +95,7 @@ extern char *mlog_ss_names[ MLOG_SS_CNT 
 /* initializes the mlog abstraction. split into two phases to
  * unravel some initialization sequencing problems.
  */
+extern void mlog_init0( void );
 extern bool_t mlog_init1( intgen_t argc, char *argv[ ] );
 extern bool_t mlog_init2( void );
 
diff -up xfsdump-2.2.42-orig/common/qlock.c xfsdump-2.2.42/common/qlock.c
--- xfsdump-2.2.42-orig/common/qlock.c	2006-11-17 14:17:38.000000000 +0900
+++ xfsdump-2.2.42/common/qlock.c	2006-12-01 19:07:50.488832864 +0900
@@ -263,6 +263,8 @@ qlock_alloc( ix_t ord )
 void
 qlock_lock( qlockh_t qlockh )
 {
+	extern bool_t miniroot;
+
 #ifdef HIDDEN
 	qlock_t *qlockp = ( qlock_t * )qlockh;
 	pid_t pid;
@@ -271,10 +273,10 @@ qlock_lock( qlockh_t qlockh )
 	/* REFERENCED */
 	bool_t lockacquired;
 #endif
-	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
+
+	if ( ! qlock_inited ) {
+		qlock_init( miniroot );
+	}
 
 	/* bypass if miniroot
 	 */
