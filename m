Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2FDC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C390161981
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhC2SE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhC2SEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 14:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617041073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3lvB6URLWHFex90mx4viylGGI1KBRtGlh/fCq9Czeb0=;
        b=VJhuxw3Jk2kxhIBuCecXyGlqFesnzeQN2VqZRrJCRaqowLGbK5J7D+puDbqdQQydkYQ+8P
        LCTWY19yeS0wioZuGeVW2D9H4VJiUSZFzwcfRll9BxhFUpcRFN512aqX66ovgz9GdkKG5U
        2mWXAdAWs2YRmK4NOOauFInv/7qehvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-D3aSM4HlOninXg2PIqsehw-1; Mon, 29 Mar 2021 14:04:29 -0400
X-MC-Unique: D3aSM4HlOninXg2PIqsehw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 343D7817469;
        Mon, 29 Mar 2021 18:04:28 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89E375044F;
        Mon, 29 Mar 2021 18:04:27 +0000 (UTC)
Date:   Mon, 29 Mar 2021 14:04:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <YGIWqX4pmfsv9LPk@bfoster>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
 <20210329022826.GO63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329022826.GO63242@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 01:28:26PM +1100, Dave Chinner wrote:
> On Fri, Mar 26, 2021 at 10:32:44AM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 26, 2021 at 11:39:38AM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > We have a report of a workload that deadlocks on log reservation via
> > > iomap_ioend completion batching. To start, the fs format is somewhat
> > > unique in that the log is on the smaller side (35MB) and the log stripe
> > > unit is 256k, but this is actually a default mkfs for the underlying
> > > storage. I don't have much more information wrt to the workload or
> > > anything that contributes to the completion processing characteristics.
> > > 
> > > The overall scenario is that a workqueue task is executing in
> > > xfs_end_io() and blocked on transaction reservation for an unwritten
> > > extent conversion. Since this task began executing and pulled pending
> > > items from ->i_ioend_list, the latter was repopulated with 90 ioends, 67
> > > of which have append transactions. These append transactions account for
> > > ~520k of log reservation each due to the log stripe unit. All together
> > > this consumes nearly all of available log space, prevents allocation of
> > > the aforementioned unwritten extent conversion transaction and thus
> > > leaves the fs in a deadlocked state.
> > > 
> > > I can think of different ways we could probably optimize this problem
> > > away. One example is to transfer the append transaction to the inode at
> > > bio completion time such that we retain only one per pending batch of
> > > ioends. The workqueue task would then pull this append transaction from
> > > the inode along with the ioend list and transfer it back to the last
> > > non-unwritten/shared ioend in the sorted list.
> > > 
> > > That said, I'm not totally convinced this addresses the fundamental
> > > problem of acquiring transaction reservation from a context that
> > > essentially already owns outstanding reservation vs. just making it hard
> > > to reproduce. I'm wondering if/why we need the append transaction at
> > > all. AFAICT it goes back to commit 281627df3eb5 ("xfs: log file size
> > > updates at I/O completion time") in v3.4 which changed the completion
> > > on-disk size update from being an unlogged update. If we continue to
> > > send these potential append ioends to the workqueue for completion
> > > processing, is there any reason we can't let the workqueue allocate the
> > > transaction as it already does for unwritten conversion?
> > 
> > Frankly I've never understood what benefit we get from preallocating a
> > transaction and letting it twist in the wind consuming log space while
> > writeback pushes data to the disk.  It's perfectly fine to delay ioend
> > processing while we wait for unwritten conversions and cow remapping to
> > take effect, so what's the harm in a slight delay for this?
> 
> The difference was that file size updates used to be far, far more
> common than unwritten extent updates for buffered IO. When this code
> was written, we almost never did buffered writes into unwritten
> regions, but we always do sequential writes that required a file
> size update.
> 
> Given that this code was replacing an un-synchronised size update,
> the performance impact of reserving transaction space in IO
> completion was significant. There was also the problem of XFS using
> global workqueues - the series that introduced the append
> transaction also introduced per-mount IO completion workqueues and
> so there were concerns about blowing out the number of completion
> workers when we have thousands of pending completions all waiting on
> log space.
> 
> There was a bunch of considerations that probably don't exist
> anymore, plus a bunch of new ones, such as the fact that we now
> queue and merge ioends to process in a single context rather than
> just spraying ioends to worker threads to deal with. The old code
> would have worked just fine - the unwritten extent conversion would
> not have been blocking all those other IO completions...
> 
> Wait, hold on - we're putting both unwritten conversion and size
> updates onto the same queue?
> 
> Ah, yes, that's exactly what we are doing. We've punted all the size
> extension to the unwritten workqueue, regardless of whether it's
> just a size update or not. And then the work processes them one at a
> time after sorting them. We don't complete/free the append
> transactions until we try to merge them one at a time as we walk the
> ioend list on the inode. Hence we try to reserve more log space
> while we still hold an unknown amount of log space on the queue we
> are processin...
> 
> IOws, the completion queuing mixing unwritten extent conversion and
> size updates is *nesting transactions*.  THat's the deadlock - we
> can't take a new transaction reservation while holding another
> transaction reservation in a state where it cannot make progress....
> 

Yes.

> > What happens if you replace the call to xfs_setfilesize_ioend in
> > xfs_end_ioend with xfs_setfilesize, and skip the transaction
> > preallocation altogether?
> 
> I expect that the deadlock will go away at the expense of increased
> log reservation contention in IO completion because this unbounds
> the amount of transaction reservation concurrency that can occur in
> buffered writeback. IOWs, this might just hammer the log really,
> really hard and that's exactly what we don't want data IO completion
> to do....
> 

The point of the original idea was to try and eliminate most of the
transaction overhead for di_size updates in the first place by doing an
update per batch (as opposed to per ioend). See the appended diff for a
crude hacked up example of what I mean.

> I'd say the first thing to fix is the ordering problem on the
> completion queue. XFS needs more than just offset based ordering, it
> needs ioend type based ordering, too. All the size updates should be
> processed before the unwritten extent conversions, hence removing
> the nesting of transactions....
> 

Generally speaking this makes sense if we need to retain the
preallocated size update transactions for some reason. One thing to note
is that we'd be putting on-disk size updates ahead of other ioend
completions on background writeback. I suspect that might not matter
much for unwritten ioends since we'd just expose unwritten extents after
a crash, but the effect on cow writeback completion is not as clear to
me.

For one, it looks like a cow ioend can both require a transaction
allocation for fork remap as well as have an append transaction already
attached, so we'd probably have to tweak how individual ioends are
processed as opposed to just ordering them differently. I also thought
cow blocks don't necessarily have to cover shared (or even existing)
blocks in the data fork due to preallocation, so we'd probably need to
investigate things like whether this makes it possible to put an on-disk
update ahead of a cow remap that lands somewhere in the range between
the in-core inode size and the (smaller) on-disk inode size, and if so,
whether that could result in problematic behavior. I'm not sure this is
worth the associated complexity if there's opportunity to remove the
need for most of these transactions in the first place. Hm?

Brian

--- 8< ---

Hacked up RFC to demonstrate batched completion side transaction
allocations for on-disk updates.

---

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1cc7c36d98e9..04d200e5e70d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -18,6 +18,9 @@
 #include "xfs_bmap_util.h"
 #include "xfs_reflink.h"
 
+/* XXX */
+#define IOMAP_F_APPEND	0x2000
+
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
 	unsigned int		data_seq;
@@ -182,12 +185,10 @@ xfs_end_ioend(
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_type == IOMAP_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
-	else
-		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
 
 done:
-	if (ioend->io_private)
-		error = xfs_setfilesize_ioend(ioend, error);
+	if (ioend->io_flags & IOMAP_F_APPEND)
+		error = xfs_setfilesize(ip, offset, size);
 	iomap_finish_ioends(ioend, error);
 	memalloc_nofs_restore(nofs_flag);
 }
@@ -221,16 +222,28 @@ xfs_end_io(
 	struct iomap_ioend	*ioend;
 	struct list_head	tmp;
 	unsigned long		flags;
+	xfs_off_t		maxendoff;
 
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	list_replace_init(&ip->i_ioend_list, &tmp);
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 
 	iomap_sort_ioends(&tmp);
+
+	/* XXX: track max endoff manually? */
+	ioend = list_last_entry(&tmp, struct iomap_ioend, io_list);
+	if (((ioend->io_flags & IOMAP_F_SHARED) ||
+	     (ioend->io_type != IOMAP_UNWRITTEN)) &&
+	    xfs_ioend_is_append(ioend)) {
+		ioend->io_flags |= IOMAP_F_APPEND;
+		maxendoff = ioend->io_offset + ioend->io_size;
+	}
+
 	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
 			io_list))) {
 		list_del_init(&ioend->io_list);
 		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
+		ASSERT(ioend->io_offset + ioend->io_size <= maxendoff);
 		xfs_end_ioend(ioend);
 	}
 }
@@ -250,8 +263,6 @@ xfs_end_bio(
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
-	ASSERT(xfs_ioend_needs_workqueue(ioend));
-
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
 		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
@@ -487,6 +498,7 @@ xfs_prepare_ioend(
 	int			status)
 {
 	unsigned int		nofs_flag;
+	bool			append = false;
 
 	/*
 	 * We can allocate memory here while doing writeback on behalf of
@@ -501,17 +513,17 @@ xfs_prepare_ioend(
 				ioend->io_offset, ioend->io_size);
 	}
 
-	/* Reserve log space if we might write beyond the on-disk inode size. */
+	/* XXX: quick hack to queue append ioends w/o transaction */
 	if (!status &&
 	    ((ioend->io_flags & IOMAP_F_SHARED) ||
 	     ioend->io_type != IOMAP_UNWRITTEN) &&
 	    xfs_ioend_is_append(ioend) &&
 	    !ioend->io_private)
-		status = xfs_setfilesize_trans_alloc(ioend);
+		append = true;
 
 	memalloc_nofs_restore(nofs_flag);
 
-	if (xfs_ioend_needs_workqueue(ioend))
+	if (xfs_ioend_needs_workqueue(ioend) || append)
 		ioend->io_bio->bi_end_io = xfs_end_bio;
 	return status;
 }

