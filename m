Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q69Ig6JW000769 for <xfs@oss.sgi.com>; Mon, 9 Jul 2012 13:42:06 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	lWylT9iaNdx029Il (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Jul 2012 11:42:04 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so13536580ggn.26
	for <xfs@oss.sgi.com>; Mon, 09 Jul 2012 11:42:04 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] workqueue: reimplement high priority using a separate
	worker pool
Date: Mon,  9 Jul 2012 11:41:49 -0700
Message-Id: <1341859315-17759-1-git-send-email-tj@kernel.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Currently, WQ_HIGHPRI workqueues share the same worker pool as the
normal priority ones.  The only difference is that work items from
highpri wq are queued at the head instead of tail of the worklist.  On
pathological cases, this simplistics highpri implementation doesn't
seem to be sufficient.

For example, block layer request_queue delayed processing uses high
priority delayed_work to restart request processing after a short
delay.  Unfortunately, it doesn't seem to take too much to push the
latency between the delay timer expiring and the work item execution
to few second range leading to unintended long idling of the
underlying device.  There seem to be real-world cases where this
latency shows up[1].

A simplistic test case is measuring queue-to-execution latencies with
a lot of threads saturating CPU cycles.  Measuring over 300sec period
with 3000 0-nice threads performing 1ms sleeps continuously and a
highpri work item being repeatedly queued with 1 jiffy interval on a
single CPU machine, the top latency was 1624ms and the average of top
20 was 1268ms with stdev 927ms.

This patchset reimplements high priority workqueues so that it uses a
separate worklist and worker pool.  Now each global_cwq contains two
worker_pools - one for normal priority work items and the other for
high priority.  Each has its own worklist and worker pool and the
highpri worker pool is populated with worker threads w/ -20 nice
value.

This reimplementation brings down the top latency to 16ms with top 20
average of 3.8ms w/ stdev 5.6ms.  The original block layer bug hasn't
been verfieid to be fixed yet (Josh?).

The addition of separate worker pools doesn't add much to the
complexity but does add more threads per cpu.  Highpri worker pool is
expected to remain small, but the effect is noticeable especially in
idle states.

I'm cc'ing all WQ_HIGHPRI users - block, bio-integrity, crypto, gfs2,
xfs and bluetooth.  Now you guys get proper high priority scheduling
for highpri work items; however, with more power comes more
responsibility.

Especially, the ones with both WQ_HIGHPRI and WQ_CPU_INTENSIVE -
bio-integrity and crypto - may end up dominating CPU usage.  I think
it should be mostly okay for bio-integrity considering it sits right
in the block request completion path.  I don't know enough about
tegra-aes tho.  aes_workqueue_handler() seems to mostly interact with
the hardware crypto.  Is it actually cpu cycle intensive?

This patchset contains the following six patches.

 0001-workqueue-don-t-use-WQ_HIGHPRI-for-unbound-workqueue.patch
 0002-workqueue-factor-out-worker_pool-from-global_cwq.patch
 0003-workqueue-use-pool-instead-of-gcwq-or-cpu-where-appl.patch
 0004-workqueue-separate-out-worker_pool-flags.patch
 0005-workqueue-introduce-NR_WORKER_POOLS-and-for_each_wor.patch
 0006-workqueue-reimplement-WQ_HIGHPRI-using-a-separate-wo.patch

0001 makes unbound wq not use WQ_HIGHPRI as its meaning will be
changing and won't suit the purpose unbound wq is using it for.

0002-0005 gradually pulls out worker_pool from global_cwq and update
code paths to be able to deal with multiple worker_pools per
global_cwq.

0006 replaces the head-queueing WQ_HIGHPRI implementation with the one
with separate worker_pool using the multiple worker_pool mechanism
previously implemented.

The patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-wq-highpri

diffstat follows.

 Documentation/workqueue.txt      |  103 ++----
 include/trace/events/workqueue.h |    2 
 kernel/workqueue.c               |  624 +++++++++++++++++++++------------------
 3 files changed, 385 insertions(+), 344 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2012/3/6/475

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
