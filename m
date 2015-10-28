Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69E2529DF5
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 06:51:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6BA3AC002
	for <xfs@oss.sgi.com>; Wed, 28 Oct 2015 04:51:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oTlWQniSXa8nVeAq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 28 Oct 2015 04:51:25 -0700 (PDT)
Date: Wed, 28 Oct 2015 07:51:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] cleanup: get rid of ASSERT
Message-ID: <20151028115121.GA50552@bfoster.bfoster>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
	<1444959901-31319-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444959901-31319-2-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 16, 2015 at 12:44:54PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> ASSERT comes from the xfs/xfs.h include, and we don't ever define
> DEBUG so we never get asserts built in. We want asserts built in for
> testing, but not for distro packages. The debian package already
> tries to do this by using "export DEBUG=-DNDEBUG" for the build
> context, but seeing as we pull in #define ASSERT(ex) (0) from the
> XFS headers it's a no-op.
> 
> Convert all the ASSERT calls to assert to remove this conflict with
> the xfsprogs headers and so local developer builds are built with
> asserts enabled.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

My initial concern when reading this was that asserts were now
unconditionally enabled. According to the man page, assert() is enabled
unless NDEBUG is defined at include time. The debian builder apparently
does this, but is this standard for other such utils?

That aside, this seems like an inconsistent approach from our other
tools. For example, the debian/rules from xfsprogs does the same thing,
yet DEBUG must be defined to enable asserts in the first place. If the
problem is that asserts cannot be enabled, I'm wondering why the
appropriate fix isn't to define DEBUG somewhere for debug-enabled builds
rather than unconditionally convert all of the ASSERT() calls into
actual assert()'s..? We do actually have a bunch of '#ifdef DEBUG' code
throughout xfsdump (and DEBUG appears in 'configure' as well, though I
have no idea if that actually does anything)...

Brian

>  common/arch_xlate.c     |   1 +
>  common/cldmgr.c         |   3 +-
>  common/cleanup.c        |   7 +-
>  common/content_common.c |  13 +-
>  common/content_inode.h  |   4 +-
>  common/dlog.c           |  13 +-
>  common/drive.c          |  17 ++-
>  common/drive_minrmt.c   | 369 ++++++++++++++++++++++-----------------------
>  common/drive_scsitape.c | 389 ++++++++++++++++++++++++------------------------
>  common/drive_simple.c   | 151 +++++++++----------
>  common/fs.c             |  23 +--
>  common/global.c         |  13 +-
>  common/hsmapi.c         |   1 +
>  common/inventory.c      |  33 ++--
>  common/lock.c           |   3 +-
>  common/main.c           |  99 ++++++------
>  common/media.c          |  21 +--
>  common/mlog.c           |  21 +--
>  common/openutil.c       |   3 +-
>  common/path.c           |  25 ++--
>  common/qlock.c          |  29 ++--
>  common/ring.c           |  65 ++++----
>  common/stream.c         |  15 +-
>  common/util.c           |  41 ++---
>  dump/content.c          | 239 ++++++++++++++---------------
>  dump/inomap.c           |  19 +--
>  inventory/inv_api.c     |  33 ++--
>  inventory/inv_core.c    |   7 +-
>  inventory/inv_files.c   |   9 +-
>  inventory/inv_fstab.c   |   5 +-
>  inventory/inv_idx.c     |  11 +-
>  inventory/inv_mgr.c     |   7 +-
>  inventory/inv_oref.c    |  51 +++----
>  inventory/inv_oref.h    |  24 +--
>  inventory/inv_stobj.c   |  23 +--
>  inventory/testmain.c    |  25 ++--
>  librmt/rmtioctl.c       |   1 +
>  restore/bag.c           |  19 +--
>  restore/content.c       | 309 +++++++++++++++++++-------------------
>  restore/dirattr.c       | 113 +++++++-------
>  restore/inomap.c        |  25 ++--
>  restore/namreg.c        |  39 ++---
>  restore/node.c          |  79 +++++-----
>  restore/tree.c          | 219 +++++++++++++--------------
>  restore/win.c           |  65 ++++----
>  45 files changed, 1362 insertions(+), 1319 deletions(-)
> 
> diff --git a/common/arch_xlate.c b/common/arch_xlate.c
> index bafc1a6..e6f897e 100644
> --- a/common/arch_xlate.c
> +++ b/common/arch_xlate.c
> @@ -18,6 +18,7 @@
>  
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
> +#include <assert.h>
>  
>  #include "arch_xlate.h"
>  #include "types.h"
> diff --git a/common/cldmgr.c b/common/cldmgr.c
> index be7de34..df33a3f 100644
> --- a/common/cldmgr.c
> +++ b/common/cldmgr.c
> @@ -25,6 +25,7 @@
>  #include <sys/prctl.h>
>  #include <errno.h>
>  #include <pthread.h>
> +#include <assert.h>
>  
>  #include "exit.h"
>  #include "types.h"
> @@ -79,7 +80,7 @@ cldmgr_create( int ( * entry )( void *arg1 ),
>  	cld_t *cldp;
>  	intgen_t rval;
>  
> -	ASSERT( pthread_equal( pthread_self( ), cldmgr_parenttid ) );
> +	assert( pthread_equal( pthread_self( ), cldmgr_parenttid ) );
>  
>  	cldp = cldmgr_getcld( );
>  	if ( ! cldp ) {
> diff --git a/common/cleanup.c b/common/cleanup.c
> index 42e8750..523f164 100644
> --- a/common/cleanup.c
> +++ b/common/cleanup.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <stdlib.h>
> +#include <assert.h>
>  
>  #include "cleanup.h"
>  
> @@ -51,7 +52,7 @@ cleanup_register_base( void ( * funcp )( void *arg1, void *arg2 ),
>  	cu_t *p;
>  
>  	p = ( cu_t * )calloc( 1, sizeof( cu_t ));
> -	ASSERT( p );
> +	assert( p );
>  	p->cu_funcp = funcp;
>  	p->cu_arg1 = arg1;
>  	p->cu_arg2 = arg2;
> @@ -94,7 +95,7 @@ cleanup_cancel( cleanup_t *cleanupp )
>  	cu_t *nextp;
>  	cu_t *prevp;
>  
> -	ASSERT( cu_rootp );
> +	assert( cu_rootp );
>  
>  	for ( prevp = 0, nextp = cu_rootp
>  	      ;
> @@ -103,7 +104,7 @@ cleanup_cancel( cleanup_t *cleanupp )
>  	      prevp = nextp, nextp = nextp->cu_nextp )
>  	;
>  
> -	ASSERT( nextp );
> +	assert( nextp );
>  	if ( prevp ) {
>  		prevp->cu_nextp = p->cu_nextp;
>  	} else {
> diff --git a/common/content_common.c b/common/content_common.c
> index 993ddae..65be31f 100644
> --- a/common/content_common.c
> +++ b/common/content_common.c
> @@ -24,6 +24,7 @@
>  #include <fcntl.h>
>  #include <errno.h>
>  #include <signal.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -66,7 +67,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* query: ask if media changed or declined
> @@ -77,13 +78,13 @@ retry:
>  		 (unsigned int)drivep->d_index );
>  	querycnt = 0;
>  	querystr[ querycnt++ ] = question;
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	dontix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("media change declined");
>  	doix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("media changed");
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	sigintix = IXMAX - 1;
>  
>  	responseix = dlog_multi_query( querystr,
> @@ -105,11 +106,11 @@ retry:
>  	} else if ( responseix == dontix ) {
>  		ackstr[ ackcnt++ ] = _("media change aborted\n");
>  	} else {
> -		ASSERT( responseix == sigintix );
> +		assert( responseix == sigintix );
>  		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
>  	}
>  
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_multi_ack( ackstr,
>  			ackcnt );
>  
> @@ -118,7 +119,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> diff --git a/common/content_inode.h b/common/content_inode.h
> index 8f0390c..9013ca4 100644
> --- a/common/content_inode.h
> +++ b/common/content_inode.h
> @@ -389,7 +389,7 @@ calc_checksum(void *bufp, size_t len)
>  	u_int32_t sum = 0;
>  	u_int32_t *sump = bufp;
>  	u_int32_t *endp = sump + len / sizeof(u_int32_t);
> -	ASSERT(len % sizeof(u_int32_t) == 0);
> +	assert(len % sizeof(u_int32_t) == 0);
>  	while (sump < endp)
>  		sum += *sump++;
>  	return ~sum + 1;
> @@ -401,7 +401,7 @@ is_checksum_valid(void *bufp, size_t len)
>  	u_int32_t sum = 0;
>  	u_int32_t *sump = bufp;
>  	u_int32_t *endp = sump + len / sizeof(u_int32_t);
> -	ASSERT(len % sizeof(u_int32_t) == 0);
> +	assert(len % sizeof(u_int32_t) == 0);
>  	while (sump < endp)
>  		sum += *sump++;
>  	return sum == 0 ? BOOL_TRUE : BOOL_FALSE;
> diff --git a/common/dlog.c b/common/dlog.c
> index ac0cafc..6220cfe 100644
> --- a/common/dlog.c
> +++ b/common/dlog.c
> @@ -26,6 +26,7 @@
>  #include <time.h>
>  #include <errno.h>
>  #include <signal.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -57,7 +58,7 @@ dlog_init( int argc, char *argv[ ] )
>  
>  	/* can only call once
>  	 */
> -	ASSERT( dlog_ttyfd == -1 );
> +	assert( dlog_ttyfd == -1 );
>  
>  	/* initially allow dialog, use stdin fd
>  	 */
> @@ -104,7 +105,7 @@ dlog_init( int argc, char *argv[ ] )
>  		struct stat statbuf;
>  		int rval;
>  
> -		ASSERT( dlog_ttyfd >= 0 );
> +		assert( dlog_ttyfd >= 0 );
>  		rval = fstat( dlog_ttyfd, &statbuf );
>  		if ( rval ) {
>  			mlog( MLOG_VERBOSE | MLOG_WARNING,
> @@ -186,7 +187,7 @@ dlog_multi_query( char *querystr[ ],
>  
>  	/* sanity
>  	 */
> -	ASSERT( dlog_allowed_flag );
> +	assert( dlog_allowed_flag );
>  
>  	/* display query description strings
>  	 */
> @@ -295,7 +296,7 @@ dlog_string_query( dlog_ucbp_t ucb, /* user's print func */
>  
>  	/* sanity
>  	 */
> -	ASSERT( dlog_allowed_flag );
> +	assert( dlog_allowed_flag );
>  
>  	/* call the caller's callback with his context, print context, and
>  	 * print operator
> @@ -359,7 +360,7 @@ dlog_string_query_print( void *ctxp, char *fmt, ... )
>  {
>  	va_list args;
>  
> -	ASSERT( ! ctxp );
> +	assert( ! ctxp );
>  
>  	va_start( args, fmt );
>  	mlog_va( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, fmt, args );
> @@ -510,7 +511,7 @@ promptinput( char *buf,
>  		}
>  		return BOOL_FALSE;
>  	} else {
> -		ASSERT( dlog_signo_received == -1 );
> +		assert( dlog_signo_received == -1 );
>  		*exceptionixp = 0;
>  		return BOOL_TRUE;
>  	}
> diff --git a/common/drive.c b/common/drive.c
> index 32a7191..f9ba851 100644
> --- a/common/drive.c
> +++ b/common/drive.c
> @@ -21,6 +21,7 @@
>  
>  #include <sys/stat.h>
>  #include <time.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -88,7 +89,7 @@ drive_init1( int argc, char *argv[ ] )
>  
>  	/* sanity check asserts
>  	 */
> -	ASSERT( sizeof( drive_hdr_t ) == DRIVE_HDR_SZ );
> +	assert( sizeof( drive_hdr_t ) == DRIVE_HDR_SZ );
>  
>  	/* count drive arguments
>  	 */
> @@ -107,7 +108,7 @@ drive_init1( int argc, char *argv[ ] )
>  	 */
>  	if (drivecnt > 0) {
>  		drivepp = ( drive_t ** )calloc( drivecnt, sizeof( drive_t * ));
> -		ASSERT( drivepp );
> +		assert( drivepp );
>  	}
>  
>  	/* initialize the partialmax value.  Each drive can be completing a file
> @@ -142,7 +143,7 @@ drive_init1( int argc, char *argv[ ] )
>  			break;
>  		}
>  	}
> -	ASSERT( driveix == drivecnt );
> +	assert( driveix == drivecnt );
>  
>  	/* the user may specify stdin as the source, by
>  	 * a single dash ('-') with no option letter. This must appear
> @@ -169,7 +170,7 @@ drive_init1( int argc, char *argv[ ] )
>  		 * allocate an array to hold ptrs to drive descriptors
>  		 */
>  		drivepp = ( drive_t ** )calloc( drivecnt, sizeof( drive_t * ));
> -		ASSERT( drivepp );
> +		assert( drivepp );
>  
>  		drivepp[ 0 ] = drive_alloc( "stdio", 0 );
>  
> @@ -215,7 +216,7 @@ drive_init1( int argc, char *argv[ ] )
>  				bestscore = score;
>  			}
>  		}
> -		ASSERT( bestsp );
> +		assert( bestsp );
>  		drivep->d_strategyp = bestsp;
>  		drivep->d_recmarksep = bestsp->ds_recmarksep;
>  		drivep->d_recmfilesz = bestsp->ds_recmfilesz;
> @@ -356,7 +357,7 @@ drive_alloc( char *pathname, ix_t driveix )
>  	/* allocate the descriptor
>  	 */
>  	drivep = ( drive_t * )calloc( 1, sizeof( drive_t ));
> -	ASSERT( drivep );
> +	assert( drivep );
>  
>  	/* convert the pathname to an absolute pathname
>  	 * NOTE: string "stdio" is reserved to mean send to standard out
> @@ -397,7 +398,7 @@ drive_allochdrs( drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix )
>  	/* allocate the read header
>  	 */
>  	grhdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
> -	ASSERT( grhdrp );
> +	assert( grhdrp );
>  	gwhdrp = NULL;
>  	dwhdrp = NULL;
>  
> @@ -411,7 +412,7 @@ drive_allochdrs( drive_t *drivep, global_hdr_t *gwhdrtemplatep, ix_t driveix )
>  		/* allocate the write header
>  		 */
>  		gwhdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
> -		ASSERT( gwhdrp );
> +		assert( gwhdrp );
>  
>  		/* copy the template
>  		 */
> diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
> index 8c57699..6d58f1f 100644
> --- a/common/drive_minrmt.c
> +++ b/common/drive_minrmt.c
> @@ -29,6 +29,7 @@
>  #include <sys/sysmacros.h>
>  #include <malloc.h>
>  #include <sched.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -471,11 +472,11 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  
>  	/* opportunity for sanity checking
>  	 */
> -	ASSERT( sizeof( global_hdr_t ) <= STAPE_HDR_SZ );
> -	ASSERT( sizeof( rec_hdr_t )
> +	assert( sizeof( global_hdr_t ) <= STAPE_HDR_SZ );
> +	assert( sizeof( rec_hdr_t )
>  		==
>  		sizeofmember( drive_hdr_t, dh_specific ));
> -	ASSERT( ! ( STAPE_MAX_RECSZ % PGSZ ));
> +	assert( ! ( STAPE_MAX_RECSZ % PGSZ ));
>  
>  	/* hook up the drive ops
>  	 */
> @@ -484,7 +485,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  	/* allocate context for the drive manager
>  	 */
>  	contextp = ( drive_context_t * )calloc( 1, sizeof( drive_context_t ));
> -	ASSERT( contextp );
> +	assert( contextp );
>  	memset( ( void * )contextp, 0, sizeof( *contextp ));
>  
>  	/* do not enable a separate I/O thread,
> @@ -583,7 +584,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  	 */
>  	if ( contextp->dc_singlethreadedpr ) {
>  		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
> -		ASSERT( contextp->dc_bufp );
> +		assert( contextp->dc_bufp );
>  	} else {
>  		intgen_t rval;
>  		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
> @@ -611,7 +612,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  				      _("not allowed "
>  				      "to pin down I/O buffer ring\n") );
>  			} else {
> -				ASSERT( 0 );
> +				assert( 0 );
>  			}
>  			return BOOL_FALSE;
>  		}
> @@ -721,18 +722,18 @@ do_begin_read( drive_t *drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( drivep->d_capabilities & DRIVE_CAP_READ );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( ! contextp->dc_recp );
> +	assert( drivep->d_capabilities & DRIVE_CAP_READ );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( ! contextp->dc_recp );
>  
>  	/* get a record buffer to use during initialization.
>  	 */
>  	if ( contextp->dc_singlethreadedpr ) {
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
> -		ASSERT( contextp->dc_ringp );
> +		assert( contextp->dc_ringp );
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  
> @@ -742,7 +743,7 @@ do_begin_read( drive_t *drivep )
>  	 */
>  	contextp->dc_iocnt = 0;
>  	if ( contextp->dc_fd < 0 ) {
> -		ASSERT( contextp->dc_fd == -1 );
> +		assert( contextp->dc_fd == -1 );
>  		rval = prepare_drive( drivep );
>  		if ( rval ) {
>  			if ( ! contextp->dc_singlethreadedpr ) {
> @@ -763,7 +764,7 @@ do_begin_read( drive_t *drivep )
>  			return rval;
>  		}
>  	}
> -	ASSERT( contextp->dc_iocnt == 1 );
> +	assert( contextp->dc_iocnt == 1 );
>  					/* set by prepare_drive or read_label */
>  
>  	/* all is well. adjust context. don't kick off read-aheads just yet;
> @@ -824,10 +825,10 @@ do_read( drive_t *drivep,
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( wantedcnt > 0 );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( wantedcnt > 0 );
>  
>  	/* clear the return status field
>  	 */
> @@ -853,7 +854,7 @@ do_read( drive_t *drivep,
>  	 */
>  	contextp->dc_ownedp = contextp->dc_nextp;
>  	contextp->dc_nextp += actualcnt;
> -	ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> +	assert( contextp->dc_nextp <= contextp->dc_dataendp );
>  
>  	mlog( MLOG_NITTY | MLOG_DRIVE,
>  	      "rmt drive op read actual == %d (0x%x)\n",
> @@ -886,16 +887,16 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( contextp->dc_ownedp );
> -	ASSERT( bufp == contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( contextp->dc_ownedp );
> +	assert( bufp == contextp->dc_ownedp );
>  
>  	/* calculate how much the caller owns
>  	 */
> -	ASSERT( contextp->dc_nextp >= contextp->dc_ownedp );
> +	assert( contextp->dc_nextp >= contextp->dc_ownedp );
>  	ownedcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
> -	ASSERT( ownedcnt == retcnt );
> +	assert( ownedcnt == retcnt );
>  
>  	/* take possession of buffer portion
>  	 */
> @@ -905,7 +906,7 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
>  	 * and (if ring in use) give buffer to ring for read-ahead.
>  	 */
>  	if ( contextp->dc_nextp >= contextp->dc_dataendp ) {
> -		ASSERT( contextp->dc_nextp == contextp->dc_dataendp );
> +		assert( contextp->dc_nextp == contextp->dc_dataendp );
>  		if ( ! contextp->dc_singlethreadedpr ) {
>  			contextp->dc_msgp->rm_op = RING_OP_READ;
>  			Ring_put( contextp->dc_ringp, contextp->dc_msgp );
> @@ -936,9 +937,9 @@ do_get_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  	/* the mark is simply the offset into the media file of the
>  	 * next byte to be read.
> @@ -977,9 +978,9 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  
>  	/* the desired mark is passed by reference, and is really just an
> @@ -1002,18 +1003,18 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  #endif
>  
> -		ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +		assert( contextp->dc_nextp >= contextp->dc_recp );
>  		recoff = ( u_int32_t )( contextp->dc_nextp
>  					-
>  					contextp->dc_recp );
> -		ASSERT( recoff <= tape_recsz );
> -		ASSERT( rechdrp->rec_used <= tape_recsz );
> -		ASSERT( recoff >= STAPE_HDR_SZ );
> -		ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -		ASSERT( recoff <= rechdrp->rec_used );
> +		assert( recoff <= tape_recsz );
> +		assert( rechdrp->rec_used <= tape_recsz );
> +		assert( recoff >= STAPE_HDR_SZ );
> +		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +		assert( recoff <= rechdrp->rec_used );
>  		currentoffset += ( off64_t )recoff;
>  	}
> -	ASSERT( wantedoffset >= currentoffset );
> +	assert( wantedoffset >= currentoffset );
>  	
>  	/* if we are currently holding a record and the desired offset
>  	 * is not within the current record, eat the current record.
> @@ -1036,12 +1037,12 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			 * must be just after it.
>  			 */
>  			if ( rechdrp->rec_used < tape_recsz ) {
> -				ASSERT( wantedoffset == nextrecoffset );
> +				assert( wantedoffset == nextrecoffset );
>  			}
>  
>  			/* figure how much to ask for
>  			 */
> -			ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +			assert( contextp->dc_nextp >= contextp->dc_recp );
>  			recoff = ( u_int32_t )( contextp->dc_nextp
>  						-
>  						contextp->dc_recp );
> @@ -1059,13 +1060,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			if ( rval ) {
>  				return rval;
>  			}
> -			ASSERT( actualcnt == wantedcnt );
> +			assert( actualcnt == wantedcnt );
>  			do_return_read_buf( drivep, dummybufp, actualcnt );
>  			currentoffset += ( off64_t )actualcnt;
> -			ASSERT( currentoffset == nextrecoffset );
> -			ASSERT( wantedoffset >= currentoffset );
> -			ASSERT( ! contextp->dc_recp );
> -			ASSERT( currentoffset
> +			assert( currentoffset == nextrecoffset );
> +			assert( wantedoffset >= currentoffset );
> +			assert( ! contextp->dc_recp );
> +			assert( currentoffset
>  				==
>  				contextp->dc_reccnt * ( off64_t )tape_recsz );
>  		}
> @@ -1084,14 +1085,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		off64_t wantedreccnt;
>  		seekmode_t seekmode;
>  		
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  		wantedreccnt = wantedoffset / ( off64_t )tape_recsz;
>  		if ( contextp->dc_singlethreadedpr ) {
>  			seekmode = SEEKMODE_RAW;
>  		} else {
>  			seekmode = SEEKMODE_BUF;
>  		}
> -		ASSERT( wantedreccnt != 0 ); /* so NOP below can be
> +		assert( wantedreccnt != 0 ); /* so NOP below can be
>  					      * distinguished from use
>  					      * in do_begin_read
>  					      */
> @@ -1101,7 +1102,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  			if ( seekmode == SEEKMODE_BUF ) {
>  				ring_stat_t rs;
> -				ASSERT( ! contextp->dc_msgp );
> +				assert( ! contextp->dc_msgp );
>  				contextp->dc_msgp =
>  						Ring_get( contextp->dc_ringp );
>  				rs = contextp->dc_msgp->rm_stat;
> @@ -1114,7 +1115,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				     rs != RING_STAT_INIT
>  				     &&
>  				     rs != RING_STAT_NOPACK ) {
> -					ASSERT( 0 );
> +					assert( 0 );
>  					contextp->dc_errorpr = BOOL_TRUE;
>  					return DRIVE_ERROR_CORE;
>  				}
> @@ -1136,8 +1137,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				continue;
>  			}
>  
> -			ASSERT( contextp->dc_reccnt == contextp->dc_iocnt );
> -			ASSERT( wantedreccnt > contextp->dc_reccnt );
> +			assert( contextp->dc_reccnt == contextp->dc_iocnt );
> +			assert( wantedreccnt > contextp->dc_reccnt );
>  			recskipcnt64 = wantedreccnt - contextp->dc_reccnt;
>  			recskipcnt64remaining = recskipcnt64;
>  			while ( recskipcnt64remaining ) {
> @@ -1145,14 +1146,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				intgen_t saved_errno;
>  				intgen_t rval;
>  
> -				ASSERT( recskipcnt64remaining > 0 );
> +				assert( recskipcnt64remaining > 0 );
>  				if ( recskipcnt64remaining > INTGENMAX ) {
>  					recskipcnt = INTGENMAX;
>  				} else {
>  					recskipcnt = ( intgen_t )
>  						     recskipcnt64remaining;
>  				}
> -				ASSERT( recskipcnt > 0 );
> +				assert( recskipcnt > 0 );
>  				rval = mt_op( contextp->dc_fd,
>  					      MTFSR,
>  					      recskipcnt );
> @@ -1174,8 +1175,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			currentoffset = contextp->dc_reccnt
>  					*
>  					( off64_t )tape_recsz;
> -			ASSERT( wantedoffset >= currentoffset );
> -			ASSERT( wantedoffset - currentoffset
> +			assert( wantedoffset >= currentoffset );
> +			assert( wantedoffset - currentoffset
>  				<
>  				( off64_t )tape_recsz );
>  		}
> @@ -1190,7 +1191,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		size_t actualcnt;
>  		intgen_t rval;
>  
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  
>  		/* figure how much to ask for. to eat an entire record,
>  		 * ask for a record sans the header. do_read will eat
> @@ -1205,11 +1206,11 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		if ( rval ) {
>  			return rval;
>  		}
> -		ASSERT( actualcnt == wantedcnt );
> +		assert( actualcnt == wantedcnt );
>  		do_return_read_buf( drivep, dummybufp, actualcnt );
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  		currentoffset += ( off64_t )tape_recsz;
> -		ASSERT( currentoffset
> +		assert( currentoffset
>  			==
>  			contextp->dc_reccnt * ( off64_t )tape_recsz );
>  	}
> @@ -1222,8 +1223,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		char *dummybufp;
>  		size_t actualcnt;
>  
> -		ASSERT( wantedoffset > currentoffset );
> -		ASSERT( wantedoffset - currentoffset < ( off64_t )tape_recsz );
> +		assert( wantedoffset > currentoffset );
> +		assert( wantedoffset - currentoffset < ( off64_t )tape_recsz );
>  		wantedcnt = ( size_t )( wantedoffset - currentoffset );
>  		if ( contextp->dc_recp ) {
>  			u_int32_t recoff;
> @@ -1233,14 +1234,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			recoff = ( u_int32_t )( contextp->dc_nextp
>  						-
>  						contextp->dc_recp );
> -			ASSERT( recoff <= tape_recsz );
> -			ASSERT( rechdrp->rec_used <= tape_recsz );
> -			ASSERT( recoff >= STAPE_HDR_SZ );
> -			ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -			ASSERT( recoff <= rechdrp->rec_used );
> -			ASSERT( recoff + wantedcnt <= rechdrp->rec_used );
> +			assert( recoff <= tape_recsz );
> +			assert( rechdrp->rec_used <= tape_recsz );
> +			assert( recoff >= STAPE_HDR_SZ );
> +			assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +			assert( recoff <= rechdrp->rec_used );
> +			assert( recoff + wantedcnt <= rechdrp->rec_used );
>  		} else {
> -			ASSERT( wantedcnt >= STAPE_HDR_SZ );
> +			assert( wantedcnt >= STAPE_HDR_SZ );
>  			wantedcnt -= STAPE_HDR_SZ;
>  		}
>  
> @@ -1253,7 +1254,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		    if ( rval ) {
>  			    return rval;
>  		    }
> -		    ASSERT( actualcnt == wantedcnt );
> +		    assert( actualcnt == wantedcnt );
>  		    do_return_read_buf( drivep, dummybufp, actualcnt );
>  		}
>  	}
> @@ -1268,18 +1269,18 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  #endif
>  
> -		ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +		assert( contextp->dc_nextp >= contextp->dc_recp );
>  		recoff = ( u_int32_t )( contextp->dc_nextp
>  					-
>  					contextp->dc_recp );
> -		ASSERT( recoff <= tape_recsz );
> -		ASSERT( rechdrp->rec_used <= tape_recsz );
> -		ASSERT( recoff >= STAPE_HDR_SZ );
> -		ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -		ASSERT( recoff <= rechdrp->rec_used );
> +		assert( recoff <= tape_recsz );
> +		assert( rechdrp->rec_used <= tape_recsz );
> +		assert( recoff >= STAPE_HDR_SZ );
> +		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +		assert( recoff <= rechdrp->rec_used );
>  		currentoffset += ( off64_t )recoff;
>  	}
> -	ASSERT( wantedoffset == currentoffset );
> +	assert( wantedoffset == currentoffset );
>  
>  	return 0;
>  }
> @@ -1310,9 +1311,9 @@ do_next_mark( drive_t *drivep )
>  
>  	/* assert protocol being followed.
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "rmt drive op: next mark\n" );
> @@ -1335,7 +1336,7 @@ noerrorsearch:
>  		}
>  		rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  
> -		ASSERT( rechdrp->first_mark_offset != 0 );
> +		assert( rechdrp->first_mark_offset != 0 );
>  		if ( rechdrp->first_mark_offset > 0 ) {
>  			 off64_t markoff = rechdrp->first_mark_offset
>  					   -
> @@ -1343,8 +1344,8 @@ noerrorsearch:
>  			 off64_t curoff = ( off64_t )( contextp->dc_nextp
>  						       -
>  						       contextp->dc_recp );
> -			 ASSERT( markoff > 0 );
> -			 ASSERT( curoff > 0 );
> +			 assert( markoff > 0 );
> +			 assert( curoff > 0 );
>  			 if ( markoff >= curoff ) {
>  				break;
>  			}
> @@ -1359,7 +1360,7 @@ noerrorsearch:
>  		contextp->dc_reccnt++;
>  	}
>  
> -	ASSERT( rechdrp->first_mark_offset - rechdrp->file_offset
> +	assert( rechdrp->first_mark_offset - rechdrp->file_offset
>  		<=
>  		( off64_t )tape_recsz );
>  	contextp->dc_nextp = contextp->dc_recp
> @@ -1367,8 +1368,8 @@ noerrorsearch:
>  			     ( size_t )( rechdrp->first_mark_offset
>  					 -
>  					 rechdrp->file_offset );
> -	ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> -	ASSERT( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> +	assert( contextp->dc_nextp <= contextp->dc_dataendp );
> +	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
>  	if ( contextp->dc_nextp == contextp->dc_dataendp ) {
>  		if ( ! contextp->dc_singlethreadedpr ) {
>  			Ring_put( contextp->dc_ringp,
> @@ -1394,7 +1395,7 @@ resetring:
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
> @@ -1417,7 +1418,7 @@ validateread:
>  	}
>  
>  	if ( nread >= 0 ) {
> -		ASSERT( ( size_t )nread <= tape_recsz );
> +		assert( ( size_t )nread <= tape_recsz );
>  		mlog( MLOG_DEBUG | MLOG_DRIVE,
>  		      "short read (nread == %d, record size == %d)\n",
>  		      nread,
> @@ -1460,24 +1461,24 @@ validatehdr:
>  		goto readrecord;
>  	}
>  
> -	ASSERT( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
> +	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
>  	markoff = rechdrp->first_mark_offset - rechdrp->file_offset;
> -	ASSERT( markoff >= ( off64_t )STAPE_HDR_SZ );
> -	ASSERT( markoff < ( off64_t )tape_recsz );
> -	ASSERT( rechdrp->rec_used > STAPE_HDR_SZ );
> -	ASSERT( rechdrp->rec_used < tape_recsz );
> +	assert( markoff >= ( off64_t )STAPE_HDR_SZ );
> +	assert( markoff < ( off64_t )tape_recsz );
> +	assert( rechdrp->rec_used > STAPE_HDR_SZ );
> +	assert( rechdrp->rec_used < tape_recsz );
>  
>  	goto alliswell;
>  
>  alliswell:
>  	contextp->dc_nextp = contextp->dc_recp + ( size_t )markoff;
> -	ASSERT( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
> +	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
>  	contextp->dc_reccnt = rechdrp->file_offset / ( off64_t )tape_recsz;
>  	contextp->dc_iocnt = contextp->dc_reccnt + 1;
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_dataendp = contextp->dc_recp + rechdrp->rec_used;
> -	ASSERT( contextp->dc_dataendp <= contextp->dc_recendp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_dataendp );
> +	assert( contextp->dc_dataendp <= contextp->dc_recendp );
> +	assert( contextp->dc_nextp < contextp->dc_dataendp );
>  	contextp->dc_errorpr = BOOL_FALSE;
>  
>  	mlog( MLOG_NORMAL | MLOG_DRIVE,
> @@ -1553,8 +1554,8 @@ do_end_read( drive_t *drivep )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
>  
>  	/* In the scsi version, read_label() does a status command to the
>  	 * drive to then decide if doing a 'fsf' is appropriate.  For minrmt,
> @@ -1608,9 +1609,9 @@ do_begin_write( drive_t *drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( ! drivep->d_markrecheadp );
> -	ASSERT( ! contextp->dc_recp );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( ! drivep->d_markrecheadp );
> +	assert( ! contextp->dc_recp );
>  
>  	/* get pointers into global write header
>  	 */
> @@ -1621,7 +1622,7 @@ do_begin_write( drive_t *drivep )
>  	/* must already be open. The only way to open is to do a begin_read.
>  	 * so all interaction with tape requires reading first.
>  	 */
> -	ASSERT( contextp->dc_fd != -1 );
> +	assert( contextp->dc_fd != -1 );
>  
>  	/* fill in write header's drive specific info
>  	 */
> @@ -1637,15 +1638,15 @@ do_begin_write( drive_t *drivep )
>  	/* get a record buffer. will be used for the media file header,
>  	 * and is needed to "prime the pump" for first call to do_write.
>  	 */
> -	ASSERT( ! contextp->dc_recp );
> +	assert( ! contextp->dc_recp );
>  	if ( contextp->dc_singlethreadedpr ) {
> -		ASSERT( contextp->dc_bufp );
> +		assert( contextp->dc_bufp );
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
> -		ASSERT( contextp->dc_ringp );
> -		ASSERT( ! contextp->dc_msgp );
> +		assert( contextp->dc_ringp );
> +		assert( ! contextp->dc_msgp );
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  
> @@ -1690,7 +1691,7 @@ do_begin_write( drive_t *drivep )
>  	/* prepare the drive context. must have a record buffer ready to
>  	 * go, header initialized.
>  	 */
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( ! contextp->dc_ownedp );
>  	contextp->dc_reccnt = 1; /* count the header record */
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
> @@ -1735,15 +1736,15 @@ do_set_mark( drive_t *drivep,
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
>  
>  	/* calculate and fill in the mark record offset
>  	 */
> -	ASSERT( contextp->dc_recp );
> +	assert( contextp->dc_recp );
>  	nextoff = contextp->dc_reccnt * ( off64_t )tape_recsz
>  		  +
>  		  ( off64_t )( contextp->dc_nextp - contextp->dc_recp );
> @@ -1758,7 +1759,7 @@ do_set_mark( drive_t *drivep,
>  	 */
>  	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  	if ( rechdrp->first_mark_offset == -1LL ) {
> -		ASSERT( nextoff != -1LL );
> +		assert( nextoff != -1LL );
>  		rechdrp->first_mark_offset = nextoff;
>  	}
>  
> @@ -1771,7 +1772,7 @@ do_set_mark( drive_t *drivep,
>  		drivep->d_markrecheadp = markrecp;
>  		drivep->d_markrectailp = markrecp;
>  	} else {
> -		ASSERT( drivep->d_markrectailp );
> +		assert( drivep->d_markrectailp );
>  		drivep->d_markrectailp->dm_nextp = markrecp;
>  		drivep->d_markrectailp = markrecp;
>  	}
> @@ -1798,12 +1799,12 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* figure how much is available; supply the min of what is
>  	 * available and what is wanted.
> @@ -1864,17 +1865,17 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp <= contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp <= contextp->dc_recendp );
>  
>  	/* verify the caller is returning exactly what is held
>  	 */
> -	ASSERT( bufp == contextp->dc_ownedp );
> -	ASSERT( retcnt == heldcnt );
> +	assert( bufp == contextp->dc_ownedp );
> +	assert( retcnt == heldcnt );
>  
>  	/* take it back
>  	 */
> @@ -1915,7 +1916,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
>  			rval = contextp->dc_msgp->rm_rval;
>  			break;
>  		default:
> -			ASSERT( 0 );
> +			assert( 0 );
>  			return DRIVE_ERROR_CORE;
>  		}
>  	}
> @@ -1979,12 +1980,12 @@ do_get_align_cnt( drive_t * drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* calculate the next alignment point at or beyond the current nextp.
>  	 * the following algorithm works because all buffers are page-aligned
> @@ -1994,11 +1995,11 @@ do_get_align_cnt( drive_t * drivep )
>  	next_alignment_off +=  PGMASK;
>  	next_alignment_off &= ~PGMASK;
>  	next_alignment_point = ( char * )next_alignment_off;
> -	ASSERT( next_alignment_point <= contextp->dc_recendp );
> +	assert( next_alignment_point <= contextp->dc_recendp );
>  
>  	/* return the number of bytes to the next alignment offset
>  	 */
> -	ASSERT( next_alignment_point >= contextp->dc_nextp );
> +	assert( next_alignment_point >= contextp->dc_nextp );
>  	return ( size_t )( next_alignment_point - contextp->dc_nextp );
>  }
>  
> @@ -2025,12 +2026,12 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* pre-initialize return of count of bytes committed to media
>  	 */
> @@ -2072,7 +2073,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  					     contextp->dc_recp,
>  					     BOOL_TRUE, BOOL_TRUE );
>  		} else {
> -			ASSERT( contextp->dc_msgp );
> +			assert( contextp->dc_msgp );
>  			contextp->dc_msgp->rm_op = RING_OP_WRITE;
>  			contextp->dc_msgp->rm_user = contextp->dc_reccnt;
>  			Ring_put( contextp->dc_ringp,
> @@ -2088,7 +2089,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  				rval = contextp->dc_msgp->rm_rval;
>  				break;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_recp = 0;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -2115,7 +2116,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  	}
>  	if ( ! contextp->dc_singlethreadedpr ) {
>  		while ( ! rval ) {
> -			ASSERT( contextp->dc_msgp );
> +			assert( contextp->dc_msgp );
>  			contextp->dc_msgp->rm_op = RING_OP_TRACE;
>  			Ring_put( contextp->dc_ringp,
>  				  contextp->dc_msgp );
> @@ -2127,14 +2128,14 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  			switch( contextp->dc_msgp->rm_stat ) {
>  			case RING_STAT_OK:
>  			case RING_STAT_INIT:
> -				ASSERT( rval == 0 );
> +				assert( rval == 0 );
>  				break;
>  			case RING_STAT_ERROR:
>  				rval = contextp->dc_msgp->rm_rval;
>  				first_rec_w_err = contextp->dc_msgp->rm_user;
>  				break;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_recp = 0;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -2182,11 +2183,11 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  	 * to tape.
>  	 */
>  	if ( rval ) {
> -		ASSERT( first_rec_w_err >= 0 );
> +		assert( first_rec_w_err >= 0 );
>  		recs_wtn_wo_err = first_rec_w_err;
>  		recs_guaranteed = recs_wtn_wo_err - contextp->dc_lostrecmax;
>  	} else {
> -		ASSERT( first_rec_w_err == -1 );
> +		assert( first_rec_w_err == -1 );
>  		recs_wtn_wo_err = contextp->dc_iocnt;
>  		recs_guaranteed = recs_wtn_wo_err;
>  	}
> @@ -2217,14 +2218,14 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "rmt drive op: fsf: count %d\n",
>  	      count );
>  
> -	ASSERT( count );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( count );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	for ( i = 0 ; i < count; i++ ) {
>  		done = 0;
> @@ -2243,7 +2244,7 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  			      _("advancing tape to next media file\n") );
>  
>  			op_failed = 0;
> -			ASSERT( contextp->dc_fd >= 0 );
> +			assert( contextp->dc_fd >= 0 );
>  			if ( mt_op( contextp->dc_fd, MTFSF, 1 ) ) {
>  				op_failed = 1;
>  			}
> @@ -2294,14 +2295,14 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  	      "rmt drive op: bsf: count %d\n",
>  	      count );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	*statp = 0;
>  
>  	/* back space - places us to left of previous file mark
>  	 * if we hit BOT, return
>  	 */
> -	ASSERT( drivep->d_capabilities & DRIVE_CAP_BSF );
> +	assert( drivep->d_capabilities & DRIVE_CAP_BSF );
>  	rval = bsf_and_verify( drivep );
>  	if (rval) {
>  		if (errno == ENOSPC/*IRIX*/ || errno == EIO/*Linux*/) {
> @@ -2379,8 +2380,8 @@ do_rewind( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "rmt drive op: rewind\n" );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* use validating tape rewind util func
>  	 */
> @@ -2405,8 +2406,8 @@ do_erase( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "rmt drive op: erase\n" );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* use validating tape rewind util func
>  	 */
> @@ -2443,8 +2444,8 @@ do_eject_media( drive_t *drivep )
>  
>  	/* drive must be open
>  	 */
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	/* issue tape unload
>  	 */
> @@ -2563,7 +2564,7 @@ read_label( drive_t *drivep )
>  	/* if a read error, get status
>  	 */
>  	if ( nread != ( intgen_t )tape_recsz ) {
> -		ASSERT( nread < ( intgen_t )tape_recsz );
> +		assert( nread < ( intgen_t )tape_recsz );
>  	} 
>  
>  	/* check for an unexpected errno
> @@ -2720,7 +2721,7 @@ get_tpcaps( drive_t *drivep )
>  #ifdef DEBUG
>  	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  #endif
>  
>  	/* can't ask about blksz, can't set blksz, can't ask about
> @@ -2796,7 +2797,7 @@ mt_op(intgen_t fd, intgen_t sub_op, intgen_t param )
>  	mop.mt_op   	= (short )sub_op;
>  	mop.mt_count	= param;
>  
> -	ASSERT( fd >= 0 );
> +	assert( fd >= 0 );
>  
>  	switch ( sub_op ) {
>  	case MTSEEK:
> @@ -3074,7 +3075,7 @@ prepare_drive( drive_t *drivep )
>  
>  	/* shouldn't be here if drive is open
>  	 */
> -	ASSERT( contextp->dc_fd == -1 );
> +	assert( contextp->dc_fd == -1 );
>  
>  	mlog( MLOG_VERBOSE | MLOG_DRIVE,
>  	      _("preparing drive\n") );
> @@ -3181,7 +3182,7 @@ prepare_drive( drive_t *drivep )
>  			      contextp->dc_recp,
>  			      tape_recsz,
>  			      &saved_errno );
> -		ASSERT( saved_errno == 0 || nread < 0 );
> +		assert( saved_errno == 0 || nread < 0 );
>  
>  		/* RMT can require a retry
>  		 */
> @@ -3340,7 +3341,7 @@ checkhdr:
>  			rec_hdr_t *tprhdrp;
>  			drhdrp = drivep->d_readhdrp;
>  			tprhdrp = ( rec_hdr_t * )drhdrp->dh_specific;
> -			ASSERT( tprhdrp->recsize >= 0 );
> +			assert( tprhdrp->recsize >= 0 );
>  			tape_recsz = ( size_t )tprhdrp->recsize;
>  			break;
>  		}
> @@ -3410,7 +3411,7 @@ Open( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: opening drive\n" );
>  
> -	ASSERT( contextp->dc_fd == -1 );
> +	assert( contextp->dc_fd == -1 );
>  
>  	errno = 0;
>  	contextp->dc_fd = open( drivep->d_pathname, oflags );
> @@ -3430,7 +3431,7 @@ Close( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: closing drive\n" );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	( void )close( contextp->dc_fd );
>  
> @@ -3447,8 +3448,8 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
>  	      "tape op: reading %u bytes\n",
>  	      cnt );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( bufp );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( bufp );
>  	*errnop = 0;
>  	errno = 0;
>  	nread = read( contextp->dc_fd, ( void * )bufp, cnt );
> @@ -3483,8 +3484,8 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
>  	      "tape op: writing %u bytes\n",
>  	      cnt );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( bufp );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( bufp );
>  	*errnop = 0;
>  	errno = 0;
>  	nwritten = write( contextp->dc_fd, ( void * )bufp, cnt );
> @@ -3664,7 +3665,7 @@ read_record(  drive_t *drivep, char *bufp )
>  	/* short read
>  	 */
>  	if ( nread >= 0 ) {
> -		ASSERT( nread <= ( intgen_t )tape_recsz );
> +		assert( nread <= ( intgen_t )tape_recsz );
>  		mlog( MLOG_DEBUG | MLOG_DRIVE,
>  		      "short read record %lld (nread == %d)\n",
>  		      contextp->dc_iocnt,
> @@ -3726,7 +3727,7 @@ getrec( drive_t *drivep )
>  				contextp->dc_errorpr = BOOL_TRUE;
>  				return contextp->dc_msgp->rm_rval;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_errorpr = BOOL_TRUE;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -3739,7 +3740,7 @@ getrec( drive_t *drivep )
>  		contextp->dc_nextp = contextp->dc_recp
>  				     +
>  				     STAPE_HDR_SZ;
> -		ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> +		assert( contextp->dc_nextp <= contextp->dc_dataendp );
>  	}
>  
>  	return 0;
> @@ -3775,7 +3776,7 @@ write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
>  	}
>  
>  	rval = determine_write_error( nwritten, saved_errno );
> -	ASSERT(rval);
> +	assert(rval);
>  
>  	return rval;
>  }
> @@ -3814,7 +3815,7 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
>  	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
>  	      "ring op: reset\n" );
>  	
> -	ASSERT( ringp );
> +	assert( ringp );
>  
>  	ring_reset( ringp, msgp );
>  }
> @@ -3845,14 +3846,14 @@ display_ring_metrics( drive_t *drivep, intgen_t mlog_flags )
>  	char *bufszsfxp;
>  	
>  	if ( tape_recsz == STAPE_MIN_MAX_BLKSZ ) {
> -		ASSERT( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
> +		assert( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
>  		sprintf( bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400 );
> -		ASSERT( strlen( bufszbuf ) < sizeof( bufszbuf ));
> +		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
>  		bufszsfxp = _("KB");
>  	} else if ( tape_recsz == STAPE_MAX_RECSZ ) {
> -		ASSERT( ! ( STAPE_MAX_RECSZ % 0x100000 ));
> +		assert( ! ( STAPE_MAX_RECSZ % 0x100000 ));
>  		sprintf( bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000 );
> -		ASSERT( strlen( bufszbuf ) < sizeof( bufszbuf ));
> +		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
>  		bufszsfxp = _("MB");
>  	} else {
>  		sprintf( bufszbuf, "%u", (unsigned int)(tape_recsz / 0x400) );
> diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
> index 0abb5d0..3f45d01 100644
> --- a/common/drive_scsitape.c
> +++ b/common/drive_scsitape.c
> @@ -29,6 +29,7 @@
>  #include <sys/sysmacros.h>
>  #include <malloc.h>
>  #include <sched.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -551,11 +552,11 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  
>  	/* opportunity for sanity checking
>  	 */
> -	ASSERT( sizeof( global_hdr_t ) <= STAPE_HDR_SZ );
> -	ASSERT( sizeof( rec_hdr_t )
> +	assert( sizeof( global_hdr_t ) <= STAPE_HDR_SZ );
> +	assert( sizeof( rec_hdr_t )
>  		==
>  		sizeofmember( drive_hdr_t, dh_specific ));
> -	ASSERT( ! ( STAPE_MAX_RECSZ % PGSZ ));
> +	assert( ! ( STAPE_MAX_RECSZ % PGSZ ));
>  
>  	/* hook up the drive ops
>  	 */
> @@ -564,7 +565,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  	/* allocate context for the drive manager
>  	 */
>  	contextp = ( drive_context_t * )calloc( 1, sizeof( drive_context_t ));
> -	ASSERT( contextp );
> +	assert( contextp );
>  	memset( ( void * )contextp, 0, sizeof( *contextp ));
>  
>  	/* do not enable a separate I/O thread,
> @@ -673,7 +674,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  	 */
>  	if ( contextp->dc_singlethreadedpr ) {
>  		contextp->dc_bufp = ( char * )memalign( PGSZ, STAPE_MAX_RECSZ );
> -		ASSERT( contextp->dc_bufp );
> +		assert( contextp->dc_bufp );
>  	} else {
>  		intgen_t rval;
>  		mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
> @@ -701,7 +702,7 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  				      _("not allowed "
>  				      "to pin down I/O buffer ring\n") );
>  			} else {
> -				ASSERT( 0 );
> +				assert( 0 );
>  			}
>  			return BOOL_FALSE;
>  		}
> @@ -834,18 +835,18 @@ do_begin_read( drive_t *drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( drivep->d_capabilities & DRIVE_CAP_READ );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( ! contextp->dc_recp );
> +	assert( drivep->d_capabilities & DRIVE_CAP_READ );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( ! contextp->dc_recp );
>  
>  	/* get a record buffer to use during initialization.
>  	 */
>  	if ( contextp->dc_singlethreadedpr ) {
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
> -		ASSERT( contextp->dc_ringp );
> +		assert( contextp->dc_ringp );
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  
> @@ -855,7 +856,7 @@ do_begin_read( drive_t *drivep )
>  	 */
>  	contextp->dc_iocnt = 0;
>  	if ( contextp->dc_fd < 0 ) {
> -		ASSERT( contextp->dc_fd == -1 );
> +		assert( contextp->dc_fd == -1 );
>  		rval = prepare_drive( drivep );
>  		if ( rval ) {
>  			if ( ! contextp->dc_singlethreadedpr ) {
> @@ -876,7 +877,7 @@ do_begin_read( drive_t *drivep )
>  			return rval;
>  		}
>  	}
> -	ASSERT( contextp->dc_iocnt == 1 );
> +	assert( contextp->dc_iocnt == 1 );
>  					/* set by prepare_drive or read_label */
>  
>  	/* all is well. adjust context. don't kick off read-aheads just yet;
> @@ -937,10 +938,10 @@ do_read( drive_t *drivep,
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( wantedcnt > 0 );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( wantedcnt > 0 );
>  
>  	/* clear the return status field
>  	 */
> @@ -966,7 +967,7 @@ do_read( drive_t *drivep,
>  	 */
>  	contextp->dc_ownedp = contextp->dc_nextp;
>  	contextp->dc_nextp += actualcnt;
> -	ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> +	assert( contextp->dc_nextp <= contextp->dc_dataendp );
>  
>  	mlog( MLOG_NITTY | MLOG_DRIVE,
>  	      "drive op read actual == %d (0x%x)\n",
> @@ -999,16 +1000,16 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( contextp->dc_ownedp );
> -	ASSERT( bufp == contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( contextp->dc_ownedp );
> +	assert( bufp == contextp->dc_ownedp );
>  
>  	/* calculate how much the caller owns
>  	 */
> -	ASSERT( contextp->dc_nextp >= contextp->dc_ownedp );
> +	assert( contextp->dc_nextp >= contextp->dc_ownedp );
>  	ownedcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
> -	ASSERT( ownedcnt == retcnt );
> +	assert( ownedcnt == retcnt );
>  
>  	/* take possession of buffer portion
>  	 */
> @@ -1018,7 +1019,7 @@ do_return_read_buf( drive_t *drivep, char *bufp, size_t retcnt )
>  	 * and (if ring in use) give buffer to ring for read-ahead.
>  	 */
>  	if ( contextp->dc_nextp >= contextp->dc_dataendp ) {
> -		ASSERT( contextp->dc_nextp == contextp->dc_dataendp );
> +		assert( contextp->dc_nextp == contextp->dc_dataendp );
>  		if ( ! contextp->dc_singlethreadedpr ) {
>  			contextp->dc_msgp->rm_op = RING_OP_READ;
>  			Ring_put( contextp->dc_ringp, contextp->dc_msgp );
> @@ -1049,9 +1050,9 @@ do_get_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  	/* the mark is simply the offset into the media file of the
>  	 * next byte to be read.
> @@ -1090,9 +1091,9 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  
>  	/* the desired mark is passed by reference, and is really just an
> @@ -1115,18 +1116,18 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  #endif
>  
> -		ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +		assert( contextp->dc_nextp >= contextp->dc_recp );
>  		recoff = ( u_int32_t )( contextp->dc_nextp
>  					-
>  					contextp->dc_recp );
> -		ASSERT( recoff <= tape_recsz );
> -		ASSERT( rechdrp->rec_used <= tape_recsz );
> -		ASSERT( recoff >= STAPE_HDR_SZ );
> -		ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -		ASSERT( recoff <= rechdrp->rec_used );
> +		assert( recoff <= tape_recsz );
> +		assert( rechdrp->rec_used <= tape_recsz );
> +		assert( recoff >= STAPE_HDR_SZ );
> +		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +		assert( recoff <= rechdrp->rec_used );
>  		currentoffset += ( off64_t )recoff;
>  	}
> -	ASSERT( wantedoffset >= currentoffset );
> +	assert( wantedoffset >= currentoffset );
>  	
>  	/* if we are currently holding a record and the desired offset
>  	 * is not within the current record, eat the current record.
> @@ -1149,12 +1150,12 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			 * must be just after it.
>  			 */
>  			if ( rechdrp->rec_used < tape_recsz ) {
> -				ASSERT( wantedoffset == nextrecoffset );
> +				assert( wantedoffset == nextrecoffset );
>  			}
>  
>  			/* figure how much to ask for
>  			 */
> -			ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +			assert( contextp->dc_nextp >= contextp->dc_recp );
>  			recoff = ( u_int32_t )( contextp->dc_nextp
>  						-
>  						contextp->dc_recp );
> @@ -1172,13 +1173,13 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			if ( rval ) {
>  				return rval;
>  			}
> -			ASSERT( actualcnt == wantedcnt );
> +			assert( actualcnt == wantedcnt );
>  			do_return_read_buf( drivep, dummybufp, actualcnt );
>  			currentoffset += ( off64_t )actualcnt;
> -			ASSERT( currentoffset == nextrecoffset );
> -			ASSERT( wantedoffset >= currentoffset );
> -			ASSERT( ! contextp->dc_recp );
> -			ASSERT( currentoffset
> +			assert( currentoffset == nextrecoffset );
> +			assert( wantedoffset >= currentoffset );
> +			assert( ! contextp->dc_recp );
> +			assert( currentoffset
>  				==
>  				contextp->dc_reccnt * ( off64_t )tape_recsz );
>  		}
> @@ -1197,14 +1198,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		off64_t wantedreccnt;
>  		seekmode_t seekmode;
>  		
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  		wantedreccnt = wantedoffset / ( off64_t )tape_recsz;
>  		if ( contextp->dc_singlethreadedpr ) {
>  			seekmode = SEEKMODE_RAW;
>  		} else {
>  			seekmode = SEEKMODE_BUF;
>  		}
> -		ASSERT( wantedreccnt != 0 ); /* so NOP below can be
> +		assert( wantedreccnt != 0 ); /* so NOP below can be
>  					      * distinguished from use
>  					      * in do_begin_read
>  					      */
> @@ -1214,7 +1215,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  			if ( seekmode == SEEKMODE_BUF ) {
>  				ring_stat_t rs;
> -				ASSERT( ! contextp->dc_msgp );
> +				assert( ! contextp->dc_msgp );
>  				contextp->dc_msgp =
>  						Ring_get( contextp->dc_ringp );
>  				rs = contextp->dc_msgp->rm_stat;
> @@ -1227,7 +1228,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				     rs != RING_STAT_INIT
>  				     &&
>  				     rs != RING_STAT_NOPACK ) {
> -					ASSERT( 0 );
> +					assert( 0 );
>  					contextp->dc_errorpr = BOOL_TRUE;
>  					return DRIVE_ERROR_CORE;
>  				}
> @@ -1249,8 +1250,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				continue;
>  			}
>  
> -			ASSERT( contextp->dc_reccnt == contextp->dc_iocnt );
> -			ASSERT( wantedreccnt > contextp->dc_reccnt );
> +			assert( contextp->dc_reccnt == contextp->dc_iocnt );
> +			assert( wantedreccnt > contextp->dc_reccnt );
>  			recskipcnt64 = wantedreccnt - contextp->dc_reccnt;
>  			recskipcnt64remaining = recskipcnt64;
>  			while ( recskipcnt64remaining ) {
> @@ -1258,14 +1259,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  				intgen_t saved_errno;
>  				intgen_t rval;
>  
> -				ASSERT( recskipcnt64remaining > 0 );
> +				assert( recskipcnt64remaining > 0 );
>  				if ( recskipcnt64remaining > INTGENMAX ) {
>  					recskipcnt = INTGENMAX;
>  				} else {
>  					recskipcnt = ( intgen_t )
>  						     recskipcnt64remaining;
>  				}
> -				ASSERT( recskipcnt > 0 );
> +				assert( recskipcnt > 0 );
>  				rval = mt_op( contextp->dc_fd,
>  					      MTFSR,
>  					      recskipcnt );
> @@ -1287,8 +1288,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			currentoffset = contextp->dc_reccnt
>  					*
>  					( off64_t )tape_recsz;
> -			ASSERT( wantedoffset >= currentoffset );
> -			ASSERT( wantedoffset - currentoffset
> +			assert( wantedoffset >= currentoffset );
> +			assert( wantedoffset - currentoffset
>  				<
>  				( off64_t )tape_recsz );
>  		}
> @@ -1303,7 +1304,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		size_t actualcnt;
>  		intgen_t rval;
>  
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  
>  		/* figure how much to ask for. to eat an entire record,
>  		 * ask for a record sans the header. do_read will eat
> @@ -1318,11 +1319,11 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		if ( rval ) {
>  			return rval;
>  		}
> -		ASSERT( actualcnt == wantedcnt );
> +		assert( actualcnt == wantedcnt );
>  		do_return_read_buf( drivep, dummybufp, actualcnt );
> -		ASSERT( ! contextp->dc_recp );
> +		assert( ! contextp->dc_recp );
>  		currentoffset += ( off64_t )tape_recsz;
> -		ASSERT( currentoffset
> +		assert( currentoffset
>  			==
>  			contextp->dc_reccnt * ( off64_t )tape_recsz );
>  	}
> @@ -1335,8 +1336,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		char *dummybufp;
>  		size_t actualcnt;
>  
> -		ASSERT( wantedoffset > currentoffset );
> -		ASSERT( wantedoffset - currentoffset < ( off64_t )tape_recsz );
> +		assert( wantedoffset > currentoffset );
> +		assert( wantedoffset - currentoffset < ( off64_t )tape_recsz );
>  		wantedcnt = ( size_t )( wantedoffset - currentoffset );
>  		if ( contextp->dc_recp ) {
>  			u_int32_t recoff;
> @@ -1346,14 +1347,14 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  			recoff = ( u_int32_t )( contextp->dc_nextp
>  						-
>  						contextp->dc_recp );
> -			ASSERT( recoff <= tape_recsz );
> -			ASSERT( rechdrp->rec_used <= tape_recsz );
> -			ASSERT( recoff >= STAPE_HDR_SZ );
> -			ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -			ASSERT( recoff <= rechdrp->rec_used );
> -			ASSERT( recoff + wantedcnt <= rechdrp->rec_used );
> +			assert( recoff <= tape_recsz );
> +			assert( rechdrp->rec_used <= tape_recsz );
> +			assert( recoff >= STAPE_HDR_SZ );
> +			assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +			assert( recoff <= rechdrp->rec_used );
> +			assert( recoff + wantedcnt <= rechdrp->rec_used );
>  		} else {
> -			ASSERT( wantedcnt >= STAPE_HDR_SZ );
> +			assert( wantedcnt >= STAPE_HDR_SZ );
>  			wantedcnt -= STAPE_HDR_SZ;
>  		}
>  
> @@ -1366,7 +1367,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		    if ( rval ) {
>  			    return rval;
>  		    }
> -		    ASSERT( actualcnt == wantedcnt );
> +		    assert( actualcnt == wantedcnt );
>  		    do_return_read_buf( drivep, dummybufp, actualcnt );
>  		}
>  	}
> @@ -1381,18 +1382,18 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  		rec_hdr_t *rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  #endif
>  
> -		ASSERT( contextp->dc_nextp >= contextp->dc_recp );
> +		assert( contextp->dc_nextp >= contextp->dc_recp );
>  		recoff = ( u_int32_t )( contextp->dc_nextp
>  					-
>  					contextp->dc_recp );
> -		ASSERT( recoff <= tape_recsz );
> -		ASSERT( rechdrp->rec_used <= tape_recsz );
> -		ASSERT( recoff >= STAPE_HDR_SZ );
> -		ASSERT( rechdrp->rec_used >= STAPE_HDR_SZ );
> -		ASSERT( recoff <= rechdrp->rec_used );
> +		assert( recoff <= tape_recsz );
> +		assert( rechdrp->rec_used <= tape_recsz );
> +		assert( recoff >= STAPE_HDR_SZ );
> +		assert( rechdrp->rec_used >= STAPE_HDR_SZ );
> +		assert( recoff <= rechdrp->rec_used );
>  		currentoffset += ( off64_t )recoff;
>  	}
> -	ASSERT( wantedoffset == currentoffset );
> +	assert( wantedoffset == currentoffset );
>  
>  	return 0;
>  }
> @@ -1425,9 +1426,9 @@ do_next_mark( drive_t *drivep )
>  
>  	/* assert protocol being followed.
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
>  
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "drive op: next mark\n" );
> @@ -1450,7 +1451,7 @@ noerrorsearch:
>  		}
>  		rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  
> -		ASSERT( rechdrp->first_mark_offset != 0 );
> +		assert( rechdrp->first_mark_offset != 0 );
>  		if ( rechdrp->first_mark_offset > 0 ) {
>  			 off64_t markoff = rechdrp->first_mark_offset
>  					   -
> @@ -1458,8 +1459,8 @@ noerrorsearch:
>  			 off64_t curoff = ( off64_t )( contextp->dc_nextp
>  						       -
>  						       contextp->dc_recp );
> -			 ASSERT( markoff > 0 );
> -			 ASSERT( curoff > 0 );
> +			 assert( markoff > 0 );
> +			 assert( curoff > 0 );
>  			 if ( markoff >= curoff ) {
>  				break;
>  			}
> @@ -1474,7 +1475,7 @@ noerrorsearch:
>  		contextp->dc_reccnt++;
>  	}
>  
> -	ASSERT( rechdrp->first_mark_offset - rechdrp->file_offset
> +	assert( rechdrp->first_mark_offset - rechdrp->file_offset
>  		<=
>  		( off64_t )tape_recsz );
>  	contextp->dc_nextp = contextp->dc_recp
> @@ -1482,8 +1483,8 @@ noerrorsearch:
>  			     ( size_t )( rechdrp->first_mark_offset
>  					 -
>  					 rechdrp->file_offset );
> -	ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> -	ASSERT( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> +	assert( contextp->dc_nextp <= contextp->dc_dataendp );
> +	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
>  	if ( contextp->dc_nextp == contextp->dc_dataendp ) {
>  		if ( ! contextp->dc_singlethreadedpr ) {
>  			Ring_put( contextp->dc_ringp,
> @@ -1509,7 +1510,7 @@ resetring:
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
> @@ -1561,7 +1562,7 @@ validateread:
>  	}
>  
>  	if ( nread >= 0 ) {
> -		ASSERT( ( size_t )nread <= tape_recsz );
> +		assert( ( size_t )nread <= tape_recsz );
>  		mlog( MLOG_DEBUG | MLOG_DRIVE,
>  		      "short read (nread == %d, record size == %d)\n",
>  		      nread,
> @@ -1604,24 +1605,24 @@ validatehdr:
>  		goto readrecord;
>  	}
>  
> -	ASSERT( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
> +	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
>  	markoff = rechdrp->first_mark_offset - rechdrp->file_offset;
> -	ASSERT( markoff >= ( off64_t )STAPE_HDR_SZ );
> -	ASSERT( markoff < ( off64_t )tape_recsz );
> -	ASSERT( rechdrp->rec_used > STAPE_HDR_SZ );
> -	ASSERT( rechdrp->rec_used < tape_recsz );
> +	assert( markoff >= ( off64_t )STAPE_HDR_SZ );
> +	assert( markoff < ( off64_t )tape_recsz );
> +	assert( rechdrp->rec_used > STAPE_HDR_SZ );
> +	assert( rechdrp->rec_used < tape_recsz );
>  
>  	goto alliswell;
>  
>  alliswell:
>  	contextp->dc_nextp = contextp->dc_recp + ( size_t )markoff;
> -	ASSERT( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
> +	assert( ! ( rechdrp->file_offset % ( off64_t )tape_recsz ));
>  	contextp->dc_reccnt = rechdrp->file_offset / ( off64_t )tape_recsz;
>  	contextp->dc_iocnt = contextp->dc_reccnt + 1;
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_dataendp = contextp->dc_recp + rechdrp->rec_used;
> -	ASSERT( contextp->dc_dataendp <= contextp->dc_recendp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_dataendp );
> +	assert( contextp->dc_dataendp <= contextp->dc_recendp );
> +	assert( contextp->dc_nextp < contextp->dc_dataendp );
>  	contextp->dc_errorpr = BOOL_FALSE;
>  
>  	mlog( MLOG_NORMAL | MLOG_DRIVE,
> @@ -1696,8 +1697,8 @@ do_end_read( drive_t *drivep )
>  
>  	/* assert protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
>  
>  	if ( ! contextp->dc_singlethreadedpr ) {
>  		Ring_reset( contextp->dc_ringp, contextp->dc_msgp );
> @@ -1745,9 +1746,9 @@ do_begin_write( drive_t *drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( ! drivep->d_markrecheadp );
> -	ASSERT( ! contextp->dc_recp );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( ! drivep->d_markrecheadp );
> +	assert( ! contextp->dc_recp );
>  
>  	/* get pointers into global write header
>  	 */
> @@ -1758,7 +1759,7 @@ do_begin_write( drive_t *drivep )
>  	/* must already be open. The only way to open is to do a begin_read.
>  	 * so all interaction with scsi tape requires reading first.
>  	 */
> -	ASSERT( contextp->dc_fd != -1 );
> +	assert( contextp->dc_fd != -1 );
>  
>  	/* get tape device status. verify tape is positioned
>   	 */
> @@ -1787,15 +1788,15 @@ do_begin_write( drive_t *drivep )
>  	/* get a record buffer. will be used for the media file header,
>  	 * and is needed to "prime the pump" for first call to do_write.
>  	 */
> -	ASSERT( ! contextp->dc_recp );
> +	assert( ! contextp->dc_recp );
>  	if ( contextp->dc_singlethreadedpr ) {
> -		ASSERT( contextp->dc_bufp );
> +		assert( contextp->dc_bufp );
>  		contextp->dc_recp = contextp->dc_bufp;
>  	} else {
> -		ASSERT( contextp->dc_ringp );
> -		ASSERT( ! contextp->dc_msgp );
> +		assert( contextp->dc_ringp );
> +		assert( ! contextp->dc_msgp );
>  		contextp->dc_msgp = Ring_get( contextp->dc_ringp );
> -		ASSERT( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
> +		assert( contextp->dc_msgp->rm_stat == RING_STAT_INIT );
>  		contextp->dc_recp = contextp->dc_msgp->rm_bufp;
>  	}
>  
> @@ -1840,7 +1841,7 @@ do_begin_write( drive_t *drivep )
>  	/* prepare the drive context. must have a record buffer ready to
>  	 * go, header initialized.
>  	 */
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( ! contextp->dc_ownedp );
>  	contextp->dc_reccnt = 1; /* count the header record */
>  	contextp->dc_recendp = contextp->dc_recp + tape_recsz;
>  	contextp->dc_nextp = contextp->dc_recp + STAPE_HDR_SZ;
> @@ -1885,15 +1886,15 @@ do_set_mark( drive_t *drivep,
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
>  
>  	/* calculate and fill in the mark record offset
>  	 */
> -	ASSERT( contextp->dc_recp );
> +	assert( contextp->dc_recp );
>  	nextoff = contextp->dc_reccnt * ( off64_t )tape_recsz
>  		  +
>  		  ( off64_t )( contextp->dc_nextp - contextp->dc_recp );
> @@ -1908,7 +1909,7 @@ do_set_mark( drive_t *drivep,
>  	 */
>  	rechdrp = ( rec_hdr_t * )contextp->dc_recp;
>  	if ( rechdrp->first_mark_offset == -1LL ) {
> -		ASSERT( nextoff != -1LL );
> +		assert( nextoff != -1LL );
>  		rechdrp->first_mark_offset = nextoff;
>  	}
>  
> @@ -1921,7 +1922,7 @@ do_set_mark( drive_t *drivep,
>  		drivep->d_markrecheadp = markrecp;
>  		drivep->d_markrectailp = markrecp;
>  	} else {
> -		ASSERT( drivep->d_markrectailp );
> +		assert( drivep->d_markrectailp );
>  		drivep->d_markrectailp->dm_nextp = markrecp;
>  		drivep->d_markrectailp = markrecp;
>  	}
> @@ -1948,12 +1949,12 @@ do_get_write_buf( drive_t *drivep, size_t wantedcnt, size_t *actualcntp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* figure how much is available; supply the min of what is
>  	 * available and what is wanted.
> @@ -2014,17 +2015,17 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp <= contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp <= contextp->dc_recendp );
>  
>  	/* verify the caller is returning exactly what is held
>  	 */
> -	ASSERT( bufp == contextp->dc_ownedp );
> -	ASSERT( retcnt == heldcnt );
> +	assert( bufp == contextp->dc_ownedp );
> +	assert( retcnt == heldcnt );
>  
>  	/* take it back
>  	 */
> @@ -2065,7 +2066,7 @@ do_write( drive_t *drivep, char *bufp, size_t retcnt )
>  			rval = contextp->dc_msgp->rm_rval;
>  			break;
>  		default:
> -			ASSERT( 0 );
> +			assert( 0 );
>  			return DRIVE_ERROR_CORE;
>  		}
>  	}
> @@ -2129,12 +2130,12 @@ do_get_align_cnt( drive_t * drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_errorpr );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_errorpr );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* calculate the next alignment point at or beyond the current nextp.
>  	 * the following algorithm works because all buffers are page-aligned
> @@ -2144,11 +2145,11 @@ do_get_align_cnt( drive_t * drivep )
>  	next_alignment_off +=  PGMASK;
>  	next_alignment_off &= ~PGMASK;
>  	next_alignment_point = ( char * )next_alignment_off;
> -	ASSERT( next_alignment_point <= contextp->dc_recendp );
> +	assert( next_alignment_point <= contextp->dc_recendp );
>  
>  	/* return the number of bytes to the next alignment offset
>  	 */
> -	ASSERT( next_alignment_point >= contextp->dc_nextp );
> +	assert( next_alignment_point >= contextp->dc_nextp );
>  	return ( size_t )( next_alignment_point - contextp->dc_nextp );
>  }
>  
> @@ -2175,12 +2176,12 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_recp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> -	ASSERT( contextp->dc_nextp < contextp->dc_recendp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_recp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp >= contextp->dc_recp + STAPE_HDR_SZ );
> +	assert( contextp->dc_nextp < contextp->dc_recendp );
>  
>  	/* pre-initialize return of count of bytes committed to media
>  	 */
> @@ -2222,7 +2223,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  					     contextp->dc_recp,
>  					     BOOL_TRUE, BOOL_TRUE );
>  		} else {
> -			ASSERT( contextp->dc_msgp );
> +			assert( contextp->dc_msgp );
>  			contextp->dc_msgp->rm_op = RING_OP_WRITE;
>  			contextp->dc_msgp->rm_user = contextp->dc_reccnt;
>  			Ring_put( contextp->dc_ringp,
> @@ -2238,7 +2239,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  				rval = contextp->dc_msgp->rm_rval;
>  				break;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_recp = 0;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -2265,7 +2266,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  	}
>  	if ( ! contextp->dc_singlethreadedpr ) {
>  		while ( ! rval ) {
> -			ASSERT( contextp->dc_msgp );
> +			assert( contextp->dc_msgp );
>  			contextp->dc_msgp->rm_op = RING_OP_TRACE;
>  			Ring_put( contextp->dc_ringp,
>  				  contextp->dc_msgp );
> @@ -2277,14 +2278,14 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  			switch( contextp->dc_msgp->rm_stat ) {
>  			case RING_STAT_OK:
>  			case RING_STAT_INIT:
> -				ASSERT( rval == 0 );
> +				assert( rval == 0 );
>  				break;
>  			case RING_STAT_ERROR:
>  				rval = contextp->dc_msgp->rm_rval;
>  				first_rec_w_err = contextp->dc_msgp->rm_user;
>  				break;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_recp = 0;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -2346,11 +2347,11 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  	 * to tape.
>  	 */
>  	if ( rval ) {
> -		ASSERT( first_rec_w_err >= 0 );
> +		assert( first_rec_w_err >= 0 );
>  		recs_wtn_wo_err = first_rec_w_err;
>  		recs_guaranteed = recs_wtn_wo_err - contextp->dc_lostrecmax;
>  	} else {
> -		ASSERT( first_rec_w_err == -1 );
> +		assert( first_rec_w_err == -1 );
>  		recs_wtn_wo_err = contextp->dc_iocnt;
>  		recs_guaranteed = recs_wtn_wo_err;
>  	}
> @@ -2382,14 +2383,14 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "drive op: fsf: count %d\n",
>  	      count );
>  
> -	ASSERT( count );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( count );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	/* get tape status
>    	 */
> @@ -2426,7 +2427,7 @@ do_fsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  			      _("advancing tape to next media file\n") );
>  
>  			op_failed = 0;
> -			ASSERT( contextp->dc_fd >= 0 );
> +			assert( contextp->dc_fd >= 0 );
>  			if ( mt_op( contextp->dc_fd, MTFSF, 1 ) ) {
>  				op_failed = 1;
>  			}
> @@ -2482,7 +2483,7 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  	      "drive op: bsf: count %d\n",
>  	      count );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	*statp = 0;
>  
> @@ -2515,7 +2516,7 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  			*statp = DRIVE_ERROR_DEVICE;
>  			return 0;
>  		}
> -		ASSERT( IS_BOT(mtstat ));
> +		assert( IS_BOT(mtstat ));
>  
>  
>  		*statp = DRIVE_ERROR_BOM;
> @@ -2531,7 +2532,7 @@ do_bsf( drive_t *drivep, intgen_t count, intgen_t *statp )
>  
>  	/* back space - places us to left of previous file mark
>  	 */
> -	ASSERT( drivep->d_capabilities & DRIVE_CAP_BSF );
> +	assert( drivep->d_capabilities & DRIVE_CAP_BSF );
>  	mtstat = bsf_and_verify( drivep );
>  
>  	/* check again for beginning-of-tape condition
> @@ -2606,8 +2607,8 @@ do_rewind( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "drive op: rewind\n" );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* use validating tape rewind util func
>  	 */
> @@ -2637,8 +2638,8 @@ do_erase( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "drive op: erase\n" );
>  
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* use validating tape rewind util func
>  	 */
> @@ -2681,8 +2682,8 @@ do_eject_media( drive_t *drivep )
>  
>  	/* drive must be open
>  	 */
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	/* issue tape unload
>  	 */
> @@ -2913,7 +2914,7 @@ read_label( drive_t *drivep )
>  	/* if a read error, get status
>  	 */
>  	if ( nread != ( intgen_t )tape_recsz ) {
> -		ASSERT( nread < ( intgen_t )tape_recsz );
> +		assert( nread < ( intgen_t )tape_recsz );
>  		ok = mt_get_status( drivep, &mtstat );
>  		if ( ! ok ) {
>  			status_failed_message( drivep );
> @@ -3135,10 +3136,10 @@ set_fixed_blksz( drive_t *drivep, size_t blksz )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( blksz );
> -	ASSERT( contextp->dc_isvarpr == BOOL_FALSE );
> -	ASSERT( contextp->dc_cansetblkszpr );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( blksz );
> +	assert( contextp->dc_isvarpr == BOOL_FALSE );
> +	assert( contextp->dc_cansetblkszpr );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* give it two tries: first without rewinding, second with rewinding
>  	 */
> @@ -3213,7 +3214,7 @@ get_tpcaps( drive_t *drivep )
>  {
>  	drive_context_t	*contextp = ( drive_context_t * )drivep->d_contextp;
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	if ( contextp->dc_isrmtpr ) {
>  		/* can't ask about blksz, can't set blksz, can't ask about
> @@ -3386,7 +3387,7 @@ mt_op(intgen_t fd, intgen_t sub_op, intgen_t param )
>  	mop.mt_op   	= (short )sub_op;
>  	mop.mt_count	= param;
>  
> -	ASSERT( fd >= 0 );
> +	assert( fd >= 0 );
>  
>  	switch ( sub_op ) {
>  	case MTSEEK:
> @@ -3458,7 +3459,7 @@ mt_get_fileno( drive_t *drivep, long *fileno)
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: get fileno\n" );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	if ( ioctl(contextp->dc_fd, MTIOCGET, &mt_stat) < 0 ) {
>  		/* failure
> @@ -3491,7 +3492,7 @@ mt_get_status( drive_t *drivep, long *status)
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: get status\n" );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	if (TS_ISDRIVER) {
>  		/*
> @@ -3864,7 +3865,7 @@ retry:
>  
>  	/* shouldn't be here if drive is open
>  	 */
> -	ASSERT( contextp->dc_fd == -1 );
> +	assert( contextp->dc_fd == -1 );
>  
>  	mlog( MLOG_VERBOSE | MLOG_DRIVE,
>  	      _("preparing drive\n") );
> @@ -3966,7 +3967,7 @@ retry:
>  
>  		Close( drivep );
>  	}
> -	ASSERT( IS_ONL( mtstat ));
> +	assert( IS_ONL( mtstat ));
>  
>  	/* determine tape capabilities. this will set the drivep->d_capabilities
>  	 * and contextp->dc_{...}blksz and dc_isQICpr, as well as recommended
> @@ -4156,7 +4157,7 @@ retry:
>  			      contextp->dc_recp,
>  			      tape_recsz,
>  			      &saved_errno );
> -		ASSERT( saved_errno == 0 || nread < 0 );
> +		assert( saved_errno == 0 || nread < 0 );
>  
>  		/* RMT can require a retry
>  		 */
> @@ -4536,7 +4537,7 @@ checkhdr:
>  			rec_hdr_t *tprhdrp;
>  			drhdrp = drivep->d_readhdrp;
>  			tprhdrp = ( rec_hdr_t * )drhdrp->dh_specific;
> -			ASSERT( tprhdrp->recsize >= 0 );
> +			assert( tprhdrp->recsize >= 0 );
>  			tape_recsz = ( size_t )tprhdrp->recsize;
>  			mlog( MLOG_DEBUG | MLOG_DRIVE,
>  			      "tape record size set to header's "
> @@ -4657,7 +4658,7 @@ Open( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: opening drive\n" );
>  
> -	ASSERT( contextp->dc_fd == -1 );
> +	assert( contextp->dc_fd == -1 );
>  
>  	errno = 0;
>  	contextp->dc_fd = open( drivep->d_pathname, oflags );
> @@ -4678,7 +4679,7 @@ Close( drive_t *drivep )
>  	mlog( MLOG_DEBUG | MLOG_DRIVE,
>  	      "tape op: closing drive\n" );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	( void )close( contextp->dc_fd );
>  
> @@ -4695,8 +4696,8 @@ Read( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
>  	      "tape op: reading %u bytes\n",
>  	      cnt );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( bufp );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( bufp );
>  	*errnop = 0;
>  	errno = 0;
>  	nread = read( contextp->dc_fd, ( void * )bufp, cnt );
> @@ -4731,8 +4732,8 @@ Write( drive_t *drivep, char *bufp, size_t cnt, intgen_t *errnop )
>  	      "tape op: writing %u bytes\n",
>  	      cnt );
>  
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( bufp );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( bufp );
>  	*errnop = 0;
>  	errno = 0;
>  	nwritten = write( contextp->dc_fd, ( void * )bufp, cnt );
> @@ -4944,7 +4945,7 @@ read_record(  drive_t *drivep, char *bufp )
>  	/* short read
>  	 */
>  	if ( nread >= 0 ) {
> -		ASSERT( nread <= ( intgen_t )tape_recsz );
> +		assert( nread <= ( intgen_t )tape_recsz );
>  		mlog( MLOG_DEBUG | MLOG_DRIVE,
>  		      "short read record %lld (nread == %d)\n",
>  		      contextp->dc_iocnt,
> @@ -5006,7 +5007,7 @@ getrec( drive_t *drivep )
>  				contextp->dc_errorpr = BOOL_TRUE;
>  				return contextp->dc_msgp->rm_rval;
>  			default:
> -				ASSERT( 0 );
> +				assert( 0 );
>  				contextp->dc_errorpr = BOOL_TRUE;
>  				return DRIVE_ERROR_CORE;
>  			}
> @@ -5019,7 +5020,7 @@ getrec( drive_t *drivep )
>  		contextp->dc_nextp = contextp->dc_recp
>  				     +
>  				     STAPE_HDR_SZ;
> -		ASSERT( contextp->dc_nextp <= contextp->dc_dataendp );
> +		assert( contextp->dc_nextp <= contextp->dc_dataendp );
>  	}
>  
>  	return 0;
> @@ -5055,7 +5056,7 @@ write_record(  drive_t *drivep, char *bufp, bool_t chksumpr, bool_t xlatepr )
>  	}
>  
>  	rval = determine_write_error( drivep, nwritten, saved_errno );
> -	ASSERT( rval );
> +	assert( rval );
>  
>  	return rval;
>  }
> @@ -5094,7 +5095,7 @@ Ring_reset(  ring_t *ringp, ring_msg_t *msgp )
>  	mlog( (MLOG_NITTY + 1) | MLOG_DRIVE,
>  	      "ring op: reset\n" );
>  	
> -	ASSERT( ringp );
> +	assert( ringp );
>  
>  	ring_reset( ringp, msgp );
>  }
> @@ -5125,19 +5126,19 @@ display_ring_metrics( drive_t *drivep, intgen_t mlog_flags )
>  	char *bufszsfxp;
>  	
>  	if ( tape_recsz == STAPE_MIN_MAX_BLKSZ ) {
> -		ASSERT( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
> +		assert( ! ( STAPE_MIN_MAX_BLKSZ % 0x400 ));
>  		sprintf( bufszbuf, "%u", STAPE_MIN_MAX_BLKSZ / 0x400 );
> -		ASSERT( strlen( bufszbuf ) < sizeof( bufszbuf ));
> +		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
>  		bufszsfxp = "KB";
>  	} else if ( tape_recsz == STAPE_MAX_RECSZ ) {
> -		ASSERT( ! ( STAPE_MAX_RECSZ % 0x100000 ));
> +		assert( ! ( STAPE_MAX_RECSZ % 0x100000 ));
>  		sprintf( bufszbuf, "%u", STAPE_MAX_RECSZ / 0x100000 );
> -		ASSERT( strlen( bufszbuf ) < sizeof( bufszbuf ));
> +		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
>  		bufszsfxp = "MB";
>  	} else if ( tape_recsz == STAPE_MAX_LINUX_RECSZ ) {
> -		ASSERT( ! ( STAPE_MAX_LINUX_RECSZ % 0x100000 ));
> +		assert( ! ( STAPE_MAX_LINUX_RECSZ % 0x100000 ));
>  		sprintf( bufszbuf, "%u", STAPE_MAX_LINUX_RECSZ / 0x100000 );
> -		ASSERT( strlen( bufszbuf ) < sizeof( bufszbuf ));
> +		assert( strlen( bufszbuf ) < sizeof( bufszbuf ));
>  		bufszsfxp = "MB";
>  	} else {
>  		bufszsfxp = "";
> diff --git a/common/drive_simple.c b/common/drive_simple.c
> index 2b0447d..2e57d8c 100644
> --- a/common/drive_simple.c
> +++ b/common/drive_simple.c
> @@ -25,6 +25,7 @@
>  #include <errno.h>
>  #include <malloc.h>
>  #include <sched.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -185,7 +186,7 @@ ds_match( int argc, char *argv[], drive_t *drivep )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( ! ( sizeofmember( drive_context_t, dc_buf ) % PGSZ ));
> +	assert( ! ( sizeofmember( drive_context_t, dc_buf ) % PGSZ ));
>  
>  	/* determine if this is an rmt file. if so, give a weak match:
>  	 * might be an ordinary file accessed via the rmt protocol.
> @@ -234,8 +235,8 @@ ds_instantiate( int argc, char *argv[], drive_t *drivep )
>  	 */
>  	contextp = ( drive_context_t * )memalign( PGSZ,
>  						  sizeof( drive_context_t ));
> -	ASSERT( contextp );
> -	ASSERT( ( void * )contextp->dc_buf == ( void * )contextp );
> +	assert( contextp );
> +	assert( ( void * )contextp->dc_buf == ( void * )contextp );
>  	memset( ( void * )contextp, 0, sizeof( *contextp ));
>  
>  	/* scan drive device pathname to see if remote tape
> @@ -439,9 +440,9 @@ do_begin_read( drive_t *drivep )
>  
>  	/* verify protocol being followed
>  	 */
> -	ASSERT( dcaps & DRIVE_CAP_READ );
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( dcaps & DRIVE_CAP_READ );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	/* can only read one media file
>  	 */
> @@ -484,7 +485,7 @@ do_begin_read( drive_t *drivep )
>  		free(tmphdr);
>  		return rval;
>  	}
> -	ASSERT( ( size_t )nread == GLOBAL_HDR_SZ );
> +	assert( ( size_t )nread == GLOBAL_HDR_SZ );
>  	
>  	mlog(MLOG_NITTY, "do_begin_read: global_hdr\n"
>  	     "\tgh_magic %.100s\n"
> @@ -585,9 +586,9 @@ do_read( drive_t *drivep,
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( wantedcnt > 0 );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
> +	assert( wantedcnt > 0 );
>  
>  	/* pre-initialize reference return
>  	 */
> @@ -595,7 +596,7 @@ do_read( drive_t *drivep,
>  
>  	/* count number of unread bytes in buffer
>  	 */
> -	ASSERT( contextp->dc_emptyp >= contextp->dc_nextp );
> +	assert( contextp->dc_emptyp >= contextp->dc_nextp );
>  	remainingcnt = ( size_t )( contextp->dc_emptyp - contextp->dc_nextp );
>  
>  	/* if no unread bytes in buffer, refill
> @@ -628,7 +629,7 @@ do_read( drive_t *drivep,
>  		/* record the ptrs to the first empty byte and the next
>  		 * byte to be read
>  		 */
> -		ASSERT( nread <= BUFSZ );
> +		assert( nread <= BUFSZ );
>  		contextp->dc_emptyp = contextp->dc_buf + nread;
>  		contextp->dc_nextp = contextp->dc_buf;
>  
> @@ -656,7 +657,7 @@ do_read( drive_t *drivep,
>  	/* advance the next ptr to the next byte to be supplied
>  	 */
>  	contextp->dc_nextp += actualcnt;
> -	ASSERT( contextp->dc_nextp <= contextp->dc_emptyp );
> +	assert( contextp->dc_nextp <= contextp->dc_emptyp );
>  
>  	/* return the actual number of bytes supplied, and a ptr to the first
>  	 */
> @@ -681,17 +682,17 @@ do_return_read_buf( drive_t *drivep, char *retp, size_t retcnt )
>  
>  	/* verify protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( contextp->dc_ownedp );
>  
>  	/* verify returning right buffer
>  	 */
> -	ASSERT( retp == contextp->dc_ownedp );
> +	assert( retp == contextp->dc_ownedp );
>  
>  	/* verify all of buffer provided is being returned
>  	 */
>  	ownedcnt = ( size_t )( contextp->dc_nextp - contextp->dc_ownedp );
> -	ASSERT( retcnt == ownedcnt );
> +	assert( retcnt == ownedcnt );
>  
>  	/* indicate nothing now owned by caller
>  	 */
> @@ -713,8 +714,8 @@ do_get_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
>  
>  	/* calculate the offset of the next byte to be supplied relative to
>  	 * the beginning of the buffer and relative to the beginning of
> @@ -746,8 +747,8 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
>  
>  	/* calculate the current offset within the media file
>  	 * of the next byte to be read
> @@ -784,7 +785,7 @@ do_seek_mark( drive_t *drivep, drive_mark_t *markp )
>  	 */
>  	nextoff = ( off64_t )( contextp->dc_nextp - contextp->dc_buf );
>  	strmoff = contextp->dc_bufstroff + nextoff;
> -	ASSERT( strmoff == mark );
> +	assert( strmoff == mark );
>  
>  	return 0;
>  }
> @@ -808,9 +809,9 @@ do_next_mark( drive_t *drivep )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( dcaps & DRIVE_CAP_NEXTMARK );
> -	ASSERT( contextp->dc_mode == OM_READ );
> -	ASSERT( ! contextp->dc_ownedp );
> +	assert( dcaps & DRIVE_CAP_NEXTMARK );
> +	assert( contextp->dc_mode == OM_READ );
> +	assert( ! contextp->dc_ownedp );
>  
>  	if ( ! mark ) {
>  		return DRIVE_ERROR_EOF;
> @@ -837,13 +838,13 @@ do_end_read( drive_t *drivep )
>  
>  	/* be sure we are following protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_READ );
> +	assert( contextp->dc_mode == OM_READ );
>  	contextp->dc_mode = OM_NONE;
>  
>  	/* bump the file mark cnt
>  	 */
>  	contextp->dc_fmarkcnt++;
> -	ASSERT( contextp->dc_fmarkcnt == 1 );
> +	assert( contextp->dc_fmarkcnt == 1 );
>  }
>  
>  /* begin_write - prepare file for writing
> @@ -871,12 +872,12 @@ do_begin_write( drive_t *drivep )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( dwhdrp->dh_strategyid == DRIVE_STRATEGY_SIMPLE );
> +	assert( dwhdrp->dh_strategyid == DRIVE_STRATEGY_SIMPLE );
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_fd >= 0 );
> -	ASSERT( contextp->dc_mode == OM_NONE );
> +	assert( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
>  
>  	/* only one media file may be written
>  	 */
> @@ -918,7 +919,7 @@ do_begin_write( drive_t *drivep )
>  	contextp->dc_mode = OM_WRITE;
>  
>  	tmphdr = (global_hdr_t *)malloc(GLOBAL_HDR_SZ);
> -	ASSERT(tmphdr);
> +	assert(tmphdr);
>  	memset(tmphdr, 0, GLOBAL_HDR_SZ);
>  	tmpdh = (drive_hdr_t *)tmphdr->gh_upper;
>  	tmpmh = (media_hdr_t *)tmpdh->dh_upper;
> @@ -997,9 +998,9 @@ do_set_mark( drive_t *drivep,
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_nextp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_nextp );
>  
>  	/* calculate the mark offset
>  	 */
> @@ -1053,7 +1054,7 @@ do_set_mark( drive_t *drivep,
>  
>  			/* assert the header has been flushed
>  			 */
> -			ASSERT( contextp->dc_bufstroff >= sizeof( *gwhdrp ));
> +			assert( contextp->dc_bufstroff >= sizeof( *gwhdrp ));
>  
>  			/* record mark in hdr
>  			 */
> @@ -1082,7 +1083,7 @@ do_set_mark( drive_t *drivep,
>  				content_hdr_t		*ch = (content_hdr_t *)mh->mh_upper;
>  				content_inode_hdr_t	*cih = (content_inode_hdr_t *)ch->ch_specific;
>  
> -				ASSERT( newoff == 0 );
> +				assert( newoff == 0 );
>  
>  				/* write and seek back to current offset
>  				 */
> @@ -1092,7 +1093,7 @@ do_set_mark( drive_t *drivep,
>  				     "(on media)\n" );
>  
>  				tmphdr = (global_hdr_t *)malloc(GLOBAL_HDR_SZ);
> -				ASSERT(tmphdr);
> +				assert(tmphdr);
>  				tmpdh = (drive_hdr_t *)tmphdr->gh_upper;
>  				tmpmh = (media_hdr_t *)tmpdh->dh_upper;
>  				tmpch = (content_hdr_t *)tmpmh->mh_upper;
> @@ -1129,13 +1130,13 @@ do_set_mark( drive_t *drivep,
>  				nwritten = write( contextp->dc_fd,
>  						  tmphdr,
>  						  sizeof( *tmphdr ));
> -				ASSERT( ( size_t )nwritten == sizeof( *tmphdr ));
> +				assert( ( size_t )nwritten == sizeof( *tmphdr ));
>  				free(tmphdr);
>  
>  				newoff = lseek64( contextp->dc_fd,
>  						  contextp->dc_bufstroff,
>  						  SEEK_SET );
> -				ASSERT( newoff == contextp->dc_bufstroff );
> +				assert( newoff == contextp->dc_bufstroff );
>  			}
>  		}
>  	}
> @@ -1144,7 +1145,7 @@ do_set_mark( drive_t *drivep,
>  	 * otherwise put the mark record on the tail of the queue.
>  	 */
>  	if ( contextp->dc_nextp == contextp->dc_buf ) {
> -		ASSERT( drivep->d_markrecheadp == 0 );
> +		assert( drivep->d_markrecheadp == 0 );
>  		( * cbfuncp )( cbcontextp, markrecp, BOOL_TRUE );
>  		return;
>  	} else {
> @@ -1155,7 +1156,7 @@ do_set_mark( drive_t *drivep,
>  			drivep->d_markrecheadp = markrecp;
>  			drivep->d_markrectailp = markrecp;
>  		} else {
> -			ASSERT( drivep->d_markrectailp );
> +			assert( drivep->d_markrectailp );
>  			drivep->d_markrectailp->dm_nextp = markrecp;
>  			drivep->d_markrectailp = markrecp;
>  		}
> @@ -1180,11 +1181,11 @@ do_get_write_buf( drive_t *drivep, size_t wanted_bufsz, size_t *actual_bufszp )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_emptyp );
> -	ASSERT( contextp->dc_ownedsz == 0 );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_emptyp );
> +	assert( contextp->dc_ownedsz == 0 );
>  
>  	/* calculate how much buffer remains
>  	 */
> @@ -1237,18 +1238,18 @@ do_write( drive_t *drivep, char *bufp, size_t writesz )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( contextp->dc_ownedp );
> -	ASSERT( bufp == contextp->dc_ownedp );
> -	ASSERT( ! contextp->dc_nextp );
> -	ASSERT( contextp->dc_ownedp < contextp->dc_emptyp );
> -	ASSERT( writesz == contextp->dc_ownedsz );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( contextp->dc_ownedp );
> +	assert( bufp == contextp->dc_ownedp );
> +	assert( ! contextp->dc_nextp );
> +	assert( contextp->dc_ownedp < contextp->dc_emptyp );
> +	assert( writesz == contextp->dc_ownedsz );
>  
>  	/* calculate next portion of buffer available for get_write_buf,
>  	 * and indicate no portion is owned.
>  	 */
>  	contextp->dc_nextp = contextp->dc_ownedp + writesz;
> -	ASSERT( contextp->dc_nextp <= contextp->dc_emptyp );
> +	assert( contextp->dc_nextp <= contextp->dc_emptyp );
>  	contextp->dc_ownedp = 0;
>  	contextp->dc_ownedsz = 0;
>  
> @@ -1304,10 +1305,10 @@ do_get_align_cnt( drive_t *drivep )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_emptyp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_emptyp );
>  
>  	/* calculate the next alignment point at or beyond the current nextp.
>  	 * the following algorithm works because dc_buf is page-aligned and
> @@ -1317,7 +1318,7 @@ do_get_align_cnt( drive_t *drivep )
>  	next_alignment_off +=  PGMASK;
>  	next_alignment_off &= ~PGMASK;
>  	next_alignment_point = ( char * )next_alignment_off;
> -	ASSERT( next_alignment_point <= contextp->dc_emptyp );
> +	assert( next_alignment_point <= contextp->dc_emptyp );
>  
>  	/* return the number of bytes to the next alignment point
>  	 */
> @@ -1338,14 +1339,14 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_WRITE );
> -	ASSERT( ! contextp->dc_ownedp );
> -	ASSERT( contextp->dc_nextp );
> -	ASSERT( contextp->dc_nextp < contextp->dc_emptyp );
> +	assert( contextp->dc_mode == OM_WRITE );
> +	assert( ! contextp->dc_ownedp );
> +	assert( contextp->dc_nextp );
> +	assert( contextp->dc_nextp < contextp->dc_emptyp );
>  
>  	/* calculate length of un-written portion of buffer
>  	 */
> -	ASSERT( contextp->dc_nextp >= contextp->dc_buf );
> +	assert( contextp->dc_nextp >= contextp->dc_buf );
>  	remaining_bufsz = ( size_t )( contextp->dc_nextp - contextp->dc_buf );
>  
>  	if ( remaining_bufsz ) {
> @@ -1387,7 +1388,7 @@ do_end_write( drive_t *drivep, off64_t *ncommittedp )
>  	/* bump the file mark cnt
>  	 */
>  	contextp->dc_fmarkcnt++;
> -	ASSERT( contextp->dc_fmarkcnt == 1 );
> +	assert( contextp->dc_fmarkcnt == 1 );
>  
>  	*ncommittedp = contextp->dc_bufstroff;
>  	contextp->dc_mode = OM_NONE;
> @@ -1410,15 +1411,15 @@ do_rewind( drive_t *drivep )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( dcaps & DRIVE_CAP_REWIND );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( dcaps & DRIVE_CAP_REWIND );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* seek to beginning of file
>  	 */
>  	newoff = lseek64( contextp->dc_fd, ( off64_t )0, SEEK_SET );
>  	if ( newoff ) {
> -		ASSERT( newoff < 0 );
> +		assert( newoff < 0 );
>  		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  		      _("could not rewind %s: %s\n"),
>  		      drivep->d_pathname,
> @@ -1446,15 +1447,15 @@ do_erase( drive_t *drivep )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( dcaps & DRIVE_CAP_ERASE );
> -	ASSERT( contextp->dc_fd >= 0 );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( dcaps & DRIVE_CAP_ERASE );
> +	assert( contextp->dc_fd >= 0 );
>  
>  	/* seek to beginning of file
>  	 */
>  	newoff = lseek64( contextp->dc_fd, ( off64_t )0, SEEK_SET );
>  	if ( newoff ) {
> -		ASSERT( newoff < 0 );
> +		assert( newoff < 0 );
>  		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_DRIVE,
>  		      _("could not rewind %s in prep for erase: %s\n"),
>  		      drivep->d_pathname,
> @@ -1486,7 +1487,7 @@ do_get_device_class( drive_t *drivep )
>  {
>  	mlog( MLOG_NITTY | MLOG_DRIVE,
>  	      "drive_simple get_device_class( )\n" );
> -	ASSERT( drivep );
> +	assert( drivep );
>  	return DEVICE_NONREMOVABLE;
>  }
>  
> @@ -1500,8 +1501,8 @@ do_quit( drive_t *drivep )
>  
>  	/* assert protocol
>  	 */
> -	ASSERT( contextp->dc_mode == OM_NONE );
> -	ASSERT( contextp );
> +	assert( contextp->dc_mode == OM_NONE );
> +	assert( contextp );
>  
>  	/* close file
>  	 */
> diff --git a/common/fs.c b/common/fs.c
> index 6f4cb6c..b77f6cc 100644
> --- a/common/fs.c
> +++ b/common/fs.c
> @@ -27,6 +27,7 @@
>  #include <fcntl.h>
>  #include <mntent.h>
>  #include <sys/ioctl.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -127,11 +128,11 @@ fs_info( char *typb,		/* out */
>  	if ( canstat && ( statb.st_mode & S_IFMT ) == S_IFBLK ) {
>  		if ( ( tep = fs_tab_lookup_blk( usrs )) != 0 ) {
>  			blks = tep->fte_blks;
> -			ASSERT( strlen( blks ) < ( size_t )blkbz );
> +			assert( strlen( blks ) < ( size_t )blkbz );
>  			strcpy( blkb, blks );
>  			mnts = tep->fte_mnts;
>  			if ( mnts ) {
> -				ASSERT( strlen( mnts ) < ( size_t )mntbz );
> +				assert( strlen( mnts ) < ( size_t )mntbz );
>  				strcpy( mntb, mnts );
>  			} else {
>  				mntb[ 0 ] = 0;
> @@ -139,7 +140,7 @@ fs_info( char *typb,		/* out */
>  			if ( ( typs = tep->fte_typs ) == 0 ) {
>  				typs = typd;
>  			}
> -			ASSERT( strlen( typs ) < ( size_t )typbz );
> +			assert( strlen( typs ) < ( size_t )typbz );
>  			strcpy( typb, typs );
>  			ok = BOOL_TRUE;
>  		} else {
> @@ -147,13 +148,13 @@ fs_info( char *typb,		/* out */
>  		}
>  	} else if ( ( tep = fs_tab_lookup_mnt( usrs )) != 0 ) {
>  		blks = tep->fte_blks;
> -		ASSERT( strlen( blks ) < ( size_t )blkbz );
> +		assert( strlen( blks ) < ( size_t )blkbz );
>  		strcpy( blkb, blks );
>  		mnts = tep->fte_mnts;
> -		ASSERT( strlen( mnts ) < ( size_t )mntbz );
> +		assert( strlen( mnts ) < ( size_t )mntbz );
>  		strcpy( mntb, mnts );
>  		typs = tep->fte_typs;
> -		ASSERT( strlen( typs ) < ( size_t )typbz );
> +		assert( strlen( typs ) < ( size_t )typbz );
>  		strcpy( typb, typs );
>  		ok = BOOL_TRUE;
>  	} else {
> @@ -161,7 +162,7 @@ fs_info( char *typb,		/* out */
>  	}
>  
>  	fs_tab_free( );
> -	ASSERT( ok != BOOL_UNKNOWN );
> +	assert( ok != BOOL_UNKNOWN );
>  
>  	if ( ok == BOOL_TRUE ) {
>  		intgen_t rval = fs_getid( mntb, idb );
> @@ -281,11 +282,11 @@ fs_tab_ent_build( struct mntent *mntentp )
>  	char *cp;
>  
>  	tep = ( fs_tab_ent_t * )calloc( 1, sizeof( fs_tab_ent_t ));
> -	ASSERT( tep );
> +	assert( tep );
>  
>  	if ( mntentp->mnt_dir ) {
>  		cp = calloc( 1, strlen( mntentp->mnt_dir ) + 1 );
> -		ASSERT( cp );
> +		assert( cp );
>  		( void )strcpy( cp, mntentp->mnt_dir );
>  		tep->fte_mnts = cp;
>  	} else {
> @@ -294,7 +295,7 @@ fs_tab_ent_build( struct mntent *mntentp )
>  
>  	if ( mntentp->mnt_type ) {
>  		cp = calloc( 1, strlen( mntentp->mnt_type ) + 1 );
> -		ASSERT( cp );
> +		assert( cp );
>  		( void )strcpy( cp, mntentp->mnt_type );
>  		tep->fte_typs = cp;
>  	} else {
> @@ -303,7 +304,7 @@ fs_tab_ent_build( struct mntent *mntentp )
>  
>  	if ( mntentp->mnt_fsname ) {
>  		cp = calloc( 1, strlen( mntentp->mnt_fsname ) + 1 );
> -		ASSERT( cp );
> +		assert( cp );
>  		( void )strcpy( cp, mntentp->mnt_fsname );
>  		tep->fte_blks = cp;
>  	} else {
> diff --git a/common/global.c b/common/global.c
> index 8e49d8b..ed844cc 100644
> --- a/common/global.c
> +++ b/common/global.c
> @@ -22,6 +22,7 @@
>  #include <sys/stat.h>
>  #include <time.h>
>  #include <errno.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -67,13 +68,13 @@ global_hdr_alloc( intgen_t argc, char *argv[ ] )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( time32_t ) == GLOBAL_HDR_TIME_SZ );
> -	ASSERT( sizeof( uuid_t ) == GLOBAL_HDR_UUID_SZ );
> +	assert( sizeof( time32_t ) == GLOBAL_HDR_TIME_SZ );
> +	assert( sizeof( uuid_t ) == GLOBAL_HDR_UUID_SZ );
>  
>  	/* allocate a global hdr
>  	 */
>  	ghdrp = ( global_hdr_t * )calloc( 1, sizeof( global_hdr_t ));
> -	ASSERT( ghdrp );
> +	assert( ghdrp );
>  
>  	/* fill in the magic number
>  	 */
> @@ -326,7 +327,7 @@ prompt_label( char *bufp, size_t bufsz )
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	responseix = dlog_string_query( prompt_label_cb,
> @@ -348,7 +349,7 @@ prompt_label( char *bufp, size_t bufsz )
>  		ackstr[ ackcnt++ ] = _("session label left blank\n");
>  	}
>  
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_string_ack( ackstr,
>  			 ackcnt );
>  
> @@ -357,7 +358,7 @@ prompt_label( char *bufp, size_t bufsz )
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> diff --git a/common/hsmapi.c b/common/hsmapi.c
> index 7f9b45e..0bca9ff 100644
> --- a/common/hsmapi.c
> +++ b/common/hsmapi.c
> @@ -19,6 +19,7 @@
>  #include <xfs/xfs.h>
>  #include <attr/attributes.h>
>  #include <xfs/jdm.h>
> +#include <assert.h>
>  
>  #include "hsmapi.h"
>  #include "mlog.h"
> diff --git a/common/inventory.c b/common/inventory.c
> index fb27048..681d28f 100644
> --- a/common/inventory.c
> +++ b/common/inventory.c
> @@ -27,6 +27,7 @@
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <sys/stat.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "inventory_priv.h"
> @@ -51,7 +52,7 @@ inv_open( inv_predicate_t bywhat, void *pred )
>  	
>  	int index = 0;
>  	
> -	ASSERT ( pred );
> +	assert ( pred );
>  	if ((fd = init_idb ( pred, bywhat, uuname, &tok )) < 0 )
>  		return tok;
>  
> @@ -66,7 +67,7 @@ inv_open( inv_predicate_t bywhat, void *pred )
>  		return INV_TOKEN_NULL;
>  	}
>  
> -	ASSERT ( index > 0 );
> +	assert ( index > 0 );
>  
>  	/* Now we need to make sure that this has enough space */
>  	num = GET_SESCOUNTERS( stobjfd, &sescnt );
> @@ -145,7 +146,7 @@ inv_lasttime_level_lessthan(
>  	time32_t **tm )
>  {
>  	int 	rval;
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  
>  	rval =  search_invt( tok, level, (void **) tm,
>  			 (search_callback_t) tm_level_lessthan );
> @@ -170,7 +171,7 @@ inv_lastsession_level_lessthan(
>  	inv_session_t 	**ses )
>  {
>  	int 	rval;
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  
>  	rval = search_invt( tok, level, (void **) ses, 
>  			  (search_callback_t) lastsess_level_lessthan );
> @@ -197,7 +198,7 @@ inv_lastsession_level_equalto(
>  	inv_session_t	**ses )
>  {
>  	int 	rval;
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  	rval = search_invt( tok, level, (void **) ses, 
>  			  (search_callback_t) lastsess_level_equalto );
>  
> @@ -236,8 +237,8 @@ inv_writesession_open(
>  	invt_seshdr_t  	hdr;
>  	inv_sestoken_t	sestok;
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> -	ASSERT ( sesid && fsid && mntpt && devpath );
> +	assert ( tok != INV_TOKEN_NULL );
> +	assert ( sesid && fsid && mntpt && devpath );
>  
>  	if ( ! ( tok->d_update_flag & FSTAB_UPDATED ) ) {
>  		if ( put_fstab_entry( fsid, mntpt, devpath ) < 0 ) {
> @@ -264,7 +265,7 @@ inv_writesession_open(
>  
>  	fd = tok->d_stobj_fd;
>  	
> -	ASSERT ( fd > 0 );
> +	assert ( fd > 0 );
>  
>  	hdr.sh_time = time;
>  	hdr.sh_level = level;	
> @@ -286,7 +287,7 @@ inv_writesession_open(
>  	/* create the writesession, and get ready for the streams to come 
>  	   afterwards */
>  	rval = create_session( sestok, fd, sescnt, ses, &hdr );
> -	ASSERT (rval > 0);
> +	assert (rval > 0);
>  
>  
>  	INVLOCK( fd, LOCK_UN );
> @@ -324,7 +325,7 @@ inv_writesession_close( inv_sestoken_t tok )
>  {
>  	int		rval;
>  	
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  
>  	/* now update end_time in the inv index header */
>  	rval = put_sesstime( tok, INVT_ENDTIME );
> @@ -354,7 +355,7 @@ inv_stream_open(
>  	invt_seshdr_t  seshdr;
>  	int fd;
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  	 
>  	stream.st_nmediafiles = 0;
>  	stream.st_interrupted = BOOL_FALSE;
> @@ -505,9 +506,9 @@ inv_put_mediafile(
>  	int 		 rval;
>  
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> -	ASSERT ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
> -	ASSERT ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
> +	assert ( tok != INV_TOKEN_NULL );
> +	assert ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
> +	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
>  
>  	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
>  	
> @@ -627,8 +628,8 @@ inv_get_session(
>  	void		      **bufpp,	/* buf to fill */
>  	size_t		       *bufszp )/* size of that buffer */
>  {
> -	ASSERT( tok != INV_TOKEN_NULL );
> -	ASSERT( tok->sd_invtok );
> +	assert( tok != INV_TOKEN_NULL );
> +	assert( tok->sd_invtok );
>  
>  	/* First get the session header, and the session information. Then
>  	   we can figure out how much space to allocate */
> diff --git a/common/lock.c b/common/lock.c
> index ab5b210..347f6cd 100644
> --- a/common/lock.c
> +++ b/common/lock.c
> @@ -18,6 +18,7 @@
>  
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "qlock.h"
> @@ -30,7 +31,7 @@ lock_init( void )
>  {
>  	/* initialization sanity checks
>  	 */
> -	ASSERT( lock_qlockh == QLOCKH_NULL );
> +	assert( lock_qlockh == QLOCKH_NULL );
>  
>  	/* allocate a qlock
>  	 */
> diff --git a/common/main.c b/common/main.c
> index 8e7451f..f392856 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -33,6 +33,7 @@
>  #include <stdint.h>
>  #include <sched.h>
>  #include <pthread.h>
> +#include <assert.h>
>  
>  #include "exit.h"
>  #include "types.h"
> @@ -161,14 +162,14 @@ main( int argc, char *argv[] )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( char_t ) == 1 );
> -	ASSERT( sizeof( u_char_t ) == 1 );
> -	ASSERT( sizeof( int32_t ) == 4 );
> -	ASSERT( sizeof( u_int32_t ) == 4 );
> -	ASSERT( sizeof( size32_t ) == 4 );
> -	ASSERT( sizeof( int64_t ) == 8 );
> -	ASSERT( sizeof( u_int64_t ) == 8 );
> -	ASSERT( sizeof( size64_t ) == 8 );
> +	assert( sizeof( char_t ) == 1 );
> +	assert( sizeof( u_char_t ) == 1 );
> +	assert( sizeof( int32_t ) == 4 );
> +	assert( sizeof( u_int32_t ) == 4 );
> +	assert( sizeof( size32_t ) == 4 );
> +	assert( sizeof( int64_t ) == 8 );
> +	assert( sizeof( u_int64_t ) == 8 );
> +	assert( sizeof( size64_t ) == 8 );
>  
>  	/* record the command name used to invoke
>  	 */
> @@ -365,7 +366,7 @@ main( int argc, char *argv[] )
>  	mlog( MLOG_DEBUG | MLOG_PROC,
>  	      "getpagesize( ) returns %u\n",
>  	      pgsz );
> -	ASSERT( ( intgen_t )pgsz > 0 );
> +	assert( ( intgen_t )pgsz > 0 );
>  	pgmask = pgsz - 1;
>  
>  	/* report parent tid
> @@ -792,7 +793,7 @@ main( int argc, char *argv[] )
>  			mlog_exit_hint(RV_INTR);
>  			stop_in_progress = BOOL_TRUE;
>  			cldmgr_stop( );
> -			ASSERT( stop_timeout >= 0 );
> +			assert( stop_timeout >= 0 );
>  			stop_deadline = now + ( time32_t )stop_timeout;
>  		}
>  		
> @@ -1146,7 +1147,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  				return BOOL_FALSE;
>  			}
>  			optfilename = optarg;
> -			ASSERT( optind > 2 );
> +			assert( optind > 2 );
>  			optfileix = ( ix_t )optind - 2;
>  			break;
>  		}
> @@ -1211,7 +1212,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  	/* allocate an argument buffer
>  	 */
>  	argbuf = ( char * )malloc( sz );
> -	ASSERT( argbuf );
> +	assert( argbuf );
>  
>  	/* copy arg0 (the executable's name ) in first
>  	 */
> @@ -1233,7 +1234,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  		close( fd );
>  		return BOOL_FALSE;
>  	}
> -	ASSERT( ( off64_t )nread == stat.st_size );
> +	assert( ( off64_t )nread == stat.st_size );
>  	p += ( size_t )stat.st_size;
>  	*p++ = ' ';
>  
> @@ -1251,7 +1252,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  	/* null-terminate the entire buffer
>  	 */
>  	*p++ = 0;
> -	ASSERT( ( size_t )( p - argbuf ) <= sz );
> +	assert( ( size_t )( p - argbuf ) <= sz );
>  
>  	/* change newlines and carriage returns into spaces
>  	 */
> @@ -1303,7 +1304,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  	/* allocate a new argv array to hold the tokens
>  	 */
>  	newargv = ( char ** )calloc( tokencnt, sizeof( char * ));
> -	ASSERT( newargv );
> +	assert( newargv );
>  
>  	/* null-terminate tokens and place in new argv, after
>  	 * extracting quotes and escapes
> @@ -1326,7 +1327,7 @@ loadoptfile( intgen_t *argcp, char ***argvp )
>  
>  		/* better not disagree with counting scan!
>  		 */
> -		ASSERT( i < ( intgen_t )tokencnt );
> +		assert( i < ( intgen_t )tokencnt );
>  
>  		/* find the end of the first token
>  		 */
> @@ -1533,7 +1534,7 @@ sigint_dialog( void )
>  			_("\nsession interrupt in progress\n");
>  	}
>  	preamblestr[ preamblecnt++ ] = "\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* top-level query: a function of session interrupt status
> @@ -1541,7 +1542,7 @@ sigint_dialog( void )
>  	querycnt = 0;
>  	querystr[ querycnt++ ] = _("please select one of "
>  				 "the following operations\n");
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	if ( ! stop_in_progress ) {
>  		interruptix = choicecnt;
> @@ -1564,7 +1565,7 @@ sigint_dialog( void )
>  	choicestr[ choicecnt++ ] = _("other controls");
>  	continueix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("continue");
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  
>  	responseix = dlog_multi_query( querystr,
>  				       querycnt,
> @@ -1586,13 +1587,13 @@ sigint_dialog( void )
>  				ackcnt );
>  		querycnt = 0;
>  		querystr[ querycnt++ ] = _("please confirm\n");
> -		ASSERT( querycnt <= QUERYMAX );
> +		assert( querycnt <= QUERYMAX );
>  		choicecnt = 0;
>  		interruptix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("interrupt this session");
>  		nochangeix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("continue");
> -		ASSERT( choicecnt <= CHOICEMAX );
> +		assert( choicecnt <= CHOICEMAX );
>  		responseix = dlog_multi_query( querystr,
>  					       querycnt,
>  					       choicestr,
> @@ -1623,7 +1624,7 @@ sigint_dialog( void )
>  		querycnt = 0;
>  		querystr[ querycnt++ ] = _("please select one of "
>  					 "the following subsystems\n");
> -		ASSERT( querycnt <= QUERYMAX );
> +		assert( querycnt <= QUERYMAX );
>  		choicecnt = 0;
>  		/* number of lines must match number of subsystems
>  		 */
> @@ -1634,7 +1635,7 @@ sigint_dialog( void )
>  		choicestr[ choicecnt++ ] = _("all of the above");
>  		nochangeix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("no change");
> -		ASSERT( choicecnt <= CHOICEMAX );
> +		assert( choicecnt <= CHOICEMAX );
>  		responseix = dlog_multi_query( querystr,
>  					       querycnt,
>  					       choicestr,
> @@ -1664,7 +1665,7 @@ sigint_dialog( void )
>  			querycnt = 0;
>  			querystr[ querycnt++ ] = ("please select one of the "
>  						  "following verbosity levels\n");
> -			ASSERT( querycnt <= QUERYMAX );
> +			assert( querycnt <= QUERYMAX );
>  			choicecnt = 0;
>  			choicestr[ choicecnt++ ] = _("silent");
>  			choicestr[ choicecnt++ ] = _("verbose");
> @@ -1674,7 +1675,7 @@ sigint_dialog( void )
>  			choicestr[ choicecnt++ ] = _("nitty + 1");
>  			nochangeix = choicecnt;
>  			choicestr[ choicecnt++ ] = _("no change");
> -			ASSERT( choicecnt <= CHOICEMAX );
> +			assert( choicecnt <= CHOICEMAX );
>  			responseix = dlog_multi_query( querystr,
>  						       querycnt,
>  						       choicestr,
> @@ -1708,7 +1709,7 @@ sigint_dialog( void )
>  			} else {
>  				if ( ssselected < 0 ) {
>  					ix_t ssix;
> -					ASSERT( ssselected == -1 );
> +					assert( ssselected == -1 );
>  					for ( ssix = 0
>  					      ;
>  					      ssix < MLOG_SS_CNT
> @@ -1734,7 +1735,7 @@ sigint_dialog( void )
>  		querycnt = 0;
>  		querystr[ querycnt++ ] = _("please select one of "
>  					  "the following metrics\n");
> -		ASSERT( querycnt <= QUERYMAX );
> +		assert( querycnt <= QUERYMAX );
>  		choicecnt = 0;
>  		ioix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("I/O");
> @@ -1746,7 +1747,7 @@ sigint_dialog( void )
>  #endif /* RESTORE */
>  		nochangeix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("continue");
> -		ASSERT( choicecnt <= CHOICEMAX );
> +		assert( choicecnt <= CHOICEMAX );
>  		responseix = dlog_multi_query( querystr,
>  					       querycnt,
>  					       choicestr,
> @@ -1779,11 +1780,11 @@ sigint_dialog( void )
>  		if ( responseix != nochangeix ) {
>  			querycnt = 0;
>  			querystr[ querycnt++ ] = "\n";
> -			ASSERT( querycnt <= QUERYMAX );
> +			assert( querycnt <= QUERYMAX );
>  			choicecnt = 0;
>  			nochangeix = choicecnt;
>  			choicestr[ choicecnt++ ] = _("continue");
> -			ASSERT( choicecnt <= CHOICEMAX );
> +			assert( choicecnt <= CHOICEMAX );
>  			responseix = dlog_multi_query( querystr,
>  						       querycnt,
>  						       choicestr,
> @@ -1818,7 +1819,7 @@ sigint_dialog( void )
>  		querycnt = 0;
>  		querystr[ querycnt++ ] = _("please select one of "
>  					   "the following controls\n");
> -		ASSERT( querycnt <= QUERYMAX );
> +		assert( querycnt <= QUERYMAX );
>  		choicecnt = 0;
>  		progix = choicecnt;
>  		if ( progrpt_enabledpr ) {
> @@ -1847,7 +1848,7 @@ sigint_dialog( void )
>  		}
>  		nochangeix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("continue");
> -		ASSERT( choicecnt <= CHOICEMAX );
> +		assert( choicecnt <= CHOICEMAX );
>  		responseix = dlog_multi_query( querystr,
>  					       querycnt,
>  					       choicestr,
> @@ -1898,7 +1899,7 @@ sigint_dialog( void )
>  							sprintf( intervalbuf,
>  								 _("%d seconds\n"),
>  								 newinterval );
> -							ASSERT( strlen( intervalbuf )
> +							assert( strlen( intervalbuf )
>  								<
>  								sizeof( intervalbuf ));
>  							ackstr[ ackcnt++ ] = intervalbuf;
> @@ -1911,7 +1912,7 @@ sigint_dialog( void )
>  						sprintf( intervalbuf,
>  							 _("%d second intervals\n"),
>  							 newinterval );
> -						ASSERT( strlen( intervalbuf )
> +						assert( strlen( intervalbuf )
>  							<
>  							sizeof( intervalbuf ));
>  						ackstr[ ackcnt++ ] = intervalbuf;
> @@ -1966,7 +1967,7 @@ sigint_dialog( void )
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> @@ -2009,7 +2010,7 @@ sigintstr( void )
>  	} else {
>  		sprintf( buf, "%c", intchr );
>  	}
> -	ASSERT( strlen( buf ) < sizeof( buf ));
> +	assert( strlen( buf ) < sizeof( buf ));
>  
>  	return buf;
>  }
> @@ -2030,11 +2031,11 @@ set_rlimits( size64_t *vmszp )
>  	/* REFERENCED */
>  	intgen_t rval;
>  
> -	ASSERT( minstacksz <= maxstacksz );
> +	assert( minstacksz <= maxstacksz );
>  
>  	rval = getrlimit64( RLIMIT_AS, &rlimit64 );
>  
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_AS org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2044,7 +2045,7 @@ set_rlimits( size64_t *vmszp )
>  		rlimit64.rlim_cur = rlimit64.rlim_max;
>  		( void )setrlimit64( RLIMIT_AS, &rlimit64 );
>  		rval = getrlimit64( RLIMIT_AS, &rlimit64 );
> -		ASSERT( ! rval );
> +		assert( ! rval );
>  		mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  			"RLIMIT_VMEM now cur 0x%llx max 0x%llx\n",
>  			rlimit64.rlim_cur,
> @@ -2054,9 +2055,9 @@ set_rlimits( size64_t *vmszp )
>  	vmsz = ( size64_t )rlimit64.rlim_cur;
>  #endif /* RESTORE */
>  	
> -	ASSERT( minstacksz <= maxstacksz );
> +	assert( minstacksz <= maxstacksz );
>  	rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_STACK org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2076,7 +2077,7 @@ set_rlimits( size64_t *vmszp )
>  			rlimit64.rlim_max = minstacksz;
>  			( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
>  			rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
> -			ASSERT( ! rval );
> +			assert( ! rval );
>  			if ( rlimit64.rlim_cur < minstacksz ) {
>  				mlog( MLOG_NORMAL
>  				      |
> @@ -2103,7 +2104,7 @@ set_rlimits( size64_t *vmszp )
>  			rlimit64.rlim_cur = minstacksz;
>  			( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
>  			rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
> -			ASSERT( ! rval );
> +			assert( ! rval );
>  			if ( rlimit64.rlim_cur < minstacksz ) {
>  				mlog( MLOG_NORMAL
>  				      |
> @@ -2131,7 +2132,7 @@ set_rlimits( size64_t *vmszp )
>  		rlimit64.rlim_cur = maxstacksz;
>  		( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
>  		rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
> -		ASSERT( ! rval );
> +		assert( ! rval );
>  		if ( rlimit64.rlim_cur > maxstacksz ) {
>  			mlog( MLOG_NORMAL
>  			      |
> @@ -2152,14 +2153,14 @@ set_rlimits( size64_t *vmszp )
>  	      rlimit64.rlim_max );
>  
>  	rval = getrlimit64( RLIMIT_DATA, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_DATA org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
>  	      rlimit64.rlim_max );
>  	
>  	rval = getrlimit64( RLIMIT_FSIZE, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_FSIZE org cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2169,14 +2170,14 @@ set_rlimits( size64_t *vmszp )
>  	rlimit64.rlim_cur = RLIM64_INFINITY;
>  	( void )setrlimit64( RLIMIT_FSIZE, &rlimit64 );
>  	rval = getrlimit64( RLIMIT_FSIZE, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_FSIZE now cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
>  	      rlimit64.rlim_max );
>  	
>  	rval = getrlimit64( RLIMIT_CPU, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_CPU cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> @@ -2184,7 +2185,7 @@ set_rlimits( size64_t *vmszp )
>  	rlimit64.rlim_cur = rlimit64.rlim_max;
>  	( void )setrlimit64( RLIMIT_CPU, &rlimit64 );
>  	rval = getrlimit64( RLIMIT_CPU, &rlimit64 );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	mlog( MLOG_NITTY | MLOG_NOLOCK | MLOG_PROC,
>  	      "RLIMIT_CPU now cur 0x%llx max 0x%llx\n",
>  	      rlimit64.rlim_cur,
> diff --git a/common/media.c b/common/media.c
> index 4ad7776..53b94d1 100644
> --- a/common/media.c
> +++ b/common/media.c
> @@ -26,6 +26,7 @@
>  #include <sys/dirent.h>
>  #include <stdio.h>
>  #include <getopt.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -91,8 +92,8 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
>  
>  	/* sanity check asserts
>  	 */
> -	ASSERT( sizeof( media_hdr_t ) == MEDIA_HDR_SZ );
> -	ASSERT( MEDIA_MARKLOG_SZ == sizeof( media_marklog_t ));
> +	assert( sizeof( media_hdr_t ) == MEDIA_HDR_SZ );
> +	assert( MEDIA_MARKLOG_SZ == sizeof( media_marklog_t ));
>  
>  	/* scan the command line for a media label
>  	 */
> @@ -143,7 +144,7 @@ media_create( int argc, char *argv[ ], drive_strategy_t *dsp )
>  	 */
>  	mediacnt = dsp->ds_drivecnt;
>  	mediapp = ( media_t ** )calloc( mediacnt, sizeof( media_t * ));
> -	ASSERT( mediapp );
> +	assert( mediapp );
>  	for ( mediaix = 0 ; mediaix < mediacnt ; mediaix++ ) {
>  		mediapp[ mediaix ] = media_alloc( dsp->ds_drivep[ mediaix ],
>  					 	  medialabel );
> @@ -266,7 +267,7 @@ media_alloc( drive_t *drivep,
>  	size_t mwhdrsz;
>  
>  	mediap = ( media_t * )calloc( 1, sizeof( media_t ));
> -	ASSERT( mediap );
> +	assert( mediap );
>  
>  	grhdrp = 0;
>  	gwhdrp = 0;
> @@ -279,12 +280,12 @@ media_alloc( drive_t *drivep,
>  			      &gwhdrp,
>  			      ( char ** )&mwhdrp,
>  			      &mwhdrsz );
> -	ASSERT( grhdrp );
> -	ASSERT( gwhdrp );
> -	ASSERT( mrhdrp );
> -	ASSERT( mwhdrp );
> -	ASSERT( mrhdrsz == MEDIA_HDR_SZ );
> -	ASSERT( mwhdrsz == MEDIA_HDR_SZ );
> +	assert( grhdrp );
> +	assert( gwhdrp );
> +	assert( mrhdrp );
> +	assert( mwhdrp );
> +	assert( mrhdrsz == MEDIA_HDR_SZ );
> +	assert( mwhdrsz == MEDIA_HDR_SZ );
>  
>  	mediap->m_greadhdrp = grhdrp;
>  	mediap->m_gwritehdrp = gwhdrp;
> diff --git a/common/mlog.c b/common/mlog.c
> index b0135b9..c546036 100644
> --- a/common/mlog.c
> +++ b/common/mlog.c
> @@ -27,6 +27,7 @@
>  #include <time.h>
>  #include <getopt.h>
>  #include <pthread.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "qlock.h"
> @@ -157,9 +158,9 @@ mlog_init1( intgen_t argc, char *argv[ ] )
>  	vsymcnt = sizeof( mlog_sym ) / sizeof( mlog_sym[ 0 ] );
>  	suboptstrs = ( char ** )calloc( MLOG_SS_CNT + vsymcnt + 1,
>  					sizeof( char * ));
> -	ASSERT( suboptstrs );
> +	assert( suboptstrs );
>  	for ( soix = 0 ; soix < MLOG_SS_CNT ; soix++ ) {
> -		ASSERT( strlen( mlog_ss_names[ soix ] ) <= MLOG_SS_NAME_MAX );
> +		assert( strlen( mlog_ss_names[ soix ] ) <= MLOG_SS_NAME_MAX );
>  			/* unrelated, but opportunity to chk */
>  		suboptstrs[ soix ] = mlog_ss_names[ soix ];
>  	}
> @@ -210,7 +211,7 @@ mlog_init1( intgen_t argc, char *argv[ ] )
>  					usage( );
>  					return BOOL_FALSE;
>  				}
> -				ASSERT( ( ix_t )suboptix
> +				assert( ( ix_t )suboptix
>  					<
>  					MLOG_SS_CNT + vsymcnt );
>  				if ( suboptix < MLOG_SS_CNT ) {
> @@ -273,8 +274,8 @@ mlog_init1( intgen_t argc, char *argv[ ] )
>  	 */
>  	for ( ssix = 0 ; ssix < MLOG_SS_CNT ; ssix++ ) {
>  		if ( mlog_level_ss[ ssix ] < 0 ) {
> -			ASSERT( mlog_level_ss[ ssix ] == -1 );
> -			ASSERT( mlog_level_ss[ MLOG_SS_GEN ] >= 0 );
> +			assert( mlog_level_ss[ ssix ] == -1 );
> +			assert( mlog_level_ss[ MLOG_SS_GEN ] >= 0 );
>  			mlog_level_ss[ ssix ] = mlog_level_ss[ MLOG_SS_GEN ];
>  		}
>  	}
> @@ -375,7 +376,7 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
>  	level = levelarg & MLOG_LEVELMASK;
>  	ss = ( ix_t )( ( levelarg & MLOG_SS_MASK ) >> MLOG_SS_SHIFT );
>  
> -	ASSERT( ss < MLOG_SS_CNT );
> +	assert( ss < MLOG_SS_CNT );
>  	if ( level > mlog_level_ss[ ss ] ) {
>  		return;
>  	}
> @@ -402,7 +403,7 @@ mlog_va( intgen_t levelarg, char *fmt, va_list args )
>  				 tmp->tm_hour,
>  				 tmp->tm_min,
>  				 tmp->tm_sec );
> -			ASSERT( strlen( mlog_tsstr ) < sizeof( mlog_tsstr ));
> +			assert( strlen( mlog_tsstr ) < sizeof( mlog_tsstr ));
>  		} else {
>  			mlog_tsstr[ 0 ] = 0;
>  		}
> @@ -676,7 +677,7 @@ mlog_get_hint( void )
>  
>  	ok = stream_get_exit_status(pthread_self(), states, N(states),
>  				    NULL, NULL, NULL, NULL, &hint);
> -	ASSERT(ok);
> +	assert(ok);
>  	return hint;
>  }
>  
> @@ -736,7 +737,7 @@ mlog_exit_flush(void)
>  						    &exit_code,
>  						    &exit_return,
>  						    &exit_hint);
> -			ASSERT(ok);
> +			assert(ok);
>  
>  			/* hint takes priority over return */
>  			rv = (exit_hint != RV_NONE) ? exit_hint : exit_return;
> @@ -771,7 +772,7 @@ mlog_exit_flush(void)
>  	else if (IS_INCOMPLETE(rv)) incomplete = BOOL_TRUE;
>  
>  	/* if we don't have an exit code here there is a problem */
> -	ASSERT(VALID_EXIT_CODE(mlog_main_exit_code));
> +	assert(VALID_EXIT_CODE(mlog_main_exit_code));
>  	if (interrupt) status_str = "INTERRUPT";
>  	else if (quit) status_str = "QUIT";
>  	else if (incomplete) status_str = "INCOMPLETE";
> diff --git a/common/openutil.c b/common/openutil.c
> index 9a88d67..c3b8d9a 100644
> --- a/common/openutil.c
> +++ b/common/openutil.c
> @@ -22,6 +22,7 @@
>  #include <limits.h>
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -56,7 +57,7 @@ open_pathalloc( char *dirname, char *basename, pid_t pid )
>    	}
>  	namelen = dirlen + 1 + strlen( basename ) + pidlen + 1;
>  	namebuf = ( char * )calloc( 1, namelen );
> -  	ASSERT( namebuf );
> +  	assert( namebuf );
>  
>    	if ( pid ) {
>  		( void )snprintf( namebuf, namelen, "%s/%s.%d", dirname, basename, pid );
> diff --git a/common/path.c b/common/path.c
> index ca24f6a..e40c473 100644
> --- a/common/path.c
> +++ b/common/path.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <xfs/xfs.h>
> +#include <assert.h>
>  
>  #include "path.h"
>  
> @@ -51,8 +52,8 @@ path_diff( char *path, char *base )
>  {
>  	char *diff;
>  
> -	ASSERT( *base == '/' );
> -	ASSERT( *path == '/' );
> +	assert( *base == '/' );
> +	assert( *path == '/' );
>  
>  	if ( ! path_beginswith( path, base )) {
>  		return 0;
> @@ -70,7 +71,7 @@ path_diff( char *path, char *base )
>  	}
>  
>  	diff = ( char * )calloc( 1, strlen( path ) + 1 );
> -	ASSERT( diff );
> +	assert( diff );
>  	strcpy( diff, path );
>  
>  	return diff;
> @@ -102,7 +103,7 @@ path_reltoabs( char *dir, char *basedir )
>  					   strlen( dir )
>  					   +
>  					   1 );
> -		ASSERT( absdir );
> +		assert( absdir );
>  
>  		( void )sprintf( absdir, "%s/%s", basedir, dir );
>  
> @@ -127,7 +128,7 @@ path_normalize( char *path )
>  	char *pep;
>  	char *npath;
>  
> -	ASSERT( path[ 0 ] == '/' );
> +	assert( path[ 0 ] == '/' );
>  
>  	while ( ( pep = pem_next( pemp )) != 0 ) {
>  		if ( ! strcmp( pep, "" )) {
> @@ -163,7 +164,7 @@ static pem_t *
>  pem_alloc( char *path )
>  {
>  	pem_t *pemp = ( pem_t * )calloc( 1, sizeof( pem_t ));
> -	ASSERT( pemp );
> +	assert( pemp );
>  	pemp->pem_head = path;
>  	pemp->pem_next = pemp->pem_head;
>  
> @@ -207,7 +208,7 @@ pem_next( pem_t *pemp )
>  	/* allocate buffer to hold the path element, incl null termination
>  	 */
>  	p = ( char * )malloc( len + 1 );
> -	ASSERT( p );
> +	assert( p );
>  
>  	/* copy the path element into the buffer
>  	 */
> @@ -230,7 +231,7 @@ static pa_t *
>  pa_alloc( void )
>  {
>  	pa_t *pap = ( pa_t * )calloc( 1, sizeof( pa_t ));
> -	ASSERT( pap );
> +	assert( pap );
>  
>  	return pap;
>  }
> @@ -250,7 +251,7 @@ pa_free( pa_t *pap )
>  static void
>  pa_append( pa_t *pap, char *pep )
>  {
> -	ASSERT( pap->pa_cnt < PAMAX );
> +	assert( pap->pa_cnt < PAMAX );
>  
>  	pap->pa_array[ pap->pa_cnt ] = pep;
>  
> @@ -261,12 +262,12 @@ static int
>  pa_peel( pa_t *pap )
>  {
>  	if ( pap->pa_cnt <= 0 ) {
> -		ASSERT( pap->pa_cnt == 0 );
> +		assert( pap->pa_cnt == 0 );
>  		return 0;
>  	}
>  
>  	pap->pa_cnt--;
> -	ASSERT( pap->pa_array[ pap->pa_cnt ] );
> +	assert( pap->pa_array[ pap->pa_cnt ] );
>  	free( ( void * )pap->pa_array[ pap->pa_cnt ] );
>  	pap->pa_array[ pap->pa_cnt ] = 0;
>  
> @@ -292,7 +293,7 @@ pa_gen( pa_t *pap )
>  	retp = ( char * )malloc( sz );
>  
>  	if (  pap->pa_cnt <= 0 ) {
> -		ASSERT(  pap->pa_cnt == 0 );
> +		assert(  pap->pa_cnt == 0 );
>  		sprintf( retp, "/" );
>  	} else {
>  		p = retp;
> diff --git a/common/qlock.c b/common/qlock.c
> index ae8466d..d88917c 100644
> --- a/common/qlock.c
> +++ b/common/qlock.c
> @@ -21,6 +21,7 @@
>  
>  #include <pthread.h>
>  #include <semaphore.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "qlock.h"
> @@ -78,13 +79,13 @@ qlock_alloc( ix_t ord )
>  
>  	/* verify the ordinal is not already taken, and mark as taken
>  	 */
> -	ASSERT( ! QLOCK_ORDMAP_GET( qlock_ordalloced, ord ));
> +	assert( ! QLOCK_ORDMAP_GET( qlock_ordalloced, ord ));
>  	QLOCK_ORDMAP_SET( qlock_ordalloced, ord );
>  
>  	/* allocate lock memory
>  	 */
>  	qlockp = ( qlock_t * )calloc( 1, sizeof( qlock_t ));
> -	ASSERT( qlockp );
> +	assert( qlockp );
>  
>  	/* initialize the mutex
>  	 */
> @@ -118,7 +119,7 @@ qlock_lock( qlockh_t qlockh )
>  		      qlockp->ql_ord,
>  		      thread_ordmap );
>  	}
> -	ASSERT( ! QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
> +	assert( ! QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
>  
>  	/* assert that no locks with a lesser ordinal are held by this thread
>  	 */
> @@ -129,12 +130,12 @@ qlock_lock( qlockh_t qlockh )
>  		      qlockp->ql_ord,
>  		      thread_ordmap );
>  	}
> -	ASSERT( ! QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord ));
> +	assert( ! QLOCK_ORDMAP_CHK( thread_ordmap, qlockp->ql_ord ));
>  
>  	/* acquire the lock
>  	 */
>  	rval = pthread_mutex_lock( &qlockp->ql_mutex );
> -	ASSERT( !rval );
> +	assert( !rval );
>  
>  	/* add ordinal to this threads ordmap
>  	 */
> @@ -150,7 +151,7 @@ qlock_unlock( qlockh_t qlockh )
>  	
>  	/* verify lock is held by this thread
>  	 */
> -	ASSERT( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
> +	assert( QLOCK_ORDMAP_GET( thread_ordmap, qlockp->ql_ord ));
>  
>  	/* clear lock's ord from thread's ord map
>  	 */
> @@ -159,7 +160,7 @@ qlock_unlock( qlockh_t qlockh )
>  	/* release the lock
>  	 */
>  	rval = pthread_mutex_unlock( &qlockp->ql_mutex );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  }
>  
>  qsemh_t
> @@ -171,12 +172,12 @@ qsem_alloc( ix_t cnt )
>  	/* allocate a semaphore
>  	 */
>  	semp = ( sem_t * )calloc( 1, sizeof( sem_t ));
> -	ASSERT( semp );
> +	assert( semp );
>  
>  	/* initialize the semaphore
>  	 */
>  	rval = sem_init( semp, 0, cnt );
> -	ASSERT( !rval );
> +	assert( !rval );
>  
>  	return ( qsemh_t )semp;
>  }
> @@ -190,7 +191,7 @@ qsem_free( qsemh_t qsemh )
>  	/* destroy the mutex and condition
>  	 */
>  	rval = sem_destroy( semp );
> -	ASSERT( !rval );
> +	assert( !rval );
>  
>  	/* free the semaphore
>  	 */
> @@ -206,7 +207,7 @@ qsemP( qsemh_t qsemh )
>  	/* "P" the semaphore
>  	 */
>  	rval = sem_wait( semp );
> -	ASSERT( !rval );
> +	assert( !rval );
>  }
>  
>  void
> @@ -218,7 +219,7 @@ qsemV( qsemh_t qsemh )
>  	/* "V" the semaphore
>  	 */
>  	rval = sem_post( semp );
> -	ASSERT( !rval );
> +	assert( !rval );
>  }
>  
>  bool_t
> @@ -229,7 +230,7 @@ qsemPwouldblock( qsemh_t qsemh )
>  	intgen_t rval;
>  
>  	rval = sem_getvalue( semp, &count );
> -	ASSERT( !rval );
> +	assert( !rval );
>  
>  	return count <= 0 ? BOOL_TRUE : BOOL_FALSE;
>  }
> @@ -242,7 +243,7 @@ qsemPavail( qsemh_t qsemh )
>  	intgen_t rval;
>  
>  	rval = sem_getvalue( semp, &count );
> -	ASSERT( !rval );
> +	assert( !rval );
>  
>  	return count < 0 ? 0 : count;
>  }
> diff --git a/common/ring.c b/common/ring.c
> index 0d2feb0..f3de7c4 100644
> --- a/common/ring.c
> +++ b/common/ring.c
> @@ -27,6 +27,7 @@
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <malloc.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "qlock.h"
> @@ -56,7 +57,7 @@ ring_create( size_t ringlen,
>  	/* allocate a ring descriptor
>  	 */
>  	ringp = ( ring_t * )calloc( 1, sizeof( ring_t ));
> -	ASSERT( ringp );
> +	assert( ringp );
>  	ringp->r_len = ringlen;
>  	ringp->r_clientctxp = clientctxp;
>  	ringp->r_readfunc = readfunc;
> @@ -86,7 +87,7 @@ ring_create( size_t ringlen,
>  	/* allocate the ring messages
>  	 */
>  	ringp->r_msgp = ( ring_msg_t * )calloc( ringlen, sizeof( ring_msg_t ));
> -	ASSERT( ringp->r_msgp );
> +	assert( ringp->r_msgp );
>  
>  	/* allocate the buffers and initialize the messages
>  	 */
> @@ -115,7 +116,7 @@ ring_create( size_t ringlen,
>  					*rvalp = EPERM;
>  					return 0;
>  				}
> -				ASSERT( 0 );
> +				assert( 0 );
>  			}
>  		}
>  	}
> @@ -126,7 +127,7 @@ ring_create( size_t ringlen,
>  			    drive_index,
>  			    _("slave"),
>  			    ringp );
> -	ASSERT( ok );
> +	assert( ok );
>  
>  	return ringp;
>  }
> @@ -138,7 +139,7 @@ ring_get( ring_t *ringp )
>  
>  	/* assert client currently holds no messages
>  	 */
> -	ASSERT( ringp->r_client_cnt == 0 );
> +	assert( ringp->r_client_cnt == 0 );
>  
>  	/* bump client message count and note if client needs to block
>  	 */
> @@ -157,11 +158,11 @@ ring_get( ring_t *ringp )
>  
>  	/* assert the message is where it belongs
>  	 */
> -	ASSERT( msgp->rm_loc == RING_LOC_READY );
> +	assert( msgp->rm_loc == RING_LOC_READY );
>  
>  	/* verify the message index has not become corrupted
>  	 */
> -	ASSERT( msgp->rm_mix == ringp->r_ready_out_ix );
> +	assert( msgp->rm_mix == ringp->r_ready_out_ix );
>  
>  	/* bump the output index
>  	 */
> @@ -187,15 +188,15 @@ ring_put( ring_t *ringp, ring_msg_t *msgp )
>  {
>  	/* assert the client holds exactly one message
>  	 */
> -	ASSERT( ringp->r_client_cnt == 1 );
> +	assert( ringp->r_client_cnt == 1 );
>  
>  	/* assert the client is returning the right message
>  	 */
> -	ASSERT( msgp->rm_mix == ringp->r_active_in_ix );
> +	assert( msgp->rm_mix == ringp->r_active_in_ix );
>  
>  	/* assert the message is where it belongs
>  	 */
> -	ASSERT( msgp->rm_loc == RING_LOC_CLIENT );
> +	assert( msgp->rm_loc == RING_LOC_CLIENT );
>  
>  	/* decrement the count of messages held by the client
>  	 */
> @@ -224,13 +225,13 @@ ring_reset( ring_t *ringp, ring_msg_t *msgp )
>  	/* if the client is not holding a message, get the next message
>  	 */
>  	if ( ringp->r_client_cnt == 0 ) {
> -		ASSERT( ! msgp );
> +		assert( ! msgp );
>  		msgp = ring_get( ringp );
> -		ASSERT( msgp );
> -		ASSERT( ringp->r_client_cnt == 1 );
> +		assert( msgp );
> +		assert( ringp->r_client_cnt == 1 );
>  	} else {
> -		ASSERT( msgp );
> -		ASSERT( ringp->r_client_cnt == 1 );
> +		assert( msgp );
> +		assert( ringp->r_client_cnt == 1 );
>  	}
>  
>  	/* tell the slave to abort
> @@ -240,24 +241,24 @@ ring_reset( ring_t *ringp, ring_msg_t *msgp )
>  
>  	/* wait for the reset to be acknowledged
>  	 */
> -	ASSERT( ringp->r_client_cnt == 0 );
> +	assert( ringp->r_client_cnt == 0 );
>  	do {
>  		/* pull a message from the ready queue
>  		 */
>  		qsemP( ringp->r_ready_qsemh );
>  		msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
> -		ASSERT( msgp->rm_loc == RING_LOC_READY );
> +		assert( msgp->rm_loc == RING_LOC_READY );
>  		ringp->r_ready_out_ix = ( ringp->r_ready_out_ix + 1 )
>  					%
>  					ringp->r_len;
>  		ringp->r_client_cnt++;
>  	} while ( msgp->rm_stat != RING_STAT_RESETACK );
> -	ASSERT( ringp->r_client_cnt == ringp->r_len );
> +	assert( ringp->r_client_cnt == ringp->r_len );
>  
>  	/* re-initialize the ring
>  	 */
> -	ASSERT( qsemPavail( ringp->r_ready_qsemh ) == 0 );
> -	ASSERT( qsemPavail( ringp->r_active_qsemh ) == 0 );
> +	assert( qsemPavail( ringp->r_ready_qsemh ) == 0 );
> +	assert( qsemPavail( ringp->r_active_qsemh ) == 0 );
>  	ringp->r_ready_in_ix = 0;
>  	ringp->r_ready_out_ix = 0;
>  	ringp->r_active_in_ix = 0;
> @@ -273,8 +274,8 @@ ring_reset( ring_t *ringp, ring_msg_t *msgp )
>  		msgp->rm_loc = RING_LOC_READY;
>  		qsemV( ringp->r_ready_qsemh );
>  	}
> -	ASSERT( qsemPavail( ringp->r_ready_qsemh ) == ringp->r_len );
> -	ASSERT( qsemPavail( ringp->r_active_qsemh ) == 0 );
> +	assert( qsemPavail( ringp->r_ready_qsemh ) == ringp->r_len );
> +	assert( qsemPavail( ringp->r_active_qsemh ) == 0 );
>  }
>  
>  void
> @@ -284,7 +285,7 @@ ring_destroy( ring_t *ringp )
>  
>  	/* the client must not be holding a message
>  	 */
> -	ASSERT( ringp->r_client_cnt == 0 );
> +	assert( ringp->r_client_cnt == 0 );
>  
>  	/* get a message
>  	 */
> @@ -302,7 +303,7 @@ ring_destroy( ring_t *ringp )
>  		 */
>  		qsemP( ringp->r_ready_qsemh );
>  		msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
> -		ASSERT( msgp->rm_loc == RING_LOC_READY );
> +		assert( msgp->rm_loc == RING_LOC_READY );
>  		ringp->r_ready_out_ix = ( ringp->r_ready_out_ix + 1 )
>  					%
>  					ringp->r_len;
> @@ -323,7 +324,7 @@ ring_slave_get( ring_t *ringp )
>  
>  	/* assert slave currently holds no messages
>  	 */
> -	ASSERT( ringp->r_slave_cnt == 0 );
> +	assert( ringp->r_slave_cnt == 0 );
>  
>  	/* bump slave message count and note if slave needs to block
>  	 */
> @@ -342,11 +343,11 @@ ring_slave_get( ring_t *ringp )
>  
>  	/* assert the message is where it belongs
>  	 */
> -	ASSERT( msgp->rm_loc == RING_LOC_ACTIVE );
> +	assert( msgp->rm_loc == RING_LOC_ACTIVE );
>  
>  	/* verify the message index has not become corrupted
>  	 */
> -	ASSERT( msgp->rm_mix == ringp->r_active_out_ix );
> +	assert( msgp->rm_mix == ringp->r_active_out_ix );
>  
>  	/* bump the output index
>  	 */
> @@ -372,15 +373,15 @@ ring_slave_put( ring_t *ringp, ring_msg_t *msgp )
>  {
>  	/* assert the slave holds exactly one message
>  	 */
> -	ASSERT( ringp->r_slave_cnt == 1 );
> +	assert( ringp->r_slave_cnt == 1 );
>  
>  	/* assert the slave is returning the right message
>  	 */
> -	ASSERT( msgp->rm_mix == ringp->r_ready_in_ix );
> +	assert( msgp->rm_mix == ringp->r_ready_in_ix );
>  
>  	/* assert the message is where it belongs
>  	 */
> -	ASSERT( msgp->rm_loc == RING_LOC_SLAVE );
> +	assert( msgp->rm_loc == RING_LOC_SLAVE );
>  
>  	/* decrement the count of messages held by the slave
>  	 */
> @@ -435,7 +436,7 @@ ring_slave_entry( void *ringctxp )
>  			}
>  			if ( ! ringp->r_first_io_time ) {
>  				ringp->r_first_io_time = time( 0 );
> -				ASSERT( ringp->r_first_io_time );
> +				assert( ringp->r_first_io_time );
>  			}
>  			rval = ( ringp->r_readfunc )( ringp->r_clientctxp,
>  						      msgp->rm_bufp );
> @@ -455,7 +456,7 @@ ring_slave_entry( void *ringctxp )
>  			}
>  			if ( ! ringp->r_first_io_time ) {
>  				ringp->r_first_io_time = time( 0 );
> -				ASSERT( ringp->r_first_io_time );
> +				assert( ringp->r_first_io_time );
>  			}
>  			rval = ( ringp->r_writefunc )( ringp->r_clientctxp,
>  						       msgp->rm_bufp );
> diff --git a/common/stream.c b/common/stream.c
> index 6704661..0db1be3 100644
> --- a/common/stream.c
> +++ b/common/stream.c
> @@ -20,6 +20,7 @@
>  #include <xfs/jdm.h>
>  
>  #include <pthread.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "exit.h"
> @@ -65,7 +66,7 @@ stream_register( pthread_t tid, intgen_t streamix )
>  	spm_t *p = spm;
>  	spm_t *ep = spm + N(spm);
>  
> -	ASSERT( streamix < STREAM_SIMMAX );
> +	assert( streamix < STREAM_SIMMAX );
>  
>  	lock();
>  	for ( ; p < ep ; p++ ) {
> @@ -75,7 +76,7 @@ stream_register( pthread_t tid, intgen_t streamix )
>  		}
>  	}
>  	unlock();
> -	ASSERT( p < ep );
> +	assert( p < ep );
>  
>  	if ( p >= ep ) return;
>  
> @@ -98,7 +99,7 @@ stream_dead( pthread_t tid )
>  			p->s_state = S_ZOMBIE;
>  			break;
>  		}
> -	ASSERT( p < ep );
> +	assert( p < ep );
>  }
>  
>  void
> @@ -116,7 +117,7 @@ stream_free( pthread_t tid )
>  		}
>  	}
>  	unlock();
> -	ASSERT( p < ep );
> +	assert( p < ep );
>  }
>  
>  int
> @@ -126,7 +127,7 @@ stream_find_all( stream_state_t states[], int nstates,
>  	int i, count = 0;
>  	spm_t *p = spm;
>  	spm_t *ep = spm + N(spm);
> -	ASSERT(nstates > 0 && ntids > 0);
> +	assert(nstates > 0 && ntids > 0);
>  
>  	if (!initialized)
>  		return 0;
> @@ -150,7 +151,7 @@ stream_find( pthread_t tid, stream_state_t s[], int nstates )
>  	spm_t *p = spm;
>  	spm_t *ep = spm + N(spm);
>  
> -	ASSERT(nstates > 0);
> +	assert(nstates > 0);
>  
>  	/* note we don't lock the stream array in this function */
>  	for ( ; p < ep ; p++ )
> @@ -275,7 +276,7 @@ stream_cnt( void )
>  	size_t ixcnt;
>  	size_t bitix;
>  
> -	ASSERT( sizeof( ixmap ) * NBBY >= STREAM_SIMMAX );
> +	assert( sizeof( ixmap ) * NBBY >= STREAM_SIMMAX );
>  	
>  	lock();
>  	for ( ; p < ep ; p++ ) {
> diff --git a/common/util.c b/common/util.c
> index 73f18fe..1dc6d6c 100644
> --- a/common/util.c
> +++ b/common/util.c
> @@ -25,6 +25,7 @@
>  #include <fcntl.h>
>  #include <errno.h>
>  #include <dirent.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -46,9 +47,9 @@ write_buf( char *bufp,
>  	while ( bufsz ) {
>  		int rval;
>  
> -		ASSERT( bufsz > 0 );
> +		assert( bufsz > 0 );
>  		mbufp = ( *get_write_buf_funcp )( contextp, bufsz, &mbufsz );
> -		ASSERT( mbufsz <= bufsz );
> +		assert( mbufsz <= bufsz );
>  		if ( bufp ) {
>  			(void)memcpy( ( void * )mbufp, ( void * )bufp, mbufsz );
>  		} else {
> @@ -86,7 +87,7 @@ read_buf( char *bufp,
>  		if ( *statp ) {
>  			break;
>  		}
> -		ASSERT( mbufsz <= bufsz );
> +		assert( mbufsz <= bufsz );
>  		if ( bufp ) {
>  			( void )memcpy( (void *)bufp, (void *)mbufp, mbufsz );
>  			bufp += mbufsz;
> @@ -255,7 +256,7 @@ bigstat_one( intgen_t fsfd,
>          xfs_fsop_bulkreq_t bulkreq;
>  	intgen_t count = 0;
>  
> -	ASSERT( ino > 0 );
> +	assert( ino > 0 );
>          bulkreq.lastip = (__u64 *)&ino;
>          bulkreq.icount = 1;
>          bulkreq.ubuffer = statp;
> @@ -354,13 +355,13 @@ diriter( jdm_fshandle_t *fshandlep,
>  	intgen_t cbrval;
>  
>  	if ( usrgdp ) {
> -		ASSERT( usrgdsz >= sizeof( struct dirent ) );
> +		assert( usrgdsz >= sizeof( struct dirent ) );
>  		gdsz = usrgdsz;
>  		gdp = ( struct dirent * )usrgdp;
>  	} else {
>  		gdsz = pgsz;
>  		gdp = ( struct dirent * )malloc( gdsz );
> -		ASSERT( gdp );
> +		assert( gdp );
>  	}
>  
>  	/* open the directory
> @@ -377,7 +378,7 @@ diriter( jdm_fshandle_t *fshandlep,
>  		}
>  		return -1;
>  	}
> -	ASSERT( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
> +	assert( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
>  
>  	/* lots of buffering done here, to achieve OS-independence.
>  	 * if proves to be to much overhead, can streamline.
> @@ -389,8 +390,8 @@ diriter( jdm_fshandle_t *fshandlep,
>  		intgen_t nread;
>  		register size_t reclen;
>  
> -		ASSERT( scrval == 0 );
> -		ASSERT( cbrval == 0 );
> +		assert( scrval == 0 );
> +		assert( cbrval == 0 );
>  
>  		nread = getdents_wrap( fd, (char *)gdp, gdsz );
>  		
> @@ -421,12 +422,12 @@ diriter( jdm_fshandle_t *fshandlep,
>  		      nread > 0
>  		      ;
>  		      nread -= ( intgen_t )reclen,
> -		      ASSERT( nread >= 0 ),
> +		      assert( nread >= 0 ),
>  		      p = ( struct dirent * )( ( char * )p + reclen ),
>  		      reclen = ( size_t )p->d_reclen ) {
>  			xfs_bstat_t statbuf;
> -			ASSERT( scrval == 0 );
> -			ASSERT( cbrval == 0 );
> +			assert( scrval == 0 );
> +			assert( cbrval == 0 );
>  
>  			/* skip "." and ".."
>  			 */
> @@ -538,7 +539,7 @@ fold_init( fold_t fold, char *infostr, char c )
>  	char *endp;
>  	ix_t cnt;
>  
> -	ASSERT( sizeof( fold_t ) == FOLD_LEN + 1 );
> +	assert( sizeof( fold_t ) == FOLD_LEN + 1 );
>  
>  	infolen = strlen( infostr );
>  	if ( infolen > FOLD_LEN - 4 ) {
> @@ -551,23 +552,23 @@ fold_init( fold_t fold, char *infostr, char c )
>  	p = &fold[ 0 ];
>  	endp = &fold[ sizeof( fold_t ) - 1 ];
>  
> -	ASSERT( p < endp );
> +	assert( p < endp );
>  	*p++ = ' ';
>  	for ( cnt = 0 ; cnt < predashlen && p < endp ; cnt++, p++ ) {
>  		*p = c;
>  	}
> -	ASSERT( p < endp );
> +	assert( p < endp );
>  	*p++ = ' ';
> -	ASSERT( p < endp );
> -	ASSERT( p + infolen < endp );
> +	assert( p < endp );
> +	assert( p + infolen < endp );
>  	strcpy( p, infostr );
>  	p += infolen;
> -	ASSERT( p < endp );
> +	assert( p < endp );
>  	*p++ = ' ';
> -	ASSERT( p < endp );
> +	assert( p < endp );
>  	for ( cnt = 0 ; cnt < postdashlen && p < endp ; cnt++, p++ ) {
>  		*p = c;
>  	}
> -	ASSERT( p <= endp );
> +	assert( p <= endp );
>  	*p = 0;
>  }
> diff --git a/dump/content.c b/dump/content.c
> index 5f7b4d9..3682358 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -30,6 +30,7 @@
>  #include <sys/ioctl.h>
>  #include <sys/quota.h>
>  #include <malloc.h>
> +#include <assert.h>
>  
>  #ifdef linux
>  #include <xfs/xqm.h>
> @@ -559,18 +560,18 @@ content_init( intgen_t argc,
>  
>  	/* basic sanity checks
>  	 */
> -	ASSERT( sizeof( mode_t ) == MODE_SZ );
> -	ASSERT( sizeof( timestruct_t ) == TIMESTRUCT_SZ );
> -	ASSERT( sizeof( bstat_t ) == BSTAT_SZ );
> -	ASSERT( sizeof( filehdr_t ) == FILEHDR_SZ );
> -	ASSERT( sizeof( extenthdr_t ) == EXTENTHDR_SZ );
> -	ASSERT( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
> -	ASSERT( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
> -	ASSERT( DIRENTHDR_SZ % DIRENTHDR_ALIGN == 0 );
> -	ASSERT( sizeofmember( content_hdr_t, ch_specific )
> +	assert( sizeof( mode_t ) == MODE_SZ );
> +	assert( sizeof( timestruct_t ) == TIMESTRUCT_SZ );
> +	assert( sizeof( bstat_t ) == BSTAT_SZ );
> +	assert( sizeof( filehdr_t ) == FILEHDR_SZ );
> +	assert( sizeof( extenthdr_t ) == EXTENTHDR_SZ );
> +	assert( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
> +	assert( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
> +	assert( DIRENTHDR_SZ % DIRENTHDR_ALIGN == 0 );
> +	assert( sizeofmember( content_hdr_t, ch_specific )
>  		>=
>  		sizeof( content_inode_hdr_t ));
> -	ASSERT( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
> +	assert( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
>  
>  	/* calculate offsets of portions of the write hdr template
>  	 */
> @@ -737,20 +738,20 @@ content_init( intgen_t argc,
>  	 */
>  	if ( subtreecnt ) {
>  		subtreep = ( char ** )calloc( subtreecnt, sizeof( char * ));
> -		ASSERT( subtreep );
> +		assert( subtreep );
>  		optind = 1;
>  		opterr = 0;
>  		subtreeix = 0;
>  		while ( ( c = getopt( argc, argv, GETOPT_CMDSTRING )) != EOF ) {
>  			switch ( c ) {
>  			case GETOPT_SUBTREE:
> -				ASSERT( subtreeix < subtreecnt );
> -				ASSERT( optarg && optarg[ 0 ] != '-' );
> +				assert( subtreeix < subtreecnt );
> +				assert( optarg && optarg[ 0 ] != '-' );
>  				subtreep[ subtreeix++ ] = optarg;
>  				break;
>  			}
>  		}
> -		ASSERT( subtreeix == subtreecnt );
> +		assert( subtreeix == subtreecnt );
>  	} else {
>  		subtreep = 0;
>  	}
> @@ -900,7 +901,7 @@ content_init( intgen_t argc,
>  			sc_resumerangecnt =  ( size_t )sessp->s_nstreams;
>  			sc_resumerangep = ( drange_t * )calloc( sc_resumerangecnt,
>  								sizeof( drange_t ));
> -			ASSERT( sc_resumerangep );
> +			assert( sc_resumerangep );
>  			for ( strmix = 0 ; strmix < sc_resumerangecnt ; strmix++ ) {
>  				inv_stream_t *bsp;
>  				inv_stream_t *esp;
> @@ -966,7 +967,7 @@ content_init( intgen_t argc,
>  		inv_free_session( &sessp );
>  		sessp = 0;
>  		ok = inv_close( inv_idbt );
> -		ASSERT( ok );
> +		assert( ok );
>  		inv_idbt = INV_TOKEN_NULL;
>  		goto baseuuidbypass;
>  	}
> @@ -1028,7 +1029,7 @@ content_init( intgen_t argc,
>  						   (u_char_t)sc_level,
>  						   &sessp);
>  		ok1 = inv_close( inv_idbt );
> -		ASSERT( ok1 );
> +		assert( ok1 );
>  		if ( ! ok ) {
>  			sessp = 0;
>  		}
> @@ -1046,7 +1047,7 @@ content_init( intgen_t argc,
>  		sc_resumerangecnt =  ( size_t )sessp->s_nstreams;
>  		sc_resumerangep = ( drange_t * )calloc( sc_resumerangecnt,
>  						        sizeof( drange_t ));
> -		ASSERT( sc_resumerangep );
> +		assert( sc_resumerangep );
>  		for ( strmix = 0 ; strmix < sc_resumerangecnt ; strmix++ ) {
>  			inv_stream_t *bsp;
>  			inv_stream_t *esp;
> @@ -1119,8 +1120,8 @@ baseuuidbypass:
>  		samefoundpr = BOOL_FALSE;
>  	}
>  	if ( underfoundpr ) {
> -		ASSERT( underlevel <= LEVEL_MAX );
> -		ASSERT( undertime );
> +		assert( underlevel <= LEVEL_MAX );
> +		assert( undertime );
>  		if ( samefoundpr ) {
>  			if ( undertime >= sametime ) {
>  				if ( underinterruptedpr ) {
> @@ -1157,7 +1158,7 @@ baseuuidbypass:
>  				sc_incrbaselevel = underlevel;
>  				uuid_copy(sc_incrbaseid, underid);
>  				sc_resumepr = BOOL_FALSE;
> -				ASSERT( sc_resumerangep );
> +				assert( sc_resumerangep );
>  				free( ( void * )sc_resumerangep );
>  				sc_resumerangep = 0;
>  			} else {
> @@ -1179,14 +1180,14 @@ baseuuidbypass:
>  					      sc_level,
>  					      sc_level );
>  				}
> -				ASSERT( sametime );
> +				assert( sametime );
>  				sc_incrpr = BOOL_TRUE;
>  				sc_incrbasetime = undertime;
>  				sc_incrbaselevel = underlevel;
>  				sc_resumepr = BOOL_TRUE;
>  				sc_resumebasetime = sametime;
>  				uuid_copy(sc_resumebaseid, sameid);
> -				ASSERT( sc_resumerangep );
> +				assert( sc_resumerangep );
>  			}
>  		} else {
>  			if ( underinterruptedpr ) {
> @@ -1223,11 +1224,11 @@ baseuuidbypass:
>  			sc_incrbaselevel = underlevel;
>  			uuid_copy(sc_incrbaseid, underid);
>  			sc_resumepr = BOOL_FALSE;
> -			ASSERT( ! sc_resumerangep );
> +			assert( ! sc_resumerangep );
>  		}
>  	} else {
>  		if ( samefoundpr ) {
> -			ASSERT( sametime );
> +			assert( sametime );
>  			if ( subtreecnt && ! samepartialpr ) {
>  				mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  				      "level %u "
> @@ -1250,11 +1251,11 @@ baseuuidbypass:
>  			sc_resumepr = BOOL_TRUE;
>  			sc_resumebasetime = sametime;
>  			uuid_copy(sc_resumebaseid, sameid);
> -			ASSERT( sc_resumerangep );
> +			assert( sc_resumerangep );
>  		} else {
>  			sc_incrpr = BOOL_FALSE;
>  			sc_resumepr = BOOL_FALSE;
> -			ASSERT( ! sc_resumerangep );
> +			assert( ! sc_resumerangep );
>  			if ( sc_level > 0 ) {
>  				mlog( MLOG_NORMAL | MLOG_ERROR, _(
>  				      "cannot find earlier dump "
> @@ -1294,9 +1295,9 @@ baseuuidbypass:
>  			char incrtimestr[ 30 ];
>  
>  			strcpy( restimestr, ctimennl( &sc_resumebasetime ));
> -			ASSERT( strlen( restimestr ) < sizeof( restimestr ));
> +			assert( strlen( restimestr ) < sizeof( restimestr ));
>  			strcpy( incrtimestr, ctimennl( &sc_incrbasetime ));
> -			ASSERT( strlen( incrtimestr ) < sizeof( incrtimestr ));
> +			assert( strlen( incrtimestr ) < sizeof( incrtimestr ));
>  
>  			mlog( MLOG_VERBOSE, _(
>  			      "resuming level %d incremental dump of %s:%s "
> @@ -1388,7 +1389,7 @@ baseuuidbypass:
>  		}
>  		sc_rootxfsstatp =
>  			( xfs_bstat_t * )calloc( 1, sizeof( xfs_bstat_t ));
> -		ASSERT( sc_rootxfsstatp );
> +		assert( sc_rootxfsstatp );
>  
>  		if ( bigstat_one( sc_fsfd, rootstat.st_ino, sc_rootxfsstatp) < 0 ) {
>  			mlog( MLOG_ERROR,
> @@ -1433,7 +1434,7 @@ baseuuidbypass:
>  	sc_stat_inomapcnt = ( size64_t )fs_getinocnt( mntpnt );
>  
>  	sc_startptp = ( startpt_t * )calloc( drivecnt, sizeof( startpt_t ));
> -	ASSERT( sc_startptp );
> +	assert( sc_startptp );
>  	ok = inomap_build( sc_fshandlep,
>  			   sc_fsfd,
>  			   sc_rootxfsstatp,
> @@ -1467,7 +1468,7 @@ baseuuidbypass:
>  	 * an inomap for each media file. the dirdump flag will be set
>  	 * in content_stream_dump() for streams which dump the directories.
>  	 */
> -	ASSERT( sizeof( cwhdrtemplatep->ch_specific ) >= sizeof( *scwhdrtemplatep ));
> +	assert( sizeof( cwhdrtemplatep->ch_specific ) >= sizeof( *scwhdrtemplatep ));
>  	scwhdrtemplatep->cih_mediafiletype = CIH_MEDIAFILETYPE_DATA;
>  	scwhdrtemplatep->cih_level = ( int32_t )sc_level;
>  	scwhdrtemplatep->cih_dumpattr = CIH_DUMPATTR_INOMAP;
> @@ -1553,17 +1554,17 @@ baseuuidbypass:
>  	/* allocate and populate per-stream context descriptors
>  	 */
>  	sc_contextp = ( context_t * )calloc( drivecnt, sizeof( context_t ));
> -	ASSERT( sc_contextp );
> +	assert( sc_contextp );
>  	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
>  		context_t *contextp = &sc_contextp[ strmix ];
>  
>  		contextp->cc_filehdrp =
>  				( filehdr_t * )calloc( 1, sizeof( filehdr_t ));
> -		ASSERT( contextp->cc_filehdrp );
> +		assert( contextp->cc_filehdrp );
>  
>  		contextp->cc_extenthdrp =
>  			    ( extenthdr_t * )calloc( 1, sizeof( extenthdr_t ));
> -		ASSERT( contextp->cc_extenthdrp );
> +		assert( contextp->cc_extenthdrp );
>  
>  		contextp->cc_getdentsbufsz = sizeof( struct dirent )
>  					       +
> @@ -1573,7 +1574,7 @@ baseuuidbypass:
>  		}
>  		contextp->cc_getdentsbufp =
>  			   ( char * ) calloc( 1, contextp->cc_getdentsbufsz );
> -		ASSERT( contextp->cc_getdentsbufp );
> +		assert( contextp->cc_getdentsbufp );
>  
>  		contextp->cc_mdirentbufsz = sizeof( direnthdr_t  )
>  					    +
> @@ -1582,7 +1583,7 @@ baseuuidbypass:
>  					    DIRENTHDR_ALIGN;
>  		contextp->cc_mdirentbufp =
>  			   ( char * ) calloc( 1, contextp->cc_mdirentbufsz );
> -		ASSERT( contextp->cc_mdirentbufp );
> +		assert( contextp->cc_mdirentbufp );
>  
>  		contextp->cc_extattrlistbufsz = EXTATTR_LISTBUF_SZ;
>  		contextp->cc_extattrrtrvarraylen = EXTATTR_RTRVARRAY_LEN;
> @@ -1592,15 +1593,15 @@ baseuuidbypass:
>  		}
>  		contextp->cc_extattrlistbufp =
>  			   ( char * )calloc( 1, contextp->cc_extattrlistbufsz );
> -		ASSERT( contextp->cc_extattrlistbufp );
> +		assert( contextp->cc_extattrlistbufp );
>  		contextp->cc_extattrrtrvarrayp =
>  		  ( attr_multiop_t * )calloc( contextp->cc_extattrrtrvarraylen,
>  				    sizeof( attr_multiop_t ));
> -		ASSERT( contextp->cc_extattrrtrvarrayp );
> +		assert( contextp->cc_extattrrtrvarrayp );
>  		contextp->cc_extattrdumpbufp =
>  			   ( char * )memalign( sizeof( extattrhdr_t ),
>  					       contextp->cc_extattrdumpbufsz );
> -		ASSERT( contextp->cc_extattrdumpbufp );
> +		assert( contextp->cc_extattrdumpbufp );
>  		if (hsm_fs_ctxtp) {
>  			contextp->cc_hsm_f_ctxtp = HsmAllocateFileContext(
>  				hsm_fs_ctxtp);
> @@ -1611,7 +1612,7 @@ baseuuidbypass:
>  		contextp->cc_readlinkbufsz = MAXPATHLEN + SYMLINK_ALIGN;
>  		contextp->cc_readlinkbufp =
>  			   ( char * ) calloc( 1, contextp->cc_readlinkbufsz );
> -		ASSERT( contextp->cc_readlinkbufp );
> +		assert( contextp->cc_readlinkbufp );
>  
>  		contextp->cc_inomap_contextp = inomap_alloc_context( );
>  	}
> @@ -1770,7 +1771,7 @@ content_statline( char **linespp[ ] )
>  				 (unsigned long long)sc_stat_inomapdone,
>  				 (unsigned long long)sc_stat_inomapcnt,
>  				 elapsed );
> -			ASSERT( strlen( statline[ 0 ] ) < STATLINESZ );
> +			assert( strlen( statline[ 0 ] ) < STATLINESZ );
>  		} else {
>  			sprintf( statline[ 0 ],
>  				 "status at %02d:%02d:%02d: "
> @@ -1784,7 +1785,7 @@ content_statline( char **linespp[ ] )
>  				 (unsigned long long)sc_stat_inomapdone,
>  				 (unsigned long long)sc_stat_inomapcnt,
>  				 elapsed );
> -			ASSERT( strlen( statline[ 0 ] ) < STATLINESZ );
> +			assert( strlen( statline[ 0 ] ) < STATLINESZ );
>  		}
>  		return 1;
>  	}
> @@ -1835,7 +1836,7 @@ content_statline( char **linespp[ ] )
>  				elapsed );
>  	}
>  
> -	ASSERT( strlen( statline[ 0 ] ) < STATLINESZ );
> +	assert( strlen( statline[ 0 ] ) < STATLINESZ );
>  
>  	/* optionally create stat lines for each drive
>  	 */
> @@ -1883,7 +1884,7 @@ content_statline( char **linespp[ ] )
>  		sprintf( &statline[ statlinecnt ]
>  				  [ strlen( statline[ statlinecnt ] ) ],
>  			 "\n" );
> -		ASSERT( strlen( statline[ statlinecnt ] ) < STATLINESZ );
> +		assert( strlen( statline[ statlinecnt ] ) < STATLINESZ );
>  		statlinecnt++;
>  	}
>  
> @@ -1905,7 +1906,7 @@ create_inv_session(
>  
>  	/* create a cleanup handler to close the inventory on exit. */
>  	rval = atexit( inv_cleanup );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  
>  	sc_inv_idbtoken = inv_open( ( inv_predicate_t )INV_BY_UUID,
>  					INV_SEARCH_N_MOD,
> @@ -1915,12 +1916,12 @@ create_inv_session(
>  	}
>  	qmntpnt = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
>  					+ 1 + strlen( mntpnt ) + 1 );
> -	ASSERT( qmntpnt );
> -	ASSERT( strlen( gwhdrtemplatep->gh_hostname ));
> +	assert( qmntpnt );
> +	assert( strlen( gwhdrtemplatep->gh_hostname ));
>  	sprintf( qmntpnt, "%s:%s", gwhdrtemplatep->gh_hostname, mntpnt );
>  	qfsdevice = ( char * )calloc( 1, strlen( gwhdrtemplatep->gh_hostname )
>  					 + 1 + strlen( fsdevice ) + 1 );
> -	ASSERT( qfsdevice );
> +	assert( qfsdevice );
>  	sprintf( qfsdevice, "%s:%s", gwhdrtemplatep->gh_hostname, fsdevice );
>  
>  	sc_inv_sestoken = inv_writesession_open( sc_inv_idbtoken,
> @@ -1943,7 +1944,7 @@ create_inv_session(
>  	*/
>  	sc_inv_stmtokenp = ( inv_stmtoken_t * )
>  				calloc( drivecnt, sizeof( inv_stmtoken_t ));
> -	ASSERT( sc_inv_stmtokenp );
> +	assert( sc_inv_stmtokenp );
>  	for ( strmix = 0 ; strmix < drivecnt ; strmix++ ) {
>  		drive_t *drivep = drivepp[ strmix ];
>  		char *drvpath;
> @@ -1971,7 +1972,7 @@ mark_set( drive_t *drivep, xfs_ino_t ino, off64_t offset, int32_t flags )
>  {
>  	drive_ops_t *dop = drivep->d_opsp;
>  	mark_t *markp = ( mark_t * )calloc( 1, sizeof( mark_t ));
> -	ASSERT( markp );
> +	assert( markp );
>  
>  	if ( flags & STARTPT_FLAGS_NULL ) {
>  		mlog( MLOG_DEBUG,
> @@ -2102,17 +2103,17 @@ content_stream_dump( ix_t strmix )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( RV_OK == 0 ); /* bigstat_iter depends on this */
> +	assert( RV_OK == 0 ); /* bigstat_iter depends on this */
>  
>  	/* allocate a buffer for use by bstat_iter
>  	 */
>  	bstatbufp = ( xfs_bstat_t * )calloc( bstatbuflen,
>  					     sizeof( xfs_bstat_t ));
> -	ASSERT( bstatbufp );
> +	assert( bstatbufp );
>  
>  	/* allocate an inomap context */
>  	inomap_contextp = inomap_alloc_context();
> -	ASSERT( inomap_contextp );
> +	assert( inomap_contextp );
>  
>  	/* determine if stream terminators will be used and are expected.
>  	 * this will be revised each time a new media file is begun.
> @@ -2253,7 +2254,7 @@ content_stream_dump( ix_t strmix )
>  		if ( rv == RV_CORE ) {
>  			return mlog_exit(EXIT_FAULT, rv);
>  		}
> -		ASSERT( rv == RV_OK );
> +		assert( rv == RV_OK );
>  		if ( rv != RV_OK ) {
>  			return mlog_exit(EXIT_FAULT, rv);
>  		}
> @@ -2298,7 +2299,7 @@ content_stream_dump( ix_t strmix )
>  			free( ( void * )bstatbufp );
>  			return mlog_exit(EXIT_FAULT, rv);
>  		}
> -		ASSERT( rv == RV_OK );
> +		assert( rv == RV_OK );
>  		if ( rv != RV_OK ) {
>  			free( ( void * )bstatbufp );
>  			return mlog_exit(EXIT_FAULT, rv);
> @@ -2334,7 +2335,7 @@ content_stream_dump( ix_t strmix )
>  				free( ( void * )bstatbufp );
>  				return mlog_exit(EXIT_FAULT, rv);
>  			}
> -			ASSERT( rv == RV_OK );
> +			assert( rv == RV_OK );
>  			if ( rv != RV_OK ) {
>  				free( ( void * )bstatbufp );
>  				return mlog_exit(EXIT_FAULT, rv);
> @@ -2394,7 +2395,7 @@ content_stream_dump( ix_t strmix )
>  				free( ( void * )bstatbufp );
>  				return mlog_exit(EXIT_FAULT, rv);
>  			}
> -			ASSERT( rv == RV_OK || rv == RV_NOMORE );
> +			assert( rv == RV_OK || rv == RV_NOMORE );
>  			if ( rv != RV_OK && rv != RV_NOMORE ) {
>  				free( ( void * )bstatbufp );
>  				return mlog_exit(EXIT_FAULT, rv);
> @@ -2737,7 +2738,7 @@ content_mediachange_query( void )
>  	}
>  	nochangeix = choicecnt;
>  	choicestr[ choicecnt++ ] = "continue";
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	responseix = dlog_multi_query( querystr,
>  				       querycnt,
>  				       choicestr,
> @@ -2755,7 +2756,7 @@ content_mediachange_query( void )
>  		clr_mcflag( choicetothrdmap[ responseix ].thrdix );
>  		return "media change acknowledged\n";
>  	}
> -	ASSERT( responseix == nochangeix );
> +	assert( responseix == nochangeix );
>  	return "continuing\n";
>  }
>  
> @@ -2919,7 +2920,7 @@ dump_dir( ix_t strmix,
>  
>  	/* no way this can be non-dir, but check anyway
>  	 */
> -	ASSERT( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
> +	assert( ( statp->bs_mode & S_IFMT ) == S_IFDIR );
>  	if ( ( statp->bs_mode & S_IFMT ) != S_IFDIR ) {
>  		return RV_OK;
>  	}
> @@ -3041,7 +3042,7 @@ dump_dir( ix_t strmix,
>  		      nread > 0
>  		      ;
>  		      nread -= ( intgen_t )reclen,
> -		      ASSERT( nread >= 0 ),
> +		      assert( nread >= 0 ),
>  		      p = ( struct dirent * )( ( char * )p + reclen ),
>  		      reclen = ( size_t )p->d_reclen ) {
>  			xfs_ino_t ino;
> @@ -3056,7 +3057,7 @@ dump_dir( ix_t strmix,
>  			 * be null-terminated, but the record may have
>  			 * padding after the null-termination.
>  			 */
> -			ASSERT( namelen < nameszmax );
> +			assert( namelen < nameszmax );
>  #endif
>  
>  			/* skip "." and ".."
> @@ -3263,7 +3264,7 @@ dump_extattr_list( drive_t *drivep,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( listp->al_count >= 0 );
> +	assert( listp->al_count >= 0 );
>  
>  	/* fill up a retrieve array and build a dump buffer;
>  	 * can run out of entries in the name list, space in the
> @@ -3397,7 +3398,7 @@ dump_extattr_list( drive_t *drivep,
>  		if (dumpbufp <= dumpbufendp)
>  			continue;	/* no buffer overflow yet */
>  
> -		ASSERT( endp > contextp->cc_extattrdumpbufp );
> +		assert( endp > contextp->cc_extattrdumpbufp );
>  		bufsz = ( size_t )( endp - contextp->cc_extattrdumpbufp );
>  
>  		rval = write_buf( contextp->cc_extattrdumpbufp,
> @@ -3476,7 +3477,7 @@ dump_extattr_list( drive_t *drivep,
>  				continue;
>  			}
>  
> -			ASSERT( endp > contextp->cc_extattrdumpbufp );
> +			assert( endp > contextp->cc_extattrdumpbufp );
>  			bufsz = ( size_t )( endp - contextp->cc_extattrdumpbufp );
>  
>  			rval = write_buf( contextp->cc_extattrdumpbufp,
> @@ -3613,7 +3614,7 @@ dump_extattr_buildrecord( xfs_bstat_t *statp,
>  
>  	memset( ( void * )&tmpah, 0, sizeof( tmpah ));
>  	tmpah.ah_sz = recsz;
> -	ASSERT( EXTATTRHDR_SZ + namesz < UINT16MAX );
> +	assert( EXTATTRHDR_SZ + namesz < UINT16MAX );
>  	tmpah.ah_valoff = ( u_int16_t )( EXTATTRHDR_SZ + namesz );
>  	tmpah.ah_flags = ( u_int16_t )
>  		(( flag & ATTR_ROOT ) ? EXTATTRHDR_FLAGS_ROOT :
> @@ -3644,7 +3645,7 @@ dump_extattrhdr( drive_t *drivep,
>  
>  	memset( ( void * )&ahdr, 0, sizeof( ahdr ));
>  	ahdr.ah_sz = recsz;
> -	ASSERT( valoff < UINT16MAX );
> +	assert( valoff < UINT16MAX );
>  	ahdr.ah_valoff = ( u_int16_t )valoff;
>  	ahdr.ah_flags = ( u_int16_t )flags | EXTATTRHDR_FLAGS_CHECKSUM;
>  	ahdr.ah_valsz = valsz;
> @@ -3937,7 +3938,7 @@ dump_file_reg( drive_t *drivep,
>  	 */
>  	if ( statp->bs_ino == startptp->sp_ino ) {
>  		offset = startptp->sp_offset;
> -		ASSERT( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
> +		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
>  	} else {
>  		offset = 0;
>  	}
> @@ -3966,7 +3967,7 @@ dump_file_reg( drive_t *drivep,
>  				break;
>  			}
>  		}
> -		ASSERT( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
> +		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
>  	}
>  		
>  	/* determine the offset within the file where the dump should end.
> @@ -4034,7 +4035,7 @@ dump_file_reg( drive_t *drivep,
>  		/* see if we are done.
>  		 */
>  		if ( cmpltflg ) {
> -			ASSERT( rv == RV_OK );
> +			assert( rv == RV_OK );
>  			break;
>  		}
>  
> @@ -4094,7 +4095,7 @@ dump_file_reg( drive_t *drivep,
>  					&offset,
>  					&bc,
>  					&cmpltflg );
> -		ASSERT( bc >= 0 );
> +		assert( bc >= 0 );
>  		bytecnt += bc;
>  		if ( rv != RV_OK ) {
>  			break;
> @@ -4193,7 +4194,7 @@ dump_file_spec( drive_t *drivep,
>  
>  		/* null-terminate the string
>  		 */
> -		ASSERT( ( size_t )nread < contextp->cc_readlinkbufsz );
> +		assert( ( size_t )nread < contextp->cc_readlinkbufsz );
>  		contextp->cc_readlinkbufp[ nread ] = 0;
>  
>  		/* calculate the extent size - be sure to include room
> @@ -4202,7 +4203,7 @@ dump_file_spec( drive_t *drivep,
>  		extentsz = ( ( size_t )nread + 1 + ( SYMLINK_ALIGN - 1 ))
>  			   &
>  			   ~ ( SYMLINK_ALIGN - 1 );
> -		ASSERT( extentsz <= contextp->cc_readlinkbufsz );
> +		assert( extentsz <= contextp->cc_readlinkbufsz );
>  
>  		/* dump an extent header
>  		 */
> @@ -4351,7 +4352,7 @@ dump_extent_group( drive_t *drivep,
>  	 */
>  	nextoffset = *nextoffsetp;
>  	bytecnt = 0;
> -	ASSERT( ( nextoffset & ( BBSIZE - 1 )) == 0 );
> +	assert( ( nextoffset & ( BBSIZE - 1 )) == 0 );
>  
>  	for ( ; ; ) {
>  		off64_t offset;
> @@ -4398,7 +4399,7 @@ dump_extent_group( drive_t *drivep,
>  		if ( gcp->eg_nextbmapp >= gcp->eg_endbmapp ) {
>  			intgen_t entrycnt; /* entries in new bmap */
>  
> -			ASSERT( gcp->eg_nextbmapp == gcp->eg_endbmapp );
> +			assert( gcp->eg_nextbmapp == gcp->eg_endbmapp );
>  
>  			/* get a new extent block
>  			 */
> @@ -4613,7 +4614,7 @@ dump_extent_group( drive_t *drivep,
>  			      extsz,
>  			      nextoffset );
>  		}
> -		ASSERT( extsz > 0 );
> +		assert( extsz > 0 );
>  
>  		/* if the resultant extent would put us over maxcnt,
>  		 * shorten it, and round up to the next BBSIZE (round 
> @@ -4692,8 +4693,8 @@ dump_extent_group( drive_t *drivep,
>  		 */
>  		if ( sosig && ( extsz > stopoffset - offset )) {
>  			extsz = stopoffset - offset;
> -			ASSERT( extsz >= 0 );
> -			ASSERT( ! ( extsz & ( off64_t )( BBSIZE - 1 )));
> +			assert( extsz >= 0 );
> +			assert( ! ( extsz & ( off64_t )( BBSIZE - 1 )));
>  			mlog( MLOG_NITTY,
>  			      "adjusted top of extent "
>  			      "to adhere to stop offset: "
> @@ -4747,8 +4748,8 @@ dump_extent_group( drive_t *drivep,
>  		}
>  		/* adjust the next offset
>  		 */
> -		ASSERT( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
> -		ASSERT( ( extsz & ( off64_t )( BBSIZE - 1 )) == 0 );
> +		assert( ( offset & ( off64_t )( BBSIZE - 1 )) == 0 );
> +		assert( ( extsz & ( off64_t )( BBSIZE - 1 )) == 0 );
>  		nextoffset = offset + extsz;
>  
>  		/* dump the extent header
> @@ -4786,7 +4787,7 @@ dump_extent_group( drive_t *drivep,
>  			bufp = ( * dop->do_get_write_buf )( drivep,
>  							    reqsz,
>  							    &actualsz );
> -			ASSERT( actualsz <= reqsz );
> +			assert( actualsz <= reqsz );
>  			new_off = lseek64( gcp->eg_fd, offset, SEEK_SET );
>  			if ( new_off == ( off64_t )( -1 )) {
>  				mlog( MLOG_NORMAL, _(
> @@ -4810,7 +4811,7 @@ dump_extent_group( drive_t *drivep,
>  
>  				nread = 0;
>  			}
> -			ASSERT( ( size_t )nread <= actualsz );
> +			assert( ( size_t )nread <= actualsz );
>  			mlog( MLOG_NITTY,
>  			      "read ino %llu offset %lld sz %d actual %d\n",
>  			      statp->bs_ino,
> @@ -5103,8 +5104,8 @@ dump_dirent( drive_t *drivep,
>  		return RV_OK;
>  	}
>  
> -	ASSERT( sz <= UINT16MAX );
> -	ASSERT( sz >= DIRENTHDR_SZ );
> +	assert( sz <= UINT16MAX );
> +	assert( sz >= DIRENTHDR_SZ );
>  
>  	outbufp = malloc(sz);
>  
> @@ -5206,7 +5207,7 @@ dump_session_inv( drive_t *drivep,
>  		      "unable to get session inventory to dump\n") );
>  		return BOOL_TRUE;
>  	}
> -	ASSERT( inv_sbufp );
> +	assert( inv_sbufp );
>  
>  	/* modify the write header to indicate the media file type.
>  	 */
> @@ -5497,18 +5498,18 @@ inv_cleanup( void )
>  			      interrupted ? ": interrupted" : "" );
>  			if (interrupted) mlog_exit_hint(RV_INTR);
>  			ok = inv_stream_close( *inv_stmtp, interrupted );
> -			ASSERT( ok );
> +			assert( ok );
>  		}
>  	}
>  
>  	if ( sc_inv_sestoken != INV_TOKEN_NULL ) {
>  		ok = inv_writesession_close( sc_inv_sestoken );
> -		ASSERT( ok );
> +		assert( ok );
>  	}
>  
>  	if ( sc_inv_idbtoken != INV_TOKEN_NULL ) {
>  		ok = inv_close( sc_inv_idbtoken );
> -		ASSERT( ok );
> +		assert( ok );
>  	}
>  }
>  
> @@ -5542,7 +5543,7 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( BES_INIT == 0 );
> +	assert( BES_INIT == 0 );
>  
>  	mlog( MLOG_DEBUG | MLOG_MEDIA,
>  	      "Media op: begin media file\n" );
> @@ -5588,7 +5589,7 @@ Media_mfile_begin( drive_t *drivep, context_t *contextp, bool_t intr_allowed )
>  			mediawrittentopr = BOOL_TRUE;
>  			goto changemedia;
>  		default:
> -			ASSERT( 0 );
> +			assert( 0 );
>  			return RV_CORE;
>  		}
>  	}
> @@ -5685,11 +5686,11 @@ position:
>  				intgen_t status;
>  				mlog( MLOG_VERBOSE | MLOG_MEDIA, _(
>  				      "stream terminator found\n") );
> -				ASSERT( contextp->cc_Media_useterminatorpr );
> -				ASSERT( dcaps & DRIVE_CAP_BSF ); /* redundant */
> +				assert( contextp->cc_Media_useterminatorpr );
> +				assert( dcaps & DRIVE_CAP_BSF ); /* redundant */
>  				status = 0;
>  				rval = ( * dop->do_bsf )( drivep, 0, &status );
> -				ASSERT( rval == 0 );
> +				assert( rval == 0 );
>  				if ( status == DRIVE_ERROR_DEVICE ) {
>  					mlog( MLOG_NORMAL | MLOG_ERROR | MLOG_MEDIA, _(
>  					      "encountered media error "
> @@ -5742,10 +5743,10 @@ position:
>  				intgen_t status;
>  				mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_MEDIA, _(
>  				      "repositioning to overwrite\n") );
> -				ASSERT( dcaps & DRIVE_CAP_BSF );
> +				assert( dcaps & DRIVE_CAP_BSF );
>  				status = 0;
>  				rval = ( * dop->do_bsf )( drivep, 0, &status );
> -				ASSERT( rval == 0 );
> +				assert( rval == 0 );
>  				if ( status == DRIVE_ERROR_DEVICE ) {
>  					return RV_DRIVE;
>  				}
> @@ -5881,7 +5882,7 @@ position:
>  				assert( dcaps & DRIVE_CAP_BSF );
>  				status = 0;
>  				rval = ( * dop->do_bsf )( drivep, 0, &status );
> -				ASSERT( rval == 0 );
> +				assert( rval == 0 );
>  				if ( status == DRIVE_ERROR_DEVICE ) {
>  					return RV_DRIVE;
>  				}
> @@ -5923,7 +5924,7 @@ changemedia:
>  	
>  	/* first eject the current media object if capability supported
>  	 */
> -	ASSERT( mediapresentpr != BOOL_UNKNOWN );
> +	assert( mediapresentpr != BOOL_UNKNOWN );
>  	if ( mediapresentpr == BOOL_TRUE ) {
>  		if ( dcaps & DRIVE_CAP_EJECT ) {
>  			rval = ( * dop->do_eject_media )( drivep );
> @@ -5949,7 +5950,7 @@ changemedia:
>  	 */
>  	if ( drivecnt > 1 && ! stdoutpiped ) {
>  		ix_t thrdix = drivep->d_index;
> -		ASSERT( sistr );
> +		assert( sistr );
>  		mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
>  		      "please change media: "
>  		      "type %s to confirm media change\n"),
> @@ -5983,8 +5984,8 @@ changemedia:
>  	goto position;
>  
>  write:
> -	ASSERT( mediapresentpr == BOOL_TRUE );
> -	ASSERT( virginmediapr != BOOL_UNKNOWN );
> +	assert( mediapresentpr == BOOL_TRUE );
> +	assert( virginmediapr != BOOL_UNKNOWN );
>  
>  	if ( intr_allowed && cldmgr_stop_requested( )) {
>  		return RV_INTR;
> @@ -6024,8 +6025,8 @@ write:
>  		mwhdrp->mh_mediaix++; /* pre-initialized to -1 */
>  	}
>  
> -	ASSERT( mwhdrp->mh_mediaix != ( u_int32_t )( -1 ));
> -	ASSERT( mwhdrp->mh_dumpfileix != ( u_int32_t )( -1 ));
> +	assert( mwhdrp->mh_mediaix != ( u_int32_t )( -1 ));
> +	assert( mwhdrp->mh_dumpfileix != ( u_int32_t )( -1 ));
>  
>  	/* do not allow interleaving of media files from different xfsdumps.
>  	 */
> @@ -6090,7 +6091,7 @@ write:
>  				}
>  			}
>  		} else {
> -			ASSERT( ! virginmediapr );
> +			assert( ! virginmediapr );
>  			uuid_copy(mwhdrp->mh_mediaid, mrhdrp->mh_mediaid);
>  			( void )strncpyterm( mwhdrp->mh_medialabel,
>  					     mrhdrp->mh_medialabel,
> @@ -6139,14 +6140,14 @@ Media_mfile_end( drive_t *drivep,
>  	mlog( MLOG_DEBUG | MLOG_MEDIA,
>  	      "Media op: end media file\n" );
>  
> -	ASSERT( contextp->cc_Media_begin_entrystate == BES_INVAL );
> +	assert( contextp->cc_Media_begin_entrystate == BES_INVAL );
>  
>  	/* call drive's end_write op to flush the tail of the media file
>  	 * if has previously hit EOM, this is moot.
>  	 */
>  	rval = ( dop->do_end_write )( drivep, ncommittedp );
>  	if ( hit_eom ) {
> -		ASSERT( ! rval );
> +		assert( ! rval );
>  		contextp->cc_Media_begin_entrystate = BES_ENDEOM;
>  		return RV_EOM;
>  	}
> @@ -6198,7 +6199,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* query: ask if overwrite ok
> @@ -6209,13 +6210,13 @@ retry:
>  		 (unsigned int)drivep->d_index );
>  	querycnt = 0;
>  	querystr[ querycnt++ ] = question;
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	dontix = choicecnt;
>  	choicestr[ choicecnt++ ] = "don't overwrite";
>  	doix = choicecnt;
>  	choicestr[ choicecnt++ ] = "overwrite";
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	sigintix = IXMAX - 1;
>  
>  	responseix = dlog_multi_query( querystr,
> @@ -6239,7 +6240,7 @@ retry:
>  	} else {
>  		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
>  	}
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_multi_ack( ackstr,
>  			ackcnt );
>  
> @@ -6248,7 +6249,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> @@ -6336,7 +6337,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* query: ask if overwrite ok
> @@ -6350,13 +6351,13 @@ retry:
>  		 (unsigned int)drivep->d_index );
>  	querycnt = 0;
>  	querystr[ querycnt++ ] = question;
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	dontix = choicecnt;
>  	choicestr[ choicecnt++ ] = "don't erase";
>  	doix = choicecnt;
>  	choicestr[ choicecnt++ ] = "erase";
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	sigintix = IXMAX - 1;
>  
>  	responseix = dlog_multi_query( querystr,
> @@ -6380,7 +6381,7 @@ retry:
>  	} else {
>  		ackstr[ ackcnt++ ] = "keyboard interrupt\n";
>  	}
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_multi_ack( ackstr,
>  			ackcnt );
>  
> @@ -6389,7 +6390,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> @@ -6448,7 +6449,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	responseix = dlog_string_query( Media_prompt_label_cb,
> @@ -6474,7 +6475,7 @@ retry:
>  		ackstr[ ackcnt++ ] = "abort\n";
>  	}
>  
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_string_ack( ackstr,
>  			 ackcnt );
>  
> @@ -6483,7 +6484,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> diff --git a/dump/inomap.c b/dump/inomap.c
> index a35059a..7a3069f 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -25,6 +25,7 @@
>  #include <time.h>
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -185,7 +186,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
>  					       bstatbuflen
>  					       *
>  					       sizeof( xfs_bstat_t ));
> -	ASSERT( bstatbufp );
> +	assert( bstatbufp );
>  
>  	/* count the number of inode groups, which will serve as a
>  	 * starting point for the size of the inomap.
> @@ -369,7 +370,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
>  			} else {
>  				ep = &startptp[ startptix + 1 ];
>  			}
> -			ASSERT( ! p->sp_flags );
> +			assert( ! p->sp_flags );
>  			mlog( MLOG_VERBOSE | MLOG_INOMAP,
>  			      _("stream %u: ino %llu offset %lld to "),
>  			      startptix,
> @@ -606,8 +607,8 @@ cb_add( void *arg1,
>  			cb_hdrsz += ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
>  		}
>  	} else if ( resumed ) {
> -		ASSERT( mode != S_IFDIR );
> -		ASSERT( changed );
> +		assert( mode != S_IFDIR );
> +		assert( changed );
>  	} else {
>  		if ( mode == S_IFDIR ) {
>  			if ( cb_skip_unchanged_dirs ) {
> @@ -832,7 +833,7 @@ cb_startpt( void *arg1,
>  		return 0;
>  	}
>  
> -	ASSERT( cb_startptix < cb_startptcnt );
> +	assert( cb_startptix < cb_startptcnt );
>  
>  	estimate = estimate_dump_space( statp );
>  	cb_accum += estimate + ( EXTENTHDR_SZ * (statp->bs_extents + 1) );
> @@ -929,7 +930,7 @@ cb_startpt( void *arg1,
>  			}
>  			break;
>  		default:
> -			ASSERT( 0 );
> +			assert( 0 );
>  			return 1;
>  		}
>  	} while ( action == ( action_t )BUMP || action == ( action_t )SPLIT );
> @@ -1042,7 +1043,7 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino )
>  static intgen_t
>  inomap_init( intgen_t igrpcnt )
>  {
> -	ASSERT( sizeof( hnk_t ) == HNKSZ );
> +	assert( sizeof( hnk_t ) == HNKSZ );
>  
>  	/* lastseg must be initialized with -1 offsets since
>  	 * no segments have been added yet */
> @@ -1483,7 +1484,7 @@ subtreelist_parse( jdm_fshandle_t *fshandlep,
>  	for ( subtreeix = 0 ; subtreeix < subtreecnt ; subtreeix++ ) {
>  		intgen_t cbrval = 0;
>  		char *currentpath = subtreebuf[ subtreeix ];
> -		ASSERT( *currentpath != '/' );
> +		assert( *currentpath != '/' );
>  		( void )diriter( fshandlep,
>  				 fsfd,
>  				 rootstatp,
> @@ -1669,7 +1670,7 @@ quantity2offset( jdm_fshandle_t *fshandlep, xfs_bstat_t *statp, off64_t qty )
>  		}
>  
>  		if ( bmap[ 0 ].bmv_entries <= 0 ) {
> -			ASSERT( bmap[ 0 ].bmv_entries == 0 );
> +			assert( bmap[ 0 ].bmv_entries == 0 );
>  			( void )close( fd );
>  			return offset_next;
>  		}
> diff --git a/inventory/inv_api.c b/inventory/inv_api.c
> index 65102e6..bd473e9 100644
> --- a/inventory/inv_api.c
> +++ b/inventory/inv_api.c
> @@ -26,6 +26,7 @@
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <sys/stat.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -48,7 +49,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
>  
>  	int index = 0;
>  	
> -	ASSERT ( pred );
> +	assert ( pred );
>  	fd = retval = init_idb ( pred, bywhat, forwhat, &tok );
>  
>  	if ( retval == I_DONE ) 
> @@ -72,7 +73,7 @@ inv_open( inv_predicate_t bywhat, inv_oflag_t forwhat, void *pred )
>  		return INV_TOKEN_NULL;
>  	}
>  
> -	ASSERT ( index > 0 );
> +	assert ( index > 0 );
>  
>  	/* Now we need to make sure that this has enough space */
>  	INVLOCK( stobjfd, LOCK_SH );
> @@ -170,12 +171,12 @@ inv_writesession_open(
>  	inv_sestoken_t	sestok;
>  	inv_oflag_t     forwhat;
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> -	ASSERT ( sesid && fsid && mntpt && devpath );
> +	assert ( tok != INV_TOKEN_NULL );
> +	assert ( sesid && fsid && mntpt && devpath );
>  	forwhat = tok->d_oflag;
>  	fd = tok->d_stobj_fd;
> -	ASSERT ( forwhat != INV_SEARCH_ONLY );
> -	ASSERT ( fd > 0 );
> +	assert ( forwhat != INV_SEARCH_ONLY );
> +	assert ( fd > 0 );
>  
>  	if ( ! ( tok->d_update_flag & FSTAB_UPDATED ) ) {
>  		if ( fstab_put_entry( fsid, mntpt, devpath, forwhat ) < 0 ) {
> @@ -218,7 +219,7 @@ inv_writesession_open(
>  	/* create the writesession, and get ready for the streams to come 
>  	   afterwards */
>  	rval = stobj_create_session( sestok, fd, sescnt, &ses, &hdr );
> -	ASSERT (rval > 0);
> +	assert (rval > 0);
>  
>  
>  	INVLOCK( fd, LOCK_UN );
> @@ -256,7 +257,7 @@ inv_writesession_close( inv_sestoken_t tok )
>  {
>  	int		rval;
>  	
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  
>  	/* now update end_time in the inv index header */
>  	rval = idx_put_sesstime( tok, INVT_ENDTIME );
> @@ -287,7 +288,7 @@ inv_stream_open(
>  	int fd;
>  	bool_t err = BOOL_FALSE;
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> +	assert ( tok != INV_TOKEN_NULL );
>  	 
>  	/* this memset is needed as a dump interrupted/crashed very soon
>  	 * after starting results in an inventory with exteremely large
> @@ -446,9 +447,9 @@ inv_put_mediafile(
>  	int 		 rval;
>  
>  
> -	ASSERT ( tok != INV_TOKEN_NULL );
> -	ASSERT ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
> -	ASSERT ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
> +	assert ( tok != INV_TOKEN_NULL );
> +	assert ( tok->md_sesstok->sd_invtok->d_update_flag & FSTAB_UPDATED );
> +	assert ( tok->md_sesstok->sd_invtok->d_stobj_fd >= 0 );
>  
>  	mf = (invt_mediafile_t *) calloc( 1, sizeof( invt_mediafile_t ) );
>  	
> @@ -512,8 +513,8 @@ inv_get_sessioninfo(
>  	int		fd;
>  
>  
> -	ASSERT( tok != INV_TOKEN_NULL );
> -	ASSERT( tok->sd_invtok );
> +	assert( tok != INV_TOKEN_NULL );
> +	assert( tok->sd_invtok );
>  	*bufpp = NULL;
>  	*bufszp = 0;
>  	fd = tok->sd_invtok->d_stobj_fd;
> @@ -579,8 +580,8 @@ inv_free_session(
>  {
>  	uint i;
>  	
> -	ASSERT(ses);
> -	ASSERT(*ses);
> +	assert(ses);
> +	assert(*ses);
>  
>  	for ( i = 0; i < (*ses)->s_nstreams; i++ ) {
>  		/* the array of mediafiles is contiguous */
> diff --git a/inventory/inv_core.c b/inventory/inv_core.c
> index 3f7edb6..a83e7ef 100644
> --- a/inventory/inv_core.c
> +++ b/inventory/inv_core.c
> @@ -25,6 +25,7 @@
>  #include <fcntl.h>
>  #include <errno.h>
>  #include <sys/dir.h>
> +#include <assert.h>
>  #include "types.h"
>  #include "inv_priv.h"
>  
> @@ -44,7 +45,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
>  {
>  	/* object must be locked at least SHARED by caller */
>  	u_int num;
> -	ASSERT( cntsz >= sizeof( invt_counter_t ) );
> +	assert( cntsz >= sizeof( invt_counter_t ) );
>  
>  	*cntpp =  calloc( 1, cntsz);
>  
> @@ -62,7 +63,7 @@ get_counters( int fd, void **cntpp, size_t cntsz )
>  		      "INV : Unknown version %d - Expected version %d\n"),
>  		      (int) ( (invt_counter_t *)(*cntpp))->ic_vernum,
>  		      (int) INV_VERSION );
> -		ASSERT ( ((invt_counter_t *)(*cntpp))->ic_vernum ==
> +		assert ( ((invt_counter_t *)(*cntpp))->ic_vernum ==
>  			INV_VERSION );
>  	} 
>  
> @@ -110,7 +111,7 @@ get_invtrecord( int fd, void *buf, size_t bufsz, off64_t off,
>  {
>  	int  nread;
>  	
> -	ASSERT ( fd >= 0 );
> +	assert ( fd >= 0 );
>  	
>  	if ( dolock ) 
>  		INVLOCK( fd, LOCK_SH );
> diff --git a/inventory/inv_files.c b/inventory/inv_files.c
> index f77eeec..34b7aac 100644
> --- a/inventory/inv_files.c
> +++ b/inventory/inv_files.c
> @@ -23,6 +23,7 @@
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <sys/dir.h>
> +#include <assert.h>
>  
>  
>  /*----------------------------------------------------------------------*/
> @@ -50,28 +51,28 @@ static char inv_lockfilep[MGR_PATH_MAX];
>  char *
>  inv_dirpath( void )
>  {
> -	ASSERT(inv_base);
> +	assert(inv_base);
>  	return inv_dirpathp;
>  }
>  
>  char *
>  inv_fstab( void )
>  {
> -	ASSERT(inv_base);
> +	assert(inv_base);
>  	return inv_fstabp;
>  }
>  
>  char *
>  inv_lockfile( void )
>  {
> -	ASSERT(inv_base);
> +	assert(inv_base);
>  	return inv_lockfilep;
>  }
>  
>  char *
>  inv_basepath( void )
>  {
> -	ASSERT(inv_base);
> +	assert(inv_base);
>  	return inv_base;
>  }
>  
> diff --git a/inventory/inv_fstab.c b/inventory/inv_fstab.c
> index 6567846..e87152f 100644
> --- a/inventory/inv_fstab.c
> +++ b/inventory/inv_fstab.c
> @@ -25,6 +25,7 @@
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <sys/dir.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -88,7 +89,7 @@ fstab_put_entry( uuid_t *fsidp, char *mntpt, char *dev, inv_oflag_t forwhat )
>  	invt_fstab_t *arr;
>  	int rval = 1;
>  
> -	ASSERT( forwhat != INV_SEARCH_ONLY );
> +	assert( forwhat != INV_SEARCH_ONLY );
>  
>  	/* fd is locked on succesful return */
>  	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
> @@ -229,7 +230,7 @@ fstab_get_fname( void *pred,
>  	if ( bywhat != INV_BY_UUID ) 
>  		free ( arr );
>  
> -	ASSERT( (int) strlen( fname ) < INV_STRLEN );
> +	assert( (int) strlen( fname ) < INV_STRLEN );
>  	return 1;
>  }	
>  	
> diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
> index 145745a..edb72b3 100644
> --- a/inventory/inv_idx.c
> +++ b/inventory/inv_idx.c
> @@ -25,6 +25,7 @@
>  #include <sys/file.h>
>  #include <sys/stat.h>
>  #include <sys/dir.h>
> +#include <assert.h>
>  #include "types.h"
>  #include "mlog.h"
>  #include "inv_priv.h"
> @@ -119,7 +120,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
>  				   We choose the former. */
>  				
>  				/* the timeperiods had better not overlap */
> -				ASSERT(( tm > iarr[i].ie_timeperiod.tp_end ) &&
> +				assert(( tm > iarr[i].ie_timeperiod.tp_end ) &&
>  				       ( tm < iarr[i+1].ie_timeperiod.tp_start ));
>  
>  				/* shift everything from (i+1) onwards by 
> @@ -134,7 +135,7 @@ idx_insert_newentry( int fd, /* kept locked EX by caller */
>  	}		
>  
>  	/* We couldnt find anything that fits */
> -	ASSERT( 0 );	/* We can't get here ! */
> +	assert( 0 );	/* We can't get here ! */
>  	return -1;
>  
>  	
> @@ -255,7 +256,7 @@ idx_create( char *fname, inv_oflag_t forwhat )
>  
>  	/* This is not to be called when the user wants to open
>  	   the db for SEARCH_ONLY. */
> -	ASSERT( forwhat != INV_SEARCH_ONLY );
> +	assert( forwhat != INV_SEARCH_ONLY );
>  
>  	if ((fd = open ( fname , INV_OFLAG(forwhat) | O_CREAT, S_IRUSR|S_IWUSR ) ) < 0 ) {
>  		INV_PERROR ( fname );
> @@ -477,8 +478,8 @@ idx_get_stobj( int invfd, inv_oflag_t forwhat, int *index )
>  		return -1;
>  	/* at this point we know that there should be at least one invindex
>  	   entry present */
> -	ASSERT ( ent != NULL );	
> -	ASSERT ( ent->ie_filename );
> +	assert ( ent != NULL );	
> +	assert ( ent->ie_filename );
>  
>  	fd = open( ent->ie_filename, INV_OFLAG(forwhat) );
>  	if ( fd < 0 )
> diff --git a/inventory/inv_mgr.c b/inventory/inv_mgr.c
> index 1f4a425..926b4c8 100644
> --- a/inventory/inv_mgr.c
> +++ b/inventory/inv_mgr.c
> @@ -24,6 +24,7 @@
>  #include <errno.h>
>  #include <sys/stat.h>
>  #include <sys/dir.h>
> +#include <assert.h>
>  #include "types.h"
>  #include "mlog.h"
>  #include "inv_priv.h"
> @@ -150,7 +151,7 @@ invmgr_query_all_sessions (
>  
>  	/* if on return, this is still null, the search failed */
>  	*outarg = NULL; 
> -	ASSERT(inarg);
> +	assert(inarg);
>  
>  	fd = fstab_getall( &arr, &cnt, &numfs, forwhat );
>  	/* special case missing file: ok, outarg says zero */
> @@ -725,7 +726,7 @@ bool_t
>  invmgr_trylock( invt_mode_t mode )
>  {
>  	int md;
> -	ASSERT( invlock_fd >= 0 );
> +	assert( invlock_fd >= 0 );
>  	
>  	md = (mode == INVT_RECONSTRUCT) ? LOCK_EX: LOCK_SH;
>  
> @@ -738,7 +739,7 @@ invmgr_trylock( invt_mode_t mode )
>  void
>  invmgr_unlock( void )
>  {
> -	ASSERT( invlock_fd >= 0 );
> +	assert( invlock_fd >= 0 );
>  	
>  	INVLOCK( invlock_fd, LOCK_UN );	
>  
> diff --git a/inventory/inv_oref.c b/inventory/inv_oref.c
> index a124b07..b6cd61d 100644
> --- a/inventory/inv_oref.c
> +++ b/inventory/inv_oref.c
> @@ -18,6 +18,7 @@
>  
>  #include <xfs/xfs.h>
>  #include <xfs/jdm.h>
> +#include <assert.h>
>  
>  #include "inv_priv.h"
>  #include "inv_oref.h"
> @@ -34,8 +35,8 @@ oref_resolve_(
>  	intgen_t rval;
>  
>  	type &= INVT_OTYPE_MASK;
> -	ASSERT(type);
> -	ASSERT(! OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> +	assert(type);
> +	assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
>  
>  	switch (type) {
>  	      case INVT_OTYPE_INVIDX:
> @@ -51,7 +52,7 @@ oref_resolve_(
>  		break;
>  
>  	      default:
> -		ASSERT(0);
> +		assert(0);
>  		break;
>  	}
>  	
> @@ -73,12 +74,12 @@ oref_resolve_upto(
>  {
>  	intgen_t rval = INV_OK;
>  
> -	ASSERT (OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> -	ASSERT (OREF_ISLOCKED(obj));
> +	assert (OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> +	assert (OREF_ISLOCKED(obj));
>  
>  	/* we arent interested in anything else */
>  	type &= INVT_RES_MASK;
> -	ASSERT(type);
> +	assert(type);
>  
>  	if (type >= INVT_RES_COUNTERS) {
>  		rval = oref_resolve_counters(obj);
> @@ -111,11 +112,11 @@ oref_resolve_entries(
>  	if (OREF_ISRESOLVED(obj, INVT_RES_ENTRIES))
>  		return INV_OK;
>  
> -	ASSERT(! OREF_ISRESOLVED(INVT_OTYPE_STOBJ));
> +	assert(! OREF_ISRESOLVED(INVT_OTYPE_STOBJ));
>  
>  	if (OREF_ISRESOLVED(INVT_OTYPE_INVIDX)) {
>  		invt_entry_t *ent;
> -		ASSERT(OREF_CNT_CURNUM(obj));
> +		assert(OREF_CNT_CURNUM(obj));
>  
>  		if (GET_ENTRIES(obj->fd, &ent, OREF_CNT_CURNUM(obj),
>  				sizeof(invt_entry_t)) < 0){
> @@ -125,7 +126,7 @@ oref_resolve_entries(
>  	}
>  	else {
>  		invt_fstab_t *ent;
> -		ASSERT(OREF_CNT_CURNUM(obj));
> +		assert(OREF_CNT_CURNUM(obj));
>  		if (GET_ENTRIES(obj->fd, &ent, OREF_CNT_CURNUM(obj),
>  				sizeof(invt_fstab_t)) < 0){
>  			return INV_ERR;
> @@ -184,10 +185,10 @@ oref_sync(
>  	intgen_t rval;
>  
>  	type &= INVT_RES_MASK;
> -	ASSERT(type);
> -	ASSERT(OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> -	ASSERT(OREF_ISRESOLVED(obj, type));
> -	ASSERT(OREF_ISLOCKED(obj));
> +	assert(type);
> +	assert(OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> +	assert(OREF_ISRESOLVED(obj, type));
> +	assert(OREF_ISLOCKED(obj));
>  
>  	switch (type) {
>  	      case INVT_RES_COUNTERS:
> @@ -199,7 +200,7 @@ oref_sync(
>  		break;
>  
>  	      case INVT_RES_ENTRIES:
> -		ASSERT(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
> +		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
>  
>  		rval = PUT_REC_NOLOCK(obj->fd, 
>  				      OREF_ENTRIES(obj), 
> @@ -209,7 +210,7 @@ oref_sync(
>  		break;
>  
>  	      default:
> -		ASSERT(0);
> +		assert(0);
>  		break;
>  	}
>  	
> @@ -226,13 +227,13 @@ oref_sync_append(
>  	intgen_t rval;
>  
>  	type &= INVT_RES_MASK;
> -	ASSERT(type);
> -	ASSERT(OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> -	ASSERT(OREF_ISLOCKED(obj));
> +	assert(type);
> +	assert(OREF_ISRESOLVED(obj, INVT_OTYPE_MASK));
> +	assert(OREF_ISLOCKED(obj));
>  
>  	switch (type) {
>  	      case INVT_RES_ENTRIES:
> -		ASSERT(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
> +		assert(! OREF_ISRESOLVED(obj, INVT_OTYPE_STOBJ));
>  		
>  		rval = PUT_REC_NOLOCK(obj->fd, 
>  				      entry,
> @@ -245,7 +246,7 @@ oref_sync_append(
>  		break;
>  
>  	      default:
> -		ASSERT(0);
> +		assert(0);
>  		break;
>  	}
>  	
> @@ -314,7 +315,7 @@ oref_resolve(
>  	invt_oref_t	*stobj;
>  	int		index;
>  
> -	ASSERT(! OREF_ISRESOLVED(invidx, INVT_OTYPE_MASK));
> +	assert(! OREF_ISRESOLVED(invidx, INVT_OTYPE_MASK));
>  	
>  	OREF_SET_TYPE(invidx, INVT_OTYPE_INVIDX);
>  
> @@ -393,7 +394,7 @@ oref_resolve_child(
>  	int		*index)
>  {
>  	invt_entry_t 	*ent;
> -	ASSERT(OREF_IS_LOCKED(invidx));
> +	assert(OREF_IS_LOCKED(invidx));
>  
>  	if (oref_resolve_upto(invidx, INVT_RES_ENTRIES) == INV_ERR)	
>  		return INV_ERR;
> @@ -402,8 +403,8 @@ oref_resolve_child(
>  	
>  	/* at this point we know that there should be at least one invindex
>  	   entry present */
> -	ASSERT ( ent != NULL );	
> -	ASSERT ( ent->ie_filename );
> +	assert ( ent != NULL );	
> +	assert ( ent->ie_filename );
>  
>  	fd = open( ent->ie_filename, O_RDWR );
>  	if ( fd < 0 ) {
> @@ -462,7 +463,7 @@ oref_resolve_new_stobj(
>  	invt_oref_t	*stobj;
>  	inv_idbtoken_t	tok;
>  
> -	ASSERT(OREF_ISLOCKED(invidx));
> +	assert(OREF_ISLOCKED(invidx));
>  
>  	memset ( &ent, 0, sizeof( ent ) );
>  	stobj = calloc(1, sizeof(invt_oref_t));
> diff --git a/inventory/inv_oref.h b/inventory/inv_oref.h
> index 5f4ed68..2562500 100644
> --- a/inventory/inv_oref.h
> +++ b/inventory/inv_oref.h
> @@ -158,48 +158,48 @@ typedef struct invt_oref {
>          { (oref)->token = tok; }
>  
>  #define OREF_SET_CNT(oref, cnt) \
> -	{ ASSERT (OREF_ISRESOLVED(oref, INVT_OTYPE_MASK)); \
> +	{ assert (OREF_ISRESOLVED(oref, INVT_OTYPE_MASK)); \
>  	  ((oref)->type & INVT_OTYPE_STOBJ) ? \
>  	  (oref)->cu_sescnt = (cnt): (oref)->cu_cnt = (cnt); \
>  	  (oref)->type |= INVT_RES_COUNTERS; }
>  
>  #define OREF_SET_ENTRIES(oref, ents) \
> -        { ASSERT ((oref)->type & (INVT_OTYPE_INVIDX | INVT_OTYPE_FSTAB));\
> -	  ASSERT ((oref)->type & INVT_RES_COUNTERS); \
> +        { assert ((oref)->type & (INVT_OTYPE_INVIDX | INVT_OTYPE_FSTAB));\
> +	  assert ((oref)->type & INVT_RES_COUNTERS); \
>  	  ((oref)->type & INVT_OTYPE_INVIDX) ? \
>  	  (oref)->eu_ent = ents : (oref)->eu_fstabent = ents; \
>  	  (oref)->type |= INVT_RES_ENTRIES; }
>  
>  #define OREF_SET_HDRS(oref, hdrs) \
> -        {  ASSERT ((oref)->type & INVT_OTYPE_STOBJ); \
> -	   ASSERT ((oref)->type & INVT_RES_COUNTERS); \
> +        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
> +	   assert ((oref)->type & INVT_RES_COUNTERS); \
>  	   (oref)->eu_hdr = hdrs; \
>  	   (oref)->type |= INVT_STOBJ_RES_HDRS; }
>  
>  #define OREF_SET_SESSIONS(oref, ses) \
> -        {  ASSERT ((oref)->type & INVT_OTYPE_STOBJ); \
> -	   ASSERT ((oref)->type & INVT_RES_COUNTERS); \
> +        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
> +	   assert ((oref)->type & INVT_RES_COUNTERS); \
>  	   (oref)->eu_ses = ses; \
>  	   (oref)->type |= INVT_STOBJ_RES_SESSIONS; }
>  
>  #define OREF_SET_STRMS(oref, strms) \
> -        {  ASSERT ((oref)->type & INVT_OTYPE_STOBJ); \
> -	   ASSERT ((oref)->type & INVT_RES_COUNTERS); \
> +        {  assert ((oref)->type & INVT_OTYPE_STOBJ); \
> +	   assert ((oref)->type & INVT_RES_COUNTERS); \
>  	   (oref)->eu_strm = strms; \
>  	   (oref)->type |= INVT_STOBJ_RES_STRMS; }
>  
>  #define OREF_SET_CHILD(oref, stobjref) \
> -        {  ASSERT (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
> +        {  assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
>  	   (oref)->ku_child = stobjref; \
>  	   (oref)->type |= INVT_RES_CHILD; }
>  
>  #define OREF_SET_PARENT(oref, invidxref) \
> -        {  ASSERT (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
> +        {  assert (! OREF_ISRESOLVED(oref, INVT_RES_KIN)); \
>  	   (oref)->ku_parent = invidxref; \
>  	   (oref)->type |= INVT_RES_PARENT; }
>  
>  #define OREF_UNRESOLVE_CHILD(oref) \
> -        {  ASSERT (OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
> +        {  assert (OREF_ISRESOLVED(oref, INVT_RES_CHILD)); \
>  	   close((oref)->ku_child->fd); \
>  	   OREF_DESTROY((oref)->ku_child); \
>  	   (oref)->ku_child = 0; \
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index becac17..42969b1 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -26,6 +26,7 @@
>  #include <sys/stat.h>
>  #include <sys/dir.h>
>  #include <sys/mman.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "timeutil.h"
> @@ -168,7 +169,7 @@ stobj_split( invt_idxinfo_t *idx, int fd, invt_sescounter_t *sescnt,
>  	if ( GET_SESHEADERS( fd, &harr, ns ) < 0 )
>  		return -1;
>  	
> -	ASSERT( harr != NULL );
> +	assert( harr != NULL );
>  
>  	if ( ( ix = stobj_find_splitpoint( fd, harr, ns, 
>  				       newsess->seshdr->sh_time ) ) == 0 )
> @@ -390,7 +391,7 @@ stobj_sortheaders( int fd, u_int num )
>  	if ( num < 2 ) return 1;
>  
>  	hdrs = malloc( sz );
> -	ASSERT( hdrs );
> +	assert( hdrs );
>  
>  	if ( GET_REC_NOLOCK( fd, hdrs, sz, STOBJ_OFFSET( 0, 0 ) ) < 0 ) {
>  		free ( hdrs );
> @@ -505,7 +506,7 @@ stobj_makefname( char *fname )
>  	strcat( fname, str );
>  	strcat( fname, INV_STOBJ_PREFIX );
>  
> -	ASSERT( (int) strlen( fname ) < INV_STRLEN );
> +	assert( (int) strlen( fname ) < INV_STRLEN );
>  }
>  
>  
> @@ -571,7 +572,7 @@ stobj_create_session(
>  {
>  	off64_t hoff;
>  	
> -	ASSERT( tok && sescnt && ses && hdr );
> +	assert( tok && sescnt && ses && hdr );
>  
>  	hdr->sh_sess_off = -1;
>  	ses->s_cur_nstreams = 0;
> @@ -759,7 +760,7 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
>  
>  	/* Now we know how big this entire thing is going to be */
>  	sesbufcp = sesbuf = calloc( 1, sessz );
> -	ASSERT( sesbuf );
> +	assert( sesbuf );
>  
>  	/* Copy everything. Note that we don't bother to adjust the offsets
>  	   either in the seshdr or in the mediafiles, because we don't need
> @@ -801,7 +802,7 @@ stobj_pack_sessinfo( int fd, invt_session_t *ses, invt_seshdr_t *hdr,
>  		for ( j = 0; j < strms[i].st_nmediafiles; 
>  		     j++, 
>  		     off = mf.mf_nextmf ) {
> -			ASSERT( off );
> +			assert( off );
>  			if ( GET_REC_NOLOCK( fd, &mf, 
>  					     sizeof( invt_mediafile_t ),
>  					     off ) <= 0 ) {
> @@ -941,7 +942,7 @@ stobj_delete_mobj(int fd,
>  /*  The prob is that we need to keep track of where we got these mfiles from
>      as we get them, or we wont know how to put them back if they are dirty.
>  */
> -			ASSERT( off );
> +			assert( off );
>  			if ( GET_REC_NOLOCK( fd, mf, 
>  					     sizeof( invt_mediafile_t ),
>  					     off ) <= 0 ) {
> @@ -1005,7 +1006,7 @@ stobj_unpack_sessinfo(
>  	char	         *tmpbuf;
>  	char 		 *p = (char *)bufp;
>  	
> -	ASSERT ( bufp );
> +	assert ( bufp );
>  	
>  	tmpbuf = (char *)malloc(bufsz);
>  
> @@ -1109,7 +1110,7 @@ stobj_unpack_sessinfo(
>  		      (int)( p - (char *) bufp ), (int) bufsz,
>  	      (int) ( sizeof( invt_entry_t ) ) );
>  	}
> -	ASSERT( (size_t) ( p - (char *) bufp ) == bufsz );
> +	assert( (size_t) ( p - (char *) bufp ) == bufsz );
>  	
>  	return BOOL_TRUE;
>  }
> @@ -1238,12 +1239,12 @@ stobj_copy_invsess(int fd,
>  		if (nmf)
>  			ises->s_streams[i].st_mediafiles = calloc( nmf,
>  						    sizeof( inv_mediafile_t ) );
> -		ASSERT( !nmf || ises->s_streams[i].st_mediafiles );
> +		assert( !nmf || ises->s_streams[i].st_mediafiles );
>  
>  		for ( j = 0; j < nmf; 
>  		      j++, 
>  		      off = mf.mf_nextmf ) {
> -			ASSERT( off );
> +			assert( off );
>  			if ( GET_REC_NOLOCK( fd, &mf, 
>  					     sizeof( invt_mediafile_t ),
>  					     off ) <= 0 ) {
> diff --git a/inventory/testmain.c b/inventory/testmain.c
> index cfd0654..d8c61e2 100644
> --- a/inventory/testmain.c
> +++ b/inventory/testmain.c
> @@ -22,6 +22,7 @@
>  #include <sys/file.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> +#include <assert.h>
>  #include "types.h"
>  #include "mlog.h"
>  #include "getopt.h"
> @@ -92,12 +93,12 @@ recons_test( int howmany )
>  		rval = get_invtrecord( fd, &sarr[i], 
>  				       sizeof( uuid_t ) + sizeof( size_t ), 0,
>  				       SEEK_CUR, BOOL_FALSE );
> -		ASSERT( rval > 0 );
> -		ASSERT( sarr[i].sz > 0 );
> +		assert( rval > 0 );
> +		assert( sarr[i].sz > 0 );
>  		sarr[i].buf = calloc( 1,  sarr[i].sz );
>  		rval = get_invtrecord( fd, sarr[i].buf,  sarr[i].sz, 0, SEEK_CUR,
>  				       BOOL_FALSE );
> -		ASSERT( rval > 0 );
> +		assert( rval > 0 );
>  	}
>  	
>  	
> @@ -263,9 +264,9 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  	printf("first time!\n");
>  	for (i=0; i<8; i++) {
>  		uuid_create( &fsidarr[i], &stat );
> -		ASSERT ( stat == uuid_s_ok );
> +		assert ( stat == uuid_s_ok );
>  		uuid_create( &sesidarr[i], &stat );
> -		ASSERT ( stat == uuid_s_ok );
> +		assert ( stat == uuid_s_ok );
>  	}
>  	fd = open( "uuids", O_RDWR | O_CREAT );
>  	PUT_REC(fd, (void *)fsidarr, sizeof (uuid_t) * 8, 0L );
> @@ -289,7 +290,7 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  		dev = dev_str[7];
>  		fsidp = &fsidarr[0]; /* j */
>  		tok1 = inv_open( INV_BY_UUID, INV_SEARCH_N_MOD, fsidp );
> -		ASSERT (tok1 != INV_TOKEN_NULL );
> +		assert (tok1 != INV_TOKEN_NULL );
>  
>  		uuid_create( &labelid, &stat );
>  		uuid_to_string( &labelid, &str, &stat );
> @@ -306,10 +307,10 @@ write_test( int nsess, int nstreams, int nmedia, int dumplevel )
>  					     dumplevel, nstreams, 
>  					     time(NULL),
>  					     mnt, dev );
> -		ASSERT (tok2 != INV_TOKEN_NULL );
> +		assert (tok2 != INV_TOKEN_NULL );
>  		for (m = 0; m<nstreams; m++) {
>  			tok3 = inv_stream_open( tok2,"/dev/rmt");
> -			ASSERT (tok3 != INV_TOKEN_NULL );
> +			assert (tok3 != INV_TOKEN_NULL );
>  
>  			for (k = 0; k<nmedia; k++ )
>  				CREAT_mfiles( tok3, &labelid, k*100,
> @@ -353,7 +354,7 @@ mp_test(int nstreams)
>  {
>  #if 0
>  	tok1 = inv_open( INV_BY_UUID, fsidp );
> -	ASSERT (tok1 != INV_TOKEN_NULL );
> +	assert (tok1 != INV_TOKEN_NULL );
>  
>  	tok2 = inv_writesession_open(tok1, fsidp,
>  				     &labelid,
> @@ -363,11 +364,11 @@ mp_test(int nstreams)
>  				     dumplevel, nstreams, 
>  				     time(NULL),
>  				     mnt, dev );
> -	ASSERT (tok2 != INV_TOKEN_NULL );
> +	assert (tok2 != INV_TOKEN_NULL );
>  
>  	for (m = 0; m<nstreams; m++) {
>  			tok3 = inv_stream_open( tok2,"/dev/rmt");
> -			ASSERT (tok3 != INV_TOKEN_NULL );
> +			assert (tok3 != INV_TOKEN_NULL );
>  
>  			for (k = 0; k<nmedia; k++ )
>  				CREAT_mfiles( tok3, &labelid, k*100,
> @@ -399,7 +400,7 @@ main(int argc, char *argv[])
>  
>  	progname = argv[0];
>  	sesfile = "sessions";
> -	ASSERT( argc > 1 );
> +	assert( argc > 1 );
>  	
>  	mlog_init( argc, argv );
>  
> diff --git a/librmt/rmtioctl.c b/librmt/rmtioctl.c
> index c49e96d..4c108fb 100644
> --- a/librmt/rmtioctl.c
> +++ b/librmt/rmtioctl.c
> @@ -30,6 +30,7 @@
>  #include <sys/ioctl.h>
>  #include <sys/mtio.h>
>  #include <sys/param.h>
> +#include <assert.h>
>  
>  /*
>   * uses old_mtget IRIX structure since we don't bother
> diff --git a/restore/bag.c b/restore/bag.c
> index b7d8fe2..8c7a216 100644
> --- a/restore/bag.c
> +++ b/restore/bag.c
> @@ -22,6 +22,7 @@
>  #include <sys/types.h>
>  #include <stdlib.h>
>  #include <memory.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -33,7 +34,7 @@ bag_alloc( void )
>  	bag_t *bagp;
>  
>  	bagp = ( bag_t * )calloc( 1, sizeof( bag_t ));
> -	ASSERT( bagp );
> +	assert( bagp );
>  	return bagp;
>  }
>  
> @@ -46,9 +47,9 @@ bag_insert( bag_t *bagp,
>  	register bagelem_t *nextp;
>  	register bagelem_t *prevp;
>  
> -	ASSERT( ! newp->be_loaded );
> +	assert( ! newp->be_loaded );
>  	newp->be_loaded = BOOL_TRUE;
> -	ASSERT( ! newp->be_bagp );
> +	assert( ! newp->be_bagp );
>  	newp->be_bagp = bagp;
>  
>  	newp->be_key = key;
> @@ -79,8 +80,8 @@ bag_remove( bag_t *bagp,
>  	register bagelem_t *nextp;
>  	register bagelem_t *prevp;
>  
> -	ASSERT( oldp->be_loaded );
> -	ASSERT( oldp->be_bagp == bagp );
> +	assert( oldp->be_loaded );
> +	assert( oldp->be_bagp == bagp );
>  
>  	nextp = oldp->be_nextp;
>  	prevp = oldp->be_prevp;
> @@ -90,7 +91,7 @@ bag_remove( bag_t *bagp,
>  
>  	if ( bagp->b_headp == oldp ) {
>  		if ( nextp == oldp ) {
> -			ASSERT( prevp == oldp );
> +			assert( prevp == oldp );
>  			bagp->b_headp = 0;
>  		} else {
>  			bagp->b_headp = nextp;
> @@ -121,8 +122,8 @@ bag_find( bag_t *bagp,
>  		*payloadpp = 0;
>  		return 0;
>  	} else {
> -		ASSERT( p->be_loaded );
> -		ASSERT( p->be_bagp == bagp );
> +		assert( p->be_loaded );
> +		assert( p->be_bagp == bagp );
>  		*payloadpp = p->be_payloadp;
>  		return p;
>  	}
> @@ -182,7 +183,7 @@ bag_free( bag_t *bagp )
>  		if ( p == bagp->b_headp ) {
>  			break;
>  		}
> -		ASSERT( p );
> +		assert( p );
>  	}
>  
>  	memset( ( void * )bagp, 0, sizeof( bag_t ));
> diff --git a/restore/content.c b/restore/content.c
> index f2d361b..4796aea 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -34,6 +34,7 @@
>  #include <utime.h>
>  #include <malloc.h>
>  #include <pthread.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "timeutil.h"
> @@ -912,14 +913,14 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( pers_desc_t ) <= PERS_DESCSZ );
> -	ASSERT( PERS_DESCSZ <= pgsz );
> -	ASSERT( ! ( pgsz % PERS_DESCSZ ));
> -	ASSERT( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
> +	assert( sizeof( pers_desc_t ) <= PERS_DESCSZ );
> +	assert( PERS_DESCSZ <= pgsz );
> +	assert( ! ( pgsz % PERS_DESCSZ ));
> +	assert( sizeof( extattrhdr_t ) == EXTATTRHDR_SZ );
>  
> -	ASSERT( ! ( perssz % pgsz ));
> +	assert( ! ( perssz % pgsz ));
>  
> -	ASSERT( SYNC_INIT == 0 );
> +	assert( SYNC_INIT == 0 );
>  
>  	mlog( MLOG_NITTY,
>  	      "sizeof( pers_desc_t ) == %d, pgsz == %d, perssz == %d \n",
> @@ -928,7 +929,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  	/* allocate transient state
>  	 */
>  	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
> -	ASSERT( tranp );
> +	assert( tranp );
>  
>  	/* allocate a qlock for establishing pi critical regions
>  	 */
> @@ -1208,7 +1209,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  	/* assume all streams contain a directory dump. streams will remove
>  	 * themselves from this bitset if they do not contain a directory dump.
>  	 */
> -	ASSERT( drivecnt <= sizeof(tranp->t_dirdumps) * NBBY );
> +	assert( drivecnt <= sizeof(tranp->t_dirdumps) * NBBY );
>  	tranp->t_dirdumps = ( 1ULL << drivecnt ) - 1;
>  
>  	/* the user may specify stdin as the restore source stream,
> @@ -1329,7 +1330,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  
>  	/* build a full pathname to pers. state file
>  	 */
> -	ASSERT( ! perspath );
> +	assert( ! perspath );
>  	perspath = open_pathalloc( tranp->t_hkdir, persname, 0 );
>  
>  	/* open, creating if non-existent
> @@ -1596,11 +1597,11 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  		intgen_t rval;
>  
>  		path1 = ( char * )calloc( 1, 2 * MAXPATHLEN );
> -		ASSERT( path1 );
> +		assert( path1 );
>  		path2 = ( char * )calloc( 1, 2 * MAXPATHLEN );
> -		ASSERT( path2 );
> -		ASSERT( persp->a.valpr );
> -		ASSERT( persp->s.valpr );
> +		assert( path2 );
> +		assert( persp->a.valpr );
> +		assert( persp->s.valpr );
>  		rval = chdir( persp->a.dstdir );
>  		if ( rval ) {
>  			mlog( MLOG_NORMAL, _(
> @@ -1673,7 +1674,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  		stpgcnt = persp->a.stpgcnt;
>  		newstpgcnt = stpgcnt;
>  		descpgcnt = persp->s.descpgcnt;
> -		ASSERT( resumepr );
> +		assert( resumepr );
>  		mlog( MLOG_VERBOSE, _(
>  		      "resuming restore previously begun %s\n"),
>  		      ctimennl( &persp->s.begintime ));
> @@ -1683,13 +1684,13 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  	/* unmap temp mapping of hdr, truncate, and remap hdr/subtrees
>  	 */
>  	rval = munmap( ( void * )persp, perssz );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	rval = ftruncate( tranp->t_persfd, ( off_t )perssz
>  					   +
>  					   ( off_t )( stpgcnt + descpgcnt )
>  					   *
>  					   ( off_t )pgsz );
> -	ASSERT( ! rval );
> +	assert( ! rval );
>  	stpgcnt = newstpgcnt;
>  	persp = ( pers_t * ) mmap_autogrow( perssz + stpgcnt * pgsz,
>  				   tranp->t_persfd, 0);
> @@ -1756,7 +1757,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  					+
>  					( STDESCALIGN - 1 );
>  				stdsz &= ~( STDESCALIGN - 1 );
> -				ASSERT( stdsz <= ( size_t )OFFMAX );
> +				assert( stdsz <= ( size_t )OFFMAX );
>  				stdescp->std_nextoff = ( off_t )stdsz;
>  				strcpy( stdescp->std_path, optarg );
>  				stdescp = ( stdesc_t * )
> @@ -1765,7 +1766,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  				break;
>  			}
>  		}
> -		ASSERT( stcnt == 0 );
> +		assert( stcnt == 0 );
>  	}
>  
>  	/* initialize the local extattr abstraction. must be done even if
> @@ -1801,7 +1802,7 @@ content_init( intgen_t argc, char *argv[ ], size64_t vmsz )
>  	 * referenced ONLY via the macros provided; the descriptors will be
>  	 * occasionally remapped, causing the ptr to change.
>  	 */
> -	ASSERT( ! descp );
> +	assert( ! descp );
>  	if ( descpgcnt ) {
>  		descp = ( pers_desc_t * ) mmap_autogrow( descpgcnt * pgsz,
>  						tranp->t_persfd,
> @@ -1932,9 +1933,9 @@ content_stream_restore( ix_t thrdix )
>  	/* allocate two path buffers
>  	 */
>  	path1 = ( char * )calloc( 1, 2 * MAXPATHLEN );
> -	ASSERT( path1 );
> +	assert( path1 );
>  	path2 = ( char * )calloc( 1, 2 * MAXPATHLEN );
> -	ASSERT( path2 );
> +	assert( path2 );
>  
>  	/* set the current directory to dstdir. the tree abstraction
>  	 * depends on the current directory being the root of the
> @@ -2081,7 +2082,7 @@ content_stream_restore( ix_t thrdix )
>  		      "dump found: checking\n" );
>  		matchpr = BOOL_FALSE;
>  		resumepr = ( scrhdrp->cih_dumpattr & CIH_DUMPATTR_RESUME );
> -		ASSERT( scrhdrp->cih_level >= 0 );
> +		assert( scrhdrp->cih_level >= 0 );
>  		level = ( ix_t )scrhdrp->cih_level;
>  		baseidp = resumepr
>  			  ?
> @@ -2246,7 +2247,7 @@ content_stream_restore( ix_t thrdix )
>  			return mlog_exit(EXIT_FAULT, rv);
>  		}
>  		dcaps = drivep->d_capabilities;
> -		ASSERT( fileh != DH_NULL );
> +		assert( fileh != DH_NULL );
>  		lock( );
>  		if ( tranp->t_sync3 == SYNC_BUSY ) {
>  			unlock( );
> @@ -2529,7 +2530,7 @@ content_stream_restore( ix_t thrdix )
>  			return mlog_exit(EXIT_FAULT, rv);
>  		}
>  		dcaps = drivep->d_capabilities;
> -		ASSERT( fileh > DH_NULL );
> +		assert( fileh > DH_NULL );
>  		if ( tranp->t_toconlypr ) {
>  			mlog( MLOG_VERBOSE, _(
>  			      "reading non-directory files\n") );
> @@ -2752,7 +2753,7 @@ content_statline( char **linespp[ ] )
>  			 percent,
>  			 (unsigned long long)tranp->t_direntcnt,
>  			 elapsed );
> -		ASSERT( strlen( statline[ 0 ] ) < STATLINESZ );
> +		assert( strlen( statline[ 0 ] ) < STATLINESZ );
>  		
>  		return 1;
>  	}
> @@ -2792,7 +2793,7 @@ content_statline( char **linespp[ ] )
>  		 (unsigned long long)inocnt,
>  		 percent,
>  		 elapsed );
> -	ASSERT( strlen( statline[ 0 ] ) < STATLINESZ );
> +	assert( strlen( statline[ 0 ] ) < STATLINESZ );
>  	
>  	/* return buffer to caller
>  	 */
> @@ -2880,7 +2881,7 @@ content_mediachange_query( void )
>  	}
>  	nochangeix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("continue");
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	responseix = dlog_multi_query( querystr,
>  				       querycnt,
>  				       choicestr,
> @@ -2920,7 +2921,7 @@ content_mediachange_query( void )
>  		choicecnt = 0;
>  		nochangeix = choicecnt;
>  		choicestr[ choicecnt++ ] = _("continue");
> -		ASSERT( choicecnt <= CHOICEMAX );
> +		assert( choicecnt <= CHOICEMAX );
>  		responseix = dlog_multi_query( querystr,
>  					       querycnt,
>  					       choicestr,
> @@ -2936,7 +2937,7 @@ content_mediachange_query( void )
>  					       nochangeix);/* sigquit ix */
>  		return _("continuing\n");
>  	}
> -	ASSERT( responseix == nochangeix );
> +	assert( responseix == nochangeix );
>  	return _("continuing\n");
>  }
>  
> @@ -3106,7 +3107,7 @@ applydirdump( drive_t *drivep,
>  					break;
>  				}
>  				namelen = strlen( dhdrp->dh_name );
> -				ASSERT( namelen <= NAME_MAX );
> +				assert( namelen <= NAME_MAX );
>  
>  				/* add this dirent to the tree.
>  				 */
> @@ -3263,7 +3264,7 @@ eatdirdump( drive_t *drivep,
>  				break;
>  			}
>  			namelen = strlen( dhdrp->dh_name );
> -			ASSERT( namelen <= NAME_MAX );
> +			assert( namelen <= NAME_MAX );
>  		}
>  	}
>  
> @@ -3525,7 +3526,7 @@ applynondirdump( drive_t *drivep,
>  				if ( cur_egrp.eg_ino < next_egrp.eg_ino
>  				     ||
>  				     next_egrp.eg_off > 0 ) {
> -					ASSERT( cur_egrp.eg_ino
> +					assert( cur_egrp.eg_ino
>  						<=
>  						next_egrp.eg_ino );
>  					pi_update_stats( bstatp->bs_blocks
> @@ -3706,8 +3707,8 @@ wipepersstate( void )
>  			       "%s/%s",
>  			       tranp->t_hkdir,
>  			       direntp->d_name );
> -		ASSERT( len > 0 );
> -		ASSERT( len < MAXPATHLEN );
> +		assert( len > 0 );
> +		assert( len < MAXPATHLEN );
>  		( void )unlink( pathname );
>  		closedir( dirp );
>  		dirp = opendir( tranp->t_hkdir );
> @@ -3732,7 +3733,7 @@ Inv_validate_cmdline( void )
>  	bool_t ok;
>  	bool_t rok;
>  
> -	ASSERT( ! persp->s.valpr );
> +	assert( ! persp->s.valpr );
>  
>  	ok = BOOL_FALSE;
>  	sessp = 0;
> @@ -3797,7 +3798,7 @@ Media_create( ix_t thrdix )
>  	Mediap->M_mrhdrp = mrhdrp;
>  	Mediap->M_crhdrp = crhdrp;
>  	Mediap->M_scrhdrp = scrhdrp;
> -	ASSERT( POS_UNKN == 0 );
> +	assert( POS_UNKN == 0 );
>  
>  	return Mediap;
>  }
> @@ -4079,7 +4080,7 @@ Media_mfile_next( Media_t *Mediap,
>  		case DRIVE_ERROR_EOD:
>  			Mediap->M_pos = POS_END;
>  			if ( Mediap->M_fsfixvalpr ) {
> -				ASSERT( purp != PURP_SEARCH );
> +				assert( purp != PURP_SEARCH );
>  				pi_hiteod( Mediap->M_fssix,
>  					   Mediap->M_fsoix );
>  			}
> @@ -4087,7 +4088,7 @@ Media_mfile_next( Media_t *Mediap,
>  		case DRIVE_ERROR_EOM:
>  			Mediap->M_pos = POS_END;
>  			if ( Mediap->M_fsfixvalpr ) {
> -				ASSERT( purp != PURP_SEARCH );
> +				assert( purp != PURP_SEARCH );
>  				pi_hiteom( Mediap->M_fssix,
>  					   Mediap->M_fsoix );
>  			}
> @@ -4206,7 +4207,7 @@ validate:
>  		/* if the purpose is to search, return this media file
>  		 */
>  		if ( purp == PURP_SEARCH ) {
> -			ASSERT( Mediap->M_pos == POS_ATHDR );
> +			assert( Mediap->M_pos == POS_ATHDR );
>  			return RV_OK;
>  		}
>  
> @@ -4457,9 +4458,9 @@ validate:
>  		/* if the purpose is dir, give it to the caller
>  		 */
>  		if ( purp == PURP_DIR ) {
> -			ASSERT( Mediap->M_pos == POS_ATHDR );
> +			assert( Mediap->M_pos == POS_ATHDR );
>  			if ( filehp ) {
> -				ASSERT( fileh != DH_NULL );
> +				assert( fileh != DH_NULL );
>  				*filehp = fileh;
>  			}
>  			return RV_OK;
> @@ -4471,9 +4472,9 @@ validate:
>  
>  		/* see if this media file contains any inodes not yet restored
>  		 */
> -		ASSERT( fileh != DH_NULL );
> +		assert( fileh != DH_NULL );
>  		pi_lock( );
> -		ASSERT( DH2F( fileh )->f_valpr );
> +		assert( DH2F( fileh )->f_valpr );
>  		begino = DH2F( fileh )->f_curegrp.eg_ino;
>  		endino = pi_scanfileendino( fileh );
>  		hassomepr = inomap_rst_needed( begino, endino );
> @@ -4532,8 +4533,8 @@ validate:
>  		 * and no check point, can still get there
>  		 * by doing dummy read of dirdump.
>  		 */
> -		ASSERT( fileh != DH_NULL );
> -		ASSERT( DH2F( fileh )->f_valpr );
> +		assert( fileh != DH_NULL );
> +		assert( DH2F( fileh )->f_valpr );
>  		resumepr = ( ( DH2F( fileh )->f_firstegrp.eg_ino
>  			       !=
>  			       DH2F( fileh )->f_curegrp.eg_ino )
> @@ -4616,7 +4617,7 @@ validate:
>  			rval = 0;
>  			break;
>  		default:
> -		    ASSERT( 0 );
> +		    assert( 0 );
>  		    rval = 1;
>  		    break;
>  		}
> @@ -4634,7 +4635,7 @@ validate:
>  		 */
>  		if ( ! rval ) {
>  			if ( filehp ) {
> -				ASSERT( fileh != DH_NULL );
> +				assert( fileh != DH_NULL );
>  				*filehp = fileh;
>  			}
>  			return RV_OK;
> @@ -4647,7 +4648,7 @@ validate:
>  		( * dop->do_end_read )( drivep );
>  		Mediap->M_pos = POS_UNKN;
>  		fileh = DH_NULL;
> -		ASSERT( purp == PURP_NONDIR );
> +		assert( purp == PURP_NONDIR );
>  		if ( pi_know_no_more_beyond_on_object( purp,
>  						       Mediap->M_fssix,
>  						       Mediap->M_fsoix,
> @@ -4735,7 +4736,7 @@ newmedia:
>  							   BOOL_FALSE );
>  			break;
>  		default:
> -			ASSERT( 0 );
> +			assert( 0 );
>  		}
>  
>  		if ( ! bagp && ! knownholespr && ! maybeholespr ) {
> @@ -4796,7 +4797,7 @@ newmedia:
>  					pi_neededobjs_free( bagp );
>  					bagp = 0;
>  				}
> -				ASSERT( sistr );
> +				assert( sistr );
>  				mlog( MLOG_NORMAL | MLOG_NOTE | MLOG_MEDIA, _(
>  				      "please change media: "
>  				      "type %s to confirm media change\n"),
> @@ -4928,19 +4929,19 @@ pi_allocdesc( dh_t *deschp )
>  		/* first unmap if any existing descriptors
>  		 */
>  		if ( descp ) {
> -			ASSERT( olddescpgcnt > 0 );
> +			assert( olddescpgcnt > 0 );
>  			rval = munmap( ( void * )descp,
>  				       olddescpgcnt * pgsz );
> -			ASSERT( ! rval );
> +			assert( ! rval );
>  			descp = 0;
>  		} else {
> -			ASSERT( olddescpgcnt == 0 );
> +			assert( olddescpgcnt == 0 );
>  		}
>  
>  		/* remap with DAU more pages of descriptors
>  		 */
> -		ASSERT( stpgcnt <= ( ix_t )INTGENMAX );
> -		ASSERT( newdescpgcnt > 0 );
> +		assert( stpgcnt <= ( ix_t )INTGENMAX );
> +		assert( newdescpgcnt > 0 );
>  		descp = ( pers_desc_t * ) mmap_autogrow( newdescpgcnt * pgsz,
>  						tranp->t_persfd,
>  						( off_t )perssz
> @@ -4973,7 +4974,7 @@ pi_allocdesc( dh_t *deschp )
>  	desch = persp->s.descfreeh;
>  	persp->s.descfreeh = DH2D( desch )->d_nexth;
>  	memset( ( void * )DH2D( desch ), 0, sizeof( pers_desc_t ));
> -	ASSERT( desch != DH_NULL );
> +	assert( desch != DH_NULL );
>  	*deschp = desch;
>  	return BOOL_TRUE;
>  }
> @@ -5041,7 +5042,7 @@ pi_insertfile( ix_t drivecnt,
>  	      strmix++,
>  	      strmh = DH2S( strmh )->s_nexth )
>  		;
> -	ASSERT( strmh != DH_NULL );
> +	assert( strmh != DH_NULL );
>  
>  	/* get handle to this object by walking/constructing this stream's
>  	 * object list, up to the desired object
> @@ -5124,10 +5125,10 @@ pi_insertfile( ix_t drivecnt,
>  	     &&
>  	     ! DH2O( prevobjh )->o_lmfknwnpr ) {
>  		size_t prevmfcnt;
> -		ASSERT( DH2O( objh )->o_fmfsix > DH2O( prevobjh )->o_fmfsix );
> +		assert( DH2O( objh )->o_fmfsix > DH2O( prevobjh )->o_fmfsix );
>  		prevmfcnt = DH2O( objh )->o_fmfsix - DH2O( prevobjh )->o_fmfsix;
>  		pi_unlock( );
> -		ASSERT( mediaix > 0 );
> +		assert( mediaix > 0 );
>  		( void )pi_insertfile( drivecnt,
>  				       driveix,
>  				       mediaix - 1,
> @@ -5190,8 +5191,8 @@ pi_insertfile( ix_t drivecnt,
>  	/* update the media file fields not yet valid
>  	 */
>  	if ( egrpvalpr && ! DH2F( fileh )->f_valpr ) {
> -		ASSERT( ! ( DH2F( fileh )->f_flags & PF_INV ));
> -		ASSERT( ! ( DH2F( fileh )->f_flags & PF_TERM ));
> +		assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
> +		assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
>  		DH2F( fileh )->f_firstegrp.eg_ino = startino;
>  		DH2F( fileh )->f_firstegrp.eg_off = startoffset;
>  		DH2F( fileh )->f_curegrp = DH2F( fileh )->f_firstegrp;
> @@ -5233,7 +5234,7 @@ pi_addfile( Media_t *Mediap,
>  	if ( ! persp->s.stat_valpr ) {
>  		persp->s.stat_inocnt = scrhdrp->cih_inomap_nondircnt;
>  		persp->s.stat_inodone = 0;
> -		ASSERT( scrhdrp->cih_inomap_datasz <= OFF64MAX );
> +		assert( scrhdrp->cih_inomap_datasz <= OFF64MAX );
>  		persp->s.stat_datacnt = ( off64_t )scrhdrp->cih_inomap_datasz;
>  		persp->s.stat_datadone = 0;
>  		persp->s.stat_valpr = BOOL_TRUE;
> @@ -5301,7 +5302,7 @@ pi_addfile( Media_t *Mediap,
>  		if ( fileh == DH_NULL ) {
>  			return DH_NULL;
>  		}
> -		ASSERT( drhdrp->dh_drivecnt > 0 );
> +		assert( drhdrp->dh_drivecnt > 0 );
>  		if ( drhdrp->dh_driveix < drhdrp->dh_drivecnt - 1 ) {
>  			/* if this is not in the last stream, we know
>  			 * there is at least one other media file in
> @@ -5433,12 +5434,12 @@ pi_addfile( Media_t *Mediap,
>  						  &rval );
>  				switch( rval ) {
>  				case 0:
> -					ASSERT( nread == ( intgen_t )bufszincr );
> +					assert( nread == ( intgen_t )bufszincr );
>  					buflen += ( size_t )nread;
>  					bufsz += bufszincr;
>  					bufp = ( char * )realloc(( void * )bufp,
>  								 bufsz );
> -					ASSERT( bufp );
> +					assert( bufp );
>  					continue;
>  				case DRIVE_ERROR_EOD:
>  				case DRIVE_ERROR_EOF:
> @@ -5495,7 +5496,7 @@ pi_addfile( Media_t *Mediap,
>  		return fileh;
>  	}
>  
> -	ASSERT( 0 );
> +	assert( 0 );
>  	return DH_NULL;
>  }
>  
> @@ -5829,7 +5830,7 @@ pi_scanfileendino( dh_t fileh )
>  	dh_t strmh;
>  	ix_t mode = 0;
>  
> -	ASSERT( fileh != DH_NULL );
> +	assert( fileh != DH_NULL );
>  
>  	/* traverse the pi tree, looking for the next media file after
>  	 */
> @@ -5863,13 +5864,13 @@ pi_scanfileendino( dh_t fileh )
>  			if ( DH2F( nexth )->f_valpr ) {
>  			    xfs_ino_t ino;
>  
> -			    ASSERT( ! ( DH2F( nexth )->f_flags & PF_INV ));
> -			    ASSERT( ! ( DH2F( nexth )->f_flags & PF_TERM ));
> +			    assert( ! ( DH2F( nexth )->f_flags & PF_INV ));
> +			    assert( ! ( DH2F( nexth )->f_flags & PF_TERM ));
>  			    if ( DH2F( nexth )->f_firstegrp.eg_off ) {
>  				ino =  DH2F( nexth )->f_firstegrp.eg_ino;
>  				return ino;
>  			    } else {
> -				ASSERT( DH2F( nexth )->f_firstegrp.eg_ino > 0 );
> +				assert( DH2F( nexth )->f_firstegrp.eg_ino > 0 );
>  				ino =  DH2F( nexth )->f_firstegrp.eg_ino - 1;
>  				return ino;
>  			    }
> @@ -5894,12 +5895,12 @@ pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
>  	dh_t follh = DH_NULL;
>  
>  
> -	ASSERT( thisfileh != DH_NULL );
> +	assert( thisfileh != DH_NULL );
>  
>  	/* traverse the pi tree, looking for fileh
>  	 */
>  	pi_lock( );
> -	ASSERT( DH2F( thisfileh )->f_valpr );
> +	assert( DH2F( thisfileh )->f_valpr );
>  
>  	for ( strmh = persp->s.strmheadh
>  	      ;
> @@ -5924,14 +5925,14 @@ pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
>  			if ( fileh == thisfileh ) {
>  			    thisfoundpr = BOOL_TRUE;
>  			} else if ( DH2F( fileh )->f_valpr ) {
> -			    ASSERT( ! ( DH2F( fileh )->f_flags & PF_INV ));
> -			    ASSERT( ! ( DH2F( fileh )->f_flags & PF_TERM ));
> +			    assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
> +			    assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
>  			    prech = fileh;
>  			}
>  		    } else if ( DH2F( fileh )->f_valpr ) {
> -			ASSERT( ! ( DH2F( fileh )->f_flags & PF_INV ));
> -			ASSERT( ! ( DH2F( fileh )->f_flags & PF_TERM ));
> -			ASSERT( follh == DH_NULL );
> +			assert( ! ( DH2F( fileh )->f_flags & PF_INV ));
> +			assert( ! ( DH2F( fileh )->f_flags & PF_TERM ));
> +			assert( follh == DH_NULL );
>  			follh = fileh;
>  			goto done;
>  		    }
> @@ -5940,7 +5941,7 @@ pi_bracketneededegrps( dh_t thisfileh, egrp_t *first_egrp, egrp_t *next_egrp )
>  	}
>  done:
>  
> -	ASSERT( thisfoundpr );
> +	assert( thisfoundpr );
>  
>  	/* initially the lower bracket is this file descriptor's
>  	 * current egrp. this catches the case where a previous restore
> @@ -5979,7 +5980,7 @@ static void
>  pi_update_stats( off64_t sz )
>  {
>  	pi_lock( );
> -	ASSERT( persp->s.stat_valpr );
> +	assert( persp->s.stat_valpr );
>  	persp->s.stat_inodone++;
>  	persp->s.stat_datadone += sz;
>  	pi_unlock( );
> @@ -6011,7 +6012,7 @@ pi_iter_alloc( void )
>  	pi_iter_t *iterp;
>  
>  	iterp = ( pi_iter_t * )calloc( 1, sizeof( pi_iter_t ));
> -	ASSERT( iterp );
> +	assert( iterp );
>  	return iterp;
>  }
>  
> @@ -6026,7 +6027,7 @@ pi_iter_nextfileh( pi_iter_t *iterp,
>  		   bool_t *objmissingprp,
>  		   bool_t *filemissingprp )
>  {
> -	ASSERT( ! iterp->donepr );
> +	assert( ! iterp->donepr );
>  
>  	if ( persp->s.strmheadh == DH_NULL ) {
>  		iterp->donepr = BOOL_TRUE;
> @@ -6034,7 +6035,7 @@ pi_iter_nextfileh( pi_iter_t *iterp,
>  	}
>  
>  	if ( ! iterp->initializedpr ) {
> -		ASSERT( persp->s.strmheadh != DH_NULL );
> +		assert( persp->s.strmheadh != DH_NULL );
>  		iterp->strmh = persp->s.strmheadh;
>  		iterp->objh = DH2S( iterp->strmh )->s_cldh;
>  		if ( iterp->objh == DH_NULL ) {
> @@ -6199,8 +6200,8 @@ pi_neededobjs_nondir_alloc( bool_t *knownholesprp,
>  			headegrp.eg_ino = INO64MAX;
>  			headegrp.eg_off = OFF64MAX;
>  		} else {
> -			ASSERT( ! ( DH2F( headh )->f_flags & PF_INV ));
> -			ASSERT( ! ( DH2F( headh )->f_flags & PF_TERM ));
> +			assert( ! ( DH2F( headh )->f_flags & PF_INV ));
> +			assert( ! ( DH2F( headh )->f_flags & PF_TERM ));
>  			headegrp = DH2F( headh )->f_firstegrp;
>  		}
>  
> @@ -6369,15 +6370,15 @@ pi_neededobjs_free( bag_t *bagp )
>  	size64_t dummykey;
>  	void *dummypayloadp;
>  
> -	ASSERT( bagp );
> +	assert( bagp );
>  
>  	bagiter_init( bagp, &bagiter );
>  
>  	bagobjp = 0;
>  	while (( bagelemp = bagiter_next( &bagiter, ( void ** )&bagobjp ) )) {
>  		bag_remove( bagp, bagelemp, &dummykey, &dummypayloadp );
> -		ASSERT( bagobjp );
> -		ASSERT( bagobjp == ( bagobj_t * )dummypayloadp );
> +		assert( bagobjp );
> +		assert( bagobjp == ( bagobj_t * )dummypayloadp );
>  		free( ( void * )bagobjp );
>  		bagobjp = 0;
>  	}
> @@ -6441,7 +6442,7 @@ pi_hiteod( ix_t strmix, ix_t objix )
>  	      ix++,
>  	      strmh = DH2S( strmh )->s_nexth )
>  		;
> -	ASSERT( strmh != DH_NULL );
> +	assert( strmh != DH_NULL );
>  
>  	/* get index to last object in stream
>  	 */
> @@ -6451,7 +6452,7 @@ pi_hiteod( ix_t strmix, ix_t objix )
>  	      ;
>  	      objh = DH2O( objh )->o_nexth, objcnt++ )
>  		;
> -	ASSERT( objcnt != 0 );
> +	assert( objcnt != 0 );
>  	lastobjix = objcnt - 1;
>  	
>  	pi_unlock( );
> @@ -6504,7 +6505,7 @@ pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
>  	      ix++,
>  	      strmh = DH2S( strmh )->s_nexth )
>  		;
> -	ASSERT( strmh != DH_NULL );
> +	assert( strmh != DH_NULL );
>  
>  	/* get index to last object in stream
>  	 */
> @@ -6514,7 +6515,7 @@ pi_hitnextdump( ix_t strmix, ix_t objix, ix_t lastfileix )
>  	      ;
>  	      objh = DH2O( objh )->o_nexth, objcnt++ )
>  		;
> -	ASSERT( objcnt != 0 );
> +	assert( objcnt != 0 );
>  	lastobjix = objcnt - 1;
>  	
>  	pi_unlock( );
> @@ -6549,7 +6550,7 @@ pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
>  	dh_t objh;
>  	dh_t fileh;
>  
> -	ASSERT( purp == PURP_DIR || purp == PURP_NONDIR );
> +	assert( purp == PURP_DIR || purp == PURP_NONDIR );
>  
>  	pi_lock( );
>  
> @@ -6563,7 +6564,7 @@ pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
>  	      ix++,
>  	      strmh = DH2S( strmh )->s_nexth )
>  		;
> -	ASSERT( strmh != DH_NULL );
> +	assert( strmh != DH_NULL );
>  
>  	/* get handle to indexed object
>  	 */
> @@ -6574,7 +6575,7 @@ pi_know_no_more_on_object( purp_t purp, ix_t strmix, ix_t objix )
>  	      ix++,
>  	      objh = DH2O( objh )->o_nexth )
>  		;
> -	ASSERT( objh != DH_NULL );
> +	assert( objh != DH_NULL );
>  	
>  	/* if don't know last media file on object, return FALSE
>  	 */
> @@ -6627,7 +6628,7 @@ pi_know_no_more_beyond_on_object( purp_t purp,
>  	dh_t objh;
>  	dh_t fileh;
>  
> -	ASSERT( purp == PURP_DIR || purp == PURP_NONDIR );
> +	assert( purp == PURP_DIR || purp == PURP_NONDIR );
>  
>  	pi_lock( );
>  
> @@ -6641,7 +6642,7 @@ pi_know_no_more_beyond_on_object( purp_t purp,
>  	      ix++,
>  	      strmh = DH2S( strmh )->s_nexth )
>  		;
> -	ASSERT( strmh != DH_NULL );
> +	assert( strmh != DH_NULL );
>  
>  	/* get handle to indexed object
>  	 */
> @@ -6653,7 +6654,7 @@ pi_know_no_more_beyond_on_object( purp_t purp,
>  	      ix++,
>  	      objh = DH2O( objh )->o_nexth )
>  		;
> -	ASSERT( objh != DH_NULL );
> +	assert( objh != DH_NULL );
>  	
>  	/* if don't know last media file on object, return FALSE
>  	 */
> @@ -6741,7 +6742,7 @@ addobj( bag_t *bagp,
>  	bagobj_t *bagobjp;
>  
>  	bagobjp = ( bagobj_t * )calloc( 1, sizeof( bagobj_t ));
> -	ASSERT( bagobjp );
> +	assert( bagobjp );
>  	uuid_copy(bagobjp->id, *idp);
>  	strncpy( bagobjp->label,
>  		 label,
> @@ -6761,7 +6762,7 @@ cntobj( bag_t *bagp )
>  	bagobj_t *bagobjp;
>  	size_t cnt;
>  
> -	ASSERT( bagp );
> +	assert( bagp );
>  
>  	bagiter_init( bagp, &bagiter );
>  	cnt = 0;
> @@ -6833,7 +6834,7 @@ askinvforbaseof( uuid_t baseid, inv_session_t *sessp )
>  	/* close the inventory
>  	 */
>  	ok = inv_close( invtok );
> -	ASSERT( ok );
> +	assert( ok );
>  
>  	/* return id of base session
>  	 */
> @@ -6933,7 +6934,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* query: ask if media changed or declined
> @@ -6950,7 +6951,7 @@ retry:
>  	}
>  	querycnt = 0;
>  	querystr[ querycnt++ ] = question;
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	dontix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("media change declined");
> @@ -6965,7 +6966,7 @@ retry:
>  	}
>  	doix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("media changed");
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	sigintix = IXMAX - 1;
>  
>  	responseix = dlog_multi_query( querystr,
> @@ -6988,7 +6989,7 @@ retry:
>  		ackstr[ ackcnt++ ] = _("media change aborted\n");
>  	} else if ( responseix == invstatix ) {
>  		ackstr[ ackcnt++ ] = "\n";
> -		ASSERT( ackcnt <= ACKMAX );
> +		assert( ackcnt <= ACKMAX );
>  		dlog_multi_ack( ackstr,
>  				ackcnt );
>  		pi_show_nomloglock( );
> @@ -6997,13 +6998,13 @@ retry:
>  		postamblestr[ postamblecnt++ ] = "\n";
>  		postamblestr[ postamblecnt++ ] = fold;
>  		postamblestr[ postamblecnt++ ] = "\n\n";
> -		ASSERT( postamblecnt <= POSTAMBLEMAX );
> +		assert( postamblecnt <= POSTAMBLEMAX );
>  		dlog_end( postamblestr,
>  			  postamblecnt );
>  		goto retry;
>  	} else if ( responseix == neededix ) {
>  		ackstr[ ackcnt++ ] = "\n";
> -		ASSERT( ackcnt <= ACKMAX );
> +		assert( ackcnt <= ACKMAX );
>  		dlog_multi_ack( ackstr,
>  				ackcnt );
>  		display_needed_objects( purp,
> @@ -7015,16 +7016,16 @@ retry:
>  		postamblestr[ postamblecnt++ ] = "\n";
>  		postamblestr[ postamblecnt++ ] = fold;
>  		postamblestr[ postamblecnt++ ] = "\n\n";
> -		ASSERT( postamblecnt <= POSTAMBLEMAX );
> +		assert( postamblecnt <= POSTAMBLEMAX );
>  		dlog_end( postamblestr,
>  			  postamblecnt );
>  		goto retry;
>  	} else {
> -		ASSERT( responseix == sigintix );
> +		assert( responseix == sigintix );
>  		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
>  	}
>  
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_multi_ack( ackstr,
>  			ackcnt );
>  
> @@ -7033,7 +7034,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> @@ -7089,7 +7090,7 @@ retry:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* display vital stats and ask if this one should be restored
> @@ -7105,7 +7106,7 @@ retry:
>  			 "the following dump has been found"
>  			 "\n\n") );
>  	}
> -	ASSERT( strlen( introstring ) < sizeof( introstring ));
> +	assert( strlen( introstring ) < sizeof( introstring ));
>  	display_dump_label( BOOL_FALSE,
>  			    MLOG_NORMAL | MLOG_BARE,
>  			    introstring,
> @@ -7122,14 +7123,14 @@ retry:
>  			_("\ninteractively restore from this dump?\n")
>  				: _("\nrestore this dump?\n");
>  	}
> -	ASSERT( querycnt <= QUERYMAX );
> +	assert( querycnt <= QUERYMAX );
>  	choicecnt = 0;
>  	dontix = choicecnt;
>  	choicestr[ choicecnt++ ] = _("skip");
>  	doix = choicecnt;
>  	choicestr[ choicecnt++ ] = (persp->a.interpr) ?
>  				_("interactively restore\n") : _("restore\n");
> -	ASSERT( choicecnt <= CHOICEMAX );
> +	assert( choicecnt <= CHOICEMAX );
>  	sigintix = IXMAX - 1;
>  
>  	responseix = dlog_multi_query( querystr,
> @@ -7153,11 +7154,11 @@ retry:
>  	} else if ( responseix == dontix ) {
>  		ackstr[ ackcnt++ ] = _("dump skipped\n");
>  	} else {
> -		ASSERT( responseix == sigintix );
> +		assert( responseix == sigintix );
>  		ackstr[ ackcnt++ ] = _("keyboard interrupt\n");
>  	}
>  
> -	ASSERT( ackcnt <= ACKMAX );
> +	assert( ackcnt <= ACKMAX );
>  	dlog_multi_ack( ackstr,
>  			ackcnt );
>  
> @@ -7166,7 +7167,7 @@ retry:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr,
>  		  postamblecnt );
>  
> @@ -7329,8 +7330,8 @@ restore_file_cb( void *cp, bool_t linkpr, char *path1, char *path2 )
>  			return BOOL_FALSE;
>  		}
>  	} else if ( ! tranp->t_toconlypr ) {
> -		ASSERT( path1 );
> -		ASSERT( path2 );
> +		assert( path1 );
> +		assert( path2 );
>  		mlog( MLOG_TRACE,
>  		      "linking %s to %s\n",
>  		      path1,
> @@ -7523,7 +7524,7 @@ restore_reg( drive_t *drivep,
>  		/* set the extended inode flags, except those which must
>  		 * be set only after all data has been restored.
>  		 */
> -		ASSERT( bstatp->bs_extsize >= 0 );
> +		assert( bstatp->bs_extsize >= 0 );
>  		memset((void *)&fsxattr, 0, sizeof( fsxattr ));
>  		fsxattr.fsx_xflags = bstatp->bs_xflags & ~POST_DATA_XFLAGS;
>  		fsxattr.fsx_extsize = (u_int32_t) bstatp->bs_extsize;
> @@ -7604,7 +7605,7 @@ restore_extent_group( drive_t *drivep,
>  		 */
>  		if ( ehdr.eh_type == EXTENTHDR_TYPE_ALIGN ) {
>  			size_t sz;
> -			ASSERT( ehdr.eh_sz <= INTGENMAX );
> +			assert( ehdr.eh_sz <= INTGENMAX );
>  			sz = ( size_t )ehdr.eh_sz;
>  			rv = discard_padding( sz, drivep );
>  			if ( rv != RV_OK ) {
> @@ -7628,7 +7629,7 @@ restore_extent_group( drive_t *drivep,
>  
>  		/* real data
>  		 */
> -		ASSERT( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
> +		assert( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
>  		bytesread = 0;
>  		rv = restore_extent( fhdrp,
>  				     &ehdr,
> @@ -7971,7 +7972,7 @@ restore_symlink( drive_t *drivep,
>  
>  	/* symlinks always have one extent
>  	 */
> -	ASSERT( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
> +	assert( ehdr.eh_type == EXTENTHDR_TYPE_DATA );
>  
>  	/* read the link path extent
>  	 */
> @@ -8006,7 +8007,7 @@ restore_symlink( drive_t *drivep,
>  		}
>  		return BOOL_FALSE;
>  	}
> -	ASSERT( ( off64_t )nread == ehdr.eh_sz );
> +	assert( ( off64_t )nread == ehdr.eh_sz );
>  	if ( ! scratch ) {
>  		if ( path ) {
>  			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
> @@ -8109,7 +8110,7 @@ read_filehdr( drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs )
>  	default:
>  		return RV_CORE;
>  	}
> -	ASSERT( ( size_t )nread == sizeof( *fhdrp ));
> +	assert( ( size_t )nread == sizeof( *fhdrp ));
>  
>  	mlog( MLOG_NITTY,
>  	      "read file hdr off %lld flags 0x%x ino %llu mode 0x%08x\n",
> @@ -8168,7 +8169,7 @@ read_extenthdr( drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs )
>  	default:
>  		return RV_CORE;
>  	}
> -	ASSERT( ( size_t )nread == sizeof( *ehdrp ));
> +	assert( ( size_t )nread == sizeof( *ehdrp ));
>  
>  	mlog( MLOG_NITTY,
>  	      "read extent hdr size %lld offset %lld type %d flags %08x\n",
> @@ -8208,8 +8209,8 @@ read_dirent( drive_t *drivep,
>  	direnthdr_t tmpdh;
>  	char *namep;    // beginning of name following the direnthdr_t
>  
> -	ASSERT( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
> -	ASSERT( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
> +	assert( sizeof( direnthdr_t ) == DIRENTHDR_SZ );
> +	assert( sizeof( direnthdr_v1_t ) == DIRENTHDR_SZ );
>  
>  	/* read the head of the dirent
>  	 */
> @@ -8236,7 +8237,7 @@ read_dirent( drive_t *drivep,
>  	default:
>  		return RV_CORE;
>  	}
> -	ASSERT( ( size_t )nread == DIRENTHDR_SZ );
> +	assert( ( size_t )nread == DIRENTHDR_SZ );
>  
>  	if ( grhdrp->gh_version >= GLOBAL_HDR_VERSION_3 ) {
>  		xlate_direnthdr(&tmpdh, dhdrp, 1);
> @@ -8279,15 +8280,15 @@ read_dirent( drive_t *drivep,
>  	/* if null, return
>  	 */
>  	if ( dhdrp->dh_ino == 0 ) {
> -		ASSERT( ( size_t )dhdrp->dh_sz == sizeof( direnthdr_t ));
> +		assert( ( size_t )dhdrp->dh_sz == sizeof( direnthdr_t ));
>  		return RV_OK;
>  	}
>  
>  	/* read the remainder of the dirent.
>  	 */
> -	ASSERT( ( size_t )dhdrp->dh_sz <= direntbufsz );
> -	ASSERT( ( size_t )dhdrp->dh_sz >= sizeof( direnthdr_t ));
> -	ASSERT( ! ( ( size_t )dhdrp->dh_sz & ( DIRENTHDR_ALIGN - 1 )));
> +	assert( ( size_t )dhdrp->dh_sz <= direntbufsz );
> +	assert( ( size_t )dhdrp->dh_sz >= sizeof( direnthdr_t ));
> +	assert( ! ( ( size_t )dhdrp->dh_sz & ( DIRENTHDR_ALIGN - 1 )));
>  	if ( ( size_t )dhdrp->dh_sz > sizeof( direnthdr_t )) {
>  		size_t remsz = ( size_t )dhdrp->dh_sz - sizeof( direnthdr_t );
>  		nread = read_buf( namep,
> @@ -8313,7 +8314,7 @@ read_dirent( drive_t *drivep,
>  		default:
>  			return RV_CORE;
>  		}
> -		ASSERT( ( size_t ) nread == remsz );
> +		assert( ( size_t ) nread == remsz );
>  	}
>  
>  	return RV_OK;
> @@ -8353,7 +8354,7 @@ read_extattrhdr( drive_t *drivep, extattrhdr_t *ahdrp, bool_t ahcs )
>  	default:
>  		return RV_CORE;
>  	}
> -	ASSERT( ( size_t )nread == sizeof( *ahdrp ));
> +	assert( ( size_t )nread == sizeof( *ahdrp ));
>  
>  	mlog( MLOG_NITTY,
>  	      "read extattr hdr sz %u valoff %u flags 0x%x valsz %u cs 0x%x\n",
> @@ -8408,7 +8409,7 @@ discard_padding( size_t sz, drive_t *drivep )
>  			  &rval );
>  	switch( rval ) {
>  	case 0:
> -		ASSERT( ( size_t )nread == sz );
> +		assert( ( size_t )nread == sz );
>  		return RV_OK;
>  	case DRIVE_ERROR_EOF:
>  	case DRIVE_ERROR_EOD:
> @@ -8444,11 +8445,11 @@ restore_extent( filehdr_t *fhdrp,
>  	*bytesreadp = 0;
>  
>  	if ( fd != -1 ) {
> -		ASSERT( path );
> +		assert( path );
>  		/* seek to the beginning of the extent.
>  		 * must be on a basic fs blksz boundary.
>  		 */
> -		ASSERT( ( off & ( off64_t )( BBSIZE - 1 )) == 0 );
> +		assert( ( off & ( off64_t )( BBSIZE - 1 )) == 0 );
>  		new_off = lseek64(  fd, off, SEEK_SET );
>  		if ( new_off < 0 ) {
>  			mlog( MLOG_NORMAL | MLOG_WARNING, _(
> @@ -8462,7 +8463,7 @@ restore_extent( filehdr_t *fhdrp,
>  			fd = -1;
>  			new_off = off;
>  		}
> -		ASSERT( new_off == off );
> +		assert( new_off == off );
>  	}
>  	if ( (fd != -1) && (bstatp->bs_xflags & XFS_XFLAG_REALTIME) ) {
>  		if ( (ioctl(fd, XFS_IOC_DIOINFO, &da) < 0) ) {
> @@ -8530,14 +8531,14 @@ restore_extent( filehdr_t *fhdrp,
>  			return rv;
>  		}
>  		if ( off >= bstatp->bs_size ) {
> -			ASSERT( off == bstatp->bs_size );
> +			assert( off == bstatp->bs_size );
>  			ntowrite = 0;
>  		} else if ((off64_t)sup_bufsz > bstatp->bs_size - off ) {
>  			ntowrite = ( size_t )( bstatp->bs_size - off );
>  		} else {
>  			ntowrite = sup_bufsz;
>  		}
> -		ASSERT( ntowrite <= ( size_t )INTGENMAX );
> +		assert( ntowrite <= ( size_t )INTGENMAX );
>  		if ( ntowrite > 0 ) {
>  			*bytesreadp += ( off64_t )ntowrite;
>  			if ( fd != -1 ) {
> @@ -8562,7 +8563,7 @@ restore_extent( filehdr_t *fhdrp,
>  				      tmp_off += ( off64_t )rval ) {
>  					int rttrunc = 0;
>  					int trycnt = 0;
> -					ASSERT( remaining
> +					assert( remaining
>  						<=
>  						( size_t )INTGENMAX );
>  					/*
> @@ -8608,7 +8609,7 @@ restore_extent( filehdr_t *fhdrp,
>  						nwritten = rval;
>  						break;
>  					}
> -					ASSERT( ( size_t )rval <= remaining );
> +					assert( ( size_t )rval <= remaining );
>  					if ( rval < remaining ) {
>  						mlog( MLOG_NORMAL | MLOG_WARNING,
>  						      _("attempt to "
> @@ -8644,7 +8645,7 @@ restore_extent( filehdr_t *fhdrp,
>  				      off,
>  				      strerror( errno ));
>  			} else {
> -				ASSERT( ( size_t )nwritten < ntowrite );
> +				assert( ( size_t )nwritten < ntowrite );
>  				mlog( MLOG_NORMAL, _(
>  				      "attempt to write %u bytes to %s at "
>  				      "offset %lld failed: only %d bytes "
> @@ -8657,7 +8658,7 @@ restore_extent( filehdr_t *fhdrp,
>  			/* stop attempting to write, but complete reads
>  			 */
>  			fd = -1;
> -			ASSERT( ntowrite <= ( size_t )INTGENMAX );
> +			assert( ntowrite <= ( size_t )INTGENMAX );
>  			nwritten = ( intgen_t )ntowrite;
>  		}
>  		sz -= ( off64_t )sup_bufsz;
> @@ -8673,7 +8674,7 @@ static size_t extattrbufsz = 0; /* size of each extattr buffer */
>  static bool_t
>  extattr_init( size_t drivecnt )
>  {
> -	ASSERT( ! extattrbufp );
> +	assert( ! extattrbufp );
>  	extattrbufsz = EXTATTRHDR_SZ		/* dump hdr */
>  		       +
>  		       NAME_MAX			/* attribute name */
> @@ -8721,7 +8722,7 @@ restore_extattr( drive_t *drivep,
>  	bstat_t *bstatp = &fhdrp->fh_stat;
>  	bool_t isfilerestored = BOOL_FALSE;
>  
> -	ASSERT( extattrbufp );
> +	assert( extattrbufp );
>  
>  	if ( ! isdirpr )
>  		isfilerestored = partial_check(bstatp->bs_ino,  bstatp->bs_size);
> @@ -8745,8 +8746,8 @@ restore_extattr( drive_t *drivep,
>  		}
>  
>  		recsz = ( size_t )ahdrp->ah_sz;
> -		ASSERT( recsz <= extattrbufsz );
> -		ASSERT( recsz >= EXTATTRHDR_SZ );
> +		assert( recsz <= extattrbufsz );
> +		assert( recsz >= EXTATTRHDR_SZ );
>  		nread = read_buf( ( char * )&ahdrp[ 1 ],
>  				  recsz - EXTATTRHDR_SZ,
>  				  ( void * )drivep,
> @@ -8769,7 +8770,7 @@ restore_extattr( drive_t *drivep,
>  		default:
>  			return RV_CORE;
>  		}
> -		ASSERT( nread == ( intgen_t )( recsz - EXTATTRHDR_SZ ));
> +		assert( nread == ( intgen_t )( recsz - EXTATTRHDR_SZ ));
>  
>  		if ( ! persp->a.restoreextattrpr && ! persp->a.restoredmpr ) {
>  			continue;
> @@ -8784,7 +8785,7 @@ restore_extattr( drive_t *drivep,
>  		 * extended attributes.
>  		 */
>  		if ( isdirpr ) {
> -			ASSERT( ! path );
> +			assert( ! path );
>  			if ( dah != DAH_NULL ) {
>  				dirattr_addextattr( dah, ahdrp );
>  			}
> @@ -9297,7 +9298,7 @@ pi_show( char *introstring )
>  	strbuflen = sprintf( strbuf,
>  			     "persistent inventory media file tree%s",
>  			     introstring );
> -	ASSERT( ( size_t )strbuflen < sizeof( strbuf ));
> +	assert( ( size_t )strbuflen < sizeof( strbuf ));
>  	fold_init( fold, strbuf, ':' );
>  	mlog( MLOG_NORMAL | MLOG_BARE | MLOG_NOLOCK,
>  	      "\n%s\n\n",
> @@ -9528,8 +9529,8 @@ display_dump_label( bool_t lockpr,
>  	char media_string_uuid[UUID_STR_LEN + 1];
>  	char fs_string_uuid[UUID_STR_LEN + 1];
>  
> -	ASSERT( scrhdrp->cih_level >= 0 );
> -	ASSERT( scrhdrp->cih_level < 10 );
> +	assert( scrhdrp->cih_level >= 0 );
> +	assert( scrhdrp->cih_level < 10 );
>  	level_string[ 0 ] = ( char )( '0' + ( u_char_t )scrhdrp->cih_level );
>  	level_string[ 1 ] = 0;
>  
> diff --git a/restore/dirattr.c b/restore/dirattr.c
> index fcfa0c8..c829808 100644
> --- a/restore/dirattr.c
> +++ b/restore/dirattr.c
> @@ -36,6 +36,7 @@
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <dirent.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -201,14 +202,14 @@ dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( dirattr_pers_t ) <= DIRATTR_PERS_SZ );
> -	ASSERT( ! dtp );
> -	ASSERT( ! dpp );
> +	assert( sizeof( dirattr_pers_t ) <= DIRATTR_PERS_SZ );
> +	assert( ! dtp );
> +	assert( ! dpp );
>  
>  	/* allocate and initialize context
>  	 */
>  	dtp = ( dirattr_tran_t * )calloc( 1, sizeof( dirattr_tran_t ));
> -	ASSERT( dtp );
> +	assert( dtp );
>  	dtp->dt_cachedh = DAH_NULL;
>  	dtp->dt_fd = -1;
>  	dtp->dt_extattrfd = -1;
> @@ -308,11 +309,11 @@ dirattr_init( char *hkdir, bool_t resume, u_int64_t dircnt )
>  
>  	/* mmap the persistent descriptor
>  	 */
> -	ASSERT( ! ( DIRATTR_PERS_SZ % pgsz ));
> +	assert( ! ( DIRATTR_PERS_SZ % pgsz ));
>  	dpp = ( dirattr_pers_t * )mmap_autogrow( DIRATTR_PERS_SZ,
>  				        dtp->dt_fd,
>  				        ( off_t )0 );
> -	ASSERT( dpp );
> +	assert( dpp );
>  	if ( dpp == ( dirattr_pers_t * )-1 ) {
>  		mlog( MLOG_NORMAL | MLOG_ERROR, _(
>  		      "unable to map %s: %s\n"),
> @@ -355,7 +356,7 @@ dirattr_cleanup( void )
>  	}
>  	if ( dpp ) {
>  		rval = munmap( ( void * )dpp, DIRATTR_PERS_SZ );
> -		ASSERT( ! rval );
> +		assert( ! rval );
>  		dpp = 0;
>  	}
>  	if ( dtp->dt_fd >= 0 ) {
> @@ -392,8 +393,8 @@ dirattr_add( filehdr_t *fhdrp )
>  	
>  	/* sanity checks
>  	 */
> -	ASSERT( dtp );
> -	ASSERT( dpp );
> +	assert( dtp );
> +	assert( dpp );
>  
>  	/* make sure file pointer is positioned to write at end of file
>  	 */
> @@ -406,7 +407,7 @@ dirattr_add( filehdr_t *fhdrp )
>  			      strerror( errno ));
>  			return DAH_NULL;
>  		}
> -		ASSERT( dpp->dp_appendoff == newoff );
> +		assert( dpp->dp_appendoff == newoff );
>  		dtp->dt_at_endpr = BOOL_TRUE;
>  	}
>  
> @@ -420,7 +421,7 @@ dirattr_add( filehdr_t *fhdrp )
>  	 */
>  	oldoff = dpp->dp_appendoff;
>  	dix = OFF2DIX( oldoff );
> -	ASSERT( dix <= DIX_MAX );
> +	assert( dix <= DIX_MAX );
>  
>  	/* populate a dirattr
>  	 */
> @@ -449,7 +450,7 @@ dirattr_add( filehdr_t *fhdrp )
>  
>  	/* update the next write offset
>  	 */
> -	ASSERT( dpp->dp_appendoff <= OFF64MAX - ( off64_t )sizeof(dirattr_t) );
> +	assert( dpp->dp_appendoff <= OFF64MAX - ( off64_t )sizeof(dirattr_t) );
>  	dpp->dp_appendoff += ( off64_t )sizeof(dirattr_t);
>  
>  #ifdef DIRATTRCHK
> @@ -514,7 +515,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
>  			dtp->dt_extattrfdbadpr = BOOL_TRUE;
>  			return;
>  		}
> -		ASSERT( seekoff == off );
> +		assert( seekoff == off );
>  
>  		oldoff = off;
>  
> @@ -595,7 +596,7 @@ dirattr_addextattr( dah_t dah, extattrhdr_t *ahdrp )
>  			dtp->dt_extattrfdbadpr = BOOL_TRUE;
>  			return;
>  		}
> -		ASSERT( seekoff == oldoff );
> +		assert( seekoff == oldoff );
>  		nwritten = write( dtp->dt_extattrfd,
>  				  ( void * )&off,
>  				  sizeof( off ));
> @@ -672,7 +673,7 @@ dirattr_cb_extattr( dah_t dah,
>  			dtp->dt_extattrfdbadpr = BOOL_TRUE;
>  			return BOOL_TRUE;
>  		}
> -		ASSERT( seekoff == off );
> +		assert( seekoff == off );
>  
>  		/* peel off the next offset
>  		 */
> @@ -711,7 +712,7 @@ dirattr_cb_extattr( dah_t dah,
>  		/* read the remainder of the extattr
>  		 */
>  		recsz = ( size_t )ahdrp->ah_sz;
> -		ASSERT( recsz >= EXTATTRHDR_SZ );
> +		assert( recsz >= EXTATTRHDR_SZ );
>  		nread = read( dtp->dt_extattrfd,
>  			      ( void * )&ahdrp[ 1 ],
>  			      recsz - EXTATTRHDR_SZ );
> @@ -756,10 +757,10 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( dtp );
> -	ASSERT( dpp );
> +	assert( dtp );
> +	assert( dpp );
>  
> -	ASSERT( dah != DAH_NULL );
> +	assert( dah != DAH_NULL );
>  
>  #ifdef DIRATTRCHK
>  	sum = HDLGETSUM( dah );
> @@ -768,18 +769,18 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
>  	dix = ( dix_t )dah;
>  #endif /* DIRATTRCHK */
>  
> -	ASSERT( dix >= 0 );
> -	ASSERT( dix <= DIX_MAX );
> +	assert( dix >= 0 );
> +	assert( dix <= DIX_MAX );
>  
>  	argoff = DIX2OFF( dix );
> -	ASSERT( argoff >= 0 );
> -	ASSERT( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> -	ASSERT( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
> +	assert( argoff >= 0 );
> +	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> +	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
>  
>  #ifdef DIRATTRCHK
>  	dirattr_get( dah );
> -	ASSERT( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> -	ASSERT( dtp->dt_cached_dirattr.d_sum == sum );
> +	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> +	assert( dtp->dt_cached_dirattr.d_sum == sum );
>  #endif /* DIRATTRCHK */
>  
>  	if ( dtp->dt_at_endpr && dtp->dt_off ) {
> @@ -796,9 +797,9 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
>  		mlog( MLOG_NORMAL, _(
>  		      "lseek of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
> -	ASSERT( newoff == argoff );
> +	assert( newoff == argoff );
>  
>  	/* populate a dirattr
>  	 */
> @@ -822,7 +823,7 @@ dirattr_update( dah_t dah, filehdr_t *fhdrp )
>  		mlog( MLOG_NORMAL, _(
>  		      "update of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
>  
>  	dtp->dt_at_endpr = BOOL_FALSE;
> @@ -959,10 +960,10 @@ dirattr_get( dah_t dah )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( dtp );
> -	ASSERT( dpp );
> +	assert( dtp );
> +	assert( dpp );
>  
> -	ASSERT( dah != DAH_NULL );
> +	assert( dah != DAH_NULL );
>  
>  	/* if we are already holding this dirattr in cache,
>  	 * just return
> @@ -977,13 +978,13 @@ dirattr_get( dah_t dah )
>  #else /* DIRATTRCHK */
>  	dix = ( dix_t )dah;
>  #endif /* DIRATTRCHK */
> -	ASSERT( dix >= 0 );
> -	ASSERT( dix <= DIX_MAX );
> +	assert( dix >= 0 );
> +	assert( dix <= DIX_MAX );
>  
>  	argoff = DIX2OFF( dix );
> -	ASSERT( argoff >= 0 );
> -	ASSERT( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> -	ASSERT( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
> +	assert( argoff >= 0 );
> +	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> +	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
>  
>  	if ( dtp->dt_at_endpr && dtp->dt_off ) {
>  		if (dirattr_flush() != RV_OK) {
> @@ -999,9 +1000,9 @@ dirattr_get( dah_t dah )
>  		mlog( MLOG_NORMAL, _(
>  		      "lseek of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
> -	ASSERT( newoff == argoff );
> +	assert( newoff == argoff );
>  
>  	/* read the dirattr
>  	 */
> @@ -1012,12 +1013,12 @@ dirattr_get( dah_t dah )
>  		mlog( MLOG_NORMAL, _(
>  		      "read of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
>  
>  #ifdef DIRATTRCHK
> -	ASSERT( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> -	ASSERT( dtp->dt_cached_dirattr.d_sum == sum );
> +	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> +	assert( dtp->dt_cached_dirattr.d_sum == sum );
>  #endif /* DIRATTRCHK */
>  
>  	dtp->dt_at_endpr = BOOL_FALSE;
> @@ -1038,13 +1039,13 @@ dirattr_cacheflush( void )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( dtp );
> -	ASSERT( dpp );
> +	assert( dtp );
> +	assert( dpp );
>  
>  	/* if nothing in the cache, ignore
>  	 */
>  	dah = dtp->dt_cachedh;
> -	ASSERT( dah != DAH_NULL );
> +	assert( dah != DAH_NULL );
>  	if ( dah == DAH_NULL ) {
>  		return;
>  	}
> @@ -1057,17 +1058,17 @@ dirattr_cacheflush( void )
>  #endif /* DIRATTRCHK */
>  
>  #ifdef DIRATTRCHK
> -	ASSERT( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> -	ASSERT( dtp->dt_cached_dirattr.d_sum == sum );
> +	assert( dtp->dt_cached_dirattr.d_unq == DIRATTRUNQ );
> +	assert( dtp->dt_cached_dirattr.d_sum == sum );
>  #endif /* DIRATTRCHK */
>  
> -	ASSERT( dix >= 0 );
> -	ASSERT( dix <= DIX_MAX );
> +	assert( dix >= 0 );
> +	assert( dix <= DIX_MAX );
>  
>  	argoff = DIX2OFF( dix );
> -	ASSERT( argoff >= 0 );
> -	ASSERT( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> -	ASSERT( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
> +	assert( argoff >= 0 );
> +	assert( argoff >= ( off64_t )DIRATTR_PERS_SZ );
> +	assert( argoff <= dpp->dp_appendoff - ( off64_t )sizeof( dirattr_t ));
>  
>  	/* seek to the dirattr
>  	 */
> @@ -1076,9 +1077,9 @@ dirattr_cacheflush( void )
>  		mlog( MLOG_NORMAL, _(
>  		      "lseek of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
> -	ASSERT( newoff == argoff );
> +	assert( newoff == argoff );
>  
>  	/* write the dirattr
>  	 */
> @@ -1089,7 +1090,7 @@ dirattr_cacheflush( void )
>  		mlog( MLOG_NORMAL, _(
>  		      "flush of dirattr failed: %s\n"),
>  		      strerror( errno ));
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
>  
>  	dtp->dt_at_endpr = BOOL_FALSE;
> @@ -1104,7 +1105,7 @@ calcdixcum( dix_t dix )
>  	ix_t nibcnt;
>  	ix_t nibix;
>  
> -	ASSERT( ( sizeof( dah_t ) / HDLSUMCNT ) * HDLSUMCNT == sizeof( dah_t ));
> +	assert( ( sizeof( dah_t ) / HDLSUMCNT ) * HDLSUMCNT == sizeof( dah_t ));
>  
>  	nibcnt = ( sizeof( dah_t ) / HDLSUMCNT ) - 1;
>  	sum = 0;
> diff --git a/restore/inomap.c b/restore/inomap.c
> index 562492e..2c62afc 100644
> --- a/restore/inomap.c
> +++ b/restore/inomap.c
> @@ -26,6 +26,7 @@
>  #include <fcntl.h>
>  #include <dirent.h>
>  #include <time.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "util.h"
> @@ -195,9 +196,9 @@ inomap_restore_pers( drive_t *drivep,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( INOPERSEG == ( sizeof( (( seg_t * )0 )->lobits ) * NBBY ));
> -	ASSERT( sizeof( hnk_t ) == HNKSZ );
> -	ASSERT( sizeof( pers_t ) <= PERSSZ );
> +	assert( INOPERSEG == ( sizeof( (( seg_t * )0 )->lobits ) * NBBY ));
> +	assert( sizeof( hnk_t ) == HNKSZ );
> +	assert( sizeof( pers_t ) <= PERSSZ );
>  
>  	/* get inomap info from media hdr
>  	 */
> @@ -243,7 +244,7 @@ inomap_restore_pers( drive_t *drivep,
>  	persp->last_ino_added = last_ino_added;
>  
>  	tmphnkp = ( hnk_t * )calloc( ( size_t )hnkcnt, sizeof( hnk_t ));
> -	ASSERT( tmphnkp );
> +	assert( tmphnkp );
>  
>  	/* read the map in from media
>  	 */
> @@ -268,7 +269,7 @@ inomap_restore_pers( drive_t *drivep,
>  		        PERSSZ
>  		        +
>  		        sizeof( hnk_t ) * ( size_t )hnkcnt );
> -	ASSERT( ! rval1 );
> +	assert( ! rval1 );
>  	( void )close( fd );
>  	free( ( void * )perspath );
>  
> @@ -278,7 +279,7 @@ inomap_restore_pers( drive_t *drivep,
>  	 */
>  	switch( rval ) {
>  	case 0:
> -		ASSERT( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
> +		assert( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
>  		ok = inomap_sync_pers( hkdir );
>  		if ( ! ok ) {
>  			return RV_ERROR;
> @@ -325,7 +326,7 @@ inomap_discard( drive_t *drivep, content_inode_hdr_t *scrhdrp )
>  	 */
>  	switch( rval ) {
>  	case 0:
> -		ASSERT( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
> +		assert( ( size_t )nread == sizeof( hnk_t ) * ( size_t )hnkcnt );
>  		return RV_OK;
>  	case DRIVE_ERROR_EOD:
>  	case DRIVE_ERROR_EOF:
> @@ -350,7 +351,7 @@ inomap_sync_pers( char *hkdir )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( hnk_t ) == HNKSZ );
> +	assert( sizeof( hnk_t ) == HNKSZ );
>  
>  	/* only needed once per session
>  	 */
> @@ -388,7 +389,7 @@ inomap_sync_pers( char *hkdir )
>  
>  	/* mmap the pers inomap
>  	 */
> -	ASSERT( hnkcnt * sizeof( hnk_t ) <= ( size64_t )INT32MAX );
> +	assert( hnkcnt * sizeof( hnk_t ) <= ( size64_t )INT32MAX );
>  	roothnkp = ( hnk_t * ) mmap_autogrow(
>  				       sizeof( hnk_t ) * ( size_t )hnkcnt,
>  				       pers_fd,
> @@ -415,7 +416,7 @@ inomap_sync_pers( char *hkdir )
>  	/* calculate the tail pointers
>  	 */
>  	tailhnkp = hnkp;
> -	ASSERT( hnkcnt > 0 );
> +	assert( hnkcnt > 0 );
>  	lastsegp = &tailhnkp->seg[ ( intgen_t )( segcnt
>  						 -
>  						 SEGPERHNK * ( hnkcnt - 1 )
> @@ -485,7 +486,7 @@ inomap_sanitize( void )
>  void
>  inomap_rst_add( xfs_ino_t ino )
>  {
> -		ASSERT( pers_fd >= 0 );
> +		assert( pers_fd >= 0 );
>  		( void )map_set( ino, MAP_NDR_CHANGE );
>  }
>  
> @@ -494,7 +495,7 @@ inomap_rst_add( xfs_ino_t ino )
>  void
>  inomap_rst_del( xfs_ino_t ino )
>  {
> -		ASSERT( pers_fd >= 0 );
> +		assert( pers_fd >= 0 );
>  		( void )map_set( ino, MAP_NDR_NOREST );
>  }
>  
> diff --git a/restore/namreg.c b/restore/namreg.c
> index 41362d1..c64833d 100644
> --- a/restore/namreg.c
> +++ b/restore/namreg.c
> @@ -24,6 +24,7 @@
>  #include <sys/ioctl.h>
>  #include <fcntl.h>
>  #include <errno.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "lock.h"
> @@ -118,15 +119,15 @@ namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( ! ntp );
> -	ASSERT( ! npp );
> +	assert( ! ntp );
> +	assert( ! npp );
>  
> -	ASSERT( sizeof( namreg_pers_t ) <= NAMREG_PERS_SZ );
> +	assert( sizeof( namreg_pers_t ) <= NAMREG_PERS_SZ );
>  
>  	/* allocate and initialize context
>  	 */
>  	ntp = ( namreg_tran_t * )calloc( 1, sizeof( namreg_tran_t ));
> -	ASSERT( ntp );
> +	assert( ntp );
>  
>  	/* generate a string containing the pathname of the namreg file
>  	 */
> @@ -223,7 +224,7 @@ namreg_init( char *hkdir, bool_t resume, u_int64_t inocnt )
>  
>  	/* mmap the persistent descriptor
>  	 */
> -	ASSERT( ! ( NAMREG_PERS_SZ % pgsz ));
> +	assert( ! ( NAMREG_PERS_SZ % pgsz ));
>  	npp = ( namreg_pers_t * ) mmap_autogrow(
>  				        NAMREG_PERS_SZ,
>  				        ntp->nt_fd,
> @@ -258,9 +259,9 @@ namreg_add( char *name, size_t namelen )
>  	
>  	/* sanity checks
>  	 */
> -	ASSERT( ntp );
> -	ASSERT( npp );
> -	ASSERT( !ntp->nt_map );
> +	assert( ntp );
> +	assert( npp );
> +	assert( !ntp->nt_map );
>  
>  	/* make sure file pointer is positioned to append
>  	 */
> @@ -271,10 +272,10 @@ namreg_add( char *name, size_t namelen )
>  			mlog( MLOG_NORMAL, _(
>  			      "lseek of namreg failed: %s\n"),
>  			      strerror( errno ));
> -			ASSERT( 0 );
> +			assert( 0 );
>  			return NRH_NULL;
>  		}
> -		ASSERT( npp->np_appendoff == newoff );
> +		assert( npp->np_appendoff == newoff );
>  		ntp->nt_at_endpr = BOOL_TRUE;
>  	}
>  
> @@ -290,7 +291,7 @@ namreg_add( char *name, size_t namelen )
>  
>  	/* write a one byte unsigned string length into the buffer.
>  	 */
> -	ASSERT( namelen < 256 );
> +	assert( namelen < 256 );
>  	c = ( unsigned char )( namelen & 0xff );
>  	ntp->nt_buf[ntp->nt_off++] = c;
>  
> @@ -300,7 +301,7 @@ namreg_add( char *name, size_t namelen )
>  	ntp->nt_off += namelen;
>  
>  	npp->np_appendoff += ( off64_t )( 1 + namelen );
> -	ASSERT( oldoff <= HDLMAX );
> +	assert( oldoff <= HDLMAX );
>  
>  #ifdef NAMREGCHK
>  
> @@ -375,12 +376,12 @@ namreg_get( nrh_t nrh,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( ntp );
> -	ASSERT( npp );
> +	assert( ntp );
> +	assert( npp );
>  
>  	/* make sure we aren't being given a NULL handle
>  	 */
> -	ASSERT( nrh != NRH_NULL );
> +	assert( nrh != NRH_NULL );
>  
>  	/* convert the handle into the offset
>  	 */
> @@ -397,9 +398,9 @@ namreg_get( nrh_t nrh,
>  
>  	/* do sanity check on offset
>  	 */
> -	ASSERT( newoff <= HDLMAX );
> -	ASSERT( newoff < npp->np_appendoff );
> -	ASSERT( newoff >= ( off64_t )NAMREG_PERS_SZ );
> +	assert( newoff <= HDLMAX );
> +	assert( newoff < npp->np_appendoff );
> +	assert( newoff >= ( off64_t )NAMREG_PERS_SZ );
>  
>  	lock( );
>  
> @@ -461,7 +462,7 @@ namreg_get( nrh_t nrh,
>  
>  	/* validate the checkbit
>  	 */
> -	ASSERT( chkbit
> +	assert( chkbit
>  		==
>  		( ( ( nrh_t )len + ( nrh_t )bufp[ 0 ] ) & CHKBITLOMASK ));
>  
> diff --git a/restore/node.c b/restore/node.c
> index 4cc8fb0..f0297a5 100644
> --- a/restore/node.c
> +++ b/restore/node.c
> @@ -23,6 +23,7 @@
>  #include <errno.h>
>  #include <memory.h>
>  #include <limits.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -188,9 +189,9 @@ node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
>  	register u_char_t nodeunq;
>  #endif /* NODECHK */
>  
> -	ASSERT( pp );
> -	ASSERT( *pp );
> -	ASSERT( nh != NH_NULL );
> +	assert( pp );
> +	assert( *pp );
> +	assert( nh != NH_NULL );
>  
>  	/* convert the handle into an index
>  	 */
> @@ -199,19 +200,19 @@ node_unmap_internal( nh_t nh, void **pp, bool_t freepr )
>  	nh = HDLGETNHDL( nh );
>  #endif /* NODECHK */
>  
> -	ASSERT( nh <= NH_MAX );
> +	assert( nh <= NH_MAX );
>  
>  #ifdef NODECHK
>  	hkp = *( *( u_char_t ** )pp + node_hdrp->nh_nodehkix );
>  	nodegen = HKPGETGEN( hkp );
> -	ASSERT( nodegen == hdlgen );
> +	assert( nodegen == hdlgen );
>  	nodeunq = HKPGETUNQ( hkp );
>  	if ( ! freepr ) {
> -		ASSERT( nodeunq != NODEUNQFREE );
> -		ASSERT( nodeunq == NODEUNQALCD );
> +		assert( nodeunq != NODEUNQFREE );
> +		assert( nodeunq == NODEUNQALCD );
>  	} else {
> -		ASSERT( nodeunq != NODEUNQALCD );
> -		ASSERT( nodeunq == NODEUNQFREE );
> +		assert( nodeunq != NODEUNQALCD );
> +		assert( nodeunq == NODEUNQFREE );
>  	}
>  #endif /* NODECHK */
>  
> @@ -240,16 +241,16 @@ node_init( intgen_t fd,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( node_hdr_t ) <= NODE_HDRSZ );
> -	ASSERT( sizeof( nh_t ) < sizeof( off64_t ));
> -	ASSERT( sizeof( nh_t ) <= sizeof( segix_t ));
> -	ASSERT( sizeof( nh_t ) <= sizeof( relnix_t ));
> -	ASSERT( nodehkix < usrnodesz );
> -	ASSERT( usrnodesz >= sizeof( char * ) + 1 );
> +	assert( sizeof( node_hdr_t ) <= NODE_HDRSZ );
> +	assert( sizeof( nh_t ) < sizeof( off64_t ));
> +	assert( sizeof( nh_t ) <= sizeof( segix_t ));
> +	assert( sizeof( nh_t ) <= sizeof( relnix_t ));
> +	assert( nodehkix < usrnodesz );
> +	assert( usrnodesz >= sizeof( char * ) + 1 );
>  		/* so node is at least big enough to hold
>  		 * the free list linkage and the housekeeping byte
>  		 */
> -	ASSERT( nodehkix > sizeof( char * ));
> +	assert( nodehkix > sizeof( char * ));
>  		/* since beginning of each node is used to
>  		 * link it in the free list.
>  		 */
> @@ -283,7 +284,7 @@ node_init( intgen_t fd,
>  	 * reasonable cap on the max number of segments.
>  	 */
>  
> -	ASSERT( NODESPERSEG_MIN >= pgsz );
> +	assert( NODESPERSEG_MIN >= pgsz );
>  
>  	if ( vmsz < WINMAP_MIN * NODESPERSEG_MIN * nodesz ) {
>  		mlog( MLOG_NORMAL | MLOG_ERROR, _(
> @@ -331,10 +332,10 @@ node_init( intgen_t fd,
>  
>  	/* map the abstraction header
>  	 */
> -	ASSERT( ( NODE_HDRSZ & pgmask ) == 0 );
> -	ASSERT( ! ( NODE_HDRSZ % pgsz ));
> -	ASSERT( off <= OFF64MAX );
> -	ASSERT( ! ( off % ( off64_t )pgsz ));
> +	assert( ( NODE_HDRSZ & pgmask ) == 0 );
> +	assert( ! ( NODE_HDRSZ % pgsz ));
> +	assert( off <= OFF64MAX );
> +	assert( ! ( off % ( off64_t )pgsz ));
>  	node_hdrp = ( node_hdr_t * )mmap_autogrow(
>  					    NODE_HDRSZ,
>  					    fd,
> @@ -394,13 +395,13 @@ node_sync( intgen_t fd, off64_t off )
>  {
>  	/* sanity checks
>  	 */
> -	ASSERT( sizeof( node_hdr_t ) <= NODE_HDRSZ );
> +	assert( sizeof( node_hdr_t ) <= NODE_HDRSZ );
>  
>  	/* map the abstraction header
>  	 */
> -	ASSERT( ( NODE_HDRSZ & pgmask ) == 0 );
> -	ASSERT( off <= ( off64_t )OFF64MAX );
> -	ASSERT( ! ( off % ( off64_t )pgsz ));
> +	assert( ( NODE_HDRSZ & pgmask ) == 0 );
> +	assert( off <= ( off64_t )OFF64MAX );
> +	assert( ! ( off % ( off64_t )pgsz ));
>  	node_hdrp = ( node_hdr_t * )mmap_autogrow(
>  					    NODE_HDRSZ,
>  					    fd,
> @@ -454,8 +455,8 @@ node_alloc( void )
>  		hkpp = p + node_hdrp->nh_nodehkix;
>  		gen = ( u_char_t )( HKPGETGEN( *p ) + ( u_char_t )1 );
>  		unq = HKPGETUNQ( *hkpp );
> -		ASSERT( unq != NODEUNQALCD );
> -		ASSERT( unq == NODEUNQFREE );
> +		assert( unq != NODEUNQALCD );
> +		assert( unq == NODEUNQFREE );
>  #endif /* NODECHK */
>  
>  		/* adjust the free list */
> @@ -473,7 +474,7 @@ node_alloc( void )
>  				( off64_t )nh2segix( node_hdrp->nh_virgnh ) *
>  				( off64_t )node_hdrp->nh_segsz;
>  
> -			ASSERT( new_seg_off
> +			assert( new_seg_off
>  				<=
>  				OFF64MAX - ( off64_t )node_hdrp->nh_segsz );
>  			mlog( MLOG_DEBUG,
> @@ -531,7 +532,7 @@ node_map( nh_t nh )
>  	register u_char_t nodeunq;
>  #endif /* NODECHK */
>  
> -	ASSERT( nh != NH_NULL );
> +	assert( nh != NH_NULL );
>  
>  	/* convert the handle into an index
>  	 */
> @@ -540,7 +541,7 @@ node_map( nh_t nh )
>  	nh = HDLGETNHDL( nh );
>  #endif /* NODECHK */
>  
> -	ASSERT( nh <= NH_MAX );
> +	assert( nh <= NH_MAX );
>  
>  	/* map in
>  	 */
> @@ -553,9 +554,9 @@ node_map( nh_t nh )
>  	hkp = *( p + node_hdrp->nh_nodehkix );
>  	nodegen = HKPGETGEN( hkp );
>  	nodeunq = HKPGETUNQ( hkp );
> -	ASSERT( nodegen == hdlgen );
> -	ASSERT( nodeunq != NODEUNQFREE );
> -	ASSERT( nodeunq == NODEUNQALCD );
> +	assert( nodegen == hdlgen );
> +	assert( nodeunq != NODEUNQFREE );
> +	assert( nodeunq == NODEUNQALCD );
>  #endif /* NODECHK */
>  
>  	return ( void * )p;
> @@ -580,9 +581,9 @@ node_free( nh_t *nhp )
>  	register u_char_t nodeunq;
>  #endif /* NODECHK */
>  
> -	ASSERT( nhp );
> +	assert( nhp );
>  	nh = *nhp;
> -	ASSERT( nh != NH_NULL );
> +	assert( nh != NH_NULL );
>  
>  	/* convert the handle into an index
>  	 */
> @@ -591,7 +592,7 @@ node_free( nh_t *nhp )
>  	nh = HDLGETNHDL( nh );
>  #endif /* NODECHK */
>  
> -	ASSERT( nh <= NH_MAX );
> +	assert( nh <= NH_MAX );
>  
>  	/* map in
>  	 */
> @@ -607,9 +608,9 @@ node_free( nh_t *nhp )
>  	hkpp = p + node_hdrp->nh_nodehkix;
>  	nodegen = HKPGETGEN( *hkpp );
>  	nodeunq = HKPGETUNQ( *hkpp );
> -	ASSERT( nodegen == hdlgen );
> -	ASSERT( nodeunq != NODEUNQFREE );
> -	ASSERT( nodeunq == NODEUNQALCD );
> +	assert( nodegen == hdlgen );
> +	assert( nodeunq != NODEUNQFREE );
> +	assert( nodeunq == NODEUNQALCD );
>  	*hkpp = HKPMKHKP( nodegen, NODEUNQFREE );
>  #endif /* NODECHK */
>  
> diff --git a/restore/tree.c b/restore/tree.c
> index 08e177f..d377590 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -28,6 +28,7 @@
>  #include <xfs/handle.h>
>  #include <dirent.h>
>  #include <sys/ioctl.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "exit.h"
> @@ -351,16 +352,16 @@ tree_init( char *hkdir,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( ! ( PERSSZ % pgsz ));
> -	ASSERT( sizeof( persp ) <= PERSSZ );
> -	ASSERT( sizeof( node_t ) <= NODESZ );
> -	ASSERT( ! persp );
> -	ASSERT( ! tranp );
> +	assert( ! ( PERSSZ % pgsz ));
> +	assert( sizeof( persp ) <= PERSSZ );
> +	assert( sizeof( node_t ) <= NODESZ );
> +	assert( ! persp );
> +	assert( ! tranp );
>  
>  	/* allocate transient state
>  	 */
>  	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
> -	ASSERT( tranp );
> +	assert( tranp );
>  
>  	tranp->t_toconlypr = toconlypr;
>  	tranp->t_hkdir = hkdir;
> @@ -425,7 +426,7 @@ tree_init( char *hkdir,
>  
>  	/* mmap the persistent state
>  	 */
> -	ASSERT( ! ( PERSSZ % pgsz ));
> +	assert( ! ( PERSSZ % pgsz ));
>  	persp = ( treepers_t * ) mmap_autogrow(
>  				     PERSSZ,
>  				     tranp->t_persfd,
> @@ -450,9 +451,9 @@ tree_init( char *hkdir,
>  	 * begin immediately after the hash abstraction. give it the remainder
>  	 * of vm.
>  	 */
> -	ASSERT( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
> +	assert( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
>  	nodeoff = ( off64_t )PERSSZ + ( off64_t )persp->p_hashsz;
> -	ASSERT( vmsz > ( size64_t )nodeoff );
> +	assert( vmsz > ( size64_t )nodeoff );
>  	ok = node_init( tranp->t_persfd, 
>  		        nodeoff,
>  		        NODESZ,
> @@ -539,16 +540,16 @@ tree_sync( char *hkdir,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( ! ( PERSSZ % pgsz ));
> -	ASSERT( sizeof( persp ) <= PERSSZ );
> -	ASSERT( sizeof( node_t ) <= NODESZ );
> -	ASSERT( ! persp );
> -	ASSERT( ! tranp );
> +	assert( ! ( PERSSZ % pgsz ));
> +	assert( sizeof( persp ) <= PERSSZ );
> +	assert( sizeof( node_t ) <= NODESZ );
> +	assert( ! persp );
> +	assert( ! tranp );
>  
>  	/* allocate transient state
>  	 */
>  	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
> -	ASSERT( tranp );
> +	assert( tranp );
>  
>  	tranp->t_toconlypr = toconlypr;
>  	tranp->t_hkdir = hkdir;
> @@ -600,7 +601,7 @@ tree_sync( char *hkdir,
>  
>  	/* mmap the persistent state
>  	 */
> -	ASSERT( ! ( PERSSZ % pgsz ));
> +	assert( ! ( PERSSZ % pgsz ));
>  	persp = ( treepers_t * ) mmap_autogrow(
>  				     PERSSZ,
>  				     tranp->t_persfd,
> @@ -637,7 +638,7 @@ tree_sync( char *hkdir,
>  
>  	/* synchronize with the node abstraction.
>  	 */
> -	ASSERT( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
> +	assert( persp->p_hashsz <= ( size64_t )( OFF64MAX - ( off64_t )PERSSZ));
>  	nodeoff = ( off64_t )PERSSZ + ( off64_t )persp->p_hashsz;
>  	ok = node_sync( tranp->t_persfd, nodeoff );
>  	if ( ! ok ) {
> @@ -687,7 +688,7 @@ tree_marknoref( void )
>  		node_t *orphp;
>  		orphp = Node_map( persp->p_orphh );
>  		orphp->n_flags |= ( NF_REFED | NF_DUMPEDDIR );
> -		ASSERT( orphp->n_dah == DAH_NULL );
> +		assert( orphp->n_dah == DAH_NULL );
>  		Node_unmap( persp->p_orphh, &orphp );
>  	}
>  }
> @@ -740,12 +741,12 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
>  
>  	/* sanity check - orphino is supposed to be an unused ino!
>  	 */
> -	ASSERT( ino != orphino );
> +	assert( ino != orphino );
>  
>  	/* lookup head of hardlink list
>  	 */
>  	hardh = link_hardh( ino, gen );
> -	ASSERT( ino != persp->p_rootino || hardh == persp->p_rooth );
> +	assert( ino != persp->p_rootino || hardh == persp->p_rooth );
>  
>  	/* already present
>  	 */
> @@ -762,7 +763,7 @@ tree_begindir( filehdr_t *fhdrp, dah_t *dahp )
>  			      gen,
>  			      fhdrp->fh_stat.bs_gen );
>  			if ( ! tranp->t_toconlypr ) {
> -				ASSERT( hardp->n_dah == DAH_NULL );
> +				assert( hardp->n_dah == DAH_NULL );
>  				hardp->n_dah = dirattr_add( fhdrp );
>  			}
>  		} else if ( ! tranp->t_toconlypr && hardp->n_dah == DAH_NULL ) {
> @@ -829,7 +830,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  
>  	/* sanity check - orphino is supposed to be an unused ino!
>  	 */
> -	ASSERT( ino != orphino );
> +	assert( ino != orphino );
>  
>  	/* don't allow entries named "orphanage" under root to be added
>  	 */
> @@ -885,7 +886,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  						return RV_ERROR;
>  				}
>  				if ( hardp->n_lnkh != NH_NULL ) {
> -					ASSERT( hardp->n_flags & NF_REAL );
> +					assert( hardp->n_flags & NF_REAL );
>  					renameh = hardp->n_lnkh;
>  					renamep = Node_map( renameh );
>  					if ( renamep->n_parh == NH_NULL ) {
> @@ -912,7 +913,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  						namreg_get( renamep->n_nrh,
>  							    tranp->t_namebuf,
>  						    sizeof( tranp->t_namebuf ));
> -						ASSERT( namebuflen > 0 );
> +						assert( namebuflen > 0 );
>  						if ( strcmp( name,
>  							   tranp->t_namebuf )) {
>  							mlog( MLOG_DEBUG
> @@ -944,10 +945,10 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  					nrh_t nrh;
>  
>  					hardp->n_flags &= ~NF_NEWORPH;
> -					ASSERT( hardp->n_nrh == NRH_NULL );
> -					ASSERT( hardp->n_parh != NH_NULL );
> +					assert( hardp->n_nrh == NRH_NULL );
> +					assert( hardp->n_parh != NH_NULL );
>  					nrh = disown( hardh );
> -					ASSERT( nrh == NRH_NULL );
> +					assert( nrh == NRH_NULL );
>  					nrh = namreg_add( name, namelen );
>  					adopt( parh, hardh, nrh );
>  					mlog( MLOG_DEBUG | MLOG_TREE,
> @@ -958,13 +959,13 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  					      gen );
>  				}
>  			} else {
> -				ASSERT( hardp->n_nrh != NRH_NULL );
> +				assert( hardp->n_nrh != NRH_NULL );
>  				namebuflen
>  				=
>  				namreg_get( hardp->n_nrh,
>  					    tranp->t_namebuf,
>  					    sizeof( tranp->t_namebuf ));
> -				ASSERT( namebuflen > 0 );
> +				assert( namebuflen > 0 );
>  				if ( hardp->n_parh == parh
>  				     &&
>  				     ! strcmp( tranp->t_namebuf, name )) {
> @@ -1021,7 +1022,7 @@ tree_addent( nh_t parh, xfs_ino_t ino, gen_t gen, char *name, size_t namelen )
>  						Node_unmap( renameh, &renamep );
>  					}
>  					renamep = Node_map( renameh );
> -					ASSERT( hardp->n_parh != NH_NULL );
> +					assert( hardp->n_parh != NH_NULL );
>  					if ( hardp->n_parh != parh ) {
>  						/* different parent
>  						 */
> @@ -1220,7 +1221,7 @@ tree_post( char *path1, char *path2 )
>  	}
>  
>  #ifdef TREE_CHK
> -	ASSERT( tree_chk( ));
> +	assert( tree_chk( ));
>  #endif /* TREE_CHK */
>  
>  	/* rename directories
> @@ -1238,7 +1239,7 @@ tree_post( char *path1, char *path2 )
>  	}
>  
>  #ifdef TREE_CHK
> -	ASSERT( tree_chk( ));
> +	assert( tree_chk( ));
>  #endif /* TREE_CHK */
>  
>  	/* process hard links
> @@ -1321,7 +1322,7 @@ noref_elim_recurse( nh_t parh,
>  			if ( ! isrefpr ) {
>  				nrh_t nrh;
>  
> -				ASSERT( ! isrenamepr );
> +				assert( ! isrenamepr );
>  				if ( isrealpr ) {
>  					ok = Node2path( cldh, path1, _("rmdir") );
>  					if ( ! ok ) {
> @@ -1346,7 +1347,7 @@ noref_elim_recurse( nh_t parh,
>  					}
>  				}
>  				nrh = disown( cldh );
> -				ASSERT( nrh != NRH_NULL );
> +				assert( nrh != NRH_NULL );
>  				namreg_del( nrh );
>  				link_out( cldh );
>  				Node_free( &cldh );
> @@ -1356,8 +1357,8 @@ noref_elim_recurse( nh_t parh,
>  				nrh_t nrh;
>  				node_t *renamep;
>  
> -				ASSERT( isrefpr );
> -				ASSERT( isrealpr );
> +				assert( isrefpr );
> +				assert( isrealpr );
>  				ok = Node2path( cldh,
>  						path1,
>  						_("tmp dir rename src") );
> @@ -1366,7 +1367,7 @@ noref_elim_recurse( nh_t parh,
>  					continue;
>  				}
>  				nrh = disown( cldh );
> -				ASSERT( nrh != NRH_NULL );
> +				assert( nrh != NRH_NULL );
>  				adopt( persp->p_orphh, cldh, NRH_NULL );
>  				ok = Node2path( cldh,
>  						path2,
> @@ -1375,7 +1376,7 @@ noref_elim_recurse( nh_t parh,
>  					/* REFERENCED */
>  					nrh_t dummynrh;
>  					dummynrh = disown( cldh );
> -					ASSERT( dummynrh == NRH_NULL );
> +					assert( dummynrh == NRH_NULL );
>  					adopt( parh, cldh, nrh );
>  					cldh = nextcldh;
>  					continue;
> @@ -1395,7 +1396,7 @@ noref_elim_recurse( nh_t parh,
>  					      path2,
>  					      strerror( errno ));
>  					dummynrh = disown( cldh );
> -					ASSERT( dummynrh == NRH_NULL );
> +					assert( dummynrh == NRH_NULL );
>  					adopt( parh, cldh, nrh );
>  					cldh = nextcldh;
>  					continue;
> @@ -1436,7 +1437,7 @@ noref_elim_recurse( nh_t parh,
>  				nh_t hardh;
>  				bool_t neededpr;
>  				hardh = link_hardh( ino, gen );
> -				ASSERT( hardh != NH_NULL );
> +				assert( hardh != NH_NULL );
>  				canunlinkpr = BOOL_FALSE;
>  				neededpr = BOOL_FALSE;
>  				/* tes@sgi.com:
> @@ -1475,7 +1476,7 @@ noref_elim_recurse( nh_t parh,
>  			if ( mustorphpr ) {
>  				/* rename file to orphanage */
>  				nrh_t nrh;
> -				ASSERT( ! canunlinkpr );
> +				assert( ! canunlinkpr );
>  				ok = Node2path( cldh,
>  						path1,
>  						_("tmp nondir rename src") );
> @@ -1484,7 +1485,7 @@ noref_elim_recurse( nh_t parh,
>  					continue;
>  				}
>  				nrh = disown( cldh );
> -				ASSERT( nrh != NRH_NULL );
> +				assert( nrh != NRH_NULL );
>  				adopt( persp->p_orphh, cldh, NRH_NULL );
>  				ok = Node2path( cldh,
>  						path2,
> @@ -1493,7 +1494,7 @@ noref_elim_recurse( nh_t parh,
>  					/* REFERENCED */
>  					nrh_t dummynrh;
>  					dummynrh = disown( cldh );
> -					ASSERT( dummynrh == NRH_NULL );
> +					assert( dummynrh == NRH_NULL );
>  					adopt( parh, cldh, nrh );
>  					cldh = nextcldh;
>  					continue;
> @@ -1513,7 +1514,7 @@ noref_elim_recurse( nh_t parh,
>  					      path2,
>  					      strerror( errno ));
>  					dummynrh = disown( cldh );
> -					ASSERT( dummynrh == NRH_NULL );
> +					assert( dummynrh == NRH_NULL );
>  					adopt( parh, cldh, nrh );
>  					cldh = nextcldh;
>  					continue;
> @@ -1527,7 +1528,7 @@ noref_elim_recurse( nh_t parh,
>  				/* REFERENCED */
>  				nrh_t nrh;
>  
> -				ASSERT( ! mustorphpr );
> +				assert( ! mustorphpr );
>  				if ( isrealpr ) {
>  					ok = Node2path( cldh, path1, _("rmdir") );
>  					if ( ! ok ) {
> @@ -1553,7 +1554,7 @@ noref_elim_recurse( nh_t parh,
>  					}
>  				}
>  				nrh = disown( cldh );
> -				ASSERT( nrh != NRH_NULL );
> +				assert( nrh != NRH_NULL );
>  				link_out( cldh );
>  				Node_free( &cldh );
>  			}
> @@ -1662,7 +1663,7 @@ rename_dirs( nh_t cldh,
>  		isrenamepr = isdirpr && renameh != NH_NULL;
>  		nextcldh = cldp->n_sibh;
>  		Node_unmap( cldh, &cldp );
> -		ASSERT( parh == persp->p_orphh );
> +		assert( parh == persp->p_orphh );
>  
>  		if ( isrenamepr ) {
>  			node_t *renamep;
> @@ -1681,12 +1682,12 @@ rename_dirs( nh_t cldh,
>  				continue;
>  			}
>  			dummynrh = disown( cldh );
> -			ASSERT( dummynrh == NRH_NULL );
> +			assert( dummynrh == NRH_NULL );
>  			adopt( newparh, cldh, newnrh );
>  			ok = Node2path( cldh, path2, _("rename dir") );
>  			if ( ! ok ) {
>  				dummynrh = disown( cldh );
> -				ASSERT( dummynrh == newnrh );
> +				assert( dummynrh == newnrh );
>  				adopt( persp->p_orphh, cldh, NRH_NULL );
>  				cldp = Node_map( cldh );
>  				cldp->n_nrh = NRH_NULL;
> @@ -1707,7 +1708,7 @@ rename_dirs( nh_t cldh,
>  				      path2,
>  				      strerror( errno ));
>  				dummynrh = disown( cldh );
> -				ASSERT( dummynrh == newnrh );
> +				assert( dummynrh == newnrh );
>  				adopt( persp->p_orphh, cldh, NRH_NULL );
>  				cldh = nextcldh;
>  				continue;
> @@ -1964,7 +1965,7 @@ tree_cb_links( xfs_ino_t ino,
>  			link_in( nh );
>  			adopt( persp->p_orphh, nh, NRH_NULL );
>  			ok = Node2path( nh, path1, _("orphan") );
> -			ASSERT( ok );
> +			assert( ok );
>  			( void )( * funcp )( contextp, BOOL_FALSE, path1,path2);
>  		}
>  	}
> @@ -2271,7 +2272,7 @@ proc_hardlinks_cb( void *contextp, nh_t hardheadh )
>  			}
>  			continue;
>  		}
> -		ASSERT( 0 );
> +		assert( 0 );
>  	}
>  
>  	/* now pass through dst list, doing renames if src list not empty,
> @@ -2700,7 +2701,7 @@ restart:
>  	preamblestr[ preamblecnt++ ] = "\n";
>  	preamblestr[ preamblecnt++ ] = fold;
>  	preamblestr[ preamblecnt++ ] = "\n\n";
> -	ASSERT( preamblecnt <= PREAMBLEMAX );
> +	assert( preamblecnt <= PREAMBLEMAX );
>  	dlog_begin( preamblestr, preamblecnt );
>  
>  	/* execute commands until time to extract or quit. always begin with
> @@ -2736,9 +2737,9 @@ restart:
>  		} else if ( responseix == abortix ) {
>  			ackstr[ ackcnt++ ] = _("abort\n");
>  		} else {
> -			ASSERT( responseix == okix );
> +			assert( responseix == okix );
>  		}
> -		ASSERT( ackcnt <= ACKMAX );
> +		assert( ackcnt <= ACKMAX );
>  		dlog_string_ack( ackstr,
>  				 ackcnt );
>  
> @@ -2753,7 +2754,7 @@ restart:
>  			postamblestr[ postamblecnt++ ] = "\n";
>  			postamblestr[ postamblecnt++ ] = fold;
>  			postamblestr[ postamblecnt++ ] = "\n\n";
> -			ASSERT( postamblecnt <= POSTAMBLEMAX );
> +			assert( postamblecnt <= POSTAMBLEMAX );
>  			dlog_end( postamblestr, postamblecnt );
>  
>  			/* if sighup or sigquit, immediately quit
> @@ -2765,7 +2766,7 @@ restart:
>  			/* if sigint, allow main thread to decide if
>  			 * operator really wants to quit
>  			 */
> -			ASSERT( responseix == sigintix );
> +			assert( responseix == sigintix );
>  			if ( cldmgr_stop_requested( )) {
>  				return BOOL_FALSE;
>  			}
> @@ -2794,7 +2795,7 @@ restart:
>  	postamblestr[ postamblecnt++ ] = "\n";
>  	postamblestr[ postamblecnt++ ] = fold;
>  	postamblestr[ postamblecnt++ ] = "\n\n";
> -	ASSERT( postamblecnt <= POSTAMBLEMAX );
> +	assert( postamblecnt <= POSTAMBLEMAX );
>  	dlog_end( postamblestr, postamblecnt );
>  
>  	/* pv 773569 - quit is not a reason to consider session
> @@ -2846,7 +2847,7 @@ tsi_cmd_pwd_recurse( void *ctxp,
>  	register intgen_t namelen;
>  	nrh_t nrh;
>  
> -	ASSERT( nh != NH_NULL );
> +	assert( nh != NH_NULL );
>  
>  	np = Node_map( nh );
>  	nrh = np->n_nrh;
> @@ -2857,11 +2858,11 @@ tsi_cmd_pwd_recurse( void *ctxp,
>  			/* RECURSION */
>  		( * pcb )( pctxp, "/" );
>  	}
> -	ASSERT( nrh != NRH_NULL );
> +	assert( nrh != NRH_NULL );
>  	namelen = namreg_get( nrh,
>  			      tranp->t_inter.i_name,
>  			      sizeof( tranp->t_inter.i_name ));
> -	ASSERT( namelen > 0 );
> +	assert( namelen > 0 );
>  	( * pcb )( pctxp, tranp->t_inter.i_name );
>  }
>  
> @@ -2933,7 +2934,7 @@ tsi_cmd_ls( void *ctxp,
>  			namelen = namreg_get( nrh,
>  					      tranp->t_inter.i_name,
>  					      sizeof( tranp->t_inter.i_name ));
> -			ASSERT( namelen > 0 );
> +			assert( namelen > 0 );
>  			( * pcb )( pctxp,
>  				   "    %s %10llu %s%s\n",
>  				   isselpr ? "*" : " ",
> @@ -2983,7 +2984,7 @@ tsi_cmd_cd( void *ctxp,
>  	/* if named is not a dir, complain
>  	 */
>  	if ( ! isdirpr ) {
> -		ASSERT( arg );
> +		assert( arg );
>  		( * pcb )( pctxp,
>  			   _("%s is not a directory\n"),
>  			   arg );
> @@ -3152,7 +3153,7 @@ tsi_cmd_match( void )
>  		return 0;
>  	}
>  
> -	ASSERT( tblp->tct_argcmin != 0 );
> +	assert( tblp->tct_argcmin != 0 );
>  	if ( tranp->t_inter.i_argc < tblp->tct_argcmin ) {
>  		return 0;
>  	}
> @@ -3224,11 +3225,11 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
>  	 * or at the current working directory
>  	 */
>  	if ( path && *path == '/' ) {
> -		ASSERT( rooth != NH_NULL );
> +		assert( rooth != NH_NULL );
>  		namedh = rooth;
>  		path++;
>  	} else {
> -		ASSERT( cwdh != NH_NULL );
> +		assert( cwdh != NH_NULL );
>  		namedh = cwdh;
>  	}
>  
> @@ -3239,7 +3240,7 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
>  	cldh = namedp->n_cldh;
>  	ino = namedp->n_ino;
>  	isselpr = ( namedp->n_flags & NF_SUBTREE );
> -	ASSERT( namedp->n_flags & NF_ISDIR );
> +	assert( namedp->n_flags & NF_ISDIR );
>  	Node_unmap( namedh, &namedp );
>  	isdirpr = BOOL_TRUE;
>  
> @@ -3278,12 +3279,12 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
>  		 * the path pointer.
>  		 */
>  		namelen = strcspn( path, "/" );
> -		ASSERT( namelen < sizeof( nbuf ));
> +		assert( namelen < sizeof( nbuf ));
>  		strncpy( nbuf, path, namelen );
>  		nbuf[ namelen ] = 0;
>  		path += namelen;
>  		if ( *path ) {
> -			ASSERT( *path == '/' );
> +			assert( *path == '/' );
>  			strpatchp = path;
>  			*strpatchp = 0;
>  			path++;
> @@ -3353,12 +3354,12 @@ tsi_walkpath( char *arg, nh_t rooth, nh_t cwdh,
>  			isselpr = ( sibp->n_flags & NF_SUBTREE );
>  			isdirpr = ( sibp->n_flags & NF_ISDIR );
>  			Node_unmap( sibh, &sibp );
> -			ASSERT( nrh != NRH_NULL || sibh == persp->p_orphh );
> +			assert( nrh != NRH_NULL || sibh == persp->p_orphh );
>  			if ( nrh != NRH_NULL ) {
>  				siblen = namreg_get( nrh,
>  						     tranp->t_inter.i_name,
>  					       sizeof( tranp->t_inter.i_name ));
> -				ASSERT( siblen > 0 );
> +				assert( siblen > 0 );
>  				if ( ! strcmp( nbuf, tranp->t_inter.i_name )) {
>  					break;
>  				}
> @@ -3523,7 +3524,7 @@ Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
>  	/* if we have a cache hit, no need to recurse any further
>  	 */
>  	if ( nh == cache.nh ) {
> -		ASSERT( bufsz > cache.len );
> +		assert( bufsz > cache.len );
>  		strcpy( buf, cache.buf );
>  		return bufsz - cache.len;
>  	}
> @@ -3550,7 +3551,7 @@ Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
>  	/* insert slash if parent not root
>  	 */
>  	if ( parh != persp->p_rooth ) {
> -		ASSERT( bufsz + MAXPATHLEN >= 2 );
> +		assert( bufsz + MAXPATHLEN >= 2 );
>  		*buf++ = '/';
>  		*( buf + 1 ) = 0;
>  		bufsz--;
> @@ -3566,15 +3567,15 @@ Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
>  	} else if ( nh == persp->p_orphh ) {
>  		namelen = sprintf( buf, "%s", orphname );
>  	} else {
> -		ASSERT( nrh != NRH_NULL );
> +		assert( nrh != NRH_NULL );
>  		namelen = namreg_get( nrh, buf, ( size_t )bufsz + MAXPATHLEN );
> -		ASSERT( namelen > 0 );
> +		assert( namelen > 0 );
>  	}
>  
>  	/* update remaining buffer size
>  	 */
>  	bufsz -= namelen;
> -	ASSERT( bufsz + MAXPATHLEN > 0 );
> +	assert( bufsz + MAXPATHLEN > 0 );
>  
>  	/* update the cache if we're the target's parent
>  	 * (and the pathname is not too long)
> @@ -3639,7 +3640,7 @@ disown( nh_t cldh )
>  	nrh = cldp->n_nrh;
>  
>  	parh = cldp->n_parh;
> -	ASSERT( parh != NH_NULL );
> +	assert( parh != NH_NULL );
>  	if ( parh == NH_NULL ) {
>  		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
>  		      "attempt to disown child "
> @@ -3647,7 +3648,7 @@ disown( nh_t cldh )
>  		return nrh;
>  	}
>  	parp = Node_map( parh );
> -	ASSERT( parp->n_cldh != NH_NULL );
> +	assert( parp->n_cldh != NH_NULL );
>  	if ( parp->n_cldh == NH_NULL ) {
>  		mlog( MLOG_NORMAL | MLOG_WARNING | MLOG_TREE, _(
>  		      "attempt to disown child "
> @@ -3668,7 +3669,7 @@ disown( nh_t cldh )
>  		nh_t prevcldh = cldp->n_sibprevh;
>  		node_t *prevcldp;
>  
> -		ASSERT(prevcldh != NH_NULL); /* must be a previous */
> +		assert(prevcldh != NH_NULL); /* must be a previous */
>  		prevcldp = Node_map( prevcldh );
>  
>  		/* fix up previous */
> @@ -3865,7 +3866,7 @@ link_matchh( nh_t hardh, nh_t parh, char *name )
>  			namelen = namreg_get( np->n_nrh,
>  					      tranp->t_namebuf,
>  					      sizeof( tranp->t_namebuf ));
> -			ASSERT( namelen > 0 );
> +			assert( namelen > 0 );
>  			if ( ! strcmp( name, tranp->t_namebuf )) {
>  				Node_unmap( hardh, &np );
>  				break;
> @@ -3955,7 +3956,7 @@ link_out( nh_t nh )
>  	/* get head of hard link list
>  	 */
>  	hardh = hash_find( ino, gen );
> -	ASSERT( hardh != NH_NULL );
> +	assert( hardh != NH_NULL );
>  
>  	/* if node is at head of hard link list, hash it out and
>  	 * hash in the following node in link list, if there is one.
> @@ -3973,7 +3974,7 @@ link_out( nh_t nh )
>  			nh_t nexth = prevp->n_lnkh;
>  			Node_unmap( prevh, &prevp  );
>  			prevh = nexth;
> -			ASSERT( prevh != NH_NULL );
> +			assert( prevh != NH_NULL );
>  			prevp = Node_map( prevh );
>  		}
>  		prevp->n_lnkh = np->n_lnkh;
> @@ -4033,7 +4034,7 @@ link_iter_next( link_iter_context_t *link_iter_contextp )
>  	/* if no last, must be first call
>  	 */
>  	if ( tmplasth == NH_NULL ) {
> -		ASSERT( link_iter_contextp->li_prevh == NH_NULL );
> +		assert( link_iter_contextp->li_prevh == NH_NULL );
>  		link_iter_contextp->li_lasth = link_iter_contextp->li_headh;
>  		return link_iter_contextp->li_lasth;
>  	}
> @@ -4065,8 +4066,8 @@ link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( link_iter_contextp->li_lasth != NH_NULL );
> -	ASSERT( nh == link_iter_contextp->li_lasth );
> +	assert( link_iter_contextp->li_lasth != NH_NULL );
> +	assert( nh == link_iter_contextp->li_lasth );
>  
>  	/* get the next node in list
>  	 */
> @@ -4076,7 +4077,7 @@ link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh )
>  	Node_unmap( link_iter_contextp->li_lasth, &lastp );
>  
>  	if ( link_iter_contextp->li_lasth == link_iter_contextp->li_headh ) {
> -		ASSERT( link_iter_contextp->li_prevh == NH_NULL );
> +		assert( link_iter_contextp->li_prevh == NH_NULL );
>  		hash_out( link_iter_contextp->li_headh );
>  		link_iter_contextp->li_headh = nexth;
>  		if ( nexth != NH_NULL ) {
> @@ -4084,7 +4085,7 @@ link_iter_unlink( link_iter_context_t *link_iter_contextp, nh_t nh )
>  		}
>  	} else {
>  		node_t *prevp;
> -		ASSERT( link_iter_contextp->li_prevh != NH_NULL );
> +		assert( link_iter_contextp->li_prevh != NH_NULL );
>  		prevp = Node_map( link_iter_contextp->li_prevh );
>  		prevp->n_lnkh = nexth;
>  		Node_unmap( link_iter_contextp->li_prevh, &prevp );
> @@ -4112,7 +4113,7 @@ hash_init( size64_t vmsz,
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( pgsz % sizeof( nh_t ) == 0 );
> +	assert( pgsz % sizeof( nh_t ) == 0 );
>  
>  	/* calculate the size of the hash array. must be a power of two,
>  	 * and a multiple of the page size. don't use more than the available
> @@ -4130,11 +4131,11 @@ hash_init( size64_t vmsz,
>  	      ;
>  	      loghashlen++ )
>  		;
> -	ASSERT( loghashlen > 0 );
> +	assert( loghashlen > 0 );
>  	hashlen = ( size64_t )1 << loghashlen;
>  	if (hashlen > hashlenmax)
>  		hashlen >>= 1;
> -	ASSERT( hashlen <= hashlenmax );
> +	assert( hashlen <= hashlenmax );
>  
>  	/* record hash size in persistent state
>  	 */
> @@ -4142,9 +4143,9 @@ hash_init( size64_t vmsz,
>  
>  	/* map the hash array just after the persistent state header
>  	 */
> -	ASSERT( persp->p_hashsz <= SIZEMAX );
> -	ASSERT( ! ( persp->p_hashsz % ( size64_t )pgsz ));
> -	ASSERT( ! ( PERSSZ % pgsz ));
> +	assert( persp->p_hashsz <= SIZEMAX );
> +	assert( ! ( persp->p_hashsz % ( size64_t )pgsz ));
> +	assert( ! ( PERSSZ % pgsz ));
>  	tranp->t_hashp = ( nh_t * ) mmap_autogrow(
>  					    ( size_t )persp->p_hashsz,
>  					    tranp->t_persfd,
> @@ -4166,7 +4167,7 @@ hash_init( size64_t vmsz,
>  	/* build a hash mask. this works because hashlen is a power of two.
>  	 * record in persistent state.
>  	 */
> -	ASSERT( hashlen - 1 <= SIZEMAX );
> +	assert( hashlen - 1 <= SIZEMAX );
>  	persp->p_hashmask = ( size_t )( hashlen - 1 );
>  
>  	return BOOL_TRUE;
> @@ -4179,18 +4180,18 @@ hash_sync( char *perspath )
>  
>  	/* sanity checks
>  	 */
> -	ASSERT( pgsz % sizeof( nh_t ) == 0 );
> +	assert( pgsz % sizeof( nh_t ) == 0 );
>  
>  	/* retrieve the hash size from the persistent state
>  	 */
>  	hashsz = persp->p_hashsz;
> -	ASSERT( ! ( hashsz % sizeof( nh_t )));
> +	assert( ! ( hashsz % sizeof( nh_t )));
>  
>  	/* map the hash array just after the persistent state header
>  	 */
> -	ASSERT( hashsz <= SIZEMAX );
> -	ASSERT( ! ( hashsz % ( size64_t )pgsz ));
> -	ASSERT( ! ( PERSSZ % pgsz ));
> +	assert( hashsz <= SIZEMAX );
> +	assert( ! ( hashsz % ( size64_t )pgsz ));
> +	assert( ! ( PERSSZ % pgsz ));
>  	tranp->t_hashp = ( nh_t * ) mmap_autogrow(
>  					    ( size_t )hashsz,
>  					    tranp->t_persfd,
> @@ -4236,7 +4237,7 @@ hash_in( nh_t nh )
>  	
>  	/* assert not already in
>  	 */
> -	ASSERT( hash_find( np->n_ino, np->n_gen ) == NH_NULL );
> +	assert( hash_find( np->n_ino, np->n_gen ) == NH_NULL );
>  
>  	/* calculate the hash index
>  	 */
> @@ -4248,7 +4249,7 @@ hash_in( nh_t nh )
>  
>  	/* insert into the list, at the head
>  	 */
> -	ASSERT( np->n_hashh == NH_NULL );
> +	assert( np->n_hashh == NH_NULL );
>  	np->n_hashh = *entryp;
>  	*entryp = nh;
>  
> @@ -4282,7 +4283,7 @@ hash_out( nh_t nh )
>  	/* get the handle of the first node in the appropriate hash array
>  	 */
>  	hashheadh = *entryp;
> -	ASSERT( hashheadh != NH_NULL );
> +	assert( hashheadh != NH_NULL );
>  	
>  	/* if node is first in list, replace entry with following node.
>  	 * otherwise, walk the list until found.
> @@ -4296,7 +4297,7 @@ hash_out( nh_t nh )
>  			nh_t nexth = prevp->n_hashh;
>  			Node_unmap( prevh, &prevp  );
>  			prevh = nexth;
> -			ASSERT( prevh != NH_NULL );
> +			assert( prevh != NH_NULL );
>  			prevp = Node_map( prevh );
>  		}
>  		prevp->n_hashh = np->n_hashh;
> @@ -4412,11 +4413,11 @@ Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp )
>  		*nexthashhp = NH_NULL;
>  	}
>  
> -	ASSERT( nextlnkhp );
> +	assert( nextlnkhp );
>  	*nextlnkhp = NH_NULL;
>  
>  	np = Node_map( nh );
> -	ASSERT( np );
> +	assert( np );
>  	n = *np;
>  	Node_unmap( nh, &np );
>  
> @@ -4456,7 +4457,7 @@ Node_chk( nh_t nh, nh_t *nexthashhp, nh_t *nextlnkhp )
>  	if ( n.n_nrh != NRH_NULL ) {
>  		intgen_t rval;
>  		rval = namreg_get( n.n_nrh, nambuf, sizeof( nambuf ));
> -		ASSERT( rval >= 0 );
> +		assert( rval >= 0 );
>  	}
>  
>  	if ( n.n_dah != DAH_NULL ) {
> @@ -4539,7 +4540,7 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
>  {
>  	bool_t okaccum = BOOL_TRUE;
>  
> -	ASSERT( parh != NH_NULL );
> +	assert( parh != NH_NULL );
>  
>  	while ( cldh != NH_NULL ) {
>  		node_t *cldp;
> @@ -4569,7 +4570,7 @@ tree_chk2_recurse( nh_t cldh, nh_t parh )
>  			namelen = namreg_get( nrh,
>  					      tranp->t_namebuf,
>  					      sizeof( tranp->t_namebuf ));
> -			ASSERT( namelen >= 0 );
> +			assert( namelen >= 0 );
>  		}
>  
>  		if ( nodeparh == NH_NULL ) {
> @@ -4631,7 +4632,7 @@ parse( int slotcnt, char **slotbuf, char *string )
>  
>  	/* sanity checkcs
>  	 */
> -	ASSERT( slotcnt >= 0 );
> +	assert( slotcnt >= 0 );
>  
>  	/* allocate a companion to the input string for identifying
>  	 * characters which are to be interpreted literally.
> diff --git a/restore/win.c b/restore/win.c
> index 0f3b573..a9f0239 100644
> --- a/restore/win.c
> +++ b/restore/win.c
> @@ -25,6 +25,7 @@
>  #include <stdlib.h>
>  #include <memory.h>
>  #include <errno.h>
> +#include <assert.h>
>  
>  #include "types.h"
>  #include "mlog.h"
> @@ -153,14 +154,14 @@ win_init( intgen_t fd,
>  {
>  	/* validate parameters
>  	 */
> -	ASSERT( ( firstoff & ( off64_t )pgmask ) == 0 );
> -	ASSERT( ( segsz & pgmask ) == 0 );
> +	assert( ( firstoff & ( off64_t )pgmask ) == 0 );
> +	assert( ( segsz & pgmask ) == 0 );
>  
>  	/* allocate and initialize transient state
>  	 */
> -	ASSERT( tranp == 0 );
> +	assert( tranp == 0 );
>  	tranp = ( tran_t * )calloc( 1, sizeof( tran_t ));
> -	ASSERT( tranp );
> +	assert( tranp );
>  
>  	tranp->t_fd = fd;
>  	tranp->t_firstoff = firstoff;
> @@ -170,7 +171,7 @@ win_init( intgen_t fd,
>  	tranp->t_segmaplen = SEGMAP_INCR;
>  	tranp->t_segmap = (win_t **)
>  	calloc( tranp->t_segmaplen, sizeof(win_t *) );
> -	ASSERT( tranp->t_segmap );
> +	assert( tranp->t_segmap );
>  
>  	/* initialize critical region enforcer
>  	 */
> @@ -203,8 +204,8 @@ win_map( segix_t segix, void **pp )
>  		     "win_map(): requested segment already mapped\n");
>  #endif
>  		if ( winp->w_refcnt == 0 ) {
> -			ASSERT( tranp->t_lruheadp );
> -			ASSERT( tranp->t_lrutailp );
> +			assert( tranp->t_lruheadp );
> +			assert( tranp->t_lrutailp );
>  			if ( tranp->t_lruheadp == winp ) {
>  				if ( tranp->t_lrutailp == winp ) {
>  					tranp->t_lruheadp = 0;
> @@ -225,8 +226,8 @@ win_map( segix_t segix, void **pp )
>  			winp->w_prevp = 0;
>  			winp->w_nextp = 0;
>  		} else {
> -			ASSERT( ! winp->w_prevp );
> -			ASSERT( ! winp->w_nextp );
> +			assert( ! winp->w_prevp );
> +			assert( ! winp->w_nextp );
>  		}
>  		winp->w_refcnt++;
>  		*pp = winp->w_p;
> @@ -243,7 +244,7 @@ win_map( segix_t segix, void **pp )
>  		     "win_map(): create a new window\n");
>  #endif
>  		winp = ( win_t * )calloc( 1, sizeof( win_t ));
> -		ASSERT( winp );
> +		assert( winp );
>  		tranp->t_wincnt++;
>  	} else if ( tranp->t_lruheadp ) {
>  		/* REFERENCED */
> @@ -252,7 +253,7 @@ win_map( segix_t segix, void **pp )
>  		mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
>  		     "win_map(): get head from lru freelist & unmap\n");
>  #endif
> -		ASSERT( tranp->t_lrutailp );
> +		assert( tranp->t_lrutailp );
>  		winp = tranp->t_lruheadp;
>  		tranp->t_lruheadp = winp->w_nextp;
>  		if ( tranp->t_lruheadp ) {
> @@ -262,10 +263,10 @@ win_map( segix_t segix, void **pp )
>  		}
>  		tranp->t_segmap[winp->w_segix] = NULL;
>  		rval = munmap( winp->w_p, tranp->t_segsz );
> -		ASSERT( ! rval );
> +		assert( ! rval );
>  		memset( ( void * )winp, 0, sizeof( win_t ));
>  	} else {
> -		ASSERT( tranp->t_wincnt == tranp->t_winmax );
> +		assert( tranp->t_wincnt == tranp->t_winmax );
>  		*pp = NULL;
>  		CRITICAL_END();
>  		mlog( MLOG_NORMAL | MLOG_WARNING, _(
> @@ -279,12 +280,12 @@ win_map( segix_t segix, void **pp )
>  
>  	/* map the window
>  	 */
> -	ASSERT( tranp->t_segsz >= 1 );
> -	ASSERT( tranp->t_firstoff
> +	assert( tranp->t_segsz >= 1 );
> +	assert( tranp->t_firstoff
>  		<=
>  		OFF64MAX - segoff - ( off64_t )tranp->t_segsz + 1ll );
> -	ASSERT( ! ( tranp->t_segsz % pgsz ));
> -	ASSERT( ! ( ( tranp->t_firstoff + segoff ) % ( off64_t )pgsz ));
> +	assert( ! ( tranp->t_segsz % pgsz ));
> +	assert( ! ( ( tranp->t_firstoff + segoff ) % ( off64_t )pgsz ));
>  #ifdef TREE_DEBUG
>  	mlog(MLOG_DEBUG | MLOG_TREE | MLOG_NOLOCK,
>  	     "win_map(): mmap segment at %lld, size = %llu\n",
> @@ -317,7 +318,7 @@ win_map( segix_t segix, void **pp )
>  		return;
>  	}
>  	winp->w_segix  = segix;
> -	ASSERT( winp->w_refcnt == 0 );
> +	assert( winp->w_refcnt == 0 );
>  	winp->w_refcnt++;
>  	tranp->t_segmap[winp->w_segix] = winp;
>  
> @@ -335,36 +336,36 @@ win_unmap( segix_t segix, void **pp )
>  
>  	/* verify window mapped
>  	 */
> -	ASSERT( segix < tranp->t_segmaplen );
> +	assert( segix < tranp->t_segmaplen );
>  	winp = tranp->t_segmap[segix];
> -	ASSERT( winp );
> +	assert( winp );
>  
>  	/* validate p
>  	 */
> -	ASSERT( pp );
> -	ASSERT( *pp );
> -	ASSERT( *pp >= winp->w_p );
> -	ASSERT( *pp < ( void * )( ( char * )( winp->w_p ) + tranp->t_segsz ));
> +	assert( pp );
> +	assert( *pp );
> +	assert( *pp >= winp->w_p );
> +	assert( *pp < ( void * )( ( char * )( winp->w_p ) + tranp->t_segsz ));
>  
>  	/* decrement the reference count. if zero, place at tail of LRU list.
>  	 */
> -	ASSERT( winp->w_refcnt > 0 );
> +	assert( winp->w_refcnt > 0 );
>  	winp->w_refcnt--;
> -	ASSERT( ! winp->w_prevp );
> -	ASSERT( ! winp->w_nextp );
> +	assert( ! winp->w_prevp );
> +	assert( ! winp->w_nextp );
>  	if ( winp->w_refcnt == 0 ) {
>  		if ( tranp->t_lrutailp ) {
> -			ASSERT( tranp->t_lruheadp );
> +			assert( tranp->t_lruheadp );
>  			winp->w_prevp = tranp->t_lrutailp;
>  			tranp->t_lrutailp->w_nextp = winp;
>  			tranp->t_lrutailp = winp;
>  		} else {
> -			ASSERT( ! tranp->t_lruheadp );
> -			ASSERT( ! winp->w_prevp );
> +			assert( ! tranp->t_lruheadp );
> +			assert( ! winp->w_prevp );
>  			tranp->t_lruheadp = winp;
>  			tranp->t_lrutailp = winp;
>  		}
> -		ASSERT( ! winp->w_nextp );
> +		assert( ! winp->w_nextp );
>  	}
>  
>  	/* zero the caller's pointer
> @@ -385,7 +386,7 @@ win_segmap_resize(segix_t segix)
>  	tranp->t_segmaplen = segix + SEGMAP_INCR;
>  	tranp->t_segmap = (win_t **)
>  		realloc( tranp->t_segmap, tranp->t_segmaplen * sizeof(win_t *) );
> -	ASSERT( tranp->t_segmap );
> +	assert( tranp->t_segmap );
>  
>  	/* clear the new portion of the array */
>  	new_part = tranp->t_segmap + oldlen;
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
