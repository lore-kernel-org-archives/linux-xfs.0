Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AD3F1AB2;
	Wed, 17 Jun 2026 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781699472; cv=none; b=K1obk/JTsYf0fCZnb7ZCE/+P8d6OFh+6h+/Z1xiVU0LpxelhQSegVpq3xXv73i2ZgqBdYbufUpTvB+kvdWtvn7nEEciIs9C2l+znDj08nZFHThh4q0MiIDtVT0cmKnmZC8R+6Y4AxhECXpnermaBna1ng301cz/ROVY7kEw8Ys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781699472; c=relaxed/simple;
	bh=GrGTI8a4oj/pksGdFmbK0N88ozLr60wbX3NY439HgAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niZOgyz80oKxVUsGF/VVfWTUSt7Pu+FMYs7MolDUktG3Y3NNgkkkaKQX6JqKqqdV6im7n2B+8wfCf1RRMFp7JVCEMDrdOdfYh9fGhgMEP4gk5zKV8EXLYMRuxdvYX3Ft2110lJCUms4Q6dG+2KkUC/GRdXXv4MLSVMIB7+f2cLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAmUlqUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAmUlqUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588481F000E9;
	Wed, 17 Jun 2026 12:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781699470;
	bh=uLu8ShXl0Y2YxWQom10gkSNouCyBlM04U9LSELPsG9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WAmUlqUKvUP+p7yOixVSlSWFhtTdaKcNfjOrHvTIDMEQbJoZG5nE5hFweeqWxWFjs
	 hDqBVTAbjgYYuY4/SfoZZ1q67bf3FKq30fYfaJo8Ts6BtufqRg7AmizH67IOSy6FPm
	 HcaYZydmmW6HvDRYBPxRLpSnWfcYR7qcyWeI7PsgEyojsFoBvnxHYuI2g9S4euYNk5
	 CioB0mIXp+g5eDSTlaPvKSy44dUeMsQrOZBZKxHOkDc9jc1HKFFQ1PH/dKCQtVrc4Y
	 /bjNVzYrA5u0ULZv9aTuI1qH0T5UNGxHvVFXFn6qImu55yrq1VXl57hdz1Xkfrk7hD
	 xWepBqtVdnJQA==
Date: Wed, 17 Jun 2026 14:31:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, Sasha Levin <sashal@kernel.org>, 
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org, xfs-stable@lists.linux.dev, 
	Christoph Hellwig <hch@lst.de>, Catherine Hoang <catherine.hoang@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org, 
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <ajKSytW_sBFJaBTW@nidhogg.toxiclabs.cc>
References: <20250322143418.216654-1-pchelkin@ispras.ru>
 <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org>
 <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>
 <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
 <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
 <CAOQ4uxgXqmP49FV3b_cKDD_703bRHz0fjm=k=FmNytsPpnKx3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgXqmP49FV3b_cKDD_703bRHz0fjm=k=FmNytsPpnKx3g@mail.gmail.com>

On Wed, Jun 17, 2026 at 11:19:25AM +0200, Amir Goldstein wrote:
> On Tue, Jun 16, 2026 at 7:33 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > I have changed teams so I no longer work on kernel and I don't believe
> > my xfs maintenance work was backfilled ;(
> >
> > On Tue, Jun 16, 2026 at 7:19 AM Carlos Maiolino <cem@kernel.org> wrote:
> > >
> > > On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> > > > Cc: linux-xfs@vger.kernel.org
> > > >
> > > > On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > > > > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > > > > Cc: Carlos Maiolino <cem@kernel.org>
> > > > >
> > > > > FWIW I don't maintain the stable trees I really don't have time for
> > > > > that. Darrick/Leah have been doing a best effort case for that, but
> > > > > again, this is mostly a best effort so we shouldn't expect them to be
> > > > > looking/picking up every single possible patch suggested for stable.
> > > > >
> > > >
> > > > Now that you mention it, the xfs-stable mailing list seems to be pretty
> > > > much dead (i.e. the last time fixes from it were merged into stable was
> > > > almost a year ago). I guess no one is really working on it anymore?
> > >
> > > IIRC Darrick started it, I personally never worked on it, but I didn't
> > > follow the evolution there.
> 
> I think at this point we can officially declare xfs in stable <= 6.6
> unmaintained
> maybe need to send patches to LTS MAINTAINERS.
> 
> The best chance in this case to apply the requested fix to 6.6.y is that the
> author (Darrick) approves it.

Unfortunately this might be true. But let's wait for Darrick's input
please. He's on vacations this week so will be unfair to make any
decisions in this matter without his input.
Also he has been still poking people to tag patches with LTS versions
so even though he might not me dealing with the xfs-stable, he might still
be driving work on LTS trees.
