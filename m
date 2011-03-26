Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2QDQUt3052106 for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 08:26:30 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 741A11DF6940
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2011 06:29:36 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with SMTP id BzE09E3V6KQwOX0Z for
	<xfs@oss.sgi.com>; Sat, 26 Mar 2011 06:29:36 -0700 (PDT)
Date: Sat, 26 Mar 2011 09:29:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 2.6.38.1: CPU#0 stuck for 67s! / xfs_ail_splice
Message-ID: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi,

When I rm -rf a directory of a few hundred thousand files/directories on 
XFS under 2.6.38.1, I see the following, is this normal?

[69501.486071] BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:2:19517]
[69501.486074] Modules linked in: tcp_diag inet_diag sata_mv
[69501.486077] CPU 0
[69501.486078] Modules linked in: tcp_diag inet_diag sata_mv
[69501.486080]
[69501.486081] Pid: 19517, comm: kworker/0:2 Not tainted 2.6.38.1 #2                  /DP55KG
[69501.486085] RIP: 0010:[<ffffffff81228619>]  [<ffffffff81228619>] xfs_ail_splice+0x19/0x90
[69501.486091] RSP: 0018:ffff88011270fb78  EFLAGS: 00000202
[69501.486092] RAX: ffff88023705ced0 RBX: ffff88023715b000 RCX: ffff88017c841588
[69501.486093] RDX: 0000007d0039770e RSI: ffff88011270fbb0 RDI: 0000007d0039770f
[69501.486095] RBP: 0000000000000001 R08: 000000000000007d R09: ffff880418e1ab48
[69501.486096] R10: 000000000000007d R11: ffff88029da55058 R12: ffffffff814b578e
[69501.486097] R13: ffffffff810a123c R14: ffff88023715b000 R15: 0000000000000097
[69501.486099] FS:  0000000000000000(0000) GS:ffff8800df200000(0000) knlGS:0000000000000000
[69501.486101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[69501.486102] CR2: 00007f0da6832010 CR3: 00000003daac1000 CR4: 00000000000006f0
[69501.486103] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[69501.486104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[69501.486106] Process kworker/0:2 (pid: 19517, threadinfo ffff88011270e000, task ffff880414fa0e50)
[69501.486107] Stack:
[69501.486108]  ffffffff81228dbb 000000000000001b 00000001810a14b8 ffff880300000000
[69501.486111]  ffff88029157b1b0 ffff8803c6b9c150 0039770e00000003 ffff880101dcb228
[69501.486113]  ffff880101dcb228 0000000000000000 ffff880101dcb228 ffff88029dbf1cc0
[69501.486116] Call Trace:
[69501.486119]  [<ffffffff81228dbb>] ? xfs_trans_ail_update_bulk+0xdb/0x150
[69501.486122]  [<ffffffff81227fa6>] ? xfs_trans_committed_bulk+0xd6/0x200
[69501.486125]  [<ffffffff8121cbe4>] ? xlog_cil_committed+0x24/0xe0
[69501.486127]  [<ffffffff8121a63f>] ? xlog_state_do_callback+0x15f/0x2d0
[69501.486129]  [<ffffffff81231980>] ? xfs_buf_iodone_work+0x0/0x50
[69501.486133]  [<ffffffff81045e1b>] ? process_one_work+0xfb/0x370
[69501.486135]  [<ffffffff81047d2e>] ? worker_thread+0x15e/0x320
[69501.486138]  [<ffffffff810268c0>] ? __wake_up_common+0x50/0x80
[69501.486140]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69501.486142]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69501.486144]  [<ffffffff8104bbd6>] ? kthread+0x96/0xa0
[69501.486146]  [<ffffffff81002fd4>] ? kernel_thread_helper+0x4/0x10
[69501.486148]  [<ffffffff8104bb40>] ? kthread+0x0/0xa0
[69501.486150]  [<ffffffff81002fd0>] ? kernel_thread_helper+0x0/0x10
[69501.486151] Code: 0f 45 c2 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 4c 8d 4f 08 4c 3b 4f 08 74 66 49 89 d2 48 8b 47 10 49 c1 ea 20 48 8b 48 08 <49> 39 c1 0f 18 09 74 12 48 8b 78 10 49 89 f8 49 c1 e8 20 45 39
[69501.486167] Call Trace:
[69501.486169]  [<ffffffff81228dbb>] ? xfs_trans_ail_update_bulk+0xdb/0x150
[69501.486171]  [<ffffffff81227fa6>] ? xfs_trans_committed_bulk+0xd6/0x200
[69501.486174]  [<ffffffff8121cbe4>] ? xlog_cil_committed+0x24/0xe0
[69501.486175]  [<ffffffff8121a63f>] ? xlog_state_do_callback+0x15f/0x2d0
[69501.486177]  [<ffffffff81231980>] ? xfs_buf_iodone_work+0x0/0x50
[69501.486179]  [<ffffffff81045e1b>] ? process_one_work+0xfb/0x370
[69501.486181]  [<ffffffff81047d2e>] ? worker_thread+0x15e/0x320
[69501.486183]  [<ffffffff810268c0>] ? __wake_up_common+0x50/0x80
[69501.486185]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69501.486187]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69501.486189]  [<ffffffff8104bbd6>] ? kthread+0x96/0xa0
[69501.486191]  [<ffffffff81002fd4>] ? kernel_thread_helper+0x4/0x10
[69501.486192]  [<ffffffff8104bb40>] ? kthread+0x0/0xa0
[69501.486194]  [<ffffffff81002fd0>] ? kernel_thread_helper+0x0/0x10
[69585.468274] BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:2:19517]
[69585.468277] Modules linked in: tcp_diag inet_diag sata_mv
[69585.468280] CPU 0
[69585.468281] Modules linked in: tcp_diag inet_diag sata_mv
[69585.468283]
[69585.468285] Pid: 19517, comm: kworker/0:2 Not tainted 2.6.38.1 #2                  /DP55KG
[69585.468288] RIP: 0010:[<ffffffff81228619>]  [<ffffffff81228619>] xfs_ail_splice+0x19/0x90
[69585.468294] RSP: 0018:ffff88011270fb78  EFLAGS: 00000202
[69585.468295] RAX: ffff8800899559c0 RBX: ffff880279648000 RCX: ffff8800899558e8
[69585.468297] RDX: 0000007d0039770e RSI: ffff88011270fbb0 RDI: 0000007d0039770f
[69585.468298] RBP: 0000000000000001 R08: 000000000000007d R09: ffff880418e1ab48
[69585.468299] R10: 000000000000007d R11: ffff8802acabb9b8 R12: ffffffff814b578e
[69585.468301] R13: ffffffff810a123c R14: ffff880279648000 R15: 0000000000000097
[69585.468302] FS:  0000000000000000(0000) GS:ffff8800df200000(0000) knlGS:0000000000000000
[69585.468304] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[69585.468305] CR2: 00007f0da6832010 CR3: 00000003daac1000 CR4: 00000000000006f0
[69585.468306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[69585.468308] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[69585.468309] Process kworker/0:2 (pid: 19517, threadinfo ffff88011270e000, task ffff880414fa0e50)
[69585.468311] Stack:
[69585.468311]  ffffffff81228dbb 000000000000001b 00000001810a14b8 ffff880418e1ab40
[69585.468314]  ffff8800d7020170 ffff8803c6b9c150 0039770e00000003 ffff880032b59078
[69585.468317]  ffff880032b59078 0000000000000000 ffff880032b59078 ffff88016581bf40
[69585.468319] Call Trace:
[69585.468322]  [<ffffffff81228dbb>] ? xfs_trans_ail_update_bulk+0xdb/0x150
[69585.468325]  [<ffffffff81227fa6>] ? xfs_trans_committed_bulk+0xd6/0x200
[69585.468328]  [<ffffffff8121cbe4>] ? xlog_cil_committed+0x24/0xe0
[69585.468330]  [<ffffffff8121a63f>] ? xlog_state_do_callback+0x15f/0x2d0
[69585.468333]  [<ffffffff81231980>] ? xfs_buf_iodone_work+0x0/0x50
[69585.468336]  [<ffffffff81045e1b>] ? process_one_work+0xfb/0x370
[69585.468338]  [<ffffffff81047d2e>] ? worker_thread+0x15e/0x320
[69585.468341]  [<ffffffff810268c0>] ? __wake_up_common+0x50/0x80
[69585.468343]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69585.468345]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69585.468347]  [<ffffffff8104bbd6>] ? kthread+0x96/0xa0
[69585.468349]  [<ffffffff81002fd4>] ? kernel_thread_helper+0x4/0x10
[69585.468351]  [<ffffffff8104bb40>] ? kthread+0x0/0xa0
[69585.468353]  [<ffffffff81002fd0>] ? kernel_thread_helper+0x0/0x10
[69585.468354] Code: 0f 45 c2 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 4c 8d 4f 08 4c 3b 4f 08 74 66 49 89 d2 48 8b 47 10 49 c1 ea 20 48 8b 48 08 <49> 39 c1 0f 18 09 74 12 48 8b 78 10 49 89 f8 49 c1 e8 20 45 39
[69585.468370] Call Trace:
[69585.468372]  [<ffffffff81228dbb>] ? xfs_trans_ail_update_bulk+0xdb/0x150
[69585.468374]  [<ffffffff81227fa6>] ? xfs_trans_committed_bulk+0xd6/0x200
[69585.468376]  [<ffffffff8121cbe4>] ? xlog_cil_committed+0x24/0xe0
[69585.468378]  [<ffffffff8121a63f>] ? xlog_state_do_callback+0x15f/0x2d0
[69585.468380]  [<ffffffff81231980>] ? xfs_buf_iodone_work+0x0/0x50
[69585.468382]  [<ffffffff81045e1b>] ? process_one_work+0xfb/0x370
[69585.468384]  [<ffffffff81047d2e>] ? worker_thread+0x15e/0x320
[69585.468386]  [<ffffffff810268c0>] ? __wake_up_common+0x50/0x80
[69585.468388]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69585.468390]  [<ffffffff81047bd0>] ? worker_thread+0x0/0x320
[69585.468392]  [<ffffffff8104bbd6>] ? kthread+0x96/0xa0
[69585.468394]  [<ffffffff81002fd4>] ? kernel_thread_helper+0x4/0x10
[69585.468395]  [<ffffffff8104bb40>] ? kthread+0x0/0xa0
[69585.468397]  [<ffffffff81002fd0>] ? kernel_thread_helper+0x0/0x10
[69586.159176] INFO: task rm:21483 blocked for more than 120 seconds.
[69586.159179] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[69586.159180] rm              D ffff8803f4bce650     0 21483  21466 0x00000004
[69586.159183]  ffff8803f4bce650 0000000000000086 0000000000000000 0000000000000000
[69586.159186]  ffff88041fd71190 0000000000011280 ffff88033d69bfd8 0000000000011280
[69586.159189]  0000000000004000 0000000000004000 ffff8803f4bce8a8 ffff88033d69a000
[69586.159192] Call Trace:
[69586.159197]  [<ffffffff812307cc>] ? _xfs_buf_ioapply+0x16c/0x2d0
[69586.159200]  [<ffffffff8123202b>] ? xfs_buf_iorequest+0x3b/0x60
[69586.159202]  [<ffffffff8121907d>] ? xlog_bdstrat+0x1d/0x50
[69586.159204]  [<ffffffff81219a4e>] ? xlog_sync+0x1fe/0x390
[69586.159206]  [<ffffffff8121c1f6>] ? _xfs_log_force_lsn+0x296/0x2d0
[69586.159210]  [<ffffffff8102e080>] ? default_wake_function+0x0/0x20
[69586.159212]  [<ffffffff8122836d>] ? _xfs_trans_commit+0x29d/0x2b0
[69586.159215]  [<ffffffff8121263d>] ? xfs_itruncate_finish+0x18d/0x310
[69586.159217]  [<ffffffff8122bf45>] ? xfs_inactive+0x2e5/0x450
[69586.159220]  [<ffffffff81238492>] ? xfs_fs_evict_inode+0x82/0x90
[69586.159223]  [<ffffffff810bb4c7>] ? evict+0x17/0xa0
[69586.159224]  [<ffffffff810bbd43>] ? iput+0x1a3/0x270
[69586.159227]  [<ffffffff810b1895>] ? do_unlinkat+0x125/0x1c0
[69586.159230]  [<ffffffff8100227b>] ? system_call_fastpath+0x16/0x1b


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
