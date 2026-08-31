Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02A353EDF;
	Mon, 31 Aug 2026 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158631; cv=none; b=pnOGcdtKtr9MRkPgG21ufjJxAL2fK7SAbmQK54+xr296GaFDsa1DUfgnBAeielHZcMGc0pvdBeDPOIdZDlHfPSnGxslH2bCrBfYXbxZs9qsLBc2Et8jhFHtGbUN+yZMO4bw+7V34RAh/g7x+1DiKxHJa4lIvH9Mh+Lfxvmijk4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158631; c=relaxed/simple;
	bh=eqK6ON7fK6bI3ZcCQQ8td+DTHlUzPTbOxgiXw58sYEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHa4u2q9H2PlLF1js9D8gYUe0IPnhH5F8TV1cke19hEa8jZcaXFv54g9Fc9ABP4QIAkq4lh6DmAVF26F/qubwIrAVSBy0xJnYseNRdLaFzOYdbaT8oipraeKDKgncgWFotc1ViV2Vmr2s9bg2xe0rsxWeMkDYKX3ilikPMsZxSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkGuArwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkGuArwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC691F000E9;
	Mon, 31 Aug 2026 06:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788158629;
	bh=hxtid+k1GbsKMn7sH9/NJOZw53qw5u57dZrsml2Btos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nkGuArwjSttVIui6c/FQRwqqrqSCzzr/FmD4+05TC4ybogEEb6iqQVMyQAfuw21ii
	 LgOVLfwx0yPv9qjf0l6zGRPw4RF5vDGDq7oG79f3224cQTQaOtzmvIPCuEjb6dhtC6
	 3nPGTE6578cC8ckfmOcJ5rwZMOgn2+Y3n0oX51P8qI0YnVs5GB89hqKfZSW7s94cAn
	 rbdGftNsgBZKPjTXB38343f0L55bGgSYNJvlWrNaMavP0rcNJx4jzJgLz4mnGojxCf
	 ddjGKYr+KQ9D96MwUIdqQ94lRGU7CD1E8+CI0YN7kY8WVH/j/IZ+Ctqb/Nuapj93cI
	 wzjVCvJCW9csw==
Date: Mon, 31 Aug 2026 08:43:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Peterson <linuxinstalled@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Peterson <eric.peterson@hpe.com>
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
Message-ID: <apUh22V-i99HtgGN@andromeda.toxiclabs.cc>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
 <apSgHPl4er6Jy9xi@dread>
 <20260831004700.4072037-1-linuxinstalled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831004700.4072037-1-linuxinstalled@gmail.com>

On Sun, Aug 30, 2026 at 06:47:00PM -0600, Eric Peterson wrote:
> On Mon, Aug 31, 2026 at 07:26:52AM +1000, Dave Chinner wrote:
> > Hence this really doesn't seem like something we should be trying to
> > infer from indirect filesystem stats. Why can't you use the bdev
> > stats to get the actual filesystem wide queue depth information?
> 
> The block device measures the device queue, which is a different
> quantity than filesystem outstanding I/O - not just a lower-layer view
> of the same thing.
> 
> Below are three cases where filesystem queue depth is not what the block
> layer sees:
> 
> 1. Cache hits never reach the block layer. Under a heavy read workload
>    with a warm cache, a large share of ops are serviced from the page
>    cache and are never seen at the block level. Device queue depth can
>    sit near zero while the filesystem is servicing a very high op rate.
> 
> 2. Filesystem ops don't map 1:1 to block I/O. A single read or write can
>    produce one block I/O, several (metadata, readahead, writeback
>    coalescing), or none at all. So device queue depth isn't the
>    filesystem's outstanding-operation count.
> 
> 3. Work can be outstanding inside the filesystem before any block I/O is
>    issued - waiting on locks, log space/reservation, delalloc, etc.
>    Such I/O has entered the filesystem but is invisible at the bdev.

Could you please put those in the commit description? For historic
purposes would be good to keep track why this has been added (or not).


> 
> The block-device queue depth answers "how deep is the device queue,"
> which is not the same as "how much work is outstanding in the
> filesystem." When the filesystem is just one layer an I/O passes
> through, the block stats fold the layers together and structurally
> cannot isolate the filesystem's own contribution.
> 
> To be clear about scope: I'm not proposing a queue-depth feature in
> the kernel. The change just adds read/write completion counters to pair
> with the existing call (submission) counters, so userspace can compute
> outstanding I/O and derive a response-time estimate itself. The kernel
> side is only exposing the complementary raw signal that's currently
> missing - calls are counted, completions are not.
> 
> Being upfront: what userspace derives from this is an instantaneous
> approximation, not a precise time-weighted queue length. It's meant as
> a cheap, always-on aggregate, not a replacement for accurate per-op
> tooling.
> 
> Does exposing the completion side of the existing call counters seem
> reasonable on that basis?
> 

Particularly I liked the idea and the justification seems fair although
I'd want to see the justification for the counter in the patch
description.

Carlos

> -Eric
> 
