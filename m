Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B842C2D4B4F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Jun 2025 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774283; cv=none; b=rY2liY0fCJWRxmWn7Ky40URUJGfAvZ4Ivdoyj0+QjZ0Tgd7k2zLt3rHLe9ALik344PfJ+CYfVsrlIHciKtKy5pMmkLHQmAGR0+12ux6V9kEq3m615sUpXyXli3KskSHh68vuF5iiDvKhnTQaX6c2s3GtM4/lwvgCAIOOHY2Mipk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774283; c=relaxed/simple;
	bh=7VnzcA4ok3t2zl/EduA2rmtKbdGUaUmmMyj+eeRP4IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soWmp7yPL6sSu+c9hd82SBMQRR5Be3uJ+cRXYVfqPjyFOlU4LKE+UXzC8nn2GR54pKJZSdO9wr5a1mWI9Dp0K7pxwyU85PSXxdg58r4fXIDQ8suwK6pDQvn4uzvup6TTyEPKFVR6dEUUIrZAVDpd3z+7ZkKDn2eTXZdy++EZaGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6F05168AFE; Tue, 24 Jun 2025 16:11:17 +0200 (CEST)
Date: Tue, 24 Jun 2025 16:11:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250624141117.GF24420@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-8-hch@lst.de> <aFH_bpJrowjwTeV_@dread.disaster.area> <20250618051509.GF28260@lst.de> <aFN5H-uDW5vxQmZJ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFN5H-uDW5vxQmZJ@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 19, 2025 at 12:42:39PM +1000, Dave Chinner wrote:
> > > The external log device can have a different sector size to
> > > the rest of the filesystem. This series looks like it removes the
> > > ability to validate that the log device sector size in teh
> > > superblock is valid for the backing device....
> > 
> > I don't follow.  Do you mean it remove the future possibility to do this?
> 
> No, I mean that this:
> 
> # mkfs.xfs -l sectsize=512,logdev=/dev/nvme1n1 -d sectsize=4k ....  /dev/nvme0n1
> 
> is an valid filesystem configuration and has been for a long, long
> time. i.e. the logdev does not have to have the same physical sector
> size support as the data device.

Sure, and I've never disagreed.  But you'd not explained how that is
relevant for this patch.  The bt_meta_sectorsize is only used for
asserting the alignment of cached buffers, and we place no buffers
(cached or uncached) on the log device ever.

