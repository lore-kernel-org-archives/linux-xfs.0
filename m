Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46749 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdHXA5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 20:57:44 -0400
Date: Wed, 23 Aug 2017 17:57:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
 creations
Message-ID: <20170824005736.GE4796@magnolia>
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

<nod> I agree that for rm and rename we might have to do twisted things
to avoid blowing up; it was more that doing so for inode allocation as
part of create/symlink that just seemed ... weird to me.

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
