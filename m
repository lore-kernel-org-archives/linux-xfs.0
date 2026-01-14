Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C67F36C5A7;
	Wed, 14 Jan 2026 06:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768372327; cv=none; b=ZTl2TrcMtTUOu+CHp+h+4nWopqAEGZKRvoCqaAa18gRCJBwJA6uo800nSdLYuKGom0DHwR/nXDCiuX7cbXd0O+sOA6/VnPGTqAt0BXT08XhJUKIyUFSKjtMv6JFx7x+v9TcjouThnbMA2oSeBdOEWMqsfZfq9eGocuRHUiG0SyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768372327; c=relaxed/simple;
	bh=gF/EbgwZ1LfhpgWxfNzhvTEn6OkVMWAIa6EqIaJZcuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1rUHu6pXnX4I+EzWejo2Ijach6emZrL/rHbLzMIAwHWkYBg0nc1gXFaAVfMpQgwewDCk6N6kO8KXB1nzuqzfd01YoACzPZ0VGJ5WD6JNYjymT5xSjs2jmHHCnJWNrjo5egq0sT7/AFrHD8HAf15s3PKmfKNCRFLAK9enwwDTKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C9A3227A8E; Wed, 14 Jan 2026 07:31:53 +0100 (CET)
Date: Wed, 14 Jan 2026 07:31:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <20260114063152.GA10876@lst.de>
References: <20260113071912.3158268-1-hch@lst.de> <20260113071912.3158268-3-hch@lst.de> <aWaOW-mjk7uuEcyW@kbusch-mbp> <20260113183208.GA15551@frogsfrogsfrogs> <aWaRxPwDZDJy2QqU@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWaRxPwDZDJy2QqU@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 13, 2026 at 11:41:08AM -0700, Keith Busch wrote:
> On Tue, Jan 13, 2026 at 10:32:08AM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 13, 2026 at 11:26:35AM -0700, Keith Busch wrote:
> > > On Tue, Jan 13, 2026 at 08:19:02AM +0100, Christoph Hellwig wrote:
> > > > @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
> > > >  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> > > >  	list_move_tail(&chunk->entry, &data->writing);
> > > >  
> > > > -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> > > > -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> > > > -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> > > > -
> > > > +	bio_reuse(&chunk->bio);
> > > 
> > > bio_reuse() uses the previous bio->bi_opf value, so don't you need to
> > > explicitly override it to REQ_OP_WRITE here? Or maybe bio_reuse() should
> > > take the desired op as a parameter so it doesn't get doubly initialized
> > > by the caller.
> > 
> > xfs_zone_gc_submit_write changes bi_opf to REQ_OP_ZONE_APPEND, so I
> > don't think it's necessary to reset it in bio_reuse.
> 
> Only for sequential zones. Conventional zones still expect someone set
> the REQ_OP_WRITE, as the previous use of the bio in this path would have
> been for a READ operation.

Yes.  This is indeed broken for conventional zones / devices.  I'll
update it, and passing in the op as suggest might make it easier to
use.
