Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35957 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752615AbdIRRW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 13:22:57 -0400
Date: Mon, 18 Sep 2017 10:22:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
Message-ID: <20170918172251.GE6540@magnolia>
References: <20170901164035.GF3775@magnolia>
 <20170904174535.GI4671@magnolia>
 <0da45d14-7c4a-9cb9-4c0c-6abc309c5001@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0da45d14-7c4a-9cb9-4c0c-6abc309c5001@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Sep 08, 2017 at 01:02:15PM -0500, Eric Sandeen wrote:
> On 9/4/17 12:45 PM, Darrick J. Wong wrote:
> > Create a -d option to mkfs.xfs that enables administrators to set
> > the CoW extent size hint on the created files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: port flags2diflags from the kernel
> 
> hm, I wonder if we need a libxfs/util.c in the kernel for stuff like
> this so libxfs diff will keep such things in sync in the future.
> 
> a project for another day I guess.  One question below.
> 
> > ---
> >  libxfs/util.c       |   64 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  man/man8/mkfs.xfs.8 |    7 ++++++
> >  mkfs/xfs_mkfs.c     |   20 ++++++++++++++++
> >  3 files changed, 89 insertions(+), 2 deletions(-)
> > 
> > diff --git a/libxfs/util.c b/libxfs/util.c
> > index 0e2f29e..b600594 100644
> > --- a/libxfs/util.c
> > +++ b/libxfs/util.c
> > @@ -175,6 +175,64 @@ libxfs_trans_ichgtime(
> >  	}
> >  }
> >  
> > +STATIC uint16_t
> > +xfs_flags2diflags(
> > +	struct xfs_inode	*ip,
> > +	unsigned int		xflags)
> > +{
> > +	/* can't set PREALLOC this way, just preserve it */
> > +	uint16_t		di_flags =
> > +		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> > +
> > +	if (xflags & FS_XFLAG_IMMUTABLE)
> > +		di_flags |= XFS_DIFLAG_IMMUTABLE;
> > +	if (xflags & FS_XFLAG_APPEND)
> > +		di_flags |= XFS_DIFLAG_APPEND;
> > +	if (xflags & FS_XFLAG_SYNC)
> > +		di_flags |= XFS_DIFLAG_SYNC;
> > +	if (xflags & FS_XFLAG_NOATIME)
> > +		di_flags |= XFS_DIFLAG_NOATIME;
> > +	if (xflags & FS_XFLAG_NODUMP)
> > +		di_flags |= XFS_DIFLAG_NODUMP;
> > +	if (xflags & FS_XFLAG_NODEFRAG)
> > +		di_flags |= XFS_DIFLAG_NODEFRAG;
> > +	if (xflags & FS_XFLAG_FILESTREAM)
> > +		di_flags |= XFS_DIFLAG_FILESTREAM;
> > +	if (S_ISDIR(VFS_I(ip)->i_mode)) {
> > +		if (xflags & FS_XFLAG_RTINHERIT)
> > +			di_flags |= XFS_DIFLAG_RTINHERIT;
> > +		if (xflags & FS_XFLAG_NOSYMLINKS)
> > +			di_flags |= XFS_DIFLAG_NOSYMLINKS;
> > +		if (xflags & FS_XFLAG_EXTSZINHERIT)
> > +			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> > +		if (xflags & FS_XFLAG_PROJINHERIT)
> > +			di_flags |= XFS_DIFLAG_PROJINHERIT;
> > +	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
> > +		if (xflags & FS_XFLAG_REALTIME)
> > +			di_flags |= XFS_DIFLAG_REALTIME;
> > +		if (xflags & FS_XFLAG_EXTSIZE)
> > +			di_flags |= XFS_DIFLAG_EXTSIZE;
> > +	}
> > +
> > +	return di_flags;
> > +}
> > +
> > +STATIC uint64_t
> > +xfs_flags2diflags2(
> > +	struct xfs_inode	*ip,
> > +	unsigned int		xflags)
> > +{
> > +	uint64_t		di_flags2 =
> > +		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> > +
> > +	if (xflags & FS_XFLAG_DAX)
> > +		di_flags2 |= XFS_DIFLAG2_DAX;
> > +	if (xflags & FS_XFLAG_COWEXTSIZE)
> > +		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> > +
> > +	return di_flags2;
> > +}
> > +
> >  /*
> >   * Allocate an inode on disk and return a copy of its in-core version.
> >   * Set mode, nlink, and rdev appropriately within the inode.
> > @@ -254,15 +312,17 @@ libxfs_ialloc(
> >  	ip->i_d.di_extsize = pip ? 0 : fsx->fsx_extsize;
> >  	ip->i_d.di_dmevmask = 0;
> >  	ip->i_d.di_dmstate = 0;
> > -	ip->i_d.di_flags = pip ? 0 : fsx->fsx_xflags;
> > +	ip->i_d.di_flags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
> 
> is this a bugfix?

No.

Prior to this patch, the only fsx_xflags bits that mkfs could set are
the ones that correspond exactly to di_flags bits, so it was fine to set
them directly.  Subtle and annoying, but it worked.

However, the xfs_mkfs.c changes enable us to set FS_XFLAG_COWEXTSIZE,
which doesn't correspond to a di_flags bit, so now we need translation
functions to return the correct di_flags/di_flags2 values for the given
fsx_xflags.

(Granted you could argue that COWEXTSIZE is bit 17 so it'll just get
truncated when we set di_flags and therefore it's not absolutely
necessary to have a translation function for di_flags but that's
sloppy.)

--D

> The rest seems ok, just wondering if the above should be hidden in here -
> at least a mention of the change in the changelog seems needed, but most
> likely thjis is a separate change, no?  Or am I missing something?
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
