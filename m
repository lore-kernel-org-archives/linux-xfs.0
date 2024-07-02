Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1058F2BCE3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899063; cv=none; b=nf3/ZtO8YMtgZXXxZAh/MPrBbgx3H3T5A99zSBmtgZi4C2pYCs6wlyyr7/EqZk9D3yxzsu+ZekfW6bKquqclG1Xfpdvu3uur4kSubAlHTrKvBxGOkAiielG0SgoWkE2s9rO1hWoq+QqTfoaVwqfJD7EGbtYMu3PYMhmZPK3UEaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899063; c=relaxed/simple;
	bh=4hQHOGVv+g+l1IzytFOndmM7lDM81akfhBLSuFuViVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y+xm+AtFD5VyiEU9P99pCnKOSyn79eM+HK1RYVTPUT6+QZFc2YskYWtS04XH/Ru3ELG72Hpj6dxa6g8Iz/qQhPx8KJN3qntm6PtGJy86zwoah+ci/rKTyWxeCTO+LDoJLMQBrLuVZA/MGqzR90HQf06mMgW14BROgvQmbZ0eJYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2CBCE68B05; Tue,  2 Jul 2024 07:44:19 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:44:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240702054419.GC23415@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988120259.2008941.14570974653938645833.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 06:09:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we're finished building online fsck, enable the periodic
> background scrub service by default.  This involves the postinst script
> starting the resource management slice and the timer.
> 
> No other sub-services need to be enabled or unmasked explicitly.  They
> also shouldn't be started or restarted because that might interrupt
> background operation unnecessarily.

I'm still not sure we quite want to run this by default on all
debian systems.  Are you ready to handle all the bug reports from
people complaining about the I/O load?

