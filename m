Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F80138482
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 19:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713294114; cv=none; b=AiGu4w31LoHkjgaS0cvB4/PRVl8SHA0TQKsaZV3LjWcQKNlVKdiq15HI1YgG9tFH9UW/2OjndmbN/pcgohjve/SoXN8eezHrjvyZxbkEnbNN31GW+kbsQQqa1flUGLy/q/IDUV9faXImf+FIucrtOdKSOFruNOFNtTTliSKwkdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713294114; c=relaxed/simple;
	bh=SjqNdJ46UfZWNc9rdEH3oC35TRcMioCI9jtmHg7PYww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yzse9GxBZTPW7QUWdn6Ah0b3J87m7h/JfjuYwW/1B7UXMzJQF609sI4jET3zsGV3TT6HqhxBnA357CQ6SLvcOlmtZO9OV9NkriVSE1ajTTirYLodEsFlijZhZPZjtzUNIyqG3tka2h0YULrY7SAmJL0QQ0HKbNqyhuRXIca1D8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cq0Aihqv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cq0Aihqv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xAeodBUW/M6UFXXdu19BuE4SAKY8FrWx1xOoHti4S9w=; b=Cq0AihqvXPbu5DRvvGODGtb6XU
	/C4ZU0Q7y0aGHkzPEfx99Kz1G2Td2ImVk8z60ETiVpiZorKMQ21ZJ7zm91QI/36S8tdluHixOZQ0f
	UfiYGXNOUudZBDWkzyEegKUo3/l46qFgvbFab3ZBlJPK5RkUyun05xU44h1END1fJPP4Wz5qTDHMq
	n/GYKFxg1r7boY208b1k4ZNx25BLvOLGcHQzBqFBj51ZWNSmDVEbBG6TQMneMtkxZBr33Q7V/ovt/
	rjryiTHDq0VT4VpRuC4R0a7LpeOo+FTe8FuPjBoddZgQhoRuL+ZQ41Zwxco4jrK3nDppV9+hKA5fH
	PeAhM7iw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwo40-0000000DS5b-2ZwH;
	Tue, 16 Apr 2024 19:01:52 +0000
Date: Tue, 16 Apr 2024 12:01:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <Zh7LIMHXwuqVeCdG@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
 <20240416185209.GZ11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416185209.GZ11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 11:52:09AM -0700, Darrick J. Wong wrote:
> > > <nod> But does exportfs actually want parent info for a nondirectory?
> > > There aren't any stubs or XXX/FIXME comments, and I've never heard any
> > > calls (at least on fsdevel) for that functionality.
> > 
> > It doesn't.  It would avoid having disconnected dentries, but
> > disconnected non-directory dentries aren't really a problem.
> 
> For directories, I think the dotdot lookup is much cheaper than scanning
> the attrs to find the first nongarbage XFS_ATTR_PARENT entry.

It is.

But I was confused again, it's been a while since I worked on that code..

We do the full reconnection for non-directories if NFSD asks for it (the
XFS or VFS handle code won't hit this because our acceptable callback
always returns true).   That code does a readdir on the parent and
returns the name when it finds the inode number.  For files without
crazy number of hardlinks just looking over the parent pointers would
be a lot more efficient for that.

