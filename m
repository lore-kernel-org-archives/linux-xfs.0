Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RHhkjc197548 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 12:43:46 -0500
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100924091522.GT2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
	<1285262225.1973.60.camel@doink>  <20100924091522.GT2614@dastard>
Date: Mon, 27 Sep 2010 12:43:29 -0500
Message-ID: <1285609409.2380.67.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2010-09-24 at 19:15 +1000, Dave Chinner wrote:
> On Thu, Sep 23, 2010 at 12:17:05PM -0500, Alex Elder wrote:
> > On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:

. . .

> > It sounds like you're going to re-work this, but
> > I'll mention this for you to consider anyway.  I
> > don't know that the "done" flag here should be
> > needed.
> 
> This check was added because if we don't detect the special case of
> the last valid inode _number_ in the AG, first_index will loop back
> to 0 and we'll start searching the AG again.  IOWs, we're not
> looking for the last inode in the cache, we're looking for the last
> valid inode number.
> 
> Hence the done flag is ensuring that:
> 	a) we terminate the walk at the last valid inode
> 	b) if there are inodes at indexes above the last valid inode
> 	number, we do not grab them or continue walking them.
> 
> Yes, b) should never happen, but I've had bugs in development code
> that have put inodes in stange places before...
> 
> > The gang lookup should never return
> > anything beyond the end of the AG.  It seems
> > like you ought to be able to detect when you've
> > covered all the whole AG elsewhere,
> 
> AFAICT, there are only two ways - the gang lookup returns nothing,
> or we see the last valid inode number in the AG. If you can come up
> with something that doesn't invlove a tree or inode number lookup,
> I'm all ears....
> 
> > *not*
> > on every entry found in this inner loop and
> > also *not* while holding the lock.
> 
> It has to be done while holding the lock because if we cannot grab
> the inode then the only way we can safely derefence the inode is
> by still holding the inode cache lock. Once we drop the lock, the
> inodes we failed to grab can be removed from the cache and we cannot
> safely dereference them to get the inode number from them.

OK, I have a proposal below--it's not a diff, it's just a
modified version of xfs_inode_ag_walk() for you to consider.
It's not hugely better but it reduces the amount
of computation done inside the inner loop and while the
lock is held.  I haven't done any testing with it.

How this differs from what you have, probably in order
of importance:
- Update first_index only on the last inode returned by
  a gang lookup (not on every inode returned)
- Don't compare new value of first_index against the
  old one when it's updated.
- Use first_index == 0 (rather than done != 0) as an
  indication that we've exhausted the inodes in the AG.
- Tracks only grabbed inodes (rather than filling the
  array with null pointers in slots for those not grabbed)
- Don't bother looking at "error" again if it's zero
  (the normal case)

Anyway, do what you like with this (or do nothing at all).
I was just following up on my suggestion.

					-Alex

STATIC int
xfs_inode_ag_walk(
        struct xfs_mount        *mp,
        struct xfs_perag        *pag,
        int                     (*execute)(struct xfs_inode *ip,
                                           struct xfs_perag *pag, int
flags),
        int                     flags)
{
        uint32_t                first_index;
        int                     last_error = 0;
        int                     skipped;
        int                     nr_found;
        
restart:
        skipped = 0;
        first_index = 0;
        do {
                int             error = 0;
                int             nr_grabbed = 0;
                int             i;
                struct xfs_inode *batch[XFS_LOOKUP_BATCH];
                struct xfs_inode *ip; /* = NULL if compiler complains */
        
                read_lock(&pag->pag_ici_lock);
                nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
                                        (void **) batch, first_index,
                                        XFS_LOOKUP_BATCH);
                if (!nr_found) {
                        read_unlock(&pag->pag_ici_lock);
                        break;
                }
        
                /* Grab the inodes while we hold the lock. */
                for (i = 0; i < nr_found; i++) {
                        ip = batch[i];
                        if (!xfs_inode_ag_walk_grab(ip)) {
                                if (i > nr_grabbed)
                                            batch[nr_grabbed] = ip;
                                nr_grabbed++;
                        }   
                }

                /*
                 * Update the index so the next lookup starts after
                 * the last inode found (whether or not we were able
                 * to grab it).  If that inode was the highest one
                 * in the AG, this will evaluate to 0, which will
                 * cause the loop to terminate (below).
                 */
                first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);

		/* Done looking at (ungrabbed) inodes; drop the lock */
                read_unlock(&pag->pag_ici_lock);
                 
                for (i = 0; i < nr_grabbed; i++) {
                        ip = batch[i];
                        error = execute(ip, pag, flags);
                        IRELE(ip);
                        if (error) {
                                if (error == EAGAIN) {
                                        skipped++;
                                else if (last_error != EFSCORRUPTED)
                                        last_error = error;
                        }
                }

                /* bail out if the filesystem is corrupted. */
                if (error == EFSCORRUPTED)
                        break;
        } while (nr_found && first_index);

        if (skipped) {
                delay(1);
                goto restart;
        }

        return last_error;
}



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
