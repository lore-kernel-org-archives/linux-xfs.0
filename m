Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D9A291E
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734066692; cv=none; b=pd4E85PklXH5y6cPgMGV9H12hqvOZ6aFxmgWaVJms3NzZPPL3km0TZsAdxU9j+QniTxrdkNc2XVHzomXiJ7/vFhtcHXBgvZQ2ZDd3bPn52//NhEzZVJ2a3R0LV0x1FY8ji1YSzhKrVzhmjuGqTjm8tVeqSSnusi2KetP4v+5HWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734066692; c=relaxed/simple;
	bh=sJ1cHBveAQ8TvOr9YANYQ5ARSXzsi91SZjxRPoVawyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C02ESzUcssWGT732zcj3DjTKVPKtiCKho6zp58rIa8CpOzwg7GV36tb/6kQu0T0ABb4zNxOHQJjOoJNQBQkfhlhqOKieIAgdhaYAkg0bgEq1oxbw8dGZojdmC33Q40gFqcxRewA2425xytzF+TNWsw2dt6WdMCJ2/6rs5npxFkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA76268BEB; Fri, 13 Dec 2024 06:11:28 +0100 (CET)
Date: Fri, 13 Dec 2024 06:11:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/43] xfs: generalize the freespace and reserved
 blocks handling
Message-ID: <20241213051128.GF5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-10-hch@lst.de> <20241212213718.GU6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212213718.GU6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:37:18PM -0800, Darrick J. Wong wrote:
> >  		mp->m_sb.sb_frextents =
> > -				percpu_counter_sum_positive(&mp->m_frextents);
> > +			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
> 
> Curious.  xfs_sum_freecounter returns percpu_counter_sum, not its
> _positive variant.  This seems like a bug?  Or at least an omitted
> max(0LL, ...) call?

Good question.  This code is pretty old and it's probably time to do
a full audit of the _positive thingies, including checking if the
existing callers make sense and what the right levels of abstraction
are.

> > @@ -1297,8 +1314,7 @@ xfs_dec_freecounter(
> >  	 * problems (i.e. transaction abort, pagecache discards, etc.) than
> >  	 * slightly premature -ENOSPC.
> >  	 */
> > -	if (has_resv_pool)
> > -		set_aside = xfs_fdblocks_unavailable(mp);
> > +	set_aside = xfs_freecounter_unavailable(mp, ctr);
> 
> Nit: I think you can get rid of the set_aside = 0; above?

Yes.

