Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q571Zabq025443 for <xfs@oss.sgi.com>; Wed, 6 Jun 2012 20:35:36 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	38xFQdX4OnpZiOts for <xfs@oss.sgi.com>;
	Wed, 06 Jun 2012 18:35:34 -0700 (PDT)
Date: Thu, 7 Jun 2012 11:35:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120607013531.GP22848@dastard>
References: <CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard> <4FCF5DB9.2000808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FCF5DB9.2000808@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 06, 2012 at 09:40:09AM -0400, Brian Foster wrote:
> On 06/05/2012 07:54 PM, Dave Chinner wrote:
> > On Fri, May 25, 2012 at 01:03:04PM -0400, Peter Watkins wrote:
> >> On Fri, May 25, 2012 at 2:28 AM, Juerg Haefliger <juergh@gmail.com> wrote:
> 
> snip
> 
> > At this point, running on a 3.5-rc1 kernel is what we need to get
> > working reliably. Once we have the problems solved there, we can
> > work out what set of patches need to be backported to 3.0-stable and
> > other kernels to fix the problems in those supported kernels...
> > 
> 
> Hi guys,
> 
> I've been reproducing a similar stall in my testing of the 're-enable
> xfsaild idle mode' patch/thread that only occurs for me in the xfs tree.
> I was able to do a bisect from rc2 down to commit 43ff2122, though the
> history of this issue makes me wonder if this commit just makes the
> problem more reproducible as opposed to introducing it. Anyways, the
> characteristics I observe so far:

More reproducable. See below.

> - Task blocked for more than 120s message in xlog_grant_head_wait(). I
> see xfs_sync_worker() in my current bt, but I'm pretty sure I've seen
> the same issue without it involved.
> - The AIL is not empty/idle. It spins with a relatively small and
> constant number of entries (I've seen ~8-40). These items are all always
> marked as "flushing."
> - Via crash, all the inodes in the ail appear to be marked as stale
> (i.e. li_cb == xfs_istale_done). The inode flags are
> XFS_ISTALE|XFS_IRECLAIMABLE|XFS_IFLOCK.
> - The iflock in particular is why the ail marks these items 'flushing'
> and why nothing seems to proceed any further (xfsaild just waits for
> these to complete). I can kick the fs back into action with a 'sync.'

Right, I've seen this as well. What I analysed in the case I saw was
that the underlying buffer is also stale - correctly - and it is
pinned in memory so cannot be flushed. HEnce all the inodes are
inteh same state. The reason they are pinned in memory is that they
items were still active in the CIL, and a log force was need to
checkpoint the CIL and cause the checkpoint to be committed. Once
the CIL checkpoint is committed, the stale items are freed from the
AIL, and everything goes onward. The problem is that with the
xfs_sync_worker stalled, nothing triggers a log force because the
inode is returning "flushing" to the AIL pushes.

However, your analysis has allowed me to find what I think is the
bug causing your problem - what I missed when I last saw this was
the significance of the order of checks in xfs_inode_item_push().
That is, we check for whether the inode is flush locked before we
check if it is stale.

By definition, a dirty stale inode must be attached to the
underlying stale buffer and that requires it to be flush locked, as
can be seen in xfs_ifree_cluster:

>>>>>>                  xfs_iflock(ip);
>>>>>>                  xfs_iflags_set(ip, XFS_ISTALE);

                        /*
                         * we don't need to attach clean inodes or those only
                         * with unlogged changes (which we throw away, anyway).
                         */
                        iip = ip->i_itemp;
                        if (!iip || xfs_inode_clean(ip)) {
                                ASSERT(ip != free_ip);
                                xfs_ifunlock(ip);
                                xfs_iunlock(ip, XFS_ILOCK_EXCL);
                                continue;
                        }

                        iip->ili_last_fields = iip->ili_fields;
                        iip->ili_fields = 0;
                        iip->ili_logged = 1;
                        xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
                                                &iip->ili_item.li_lsn);

>>>>>>                  xfs_buf_attach_iodone(bp, xfs_istale_done,
>>>>>>                                            &iip->ili_item);


So basically, the problem is that we should be checking for stale
before flushing in xfs_inode_item_push(). I'll send out a patch that
fixes this in a few minutes.

Good analysis work, Brian!

BTW, I think the underlying cause might be a different manifestation
of the race described in the comment above
xfs_inode_item_committed(), only this time with inodes that are
already in the AIL....

And FWIW, it doesn't explain the CIL stalls that seem to the other
cause of the problem when the AIL is empty...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
