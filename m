Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BE2848A7;
	Mon,  6 Apr 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775488871; cv=none; b=OeylKDMipWs+kDwkNgL4+70TzjjzlShNSlIPVYkj9sbPrpbFUn5lqvgeqsILgiyJjxQuNZMOicR7wnXdJoRRGYjZn+HfW/lvizEATMJC/bP1Z168Mghlmlfao/1tTjARCEM68iNhhk+udQ1vADnz4+rB3oj0YOhIF6cgHhLEEAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775488871; c=relaxed/simple;
	bh=AvF/hcKT9gwM1FlTC5o4c0qsrDGRi6VLERtn07f5HOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxlHOjxyuHEKBEdMZ1Oosb4a3OF1rICN6/zc61juI1+SrH3fRqGSqFG42eEm18xV3piNoTap+PQbVpT7MvvgXLLhiy88lUWI783XOjIX8Op7o0uhxUrSG5U9hkImxyef03PZh8rq51yV8tz0AhPscTgAx6dTABNYeXWKj0b15ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgJDnRBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgJDnRBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE825C4CEF7;
	Mon,  6 Apr 2026 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775488870;
	bh=AvF/hcKT9gwM1FlTC5o4c0qsrDGRi6VLERtn07f5HOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tgJDnRBVtaS5yu+3fcJ/Fq1l1cxAz9CIbQ5csAumu8bM1hExFW7e9E6M+Og8eNGts
	 hO5JhCLzRhB4hdUxEouiSyvTtIiOluYR/x6kFK4/0IpDVwu/IA07doZVhoniet57eu
	 QWdRDe8kX1Kwd0IVAqenUKrKsa6e15vPE5V4VHPMzMGSa/O9q/xPOjnIakeAgDEv+4
	 dGOuGHiB4rQh9tMnVS79cR86EGNPzSPxfVoImmffC1TRxViG8Xl3eKAHFVl0MFJQlT
	 H0yhKX2PF/AmNYAFz4JHBj9Izqv2AwbJMc4GYhNtDw1BCamfGW6w3jRuSU6SF/x/2V
	 6W9pKTQOFCNbA==
Date: Mon, 6 Apr 2026 08:21:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: check directory data block header padding in scrub
Message-ID: <20260406152110.GA1048989@frogsfrogsfrogs>
References: <20260404125032.37693-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404125032.37693-2-ytohnuki@amazon.com>

On Sat, Apr 04, 2026 at 01:50:33PM +0100, Yuto Ohnuki wrote:
> The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and
> should always be zero. The scrub code already checks the pad field for
> leaf and free block headers but was missing the same check for data
> block headers. Add the missing check.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/scrub/dir.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e09724cd3725..2db4def3358c 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -492,7 +492,12 @@ xchk_directory_data_bestfree(
>  		goto out;
>  	xchk_buffer_recheck(sc, bp);
>  
> -	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */

But where do we set xfs_dir3_data_hdr.pad to zero?  xfs_dir3_data_init
does not seem to do this...

> +	if (xfs_has_crc(sc->mp)) {
> +		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
> +
> +		if (hdr3->pad != cpu_to_be32(0))
> +			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);

...and even if there is code that does the zero-initialization, it's
possible that old kernels wrote out garbage in the pad field and were
quite ok with that.  At best you can set XFS_SCRUB_OFLAG_PREEN to
indicate that this kernel should clean it out.

(For that you'd also want to add a new xchk_fblock_set_corrupt helper to
record which block tripped the "optimization possible" message.)

--D

> +	}
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out_buf;
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
