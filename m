Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC03B8D60
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765347658; cv=none; b=gDUtCZowpjc+escWz2nNFW22QRxrrExiq23fGdUMkQ1E+YPt6fHoGrpmiKh31WCWE6QURekYHJkWYuSSY1o0Yz22Zp0vUiANULSJPat33IxMn/vftOqmhuZZ2gVpxM2MJLKF1EOrWyfZlGOa4eo5661FMqSmId1Hy2ooEKgraZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765347658; c=relaxed/simple;
	bh=m7DtMyfyZ+30mPdsStPUnoDlcOFxTdkoszM1sTUdoz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3QM2zRGuvmwryoipxwy5rIrnAyqWHrAQqrLs/XpOxU+9C49B35Oy3SeThCsU+3Az6TnCqvYLFbvTcUFUX/gFXCLY1707ID9ntyCXWWkgwyD0Y0JrFIAmPFJiBwozoWqa/i604oMxP3PVUcnoulEKaUPelU7VzbT7Qbf6UXGhHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPYZ0WwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPYZ0WwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09693C4CEF1;
	Wed, 10 Dec 2025 06:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765347658;
	bh=m7DtMyfyZ+30mPdsStPUnoDlcOFxTdkoszM1sTUdoz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mPYZ0WwD0KoU+bJ+ISVIoW/7AbvSKZcZPTVmOIrsWcxBWjW08PoEYMjvUCz/5Wl4p
	 RTtWYyb4yuRJNTfR4jTNn+W92dB7G1KKwRurhg6rRnAZoe0y7tP9TEDqsjptltdiiT
	 IpVpJBR4tL3lW3sa58JFz1eQSgnFXmYqHYADF3jkVraOvrj6cRYmdTWnaCSmv+IDAj
	 rMLeHuHKrem7Xy1W/1JwINZqNRlcsqjlympzwrMLNwXh1mMbftPsl3eBlduC2pw6cI
	 9I/ERVOFxgRN6sNDfvSZAsHyhD1+ZLgLhmdcZrboHmRp0BL+R381QvMu/tTst0H1qj
	 5tvr2j5p8VBSw==
Date: Tue, 9 Dec 2025 22:20:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org, sandeen@redhat.com, zlang@redhat.com,
	aalbersh@redhat.com
Subject: Re: [PATCH 1/1] mdrestore: fix restore_v2() superblock length check
Message-ID: <20251210062057.GA7753@frogsfrogsfrogs>
References: <20251209202700.1507550-1-preichl@redhat.com>
 <20251209202700.1507550-2-preichl@redhat.com>
 <20251209205017.GX89472@frogsfrogsfrogs>
 <aTkFC2EWf5UX5y9w@infradead.org>
 <aTkMgBUQcp-AmkaC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTkMgBUQcp-AmkaC@infradead.org>

On Tue, Dec 09, 2025 at 10:00:32PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 09:28:43PM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 09, 2025 at 12:50:17PM -0800, Darrick J. Wong wrote:
> > > > -	if (xme.xme_addr != 0 || xme.xme_len == 1 ||
> > > > +	if (xme.xme_addr != 0 || cpu_to_be32(xme.xme_len) != 1 ||
> > > 
> > > xme.xme_len is the ondisk value, so that should be be32_to_cpu().
> > > 
> > > Otherwise the patch looks ok.
> > 
> > We really need to bring back regular sparse runs on the userspace
> > code.  Let's see if I can get it back working..
> 
> I just gave it a try, and make CC=cgcc still works in theory.
> But between the urcu headers making it throw up, issues in the
> Linux UAPI headers and our own redefinition of the __be32/__be16
> types it generates so much noise that it stops reporting before
> any real issues including this one.  Sigh.  I'll see if there
> is a way to clean some of this up and get useful results.

I usually just grep -v out the macro crap and squint real hard to find
the real issues.  Oftentimes Dan Carpenter would help out, but I hear
that his work on that is coming to an end.

--D
