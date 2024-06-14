Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3FB26AF1
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 04:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718338391; cv=none; b=MKfxSL9scgb3YWkd2+o+wEN42pzXPUhXskHrlHL/hIFaREGgv7Q1jXtSdjP3M1TTlTjOxFqTv98BbTmeUSPxmxhyrm4zpY3a45rTew8zN6GYf+lvXZh46RbBnuEQZk1AYd+MIywmrqR9PvhsAhfAcnsgbLKtPTdLdf4j+w/q3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718338391; c=relaxed/simple;
	bh=/iGAvzE4OR/U9lUkjSAK5g+Uo67UdAzBuV5ed86b8mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfHlda9wfA+ZawOBOXqbxlOkdf2o2sJ2+Nzk3/281CON+gT0UXS1LQVB4KMTbmOD3K9MsjnCbvV+HfU0R6YP/ue1IGCC1q9gVC3ExGffp9/v8aLW5DzbzmcgSyJfF915iu8LVpBau7eSQEGAdhxZp+ponJMq9ZCaNjMSn4Z4z4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MAZ1wc2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MAZ1wc2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F99C2BD10;
	Fri, 14 Jun 2024 04:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718338390;
	bh=/iGAvzE4OR/U9lUkjSAK5g+Uo67UdAzBuV5ed86b8mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MAZ1wc2IYetubYxb/r2IiScBiNQpt4MPSc0gomUZGTMnRsnQLFF/OtWeYDb2pQrRE
	 0THSxC/Myol+7NkxLjO5uHOArh6z0ri87DZmtmu+vTUnW3E4F3s871Aqsbgg1K8Umh
	 1b51j64++lEHer5blSy9iUAUaz1smtc+hFsKRlhvghCwW4+K6ESZ7jRR5YTCTQrEw7
	 wZQo1BnpoW849lRq0akfVZzeDw080zjMt9L4H3BBBeQ3tvfXF9OCnOsc2S/vYo4ftx
	 93AP3yGd37sQcvs02bHyNIVeZN1OCoDjqMj/ZCLvGIS6iEgr70i+viaIWSoSrkbSrl
	 IsojAqHhUrhaQ==
Date: Thu, 13 Jun 2024 21:13:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: restrict when we try to align cow fork delalloc
 to cowextsz hints
Message-ID: <20240614041310.GG6125@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs>
 <20240613050613.GC17048@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613050613.GC17048@lst.de>

On Thu, Jun 13, 2024 at 07:06:13AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 12, 2024 at 10:47:19AM -0700, Darrick J. Wong wrote:
> >  	xfs_filblks_t		prealloc,
> >  	struct xfs_bmbt_irec	*got,
> >  	struct xfs_iext_cursor	*icur,
> > -	int			eof)
> > +	int			eof,
> > +	bool			use_cowextszhint)
> 
> Looking at the caller below I don't think we need the use_cowextszhint
> flag here, we can just locally check for prealloc beeing non-0 in
> the branch below:

That won't work, because xfs_buffered_write_iomap_begin only sets
@prealloc to nonzero if it thinks is an extending write.  For the cow
fork, we create delalloc reservations that are aligned to the cowextsize
value for overwrites below eof.

--D

> > +	/*
> > +	 * If the caller wants us to do so, try to expand the range of the
> > +	 * delalloc reservation up and down so that it's aligned with the CoW
> > +	 * extent size hint.  Unlike the data fork, the CoW cancellation
> > +	 * functions will free all the reservations at inactivation, so we
> > +	 * don't require that every delalloc reservation have a dirty
> > +	 * pagecache.
> > +	 */
> > +	if (whichfork == XFS_COW_FORK && use_cowextszhint) {
> 
> Which keeps all the logic and the comments in one single place.
> 
> 
