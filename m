Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485BD4C042A;
	Thu,  2 Jul 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783001037; cv=none; b=EID7aP2xklmQSflqU4nQIt6c3B/5P3f+DCIWTjztm3Yk6Ohoe/YxVqIeLp0uVbiCiFW4bINgctBzT+4FYpKThKXFf44YFX2kiL7GEasjQKVRgBdonq/AXdJWgSmqgF40VtdxWgKTSDjGEIS0iRVZptGDLSunQcfelveUVkdc/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783001037; c=relaxed/simple;
	bh=hXt1CeM/ShBle43ZJQf+gxS+Z4mfotr/AlFHiOAr3JY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXa+5HbLKv2t50gYGsB3kNjGxLFSM9L0G+dYzauBesmbbGAZ0RO23LcpZf/rtiToFy40yklJmSR9eccWkMAFYwP1C7skQBIsNK2BsDQNUNG+agQXOVjAFtAJ3ZeGz0LjMVfPiOzU3/aLBaXU+LJHr0RIZ6OINf+n3mYNhtP8M3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2313968BEB; Thu,  2 Jul 2026 16:03:53 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:03:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org, hch@lst.de,
	djwong@kernel.org, willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	"open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 10/18] block: convert iomap ops to ->iomap_next()
Message-ID: <20260702140352.GC21339@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-11-joannelkoong@gmail.com> <akRlehPHzy-F_105@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akRlehPHzy-F_105@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 30, 2026 at 06:55:22PM -0600, Keith Busch wrote:
> On Tue, Jun 30, 2026 at 05:09:25PM -0700, Joanne Koong wrote:
> >  static const struct iomap_ops blkdev_iomap_ops = {
> > -	.iomap_begin		= blkdev_iomap_begin,
> > +	.iomap_next		= blkdev_iomap_next,
> >  };
> 
> I think it's generally safe to use the same mailing list for the entire
> series. There's no context here on what "iomap_next" is because I'm
> subscribed only to linux-block. I found the rest here:

Yeah, without that some people always get screwed over reviewing the
series.

> FWIW, everything looks good to me.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

Same here:

Reviewed-by: Christoph Hellwig <hch@lst.de>
