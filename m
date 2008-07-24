Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 23:19:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O6J2be009590
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:19:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B58FE9210E
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:20:12 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 4VSbcX8BxeFmVRLU for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:20:12 -0700 (PDT)
Date: Thu, 24 Jul 2008 08:20:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sanitize xfs_initialize_vnode
Message-ID: <20080724062002.GA26938@lst.de>
References: <20080502105215.GA17870@lst.de> <20080723195110.GA6645@lst.de> <20080724061615.GR6761@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080724061615.GR6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Jul 24, 2008 at 04:16:15PM +1000, Dave Chinner wrote:
> > +	}
> > +
> > +	xfs_iflags_clear(ip, XFS_INEW);
> > +	barrier();
> > +
> > +	unlock_new_inode(inode);
> > +}
> 
> Do we still need that barrier()? Or has the reason for it
> existing been lost in the mists of time? Regardless, it was
> there before so this is not a reason to stop the patch from
> going in...

Good question.  I wonder why it's there in the first place.
