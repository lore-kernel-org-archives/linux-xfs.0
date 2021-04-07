Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E4BC433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F676139C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbhDGPcC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243285AbhDGPcC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB96C6138B;
        Wed,  7 Apr 2021 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617809512;
        bh=YG4Yq2Lut7kk5ro5Un2r6OPE5aYAuIDTb9vgTjIT+u0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZLUMJKT3kLpij8375H+DeADbfocF7sIT+5Pew+2FIFxpdu+uGOlTeT4eLnPsb2ji
         GoHY/WFy06azSW8fal10ODszazOyn6L5Y1T7XZgoJpjdAfCkGEP2oMORAh49mxxS3A
         0s2R9gWKVQZ/EUR/6XsNIUsPikL2d3U3drvDCsX6WrEfmrew5EDNbI5wKpgq15xlJp
         etwKMHvfXgJ1i2GcPrx/kgK7WdfJ+Or/6uBHhEgvsYvTa/935fIXlick3gJpIZbRu+
         MWsLIrkmPdVNkSEfTDwCKJMLfI9kzhAiUTGb3T4xU+og3kgtxog8/Rg5aZ0rFlJvI/
         GtnyYCh6TlhlQ==
Date:   Wed, 7 Apr 2021 08:31:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: drop submit side trans alloc for append ioends
Message-ID: <20210407153152.GI3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:00AM -0400, Brian Foster wrote:
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
> ---
>  fs/xfs/xfs_aops.c | 45 +++------------------------------------------
>  1 file changed, 3 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 1cc7c36d98e9..c1951975bd6a 100644
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
> @@ -182,12 +155,10 @@ xfs_end_ioend(
>  		error = xfs_reflink_end_cow(ip, offset, size);

Seems reasonable to me.  xfs_reflink_end_cow_extent should probably
learn how to extend the ondisk EOF as patch 6/4.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -	else
> -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
>  
>  done:
> -	if (ioend->io_private)
> -		error = xfs_setfilesize_ioend(ioend, error);
> +	if (!error && xfs_ioend_is_append(ioend))
> +		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
>  	iomap_finish_ioends(ioend, error);
>  	memalloc_nofs_restore(nofs_flag);
>  }
> @@ -237,7 +208,7 @@ xfs_end_io(
>  
>  static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
>  {
> -	return ioend->io_private ||
> +	return xfs_ioend_is_append(ioend) ||
>  		ioend->io_type == IOMAP_UNWRITTEN ||
>  		(ioend->io_flags & IOMAP_F_SHARED);
>  }
> @@ -250,8 +221,6 @@ xfs_end_bio(
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	unsigned long		flags;
>  
> -	ASSERT(xfs_ioend_needs_workqueue(ioend));
> -
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
>  	if (list_empty(&ip->i_ioend_list))
>  		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
> @@ -501,14 +470,6 @@ xfs_prepare_ioend(
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
> 2.26.3
> 
