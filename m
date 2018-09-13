Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:21842 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727277AbeIMJ13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Sep 2018 05:27:29 -0400
Date: Thu, 13 Sep 2018 14:19:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange XFS problem
Message-ID: <20180913041944.GA27618@dastard>
References: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Troels Hansen <th@casalogic.dk>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 12, 2018 at 10:07:55AM +0200, Troels Hansen wrote:
> Hi, we are facing an issue where we can't figure out if its XFS software related, or actually related to hardware, and can't quite figure out why we are facing the issues, though is doesn't seem hardware related.
> 
> The issue is with a 102Tb array on a Dell branded LSISAS 3508 (Perc H840).
> Running Ubuntu with a 4.15.0-32 (Ubuntu branded), but we have also been running a number of 4.4.0-x with the same issues.

Smells of an IO overload problem from that.

> The XFS filsusyem is on a very busy NFS server, and when the issue
> occurs we see strange issues with NFS, while the system seems
> healthy on the local server, but at the same time some programs
> are having problems accessing the fs.
> 
> It occure roughly every 14 days, where we have to restart the fs to come back fully working.

What happens on your network every 14 days or so? Is there a rogue
client side backup or admin task running somewhere?

> Sometimes refusing to unmount cleanly during shutdown, forcing us to fsck the fs on startup.

Unclean shutdown doesn't require fsck to be run.

> It looks like its hanging in xlog_grant_head_wait, but I don't know enough to determine what can make it hang there.
> 
> Hoping someone in here could have a look and point me in the right direction.
> 
> Below is a trace from the last crash we had:

Not a crash - it's a hung task warning.

> Sep  9 23:23:51 ged kernel: [1436769.178935] INFO: task mysqld:2847 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.178999]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.179047] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.179105] mysqld          D    0  2847      1 0x00000000
> Sep  9 23:23:51 ged kernel: [1436769.179111] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.179123]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.179127]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.179216]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179277]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179330]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179381]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179428]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179478]  xfs_vn_update_time+0x5d/0x160 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179486]  file_update_time+0xbe/0x110
> Sep  9 23:23:51 ged kernel: [1436769.179493]  ? tcp_recvmsg+0x317/0xab0
> Sep  9 23:23:51 ged kernel: [1436769.179542]  xfs_file_aio_write_checks+0x13a/0x180 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179588]  xfs_file_buffered_aio_write+0x89/0x2a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179632]  xfs_file_write_iter+0x103/0x150 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179637]  new_sync_write+0xe5/0x140
> Sep  9 23:23:51 ged kernel: [1436769.179641]  __vfs_write+0x29/0x40
> Sep  9 23:23:51 ged kernel: [1436769.179645]  vfs_write+0xb8/0x1b0
> Sep  9 23:23:51 ged kernel: [1436769.179649]  SyS_pwrite64+0x95/0xb0
> Sep  9 23:23:51 ged kernel: [1436769.179655]  do_syscall_64+0x73/0x130
> Sep  9 23:23:51 ged kernel: [1436769.179661]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
.....

Does this repeat every 120s?

These hung task warnings can happen if your workload has overloaded
your raid array and everything doing IO hangs while it catches up.
e.g. you have 6GB of random 4k writes in the controller NV cache and
it takes minutes for it to flush (because random 4k writes are slow)
and make room for new incoming IO....

If the warnings don't repeat, then it means it was a temporary
overload. If the warnings repeat, but change processes and stack
traces then it's a sustained overload condition. If exactly the same
warnings repeat and/or has stalled and doesn't restart, then we've
got some kind of hang occurring and we'll need to look into it
further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
