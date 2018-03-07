Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34993 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754333AbeCGVHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Mar 2018 16:07:36 -0500
Date: Thu, 8 Mar 2018 08:07:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix double ijoin in xfs_reflink_cancel_cow_range
Message-ID: <20180307210706.GO18129@dastard>
References: <20180307091020.6186-1-david@fromorbit.com>
 <20180307091020.6186-3-david@fromorbit.com>
 <20180307131725.GA32572@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307131725.GA32572@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 07, 2018 at 05:17:25AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 07, 2018 at 08:10:20PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > AN inode is joined to teh same transaction twice in
> > xfs_reflink_cancel_cow_range() resulting in the following assert
> > failure:
> 
> Needs some major spelling love :)

Yeah, I sent it out as soon as I realised it was more than just an
isolated occurrence. Needs updating...

> > [   30.180485] XFS: Assertion failed: !(lip->li_flags & XFS_LI_TRANS), file: fs/xfs/xfs_trans.c, line: 740
> 
> That assertations seems like something that only exists locally in your
> tree.  Any chance to send it out with this series?

It's in the first patch. I've got to revise it, anyway, because I
missed the xfs_trans_brelease() case that removes the log item from
the transaction and that throws a false positive in the rmap
finishing code.

> The other option would be to make xfs_trans_ijoin a no-op if the inode
> is already joined, except that this wouldn't work with the magic unlock
> on commit. 

I'd much prefer we catch all the places where we are not handling
permanent transaction state correctly as we pass it between
different functions. Especially as we need to do that to get rid of
the log item descriptor abstraction...

> Which is a feature I find horribly confusing, so we should
> get rid of it, for which we'd need to get rid of the concept of
> synchronous transactions in favour of leaving the log force to the
> caller, which again would be more logical.
> 
> Guess I need to look into doing these cleanups as I don't want to force
> them on anyone else.  Just need to finish all the other more important
> bits on the todo list first :)

As always :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
