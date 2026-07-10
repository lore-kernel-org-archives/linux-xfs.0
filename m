Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B0A1A5B9D;
	Fri, 10 Jul 2026 04:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783658132; cv=none; b=JRSiK529UBo6R5c75VvLOJLLs4YUPdZmgo1dyS3UEIQ2QX0EL7u86GiRwqiGis/Win1WJCclWk8sn+d0gatIkTXYqc3atznYew4pEQaP7ZxX9s18Q+CBbpTUtsdj69ET6XYtkFPKNPGN0eMPikyomsEPpkAJBwrCA/Byk+u7uGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783658132; c=relaxed/simple;
	bh=t78A5rSeEI3MRsSV+lVKitFPJppqUsyVSaYrK5HAwuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKcihQvMgk6OTFq+mXR7bFE4UEZaNIsn0ucAr9AuJ5UQ9S2nY2t1yo0kceyT7QvCFdvdBy8dyXRDpIULJaczpdYdajm9jETOUcIY9TqrNdiuooENJqBVK00uRkZLizgJQ0mEJIQVF/a7pybMF+FkLZLs5fa8pIOJWdzcXzpQBQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B66A068B05; Fri, 10 Jul 2026 06:35:19 +0200 (CEST)
Date: Fri, 10 Jul 2026 06:35:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <20260710043519.GA6205@lst.de>
References: <20260708011843.1036846-1-kbusch@meta.com> <20260709071352.GA20180@lst.de> <ak-mQqt-a-jy6ZoV@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-mQqt-a-jy6ZoV@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 09, 2026 at 07:46:42AM -0600, Keith Busch wrote:
> On Thu, Jul 09, 2026 at 09:13:52AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > 
> > > +	fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> > > +	fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> > > +	fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> > > +	fa->fsx_dio_virt_boundary_align = bdev_virt_boundary_alignment(bdev);
> > > +	fa->fsx_max_segments = bdev_max_segments(bdev);
> > 
> > How is the max_segments value defined in a way that is meaningful to
> > userspace?
> 
> It tells you how many sub-sector vectors you can submit in your
> readv/writev before it needs to add up to a logical block size.
> 
> Ex: 4k logical block size, 4 byte DMA, 256 max segments. You can define
> 4-byte iov's in your command, but you'll hit the max segment count
> before you have a valid IO if they're all that small.

Ah, makes sense.  But besides the missing documentation I think
max_segments is a bit of a misleading name for that.

Something like max_vecs_per_block (although we don't expose blocks
in the UAPI) or max_vecs_per_granularity (I think grammar wants a word
with me for that, though...) might be a bit more suitable.

> > > @@ -145,6 +155,8 @@ static int file_attr_to_fileattr(const struct file_attr *fattr,
> > >  
> > >  	if (fattr->fa_xflags & ~mask)
> > >  		return -EINVAL;
> > > +	if (fattr->fa_pad)
> > > +		return -EINVAL;
> > 
> > How is this related?
> 
> I had to add a padding field to the struct to account for the implicit
> hole in 64-bit and to ensure the struct is the same size for 32-bit.
> It's a reserved field, so we have to ensure the current kernel doesn't
> support any value here in case we define this field for something else
> in the future.

Ah, right.
