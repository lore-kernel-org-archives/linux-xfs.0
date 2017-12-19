Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdLSUuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:50:07 -0500
Date: Tue, 19 Dec 2017 12:50:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/13] xfs: provide a centralized method for verifying
 inline fork data
Message-ID: <20171219205004.GE12613@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320955376.30654.3972078644450529725.stgit@magnolia>
 <20171219060640.GT4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219060640.GT4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 05:06:40PM +1100, Dave Chinner wrote:
> On Wed, Dec 13, 2017 at 03:59:13PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace the current haphazard dir2 shortform verifier callsites with a
> > centralized verifier function that can be called either with the default
> > verifier functions or with a custom set.  This helps us strengthen
> > integrity checking while providing us with flexibility for repair tools.
> > 
> > xfs_repair wants this to be able to supply its own verifier functions
> > when trying to fix possibly corrupt metadata.
> 
> I was about to say "this looks a little over-engineered" then I read
> the commit message.... :P
> 
> Ok, so it pulls the fork verication out of the libxfs inode read code,
> and instead slots it into the kernel inode cache miss path just
> after the inode has been read. Same effect - newly read inodes get
> their forks verified before use. ANd they same thing happens in
> xfs_iflush_int(), which is private to the kernel anyway....

<nod> It's a little over-engineered for the kernel; the real point of
all this is to check local format forks by default while enabling
xfs_repair to skip those checks if, say, it wants to fix an inode with
broken xattrs by zapping the attr fork.

> > +
> > +/* Default fork content verifiers. */
> > +struct xfs_ifork_ops xfs_default_ifork_ops = {
> > +	.verify_attr	= xfs_attr_shortform_verify,
> > +	.verify_dir	= xfs_dir2_sf_verify,
> > +	.verify_symlink	= xfs_symlink_shortform_verify,
> > +};
> > +
> > +/* Verify the inline contents of the data fork of an inode. */
> > +xfs_failaddr_t
> > +xfs_ifork_verify_data(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_ifork_ops	*ops)
> > +{
> > +	xfs_ifork_verifier_t	fn = NULL;
> > +
> > +	/* Non-local data fork, we're done. */
> > +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > +		return NULL;
> > +
> > +	/* Check the inline data fork if there is one. */
> > +	if (S_ISDIR(VFS_I(ip)->i_mode))
> > +		fn = ops->verify_dir;
> > +	else if (S_ISLNK(VFS_I(ip)->i_mode))
> > +		fn = ops->verify_symlink;
> > +
> > +	if (fn)
> > +		return fn(ip);
> > +	return NULL;
> > +}
> 
> Seems a little convoluted, especially if we grow more cases. This
> seems simpler already:
> 
> 	switch(VFS_I(ip)->i_mode & S_IFMT) {
> 	case S_IFDIR:
> 		return ops->verify_dir(ip);
> 	case S_IFLNK:
> 		return ops->verify_symlink(ip);
> 	default:
> 		break;
> 	}
> 	return NULL;

Fixed.

> > +
> > +/* Verify the inline contents of the attr fork of an inode. */
> > +xfs_failaddr_t
> > +xfs_ifork_verify_attr(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_ifork_ops	*ops)
> > +{
> > +	xfs_ifork_verifier_t	fn = NULL;
> > +
> > +	/* There has to be an attr fork allocated if aformat is local. */
> > +	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > +		if (XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> > +			fn = ops->verify_attr;
> > +		else
> > +			return __this_address;
> > +	}
> > +
> > +	if (fn)
> > +		return fn(ip);
> > +	return NULL;
> 
> And this could be stright lined as:
> 
> 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
> 		return NULL;
> 	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> 		return __this_address;
> 
> 	return ops->verify_attr(ip);

Fixed.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
