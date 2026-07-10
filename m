Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7EC363C5B;
	Fri, 10 Jul 2026 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696955; cv=none; b=g00qFfOcQI7v311xrMTEHperVHbxIiilXiXO6R+xLH4LtjBURW+4DJ1ovj9OK8smKbMALeXlFxHjcBLDfjyXF12UZ/7UWpNG9Fuvdc1q01l1i/OXW2Yo/iZxSVD1yhTdtqC90dSeud+MYTnh5WZed7lo5ZuY+PPGIRikGwNuZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696955; c=relaxed/simple;
	bh=8gzFoNNR4YwjlaVrX0OmmylnRCGx7JLjJgNqHpDhGus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re7BE0OkUHmK9l8IDDmxLPRhoBBuD+x8a1b77kc4g3NrpW5BsUAcscro3QuZwzro34TCN3sdOdjmKztemwThY9MJJrw5uSOAnFNeh0/v0G392bHlXR/QES0lq1SwbstsbZB04skZAuWcPUCATtq1juQnGyDpdJKMO7mtNglnrMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UClDCNbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UClDCNbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83291F000E9;
	Fri, 10 Jul 2026 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783696953;
	bh=BZBmbz6+BQI2Kzh1iUDOvyORAvj/yICrOCZDo+Rp0kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UClDCNbCQfNVRQhm1i8d0xb29cuN0tYD1gSYn7nGQxcwS7UY+Fj+hD+7dJGoKu6Zg
	 5dYucbOrXi+v7T24cB56Kj8GAb1o3zBc9NpvUvN5qN3+YfFzwGuu96lk54Lzoit87D
	 P/hGUwB9WQjR82lZLQWwQitL+/Bv5Y8BZH6R/S5wyEVMfzdFEcixq45ps9RC5QDPjc
	 iSoPzj/1r4B8qaXm++3azwoC4Yb8dd/t/FKEfXkTGZYSqWjTHmfxIksx4hz8WTp+TP
	 xjssz+2VAgXF7xqPMcYBg54aH6eutuE3PC4QXMK3tooi3O/AVmgdjEBLUn+HPAXBxF
	 9d+WnwGLCmO8A==
Date: Fri, 10 Jul 2026 09:22:31 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <alEON9EQ3BAX_D35@kbusch-mbp>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
 <ak-mQqt-a-jy6ZoV@kbusch-mbp>
 <20260710043519.GA6205@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710043519.GA6205@lst.de>

On Fri, Jul 10, 2026 at 06:35:19AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 09, 2026 at 07:46:42AM -0600, Keith Busch wrote:
> > On Thu, Jul 09, 2026 at 09:13:52AM +0200, Christoph Hellwig wrote:
> > > On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> > > 
> > > > +	fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> > > > +	fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> > > > +	fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> > > > +	fa->fsx_dio_virt_boundary_align = bdev_virt_boundary_alignment(bdev);
> > > > +	fa->fsx_max_segments = bdev_max_segments(bdev);
> > > 
> > > How is the max_segments value defined in a way that is meaningful to
> > > userspace?
> > 
> > It tells you how many sub-sector vectors you can submit in your
> > readv/writev before it needs to add up to a logical block size.
> > 
> > Ex: 4k logical block size, 4 byte DMA, 256 max segments. You can define
> > 4-byte iov's in your command, but you'll hit the max segment count
> > before you have a valid IO if they're all that small.
> 
> Ah, makes sense.  But besides the missing documentation I think
> max_segments is a bit of a misleading name for that.
> 
> Something like max_vecs_per_block (although we don't expose blocks
> in the UAPI) or max_vecs_per_granularity (I think grammar wants a word
> with me for that, though...) might be a bit more suitable.

The granularity it has to add up to is defined by the
fsx_dio_offset_align attribute. This is a bit long, but to make that
relationship clear, how about:

  fsx_dio_max_vecs_per_offset_align
