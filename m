Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36718 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdIDQPo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 12:15:44 -0400
Received: by mail-wr0-f177.google.com with SMTP id p14so903044wrg.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Sep 2017 09:15:43 -0700 (PDT)
Date: Mon, 4 Sep 2017 18:15:39 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: evict CoW fork extents when performing
 finsert/fcollapse
Message-ID: <20170904161539.2nmwabsljybd2lwi@hades.localdomain>
References: <20170904154941.GB4660@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904154941.GB4660@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Sep 04, 2017 at 08:49:41AM -0700, Darrick J. Wong wrote:
> When we perform an finsert/fcollapse operation, cancel all the CoW
> extents for the affected file offset range so that they don't end up
> pointing to the wrong blocks.
> 
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_bmap_util.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index cd9a540..bc6c6e1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1459,7 +1459,19 @@ xfs_shift_file_space(
>  		return error;
>  
>  	/*
> -	 * The extent shiting code works on extent granularity. So, if
> +	 * Clean out anything hanging around in the cow fork now that
> +	 * we've flushed all the dirty data out to disk to avoid having
> +	 * CoW extents at the wrong offsets.
> +	 */
> +	if (xfs_is_reflink_inode(ip)) {
> +		error = xfs_reflink_cancel_cow_range(ip, offset, NULLFILEOFF,
> +				true);
> +		if (error)
> +			return error;
> +	}
> +
> +	/*
> +	 * The extent shifting code works on extent granularity. So, if
>  	 * stop_fsb is not the starting block of extent, we need to split
>  	 * the extent at stop_fsb.
>  	 */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
