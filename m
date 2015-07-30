Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 974807F66
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 19:35:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84E0F304043
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:35:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jNVEwHQXJhVQvr62 for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 17:35:16 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:34:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/24] xfs: add refcount btree stats infrastructure
Message-ID: <20150730003427.GG16638@dastard>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223318.17414.21535.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223318.17414.21535.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 29, 2015 at 03:33:18PM -0700, Darrick J. Wong wrote:
> The refcount btree presents the same stats as the other btrees, so
> add all the code for that now.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.h |    4 ++--
>  fs/xfs/xfs_stats.c        |    1 +
>  fs/xfs/xfs_stats.h        |   18 +++++++++++++++++-
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 8d9fffe..b747c86 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -99,7 +99,7 @@ do {    \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
>  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
> -	case XFS_BTNUM_REFC: break;	\
> +	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
>  	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
>  	}       \
>  } while (0)
> @@ -115,7 +115,7 @@ do {    \
>  	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
>  	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
>  	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
> -	case XFS_BTNUM_REFC: break;	\
> +	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \

__XFS_BTREE_STATS_ADD()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
