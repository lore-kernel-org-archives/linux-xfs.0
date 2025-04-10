Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7021A5B9B
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303442; cv=none; b=DiiDp2YEvIeNiCQMWRfVTgI8hhKjlqDkbgoRfm/26BLdtJWcOM2Dcz+CXao14LBehNsNHu4sRdpyA47Pyh8r0ePxGVc4NSi7kVtcuAjdgZVJkpymeH0yLYGOqxmKn5lCvkdvu6gd1kXYnhnScCXvCusQOqeXEsyzlPKTdEZO5EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303442; c=relaxed/simple;
	bh=8D6WzLY7bachjhV/7kqf9HLe0SlTnIop4gCd8ymAHpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tnf+jpXNpeP+glYlryDuPgp1zCzzYzl6NnqmgpkoTqrOHhppsIM/RlzfDNwuvH8rQVy03f0yuDiUouFtuQKMD07y1g2KVLwvleMqT6jBIn1pOu1SgYLoOfohMHTQ+mD/cxQk6htH8c2EEBU8P6hTnNKIe27aVgI41AJ2z4A54oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V02ZplN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V02ZplN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6688CC4CEE8;
	Thu, 10 Apr 2025 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744303440;
	bh=8D6WzLY7bachjhV/7kqf9HLe0SlTnIop4gCd8ymAHpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V02ZplN7PMnhzRlnTOjqhOesAZVJsXWdpnM3drT2gFu7Pc2trZj1LGMlNUG5Tmavq
	 V08WVU3DGKcBryfnFHJbUskRNEHDGepsDl833yigcBXNu3omgXbAhGk62wgQfts3My
	 A9rylWGcQ+RAxfFc9XbbywDEEtIwknmIE62mdEqc3xE1UJhQPHWAf+6U4zrFqdZdFd
	 BO7qtgxO+X5rcFH3SJ6XMDG+8SU2TDa+Pqw3hIWtYCUO+DfIAlOK2olT5DEj+EJfBl
	 BLWDRk41sbXzneY1PxsFzQjP32SB++zmsmkI77fZS5slrCTA7MO4UtnT/yafUADpTH
	 IfZmVebS9sLow==
Date: Thu, 10 Apr 2025 09:43:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs_repair: validate rt groups vs reported
 hardware zones
Message-ID: <20250410164359.GA6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-30-hch@lst.de>
 <20250409184112.GE6283@frogsfrogsfrogs>
 <20250410063457.GD31075@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410063457.GD31075@lst.de>

On Thu, Apr 10, 2025 at 08:34:57AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 11:41:12AM -0700, Darrick J. Wong wrote:
> > > +#define ZONES_PER_IOCTL			16384
> > > +
> > > +static void
> > > +report_zones_cb(
> > > +	struct xfs_mount	*mp,
> > > +	struct blk_zone		*zone)
> > > +{
> > > +	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
> > 
> >         ^^^^^^^^^^^^^ nit: xfs_rtblock_t ?
> 
> Updated.
> 
> > Nit: inconsistent styles in declaration indentation
> 
> Fixed.
> 
> > > +	device_size /= 512; /* BLKGETSIZE64 reports a byte value */
> > 
> > device_size = BTOBB(device_size); ?
> 
> Sure.
> 
> > > +
> > > +			switch (zones[i].type) {
> > > +			case BLK_ZONE_TYPE_CONVENTIONAL:
> > > +			case BLK_ZONE_TYPE_SEQWRITE_REQ:
> > > +				break;
> > > +			case BLK_ZONE_TYPE_SEQWRITE_PREF:
> > > +				do_error(
> > > +_("Found sequential write preferred zone\n"));
> > 
> > I wonder, can "sequential preferred" zones be treated as if they are
> > conventional zones?  Albeit really slow ones?
> 
> Yes, they could.  However in the kernel we've decided that dealing
> them is too painful for the few prototypes build that way and reject
> them in the block layer.  So we won't ever seem them here except with
> a rather old kernel.

Ah, I hadn't realized those aren't even supported now, but yeah:

	case BLK_ZONE_TYPE_SEQWRITE_PREF:
	default:
		pr_warn("%s: Invalid zone type 0x%x at sectors %llu\n",
			disk->disk_name, (int)zone->type, zone->start);

I guess that means drive-managed SMR disks don't export zone info at
all?

--D
