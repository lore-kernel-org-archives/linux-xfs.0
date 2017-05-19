Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31184 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757347AbdESXjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 19:39:05 -0400
Date: Sat, 20 May 2017 09:39:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170519233900.GT17542@dastard>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
 <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
 <20170519002227.GS17542@dastard>
 <20170519112659.GB64091@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170519112659.GB64091@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, May 19, 2017 at 07:27:01AM -0400, Brian Foster wrote:
> On Fri, May 19, 2017 at 10:22:27AM +1000, Dave Chinner wrote:
> > On Wed, May 17, 2017 at 12:41:11PM +0200, Carlos Maiolino wrote:
> > > Hi Dave,
> > > 
> > > On Wed, May 17, 2017 at 10:57:49AM +1000, Dave Chinner wrote:
> > > > On Thu, May 11, 2017 at 03:57:33PM +0200, Carlos Maiolino wrote:
> > > > > +xfs_inode_item_error(
> > > > > +	struct xfs_log_item	*lip,
> > > > > +	unsigned int		bflags)
> > > > > +{
> > > > > +
> > > > > +	/*
> > > > > +	 * The buffer writeback containing this inode has been failed
> > > > > +	 * mark it as failed and unlock the flush lock, so it can be retried
> > > > > +	 * again
> > > > > +	 */
> > > > > +	if (bflags & XBF_WRITE_FAIL)
> > > > > +		lip->li_flags |= XFS_LI_FAILED;
> > > > > +}
> > > > 
> > > > I'm pretty sure we can't modify the log item state like this in
> > > > IO context because the parent object is not locked by this context.
> > > > We can modify the state during IO submission because we hold the
> > > > parent object lock, but we don't hold it here.
> > > > 
> > > > i.e. we can race with other log item state changes done during a
> > > > concurrent transaction (e.g. marking the log item dirty in
> > > > xfs_trans_log_inode()).
> > > > 
> > > > > +
> > > > > +				if (lip->li_flags & XFS_LI_FAILED)
> > > > > +					lip->li_flags &= XFS_LI_FAILED;
> > > > > +				lip = next;
> > > > > +			}
> > > > 
> > > > Same race here - we hold the lock for this inode, but not all the
> > > > other inodes linked to the buffer.
> > > > 
> > > > This implies that lip->li_flags needs to use atomic bit updates so
> > > > there are no RMW update races like this.
> > > > 
> > > 
> > > I believe refers to both cases above, while setting and removing the flag?
> > > 
> > > I can simply use set_bit() and clear_bit() here, if this is enough, although, to
> > > use them I'll need to change lip->li_flags size to `unsigned long` if people are
> > > ok with that.
> > 
> > Yup, and you need to change every other flag in li_flags to use
> > atomic bitops, too. That also means using test_bit() for value
> > checks, test_and_clear_bit() instead of "if (bit) {clear bit}" and
> > so on.
> > 
> > i.e. it's no good just making one flag atomic and all the other
> > updates using RMW accesses to change the state because that doesn't
> > close the update race conditions.
> > 
> 
> Am I following this correctly that the only potential race here looks
> like it is with XFS_LI_ABORTED (the dirty transaction cancel case,
> specifically)?

XFS_LI_ABORTED is used during a shutdown (dirty trans cancel causes
a shutdown) so races don't really matter here.

However, the XFS_LI_IN_AIL flag is the problem because of it's
serialisation requirements. That is, log IO completion can be
running asynchronously to metadata object IO completion and the
manipulation of the XFS_LI_IN_AIL flag and state is protected by the
ailp->xa_lock.

Adding new flags to the same field that can be asynchronously
updated by RMW operations outside the ailp->xa_lock will cause
problems in future. There *may not* be a problem right now, but it
is poor programming practice to have different coherency processes
for the same variable that is updated via RMW operations. In these
situations, the only safe way to update the variable is to use an
atomic operation.

i.e. I'm not looking for a specific bug in the code - I'm pointing
out a concurrent programming error that is being made.

> But otherwise given the above, that this is primarily I/O error path
> code, and that we presumably already have serialization mechanisms in
> place in the form of parent object locks, why not just grab the inode
> lock in the appropriate places?

Because we can't guarantee that we can lock the parent object in IO
completion. Deadlock is trivial: process A grabs parent object,
blocks on flush lock. IO completion holds flush lock, blocks trying
to get parent object lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
