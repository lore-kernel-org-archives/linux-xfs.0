Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1C71372
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266903; cv=none; b=j1zY/gKeckyPb9zBSMT5ss9RfDoDcZAyvF+HPdGlwmefkcCtvB0in+nL3qHOJsG5AFmKz1timAnDGe6C5OwxNunDnfp5R7IoRMvv3TjdXcnBJ3QwnOJVyo7Z6wsZ9AYUzg8gkDar0sxSgNzQ1QJqAi3sNaKMZ0gpnrdyPiJwiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266903; c=relaxed/simple;
	bh=EFH+v/oDxPR2rQwroJvQIYPjZEP+R9qWGsPH+4r67W8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rauARcT5/3AWRzsmgp06JnZ8QZQzsTrSTNegXrcGL6Sv1MRf3mWEYSyllfg9u962vp+jKfueTYFa02ri3aAygBqkTV04Srz4xEON3mlPZJ4jN6MPMWH42HbIzOiA+4Qk3scY6pa1avGJdW35/RZxx02Z5bl0mrvulDB8kEzltxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0E8D568BFE; Thu, 10 Apr 2025 08:34:58 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:34:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs_repair: validate rt groups vs reported
 hardware zones
Message-ID: <20250410063457.GD31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-30-hch@lst.de> <20250409184112.GE6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409184112.GE6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 11:41:12AM -0700, Darrick J. Wong wrote:
> > +#define ZONES_PER_IOCTL			16384
> > +
> > +static void
> > +report_zones_cb(
> > +	struct xfs_mount	*mp,
> > +	struct blk_zone		*zone)
> > +{
> > +	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
> 
>         ^^^^^^^^^^^^^ nit: xfs_rtblock_t ?

Updated.

> Nit: inconsistent styles in declaration indentation

Fixed.

> > +	device_size /= 512; /* BLKGETSIZE64 reports a byte value */
> 
> device_size = BTOBB(device_size); ?

Sure.

> > +
> > +			switch (zones[i].type) {
> > +			case BLK_ZONE_TYPE_CONVENTIONAL:
> > +			case BLK_ZONE_TYPE_SEQWRITE_REQ:
> > +				break;
> > +			case BLK_ZONE_TYPE_SEQWRITE_PREF:
> > +				do_error(
> > +_("Found sequential write preferred zone\n"));
> 
> I wonder, can "sequential preferred" zones be treated as if they are
> conventional zones?  Albeit really slow ones?

Yes, they could.  However in the kernel we've decided that dealing
them is too painful for the few prototypes build that way and reject
them in the block layer.  So we won't ever seem them here except with
a rather old kernel.

