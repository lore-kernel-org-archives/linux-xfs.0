Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 832A87F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 18:24:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72B6A304039
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 16:24:46 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XkzvBqTbeIg4bGBq for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 16:24:43 -0800 (PST)
Date: Wed, 7 Jan 2015 11:24:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/18] xfs: implement pnfs export operations
Message-ID: <20150107002434.GG31508@dastard>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-18-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-18-git-send-email-hch@lst.de>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:40PM +0100, Christoph Hellwig wrote:
> Add operations to export pNFS block layouts from an XFS filesystem.  See
> the previous commit adding the operations for an explanation of them.
.....
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index fdc6422..2b86be8 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -601,6 +601,8 @@ xfs_growfs_data(
>  	if (!mutex_trylock(&mp->m_growlock))
>  		return -EWOULDBLOCK;
>  	error = xfs_growfs_data_private(mp, in);
> +	if (!error)
> +		mp->m_generation++;
>  	mutex_unlock(&mp->m_growlock);
>  	return error;
>  }

I couldn't find an explanation of what this generation number is
for. What are it's semantics w.r.t. server crashes?

> +xfs_fs_get_uuid(
> +	struct super_block	*sb,
> +	u8			*buf,
> +	u32			*len,
> +	u64			*offset)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (*len < sizeof(uuid_t))
> +		return -EINVAL;
> +
> +	memcpy(buf, &mp->m_sb.sb_uuid, sizeof(uuid_t));

uuid_copy()?

> +	*len = sizeof(uuid_t);
> +	*offset = offsetof(struct xfs_dsb, sb_uuid);
> +	return 0;
> +}
> +
> +static void
> +xfs_map_iomap(
> +	struct xfs_inode	*ip,
> +	struct iomap		*iomap,
> +	struct xfs_bmbt_irec	*imap,
> +	xfs_off_t	offset)

xfs_bmbt_to_iomap()?

> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	iomap->blkno = -1;
> +	if (imap->br_startblock == HOLESTARTBLOCK)
> +		iomap->type = IOMAP_HOLE;
> +	else if (imap->br_startblock == DELAYSTARTBLOCK)
> +		iomap->type = IOMAP_DELALLOC;
> +	else {
> +		/*
> +		 * the block number in the iomap must match the start offset we
> +		 * place in the iomap.
> +		 */
> +		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
> +		ASSERT(iomap->blkno || XFS_IS_REALTIME_INODE(ip));
> +		if (imap->br_state == XFS_EXT_UNWRITTEN)
> +			iomap->type = IOMAP_UNWRITTEN;
> +		else
> +			iomap->type = IOMAP_MAPPED;
> +	}
> +	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
> +	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> +}

Why does this function get passed an offset it is not actually used?

> +static int
> +xfs_fs_update_flags(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	/*
> +	 * Update the mode, and prealloc flag bits.
> +	 */
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_WRITEID);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_writeid, 0, 0);
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +	ip->i_d.di_mode &= ~S_ISUID;
> +	if (ip->i_d.di_mode & S_IXGRP)
> +		ip->i_d.di_mode &= ~S_ISGID;
> +
> +	ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
> +
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	return xfs_trans_commit(tp, 0);
> +}

That needs timestamp changes as well. i.e.:

	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);

and at that point, it's basically the same code as in
xfs_file_fallocate() and xfs_ioc_space(), so should probably be
factored into a common operation.

> +
> +/*
> + * Get a layout for the pNFS client.
> + *
> + * Note that in the allocation case we do force out the transaction here.
> + * There is no metadata update that is required to be stable for NFS
> + * semantics, and layouts are not valid over a server crash.  Instead
> + * we'll have to be careful in the commit routine as it might pass us
> + * blocks for an allocation that never made it to disk in the recovery
> + * case.

I think you are saying that because block allocation is an async
transaction, then we have to deal with the possibility that we crash
before the transaction hits the disk.

How often do we have to allocate
new blocks like this? Do we need to use async transactions for this
case, or should we simply do the brute force thing (by making the
allocation transaction synchronous) initially and then, if
performance problems arise, optimise from there?

> + */
> +int
> +xfs_fs_map_blocks(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	u64			length,
> +	struct iomap		*iomap,
> +	bool			write,
> +	u32			*device_generation)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_bmbt_irec	imap;
> +	xfs_fileoff_t		offset_fsb, end_fsb;
> +	loff_t			limit;
> +	int			bmapi_flags = XFS_BMAPI_ENTIRE;
> +	int			nimaps = 1;
> +	uint			lock_flags;
> +	int			error = 0;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return -ENXIO;
> +
> +	xfs_ilock(ip, XFS_IOLOCK_EXCL);

Why are we locking out IO just to read the block map (needs a
comment)?

> +	if (!write) {
> +		limit = max(round_up(i_size_read(inode),
> +				     inode->i_sb->s_blocksize),
> +			    mp->m_super->s_maxbytes);
> +	} else {
> +		limit = mp->m_super->s_maxbytes;
> +	}

	limit = mp->m_super->s_maxbytes;
	if (!write)
		limit = max(limit, round_up(i_size_read(inode),
					    inode->i_sb->s_blocksize));
> +
> +	error = -EINVAL;
> +	if (offset > limit)
> +		goto out_unlock;
> +	if (offset + length > mp->m_super->s_maxbytes)
> +		length = limit - offset;

Need to catch a wrap through zero...

> +	/*
> +	 * Flush data and truncate the pagecache.  pNFS block clients just
> +	 * like direct I/O access the disk directly.
> +	 */
> +	error = filemap_write_and_wait(inode->i_mapping);
> +	if (error)
> +		goto out_unlock;
> +	invalidate_inode_pages2(inode->i_mapping);

invalidate_inode_pages2() can fail with EBUSY....

> +
> +	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
> +	offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +
> +	lock_flags = xfs_ilock_data_map_shared(ip);
> +	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
> +				&imap, &nimaps, bmapi_flags);
> +	xfs_iunlock(ip, lock_flags);
> +
> +	if (error)
> +		goto out_unlock;
> +
> +	if (write) {

ASSERT(imap.br_startblock != DELAYSTARTBLOCK);

> +		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
> +			error = xfs_iomap_write_direct(ip, offset, length,
> +						       &imap, nimaps);
> +			if (error)
> +				goto out_unlock;
> +		}
> +
> +		error = xfs_fs_update_flags(ip);
> +		if (error)
> +			goto out_unlock;
> +	}
> +	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +
> +	xfs_map_iomap(ip, iomap, &imap, offset);
> +	*device_generation = mp->m_generation;

So whenever the server first starts up the generation number in a
map is going to be zero - what purpose does this actually serve?

> +	return error;
> +out_unlock:
> +	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +	return error;
> +}
> +
> +/*
> + * Make sure the blocks described by maps are stable on disk.  This includes
> + * converting any unwritten extents, flushing the disk cache and updating the
> + * time stamps.
> + *
> + * Note that we rely on the caller to always send us a timestamp update so that
> + * we always commit a transaction here.  If that stops being true we will have
> + * to manually flush the cache here similar to what the fsync code path does
> + * for datasyncs on files that have no dirty metadata.

Needs an assert.

> + *
> + * In the reclaim case we might get called for blocks that were only allocated
> + * in memory and not on disk.  We rely on the fact that unwritten extent
> + * conversions handle this properly.
> + */

Making allocation transactions synchronous as well will make this
wart go away.

> +int
> +xfs_fs_commit_blocks(
> +	struct inode		*inode,
> +	struct iomap		*maps,
> +	int			nr_maps,
> +	struct iattr		*iattr)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error, i;
> +	loff_t			size;
> +
> +	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> +
> +	size = i_size_read(inode);
> +	if ((iattr->ia_valid & ATTR_SIZE) && iattr->ia_size > size)
> +		size = iattr->ia_size;
> +
> +	for (i = 0; i < nr_maps; i++) {
> +		u64 start, length, end;
> +
> +		start = maps[i].offset;
> +		if (start > size)
> +			continue;
> +
> +		end = start + maps[i].length;
> +		if (end > size)
> +			end = size;
> +
> +		length = end - start;
> +		if (!length)
> +			continue;
> +
> +		error = xfs_iomap_write_unwritten(ip, start, length);
> +		if (error)
> +			goto out_drop_iolock;
> +	}
> +
> +	/*
> +	 * Make sure reads through the pagecache see the new data.
> +	 */
> +	invalidate_inode_pages2(inode->i_mapping);

Probably should do that first. Also, what happens if there is local
dirty data on the file at this point? Doesn't this just toss them
away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
