Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o888jba2023312 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 03:45:37 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4415C5698B
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 01:46:20 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id MrimIFMClDhNDr8d for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 01:46:20 -0700 (PDT)
Message-ID: <4C874D55.6080402@kernel.org>
Date: Wed, 08 Sep 2010 10:46:13 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<20100907124850.GP705@dastard> <4C865CC4.9070701@kernel.org>
	<20100908073428.GR705@dastard> <4C87474B.3050405@kernel.org>
	<20100908082819.GV705@dastard>
In-Reply-To: <20100908082819.GV705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hello,

On 09/08/2010 10:28 AM, Dave Chinner wrote:
>> They may if necessary to keep the workqueue progressing.
> 
> Ok, so the normal case is that they will all be processed local to the
> CPU they were queued on, like the old workqueue code?

Bound workqueues always process works locally.  Please consider the
following scenario.

 w0, w1, w2 are queued to q0 on the same CPU.  w0 burns CPU for 5ms
 then sleeps for 10ms then burns CPU for 5ms again then finishes.  w1
 and w2 sleeps for 10ms.

The following is what happens with the original workqueue (ignoring
all other tasks and processing overhead).

 TIME IN MSECS	EVENT
 0		w0 burns CPU
 5		w0 sleeps
 15		w0 wakes and burns CPU
 20		w0 finishes, w1 starts and sleeps
 30		w1 finishes, w2 starts and sleeps
 40		w2 finishes

With cmwq if @max_active >= 3,

 TIME IN MSECS	EVENT
 0		w0 burns CPU
 5		w0 sleeps, w1 starts and sleeps, w2 starts and sleeps
 15		w0 wakes and burns CPU, w1 finishes, w2 finishes
 20		w0 finishes

IOW, cmwq assigns a new worker when there are more work items to
process but no work item is currently in progress on the CPU.  Please
note that this behavior is across *all* workqueues.  It doesn't matter
which work item belongs to which workqueue.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
