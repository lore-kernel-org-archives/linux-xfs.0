Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEBB15DBA0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135347; cv=none; b=BlvHfa13otbube5AihNOkHzZecgJ1Z9FSEgXqU9bTUToTd9lMnmYakE1uuCZ4Gl2t7VDy59Y5v4WB1IahkowZcnm23bB/EnDkw0czqerUi65s7TRJVzjDEvm1y+hLPfGybhh8iGWu6N8GtFynrJMoSU+1en/k+uoq9F9BbnSVfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135347; c=relaxed/simple;
	bh=/muW78tBnKwQ/Pku6FMPK7TuHPwB4//5X8oPmthj6D8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaHsCflc2TAkkpbF3Zw6VZBNRUZgKGvsTbrsHTaTzYqNT+MClfJGl7odEbPvZeTIlwZyA+/P+o7U3g6ZYKSqtbFEkSpQbO9u/sRVMWtU9grcwQ/sxkGUBm5GefrIj5d3O4S4JCs8qBLx5Udz0HO1jAcWuMMC1K5lVQFKpYnpsgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hh1ZMAaZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hh1ZMAaZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ejAzWkBPinfWBs+7LNAGPunX+FF3rSzuI7E3t2rfbxQ=; b=hh1ZMAaZoVy+5fXvsdGI6vvqc+
	55ioesNKsAXGIgzBK6MHTXPShCwg7elZKhnl4OG95Kx+mo9AL81hpdMoYB6bDMEc9DCZnjzfmVzuV
	EVjXK2EYk8VqkFlymosMTU3t39UeNqQ125iHB41q0q5rM6jN2/nUKialhZWDKCNOC08TSRdJx0rfV
	DgwbltEemXhwt/aHps5YH0BXRnZb2vubn93Rp54SHJzcS23D7zW1xUxVKy/gDfx/YPHGTWjhWCS92
	SwDpcGGJfPfuUuCQ8ymtiUdFKPXdTrA6rYAW2efS+INGX1SO2XLIifP4r5AOe+0i/g0t9A+k9Pd+n
	n+m5FHQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMB7-00000009yMR-0t7X;
	Wed, 28 Feb 2024 15:49:05 +0000
Date: Wed, 28 Feb 2024 07:49:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/14] xfs: create deferred log items for file mapping
 exchanges
Message-ID: <Zd9V8VIoA6WpZUDM@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011723.938268.9127095506680684172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011723.938268.9127095506680684172.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
> +static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)

This seems entirely unrelated, can you split it into a cleanup patch?

> +		state |= CRIGHT_CONTIG;
> +	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
> +	    left->br_startblock + curr->br_startblock +
> +					right->br_startblock > XFS_MAX_BMBT_EXTLEN)

Overly long line here (and pretty weird formatting causing it..)

> +	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
> +	    left->br_startblock + new->br_startblock +
> +					right->br_startblock > XFS_MAX_BMBT_EXTLEN)

Same here.

> +/* XFS-specific parts of file exchanges */

Well, everything really is XFS-specific :)  I'd drop this comment.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
