Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ANUct8139364 for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 18:30:38 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id pxMtEhzmyqDPBhz7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Jul 2012 16:30:37 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so1208056pbb.26
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 16:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341859315-17759-4-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-4-git-send-email-tj@kernel.org>
Date: Tue, 10 Jul 2012 16:30:36 -0700
Message-ID: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu where
	applicable
From: Tony Luck <tony.luck@intel.com>
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
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
>          */
>         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
>                      pool->nr_workers == pool->nr_idle &&
> -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> +                    atomic_read(get_pool_nr_running(pool)));
>  }

Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
haven't bisected ... just noticed  that two patches in this series tinker
with lines in this check. next-20120706 didn't generate the WARN.

-Tony

Mount-cache hash table entries: 1024
ACPI: Core revision 20120518
Boot processor id 0x0/0x0
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0x2d0/0x4a0()
Modules linked in:

Call Trace:
 [<a0000001000154e0>] show_stack+0x80/0xa0
                                sp=e0000040600f7c30 bsp=e0000040600f0da8
 [<a000000100d6e870>] dump_stack+0x30/0x50
                                sp=e0000040600f7e00 bsp=e0000040600f0d90
 [<a0000001000730a0>] warn_slowpath_common+0xc0/0x100
                                sp=e0000040600f7e00 bsp=e0000040600f0d50
 [<a000000100073120>] warn_slowpath_null+0x40/0x60
                                sp=e0000040600f7e00 bsp=e0000040600f0d28
 [<a0000001000aaad0>] worker_enter_idle+0x2d0/0x4a0
                                sp=e0000040600f7e00 bsp=e0000040600f0cf0
 [<a0000001000ad020>] worker_thread+0x4a0/0xbe0
                                sp=e0000040600f7e00 bsp=e0000040600f0c28
 [<a0000001000bda70>] kthread+0x110/0x140
                                sp=e0000040600f7e00 bsp=e0000040600f0be8
 [<a000000100013510>] kernel_thread_helper+0x30/0x60
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
---[ end trace 9501f2472a75a227 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
