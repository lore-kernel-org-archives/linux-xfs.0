Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8941 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbeENK0e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 06:26:34 -0400
Date: Mon, 14 May 2018 06:26:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 8/8] xfs: teach xfs_bmapi_remap to accept some bmapi
 flags
Message-ID: <20180514102632.GC8919@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597993604.25215.2923117604057991749.stgit@magnolia>
 <20180511234616.GL11261@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511234616.GL11261@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 04:46:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
> updates.  This enables us to rebuild real and unwritten extents from the
> rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: tidy up the assert checking for ATTR|PREALLOC
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b63e15a114f3..7b0e2b551e23 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4543,7 +4543,10 @@ xfs_bmapi_remap(
>  	ASSERT(len > 0);
>  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
> +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
> +			   XFS_BMAPI_NORMAP)));
> +	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
> +			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> @@ -4581,7 +4584,10 @@ xfs_bmapi_remap(
>  	got.br_startoff = bno;
>  	got.br_startblock = startblock;
>  	got.br_blockcount = len;
> -	got.br_state = XFS_EXT_NORM;
> +	if (flags & XFS_BMAPI_PREALLOC)
> +		got.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		got.br_state = XFS_EXT_NORM;
>  
>  	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
>  			&cur, &got, &firstblock, dfops, &logflags, flags);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
