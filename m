Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D3BB7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 19:28:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A020304062
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:28:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id DV3Kh6StlkHTxCT6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 17:28:38 -0800 (PST)
Date: Mon, 4 Jan 2016 17:28:32 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: only end a COW operation in
	xfs_zero_remaining_bytes if we started one
Message-ID: <20160105012832.GJ28330@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451822873-12969-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Jan 03, 2016 at 01:07:52PM +0100, Christoph Hellwig wrote:
> Without these we can see NULL pointer dereferences due to a non-existing
> COW fork during xfstests runs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7bee3c7..e777095 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1226,13 +1226,15 @@ xfs_zero_remaining_bytes(
>  
>  		error = xfs_bwrite(bp);
>  		xfs_buf_relse(bp);
> -		if (error) {
> -			err2 = xfs_reflink_end_cow_failed(ip, offset,
> +		if (should_fork) {
> +			if (error) {
> +				err2 = xfs_reflink_end_cow_failed(ip, offset,
> +						lastoffset - offset + 1);
> +				return error;
> +			}
> +			error = xfs_reflink_end_cow(ip, offset,
>  					lastoffset - offset + 1);
> -			return error;
>  		}

Good catch!  There's a buffer leak in the error case for xfs_map_cow_blocks()
so I'll fold them both into the original patch.

--D

> -		error = xfs_reflink_end_cow(ip, offset,
> -				lastoffset - offset + 1);
>  		if (error)
>  			return error;
>  	}
> -- 
> 1.9.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
