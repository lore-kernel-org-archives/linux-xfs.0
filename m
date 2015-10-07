Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA1267F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 18:20:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CF41AC00A
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 16:20:16 -0700 (PDT)
Received: from mail-yk0-f178.google.com (mail-yk0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	yBsGuoH14q3mDCpj (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 16:20:14 -0700 (PDT)
Received: by ykba192 with SMTP id a192so29638103ykb.3
	for <xfs@oss.sgi.com>; Wed, 07 Oct 2015 16:20:14 -0700 (PDT)
Date: Wed, 7 Oct 2015 16:20:10 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
Message-ID: <20151007232010.GA21142@mtj.duckdns.org>
References: <1443806997-30792-1-git-send-email-Waiman.Long@hpe.com>
	<20151002221649.GL27164@dastard> <5613017D.7080909@hpe.com>
	<20151006002538.GO27164@dastard> <561405E1.8020008@hpe.com>
	<20151006213023.GP27164@dastard> <561579EA.60507@hpe.com>
	<20151007230441.GG32150@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007230441.GG32150@dastard>
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

On Thu, Oct 08, 2015 at 10:04:42AM +1100, Dave Chinner wrote:
...
> As it is, the update race you pointed out is easy to solve with
> __this_cpu_cmpxchg rather than _this_cpu_sub (similar to mod_state()
> in the MM percpu counter stats code, perhaps).

percpu cmpxchg is no different from sub or any other operations
regarding cross-CPU synchronization.  They're safe iff the operations
are on the local CPU.  They have to be made atomics if they need to be
manipulated from remote CPUs.

That said, while we can't manipulate the percpu counters directly, we
can add a separate global counter to cache sum result from the
previous run which gets automatically invalidated when any percpu
counter overflows.  That should give better and in case of
back-to-back invocations pretty good precision compared to just
returning the global overflow counter.  Interface-wise, that'd be a
lot easier to deal with although I have no idea whether it'd fit this
particular use case or whether this use case even exists.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
