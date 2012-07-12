Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CH5QM6064159 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 12:05:26 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 2JWoFyLu4tzHcW4T
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 10:05:25 -0700 (PDT)
Received: by yhp26 with SMTP id 26so3318193yhp.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 10:05:25 -0700 (PDT)
Date: Thu, 12 Jul 2012 10:05:19 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120712170519.GA20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120712130648.GA19214@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Fengguang.

On Thu, Jul 12, 2012 at 09:06:48PM +0800, Fengguang Wu wrote:
> [    0.207977] WARNING: at /c/kernel-tests/mm/kernel/workqueue.c:1217 worker_enter_idle+0x2b8/0x32b()
> [    0.207977] Modules linked in:
> [    0.207977] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc6-08414-g9645fff #15
> [    0.207977] Call Trace:
> [    0.207977]  [<ffffffff81087189>] ? worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff810559d9>] warn_slowpath_common+0xae/0xdb
> [    0.207977]  [<ffffffff81055a2e>] warn_slowpath_null+0x28/0x31
> [    0.207977]  [<ffffffff81087189>] worker_enter_idle+0x2b8/0x32b
> [    0.207977]  [<ffffffff81087222>] start_worker+0x26/0x42
> [    0.207977]  [<ffffffff81c8b261>] init_workqueues+0x2d2/0x59a
> [    0.207977]  [<ffffffff81c8af8f>] ? usermodehelper_init+0x8a/0x8a
> [    0.207977]  [<ffffffff81000284>] do_one_initcall+0xce/0x272
> [    0.207977]  [<ffffffff81c6f650>] kernel_init+0x12e/0x3c1
> [    0.207977]  [<ffffffff814b9b74>] kernel_thread_helper+0x4/0x10
> [    0.207977]  [<ffffffff814b80b0>] ? retint_restore_args+0x13/0x13
> [    0.207977]  [<ffffffff81c6f522>] ? start_kernel+0x737/0x737
> [    0.207977]  [<ffffffff814b9b70>] ? gs_change+0x13/0x13

Yeah, I forgot to flip the WARN_ON_ONCE() condition so that it checks
nr_running before looking at pool->nr_running.  The warning is
spurious.  Will post fix soon.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
