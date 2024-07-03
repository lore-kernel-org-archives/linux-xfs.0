Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4681C69A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719980967; cv=none; b=IA/c65A8L2ZLaEEWeg2hyBNDaA3YX/TeALjXtfZEQ+NxPcjttwgf8o7dWD12ass2nKxaULiQL8imEZl6a9wvOeGHlo687qsFwgOOYu4f2us2kU0Gv2jJ6CEsfytLnQyxEJPvE5v+jo+pCL7WsrhEuIFVbYUcCPstkWOnPTr81hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719980967; c=relaxed/simple;
	bh=mwiD9BvesPeA4GLBSPoEElX6eJESWKCEMOZ7A9Mly24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9UarT8PgtONTKyJ9tMP43RmAsyeUVFx2Hej6OffKZUsG4usx81U751P0m8jFXP42jQRXDjxLKqFE20Gw60gjyc7caXf+qDZ77xvRKlO93h7LEF3R93H3YxxL1A3FLGQ855lPeiESsiOmRXvjGp7dfg1i9RNHaQuPj/Jbx11MCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0101F227A87; Wed,  3 Jul 2024 06:29:22 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:29:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240703042922.GB24160@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs> <20240702053627.GN22804@lst.de> <20240703022914.GT612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703022914.GT612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 07:29:14PM -0700, Darrick J. Wong wrote:
> Oooh, that's a good idea.  Let me fiddle with that & tack it on the end?
> 
> Hmm.  How do we query the discard granularity from a userspace program?
> I can try to guess the /sys/block/XXX root from the devices passed in,
> or maybe libblkid will tell me?  And then I'd have to go open
> queue/discard_granularity underneath that to read that.

Good question.  As far as I can tell there is no simply ioctl for it.
I really wonder if we need an extensible block topology ioctl that we
can keep adding files for new queue limits, to make it easy to query
them from userspace without all that sysfs mess..

> That's going to take a day or so, I suspect. :/

No rush, just noticed it.  Note that for the discard granularity
we should also look at the alignment and not just the size.
