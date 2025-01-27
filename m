Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E413B784
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 16:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737993801; cv=none; b=lhQsSDNuOn34pZ+bp+gf8tcJk19KCuVIT9Vylw+L+xG67TkuKdjN6guaw2/IRjboq4Hddfn+TPV/Tit3ybYrafF3iFK/NX/C/gJckMvOw3PjvqmKqGrugViIiPuZPcuTksyC0k/sSh8odnsY9jD626hkv050whw6uPX2afPP6h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737993801; c=relaxed/simple;
	bh=Ds8Qcjc88YmGE+NT4AJ/wcO5I74AYKXvyZ4GCmPG404=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LN1SLdegWlkQtVhmQFNYQT91UMXRpTaJskySxWXKA0+vG6O9kypc5M+dTyrYYfyNw9EQn6WMMDkqD2N9YEui+nDDGJgwOWzAaDAa2g77cCCN3M5A4z3rknc+mw7f205odBvrDWk9NJp1wWuYe4pgwkoOLE+uqo4uQb06kOtAJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHQuFCkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHQuFCkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6D0C4CED2;
	Mon, 27 Jan 2025 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737993799;
	bh=Ds8Qcjc88YmGE+NT4AJ/wcO5I74AYKXvyZ4GCmPG404=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GHQuFCkNFExSXYFlV19Sg5JGT9MC6c6xaoqraoS0mj8KIaJsea42/xNBE4XAeIpTF
	 mH0qan6mc9kEEF4d+6p9/oolSlMfe0YT50vRiFkyUg/2UHspT0mKxzxpxPNYr2h6tQ
	 jErppcCMVbytBPbhAzK7dH8ahiQFlaAYdXELW/vy8VpOOFWwlJvxOlTyOcq+teCNtJ
	 9G6sctx8WkRHXIktQY5L07JZfhJWx8LQahVp0Ptw0zWrSZgQx9W7dYkqC2NsJAaHsL
	 S6rogb5BpNkZkspTr4hCuAupjAAMEKHGi/p/yzfEZDaCQpvI2xYtGMb04hI2/3DPzb
	 ca6R6YJ2dcKjQ==
Date: Mon, 27 Jan 2025 08:03:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all.timer: don't run if /var/lib/xfsprogs is
 readonly
Message-ID: <20250127160319.GL3557553@frogsfrogsfrogs>
References: <20250122020025.GL1611770@frogsfrogsfrogs>
 <20250122060230.GA30481@lst.de>
 <20250122071829.GW3557553@frogsfrogsfrogs>
 <20250122072247.GA32211@lst.de>
 <20250122193437.GY3557553@frogsfrogsfrogs>
 <20250127085751.GA22719@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127085751.GA22719@lst.de>

On Mon, Jan 27, 2025 at 09:57:51AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 22, 2025 at 11:34:37AM -0800, Darrick J. Wong wrote:
> > The particular place that I noticed this was on my fstests fleet, where
> > the root filesystem is an ro nfs4 export.  I forgot to configure an
> > overlayfs for /var/lib/xfsprogs, so when I upgraded it to xfsprogs 6.12
> > and left the VMs running on a Sunday morning, they tried to start
> > xfs_scrub_all and failed.  Then the monitoring systems emailed me about
> > that, and I got 150 emails. :(
> >
> > This /should/ be a pretty uncommon situation since (AFAICT) most
> > readonly-root systems set up a writable (and possibly volatile)
> > /var/lib, but I thought I should just turn off the timer if it's going
> > to fail anyway.
> 
> Can you write this up in a comment in the systemd unit file?

Will do!

> With that the patch looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you.

--D
