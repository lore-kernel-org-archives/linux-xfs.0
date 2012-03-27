Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RFwB95107384 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 10:58:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eYE5jrTuhM6s3FME for
	<xfs@oss.sgi.com>; Tue, 27 Mar 2012 08:58:10 -0700 (PDT)
Date: Tue, 27 Mar 2012 11:57:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120327155759.GB28707@redhat.com>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
	<20120327143127.GA11434@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327143127.GA11434@infradead.org>
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

On Tue, Mar 27, 2012 at 10:31:27AM -0400, Christoph Hellwig wrote:
> Vivek, does CFQ still need any hints for this sort of handoff?
> 

Christoph, I don't understand the issue enough to comment on it.

Had a quick look at the patch. Looks like some action (writing log), has
been moved to a worker thread.  And in some cases (log force triggered
flush, whatever it is), we seem to prefer to do it from the submitter's
context.

> > To avoid potential issues with "smart" IO schedulers, don't use the
> > workqueue for log force triggered flushes. Instead, do them directly
> > so that the log IO is done directly by the process issuing the log
> > force and so doesn't get stuck on IO elevator queue idling
> > incorrectly delaying the log IO from the workqueue.

Dave, can you explain a bit more that how CFQ idling in the above case.
You seem to be saying that if we do more idling if this operation is
done from worker thread context. I don't udnerstand why.

In general, one can run into issues with CFQ if there are two processes
doing IO and they are dependent on each other for completion of IO. CFQ
will not know about this dependency and might end up waiting for IO from
one process while next IO will come from next process now. 

So I am not sure why "smart" IO schedulers will run into issues if we
use a worker thread to do log IO. Also not sure, why same thing is right
thing to do when it is not forced flush.

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
