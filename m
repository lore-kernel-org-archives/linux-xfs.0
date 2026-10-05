Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D259A4AD4B4;
	Mon,  5 Oct 2026 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211256; cv=none; b=ttYb4fyLItteqdBI8aW9fXXPtfX48ssh2BhwZhsbtA/hW/RKTJFC/IsP3A6O11gP6rQSzdeKah1J/UvxVjLSPu7o55WfFXTbsK2G5dmuGtYknP10eCet4nPtz47tsDzRC4yE762diJefLbXsyDiO/y/zbTKbPim33tMjXkg9mnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211256; c=relaxed/simple;
	bh=SKgit+ZOnwpEw/gEkoKd581GSr3oufWSl+xg/49ZHiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=og9a4sH1TNWDx/nWV2kSyXPGDBn4Qoa/fxdLd7Uz4u3RxvI9wA5fH1LUJATVCnEZa7u3duEqCAEp+3If39HjgLzKoatP3UdrXKNiu8mVJ2uh78qXfqsfxWIzLwFnPhis1jSEJFvHcHtGgcxcc9/2+bGYC0IhFWI8jIahUUWdseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k9sHGch7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k9sHGch7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 680F51F000FF;
	Mon,  5 Oct 2026 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791211245;
	bh=VOan8gJoGkfbHQH6EulspS4IvVIM1W9KxS50K2vYsDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k9sHGch7m9G5YPUtHjA0I5AAwodDIh91eMUTPJ07SXznA5zS5Pcr+w20VxNn4fNsm
	 mwiuwJW9sLHef7ZhzAADmvf/xD1HH/E3QsEoEPN4uP6IY5v0vYIYjNmdRHFaALdudl
	 K3hoJ1/rgym7+JM7+0kZzjILJt+mwYWoAe9LxxXskbl69zlyZaeED4HnP2onyXE6sz
	 zkHWR5BdZ8Db1QQ3ZLC6RmTK5DXmKqDJeibro+6hRO398E98tiLJud/jFADL49TLqa
	 wdF0qHeJd1iCHIJ7IkODZiRH7OwJin8z803PteIaml4sfkLE0vSP2W6vYTmcXR2AFV
	 TF0gkTbRjzpbw==
Date: Mon, 5 Oct 2026 07:40:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/12] xfs: avoid cross-rtgroup reaping after a repair
Message-ID: <20261005144044.GZ2705364@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
 <179014159798.1875436.7915121855965899039.stgit@frogsfrogsfrogs>
 <arS7tTCQGhyHjoou@infradead.org>
 <20260924193431.GR2705364@frogsfrogsfrogs>
 <asN2P4KND2F0cy6b@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asN2P4KND2F0cy6b@nidhogg.toxiclabs.cc>

On Mon, Oct 05, 2026 at 12:05:16PM +0200, Carlos Maiolino wrote:
> On Thu, Sep 24, 2026 at 12:34:31PM -0700, Darrick J. Wong wrote:
> > On Wed, Sep 23, 2026 at 10:57:09PM -0700, Christoph Hellwig wrote:
> > > On Tue, Sep 22, 2026 at 11:03:52PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > LOLLM notices that the extents stored in a xrtb_bitmap (aka xfs_rtblock
> > > > bitmap) can span multiple rtgroups due to two circumstances.  The first
> > > > is that the size of an rtgroup is an exact power of two, which means
> > > > that rtgroups are adjacent in the segmented xfs_rtblock_t address space.
> > > > This is fairly common to reduce the amount of multiplication and
> > > > division needed to handle space on the rt volume.
> > > > 
> > > > The second is that (unlike in the original rtgroups design), rtgroups do
> > > > not have fixed-location metadata like AGs do, which means that there's
> > > > nothing to force a break between rtgroups.
> > > > 
> > > > Therefore, we must loop through the rtgroups in xreap_rtmeta_extent to
> > > > avoid running off the end of an rtgroup while reaping.
> > > 
> > > This fix looks good.
> > > 
> > > Sashiko complains this could use some additional input sanitization,
> > > though.
> > 
> > Oh yeah.  If rgbno points into the gap between rtgroups, we should
> > advance *done to the start of the next rtgroup.
> 
> I think we can go with this series now and add that later, no need to
> re-send the series just for this case IMHO.

Sounds good to me.  All the patches that don't make it into first 24
batches can just slide into the last one. ;)

--D

> > 
> > --D
> > 
> 
