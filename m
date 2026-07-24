Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075C74418D7
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912598; cv=none; b=bzbygUZxAvOGQfBmTA89AjTzEhiiRkhhIVX/J9m+P/qQu3rzqr8e211YpbeBLQyh+DmE4EHiuqj/c8NJvOWhtwNuJiJv1MpP0kGymGldie6eHrFzMnpftCxmht3tCUU0sMhJE2nMFlcIdzsAynaQ0ehHMQIzlZR7VI84COBIdHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912598; c=relaxed/simple;
	bh=c/QfIpbMSXkLn5nuCIDZT2BEwsJxBnLfbwQ0oZC3NIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDDnVlchKV5CXuJtURBQL5PnvvIgAvWpvt7uyrSlEdnXMjXrENj0lhDwoEPnbwY/S54l9m6IDcJyj0o0E54lUvHtl1B5t3aQ60OVTk9GVN/4MVRcdMlkZ/JgowEHIEJv47TmSbuKAAmdqDkjDDCxma8dD3lBUR0vq0572sAVcGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=be6ks+Jz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="be6ks+Jz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 82DB91F000E9;
	Fri, 24 Jul 2026 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912596;
	bh=WSAXiVQiuB6YwsKxyYoaubxjgVXRB0JPLxw6XAjxV64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=be6ks+JzVOq1aXkfP4Ox3jS/mOBFMwjjULamXz+Og+RQ4MnYiL3TbrbFbUSMODUFc
	 e1oatFT7y2kfAw7fQCCCP6wZO8mGpSjS/9LKos12TKB2Q5IYW2oscJ77NmK+v0cfSG
	 HNpCMhq3BuPs5vHBXwzfRvs5jBKoz4yDKehAsJdw8EUV7k6rtx6NRHtCNfWlMN70xw
	 eX+YtwwmYWzkGCoqufd61i3JUAzmUNEfZnbdL4esS86dwhWyraOa2m+LM+91X95uvB
	 Ki2TnX3HBvVDCGa8xwB5sPHqHmxGbO8P7U3oS3H2DuK3MGhknf70s5vwyClkUMzME+
	 xhhmhWeWLIvnw==
Date: Fri, 24 Jul 2026 10:03:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: add lockless xfs_buf_readahead_map fast path
Message-ID: <20260724170316.GZ2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-13-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-13-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:05PM +0200, Christoph Hellwig wrote:
> Readahead currently always locks the buffer, which can cause contention
> with actual users of the buffer.  Add a fast path without taking any
> locks if the buffer is uptodate and not stale.

So we're trying to cut down on b_sema contention for detecting the case
where the buffer is already uptodate?  And I guess the idea here is that
if you had per-fsblock filesystem metadata, you'd want to be able to
readahead that metadata into memory during setup for file IO without
so much locking?

Sounds reasonable to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f5701f74061f..2e498e9e05e9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -756,13 +756,23 @@ xfs_buf_readahead_map(
>  
>  	if (xfs_find_get_buf(target, map, nmaps, flags, &bp))
>  		return;
> -	if (xfs_buf_find_lock(bp, XBF_TRYLOCK))
> +
> +	/*
> +	 * Do a lockless fast path check for a valid uptodate buffer and avoid
> +	 * locking entirely in this case.
> +	 */
> +	if ((READ_ONCE(bp->b_flags) & (XBF_DONE | XBF_STALE)) == XBF_DONE)
>  		goto out_rele;
>  
> -	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
> -	if (bp->b_flags & XBF_DONE)
> +	/* Otherwise lock the buffer to stabilize the state */
> +	if (!xfs_buf_trylock(bp))
> +		goto out_rele;
> +
> +	/* Let the actual reader deal with stale buffers. */
> +	if (bp->b_flags & (XBF_STALE | XBF_DONE))
>  		goto out_unlock;
>  
> +	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
>  	XFS_STATS_INC(target->bt_mount, xb_get_read);
>  	bp->b_ops = ops;
>  	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
> -- 
> 2.53.0
> 
> 
