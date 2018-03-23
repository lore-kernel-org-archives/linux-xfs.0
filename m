Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43262 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751992AbeCWRIO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Mar 2018 13:08:14 -0400
Date: Fri, 23 Mar 2018 17:08:13 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180323170813.GD30543@wotan.suse.de>
References: <20171123060137.GL2135@magnolia>
 <20180323013037.GA9190@wotan.suse.de>
 <20180323034145.GH4818@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323034145.GH4818@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 08:41:45PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 23, 2018 at 01:30:37AM +0000, Luis R. Rodriguez wrote:
> > On Wed, Nov 22, 2017 at 10:01:37PM -0800, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index 61d1cb7..8012741 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -2401,6 +2401,24 @@ xfs_ifree_cluster(
> > >  }
> > >  
> > >  /*
> > > + * Free any local-format buffers sitting around before we reset to
> > > + * extents format.
> > > + */
> > > +static inline void
> > > +xfs_ifree_local_data(
> > > +	struct xfs_inode	*ip,
> > > +	int			whichfork)
> > > +{
> > > +	struct xfs_ifork	*ifp;
> > > +
> > > +	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> > > +		return;
> > 
> > I'm new to all this so this was a bit hard to follow. I'm confused with how
> > commit 43518812d2 ("xfs: remove support for inlining data/extents into the
> > inode fork") exacerbated the leak, isn't that commit about
> > XFS_DINODE_FMT_EXTENTS?
> 
> Not specifically _EXTENTS, merely any fork (EXTENTS or LOCAL) whose
> incore data was small enough to fit in if_inline_ata.

Got it, I thought those were XFS_DINODE_FMT_EXTENTS by definition.

> > Did we have cases where the format was XFS_DINODE_FMT_LOCAL and yet
> > ifp->if_u1.if_data == ifp->if_u2.if_inline_data ?
> 
> An empty directory is 6 bytes, which is what you get with a fresh mkdir
> or after deleting everything in the directory.  Prior to the 43518812d2
> patch we could get away with not even checking if we had to free if_data
> when deleting a directory because it fit within if_inline_data.

Ah got it. So your fix *is* also applicable even prior to commit 43518812d2.

  Luis
