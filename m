Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BF3125B9;
	Thu, 13 Mar 2025 17:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886343; cv=none; b=eWOATtFcCMIk/AkmfkPEGh1yy51GDaNvQ9vooP3LmhPuqdbOjRCMKq5USfSW1WS/dFjPXHBQKX12zguWcOnM3vweLKiQj0ln7kMWgilKU3I9MW4ZPQqRhO6dZ2tadcAQIqtoDzBoP8A4oUUwspN3rOtfBAvgp9hapufUH3PuCY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886343; c=relaxed/simple;
	bh=G/NRXd1zgX5LIc/UfCVwV4uyZ+9NPTExGBjHMrwSlUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApqdrWhO23BPnLHd/o7keLAQ4b0qKYmHDJ8hZjEENwiEvipiwuyRz59zPCWniTkJ0sAHaXFI+Ulro85WK9UyzoX5+FDOXOvIaehS1INJGGpp4BH4K88z5ITnA2XZGO0ewWLHbjzBADWLkevAyDcTU381lN2NwgTjQjILKGNfX2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uL9Pv0p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uL9Pv0p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780FFC4CEDD;
	Thu, 13 Mar 2025 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741886342;
	bh=G/NRXd1zgX5LIc/UfCVwV4uyZ+9NPTExGBjHMrwSlUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uL9Pv0p3A3QLqomRLMMT+Pn4XRHdF0OokPiLIB8ONNYkOil3q5FIHx8iA88ubY3AZ
	 OTQ3aPG1EKJI40qH/s1I6Y/xc+6sPDXRSQdrZpqLgMF28aOb2PZbNPuVVyNP0SY6KD
	 DHZMxgP4gBQGJxuCYS4QuiKj1cZwcDkc3RlXAuHnZ4WbcUKdytqrOW5ZulFryBTtjP
	 UYDkikGhvQ7M205xXDCK9ga4wPYtzZnqgY6XmY+m+TBASHGNGhAAQaI7ilnA5C3QTA
	 CZWt5+5vpp9HhDnXRBn41lstsKZ7I9hdIsAZWA+vZqiNPrWPzJ21XssIGgZEUJCT2O
	 woGviD3wyKFRA==
Date: Thu, 13 Mar 2025 10:19:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: skip various tests on zoned devices
Message-ID: <20250313171902.GW2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-16-hch@lst.de>
 <20250312202759.GP2803749@frogsfrogsfrogs>
 <20250313073218.GH11310@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313073218.GH11310@lst.de>

On Thu, Mar 13, 2025 at 08:32:18AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 12, 2025 at 01:27:59PM -0700, Darrick J. Wong wrote:
> > > +# The dm-delay map added by this test doesn't work on zoned devices
> > > +_require_non_zoned_device $SCRATCH_DEV
> > 
> > Should this kind of check become a part of _require_dm_target?  Or does
> > dm-delay support zoned targets, just not for this test?
> 
> i.e. check for specific targets in _require_dm_target and reject them
> on zoned?  I can see if that would work.

Yeah, since it already switches on which target you ask for, and applies
per-target requirements checking.

--D

> > > +#
> > > +# The dm-flakey map added by this test doesn't work on zoned devices
> > > +# because table sizes need to be aligned to the zone size.
> > > +#
> > > +_require_non_zoned_device $SCRATCH_DEV
> > > +_require_non_zoned_device $SCRATCH_RTDEV
> > 
> > Can we fix the table sizes?
> 
> I'll take a look.
> 
> 
