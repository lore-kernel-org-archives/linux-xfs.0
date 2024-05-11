Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A3D522A
	for <linux-xfs@vger.kernel.org>; Sat, 11 May 2024 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715414203; cv=none; b=q3gOXBeNkspMx3MOYk9zI5Id+dwD7reK7lv2aaFMQ5egZAmAzLPbiZgp/rRSrmC5HlBrLC80lYKh+CrpOAkNCyzqUeX0WTzDTzEIBsD00eKVX+hWqNzzgJL2lOmEs+WP5pFJJeQBVEkZbJ6LjglsknzAdCoGCeqS5ZwV8BzW0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715414203; c=relaxed/simple;
	bh=CzUuSRkUBFSAQIO421GoZqI0RdKMHuHuGiOZeS16XG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXf5My60dBUFNwUhSnHLFzB8RRGFJUeCKXYDG2aI0rVgF2RToWifPtvktwLd4dcwkCLLLuYiy0fp1/p0L2icuJTSR69VIIdKE0umvXuwDVWZa/zGAxRdd77CeJfatiR7FwFOFGeRze2h7je3CTxGGrtBWLI69/zcQoknQLYN5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxLRRnrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxLRRnrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD62BC2BD10;
	Sat, 11 May 2024 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715414203;
	bh=CzUuSRkUBFSAQIO421GoZqI0RdKMHuHuGiOZeS16XG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SxLRRnrEovLAN2Vzg8ZoPRKZKskWk8eBySt2TSivI20kZWYhmJYMwSdtgqm55H8SP
	 U1pOi6amCLSgW49ShwyyccewPLIY89h/c1+QgS2bAAPUFajp91hX5qNUl+H3YGUxG6
	 VDHvMySAavYBTDKuVNXkcaLtlSJSuiV8Aus5+7tL/PZSK4lhwg+SpEwXOCN8I54VT4
	 9T0UuzclN2X2Yor45p6kxbiCrHq0JKkY2/9lQSSUHhypkQJ7FPcSwRwMl+BX6wgZ4R
	 yQuIFZwolz9yG5fOODn7QYoIsDhnuYI6rw+ScZE1R4W0tsbDnBXXGNpmHbJQJThd1t
	 U/sa4UknChPfw==
Date: Sat, 11 May 2024 09:56:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Philip Hands <phil@hands.com>, 
	Debian Bug Tracking System <owner@bugs.debian.org>, linux-xfs@vger.kernel.org
Subject: Re: Processed: your mail
Message-ID: <7tbjznejwdh4xvau2lzydjrdvmdjrpskployrdlflz7qizmvfd@44h7xy5azpsu>
References: <87jzk3qngi.fsf@hands.com>
 <handler.s.C.17152516831244576.transcript@bugs.debian.org>
 <sftag21AP5w8084Cro_9g-xWWPvsCuHmbxyU1r0_5V--fY8NhYuH9VxQsAXMgsJp3ZMV78f6jwKf4x-Csn87_g==@protonmail.internalid>
 <20240509144020.GH360919@frogsfrogsfrogs>
 <obz2jwsc32n6r3x6y4mqgaksirwep7tszox5zlw3ulhy3in2jx@gh56jssnbai3>
 <TLD_gdK3W_NDMW08YboQXFb_7tZw-n38a6bw0BAxp0ocanZbBkNUsefBGU_swPrDsV-GExWhpFcpnFZcGzLwfA==@protonmail.internalid>
 <20240510190224.GX360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510190224.GX360919@frogsfrogsfrogs>

On Fri, May 10, 2024 at 12:02:24PM GMT, Darrick J. Wong wrote:
> On Fri, May 10, 2024 at 08:07:15PM +0200, Carlos Maiolino wrote:
> > On Thu, May 09, 2024 at 07:40:20AM GMT, Darrick J. Wong wrote:
> > > On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> > > > Processing commands for control@bugs.debian.org:
> > > >
> > > > > tags 1070795 + d-i
> > > > Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs
> > >
> > > Yeah, someone needs to apply the patches in
> > >
> > > https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/
> > >
> > > and
> > >
> > > https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/
> > >
> > > which were not picked up for 6.7.  Unless the upstream maintainer
> > > (Carlos) goes ahead with a 6.7.1?
> >
> > I was planning to release 6.8 this week, do you think we still need a 6.7.1?
> 
> Nope. :)
> 
> (Are you going to LSF?)

No, I won't :( But I'll be in LPC, will you? :)

Carlos

> 
> --D
> 
> > Carlos
> >
> > >
> > > --D
> > >
> > > > Added tag(s) d-i.
> > > > > thanks
> > > > Stopping processing here.
> > > >
> > > > Please contact me if you need assistance.
> > > > --
> > > > 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> > > > Debian Bug Tracking System
> > > > Contact owner@bugs.debian.org with problems
> > > >
> >
