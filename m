Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5M6pN9u061661 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 01:51:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2C8215E6632
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2011 23:51:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JWNN7rGWguM4LDap for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2011 23:51:19 -0700 (PDT)
Date: Wed, 22 Jun 2011 02:51:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: improve sync behaviour in face of aggressive dirtying
Message-ID: <20110622065113.GA30411@infradead.org>
References: <20110617131401.GC2141@infradead.org>
	<20110620081802.GA27111@infradead.org>
	<20110621003343.GJ32466@dastard>
	<20110621092920.GA24540@infradead.org>
	<20110622010911.GS32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110622010911.GS32466@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Wu Fengguang <fengguang.wu@intel.com>, xfs@oss.sgi.com

On Wed, Jun 22, 2011 at 11:09:11AM +1000, Dave Chinner wrote:
> All good, except I think there's a small problem with this - we have
> to process the ioends before pages will transition from WRITEBACK to
> clean. i.e. it is not until xfs_ioend_destroy() that we call the
> bh->b_end_io() function to update the page state. Hence it would
> have to be:
> 
> xfs_fsync() {
> 
> 	current->journal_info = &ioend_end_list;
> 
> 	filemap_fdatawrite();
> 
> 	list_for_each_entry_reverse(ioend_end_list) {
> 		/* process_ioend also waits for ioend completion */
> 		process_ioend();
> 	}
> 
> 	current->journal_info = NULL;
> 
> 	filemap_fdatawait();

Indeed.

> Direct IO is another matter, but we've already got an
> xfs_ioend_wait() in xfs_fsync() to deal with that. Perhaps that
> could be moved over to your new DIO counter so we do block on all
> pending IO?

Splitting the pending direct I/O requests into the one is indeed the
plan.  We'll still need to track ioends for them, though - and I haven't
though about thedetails for those yet.

> > If that sounds reasonable I'll respin a series to move to
> > per-mount workqueues, remove the EAGAIN case, and use the workqueue
> > flush in sync.  Fsync will be left for later, and I'll ping Josef to
> > resend his fsync prototype change.
> 
> Yes, sounds like a plan.

I've implemented it yesterday, and it appears to work fine.  But there's
another issues I found:  the flush_workqueue will update i_size and mark
the inodes dirty right now from ->sync_fs, but that's after we've done
the VFS writeback.  I guess I nees to order this patch after the one
I'm working on to stop doing non-transaction inode updates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
