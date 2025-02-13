Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8671EA90
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739423876; cv=none; b=VKsaF32UGdc6Zgna5TCBioanKNEwKkmPuwrOrbbbxMEeIuR9YGH+wMjRjw8vRJ2IypmyngyuYyNjKrdmzaOGfvlCMx1V22yqjmYiiC4p9ScMryFJ+/COKZyN1fVA7h5M4T1lzutONSC/gKKyDjb19ueMoGC/LpClc9o/lG4PmVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739423876; c=relaxed/simple;
	bh=gAoJ7RAk905aaRgIBwglf3ScO2SPlWDFx+sWoxxuK40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejR0G7nArnkfknp6camsnw/ZigA3hvACxAwSzY4AZ7kyFwQwyZwt1FE9OG/sIT2nH+0fRwr6lZOvw05ggty4gXSr7ZssfQQcstu3USxZYdjPMnKU9QKs2cFx97XfBOoO88oIA+3HWSj1bX0liM1pLLA2YqeAI8IL75tMQJ+FeK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AB8A967373; Thu, 13 Feb 2025 06:17:49 +0100 (CET)
Date: Thu, 13 Feb 2025 06:17:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: add support for zoned space reservations
Message-ID: <20250213051749.GD17582@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-24-hch@lst.de> <20250207175231.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207175231.GA21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 07, 2025 at 09:52:31AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:39AM +0100, Christoph Hellwig wrote:
> > For zoned file systems garbage collection (GC) has to take the iolock
> > and mmaplock after moving data to a new place to synchronize with
> > readers.  This means waiting for garbage collection with the iolock can
> > deadlock.
> > 
> > To avoid this, the worst case required blocks have to be reserved before
> > taking the iolock, which is done using a new RTAVAILABLE counter that
> > tracks blocks that are free to write into and don't require garbage
> 
> Wasn't that in the last patch?  Should this sentence move there?

The last patch added the counter, it really should be here.  Let me
reshuffle the patches a bit to make that happen.

> > +	if (flags & XFS_ZR_NOWAIT)
> > +		return -EAGAIN;
> > +
> > +	spin_lock(&zi->zi_reservation_lock);
> > +	list_add_tail(&reservation.entry, &zi->zi_reclaim_reservations);
> 
> I think you're supposed to have initialized reservation.entry already.

What do you mean with that?

> > +	int				error;
> > +
> > +	ASSERT(ac->reserved_blocks == 0);
> > +	ASSERT(ac->open_zone == NULL);
> > +
> > +	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
> > +			flags & XFS_ZR_RESERVED);
> > +	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
> > +		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
> 
> Overly long line.

It's exactly 80 characters :)

