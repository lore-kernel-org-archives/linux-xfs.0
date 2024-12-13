Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D2779F5
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067336; cv=none; b=JaKvxCvxfUQEXZaiYl8nMVaO2IlMYUk4CmVpglIqq4UY2rjH9vTO3nMQcvod7ISuCTTi7XYL3bpae6nw5Iov1xr78ShTp/lVTzJHIo7zYsODjgH59wInuNqvye/A9CiJH2UJl/oGy34R+AWAmu0DoO3ihqn9DeaEXw67fiiXZIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067336; c=relaxed/simple;
	bh=30VWFcGNc+0MaZlUx2o+gVJe4yZApkxx3uhnZ7NcS74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuFfRjJ9eAmnfAXTaXaci3y0r4vgJex+2Q8qkTdiBvzsNdQiSqeyMEeTD0nJBFVNJxu1oN6fSZ2KaAfkcW6b/vplvXfRfFJpJO6Cfym6vp+ltV37OkiKrw5KKGgZvNrRT0VhtP3lzu4SJXqGcUT9Zsy9spweqQQqFEBBzYq+4L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAA0868BEB; Fri, 13 Dec 2024 06:22:10 +0100 (CET)
Date: Fri, 13 Dec 2024 06:22:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/43] xfs: define the zoned on-disk format
Message-ID: <20241213052210.GK5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-16-hch@lst.de> <20241212220220.GA6653@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212220220.GA6653@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 02:02:20PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:40AM +0100, Christoph Hellwig wrote:
> > Zone file systems reuse the basic RT group enabled XFS file system
> > structure to support a mode where each RT group is always written from
> > start to end and then reset for reuse (after moving out any remaining
> > data).  There are few minor but important changes, which are indicated
> > by a new incompat flag:
> > 
> > 1) there are no bitmap and summary inodes, and thus the sb_rbmblocks
> >    superblock field must be cleared to zero
> 
> zoned rt requires rt rmap and reflink, and hence metadir.  There is no
> such field as sb_rbmblocks anymore.

I doesn't actually require reflink - in fact it currently is incompatible
with reflink due to GC not understanding refcounts (it does depend on
your reflink code as it's reusing a few bits from that just to make it
confusing).

And sb_rbmblocks is actually still set for metadir file systems.

> > 4) an overlay of the cowextsizse field for the rtrmap inode so that we
> 
>                        cowextsize
> 
> >    can persistently track the total amount of bytes currently used in
> 
> Isn't this the total number of *fsblocks* currently used?

or rtblocks? :)  But yes, it's not byte granularity obviously, no idea
why I wrote that.

> Heh, I guess I should go down to my lab and plug in this smr disk and
> see how many zones it reports...

It will be capacity in bytes / 256MB unless you found a really, really
weird beast.

> > -	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> > -			mode, flags, flags2);
> > -	if (fa)
> > -		return fa;
> > +	if (!xfs_has_zoned(mp) ||
> > +	    dip->di_metatype != cpu_to_be16(XFS_METAFILE_RTRMAP)) {
> > +		/* COW extent size hint validation */
> > +		fa = xfs_inode_validate_cowextsize(mp,
> > +				be32_to_cpu(dip->di_cowextsize),
> > +				mode, flags, flags2);
> 
> I think there's *some* validation you could do, such as checking that
> i_cowextsize <= the number of blocks in the rtgroup.

So we do a fair amount of validation in xfs_zone_validate based on the
hardware zone state.  I tried to add more here but it failed because
we getting at the rtgroups wasn't easily possible.  But yes, I think
a simple rgsize check should be possible at least.

> I almost wonder if you should add that kind of logic to
> xfs_inode_validate_cowextsize but that might be one incoherence too
> many.  OTOH it would probably reduce the number of changes in the fsck
> code.

I'll take a look, but having a cowextsize helper that validated a field
overlay with an entirely different meaning sounds a bit confusing.

