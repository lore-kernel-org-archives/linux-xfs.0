Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44701 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751164AbeDQX5e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 19:57:34 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1f8aTb-00006L-T3
        for linux-xfs@vger.kernel.org; Wed, 18 Apr 2018 09:57:31 +1000
Date: Wed, 18 Apr 2018 09:57:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: validate cached inodes are free when allocated
Message-ID: <20180417235731.GL23861@dastard>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417063916.13069-2-david@fromorbit.com>
 <20180417090030.xyt53fr5aztxftfg@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417090030.xyt53fr5aztxftfg@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 11:00:30AM +0200, Carlos Maiolino wrote:
> >  fs/xfs/xfs_icache.c | 73 +++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 48 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 98b7a4ae15e4..fb37ada55710 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -309,6 +309,46 @@ xfs_reinit_inode(
> >  	return error;
> >  }
> >  
> > +/*
> > + * If we are allocating a new inode, then check what was returned is
> > + * actually a free, empty inode. If we are not allocating an inode,
> > + * the check we didn't find a free inode.
> 
> I know it's been like that for a while, but maybe it's a good time to fix this
> typo? "then check we didn't find..." ?
> 
> Fixing the old typo or not, the patch looks good:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Darrick, do want me to resend with the typo fix, or can you do it on
the way into your tree?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
