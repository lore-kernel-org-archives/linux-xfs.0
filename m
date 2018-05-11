Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbeEKPU2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 May 2018 11:20:28 -0400
Date: Fri, 11 May 2018 11:20:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: teach xfs_bmapi_remap to accept some bmapi flags
Message-ID: <20180511152026.GI105683@bfoster.bfoster>
References: <152597988038.25215.9276761144353662866.stgit@magnolia>
 <152597993604.25215.2923117604057991749.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152597993604.25215.2923117604057991749.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 10, 2018 at 12:18:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach xfs_bmapi_remap how to map in unwritten extent and to skip rmap
> updates.  This enables us to rebuild real and unwritten extents from the
> rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b63e15a114f3..7660efb5beb0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4543,7 +4543,9 @@ xfs_bmapi_remap(
>  	ASSERT(len > 0);
>  	ASSERT(len <= (xfs_filblks_t)MAXEXTLEN);
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK)));
> +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
> +			   XFS_BMAPI_NORMAP)));
> +	ASSERT(!(flags & XFS_BMAPI_ATTRFORK) || !(flags & XFS_BMAPI_PREALLOC));

A little confusing.. how about something like?

	ASSERT((flags & XFS_BMAPI_ATTRFORK|XFS_BMAPI_PREALLOC) !=
		XFS_BMAPI_ATTRFORK|XFS_BMAPI_PREALLOC);

>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> @@ -4581,7 +4583,10 @@ xfs_bmapi_remap(
>  	got.br_startoff = bno;
>  	got.br_startblock = startblock;
>  	got.br_blockcount = len;
> -	got.br_state = XFS_EXT_NORM;
> +	if (flags & XFS_BMAPI_PREALLOC)
> +		got.br_state = XFS_EXT_UNWRITTEN;
> +	else
> +		got.br_state = XFS_EXT_NORM;

It's hard to see the wider picture without any users of this, but I do
notice that the one current caller appears to have everything passed
down to it to construct an xfs_bmbt_irec (in fact the data appears to
come from an irec in the first place).

Brian

>  
>  	error = xfs_bmap_add_extent_hole_real(tp, ip, whichfork, &icur,
>  			&cur, &got, &firstblock, dfops, &logflags, flags);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
