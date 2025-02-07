Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6A15E5B8
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904093; cv=none; b=FUy0WOku5sMgJNysPOJEjIqPc+Ztgs9hVPuKo3sCpHgXk1CSwc2gdAxq4l7m7z3eP+FRttouJSpsSnJeoWAe8mgSyMKWMHHL9vwPnlFiyslH520L3kLbw11BLzd9vbrucJzECx5BaBvAjbP/wOCu8Gw2NUn+o3NJ5P2llxNU8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904093; c=relaxed/simple;
	bh=FJKTZ2HVaCC8mynKI7KC8sq1Rz7IL5hl9A5v+yH0S7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UUYFTGhVXY0Q+uHwIjsSD4/mTIpfAUU4AcHhouGv9Z0chpIEtj/fc5jMNlzFSVjVjGsJkXTlDPfdG9whl0ZYsdqNbwa912DAWP0IL7ybol9fyp0S1abfRnYkzhnEIFzm2IN+U/i7JRhczPQ2LPloq0DgwtjkJYrFklk+luQMTM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9D7168C4E; Fri,  7 Feb 2025 05:54:46 +0100 (CET)
Date: Fri, 7 Feb 2025 05:54:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/43] xfs: disable reflink for zoned file systems
Message-ID: <20250207045446.GA6694@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-35-hch@lst.de> <20250207043123.GM21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207043123.GM21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 06, 2025 at 08:31:23PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 06, 2025 at 07:44:50AM +0100, Christoph Hellwig wrote:
> > While the zoned on-disk format supports reflinks, the GC code currently
> > always unshares reflinks when moving blocks to new zones, thus making the
> > feature unusuable.  Disable reflinks until the GC code is refcount aware.
> 
> It might be worth mentioning that I've been working on a refcount-aware
> free space defragmenter that could be used for this kind of thing,
> albeit with the usual problems of userspace can't really stop the
> kernel from filling its brains and starving our defragc process.
> 
> It would be interesting to load up that adversarial thread timing
> sched_ext thing that I hear was talked about at fosdem.

Not sure waht sched_ext thing and how it's relevant.

It's just that refcount awareness is a bit of work and not really
required for the initial use cases.  It might also have fun implications
for the metabtree reservations, but otherwise I don't think it's rocket
science.  Even more so with a pre-existing implementation to steal ideas
from.

Talking about stealing ideas - the in-kernel GC flow should mostly work
for a regular file system as well.  I don't think actually sharing much
code is going to be useful because the block reservations work so
differently, but I suspect doing it in-kernel using the same "check if
the mapping change at I/O completion time" scheme use in GC would work
very well for a freespace defragmenter on a regular file system.  And
doing it in the kernel will be more efficient at operation time and
probably also be a lot less code than doing it with a whole bunch of
userspace to kernel roundtrips.

