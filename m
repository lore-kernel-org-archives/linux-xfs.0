Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3DC97F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 20:09:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F107AC005
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 18:09:53 -0700 (PDT)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id rHJ2bhuAMchb2xcH
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Oct 2015 18:09:51 -0700 (PDT)
Received: by pacfv12 with SMTP id fv12so37730184pac.2
	for <xfs@oss.sgi.com>; Wed, 07 Oct 2015 18:09:51 -0700 (PDT)
Date: Wed, 7 Oct 2015 18:09:47 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151008010947.GB21142@mtj.duckdns.org>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard> <561579EA.60507@hpe.com>
	<20151007230441.GG32150@dastard>
	<20151007232010.GA21142@mtj.duckdns.org>
	<20151008010218.GT27164@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151008010218.GT27164@dastard>
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
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, Waiman Long <waiman.long@hpe.com>, xfs@oss.sgi.com

Hello, Dave.

On Thu, Oct 08, 2015 at 12:02:18PM +1100, Dave Chinner wrote:
> > percpu cmpxchg is no different from sub or any other operations
> > regarding cross-CPU synchronization.  They're safe iff the operations
> > are on the local CPU.  They have to be made atomics if they need to be
> > manipulated from remote CPUs.
> 
> Again, another trivially solvable problem, but still irrelevant
> because we don't have the data that tells us whether changing the
> counter behaviour solves the problem....

Dude, it isn't trivially solvable.  You either can't do it or have to
pay the overhead during local access to get around it.

> > That said, while we can't manipulate the percpu counters directly, we
> > can add a separate global counter to cache sum result from the
> > previous run which gets automatically invalidated when any percpu
> > counter overflows.
> >
> > That should give better and in case of
> > back-to-back invocations pretty good precision compared to just
> > returning the global overflow counter.  Interface-wise, that'd be a
> > lot easier to deal with although I have no idea whether it'd fit this
> > particular use case or whether this use case even exists.
> 
> No, it doesn't help - it's effectively what Waiman's original patch
> did by returning the count from the initial comparison and using
> that for ENOSPC detection instead of doing a second comparison...

Just chipping in purely from percpu side.  If what Waiman suggested is
something useable, caching the result inside percpu_counter would be a
better interface.  If not, no idea.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
