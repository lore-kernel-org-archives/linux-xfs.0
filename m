Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o888RjH9022531 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 03:27:46 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DEB753BE7
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 01:28:29 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	qqgzVNmQuu5Lm8xw for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 01:28:29 -0700 (PDT)
Date: Wed, 8 Sep 2010 18:28:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908082819.GV705@dastard>
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org>
	<20100908073428.GR705@dastard> <4C87474B.3050405@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C87474B.3050405@kernel.org>
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

On Wed, Sep 08, 2010 at 10:20:27AM +0200, Tejun Heo wrote:
> On 09/08/2010 09:34 AM, Dave Chinner wrote:
> >> Probably I have overloaded the term 'concurrency' too much.  In this
> >> case, I meant the number of workers assigned to work items of the wq.
> >> If you fire off N work items which sleep at the same time, cmwq will
> >> eventually try to create N workers as each previous worker goes to
> >> sleep so that the CPU doesn't sit idle while there are work items to
> >> process as long as N < @wq->nr->active.
> > 
> > Ok, so if I queue N items on a single CPU when max_active == N, they
> > get spread across N worker threads on different CPUs? 
> 
> They may if necessary to keep the workqueue progressing.

Ok, so the normal case is that they will all be processed local to the
CPU they were queued on, like the old workqueue code?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
