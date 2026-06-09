Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C39D351C24
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016854; cv=none; b=rOzw5uSj71u4y6mdB0uOETDNbPZ2iAjz1vGDy68UAoh7V+3qKYkYEeYkyVhe4fJrkMfJl+YoFEak086M+qvo+8YKCCxqWyUA6llCYlICWB22maAHyjBdEcaO/6/rXKRnn+bGPRZVMs8T5vRFw3h98qnri7kf8nyL9o+SnXu0Twc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016854; c=relaxed/simple;
	bh=3B7I3BFAM7rrYXXt9aiUU08grSUs5HHPlt1sDggORk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQN4sHEn2lNijsAv7tILT9aktnqUsBdk0ZR/zcdfl7yJdNKG9uqk3+ougCtg+rVqTI5NlirYc1ZvfIjhTDWzeSpTjay2uNkermfwMaNZYNfZkciBX0CkZzNYYTLaRI7rX4o1JHddLPmZlAnXSXCzb1fuxPyQTR+f/lIdi6WV6vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTI7m9mJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTI7m9mJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D7F41F00893;
	Tue,  9 Jun 2026 14:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016852;
	bh=QKHmrMpx27Mo3bjufh8qOMwxCSmupoJ3kU00N2maBmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GTI7m9mJV2Vw6VvOse0dS8DKD+ZrrA3cNcpmSUs3iuwqIs+RDtZodUFnK25CmueXq
	 TTwRskDms35X0i9KiXZDj63uLlf9gKcqbu5tjOUTSKLKMtYE4i9R2ctSMATR/CnwHP
	 KyA6Q2mHQUMs8bgWf7TesfC/vwmWXMCmrrY9+8ELzwliLtGMfYPA4ivmXTqUAipemP
	 OACETw4EVvMHC/YEpKd5uKdF+ocysfbk2Vbw5qEeohlIX2OP9RyBizvA8pXF70dXwv
	 tpcq7sLdvxOTppYnIUugLuTNAs8jmSzyyNtrypCFxSJzE/q0lKiBhtjBNbzzxxXX4r
	 KBPM5bm1fcXMw==
Date: Tue, 9 Jun 2026 07:54:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: only log freed extents for the current RTG in
 zoned growfs
Message-ID: <20260609145411.GZ6078@frogsfrogsfrogs>
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609075655.1698743-4-hch@lst.de>

On Tue, Jun 09, 2026 at 09:56:43AM +0200, Christoph Hellwig wrote:
> Otherwise a power fail or crash during growfs could lead to an
> elevated sb_rblocks counter.
> 
> Note that the step function is much simpler compared to the classic RT
> allocator, as zoned RT sections must be allocated to zone and thus
> realtime group boundaries, and also because the rtextsize is fixed to a
> single FSB.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_rtalloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index fd07c1a18615..728f444fbc30 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -890,8 +890,7 @@ xfs_growfs_rt_sb_fields(
>  
>  static int
>  xfs_growfs_rt_zoned(
> -	struct xfs_rtgroup	*rtg,
> -	xfs_rfsblock_t		nrblocks)
> +	struct xfs_rtgroup	*rtg)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_mount	*nmp;
> @@ -903,7 +902,8 @@ xfs_growfs_rt_zoned(
>  	 * Calculate new sb and mount fields for this round.  Also ensure the
>  	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
>  	 */
> -	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
> +	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
> +			mp->m_sb.sb_rgextents * (rtg_rgno(rtg) + 1),

I wonder, do you have to be careful about the multiplication overflowing
here because rgextents and rgno are both 32-bit variables?

--D

>  			mp->m_sb.sb_rextsize);
>  	if (!nmp)
>  		return -ENOMEM;
> @@ -1219,7 +1219,7 @@ xfs_growfs_rtg(
>  	}
>  
>  	if (xfs_has_zoned(mp)) {
> -		error = xfs_growfs_rt_zoned(rtg, nrblocks);
> +		error = xfs_growfs_rt_zoned(rtg);
>  		goto out_rele;
>  	}
>  
> -- 
> 2.53.0
> 
> 
