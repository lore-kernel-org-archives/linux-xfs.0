Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9Dd3O3112040 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 07:39:03 -0600
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEFABAC002
	for <xfs@oss.sgi.com>; Fri,  9 Nov 2012 05:40:59 -0800 (PST)
Message-Id: <20121109132713.922668905@sgi.com>
Date: Fri, 09 Nov 2012 07:23:59 -0600
From: rjohnston@sgi.com
Subject: [PATCH 1/3] xfstests: remove unsupported conditionals
References: <20121109132358.256359544@sgi.com>
Content-Disposition: inline;
	filename=xfstests-remove-unsupported-conditionals.patch
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

This patch removes the unsupported sgi and CRAY.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
 dmapi/src/common/lib/dmport.h         |   16 
 dmapi/src/common/lib/util.c           |   16 
 dmapi/src/sample_hsm/wbee.c           |    2 
 dmapi/src/simple/dm_create_session.c  |    3 
 dmapi/src/simple/dm_destroy_session.c |    3 
 dmapi/src/simple/dm_find_eventmsg.c   |    3 
 dmapi/src/simple/dm_getall_sessions.c |    3 
 dmapi/src/simple/dm_getall_tokens.c   |    3 
 dmapi/src/simple/dm_query_session.c   |    3 
 dmapi/src/suite1/cmd/get_mountinfo.c  |    4 
 dmapi/src/suite1/cmd/make_rt_sparse.c |    7 
 dmapi/src/suite1/cmd/print_event.c    |    8 
 dmapi/src/suite1/cmd/print_fshandle.c |   21 
 dmapi/src/suite2/src/check_dmapi.c    |   25 
 dmapi/src/suite2/src/dm_test_daemon.c |   20 
 dmapi/src/suite2/src/mmap.c           |   12 
 dmapi/src/suite2/src/test_invis.c     |   43 
 include/test.h                        |   17 
 include/tlibio.h                      |   40 
 include/usctest.h                     |    2 
 include/write_log.h                   |    8 
 lib/datapid.c                         |  179 ---
 lib/random_range.c                    |   34 
 lib/str_to_bytes.c                    |    6 
 lib/tlibio.c                          |  777 --------------
 ltp/doio.c                            | 1866 +---------------------------------
 ltp/doio.h                            |    6 
 ltp/growfiles.c                       |  162 --
 ltp/iogen.c                           |  307 -----
 src/dirperf.c                         |    2 
 src/dmiperf.c                         |    6 
 src/global.h                          |    5 
 src/multi_open_unlink.c               |    4 
 src/randholes.c                       |    5 
 34 files changed, 101 insertions(+), 3517 deletions(-)

Index: b/dmapi/src/common/lib/dmport.h
===================================================================
--- a/dmapi/src/common/lib/dmport.h
+++ b/dmapi/src/common/lib/dmport.h
@@ -294,22 +294,6 @@ typedef	struct dm_timestruct dm_timestru
 
 -------------- end of SGI-specific hack documentation --------------- */
 
-#ifdef	__sgi
-
-#include <sys/dmi.h>
-
-/* In the dm_fileattr_t structure, Veritas used 'timeval' structures for all
-   the time fields while XDSM uses 'time_t' structures.  Define some symbols
-   that can be used for the time fields with all implementation types.
-*/
-
-#define FA_ATIME	fa_atime
-#define FA_MTIME	fa_mtime
-#define FA_CTIME	fa_ctime
-#define FA_DTIME	fa_dtime
-
-#endif /* __sgi */
-
 #ifdef	linux
 
 #include <dmapi.h>
Index: b/dmapi/src/common/lib/util.c
===================================================================
--- a/dmapi/src/common/lib/util.c
+++ b/dmapi/src/common/lib/util.c
@@ -380,11 +380,7 @@ save_filedata(
 		nread = dm_read_invis(sid, hanp, hlen, DM_NO_TOKEN, off, 
 					(dm_ssize_t)CHUNKSIZE, filebuf);
 		if (nread != CHUNKSIZE) {
-#ifdef	__sgi
-			errno_msg("%s/%d: invis read err: got %lld, expected %lld, buf %d",
-#else
 			errno_msg("%s/%d: invis read err: got %d, expected %d, buf %d",
-#endif
 				__FILE__, __LINE__,
 				nread, (dm_ssize_t)CHUNKSIZE, i);
 			retval = 1;
@@ -406,11 +402,7 @@ save_filedata(
 	nread  = dm_read_invis(sid, hanp, hlen, DM_NO_TOKEN, off, 
 				(dm_ssize_t)lastbuf, filebuf);
 	if (nread != lastbuf) {
-#ifdef	__sgi
-		errno_msg("%s/%d: invis read error- got %lld, expected %lld, last buf",
-#else
 		errno_msg("%s/%d: invis read error- got %d, expected %d, last buf",
-#endif
 				__FILE__, __LINE__,
 				nread, lastbuf);
 		retval = 1;
@@ -419,11 +411,7 @@ save_filedata(
 
 	nwrite = write(stg_fd, filebuf, (int)lastbuf);
 	if (nwrite != lastbuf) {
-#ifdef	__sgi
-		errno_msg("%s/%d: write error %d, expected %lld, last buffer", 
-#else
 		errno_msg("%s/%d: write error %d, expected %d, last buffer", 
-#endif
 				__FILE__, __LINE__,
 				nwrite, lastbuf);
 		retval = 1;
@@ -845,7 +833,7 @@ static	char		buffer[256];
 }
 
 
-#if defined(__sgi) || defined(linux)
+#if defined(linux)
 
 extern char *
 xflags_to_string(
@@ -913,7 +901,7 @@ print_state(
 	fprintf(stdout, "dt_blksize     %d\n", dmstat->dt_blksize);
 	fprintf(stdout, "dt_blocks      %lld\n", (long long) dmstat->dt_blocks);
 
-#if defined(__sgi) || defined(linux)
+#if defined(linux)
 	fprintf(stdout, "dt_xfs_igen    %d\n",  dmstat->dt_xfs_igen);
 	fprintf(stdout, "dt_xfs_xflags  %s\n",
 		xflags_to_string(dmstat->dt_xfs_xflags));
Index: b/dmapi/src/sample_hsm/wbee.c
===================================================================
--- a/dmapi/src/sample_hsm/wbee.c
+++ b/dmapi/src/sample_hsm/wbee.c
@@ -245,7 +245,7 @@ check_lockstate(
 		errno_msg("Can't query file access rights");
 		return(1);
 	}
-#if defined(__sgi) || defined(linux)
+#if defined(linux)
 	/*
  	 * There are no access rights on the SGI. 1 means it's
 	 * there.
Index: b/dmapi/src/simple/dm_create_session.c
===================================================================
--- a/dmapi/src/simple/dm_create_session.c
+++ b/dmapi/src/simple/dm_create_session.c
@@ -22,9 +22,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/simple/dm_destroy_session.c
===================================================================
--- a/dmapi/src/simple/dm_destroy_session.c
+++ b/dmapi/src/simple/dm_destroy_session.c
@@ -22,9 +22,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/simple/dm_find_eventmsg.c
===================================================================
--- a/dmapi/src/simple/dm_find_eventmsg.c
+++ b/dmapi/src/simple/dm_find_eventmsg.c
@@ -22,9 +22,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/simple/dm_getall_sessions.c
===================================================================
--- a/dmapi/src/simple/dm_getall_sessions.c
+++ b/dmapi/src/simple/dm_getall_sessions.c
@@ -24,9 +24,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/simple/dm_getall_tokens.c
===================================================================
--- a/dmapi/src/simple/dm_getall_tokens.c
+++ b/dmapi/src/simple/dm_getall_tokens.c
@@ -23,9 +23,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/simple/dm_query_session.c
===================================================================
--- a/dmapi/src/simple/dm_query_session.c
+++ b/dmapi/src/simple/dm_query_session.c
@@ -22,9 +22,6 @@
 #ifdef linux
 #include <dmapi.h>
 #endif
-#ifdef __sgi
-#include <sys/dmi.h>
-#endif
 
 int
 main( int argc, char **argv )
Index: b/dmapi/src/suite1/cmd/get_mountinfo.c
===================================================================
--- a/dmapi/src/suite1/cmd/get_mountinfo.c
+++ b/dmapi/src/suite1/cmd/get_mountinfo.c
@@ -43,11 +43,7 @@ in the call, and sid is the session ID w
 #define HDR  "%s: token %d sequence %d\n"
 #define VALS "\t%-15s %s\n"
 #define VALD "\t%-15s %d\n"
-#ifdef	__sgi
-#define VALLLD "\t%-15s %lld\n"
-#else
 #define VALLLD "\t%-15s %ld\n"
-#endif
 
 #ifndef linux
 extern	char	*sys_errlist[];
Index: b/dmapi/src/suite1/cmd/make_rt_sparse.c
===================================================================
--- a/dmapi/src/suite1/cmd/make_rt_sparse.c
+++ b/dmapi/src/suite1/cmd/make_rt_sparse.c
@@ -21,13 +21,6 @@
  */
 
 #include <sys/types.h>
-#ifdef __sgi
-#include <sys/fs/xfs_itable.h>
-#include <sys/syssgi.h>
-#include <sys/uuid.h>
-#include <sys/fs/xfs_fsops.h>
-#endif
-
 #include <errno.h>
 #include <fcntl.h>
 #include <malloc.h>
Index: b/dmapi/src/suite1/cmd/print_event.c
===================================================================
--- a/dmapi/src/suite1/cmd/print_event.c
+++ b/dmapi/src/suite1/cmd/print_event.c
@@ -965,10 +965,10 @@ set_disposition(
 	/* Metadata events. */
 
 	DMEV_SET(DM_EVENT_ATTRIBUTE, eventlist);
-#if 	! defined ( __sgi ) && ! defined ( VERITAS_21 ) && !defined(linux)
+#if 	!defined(VERITAS_21) && !defined(linux)
 	DMEV_SET(DM_EVENT_CANCEL, eventlist);	/* not supported on SGI */
 #endif
-#if !defined( __sgi) && !defined(linux)
+#if !defined(linux)
 	DMEV_SET(DM_EVENT_CLOSE, eventlist);	/* not supported on SGI */
 #endif
 	DMEV_SET(DM_EVENT_DESTROY, eventlist);
@@ -1051,10 +1051,10 @@ set_events(
 	/* Metadata events. */
 
 	DMEV_SET(DM_EVENT_ATTRIBUTE, eventlist);
-#if 	! defined ( __sgi ) && ! defined ( VERITAS_21 ) && ! defined(linux)
+#if 	!defined(VERITAS_21) && !defined(linux)
 	DMEV_SET(DM_EVENT_CANCEL, eventlist);	/* not supported on SGI */
 #endif
-#if !defined( __sgi) && !defined(linux)
+#if !defined(linux)
 	DMEV_SET(DM_EVENT_CLOSE, eventlist);	/* not supported on SGI */
 #endif
 	DMEV_SET(DM_EVENT_DESTROY, eventlist);
Index: b/dmapi/src/suite1/cmd/print_fshandle.c
===================================================================
--- a/dmapi/src/suite1/cmd/print_fshandle.c
+++ b/dmapi/src/suite1/cmd/print_fshandle.c
@@ -22,17 +22,10 @@
 
 #include <sys/types.h>
 #include <string.h>
-#ifdef __sgi
-#include <sys/syssgi.h>
-#include <sys/uuid.h>
-#include <sys/fs/xfs_fsops.h>
-#endif
-
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
-
 #include <lib/dmport.h>
 
 char *Progname;
@@ -56,11 +49,6 @@ main(
 	int		argc,
 	char		**argv)
 {
-#ifdef __sgi
-	xfs_fsop_geom_t	geom;
-	char		*uuid_str;
-	u_int		status;
-#endif
 	char		*name;
 	int		fd;
 	void		*fshanp;
@@ -85,15 +73,6 @@ main(
 			strerror(errno));
 		exit(1);
 	}
-
-#ifdef __sgi
-	syssgi(SGI_XFS_FSOPERATIONS, fd, XFS_FS_GEOMETRY, NULL, &geom);
-
-	uuid_to_string(&geom.uuid, &uuid_str, &status);
-
-	fprintf(stdout, "fshandle %s, uuid %s, %s\n",
-		buffer, uuid_str, argv[1]);
-#endif
 	fprintf(stdout, "fshandle %s, %s\n",
 		buffer, argv[1]);
 	exit(0);
Index: b/dmapi/src/suite2/src/check_dmapi.c
===================================================================
--- a/dmapi/src/suite2/src/check_dmapi.c
+++ b/dmapi/src/suite2/src/check_dmapi.c
@@ -123,31 +123,6 @@ main(
 	  exit(1);
 	}
 
-	/*--------------------------------
-	 * EXAMINE /usr/include/sys/dmi.h:
-	 *--------------------------------
-	 */
-#ifdef __sgi
-#define DMAPI_HDR "/usr/include/sys/dmi.h"
-
-	if (stat(DMAPI_HDR, &stat_buf)==-1){
-	  if (errno==ENOENT) { 
-	    printf( "You are missing a vital DMAPI file: %s\n", DMAPI_HDR);
-	  }
-	  else {
-	    printf( "ERROR: could not stat %s (%s)\n", DMAPI_HDR, strerror(errno));
-	  }
-	}
-	else {
-	  if (stat_buf.st_size <= 15000) {
-	    printf("You appear to have an old version of a vital DMAPI file: %s\n", DMAPI_HDR);
-	  }
-	  else if (Vflag) {
-	    printf("(You appear to have the correct version of %s\n", DMAPI_HDR);
-	  }
-	}
-#endif
-	
 	/*--------------------------
 	 * RESOLVE KERNEL PRESENCE:
 	 *--------------------------
Index: b/dmapi/src/suite2/src/dm_test_daemon.c
===================================================================
--- a/dmapi/src/suite2/src/dm_test_daemon.c
+++ b/dmapi/src/suite2/src/dm_test_daemon.c
@@ -736,7 +736,7 @@ handle_message(
       respcode = ENOSPC;
       break;
 
-    case DM_EVENT_DEBUT:		/* not supported on SGI */
+    case DM_EVENT_DEBUT:
       printf(HDR VALS,
 	     "debut", msg->ev_token, msg->ev_sequence,
 	     "object",		hans1);
@@ -843,7 +843,7 @@ handle_message(
       respond = 0;
       break;
 
-    case DM_EVENT_CLOSE:	/* not supported on SGI */
+    case DM_EVENT_CLOSE:
       printf(HDR VALS,
 	     "close", msg->ev_token, msg->ev_sequence,
 	     "object",		hans1);
@@ -1024,11 +1024,11 @@ set_disposition(
 	/* Metadata events. */
 
 	DMEV_SET(DM_EVENT_ATTRIBUTE, eventlist);
-#if 	! defined ( __sgi ) && ! defined ( VERITAS ) && ! defined(linux)
-	DMEV_SET(DM_EVENT_CANCEL, eventlist);	/* not supported on SGI */
+#if 	!defined(VERITAS) && !defined(linux)
+	DMEV_SET(DM_EVENT_CANCEL, eventlist);
 #endif
-#if !defined(__sgi) && !defined(linux)
-	DMEV_SET(DM_EVENT_CLOSE, eventlist);	/* not supported on SGI */
+#if !defined(linux)
+	DMEV_SET(DM_EVENT_CLOSE, eventlist);
 #endif
 	DMEV_SET(DM_EVENT_DESTROY, eventlist);
 
@@ -1103,11 +1103,11 @@ set_events(
 	/* Metadata events. */
 
 	DMEV_SET(DM_EVENT_ATTRIBUTE, eventlist);
-#if 	! defined ( __sgi ) && ! defined ( VERITAS ) && !defined(linux)
-	DMEV_SET(DM_EVENT_CANCEL, eventlist);	/* not supported on SGI */
+#if 	!defined(VERITAS) && !defined(linux)
+	DMEV_SET(DM_EVENT_CANCEL, eventlist);
 #endif
-#if !defined(__sgi) && !defined(linux)
-	DMEV_SET(DM_EVENT_CLOSE, eventlist);	/* not supported on SGI */
+#if !defined(linux)
+	DMEV_SET(DM_EVENT_CLOSE, eventlist);
 #endif
 	DMEV_SET(DM_EVENT_DESTROY, eventlist);
 
Index: b/dmapi/src/suite2/src/mmap.c
===================================================================
--- a/dmapi/src/suite2/src/mmap.c
+++ b/dmapi/src/suite2/src/mmap.c
@@ -94,18 +94,9 @@ static	struct	{
 	FLAG(PROT_READ, FL_PROT),
 	FLAG(PROT_WRITE, FL_PROT),
 	FLAG(PROT_EXEC, FL_PROT),
-#ifdef __sgi
-	FLAG(PROT_EXECUTE, FL_PROT),
-#endif
 	FLAG(MAP_SHARED, FL_MAP),
 	FLAG(MAP_PRIVATE, FL_MAP),
 	FLAG(MAP_FIXED, FL_MAP),
-#ifdef __sgi
-	FLAG(MAP_RENAME, FL_MAP),
-	FLAG(MAP_AUTOGROW, FL_MAP),
-	FLAG(MAP_LOCAL, FL_MAP),
-	FLAG(MAP_AUTORESRV, FL_MAP),
-#endif
 	FLAG(MAP_NONE, FL_MAP),
 };
 
@@ -145,9 +136,6 @@ main(int argc, char * argv[])
 	ifile->flags[FL_PROT].value = PROT_READ;
 	ifile->flags[FL_OPEN].value = O_RDONLY;
 	ofile->flags[FL_MAP].value = MAP_SHARED;
-#ifdef __sgi
-	ofile->flags[FL_MAP].value = MAP_AUTOGROW;
-#endif
 	ofile->flags[FL_PROT].value = PROT_WRITE;
 	ofile->flags[FL_OPEN].value = O_RDWR|O_CREAT;
 
Index: b/dmapi/src/suite2/src/test_invis.c
===================================================================
--- a/dmapi/src/suite2/src/test_invis.c
+++ b/dmapi/src/suite2/src/test_invis.c
@@ -210,18 +210,9 @@ main(
 		      test_file);
 	    }
 	    else {
-#ifdef __sgi
-	      if ((statbuf.st_atim.tv_sec == checkbuf.st_atim.tv_sec) &&
-	      (statbuf.st_atim.tv_nsec == checkbuf.st_atim.tv_nsec) &&
-	      (statbuf.st_mtim.tv_sec == checkbuf.st_mtim.tv_sec) &&
-	      (statbuf.st_mtim.tv_nsec == checkbuf.st_mtim.tv_nsec) &&
-	      (statbuf.st_ctim.tv_sec == checkbuf.st_ctim.tv_sec) &&
-	      (statbuf.st_ctim.tv_nsec == checkbuf.st_ctim.tv_nsec))
-#else
 	      if ((statbuf.st_atime == checkbuf.st_atime) &&
 	      (statbuf.st_mtime == checkbuf.st_mtime) &&
 	      (statbuf.st_ctime == checkbuf.st_ctime))
-#endif
 		{
 		if (Vflag) {
 		  printf("Report: time stamp unchanged by write\n");
@@ -267,18 +258,9 @@ main(
 		      test_file);
 	    }
 	    else {
-#ifdef __sgi
-	      if ((statbuf.st_atim.tv_sec == checkbuf.st_atim.tv_sec) &&
-	      (statbuf.st_atim.tv_nsec == checkbuf.st_atim.tv_nsec) &&
-	      (statbuf.st_mtim.tv_sec == checkbuf.st_mtim.tv_sec) &&
-	      (statbuf.st_mtim.tv_nsec == checkbuf.st_mtim.tv_nsec) &&
-	      (statbuf.st_ctim.tv_sec == checkbuf.st_ctim.tv_sec) &&
-	      (statbuf.st_ctim.tv_nsec == checkbuf.st_ctim.tv_nsec))
-#else
 	      if ((statbuf.st_atime == checkbuf.st_atime) &&
 	      (statbuf.st_mtime == checkbuf.st_mtime) &&
 	      (statbuf.st_ctime == checkbuf.st_ctime))
-#endif
 		{
 		if (Vflag) {
 		  printf("Report: time stamp unchanged by read\n");
@@ -344,31 +326,6 @@ main(
 	    printf("Report: \"0x%x\" was written and \"0x%x\" was read "
 		   "at byte %d million.\n", ch, *(u_char *)bufp, ch);
 	  }
-
-#ifdef __sgi
-	  /* Try writing a character in the 2 gigabyte (2^31) range */
-	  sprintf(bufp, "%c", ch);
-	  if (dm_write_invis(sid, hanp, hlen, DM_NO_TOKEN, 0, 
-			     2147840000, 1, bufp)==-1){
-	    printf("Error invis-writing %s at 2 gigabytes: %s\n", 
-		   (u_char *)bufp, ERR_NAME);
-	  }
-	  else if (dm_read_invis(sid, hanp, hlen, DM_NO_TOKEN,
-				 2147840000, 1, bufp)==-1){
-	    printf("Error invis-reading at 2 gigabytes: %s\n",
-		   ERR_NAME);
-	  }
-	  else if (((u_char *)bufp)[0]!=ch) {
-	    printf("Error: wanted to read %c and instead got %s.\n",
-		   ch, (u_char *)bufp);
-	  }
-	  else if (Vflag) {
-	    printf("Report: \"0x%x\" was written and \"0x%x\" was read "
-		   "at 2147840000 bytes\n\t(a bit over 2 gigabytes).\n", 
-		   ch, *(u_char *)bufp);
-	  }
-#endif
-
 	  printf("\t(errno subtests beginning...)\n");
 	  /**** WRITE tests ****/
 	  /*---------------------------------------------------------*/
Index: b/include/test.h
===================================================================
--- a/include/test.h
+++ b/include/test.h
@@ -36,23 +36,6 @@
 #define TCONF    32   /* Test not appropriate for configuration flag */
 
 /*
- * To determine if you are on a Umk or Unicos system,
- * use sysconf(_SC_CRAY_SYSTEM).  But since _SC_CRAY_SYSTEM
- * is not defined until 90, it will be define here if not already
- * defined.
- * if ( sysconf(_SC_CRAY_SYSTEM) == 1 )
- *    on UMK
- * else   # returned 0 or -1 
- *    on Unicos
- * This is only being done on CRAY systems.
- */
-#ifdef CRAY
-#ifndef _SC_CRAY_SYSTEM
-#define _SC_CRAY_SYSTEM  140
-#endif /* ! _SC_CRAY_SYSTEM */
-#endif /* CRAY */
-
-/*
  * Ensure that NUMSIGS is defined.
  * It should be defined in signal.h or sys/signal.h on
  * UNICOS/mk and IRIX systems.   On UNICOS systems,
Index: b/include/tlibio.h
===================================================================
--- a/include/tlibio.h
+++ b/include/tlibio.h
@@ -23,54 +23,27 @@
 #define LIO_IO_SYNCV            00020   /* single-buffer readv/writev */
 #define LIO_IO_SYNCP            00040   /* pread/pwrite */
 
-#ifdef sgi
-#define LIO_IO_ATYPES           00077   /* all io types */
-#define LIO_IO_TYPES            00061   /* all io types, non-async */
-#endif /* sgi */
 #ifdef linux
 #define LIO_IO_TYPES            00021   /* all io types */
 #endif /* linux */
-#ifdef CRAY
-#define LIO_IO_TYPES            00017   /* all io types */
-#endif /* CRAY */
 
 #define LIO_WAIT_NONE           00010000 /* return asap -- use with care */
 #define LIO_WAIT_ACTIVE         00020000 /* spin looking at iosw fields, or EINPROGRESS */
 #define LIO_WAIT_RECALL         00040000 /* call recall(2)/aio_suspend(3) */
 #define LIO_WAIT_SIGPAUSE       00100000 /* call pause */
 #define LIO_WAIT_SIGACTIVE      00200000 /* spin waiting for signal */
-#ifdef sgi
-#define LIO_WAIT_CBSUSPEND      00400000 /* aio_suspend waiting for callback */
-#define LIO_WAIT_SIGSUSPEND     01000000 /* aio_suspend waiting for signal */
-#define LIO_WAIT_ATYPES         01760000 /* all async wait types, except nowait */
-#define LIO_WAIT_TYPES          00020000 /* all sync wait types (sorta) */
-#endif /* sgi */
+
 #ifdef linux
 #define LIO_WAIT_TYPES          00300000 /* all wait types, except nowait */
 #endif /* linux */
-#ifdef CRAY
-#define LIO_WAIT_TYPES          00360000 /* all wait types, except nowait */
-#endif /* CRAY */
 
 /* meta wait io  */
 /*  00  000 0000 */
 
-#ifdef sgi
-/* all callback wait types */
-#define LIO_WAIT_CBTYPES	(LIO_WAIT_CBSUSPEND)
-/* all signal wait types */
-#define LIO_WAIT_SIGTYPES	(LIO_WAIT_SIGPAUSE|LIO_WAIT_SIGACTIVE|LIO_WAIT_SIGSUSPEND)
-/* all aio_{read,write} or lio_listio */
-#define LIO_IO_ASYNC_TYPES	(LIO_IO_ASYNC|LIO_IO_SLISTIO|LIO_IO_ALISTIO)
-#endif /* sgi */
 #ifdef linux
 /* all signal wait types */
 #define LIO_WAIT_SIGTYPES	(LIO_WAIT_SIGPAUSE)
 #endif /* linux */
-#ifdef CRAY
-/* all signal wait types */
-#define LIO_WAIT_SIGTYPES	(LIO_WAIT_SIGPAUSE|LIO_WAIT_SIGACTIVE)
-#endif /* CRAY */
 
 /*
  * This bit provides a way to randomly pick an io type and wait method.
@@ -110,17 +83,6 @@ int  lio_read_buffer(int fd, int method,
 		     int sig, char **errmsg, long wrd);
 int  lio_random_methods(long mask);
 
-#if CRAY
-#include <sys/iosw.h>
-int  lio_wait4asyncio(int method, int fd, struct iosw **statptr);
-int  lio_check_asyncio(char *io_type, int size, struct iosw *status);
-#endif /* CRAY */
-#ifdef sgi
-#include <aio.h>
-int  lio_wait4asyncio(int method, int fd, aiocb_t *aiocbp);
-int  lio_check_asyncio(char *io_type, int size, aiocb_t *aiocbp, int method);
-#endif /* sgi */
-
 /*
  * Define the structure that contains the infomation that is used
  * by the parsing and help functions.
Index: b/include/usctest.h
===================================================================
--- a/include/usctest.h
+++ b/include/usctest.h
@@ -89,11 +89,9 @@
 #endif
 #endif
 
-#ifndef CRAY
 #ifndef BSIZE 
 #define BSIZE BBSIZE
 #endif
-#endif
 
 /***********************************************************************
  * Define option_t structure type.
Index: b/include/write_log.h
===================================================================
--- a/include/write_log.h
+++ b/include/write_log.h
@@ -91,18 +91,10 @@ struct wlog_rec {
  */
 
 struct wlog_rec_disk {
-#ifdef sgi	/* sgi is pissy about fields > 32 bit, even cc -mips3 */
-    uint    w_offset    : 32;	    /* file offset  	    	    */
-    uint    w_extra0    : 32;       /* EXTRA BITS IN WORD 0         */
-#endif
 #ifdef linux
     uint    w_offset    : 32;	    /* file offset  	    	    */
     uint    w_extra0    : 32;       /* EXTRA BITS IN WORD 0         */
 #endif
-#ifdef CRAY
-    uint    w_offset    : 44;	    /* file offset  	    	    */
-    uint    w_extra0    : 20;       /* EXTRA BITS IN WORD 0         */
-#endif
 
     uint    w_nbytes    : 32;	    /* # bytes written	    	    */
     uint    w_oflags	: 32;	    /* low-order open() flags	    */
Index: b/lib/datapid.c
===================================================================
--- a/lib/datapid.c
+++ b/lib/datapid.c
@@ -75,87 +75,8 @@ char *buffer;
 int bsize;
 int offset;
 {
-#if CRAY
-	
-   int cnt;
-   int tmp;
-   char *chr;
-   long *wptr;
-   long word;
-   int woff;	/* file offset for the word */
-   int boff;	/* buffer offset or index */
-   int num_full_words;
-
-    num_full_words = bsize/NBPW;
-    boff = 0;
-
-    if ( cnt=(offset % NBPW) ) {	/* partial word */
-
-	woff = offset - cnt;
-#if DEBUG
-printf("partial at beginning, cnt = %d, woff = %d\n", cnt, woff);
-#endif
-
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-
-	for (tmp=0; tmp<cnt; tmp++) {   /* skip unused bytes */
-	    chr++;
-        }
-
-	for (; boff<(NBPW-cnt) && boff<bsize; boff++, chr++) {
-	    buffer[boff] = *chr;
-	}
-    }
-
-    /*
-     * full words 
-     */
-
-    num_full_words = (bsize-boff)/NBPW;
-	
-    woff = offset+boff;
-	
-    for (cnt=0; cnt<num_full_words; woff += NBPW, cnt++ ) {
-
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-	for(tmp=0; tmp<NBPW; tmp++, chr++) {
-	    buffer[boff++] = *chr;
-	}
-/****** Only if wptr is a word ellined
-	wptr = (long *)&buffer[boff];
-	*wptr = word;
-	boff += NBPW;
-*****/
-
-    }
-
-    /*
-     * partial word at end of buffer
-     */
-
-    if ( cnt=((bsize-boff) % NBPW) ) {
-#if DEBUG
-printf("partial at end\n");
-#endif
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-
-	for (tmp=0; tmp<cnt && boff<bsize; tmp++, chr++) {
-	    buffer[boff++] = *chr;
-	}
-    }
-
-    return bsize;
-
-#else
 	return -1;	/* not support on non-64 bits word machines  */
 
-#endif
 
 } 
 
@@ -171,112 +92,12 @@ int bsize;
 int offset;
 char **errmsg;
 {
-#if CRAY
-	
-   int cnt;
-   int tmp;
-   char *chr;
-   long *wptr;
-   long word;
-   int woff;	/* file offset for the word */
-   int boff;	/* buffer offset or index */
-   int num_full_words;
-
-
-    if ( errmsg != NULL ) {
-        *errmsg = Errmsg;
-    }
-
-
-    num_full_words = bsize/NBPW;
-    boff = 0;
-
-    if ( cnt=(offset % NBPW) ) {	/* partial word */
-	woff = offset - cnt;
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-
-	for (tmp=0; tmp<cnt; tmp++) {   /* skip unused bytes */
-	    chr++;
-        }
-
-	for (; boff<(NBPW-cnt) && boff<bsize; boff++, chr++) {
-	    if (buffer[boff] != *chr) {
-		sprintf(Errmsg, "Data mismatch at offset %d, exp:%#o, act:%#o",
-		    offset+boff, *chr, buffer[boff]);
-		return offset+boff;
-	    }
-	}
-    }
-
-    /*
-     * full words 
-     */
-
-    num_full_words = (bsize-boff)/NBPW;
-	
-    woff = offset+boff;
-	
-    for (cnt=0; cnt<num_full_words; woff += NBPW, cnt++ ) {
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-	for(tmp=0; tmp<NBPW; tmp++, boff++, chr++) {
-	    if ( buffer[boff] != *chr ) {
-	        sprintf(Errmsg, "Data mismatch at offset %d, exp:%#o, act:%#o",
-	            woff, *chr, buffer[boff]);
-	        return woff;
-	    }
-	}
-
-/****** only if a word elined
-	wptr = (long *)&buffer[boff];
-	if ( *wptr != word ) {
-	    sprintf(Errmsg, "Data mismatch at offset %d, exp:%#o, act:%#o",
-	        woff, word, *wptr);
-	    return woff;
-	}
-	boff += NBPW;
-******/
-    }
-
-    /*
-     * partial word at end of buffer
-     */
-
-    if ( cnt=((bsize-boff) % NBPW) ) {
-#if DEBUG
-printf("partial at end\n");
-#endif
-	word = ((LOWER16BITS(pid) << 48) | (LOWER32BITS(woff) << 16) | LOWER16BITS(pid));
-
-	chr = (char *)&word;
-
-
-	for (tmp=0; tmp<cnt && boff<bsize; boff++, tmp++, chr++) {
-	    if ( buffer[boff] != *chr ) {
-		sprintf(Errmsg, "Data mismatch at offset %d, exp:%#o, act:%#o",
-		    offset+boff, *chr, buffer[boff]);
-		return offset+boff;
-	    }
-	}
-    }
-
-    sprintf(Errmsg, "all %d bytes match desired pattern", bsize);
-    return -1;      /* buffer is ok */
-
-#else
-	
     if ( errmsg != NULL ) {
         *errmsg = Errmsg;
     }
     sprintf(Errmsg, "Not supported on this OS.");
     return 0;
 
-#endif
-
-
 }       /* end of datapidchk */
 
 #if UNIT_TEST
Index: b/lib/random_range.c
===================================================================
--- a/lib/random_range.c
+++ b/lib/random_range.c
@@ -338,27 +338,7 @@ char	**errp;
 	}
 
     	nmults = ((max - min) / mult) + 1;
-#if CRAY 
-        /*
-         * If max is less than 2gb, then the value can fit in 32 bits
-         * and the standard lrand48() routine can be used.
-         */
-        if ( max <= (long)2147483647 ) {
-            return (long) (min + (((long)lrand48() % nmults) * mult));
-        } else {
-            /*
-             * max is greater than 2gb - meeds more than 32 bits.
-             * Since lrand48 only will get a number up to 32bits.
-             */
-	    long randnum;
-            randnum=divider(min, max, 0, -1);
-            return (long) (min + ((randnum % nmults) * mult));
-        }
-
-#else
         return (min + ((lrand48() % nmults) * mult));
-#endif
-
 }
 
 /*
@@ -430,7 +410,7 @@ char	**errp;
 	}
 
     	nmults = ((max - min) / mult) + 1;
-#if CRAY || (_MIPS_SZLONG == 64)
+#if (_MIPS_SZLONG == 64)
         /*
          * If max is less than 2gb, then the value can fit in 32 bits
          * and the standard lrand48() routine can be used.
@@ -648,8 +628,6 @@ random_bit(long mask)
     /*
      * get the number of bits set in mask
      */
-#ifndef CRAY
-
         bit=1L;
         for ( nshift=0; nshift<sizeof(long)*8; nshift++) {
                 if ( mask & bit )
@@ -657,10 +635,6 @@ random_bit(long mask)
                 bit=bit<<1;
         }
 
-#else
-        nbits=_popcnt(mask);
-#endif  /* if CRAY */
-
     /*
      * randomly choose a bit.
      */
@@ -740,14 +714,10 @@ char **argv;
     int ind;
     int cnt, iter=10;
     int imin=0, imult=1, itmin, itmax=0;
-#if CRAY
-    int imax=6*GIG;	/* higher than 32 bits */
-#else
     int imax=1048576;
-#endif
 
     long lret, lmin=0, lmult=1, ltmin, ltmax=0; 
-#if CRAY || (_MIPS_SZLONG == 64)
+#if (_MIPS_SZLONG == 64)
     long lmax=6*(long)GIG;	/* higher than 32 bits */
 #else
     long lmax=1048576;
Index: b/lib/str_to_bytes.c
===================================================================
--- a/lib/str_to_bytes.c
+++ b/lib/str_to_bytes.c
@@ -43,11 +43,7 @@
  *
  ****************************************************************************/
 
-#if CRAY
-#define B_MULT	BSIZE		/* block size */
-#elif sgi
-#define B_MULT	BBSIZE		/* block size */
-#elif linux
+#if linux
 #define B_MULT	DEV_BSIZE	/* block size */
 #endif
 
Index: b/lib/tlibio.c
===================================================================
--- a/lib/tlibio.c
+++ b/lib/tlibio.c
@@ -38,16 +38,6 @@
  *						char **errmsg, long wrd);
  *  int  lio_read_buffer(int fd, int method, char *buffer, int size,
  *						char **errmsg, long wrd);
- *
- *  #ifdef CRAY
- *  int  lio_wait4asyncio(int method, int fd, struct iosw **statptr)
- *  int  lio_check_asyncio(char *io_type, int size, struct iosw *status)
- *  #endif
- *  #ifdef sgi
- *  int  lio_wait4asyncio(int method, int fd, aiocb_t *aiocbp)
- *  int  lio_check_asyncio(char *io_type, int size, aiocb_t *aiocbp, int method)
- *  #endif
- *
  *  int  lio_parse_io_arg1(char *string)
  *  void lio_help1(char *prefix);
  *
@@ -76,19 +66,9 @@
 #include <sys/types.h>
 #include <sys/file.h>
 #include <signal.h>
-#ifdef CRAY
-#include <sys/secparm.h>
-#include <sys/iosw.h>
-#include <sys/listio.h>
-#else
-/* for linux or sgi */
 #include <sys/uio.h> /* readv(2)/writev(2) */
 #include <string.h>
 #include <strings.h>
-#endif
-#ifdef sgi
-#include <aio.h>
-#endif
 #include <stdlib.h> /* atoi, abs */
 
 #include "tlibio.h"		/* defines LIO* marcos */
@@ -109,9 +89,6 @@
 #ifndef linux
 static void lio_async_signal_handler();
 #endif
-#ifdef sgi
-static void lio_async_callback_handler();
-#endif
 
 /*
  * Define the structure as used in lio_parse_arg1 and lio_help1
@@ -121,17 +98,10 @@ struct lio_info_type  Lio_info1[] = {
     { "p", LIO_IO_ASYNC|LIO_WAIT_SIGACTIVE, "async i/o using a loop to wait for a signal" },
     { "b", LIO_IO_ASYNC|LIO_WAIT_SIGPAUSE, "async i/o using pause" },
     { "a", LIO_IO_ASYNC|LIO_WAIT_RECALL, "async i/o using recall/aio_suspend" },
-#ifdef sgi
-    { "r", 
-	LIO_RANDOM|LIO_IO_TYPES|LIO_WAIT_TYPES, "random sync i/o types and wait methods" },
-    { "R", 
-	LIO_RANDOM|LIO_IO_ATYPES|LIO_WAIT_ATYPES, "random i/o types and wait methods" },
-#else
     { "r", 
 	LIO_RANDOM|LIO_IO_TYPES|LIO_WAIT_TYPES, "random i/o types and wait methods" },
     { "R", 
 	LIO_RANDOM|LIO_IO_TYPES|LIO_WAIT_TYPES, "random i/o types and wait methods" },
-#endif
     { "l", LIO_IO_SLISTIO|LIO_WAIT_RECALL, "single stride sync listio" },
     { "L", LIO_IO_ALISTIO|LIO_WAIT_RECALL, "single stride async listio using recall" },
     { "X", LIO_IO_ALISTIO|LIO_WAIT_SIGPAUSE, "single stride async listio using pause" },
@@ -165,10 +135,6 @@ char Lio_SysCall[PATH_MAX];	/* string co
 
 static volatile int Received_signal = 0;	/* number of signals received */
 static volatile int Rec_signal;
-#ifdef sgi
-static volatile int Received_callback = 0;	/* number of callbacks received */
-static volatile int Rec_callback;
-#endif
 static char Errormsg[500];
 static int Debug_level = 0;
 
@@ -416,25 +382,6 @@ lio_async_signal_handler(int sig)
 }
 #endif
 
-#ifdef sgi
-/***********************************************************************
- * This is an internal callback handler.
- * If the handler is called, it will increment the Received_callback
- * global variable.
- ***********************************************************************/
-static void
-lio_async_callback_handler(sigval_t sigval)
-{
-	if ( Debug_level )
-	    printf("DEBUG %s/%d: received callback, nbytes=%d, a callback called %d times\n",
-		__FILE__, __LINE__, sigval.sival_int, Received_callback+1);
-
-	Received_callback++;
-
-	return;
-}
-#endif /* sgi */
-
 /***********************************************************************
  * lio_random_methods
  * This function will randomly choose an io type and wait method
@@ -523,18 +470,7 @@ long wrd;	/* to allow future features, u
     int omethod = method;
     int listio_cmd;		/* Holds the listio/lio_listio cmd */
 #endif
-#ifdef  CRAY
-    struct listreq request;	/* Used when a listio is wanted */
-    struct iosw status, *statptr[1];  
-#else
-    /* for linux or sgi */
     struct iovec iov;	/* iovec for writev(2) */
-#endif
-#ifdef sgi
-    aiocb_t aiocbp;	/* POSIX aio control block */
-    aiocb_t *aiolist[1]; /* list of aio control blocks for lio_listio */
-    off64_t poffset;	/* pwrite(2) offset */
-#endif
 
     /*
      * If LIO_RANDOM bit specified, get new method randomly.
@@ -551,64 +487,9 @@ long wrd;	/* to allow future features, u
 	*errmsg = Errormsg;
 
     Rec_signal=Received_signal;	/* get the current number of signals received */
-#ifdef sgi
-    Rec_callback=Received_callback;	/* get the current number of callbacks received */
-#endif
-
-#ifdef  CRAY
-    bzero(&status, sizeof(struct iosw));
-    bzero(&request, sizeof(struct listreq));
-    statptr[0] = &status;
-#else
-    /* for linux or sgi */
     bzero(&iov, sizeof(struct iovec));
     iov.iov_base = buffer;
     iov.iov_len = size;
-#endif
-#ifdef sgi
-    bzero(&aiocbp, sizeof(aiocb_t));
-    aiocbp.aio_fildes = fd;
-    aiocbp.aio_nbytes = size;
-    aiocbp.aio_buf = buffer;
-/*    aiocbp.aio_offset = lseek( fd, 0, SEEK_CUR ); -- set below */
-    aiocbp.aio_sigevent.sigev_notify = SIGEV_NONE;
-    aiocbp.aio_sigevent.sigev_signo = 0;
-    aiocbp.aio_sigevent.sigev_func = NULL;
-    aiocbp.aio_sigevent.sigev_value.sival_int = 0;
-    aiolist[0] = &aiocbp;
-
-    if( (ret = lseek( fd, 0, SEEK_CUR )) == -1 ){
-	ret = 0;
-	/* If there is an error and it is not ESPIPE then kick out the error.
-	 * If the fd is a fifo then we have to make sure that
-	 * lio_random_methods() didn't select pwrite/pread; if it did then
-	 * switch to write/read.
-	 */
-	if( errno == ESPIPE ){
-		if( method & LIO_IO_SYNCP ){
-			if( omethod & LIO_RANDOM ){
-				method &= ~LIO_IO_SYNCP;
-				method |= LIO_IO_SYNC;
-				if( Debug_level > 2 )
-					printf("DEBUG %s/%d: random chosen method switched to %#o for fifo\n", __FILE__, __LINE__, method );
-			}
-			else if( Debug_level ){
-				printf("DEBUG %s/%d: pwrite will fail when it writes to a fifo\n",
-				       __FILE__, __LINE__ );
-			}
-		}
-		/* else: let it ride */
-	}
-	else{
-		sprintf(Errormsg, "%s/%d lseek(fd=%d,0,SEEK_CUR) failed, errno=%d  %s",
-			__FILE__, __LINE__, fd, errno, strerror(errno));
-		return -errno;
-	}
-    }
-    poffset = (off64_t)ret;
-    aiocbp.aio_offset = ret;
-
-#endif
 
     /*
      * If the LIO_USE_SIGNAL bit is not set, only use the signal
@@ -622,11 +503,6 @@ long wrd;	/* to allow future features, u
 	sig=0;	/* ignore signal parameter */
     }
 
-#ifdef sgi
-    if ( sig && (method & LIO_WAIT_CBTYPES) )
-	sig=0; /* ignore signal parameter */
-#endif
-
     /*
      * only setup signal hander if sig was specified and
      * a sig wait method was specified.
@@ -635,27 +511,6 @@ long wrd;	/* to allow future features, u
      *** restoring the signal handler could be added ***
      */
 
-    if ( sig &&  (method & LIO_WAIT_SIGTYPES) ){
-#ifdef CRAY
-        sigctl(SCTL_REG, sig, lio_async_signal_handler);
-#endif
-#ifdef sgi
-        aiocbp.aio_sigevent.sigev_notify = SIGEV_SIGNAL;
-	aiocbp.aio_sigevent.sigev_signo = sig;
-        sigset(sig, lio_async_signal_handler);
-#endif /* sgi */
-    }
-#ifdef sgi
-    else if( method & LIO_WAIT_CBTYPES ){
-	/* sival_int just has to be something that I can use
-	 * to identify the callback, and "size" happens to be handy...
-	 */
-	aiocbp.aio_sigevent.sigev_notify = SIGEV_CALLBACK;
-	aiocbp.aio_sigevent.sigev_func = lio_async_callback_handler;
-	aiocbp.aio_sigevent.sigev_value.sival_int = size;
-    }
-#endif
-
     /*
      * Determine the system call that will be called and produce
      * the string of the system call and place it in Lio_SysCall.
@@ -700,182 +555,6 @@ long wrd;	/* to allow future features, u
 
     }
 
-    else if ( method & LIO_IO_ASYNC ) {
-#ifdef CRAY
-	sprintf(Lio_SysCall,
-	    "writea(%d, buf, %d, &status, %d)", fd, size, sig);
-	io_type="writea";
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ((ret = writea(fd, buffer, size, &status, sig)) == -1) {
-	    sprintf(Errormsg,
-		"%s/%d writea(%d, buf, %d, &stat, %d) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, sig, errno, strerror(errno));
-	    sigon();
-	    return -errno;
-	}
-#endif
-#ifdef sgi
-	sprintf(Lio_SysCall,
-	    "aio_write(fildes=%d, buf, nbytes=%d, signo=%d)", fd, size, sig);
-	io_type="aio_write";
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-		sighold( sig );
-	if ((ret = aio_write(&aiocbp)) == -1) {
-	    sprintf(Errormsg,
-		"%s/%d aio_write(fildes=%d, buf, nbytes=%d, signo=%d) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, sig, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-	    return -errno;
-	}
-#endif
-    } /* LIO_IO_ASYNC */
-
-    else if ( method & LIO_IO_SLISTIO ) {
-#ifdef CRAY
-	request.li_opcode = LO_WRITE;
-	request.li_fildes = fd;
-        request.li_buf = buffer;
-        request.li_nbyte = size;
-        request.li_status = &status;
-        request.li_signo = sig;
-        request.li_nstride = 0;
-        request.li_filstride = 0;
-        request.li_memstride = 0;
-
-	listio_cmd=LC_WAIT;
-	io_type="listio(2) sync write";
-
-	sprintf(Lio_SysCall, 
-		"listio(LC_WAIT, &req, 1) LO_WRITE, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ( listio(listio_cmd, &request, 1) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    sigon();
-            return -errno;
-        }
-
-	if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: %s did not return -1\n",
-		__FILE__, __LINE__, Lio_SysCall);
-
-	ret=lio_check_asyncio(io_type, size,  &status);
-	return ret;
-
-#endif
-#ifdef sgi
-
-	aiocbp.aio_lio_opcode = LIO_WRITE;
-	listio_cmd=LIO_WAIT;
-	io_type="lio_listio(3) sync write";
-
-	sprintf(Lio_SysCall,
-		"lio_listio(LIO_WAIT, aiolist, 1, NULL) LIO_WRITE, fd:%d, nbyte:%d, sig:%d",
-                fd, size, sig );
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-	    sighold( sig );
-	if ( lio_listio(listio_cmd, aiolist, 1, NULL) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-            return -errno;
-        }
-
-	if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: %s did not return -1\n",
-		__FILE__, __LINE__, Lio_SysCall);
-
-	ret=lio_check_asyncio(io_type, size,  &aiocbp, method);
-	return ret;
-#endif
-    } /* LIO_IO_SLISTIO */
-
-    else if ( method & LIO_IO_ALISTIO ) {
-#ifdef CRAY
-	request.li_opcode = LO_WRITE;
-	request.li_fildes = fd;
-        request.li_buf = buffer;
-        request.li_nbyte = size;
-        request.li_status = &status;
-        request.li_signo = sig;
-        request.li_nstride = 0;
-        request.li_filstride = 0;
-        request.li_memstride = 0;
-
-	listio_cmd=LC_START;
-	io_type="listio(2) async write";
-
-	sprintf(Lio_SysCall, 
-		"listio(LC_START, &req, 1) LO_WRITE, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ( listio(listio_cmd, &request, 1) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    sigon();
-            return -errno;
-        }
-#endif
-#ifdef sgi
-	aiocbp.aio_lio_opcode = LIO_WRITE;
-	listio_cmd=LIO_NOWAIT;
-	io_type="lio_listio(3) async write";
-
-	sprintf(Lio_SysCall,
-		"lio_listio(LIO_NOWAIT, aiolist, 1, NULL) LIO_WRITE, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-		sighold( sig );
-	if ( lio_listio(listio_cmd, aiolist, 1, NULL) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-            return -errno;
-        }
-#endif
-    }/* LIO_IO_ALISTIO */
-
-#ifndef CRAY
     else if ( method & LIO_IO_SYNCV ) {
 	io_type="writev(2)";
 
@@ -904,38 +583,6 @@ long wrd;	/* to allow future features, u
 
         return ret;
     } /* LIO_IO_SYNCV */
-#endif
-
-#ifdef sgi
-    else if ( method & LIO_IO_SYNCP ) {
-	io_type="pwrite(2)";
-
-	sprintf(Lio_SysCall, 
-		"pwrite(%d, buf, %d, %lld)", fd, size, poffset);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-	if ((ret = pwrite(fd, buffer, size, poffset)) == -1) {
-	    sprintf(Errormsg, "%s/%d pwrite(%d, buf, %d, %lld) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, poffset, errno, strerror(errno));
-	    return -errno;
-	}
-
-	if ( ret != size ) {
-            sprintf(Errormsg,
-		"%s/%d pwrite(%d, buf, %d, %lld) returned=%d",
-		    __FILE__, __LINE__,
-		    fd, size, poffset, ret);
-        }
-        else if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: pwrite completed without error (ret %d)\n",
-                __FILE__, __LINE__, ret);
-
-        return ret;
-    } /* LIO_IO_SYNCP */
-#endif
 
     else {
 	printf("DEBUG %s/%d: No I/O method chosen\n", __FILE__, __LINE__ );
@@ -943,16 +590,6 @@ long wrd;	/* to allow future features, u
     }
 
     /*
-     * wait for async io to complete.
-     */
-#ifdef CRAY
-    ret=lio_wait4asyncio(method, fd, statptr);
-#endif
-#ifdef sgi
-    ret=lio_wait4asyncio(method, fd, &aiocbp);
-#endif
-
-    /*
      * If there was an error waiting for async i/o to complete,
      * return the error value (errno) to the caller.
      * Note: Errormsg should already have been updated.
@@ -976,13 +613,6 @@ long wrd;	/* to allow future features, u
      * have been updated but the actual i/o size if returned.
      */
     
-#ifdef CRAY
-    ret=lio_check_asyncio(io_type, size, &status);
-#endif
-#ifdef sgi
-    ret=lio_check_asyncio(io_type, size, &aiocbp, method);
-#endif
-
     return ret;
 }	/* end of lio_write_buffer */
 
@@ -1042,18 +672,7 @@ long wrd;	/* to allow future features, u
     int listio_cmd;		/* Holds the listio/lio_listio cmd */
     int omethod = method;
 #endif
-#ifdef  CRAY
-    struct listreq request;	/* Used when a listio is wanted */
-    struct iosw status, *statptr[1];  
-#else
-    /* for linux or sgi */
     struct iovec iov; /* iovec for readv(2) */
-#endif
-#ifdef sgi
-    aiocb_t aiocbp;	/* POSIX aio control block */
-    aiocb_t *aiolist[1]; /* list of aio control blocks for lio_listio */
-    off64_t poffset;	/* pread(2) offset */
-#endif
 
     /*
      * If LIO_RANDOM bit specified, get new method randomly.
@@ -1070,64 +689,9 @@ long wrd;	/* to allow future features, u
 	*errmsg = Errormsg;
 
     Rec_signal=Received_signal;	/* get the current number of signals received */
-#ifdef sgi
-    Rec_callback=Received_callback;	/* get the current number of callbacks received */
-#endif
-
-#ifdef  CRAY
-    bzero(&status, sizeof(struct iosw));
-    bzero(&request, sizeof(struct listreq));
-    statptr[0] = &status;
-#else
-    /* for linux or sgi */
     bzero(&iov, sizeof(struct iovec));
     iov.iov_base = buffer;
     iov.iov_len = size;
-#endif
-#ifdef sgi
-    bzero(&aiocbp, sizeof(aiocb_t));
-    aiocbp.aio_fildes = fd;
-    aiocbp.aio_nbytes = size;
-    aiocbp.aio_buf = buffer;
-/*    aiocbp.aio_offset = lseek( fd, 0, SEEK_CUR ); -- set below */
-    aiocbp.aio_sigevent.sigev_notify = SIGEV_NONE;
-    aiocbp.aio_sigevent.sigev_signo = 0;
-    aiocbp.aio_sigevent.sigev_func = NULL;
-    aiocbp.aio_sigevent.sigev_value.sival_int = 0;
-    aiolist[0] = &aiocbp;
-
-    if( (ret = lseek( fd, 0, SEEK_CUR )) == -1 ){
-	ret = 0;
-	/* If there is an error and it is not ESPIPE then kick out the error.
-	 * If the fd is a fifo then we have to make sure that
-	 * lio_random_methods() didn't select pwrite/pread; if it did then
-	 * switch to write/read.
-	 */
-	if( errno == ESPIPE ){
-		if( method & LIO_IO_SYNCP ){
-			if( omethod & LIO_RANDOM ){
-				method &= ~LIO_IO_SYNCP;
-				method |= LIO_IO_SYNC;
-				if( Debug_level > 2 )
-					printf("DEBUG %s/%d: random chosen method switched to %#o for fifo\n", __FILE__, __LINE__, method );
-			}
-			else if( Debug_level ){
-				printf("DEBUG %s/%d: pread will fail when it reads from a fifo\n",
-				       __FILE__, __LINE__ );
-			}
-		}
-		/* else: let it ride */
-	}
-	else{
-		sprintf(Errormsg, "%s/%d lseek(fd=%d,0,SEEK_CUR) failed, errno=%d  %s",
-			__FILE__, __LINE__, fd, errno, strerror(errno));
-		return -errno;
-	}
-    }
-    poffset = (off64_t)ret;
-    aiocbp.aio_offset = ret;
-
-#endif
 
     /*
      * If the LIO_USE_SIGNAL bit is not set, only use the signal
@@ -1141,11 +705,6 @@ long wrd;	/* to allow future features, u
         sig=0;  /* ignore signal parameter */
     }
 
-#ifdef sgi
-    if ( sig && (method & LIO_WAIT_CBTYPES) )
-	sig=0; /* ignore signal parameter */
-#endif
-
     /*
      * only setup signal hander if sig was specified and
      * a sig wait method was specified.
@@ -1154,27 +713,6 @@ long wrd;	/* to allow future features, u
      *** restoring the signal handler could be added ***
      */
 
-    if ( sig &&  (method & LIO_WAIT_SIGTYPES) ){
-#ifdef CRAY
-	    sigctl(SCTL_REG, sig, lio_async_signal_handler);
-#endif
-#ifdef sgi
-	    aiocbp.aio_sigevent.sigev_notify = SIGEV_SIGNAL;
-	    aiocbp.aio_sigevent.sigev_signo = sig;
-	    sigset(sig, lio_async_signal_handler);
-#endif /* CRAY */
-    }
-#ifdef sgi
-    else if( method & LIO_WAIT_CBTYPES ){
-	    aiocbp.aio_sigevent.sigev_notify = SIGEV_CALLBACK;
-	    aiocbp.aio_sigevent.sigev_func = lio_async_callback_handler;
-	    /* sival_int just has to be something that I can use
-	     * to identify the callback, and "size" happens to be handy...
-	     */
-	    aiocbp.aio_sigevent.sigev_value.sival_int = size;
-    }
-#endif
-
     /*
      * Determine the system call that will be called and produce
      * the string of the system call and place it in Lio_SysCall.
@@ -1219,180 +757,6 @@ long wrd;	/* to allow future features, u
 
     }
 
-    else if ( method & LIO_IO_ASYNC ) {
-#ifdef CRAY
-	sprintf(Lio_SysCall,
-	    "reada(%d, buf, %d, &status, %d)", fd, size, sig);
-	io_type="reada";
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ((ret = reada(fd, buffer, size, &status, sig)) == -1) {
-	    sprintf(Errormsg,
-		"%s/%d reada(%d, buf, %d, &stat, %d) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, sig, errno, strerror(errno));
-	    sigon();
-	    return -errno;
-	}
-#endif
-#ifdef sgi
-	sprintf(Lio_SysCall,
-	    "aio_read(fildes=%d, buf, nbytes=%d, signo=%d)", fd, size, sig);
-	io_type="aio_read";
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-		sighold( sig );
-	if ((ret = aio_read(&aiocbp)) == -1) {
-	    sprintf(Errormsg,
-		"%s/%d aio_read(fildes=%d, buf, nbytes=%d, signo=%d) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, sig, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-	    return -errno;
-	}
-#endif
-    } /* LIO_IO_ASYNC */
-
-    else if ( method & LIO_IO_SLISTIO ) {
-#ifdef CRAY
-	request.li_opcode = LO_READ;
-	request.li_fildes = fd;
-        request.li_buf = buffer;
-        request.li_nbyte = size;
-        request.li_status = &status;
-        request.li_signo = sig;
-        request.li_nstride = 0;
-        request.li_filstride = 0;
-        request.li_memstride = 0;
-
-	listio_cmd=LC_WAIT;
-	io_type="listio(2) sync read";
-
-	sprintf(Lio_SysCall, 
-		"listio(LC_WAIT, &req, 1) LO_READ, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ( listio(listio_cmd, &request, 1) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    sigon();
-            return -errno;
-        }
-
-	if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: %s did not return -1\n",
-		__FILE__, __LINE__, Lio_SysCall);
-
-	ret=lio_check_asyncio(io_type, size,  &status);
-	return ret;
-#endif
-#ifdef sgi
-	aiocbp.aio_lio_opcode = LIO_READ;
-	listio_cmd=LIO_WAIT;
-	io_type="lio_listio(3) sync read";
-
-	sprintf(Lio_SysCall, 
-		"lio_listio(LIO_WAIT, aiolist, 1, NULL) LIO_READ, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-		sighold( sig );
-	if ( lio_listio(listio_cmd, aiolist, 1, NULL) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-            return -errno;
-        }
-
-	if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: %s did not return -1\n",
-		__FILE__, __LINE__, Lio_SysCall);
-
-	ret=lio_check_asyncio(io_type, size,  &aiocbp, method);
-	return ret;
-#endif
-    }/* LIO_IO_SLISTIO */
-
-    else if ( method & LIO_IO_ALISTIO ) {
-#ifdef CRAY
-	request.li_opcode = LO_READ;
-	request.li_fildes = fd;
-        request.li_buf = buffer;
-        request.li_nbyte = size;
-        request.li_status = &status;
-        request.li_signo = sig;
-        request.li_nstride = 0;
-        request.li_filstride = 0;
-        request.li_memstride = 0;
-
-	listio_cmd=LC_START;
-	io_type="listio(2) async read";
-
-	sprintf(Lio_SysCall, 
-		"listio(LC_START, &req, 1) LO_READ, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	sigoff();
-	if ( listio(listio_cmd, &request, 1) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    sigon();
-            return -errno;
-        }
-#endif
-#ifdef sgi
-	aiocbp.aio_lio_opcode = LIO_READ;
-	listio_cmd=LIO_NOWAIT;
-	io_type="lio_listio(3) async read";
-
-	sprintf(Lio_SysCall, 
-		"lio_listio(LIO_NOWAIT, aiolist, 1, NULL) LIO_READ, fd:%d, nbyte:%d",
-                fd, size);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-
-	if( sig )
-		sighold( sig );
-	if ( lio_listio(listio_cmd, aiolist, 1, NULL) == -1 ) {
-            sprintf(Errormsg, "%s/%d %s failed, fd:%d, nbyte:%d errno=%d %s",
-		    __FILE__, __LINE__,
-		Lio_SysCall, fd, size, errno, strerror(errno));
-	    if( sig )
-		sigrelse( sig );
-            return -errno;
-        }
-#endif
-    } /* LIO_IO_ALISTIO */
-
-#ifndef CRAY
     else if ( method & LIO_IO_SYNCV ) {
 	io_type="readv(2)";
 
@@ -1421,38 +785,6 @@ long wrd;	/* to allow future features, u
 
         return ret;
     } /* LIO_IO_SYNCV */
-#endif
-
-#ifdef sgi
-    else if ( method & LIO_IO_SYNCP ) {
-	io_type="pread(2)";
-
-	sprintf(Lio_SysCall, 
-		"pread(%d, buf, %d, %lld)", fd, size, poffset);
-
-        if ( Debug_level ) {
-	    printf("DEBUG %s/%d: %s\n", __FILE__, __LINE__, Lio_SysCall);
-        }
-	if ((ret = pread(fd, buffer, size, poffset)) == -1) {
-	    sprintf(Errormsg, "%s/%d pread(%d, buf, %d, %lld) ret:-1, errno=%d %s",
-		    __FILE__, __LINE__,
-		fd, size, poffset, errno, strerror(errno));
-	    return -errno;
-	}
-
-	if ( ret != size ) {
-            sprintf(Errormsg,
-		"%s/%d pread(%d, buf, %d, %lld) returned=%d",
-		    __FILE__, __LINE__,
-		    fd, size, poffset, ret);
-        }
-        else if ( Debug_level > 1 )
-            printf("DEBUG %s/%d: pread completed without error (ret %d)\n",
-                __FILE__, __LINE__, ret);
-
-        return ret;
-    } /* LIO_IO_SYNCP */
-#endif
 
     else {
 	printf("DEBUG %s/%d: No I/O method chosen\n", __FILE__, __LINE__ );
@@ -1460,17 +792,6 @@ long wrd;	/* to allow future features, u
     }
 
     /*
-     * wait for async io to complete.
-     * Note: Sync io should have returned prior to getting here.
-     */
-#ifdef CRAY
-    ret=lio_wait4asyncio(method, fd, statptr);
-#endif
-#ifdef sgi
-    ret=lio_wait4asyncio(method, fd, &aiocbp);
-#endif
-
-    /*
      * If there was an error waiting for async i/o to complete,
      * return the error value (errno) to the caller.
      * Note: Errormsg should already have been updated.
@@ -1494,13 +815,6 @@ long wrd;	/* to allow future features, u
      * have been updated but the actual i/o size if returned.
      */
     
-#ifdef CRAY
-    ret=lio_check_asyncio(io_type, size, &status);
-#endif
-#ifdef sgi
-    ret=lio_check_asyncio(io_type, size, &aiocbp, method);
-#endif
-
     return ret;
 }	/* end of lio_read_buffer */
 
@@ -1518,37 +832,9 @@ long wrd;	/* to allow future features, u
  * (rrl 04/96)
  ***********************************************************************/
 int
-#ifdef CRAY
-lio_check_asyncio(char *io_type, int size, struct iosw *status)
-#else
 lio_check_asyncio(char *io_type, int size, aiocb_t *aiocbp, int method)
-#endif
 {
     int ret;
-
-#ifdef CRAY
-    if ( status->sw_error ) {
-        sprintf(Errormsg,
-            "%s/%d %s, sw_error set = %d %s, sw_count = %d",
-		__FILE__, __LINE__, io_type,
-            status->sw_error, strerror(status->sw_error), status->sw_count);
-        return -status->sw_error;
-    }
-    else if ( status->sw_count != size ) {
-        sprintf(Errormsg,
-            "%s/%d %s, sw_count not as expected(%d), but actual:%d",
-		__FILE__, __LINE__, io_type,
-            size, status->sw_count);
-    }
-    else if ( Debug_level > 1 ) {
-        printf("DEBUG %s/%d: %s completed without error (sw_error == 0, sw_count == %d)\n",
-            __FILE__, __LINE__, io_type, status->sw_count);
-    }
-
-    return status->sw_count;
-
-#else
-
     int cnt = 1;
 
     /* The I/O may have been synchronous with signal completion.  It doesn't
@@ -1609,8 +895,6 @@ lio_check_asyncio(char *io_type, int siz
 
     return ret;
 
-#endif
-
 } /* end of lio_check_asyncio */
 
 
@@ -1633,39 +917,16 @@ lio_check_asyncio(char *io_type, int siz
  * (rrl 04/96)
  ***********************************************************************/
 int
-#ifdef CRAY
-lio_wait4asyncio(int method, int fd, struct iosw **statptr)
-#else
 lio_wait4asyncio(int method, int fd, aiocb_t *aiocbp)
-#endif
 {
     int cnt;
-#ifdef sgi
-    int ret;
-    const aiocb_t *aioary[1]; 
-#endif
 
     if ( (method & LIO_WAIT_RECALL)
-#ifdef sgi
-	|| (method & LIO_WAIT_CBSUSPEND) 
-	|| (method & LIO_WAIT_SIGSUSPEND) 
-#endif
 	|| ((method & LIO_WAIT_TYPES) == 0) ){
 	/*
 	 * If method has LIO_WAIT_RECALL bit set or method does
 	 * not have any wait method bits set (default), use recall/aio_suspend.
          */
-#ifdef CRAY
-        if ( Debug_level > 2 )
-            printf("DEBUG %s/%d: wait method : recall\n", __FILE__, __LINE__);
-        sigon();
-        if ( recall(fd, 1, statptr) ) {
-	    sprintf(Errormsg, "%s/%d recall(%d, 1, stat) failed, errno:%d %s",
-		    __FILE__, __LINE__,
-		fd, errno, strerror(errno));
-	    return -errno;
-	}
-#else
         if ( Debug_level > 2 )
             printf("DEBUG %s/%d: wait method : aio_suspend, sigev_notify=%s\n", __FILE__, __LINE__,
     		(aiocbp->aio_sigevent.sigev_notify == SIGEV_SIGNAL ? "signal" :
@@ -1698,24 +959,10 @@ lio_wait4asyncio(int method, int fd, aio
 		fd, errno, strerror(errno));
 	    return -errno;
 	}
-#endif
-
     } else if ( method & LIO_WAIT_ACTIVE ) {
         if ( Debug_level > 2 )
             printf("DEBUG %s/%d: wait method : active\n", __FILE__, __LINE__);
-#ifdef CRAY
-        sigon();
-	/* 
-         * loop until sw_flag, sw_count or sw_error field elements
-	 * change to non-zero.
- 	 */
-        cnt=0;
-        while ( (*statptr)->sw_flag == 0 && 
-		(*statptr)->sw_count == 0 &&
-		(*statptr)->sw_error == 0 ) {
-	   cnt++;
-	}
-#else
+
 	/* loop while aio_error() returns EINPROGRESS */
 	cnt=0;
 	while(1){
@@ -1726,7 +973,6 @@ lio_wait4asyncio(int method, int fd, aio
 		++cnt;
 	}
 
-#endif
 	if ( Debug_level > 5 && cnt && (cnt % 50) == 0 )
 		printf("DEBUG %s/%d: wait active cnt = %d\n",
 		    __FILE__, __LINE__, cnt);
@@ -1734,37 +980,20 @@ lio_wait4asyncio(int method, int fd, aio
     } else if ( method & LIO_WAIT_SIGPAUSE ) {
         if ( Debug_level > 2 )
             printf("DEBUG %s/%d: wait method : sigpause\n", __FILE__, __LINE__);
-#ifdef sgi
-	/* note: don't do the sigon() for CRAY in this case.  why? -- roehrich 6/11/97 */
-	if( aiocbp->aio_sigevent.sigev_notify == SIGEV_SIGNAL )
-		sigrelse( aiocbp->aio_sigevent.sigev_signo );
-	else {
-		printf("DEBUG %s/%d: sigev_notify != SIGEV_SIGNAL\n", __FILE__, __LINE__ );
-		return -1;
-	}
-#endif
         pause();
 
     } else if ( method & LIO_WAIT_SIGACTIVE ) {
         if ( Debug_level > 2 )
             printf("DEBUG %s/%d: wait method : sigactive\n", __FILE__, __LINE__);
-#ifdef CRAY
-        sigon();
-#else
 	if( aiocbp->aio_sigevent.sigev_notify == SIGEV_SIGNAL )
 		sigrelse( aiocbp->aio_sigevent.sigev_signo );
 	else {
 		printf("DEBUG %s/%d: sigev_notify != SIGEV_SIGNAL\n", __FILE__, __LINE__ );
 		return -1;
 	}
-#endif
 	/* loop waiting for signal */
         while ( Received_signal == Rec_signal ){
-#ifdef CRAY
-                sigon();
-#else
 		sigrelse( aiocbp->aio_sigevent.sigev_signo );
-#endif
 	}
 
     } else if ( method & LIO_WAIT_NONE ) {
@@ -1779,10 +1008,6 @@ lio_wait4asyncio(int method, int fd, aio
 	 */
 	sprintf(Errormsg, "%s/%d LIO_WAIT_NONE was selected (this is broken)\n",
 		__FILE__, __LINE__ );
-#ifdef CRAY
-        sigon();
-#endif
-/*        return 1;*/
         return -1;
     }
     else {
Index: b/ltp/doio.c
===================================================================
--- a/ltp/doio.c
+++ b/ltp/doio.c
@@ -29,12 +29,6 @@
 
 #include "global.h"
 
-#ifdef sgi
-#include <aio.h>	/* for aio_read,write */
-#include <inttypes.h>	/* for uint64_t type */
-#include <siginfo.h>	/* signal handlers & SA_SIGINFO */
-#endif
-
 #include <sys/uio.h>	/* for struct iovec (readv)*/
 #include <sys/mman.h>	/* for mmap(2) */
 #include <sys/ipc.h>	/* for i/o buffer in shared memory */
@@ -55,7 +49,7 @@ int do_xfsctl(struct io_req *);
 #include "string_to_tokens.h"
 
 #ifndef O_SSD
-#define O_SSD 0	    	/* so code compiles on a CRAY2 */
+#define O_SSD 0                /* so code compiles on a CRAY2 */
 #endif
 
 #define UINT64_T unsigned long long
@@ -66,11 +60,7 @@ int do_xfsctl(struct io_req *);
 
 #define PPID_CHECK_INTERVAL 5		/* check ppid every <-- iterations */
 #define	MAX_AIO		256		/* maximum number of async I/O ops */
-#ifdef _CRAYMPP
-#define	MPP_BUMP	16		/* page un-alignment for MPP */
-#else
 #define	MPP_BUMP	0
-#endif
 
 
 #define	SYSERR strerror(errno)
@@ -187,10 +177,8 @@ struct fd_cache {
 	int	c_miniosz;
 	int	c_maxiosz;
 #endif
-#ifndef CRAY
 	void	*c_memaddr;	/* mmapped address */
 	int	c_memlen;	/* length of above region */
-#endif
 };
 
 #define FD_ALLOC_INCR	32      /* allocate this many fd_map structs	*/
@@ -221,10 +209,8 @@ void	sigint_handler();	/* Catch SIGINT i
 void	die_handler();		/* Bad sig in child doios, exit 1. */
 void	cleanup_handler();	/* Normal kill, exit 0. */
 
-#ifndef CRAY
 void	sigbus_handler();	/* Handle sigbus--check active_mmap_rw to
 				   decide if this should be a normal exit. */
-#endif
 
 void	cb_handler();		/* Posix aio callback handler. */
 void	noop_handler();		/* Delayop alarm, does nothing. */
@@ -287,14 +273,6 @@ struct aio_info {
 	int			fd;
 	int			strategy;
 	volatile int		done;
-#ifdef CRAY
-	struct iosw		iosw;
-#endif
-#ifdef sgi
-	aiocb_t			aiocb;
-	int			aio_ret;	/* from aio_return */
-	int			aio_errno;	/* from aio_error */
-#endif
 	int			sig;
 	int			signalled;
 	struct sigaction	osa;
@@ -322,9 +300,6 @@ struct smap checkmap[] = {
 struct smap delaymap[] = {
 	{ "select",	DELAY_SELECT },
 	{ "sleep",	DELAY_SLEEP },
-#ifdef sgi
-	{ "sginap",	DELAY_SGINAP },
-#endif
 	{ "alarm",	DELAY_ALARM },
 	{ NULL,	0 },
 };
@@ -352,10 +327,6 @@ char	**argv;
 	struct sigaction	sa;
 	sigset_t		block_mask, old_mask;
 	umask(0);		/* force new file modes to known values */
-#if _CRAYMPP
-	Npes = sysconf(_SC_CRAY_NPES);	/* must do this before parse_cmdline */
-	Vpe = sysconf(_SC_CRAY_VPE);
-#endif
 
 	TagName[0] = '\0';
 	parse_cmdline(argc, argv, OPTS);
@@ -577,9 +548,7 @@ doio()
 	char			*cp;
 	struct io_req   	ioreq;
 	struct sigaction	sa, def_action, ignore_action, exit_action;
-#ifndef CRAY
 	struct sigaction	sigbus_action;
-#endif
 
 	Memsize = Sdssize = 0;
 
@@ -653,19 +622,6 @@ doio()
 	def_action.sa_flags = 0;
 	sigemptyset(&def_action.sa_mask);
 
-#ifdef sgi
-	exit_action.sa_sigaction = cleanup_handler;
-	exit_action.sa_flags = SA_SIGINFO;
-	sigemptyset(&exit_action.sa_mask);
-
-	sa.sa_sigaction = die_handler;
-	sa.sa_flags = SA_SIGINFO;
-	sigemptyset(&sa.sa_mask);
-
-	sigbus_action.sa_sigaction = sigbus_handler;
-	sigbus_action.sa_flags = SA_SIGINFO;
-	sigemptyset(&sigbus_action.sa_mask);
-#else
 	exit_action.sa_handler = cleanup_handler;
 	exit_action.sa_flags = 0;
 	sigemptyset(&exit_action.sa_mask);
@@ -674,12 +630,9 @@ doio()
 	sa.sa_flags = 0;
 	sigemptyset(&sa.sa_mask);
 
-#ifndef CRAY
 	sigbus_action.sa_handler = sigbus_handler;
 	sigbus_action.sa_flags = 0;
 	sigemptyset(&sigbus_action.sa_mask);
-#endif
-#endif
 
 	for (i = 1; i <= NSIG; i++) {
 		switch(i) {
@@ -688,12 +641,10 @@ doio()
 			sigaction(i, &exit_action, NULL);
 			break;
 
-#ifndef CRAY
 			/* This depends on active_mmap_rw */
 		case SIGBUS:
 			sigaction(i, &sigbus_action, NULL);
 			break;
-#endif
 
 		    /* Signals to Ignore... */
 		case SIGSTOP:
@@ -790,15 +741,6 @@ doio()
 				alloc_mem(-1);
 #endif
 			}
-
-#ifdef _CRAY1
-			if (Sdssize) {
-				ssbreak(-1 * btoc(Sdssize));
-				Sdsptr = 0;
-				Sdssize = 0;
-			}
-#endif /* _CRAY1 */
-
 			alloc_fd(NULL, 0);
 		}
 
@@ -835,31 +777,16 @@ doio()
 		case LEWRITEA:
 			rval = do_rw(&ioreq);
 			break;
-
-#ifdef CRAY
-		case SSREAD:
-		case SSWRITE:
-			rval = do_ssdio(&ioreq);
-			break;
-
-		case LISTIO:
-			rval = do_listio(&ioreq);
-			break;
-#endif
-
 #ifndef NO_XFS
 		case RESVSP:
 		case UNRESVSP:
 			rval = do_xfsctl(&ioreq);
 			break;
 #endif
-
-#ifndef CRAY
 		case FSYNC2:
 		case FDATASYNC:
 			rval = do_sync(&ioreq);
 			break;
-#endif
 		default:
 			doio_fprintf(stderr,
 				     "Don't know how to handle io request type %d\n",
@@ -917,12 +844,6 @@ doio_delay()
 		sleep(delaytime);
 		break;
 
-#ifdef sgi
-	case DELAY_SGINAP:
-		sginap(delaytime);
-		break;
-#endif
-
 	case DELAY_ALARM:
 		sa_al.sa_flags = 0;
 		sa_al.sa_handler = noop_handler;
@@ -1019,35 +940,9 @@ format_oflags(int oflags)
 
 	if(oflags & O_SYNC)
 		strcat(flags,"O_SYNC,");
-#ifdef CRAY
-	if(oflags & O_RAW)
-		strcat(flags,"O_RAW,");
-	if(oflags & O_WELLFORMED)
-		strcat(flags,"O_WELLFORMED,");
-#ifdef O_SSD
-	if(oflags & O_SSD)
-		strcat(flags,"O_SSD,");
-#endif
-	if(oflags & O_LDRAW)
-		strcat(flags,"O_LDRAW,");
-	if(oflags & O_PARALLEL)
-		strcat(flags,"O_PARALLEL,");
-	if(oflags & O_BIG)
-		strcat(flags,"O_BIG,");
-	if(oflags & O_PLACE)
-		strcat(flags,"O_PLACE,");
-	if(oflags & O_ASYNC)
-		strcat(flags,"O_ASYNC,");
-#endif
 
 	if(oflags & O_DIRECT)
 		strcat(flags,"O_DIRECT,");
-#ifdef sgi
-	if(oflags & O_DSYNC)
-		strcat(flags,"O_DSYNC,");
-	if(oflags & O_RSYNC)
-		strcat(flags,"O_RSYNC,");
-#endif
 
 	return(strdup(flags));
 }
@@ -1083,11 +978,7 @@ format_rw(
 	void		*buffer,
 	int		signo,
 	char		*pattern,
-#ifdef CRAY
-	struct	iosw	*iosw
-#else
 	void		*iosw
-#endif
 	)
 {
 	static char		*errbuf=NULL;
@@ -1155,44 +1046,6 @@ format_rw(
 	return errbuf;
 }
 
-#ifdef CRAY
-char *
-format_sds(
-	struct	io_req	*ioreq,
-	void		*buffer,
-	int		sds,
-	char		*pattern
-	)
-{
-	int			i;
-	static char		*errbuf=NULL;
-	char			*cp;
-
-	struct ssread_req	*ssreadp = &ioreq->r_data.ssread;
-	struct sswrite_req	*sswritep = &ioreq->r_data.sswrite;
-
-	if(errbuf == NULL)
-		errbuf = (char *)malloc(32768);
-
-	cp = errbuf;
-	cp += sprintf(cp, "Request number %d\n", Reqno);
-
-
-	switch (ioreq->r_type) {
-	case SSREAD:
-		cp += sprintf(cp, "syscall:  ssread(%#o, %#o, %d)\n",
-			      buffer, sds, ssreadp->r_nbytes);
-		break;
-
-	case SSWRITE:
-		cp += sprintf(cp, "syscall:  sswrite(%#o, %#o, %d) - pattern was %s\n",
-			      buffer, sds, sswritep->r_nbytes, pattern);
-		break;
-	}
-	return errbuf;
-}
-#endif /* CRAY */
-
 /*
  * Perform the various sorts of disk reads
  */
@@ -1203,10 +1056,6 @@ struct io_req	*req;
 {
 	int	    	    	fd, offset, nbytes, oflags, rval;
 	char    	    	*addr, *file;
-#ifdef CRAY
-	struct aio_info		*aiop;
-	int			aio_id, aio_strat, signo;
-#endif
 #ifndef NO_XFS
 	struct fd_cache		*fdc;
 #endif
@@ -1241,28 +1090,6 @@ struct io_req	*req;
 #define wtob(x)	(x * sizeof(UINT64_T))
 #endif
 
-#ifdef CRAY
-	if (oflags & O_SSD) {
-		if (alloc_sds(nbytes) == -1)
-			return -1;
-
-		addr = (char *)Sdsptr;
-	} else {
-		if ((rval = alloc_mem(nbytes + wtob(1) * 2 + MPP_BUMP * sizeof(UINT64_T))) < 0) {
-			return rval;
-		}
-
-		addr = Memptr;
-
-		/*
-		 * if io is not raw, bump the offset by a random amount
-		 * to generate non-word-aligned io.
-		 */
-		if (! (req->r_data.read.r_uflags & F_WORD_ALIGNED)) {
-			addr += random_range(0, wtob(1) - 1, 1, NULL);
-		}
-	}
-#else
 #ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
@@ -1290,8 +1117,7 @@ struct io_req	*req;
 	}
 
 	addr = Memptr;
-#endif	/* !CRAY && sgi */
-#endif	/* CRAY */
+#endif	/* !NO_XFS */
 
 
 	switch (req->r_type) {
@@ -1320,66 +1146,6 @@ struct io_req	*req;
 			return -1;
 		}
 		break;
-
-#ifdef CRAY
-	case READA:
-		/*
-		 * Async read
-		 */
-
-	        /* move to the desired file position. */
-		if (lseek(fd, offset, SEEK_SET) == -1) {
-			doio_fprintf(stderr,
-				     "lseek(%d, %d, SEEK_SET) failed:  %s (%d)\n",
-				     fd, offset, SYSERR, errno);
-			return -1;
-		}
-
-		aio_strat = req->r_data.read.r_aio_strat;
-		signo = (aio_strat == A_SIGNAL) ? SIGUSR1 : 0;
-
-		aio_id = aio_register(fd, aio_strat, signo);
-		aiop = aio_slot(aio_id);
-
-		if (reada(fd, addr, nbytes, &aiop->iosw, signo) == -1) {
-			doio_fprintf(stderr, "reada() failed: %s (%d)\n%s\n",
-				     SYSERR, errno,
-				     format_rw(req, fd, addr, signo, NULL, &aiop->iosw));
-			aio_unregister(aio_id);
-			doio_upanic(U_RVAL);
-			rval = -1;
-		} else {
-			/*
-			 * Wait for io to complete
-			 */
-
-			aio_wait(aio_id);
-
-			/*
-			 * make sure the io completed without error
-			 */
-
-			if (aiop->iosw.sw_count != nbytes) {
-				doio_fprintf(stderr,
-					     "Bad iosw from reada()\nExpected (%d,%d,%d), got (%d,%d,%d)\n%s\n",
-					     1, 0, nbytes,
-					     aiop->iosw.sw_flag,
-					     aiop->iosw.sw_error,
-					     aiop->iosw.sw_count,
-				     format_rw(req, fd, addr, signo, NULL, &aiop->iosw));
-				aio_unregister(aio_id);
-				doio_upanic(U_IOSW);
-				rval = -1;
-			} else {
-				aio_unregister(aio_id);
-				rval = 0;
-			}
-		}
-
-		if (rval == -1)
-			return rval;
-		break;
-#endif	/* CRAY */
 	}
 
 	return 0;		/* if we get here, everything went ok */
@@ -1401,10 +1167,6 @@ struct io_req	*req;
 	long    	    	offset, woffset = 0;
 	char    	    	*addr, pattern, *file, *msg;
 	struct wlog_rec		wrec;
-#ifdef CRAY
-	int			aio_strat, aio_id;
-	struct aio_info		*aiop;
-#endif
 #ifndef NO_XFS
 	struct fd_cache		*fdc;
 #endif
@@ -1444,54 +1206,6 @@ struct io_req	*req;
 	 * Allocate SDS space for backdoor write if desired
 	 */
 
-#ifdef CRAY
-	if (oflags & O_SSD) {
-#ifndef _CRAYMPP
-		if ((rval = alloc_mem(nbytes + wtob(1))) < 0) {
-			return rval;
-		}
-
-		(*Data_Fill)(Memptr, nbytes, Pattern, Pattern_Length, 0);
-		/*pattern_fill(Memptr, nbytes, Pattern, Pattern_Length, 0);*/
-
-		if (alloc_sds(nbytes) == -1)
-			return -1;
-
-		if (sswrite((long)Memptr, Sdsptr, btoc(nbytes)) == -1) {
-			doio_fprintf(stderr, "sswrite(%d, %d, %d) failed:  %s (%d)\n",
-				     (long)Memptr, Sdsptr, btoc(nbytes), 
-				     SYSERR, errno);
-			fflush(stderr);
-			return -1;
-		}
-
-		addr = (char *)Sdsptr;
-#else
-		doio_fprintf(stderr, "Invalid O_SSD flag was generated for MPP system\n");
-		fflush(stderr);
-		return -1;
-#endif /* !CRAYMPP */
-	} else {
-		if ((rval = alloc_mem(nbytes + wtob(1)) < 0)) {
-			return rval;
-		}
-
-		addr = Memptr;
-
-		/*
-		 * if io is not raw, bump the offset by a random amount
-		 * to generate non-word-aligned io.
-		 */
-
-		if (! (req->r_data.write.r_uflags & F_WORD_ALIGNED)) {
-			addr += random_range(0, wtob(1) - 1, 1, NULL);
-		}
-
-		(*Data_Fill)(Memptr, nbytes, Pattern, Pattern_Length, 0);
-		if( addr != Memptr )
-			memmove( addr, Memptr, nbytes);
-	}
-#else /* CRAY */
 #ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
@@ -1528,7 +1242,6 @@ struct io_req	*req;
 	if( addr != Memptr )
 		memmove( addr, Memptr, nbytes);
 #endif /* sgi */
-#endif /* CRAY */
 
 	rval = -1;
 	got_lock = 0;
@@ -1625,68 +1338,6 @@ struct io_req	*req;
 		}
 
 		break;
-
-#ifdef CRAY
-	case WRITEA:
-		/*
-		 * async write
-		 */
-		if (lseek(fd, offset, SEEK_SET) == -1) {
-			doio_fprintf(stderr,
-				     "lseek(%d, %d, SEEK_SET) failed:  %s (%d)\n",
-				     fd, offset, SYSERR, errno);
-			return -1;
-		}
-
-		aio_strat = req->r_data.write.r_aio_strat;
-		signo = (aio_strat == A_SIGNAL) ? SIGUSR1 : 0;
-
-		aio_id = aio_register(fd, aio_strat, signo);
-		aiop = aio_slot(aio_id);
-
-		/*
-		 * init iosw and do the async write
-		 */
-
-		if (writea(fd, addr, nbytes, &aiop->iosw, signo) == -1) {
-			doio_fprintf(stderr,
-				     "writea() failed: %s (%d)\n%s\n",
-				     SYSERR, errno,
-				     format_rw(req, fd, addr, -1, Pattern, NULL));
-			doio_upanic(U_RVAL);
-			aio_unregister(aio_id);
-			rval = -1;
-		} else {
-
-			/*
-			 * Wait for io to complete
-			 */
-
-			aio_wait(aio_id);
-
-			/*
-			 * check that iosw is ok
-			 */
-
-			if (aiop->iosw.sw_count != nbytes) {
-				doio_fprintf(stderr,
-					     "Bad iosw from writea()\nExpected (%d,%d,%d), got (%d,%d,%d)\n%s\n",
-					     1, 0, nbytes,
-					     aiop->iosw.sw_flag,
-					     aiop->iosw.sw_error,
-					     aiop->iosw.sw_count,
-					     format_rw(req, fd, addr, -1, Pattern, &aiop->iosw));
-				aio_unregister(aio_id);
-				doio_upanic(U_IOSW);
-				rval = -1;
-			} else {
-				aio_unregister(aio_id);
-				rval = 0;
-			}
-		}
-		break;
-
-#endif /* CRAY */
 	}
 
 	/*
@@ -1701,11 +1352,7 @@ struct io_req	*req;
 		if (msg != NULL) {
 		  	doio_fprintf(stderr, "%s%s\n",
 				     msg,
-#ifdef CRAY
-				     format_rw(req, fd, addr, -1, Pattern, &aiop->iosw)
-#else
 				     format_rw(req, fd, addr, -1, Pattern, NULL)
-#endif
 				);
 			doio_upanic(U_CORRUPTION);
 			exit(E_COMPARE);
@@ -1773,515 +1420,97 @@ int	nbytes;
 	return 0;
 }
 
-/*
- * Perform a listio request.
+int
+do_listio(req)
+struct io_req	*req;
+{
+	return -1;
+}
+
+/* ---------------------------------------------------------------------------
+ *
+ * A new paradigm of doing the r/w system call where there is a "stub"
+ * function that builds the info for the system call, then does the system
+ * call; this is called by code that is common to all system calls and does
+ * the syscall return checking, async I/O wait, iosw check, etc.
+ *
+ * Flags:
+ *	WRITE, ASYNC, SSD/SDS,
+ *	FILE_LOCK, WRITE_LOG, VERIFY_DATA,
  */
 
-#ifdef CRAY
+struct	status {
+	int	rval;		/* syscall return */
+	int	err;		/* errno */
+	int	*aioid;		/* list of async I/O structures */
+};
+
+struct syscall_info {
+	char		*sy_name;
+	int		sy_type;
+	struct status	*(*sy_syscall)();
+	int		(*sy_buffer)();
+	char		*(*sy_format)();
+	int		sy_flags;
+	int		sy_bits;
+};
+
+#define	SY_WRITE		00001
+#define	SY_ASYNC		00010
+#define	SY_IOSW			00020
+#define	SY_SDS			00100
+
 char *
-format_listio(
-	struct	io_req	*ioreq,
-	int		lcmd,
-	struct listreq	*list,
-	int		nent,
-	int		fd,
-	char		*pattern
-	)
+fmt_ioreq(struct io_req *ioreq, struct syscall_info *sy, int fd)
 {
-	static	char		*errbuf=NULL;
-	struct	listio_req	*liop = &ioreq->r_data.listio;
-	struct	listreq		*listreq;
-	char			*cp, *cmd, *opcode, *aio_strat;
-	int			i;
-
-	switch (lcmd) {
-	case LC_START:	cmd = "LC_START";	break;
-	case LC_WAIT:	cmd = "LC_WAIT";	break;
-	default:	cmd = "???";		break;
-	}
+	static char		*errbuf=NULL;
+	char			*cp;
+	struct rw_req		*io;
+	struct smap		*aname;
 
 	if(errbuf == NULL)
 		errbuf = (char *)malloc(32768);
 
+	io = &ioreq->r_data.io;
+
+	/*
+	 * Look up async I/O completion strategy
+	 */
+	for(aname=aionames;
+	    aname->value != -1 && aname->value != io->r_aio_strat;
+	    aname++)
+		;
+
 	cp = errbuf;
 	cp += sprintf(cp, "Request number %d\n", Reqno);
 
-	cp += sprintf(cp, "syscall:  listio(%s, %#o, %d)\n\n",
-		      cmd, list, nent);
+	cp += sprintf(cp, "          fd %d is file %s - open flags are %#o %s\n",
+		      fd, io->r_file, io->r_oflags, format_oflags(io->r_oflags));
 
-	aio_strat = format_strat(liop->r_aio_strat);
+	if(sy->sy_flags & SY_WRITE) {
+		cp += sprintf(cp, "          write done at file offset %d - pattern is %c (%#o)\n",
+			      io->r_offset,
+			      (io->r_pattern == '\0') ? '?' : io->r_pattern,
+			      io->r_pattern);
+	} else {
+		cp += sprintf(cp, "          read done at file offset %d\n",
+		      io->r_offset);
+	}
 
-	for (i = 0; i < nent; i++) {
-		cp += sprintf(cp, "struct lioreq for request element %d\n", i);
-		cp += sprintf(cp, "----------------------------------------\n");
+	if(sy->sy_flags & SY_ASYNC) {
+		cp += sprintf(cp, "          async io completion strategy is %s\n",
+			      aname->string);
+	}
 
-		listreq = list + i;
+	cp += sprintf(cp, "          number of requests is %d, strides per request is %d\n",
+		      io->r_nent, io->r_nstrides);
 
-		switch (listreq->li_opcode) {
-		case LO_READ:	opcode = "LO_READ";	break;
-		case LO_WRITE:	opcode = "LO_WRITE";	break;
-		default:	opcode = "???";		break;
-		}
-			
-		cp += sprintf(cp, "          li_opcode =    %s\n", opcode);
-		cp += sprintf(cp, "          li_drvr =      %#o\n", listreq->li_drvr);
-		cp += sprintf(cp, "          li_flags =     %#o\n", listreq->li_flags);
-		cp += sprintf(cp, "          li_offset =    %d\n", listreq->li_offset);
-		cp += sprintf(cp, "          li_fildes =    %d\n", listreq->li_fildes);
-		cp += sprintf(cp, "          li_buf =       %#o\n", listreq->li_buf);
-		cp += sprintf(cp, "          li_nbyte =     %d\n", listreq->li_nbyte);
-		cp += sprintf(cp, "          li_status =    %#o (%d, %d, %d)\n", listreq->li_status, listreq->li_status->sw_flag, listreq->li_status->sw_error, listreq->li_status->sw_count);
-		cp += sprintf(cp, "          li_signo =     %d\n", listreq->li_signo);
-		cp += sprintf(cp, "          li_nstride =   %d\n", listreq->li_nstride);
-		cp += sprintf(cp, "          li_filstride = %d\n", listreq->li_filstride);
-		cp += sprintf(cp, "          li_memstride = %d\n", listreq->li_memstride);
-		cp += sprintf(cp, "          io completion strategy is %s\n", aio_strat);
-	}
-	return errbuf;
-}
-#endif /* CRAY */
-
-int
-do_listio(req)
-struct io_req	*req;
-{
-#ifdef CRAY
-	struct listio_req	*lio;
-	int	    	    	fd, oflags, signo, nb, i;
-	int	    	    	logged_write, rval, got_lock;
-	int			aio_strat, aio_id;
-	int			min_byte, max_byte;
-	int			mem_needed;
-	int		       	foffset, fstride, mstride, nstrides;
-	char			*moffset;
-	long    	    	offset, woffset;
-	char    	    	*addr, *msg;
-	sigset_t		block_mask, omask;
-	struct wlog_rec		wrec;
-	struct aio_info		*aiop;
-	struct listreq		lio_req;
-
-	lio = &req->r_data.listio;
-
-	/*
-	 * If bytes per stride is less than the stride size, drop the request
-	 * since it will cause overlapping strides, and we cannot predict
-	 * the order they will complete in.
-	 */
-
-	if (lio->r_filestride && abs(lio->r_filestride) < lio->r_nbytes) {
-		doio_fprintf(stderr, "do_listio():  Bogus listio request - abs(filestride) [%d] < nbytes [%d]\n",
-			     abs(lio->r_filestride), lio->r_nbytes);
-		return -1;
-	}
-
-	/*
-	 * Allocate core memory.  Initialize the data to be written.  Make
-	 * sure we get enough, based on the memstride.
-	 */
-
-	mem_needed = 
-		stride_bounds(0, lio->r_memstride, lio->r_nstrides,
-			      lio->r_nbytes, NULL, NULL);
-
-	if ((rval = alloc_mem(mem_needed + wtob(1))) < 0) {
-		return rval;
-	}
-
-	/*
-	 * Set the memory address pointer.  If the io is not raw, adjust
-	 * addr by a random amount, so that non-raw io is not necessarily
-	 * word aligned.
-	 */
-
-	addr = Memptr;
-
-	if (! (lio->r_uflags & F_WORD_ALIGNED)) {
-		addr += random_range(0, wtob(1) - 1, 1, NULL);
-	}
-
-	if (lio->r_opcode == LO_WRITE) {
-		Pattern[0] = lio->r_pattern;
-		(*Data_Fill)(Memptr, mem_needed, Pattern, Pattern_Length, 0);
-		if( addr != Memptr )
-			memmove( addr, Memptr, mem_needed);
-	}
-
-	/*
-	 * Get a descriptor to do the io on.  No need to do an lseek, as this
-	 * is encoded in the listio request.
-	 */
-
-	if ((fd = alloc_fd(lio->r_file, lio->r_oflags)) == -1) {
-		return -1;
-	}
-
-	rval = -1;
-	got_lock = 0;
-	logged_write = 0;
-
-	/*
-	 * If the opcode is LO_WRITE, lock all regions of the file that
-	 * are touched by this listio request.  Currently, we use
-	 * stride_bounds() to figure out the min and max bytes affected, and
-	 * lock the entire region, regardless of the file stride.
-	 */
-
-	if (lio->r_opcode == LO_WRITE && k_opt) {
-		stride_bounds(lio->r_offset,
-			      lio->r_filestride, lio->r_nstrides,
-			      lio->r_nbytes, &min_byte, &max_byte);
-
-		if (lock_file_region(lio->r_file, fd, F_WRLCK,
-				     min_byte, (max_byte-min_byte+1)) < 0) {
-			doio_fprintf(stderr, "stride_bounds(%d, %d, %d, %d, ..., ...) set min_byte to %d, max_byte to %d\n",
-				     lio->r_offset, lio->r_filestride,
-				     lio->r_nstrides, lio->r_nbytes, min_byte,
-				     max_byte);
-			return -1;
-		} else {
-			got_lock = 1;
-		}
-	}
-
-	/*
-	 * async write
-	 */
-
-	aio_strat = lio->r_aio_strat;
-	signo = (aio_strat == A_SIGNAL) ? SIGUSR1 : 0;
-
-	aio_id = aio_register(fd, aio_strat, signo);
-	aiop = aio_slot(aio_id);
-
-	/*
-	 * Form the listio request, and make the call.
-	 */
-
-	lio_req.li_opcode = lio->r_opcode;
-	lio_req.li_drvr = 0;
-	lio_req.li_flags = LF_LSEEK;
-	lio_req.li_offset = lio->r_offset;
-	lio_req.li_fildes = fd;
-
-	if (lio->r_memstride >= 0 || lio->r_nstrides <= 1) {
-		lio_req.li_buf = addr;
-	} else {
-		lio_req.li_buf = addr + mem_needed - lio->r_nbytes;
-	}
-
-	lio_req.li_nbyte = lio->r_nbytes;
-	lio_req.li_status = &aiop->iosw;
-	lio_req.li_signo = signo;
-	lio_req.li_nstride = lio->r_nstrides;
-	lio_req.li_filstride = lio->r_filestride;
-	lio_req.li_memstride = lio->r_memstride;
-
-	/*
-	 * If signo != 0, block signo while we're in the system call, so that
-	 * we don't get interrupted syscall failures.
-	 */
-
-	if (signo) {
-		sigemptyset(&block_mask);
-		sigaddset(&block_mask, signo);
-		sigprocmask(SIG_BLOCK, &block_mask, &omask);
-	}
-
-	if (listio(lio->r_cmd, &lio_req, 1) < 0) {
-		doio_fprintf(stderr,
-			     "listio() failed: %s (%d)\n%s\n",
-			     SYSERR, errno,
-			     format_listio(req, lio->r_cmd, &lio_req, 1, fd, Pattern));
-		aio_unregister(aio_id);
-		doio_upanic(U_RVAL);
-		goto lio_done;
-	}
-
-	if (signo) {
-		sigprocmask(SIG_SETMASK, &omask, NULL);
-	}
-
-	/*
-	 * Wait for io to complete
-	 */
-
-	aio_wait(aio_id);
-
-	nstrides = lio->r_nstrides ? lio->r_nstrides : 1;
-	if (aiop->iosw.sw_count != lio->r_nbytes * nstrides) {
-		doio_fprintf(stderr,
-			     "Bad iosw from listio()\nExpected (%d,%d,%d), got (%d,%d,%d)\n%s\n",
-			     1, 0, lio->r_nbytes * lio->r_nstrides,
-			     aiop->iosw.sw_flag,
-			     aiop->iosw.sw_error, aiop->iosw.sw_count,
-			     format_listio(req, lio->r_cmd, &lio_req, 1, fd, Pattern));
-		aio_unregister(aio_id);
-		doio_upanic(U_IOSW);
-		goto lio_done;
-	} 
-
-	aio_unregister(aio_id);
-
-	/*
-	 * Verify that the data was written correctly - check_file() returns
-	 * a non-null pointer which contains an error message if there are
-	 * problems.
-	 *
-	 * For listio, we basically have to make 1 call to check_file for each
-	 * stride.
-	 */
-
-	if (v_opt && lio_req.li_opcode == LO_WRITE) {
-		fstride = lio->r_filestride ? lio->r_filestride : lio->r_nbytes;
-		mstride = lio->r_memstride ? lio->r_memstride : lio->r_nbytes;
-		foffset = lio->r_offset;
-
-		if (mstride> 0 || lio->r_nstrides <= 1) {
-			moffset = addr;
-		} else {
-			moffset = addr + mem_needed - lio->r_nbytes;
-		}
-
-		for (i = 0; i < lio_req.li_nstride; i++) {
-			msg = check_file(lio->r_file,
-					 foffset, lio->r_nbytes,
-					 Pattern, Pattern_Length,
-					 moffset - addr,
-					 lio->r_oflags & O_PARALLEL);
-
-			if (msg != NULL) {
-				doio_fprintf(stderr, "%s\n%s\n",
-					     msg,
-			     format_listio(req, lio->r_cmd, &lio_req, 1, fd, Pattern));
-				doio_upanic(U_CORRUPTION);
-	    			exit(E_COMPARE);
-			}
-
-			moffset += mstride;
-			foffset += fstride;
-		}
-
-	}
-
-	rval = 0;
-
- lio_done:
-
-	/*
-	 * General cleanup ...
-	 *
-	 */
-
-	/*
-	 * Release file locks if necessary
-	 */
-
-	if (got_lock) {
-		if (lock_file_region(lio->r_file, fd, F_UNLCK,
-				     min_byte, (max_byte-min_byte+1)) < 0) {
-			return -1;
-		}
-	}
-
-	return rval;
-#else
-	return -1;
-#endif
-}
-
-/*
- * perform ssread/sswrite operations
- */
-
-#ifdef _CRAY1
-
-int
-do_ssdio(req)
-struct io_req	*req;
-{
-	int	    nbytes, nb;
-	char    errbuf[BSIZE];
-
-	nbytes = req->r_data.ssread.r_nbytes;
-
-	/*
-	 * Grab core and sds space
-	 */
-
-	if ((nb = alloc_mem(nbytes)) < 0)
-		return nb;
-
-	if (alloc_sds(nbytes) == -1)
-		return -1;
-
-	if (req->r_type == SSWRITE) {
-
-		/*
-		 * Init data and ship it to the ssd
-		 */
-
-		Pattern[0] = req->r_data.sswrite.r_pattern;
-		/*pattern_fill(Memptr, nbytes, Pattern, Pattern_Length, 0);*/
-		(*Data_Fill)(Memptr, nbytes, Pattern, Pattern_Length, 0);
-
-		if (sswrite((long)Memptr, (long)Sdsptr, btoc(nbytes)) == -1) {
-			doio_fprintf(stderr, "sswrite() failed:  %s (%d)\n%s\n",
-				     SYSERR, errno,
-				     format_sds(req, Memptr, Sdsptr, Pattern));
-			doio_upanic(U_RVAL);
-			return -1;
-		}
-	} else {
-		/*
-		 * read from sds
-		 */
-
-		if (ssread((long)Memptr, (long)Sdsptr, btoc(nbytes)) == -1) {
-			doio_fprintf(stderr, "ssread() failed: %s (%d)\n%s\n",
-				     SYSERR, errno,
-				     format_sds(req, Memptr, Sdsptr, Pattern));
-
-			doio_upanic(U_RVAL);
-			return -1;
-		}
-	}
-
-	/*
-	 * Verify data if SSWRITE and v_opt
-	 */
-
-	if (v_opt && req->r_type == SSWRITE) {
-		ssread((long)Memptr, (long)Sdsptr, btoc(nbytes));
-
-		if (pattern_check(Memptr, nbytes, Pattern, Pattern_Length, 0) == -1) {
-			doio_fprintf(stderr,
-				     "sds DATA COMPARE ERROR - ABORTING\n%s\n",
-				     format_sds(req, Memptr, Sdsptr, Pattern));
-
-			doio_upanic(U_CORRUPTION);
-			exit(E_COMPARE);
-		}
-	}
-}
-
-#else
-
-#ifdef CRAY
-
-int
-do_ssdio(req)
-struct io_req	*req;
-{
-	doio_fprintf(stderr,
-		     "Internal Error - do_ssdio() called on a non-cray1 system\n");
-	alloc_mem(-1);
-	exit(E_INTERNAL);
-}
-
-#endif
-
-#endif /* _CRAY1 */
-
-
-/* ---------------------------------------------------------------------------
- * 
- * A new paradigm of doing the r/w system call where there is a "stub"
- * function that builds the info for the system call, then does the system
- * call; this is called by code that is common to all system calls and does
- * the syscall return checking, async I/O wait, iosw check, etc.
- *
- * Flags:
- *	WRITE, ASYNC, SSD/SDS, 
- *	FILE_LOCK, WRITE_LOG, VERIFY_DATA,
- */
-
-struct	status {
-	int	rval;		/* syscall return */
-	int	err;		/* errno */
-	int	*aioid;		/* list of async I/O structures */
-};
-
-struct syscall_info {
-	char		*sy_name;
-	int		sy_type;
-	struct status	*(*sy_syscall)();
-	int		(*sy_buffer)();
-	char		*(*sy_format)();
-	int		sy_flags;
-	int		sy_bits;
-};
-
-#define	SY_WRITE		00001
-#define	SY_ASYNC		00010
-#define	SY_IOSW			00020
-#define	SY_SDS			00100
-
-char *
-fmt_ioreq(struct io_req *ioreq, struct syscall_info *sy, int fd)
-{
-	static char		*errbuf=NULL;
-	char			*cp;
-	struct rw_req		*io;
-	struct smap		*aname;
-#ifdef CRAY
-	struct stat		sbuf;
-#endif
-
-	if(errbuf == NULL)
-		errbuf = (char *)malloc(32768);
-
-	io = &ioreq->r_data.io;
-
-	/*
-	 * Look up async I/O completion strategy
-	 */
-	for(aname=aionames;
-	    aname->value != -1 && aname->value != io->r_aio_strat;
-	    aname++)
-		;
-
-	cp = errbuf;
-	cp += sprintf(cp, "Request number %d\n", Reqno);
-
-	cp += sprintf(cp, "          fd %d is file %s - open flags are %#o %s\n",
-		      fd, io->r_file, io->r_oflags, format_oflags(io->r_oflags));
-
-	if(sy->sy_flags & SY_WRITE) {
-		cp += sprintf(cp, "          write done at file offset %d - pattern is %c (%#o)\n",
-			      io->r_offset,
-			      (io->r_pattern == '\0') ? '?' : io->r_pattern, 
-			      io->r_pattern);
-	} else {
-		cp += sprintf(cp, "          read done at file offset %d\n",
-		      io->r_offset);
-	}
-
-	if(sy->sy_flags & SY_ASYNC) {
-		cp += sprintf(cp, "          async io completion strategy is %s\n",
-			      aname->string);
-	}
-
-	cp += sprintf(cp, "          number of requests is %d, strides per request is %d\n",
-		      io->r_nent, io->r_nstrides);
-
-	cp += sprintf(cp, "          i/o byte count = %d\n",
-		      io->r_nbytes);
+	cp += sprintf(cp, "          i/o byte count = %d\n",
+		      io->r_nbytes);
 
 	cp += sprintf(cp, "          memory alignment is %s\n",
 		      (io->r_uflags & F_WORD_ALIGNED) ? "aligned" : "unaligned");
 
-#ifdef CRAY
-	if(io->r_oflags & O_RAW) {
-		cp += sprintf(cp, "          RAW I/O: offset %% 4096 = %d length %% 4096 = %d\n",
-			      io->r_offset % 4096, io->r_nbytes % 4096);
-		fstat(fd, &sbuf);
-		cp += sprintf(cp, "          optimal file xfer size: small: %d large: %d\n",
-			      sbuf.st_blksize, sbuf.st_oblksize);
-		cp += sprintf(cp, "          cblks %d cbits %#o\n",
-			      sbuf.st_cblks, sbuf.st_cbits);
-	}
-#endif
 #ifndef NO_XFS
 	if(io->r_oflags & O_DIRECT) {
 		struct dioattr	finfo;
@@ -2307,136 +1536,6 @@ fmt_ioreq(struct io_req *ioreq, struct s
 	return(errbuf);
 }
 
-/*
- * Issue listio requests
- */
-#ifdef CRAY
-struct status *
-sy_listio(req, sysc, fd, addr)
-struct io_req	*req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-{
-	int		offset, nbytes, nstrides, nents, aio_strat;
-	int		aio_id, signo, o, i, lc;
-	char    	*a;
-	struct listreq	*lio_req, *l;
-	struct aio_info	*aiop;
-	struct status	*status;
-
-	/*
-	 * Initialize common fields - assumes r_oflags, r_file, r_offset, and
-	 * r_nbytes are at the same offset in the read_req and reada_req
-	 * structures.
-	 */
-	offset	  = req->r_data.io.r_offset;
-	nbytes	  = req->r_data.io.r_nbytes;
-	nstrides  = req->r_data.io.r_nstrides;
-	nents     = req->r_data.io.r_nent;
-	aio_strat = req->r_data.io.r_aio_strat;
-
-	lc = (sysc->sy_flags & SY_ASYNC) ? LC_START : LC_WAIT;
-
-	status = (struct status *)malloc(sizeof(struct status));
-	if( status == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-		return NULL;
-	}
-	status->aioid = (int *)malloc( (nents+1) * sizeof(int) );
-	if( status->aioid == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-		return NULL;
-	}
-
-	signo = (aio_strat == A_SIGNAL) ? SIGUSR1 : 0;
-
-	lio_req = (struct listreq *)malloc(nents * sizeof(struct listreq));
-	if( lio_req == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-		return NULL;
-	}
-	for(l=lio_req,a=addr,o=offset,i=0;
-	    i < nents;
-	    l++, a+=nbytes, o+=nbytes, i++) {
-
-		aio_id = aio_register(fd, aio_strat, signo);
-		aiop = aio_slot(aio_id);
-		status->aioid[i] = aio_id;
-
-		l->li_opcode	= (sysc->sy_flags & SY_WRITE) ? LO_WRITE : LO_READ;
-		l->li_offset	= o;
-		l->li_fildes	= fd;
-		l->li_buf	= a;
-		l->li_nbyte	= nbytes;
-		l->li_status	= &aiop->iosw;
-		l->li_signo	= signo;
-		l->li_nstride	= nstrides;
-		l->li_filstride	= 0;
-		l->li_memstride	= 0;
-		l->li_drvr	= 0;
-		l->li_flags	= LF_LSEEK;
-	}
-
-	status->aioid[nents] = -1;		/* end sentinel */
-
-	if( (status->rval = listio(lc, lio_req, nents)) == -1) {
-		status->err = errno;
-	}
-
-	free(lio_req);
-	return(status);
-}
-
-/*
- * Calculate the size of a request in bytes and min/max boundaries
- *
- * This assumes filestride & memstride = 0.
- */
-int
-listio_mem(struct io_req *req, int offset, int fmstride,
-	   int *min, int *max)
-{
-	int	i, size;
-
-	size = stride_bounds(offset, fmstride,
-			     req->r_data.io.r_nstrides*req->r_data.io.r_nent,
-			     req->r_data.io.r_nbytes, min, max);
-	return(size);
-}
-
-char *
-fmt_listio(struct io_req *req, struct syscall_info *sy, int fd, char *addr)
-{
-	static char	*errbuf = NULL;
-	char		*cp;
-	char		*c, *opcode;
-	int		i;
-
-	if(errbuf == NULL){
-		errbuf = (char *)malloc(32768);
-		if( errbuf == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-			return NULL;
-		}
-	}
-
-	c = (sy->sy_flags & SY_ASYNC) ? "lc_wait" : "lc_start";
-
-	cp = errbuf;
-	cp += sprintf(cp, "syscall:  listio(%s, (?), %d)\n",
-		      c, req->r_data.io.r_nent);
-
-	cp += sprintf(cp, "          data buffer at %#o\n", addr);
-
-	return(errbuf);
-}
-#endif /* CRAY */
-
 struct status *
 sy_pread(req, sysc, fd, addr)
 struct io_req	*req;
@@ -2510,7 +1609,6 @@ fmt_pread(struct io_req *req, struct sys
 	return(errbuf);
 }
 
-#ifndef CRAY
 struct status *
 sy_readv(req, sysc, fd, addr)
 struct io_req	*req;
@@ -2584,116 +1682,6 @@ fmt_readv(struct io_req *req, struct sys
 		      sy->sy_name, fd);
 	return(errbuf);
 }
-#endif /* !CRAY */
-
-#ifdef sgi
-struct status *
-sy_aread(req, sysc, fd, addr)
-struct io_req *req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-{
-	struct status *sy_arw();
-	return sy_arw(req, sysc, fd, addr, 0);
-}
-
-struct status *
-sy_awrite(req, sysc, fd, addr)
-struct io_req *req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-{
-	struct status *sy_arw();
-	return sy_arw(req, sysc, fd, addr, 1);
-}
-
-/*
-  #define sy_aread(A, B, C, D)	sy_arw(A, B, C, D, 0)
-  #define sy_awrite(A, B, C, D)	sy_arw(A, B, C, D, 1)
- */
-
-struct status *
-sy_arw(req, sysc, fd, addr, rw)
-struct io_req *req;
-struct syscall_info *sysc;
-int fd;
-char *addr;
-int rw;
-{
-	/* POSIX 1003.1b-1993 Async read */
-	struct status		*status;
-	int	    	    	rc;
-	int			aio_id, aio_strat, signo;
-	struct aio_info		*aiop;
-
-	status = (struct status *)malloc(sizeof(struct status));
-	if( status == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-		return NULL;
-	}
-	aio_strat = req->r_data.io.r_aio_strat;
-	signo = (aio_strat == A_SIGNAL) ? SIGUSR1 : 0;
-
-	aio_id = aio_register(fd, aio_strat, signo);
-	aiop = aio_slot(aio_id);
-
-	memset( (void *)&aiop->aiocb, 0, sizeof(aiocb_t));
-
-	aiop->aiocb.aio_fildes = fd;
-	aiop->aiocb.aio_nbytes = req->r_data.io.r_nbytes;
-	aiop->aiocb.aio_offset = req->r_data.io.r_offset;
-	aiop->aiocb.aio_buf = addr;
-	aiop->aiocb.aio_reqprio = 0;	/* must be 0 */
-	aiop->aiocb.aio_lio_opcode = 0;
-
-	if(aio_strat == A_SIGNAL) {	/* siginfo(2) stuff */
-		aiop->aiocb.aio_sigevent.sigev_notify = SIGEV_SIGNAL;
-		aiop->aiocb.aio_sigevent.sigev_signo = signo;
-	} else if(aio_strat == A_CALLBACK) {
-		aiop->aiocb.aio_sigevent.sigev_signo = 0;
-		aiop->aiocb.aio_sigevent.sigev_notify = SIGEV_CALLBACK;
-		aiop->aiocb.aio_sigevent.sigev_func = cb_handler;
-		aiop->aiocb.aio_sigevent.sigev_value.sival_int = aio_id;
-	} else {
-		aiop->aiocb.aio_sigevent.sigev_notify = SIGEV_NONE;
-		aiop->aiocb.aio_sigevent.sigev_signo = 0;
-	}
-
-	if(rw)
-		rc = aio_write(&aiop->aiocb);
-	else
-		rc = aio_read(&aiop->aiocb);
-
-	status->aioid = (int *)malloc( 2 * sizeof(int) );
-	if( status->aioid == NULL ){
-		doio_fprintf(stderr, "malloc failed, %s/%d\n",
-			__FILE__, __LINE__);
-		return NULL;
-	}
-	status->aioid[0] = aio_id;
-	status->aioid[1] = -1;
-	status->rval = rc;
-	status->err = errno;
-	return(status);
-}
-
-char *
-fmt_aread(struct io_req *req, struct syscall_info *sy, int fd, char *addr)
-{
-	static char	errbuf[32768];
-	char		*cp;
-
-	cp = errbuf;
-	cp += sprintf(cp, "syscall:  %s(&aiop->aiocb)\n",
-		      sy->sy_name);
-	return(errbuf);
-}
-#endif /* sgi */
-
-#ifndef CRAY
 
 struct status *
 sy_mmread(req, sysc, fd, addr)
@@ -2809,72 +1797,10 @@ fmt_mmrw(struct io_req *req, struct sysc
 		      (unsigned long) memaddr, req->r_data.io.r_nbytes,
 		      (unsigned long) addr);
 		      
-	return(errbuf);
-}
-#endif /* !CRAY */
-
-struct syscall_info syscalls[] = {
-#ifdef CRAY
-	{ "listio-read-sync",		LREAD,
-	  sy_listio,	NULL,		fmt_listio,
-	  SY_IOSW
-	},
-	{ "listio-read-strides-sync",	LSREAD,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW
-	},
-	{ "listio-read-reqs-sync",	LEREAD,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW
-	},
-	{ "listio-read-async",		LREADA,
-	  sy_listio,	NULL,		fmt_listio,
-	  SY_IOSW | SY_ASYNC
-	},
-	{ "listio-read-strides-async",	LSREADA,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_ASYNC
-	},
-	{ "listio-read-reqs-async",	LEREADA,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_ASYNC
-	},
-	{ "listio-write-sync",		LWRITE,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE
-	},
-	{ "listio-write-strides-sync",	LSWRITE,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE
-	},
-	{ "listio-write-reqs-sync",	LEWRITE,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE
-	},
-	{ "listio-write-async",		LWRITEA,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE | SY_ASYNC
-	},
-	{ "listio-write-strides-async",	LSWRITEA,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE | SY_ASYNC
-	},
-	{ "listio-write-reqs-async",	LEWRITEA,
-	  sy_listio,	listio_mem,	fmt_listio,
-	  SY_IOSW | SY_WRITE | SY_ASYNC
-	},
-#endif
+	return(errbuf);
+}
 
-#ifdef sgi
-	{ "aread",			AREAD,
-	  sy_aread,	NULL,		fmt_aread,
-	  SY_IOSW | SY_ASYNC
-	},
-	{ "awrite",			AWRITE,
-	  sy_awrite,	NULL,		fmt_aread,
-	  SY_IOSW | SY_WRITE | SY_ASYNC
-	},
-#endif
+struct syscall_info syscalls[] = {
 	{ "pread",			PREAD,
 	  sy_pread,	NULL,		fmt_pread,
 	  0
@@ -2884,7 +1810,6 @@ struct syscall_info syscalls[] = {
 	  SY_WRITE
 	},
 
-#ifndef CRAY
 	{ "readv",			READV,
 	  sy_readv,	NULL,		fmt_readv,
 	  0
@@ -2901,7 +1826,6 @@ struct syscall_info syscalls[] = {
 	  sy_mmwrite,	NULL,		fmt_mmrw,
 	  SY_WRITE
 	},
-#endif
 
 	{ NULL,				0,
 	  0,		0,		0,
@@ -2922,13 +1846,6 @@ do_rw(req)
 	struct status		*s;
 	struct wlog_rec		wrec;
 	struct syscall_info	*sy;
-#ifdef sgi
-	struct aio_info		*aiop;
-#endif
-#ifdef CRAY
-	/* REFERENCED */
-	struct iosw		*iosw;
-#endif
 #ifndef NO_XFS
 	struct fd_cache		*fdc;
 #endif
@@ -2990,11 +1907,6 @@ do_rw(req)
 		mem_needed = nbytes;
 	}
 
-#ifdef CRAY
-	if ((rval = alloc_mem(mem_needed + wtob(1) * 2 + MPP_BUMP * sizeof(UINT64_T))) < 0) {
-		return rval;
-	}
-#else
 #ifndef NO_XFS
 	/* get memory alignment for using DIRECT I/O */
 	fdc = alloc_fdcache(file, oflags);
@@ -3007,7 +1919,6 @@ do_rw(req)
 		return rval;
 	}
 #endif
-#endif /* CRAY */
 
 	Pattern[0] = pattern;
 
@@ -3016,35 +1927,9 @@ do_rw(req)
 	 */
 
 	if (oflags & O_SSD) {
-#ifdef CRAY
-#ifndef _CRAYMPP
-		if (alloc_sds(nbytes) == -1)
-			return -1;
-
-		if( sy->sy_flags & SY_WRITE ) {
-			/*pattern_fill(Memptr, mem_needed, Pattern, Pattern_Length, 0);*/
-			(*Data_Fill)(Memptr, nbytes, Pattern, Pattern_Length, 0);
-
-			if (sswrite((long)Memptr, Sdsptr, btoc(mem_needed)) == -1) {
-				doio_fprintf(stderr, "sswrite(%d, %d, %d) failed:  %s (%d)\n",
-					     (long)Memptr, Sdsptr, 
-					     btoc(mem_needed), SYSERR, errno);
-				fflush(stderr);
-				return -1;
-			}
-		}
-
-		addr = (char *)Sdsptr;
-#else
-		doio_fprintf(stderr, "Invalid O_SSD flag was generated for MPP system\n");
-		fflush(stderr);
-		return -1;
-#endif /* _CRAYMPP */
-#else	/* CRAY */
 		doio_fprintf(stderr, "Invalid O_SSD flag was generated for non-Cray system\n");
 		fflush(stderr);
 		return -1;
-#endif	/* CRAY */
 	} else {
 		addr = Memptr;
 
@@ -3057,9 +1942,6 @@ do_rw(req)
 		 */
 
 		if (! (req->r_data.io.r_uflags & F_WORD_ALIGNED)) {
-#ifdef _CRAYMPP
-			addr += random_range(0, MPP_BUMP, 1, NULL) * sizeof(int);
-#endif
 			addr += random_range(0, wtob(1) - 1, 1, NULL);
 		}
 
@@ -3186,80 +2068,7 @@ do_rw(req)
 		 * structure.
 		 */
 
-		if( sy->sy_flags & SY_IOSW ) {
-#ifdef CRAY
-			for( i=0; i < nents; i++ ) {
-				if(s->aioid == NULL)
-					break; /* >>> error condition? */
-				aiop = aio_slot(s->aioid[i]);
-				iosw = &aiop->iosw;
-				if(iosw->sw_error != 0) {
-					doio_fprintf(stderr,
-						     "%s() iosw error set: %s\n%s\n%s\n",
-						     sy->sy_name,
-						     strerror(iosw->sw_error),
-						     fmt_ioreq(req, sy, fd),
-						     (*sy->sy_format)(req, sy, fd, addr));
-					doio_upanic(U_IOSW);
-					rval = -1;
-				} else if(iosw->sw_count != nbytes*nstrides) {
-					doio_fprintf(stderr,
-						     "Bad iosw from %s() #%d\nExpected (%d,%d,%d), got (%d,%d,%d)\n%s\n%s\n",
-						     sy->sy_name, i,
-						     1, 0, nbytes*nstrides,
-						     iosw->sw_flag,
-						     iosw->sw_error,
-						     iosw->sw_count,
-						     fmt_ioreq(req, sy, fd),
-						     (*sy->sy_format)(req, sy, fd, addr));
-					doio_upanic(U_IOSW);
-					rval = -1;
-				}
-
-				aio_unregister(s->aioid[i]);
-			}
-#endif /* CRAY */
-#ifdef sgi
-			for( i=0; s->aioid[i] != -1; i++ ) {
-				if(s->aioid == NULL) {
-					doio_fprintf(stderr,
-						     "aioid == NULL!\n");
-					break;
-				}
-				aiop = aio_slot(s->aioid[i]);
-
-				/*
-				 * make sure the io completed without error
-				 */
-				if (aiop->aio_errno != 0) {
-					doio_fprintf(stderr,
-						     "%s() aio error set: %s (%d)\n%s\n%s\n",
-						     sy->sy_name,
-						     strerror(aiop->aio_errno),
-						     aiop->aio_errno,
-						     fmt_ioreq(req, sy, fd),
-						     (*sy->sy_format)(req, sy, fd, addr));
-					doio_upanic(U_IOSW);
-					rval = -1;
-				} else if (aiop->aio_ret != nbytes) {
-					doio_fprintf(stderr,
-						     "Bad aio return from %s() #%d\nExpected (%d,%d), got (%d,%d)\n%s\n%s\n",
-						     sy->sy_name, i,
-						     0, nbytes,
-						     aiop->aio_errno,
-						     aiop->aio_ret,
-						     fmt_ioreq(req, sy, fd),
-						     (*sy->sy_format)(req, sy, fd, addr));
-					aio_unregister(s->aioid[i]);
-					doio_upanic(U_IOSW);
-					return -1;
-				} else {
-					aio_unregister(s->aioid[i]);
-					rval = 0;
-				}
-			}
-#endif /* sgi */
-		} else {
+		if( !(sy->sy_flags & SY_IOSW) ) {
 
 			if(s->rval != mem_needed) {
 				doio_fprintf(stderr,
@@ -3428,7 +2237,6 @@ do_xfsctl(req)
 /*
  *  fsync(2) and fdatasync(2)
  */
-#ifndef CRAY
 int
 do_sync(req)
 	struct io_req	*req;
@@ -3465,8 +2273,6 @@ do_sync(req)
 	}
 	return (rval == -1) ? -1 : 0;
 }
-#endif
-
 
 int
 doio_pat_fill(char *addr, int mem_needed, char *Pattern, int Pattern_Length,
@@ -3583,11 +2389,6 @@ int	fsa;
 		flags = Validation_Flags | O_RDONLY;
 	} else {
 		flags = O_RDONLY;
-		if (fsa) {
-#ifdef CRAY
-			flags |= O_PARALLEL | O_RAW | O_WELLFORMED;
-#endif
-		}
 	}
 
 	if ((fd = alloc_fd(file, flags)) == -1) {
@@ -3690,7 +2491,7 @@ doio_fprintf(FILE *stream, char *format,
  * Simple function for allocating core memory.  Uses Memsize and Memptr to
  * keep track of the current amount allocated.
  */
-#ifndef CRAY
+
 int
 alloc_mem(nbytes)
 int nbytes;
@@ -3703,9 +2504,6 @@ int nbytes;
 	char		filename[255];
 #ifdef linux
 	struct shmid_ds shm_ds;
-#endif
-
-#ifdef linux
 	bzero( &shm_ds, sizeof(struct shmid_ds) );
 #endif
 
@@ -3718,36 +2516,17 @@ int nbytes;
 
 			switch(Memalloc[me].memtype) {
 			case MEM_DATA:
-#ifdef sgi
-				if(Memalloc[me].flags & MEMF_MPIN)
-					munpin(Memalloc[me].space,
-					       Memalloc[me].size);
-#endif
 				free(Memalloc[me].space);
 				Memalloc[me].space = NULL;
 				Memptr = NULL;
 				Memsize = 0;
 				break;
 			case MEM_SHMEM:
-#ifdef sgi
-				if(Memalloc[me].flags & MEMF_MPIN)
-					munpin(Memalloc[me].space,
-					       Memalloc[me].size);
-#endif
 				shmdt(Memalloc[me].space);
 				Memalloc[me].space = NULL;
-#ifdef sgi
-				shmctl(Memalloc[me].fd, IPC_RMID);
-#else
 				shmctl(Memalloc[me].fd, IPC_RMID, &shm_ds);
-#endif
 				break;
 			case MEM_MMAP:
-#ifdef sgi
-				if(Memalloc[me].flags & MEMF_MPIN)
-					munpin(Memalloc[me].space,
-					       Memalloc[me].size);
-#endif
 				munmap(Memalloc[me].space, 
 				       Memalloc[me].size);
 				close(Memalloc[me].fd);
@@ -3778,10 +2557,6 @@ int nbytes;
 	case MEM_DATA:
 		if( nbytes > M->size ) {
 			if( M->space != NULL ){
-#ifdef sgi
-				if( M->flags & MEMF_MPIN )
-					munpin( M->space, M->size );
-#endif
 				free(M->space);
 			}
 			M->space = NULL;
@@ -3794,14 +2569,6 @@ int nbytes;
 					     nbytes, SYSERR, errno);
 				return -1;
 			}
-#ifdef sgi
-			if(M->flags & MEMF_MPIN) {
-				if( mpin(cp, nbytes) == -1 ) {
-					doio_fprintf(stderr, "mpin(0x%lx, %d) failed:  %s (%d)\n",
-					     cp, nbytes, SYSERR, errno);
-				}
-			}
-#endif
 			M->space = (void *)cp;
 			M->size = nbytes;
 		}
@@ -3810,10 +2577,6 @@ int nbytes;
 	case MEM_MMAP:
 		if( nbytes > M->size ) {
 			if( M->space != NULL ) {
-#ifdef sgi
-				if( M->flags & MEMF_MPIN )
-					munpin(M->space, M->size);
-#endif
 				munmap(M->space, M->size);
 				close(M->fd);
 				if( M->flags & MEMF_FILE )
@@ -3846,14 +2609,6 @@ int nbytes;
 			/* bias flags on MEMF_PRIVATE etc */
 			if(M->flags & MEMF_PRIVATE)
 				flags |= MAP_PRIVATE;
-#ifdef sgi
-			if(M->flags & MEMF_LOCAL)
-				flags |= MAP_LOCAL;
-			if(M->flags & MEMF_AUTORESRV)
-				flags |= MAP_AUTORESRV;
-			if(M->flags & MEMF_AUTOGROW)
-				flags |= MAP_AUTOGROW;
-#endif
 			if(M->flags & MEMF_SHARED)
 				flags |= MAP_SHARED;
 
@@ -3870,11 +2625,6 @@ int nbytes;
 					     M->name);
 				doio_fprintf(stderr, "\t%s%s%s%s%s",
 					     (flags & MAP_PRIVATE) ? "private " : "",
-#ifdef sgi
-					     (flags & MAP_LOCAL) ? "local " : "",
-					     (flags & MAP_AUTORESRV) ? "autoresrv " : "",
-					     (flags & MAP_AUTOGROW) ? "autogrow " : "",
-#endif
 					     (flags & MAP_SHARED) ? "shared" : "");
 				return(-1);
 			}
@@ -3884,16 +2634,7 @@ int nbytes;
 	case MEM_SHMEM:
 		if( nbytes > M->size ) {
 			if( M->space != NULL ) {
-#ifdef sgi
-				if( M->flags & MEMF_MPIN )
-					munpin(M->space, M->size);
-#endif
-				shmdt( M->space );
-#ifdef sgi
-				shmctl( M->fd, IPC_RMID );
-#else
 				shmctl( M->fd, IPC_RMID, &shm_ds );
-#endif
 			}
 			M->space = NULL;
 			M->size = 0;
@@ -3929,14 +2670,6 @@ int nbytes;
 					     shmid, SYSERR, errno);
 				return(-1);
 			}
-#ifdef sgi
-			if(M->flags & MEMF_MPIN) {
-				if( mpin(M->space, M->size) == -1 ) {
-					doio_fprintf(stderr, "mpin(0x%lx, %d) failed:  %s (%d)\n",
-						     M->space, M->size, SYSERR, errno);
-			    }
-			}
-#endif
 		}
 		break;
 
@@ -3952,123 +2685,6 @@ int nbytes;
 	mturn++;
 	return 0;
 }
-#endif /* !CRAY */
-
-#ifdef CRAY
-int
-alloc_mem(nbytes)
-int nbytes;
-{
-	char    *cp;
-	int	ip;
-	static	char	*malloc_space;
-
-	/*
-	 * The "unicos" version of this did some stuff with sbrk;
-	 * this caused problems with async I/O on irix, and now appears
-	 * to be causing problems with FSA I/O on unicos/mk.
-	 */
-#ifdef NOTDEF
-	if (nbytes > Memsize) {
-		if ((cp = (char *)sbrk(nbytes - Memsize)) == (char *)-1) {
-			doio_fprintf(stderr, "sbrk(%d) failed:  %s (%d)\n",
-				     nbytes - Memsize, SYSERR, errno);
-			return -1;
-		}
-
-		if (Memsize == 0)
-			Memptr = cp;
-		Memsize += nbytes - Memsize;
-	}
-#else
-
-	/* nbytes = -1 means "free all allocated memory" */
-	if( nbytes == -1 ) {
-		free( malloc_space );
-		Memptr = NULL;
-		Memsize = 0;
-		return 0;
-	}
-
-	if( nbytes > Memsize ) {
-	    if( Memsize != 0 )
-		free( malloc_space );
-
-	    if( (cp = malloc_space = malloc( nbytes )) == NULL ) {
-		doio_fprintf(stderr, "malloc(%d) failed:  %s (%d)\n",
-			     nbytes, SYSERR, errno);
-		return -1;
-	    }
-
-#ifdef _CRAYT3E
-	    /* T3E requires memory to be aligned on 0x40 word boundaries */
-	    ip = (int)cp;
-	    if( ip & 0x3F != 0 ) {
-		doio_fprintf(stderr, "malloc(%d) = 0x%x(0x%x) not aligned by 0x%x\n",
-			     nbytes, cp, ip, ip & 0x3f);
-
-		free(cp);
-		if( (cp = malloc_space = malloc( nbytes + 0x40 )) == NULL ) {
-		    doio_fprintf(stderr, "malloc(%d) failed:  %s (%d)\n",
-				 nbytes, SYSERR, errno);
-		    return -1;
-		}
-		ip = (int)cp;
-		cp += (0x40 - (ip & 0x3F));
-	    }
-#endif /* _CRAYT3E */
-	    Memptr = cp;
-	    Memsize = nbytes;
-	}
-#endif /* NOTDEF */
-	return 0;
-}
-#endif /* CRAY */
-
-/*
- * Simple function for allocating sds space.  Uses Sdssize and Sdsptr to
- * keep track of location and size of currently allocated chunk.
- */
-
-#ifdef _CRAY1
-
-int
-alloc_sds(nbytes)
-int nbytes;
-{
-	int nblks;
-
-	if (nbytes > Sdssize) {
-		if ((nblks = ssbreak(btoc(nbytes - Sdssize))) == -1) {
-			doio_fprintf(stderr, "ssbreak(%d) failed:  %s (%d)\n",
-				     btoc(nbytes - Sdssize), SYSERR, errno);
-			return -1;
-		}
-
-		Sdssize = ctob(nblks);
-		Sdsptr = 0;
-	}
-
-	return 0;
-}
-
-#else
-
-#ifdef CRAY
-
-int
-alloc_sds(nbytes)
-int	nbytes;
-{
-	doio_fprintf(stderr,
-		     "Internal Error - alloc_sds() called on a CRAY2 system\n");
-	alloc_mem(-1);
-	exit(E_INTERNAL);
-}
-
-#endif
-
-#endif /* _CRAY1 */
 
 /*
  * Function to maintain a file descriptor cache, so that doio does not have
@@ -4119,11 +2735,9 @@ int	oflags;
 			if (cp->c_fd != -1) {
 				close(cp->c_fd);
 			}
-#ifndef CRAY
 			if (cp->c_memaddr != NULL) {
 				munmap(cp->c_memaddr, cp->c_memlen);
 			}
-#endif
 		}
 
 		free(cache);
@@ -4146,11 +2760,7 @@ int	oflags;
 		if (cp->c_fd != -1 &&
 		    cp->c_oflags == oflags &&
 		    strcmp(cp->c_file, file) == 0) {
-#ifdef CRAY
-			cp->c_rtc = _rtc();
-#else
 			cp->c_rtc = Reqno;
-#endif
 			return cp;
 		}
 
@@ -4234,11 +2844,7 @@ int	oflags;
 	free_slot->c_fd = fd;
 	free_slot->c_oflags = oflags;
 	strcpy(free_slot->c_file, file);
-#ifdef CRAY
-	free_slot->c_rtc = _rtc();
-#else
 	free_slot->c_rtc = Reqno;
-#endif
 
 #ifndef NO_XFS
 	if (oflags & O_DIRECT) {
@@ -4257,10 +2863,8 @@ int	oflags;
 	free_slot->c_miniosz = finfo.d_miniosz;
 	free_slot->c_maxiosz = finfo.d_maxiosz;
 #endif
-#ifndef CRAY
 	free_slot->c_memaddr = NULL;
 	free_slot->c_memlen = 0;
-#endif
 
 	return free_slot;
 }
@@ -4272,104 +2876,6 @@ int	oflags;
  *
  */
 
-#ifdef sgi
-/*
- * "caller-id" for signals
- */
-void
-signal_info(int sig, siginfo_t *info, void *v)
-{
-	int haveit = 0;
-
-	if(info != NULL) {
-		switch(info->si_code) {
-		case SI_USER:
-			doio_fprintf(stderr,
-				     "signal_info: si_signo %d si_errno %d si_code SI_USER pid %d uid %d\n",
-				     info->si_signo, info->si_errno, 
-				     info->si_pid, info->si_uid);
-			haveit = 1;
-			break;
-
-		case SI_QUEUE:
-			doio_fprintf(stderr, "signal_info  si_signo %d si_code = SI_QUEUE\n",
-				     info->si_signo);
-			haveit = 1;
-			break;
-		}
-
-		if( ! haveit ){
-			if( (info->si_signo == SIGSEGV) ||
-			   (info->si_signo == SIGBUS) ){
-				doio_fprintf(stderr, "signal_info  si_signo %d si_errno %d si_code = %d  si_addr=%p  active_mmap_rw=%d havesigint=%d\n",
-					     info->si_signo, info->si_errno,
-					     info->si_code, info->si_addr,
-					     active_mmap_rw,
-					     havesigint);
-				haveit = 1;
-			   }
-		}
-
-		if( !haveit ){
-			doio_fprintf(stderr, "signal_info: si_signo %d si_errno %d unknown code %d\n",
-				     info->si_signo, info->si_errno,
-				     info->si_code);
-		}
-	} else {
-		doio_fprintf(stderr, "signal_info: sig %d\n", sig);
-	}
-}
-#endif
-
-#ifdef sgi
-void
-cleanup_handler(int sig, siginfo_t *info, void *v)
-{
-	havesigint=1; /* in case there's a followup signal */
-	/*signal_info(sig, info, v);*/	/* be quiet on "normal" kill */
-	alloc_mem(-1);
-	exit(0);
-}
-
-
-void
-die_handler(int sig, siginfo_t *info, void *v)
-{
-	doio_fprintf(stderr, "terminating on signal %d\n", sig);
-	signal_info(sig, info, v);
-	alloc_mem(-1);
-	exit(1);
-}
-
-void
-sigbus_handler(int sig, siginfo_t *info, void *v)
-{
-	/* While we are doing a memcpy to/from an mmapped region we can
-	   get a SIGBUS for a variety of reasons--and not all of them
-	   should be considered failures.
-
-	   Under normal conditions if we get a SIGINT it means we've been
-	   told to shutdown.  However, if we're currently doing the above-
-	   mentioned memcopy then the kernel will follow that SIGINT with
-	   a SIGBUS.  We can guess that we're in this situation by seeing
-	   that the si_errno field in the siginfo structure has EINTR as
-	   an errno.  (We might make the guess stronger by looking at the
-	   si_addr field to see that it's not faulting off the end of the
-	   mmapped region, but it seems that in such a case havesigint
-	   would not have been set so maybe that doesn't make the guess
-	   stronger.)
-	 */
-
-	
-	if( active_mmap_rw && havesigint && (info->si_errno == EINTR) ){
-		cleanup_handler( sig, info, v );
-	}
-	else{
-		die_handler( sig, info, v );
-	}
-}
-#else
-
 void
 cleanup_handler()
 {
@@ -4387,7 +2893,6 @@ int sig;
 	exit(1);
 }
 
-#ifndef CRAY
 void
 sigbus_handler(sig)
 int sig;
@@ -4402,9 +2907,6 @@ int sig;
 	else
 		die_handler(sig);
 }
-#endif /* !CRAY */
-#endif /* sgi */
-
 
 void
 noop_handler(sig)
@@ -4483,34 +2985,6 @@ dump_aio()
 	fprintf(stderr, "%d active async i/os\n", count);
 }
 
-
-#ifdef sgi
-/*
- * Signal handler called as a callback, not as a signal.
- * 'val' is the value from sigev_value and is assumed to be the
- * Aio_Info[] index.
- */
-void
-cb_handler(val)
-sigval_t val;
-{
-	struct aio_info	*aiop;
-
-/*printf("cb_handler requesting slot %d\n", val.sival_int);*/
-	aiop = aio_slot( val.sival_int );
-/*printf("cb_handler, aiop=%p\n", aiop);*/
-
-/*printf("%d in cb_handler\n", getpid() );*/
-	if (aiop->strategy == A_CALLBACK) {
-		aiop->signalled++;
-
-		if (aio_done(aiop)) {
-			aiop->done++;
-		}
-	}
-}
-#endif
-
 struct aio_info *
 aio_slot(aio_id)
 int	aio_id;
@@ -4563,9 +3037,6 @@ int		sig;
 	aiop->fd = fd;
 	aiop->strategy = strategy;
 	aiop->done = 0;
-#ifdef CRAY
-	bzero((char *)&aiop->iosw, sizeof(aiop->iosw));
-#endif
 
 	if (strategy == A_SIGNAL) {
 		aiop->sig = sig;
@@ -4610,111 +3081,6 @@ int	aio_id;
 #endif
 	sigset_t	sigset;
 	struct aio_info	*aiop;
-#ifdef CRAY
-	struct iosw	*ioswlist[1];
-#endif
-#ifdef sgi
-	const aiocb_t	*aioary[1];
-#endif
-	int r, cnt;
-
-
-	aiop = aio_slot(aio_id);
-/*printf("%d aiop B =%p\n", getpid(), aiop);*/
-
-	switch (aiop->strategy) {
-	case A_POLL:
-		while (! aio_done(aiop))
-			;
-		break;
-
-	case A_SIGNAL:
-		sigemptyset(&sigset);
-		sighold( aiop->sig );
-
-		while ( !aiop->signalled || !aiop->done ) {
-			sigsuspend(&sigset);
-			sighold( aiop->sig );
-		}
-		break;
-
-#ifdef CRAY
-	case A_RECALL:
-		ioswlist[0] = &aiop->iosw;
-		if (recall(aiop->fd, 1, ioswlist) < 0) {
-			doio_fprintf(stderr, "recall() failed:  %s (%d)\n",
-				     SYSERR, errno);
-			exit(E_SETUP);
-		}
-		break;
-
-#ifdef RECALL_SIZEOF
-
-	case A_RECALLA:
-		RECALL_INIT(mask);
-		RECALL_SET(mask, aiop->fd);
-		if (recalla(mask) < 0) {
-			doio_fprintf(stderr, "recalla() failed:  %s (%d)\n",
-				     SYSERR, errno);
-			exit(E_SETUP);
-		}
-
-		RECALL_CLR(mask, aiop->fd);
-		break;
-#endif
-
-	case A_RECALLS:
-		ioswlist[0] = &aiop->iosw;
-		if (recalls(1, ioswlist) < 0) {
-			doio_fprintf(stderr, "recalls failed:  %s (%d)\n",
-				SYSERR, errno);
-			exit(E_SETUP);
-		}
-		break;
-#endif	/* CRAY */
-
-#ifdef sgi
-	case A_CALLBACK:
-		aioary[0] = &aiop->aiocb;
-		cnt=0;
-		do {
-			r = aio_suspend(aioary, 1, NULL);
-			if( r == -1 ){
-				doio_fprintf(stderr, "aio_suspend failed: %s (%d)\n",
-					     SYSERR, errno );
-				exit(E_SETUP);
-			}
-			cnt++;
-		} while(aiop->done == 0);
-
-#if 0
-		/*
-		 * after having this set for a while, I've decided that
-		 * it's too noisy
-		 */
-		if(cnt > 1)
-			doio_fprintf(stderr, "aio_wait: callback wait took %d tries\n", cnt);
-#endif
-
-		/* 
-		 * Note: cb_handler already calls aio_done
-		 */
-		break;
-
-
-	case A_SUSPEND:
-		aioary[0] = &aiop->aiocb;
-		r = aio_suspend(aioary, 1, NULL);
-		if( r == -1 ){
-			doio_fprintf(stderr, "aio_suspend failed: %s (%d)\n",
-				     SYSERR, errno );
-			exit(E_SETUP);
-		}
-
-		aio_done(aiop);
-		break;
-#endif
-	}
 
 /*printf("aio_wait: errno %d return %d\n", aiop->aio_errno, aiop->aio_ret);*/
 
@@ -4747,29 +3113,7 @@ time_t	t;
 int
 aio_done(struct aio_info *ainfo)
 {
-#ifdef CRAY
-	return ainfo->iosw.sw_flag;
-#endif
-
-#ifdef sgi
-	if( (ainfo->aio_errno = aio_error(&ainfo->aiocb)) == -1 ){
-		doio_fprintf(stderr, "aio_done: aio_error failed: %s (%d)\n",
-			     SYSERR, errno );
-		exit(E_SETUP);
-	}
-	/*printf("%d aio_done aio_errno=%d\n", getpid(), ainfo->aio_errno);*/
-	if( ainfo->aio_errno != EINPROGRESS ){
-		if( (ainfo->aio_ret = aio_return(&ainfo->aiocb)) == -1 ){
-			doio_fprintf(stderr, "aio_done: aio_return failed: %s (%d)\n",
-				     SYSERR, errno );
-			exit(E_SETUP);
-		}
-	}
-
-	return (ainfo->aio_errno != EINPROGRESS);
-#else
         return -1;   /* invalid */
-#endif
 }
 
 /*
@@ -4789,18 +3133,6 @@ int	mask;
 	if (U_opt == 0 || (mask & Upanic_Conditions) == 0) {
 		return;
 	}
-
-#ifdef CRAY
-	if (upanic(PA_SET) < 0) {
-		doio_fprintf(stderr, "WARNING - Could not set the panic flag - upanic(PA_SET) failed:  %s (%d)\n",
-			     SYSERR, errno);
-	}
-
-	upanic(PA_PANIC);
-#endif
-#ifdef sgi
-	syssgi(1005);	/* syssgi test panic - DEBUG kernels only */
-#endif
 	doio_fprintf(stderr, "WARNING - upanic() failed\n");
 }
 
@@ -4905,16 +3237,11 @@ char	*opts;
 			break;
 
 		case 'M':	/* memory allocation types */
-#ifndef CRAY
 			nmemargs = string_to_tokens(optarg, memargs, 32, ",");
 			for(ma=0; ma < nmemargs; ma++) {
 				parse_memalloc(memargs[ma]);
 			}
 			/*dump_memalloc();*/
-#else
-			fprintf(stderr, "%s%s: Error: -M isn't supported on this platform\n", Prog, TagName);
-			exit(1);
-#endif
 			M_opt++;
 			break;
 
@@ -4964,14 +3291,6 @@ char	*opts;
 				Validation_Flags = O_SYNC;
 			} else if (strcasecmp(optarg, "buffered") == 0) {
 				Validation_Flags = 0;
-#ifdef CRAY
-			} else if (strcasecmp(optarg, "parallel") == 0) {
-				Validation_Flags = O_PARALLEL;
-			} else if (strcasecmp(optarg, "ldraw") == 0) {
-				Validation_Flags = O_LDRAW;
-			} else if (strcasecmp(optarg, "raw") == 0) {
-				Validation_Flags = O_RAW;
-#endif
 			} else if (strcasecmp(optarg, "direct") == 0) {
 				Validation_Flags = O_DIRECT;
 			} else {
@@ -5097,7 +3416,6 @@ char	*opts;
  *	NBLKS
  *	nblks worth of directories - 1 int pids
  */
-#ifndef CRAY
 void
 parse_memalloc(char *arg)
 {
@@ -5223,8 +3541,6 @@ dump_memalloc()
 	}
 }
 
-#endif /* !CRAY */
-
 /*
  * -d <op>:<time> - doio inter-operation delay
  *	currently this permits ONE type of delay between operations.
@@ -5312,9 +3628,6 @@ FILE	*stream;
 	fprintf(stream, "\t                     Operations are:\n");
 	fprintf(stream, "\t                         select:time (1 second=1000000)\n");
 	fprintf(stream, "\t                         sleep:time (1 second=1)\n");
-#ifdef sgi
-	fprintf(stream, "\t                         sginap:time (1 second=CLK_TCK=100)\n");
-#endif
 	fprintf(stream, "\t                         alarm:time (1 second=1)\n");
 	fprintf(stream, "\t-e                   Re-exec children before entering the main\n");
 	fprintf(stream, "\t                     loop.  This is useful for spreading\n");
@@ -5323,35 +3636,19 @@ FILE	*stream;
 	fprintf(stream, "\t-v                   Verify writes - this is done by doing a buffered\n");
 	fprintf(stream, "\t                     read() of the data if file io was done, or\n");
 	fprintf(stream, "\t                     an ssread()of the data if sds io was done\n");
-#ifndef CRAY
 	fprintf(stream, "\t-M                   Data buffer allocation method\n");
 	fprintf(stream, "\t                     alloc-type[,type]\n");
-#ifdef sgi
-	fprintf(stream, "\t			    data:flags\n");
-	fprintf(stream, "\t			        p - mpin buffer\n");
-	fprintf(stream, "\t			    shmem:shmid:size:flags\n");
-	fprintf(stream, "\t			        p - mpin buffer\n");
-#else
 	fprintf(stream, "\t			    data\n");
 	fprintf(stream, "\t			    shmem:shmid:size\n");
-#endif /* sgi */
 	fprintf(stream, "\t			    mmap:flags:filename\n");
 	fprintf(stream, "\t			        p - private\n");
-#ifdef sgi
-	fprintf(stream, "\t			        s - shared\n");
-	fprintf(stream, "\t			        l - local\n");
-	fprintf(stream, "\t			        a - autoresrv\n");
-	fprintf(stream, "\t			        G - autogrow\n");
-#else
 	fprintf(stream, "\t			        s - shared (shared file must exist\n"),
 	fprintf(stream, "\t			            and have needed length)\n");
-#endif
 	fprintf(stream, "\t			        f - fixed address (not used)\n");
 	fprintf(stream, "\t			        a - specify address (not used)\n");
 	fprintf(stream, "\t			        U - Unlink file when done\n");
 	fprintf(stream, "\t			        The default flag is private\n");
 	fprintf(stream, "\n");
-#endif /* !CRAY */
 	fprintf(stream, "\t-m message_interval  Generate a message every 'message_interval'\n");
 	fprintf(stream, "\t                     requests.  An interval of 0 suppresses\n");
 	fprintf(stream, "\t                     messages.  The default is 0.\n");
@@ -5368,11 +3665,6 @@ FILE	*stream;
 	fprintf(stream, "\t                     'buffered' - validate using bufferd read\n");
 	fprintf(stream, "\t                     'sync'     - validate using O_SYNC read\n");
 	fprintf(stream, "\t                     'direct    - validate using O_DIRECT read'\n");
-#ifdef CRAY
-	fprintf(stream, "\t                     'ldraw'    - validate using O_LDRAW read\n");
-	fprintf(stream, "\t                     'parallel' - validate using O_PARALLEL read\n");
-	fprintf(stream, "\t                     'raw'      - validate using O_RAW read\n");
-#endif
 	fprintf(stream, "\t                     By default, 'parallel'\n");
 	fprintf(stream, "\t                     is used if the write was done with O_PARALLEL\n");
 	fprintf(stream, "\t                     or 'buffered' for all other writes.\n");
Index: b/ltp/doio.h
===================================================================
--- a/ltp/doio.h
+++ b/ltp/doio.h
@@ -56,13 +56,7 @@
 #define UNRESVSP 123		/* xfsctl(XFS_IOC_UNRESVSP) */
 #define	FSYNC2	125		/* fsync(2) */
 #define	FDATASYNC 126		/* fdatasync(2) */
-
-#ifdef CRAY
-/* used: <<doio>> 1.? <<DOIO>> 1.5 <-DOIO-> 1.7*/
-#define DOIO_MAGIC  '<[DOIO]>'
-#else
 #define DOIO_MAGIC  07116601
-#endif
 
 /*
  * Define various user flags (r_uflag field) that io requests can have
Index: b/ltp/growfiles.c
===================================================================
--- a/ltp/growfiles.c
+++ b/ltp/growfiles.c
@@ -168,11 +168,7 @@ int mult_size=1;		/* when random iosz, i
 /* the *_lseek variables are only used when radon lseek option (-R) is used */
 int min_lseek=0;		/* also set in option parsing */
 int max_lseek=-1;		/* -1 means size of file */
-#ifdef CRAY
-int Pattern=PATTERN_OFFSET;	/* This pattern is 64 bit word based */
-#else
 int Pattern=PATTERN_ASCII;
-#endif
 int Seed=-1;			/* random number seed, < 0 == uninitialized  */
 int Nseeds=0;			/* Number of seed specified by the user */
 int *Seeds;			/* malloc'ed arrary of ints holding user spec seeds */
@@ -229,32 +225,6 @@ struct fileinfo_t {
  * to use.
  */
 int Open_flags[] = { 
-#ifdef CRAY
-	O_RDWR|O_CREAT,
-	O_RDWR|O_CREAT|O_RAW,
-	O_RDWR|O_CREAT|O_BIG,
-	O_RDWR|O_CREAT|O_APPEND,
-	O_RDWR|O_CREAT|O_NDELAY,
-	O_RDWR|O_CREAT|O_PLACE,
-	O_RDWR|O_CREAT|O_SYNC,
-	O_RDWR|O_CREAT|O_RAW|O_SYNC,
-	O_RDWR|O_CREAT|O_NDELAY|O_SYNC,
-	O_RDWR|O_CREAT|O_NDELAY|O_SYNC|O_BIG,
-	O_RDWR|O_CREAT|O_RAW,
-	O_RDWR|O_CREAT|O_RAW|O_APPEND,
-	O_RDWR|O_CREAT|O_RAW|O_BIG,
-	O_RDWR|O_CREAT|O_RAW|O_APPEND|O_BIG,
-/***
- * O_WELLFORMED makes -o random require well formed i/o
- ***/
-#if ALLOW_O_WELLFORMED
-#if O_PARALLEL
-	O_RDWR|O_CREAT|O_PARALLEL|O_WELLFORMED|O_RAW,
-	O_RDWR|O_CREAT|O_PARALLEL|O_WELLFORMED|O_RAW|O_TRUNC,
-#endif /* O_PARALLEL */
-#endif
-
-#else /* CRAY */
 	O_RDWR|O_CREAT,
 	O_RDWR|O_CREAT|O_APPEND,
 	O_RDWR|O_CREAT|O_NDELAY,
@@ -262,7 +232,6 @@ int Open_flags[] = {
 	O_RDWR|O_CREAT|O_SYNC|O_NDELAY,
 	O_RDWR|O_CREAT|O_APPEND|O_NDELAY,
 
-#endif /* CRAY */
 };
 
 #define REXEC_INIT	0	/* don't do re-exec of childern */
@@ -270,11 +239,7 @@ int Open_flags[] = {
 #define REXEC_DONE	2	/* We've already been re-exec'ed */
 
 #ifndef BSIZE
-#ifdef CRAY
-#define BSIZE	1024
-#else
 #define BSIZE	512
-#endif  /* CRAY */
 #endif  /* BSIZE */
 
 #define USECS_PER_SEC	1000000  /* microseconds per second */
@@ -428,9 +393,6 @@ extern int Forker_npids;	/* num of forke
 
 		case 'd':
 			auto_dir=optarg;
-#ifdef CRAY
-			unsetenv("TMPDIR");	/* force the use of auto_dir */
-#endif
 			if ( stat(auto_dir, &statbuf) == -1 ) {
 			    if ( mkdir(auto_dir, 0777) == -1 ) {
 				if ( errno != EEXIST ) {
@@ -612,18 +574,9 @@ extern int Forker_npids;	/* num of forke
 			break;
 
 		case 'P':
-#ifdef CRAY
-			if (strcmp(optarg, "PANIC") != 0 ) {
-				fprintf(stderr, "%s%s: --P arg must be PANIC\n", Progname, TagName);
-				exit(1);
-			}
-			Upanic_on_error++;
-			printf("%s: Will call upanic after writes\n");
-#else
 			printf("%s%s: --P is illegal option on non-cray system\n",
 				Progname, TagName);
 			exit(1);
-#endif
 			break;
 
 		case 'q':	/* file content or pattern */
@@ -904,11 +857,6 @@ no whole file checking will be performed
 	    background(Progname);	/* give user their prompt back */
 	}
 
-#if CRAY
-	if ( Sync_with_others )
-	   setpgrp();
-#endif
-
 	if ( Debug > 3 ) {
 #if NEWIO
 	    lio_set_debug(Debug-3);
@@ -1227,18 +1175,9 @@ no whole file checking will be performed
 	/*
 	 * If delaying between iterations, get amount time to
 	 * delaysecs in clocks or usecs.
-	 * If on the CRAY, delaytime is in clocks since
-	 * _rtc() will be used, which does not have the overhead
-         * of gettimeofday(2).
 	 */
 	if ( delaysecs ) {
-#if CRAY
-	   int hz;
-	   hz=sysconf(_SC_CLK_TCK);
-	   delaytime=(int)((float)hz * delaysecs);
-#else
 	   delaytime=(int)((float)USECS_PER_SEC * delaysecs);
-#endif
         }
 
 	/*
@@ -1398,13 +1337,6 @@ no whole file checking will be performed
 	        if ( delaytime ) {
 		
 		    int ct, end;
-#ifdef CRAY
-		    ct=_rtc();
-		    end=ct+delaytime;
-        	    while ( ct < end ) {
-		        ct = _rtc();
-		    }
-#else
 		    struct timeval curtime;
 		    gettimeofday(&curtime, NULL);
 		    ct=curtime.tv_sec*USECS_PER_SEC + curtime.tv_usec;
@@ -1414,7 +1346,6 @@ no whole file checking will be performed
 		        gettimeofday(&curtime, NULL);
 		        ct=curtime.tv_sec*USECS_PER_SEC + curtime.tv_usec;
 		    }
-#endif
 	        }
 	    }
 #ifndef NO_XFS
@@ -1472,10 +1403,6 @@ set_sig()
                 case SIGKILL:
                 case SIGSTOP:
                 case SIGCONT:
-#ifdef CRAY
-                case SIGINFO:
-                case SIGRECOVERY:
-#endif /* CRAY */
 #ifdef SIGCKPT
 	        case SIGCKPT:
 #endif /* SIGCKPT */
@@ -1486,12 +1413,7 @@ set_sig()
                     break;
 
                 default:
-#ifdef sgi
-		    sigset( sig, sig_handler );
-#else
-/* linux and cray */
                     signal(sig, sig_handler);
-#endif
                 break;
             }
         } /* endfor */
@@ -1512,9 +1434,7 @@ int sig;
     if ( sig == SIGUSR2 ) {
 	fprintf(stdout, "%s%s: %d %s/%d: received SIGUSR2 (%d) - stopping.\n",
 	    Progname, TagName, Pid, __FILE__, __LINE__, sig);
-#ifndef sgi
         signal(sig, sig_handler);	/* allow us to get this signal more than once */
-#endif
         
     } else if( sig == SIGINT ){
 	/* The user has told us to cleanup, don't pretend it's an error. */
@@ -1552,13 +1472,6 @@ notify_others()
 
     if ( Sync_with_others && send_signals == 0 ) {
 
-#if CRAY
-	send_signals=1; /* only send signals once */
-	if ( Debug > 1 )
-	    printf("%s%s: %d DEBUG2 %s/%d: Sending SIGUSR2 to pgrp\n",
-		  Progname, TagName, Pid, __FILE__, __LINE__);
-	killm(C_PGRP, getpgrp(), SIGUSR2);
-#else
 	send_signals=1; /* only send signals once */
 
         for (ind=0; ind< Forker_npids; ind++) {
@@ -1568,7 +1481,6 @@ notify_others()
 		        Progname, TagName, Pid, __FILE__, __LINE__, Forker_pids[ind]);
 	        kill(Forker_pids[ind], SIGUSR2);
         }
-#endif
     }
 
 }
@@ -1583,12 +1495,6 @@ handle_error()
 {
     Errors++;
 
-#ifdef CRAY
-    if ( Errors & Upanic_on_error ) {
-        upanic(PA_PANIC);
-    }
-#endif
-
     if ( Maxerrs && Errors >= Maxerrs ) {
 	printf("%s%s: %d %s/%d: %d Hit max errors value of %d\n", 
 	    Progname, TagName, Pid, __FILE__, __LINE__, Iter_cnt, Maxerrs);
@@ -2030,25 +1936,6 @@ unsigned char *buf;
 					Progname, TagName, __FILE__, __LINE__, errno, strerror(errno) );
 				return -1;
 			}
-#if NEWIO
-#ifdef sgi
-			/* If this is POSIX I/O and it is via aio_{read,write}
-			 * or lio_listio then after completion of the I/O the
-			 * value of the file offset for the file is
-			 * unspecified--which means we cannot trust what
-			 * tell() told us.  Fudge it here.
-			 */
-			if( (io_type & LIO_IO_ASYNC_TYPES) || (io_type & LIO_RANDOM) ){
-				if( tmp != Woffset + grow_incr ){
-					if( Debug > 5 ){
-						printf("%s: %d DEBUG6 %s/%d: posix fudge, forcing tmp (%d) to match Woffset+grow_incr (%d)\n",
-						       Progname, Pid, __FILE__, __LINE__, tmp, Woffset+grow_incr);
-					}
-					tmp = Woffset + grow_incr;
-				}
-			}
-#endif
-#endif
 		}
 
 		lkfile(fd, LOCK_UN, LKLVL0);	
@@ -2140,9 +2027,6 @@ int just_trunc;		/* lseek has already be
     int cur_offset;
     int new_offset;
     int ret;
-#ifdef CRAY
-    int offset;
-#endif
 
 	shrink_cnt++;
 
@@ -2184,19 +2068,6 @@ int just_trunc;		/* lseek has already be
             else {
                 new_offset=random_range(min_lseek, max_lseek, 1, NULL);
             }
-
-#ifdef CRAY
-            if ((offset=lseek(fd, new_offset, SEEK_SET)) == -1 ) {
-                fprintf(stderr, "%s%s: %d %s/%d: lseek(%d, %d, SEEK_SET) l3 failed: %s\n",
-                    Progname, TagName, Pid, __FILE__, __LINE__, fd, new_offset, strerror(errno));
-	        lkfile(fd, LOCK_UN, LKLVL0);
-                return -1;
-            }
-            else if ( Debug > 3 )
-                printf("%s: %d DEBUG4 %s/%d: lseeked to random offset %d\n",
-                    Progname, Pid, __FILE__, __LINE__, offset);
-    
-#endif
         }
 
 	else {	/* remove trunc_incr from file */
@@ -2205,41 +2076,19 @@ int just_trunc;		/* lseek has already be
 
 	    if ( new_offset < 0 )
 		new_offset=0;
-	
-#ifdef CRAY
-	    if (  lseek(fd, new_offset, SEEK_SET) == -1 ) {
-		fprintf(stderr, "%s%s: %d %s/%d: lseek(fd, %d, SEEK_SET) l4 failed: %s\n",
-			Progname, TagName, Pid, __FILE__, __LINE__, new_offset, strerror(errno));
-	        lkfile(fd, LOCK_UN, LKLVL0);
-		return -1;
-	    }
-            else if ( Debug > 3 )
-                printf("%s: %d DEBUG4 %s/%d: lseeked to offset %d, %d bytes from end\n",
-                    Progname, Pid, __FILE__, __LINE__, new_offset, trunc_incr);
-#endif
 	}
 
-
-#ifdef CRAY
-	ret=trunc(fd);
-#else
 	ret=ftruncate(fd, new_offset );
 	if( (ret == 0) && (Debug > 3) ){
                 printf("%s: %d DEBUG4 %s/%d: ftruncated to offset %d, %d bytes from end\n",
                     Progname, Pid, __FILE__, __LINE__, new_offset, trunc_incr);
 	}
-#endif
 
 	lkfile(fd, LOCK_UN, LKLVL0);
 
 	if ( ret == -1 ) {
-#ifdef CRAY
-		fprintf(stderr, "%s%s: %d %s/%d: trunc failed: %s\n",
-			Progname, TagName, Pid, __FILE__, __LINE__, strerror(errno));
-#else
 		fprintf(stderr, "%s%s: %d %s/%d: ftruncate failed: %s\n",
 			Progname, TagName, Pid, __FILE__, __LINE__, strerror(errno));
-#endif
 		return -1;
 	}
 
@@ -2756,17 +2605,6 @@ int fd;
 int size;
 {
 
-#ifdef CRAY
-    long avl;
-
-        if ( ialloc(fd, size, IA_CONT, &avl) == -1 ) {
-                fprintf(stderr, "%s%s %s/%d: Unable to pre-alloc space: ialloc failed: %d  %s\n",
-			Progname, TagName,
-                        __FILE__, __LINE__, errno, strerror(errno));
-                return -1;
-        }
-#endif
-
 #ifndef NO_XFS
 #ifdef XFS_IOC_RESVSP
     struct xfs_flock64 f;
Index: b/ltp/iogen.c
===================================================================
--- a/ltp/iogen.c
+++ b/ltp/iogen.c
@@ -146,21 +146,6 @@ struct strmap	Aio_Strat_Map[] = {
 #else
 	{ "none",	0	},
 #endif /* !linux */
-#ifdef CRAY
-#if _UMK || RELEASE_LEVEL >= 8000
-	{ "recall",	A_RECALL	},
-#endif
-
-#ifdef RECALL_SIZEOF
-	{ "recalla",    A_RECALLA	},
-#endif
-	{ "recalls",    A_RECALLS	},
-#endif /* CRAY */
-
-#ifdef sgi
-	{ "suspend",	A_SUSPEND	},
-	{ "callback",	A_CALLBACK	},
-#endif
 	{ NULL,		-1		}
 };
 
@@ -195,80 +180,20 @@ struct strmap	Omode_Map[] = {
 struct strmap	Syscall_Map[] = {
 	{ "read",		READ,		0			},
 	{ "write",		WRITE,		SY_WRITE		},
-#ifdef CRAY
-	{ "reada",		READA,		SY_ASYNC		},
-	{ "writea",		WRITEA,		SY_WRITE|SY_ASYNC	},
-#ifndef _CRAYMPP
-	{ "ssread",		SSREAD,		SY_SDS			},
-	{ "sswrite",		SSWRITE,	SY_WRITE|SY_SDS		},
-#endif
-	{ "listio",		LISTIO,		SY_ASYNC		},
-
-	/* listio as 4 system calls */
-	{ "lread",		LREAD,		0			},
-	{ "lreada",		LREADA,		SY_ASYNC		},
-	{ "lwrite",		LWRITE,		SY_WRITE		},
-	{ "lwritea",		LWRITEA,	SY_WRITE|SY_ASYNC	},
-
-	/* listio with nstrides > 1 */
-	{ "lsread",		LSREAD,		0			},
-	{ "lsreada",		LSREADA,	SY_ASYNC		},
-	{ "lswrite",		LSWRITE,	SY_WRITE		},
-	{ "lswritea",		LSWRITEA,	SY_WRITE|SY_ASYNC	},
-
-	/* listio with nents > 1 */
-	{ "leread",		LEREAD,		0|SY_NENT		},
-	{ "lereada",		LEREADA,	SY_ASYNC|SY_NENT	},
-	{ "lewrite",		LEWRITE,	SY_WRITE|SY_NENT	},
-	{ "lewritea",		LEWRITEA,	SY_WRITE|SY_ASYNC|SY_NENT },
-
-	/* listio with nents > 1 & nstrides > 1 */
-
-	/* all listio system calls under one name */
-	{ "listio+",		LREAD,		0			},
-	{ "listio+",		LREADA,		SY_ASYNC		},
-	{ "listio+",		LWRITE,		SY_WRITE		},
-	{ "listio+",		LWRITEA,	SY_WRITE|SY_ASYNC	},
-	{ "listio+",		LSREAD,		0			},
-	{ "listio+",		LSREADA,	SY_ASYNC		},
-	{ "listio+",		LSWRITE,	SY_WRITE		},
-	{ "listio+",		LSWRITEA,	SY_WRITE|SY_ASYNC	},
-	{ "listio+",		LEREAD,		0|SY_NENT		},
-	{ "listio+",		LEREADA,	SY_ASYNC|SY_NENT	},
-	{ "listio+",		LEWRITE,	SY_WRITE|SY_NENT	},
-	{ "listio+",		LEWRITEA,	SY_WRITE|SY_ASYNC|SY_NENT },
-#endif
-
 	{ "pread",		PREAD   				},
 	{ "pwrite",		PWRITE,		SY_WRITE		},
-#ifdef sgi
-	{ "aread",		AREAD,		SY_ASYNC		},
-	{ "awrite",		AWRITE,		SY_WRITE|SY_ASYNC	},
-#if 0
-	/* not written yet */
-	{ "llread",		LLREAD,		0			},
-	{ "llaread",		LLAREAD,	SY_ASYNC		},
-	{ "llwrite",		LLWRITE,	0			},
-	{ "llawrite",		LLAWRITE,	SY_ASYNC		},
-	{ "ffsync",		DFFSYNC, 	SY_WRITE		},
-#endif
-#endif /* SGI */
 #ifndef NO_XFS
 	{ "resvsp",		RESVSP, 	SY_WRITE		},
 	{ "unresvsp",		UNRESVSP, 	SY_WRITE		},
 	{ "reserve",		RESVSP, 	SY_WRITE		},
 	{ "unreserve",		UNRESVSP, 	SY_WRITE		},
 #endif
-
-#ifndef CRAY
 	{ "readv",		READV					},
 	{ "writev",		WRITEV,		SY_WRITE		},
 	{ "mmread",		MMAPR					},
 	{ "mmwrite",		MMAPW,		SY_WRITE		},
 	{ "fsync2",		FSYNC2, 	SY_WRITE		},
 	{ "fdatasync",		FDATASYNC, 	SY_WRITE		},
-#endif
-
 	{ NULL,			-1      }
 };
 
@@ -280,36 +205,7 @@ struct strmap	Syscall_Map[] = {
 struct strmap	Flag_Map[] = {
 	{ "buffered",		0,			0	},
 	{ "sync",		O_SYNC,			0	},
-#ifdef CRAY
-	{ "raw",		O_RAW,			FLG_RAW	},
-	{ "raw+wf",		O_RAW | O_WELLFORMED,	FLG_RAW	},
-	{ "raw+wf+ldraw",	O_RAW | O_WELLFORMED | O_LDRAW,	FLG_RAW	},
-	{ "raw+wf+ldraw+sync",	O_RAW | O_WELLFORMED | O_LDRAW | O_SYNC, FLG_RAW },
-#ifdef O_SSD
-	{ "ssd",		O_SSD,			FLG_RAW	},
-#endif
-#ifdef O_LDRAW
-	{ "ldraw",		O_LDRAW,		0	},
-#endif
-#ifdef O_PARALLEL
-	{ "parallel",		O_PARALLEL | O_RAW | O_WELLFORMED,
-		  FLG_RAW },
-	{ "parallel+sync",	O_PARALLEL | O_RAW | O_WELLFORMED | O_SYNC,
-		  FLG_RAW },
-	{ "parallel+ldraw",	O_PARALLEL | O_RAW | O_WELLFORMED | O_LDRAW,
-		  FLG_RAW },
-	{ "parallel+ldraw+sync",
-		  O_PARALLEL | O_RAW | O_WELLFORMED | O_LDRAW | O_SYNC,
-		  FLG_RAW },
-#endif
-#endif /* CRAY */
-
 	{ "direct",		O_DIRECT,		FLG_RAW },
-#ifdef sgi
-	{ "dsync",		O_DSYNC		},	/* affects writes */
-	{ "rsync",		O_RSYNC		},	/* affects reads */
-	{ "rsync+dsync",	O_RSYNC|O_DSYNC	},
-#endif
 	{ NULL, 	    -1	    	}
 };
 
@@ -353,13 +249,7 @@ char	**argv;
     struct io_req   req;
     
     umask(0);
-
-#ifdef CRAY
-    Sds_Avail = sysconf(_SC_CRAY_SDS);
-#else
     Sds_Avail = 0;
-#endif
-
     TagName[0] = '\0';
     parse_cmdline(argc, argv, OPTS);
 
@@ -557,9 +447,6 @@ struct io_req   *req;
     char    	    	pattern, *errp;
     struct strmap	*flags, *sc, *aio_strat;
     struct file_info	*fptr;
-#ifdef CRAY
-    int                 opcode, cmd;
-#endif
 
     /*
      * Choose system call, flags, and file
@@ -568,32 +455,11 @@ struct io_req   *req;
     sc = Syscall_List[random_range(0, Nsyscalls-1, 1, NULL)];
     req->r_type = sc->m_value;
 
-#ifdef CRAY
-    if (sc->m_value == LISTIO ) {
-	    opcode = random_range(0, 1, 1, NULL) ? LO_READ : LO_WRITE;
-	    cmd = random_range(0, 1, 1, NULL) ? LC_START : LC_WAIT;
-    }
-#endif
-
     if( sc->m_flags & SY_WRITE )
 	    pattern = Byte_Patterns[random_range(0, sizeof(Byte_Patterns) - 1, 1, NULL)];
     else
 	    pattern = 0;
 
-#if CRAY
-    /*
-     * If sds io, simply choose a length (possibly pattern) and return
-     */
-
-    if (sc->m_flags & SY_SDS ) {
-	    req->r_data.ssread.r_nbytes = random_range(Mintrans, Maxtrans, BSIZE, NULL);
-	    if (sc->m_flags & SY_WRITE)
-		    req->r_data.sswrite.r_pattern = pattern;
-
-	    return 0;
-    }
-#endif
-
     /*
      * otherwise, we're doing file io.  Choose starting offset, length,
      * open flags, and possibly a pattern (for write/writea).
@@ -856,25 +722,6 @@ struct io_req   *req;
 	break;
 
     case LISTIO:
-#ifdef CRAY
-	strcpy(req->r_data.listio.r_file, fptr->f_path);
-	req->r_data.listio.r_offset = offset;
-	req->r_data.listio.r_cmd = cmd;
-	req->r_data.listio.r_aio_strat = (aio_strat==NULL) ? 0 : aio_strat->m_value;
-	req->r_data.listio.r_filestride = 0;
-	req->r_data.listio.r_memstride = 0;
-	req->r_data.listio.r_opcode = opcode;
-	req->r_data.listio.r_nstrides = 1;
-	req->r_data.listio.r_nbytes = length;
-	req->r_data.listio.r_uflags = (flags->m_flags & FLG_RAW) ? F_WORD_ALIGNED : 0;
-
-	if (opcode == LO_WRITE) {
-		req->r_data.listio.r_pattern = pattern;
-		req->r_data.listio.r_oflags = O_WRONLY | flags->m_value;
-	} else {
-		req->r_data.listio.r_oflags = O_RDONLY | flags->m_value;
-	}
-#endif
 	break;
     }
 
@@ -897,9 +744,6 @@ get_file_info(rec)
 struct file_info    *rec;
 {
     struct stat			sbuf;
-#ifdef CRAY
-    struct lk_device_info	dinfo;
-#endif
 #ifndef NO_XFS
     int				fd;
     struct dioattr		finfo;
@@ -916,13 +760,6 @@ struct file_info    *rec;
 	return -1;
     }
 
-#if _CRAY2
-    if ((! S_ISREG(sbuf.st_mode)) || strncmp(rec->f_path, "/dev/", 5) == 0) {
-	fprintf(stderr, "iogen%s:  device level io not supported on cray2\n", TagName);
-	return -1;
-    }
-#endif
-
     rec->f_type = sbuf.st_mode & S_IFMT;
 
     /*
@@ -947,17 +784,6 @@ struct file_info    *rec;
 	}
 
 	rec->f_riou = BSIZE;
-#ifdef CRAY
-	if (lk_rawdev(rec->f_path, dinfo.path, sizeof(dinfo.path), 0) == -1)
-	    return -1;
-
-	if (lk_devinfo(&dinfo, 0) == -1) {
-	    /* can't get raw I/O unit -- use stat to fudge it */
-	    rec->f_riou = sbuf.st_blksize;
-	} else {
-	    rec->f_riou = ctob(dinfo.iou);
-	}
-#endif
 #ifndef NO_XFS
 	if( (fd = open(rec->f_path, O_RDWR|O_DIRECT, 0)) != -1 ) {
 #ifdef XFS_IOC_DIOINFO
@@ -980,34 +806,10 @@ bozo!
 	    rec->f_riou = BBSIZE;
 	}
 #endif
-
     } else {
 
-#ifdef CRAY
-	/*
-	 * Otherwise, file is a device.  Use lk_devinfo() to get its logical
-	 * sector size.  This is the iou and riou
-	 */
-
-	strcpy(dinfo.path, rec->f_path);
-
-	if (lk_devinfo(&dinfo, 0) == -1) {
-	    fprintf(stderr, "iogen%s: %s:  %s\n", TagName, Lk_err_func, Lk_err_mesg);
-	    return -1;
-	}
-
-	rec->f_iou = ctob(dinfo.iou);
-	rec->f_riou = ctob(dinfo.iou);
-	rec->f_length = ctob(dinfo.length);
-#else
-#ifdef sgi
-	rec->f_riou = BBSIZE;
-	rec->f_length = BBSIZE;
-#else
 	rec->f_riou = BSIZE;
 	rec->f_length = BSIZE;
-#endif /* sgi */
-#endif /* CRAY */
     }
 
     return 0;
@@ -1393,32 +1195,12 @@ char	*opts;
     struct file_info	*fptr;
     int			nopenargs;
     char		*openargs[5];	/* Flags, cbits, cblks */
-#ifdef CRAY
-    char		*errmsg;
-    char		*ranges;
-    struct strmap	*type;
-#endif
-
     while ((o = getopt(argc, argv, opts)) != EOF) {
         switch ((char)o) {
 
  	case 'a':
-#ifndef CRAY
 	    fprintf(stderr, "iogen%s:  Unrecognized option -a on this platform\n", TagName);
 	    exit(2);
-#else
-	    cp = strtok(optarg, ",");
-	    while (cp != NULL) {
-		if ((type = str_lookup(Aio_Strat_Map, cp)) == NULL) {
-		    fprintf(stderr, "iogen%s:  Unrecognized aio completion strategy:  %s\n", TagName, cp);
-		    exit(2);
-		}
-
-		Aio_Strat_List[Naio_Strat_Types++] = type;
-		cp = strtok(NULL, ",");
-	    }
-	    a_opt++;
-#endif
 	    break;
 
  	case 'f':
@@ -1480,23 +1262,8 @@ char	*opts;
 	    break;
 
 	case 'L':
-#ifndef CRAY
 	    fprintf(stderr, "iogen%s:  Unrecognized option -L on this platform\n", TagName);
 	    exit(2);
-#else
-	    if( parse_ranges(optarg, 1, 255, 1, NULL, &ranges, 
-			     &errmsg ) == -1 ) {
-		    fprintf(stderr, "iogen%s: error parsing listio range '%s': %s\n",
-			    TagName, optarg, errmsg);
-		    exit(1);
-	    }
-
-	    Minstrides = range_min(ranges, 0);
-	    Maxstrides = range_max(ranges, 0);
-
-	    free(ranges);
-	    L_opt++;
-#endif
 	    break;
 
 	case 'm':
@@ -1519,19 +1286,6 @@ char	*opts;
 	case 'O':
 
 	    nopenargs = string_to_tokens(optarg, openargs, 4, ":/");
-
-#ifdef CRAY
-	    if(nopenargs)
-		sscanf(openargs[1],"%i", &Ocbits);
-	    if(nopenargs > 1)
-		sscanf(openargs[2],"%i", &Ocblks);
-
-	    Oflags = parse_open_flags(openargs[0], &errmsg);
-	    if(Oflags == -1) {
-		fprintf(stderr, "iogen%s: -O %s error: %s\n", TagName, optarg, errmsg);
-		exit(1);
-	    }
-#endif
 #ifndef NO_XFS
 	    if(!strcmp(openargs[0], "realtime")) {
 		/*
@@ -1685,28 +1439,12 @@ char	*opts;
 	Nsyscalls = 0;
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "read");
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "write");
-#ifdef CRAY
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "reada");
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "writea");
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "lread");
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "lreada");
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "lwrite");
-	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "lwritea");
-#endif
-
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "pread");
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "pwrite");
-#ifdef sgi
-	/*Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "aread");*/
-	/*Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "awrite");*/
-#endif
-
-#ifndef CRAY
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "readv");
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "writev");
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "mmread");
 	Syscall_List[Nsyscalls++] = str_lookup(Syscall_Map, "mmwrite");
-#endif
 
         Fileio = 1;
     }
@@ -1724,18 +1462,6 @@ char	*opts;
 	    Nflags = 0;
 	    Flag_List[Nflags++] = str_lookup(Flag_Map, "buffered");
 	    Flag_List[Nflags++] = str_lookup(Flag_Map, "sync");
-#ifdef CRAY
-	    Flag_List[Nflags++] = str_lookup(Flag_Map, "raw+wf");
-    	    Flag_List[Nflags++] = str_lookup(Flag_Map, "ldraw");
-#endif
-
-#ifdef sgi
-	    /* Warning: cannot mix direct i/o with others! */
-	    Flag_List[Nflags++] = str_lookup(Flag_Map, "dsync");
-	    Flag_List[Nflags++] = str_lookup(Flag_Map, "rsync");
-	    /* Flag_List[Nflags++] = str_lookup(Flag_Map, "rsync+sync");*/
-	    /* Flag_List[Nflags++] = str_lookup(Flag_Map, "rsync+dsync");*/
-#endif
     }
 
     if (Fileio) {
@@ -1897,26 +1623,12 @@ FILE	*stream;
     fprintf(stream, "\n");
 #ifndef linux
     fprintf(stream, "\t-a aio_type,...  Async io completion types to choose.  Supported types\n");
-#ifdef CRAY
-#if _UMK || RELEASE_LEVEL >= 8000
-    fprintf(stream, "\t                 are:  poll, signal, recall, recalla, and recalls.\n");
-#else
-    fprintf(stream, "\t                 are:  poll, signal, recalla, and recalls.\n");
-#endif
-#else
     fprintf(stream, "\t                 are:  poll, signal, suspend, and callback.\n");
-#endif
     fprintf(stream, "\t                 Default is all of the above.\n");
 #else /* !linux */
     fprintf(stream, "\t-a               (Not used on Linux).\n");
 #endif /* !linux */
     fprintf(stream, "\t-f flag,...      Flags to use for file IO.  Supported flags are\n");
-#ifdef CRAY
-    fprintf(stream, "\t                 raw, ssd, buffered, ldraw, sync,\n");
-    fprintf(stream, "\t                 raw+wf, raw+wf+ldraw, raw+wf+ldraw+sync,\n");
-    fprintf(stream, "\t                 and parallel (unicos/mk on MPP only).\n");
-    fprintf(stream, "\t                 Default is 'raw,ldraw,sync,buffered'.\n");
-#else
 #ifndef NO_XFS
     fprintf(stream, "\t                 buffered, direct, sync.\n");
     fprintf(stream, "\t                 Default is 'buffered,sync'.\n");
@@ -1924,17 +1636,12 @@ FILE	*stream;
     fprintf(stream, "\t                 buffered, sync.\n");
     fprintf(stream, "\t                 Default is 'buffered,sync'.\n");
 #endif /* sgi */
-#endif /* CRAY */
     fprintf(stream, "\t-h               This help.\n");
     fprintf(stream, "\t-i iterations[s] # of requests to generate.  0 means causes iogen\n");
     fprintf(stream, "\t                 to run until it's killed.  If iterations is suffixed\n");
     fprintf(stream, "\t                 with 's', then iterations is the number of seconds\n");
     fprintf(stream, "\t                 that iogen should run for.  Default is '0'.\n");
-#ifndef CRAY
     fprintf(stream, "\t-L min:max       listio nstrides / nrequests range\n");
-#else
-    fprintf(stream, "\t-L               (Not used on this platform).\n");
-#endif /* !CRAY */
     fprintf(stream, "\t-m offset-mode   The mode by which iogen chooses the offset for\n");
     fprintf(stream, "\t                 consectutive transfers within a given file.\n");
     fprintf(stream, "\t                 Allowed values are 'random', 'sequential',\n");
@@ -1943,9 +1650,6 @@ FILE	*stream;
     fprintf(stream, "\t-N tagname       Tag name, for Monster.\n");
     fprintf(stream, "\t-o               Form overlapping consecutive requests.\n");
     fprintf(stream, "\t-O               Open flags for creating files\n");
-#ifdef CRAY
-    fprintf(stream, "\t                 {O_PLACE,O_BIG,etc}[:CBITS[:CBLKS]]\n");
-#endif
 #ifndef NO_XFS
     fprintf(stream, "\t                 realtime:extsize - put file on real-time volume\n");
     fprintf(stream, "\t                 allocate - allocate space with F_ALLOCSP\n");
@@ -1959,17 +1663,6 @@ FILE	*stream;
     fprintf(stream, "\t-q               Quiet mode.  Normally iogen spits out info\n");
     fprintf(stream, "\t                 about test files, options, etc. before starting.\n");
     fprintf(stream, "\t-s syscall,...   Syscalls to do.  Supported syscalls are\n");
-#ifdef sgi
-    fprintf(stream, "\t                 read, write, pread, pwrite, readv, writev\n");
-    fprintf(stream, "\t                 aread, awrite, resvsp, unresvsp, ffsync,\n");
-    fprintf(stream, "\t                 mmread, mmwrite, fsync2, fdatasync,\n");
-    fprintf(stream, "\t                 Default is 'read,write,pread,pwrite,readv,writev,mmread,mmwrite'.\n");
-#endif
-#ifdef CRAY
-    fprintf(stream, "\t                 read, write, reada, writea, listio,\n");
-    fprintf(stream, "\t                 ssread (PVP only), and sswrite (PVP only).\n");
-    fprintf(stream, "\t                 Default is 'read,write,reada,writea,listio'.\n");
-#endif
 #ifdef linux
     fprintf(stream, "\t                 read, write, pread, pwrite, readv, writev,\n");
     fprintf(stream, "\t                 mmread, mmwrite, fsync2, fdatasync,\n");
Index: b/src/dirperf.c
===================================================================
--- a/src/dirperf.c
+++ b/src/dirperf.c
@@ -28,9 +28,7 @@
 #include <string.h>
 #include <unistd.h>
 
-#ifndef __sgi__
 typedef unsigned int uint_t;
-#endif
 
 /*
  * Loop over directory sizes:
Index: b/src/dmiperf.c
===================================================================
--- a/src/dmiperf.c
+++ b/src/dmiperf.c
@@ -28,15 +28,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
-#ifdef  sgi
-#include <sys/attributes.h>
-#else
 #include <attr/attributes.h>
-#endif
 
-#ifndef sgi
 typedef unsigned int uint_t;
-#endif
 
 /*
  * Loop over directory sizes:
Index: b/src/global.h
===================================================================
--- a/src/global.h
+++ b/src/global.h
@@ -21,11 +21,6 @@
 
 #include <config.h>
 
-#ifdef sgi
-#include <../../irix/include/xfs/platform_defs.h>
-#include <../../xfsprogs/include/irix.h>
-#endif
-
 #ifdef HAVE_XFS_XFS_H
 #include <xfs/xfs.h>
 #endif
Index: b/src/multi_open_unlink.c
===================================================================
--- a/src/multi_open_unlink.c
+++ b/src/multi_open_unlink.c
@@ -24,11 +24,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-#ifdef  sgi
-#include <sys/attributes.h>
-#else
 #include <attr/attributes.h>
-#endif
 
 #define MAX_EA_NAME 30
 
Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -54,13 +54,8 @@ static int test;
  * F_FSGETXATTR (Irix).
  *
  */
-#ifdef	__sgi__	/* Irix */
-#  define xfscntl(filename, fd, cmd, arg) \
-		fcntl((fd), F_ ## cmd, (arg))
-#else	/* ! __sgi__ */
 #  define xfscntl(filename, fd, cmd, arg) \
 		xfsctl((filename), (fd), XFS_IOC_ ## cmd, (arg))
-#endif	/* ! __sgi__ */
 
 static void
 usage(char *progname)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
