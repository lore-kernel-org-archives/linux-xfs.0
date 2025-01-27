Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF11FCCEC
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968285; cv=none; b=UbGQi/Iu484CK9Z4oMMwwJPFOn4dacoUWDm26XwJu49ub7SRNgOucYYssMOJBCgvUQUjMxmBGmI5GJ73jGkb6wt6CTx4ckfhPJZw5Hap7/CqpadzZqjd4d2jN1F3Ob0xsiABEIyWw3s5QXt1pR63jSpvHiEFcS2MBCVEUqOFbRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968285; c=relaxed/simple;
	bh=xNx7mmSZ8vgTyuKApIJSHsYnq15icSjHYIo3t0gRCW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9B825d/xJ9KgLC+eUSf7fv4yQL8iPZj10ZghvE8WhSw/jQrg8H3kC2kT9yGTZTVZi5MGrXiUM3I48V6xLSy4/9GAgtR/nhIVVEzRBtqmx9zyzBIsgAMRXnlf8QpghBFtN5vQ69w2ru8tpYL8lbu9N7AWx1Cea0xOwwDQQeoVe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2177F68C7B; Mon, 27 Jan 2025 09:57:52 +0100 (CET)
Date: Mon, 27 Jan 2025 09:57:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250127085751.GA22719@lst.de>
References: <20250122020025.GL1611770@frogsfrogsfrogs> <20250122060230.GA30481@lst.de> <20250122071829.GW3557553@frogsfrogsfrogs> <20250122072247.GA32211@lst.de> <20250122193437.GY3557553@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122193437.GY3557553@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 22, 2025 at 11:34:37AM -0800, Darrick J. Wong wrote:
> The particular place that I noticed this was on my fstests fleet, where
> the root filesystem is an ro nfs4 export.  I forgot to configure an
> overlayfs for /var/lib/xfsprogs, so when I upgraded it to xfsprogs 6.12
> and left the VMs running on a Sunday morning, they tried to start
> xfs_scrub_all and failed.  Then the monitoring systems emailed me about
> that, and I got 150 emails. :(
>
> This /should/ be a pretty uncommon situation since (AFAICT) most
> readonly-root systems set up a writable (and possibly volatile)
> /var/lib, but I thought I should just turn off the timer if it's going
> to fail anyway.

Can you write this up in a comment in the systemd unit file?

With that the patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
