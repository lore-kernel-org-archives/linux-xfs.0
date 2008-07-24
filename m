Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 23:15:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O6FPgI008742
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:15:25 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 123FCE92098
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:16:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id sFGTUdoU4ndIBQJD for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:16:35 -0700 (PDT)
Date: Thu, 24 Jul 2008 16:16:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] sanitize xfs_initialize_vnode
Message-ID: <20080724061615.GR6761@disturbed>
References: <20080502105215.GA17870@lst.de> <20080723195110.GA6645@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723195110.GA6645@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 09:51:10PM +0200, Christoph Hellwig wrote:
> On Fri, May 02, 2008 at 12:52:15PM +0200, Christoph Hellwig wrote:
> > Sanitize setting up the Linux indode.
> > 
> > Setting up the xfs_inode <-> inode link is opencoded in xfs_iget_core
> > now because that's the only place it needs to be done,
> > xfs_initialize_vnode is renamed to xfs_setup_inode and loses all
> > superflous paramaters.  The check for I_NEW is removed because it always
> > is true and the di_mode check moves into xfs_iget_core because it's only
> > needed there.
> > 
> > xfs_set_inodeops and xfs_revalidate_inode are merged into
> > xfs_setup_inode and the whole things is moved into xfs_iops.c where it
> > belongs.
> 
> Rediffed to apply ontop of Dave's and my vnode helper cleanups:

Looks good and has been passing testing here for the past week...

One question, though:

> +	}
> +
> +	xfs_iflags_clear(ip, XFS_INEW);
> +	barrier();
> +
> +	unlock_new_inode(inode);
> +}

Do we still need that barrier()? Or has the reason for it
existing been lost in the mists of time? Regardless, it was
there before so this is not a reason to stop the patch from
going in...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
