Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB1923BE
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739423695; cv=none; b=tqFwOSVwTYKQ0N9gU/CpBmzAoPu51VlEMnboivq13jRM+CyiPFcdntKi71lv04Q+0YrtoS5FUJK5F2RLvOxUm5ba8c7NKvadyEZo4Yttwm2bSwkGzYxobwFFBuJNE7ksnkkowCNrXZbkqcrWH7TUDa4nePtkUj+l4756g5Zak9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739423695; c=relaxed/simple;
	bh=D6kdeUqCCSofkGeZtafxm4qxCyXwVO8oEyyIbt0UnLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/AjE9SNe6vNNC27dFCmkwNFhYBZY1zq4vpjmQ254k5laNKPgkjNHe+k6SCzmaV0gekCS9oPC46klJp5/9u3KsujwtFWBM9dhRQ9MHKESmn8XOTYrj40FHk0Em4BHkmaPT438YZ6YFc6lthBQWfzm4+aO7COE8i2vJ9y+w5h14Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C817667373; Thu, 13 Feb 2025 06:14:48 +0100 (CET)
Date: Thu, 13 Feb 2025 06:14:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: add the zoned space allocator
Message-ID: <20250213051448.GC17582@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-23-hch@lst.de> <20250207173942.GZ21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207173942.GZ21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 07, 2025 at 09:39:42AM -0800, Darrick J. Wong wrote:
> > +	/* XXX: this is a little verbose, but let's keep it for now */
> > +	xfs_info(mp, "using zone %u (%u)",
> > +		 rtg_rgno(oz->oz_rtg), zi->zi_nr_open_zones);
> 
> Should this XXX become a tracepoint?
> 
> > +	trace_xfs_zone_activate(oz->oz_rtg);

The tracepoint is just below, but yes - this obviously was left as a
canary in the coalmine to check if anyone actually reviews the code :)

> > +	if (xfs_is_shutdown(mp))
> > +		goto out_error;
> > +
> > +	/*
> > +	 * If we don't have a cached zone in this write context, see if the
> > +	 * last extent before the one we are writing points of an active zone.
> 
> "...writing points *to the end* of an active zone" ?

We only really care about the same zone.  Even if that doesn't create a
contiguous extent, it means the next GC cycle will make it contiguous.
But even before that the locality is kinda useful at least on HDD.

There's still grammar issues, though which I've fixed up.

> 
> > +	 * If so, just continue writing to it.
> > +	 */
> > +	if (!*oz && ioend->io_offset)
> > +		*oz = xfs_last_used_zone(ioend);
> 
> Also, why not return oz instead of passing it out via double pointer?

I remember going back and forth a few times.  Let me give it a try to
see how it works out this time.

> > +	mp->m_zone_info = xfs_alloc_zone_info(mp);
> > +	if (!mp->m_zone_info)
> > +		return -ENOMEM;
> > +
> > +	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
> > +		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
> > +		 mp->m_max_open_zones);
> 
> Tracepoint?

I think this actually pretty usueful mount time information in the
kernel log.  But if you mean a trace point on top of the message and
not instead I can look into it.
