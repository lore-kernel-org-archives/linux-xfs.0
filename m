Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 108FE7F91
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 12:03:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FFD8AC001
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 10:03:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4dXE7SGkD2hkGQ5Q for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 10:03:16 -0700 (PDT)
Message-ID: <55D759D4.8060101@sandeen.net>
Date: Fri, 21 Aug 2015 12:03:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfsdump: use 64bit local variables in inode.c
References: <20150821193047.661578219@gulag1.americas.sgi.com>
	<20150821193241.899709228@gulag1.americas.sgi.com>
In-Reply-To: <20150821193241.899709228@gulag1.americas.sgi.com>
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
To: rjohnston@sgi.com, xfs@oss.sgi.com

On 8/21/15 9:01 AM, rjohnston@sgi.com wrote:
> The memset in cb_add_inogrp will segfault when the index oldsize
> overflows. In cb_add_inogrp(), the temp variables used in
> calculating the new i2gmap segment offset should be int64 instead
> of intgen_t (int32).
> 
> Fix this:
>   a. simplify the calculation of oldsize by moving it
>      before hnkmaplen is incremented.

I think it'd make more sense to put a) in the second patch; it's
unrelated to the variable size changes.

Still wrapping my head around what these variables are for, but
makes sense at first glance.

Thanks,
-Eric

>   b. change the index variables int64 to prevent overflow. 
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> ---
>  dump/inomap.c |   41 +++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> Index: b/dump/inomap.c
> ===================================================================
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -71,7 +71,7 @@ static intgen_t cb_context( bool_t last,
>  			    drange_t *,
>  			    startpt_t *,
>  			    size_t,
> -			    intgen_t,
> +			    int64_t,
>  			    bool_t,
>  			    bool_t *);
>  static void cb_context_free( void );
> @@ -96,7 +96,7 @@ static off64_t estimate_dump_space( xfs_
>  
>  /* inomap primitives
>   */
> -static intgen_t inomap_init( intgen_t igrpcnt );
> +static intgen_t inomap_init( int64_t igrpcnt );
>  static void inomap_add( void *, xfs_ino_t ino, gen_t gen, intgen_t );
>  static intgen_t inomap_set_state( void *, xfs_ino_t ino, intgen_t );
>  static void inomap_set_gen(void *, xfs_ino_t, gen_t );
> @@ -160,7 +160,7 @@ inomap_build( jdm_fshandle_t *fshandlep,
>  	xfs_bstat_t *bstatbufp;
>  	size_t bstatbuflen;
>  	bool_t pruneneeded = BOOL_FALSE;
> -	intgen_t igrpcnt = 0;
> +	int64_t igrpcnt = 0;
>  	intgen_t stat;
>  	intgen_t rval;
>  
> @@ -449,7 +449,7 @@ cb_context( bool_t last,
>  	    drange_t *resumerangep,
>  	    startpt_t *startptp,
>  	    size_t startptcnt,
> -	    intgen_t igrpcnt,
> +	    int64_t igrpcnt,
>  	    bool_t skip_unchanged_dirs,
>  	    bool_t *pruneneededp )
>  {
> @@ -949,14 +949,14 @@ struct i2gseg {
>  typedef struct i2gseg i2gseg_t;
>  
>  typedef struct seg_addr {
> -	intgen_t hnkoff;
> -	intgen_t segoff;
> -	intgen_t inooff;
> +	int64_t hnkoff;
> +	int64_t segoff;
> +	int64_t inooff;
>  } seg_addr_t;
>  
>  static struct inomap {
>  	hnk_t *hnkmap;
> -	intgen_t hnkmaplen;
> +	int64_t hnkmaplen;
>  	i2gseg_t *i2gmap;
>  	seg_addr_t lastseg;
>  } inomap;
> @@ -1040,7 +1040,7 @@ SEG_GET_BITS( seg_t *segp, xfs_ino_t ino
>  /* context for inomap construction - initialized by map_init
>   */
>  static intgen_t
> -inomap_init( intgen_t igrpcnt )
> +inomap_init( int64_t igrpcnt )
>  {
>  	ASSERT( sizeof( hnk_t ) == HNKSZ );
>  
> @@ -1066,7 +1066,7 @@ inomap_getsz( void )
>  static inline bool_t
>  inomap_validaddr( seg_addr_t *addrp )
>  {
> -	intgen_t maxseg;
> +	int64_t maxseg;
>  
>  	if ( addrp->hnkoff < 0 || addrp->hnkoff > inomap.lastseg.hnkoff )
>  		return BOOL_FALSE;
> @@ -1093,13 +1093,13 @@ inomap_addr2seg( seg_addr_t *addrp )
>  	return &hunkp->seg[addrp->segoff];
>  }
>  
> -static inline intgen_t
> +static inline int64_t
>  inomap_addr2segix( seg_addr_t *addrp )
>  {
>  	return ( addrp->hnkoff * SEGPERHNK ) + addrp->segoff;
>  }
>  
> -static inline intgen_t
> +static inline int64_t
>  inomap_lastseg( intgen_t hnkoff )
>  {
>  	if ( hnkoff == inomap.lastseg.hnkoff )
> @@ -1125,8 +1125,11 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
>  		lastsegp->segoff = 0;
>  
>  		if (lastsegp->hnkoff == inomap.hnkmaplen) {
> -			intgen_t numsegs;
> -			intgen_t oldsize;
> +			int64_t numsegs;
> +			int64_t oldsize;
> +
> +			oldsize = inomap.hnkmaplen * SEGPERHNK
> +				  * sizeof(i2gseg_t);
>  
>  			inomap.hnkmaplen++;
>  			inomap.hnkmap = (hnk_t *)
> @@ -1140,8 +1143,6 @@ cb_add_inogrp( void *arg1, intgen_t fsfd
>  				return -1;
>  
>  			/* zero the new portion of the i2gmap */
> -			oldsize = (numsegs - SEGPERHNK) * sizeof(i2gseg_t);
> -
>  			memset(inomap.i2gmap + oldsize,
>  			       0,
>  			       SEGPERHNK * sizeof(i2gseg_t));
> @@ -1199,8 +1200,8 @@ static bool_t
>  inomap_find_hnk( seg_addr_t *addrp, xfs_ino_t ino )
>  {
>  	hnk_t *hunkp;
> -	intgen_t lower;
> -	intgen_t upper;
> +	int64_t lower;
> +	int64_t upper;
>  
>  	lower = 0;
>  	upper = inomap.lastseg.hnkoff;
> @@ -1231,8 +1232,8 @@ static bool_t
>  inomap_find_seg( seg_addr_t *addrp, xfs_ino_t ino )
>  {
>  	seg_t *segp;
> -	intgen_t lower;
> -	intgen_t upper;
> +	int64_t lower;
> +	int64_t upper;
>  
>  	if ( !inomap_validaddr( addrp ) ) {
>  		inomap_reset_context( addrp );
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
