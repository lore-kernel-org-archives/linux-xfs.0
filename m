Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3568C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 21:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769B220678
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 21:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jX/ljRXg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgHaVTT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 17:19:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgHaVTS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 17:19:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VLFxfw170122;
        Mon, 31 Aug 2020 21:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iuh4jcP08Yo4AisnxQF4sikYCOVFaDBcfBmD2ggVfrY=;
 b=jX/ljRXgsox++f+felT+ejFDYTSrxcVu/7rTWSIp5YhtyS3pMiYraLdP8+SOv3CDpMG2
 8/0iF0+jkpscLvf+ggO640W2Cw43fmA41v8Nf3RZDuEHe5KY9pTeAiMY1mSmdr5dOWuL
 J5dG+JKkdRkzqPwbQJ9tZqkoUQL1DPiEgmhIkeSLc5DvXhd93cietVivC47GetHM430w
 qZX7Sz6ZgWMS+pIxs2TInGTKT7SapvqG1t+c9vrLZADlrM+OlVQ4SytQFrf57aO8255k
 a/L/ARl2XWX8uXLcjCfqW9oNQ8khId/SUXG9cGAEXo9SeOR5bJG5w2wNzCyKD2THioZ/ xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 337qrhfpy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 21:19:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VLB870185838;
        Mon, 31 Aug 2020 21:19:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380km85su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 21:19:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VLJCgl025077;
        Mon, 31 Aug 2020 21:19:12 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 14:19:12 -0700
Date:   Mon, 31 Aug 2020 14:19:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: RCU stall when using XFS
Message-ID: <20200831211915.GB6096@magnolia>
References: <alpine.LRH.2.02.2008311513150.7870@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2008311513150.7870@file01.intranet.prod.int.rdu2.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 03:22:15PM -0400, Mikulas Patocka wrote:
> Hi
> 
> I report this RCU stall when working with one 512GiB file the XFS 
> filesystem on persistent memory. Except for the warning, there was no 
> observed misbehavior.
> 
> Perhaps, it is missing cond_resched() somewhere.

Yikes, you can send a 2T request to a pmem device??

/sys/block/pmem0/queue/max_hw_sectors_kb : 2147483647

My puny laptop can only push 29GB/s, which I guess means we could stall
on an IO request for 70 seconds...

--D

> Mikulas
> 
> 
> [187395.754249] XFS (pmem3): Mounting V5 Filesystem
> [187395.766583] XFS (pmem3): Ending clean mount
> [187395.771434] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188226.398260] rcu: INFO: rcu_sched self-detected stall on CPU
> [188226.404609] rcu: 	11-....: (37223 ticks this GP) idle=5a2/1/0x4000000000000000 softirq=259495/259495 fqs=13202 
> [188226.416134] 	(t=60017 jiffies g=8444929 q=28811)
> [188226.421405] NMI backtrace for cpu 11
> [188226.425492] CPU: 11 PID: 36509 Comm: kworker/11:0 Tainted: G S         O      5.9.0-rc2 #3
> [188226.434886] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYXCRB1.86B.0576.D20.1902150028 02/15/2019
> [188226.446099] Workqueue: xfs-conv/pmem3 xfs_end_io [xfs]
> [188226.451966] Call Trace:
> [188226.454818]  <IRQ>
> [188226.457184]  dump_stack+0x57/0x70
> [188226.460980]  nmi_cpu_backtrace.cold.8+0x13/0x4f
> [188226.466135]  ? lapic_can_unplug_cpu.cold.36+0x37/0x37
> [188226.471870]  nmi_trigger_cpumask_backtrace+0xc8/0xca
> [188226.477512]  rcu_dump_cpu_stacks+0xae/0xdc
> [188226.482182]  rcu_sched_clock_irq.cold.94+0x10a/0x366
> [188226.487822]  ? trigger_load_balance+0x3c/0x240
> [188226.492881]  ? tick_sched_do_timer+0x70/0x70
> [188226.497742]  ? tick_sched_do_timer+0x70/0x70
> [188226.502620]  update_process_times+0x24/0x60
> [188226.507401]  tick_sched_handle.isra.26+0x35/0x40
> [188226.512651]  tick_sched_timer+0x65/0x80
> [188226.517083]  __hrtimer_run_queues+0x100/0x280
> [188226.522042]  hrtimer_interrupt+0x100/0x220
> [188226.526710]  ? rcu_iw_handler+0x19/0x40
> [188226.531089]  __sysvec_apic_timer_interrupt+0x5d/0xf0
> [188226.536720]  asm_call_on_stack+0xf/0x20
> [188226.541098]  </IRQ>
> [188226.543540]  sysvec_apic_timer_interrupt+0x73/0x80
> [188226.548984]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [188226.554844] RIP: 0010:_raw_spin_unlock_irqrestore+0xe/0x10
> [188226.561062] Code: 00 8b 07 85 c0 75 0b ba 01 00 00 00 f0 0f b1 17 74 03 31 c0 c3 b8 01 00 00 00 c3 90 0f 1f 44 00 00 c6 07 00 0f 1f 40 00 56 9d <c3> 90 0f 1f 44 00 00 8b 07 a9 ff 01 00 00 75 1e ba 00 02 00 00 f0
> [188226.582119] RSP: 0000:ffffb013ce1dbd28 EFLAGS: 00000206
> [188226.588049] RAX: 0000000000000000 RBX: ffffefef65cd7f40 RCX: 0000000000000180
> [188226.596109] RDX: ffff8956c7d1fa38 RSI: 0000000000000206 RDI: ffff896c5dcd4db0
> [188226.604171] RBP: 0000000000000001 R08: ffffb013ce1dbcf0 R09: 0000000000000206
> [188226.612232] R10: 00000000000313d5 R11: 0000000000000001 R12: ffff896a0bbe4000
> [188226.620293] R13: ffff896d59ae4800 R14: ffff896c5dcd4da8 R15: ffff8c9234c54860
> [188226.628399]  test_clear_page_writeback+0xd7/0x300
> [188226.633750]  end_page_writeback+0x43/0x60
> [188226.638326]  iomap_finish_ioend+0x17f/0x200
> [188226.643103]  ? xfs_iomap_write_unwritten+0x18a/0x2c0 [xfs]
> [188226.649322]  iomap_finish_ioends+0x43/0xa0
> [188226.653999]  xfs_end_ioend+0x6b/0x100 [xfs]
> [188226.658825]  ? xfs_setfilesize_ioend+0x60/0x60 [xfs]
> [188226.664482]  xfs_end_io+0xad/0xe0 [xfs]
> [188226.668860]  process_one_work+0x206/0x3d0
> [188226.673431]  ? process_one_work+0x3d0/0x3d0
> [188226.678197]  worker_thread+0x2d/0x3d0
> [188226.682380]  ? process_one_work+0x3d0/0x3d0
> [188226.687146]  kthread+0x116/0x130
> [188226.690844]  ? kthread_park+0x80/0x80
> [188226.695029]  ret_from_fork+0x1f/0x30
> [188510.467258] XFS (pmem3): Unmounting Filesystem
> [188514.316739] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [188514.325229] XFS (pmem3): Mounting V5 Filesystem
> [188514.338115] XFS (pmem3): Ending clean mount
> [188514.342969] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188547.273256] XFS (pmem3): Unmounting Filesystem
> [188551.349615] XFS (pmem3): Mounting V5 Filesystem
> [188551.362393] XFS (pmem3): Ending clean mount
> [188551.367259] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188623.505834] XFS (pmem3): Unmounting Filesystem
> [188627.935790] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [188627.944297] XFS (pmem3): Mounting V5 Filesystem
> [188627.957588] XFS (pmem3): Ending clean mount
> [188627.962455] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188727.574325] XFS (pmem3): Unmounting Filesystem
> [188730.257546] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [188730.266029] XFS (pmem3): Mounting V5 Filesystem
> [188730.277924] XFS (pmem3): Ending clean mount
> [188730.282780] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188731.157151] XFS (pmem3): Unmounting Filesystem
> [188732.031577] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [188732.040047] XFS (pmem3): Mounting V5 Filesystem
> [188732.049865] XFS (pmem3): Ending clean mount
> [188732.054673] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [188752.654883] XFS (pmem3): Unmounting Filesystem
> [188753.536132] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [188753.544610] XFS (pmem3): Mounting V5 Filesystem
> [188753.556100] XFS (pmem3): Ending clean mount
> [188753.560954] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [189643.193075] XFS (pmem3): Unmounting Filesystem
> [189646.828861] XFS (pmem3): Mounting V5 Filesystem
> [189646.841023] XFS (pmem3): Ending clean mount
> [189646.845865] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> [189703.029858] XFS (pmem3): Unmounting Filesystem
> [189705.756862] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> [189705.765342] XFS (pmem3): Mounting V5 Filesystem
> [189705.777044] XFS (pmem3): Ending clean mount
> [189705.781896] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
> 
