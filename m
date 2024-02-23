Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD1C12DD81
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708742; cv=none; b=lb6FUSPk2HdpGjA4H/jc4BSPS17s0qYFBRI1hr4jSUsrUt7F8XpT1FeJKfhYKpUbst+U5GCu6yc2z9bD1SkL67YoDaObnqJVfWD0cadEyVJ/XtMtPs8Zyo6Zcia3InYuYZnyC4P9kh6ZYryt7bG2nSEnAwWVY68c4C0EujkR5rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708742; c=relaxed/simple;
	bh=JsXppklqdTMxIAtfFaClqqTuJNOXfhYcDYT8+mEwzNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ThkzxpuTIEJg5JY7rV2SXex5k/QKtt4ZtcfkKgwjTt42BaV2QthWoAfrWawfqqbRQK06DZLs+inJ7KsqpTnFjfkASslY2LANr4vf81/GqIfmqsDgD2k6AgaY7IPnZmrK0aUEFykeAxsFdSNvBWQiaI1PWnClbws2G1m+WZxGJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9093A68B05; Fri, 23 Feb 2024 18:18:56 +0100 (CET)
Date: Fri, 23 Feb 2024 18:18:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: split xfs_mod_freecounter
Message-ID: <20240223171855.GB4579@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-5-hch@lst.de> <20240223170953.GQ616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223170953.GQ616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 09:09:53AM -0800, Darrick J. Wong wrote:
> > -	lcounter = (long long)mp->m_resblks_avail + delta;
> > -	if (lcounter >= 0) {
> > -		mp->m_resblks_avail = lcounter;
> > +		xfs_warn_once(mp,
> > +"Reserve blocks depleted! Consider increasing reserve pool size.");
> 
> Hmm.  This message gets logged if the __percpu_counter_compare above
> returns a negative value and we don't have a reserve pool.  I think
> that's a change from the current code, where running out of m_frextents
> returns ENOSPC without generating (misleading) log messages about the
> reserve pool.

Yes, I'll need to fix that up.

> without all the reserve pool machinery that fdblocks has.  The original
> code to implement m_frextents did exactly that, but Dave really wanted
> me to optimize this for icache footprint[1] so we ended up with (IMO)
> harder to understand xfs_mod_freecounter.

FYI, I have uses for reserved frextents a bit down the road, so
I'll make use of that.  Without that splitting them would seem nicer
to me.
