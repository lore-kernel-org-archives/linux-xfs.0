Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95422D8771;
	Tue, 18 Nov 2025 05:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763445440; cv=none; b=KlE9BB0aSi7LesIIfKkFxgsDazJFfbxG6cYOAjLwO7/RIH5G7Q0EHeIEVf9lQ3NV/kmstzQzSXcQn9/6dFH0S9nrY0W9G+xt9sTTn+Z9LhDcVRAELoyFAhBZvpEMxy8PgEhqL1rUlYMCk2ibAnXF/zZcxX4SSQg5ayFb3aR5+xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763445440; c=relaxed/simple;
	bh=6yIcxf1UVTGglmW3eGQv5LbpJGmJ+zqj1VQuv+aPavA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L90SUoY2mpzfUzFrlPz/JvgyTYbvFKCzLiptN7cxRLSOmdDC04/JtMLb7+QJhMgFU9wY4pujjfygTZnbO1NkPdtAJ4NgI4K5escJbE64TERvMwmSzoQ+Asqh+Rm2WN5+wFir9LPTQbzUPZkzy1nXw+25cCswMFcja6S0cezQ2O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E205268AFE; Tue, 18 Nov 2025 06:57:11 +0100 (CET)
Date: Tue, 18 Nov 2025 06:57:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: make xfs sparse-warning free
Message-ID: <20251118055710.GA22733@lst.de>
References: <20251114055249.1517520-1-hch@lst.de> <CAHk-=wg=B_E6xyFWF0s2mGrRP==7Oo9WAt645x6n+Fb2FAWNjw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg=B_E6xyFWF0s2mGrRP==7Oo9WAt645x6n+Fb2FAWNjw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 09:56:51AM -0800, Linus Torvalds wrote:
> I know you looked at that clang context thing earlier, and assumed
> that that is what triggered this work in the first place?

In this case not directly, although patch 2 was originally done for
that.  Patch 1 is newer than those experiments, but only because we
just started using lockref in this merge window, and it should apply
for that as well.

> > Patch 3 duplicates some XFS code to work around the lock context tracking,
> > but I think it is pretty silly.
> 
> makes me go "if you have to make the code worse to make sparse happy,
> maybe just look at the clang context tracking instead?"

Well, that's why I said I didn't like it it and included it more as
an example for the sparse developers to see what goes wrong.

> Because I *assume* that the more complete clang context tracking
> series doesn't need that?

I assume the same, but the quota changes the cause this are new, and I
haven't combined them yet with the context tracking experiments I did a
while ago.

