Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0C53009E8
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 15:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738263; cv=none; b=dU8IWqXc+L8W6TbuIp0H40wslSkmTXjoTfFDWxn9DgP0h4frTku+BX2EHmRHuvu9suPOU/8B32IoJ41fCzsBwpotSNjy5BCMEET3vzH62cvYnIDMUcs2Tem15WoxngkcNDARW6Fn0tpw+kZ+UX4RLCk9vujJsp2Pg4185sFThuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738263; c=relaxed/simple;
	bh=kMVndmYf49KAw4r93olStFgJ1mV9fcQ1uVr84wqh2DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWwe0+BFVw8+L8SymSbzMv9t473/6Tbbh0yvtUruLgl22x0HwTutYqd38bT0N9i3Jqv7k4mvWyifbB9XZIm4lfcjWtkBf1y3Cc/bjilrOHJaEGdZD9A2GkIQCBs3gVJnQhJsFOa2EWOqaHCbpRfcvvcS4aTSeni8Wvc6SQn0DFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TrgyCYva; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TrgyCYva"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VpNo1Q4blq6JFICWwRW4a2uuV5qc7EyHtggANmuIzVM=; b=TrgyCYvaad3j7yBr+LnSP9owbJ
	5TU+Yc0CrAL7E5IdRVRJAw8rXtnoNvR2eUClnrcmPRnoCgBK6R+6hV+d+93atkYQq3yeWXzSEHn9a
	jjjWY+3qn9YI30SNttOC7eKyHb7eA/ZWBurrkko8MLCDxIGGRBJje3JpA5p7wUimgNF+9pSNlVrkU
	2cPq2Rs4ipFLm0MwHcnqvgZc8l3ROwhU0tc27rQKcd7KrFp2OOGyz6aSp63GzGYqlxshhi9iFGJR9
	95i8Uygw427VzTwSHFR3La8eBSUq5CNBm/hgVqiBWERQ40eDK2Ltfys0fdAaX6MLj/7PshhfYRBea
	Kud0sBSQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vppuU-0000000H95V-1u5J;
	Tue, 10 Feb 2026 15:44:18 +0000
Date: Tue, 10 Feb 2026 07:44:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: nirjhar@linux.ibm.com
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	nirjhar.roy.lists@gmail.com
Subject: Re: [patch v1 1/2] xfs: Refactoring the nagcount and delta
 calculation
Message-ID: <aYtSUp0m5KUQ8HUt@infradead.org>
References: <cover.1770725429.git.nirjhar.roy.lists@gmail.com>
 <b70d0fa35690cb120a6f79a7283af943548acb45.1770725429.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b70d0fa35690cb120a6f79a7283af943548acb45.1770725429.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 10, 2026 at 05:56:34PM +0530, nirjhar@linux.ibm.com wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Introduce xfs_growfs_compute_delta() to calculate the nagcount
> and delta blocks and refactor the code from xfs_growfs_data_private().
> No functional changes.
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |  3 +++
>  fs/xfs/xfs_fsops.c     | 17 ++---------------
>  3 files changed, 33 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index e6ba914f6d06..f2b35d59d51e 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -872,6 +872,34 @@ xfs_ag_shrink_space(
>  	return err2;
>  }
>  
> +void
> +xfs_growfs_compute_deltas(
> +	struct xfs_mount	*mp,
> +	xfs_rfsblock_t		nb,
> +	int64_t			*deltap,
> +	xfs_agnumber_t		*nagcountp)
> +{
> +	xfs_rfsblock_t	nb_div, nb_mod;
> +	int64_t		delta;
> +	xfs_agnumber_t	nagcount;
> +
> +	nb_div = nb;
> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> +	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
> +		nb_div++;
> +	else if (nb_mod)
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +
> +	if (nb_div > XFS_MAX_AGNUMBER + 1) {
> +		nb_div = XFS_MAX_AGNUMBER + 1;
> +		nb = nb_div * mp->m_sb.sb_agblocks;
> +	}
> +	nagcount = nb_div;
> +	delta = nb - mp->m_sb.sb_dblocks;
> +	*deltap = delta;
> +	*nagcountp = nagcount;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 1f24cfa27321..f7b56d486468 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -331,6 +331,9 @@ struct aghdr_init_data {
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
>  int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
>  			xfs_extlen_t delta);
> +void
> +xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
> +	int64_t *deltap, xfs_agnumber_t *nagcountp);

The formatting here doesn't really match the functions above and below..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
