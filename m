Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Aug 2008 17:18:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7I0HwgS006088
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:17:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6342719F422A
	for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:19:17 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id JIRDPmZ9bTUpTIY3 for <xfs@oss.sgi.com>; Sun, 17 Aug 2008 17:19:17 -0700 (PDT)
Date: Mon, 18 Aug 2008 10:19:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/7] XFS: Make use of the init-once slab optimisation.
Message-ID: <20080818001912.GE19760@disturbed>
References: <1218698083-11226-1-git-send-email-david@fromorbit.com> <1218698083-11226-6-git-send-email-david@fromorbit.com> <20080814190001.GA19070@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814190001.GA19070@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2008 at 03:00:01PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 14, 2008 at 05:14:41PM +1000, Dave Chinner wrote:
> > To avoid having to initialise some fields of the XFS inode
> > on every allocation, we can use the slab init-once feature
> > to initialise them. All we have to guarantee is that when
> > we free the inode, all it's entries are in the initial state.
> > Add asserts where possible to ensure debug kernels check this
> > initial state before freeing and after allocation.
> 
> Looks good, and I think it this can be moved before the series and
> submitted ASAP.

I'll reorder it....

> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index cf6754a..4f4c939 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -594,21 +594,21 @@ xfs_bulkstat(
> >  						/*
> >  						 * Get the inode cluster buffer
> >  						 */
> > -						ASSERT(xfs_inode_zone != NULL);
> > -						ip = kmem_zone_zalloc(xfs_inode_zone,
> > -								      KM_SLEEP);
> > -						ip->i_ino = ino;
> > -						ip->i_mount = mp;
> > -						spin_lock_init(&ip->i_flags_lock);
> >  						if (bp)
> >  							xfs_buf_relse(bp);
> > +						ip = xfs_inode_alloc(mp, ino);
> > +						if (!ip) {
> > +							bp = NULL;
> > +							rval = ENOMEM;
> > +							break;
> > +						}
> >  						error = xfs_itobp(mp, NULL, ip,
> >  								&dip, &bp, bno,
> >  								XFS_IMAP_BULKSTAT,
> >  								XFS_BUF_LOCK);
> 
> Yikes, what a mess - eventually we should convert this to opencoded cals
> to xfs_imap and xfs_imap_to_bp, but before the function needs to be
> split into manageable chunk.  Another item on the todo list..

Yeah, bulkstat is an utter, utter mess. There's a lot of work needed
to clean it up...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
