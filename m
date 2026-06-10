Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED0A40D579
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068740; cv=none; b=j9txw/j3zaY4JphndeObryuFYOSVkZJcRcXPG3BxxxoEeZXJZeN5M36MJWcnt94qyHfW/bM6Y5kRtPH9GHdjWmVrMgzRr6nDIyTq3ldbREuq3o2tbminoovJKxFpHFFGJJZGURwXYdKu8w1ablMU0N7qqelYyVkzZnSQFFiDTcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068740; c=relaxed/simple;
	bh=Z8MsFDTC9S4osQFm7eX5pqmIQw3wIwi03ZiR8+/e4QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=makCqsQzJm+/jCvX8kgM3EZR1eFhR+921LQdUgX9pdBzcDgpH3k7L020OuoxjEYr2i3Do2AwWENvvhI1c7zLIo0Q6/ZErV/l2HHEAaksZPuArBoYi/yan/5o4jXln+iW9fB6gizn2YECYGCju5+WEw7EeuMXpMslRmsU5Z5ZrgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45EC668BEB; Wed, 10 Jun 2026 07:18:56 +0200 (CEST)
Date: Wed, 10 Jun 2026 07:18:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: only log freed extents for the current RTG in
 zoned growfs
Message-ID: <20260610051855.GA656@lst.de>
References: <20260610050731.1906760-1-hch@lst.de> <20260610050731.1906760-4-hch@lst.de> <20260610051218.GF6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610051218.GF6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 09, 2026 at 10:12:18PM -0700, Darrick J. Wong wrote:
> > -	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
> > +	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
> > +			xfs_rtgs_to_rfsbs(mp, rtg_rgno(rtg) + 1),
> 
> Heh, I forgot we had a helper for this!

Yeah, if only the person who added it would remember to consistently use
it..

