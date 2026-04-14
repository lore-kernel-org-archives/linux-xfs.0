Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122A635A952;
	Tue, 14 Apr 2026 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776163403; cv=none; b=BegQUNRad11dDOJhQOtyxOxMY1w8ejimKRjh26Dmdpd7UJxmHM4r8N1b/sYQl766g5MGWirBeZcL9GF+gf9F7bQxIgRsmX9anKNCb2pE3hXC1T3mSzMzwlXpSaxVplr2Lweyx71nPQKv5MFj7ElIe+wRKkDGlv5HAMS7+NAyc/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776163403; c=relaxed/simple;
	bh=aHBw8r9UG38xqO3orablJh4axD69BNCPvGseEiOj8Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lM4jifpPq8/3KrSM6PPr3r5JvDF8cN6pCW1eWfUvdNwJBSYtu1nZM+qnK8HvEk8SAc+3IKsaeElA55uPRq7NMy8MxDQwPyoRm/P/9p8HGLa78gqenFSsFMPoTH2VSzOXERclECzCJPdCvz8zgzKZvvHMva9v/u0FQ7CrMmEyXJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuUiwer5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuUiwer5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28C4C19425;
	Tue, 14 Apr 2026 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163402;
	bh=aHBw8r9UG38xqO3orablJh4axD69BNCPvGseEiOj8Uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NuUiwer5xRnY8xGT8HCUG6BFIdVkr1E3uadTG+y5mHHWjWch69XqmylqHes6y2a0+
	 tdDiiXiA0lNUwQMWBvFnzdrwGG7of/UQp+LkPJJJ0Z3I47JimhJJuCIVhrq/G6Iun0
	 7Z5k5tqGWmLgCPC0bahyMzTcKU5KNKulXXTrcaNkOBy+pTUb0YADO37WYcQRa/sBfP
	 d1PYLOg+QR0xybI4uM6YHt3PKLQ+4MqL51CWgiDcF9CmpX+IzDntzgjsn1VBaSh+ID
	 IfyZ0ZB3R3n9/sxatd0q7ImUksXAXZXbKFVoNRDHGBK+6/7AaEsktEVujsA7BVkOeq
	 Uco7+LuGs8yKA==
Date: Tue, 14 Apr 2026 12:43:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Wilfred Mallawa <wilfred.opensource@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Damien Le Moal <dlemoal@kernel.org>, Alistair Francis <alistair.francis@wdc.com>, 
	Hans Holmberg <hans.holmberg@wdc.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix memory leak on error in xfs_alloc_zone_info()
Message-ID: <ad4Z-yHwPs9ZDuI7@nidhogg.toxiclabs.cc>
References: <20260414034149.1116281-3-wilfred.opensource@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414034149.1116281-3-wilfred.opensource@gmail.com>

On Tue, Apr 14, 2026 at 01:41:51PM +1000, Wilfred Mallawa wrote:
> From: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> 
> Currently, the 0th index of the zi_used_bucket_bitmap array is not freed on
> error due to the pre-decrement then evaluate semantic of this while loop used
> in xfs_alloc_zone_info(). Fix it by allowing for the i == 0 case to be covered.
> 
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Cc: stable@vger.kernel.org

Code looks good.

After fixing Damien's suggestions, feel free to add:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index a851b98143c0..c64f9ab743a6 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1217,7 +1217,7 @@ xfs_alloc_zone_info(
>  	return zi;
>  
>  out_free_bitmaps:
> -	while (--i > 0)
> +	while (--i >= 0)
>  		kvfree(zi->zi_used_bucket_bitmap[i]);
>  	kfree(zi);
>  	return NULL;
> -- 
> 2.53.0
> 
> 
