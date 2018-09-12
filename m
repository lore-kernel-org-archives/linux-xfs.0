Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42663 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbeILQDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 12:03:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id v17-v6so1537884wrr.9
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 03:59:42 -0700 (PDT)
Date: Wed, 12 Sep 2018 12:59:38 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Strange XFS problem
Message-ID: <20180912105938.jbziznvnrheldudj@odin.usersys.redhat.com>
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
> 
> The XFS filsusyem is on a very busy NFS server, and when the issue occurs we see strange issues with NFS, while the system seems healthy on the local server, but at the same time some programs are having problems accessing the fs.
> 
> It occure roughly every 14 days, where we have to restart the fs to come back fully working.
> Sometimes refusing to unmount cleanly during shutdown, forcing us to fsck the fs on startup.
> 
> It looks like its hanging in xlog_grant_head_wait, but I don't know enough to determine what can make it hang there.
> 
> Hoping someone in here could have a look and point me in the right direction.
> 
> Below is a trace from the last crash we had:

It's a long shot, but can't do much without more information. At first, your
filesystem is waiting for log space, so it could be your log is too small, your
storage is too slow and/or misconfigured, or maybe you you've been hitting a bug
somewhere!?

I don't remember any bug regarding log space issues or reservation problems
happening recently, but I don't use to work on log reservation issues by now,
so, maybe other can have more information if this might be any bug or not.

In the mean time, can you provide more information about the systems where you
are hitting this issue?

Mainle the storage configuration and the xfs_info output of the affected
filesystems.

FWIW:
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers

> 
> 
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
> Sep  9 23:23:51 ged kernel: [1436769.179664] RIP: 0033:0x7f16be838da3
> Sep  9 23:23:51 ged kernel: [1436769.179667] RSP: 002b:00007f148c31b950 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
> Sep  9 23:23:51 ged kernel: [1436769.179671] RAX: ffffffffffffffda RBX: 00007f148c31ba50 RCX: 00007f16be838da3
> Sep  9 23:23:51 ged kernel: [1436769.179673] RDX: 0000000000000200 RSI: 00007f149ea80200 RDI: 0000000000000008
> Sep  9 23:23:51 ged kernel: [1436769.179675] RBP: 00007f148c31bc00 R08: 000000000019d200 R09: 00007f148c31bc3c
> Sep  9 23:23:51 ged kernel: [1436769.179677] R10: 000000000019d200 R11: 0000000000000293 R12: 0000000000000200
> Sep  9 23:23:51 ged kernel: [1436769.179679] R13: 000000000019d200 R14: 0000000000000000 R15: 0000000000000000
> Sep  9 23:23:51 ged kernel: [1436769.179686] INFO: task nfsd:1937 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.179738]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.179784] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.179842] nfsd            D    0  1937      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.179846] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.179852]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.179857]  ? sch_direct_xmit+0x73/0x1b0
> Sep  9 23:23:51 ged kernel: [1436769.179860]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.179910]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.179956]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180005]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180051]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180096]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180145]  xfs_vn_update_time+0x5d/0x160 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180150]  file_update_time+0xbe/0x110
> Sep  9 23:23:51 ged kernel: [1436769.180199]  xfs_file_aio_write_checks+0x13a/0x180 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180244]  xfs_file_buffered_aio_write+0x89/0x2a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180248]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.180291]  xfs_file_write_iter+0x103/0x150 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180295]  do_iter_readv_writev+0x111/0x180
> Sep  9 23:23:51 ged kernel: [1436769.180299]  do_iter_write+0x87/0x1a0
> Sep  9 23:23:51 ged kernel: [1436769.180302]  vfs_iter_write+0x19/0x30
> Sep  9 23:23:51 ged kernel: [1436769.180321]  nfsd_vfs_write+0xbe/0x380 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180338]  nfsd4_write+0x16c/0x1a0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180352]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180365]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180395]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.180416]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.180428]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180434]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.180445]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.180451]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.180456]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.180461] INFO: task nfsd:1938 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.180511]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.180557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.180615] nfsd            D    0  1938      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.180619] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.180623]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.180628]  ? sch_direct_xmit+0x73/0x1b0
> Sep  9 23:23:51 ged kernel: [1436769.180631]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.180689]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180737]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180786]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180832]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180876]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180926]  xfs_vn_update_time+0x5d/0x160 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.180931]  file_update_time+0xbe/0x110
> Sep  9 23:23:51 ged kernel: [1436769.180980]  xfs_file_aio_write_checks+0x13a/0x180 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181025]  xfs_file_buffered_aio_write+0x89/0x2a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181029]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.181073]  xfs_file_write_iter+0x103/0x150 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181077]  do_iter_readv_writev+0x111/0x180
> Sep  9 23:23:51 ged kernel: [1436769.181080]  do_iter_write+0x87/0x1a0
> Sep  9 23:23:51 ged kernel: [1436769.181083]  vfs_iter_write+0x19/0x30
> Sep  9 23:23:51 ged kernel: [1436769.181101]  nfsd_vfs_write+0xbe/0x380 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181117]  nfsd4_write+0x16c/0x1a0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181131]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181143]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181169]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.181189]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.181200]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181206]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.181217]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181222]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.181228]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.181233] INFO: task nfsd:1939 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.181282]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.181328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.181385] nfsd            D    0  1939      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.181389] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.181394]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.181398]  ? sch_direct_xmit+0x73/0x1b0
> Sep  9 23:23:51 ged kernel: [1436769.181401]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.181455]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181503]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181551]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181599]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181643]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181692]  xfs_vn_update_time+0x5d/0x160 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181698]  file_update_time+0xbe/0x110
> Sep  9 23:23:51 ged kernel: [1436769.181747]  xfs_file_aio_write_checks+0x13a/0x180 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181792]  xfs_file_buffered_aio_write+0x89/0x2a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181796]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.181839]  xfs_file_write_iter+0x103/0x150 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.181843]  do_iter_readv_writev+0x111/0x180
> Sep  9 23:23:51 ged kernel: [1436769.181846]  do_iter_write+0x87/0x1a0
> Sep  9 23:23:51 ged kernel: [1436769.181849]  vfs_iter_write+0x19/0x30
> Sep  9 23:23:51 ged kernel: [1436769.181864]  nfsd_vfs_write+0xbe/0x380 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181880]  nfsd4_write+0x16c/0x1a0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181894]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181906]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181930]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.181951]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.181962]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181967]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.181978]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.181984]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.181988]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.181993] INFO: task nfsd:1940 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.182041]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.182088] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.182146] nfsd            D    0  1940      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.182149] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.182153]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.182158]  ? __switch_to_asm+0x40/0x70
> Sep  9 23:23:51 ged kernel: [1436769.182162]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.182213]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182259]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182308]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182354]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182398]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182448]  xfs_setattr_nonsize+0x242/0x5a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182494]  xfs_vn_setattr_nonsize+0x42/0x90 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182539]  xfs_vn_setattr+0x66/0xa0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.182544]  notify_change+0x2e1/0x410
> Sep  9 23:23:51 ged kernel: [1436769.182558]  nfsd_setattr+0x390/0x4f0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182562]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.182577]  nfsd4_setattr+0x10e/0x140 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182591]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182603]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182626]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.182646]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.182657]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182662]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.182673]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.182710]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.182715]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.182720] INFO: task nfsd:1941 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.182771]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.182820] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.182884] nfsd            D    0  1941      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.182897] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.182905]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.182914]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.182972]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183022]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183075]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183126]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183174]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183229]  xfs_create+0x1bf/0x6b0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183239]  ? get_acl+0x1d/0x100
> Sep  9 23:23:51 ged kernel: [1436769.183248]  ? posix_acl_create+0x109/0x160
> Sep  9 23:23:51 ged kernel: [1436769.183300]  xfs_generic_create+0x21a/0x2f0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183350]  xfs_vn_mknod+0x14/0x20 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183396]  xfs_vn_create+0x13/0x20 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183405]  vfs_create+0x12d/0x190
> Sep  9 23:23:51 ged kernel: [1436769.183424]  do_nfsd_create+0x43f/0x580 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183446]  nfsd4_open+0x20c/0x730 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183466]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183482]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183509]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.183535]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.183553]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183562]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.183578]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.183588]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.183596]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.183607] INFO: task nfsd:1942 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.183657]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.183703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.183760] nfsd            D    0  1942      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.183763] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.183768]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.183772]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.183823]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183870]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183917]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.183964]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184008]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184056]  xfs_setattr_nonsize+0x242/0x5a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184077]  ? nfsd_setuser+0x11f/0x2b0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184127]  xfs_vn_setattr_nonsize+0x42/0x90 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184174]  xfs_vn_setattr+0x66/0xa0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184184]  ? current_time+0x32/0x70
> Sep  9 23:23:51 ged kernel: [1436769.184194]  notify_change+0x2e1/0x410
> Sep  9 23:23:51 ged kernel: [1436769.184212]  nfsd_setattr+0x390/0x4f0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184222]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.184241]  nfsd4_setattr+0x10e/0x140 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184260]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184278]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184306]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.184330]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.184345]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184356]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.184374]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.184384]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.184395]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.184406] INFO: task nfsd:1943 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.184460]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.184508] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.184565] nfsd            D    0  1943      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.184568] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.184572]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.184577]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.184628]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184673]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184721]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184768]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184812]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184867]  xfs_setattr_nonsize+0x242/0x5a0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184918]  xfs_vn_setattr_nonsize+0x42/0x90 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184966]  xfs_vn_setattr+0x66/0xa0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.184977]  notify_change+0x2e1/0x410
> Sep  9 23:23:51 ged kernel: [1436769.184997]  nfsd_setattr+0x390/0x4f0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185004]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.185020]  nfsd4_setattr+0x10e/0x140 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185034]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185046]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185074]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.185098]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.185113]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185119]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.185135]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185143]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.185151]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.185156] INFO: task nfsd:1944 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.185205]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.185251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.185308] nfsd            D    0  1944      2 0x80000000
> Sep  9 23:23:51 ged kernel: [1436769.185311] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.185315]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.185321]  ? __slab_free+0xb2/0x2f0
> Sep  9 23:23:51 ged kernel: [1436769.185324]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.185374]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185420]  xlog_grant_head_check+0xf1/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185467]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185513]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185556]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185606]  xfs_rename+0x133/0xab0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185610]  ? _cond_resched+0x1a/0x50
> Sep  9 23:23:51 ged kernel: [1436769.185614]  ? sort+0x165/0x250
> Sep  9 23:23:51 ged kernel: [1436769.185618]  ? iter_div_u64_rem+0x20/0x20
> Sep  9 23:23:51 ged kernel: [1436769.185665]  xfs_vn_rename+0xd4/0x150 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.185670]  vfs_rename+0x6a5/0x8c0
> Sep  9 23:23:51 ged kernel: [1436769.185675]  ? lookup_one_len+0xf5/0x120
> Sep  9 23:23:51 ged kernel: [1436769.185689]  nfsd_rename+0x359/0x3a0 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185705]  nfsd4_rename+0x6e/0x190 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185719]  nfsd4_proc_compound+0x33c/0x630 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185731]  nfsd_dispatch+0xbb/0x250 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185753]  svc_process_common+0x380/0x690 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.185773]  svc_process+0xfa/0x1c0 [sunrpc]
> Sep  9 23:23:51 ged kernel: [1436769.185785]  nfsd+0xe9/0x150 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185790]  kthread+0x105/0x140
> Sep  9 23:23:51 ged kernel: [1436769.185801]  ? nfsd_destroy+0x60/0x60 [nfsd]
> Sep  9 23:23:51 ged kernel: [1436769.185807]  ? kthread_destroy_worker+0x50/0x50
> Sep  9 23:23:51 ged kernel: [1436769.185812]  ret_from_fork+0x35/0x40
> Sep  9 23:23:51 ged kernel: [1436769.185830] INFO: task bacula-fd:24743 blocked for more than 120 seconds.
> Sep  9 23:23:51 ged kernel: [1436769.185881]       Not tainted 4.15.0-32-generic #35~16.04.1-Ubuntu
> Sep  9 23:23:51 ged kernel: [1436769.185927] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Sep  9 23:23:51 ged kernel: [1436769.185983] bacula-fd       D    0 24743      1 0x00000000
> Sep  9 23:23:51 ged kernel: [1436769.185987] Call Trace:
> Sep  9 23:23:51 ged kernel: [1436769.185991]  __schedule+0x3d6/0x8b0
> Sep  9 23:23:51 ged kernel: [1436769.185995]  schedule+0x36/0x80
> Sep  9 23:23:51 ged kernel: [1436769.186045]  xlog_grant_head_wait+0xb8/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186090]  xlog_grant_head_check+0x94/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186136]  xfs_log_reserve+0xcb/0x1e0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186182]  xfs_trans_reserve+0x169/0x1d0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186225]  xfs_trans_alloc+0xbe/0x130 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186274]  xfs_vn_update_time+0x5d/0x160 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186279]  touch_atime+0xb2/0xe0
> Sep  9 23:23:51 ged kernel: [1436769.186286]  generic_file_read_iter+0x93a/0xba0
> Sep  9 23:23:51 ged kernel: [1436769.186292]  ? page_cache_tree_insert+0xe0/0xe0
> Sep  9 23:23:51 ged kernel: [1436769.186341]  xfs_file_buffered_aio_read+0x5d/0x100 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186385]  xfs_file_read_iter+0x68/0xc0 [xfs]
> Sep  9 23:23:51 ged kernel: [1436769.186389]  new_sync_read+0xe2/0x130
> Sep  9 23:23:51 ged kernel: [1436769.186393]  __vfs_read+0x29/0x40
> Sep  9 23:23:51 ged kernel: [1436769.186396]  vfs_read+0x93/0x130
> Sep  9 23:23:51 ged kernel: [1436769.186399]  SyS_read+0x55/0xc0
> Sep  9 23:23:51 ged kernel: [1436769.186405]  do_syscall_64+0x73/0x130
> Sep  9 23:23:51 ged kernel: [1436769.186409]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Sep  9 23:23:51 ged kernel: [1436769.186412] RIP: 0033:0x7f919219b51d
> Sep  9 23:23:51 ged kernel: [1436769.186414] RSP: 002b:00007f918d90c9a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
> Sep  9 23:23:51 ged kernel: [1436769.186418] RAX: ffffffffffffffda RBX: 00007f917c00b1a0 RCX: 00007f919219b51d
> Sep  9 23:23:51 ged kernel: [1436769.186420] RDX: 0000000000010000 RSI: 00007f917c00c8c0 RDI: 000000000000000e
> Sep  9 23:23:51 ged kernel: [1436769.186422] RBP: 00007f917e12de68 R08: 000000000000000a R09: 0000000000000000
> Sep  9 23:23:51 ged kernel: [1436769.186424] R10: 0000000000000000 R11: 0000000000000293 R12: 00007f917c096308
> Sep  9 23:23:51 ged kernel: [1436769.186426] R13: 00007f917c00bfa8 R14: 00007f917c00b1a0 R15: 00007f917e12de68
> 

-- 
Carlos
