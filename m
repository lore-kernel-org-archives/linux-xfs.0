Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375F81F0E59
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952909; cv=none; b=nKqENURoUmO3j2x8zs8V2f/6We8DyUE06DgZ7GrR9a7eh2KpFsr5qB04NN0tXjnAApMOg8w+QZgq+/GZksLp3TMebAu5YhWzNSXgARz2uSrG0yGp3MXb7xbdnzCejGjyPgcS/6Bm4ziVqLlOS1x3dO9z4cb0S2re+wOgkf2237w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952909; c=relaxed/simple;
	bh=kXG4Esic747a8kKSJ+xC0Yyf0n/clYQtFZc0pEuRhYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmTSEu/xkL5/NXb/ac+VTtMkTAgt84ilJO8IAYmmi66VNzLlTBBeC2mgEAeQoBHskiB7hmZnwUGTii0jVObw45PMo3cLdnF1/+dEzhG4Uye7o3PXTrtWojSYrAFM8eukwiQ62lgSdTR2K/TDUvUhT3sqpWO4/v5AsAg9FehDG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FPS9BFnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FPS9BFnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B31C4CEEA;
	Wed, 11 Dec 2024 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952909;
	bh=kXG4Esic747a8kKSJ+xC0Yyf0n/clYQtFZc0pEuRhYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPS9BFnrBUi4rdhR2MqhwrH/QFy1o1ZfhZxcA140dbxqbf8bsNboTYC8qlaUHga7s
	 dA1e88zaZp8Bz09UAgDpO1jKQeJH2tr/x82p2yhYlUlL2A8LXRZWtj6w/FxUnkX6NS
	 L5jo0a88s9JlujSwWOdYNydO0ZY4Uje/LzijGWJUREAFxZceN0BycoM/lc0MVIZ5hg
	 tp9jrnWBAbise17awdfs62GKEtV3qDEsMYjq8ZFTgXdO8EYJGnPrreSrHRUfyy3aQy
	 bvrsgVR0/1PV+CmUZnd4WlFKTcZd+gWI12WUEHkXFbIS32msXw3fozi9JmYT7m2pWf
	 lJN5z2CL3elTQ==
Date: Wed, 11 Dec 2024 13:35:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/50] xfs_db: support changing the label and uuid of rt
 superblocks
Message-ID: <20241211213508.GU6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752388.126362.13051985148596315963.stgit@frogsfrogsfrogs>
 <Z1fUsP8hMfDnJ6Fz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fUsP8hMfDnJ6Fz@infradead.org>

On Mon, Dec 09, 2024 at 09:42:08PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 04:12:31PM -0800, Darrick J. Wong wrote:
> >u +	struct xfs_mount	*mp)
> > +{
> > +	int			error;
> > +
> > +	if (!xfs_has_rtsb(mp) || !xfs_has_realtime(mp))
> 
> Nit: I would have expected the checks to be reversed just from a reading
> flow perspective:
> 
> 	if (!xfs_has_realtime(mp) || !xfs_has_rtsb(mp))
> 
> But in the end it does not matter.

I changed the order, since everywhere else does it this way too.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
