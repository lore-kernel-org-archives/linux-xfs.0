Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0943CA497;
	Fri, 10 Jul 2026 22:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783724295; cv=none; b=FpgvaGlIqJGpptT9Fq/zaUhIl1SpSlBoxnDx2fXU2vjQzo8qNnplWTdzZq7jYyL/aN2eZvNbnSbmIKcb6GbT8k5KTi2YYwBfUAxytMTM0lnl8xd9BvVugP8YOY5OPw+ZqeBKCoJ3cEizfN+sRA0erJ7KkHBmtCLxQ/RIiIxylvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783724295; c=relaxed/simple;
	bh=mw9eRWBKgSM9ZaHZNC7SpFAzvrPEQ6jqzkwbNGeqKVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBRFc8aosHQAZwMrez5PB0sotWkWQkRyzkB38XPrhreSSCGYtZJPZG8AZh90ubdDdhh3TSYw6pZEx+SMeNJ0+gc/MB14h5U/eIE7aeMl0p3gIX51njMFtymwJvnqXfgqHOZlqwQhONxIl38fJqVILFGHDdloXYz5UK5FAS+6OXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQbZWvrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQbZWvrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CCD1F000E9;
	Fri, 10 Jul 2026 22:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783724294;
	bh=NkeORe+bO7UNqmqDFJw/AxpC9nvY1tbNbvdLo/yNIQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mQbZWvrMX0flq/z1MA3Kytgtdx6+fyTYu3dK/X7c4oh70mKhm8ZwVnKRtqylnCqv/
	 GTDsEKO+4rGVvyaM2mD1j7XtNnoVYfg9A1AOmzG6sclc+zG56GXVsqzxwRSOtvElVu
	 um63FKHXWR3AmeCcw/Yg+9uwD1cWn19jV+QkE0c/Jb38Grx3fOYKsz5qarVCVc0AqL
	 9qYipa2T4SbgN4sJp+jr6MSgFwVJ4Qe6zclXuIrbIum7ByL4E36JBYGIEEtdqfat/J
	 gjmy1hI2SlX0c3whMXkKadmd4vp3erA/l0Z30LVFBF2+NYTlrMfcq5tegUMtBMSvng
	 L9Zd8PjyE7LuA==
Date: Fri, 10 Jul 2026 16:58:12 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, aalbersh@kernel.org,
	jack@suse.cz, tytso@mit.edu, jaegeuk@kernel.org, cem@kernel.org
Subject: Re: [f2fs-dev] [PATCHv2 0/5] direct-io file extended attributes
Message-ID: <alF5BHEZ5czyJWaY@kbusch-mbp>
References: <20260710210646.3576365-1-kbusch@meta.com>
 <20260710215328.GE1911@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710215328.GE1911@quark>

On Fri, Jul 10, 2026 at 05:53:28PM -0400, Eric Biggers wrote:
> On Fri, Jul 10, 2026 at 02:06:41PM -0700, Keith Busch via Linux-f2fs-devel wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The attributes reported through statx are incomplete for applications to
> > fully know exactly how IO construction is valid or not. The statx call
> > can report minimum memory alignment and total granularity, but it
> > doesn't show the underlying gap boundary requirements or max segments
> > per granule.
> > 
> > This series adds the minimum to the extended file attributes through
> > file_getattr. I hear this is the preferred interface for reporting such
> > things over adding more fields to statx. In order to get everything
> > under a single syscall, some of the attributes are duplicated from
> > statx.
> 
> Okay, in v2 we at least now know that the existing statx UAPI was
> considered.  Could you give a specific real-world example (with the
> actual values of each parameter) where it's not sufficient?  Without
> that there isn't really any way to evaluate this proposal.

Yes, we can consider nvme. This protocol supports two different transfer
modes called PRP and SGL. PRP requires 4k aligned segments, though you
can have an arbitrary 4-byte aligned offset at the start. SGL on the
other hand allows completely arbitrary size and alignments for each
segment.

statx reports information sufficient to know that you can have dword
aligned page offsets for a virtually contiguous buffer, but it doesn't
report PRP's boundary gap requirement, so applications can't tell if the
file follows PRP or SGL rules for direct-io.

And if you have a device using SGL, statx doesn't report the max number
of sub-sector segments you can submit in a single command.

This series provides both limits so user space has the complete picture.

A typical nvme that supports only PRP has a DMA alignment of 4 bytes, a
dio offset alignment of 4k, and a virtual boundary of 4k.

If SGL were supported, there would be no virtual boundary gap, and max
segments is 256.
