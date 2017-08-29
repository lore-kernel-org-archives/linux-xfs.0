Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34304 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdH2SEw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 14:04:52 -0400
Date: Tue, 29 Aug 2017 11:04:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
 creations
Message-ID: <20170829180445.GU4757@magnolia>
References: <20170821082404.3387-1-hch@lst.de>
 <20170823202213.GA4796@magnolia>
 <20170824004755.GC21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824004755.GC21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Aug 24, 2017 at 10:47:55AM +1000, Dave Chinner wrote:
> On Wed, Aug 23, 2017 at 01:22:13PM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 21, 2017 at 10:24:04AM +0200, Christoph Hellwig wrote:
> > > If we create a new file we will need an inode, and usually some metadata
> > > in the parent direction.  Aiming for everything to go well despite the
> > > lack of a reservation leads to dirty transactions cancelled under a heavy
> > > create/delete load.  This patch removes those nospace transactions, which
> > > will lead to slightly earlier ENOSPC on some workloads, but instead
> > > prevent file system shutdowns due to cancelling dirty transactions for
> > > others.
> > > 
> > > A customer could observe assertations failures and shutdowns due to
> > > cancelation of dirty transactions during heavy NFS workloads as shown
> > > below:
> > 
> > Looks ok... but is there a xfstest somewhere that can be coaxed into
> > reproducing this?  I'm looking at what this code does and have been
> > wondering why it even tries this weird workaround in the first place?
> 
> Because back in 1997 SGI had a customer that didn't like getting
> ENOSPC being reported trying to rename file near ENOSPC when df said
> the filesystem had <some tiny amount> of space available and the
> directory blocks weren't full:
> 
> commit f5029ed542697e8daf728b57d8fec0d9f1abc66c
> Author: Doug Doucette <doucette@engr.sgi.com>
> Date:   Tue Jul 15 17:54:13 1997 +0000
> 
>     Add xfs_dir_canenter to check for entering name in a directory
>     with no space allocation.  Initialize new da_arg field justcheck,
>     use it in xfs_dir_node_addname.
> 
> commit 9b9c81137b07d40d864e468cf3168f1b55d83c13
> Author: Doug Doucette <doucette@engr.sgi.com>
> Date:   Fri Jul 11 16:33:02 1997 +0000
> 
>     Make xfs_dir_createname fail gracefully if the total argument is
>     0 and we actually need space.  Same treatment for xfs_dir_node_addname.
>     Part of making rename work sometimes with 0 space reservation.
> 
> > IOWS, the weirdness removed by this patch didn't quite smell right, but
> > at the same time I want to know more about why the smelly weirdness was
> > there at all before I rip it out. Context, anyone? :)
> 
> It's always been a crufty corner case. xfs_rename and xfs_remove
> need to be able to operate at ENOSPC where reservations may not be
> possible so they can free up space. However, create/symlink/link
> don't really need to work when so close to ENOSPC we can't get a
> reservation of a few blocks, so I don't see a huge problem with
> this.

Hmm.  Across the testing farm, I see a new behavior -- some of the
xfs/013 runs now get stuck in the cleaner thread, waiting for fsstress
to create some directories for it to remove, only fsstress crashed out
with ENOSPC long ago.  Prior to that, the test would finish with a ton
of ENOSPC messages.

I'm /fairly/ sure this is just xfs/013 being slightly stupid, but in any
case I'm going to hang onto this one a little more while I try to figure
out what exactly xfs/013 is trying to do.  My guess is that the cleaner
thread should just exit if fsstress goes away, but then there's also the
question of whether or not it matter that we spew out the ENOSPC
messages even without this patch applied.

(IOWs I think the problem I see is due to the test, not this patch.)

<muttering>

Ultimately this comes down to a behavioral change, where we trade a
fairly improbably bad event (fs shutdown) for a somewhat more probably
not as bad event (enospc with a few free blocks), which makes this
decision hard, especially with the current cloudy trend of running
systems much closer to the limits than we used to, as Dave pointed out
elsewhere.

My off-the-cuff opinion is that systems ought to be provisioned with
enough storage to keep the fs from getting anywhere past 90% full, let
alone full to the point where we even need to try a no-allocation
transaction; and that shutdowns are bad, especially if they're
avoidable. :)

</muttering>

--D

> 
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
