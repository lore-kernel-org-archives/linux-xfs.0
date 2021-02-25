Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687FAC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 405CE64F1B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhBYUfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:35:25 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60627 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234614AbhBYUdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 15:33:09 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 891284EC6DC;
        Fri, 26 Feb 2021 07:32:13 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFNIy-004E2e-M6; Fri, 26 Feb 2021 07:32:12 +1100
Date:   Fri, 26 Feb 2021 07:32:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: initialise attr fork on inode create
Message-ID: <20210225203212.GJ4662@dread.disaster.area>
References: <20210222230556.GR4662@dread.disaster.area>
 <20210225080900.GH2483198@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225080900.GH2483198@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=38zuZcw9i34eI8tdJnIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 08:09:00AM +0000, Christoph Hellwig wrote:
> This look really nice to me, but a few comments on the overall
> structure:
> 
> > +/*
> > + * Set an inode attr fork offset based on the format of the data fork.
> > + *
> > + * If a size of zero is passed in, then caller does not know the size of
> > + * the attribute that might be added (i.e. pre-emptive attr fork creation).
> > + * Hence in this case just set the fork offset to the default so that we don't
> > + * need to modify the supported attr format in the superblock.
> > + */
> >  int
> >  xfs_bmap_set_attrforkoff(
> >  	struct xfs_inode	*ip,
> > @@ -1041,6 +1048,11 @@ xfs_bmap_set_attrforkoff(
> >  	case XFS_DINODE_FMT_LOCAL:
> >  	case XFS_DINODE_FMT_EXTENTS:
> >  	case XFS_DINODE_FMT_BTREE:
> > +		if (size == 0) {
> > +			ASSERT(!version);
> > +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > +			break;
> > +		}
> >  		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
> >  		if (!ip->i_d.di_forkoff)
> >  			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> 
> I don't think cramming this special case into xfs_bmap_set_attrforkoff
> makes a whole lot of sense.  I'd rather just open code this logic into
> the caller like this:
> 
> 	if (init_xattrs) {
> 		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> 	}
> 
> which seems a whole lot simpler and much more obvious than the rather
> arcane calling conventions for this magic invocation of 
> xfs_bmap_set_attrforkoffxfs_bmap_set_attrforkoff.


AAARRRRGGGGGHHHHH!

That's exactly what I did with the first version and Brian and then
Darrick were both adamant that setting the attr fork had to be done
through xfs_bmap_set_attrforkoff() via formalising "size=0 means use
defaults".

I know, just doing it the way you suggest is simple, obvious and
straight forward and that's exactly the argument I made, but nobody
else wanted it that way.

> 
> > +struct xfs_ifork *
> > +xfs_ifork_alloc(
> > +	enum xfs_dinode_fmt	format,
> > +	xfs_extnum_t		nextents)
> > +{
> > +	struct xfs_ifork	*ifp;
> > +
> > +	ifp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
> > +	ifp->if_format = format;
> > +	ifp->if_nextents = nextents;
> > +	return ifp;
> > +}
> 
> Please split the addition of xfs_ifork_alloc and the conversion of the
> existing calles into a prep patch.
> 
> > -	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> > -		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> 
> This check is lost.  I think we're fine as we don't support such old
> file systems at all, but we should probably document this change (and
> maybe even split it into a separate prep patch).

I don't see any point in splitting it out into a separate patch.
It's dead code, so while I'm touching this exact piece of code. I'll
document it.

> >  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> >  
> >  int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 636ac13b1df2..95e3a5e6e5e2 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -773,6 +773,7 @@ xfs_init_new_inode(
> >  	xfs_nlink_t		nlink,
> >  	dev_t			rdev,
> >  	prid_t			prid,
> > +	bool			init_xattrs,
> >  	struct xfs_inode	**ipp)
> >  {
> >  	struct inode		*dir = pip ? VFS_I(pip) : NULL;
> 
> So instead of passing the parameter down a few levels I think we can
> just take the decision inside of xfs_init_new_inode with a simple check
> like:
> 
> 	if (pip && nlink > 0 && !S_ISLNK(mode) &&
> 	    xfs_create_need_xattr(dir, default_acl, acl)) {
> 	    	...
> 	}

We don't pass down the acl/default acl to this function. We have to
pass something down into here for it to do the right thing....

> 
> > +static inline bool
> > +xfs_create_need_xattr(
> > +	struct inode	*dir,
> > +	struct posix_acl *default_acl,
> > +	struct posix_acl *acl)
> > +{
> > +	if (acl)
> > +		return true;
> > +	if (default_acl)
> > +		return true;
> > +	if (!IS_ENABLED(CONFIG_SECURITY))
> > +		return false;
> > +	if (dir->i_sb->s_security)
> > +		return true;
> > +	return false;
> > +}
> 
> This isn't XFS-specific.  Please move it to fs.h and split it into another
> prep patch.

No. I'm not putting a special, targetted one-off
filesystem-implementation specific functions in fs.h even if it only
contain generic checks. There's already way too much crap in fs.h,
and this doesn't improve the situation. If you have need for it in
other filesystems, then pull it up out of the XFS code in that
patchset.

> Also this won't compile as-is as s_security only exists
> when CONFIG_SECURITY is defined, so the IS_ENABLED needs to be replaced
> with an ifdef.

I'll fix that.

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
