Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58FD421229
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 06:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505178; cv=none; b=F4ovX35523T5AEY0gPerpQ+siDSzM7OtjcIvKUiADdGQtydEsTfJHT0pkEqru5f+4OGKSbnATVQrxynZ68LnYXigSwpur8OcgFRrwwtN08dGOsoOPPJBW2I5XajczTVzenfNRiw1Zop89ipSda9w+fgf32hxANbcWAKplaI2uoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505178; c=relaxed/simple;
	bh=UgWEn5C/9wwkNNqNF5Kxnn7LXqFyt0ndHubqdyb+NIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqcN9w0A8qLFwU/2nQemdi+1uAhe0LL6mnEsteWzEV2FDcSKVnLp70sNWlSUGqppqVULsegaGCDzU+ffOXPq6x/805PCb32/b5WweZHT4YkOCF/9liRCBgloG8ZmcvjKV3KrZOth1Sjdw5feOWLyMVe5d9YhUXkD22RkoECn36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jA07yMe+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jA07yMe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB6D1F00A3D;
	Fri,  4 Sep 2026 06:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505177;
	bh=XLUv03jgRfcsVHdAj++8mhlsGOlR0hxTv7FISZkrlHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jA07yMe+HnJN1fsdiT/CuI8s3IFiryyZ9JH//dQKewv5k5jFLm8h+2qXUgkDq0LZ8
	 DnSOf6CHX4nUKJmiAa8TF8PxCOYTgbg2F1596PCWTe49zafUcmV59xx9BZc8teiWNL
	 FHWU2/VI00Cym7pyElkGRKKpXL7ty4TjcLNnw8XH6db+oqfYjY8Cvd5FL1Ffi+B24B
	 /GeSk3hXsdzqG9bpoUWejYskfACQ3IXUyPKILzhx1gwPOobzWXAhHWAV3oZzlnBRy6
	 arrQI5BdlbnV/3bcUv619lGUtnSsCNHOvBPqwX8Q/H3bv2bjYoLIxcv1w1IYRQpuNz
	 wlOFHzjSrEeaw==
Date: Fri, 4 Sep 2026 08:59:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: remove redundant function declaration
Message-ID: <appsTx-9mVObXJyE@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312582.1198660.18019501735306969631.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312582.1198660.18019501735306969631.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:26:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove this useless code.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/dabtree.h |    2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
> index de291e3b77dd8e..d654c125feb4d8 100644
> --- a/fs/xfs/scrub/dabtree.h
> +++ b/fs/xfs/scrub/dabtree.h
> @@ -37,8 +37,6 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
>  void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
>  void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
>  
> -void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
> -
>  int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
>  int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
>  		xchk_da_btree_rec_fn scrub_fn, void *private);
> 
> 
