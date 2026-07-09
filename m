Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB736F439;
	Thu,  9 Jul 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604809; cv=none; b=dgXXB5R91FoWQX3EHUEOsPedC8SxZcsU3Tt6WN6gJ8IXrj29S6Mr45w4qEfGkQXKNGZOkOThF2YtOm8fhzIsjNBPmMPiC40w6q3w/j5asPCnwaJLBjo6fxkefRl28aRqxRhNA758/+LT6Ya8lVlQOuP4PKOVZH9S1bYyBzcn5Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604809; c=relaxed/simple;
	bh=Yt0Anlkyxs8Kc/6GbH1GdXH5KQ3+Ny7arJBnpMpBiFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgN5i1ltyTAs8LLsxwHEwc776AiEKClUU98J5Z3ilIxo8pyyoa9WV7RiD8Ggim8QtziGfpLKn1ZiGlVJgR1Z6A3SwpsQ1IpP1WSO0WQQR3wdQFvToRElv9Gg/Hv9G/9SYTpiS2YIxYtw9KUW4EooD8pgKUVQmRsW54Egbcr5FHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AhWODjiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AhWODjiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB7B1F000E9;
	Thu,  9 Jul 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783604804;
	bh=UL3vDynmWxUSqCx3PVJTM78NQC5YacFiGvq0zDihpIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AhWODjiQt1SnQ1SczulwHGvJwXHy7PVENMAKy+TzSz7vzgLfJjgSCsxduqvfLmY6j
	 fkTkgcVVAY2WhwPjbeFDAZgztT6s6c0U8h9ziC2ecZOqAsiQowinbvZHNCGeLyCxNJ
	 oxkZvA09GDG/1hZ+FmXjUyyP5Xs4LStvFOJKHRKgd26RzlwGMjPx/LxpwTXsKaDnK8
	 FNM2TuK3ybChiQpEX539cbzp/Atz+0ql6uRvfORnBlWSqeqPwgRi0FFqlPAsK2x5vY
	 QZTVSjGqBkrhsbumaQTgMDrDO3AATKN8hwA9m7H398iKuYdmI0PL9FbfrT2skUUHLc
	 gwqFmLT6AH4rg==
Date: Thu, 9 Jul 2026 07:46:42 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, jack@suse.cz, brauner@kernel.org, cem@kernel.org,
	jaegeuk@kernel.org, aalbersh@kernel.org, tytso@mit.edu
Subject: Re: [PATCH] fs: report direct io constraints through file_getattr
Message-ID: <ak-mQqt-a-jy6ZoV@kbusch-mbp>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709071352.GA20180@lst.de>

On Thu, Jul 09, 2026 at 09:13:52AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 06:18:43PM -0700, Keith Busch wrote:
> 
> > +	fa->fsx_dio_mem_align = bdev_dma_alignment(bdev) + 1;
> > +	fa->fsx_dio_offset_align = bdev_logical_block_size(bdev);
> > +	fa->fsx_dio_read_offset_align = bdev_logical_block_size(bdev);
> > +	fa->fsx_dio_virt_boundary_align = bdev_virt_boundary_alignment(bdev);
> > +	fa->fsx_max_segments = bdev_max_segments(bdev);
> 
> How is the max_segments value defined in a way that is meaningful to
> userspace?

It tells you how many sub-sector vectors you can submit in your
readv/writev before it needs to add up to a logical block size.

Ex: 4k logical block size, 4 byte DMA, 256 max segments. You can define
4-byte iov's in your command, but you'll hit the max segment count
before you have a valid IO if they're all that small.
 
> > @@ -145,6 +155,8 @@ static int file_attr_to_fileattr(const struct file_attr *fattr,
> >  
> >  	if (fattr->fa_xflags & ~mask)
> >  		return -EINVAL;
> > +	if (fattr->fa_pad)
> > +		return -EINVAL;
> 
> How is this related?

I had to add a padding field to the struct to account for the implicit
hole in 64-bit and to ensure the struct is the same size for 32-bit.
It's a reserved field, so we have to ensure the current kernel doesn't
support any value here in case we define this field for something else
in the future.
