Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145839.uxrjuuhmirsg6pcy@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17126 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdBWWmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 17:42:38 -0500
Date: Fri, 24 Feb 2017 09:42:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [WIP] Propagate error state from buffers to the objects
 attached
Message-ID: <20170223224232.GE17542@dastard>
References: <20170112142209.23458-1-cmaiolino@redhat.com>
 <20170112153852.GF14085@bfoster.bfoster>
 <20170221093057.6bxc6itmimyqckav@eorzea.usersys.redhat.com>
 <20170221132528.GA3207@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221132528.GA3207@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 21, 2017 at 08:25:30AM -0500, Brian Foster wrote:
> On Tue, Feb 21, 2017 at 10:30:57AM +0100, Carlos Maiolino wrote:
> > > > +		if (lip->li_flags & XFS_LI_FAILED) {
> > > > +			printk("#### ITEM BUFFER FAILED PREVIOUSLY, inode: %llu\n",
> > > > +			       ip->i_ino);
> > > > +			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
> > > > +					       &dip, &bp, XBF_TRYLOCK, 0);
> > > > +
> > > > +			if (error) {
> > > > +				rval = XFS_ITEM_FLUSHING;
> > > > +				goto out_unlock;
> > > > +			}
> > > > +
> > > > +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> > > > +				rval = XFS_ITEM_FLUSHING;
> > > > +				xfs_buf_relse(bp);
> > > > +				goto out_unlock;
> > > > +			}
> > > > +
> > > > +			if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> > > > +				printk("#### QUEUEING AGAIN\n");
> > > > +				rval = XFS_ITEM_FLUSHING;
> > > > +			}
> > > > +
> > > 
> > > We need to clear the LI_FAILED state once we've queued it for retry. 
> > 
> > I tried to do this to clear the flag:
> > 
> > 		if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> > 				lip->li_flags &= ~XFS_LI_FAILED;
> > 				printk("#### QUEUEING AGAIN\n");
> > 				rval = XFS_ITEM_FLUSHING;
> > 			}
> > 
> > There is something wrong here that I'm trying to figure out. When I clear the
> > flag, my reproducer ends up in a stack overflow, see below (I removed the linked
> > in modules from the stack to save some space). I just started to investigate
> > why such overflow happened, but I thought it might be worth to post giving that
> > I'm still learning how buffers and the log items work together, maybe you or
> > somebody else might have an idea.
> > 
> 
> Nothing stands out to me on a quick look, but it's been a while since
> I've looked at this. It does look like we should clear the failed flag
> regardless of whether the queue succeeds or not, though (here you clear
> it only when the queue fails).

FWIW, I think this is the wrong way to handle a buffer error, both
from a philosophical POV and from an XFS IO model POV. That is:
IO submission should not need to handle a previous write failure that
didn't clean up buffer and object state correctly. The IO completion handler of the
failed IO should have done all the required cleanup so the
submission path should not require any modifications at all.

Keep in mind the way inode cluster flushing works:

	1. flush first inode in cluster
	2. call xfs-iflush_cluster()
	3. flush lock and flush all inodes on cluster buffer

Now, this means the other 31 dirty inodes in the cluster that were
clustered and flush locked will now get hit your new code when the
AIL tries to push them and find the flush locked. It will do buffer
lookups for 31 inodes that it didn't need to, i.e. failing to get an
inode flush lock in AIL pushing is a /very common occurrence/ whilst
buffer writeback failure is extremely rare.

i.e. we need to unlock and mark the inodes as failed from the buffer
IO completion callbacks, not poll inode buffers for failure if we
can't get a flush lock on an inode. i.e. we need a "soft-error"
equivalent of xfs_iflush_abort() that doesn't shutdown the fs or
remove objects from the AIL unless the filesystem has already been
shut down....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
