Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C42139E;
	Mon,  5 May 2025 05:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746423956; cv=none; b=g/u+r4ojtqj9X59PEi5RUoFwFYDLdaNWYMSLN6E14yNdSxv7yXIZJTfy2bnpR1awQlUgtH3D/A7zHOYTW8pMf4h+Oq+rJCAXIGIgD0wWg79HLsGDn5MT+9nbe1aOZk0cuoUcosBJFWYWbYmNxUrpHBQ2hfb1qzQpV21kzOHGUEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746423956; c=relaxed/simple;
	bh=4gn9TG1eNTrW9xDNN9bGw6HLyAmyE26Dayg0mZ4cgh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M+C8rVYD/YBxDBIPclxCA9YBYOJ0XT/2N3Rltgo6Pp8NgJEgqJrtA9x/JlZGh3O+kvSrtiBzKreA2LVWnOSNfCGDbqBQOuvV/MusGMxlXpZULEQjSVBfjulXSodMbobajaGhk5mwQxLTI6AsKrGSdKI0TmvqsLA9noxBAlwu9Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3892668BFE; Mon,  5 May 2025 07:45:50 +0200 (CEST)
Date: Mon, 5 May 2025 07:45:49 +0200
From: hch <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] xfs: free the item in xfs_mru_cache_insert on
 failure
Message-ID: <20250505054549.GA21045@lst.de>
References: <20250430084117.9850-1-hans.holmberg@wdc.com> <20250430084117.9850-2-hans.holmberg@wdc.com> <20250502200646.GT25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502200646.GT25675@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 02, 2025 at 01:06:46PM -0700, Darrick J. Wong wrote:
> >  	atomic_inc(&pag_group(args->pag)->xg_active_ref);
> >  	item->pag = args->pag;
> > -	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> > -	if (error)
> > -		goto out_free_item;
> > +	xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> 
> Hmm, don't you still need to check for -ENOMEM returns?  Or if truly
> none of the callers care anymore, then can we get rid of the return
> value for xfs_mru_cache_insert?

Both for file streams and the zone association in the next patch the
mru cache is just a hint, so we ignore all errors (see the return 0
in the error handling boilerplate in the existing code).  But hardcoding
that assumption into the core mru cache helpers seems a bit weird.

