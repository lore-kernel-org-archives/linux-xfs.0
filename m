Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872B4211A14
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768577160; cv=none; b=AD4y/pWt3A1NjIBQS2zIuG8gzWD357w4w55f9Dx+WNsz35dmcIm+tkLQchYI4MZAcO1gar3Yad6I+hj1HnbIn+zAL/tdHdpR3rLq/N5FwwsMay0D+NK4BdDtIhIV1N1H5lkgFprgVXkDSkKCV7hntiCbbr3TcS1e9PHc7Lny2yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768577160; c=relaxed/simple;
	bh=oNjpnsnJfuCDHoPxI7XXpo8CZLVCEJpxCxQZAcWnUjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6KesKbgM16i/CY3RNFwbldEjirsiSnDooHjsqe+dW1wLMWBWdOrNONk1KnaLExszZdbJm0g0kzB9QAUYXZ/1v4DFG0ZCGYJsG7yePZcOq0lfucOTw9MvQsNdcYBVjVTOFiSB9oUE+ryn3SyLhvQi/CJamYscnf49Tu2bEzUzn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SCYaHjaD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SCYaHjaD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ae6dnVEx8QIWtSiAIRFhdhqT4aRXhTlfickTLHThUgA=; b=SCYaHjaDhozWjXlAwCnIxxyZLH
	7qxUGr7PmkQQj0QrEuqc6bIvnAuEtXsR7QMyYU/viZKIvGpXWD5Fv9PY42xVhsrCvhTmF3vXD/ldJ
	C4OjF3DSI1fhSzMpCX7dyWvJXwxxChEu2jO6rzh66X4lCcsMXLFBbRNJ7lsMTaH+n+vkfdn88UpKx
	25S2udEyZHlQUAJHDCigzep2wfkhIofSvRfshG4v+B2bY2A5GStW61TjFRRRgEGAQ2eVsHIUblJRh
	ShgCG5whazOI+AKEUEoXbyvspWwD/99XaaZt5mvbbIXdudmsHTPoaKOYpAGAsClhtt6pjZUkzPPuf
	3JoBr+hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vgli2-0000000EMRf-3xLJ;
	Fri, 16 Jan 2026 15:25:58 +0000
Date: Fri, 16 Jan 2026 07:25:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Wenwu Hou <hwenwur@gmail.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <aWpYhpNFTfMqdh-r@infradead.org>
References: <20260116103807.109738-1-hwenwur@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116103807.109738-1-hwenwur@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 16, 2026 at 06:38:07PM +0800, Wenwu Hou wrote:
> The memalloc_nofs_save() and memalloc_nofs_restore() calls are
> incorrectly paired in xfs_trans_roll.
> 
> Call path:
> xfs_trans_alloc()
>     __xfs_trans_alloc()
> 	// tp->t_pflags = memalloc_nofs_save();
> 	xfs_trans_set_context()
> ...
> xfs_defer_trans_roll()
>     xfs_trans_roll()
>         xfs_trans_dup()
>             // old_tp->t_pflags = 0;
>             xfs_trans_switch_context()
>         __xfs_trans_commit()
>             xfs_trans_free()
>                 // memalloc_nofs_restore(tp->t_pflags);
>                 xfs_trans_clear_context()
> 
> The code passes 0 to memalloc_nofs_restore() when committing the original
> transaction, but memalloc_nofs_restore() should always receive the
> flags returned from the paired memalloc_nofs_save() call.
> 
> Before commit 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}"),
> calling memalloc_nofs_restore(0) would unset the PF_MEMALLOC_NOFS flag,
> which could cause memory allocation deadlocks[1].
> Fortunately, after that commit, memalloc_nofs_restore(0) does nothing,
> so this issue is currently harmless.
> 
> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> Link: https://lore.kernel.org/linux-xfs/20251104131857.1587584-1-leo.lilong@huawei.com [1]
> Signed-off-by: Wenwu Hou <hwenwur@gmail.com>
> ---
>  fs/xfs/xfs_trans.c | 3 +--
>  fs/xfs/xfs_trans.h | 9 ---------
>  2 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 474f5a04ec63..d2ab296a52bc 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -124,8 +124,6 @@ xfs_trans_dup(
>  	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
>  	tp->t_rtx_res = tp->t_rtx_res_used;
>  
> -	xfs_trans_switch_context(tp, ntp);
> -
>  	/* move deferred ops over to the new tp */
>  	xfs_defer_move(ntp, tp);
>  
> @@ -1043,6 +1041,7 @@ xfs_trans_roll(
>  	 * locked be logged in the prior and the next transactions.
>  	 */
>  	tp = *tpp;
> +	xfs_trans_set_context(tp);

It took me a while to understand this, but it looks correct.

Can you add a comment here like:

	/*
	 * __xfs_trans_commit cleared the NOFS flag by calling into
	 * xfs_trans_free.  Set it again here before doing memory
	 * allocations.
	 */

I also think we'd do better without the xfs_trans_*context helpers
in their current form, but that's a separate issue I'll look into
myself.
