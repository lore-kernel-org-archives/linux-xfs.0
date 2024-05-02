Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CDF19470
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 04:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714623322; cv=none; b=OXF4tCKv8VA7XOkNx3xkfgwr/loOi2lmnZak86ZL0kXz9Hb3ngJ2TjqMhx3892snJm2QBLrqsGIztj+bheHQ8v9RXMVyXao8KtA1MfExxH3K+wrwQCtqPcu0PGiHZw5Y1D2r9PZWFezjUnBhdF6Tsz3YwDGw9ChSumhU+UrDeXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714623322; c=relaxed/simple;
	bh=a7Js3Gg8hWy2+0Iewxg5lQUbYPdEYbBjcU44h7VSY9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsuGqlklW84wfQ03faEMYOQIXZ+Mk1bJ/pHmdSiFhIc9bMvL8VMKSy2mViYJ8rhy7msr9+0v2MCM3PM41wEfTYZX6IHIlaUU4fj3f/ZSdKCIsIgWMsGd+3wiuwDWqVRVH40q5SXUT0iQJjYazMCsfHvNXhb527jwSzMv/hKWEcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A84C227A87; Thu,  2 May 2024 06:15:17 +0200 (CEST)
Date: Thu, 2 May 2024 06:15:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs: factor out a xfs_dir2_sf_addname_common
 helper
Message-ID: <20240502041517.GC26601@lst.de>
References: <20240430124926.1775355-1-hch@lst.de> <20240430124926.1775355-13-hch@lst.de> <20240501213147.GA360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240501213147.GA360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 02:31:47PM -0700, Darrick J. Wong wrote:
> Hmm.  @objchange==true in the _hard() case means that we already
> converted the sf dir to ino8 format, right?  So that's why we don't need
> to increment i8count?

Yes.

It is a little weird to be honest and given the final state after the
series I wonder if i8count manipulation should just move outside the
helper.
