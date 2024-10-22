Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352AD19C559;
	Tue, 22 Oct 2024 11:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595798; cv=none; b=tffdTRde11nSGi8CrrGsmHS4a6kwrqZTbw7NXjYtRp2BiZHuUgc6Q8SgPmHAAgQjNYFsJBDbWQBAZ7NnBTtU51GuOXR/5bfMDbL3nAHiWbhaTfhx79XeeedLpjkybjTmDIZk56Jx8PdYRBtfZTbIIcS+95td+3sMDvSKKNqID7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595798; c=relaxed/simple;
	bh=kiuJLXM00R2xjoCq2cO3SkKeY3DGvebHihn+W7XV2pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsRJIui09vGh/0tDX2dFZ9LVjjRtPv3m67sEj/UaPgrxjkRUglx5Agw0W/mAv7uqIU09ayrsveKj4bXzRVwFopIISrYjSksBOAhlS3Gbc2HKFdcEs7W+1SE1rUBflpl3zvN43LOdjIWrJuvZF5QBKNxxAshcbo0ZP+wmXA6BZ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZJxfEFs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZJxfEFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6469EC4CEE6;
	Tue, 22 Oct 2024 11:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729595797;
	bh=kiuJLXM00R2xjoCq2cO3SkKeY3DGvebHihn+W7XV2pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jZJxfEFspbSXxF2wh+pr5+Nxk1/qHnVTX43BSYN+uhQt2uHnRLhiqGGhiF5Lhe5PD
	 +v3TxXOfGvSlH0fjUxFGsMZv8YpUWJ2YuioRZhq+8l4c+WBHT70efkfHKUxoRORNOI
	 kNJO3/Sd3FUpEGmfERtcFvT9b/HHlqoZl614J2B8oVzGu7BV5PN5wb75C8vZpTlsap
	 ovwJoNlWfUTzqrFBVC3o4xJKXje9NEbzbGS5qSjze//Pi9F+kjFoTy+AVmuYQKJdD6
	 J3VtkGe0h+W/W7ho6PkHMbVlnkbr6aIgBe8PP8IH9/on+sFBDgPvu5ZxnFGzh30XhJ
	 bPitWxCl7ydfw==
Date: Tue, 22 Oct 2024 13:16:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 20/29] xfs: don't fail repairs on metadata files with no
 attr fork
Message-ID: <xr2px4yfwpi4cak4e5z4xnjyip6zblxi537v4x4r2ibssajuie@eeubheijryrj>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
 <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
 <2024101838-thickness-exposure-ec78@gregkh>
 <20241021172751.GA21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021172751.GA21853@frogsfrogsfrogs>

On Mon, Oct 21, 2024 at 10:27:51AM GMT, Darrick J. Wong wrote:
> On Fri, Oct 18, 2024 at 08:00:21AM +0200, Greg KH wrote:
> > On Thu, Oct 17, 2024 at 11:58:10AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Fix a minor bug where we fail repairs on metadata files that do not have
> > > attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.
> > > 
> > > Cc: <stable@vger.kernel.org> # v6.8
> > > Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/scrub/repair.c |    8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > Why is a bugfix / stable-tagged-patch, number 20 in a 29 patch series?
> > Why isn't it first, or better yet, on it's own if it is fixing a bug
> > that people want merged "soon"?
> 
> I have too many patches, and every time I try to get a set through the
> review process I end up having to write *more* patches to appease the
> reviewers, and fixes get lost.  Look at the copyrights on the other
> patches, I've been trying to get this upstreamed since 2018.
> 
> This particular bugfix got lost last month probably because I forgot to
> ping cem to take it for 6.12-rc1.  Thanks for pushing on this, Greg.
> 
> Hey Carlos, can you queue this one up for 6.12-rc5, please?

Sure, it's queued now in next-rc, I'm testing it and I hope to send it to
for-next today yet. It's the only patch for -rc5.

Cheers.
Carlos

> 
> --D
> 
> > thanks,
> > 
> > greg k-h
> > 
> 
