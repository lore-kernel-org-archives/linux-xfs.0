Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 133E57F7B
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 19:35:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E75118F804C
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:35:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kQE7cRPOKRoDSxy0 for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 17:35:40 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:35:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/24] xfs: refcount btree add more reserved blocks
Message-ID: <20150730003517.GH16638@dastard>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223324.17414.85659.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223324.17414.85659.stgit@birch.djwong.org>
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

On Wed, Jul 29, 2015 at 03:33:24PM -0700, Darrick J. Wong wrote:
> Since XFS reserves a small amount of space in each AG as the minimum
> free space needed for an operation, save some more space in case we
> touch the refcount btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c  |   13 +++++++++++++
>  fs/xfs/libxfs/xfs_format.h |    2 ++
>  2 files changed, 15 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 40e8129..cb6b3d9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -50,10 +50,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
>  STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>  		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
>  
> +unsigned int
> +XFS_REFC_BLOCK(

No need to shout for functions.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
