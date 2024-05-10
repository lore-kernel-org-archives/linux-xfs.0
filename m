Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE19F1E525
	for <linux-xfs@vger.kernel.org>; Fri, 10 May 2024 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715364440; cv=none; b=I3hrKLnyywdolclWzpRN/JUcKWtnbjPNbVIjuGOATohsP5bm2Wx+brrSMeKk0etjxuk8fe7INdf6zRpIRzY3MpCAuwhDsYh51XUhV7B70K3hlRwUn7HIfx3BgYa/m0ZvL0iMUTgcHoTphtpmr5sabmoelZBZOC8GUahXmj9KcWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715364440; c=relaxed/simple;
	bh=RcIGrulAA8wKzQmP1KW1cXnC7rBkArYMHfYRB4vIYUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnMAYmeIlVklm4r1vLqOclfPHCOj4VDsAkMBVt4s4GKGihbnVKiCjcMD2v8pqOgAE8OgOPus6OXoWSRfB4KzmFYrREzeFvxhucERiprNSFeFq/3Oj2lsBJOIR8AWboZIMFykgshl0w312bLwKOURIaRJOXI7skZHYnx7tCNQpgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCeIw/9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCeIw/9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380EC113CC;
	Fri, 10 May 2024 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715364439;
	bh=RcIGrulAA8wKzQmP1KW1cXnC7rBkArYMHfYRB4vIYUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hCeIw/9eHVvzoB7PHCRdXuMFCxe9jVhf8CM08VqbE5mNiu99uP9xLqduX7CH8SfvV
	 ianZmEMbEeXjSgRiqR/h+H4pQLbq0lNWfyx2O6Qyt19Nz4RXvRLGYJhirKmRDEkqNR
	 x2xOkGip0MApECSnmGx5mpgPeXCJQdLFF4/0KKBqlpyqiKvph/4DMes+xeKRT5q8Nj
	 zujpdfLvsikls6M4//UD0sUnYoG0XOVmlph+rDkgZPgOsKQ1bB9/jpDBlB7VyrYUFO
	 8c1MBdoSQytKHYEmeY6dE2FLzutOikO9YZXkiPcW8S/4jz2GbZ/1H1u/yRwvA7lpoR
	 b+eExLjWa9dZQ==
Date: Fri, 10 May 2024 20:07:15 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Philip Hands <phil@hands.com>, 
	Debian Bug Tracking System <owner@bugs.debian.org>, linux-xfs@vger.kernel.org
Subject: Re: Processed: your mail
Message-ID: <obz2jwsc32n6r3x6y4mqgaksirwep7tszox5zlw3ulhy3in2jx@gh56jssnbai3>
References: <87jzk3qngi.fsf@hands.com>
 <handler.s.C.17152516831244576.transcript@bugs.debian.org>
 <sftag21AP5w8084Cro_9g-xWWPvsCuHmbxyU1r0_5V--fY8NhYuH9VxQsAXMgsJp3ZMV78f6jwKf4x-Csn87_g==@protonmail.internalid>
 <20240509144020.GH360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509144020.GH360919@frogsfrogsfrogs>

On Thu, May 09, 2024 at 07:40:20AM GMT, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> > Processing commands for control@bugs.debian.org:
> >
> > > tags 1070795 + d-i
> > Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs
> 
> Yeah, someone needs to apply the patches in
> 
> https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/
> 
> and
> 
> https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/
> 
> which were not picked up for 6.7.  Unless the upstream maintainer
> (Carlos) goes ahead with a 6.7.1?

I was planning to release 6.8 this week, do you think we still need a 6.7.1?

Carlos

> 
> --D
> 
> > Added tag(s) d-i.
> > > thanks
> > Stopping processing here.
> >
> > Please contact me if you need assistance.
> > --
> > 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> > Debian Bug Tracking System
> > Contact owner@bugs.debian.org with problems
> >
