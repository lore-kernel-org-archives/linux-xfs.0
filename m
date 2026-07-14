Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7850044683D;
	Tue, 14 Jul 2026 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046873; cv=none; b=pU2+dymtbRTavPdhhw7mNKFCxMYbXFIfuQpIQ0XpE+ONKDhVxdRUkST+NntVgSBpj4SdafSozBlF15KlGDysiiXjcpGogZQeOtmXa2AoGq0F3NcuYKmTETBNZKji+JBYqdEvnUR6Rj7H0yGEVQuB2t3HMT3omHcXYSfLfUcnYG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046873; c=relaxed/simple;
	bh=mcOLsVa24VNG9GTo+jcA12exvUJxO7xcAnzAFK+mDk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSTb8vb1LxHfZ9DsTteTUy5BBehk1nFX79SoC8hR/fnGQsfwsBIfX2VcyWoEyccRRMpnd8cV0hn5kY9oPv7wnS9pjg0ajlBINjLNeQog2bn+1fmKKPetzT97cu/aYV53L6W7Rw2zofyxNAAF7Tgh0+OzxipkSU+E22IgrHkV8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXVgkcyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXVgkcyR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 05E961F00A3F;
	Tue, 14 Jul 2026 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784046872;
	bh=tyjFGMJS2PAuFb9Al89Zqm+4X+qgTD6eTTQ7xhfafTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JXVgkcyRV2w7u4qwSOxpOHeJ6w5UJpNrV68kvnWbZJDH2l4G3DBJEgsSClZJLI6Ny
	 K/YxshM/PEOSclCdxynCO1gzQOuREVOgoxV8Nu6Zgr+tqqIhIU6fC2tDqUOv2k8z8Z
	 Rp8Bcji4XtKR9kVVA5U0ACskmc84e7Jx8DlU/Acei/UV7dX8vRRmAhGZnzhrY74cFc
	 096a10JXvvbY+XdXDC82algLSUiON4coHEduA6Oz/frN9EH1ByKvHq323tC7kxV5x8
	 LOwfKf8iGJ/tIIw0TZ8Y0MrRaaHVv72lziltr+ka6MxEuwwQZ5yEocVdBvhqNZIl9X
	 3CS7BvpPItp5Q==
Date: Tue, 14 Jul 2026 09:34:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: clamp timestamp nanoseconds correctly
Message-ID: <20260714163431.GD7398@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
 <178400716925.268162.444784889317482361.stgit@frogsfrogsfrogs>
 <20260714061557.GF1072@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714061557.GF1072@lst.de>

On Tue, Jul 14, 2026 at 08:15:57AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 13, 2026 at 11:07:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed an off-by-one error in the nsec clamping; fix that so that
> > we never have tv_nsec == 1e9.
> 
> Hah..  
> 
> >  {
> > -	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
> > +	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC - 1);
> >  	*ts = timestamp_truncate(*ts, VFS_I(ip));
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But I'd really expect this would be handled by core timing/timestamp
> helpers.

I'd have thought so too, but timestamp_truncate doesn't clamp tv_nsec to
[0, 1e9) because it assumes that callers (mostly the vfs) already did
that.

--D
