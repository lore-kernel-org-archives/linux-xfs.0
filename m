Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1D350D74;
	Fri,  9 Jan 2026 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975720; cv=none; b=o1OBWk+i092H/x4APyZQF6HGOQR04NayBJ4ZsbdgA3BXtpBNwvL+yCjBz2d6C08RiIRipW8CGzOvEwDIs0gnUipMJussEwH/U0TC49vbtZoFinx8zS7yGXc3rVH0QSgYfQjolBEZo3rG3VNi5H7vg1YJeRG5hlMXgY1a9+mhEiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975720; c=relaxed/simple;
	bh=rPLTY10CYUrS+QsnoLyDPVZ143Tx/dq8aI6VQ9pLJuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0ERROlBL60Y3nsHxh9g+NFAogmjT2zbnFjaRQFGy69B2RppUKLCCiFtw8dhta9wtQTKOkR0SHMXKoPeI2Ige+itdD0g2n2AK45Ob+h26H5snAJbiyUzJr/jjhqVdiQSwsc5JRL0UZlD+ITs/P27OyWRIbmQxy9Tw9oRr7zNf5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DxSW5MzC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DxSW5MzC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vr10Gk0w2xjCuCT8QlDJ/mLUFlt3m3OYq96enQWHaOs=; b=DxSW5MzCZ8v+LLuDp1Ye9Ohdde
	QkDe9xNt12e0lwYUwjYPruvx2DlE5OAfppnbb7NGCNDj9jORXFhZRmcQt3aTn6aqIAbz09x3e5hNU
	cdwtCB4l+bYc5M8aYAcianw/Yp29v3rzUK1IkyB/hYKkRH96HaKGwAvhKPNh5VqZR6JjoyU1sITjI
	Qb4VlzIs+clur8D/i33jkN1Hm3CElExPj44HxbMZDtUr16lw0KJ0PrDMdDtxEbWs/ARpl8aHEBkox
	FnV4DFtNRuTGErTo+PBb47AIGStPsu/xircoZunzGcA2U9wsCKMY/weqdGC6aKWcqWEAxFn9pel62
	mXAFIx6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFFL-00000002c4H-3AM5;
	Fri, 09 Jan 2026 16:21:55 +0000
Date: Fri, 9 Jan 2026 08:21:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mark Tinguely <mark.tinguely@oracle.com>, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix NULL ptr in xfs_attr_leaf_get
Message-ID: <aWErIxQxiNhTq2nR@infradead.org>
References: <20251230190029.32684-1-mark.tinguely@oracle.com>
 <17cd5bef-e787-4dc9-9536-112d1e2cda2d@oracle.com>
 <aVzDNYiygzgjMAkA@infradead.org>
 <20260106154026.GA191501@frogsfrogsfrogs>
 <aV32nTIWTacVXqIw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV32nTIWTacVXqIw@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 10:01:01PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 07:40:26AM -0800, Darrick J. Wong wrote:
> > > > Fixes v5.8-rc4-95-g07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> > > > No reproducer.
> > > 
> > > Eww, what a mess.  I think we're better off to always leave releasing
> > > bp to the caller.  Something like the patch below.  Only compile tested
> > > for now, but I'll kick off an xfstests run.
> > > 
> > > Or maybe we might just kill off xfs_attr_leaf_hasname entirely and open
> > > code it in the three callers, which might end up being more readable?
> > 
> > ...unless this is yet another case of the block layer returning ENODATA,
> > which is then mistaken for returning ENOATTR-but-here's-your-buffer by
> > the xfs_attr code?
> 
> Not really and unless.  This patch (and the full removal that I've
> prepared in the meantime) still fix the missing buffer release in that
> case and make the code easier to follow.  But yes, they would not fix
> the underlying issue, which is why I still think we should not blindly
> propagate block layer errors into b_error.

Having looked at this a bit more, there are clear issued with the calling
convention of xfs_attr_leaf_hasname, which are fixed by removing it as 
done in the patch I just sent.

But this is very clearly another case where ENODATA/ENOATTR can leak from
the buffer cache.  So just as I said back then I think we need to stop
leaking the block status code through the buffer cache.
