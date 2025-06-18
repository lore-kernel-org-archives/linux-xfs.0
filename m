Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8C21F4727
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 05:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750223151; cv=none; b=IGzhBAeZZeOwbdkNfts5vP0WPU1PoMpN+MImSBMFg18HFnLadvFS9RZEaiKvu3d7zoH3bQM0L8pQIxqv5yMYMrsQHpxS99apZd4A36SIxPh8Q5uqwLS4eMbEB3P9HMzpUWLAwPM3mmrtd8rLt3f5l6jDY8teVbJ54zx5FvKh5W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750223151; c=relaxed/simple;
	bh=qCUWiCmZO8Ib/N+ZVCUz22mXhMDq7o2m/PziFnyg78U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lwsvVoSfB1O2v9O+q4EukDo1Pg3ovSEMo3Adbm7BlJJbd2BywpIOqb6G1bGCosDzKShLLkTnsQr7nryuUJ41RcsjC1p5Pknt043NC7NXRGQsLCa/3VW7iLO1lR4EvKEjq5v0uN4frrqOlLYqXL5RyGVPWQplKPs3KKYbDaZwJoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00D9268D0E; Wed, 18 Jun 2025 07:05:45 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:05:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove the call to bdev_validate_blocksize in
 xfs_configure_buftarg
Message-ID: <20250618050545.GB28260@lst.de>
References: <20250617105238.3393499-1-hch@lst.de> <20250617105238.3393499-4-hch@lst.de> <aFH85PhSv6NnjWIQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFH85PhSv6NnjWIQ@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 18, 2025 at 09:40:20AM +1000, Dave Chinner wrote:
> On Tue, Jun 17, 2025 at 12:52:01PM +0200, Christoph Hellwig wrote:
> > All checks the checks done in bdev_validate_blocksize are already
> > performed in xfs_readsb and xfs_validate_sb_common.
> 
> For the data device, yes. I don't obviously see anywhere else that
> we check the fs external log dev or rt device sector size against
> the block device sector size, so unless I'm just being blind it
> seems to me that this check in xfs_configure_buftarg() is still
> necessary for those devices.

bdev_validate_blocksize does two things:
 
 - call blk_validate_block_size to enure the passed in block size
   is a power of two, > 512 bytes and < BLK_MAX_BLOCK_SIZE
 - check that the passed in size is larger than the sector size

In xfs_setup_devices both the main and RT device pass sb_sectsize,
so the first part is common for them, the log device passes
either BBSIZE or sb_logsectsize.

XFS verifies the is power of two for both sb fields.  The
BLK_MAX_BLOCK_SIZE is not relevant as we don't set the block
size in the block layer.  But yes, we are missing the
XFS (log)sectorsize >= lba size check for the RT and log device,
I'll fix it up.

