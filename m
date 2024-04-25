Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297014A0BF
	for <linux-xfs@vger.kernel.org>; Thu, 25 Apr 2024 16:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714061872; cv=none; b=gb1lP0ziWRk+BsnE4t3QFX4Dv+M6YJVve4Tq6Vwfge6hetfuP6yjm5gZYRNE/ky9LnN4gj9qnGczBOdJbkxo59D+G2bHp7D+vVttWyWp+ljiw+RJObRyd0tZJTAaUPg2p7LxtnfyCFbEuBI/cM4+N3C/mB021+vCL6Z3pHkZfdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714061872; c=relaxed/simple;
	bh=6Bb//jonHEbApt0tVwNci0mx9qhg0wmS4YQAKEypkCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H5k73TYKGGNWYEZu/8XjVr1sBa8m3rHkQB7W29cdf3DYUX3sQE1BIQxfYMNIIZxFInJ6gjyffKvShmTaqLKZGlo+2gbfatTICx4kBaaE8nhKxrKBjg6XKbDteNbLy5zD3NZHKsVOy/l3tfQFll/odFNU0dNUVRudKS5L7K2DHmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKffPwo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKffPwo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E0DC113CC;
	Thu, 25 Apr 2024 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714061871;
	bh=6Bb//jonHEbApt0tVwNci0mx9qhg0wmS4YQAKEypkCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vKffPwo5fVxk7WvyfDjiiijBhba3DY1rzHlBGODni828PjbnpwZvZdlHdmub4EUju
	 58/PhWh1CAkkfADAWDRr5wlO4u5jcqhZT42NDCG0uK8WdpzqM1BHoCszj1CHD8DXOs
	 pw2S+xJ6q0t20joUScInSsWRgBbX+IdkZP+No7Jm2dy6m8oZbpetdSK3kZAE/vncrJ
	 DW/oXAkohss3rzEPWkhaNPArsQBhCaAo5TB/wqKeatsB+0SFSYXSyO95GzdR2zUqA0
	 UZ2NK5Fp9pMHKBtMnOuQpzR8PGbbyxR5zvW+zGtJbp+TRA3IGyak8k2oPs4zL5mRgQ
	 V7NsHWTUG1MRg==
Date: Thu, 25 Apr 2024 09:17:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: Clear W=1 warning in xfs_iwalk_run_callbacks():
Message-ID: <20240425161751.GZ360919@frogsfrogsfrogs>
References: <20240425120846.707829-1-john.g.garry@oracle.com>
 <20240425120846.707829-2-john.g.garry@oracle.com>
 <ZipJ4P7QDK9dZlyn@infradead.org>
 <01b8050a-b564-4843-8fec-dfa40489aaf4@oracle.com>
 <Zipa2CadmKMlERYW@infradead.org>
 <9a0a308d-ecd3-43eb-9ac0-aea111d04e9e@oracle.com>
 <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99a9fa0-e5ab-4bbf-b639-f4364e6b7efe@oracle.com>

On Thu, Apr 25, 2024 at 04:37:25PM +0100, John Garry wrote:
> On 25/04/2024 14:33, John Garry wrote:
> > > 
> > > (it also wasn't in the original patch and only got added working around
> > > some debug warnings)
> > 
> > Fine, I'll look to remove those ones as well, which I think is possible
> > with the same method you suggest.
> 
> It's a bit messy, as xfs_buf.b_addr is a void *:
> 
> From 1181afdac3d61b79813381d308b9ab2ebe30abca Mon Sep 17 00:00:00 2001
> From: John Garry <john.g.garry@oracle.com>
> Date: Thu, 25 Apr 2024 16:23:49 +0100
> Subject: [PATCH] xfs: Stop using __maybe_unused in xfs_alloc.c
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9da52e92172a..5d84a97b4971 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1008,13 +1008,13 @@ xfs_alloc_cur_finish(
>  	struct xfs_alloc_arg	*args,
>  	struct xfs_alloc_cur	*acur)
>  {
> -	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;

If you surround this declaration with #ifdef DEBUG, will the warning go
away...

>  	int			error;
> 
>  	ASSERT(acur->cnt && acur->bnolt);
>  	ASSERT(acur->bno >= acur->rec_bno);
>  	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
> -	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
> +	ASSERT(acur->rec_bno + acur->rec_len <=
> +		be32_to_cpu(((struct xfs_agf *)args->agbp->b_addr)->agf_length));

...without the need for this?

--D

> 
>  	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
>  				      acur->rec_len, acur->bno, acur->len, 0);
> @@ -1217,7 +1217,7 @@ STATIC int			/* error */
>  xfs_alloc_ag_vextent_exact(
>  	xfs_alloc_arg_t	*args)	/* allocation argument structure */
>  {
> -	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
> +	struct xfs_buf	*agbp = args->agbp;
>  	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
>  	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
>  	int		error;
> @@ -1234,8 +1234,7 @@ xfs_alloc_ag_vextent_exact(
>  	/*
>  	 * Allocate/initialize a cursor for the by-number freespace btree.
>  	 */
> -	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, args->agbp,
> -					  args->pag);
> +	bno_cur = xfs_bnobt_init_cursor(args->mp, args->tp, agbp, args->pag);
> 
>  	/*
>  	 * Lookup bno and minlen in the btree (minlen is irrelevant, really).
> @@ -1295,9 +1294,9 @@ xfs_alloc_ag_vextent_exact(
>  	 * We are allocating agbno for args->len
>  	 * Allocate/initialize a cursor for the by-size btree.
>  	 */
> -	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
> -					args->pag);
> -	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
> +	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, agbp, args->pag);
> +	ASSERT(args->agbno + args->len <=
> +		be32_to_cpu(((struct xfs_agf *)agbp->b_addr)->agf_length));
>  	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
>  				      args->len, XFSA_FIXUP_BNO_OK);
>  	if (error) {
> -- 
> 2.35.3
> 
> 
> ---
> 
> There's a few ways to improve this, like make xfs_buf.b_addr a union, but I
> am not sure if it is worth it.
> 
> 
