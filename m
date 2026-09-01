Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82A46EC7C;
	Tue,  1 Sep 2026 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250327; cv=none; b=omzXp//dn2hIT3KvkYs+GID8iNJsV+A+wYlDIXGnvLC/vNdQzszfIg3f+Bhg2u+Lnr5LcsWwmrLV9n2u1/1Pz40VHJTiI8tajNR+HipR0J4GPumyNAfJI3h9G1uXDhlMnbrlzaLUfRCpF1Vg5oGtsPNsSSuFg6sTLQutHoedw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250327; c=relaxed/simple;
	bh=gBIzIbNFR12//+mkGiJ16TI6jFrWvhCXBaD3KNNlxt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSUsmWnLx5bUzK2XcSKYre7/6jv0a2WzxBlsEYWo95M5suyQbO75+EoukfsKTOP85vEOp0babt5PDhVkmgL0FQhn1DnPhuGVitOhJAV9oRY/ewnsIBwmfVCzobO4oKFzytD2u9zHRC/BaFKF+O+qutjRH+LHOFxiJR0suk7dypg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1CE568AFE; Tue,  1 Sep 2026 10:12:00 +0200 (CEST)
Date: Tue, 1 Sep 2026 10:12:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/17] block: warn on too larger integrity allocations
Message-ID: <20260901081200.GB22531@lst.de>
References: <20260831064010.2574896-1-hch@lst.de> <20260831064010.2574896-3-hch@lst.de> <20260831180136.GI1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831180136.GI1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 31, 2026 at 11:01:36AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 31, 2026 at 09:39:50AM +0300, Christoph Hellwig wrote:
> > Catch cases where upper layer bugs create larger I/Os than the
> > mempool would return even without dipping into the mempool.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/bio-integrity.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> > index b23e2434d80c..d3df726e0f08 100644
> > --- a/block/bio-integrity.c
> > +++ b/block/bio-integrity.c
> > @@ -72,6 +72,7 @@ void bio_integrity_alloc_buf(struct bio *bio, gfp_t gfp, bool zero_buffer)
> >  	unsigned int len = bio_integrity_bytes(bi, bio_sectors(bio));
> >  	void *buf;
> >  
> > +	WARN_ON_ONCE(len > BLK_INTEGRITY_MAX_SIZE);
> 
> Should it fail the bio after complaining, then?

We can't really fail here as the entire path is build around continuing.
This is really a big warning for developer bugs that must not happen
for properly written callers.

