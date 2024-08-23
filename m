Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D3C8493
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389868; cv=none; b=CjACMYeHjKJ1Z8D/oLMuTry/OYVtLQDauPtV+LFTH9DRRNg6sCBfQOUZOVnt/swzgfU+VyNZKYgEM7XWXvjcc4IwfknBD5YN50nSiAxD9MGu7CAu8fJEgZzqDvAmDYlAVaRfzLpNlYHVX8c4TKc2zj9oYAb3jQFDYfCvIr/Uk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389868; c=relaxed/simple;
	bh=UET3Fnoqqh2WNAxrg04qZk511P6UiybVD//Cte6BeCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjW+dtxwicFR+wi6fRnw3V0cXXoYdahcXapbdSpci3wCkR2dsBd1gBpj1fsKnUlQd8EPBFYU2kBcsswhfDbJCXk9JG26q7ZgRWxStgFIBZ4+rfrA15/EKQPg348D1svh0soil9VuA7NXlJ2abMF5P2t2ym5wmsGT1jHODIh83NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=knQPNkKT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="knQPNkKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1GcZMLu/ilxuQEzHw7eR6vupv87/B5j0tI99KvT2+nA=; b=knQPNkKTaUh9sQcK29zNBeoAsR
	gg82oVX0V8vy4UBX3k65VJBqnM7OfLSdQUa4mKdaVoi2Nwu5416doUuDJWpQes8YTEmC4Rgq3K/NK
	7ky57pgwIKZ3C9RgNu+qLHzpdTH4zq9kSMFEtLpaYMvGfq0PHBtmuOc3rK2ARbxHmk8mx5MY04ln3
	mxBwBai6mkL4fyxTO+rMFLuJ8G6RU9RaFS1oNTrxkg3xVN8hnsc7/VbsVz2CejTiiDOxLq5MKSfLW
	bOpRkQ73PRUxMEPWqc9dNRQ0mAUrLoHaDjV3t5PSGHLo5KYCzj5NXWrqrAIqEMdeSZiwiWkxj/Tr3
	aaxy9skA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMZk-0000000FGlO-3erQ;
	Fri, 23 Aug 2024 05:11:04 +0000
Date: Thu, 22 Aug 2024 22:11:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/26] xfs: define the format of rt groups
Message-ID: <ZsgZ6ND3UFA0bGl-@infradead.org>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088534.60592.14072619855969226822.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088534.60592.14072619855969226822.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 05:21:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Define the ondisk format of realtime group metadata, and a superblock
> for realtime volumes.  rt supers are protected by a separate rocompat
> bit so that we can leave them off if the rt device is zoned.

We actually killed the flag again and just kept the separate helper
to check for it.

> Add a xfs_sb_version_hasrtgroups so that xfs_repair knows how to zero
> the tail of superblocks.

.. and merged the rtgroup and metadir flags, so while this helper
still exists (and will get lots of use to make the code readable),
that particular use case is gone now.

> -#define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
> -#define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> -#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> -#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> +#define XFS_SB_FEAT_RO_COMPAT_FINOBT	(1 << 0)  /* free inode btree */
> +#define XFS_SB_FEAT_RO_COMPAT_RMAPBT	(1 << 1)  /* reverse map btree */
> +#define XFS_SB_FEAT_RO_COMPAT_REFLINK	(1 << 2)  /* reflinked files */
> +#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT	(1 << 3)  /* inobt block counts */

That also means the above is just a spurious unrelated cleanup now.
Still useful, but maybe it should go into a sepaarate patch?  Or just
don't bother.  Btw, one day we should clearly mark all our on-disk
bitmaps as unsigned.

> +	if (xfs_has_rtgroups(nmp))
> +		nmp->m_sb.sb_rgcount =
> +			howmany_64(nmp->m_sb.sb_rextents, nmp->m_sb.sb_rgextents);

		nmp->m_sb.sb_rgcount = howmany_64(nmp->m_sb.sb_rextents,
						nmp->m_sb.sb_rgextents);

to avoid the overly long line.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
