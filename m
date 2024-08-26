Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C8D198830
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724693609; cv=none; b=NMWx0Ijrs4p/FFeIzxgGBxHKt9mO4RIwbi/XsFwyal06RdJSDrQ00wEDNhFOcoPfvRNKzl8HcWnwvh2sBc6zY6hso7Ewwo2aXnxK0sHQZxW3/JWt4krBI4so8v1YhwtxG3jLHip6AgEV1UrM8gV/LvuMshquelVai4DN8v6i9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724693609; c=relaxed/simple;
	bh=Kt1CDgj5DKZw7JMnA8qGbnIuoLA/02FkxMn/SQdifcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVFJuPMb6vvfyGujUgEh5+iblU1S6Ue5oDWQg3K8N5pCI+eC0py0q9qiUB281ttqhnLqiDN3Jdee6L8QnFWGboKLrE39+IfM8lYeVe7ns7VQuTEKq4kIqF7FdLAv+6ujwpimtNnLgLOfm6mLIYwErJanSweU+YVDosvP2VHN80E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tuQs30ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuQs30ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBD0C8B7A4;
	Mon, 26 Aug 2024 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724693609;
	bh=Kt1CDgj5DKZw7JMnA8qGbnIuoLA/02FkxMn/SQdifcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tuQs30hosf6+3KNwi/jvA7KMzmhdoYE/idAKl31LMQb0ieyzR0DqCqfpA6eqOUWZF
	 nc8/k62muHXZ+pffGfu1wJ3AyzSokV8l65lLwfgJi5vURBQtboxk/p7IBQh/8AEUzO
	 3YvfXmh441ezHD72NMAnsvYkc/r/PkdhwapD5tQEazbgkMFki9BP5Q3p5uZVJgneN5
	 oj4hDvUxDvnwQNPvF6qq4B8mj341DyNjAGJWg++VGXbBQgLW53aiCT1nUjUby4+RF4
	 IDnhkww4jOo+OYObUaE7X+jKS9R9hI5Bd3BF6DBa6k6Oirn6/wIPy0RN2EJbuCUkTE
	 e6B/7eeXbtVyA==
Date: Mon, 26 Aug 2024 10:33:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/26] xfs: hide metadata inodes from everyone because
 they are special
Message-ID: <20240826173328.GW865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085312.57482.9340127129544109933.stgit@frogsfrogsfrogs>
 <ZsvPLoxe9UEZZKuM@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvPLoxe9UEZZKuM@dread.disaster.area>

On Mon, Aug 26, 2024 at 10:41:18AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:04:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Metadata inodes are private files and therefore cannot be exposed to
> > userspace.  This means no bulkstat, no open-by-handle, no linking them
> > into the directory tree, and no feeding them to LSMs.  As such, we mark
> > them S_PRIVATE, which stops all that.
> 
> Can you merge this back up into the initial iget support code?
> 
> > 
> > While we're at it, put them in a separate lockdep class so that it won't
> > get confused by "recursive" i_rwsem locking such as what happens when we
> > write to a rt file and need to allocate from the rt bitmap file.  The
> > static function that we use to do this will be exported in the rtgroups
> > patchset.
> 
> Stale commit message? There's nothing of the sort in this patch....

Yeah, sorry.  Previously there were separate lockdep classes for metadir
directories and files each, but hch and I decided that each consumer of
a metadata file should set its own class accordingly, and that the
directories could continue using xfs_nondir_ilock_class as the only
code that uses them is either mount time setup code or repair.

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/tempfile.c |    8 ++++++++
> >  fs/xfs/xfs_iops.c       |   15 ++++++++++++++-
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
> > index 177f922acfaf1..3c5a1d77fefae 100644
> > --- a/fs/xfs/scrub/tempfile.c
> > +++ b/fs/xfs/scrub/tempfile.c
> > @@ -844,6 +844,14 @@ xrep_is_tempfile(
> >  	const struct xfs_inode	*ip)
> >  {
> >  	const struct inode	*inode = &ip->i_vnode;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +
> > +	/*
> > +	 * Files in the metadata directory tree also have S_PRIVATE set and
> > +	 * IOP_XATTR unset, so we must distinguish them separately.
> > +	 */
> > +	if (xfs_has_metadir(mp) && (ip->i_diflags2 & XFS_DIFLAG2_METADATA))
> > +		return false;
> 
> Why do you need to check both xfs_has_metadir() and the inode flag
> here? The latter should only be set if the former is set, yes?
> If it's the other way around, then we have an on-disk corruption...

Probably just stale code that's been sitting around for a while.
But yes, this could all be:

	if (xfs_is_metadir_inode(ip))
		return false;

since the inode verifier should have already caught this.

> >  	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
> >  		return true;
> 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 1cdc8034f54d9..c1686163299a0 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -42,7 +42,9 @@
> >   * held. For regular files, the lock order is the other way around - the
> >   * mmap_lock is taken during the page fault, and then we lock the ilock to do
> >   * block mapping. Hence we need a different class for the directory ilock so
> > - * that lockdep can tell them apart.
> > + * that lockdep can tell them apart.  Directories in the metadata directory
> > + * tree get a separate class so that lockdep reports will warn us if someone
> > + * ever tries to lock regular directories after locking metadata directories.
> >   */
> >  static struct lock_class_key xfs_nondir_ilock_class;
> >  static struct lock_class_key xfs_dir_ilock_class;
> > @@ -1299,6 +1301,7 @@ xfs_setup_inode(
> >  {
> >  	struct inode		*inode = &ip->i_vnode;
> >  	gfp_t			gfp_mask;
> > +	bool			is_meta = xfs_is_metadata_inode(ip);
> >  
> >  	inode->i_ino = ip->i_ino;
> >  	inode->i_state |= I_NEW;
> > @@ -1310,6 +1313,16 @@ xfs_setup_inode(
> >  	i_size_write(inode, ip->i_disk_size);
> >  	xfs_diflags_to_iflags(ip, true);
> >  
> > +	/*
> > +	 * Mark our metadata files as private so that LSMs and the ACL code
> > +	 * don't try to add their own metadata or reason about these files,
> > +	 * and users cannot ever obtain file handles to them.
> > +	 */
> > +	if (is_meta) {
> > +		inode->i_flags |= S_PRIVATE;
> > +		inode->i_opflags &= ~IOP_XATTR;
> > +	}
> 
> No need for a temporary variable here.

<nod>

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
