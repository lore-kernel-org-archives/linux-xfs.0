Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD30C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Mar 2022 02:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiCSCER (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 22:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiCSCEQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 22:04:16 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A59986C8
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 19:02:55 -0700 (PDT)
Received: from fsav312.sakura.ne.jp (fsav312.sakura.ne.jp [153.120.85.143])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22J22qaa070248;
        Sat, 19 Mar 2022 11:02:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav312.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp);
 Sat, 19 Mar 2022 11:02:52 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav312.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22J22pLa070244
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sat, 19 Mar 2022 11:02:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
Date:   Sat, 19 Mar 2022 11:02:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <e0a0bc94-e6de-b0e5-ee46-a76cd1570ea6@I-love.SAKURA.ne.jp>
 <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YjS+Jr6QudSKMSGy@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/03/19 2:15, Tejun Heo wrote:
> Hello,
> 
> On Fri, Mar 18, 2022 at 09:05:42PM +0900, Tetsuo Handa wrote:
>> But since include/linux/workqueue.h only says
>>
>> 	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */
>>
>> , I can't tell when not to specify __WQ_LEGACY and WQ_MEM_RECLAIM together...
>>
>> Tejun, what is the intent of this warning? Can the description of __WQ_LEGACY flag
>> be updated? I think that the loop module had better reserve one "struct task_struct"
>> for each loop device.
>>
>> I guess that, in general, waiting for a work in !WQ_MEM_RECLAIM WQ from a
>> WQ_MEM_RECLAIM WQ is dangerous because that work may not be able to find
>> "struct task_struct" for processing that work. Then, what we should do is to
>> create mp->m_sync_workqueue with WQ_MEM_RECLAIM flag added instead of creating
>> lo->workqueue with __WQ_LEGACY + WQ_MEM_RECLAIM flags added...
>>
>> Is __WQ_LEGACY + WQ_MEM_RECLAIM combination a hack for silencing this warning
>> without fixing various WQs used by xfs and other filesystems?
> 
> So, create_workqueue() is the deprecated interface and always imples
> MEM_RECLAIM because back when the interface was added each wq had a
> dedicated worker and there's no way to tell one way or the other. The
> warning is telling you to convert the workqueue to the alloc_workqueue()
> interface and explicitly use WQ_MEM_RECLAIM flag if the workqueue is gonna
> participate in MEM_RECLAIM chain.

Is the intent of __WQ_LEGACY flag to indicate that "this WQ was created
using deprecated interface" ? But such intention no longer holds true.

Despite __WQ_LEGACY flag is described as "internal: create*_workqueue()",
tegra194_cpufreq_probe()/scsi_add_host_with_dma()/iscsi_host_alloc()/
iscsi_transport_init() are passing __WQ_LEGACY flag using alloc_workqueue()
interface. Therefore, __WQ_LEGACY flag is no longer a meaningful indicator of
"internal: create*_workqueue()". Description for __WQ_LEGACY flag needs an
update.

Here is an example program which reproduces

	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
		  "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps",
		  worker->current_pwq->wq->name, worker->current_func,
		  target_wq->name, target_func);

reported in https://lore.kernel.org/all/20210322060334.GD32426@xsang-OptiPlex-9020/ .

---------- test.c ----------
#include <linux/module.h>
#include <linux/sched.h>

static struct workqueue_struct *wq1;
static struct workqueue_struct *wq2;
static struct work_struct w1;
static struct work_struct w2;

static void wq2_workfn(struct work_struct *work)
{
}

static void wq1_workfn(struct work_struct *work)
{
	INIT_WORK(&w2, wq2_workfn);
	queue_work(wq2, &w2);
	flush_work(&w2);
}

static int __init wq_test_init(void)
{
	wq1 = alloc_workqueue("wq1", WQ_MEM_RECLAIM, 0);
	wq2 = alloc_workqueue("wq2", 0, 0);
	INIT_WORK(&w1, wq1_workfn);
	queue_work(wq1, &w1);
	flush_work(&w1);
	destroy_workqueue(wq2);
	destroy_workqueue(wq1);
	return -EINVAL;
}

module_init(wq_test_init);
MODULE_LICENSE("GPL");
---------- test.c ----------

----------
[  152.666153] test: loading out-of-tree module taints kernel.
[  152.673510] ------------[ cut here ]------------
[  152.675765] workqueue: WQ_MEM_RECLAIM wq1:wq1_workfn [test] is flushing !WQ_MEM_RECLAIM wq2:wq2_workfn [test]
[  152.675790] WARNING: CPU: 0 PID: 259 at kernel/workqueue.c:2650 check_flush_dependency+0x169/0x170
[  152.682636] Modules linked in: test(O+) loop dm_mod dax serio_raw sg vmw_vmci fuse drm sd_mod t10_pi ata_generic pata_acpi ahci libahci ata_piix mptspi mptscsih i2c_piix4 mptbase i2c_core libata scsi_transport_spi e1000
[  152.690020] CPU: 0 PID: 259 Comm: kworker/0:2 Kdump: loaded Tainted: G           O      5.17.0-rc8+ #72
[  152.693869] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
[  152.697764] Workqueue: wq1 wq1_workfn [test]
[  152.699762] RIP: 0010:check_flush_dependency+0x169/0x170
[  152.701817] Code: 8d 7f 18 e8 89 84 3a 00 49 8b 57 18 49 81 c5 60 01 00 00 48 c7 c7 60 f4 86 82 4c 89 e6 4c 89 e9 4d 89 f0 31 c0 e8 c7 80 fc ff <0f> 0b e9 61 ff ff ff 55 41 57 41 56 41 55 41 54 53 48 83 ec 18 48
[  152.709031] RSP: 0018:ffff8881110a7b00 EFLAGS: 00010046
[  152.711434] RAX: 19db87cad24ebb00 RBX: ffffe8ffffa4cc00 RCX: 0000000000000002
[  152.714781] RDX: 0000000000000004 RSI: dffffc0000000000 RDI: ffffffff84a84f00
[  152.717334] RBP: 0000000000000000 R08: dffffc0000000000 R09: ffffed1023546ef8
[  152.723543] R10: ffffed1023546ef8 R11: 1ffff11023546ef7 R12: ffff888113e75160
[  152.729068] R13: ffff888113e70f60 R14: ffffffffa0848090 R15: ffff8881014c3528
[  152.731834] FS:  0000000000000000(0000) GS:ffff88811aa00000(0000) knlGS:0000000000000000
[  152.734735] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  152.736840] CR2: 0000557cfd128768 CR3: 000000007216f006 CR4: 00000000001706f0
[  152.739790] Call Trace:
[  152.740715]  <TASK>
[  152.742072]  start_flush_work+0xf9/0x440
[  152.746516]  __flush_work+0xed/0x170
[  152.747845]  ? flush_work+0x10/0x10
[  152.749240]  ? __queue_work+0x558/0x5b0
[  152.750648]  ? queue_work_on+0xe0/0x160
[  152.752036]  ? lockdep_hardirqs_on+0xe6/0x170
[  152.753757]  ? queue_work_on+0xed/0x160
[  152.755546]  ? wq_worker_last_func+0x20/0x20
[  152.757177]  ? rcu_read_lock_sched_held+0x87/0x100
[  152.758960]  ? perf_trace_rcu_stall_warning+0x210/0x210
[  152.760929]  process_one_work+0x45e/0x6b0
[  152.762587]  ? rescuer_thread+0x9f0/0x9f0
[  152.764332]  ? _raw_spin_lock_irqsave+0xf0/0xf0
[  152.766110]  worker_thread+0x4d7/0x960
[  152.767523]  ? _raw_spin_unlock+0x40/0x40
[  152.769146]  ? preempt_count_sub+0xf/0xc0
[  152.770595]  ? _raw_spin_unlock_irqrestore+0xb2/0x110
[  152.773091]  ? rcu_lock_release+0x20/0x20
[  152.774637]  kthread+0x178/0x1a0
[  152.775819]  ? kthread_blkcg+0x50/0x50
[  152.777228]  ret_from_fork+0x1f/0x30
[  152.778603]  </TASK>
[  152.779427] irq event stamp: 12002
[  152.782443] hardirqs last  enabled at (12001): [<ffffffff81102620>] queue_work_on+0xe0/0x160
[  152.786186] hardirqs last disabled at (12002): [<ffffffff8237473b>] _raw_spin_lock_irq+0x7b/0xe0
[  152.789707] softirqs last  enabled at (11996): [<ffffffff810d9105>] irq_exit_rcu+0xb5/0x100
[  152.792767] softirqs last disabled at (11971): [<ffffffff810d9105>] irq_exit_rcu+0xb5/0x100
[  152.795802] ---[ end trace 0000000000000000 ]---
----------

But if I do

-	wq1 = alloc_workqueue("wq1", WQ_MEM_RECLAIM, 0);
+	wq1 = alloc_workqueue("wq1", __WQ_LEGACY | WQ_MEM_RECLAIM, 0);

, this warning goes away. Therefore, it seems to me that __WQ_LEGACY flag is used
in combination with WQ_MEM_RECLAIM flag in order to ask check_flush_dependency()
not to emit this warning when we cannot afford doing

-	wq2 = alloc_workqueue("wq2", 0, 0);
+	wq2 = alloc_workqueue("wq2", WQ_MEM_RECLAIM, 0);

because the owner of wq1 and wq2 differs.

Given that the legacy create_workqueue() interface always implied WQ_MEM_RECLAIM flag,
maybe it is better to make alloc_workqueue() interface WQ_MEM_RECLAIM by default.
That is, obsolete WQ_MEM_RECLAIM flag and __WQ_LEGACY flag, and introduce a new flag
(e.g. WQ_MAY_SHARE_WORKER) which is passed to alloc_workqueue() interface only when
it is absolutely confident that this WQ never participates in memory reclaim path and
never participates in flush_workqueue()/flush_work() operation.

