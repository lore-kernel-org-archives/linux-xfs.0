Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17940366816;
	Fri, 11 Sep 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139273; cv=none; b=K4ge/gkGROte9ho4WZaldQGpCGJf7FzOooauhIxeRkBy0hAKnMzim6tLY55lZZrEff6rXw1HalHh6dVF8PrclJybK4RIzzhrqZ6rU5NQilcDyW608quENeVDTGXCObGqUJ9+CUUsrzi9pA1OLsyzujWz84k3KwwFbT6SMsMg5+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139273; c=relaxed/simple;
	bh=zIOGKwx22Z5IUWIYJS6Ujr6d7vzLyN/DyJlUBihYb04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SdwmyeBXDmeF0Ku+WiQnp1DocFPd9++8mLiSYD7T0TGKns5rNX/hPSMaB/msT5gwhqXcgMao/NQxkw6KixPpx/kw+06KMzxNfrlgqt+jdrWYMsQ0oqaTnjlhSiqk5ZFOmLWW2286QXBEuHR3Yhjr8GZ09ZGDEdU7qkUBEL4Zox8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4532E68D09; Fri, 11 Sep 2026 17:07:46 +0200 (CEST)
Date: Fri, 11 Sep 2026 17:07:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: check di_forkoff correctly in scrub
Message-ID: <20260911150745.GA26822@lst.de>
References: <178910161988.174887.8958318922224347752.stgit@frogsfrogsfrogs> <178910162147.174887.15828411239184280666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178910162147.174887.15828411239184280666.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 10, 2026 at 10:54:58PM -0700, Darrick J. Wong wrote:
> The di_forkoff check in xchk_dinode is incorrect, according to LOLLM.
> XFS_DFORK_BOFF returns a byte count relative to the start of the literal
> area, not the start of the inode.  Therefore, this check won't flag
> di_forkoff values that are larger than the literal area but not the
> inode size itself.  Fix this check; sadly the old APTR code was correct.

The fi looks good, but I really which we could encapsulate this
magic >> 3 a bit better (here and elsewhere).

Reviewed-by: Christoph Hellwig <hch@lst.de>

