Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p83LZWJw147807 for <xfs@oss.sgi.com>; Sat, 3 Sep 2011 16:35:32 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7152E132A41
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2011 14:35:30 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id Ah1ngUKUf9VHx3En for
	<xfs@oss.sgi.com>; Sat, 03 Sep 2011 14:35:30 -0700 (PDT)
Date: Sun, 4 Sep 2011 05:35:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH, RFC] writeback: avoid redirtying when ->write_inode
	failed to clear I_DIRTY
Message-ID: <20110903213527.GB10529@localhost>
References: <20110827061409.GA6854@infradead.org>
	<20110827135825.GA22575@localhost>
	<20110903011315.GJ12182@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110903011315.GJ12182@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Sep 03, 2011 at 09:13:15AM +0800, Jan Kara wrote:
> On Sat 27-08-11 21:58:25, Wu Fengguang wrote:
> > Christoph,
> > 
> > On Sat, Aug 27, 2011 at 02:14:09PM +0800, Christoph Hellwig wrote:
> > > Right now ->write_inode has no way to safely return a EAGAIN without explicitly
> > > redirtying the inode, as we would lose the dirty state otherwise.  Most
> > > filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
> > > the flusher thread when ->write_inode hits contentended inode locks.  A
> > > contended ilock is something XFS can hit very easibly when extending files, as
> > > the data I/O completion handler takes the lock to update the size, and the
> > > ->write_inode call can race with it fairly easily if writing enough data
> > > in one go so that the completion for the first write come in just before
> > > we call ->write_inode.
> > > 
> > > Change the handling of this case to use requeue_io for a quick retry instead
> > > of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
> > > delaying the writeout more and more with every failed attempt to get the lock.
> > 
> > Yeah redirty_tail() does have the problem of possibly delay inodes for
> > too long time. However, you know requeue_io() always has the danger of
> > triggering busy wb_writeback() loops in corner cases.
> > 
> > For example, nfs_write_inode()/nfs_commit_unstable_pages() often
> > redirty the inode without doing anything (hence no any progress, a
> > prerequisite for busy loops) depending on the in flight writes, which
> > unfortunately further depends on _external_ network/server states..
> > That means some stalled network/sever state could lead to busy loops
> > in NFS clients.
> > 
> > The alternative solution may be to firstly apply the attached patch,
> > and change this one to:
> > 
> >   -			redirty_tail(inode, wb);
> >   +			requeue_io_wait(inode, wb);
>   But your patch doesn't solve the busyloop when the problematic inodes are
> the only ones under writeback, does it? Then b_more_io and b_more_io_wait
> are effectively the same if I understand it right.

The difference lies in the

                /*
                 * No more inodes for IO, bail
                 */
                if (list_empty(&wb->b_more_io))
                        break;

check in wb_writeback(). So when what's left are all b_more_io_wait
inodes, the above check will take effect and break the loop. This is
the tricky point of the patch: it relies on the code not touched by
the patch to work. I've updated the changelog to explain this.

> I think that busylooping in cases like these could be fixed improving the
> busyloop prevention at the end of the loop in wb_writeback(). Maybe we
> could just take a short nap before continuting with writeback instead of /
> in addition to waiting for inode writeback. What do you think?

That's a reasonable robust option, however at the cost of keeping the
writeback code in some ambiguous state ;)

Thanks,
Fengguang
---
Subject: writeback: introduce queue b_more_io_wait
Date: Sun Jul 31 18:44:44 CST 2011

The problem is, redirty_tail() may update i_dirtied_when and result in
30s max delay. If redirty_tail() is called often enough, some inode may
even be delayed for ever.

So introduce the b_more_io_wait queue to park inodes that for some
reason cannot be synced immediately. The inodes will be sent to b_io at
the next b_io refill time, however won't be busy retried as b_more_io:
when the redirtied inodes are all in b_more_io_wait, wb_writeback() will
see empty b_more_io and hence break out of the loop. 

The new data flow after converting all redirty_tail() calls to
requeue_io_wait():

b_dirty --> b_io --> b_more_io/b_more_io_wait --+
             ^                                  |
	     |                                  |
	     +----------------------------------+

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |   10 ++++++++++
 include/linux/backing-dev.h |    8 +++++---
 mm/backing-dev.c            |   10 ++++++++--
 3 files changed, 23 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-08-27 15:28:27.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-08-27 15:45:10.000000000 +0800
@@ -220,6 +220,15 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_wb_list, &wb->b_more_io);
 }
 
+/*
+ * The inode should be retried in an opportunistic way.
+ */
+static void requeue_io_wait(struct inode *inode, struct bdi_writeback *wb)
+{
+	assert_spin_locked(&wb->list_lock);
+	list_move(&inode->i_wb_list, &wb->b_more_io_wait);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -307,6 +316,7 @@ static void queue_io(struct bdi_writebac
 	int moved;
 	assert_spin_locked(&wb->list_lock);
 	list_splice_init(&wb->b_more_io, &wb->b_io);
+	list_splice_init(&wb->b_more_io_wait, &wb->b_io);
 	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
 	trace_writeback_queue_io(wb, older_than_this, moved);
 }
--- linux-next.orig/include/linux/backing-dev.h	2011-08-26 19:27:20.000000000 +0800
+++ linux-next/include/linux/backing-dev.h	2011-08-27 15:45:10.000000000 +0800
@@ -59,6 +59,7 @@ struct bdi_writeback {
 	struct list_head b_dirty;	/* dirty inodes */
 	struct list_head b_io;		/* parked for writeback */
 	struct list_head b_more_io;	/* parked for more writeback */
+	struct list_head b_more_io_wait;/* opportunistic retry io */
 	spinlock_t list_lock;		/* protects the b_* lists */
 };
 
@@ -129,9 +130,10 @@ extern struct list_head bdi_pending_list
 
 static inline int wb_has_dirty_io(struct bdi_writeback *wb)
 {
-	return !list_empty(&wb->b_dirty) ||
-	       !list_empty(&wb->b_io) ||
-	       !list_empty(&wb->b_more_io);
+	return !list_empty(&wb->b_dirty)	||
+	       !list_empty(&wb->b_io)		||
+	       !list_empty(&wb->b_more_io)	||
+	       !list_empty(&wb->b_more_io_wait);
 }
 
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
--- linux-next.orig/mm/backing-dev.c	2011-08-26 19:27:20.000000000 +0800
+++ linux-next/mm/backing-dev.c	2011-08-27 15:45:10.000000000 +0800
@@ -74,10 +74,10 @@ static int bdi_debug_stats_show(struct s
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long nr_dirty, nr_io, nr_more_io;
+	unsigned long nr_dirty, nr_io, nr_more_io, nr_more_io_wait;
 	struct inode *inode;
 
-	nr_dirty = nr_io = nr_more_io = 0;
+	nr_dirty = nr_io = nr_more_io = nr_more_io_wait = 0;
 	spin_lock(&wb->list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
@@ -85,6 +85,8 @@ static int bdi_debug_stats_show(struct s
 		nr_io++;
 	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
 		nr_more_io++;
+	list_for_each_entry(inode, &wb->b_more_io_wait, i_wb_list)
+		nr_more_io_wait++;
 	spin_unlock(&wb->list_lock);
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
@@ -103,6 +105,7 @@ static int bdi_debug_stats_show(struct s
 		   "b_dirty:            %10lu\n"
 		   "b_io:               %10lu\n"
 		   "b_more_io:          %10lu\n"
+		   "b_more_io_wait:     %10lu\n"
 		   "bdi_list:           %10u\n"
 		   "state:              %10lx\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
@@ -116,6 +119,7 @@ static int bdi_debug_stats_show(struct s
 		   nr_dirty,
 		   nr_io,
 		   nr_more_io,
+		   nr_more_io_wait,
 		   !list_empty(&bdi->bdi_list), bdi->state);
 #undef K
 
@@ -635,6 +639,7 @@ static void bdi_wb_init(struct bdi_write
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
 	INIT_LIST_HEAD(&wb->b_more_io);
+	INIT_LIST_HEAD(&wb->b_more_io_wait);
 	spin_lock_init(&wb->list_lock);
 	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
 }
@@ -701,6 +706,7 @@ void bdi_destroy(struct backing_dev_info
 		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
 		list_splice(&bdi->wb.b_io, &dst->b_io);
 		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+		list_splice(&bdi->wb.b_more_io_wait, &dst->b_more_io_wait);
 		spin_unlock(&bdi->wb.list_lock);
 		spin_unlock(&dst->list_lock);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
