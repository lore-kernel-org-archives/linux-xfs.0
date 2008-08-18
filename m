Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Aug 2008 17:40:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I0etCa008582
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:40:55 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CF1FF5D24A
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:42:14 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 8a5A4dD2MeUxSKJk for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:42:14 -0700 (PDT)
Date: Mon, 18 Aug 2008 10:42:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/7] XFS: don't use vnodes where unnecessary
Message-ID: <20080818004209.GH19760@disturbed>
References: <1218698083-11226-1-git-send-email-david@fromorbit.com> <1218698083-11226-8-git-send-email-david@fromorbit.com> <20080814201022.GA20557@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814201022.GA20557@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 04:10:22PM -0400, Christoph Hellwig wrote:
> >  	do {
> > +		struct inode	*inode;
> > +		boolean_t	vnode_refed;
> > +		xfs_inode_t	*ip = NULL;
> 
> This should not be inode_refed, no? :)

Yeah ;)

> > -		vp = VFS_I(ip);
> > -		if (!vp) {
> > +		if (xfs_iflags_test(ip, (XFS_IRECLAIM|XFS_IRECLAIMABLE))) {
> 
> These changes really need to be folded into the previous patch for
> bisectability reasons..

Right - this was catching all this bits that I missed in the
previous patch ;)

> 
> > +		inode = VFS_I(ip);
> > +		if (VN_BAD(inode)) {
> 
> Just use is_bad_inode directly.  (Also in a few other places)

Will do.

> >  		} else {
> > -			/* safe to unlock here as we have a reference */
> > +			if (!xfs_ilock_nowait(ip, lock_flags)) {
> > +				/* leave it to reclaim */
> > +				read_unlock(&pag->pag_ici_lock);
> > +				continue;
> > +			}
> >  			read_unlock(&pag->pag_ici_lock);
> >  		}
> 
> Maybe not for this patch, but in general, why do we even bother about
> the inodes we can't get a reference to, shouldn't we just always leave
> this to reclaim?

Right now, we either get a reference or an ilock to prevent reclaim
from freeing it. The case ofthe vnode disappearing made it difficult
to make a clear delineation. With the combined inode, it is much
easier to make this distinction, but if we are doing ascending order
writeback of inodes, we really want to get all the inodes that are
dirty regardless of whether they are in reclaim or not.

> > -		if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
> > +		if ((flags & SYNC_DELWRI) && VN_DIRTY(VFS_I(ip))) {
> 
> Why not use the "inode" variable we have in scope anyway?

Yup, should do that.

> > +	if (!(inode->i_state & I_CLEAR))
> > +		return atomic_read(&inode->i_count);
> 
> Well, it's just zero when the inode is out of the vfs, so we could
> probably simply do it unconditional.

Ok, I'll have a look at that.

> 
> > +		vp = vn_grab(VFS_I(ip));
> > +		if (vp) {
> 
> Please switch this one to igrab, and the inode name, too.  As this
> is the last caller of vn_grab we can kill it now.

Ok, I'll fix that one up, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
