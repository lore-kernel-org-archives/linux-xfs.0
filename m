Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373A2318EE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 07:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290426; cv=none; b=R4cGDWtgKLCB9QsPCn/QUkLNwrxWNIbG1zJnJlDwW+rvLl+tSCoSUSXH+ylXOTVDmbjArUgt0X7RHPoLPGm9ZBdjkNzbX19j++g4tcbWxLutEu8igqQhrabo1+mTirtIfXqpamGGLI5Dpy3XJFCoAWFQMo13J864T5Jhp5/LYHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290426; c=relaxed/simple;
	bh=fLHHqwG45LfA+xcqnoxVC35WOOJPshoGI1vLDpEDU+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcZDXrpePVPMc59exP9/CxXFmqt+rqcYH60FK9xd3RJv6pPoVlpAOZENPgionEMyZg0M7x9+dMl2bA3u5xpjmvKgAbpgksfL+V5rkOk6/uuELzSWnWh7cjUNER3buqwDVyi5N+//aHHheaHGiOCKInmfrCTmGiMPF3AgfPr+J9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8B830227AA8; Tue, 13 Jan 2026 08:47:01 +0100 (CET)
Date: Tue, 13 Jan 2026 08:47:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Message-ID: <20260113074700.GB28727@lst.de>
References: <20260109172139.2410399-1-hch@lst.de> <20260109172139.2410399-4-hch@lst.de> <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 12, 2026 at 11:15:07AM +0100, Damien Le Moal wrote:
> > + * pointer.
> > + *
> > + * For conventional zones or conventional devices we have query the rmap to
> > + * find the highest recorded block and set the write pointer to the block after
> > + * that.  In case of a power loss this misses blocks where the data I/O has
> > + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> > + * the most recently written ones got deleted again before unmount, but this is
> > + * the best we can do without hardware support.
> > + */
> 
> I find this comment and the function name confusing since we are not looking at
> a zone write pointer at all. So maybe rename this to something like:
> 
> xfs_rmap_get_highest_rgbno()

Well, we're still trying to make up a write pointer.  I've renamed
it to include estimate, and in the revised series this goes away
as a separate helper.  But what is confusing about the comment?

> ? Also, I think the comment block should go...

In the update version this goes away as a separate function and I
think the comment gets into a better place before a function that
queries the hardware or estimated rmap write pointer.

> This code is also hard to follow without a comment indicating that write_pointer
> is not set by xfs_zone_validate() for conventional zones. Ideally, we should
> move the call to xfs_rmap_write_pointer() in xfs_zone_validate(). That would be
> cleaner, no ?

No.  xfs_zone_validate is about to become entirely about the blk_zone
and not XFS internal information.

