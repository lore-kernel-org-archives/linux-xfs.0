Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65428149C41
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734286440; cv=none; b=hliYzMWWxX8+ybupTqmk1bp5XgFx9IuATu/noe9BdGgYP68dHoBGsizpHh6mDgQeYIbRnKzy6rskngqhIrl2y3Q3FQuWNK248Io1rxyfFTgObQztdhkS/Exw5lEKXNCF6y5td/lO7itLWalf2OGqv3TUzGkaX6b9aNryx37x6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734286440; c=relaxed/simple;
	bh=JfzmxNN3YHa70TFFY+RhqXZ2r0UcOSrB40PtaBTRxyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r4U9K2FcopOBq64Bh/PFCl43sOodL/ObsgQU4Itytq33hmRylZcpab8nrpJpry7/PQkghs4r4uPbUfeQ/pIh2Hz/cgR7X5FjEN0PLQRWIS9q6AOtFlO/x3HLML8m784S+p4KrSbq9do0cNalYu7LuODCxNC7EU4L8HNGmQUSQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1WbItMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1WbItMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F05C4CECE;
	Sun, 15 Dec 2024 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734286440;
	bh=JfzmxNN3YHa70TFFY+RhqXZ2r0UcOSrB40PtaBTRxyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R1WbItMu56yG+SfulCMd3GOQAhw7btr+F5hJCodW/x2Q6xYulgOvcK7dc6xXK4MJt
	 ZPFdXeIJC6lzQs8YVANyPSzxakrTYn25oFkzSwztBXha/lWg2hSUPg50IwpVf1x2f5
	 tudo2bSPqqIM0BGVNNbFM16sSDQyYrukAQ3/4rZMJApQo636rDMfVstxN6ld6fhFUO
	 4sXum+zn05iCDP2UT7JM7W2C3cc176aT4lzC18DkjIL9RBaqrRykANCwuLDIU8zotc
	 OhMYJyCPyk91FNICmc6Bf+3Nf2s3DaH0lyz2Mi5zbqeTH/cFu8kBXZBIfQehOHowIG
	 lQ0n6sQ6zZOGg==
Date: Sun, 15 Dec 2024 10:13:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/43] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
Message-ID: <20241215181359.GB6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-5-hch@lst.de>
 <20241212211843.GQ6678@frogsfrogsfrogs>
 <20241213050439.GB5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213050439.GB5630@lst.de>

On Fri, Dec 13, 2024 at 06:04:39AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 01:18:43PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:29AM +0100, Christoph Hellwig wrote:
> > > Delalloc reservations are not supported in userspace, and thus it doesn't
> > > make sense to share this helper with xfsprogs.c.  Move it to xfs_iomap.c
> > > toward the two callers.
> > > 
> > > Note that there rest of the delalloc handling should probably eventually
> > > also move out of xfs_bmap.c, but that will require a bit more surgery.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Not opposed since we /could/ move this back if userspace ever (a) grows
> > a fuse server and (b) decides to use delalloc with it, but is this move
> > totally necessary?
> 
> It's not totally necessary, we could also mark xfs_bmap_worst_indlen and
> xfs_bmap_add_extent_hole_delay non-static and be done with it.  But then
> again I'd rather reduce the unused libxfs sync surface if I can.

<nod>

Does anyone else have an opinion?  Particularly any of the past xfsprogs
maintainers?

--D
