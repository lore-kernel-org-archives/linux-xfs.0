Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A74C1D5148
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 13:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999425; cv=none; b=eHDxF2FqNb1q50c9ByYeDbx7EAuqpSR8L/n6zSo87ZcVHYR5q69FdbJ6ZVXFiM0NF8fG1ggaZBzA4GaVdSIDlN+VQOWohHNy5St01VKxHMlkLyn9yNYxZkp3x52hwu17qasCeDoTS+/YPGtt8M7tCZiGeq5qkcmfD7AaDl8mzdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999425; c=relaxed/simple;
	bh=Fu6CbTf74KH8dk4tpXxmuw9mMw1rM8PZB0wKFTahA0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lGAeND9RpEuqRV5gs463KXVFW83VgVYGgVNVQwicw0UVu1WSV1OjimZ5paknyka8L8nu6dOi40902ykFIM4hGQOBRxZbBO363TzYHlCgGlWFfRw5heoswIrpIW6HWpP0YFQDTWOrpF3fOLGou9FJk4A+3jiDBPEjMXEwGy0xEdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 49D8F227AAC; Tue, 15 Oct 2024 15:37:01 +0200 (CEST)
Date: Tue, 15 Oct 2024 15:37:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: update the pag for the last AG at recovery
 time
Message-ID: <20241015133700.GB4535@lst.de>
References: <20241014060516.245606-1-hch@lst.de> <20241014060516.245606-7-hch@lst.de> <Zw5qDZXQd2UzoGQu@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw5qDZXQd2UzoGQu@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 09:11:41AM -0400, Brian Foster wrote:
> > index 25cec9dc10c941..5ca8d01068273d 100644
> > --- a/fs/xfs/libxfs/xfs_ag.c
> > +++ b/fs/xfs/libxfs/xfs_ag.c
> > @@ -273,6 +273,23 @@ xfs_agino_range(
> >  	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
> >  }
> >  
> 
> Comment please. I.e.,
> 
> /*
>  * Update the perag of the previous tail AG if it has been changed
>  * during recovery (i.e. recovery of a growfs).
>  */

Sure.

> > +	/*
> > +	 * Growfs can also grow the last existing AG.  In this case we also need
> 
> It can shrink the last AG as well, FWIW.

Indeed, I keep forgetting about the weird special case partial shrink
that we support.

> > -	error = xfs_initialize_perag(mp, orig_agcount,
> > -			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
> > -			&mp->m_maxagi);
> > +	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
> > +			mp->m_sb.sb_dblocks, &mp->m_maxagi);
> 
> Seems like this should be folded into an earlier patch?

Yes.

