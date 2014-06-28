Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BF2A7F3F
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 19:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18653304067
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 17:49:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aPyDiKZHEJgpyByU for <xfs@oss.sgi.com>;
	Fri, 27 Jun 2014 17:49:35 -0700 (PDT)
Date: Sat, 28 Jun 2014 10:49:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140628004932.GA9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard> <20140626002859.GQ9508@dastard>
	<53AC7CA9.9050505@sgi.com> <20140626224727.GS9508@dastard>
	<53AD7F1B.500@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53AD7F1B.500@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 27, 2014 at 09:26:35AM -0500, Mark Tinguely wrote:
> On 06/26/14 17:47, Dave Chinner wrote:
> >On Thu, Jun 26, 2014 at 03:03:53PM -0500, Mark Tinguely wrote:
> 
> >>Could an out of order CIL push cause this?
> >
> >I don't think so - the issue appears to be that a CRC is not being
> >recalculated on a buffer before IO has been issued to disk, not that
> >there is incorrect metadata in the buffer. Regardless of how we
> >modify the buffer, the CRC should always match the contents of the
> >block on disk because we calculate it with the buffer locked and
> >just prior to it being written.
> >
> >>SGI saw sequence 2 (and sometimes 3/4) of the cil push get in front
> >>of cil push sequence 1. Looks like the setting of
> >>log->l_cilp->xc_ctx->commit_lsn in xlog_cil_init_post_recovery()
> >>lets this happen.
> >
> >I don't think can actually happen - the CIL is not used until after
> >xlog_cil_init_post_recovery() is completed and transactions start
> >during EFI recovery. Any attempt to use it prior to that call will
> >oops on the null ctx_ticket.
> >
> >As for the ordering issue, I'm pretty sure that was fixed in
> >commit f876e44 ("xfs: always do log forces via the workqueue").
> 
> The problem will be with the first CIL push *after* the
> xlog_cil_init_post_recovery() especially if the first ctx has a
> large vector list and the following ones have small ones.

Sequence 2 cannot start until sequence 1 is on the committing list
and the xc_ctx_lock has been dropped. If seqeunce 2 is then pushed,
while sequence 1 is still writing to the log, then sequence 2 can be
interleaved with sequence 1.

However, the sequences on the commit list are then strictly ordered
while the commit record is written. i.e. seqeunce 2 will sleep
waiting for seqeunce 1 to write it's commit record, which then wakes
sequence 2 so it can write it's commit record, whcih then wakes
seqeunce 3... and so on.

Log recovered once cares that the commit records for each checkpoint
are written in the correct order. You can see the checkpoint
transactions be written to the log out of order, but the order of
commit records determines the order in which checkpoints are
replayed during recovery.

> Looks to me that the problem is still in the cil push worker.

I can't see how the commit records (which are written in
xfs_log_done()) would be incorrectly ordered given the way that
the commit list code serialises and orders calls to xfs_log_done()
based on sequence number.

Keep in mind that I might just be being stupid and missing
something so obvious I need a brown paper bag to hide in, so you'll
need to spell it out for me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
