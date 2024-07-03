Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F29381D9
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719982698; cv=none; b=EmCwJHr1BoyTkRKXXdHsIIQvdLLDhGGoN5qQWEKGQX5XK5whyHDketdZrjTWkPdVYT/fwQznGE6fqAytH8EWtwF3NIVto55fvit2GivynyrO4PkDQzMCJAIvYQbDkNIiwQ/GWYzGxXr2DXS/PF18x05iyJtlnDIDZSq+LPhOPQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719982698; c=relaxed/simple;
	bh=e/gTV0Wam79UmCx1DIpW5twN2dIA+34/FKLvZ7y713E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MN8INAZ97ClnWMPz2v+VZTCWMjwb7xAKwKtdPxmZZY0LxNGX1DkVG8kHP359EjhEeE5fLfruri6h4sa41Pl8QX9RBGd2dlRuE+n21cblYSv704c1aLNqWBNyX///lHcjZNEmGwKQ9kgU3qQ5QxlFgWN2BjrGmr7gV7fxEpprc3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 004C768AA6; Wed,  3 Jul 2024 06:58:12 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:58:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703045812.GA24691@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs> <20240702053627.GN22804@lst.de> <20240703022914.GT612460@frogsfrogsfrogs> <20240703042922.GB24160@lst.de> <20240703045539.GZ612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703045539.GZ612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 09:55:39PM -0700, Darrick J. Wong wrote:
> > Good question.  As far as I can tell there is no simply ioctl for it.
> > I really wonder if we need an extensible block topology ioctl that we
> > can keep adding files for new queue limits, to make it easy to query
> > them from userspace without all that sysfs mess..
> 
> Yeah.  Or implement FS_IOC_GETSYSFSPATH for block devices? :P

I know people like to fetishize file access (and to be honest from a
shell it is really nice), but from a C program would you rather do
one ioctl to find a sysfs base path, then do string manipulation to
find the actual attribute, then open + read + close it, or do a single
ioctl and read a bunch of values from a struct?

> > > That's going to take a day or so, I suspect. :/
> > 
> > No rush, just noticed it.  Note that for the discard granularity
> > we should also look at the alignment and not just the size.
> 
> <nod> AFAICT the xfs discard code doesn't check the alignment.  Maybe
> the block layer does, but ..

The block layer checks the alignment and silently skips anything not
matching it.  So not adhering it isn't an error, it might just cause
pointless work.

