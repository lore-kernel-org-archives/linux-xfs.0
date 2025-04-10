Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A64FEAD0
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266477; cv=none; b=HcpI5o6aJlli0OHQjp/XcmD0k9X6s76Kmfnr+r3HQ+lv1kSCJsB7LGRsmPtETsoeaCTC80EU+6H1ohgQ2a6JNgueK8sZqfJeU3SkvyPJpMOewVOxHxUKiT6dLPx0soHXWjZaiGyV/sWAXrNVDF4vweiLHk1Sk5HpnT5oxZYCtRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266477; c=relaxed/simple;
	bh=nu04PPQFv8HZNeGzL8CamXasV3xhi7RbWpBXu6kqyzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ASTP8+MaYKCdm23Ij9tWP9m2ax5MfD5LpZ8MWVeWCQGXN3z6a8M5VGemoEmBO4jrvrWB3b3NmzZJ232thCdYNSwHYRxWsk19S9WipXaIMtHM9iXdky4pV95nQo7TQ3Gyv2SOU5UnpDe/yjCkw/G7Xca6PFsXGrwRhZKO7L2I/CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70A1F68BFE; Thu, 10 Apr 2025 08:27:50 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:27:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs_repair: support repairing zoned file systems
Message-ID: <20250410062749.GB31075@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-28-hch@lst.de> <20250409161012.GC6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409161012.GC6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 09:10:12AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:30AM +0200, Christoph Hellwig wrote:
> > Note really much to do here.  Mostly ignore the validation and
> > regeneration of the bitmap and summary inodes.  Eventually this
> > could grow a bit of validation of the hardware zone state.
> 
> What do we actually do about the hardware zone state?  If the write
> pointer is lower than wherever the rtrmapbt thinks it is, then we're
> screwed, right?

Yes.  See offlist discussion with Hans.

> Does it matter if the hw write pointer is higher than where the rtrmapbt
> thinks it is?  In that case, a new write will be beyond the last write
> that the filesystem knows about, but the device will tell us the disk
> address so it's all good aside from the freertx counters being wrong.  I
> think?

Yes.  That's actually a totally expected case for an unclean shutdown
with data I/O in flight.  freertx is recalculate at each mount, and
the space not recorded in the rmapbt is simply marked as reclaimable
through garbage collection.

