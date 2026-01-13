Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB41D432D;
	Tue, 13 Jan 2026 18:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768329671; cv=none; b=Jk0yzm07Kt+JpgUv+4481zgYTQKMFkPI8aI6cvvBgJyYtJLhFBRlIp1PzalBHs+xx1PjNvoCYrAJ0Y1wfhlKc0emn1sk01RctrpAkvms1oC6l9+XP/ZUkp37/2lY2V/nQXS5/EyL5MvK4UL3085kjItDokbweo4sk4ZMZatLbKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768329671; c=relaxed/simple;
	bh=onbFSuJYZ6AsHQCisBEUIaPyGLlE+VzFR0q8Y6RThfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YdwbOlZ1aG04xbqW8yOK+ejHpPazpv5G7AWtHFJhVLsYGYdtWC7oT734E7ordKgC7/z9PgMQWhuUy1vpBLaKd6j9FBbmWbtCHCAZw7a87f9NMzdtpvLXW/18wnkRhcYR8cZ+auRN3VFg1S1QD9FuxFRWazTE7WVOGnUGwVdKFmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbbtSySE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbbtSySE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6BCC116C6;
	Tue, 13 Jan 2026 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768329670;
	bh=onbFSuJYZ6AsHQCisBEUIaPyGLlE+VzFR0q8Y6RThfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IbbtSySEaSdRs8AKjPOJiX1L9HFWr3YM9FQCeU3DT0BJiBV4OT2gINaEagVB9paM7
	 5pxBzdmgEdeNV9U8QYzar4cgLfxWYWrIvYyxYfbcyMnSizY0nQYyL/eMvXF0/YSfyk
	 UgeYEYWL1XS8vt677vBDJhuXxqpniV4tQDHjnfqGKoNcOrwQYGHrbDTCx4KHVYN+aU
	 6fpqnY2NSi9HrWristfxUNGIzO6TxannvWmWOQKtxiCMt+9QCuVaQa3qyvVvLuWduP
	 wOvJefH5gXLbFcgf56Q2+nxb4fZtsdXsCw+h75k/wm3ykfKtRxT4P/hbSsIUBYlSKv
	 88ZJjEWR2dWJA==
Date: Tue, 13 Jan 2026 11:41:08 -0700
From: Keith Busch <kbusch@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <aWaRxPwDZDJy2QqU@kbusch-mbp>
References: <20260113071912.3158268-1-hch@lst.de>
 <20260113071912.3158268-3-hch@lst.de>
 <aWaOW-mjk7uuEcyW@kbusch-mbp>
 <20260113183208.GA15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113183208.GA15551@frogsfrogsfrogs>

On Tue, Jan 13, 2026 at 10:32:08AM -0800, Darrick J. Wong wrote:
> On Tue, Jan 13, 2026 at 11:26:35AM -0700, Keith Busch wrote:
> > On Tue, Jan 13, 2026 at 08:19:02AM +0100, Christoph Hellwig wrote:
> > > @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
> > >  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
> > >  	list_move_tail(&chunk->entry, &data->writing);
> > >  
> > > -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> > > -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> > > -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> > > -
> > > +	bio_reuse(&chunk->bio);
> > 
> > bio_reuse() uses the previous bio->bi_opf value, so don't you need to
> > explicitly override it to REQ_OP_WRITE here? Or maybe bio_reuse() should
> > take the desired op as a parameter so it doesn't get doubly initialized
> > by the caller.
> 
> xfs_zone_gc_submit_write changes bi_opf to REQ_OP_ZONE_APPEND, so I
> don't think it's necessary to reset it in bio_reuse.

Only for sequential zones. Conventional zones still expect someone set
the REQ_OP_WRITE, as the previous use of the bio in this path would have
been for a READ operation.
