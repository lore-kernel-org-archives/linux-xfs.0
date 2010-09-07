Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o87D2IoT242953 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 08:02:20 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 762F7D9C1CC
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 06:14:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	F4lDTXK05vIq996h for <xfs@oss.sgi.com>;
	Tue, 07 Sep 2010 06:14:08 -0700 (PDT)
Date: Tue, 7 Sep 2010 23:02:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100907130243.GQ705@dastard>
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<4C862F8E.7030507@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C862F8E.7030507@kernel.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 07, 2010 at 02:26:54PM +0200, Tejun Heo wrote:
> On 09/07/2010 12:35 PM, Tejun Heo wrote:
> > Can you please help me a bit more?  Are you saying the following?
> > 
> > Work w0 starts execution on wq0.  w0 tries locking but fails.  Does
> > delay(1) and requeues itself on wq0 hoping another work w1 would be
> > queued on wq0 which will release the lock.  The requeueing should make
> > w0 queued and executed after w1, but instead w1 never gets executed
> > while w0 hogs the CPU constantly by re-executing itself.  Also, how
> > does delay(1) help with chewing up CPU?  Are you talking about
> > avoiding constant lock/unlock ops starving other lockers?  In such
> > case, wouldn't cpu_relax() make more sense?
> 
> Ooh, almost forgot.  There was nr_active underflow bug in workqueue
> code which could lead to malfunctioning max_active regulation and
> problems during queue freezing, so you could be hitting that too.  I
> sent out pull request some time ago but hasn't been pulled into
> mainline yet.  Can you please pull from the following branch and add
> WQ_HIGHPRI as discussed before and see whether the problem is still
> reproducible?

I'm currently running with the WQ_HIGHPRI flag. I only change one
thing at a time so I can tell what caused the change in behaviour...

> And if the problem is reproducible, can you please
> trigger sysrq thread dump and attach it?

Well, most of the time the system is 100% unresponsive when the
livelock occurs, so I'll be lucky to get anything at all....

>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

I'll try that next if the probelm still persists.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
