Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D222F39A5
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381222; cv=none; b=IvYY9yhi2BxNHWhWpJVSShqrEz4to1hq3utD+fBoBDbLTKwra+M0S/4T3UESZDjFW/hSbEJU4gs/ycEs8+xKQ83o31+zdgkmJ9PATaLoCwMlsG/jHORN/+V6ldsvKG52Xfs2fhIgwl/IQmRLJ1OHcdufmWVUl1/gJ2bG9tQ0ZzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381222; c=relaxed/simple;
	bh=FnjrLaX/twMAs3lfht2TzeU0+9b+8Bbt7bSJnis37V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dkbo2HVFPJuDM1TQiU6Yyfq2ujIPNMZD7b08FLL/k7G7RKscIMCh72sW7rlWLonyEos1h7q7H50NoKf71M7d6mfYULrBUzV21+bwRKVqcrjNVTZ26YVI2kElMXeF9rCKO1oZ5I2sYESqFbr6i2N/o+ChxUu+AiAtNPtWJhENFaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 58DB3227A87; Wed, 10 Dec 2025 16:40:16 +0100 (CET)
Date: Wed, 10 Dec 2025 16:40:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251210154016.GA3851@lst.de>
References: <20251210090400.3642383-1-hch@lst.de> <aTmTl_khrrNz9yLY@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmTl_khrrNz9yLY@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 10:36:55AM -0500, Brian Foster wrote:
> Is there a reason in particular for testing this with the zone mode?
> It's just a DEBUG thing for the zeroing mechanism. Why not just filter
> out the is_zoned_inode() case at the injection site?

Because I also want to be able to test the zeroing code for zoned
file systems, especially given zeroing is a bit of painful area
for out of place write file systems like zoned XFS.

> I suppose you could argue there is a point if we have separate zoned
> mode iomap callbacks and whatnot, but I agree the factoring here is a
> little unfortunate. I wonder if it would be nicer if we could set a flag
> or something on an ac and toggle the zone mode off that, but on a quick
> look I don't see a flag field in the zone ctx.

I don't really follow what you mean here.

> Hmm.. I wonder if we could still do something more clever where the zone
> mode has its own injection site to bump the res, and then the lower
> level logic just checks whether the reservation is sufficient for a full
> zero..? I'm not totally sure if that's ultimately cleaner, but maybe
> worth a thought..

We could have a different site for that injection, but we'd still need
to move the current one or at least make it conditional so that it
can't trigger for zoned mode.  I doubt that's less ugly than this
version.

