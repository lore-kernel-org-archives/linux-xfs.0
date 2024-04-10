Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF532C127
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 04:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712721838; cv=none; b=bn57VxFzDV3tF5LS4LleXS9q1+Kafz77bp51jga0tsbL3Ujph3M08iFiMCeSqzVFv+Xo6sVB4hdCT3sNDzj9o3PCpahn8Qun67tsTGHKPGa7BY6IMbwMdscuvHInDkxpYdpTQJeJ/GhqpQonlmcCH1KV4D/l7MG2CNt/LLZVmzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712721838; c=relaxed/simple;
	bh=wTlJVHpqUIATmgRa1iihQu0th0Dvyaa4f+jjKjzQP8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lWYU7gDbAZe8NB3c9O1L5DRaDEKMKgB3zXenzJ7BmcJsbQ3EYvjWYzrrW3Y/mwgz7SrHIitARJ7uZwcSzppwjUPxWcv5vxLQ+VdJhLKz/UwzwIu0p6g6QtLQM4pmXXcXzvkRyInI00cV0H+3XUkTQrK/TROVwvPuIfQYtLzVmks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C5DF68B05; Wed, 10 Apr 2024 06:03:53 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:03:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5/8] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
Message-ID: <20240410040353.GC1883@lst.de>
References: <20240408145454.718047-1-hch@lst.de> <20240408145454.718047-6-hch@lst.de> <20240409232044.GQ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409232044.GQ6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 04:20:44PM -0700, Darrick J. Wong wrote:
> > @@ -4542,6 +4532,15 @@ xfs_bmapi_write(
> >  			 */
> >  			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
> >  
> > +			if (wasdelay) {
> > +				bma.offset = bma.got.br_startoff;
> > +				bma.length = bma.got.br_blockcount;
> 
> This read funny since we'd previously set bma.{offset,length} above, but
> I guess that preserves the "convert all the delalloc" behavior; and you
> turn it off in patch 8, right?

Yes.  That being said I should just move the assignments into the other
branch here to make things more obvious.

