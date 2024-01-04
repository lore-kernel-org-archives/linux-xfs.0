Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB21DFE5
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E499C68AFE; Thu,  4 Jan 2024 07:32:18 +0100 (CET)
Date: Thu, 4 Jan 2024 07:32:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning
 structure
Message-ID: <20240104063218.GI29215@lst.de>
References: <20240103203836.608391-1-hch@lst.de> <20240103203836.608391-6-hch@lst.de> <20240104012133.GM361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104012133.GM361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 05:21:33PM -0800, Darrick J. Wong wrote:
> > -int xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
> > -		struct xfbtree **xfbtreep);
> > +int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
> > +		const struct xfs_btree_ops *btree_ops);
> 
> Why not pass the xfs_buftarg and the owner into the init function?  It
> feels a little funny that the callsites are:
> 
> 	xfbt->target = buftarg;
> 	xfbt->owner = agno;
> 	return xfbtree_init(mp, &xfbt, btree_ops);
> 
> vs:
> 
> 	return xfbtree_init(mp, &xfbt, buftarg, agno, btree_ops);

Yes, but..

The owner assignment should really just move into the caller of the
helpers, which would clean things up.

And the target one I need to fully understand, but maybe let's bring
this up here and ask the question I was going to ask elsewhere after
doing a bit more research.

The way the in-memory buftargs work right now look weird to me.

Why do we keep the target as a separate concept from the xfbtree?
My logical assumption would be that the xfbtree creates the target
internally and the caller shouldn't have to bother with it.

This also goes further and makes me wonder why the
xfs_buf_cache is embdded in the xfile and not just allocated when
allocating a file-backed buftarg?

Btw, once you start touching the xfbtree can we think a bit about
the naming?  Right now we have xfbtree but also a xfs_btree_mem.h,
which seems very confusing.  I think just doing a xfs_btree_mem
naming and moving it out of scrub/ would make sense as the concept
isn't really scrub/repair specific.  But if we want to stick with
it I'd prefer to not also have _mem-based naming.
