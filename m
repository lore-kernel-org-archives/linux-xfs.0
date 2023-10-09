Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0888CD6137
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 21:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378284AbjJIVSS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 17:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378722AbjJIVSI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 17:18:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B621BE3
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 14:17:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04469C433C8;
        Mon,  9 Oct 2023 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696886236;
        bh=P3KiM8/0lPjQi4ed1Eo583KVgGcAqulGQzxagyQ3Dco=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fexeVqR9Lzq4nB0ZNgYWn06MFNkBz+wN7HiWfRDwQtmrYiKKYsO+4sqg1EDqYuZZO
         IYHs8gebHIZU7/L7k6KtqADbVr4Ze5Tpat1uZKXsMC9XiLuM2WhQyrx1i0jHab8jyd
         szRAbUNuFNjH9M+rcaOmcTBuU0poaGbNk74X0BzyQXqX0EmMG1JyTpOJsMePbEoDZl
         GOZVCVq9o2eorOVRfFMIyNjAql71if4z+hVnArsD11jnxfGEPZQipWu2cvFIQlX3Pw
         D81fa8ijQ8nbrX4e7V7t406Zhd6mxBOUwnkjo5eGDBkV83QEFbdqViM12uyh4EfqEM
         94hqMCen040YQ==
Date:   Mon, 9 Oct 2023 14:17:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <20231009211715.GE21298@frogsfrogsfrogs>
References: <20231009205936.38644-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009205936.38644-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 09, 2023 at 01:59:36PM -0700, Catherine Hoang wrote:
> Clone operations and read IO do not change any data in the source file, so they
> should be able to run concurrently. Demote the exclusive locks taken by FICLONE
> to shared locks to allow reads while cloning. While a clone is in progress,
> writes will take the IOLOCK_EXCL, so they block until the clone completes.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/xfs_file.c    | 41 +++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_inode.h   |  8 ++++++++
>  fs/xfs/xfs_reflink.c | 19 +++++++++++++++++++
>  fs/xfs/xfs_reflink.h |  2 ++
>  4 files changed, 64 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 203700278ddb..5bfb2013366f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -554,6 +554,15 @@ xfs_file_dio_write_aligned(
>  	ret = xfs_ilock_iocb(iocb, iolock);
>  	if (ret)
>  		return ret;
> +
> +	if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
> +	if (iolock == XFS_IOLOCK_EXCL && !xfs_iflags_test(ip, XFS_IREMAPPING)) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  		iolock = XFS_IOLOCK_SHARED;

If we hold IOLOCK_EXCL on an aligned write and we think we can demote
the lock to IOLOCK_SHARED, why do we need to test IREMAPPING?

The direct writer holds IOLOCK_EXCL, so there cannot be any remapping
operations in progress on this file at all.

OTOH if there are remapping operations holding the IOLOCK in any mode,
then there cannot be any direct writers holding IOLOCK_EXCL.

There can't be any xfs_file_dio_write_aligned threads holding
IOLOCK_SHARED racing with reflink because either the direct writer sees
IREMAPPING and has to drop IOLOCK_SHARED to get IOLOCK_EXCL; or the
direct write is proceeding while holding IOLOCK_SHARED, which prevents
reflink from starting up.

So, uh, what is the IREMAPPING test here protecting against?

(Did I miss some other conflict between reflink and the dio count?
That's entirely possible...)

>  	}
> @@ -622,6 +631,14 @@ xfs_file_dio_write_unaligned(
>  	if (ret)
>  		return ret;
>  
> +	if (iolock != XFS_IOLOCK_EXCL && xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
> +	xfs_iflags_clear(src, XFS_IREMAPPING);
> +	xfs_reflink_unlock(src, dest);
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
> +		if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
> +			if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
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
> index 0c5bdb91152e..3046ddfa2358 100644
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
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index eb9102453aff..26cbf99061b0 100644
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
> @@ -1718,3 +1722,18 @@ xfs_reflink_unshare(
>  	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
>  	return error;
>  }
> +
> +/* Unlock both inodes after the reflink completes. */

This comment should be more specific about what it unlocks:

/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */

--D

> +void
> +xfs_reflink_unlock(
> +	struct xfs_inode	*ip1,
> +	struct xfs_inode	*ip2)
> +{
> +	if (ip1 != ip2)
> +		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
> +	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
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
