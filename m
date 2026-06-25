Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94ED3DE451
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782388805; cv=none; b=kDVJHUd1siJJBPPXlDOMKcAkiMu0G0uPXPieI7lCA3DvgtK6cQAmmsO7sYzHL6OYzQ8TpsY1JBZWA5/kxu1VuEgljY8oYANsVKsd85NDvA4t6thAWt0F+EScyqlueu6dnelIZxEbuheq35lDD3PVAP9H+IM75K05KRseLVVNerU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782388805; c=relaxed/simple;
	bh=FLo0TOpo6vmk6X3Dg9Kvs9NVJO+RL0nOSIwtyANHkaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVGECqgBgonUhLhoSbqp59VWwXeBJ01rKoou3jHPMYGHI+fSh+chp88UlbhIjOg+7mhorMTYtZJ7pwDy7KHHlQe1AeZ7Hgdk4rx8ASNc/JRSAoDs/RB8h2xWA5YDnazboHhGyfzEJ4jNLIjuMWIzpViqiQ/Va9f8JgG75ObaAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C369268B05; Thu, 25 Jun 2026 14:00:01 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:00:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/11] xfs_scrub: handle missing media verify ioctl
 failure return codes
Message-ID: <20260625120001.GB18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484456.915780.2285571166999058813.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484456.915780.2285571166999058813.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 11:14:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back when we reworked the read-verify code to use the kernel ioctl to
> perform media scans, we forgot to teach read_verify_one callers to
> handle the new error codes.  Codex noticed this discrepancy, so let's
> fix that.

Urrg, more leaks of the obscure kernel BLK_STS to errno mappings to
userspace :(  But yes, we need to handle them:

Reviewed-by: Christoph Hellwig <hch@lst.de>

