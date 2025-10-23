Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0AF26A1BB
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761200916; cv=none; b=c6RQIBJkR4MVVjRS4vm5RpcHXUzi7QBzrxuHK88YcmJzRiIJ3uyGDPhx+4/fn9NMpIb6jy6bM4IM5s+AASTs/XBLgVON9LvtlXw5Vp2R0V5dRPhgPZedN3mhPDtxpbf0eODqzydCdExMefiVFUJ/tqGCOQ4c7v1afBW3feWftZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761200916; c=relaxed/simple;
	bh=oQAB12JVUPUYw38JUEe2i9aDPN1XXlHLAjNplmScL6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dt2dy+8uu0+vYHWsPh1kWRkr33lFegymyvINKotiqqJnkpZsY9IdTeQSVPUVjdgisrSI9twMbQHFmdiET++f7cG7qIR/sbtZkxLgzZHfGDRVyKh0VLJaXBUj1DX4FqfwVsZHHxhsun9nfiBvz+yMDR9ZyZPY4qkGUs3RU2TqhaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA8BC227A8E; Thu, 23 Oct 2025 08:28:29 +0200 (CEST)
Date: Thu, 23 Oct 2025 08:28:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <20251023062829.GA29564@lst.de>
References: <20251017060710.696868-1-hch@lst.de> <20251017060710.696868-2-hch@lst.de> <20251023061622.GP3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023061622.GP3356773@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 22, 2025 at 11:16:22PM -0700, Darrick J. Wong wrote:
> > +		/*
> > +		 * If the zone is already undergoing GC, don't pick it again.
> > +		 *
> > +		 * This prevents us from picking one of the zones for which we
> > +		 * already submitted GC I/O, but for which the remapping hasn't
> > +		 * concluded again.  This won't cause data corruption, but
> 
> "...but that I/O hasn't yet finished."

It's really the remapping after the I/O that has to finish, but given
that we talk about I/O earlier, maybe your wording is less confusing.

