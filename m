Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4E14AD1D;
	Tue,  2 Apr 2024 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712075277; cv=none; b=KpxewCDzeA6eJDaYmRjM1/Hu+G4l2OP73+f8NPe18IDMAzKr0YiY0htsuAHy1Fmawi+RMxqK+eP/FaGMdeeXQULY/bDMmgH0Dbjgd3K3n62h+4gIcGdx/xAA2FW2BvLCHnBOvoGnxVNFyGEwx+Hmm3Lrg7JALkZqXV+tWvqbG5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712075277; c=relaxed/simple;
	bh=aRHI4wAbaX7Ee5gGh6gDFF5VzVgwgx6oiFPOHqdDEsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxgRsu3Z44W+Giyio+24DJ9BmEkR53XCZI+tKjSqTGQFZ1ack4aBM+Z4RXtSaOEolrGpc0JBBC3gFiuSfYGfETsK4V9wBRZoFTZYUnO2Bnm3FxSzuf8ZSuAEQcyNXlc9eeMqhGGqD6CvJdRlhqTNyRodqkfp2FySkILFWVncBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+NjzIBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+NjzIBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E38AC433F1;
	Tue,  2 Apr 2024 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712075277;
	bh=aRHI4wAbaX7Ee5gGh6gDFF5VzVgwgx6oiFPOHqdDEsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q+NjzIBkbIKfcERBfLVSDw3Ox/Lv4oQlVrtykB1jb43FtQU5j497DuTDkD3aCeNGC
	 qJS3xn2Db27AdXn2+CXpUHuXwB+BbI4eKPfixhZwgt7RCycXZLYyLqRcKc1nHt5vrW
	 5gY394tP/UJwgdEuNJE64SEIi/qi2nJVOOVYMBWlqVIN5pb6UK4DotmflDYoZRHe/q
	 f3SEB6NItqxE5dyIdDrk1z6ecw4nST1eT5RNWz0O2b0HQb6syKN8jh24fKfcUhROoz
	 JjuOWM3JqhVQ73DZZHKuBSLBvqeX4HRyHZG8sqwifEnOlVjTRPvjan6Y3JybcH9Wmk
	 +HaUYUUlB7e4A==
Date: Tue, 2 Apr 2024 09:27:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 12/29] xfs: widen flags argument to the xfs_iflags_*
 helpers
Message-ID: <20240402162756.GA6390@frogsfrogsfrogs>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868758.1988170.13958676356498248164.stgit@frogsfrogsfrogs>
 <vhk2g3qvkf224oklr57pmdnrjh6odshv62ciqguxcsgbrbplt5@3msropqnuqfa>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vhk2g3qvkf224oklr57pmdnrjh6odshv62ciqguxcsgbrbplt5@3msropqnuqfa>

On Tue, Apr 02, 2024 at 02:37:50PM +0200, Andrey Albershteyn wrote:
> On 2024-03-29 17:39:11, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_inode.i_flags is an unsigned long, so make these helpers take that
> > as the flags argument instead of unsigned short.  This is needed for the
> > next patch.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_inode.h |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > 
> 
> Would it also make sense to flip iflags to unsigned long in
> xfs_iget_cache_miss()?

I think it could pass XFS_INEW directly to xfs_iflags_set and skip the
iflags local variable completely.  IIRC it /was/ used to set dontcache
back when that was an xfs-specific flag.

> Looks good to me:
> Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

Thanks!

--D

> -- 
> - Andrey
> 
> 
