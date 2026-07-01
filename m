Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC61372665;
	Wed,  1 Jul 2026 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782923593; cv=none; b=dc3phKgLtfSH3P/Cm/pY3KAvESfEFJYdtxkgxpF0SxG0PKmzO4KsihoHJsnVYvNykqtLkqRz7Zfo2Oq/Ae9RFaEaH9NuOw3SjV8oDjKTna7OIGxN0DBM5JPqz0pYc/VYHdNwr307Drbs2lDKo60jTCLxgjfvxr15tsZV2O1WkJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782923593; c=relaxed/simple;
	bh=0O9t1tSW9YfYk8QA/2Mz/IGLCxAsLbduu3bCC9RWh80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VidtfDOoO7XHV3/n1Jef4VPwf/WKqkMjPa5KntYSHELT79huIcs6yP2+MmFQJytcBqZbRs73UfhIAQkW8LpZbywLhXFewhsy/xhOkuui4x7hJm86V7+312F1ScVEOzZ3UILj4VdUzyDL6iJzxxiDCMX4G65Fc90eLF/WV6HFZ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cyqs4l3b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cyqs4l3b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D543A1F000E9;
	Wed,  1 Jul 2026 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782923590;
	bh=JgWpcCcEJlgI18zAnaxSSxs31O3rZqKIde8ESLBbl58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cyqs4l3bKZWQQmmdEFKG4KeMAGlk09rG3dzqnFaYOS78zkoBGk+T+4LlOw2HlIu7G
	 aUKhduciD+oTLynKp6RHPTayp0cE8K0l4iL1KtmrYlxenJOpxpfShccuy0UzRnoIo6
	 j9GIJrJqQIlmJJiD4u7e2HNhlfKcXow02C7YBRGmHLSn94rxIWn13Q/LW3fAG/SjKO
	 EproLb5GRdFPnZORcWcSZaZwGZAKVindRMCEz6Sahg8rutD3jweoXQ6PMWLYZjn+QX
	 nGKeKKYdgL6CL8saUrQZcoffTdH3t7ZcSGdQux7I44Buj8X29F5jLXfYV5wvUALB8U
	 aMdmvxzZS0kwA==
Date: Wed, 1 Jul 2026 09:33:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Carlos Maiolino <cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org,
	xfs-stable@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <20260701163310.GB6517@frogsfrogsfrogs>
References: <20260612233110.2-1-sashal@kernel.org>
 <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>
 <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
 <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
 <CAOQ4uxgXqmP49FV3b_cKDD_703bRHz0fjm=k=FmNytsPpnKx3g@mail.gmail.com>
 <ajKSytW_sBFJaBTW@nidhogg.toxiclabs.cc>
 <20260625183421.GO6070@frogsfrogsfrogs>
 <akRTtCIZZ0IZ0Omc@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akRTtCIZZ0IZ0Omc@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Tue, Jun 30, 2026 at 07:39:32PM -0400, Hamza Mahfooz wrote:
> On Thu, Jun 25, 2026 at 11:34:21AM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 17, 2026 at 02:31:01PM +0200, Carlos Maiolino wrote:
> > > On Wed, Jun 17, 2026 at 11:19:25AM +0200, Amir Goldstein wrote:
> > > > On Tue, Jun 16, 2026 at 7:33 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > > > >
> > > > > I have changed teams so I no longer work on kernel and I don't believe
> > > > > my xfs maintenance work was backfilled ;(
> > > > >
> > > > > On Tue, Jun 16, 2026 at 7:19 AM Carlos Maiolino <cem@kernel.org> wrote:
> > > > > >
> > > > > > On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> > > > > > > Cc: linux-xfs@vger.kernel.org
> > > > > > >
> > > > > > > On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > > > > > > > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > > > > > > > Cc: Carlos Maiolino <cem@kernel.org>
> > > > > > > >
> > > > > > > > FWIW I don't maintain the stable trees I really don't have time for
> > > > > > > > that. Darrick/Leah have been doing a best effort case for that, but
> > > > > > > > again, this is mostly a best effort so we shouldn't expect them to be
> > > > > > > > looking/picking up every single possible patch suggested for stable.
> > > > > > > >
> > > > > > >
> > > > > > > Now that you mention it, the xfs-stable mailing list seems to be pretty
> > > > > > > much dead (i.e. the last time fixes from it were merged into stable was
> > > > > > > almost a year ago). I guess no one is really working on it anymore?
> > > > > >
> > > > > > IIRC Darrick started it, I personally never worked on it, but I didn't
> > > > > > follow the evolution there.
> > > > 
> > > > I think at this point we can officially declare xfs in stable <= 6.6
> > > > unmaintained
> > > > maybe need to send patches to LTS MAINTAINERS.
> > > > 
> > > > The best chance in this case to apply the requested fix to 6.6.y is that the
> > > > author (Darrick) approves it.
> > > 
> > > Unfortunately this might be true. But let's wait for Darrick's input
> > > please. He's on vacations this week so will be unfair to make any
> > > decisions in this matter without his input.
> > > Also he has been still poking people to tag patches with LTS versions
> > > so even though he might not me dealing with the xfs-stable, he might still
> > > be driving work on LTS trees.
> > 
> > I've really only been doing QA work on 6.12/6.18 LTS.  Ted Tso might
> > still be doing the older ones.  Catherine left Oracle last year.
> 
> Any idea on potential paths forward for getting this series in
> particular into 6.6.y?

Run fstests, and if there are no new regressions, ask sasha/greg to
queue it.

--D
