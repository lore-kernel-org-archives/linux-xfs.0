Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4025FA05;
	Mon, 30 Mar 2026 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774834411; cv=none; b=ZAwLZICqjfzC3LfITCWzQqaFcLOLtAHGY7vkussHAhDFAa9C61LP0AJ5Oua6ReXLRi5fcisvjzWgyuau7LkwuhsEd3aeulqA9yUQrmoNezbbAmDy1H1N4NThoWanIxwVUbIrrzgh0ba2Y8LCHWO1BkXiA0Aq0Vu1nI88SCa0OHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774834411; c=relaxed/simple;
	bh=lpLl2ze0v4vDT+FhxHEd24BdefLO+7VPzUd2SBGhW3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjPZvjD+orcNWNBusVOrTLCUJanZyM/xGCaXFKHSEEl1+GfBb3uOQdiexmyRIK56mUEDm16dP+oc1Ot+Tx2K5p+z3z4aIXPJC9THRB3tFJFKuAmDrOQedBXFTsXmSvlSyJrgByYvmyAEvmhvxnXhUYXhy8+tJ4j82MFPkLbCECM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+HNe/r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+HNe/r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0745BC116C6;
	Mon, 30 Mar 2026 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774834410;
	bh=lpLl2ze0v4vDT+FhxHEd24BdefLO+7VPzUd2SBGhW3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+HNe/r+Rr6PE8NPdWuyOEyj54XHjOLjeQpaLJ72E/vrQmM7G8ZGQkTtPuHnuOHl2
	 0W89HLL3KD6YvG691St9t6ZGtXLfTkGzwS0xetdwnqERjXhmHhordYVDeqlSLPn6YZ
	 jIY1+hHtbSyt7izSXEJQBEWIuFLmvgn094LJrYhhOGNnD6NbefijRTpVL9UHyCg+LK
	 xS/HEb3f0MHWTaYF6Q5XCdDgtztDCeJfG23VCfLjlIwOHedH5iKr9IyEYgKyXafAY1
	 ZUOm1Ex0t089l+FRJ0vdLwjkcfjzCELrKRxJG349FayFIx5ayyWRQH/NKd6Qb5vUAJ
	 ynRKI+znIz3rA==
Date: Mon, 30 Mar 2026 12:33:22 +1100
From: Dave Chinner <dgc@kernel.org>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: annotate lockless bli_flags access in buf item paths
Message-ID: <acnS4iOihfWL4ay5@dread>
References: <20260327131448.156177-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327131448.156177-1-zzzccc427@gmail.com>

On Fri, Mar 27, 2026 at 09:14:48PM +0800, Cen Zhang wrote:
> xfs_buf_item_unpin() and xfs_buf_item_committed() read bip->bli_flags
> without holding the buffer lock, while xfs_buf_item_release() clears
> XFS_BLI_LOGGED, XFS_BLI_HOLD, and XFS_BLI_ORDERED under that lock.
> This can happen when an older checkpoint still holds a CIL reference to
> the BLI while a new transaction is finishing with the buffer.

It's much more complex than that, and I think that there aren't any
meaningful data races in these cases.

> The lockless readers only test XFS_BLI_STALE and
> XFS_BLI_INODE_ALLOC_BUF, which are disjoint from the bits being
> cleared, so correctness is not affected in practice.  However, the
> plain C accesses still constitute a data race that may allow the
> compiler to optimize them in unexpected ways (e.g., load tearing or
> fused reloads), so they should be marked explicitly.

I'm not sure that sort of thing will ever occur given that bli_flags
is a 32 bit int with natural alignment.

> Annotate the two lockless reads with READ_ONCE(), make the clearing
> store in xfs_buf_item_release() a WRITE_ONCE(), and use READ_ONCE() in
> the buf-item tracepoint that may snapshot bli_flags without the lock.
> 
> Fixes: 8e1238508633 ("xfs: remove stale parameter from ->iop_unpin method")
> Fixes: 71e330b59390 ("xfs: Introduce delayed logging core code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
> ---
>  fs/xfs/xfs_buf_item.c | 18 +++++++++++-------
>  fs/xfs/xfs_trace.h    |  2 +-
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8487635579e5..c3d0dc17ee10 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -502,7 +502,8 @@ xfs_buf_item_unpin(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	int			stale = bip->bli_flags & XFS_BLI_STALE;
> +	unsigned int		flags = READ_ONCE(bip->bli_flags);
> +	int			stale = flags & XFS_BLI_STALE;
>  	int			freed;

When XFS_BLI_STALE is set in unpin, then by definition the buffer
must be locked and the BLI referenced. i.e. the buffer is locked
when XFS_BLI_STALE is set, and it remains locked until journal
completion runs xfs_buf_item_unpin() and drops the final BLI
reference. So if XFS_BLI_STALE is set, this isn't an unlocked read.

Regardless of that, if the unpin call doesn't drop the last
reference, then we return from xfs_buf_item_unpin() without having
ever checked the stale flag. i.e the read is completely irrelevant
in cases but the last reference to the BLI.

And if this is the last reference to the BLI, then it is not joined
into a current transaction, which means nothing is going to be
changing the BLI state.

Hence we only care about the bli_flags when unpin has the only
remaining reference to the bli, and in that case the read cannot be
racing with anything else changing it's state. There is no
data access race here on the final reference, regardless of what
locks are held.

IOWs, using READ_ONCE to indicate a data access race is -incorrect-
in the cases where we actually use the result of the read.

Seriously: if you want to mark data accesses as being racy, you
better be adding comments to explain what the actual data race is
and why it matters enough that it needs annotation. Otherwise it is
just useless noise in the code...

>  	ASSERT(bp->b_log_item == bip);
> @@ -679,13 +680,14 @@ xfs_buf_item_release(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
> -	bool			stale = bip->bli_flags & XFS_BLI_STALE;
> +	unsigned int		flags = bip->bli_flags;
> +	bool			hold = flags & XFS_BLI_HOLD;
> +	bool			stale = flags & XFS_BLI_STALE;
>  	bool			aborted = test_bit(XFS_LI_ABORTED,
>  						   &lip->li_flags);
> -	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> +	bool			dirty = flags & XFS_BLI_DIRTY;
>  #if defined(DEBUG) || defined(XFS_WARN)
> -	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
> +	bool			ordered = flags & XFS_BLI_ORDERED;
>  #endif
>  
>  	trace_xfs_buf_item_release(bip);
> @@ -705,7 +707,8 @@ xfs_buf_item_release(
>  	 * per-transaction state from the bli, which has been copied above.
>  	 */
>  	bp->b_transp = NULL;
> -	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
> +	WRITE_ONCE(bip->bli_flags,
> +		   flags & ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED));
>  
>  	/* If there are other references, then we have nothing to do. */

This is always called with the buffer locked, so it already
serialises correctly against all the other reads that set or check
those flags under the buffer lock.

Indeed, why does this one specific write matter, and not all the
other writes to bip->bli_flags that set the flags that "lockless
reads" might trip over? Like, say, in xfs_trans_inode_alloc_buf() or
xfs_trans_binval()?

>  	if (!atomic_dec_and_test(&bip->bli_refcount))
> @@ -792,10 +795,11 @@ xfs_buf_item_committed(
>  	xfs_lsn_t		lsn)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> +	unsigned int		flags = READ_ONCE(bip->bli_flags);
>  
>  	trace_xfs_buf_item_committed(bip);
>  
> -	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
> +	if ((flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
>  		return lip->li_lsn;
>  	return lsn;

There is no consequential race here, either. Once an BLI is marked
as an XFS_BLI_INODE_ALLOC_BUF under the buffer lock - the same lock
hold that clears flags in xfs_buf_item_release() - that flag never
gets clears from bip->bli_flags. Hence we just don't care what the
compiler does for this read, because it will always return the correct
value no matter what. i.e. it is yet another benign data race....

> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb..2069534bb0c1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -895,7 +895,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  	),
>  	TP_fast_assign(
>  		__entry->dev = bip->bli_buf->b_target->bt_dev;
> -		__entry->bli_flags = bip->bli_flags;
> +		__entry->bli_flags = READ_ONCE(bip->bli_flags);

We just don't care here...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
