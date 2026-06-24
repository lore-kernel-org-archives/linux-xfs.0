Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AD32D7393;
	Wed, 24 Jun 2026 13:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308996; cv=none; b=IC0t3xZ1OW1i99U4lRxgMrRa4iIhvU9NM1qrnlP1PWBvG4gBae98cI3qf5pzx2uMpBcXV2KC+FVtrOnm9NnnFDoQEr0D/D6RM3CSba4MfFTYwvg0siTjsCB8FX9BOKBdoUffdcdH44FkwNcEpfUrJRtaxJlu/Zi7nYHkAs3O7f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308996; c=relaxed/simple;
	bh=QpzgjY77zUH51UqQDs9YjDnOiWXUsGV1PCcqgRmw4xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fy6Bc4RBAY5woO0hWAJ36b0IhHsDk8WVAGNt1fX1u5Qa9Da5iKxTKCyfR/Q5Y8uW1aurm8jpqxCNuKkGeNx5qTepGH+GZ98uWmQ4h9+cxFM9AEk1X/X3yQCCLxAlHC/QgkO5yxoYVbgH7iHjbDTC3RUDkc2vBAonEI2dUFsF6X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DA98C68C4E; Wed, 24 Jun 2026 15:49:50 +0200 (CEST)
Date: Wed, 24 Jun 2026 15:49:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <20260624134950.GA6471@lst.de>
References: <20260623142109.1838702-1-hch@lst.de> <rbrncqfmzbnj5o2yvieqtpl3dkb4qzafsai3sarmbta4fsqc6f@yruai3zv5llu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rbrncqfmzbnj5o2yvieqtpl3dkb4qzafsai3sarmbta4fsqc6f@yruai3zv5llu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 02:26:35PM +0200, Jan Kara wrote:
> A cleaner but still relatively simple way how to fix your problem would be
> to do something similar like e.g. btrfs does. That is when you have a
> filesystem with multiple backing devices, you create a new BDI (using
> super_setup_bdi()) and set its parameters based on the combination of
> devices you have.
> 
> The only downside to this is that blk-wbt has a layering violation in it
> when it tries to guess whether there are task dirty-throttled for the
> device which stops working for when the filesystem uses this synthetic bdi.
> But I don't think that's too serious to worry about.

The big downside of that is that it breaks the userspace ABI - any
previous changes to BDI paramters, most importantly the read-ahead size,
would now only apply to the BDI for s_bdev which isn't actually used
by anything.

And yeah, the blk-wbt thing actually looks really broken and could use
fixing..

> >   1) support multiple BDIs per file system.
> > 
> > 	This would work pretty well for XFS, as data for a given file is
> > 	always entirely on one device, and the VFS writeback code is not
> > 	used for metadata.  But it probably doesn't work well for other
> > 	cases
> 
> Since looking up the bdi is abstracted through inode_to_bdi() (which
> currently goes through the superblock), this would be relatively easy to do
> but either the inode would have to store the bdi pointer or we'd have to
> have an operation to query it. Just at this point I'm not fully convinced
> the additional complexity / memory cost is worth it compared to what can be
> achieved with a synthetic bdi.

Same.

> >   2) stop propagating these values through the BDI
> > 
> > 	Have a way to query these parameters from the file system, either
> > 	through a method if we want to be fully dynamic, or through fields
> > 	instead of going through the BDI.  The downside would be that
> > 	sysfs modifications of the readahead size would not work after
> > 	the file system initially queried them.
> 
> Similarly as above. It makes sense but I'm not sure there are strong enough
> usecases to justify this.

It would at least be a lot less complete than option 1.  And get us out of
a bit more of all that bdi weirdness.
