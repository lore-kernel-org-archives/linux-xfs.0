Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B42B13792A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 22:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713306710; cv=none; b=OS1lnQJ7msZB3xbtbgo2xtV8bIJuyu6VdudgLbioQHXVWu+iDWVNuQ+9BMUdZUp5n094Auky69crSiTWywzCqnc2I86gelkVEKbiWK9i5tIiBkqrf2G7u7Xdp/WKyAekjvUpcdmdMZu3FZ5Mh5e9HQxdQiwAHWPwyebk5rjuhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713306710; c=relaxed/simple;
	bh=FJrNtv25vjcj+ASW88oXvdza1DlRF7EUUdRWzqxP+YY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/LBm+33FxQ4nR44FQRY45rhAN593eyFQgMxEDZ3WN0aDxIdhV3dC+DKZ8da4EXZyqmNQ6CD50+7AcMyfYlg5fJtlNe2bDGnTovHxN5qBHUrQPHWHABSTVDXxBbdeSgh9xwv8mowPszquinUPl2TWk294W1D1ScZFvvWDTI8M9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjMBgaca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjMBgaca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3395C113CE;
	Tue, 16 Apr 2024 22:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713306709;
	bh=FJrNtv25vjcj+ASW88oXvdza1DlRF7EUUdRWzqxP+YY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DjMBgacaGLXbjGSXPg3lwb9fnGYDfpHVttvX4ES7J+TY5BOhBP2MQuZWCSU9ZQvKB
	 aSvuouDoalaEkKP1Gfz3X2ojvbfMx6igbedIerq6JRwmWdBPnxUQDuHkN2+KkWbeKc
	 zZ05axGMqps67QWd0i2LSRRxCmMl/KZ/vunL7lbAw9nb6SVtfBRFYReHhc3Q4AleFB
	 PUNEtqJRP8JmZDiKlKr5VdGDVh7Gf4illVrH0bJVxPlGms+ZP5obmPQpdDez2sv5Ko
	 xylo03H1zFcdzw4FJUAu81PkUpq7KtZU/hKIIHRYdynDc6Gi5K19jC5KbqkRnVC0/j
	 TV0kiCXKApfeg==
Date: Tue, 16 Apr 2024 15:31:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240416223148.GH11948@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
 <Zh4OHi8GI-0v60qB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4OHi8GI-0v60qB@infradead.org>

On Mon, Apr 15, 2024 at 10:35:26PM -0700, Christoph Hellwig wrote:
> >  out_free:
> > +	/*
> > +	 * If we're holding the only reference to an inode opened via handle,
> > +	 * mark it dontcache so that we don't pollute the cache.
> > +	 */
> > +	if (handle_ip) {
> > +		if (atomic_read(&VFS_I(handle_ip)->i_count) == 1)
> > +			d_mark_dontcache(VFS_I(handle_ip));
> > +		xfs_irele(handle_ip);
> 
> This still feels the wrong way around vs just using IGET_UNCACHED?
> 
> Or did I miss the killer argument why that can't work?

No, I missed the killer argument.  In fact, I think the fsdax
reorganization into d_mark_dontcache makes this counterproductive.

Initially, I had thought that we'd be doing users a favor by only
marking inodes dontcache at the end of a scrub operation, and only if
there's only one reference to that inode.  This was more or less true
back when I_DONTCACHE was an XFS iflag and the only thing it did was
change the outcome of xfs_fs_drop_inode to 1.  If there are dentries
pointing to the inode when scrub finishes, the inode will have positive
i_count and stay around in cache until dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

So I think I want to change xchk_irele to clear I_DONTCACHE if we're in
transaction context or if corruption was found; and to use
XFS_IGET_DONTCACHE instead of the i_count-based d_mark_dontcache calls.

--D
