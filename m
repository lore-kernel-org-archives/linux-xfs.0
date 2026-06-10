Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D591406800;
	Wed, 10 Jun 2026 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781094530; cv=none; b=TAbqTYJpVBsmetmXoKqKxaz0AQGhsYdNQkRg9OeFrLG7WnR+GBcDLmgfnt8GB8xZt0W57DDyphsytPBXbmyb69BmChVCsCJWcCRQI0afzVhpOlpXjFhfZ5Hy5KgLezlWZViTdd5L6HzGa+xD2pz00Qb3uHqx/ooHrBqd8tauEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781094530; c=relaxed/simple;
	bh=fVTHwkRKrZRnkusl0GK5frWeaPUrXO9Ick6ah3uYVhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAshp7Yf7UBUzjkQS34+/LD8MXWOvAy+CJYkjgNWpxgko53G/7YpXWQ51OcyM624VFe9tNeaf5M7k+KxkBj3/lcJNJTf5SWOm8T4xqYk9JhyFkFPccavtS0WPg70Y4bZfZAoRn7ijNdXN6pjvf7RGYf29fO6LGtxWNWMSokdtrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tOXKq2cH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tOXKq2cH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2ToNO6+ATDc257fO/bBYC+jpArrFT+Bt/uAFuVJei7c=; b=tOXKq2cHdUXT3wygWOYTJqkX0z
	YMmEV6ir3yD0EKdjfsgtUXwley7fFganK0E6mlzbiGHop4ry3cJtk09m/qs0bHu1vv63OmLDbN7Ph
	QkirKS8uEyu3jq8p9Vi0H9UKjZSz3Jl0HRUkVujGKqgABh0YAI6XA3tBdtQ5efcwcRCtwS7+GUK4V
	WDF35vG6Ih4hpwUJfzw9PzJ8bio0IxTBT2d50LYYRIsvbdZAbFVah4HXdUI3DVamOGWPGeGZo3oOu
	/h82bE5siyPof2UzggxuCHJy7ao3vXFZ6gQAB8yk82zD+RHY8ddrKFA4POlxkyzWOU9niujUQuDVE
	nRxsL1Ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXI35-00000007dh6-3QAL;
	Wed, 10 Jun 2026 12:28:47 +0000
Date: Wed, 10 Jun 2026 05:28:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: cem@kernel.org, djwong@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com, zhanjun@uniontech.com, gouhaojake@163.com,
	gouhao@unionntech.com
Subject: Re: [PATCH] xfs: fix use-after-free of buf_log_item in
 xlog_cil_build_lv_chain
Message-ID: <ailYf4UzSLplTR3f@infradead.org>
References: <20260604094233.8492-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604094233.8492-1-gouhao@uniontech.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 04, 2026 at 05:42:33PM +0800, Gou Hao wrote:
> xfs_buf_item_done() frees the buf_item via xfs_buf_item_relse() but
> does not remove the item from the CIL log_items list (li_cil). When the
> item is freed through an error/shutdown/abort path before the CIL push
> worker processes it, the freed memory remains linked in ctx->log_items.
> 
> The CIL push worker in xlog_cil_build_lv_chain() then dereferences
> the freed object via item->li_lv, triggering a KASAN slab-use-after-free.
> For details, see Link[1].

There's no reproducer there.  Do you have a local one?

> Add down_read() on xc_ctx_lock before list_del_init() in
> xfs_buf_item_done() to safely remove the item from the CIL list.  This
> uses the same lock that protects CIL list operations: insertions are
> done under xc_ctx_lock read-side (xlog_cil_insert_items) and removals
> under write-side (xlog_cil_build_lv_chain).  The read lock is safe here
> because xfs_buf_item_done() is always called in process context (workqueue
> or direct I/O wait) and cannot deadlock with the CIL push worker which
> holds the write lock during xlog_cil_build_lv_chain - the worker does not
> trigger metadata buffer I/O that would call xfs_buf_item_done().

This looks like a more general issue as we should never free anything
that is still on the CIL. I.e. it looks like we have even more issues
with the buf item state machine here :(

> 
> Reported-by: syzbot+598a791b31c498b63c6b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a069a95.050a0220.2921a.0006.GAE@google.com/T/ [1]
> Fixes: 816c330b605c ("xfs: factor out stale buffer item completion")
> Cc: stable@vger.kernel.org
> Suggested-by: Zhan Jun <zhanjun@uniontech.com>
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> ---
>  fs/xfs/xfs_buf_item.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8487635579e5..75529dfd1170 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1067,6 +1067,11 @@ void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> +	if (bp->b_log_item->bli_item.li_log->l_cilp) {
> +		down_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
> +		list_del_init(&bp->b_log_item->bli_item.li_cil);
> +		up_read(&bp->b_log_item->bli_item.li_log->l_cilp->xc_ctx_lock);
> +	}
>  	/*
>  	 * If we are forcibly shutting down, this may well be off the AIL
>  	 * already. That's because we simulate the log-committed callbacks to
> -- 
> 2.20.1
> 
> 
---end quoted text---
