Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9A23B7B99;
	Mon, 20 Jul 2026 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540341; cv=none; b=ZkiLXtgUkWJw3za4N//3j4iRZiHW7m1lY1L+nxa7rT4GrWzdrdjhElI1zBKWxjty3zU52cyzU1xYkjH7aaYrhqc3QR3VX8F8Z4lKkd0rQGDoho0SPBrto/P8Oj/NXeR2xSXsun76/Q+eBMgca9dQE5Mhm6lLqg5kl8QGP1+cH64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540341; c=relaxed/simple;
	bh=Or9STJmTlI1vfut4rRuIukCFIbLzcT1Tg4gzU9rrD3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g445xUEgXS/d3m1LhxkSLgAyBxRLcDaMsv9560EFv7bEGJc7MInl9/kgLzE7yWTDnx1UozGzhai1RKdT5xY17VJcgsARXA3W+tq4xN9jt5AjzCcErIHEl/xYZ/7GBx02iTxBm36Dfaescq+wEAbTOyOPInsCCwONEmEgGwXD95U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUKffP8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUKffP8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E1F1F00A3F;
	Mon, 20 Jul 2026 09:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540340;
	bh=99A7jp8QhPLMVch4cyBgRkG6zDkaywXbbfwScdUUt7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IUKffP8DwaKJ28l6aiToJSOmfxkguMWbnlXprzLGx8vaS/JbRCCtz0D+qEG/u0a67
	 ifMBZUAXSuU0fmiK5r9SEbe1QidZHe9HkjngxaZhG8EThu2TawOosnZlrRx7MLUIe8
	 JbyO3nGlIFmip6/Pq2/Y6h7wbjgiTDliaDATW8NIxJcfo05sA3XCT8P2N7+kNbHTh9
	 IJyX1eJjHodLrcf4nhAb4uFwpLPFTQz/1pYsMugyl7gNCAyCd4XYB2IpzhvYlamprL
	 /aLHDtOzgzDT8bla6rCqjCqt08WneJq8UEclHyPpzrp9LCtmmhS+xfzdw+Gql4hyx3
	 iuGtH8+DkC9aw==
Date: Mon, 20 Jul 2026 11:38:56 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>, 
	Matthew Wilcox <willy@infradead.org>, Damien Le Moal <dlemoal@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <al3rszGopCngWzN2@nidhogg.toxiclabs.cc>
References: <20260623142109.1838702-1-hch@lst.de>
 <20260623142109.1838702-2-hch@lst.de>
 <al3j0GaQaeYj0Ih8@nidhogg.toxiclabs.cc>
 <20260720091128.GB24062@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720091128.GB24062@lst.de>

On Mon, Jul 20, 2026 at 11:11:28AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 20, 2026 at 11:02:15AM +0200, Carlos Maiolino wrote:
> > On Tue, Jun 23, 2026 at 04:21:06PM +0200, Christoph Hellwig wrote:
> > > When using XFS with a main device on an SSD that stores metadata and a RT
> > > device to store data on a HDD, we fail to take the I/O sizes for the RT
> > > device into accounting, leading to up to 5% slower read performance when
> > > using an SSD for metadata vs storing data and metadata on the HDD.
> > > 
> > > Fix this up by taking the RT settings into account.  Note that this
> > > updates the BDI owned by the main device, and leaves those settings in
> > > place even when the file system is unmounted.  This is a bit unexpected
> > > but not different from manual tuning through sysfs (although that is only
> > > possible for the ra_pages value).
> > 
> > Sorry a 'very late reply', but...
> > On a second thought, wouldn't be wise to cache the original value in
> > memory and restore it during unmount/filesystem shutdown?
> > 
> > I could send a patch to complement this one if you guys agree, otherwise
> > just ignore me.
> 
> As mentioned this does seem like a valid option, there's tradeoff
> both ways.  Although we'd also want a flag to avoid restoring them
> if they were changed while mounted so it would get a bit more
> complicated.  Happy to respin it for that if there is a general
> preference.
> 

Sorry coming back late to it, I don't want to give you extra work after
we've already discussed the implementation.

I was going to merge this patch today, but it came to my mind that might
not be a good idea to just quietly update BDI settings while XFS is
using it and just keep whatever change we made persist after the mount.

I can still merge it this week and we decide what to do later or just wait a
bit for extra thoughts on this.
Perhaps let's see if we get other comments soon and we make a decision
later this week.
