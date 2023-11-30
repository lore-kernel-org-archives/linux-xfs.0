Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA7E197
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nN9cotrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E187C433C8;
	Thu, 30 Nov 2023 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701303047;
	bh=GKt4bTYIuJ85NgT2pCpRYgYQMlcAJ+vKGaEciM9iMS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nN9cotrx4bt943b6yiYrDH8CJbFBHFkd/WMlUYpjPnlSSB9jnmsU63GxvBQUlr8Pe
	 LA7ZShEhyA2D8rgybyLWSpCQwgW+BhX7Hh7xFVgygrxSFGmx/lqa8E8grSfew4PI/6
	 27+Wx3LJJrjODUHaFdopDs6q8QxIzLxQNGZK4RLKsCh7Xl6x/z+wB3mYk4h3dbEw08
	 3txoljzkTAuurgb/ecb3lIFhG4WMM00xvTRUFBbpIIzvxVCV9EzvFcOuOGix2i2S4N
	 l+fpuoEBBwA8h0/JIU8yNZbXqPL0XSnhq78vM2tbARYpp+cZu4OZJ4cpgODXU+zzyg
	 uxuuvLibESZlA==
Date: Wed, 29 Nov 2023 16:10:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: check rt summary file geometry more thoroughly
Message-ID: <20231130001046.GG361584@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
 <170086928377.2771542.14818456920992275639.stgit@frogsfrogsfrogs>
 <ZWXzvNHCV6QWeikg@infradead.org>
 <20231128233008.GF4167244@frogsfrogsfrogs>
 <ZWbUvcVIBROrHVOh@infradead.org>
 <20231129062155.GC361584@frogsfrogsfrogs>
 <ZWbY7a2ZB8LE0Prh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbY7a2ZB8LE0Prh@infradead.org>

On Tue, Nov 28, 2023 at 10:23:41PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 10:21:55PM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 28, 2023 at 10:05:49PM -0800, Christoph Hellwig wrote:
> > > On Tue, Nov 28, 2023 at 03:30:09PM -0800, Darrick J. Wong wrote:
> > > > LOL so I just tried a 64k rt volume with a 1M rextsize and mkfs crashed.
> > > > I guess I'll go sort out what's going on there...
> > > 
> > > I think we should just reject rt device size < rtextsize configs in
> > > the kernel and all tools.
> > 
> > "But that could break old weirdass customer filesystems."
> > 
> > The design of rtgroups prohibits that, so we're ok going forward.
> 
> Well, as you just said it hasn't mounted for a long time, and really
> this is a corner case that just doesn't make any sense.  I'd really
> prefer to cleanly reject it, and if someone really complains with a good
> reason we can revisit the decisions.  But I strongly doubt it's ever
> going to happen.

Oh, even better, Dave and I noticed today that if you format a 17G
realtime volume (> 2^32 rt extents) then mkfs fails because there's an
integer overflow:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/mkfs/xfs_mkfs.c#n3739

Based on your observation that rt free space never exceeds the group
length with rtgroups turned on, I'll tweak the sb_rextslog computation
so that it's computed with (rgblocks / rextsize) instead of (rblocks /
rextsize) which will fix that problem for future filesystems.

--D
