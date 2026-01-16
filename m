Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8854B29DB6C
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768572215; cv=none; b=EVpg7o3pYIIF80esgVZ9dyyblCqSQpGs59WbxbctnTPFjbzDgqnGUQALcURd6bwsha6bnJtOe++/vWIEUbASnkSN3BnD6JelkiqCMPa7nArzdOFI5jUcrGa+BgSwDCQ+i0QDS180AYbJebLiCKiGZWr0+VYd7Xa4N+T8GJA8Dew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768572215; c=relaxed/simple;
	bh=N/deEPuSU4SzYrT+s6jaediTtfzcclJGj6iDmI1txKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDiyyOzz7Ty6cjORFSZKBpxWKxJGwEdit1dRmF2L1dtgKg9L+0fqkadf1sgPJ8LK2fFEfTKp+z92QmXM+dptVfci8XYYwD/5JGgqURLEUsNpG/OKYqvCKBA3cmp6qMQ1n6cOiLRxnuX/GkGRT7gTjRl+5UPOwlrM9ROj1vEOv7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqpzgFlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqpzgFlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087E5C116C6;
	Fri, 16 Jan 2026 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768572215;
	bh=N/deEPuSU4SzYrT+s6jaediTtfzcclJGj6iDmI1txKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iqpzgFlROyxYrTkfH8WqtuOxWEO7jhXWkyBLsArIwcm0X1T8PoTqBYO5rYma+XaD+
	 6sJIY1HYSnV5r5BNzSaAHW3939gw6UPyCrM8nXDLwA0OgfDcgEUeoHTqg4WhrwmgQ3
	 XCPceWVLT9ky78E8L+uZL84Fs7OcfDtZrllCFK8gqGEKpCh+jPDwWMTiqApztyei1S
	 DpadPzHNu38Tr1tFHv01pG+p5KGrSbypiI4/AC0kWnQeaOUm/dC4BgbS251ofQuYMb
	 GGb9gLHZqI5h1CTjG7dclRN+BRHBa7t2jd1yB3Izy4usAUoYyT6hp3IFgvpQcgGO9S
	 f450ASWQkGtpA==
Date: Fri, 16 Jan 2026 15:03:30 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: add missing forward declaration in xfs_zones.h
Message-ID: <aWpFJ6hO-UMFpDlj@nidhogg.toxiclabs.cc>
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114065339.3392929-2-hch@lst.de>

On Wed, Jan 14, 2026 at 07:53:24AM +0100, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
> Add the missing forward declaration for struct blk_zone in xfs_zones.h.
> This avoids headaches with the order of header file inclusion to avoid
> compilation errors.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_zones.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> index 5fefd132e002..df10a34da71d 100644
> --- a/fs/xfs/libxfs/xfs_zones.h
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -3,6 +3,7 @@
>  #define _LIBXFS_ZONES_H
>  
>  struct xfs_rtgroup;
> +struct blk_zone;

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>  /*
>   * In order to guarantee forward progress for GC we need to reserve at least
> -- 
> 2.47.3
> 
> 
