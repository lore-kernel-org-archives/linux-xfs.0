Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49362 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752339AbdBNGpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 01:45:43 -0500
Date: Mon, 13 Feb 2017 22:44:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/7] nonblocking aio: xfs
Message-ID: <20170214064448.GA6808@birch.djwong.org>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214024603.9563-7-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org

On Mon, Feb 13, 2017 at 08:46:02PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Send the whole patchset to linux-xfs, please.

> If IOCB_NONBLOCKING is set:
> 	+ Check if writing beyond end of file, if yes return EAGAIN
> 	- check if writing to a hole which does not have allocated
> 	  file blocks.
> 	- Check if i_rwsem is immediately lockable in xfs_rw_ilock()
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/xfs/xfs_file.c  | 36 ++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_inode.h |  2 ++
>  2 files changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 9a5d64b..42f055f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -51,14 +51,20 @@ static const struct vm_operations_struct xfs_file_vm_ops;
>   * Locking primitives for read and write IO paths to ensure we consistently use
>   * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
>   */
> -static inline void
> +static inline int
>  xfs_rw_ilock(
>  	struct xfs_inode	*ip,
>  	int			type)
>  {
> -	if (type & XFS_IOLOCK_EXCL)
> -		inode_lock(VFS_I(ip));
> +	if (type & XFS_IOLOCK_EXCL) {
> +		if ((type & XFS_IOLOCK_NONBLOCKING) &&
> +				!inode_trylock(VFS_I(ip)))
> +			return -EAGAIN;
> +		else
> +			inode_lock(VFS_I(ip));
> +	}
>  	xfs_ilock(ip, type);
> +	return 0;

This function went away in 4.10-rc1.

>  }
>  
>  static inline void
> @@ -418,6 +424,24 @@ xfs_file_aio_write_checks(
>  	if (error <= 0)
>  		return error;
>  
> +	if (iocb->ki_flags & IOCB_NONBLOCKING) {
> +		struct xfs_bmbt_irec	imap;
> +		xfs_fileoff_t           offset_fsb, end_fsb;
> +		int			nimaps = 1, ret = 0;
> +		end_fsb = XFS_B_TO_FSB(ip->i_mount, iocb->ki_pos + count);
> +		if (XFS_B_TO_FSB(ip->i_mount, i_size_read(inode)) < end_fsb)
> +			return -EAGAIN;
> +		/* Check if it is an unallocated hole */
> +		offset_fsb = XFS_B_TO_FSBT(ip->i_mount, iocb->ki_pos);
> +
> +		ret = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
> +				&nimaps, 0);

You need to hold the ilock to call _bmapi_read, and I don't think
it's held here.  Did you CONFIG_XFS_DEBUG=y?

> +		if (ret)
> +			return ret;
> +		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK)
> +			return -EAGAIN;
> +	}
> +
>  	error = xfs_break_layouts(inode, iolock, true);
>  	if (error)
>  		return error;
> @@ -555,11 +579,15 @@ xfs_file_dio_aio_write(
>  	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
>  		unaligned_io = 1;
>  		iolock = XFS_IOLOCK_EXCL;
> +		if (iocb->ki_flags & IOCB_NONBLOCKING)
> +			iolock |= XFS_IOLOCK_NONBLOCKING;
>  	} else {
>  		iolock = XFS_IOLOCK_SHARED;
>  	}
>  
> -	xfs_rw_ilock(ip, iolock);
> +	ret = xfs_rw_ilock(ip, iolock);
> +	if (ret)
> +		return ret;
>  
>  	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
>  	if (ret)
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 71e8a81..1a2d5eb 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -283,6 +283,7 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>  #define	XFS_ILOCK_SHARED	(1<<3)
>  #define	XFS_MMAPLOCK_EXCL	(1<<4)
>  #define	XFS_MMAPLOCK_SHARED	(1<<5)
> +#define	XFS_IOLOCK_NONBLOCKING	(1<<6)

What is the expected behavior if this is passed directly to xfs_ilock?

--D

>  
>  #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
>  				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
> @@ -291,6 +292,7 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
>  #define XFS_LOCK_FLAGS \
>  	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
>  	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
> +	{ XFS_IOLOCK_NONBLOCKING,	"IOLOCK_NONBLOCKING" }, \
>  	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
>  	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
>  	{ XFS_MMAPLOCK_EXCL,	"MMAPLOCK_EXCL" }, \
> -- 
> 2.10.2
> 
