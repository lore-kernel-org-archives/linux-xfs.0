Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39780 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932131AbeCBVxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 16:53:00 -0500
Date: Sat, 3 Mar 2018 08:52:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: handle inconsistent log item formatting state
 correctly
Message-ID: <20180302215257.GR30854@dastard>
References: <20180301223527.28626-1-david@fromorbit.com>
 <20180302171833.GS19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302171833.GS19312@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 09:18:33AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 02, 2018 at 09:35:27AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Brian Foster reported an oops like:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: xlog_cil_push+0x184/0x400 [xfs]
> > ....
> > Workqueue: xfs-cil/dm-3 xlog_cil_push_work [xfs]
> > RIP: 0010:xlog_cil_push+0x184/0x400 [xfs]
> > ....
> > 
> > This was caused by the log item size calculation return that there
> > were no log vectors to write on a normal buffer. This should only
> > occur for ordered buffers - the exception handling had never been
> > executed for a non-ordered buffer. This mean we ended up with
> > a log item marked dirty (XFS_LID_DIRTY) but with no log vectors
> > attached that got added to the CIL. When the CIL was pushed, it
> > tripped over the null log vector on the dirty log item when trying
> > to chain the log vectors that needed to be written to the log.
> > 
> > Fix this by clearing the XFS_LID_DIRTY flag on the log item if
> > nothing gets formatted. This will prevent the log item from being
> > added incorrectly to the CIL, and hence avoid the crash
> 
> Is there a test case for this, or just intermittent crashes?

Nope, we can't hit this case right now - it's something that was
only triggered by a bug in my ranged buffer logging patch. It's
clearly a bug, though, so it's a landmine we should remove.

> > Reported-by: Brian Foster <bfoster@redhat.com>
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 27 ++++++++++++++++++++-------
> >  1 file changed, 20 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 61ab5c0a4c45..c1ecd7698100 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -345,9 +345,16 @@ xlog_cil_insert_format_items(
> >  		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
> >  			ordered = true;
> >  
> > -		/* Skip items that do not have any vectors for writing */
> > -		if (!shadow->lv_niovecs && !ordered)
> > +		/*
> > +		 * Skip items that do not have any vectors for writing. These
> > +		 * log items must now be considered clean in this transaction,
> > +		 * so clear the XFS_LID_DIRTY flag to ensure it doesn't get
> > +		 * added to the CIL by mistake.
> > +		 */
> > +		if (!shadow->lv_niovecs && !ordered) {
> > +			lidp->lid_flags &= ~XFS_LID_DIRTY;
> >  			continue;
> > +		}
> >  
> >  		/* compare to existing item size */
> >  		old_lv = lip->li_lv;
> > @@ -486,6 +493,14 @@ xlog_cil_insert_items(
> >  		if (!(lidp->lid_flags & XFS_LID_DIRTY))
> >  			continue;
> >  
> > +		/*
> > +		 * Log items added to the CIL must have a formatted log vector
> > +		 * attached to them. This is a requirement of the log vector
> > +		 * chaining used separate the log items from the changes that
>                          ^^^^^^^^^^^^^^^^^^
> /me trips over this part of the comment, is this supposed to say
> '...chaining using separate log items...' or '...used to separate the log
> items...'?

The latter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
