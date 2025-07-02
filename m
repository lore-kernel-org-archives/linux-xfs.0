Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785062F7D00
	for <linux-xfs@vger.kernel.org>; Wed,  2 Jul 2025 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482890; cv=none; b=huO2ip3T4BfSI9+eL1mKKooSTxFcwYvZ7dl5ujEkfgCLXaorzsEBZvaluRyzRQDBnRL0arh47XhhS4ynWOFx/Xk8o4TJaF5p76Qsu9GKfCXSK8qH5gZCgl3uYvow9BmJ08qeYtUQwsu1c2avEyU3gKBm/4TjvOsjifJdWFaotI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482890; c=relaxed/simple;
	bh=w8fcYKR+zibjWMznn+rbKCTGSFRA8TljVvKZ6qGP9Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiHzwHUHuiQakyOZayucMcI0nCoBi+Nn9dezMg2Ynk2d5BCLrc28JIwUSKTpN9P2mcM7Y6boRtQRgbRo4WddFnNnXiaFK5gvcTk3SwDTz9PXYvwsub4lHb/bGPj5kAfJzF7iC8OWOsNROLZ7BJwm+SAW2QBLQ53VNwXa8w+xosg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIyeDTpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIyeDTpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38D6C4CEE7;
	Wed,  2 Jul 2025 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751482890;
	bh=w8fcYKR+zibjWMznn+rbKCTGSFRA8TljVvKZ6qGP9Kk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EIyeDTpgASffnSjZ+eNvLmmykYZ7NUM8Vliu40ulEGzSh0EiQe7zbPbqzT/ezqHt6
	 na21co1jIqLBBZ4rUPZnzHBtMITtuw8/dzQbYYz0ypOued2glDWWNzMnLO98+84WJl
	 DdN3XV9QRfVZTwmUDvHYuDQGPasjyeqMbl9iX7/Wl0bJPptmq1bokWOUm0GD7/xjHt
	 Tzeh5IyZGjuoAZlW6OTQrQk+MUN3wPyCRA3T1QcGauafShP4BWgJgOa5951FuwrRi+
	 yOFQgmQjNieeUUhNhD2QJrcXh8WsRyme4JuMkRRnWpT+REJO1Dbay/c15oOiiz0/0g
	 5Ksd2dPadZoEw==
Date: Wed, 2 Jul 2025 12:01:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, catherine.hoang@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] mkfs: allow users to configure the desired maximum
 atomic write size
Message-ID: <20250702190129.GA10009@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303966.916168.14447520990668670279.stgit@frogsfrogsfrogs>
 <b131893c-9952-4f23-8332-2191c3d1198c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b131893c-9952-4f23-8332-2191c3d1198c@oracle.com>

On Wed, Jul 02, 2025 at 09:50:04AM +0100, John Garry wrote:
> On 01/07/2025 19:08, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Allow callers of mkfs.xfs to specify a desired maximum atomic write
> > size.  This value will cause the log size to be adjusted to support
> > software atomic writes, and the AG size to be aligned to support
> > hardware atomic writes.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> thanks, regardless of comments below, FWIW:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> >   		goto validate;
> > @@ -4971,6 +4998,140 @@ calc_concurrency_logblocks(
> >   	return logblocks;
> >   }
> > +#define MAX_RW_COUNT (INT_MAX & ~(getpagesize() - 1))
> > +
> > +/* Maximum atomic write IO size that the kernel allows. */
> 
> FWIW, statx atomic write unit max is a 32b value, so we get a 2GB limit just
> from that factor

<nod> But we might as well mirror the kernel's calculations...

> > +static inline xfs_extlen_t calc_atomic_write_max(struct mkfs_params *cfg)
> > +{
> > +	return rounddown_pow_of_two(MAX_RW_COUNT >> cfg->blocklog);
> > +}
> > +
> > +static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
> > +{
> > +	return 1 << (ffs(nr) - 1);
> > +}
> > +
> > +/*
> > + * If the data device advertises atomic write support, limit the size of data
> > + * device atomic writes to the greatest power-of-two factor of the AG size so
> > + * that every atomic write unit aligns with the start of every AG.  This is
> > + * required so that the per-AG allocations for an atomic write will always be
> > + * aligned compatibly with the alignment requirements of the storage.
> > + *
> > + * If the data device doesn't advertise atomic writes, then there are no
> > + * alignment restrictions and the largest out-of-place write we can do
> > + * ourselves is the number of blocks that user files can allocate from any AG.
> > + */
> > +static inline xfs_extlen_t
> > +calc_perag_awu_max(
> > +	struct mkfs_params	*cfg,
> > +	struct fs_topology	*ft)
> > +{
> > +	if (ft->data.awu_min > 0)
> > +		return max_pow_of_two_factor(cfg->agsize);
> > +	return cfg->agsize;
> 
> out of curiosity, for out-of-place atomic writes, is there anything to stop
> the blocks being allocated across multiple AGs?

Nope.  But they'll at least get the software fallback, same as if they
were writing to a severely fragmented filesystem.

--D

--D
