Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o888oo8U023544 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 03:50:51 -0500
Received: from hera.kernel.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B05E1036D00
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 02:02:44 -0700 (PDT)
Received: from hera.kernel.org (hera.kernel.org [140.211.167.34]) by
	cuda.sgi.com with ESMTP id LDYNlurcFQsxLjUG for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 02:02:44 -0700 (PDT)
Message-ID: <4C874E90.5040405@kernel.org>
Date: Wed, 08 Sep 2010 10:51:28 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
References: <20100907072954.GM705@dastard> <4C86003B.6090706@kernel.org>
	<20100907100108.GN705@dastard> <4C861582.6080102@kernel.org>
	<4C862F8E.7030507@kernel.org> <20100908082249.GT705@dastard>
In-Reply-To: <20100908082249.GT705@dastard>
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

On 09/08/2010 10:22 AM, Dave Chinner wrote:
> Ok, it looks as if the WQ_HIGHPRI is all that was required to avoid
> the log IO completion starvation livelocks. I haven't yet pulled
> the tree below, but I've now created about a billion inodes without
> seeing any evidence of the livelock occurring.
> 
> Hence it looks like I've been seeing two livelocks - one caused by
> the VM that Mel's patches fix, and one caused by the workqueue
> changeover that is fixed by the WQ_HIGHPRI change.
> 
> Thanks for you insights, Tejun - I'll push the workqueue change
> through the XFS tree to Linus.

Great, BTW, I have several questions regarding wq usage in xfs.

* Do you think @max_active > 1 could be useful for xfs?  If most works
  queued on the wq are gonna contend for the same (blocking) set of
  resources, it would just make more threads sleeping on those
  resources but otherwise it would help reducing execution latency a
  lot.

* xfs_mru_cache is a singlethread workqueue.  Do you specifically need
  singlethreadedness (strict ordering of works) or is it just to avoid
  creating dedicated per-cpu workers?  If the latter, there's no need
  to use singlethread one anymore.

* Are all four workqueues in xfs used during memory allocation?  With
  the new implementation, the reasons to have dedicated wqs are,

  - Forward progress guarantee in the memory allocation path.  Each
    workqueue w/ WQ_RESCUER has _one_ rescuer thread reserved for
    execution of works on the specific wq, which will be used under
    memory pressure to make forward progress.

  - A wq is a flush domain.  You can flush works on it as a group.

  - A wq is also a attribute domain.  If certain work items need to be
    handled differently (highpri, cpu intensive, execution ordering,
    etc...), they can be queued to a wq w/ those attributes specified.

  Maybe some of those workqueues can drop WQ_RESCUER or merged or just
  use the system workqueue?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
