Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753924AbeGFDrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:47:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663iAL4006243
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:47:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2k0dnt8200-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:47:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w663ldkf016033
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:47:39 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w663ldRs020200
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:47:39 GMT
Date: Thu, 5 Jul 2018 20:47:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 3/8] xfs: convert inode from extents to local format
Message-ID: <20180706034737.GR32415@magnolia>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-4-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-4-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:24AM +0800, Shan Hai wrote:
> Introduce a function to convert an inode from extents to local
> format. The conversion happens at writeback time, this avoids
> interfering with the delayed allocation and page cache vs
> xfs_buf operations, the will be inlined data is directly got
> from the page which was read and modified by the iomap write actor.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/xfs_aops.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 8eb3ba3d4d00..ac5a7695f363 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -9,6 +9,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_defer.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
> @@ -887,6 +888,55 @@ xfs_map_cow(
>  	return 0;
>  }
>  
> +static int
> +xfs_inode_extents_to_local(
> +	xfs_inode_t		*ip,
> +	int			whichfork,
> +	struct page		*page)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	struct xfs_defer_ops	dfops;
> +	xfs_fsblock_t		first_block;
> +	int			logflags;
> +	int			error = 0;
> +
> +	if (i_size_read(VFS_I(ip)) > XFS_IFORK_DSIZE(ip))
> +		return 0;

If it's too big to fit in local format, then isn't this an error?

--D

> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	xfs_defer_init(&dfops, &first_block);
> +
> +	logflags = 0;
> +	error = xfs_bmap_extents_to_local(tp, ip, &dfops, &logflags,
> +			XFS_DATA_FORK, page);
> +	if (error)
> +		goto trans_cancel;
> +
> +	xfs_trans_log_inode(tp, ip, logflags);
> +	error = xfs_defer_finish(&tp, &dfops);
> +	if (error)
> +		goto trans_cancel;
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto error0;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	return 0;
> +
> +trans_cancel:
> +	xfs_defer_cancel(&dfops);
> +	xfs_trans_cancel(tp);
> +error0:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
>  /*
>   * We implement an immediate ioend submission policy here to avoid needing to
>   * chain multiple ioends and hence nest mempool allocations which can violate
> @@ -920,6 +970,8 @@ xfs_writepage_map(
>  	int			count = 0;
>  	int			uptodate = 1;
>  	unsigned int		new_type;
> +	xfs_inode_t		*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
>  
>  	bh = head = page_buffers(page);
>  	offset = page_offset(page);
> @@ -1044,6 +1096,14 @@ xfs_writepage_map(
>  		end_page_writeback(page);
>  	}
>  
> +	if (!error) {
> +		if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
> +				i_size_read(inode) <= XFS_IFORK_DSIZE(ip)) {
> +			error = xfs_inode_extents_to_local(ip, XFS_DATA_FORK,
> +								page);
> +		}
> +	}
> +
>  	mapping_set_error(page->mapping, error);
>  	return error;
>  }
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
