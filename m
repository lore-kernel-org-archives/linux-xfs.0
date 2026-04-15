Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36CE30DED1;
	Wed, 15 Apr 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266436; cv=none; b=hN0aTHgXz9VPJ+TqLU1aCDWO1/K36DDvBfOSP51w8HUX5ehTNfzyZ73DcuKmO1efnVeL8+sLYBfRjOtrQAAq0MEtD+ywPKybp11e17pjDqgQ6oJRGAh+v4KiexA7zeTiI2XIo7bL5W3HUhd+D5P/oGDPAorFuVYvr3piPOMPsbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266436; c=relaxed/simple;
	bh=yfTslpqTQOQXpmZjWqpZ+Vp3SA2R8Q+m/vg5qSq/56g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsZ2gonHdp2GuJIb7aUbBLEOwb+O2HeLm5eoSoZQWV8cITEDT1OS4R73syPbN0ryrdjZuNcnWZfK6cyP5ZdH0elhTVqseZ4g2tZa13XANT4/9/4DPwQp7aiGU5WcHYwf93fc4DLHVnwAkBIQy0DpTPvmCVN6RaZG0PRLM6TZoxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2WUY6j9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2WUY6j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E72C19424;
	Wed, 15 Apr 2026 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266436;
	bh=yfTslpqTQOQXpmZjWqpZ+Vp3SA2R8Q+m/vg5qSq/56g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f2WUY6j9Mu3PgETgMBKKTzUE3QfPbCbTPO05Cdp30meT+vLs61TV5dGkuVExQEDIv
	 ZyMVbaBLRuXohCnfUxW0UZEjudwiwyz7HpSS+2iyMf2xg3TOq44Xm4uLV7iOWb4dS9
	 tlkmQ2/Cb1rdeTmkJO/cHPkv2CWhGzWidnnPI5XYm0/eJOvlSaG/xZ1aCQ/K9LdI1y
	 F+OO6XMcceLXHGCZENXKijVlSKHjukkspU4fnId5P5dBwrzR2aRc9In9ZGUMgE01nQ
	 AS2YiEQHP7wXNABAZTfzt10Vatt20TAHSkTCaHWTx+b/j5qpWspB7XuqVaw2CCM/kz
	 mg1gFQ3qcHSRQ==
Date: Wed, 15 Apr 2026 08:20:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] xfs: check da node block pad field during scrub
Message-ID: <20260415152035.GC114209@frogsfrogsfrogs>
References: <20260410170614.8075-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410170614.8075-2-ytohnuki@amazon.com>

On Fri, Apr 10, 2026 at 06:06:15PM +0100, Yuto Ohnuki wrote:
> The da node block header (xfs_da3_node_hdr) contains a __pad32 field
> that should always be zero. Add a check for this during directory and
> attribute btree scrubbing.
> 
> Since old kernels may have written non-zero padding without issues, flag
> this as an optimization opportunity (preen) rather than corruption.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Should the dabtree write verifier also set __pad32 to zero, in case the
kernel encounters a dabtree block writen out before the memset was added
to xfs_da3_node_create in commit a45086e27dfa21 ("xfs: validate metadata
LSNs against log on v5 superblocks")?

This change on its own is correct though, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> Changes in v3:
> - Drop unnecessary be32_to_cpu() on comparison to zero.
> - Link to v2: https://lore.kernel.org/all/20260408174033.4165-2-ytohnuki@amazon.com/
> Changes in v2:
> - Use xchk_da_set_preen instead of xchk_da_set_corrupt since
>   old kernels may have written non-zero padding without issues.
> - Link to v1: https://lore.kernel.org/all/20260404143043.65268-2-ytohnuki@amazon.com/
> ---
>  fs/xfs/scrub/dabtree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index 1a71d36898b1..c2d6ad59d03e 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -454,7 +454,12 @@ xchk_da_btree_block(
>  			}
>  		}
>  
> -		/* XXX: Check hdr3.pad32 once we know how to fix it. */
> +		if (xfs_has_crc(ip->i_mount)) {
> +			struct xfs_da3_node_hdr *nodehdr3 = blk->bp->b_addr;
> +
> +			if (nodehdr3->__pad32)
> +				xchk_da_set_preen(ds, level);
> +		}
>  		break;
>  	default:
>  		xchk_da_set_corrupt(ds, level);
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
