Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC6F3191BB;
	Thu, 19 Feb 2026 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771508466; cv=none; b=mIapGbEPVI1NkIS7h/qkjLmUd4JM2ay5X7eB05EhMygnSZzkzTW7IXJ8+1mdv+DClcv1gm6kBLZ+vvz65sr5fS4JXb33jtk+5005iIhIR4pC4R57yQUxiLXoMRSOPvyIt/1AzjPSrODt0dvMKt27U5RLtRsLzpIIf8Lj/GYeP+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771508466; c=relaxed/simple;
	bh=Wb9Q0hoQOXXMO297DJsBiXshfgGgR+MvEB0pfl3uBcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTD7nyUV4i6+6NHRkBxGTErhn6qUwscV0pNIGExYRccJBJL0wzXvlaVVPcAEuzz50+dOH/QhT55/+G6pdpHoYWSZwrhoRKpg+xhzC63z3MOTQ/DJzFuhVqSHKZ/N3pBABrNwvr9EnaMUirlqzGMgV/GBq59Pq6+qs60IlR6UebM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E6B568BFE; Thu, 19 Feb 2026 14:41:02 +0100 (CET)
Date: Thu, 19 Feb 2026 14:41:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <20260219134101.GA12139@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-29-aalbersh@kernel.org> <20260218064429.GC8768@lst.de> <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx> <20260219061122.GA4091@lst.de> <4cmnh4lgygm4fj3fixsgy3b7xp2ayo3jirvspoma6qxusdgluu@nyamffhaurej>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cmnh4lgygm4fj3fixsgy3b7xp2ayo3jirvspoma6qxusdgluu@nyamffhaurej>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 19, 2026 at 10:51:14AM +0100, Andrey Albershteyn wrote:
> > > fs block size < PAGE_SIZE when these tree holes are in one folio
> > > with descriptor. Iomap can not fill them without getting descriptor
> > > first.
> > 
> > Should we just simply not create tree holes for that case?  Anything
> > involving page cache validation is a pain, so if we have an easy
> > enough way to avoid it I'd rather do that.
> 
> I don't think we can. Any hole at the tree tail which gets into the
> same folio with descriptor need to be skipped. If we write out
> hashes instead of the holes for the 4k page then other holes at
> lower offsets of the tree still can have holes on bigger page
> system.

Ok.

> Adding a bit of space between tree tail and descriptor would
> probably work but that's also dependent on the page size.

Well, I guess then the only thing we can do is writes very detailed
comments explaining all this.
