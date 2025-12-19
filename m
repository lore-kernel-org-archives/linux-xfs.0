Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A796C2D877B
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 23:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188785; cv=none; b=KksHp8LdYIj5o0YnKZa/sbYQbnrrHABDNqrwkKxoU9aCWeqAEe5wL6vJr4C37dPtE2fA1JYujkgkGUdQ0vnAoDPZilw5m3HdPXf0ojLZ3IOwjG+tDIlzjPp5fssjfnzrX2wTKpMSS0+iggRCgJQ52ShquwnOjvjxqHzF2NHPwD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188785; c=relaxed/simple;
	bh=BqFlGFR7BUDzdEAW3P5WBxkICTdb9zYMq459fp7GzwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaPMNqEwbg49egJuvSRrCsPZyxbUvrFJyt7xRgPdlUVebPwUGII+8ZATzc7Wu0/5JrJQvprDyc3QLau/Yr+EgqWYRhsefidscI5HoEdAM9gb1ZrvHH7N/htGw87rg2d0BkfuAIDh9UsDXJNkbC7b76NTxjtJdIiv98Z4hO6NhFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7762WJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7762WJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB9BC4CEF1;
	Fri, 19 Dec 2025 23:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766188785;
	bh=BqFlGFR7BUDzdEAW3P5WBxkICTdb9zYMq459fp7GzwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i7762WJfJaNKaJG4Tt8doJIFwyDr+5SVvowOA072fM0f49wWUBsgiK0Yij8OSgZHP
	 vpQAfj8mD28hxe7yHM9A+gvTOPq7av0dYBJjKWRo29lZQIujANkThT6jFmHdkDj/ey
	 9lCWLLtaEgF2+T+S3+VB8Ac+gzXphdWKrWdURFQbxDIrmFFeRbxrHKFzgHRRGFSYo9
	 kQBf06IKXupqibyi0NqP8pLA2ICKKCaPmFN0388KRx5i/KIpH8StOkwoASLjj7IQFl
	 irLKJUdg2bJN8bpfGeV3attUetJzVUdhBCHi+fsXjl1HGfIK7K6CVd+dciRswYntDB
	 6bYwjdiGZ5GYw==
Date: Fri, 19 Dec 2025 15:59:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v2 0/3] Enable cached zone report
Message-ID: <20251219235944.GH7725@frogsfrogsfrogs>
References: <20251219093810.540437-1-dlemoal@kernel.org>
 <20251219235602.GG7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219235602.GG7725@frogsfrogsfrogs>

On Fri, Dec 19, 2025 at 03:56:02PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 19, 2025 at 06:38:07PM +0900, Damien Le Moal wrote:
> > Enable cached zone report to speed up mkfs and repair on a zoned block
> > device (e.g. an SMR disk). Cached zone report support was introduced in
> > the kernel with version 6.19-rc1.  This was co-developped with
> > Christoph.
> 
> Just out of curiosity, do you see any xfsprogs build problems with
> BLK_ZONE_COND_ACTIVE if the kernel headers are from 6.18?
> 
> > Darrick,
> > 
> > It may be cleaner to have a common report zones helper instead of
> > repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
> > However, I am not sure where to place such helper. In libxfs/ or in
> > libfrog/ ? Please advise.
> 
> libfrog/, please.

and since I hit [send] without providing a reason, I'll request a
do-over:

libfrog/, please.  That's where we stuff all the support code, ioctl
wrappers, and data structures for xfsprogs nowadays.  It's better than
cluttering up libxfs/.

--D

> --D
> 
> > Thanks !
> > 
> > Changes from v1:
> >  - Fix erroneous handling of ioctl(BLKREPORTZONEV2) error to correctly
> >    fallback to the regular ioctl(BLKREPORTZONE) if the kernel does not
> >    support BLKREPORTZONEV2.
> > 
> > Damien Le Moal (3):
> >   libxfs: define BLKREPORTZONEV2 if the kernel does not provide it
> >   mkfs: use cached report zone
> >   repair: use cached report zone
> > 
> >  libxfs/topology.h | 8 ++++++++
> >  mkfs/xfs_mkfs.c   | 7 ++++++-
> >  repair/zoned.c    | 7 ++++++-
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > -- 
> > 2.52.0
> > 
> > 
> 
