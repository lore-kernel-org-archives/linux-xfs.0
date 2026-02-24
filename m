Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E0925785D
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771933153; cv=none; b=KGeZfHBsSjzzJvT7Lwpl3ULI9iBwVPwAgTiEqv0qGgJuRBL5NPAhXJYA1tN5+2y0UBy6ESirq50lcxfvHCZO5y8srvJbTDhSF2uTljVcqERhJtaD3pyoauhTa++hBx89UaiqyNyPNMUu7S6nFAflbu+GCzV3aVdBBQeZpFoqdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771933153; c=relaxed/simple;
	bh=k06t8vpIFoukonS7TZhXZljzYk/vPeAB/hTGMYfQHYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRgjDWKr2w5edgN0ebS9mvLOeFSJfYBum4sP4n7phswboasmkOGqThh4aL6aUzH9nkzkVZGV2QwWemzzYk6Biq67+oFDf+fxeGlWqyBFrnH2DDIjvfQkLJtdpd9orU5DPzW7Gw+m9bUMOix4vSQKxGywdkXj5MSUBmiqzztsPMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUg1ONc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUg1ONc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE4CC19422;
	Tue, 24 Feb 2026 11:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771933153;
	bh=k06t8vpIFoukonS7TZhXZljzYk/vPeAB/hTGMYfQHYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUg1ONc+HO60bXioAk4GtzdQSKBcIkYUcrBjtG/dedFkhLijqLg63XCXDQYBn4MNY
	 VtUQ1oibI7qiE04radlIWR90YBGOabnnF55c48Q51HWgxZd1p9oikABQTG7YU4uSFt
	 eqZxVBQGIMvHrzrhZdW9MderZWhV4Y8Jd6kqSLJsxIIoKbzZuqBugyqeIM3KyO2xHT
	 PkEpZEC0642gdV3t8cQTh/QTJUml1309qjSGEg+xKDhqC9b8FRM+MV5Q6ojBKVpnrC
	 nLGiIuU6iW96Jus1WyNESET3G5hMLJsQuwSlpOqH3DPfF+8wAGWQjWPXaR2zdPc/5a
	 HXjjwuKAtReXg==
Date: Tue, 24 Feb 2026 12:39:08 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: samsun1006219@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't report half-built inodes to fserror
Message-ID: <aZ2NU4-LCIGOgjI9@nidhogg.toxiclabs.cc>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925538.401799.9155847221857034016.stgit@frogsfrogsfrogs>
 <aZcNva4Ur6WSqyDD@nidhogg.toxiclabs.cc>
 <20260219220223.GS6490@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219220223.GS6490@frogsfrogsfrogs>

On Thu, Feb 19, 2026 at 02:02:23PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 19, 2026 at 02:21:36PM +0100, Carlos Maiolino wrote:
> > On Wed, Feb 18, 2026 at 10:02:17PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Sam Sun apparently found a syzbot way to fuzz a filesystem such that
> > > xfs_iget_cache_miss would free the inode before the fserror code could
> > > catch up.  Frustratingly he doesn't use the syzbot dashboard so there's
> > > no C reproducer and not even a full error report, so I'm guessing that:
> > > 
> > > Inodes that are being constructed or torn down inside XFS are not
> > > visible to the VFS.  They should never be reported to fserror.
> > > Also, any inode that has been freshly allocated in _cache_miss should be
> > > marked INEW immediately because, well, it's an incompletely constructed
> > > inode that isn't yet visible to the VFS.
> > > 
> > > Reported-by: Sam Sun <samsun1006219@gmail.com>
> > > Fixes: 5eb4cb18e445d0 ("xfs: convey metadata health events to the health monitor")
> > > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > The change looks ok to me. Would be nice though if we can be sure this
> > fix the reporter's issue. Any idea if the reporter could reproduce it?
> 
> It sounds like syzbot found a reproducer for the reporter, but they will
> not integrate with Google's syzbot dashboard or stand up their own
> instance so I can't download it on my own; and they only posted a very
> large strace so someone would have to turn that into a C program.
> 
> This is rude behavior, and egregiously so when the reporter **has an
> automated fuzzer** that spat out a C program somewhere, but they won't
> share.

Agreed.

> 
> > Otherwise pointing this as a fix to a problem we can't be sure has
> > actually been fixed, sounds misleading at best.
> 
> I don't know what to do unless the reporter builds a patched kernel and
> tests it for us.

Chances are.... we never hear anything else again, but hopefully I'm
wrong :)

My suggestion would be to leave the Fixes tag off, to avoid stable
backports that "might not really fix" the problem, but this is a
suggestion only, I'm ok to have it anyway.

> 
> > For the fix itself though:
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Thanks for reviewing.
> 
> --D
> 
> > 
> > > ---
> > >  fs/xfs/xfs_health.c |    8 ++++++--
> > >  fs/xfs/xfs_icache.c |    9 ++++++++-
> > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> > > index 6475159eb9302c..239b843e83d42a 100644
> > > --- a/fs/xfs/xfs_health.c
> > > +++ b/fs/xfs/xfs_health.c
> > > @@ -316,8 +316,12 @@ xfs_rgno_mark_sick(
> > >  
> > >  static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
> > >  {
> > > -	/* Report metadata inodes as general filesystem corruption */
> > > -	if (xfs_is_internal_inode(ip)) {
> > > +	/*
> > > +	 * Do not report inodes being constructed or freed, or metadata inodes,
> > > +	 * to fsnotify.
> > > +	 */
> > > +	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIM) ||
> > > +	    xfs_is_internal_inode(ip)) {
> > >  		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
> > >  				GFP_NOFS);
> > >  		return;
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index dbaab4ae709f9c..f13e55b75d66c4 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -636,6 +636,14 @@ xfs_iget_cache_miss(
> > >  	if (!ip)
> > >  		return -ENOMEM;
> > >  
> > > +	/*
> > > +	 * Set XFS_INEW as early as possible so that the health code won't pass
> > > +	 * the inode to the fserror code if the ondisk inode cannot be loaded.
> > > +	 * We're going to free the xfs_inode immediately if that happens, which
> > > +	 * would lead to UAF problems.
> > > +	 */
> > > +	xfs_iflags_set(ip, XFS_INEW);
> > > +
> > >  	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
> > >  	if (error)
> > >  		goto out_destroy;
> > > @@ -713,7 +721,6 @@ xfs_iget_cache_miss(
> > >  	ip->i_udquot = NULL;
> > >  	ip->i_gdquot = NULL;
> > >  	ip->i_pdquot = NULL;
> > > -	xfs_iflags_set(ip, XFS_INEW);
> > >  
> > >  	/* insert the new inode */
> > >  	spin_lock(&pag->pag_ici_lock);
> > > 
> > > 
> > 
> 
