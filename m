Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A53944F
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017491; cv=none; b=GOYQ3VDctUwaf9XihwKEinckhOTdE15knr4J7gMGx/kSWv32SRZnrhNyPNNez7MH79vFbf/4ZNc/JuIp96CgWUxb9Bc7NiYOi7GVF+Dx/k8941c/TbtzK6vApPzuJ1AtI+eWsYhikdh3O9clhO4CGiDJGZxCDi43wie5a/HENgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017491; c=relaxed/simple;
	bh=MNTE+6uLw9UrMT5RgMjIx0s+ulrYC+WxuzbomZX9Hs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ndI7t4BhNnx7SN9vZyppu5njdXOOmG2hfrSPfwBcTUJp7/8qmoGurl/SVXA9k38yxp8hBGzgLgyaMvbG7GavnJ5gPrxmCr5MZza/+WFintel5K74GGShCWHszBg+gktw5xPOqhckOTDHVe11VwRzvlNsb8nToGKb7mkyspOuIfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=duUeK4TE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="duUeK4TE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y6/dYFO4SpvOfHcD0KYXFR/2Uvv0a50+MpK5l+TOlR8=; b=duUeK4TET11WQIlZD4vN4msCO7
	FQRBSkuna/oYtHUUP2qX6WONq0tDrwjOe1G8KNar3I20DGcCC2dU20O/KS5jyhw5ARZWmMvHtMzW1
	amAQxKZ92PeRS+dwwNX0ANvnhw5yLCTaqL+rcdAyR/YReVQCD2dp2ZzpGhGt1RhIMpI2YNXvcAmqV
	FXum42Ctjk9hlgJp+NQF7oCJZc+C6LH+Ns1oJzkTEujggu+eoebRvdnhV5WXoDwexhIwaF3B+1P3p
	q4ARnz9t+XmyGayvH4mtNFnFNX1UH5WoVIt85nhJ7ik4fvxkj6XlIOOzhChHInMssdqV9nRjfeLyg
	y/2/6G3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmoP8-00000004bAp-0uPj;
	Mon, 02 Feb 2026 07:31:26 +0000
Date: Sun, 1 Feb 2026 23:31:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <aYBSzg3IhFffphuI@infradead.org>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <20260130165534.GG7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130165534.GG7712@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 30, 2026 at 08:55:34AM -0800, Darrick J. Wong wrote:
> > +		xa_erase(&xfs_uuid_table, index);
> > +	}
> 
> Why not store the xarray index in the xfs_mount so you can delete the
> entry directly without having to walk the entire array?

Yeah, that makes a lot of sense.

> And while I'm on about it ... if you're going to change data structures,
> why not use rhashtable or something that can do a direct lookup?

rhashtables require quite a bit of boilerplate.  Probably not worth
if for a single lookup in a relatively small colletion once per
mount.  But yeah, if only we had a data structure that allows
directly lookups without all that boilerplate..

