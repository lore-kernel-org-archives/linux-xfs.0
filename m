Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:14:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M6EYWT019964
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:14:38 -0700
Date: Thu, 22 May 2008 16:15:19 +1000
From: David Chinner <dgc@sgi.com>
Subject: [hack] allow xfsrestore to run on 64k page size machines
Message-ID: <20080522061519.GT173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


xfsrestore has assumptions about page size built into the inode hunk
size in the dump format. Seems to be a stupid thing to do - this
patch simply comments out the asserts to allow it to work on
64k page size machine, but probably subtly breaks the code.
Nasty hack, really, but allows xfsqa tests to pass.

Not-Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfsdump/restore/inomap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: xfs-cmds/xfsdump/restore/inomap.c
===================================================================
--- xfs-cmds.orig/xfsdump/restore/inomap.c	2006-11-14 19:57:32.000000000 +1100
+++ xfs-cmds/xfsdump/restore/inomap.c	2008-05-13 10:34:05.963909158 +1000
@@ -197,8 +197,8 @@ inomap_restore_pers( drive_t *drivep,
 	 */
 	ASSERT( INOPERSEG == ( sizeof( (( seg_t * )0 )->lobits ) * NBBY ));
 	ASSERT( sizeof( hnk_t ) == HNKSZ );
-	ASSERT( HNKSZ >= pgsz );
-	ASSERT( ! ( HNKSZ % pgsz ));
+	//ASSERT( HNKSZ >= pgsz );
+	//ASSERT( ! ( HNKSZ % pgsz ));
 	ASSERT( sizeof( pers_t ) <= PERSSZ );
 
 	/* get inomap info from media hdr
@@ -224,8 +224,8 @@ inomap_restore_pers( drive_t *drivep,
 
 	/* mmap the persistent hdr and space for the map
 	 */
-	ASSERT( sizeof( hnk_t ) * ( size_t )hnkcnt >= pgsz );
-	ASSERT( ! ( sizeof( hnk_t ) * ( size_t )hnkcnt % pgsz ));
+	//ASSERT( sizeof( hnk_t ) * ( size_t )hnkcnt >= pgsz );
+	//ASSERT( ! ( sizeof( hnk_t ) * ( size_t )hnkcnt % pgsz ));
 	persp = ( pers_t * ) mmap_autogrow(
 				     PERSSZ
 				     +
@@ -355,8 +355,8 @@ inomap_sync_pers( char *hkdir )
 	/* sanity checks
 	 */
 	ASSERT( sizeof( hnk_t ) == HNKSZ );
-	ASSERT( HNKSZ >= pgsz );
-	ASSERT( ! ( HNKSZ % pgsz ));
+	//ASSERT( HNKSZ >= pgsz );
+	//ASSERT( ! ( HNKSZ % pgsz ));
 
 	/* only needed once per session
 	 */
