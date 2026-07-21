Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2394DC527;
	Tue, 21 Jul 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647139; cv=none; b=hAJnHU/qchTlrl7khLmsg0BY9JbfJOCiKyU9RaLzRRfQqTs54+JOQz937F1+aHI2D+duXhEuSVMIAyKNvdyXRDE2YE/wopaYN3MXBaPTc9Fj70fP13rpnHq5QuybUoQVrDkIytPBJWAdQMZmooNfHlC0HFUIeDcahu1Vq8Qcd/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647139; c=relaxed/simple;
	bh=w8CKdu3NyqihQy4NAOqmZwEmC/byP6Q9n3Z76ixqRM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzO6dYgJ+7Aiy45z8Ot4DeeG8u+gIaRmAHsU1ZjJmkCc4DObooTjUCQwCH82C+Yzy2Ndb1DOtAk73a0098AiGpTwG7cqKx4pQwLv0u7eHMMjS0kGB9zL+pwvi2NkUrQ1+VRpJtprHbJpbRF4pjIennMKWUCo0mHkotMbXJd7KdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaAWkCgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaAWkCgy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 55CA71F000E9;
	Tue, 21 Jul 2026 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784647133;
	bh=NR/hRBrwJM+A9daRxBJALCOFlcL+x4qHodtxxH+B5Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GaAWkCgyBcLCw3XoN2parGz1o/rV5ZUKX+eu1x7dn3fCTubiseURFssgA09rh45iE
	 6oflBzDLogPVVpOlu3Wfy/sirL3l+PeSln5BOWwG5aLS7SzRMJ+yenin7BBCOSWpH3
	 TPPdv8pmHD4xqF7rLbIpQgijLV4uLjZGIt+b7yumIYzp3cdYRpvIkUPJ/L0RU4OROX
	 vlTaoipSCXrCm3ViVd/L6ghu7LgKi1K1DIRj7SxlP09v7gyHf88QPPZWTk4US+1pvR
	 xQ+37glKahv6r3hDoja8+6bBWmVhHSDotsYl8m78PH78lCI3qExm3PLEQzyMCLTTff
	 VI0KLMl4sWhcQ==
Date: Tue, 21 Jul 2026 08:18:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <20260721151852.GA7358@frogsfrogsfrogs>
References: <20260720140849.2269776-1-hch@lst.de>
 <20260720140849.2269776-2-hch@lst.de>
 <d2c1b12e-c6ab-4614-b851-c42b808fc6eb@kernel.org>
 <20260721043011.GB6339@lst.de>
 <al86SnXSDqQ0sKkR@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al86SnXSDqQ0sKkR@nidhogg.toxiclabs.cc>

On Tue, Jul 21, 2026 at 11:23:29AM +0200, Carlos Maiolino wrote:
> On Tue, Jul 21, 2026 at 06:30:11AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 21, 2026 at 08:07:40AM +0900, Damien Le Moal wrote:
> > > > + * Update the BDI values to the max of the data and RT device to cover our
> > > 
> > > s/data/main ?
> > > I am still confused about the proper name for the device holding metadata :)
> > > 
> > > Other than this, this looks OK to me.
> > 
> > Historically the main device is called the data device, which is
> > also reflected in all kinds of field naming.  But yes, it is confusing
> > especially for zoned xfs setups.  Maybe I should do a little global
> > naming sweep..
> > 
> > 
> 
> +1, please keep /data/ here, this makes much more sense in xfs lingo...
> Perhaps we should start naming them to something like ndata (for normal
> data) and zdata for zoned data, but that's talk for another thread.

I've been trying to be consistent at calling them the 'datadev' and
'rtdev' (no spaces) so it's more obvious that I'm using a jargon.  But
'rt' makes no sense these days and I never did come up with a good
retcon for it though.

"RelaTive"?  Because the rtdev is "related" to the datadev by metadata?

:D

--D
