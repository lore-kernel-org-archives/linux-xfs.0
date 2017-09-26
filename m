Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965319AbdIZPAa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2017 11:00:30 -0400
Date: Tue, 26 Sep 2017 08:00:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: update i_size after unwritten conversion in dio
 completion
Message-ID: <20170926150029.GC9530@infradead.org>
References: <20170921155246.4352-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921155246.4352-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 11:52:46PM +0800, Eryu Guan wrote:
> Since commit d531d91d6990 ("xfs: always use unwritten extents for
> direct I/O writes"), we start allocating unwritten extents for all
> direct writes to allow appending aio in XFS.
> 
> But for dio writes that could extend file size we update the in-core
> inode size first, then convert the unwritten extents to real
> allocations at dio completion time in xfs_dio_write_end_io(). Thus a
> racing direct read could see the new i_size and find the unwritten
> extents first and read zeros instead of actual data, if the direct
> writer also takes a shared iolock.
> 
> Fix it by updating the in-core inode size after the unwritten extent
> conversion. To do this, introduce a new boolean argument to
> xfs_iomap_write_unwritten() to tell if we want to update in-core
> i_size or not.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2:
> - fix comments by copying Brian's words :)
> - fix code style, remove unnecessary blank lines and braces
> 
> v1: https://marc.info/?l=linux-xfs&m=150599032124565&w=2
> 
>  fs/xfs/xfs_aops.c  |  3 ++-
>  fs/xfs/xfs_file.c  | 33 +++++++++++++++++++--------------
>  fs/xfs/xfs_iomap.c |  7 +++++--
>  fs/xfs/xfs_iomap.h |  2 +-
>  fs/xfs/xfs_pnfs.c  |  2 +-
>  5 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 29172609f2a3..f18e5932aec4 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -343,7 +343,8 @@ xfs_end_io(
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  		break;
>  	case XFS_IO_UNWRITTEN:
> -		error = xfs_iomap_write_unwritten(ip, offset, size);
> +		/* writeback should never update isize */
> +		error = xfs_iomap_write_unwritten(ip, offset, size, false);

Can we expand this to

	/* writeback should never update the in-core inode size */

> @@ -459,20 +473,11 @@ xfs_dio_write_end_io(
>  	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode)) {
>  		i_size_write(inode, offset + size);
> +		spin_unlock(&ip->i_flags_lock);
>  		error = xfs_setfilesize(ip, offset, size);
> +	} else {
> +		spin_unlock(&ip->i_flags_lock);
> +	}

I find the old update_isize scheme a little easier to read, but it
shouldn't matter in the end:

  	spin_lock(&ip->i_flags_lock);
  	if (offset + size > i_size_read(inode)) {
  		i_size_write(inode, offset + size);
		update_isize = true;
	}
	spin_unlock(&ip->i_flags_lock);

	if (!update_isize)
		return 0;
	return xfs_setfilesize(ip, offset, size);

>  	xfs_bmbt_irec_t imap;
>  	struct xfs_defer_ops dfops;
> +	struct inode	*inode = VFS_I(ip);
>  	xfs_fsize_t	i_size;
>  	uint		resblks;
>  	int		error;
> @@ -899,7 +901,8 @@ xfs_iomap_write_unwritten(
>  		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
>  		if (i_size > offset + count)
>  			i_size = offset + count;
> -
> +		if (update_isize && i_size > i_size_read(inode))
> +			i_size_write(inode, i_size);
>  		i_size = xfs_new_eof(ip, i_size);
>  		if (i_size) {
>  			ip->i_d.di_size = i_size;

I wonder if this might be cleaner if we expand xfs_new_eof for
the update_isize case.  Something like the untested helper below:

static bool
xfs_alloc_update_isize(
	struct xfs_inode	*ip,
	xfs_fileoff_t		offset_fsb,
	xfs_filblks_t		count_fsb,
	bool			update_incore_isize)
{
	xfs_fsize_t		i_size;

	i_size = XFS_FSB_TO_B(ip->i_mount, offset_fsb + count_fsb);
	if (i_size > offset + count)
		i_size = offset + count;

	if (update_isize) {
		if (i_size <= i_size_read(inode))
			return;
		i_size_write(inode, i_size);
	} else {
		i_size = xfs_new_eof(ip, i_size);
		if (!i_size)
			return;
	}

	ip->i_d.di_size = i_size;
	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
}
