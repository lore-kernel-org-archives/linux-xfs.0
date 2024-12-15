Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95081FDD
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 05:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734240439; cv=none; b=OvfeVijszHnI8CE/nT7LTuPvSqe9msjVHhjqMfAtXMC1Rw7eLeTHWlvqoPQUOmuBtVyMBwJ/jomoduL6v2WAzQiJayBztUzIqMEw5Y0KFcKR1p+qwSVzNq8ePf60Qmn9P58rPEhkwdhvXzYYZyuTEIH4u1oohrj1rt7rlhSSV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734240439; c=relaxed/simple;
	bh=4r2CdP+QcXedKOKoL+GpkS6TeU9JVBr2AGc0LUfSHkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gASH/rk636oY+WxPmkx5FfNxcd/JX2+ckOEFa94VoWGtizwo0O7dCUnOR+esuXSwE9yONXzj5gCZIhC+FYmzIgPk7+oLJ2UuTy9r2pKtx38M6au3BlxvMiTnRsjA8LIu3JSFD2kxD7eUJx6GAQK/gceaRw5f6msS3qraInzzyss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6A45C68C7B; Sun, 15 Dec 2024 06:27:13 +0100 (CET)
Date: Sun, 15 Dec 2024 06:27:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/43] xfs: add the zoned space allocator
Message-ID: <20241215052712.GD10051@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-25-hch@lst.de> <20241213183304.GN6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213183304.GN6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 10:33:04AM -0800, Darrick J. Wong wrote:
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	xfs_rgblock_t		rgbno = xfs_rtb_to_rgbno(mp, fsbno);
> > +	struct xfs_inode	*rmapip;
> > +	struct xfs_open_zone	*oz;
> > +	struct xfs_rtgroup	*rtg;
> > +	int			error = 0;
> > +
> > +	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, fsbno));
> > +	if (WARN_ON_ONCE(!rtg))
> > +		return -EIO;
> > +	rmapip = rtg_rmap(rtg);
> > +
> > +	xfs_ilock(rmapip, XFS_ILOCK_EXCL);
> 
> xfs_rtgroup_lock?

Yeah, I'll do an audit for using the proper helpers.

> 
> > +
> > +	/*
> > +	 * There is a reference on the oz until all blocks were written, and it
> > +	 * is only dropped below with the rmapip ILOCK held.  Thus we don't need
> > +	 * to grab an extra reference here.
> > +	 */
> > +	oz = READ_ONCE(rtg->rtg_open_zone);
> > +	if (WARN_ON_ONCE(!oz)) {
> 
> I wonder if this should be using XFS_IS_CORRUPT() instead of
> WARN_ON_ONCE?

Probably.

> > +}
> > +
> > +static int
> > +xfs_zoned_end_extent(
> 
> xfs_zoned_remap_extent?

It doesn't really remap much, right?  It maps, so I guess I could
use that.

