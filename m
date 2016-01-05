Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08A297F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 19:23:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96B2DAC002
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:23:17 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yQFFGXvo1FXwqs8J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 17:23:15 -0800 (PST)
Date: Mon, 4 Jan 2016 17:23:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: pass inode instead of file to
	xfs_reflink_dirty_range
Message-ID: <20160105012309.GI28330@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451822873-12969-2-git-send-email-hch@lst.de>
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

On Sun, Jan 03, 2016 at 01:07:51PM +0100, Christoph Hellwig wrote:
> We don't actually need a file for write_begin/end, those can be passed
> as NULL for disk based file systems.  This is important as we won't

I wasn't aware that one could /do/ that. :)

Looks good, though.  I think I can clean the filp arguments out of the reflink
code entirely, too.

--D

> even have a file pointer during a truncate operation, which gives a
> guaranteed NULL pointer dererference with the current code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index da4a715..4a3f0ee 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1316,7 +1316,7 @@ out_error:
>   */
>  STATIC int
>  xfs_reflink_dirty_range(
> -	struct file		*filp,
> +	struct inode		*inode,
>  	xfs_off_t		pos,
>  	xfs_off_t		len)
>  {
> @@ -1330,14 +1330,14 @@ xfs_reflink_dirty_range(
>  	unsigned long		bytes;	/* Bytes to write to page */
>  	void			*fsdata;
>  
> -	mapping = filp->f_mapping;
> +	mapping = inode->i_mapping;
>  	a_ops = mapping->a_ops;
>  	flags = AOP_FLAG_UNINTERRUPTIBLE;
>  	do {
>  
>  		offset = (pos & (PAGE_CACHE_SIZE - 1));
>  		bytes = min_t(unsigned long, len, PAGE_CACHE_SIZE) - offset;
> -		rpage = xfs_get_page(file_inode(filp), pos);
> +		rpage = xfs_get_page(inode, pos);
>  		if (IS_ERR(rpage)) {
>  			error = PTR_ERR(rpage);
>  			break;
> @@ -1346,24 +1346,24 @@ xfs_reflink_dirty_range(
>  			break;
>  		}
>  
> -		error = a_ops->write_begin(filp, mapping, pos, bytes, flags,
> +		error = a_ops->write_begin(NULL, mapping, pos, bytes, flags,
>  					   &page, &fsdata);
>  		page_cache_release(rpage);
>  		if (error < 0)
>  			break;
>  
> -		trace_xfs_reflink_unshare_page(file_inode(filp), page,
> +		trace_xfs_reflink_unshare_page(inode, page,
>  				pos, bytes);
>  
>  		if (!PageUptodate(page)) {
> -			pr_err("%s: STALE? ino=%lu pos=%llu\n",
> -				__func__, filp->f_inode->i_ino, pos);
> +			pr_err("%s: STALE? ino=%llu pos=%llu\n",
> +				__func__, XFS_I(inode)->i_ino, pos);
>  			WARN_ON(1);
>  		}
>  		if (mapping_writably_mapped(mapping))
>  			flush_dcache_page(page);
>  
> -		error = a_ops->write_end(filp, mapping, pos, bytes, bytes,
> +		error = a_ops->write_end(NULL, mapping, pos, bytes, bytes,
>  					 page, fsdata);
>  		if (error < 0)
>  			break;
> @@ -1454,7 +1454,7 @@ xfs_reflink_dirty_extents(
>  			flen = XFS_FSB_TO_B(mp, rlen);
>  			if (fpos + flen > isize)
>  				flen = isize - fpos;
> -			error = xfs_reflink_dirty_range(filp, fpos, flen);
> +			error = xfs_reflink_dirty_range(VFS_I(ip), fpos, flen);
>  			xfs_ilock(ip, XFS_ILOCK_EXCL);
>  			if (error)
>  				goto out;
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
