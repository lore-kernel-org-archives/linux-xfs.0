Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E51433A6
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 06:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832637; cv=none; b=JmCq5n//aibc9CidD8bowDMNX0vg9CnRuRhuM5dfx8um6ry2FjB07UEyvhHVQ6kIJx6hGmDHXVGghSg4wpZMm/riW9lg+dLRpCstCpGEoII0myF+0eTKM+cIPRiiIM2yPDFXvsC/1bagKYxuUZc2RqQTqW+St2SFC0xhMHCpT/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832637; c=relaxed/simple;
	bh=wGEmAtVYmig6lMfbMu2xPsYbg4IZeeapHFjpmIuEWLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8uhABbG0JMEzQqqv5uhiU5pDsbmKUpfJkIVtsLJclmJPoUu3q7W3BnIA3C4eNKSd6TtPbELuN8LMUYSh7vI01RLcZOS+nDufFUTYRz2nEtHgrbDopSubR0izXaO0gL6HuvLgw2+MaRkBGPMbTbPB0M2TIKfqtaBMfnyMHpEsEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 25712227A87; Wed, 25 Jun 2025 08:23:51 +0200 (CEST)
Date: Wed, 25 Jun 2025 08:23:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250625062350.GA9673@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-8-hch@lst.de> <aFH_bpJrowjwTeV_@dread.disaster.area> <20250618051509.GF28260@lst.de> <aFN5H-uDW5vxQmZJ@dread.disaster.area> <20250624141117.GF24420@lst.de> <aFs68CkT5zQZBeSX@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFs68CkT5zQZBeSX@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 25, 2025 at 09:55:28AM +1000, Dave Chinner wrote:
> Again: I am not talking about the bt_meta_sectorsize removal being a
> problem!

Why do you comment on the patch doing that then?

> I will repeat it once more: this patchset removes the check that
> guarantees the the underlying block device has a sector size that is
> valid for the sector size the filesystem devices are configured to
> use. That is not acceptible - a 512 byte sector filesystem device
> must not be able to mount on a hard 4kB sector device because the
> moment we do a 512 byte aligned IO to the log device, the bdev will
> give an EIO error and we'll shut down the filesystem.

Yes, and I've already agree to not drop that check after you initially
pointed that out.

So I'm really confused on what you are trying to comment on for this
patch.

