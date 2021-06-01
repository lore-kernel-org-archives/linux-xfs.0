Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7D8C4708F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 23:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EE2613AD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 23:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhFAXRG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:17:06 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55530 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234766AbhFAXRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 19:17:06 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 798B869DD7;
        Wed,  2 Jun 2021 09:15:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loDbU-007t5l-Fm; Wed, 02 Jun 2021 09:15:20 +1000
Date:   Wed, 2 Jun 2021 09:15:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     riteshh <riteshh@linux.ibm.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210601231520.GG664593@dread.disaster.area>
References: <20210519011920.450421-1-david@fromorbit.com>
 <20210531175825.mahfjai3pqftdlrv@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531175825.mahfjai3pqftdlrv@riteshh-domain>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=ufQ1DIqz9ilYA2kVWSYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 11:28:25PM +0530, riteshh wrote:
> On 21/05/19 11:19AM, Dave Chinner wrote:
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -384,21 +384,30 @@ xfs_file_write_checks(
> >  		}
> >  		goto restart;
> >  	}
> > +
> >  	/*
> >  	 * If the offset is beyond the size of the file, we need to zero any
> >  	 * blocks that fall between the existing EOF and the start of this
> > -	 * write.  If zeroing is needed and we are currently holding the
> > -	 * iolock shared, we need to update it to exclusive which implies
> > -	 * having to redo all checks before.
> > +	 * write.  If zeroing is needed and we are currently holding the iolock
> > +	 * shared, we need to update it to exclusive which implies having to
> > +	 * redo all checks before.
> > +	 *
> > +	 * We need to serialise against EOF updates that occur in IO completions
> > +	 * here. We want to make sure that nobody is changing the size while we
> > +	 * do this check until we have placed an IO barrier (i.e.  hold the
> > +	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
> > +	 * spinlock effectively forms a memory barrier once we have the
> > +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
> > +	 * hence be able to correctly determine if we need to run zeroing.
> >  	 *
> > -	 * We need to serialise against EOF updates that occur in IO
> > -	 * completions here. We want to make sure that nobody is changing the
> > -	 * size while we do this check until we have placed an IO barrier (i.e.
> > -	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> > -	 * The spinlock effectively forms a memory barrier once we have the
> > -	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> > -	 * and hence be able to correctly determine if we need to run zeroing.
> > +	 * We can do an unlocked check here safely as IO completion can only
> > +	 * extend EOF. Truncate is locked out at this point, so the EOF can
> > +	 * not move backwards, only forwards. Hence we only need to take the
> > +	 * slow path and spin locks when we are at or beyond the current EOF.
> >  	 */
> > +	if (iocb->ki_pos <= i_size_read(inode))
> > +		goto out;
> > +
> >  	spin_lock(&ip->i_flags_lock);
> >  	isize = i_size_read(inode);
> >  	if (iocb->ki_pos > isize) {
> 
> Hello Dave/Jan,
> 
> Sorry about some silly queries here. But locking sometimes can get confusing and
> needs a background context/history.
> 
> So,
> I was going through the XFS DIO path and I couldn't completely get this below
> difference between xfs_file_dio_write_unaligned() v/s
> xfs_file_dio_write_aligned() checks for taking xfs iolock (inode rwsem)
> with different exclusivity(exclusive v/s shared).
> 
> I in xfs_**_unaligned() function, we also check if (ki_pos + count >= isize()).
> If yes, then we go for an exclusive iolock.
> While in xfs_**_aligned() function, we always take shared iolock.
> 
> Can you please help me understand why is that? In case of an extending aligned
> write, won't we need an exclusive iolock for XFS?

No. Extending the file is a slowpath operation which requires
exclusive locking. We always take the shared lock first if we can
because that's the normal fast path operation and so we optimise for
that case.

In the aligned DIO case, we check for sub-block EOF zeroing in
xfs_file_write_checks(). If needed, we upgrade the lock to exclusive
while the EOF zeroing is done. Once we return back to the aligned IO
code, we'll demote that exclusive lock back to shared for the block
aligned IO that we are issuing.

> Or IIUC, this exclusive lock is mostly needed to prevent two sub-bock zeroing
> from running in parallel (which if this happens could cause corruption)
> and this can only happen with unaligned writes.

The exclusive lock is needed for serialising zeroing operations,
whether it be zeroing for EOF extension or sub-block zeroing for
unaligned writes.

The reason for the EOF checks in the unaligned case is right there
in the comment above the EOF checks:

        /*
         * Extending writes need exclusivity because of the sub-block zeroing
         * that the DIO code always does for partial tail blocks beyond EOF, so
         * don't even bother trying the fast path in this case.
         */

IOWs, there is no possible "fast path" shared locking case for
unaligned extending DIOs, so we just take the exlusive lock right
from the start.

> Whereas, I guess ext4, still does exclusive lock even with aligned extending
> writes, possibly because of updation of inode->i_size and orphan inode
> handling requires it to take exclusive inode rwsem.
> 
> While for XFS inode->i_size updation happens with a different spinlock which is
> ip->i_flags_lock.

XFS is serialising DIO completion against DIO submission here rather
than anything else to do with inode size updates which are,
generally speaking, serialised at a higher level by various
combinations of i_rwsem, MMAPLOCK, ILOCK and inode_dio_wait().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
