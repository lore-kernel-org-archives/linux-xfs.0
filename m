Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD825D20C;
	Thu, 13 Mar 2025 07:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741851144; cv=none; b=ZyEIYj3ocYB1o6rTWNb9rCtUwg73F1tLnsIFVqJFFkju0lGkdUcxnVpL2nS38TD0rtXz8qW/hFOYCgtVxjf3Jp+G8aZW5YjTHkABPsBJnMMtbkLdym5mn1q/XnpKHgO9DXGVe/tAGOxiuCaKc+9RJdPflqSIxLdVcbQEtLlFn2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741851144; c=relaxed/simple;
	bh=wKOm8g/vjur08OVXHijTxctoL1VCAymqKWDnsVeZK3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZmfWy07mUPcEMPY9sZ3/1yoy+oRTG5N4bvdBcO+eJ0rrIRsuSC9URSIcnzop+17lVCjKS7YBs75M7d7Ho+ea0Y4kIf+Ldj3IVzr23iOkG6AxmaCGYVPu51ChpVpaDBUzPDbJ4Q/PaivAXPySY6ORXMviY5h6ujionlaUt4E4IpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDE8568C4E; Thu, 13 Mar 2025 08:32:18 +0100 (CET)
Date: Thu, 13 Mar 2025 08:32:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: skip various tests on zoned devices
Message-ID: <20250313073218.GH11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-16-hch@lst.de> <20250312202759.GP2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312202759.GP2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:27:59PM -0700, Darrick J. Wong wrote:
> > +# The dm-delay map added by this test doesn't work on zoned devices
> > +_require_non_zoned_device $SCRATCH_DEV
> 
> Should this kind of check become a part of _require_dm_target?  Or does
> dm-delay support zoned targets, just not for this test?

i.e. check for specific targets in _require_dm_target and reject them
on zoned?  I can see if that would work.

> > +#
> > +# The dm-flakey map added by this test doesn't work on zoned devices
> > +# because table sizes need to be aligned to the zone size.
> > +#
> > +_require_non_zoned_device $SCRATCH_DEV
> > +_require_non_zoned_device $SCRATCH_RTDEV
> 
> Can we fix the table sizes?

I'll take a look.

