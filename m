Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fCgGIUbp"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D089F10D5
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 21:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HCFBD0tIaWP0e1B6fHiJW5cjihGcVjeQRpa6pjtqfAU=; b=fCgGIUbpUrAFPKM72emMZInu0r
	sPFTDnuD4E1pVeCLUydJVTh9zhI5Pn2YtH1wvuJQ8P18lp+e015LdydfjRXOZIPkqy0lc6DrEm+XM
	W9jwm+hAi9+K5twZ2ROCWFUlb5zPr35lnarsMpoQAzNWXV55a8nWgBxNYVmUdfPd4v1iJo3qm+a5+
	TPGdzOKm67nRm1ZMPuR5ZcL2DkrV32IbFkyOpmJ5isFcjVoK3zmmrfW+gJ6WQEdG7EjkYK6e/3Uns
	iQgsu417D09Bvmty5SOwSJtMzHV2k/gFuGyHFXnudAklVokrAjmRr1lmziG4mioSoqdEp8igcjUQ8
	Eu8miPYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r8ZHI-009wv1-2L;
	Thu, 30 Nov 2023 05:07:56 +0000
Date: Wed, 29 Nov 2023 21:07:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: repair inode fork block mapping data structures
Message-ID: <ZWgYrIDVl992ZIsO@infradead.org>
References: <170086927899.2771366.12096620230080096884.stgit@frogsfrogsfrogs>
 <170086927942.2771366.11233494127863883983.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927942.2771366.11233494127863883983.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Nov 24, 2023 at 03:53:25PM -0800, Darrick J. Wong wrote:
> +static int
> +xrep_bmap_extent_cmp(
> +	const void			*a,
> +	const void			*b)
> +{
> +	xfs_fileoff_t			ao;
> +	xfs_fileoff_t			bo;
> +
> +	ao = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)a);
> +	bo = xfs_bmbt_disk_get_startoff((struct xfs_bmbt_rec *)b);

It would be nice if we could just have local variables for the
xfs_bmbt_recs and not need casts.  I guess for that
xfs_bmbt_disk_get_startoff would need to take a const argument?

Probably something for later.

> +	if (whichfork == XFS_ATTR_FORK)
> +		return 0;

Nit: I'd probably just split the data fork specific validation
into a separate helper to keep things nicely organized.

> +	/*
> +	 * No need to waste time scanning for shared extents if the inode is
> +	 * already marked.
> +	 */
> +	if (whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(sc->ip))
> +		rb->shared_extents = true;

The comment doesn't seem to match the code.

> +/*
> + * Try to reserve more blocks for a transaction.
> + *
> + * This is for callers that need to attach resources to a transaction, scan
> + * those resources to determine the space reservation requirements, and then
> + * modify the attached resources.  In other words, online repair.  This can
> + * fail due to ENOSPC, so the caller must be able to cancel the transaction
> + * without shutting down the fs.
> + */
> +int
> +xfs_trans_reserve_more(
> +	struct xfs_trans	*tp,
> +	unsigned int		blocks,
> +	unsigned int		rtextents)

This basically seems to duplicate xfs_trans_reserve except that it skips
the log reservation.  What about just allowing to pass a NULL resp
agument to xfs_trans_reserve to skip the log reservation and reuse the
code?

Otherwise this looks good to me.
