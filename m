Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635683FBA0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709139753; cv=none; b=uBw8bH5atQIH1W5CryEGC2D8JsPBgrdXuL6nEzsUcPYKouhm4blPhx/sjLmXU+j4J8ON1SckS4p9UAfMZ8ABFT6MDSatdCFPnVSL7roBsvWEp5Ih1vKiJ3UWRelNn6LU0pOzilXpP+Ysd2x+TQFbOLwjI/mT5Q4uf8I13ew7yiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709139753; c=relaxed/simple;
	bh=Fx4jo40nIZyB1jX23qCrmix33PP0JYrxLD6MGRF3CTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kx0Ncb8plFfw/aBOLlYsC/jLDabgYg+XO42k/sINjSgCXdcLP2cO/mc+FCnNkWCIU9xTeqWpng/+wvqVDGbhQFE0yK+xsM2icJ2BBt0grGeefDYvINtXbT6GHA1AGy1sD7uLqOxVyLkrJPaSpVBrZQONLi0LfXhUpllwivSPoJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mvnfCH6U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mvnfCH6U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LizXADbTmDp0X75UVGbvUo6BaEPyhSvMjifL8YIM6y0=; b=mvnfCH6URLcCtN+dCxF4IdXqLo
	D6b84CKPL2v1IFZfjoZqWpIMiS7gQq8WOaJVolTaSQrAq/Fx+F6UJ05wdAwEPxp+WEHGTYudV/zuR
	0DLT2cMCjX5MOLhuy7vCZY1hjqoU6pVepBXy8qqwHZZnIUJstBVqbq53CltsNOfuYZlw6wL0Oweau
	Kop8C9pD8DFwp2UFe1Gud/hyDmqGaRibCKuafXrfFGw0BaW7JhFrHYyZMqSaVEXXpNVKt7wm2HwTb
	NyGvI1jQj5sDrxXeePJCPnjKkRRTORZ/lW3PqQjx1/jOUMwMhv50ncjCpJ9qXb+IvY4Rxt9KZvRK6
	Z7dfoJJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNKA-0000000ADO4-3Ur8;
	Wed, 28 Feb 2024 17:02:30 +0000
Date: Wed, 28 Feb 2024 09:02:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
Message-ID: <Zd9nJj3Lw4kUYIY6@infradead.org>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
 <170900012232.938660.16382530364290848736.stgit@frogsfrogsfrogs>
 <Zd4mxB5alRUsAS7o@infradead.org>
 <20240228165227.GH1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228165227.GH1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 28, 2024 at 08:52:27AM -0800, Darrick J. Wong wrote:
> that are private to XFS.  What this means is that userspace should never
> be able to access any information about these files, and should not be
> able to open these files by handle.
> 
> "Callers must not be allowed to link these files into the directory
> tree, which should suffice to keep these private inodes actually
> private.  I_LINKABLE is therefore left unset.

I_LINKABLE is only set for O_TMPFILE, so I wouldn't even bother with
that.  But thinking about this:  what i_nlink do these private inodes
have?  If it is >= 1, we probably want to add an IS_PRIVATE check
to xfs_link just in case they ever leak out to a place where ->link
could be called.
