Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7FFiKjx095947 for <xfs@oss.sgi.com>; Mon, 15 Aug 2011 10:44:20 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfsdump: refactor ring_create
Date: Mon, 15 Aug 2011 10:43:18 -0500
Message-Id: <1313422998-7263-1-git-send-email-wkendall@sgi.com>
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

ring_create() takes a thread creation function pointer. The two
callers of ring_create() pass pointers to identical but separate
functions. This can be simplified by moving the thread creation
code into ring_create() itself.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/drive_minrmt.c   |   23 +----------------------
 common/drive_scsitape.c |   23 +----------------------
 common/ring.c           |   13 +++++++++----
 common/ring.h           |   10 ++++------
 4 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 94795e2..a61dfff 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -324,9 +324,6 @@ static intgen_t Write( drive_t *drivep,
 static intgen_t record_hdr_validate( drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr );
-static void ring_thread( void *clientctxp,
-			 int ( * entryp )( void *ringctxp ),
-			 void *ringctxp );
 static int ring_read( void *clientctxp, char *bufp );
 static int ring_write( void *clientctxp, char *bufp );
 static double percent64( off64_t num, off64_t denom );
@@ -610,7 +607,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 		contextp->dc_ringp = ring_create( contextp->dc_ringlen,
 						  STAPE_MAX_RECSZ,
 						  contextp->dc_ringpinnedpr,
-						  ring_thread,
+						  drivep->d_index,
 						  ring_read,
 						  ring_write,
 						  ( void * )drivep,
@@ -3808,24 +3805,6 @@ ring_write( void *clientctxp, char *bufp )
 	return write_record( ( drive_t * )clientctxp, bufp, BOOL_TRUE, BOOL_TRUE );
 }
 
-static void
-ring_thread( void *clientctxp,
-	     int ( * entryp )( void *ringctxp ),
-	     void *ringctxp )
-{
-	drive_t *drivep = ( drive_t * )clientctxp;
-	/* REFERENCED */
-	bool_t ok;
-
-	ok = cldmgr_create( entryp,
-			    CLONE_VM,
-			    drivep->d_index,
-			    _("slave"),
-			    ringctxp );
-	ASSERT( ok );
-}
-
-
 static ring_msg_t *
 Ring_get( ring_t *ringp )
 {
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 0f034b7..e08c5b5 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -374,9 +374,6 @@ static intgen_t quick_backup( drive_t *drivep,
 static intgen_t record_hdr_validate( drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr );
-static void ring_thread( void *clientctxp,
-			 int ( * entryp )( void *ringctxp ),
-			 void *ringctxp );
 static int ring_read( void *clientctxp, char *bufp );
 static int ring_write( void *clientctxp, char *bufp );
 static double percent64( off64_t num, off64_t denom );
@@ -700,7 +697,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep, bool_t singlethreaded )
 		contextp->dc_ringp = ring_create( contextp->dc_ringlen,
 						  STAPE_MAX_RECSZ,
 						  contextp->dc_ringpinnedpr,
-						  ring_thread,
+						  drivep->d_index,
 						  ring_read,
 						  ring_write,
 						  ( void * )drivep,
@@ -5088,24 +5085,6 @@ ring_write( void *clientctxp, char *bufp )
 	return write_record( ( drive_t * )clientctxp, bufp, BOOL_TRUE, BOOL_TRUE );
 }
 
-static void
-ring_thread( void *clientctxp,
-	     int ( * entryp )( void *ringctxp ),
-	     void *ringctxp )
-{
-	drive_t *drivep = ( drive_t * )clientctxp;
-	/* REFERENCED */
-	bool_t ok;
-
-	ok = cldmgr_create( entryp,
-			    CLONE_VM,
-			    drivep->d_index,
-			    "slave",
-			    ringctxp );
-	ASSERT( ok );
-}
-
-
 static ring_msg_t *
 Ring_get( ring_t *ringp )
 {
diff --git a/common/ring.c b/common/ring.c
index f6fc64d..2fe7dc2 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -30,6 +30,7 @@
 
 #include "types.h"
 #include "qlock.h"
+#include "cldmgr.h"
 #include "ring.h"
 
 static int ring_slave_entry( void *ringctxp );
@@ -38,14 +39,13 @@ ring_t *
 ring_create( size_t ringlen,
 	     size_t bufsz,
 	     bool_t pinpr,
-	     void ( *threadfunc )( void *clientctxp,
-				   int ( * entry )( void *ringctxp ),
-				   void *ringctxp ),
+	     ix_t drive_index,
 	     int ( *readfunc )( void *clientctxp, char *bufp ),
 	     int ( *writefunc )( void *clientctxp, char *bufp ),
 	     void *clientctxp,
 	     intgen_t *rvalp )
 {
+	bool_t ok;
 	ring_t *ringp;
 	size_t mix;
 
@@ -122,7 +122,12 @@ ring_create( size_t ringlen,
 
 	/* kick off the slave thread
 	 */
-	( *threadfunc )( clientctxp, ring_slave_entry, ( void * )ringp );
+	ok = cldmgr_create( ring_slave_entry,
+			    CLONE_VM,
+			    drive_index,
+			    _("slave"),
+			    ringp );
+	ASSERT( ok );
 
 	return ringp;
 }
diff --git a/common/ring.h b/common/ring.h
index 387f65f..56e3924 100644
--- a/common/ring.h
+++ b/common/ring.h
@@ -154,9 +154,9 @@ typedef struct ring ring_t;
 	
 
 /* ring_create - creates a ring. parameters supply the length of the ring,
- * the read/write buffer size, a function for creating a thread, a function
- * for reading, a function for writing, and a pointer to client context for the
- * read and write functions. returns a pointer to a ring if successful, a NULL
+ * the read/write buffer size, the drive index, a function for reading, a
+ * function for writing, and a pointer to client context for the read and
+ * write functions. returns a pointer to a ring if successful, a NULL
  * pointer if not. the read and write functions should return 0 on success,
  * or an error code on failure which will be recorded in the rm_rval field
  * of the message invoking the failed operation. if null pointer returned,
@@ -168,9 +168,7 @@ typedef struct ring ring_t;
 extern ring_t *ring_create( size_t ringlen,
 			    size_t bufsz,
 			    bool_t pinpr,
-			    void ( * threadfunc )( void *clientctxp,
-					    int ( * entryp )( void *ringctxp ),
-						   void *ringctxp ),
+			    ix_t drive_index,
 			    int ( * readfunc )( void *clientctxp, char *bufp ),
 			    int ( * writefunc )( void *clientctxp, char *bufp ),
 			    void *clientctxp,
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
