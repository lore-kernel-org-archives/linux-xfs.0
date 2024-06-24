Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E4A19D09F
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719245261; cv=none; b=FmmM3uJjEyH8E2ZrULSE4qa4jKy8O1Or1Cvlk9AjhAXMxLFtVVeCBGAK1lR1fmMpc+kWBbN5+x/UeeokglOc8kWyji4rr1RbSy2H5rerNkgP8eaDoPgdmOJ7Et54fpPUuoOeY6ZzlAP6tviecnCv6XnqGGGUy6pgfqWH3uYuivE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719245261; c=relaxed/simple;
	bh=bnVxq4Ph1grb8WJk9Oqu4tA/02jtCbZUXmHQ4Q9QeiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHgNZfrmpTF1tomdp77EFZ3UZU7lHSwZbf6osXETT/kpvSyJYHGyURjcRBqoJ1zAldgWy6uyd4FUdm2NPDGRVWKrc748AJ1HeWOLBvHLZJMpOOGwgixs8zvsGURNfapvc1TDPbsh15nrRRO1mEc6zZFV4gBZiNI4ZO3M9LrS/TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C7B968CFE; Mon, 24 Jun 2024 18:07:35 +0200 (CEST)
Date: Mon, 24 Jun 2024 18:07:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reclaim speculative preallocations for
 append only files
Message-ID: <20240624160735.GA15941@lst.de>
References: <20240623053532.857496-1-hch@lst.de> <20240623053532.857496-11-hch@lst.de> <20240624155443.GN3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240624155443.GN3058325@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 08:54:43AM -0700, Darrick J. Wong wrote:
> >  
> >  		if (xfs_get_extsz_hint(ip) ||
> > -		    (ip->i_diflags &
> > -		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> > +		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
> 
> The last time you tried to remove XFS_DIFLAG_APPEND from this test, I
> noticed that there's some fstest that "fails" because the bmap output
> for an append-only file now stops at isize instead of maxbytes.  Do you
> see this same regression?

No.   What test did you see it with?  Any special mkfs or mount options?
