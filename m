Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFGQ4hR015632 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 10:26:04 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MYLnI3v5EJEKJ2Ua (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 08:28:08 -0800 (PST)
Date: Thu, 15 Nov 2012 11:28:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/32] xfs: remove xfs_flushinval_pages
Message-ID: <20121115162807.GE4019@infradead.org>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352721264-3700-6-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> -		if ((iocb->ki_pos & target->bt_smask) ||
> -		    (size & target->bt_smask)) {
> -			if (iocb->ki_pos == i_size_read(inode))
> +		if ((pos & target->bt_smask) || (size & target->bt_smask)) {
> +			if (pos == i_size_read(inode))
>  				return 0;
>  			return -XFS_ERROR(EINVAL);
>  		}
>  	}
>  
> -	n = mp->m_super->s_maxbytes - iocb->ki_pos;
> +	n = mp->m_super->s_maxbytes - pos;

What does this have to do with the recent of the patch?

Not that is diapprove, but I don't think it fits here.

>  		if (inode->i_mapping->nrpages) {
> -			ret = -xfs_flushinval_pages(ip,
> -					(iocb->ki_pos & PAGE_CACHE_MASK),
> -					-1, FI_REMAPF_LOCKED);
> +			ret = -filemap_write_and_wait_range(
> +							VFS_I(ip)->i_mapping,
> +							pos, -1);
>  			if (ret) {
>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>  				return ret;
>  			}
> +			truncate_pagecache_range(VFS_I(ip), pos, -1);

We already have a local "inode" variable that can be used in these two
places.

Also the -1 end might be a 1:1 translation of what was there, but is not what
we really want.  At very least it needs an XXX comment that the range should
be revisited.

> @@ -670,10 +670,11 @@ xfs_file_dio_aio_write(
>  		goto out;
>  
>  	if (mapping->nrpages) {
> -		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
> -							FI_REMAPF_LOCKED);
> +		ret = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> +						    pos, -1);
>  		if (ret)
>  			goto out;
> +		truncate_pagecache_range(VFS_I(ip), pos, -1);

We already have local mapping and inode variables here, same comment
about the -1 len.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
