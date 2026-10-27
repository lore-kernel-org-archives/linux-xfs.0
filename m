Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793116249;
	b=XHZlh/eY12YXbamxnNMSbalxhDN0LI7QJpOQOz2VsSo5KcKvk9rjzs3xDAYX93NIBAa4
	 ovco6+8xVbtfGbgZmo4H9QfCbFlTDgm5z6f3uK9CABwvCra6HcVnLKr6Bfd0Okd6Da0Sp
	 wSeyKP1ssLv+xbF2mB8NwW6JinivBGNAFZsvVEY7vM7K6jk7l1ifoF9NQQIR9tYxUGCah
	 CXMkSlxN/HxQRTOjBCwmHBBdLWk/83Hp9WEvjKhB4OuLxrwXaGYvCblsKGQQvzGXjhKOJ
	 6jG8GTo9mm8NVGsnoJnitMriG7KBC3Ci0fgrv35M6fDV32kRhpx+f2/XDna1n7zZezw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793116249;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=m+Ex2ylCXH8pY+H401VFgKf2jxaf4Osd5Mhr8rVW5MY=;
	b=lLjlqspKTZFqKtq6FJDa0wdDQjJzmesW+jytXn4A7TYKSR+nM3p2M6dI/xky5lGGIMr8
	 bhd0o7MfMibd/6CFjyZLJRFcssX1XJTaftSLdWFI3XihAU1qWMLUaIDivEPosD5Px2Cgb
	 HcTsQ7Q1PgbdKspeC3RGKLEO760lYINNaNJv57KtqVYmpUtdH/5uh/LN6bEx3B4HSBDcx
	 dj6u5oZCHxS6B9IDii9Z+RnaSFh1FkJCCD8bdU7hjNz5GWMEO776sf317ZcSiDkzHUkis
	 Osm0hCEgS9SuymcSFSyOZzBYN3ZdjNZfooPXEzaxD5qFHJMFtdup9KzZUAxbrekzFYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gs9f67Ne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05380606E6C0;
	Tue, 27 Oct 2026 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gs9f67Ne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A1D1F031EF;
	Tue, 27 Oct 2026 15:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116248;
	bh=m+Ex2ylCXH8pY+H401VFgKf2jxaf4Osd5Mhr8rVW5MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gs9f67NeA0yVm1F6RPLTncAyE+obVjwwWe8baqzKIa+dFyX5ceObJCShr9KUAQGVy
	 MWWy4zQp1GdaJQuUyEdPFBPqZHPjn+JvlmEF4if6BgNaZqNEyj0DEuVhJwCYW/Z3TX
	 iUy5i0srugq5eNcsIUdfrcWAYlMpZeAB1qoGfyC98uoFgY/6xHeaHLIlfFF+D5f0mt
	 6W2E0jQ+Ve4gg0ZTZWYaJuCWdulQApwf7hnqKch3CEmIlAY5mJjNNbOJa78XJO1H9R
	 MO15BGnN5BS9yRNw9yMXs24RlYV9c2A8PjCm0u4Jkvium64LEf7mNadImFeEaC9cST
	 7xZGKJxiiC7kg==
Date: Tue, 27 Oct 2026 16:50:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilfred Mallawa <wilfred.mallawa@wdc.com>
Subject: Re: [PATCH] xfs: fix unwind handling during xfs_mount_sysfs_init()
Message-ID: <auDFY4Lkxs76I_F5@cronus.toxiclabs.cc>
References: <20261026053454.987673-2-wilfred.opensource@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026053454.987673-2-wilfred.opensource@gmail.com>

On Mon, Oct 26, 2026 at 03:34:55PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> The goto for failing to setup /error/metadata jumps to the wrong place
> in xfs_mount_sysfs_init(). Fix it.
> 
> Fixes: a9a7b9e8686d ("xfs: add support for lazy direct read bounce buffering")
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> ---
>  fs/xfs/xfs_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index e77917ac179d..4a6a8c92c3a1 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -906,7 +906,7 @@ xfs_mount_sysfs_init(
>  				"metadata", &mp->m_error_meta_kobj,
>  				xfs_error_meta_init);
>  	if (error)
> -		goto out_remove_csum_dir;
> +		goto out_remove_error_dir;

Hmm. I think this is wrong. Don't we need to remove the fail_at_unmount
file *before* removing the kobject?

So, we'd need to actually call sysfs_remove_file() before actually
deleting the m_error_kobj.

I am honestly not sure if kobject_del would clean up any attributes
added there, but I think that's the right thing to do here?!

Cheers.

>  
>  	return 0;
>  
> -- 
> 2.56.0
> 
> 
