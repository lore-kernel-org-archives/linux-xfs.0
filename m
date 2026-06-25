Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6AA3DCD80
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389183; cv=none; b=Ts3T5sBY2/SAWquijGnF3GOFQo1jGMBrnbMu9RVP40Eh+kyBsoaRfOTkvF/f05Zj09Ncy3hl6vFr5OBjZj/f07fuSZCPDJ5bkEfRxst1V39YsDihxZXeCcz923fAlRD895kCPWBnFABNDIADr4kJgGParxvrR6qEt2wnqGioWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389183; c=relaxed/simple;
	bh=NO9XMODcgWdRnKy9emhVv/g4OBpVYpRjxvhRzMVDwlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Krm1Vxct288qUWm/VpPVbkw0WOytK6LAxwBJpFkZ5Lcbk8tcgvrH5oLb+XIb75FUhTvnB54XKTYEpuzszDw9mfZbFfHY03AUyp2JB2JzTrsNZrjdoDStCePAxoRjb8PvOquQEjnr2rTQdxQCmhMhgAmS58b2/ute1ILdwZyl7P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AE44C68B05; Thu, 25 Jun 2026 14:06:19 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:06:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/11] xfs_scrub: don't leak the autofsck fsproperty
 handle
Message-ID: <20260625120619.GK18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484623.915780.13550947290089406895.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484623.915780.13550947290089406895.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:17:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex notices that we leak the fsproperty handle if the filesystem
> doesn't actually have the property set.  Fix that by moving the free
> call; it can handle a totally nulled out structure.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

