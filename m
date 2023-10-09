Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E98CD613C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 21:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378717AbjJIVjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378298AbjJIVjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 17:39:18 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582179D
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 14:39:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5809d5fe7f7so3284837a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2023 14:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696887557; x=1697492357; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TitE2Gfc6ijQhJCqqQhMSXftXFdI0hKP8a41rhK98j4=;
        b=YxTpHbJXKtHgvS59cjtLpM3+kW9+mTuyIddqGuAeJkTk3ukHI/hfrKXAdkaD5EYh0j
         /cl58+k42hiPRyF7BP+gHsd4elqxolgcJ5MF3fEM4CtwZCKKhE6QrY3wFBN2Grejplzs
         xj3LTC1D7iM9GdJS7DFuzOtHHvXWok6DmXv5eo6tHlOfB/XZO8hJW9gmjHpY+QI0lQNA
         C8cesSWBB0zeiDbDl/68Rl1SDOBoFUGKnL3kS9S5DNBaDdEU30Q8UZK2sny9+h3xUIO9
         J7HZDz9Qz4gdCfFwl6Mt5dLc0RpNqq5xyWCdVjdeBaeHXV/u2d8RYMtiO1lL1rur8jJD
         sZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696887557; x=1697492357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TitE2Gfc6ijQhJCqqQhMSXftXFdI0hKP8a41rhK98j4=;
        b=QNzr+NkMtUiwX+DCG9a+jDKGL0geQ12ARTBn/PUgv7x73LCo3HHgSEDga8yGQFCBF0
         A75WoyfH8EGU0gX5W4ufxbD+iD9KdhJgl6nfyusFS7CswTynz+ANFZ2XFYP2vIdyPQuo
         /I/Ffyu+jrJHffGPKCAqSgHI4XD886u1b8uhKoG3TqWn/YHfIKx4zzR4jCtwHWf2A9nC
         1k1LncmKgClOLSiLHPgpOEWINO8K2mYiTri0bojmtZBb0ZdS9+s0k2n41G+UwiJPdpUy
         3buvroOQApp1BF+LBclY5/bAL65LnqIpWzNLWgHlwQvFXTKd5svIsyygde4PHvE/P3K4
         v89Q==
X-Gm-Message-State: AOJu0YzK9sWdsY2TjaHl7nZ6YCD3y+tZVJNsGyiYjZtzk7gVBOkTrHSQ
        cjw9FQlquRmNVSsIJTFb89Cs1i6++rTFo0Z9HOs=
X-Google-Smtp-Source: AGHT+IEcZqEdBt+/ipBjNsYccY4mq35OP0JwlfHFqw/ccG6Nzzo+gLpQkA7NqbJANwa6m0ewBIMY4w==
X-Received: by 2002:a05:6a20:5647:b0:153:919e:18ce with SMTP id is7-20020a056a20564700b00153919e18cemr13358117pzc.48.1696887556531;
        Mon, 09 Oct 2023 14:39:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090322c700b001c726147a46sm10095160plg.234.2023.10.09.14.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 14:39:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qpxy5-00Bh69-07;
        Tue, 10 Oct 2023 08:39:13 +1100
Date:   Tue, 10 Oct 2023 08:39:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: allow read IO and FICLONE to run concurrently
Message-ID: <ZSRzAVdTMeL4CcjM@dread.disaster.area>
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

This has turned out pretty nice and simple :)

I have a couple of suggestions to improve it further, though.

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
>  	}

This is unnecessary. If we already have the IOLOCK_EXCL, then a
remapping cannot be in progress and hence that flag should never be
set here.

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

Rather than duplicating this, I'm wondering if we should just put
this in a wrapper - xfs_ilock_iocb_for_write(), which does:

static int
xfs_ilock_iocb_for_write(
	struct kiocb	*iocb,
	int		*lock_mode)
{
	struct xfs_inode *ip = XFS_I(file_inode(iocb->ki_filp));

	do {
		ret = xfs_ilock_iocb(iocb, *lock_mode);
		if (ret)
			return ret;
		if (*lock_mode == XFS_IOLOCK_EXCL)
			return 0;
		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
			return 0;
		xfs_iunlock(ip, *lock_mode);
		*lock_mode = XFS_IOLOCK_EXCL;
	} while (1);
	/* notreached */
	return -EAGAIN;
}

And then we can call it from the buffered and DAX write paths, too,
so that all the write IO paths use the same locking and will handle
this case automatically if they are converted to use shared locking.

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

Make that xfs_iunlock2_remapping(), and move the clearing of the
remapping bit inside it.


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

This would be better done as:

	lock_mode = 0;
	if (IS_DAX(inode) || write_fault)
		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));

	if (IS_DAX(inode)) {
		pfn_t pfn;

		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
		if (ret & VM_FAULT_NEEDDSYNC)
			ret = dax_finish_sync_fault(vmf, order, pfn);
	} else if (write_fault) {
		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
	} else {
		ret = filemap_fault(vmf);
	}

	if (lock_mode)
		xfs_iunlock(XFS_I(inode), lock_mode);
....


and

static int
xfs_ilock_for_write_fault(
	struct xfs_inode	*ip)
{
	int			lock_mode = XFS_MMAPLOCK_SHARED;

	do {
		xfs_ilock(ip, lock_mode);
		if (!xfs_iflags_test(ip, XFS_IREMAPPING))
			return lock_mode;
		if (lock_mode == XFS_MMAPLOCK_EXCL)
			return lock_mode;
		xfs_iunlock(ip, lock_mode);
		lock_mode = XFS_MMAPLOCK_SHARED;
	} while (1);
	/* notreached */
	return 0;
}

This separates out the locking from the processing of the fault
quite nicely....

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

That should go with all the other inode locking functions in
xfs_inode.c.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
