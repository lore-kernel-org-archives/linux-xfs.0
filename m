Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB003D7D8C;
	Tue, 20 Jan 2026 22:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768949732; cv=none; b=kYLxqCtRau6BYScyahW8fGo8u9CmEGQA4A9p6OL2elFSwpJ8lnu41wnWqVnrDgGELxUofOmniuSfO8IhvySkYuiQI6MiGu2qTI8AudFRm1PRwed1Em3ZvpgNIUk0yN36MxYJ/g2ncw4iFXVCYudwWm0e7tO0mVFm/hg8HbFrDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768949732; c=relaxed/simple;
	bh=bwJ+igiEP4AnfA99wZwsMu66YRPvghoR8xuti7ENz5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzgFIk17KJihhuLzKnLe5+pdeYjjO0zG5PaP9WnNRDtirfsdMBsab5d53W4sndQjkPvxXlgr3L08sUbj7QRoqYnTPlKVYYTUm7skuJYxjRGBvaK98p2/Bm7/6HyV2THGIyicDYsp9IAU1Nd4hlZw+Moc7CgNS2YOIObsXHAMoqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6JeDNFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6JeDNFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48372C16AAE;
	Tue, 20 Jan 2026 22:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768949732;
	bh=bwJ+igiEP4AnfA99wZwsMu66YRPvghoR8xuti7ENz5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U6JeDNFyzjwRW4H/19PwkVi9G5cVX1H5d+xO6e3JF3kM4FpIXr2kHkOSxifq1SXxL
	 SP99f5YvwNbiLHGXrQOSEFdKzEIgyDbB/THMJZdTVErBookrcaVIuO/S8ISpsL1c1P
	 +H+SRxCVrLPbPZnfe1kt2jSp/Xm3bFjAAgeBEjc94nsucu0yObYx+t176D6JZ1L1Cx
	 MetvCZ//I8xd1Pyn3U9wsOkI6BIvxYN2Nlr1B9ewNstj1mQ0xvS351bdW76tFS4K+e
	 S1Krj5nPGuP4jnP0ngh7BrLkKpXs504CMSpj/NqntldIYQdK6eWAhUm0IdJCkOHYfJ
	 96cLw+TVmSBZg==
Date: Tue, 20 Jan 2026 14:55:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dmitry Antipov <dmantipov@yandex.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
Message-ID: <20260120225531.GZ15551@frogsfrogsfrogs>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-3-dmantipov@yandex.ru>
 <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
 <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
 <aW_4bxkLe4-g9teu@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW_4bxkLe4-g9teu@smile.fi.intel.com>

On Tue, Jan 20, 2026 at 11:49:35PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 20, 2026 at 07:57:50PM +0300, Dmitry Antipov wrote:
> > On Tue, 2026-01-20 at 16:59 +0200, Andy Shevchenko wrote:
> > 
> > > With all this, I do not see the point of having a new API.
> > > Also, where are the test cases for it?
> 
> > If there is no point, why worrying about tests?
> 
> I don't know yet if there is a point or not, I provided my view.
> I think you know better than me the code in question. It might
> be that I'm mistaken, and if so the good justification in the
> (currently absent) cover letter may well help with that.
> 
> > Also, do you always communicate with the people
> > just like they're your (well-) paid personnel?
> 
> What do you mean? Test cases is the requirement for the new APIs
> added to the lib/. It's really should be regular practice for
> the code development independently on the project. If you think
> frustrated by this, I can tell you that I was more than once in
> the past in the same situation until I learnt it very well and
> now when I submit anything to the lib I always add test cases.

Yes.  Common code needs to have a rigorous self test suite, because I
see no point in replacing inadequately tested bespoke parsing code with
inadequately tested common parsing code.

--D

> -- 
> With Best Regards,
> Andy Shevchenko
> 
> 
> 
