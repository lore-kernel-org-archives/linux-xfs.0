Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47A1F7F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:55:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 33CB48F8050
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 15:55:26 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	K5T6EpxAmUekaX8I for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 15:55:23 -0700 (PDT)
Date: Fri, 22 Aug 2014 08:55:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfsprogs: use ASSERT_ALWAYS for impossible switch case
Message-ID: <20140821225521.GR26465@dastard>
References: <53F62D12.8010505@sandeen.net>
 <53F639F6.6050905@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F639F6.6050905@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 01:27:02PM -0500, Eric Sandeen wrote:
> The original reason for the expletive below has been lost
> in the mists of time, but at any rate, ASSERT() goes away in
> libxfs, and this leads static analysis checkers to believe that
> XFS_BTNUM_MAX is possible, and that we might overflow an array
> later when using it as an index.
> 
> We can shut this up and mark it as truly impossible by adding
> a userspace definition for ASSERT_ALWAYS and using it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: do it in a kernel-compatible way.
> 
> diff --git a/include/xfs_btree.h b/include/xfs_btree.h
> index 2590d40..f24f787 100644
> --- a/include/xfs_btree.h
> +++ b/include/xfs_btree.h
> @@ -69,7 +69,7 @@ do {    \
>  	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
> -	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
> +	case XFS_BTNUM_MAX: ASSERT_ALWAYS(0); /* fucking gcc */ ; break; \
>  	}       \
>  } while (0)
>  
> @@ -83,7 +83,7 @@ do {    \
>  	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
> -	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
> +	case XFS_BTNUM_MAX: ASSERT_ALWAYS(0); /* fucking gcc */ ; break; \
>  	}       \
>  } while (0)

Which we don't want in kernel space, because we want that case to be
optimised out by the compiler for production kernels....

What we should really do is properly abstract the btree stats
structure and put a pointer into the cursor so that the switch
statement can go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
