Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0606721B9E8
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739908191; cv=none; b=W1fDFkb32RUOWhGBXjC/lKiQt5/WZxLp+ZpFYi3vk/oOt9jt8hAwJ1OujK/t6bO9r3Iq34ROv7prt7iO+0bPzIhJijsI+2BwMb1F4j+Xf5bxVQ5x2C2ikLOTXH4OgA3jC1chHBOFdd495m2czEOM3M+V/KuuGDp9UvhtsAnKbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739908191; c=relaxed/simple;
	bh=/IMuvFmS6VxwFioYvxuxAi+i8naVUX1z6iKj3+j3E6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YlBYxLiEoHO918+QER21BDErpQv8SH2CvFCcG5aq1xJsOy3Jb57nzLIb7qpaKDJffnWfVFjSrNgZxMAV6oy1ZXKAiBHZc3TQACByagQKpa2P0lZVBV/GfvjJDEss+bgU+IV9bBqNJ7w8gvlb5O1HcVxFOV1IQ+Bxl6SBDDlfLOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyOD7WCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyOD7WCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7674BC4CEE2;
	Tue, 18 Feb 2025 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739908190;
	bh=/IMuvFmS6VxwFioYvxuxAi+i8naVUX1z6iKj3+j3E6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qyOD7WCGJ+p8+FBCKTMIhrJHU3CLwqi/tVnC15ibD+yUHixKilfpzof6RVWclBofh
	 dGGtGbSOxoT8TAS9mrOvV6iC9g2IzmqF/6fOXEYZO6cf9XImMJPBh+Um8v48qGtTI4
	 EaKA8zObEv90ztpz69nTMS/0KO/Ros9+e+KRhLhIUA6bVeegvwvqLWdNLL7KWzkoZI
	 xSqX2WraVPRYY+YCRQuhKAJnz1DjDwjM+Wky1KDhw//rW6L6SU0LviZziCfq3jBaez
	 AiHYlV7yYrPvKJZnkijvnUSKWggoOWl3GFO/Q9QMb0M/ddP6nO3YeOmKalfi/5MxoS
	 M/X3EHbloMzDQ==
Date: Tue, 18 Feb 2025 11:49:49 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
Message-ID: <20250218194949.GE21808@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
 <Z7RGkVLW13HPXAb-@infradead.org>
 <20250218155409.GQ3028674@frogsfrogsfrogs>
 <20250218180456.GC21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218180456.GC21808@frogsfrogsfrogs>

On Tue, Feb 18, 2025 at 10:04:56AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 18, 2025 at 07:54:09AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 18, 2025 at 12:36:33AM -0800, Christoph Hellwig wrote:
> > > On Thu, Feb 06, 2025 at 03:03:32PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Aheada of deprecating V4 support in the kernel, let's give people a way
> > > > to extract their files from a filesystem without needing to mount.
> > > 
> > > So I've wanted a userspace file access for a while, but if we deprecate
> > > the v4 support in the kernel that will propagte to libxfs quickly,
> > > and this code won't help you with v4 file systems either.  So I don't
> > > think the rationale here seems very good.
> > 
> > We aren't removing V4 support from the kernel until September 2030 and
> > xfsprogs effectively builds with CONFIG_XFS_SUPPORT_V4=y.  That should
> > be enough time, right?
> > 
> > > >  extern void		bmapinflate_init(void);
> > > > +extern void		rdump_init(void);
> > > 
> > > No need for the extern.
> > 
> > Ok.
> > 
> > > > +	/* XXX cannot copy fsxattrs */
> > > 
> > > Should this be fixed first?  Or document in a full sentence comment
> > > explaining why it can't should not be?
> > 
> > 	/* XXX cannot copy fsxattrs until setfsxattrat() syscall merge */
> > 
> > > > +		[1] = {
> > > > +			.tv_sec  = inode_get_mtime_sec(VFS_I(ip)),
> > > > +			.tv_nsec = inode_get_mtime_nsec(VFS_I(ip)),
> > > > +		},
> > > > +	};
> > > > +	int			ret;
> > > > +
> > > > +	/* XXX cannot copy ctime or btime */
> > > 
> > > Same for this and others.
> > 
> > Is there a way to set ctime or btime?  I don't know of any.
> 
> Now that I'm past all the morning meetings and have had time to research
> things a little more deeply/wake up more: no, there's no way to set the
> inode change or birth times.
> 
> > 	/* Cannot set ctime or btime */
> 
> So I'll go with ^^ this comment.
> 
> > > > +	/* Format xattr name */
> > > > +	if (attr_flags & XFS_ATTR_ROOT)
> > > > +		nsp = XATTR_TRUSTED_PREFIX;
> > > > +	else if (attr_flags & XFS_ATTR_SECURE)
> > > > +		nsp = XATTR_SECURITY_PREFIX;
> > > > +	else
> > > > +		nsp = XATTR_USER_PREFIX;
> > > 
> > > Add a self-cotained helper for this?  I'm pretty sure we do this
> > > translation in a few places.
> 
> Actually, xfsprogs doesn't:
> 
> $ git grep XATTR_SECURITY_PREFIX
> db/rdump.c:293:         nsp = XATTR_SECURITY_PREFIX;
> mkfs/proto.c:393:       } else if (!strncmp(attrname, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
> mkfs/proto.c:394:               args.name = (unsigned char *)attrname + XATTR_SECURITY_PREFIX_LEN;
> 
> The kernel gets a little closer in xfs_xattr.c:
> 
> $ git grep XATTR_SECURITY_PREFIX include/ fs/*.c fs/xfs/
> fs/xattr.c:128: if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) ||
> fs/xattr.c:228: int issec = !strncmp(name, XATTR_SECURITY_PREFIX,
> fs/xattr.c:229:                            XATTR_SECURITY_PREFIX_LEN);
> fs/xattr.c:249:                 const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
> fs/xattr.c:442: if (!strncmp(name, XATTR_SECURITY_PREFIX,
> fs/xattr.c:443:                         XATTR_SECURITY_PREFIX_LEN)) {
> fs/xattr.c:444:         const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
> fs/xfs/xfs_xattr.c:207: .prefix = XATTR_SECURITY_PREFIX,
> fs/xfs/xfs_xattr.c:304:         prefix = XATTR_SECURITY_PREFIX;
> fs/xfs/xfs_xattr.c:305:         prefix_len = XATTR_SECURITY_PREFIX_LEN;
> 
> But xfs_xattr_put_listent has some custom logic in it:
> 
> 	if (flags & XFS_ATTR_ROOT) {
> #ifdef CONFIG_XFS_POSIX_ACL
> 		if (namelen == SGI_ACL_FILE_SIZE &&
> 		    strncmp(name, SGI_ACL_FILE,
> 			    SGI_ACL_FILE_SIZE) == 0) {
> 			__xfs_xattr_put_listent(
> 					context, XATTR_SYSTEM_PREFIX,
> 					XATTR_SYSTEM_PREFIX_LEN,
> 					XATTR_POSIX_ACL_ACCESS,
> 					strlen(XATTR_POSIX_ACL_ACCESS));
> 		} else if (namelen == SGI_ACL_DEFAULT_SIZE &&
> 			 strncmp(name, SGI_ACL_DEFAULT,
> 				 SGI_ACL_DEFAULT_SIZE) == 0) {
> 			__xfs_xattr_put_listent(
> 					context, XATTR_SYSTEM_PREFIX,
> 					XATTR_SYSTEM_PREFIX_LEN,
> 					XATTR_POSIX_ACL_DEFAULT,
> 					strlen(XATTR_POSIX_ACL_DEFAULT));
> 		}
> #endif
> 
> 		/*
> 		 * Only show root namespace entries if we are actually allowed to
> 		 * see them.
> 		 */
> 		if (!capable(CAP_SYS_ADMIN))
> 			return;
> 
> 		prefix = XATTR_TRUSTED_PREFIX;
> 		prefix_len = XATTR_TRUSTED_PREFIX_LEN;
> 
> But I do see that rdump should translate SGI_ACL_FILE to
> XATTR_POSIX_ACL_ACCESS so I'll go do that.

...actually, no.  The SGI_ACL_{FILE,DEFAULT} xattrs can be copied
verbatim into another XFS filesystem and they continue to work
correctly.  Translating them into the generic
"system.posix_acl_{access,default}" xattrs requires the introduction of
libacl as a hard dependency because the exact format of the blob passed
around by setxattr/getxattr is private to libacl.

I think it's a bridge too far to have xfs_db depend on libacl for the
sake of non-XFS filesystems so I'll add a warning if we think we're
copying the ACL xattr to something that isn't an XFS filesystem.

--D

> --D
> 
> > Ok.  I think at least scrub phase5 does this.
> > 
> > > > +	if (XFS_IS_REALTIME_INODE(ip))
> > > > +		btp = ip->i_mount->m_rtdev_targp;
> > > > +	else
> > > > +		btp = ip->i_mount->m_ddev_targp;
> > > 
> > > Should be move xfs_inode_buftarg from kernel code to common code?
> > 
> > Hmm.  The xfs_inode -> xfs_buftarg translation could be moved to
> > libxfs/xfs_inode_util.c, yes.  Though that can't happen until 6.15
> > because we're well past the merge window.  For now I think it's the only
> > place in xfsprogs where we do that.
> > 
> > --D
> > 
> 
