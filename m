Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 778497F61
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 05:14:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 641E5304039
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 03:14:46 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 056kFZQI4W12OuFs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Mar 2013 03:14:44 -0700 (PDT)
Message-ID: <51517506.1020906@oracle.com>
Date: Tue, 26 Mar 2013 18:14:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [ASSERT failure] transaction reservations changes bad?
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
	<513F0C07.1060000@oracle.com> <513F17F3.1010204@oracle.com>
	<20130312120545.GO21651@dastard>
In-Reply-To: <20130312120545.GO21651@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/12/2013 08:05 PM, Dave Chinner wrote:
> On Tue, Mar 12, 2013 at 07:56:35PM +0800, Jeff Liu wrote:
>> More info, 3.7.0 is the oldest kernel on my environment, I ran into the
>> same problem.
> 
> Thanks for following up so quickly, Jeff. So the problem is that a
> new test is tripping over a bug that has been around for a while,
> not that it is a new regression.
> 
> OK, so I'll expunge that from my testing for the moment as I don't
> ahve time to dig in and find out what the cause is right now. If
> anyone else wants to.... :)

I did some further tests to nail down this issue, just posting the analysis result here,
it might be of some use when we revising it again.

The disk is formated with Dave's previous comments, i.e.
mkfs.xfs -f -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b /dev/xxx

First of all, looks this bug stayed in hiding for years since I can reproduce it between upstream
3.0 to 3.9.0-rc3, the oldest kernel I have tried is 2.6.39 which has the same problem.

The following tests are running against kernel with CONFIG_XFS_DEBUG is enabled.

1) Create directory will cause kernel panic, observed same info to Dave's previous posts.

[ 3846.705416] XFS: Assertion failed: BTOBB(need_bytes) < log->l_logBBsize, file: fs/xfs/xfs_log.c, line:
[ 3846.705444] ------------[ cut here ]------------
[ 3846.705447] kernel BUG at fs/xfs/xfs_message.c:100!
[ 3846.705450] invalid opcode: 0000 [#1] SMP [ 3846.705454] Modules linked in: xfs(O) libcrc32c ........
[ 3846.705487] CPU 0 [ 3846.705493] Pid: 2188, comm: mkdir Tainted: G           O 3.9.0-rc3 #1 innotek GmbH VirtualBox
[ 3846.705496] RIP: 0010:[<ffffffffa021d632>]  [<ffffffffa021d632>] assfail+0x22/0x30 [xfs]
[ 3846.705534] RSP: 0018:ffff880079d61c78  EFLAGS: 00010296
[ 3846.705537] RAX: 000000000000005f RBX: ffff880079c1b800 RCX: 0000000000000006
[ 3846.705539] RDX: 0000000000000007 RSI: 0000000000000007 RDI: 0000000000000246
[ 3846.705542] RBP: ffff880079d61c78 R08: 000000000000000a R09: 0000000000000000
[ 3846.705544] R10: 0000000000000245 R11: 0000000000000244 R12: ffff880079c1b9d8
[ 3846.705547] R13: 0000000000000dcb R14: 0000000000000003 R15: 00000000000111b8
[ 3846.705550] FS:  00007f4da7f317c0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[ 3846.705553] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3846.705556] CR2: 00000000004044d0 CR3: 00000000793fd000 CR4: 00000000000006f0
[ 3846.705570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3846.705573] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3846.705576] Process mkdir (pid: 2188, threadinfo ffff880079d60000, task ffff880030270000)
[ 3846.705578] Stack:
[ 3846.705581]  ffff880079d61cb8 ffffffffa0275ecb ffffffffa0225cd7 ffffffffa0298210
[ 3846.705586]  0000000000000007 ffff880079bdb730 ffff880079c1b800 0000000000000001
[ 3846.705591]  ffff880079d61d18 ffffffffa0277f48 ffff880079d61d18 ffff880079dd3040
[ 3846.705595] Call Trace:
[ 3846.705634]  [<ffffffffa0275ecb>] xlog_grant_push_ail+0x8b/0x1c0 [xfs]
[ 3846.705663]  [<ffffffffa0225cd7>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
[ 3846.705698]  [<ffffffffa0277f48>] xfs_log_reserve+0x208/0x3e0 [xfs]
[ 3846.705731]  [<ffffffffa0273747>] xfs_trans_reserve+0x327/0x360 [xfs]
[ 3846.705762]  [<ffffffffa02731c7>] ? _xfs_trans_alloc+0x37/0xa0 [xfs]
[ 3846.705790]  [<ffffffffa0222c34>] xfs_create+0x184/0x6f0 [xfs]
[ 3846.705816]  [<ffffffffa021ae4b>] xfs_vn_mknod+0xcb/0x1e0 [xfs]
[ 3846.705841]  [<ffffffffa021af76>] xfs_vn_mkdir+0x16/0x20 [xfs]
[ 3846.705850]  [<ffffffff811a3f77>] vfs_mkdir+0xa7/0x120
[ 3846.705856]  [<ffffffff811a497b>] sys_mkdirat+0xab/0xf0
[ 3846.705861]  [<ffffffff811a49d9>] sys_mkdir+0x19/0x20
[ 3846.705869]  [<ffffffff816a5dd9>] system_call_fastpath+0x16/0x1b
[ 3846.705871] Code: e8 f4 fb ff ff 0f 0b 66 90 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 0
[ 3846.705918] RIP  [<ffffffffa021d632>] assfail+0x22/0x30 [xfs]
[ 3846.705943]  RSP <ffff880079d61c78>
[ 3846.705948] ---[ end trace 7b3a9ee81a9920f1 ]---


2) For a refreshed formated XFS partition, create a regular file via `touch /xfs/test_file`, the process
will hang and the following syslog were observed:

Mar 26 14:15:35 linux64bit kernel: [  841.804353] INFO: task kworker/0:2:2118 blocked for more than 120 seconds.
Mar 26 14:15:35 linux64bit kernel: [  841.804361] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 26 14:15:35 linux64bit kernel: [  841.804364] kworker/0:2     D ffffffff8180cfa0     0  2118      2 0x00000000
Mar 26 14:15:35 linux64bit kernel: [  841.804372]  ffff880079bfdc18 0000000000000046 ffff880076bdc5c0 0000000000014e40
Mar 26 14:15:35 linux64bit kernel: [  841.804378]  ffff880062b31720 ffff880079bfdfd8 ffff880079bfdfd8 ffff880079bfdfd8
Mar 26 14:15:35 linux64bit kernel: [  841.804382]  ffffffff81c13440 ffff880062b31720 ffff880079bfdc38 ffff880079165cf0
Mar 26 14:15:35 linux64bit kernel: [  841.804387] Call Trace:
Mar 26 14:15:35 linux64bit kernel: [  841.804400]  [<ffffffff8169c399>] schedule+0x29/0x70
Mar 26 14:15:35 linux64bit kernel: [  841.804444]  [<ffffffffa037e15a>] xlog_grant_head_wait+0x15a/0x2b0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804466]  [<ffffffff81692bf3>] ? printk+0x61/0x63
Mar 26 14:15:35 linux64bit kernel: [  841.804500]  [<ffffffffa037e414>] xlog_grant_head_check+0x164/0x1d0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804530]  [<ffffffffa037ff8e>] xfs_log_reserve+0x24e/0x3e0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804561]  [<ffffffffa037b747>] xfs_trans_reserve+0x327/0x360 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804589]  [<ffffffffa032dd84>] ? kmem_zone_zalloc+0x34/0x50 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804613]  [<ffffffffa031bbb0>] xfs_fs_log_dummy+0x80/0x130 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804643]  [<ffffffffa0381524>] xfs_log_worker+0x54/0x120 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804650]  [<ffffffff8107805b>] process_one_work+0x16b/0x400
Mar 26 14:15:35 linux64bit kernel: [  841.804655]  [<ffffffff81078ce9>] worker_thread+0x119/0x360
Mar 26 14:15:35 linux64bit kernel: [  841.804660]  [<ffffffff81078bd0>] ? manage_workers+0x350/0x350
Mar 26 14:15:35 linux64bit kernel: [  841.804665]  [<ffffffff8107e200>] kthread+0xc0/0xd0
Mar 26 14:15:35 linux64bit kernel: [  841.804669]  [<ffffffff8107e140>] ? flush_kthread_worker+0xb0/0xb0
Mar 26 14:15:35 linux64bit kernel: [  841.804675]  [<ffffffff816a5d2c>] ret_from_fork+0x7c/0xb0
Mar 26 14:15:35 linux64bit kernel: [  841.804679]  [<ffffffff8107e140>] ? flush_kthread_worker+0xb0/0xb0
Mar 26 14:15:35 linux64bit kernel: [  841.804685] INFO: task touch:2323 blocked for more than 120 seconds.
Mar 26 14:15:35 linux64bit kernel: [  841.804687] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 26 14:15:35 linux64bit kernel: [  841.804689] touch           D ffffffff8180cfa0     0  2323   2128 0x00000000
Mar 26 14:15:35 linux64bit kernel: [  841.804694]  ffff8800791419b8 0000000000000086 ffff880076bdc5c0 0000000000014e40
Mar 26 14:15:35 linux64bit kernel: [  841.804699]  ffff88003032ae40 ffff880079141fd8 ffff880079141fd8 ffff880079141fd8
Mar 26 14:15:35 linux64bit kernel: [  841.804703]  ffffffff81c13440 ffff88003032ae40 ffff8800791419d8 ffff880079993000
Mar 26 14:15:35 linux64bit kernel: [  841.804707] Call Trace:
Mar 26 14:15:35 linux64bit kernel: [  841.804713]  [<ffffffff8169c399>] schedule+0x29/0x70
Mar 26 14:15:35 linux64bit kernel: [  841.804740]  [<ffffffffa037e15a>] xlog_grant_head_wait+0x15a/0x2b0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804745]  [<ffffffff81692bf3>] ? printk+0x61/0x63
Mar 26 14:15:35 linux64bit kernel: [  841.804772]  [<ffffffffa037e461>] xlog_grant_head_check+0x1b1/0x1d0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804798]  [<ffffffffa037ff8e>] xfs_log_reserve+0x24e/0x3e0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804826]  [<ffffffffa037b747>] xfs_trans_reserve+0x327/0x360 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804854]  [<ffffffffa032ac34>] xfs_create+0x184/0x6f0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804880]  [<ffffffffa0322e4b>] xfs_vn_mknod+0xcb/0x1e0 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804904]  [<ffffffffa0322f93>] xfs_vn_create+0x13/0x20 [xfs]
Mar 26 14:15:35 linux64bit kernel: [  841.804913]  [<ffffffff811a29c5>] vfs_create+0xb5/0x130
Mar 26 14:15:35 linux64bit kernel: [  841.804918]  [<ffffffff811a37ca>] do_last+0xd8a/0xec0
Mar 26 14:15:35 linux64bit kernel: [  841.804926]  [<ffffffff812fe01c>] ? apparmor_file_alloc_security+0x2c/0x60
Mar 26 14:15:35 linux64bit kernel: [  841.804932]  [<ffffffff811a39b8>] path_openat+0xb8/0x4c0
Mar 26 14:15:35 linux64bit kernel: [  841.804937]  [<ffffffff81158741>] ? handle_mm_fault+0x271/0x390
Mar 26 14:15:35 linux64bit kernel: [  841.804943]  [<ffffffff811a4552>] do_filp_open+0x42/0xa0
Mar 26 14:15:35 linux64bit kernel: [  841.804949]  [<ffffffff811b1675>] ? __alloc_fd+0xe5/0x170
Mar 26 14:15:35 linux64bit kernel: [  841.804955]  [<ffffffff811941de>] do_sys_open+0xfe/0x1e0
Mar 26 14:15:35 linux64bit kernel: [  841.804960]  [<ffffffff811942e1>] sys_open+0x21/0x30
Mar 26 14:15:35 linux64bit kernel: [  841.804966]  [<ffffffff816a5dd9>] system_call_fastpath+0x16/0x1b

It most likely a deadlock or dead loop was occurred according to above tracing info.
Then I did some investigation to check what had happened in transaction log space reservations
between mount a refreshed formated XFS partition and create a new file by adding some debugging code.

As per the current disk formating, the totally log space is 2560 * 1024 = 2621440 bytes.
By default, there are 1310720 bytes free space on both l_reserve_head.grant and l_write_head.grant separately.

Firstly, I observed a non-permanent CIL ticket allocation at xlog_cil_init_post_recovery() for xfs_log_mount(),
and it has no affect to our situation.

Secondly, xfs_vn_update_time() is invoked per mount the partition, and hence the XFS_TRANS_FSYNC_TS transaction
was happened, it need 532916 bytes for the space reservation, then give back 208 bytes at xlog_ungrant_log_space()
after xfs_trans_commit().  Therefore, it only reserved (532916 - 208) bytes in this transaction, now there has
1310720 - (532916 - 208) = 778012 bytes left at l_reserve_head.grant.

Finally, creating a file will make XFS_TRANS_CREATE happened, and it need to reserve 1205208 bytes, however, there
only has 778012 bytes can be reserved, so that the process hang at the loop of xlog_grant_head_wait() and then call
schedule() to let other processes wake up and running.

In this situation, xfs_log_worker() will up and running, as this is the 1st time it was issued, the call chains was
shown as following:
........
......
xlog_log_force()
  __xfs_log_force() -> xfs_sync()
    xlog_cil_force_lsn()
      xlog_cil_push()
        xlog_log_done()
          xlog_ungrant_log_space()
	    xlog_log_space_wake()
	      xlog_grant_head_wake()...

Up to now, there should left 1306396 bytes in l_reserve_head.grant since I observed this CHECKPOINT transaction
gave back 528384 bytes at xlog_ungrant_log_space(), so that 528384 + 778012 = 1306396 bytes, but that's is not
exactly, because it reserved 257820 bytes at xfs_sync(), so the left space is 1306396 - 257820 = 1048576 bytes.

Once xfs_log_worker() run completed, the previous XFS_TRANS_CREATE is revived at the point after schedule(),
but the free space(1048576) is less than the required(1205208), as a result, it got blocked again.

Periodicity, xfs_log_worker() comes up, but this time it gone through XFS_TRANS_DUMMY instead.  In this case, the
current free space is enough for this reservations because it requires 533172 bytes only, however, it also hang at
the point of xlog_grant_head_wait() before schedule() because there only has one log transaction related process
belong to the file creation would be scheduled, but this process will be blocked again due to the lack of log space.

The question is that even if XFS_TRANS_DUMMY was not got involved, XFS_TRANS_CREATE would still be blocked as the log
space reservation can not be satisfied.  IMHO, looks the major cause is related to the 'sunit' parameter, since it would
affect the log space unit calculations by '2*log->l_mp->m_sb.sb_logsunit' at xlog_ticket_alloc().  However, we don't include
this factor into consideration at mkfs or mount stage, should we take it into account?


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
