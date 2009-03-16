Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAATNj083525 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:10:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1965A19C7D0
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:10:08 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FTi0MUil3pnJO2f6 for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:10:08 -0700 (PDT)
Date: Mon, 16 Mar 2009 06:10:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] [XFS] Split inode data writeback from inode sync.
Message-ID: <20090316101008.GA2874@infradead.org>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
	<1237117603-26071-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237117603-26071-2-git-send-email-david@fromorbit.com>
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

> +static int
> +xfs_sync_inode_data(
> +	struct xfs_inode	*ip,
> +	int			flags)
> +{
> +	struct inode	*inode = VFS_I(ip);
> +	int		error = 0;
> +
> +	if (VN_DIRTY(inode)) {
> +		int	locked = 0;
> +		if (flags & SYNC_TRYLOCK) {
> +			if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> +				locked = 1;
> +		} else {
> +			xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +			locked = 1;
> +		}
> +		if (locked) {
> +			error = xfs_flush_pages(ip, 0, -1,
> +					(flags & SYNC_WAIT) ? 0 : XFS_B_ASYNC,
> +					FI_NONE);
> +			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +		}
> +	}
> +
> +	if (flags & SYNC_IOWAIT)
> +		xfs_ioend_wait(ip);
> +
> +	return error;
> +}

In the end this should look more like:



static int
xfs_sync_inode_data(
	struct xfs_inode	*ip,
	int			flags)
{
	struct inode	*inode = VFS_I(ip);
	struct address_space *mapping = inode->i_mapping;
	int		error = 0;

	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
			if (flags & SYNC_TRYLOCK)
				goto out;
			xfs_ilock(ip, XFS_IOLOCK_SHARED);
		}

		if (flags & SYNC_WAIT) {
			error = filemap_write_and_wait(mapping);
		else
			error = filemap_fdatawrite(mapping);

		xfs_iflags_clear(ip, XFS_ITRUNCATED);
		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
	}

 out:
	if (flags & SYNC_IOWAIT)
		xfs_ioend_wait(ip);
	return -error;
}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
