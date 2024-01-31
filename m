Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B253739FD7
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 22:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706739063; cv=none; b=NY7tJmeiJHHBDUkJVqZM1LCilo3fv/qsjQ/uepE6csnzE31UBo7rBuYS3AA7ipnTS4M4sqoMw0HezElKSn4pa3hkkV7T8dH7Kle2QOYutq0xo0+VgpHiUuRx4vksR+IJE0jdB4p2ykH+ZLJXCcNRzGJ6QhCF7H1+8zHiPQWsjzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706739063; c=relaxed/simple;
	bh=/ggiGyEx/LMJuz8jpizM8BQHT/Pnq3/9i9Kt2EN92/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK++C2pINdqPNv7nzBlIhaYm6+l+xl1zY2F6LgNnNXN47YM+t1b37VD5MspZKpFuSUpYWxbRWU/7n9zi+VIlSfucZvndaLIHwb9aWha9r0nr3BsyFH4FKZV/v/NE3pfverOEYy+7I4DXEcjxbkfnAQHqCy5fI7UP5QUhfTD3qdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwmJv29m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwmJv29m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C954C43390;
	Wed, 31 Jan 2024 22:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706739063;
	bh=/ggiGyEx/LMJuz8jpizM8BQHT/Pnq3/9i9Kt2EN92/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YwmJv29mOmPR/4QEv6oBxhOLBLVSCKsUIn2Y57C8MRITXymiLEdbxjTTVCb5vgLus
	 QxBHmUw6H7hNYxWwp4kZBnViJ/9KTl1Btk0mJ55wn9NUIh0Le6ltigrdvylOZGU49W
	 5hJ2Z97C3PiZcOC8XtJq2i1XI/PAnBOyVY+zS03QK/RXQBHZANopv2BH538SjvOaf6
	 b58KxTB2s5qLnqwO5PixbACmmQn4XHGYRGAGl3fwDcAjXnHygZFEc6iPt0rzJm9bUb
	 hippKeYizQptc7rm9k9GBhmiElOUD/y50WfWOGWZr6JI+L3uRT+iSRjW0L5ZZVamLR
	 wHBTA0upmi/3Q==
Date: Wed, 31 Jan 2024 14:11:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: disable sparse inode chunk alignment check when
 there is no alignment
Message-ID: <20240131221102.GA616564@frogsfrogsfrogs>
References: <20240131194714.GO1371843@frogsfrogsfrogs>
 <ZbqzmZs++8RVHk0U@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbqzmZs++8RVHk0U@dread.disaster.area>

On Thu, Feb 01, 2024 at 07:54:49AM +1100, Dave Chinner wrote:
> On Wed, Jan 31, 2024 at 11:47:14AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > While testing a 64k-blocksize filesystem, I noticed that xfs/709 fails
> > to rebuild the inode btree with a bunch of "Corruption remains"
> > messages.  It turns out that when the inode chunk size is smaller than a
> > single filesystem block, no block alignments constraints are necessary
> > for inode chunk allocations, and sb_spino_align is zero.  Hence we can
> > skip the check.
> 
> Should sparse inodes even be enabled by mkfs in this case?

Probably not, it's totally useless for inopblock <= 64.

> Regardless, if sb_spino_align = 0 then xfs_ialloc_setup_geometry()
> does:
> 
> 	igeo->ialloc_min_blks = igeo->ialloc_blks;
> 
> And this turns off sparse inode allocation for this situation....
> 
> > Fixes: dbfbf3bdf639 ("xfs: repair inode btrees")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/ialloc_repair.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
> > index b3f7182dd2f5d..e94f108000825 100644
> > --- a/fs/xfs/scrub/ialloc_repair.c
> > +++ b/fs/xfs/scrub/ialloc_repair.c
> > @@ -369,7 +369,7 @@ xrep_ibt_check_inode_ext(
> >  	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
> >  	 * Sparse clusters must be aligned to sparse chunk alignment.
> >  	 */
> > -	if (xfs_has_sparseinodes(mp) &&
> > +	if (xfs_has_sparseinodes(mp) && mp->m_sb.sb_spino_align &&
> >  	    (!IS_ALIGNED(agbno, mp->m_sb.sb_spino_align) ||
> >  	     !IS_ALIGNED(agbno + len, mp->m_sb.sb_spino_align)))
> >  		return -EFSCORRUPTED;
> 
> ... which makes this additional check reasonable.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks!

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
