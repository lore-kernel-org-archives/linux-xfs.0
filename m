Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25541292D5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706816; cv=none; b=EkDF7OB2iQ/QsCAc6uN8RIrXCMMtz2RJDGjLvqxzuNuazYTHT3JPV3CtuuzGJWoHroQX4XXOBZmSv7jrXdUzArfBoKiJYTI4Pp/NfCUeiWGrODiGmMvi4Vcw+GpvN1WW1Y34CmM8mcr1F45PGqNUXCsj48HljVH06KBSznRXtQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706816; c=relaxed/simple;
	bh=DOqzSp2z3r/vpqgFcCToL7UlelFasjojS8Sn4qBr3Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aN1FnEl7v3v5i8AURNeCfyf15zRyJOO0TDSQlXbVodRPIDBzhErOYZBscgkUR7ICf6d1aLKOJGzH2XRh9Hlc5ETFA+tBDUoq0uRKbO6bV3D0wW8ReM9Rc2nhOCyvbU0sAL8PS7p9o9UbgLtcM+ru1azO0IEsk/gna6tqScY94KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwYxQVbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwYxQVbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861F4C433F1;
	Fri, 23 Feb 2024 16:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708706816;
	bh=DOqzSp2z3r/vpqgFcCToL7UlelFasjojS8Sn4qBr3Hc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwYxQVbgpQeq3syz1/Tcw0eAZ1ZcDLb9Q/De3aOH98ZJmJApLYirUVbPvhqTZ18Um
	 VMKilJuTLh4obgClYv5MCRHiQnE0oiOgHH8I09sMB4gbhxQ4MPfee4St3huSTlGoZ1
	 YJn3qzrNtWvm/G3CeGrZbCrbEQPHAsVUOEMan+JHK/MQ6kl8xs81EJLQQNprmour1E
	 eJQOF8wz6Ou8/iHTn0uGw9AVjtLkbAFrYKaP6mTWlrsBXTdlTVekwZv657eU+61Mp3
	 IWEe/vfcawWQxR2CY1yoTs+EA/GM8aD41ovxbSFS8mepdQhDtjqoZp6bjhkaWNOTcD
	 u4kBMKHNwY8yQ==
Date: Fri, 23 Feb 2024 08:46:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240223164655.GO616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-3-hch@lst.de>
 <20240223163448.GN616564@frogsfrogsfrogs>
 <20240223163737.GA3410@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223163737.GA3410@lst.de>

On Fri, Feb 23, 2024 at 05:37:37PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 08:34:48AM -0800, Darrick J. Wong wrote:
> > I don't really like using transaction flags to record lock state.
> > 
> > Would this be cleaner if we tracked this in struct xfs_rtalloc_args, and
> > had an xfs_rtalloc_acquire(mp, &args, XFS_ILOCK_{SHARED,EXCL}) method
> > that would set that up for us?
> 
> Urgg, that would be pretty ugly, and not work for the new locking in the
> extfree item once you add that, which has the same weird layering
> violation.

<nod> Dave occasionally talks about turning allocation into a log intent
so that we could decouple both of these things.  I think the difficulty
there is that you need a way for the allocator to notice that a
particular "free" extent is actually "busy".  That's trivial for the
bnobt allocator, but nonexistent for rtalloc.

> The only "sane" way out would be to always use a deferred item, which we
> should be doing for anything using new RT features, but we can't really
> do that for legacy file systems without forcing a log incompat flag.
> So while I don't particularly like the transaction flag it seems like
> the least evil solution.

I had thought about doing that for rtgroups=1 filesystems. :)

--D
