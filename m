Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2LBBXo200871 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 16:11:11 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 4/8] xfsdump: simplify qlock ordinal bitmap
Date: Wed,  2 Nov 2011 16:10:50 -0500
Message-Id: <1320268254-20583-5-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
References: <1320268254-20583-1-git-send-email-wkendall@sgi.com>
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

The qlock abstraction manages an array of ordinal bitmaps, one bitmap
for each thread. The bitmap indicates which locks a thread is holding
and is used to verify that the locks are obtained in the correct order.

There is no need to use an array to store the bitmaps, and in fact
adding entries to the array is broken because qlock_thrdcnt is not
protected by a lock. A simpler approach is to create a per-thread bitmap
using thread local storage.

With this change, there is no need for each new thread to register with
the qlock abstraction, so qlock_thrdinit() goes away. Remove
qlock_init() since it can be statically initialized, and that means
there's no need for a flag (qlock_inited) indicating that the module has
been initialized.  Also there's no longer a need to track or limit the
number of threads that the qlock abstraction can handle.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 common/cldmgr.c |    4 -
 common/main.c   |    7 --
 common/qlock.c  |  195 ++++---------------------------------------------------
 common/qlock.h  |   11 +---
 4 files changed, 14 insertions(+), 203 deletions(-)

diff --git a/common/cldmgr.c b/common/cldmgr.c
index 7784a15..d327bab 100644
--- a/common/cldmgr.c
+++ b/common/cldmgr.c
@@ -213,12 +213,8 @@ cldmgr_entry( void *arg1 )
 {
 	cld_t *cldp = ( cld_t * )arg1;
 	pid_t pid = getpid( );
-	/* REFERENCED */
-	bool_t ok;
 
 	cldp->c_pid = pid;
-	ok = qlock_thrdinit( );
-	ASSERT( ok );
 	if ( ( intgen_t )( cldp->c_streamix ) >= 0 ) {
 		stream_register( pid, ( intgen_t )cldp->c_streamix );
 	}
diff --git a/common/main.c b/common/main.c
index be8a921..25c0838 100644
--- a/common/main.c
+++ b/common/main.c
@@ -357,13 +357,6 @@ main( int argc, char *argv[] )
 		miniroot = BOOL_TRUE;
 	}
 
-	/* initialize the spinlock allocator
-	 */
-	ok = qlock_init( );
-	if ( ! ok ) {
-		return mlog_exit(EXIT_ERROR, RV_INIT);
-	}
-
 	/* initialize message logging (stage 2) - allocate the message lock
 	 */
 	ok = mlog_init2( );
diff --git a/common/qlock.c b/common/qlock.c
index 5b87b3b..67d1291 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -48,14 +48,6 @@ struct qsem {
 };
 typedef struct  qsem qsem_t;
 
-#define QLOCK_THRDCNTMAX			256
-	/* arbitrary limit on number of threads supported
-	 */
-
-static size_t qlock_thrdcnt;
-	/* how many threads have checked in
-	 */
-
 typedef size_t ordmap_t;
 	/* bitmap of ordinals. used to track what ordinals have
 	 * been allocated.
@@ -69,12 +61,7 @@ static ordmap_t qlock_ordalloced;
 	/* to enforce allocation of only one lock to each ordinal value
 	 */
 
-struct thrddesc {
-	pthread_t td_tid;
-	ordmap_t td_ordmap;
-};
-typedef struct thrddesc thrddesc_t;
-static thrddesc_t qlock_thrddesc[ QLOCK_THRDCNTMAX ];
+static __thread ordmap_t thread_ordmap;
 	/* holds the ordmap for each thread
 	 */
 
@@ -94,69 +81,12 @@ static thrddesc_t qlock_thrddesc[ QLOCK_THRDCNTMAX ];
 	/* checks if any bits less than ord are set in the ordmap
 	 */
 
-/* REFERENCED */
-static bool_t qlock_inited = BOOL_FALSE;
-	/* to sanity check initialization
-	 */
-
-/* forward declarations
- */
-static void qlock_ordmap_add( pthread_t tid );
-static ordmap_t *qlock_ordmapp_get( pthread_t tid );
-static ix_t qlock_thrdix_get( pthread_t tid );
-
-bool_t
-qlock_init( void )
-{
-	/* sanity checks
-	 */
-	ASSERT( ! qlock_inited );
-
-	/* initially no threads checked in
-	 */
-	qlock_thrdcnt = 0;
-
-	/* initially no ordinals allocated
-	 */
-	qlock_ordalloced = 0;
-
-	/* now say we are initialized
-	 */
-	qlock_inited = BOOL_TRUE;
-
-	/* add the parent thread to the thread list
-	 */
-	if ( ! qlock_thrdinit( )) {
-		qlock_inited = BOOL_FALSE;
-		return BOOL_FALSE;
-	}
-
-	return BOOL_TRUE;
-}
-
-bool_t
-qlock_thrdinit( void )
-{
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
-	/* add thread to ordmap list
-	 */
-	qlock_ordmap_add( pthread_self() );
-
-	return BOOL_TRUE;
-}
 
 qlockh_t
 qlock_alloc( ix_t ord )
 {
 	qlock_t *qlockp;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* verify the ordinal is not already taken, and mark as taken
 	 */
 	ASSERT( ! QLOCK_ORDMAP_GET( qlock_ordalloced, ord ));
@@ -183,48 +113,34 @@ qlock_lock( qlockh_t qlockh )
 {
 	qlock_t *qlockp = ( qlock_t * )qlockh;
 	pthread_t tid;
-	ix_t thrdix;
-	ordmap_t *ordmapp;
 	/* REFERENCED */
 	intgen_t rval;
 	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
-	/* get the caller's tid and thread index
+	/* get the caller's tid
 	 */
 	tid = pthread_self();
 
-	thrdix = qlock_thrdix_get( tid );
-
-	/* get the ordmap for this thread
-	 */
-	ordmapp = qlock_ordmapp_get( tid );
-
 	/* assert that this lock not already held by this thread
 	 */
-	if ( QLOCK_ORDMAP_GET( *ordmapp, qlockp->ql_ord )) {
+	if ( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
-		      _("lock already held: thrd %d tid %lu ord %d map %x\n"),
-		      thrdix,
+		      _("lock already held: tid %lu ord %d map %x\n"),
 		      tid,
 		      qlockp->ql_ord,
-		      *ordmapp );
+		      thread_ordmap );
 	}
-	ASSERT( ! QLOCK_ORDMAP_GET( *ordmapp, qlockp->ql_ord ));
+	ASSERT( ! QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
 
 	/* assert that no locks with a lesser ordinal are held by this thread
 	 */
-	if ( QLOCK_ORDMAP_CHK( *ordmapp, qlockp->ql_ord )) {
+	if ( QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
-		      _("lock ordinal violation: thrd %d tid %lu ord %d map %x\n"),
-		      thrdix,
+		      _("lock ordinal violation: tid %lu ord %d map %x\n"),
 		      tid,
 		      qlockp->ql_ord,
-		      *ordmapp );
+		      thread_ordmap );
 	}
-	ASSERT( ! QLOCK_ORDMAP_CHK( *ordmapp, qlockp->ql_ord ));
+	ASSERT( ! QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord ));
 
 	/* acquire the lock
 	 */
@@ -233,32 +149,23 @@ qlock_lock( qlockh_t qlockh )
 
 	/* add ordinal to this threads ordmap
 	 */
-	QLOCK_ORDMAP_SET( *ordmapp, qlockp->ql_ord );
+	QLOCK_ORDMAP_SET( thread_ordmap, qlockp->ql_ord );
 }
 
 void
 qlock_unlock( qlockh_t qlockh )
 {
 	qlock_t *qlockp = ( qlock_t * )qlockh;
-	ordmap_t *ordmapp;
 	/* REFERENCED */
 	intgen_t rval;
 	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
-	/* get the ordmap for this thread
-	 */
-	ordmapp = qlock_ordmapp_get( pthread_self() );
-
 	/* verify lock is held by this thread
 	 */
-	ASSERT( QLOCK_ORDMAP_GET( *ordmapp, qlockp->ql_ord ));
+	ASSERT( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
 
 	/* clear lock's ord from thread's ord map
 	 */
-	QLOCK_ORDMAP_CLR( *ordmapp, qlockp->ql_ord );
+	QLOCK_ORDMAP_CLR( thread_ordmap, qlockp->ql_ord );
 	
 	/* release the lock
 	 */
@@ -271,10 +178,6 @@ qsem_alloc( ix_t cnt )
 {
 	qsem_t *qsemp;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* allocate a semaphore
 	 */
 	qsemp = ( qsem_t * )calloc( 1, sizeof( qsem_t ));
@@ -297,10 +200,6 @@ qsem_free( qsemh_t qsemh )
 {
 	qsem_t *qsemp = ( qsem_t * )qsemh;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* destroy the mutex and condition
 	 */
 	pthread_mutex_destroy( &qsemp->qs_mutex );
@@ -317,10 +216,6 @@ qsemP( qsemh_t qsemh )
 	qsem_t *qsemp = ( qsem_t * )qsemh;
 	intgen_t rval;
 	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* acquire the lock
 	 */
 	rval = pthread_mutex_lock( &qsemp->qs_mutex );
@@ -347,10 +242,6 @@ qsemV( qsemh_t qsemh )
 	qsem_t *qsemp = ( qsem_t * )qsemh;
 	intgen_t rval;
 	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* acquire the lock
 	 */
 	rval = pthread_mutex_lock( &qsemp->qs_mutex );
@@ -375,10 +266,6 @@ qsemPwouldblock( qsemh_t qsemh )
 	ix_t count;
 	intgen_t rval;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* acquire the lock
 	 */
 	rval = pthread_mutex_lock( &qsemp->qs_mutex );
@@ -403,10 +290,6 @@ qsemPavail( qsemh_t qsemh )
 	ix_t count;
 	intgen_t rval;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* acquire the lock
 	 */
 	rval = pthread_mutex_lock( &qsemp->qs_mutex );
@@ -431,10 +314,6 @@ qsemPblocked( qsemh_t qsemh )
 	ix_t waiters;
 	intgen_t rval;
 
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-
 	/* acquire the lock
 	 */
 	rval = pthread_mutex_lock( &qsemp->qs_mutex );
@@ -451,51 +330,3 @@ qsemPblocked( qsemh_t qsemh )
 
 	return waiters;
 }
-
-/* internal ordinal map abstraction
- */
-static void
-qlock_ordmap_add( pthread_t tid )
-{
-	ASSERT( qlock_thrdcnt < QLOCK_THRDCNTMAX );
-	qlock_thrddesc[ qlock_thrdcnt ].td_tid = tid;
-	qlock_thrddesc[ qlock_thrdcnt ].td_ordmap = 0;
-	qlock_thrdcnt++;
-}
-
-static thrddesc_t *
-qlock_thrddesc_get( pthread_t tid )
-{
-	thrddesc_t *p;
-	thrddesc_t *endp;
-
-	for ( p = &qlock_thrddesc[ 0 ],
-	      endp = &qlock_thrddesc[ qlock_thrdcnt ]
-	      ;
-	      p < endp
-	      ;
-	      p++ ) {
-		if ( pthread_equal( p->td_tid, tid ) ) {
-			return p;
-		}
-	}
-
-	return 0;
-}
-
-static ordmap_t *
-qlock_ordmapp_get( pthread_t tid )
-{
-	thrddesc_t *p;
-	p = qlock_thrddesc_get( tid );
-	return &p->td_ordmap;
-}
-
-static ix_t
-qlock_thrdix_get( pthread_t tid )
-{
-	thrddesc_t *p;
-	p = qlock_thrddesc_get( tid );
-	ASSERT( p >= &qlock_thrddesc[ 0 ] );
-	return ( ix_t )( p - &qlock_thrddesc[ 0 ] );
-}
diff --git a/common/qlock.h b/common/qlock.h
index 5ac51bd..da2031c 100644
--- a/common/qlock.h
+++ b/common/qlock.h
@@ -21,7 +21,7 @@
 /* qlock - quick locks abstraction
  *
  * threads may allocate quick locks using qlock_alloc, and free them with
- * qlock_free. the abstraction is initialized with qlock_init.
+ * qlock_free.
  *
  * deadlock detection is accomplished by giving an ordinal number to each
  * lock allocated, and record all locks held by each thread. locks may not
@@ -48,15 +48,6 @@ typedef void *qlockh_t;
 	/* opaque handle
 	 */
 
-extern bool_t qlock_init( void );
-	/* called by main to initialize abstraction. returns FALSE if
-	 * utility should abort.
-	 */
-
-extern bool_t qlock_thrdinit( void );
-	/* called by each thread to prepare it for participation
-	 */
-
 extern qlockh_t qlock_alloc( ix_t ord );
 	/* allocates a qlock with the specified ordinal. returns
 	 * NULL if lock can't be allocated.
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
