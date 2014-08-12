Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 009557F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 18:56:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E52BB304032
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 16:56:35 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iVAm15EnsfmmIbfy for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 16:56:30 -0700 (PDT)
Date: Wed, 13 Aug 2014 09:56:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140812235615.GB20518@dastard>
References: <4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
	<20140811215207.GS20518@dastard>
	<20140812120341.GA46654@bfoster.bfoster>
	<DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <DC407F6E8F8C4EE1AF7117D7D6ABF282@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Aug 12, 2014 at 03:39:02PM +0300, Alex Lyakas wrote:
> Hello Dave, Brian,
> I will describe a generic reproduction that you ask for.
> 
> It was performed on pristine XFS code from 3.8.13, taken from here:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
....
> I mounted XFS with the following options:
> rw,sync,noatime,wsync,attr2,inode64,noquota 0 0
> 
> I started a couple of processes writing files sequentially onto this
> mount point, and after few seconds crashed the VM.
> When the VM came up, I took the metadump file and placed it in:
> https://drive.google.com/file/d/0ByBy89zr3kJNa0ZpdmZFS242RVU/edit?usp=sharing
> 
> Then I set up the following Device Mapper target onto /dev/vde:
> dmsetup create VDE --table "0 41943040 linear-custom /dev/vde 0"
> I am attaching the code (and Makefile) of dm-linear-custom target.
> It is exact copy of dm-linear, except that it has a module
> parameter. With the parameter set to 0, this is an identity mapping
> onto /dev/vde. If the parameter is set to non-0, all WRITE bios are
> failed with ENOSPC. There is a workqueue to fail them in a different
> context (not sure if really needed, but that's what our "real"
> custom
> block device does).

Well, they you go. That explains it - an asynchronous dispatch error
happening fast enough to race with the synchronous XFS dispatch
processing.

dispatch thread			device workqueue
xfs_buf_hold();
atomic_set(b_io_remaining, 1)
atomic_inc(b_io_remaining)
submit_bio(bio)
queue_work(bio)
xfs_buf_ioend(bp, ....);
  atomic_dec(b_io_remaining)
xfs_buf_rele()
				bio error set to ENOSPC
				  bio->end_io()
				    xfs_buf_bio_endio()
				      bp->b_error = ENOSPC
				      _xfs_buf_ioend(bp, 1);
				        atomic_dec(b_io_remaining)
					  xfs_buf_ioend(bp, 1);
					    queue_work(bp)
xfs_buf_iowait()
 if (bp->b_error) return error;
if (error)
  xfs_buf_relse()
    xfs_buf_rele()
      xfs_buf_free()

And now we have a freed buffer that is queued on the io completion
queue. Basically, it requires the buffer error to be set
asynchronously *between* the dispatch decrementing it's I/O count
after dispatch, but before we wait on the IO.

Not sure what the right fix is yet - removing the bp->b_error check
from xfs_buf_iowait() doesn't solve the problem - it just prevents
this code path from being tripped over by the race condition.

But, just to validate this is the problem, you should be able to
reproduce this on a 3.16 kernel. Can you try that, Alex?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
