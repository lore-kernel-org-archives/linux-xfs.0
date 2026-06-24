Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CAD25B0BD
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782289550; cv=none; b=CsJW1TW9n9HEY+aI3UiFXaxbD5Wn4cj9VwR/YlvEk9DTMoWgAWWXaV5BPeSW4SxkokUDnatS8NOAwGoWtjsja/sv3OxtGPpTcrorj9s5dQI79fFV9WIbnKn/pR+xGH0XM4w4etatXc3j2oYLojfLtfePbZEVXKdRv2h7Gstr1nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782289550; c=relaxed/simple;
	bh=FlqXlcukZ4XwS83N3fNjsihLGzMAYUVQ/9CUCjljIYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ht5aREVLTpDJoH2WSa6xo+k0RVtYZtZ+MpCEAPKmU7Diy8JC46FVVqipBNjWeEHwSk53hkTV37iZILF1t90bgxlVazGG7kfFJtVfTMxsIh/kZeD1TGSPirHEH9meX2BEGs6BgjD/fdiM8dpNXvP5VUHduudAcDkAdJ+6ah5TgPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlKCb9Cw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlKCb9Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE11F000E9;
	Wed, 24 Jun 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782289549;
	bh=XUSwVhzauuvp9hmFalpgAbqsZie28aJZSR15ubGSjz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BlKCb9CwvGwPzmxbq+2aN4pqTt5fUSKVjj0O7WDYa1vG8q3DzdzGlgmkLIUADEhXu
	 gcOoJZXQuExFbeMgCuWX3tFIQBa4Shv/OwIv08g2gvEgklGQnnAUKUZAStZfkkuRME
	 kfSyAE7IjyOfB1s8YDFcQno2rOoQi4fnHSTp/VE8JxvrK/pe9ULPKtNUX4hypE8xkn
	 KipEh4OpRpYLgKcwmy6sbly2o0xOOmnOO9hXmwy0qxaXH/OaxiCug6hmUmJDXvewqT
	 TOn32pcD6vzLrVt/uyF4C53+lqzImSZtM0Lxy/oPDW9Vsbq31uFZwDj4MIW4No8bYS
	 tqjQaSMK/uI7w==
Date: Wed, 24 Jun 2026 10:25:45 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: simplify the failure path in
 xfs_buf_alloc_vmalloc
Message-ID: <ajuUgVVA0_9iVwZB@nidhogg.toxiclabs.cc>
References: <20260617055814.3842058-1-hch@lst.de>
 <20260617055814.3842058-5-hch@lst.de>
 <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>
 <20260624074135.GA12896@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624074135.GA12896@lst.de>

On Wed, Jun 24, 2026 at 09:41:35AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 02:34:10PM +0200, Carlos Maiolino wrote:
> > >  	for (;;) {
> > >  		bp->b_addr = __vmalloc(size, gfp_mask);
> > >  		if (bp->b_addr)
> > >  			break;
> > > -		if (flags & XBF_READ_AHEAD)
> > 
> > My only concern is that looking at it now, isn't obvious why GRP_NORETRY
> > has been set in the first place, perhaps worth adding a comment above
> > it? Like:
> > 		/* Set during readahead */
> 
> Maybe.  But in the end we don't really care why it was set, as it clearly
> tells us not to retry, right?
> 
> 

Fair enough
