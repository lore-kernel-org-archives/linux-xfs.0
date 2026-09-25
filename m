Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473741922FD;
	Fri, 25 Sep 2026 05:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315938; cv=none; b=depqGasz9cMsVR1kg5ui2Qj9ghEIZtPK3QHptzE/R7hXo2OrfnVrgqCCUos51nRz2F4CCIXcJwY3EwBJkKZWZJKuYK0z+r3LjE4nPJHYCybmWAsfoPX5L5g6pTjEsPaeHhSetDezeCYdfH0v7nbCNhCRgSVxuKTWdzyjAYCyB9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315938; c=relaxed/simple;
	bh=Pb5UpWyjCynA7VxF3UBK2Nj2I8q0bhSdVxovvlcb/bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wyxgn/+du6KhfkBpK8IqaSA1NwNJc/FX6sttuBCT2tfJMoY4s4mHEiTkmRgVklt/lIr6y1nrQlT6Gw/VvBkiXj41boKiyrLNmPDHNTua0yFNOLFkrMoNd3Y3syxiMFoWbUGxjkEGPiwKOtnLcZ/KVEp8Ly5eWy6MqLvY4rFluQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A49568BFE; Fri, 25 Sep 2026 07:58:53 +0200 (CEST)
Date: Fri, 25 Sep 2026 07:58:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/21] xfs: prepare xfs_rtfile_initialize_blocks for
 larger than FSB blocks
Message-ID: <20260925055853.GD3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-7-hch@lst.de> <20260924220311.GH2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924220311.GH2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:03:11PM -0700, Darrick J. Wong wrote:
> > +	size_t			copylen = len;
> > +	struct xfs_trans_res	tres = M_RES(mp)->tr_growrtzero;
> >  	struct xfs_trans	*tp;
> >  	struct xfs_buf		*bp;
> > -	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
> >  	int			error;
> >  
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
> > +	tres.tr_logres *= nblks;
> 
> Hmm.  Is it safe to multiply the log reservation by an arbitrary
> block count?  I would think we'd want *some* guarantee that we can't
> create a transaction that's larger than the log can support.
> 
> It might suffice to put in a safeguard like:
> 
> 	/* Log should always be able to handle 64k of logged buffers */
> 	ASSERT(nblks <= XFS_B_TO_FSB(mp, SZ_64K));

Sounds good.  Or recalculate the entire reservation, but that feels a bit
wasteful.

> > +	if (xfs_has_rtgroups(mp))
> > +		copylen -= sizeof(struct xfs_rtbuf_blkinfo);
> 
> This is how we maintain copylen as the amount of non-header data to copy
> out of *data, correct? 

Yes.

> I suppose that means that the checksum file blocks also have a header?

Yes.  We need this to see if the checksums are corrupted, and then with
the follow on series potentially read it from another mirror.
