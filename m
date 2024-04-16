Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580DF137C34
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293530; cv=none; b=tQmLN0zM7il5cFSt9FzaVZHIP6utQuZIyo/pdVfZaXBLKkpHEl2F5NHp0QQukOtmIopF/iPDKtQWw9bM7WPwEB+cUSWyQ4v2+i0SkowVd3d1w+0CFU7ZO1X51iBVfN8BCpio1akuQpPoxPXYhhZxkiKq68tW0Jlq3yN1WNdNSSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293530; c=relaxed/simple;
	bh=3VlXRPZWCowt5BzU15NIVSi1UB3P7nMXCpviQ48LLq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCJ4Y8ovBVh6Gkfr2U3Gj/rKFRjiyrlIJ8ku7jLxJMJAjBcZpBfPUiSV3QPwlMgB9ExoF/ymEPF7V16jTQIm05+o8WDZuQI3fxOaCDLM9Omtl1xzVJ2Rsj3KNzQtYT/+inWmSqlfHFLRRd8BUBp46oUlJrake89uv4IHm/nq9LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPofxlrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPofxlrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B8FC113CE;
	Tue, 16 Apr 2024 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713293529;
	bh=3VlXRPZWCowt5BzU15NIVSi1UB3P7nMXCpviQ48LLq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IPofxlrE/7uOKCwpme36L4icDz0h3L58rw5WmbtVmslEzYMt1ldfpiH019VzchhK0
	 B7EychEBdBvsHpZf0PQUnN5KBTvoc+uILyPDQ3PhzJxbvQ8LuCqwbJReCt+oV/C5n/
	 D7d0a6WuYgmALg6tSCw+6VQGSPy6Ddfe7t4rjwJBO1nmZ0Z/ULkcrxyhkcM5YIkjyW
	 wWNnTvT8HCSZhAZWPT2TELGFf5GyxprZoGOaZHUF8y+6bKHGqYS80gO0jKPbwm/sCo
	 C5P2dq+yVq72cQhZZ6BERecExhsFgmieJgKM+GxE24UEpXjG2Kgl6PaNXtyFs6xb9h
	 H2JhkOijgVF5g==
Date: Tue, 16 Apr 2024 11:52:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240416185209.GZ11948@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270970008.3631889.8274576756376203769.stgit@frogsfrogsfrogs>
 <20240412173957.GB11948@frogsfrogsfrogs>
 <20240414051816.GA1323@lst.de>
 <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh6tNvXga6bGwOSg@infradead.org>

On Tue, Apr 16, 2024 at 09:54:14AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 09:50:56AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 16, 2024 at 06:47:16AM +0200, Christoph Hellwig wrote:
> > > On Mon, Apr 15, 2024 at 12:40:36PM -0700, Darrick J. Wong wrote:
> > > > True, libhandle is a very nice wrapper for the kernel ioctls.  I wish
> > > > Linux projects did that more often.  But suppose you're calling the
> > > > ioctls directly without libhandle and mess it up?
> > > 
> > > The you get different inodes back.  Not really any different from
> > > pointing your path name based code to the wrong fs or directory,
> > > is it?
> > 
> > I suppose not.  But why bother setting the fsid at all, then?
> 
> I suspect that's a leftover from IRIX where the by handle operations
> weren't ioctls tied to a specific file system.

Oh, so on Irix a program could call the kernel with *only* the handle
and no fd?  I wasn't aware of that, but most of my exposure to Irix was
wowwwing over the 3D File Explorer in _Jurassic Park_ and later an old
Indigo that someone donated to the high school. ;)

Ok, I'll drop the fsid checking code entirely.

> > > But as we never generate the file handles that encode the parent
> > > we already never connect files to their parent directory anyway.
> > 
> > I pondered whether or not we should encode parent info in a regular
> > file's handle.
> 
> We shouldn't.  It's a really a NFS thing.
> 
> 
> > Would that result in an invalid handle if the file gets
> > moved to another directory?
> 
> Yes.
> 
> > That doesn't seem to fit with the behavior
> > that fds remain attached to the file even if it gets moved/deleted.
> 
> Exactly.

<nod>

> > 
> > > OTOH we should be able to optimize ->get_parent a bit with parent
> > > pointers, as we can find the name in the parent directory for
> > > a directory instead of doing linear scans in the parent directory.
> > > (for non-directory files we currenty don't fully connect anwyay)
> > 
> > <nod> But does exportfs actually want parent info for a nondirectory?
> > There aren't any stubs or XXX/FIXME comments, and I've never heard any
> > calls (at least on fsdevel) for that functionality.
> 
> It doesn't.  It would avoid having disconnected dentries, but
> disconnected non-directory dentries aren't really a problem.

For directories, I think the dotdot lookup is much cheaper than scanning
the attrs to find the first nongarbage XFS_ATTR_PARENT entry.

--D
