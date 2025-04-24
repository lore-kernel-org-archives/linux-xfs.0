Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7031F4C9F
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 22:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745532044; cv=none; b=SflBDKXITxi0nUW1V45Xe5GK0s/Xnn2FvA5z/SxGK3L9Q/NSjdPpank8RlQQThopIXK2lX+DLX9W6vzwr0Fvlva/b8sxnBeuvbSoudMHGiiNUBGezcRmvqeURchq+YFB7FavMwkGeElsHg5IFGfloUDwxzfYDNYa5YE6Qrm/kxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745532044; c=relaxed/simple;
	bh=erpxHYWudnFHjjLDEzw+Of1sypy0u7AddmLxd1IKWD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVvMZ9s1zi2XeNSCnlUbgyqK6M0JbyBvYGWuA7Yvbwqed7wzR5UpTa1et7uETzSRe571FX22t9R3BuadJ79W3jZhgotAc9EVy36FeOgpAlBo1kwYsc57qwzb+MeJ3/RNjSOO6Kx5wyPBjIo+1YmzU8j0d4OGdUFqCnhhahxFBLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9xC3p1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9xC3p1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD4DC4CEE3;
	Thu, 24 Apr 2025 22:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745532041;
	bh=erpxHYWudnFHjjLDEzw+Of1sypy0u7AddmLxd1IKWD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H9xC3p1/HCcahXZhfCg43UCdGycVqT+brcfi5Q2QfKaodP4/Eu1twifS6N4aZYsSE
	 7F0jv3Wd9hNKdyDa4AR4CY7KgNIBbxKMNBCictZu7Ab/Wo3nSGcKD/dMJulMl6yFW1
	 QGWLaWIST3C95upKZHLFfpxRqwhAFeXoEht6e7Q6rvVKOQb4JbxUjku1hj4wA21hlg
	 BsU3Km+imMCRZ69J3oC7WKVPs/GjhfMatpAiGLrEfa+ugv3OFAedQP7GPhEMM7lKmG
	 dgxD2NYOro++lbyn71dfVfgcEwlkei6LtzL3bjlVydPCGR1UafsdztsxgT6nWZydGG
	 Yo5shO5UN1Sog==
Date: Thu, 24 Apr 2025 15:00:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <20250424220041.GK25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
 <20250423202358.GI25675@frogsfrogsfrogs>
 <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vmiujkqli3d4c7ohgegpxvwacowl2tdaps6m4wyvwh6dcfado7@csca7fs5y7ss>

On Thu, Apr 24, 2025 at 06:09:45PM +0200, Luca Di Maio wrote:
> On Wed, Apr 23, 2025 at 01:23:58PM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 23, 2025 at 06:03:17PM +0200, Luca Di Maio wrote:
> > > +static void fail(char *msg, int i)
> > > +{
> > > +   fprintf(stderr, _("%s: %s [%d - %s]\n"), progname, msg, i, strerror(i));
> > > +   exit(1);
> > > +}
> > > +
> > > +static int newregfile(char *fname)
> > > +{
> > > +   int fd;
> > > +   off_t size;
> > > +
> > > +   if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> > > +           fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, fname,
> > > +                   strerror(errno));
> > > +           exit(1);
> > > +   }
> > > +
> > > +   return fd;
> > > +}
> >
> > Why is this copy-pasting code from proto.c?  Put the new functions
> > there, and then you don't need all this externing.
> >
> 
> Right, this is because with a separate flag I thought it would have been
> better to keep it in a separate file.

Common functionality goes together in a C module, regardless of how it
gets called.

> With the new behaviour you proposed in the previous mail (one -p flag,
> check if file/directory) then I can unify back into proto.c, thus
> removing all the exported functions changes.

<nod>

> > > +
> > > +static void writetimestamps(struct xfs_inode *ip, struct stat statbuf)
> > > +{
> > > +   struct timespec64 ts;
> > > +
> > > +   /*
> > > +    * Copy timestamps from source file to destination inode.
> > > +    *  In order to not be influenced by our own access timestamp,
> > > +    *  we set atime and ctime to mtime of the source file.
> > > +    *  Usually reproducible archives will delete or not register
> > > +    *  atime and ctime, for example:
> > > +    *     https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
> > > +    */
> > > +   ts.tv_sec = statbuf.st_mtime;
> > > +   ts.tv_nsec = statbuf.st_mtim.tv_nsec;
> > > +   inode_set_atime_to_ts(VFS_I(ip), ts);
> > > +   inode_set_ctime_to_ts(VFS_I(ip), ts);
> > > +   inode_set_mtime_to_ts(VFS_I(ip), ts);
> >
> > This seems weird to me that you'd set [ac]time to mtime.  Why not open
> > the source file O_ATIME and copy atime?  And why would copying ctime not
> > result in a reproducible build?
> >
> > Not sure what you do about crtime.
> >
> 
> The problem stems from the extraction of the artifact. Usually
> reproducible archives will remove [ac]time and only keep mtime, but in
> the moment that a file is extracted, any filesystem will assign [ac]time
> to the moment of extraction.
> This will add randomness not to the filesystem itself, because it will
> be reproducible if acting on the same extracted archive, but it will not
> be reproducible if acting on a new extraction of the same archive.
> 
> Another approach we can do is what mkfs.ext4's populate functionality is
> doing: while it preserves mtime, [cr,a,c]time is set to whatever time the
> mkfs command is running.
> 
> This would make it preserve the important timestamp (mtime) and move the
> "problem" of the reproducible/changing timestamp to the environment,
> while keeping the behaviour of mkfs.xfs sensible
> 
> What do you think?

The thing is, if you were relying on atime/mtime for detection of "file
data changed since last read" then /not/ copying atime into the
filesystem breaks that property in the image.

How about copying [acm]time from the source file by default, but then
add a new -p noatime option to skip the atime?

ctime/crtime should be the current time when mkfs command is running.
I assume that you have a gettimeofday type wrapper that makes it always
return the same value?

> > > +   /*
> > > +    * copy over file content, attributes and
> > > +    * timestamps
> > > +    */
> > > +   if (fd != 0) {
> > > +           writefile(ip, fname, fd);
> > > +           writeattrs(ip, fname, fd);
> >
> > Since we're adding features, should this read the fsxattr info from the
> > source file, override it with the set fields in *fsxp, and set that on
> > the file?  If you're going to slurp up a directory, you might as well
> > get all the non-xattr file attributes.
> >
> 
> Right, I thought creatproto() did that, but now I see that this is done
> only for the root inode, I'll add this for others too, thanks.

Right.

> > > +           libxfs_parent_finish(mp, ppargs);
> > > +           tp = NULL;
> >
> > Shouldn't this copy xattrs and fsxattrs to directories and symlinks too?
> >
> 
> Right, will add, thanks.

<nod>

> > > +/*
> > > + * walk_dir will recursively list files and directories
> > > + * and populate the mountpoint *mp with them using handle_direntry().
> > > + */
> > > +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> > > +                       struct fsxattr *fsxp, char *cur_path)
> > > +{
> > > +   DIR *dir;
> > > +   struct dirent *entry;
> > > +
> > > +   /*
> > > +    * open input directory and iterate over all entries in it.
> > > +    * when another directory is found, we will recursively call
> > > +    * populatefromdir.
> > > +    */
> > > +   if ((dir = opendir(cur_path)) == NULL)
> > > +           fail(_("cannot open input dir"), 1);
> > > +   while ((entry = readdir(dir)) != NULL) {
> > > +           handle_direntry(mp, pip, fsxp, cur_path, entry);
> > > +   }
> > > +   closedir(dir);
> > > +}
> >
> > nftw() ?  Which has the nice feature of constraining the number of open
> > dirs at any given time.
> >
> > --D
> >
> 
> The problem with nftw() is that working with callback functions, we will
> need to switch to static variables for state, for example to keep track
> of each ip's pip, while with the recursive approach we can have some
> state and basically walk_dir() behaves similar to parseproto(), making
> changes to the rest of the file minimal.
> This seems to involve a lot more changes than now where we're basically
> just adding a limited number of functions to proto.c.

Eck, ok.  Never mind then.  I guess we could try to bump RLIMIT_NOFILE
in that case to avoid EMFILE.

--D

> Thanks again for the review Darrick,
> I'll wait for your feedback on the walk_dir() vs nftw() and the [ac]time
> approach,
> thanks
> 
> L.
> 
