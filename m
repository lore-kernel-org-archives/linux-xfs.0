Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 911D67CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:58:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04F75AC003
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:58:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AoOhO0L5xes9PdTy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:58:16 -0700 (PDT)
Date: Thu, 14 Apr 2016 08:58:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: implement iomap based buffered write path
Message-ID: <20160414125814.GE20696@bfoster.bfoster>
References: <1460494382-14547-1-git-send-email-hch@lst.de>
	<1460494382-14547-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460494382-14547-6-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 12, 2016 at 01:52:59PM -0700, Christoph Hellwig wrote:
> Convert XFS to use the new iomap based multipage write path. This involves
> implementing the ->iomap_begin and ->iomap_end methods, and switching the
> buffered file write, page_mkwrite and xfs_iozero paths to the new iomap
> helpers.
> 
> With this change __xfs_get_blocks will never be used for buffered writes,
> and the code handling them can be removed.
> 
> Based on earlier code from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Kconfig     |   1 +
>  fs/xfs/xfs_aops.c  | 212 -----------------------------------------------------
>  fs/xfs/xfs_file.c  |  71 ++++++++----------
>  fs/xfs/xfs_iomap.c | 144 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.h |   5 +-
>  fs/xfs/xfs_iops.c  |   9 ++-
>  fs/xfs/xfs_trace.h |   3 +
>  7 files changed, 187 insertions(+), 258 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2f37194..73de1ec 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -967,3 +967,147 @@ xfs_bmbt_to_iomap(
...
> +static int
> +xfs_file_iomap_end_delalloc(
> +	struct xfs_inode	*ip,
> +	loff_t			offset,
> +	loff_t			length,
> +	ssize_t			written)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		start_fsb;
> +	xfs_fileoff_t		end_fsb;
> +	int			error = 0;
> +
> +	start_fsb = XFS_B_TO_FSB(mp, offset + written);
> +	end_fsb = XFS_B_TO_FSB(mp, offset + length - written);
> +

Just skimming over this series... but shouldn't this be offset + length?
Why walk back from the end of the allocated range?

Brian

> +	/*
> +	 * Trim back delalloc blocks if we didn't manage to write the whole
> +	 * range reserved.
> +	 *
> +	 * We don't need to care about racing delalloc as we hold i_mutex
> +	 * across the reserve/allocate/unreserve calls. If there are delalloc
> +	 * blocks in the range, they are ours.
> +	 */
> +	if (start_fsb < end_fsb) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
> +					       end_fsb - start_fsb);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_alert(mp, "%s: unable to clean up ino %lld",
> +				__func__, ip->i_ino);
> +			return error;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +xfs_file_iomap_end(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	loff_t			length,
> +	ssize_t			written,
> +	unsigned		flags,
> +	struct iomap		*iomap)
> +{
> +	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
> +		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
> +				length, written);
> +	return 0;
> +}
> +
> +struct iomap_ops xfs_iomap_ops = {
> +	.iomap_begin		= xfs_file_iomap_begin,
> +	.iomap_end		= xfs_file_iomap_end,
> +};
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 718f07c..e066d04 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -18,7 +18,8 @@
>  #ifndef __XFS_IOMAP_H__
>  #define __XFS_IOMAP_H__
>  
> -struct iomap;
> +#include <linux/iomap.h>
> +
>  struct xfs_inode;
>  struct xfs_bmbt_irec;
>  
> @@ -33,4 +34,6 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
>  void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *);
>  
> +extern struct iomap_ops xfs_iomap_ops;
> +
>  #endif /* __XFS_IOMAP_H__*/
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 1e2086d..6dfa10c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -38,6 +38,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_pnfs.h"
> +#include "xfs_iomap.h"
>  
>  #include <linux/capability.h>
>  #include <linux/xattr.h>
> @@ -822,8 +823,8 @@ xfs_setattr_size(
>  			error = dax_truncate_page(inode, newsize,
>  					xfs_get_blocks_direct);
>  		} else {
> -			error = block_truncate_page(inode->i_mapping, newsize,
> -					xfs_get_blocks);
> +			error = iomap_truncate_page(inode, newsize,
> +					&did_zeroing, &xfs_iomap_ops);
>  		}
>  	}
>  
> @@ -838,8 +839,8 @@ xfs_setattr_size(
>  	 * problem. Note that this includes any block zeroing we did above;
>  	 * otherwise those blocks may not be zeroed after a crash.
>  	 */
> -	if (newsize > ip->i_d.di_size &&
> -	    (oldsize != ip->i_d.di_size || did_zeroing)) {
> +	if (did_zeroing ||
> +	    (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
>  		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
>  						      ip->i_d.di_size, newsize);
>  		if (error)
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 840d52e..86fb345 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1296,6 +1296,9 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
>  DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
> +DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
> +DEFINE_IOMAP_EVENT(xfs_iomap_found);
> +DEFINE_IOMAP_EVENT(xfs_iomap_not_found);
>  
>  DECLARE_EVENT_CLASS(xfs_simple_io_class,
>  	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
