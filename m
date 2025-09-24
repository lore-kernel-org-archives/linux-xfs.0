Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D11228980A
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 21:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750734; cv=none; b=n3i5pgA1AVrc/Ks65CxIC1Rl8IHJXqJsBGpr99TDd/AYlAlRGLioz6EmIlMKFU16s/6ZkaSXPORUI/qNWTkB0ArrugbpnynIwWMq+XU0NqtPn+4LnFIJZYsgzdQUUcogLEpZ9RO6nv7zhB8h8Uy6DWm31ANb86K0FGgZcmnqqnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750734; c=relaxed/simple;
	bh=WghDEzWnL1rFqX/AdI+GykB0kU2lXe9BXvfqOVS5a0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+xaE9/GijJ9kP9fneG+eD8riYPRaPIpeQu0/R1CqJLjs9OFJ/qWbw+wYhsAYfZWLI3xOra0q8s1sR9QxUktI+HWz09w5wqarjPMWVh29ey9+JpH/GT2sJD1cxQJRy871sgL8ny5OdkNxeZ9/AYSGzJu0UqDkrJzILKmNONuXdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvQBqwAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvQBqwAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91663C4CEF8;
	Wed, 24 Sep 2025 21:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758750733;
	bh=WghDEzWnL1rFqX/AdI+GykB0kU2lXe9BXvfqOVS5a0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SvQBqwAsExoFuPiaxB1E6dc062kzxvcYIHRQ3V05ZcScwkwixvQ0ftHCktf9+fMOe
	 5yePB/B9fs5iMXbpl1TTp7GW34+5w2rhQ9ndCGIKX0f9c0FG+VoKQs7nEvb5OpQp56
	 TyPGq2X8joaABohfUTW0LbtwIi5AhL+zwaNJURYKV0cPUkbhMhlwDV7rCsqi2Ja7NA
	 gNaTOOjhrlJPNFcDKbL9Ixm1eep6SFQy2BkIgtQ90pWlRP1ZP4GqCA/ChU5M0uFo53
	 COxkXEcfJTs5jCXZW7zMaL1/1y4runzk1m0hTWewJmLtMt02+xs9lwpuJChzFKWjKx
	 4RVdHMV9Sv/lA==
Date: Wed, 24 Sep 2025 14:52:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] libfrog: pass mode to xfrog_file_setattr
Message-ID: <20250924215213.GX8096@frogsfrogsfrogs>
References: <20250923170857.GS8096@frogsfrogsfrogs>
 <20250923171027.GU8096@frogsfrogsfrogs>
 <zzigcp3ew5h2yyngalxt7dpahsl2z2zdhpqxytc36os7ou257i@2nbwj2qghase>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zzigcp3ew5h2yyngalxt7dpahsl2z2zdhpqxytc36os7ou257i@2nbwj2qghase>

On Wed, Sep 24, 2025 at 03:18:15PM +0200, Andrey Albershteyn wrote:
> On 2025-09-23 10:10:27, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs/633 crashes rdump_fileattrs_path passes a NULL struct stat pointer
> > and then the fallback code dereferences it to get the file mode.
> 
> Oh is it latest xfsprogs with older kernel (without file_[g]etattr)?
> 
> (I see this on 6.16)

Yes, the crash happens on 6.16-rc7 where there is no file_setattr call,
and does not happen on for-next where file_setattr does exist.

> > Instead, let's just pass the stat mode directly to it, because that's
> > the only piece of information that it needs.
> > 
> > Fixes: 128ac4dadbd633 ("xfs_db: use file_setattr to copy attributes on special files with rdump")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  libfrog/file_attr.h |    9 ++-------
> >  db/rdump.c          |    4 ++--
> >  io/attr.c           |    4 ++--
> >  libfrog/file_attr.c |    4 ++--
> >  quota/project.c     |    6 ++++--
> >  5 files changed, 12 insertions(+), 15 deletions(-)
> > 
> > diff --git a/libfrog/file_attr.h b/libfrog/file_attr.h
> > index df9b6181d52cf9..2a1c0d42d0a771 100644
> > --- a/libfrog/file_attr.h
> > +++ b/libfrog/file_attr.h
> > @@ -24,12 +24,7 @@ xfrog_file_getattr(
> >  	struct file_attr	*fa,
> >  	const unsigned int	at_flags);
> >  
> > -int
> > -xfrog_file_setattr(
> > -	const int		dfd,
> > -	const char		*path,
> > -	const struct stat	*stat,
> > -	struct file_attr	*fa,
> > -	const unsigned int	at_flags);
> > +int xfrog_file_setattr(const int dfd, const char *path, const mode_t mode,
> > +		struct file_attr *fa, const unsigned int at_flags);
> 
> Is this formatting change intentional? (maybe then the
> xfrog_file_getattr also)

Yes, compressed is the usual style for function declarations.
It's only the definition that gets the expanded format.

(I didn't hassle you about it when you submitted the original patch
because I'm trying to stop doing that to people ;))

> otherwise lgtm
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks!

--D

> >  
> >  #endif /* __LIBFROG_FILE_ATTR_H__ */
> > diff --git a/db/rdump.c b/db/rdump.c
> > index 84ca3156d60598..26f9babad62be1 100644
> > --- a/db/rdump.c
> > +++ b/db/rdump.c
> > @@ -188,8 +188,8 @@ rdump_fileattrs_path(
> >  			return 1;
> >  	}
> >  
> > -	ret = xfrog_file_setattr(destdir->fd, pbuf->path, NULL, &fa,
> > -			AT_SYMLINK_NOFOLLOW);
> > +	ret = xfrog_file_setattr(destdir->fd, pbuf->path, VFS_I(ip)->i_mode,
> > +			&fa, AT_SYMLINK_NOFOLLOW);
> >  	if (ret) {
> >  		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
> >  			lost_mask |= LOST_FSXATTR;
> > diff --git a/io/attr.c b/io/attr.c
> > index 022ca5f1df1b7c..9563ff74e44777 100644
> > --- a/io/attr.c
> > +++ b/io/attr.c
> > @@ -261,7 +261,7 @@ chattr_callback(
> >  
> >  	attr.fa_xflags |= orflags;
> >  	attr.fa_xflags &= ~andflags;
> > -	error = xfrog_file_setattr(AT_FDCWD, path, stat, &attr,
> > +	error = xfrog_file_setattr(AT_FDCWD, path, stat->st_mode, &attr,
> >  				   AT_SYMLINK_NOFOLLOW);
> >  	if (error) {
> >  		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > @@ -357,7 +357,7 @@ chattr_f(
> >  
> >  	attr.fa_xflags |= orflags;
> >  	attr.fa_xflags &= ~andflags;
> > -	error = xfrog_file_setattr(AT_FDCWD, name, &st, &attr,
> > +	error = xfrog_file_setattr(AT_FDCWD, name, st.st_mode, &attr,
> >  				   AT_SYMLINK_NOFOLLOW);
> >  	if (error) {
> >  		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
> > diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> > index bb51ac6eb2ef95..c2cbcb4e14659c 100644
> > --- a/libfrog/file_attr.c
> > +++ b/libfrog/file_attr.c
> > @@ -85,7 +85,7 @@ int
> >  xfrog_file_setattr(
> >  	const int		dfd,
> >  	const char		*path,
> > -	const struct stat	*stat,
> > +	const mode_t		mode,
> >  	struct file_attr	*fa,
> >  	const unsigned int	at_flags)
> >  {
> > @@ -103,7 +103,7 @@ xfrog_file_setattr(
> >  		return error;
> >  #endif
> >  
> > -	if (SPECIAL_FILE(stat->st_mode)) {
> > +	if (SPECIAL_FILE(mode)) {
> >  		errno = EOPNOTSUPP;
> >  		return -1;
> >  	}
> > diff --git a/quota/project.c b/quota/project.c
> > index 5832e1474e2549..33449e01ef4dbb 100644
> > --- a/quota/project.c
> > +++ b/quota/project.c
> > @@ -157,7 +157,8 @@ clear_project(
> >  	fa.fa_projid = 0;
> >  	fa.fa_xflags &= ~FS_XFLAG_PROJINHERIT;
> >  
> > -	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
> > +			AT_SYMLINK_NOFOLLOW);
> >  	if (error) {
> >  		fprintf(stderr, _("%s: cannot clear project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > @@ -205,7 +206,8 @@ setup_project(
> >  	if (S_ISDIR(stat->st_mode))
> >  		fa.fa_xflags |= FS_XFLAG_PROJINHERIT;
> >  
> > -	error = xfrog_file_setattr(dfd, path, stat, &fa, AT_SYMLINK_NOFOLLOW);
> > +	error = xfrog_file_setattr(dfd, path, stat->st_mode, &fa,
> > +			AT_SYMLINK_NOFOLLOW);
> >  	if (error) {
> >  		fprintf(stderr, _("%s: cannot set project on %s: %s\n"),
> >  			progname, path, strerror(errno));
> > 
> 
> -- 
> - Andrey
> 
> 
