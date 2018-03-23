Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52347 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbeCWSXF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Mar 2018 14:23:05 -0400
Date: Fri, 23 Mar 2018 18:23:02 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180323182302.GB9190@wotan.suse.de>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323172620.GK4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org, Sasha Levin <alexander.levin@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Fri, Mar 23, 2018 at 10:26:20AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 23, 2018 at 05:08:13PM +0000, Luis R. Rodriguez wrote:
> > On Thu, Mar 22, 2018 at 08:41:45PM -0700, Darrick J. Wong wrote:
> > > On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> > > > On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 61d1cb7..8012741 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> > > > >  }
> > > > >  
> > > > >  /*
> > > > > + * Free any local-format buffers sitting around before we reset to
> > > > > + * extents format.
> > > > > + */
> > > > > +static inline void
> > > > > +xfs_ifree_local_data(
> > > > > +	struct xfs_inode	*ip,
> > > > > +	int			whichfork)
> > > > > +{
> > > > > +	struct xfs_ifork	*ifp;
> > > > > +
> > > > > +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> > > > > +		return;
> > > > 
> > > > I'm new to all this so this was a bit hard to follow. I'm confused with how
> > > > commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> > > > inode fork") exacerbated the leak, isn't that commit about
> > > > XFS_DINODE_FMT_EXTENTS?
> > > 
> > > Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
> > > incore data was small enough to fit in if_inline_ata.
> > 
> > Got it, I thought those were XFS_DINODE_FMT_EXTENTS by definition.
> > 
> > > > Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> > > > ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?
> > > 
> > > An empty directory is 6 bytes, which is what you get with a fresh mkdir
> > > or after deleting everything in the directory.  Prior to the 43518812d2
> > > patch we could get away with not even checking if we had to free if_data
> > > when deleting a directory because it fit within if_inline_data.
> > 
> > Ah got it. So your fix *is* also applicable even prior to commit 43518812d2.
> 
> You'd have to modify the patch so that it doesn't try to kmem_free
> if_data if if_data == if_inline_data but otherwise (in theory) I think
> that the concept applies to pre-4.15 kernels.
> 
> (YMMV, please do run this through QA/kmemleak just in case I'm wrong, etc...)

Well... so we need a resolution and better get testing this already given that
*I believe* the new auto-selection algorithm used to cherry pick patches onto
stable for linux-4.14.y (covered on a paper [0] and when used, stable patches
are prefixed with AUTOSEL, a recent discussion covered this in November 2017
[1]) recommended to merge your commit 98c4f78dcdd8 ("xfs: always free inline
data before resetting inode fork during ifree") as stable commit 1eccdbd4836a41
on v4.14.17 *without* merging commit 43518812d2 ("xfs: remove support for
inlining data/extents into the inode fork").

Sasha, Greg,

Can you confirm if the algorithm was used in this case?

Since both commits are merged on v4.15, this is a non-issue on >= 4.15.

I do wonder if other XFS folks are *at least* aware that the auto-selection
algorithm now currently merging patches onto stable for XFS?

FWIW I just finished completing review *all* the other stable commits merged on
XFS on v4.14 *and* v4.13.y and this was the only one that cried out as fishy...
so I would not use this as a reason to say we shouldn't use it for XFS,
specially in lieu of any formal active process which we can count on always
takes place for XFS stable patches. In fact, I'd say that if the auto-selection
algorithm was used we should be able to fine tune it with a bit more subsystem
involvement.  I can at least volunteer to help try to review the candidate
patches that AUTOSEL comes up with (any others?), but note I'm new to XFS... I
can also think of a few modifications to the algorithm but which I can make in
a separate thread. Anyway, provided this is reasonable with others, then
perhaps we can keep using it for XFS?

[0] https://soarsmu.github.io/papers/icse12-patch.pdf
[1] https://lkml.org/lkml/2017/11/21/486

  Luis
