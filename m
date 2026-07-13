Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5193DD51D;
	Mon, 13 Jul 2026 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933757; cv=none; b=Bqd/EkSAZDLEsTE899tNt7E0eoymFRZbhOm8MZpSRA/gDX3vOM1zzRYnnaYHh0W2oANzMC/4ciA46CVh2MBmoQtsykksnXwibt+n2XrG439fmQHWEbDp6jiFKTfoS7BTzMXICRfZI+o7t36at5o77mcaKWSi7ud+tnLg9SM4TAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933757; c=relaxed/simple;
	bh=PTH0jcCDIJ/iv8NtEspe3ysq1kimRd79WjKIOdXTad4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3Cgy7Rnz+Qlj2figBGNNh+efl0VH4qbuxpXor60ox/xA7Zx3BGDYdZ88FOtSM7y1Zw0MqNO3imx0ptVfp5pfbTMqHJob7FjnV2VOW6q6LFMUTBST/bdsCw9LZ4G89LMwKTrThSfPQAFzdmnEmWsbwUMdq1lNWzV9pwcgw8GC8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u0rFFxub; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u0rFFxub"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oxKo/+QzqK0iYuZ60u2gtmzxYhP6QOQw2aQXjUqHEVw=; b=u0rFFxub/6usWJjd4HqA2tM9XG
	yjv/zpk5VcDJ1dWWANA4AtU3J3u6JRhG+PZQQrySOGLKmcNJBoqf2f11hrybpE7yHmFZv0uXKGchT
	d48Z9Hymrzkl5nAjGhGaUJGi6k4unwtiktB4kFOJCj7xcmxjlf4sPghq0OZQ/WeUM0Qeer231Tc4x
	SwsPNhdDnLoPu3Vk3ILVlylMYBa0J0Lzf4w6P/WOERSc0nk5U6il0KqkwuHA0tDDXbmg+jVpOIvUW
	Eygd6IPNyauakQ8P518M8AF2wOb8T5UL630KUnF0wYLFPVL8yQFEN5zhOVytdeN2GzesU6NPOLd/c
	av4jv6Hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjCf5-00000008fi9-2Bgq;
	Mon, 13 Jul 2026 09:09:15 +0000
Date: Mon, 13 Jul 2026 02:09:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <alSrO3aDTuZkX0K9@infradead.org>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713035505.1635191-1-yun.zhou@windriver.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
> is cleared but only restored in the success path.  This leaves the
> error path without nofs protection, causing a circular lock dependency
> between xfs_nondir_ilock_class and fs_reclaim:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xfs_nondir_ilock_class);
>                                lock(fs_reclaim);
>                                lock(&xfs_nondir_ilock_class);
>   lock(fs_reclaim);
> 
> Fix this by moving xfs_trans_set_context() before the error check so
> that nofs context is always restored on the new transaction.
> 
> Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
> Fixes: a1ca658d649a ("xfs: fix incorrect context handling in xfs_trans_roll")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
>  fs/xfs/xfs_trans.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bfbd9f6f0df..1b36cf12d4e3 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1029,6 +1029,15 @@ xfs_trans_roll(
>  	 * duplicate transaction that gets returned.
>  	 */
>  	error = __xfs_trans_commit(tp, true);
> +
> +	tp = *tpp;
> +	/*
> +	 * __xfs_trans_commit cleared the NOFS flag by calling into
> +	 * xfs_trans_free.  Set it again here before doing memory
> +	 * allocations.
> +	 */
> +	xfs_trans_set_context(tp);

The tp assignment above now returns the incorrect transaction when
__xfs_trans_commit fails, so you can't do this.

Otherwise yes, this call should move up.  I don't really see how
it fixes the syzbot report, though.

