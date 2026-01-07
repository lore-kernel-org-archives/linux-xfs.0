Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382133985B
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806157; cv=none; b=ecPouM2ocsDqbpwO7O5Y5Bq95uDtBbJJ4HnbI/RtpygwPTyIqfA8vRf6VkkF3Tx1sE1ev6ylElYWdl4Ymqdy1h4sDDJcEkknH0tySim14PJ1urwf6aPSGxeVyp4Dfqn0oJCfV1gXuL32GANQC/aFg45b2Ix0mH0XRYX7DGXlAY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806157; c=relaxed/simple;
	bh=nWISEEVsoxXQ+bEPOQZlzMaA9vqpkfi66p3gIveeRbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BB3ez4xfAcoONabasVPvgmsfBouE5OPl6R7S2Hus845rcFGKei4RsUpNDL9hiRBe/uDF0hUHb2WTqhak7Llj2rALlUFT85K0JikJV9nKHOHjAoJiShpWND4CeA9jTWVIVFjiNsgUFrx3esG20pa9snmL6rQdofE8rt0OKANIyzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y80YbQm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y80YbQm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECEBC4CEF1;
	Wed,  7 Jan 2026 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767806157;
	bh=nWISEEVsoxXQ+bEPOQZlzMaA9vqpkfi66p3gIveeRbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y80YbQm9fYFce7fe4sanFHcmEhNH1wQ5VjVZYkuZM2LGn36iE9IZ8v0HPnR+Q1vml
	 cGxVThlB1LrZmokZT8wZPbZTnIsQUfpgFdct6cUcCsZRZD6MRwuOHEwqwyYAMgbRyX
	 n/tAE+DK7xC0/U3Ny9/JlS2k+jbXxzf4khz1BpXUHciX0bmKtHMn7mdKOMEbuYOf5Q
	 K+tdaIiijfzveSkJqG83qTkENJmYeyz8sqmINqLDB/YokG9CqtS5ujjI07lWr9ZLL4
	 IuBZEQ+/hbYmydtlgRh9sh3RWOayb1DFwCVi9vXYaetuF991zTARhum7hWzWeo4inX
	 paQxUZkf/G64w==
Date: Wed, 7 Jan 2026 09:15:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: set rtstart from user-specified dblocks
Message-ID: <20260107171556.GB15551@frogsfrogsfrogs>
References: <20260106185314.GJ191501@frogsfrogsfrogs>
 <aV36RCNPxZxl5nZx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV36RCNPxZxl5nZx@infradead.org>

On Tue, Jan 06, 2026 at 10:16:36PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 10:53:14AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/211 fails to format the disk on a system with an internal zoned
> > device.  Poking through the shell scripts, it's apparently doing this:
> 
> On some anyway.  We've had this on our CI machines as well, and it's
> been on my todo list why it doesn't happen everywhere, so thanks for
> digging into this and getting it off my todo list :)
> 
> > # mkfs.xfs -d size=629145600 -r size=629145600 -b size=4096 -m metadir=1,autofsck=1,uquota,gquota,pquota, -r zoned=1 -d rtinherit=1 /dev/sdd
> > size 629145600 specified for data subvolume is too large, maximum is 131072 blocks
> > 
> > Strange -- we asked for 629M data and rt sections, the device is 20GB in
> > size, but it claims insufficient space in the data subvolume.
> > 
> > Further analysis shows that open_devices is setting rtstart to 1% of the
> > size of the data volume (or no less than 300M) and rounding that up to
> > the nearest power of two (512M).  Hence the 131072 number.
> > 
> > But wait, we said that we wanted a 629M data section.  Let's set rtstart
> > to the same value if the user didn't already provide one, instead of
> > using the default value.
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v6.15.0
> > Fixes: 2e5a737a61d34e ("xfs_mkfs: support creating file system with zoned RT devices")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |   31 +++++++++++++++++++++----------
> >  1 file changed, 21 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index b34407725f76df..ab3d74790bbcb8 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3720,17 +3720,28 @@ open_devices(
> >  		zt->rt.zone_capacity = zt->data.zone_capacity;
> >  		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
> >  	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
> > -		/*
> > -		 * By default reserve at 1% of the total capacity (rounded up to
> > -		 * the next power of two) for metadata, but match the minimum we
> > -		 * enforce elsewhere. This matches what SMR HDDs provide.
> > -		 */
> > -		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
> > -					      BTOBB(300 * 1024 * 1024));
> > +		if (cfg->dblocks) {
> > +			/*
> > +			 * If the user specified the size of the data device
> > +			 * but not the start of the internal rt device, set
> > +			 * the internal rt volume to start at the end of the
> > +			 * data device.
> > +			 */
> > +			cfg->rtstart = cfg->dblocks << (cfg->blocklog - BBSHIFT);
> 
> Overly long line here.
> 
> > +		} else {
> > +			/*
> > +			 * By default reserve at 1% of the total capacity
> > +			 * (rounded up to the next power of two) for metadata,
> > +			 * but match the minimum we enforce elsewhere. This
> > +			 * matches what SMR HDDs provide.
> > +			 */
> > +			uint64_t rt_target_size = max((xi->data.size + 99) / 100,
> > +						      BTOBB(300 * 1024 * 1024));
> 
> And here as well.  Maybe split the sizse calculation into a helper
> to make these a bit more readable?

Fixed:

static uint64_t
calc_rtstart(
	const struct mkfs_params	*cfg,
	const struct libxfs_init	*xi)
{
	uint64_t			rt_target_size;
	uint64_t			rtstart = 1;

	if (cfg->dblocks) {
		/*
		 * If the user specified the size of the data device but not
		 * the start of the internal rt device, set the internal rt
		 * volume to start at the end of the data device.
		 */
		return cfg->dblocks << (cfg->blocklog - BBSHIFT);
	}

	/*
	 * By default reserve at 1% of the total capacity (rounded up to the
	 * next power of two) for metadata, but match the minimum we enforce
	 * elsewhere. This matches what SMR HDDs provide.
	 */
	rt_target_size = max((xi->data.size + 99) / 100,
			     BTOBB(300 * 1024 * 1024));

	while (rtstart < rt_target_size)
		rtstart <<= 1;
	return rtstart;
}

and then the callsite turns into cfg->rtstart = calc_rtstart(...).

> Otherwise this looks good.

Thanks!

--D
