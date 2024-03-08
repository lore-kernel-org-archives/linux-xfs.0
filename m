Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FCF15C0;
	Fri,  8 Mar 2024 15:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709911369; cv=none; b=MMX4BzAiD3nlEtbl+s7mYOO9McnmaQSLWzY558f9zb/i89dxIYPA4KfcM3ku6gDSAZEqYOsXoHNaZeXyM9a7w6EYuaIYItGNek5N08t1yaaszi+sadGjCdy51ZcbhXeBufLJ5Z4AbkoZ62OLGN2tGbNnwply+Q2AdQqb0r2rS5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709911369; c=relaxed/simple;
	bh=ZxlwDvGSgvkRxr1WjFiV9x6QgoQZrb0uHj/jKyYgpzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRisQVt8BEse14ioVCehlpmdKiyTFG45ebW61kGof7+aaYdY+RSm1EktXXIDas8NBaqrAT7WX+/bfOYrWImWv4cJ4BmWnsSldaytHmrxu5/3iHr9Yc3BO+TywiCOwYw69RCTVsDvn6phhtk1UPChtzoqu2lkxoyQKN2Pv56SDIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A990268BEB; Fri,  8 Mar 2024 16:22:44 +0100 (CET)
Date: Fri, 8 Mar 2024 16:22:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] block: move discard checks into the ioctl handler
Message-ID: <20240308152244.GC11963@lst.de>
References: <20240307151157.466013-1-hch@lst.de> <20240307151157.466013-3-hch@lst.de> <ZeoylEeVMt2fXT2R@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeoylEeVMt2fXT2R@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 08, 2024 at 08:33:08AM +1100, Dave Chinner wrote:
> >  static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
> >  		unsigned long arg)
> >  {
> > +	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
> > +	sector_t sector, nr_sects;
> 
> This changes the alignment checks from a hard coded 512 byte sector
> to the logical block size of the device. I don't see a problem with
> this (it fixes a bug) but it should at least be mentioned in the
> commit message.

Before the exact block size alignment check as done down in
__blkdev_issue_discard, it just moves up here now.  I guess I need to
make that more clear in the commit message.
