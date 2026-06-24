Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F6322522
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 08:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782289591; cv=none; b=kr1t5dFEqGDpcGxDi2I9AbI42yzNrn/zvVI3/dOKxEXAPzDUmMz0r92LN+s5fzauN7iHRcMag41JlIpPSX6hoWQ/PRi7V8ygTZAlMuxXTHY392xqsTYJTU19rnXQYXSfm50C5z7xqWQjn/MY4NlxzfsmuYCUaB0Y6fRK4aHHdx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782289591; c=relaxed/simple;
	bh=sTjBE5iQm6kuLHU5HveUSysYJDi//IeRzOkQD7HU41E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+y7lJ96Nh3Lv+MLdZbDrEISl3wltuOk3G12CVY29kKmaYfpbX/xqOUwmdRBrXXHB/CGhMTFy2m6TVknBs2G8Q5IZU6gvTyLAjLLE/uFqw38rkUDZ8mo3aOl1U8ROCO/Qf5/0s63YHuChtYaerKsJLXnXsXR76O0nHUHAdd+6/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fh80VGlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fh80VGlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4661F000E9;
	Wed, 24 Jun 2026 08:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782289590;
	bh=yYVfQxNJLFha1my4/o8fx2XRqbHh6sEBDyEDAkJVWNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fh80VGlHanz7jFJ4DnTkK0Xutyy8PColayLSe2a1iqkOpJRamQzNdu5RK43Fel3oF
	 zlWuey/8f56GTC/vblE2vYFdOc0CEaExXgfMcpBjauodA6nNnaAerW818tqNXIVSNE
	 /t1C4Doa/rPZjECzQyINANa92kmBmMRWLun7LrDieLBaNrUCXy+kqT/+iRQM3t+Ze/
	 JoaMSiCLGQgQKDBdsrhVK80CQaN3he9mhcvFZ7KIiyxX4iacSSqt00eNIEM1cy7BEu
	 durKVfI9mGol331H1zpMtL8VluakwG1H9Wh+bM/mzan1UzUGrDXsJ5XIPm7cAZGthQ
	 QpOP8EkNQsnxw==
Date: Wed, 24 Jun 2026 10:26:26 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: improve the xfs_buf_ioend_fail calling
 convention
Message-ID: <ajuUlgquKt7puvOz@nidhogg.toxiclabs.cc>
References: <20260622073035.1370904-1-hch@lst.de>
 <20260622073035.1370904-4-hch@lst.de>
 <ajkxAU-VxjRrHVS0@nidhogg.toxiclabs.cc>
 <20260624074206.GA12969@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624074206.GA12969@lst.de>

On Wed, Jun 24, 2026 at 09:42:06AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 22, 2026 at 02:59:05PM +0200, Carlos Maiolino wrote:
> > On Mon, Jun 22, 2026 at 09:30:02AM +0200, Christoph Hellwig wrote:
> > > Move setting the ASYNC flag into xfs_buf_ioend_fail_async, assert that
> > 				  Is this a typo? I can't find this
> > 				  definition anywhere and the code also
> > 				  moves this into xfs_buf_ioend_fail(),
> > 				  not into a _async variation.
> 
> Yeah, this could use a little update.
> 
> 

If you'll be re-sending the whole series again, feel free to add

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

At the end everything looks good with these caveats
