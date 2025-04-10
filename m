Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F301F0E26
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744265379; cv=none; b=NaEaDVzd1D26IPmBGI5XJxQKagK3CAbP/9hazO3suxdGXTRo5idx3K5NQJFTqpvvOlZzDzTvwagVSqi1kPLklcc3iWo+2ndr11X9nHaSxeTg3Ch5wYH0uj5b2DAysaTSSgLg6j+ywTPATiPnqy1LSA2cR2pEFDol7lQ5lUq2pNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744265379; c=relaxed/simple;
	bh=MdkvIGAHAtiMoRiWezuiAugfp4h6VIoVFtEluiQDGhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E90OO7jYzmjO0SWl0ENhbHqqKHqNhmsuGiq9gDaYXd/VHAtiAnsZnVGnRDTpCzrdfzx381X0NPyvkN3m3aaTWmlFfdSoAL63YIwO3XBtV5vfmtzddbSKcGUVEWf0KkIGeVphJYsAYBQSM/hhd24Q9osdEWSXnd/ARHXj6VUar6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A2AA968BFE; Thu, 10 Apr 2025 08:09:32 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:09:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/45] FIXUP: xfs: allow internal RT devices for zoned
 mode
Message-ID: <20250410060931.GC30571@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-14-hch@lst.de> <20250409155548.GV6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409155548.GV6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 08:55:48AM -0700, Darrick J. Wong wrote:
> Hum.  This change means that if you call xfs_db -c info without
> supplying a realtime device, the info command output will claim an
> internal rt device:
> 
> $ truncate -s 3g /tmp/a
> $ truncate -s 3g /tmp/b
> $ mkfs.xfs -f /tmp/a -r rtdev=/tmp/b
> $ xfs_db -c info /tmp/a

I guess this wants a regression test while we're at it.

> static inline const char *
> rtdev_name(
> 	const struct xfs_fsop_geo	*geo,
> 	const char			*rtname)
> {
> 	if (!geo->rtblocks)
> 		return _("none");
> 	if (geo->rtstart)
> 		return _("internal");
> 	if (!rtname)
> 		return _("external");
> 	return rtname;
> }
> 
> instead?

That should work.  Although the rtstart handling needs to be later
as it doesn't exist yet here.  I've added the helper for now and
will see how it works out while I finish the rebase.
