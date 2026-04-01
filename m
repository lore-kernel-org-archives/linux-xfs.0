Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F73A390CA9;
	Wed,  1 Apr 2026 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052411; cv=none; b=tN/uvOzmKEd2o//ATyUELsMZjJJ5tTQdV0P+5KWo0mTuatAElGG7WKRoYDXWpjQHbHsDR2JOhqBIXTC2GtBUhiDy0xAxtsnkDrnA7Fr+0aVQDUldbdSebT4F3o3/3pT7GQN1OVTuIFcRnGcVjdeZvwgYhVjTYHn4zN5iQxA6GNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052411; c=relaxed/simple;
	bh=7LIxVcJeX1k1JRkk1jRbY6b+DjoSguDf7BOfMp2/O/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVXS/o8tP8t9Y5pUK6UzPiwf6ev9kBeXIwSFi2lZX5CPMwaqkYRQ4Oqw0GDFOSCTr3SBHCyU39Zoxxu+YdvHcuibiPq4YrgzV5WQEPCC3g+z5Qm/384UXraQO85j9OjrpV61HEXm+KoMnyIj/k7jhD2WPu0fYR48FdIiKv+vRAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8253568C4E; Wed,  1 Apr 2026 16:06:46 +0200 (CEST)
Date: Wed, 1 Apr 2026 16:06:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260401140646.GA21703@lst.de>
References: <20260331152341.4047725-1-hch@lst.de> <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt> <20260401061828.GA24293@lst.de> <20260401075952.ifuz3kqfq3g7c4gf@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401075952.ifuz3kqfq3g7c4gf@doltdoltdolt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 01, 2026 at 03:59:52PM +0800, Zorro Lang wrote:
> > > > +_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> > > > +	> "$seqres.full" 2>&1
> > > 
> > > I usually tack on "|| _fail 'mkfs failed'" after _scratch_mount if it's
> > > using extra options. That way, we'll know for sure if the mkfs actually
> > > failed.
> > 
> > Yes, that is useful here, especially if we want to support older kernels
> > before the zoned device support or !CONFIG_XFS_RT kernels.
> 
> Oh, if so, we might need _require_realtime. But that's still not enough to
> check mkfs.xfs and mount.xfs on old system (then notrun), we might need
> more _require_* helpers for this test. What do you think?


I think _notrun if mkfs or the initial mount fails might be easier and
better here.

