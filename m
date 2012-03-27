Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RHO8d7134523 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 12:24:08 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h6JNYJfzY3Bb9bEH for
	<xfs@oss.sgi.com>; Tue, 27 Mar 2012 10:24:05 -0700 (PDT)
Date: Tue, 27 Mar 2012 13:23:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120327172357.GE28707@redhat.com>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
	<20120327143127.GA11434@infradead.org>
	<20120327155759.GB28707@redhat.com>
	<20120327160300.GA22555@infradead.org>
	<20120327161941.GC28707@redhat.com>
	<20120327170309.GA6712@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327170309.GA6712@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Mar 27, 2012 at 01:03:09PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 27, 2012 at 12:19:41PM -0400, Vivek Goyal wrote:
> > So xfs either need to resort to similar optimizaiton where IO type from
> > both the process context is of same type or try to do all the IO from
> > one process context. 
> 
> All XFS log I/O is marked SYNC and (FUA and/or FLUSH).

Well, if all the requests are marked with FUA/FLUSH, then I think these
requests will not even be given to IO scheduler. And we should not have
the issue of idling.

        if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
                spin_lock_irq(q->queue_lock);
                where = ELEVATOR_INSERT_FLUSH;
                goto get_rq;
        }

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
