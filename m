Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A5tuoj154052 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 00:55:57 -0500
Received: from mail.ud10.udmedia.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AF6255E4A4
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 22:55:54 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id g3KTe5sFpjmpj3mt for
	<xfs@oss.sgi.com>; Sun, 09 Oct 2011 22:55:54 -0700 (PDT)
Date: Mon, 10 Oct 2011 07:55:46 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
Message-ID: <20111010055546.GA1641@x4.trippels.de>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010014509.GT3159@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, xfs@oss.sgi.com, Stefan Priebe <s.priebe@profihost.ag>

On 2011.10.10 at 12:45 +1100, Dave Chinner wrote:
> On Thu, Oct 06, 2011 at 02:33:00PM -0400, Christoph Hellwig wrote:
> > Currently we have a few issues with the way the workqueue code is used to
> > implement AIL pushing:
> > 
> >  - it accidentally uses the same workqueue as the syncer action, and thus
> >    can be prevented from running if there are enough sync actions active
> >    in the system.
> >  - it doesn't use the HIGHPRI flag to queue at the head of the queue of
> >    work items
> > 
> > At this point I'm not confident enough in getting all the workqueue flags and
> > tweaks right to provide a perfectly reliable execution context for AIL
> > pushing, which is the most important piece in XFS to make forward progress
> > when the log fills.
> > 
> > Revert back to use a kthread per filesystem which fixes all the above issues
> > at the cost of having a task struct and stack around for each mounted
> > filesystem.  In addition this also gives us much better ways to diagnose
> > any issues involving hung AIL pushing and removes a small amount of code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> > Tested-by: Stefan Priebe <s.priebe@profihost.ag>
> 
> I'd much prefer to fix the problems with the workqueue usage than
> revert back to using a thread, but seeing as I cannot reproduce the
> hangs I can't really track down whatever problem there is. So,
> a bit reluctantly:

Wouldn't it be possible to verify that the problem also goes away with
this simple one liner?

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2366c54..daf30c9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1654,7 +1654,7 @@ xfs_init_workqueues(void)
 	if (!xfs_syncd_wq)
 		goto out;
 
-	xfs_ail_wq = alloc_workqueue("xfsail", WQ_CPU_INTENSIVE, 8);
+	xfs_ail_wq = alloc_workqueue("xfsail", WQ_HIGHPRI | WQ_CPU_INTENSIVE, 8);
 	if (!xfs_ail_wq)
 		goto out_destroy_syncd;
 
>From Documentation/workqueue.txt:

  WQ_HIGHPRI | WQ_CPU_INTENSIVE

	This combination makes the wq avoid interaction with
	concurrency management completely and behave as a simple
	per-CPU execution context provider.  Work items queued on a
	highpri CPU-intensive wq start execution as soon as resources
	are available and don't affect execution of other work items.

So this should be identical to reverting back to the kthread. No?
CCing Tejun, maybe he can comment on this?

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
