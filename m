Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33382 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYSXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 13:23:38 -0500
Date: Thu, 25 Jan 2018 10:23:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/11] xfs: refactor inode verifier corruption error
 printing
Message-ID: <20180125182333.GI9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676034665.12349.14442218679852748423.stgit@magnolia>
 <20180125173139.GE44175@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125173139.GE44175@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 12:31:40PM -0500, Brian Foster wrote:
> On Tue, Jan 23, 2018 at 06:19:06PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor inode verifier error reporting into a non-libxfs function so
> > that we aren't encoding the message format in libxfs.  This also
> > changes the kernel dmesg output to resemble buffer verifier errors
> > more closely.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c |    6 ++----
> >  fs/xfs/xfs_error.c            |   37 +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_error.h            |    3 +++
> >  fs/xfs/xfs_inode.c            |   14 ++++++++------
> >  4 files changed, 50 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 6e9dcdb..6d05ba6 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -578,10 +578,8 @@ xfs_iread(
> >  	/* even unallocated inodes are verified */
> >  	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> >  	if (fa) {
> > -		xfs_alert(mp, "%s: validation failed for inode %lld at %pS",
> > -				__func__, ip->i_ino, fa);
> > -
> > -		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "record", dip,
> > +				sizeof(*dip), fa);
> 
> What does "record" mean? "dinode" perhaps? Otherwise looks fine:

Sure, 'dinode' works.  Ultimately this comes out as:

"Metadata corruption detected at xfs_fubar+0x0, inode 0x8008 record"

but I guess

"Metadata corruption detected at xfs_fubar+0x0, inode 0x8008 dinode"

works just as well.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thank you for reviewing this series!

--D

> 
> >  		error = -EFSCORRUPTED;
> >  		goto out_brelse;
> >  	}
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index 980d5f0..ccf520f 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -24,6 +24,7 @@
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_sysfs.h"
> > +#include "xfs_inode.h"
> >  
> >  #ifdef DEBUG
> >  
> > @@ -372,3 +373,39 @@ xfs_verifier_error(
> >  	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> >  		xfs_stack_trace();
> >  }
> > +
> > +/*
> > + * Warnings for inode corruption problems.  Don't bother with the stack
> > + * trace unless the error level is turned up high.
> > + */
> > +void
> > +xfs_inode_verifier_error(
> > +	struct xfs_inode	*ip,
> > +	int			error,
> > +	const char		*name,
> > +	void			*buf,
> > +	size_t			bufsz,
> > +	xfs_failaddr_t		failaddr)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_failaddr_t		fa;
> > +	int			sz;
> > +
> > +	fa = failaddr ? failaddr : __return_address;
> > +
> > +	xfs_alert(mp, "Metadata %s detected at %pS, inode 0x%llx %s",
> > +		  error == -EFSBADCRC ? "CRC error" : "corruption",
> > +		  fa, ip->i_ino, name);
> > +
> > +	xfs_alert(mp, "Unmount and run xfs_repair");
> > +
> > +	if (buf && xfs_error_level >= XFS_ERRLEVEL_LOW) {
> > +		sz = min_t(size_t, XFS_CORRUPTION_DUMP_LEN, bufsz);
> > +		xfs_alert(mp, "First %d bytes of corrupted metadata buffer:",
> > +				sz);
> > +		xfs_hex_dump(buf, sz);
> > +	}
> > +
> > +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> > +		xfs_stack_trace();
> > +}
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index a3ba05b..7e728c5 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -28,6 +28,9 @@ extern void xfs_corruption_error(const char *tag, int level,
> >  			int linenum, xfs_failaddr_t failaddr);
> >  extern void xfs_verifier_error(struct xfs_buf *bp, int error,
> >  			xfs_failaddr_t failaddr);
> > +extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> > +			const char *name, void *buf, size_t bufsz,
> > +			xfs_failaddr_t failaddr);
> >  
> >  #define	XFS_ERROR_REPORT(e, lvl, mp)	\
> >  	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index fc118dd..c60efec 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3502,21 +3502,23 @@ bool
> >  xfs_inode_verify_forks(
> >  	struct xfs_inode	*ip)
> >  {
> > +	struct xfs_ifork	*ifp;
> >  	xfs_failaddr_t		fa;
> >  
> >  	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
> >  	if (fa) {
> > -		xfs_alert(ip->i_mount,
> > -				"%s: bad inode %llu inline data fork at %pS",
> > -				__func__, ip->i_ino, fa);
> > +		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> > +				ifp->if_u1.if_data, ifp->if_bytes, fa);
> >  		return false;
> >  	}
> >  
> >  	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
> >  	if (fa) {
> > -		xfs_alert(ip->i_mount,
> > -				"%s: bad inode %llu inline attr fork at %pS",
> > -				__func__, ip->i_ino, fa);
> > +		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> > +				ifp ? ifp->if_u1.if_data : NULL,
> > +				ifp ? ifp->if_bytes : 0, fa);
> >  		return false;
> >  	}
> >  	return true;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
