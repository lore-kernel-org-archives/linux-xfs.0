Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF44ADDD2
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243135; cv=none; b=tiYdXpilqus4sivB7YHlUVgkP7ZKka6LLyaRsnOFulN1yw4XMwg7Mw90vv3DjSSYwXHXyXyv7MnNIxWtIN506SbIbEZEsKdJqcnE8a2hMc/UlOYN/JFDj0QY5y+Pu8uvT2UufnwfOpUa/fOp2deihfJMpsWq480Dksm4vbu6oVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243135; c=relaxed/simple;
	bh=zkg0pByh1hy59LFAmJxMoU1Ouhi2kKqtw/Qm0XI1TfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdYiA/pdZaF+U3pLZ09s9FprHqRk4NTGMt1jY8mUZduPpe6ylX6CBEjNaShtn9eFGteQf+wB9F6OkRlYV+jsA4IMHyIXKHxR7zC6ulYeUs2pqP2ur+ijK2/nBr0jmc+s0vTfDXkpfYeXYlU+gwIX3LzZLz8HA6OOR3//PqIGUP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B632868C7B; Sun, 15 Dec 2024 07:12:09 +0100 (CET)
Date: Sun, 15 Dec 2024 07:12:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/43] xfs: implement buffered writes to zoned RT
 devices
Message-ID: <20241215061209.GA10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-28-hch@lst.de> <20241213223757.GQ6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213223757.GQ6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:37:57PM -0800, Darrick J. Wong wrote:
> > index d35ac4c19fb2..67392413216b 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1,7 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  /*
> >   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> > - * Copyright (c) 2016-2018 Christoph Hellwig.
> > + * Copyright (c) 2016-2023 Christoph Hellwig.
> 
> 2024, surely?
> 
> Or at this point, 2025

Nost of this actually was done (and pushed to a semi-public tree) in
2023.  But I guess I touched it enough in 2024 to cover that.

> > +	wpc->iomap.type = IOMAP_MAPPED;
> > +	wpc->iomap.flags = IOMAP_F_DIRTY;
> > +	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
> > +	wpc->iomap.offset = offset;
> > +	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
> > +	wpc->iomap.flags = IOMAP_F_ZONE_APPEND;
> > +	wpc->iomap.addr = 0;
> 
> /me wonders if this should be set somewhere other than block 0 just in
> case we screw up?  That might just be paranoia since I think iomap puts
> the bio if it doesn't get to ->submit_bio.

I'll give it a spin.

> > +	struct xfs_inode	*ip = XFS_I(mapping->host);
> >  	struct xfs_writepage_ctx wpc = { };
> > +	int			error;
> >  
> > -	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> > +	xfs_iflags_clear(ip, XFS_ITRUNCATED);
> > +	if (xfs_is_zoned_inode(ip)) {
> > +		struct xfs_zoned_writepage_ctx xc = { };
> 
> I noticed that the zoned writepage ctx doesn't track data/cow fork
> sequence numbers.  Why is this not necessary?  Can we not race with
> someone else doing writeback?

Unlike "regular" XFS writeback, which tries to convert large extents from
preallocations (or just large ranges), zoned writeback works a single
folio at time, that there is a new mapping for each folio.  And these are
only dummy mappings anyway.  So all work happens on folios that are
locked or have the writeback bit set and are off limits to other
writeback threads, new buffered writers or invalidation.  I guess I
need to document this better.

> > +xfs_zoned_buffered_write_iomap_begin(
> > +	struct inode		*inode,
> > +	loff_t			offset,
> > +	loff_t			count,
> > +	unsigned		flags,
> > +	struct iomap		*iomap,
> > +	struct iomap		*srcmap)
> > +{
> > +	struct iomap_iter	*iter =
> > +		container_of(iomap, struct iomap_iter, iomap);
> 
> I still wonder if iomap should be passing a (const struct iomap_iter *)
> to the ->iomap_begin function instead of passing all these variables and
> then implementations have to container_of if they want iter->private
> too.

It should, and I plan to pass the iter when reworking this towards
the iter model.  Hopefully I can get to that relatively soon after
this project lands.

