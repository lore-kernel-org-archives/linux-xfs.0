Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJ8ZKU5010270 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 02:35:20 -0600
Message-ID: <4EC76A2A.3060709@oracle.com>
Date: Sat, 19 Nov 2011 16:34:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: XFS SEEK_DATA/SEEK_HOLE support V1
References: <4E887D7F.2010306@oracle.com>	<20111114102444.GA27791@infradead.org>	<4EC10DE8.6030607@oracle.com>
	<20111114125044.GA9802@infradead.org> <4EC768F5.4050904@oracle.com>
In-Reply-To: <4EC768F5.4050904@oracle.com>
Reply-To: jeff.liu@oracle.com
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
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, aelder@sgi.com, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Sorry!! I forgot to write the subject beginning with "[PATCH]", will
re-sent it again.

Thanks,
-Jeff

On 11/19/2011 04:29 PM, Jeff Liu wrote:

> Hello,
> 
> Sorry for the delay! I have worked on another high priority task these days.
> 
> So the below patch is the first try to add SEEK_DATA/SEEK_HOLE to XFS, I have tested it through seek_test.c from Sunil, looks all works to me.
> http://oss.oracle.com/~smushran/seek_data/seek_test.c
> 
> Any feedback are welcome, thank you!
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/xfs/xfs_bmap.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap.h |    1 +
>  fs/xfs/xfs_file.c |   51 ++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_iops.c |   64 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iops.h |    3 ++
>  5 files changed, 199 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index c68baeb..04c3930 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -6133,3 +6133,84 @@ next_block:
>  
>  	return error;
>  }
> +
> +
> +int
> +xfs_seek_data_hole(
> +	struct xfs_inode	*ip,
> +	loff_t			*start,
> +	u32			type)
> +{
> +	xfs_mount_t		*mp = ip->i_mount;
> +	xfs_fileoff_t		seekoff = *start;
> +	xfs_fileoff_t		filelen;
> +	xfs_extnum_t		lastx;
> +	xfs_ifork_t		*ifp;
> +	struct xfs_bmbt_irec	got;
> +	struct xfs_bmbt_irec	prev;
> +	u64			extoff;
> +	u64			extlen;
> +	int			eof;
> +
> +	if (xfs_get_extsz_hint(ip) ||
> +	    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> +		filelen = XFS_MAXIOFFSET(mp);
> +	} else {
> +		filelen = ip->i_size;
> +	}
> +
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	xfs_bmap_search_extents(ip, XFS_BB_TO_FSBT(mp, BTOBB(*start)),
> +				XFS_DATA_FORK, &eof, &lastx, &got, &prev);
> +
> +	if (type == SEEK_DATA) {
> +		extoff = BBTOB(XFS_FSB_TO_BB(mp, got.br_startoff));
> +		extlen = BBTOB(XFS_FSB_TO_BB(mp, got.br_blockcount));
> +
> +		if (eof) {
> +			if (seekoff < extoff + extlen)
> +				*start = seekoff;
> +			else {
> +				/*
> +				 * There is no more data region past the
> +				 * supplied offset.
> +				 */
> +				return XFS_ERROR(ENXIO);
> +			}
> +		}
> +
> +		*start = seekoff < extoff ? extoff : seekoff;
> +	} else {
> +		for (;;) {
> +			extoff = BBTOB(XFS_FSB_TO_BB(mp, got.br_startoff));
> +			extlen = BBTOB(XFS_FSB_TO_BB(mp, got.br_blockcount));
> +			if (eof) {
> +				/*
> +				 * There might be a hole at the end of the
> +				 * file, adjust to the file size.
> +				 */
> +				if (seekoff >= extoff) {
> +					*start = min_t(xfs_fileoff_t, filelen,
> +							(extoff + extlen));
> +				}
> +				break;
> +			}
> +
> +			/* A hole found */
> +			if (seekoff < extoff) {
> +				*start = seekoff;
> +				break;
> +			}
> +
> +			/* Fetch the next extent */
> +			seekoff = extoff + extlen;
> +			if (++lastx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
> +				xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx),
> +						 &got);
> +			else
> +				eof = 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
> index 89ee672..964e29b 100644
> --- a/fs/xfs/xfs_bmap.h
> +++ b/fs/xfs/xfs_bmap.h
> @@ -196,6 +196,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
>  int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
>  		xfs_extnum_t num);
>  uint	xfs_default_attroffset(struct xfs_inode *ip);
> +int	xfs_seek_data_hole(struct xfs_inode *ip, loff_t *start, u32 type);
>  
>  #ifdef __KERNEL__
>  /* bmap to userspace formatter - copy to user & advance pointer */
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 753ed9b..bf5471b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1141,8 +1141,57 @@ xfs_vm_page_mkwrite(
>  	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  }
>  
> +STATIC loff_t
> +xfs_file_llseek(
> +	struct file *file,
> +	loff_t offset,
> +	int origin)
> +{
> +	struct inode *inode = file->f_mapping->host;
> +	int ret;
> +
> +	if (origin != SEEK_DATA && origin != SEEK_HOLE)
> +		return generic_file_llseek(file, offset, origin);
> +
> +	mutex_lock(&inode->i_mutex);
> +	switch (origin) {
> +	case SEEK_DATA:
> +	case SEEK_HOLE:
> +		if (offset >= i_size_read(inode)) {
> +			ret = -ENXIO;
> +			goto error;
> +		}
> +
> +		ret = xfs_find_desired_extent(inode, &offset, origin);
> +		if (ret)
> +			goto error;
> +	}
> +
> +	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	if (offset > inode->i_sb->s_maxbytes) {
> +		ret = -EINVAL;
> +		goto error;
> +	}
> +
> +	if (offset != file->f_pos) {
> +		file->f_pos = offset;
> +		file->f_version = 0;
> +	}
> +
> +	mutex_unlock(&inode->i_mutex);
> +	return offset;
> +
> +error:
> +	mutex_unlock(&inode->i_mutex);
> +	return ret;
> +}
> +
>  const struct file_operations xfs_file_operations = {
> -	.llseek		= generic_file_llseek,
> +	.llseek		= xfs_file_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
>  	.aio_read	= xfs_file_aio_read,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 23ce927..482c1ff 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1030,6 +1030,70 @@ xfs_vn_fiemap(
>  	return 0;
>  }
>  
> +int
> +xfs_find_desired_extent(
> +	struct inode		*inode,
> +	loff_t			*start,
> +	u32			type)
> +{
> +	xfs_inode_t		*ip = XFS_I(inode);
> +	xfs_mount_t		*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp;
> +	int			lock;
> +	int			error;
> +
> +	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> +		return XFS_ERROR(EINVAL);
> +
> +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +
> +	/*
> +	 * Flush the delay alloc blocks. Even after flushing the inode,
> +	 * there can still be delalloc blocks on the inode beyond EOF
> +	 * due to speculative preallocation. These are not removed until
> +	 * the release function is called or the inode is inactivated.
> +	 * Hence we cannot assert here that ip->i_delayed_blks == 0.
> +	 */
> +	if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
> +		error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
> +		if (error)
> +			goto out_unlock_iolock;
> +	}
> +
> +	lock = xfs_ilock_map_shared(ip);
> +
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		error = EIO;
> +		goto out_unlock_ilock;
> +	}
> +
> +	XFS_STATS_INC(xs_blk_mapr);
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +
> +	ASSERT(ifp->if_ext_max ==
> +	      XFS_IFORK_SIZE(ip, XFS_DATA_FORK) / (uint)sizeof(xfs_bmbt_rec_t));
> +
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error)
> +			goto out_unlock_ilock;
> +	}
> +
> +	error = xfs_seek_data_hole(ip, start, type);
> +
> +out_unlock_ilock:
> +	xfs_iunlock_map_shared(ip, lock);
> +out_unlock_iolock:
> +	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +
> +	if (error)
> +		return -error;
> +
> +	return 0;
> +}
> +
>  static const struct inode_operations xfs_inode_operations = {
>  	.get_acl		= xfs_get_acl,
>  	.getattr		= xfs_vn_getattr,
> diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
> index ef41c92..ea47abd 100644
> --- a/fs/xfs/xfs_iops.h
> +++ b/fs/xfs/xfs_iops.h
> @@ -27,4 +27,7 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
>  
>  extern void xfs_setup_inode(struct xfs_inode *);
>  
> +extern int xfs_find_desired_extent(struct inode *inode, loff_t *start,
> +				   u32 type);
> +
>  #endif /* __XFS_IOPS_H__ */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
