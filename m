Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC9C127;
	Wed, 10 Apr 2024 04:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712722449; cv=none; b=eOfxXoTA8sKd1hlnMWZ+6oaMhDWwkvwBuSLEa4AUIPNwQ+XDT/LExwsh2K+cfaKJqK355c8VgmN2IKsjIXIXnf92ngHesfwCJvIiJnIQqDKj3oh0+DgsOu3EIEHOcy47QyyoDJSs1cKIDV6qG+nd2A2kfTb/ReqcgWyy99wusfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712722449; c=relaxed/simple;
	bh=QHJK+bqcLSoZlrcQcS5OTsEbO9qapYno3pL9GEBB1DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCJgzraGnJ5mEJBirb+OjtBxVyifcKt46i9ARAYNU0ihyiosmms95h1XEnA+yR022MtY+WZT+b+Em2lFw3fGX1i/WORM8re31R93j/yHdj5U1DMxnSM32cqvFB1ghrc2DrqbMOlPzLWNm2GSF5uG0Op0Ku5dUxGgDju/THxBJ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9599068B05; Wed, 10 Apr 2024 06:14:03 +0200 (CEST)
Date: Wed, 10 Apr 2024 06:14:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't run tests that require v4 file systems
 when not supported
Message-ID: <20240410041402.GB2208@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408133243.694134-7-hch@lst.de> <20240409155612.GF634366@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409155612.GF634366@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 09, 2024 at 08:56:12AM -0700, Darrick J. Wong wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  common/xfs    | 10 ++++++++++
> >  tests/xfs/002 |  1 +
> 
> Looks fine to me.
> 
> >  tests/xfs/045 |  1 +
> 
> xfs_db can change uuids on v5 filesystems now, so we don't nee the
> -mcrc=0 in this test.

Ok, I'll look into that.

> Looks fine to me.
> 
> >  tests/xfs/148 |  2 ++
> 
> I wonder if we could rewrite this test to use either the xfs_db write -d
> command on dirents or attrs directly; or the link/attrset commands,
> since AFAICT the dir/attr code doesn't itself run namecheck when
> creating entries/attrs.

Can I leave that to you? :)

> >  tests/xfs/158 |  1 +
> >  tests/xfs/160 |  1 +
> 
> inobtcount and bigtime are new features, maybe these two tests should
> lose the clause that checks that we can't upgrade a V4 filesystem?

I'll take a look.

> >  tests/xfs/194 |  2 ++
> 
> Not sure why this one is fixated on $pagesize/8.  Was that a requirement
> to induce an error?  Or would this work just as well on a 1k fsblock fs?
> 
> (Eric?)

I can check if it could be made to work on $pagesize/4, but I'll
need to defer to Eric if that even makes sense.

> >  tests/xfs/513 |  1 +
> 
> I think we should split this into separate tests for V4/V5 options and
> only _require_xfs_nocrc the one with V4 options, because I wouldn't want
> to stop testing V5 codepaths simply because someone turned off V4
> support in the kernle.

Ok.

> >  tests/xfs/526 |  1 +
> 
> I'm at a loss on this one -- what it does is useful, but there aren't
> any V5 mkfs options that conflict as nicely as crc=0 does.

Yes, I tried to look for conflicting options, but I couldn't find
anything.  Maybe we'll grow some before the v4 support is retired
for real :)

