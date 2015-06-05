Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 388C77F4E
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 21:15:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1905D8F8054
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2015 19:15:28 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5avEO5wBJ9gpdZdF for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2015 19:15:25 -0700 (PDT)
Date: Fri, 5 Jun 2015 12:14:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: silence unused var warnings
Message-ID: <20150605021454.GP9143@dastard>
References: <55551F12.1070308@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55551F12.1070308@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 14, 2015 at 05:17:54PM -0500, Eric Sandeen wrote:
> This takes 2 different approaches, just following similar code
> that already exists.  It'll probably make Coverity flag
> the pointless assignments, unfortunately.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Note, this is for the libxfs-4 branch
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 1b4ac64..c871d53 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -150,9 +150,9 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>  #define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
>  #define XFS_TEST_ERROR(expr,a,b,c)	( expr )
>  #define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)	\
> -		{ if (!(expr)) { error = EFSCORRUPTED; goto l; } }
> +		{ (mp) = (mp); if (!(expr)) { error = EFSCORRUPTED; goto l; } }
>  #define XFS_WANT_CORRUPTED_RETURN(mp, expr)	\
> -		{ if (!(expr)) { return EFSCORRUPTED; } }
> +		{ (mp) = (mp); if (!(expr)) { return EFSCORRUPTED; } }
>  
>  #ifdef __GNUC__
>  #define __return_address	__builtin_return_address(0)
> @@ -344,7 +344,11 @@ roundup_64(__uint64_t x, __uint32_t y)
>  
>  /* space allocation */
>  #define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
> -#define xfs_extent_busy_insert(tp,ag,bno,len,flags)	((void) 0)
> +/* avoid unused variable warning */
> +#define xfs_extent_busy_insert(tp,ag,bno,len,flags)({ 	\
> +	xfs_agnumber_t __foo = ag; 			\
> +	__foo = 0;					\
> +})

libxfs_priv.h:349:17: warning: variable '__foo' set but not used [-Wunused-but-set-variable]
  xfs_agnumber_t __foo = ag;    \

so I changed the second line to __foo = __foo; to get rid of this
warning, as several of the other macros in that file do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
