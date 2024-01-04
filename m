Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E67200A6
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fn0nqJf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CFEC433C8;
	Thu,  4 Jan 2024 07:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704353612;
	bh=pQPruek3o9JchDQVoDkbSvZHAJ3L0pzNrQHovkUuHjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fn0nqJf8m+B/FZQkGKcRnFjTx17s6BBNF613PYeFQmRa2GZoRA1roZNYTMHQ8xSF1
	 m/+oYHthX2vdWPXxOfIKAuYKX8z7WHuKwPul9NppXMU74GDc+eT38ZiEEbZfcX7A62
	 5ZmkQgR9haELXmz7CsH9ocRCCIDYLQTjgQuDvwIJEFGJIjULx4xujhhJRBUlckjUZy
	 V+9RNC4MVy9yDgo2UHP/tATb6wEbmBC7za3F5YRy/2KyiT58tvmm5ZmvWK0LZARIKP
	 W8w0ovpkm4tFsmtEy16ibquXYkCNPbjoxRqkFj/eYGkRfTyTw1+cs2wlbvfmUd7LYJ
	 IArNHuM8ubX6A==
Date: Wed, 3 Jan 2024 23:33:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 8/9] xfs: support in-memory btrees
Message-ID: <20240104073331.GE361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
 <ZZZUkq145pW64Zzo@infradead.org>
 <20240104072752.GC361584@frogsfrogsfrogs>
 <ZZZek95Tyfuxz8RQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZek95Tyfuxz8RQ@infradead.org>

On Wed, Jan 03, 2024 at 11:30:27PM -0800, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 11:27:52PM -0800, Darrick J. Wong wrote:
> > > Btw, one thing I noticed is that we have a lot of confusion on what
> > > part of the bc_ino/ag/mem union is used for a given btree.  For
> > > On-disk inodes we abuse the long ptrs flag, and then we through in
> > > the xfile flags.  If you're fine with it I can try to sort it out.
> > > It's not really a blocker, but I think it would be a lot claner if
> > > we used the chance to sort it out.  This will become even more
> > > important with the rt rmap/reflink trees that will further increase
> > > the confusion here.
> > 
> > Go for it! :)
> 
> Happy to do it you don't complain about all the rebase pain it'll
> cause..

You might want to wait a bit for my XFS_BTREE_ -> XFS_BTGEO_ change to
finish testing so I can repost.  That alone will cause a fair amount of
rebasing.

> > > That means xfs_btree.c can use the target from it, and the owner
> > > and we can remove the indirect calls for calculcating maxrecs/minrecs,
> > > and then also add a field for the block size like this one and remove
> > > a lof of the XFS_BTREE_IN_XFILE checks.
> > 
> > Sounds like a good idea.
> 
> Same here.
> 
> > 
> > > > +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> > > > +		return 0;
> > > > +
> > > >  	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
> > > >  		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
> > > 
> > > Should the xfile check go into  xfs_buf_readahead instead?  That would
> > > execute a little more useles code for in-memory btrees, but keep this
> > > check in one place (where we could also write a nice comment explaining
> > > it :))
> > 
> > Sure, why not?  It's too bad that readahead to an xfile can't
> > asynchronously call xfile_get_page; maybe we wouldn't need so much
> > caching.
> 
> Actualy page lookup or allocation never is async, so this would only
> be about reading swap from disk.  And given what a mess the swap code
> is I don't think we'll have an async read for that any time soon.

Yeah, I was afraid you were gonna say that. :(

--D
