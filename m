Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93611442100
	for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2026 09:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787044998; cv=none; b=bk3okBOGXg184Q7MQjkKfoXzi6QmQYEOD9ebJ4HcbuWAXWO0PFJmf/r7Q9rz7Uil6fibMgbwofYB7CE3SK5j7NbL+sMASEaGcMeY4Ea/g+l8g5YcOEwHTFrYh87Lflmf7mc/99zjxGpj4nTtGkhp6CV/aixLvoGStXPNo5NMomg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787044998; c=relaxed/simple;
	bh=yqtSRGtf6MuatI6WtSH/MIhEhUa7cA7qeW8YVm/L81A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b7FkWTSx+RnXVokFPr/aPjN6GV3mT76gpHQr0bwZjKs7n3ny/jQL1JALrPh8vSxcC155znMSVSiChrvIvFeqtf+NugNG4ZQTrtwnnt9zbCKq0h7kEfCw9QOwBob0eY3QjDMy9y4GBMD9qHXxQDVPAD15/4C05Zwu7vdBb3t4h70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BD7u6bBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BD7u6bBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7A01F000E9;
	Tue, 18 Aug 2026 09:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787044997;
	bh=soxd0YEngNIm4n+fxiy4497Md9yGMHbZ3Di2vldKbpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BD7u6bBIyiaAASXat/GCJby5Tqq8AdgWsHBcP39ldYnNLkwYDX8z13y4a1sgfE3lu
	 PuYCKPKhoDf1RWOiXTKUOCYV3m2AfmZwi1CdtGHDRjIIoGeqtRcRU0D8N5ZBnQL9oQ
	 XagN/PqJk0sFB51O0gRM1SVsxGDyjjoExWFUhA8XWeE5gonzNEhgC75z/rUhAeoQGL
	 2m7KgfScovqq+Ks+J24izs6eAWhHyveYTeQNHMbPY5s0+duKB+FFI+SP47u63i+grT
	 YWP+5vyYED9TgdUsMVypzFwHjzbxCkl17no1Vo1yWW6+xK/5hQAMwO3tne4HtGe3Oe
	 5jtBMbgDiFKBQ==
Date: Tue, 18 Aug 2026 11:23:13 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: split an assert in xfs_trans_log_buf
Message-ID: <aoQkXOxqitR7KdcK@andromeda.toxiclabs.cc>
References: <20260720093612.2186703-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720093612.2186703-1-hch@lst.de>

On Mon, Jul 20, 2026 at 11:36:12AM +0200, Christoph Hellwig wrote:
> Split the "irst <= last && last < BBTOB(bp->b_length)" assert into two to
> make it clear which condition fired.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_trans_buf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 1e025848811a..a5d25b703dfc 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -521,7 +521,8 @@ xfs_trans_log_buf(
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
> -	ASSERT(first <= last && last < BBTOB(bp->b_length));
> +	ASSERT(first <= last);
> +	ASSERT(last < BBTOB(bp->b_length));
>  	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
>  
>  	xfs_trans_dirty_buf(tp, bp);

Ops, I think this fell through the cracks. Looks good though...

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> -- 
> 2.53.0
> 
