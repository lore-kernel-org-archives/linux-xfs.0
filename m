Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72394347FDC
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 23:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762299571; cv=none; b=UxOCbT9ucgooiI4l/dsoYzgZuMKadfUPY++Gemtnlp6ZWTmezSuxSx55tXv2H7T95O4X0SeV3cNncdr9hyTOUKblDftehQqQp0nOjkwU2KJXfO6zPkT1dtLGSde+S/08Xm1OY1l66whQ+g4mPoXLEx7ELt7HsGZneAB9JWGHQco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762299571; c=relaxed/simple;
	bh=QFGOFIN5sZk+/T2KDcDYbudaVi5Gh2Nbc8e6BIIb5BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5qi5WDE10/DPoeMYhjZ+reaa1ijeMpjgW55prh20NOB6sauh4IqfONNv0dK0nYIeJV1p/Bx3bRLUO1ks/+MGJ5XamDfKZjNmwH50h711P+h83iD2RXphKSVGonrwlsNfrLEIlmuP8wc6Z0aJOaon6oN+tpW0RgcaBTNcCIuPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pFot7Hgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pFot7Hgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C07BC4CEF8;
	Tue,  4 Nov 2025 23:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762299571;
	bh=QFGOFIN5sZk+/T2KDcDYbudaVi5Gh2Nbc8e6BIIb5BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pFot7HggXovLhd8eGZpwJTVzdW3Ec/c/ZaPRa7rMxix0BZlQG08c1POxT9YKJyYp1
	 AUBh2j6CqqXd5altSykRU6h8R+Ua0KDl5M83rN4//+xwLrRt+4d1x63V4nqGbmpRPY
	 KXkYv7yKGRdtOmaNLT3FKHrF6OED8XCt/nLuG72l2QOZZyGIcNtl9FGG6uNUZp0HZd
	 elPWmQ6u6YVtTJ/HXZ3w4NA1zNe924LSbns9yn1U2vrGu8WE7O5KsNNKyPtzywMJYU
	 mAVJn2QyhPPakAihdf4HYnkmmvNtEC5zLE6Xd0BiATVblSKXzyeGfQDqmNQnPWQEWa
	 wYwAa53xfR7Nw==
Date: Tue, 4 Nov 2025 15:39:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: set lv_bytes in xlog_write_one_vec
Message-ID: <20251104233930.GP196370@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-3-hch@lst.de>
 <20251101000409.GR3356773@frogsfrogsfrogs>
 <20251103104318.GA9158@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103104318.GA9158@lst.de>

On Mon, Nov 03, 2025 at 11:43:19AM +0100, Christoph Hellwig wrote:
> On Fri, Oct 31, 2025 at 05:04:09PM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index ed83a0e3578e..382c55f4d8d2 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -858,14 +858,15 @@ xlog_write_one_vec(
> > >  	struct xfs_log_vec	lv = {
> > >  		.lv_niovecs	= 1,
> > >  		.lv_iovecp	= reg,
> > > +		.lv_bytes	= reg->i_len,
> > 
> > I'm surprised that nothing's noticed the zero lv_bytes, but I guess
> > unmount and commit record writes have always wanted a full write anyway?
> > 
> > Question: if lv_bytes is no longer zero, can this fall into the
> > xlog_write_partial branch?
> 
> The unmount format is smaller than an opheader, so we won't split it
> because of that, but unless I'm misreading things it could fix a bug
> where we'd not get a new iclog when needed for it otherwise?

Yeah, I think that's theoretically possible.  I wonder what that would
look like to generic/388 though?  I haven't seen any problems with log
recovery for a while other than the large xattr thing, so maybe it's not
worth worrying about.

> The commit record is just an an opheader without any payload, so there
> is no way to even split it in theory.

<nod>

--D
