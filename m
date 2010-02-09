Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19J8sMr243495 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 13:08:54 -0600
Subject: Re: [PATCH 0/9] Delayed write metadata writeback V5
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1265687802-23043-1-git-send-email-david@fromorbit.com>
References: <1265687802-23043-1-git-send-email-david@fromorbit.com>
Date: Tue, 09 Feb 2010 13:10:04 -0600
Message-ID: <1265742604.26394.1.camel@doink1>
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

On Tue, 2010-02-09 at 14:56 +1100, Dave Chinner wrote:
> While I started with killing async inode writeback, the series has
> grown. It's not really limited to inode writeback - it touches dquot
> flushing, changes the way the AIL pushes on buffers, adds xfsbufd
> sorting for delayed write buffers, adds a real non-blocking mode to
> inode reclaim and avoids physical inode writeback from the VFS while
> fixing bugs in handling delayed write inodes.  Hence this is more
> about enabling efficient delayed write metadata than it is able
> killing async inode writeback.
> 
> The idea behind this series is to make metadata buffers get
> written from xfsbufd via the delayed write queue rather than being
> issued asynchronously from all over the place. To do this, async
> buffer writeback is almost entirely removed from XFS, replaced
> instead by delayed writes and a method to expedite flushing of
> delayed write buffers when required.
> 
> The result of funnelling all the buffer IO into a single place
> is that we can more tightly control and therefore optimise the
> submission of metadata IO. Aggregating the buffers before dispatch
> allows much better sort efficiency of the buffers as the sort window
> is not limited to the size of the elevator congestion hysteresis
> limit. Hence we can approach 100% merge effeciency on large numbers
> of buffers when dispatched for IO and greatly reduce the amount
> of seeking metadata writeback causes.
> 
> The major change is to the inode flushing and reclaim code. Delayed
> write inodes hold the flush lock for much longer than for async
> writeback, and hence blocking on the flush lock can cause extremely
> long latencies without other mechanisms to expedite the release of
> the flush locks. To prevent needing to flush inodes immediately,
> all operations are done non-blocking unless synchronous. This
> required a significant rework of the inode reclaim code, but it
> greatly simplified other pieces of code (e.g. log item pushing).
> 
> Version 5
> - drop the fsync changes to xfs_fs_write_inode() and the associated
>   locking changes, replace them with a targeted inode logging
>   function from Christoph Hellwig to fix a performance regression on
>   fs_mark -S4 workloads on an SSD.
> 
> Version 4
> - rework inode reclaim checks for better legibility
> - add warning to reclaim code when delwri flush errors occur
> - kill XFS_ITEM_FLUSHING now it is not used
> - clean up sync_mode flags being pushed into xfs_iflush()
> - kill the now unused xfs_bawrite() function
> - include Christoph's fsync cache flush fix
> - rework the inode locking and call to xfs_fsync() when doing
>   synchronous inode writes to close races between the fsync and
>   the background delwri flush afterwards.
> 
> Version 3
> - rework inode reclaim to:
> 	- separate it from xfs_iflush return values
> 	- provide a non-blocking mode for background operation
> - apply delwri buffer promotion tricks to dquot flushing
> - kill unneeded dquot flushing flags, similar to inode flushing flag
>   removal
> - fix sync inode flush bug when trying to flush delwri inodes
> 
> Version 2:
> - use generic list sort function
> - when unmounting, push the delwri buffers first, then do sync inode
>   reclaim so that reclaim doesn't block for 15 seconds waiting for
>   delwri inode buffers to be aged and written before the inodes can
>   be reclaimed.
> 
> Alex, the patch series is available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/dgc/xfs for-2.6.34

I looked over the whole series again and it all looks good
to me.  I will pull from your for-2.6.34 branch and will
post it on OSS after I've tested it a bit.

Signed-off-by: Alex Elder <aelder@sgi.com>

					-Alex

> Christoph Hellwig (2):
>       xfs: remove invalid barrier optimization from xfs_fsync
>       xfs: log changed inodes instead of writing them synchronously
> 
> Dave Chinner (7):
>       xfs: Make inode reclaim states explicit
>       xfs: Use delayed write for inodes rather than async V2
>       xfs: Don't issue buffer IO direct from AIL push V2
>       xfs: Sort delayed write buffers before dispatch
>       xfs: Use delay write promotion for dquot flushing
>       xfs: kill the unused XFS_QMOPT_* flush flags V2
>       xfs: kill xfs_bawrite
> 
>  fs/xfs/linux-2.6/xfs_buf.c    |  135 ++++++++++++++++++++++++++--------------
>  fs/xfs/linux-2.6/xfs_buf.h    |    3 +-
>  fs/xfs/linux-2.6/xfs_super.c  |  111 ++++++++++++++++++++++++---------
>  fs/xfs/linux-2.6/xfs_sync.c   |  138 +++++++++++++++++++++++++++++++++-------
>  fs/xfs/linux-2.6/xfs_trace.h  |    1 +
>  fs/xfs/quota/xfs_dquot.c      |   38 +++++-------
>  fs/xfs/quota/xfs_dquot_item.c |   87 ++++----------------------
>  fs/xfs/quota/xfs_dquot_item.h |    4 -
>  fs/xfs/quota/xfs_qm.c         |   14 ++---
>  fs/xfs/xfs_buf_item.c         |   64 ++++++++++---------
>  fs/xfs/xfs_inode.c            |   86 ++------------------------
>  fs/xfs/xfs_inode.h            |   11 +---
>  fs/xfs/xfs_inode_item.c       |  108 +++++++-------------------------
>  fs/xfs/xfs_inode_item.h       |    6 --
>  fs/xfs/xfs_mount.c            |   13 ++++-
>  fs/xfs/xfs_quota.h            |    8 +--
>  fs/xfs/xfs_trans.h            |    3 +-
>  fs/xfs/xfs_trans_ail.c        |   13 ++--
>  fs/xfs/xfs_vnodeops.c         |   12 +---
>  19 files changed, 410 insertions(+), 445 deletions(-)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
