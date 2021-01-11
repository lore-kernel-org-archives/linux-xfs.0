Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0CBC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF51A22795
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 19:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390625AbhAKTAy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 14:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390531AbhAKTAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 14:00:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610391566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g2GdxugnWr3ZKzDNa7wKoHZrbCSv3DhlAbpXvzRS6pY=;
        b=FH3Rj7pUKT3hB9e2j+yqE4bxoQUj1tOiJfGdiu8gIlwXz69jdR4X5bSXi4y/he9nKoq/YV
        6XxNnCrqHuvGlNlSYIc7XosWEfZxJc8hRvweeiqFevcESkRzUxRvvyTVlO9ZcEkS85yo/R
        ugYuSclXR3KUD8QamKS8S1C+yYwZabA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-sXuHQNqlOdeD05WT_9Okdg-1; Mon, 11 Jan 2021 13:59:24 -0500
X-MC-Unique: sXuHQNqlOdeD05WT_9Okdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26365107ACFE;
        Mon, 11 Jan 2021 18:59:23 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82E4F60BE5;
        Mon, 11 Jan 2021 18:59:22 +0000 (UTC)
Date:   Mon, 11 Jan 2021 13:59:20 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 3/3] xfs: try to avoid the iolock exclusive for
 non-aligned direct writes
Message-ID: <20210111185920.GF1091932@bfoster>
References: <20210111161212.1414034-1-hch@lst.de>
 <20210111161212.1414034-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161212.1414034-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:12:12PM +0100, Christoph Hellwig wrote:
> We only need the exclusive iolock for direct writes to protect sub-block
> zeroing after an allocation or conversion of unwritten extents, and the
> synchronous execution of these writes is also only needed because the
> iolock is dropped early for the dodgy i_dio_count synchronisation.
> 
> Always start out with the shared iolock in xfs_file_dio_aio_write for
> non-appending writes and only upgrade it to exclusive if the start and
> end of the write range are not already allocated and in written
> state.  This means one or two extra lookups in the in-core extent tree,
> but with our btree data structure those lookups are very cheap and do
> not show up in profiles on NVMe hardware for me.  On the other hand
> avoiding the lock allows for a high concurrency using aio or io_uring.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Avi Kivity <avi@scylladb.com>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 127 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 96 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1470fc4f2e0255..59d4c6e90f06c1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -521,6 +521,57 @@ static const struct iomap_dio_ops xfs_dio_write_ops = {
>  	.end_io		= xfs_dio_write_end_io,
>  };
>  
> +static int
> +xfs_dio_write_exclusive(
> +	struct kiocb		*iocb,
> +	size_t			count,
> +	bool			*exclusive_io)
> +{
> +	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_ifork	*ifp = &ip->i_df;
> +	loff_t			offset = iocb->ki_pos;
> +	loff_t			end = offset + count;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
> +	struct xfs_bmbt_irec	got = { };
> +	struct xfs_iext_cursor	icur;
> +	int			ret;
> +
> +	*exclusive_io = true;
> +
> +	/*
> +	 * Bmap information not read in yet or no blocks allocated at all?
> +	 */
> +	if (!(ifp->if_flags & XFS_IFEXTENTS) || !ip->i_d.di_nblocks)
> +		return 0;
> +
> +	ret = xfs_ilock_iocb(iocb, XFS_ILOCK_SHARED);
> +	if (ret)
> +		return ret;

It looks like this helper is only called with ILOCK_SHARED already held.

> +
> +	if (offset & mp->m_blockmask) {
> +		if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &icur, &got) ||
> +		    got.br_startoff > offset_fsb ||
> +		    got.br_state == XFS_EXT_UNWRITTEN)
> +		    	goto out_unlock;
> +	}
> +
> +	if ((end & mp->m_blockmask) &&
> +	    got.br_startoff + got.br_blockcount <= end_fsb) {
> +		if (!xfs_iext_lookup_extent(ip, ifp, end_fsb, &icur, &got) ||
> +		    got.br_startoff > end_fsb ||
> +		    got.br_state == XFS_EXT_UNWRITTEN)
> +		    	goto out_unlock;

This line and the same goto in the previous block are both whitespace
damaged (tabs before spaces).

> +	}
> +
> +	*exclusive_io = false;
> +
> +out_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	return ret;
> +}
> +
>  /*
>   * xfs_file_dio_aio_write - handle direct IO writes
>   *
> @@ -557,8 +608,9 @@ xfs_file_dio_aio_write(
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	ssize_t			ret = 0;
> -	int			unaligned_io = 0;
> -	int			iolock;
> +	int			iolock = XFS_IOLOCK_SHARED;
> +	bool			subblock_io = false;
> +	bool			exclusive_io = false;
>  	size_t			count = iov_iter_count(from);
>  	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
>  
> @@ -566,45 +618,58 @@ xfs_file_dio_aio_write(
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
> -	/*
> -	 * Don't take the exclusive iolock here unless the I/O is unaligned to
> -	 * the file system block size.  We don't need to consider the EOF
> -	 * extension case here because xfs_file_aio_write_checks() will relock
> -	 * the inode as necessary for EOF zeroing cases and fill out the new
> -	 * inode size as appropriate.
> -	 */
> +	/* I/O that is not aligned to the fsblock size will need special care */
>  	if ((iocb->ki_pos & mp->m_blockmask) ||
> -	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
> -		unaligned_io = 1;
> +	    ((iocb->ki_pos + count) & mp->m_blockmask))
> +		subblock_io = true;
>  
> -		/*
> -		 * We can't properly handle unaligned direct I/O to reflink
> -		 * files yet, as we can't unshare a partial block.
> -		 */
> -		if (xfs_is_cow_inode(ip)) {
> -			trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
> -			return -ENOTBLK;
> -		}
> -		iolock = XFS_IOLOCK_EXCL;
> -	} else {
> -		iolock = XFS_IOLOCK_SHARED;
> +	/*
> +	 * We can't properly handle unaligned direct I/O to reflink files yet,
> +	 * as we can't unshare a partial block.
> +	 */
> +	if (subblock_io && xfs_is_cow_inode(ip)) {
> +		trace_xfs_reflink_bounce_dio_write(ip, iocb->ki_pos, count);
> +		return -ENOTBLK;
>  	}
>  
> -	if (iocb->ki_flags & IOCB_NOWAIT) {
> -		/* unaligned dio always waits, bail */
> -		if (unaligned_io)
> -			return -EAGAIN;
> -		if (!xfs_ilock_nowait(ip, iolock))
> +	/*
> +	 * Racy shortcut for obvious appends to avoid too much relocking:

s/:/./

> +	 */
> +	if (iocb->ki_pos > i_size_read(inode)) {
> +		if (iocb->ki_flags & IOCB_NOWAIT)
>  			return -EAGAIN;

Not sure why we need this check here if we'll eventually fall into the
serialized check. It seems safer to me to just do 'iolock =
XFS_IOLOCK_EXCL;' here and carry on.

> -	} else {
> -		xfs_ilock(ip, iolock);
> +		iolock = XFS_IOLOCK_EXCL;
>  	}
>  
> +relock:
> +	ret = xfs_ilock_iocb(iocb, iolock);
> +	if (ret)
> +		return ret;
>  	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
>  	if (ret)
>  		goto out;
>  	count = iov_iter_count(from);
>  
> +	/*
> +	 * Upgrade to an exclusive lock and force synchronous completion if the
> +	 * I/O will require partial block zeroing.
> +	 * We don't need to consider the EOF extension case here because
> +	 * xfs_file_aio_write_checks() will relock the inode as necessary for
> +	 * EOF zeroing cases and fill out the new inode size as appropriate.
> +	 */
> +	if (iolock != XFS_IOLOCK_EXCL && subblock_io) {
> +		ret = xfs_dio_write_exclusive(iocb, count, &exclusive_io);
> +		if (ret)
> +			goto out;
> +		if (exclusive_io) {
> +			xfs_iunlock(ip, iolock);
> +			if (iocb->ki_flags & IOCB_NOWAIT)
> +				return -EAGAIN;
> +			iolock = XFS_IOLOCK_EXCL;
> +			goto relock;
> +		}
> +	}
> +
>  	/*
>  	 * If we are doing unaligned IO, we can't allow any other overlapping IO
>  	 * in-flight at the same time or we risk data corruption. Wait for all
> @@ -612,7 +677,7 @@ xfs_file_dio_aio_write(
>  	 * iolock if we had to take the exclusive lock in
>  	 * xfs_file_aio_write_checks() for other reasons.
>  	 */
> -	if (unaligned_io) {
> +	if (exclusive_io) {

Hmm.. so if we hold or upgrade to ILOCK_EXCL from the start for whatever
reason, we'd never actually check whether the I/O is "exclusive" or not.
Then we fall into here, demote the lock and the iomap layer may very
well end up doing subblock zeroing. I suspect if we wanted to maintain
this logic, the exclusive I/O check should occur for any subblock_io
regardless of how the lock is held.

Also, the comment above this check could use an update since it still refers
to "unaligned IO."

Brian

>  		inode_dio_wait(inode);
>  	} else if (iolock == XFS_IOLOCK_EXCL) {
>  		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
> @@ -626,7 +691,7 @@ xfs_file_dio_aio_write(
>  	 */
>  	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
>  			   &xfs_dio_write_ops,
> -			   is_sync_kiocb(iocb) || unaligned_io);
> +			   is_sync_kiocb(iocb) || exclusive_io);
>  out:
>  	if (iolock)
>  		xfs_iunlock(ip, iolock);
> -- 
> 2.29.2
> 

