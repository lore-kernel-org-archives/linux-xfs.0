Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A32817996
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719981088; cv=none; b=is5WBCibrTIA5B13niunp/kgRv3uhimVjhPKvj5N6wNGaAYjtf5gFW6+A7QDEZrWhveLHm3/fFI6bjisbwBjwicqgFPLg3XImLsJP32irWU/k1jBVQs9G52CkRbHhfzhNCKnszuyLkQ2TmEmp/rtx0mWCUoN3cwtx4d444VcQr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719981088; c=relaxed/simple;
	bh=DzbEBGIK9hgyCoPiq4Oxzv6H+NeIKJAdLeoh+EhynjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbakCTntXPZdLxLyxo+98bXtUHPDPC+6LgW9brHrnLDPV8qW8mk9CIVoymFIKPm9/69u6AjAjqIegjMBQQXqcSnnSt+shrsthv8TwBRkPishRRld66tUWRKrsur2bBMMyjZDMG6jErOyGrtAkkRwfn8bQUcTWu9kTEPgi/PClbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 507B7227A87; Wed,  3 Jul 2024 06:31:24 +0200 (CEST)
Date: Wed, 3 Jul 2024 06:31:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240703043123.GD24160@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs> <20240702054419.GC23415@lst.de> <20240703025929.GV612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703025929.GV612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 02, 2024 at 07:59:29PM -0700, Darrick J. Wong wrote:
> CONFIG_XFS_ONLINE_SCRUB isn't turned on for the 6.9.7 kernel in sid, so
> there shouldn't be any complaints until we ask the kernel team to enable
> it.  I don't think we should ask Debian to do that until after they lift
> the debian 13 freeze next year/summer/whenever.

I'm not entirely sure if we should ever do this by default.  The right
fit to me would be on of those questions asked during apt-get upgrade
to enable/disable things.  But don't ask me how those are implemented
or even called.

