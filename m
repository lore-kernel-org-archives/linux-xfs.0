Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74MUvoM089253 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 17:30:57 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 1/7] xfsdump: remove conditional OPENMASKED code
Date: Thu,  4 Aug 2011 17:30:05 -0500
Message-Id: <1312497011-24840-2-git-send-email-wkendall@sgi.com>
In-Reply-To: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
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

xfsdump contains a couple wrapper functions which block signals
during an open(2) call. This code is conditionally compiled and has
not been enabled for a long time. Remove the wrappers rather than
converting them to use the POSIX signal API.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/drive_minrmt.c   |   58 +---------------------------------------------
 common/drive_scsitape.c |   58 +---------------------------------------------
 2 files changed, 4 insertions(+), 112 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 94795e2..eb7876a 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -24,11 +24,9 @@
 #include <sys/sem.h>
 #include <sys/prctl.h>
 #include <time.h>
-#include <signal.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/sysmacros.h>
-#include <sys/signal.h>
 #include <malloc.h>
 #include <sched.h>
 
@@ -59,12 +57,6 @@
 
 /* remote tape protocol debug
  */
-#ifdef OPENMASKED
-static intgen_t open_masked_signals( char *path, int oflags );
-#else /* OPENMASKED */
-#define open_masked_signals(p,f)	open(p,f)
-#endif /* OPENMASKED */
-
 #ifdef RMT
 #ifdef RMTDBG
 #define	open(p,f)		dbgrmtopen(p,f)
@@ -455,7 +447,7 @@ ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 		    	    }
 			    cmdlineblksize = ( u_int32_t )atoi( optarg );
 		            errno = 0;
-		            fd = open_masked_signals( drivep->d_pathname, O_RDONLY );
+		            fd = open( drivep->d_pathname, O_RDONLY );
 		            if ( fd < 0 ) 
 			            return -10;
 		            close( fd );
@@ -3435,7 +3427,7 @@ Open( drive_t *drivep )
 	ASSERT( contextp->dc_fd == -1 );
 
 	errno = 0;
-	contextp->dc_fd = open_masked_signals( drivep->d_pathname, oflags );
+	contextp->dc_fd = open( drivep->d_pathname, oflags );
 
 	if ( contextp->dc_fd <= 0 ) {
 		return BOOL_FALSE;
@@ -4039,49 +4031,3 @@ isxfsdumperasetape( drive_t *drivep )
 	else 
 		return BOOL_FALSE;
 }
-
-#ifdef OPENMASKED
-
-static intgen_t
-open_masked_signals( char *pathname, int oflags )
-{
-	bool_t isrmtpr;
-	SIG_PF sigalrm_save;
-	SIG_PF sigint_save;
-	SIG_PF sighup_save;
-	SIG_PF sigquit_save;
-	SIG_PF sigcld_save;
-	intgen_t rval;
-	intgen_t saved_errno;
-
-	if ( strchr( pathname, ':') ) {
-		isrmtpr = BOOL_TRUE;
-	} else {
-		isrmtpr = BOOL_FALSE;
-	}
-
-	if ( isrmtpr ) {
-		sigalrm_save = sigset( SIGALRM, SIG_IGN );
-		sigint_save = sigset( SIGINT, SIG_IGN );
-		sighup_save = sigset( SIGHUP, SIG_IGN );
-		sigquit_save = sigset( SIGQUIT, SIG_IGN );
-		sigcld_save = sigset( SIGCLD, SIG_IGN );
-	}
-
-	errno = 0;
-	rval = open( pathname, oflags );
-	saved_errno = errno;
-
-	if ( isrmtpr ) {
-		( void )sigset( SIGCLD, sigcld_save );
-		( void )sigset( SIGQUIT, sigquit_save );
-		( void )sigset( SIGHUP, sighup_save );
-		( void )sigset( SIGINT, sigint_save );
-		( void )sigset( SIGALRM, sigalrm_save );
-	}
-
-	errno = saved_errno;
-	return rval;
-}
-
-#endif /* OPENMASKED */
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 0f034b7..d72ba69 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -24,11 +24,9 @@
 #include <sys/sem.h>
 #include <sys/prctl.h>
 #include <time.h>
-#include <signal.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/sysmacros.h>
-#include <sys/signal.h>
 #include <malloc.h>
 #include <sched.h>
 
@@ -55,12 +53,6 @@
 
 /* remote tape protocol debug
  */
-#ifdef OPENMASKED
-static intgen_t open_masked_signals( char *path, int oflags );
-#else /* OPENMASKED */
-#define open_masked_signals(p,f)	open(p,f)
-#endif /* OPENMASKED */
-
 #ifdef RMT
 #ifdef RMTDBG
 #define	open(p,f)		dbgrmtopen(p,f)
@@ -539,7 +531,7 @@ ds_match( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 
 	if ( strchr( drivep->d_pathname, ':')) {
 		errno = 0;
-		fd = open_masked_signals( drivep->d_pathname, O_RDONLY );
+		fd = open( drivep->d_pathname, O_RDONLY );
 		if ( fd < 0 ) {
 			return -10;
 		}
@@ -4682,7 +4674,7 @@ Open( drive_t *drivep )
 	ASSERT( contextp->dc_fd == -1 );
 
 	errno = 0;
-	contextp->dc_fd = open_masked_signals( drivep->d_pathname, oflags );
+	contextp->dc_fd = open( drivep->d_pathname, oflags );
 
 	if ( contextp->dc_fd <= 0 ) {
 		return BOOL_FALSE;
@@ -5426,52 +5418,6 @@ isefsdump( drive_t *drivep )
 	}
 }
 
-#ifdef OPENMASKED
-
-static intgen_t
-open_masked_signals( char *pathname, int oflags )
-{
-	bool_t isrmtpr;
-	SIG_PF sigalrm_save;
-	SIG_PF sigint_save;
-	SIG_PF sighup_save;
-	SIG_PF sigquit_save;
-	SIG_PF sigcld_save;
-	intgen_t rval;
-	intgen_t saved_errno;
-
-	if ( strchr( pathname, ':') ) {
-		isrmtpr = BOOL_TRUE;
-	} else {
-		isrmtpr = BOOL_FALSE;
-	}
-
-	if ( isrmtpr ) {
-		sigalrm_save = sigset( SIGALRM, SIG_IGN );
-		sigint_save = sigset( SIGINT, SIG_IGN );
-		sighup_save = sigset( SIGHUP, SIG_IGN );
-		sigquit_save = sigset( SIGQUIT, SIG_IGN );
-		sigcld_save = sigset( SIGCLD, SIG_IGN );
-	}
-
-	errno = 0;
-	rval = open( pathname, oflags );
-	saved_errno = errno;
-
-	if ( isrmtpr ) {
-		( void )sigset( SIGCLD, sigcld_save );
-		( void )sigset( SIGQUIT, sigquit_save );
-		( void )sigset( SIGHUP, sighup_save );
-		( void )sigset( SIGINT, sigint_save );
-		( void )sigset( SIGALRM, sigalrm_save );
-	}
-
-	errno = saved_errno;
-	return rval;
-}
-
-#endif /* OPENMASKED */
-
 /*
  * General purpose routine which dredges through procfs trying to
  * match up device driver names with the associated major numbers
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
