Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD23126059D
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761231860; cv=none; b=cQJM87smnhPmoFR4b3YS0426JJMWXEgLlaPDNEQ/dS8qtTER5JkaqhGH0r+6JT1ONNuwBjuTyf7F0Zuv+CxJ7F5atg1n6VM1uWZi+Ptvwvy8GAoRKGE9fqoCb8OeKWWha+tZk9GiC9txuDjeeYLoip7seCaIIljZm1Yu0EKcEgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761231860; c=relaxed/simple;
	bh=V5Ff9r+enY2FcEwyh0TVwmkZqFSVKyEuIwQRcRtIdsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTPB1bxCdc32kxdqABCvgP/JNX7wUBPmbKDdXkEDdp1ztHuXPDWQkrUJmRA6gkIKFqfKYW+ZojML7JstB6zvc2DdPB09/YeBSVyDW70CQqi7iS4BjNb8/QSIsAi7w8VyGU9dW/MpivNAKI3YKtDFtVyHdSCovX3gtz6dqlSPGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8564227A8E; Thu, 23 Oct 2025 17:04:08 +0200 (CEST)
Date: Thu, 23 Oct 2025 17:04:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <20251023150408.GA30853@lst.de>
References: <20251017060710.696868-1-hch@lst.de> <20251017060710.696868-2-hch@lst.de> <20251023061622.GP3356773@frogsfrogsfrogs> <20251023062829.GA29564@lst.de> <20251023150232.GI4015566@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023150232.GI4015566@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 23, 2025 at 08:02:32AM -0700, Darrick J. Wong wrote:
> > > > +		 *
> > > > +		 * This prevents us from picking one of the zones for which we
> > > > +		 * already submitted GC I/O, but for which the remapping hasn't
> > > > +		 * concluded again.  This won't cause data corruption, but
> > > 
> > > "...but that I/O hasn't yet finished."
> > 
> > It's really the remapping after the I/O that has to finish, but given
> > that we talk about I/O earlier, maybe your wording is less confusing.
> 
> The word 'again' at the end of the sentence tripped me up.  I think the
> word you want there is "yet" (because "again" implies that this isn't
> the first time we've remapped the space, which isn't true) but you could
> also end the sentence wit` "concluded".

Both sounds fine.

