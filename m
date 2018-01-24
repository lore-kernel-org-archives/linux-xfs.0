Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeAXAN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jan 2018 19:13:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0O0Bv7C158511
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 00:13:56 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2fpf2vg2p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 00:13:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0O0DsMU029026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 00:13:54 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0O0DsSh013106
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2018 00:13:54 GMT
Date: Tue, 23 Jan 2018 16:13:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/1] xfs: bmap code cleanup
Message-ID: <20180124001353.GT25805@magnolia>
References: <1516696944-11996-1-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516696944-11996-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 23, 2018 at 04:42:24PM +0800, Shan Hai wrote:
> Remove the extent size hint and realtime inode relevant code from
> the xfs_bmapi_reserve_delalloc since it is not called on the inode
> with extent size hint set or on a realtime inode.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 32 ++++++++------------------------
>  1 file changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 1bddbba6b80c..8b4ab1932b58 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3876,8 +3876,6 @@ xfs_bmapi_reserve_delalloc(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	xfs_extlen_t		alen;
>  	xfs_extlen_t		indlen;
> -	char			rt = XFS_IS_REALTIME_INODE(ip);
> -	xfs_extlen_t		extsz;
>  	int			error;
>  	xfs_fileoff_t		aoff = off;
>  
> @@ -3892,31 +3890,25 @@ xfs_bmapi_reserve_delalloc(
>  		prealloc = alen - len;
>  
>  	/* Figure out the extent size, adjust alen */
> -	if (whichfork == XFS_COW_FORK)
> -		extsz = xfs_get_cowextsz_hint(ip);
> -	else
> -		extsz = xfs_get_extsz_hint(ip);

This patch reminded me that I'd been wondering since the early days of
reflink development -- why /does/ this function have the ability to
align delalloc reservations, considering that none of the write paths
seem to use it?  Was this just some nugget from the old days?  Will the
CoW fork be ok if its tries to cowextsize align its da reservations?

So I went digging into the git history and came up with aff3a9edb70
wherein Dave discovered that the result of these larger da reservations
was that the whole extent could get allocated, but left some kind of
stale data exposure problem.  (I guess because we shoved the whole real
extent into the extent map?  I wasn't around in the 3.4 days...)
Therefore, the easiest solution was to go straight to making an
unwritten allocation, and any subsequent read would always return
zeroes, the same as directio does.

The CoW fork doesn't have this problem because even if we create large
da reservations and then allocate the whole extent including parts that
aren't mapped by the page cache, the CoW fork extents aren't used for
reads and they aren't mapped into the (permanent) data fork unless we
actually write something to that range.

> -	if (extsz) {
> +	if (whichfork == XFS_COW_FORK) {
>  		struct xfs_bmbt_irec	prev;
> +		xfs_extlen_t extsz = xfs_get_cowextsz_hint(ip);

Please line up the variable names:

struct xfs_bmbt_irec	prev;
xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);

Otherwise it looks ok.  I think I'll just edit this on its way in.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
>  			prev.br_startoff = NULLFILEOFF;
>  
> -		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, rt, eof,
> +		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
>  					       1, 0, &aoff, &alen);
>  		ASSERT(!error);
>  	}
>  
> -	if (rt)
> -		extsz = alen / mp->m_sb.sb_rextsize;
> -
>  	/*
>  	 * Make a transaction-less quota reservation for delayed allocation
>  	 * blocks.  This number gets adjusted later.  We return if we haven't
>  	 * allocated blocks already inside this loop.
>  	 */
>  	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
> -			rt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> +						XFS_QMOPT_RES_REGBLKS);
>  	if (error)
>  		return error;
>  
> @@ -3927,12 +3919,7 @@ xfs_bmapi_reserve_delalloc(
>  	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
>  	ASSERT(indlen > 0);
>  
> -	if (rt) {
> -		error = xfs_mod_frextents(mp, -((int64_t)extsz));
> -	} else {
> -		error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
> -	}
> -
> +	error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
>  	if (error)
>  		goto out_unreserve_quota;
>  
> @@ -3963,14 +3950,11 @@ xfs_bmapi_reserve_delalloc(
>  	return 0;
>  
>  out_unreserve_blocks:
> -	if (rt)
> -		xfs_mod_frextents(mp, extsz);
> -	else
> -		xfs_mod_fdblocks(mp, alen, false);
> +	xfs_mod_fdblocks(mp, alen, false);
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
> -		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0, rt ?
> -				XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
> +		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
> +						XFS_QMOPT_RES_REGBLKS);
>  	return error;
>  }
>  
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
