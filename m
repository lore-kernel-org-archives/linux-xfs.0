Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41100 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752944AbeDRAFv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 20:05:51 -0400
Date: Tue, 17 Apr 2018 17:05:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: validate cached inodes are free when allocated
Message-ID: <20180418000547.GF24738@magnolia>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417063916.13069-2-david@fromorbit.com>
 <20180417090030.xyt53fr5aztxftfg@odin.usersys.redhat.com>
 <20180417235731.GL23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417235731.GL23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 09:57:31AM +1000, Dave Chinner wrote:
> On Tue, Apr 17, 2018 at 11:00:30AM +0200, Carlos Maiolino wrote:
> > >  fs/xfs/xfs_icache.c | 73 +++++++++++++++++++++++++++++++++++------------------
> > >  1 file changed, 48 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 98b7a4ae15e4..fb37ada55710 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -309,6 +309,46 @@ xfs_reinit_inode(
> > >  	return error;
> > >  }
> > >  
> > > +/*
> > > + * If we are allocating a new inode, then check what was returned is
> > > + * actually a free, empty inode. If we are not allocating an inode,
> > > + * the check we didn't find a free inode.
> > 
> > I know it's been like that for a while, but maybe it's a good time to fix this
> > typo? "then check we didn't find..." ?
> > 
> > Fixing the old typo or not, the patch looks good:
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Darrick, do want me to resend with the typo fix, or can you do it on
> the way into your tree?

I'll do it on the way into the tree.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
