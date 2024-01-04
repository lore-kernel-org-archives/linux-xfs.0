Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220E81DDEE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dj0rJhoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B99C433C7;
	Thu,  4 Jan 2024 07:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704352495;
	bh=FoP+/ygeTQFcqIwuHyNP3MbzewG9hYnHlbA2h7fvKzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dj0rJhoQCDHKSOlCYRT4uYasoadTvjuNZw5e8C7fyIiab9viiXnii9jNKBBxuKS3e
	 n28tH3LqWfG/FQ1nVp8iZWFBoD78iako4psZpguxjX/OhVV0QFqzKi6czhhp1E/ZOa
	 TLiTkrFCxLoLGYuaCVr5fxKalXp78z4EI9UNKLI/CD64kAy7APwMtxrkRRxlbtY5gQ
	 g0RtoyPyX4qTQd139r4b1F4h1SoSGdHBkS9pKdnxe9xyUoXQMJmbUvHApdVKJo9iLM
	 Rk3esHK5lRtOmxGGw45I9VvgIQlFgA06wt8EQqMwz735sPt27l5QlpDcmtaj7Uha1D
	 KtrS4GASuO/YA==
Date: Wed, 3 Jan 2024 23:14:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning structure
Message-ID: <20240104071454.GY361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-6-hch@lst.de>
 <20240104012133.GM361584@frogsfrogsfrogs>
 <20240104063218.GI29215@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104063218.GI29215@lst.de>

On Thu, Jan 04, 2024 at 07:32:18AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 05:21:33PM -0800, Darrick J. Wong wrote:
> > > -int xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
> > > -		struct xfbtree **xfbtreep);
> > > +int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
> > > +		const struct xfs_btree_ops *btree_ops);
> > 
> > Why not pass the xfs_buftarg and the owner into the init function?  It
> > feels a little funny that the callsites are:
> > 
> > 	xfbt->target = buftarg;
> > 	xfbt->owner = agno;
> > 	return xfbtree_init(mp, &xfbt, btree_ops);
> > 
> > vs:
> > 
> > 	return xfbtree_init(mp, &xfbt, buftarg, agno, btree_ops);
> 
> Yes, but..
> 
> The owner assignment should really just move into the caller of the
> helpers, which would clean things up.
> 
> And the target one I need to fully understand, but maybe let's bring
> this up here and ask the question I was going to ask elsewhere after
> doing a bit more research.
> 
> The way the in-memory buftargs work right now look weird to me.
> 
> Why do we keep the target as a separate concept from the xfbtree?
> My logical assumption would be that the xfbtree creates the target
> internally and the caller shouldn't have to bother with it.

IIRC setting up the shrinker in xfs_alloc_buftarg_common takes some
shrinker lock somewhere, and lockdep complained about a potential
deadlock between the locks that scrub takes if I don't create the xfile
buftarg in the scrub _setup routines.  That's why it's not created
internally to the xfbtree.

I agree that it makes much more sense only to create those things when
they're actually needed, but ... hm.  Maybe we don't need the xfile
buftarg to be hooked up to the shrinkers, seeing as it's ephemeral
anyway?  That would save a lot of fuss and ...

> This also goes further and makes me wonder why the
> xfs_buf_cache is embdded in the xfile and not just allocated when
> allocating a file-backed buftarg?

...maybe we could actually do it this way.  I'll look into it tomorrow.

> Btw, once you start touching the xfbtree can we think a bit about
> the naming?  Right now we have xfbtree but also a xfs_btree_mem.h,
> which seems very confusing.  I think just doing a xfs_btree_mem
> naming and moving it out of scrub/ would make sense as the concept
> isn't really scrub/repair specific.  But if we want to stick with
> it I'd prefer to not also have _mem-based naming.

Yes, lets move it to libxfs/xfbtree.[ch].

--D
