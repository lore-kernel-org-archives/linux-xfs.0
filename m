Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53298 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbeCXJGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Mar 2018 05:06:43 -0400
Date: Sat, 24 Mar 2018 10:06:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180324090638.GB1170@kroah.com>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
 <20180323170813.GD30543@wotan.suse.de>
 <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323182302.GB9190@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org, Sasha Levin <alexander.levin@microsoft.com>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Fri, Mar 23, 2018 at 06:23:02PM +0000, Luis R. Rodriguez wrote:
> On Fri, Mar 23, 2018 at 10:26:20AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 23, 2018 at 05:08:13PM +0000, Luis R. Rodriguez wrote:
> > > On Thu, Mar 22, 2018 at 08:41:45PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> > > > > On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> > > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > > index 61d1cb7..8012741 100644
> > > > > > --- a/fs/xfs/xfs_inode.c
> > > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> > > > > >  }
> > > > > >  
> > > > > >  /*
> > > > > > + * Free any local-format buffers sitting around before we reset to
> > > > > > + * extents format.
> > > > > > + */
> > > > > > +static inline void
> > > > > > +xfs_ifree_local_data(
> > > > > > +	struct xfs_inode	*ip,
> > > > > > +	int			whichfork)
> > > > > > +{
> > > > > > +	struct xfs_ifork	*ifp;
> > > > > > +
> > > > > > +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> > > > > > +		return;
> > > > > 
> > > > > I'm new to all this so this was a bit hard to follow. I'm confused with how
> > > > > commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> > > > > inode fork") exacerbated the leak, isn't that commit about
> > > > > XFS_DINODE_FMT_EXTENTS?
> > > > 
> > > > Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
> > > > incore data was small enough to fit in if_inline_ata.
> > > 
> > > Got it, I thought those were XFS_DINODE_FMT_EXTENTS by definition.
> > > 
> > > > > Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> > > > > ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?
> > > > 
> > > > An empty directory is 6 bytes, which is what you get with a fresh mkdir
> > > > or after deleting everything in the directory.  Prior to the 43518812d2
> > > > patch we could get away with not even checking if we had to free if_data
> > > > when deleting a directory because it fit within if_inline_data.
> > > 
> > > Ah got it. So your fix *is* also applicable even prior to commit 43518812d2.
> > 
> > You'd have to modify the patch so that it doesn't try to kmem_free
> > if_data if if_data == if_inline_data but otherwise (in theory) I think
> > that the concept applies to pre-4.15 kernels.
> > 
> > (YMMV, please do run this through QA/kmemleak just in case I'm wrong, etc...)
> 
> Well... so we need a resolution and better get testing this already given that
> *I believe* the new auto-selection algorithm used to cherry pick patches onto
> stable for linux-4.14.y (covered on a paper [0] and when used, stable patches
> are prefixed with AUTOSEL, a recent discussion covered this in November 2017
> [1]) recommended to merge your commit 98c4f78dcdd8 ("xfs: always free inline
> data before resetting inode fork during ifree") as stable commit 1eccdbd4836a41
> on v4.14.17 *without* merging commit 43518812d2 ("xfs: remove support for
> inlining data/extents into the inode fork").
> 
> Sasha, Greg,
> 
> Can you confirm if the algorithm was used in this case?

No idea.

I think xfs should just be added to the "blacklist" so that it is not
even looked at for these types of auto-selected patches.  Much like the
i915 driver currently is handled (it too is ignored for these patches
due to objections from the maintainers of it.)

thanks,

greg k-h
