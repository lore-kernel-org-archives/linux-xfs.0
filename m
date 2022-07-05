Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261FDC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 18:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiGESh7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 14:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGESh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 14:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC51D0D0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 11:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22D73B818EE
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 18:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACE0C341C7;
        Tue,  5 Jul 2022 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657046274;
        bh=blHK3NDtFdxf6rMCgoKNnQY5HuEaSAROGoC+CksRFK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spDtHXmGx6BOtVap6Jjj8Vzy0tBybAztGqRUmhnaW9mQmwB4dlh0gaPL6B8Ua+i0I
         T8PuSeyuM2qjsLruvMp5PlfNMGkAVX8NfYrbsFRzpIc0iVuXlORZu+UcrywpHmUpvh
         6vm+1daFgt5FYE9f2gTy0GRd5wyr2ErvXCaEmnvoWQTgSn7M/TKqomMMOObkwsq353
         g1SOTerBKteiLOhCdTt+IfkmshEqTFi9X24gd9H2Z9is+6DewNn6mkj7fUcYr/8MEd
         ccIqb5t/Uv03vAEm8MbQ7ojySKwODmEBll0UImrLELKCmeuooB1P2kFiuCdbwicMeD
         AaI0rEdvDlQIA==
Date:   Tue, 5 Jul 2022 11:37:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V2] xfs: make src file readable during reflink
Message-ID: <YsSFAmc70npnoCbM@magnolia>
References: <20220629060755.25537-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629060755.25537-1-wen.gang.wang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 11:07:55PM -0700, Wengang Wang wrote:
> During a reflink operation, the IOLOCK and MMAPLOCK of the source file
> are held in exclusive mode for the duration. This prevents reads on the
> source file, which could be a very long time if the source file has
> millions of extents.
> 
> As the source of copy, besides some necessary modification (say dirty page
> flushing), it plays readonly role. Locking source file exclusively through
> out the full reflink copy is unreasonable.
> 
> This patch downgrades exclusive locks on source file to shared modes after
> page cache flushing and before cloning the extents. To avoid source file
> change after lock downgradation, direct write paths take IOLOCK_EXCL on
> seeing reflink copy happening to the files.

This is going to complicate the synchronization logic between reflink
and everything else quite a bit -- right now we generally allow multiple
concurrent direct writers (IOLOCK) and write faults (MMAPLOCK) per file,
so space mapping operations (fallocate/reflink) can lock out those
writers in a simple manner.

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
> V2 changes:
>  Commit message
>  Make direct write paths take IOLOCK_EXCL when reflink copy is happening
>  Tiny changes
> ---
>  fs/xfs/xfs_file.c  | 33 ++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_inode.c | 31 +++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h | 11 +++++++++++
>  3 files changed, 72 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5a171c0b244b..6ca7118ee274 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -514,8 +514,10 @@ xfs_file_dio_write_aligned(
>  	struct iov_iter		*from)
>  {
>  	unsigned int		iolock = XFS_IOLOCK_SHARED;
> +	int			remapping;

bool?

>  	ssize_t			ret;
>  
> +relock:
>  	ret = xfs_ilock_iocb(iocb, iolock);
>  	if (ret)
>  		return ret;
> @@ -523,14 +525,25 @@ xfs_file_dio_write_aligned(
>  	if (ret)
>  		goto out_unlock;
>  
> +	remapping = xfs_iflags_test(ip, XFS_IREMAPPING);

remapping = xfs_has_reflink(mp) && xfs_iflags_test(ip, XFS_IREMAPPING);

so that you can skip the locked test on filesystems where remapping
isn't possible.

> +
>  	/*
>  	 * We don't need to hold the IOLOCK exclusively across the IO, so demote
>  	 * the iolock back to shared if we had to take the exclusive lock in
>  	 * xfs_file_write_checks() for other reasons.
> +	 * But take IOLOCK_EXCL when reflink copy is going on
>  	 */
>  	if (iolock == XFS_IOLOCK_EXCL) {
> -		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> -		iolock = XFS_IOLOCK_SHARED;
> +		if (!remapping) {
> +			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> +			iolock = XFS_IOLOCK_SHARED;
> +		}

Hm.  So the logic in the IOLOCK_EXCL case is that if a directio write
takes IOLOCK_EXCL, there can't possibly be a remap operation running.
Remap operations themselves always start by taking IOLOCK_EXCL before
setting IREMAPPING, so a remap operation cannot set IREMAPPING until
after this directio completes.

In the IOLOCK_SHARED case below, the directio upgrades to IOLOCK_EXCL if
a remap operation is detected.  We're protected against IREMAPPING
getting set while we hold IOLOCK_SHARED (because remap operations start
by taking IOLOCK_EXCL), though in theory we could race with the end of a
remapping operation, which at worst will result in an unnecessary
IOLOCK_EXCL acquisition, right?

There can only be one remapping operation in progress at a time because
they will take IOLOCK_EXCL initially and demote to _SHARED, so there
shouldn't be any races to setting and clearing IREMAPPING.

So I /think/ this works, but concurrency is hard to think about. :/

> +	} else { /* iolock == XFS_ILOCK_SHARED */

IOLOCK_SHARED, not ILOCK_SHARED?

> +		if (remapping) {
> +			xfs_iunlock(ip, iolock);
> +			iolock = XFS_IOLOCK_EXCL;
> +			goto relock;
> +		}
>  	}
>  	trace_xfs_file_direct_write(iocb, from);
>  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
> @@ -1125,6 +1138,19 @@ xfs_file_remap_range(

Aren't changes necessary for xfs_file_dio_write_unaligned too?

>  	if (ret || len == 0)
>  		return ret;
>  
> +	/*
> +	 * Set XFS_IREMAPPING flag to source file before we downgrade
> +	 * the locks, so that all direct writes know they have to take
> +	 * IOLOCK_EXCL.
> +	 */
> +	xfs_iflags_set(src, XFS_IREMAPPING);
> +
> +	/*
> +	 * From now on, we read only from src, so downgrade locks to allow
> +	 * read operations go.
> +	 */
> +	xfs_ilock_io_mmap_downgrade_src(src, dest);
> +
>  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
>  
>  	ret = xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
> @@ -1152,7 +1178,8 @@ xfs_file_remap_range(
>  	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
>  		xfs_log_force_inode(dest);
>  out_unlock:
> -	xfs_iunlock2_io_mmap(src, dest);
> +	xfs_iflags_clear(src, XFS_IREMAPPING);
> +	xfs_iunlock2_io_mmap_src_shared(src, dest);
>  	if (ret)
>  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
>  	return remapped > 0 ? remapped : ret;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 52d6f2c7d58b..1cbd4a594f28 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3786,6 +3786,16 @@ xfs_ilock2_io_mmap(
>  	return 0;
>  }
>  
> +/* Downgrade the locks on src file if src and dest are not the same one. */
> +void
> +xfs_ilock_io_mmap_downgrade_src(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	if (src != dest)
> +		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);

Oh, you're downgrading MMAPLOCK_EXCL (aka invalidate_lock) too?

That's going to be tricky to figure out -- write page faults (and
apparently all DAX faults) take MMAPLOCK_SHARED (invalidate_lock_shared)
so I think you'd have to add similar "upgrade/downgrade lock" logic to
__xfs_filemap_fault?

I'm not 100% sure I'm correct about that statement, my head is starting
to spin and I'm not sure it's worth the complexity.

I /do/ wonder if range locking would be a better solution here, since we
can safely unlock file ranges that we've already remapped?

--D

> +}
> +
>  /* Unlock both inodes to allow IO and mmap activity. */
>  void
>  xfs_iunlock2_io_mmap(
> @@ -3798,3 +3808,24 @@ xfs_iunlock2_io_mmap(
>  	if (ip1 != ip2)
>  		inode_unlock(VFS_I(ip1));
>  }
> +
> +/*
> + * Unlock the exclusive locks on dest file.
> + * Also unlock the shared locks on src if src and dest are not the same one
> + */
> +void
> +xfs_iunlock2_io_mmap_src_shared(
> +	struct xfs_inode	*src,
> +	struct xfs_inode	*dest)
> +{
> +	struct inode	*src_inode = VFS_I(src);
> +	struct inode	*dest_inode = VFS_I(dest);
> +
> +	inode_unlock(dest_inode);
> +	filemap_invalidate_unlock(dest_inode->i_mapping);
> +	if (src == dest)
> +		return;
> +
> +	inode_unlock_shared(src_inode);
> +	filemap_invalidate_unlock_shared(src_inode->i_mapping);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 7be6f8e705ab..c07d4b42cf9d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -262,6 +262,13 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
>   */
>  #define XFS_INACTIVATING	(1 << 13)
>  
> +/*
> + * A flag indicating reflink copy / remapping is happening to the file as
> + * source. When set, all direct IOs should take IOLOCK_EXCL to avoid
> + * interphering the remapping.
> + */
> +#define XFS_IREMAPPING		(1 << 14)
> +
>  /* All inode state flags related to inode reclaim. */
>  #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
>  				 XFS_IRECLAIM | \
> @@ -512,5 +519,9 @@ void xfs_end_io(struct work_struct *work);
>  
>  int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
>  void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
> +void xfs_ilock_io_mmap_downgrade_src(struct xfs_inode *src,
> +					struct xfs_inode *dest);
> +void xfs_iunlock2_io_mmap_src_shared(struct xfs_inode *src,
> +					struct xfs_inode *dest);
>  
>  #endif	/* __XFS_INODE_H__ */
> -- 
> 2.21.0 (Apple Git-122.2)
> 
