Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F934A79D
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778228216; cv=none; b=JbYhDBfAB3Ip0owM+0LxyJKTCmO65PqzWeKB23cYmtGJ8YT96GuDMIXCPCm0Yp3TRQycLm9jjVzepXO/4qwtFQHCTVNoyffCwauBBBUXKHY/NnVm8xtsLdwpaxt6xpm+HGbsa9oxd1ZaFYAQHIP4jTwQj2Ej6vZ0Hxbv0pMoywM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778228216; c=relaxed/simple;
	bh=RmyUAa8pjii6W/PfUX7I+1luKcFaSerq15W3oQZ3sRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uisfXNDZGZlzjnWTQE4PMPNqSLFcjOH/wlRwYYcADjMlwCD90MX1446t6b72gBhOOoQOKilNNM8WBABqpVH2hY2wwnDPG4xaOxfFptJH6bzHURoI9IEQOUK5UXiveuwHjb11Y8Qzax6cH8slDr48wohxGtRGzc8NRifSYADM7+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1955768BEB; Fri,  8 May 2026 10:16:52 +0200 (CEST)
Date: Fri, 8 May 2026 10:16:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve RT geometry validation
Message-ID: <20260508081651.GA19827@lst.de>
References: <20260507052543.1305129-1-hch@lst.de> <20260507171758.GJ7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507171758.GJ7751@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 07, 2026 at 10:17:58AM -0700, Darrick J. Wong wrote:
> Isn't this already covered by xfs_validate_sb_rtgroups?

From a quick look it should...

> > -		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
> > -		if (mod)
> > +		if ((sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) &&
> > +		    mod > 0)
> >  			return false;
> 
> And shouldn't this be in xfs_validate_sb_zoned?

This just slightly moves code.

> Or do you want this in xfs_validate_rt_geometry because that's what
> xfs_repair calls to check the superblock?

I guess.  At least it was repair that went off on my badly messed up
file system without this fix.

Maybe it's time to go back to the drawing board for the sb validation.

