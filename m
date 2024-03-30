Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4F9883C
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 05:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711778221; cv=none; b=EwCqpVHpSYIEy/5flYu8GkS09HwcoGuGyyfsuZchtXi45VYpUsP/b9/M810nobCSPr4yRt0MmI2BujD8zEiJfSE6jJFwMiaGll8W9bhd2aSR4vBTCqN6cALHKnPGgkzHpjLsXYG7+rVtefpPC3aciKtThkpOw8kvkkKgXK+qMgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711778221; c=relaxed/simple;
	bh=nsMpASkJqvGganZmr4rsc5f4pIkQEYHqks3MYt4DZqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoWyanOvdljkgA6Qn5c4/5/eCwMGrku9zvrIhxeEVDBxAiTq5ukoKRu/muvbIok6hLP9CpRM+5xu55xrTn9BRQioVPifbDcy9JUPTa4nIaX395KXRwwc1yshaaM3WTkbFISbggQ00uPxY70ull9JLGHErvHF98n3SkR+cvB7CFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C0D568B05; Sat, 30 Mar 2024 06:56:55 +0100 (CET)
Date: Sat, 30 Mar 2024 06:56:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check if_bytes under the ilock in
 xfs_reflink_end_cow_extent
Message-ID: <20240330055654.GA24680@lst.de>
References: <20240328070256.2918605-1-hch@lst.de> <20240328070256.2918605-2-hch@lst.de> <20240329161429.GE6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329161429.GE6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 29, 2024 at 09:14:29AM -0700, Darrick J. Wong wrote:
> This unlocked access was supposed to short-circuit the case where
> there's absolutely nothing in the cow fork at all, so that we don't have
> to wait for a transaction and the ILOCK.  Is the unlocked access
> causing problems?

I've not observeved problems.  But I can't see how this access can
be race free.  Note that this case can only happen if we have racy
direct I/O writes, so I'm not sure trying to optimize performance for
it makes much sense.

> > +	/* No COW extents?  That's easy! */
> > +	if (ifp->if_bytes == 0) {
> > +		*offset_fsb = end_fsb;
> > +		goto out_cancel;
> > +	}
> 
> This is already taken care of by the clause that comes below
> the end of this diff:


> Since xfs_iext_lookup_extent will return false if the cow fork tree is
> empty.
> That said, I think the xfs_iext_count_may_overflow stuff is misplaced --
> we should be querying the cow fork extent and bouncing out early before
> we bother with checking/upgrading the nextents width.  If
> xfs_iext_count_upgrade dirtied the transaction, the early bailout will
> cause a shutdown.
> 
> (The iext upgrade only needs to happen after the bmapi_read.)

Yes, I guess the right thing is to move the upgrade later and then
just let xfs_iext_lookup_extent handle the no extents case.
