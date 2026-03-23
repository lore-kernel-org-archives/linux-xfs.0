Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605163B6C00
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 15:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279085; cv=none; b=MOjzBYQxNgEz8IeOQb8C20QcyqvwCfmzGbqV8kat725U6KYN/+Vti5OBhkuRdyllWBONa2LpGCYjNvyppGFt1LbHIaIzAIvxuPHAeXpV/z9oaxkrRbiGMyLJtm2asDFEJLykvKg7p2ZOl/64nCzRLUJ52wojAr5HKYgw/RcgTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279085; c=relaxed/simple;
	bh=EHEabmXU9LVStWwndHvug/08itKnjSZuXk0ubiKo5vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FwlDtcyEugaxZu9Z/7Pe8CTkwUvKtOY32ozc7nips7UfossmvXOqyki0qWVILoziA1PHecfJXln7IuvpoHSlZwsw+mw2ydrOEZSw6nA+4lMxLiHsLVQecOyo3B5yebHBOmevzvUwa6LnsX7LVJ9g2hQUuC59swL9kcHLYjf0ySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQZs642c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQZs642c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4C4C2BCB1;
	Mon, 23 Mar 2026 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774279085;
	bh=EHEabmXU9LVStWwndHvug/08itKnjSZuXk0ubiKo5vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eQZs642cVFUXTUHP2f92NoVjReO0iMj3kuVKUsLkJogkLxxzWQ2u0LxKmBzh4DV7i
	 T2xn3SY7V2WCPm+OaAWReq6IKnOm/Om2+xNMwnWxEG6Uv8fqtQ8yU6ryI6WixoERP/
	 QDfinQmHRiMbdlNcJ4kO1j/MnXQjxYEB2eoIByAswY83IA3lOtU3hZhLjHpCAreiaO
	 kBIO1ji2jliGVhlL+Fa78eNDHHrG8H//ZFJy6uFcRYBwynF45DmJyts4acWLjbFvBz
	 K/Y6j2opbEpJ3IHOsUq+qtZF3eiQoz9fy/Uf/Z4qc28TgQX5m4HKAuE2u7zV4RXwxS
	 vunHRtm3D9EBQ==
Date: Mon, 23 Mar 2026 08:18:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] xfs_scrub: allow overrides of the media
 verification IO limits
Message-ID: <20260323151804.GF6223@frogsfrogsfrogs>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507344.3681140.4424251568194204096.stgit@frogsfrogsfrogs>
 <abz0jpxjiVBe0hEQ@infradead.org>
 <20260320154453.GC6223@frogsfrogsfrogs>
 <acDY9Vu8BIyTbUtC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acDY9Vu8BIyTbUtC@infradead.org>

On Sun, Mar 22, 2026 at 11:08:53PM -0700, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 08:44:53AM -0700, Darrick J. Wong wrote:
> > > So you'll need to hack the systemd unit files?  How could we set this
> > > on a per-file system basis?
> > > 
> > > Not really arguing against this, but we might end up needing more
> > > flexbility in the end.
> > 
> > I'd do per-fs tweaks by defining an xfs_property and telling users to
> > set it, e.g.
> > 
> > # xfs_property /home set scrub_verify_max_size=128M
> 
> Sounds reasonable.
> 
> > I don't think we need to define the property right now, that can wait
> > until someone has time to do a more in depth analysis of what settings
> > adjustments are needed for modern hardware.  I'm keener on figuring out
> > something that'd work more automagically because sysadmins are lazy. :)
> 
> Agreed.  Another thing we might want is to record the scrub progress
> somewhere so that we don't always start from the beginning when
> interrupted.  Also not really needed now, I'd rather land the code
> first.

<nod> I'll send out the most recent libxfs-7.0 resync patches shortly,
so Andrey can get started on that.

--D
