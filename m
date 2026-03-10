Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D532BD5B4;
	Tue, 10 Mar 2026 06:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773122487; cv=none; b=DRO13Re+QE93a/qAzXwIVPI9Dlz28NPU1twLwxTqHwUFKGl1EL8FHWe08K2dI1D4HhyqT97x846T2GwPubomudsYJ8adBtP9BRaqPyMw9+nXHvH9ecEe5gQxw6f9VjPxIBNapadxwc7C8gJNdjyOrzqNuFfZ5OCVjXdbV7+XRg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773122487; c=relaxed/simple;
	bh=pcVc9Pouz7lkg5v65oe7+D28QvskTR2dl5in922rYic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2AyaTBaKj0g/eDfhC4S6yn5IbkmXwSbnPhMPXvcm6HwpnyGdP6NQAUzxWEU10Uax8TlYiMSjCVtmXIxke2xfKVfagbTO681LU92hp6NRW9N7H0vZuZU455+KqGbbmSIr/aV05CkdkgvqHGHpZ9x+WZ4byHayMTJuJMSL1O8Up4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nz9IeBLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nz9IeBLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0415FC19423;
	Tue, 10 Mar 2026 06:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773122486;
	bh=pcVc9Pouz7lkg5v65oe7+D28QvskTR2dl5in922rYic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nz9IeBLYWvwYXJeLU812UbuzIcBxgLZqPrDcdN+b+JX4LZrqR2igIpo6pI8FmVgui
	 aXSSulclqsHn/Eh4BDqE0OaJaaAEJ8eMGAH0yXFm+ddQnNTj9nBpG/p1Sx8LOQnTMY
	 1jKerhye52gKTjCVkp1ZGMl//8be3/X50YplRaO1C2mqQp4wVlITYSi704Vv/ddV+s
	 GT/GU0ylJ5goQLWLyQTbmCxWSalmy1uyQh7PAqvHgN+ahQxK5iNDqs6G8CNhNFCDBb
	 QsNxXpLD4BJv/4oTwxkABzo7FbIiiiT+DUkVj1bec0/MoY9H3oifC1UvW4iqrIJ0Xn
	 6sVKO0IxZeW6Q==
Date: Tue, 10 Mar 2026 17:01:15 +1100
From: Dave Chinner <dgc@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, jack@suse.cz,
	cem@kernel.org, kbusch@kernel.org, axboe@kernel.dk,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v2 5/5] xfs: introduce software write streams
Message-ID: <aa-zq5troQ91i73v@dread>
References: <20260309052944.156054-1-joshi.k@samsung.com>
 <CGME20260309053436epcas5p3cdfff99c945032dc50503774770f4317@epcas5p3.samsung.com>
 <20260309052944.156054-6-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309052944.156054-6-joshi.k@samsung.com>

On Mon, Mar 09, 2026 at 10:59:44AM +0530, Kanchan Joshi wrote:
> Even when the underlying block device does not advertise write streams,
> XFS can choose do so as write-stream based AG allocation can improve the
> concurrency and reduce interleaving of concurrent block allocation as well
> as logical fragmentation.

XFS's default allocation policy already does this "stream
separation" implicitly on a per-directory basis. So you're going to
need to be more specific about the workload that can benefit from
software write streams being assigned to specific AGs...

> Use a simple 3-tier (low/medium/high) AG count based heuristic to
> publish streams. This enables logical spatial isolation for standard
> storage, execluding rotational media and rtvolume.

This is completely unnecessary if you use the filestreams allocator
for write streams to do workload separation. There is no special
hardware mapping of streams that we can use, so just an AG per
stream will get you exactly the same stream separation behaviour.

And, FWIW, filestreams works just fine on rotational devices. In
fact, that is what filestreams was designed for: optimising IO
to/from massive isochronous RAID arrays full of spinning disks that
stored uncompressed high definition video streams in file-per-frame
format. Keeping each video stream in a separate AG meant each frame
of a video was placed on sequential RAID stripes and each video
stream hit different disks in the RAID arrays. This mean video
stream reads and writes always did full stripe IO and the IO from
the different streams never interfered with each other.

So, yeah, get rid of the arbitrary "can't use software mappings on
rotational devices" because we know from experience that it is just
not true...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
