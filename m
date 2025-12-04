Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511CE2D878C
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 10:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764842906; cv=none; b=Ljp0uH4G9JlflJHjzJfBKYeOvI6XHrp8jwrc3HOQ5YXpiBpxe6rTBI+ygubsmbJ7klwzrWCuZuAtBG4JrxEnUwf5b2Z2XjhwIVRMdNHMyV/9w+l/Nw/7N7k5mP6wJwYbDpVCUM87+dAPxqtZduJb0xfss+HD+PyUxSc/mFWXeUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764842906; c=relaxed/simple;
	bh=EV/pF04QaDCVBVtsTzQIij/I5q3b1EM/I8oavMpPZUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxMO6+cnRqJGoNFYPZWeS6URkWk9eVW675JyYl1qluhmGMv+qcvEPGV158+lmjLsXmlF5rc+DTMkscxtIgmcAHz49b4NIihf+9pMJcL0Zd3tU4JQqbQvqhMkCylBN9dslqyEe67yhNPImEhcBAkdboeMIa2FeIouR7vnfpQlwlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5AF8368AFE; Thu,  4 Dec 2025 11:08:20 +0100 (CET)
Date: Thu, 4 Dec 2025 11:08:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	aalbersh@kernel.org, cem@kernel.org, cmaiolino@redhat.com,
	djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com,
	preichl@redhat.com
Subject: Re: [PATCH 23/33] xfs: convert xfs_buf_log_format_t typedef to
 struct
Message-ID: <20251204100820.GA21013@lst.de>
References: <cover.1764788517.patch-series@thinky> <qptxxayqxie4vwryddds36sofs44zufqo3wes6j4dfehl2jxoq@3ioxr4fnyynb> <20251204093202.GC19971@lst.de> <2vhe7x2wsydpko2n272dppoqk6kxe7ejkx2lwpmg6pa56mmnzf@f64b4gg4dpuv>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vhe7x2wsydpko2n272dppoqk6kxe7ejkx2lwpmg6pa56mmnzf@f64b4gg4dpuv>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 11:00:51AM +0100, Andrey Albershteyn wrote:
> > > +	xfs_log_item_t			bli_item;	/* common item structure */
> > 
> > This should be struct xfs_log_item.
> 
> hmm, I think this one (and xfs_buf_log_item_t) wasn't propagated to
> xfsprogs. I see your commit in kernel but that's from 2019. 

Oops.  I can take care of that, but for anything you touch anyway,
please avoid the typedef.

> > And this clashed with the series I had, which also splits things up.
> > But I guess we should just do the quick conversion given that you've
> > done all the work and I was too slow.
> > 
> 
> If you have more cleanups I can also include them, I want to prepare
> everything for soonish v6.18 release and include that fix for
> xfs_quota (which I will probably send today, not sure if reporter
> will send the fix).

I have a quite a bit of dusting off for logprint.  But let's get a 6.18
release out first, I'll send them for 6.19.  There's also a lot more
work for the iclog_incore2 removal, including really nice cleanups
enabled by that.

