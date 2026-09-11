Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AE6368D62
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139487; cv=none; b=OIoV6Evq9FsIHjnJ85DCZyIPtHH3z0Wc+YD52l2zWDSt08+zbJHOH0rB6p5o5d+Jb92m5K0zJa5QHgYXgDmzjWWQlruIXVX5cxtFAIpF1A2HObhTAKLTEZ1qMQvqOzvLLqwvtTW+325jLe9GVKPdCMaS5Mg9z38z7KauJQ7Sl5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139487; c=relaxed/simple;
	bh=/2tJf5w7qmKe0RhiQjS1Xzett3CeMB3cjfqaClXWuiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8BrdJPD3KMxQj67vcd3o8mtwAzFIpPpl+uPtKYbUagIKsVw/OmWB4nOfrJuWstWahLRUkjKeUmC8TdG2zEHoSmZbxUqWO1ypasFkl/fhuj+wEUJ10tnRNUtVbOaAwYEgFzX6lQW0epjSg4/QXH5eqSFa0s1kU+st3p3+UCHKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF6D668C7B; Fri, 11 Sep 2026 17:11:20 +0200 (CEST)
Date: Fri, 11 Sep 2026 17:11:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] libxfs: don't set mp->m_rtdev_targp when no RT
 devices is provided
Message-ID: <20260911151120.GA26893@lst.de>
References: <20260911144559.1959740-1-hch@lst.de> <20260911144559.1959740-2-hch@lst.de> <20260911145726.GE6265@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911145726.GE6265@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 11, 2026 at 07:57:26AM -0700, Darrick J. Wong wrote:
> > -	if (!xi->rt.dev || xi->rt.dev == xi->data.dev)
> > +	if (xi->rt.dev == xi->data.dev)
> >  		mp->m_rtdev_targp = mp->m_ddev_targp;
> >  	else
> >  		mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt,
> 
> Does this mean that m_rtdev_targp is never NULL, even when we don't
> specify or have a rt device attached?

I think that is the case right now.

> I would have expected this to be:
> 
> 	if (!xi->rt.dev)
> 		mp->m_rtdev_targp = NULL;
> 	else if (xi->rt.dev == xi->data.dev)
> 		mp->m_rtdev_targp = mp->m_ddev_targp;
> 	else
> 		mp->m_rtdev_targp = libxfs_buftarg_alloc(...);

And that is what we get with this patch.  The zeroing is done by
zeroing the entire mount structure in the callers of libxfs_mount
(don't ask me why..).

