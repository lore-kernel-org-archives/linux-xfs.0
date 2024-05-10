Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09348481BA
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715367746; cv=none; b=DkbhtmaZ6fxCtRlyGlQCNf/MI/FIhdrAdBdXBBGLPYMiOmzFm5vVQkUndp9TJE4bvLwAbB0xcpU6+dc4r+E27AYhZ8G9kHXeABjcT8o4wwMu3IC0dgHJ4xCpM0KsPkC+XQZA9qEHwLY0D/iMELRWAZ2/6xHojdttEWPKlSiYujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715367746; c=relaxed/simple;
	bh=b3XIIE2ooS/9yOO4b0Kv9mIPB+32jwaVASjZVW3mjPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuesb9MDQoi3YOSn2PgTEC8cFcy0Fjzqy2ixVtjMii2Xic4v4sYEurydyDH7PrHykpf6f1HdKt8gMVFXQH3bbn0fYcrOCC+dLRFYKRXNATnSDw1VCnVLf4ubyq8nt/369FXo4sX/PV5ZmISm3/UxFpqHz7RbihMidXpoa8tqqzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhmTcJIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhmTcJIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAC9C2BD10;
	Fri, 10 May 2024 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715367745;
	bh=b3XIIE2ooS/9yOO4b0Kv9mIPB+32jwaVASjZVW3mjPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jhmTcJIqVQOKH+aIoTOa1KaVbQI2XedRUjaILN4XL2p5Mr3j2RYLrUQqevTEDOvfP
	 Vl7D44Lmio8UgfAc+mSfKBHN13/I/DW9EXwMTPDxyrra5DSd8kB9wVRwwp7drQyv8y
	 GxOTKcPn8wYfD8IX7+OsabfF5fdbFB81G7uYjWeI9SZkCozNjhqrqhvmO4mgB9rbWd
	 9TsHpzMa+2mLlOUMegp8I8/39kwK50JVvvYtKLZN/kWJMjf8ZjIz0Xq53ctVUEHfsV
	 AhMmijEVv/pcVQha92juLQuGQn+FoY0SonI+Vv8n5KhJS2yDqgB/Y7h9yviCaGo1+l
	 Xy89aX732pFog==
Date: Fri, 10 May 2024 12:02:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Philip Hands <phil@hands.com>,
	Debian Bug Tracking System <owner@bugs.debian.org>,
	linux-xfs@vger.kernel.org
Subject: Re: Processed: your mail
Message-ID: <20240510190224.GX360919@frogsfrogsfrogs>
References: <87jzk3qngi.fsf@hands.com>
 <handler.s.C.17152516831244576.transcript@bugs.debian.org>
 <sftag21AP5w8084Cro_9g-xWWPvsCuHmbxyU1r0_5V--fY8NhYuH9VxQsAXMgsJp3ZMV78f6jwKf4x-Csn87_g==@protonmail.internalid>
 <20240509144020.GH360919@frogsfrogsfrogs>
 <obz2jwsc32n6r3x6y4mqgaksirwep7tszox5zlw3ulhy3in2jx@gh56jssnbai3>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <obz2jwsc32n6r3x6y4mqgaksirwep7tszox5zlw3ulhy3in2jx@gh56jssnbai3>

On Fri, May 10, 2024 at 08:07:15PM +0200, Carlos Maiolino wrote:
> On Thu, May 09, 2024 at 07:40:20AM GMT, Darrick J. Wong wrote:
> > On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> > > Processing commands for control@bugs.debian.org:
> > >
> > > > tags 1070795 + d-i
> > > Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs
> > 
> > Yeah, someone needs to apply the patches in
> > 
> > https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/
> > 
> > and
> > 
> > https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/
> > 
> > which were not picked up for 6.7.  Unless the upstream maintainer
> > (Carlos) goes ahead with a 6.7.1?
> 
> I was planning to release 6.8 this week, do you think we still need a 6.7.1?

Nope. :)

(Are you going to LSF?)

--D

> Carlos
> 
> > 
> > --D
> > 
> > > Added tag(s) d-i.
> > > > thanks
> > > Stopping processing here.
> > >
> > > Please contact me if you need assistance.
> > > --
> > > 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> > > Debian Bug Tracking System
> > > Contact owner@bugs.debian.org with problems
> > >
> 
