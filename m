Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EA4F7F3F
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 07:59:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6309AC002
	for <xfs@oss.sgi.com>; Wed, 13 Aug 2014 05:59:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JwG1jfDcZmL7kmIX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Aug 2014 05:59:36 -0700 (PDT)
Date: Wed, 13 Aug 2014 08:59:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140813125932.GA4605@bfoster.bfoster>
References: <9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
	<20140812235615.GB20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140812235615.GB20518@dastard>
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
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Wed, Aug 13, 2014 at 09:56:15AM +1000, Dave Chinner wrote:
> On Tue, Aug 12, 2014 at 03:39:02PM +0300, Alex Lyakas wrote:
> > Hello Dave, Brian,
> > I will describe a generic reproduction that you ask for.
> > 
> > It was performed on pristine XFS code from 3.8.13, taken from here:
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> ....
> > I mounted XFS with the following options:
> > rw,sync,noatime,wsync,attr2,inode64,noquota 0 0
> > 
> > I started a couple of processes writing files sequentially onto this
> > mount point, and after few seconds crashed the VM.
> > When the VM came up, I took the metadump file and placed it in:
> > https://drive.google.com/file/d/0ByBy89zr3kJNa0ZpdmZFS242RVU/edit?usp=sharing
> > 
> > Then I set up the following Device Mapper target onto /dev/vde:
> > dmsetup create VDE --table "0 41943040 linear-custom /dev/vde 0"
> > I am attaching the code (and Makefile) of dm-linear-custom target.
> > It is exact copy of dm-linear, except that it has a module
> > parameter. With the parameter set to 0, this is an identity mapping
> > onto /dev/vde. If the parameter is set to non-0, all WRITE bios are
> > failed with ENOSPC. There is a workqueue to fail them in a different
> > context (not sure if really needed, but that's what our "real"
> > custom
> > block device does).
> 
> Well, they you go. That explains it - an asynchronous dispatch error
> happening fast enough to race with the synchronous XFS dispatch
> processing.
> 
> dispatch thread			device workqueue
> xfs_buf_hold();
> atomic_set(b_io_remaining, 1)
> atomic_inc(b_io_remaining)
> submit_bio(bio)
> queue_work(bio)
> xfs_buf_ioend(bp, ....);
>   atomic_dec(b_io_remaining)
> xfs_buf_rele()
> 				bio error set to ENOSPC
> 				  bio->end_io()
> 				    xfs_buf_bio_endio()
> 				      bp->b_error = ENOSPC
> 				      _xfs_buf_ioend(bp, 1);
> 				        atomic_dec(b_io_remaining)
> 					  xfs_buf_ioend(bp, 1);
> 					    queue_work(bp)
> xfs_buf_iowait()
>  if (bp->b_error) return error;
> if (error)
>   xfs_buf_relse()
>     xfs_buf_rele()
>       xfs_buf_free()
> 
> And now we have a freed buffer that is queued on the io completion
> queue. Basically, it requires the buffer error to be set
> asynchronously *between* the dispatch decrementing it's I/O count
> after dispatch, but before we wait on the IO.
> 

That's basically the theory I wanted to test with the experimental
patch. E.g., the error check races with the iodone workqueue item.

> Not sure what the right fix is yet - removing the bp->b_error check
> from xfs_buf_iowait() doesn't solve the problem - it just prevents
> this code path from being tripped over by the race condition.
> 

Perhaps I'm missing some context... I don't follow how removing the
error check doesn't solve the problem. It clearly closes the race and
perhaps there are other means of doing the same thing, but what part of
the problem does that leave unresolved? E.g., we provide a
synchronization mechanism for an async submission path and an object
(xfs_buf) that is involved with potentially multiple such async (I/O)
operations. The async callback side manages the counts of outstanding
bios etc. to set the state of the buf object correctly and fires a
completion when everything is done. The calling side simply waits on the
completion before it can analyze state of the object. Referring to
anything inside that object that happens to be managed by the buffer I/O
mechanism before the buffer is considered complete just seems generally
racy.

It looks like submit_bio() manages this by providing the error through
the callback (always). It also doesn't look like submission path is
guaranteed to be synchronous either (consider md, which appears to use
workqueues and kernel threads)), so I'm not sure that '...;
xfs_buf_iorequest(bp); if (bp->b_error)' is really safe anywhere unless
you're explicitly looking for a write verifier error or something and
do nothing further on the buf contingent on completion (e.g., freeing it
or something it depends on).

Brian

> But, just to validate this is the problem, you should be able to
> reproduce this on a 3.16 kernel. Can you try that, Alex?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
