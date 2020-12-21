Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA18BC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 12:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0CF2253A
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 12:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgLUMWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 07:22:55 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37255 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbgLUMWz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Dec 2020 07:22:55 -0500
Received: from [192.168.0.8] (ip5f5aef0c.dynamic.kabel-deutschland.de [95.90.239.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4115B2064784C;
        Mon, 21 Dec 2020 13:22:12 +0100 (CET)
Subject: Re: v5.10.1 xfs deadlock
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
 <20201218214915.GA53382@dread.disaster.area>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <c89ecac6-f5bb-52b8-4fcd-9098983cdf2e@molgen.mpg.de>
Date:   Mon, 21 Dec 2020 13:22:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218214915.GA53382@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 18.12.20 22:49, Dave Chinner wrote:
> On Thu, Dec 17, 2020 at 06:44:51PM +0100, Donald Buczek wrote:
>> Dear xfs developer,
>>
>> I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.
>>
>> The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.
>>
>> After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.
>>
>>      root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
>>      root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
>>      root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
>>      root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP
>>
>> Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt
>>
>> It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this
>>
>>      [<0>] xfs_log_commit_cil+0x6cc/0x7c0
>>      [<0>] __xfs_trans_commit+0xab/0x320
>>      [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
>>      [<0>] xfs_end_ioend+0xc6/0x110
>>      [<0>] xfs_end_io+0xad/0xe0
>>      [<0>] process_one_work+0x1dd/0x3e0
>>      [<0>] worker_thread+0x2d/0x3b0
>>      [<0>] kthread+0x118/0x130
>>      [<0>] ret_from_fork+0x22/0x30
>>
>> xfs_log_commit_cil+0x6cc is
>>
>>    xfs_log_commit_cil()
>>      xlog_cil_push_background(log)
>>        xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
>>
>> Some other threads, including the four "cp" commands are also blocking at xfs_log_commit_cil+0x6cc
>>
>> There are also single "flush" process for each md device with this stack signature:
>>
>>      [<0>] xfs_map_blocks+0xbf/0x400
>>      [<0>] iomap_do_writepage+0x15e/0x880
>>      [<0>] write_cache_pages+0x175/0x3f0
>>      [<0>] iomap_writepages+0x1c/0x40
>>      [<0>] xfs_vm_writepages+0x59/0x80
>>      [<0>] do_writepages+0x4b/0xe0
>>      [<0>] __writeback_single_inode+0x42/0x300
>>      [<0>] writeback_sb_inodes+0x198/0x3f0
>>      [<0>] __writeback_inodes_wb+0x5e/0xc0
>>      [<0>] wb_writeback+0x246/0x2d0
>>      [<0>] wb_workfn+0x26e/0x490
>>      [<0>] process_one_work+0x1dd/0x3e0
>>      [<0>] worker_thread+0x2d/0x3b0
>>      [<0>] kthread+0x118/0x130
>>      [<0>] ret_from_fork+0x22/0x30
>>
>> xfs_map_blocks+0xbf is the
>>
>>      xfs_ilock(ip, XFS_ILOCK_SHARED);
>>
>> in xfs_map_blocks().
> 
> Can you post the entire dmesg output after running
> 'echo w > /proc/sysrq-trigger' to dump all the block threads to
> dmesg?
> 
>> I have an out of tree driver for the HBA ( smartpqi 2.1.6-005
>> pulled from linux-scsi) , but it is unlikely that this blocking is
>> related to that, because the md block devices itself are
>> responsive (`xxd /dev/md0` )
> 
> My bet is that the OOT driver/hardware had dropped a log IO on the
> floor - XFS is waiting for the CIL push to complete, and I'm betting
> that is stuck waiting for iclog IO completion while writing the CIL
> to the journal. The sysrq output will tell us if this is the case,
> so that's the first place to look.

I think you are right here, and I'm sorry for blaming the wrong layer.

I've got the system into another (though little different) zero-progress situation. This time it happened on md0 only while md1 was still working.

I think, this should be prove, that the failure is on the block layer of the member disks:

     root:deadbird:/scratch/local/# for f in /sys/devices/virtual/block/md?/md/rd*/block/inflight;do echo $f: $(cat $f);done
     /sys/devices/virtual/block/md0/md/rd0/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd1/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd10/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd11/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd12/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd13/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd14/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd15/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd2/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd3/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd4/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd5/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd6/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd7/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd8/block/inflight: 1 0
     /sys/devices/virtual/block/md0/md/rd9/block/inflight: 1 0
     /sys/devices/virtual/block/md1/md/rd0/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd1/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd10/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd11/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd12/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd13/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd14/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd15/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd2/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd3/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd4/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd5/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd6/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd7/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd8/block/inflight: 0 0
     /sys/devices/virtual/block/md1/md/rd9/block/inflight: 0 0

Best

   Donald

> 
> Cheers,
> 
> Dave.
> 
-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
