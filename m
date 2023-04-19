Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AEDC77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 15:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDSPSy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 11:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDSPSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 11:18:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570937A83
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 08:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 663BC64026
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 15:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C012FC433EF;
        Wed, 19 Apr 2023 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681917374;
        bh=MvDTm9gyeVhbSseTa+XHRqjKYVj22DWCxtghIUUZRT0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ghkCcDHzSYj82bhYzyAaYCATnBGs/3f1CclS/Tcr+sbrzgJ2Jl7RjOdhcLbGI03Ed
         +xrqEG9NPnycoTqVd7BYb8s47gXIviopNA5muh4XhaseOIjAV51R5TUlunapIE9Xbm
         kfJsTF17ygx9jP/aj1U0wpujQhBlw6vIj7fHcrzq5ZlNYekRfUAqnPWAYYjfDAhjWd
         GN9VMPRZ27klLO/rXKwpROE1c/xg3DRuUTEJ+04PDkQd8ch5wT5YL0gDCcUDFbPK37
         Bmh6Lafn7PP0sE4uqnvUXFyKFNSKR5zS3IMaJCgBa39nC2p9Z7KK2c2uxmVfvSzf4k
         0ZvBmTiMe37Nw==
Date:   Wed, 19 Apr 2023 08:16:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Christian Theune <ct@flyingcircus.io>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5.10 CANDIDATE] xfs: drop submit side trans alloc for
 append ioends
Message-ID: <20230419151614.GF360889@frogsfrogsfrogs>
References: <20230419043259.2026839-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419043259.2026839-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2023 at 07:32:59AM +0300, Amir Goldstein wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> commit 7cd3099f4925d7c15887d1940ebd65acd66100f5 upstream.
> 
> Per-inode ioend completion batching has a log reservation deadlock
> vector between preallocated append transactions and transactions
> that are acquired at completion time for other purposes (i.e.,
> unwritten extent conversion or COW fork remaps). For example, if the
> ioend completion workqueue task executes on a batch of ioends that
> are sorted such that an append ioend sits at the tail, it's possible
> for the outstanding append transaction reservation to block
> allocation of transactions required to process preceding ioends in
> the list.
> 
> Append ioend completion is historically the common path for on-disk
> inode size updates. While file extending writes may have completed
> sometime earlier, the on-disk inode size is only updated after
> successful writeback completion. These transactions are preallocated
> serially from writeback context to mitigate concurrency and
> associated log reservation pressure across completions processed by
> multi-threaded workqueue tasks.
> 
> However, now that delalloc blocks unconditionally map to unwritten
> extents at physical block allocation time, size updates via append
> ioends are relatively rare. This means that inode size updates most
> commonly occur as part of the preexisting completion time
> transaction to convert unwritten extents. As a result, there is no
> longer a strong need to preallocate size update transactions.
> 
> Remove the preallocation of inode size update transactions to avoid
> the ioend completion processing log reservation deadlock. Instead,
> continue to send all potential size extending ioends to workqueue
> context for completion and allocate the transaction from that
> context. This ensures that no outstanding log reservation is owned
> by the ioend completion worker task when it begins to process
> ioends.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reported-by: Christian Theune <ct@flyingcircus.io>
> Link: https://lore.kernel.org/linux-xfs/CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Darrick,
> 
> As I wrote in $LINK, this fix from v5.13 was missed from my backports
> due to a tool error.
> 
> It's also in good timeing because Chandan has just finished the v5.12
> backports.
> 
> I ran it though 10 kdevops cycles.
> 
> Please approve.

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
> 
>  fs/xfs/xfs_aops.c | 45 +++------------------------------------------
>  1 file changed, 3 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 953de843d9c3..e341d6531e68 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -39,33 +39,6 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  		XFS_I(ioend->io_inode)->i_d.di_size;
>  }
>  
> -STATIC int
> -xfs_setfilesize_trans_alloc(
> -	struct iomap_ioend	*ioend)
> -{
> -	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> -	struct xfs_trans	*tp;
> -	int			error;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	ioend->io_private = tp;
> -
> -	/*
> -	 * We may pass freeze protection with a transaction.  So tell lockdep
> -	 * we released it.
> -	 */
> -	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
> -	/*
> -	 * We hand off the transaction to the completion thread now, so
> -	 * clear the flag here.
> -	 */
> -	xfs_trans_clear_context(tp);
> -	return 0;
> -}
> -
>  /*
>   * Update on-disk file size now that data has been written to disk.
>   */
> @@ -191,12 +164,10 @@ xfs_end_ioend(
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -	else
> -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
>  
> +	if (!error && xfs_ioend_is_append(ioend))
> +		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  done:
> -	if (ioend->io_private)
> -		error = xfs_setfilesize_ioend(ioend, error);
>  	iomap_finish_ioends(ioend, error);
>  	memalloc_nofs_restore(nofs_flag);
>  }
> @@ -246,7 +217,7 @@ xfs_end_io(
>  
>  static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
>  {
> -	return ioend->io_private ||
> +	return xfs_ioend_is_append(ioend) ||
>  		ioend->io_type == IOMAP_UNWRITTEN ||
>  		(ioend->io_flags & IOMAP_F_SHARED);
>  }
> @@ -259,8 +230,6 @@ xfs_end_bio(
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	unsigned long		flags;
>  
> -	ASSERT(xfs_ioend_needs_workqueue(ioend));
> -
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
>  	if (list_empty(&ip->i_ioend_list))
>  		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
> @@ -510,14 +479,6 @@ xfs_prepare_ioend(
>  				ioend->io_offset, ioend->io_size);
>  	}
>  
> -	/* Reserve log space if we might write beyond the on-disk inode size. */
> -	if (!status &&
> -	    ((ioend->io_flags & IOMAP_F_SHARED) ||
> -	     ioend->io_type != IOMAP_UNWRITTEN) &&
> -	    xfs_ioend_is_append(ioend) &&
> -	    !ioend->io_private)
> -		status = xfs_setfilesize_trans_alloc(ioend);
> -
>  	memalloc_nofs_restore(nofs_flag);
>  
>  	if (xfs_ioend_needs_workqueue(ioend))
> -- 
> 2.34.1
> 
