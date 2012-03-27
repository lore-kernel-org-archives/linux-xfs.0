Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGuH5n130348 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:56:17 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7qWIv0QiJFOcujRK for
	<xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:56:16 -0700 (PDT)
Date: Tue, 27 Mar 2012 12:19:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] xfs: Do background CIL flushes via a workqueue
Message-ID: <20120327161941.GC28707@redhat.com>
References: <1332841605-3538-1-git-send-email-david@fromorbit.com>
	<20120327143127.GA11434@infradead.org>
	<20120327155759.GB28707@redhat.com>
	<20120327160300.GA22555@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327160300.GA22555@infradead.org>
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

On Tue, Mar 27, 2012 at 12:03:00PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 27, 2012 at 11:57:59AM -0400, Vivek Goyal wrote:
> > On Tue, Mar 27, 2012 at 10:31:27AM -0400, Christoph Hellwig wrote:
> > > Vivek, does CFQ still need any hints for this sort of handoff?
> > > 
> > 
> > Christoph, I don't understand the issue enough to comment on it.
> > 
> > Had a quick look at the patch. Looks like some action (writing log), has
> > been moved to a worker thread.  And in some cases (log force triggered
> > flush, whatever it is), we seem to prefer to do it from the submitter's
> > context.
> 
> Yes.  This is to workaround the old problem of cfq getting utterly
> confused if cooperating I/O beeing submitted from different threads.
> 
> The case in the previous version of this patch was:
> 
>  - thread doing the fsync will write out data, and wait for it
>  - then we'd force the log by kicking a workqueue and waiting for it
> 
> quite similar to the ext3/4 fsync issues that we had long discussions
> about.

Ok, then I think that fundamental issue still remains with CFQ. And there
is no general solution to recognizing dependency between processes.

But a specific workaround  for ext3/ext4 fsync problem was put by corrado
long back.

commit 749ef9f8423054e326f3a246327ed2db4b6d395f
Author: Corrado Zoccolo <czoccolo@gmail.com>
Date:   Mon Sep 20 15:24:50 2010 +0200

    cfq: improve fsync performance for small files

Basically, I think previously journal commits were "WRITE" and were
showing most likely on async IO tree. And "fsync" IO was synchronous
and probably showing up on "sync-noidle" tree. CFQ does idling before
it switches between trees hence transition from one process to other
was slow.

Now corrado, changed the IO type from journaling thread to "WRITE_SYNC"
which makes writes synchronous and sets the REQ_NOIDLE flag. Hence forcing
"journal" thread to show up on "sync-noidle" tree. I think "fsync" was
already there so effectively both the processes are on same service tree
and we don't idle between processes when they are on "sync-noidle" tree.

So xfs either need to resort to similar optimizaiton where IO type from
both the process context is of same type or try to do all the IO from
one process context. 

AFAIK, CFQ does not have any generic mechanism to detect process IO
dependecny.

Thanks
Vivek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
