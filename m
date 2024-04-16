Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203238120A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 22:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307880; cv=none; b=eyFXnB+iE1kczzTt40ODytPS0Cr9geNuZc1sEmI+sgUOrTlYSuV0VqZU3EJvBGO94vx2HMDWXri8qOgvnTRqfYHmN0c2KfYRDYXnfqD7Iz/lG0l+3WXYx8kq00byUlxYw7jKdp/SH61sIOKLm2Op1LFk2taSNSSh5UlX9S3laWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307880; c=relaxed/simple;
	bh=66GNvMyjwkIuP8JLjvkmX322TSYgr95BzS8gOWYjKCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+wNn/zvh1hKCzF3m3EiRolHG2WzqQyEm8PKDXp9P07LKqtm/Egz4dE2py9PC536w1ieuJQAacN+yaJVdoW12DVWlVExV0pY8x2bMynM5XfXkpVht3ZmwOnBHTuaNW1b0RUnQ72Uw9tBiC7tn7mCiErU4yh79rPFz+Dc3KRlEsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE1Iep1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE1Iep1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC83C113CE;
	Tue, 16 Apr 2024 22:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713307879;
	bh=66GNvMyjwkIuP8JLjvkmX322TSYgr95BzS8gOWYjKCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PE1Iep1gBXmzcXzchMiNq4p+N9Ez10EnfVPa+8yol68rQwaZ86lswo0bS5HD4x0by
	 hBjPhgqOy4y6J+SG19TbxJoe7FUFm5WnUSsGUtaeJ+qVZheoME6q04Lp9DO73G/tmx
	 lNfaib6rPeTGZPqTnSWbxR89A5rFWzqo+YfvC/mLsoOYmHG9eFFIWZ0qu2ebiU+HbV
	 TAxTMDN44SKjvzdCDKhatoaBpjNFAWEgd4d04l+hwMoncAFc9MGDe9dtbU3syMUhtR
	 TDA5568+0lAzxpiiPWgtY57+9VbGR7/BdfFEaDOmm4E0fmcY+RxucjUqTsBo7foSvv
	 Tzcwt9ZftSCiQ==
Date: Tue, 16 Apr 2024 15:51:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240416225118.GI11948@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030309.253873.8649027644659300452.stgit@frogsfrogsfrogs>
 <Zh4OHi8GI-0v60qB@infradead.org>
 <20240416223148.GH11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416223148.GH11948@frogsfrogsfrogs>

On Tue, Apr 16, 2024 at 03:31:48PM -0700, Darrick J. Wong wrote:
> On Mon, Apr 15, 2024 at 10:35:26PM -0700, Christoph Hellwig wrote:
> > >  out_free:
> > > +	/*
> > > +	 * If we're holding the only reference to an inode opened via handle,
> > > +	 * mark it dontcache so that we don't pollute the cache.
> > > +	 */
> > > +	if (handle_ip) {
> > > +		if (atomic_read(&VFS_I(handle_ip)->i_count) == 1)
> > > +			d_mark_dontcache(VFS_I(handle_ip));
> > > +		xfs_irele(handle_ip);
> > 
> > This still feels the wrong way around vs just using IGET_UNCACHED?
> > 
> > Or did I miss the killer argument why that can't work?
> 
> No, I missed the killer argument.  In fact, I think the fsdax
> reorganization into d_mark_dontcache makes this counterproductive.
> 
> Initially, I had thought that we'd be doing users a favor by only
> marking inodes dontcache at the end of a scrub operation, and only if
> there's only one reference to that inode.  This was more or less true
> back when I_DONTCACHE was an XFS iflag and the only thing it did was
> change the outcome of xfs_fs_drop_inode to 1.  If there are dentries
> pointing to the inode when scrub finishes, the inode will have positive
> i_count and stay around in cache until dentry reclaim.
> 
> But now we have d_mark_dontcache, which cause the inode *and* the
> dentries attached to it all to be marked I_DONTCACHE, which means that
> we drop the dentries ASAP, which drops the inode ASAP.
> 
> This is bad if scrub found problems with the inode, because now they can
> be scheduled for inactivation, which can cause inodegc to trip on it and
> shut down the filesystem.
> 
> Even if the inode isn't bad, this is still suboptimal because phases 3-7
> each initiate inode scans.  Dropping the inode immediately during phase
> 3 is silly because phase 5 will reload it and drop it immediately, etc.
> It's fine to mark the inodes dontcache, but if there have been accesses
> to the file that set up dentries, we should keep them.
> 
> I validated this by setting up ftrace to capture xfs_iget_recycle*
> tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
> saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
> and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
> 30 seconds.
> 
> So I think I want to change xchk_irele to clear I_DONTCACHE if we're in
> transaction context or if corruption was found; and to use
> XFS_IGET_DONTCACHE instead of the i_count-based d_mark_dontcache calls.

Actually we don't even need to clear DONTCACHE on sick inodes; commit
7975e465af6b4 ("xfs: drop IDONTCACHE on inodes when we mark them sick")
already took care of that.

--D

> --D
> 
