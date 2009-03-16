Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2GAlec9085758 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 05:48:00 -0500
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 796F01C46041
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 03:47:18 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	lXeQq0OPRWQSLzKY for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 03:47:18 -0700 (PDT)
Date: Mon, 16 Mar 2009 21:47:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] [XFS] Split inode data writeback from inode sync.
Message-ID: <20090316104712.GJ26138@disturbed>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
	<1237117603-26071-2-git-send-email-david@fromorbit.com>
	<20090316101008.GA2874@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090316101008.GA2874@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Mar 16, 2009 at 06:10:08AM -0400, Christoph Hellwig wrote:
> > +static int
> > +xfs_sync_inode_data(
> > +	struct xfs_inode	*ip,
> > +	int			flags)
> > +{
> > +	struct inode	*inode = VFS_I(ip);
> > +	int		error = 0;
> > +
> > +	if (VN_DIRTY(inode)) {
> > +		int	locked = 0;
> > +		if (flags & SYNC_TRYLOCK) {
> > +			if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> > +				locked = 1;
> > +		} else {
> > +			xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > +			locked = 1;
> > +		}
> > +		if (locked) {
> > +			error = xfs_flush_pages(ip, 0, -1,
> > +					(flags & SYNC_WAIT) ? 0 : XFS_B_ASYNC,
> > +					FI_NONE);
> > +			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> > +		}
> > +	}
> > +
> > +	if (flags & SYNC_IOWAIT)
> > +		xfs_ioend_wait(ip);
> > +
> > +	return error;
> > +}
> 
> In the end this should look more like:
> 
> 
> 
> static int
> xfs_sync_inode_data(
> 	struct xfs_inode	*ip,
> 	int			flags)
> {
> 	struct inode	*inode = VFS_I(ip);
> 	struct address_space *mapping = inode->i_mapping;
> 	int		error = 0;
> 
> 	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> 		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
> 			if (flags & SYNC_TRYLOCK)
> 				goto out;
> 			xfs_ilock(ip, XFS_IOLOCK_SHARED);
> 		}
> 
> 		if (flags & SYNC_WAIT) {
> 			error = filemap_write_and_wait(mapping);
> 		else
> 			error = filemap_fdatawrite(mapping);
> 
> 		xfs_iflags_clear(ip, XFS_ITRUNCATED);
> 		xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> 	}
> 
>  out:
> 	if (flags & SYNC_IOWAIT)
> 		xfs_ioend_wait(ip);
> 	return -error;
> }

Seems sane. I'll rework it around this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
