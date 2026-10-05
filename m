Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D9E481A97;
	Mon,  5 Oct 2026 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205892; cv=none; b=Kk9Ebj0sxzKLaFwLXDRdm2p/G90f4Z5hKvM3M/1uagYFbxXMpgDpfwmxXLx4FzkjzjcDdwAgkp+Tp/WvYnhLkLYpyelMkYfgoS97ivd5UedhG2AtJRYt/3sM4xSZTLJZhrLlqsZVZ9K+nJvA3WPq/ZhKyP2HqNpl9rFyAKAPgjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205892; c=relaxed/simple;
	bh=rwI9RR9EAYt6j2DBEfQTDUQVbWv3+cWmgFveBfny9mQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aH7sq8QdXYGY1XzLEq6SHFsWwFP8btIceHXgLEGoeZ95jvOJ3Mmdp5CC0TB9L9/zxWKSazzzv992CWEfP+ZNeTU3236/5wS57Vc7l7AsguByX+FBsWV8un8eMmIJmHS1V/2u1/Xu3QTK0mMutLEHMywbmHHou+p+NuxeZklLhuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F34768AFE; Mon,  5 Oct 2026 15:11:27 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:11:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/21] xfs: add data checksum support to zoned garbage
 collection
Message-ID: <20261005131126.GD26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-17-hch@lst.de> <20260929010639.GX2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929010639.GX2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:06:39PM -0700, Darrick J. Wong wrote:
> > +	/* Buffer for data checksums */
> > +	struct xfs_buf			*csum_bp;
> > +	void				*csum_buf;
> 
> Where is csum_buf used?

Nowhere, left from an earlier version.

> > +		error = xfs_rtcsum_read_async(mp, chunk->old_startblock,
> > +				&chunk->csum_bp);
> > +		if (error) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> > +			xfs_zone_gc_free_chunk(chunk);
> > +			return false;
> > +		}
> 
> Ok so this starts the csum block read asynchronously, and then submits
> the read bio.  chunk->csum_bp is the checksum buffer of the rtcsum file
> of the zone we're cleaning out, right?

Yes.

> > +		boff = xfs_rtb_to_rtcsumoff(mp, chunk->old_startblock);
> > +		error = xfs_rtcsum_log(chunk->oz, chunk->new_daddr, chunk->len,
> > +				chunk->csum_bp->b_addr + boff);
> 
> ...and then write the same checksum to the new daddr using the old
> checksum.  There's no explicit validation of the checksum in the garbage
> collector itself, but I gather the read ioend did this for us already,
> right?

Exactly.

