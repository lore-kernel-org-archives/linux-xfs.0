Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296764B0E32
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819851; cv=none; b=cLC3YUKBI4pUzuoeMYJkigWOixbT1NAS7A4dT9NvrcFZhX01Ux5WofWzv+UNoRMw5yhpqvqRpACi5PQyaHz+FzcHt+pFeLPBsVak92xCsVU+5EwGFzYBgfC+6g2TukNRPf3lVwqNLIDEbz3Bc2GXotL/+GTUsb51NUgHp5nTWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819851; c=relaxed/simple;
	bh=yxXrkGiCzajSKRpsO7wNyAjReJUe3DJ8UIfacKhGXxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XazUBiGYz04AicQJYG1P0KI6Th4HRjk5FA2xypAziB62gVVQlkrCroPN9xO2xvrbKYafCOWOsK1kdtnSm+15fS7yXQOpjURhdaoQf4HZ+82gczXRLOphE0vvAfOcLrdyqvI2/dcTBEWcD3+cP+TBADjaQ30BwTUMzjMx7PfQUdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R4e2n6jD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R4e2n6jD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n5GsAvyjJpr8yO40HKzxu368FFg5IRlgzEAdGCfaD0k=; b=R4e2n6jDKh3dLWIMU/4YlctbQi
	XaV7Vlh7YGaIJtO4O1iU7zv4tdNCQiXmreyC0b1yIGnmu5MzD1NsvMWa4ynWOjALSqiYy5tm86yyD
	OvUPpF0ik/Yo33zgdh/0qD2beHEiD6ArD1SVGNC6nVpQxJh7TdBeHQaE1R5sy0bks6rfqaUuNcsIq
	l4a6hyBDXKXOAFckMzPFwF+ohdCRWe4vlpYK5z1etweHjV9QLzUdOlpeWaHXwc2x5Y+FMnnKB/00F
	9Nlryx/H+WkQjoh9jeMCI44mhmlikRiXqmQ5P7wWTKb4vF4aZA11VJH6PR901rjEgfnGhj/9lIiY1
	jJfnUJYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGIC5-0000000Aq0d-1333;
	Mon, 12 Oct 2026 15:44:05 +0000
Date: Mon, 12 Oct 2026 08:44:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/26] xfs: hide b_flags manipulation from code outside
 of xfs_buf.c
Message-ID: <as0ARZpyuDQYbqCa@infradead.org>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
 <179158947495.3719791.6891995032675051951.stgit@frogsfrogsfrogs>
 <asze5x4ZrCI-Clss@infradead.org>
 <20261012153503.GY2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012153503.GY2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 12, 2026 at 08:35:03AM -0700, Darrick J. Wong wrote:
> > propagating the kernel flag to the libxfs one might be a good idea.
> > But please don't hide it in the resync, but make it an explicitly
> > documented separate patch so that it is properly described and
> > easily bisectable.
> 
> Hrmm.  Looking at the existing XBF_DONE usage in libxfs:
> 
> libxfs/rdwr.c:1428: * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
> libxfs/rdwr.c:1437:     ASSERT(bp->b_flags & XBF_DONE);
> libxfs/xfs_platform.h:323:#define XBF_DONE                      0
> 
> I'm gonna guess that if I replace the helper with:
> 
> static inline void xfs_buf_set_uptodate(struct xfs_buf *bp)
> {
> 	/* does nothing, XBF_DONE is not LIBXFS_B_UPTODATE */
> }
> 
> Everything will be all right.  How's that sound?

For this series right.  But as argued by the repair log recovery
slop series unifying the flags is probably a good thing, just not
hidden in a resync.

