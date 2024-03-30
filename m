Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCD479F0
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 05:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711778357; cv=none; b=rthU/3nq8HWcAGTPhOJK5VEcKQruhmpF53tXpwDoVcMWV/VFDx4O1nY9U32PgIwDxtX1dPLFveWVcp1KupK280rs17yOSSfSYh86B69cPmfRAlo7ezdhTilBWle0EsQ0bM48Z0OuWasATvZ9YAfw3GKFezPiZpbeNv67SD98ra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711778357; c=relaxed/simple;
	bh=nML0le7fVB0q9oGUs9KH4dKXxxaOXTQLOpNmU6V+3M0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJ7SSri4IKZn6JxEJ9U2Wp1VbUS44XvbUCeXYHfYZQ+8S8aLF2IH4G6crpI3kg0SXVdi1DtjTlIpisJW59xImfvs1ndggwrXW8/rfB2gexY3XUrsTiNjQ1Sip+kQ6QNpoyLmTf/J9MPuMoTgMm6Js+G7XeEgvYObiaNIqVIG0wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB4FE68B05; Sat, 30 Mar 2024 06:59:12 +0100 (CET)
Date: Sat, 30 Mar 2024 06:59:12 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: rename the del variable in
 xfs_reflink_end_cow_extent
Message-ID: <20240330055912.GC24680@lst.de>
References: <20240328070256.2918605-1-hch@lst.de> <20240328070256.2918605-7-hch@lst.de> <20240329163108.GJ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329163108.GJ6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 29, 2024 at 09:31:08AM -0700, Darrick J. Wong wrote:
> >  	/*
> > -	 * Preserve @got for the eventual CoW fork deletion; from now on @del
> > +	 * Preserve @got for the eventual CoW fork deletion; from now on @new
> >  	 * represents the mapping that we're actually remapping.
> 
> I'd have called it 'remap' because that's what the comment says.

Fine with me.

