Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B2EFC35240
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 03:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E0024656
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 03:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgA1Dvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:51:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41788 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbgA1Dvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 22:51:32 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E0B2A3A2438;
        Tue, 28 Jan 2020 14:51:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwHuR-0006tc-AQ; Tue, 28 Jan 2020 14:51:27 +1100
Date:   Tue, 28 Jan 2020 14:51:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Some tasks got to hang_task in XFS
Message-ID: <20200128035127.GC18610@dread.disaster.area>
References: <CAMym5wu+ypVDQbyFRrjpqCRKyovpT=nitF4O8VNuspDv5rsd-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMym5wu+ypVDQbyFRrjpqCRKyovpT=nitF4O8VNuspDv5rsd-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=_BlDLN3NAAAA:20 a=4u6H09k7AAAA:8 a=7-415B0cAAAA:8
        a=4t_MpNofPte4Nk4gjJYA:9 a=CjuIK1q_8ugA:10 a=5yerskEF2kbSkDMynNst:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 12:37:55PM +0900, Satoru Takeuchi wrote:
> In Rook(*1)/Ceph community, some users encountered hang_task in XFS.
> Although we've not reproduced this problem in the newest kernel, could anyone
> give us any hint about this problem, if possible?
> 
> *1) An Ceph orchestration in Kubernetes
> 
> Here is the detail.
> 
> Under some workload in Ceph, many processes got to hang_task. We found
> that there
> are two kinds of processes.
> 
> a) In very high CPU load
> b) Encountered hang_task in the XFS
> 
> In addition,a user got the following two kernel traces.
> 
> A (b) process's backtrace with `hung_task_panic=1`.
> 
> ```
> [51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 seconds.
> [51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu

Kinda old, and not an upstream LTS kernel, right?

> [51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [51717.039426] kworker/2:1     D    0  5938      2 0x80000000
> [51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]

Filesystem is on a Ceph RBD device.

> [51717.039472] Call Trace:
> [51717.039478]  __schedule+0x24e/0x880
> [51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
> [51717.039506]  schedule+0x2c/0x80
> [51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
> [51717.039533]  ? wake_up_q+0x80/0x80
> [51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
> [51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
> [51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
> [51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
> [51717.039626]  process_one_work+0x1de/0x420
> [51717.039627]  worker_thread+0x32/0x410
> [51717.039628]  kthread+0x121/0x140
> [51717.039630]  ? process_one_work+0x420/0x420
> [51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
> [51717.039633]  ret_from_fork+0x35/0x40

That's waiting for log IO completion.

> ```
> 
> A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
> process>/stack`
> 
> ```
> [<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
> [<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
> [<0>] xfs_trans_commit+0x10/0x20 [xfs]
> [<0>] xfs_sync_sb+0x6d/0x80 [xfs]
> [<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
> [<0>] xfs_unmountfs+0xe7/0x200 [xfs]
> [<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
> [<0>] generic_shutdown_super+0x72/0x120
> [<0>] kill_block_super+0x2c/0x80
> [<0>] deactivate_locked_super+0x48/0x80
> [<0>] deactivate_super+0x40/0x60
> [<0>] cleanup_mnt+0x3f/0x80
> [<0>] __cleanup_mnt+0x12/0x20
> [<0>] task_work_run+0x9d/0xc0
> [<0>] exit_to_usermode_loop+0xc0/0xd0
> [<0>] do_syscall_64+0x121/0x130
> [<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [<0>] 0xffffffffffffffff

ANd this is the last reference to the filesystem being dropped and
it waiting for log IO completion.

So, the filesytem has been unmounted, and it's waiting for journal
IO on the device to complete.  I wonder if a wakeup was missed
somewhere?

Did the system stop/tear down /dev/rbd0 prematurely?

> Related discussions:
> - Issue of Rook:
>   https://github.com/rook/rook/issues/3132
> - Issue of Ceph
>   https://tracker.ceph.com/issues/40068

These point to Ceph RBDs failing to respond under high load and
tasks hanging because they are waiting on IO. That's exactly the
symptoms you are reporting here. That points to it being a Ceph RBD
issue to me, especially the reports where rbd devices report no IO
load but the ceph back end is at 100% disk utilisation doing
-something-.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
