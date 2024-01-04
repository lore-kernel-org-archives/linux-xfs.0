Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8D41DFE3
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kIqYtBld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08966C433C7;
	Thu,  4 Jan 2024 07:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704352921;
	bh=PJDWXqsP537GDtVkRhbJ1MxC/RlAdsdz4MHSIRUKjsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kIqYtBldkPDUtahoq+RuknnqAM9gSpjvfU/nGvmmGqwQ9wf7L/GeROR+NFCWU+2tk
	 lYi9cyXmpd8U/tOemN9uFRs+l4YO/ixkHVp5NmX7WRjosh8Uq3QF+cP8kif6bdae2q
	 +af+A7oyNn9UJOaOGj/NUd/j9+S5C5m3d0ldCR1tr+v63/PQtJ92bOwITTi9ioslIZ
	 B6b9+22tl8FLyVatZ76Q95zPJzRg0TWpMlJjNeweHlpmduC3wOS+BksEXmerNnlOEt
	 AshWrIJa+dYb3dL4U2eXP55SzLCMP1/nN122+fH/ORB7zw4AULWtYQOdLh/uQjMSfX
	 aQk7K+Cu+akBA==
Date: Wed, 3 Jan 2024 23:22:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning structure
Message-ID: <20240104072200.GB361584@frogsfrogsfrogs>
References: <20240103203836.608391-1-hch@lst.de>
 <20240103203836.608391-6-hch@lst.de>
 <20240104012133.GM361584@frogsfrogsfrogs>
 <20240104063218.GI29215@lst.de>
 <20240104071454.GY361584@frogsfrogsfrogs>
 <20240104071735.GB30339@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104071735.GB30339@lst.de>

On Thu, Jan 04, 2024 at 08:17:35AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 03, 2024 at 11:14:54PM -0800, Darrick J. Wong wrote:
> > IIRC setting up the shrinker in xfs_alloc_buftarg_common takes some
> > shrinker lock somewhere, and lockdep complained about a potential
> > deadlock between the locks that scrub takes if I don't create the xfile
> > buftarg in the scrub _setup routines.  That's why it's not created
> > internally to the xfbtree.
> > 
> > I agree that it makes much more sense only to create those things when
> > they're actually needed, but ... hm.  Maybe we don't need the xfile
> > buftarg to be hooked up to the shrinkers, seeing as it's ephemeral
> > anyway?  That would save a lot of fuss and ...
> 
> Yes, once we move to a model where the buffer always points to
> the shmem page, and we remove the buffer lru for them as we already
> have the page LRU there is no point in having a shrinker at all.

Ok.  I'll move the shrinker stuff into the real buftarg creation
function.  This seems to have become a lot simpler now that the shrinker
is a pointer instead of embedded in the buftarg.

> > > naming and moving it out of scrub/ would make sense as the concept
> > > isn't really scrub/repair specific.  But if we want to stick with
> > > it I'd prefer to not also have _mem-based naming.
> > 
> > Yes, lets move it to libxfs/xfbtree.[ch].
> 
> What does the xf in the various scrubx/xf* thinks stand for, btw?
> Why not libxfs/xfs_btree_mem.[ch]?

"xfile btree".

--D
