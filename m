Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5524B1B33;
	Mon,  5 Oct 2026 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791211890; cv=none; b=A6K8uUOf2PSCCZ+RgfpF0p2sOeM/SL4IKj92ydVXMCUjM2lx8WFurAZKg0webhuAEeI/iTuCp3R9ZRc+RK00Bdhj4vX4hmQRpjVy6LezdXpaC6NHKvbrGTesxOkLwEAqa/SvllrYOcARL3NOmV8F4IH9/LKD66cFMWxHzabtxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791211890; c=relaxed/simple;
	bh=BKeDf5B5H+IZ06dkXGTwN2MZpk/zo6wusOiubwTetu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pZ2TsTN5x4mNsDZI+PU93DyzRdgOx34ovEQfDk1CNeiyoLbeWDeaaJHsddtt3RXmh6P+WGcIQKU0dbxY+31fczuerKwSFPGsuTquS56TszwrmElgsvaKpRiAgNmZ9vLteHvEarXCD2mp8JiQY6r8uBAAP6Ysonhjh1iuplK+4Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBsWrQv9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBsWrQv9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D523A1F000FF;
	Mon,  5 Oct 2026 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791211883;
	bh=RtBDG755PC1XDdD4Mqc1cS/7gJUqyuZwtGm666ES5S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WBsWrQv9/mT/bT2AJK9LFnUelj36HfwOYpQIoOS9ZTM/w/Nws81T+tYIOF2YhAX3g
	 6y2xaTmi0WTe67tvzclb4PK0muD05cDNr5zcC1VWunw6so3A9aYYh7YLj+0+S289A4
	 L6VA9hH2zTbJwEg1KGNIF5ablp5Ig66bmF6QxUZO/GKqSMkIIu8oBBpHb49HQq7pW4
	 +wPmPcWx4XyiUKCvAJ3ZE/R7/WX0Do0bNBnke4akIAZBDryWWm0GiC/f4uFfOc0+Rz
	 aBY09JTojpvHCl2o2qie8+doEDgMbB+SvPRGJgNJqLARgZ4Ar+ZkMld3OjCXwR0eR4
	 bqtdy3r0DIgbQ==
Date: Mon, 5 Oct 2026 07:51:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/13] xfs/2304: version of generic/388 that run
 xfs_scrub -x for each iteration
Message-ID: <20261005145123.GB2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-10-hch@lst.de>
 <20260929015645.GL2705364@frogsfrogsfrogs>
 <20261005132522.GN26805@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005132522.GN26805@lst.de>

On Mon, Oct 05, 2026 at 03:25:22PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 06:56:45PM -0700, Darrick J. Wong wrote:
> > > +	$XFS_SCRUB_PROG -x $SCRATCH_MNT >> $seqres.full 2>&1
> > 
> > I think we should just change generic/388 to run xfs_scrub after
> > recovery, and add -x if data checksums are enabled?  That /would/ have
> > the effect of catching recovery errors (or scrub bugs) earlier.
> 
> My idea was to key it off XFS_VERIFY_FILE_DATA.  But yes, generic
> is probably better if no one screams.
> 
> > Though I wonder how much that reduces the number of loop iterations over
> > a given SOAK_DURATION?
> 
> Good question.  Maybe adjust that if XFS_VERIFY_FILE_DATA is set?

Yes.

I'm ok with g388 running more slowly if it'll catch data checksum bugs
and whatnot.  I'm a little surprised that it doesn't already run
_check_filesystems every loop iteration.

--D
