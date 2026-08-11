Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5D135CB6D
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786460614; cv=none; b=Tr6NEWlu0uIpQQUUmwh9LLBRoiS2VWICvK3busFbS7nnJs6VeFulNwRU/sIq73AJTlWnMv9LXDdp8/KvYdIcOjqSNP9NDK7U0/k2w/UamHfehrFRAwPPj0A7BcEpYYJji+PBlZy8cfdbz1F9hE07ItU/rluoPFbowLI62RmFEtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786460614; c=relaxed/simple;
	bh=0IIwoZey/5ItVIhSxAp7dq9pRsSX5+eyAKIIEMNQP8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuqW1yIRkZr8mBlj/VGnWDYBEQTvlA+HJMfQixpDQ6Py4/X1rDDiECmIHsxtcj8AYYd5655HcxPlhpuBBqYZhN+0Y9Rt0H6/DH8pZt8MKxOXjWTqNEy6hbBY4xvDd2BdNpWXrN6560Imlsin5sFB+iWZ/HozdLfGoHvaa1EcjKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8BD436732A; Tue, 11 Aug 2026 17:03:20 +0200 (CEST)
Date: Tue, 11 Aug 2026 17:03:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: fix racy open zone caching
Message-ID: <20260811150320.GA19302@lst.de>
References: <20260810153759.466417-1-hch@lst.de> <20260810153759.466417-3-hch@lst.de> <20260810182142.GW3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810182142.GW3556460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 10, 2026 at 11:21:42AM -0700, Darrick J. Wong wrote:
> > +	if (oz && !atomic_inc_not_zero(&oz->oz_ref))
> > +		oz = NULL;
> 
> Do we still need to test oz for null-ness here?  AFAICT we've already
> handled those cases here.

Yeah, that can go away.

> > +	spin_lock(&ip->i_flags_lock);
> > +	old_oz = VFS_I(ip)->i_private;
> > +	if (old_oz && old_oz->oz_allocated < rtg_blocks(old_oz->oz_rtg))
> > +		swap(oz, old_oz);
> >  	atomic_inc(&oz->oz_ref);
> 
> Hmm, I'm confused about oz_ref handling here.
> 
> If old_oz still has space, we swap oz and old_oz, after which oz alias
> i_private and old_oz is the zone that the caller passed in.  The above
> line then increments oz->oz_ref and puts the zone that the caller passed
> in.
> 
> Doesn't that cause oz->oz_ref to be too high?  We already had a ref
> via i_private, and now we have another one.

The caller needs a reference, and i_private needs a reference.  But this
is a bit to oclever to understand, we probably should be doing
atomic_inc_not_zero for the i_private case as well.  I'll rework this
to be a bit more clear.

