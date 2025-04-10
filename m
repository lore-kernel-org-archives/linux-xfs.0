Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45BF374D1
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266596; cv=none; b=C64LIQCWgfC1UAp39aj0d0MUzffYByOICCJQqmLAJV3J7ZB2aDW8UxRsRJYuTxxMol2ftkLp3DhPrLWiEmRBWGadxtESWmhOIVArdKjXjGgYBntR6jGX4TU5RPaqM/3xdFM6NRbRyk7auJ0acQd0eYs8u7SwirKup2kaB6eyNX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266596; c=relaxed/simple;
	bh=vQvsyIqvA4UG9+gOQrxM2dBJH7aUgLWvDW2fx/0czVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUBwTR2sGJXi+j16qVCxW4Y5aepNgpPRndMaj5aAbpebMvJRrlihISt+GB8HGb0dD0DyQbTYRVoyCmnz6R8jQ4zxtYbhT8OjT/nByS3jEfUWgPQm73ervqqMkOVKbrhXsIkl6RO92M94nMNROvptR5Te4/mxAL5YvRLPifomJ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 607C568BFE; Thu, 10 Apr 2025 08:29:50 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:29:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/45] xfs_repair: fix the RT device check in
 process_dinode_int
Message-ID: <20250410062950.GC31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-29-hch@lst.de> <20250409161155.GD6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409161155.GD6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 09:11:55AM -0700, Darrick J. Wong wrote:
> > index 7bdd3dcf15c1..0c559c408085 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -3265,8 +3265,9 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> >  			flags &= XFS_DIFLAG_ANY;
> >  		}
> >  
> > -		/* need an rt-dev for the realtime flag! */
> > -		if ((flags & XFS_DIFLAG_REALTIME) && !rt_name) {
> > +		/* need an rt-dev for the realtime flag */
> > +		if ((flags & XFS_DIFLAG_REALTIME) &&
> > +		    !mp->m_rtdev_targp) {
> 
> If we're going to check the fs geometry, then why not check
> mp->m_sb.sb_rextents != 0?

I'll give it a spin.

