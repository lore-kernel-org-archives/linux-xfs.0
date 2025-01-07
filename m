Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C54926ADD
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232176; cv=none; b=W3kI4wCQhHf+8DsDR21CYyIdmL2fW3Fe/P9J4gg6A6CLNYeF0RBHTeHz29CgyLD51HtSPNyyj9xA4w4t+5OUvPf+GjG/kg3/zF0gjaJbPd5CAaj7ecnJbQKHUXRLQs89FS8+Qf34r2ehXa3cuzrHC4Bem0Cw1iD8zwfXa9c3CQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232176; c=relaxed/simple;
	bh=RJM8Ejkpkqv1mmrKRkEHRIrzKuiRBEVHBDN73ua744g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lq+zr2HjAscT9fHe2CphyB7mbHvnwUxzpRfZiDeA11xXnH2FlR51G6sqmM6di6XiaZekBrh7RwbcpktIcdsdnzwnvh8N76sLz/ZGrIG91TQdAFWE2eD0YypUBqGWnJQEEt6g2sF+PwXVrPH4ZHGPLCMsltu04c4svxnkDSDuULM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfAowz1H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfAowz1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3B9C4CED6;
	Tue,  7 Jan 2025 06:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736232175;
	bh=RJM8Ejkpkqv1mmrKRkEHRIrzKuiRBEVHBDN73ua744g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfAowz1HCOwxzyHeBDIAVZ/OmK7fiDST2vXGl7K0pcCGH/cfEDd4n6VOmOFAzoanw
	 nU5oveqNtDLNHQVUsM3XBPcLPgLbY3zg3Z4Af2W4HCLfTNBbNemB3anJG1eWLXpw8g
	 g2D4SyThYd+BOOQEXZLRbM6DsN3RPCuwUTea9OUNkmRc7WYz1K2EMj+8pyC190klIC
	 0t5yN8JoBU0C/vbpGpJNrzzjGJwwUKCP53LlSz7Ge7Ub1DqLbpsNZ4kXNUizj6h45d
	 2wODDZ2ZuB46nv7K43bP9YzR9s7VgyPhCcH/3AFCmyJNGqzRcSAnhYtorIrNImPpDG
	 XcYDavZ49w7mw==
Date: Mon, 6 Jan 2025 22:42:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] xfs: move invalidate_kernel_vmap_range to
 xfs_buf_ioend
Message-ID: <20250107064255.GB6174@frogsfrogsfrogs>
References: <20250106095613.847700-1-hch@lst.de>
 <20250106095613.847700-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106095613.847700-11-hch@lst.de>

On Mon, Jan 06, 2025 at 10:54:47AM +0100, Christoph Hellwig wrote:
> Invalidating cache lines can be fairly expensive, so don't do it
> in interrupt context.  Note that in practice very few setup will
> actually do anything here as virtually indexed caches are rather
> uncommon, but we might as well move the call to the proper place
> while touching this area.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 094f16457998..49df4adf0e98 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1365,6 +1365,9 @@ xfs_buf_ioend(
>  	trace_xfs_buf_iodone(bp, _RET_IP_);
>  
>  	if (bp->b_flags & XBF_READ) {
> +		if (!bp->b_error && xfs_buf_is_vmapped(bp))
> +			invalidate_kernel_vmap_range(bp->b_addr,
> +					xfs_buf_vmap_len(bp));
>  		if (!bp->b_error && bp->b_ops)
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
> @@ -1495,9 +1498,6 @@ xfs_buf_bio_end_io(
>  		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		xfs_buf_ioerror(bp, -EIO);
>  
> -	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
> -		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
> -
>  	xfs_buf_ioend_async(bp);
>  	bio_put(bio);
>  }
> -- 
> 2.45.2
> 
> 
