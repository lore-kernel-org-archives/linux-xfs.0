Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Kxec1076025 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:41 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 3/8] xfsdump: implement lock abstraction with pthreads
Date: Mon,  7 Nov 2011 14:58:26 -0600
Message-Id: <1320699511-12281-4-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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

This patch implements xfsdump's locking abstraction using pthread
locking primitives. The obsolete IRIX locking code has been removed.

The POSIX semaphore implementation on Linux does not provide a count
of threads waiting to decrement the semaphore, so qsemPblocked()
has been removed. It was called from a few asserts, but the current
count of the semaphore was also checked in adjacent asserts, so
it was deemed acceptable to remove the qsemPblocked() asserts.

A few debug-level log calls had to be changed to use the "no lock"
flag to prevent locks from being acquired out of order. This is
used in various debug messages throughout xfsdump.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
Changes in v2:
   - Use POSIX semaphores (sem_t) instead of rolling our own
     with a pthread mutex and condition, as suggested by
     Christoph.

 common/main.c     |    2 +-
 common/qlock.c    |  355 +++++++++++------------------------------------------
 common/qlock.h    |   13 +--
 common/ring.c     |    4 -
 restore/content.c |   17 ++-
 5 files changed, 88 insertions(+), 303 deletions(-)

diff --git a/common/main.c b/common/main.c
index 08be16e..be8a921 100644
--- a/common/main.c
+++ b/common/main.c
@@ -359,7 +359,7 @@ main( int argc, char *argv[] )
 
 	/* initialize the spinlock allocator
 	 */
-	ok = qlock_init( miniroot );
+	ok = qlock_init( );
 	if ( ! ok ) {
 		return mlog_exit(EXIT_ERROR, RV_INIT);
 	}
diff --git a/common/qlock.c b/common/qlock.c
index 6c9ee16..adaa7dd 100644
--- a/common/qlock.c
+++ b/common/qlock.c
@@ -19,6 +19,9 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 
+#include <pthread.h>
+#include <semaphore.h>
+
 #include "types.h"
 #include "qlock.h"
 #include "mlog.h"
@@ -27,24 +30,13 @@ struct qlock {
 	ix_t ql_ord;
 		/* ordinal position of this lock
 		 */
-	pid_t ql_owner;
-		/* who owns this lock
-		 */
-#ifdef HIDDEN
-	ulock_t ql_uslockh;
-		/* us lock handle
-		 */
-#endif /* HIDDEN */
+	pthread_mutex_t ql_mutex;
 };
 
 typedef struct  qlock qlock_t;
 	/* internal qlock
 	 */
 
-#define QLOCK_SPINS			0x1000
-	/* how many times to spin on lock before sleeping for it
-	 */
-
 #define QLOCK_THRDCNTMAX			256
 	/* arbitrary limit on number of threads supported
 	 */
@@ -67,15 +59,13 @@ static ordmap_t qlock_ordalloced;
 	 */
 
 struct thrddesc {
-	pid_t td_pid;
+	pthread_t td_tid;
 	ordmap_t td_ordmap;
 };
 typedef struct thrddesc thrddesc_t;
-#ifdef HIDDEN
 static thrddesc_t qlock_thrddesc[ QLOCK_THRDCNTMAX ];
 	/* holds the ordmap for each thread
 	 */
-#endif
 
 #define QLOCK_ORDMAP_SET( ordmap, ord )	( ordmap |= 1U << ord )
 	/* sets the ordinal bit in an ordmap
@@ -93,21 +83,6 @@ static thrddesc_t qlock_thrddesc[ QLOCK_THRDCNTMAX ];
 	/* checks if any bits less than ord are set in the ordmap
 	 */
 
-#ifdef HIDDEN
-static usptr_t *qlock_usp;
-#else
-static void *qlock_usp;
-#endif /* HIDDEN */
-
-	/* pointer to shared arena from which locks are allocated
-	 */
-
-#ifdef HIDDEN
-static char *qlock_arenaroot = "xfsrestoreqlockarena";
-	/* shared arena file name root
-	 */
-#endif
-
 /* REFERENCED */
 static bool_t qlock_inited = BOOL_FALSE;
 	/* to sanity check initialization
@@ -115,22 +90,13 @@ static bool_t qlock_inited = BOOL_FALSE;
 
 /* forward declarations
  */
-#ifdef HIDDEN
-static void qlock_ordmap_add( pid_t pid );
-static ordmap_t *qlock_ordmapp_get( pid_t pid );
-static ix_t qlock_thrdix_get( pid_t pid );
-#endif
+static void qlock_ordmap_add( pthread_t tid );
+static ordmap_t *qlock_ordmapp_get( pthread_t tid );
+static ix_t qlock_thrdix_get( pthread_t tid );
 
 bool_t
-qlock_init( bool_t miniroot )
+qlock_init( void )
 {
-#ifdef HIDDEN
-	char arenaname[ 100 ];
-	/* REFERENCED */
-	intgen_t nwritten;
-	intgen_t rval;
-#endif
-
 	/* sanity checks
 	 */
 	ASSERT( ! qlock_inited );
@@ -143,44 +109,6 @@ qlock_init( bool_t miniroot )
 	 */
 	qlock_ordalloced = 0;
 
-	/* if miniroot, fake it
-	 */
-	if ( miniroot ) {
-		qlock_inited = BOOL_TRUE;
-		qlock_usp = 0;
-		return BOOL_TRUE;
-	}
-#ifdef HIDDEN
-
-	/* generate the arena name
-	 */
-	nwritten = sprintf( arenaname,
-			    "/tmp/%s.%d",
-			    qlock_arenaroot,
-			    get_pid() );
-	ASSERT( nwritten > 0 );
-	ASSERT( ( size_t )nwritten < sizeof( arenaname ));
-
-	/* configure shared arenas to automatically unlink on last close
-	 */
-	rval = usconfig( CONF_ARENATYPE, ( u_intgen_t )US_SHAREDONLY );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
-		      _("unable to configure shared arena for auto unlink: %s\n"),
-		      strerror( errno ));
-		return BOOL_FALSE;
-	}
-
-	/* allocate a shared arena for the locks
-	 */
-	qlock_usp = usinit( arenaname );
-	if ( ! qlock_usp ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
-		      _("unable to allocate shared arena for thread locks: %s\n"),
-		      strerror( errno ));
-		return BOOL_FALSE;
-	}
-
 	/* now say we are initialized
 	 */
 	qlock_inited = BOOL_TRUE;
@@ -191,7 +119,6 @@ qlock_init( bool_t miniroot )
 		qlock_inited = BOOL_FALSE;
 		return BOOL_FALSE;
 	}
-#endif /* HIDDEN */
 
 	return BOOL_TRUE;
 }
@@ -199,28 +126,13 @@ qlock_init( bool_t miniroot )
 bool_t
 qlock_thrdinit( void )
 {
-#ifdef HIDDEN
-	intgen_t rval;
-
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
-
-	/* add thread to shared arena
-	 */
-	rval = usadd( qlock_usp );
-	if ( rval ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
-		      _("unable to add thread to shared arena: %s\n"),
-		      strerror( errno ));
-		return BOOL_FALSE;
-	}
 
 	/* add thread to ordmap list
 	 */
-	qlock_ordmap_add( get_pid() );
-#endif /* HIDDEN */
+	qlock_ordmap_add( pthread_self() );
 
 	return BOOL_TRUE;
 }
@@ -244,14 +156,9 @@ qlock_alloc( ix_t ord )
 	qlockp = ( qlock_t * )calloc( 1, sizeof( qlock_t ));
 	ASSERT( qlockp );
 
-#ifdef HIDDEN
-	/* allocate a us lock: bypass if miniroot
+	/* initialize the mutex
 	 */
-	if ( qlock_usp ) {
-		qlockp->ql_uslockh = usnewlock( qlock_usp );
-		ASSERT( qlockp->ql_uslockh );
-	}
-#endif /* HIDDEN */
+	pthread_mutex_init( &qlockp->ql_mutex, NULL );
 
 	/* assign the ordinal position
 	 */
@@ -263,44 +170,34 @@ qlock_alloc( ix_t ord )
 void
 qlock_lock( qlockh_t qlockh )
 {
-#ifdef HIDDEN
 	qlock_t *qlockp = ( qlock_t * )qlockh;
-	pid_t pid;
+	pthread_t tid;
 	ix_t thrdix;
 	ordmap_t *ordmapp;
 	/* REFERENCED */
-	bool_t lockacquired;
-#endif
+	intgen_t rval;
 	
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
 
-	/* bypass if miniroot
-	 */
-	if ( ! qlock_usp ) {
-		return;
-	}
-
-#ifdef HIDDEN
-
-	/* get the caller's pid and thread index
+	/* get the caller's tid and thread index
 	 */
-	pid = get_pid();
+	tid = pthread_self();
 
-	thrdix = qlock_thrdix_get( pid );
+	thrdix = qlock_thrdix_get( tid );
 
 	/* get the ordmap for this thread
 	 */
-	ordmapp = qlock_ordmapp_get( pid );
+	ordmapp = qlock_ordmapp_get( tid );
 
-	/* assert that this lock not already held
+	/* assert that this lock not already held by this thread
 	 */
 	if ( QLOCK_ORDMAP_GET( *ordmapp, qlockp->ql_ord )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
-		      _("lock already held: thrd %d pid %d ord %d map %x\n"),
+		      _("lock already held: thrd %d tid %lu ord %d map %x\n"),
 		      thrdix,
-		      pid,
+		      tid,
 		      qlockp->ql_ord,
 		      *ordmapp );
 	}
@@ -310,278 +207,176 @@ qlock_lock( qlockh_t qlockh )
 	 */
 	if ( QLOCK_ORDMAP_CHK( *ordmapp, qlockp->ql_ord )) {
 		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_NOLOCK,
-		      _("lock ordinal violation: thrd %d pid %d ord %d map %x\n"),
+		      _("lock ordinal violation: thrd %d tid %lu ord %d map %x\n"),
 		      thrdix,
-		      pid,
+		      tid,
 		      qlockp->ql_ord,
 		      *ordmapp );
 	}
 	ASSERT( ! QLOCK_ORDMAP_CHK( *ordmapp, qlockp->ql_ord ));
 
-	/* acquire the us lock
+	/* acquire the lock
 	 */
-	lockacquired = uswsetlock( qlockp->ql_uslockh, QLOCK_SPINS );
-	ASSERT( lockacquired );
-
-	/* verify lock is not already held
-	 */
-	ASSERT( ! qlockp->ql_owner );
+	rval = pthread_mutex_lock( &qlockp->ql_mutex );
+	ASSERT( !rval );
 
 	/* add ordinal to this threads ordmap
 	 */
 	QLOCK_ORDMAP_SET( *ordmapp, qlockp->ql_ord );
-
-	/* indicate the lock's owner
-	 */
-	qlockp->ql_owner = pid;
-#endif /* HIDDEN */
 }
 
 void
 qlock_unlock( qlockh_t qlockh )
 {
-#ifdef HIDDEN
 	qlock_t *qlockp = ( qlock_t * )qlockh;
-	pid_t pid;
 	ordmap_t *ordmapp;
 	/* REFERENCED */
 	intgen_t rval;
-#endif
 	
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
 
-	/* bypass if miniroot
-	 */
-	if ( ! qlock_usp ) {
-		return;
-	}
-
-#ifdef HIDDEN
-	/* get the caller's pid
-	 */
-	pid = get_pid();
-
 	/* get the ordmap for this thread
 	 */
-	ordmapp = qlock_ordmapp_get( pid );
+	ordmapp = qlock_ordmapp_get( pthread_self() );
 
 	/* verify lock is held by this thread
 	 */
 	ASSERT( QLOCK_ORDMAP_GET( *ordmapp, qlockp->ql_ord ));
-	ASSERT( qlockp->ql_owner == pid );
-
-	/* clear lock owner
-	 */
-	qlockp->ql_owner = 0;
 
 	/* clear lock's ord from thread's ord map
 	 */
 	QLOCK_ORDMAP_CLR( *ordmapp, qlockp->ql_ord );
 	
-	/* release the us lock
+	/* release the lock
 	 */
-	rval = usunsetlock( qlockp->ql_uslockh );
+	rval = pthread_mutex_unlock( &qlockp->ql_mutex );
 	ASSERT( ! rval );
-#endif /* HIDDEN */
 }
 
 qsemh_t
 qsem_alloc( ix_t cnt )
 {
-#ifdef HIDDEN
-	usema_t *usemap;
+	sem_t *semp;
+	intgen_t rval;
 
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
-	/* allocate a us semaphore
+	/* allocate a semaphore
 	 */
-	usemap = usnewsema( qlock_usp, ( intgen_t )cnt );
-	ASSERT( usemap );
+	semp = ( sem_t * )calloc( 1, sizeof( sem_t ));
+	ASSERT( semp );
 
-	return ( qsemh_t )usemap;
-#else
-	return 0;
-#endif /* HIDDEN */
+	/* initialize the semaphore
+	 */
+	rval = sem_init( semp, 0, cnt );
+	ASSERT( !rval );
+
+	return ( qsemh_t )semp;
 }
 
 void
 qsem_free( qsemh_t qsemh )
 {
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
+	sem_t *semp = ( sem_t * )qsemh;
+	intgen_t rval;
 
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
-	/* free the us semaphore
+	/* destroy the mutex and condition
+	 */
+	rval = sem_destroy( semp );
+	ASSERT( !rval );
+
+	/* free the semaphore
 	 */
-	usfreesema( usemap, qlock_usp );
-#endif /* HIDDEN */
+	free( semp );
 }
 
 void
 qsemP( qsemh_t qsemh )
 {
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
+	sem_t *semp = ( sem_t * )qsemh;
 	intgen_t rval;
 	
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
 	/* "P" the semaphore
 	 */
-	rval = uspsema( usemap );
-	if ( rval != 1 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
-		      _("unable to \"P\" semaphore: "
-		      "rval == %d, errno == %d (%s)\n"),
-		      rval,
-		      errno,
-		      strerror( errno ));
-	}
-	ASSERT( rval == 1 );
-#endif /* HIDDEN */
+	rval = sem_wait( semp );
+	ASSERT( !rval );
 }
 
 void
 qsemV( qsemh_t qsemh )
 {
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
+	sem_t *semp = ( sem_t * )qsemh;
 	intgen_t rval;
 	
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
 	/* "V" the semaphore
 	 */
-	rval = usvsema( usemap );
-	if ( rval != 0 ) {
-		mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_NOLOCK,
-		      _("unable to \"V\" semaphore: "
-		      "rval == %d, errno == %d (%s)\n"),
-		      rval,
-		      errno,
-		      strerror( errno ));
-	}
-	ASSERT( rval == 0 );
-#endif /* HIDDEN */
+	rval = sem_post( semp );
+	ASSERT( !rval );
 }
 
 bool_t
 qsemPwouldblock( qsemh_t qsemh )
 {
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
+	sem_t *semp = ( sem_t * )qsemh;
+	int count;
 	intgen_t rval;
-	
+
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
-	/* check the semaphore
-	 */
-	rval = ustestsema( usemap );
+	rval = sem_getvalue( semp, &count );
+	ASSERT( !rval );
 
-	/* if equal to zero, no tokens left. if less than zero, other thread(s)
-	 * currently waiting.
-	 */
-	if ( rval <= 0 ) {
-		return BOOL_TRUE;
-	} else {
-		return BOOL_FALSE;
-	}
-#else
-return BOOL_FALSE;
-#endif /* HIDDEN */
+	return count <= 0 ? BOOL_TRUE : BOOL_FALSE;
 }
 
 size_t
 qsemPavail( qsemh_t qsemh )
 {
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
+	sem_t *semp = ( sem_t * )qsemh;
+	int count;
 	intgen_t rval;
-	
-	/* sanity checks
-	 */
-	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
-
-	/* check the semaphore
-	 */
-	rval = ustestsema( usemap );
-
-	/* if greater or equal to zero, no one is blocked and that is the number
-	 * of resources available. if less than zero, absolute value is the
-	 * number of blocked threads.
-	 */
-	if ( rval < 0 ) {
-		return 0;
-	} else {
-		return ( size_t )rval;
-	}
-#else
-return 0;
-#endif /* HIDDEN */
-}
 
-size_t
-qsemPblocked( qsemh_t qsemh )
-{
-#ifdef HIDDEN
-	usema_t *usemap = ( usema_t * )qsemh;
-	intgen_t rval;
-	
 	/* sanity checks
 	 */
 	ASSERT( qlock_inited );
-	ASSERT( qlock_usp );
 
-	/* check the semaphore
-	 */
-	rval = ustestsema( usemap );
+	rval = sem_getvalue( semp, &count );
+	ASSERT( !rval );
 
-	/* if greater or equal to zero, no one is blocked. if less than zero,
-	 * absolute value is the number of blocked threads.
-	 */
-	if ( rval < 0 ) {
-		return ( size_t )( 0 - rval );
-	} else {
-		return 0;
-	}
-#else
-return 0;
-#endif /* HIDDEN */
+	return count < 0 ? 0 : count;
 }
 
 /* internal ordinal map abstraction
  */
-#ifdef HIDDEN
 static void
-qlock_ordmap_add( pid_t pid )
+qlock_ordmap_add( pthread_t tid )
 {
 	ASSERT( qlock_thrdcnt < QLOCK_THRDCNTMAX );
-	qlock_thrddesc[ qlock_thrdcnt ].td_pid = pid;
+	qlock_thrddesc[ qlock_thrdcnt ].td_tid = tid;
 	qlock_thrddesc[ qlock_thrdcnt ].td_ordmap = 0;
 	qlock_thrdcnt++;
 }
 
 static thrddesc_t *
-qlock_thrddesc_get( pid_t pid )
+qlock_thrddesc_get( pthread_t tid )
 {
 	thrddesc_t *p;
 	thrddesc_t *endp;
@@ -592,29 +387,27 @@ qlock_thrddesc_get( pid_t pid )
 	      p < endp
 	      ;
 	      p++ ) {
-		if ( p->td_pid == pid ) {
+		if ( pthread_equal( p->td_tid, tid ) ) {
 			return p;
 		}
 	}
 
-	ASSERT( 0 );
 	return 0;
 }
 
 static ordmap_t *
-qlock_ordmapp_get( pid_t pid )
+qlock_ordmapp_get( pthread_t tid )
 {
 	thrddesc_t *p;
-	p = qlock_thrddesc_get( pid );
+	p = qlock_thrddesc_get( tid );
 	return &p->td_ordmap;
 }
 
 static ix_t
-qlock_thrdix_get( pid_t pid )
+qlock_thrdix_get( pthread_t tid )
 {
 	thrddesc_t *p;
-	p = qlock_thrddesc_get( pid );
+	p = qlock_thrddesc_get( tid );
 	ASSERT( p >= &qlock_thrddesc[ 0 ] );
 	return ( ix_t )( p - &qlock_thrddesc[ 0 ] );
 }
-#endif
diff --git a/common/qlock.h b/common/qlock.h
index 1880aff..ae411bb 100644
--- a/common/qlock.h
+++ b/common/qlock.h
@@ -21,19 +21,13 @@
 /* qlock - quick locks abstraction
  *
  * threads may allocate quick locks using qlock_alloc, and free them with
- * qlock_free. the abstraction is initialized with qlock_init. the underlying
- * mechanism is the IRIX us lock primitive. in order to use this, a temporary
- * shared arena is created in /tmp. this will be automatically unlinked
- * when the last thread exits.
+ * qlock_free. the abstraction is initialized with qlock_init.
  *
  * deadlock detection is accomplished by giving an ordinal number to each
  * lock allocated, and record all locks held by each thread. locks may not
  * be acquired out of order. that is, subsequently acquired locks must have
  * a lower ordinal than all locks currently held. for convenience, the ordinals
  * of all locks to be allocated will be defined in this file.
- *
- * ADDITION: added counting semaphores. simpler to do here since same
- * shared arena can be used.
  */
 
 #define QLOCK_ORD_CRIT	0
@@ -54,7 +48,7 @@ typedef void *qlockh_t;
 	/* opaque handle
 	 */
 
-extern bool_t qlock_init( bool_t miniroot );
+extern bool_t qlock_init( void );
 	/* called by main to initialize abstraction. returns FALSE if
 	 * utility should abort.
 	 */
@@ -98,8 +92,5 @@ extern bool_t qsemPwouldblock( qsemh_t qsemh );
 extern size_t qsemPavail( qsemh_t qsemh );
 	/* number of resources available
 	 */
-extern size_t qsemPblocked( qsemh_t qsemh );
-	/* number of threads currently blocked on this semaphore
-	 */
 
 #endif /* QLOCK_H */
diff --git a/common/ring.c b/common/ring.c
index e1dddba..b6074d1 100644
--- a/common/ring.c
+++ b/common/ring.c
@@ -258,9 +258,7 @@ ring_reset( ring_t *ringp, ring_msg_t *msgp )
 	/* re-initialize the ring
 	 */
 	ASSERT( qsemPavail( ringp->r_ready_qsemh ) == 0 );
-	ASSERT( qsemPblocked( ringp->r_ready_qsemh ) == 0 );
 	ASSERT( qsemPavail( ringp->r_active_qsemh ) == 0 );
-	ASSERT( qsemPblocked( ringp->r_active_qsemh ) <= 1 );
 	ringp->r_ready_in_ix = 0;
 	ringp->r_ready_out_ix = 0;
 	ringp->r_active_in_ix = 0;
@@ -277,9 +275,7 @@ ring_reset( ring_t *ringp, ring_msg_t *msgp )
 		qsemV( ringp->r_ready_qsemh );
 	}
 	ASSERT( qsemPavail( ringp->r_ready_qsemh ) == ringp->r_len );
-	ASSERT( qsemPblocked( ringp->r_ready_qsemh ) == 0 );
 	ASSERT( qsemPavail( ringp->r_active_qsemh ) == 0 );
-	ASSERT( qsemPblocked( ringp->r_active_qsemh ) <= 1 );
 }
 
 void
diff --git a/restore/content.c b/restore/content.c
index 2228a7f..8dfa456 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8911,7 +8911,8 @@ partial_reg( ix_t d_index,
 
 	/* If not found, find a free one, fill it in and return */
 	if ( ! isptr ) {
-		mlog(MLOG_NITTY, "partial_reg: no entry found for %llu\n", ino);
+		mlog(MLOG_NITTY | MLOG_NOLOCK,
+			"partial_reg: no entry found for %llu\n", ino);
 		/* find a free one */
 		for (i=0; i < partialmax; i++ ) {
 			if (persp->a.parrest[i].is_ino == 0) {
@@ -8950,8 +8951,10 @@ found:
 		/* no existing entry for this drive, fill in the values */
 		bsptr->offset = offset;
 		bsptr->endoffset = endoffset;
-		mlog(MLOG_NITTY, "partial_reg: update entry [%d]: "
-		     "<off = %lld, end = %lld>\n", d_index, offset, endoffset);
+		mlog(MLOG_NITTY | MLOG_NOLOCK,
+			"partial_reg: update entry [%d]: "
+			"<off = %lld, end = %lld>\n",
+			d_index, offset, endoffset);
 	} else {
 		bool_t ret;
 
@@ -8960,9 +8963,11 @@ found:
 		 */
 		bsptr->endoffset = endoffset;
 		ret = partial_check2(isptr, fsize);
-		mlog(MLOG_NITTY, "partial_reg: extend entry [%d]: "
-		     "<end = %lld>\n", d_index, endoffset);
-		mlog(MLOG_NITTY, "partial_reg: partial_check returns: %d\n", ret);
+		mlog(MLOG_NITTY | MLOG_NOLOCK,
+			"partial_reg: extend entry [%d]: <end = %lld>\n",
+			d_index, endoffset);
+		mlog(MLOG_NITTY | MLOG_NOLOCK,
+			"partial_reg: partial_check returns: %d\n", ret);
 	}
 
 	pi_unlock();
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
