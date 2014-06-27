Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 557987F9B
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2014 09:26:41 -0500 (CDT)
Message-ID: <53AD7F1B.500@sgi.com>
Date: Fri, 27 Jun 2014 09:26:35 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard> <20140626002859.GQ9508@dastard>
	<53AC7CA9.9050505@sgi.com> <20140626224727.GS9508@dastard>
In-Reply-To: <20140626224727.GS9508@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/26/14 17:47, Dave Chinner wrote:
> On Thu, Jun 26, 2014 at 03:03:53PM -0500, Mark Tinguely wrote:

>> Could an out of order CIL push cause this?
>
> I don't think so - the issue appears to be that a CRC is not being
> recalculated on a buffer before IO has been issued to disk, not that
> there is incorrect metadata in the buffer. Regardless of how we
> modify the buffer, the CRC should always match the contents of the
> block on disk because we calculate it with the buffer locked and
> just prior to it being written.
>
>> SGI saw sequence 2 (and sometimes 3/4) of the cil push get in front
>> of cil push sequence 1. Looks like the setting of
>> log->l_cilp->xc_ctx->commit_lsn in xlog_cil_init_post_recovery()
>> lets this happen.
>
> I don't think can actually happen - the CIL is not used until after
> xlog_cil_init_post_recovery() is completed and transactions start
> during EFI recovery. Any attempt to use it prior to that call will
> oops on the null ctx_ticket.
>
> As for the ordering issue, I'm pretty sure that was fixed in
> commit f876e44 ("xfs: always do log forces via the workqueue").

The problem will be with the first CIL push *after* the 
xlog_cil_init_post_recovery() especially if the first ctx has a large 
vector list and the following ones have small ones.

Looks to me that the problem is still in the cil push worker.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
