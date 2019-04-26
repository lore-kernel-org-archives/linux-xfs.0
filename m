Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34154 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfDZOc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Apr 2019 10:32:28 -0400
Date: Fri, 26 Apr 2019 07:30:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: add missing error check in xfs_prepare_shift()
Message-ID: <20190426143009.GN178290@magnolia>
References: <20190426120633.36420-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426120633.36420-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 26, 2019 at 08:06:33AM -0400, Brian Foster wrote:
> xfs_prepare_shift() fails to check the error return from
> xfs_flush_unmap_range(). If the latter fails, that could lead to an
> insert/collapse range operation over a delalloc range, which is not
> supported.
> 
> Add an error check and return appropriately. This is reproduced
> rarely by generic/475.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2db43ff4f8b5..06d07f1e310b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1193,6 +1193,8 @@ xfs_prepare_shift(
>  	 * about to shift down every extent from offset to EOF.
>  	 */
>  	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * Clean out anything hanging around in the cow fork now that
> -- 
> 2.17.2
> 
