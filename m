Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20784749E1;
	Mon,  5 Oct 2026 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194725; cv=none; b=K1m0gBRQaIaXmAB43IvpbHyK0L6nbcoDIXEEpeg/Glj2el0SWujhA38b73Pyjwruyq00bsej3YVdIDi9+9mpufNB0lfQ2gHof4KmaRYUGHV3pekaZh39TQexJxyjMF2ZxY6m3fpSHXe3po9RoS88JnOdpitpH2tdu2dSWT/NEAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194725; c=relaxed/simple;
	bh=eCzku8Xgob0rqJpOfTeJcQj8pvA4FUbvRh+ie8JhzTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhBG57ygcw/oiPYU5xLIiZPu+szMzYwYXl9wzpYPTixjwOAOxM7suomosi0/JYJe5ViPIl6KVDRw9gkxsiGy2JplZfOCfq+sVMFNYNu0B8XpOSTOFxK1K5MQjYEIsFuHzCE+WS5A0r0MaQXCQVMNJT99KIfEHZ3XM/DLP1IbtjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJGz84Tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJGz84Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84C81F00898;
	Mon,  5 Oct 2026 10:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791194720;
	bh=zz2X9PCYvg5uDGN9RaX/IF3VF/CV1ZBEUczhWSZCYHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YJGz84Tx4sGhjye8XvYE1CeELO6XONAqomE8hJnkYIvXVfokXzWe3YT0W7eqiPjR+
	 6bj6JIQMi92eJCxDiEnank82y0eUQPCBxfCclmW9QV0UFJSZsU1f1tPG/5wKtebJMK
	 aWvpT6VjwcSuiNkTMxglrSqQpnzAGT59HjVnV3snyRaObb/BwVxo+yyNTQrgqpcWFO
	 UEBrTBwzxZ3vkTxeOI5WDxfdI1qnGZxJKOgnNsF8qYWpARmU4+jjypFmQyCK+DJi6Z
	 PqAejq0Pf0iVOUNR4MNEkLT4Z2gsncISa6IImrugCCTuV1ttpYnxwzg5L0JAHrAnfk
	 hMof79UvlxzwA==
Date: Mon, 5 Oct 2026 12:05:16 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: avoid cross-rtgroup reaping after a repair
Message-ID: <asN2P4KND2F0cy6b@nidhogg.toxiclabs.cc>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159798.1875436.7915121855965899039.stgit@frogsfrogsfrogs>
 <arS7tTCQGhyHjoou@infradead.org>
 <20260924193431.GR2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924193431.GR2705364@frogsfrogsfrogs>

On Thu, Sep 24, 2026 at 12:34:31PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 23, 2026 at 10:57:09PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 22, 2026 at 11:03:52PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > LOLLM notices that the extents stored in a xrtb_bitmap (aka xfs_rtblock
> > > bitmap) can span multiple rtgroups due to two circumstances.  The first
> > > is that the size of an rtgroup is an exact power of two, which means
> > > that rtgroups are adjacent in the segmented xfs_rtblock_t address space.
> > > This is fairly common to reduce the amount of multiplication and
> > > division needed to handle space on the rt volume.
> > > 
> > > The second is that (unlike in the original rtgroups design), rtgroups do
> > > not have fixed-location metadata like AGs do, which means that there's
> > > nothing to force a break between rtgroups.
> > > 
> > > Therefore, we must loop through the rtgroups in xreap_rtmeta_extent to
> > > avoid running off the end of an rtgroup while reaping.
> > 
> > This fix looks good.
> > 
> > Sashiko complains this could use some additional input sanitization,
> > though.
> 
> Oh yeah.  If rgbno points into the gap between rtgroups, we should
> advance *done to the start of the next rtgroup.

I think we can go with this series now and add that later, no need to
re-send the series just for this case IMHO.

> 
> --D
> 
