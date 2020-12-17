Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44720C4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1499723A53
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 21:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgLQVbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Dec 2020 16:31:22 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41855 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728336AbgLQVbW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Dec 2020 16:31:22 -0500
Received: from [192.168.0.8] (ip5f5aeed4.dynamic.kabel-deutschland.de [95.90.238.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5679C2000C03F;
        Thu, 17 Dec 2020 22:30:38 +0100 (CET)
Subject: Re: v5.10.1 xfs deadlock
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
 <20201217194317.GD2507317@bfoster>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <39b92850-f2ff-e4b6-0b2e-477ab3ec3c87@molgen.mpg.de>
Date:   Thu, 17 Dec 2020 22:30:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201217194317.GD2507317@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17.12.20 20:43, Brian Foster wrote:
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
>>
>> The system is low on free memory
>>
>>      MemTotal:       197587764 kB
>>      MemFree:          2196496 kB
>>      MemAvailable:   189895408 kB
>>
>> but responsive.
>>
>> I have an out of tree driver for the HBA ( smartpqi 2.1.6-005 pulled from linux-scsi) , but it is unlikely that this blocking is related to that, because the md block devices itself are responsive (`xxd /dev/md0` )
>>
>> I can keep the system in the state for a while. Is there an idea what was going from or an idea what data I could collect from the running system to help? I have full debug info and could walk lists or retrieve data structures with gdb.
>>
> 
> It might be useful to dump the values under /sys/fs/xfs/<dev>/log/* for
> each fs to get an idea of the state of the logs as well...


root@deadbird:~# for f in /sys/fs/xfs/*/log/*; do echo $f : $(cat $f);done
/sys/fs/xfs/md0/log/log_head_lsn : 5:714808
/sys/fs/xfs/md0/log/log_tail_lsn : 5:581592
/sys/fs/xfs/md0/log/reserve_grant_head : 5:365981696
/sys/fs/xfs/md0/log/write_grant_head : 5:365981696
/sys/fs/xfs/md1/log/log_head_lsn : 3:2963880
/sys/fs/xfs/md1/log/log_tail_lsn : 3:2772656
/sys/fs/xfs/md1/log/reserve_grant_head : 3:1517506560
/sys/fs/xfs/md1/log/write_grant_head : 3:1517506560
/sys/fs/xfs/sda1/log/log_head_lsn : 233:106253
/sys/fs/xfs/sda1/log/log_tail_lsn : 233:106251
/sys/fs/xfs/sda1/log/reserve_grant_head : 233:54403812
/sys/fs/xfs/sda1/log/write_grant_head : 233:54403812
/sys/fs/xfs/sda2/log/log_head_lsn : 84:5653
/sys/fs/xfs/sda2/log/log_tail_lsn : 84:5651
/sys/fs/xfs/sda2/log/reserve_grant_head : 84:2894336
/sys/fs/xfs/sda2/log/write_grant_head : 84:2894336



> 
> Brian
> 
>> Best
>>    Donald
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
