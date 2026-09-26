Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8752E762C
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403497; cv=none; b=cs2eJ2pgugLuxmrlNHHDL7KqjDLdRRf1CvJXJXm99i+pEdD92RpfOUY3DMeGGksxyUn1Th4sMzrSxLTnLwpo3PQWu0fuYATvMlMOkNnJbgbCdwqw71D8sylLJ6OUAYxPDX8NTnz5voGi4gTBxYc8Zo4pGAa47ypvJzClGlSc1lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403497; c=relaxed/simple;
	bh=xeAh9jplwZ7sqVz3eAq82MEsL2t2tGcLamOMDC3785w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEzrCffqluEMjqHePWLT92sVYTsRRn1o71AkRX0lfq4chgIYGHaccI1zrZD/gx5qtyH63AOonOsao51ZPPoI3HNdJFrOw39i0jbVgXbxyayOmoN/rI3SaO1PyTkxcax0GDB/ULYmx5Majp1DyO8IHRy7tVrrCk5X444F/veRjaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11DEF68C4E; Sat, 26 Sep 2026 08:18:13 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:18:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/32] xfs_io: report checksum information from fs
 geometry in statfs
Message-ID: <20260926061812.GJ20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-29-hch@lst.de> <20260925233351.GN2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925233351.GN2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:33:51PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 12:04:18PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Seems fine, though I wonder if we should report 1U<<rtcsum_blklog?

I was trying to save space, but there's arguments either way...

