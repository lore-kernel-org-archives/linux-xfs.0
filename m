Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6882AE95
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943455; cv=none; b=BSOx9VXj5GNo9+si8FYuUiYks19+yRM6BoF1YnrmyTMrekZrJyf+KfA+OgVkwQZmq+jkGj6TL/qFvYfARhob90BG3wmCk0zmKQ5qRE8OLDwxD7n22S0vz78wTmG4lmJbXHxM+aiflTb24271w6NDdUrOhRWV0aUfpkPfYmMRtBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943455; c=relaxed/simple;
	bh=j3JEcT63W/maGUFhaL6CgtoOn/W7Y0exl5/ysq+cfjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4zxUrsBYqXwx1EYusX0N0c2XdYyvlR/909ySNagL2V+5uQ+7aLmm6gKPpZ+kpa3hmMCau52qnFwuolhS1+1ArPbVKMRhOpsnW5e2wEqvrppwWr174Zh/aWCUdOujL+H5qsKyvv2+y1iDK5J4eGOlkvLjJnTVCLo9w3IQfaOWBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtlT1IIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtlT1IIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D6AC4CED1;
	Wed, 19 Feb 2025 05:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739943454;
	bh=j3JEcT63W/maGUFhaL6CgtoOn/W7Y0exl5/ysq+cfjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtlT1IIwYegkYIJ44yrk2CQfeUAar/q+5BMbZxtiaonO1MeKzhWjNG84MEyE6abMx
	 hclib6VB8AjRhc4rmSVCzpRmzRlnPG3+/asD1KHjUjywV0iBNlhmwXhyLjVXpUltYf
	 A8fA+jy8Na8Q6umG45ZwM8PS1GH6MCr/ViqcKwJAMET0Lc3MZo8uS4k0wio78S0+dG
	 a8XYn9VI3CNCw6MzCjsIUUNhqwFUsUpvxVxwbiPGZHlkgdPu5R3CK8yVRs7bpy75r8
	 I7j+oJL2S2vgwUlkk1W9o+wBIwzn6sTucV1XjWNWRxbGaem9wHMmVoZ6eIMOlcfMIx
	 QMGFCs6Gqye9g==
Date: Tue, 18 Feb 2025 21:37:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove most in-flight buffer accounting
Message-ID: <20250219053733.GN21808@frogsfrogsfrogs>
References: <20250217093207.3769550-1-hch@lst.de>
 <20250217093207.3769550-4-hch@lst.de>
 <20250218202327.GI21808@frogsfrogsfrogs>
 <20250219053527.GC10173@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219053527.GC10173@lst.de>

On Wed, Feb 19, 2025 at 06:35:27AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 18, 2025 at 12:23:27PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 17, 2025 at 10:31:28AM +0100, Christoph Hellwig wrote:
> > > The buffer cache keeps a bt_io_count per-CPU counter to track all
> > > in-flight I/O, which is used to ensure no I/O is in flight when
> > > unmounting the file system.
> > > 
> > > For most I/O we already keep track of inflight I/O at higher levels:
> > > 
> > >  - for synchronous I/O (xfs_buf_read/xfs_bwrite/xfs_buf_delwri_submit),
> > >    the caller has a reference and waits for I/O completions using
> > >    xfs_buf_iowait
> > >  - for xfs_buf_delwri_submit the only caller (AIL writeback) tracks the
> > 
> > Do you mean xfs_buf_delwri_submit_nowait here?
> 
> Yes.
> 
> > IOWs, only asynchronous readahead needs an explicit counter in the
> > xfs_buf to prevent unmount because:
> > 
> > 0. Anything done in mount/unmount/freeze holds s_umount
> > 1. Buffer reads done on behalf of a file hold the file open and pin the
> >    mount
> > 2. Dirty buffers have log items, and we can't unmount until those are
> >    dealt with
> > 3. Fsck holds an open fd and hence pins the mount
> > 4. Unmount blocks until background gc finishes
> > 
> > Right?
> 
> Yes.
> 
> > I almost wonder if you could just have a percpu counter in the
> > xfs_mount but that sounds pretty hot.
> 
> Well, that would remove the nice xfs_buftarg_wait() abstraction.
> Givne that we don't even allocate an extra buftrag unless we use
> it that doesn't seem very useful.

Heheh.  Anyway, the changes look good to me so with that cleared up
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

> > > +	/* there are currently no valid flags for xfs_buf_get_uncached */
> > > +	ASSERT(flags == 0);
> > 
> > Can we just get rid of flags then?  AFAICT nobody uses it either here or
> > in xfsprogs, and in fact I think there's a nasty bug in the userspace
> > rtsb code:
> 
> See my reply to the last patch: I actually have a patch to remove it,
> but it conflicts with the zoned series.  So for now I'll defer it until
> that is merged.

<nod>

--D
