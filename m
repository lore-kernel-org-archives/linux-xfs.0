Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3BC4A7CB7;
	Mon, 12 Oct 2026 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810558; cv=none; b=KMOk6ZBWi3BooaUTK92SyqGtgsmJoR+5YgvJKr6OAb43cvljdQarLlCYvdB3X5FJP5k60ZHWt5cASf0O+ISCOzgetQpdQ34+Z2SzEMPolMvtjIaDTYrEIdk+dgPluctTmx3Y18s+gJwcvg5CcjMyWVE6P6MTV/avSyYTbQgwLno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810558; c=relaxed/simple;
	bh=nYmRq2IG3KUl/hCsvqN7xXix+A7YmnKOy0Of5/ngg08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDdM2RxDtl79MIxj9kaga4wvl6gqz+ems2nO4NMWqb88XQZpLbOewUH8UcAD7mbQ8WU0i7dU3XMFI+jReVYr+0iuEi9DddnbSzhM/2c6HBFypnjYszfKsOetPv7vMOH35Gu4xNdu5pj2YjRB0Gv023NelxcQpx+R0hV+yyuxZBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iKi5bToK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iKi5bToK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Yf++0YfKa//bAyU6KpPQqDdCyQDmMXjilHVxWCcJZZg=; b=iKi5bToKOj+H2EBib12Jjw8oS7
	/yH/7LwVm5pO96QUP+jLEC9RyaAzThU1JtSjeWYju3cSFUYHQYyT2z7aU0BJVsC5C+Gb76Sp68yYW
	S6fTWBma/8oyQTt5S6LHN3kpnVx6iLrsYUDsrjHG+d+IJVtx85Xmwhh8A4YitEdSUQjhTSznuyDTg
	/5dTKbNVJV6B6Pj1WfLhWWu1nfAsedVjvwis/Y8B5rRhyUWg14NyFUfia1cC6dHqaeG/4JJLgtg3M
	xA3qkOQUuKNVRikmPXa0PfcWnSZV1U2+rk3r+sUuWjvZBfLOYOu7xSrgUYU14DlVEt+sV6gC6gOdD
	nj9UIUoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFmG-0000000AXA6-3S3T;
	Mon, 12 Oct 2026 13:09:16 +0000
Date: Mon, 12 Oct 2026 06:09:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: only written file data blocks can be shared
Message-ID: <aszb_INSp9qbSTf-@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065324.1058326.3356948076285838276.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065324.1058326.3356948076285838276.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:57:18PM -0700, Darrick J. Wong wrote:
> +	/*
> +	 * The refcount btree should only have records for written file data
> +	 * blocks or for COW staging blocks.
> +	 */
> +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> +			      XFS_RMAP_UNWRITTEN))) {
> +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> +		return 0;
> +	}

> +	/*
> +	 * The refcount btree should only have records for written file data
> +	 * blocks or for COW staging blocks.
> +	 */
> +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> +			      XFS_RMAP_UNWRITTEN))) {
> +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> +		return 0;
> +	}

Can we have a shared helper for this conditional?

Otherwise this looks good.

