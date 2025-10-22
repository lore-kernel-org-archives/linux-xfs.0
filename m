Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ADF1F099C
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 04:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761108842; cv=none; b=TT+QAzpV/4OlBNCPmGaByZTtc2JWpSuJQ8FskhxTfPL8zEAlVmB9/6kqzzgX3S4tuvlESIaY3w67TJiuPVQdAzokHdoTRPoAaws9bmMEhGVCFZSXDVPrZo4uHZYZL1pHZ/pKRvvhxLACMZ9zosPvVgNt+hHb78+CNwsBD1s+2yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761108842; c=relaxed/simple;
	bh=AkX9Qqz1uOp2dCSl2dqW20yQcMsDZ8Cd2LTwSZ/qfSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmymujVZ5A0wDasj7RxRLGrOrhpwC/Gd1xbzm76IxjEb7mzLmJz1NefvSzbPaBgw+xWwsTXIijAQQyejdHyPEo6q//FXkWwMUQMymUOHtspwwPO8UzcoGrVZaZhyGoiw1La0mkceJ8Hq3wCvNv5VUV1a5doh/mJYLnsPwnL3wOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DNLR1dA0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DNLR1dA0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NpDI8v2eWk3M0h9JtU2/viD9Gi2xpfn/Y7CGH25Y5X0=; b=DNLR1dA06mCTFzEAvFngdEfGm2
	7nSJENmthM8xUx96xlMluLB47recIGvHFWY7Aa0ZDCqHCmjOdGEy++HFHCwiDrXMqM1+rNVrlwB6D
	fz5gxZpziG/6vMCgA4h2rNu4UNYd2DwjdRAEjDDyYOpXZ2zjwooTuTnSEgZNCMi6LRvChyFUkaDAq
	hzTW/NkXdLUlroE12dYk59oljU0I+3CijmOWe0hQwlEJMtvy8QnOmzKCgj/1GCQvj1pfkSMeVqaQj
	PpSwXILBdzhdS6DdSFcO1i3iJ/14+pGG1p26IssySg21/R1nixxRq9dtzpI49Z0UP4QtcINDcRHVR
	0R60Ng4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBQrH-00000001Twy-3Scw;
	Wed, 22 Oct 2025 04:53:59 +0000
Date: Tue, 21 Oct 2025 21:53:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over
 2x PAGE_SIZE.
Message-ID: <aPhjZ4sfHngyJRQK@infradead.org>
References: <20251021141744.1375627-1-lukas@herbolt.com>
 <20251021141744.1375627-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021141744.1375627-4-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This doesn't seem to relate to the other patch, so bundling it into a
single series is a but unusual, not to say slightly confusing.

On Tue, Oct 21, 2025 at 04:17:45PM +0200, Lukas Herbolt wrote:
> The krealloc prints out warning if allocation is bigger than 2x PAGE_SIZE,
> lets use kvrealloc for the memory allocation.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  fs/xfs/xfs_mount.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index dc32c5e34d817..e728e61c9325a 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -89,7 +89,7 @@ xfs_uuid_mount(
>  	}
>  
>  	if (hole < 0) {
> -		xfs_uuid_table = krealloc(xfs_uuid_table,
> +		xfs_uuid_table = kvrealloc(xfs_uuid_table,
>  			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
>  			GFP_KERNEL | __GFP_NOFAIL);
>  		hole = xfs_uuid_table_size++;

I agree with the low-level comments from Darrick and Dave.  But once
we start bikeshedding here, maybe do the grand bikeshedding and stop
using this stupid array and replace it with an xarray using XA_FLAGS_ALLOC
which takes care of all the memory allocations and even nicely frees them
on unmount?

I suspect we'd even end up with slightly less code that way, and
certainly better memory usage.

