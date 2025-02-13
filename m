Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB21714B7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 22:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484584; cv=none; b=UjK3W+uMz5yyNLD/KmC6eSBT1XGT6Wvp9YshVL9Yx6smSDluHwUffPzklJhI1CoNYzXvptQ+ApHvZRRggv8nDessSex8op+8Kc/77E4pMDbSJmApOWFoEDxudsBdbxThapiNgAwTeTz4BmbHY/WA5veazmi3U6Je9isMdP3pgag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484584; c=relaxed/simple;
	bh=Hi3NK4iYW7xpf2B4mszrJvgMJ7+Y+HuW7bltBKqMZ4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Surv30RgqTeH79KZsbxjL8Jkjgb/LgbSBuftM9Wc+GKqDl/qJ6oAznhJzXCAIxhXIe7UZUeCrjKydshZsaLwHPyi9kz9Wk5afmnhbJX7vzbFf/rUeO9hFqIp5X3ks170d13TjPO4DOzMfP/J55kyfBRdXsJ5MmlkdGRSEmrUHpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUNKdQOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUNKdQOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D57C4CED1;
	Thu, 13 Feb 2025 22:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739484583;
	bh=Hi3NK4iYW7xpf2B4mszrJvgMJ7+Y+HuW7bltBKqMZ4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUNKdQOGUCTx0jNxBXfsbNSMjsQJmbr4hT4fTOPF9u9sz30fygCPD9MUY4mhvmbcz
	 pVUB3dvQ3b4wX4YdRCtrARp84fqRgNL7VEKF0dyC8+W5Gkax6l4BS+8ERMJzGPDEJL
	 RSH6prhMPr3J4O+Ri5QLYEZTWQccmkmEzzxVUAJndIPxngSIviPRI6xNO6qXz2e3ZR
	 GqR67/Xfka5iRg6V88EwwELMNBPf5YxBJ651FiWNq4iM+EuybyixR0sZK5UqeV6ZSs
	 X8chPUCCQXh7Mu50hZA0AK4brxmCoQWrhsgscsOZK9VP6cHWVWhiP5tbRFUDMHlq80
	 lL7duJFPsORjw==
Date: Thu, 13 Feb 2025 14:09:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: add support for zoned space reservations
Message-ID: <20250213220943.GU21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-24-hch@lst.de>
 <20250207175231.GA21808@frogsfrogsfrogs>
 <20250213051749.GD17582@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213051749.GD17582@lst.de>

On Thu, Feb 13, 2025 at 06:17:49AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 07, 2025 at 09:52:31AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:39AM +0100, Christoph Hellwig wrote:
> > > For zoned file systems garbage collection (GC) has to take the iolock
> > > and mmaplock after moving data to a new place to synchronize with
> > > readers.  This means waiting for garbage collection with the iolock can
> > > deadlock.
> > > 
> > > To avoid this, the worst case required blocks have to be reserved before
> > > taking the iolock, which is done using a new RTAVAILABLE counter that
> > > tracks blocks that are free to write into and don't require garbage
> > 
> > Wasn't that in the last patch?  Should this sentence move there?
> 
> The last patch added the counter, it really should be here.  Let me
> reshuffle the patches a bit to make that happen.
> 
> > > +	if (flags & XFS_ZR_NOWAIT)
> > > +		return -EAGAIN;
> > > +
> > > +	spin_lock(&zi->zi_reservation_lock);
> > > +	list_add_tail(&reservation.entry, &zi->zi_reclaim_reservations);
> > 
> > I think you're supposed to have initialized reservation.entry already.
> 
> What do you mean with that?

I think the reservation was declared to be initialized as zeroes, but
there was never an INIT_LIST_HEAD(&reservation.entry) to set the
pointers to each other?

> > > +	int				error;
> > > +
> > > +	ASSERT(ac->reserved_blocks == 0);
> > > +	ASSERT(ac->open_zone == NULL);
> > > +
> > > +	error = xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, count_fsb,
> > > +			flags & XFS_ZR_RESERVED);
> > > +	if (error == -ENOSPC && (flags & XFS_ZR_GREEDY) && count_fsb > 1)
> > > +		error = xfs_zoned_reserve_extents_greedy(ip, &count_fsb, flags);
> > 
> > Overly long line.
> 
> It's exactly 80 characters :)

There are two things I'm bad at: off by one errors.

--D
