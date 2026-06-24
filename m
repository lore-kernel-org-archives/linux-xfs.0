Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EBB1A724C;
	Wed, 24 Jun 2026 07:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286493; cv=none; b=e5flry/9gksi5+W3EZjoQa5g3Aicz76H6J0BTcHayJneWr8P4K/kQDwxZftR+cLBUExxMETJYXHdX/MNqXFEfKQMwERAWZYIuU1mcgXVLBTcD00oqRS19kHJyakBMosA3AVTw4r+c3kCkFhYOxhsJfxj3K/pGwfNHiFW8gPjmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286493; c=relaxed/simple;
	bh=1NRoBEdgPXWTcz3r0lu8OmTVYDfqthhYb1hNVfakD1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0NW5XbV9LCPOb8VNLdl8qWR0hJjTn7B7kF7KiaPO9qldrxgzfZavzXpBZp4Wymh6AAXvTRo29+be1vo59nq5r2ItDTgbGyL3wtfP2xRpL3HvE731wKYpVGGV+vii9XpF1zru9+rvql+IMgoVlZ2zPB+CGe69o0fLgqTL9gRtsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBD9E68BEB; Wed, 24 Jun 2026 09:34:45 +0200 (CEST)
Date: Wed, 24 Jun 2026 09:34:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260624073445.GA12359@lst.de>
References: <20260623135208.1812933-1-hch@lst.de> <20260623135208.1812933-3-hch@lst.de> <CAJnrk1agx-qUizNzCnzvZ6Marf7u-K4EtKOak4c2MQN1sJfgNA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1agx-qUizNzCnzvZ6Marf7u-K4EtKOak4c2MQN1sJfgNA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 23, 2026 at 10:29:54AM -0700, Joanne Koong wrote:
> >  void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
> > -               struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
> > +               struct iomap_read_folio_ctx *ctx, bool force,
> 
> nit: might simplify things to drop the unused force arg

I guess this is not directly used as a method, so we could.

> >
> > -       while ((ret = iomap_iter(&iter, ops)) > 0)
> > +       while ((ret = iomap_iter(&iter, ops)) > 0) {
> > +               iomap_submit_read(&iter, ctx, false);
> >                 iter.status = iomap_read_folio_iter(&iter, ctx,
> >                                 &bytes_submitted);
> 
> should the submit_read happen after the iomap_read_folio_iter() /
> iomap_readahead_iter() instaed of before? From what I see, it looks
> like iomap_submit_read() would hold the iter state of the next
> mapping. It seems like in iomap_bio_submit_read_endio(), the
> iter->iomap.flags would be the next extent's flags instead of the one
> that needs to be submitted?

Yeah, the iter state would be wrong here if anyone actually used it.
But the only thing we actually ever use from it is the inode in XFS.

So I'm tempted to instead just adopt the signature to not pass the
iter, as nothing should rely on it.  The only interesting thing I could
think of for the future would be to pass on private data, but that's
probably better left for when we actually need it.

