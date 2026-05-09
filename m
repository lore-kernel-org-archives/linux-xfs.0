Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD3A95E
	for <linux-xfs@vger.kernel.org>; Sat,  9 May 2026 00:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778288082; cv=none; b=qMPspwYFbzkjr4dxqSCXjUs5ImppbwBQDqHtxEH2IHr3tVuU9zwJzbeyUMv38eSAPzVfHprOuwP1fA16+BMDs3dyBW+bQul5S/p8NKDDyCx0bupPfjqIlkQOs6v3VNtvQCJv92qwL/LRlMFf8RFdT+nnHSAor3VnyBLcZzi/3hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778288082; c=relaxed/simple;
	bh=7/jCYR44pByV9kMAB6LEFrkEwPRMj5mjzX6sRoaAvUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUPIfYCNaB092OCMFoZJuv5KkEt1BEkGyaWuu9BxRjtTXI8m4fWU0O0WC+qIWEek1FlXYt2RmNKIKCL0NmL3YJGSWW9H2Du8Bz72LbpD6bk+MdYqVQAmzJUMETKUAZd/YZzPrKIZe1dm7gSYNlslDDv6PFqYG5QJcq9vRwwW0NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUw/xYaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUw/xYaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A25C2BCB0;
	Sat,  9 May 2026 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778288082;
	bh=7/jCYR44pByV9kMAB6LEFrkEwPRMj5mjzX6sRoaAvUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUw/xYaDEKdpufkp+DlDQLurnMyAdhimSKIF5u/m0j3SETQf0f1KaZTAuNk9q9Hwr
	 d+CYa/hxHwiE60YoFRbNWpDAE38l/Zd8Ylvldg6WlLXseG9ckxLekXfhp1HNlWTkVf
	 Xuo25aEZyewCZqUzXxdqQJHRHkQzyiJx8S1WWlC+LGv1mytnTzR+qr7wpscLVlQsHr
	 iOj+yRjMqQrzO9zuKnTtaM1MONJK67Qw7br1b0fYTRKX8fbj8Ams1IXqwOWJzoPLMy
	 IvBga7pEFJfS0LfgIs0GuPtPUmtiI9J1G6twWkrXLk9Gojv72luStr7NfD4UAT8bjb
	 d5tdsWSAuXpxw==
Date: Fri, 8 May 2026 17:54:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve RT geometry validation
Message-ID: <20260509005442.GL7751@frogsfrogsfrogs>
References: <20260507052543.1305129-1-hch@lst.de>
 <20260507171758.GJ7751@frogsfrogsfrogs>
 <20260508081651.GA19827@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508081651.GA19827@lst.de>

On Fri, May 08, 2026 at 10:16:51AM +0200, Christoph Hellwig wrote:
> On Thu, May 07, 2026 at 10:17:58AM -0700, Darrick J. Wong wrote:
> > Isn't this already covered by xfs_validate_sb_rtgroups?
> 
> From a quick look it should...
> 
> > > -		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> > > -		if (mod)
> > > +		if ((sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) &&
> > > +		    mod > 0)
> > >  			return false;
> > 
> > And shouldn't this be in xfs_validate_sb_zoned?
> 
> This just slightly moves code.
> 
> > Or do you want this in xfs_validate_rt_geometry because that's what
> > xfs_repair calls to check the superblock?
> 
> I guess.  At least it was repair that went off on my badly messed up
> file system without this fix.
> 
> Maybe it's time to go back to the drawing board for the sb validation.

Yeah, it's unfortunate that xfs_repair duplicates most of that sb
validation code just so it can return an enum instead of xfs_err()ing
all over the place. :/

--D
