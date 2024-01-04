Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481342C19E
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 19:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ly2y13KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA28C433C7;
	Thu,  4 Jan 2024 19:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704396502;
	bh=1rWHZbpeffuPuWasYZpe7xRmQrWpqZw2KRnoleF11Ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ly2y13KFRKmyLdYd/4wIKg/AmsRh489WK22nzeO+U2xtFBLr2/k5EquwmN2uJjAe7
	 KUU8BXyCv495hab0Y/2s3pmTw2yhy4Su4GGpPhvF8TlfL2c74I5oPVllPpD1YLWXdo
	 L5MRmXay+mryfKzO6Y07HG96Sov+LQJxojboNtbt4g4CcWYzI7Tt4pCTA582jgvQ1q
	 3Zy97p5LcGtWtxVJ2bHE85caPDeom6Pf9CO6ZdG6IORc5iYvxpRXQWeckGI7gur9Ug
	 eGVV6blM0MXJ07MKTDX5yt+U+20IGUcsQCO17E8H7XmWAgAUv90qxzGEouQARyxeqw
	 BjJumIL1V/GbA==
Date: Thu, 4 Jan 2024 11:28:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning structure
Message-ID: <20240104192822.GI361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-6-hch@lst.de>
 <20240104012133.GM361584@frogsfrogsfrogs>
 <20240104063218.GI29215@lst.de>
 <20240104071454.GY361584@frogsfrogsfrogs>
 <20240104071735.GB30339@lst.de>
 <20240104072200.GB361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104072200.GB361584@frogsfrogsfrogs>

On Wed, Jan 03, 2024 at 11:22:00PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 04, 2024 at 08:17:35AM +0100, Christoph Hellwig wrote:
> > On Wed, Jan 03, 2024 at 11:14:54PM -0800, Darrick J. Wong wrote:
> > > IIRC setting up the shrinker in xfs_alloc_buftarg_common takes some
> > > shrinker lock somewhere, and lockdep complained about a potential
> > > deadlock between the locks that scrub takes if I don't create the xfile
> > > buftarg in the scrub _setup routines.  That's why it's not created
> > > internally to the xfbtree.
> > > 
> > > I agree that it makes much more sense only to create those things when
> > > they're actually needed, but ... hm.  Maybe we don't need the xfile
> > > buftarg to be hooked up to the shrinkers, seeing as it's ephemeral
> > > anyway?  That would save a lot of fuss and ...
> > 
> > Yes, once we move to a model where the buffer always points to
> > the shmem page, and we remove the buffer lru for them as we already
> > have the page LRU there is no point in having a shrinker at all.
> 
> Ok.  I'll move the shrinker stuff into the real buftarg creation
> function.  This seems to have become a lot simpler now that the shrinker
> is a pointer instead of embedded in the buftarg.

Though looking at buftarg allocation and my old notes from a couple of
years ago -- a second reason for allocating the buftarg during scrub
setup was that the list_lru_init call allocates an array that's
O(nodes_nr) and percpu_counter_init allocates an array that's
O(maxcpus).  At the time I decided that it was better to put those large
contiguous memory allocations in the ->setup routine where we don't have
any vfs/xfs locks held, can run direct reclaim, and haven't done any xfs
work yet.

So I'd like to leave the buftarg attached to struct xfs_scrub, though
I'll still get rid of the shrinker for xfile buftargs.

--D

> > > > naming and moving it out of scrub/ would make sense as the concept
> > > > isn't really scrub/repair specific.  But if we want to stick with
> > > > it I'd prefer to not also have _mem-based naming.
> > > 
> > > Yes, lets move it to libxfs/xfbtree.[ch].
> > 
> > What does the xf in the various scrubx/xf* thinks stand for, btw?
> > Why not libxfs/xfs_btree_mem.[ch]?
> 
> "xfile btree".
> 
> --D
> 
