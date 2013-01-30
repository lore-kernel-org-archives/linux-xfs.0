Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A1ED7F4E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 21:16:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D019130404E
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 19:16:25 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id ftBE4rW7tEIL44dE for
	<xfs@oss.sgi.com>; Tue, 29 Jan 2013 19:16:20 -0800 (PST)
Message-ID: <42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
Date: Tue, 29 Jan 2013 22:16:20 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130129151833.GF27055@sgi.com>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi all,

I've update the CentOS bug (http://bugs.centos.org/view.php?id=6217) with
the following information:


-- More detail about the hang including traceback --

Using 5.9 kernel (348) without md raid:
Please stand by while rebooting the system...
md: stopping all md devices.
Synchronizing SCSI cache for disk sda:
Restarting system.
..
machine restart
(reboots normally)


With md raid1:
Unmounting pipe file systems:
Unmounting file systems:
Please stand by while rebooting the system...
md: stopping all md devices.
md: md2 switched to read-only mode.
md: md1 switched to read-only mode.
(hang)

Traceback:
INFO: task reboot:2063 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
reboot        D ffff810037df37e0     0  2063      1                  19
(NOTLB)
 ffff81005890ba08 0000000000000082 ffff81005890ba58 ffff81005beb1ea0
 0000000000000001 0000000000000007 ffff810058d67040 ffff810037df37e0
 000000596dd8a1e6 0000000000003df4 ffff810058d67228 000000008008d76f
Call Trace:
 [<ffffffff8002e4bc>] __wake_up+0x38/0x4f
 [<ffffffff80223bce>] md_write_start+0xf2/0x108
 [<ffffffff800a3bc2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000ab62>] get_page_from_freelist+0x380/0x442
 [<ffffffff880b102c>] :raid1:make_request+0x38/0x5d8
 [<ffffffff8001c839>] generic_make_request+0x211/0x228
 [<ffffffff8002389f>] mempool_alloc+0x31/0xe7
 [<ffffffff8001a98f>] vsnprintf+0x5d7/0xb54
 [<ffffffff80033695>] submit_bio+0xe6/0xed
 [<ffffffff8807f801>] :xfs:_xfs_buf_ioapply+0x1f2/0x254
 [<ffffffff8807f89c>] :xfs:xfs_buf_iorequest+0x39/0x64
 [<ffffffff8808386c>] :xfs:xfs_bdstrat_cb+0x36/0x3a
 [<ffffffff8807c0a8>] :xfs:xfs_bwrite+0x5e/0xba
 [<ffffffff88077669>] :xfs:xfs_syncsub+0x119/0x226
 [<ffffffff88084ce2>] :xfs:xfs_fs_sync_super+0x33/0xdd
 [<ffffffff8010aa44>] quota_sync_sb+0x2e/0xf0
 [<ffffffff800e55bd>] __fsync_super+0x1b/0x9e
 [<ffffffff800e578a>] fsync_super+0x9/0x16
 [<ffffffff800e57c1>] fsync_bdev+0x2a/0x3b
 [<ffffffff8014ea59>] invalidate_partition+0x28/0x40
 [<ffffffff802225a8>] do_md_stop+0xa0/0x2ec
 [<ffffffff80224d41>] md_notify_reboot+0x5f/0x120
 [<ffffffff80067565>] notifier_call_chain+0x20/0x32
 [<ffffffff8009de98>] blocking_notifier_call_chain+0x22/0x36
 [<ffffffff8009e220>] kernel_restart_prepare+0x18/0x29
 [<ffffffff8009e280>] kernel_restart+0x9/0x46
 [<ffffffff8009e40a>] sys_reboot+0x146/0x1c7
 [<ffffffff8003b291>] hrtimer_try_to_cancel+0x4a/0x53
 [<ffffffff8005a753>] hrtimer_cancel+0xc/0x16
 [<ffffffff80063cf9>] do_nanosleep+0x47/0x70
 [<ffffffff8005a640>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff800a5b84>] hrtimer_wakeup+0x0/0x22
 [<ffffffff8001e2f2>] sigprocmask+0xb7/0xdb
 [<ffffffff80054fe6>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005d116>] system_call+0x7e/0x83


Filesystem            Size  Used Avail Use% Mounted on
/dev/md3              4.9G  784M  4.2G  16% /
/dev/md2              108M   11M   97M  11% /boot
tmpfs                 689M     0  689M   0% /dev/shm

[root@test9][/root]# swapon -s
Filename                                Type            Size    Used   
Priority
/dev/md1                                partition       2947832 0       -1


[root@test9][/root]# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sdb1[1] sda1[0]
      128384 blocks [2/2] [UU]

md1 : active raid1 sdb2[1] sda2[0]
      2947840 blocks [2/2] [UU]

md3 : active raid1 sdb3[1] sda3[0]
      5116608 blocks [2/2] [UU]

unused devices: <none>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
