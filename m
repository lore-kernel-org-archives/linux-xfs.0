Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755263AbcJGSFJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 14:05:09 -0400
Date: Fri, 7 Oct 2016 14:05:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 46/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20161007180506.GF58659@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Sep 29, 2016 at 08:10:39PM -0700, Darrick J. Wong wrote:
> Unshare all shared extents if the user calls fallocate with the new
> unshare mode flag set, so that we can guarantee that a subsequent
> write will not ENOSPC.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> [hch: pass inode instead of file to xfs_reflink_dirty_range,
>       use iomap infrastructure for copy up]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c    |   10 ++
>  fs/xfs/xfs_reflink.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.h |    2 
>  3 files changed, 247 insertions(+), 2 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 77ac810..065e836 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1472,3 +1472,240 @@ xfs_reflink_remap_range(
>  		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
>  	return error;
>  }
...
> +/* Iterate the extents; if there are no reflinked blocks, clear the flag. */
> +STATIC int
> +xfs_reflink_try_clear_inode_flag(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		old_isize)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	xfs_fileoff_t		fbno;
> +	xfs_filblks_t		end;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	xfs_extlen_t		aglen;
> +	xfs_agblock_t		rbno;
> +	xfs_extlen_t		rlen;
> +	struct xfs_bmbt_irec	map[2];
> +	int			nmaps;
> +	int			error = 0;
> +
> +	/* Start a rolling transaction to remove the mappings */
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	if (old_isize != i_size_read(VFS_I(ip)))
> +		goto cancel;
> +	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK))
> +		goto cancel;
> +

The code that has been merged is now different from this code :/, but
just a heads up that the code in the tree looks like it has another one
of those potentially blind transaction commit sequences between
xfs_reflink_try_clear_inode_flag() and xfs_reflink_clear_inode_flag().

It doesn't appear to be a problem in how it is actually used in this
patch, but for reference, I think it's better practice for lower level
functions like xfs_reflink_clear_inode_flag() to assert that the flag is
set and make it the responsibility of the caller to check for it and do
the right thing. Just my .02 though.

> +	fbno = 0;
> +	end = XFS_B_TO_FSB(mp, old_isize);
> +	while (end - fbno > 0) {
> +		nmaps = 1;
> +		/*
> +		 * Look for extents in the file.  Skip holes, delalloc, or
> +		 * unwritten extents; they can't be reflinked.
> +		 */
> +		error = xfs_bmapi_read(ip, fbno, end - fbno, map, &nmaps, 0);
> +		if (error)
> +			goto cancel;
> +		if (nmaps == 0)
> +			break;
> +		if (map[0].br_startblock == HOLESTARTBLOCK ||
> +		    map[0].br_startblock == DELAYSTARTBLOCK ||
> +		    ISUNWRITTEN(&map[0]))
> +			goto next;
> +
> +		map[1] = map[0];
> +		while (map[1].br_blockcount) {
> +			agno = XFS_FSB_TO_AGNO(mp, map[1].br_startblock);
> +			agbno = XFS_FSB_TO_AGBNO(mp, map[1].br_startblock);
> +			aglen = map[1].br_blockcount;
> +
> +			error = xfs_reflink_find_shared(mp, agno, agbno, aglen,
> +					&rbno, &rlen, false);
> +			if (error)
> +				goto cancel;
> +			/* Is there still a shared block here? */
> +			if (rlen > 0) {
> +				error = 0;
> +				goto cancel;
> +			}
> +
> +			map[1].br_blockcount -= aglen;
> +			map[1].br_startoff += aglen;
> +			map[1].br_startblock += aglen;

This is basically doing:

	map[1] = map[0];
	while (map[1].br_blockcount) {
		aglen = map[1].br_blockcount;
		...
		map[1].br_blockcount -= aglen;
	}

So the loop appears to be completely superfluous.

> +		}
> +
> +next:
> +		fbno = map[0].br_startoff + map[0].br_blockcount;
> +	}
> +
> +	/*
> +	 * We didn't find any shared blocks so turn off the reflink flag.
> +	 * First, get rid of any leftover CoW mappings.
> +	 */
> +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, 0, NULLFILEOFF);
> +	if (error)
> +		goto cancel;
> +
> +	/* Clear the inode flag. */
> +	trace_xfs_reflink_unset_inode_flag(ip);
> +	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +	xfs_trans_ijoin(tp, ip, 0);
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto out;
> +
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return 0;
> +cancel:
> +	xfs_trans_cancel(tp);
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	return error;
> +}
> +
> +/*
> + * Pre-COW all shared blocks within a given byte range of a file and turn off
> + * the reflink flag if we unshare all of the file's blocks.
> + */
> +int
> +xfs_reflink_unshare(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		len)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		fbno;
> +	xfs_filblks_t		end;
> +	xfs_off_t		old_isize, isize;
> +	int			error;
> +
> +	if (!xfs_is_reflink_inode(ip))
> +		return 0;
> +
> +	trace_xfs_reflink_unshare(ip, offset, len);
> +
> +	inode_dio_wait(VFS_I(ip));
> +
> +	/* Try to CoW the selected ranges */
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	fbno = XFS_B_TO_FSB(mp, offset);

XFS_B_TO_FSBT() ?

> +	old_isize = isize = i_size_read(VFS_I(ip));
> +	end = XFS_B_TO_FSB(mp, offset + len);
> +	error = xfs_reflink_dirty_extents(ip, fbno, end, isize);
> +	if (error)
> +		goto out_unlock;
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +	/* Wait for the IO to finish */
> +	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
> +	if (error)
> +		goto out;
> +
> +	/* Turn off the reflink flag if we unshared the whole file */
> +	if (offset == 0 && len == isize) {

Isn't this valid if len is larger than isize (similar check in
xfs_reflink_try_clear_inode_flag() might defeat this as well)?

FWIW, this has a similar issue as the earlier truncate code in that we
might just unshare the shared regions and thus retain the flag.

Brian

> +		error = xfs_reflink_try_clear_inode_flag(ip, old_isize);
> +		if (error)
> +			goto out;
> +	}
> +
> +	return 0;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
> +	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index df82b20..ad4fc61 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -48,5 +48,7 @@ extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
>  extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
>  		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
>  		unsigned int flags);
> +extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
> +		xfs_off_t len);
>  
>  #endif /* __XFS_REFLINK_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
