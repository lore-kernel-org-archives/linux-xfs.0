Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65BA3FBB63
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108197; cv=none; b=GomVMJ4EzjBIwlpniLix4oxciGhaLMglcpS7R+ImuK/Kzc7xpcZ89KNPDvgF46bOuwTLMLbqLoLEzCnvWkvc2XIvdFdrahxf9Uw9zCzsNd7GdXn6xIASLEqEA9QaYP66mA0gpHdhfAiJ03zoKoKC3fbacjJpnVMozMrSWfaHRtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108197; c=relaxed/simple;
	bh=q0c5OBZHq95Hr8Cy8QB+4vIxoNrwP/knq9mnGp1nO+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nusKfWTQXKYqfPT0Cl8V8gYhFM2xThzbSWYqc218E9OHp6GXdrI77i3pb0Bc+2YHprNBLHQgcp0KK7PcpWFpEVY6GEsC15uAkj6/CusF9C5kkDkxcGX2A9R5TzQRiO+Cn4lAV6+DeKg9m+QvoCJHl2rpne9l3ShHKOh73LWaPA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0346468D09; Mon, 18 May 2026 14:43:11 +0200 (CEST)
Date: Mon, 18 May 2026 14:43:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: handle racing deletions in
 xfs_zone_gc_iter_irec
Message-ID: <20260518124311.GA4694@lst.de>
References: <20260518065224.9066-1-hans.holmberg@wdc.com> <agrERjRq10bm0rrY@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agrERjRq10bm0rrY@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 18, 2026 at 05:48:22PM +1000, Dave Chinner wrote:
> > -		if (error == -ENOENT) {
> > +		if (error == -ENOENT || error == -EINVAL) {
> >  			iter->rec_idx++;
> >  			goto retry;
> >  		}
> 
> Why did you choose to do this? I was expecting the updated fix to be
> dropping XFS_IGET_UNTRUSTED from the xfs_iget() call because the
> inode numbers are coming from a trusted source (i.e. the rmapbt) and
> this would then return the expected -ENOENT on unlink races instead
> of -EINVAL....

The inode number is not trusted.  It comes from a stale copy of the rmap,
and the inode cluster can have been freed and reallocated.  Dropping
XFS_IGET_UNTRUSTED would be highly dangerous as it could cause iget
to interprete something else as an inode struture in this case and
easily cause kernel crashes.

