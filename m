Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD046B98
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 20:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sk7VFKfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E7DC433C7;
	Tue, 28 Nov 2023 20:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701202293;
	bh=CYx8N/aGd4Yu09eVthx+H1dX2X3E2rC81GEd1bD12a0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sk7VFKfwyTowmQwrDWgyE9DsJKXh4fMu1PtFHYl7KXQvobjtfM+YVsWAIE6Cw/aRF
	 GR2H+ilDTH6qYyO+R9G8HYAEsZv9euLlsHPJJxV1FUQWKuJTj30FybYXZEIqqFxfj1
	 ang8IQg5I4CO/YUjn7U4wNQMfMVbOJ90RYpLgNDwsAb5vNILv+0OEixe/5dqNSGdaM
	 kZaGqvoIC+XgNP5pn/ygumYwBC4r7pYkl1q01sDGJcGBqr+lpyw9IupuOQxtHvwOQJ
	 Qio7uyARL6YsODT8hkWXgN+CGOG1DuF1fs6npnz9WF111H0mH9P51T6MEpGJPo+4Kl
	 Q5gL/LMQw6wBA==
Date: Tue, 28 Nov 2023 12:11:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: constrain dirty buffers while formatting a
 staged btree
Message-ID: <20231128201133.GA4167244@frogsfrogsfrogs>
References: <170086926569.2770816.7549813820649168963.stgit@frogsfrogsfrogs>
 <170086926640.2770816.12781452338907572006.stgit@frogsfrogsfrogs>
 <ZWGL4tBoNDoGND7F@infradead.org>
 <20231127225631.GI2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127225631.GI2766956@frogsfrogsfrogs>

On Mon, Nov 27, 2023 at 02:56:31PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 24, 2023 at 09:53:38PM -0800, Christoph Hellwig wrote:
> > > @@ -480,7 +500,7 @@ xfs_btree_bload_node(
> > >  
> > >  		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
> > >  
> > > -		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
> > > +		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
> > >  				&child_bp);
> > 
> > How is this (and making xfs_btree_read_buf_block outside of xfs_buf.c)
> > related to the dirty limit?
> 
> Oh!  Looking through my notes, I wanted the /new/ btree block buffers
> have the same lru reference count the old ones did.  I probably should
> have exported xfs_btree_set_refs instead of reading whatever is on disk
> into a buffer, only to blow away the contents anyway.

And now that I've dug further through my notes, I've realized that
there's a better reason for this unexplained _get_buf -> _read_buf
transition and the setting of XBF_DONE in _delwri_queue_here.

This patch introduces the behavior that we flush the delwri list to disk
every 256k.  Flushing the buffers releases them, which means that
reclaim could free the buffer before xfs_btree_bload_node needs it again
to build the next level up.  If that's the case, then _get_buf will get
us a !DONE buffer with zeroes instead of reading the (freshly written)
buffer back in from disk.  We'll then end up formatting garbage keys
into the node block, which is bad.

		/*
		 * Read the lower-level block in case the buffer for it has
		 * been reclaimed.  LRU refs will be set on the block, which is
		 * desirable if the new btree commits.
		 */
		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
				&child_bp);

The behavior of setting XBF_DONE in xfs_buf_delwri_queue_here is an
optimization if _delwri_submit releases the buffer and it is /not/
reclaimed.  In that case, xfs_btree_read_buf_block will find the buffer
without the DONE flag set and reread the contents from disk, which is
unnecessary.

I'll split those changes into separate patches with fuller explanations
of what's going on.

--D

> --D
> 
