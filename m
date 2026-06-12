Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3311C3AC0C6;
	Fri, 12 Jun 2026 05:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781242120; cv=none; b=uQz7uZ7gtyudXlPZLzxR/5Q+8LHs0lL2V8P7rYMDCS3UBl4ls1vCKimhvJAqdvO8Dx6IpegM3NSzGJgO5bay3KieSJ/H7ZRTauDHN5wDf5vsVHmMRiR39yDPLaIjA+R9a+pq4kfSLH+RuzRt/NXn4VK01YLn8nPunIbGqbNYz50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781242120; c=relaxed/simple;
	bh=JspGtTuIqHmF9JAX3VdnalFZSZ3Mib4Q1S3WyAzcKMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tF5JxYjN590OQbHKrGdY04l+DfSVB/EVsq7nGqQ4Cgzkpv3027V1RTH+e4kY3exOuGU1uwi2X/d7KNF3EV8gzfM9lpvYdETqFEcbti2/mKujyu54j+I9FV8Ra4Zd3OGbmmTsBQg9x9gQiOaDB8s+Ul1pdDKJd11UE1uE9aA+2VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19C5468C4E; Fri, 12 Jun 2026 07:28:32 +0200 (CEST)
Date: Fri, 12 Jun 2026 07:28:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	brauner@kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <20260612052831.GA9010@lst.de>
References: <20260610145218.141369-1-cem@kernel.org> <20260611055744.GA18538@lst.de> <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc> <aiqwy5DfHI79KXuZ@kbusch-mbp> <20260611133833.GA14645@lst.de> <airX6BmMQ14Rvjcb@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <airX6BmMQ14Rvjcb@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 11, 2026 at 05:47:07PM +0200, Carlos Maiolino wrote:
> On Thu, Jun 11, 2026 at 03:38:33PM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 11, 2026 at 06:57:47AM -0600, Keith Busch wrote:
> > > It's entirely possible a device supports byte aligned addresses. The
> > > block layer just doesn't let a driver report that. So either it really
> > > was successful because you found a bug that skips the alignment checks,
> > > or your device silently corrupted your payload.
> 
> I tried this on different hardware, I find it hard to say all those
> devices were corrupting the payload.

I think in the other thread we agreed that we are currently missing
the alignment check for fast-path bios not hitting the splitting code,
so maybe that is something you see.  Additionally we're missing the
checks for purely bio based drivers not calling the splitting helper
at all, but I don't think that applies here.

> > > Anyway, my earlier suggestion should work. Ming thinks it may go to far,
> > > though, in not taking the optimization when it was possible. So here's
> > > an alternative suggestion that should get things working as expected:
> > 
> > The fix below looks like it is addressing a real bug.  I'm not sure if
> > Carlos is hitting it, but we were missing the alignment checks for
> > single-bvec fast path bios so far indeed.
> 
> You left context out so I'm assuming by the fix you meant Keith's patch.

Yes.

