Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B542E936EC
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 00:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbjJEAEO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Oct 2023 20:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241171AbjJEAEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2023 20:04:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE9DD7
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 17:04:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BE8C433C8;
        Thu,  5 Oct 2023 00:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696464247;
        bh=BdPUZUPFTA/fxDkygCb6o+aSS/hsgtJngO+Na+gV/8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Whag/uuSBitRmGZ3vMDKnOo2+RLlNPEIVcK3zAYyL7NWw4aHPlRvPi4+dohieKNPt
         QThfoJxaqf0kXQtVN1VdJw+kyJfE65GjkQYDGDfnNlDKwsf/hgJ0wRezFtSxBNLxtV
         FMTNQF863K6MhTXKe2PaNey2G/1hWqxL5M4/qsJSbb5f0wH0YnCbX21TDm9CSUNR0P
         Nex53w/r/R+mF7H81rsOi65CA+rmpEB8p5exelzzV7Af1EHsihDAtIHxdqpw0wsC9W
         SbYm5uu30Ov1uYKhR5MAbc4yZoqPaiqTyD7tWfLLeV6fau/aVjzBP/Y4gvXdSrrYGW
         UL5RT7CCRAuqg==
Date:   Wed, 4 Oct 2023 17:04:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231005000406.GM21298@frogsfrogsfrogs>
References: <20231004205807.85450-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004205807.85450-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 01:58:07PM -0700, Catherine Hoang wrote:
> Clone operations and read IO do not change any data in the source file, so they
> should be able to run concurrently. Demote the exclusive locks taken by FICLONE
> to shared locks to allow reads while cloning. While a clone is in progress,
> writes will take the IOLOCK_EXCL, so they block until the clone completes.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_file.c    | 41 +++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_inode.h   |  3 +++
>  fs/xfs/xfs_reflink.c | 31 +++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.h |  2 ++
>  4 files changed, 71 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 203700278ddb..1ec987fcabb9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -554,6 +554,15 @@ xfs_file_dio_write_aligned(
>  	ret = xfs_ilock_iocb(iocb, iolock);
>  	if (ret)
>  		return ret;
> +
> +	if (xfs_iflags_test(ip, XFS_ICLONING)) {
> +		xfs_iunlock(ip, iolock);
> +		iolock = XFS_IOLOCK_EXCL;
> +		ret = xfs_ilock_iocb(iocb, iolock);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	ret = xfs_file_write_checks(iocb, from, &iolock);
>  	if (ret)
>  		goto out_unlock;
> @@ -563,7 +572,7 @@ xfs_file_dio_write_aligned(
>  	 * the iolock back to shared if we had to take the exclusive lock in
>  	 * xfs_file_write_checks() for other reasons.
>  	 */
> -	if (iolock == XFS_IOLOCK_EXCL) {
> +	if (iolock == XFS_IOLOCK_EXCL && !xfs_iflags_test(ip, XFS_ICLONING)) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;
>  	}
> @@ -622,6 +631,14 @@ xfs_file_dio_write_unaligned(
>  	if (ret)
>  		return ret;
>  
> +	if (xfs_iflags_test(ip, XFS_ICLONING) && iolock != XFS_IOLOCK_EXCL) {

xfs_iflags_test cycles a spinlock; you ought to put the cheaper
condition (the iolock check) first so that the compiler's shorcutting
can make this cheaper.

> +		xfs_iunlock(ip, iolock);
> +		iolock = XFS_IOLOCK_EXCL;
> +		ret = xfs_ilock_iocb(iocb, iolock);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/*
>  	 * We can't properly handle unaligned direct I/O to reflink files yet,
>  	 * as we can't unshare a partial block.
> @@ -1180,7 +1197,8 @@ xfs_file_remap_range(
>  	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
>  		xfs_log_force_inode(dest);
>  out_unlock:
> -	xfs_iunlock2_io_mmap(src, dest);
> +	xfs_reflink_unlock(src, dest);
> +	xfs_iflags_clear(src, XFS_ICLONING);

Clear the ICLONING flag before dropping the locks so that a caller
trying to get IOLOCK_EXCL won't wake up until the flag is really gone.

>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return remapped > 0 ? remapped : ret;
> @@ -1328,6 +1346,7 @@ __xfs_filemap_fault(
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	vm_fault_t		ret;
> +	uint                    mmaplock = XFS_MMAPLOCK_SHARED;
>  
>  	trace_xfs_filemap_fault(ip, order, write_fault);
>  
> @@ -1339,17 +1358,27 @@ __xfs_filemap_fault(
>  	if (IS_DAX(inode)) {
>  		pfn_t pfn;
>  
> -		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +		xfs_ilock(XFS_I(inode), mmaplock);
> +		if (xfs_iflags_test(ip, XFS_ICLONING)) {
> +			xfs_iunlock(ip, mmaplock);
> +			mmaplock = XFS_MMAPLOCK_EXCL;
> +			xfs_ilock(XFS_I(inode), mmaplock);
> +		}
>  		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
>  		if (ret & VM_FAULT_NEEDDSYNC)
>  			ret = dax_finish_sync_fault(vmf, order, pfn);
> -		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +		xfs_iunlock(XFS_I(inode), mmaplock);
>  	} else {
>  		if (write_fault) {
> -			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +			xfs_ilock(XFS_I(inode), mmaplock);
> +			if (xfs_iflags_test(ip, XFS_ICLONING)) {
> +				xfs_iunlock(ip, mmaplock);
> +				mmaplock = XFS_MMAPLOCK_EXCL;
> +				xfs_ilock(XFS_I(inode), mmaplock);
> +			}
>  			ret = iomap_page_mkwrite(vmf,
>  					&xfs_page_mkwrite_iomap_ops);
> -			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +			xfs_iunlock(XFS_I(inode), mmaplock);
>  		} else {
>  			ret = filemap_fault(vmf);
>  		}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 0c5bdb91152e..e3ff059c69f7 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -347,6 +347,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>  /* Quotacheck is running but inode has not been added to quota counts. */
>  #define XFS_IQUOTAUNCHECKED	(1 << 14)
>  
> +/* Clone in progress, do not allow modifications. */
> +#define XFS_ICLONING (1 << 15)

Somewhere we need to capture the locking behavior around this flag.

/*
 * Remap in progress.  Callers that wish to update file data while
 * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
 * the lock in exclusive mode.  Relocking the file will block until
 * ICLONING is cleared.
 */
#define XFS_IREMAPPING		(1U << 15)

On second thought, perhaps this should be called XFS_IREMAPPING?  Since
these semantics apply to dedupe in addition to clone.

> +
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
>  				 XFS_IRECLAIM | \
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index eb9102453aff..645cc196ee13 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
>  	if (ret)
>  		goto out_unlock;
>  
> +	xfs_iflags_set(src, XFS_ICLONING);
> +	if (inode_in != inode_out)
> +		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
> +
>  	return 0;
>  out_unlock:
>  	xfs_iunlock2_io_mmap(src, dest);
> @@ -1718,3 +1722,30 @@ xfs_reflink_unshare(
>  	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
>  	return error;
>  }
> +
> +/* Unlock both inodes after the reflink completes. */
> +void
> +xfs_reflink_unlock(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	struct address_space	*mapping1;
> +	struct address_space	*mapping2;
> +
> +	if (IS_DAX(VFS_I(ip1)) && IS_DAX(VFS_I(ip2))) {
> +		if (ip1 != ip2)
> +			xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
> +		xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
> +	} else {
> +		mapping1 = VFS_I(ip1)->i_mapping;
> +		mapping2 = VFS_I(ip2)->i_mapping;
> +		if (mapping1 && mapping1 != mapping2)
> +			up_read(&mapping1->invalidate_lock);
> +		if (mapping2)
> +			up_write(&mapping2->invalidate_lock);

XFS_MMAPLOCK is the same thing mapping->invalidate-lock; won't
the first version work for the !DAX case too?

--D

> +	}
> +
> +	if (ip1 != ip2)
> +		inode_unlock_shared(VFS_I(ip1));
> +	inode_unlock(VFS_I(ip2));
> +}
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 65c5dfe17ecf..89f4d2a2f52e 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -53,4 +53,6 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
>  extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
>  		xfs_extlen_t cowextsize, unsigned int remap_flags);
>  
> +void xfs_reflink_unlock(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +
>  #endif /* __XFS_REFLINK_H */
> -- 
> 2.34.1
> 
