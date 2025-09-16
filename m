Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F375B3043B3
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 10:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018394; cv=none; b=mrYFVoVP/gQwU6aoaarnGBfUH2ccKoiuJ515wvCTFTmUUQMW0gLS0eBuSrw0OV8kGda29bdZZSOAH6zO9Glfh+8AMHNzilYMiROlsm77ZMY+mMhAA5N/BNqbqbLSZzKk0MDls/jvGVPtyYulWjuW8Reaqvu6rsWifieUqWBVWfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018394; c=relaxed/simple;
	bh=QsvO+BO+jm7cXiWqyuST3j2wmhHd4w1EfhAvtpwd9a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okludjsVunpikRRjVy2/V5IGcQo84eLSTkRc7B9n6zLIQdhOkxl/BuXmp5FbJEcgrwVM8qu0UpUo7JWDuiU2f5qcryys7LPcQPdGlSdoAeTVlMYfChmle5NwuC6gmUJgByJfVB/7ftKfNcXQzXoUgV5RKNp43bvti16X0OMb2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJoiBgiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJoiBgiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B6BC4CEEB;
	Tue, 16 Sep 2025 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758018393;
	bh=QsvO+BO+jm7cXiWqyuST3j2wmhHd4w1EfhAvtpwd9a4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJoiBgiEL6eRoyIwpz1nqUhtxDqEfFljKtAo74PF5SQ6plZOxHrYKUhzHCdHwyfHo
	 L+AASmBt5XbXa01jWFhULCxcAeoUTJG+hiSxJ6Tfno7O6DlndO6/xmYDJ341HVZO/E
	 lSW7lMIR2jVBOgg/4v7jEnKTut1J26KaQEpU/Qupyl65wyPxWcUYbyzeo9g2oCgCWA
	 5oX+QZklpIEXLaJpQ2h+Y6F3weSB0uVTp7YJgyTM214O0ibj0E6bVuFnspfTDGeZqy
	 X3TDYFh8WF7InuhpYaI+vMUszXgTHxAe31nCKp8MtiJkycaWVQN74GTCDArXNPNE9Q
	 E8CyvffsHkHYw==
Date: Tue, 16 Sep 2025 12:26:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix log CRC mismatches between i386 and other
 architectures
Message-ID: <fbo64pgrfrz4nyc75tj7dzv3ctmozdvoq4enrfe4n54x5s23lj@zs5u3ziruo2c>
References: <20250915132047.159473-1-hch@lst.de>
 <20250915132047.159473-3-hch@lst.de>
 <20250915182513.GP8096@frogsfrogsfrogs>
 <gBaRcE3A7lMPsrrw9Ct-5I-zvYoRDz3D9gT0aOWI0HM0TjgWbH9itNzXEkaG5nNQbE0KaYPLvIX6Y0OnVVwL6Q==@protonmail.internalid>
 <20250915205049.GB5650@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915205049.GB5650@lst.de>

On Mon, Sep 15, 2025 at 10:50:49PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 15, 2025 at 11:25:13AM -0700, Darrick J. Wong wrote:
> > ...and let me guess, the checksum function samples data all the way out
> > to byte 324/328 too?
> 
> Yes.
> 
> > > Fixes: 0e446be44806 ("xfs: add CRC checks to the log")
> >
> > Cc: <stable@vger.kernel.org> # v3.8
> 
> Still not a fan of the explicit stable tag vs implying it by fixes,
> but yes, this should be backported.

I'll add it here...


> 
> > > +	 * We now do two checksum validation passes for both sizes to allow
> > > +	 * moving v5 file systems with unclean logs between i386 and other
> > > +	 * (little-endian) architectures.
> >
> > Is this a problem on other 32-bit platforms?  Or just i386?
> 
> The alignment is an i386-specific quirk.  We have similar workarounds
> for the extent structure in the EFI/EFD items and some 32-bit ioctls,
> except that this one can be a bit simpler.
> 
