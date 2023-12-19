Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC407C120
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVRkEEqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54449C433C8;
	Tue, 19 Dec 2023 04:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702961463;
	bh=UNdVjtgWJae6bJHcOE0s83UhXKsRV9WG4yIEuhz9S/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TVRkEEqkAidUmOxsTfi3fYvDpp/Zd2QnXfk6hAGWGlpfIYZybchISUZXn17xclWch
	 ytMUrr/xQqt9WC3J6etbWpNTE0SUokQdC5GPWGcY7tWjfs8amfnW60FLya40YOKnt4
	 NYQZEKsH1lVliiBK3wRZj/aj3QlSE163IIFoFCD0+0N/oLdOnfmO8xnvahCjDiWP0s
	 H53BgeR9zLPCUeS5PA8JgPNJE+IlTdUDRtOKjJuC79EQJJTPrOT1m9Yd2gO5VaXSGK
	 6rB7nb/q9pcGB7TXigFFXofXiBoV/FxTYgI9lSJvTcf1DwDLAfr0knMVdu6uhmBWWx
	 c6LH2USSxfySQ==
Date: Mon, 18 Dec 2023 20:51:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs: rename xfs_bmap_rtalloc to
 xfs_rtallocate_extent
Message-ID: <20231219045102.GG361584@frogsfrogsfrogs>
References: <20231218045738.711465-1-hch@lst.de>
 <20231218045738.711465-23-hch@lst.de>
 <20231218222430.GW361584@frogsfrogsfrogs>
 <20231219041755.GA30404@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219041755.GA30404@lst.de>

On Tue, Dec 19, 2023 at 05:17:55AM +0100, Christoph Hellwig wrote:
> On Mon, Dec 18, 2023 at 02:24:30PM -0800, Darrick J. Wong wrote:
> > > -xfs_bmap_rtalloc(
> > > +xfs_rtallocate_extent(
> > >  	struct xfs_bmalloca	*ap)
> > 
> > Hmm.  I'm still not sure I like the name here -- we're doing an rt
> > allocation for a bmap allocation args structure.
> > 
> > xfs_rtalloc_bmap?
> > 
> > (Or just drop this one, I've lost my will to fight over naming.)
> 
> I have to say I don't really like the bmap in the low-level allocator
> to start with, but maybe for that to happen we need to stop passing
> the xfs_bmalloca structure.
> 
> So droppign it and living the with the pre-existing name for now until
> we can clean up the whole are further seems like a good plan to me.

Ok by me!

--D
