Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28K4R30060592 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 14:04:27 -0600
Date: Thu, 8 Mar 2012 14:04:34 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 8/8] xfs: add back fdatasync support
Message-ID: <20120308200434.GW7762@sgi.com>
References: <20120221003824.415885674@bombadil.infradead.org>
	<20120221003907.518904261@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120221003907.518904261@bombadil.infradead.org>
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

On Mon, Feb 20, 2012 at 07:38:32PM -0500, Christoph Hellwig wrote:
> Add an in-memory only flag to say we logged timestamps only, and use it to
> check if fdatasync can optimize away the log force.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok.  I was a little concerned that xfs_inode_item_format doesn't
know what an XFS_ILOG_TIMESTAMP is, until it dawned that we always log
the inode core.

Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> ---
>  fs/xfs/xfs_file.c       |    7 +++++--
>  fs/xfs/xfs_inode_item.c |    3 ++-
>  fs/xfs/xfs_inode_item.h |   12 +++++++++++-
>  fs/xfs/xfs_super.c      |    2 +-
>  4 files changed, 19 insertions(+), 5 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_inode_item.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode_item.c	2012-02-20 12:08:44.379988903 -0800
> +++ xfs/fs/xfs/xfs_inode_item.c	2012-02-20 12:10:27.239988625 -0800
> @@ -439,7 +439,8 @@ out:
>  	 * games in recovery easier, which isn't a big deal as just about any
>  	 * transaction would dirty it anyway.
>  	 */
> -	iip->ili_format.ilf_fields = XFS_ILOG_CORE | iip->ili_fields;
> +	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
> +		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
>  	iip->ili_format.ilf_size = nvecs;
>  }
>  
> Index: xfs/fs/xfs/xfs_inode_item.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode_item.h	2012-02-20 12:08:44.383322236 -0800
> +++ xfs/fs/xfs/xfs_inode_item.h	2012-02-20 12:10:27.239988625 -0800
> @@ -86,6 +86,16 @@ typedef struct xfs_inode_log_format_64 {
>  #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
>  #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
>  
> +
> +/*
> + * The timestamps in the core are dirty, but not nessecarily anything
> + * else.
> + *
> + * This is an incore only value store in ilf_fields & co, which must
> + * never make it to disk, unlike the other fields above.
> + */
> +#define XFS_ILOG_TIMESTAMP	0x4000
> +
>  #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
>  				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
>  				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
> @@ -101,7 +111,7 @@ typedef struct xfs_inode_log_format_64 {
>  				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
>  				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
>  				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
> -				 XFS_ILOG_ABROOT)
> +				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
>  
>  static inline int xfs_ilog_fbroot(int w)
>  {
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2012-02-20 12:08:35.513322261 -0800
> +++ xfs/fs/xfs/xfs_file.c	2012-02-20 12:11:40.246655094 -0800
> @@ -197,8 +197,11 @@ xfs_file_fsync(
>  	 * to flush the log up to the latest LSN that touched the inode.
>  	 */
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> +	if (xfs_ipincount(ip)) {
> +		if (!datasync ||
> +		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
> +			lsn = ip->i_itemp->ili_last_lsn;
> +	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  
>  	if (lsn)
> Index: xfs/fs/xfs/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_super.c	2012-02-20 12:08:35.526655594 -0800
> +++ xfs/fs/xfs/xfs_super.c	2012-02-20 12:10:27.239988625 -0800
> @@ -907,7 +907,7 @@ xfs_fs_dirty_inode(
>  	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
>  
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
>  	error = xfs_trans_commit(tp, 0);
>  	if (error)
>  		goto trouble;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
