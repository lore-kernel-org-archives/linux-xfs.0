Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E57413D8E;
	Tue, 21 Jul 2026 09:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625814; cv=none; b=QCFwsVmnMY9gWm8FBPNmLOS5+X/55RmIv003B2wbtfTVOlu1OE8s2QMnVDzIvnk/CWBub4K/LLT7cC2/u920isIeACrmGZ/P2CaLO0+pAqxsO7KCKMq3On+M3u/7ys4qBblHzVyD0rK9VTsHAs1xV1MgksZG2tQp/FVZ42MU/m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625814; c=relaxed/simple;
	bh=Dtiv0g/kBy6elPvKCe97k35VyXNa8WpbDnRW1+ts5RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPyTpFECV5gsEeEp0bVHY1By9eD9s+t5gpJ28i4SGocArMj8BFoQCzMh404KB6DIM3B16UuykmiN44iwcn1ctQcAentBmVoUPNJG0D1wAjTOKJHzVr0rHlFnwEPftTiaJdyqEvTOZuqG7pwymfyBZ5RDKvM/Xwx6zDrOIciLhlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Om5zXwDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Om5zXwDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01D91F00ACA;
	Tue, 21 Jul 2026 09:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625813;
	bh=si2zwd4201NbjCrKU0ilWzmlqxXb2UYo3JpfBfGKbmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Om5zXwDBGGhXV5cJ/LlsXeabcmoFKYJgaqtAaJuumXzZ3EiUGotPSLYUuLgNa8VXS
	 dt2zZ8YiIFDwiHGdXEyZ8s2iFSkpYgoMsCChF/8CqxzSGuWRs6fYKOBBQAljRJyG+9
	 USVAT29620AtJ4rE0uFJ0dB7dh/6PiNdF88JhGdyALfM2HLRWMVd/4CHlXe+QS2KrH
	 pBCo3R8+yi9FRVySDBl93GVPjSWp8wEZzo5l13SxpDb/N6mwX78W7JOB6eoEnkMqKN
	 4cRwFC5QYW69ZmYh98ksw0YMLz92zMJz41tUT6DtpB5B8iLKhH+m4Dse9LLrRyt6yU
	 pWkdsd1VBnTVg==
Date: Tue, 21 Jul 2026 11:23:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jan Kara <jack@suse.cz>, 
	Filip Blagojevic <filip.blagojevic@wdc.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT
 device limits
Message-ID: <al86SnXSDqQ0sKkR@nidhogg.toxiclabs.cc>
References: <20260720140849.2269776-1-hch@lst.de>
 <20260720140849.2269776-2-hch@lst.de>
 <d2c1b12e-c6ab-4614-b851-c42b808fc6eb@kernel.org>
 <20260721043011.GB6339@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721043011.GB6339@lst.de>

On Tue, Jul 21, 2026 at 06:30:11AM +0200, Christoph Hellwig wrote:
> On Tue, Jul 21, 2026 at 08:07:40AM +0900, Damien Le Moal wrote:
> > > + * Update the BDI values to the max of the data and RT device to cover our
> > 
> > s/data/main ?
> > I am still confused about the proper name for the device holding metadata :)
> > 
> > Other than this, this looks OK to me.
> 
> Historically the main device is called the data device, which is
> also reflected in all kinds of field naming.  But yes, it is confusing
> especially for zoned xfs setups.  Maybe I should do a little global
> naming sweep..
> 
> 

+1, please keep /data/ here, this makes much more sense in xfs lingo...
Perhaps we should start naming them to something like ndata (for normal
data) and zdata for zoned data, but that's talk for another thread.

