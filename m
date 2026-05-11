Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3313BA25F;
	Mon, 11 May 2026 08:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778489882; cv=none; b=oscULUIiXm5VDOYo/y8JV8dNefiVsnw1J/jeWEovQMmk2MzEJtv9zbqzwurlrMZCocZNKOS8x9WcHQ6Ytze0VeTipIkGg2iWai/1kK7MEEw2P5som3WXsYUNKvkxoN7zORzO32rEvjtUzETRW1i9Cya/jJiHbp2gXhO+KfZPGX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778489882; c=relaxed/simple;
	bh=zQB6MpAt59FJ1txdrRzvc/fWJEFs2ql5bw3G1xw+9u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwuIrAYDLt27ix0PNpGqLt1OJ1+BUINDGPO0YAYkOUX+jsHfdMf0pKa2Vt4C9Z961O7dTYiY5rbRBcnCVLTCU7ITIPruWeHTJpPMco7Up3eTJRhs/J4F4xUW+gQgSS038oemNT5fImCVbXRac/EUB6ZksACYrt54QMNIPgJwNxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3662A68BEB; Mon, 11 May 2026 10:57:58 +0200 (CEST)
Date: Mon, 11 May 2026 10:57:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chi Zhiling <chizhiling@163.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
	hch@lst.de, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH] iomap: add dirty page control to iomap_zero_iter
Message-ID: <20260511085757.GB1186@lst.de>
References: <20260510064737.437597-1-chizhiling@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510064737.437597-1-chizhiling@163.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, May 10, 2026 at 02:47:37PM +0800, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> This patch prepares the iomap framework for exFAT's upcoming migration to
> iomap. During testing of the exFAT iomap branch with xfstests generic/299
> on a VM with 8GB RAM and a 40GB disk, system unresponsiveness was observed.
> 
> iomap_zero_iter() lacked dirty page throttling, which could cause memory
> pressure when exFAT's valid_size mechanism triggers large-scale zeroing
> operations during writes beyond valid_size.
> 
> Align iomap_zero_iter() with iomap_write_iter() by adding
> balance_dirty_pages_ratelimited() to throttle dirty page generation during
> large zeroing operations. Also add cond_resched() to provide voluntary
> rescheduling points during long-running loops.

The balance_dirty_pages_ratelimited looks good.  Now with lazy preempt
we really should not need more cond_resched calls, though.

> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> ---
> 
> exFAT iomap migration:
> https://lore.kernel.org/linux-fsdevel/20260507124238.7313-1-linkinjeon@kernel.org/
> 
>  fs/iomap/buffered-io.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d7b648421a70..f6955786c8ad 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1543,6 +1543,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  		size_t offset;
>  		bool ret;
>  
> +		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
> +
>  		bytes = min_t(u64, SIZE_MAX, bytes);
>  		status = iomap_write_begin(iter, write_ops, &folio, &offset,
>  				&bytes);
> @@ -1571,6 +1573,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  		if (WARN_ON_ONCE(!ret))
>  			return -EIO;
>  
> +		cond_resched();
> +
>  		status = iomap_iter_advance(iter, bytes);
>  		if (status)
>  			break;
> -- 
> 2.43.0
---end quoted text---
