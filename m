Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06764219EA;
	Fri,  6 Feb 2026 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770399770; cv=none; b=U+BHsCpoAiD0v4MXc0o7SsWLsQDbHKVS9u0ODte0B8FI5TV4ZJfVJIKYFXRPmlsjGAjm7lVZeTwtzCnAvQVEoJadOmSFOM0iLMovcgEWLwnYC3nylh0bP1T2rgw9rohqyYMUZpMtQQionKWPJKA6vWKzr0PQynEAKVa5i+ARhEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770399770; c=relaxed/simple;
	bh=eNJmIb5koQUG9PEJGuhNbm5WYTOM+0rPQAPgKszuWSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ST9LWIsGBDga/WZOOl9n1nAYhIxsVqWxQcNJw5I2CgaNI9JTCGc1fzJwdf1kZRgOyi67HL6UX9RXMxyi7em2g1rcokoZEKOfk4NcI4gAK3HG5DyypYvfwX0qaXohXoXwcnK8XOb66c0MLlV0zJeBl7Vxcc1JrNw1jiM4lYnt4ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G3jOW1Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G3jOW1Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB0DC19422;
	Fri,  6 Feb 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770399769;
	bh=eNJmIb5koQUG9PEJGuhNbm5WYTOM+0rPQAPgKszuWSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G3jOW1TzFYHRzH4c888JMdxPstz1/9vFvXCkJpcLhWaJMTAxyxj2mv5Jcv+StTe0C
	 cdG4mcL8mzrXPDSwgnvyd6ahvvF2quNcAo+YJzixcBs0FaMj66HNsWNrkTrMLrzO3i
	 lbaQONTMuph4klV2qdeTMS2HTUmIr3jtPyXUuyjIw+Vz3BwhELaQJ8Mz8bUepxDmQD
	 fP293XajWgIZAlcJT7CPsEiKde0U06muNpZevnHzNM6u3LMODWAtC2S9Zg3LDoxG5G
	 79PHvNVhQGsJGEMg5g93uw2geo0a9sX8qzr+4o9QbjYBTSq3srJBZeoqiYdJUgAtAU
	 nIhA7tg0BHDKA==
Date: Fri, 6 Feb 2026 09:42:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <20260206174248.GZ7712@frogsfrogsfrogs>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
 <aXEvAD5Rf5QLp4Ma@bfoster>
 <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
 <aXN3EtxKFXX8DEbl@bfoster>
 <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
 <20260206062527.GA25841@lst.de>
 <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>

On Fri, Feb 06, 2026 at 03:37:38PM +0530, Kundan Kumar wrote:
> On 2/6/2026 11:55 AM, Christoph Hellwig wrote:
> > I fear we're deep down a rabbit hole solving the wrong problem here.
> > Traditionally block allocation, in XFS and in general, was about finding
> > the "best" location to avoid seeks.  With SSDs the seeks themselves are
> > kinda pointless, although large sequential write streams are still very
> > useful of course, as is avoiding both freespace and bmap fragmentation.
> > On the other hand avoiding contention from multiple writers is a good
> > thing.  (this is discounting the HDD case, where the industry is very
> > rapidly moving to zoned device, for which zoned XFS has a totally
> > different allocator)
> > 
> > With multi-threaded writeback this become important for writeback, but
> > even before this would be useful for direct and uncached I/O.
> > 
> > So I think the first thing I'd look into it to tune the allocator to
> > avoid that contention, by by spreading different allocation streams from
> > different core to different AGs, and relax the very sophisticated and
> > detailed placement done by the XFS allocator.
> 
> When you say "coarse-grained sharding", do you mean tracking a single
> "home AG" per inode (no per-folio tagging) and using it as a best-effort
> hint for writeback routing?
> 
> If so, we can align with that and keep the threading model generic by
> relying on bdi writeback contexts. Concretely, XFS would set up a 
> bounded number of bdi wb contexts at mount time, and route each inode to 
> its home shard. Does this align with what you have in mind?
> 
> We had implemented a similar approach in earlier versions of this
> series[1]. But the feedback[2] that we got was that mapping high level
> writeback to eventual AG allocation can be sometimes inaccurate (aged
> filesystems, inode spanning accross multiple AGs, etc.), so we moved to
> per folio tagging to make the routing decision closer to the actual IO.
> That said, I agree that the per folio approach is complex.
> 
> Darrick, does this direction look reasonable to you as well?

Yeah, I think a simpler scheme would be a better starting place; we can
make things more complex later once we can show that there's a need.

--D

> 
> [1] 
> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
> [2] https://lore.kernel.org/all/20251107133742.GA5596@lst.de/
> 
> 
