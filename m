Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7829C7CA4
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 11:46:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F3CC8F8049
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 09:45:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dQBPjME8DJZ7I2yB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 09:45:55 -0700 (PDT)
Date: Tue, 5 Jul 2016 12:45:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160705164552.GA6317@bfoster.bfoster>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160701223011.GA28130@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2016 at 06:30:12PM -0400, Brian Foster wrote:
> On Fri, Jul 01, 2016 at 08:44:57AM +1000, Dave Chinner wrote:
> > On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> > > Newly allocated XFS metadata buffers are added to the LRU once the hold
> > > count is released, which typically occurs after I/O completion. There is
> > > no other mechanism at current that tracks the existence or I/O state of
> > > a new buffer. Further, readahead I/O tends to be submitted
> > > asynchronously by nature, which means the I/O can remain in flight and
> > > actually complete long after the calling context is gone. This means
> > > that file descriptors or any other holds on the filesystem can be
> > > released, allowing the filesystem to be unmounted while I/O is still in
> > > flight. When I/O completion occurs, core data structures may have been
> > > freed, causing completion to run into invalid memory accesses and likely
> > > to panic.
> > > 
> > > This problem is reproduced on XFS via directory readahead. A filesystem
> > > is mounted, a directory is opened/closed and the filesystem immediately
> > > unmounted. The open/close cycle triggers a directory readahead that if
> > > delayed long enough, runs buffer I/O completion after the unmount has
> > > completed.
> > > 
> > > To work around this problem, add readahead buffers to the LRU earlier
> > > than other buffers (when the buffer is allocated, specifically). The
> > > buffer hold count will ultimately remain until I/O completion, which
> > > means any shrinker activity will skip the buffer until then. This makes
> > > the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> > > unmount or quiesce waits for I/O completion appropriately.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > This addresses the problem reproduced by the recently posted xfstests
> > > test:
> > > 
> > >   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> > > 
> > > This could probably be made more involved, i.e., to create another list
> > > of buffers in flight or some such. This seems more simple/sane to me,
> > > however, and survives my testing so far...
> > > 
> > > Brian
> > > 
> > >  fs/xfs/xfs_buf.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 4665ff6..3f03df9 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -590,8 +590,20 @@ xfs_buf_get_map(
> > >  		return NULL;
> > >  	}
> > >  
> > > +	/*
> > > +	 * If the buffer found doesn't match the one allocated above, somebody
> > > +	 * else beat us to insertion and we can toss the new one.
> > > +	 *
> > > +	 * If we did add the buffer and it happens to be readahead, add to the
> > > +	 * LRU now rather than waiting until the hold is released. Otherwise,
> > > +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> > > +	 * nothing else prevents an unmount before I/O completion.
> > > +	 */
> > >  	if (bp != new_bp)
> > >  		xfs_buf_free(new_bp);
> > > +	else if (flags & XBF_READ_AHEAD &&
> > > +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> > > +		atomic_inc(&bp->b_hold);
> > 
> > This doesn't sit right with me. The LRU is for "unused" objects, and
> > readahead objects are not unused until IO completes and nobody is
> > waiting on them.
> > 
> > As it is, this points out another problem with readahead buffers -
> > they aren't actually being cached properly because b_lru_ref == 0,
> > which means they are immediately reclaimed on IO completion rather
> > than being added to the LRU....
> > 
> > I also think that it's not sufficient to cover the generic case of
> > async IO that has no waiter. i.e. we could do get_buf, submit async
> > write, drop submitter reference, and now we have the same problem
> > but on a write.  i.e. this problem is and async IO issue, not a
> > readahead issue.
> > 
> > I think that it might be better to fix it by doing this:
> > 
> > 	1. ensure async IO submission always has b_lru_ref set, and
> > 	if it isn't, set it to 1. This ensures the buffer will be
> > 	added to the LRU on completion if it isn't already there.
> > 
> > 	2. keep a count of async buffer IO in progress. A per-cpu
> > 	counter in the buftarg will be fine for this. Increment in
> > 	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
> > 	xfs_buf_iodone() once we've determined if the buffer needs
> > 	adding to the LRU or not.
> > 
> > 	3. make xfs_wait_buftarg() wait until the async IO count
> > 	goes to zero before it gives up trying to release buffers on
> > 	the LRU.
> > 
> 
> After playing with this a bit this afternoon, I don't think it is so
> straightforward to maintain consistency between xfs_buf_submit() and
> xfs_buf_rele(). Some buffers are actually never released (superblock,
> log buffers). Other buffers can actually be submitted for I/O multiple
> times before they are ultimately released (e.g., log recovery buffer
> read -> delwri submission).
> 

I think I can get around these problems by skipping all uncached I/O and
maintaining a per-buffer I/O count that is sunk into the global buftarg
count once the buffer is released. E.g., something like the following
patch. Not fully tested, but works on some quick tests...

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4665ff6..8a04b66 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -177,6 +177,7 @@ _xfs_buf_alloc(
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_flags = flags;
+	atomic_set(&bp->b_io_count, 0);
 
 	/*
 	 * Set length and io_length to the same value initially.
@@ -865,6 +866,21 @@ xfs_buf_hold(
 	atomic_inc(&bp->b_hold);
 }
 
+static inline void
+xfs_buf_rele_iocount(
+	struct xfs_buf	*bp)
+{
+	int		val;
+
+	val = atomic_read(&bp->b_io_count);
+	if (!val)
+		return;
+
+	atomic_sub(val, &bp->b_io_count);
+	percpu_counter_add(&bp->b_target->bt_io_count, -val);
+	wake_up(&bp->b_target->bt_io_wait);
+}
+
 /*
  *	Releases a hold on the specified buffer.  If the
  *	the hold count is 1, calls xfs_buf_free.
@@ -880,8 +896,10 @@ xfs_buf_rele(
 	if (!pag) {
 		ASSERT(list_empty(&bp->b_lru));
 		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
-		if (atomic_dec_and_test(&bp->b_hold))
+		if (atomic_dec_and_test(&bp->b_hold)) {
+			xfs_buf_rele_iocount(bp);
 			xfs_buf_free(bp);
+		}
 		return;
 	}
 
@@ -890,6 +908,9 @@ xfs_buf_rele(
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
 		spin_lock(&bp->b_lock);
+
+		xfs_buf_rele_iocount(bp);
+
 		if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 			/*
 			 * If the buffer is added to the LRU take a new
@@ -1277,6 +1298,18 @@ _xfs_buf_ioapply(
 	rw |= REQ_META;
 
 	/*
+	 * XXX: uncached check indirectly filters out the sb buffer and log
+	 * buffers (possibly others?), that are held and never released to the
+	 * LRU
+	 */
+	if (bp->b_flags & XBF_ASYNC &&
+	    bp->b_bn != XFS_BUF_DADDR_NULL &&	/* uncached */
+	    atomic_read(&bp->b_lru_ref) && list_empty(&bp->b_lru)) {
+		percpu_counter_inc(&bp->b_target->bt_io_count);
+		atomic_inc(&bp->b_io_count);
+	}
+
+	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
 	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
@@ -1533,6 +1566,8 @@ xfs_wait_buftarg(
 	 * ensure here that all reference counts have been dropped before we
 	 * start walking the LRU list.
 	 */
+	wait_event(btp->bt_io_wait,
+		   (percpu_counter_sum(&btp->bt_io_count) == 0));
 	drain_workqueue(btp->bt_mount->m_buf_workqueue);
 
 	/* loop until there is nothing left on the lru list. */
@@ -1629,6 +1664,8 @@ xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	unregister_shrinker(&btp->bt_shrinker);
+	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
+	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
@@ -1693,6 +1730,10 @@ xfs_alloc_buftarg(
 	if (list_lru_init(&btp->bt_lru))
 		goto error;
 
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+		goto error;
+	init_waitqueue_head(&btp->bt_io_wait);
+
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8bfb974..2518d09 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -115,6 +115,10 @@ typedef struct xfs_buftarg {
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
 	struct list_lru		bt_lru;
+
+	/* XXX: would atomic_t suffice? */
+	struct percpu_counter	bt_io_count;
+	wait_queue_head_t	bt_io_wait;
 } xfs_buftarg_t;
 
 struct xfs_buf;
@@ -183,6 +187,7 @@ typedef struct xfs_buf {
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset in first page */
 	int			b_error;	/* error code on I/O */
+	atomic_t		b_io_count;
 
 	/*
 	 * async write failure retry count. Initialised to zero on the first

> I have a semi-functional patch that holds more of a pure I/O count,
> which means the count is decremented immediately in xfs_buf_ioend()
> rather than deferred to release. One downside is that while this
> technically still resolves the original problem, it's racy in that the
> count is dropped before the buffer is added to the LRU. This still works
> for the original problem because we also drain the ioend workqueue in
> xfs_wait_buftarg(), but it's not correct because we allow for
> non-deferred completion in the event of I/O errors (i.e.,
> xfs_buf_ioend() called directly from xfs_buf_submit()).
> 
> Brian
> 
> > That will ensure readahead buffers are cached, and we capture both
> > async read and async write buffers in xfs_wait_buftarg().
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
