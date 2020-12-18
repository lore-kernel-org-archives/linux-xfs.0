Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C997DC4361B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 21:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A23123B7B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 21:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgLRVuA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 16:50:00 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:58790 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgLRVuA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 16:50:00 -0500
Received: from dread.disaster.area (pa49-181-255-32.pa.nsw.optusnet.com.au [49.181.255.32])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 749E310676B;
        Sat, 19 Dec 2020 08:49:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kqNch-000DzC-NE; Sat, 19 Dec 2020 08:49:15 +1100
Date:   Sat, 19 Dec 2020 08:49:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Donald Buczek <buczek@molgen.mpg.de>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: v5.10.1 xfs deadlock
Message-ID: <20201218214915.GA53382@dread.disaster.area>
References: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=TT2gYx/P4twmiiok1SQxOQ==:117 a=TT2gYx/P4twmiiok1SQxOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=pbPJX3KNAAAA:8 a=WWXfqoTBAAAA:8
        a=7-415B0cAAAA:8 a=n4V3cln1qZeQZ-Gr4-cA:9 a=CjuIK1q_8ugA:10
        a=oq68ferKVpmdzqj7Fr_q:22 a=G2uvcFSCWpQuK2C1375M:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 17, 2020 at 06:44:51PM +0100, Donald Buczek wrote:
> Dear xfs developer,
> 
> I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.
> 
> The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.
> 
> After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.
> 
>     root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
>     root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
>     root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
>     root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP
> 
> Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt
> 
> It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this
> 
>     [<0>] xfs_log_commit_cil+0x6cc/0x7c0
>     [<0>] __xfs_trans_commit+0xab/0x320
>     [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
>     [<0>] xfs_end_ioend+0xc6/0x110
>     [<0>] xfs_end_io+0xad/0xe0
>     [<0>] process_one_work+0x1dd/0x3e0
>     [<0>] worker_thread+0x2d/0x3b0
>     [<0>] kthread+0x118/0x130
>     [<0>] ret_from_fork+0x22/0x30
> 
> xfs_log_commit_cil+0x6cc is
> 
>   xfs_log_commit_cil()
>     xlog_cil_push_background(log)
>       xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
> 
> Some other threads, including the four "cp" commands are also blocking at xfs_log_commit_cil+0x6cc
> 
> There are also single "flush" process for each md device with this stack signature:
> 
>     [<0>] xfs_map_blocks+0xbf/0x400
>     [<0>] iomap_do_writepage+0x15e/0x880
>     [<0>] write_cache_pages+0x175/0x3f0
>     [<0>] iomap_writepages+0x1c/0x40
>     [<0>] xfs_vm_writepages+0x59/0x80
>     [<0>] do_writepages+0x4b/0xe0
>     [<0>] __writeback_single_inode+0x42/0x300
>     [<0>] writeback_sb_inodes+0x198/0x3f0
>     [<0>] __writeback_inodes_wb+0x5e/0xc0
>     [<0>] wb_writeback+0x246/0x2d0
>     [<0>] wb_workfn+0x26e/0x490
>     [<0>] process_one_work+0x1dd/0x3e0
>     [<0>] worker_thread+0x2d/0x3b0
>     [<0>] kthread+0x118/0x130
>     [<0>] ret_from_fork+0x22/0x30
> 
> xfs_map_blocks+0xbf is the
> 
>     xfs_ilock(ip, XFS_ILOCK_SHARED);
> 
> in xfs_map_blocks().

Can you post the entire dmesg output after running
'echo w > /proc/sysrq-trigger' to dump all the block threads to
dmesg?

> I have an out of tree driver for the HBA ( smartpqi 2.1.6-005
> pulled from linux-scsi) , but it is unlikely that this blocking is
> related to that, because the md block devices itself are
> responsive (`xxd /dev/md0` )

My bet is that the OOT driver/hardware had dropped a log IO on the
floor - XFS is waiting for the CIL push to complete, and I'm betting
that is stuck waiting for iclog IO completion while writing the CIL
to the journal. The sysrq output will tell us if this is the case,
so that's the first place to look.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
