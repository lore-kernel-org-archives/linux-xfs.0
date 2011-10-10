Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AIbZO9196156 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 13:37:35 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0BB64F0372
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:37:34 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	DWUTx1wuJv1rwfZE for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 11:37:34 -0700 (PDT)
Received: by iahk25 with SMTP id k25so2500857iah.26
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:37:34 -0700 (PDT)
Date: Mon, 10 Oct 2011 11:37:30 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
Message-ID: <20111010183730.GJ8100@google.com>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
	<20111010132611.GA1248@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010132611.GA1248@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Priebe <s.priebe@profihost.ag>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

Hello,

On Mon, Oct 10, 2011 at 09:26:11AM -0400, Christoph Hellwig wrote:
> On Mon, Oct 10, 2011 at 07:55:46AM +0200, Markus Trippelsdorf wrote:
> > Wouldn't it be possible to verify that the problem also goes away with
> > this simple one liner?
> 
> We've been through a few variants, and none fixed it while Stefan had
> to try them on production machines.
> 
> To be honest I'm not convinced at all that a workqueue was such a good
> idea for the ail in particular.  It works extremly well for things were
> we can easily define a work item, e.g. an object that gets queued up
> and a method on it gets exectured.  But for the AIL we really have
> a changing target that needs more or less constant pushing, and the
> target keeps changing while executing our work.  Conceptually it fits
> the idea of an thread much better, with the added benefit of not relying
> on finding a combination of workqueue flags that gets the exact
> behaviour (exectuion ASAP without any limits because of other items
> or required memory allocation).
> 
> And unlike the various per-cpu threads we used to have it is only one
> thread per filesystem anyway.

I don't know xfs internals at all so I don't have too strong an
opinion at this point but don't we at least need to understand what's
going on?  CPU_INTENSIVE / HIGHPRI flags shouldn't cause deadlock
unless some work items are doing busy looping waiting for another work
item to do something (busy yielding might achieve similar effect tho).
They don't change forward progress guarantee.

The only thing which can cause stall is lack of MEM_RECLAIM.  One
thing to be careful about is that each wq has only one rescuer, so if
more than one work items have inter-dependency, it might still lead to
deadlock and they need to be served by different workqueues.

The reasons for moving away from using kthread directly are two folded
- resources and correctness.  I've gone through a number of kthread
users during auditing freezer usage recently and more than half of
them get the synchronization against kthread_stop() or freezer wrong
(to be fair, the rules are quite tricky).  The problem with those bugs
is that they are really obscure race conditions and won't trigger
easily.

Thank you.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
