Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E1526ACC;
	Sat, 11 Jul 2026 00:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783729456; cv=none; b=mL7VshNCe+UzG5WxYFXGEeFv5p13A8C7qSPXnGPWbcAbEyGO1R9dR/TMoJjlIpXnzzrPZ4y0uhPu7qap9tBFFolJUfVyHqksmvfdbl1gAPsyjsoCoUmUEObHMfibTUMX2PEfIEx+/XRaqqd3kA6EbVrIQuJP0uTAmnwUsue8D5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783729456; c=relaxed/simple;
	bh=pwcS+JPhE+W/ODtU0qbehIRMPyrOXRiZ+yUqfS2Rkho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kp1kpEyf/fkzsUQy/SmNvoAZQAUHjk9Oepc9edfKRUf+qBPxvn1huWFsu6MlRzPSPb9KaLfkDMSjfCtobfo4TCDbCfaUMAWFelyxBZmbe/IYTf5dzjvdTyzHMUY7ubyrIeHxkJmmwWAfCXN+935DT088TH6KYlE5BDW+23fUDlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POsAX31I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POsAX31I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC45D1F000E9;
	Sat, 11 Jul 2026 00:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783729454;
	bh=KFEzUaw/g/UY9rxNioMfIoydpjuxUFKK3/1Tvh4wibs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=POsAX31IWu/ZhM35wRUyOQm/LLL5C+CsYCR/eBwvf0NnHgI3lSsEkv8g9ME3OHu+g
	 5YLPzqT+WkhmOO8rKwKOdERg9WIadWU016pZySHkLwMkUZhyAgxHx5KPCcae34Vc+T
	 OSfcqyfcZ1GEBpyZ81RULmKvq/ZcxNq7QHO+TFnSvZUML/6mUMAyT23+9zv6Kzei9v
	 qM9lH81J0rCzK4N/EeBpMfRGOLtMOSzMlyk/CAzOv72ub0kj8eq38+9T8743cVy0be
	 HWIXZvNI+wMHHulBFG4Yqv+wbdW8Jyl1VqYUdj5AyOEImaan/gQ2P6Y3WTUlEk1JlS
	 DB5Zm1Ma5jTJA==
Date: Fri, 10 Jul 2026 20:24:12 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, aalbersh@kernel.org,
	jack@suse.cz, tytso@mit.edu, jaegeuk@kernel.org, cem@kernel.org
Subject: Re: [PATCHv2 0/5] direct-io file extended attributes
Message-ID: <20260711002412.GG1911@quark>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710215328.GE1911@quark>
 <alF5BHEZ5czyJWaY@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alF5BHEZ5czyJWaY@kbusch-mbp>

On Fri, Jul 10, 2026 at 04:58:12PM -0600, Keith Busch wrote:
> On Fri, Jul 10, 2026 at 05:53:28PM -0400, Eric Biggers wrote:
> > On Fri, Jul 10, 2026 at 02:06:41PM -0700, Keith Busch via Linux-f2fs-devel wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > The attributes reported through statx are incomplete for applications to
> > > fully know exactly how IO construction is valid or not. The statx call
> > > can report minimum memory alignment and total granularity, but it
> > > doesn't show the underlying gap boundary requirements or max segments
> > > per granule.
> > > 
> > > This series adds the minimum to the extended file attributes through
> > > file_getattr. I hear this is the preferred interface for reporting such
> > > things over adding more fields to statx. In order to get everything
> > > under a single syscall, some of the attributes are duplicated from
> > > statx.
> > 
> > Okay, in v2 we at least now know that the existing statx UAPI was
> > considered.  Could you give a specific real-world example (with the
> > actual values of each parameter) where it's not sufficient?  Without
> > that there isn't really any way to evaluate this proposal.
> 
> Yes, we can consider nvme. This protocol supports two different transfer
> modes called PRP and SGL. PRP requires 4k aligned segments, though you
> can have an arbitrary 4-byte aligned offset at the start. SGL on the
> other hand allows completely arbitrary size and alignments for each
> segment.
> 
> statx reports information sufficient to know that you can have dword
> aligned page offsets for a virtually contiguous buffer, but it doesn't
> report PRP's boundary gap requirement, so applications can't tell if the
> file follows PRP or SGL rules for direct-io.
> 
> And if you have a device using SGL, statx doesn't report the max number
> of sub-sector segments you can submit in a single command.
> 
> This series provides both limits so user space has the complete picture.
> 
> A typical nvme that supports only PRP has a DMA alignment of 4 bytes, a
> dio offset alignment of 4k, and a virtual boundary of 4k.

So each segment's length has to be a multiple of 4k, *and* it has to end
on a 4k aligned memory address?  That implies the segment begins at a 4k
aligned memory address as well, which is just stx_dio_mem_align=4k.

What am I missing?

What is a specific example of an I/O request that you'd like to be able
to submit that the existing UAPI can't declare support for?

> If SGL were supported, there would be no virtual boundary gap, and max
> segments is 256.

Can you elaborate on why DIO users need to know max_segments?

I'm worried about the UAPI duplication, as well as it going to be very
difficult for userspace to correctly use this information.  With just
the two alignments there's at least a chance of them getting it right.
If we throw virt_boundary_mask and max_segments into the mix, I don't
think there's much chance.

- Eric
