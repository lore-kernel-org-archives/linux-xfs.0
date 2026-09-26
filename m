Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A710936167F
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790402777; cv=none; b=eLzzRQsrmColHsO/4vg0WL2NdOHHftFBCPBUxfOlIez0SeBIZ/nTmJb4pwcKdXvGFa4h+B5yZHyPuM0weCpfZs1hMBG/oxTYhkbeB08kzfvQUfZLOjmRCCqXokNirhfVHGvNy3SeDJvdUK2tmjehx7jTx0UucGvIugthg+ao5kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790402777; c=relaxed/simple;
	bh=HztnUrvwOA8PTEwQ+vwgtieQH6mafkwqRV9WSxOCg3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BOTU/gOlsc0UdcSVH5SCi2W1+mNOeyA4LP0cUpouHmVvggzJyjVObfx146sTPUg01SkKqv527BYvmMkkzma5taD8aYgVoE4opmMeHi7FLeMlkGJG57xsN585x9g6gdMMVn//kB6ZUhbMsDGmKWBiezt5mYgYrHKd59wUtYJ46Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93D0C68C4E; Sat, 26 Sep 2026 08:06:11 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:06:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: small cleanups to help code sharing with xfsprogs
Message-ID: <20260926060611.GC20636@lst.de>
References: <20260925151841.3385994-1-hch@lst.de> <20260925225233.GZ2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925225233.GZ2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 03:52:33PM -0700, Darrick J. Wong wrote:
> On Fri, Sep 25, 2026 at 05:18:25PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series has a few trivial cleanups and code moves that help
> > sharing more code with xfsprogs.
> 
> Hrmm.  This is a somewhat different approach than what Chris Wedgwood
> did for his log port to userspace.

Well, that seems to have been an AI slop dump without any further
engagement from the LLM-herder, so I'm not sure it matters.

But it also is a bit of a different thing.  This series tries to reduce
the kernel/user libxfs differences, and reusing whatever we can from
the kernel helps with that.  What we do about the log becomes relevant
if/when we want to update that or share more.  My previously stated
opinion is that splitting a single kernel code base into two libraries,
which then generally are linked into the same programs again is not
helpful.  But someone comes up with a design that actually makes it
work painlessly I would not complain.  In the meantime I'd improve
the maintainability of libxfs without touching the logging code at all.
