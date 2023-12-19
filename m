Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD8EBE59
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 04:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5A1468AFE; Tue, 19 Dec 2023 05:17:55 +0100 (CET)
Date: Tue, 19 Dec 2023 05:17:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs: rename xfs_bmap_rtalloc to
 xfs_rtallocate_extent
Message-ID: <20231219041755.GA30404@lst.de>
References: <20231218045738.711465-1-hch@lst.de> <20231218045738.711465-23-hch@lst.de> <20231218222430.GW361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218222430.GW361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 18, 2023 at 02:24:30PM -0800, Darrick J. Wong wrote:
> > -xfs_bmap_rtalloc(
> > +xfs_rtallocate_extent(
> >  	struct xfs_bmalloca	*ap)
> 
> Hmm.  I'm still not sure I like the name here -- we're doing an rt
> allocation for a bmap allocation args structure.
> 
> xfs_rtalloc_bmap?
> 
> (Or just drop this one, I've lost my will to fight over naming.)

I have to say I don't really like the bmap in the low-level allocator
to start with, but maybe for that to happen we need to stop passing
the xfs_bmalloca structure.

So droppign it and living the with the pre-existing name for now until
we can clean up the whole are further seems like a good plan to me.
