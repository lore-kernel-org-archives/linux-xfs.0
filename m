Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55035189F43
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 06:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761201062; cv=none; b=QRjgW5ZRwYMrdhs5g1xXwhwQdJ0crUyCnuv0i1GDQ2YR1cERxKFn4drCvjmMiCI12Y4gzTTvz2eEhhpyghaEunrNQWsdP9hdoWLUd5YLCxr+tzN8aYuM6b26oDEICi82dg+H0Pld9vEevPPS8uRu0kJbvGh5PJqAFerIs9GBE78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761201062; c=relaxed/simple;
	bh=Mw8krz+UOWbo4VBxYks/HxY96FuT4v5eSLUhVHk1dBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GBk1JjpzUPl6CmxidHAJZXsYAyP4K+0X2IOZhIi85l0zUpMVaolsfVXZLZnFpuuovw8ea7/25Lm3rCuNq6OOI+aFCZnif4e1I1UomRJ1hZsj6McyDIzrpSM/offUuMJ6kzYCYPgKxVAFAKn1Nukvg1VlECj2f80NownEXzMDG/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00261227A8E; Thu, 23 Oct 2025 08:30:55 +0200 (CEST)
Date: Thu, 23 Oct 2025 08:30:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: document another racy GC case in
 xfs_zoned_map_extent
Message-ID: <20251023063055.GA29593@lst.de>
References: <20251017060710.696868-1-hch@lst.de> <20251017060710.696868-3-hch@lst.de> <20251023062125.GQ3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023062125.GQ3356773@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 22, 2025 at 11:21:25PM -0700, Darrick J. Wong wrote:
> > +	 * Note that this can also happen when racing with operations that do
> > +	 * not actually invalidate the data, but just move it to a different
> > +	 * inode (XFS_IOC_EXCHANGE_RANGE), or to a different offset inside the
> > +	 * inode (FALLOC_FL_COLLAPSE_RANGE / FALLOC_FL_INSERT_RANGE).  If the
> 
> Or (eventually) this will also be possible if zonegc races with a plain
> remapping via FICLONERANGE, right?
> 
> (Like, whenever reflink gets implemented)

Yes.

> I guess the zonegc write completion could just iterate the rtrmapbt for
> records that overlap the old extent and remap them until there are no
> rtrmapbt entries returned.  Then you'd be able to catch the
> exchange-range and reflink cases, right?

I don't think so.  All these remap operation would at this point would
have remove the rmapbt record for the old record because they changed
the logical mapping.  So I don't think we'd find anything useful there.
