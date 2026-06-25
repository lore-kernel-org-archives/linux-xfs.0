Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F1A1A9F87;
	Thu, 25 Jun 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782412462; cv=none; b=b9HZRCt5ZIIoh8iowZks2GzGWSEWLAyw+Z5wrFBG3vUSqHKdyr7zZqOyT9b74glSrmw6zQ9UzVDoaR/Kr9PDlpMaLRHb58jyut4PN0aXOPcMzIWK5OhsFFkj8F/EHmIdWZg8yzuUMcOrMB++jlmsPSvJ55McytM2hJw99NFvrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782412462; c=relaxed/simple;
	bh=pHQoJZlDXGdbkEvNoFjM+GBP/kzHaKrL2cfMVLf7qOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLRikW8lo9rTBD8hIFAC3XcKiXOuMzqcmenQp33vmeLeG/RD9Inhjd1oA8WPECNjtkGUp3MhgnOE6yiwDOJd47wrnm5Mfnnawx2AruvtZtT4qIltWNrDR8HWTEjWIAIt84R6RSccwjLUDEyYHqT+r7K9AN0rbIDF4WQxgY9dvEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntFGAqYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntFGAqYV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 968B61F00A3A;
	Thu, 25 Jun 2026 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782412461;
	bh=7qdGRTcI2C42MZUsxeAQJzaHCI5g2TXL/7WRDEDIO7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ntFGAqYVCGySrdEbnYX7oE05UmGobqxBM+K9rZyQSMP92tWaZ8W3GgsPGIPJvx2g2
	 aipRNds5nMPjjW77iYxq4+bW5Qcg14ga4cLl3e4CwGuvVyyD3eWqQyfy1swXRvifNO
	 BWTyyRbbJeyJaUkPMDMSOhTNSPEHhGTKvWAv59+ImngDuIR+lBO1p/QhiP3TFZBlwe
	 B4ajw5uXqqU0CHDLb4rZ1cHJuBNafMUN2K+RDuwJ1I/mmdGGtkDPJm8bZEzT8pqWfi
	 ttjI2Tg5NKf2i7hyaWjPynMbNLm5jgHfTDc0lp8PQ/x3WKJuZdXW5A6Tpih1MskXZV
	 UfeuX0ieEjXzg==
Date: Thu, 25 Jun 2026 11:34:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org,
	xfs-stable@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <20260625183421.GO6070@frogsfrogsfrogs>
References: <20250322143418.216654-1-pchelkin@ispras.ru>
 <aisAxyXVxf4wql2u@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260612233110.2-1-sashal@kernel.org>
 <ajBQPNuKCruxhkXX@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajD3Gb-vQkGU0N6b@nidhogg.toxiclabs.cc>
 <ajFQPY2m2A6ltvTH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ajFabPtI8UGfkyix@nidhogg.toxiclabs.cc>
 <CACzhbgS59uCYhjX80__+nPjEx=N8mKUsYyFS1+aRDpMA-b-VXQ@mail.gmail.com>
 <CAOQ4uxgXqmP49FV3b_cKDD_703bRHz0fjm=k=FmNytsPpnKx3g@mail.gmail.com>
 <ajKSytW_sBFJaBTW@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajKSytW_sBFJaBTW@nidhogg.toxiclabs.cc>

On Wed, Jun 17, 2026 at 02:31:01PM +0200, Carlos Maiolino wrote:
> On Wed, Jun 17, 2026 at 11:19:25AM +0200, Amir Goldstein wrote:
> > On Tue, Jun 16, 2026 at 7:33 PM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> > >
> > > I have changed teams so I no longer work on kernel and I don't believe
> > > my xfs maintenance work was backfilled ;(
> > >
> > > On Tue, Jun 16, 2026 at 7:19 AM Carlos Maiolino <cem@kernel.org> wrote:
> > > >
> > > > On Tue, Jun 16, 2026 at 09:31:41AM -0400, Hamza Mahfooz wrote:
> > > > > Cc: linux-xfs@vger.kernel.org
> > > > >
> > > > > On Tue, Jun 16, 2026 at 09:13:45AM +0200, Carlos Maiolino wrote:
> > > > > > On Mon, Jun 15, 2026 at 03:19:24PM -0400, Hamza Mahfooz wrote:
> > > > > > > Cc: Carlos Maiolino <cem@kernel.org>
> > > > > >
> > > > > > FWIW I don't maintain the stable trees I really don't have time for
> > > > > > that. Darrick/Leah have been doing a best effort case for that, but
> > > > > > again, this is mostly a best effort so we shouldn't expect them to be
> > > > > > looking/picking up every single possible patch suggested for stable.
> > > > > >
> > > > >
> > > > > Now that you mention it, the xfs-stable mailing list seems to be pretty
> > > > > much dead (i.e. the last time fixes from it were merged into stable was
> > > > > almost a year ago). I guess no one is really working on it anymore?
> > > >
> > > > IIRC Darrick started it, I personally never worked on it, but I didn't
> > > > follow the evolution there.
> > 
> > I think at this point we can officially declare xfs in stable <= 6.6
> > unmaintained
> > maybe need to send patches to LTS MAINTAINERS.
> > 
> > The best chance in this case to apply the requested fix to 6.6.y is that the
> > author (Darrick) approves it.
> 
> Unfortunately this might be true. But let's wait for Darrick's input
> please. He's on vacations this week so will be unfair to make any
> decisions in this matter without his input.
> Also he has been still poking people to tag patches with LTS versions
> so even though he might not me dealing with the xfs-stable, he might still
> be driving work on LTS trees.

I've really only been doing QA work on 6.12/6.18 LTS.  Ted Tso might
still be doing the older ones.  Catherine left Oracle last year.

--D
