Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEC955783
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716299472; cv=none; b=VNFeXOkzefj02aewnpweNVc5pFG9zY7PE30qxKgAoJRj+EHMg5y7GlXu6MZYkNsddR6i5j3q8uDZ+n6GpDkH7jh7D8FrWjBvPmXYKkq4ItnpKdVNFt0w5eBkhUWsmRd0pRQ55SPZtjhv+2G4OXsUoqlCrxhCywUrtstXS3kWHFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716299472; c=relaxed/simple;
	bh=UR5f1ZZSjCNInEnpXhV+mgPlBM3oG7zuRs04eLJwcNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DleUu5jH90Hr0FhffFIr4j20HEu2aVdQy48pHGO2K9cRqNKF0DRqAYDK36ZGP4BCivxsWd97JZWoPbjXhP/5sezfTWYvVwZmcoyG+544K/U2d5OvBaR/AomTh784Ey/wNs04ooZ+IzQJvQ/Cn9DGzpAYZ1Hd5+cPXVGxPxhKVD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LHeXRK6k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LHeXRK6k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7ZwDQU/oJBn3o6tMasv49ip8nj9ZCIR2IART1OE3sWI=; b=LHeXRK6k2ahkAVwvoi97KXosI/
	WHzaDL+hWD/ZpLKQ2DzaFhZGKBRMOLtBJig2m3oHAe77+WmActE59DaMtlauvl7w+oYx1K/+saYEk
	/Rdp/b0XKvg3Jx1PM4IuRJzrxWIJUJZQWU2f3m/ZNC7Fs89jPL1ocbjaIzI9/bgOFc7OR5ifcA0Ly
	gNLJOqRJhs1TxkUMwggoU7BotEpNXTWMSCZF04GWi3QaosuPH+5mRSkuQC26QcM5p3WbXYX5z0aK1
	QORdzCkktMSa8wQvUojcKyE31iW6S8DyC5VnNH/PlcwqD52gBvikbXy2xdG6TmGSb4VvVgJn26ziB
	tPpGZSJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9PtT-000000003Qm-0Lb3;
	Tue, 21 May 2024 13:51:07 +0000
Date: Tue, 21 May 2024 06:51:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
Message-ID: <Zkymy4s5LtabyMRm@infradead.org>
References: <20240521010338.GL25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521010338.GL25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 20, 2024 at 06:03:38PM -0700, Darrick J. Wong wrote:
> +	tres->tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres->tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +	return args->total;

Seems like indentation is off for the XFS_TRANS_PERM_LOG_RES
assignment?

Also wju does this need to return args->total vs just handling it
in the caller? 

> +/* Initialize transaction reservation for an xattr remove */
> +unsigned int
> +xfs_attr_init_remove_trans(
> +	struct xfs_da_args	*args,
> +	struct xfs_trans_res	*tres)
> +{
> +	struct xfs_mount	*mp = args->dp->i_mount;
> +
> +	*tres = M_RES(mp)->tr_attrrm;
> +	return XFS_ATTRRM_SPACE_RES(mp);

And do we even need this helper vs open coding it like we do in
most transaction allocations?

