Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGLn1nr131882 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 15:49:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE39F1CD5D30
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 13:50:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	3dVbPyUwcaCwIiBd for <xfs@oss.sgi.com>;
	Thu, 16 Dec 2010 13:50:53 -0800 (PST)
Date: Fri, 17 Dec 2010 08:50:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: reduce the number of AIL push wakeups
Message-ID: <20101216215050.GA5193@dastard>
References: <1292214743-18073-1-git-send-email-david@fromorbit.com>
	<1292214743-18073-6-git-send-email-david@fromorbit.com>
	<20101216153846.GC24185@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101216153846.GC24185@infradead.org>
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

On Thu, Dec 16, 2010 at 10:38:47AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 13, 2010 at 03:32:19PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The xfaild often tries to rest to wait for congestion to pass of for
> > IO to complete, but is regularly woken in tail-pushing situations.
> > In severe cases, the xfsaild is getting woken tens of thousands of
> > times a second. Reduce the number needless wakeups by only waking
> > the xfsaild if the new target is larger than the old one. Further
> > make short sleeps uninterruptible as they occur when the xfsaild has
> > decided it needs to back off to allow some IO to complete and being
> > woken early is counter-productive.
> 
> This patch causes softlockup warnings in xfsaild for various testcases
> on my 32-bit x86 VM, but the testcases continue otherwise normally.

What tests?

> Example below:
> 
> [  361.692515] INFO: task xfsaild/vdb5:8705 blocked for more than 120 seconds.
> [  361.697272] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  361.703929] xfsaild/vdb5  D 00000000     0  8705      2 0x00000000
> [  361.708148]  f4933f10 00000046 f4b37464 00000000 00000000 f4b37100 f4b37100 00000046
> [  361.711501]  f4933eb4 00000046 f4b37100 c0936092 f4b37264 f4b37268 00000000 c0d52d00
> [  361.714786]  c0d52d08 c0e96c00 f5735d38 f4933ec0 f4b37100 f6946c00 f4933eec c0160553
> [  361.718120] Call Trace:
> [  361.721856]  [<c0936092>] ? _raw_spin_unlock_irq+0x22/0x30
> [  361.723439]  [<c0160553>] ? finish_task_switch+0x73/0x100
> [  361.725056]  [<c0160517>] ? finish_task_switch+0x37/0x100
> [  361.726592]  [<c09334b3>] ? schedule+0x263/0x9d0
> [  361.727932]  [<c0198f4b>] ? trace_hardirqs_off+0xb/0x10
> [  361.729548]  [<c0933f05>] schedule_timeout+0x185/0x250
> [  361.731258]  [<c09360d5>] ? _raw_spin_unlock_irqrestore+0x35/0x60
> [  361.733037]  [<c019c68b>] ? trace_hardirqs_on+0xb/0x10
> [  361.734513]  [<c04ed504>] xfsaild+0x54/0xc0
> [  361.735786]  [<c04ed4b0>] ? xfsaild+0x0/0xc0
> [  361.737171]  [<c0187634>] kthread+0x74/0x80
> [  361.738446]  [<c01875c0>] ? kthread+0x0/0x80
> [  361.739987]  [<c013507a>] kernel_thread_helper+0x6/0x1c
> [  361.741589] no locks held by xfsaild/vdb5/8705.

So this is saying is that a 20ms uninterruptible sleep lasting for more
than 120s? Doesn't that imply some kind of scheduler starvation, not
an actual XFS problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
