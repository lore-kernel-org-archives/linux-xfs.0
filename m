Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0476C51813F;
	Tue, 22 Sep 2026 07:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061622; cv=none; b=WpXFIhokQi2CUddKfx6MZgNN1l50WC8hxK+PDRAuNmP34eVuFgvGCeStTwpJMY0PqcRQZsDzL+UEkJ5YyJeGAIPgJ/vCZzUJjq5f+bkv7XCGcJHxcWKv90t3pv9FZr+iHuKsVSAW5zcDgxRFCRVi5bojRkonqgQLOlnykisq/sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061622; c=relaxed/simple;
	bh=LoJJY+MGmUe8O9vWOuBEUS1AeTA957gAbljhvWfOOxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkJPsZLblbmoqIxvGGzeJ0q5ES8oZbS2WpSu0WP9LA1ONKAX/PDeEbUuLhjMDoRHQNWTfWpCK09VmXVgL+axTwivpNixcgmLo2A3TdP5+cSk/4lthPLsTFlEB7/8CueNeN+Lna3kcJaWzrAzqAvJA7asaSvoFGOjoodHDw1ZldI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GxiJCKr7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GxiJCKr7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yQ8oqV+zlgKMQEWLXG1XYm7bo7EGuxG7SQtxvJVwPKc=; b=GxiJCKr7C4bne9OfpP4kXFeMSZ
	inl1e1zaG0FpExyWIYbx+brAqIJfAKSYxn/Ir8m5qGEnp/7vvsNp0u9dWozoCIrnQTSYUpoeBmKL5
	yb9NP/nxDVnuMsj2X8bmrSA71aGeDiSH5tkh4UTTi69CHkSa4k+cw4J3BCuzDt8ItSqx58UxTNyxl
	PXpArosE9haK5cSQaWxxJjwGNhpQy7udgZ400gBwV4vcgauAtQthw4kvSti/30SOp3PgLVFtnE8Ej
	oqDTEJ0c8VLnq7Qg1KskUW3A6NArtFsaXzT2teeXyQ6DqgCWiiGYDZ3oSOdSG52QOZXB+Bd+MBjTq
	oAHXAjsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8unK-00000004UMT-2BLP;
	Tue, 22 Sep 2026 07:20:02 +0000
Date: Tue, 22 Sep 2026 00:20:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org,
	hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <arIsIhrWltHi9Aej@infradead.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
 <20260922043402.GM2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922043402.GM2705364@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 21, 2026 at 09:34:02PM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index cc48f6e20e80..7ba76017ae56 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -5280,6 +5280,10 @@ __xfs_bunmapi(
> >  		if (del.br_startoff + del.br_blockcount > end + 1)
> >  			del.br_blockcount = end + 1 - del.br_startoff;
> >  
> > +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > +				del.br_state != XFS_EXT_UNWRITTEN)
> 
> Odd indentation?
> 
> 		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> 		    del.br_state != XFS_EXT_UNWRITTEN)

Yeah.

> /me again wonders if bunmapi ought to have its own flags instaed of
> reusing *some* of bmapi.  But I concede that ought to be a different
> cleanup, because figuring out which flags are for bunmapi.  I think it's
> REMAP, ATTR_FORK, NODISCARD, and UNWRITTEN?

I think that would create more confusion than it helps.  OTOH asserting
the valid flag would be helful.

Sashiko complains about interactions with the weird rtextent bunmap
behavior.  Should we disallow fsverity with a larger than fsb
rtextensive to not bother with this?  Btw, did you test this series
with RT classic and or zoned?

