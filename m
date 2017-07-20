Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48976 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933515AbdGTUUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2017 16:20:44 -0400
Date: Thu, 20 Jul 2017 13:20:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: consolidate local format inode fork verifiers
Message-ID: <20170720202037.GV4224@magnolia>
References: <20170719160318.GP4224@magnolia>
 <20170720115143.GA3944@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720115143.GA3944@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 20, 2017 at 07:51:46AM -0400, Brian Foster wrote:
> On Wed, Jul 19, 2017 at 09:03:18AM -0700, Darrick J. Wong wrote:
> > Create a centralized function to verify local format inode forks, then
> > migrate the existing short format directory verifier to use this
> > framework and add verifiers for the other two things we support (attrs
> > and symlinks).
> > 
> > Obviously this will get broken up into smaller pieces (one patch to
> > refactor/move the existing verifier calls, another one to add the two
> > new verifiers), but what do people think?
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> I haven't combed through the details of the verifiers, but just a few
> very quick thoughts..
> 
> >  fs/xfs/libxfs/xfs_attr_leaf.c      |   70 ++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.h      |    1 +
> >  fs/xfs/libxfs/xfs_inode_fork.c     |   10 -----
> >  fs/xfs/libxfs/xfs_shared.h         |    1 +
> >  fs/xfs/libxfs/xfs_symlink_remote.c |   29 +++++++++++++++
> >  fs/xfs/xfs_icache.c                |   46 ++++++++++++++++++++++++
> >  fs/xfs/xfs_icache.h                |    1 +
> >  fs/xfs/xfs_inode.c                 |    6 +--
> >  8 files changed, 150 insertions(+), 14 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 0e80f34..5484211 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -183,16 +183,6 @@ xfs_iformat_fork(
> >  	if (error)
> >  		return error;
> >  
> > -	/* Check inline dir contents. */
> > -	if (S_ISDIR(VFS_I(ip)->i_mode) &&
> > -	    dip->di_format == XFS_DINODE_FMT_LOCAL) {
> > -		error = xfs_dir2_sf_verify(ip);
> > -		if (error) {
> > -			xfs_idestroy_fork(ip, XFS_DATA_FORK);
> > -			return error;
> > -		}
> > -	}
> > -
> 
> What's the purpose of moving this? Just to accommodate userspace?

Yes, it's part of letting repair supply its own ifork verifiers so that
phase 6 can libxfs_iget to inspect and correct shortform directories.

> As it is, it looks like this leaves a coverage gap in a log recovery
> case where xfs_iget() is not used (xfs_recover_inode_owner_change()).

Ugh, I didn't even notice that.

As it stands today, xfs_recover_inode_owner_change also won't notice
corrupt attr forks or inline symlinks.  Seeing as we're (theoretically)
only changing the owner fields in v5 bmbt tree blocks this might not
have any practical consequence.  At that point we've already replayed
everything else in that inode that was dirty and are about to write
things out to disk, so everything has to be correct.

> Also, I think this is best split up into two or three smaller patches.
> E.g., one to move/rename the existing mechanism (with justification as
> to why), one or more to add the additional verifiers for the other
> formats.

(I mentioned that I'd do that before sending a real series...)

> >  	if (xfs_is_reflink_inode(ip)) {
> >  		ASSERT(ip->i_cowfp == NULL);
> >  		xfs_ifork_init_cow(ip);
> ...
> > diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> > index c484877..96e2957 100644
> > --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> > +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> > @@ -207,3 +207,32 @@ xfs_symlink_local_to_remote(
> >  	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
> >  					ifp->if_bytes - 1);
> >  }
> > +
> > +/* Verify the consistency of an inline symlink. */
> > +int
> > +xfs_symlink_sf_verify(
> > +	struct xfs_inode	*ip)
> > +{
> > +	char			*sfp;
> > +	char			*endp;
> > +	struct xfs_ifork	*ifp;
> > +	int			size;
> > +
> > +	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	sfp = (char *)ifp->if_u1.if_data;
> > +	size = ifp->if_bytes;
> > +	endp = sfp + size;
> > +
> > +	/* No negative sizes or overly long symlink targets. */
> > +	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
> > +		return -EFSCORRUPTED;
> > +
> > +	/* No NULLs in the target either. */
> > +	for (; sfp < endp; sfp++) {
> > +		if (*sfp == 0)
> > +			return -EFSCORRUPTED;
> > +	}
> 
> 	memchr() ?

<nod> Will do.  I should also check the padding fields too...

--D

> Brian
> 
> > +
> > +	return 0;
> > +}
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 0a9e698..fd1d430 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -34,6 +34,11 @@
> >  #include "xfs_dquot_item.h"
> >  #include "xfs_dquot.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_dir2_priv.h"
> > +#include "xfs_attr_leaf.h"
> > +#include "xfs_shared.h"
> >  
> >  #include <linux/kthread.h>
> >  #include <linux/freezer.h>
> > @@ -449,6 +454,43 @@ xfs_iget_cache_hit(
> >  	return error;
> >  }
> >  
> > +/* Check inline fork contents. */
> > +int
> > +xfs_iget_verify_forks(
> > +	struct xfs_inode		*ip)
> > +{
> > +	int				error;
> > +
> > +	/* Check the attribute fork if there is one. */
> > +	if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK) &&
> > +	    ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > +		error = xfs_attr_shortform_verify(ip);
> > +		if (error) {
> > +			xfs_alert(ip->i_mount,
> > +					"%s: bad inode %Lu inline attr fork",
> > +					__func__, ip->i_ino);
> > +			return error;
> > +		}
> > +	}
> > +
> > +	/* Non-local data fork, jump out. */
> > +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > +		return 0;
> > +
> > +	/* Check the inline data fork if there is one. */
> > +	if (S_ISDIR(VFS_I(ip)->i_mode))
> > +		error = xfs_dir2_sf_verify(ip);
> > +	else if (S_ISLNK(VFS_I(ip)->i_mode))
> > +		error = xfs_symlink_sf_verify(ip);
> > +	else
> > +		error = -EFSCORRUPTED;
> > +
> > +	if (error)
> > +		xfs_alert(ip->i_mount, "%s: bad inode %Lu inline data fork",
> > +				__func__, ip->i_ino);
> > +	return error;
> > +}
> > +
> >  
> >  static int
> >  xfs_iget_cache_miss(
> > @@ -473,6 +515,10 @@ xfs_iget_cache_miss(
> >  	if (error)
> >  		goto out_destroy;
> >  
> > +	error = xfs_iget_verify_forks(ip);
> > +	if (error)
> > +		goto out_destroy;
> > +
> >  	trace_xfs_iget_miss(ip);
> >  
> >  	if ((VFS_I(ip)->i_mode == 0) && !(flags & XFS_IGET_CREATE)) {
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index bff4d85..abf1cff 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -129,5 +129,6 @@ xfs_fs_eofblocks_from_user(
> >  
> >  int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> >  				  xfs_ino_t ino, bool *inuse);
> > +int xfs_iget_verify_forks(struct xfs_inode *ip);
> >  
> >  #endif
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index ceef77c..7ca8336 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3547,10 +3547,8 @@ xfs_iflush_int(
> >  	if (ip->i_d.di_version < 3)
> >  		ip->i_d.di_flushiter++;
> >  
> > -	/* Check the inline directory data. */
> > -	if (S_ISDIR(VFS_I(ip)->i_mode) &&
> > -	    ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
> > -	    xfs_dir2_sf_verify(ip))
> > +	/* Check the inline fork data. */
> > +	if (xfs_iget_verify_forks(ip))
> >  		goto corrupt_out;
> >  
> >  	/*
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
