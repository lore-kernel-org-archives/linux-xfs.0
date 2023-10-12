Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23AECDB483
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 06:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbjJLG05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 02:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbjJLG0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 02:26:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1795F0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 23:26:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFB2C433C8;
        Thu, 12 Oct 2023 06:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697092013;
        bh=qiYWl2NGAWtNwiWW5N4RKhFwN8T9gJDchbiqHnpmfj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDB1UlLQ7f2ALdU+15uAuNM7mRP0CezLDtDIyz5Y1YaGiAMFBCfATkH3AMx6+xok8
         Lru3u4EKmkn7ZtO53ILxV53nMDlNVh8ZsFPSqJbFkgzaOqJfKiHx6FM3bZXeCfTGOG
         EgyXjIUnzYiPfapiEpHlUeJBr1RYoXTuuqQJiyvupPoVBe3xxiSwghJqxOIbT6k10+
         SBSIQDKTtWuNVsjx2v+8jOtLjs0zBSwoqxSAYhfbMoMRmpRJ31XudtG+z943PiqLJn
         vZwUEUJtIEzleuS7IuKKNZFfcQ2USnyJF/NfT1WnVMu4LOuP/Bmstq2Qb32Ow/+IH1
         SOzQyNzNdjCDQ==
Date:   Wed, 11 Oct 2023 23:26:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231012062652.GD21298@frogsfrogsfrogs>
References: <20231012010845.64286-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012010845.64286-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 06:08:45PM -0700, Catherine Hoang wrote:
> Clone operations and read IO do not change any data in the source file, so they
> should be able to run concurrently. Demote the exclusive locks taken by FICLONE
> to shared locks to allow reads while cloning. While a clone is in progress,
> writes will take the IOLOCK_EXCL, so they block until the clone completes.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_file.c    | 68 +++++++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_inode.c   | 17 +++++++++++
>  fs/xfs/xfs_inode.h   |  9 ++++++
>  fs/xfs/xfs_reflink.c |  4 +++
>  4 files changed, 85 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 203700278ddb..425507b0d1cb 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -214,6 +214,48 @@ xfs_ilock_iocb(
>  	return 0;
>  }
>  
> +static int
> +xfs_ilock_iocb_for_write(
> +	struct kiocb		*iocb,
> +	unsigned int		*lock_mode)
> +{
> +	ssize_t			ret;
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +
> +	do {
> +		ret = xfs_ilock_iocb(iocb, *lock_mode);
> +		if (ret)
> +			return ret;
> +		if (*lock_mode == XFS_IOLOCK_EXCL)
> +			return 0;
> +		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
> +			return 0;
> +		xfs_iunlock(ip, *lock_mode);
> +		*lock_mode = XFS_IOLOCK_EXCL;
> +	} while (1);
> +	/* notreached */

Might want to change that to an ASSERT(0) so we'll notice if this ever
breaks.

> +	return -EAGAIN;
> +}
> +
> +static int

"unsigned int", please be consistent with the other inode lock flag
usage around the codebase.

> +xfs_ilock_for_write_fault(
> +	struct xfs_inode	*ip)
> +{
> +	int			lock_mode = XFS_MMAPLOCK_SHARED;
> +
> +	do {
> +		xfs_ilock(ip, lock_mode);
> +		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
> +			return lock_mode;
> +		if (lock_mode == XFS_MMAPLOCK_EXCL)
> +			return lock_mode;
> +		xfs_iunlock(ip, lock_mode);
> +		lock_mode = XFS_MMAPLOCK_EXCL;
> +	} while (1);
> +	/* notreached */
> +	return 0;

I wonder if this would be easier to understand with the loop unrolled?

	/* get a shared lock if no remapping in progress */
	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
		return XFS_MMAPLOCK_SHARED;

	/* wait for remapping to complete */
	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
	return XFS_MMAPLOCK_EXCL;

It eliminates the awkward /* notreached */ construction.

Thoughts?

> +}
> +
>  STATIC ssize_t
>  xfs_file_dio_read(
>  	struct kiocb		*iocb,
> @@ -551,7 +593,7 @@ xfs_file_dio_write_aligned(
>  	unsigned int		iolock = XFS_IOLOCK_SHARED;
>  	ssize_t			ret;
>  
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>  	if (ret)
>  		return ret;
>  	ret = xfs_file_write_checks(iocb, from, &iolock);
> @@ -618,7 +660,7 @@ xfs_file_dio_write_unaligned(
>  		flags = IOMAP_DIO_FORCE_WAIT;
>  	}
>  
> -	ret = xfs_ilock_iocb(iocb, iolock);
> +	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
>  	if (ret)
>  		return ret;
>  
> @@ -1180,7 +1222,7 @@ xfs_file_remap_range(
>  	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
>  		xfs_log_force_inode(dest);
>  out_unlock:
> -	xfs_iunlock2_io_mmap(src, dest);
> +	xfs_iunlock2_remapping(src, dest);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return remapped > 0 ? remapped : ret;
> @@ -1328,6 +1370,7 @@ __xfs_filemap_fault(
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	vm_fault_t		ret;
> +	int			lock_mode = 0;

unsigned int

--D

>  
>  	trace_xfs_filemap_fault(ip, order, write_fault);
>  
> @@ -1336,25 +1379,24 @@ __xfs_filemap_fault(
>  		file_update_time(vmf->vma->vm_file);
>  	}
>  
> +	if (IS_DAX(inode) || write_fault)
> +		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
> +
>  	if (IS_DAX(inode)) {
>  		pfn_t pfn;
>  
> -		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
>  		if (ret & VM_FAULT_NEEDDSYNC)
>  			ret = dax_finish_sync_fault(vmf, order, pfn);
> -		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	} else if (write_fault) {
> +		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
>  	} else {
> -		if (write_fault) {
> -			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -			ret = iomap_page_mkwrite(vmf,
> -					&xfs_page_mkwrite_iomap_ops);
> -			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -		} else {
> -			ret = filemap_fault(vmf);
> -		}
> +		ret = filemap_fault(vmf);
>  	}
>  
> +	if (lock_mode)
> +		xfs_iunlock(XFS_I(inode), lock_mode);
> +
>  	if (write_fault)
>  		sb_end_pagefault(inode->i_sb);
>  	return ret;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4d55f58d99b7..97b0078249fd 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3621,6 +3621,23 @@ xfs_iunlock2_io_mmap(
>  		inode_unlock(VFS_I(ip1));
>  }
>  
> +/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */
> +void
> +xfs_iunlock2_remapping(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	xfs_iflags_clear(ip1, XFS_IREMAPPING);
> +
> +	if (ip1 != ip2)
> +		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
> +	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
> +
> +	if (ip1 != ip2)
> +		inode_unlock_shared(VFS_I(ip1));
> +	inode_unlock(VFS_I(ip2));
> +}
> +
>  /*
>   * Reload the incore inode list for this inode.  Caller should ensure that
>   * the link count cannot change, either by taking ILOCK_SHARED or otherwise
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 0c5bdb91152e..3dc47937da5d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>  /* Quotacheck is running but inode has not been added to quota counts. */
>  #define XFS_IQUOTAUNCHECKED	(1 << 14)
>  
> +/*
> + * Remap in progress. Callers that wish to update file data while
> + * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
> + * the lock in exclusive mode. Relocking the file will block until
> + * IREMAPPING is cleared.
> + */
> +#define XFS_IREMAPPING		(1U << 15)
> +
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
>  				 XFS_IRECLAIM | \
> @@ -595,6 +603,7 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  
>  static inline bool
>  xfs_inode_unlinked_incomplete(
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index eb9102453aff..658edee8381d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
>  	if (ret)
>  		goto out_unlock;
>  
> +	xfs_iflags_set(src, XFS_IREMAPPING);
> +	if (inode_in != inode_out)
> +		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
> +
>  	return 0;
>  out_unlock:
>  	xfs_iunlock2_io_mmap(src, dest);
> -- 
> 2.34.1
> 
