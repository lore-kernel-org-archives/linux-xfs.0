Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84D542BEB9
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253333; cv=none; b=CpD8wlVx3w5mB9vt2gNDuhKOO2pz8FlvNm5YKelJAb8rgTLPj7rxjx8Jd/k01lHQ+RYpQHeJoA6/61DyEKTODc3+TQ7mfrLpcyTrntxEOfnwOJ+BkP6zRYttuilXMnvb3gBlFqC9266oyJAeTnGAgWxn++8iErAUeqptJ1dGU0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253333; c=relaxed/simple;
	bh=E/+3RiJMjllpYoFenX4/Of36jcnSwwHc6ESUltbP9+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzyltNPcOUE1t1zpK11hKrUML/ZaW9zrezZcn9ulpnyHsLlDqwY6YkDqkXghXIEjXqLcx6PwUNHXeAJywYhO0hgz3ZXBdyB8muGHm36sw9/M/qQZQ8TsNyBNCS0Agg7zdAv6vbzUYLM8YS3I2uEL1lvTtwfT6kWiZ5ID03zRpVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E78EC68B05; Tue, 28 Jul 2026 17:42:07 +0200 (CEST)
Date: Tue, 28 Jul 2026 17:42:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, darrick.wong@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: check v5 superblock features early
Message-ID: <20260728154207.GA10775@lst.de>
References: <20260728080435.1777362-1-hch@lst.de> <20260728152628.GN2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728152628.GN2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 28, 2026 at 08:26:28AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 28, 2026 at 10:04:35AM +0200, Christoph Hellwig wrote:
> > When working on a new features that reuses the existing pad in the
> > superblock, I noticed that mounting such a file system on an old kernel
> > logs a rather confusing warning:
> > 
> >     XFS (vdc): Metadir superblock padding fields must be zero.
> > 
> > This is because we only validate the various feature fields in v5
> > superblocks after the common superblock validation helper is called.
> > 
> > Fix this by calling the feature validation first.  To make this more
> > obvious, rename xfs_validate_sb_read to xfs_validate_sb_features and only
> > call it for v5 file systems.
> 
> Shouldn't it be called xfs_validate_v5_sb_features then?
> 
> Oh.  There's already a xfs_sb_validate_v5_features function that checks
> that the v4 feature bits are set correctly for a v5 filesystem, and it
> would be confusing to have both.

Or just stick to the old name :)

> Could we move the code in
> xfs_validate_sb_read into xfs_sb_validate_v5_features instead?

But yes, that does look sensible as well.

> If you do that, then xfs_sb_good_version will validate the feature bit
> recognition, which it doesn't do now.  I'm not sure what weird side
> effects might result from that though.

None in the kernel, but userspace has a lot more callers that need a
careful look.

