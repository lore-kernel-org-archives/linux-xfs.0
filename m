Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:22422 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751117AbeDEXM0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:12:26 -0400
Date: Fri, 6 Apr 2018 09:12:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/21] xfs: make xfs_bmapi_remapi work with attribute
 forks
Message-ID: <20180405231223.GK23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269901338.16346.3950698529446189331.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269901338.16346.3950698529446189331.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:56:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new flags argument to xfs_bmapi_remapi so that we can pass BMAPI
> flags into the function.  This enables us to pass in BMAPI_ATTRFORK so
> that we can remap things into the attribute fork.  Eventually the
> online repair code will use this to rebuild attribute forks, so make it
> non-static.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   36 +++++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_bmap.h |    4 ++++
>  2 files changed, 27 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 519ef9c..c676d5c 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4512,30 +4512,37 @@ xfs_bmapi_write(
>  	return error;
>  }
>  
> -static int
> +int
>  xfs_bmapi_remap(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		bno,
>  	xfs_filblks_t		len,
>  	xfs_fsblock_t		startblock,
> -	struct xfs_defer_ops	*dfops)
> +	struct xfs_defer_ops	*dfops,
> +	int			flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_ifork	*ifp;
>  	struct xfs_btree_cur	*cur = NULL;
>  	xfs_fsblock_t		firstblock = NULLFSBLOCK;
>  	struct xfs_bmbt_irec	got;
>  	struct xfs_iext_cursor	icur;
> +	int			whichfork = xfs_bmapi_whichfork(flags);
>  	int			logflags = 0, error;
>  
> +	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	ASSERT(len > 0);
>  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(!(flags & (XFS_BMAPI_DELALLOC | XFS_BMAPI_COWFORK |
> +			  XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT |
> +			  XFS_BMAPI_IGSTATE | XFS_BMAPI_METADATA |
> +			  XFS_BMAPI_ENTIRE | XFS_BMAPI_CONVERT_ONLY)));

Wouldn't it be better just to assert it's a flag that is supported?
i.e.

	ASSERT(!flags || (flags & XFS_BMAPI_ATTRFORK));

> @@ -4569,18 +4576,21 @@ xfs_bmapi_remap(
>  	got.br_startoff = bno;
>  	got.br_startblock = startblock;
>  	got.br_blockcount = len;
> -	got.br_state = XFS_EXT_NORM;
> +	if (flags & XFS_BMAPI_PREALLOC)
> +		got.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		got.br_state = XFS_EXT_NORM;

This seems unrelated to the attr fork support change?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
