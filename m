Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A1B1EB2B
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F2CBB68AFE; Thu,  4 Jan 2024 08:17:35 +0100 (CET)
Date: Thu, 4 Jan 2024 08:17:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning
 structure
Message-ID: <20240104071735.GB30339@lst.de>
References: <20240103203836.608391-1-hch@lst.de> <20240103203836.608391-6-hch@lst.de> <20240104012133.GM361584@frogsfrogsfrogs> <20240104063218.GI29215@lst.de> <20240104071454.GY361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104071454.GY361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 11:14:54PM -0800, Darrick J. Wong wrote:
> IIRC setting up the shrinker in xfs_alloc_buftarg_common takes some
> shrinker lock somewhere, and lockdep complained about a potential
> deadlock between the locks that scrub takes if I don't create the xfile
> buftarg in the scrub _setup routines.  That's why it's not created
> internally to the xfbtree.
> 
> I agree that it makes much more sense only to create those things when
> they're actually needed, but ... hm.  Maybe we don't need the xfile
> buftarg to be hooked up to the shrinkers, seeing as it's ephemeral
> anyway?  That would save a lot of fuss and ...

Yes, once we move to a model where the buffer always points to
the shmem page, and we remove the buffer lru for them as we already
have the page LRU there is no point in having a shrinker at all.

> > naming and moving it out of scrub/ would make sense as the concept
> > isn't really scrub/repair specific.  But if we want to stick with
> > it I'd prefer to not also have _mem-based naming.
> 
> Yes, lets move it to libxfs/xfbtree.[ch].

What does the xf in the various scrubx/xf* thinks stand for, btw?
Why not libxfs/xfs_btree_mem.[ch]?
