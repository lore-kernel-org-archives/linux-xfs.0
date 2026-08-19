Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E9C37475B;
	Wed, 19 Aug 2026 23:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787182227; cv=none; b=JFYXT2OM67A/OQAcE36FQNW20R7D6CdxoeL6UjRFyLdf6EC4ZyfMcHSeKiCqXxBBajXpLSBRT+a1pi73YYp1AzxHsTTM1Tt1ADaFZzDBlq2OYc7RLZ9nOwn3WKcWWhG/9lA6ThWz60LEuH2vokzWDo/AuwJ5wzgFg9luewAQCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787182227; c=relaxed/simple;
	bh=8Iw1U5pGc70aMMwVaNrcN8fEBP8J93smjw8l3aseGVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9f9msYxP3ZWCG6xU65PM9F2rCkgTclz66qhjl7/reA8s+CQbK1EShBST0wRbAfNjX4tnAulOuVRASyRCYhtXuJT8rMUpanmrXFxGD2pIt07eAh1S++hGdCca9oujd3YIrfTxSlFEytOoR9DxcQS+1lVtBFR7TLghw+set5CU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMPAbZFr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMPAbZFr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5282A1F000E9;
	Wed, 19 Aug 2026 23:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787182226;
	bh=5WGjeYTHMaQ10etp1Q4zg42jJ9SEkLl1Q6F1MzgCNZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PMPAbZFrLavfGbp79aUg3oFrFxwgp8bBUl/bFfCwah2JCOM1epuOweaS7sGZ0hipG
	 GjtlYel6s0wVhVburtDF4L5sxwSZaqXdeI9Xgl5WHXWTFU2vKrKiFdo2IZgtkOBOQs
	 J4v1VviP2Uq0HlqQGaPVU5NMYikZEXHo7QrGGclwy/NT4InH7B+YIdKoyoZ/DpzHV2
	 vH9Fg7elzkV/NBezyrhaqABBh03U7Vq4698FYZ/oRtTieiocXYaM+9gyhaRcE410uJ
	 xwzOCA2+KGtyHrVEkIGKKvLPlmkyyCGQXsRkDXy948xYXHgawDZS6tnxP4tIPgxPee
	 j9QZBx0IegSBA==
Date: Wed, 19 Aug 2026 16:30:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
Message-ID: <20260819233025.GF6072@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
 <aoVKR4HmS3Hi7WBg@infradead.org>
 <20260819231943.GD6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819231943.GD6072@frogsfrogsfrogs>

On Wed, Aug 19, 2026 at 04:19:43PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 18, 2026 at 11:16:39PM -0700, Christoph Hellwig wrote:
> > On Wed, Aug 12, 2026 at 10:25:40PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > It's possible to construct an in-memory rtrmap btree for filesystems
> > > that don't have the rmap feature enabled.  The kernel doesn't do this,
> > > but xfs_repair will, if asked to reindex a filesystem that has rtreflink
> > > enabled but not rtrmap.  Therefore, we must create the cursor with
> > > enough levels to handle a maximally sized btree possible.
> > 
> > Should repair initialize m_rtrmap_maxlevels instead of overallocating
> > in the kernel?
> 
> I'd prefer not to because (a) m_rtrmap_maxlevels is used in various
> places (like computing transaction reservations) outside of creating
> in-memory btrees and that would be weird on a non-rmap filesystem; (b)
> the regular rmap code in xfs_repair already allocates biggish cursors
> for in-memory btrees this way; and (c) I don't think it matters much
> even in the kernel because if we're that low on memory then we're not
> going to be able to create a replacement rmap record set in memory to
> stage the rmapbt regeneration anyway.
> 
> That said, a more targetted way would be to add a maxlevels parameter to
> xfs_{rt,}rmapbt_mem_cursor() and let the caller figure out the optimal
> setting for their context -- online repair can use
> mp->m_{rt,}rmap_maxlevels because it only creates in-memory rmap btrees
> when rmap is enabled; and xfs_repair can use
> xfs_{rt,}rmap_maxlevels_ondisk() for the weird (reflink && !rmap) case.
> 
> How does that sound?

On second thought ... the slab cache that we use to create rtrmapbt
cursors always makes them big enough for xfs_rtrmap_maxlevels_ondisk()
levels, so we always consume that much memory no matter what we set
bc_nlevels to in xfs_rtrmapbt_mem_cursor().

--D
