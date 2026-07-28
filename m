Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5BD1FC8;
	Tue, 28 Jul 2026 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785214788; cv=none; b=NGEF1odSTRPmdFK74FCS078yUsi4r9xTUAaIWsqGzkv2eEeFI00WllYIY8lZFOmwMMiRHmD8tnXKMZHMCgXi4WhrM3oP/mcss+ZQ07/P256TzzIiZul9I16UDaOHXreG3bA+tNdoq8qOE0Z1L03WY7D89V9zT0E72bn+wfLCz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785214788; c=relaxed/simple;
	bh=c+LPG7XmK+7U6N1YyS5FtIfmTwYnNLMmAV1mBECswK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJSDTo+7Z5LMWqdJd9ZRF8WuvCIe8+rlgFrsV8De0XmwnbmFZqzTTnTfLqHUN0yxFI26KbnkVSemYYtgjwjM09YkZeZwwk2Ukt4k369eQstA01VSNRfK8WzrGMrzy9x2jT7vgiUNy3SpeVPd3WtdmFoHB1Bbbfu/ny/zBuLW090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DCE2F68AFE; Tue, 28 Jul 2026 06:59:44 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:59:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 12/22] iomap: better read bounce buffering support
Message-ID: <20260728045944.GA20354@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <CGME20260723145102epcas5p1b832a57cc20b821145a4814f29d4fee5@epcas5p1.samsung.com> <20260723145000.116419-13-hch@lst.de> <1d08c3f3-29d6-42db-973b-1c544b436e15@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d08c3f3-29d6-42db-973b-1c544b436e15@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 27, 2026 at 07:47:27PM +0530, Anuj Gupta/Anuj Gupta wrote:
> On 7/23/2026 8:19 PM, Christoph Hellwig wrote:
> > +void iomap_bounce_read(struct iomap_ioend *orig_ioend, unsigned int minsize,
> > +		void (*submit_ioend)(struct iomap_ioend *ioend))
> > +{
> > +	struct inode *inode = orig_ioend->io_inode;
> > +	struct bio *orig_bio = &orig_ioend->io_bio;
> > +	loff_t file_offset = orig_ioend->io_offset;
> > +	sector_t sector = orig_ioend->io_sector;
> > +	size_t total_len = round_up(orig_ioend->io_size, minsize);
> > +
> > +	WARN_ON_ONCE(!(orig_ioend->io_flags & IOMAP_IOEND_DIRECT));
> > +
> > +	do {
> > +		struct iomap_ioend *ioend;
> > +		struct bio *bio;
> > +		int error;
> > +
> > +		bio = bio_alloc_bioset(orig_bio->bi_bdev,
> > +				min(total_len / minsize, BIO_MAX_VECS),
> > +				orig_bio->bi_opf, GFP_KERNEL,
> > +				&iomap_ioend_split_bioset);
> 
> thw new bio inherits REQ_POLLED via orig_bio->bi_opf but iocb->private 
> still points to the never submitted orig_bio; hanging polled reads.
> Maybe mask REQ_POLLED from the bounce bio?

Yes.  And I need to come up with a good way to provide test coverage
for polled I/O interactions like this.
