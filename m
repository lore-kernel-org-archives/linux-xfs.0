Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48840 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751926AbeCWDzf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 23:55:35 -0400
Date: Thu, 22 Mar 2018 20:41:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180323034145.GH4818@magnolia>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323013037.GA9190@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_ifree, we reset the data/attr forks to extents format without
> > bothering to free any inline data buffer that might still be around
> > after all the blocks have been truncated off the file.  Prior to commit
> > 43518812d2 ("xfs: remove support for inlining data/extents into the
> > inode fork") nobody noticed because the leftover inline data after
> > truncation was small enough to fit inside the inline buffer inside the
> > fork itself.
> > 
> > However, now that we've removed the inline buffer, we /always/ have to
> > free the inline data buffer or else we leak them like crazy.  This test
> > was found by turning on kmemleak for generic/001 or generic/388.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 61d1cb7..8012741 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> >  }
> >  
> >  /*
> > + * Free any local-format buffers sitting around before we reset to
> > + * extents format.
> > + */
> > +static inline void
> > +xfs_ifree_local_data(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork)
> > +{
> > +	struct xfs_ifork	*ifp;
> > +
> > +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> > +		return;
> 
> I'm new to all this so this was a bit hard to follow. I'm confused with how
> commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> inode fork") exacerbated the leak, isn't that commit about
> XFS_DINODE_FMT_EXTENTS?

Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
incore data was small enough to fit in if_inline_ata.

> Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?

An empty directory is 6 bytes, which is what you get with a fresh mkdir
or after deleting everything in the directory.  Prior to the 43518812d2
patch we could get away with not even checking if we had to free if_data
when deleting a directory because it fit within if_inline_data.

--D

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
