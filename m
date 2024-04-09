Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58247158D8F
	for <linux-xfs@vger.kernel.org>; Tue,  9 Apr 2024 22:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712703216; cv=none; b=EMjiv+nX3HI9D1fJlqX4NyZXIvXqeD0OsNCuIbt/0Xb34VVjLrWJJvXuVEiRuxsahfw/8C6YUwmYBjpuevdtyM9I6gsi1wY01clvCxPiHGNi7d6goPHwx4nM3uMFHLAzJ0AwQv9fLHzyQSl7p1qZ6isT5B6c3SDqXHYbuUyvk18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712703216; c=relaxed/simple;
	bh=uPxblWno/5SqSFzTSB3rVJclR3IY9u1sNlJtcTmuBbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/PcBoS1D/wQ7twxdGJ/rCDWqaXS2RJQPM7vlPokv0wbEw04FWnfy8kEwomckMaYysE/ZRkk9Vbak+Y9mmyNOXxUTZ5V0O8ozm+jt8pVMCEeInUk3YQRX5LZrXOSSQR8ORr4PDPyqFWDfVIZPIgHsDMU8BHNsqSNmoGjZQ9kvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aewQCDRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aewQCDRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D754FC433C7;
	Tue,  9 Apr 2024 22:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712703215;
	bh=uPxblWno/5SqSFzTSB3rVJclR3IY9u1sNlJtcTmuBbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aewQCDReNlaANMJF0Lbky+hU5rSXKn1oyV3aHtXGS/fN5SPxW4yvHkaBmKaOCOYyo
	 CVAHyEn0R/vlx/KlxzO9DmuNbmqHc2Y0s7akEMburPM85D0zHGbLtjKTJIAI67l/EX
	 8jrQS0t0dAEKaTR2qR/uV+MVXCe8PDmYXU4NOLGQJ1lMPhzhyXr1Ok7+xSjXKnKsPU
	 xucsOO0oOLq0NL9FGtABU8HLZVG7C8nnjv62YP/mXAfxi0+0a/VgxEvLmfVpUvr6g5
	 /oxmgFCwVXRCj0h2dpAvp49DFkqR9eoJ8i/BiAX1e93XtClFTc9dE5jDRnFCaTpui4
	 JqZxF4OrHpVog==
Date: Tue, 9 Apr 2024 15:53:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
Message-ID: <20240409225335.GI6390@frogsfrogsfrogs>
References: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
 <171150379761.3216346.9053282853553134545.stgit@frogsfrogsfrogs>
 <ZhMle4U4mwUnqoNZ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhMle4U4mwUnqoNZ@dread.disaster.area>

On Mon, Apr 08, 2024 at 09:00:11AM +1000, Dave Chinner wrote:
> On Tue, Mar 26, 2024 at 06:51:00PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Only allow the addition of new log incompat features to the primary
> > superblock if the sysadmin provides explicit consent via a mount option
> > or if the process has administrative privileges.  This should prevent
> > surprises when trying to recover dirty logs on old kernels.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> As I said originally when this was proposed, the logic needs to
> default to allow log incompat features to be added rather than
> disallow.
> 
> Essentially, having the default as "not allowed" means in future
> every single XFS mount on every single system is going to have to
> add this mount option to allow new log format features to used.
> 
> This "default = disallow" means our regression test systems will not
> be exercising features based on this code without explicitly
> expanding every independent test configuration matrix by another
> dimension. This essentially means there will be almost no test
> coverage for these dynamic features..
> 
> So, yeah, I think this needs to default to "allow", not "disallow".

This is moot -- I changed exchangerange to use a permanent incompat
feature so that we can guarantee to users that if the xfs_info output
says it's enabled then it's 100% ready to go.  Hence I no longer care
what happens to log incompat bits and this patch no longer needs to
exist.

--D

> 
> > ---
> >  Documentation/admin-guide/xfs.rst |    7 +++++++
> >  fs/xfs/xfs_mount.c                |   26 ++++++++++++++++++++++++++
> >  fs/xfs/xfs_mount.h                |    3 +++
> >  fs/xfs/xfs_super.c                |   12 +++++++++++-
> >  4 files changed, 47 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> > index b67772cf36d6d..52acd95b2b754 100644
> > --- a/Documentation/admin-guide/xfs.rst
> > +++ b/Documentation/admin-guide/xfs.rst
> > @@ -21,6 +21,13 @@ Mount Options
> >  
> >  When mounting an XFS filesystem, the following options are accepted.
> >  
> > +  add_log_feat/noadd_log_feat
> > +        Permit unprivileged userspace to use functionality that requires
> > +        the addition of log incompat feature bits to the superblock.
> > +        The feature bits will be cleared during a clean unmount.
> > +        Old kernels cannot recover dirty logs if they do not recognize
> > +        all log incompat feature bits.
> > +
> >    allocsize=size
> >  	Sets the buffered I/O end-of-file preallocation size when
> >  	doing delayed allocation writeout (default size is 64KiB).
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index d37ba10f5fa33..a0b271758f910 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1281,6 +1281,27 @@ xfs_force_summary_recalc(
> >  	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> >  }
> >  
> > +/*
> > + * Allow the log feature upgrade only if the sysadmin permits it via mount
> > + * option; or the caller is the administrator.  If the @want_audit parameter
> > + * is true, then a denial due to insufficient privileges will be logged.
> > + */
> > +bool
> > +xfs_can_add_incompat_log_features(
> > +	struct xfs_mount	*mp,
> > +	bool			want_audit)
> > +{
> > +	/* Always allowed if the mount option is set */
> > +	if (mp->m_features & XFS_FEAT_ADD_LOG_FEAT)
> > +		return true;
> 
> Please define a __XFS_HAS_FEAT() macro for this feature bit and
> use xfs_has_log_features_enabled() wrapper for it.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
