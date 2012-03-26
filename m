Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLvEDH101014 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:57:15 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ECbkSKrUCKUnFLAR for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 14:57:12 -0700 (PDT)
Date: Tue, 27 Mar 2012 08:57:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: initialise xfssync work before running
	quotachecks
Message-ID: <20120326215709.GM5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-4-git-send-email-david@fromorbit.com>
	<20120322151548.GS7762@sgi.com> <20120322210723.GC5091@dastard>
	<4F6C7BE7.3060100@sgi.com> <20120325232253.GJ5091@dastard>
	<4F7086FA.9010003@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F7086FA.9010003@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Mon, Mar 26, 2012 at 10:10:50AM -0500, Mark Tinguely wrote:
> On 03/25/12 18:22, Dave Chinner wrote:
> >On Fri, Mar 23, 2012 at 08:34:31AM -0500, Mark Tinguely wrote:
> >>>  On 03/22/12 16:07, Dave Chinner wrote:
> >>>>  >On Thu, Mar 22, 2012 at 10:15:48AM -0500, Ben Myers wrote:
> >>>>>  >>On Thu, Mar 22, 2012 at 04:15:08PM +1100, Dave Chinner wrote:
> >>>>>>  >>>From: Dave Chinner<dchinner@redhat.com>
> >>>>>>  >>>
> >>>>>>  >>>Because the mount process can run a quotacheck and consume lots of
> >>>>>>  >>>inodes, we need to be able to run periodic inode reclaim during the
> >>>>>>  >>>mount process. This will prevent running the system out of memory
> >>>>>>  >>>during quota checks.
> >>>>>>  >>>
> >>>>>>  >>>This essentially reverts 2bcf6e97, but that is safe to do now that
> >>>>>>  >>>the quota sync code that was causing problems during long quotacheck
> >>>>>>  >>>executions is now gone.
> >>>>>  >>
> >>>>>  >>Dave, I've held off on #s 3 and 4 because they appear to be racy.  Being
> >>>>  >
> >>>>  >What race?
> >>>>  >
> >>>>  >Cheers,
> >>>>  >
> >>>>  >Dave
> >>>
> >>>
> >>>  2 of the sync workers use iterators
> >>>    xfs_inode_ag_iterator()
> >>>     xfs_perag_get()
> >>>      radix_tree_lookup(&mp->m_perag_tree, agno)
> >>>
> >>>  The race I was worried about was in xfs_mount() to initialize the
> >>>  mp->m_perag_lock, and the radix tree initialization:
> >>>    INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC)).
> >>>
> >>>  There is a lock and 2 or 3 unbuffered I/O are performed in xfs_mountfs()
> >>>  before the mp->m_perag_tree is initialized.
> >Yes they are uncached IOs so do not utilise the cache that
> >requires the mp->m_perag_tree to be initialised.
> 
> The point I was trying to make is the sync workers use iterators.
> The race is to get the mp->m_perag_tree initialized before one of
> the sync workers tries to do a xfs_perag_get().

Firstly, xfs_sync_worker does not iterate AGs at all anymore - it
pushes the log and the AIL, and nothing else. So there is no
problems there.

Secondly xfs_flush_worker() is only triggered by ENOSPC, and that
can't happen until the filesystem is mounted and real work starts.

Finally, the reclaim worker does iterate the perag tree, but the
next patch in the series ensures that is started on demand, not from
xfs_syncd_init(). This ensures that iteration does not occur
until after the first inode is placed into reclaim, and that must
happen after the perag tree is initialised because otherwise we
can't read in inodes, let alone put them into a reclaim state....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
