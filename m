Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D01937A840;
	Thu,  2 Jul 2026 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006265; cv=none; b=VPlaL1SijuAiqzowOKq6CWNPvgGbw4WiZSXpmM6MvViaQd2CxZWtGN/2RqZwnrab0hxUOQE4t2EN4xpaCJlcEdUqiNfJB57vmJznoTTICv1IFdnCJBU4H0wCNZ9/anE3rA5mDHI384sX3RpHDMBgeoq6joqFnT3u518BIxRz0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006265; c=relaxed/simple;
	bh=3wCSwzw6ihpUMvgbR5ptKuzF6Xev0Hsd4W5EQsoILoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jwwj4QZ7FmYqmIWMo+HrGAXUY4CFygKHkBEmAVjLfLvvF1Wd2d+NlUrukqRWi8nE0zQ8j//ZE7BXoHfZwJZhu2qBT1zfscOezpNdMCUMUERFh7Sh4HJluipjLfdjEp/qKHRhtT4n0CJxZ5GCxOUYYCoHTvsNzvDjAUIAGA/CEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwCMtRBO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwCMtRBO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E78C31F000E9;
	Thu,  2 Jul 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006263;
	bh=88OAjTQ/GtsnARt4KNnNaNmYL+xYbYOWeaQROWVJI+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PwCMtRBOIdztjlCdPB1b2+k5nod5PRo6Ktw3oxoUlkIW3wQkO1e+TflCn8kvjVPnV
	 yiG8ENuZz618En8XyBCSMhZ4va7NRDWyMBffVwmFMS89+aAvYP0yB31OEJuZW1WiVT
	 rwp/boOS0rTZFKvyAlvqq+CyUNZC0jUHSFH3mtFy2KMO+R87OQaxe+YmuOKX9LPBae
	 qsR/1x/N4Peo7wH9e3LXKfxGjtk1u2Cb0SssL786+5yN0G4255xDimZ2N+N7n6z5uV
	 dhYqjGdAISuh9tMXi+9FfLpWHBHZFrIHyBzIsINvQstD5pp2sG2S/jSZ+lxDxW4/Ko
	 qF7Doi6aymKZQ==
Date: Thu, 2 Jul 2026 08:31:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <20260702153102.GA9392@frogsfrogsfrogs>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org>
 <20260701155234.GF6526@frogsfrogsfrogs>
 <akZF4ib9KpSxnBQ3@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZF4ib9KpSxnBQ3@infradead.org>

On Thu, Jul 02, 2026 at 04:05:06AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 01, 2026 at 08:52:34AM -0700, Darrick J. Wong wrote:
> > > This almost sounds like we should explicitly zero this case just for that
> > > particular case.  Although Darrick was kinda heading in a different
> > > direction and I don't want to start a fight here.
> > 
> > I'm fine with either solution; I simply prefer the one that fixes all
> > the current and future "oops we forgot to zero a hidden padding" bugs in
> > one action.
> 
> Maybe we should avoid creating hidden zero padding to start with? :)
> But this is a small allocation, and most of it gets overwritten
> while the cache is still hot, so I can live with the unconditional
> zeroing.  Still feels a bit odd to reach for the big hammer.

<shrug> If this is truly the only place where we forget to initialize
if_broot fully then I'm ok with just doing that and not going for
GFP_ZERO.  If we have an army of KASAN syzbotters whacking away at the
system, then I could reevaluate my resistance to whack-a-mole.

--D
