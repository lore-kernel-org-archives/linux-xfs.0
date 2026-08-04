Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE33421236;
	Tue,  4 Aug 2026 19:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785870031; cv=none; b=qBz1YRfQ8+R+XwPcBNX+d2mEAUbFhui/fSeygm5RAa2ELtUkEJBVNc3WZ8koIPQvrqmYboj7DPWZMl2w1gcC8mtuqfU7vdJnhIHz/mYmHsmJhqNwQ2vAceGTpYZAlBJ35vVe6mxvBAPt8yMWAaupl5+/0rVOCytnRPctvXlpk44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785870031; c=relaxed/simple;
	bh=U0cUnBHXXBzpX4hs+2YD00oNzK/cvSlJUd7PyjV3MPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nt5NU3FPIvkeHwQjFgGRWMi64pLrJKRSJ7n8Eq7vzGaIkht41NSx5nXL/xP68P3miTXTc9CqdUohtLvlz9REn7F/+YAMKHai/WaLIiRMdtnRGSrynofhmfxyApaa3zTxQVnZV6vqzsnuDAfBL3gF4EQlUqxfw5kwQUU+JER0I5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnwpTPvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnwpTPvv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 75F9D1F00A3D;
	Tue,  4 Aug 2026 19:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785870027;
	bh=oTbuw/euW+vCmgqmL6+mJcayXncOdyukRicUuH2+0kI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BnwpTPvvn3TIPcenIfDsdMZXWdypqmknhdx/u5JgPYdVJssvRi6efz4Ee+BETc6+d
	 vSSkWiSMf5CvqIwFL770NKdjcAFcMaeeOTjxIl6JOLolmO3k/xMaXfZccvfvy9x0BU
	 dCLeCU76Z8Yw9+w+qS9x9AQnrt3WilfeYvkKcL4uobYs2KAnhMXPlUTG6Z6kXQTUOC
	 MEiEmZE45rmayhVfHemzGodB3Po5hFtBsnbPmpGTcmifbyfIweM9zETwYSljoX+0X2
	 wJwuAuuG370yPZTs4dkSm5sKrOH3MyN3Mf0zTh0aF4a47z4Y4jduwqLjSGEbLzitAI
	 KhMZ8ePtgux0Q==
Date: Tue, 4 Aug 2026 12:00:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804190027.GQ3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-6-aalbersh@kernel.org>
 <20260804174223.GB14046@lst.de>
 <20260804183752.GC2904385@google.com>
 <20260804185700.GE2904385@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804185700.GE2904385@google.com>

On Tue, Aug 04, 2026 at 06:57:00PM +0000, Eric Biggers wrote:
> On Tue, Aug 04, 2026 at 06:37:52PM +0000, Eric Biggers wrote:
> > On Tue, Aug 04, 2026 at 07:42:23PM +0200, Christoph Hellwig wrote:
> > > On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> > > > The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> > > > flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> > > > systems. Open code folio mapping and flushing to copy all digests at
> > > > once.
> > > 
> > > This looks correct, although to me optimizing for this feels like
> > > premature optimizations not worth the ugly code unless we have numbers
> > > to justify it.
> > > 
> > > If Eric wants it:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > > +		if (folio_test_partial_kmap(folio) &&
> > > > +		    off > PAGE_SIZE - offset_in_page(offset))
> > > > +			off = PAGE_SIZE - offset_in_page(offset);
> > > > +		for (; to < (vaddr + off); to += vi->tree_params.digest_size)
> > > 
> > > Style nitpick: no need for braces when comparing with simple
> > > integer arithmetics like this.
> > > 
> > > > +	for (off = offset; off < (offset + len);
> > > 
> > > Same here.
> > 
> > Well I didn't ask for it per se, but I pointed it out and asked whether
> > anyone will care about the combination of XFS && FS_VERITY && HIGHMEM.
> > Based on Darrick's email it seems the answer may be no?
> > 
> > If it's kept as-is, adding a comment mentioning that it doesn't need to
> > be optimized for HIGHMEM would help preempt any questions about it.
> 
> Note that the explanation in the commit message seems to be confusing
> people as well.  It only mentions flush_dcache_folio(), when the actual
> performance problem on HIGHMEM would be the mapping and unmapping.

Ah.  In that case I definitely don't care to optimize it unless we get a
complaint from a real user.  XFS doesn't really support 32-bit anymore
because xfs_repair on large filesystems is known to run out of address
space for all of its temporary indexes and crash.

(I'd be fine with dropping this entirely.)

((Yes, we could increase the amount of address space by cheating with
memfds, but yuck.))

--D

> - Eric
> 
